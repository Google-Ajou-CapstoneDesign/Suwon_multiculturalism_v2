import logging

from google.adk.events import Event
from google.genai import types

from app.agent.pipeline import _log_agent_event


def test_logs_thought_parts(caplog):
    event = Event(
        author="local_bridge_agent",
        content=types.Content(
            role="model",
            parts=[types.Part(text="사용자가 임금체불을 물었으니 calculate_wage를 써야겠다.", thought=True)],
        ),
    )

    with caplog.at_level(logging.INFO, logger="app.agent.pipeline"):
        _log_agent_event(event)

    assert any("사고 과정" in r.message for r in caplog.records)


def test_logs_function_call_and_response(caplog):
    call_event = Event(
        author="local_bridge_agent",
        content=types.Content(
            role="model",
            parts=[types.Part(function_call=types.FunctionCall(name="calculate_wage", args={"unpaid_amount": 500000}))],
        ),
    )
    response_event = Event(
        author="local_bridge_agent",
        content=types.Content(
            role="user",
            parts=[types.Part(function_response=types.FunctionResponse(name="calculate_wage", response={"is_overdue": True}))],
        ),
    )

    with caplog.at_level(logging.INFO, logger="app.agent.pipeline"):
        _log_agent_event(call_event)
        _log_agent_event(response_event)

    messages = [r.message for r in caplog.records]
    assert any("도구 호출" in m and "calculate_wage" in m for m in messages)
    assert any("도구 결과" in m and "calculate_wage" in m for m in messages)


def test_no_log_for_plain_final_answer(caplog):
    event = Event(
        author="local_bridge_agent",
        content=types.Content(role="model", parts=[types.Part(text="답변입니다.")]),
    )

    with caplog.at_level(logging.INFO, logger="app.agent.pipeline"):
        _log_agent_event(event)

    assert caplog.records == []
