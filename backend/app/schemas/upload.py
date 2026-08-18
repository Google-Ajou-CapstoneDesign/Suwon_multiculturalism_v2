from datetime import datetime
from typing import Optional

from .base import CamelModel


class UploadResponse(CamelModel):
    file_id: str
    stored_path: str
    content_type: str
    size_bytes: int


class EvidenceFileMeta(CamelModel):
    """evidence_files/{fileId} 문서. storage_service.save_evidence_file()이
    올린 파일의 메타데이터 — 업로드 자체와 별개로 "이 사용자가 어떤 파일을
    올렸는지" 나중에 조회할 수 있게 Firestore에 남겨둔다."""

    file_id: str
    user_id: str
    case_type: str
    stored_path: str
    content_type: str
    size_bytes: int
    worklog_id: Optional[str] = None
    uploaded_at: Optional[datetime] = None
