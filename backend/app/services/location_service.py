import logging
from datetime import datetime, timezone
from typing import Optional

import httpx

from ..core.logging_utils import log_exception_summary
from ..schemas.location import LocationVerifyRequest, LocationVerifyResponse

logger = logging.getLogger(__name__)

# 대한민국 대략적 경계 상자 — 등록된 사업장 좌표가 없어 반경 대조(지오펜싱)는
# 하지 않는다. (0, 0) 같은 명백히 잘못되거나 위조된 좌표만 걸러낸다.
_KR_LAT_RANGE = (33.0, 39.0)
_KR_LNG_RANGE = (124.0, 132.0)

# OpenStreetMap Nominatim — weather_service의 Open-Meteo와 같은 이유로 골랐다
# (무료, API 키 불필요, 별도 GCP 설정 없이 바로 동작). 다만 이용 정책상 초당
# 1회 제한과 User-Agent 명시가 필수라 아래에서 지킨다. TODO(backend/prod):
# 사용자 수가 늘어 요청이 잦아지면 Kakao/Google 등 유료 지오코더로 교체하거나
# 자체 호스팅을 검토한다 — 지금은 근무기록 인증 시에만(하루 한두 번) 호출되는
# 저빈도 사용이라 이 정책 안에서 충분하다.
_NOMINATIM_URL = "https://nominatim.openstreetmap.org/reverse"
_USER_AGENT = "LocalBridge-SuwonMulticulturalism/1.0 (capstone project)"

_NOMINATIM_LANGUAGE = {
    "ko": "ko",
    "en": "en",
    "zh": "zh-CN",
    "vi": "vi",
    "uz": "uz",
    "tr": "tr",
}


async def _reverse_geocode(latitude: float, longitude: float, language: str) -> Optional[str]:
    """좌표를 사람이 읽을 수 있는 주소 문자열로 변환한다.

    실패해도 예외를 던지지 않고 None을 돌려준다 — 역지오코딩은 부가 정보라
    이것 때문에 위치 인증 자체(verified 판정)가 막히면 안 된다."""
    try:
        async with httpx.AsyncClient(timeout=5.0) as client:
            response = await client.get(
                _NOMINATIM_URL,
                params={
                    "format": "jsonv2",
                    "lat": latitude,
                    "lon": longitude,
                    "zoom": 18,
                    "addressdetails": 0,
                    "accept-language": _NOMINATIM_LANGUAGE.get(language, "ko"),
                },
                headers={"User-Agent": _USER_AGENT},
            )
            response.raise_for_status()
            data = response.json()
    except Exception as exc:  # noqa: BLE001 - 지오코딩 실패는 조용히 폴백한다.
        log_exception_summary(logger, "역지오코딩 실패 — 좌표만 기록합니다.", exc)
        logger.exception("역지오코딩 실패 전체 트레이스백")
        return None

    display_name = data.get("display_name") if isinstance(data, dict) else None
    return display_name or None


async def verify_location(payload: LocationVerifyRequest) -> LocationVerifyResponse:
    plausible = (
        _KR_LAT_RANGE[0] <= payload.latitude <= _KR_LAT_RANGE[1]
        and _KR_LNG_RANGE[0] <= payload.longitude <= _KR_LNG_RANGE[1]
    )
    address = await _reverse_geocode(payload.latitude, payload.longitude, payload.language)
    return LocationVerifyResponse(
        verified=plausible,
        verified_at=datetime.now(timezone.utc),
        latitude=payload.latitude,
        longitude=payload.longitude,
        address=address,
    )
