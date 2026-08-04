"""위치 기반 기관 라우팅. P0는 고정 목록(app/data/orgs.json)만 사용한다.
TODO(backend/P1): 공공데이터(체불사업주 명단, 산재보험 가입 여부) 연동, 더 넓은 기관 커버리지.
"""

import json
import math
from pathlib import Path
from typing import List, Optional

from ..schemas.org import Org

_DATA_PATH = Path(__file__).resolve().parent.parent / "data" / "orgs.json"
_RAW_ORGS = json.loads(_DATA_PATH.read_text(encoding="utf-8"))

# 위치 정보가 없을 때(권한 거부 등) 쓰는 기본 노출 순서.
DEFAULT_ORGS: List[Org] = [Org(name=o["name"], distance_km=0.0) for o in _RAW_ORGS]


def _haversine_km(lat1: float, lng1: float, lat2: float, lng2: float) -> float:
    r = 6371.0
    phi1, phi2 = math.radians(lat1), math.radians(lat2)
    d_phi = math.radians(lat2 - lat1)
    d_lambda = math.radians(lng2 - lng1)
    a = math.sin(d_phi / 2) ** 2 + math.cos(phi1) * math.cos(phi2) * math.sin(d_lambda / 2) ** 2
    return 2 * r * math.asin(math.sqrt(a))


def list_orgs(
    lat: Optional[float] = None,
    lng: Optional[float] = None,
    category: Optional[str] = None,
) -> List[Org]:
    orgs = _RAW_ORGS
    if category:
        orgs = [o for o in orgs if category in o.get("categories", [])]

    if lat is None or lng is None:
        return [Org(name=o["name"], distance_km=0.0) for o in orgs]

    scored = [
        Org(name=o["name"], distance_km=round(_haversine_km(lat, lng, o["lat"], o["lng"]), 1))
        for o in orgs
    ]
    return sorted(scored, key=lambda org: org.distance_km)
