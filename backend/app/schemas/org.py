from typing import Optional

from .base import CamelModel


class Org(CamelModel):
    name: str
    # 사용자 위치 또는 기관 좌표가 없으면 실제 거리를 알 수 없으므로 null.
    # 0.0은 두 좌표가 실제로 매우 가까울 때만 사용한다.
    distance_km: Optional[float] = None
