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
    evidence_file_ids: List[str] = []


class WorklogMonthResponse(CamelModel):
    days: List[WorklogDay] = []
