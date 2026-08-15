from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_verify_location_inside_korea_is_verified():
    response = client.post(
        "/api/location/verify",
        json={"latitude": 37.2636, "longitude": 127.0286, "accuracyM": 12.5},
    )
    assert response.status_code == 200
    body = response.json()
    assert body["verified"] is True
    assert body["latitude"] == 37.2636
    assert body["longitude"] == 127.0286
    assert "verifiedAt" in body


def test_verify_location_null_island_is_not_verified():
    response = client.post(
        "/api/location/verify",
        json={"latitude": 0, "longitude": 0},
    )
    assert response.status_code == 200
    assert response.json()["verified"] is False


def test_verify_location_rejects_out_of_range_latitude():
    response = client.post(
        "/api/location/verify",
        json={"latitude": 137.0, "longitude": 127.0},
    )
    assert response.status_code == 422


def test_verify_location_works_without_auth_header():
    # 근무기록장은 로그인 없이도 쓸 수 있어야 하므로 Authorization 헤더가
    # 없어도 200이어야 한다(get_optional_user).
    response = client.post(
        "/api/location/verify",
        json={"latitude": 37.2636, "longitude": 127.0286},
    )
    assert response.status_code == 200
