from .base import CamelModel


class WeatherInfo(CamelModel):
    """GET /api/weather 응답. 날씨 상태는 코드로만 내려주고(clear/cloudy/rain 등),
    4개 언어 문구로 옮기는 건 프론트가 한다 — 이 앱의 다른 구조화 데이터(Org 등)와
    같은 원칙으로, 번역은 항상 클라이언트 쪽 책임이다."""

    location: str
    condition_code: str
    emoji: str
    temp_c: int
    feels_like_c: int
    low_c: int
    high_c: int
