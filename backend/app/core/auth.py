"""Firebase ID 토큰 검증 의존성.

Authorization: Bearer <Firebase ID Token> 헤더를 검증해 요청 사용자를 식별한다.
TODO(prod): AUTH_DEV_BYPASS는 로컬 개발 전용이다. HF Spaces Secrets에는 절대
이 값을 true로 등록하지 않는다 (미설정 시 기본값 false).
"""

import os
from dataclasses import dataclass
from typing import Optional

from fastapi import Header, HTTPException, status
from firebase_admin import auth as firebase_auth

from .firebase import get_firebase_app

_DEV_BYPASS = os.getenv("AUTH_DEV_BYPASS", "false").lower() == "true"


@dataclass
class CurrentUser:
    uid: str
    email: Optional[str] = None


async def get_current_user(authorization: Optional[str] = Header(default=None)) -> CurrentUser:
    app = get_firebase_app()

    if app is None:
        if _DEV_BYPASS:
            return CurrentUser(uid="dev-user")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Firebase 자격증명이 설정되지 않았습니다.",
        )

    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="인증 토큰이 필요합니다.")

    token = authorization.removeprefix("Bearer ").strip()
    try:
        decoded = firebase_auth.verify_id_token(token, app=app)
    except Exception as exc:  # firebase_admin은 다양한 예외 타입을 던진다
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="유효하지 않은 토큰입니다.") from exc

    return CurrentUser(uid=decoded["uid"], email=decoded.get("email"))


async def get_optional_user(authorization: Optional[str] = Header(default=None)) -> Optional[CurrentUser]:
    if not authorization:
        return None
    try:
        return await get_current_user(authorization=authorization)
    except HTTPException:
        return None
