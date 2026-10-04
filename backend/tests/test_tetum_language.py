from unittest.mock import AsyncMock, patch

import pytest
from fastapi.testclient import TestClient

from app.main import app
from app.agent.pipeline import _LANGUAGE_NAMES
from app.services import chat_service


def test_tetum_language_reaches_agent_and_has_tetum_fallback(monkeypatch, chat_quota):
    monkeypatch.setattr(chat_service, "get_genai_client", lambda: None)
    monkeypatch.setattr(chat_service, "_fallback_orgs", lambda *args, **kwargs: [])
    agent = AsyncMock(side_effect=RuntimeError("unavailable"))
    monkeypatch.setattr(chat_service, "run_agent", agent)
    response = TestClient(app).post("/api/chat", json={
        "message": "Ha'u seidauk simu saláriu", "language": "tet",
    })
    assert response.status_code == 200
    assert agent.call_args.kwargs["language"] == "tet"
    assert response.json()["factAnswer"] == chat_service._CONTENT["wage"]["fact_answer"]["tet"]
    assert "Tetum" in _LANGUAGE_NAMES["tet"]


@pytest.mark.parametrize("message,intent", [
    ("Ha'u seidauk simu saláriu", "wage"),
    ("Ha'u kanek iha servisu", "accident"),
    ("Haree ha'u-nia kontratu servisu", "contract"),
    ("Oinsá loke konta banku?", "life_info"),
    ("Sentru apoiu besik iha ne'ebé?", "org_search"),
    ("Bondia", "meta"),
])
def test_tetum_keyword_fallback(message, intent):
    assert chat_service._classify_with_keywords(message) == intent


def test_all_tetum_static_chat_answers_exist():
    for entry in chat_service._CONTENT.values():
        for key in ("fact_answer", "risk_notice"):
            if entry[key] is not None:
                assert entry[key]["tet"].strip()


def test_location_forwards_tetum_language():
    class Response:
        def raise_for_status(self):
            pass

        def json(self):
            return {"display_name": "Suwon, Koreia do Sul"}

    with patch("httpx.AsyncClient.get", AsyncMock(return_value=Response())) as request:
        response = TestClient(app).post("/api/location/verify", json={
            "latitude": 37.2636, "longitude": 127.0286, "language": "tet",
        })
    assert response.status_code == 200
    assert request.call_args.kwargs["params"]["accept-language"] == "tet"
