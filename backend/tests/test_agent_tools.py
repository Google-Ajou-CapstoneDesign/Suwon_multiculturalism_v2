import json
from pathlib import Path

from app.agent.tools import build_tools

_ORGS_JSON = Path(__file__).resolve().parent.parent / "app" / "data" / "organizations.json"


def _tool(name: str, uid=None, latitude=None, longitude=None):
    tools = build_tools(uid=uid, latitude=latitude, longitude=longitude)
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


def test_search_support_orgs_filters_by_situation_via_keyword_fallback():
    # 로컬/CI 기본 상태: genai 자격증명이 없으므로 키워드 매칭 경로로 폴백한다.
    search_support_orgs = _tool("search_support_orgs")

    result = search_support_orgs(situation="임금체불 진정 제기")

    assert 0 < len(result["orgs"]) <= 3


def test_search_support_orgs_sorts_by_distance_when_location_given():
    data = json.loads(_ORGS_JSON.read_text(encoding="utf-8"))
    target = next(o for o in data if o.get("latitude") is not None)
    search_support_orgs = _tool(
        "search_support_orgs",
        latitude=target["latitude"],
        longitude=target["longitude"],
    )

    result = search_support_orgs()

    distances = [o["distance_km"] for o in result["orgs"]]
    known_distances = [distance for distance in distances if distance is not None]
    assert known_distances == sorted(known_distances)
    assert distances[0] == 0.0


def test_search_support_orgs_without_location_does_not_report_false_zero():
    search_support_orgs = _tool("search_support_orgs")

    result = search_support_orgs(situation="임금체불 진정 제기")

    assert all(o["distance_km"] is None for o in result["orgs"])


def test_search_reference_documents_returns_empty_when_datastore_unconfigured():
    # 로컬/CI 기본 상태: DISCOVERY_ENGINE_ID가 설정되지 않아 클라이언트가 None이다.
    search_reference_documents = _tool("search_reference_documents")

    result = search_reference_documents(query="근로기준법 임금 지급기한")

    assert result["documents"] == []
