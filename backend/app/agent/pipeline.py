"""Gemini 함수 호출 루프(Agent loop) 실행.

에이전트구상.png의 "Agent loop" 박스 그대로: Gemini에 메시지를 보내고, 함수
호출 요청이 있으면 Tools를 실행해 결과를 다시 넣고, 없으면 최종 답변으로
루프를 끝낸다. 이 함수는 최종 답변 텍스트만 돌려주고, 주제 판별(사전 게이트)과
이력 저장은 chat_service가 담당한다 — google-genai 자격증명이 없거나 호출이
실패하면 예외를 그대로 던져 호출부가 정적 안내 문구로 폴백하게 한다.
"""

import logging
import re
import uuid
from dataclasses import dataclass, field
from typing import List, Optional

from google.adk.agents import Agent
from google.adk.events import Event
from google.adk.models import Gemini
from google.adk.runners import Runner
from google.adk.sessions import InMemorySessionService
from google.genai import types

from ..core.genai_client import get_model_name, resolve_client_kwargs
from ..core.time_utils import now_kst, weekday_kst_ko
from ..schemas.chat import ChatTurn
from ..schemas.org import Org
from .tools import build_tools

logger = logging.getLogger(__name__)

_APP_NAME = "local_bridge_chat"

_SYSTEM_INSTRUCTION = """
당신은 Team EQ Lab에서 만든 Local Bridge 앱의 에이전트입니다.
당신의 역할은 수원시 이주노동자·유학생을 돕는 따뜻한 상담사 에이전트입니다.

원칙:
- 사용자가 감정적 공감을 원하면 따뜻하게 공감해 주세요. 하지만 공감만 하고 끝내지 말고, 반드시 다음 행동을 안내하세요.
- "위법입니다", "무조건 이깁니다"처럼 단정적인 법적 결론을 내리지 말고, 확인된
  사실과 다음 행동(진정 제기, 네비게이터 이용, 기관 문의 등)을 안내하세요.
- 확실하지 않은 정보는 지어내지 말고, 백과사전 탭이나 관련 기관 문의를 안내하세요.
- 최대한 친절하고 상세하게 답변하세요.
- 메시지 맨 앞 대괄호에 오늘 날짜·요일·시각과 함께 "답변 언어(앱 설정)"이 주어집니다.
  "내일", "이번 주말"처럼 상대적인 시점을 판단하거나, 기관 이용시간(예: "평일
  09:00~18:00")을 보고 지금·내일 이용 가능한지 판단할 때 날짜 정보를 기준으로
  삼으세요 — 당신의 기억 속 날짜가 아니라 항상 이 값을 써야 합니다. 답변 언어는
  반드시 이 대괄호에 명시된 언어를 따르세요 — 사용자가 메시지를 다른 언어로
  썼더라도(예: 한국어로 짧게 물어봐도) 지정된 언어로만 답변해야 합니다. 단, 이
  대괄호 자체는 당신만 보는 참고용 컨텍스트입니다. 답변 텍스트 맨 앞이나 어디에도
  이 대괄호, 날짜, 요일, 시각, "답변 언어" 문구를 그대로(혹은 다른 말로
  바꿔서라도) 출력하지 마세요 — 사용자에게는 곧바로 지정된 언어의 답변 내용만
  보여야 합니다.

도구 호출:
- 임금·체불과 관련된 날짜/금액 수치를 안내할 때는 반드시 calculate_wage 도구를
  호출해 계산된 값만 사용하세요. 직접 암산하지 마세요.
- 사용자가 이전 상담 맥락을 언급하거나 참고가 필요하면 get_user_history 도구를
  호출하세요.
- 가까운 상담·지원 기관이 필요하면 search_support_orgs 도구를 호출하세요.
- 법 조항이나 정부 안내 문서의 정확한 내용이 필요하면 search_reference_documents
  도구로 찾은 조각만 인용하세요. 조문을 직접 지어내지 마세요.
- 사용자가 지금 바로 다음 행동을 취해야 할 만큼 긴급·구체적인 상황이라고
  판단되면(단순 정보 문의는 해당 안 됨) flag_urgent_action 도구를 호출하세요
  — 이 판단에 따라 화면에 경고와 네비게이터 이동 버튼이 뜹니다.
"""

_session_service = InMemorySessionService()

# 지시문에도 "이 대괄호를 답변에 쓰지 말라"고 못박아뒀지만, 모델이 가끔
# "[2026-08-13 (수요일) 12:54 기준(한국시간)]" 같은 날짜 컨텍스트를 (원문
# 그대로든 살짝 바꿔 말하든) 답변 맨 앞에 그대로 옮겨 적는 경우가 있어 방어적으로
# 한 번 더 걸러낸다. "기준(한국시간)"은 우리가 주입하는 컨텍스트에만 등장하는
# 고정 문구라 오탐 없이 식별할 수 있다.
_LEADING_TIME_CONTEXT_RE = re.compile(r"^\[[^\]]*기준\(한국시간\)[^\]]*\]\s*")


def _strip_leaked_context(text: str) -> str:
    return _LEADING_TIME_CONTEXT_RE.sub("", text, count=1).lstrip()


@dataclass
class AgentResult:
    """run_agent()의 반환값.

    chat_service가 예전에는 risk_notice/routing_target/recommended_orgs를
    intent(wage/accident/contract) 분류만 보고 무조건 채웠는데, 그러면 사용자가
    가벼운 질문을 해도 매번 경고문구·네비게이터 버튼·기관목록이 떴다. 이제는
    에이전트가 flag_urgent_action 호출 여부로 "지금 안내가 필요한 상황인지"를
    직접 판단하고(urgent), search_support_orgs를 실제로 호출했다면 그 결과를
    그대로(orgs) 돌려줘서 화면에 뜨는 기관이 에이전트가 실제로 찾은 것과
    일치하게 한다.
    """

    text: str
    urgent: bool = False
    orgs: List[Org] = field(default_factory=list)


def _log_agent_event(event: Event) -> None:
    """에이전트 루프에서 일어난 사고 과정·도구 호출·도구 결과를 로그로 남긴다.

    에이전트구상.png의 Agent loop 내부(Gemini 응답 → 함수 호출 판단 → Tools 실행
    → 재전송)를 로그만으로도 그대로 따라갈 수 있게 하기 위함이다 — 사용자에게
    나가는 답변에는 영향을 주지 않는다.
    """
    if event.content and event.content.parts:
        for part in event.content.parts:
            if part.thought and part.text:
                logger.info("🤔 [%s] 사고 과정: %s", event.author, part.text)
    for call in event.get_function_calls():
        logger.info("🔧 [%s] 도구 호출: %s(%s)", event.author, call.name, call.args)
    for response in event.get_function_responses():
        logger.info("✅ [%s] 도구 결과: %s → %s", event.author, response.name, response.response)


_LANGUAGE_NAMES = {
    "ko": "한국어",
    "en": "English",
    "zh": "中文(简体)",
    "vi": "Tiếng Việt",
}


async def run_agent(
    *,
    message: str,
    uid: Optional[str],
    visa_group: Optional[str],
    lifecycle_stage: Optional[str],
    history: Optional[List[ChatTurn]] = None,
    language: Optional[str] = None,
) -> AgentResult:
    """Tools를 갖춘 Gemini 에이전트를 한 번 실행해 답변과 에이전트의 판단(AgentResult)을 반환한다."""

    agent = Agent(
        name="local_bridge_agent",
        # 모델 이름 문자열만 주면 ADK가 core.genai_client와 무관하게 자체
        # 기본값(GOOGLE_GENAI_USE_VERTEXAI 환경변수 부재 시 Developer API/API
        # 키 모드)으로 클라이언트를 만들어버린다 — get_genai_client()와 동일한
        # 규칙(resolve_client_kwargs)을 명시적으로 넘겨 환경변수 설정 누락에
        # 안전하게 만든다.
        model=Gemini(model=get_model_name(), client_kwargs=resolve_client_kwargs()),
        instruction=_SYSTEM_INSTRUCTION,
        tools=build_tools(uid=uid),
        # 사고 과정(thought) 로그는 디버깅용일 뿐 사용자 응답에는 전혀 쓰이지
        # 않는데, thinking_budget 상한이 없으면 매 호출마다 모델이 실제로
        # "생각"하는 데 적잖은 시간을 써 체감 응답 속도를 떨어뜨린다.
        # thinking_budget=0으로 꺼서 그 지연을 없앤다.
        generate_content_config=types.GenerateContentConfig(
            thinking_config=types.ThinkingConfig(
                include_thoughts=False, thinking_budget=0
            )
        ),
    )
    runner = Runner(agent=agent, app_name=_APP_NAME, session_service=_session_service)

    effective_uid = uid or "anonymous"
    session_id = uuid.uuid4().hex
    await _session_service.create_session(
        app_name=_APP_NAME, user_id=effective_uid, session_id=session_id
    )

    now = now_kst()
    # 에이전트는 실제 시계가 없어 "오늘"을 모른다 — 매 요청마다 한국 시간 기준
    # 날짜·요일·시각을 넣어줘야 "내일", "지금 문 열었나요" 같은 상대적 시점
    # 질문과 기관 이용시간 판단이 가능하다(서버가 UTC로 도는 Cloud Run이라
    # KST로 명시 변환한다 — core.time_utils 참고).
    context_lines = [
        f"오늘 날짜: {now.strftime('%Y-%m-%d')} ({weekday_kst_ko(now.date())}요일) "
        f"{now.strftime('%H:%M')} 기준(한국시간)"
    ]
    if visa_group:
        context_lines.append(f"체류자격: {visa_group}")
    if lifecycle_stage:
        context_lines.append(f"생애주기 단계: {lifecycle_stage}")
    # 메시지 자체가 어떤 언어로 쓰였든(예: 한국어로 짧게 물어봐도), 프론트엔드
    # 앱 언어 설정을 따라 답변 언어를 강제한다 — 메시지 언어만 보고 자동
    # 판단하게 두면 설정과 다른 언어로 답하는 경우가 있었다.
    language_name = _LANGUAGE_NAMES.get(language or "ko", _LANGUAGE_NAMES["ko"])
    context_lines.append(f"답변 언어(앱 설정): {language_name} — 메시지의 언어와 달라도 반드시 이 언어로만 답변")
    context_prefix = f"[{' / '.join(context_lines)}]\n"

    # 매 요청마다 새 세션을 만들어 돌리므로(아래 create_session) 에이전트에게는
    # ADK 세션 자체의 기억이 없다 — chat_service가 프론트엔드로부터 받은 직전
    # 대화를 여기서 텍스트로 그대로 넣어줘야 "그럼 저는 어떻게 해야 하나요?"
    # 같은 맥락 의존 후속 질문에 제대로 답할 수 있다.
    history_block = "\n".join(
        f"{'사용자' if turn.role == 'user' else '상담사'}: {turn.text}"
        for turn in (history or [])[-6:]
    )
    history_prefix = f"[이전 대화]\n{history_block}\n\n" if history_block else ""

    new_message = types.Content(
        role="user", parts=[types.Part(text=history_prefix + context_prefix + message)]
    )

    final_text_parts: list[str] = []
    urgent = False
    found_orgs: List[Org] = []
    async for event in runner.run_async(
        user_id=effective_uid, session_id=session_id, new_message=new_message
    ):
        _log_agent_event(event)
        for call in event.get_function_calls():
            if call.name == "flag_urgent_action":
                urgent = True
        for response in event.get_function_responses():
            if response.name == "search_support_orgs" and isinstance(response.response, dict):
                orgs_data = response.response.get("orgs") or []
                found_orgs = [Org.model_validate(o) for o in orgs_data]
        if event.is_final_response() and event.content and event.content.parts:
            # part.thought(사고 과정)까지 같이 걸러내지 않으면 "Oh no, they're
            # really hurting..." 같은 영어 사고 과정 텍스트가 실제 답변 앞에
            # 그대로 붙어서 사용자에게 노출된다 — _log_agent_event()가 이미
            # 로그로 따로 남기므로 여기서는 사고 과정이 아닌 part만 모은다.
            final_text_parts = [
                part.text
                for part in event.content.parts
                if part.text and not part.thought
            ]

    final_text = _strip_leaked_context("".join(final_text_parts).strip())
    if not final_text:
        raise RuntimeError("에이전트가 최종 응답을 생성하지 못했습니다.")
    return AgentResult(text=final_text, urgent=urgent, orgs=found_orgs)
