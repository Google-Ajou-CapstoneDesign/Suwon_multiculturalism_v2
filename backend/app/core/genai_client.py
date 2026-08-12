"""google-genai SDK 클라이언트 초기화.

Cloud Run 배포 시에는 Vertex AI 모드(GOOGLE_GENAI_USE_VERTEXAI=true)를 기본으로 쓴다 —
이 모드는 Cloud Run 서비스 계정의 ADC로 인증되므로 API 키를 별도로 관리할 필요가 없다
(서비스 계정에 roles/aiplatform.user만 부여하면 된다). 로컬 개발 등 Vertex AI 프로젝트가
없는 환경에서는 GEMINI_API_KEY를 쓰는 Developer API 모드로 폴백할 수 있다.

설정이 없으면 None을 반환한다 — 호출부(services/chat_service.py)가 규칙 기반
분류로 폴백하게 하기 위함이다(firebase.py의 get_firebase_app()과 동일한 패턴).

주의: vertexai=True 로 만든 클라이언트는 AI Studio(generativelanguage.googleapis.com,
API 키 과금)가 아니라 Vertex AI API(<location>-aiplatform.googleapis.com, ADC 인증 ·
GCP 프로젝트 과금·크레딧 적용)를 호출한다 — google-genai SDK 내부(_api_client.py)에서
vertexai 플래그로 base_url 자체가 갈린다. 즉 로컬에서 GCP 크레딧을 쓰려면 GEMINI_API_KEY를
쓰지 말고 GOOGLE_CLOUD_PROJECT만 채운 뒤 `gcloud auth application-default login`으로
ADC를 발급하면 된다.
"""

import logging
import os
from functools import lru_cache
from typing import Any, Dict, Optional

from google import genai

logger = logging.getLogger(__name__)


def resolve_client_kwargs() -> Optional[Dict[str, Any]]:
    """genai.Client(**kwargs)에 넘길 인자를 환경변수로부터 결정한다.

    get_genai_client()와 agent/pipeline.py(ADK 에이전트)가 동일한 규칙을
    공유하기 위한 함수다 — ADK의 Gemini 모델 래퍼는 모델 이름 문자열만 주면
    이 규칙을 전혀 모르고 google-genai 자체 기본값(GOOGLE_GENAI_USE_VERTEXAI
    환경변수가 없으면 Developer API/API 키 모드)으로 클라이언트를 만들어버린다.
    그러면 GOOGLE_CLOUD_PROJECT/LOCATION은 배포 환경에 설정돼 있어도
    GOOGLE_GENAI_USE_VERTEXAI 하나만 빠뜨려도 에이전트 쪽만 "No API key was
    provided" 에러로 조용히 실패한다 — 그래서 반드시 kwargs를 명시적으로
    만들어 넘겨야 한다.

    설정이 부족하면 None을 반환한다.
    """
    use_vertexai = os.getenv("GOOGLE_GENAI_USE_VERTEXAI", "true").lower() == "true"

    if use_vertexai:
        project = os.getenv("GOOGLE_CLOUD_PROJECT")
        location = os.getenv("GOOGLE_CLOUD_LOCATION", "us-central1")
        if not project:
            logger.warning(
                "GOOGLE_CLOUD_PROJECT가 설정되지 않아 Vertex AI 모드를 쓸 수 없습니다. "
                "챗봇은 키워드 규칙 기반으로만 동작합니다."
            )
            return None
        return {"vertexai": True, "project": project, "location": location}

    api_key = os.getenv("GEMINI_API_KEY")
    if not api_key:
        logger.warning(
            "GEMINI_API_KEY가 설정되지 않아 genai 클라이언트를 만들 수 없습니다. "
            "챗봇은 키워드 규칙 기반으로만 동작합니다."
        )
        return None
    return {"vertexai": False, "api_key": api_key}


@lru_cache
def get_genai_client() -> Optional[genai.Client]:
    kwargs = resolve_client_kwargs()
    if kwargs is None:
        return None
    return genai.Client(**kwargs)


def get_model_name() -> str:
    return os.getenv("GENAI_MODEL", "gemini-3.5-flash")
