from typing import List, Literal, Optional

from .base import CamelModel
from .wage import WageFacts


class ClaimantInfo(CamelModel):
    name: str
    address: Optional[str] = None
    phone: Optional[str] = None


class MappingRow(CamelModel):
    """Flutter DocumentMappingRow 위젯의 MappingStatus(auto/verbatim/blocked)와 1:1 대응."""

    label: str
    value: Optional[str] = None
    status: Literal["auto", "verbatim", "blocked"]
    notice: Optional[str] = None


class WageMappingRequest(CamelModel):
    claimant: ClaimantInfo
    facts: WageFacts
    narrative: str  # 5W1H 사실 서술 — 가공 없이 원문 그대로 서식에 옮겨진다


class WageMappingResponse(CamelModel):
    rows: List[MappingRow]
    disclaimer: str
