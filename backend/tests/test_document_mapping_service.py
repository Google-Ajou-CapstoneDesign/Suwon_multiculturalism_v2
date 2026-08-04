from datetime import date

from app.schemas.document_mapping import ClaimantInfo, WageMappingRequest
from app.schemas.wage import WageFacts
from app.services import document_mapping_service


def test_wage_mapping_separates_fact_narrative_and_blocked_fields():
    request = WageMappingRequest(
        claimant=ClaimantInfo(name="홍○○"),
        facts=WageFacts(
            work_start_date=date(2026, 3, 1),
            last_work_date=date(2026, 7, 20),
            unpaid_amount=500_000,
            agreed_monthly_salary=2_000_000,
            has_contract=True,
            workplace_name="OO식당",
        ),
        narrative="3월 1일부터 7월 20일까지 근무했는데 7월 급여 50만원을 아직 받지 못했습니다.",
    )

    result = document_mapping_service.build_wage_mapping(request)
    by_label = {row.label: row for row in result.rows}

    assert by_label["성명"].status == "auto"
    assert by_label["성명"].value == "홍○○"
    assert by_label["미지급액"].value == "500,000원"

    assert by_label["진정 취지 및 경위"].status == "verbatim"
    assert by_label["진정 취지 및 경위"].value == request.narrative

    blocked = by_label["통상임금·시간외수당 등"]
    assert blocked.status == "blocked"
    assert blocked.value is None
    assert blocked.notice
