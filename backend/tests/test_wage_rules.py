from datetime import date

from app.schemas.wage import WageFacts
from app.services import wage_rules


def _facts(**overrides) -> WageFacts:
    base = dict(
        work_start_date=date(2026, 3, 1),
        last_work_date=date(2026, 7, 20),
        unpaid_amount=500_000,
        agreed_monthly_salary=2_000_000,
        has_contract=True,
        workplace_name="OO식당",
    )
    base.update(overrides)
    return WageFacts(**base)


def test_overdue_when_past_14_day_deadline():
    facts = _facts(last_work_date=date(2026, 7, 1))
    result = wage_rules.classify(facts, today=date(2026, 7, 20))

    assert result.payment_due_date == date(2026, 7, 15)
    assert result.is_overdue is True
    assert result.days_overdue == 5


def test_not_overdue_within_14_day_deadline():
    facts = _facts(last_work_date=date(2026, 7, 15))
    result = wage_rules.classify(facts, today=date(2026, 7, 20))

    assert result.payment_due_date == date(2026, 7, 29)
    assert result.is_overdue is False
    assert result.days_overdue == 0


def test_no_unpaid_amount_short_circuits_overdue():
    facts = _facts(last_work_date=date(2026, 1, 1), unpaid_amount=0)
    result = wage_rules.classify(facts, today=date(2026, 12, 31))

    assert result.is_overdue is False
    assert "미지급 금액이 입력되지 않았습니다." in result.guidance
