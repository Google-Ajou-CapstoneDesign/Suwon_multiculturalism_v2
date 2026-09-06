from datetime import date
from typing import List, Optional

from pydantic import Field

from .base import CamelModel

_TIME_PATTERN = r"^([01]\d|2[0-3]):[0-5]\d$"


class WorklogDayUpsert(CamelModel):
    """PUT /api/worklog/days/{date}로 받는 하루치 근무기록 수정 요청.

    is_overtime은 클라이언트가 보내지 않는다 — worklog_service가 clock_in/
    clock_out/break_minutes로부터 결정론적으로 계산한다(직접 암산·자유
    판단 금지 원칙, wage_rules.classify와 동일). is_risk도 아직 이
    필드 하나로 판정할 근거(체불 여부는 임금 정보가 있어야 계산 가능)가
    없어 항상 서버 기본값(false)만 쓴다 — 나중에 wage_rules와 연동할 자리다.
    """

    clock_in: Optional[str] = Field(default=None, pattern=_TIME_PATTERN)
    clock_out: Optional[str] = Field(default=None, pattern=_TIME_PATTERN)
    break_minutes: int = 0
    memo: str = ""
    gps_verified: bool = False
    # /api/location/verify가 이미 좌표를 받아 그대로 돌려주고 있다 — 그 값을
    # 프론트가 여기 실어 보내면(위치 인증 성공 시에만) 근무기록에 근거 좌표로
    # 같이 남긴다. docs/firestore_스키마.md §2에서 제안했던 필드.
    verified_latitude: Optional[float] = Field(default=None, ge=-90, le=90)
    verified_longitude: Optional[float] = Field(default=None, ge=-180, le=180)
    # /api/location/verify가 역지오코딩으로 이미 변환해 돌려준 주소 문자열을
    # 그대로 실어 보낸다 — 좌표만 저장하면 화면에 다시 띄울 때마다 매번
    # 재지오코딩해야 해서 비효율적이고, 인증 시점의 표시값을 그대로 남겨두는
    # 편이 나중에 봐도 그때 무슨 주소로 인증됐는지 정확히 알 수 있다.
    verified_address: Optional[str] = None


class WorklogDay(CamelModel):
    """GET/PUT 응답. docs/firestore_스키마.md의 worklogs/{worklogId}를 반영한다."""

    worklog_id: str
    user_id: str
    date: date
    clock_in: Optional[str] = None
    clock_out: Optional[str] = None
    break_minutes: int = 0
    memo: str = ""
    is_overtime: bool = False
    is_risk: bool = False
    gps_verified: bool = False
    verified_latitude: Optional[float] = None
    verified_longitude: Optional[float] = None
    verified_address: Optional[str] = None
    evidence_file_ids: List[str] = []


class WorklogMonthResponse(CamelModel):
    days: List[WorklogDay] = []
