from typing import List, Optional

from fastapi import APIRouter, Query

from ..schemas.org import Org
from ..services import org_service

router = APIRouter(prefix="/api/orgs", tags=["orgs"])


@router.get("", response_model=List[Org])
def get_orgs(
    lat: Optional[float] = Query(default=None),
    lng: Optional[float] = Query(default=None),
    category: Optional[str] = Query(
        default=None,
        description=(
            "기관의 '추천 대상' 설명에 포함된 키워드로 단순 필터링(예: '임금', '산재'). "
            "의미 기반 매칭이 필요하면 이 엔드포인트 대신 에이전트의 search_support_orgs "
            "도구(situation 파라미터)를 쓴다."
        ),
    ),
) -> List[Org]:
    return org_service.list_orgs(lat=lat, lng=lng, category=category)
