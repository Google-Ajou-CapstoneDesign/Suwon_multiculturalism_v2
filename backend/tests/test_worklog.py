from fastapi.testclient import TestClient

from app.main import app
from app.services import worklog_service

client = TestClient(app)


def test_list_days_without_firestore_returns_503(monkeypatch):
    # 조회 장애를 '증빙 기록 없음'으로 오인하지 않도록 구분한다.
    monkeypatch.setattr(worklog_service, "_client", lambda: None)
    response = client.get("/api/worklog/days", params={"year": 2026, "month": 8})
    assert response.status_code == 503


def test_list_days_empty_month_is_success(monkeypatch):
    monkeypatch.setattr(worklog_service, "list_month", lambda uid, year, month: [])
    response = client.get("/api/worklog/days", params={"year": 2026, "month": 8})
    assert response.status_code == 200
    assert response.json() == {"days": []}


def test_list_days_query_failure_is_not_empty_success(monkeypatch):
    class BrokenClient:
        def collection(self, name):
            raise RuntimeError("database unavailable")

    monkeypatch.setattr(worklog_service, "_client", lambda: BrokenClient())
    response = client.get("/api/worklog/days", params={"year": 2026, "month": 8})
    assert response.status_code == 503


def test_list_days_invalid_year():
    for year in [0, 9999]:
        response = client.get("/api/worklog/days", params={"year": year, "month": 12})
        assert response.status_code == 400


def test_list_days_rejects_invalid_month():
    response = client.get("/api/worklog/days", params={"year": 2026, "month": 13})
    assert response.status_code == 400


def test_upsert_day_without_firestore_returns_503():
    response = client.put(
        "/api/worklog/days/2026-08-18",
        json={"clockIn": "09:00", "clockOut": "18:00", "breakMinutes": 60, "memo": "테스트"},
    )
    assert response.status_code == 503


def test_upsert_day_rejects_malformed_time():
    response = client.put(
        "/api/worklog/days/2026-08-18",
        json={"clockIn": "9am"},
    )
    assert response.status_code == 422


def test_doc_id_is_deterministic_per_user_and_date():
    from datetime import date

    first = worklog_service.doc_id("uid-1", date(2026, 8, 18))
    second = worklog_service.doc_id("uid-1", date(2026, 8, 18))
    assert first == second == "uid-1_2026-08-18"
