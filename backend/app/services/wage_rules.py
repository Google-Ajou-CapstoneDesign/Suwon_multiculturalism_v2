"""임금체불 규칙 엔진. 근로기준법 제36조(퇴직 후 14일 이내 금품 청산) 기준의
순수 if-then 분류만 수행한다 — LLM을 사용하지 않고, 분류 결과는 다음 단계의
안내문 선택에만 쓰인다(사용자에게 "위법입니다" 같은 단정 문장을 만들지 않는다).
"""

from datetime import date, timedelta
from typing import Optional

from ..core.time_utils import today_kst
from ..schemas.wage import WageClassifyResponse, WageFacts

_PAYMENT_DEADLINE_DAYS = 14

_GUIDANCE_OVERDUE = (
    "약정된 금액을 기한 내에 받지 못한 것으로 보여요. 관할 고용노동지청에 임금체불 진정을 제기할 수 있어요."
)
_GUIDANCE_WITHIN_DEADLINE = (
    "아직 법정 지급기한(퇴직 후 14일) 이내예요. 기한이 지나면 진정 제기가 가능하니 근무 기록을 계속 남겨두세요."
)
_GUIDANCE_NO_UNPAID = "미지급 금액이 입력되지 않았어요. 금액을 확인한 뒤 다시 시도해 주세요."


def classify(facts: WageFacts, *, today: Optional[date] = None) -> WageClassifyResponse:
    today = today or today_kst()
    payment_due_date = facts.last_work_date + timedelta(days=_PAYMENT_DEADLINE_DAYS)
    is_overdue = today > payment_due_date and facts.unpaid_amount > 0
    days_overdue = max((today - payment_due_date).days, 0)

    if facts.unpaid_amount <= 0:
        guidance = _GUIDANCE_NO_UNPAID
    elif is_overdue:
        guidance = _GUIDANCE_OVERDUE
    else:
        guidance = _GUIDANCE_WITHIN_DEADLINE

    return WageClassifyResponse(
        payment_due_date=payment_due_date,
        days_overdue=days_overdue,
        is_overdue=is_overdue,
        guidance=guidance,
    )
