from datetime import datetime
from typing import Literal, Optional

from pydantic import Field

from .base import CamelModel


class LocationVerifyRequest(CamelModel):
    """근무기록장 "위치 인증하기" 버튼이 보내는 기기 GPS 좌표."""

    latitude: float = Field(ge=-90, le=90)
    longitude: float = Field(ge=-180, le=180)
    accuracy_m: Optional[float] = None
    # 역지오코딩 결과 주소 문자열을 어떤 언어로 받을지. ChatRequest.language와
    # 동일한 규칙(프론트엔드 AppLanguage 현재 설정을 그대로 전달) — 주소는
    # weather_service의 condition_code처럼 유한한 값 집합으로 지원 언어를
    # 다 준비해둘 수 없는(장소마다 문자열이 달라지는) 데이터라, 이 한 곳만
    # 예외적으로 서버가 이미 번역된 문자열을 돌려준다.
    language: Literal["ko", "en", "zh", "vi", "uz", "tr"] = "ko"


class LocationVerifyResponse(CamelModel):
    """사업장 좌표가 아직 등록돼 있지 않아 지오펜싱(반경 대조)은 하지 않는다 —
    좌표가 실제로 수신됐고 그럴듯한(대한민국 범위 내) 값인지만 판정하고, 서버
    시각을 기준으로 기록한다. daily_work_record.dart의 gpsVerified 설계 원칙
    ("판정하지 않고 사실만 기록")과 동일하게, 근무지 소속 여부를 단정하지 않는다."""

    verified: bool
    verified_at: datetime
    latitude: float
    longitude: float
    # 역지오코딩 실패(외부 API 장애·요청 제한 등)해도 위치 인증 자체는 막지
    # 않는다 — 이럴 땐 None을 내려보내고 프론트가 좌표 대신 보여줄 문구가
    # 없으면 조용히 생략한다.
    address: Optional[str] = None
