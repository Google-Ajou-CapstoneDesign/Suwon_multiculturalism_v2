from app.agent.tools import build_tools


def _tool(name: str, uid=None):
    tools = build_tools(uid=uid)
    return next(t for t in tools if t.__name__ == name)


def test_get_user_history_without_uid_returns_empty():
    get_user_history = _tool("get_user_history")

    result = get_user_history()

    assert result["turns"] == []


def test_calculate_wage_returns_overdue_classification():
    calculate_wage = _tool("calculate_wage")

    result = calculate_wage(
        work_start_date="2026-03-01",
        last_work_date="2026-06-01",
        unpaid_amount=500000,
        agreed_monthly_salary=2000000,
        has_contract=True,
        workplace_name="OO식당",
    )

    assert result["is_overdue"] is True
    assert result["days_overdue"] > 0


def test_calculate_wage_invalid_date_returns_error_not_exception():
    calculate_wage = _tool("calculate_wage")

    result = calculate_wage(
        work_start_date="not-a-date",
        last_work_date="2026-06-01",
        unpaid_amount=500000,
        agreed_monthly_salary=2000000,
        has_contract=True,
        workplace_name="OO식당",
    )

    assert "error" in result


def test_search_support_orgs_returns_default_list_without_location():
    search_support_orgs = _tool("search_support_orgs")

    result = search_support_orgs()

    assert len(result["orgs"]) > 0
    assert "name" in result["orgs"][0]


def test_search_reference_documents_returns_empty_when_datastore_unconfigured():
    # 로컬/CI 기본 상태: DISCOVERY_ENGINE_ID가 설정되지 않아 클라이언트가 None이다.
    search_reference_documents = _tool("search_reference_documents")

    result = search_reference_documents(query="근로기준법 임금 지급기한")

    assert result["documents"] == []
