"""수원시 날씨 — Open-Meteo(무료, API 키 불필요)에서 실시간으로 가져온다.
TODO(backend): 사용자별 위치가 생기면 좌표를 파라미터화한다 — 지금은 앱이
수원시 고정이라 좌표도 고정해뒀다.

조회 실패(네트워크 오류·응답 형식 이상 등)엔 None을 반환한다 — 다른 서비스들과
같은 "설정/호출 실패 시 조용히 폴백" 원칙으로, 여기서는 라우터가 503을 반환해
프론트가 자체 목업으로 대체하게 한다.
"""

import logging
import time
from typing import Optional

import httpx

from ..core.logging_utils import log_exception_summary
from ..schemas.weather import WeatherInfo

logger = logging.getLogger(__name__)

_SUWON_LAT = 37.2636
_SUWON_LON = 127.0286
_FORECAST_URL = "https://api.open-meteo.com/v1/forecast"

# 홈 화면을 열 때마다 매번 외부 API를 부르지 않도록 짧게 캐싱한다 — 날씨는
# 15분 안에 크게 안 바뀌고, Open-Meteo 무료 사용량도 아낄 수 있다.
_CACHE_TTL_SECONDS = 15 * 60
_cache: Optional[tuple[float, WeatherInfo]] = None


def _condition_from_wmo(code: int) -> tuple[str, str]:
    """WMO 날씨 코드(Open-Meteo 기준)를 이 앱의 condition_code + 이모지로 단순화한다."""
    if code == 0:
        return "clear", "☀️"
    if code in (1, 2):
        return "partlyCloudy", "🌤️"
    if code == 3:
        return "cloudy", "☁️"
    if code in (45, 48):
        return "fog", "🌫️"
    if code in (51, 53, 55, 56, 57, 80, 81, 82):
        return "drizzle", "🌦️"
    if code in (61, 63, 65, 66, 67):
        return "rain", "🌧️"
    if code in (71, 73, 75, 77, 85, 86):
        return "snow", "🌨️"
    if code in (95, 96, 99):
        return "thunderstorm", "⛈️"
    return "cloudy", "☁️"


async def get_suwon_weather() -> Optional[WeatherInfo]:
    global _cache
    now = time.monotonic()
    if _cache is not None and now - _cache[0] < _CACHE_TTL_SECONDS:
        return _cache[1]

    try:
        async with httpx.AsyncClient(timeout=5.0) as client:
            response = await client.get(
                _FORECAST_URL,
                params={
                    "latitude": _SUWON_LAT,
                    "longitude": _SUWON_LON,
                    "current": "temperature_2m,apparent_temperature,weather_code",
                    "daily": "temperature_2m_max,temperature_2m_min",
                    "timezone": "Asia/Seoul",
                    "forecast_days": 1,
                },
            )
            response.raise_for_status()
            data = response.json()
    except Exception as exc:
        log_exception_summary(logger, "Open-Meteo 날씨 조회 실패", exc)
        logger.exception("Open-Meteo 날씨 조회 실패 전체 트레이스백")
        return None

    try:
        current = data["current"]
        daily = data["daily"]
        condition_code, emoji = _condition_from_wmo(int(current["weather_code"]))
        info = WeatherInfo(
            location="수원시",
            condition_code=condition_code,
            emoji=emoji,
            temp_c=round(current["temperature_2m"]),
            feels_like_c=round(current["apparent_temperature"]),
            low_c=round(daily["temperature_2m_min"][0]),
            high_c=round(daily["temperature_2m_max"][0]),
        )
    except (KeyError, IndexError, TypeError) as exc:
        log_exception_summary(logger, "Open-Meteo 응답 파싱 실패", exc)
        logger.exception("Open-Meteo 응답 파싱 실패 전체 트레이스백")
        return None

    _cache = (now, info)
    return info
