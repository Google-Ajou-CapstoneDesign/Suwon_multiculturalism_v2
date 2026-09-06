from unittest.mock import AsyncMock, patch

from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


class _FakeGeocodeResponse:
    def __init__(self, json_data):
        self._json = json_data

    def raise_for_status(self):
        pass

    def json(self):
        return self._json


# 실제 Nominatim에 매 테스트 실행마다 네트워크 요청을 보내지 않도록(CI
# 안정성·이용 정책 준수 둘 다를 위해) weather_service 테스트와 동일한 방식으로
# httpx.AsyncClient.get을 패치한다.
_FAKE_ADDRESS = "대한민국 경기도 수원시 팔달구 정조로 애칭"


def test_verify_location_inside_korea_is_verified():
    with patch(
        "httpx.AsyncClient.get",
        AsyncMock(return_value=_FakeGeocodeResponse({"display_name": _FAKE_ADDRESS})),
    ):
        response = client.post(
            "/api/location/verify",
            json={"latitude": 37.2636, "longitude": 127.0286, "accuracyM": 12.5},
        )
    assert response.status_code == 200
    body = response.json()
    assert body["verified"] is True
    assert body["latitude"] == 37.2636
    assert body["longitude"] == 127.0286
    assert body["address"] == _FAKE_ADDRESS
    assert "verifiedAt" in body


def test_verify_location_null_island_is_not_verified():
    with patch(
        "httpx.AsyncClient.get",
        AsyncMock(return_value=_FakeGeocodeResponse({"display_name": "Null Island"})),
    ):
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
    with patch(
        "httpx.AsyncClient.get",
        AsyncMock(return_value=_FakeGeocodeResponse({"display_name": _FAKE_ADDRESS})),
    ):
        response = client.post(
            "/api/location/verify",
            json={"latitude": 37.2636, "longitude": 127.0286},
        )
    assert response.status_code == 200


def test_verify_location_still_verifies_when_geocoding_fails():
    # 역지오코딩은 부가 정보라, 외부 API가 죽어도 위치 인증(verified) 판정
    # 자체는 막히면 안 된다 — address만 null로 빠진다.
    with patch("httpx.AsyncClient.get", AsyncMock(side_effect=Exception("network down"))):
        response = client.post(
            "/api/location/verify",
            json={"latitude": 37.2636, "longitude": 127.0286},
        )
    assert response.status_code == 200
    body = response.json()
    assert body["verified"] is True
    assert body["address"] is None


def test_verify_location_passes_requested_language_to_geocoder():
    captured = {}

    async def _fake_get(self, url, params=None, headers=None):
        captured["language"] = params.get("accept-language")
        return _FakeGeocodeResponse({"display_name": _FAKE_ADDRESS})

    with patch("httpx.AsyncClient.get", _fake_get):
        response = client.post(
            "/api/location/verify",
            json={"latitude": 37.2636, "longitude": 127.0286, "language": "vi"},
        )
    assert response.status_code == 200
    assert captured["language"] == "vi"
