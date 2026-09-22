from datetime import date

from fastapi import APIRouter, Depends, HTTPException, status

from ..core.auth import CurrentUser, get_current_user
from ..schemas.worklog import WorklogDay, WorklogDayUpsert, WorklogMonthResponse
from ..services import worklog_service

router = APIRouter(prefix="/api/worklog", tags=["worklog"])


@router.get("/days", response_model=WorklogMonthResponse)
def list_days(
    year: int, month: int, user: CurrentUser = Depends(get_current_user)
) -> WorklogMonthResponse:
    if not 1 <= month <= 12:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, detail="month는 1~12 사이여야 합니다."
        )
    if not 1 <= year <= 9998:
        raise HTTPException(status_code=400, detail="year는 1~9998 사이여야 합니다.")
    try:
        return WorklogMonthResponse(days=worklog_service.list_month(user.uid, year, month))
    except worklog_service.WorklogReadError as exc:
        raise HTTPException(
            status_code=503, detail="근무기록을 불러올 수 없습니다. 잠시 후 다시 시도하세요."
        ) from exc


@router.put("/days/{day}", response_model=WorklogDay)
def upsert_day(
    day: date, patch: WorklogDayUpsert, user: CurrentUser = Depends(get_current_user)
) -> WorklogDay:
    record = worklog_service.upsert_day(user.uid, day, patch)
    if record is None:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Firestore가 설정되지 않아 근무기록을 저장할 수 없습니다.",
        )
    return record
