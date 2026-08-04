"""챗봇 라이트 라우팅.

google-genai(Gemini)는 사용자 문장의 '의도 분류'에만 쓴다 — 절대로 안내 문구
자체를 생성하지 않는다. 실제로 사용자에게 나가는 factAnswer/riskNotice는 전부
_CONTENT에 미리 검수해 둔 정적 문구뿐이다(법률 환각 방지 원칙).

genai 클라이언트가 설정되지 않았거나(로컬 개발, CI) 호출이 실패하면 키워드
매칭 규칙으로 폴백해, 자격증명 없이도 항상 응답할 수 있게 한다.
"""

import logging
from typing import Dict, List, Literal, Optional, TypedDict

from google.genai import types
from pydantic import BaseModel

from ..core.genai_client import get_genai_client, get_model_name
from ..schemas.chat import ChatRequest, ChatResponse, RoutingTarget
from ..schemas.org import Org
from .org_service import DEFAULT_ORGS

logger = logging.getLogger(__name__)

Intent = Literal["wage", "accident", "contract", "other"]


class IntentClassification(BaseModel):
    """genai structured output 스키마. 분류값만 받고 다른 자유 텍스트는 받지 않는다."""

    intent: Intent


class _ContentEntry(TypedDict):
    keywords: List[str]
    fact_answer: Optional[str]
    risk_notice: Optional[str]
    routing_target: Optional[RoutingTarget]


_FALLBACK_RISK_NOTICE = (
    "검수된 정보가 아직 없는 질문이에요. 백과사전 탭에서 관련 정보를 찾아보시거나, 아래 기관에 직접 문의해 보세요."
)

_CONTENT: Dict[Intent, _ContentEntry] = {
    "wage": {
        "keywords": ["임금", "체불", "월급", "급여"],
        "fact_answer": (
            "근로기준법상 사용자는 퇴직·지급일로부터 14일 이내에 임금을 지급해야 해요. "
            "이미 기간이 지났다면 진정 제기가 가능해요."
        ),
        "risk_notice": (
            "즉시 대응이 필요한 사안으로 보여요. 정확한 판단은 AI가 아닌 아래 네비게이터·전문가를 통해 확인해 주세요."
        ),
        "routing_target": RoutingTarget(module="module3-wage"),
    },
    "accident": {
        "keywords": ["산재", "다쳤", "부상", "사고"],
        "fact_answer": "업무 중 다쳤다면 산재보험으로 치료비를 처리할 수 있어요. 사업주의 공상 처리 요구는 거절할 수 있어요.",
        "risk_notice": "사고 사실관계 정리가 필요해 보여요. 산재 대응 네비게이터에서 증빙을 정리해 드릴게요.",
        "routing_target": RoutingTarget(module="module3-accident"),
    },
    "contract": {
        "keywords": ["계약서", "근로계약"],
        "fact_answer": (
            "근로계약서에는 임금·근무시간·휴게시간 등 11개 필수 확인 항목이 있어요. "
            "백과사전 탭의 체크리스트에서 확인할 수 있어요."
        ),
        "risk_notice": None,
        "routing_target": RoutingTarget(module="module1", category_id="contract_check"),
    },
    "other": {
        "keywords": [],
        "fact_answer": None,
        "risk_notice": _FALLBACK_RISK_NOTICE,
        "routing_target": None,
    },
}

_SYSTEM_INSTRUCTION = (
    "너는 이주노동자 지원 서비스의 질문 분류기다. 사용자 문장을 아래 네 가지 중 "
    "하나로만 분류해라: wage(임금·급여 미지급), accident(산업재해·사고·부상), "
    "contract(근로계약서 관련), other(그 외 전부). 분류값 외에 설명·조언·새로운 "
    "문장을 절대 만들지 마라."
)


def _classify_with_genai(message: str) -> Optional[Intent]:
    client = get_genai_client()
    if client is None:
        return None
    try:
        response = client.models.generate_content(
            model=get_model_name(),
            contents=message,
            config=types.GenerateContentConfig(
                system_instruction=_SYSTEM_INSTRUCTION,
                response_mime_type="application/json",
                response_schema=IntentClassification,
                temperature=0,
            ),
        )
        parsed = response.parsed
        if not isinstance(parsed, IntentClassification):
            return None
        return parsed.intent
    except Exception:
        logger.exception("genai 의도 분류 실패 — 키워드 규칙으로 폴백합니다.")
        return None


def _classify_with_keywords(message: str) -> Intent:
    for intent, content in _CONTENT.items():
        if intent == "other":
            continue
        if any(keyword in message for keyword in content["keywords"]):
            return intent
    return "other"


def answer(request: ChatRequest) -> ChatResponse:
    intent = _classify_with_genai(request.message) or _classify_with_keywords(request.message)
    content = _CONTENT[intent]

    orgs: List[Org] = DEFAULT_ORGS[:2] if intent != "other" else DEFAULT_ORGS[:1]
    return ChatResponse(
        fact_answer=content["fact_answer"],
        risk_notice=content["risk_notice"],
        routing_target=content["routing_target"],
        recommended_orgs=orgs,
    )
