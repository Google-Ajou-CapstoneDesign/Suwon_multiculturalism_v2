"""Firestore evidence_files/{fileId} 증빙파일 메타데이터 저장·조회.

storage_service.save_evidence_file()은 Firebase Storage에 파일을 올리기만
하고 메타데이터는 어디에도 남기지 않았다 — 이 모듈이 그 메타데이터를
evidence_files 컬렉션에 기록해, "이 사용자가 어떤 파일을 올렸는지"를 나중에
조회할 수 있게 한다. user_service.py와 동일한 폴백 원칙을 따른다.
"""

import logging
from datetime import datetime, timezone
from typing import List, Optional

from ..core.firebase import get_firebase_app
from ..core.logging_utils import log_exception_summary
from ..schemas.upload import EvidenceFileMeta

logger = logging.getLogger(__name__)

_COLLECTION = "evidence_files"


def _client():
    app = get_firebase_app()
    if app is None:
        return None
    from firebase_admin import firestore  # 앱 미초기화 시 임포트 비용을 피하기 위한 지연 임포트

    return firestore.client(app)


def record_evidence_file(
    uid: str,
    *,
    file_id: str,
    case_type: str,
    stored_path: str,
    content_type: str,
    size_bytes: int,
    worklog_id: Optional[str] = None,
) -> None:
    db = _client()
    if db is None:
        return
    try:
        db.collection(_COLLECTION).document(file_id).set(
            {
                "file_id": file_id,
                "user_id": uid,
                "case_type": case_type,
                "stored_path": stored_path,
                "content_type": content_type,
                "size_bytes": size_bytes,
                "worklog_id": worklog_id,
                "uploaded_at": datetime.now(timezone.utc),
            }
        )
    except Exception as exc:
        log_exception_summary(logger, "증빙파일 메타데이터 저장 실패 — 업로드 자체는 완료됐습니다.", exc)
        logger.exception("증빙파일 메타데이터 저장 실패 전체 트레이스백")


def list_files(uid: str, *, worklog_id: Optional[str] = None) -> List[EvidenceFileMeta]:
    db = _client()
    if db is None:
        return []
    try:
        query = db.collection(_COLLECTION).where("user_id", "==", uid)
        if worklog_id is not None:
            query = query.where("worklog_id", "==", worklog_id)
        return [EvidenceFileMeta.model_validate(doc.to_dict()) for doc in query.stream()]
    except Exception as exc:
        log_exception_summary(logger, "증빙파일 목록 조회 실패", exc)
        logger.exception("증빙파일 목록 조회 전체 트레이스백")
        return []
