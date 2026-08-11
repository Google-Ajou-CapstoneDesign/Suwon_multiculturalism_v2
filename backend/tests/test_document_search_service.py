from types import SimpleNamespace

from app.services import document_search_service


def _fake_result(data):
    return SimpleNamespace(document=SimpleNamespace(derived_struct_data=data))


def test_search_documents_extracts_snippets(monkeypatch):
    fake_response = SimpleNamespace(
        results=[
            _fake_result(
                {
                    "title": "근로기준법 제36조",
                    "link": "https://law.go.kr/법령/근로기준법/제36조",
                    "snippets": [{"snippet": "사용자는 퇴직 후 14일 이내에 임금을 지급해야 한다."}],
                }
            ),
            _fake_result({}),  # 발췌할 내용이 없는 결과는 건너뛴다
        ]
    )
    monkeypatch.setattr(document_search_service, "get_search_client", lambda: SimpleNamespace(search=lambda request: fake_response))
    monkeypatch.setattr(document_search_service, "get_serving_config", lambda: "fake-serving-config")

    results = document_search_service.search_documents("임금 지급기한")

    assert len(results) == 1
    assert results[0].title == "근로기준법 제36조"
    assert "14일 이내" in results[0].snippet


def test_search_documents_falls_back_to_extractive_answers(monkeypatch):
    fake_response = SimpleNamespace(
        results=[
            _fake_result(
                {
                    "title": "고용노동부 안내",
                    "link": "",
                    "extractive_answers": [{"content": "체불 임금은 진정 제기가 가능합니다."}],
                }
            ),
        ]
    )
    monkeypatch.setattr(document_search_service, "get_search_client", lambda: SimpleNamespace(search=lambda request: fake_response))
    monkeypatch.setattr(document_search_service, "get_serving_config", lambda: "fake-serving-config")

    results = document_search_service.search_documents("체불 진정")

    assert len(results) == 1
    assert "진정 제기" in results[0].snippet


def test_search_documents_returns_empty_when_datastore_unconfigured(monkeypatch):
    monkeypatch.setattr(document_search_service, "get_search_client", lambda: None)

    assert document_search_service.search_documents("아무 질문") == []


def test_search_documents_handles_search_call_failure(monkeypatch):
    def _raise(request):
        raise RuntimeError("network error")

    monkeypatch.setattr(document_search_service, "get_search_client", lambda: SimpleNamespace(search=_raise))
    monkeypatch.setattr(document_search_service, "get_serving_config", lambda: "fake-serving-config")

    assert document_search_service.search_documents("아무 질문") == []
