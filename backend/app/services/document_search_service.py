"""Vertex AI Search 데이터스토어에서 임베딩된 문서를 검색한다.

법령·안내 문서를 미리 데이터스토어에 임포트해두면, 에이전트가 사용자 질문과
관련된 문서 조각(snippet)을 찾아와 프롬프트의 근거로 쓸 수 있다 — 이 모듈은
검색 결과를 그대로 반환할 뿐 문서 내용에 대한 판단을 섞지 않는다(법률 환각
방지 원칙: 에이전트가 원문을 지어내지 않고 여기서 찾은 조각만 인용하게 한다).
"""

import logging
from dataclasses import dataclass
from typing import List

from google.cloud import discoveryengine_v1 as discoveryengine

from ..core.discovery_engine_client import get_search_client, get_serving_config

logger = logging.getLogger(__name__)


@dataclass
class DocumentSnippet:
    title: str
    snippet: str
    link: str


def search_documents(query: str, *, page_size: int = 5) -> List[DocumentSnippet]:
    """데이터스토어가 설정되지 않았거나 호출이 실패하면 빈 목록을 반환한다 —
    호출부(agent.tools)가 예외 대신 "검색 결과 없음"으로 처리하게 하기 위함."""
    client = get_search_client()
    if client is None:
        return []

    request = discoveryengine.SearchRequest(
        serving_config=get_serving_config(),
        query=query,
        page_size=page_size,
        content_search_spec=discoveryengine.SearchRequest.ContentSearchSpec(
            snippet_spec=discoveryengine.SearchRequest.ContentSearchSpec.SnippetSpec(
                return_snippet=True,
            ),
        ),
    )

    try:
        response = client.search(request)
    except Exception:
        logger.exception("Vertex AI Search 호출 실패 — 빈 결과로 진행합니다.")
        return []

    results: List[DocumentSnippet] = []
    for result in response.results:
        data = result.document.derived_struct_data
        if not data:
            continue

        snippets = data.get("snippets") or []
        text = " ".join(s.get("snippet", "") for s in snippets if s.get("snippet"))
        if not text:
            extractive_answers = data.get("extractive_answers") or []
            text = " ".join(a.get("content", "") for a in extractive_answers if a.get("content"))
        if not text:
            continue

        results.append(
            DocumentSnippet(title=data.get("title", ""), snippet=text, link=data.get("link", ""))
        )
    return results
