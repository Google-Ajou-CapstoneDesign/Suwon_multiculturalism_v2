"""Firebase Admin SDK 초기화.

자격증명이 없으면 앱 시작을 막지 않고 None을 반환한다 — 로컬 개발 시
core.auth 모듈이 AUTH_DEV_BYPASS로 폴백할 수 있게 하기 위함이다.
"""

import json
import logging
import os
from functools import lru_cache
from typing import Optional

import firebase_admin
from firebase_admin import credentials

logger = logging.getLogger(__name__)


@lru_cache
def get_firebase_app() -> Optional[firebase_admin.App]:
    try:
        return firebase_admin.get_app()
    except ValueError:
        pass  # 아직 초기화되지 않음 — 아래에서 초기화 시도

    raw_json = os.getenv("FIREBASE_CREDENTIALS_JSON")
    cred_path = os.getenv("GOOGLE_APPLICATION_CREDENTIALS")

    if raw_json:
        cred = credentials.Certificate(json.loads(raw_json))
    elif cred_path and os.path.exists(cred_path):
        cred = credentials.Certificate(cred_path)
    else:
        logger.warning(
            "Firebase 자격증명이 설정되지 않았습니다 (FIREBASE_CREDENTIALS_JSON / "
            "GOOGLE_APPLICATION_CREDENTIALS 미설정). 인증·업로드 기능이 비활성화됩니다."
        )
        return None

    storage_bucket = os.getenv("FIREBASE_STORAGE_BUCKET")
    options = {"storageBucket": storage_bucket} if storage_bucket else None
    return firebase_admin.initialize_app(cred, options)
