from types import SimpleNamespace

from app.schemas.chat import ChatRequest
from app.services import chat_service


async def test_keyword_fallback_used_when_genai_client_unavailable(monkeypatch):
    # 로컬/CI 기본 상태: genai 자격증명이 없으므로 get_genai_client()는 None을 반환해야 한다.
    monkeypatch.setattr(chat_service, "get_genai_client", lambda: None)

    response = await chat_service.answer(ChatRequest(message="산재로 다쳤어요 어떻게 하나요"))

    assert response.routing_target.module == "module3-accident"


async def test_genai_classification_result_drives_routing(monkeypatch):
    fake_parsed = chat_service.IntentClassification(intent="wage")
    fake_response = SimpleNamespace(parsed=fake_parsed)
    fake_models = SimpleNamespace(generate_content=lambda **_kwargs: fake_response)
    fake_client = SimpleNamespace(models=fake_models)

    monkeypatch.setattr(chat_service, "get_genai_client", lambda: fake_client)

    # 메시지 자체에는 키워드 규칙에 걸릴 단어가 없어도, genai 분류 결과를 따라야 한다.
    # (에이전트 호출은 테스트 환경에 GCP 자격증명이 없어 실패 → 정적 문구로 폴백하지만,
    #  이 테스트가 검증하는 라우팅 결과에는 영향이 없다.)
    response = await chat_service.answer(ChatRequest(message="지난달 돈을 못 받았어요"))

    assert response.routing_target.module == "module3-wage"


async def test_genai_exception_falls_back_to_keywords(monkeypatch):
    def _raise(**_kwargs):
        raise RuntimeError("network error")

    fake_models = SimpleNamespace(generate_content=_raise)
    fake_client = SimpleNamespace(models=fake_models)
    monkeypatch.setattr(chat_service, "get_genai_client", lambda: fake_client)

    response = await chat_service.answer(ChatRequest(message="근로계약서를 안 써줬어요"))

    assert response.routing_target.module == "module1"
    assert response.routing_target.category_id == "contract_check"


async def test_fallback_answer_follows_app_language_setting(monkeypatch):
    # genai/에이전트 둘 다 없는 테스트 환경 → 정적 폴백 문구로 응답한다.
    # 이때도 request.language(프론트엔드 앱 설정)를 따라야 한다 — 메시지 자체는
    # 한국어로 쓰여 있어도 답변은 language에 지정된 언어여야 한다.
    monkeypatch.setattr(chat_service, "get_genai_client", lambda: None)

    response = await chat_service.answer(
        ChatRequest(message="지난달 임금을 못 받았어요", language="en")
    )

    assert response.fact_answer == chat_service._CONTENT["wage"]["fact_answer"]["en"]
    assert response.fact_answer != chat_service._CONTENT["wage"]["fact_answer"]["ko"]
