from fastapi import APIRouter, Depends, File, HTTPException, UploadFile, status

from ..core.auth import CurrentUser, get_current_user
from ..schemas.upload import UploadResponse
from ..services.storage_service import StorageNotConfiguredError, save_evidence_file

router = APIRouter(prefix="/api/uploads", tags=["uploads"])


@router.post("", response_model=UploadResponse)
async def upload_evidence(
    case_type: str,
    file: UploadFile = File(...),
    user: CurrentUser = Depends(get_current_user),
) -> UploadResponse:
    try:
        result = await save_evidence_file(file, uid=user.uid, case_type=case_type)
    except StorageNotConfiguredError as exc:
        raise HTTPException(status_code=status.HTTP_503_SERVICE_UNAVAILABLE, detail=str(exc)) from exc
    return UploadResponse(**result)
