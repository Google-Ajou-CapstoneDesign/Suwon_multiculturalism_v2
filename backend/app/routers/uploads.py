from datetime import date
from typing import List, Optional

from fastapi import APIRouter, Depends, File, HTTPException, UploadFile, status

from ..core.auth import CurrentUser, get_current_user
from ..schemas.upload import EvidenceFileMeta, UploadResponse
from ..services import evidence_service, worklog_service
from ..services.storage_service import StorageNotConfiguredError, save_evidence_file

router = APIRouter(prefix="/api/uploads", tags=["uploads"])


@router.post("", response_model=UploadResponse)
async def upload_evidence(
    case_type: str,
    file: UploadFile = File(...),
    worklog_date: Optional[date] = None,
    user: CurrentUser = Depends(get_current_user),
) -> UploadResponse:
    """증빙파일을 Storage에 올리고 Firestore에 메타데이터를 남긴다.
    worklog_date를 함께 보내면(예: 근무기록장에서 그날 사진을 첨부하는 경우)
    해당 날짜의 worklogs 문서에도 파일을 연결한다."""
    try:
        result = await save_evidence_file(file, uid=user.uid, case_type=case_type)
    except StorageNotConfiguredError as exc:
        raise HTTPException(status_code=status.HTTP_503_SERVICE_UNAVAILABLE, detail=str(exc)) from exc

    linked_worklog_id = worklog_service.doc_id(user.uid, worklog_date) if worklog_date else None
    evidence_service.record_evidence_file(
        user.uid,
        case_type=case_type,
        worklog_id=linked_worklog_id,
        **result,
    )
    if worklog_date is not None:
        worklog_service.append_evidence_file(user.uid, worklog_date, result["file_id"])
    return UploadResponse(**result)


@router.get("", response_model=List[EvidenceFileMeta])
def list_uploads(
    worklog_date: Optional[date] = None, user: CurrentUser = Depends(get_current_user)
) -> List[EvidenceFileMeta]:
    linked_worklog_id = worklog_service.doc_id(user.uid, worklog_date) if worklog_date else None
    return evidence_service.list_files(user.uid, worklog_id=linked_worklog_id)
