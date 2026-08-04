from types import SimpleNamespace

from app.schemas.chat import ChatRequest
from app.services import chat_service


def test_keyword_fallback_used_when_genai_client_unavailable(monkeypatch):
    # 로컬/CI 기본 상태: genai 자격증명이 없으므로 get_genai_client()는 None을 반환해야 한다.
    monkeypatch.setattr(chat_service, "get_genai_client", lambda: None)

    response = chat_service.answer(ChatRequest(message="산재로 다쳤어요 어떻게 하나요"))

    assert response.routing_target.module == "module3-accident"


def test_genai_classification_result_drives_routing(monkeypatch):
    fake_parsed = chat_service.IntentClassification(intent="wage")
    fake_response = SimpleNamespace(parsed=fake_parsed)
    fake_models = SimpleNamespace(generate_content=lambda **_kwargs: fake_response)
    fake_client = SimpleNamespace(models=fake_models)

    monkeypatch.setattr(chat_service, "get_genai_client", lambda: fake_client)

    # 메시지 자체에는 키워드 규칙에 걸릴 단어가 없어도, genai 분류 결과를 따라야 한다.
    response = chat_service.answer(ChatRequest(message="지난달 돈을 못 받았어요"))

    assert response.routing_target.module == "module3-wage"


def test_genai_exception_falls_back_to_keywords(monkeypatch):
    def _raise(**_kwargs):
        raise RuntimeError("network error")

    fake_models = SimpleNamespace(generate_content=_raise)
    fake_client = SimpleNamespace(models=fake_models)
    monkeypatch.setattr(chat_service, "get_genai_client", lambda: fake_client)

    response = chat_service.answer(ChatRequest(message="근로계약서를 안 써줬어요"))

    assert response.routing_target.module == "module1"
    assert response.routing_target.category_id == "contract_check"
