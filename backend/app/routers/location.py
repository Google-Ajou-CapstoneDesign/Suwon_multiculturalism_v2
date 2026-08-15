from typing import Optional

from fastapi import APIRouter, Depends

from ..core.auth import CurrentUser, get_optional_user
from ..schemas.location import LocationVerifyRequest, LocationVerifyResponse
from ..services import location_service

router = APIRouter(prefix="/api/location", tags=["location"])


@router.post("/verify", response_model=LocationVerifyResponse)
async def verify_location(
    payload: LocationVerifyRequest,
    _user: Optional[CurrentUser] = Depends(get_optional_user),
) -> LocationVerifyResponse:
    return location_service.verify_location(payload)
