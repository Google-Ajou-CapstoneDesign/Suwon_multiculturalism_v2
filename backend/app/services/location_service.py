from datetime import datetime, timezone

from ..schemas.location import LocationVerifyRequest, LocationVerifyResponse

# 대한민국 대략적 경계 상자 — 등록된 사업장 좌표가 없어 반경 대조(지오펜싱)는
# 하지 않는다. (0, 0) 같은 명백히 잘못되거나 위조된 좌표만 걸러낸다.
_KR_LAT_RANGE = (33.0, 39.0)
_KR_LNG_RANGE = (124.0, 132.0)


def verify_location(payload: LocationVerifyRequest) -> LocationVerifyResponse:
    plausible = (
        _KR_LAT_RANGE[0] <= payload.latitude <= _KR_LAT_RANGE[1]
        and _KR_LNG_RANGE[0] <= payload.longitude <= _KR_LNG_RANGE[1]
    )
    return LocationVerifyResponse(
        verified=plausible,
        verified_at=datetime.now(timezone.utc),
        latitude=payload.latitude,
        longitude=payload.longitude,
    )
