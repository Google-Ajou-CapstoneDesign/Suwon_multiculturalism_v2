from datetime import datetime
from typing import Optional

from pydantic import Field

from .base import CamelModel


class LocationVerifyRequest(CamelModel):
    """근무기록장 "위치 인증하기" 버튼이 보내는 기기 GPS 좌표."""

    latitude: float = Field(ge=-90, le=90)
    longitude: float = Field(ge=-180, le=180)
    accuracy_m: Optional[float] = None


class LocationVerifyResponse(CamelModel):
    """사업장 좌표가 아직 등록돼 있지 않아 지오펜싱(반경 대조)은 하지 않는다 —
    좌표가 실제로 수신됐고 그럴듯한(대한민국 범위 내) 값인지만 판정하고, 서버
    시각을 기준으로 기록한다. daily_work_record.dart의 gpsVerified 설계 원칙
    ("판정하지 않고 사실만 기록")과 동일하게, 근무지 소속 여부를 단정하지 않는다."""

    verified: bool
    verified_at: datetime
    latitude: float
    longitude: float
