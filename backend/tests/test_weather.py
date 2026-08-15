from unittest.mock import AsyncMock, patch

import pytest
from fastapi.testclient import TestClient

from app.main import app
from app.services import weather_service

client = TestClient(app)


@pytest.fixture(autouse=True)
def _reset_cache():
    # 서비스 모듈 레벨 캐시가 테스트 간에 새어나가지 않도록 매 테스트 전후로 비운다.
    weather_service._cache = None
    yield
    weather_service._cache = None


class _FakeResponse:
    def __init__(self, json_data):
        self._json = json_data

    def raise_for_status(self):
        pass

    def json(self):
        return self._json


async def test_get_suwon_weather_parses_open_meteo_response():
    fake_data = {
        "current": {
            "temperature_2m": 27.4,
            "apparent_temperature": 29.9,
            "weather_code": 1,
        },
        "daily": {
            "temperature_2m_max": [30.1],
            "temperature_2m_min": [22.3],
        },
    }
    with patch("httpx.AsyncClient.get", AsyncMock(return_value=_FakeResponse(fake_data))):
        info = await weather_service.get_suwon_weather()

    assert info is not None
    assert info.location == "수원시"
    assert info.temp_c == 27
    assert info.feels_like_c == 30
    assert info.low_c == 22
    assert info.high_c == 30
    assert info.condition_code == "partlyCloudy"
    assert info.emoji == "🌤️"


async def test_get_suwon_weather_returns_none_on_network_failure():
    with patch("httpx.AsyncClient.get", AsyncMock(side_effect=Exception("network down"))):
        info = await weather_service.get_suwon_weather()
    assert info is None


async def test_get_suwon_weather_returns_none_on_malformed_response():
    with patch(
        "httpx.AsyncClient.get",
        AsyncMock(return_value=_FakeResponse({"current": {}, "daily": {}})),
    ):
        info = await weather_service.get_suwon_weather()
    assert info is None


def test_weather_endpoint_returns_503_when_service_unavailable():
    with patch(
        "app.services.weather_service.get_suwon_weather", AsyncMock(return_value=None)
    ):
        response = client.get("/api/weather")
    assert response.status_code == 503


def test_weather_endpoint_returns_data_when_service_available():
    fake_data = {
        "current": {
            "temperature_2m": 31.0,
            "apparent_temperature": 34.0,
            "weather_code": 0,
        },
        "daily": {
            "temperature_2m_max": [33.0],
            "temperature_2m_min": [24.0],
        },
    }
    with patch("httpx.AsyncClient.get", AsyncMock(return_value=_FakeResponse(fake_data))):
        response = client.get("/api/weather")

    assert response.status_code == 200
    body = response.json()
    assert body["tempC"] == 31
    assert body["feelsLikeC"] == 34
    assert body["conditionCode"] == "clear"
    assert body["emoji"] == "☀️"
