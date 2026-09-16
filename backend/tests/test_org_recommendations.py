from types import SimpleNamespace

from app.schemas.org import Org
from app.services import org_service


def test_relevance_order_survives_distance_and_details_reach_json(monkeypatch):
    records = [
        {"name": "Best match", "latitude": 36.0, "longitude": 127.0,
         "address": "Full address", "phone_number": "031-123-4567", "business_hours": "09:00-18:00"},
        {"name": "Nearer second match", "latitude": 37.26, "longitude": 127.0},
    ]
    monkeypatch.setattr(org_service, "_load_all_orgs", lambda: records)
    monkeypatch.setattr(org_service, "_rerank_with_genai", lambda *args: records)
    result = org_service.find_relevant_orgs("help", lat=37.26, lng=127.0)
    assert [r["name"] for r in result] == [r["name"] for r in records]
    assert result[0]["distance_km"] > result[1]["distance_km"]
    payload = Org.model_validate(result[0]).model_dump(by_alias=True)
    assert payload["address"] == "Full address"
    assert payload["phoneNumber"] == "031-123-4567"
    assert payload["businessHours"] == "09:00-18:00"
    fallback = org_service.list_orgs()
    assert fallback[0].address == "Full address"
    assert fallback[1].phone_number is None


def test_top_two_deduplicates_model_results(monkeypatch):
    records = [{"name": name} for name in ["A", "B", "C"]]
    parsed = org_service._RelevantOrgNames(org_names=["B", "B", "missing", "A", "C"])
    client = SimpleNamespace(models=SimpleNamespace(generate_content=lambda **kwargs:
        SimpleNamespace(parsed=parsed)))
    monkeypatch.setattr(org_service, "get_genai_client", lambda: client)
    assert [r["name"] for r in org_service._rerank_with_genai("help", records, 2)] == ["B", "A"]
