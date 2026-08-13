"""챗봇 파이프라인 (에이전트구상.png).

1) genai로 '주제 판별(의도 분류)'만 먼저 하고(실패 시 키워드 폴백) — 이 게이트가
   "답변이 판단할 수 있는 소재인가?"에 해당한다. 분류는 직전 대화([이전 대화])도
   같이 보고 판단한다 — 그렇지 않으면 "그럼 저는 어떻게 해야 하나요?" 같은
   맥락 의존 후속 질문이 매번 off_topic으로 새서 답이 안 나가는 문제가 있었다.
   wage/accident/contract/meta는 에이전트를 부르고, off_topic만 에이전트 없이
   정중한 거절 문구로 바로 응답한다.
2) 소재가 있다고 판단되면 app.agent.pipeline.run_agent()로 Tools(사용자 이력
   조회·임금 계산·기관 조회)를 갖춘 Gemini 에이전트 루프를 돌려 최종 답변을
   받는다 — 더 이상 정적 문구만 내보내지 않고, 도구로 근거를 확보한 뒤 LLM이
   답변을 구성한다.
3) 에이전트 호출이 실패하면(자격증명 없음, 네트워크 오류 등) _CONTENT의 사전
   검수 문구로 폴백해 항상 응답할 수 있게 한다.
4) 로그인한 사용자(uid)라면 history_service로 이번 대화를 저장한다 — 이력
   저장 실패가 응답 자체를 막지는 않는다.
"""

import logging
from typing import Dict, List, Literal, Optional, TypedDict

from google.genai import types
from pydantic import BaseModel

from ..agent.pipeline import run_agent
from ..core.genai_client import get_genai_client, get_model_name
from ..core.logging_utils import log_exception_summary
from ..schemas.chat import ChatRequest, ChatResponse, ChatTurn, RoutingTarget
from ..schemas.org import Org
from . import history_service
from .org_service import DEFAULT_ORGS

logger = logging.getLogger(__name__)

Intent = Literal["wage", "accident", "contract", "meta", "off_topic"]

# 에이전트를 실제로 호출하는 의도 — 나머지(off_topic)는 정중히 거절만 하고
# Gemini를 부르지 않는다(비용·오남용 방지).
_AGENT_INTENTS: frozenset = frozenset({"wage", "accident", "contract", "meta"})


class IntentClassification(BaseModel):
    """genai structured output 스키마. 분류값만 받고 다른 자유 텍스트는 받지 않는다."""

    intent: Intent


class _ContentEntry(TypedDict):
    keywords: List[str]
    fact_answer: Optional[str]
    risk_notice: Optional[str]
    routing_target: Optional[RoutingTarget]


_META_FALLBACK_ANSWER = (
    "저는 수원시 이주노동자·유학생의 노동 상담을 돕는 AI 도우미예요. "
    "임금체불, 산업재해, 근로계약서 등 궁금한 점을 편하게 물어보세요."
)
_OFF_TOPIC_ANSWER = (
    "이 서비스는 수원시 이주노동자·유학생의 노동 상담(임금체불·산업재해·근로계약 등)을 돕는 곳이에요. "
    "요청하신 내용은 제가 도와드리기 어려운 주제라 정중히 양해 부탁드려요."
)

_CONTENT: Dict[Intent, _ContentEntry] = {
    "wage": {
        "keywords": ["임금", "체불", "월급", "급여"],
        "fact_answer": (
            "근로기준법상 사용자는 퇴직·지급일로부터 14일 이내에 임금을 지급해야 해요. "
            "이미 기간이 지났다면 진정 제기가 가능해요."
        ),
        "risk_notice": (
            "즉시 대응이 필요한 사안으로 보여요. 정확한 판단은 AI가 아닌 아래 네비게이터·전문가를 통해 확인해 주세요."
        ),
        "routing_target": RoutingTarget(module="module3-wage"),
    },
    "accident": {
        "keywords": ["산재", "다쳤", "부상", "사고"],
        "fact_answer": "업무 중 다쳤다면 산재보험으로 치료비를 처리할 수 있어요. 사업주의 공상 처리 요구는 거절할 수 있어요.",
        "risk_notice": "사고 사실관계 정리가 필요해 보여요. 산재 대응 네비게이터에서 증빙을 정리해 드릴게요.",
        "routing_target": RoutingTarget(module="module3-accident"),
    },
    "contract": {
        "keywords": ["계약서", "근로계약"],
        "fact_answer": (
            "근로계약서에는 임금·근무시간·휴게시간 등 11개 필수 확인 항목이 있어요. "
            "백과사전 탭의 체크리스트에서 확인할 수 있어요."
        ),
        "risk_notice": None,
        "routing_target": RoutingTarget(module="module1", category_id="contract_check"),
    },
    "meta": {
        # 노동 상담 소재는 아니지만 서비스가 직접 답해도 되는 것("너는 누구니?" 등).
        # genai 미설정 시엔 키워드로만 대충 잡는다 — 정교함보다는 완전히 놓치지
        # 않는 게 목적이라 최소한만 넣는다.
        "keywords": ["너는 누구", "당신은 누구", "뭐하는 곳", "뭐 하는 곳", "사용법", "안녕하세요", "안녕"],
        "fact_answer": _META_FALLBACK_ANSWER,
        "risk_notice": None,
        "routing_target": None,
    },
    "off_topic": {
        # 노동 상담과 무관해 정중히 거절해야 하는 것("돈 버는 어플리케이션 설계해줘" 등).
        # 키워드 폴백에서 아무 것도 안 걸리면 여기로 떨어지는 기본값이기도 하다.
        "keywords": [],
        "fact_answer": _OFF_TOPIC_ANSWER,
        "risk_notice": None,
        "routing_target": None,
    },
}

_SYSTEM_INSTRUCTION = (
    """당신은 수원시 이주노동자·유학생 노동 상담 서비스의 질문 분류기입니다.
    [이전 대화]가 주어지면 맥락으로 참고하고, [분류할 메시지](없으면 입력 전체)를
    아래 다섯 가지 중 하나로 분류하세요.

    - wage: 임금·급여 미지급, 체불 관련
    - accident: 산업재해·사고·부상 관련
    - contract: 근로계약서 관련
    - meta: 이 서비스/AI 자체에 대한 질문이나 인사(예: "너는 누구니?",
      "뭘 도와줄 수 있어?", "안녕", "사용법 알려줘") — 노동 상담 소재는 아니지만
      서비스가 직접 답해도 되는 것
    - off_topic: 노동 상담과 무관한 요청(예: "돈 버는 어플리케이션 설계해줘",
      "오늘 날씨 어때", 일반 잡담·코딩·창작 요청 등) — 정중히 거절해야 하는 것

    [이전 대화]의 흐름상 지금 메시지가 wage/accident/contract 상담의 자연스러운
    후속 질문(예: "그럼 저는 어떻게 해야 하나요?", "얼마나 받을 수 있어요?")이면
    그 맥락에 맞는 카테고리로 분류하세요 — 메시지 자체에 키워드가 없다고 무조건
    off_topic으로 분류하지 마세요.

    분류값 외에 설명·조언·새로운 문장을 절대 만들지 마세요.
    """
)


def _format_history_for_prompt(history: List[ChatTurn], *, limit: int = 6) -> str:
    if not history:
        return ""
    lines = [
        f"{'사용자' if turn.role == 'user' else '상담사'}: {turn.text}"
        for turn in history[-limit:]
    ]
    return "\n".join(lines)


def _classify_with_genai(message: str, history: List[ChatTurn]) -> Optional[Intent]:
    client = get_genai_client()
    if client is None:
        return None
    history_block = _format_history_for_prompt(history)
    contents = (
        f"[이전 대화]\n{history_block}\n\n[분류할 메시지]\n{message}"
        if history_block
        else message
    )
    try:
        response = client.models.generate_content(
            model=get_model_name(),
            contents=contents,
            config=types.GenerateContentConfig(
                system_instruction=_SYSTEM_INSTRUCTION,
                response_mime_type="application/json",
                response_schema=IntentClassification,
                temperature=0,
            ),
        )
        parsed = response.parsed
        if not isinstance(parsed, IntentClassification):
            return None
        return parsed.intent
    except Exception as exc:
        log_exception_summary(logger, "genai 의도 분류 실패 — 키워드 규칙으로 폴백합니다.", exc)
        logger.exception("genai 의도 분류 실패 전체 트레이스백")
        return None


def _classify_with_keywords(message: str) -> Intent:
    for intent, content in _CONTENT.items():
        if intent == "off_topic":
            continue
        if any(keyword in message for keyword in content["keywords"]):
            return intent
    return "off_topic"


async def answer(request: ChatRequest, uid: Optional[str] = None) -> ChatResponse:
    intent = (
        _classify_with_genai(request.message, request.history)
        or _classify_with_keywords(request.message)
    )
    content = _CONTENT[intent]

    fact_answer = content["fact_answer"]
    # risk_notice/routing_target은 예전엔 intent만 보고 무조건 채웠다 — 그러면
    # 가벼운 질문에도 매번 경고문구·네비게이터 버튼이 떴다. 이제는 에이전트가
    # flag_urgent_action 도구로 "지금 안내가 필요한 상황인지" 직접 판단한
    # 경우에만 채운다(urgent).
    risk_notice: Optional[str] = None
    routing_target: Optional[RoutingTarget] = None
    orgs: List[Org] = DEFAULT_ORGS[:1] if intent in ("wage", "accident", "contract") else []

    if intent in _AGENT_INTENTS:
        try:
            agent_result = await run_agent(
                message=request.message,
                uid=uid,
                visa_group=request.visa_group,
                lifecycle_stage=request.lifecycle_stage,
                history=request.history,
            )
            fact_answer = agent_result.text
            if agent_result.urgent:
                risk_notice = content["risk_notice"]
                routing_target = content["routing_target"]
            if agent_result.orgs:
                orgs = agent_result.orgs
        except Exception as exc:
            log_exception_summary(logger, "에이전트 응답 생성 실패 — 사전 검수 문구로 폴백합니다.", exc)
            logger.exception("에이전트 응답 생성 실패 전체 트레이스백")
            fact_answer = content["fact_answer"]
            # 에이전트가 아예 실패하면 "지금 안내가 필요한 상황인지" 판단을
            # 대신해줄 수 없으니, wage/accident/contract는 예전처럼 intent 기반
            # 고정 안내로 안전하게 폴백한다(과소 안내보다는 과다 안내가 낫다).
            # meta는 애초에 경고·라우팅이 없는 카테고리라 그대로 둔다.
            if intent != "meta":
                risk_notice = content["risk_notice"]
                routing_target = content["routing_target"]
                orgs = DEFAULT_ORGS[:2]

    response = ChatResponse(
        fact_answer=fact_answer,
        risk_notice=risk_notice,
        routing_target=routing_target,
        recommended_orgs=orgs,
    )

    if uid:
        history_service.save_turn(uid, request.message, fact_answer)

    return response
