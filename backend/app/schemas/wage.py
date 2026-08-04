from datetime import date

from .base import CamelModel


class WageFacts(CamelModel):
    """1단계에서 입력받는 선택형·숫자·날짜 값만 담는다 — 원인 추정형 필드는 두지 않는다."""

    work_start_date: date
    last_work_date: date
    unpaid_amount: int
    agreed_monthly_salary: int
    has_contract: bool
    workplace_name: str


class WageClassifyResponse(CamelModel):
    payment_due_date: date
    days_overdue: int
    is_overdue: bool
    guidance: str
