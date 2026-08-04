from typing import List, Literal, Optional

from .base import CamelModel
from .org import Org


class ChatRequest(CamelModel):
    message: str
    visa_group: Optional[Literal["E-9", "H-2", "D-2"]] = None
    lifecycle_stage: Optional[str] = None


class RoutingTarget(CamelModel):
    # frontend_설계.md의 AIResponse.routingTarget 유니온과 값 표기를 맞춘다.
    module: Literal["module1", "module3-wage", "module3-accident"]
    category_id: Optional[str] = None


class ChatResponse(CamelModel):
    fact_answer: Optional[str] = None
    risk_notice: Optional[str] = None
    routing_target: Optional[RoutingTarget] = None
    recommended_orgs: List[Org] = []
