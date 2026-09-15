from unittest.mock import AsyncMock, patch

from fastapi.testclient import TestClient

from app.main import app
from app.agent.pipeline import _LANGUAGE_NAMES
from app.services import chat_service


def test_uzbek_chat_reaches_agent_and_has_translated_fallback(monkeypatch, chat_quota):
    monkeypatch.setattr(chat_service, "get_genai_client", lambda: None)
    monkeypatch.setattr(chat_service, "_fallback_orgs", lambda *args, **kwargs: [])
    agent = AsyncMock(side_effect=RuntimeError("unavailable"))
    monkeypatch.setattr(chat_service, "run_agent", agent)
    response = TestClient(app).post("/api/chat", json={"message": "임금체불", "language": "uz"})
    assert response.status_code == 200
    assert agent.call_args.kwargs["language"] == "uz"
    assert "ish haqi" in response.json()["factAnswer"]
    assert "Latin" in _LANGUAGE_NAMES["uz"]


def test_uzbek_location_language_is_forwarded():
    class Response:
        def raise_for_status(self):
            pass

        def json(self):
            return {"display_name": "Suvon, Koreya Respublikasi"}

    with patch("httpx.AsyncClient.get", AsyncMock(return_value=Response())) as request:
        response = TestClient(app).post("/api/location/verify", json={
            "latitude": 37.2636, "longitude": 127.0286, "language": "uz",
        })
    assert response.status_code == 200
    assert response.json()["address"] == "Suvon, Koreya Respublikasi"
    assert request.call_args.kwargs["params"]["accept-language"] == "uz"


def test_all_static_chat_answers_include_uzbek():
    for entry in chat_service._CONTENT.values():
        for field in ("fact_answer", "risk_notice"):
            text = entry[field]
            if text is not None:
                assert text["uz"].strip()
