from typing import List, Literal, Optional

from pydantic import Field

from .base import CamelModel
from .org import Org


class ChatTurn(CamelModel):
    """직전 대화 한 턴. 프론트엔드가 화면에 이미 들고 있는 메시지 목록에서
    최근 몇 개를 그대로 잘라 보낸다 — 백엔드가 별도로 대화 세션을 저장하지
    않는 지금 구조에서, 의도 분류와 에이전트 둘 다 "그럼 저는 어떻게 해야
    하나요?" 같은 맥락 의존 후속 질문을 이해하려면 이게 필요하다."""

    role: Literal["user", "assistant"]
    text: str


class ChatRequest(CamelModel):
    message: str
    history: List[ChatTurn] = []
    visa_group: Optional[Literal["E-9", "H-2", "D-2"]] = None
    lifecycle_stage: Optional[str] = None
    # 프론트엔드(AppLanguage)의 현재 언어 설정. 메시지 자체가 어떤 언어로
    # 쓰였든, 답변은 항상 이 설정을 따라야 한다 — 모델이 메시지 언어만 보고
    # 자동 판단하게 두면(예: 한국어로 짧게 쓴 질문) 설정과 다른 언어로 답하는
    # 경우가 있었다.
    language: Literal["ko", "en", "zh", "vi"] = "ko"
    # 추천 기관까지 실제 거리를 계산하기 위한 기기 현재 위치. 위치 권한이
    # 없거나 서비스가 꺼져 있으면 둘 다 생략할 수 있다.
    latitude: Optional[float] = Field(default=None, ge=-90, le=90)
    longitude: Optional[float] = Field(default=None, ge=-180, le=180)


class RoutingTarget(CamelModel):
    # frontend_설계.md의 AIResponse.routingTarget 유니온과 값 표기를 맞춘다.
    module: Literal["module1", "module3-wage", "module3-accident"]
    category_id: Optional[str] = None


class ChatResponse(CamelModel):
    fact_answer: Optional[str] = None
    risk_notice: Optional[str] = None
    routing_target: Optional[RoutingTarget] = None
    recommended_orgs: List[Org] = []
