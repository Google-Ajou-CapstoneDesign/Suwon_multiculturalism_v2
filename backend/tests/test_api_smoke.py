from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_chat_wage_keyword_routes_to_wage_navigator():
    response = client.post("/api/chat", json={"message": "임금 못받은지 3주됐어요"})
    assert response.status_code == 200
    body = response.json()
    assert body["routingTarget"]["module"] == "module3-wage"
    assert len(body["recommendedOrgs"]) > 0


def test_orgs_default_list_without_location():
    response = client.get("/api/orgs")
    assert response.status_code == 200
    assert len(response.json()) == 5


def test_wage_classify_requires_auth_dev_bypass_ok():
    payload = {
        "workStartDate": "2026-03-01",
        "lastWorkDate": "2026-07-01",
        "unpaidAmount": 500000,
        "agreedMonthlySalary": 2000000,
        "hasContract": True,
        "workplaceName": "OO식당",
    }
    response = client.post("/api/wage/classify", json=payload)
    assert response.status_code == 200
    assert "isOverdue" in response.json()
