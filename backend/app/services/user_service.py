"""Firestore users/{uid} 프로필 저장·조회.

history_service.py와 동일한 폴백 원칙: Firebase 자격증명이 없으면(로컬 개발, CI)
조용히 None/no-op으로 동작한다. 비밀번호는 Firebase Authentication이 전담하므로
여기서는 절대 다루지 않는다(docs/firestore_스키마.md 참고).
"""

import logging
from datetime import datetime, timezone
from typing import Optional

from ..core.firebase import get_firebase_app
from ..core.logging_utils import log_exception_summary
from ..schemas.user import UpsertUserProfileRequest, UserProfile

logger = logging.getLogger(__name__)

_COLLECTION = "users"


def _client():
    app = get_firebase_app()
    if app is None:
        return None
    from firebase_admin import firestore  # 앱 미초기화 시 임포트 비용을 피하기 위한 지연 임포트

    return firestore.client(app)


def upsert_user(uid: str, email: Optional[str], req: UpsertUserProfileRequest) -> Optional[UserProfile]:
    db = _client()
    if db is None:
        return None
    try:
        doc_ref = db.collection(_COLLECTION).document(uid)
        existing = doc_ref.get()
        now = datetime.now(timezone.utc)
        data = {
            "user_id": uid,
            "name": req.name,
            "email": email,
            "visa_type": req.visa_type,
            "nationality": req.nationality,
            "preferred_language": req.preferred_language,
            "updated_at": now,
        }
        if not existing.exists:
            data["created_at"] = now
            data["contract_stored"] = False
            data["payslip_stored"] = False
            data["onboarding_completed"] = False
        doc_ref.set(data, merge=True)
        return get_user(uid)
    except Exception as exc:
        log_exception_summary(logger, "사용자 프로필 저장 실패", exc)
        logger.exception("사용자 프로필 저장 실패 전체 트레이스백")
        return None


def update_vault_status(
    uid: str, *, contract_stored: Optional[bool], payslip_stored: Optional[bool]
) -> Optional[UserProfile]:
    db = _client()
    if db is None:
        return None
    try:
        doc_ref = db.collection(_COLLECTION).document(uid)
        if not doc_ref.get().exists:
            return None
        data = {"updated_at": datetime.now(timezone.utc)}
        if contract_stored is not None:
            data["contract_stored"] = contract_stored
        if payslip_stored is not None:
            data["payslip_stored"] = payslip_stored
        doc_ref.set(data, merge=True)
        return get_user(uid)
    except Exception as exc:
        log_exception_summary(logger, "보관함 상태 저장 실패", exc)
        logger.exception("보관함 상태 저장 실패 전체 트레이스백")
        return None


def get_user(uid: str) -> Optional[UserProfile]:
    db = _client()
    if db is None:
        return None
    try:
        doc = db.collection(_COLLECTION).document(uid).get()
        if not doc.exists:
            return None
        return UserProfile.model_validate(doc.to_dict())
    except Exception as exc:
        log_exception_summary(logger, "사용자 프로필 조회 실패", exc)
        logger.exception("사용자 프로필 조회 실패 전체 트레이스백")
        return None
