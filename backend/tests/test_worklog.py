from fastapi.testclient import TestClient

from app.main import app
from app.services import worklog_service

client = TestClient(app)


def test_list_days_without_firestore_returns_empty_list():
    # 테스트 환경엔 Firebase 자격증명이 없으므로(conftest AUTH_DEV_BYPASS만 켜둠)
    # worklog_service.list_month()가 빈 목록을 돌려주고, 라우터는 200 + 빈
    # 배열로 응답해야 한다 — 근무기록이 없는 것과 Firestore 미설정을 구분하지
    # 않는다(둘 다 "표시할 게 없다"로 취급).
    response = client.get("/api/worklog/days", params={"year": 2026, "month": 8})
    assert response.status_code == 200
    assert response.json() == {"days": []}


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
