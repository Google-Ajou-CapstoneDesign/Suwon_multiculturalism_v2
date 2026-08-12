"""Gemini 함수 호출 루프(Agent loop) 실행.

에이전트구상.png의 "Agent loop" 박스 그대로: Gemini에 메시지를 보내고, 함수
호출 요청이 있으면 Tools를 실행해 결과를 다시 넣고, 없으면 최종 답변으로
루프를 끝낸다. 이 함수는 최종 답변 텍스트만 돌려주고, 주제 판별(사전 게이트)과
이력 저장은 chat_service가 담당한다 — google-genai 자격증명이 없거나 호출이
실패하면 예외를 그대로 던져 호출부가 정적 안내 문구로 폴백하게 한다.
"""

import logging
import uuid
from typing import Optional

from google.adk.agents import Agent
from google.adk.events import Event
from google.adk.runners import Runner
from google.adk.sessions import InMemorySessionService
from google.genai import types

from ..core.genai_client import get_model_name
from .tools import build_tools

logger = logging.getLogger(__name__)

_APP_NAME = "local_bridge_chat"

_SYSTEM_INSTRUCTION = """당신은 수원시 이주노동자·유학생을 돕는 따뜻한 상담사 에이전트입니다.

원칙:
- 사용자가 감정적 공감을 원하면 따뜻하게 공감해 주세요. 하지만 공감만 하고 끝내지 말고, 반드시 다음 행동을 안내하세요.
- "위법입니다", "무조건 이깁니다"처럼 단정적인 법적 결론을 내리지 말고, 확인된
  사실과 다음 행동(진정 제기, 네비게이터 이용, 기관 문의 등)을 안내하세요.
- 확실하지 않은 정보는 지어내지 말고, 백과사전 탭이나 관련 기관 문의를 안내하세요.
- 한국어 존댓말로, 3~5문장 이내로 간결하게 답하세요.

도구 호출:
- 임금·체불과 관련된 날짜/금액 수치를 안내할 때는 반드시 calculate_wage 도구를
  호출해 계산된 값만 사용하세요. 직접 암산하지 마세요.
- 사용자가 이전 상담 맥락을 언급하거나 참고가 필요하면 get_user_history 도구를
  호출하세요.
- 가까운 상담·지원 기관이 필요하면 search_support_orgs 도구를 호출하세요.
- 법 조항이나 정부 안내 문서의 정확한 내용이 필요하면 search_reference_documents
  도구로 찾은 조각만 인용하세요. 조문을 직접 지어내지 마세요.
"""

_session_service = InMemorySessionService()


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


async def run_agent(
    *,
    message: str,
    uid: Optional[str],
    visa_group: Optional[str],
    lifecycle_stage: Optional[str],
) -> str:
    """Tools를 갖춘 Gemini 에이전트를 한 번 실행해 최종 답변 텍스트를 반환한다."""

    agent = Agent(
        name="local_bridge_agent",
        model=get_model_name(),
        instruction=_SYSTEM_INSTRUCTION,
        tools=build_tools(uid=uid),
        # 모델이 사고 과정(thought)을 함께 반환하게 한다 — 모델이 지원하지 않으면
        # 조용히 무시된다. _log_agent_event()가 이 부분만 로그로 남기고 사용자
        # 응답에는 포함하지 않는다.
        generate_content_config=types.GenerateContentConfig(
            thinking_config=types.ThinkingConfig(include_thoughts=True)
        ),
    )
    runner = Runner(agent=agent, app_name=_APP_NAME, session_service=_session_service)

    effective_uid = uid or "anonymous"
    session_id = uuid.uuid4().hex
    await _session_service.create_session(
        app_name=_APP_NAME, user_id=effective_uid, session_id=session_id
    )

    context_lines = []
    if visa_group:
        context_lines.append(f"체류자격: {visa_group}")
    if lifecycle_stage:
        context_lines.append(f"생애주기 단계: {lifecycle_stage}")
    context_prefix = f"[{' / '.join(context_lines)}]\n" if context_lines else ""

    new_message = types.Content(
        role="user", parts=[types.Part(text=context_prefix + message)]
    )

    final_text_parts: list[str] = []
    async for event in runner.run_async(
        user_id=effective_uid, session_id=session_id, new_message=new_message
    ):
        _log_agent_event(event)
        if event.is_final_response() and event.content and event.content.parts:
            final_text_parts = [part.text for part in event.content.parts if part.text]

    final_text = "".join(final_text_parts).strip()
    if not final_text:
        raise RuntimeError("에이전트가 최종 응답을 생성하지 못했습니다.")
    return final_text
