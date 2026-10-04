from unittest.mock import AsyncMock, patch

import pytest
from fastapi.testclient import TestClient

from app.main import app
from app.agent.pipeline import _LANGUAGE_NAMES
from app.services import chat_service


def test_nepali_request_reaches_agent_and_uses_nepali_fallback(monkeypatch, chat_quota):
    monkeypatch.setattr(chat_service, "get_genai_client", lambda: None)
    monkeypatch.setattr(chat_service, "_fallback_orgs", lambda *args, **kwargs: [])
    agent = AsyncMock(side_effect=RuntimeError("unavailable"))
    monkeypatch.setattr(chat_service, "run_agent", agent)
    response = TestClient(app).post("/api/chat", json={
        "message": "मैले तलब पाएको छैन", "language": "ne",
    })
    assert response.status_code == 200
    assert agent.call_args.kwargs["language"] == "ne"
    assert any("\u0900" <= c <= "\u097f" for c in response.json()["factAnswer"])
    assert "Nepali" in _LANGUAGE_NAMES["ne"]


@pytest.mark.parametrize("message,intent", [
    ("मैले तलब पाएको छैन", "wage"),
    ("काम गर्दा घाइते भएँ", "accident"),
    ("रोजगार सम्झौता जाँच गर्न चाहन्छु", "contract"),
    ("बैंक खाता कसरी खोल्ने?", "life_info"),
    ("नजिकको सहायता केन्द्र कहाँ छ?", "org_search"),
    ("नमस्ते", "meta"),
])
def test_nepali_keyword_fallback(message, intent):
    assert chat_service._classify_with_keywords(message) == intent


def test_nepali_static_answers_are_complete():
    for entry in chat_service._CONTENT.values():
        for key in ("fact_answer", "risk_notice"):
            if entry[key] is not None:
                text = entry[key]["ne"]
                assert text.strip()
                assert any("\u0900" <= c <= "\u097f" for c in text)


def test_location_forwards_nepali_language():
    class Response:
        def raise_for_status(self):
            pass

        def json(self):
            return {"display_name": "सुवन, दक्षिण कोरिया"}

    with patch("httpx.AsyncClient.get", AsyncMock(return_value=Response())) as request:
        response = TestClient(app).post("/api/location/verify", json={
            "latitude": 37.2636, "longitude": 127.0286, "language": "ne",
        })
    assert response.status_code == 200
    assert response.json()["address"] == "सुवन, दक्षिण कोरिया"
    assert request.call_args.kwargs["params"]["accept-language"] == "ne"
