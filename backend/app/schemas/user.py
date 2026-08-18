from datetime import datetime
from typing import Optional

from .base import CamelModel


class UpsertUserProfileRequest(CamelModel):
    """회원가입/로그인 직후 프론트가 PUT /api/users/me로 보내는 값.
    docs/firestore_스키마.md의 users/{uid} 필드 중 클라이언트가 채우는 부분만 받는다 —
    created_at/updated_at은 서버가 채운다."""

    name: str
    visa_type: Optional[str] = None
    nationality: Optional[str] = None
    preferred_language: str = "ko"


class VaultUpdateRequest(CamelModel):
    """PATCH /api/users/me/vault — 사업주 공식 증빙 보관함(계약서/명세서)
    등록 여부 토글. 둘 다 optional이라 바꾸고 싶은 항목만 보내면 된다."""

    contract_stored: Optional[bool] = None
    payslip_stored: Optional[bool] = None


class UserProfile(CamelModel):
    """GET/PUT /api/users/me 응답. docs/firestore_스키마.md의 users/{uid} 스키마와
    필드를 맞춘다 — password는 애초에 저장하지 않으므로 여기도 없다."""

    user_id: str
    name: str
    email: Optional[str] = None
    visa_type: Optional[str] = None
    nationality: Optional[str] = None
    preferred_language: str = "ko"
    contract_stored: bool = False
    payslip_stored: bool = False
    onboarding_completed: bool = False
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None
