from fastapi import APIRouter, Depends, HTTPException, status

from ..core.auth import CurrentUser, get_current_user
from ..schemas.user import UpsertUserProfileRequest, UserProfile, VaultUpdateRequest
from ..services import user_service

router = APIRouter(prefix="/api/users", tags=["users"])


@router.put("/me", response_model=UserProfile)
def upsert_my_profile(
    request: UpsertUserProfileRequest, user: CurrentUser = Depends(get_current_user)
) -> UserProfile:
    profile = user_service.upsert_user(user.uid, user.email, request)
    if profile is None:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Firestore가 설정되지 않아 프로필을 저장할 수 없습니다.",
        )
    return profile


@router.get("/me", response_model=UserProfile)
def get_my_profile(user: CurrentUser = Depends(get_current_user)) -> UserProfile:
    profile = user_service.get_user(user.uid)
    if profile is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="프로필이 없습니다.")
    return profile


@router.patch("/me/vault", response_model=UserProfile)
def update_vault_status(
    request: VaultUpdateRequest, user: CurrentUser = Depends(get_current_user)
) -> UserProfile:
    profile = user_service.update_vault_status(
        user.uid,
        contract_stored=request.contract_stored,
        payslip_stored=request.payslip_stored,
    )
    if profile is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="프로필이 없거나 Firestore가 설정되지 않았습니다.",
        )
    return profile
