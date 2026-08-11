"""Firestore 기반 사용자 상담 이력 저장·조회 (P1).

README의 P0 범위("Firestore 연동 없이 스테이트리스")를 확장한다. Firebase
자격증명이 없으면(로컬 개발, CI) 조용히 빈 값/no-op으로 동작한다 —
core.firebase.get_firebase_app()과 동일한 폴백 원칙이며, 이력 저장 실패가
챗봇 응답 자체를 막아서는 안 된다.
"""

import logging
from datetime import datetime, timezone
from typing import List, Optional

from ..core.firebase import get_firebase_app

logger = logging.getLogger(__name__)

_COLLECTION = "chat_history"


def _client():
    app = get_firebase_app()
    if app is None:
        return None
    from firebase_admin import firestore  # 앱 미초기화 시 임포트 비용을 피하기 위한 지연 임포트

    return firestore.client(app)


def save_turn(uid: str, message: str, response_text: Optional[str]) -> None:
    db = _client()
    if db is None:
        return
    try:
        db.collection(_COLLECTION).document(uid).collection("turns").add(
            {
                "message": message,
                "response": response_text,
                "created_at": datetime.now(timezone.utc),
            }
        )
    except Exception:
        logger.exception("상담 이력 저장 실패 — 응답 자체에는 영향을 주지 않습니다.")


def get_recent_history(uid: str, *, limit: int = 5) -> List[dict]:
    db = _client()
    if db is None:
        return []
    try:
        from firebase_admin import firestore

        docs = (
            db.collection(_COLLECTION)
            .document(uid)
            .collection("turns")
            .order_by("created_at", direction=firestore.Query.DESCENDING)
            .limit(limit)
            .stream()
        )
        return [doc.to_dict() for doc in docs]
    except Exception:
        logger.exception("상담 이력 조회 실패 — 빈 이력으로 진행합니다.")
        return []
