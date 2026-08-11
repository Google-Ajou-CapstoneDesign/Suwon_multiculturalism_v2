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
from typing import Optional

from google import genai

logger = logging.getLogger(__name__)


@lru_cache
def get_genai_client() -> Optional[genai.Client]:
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
        return genai.Client(vertexai=True, project=project, location=location)

    api_key = os.getenv("GEMINI_API_KEY")
    if not api_key:
        logger.warning(
            "GEMINI_API_KEY가 설정되지 않아 genai 클라이언트를 만들 수 없습니다. "
            "챗봇은 키워드 규칙 기반으로만 동작합니다."
        )
        return None
    return genai.Client(api_key=api_key)


def get_model_name() -> str:
    return os.getenv("GENAI_MODEL", "gemini-3.5-flash")
