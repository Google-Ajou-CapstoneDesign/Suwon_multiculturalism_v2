"""위치·상황 기반 기관 조회.

Firestore `organizations` 컬렉션을 조회하고, 자격증명이 없거나 컬렉션이
비어 있으면 app/data/organizations.json(로컬 지오코딩 결과, scripts/
geocode_organizations.py 산출물)으로 폴백한다 — core.firebase.get_firebase_app()/
core.genai_client.get_genai_client()와 동일한 "설정 없으면 조용히 폴백" 원칙.

두 가지 조회 방식을 분리해뒀다:
- list_orgs(): GET /api/orgs가 쓰는 단순 조회. LLM 없이 category를
  "추천 대상" 텍스트 포함 여부로만 거른다.
- find_relevant_orgs(): 에이전트의 search_support_orgs 도구가 쓰는 조회.
  situation(자연어)으로 genai가 "추천 대상"과 대조해 관련 기관을 골라준다
  (미설정/실패 시 키워드 매칭으로 폴백).

기관이 32건뿐이라(2026-08 기준) 전체를 프로세스 생애 동안 메모리에 캐싱해도
충분하다 — 별도 벡터 DB·페이지네이션이 필요 없는 규모다.
"""

import json
import logging
import math
import re
from functools import lru_cache
from pathlib import Path
from typing import Any, Dict, List, Optional

from google.genai import types
from pydantic import BaseModel

from ..core.firebase import get_firebase_app
from ..core.genai_client import get_genai_client, get_model_name
from ..core.logging_utils import log_exception_summary
from ..schemas.org import Org

logger = logging.getLogger(__name__)

_FALLBACK_PATH = Path(__file__).resolve().parent.parent / "data" / "organizations.json"
_FIRESTORE_COLLECTION = "organizations"

# 사용자 위치는 알지만 기관 좌표가 없는 경우(예: 오프라인 주소가 없는 콜센터) —
# 실제 거리로 오인하지 않도록 뒤로 밀어내는 정렬용 큰 값.
_NO_COORDS_DISTANCE_KM = 999.0


def _read_fallback_orgs() -> List[Dict[str, Any]]:
    return json.loads(_FALLBACK_PATH.read_text(encoding="utf-8"))


# GET /api/orgs 등 "위치 정보 없음" 상태에서 쓰는 정적 기본 목록 — Firestore
# 연동 여부와 무관하게 항상 같은 로컬 데이터로 만든다(과거 orgs.json 5건과
# 동일한 역할, 지금은 32건).
DEFAULT_ORGS: List[Org] = [
    Org(name=o["name"], distance_km=0.0) for o in _read_fallback_orgs()
]


@lru_cache
def _load_all_orgs() -> List[Dict[str, Any]]:
    """Firestore를 먼저 시도하고, 안 되면 로컬 폴백을 쓴다. 프로세스 생애 동안
    한 번만 로드한다 — 관리자가 기관 정보를 바꾸면 재배포(또는 재시작)해야
    반영된다(32건 규모에서는 합리적인 트레이드오프)."""
    app = get_firebase_app()
    if app is not None:
        try:
            from firebase_admin import firestore

            db = firestore.client(app)
            docs = (
                db.collection(_FIRESTORE_COLLECTION)
                .where("is_active", "==", True)
                .stream()
            )
            orgs = [d.to_dict() for d in docs]
            if orgs:
                return orgs
        except Exception as exc:
            log_exception_summary(logger, "Firestore organizations 조회 실패 — 로컬 폴백을 사용합니다.", exc)
            logger.exception("Firestore organizations 조회 실패 전체 트레이스백")

    return _read_fallback_orgs()


def _haversine_km(lat1: float, lng1: float, lat2: float, lng2: float) -> float:
    r = 6371.0
    phi1, phi2 = math.radians(lat1), math.radians(lat2)
    d_phi = math.radians(lat2 - lat1)
    d_lambda = math.radians(lng2 - lng1)
    a = math.sin(d_phi / 2) ** 2 + math.cos(phi1) * math.cos(phi2) * math.sin(d_lambda / 2) ** 2
    return 2 * r * math.asin(math.sqrt(a))


def _distance_km(lat: Optional[float], lng: Optional[float], org: Dict[str, Any]) -> float:
    if lat is None or lng is None:
        return 0.0
    org_lat, org_lng = org.get("latitude"), org.get("longitude")
    if org_lat is None or org_lng is None:
        return _NO_COORDS_DISTANCE_KM
    return round(_haversine_km(lat, lng, org_lat, org_lng), 1)


def list_orgs(
    lat: Optional[float] = None,
    lng: Optional[float] = None,
    category: Optional[str] = None,
) -> List[Org]:
    """GET /api/orgs가 쓰는 단순 조회 — LLM 재순위화 없이 category를 "추천 대상"
    텍스트에 대한 단순 포함 검색으로만 거른다."""
    orgs = _load_all_orgs()
    if category:
        orgs = [o for o in orgs if category in o.get("recommended_for", "")]

    scored = [
        Org(name=o["name"], distance_km=_distance_km(lat, lng, o)) for o in orgs
    ]
    if lat is not None and lng is not None:
        scored.sort(key=lambda org: org.distance_km)
    return scored


class _RelevantOrgNames(BaseModel):
    """genai structured output 스키마 — 관련 기관 이름만 관련도 순으로 받는다."""

    org_names: List[str]


def _rerank_with_keywords(
    situation: str, orgs: List[Dict[str, Any]], limit: int
) -> List[Dict[str, Any]]:
    if not situation:
        return orgs[:limit]
    tokens = [t for t in re.split(r"[\s,·/()]+", situation) if len(t) >= 2]
    scored = []
    for o in orgs:
        haystack = f"{o.get('recommended_for', '')} {o.get('description', '')}"
        score = sum(1 for t in tokens if t in haystack)
        if score > 0:
            scored.append((score, o))
    scored.sort(key=lambda pair: pair[0], reverse=True)
    picked = [o for _, o in scored[:limit]]
    return picked or orgs[:limit]


def _rerank_with_genai(
    situation: str, orgs: List[Dict[str, Any]], limit: int
) -> List[Dict[str, Any]]:
    """situation과 각 기관의 "추천 대상"을 genai로 대조해 관련도 높은 순으로
    최대 limit개를 고른다. genai 미설정/호출 실패 시 키워드 매칭으로 폴백한다
    (chat_service._classify_with_genai와 동일한 이중 경로 패턴)."""
    if not situation:
        return orgs[:limit]

    client = get_genai_client()
    if client is None:
        return _rerank_with_keywords(situation, orgs, limit)

    candidates = "\n".join(
        f"- {o['name']}: {o.get('recommended_for', '')}" for o in orgs
    )
    prompt = (
        f"사용자 상황: {situation}\n\n"
        f"아래는 기관 목록이다(이름: 추천 대상). 이 상황에 실제로 도움이 될 "
        f"기관을 관련도 높은 순으로 최대 {limit}개 골라 이름을 목록 표기 그대로 "
        f"반환하라. 명확히 관련된 기관이 없으면 빈 목록을 반환하라.\n\n{candidates}"
    )
    try:
        response = client.models.generate_content(
            model=get_model_name(),
            contents=prompt,
            config=types.GenerateContentConfig(
                response_mime_type="application/json",
                response_schema=_RelevantOrgNames,
                temperature=0,
            ),
        )
        parsed = response.parsed
        if not isinstance(parsed, _RelevantOrgNames):
            return _rerank_with_keywords(situation, orgs, limit)
        by_name = {o["name"]: o for o in orgs}
        picked = [by_name[n] for n in parsed.org_names if n in by_name]
        return picked[:limit] if picked else _rerank_with_keywords(situation, orgs, limit)
    except Exception as exc:
        log_exception_summary(logger, "기관 재순위화(LLM) 실패 — 키워드 매칭으로 폴백합니다.", exc)
        logger.exception("기관 재순위화 실패 전체 트레이스백")
        return _rerank_with_keywords(situation, orgs, limit)


def find_relevant_orgs(
    situation: str = "",
    lat: Optional[float] = None,
    lng: Optional[float] = None,
    limit: int = 3,
) -> List[Dict[str, Any]]:
    """agent.tools.search_support_orgs가 쓰는 핵심 함수.

    situation(자연어)으로 관련 기관을 추리고, 사용자 위치가 있으면 거리
    오름차순으로 정렬한다. 에이전트가 답변에 바로 인용할 수 있도록 기관의
    모든 필드(설명·전화번호·주소·이용시간 등)를 그대로 담은 dict를 반환한다
    — Org(name/distanceKm만 있는 API 응답 스키마)로 좁히는 건 호출부 책임이다.
    """
    orgs = _load_all_orgs()
    picked = _rerank_with_genai(situation, orgs, limit)

    result = []
    for o in picked:
        item = dict(o)
        item["distance_km"] = _distance_km(lat, lng, o)
        result.append(item)

    if lat is not None and lng is not None:
        result.sort(key=lambda o: o["distance_km"])
    return result
