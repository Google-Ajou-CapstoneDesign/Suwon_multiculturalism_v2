from unittest.mock import AsyncMock, patch

import pytest
from fastapi.testclient import TestClient

from app.main import app
from app.agent.pipeline import _LANGUAGE_NAMES
from app.schemas.chat import ChatRequest
from app.services import chat_service


LANGUAGES = ("lo", "mn", "my", "bn", "si", "id", "km", "ky", "th", "ur", "fil", "tg")
WAGE_MESSAGES = {
    "lo": "ຄ່າຈ້າງ", "mn": "цалин", "my": "လစာ", "bn": "বেতন",
    "si": "වැටුප්", "id": "gaji", "km": "ប្រាក់ឈ្នួល", "ky": "эмгек акы",
    "th": "ค่าจ้าง", "ur": "تنخواہ", "fil": "sahod", "tg": "музди меҳнат",
}


@pytest.mark.parametrize("language", LANGUAGES)
def test_selected_language_reaches_agent_and_fallback(language, monkeypatch, chat_quota):
    monkeypatch.setattr(chat_service, "get_genai_client", lambda: None)
    monkeypatch.setattr(chat_service, "_fallback_orgs", lambda *args, **kwargs: [])
    agent = AsyncMock(side_effect=RuntimeError("unavailable"))
    monkeypatch.setattr(chat_service, "run_agent", agent)
    response = TestClient(app).post("/api/chat", json={
        "message": WAGE_MESSAGES[language], "language": language,
    })
    assert response.status_code == 200
    assert agent.call_args.kwargs["language"] == language
    assert response.json()["factAnswer"] == chat_service._CONTENT["wage"]["fact_answer"][language]
    assert _LANGUAGE_NAMES[language]


@pytest.mark.parametrize("language", LANGUAGES)
def test_localized_static_answers_and_keywords(language):
    assert ChatRequest(message="test", language=language).language == language
    assert chat_service._classify_with_keywords(WAGE_MESSAGES[language]) == "wage"
    for entry in chat_service._CONTENT.values():
        for key in ("fact_answer", "risk_notice"):
            if entry[key] is not None:
                assert entry[key][language].strip()


@pytest.mark.parametrize("language", LANGUAGES)
def test_location_uses_selected_language(language):
    class Response:
        def raise_for_status(self):
            pass

        def json(self):
            return {"display_name": "Suwon"}

    with patch("httpx.AsyncClient.get", AsyncMock(return_value=Response())) as request:
        response = TestClient(app).post("/api/location/verify", json={
            "latitude": 37.2636, "longitude": 127.0286, "language": language,
        })
    assert response.status_code == 200
    assert request.call_args.kwargs["params"]["accept-language"] == language
