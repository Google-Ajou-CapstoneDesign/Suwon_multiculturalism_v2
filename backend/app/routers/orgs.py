from typing import List, Optional

from fastapi import APIRouter, Query

from ..schemas.org import Org
from ..services import org_service

router = APIRouter(prefix="/api/orgs", tags=["orgs"])


@router.get("", response_model=List[Org])
def get_orgs(
    lat: Optional[float] = Query(default=None),
    lng: Optional[float] = Query(default=None),
    category: Optional[str] = Query(default=None, description="wage | accident | general"),
) -> List[Org]:
    return org_service.list_orgs(lat=lat, lng=lng, category=category)
