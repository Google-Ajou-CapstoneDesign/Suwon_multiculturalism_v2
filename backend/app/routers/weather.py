from fastapi import APIRouter, HTTPException

from ..schemas.weather import WeatherInfo
from ..services import weather_service

router = APIRouter(prefix="/api/weather", tags=["weather"])


@router.get("", response_model=WeatherInfo)
async def get_weather() -> WeatherInfo:
    """실패 시 503을 반환한다 — 프론트가 자체 목업으로 대체한다(uploads/orgs와
    달리 이 데이터는 정적 폴백 파일이 없어 여기서 흉내내지 않는다)."""
    info = await weather_service.get_suwon_weather()
    if info is None:
        raise HTTPException(status_code=503, detail="날씨 정보를 가져오지 못했습니다.")
    return info
