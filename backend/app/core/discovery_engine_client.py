"""Vertex AI Search(Discovery Engine) 클라이언트 초기화.

문서를 데이터스토어에 미리 임포트해두면 임베딩 생성·색인은 GCP가 알아서
처리한다 — 이 클라이언트는 검색만 담당한다. 콘솔에서 데이터스토어를 만든 뒤
그걸 감싸는 검색 앱(엔진)을 만들어야 서빙 설정(serving config) 경로가 생긴다
(genai_client.py의 "설정 없으면 None" 폴백 원칙과 동일).

필요 환경변수:
  DISCOVERY_ENGINE_ID       — 검색 앱(엔진) ID. 미설정 시 검색 도구가 비활성화된다.
  DISCOVERY_ENGINE_LOCATION — 데이터스토어 리전. 기본값 "global".
"""

import os
from functools import lru_cache
from typing import Optional

from google.api_core.client_options import ClientOptions
from google.cloud import discoveryengine_v1 as discoveryengine


@lru_cache
def get_search_client() -> Optional[discoveryengine.SearchServiceClient]:
    if not os.getenv("GOOGLE_CLOUD_PROJECT") or not os.getenv("DISCOVERY_ENGINE_ID"):
        return None

    location = os.getenv("DISCOVERY_ENGINE_LOCATION", "global")
    client_options = (
        ClientOptions(api_endpoint=f"{location}-discoveryengine.googleapis.com")
        if location != "global"
        else None
    )
    return discoveryengine.SearchServiceClient(client_options=client_options)


def get_serving_config() -> str:
    project = os.getenv("GOOGLE_CLOUD_PROJECT")
    location = os.getenv("DISCOVERY_ENGINE_LOCATION", "global")
    engine_id = os.getenv("DISCOVERY_ENGINE_ID")
    return (
        f"projects/{project}/locations/{location}/collections/default_collection/"
        f"engines/{engine_id}/servingConfigs/default_config"
    )
