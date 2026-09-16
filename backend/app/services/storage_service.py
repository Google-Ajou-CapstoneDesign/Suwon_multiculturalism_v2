"""증빙 파일 업로드. 원본을 그대로 Firebase Storage에 저장할 뿐 OCR·내용 분석은
하지 않는다 — 증빙의 유·불리를 시스템이 판단하지 않는다는 안전 원칙 때문이다.
"""

import os
import uuid
from datetime import datetime, timezone

from fastapi import UploadFile
from google.api_core.exceptions import Forbidden, NotFound

from ..core.firebase import get_firebase_app


class StorageNotConfiguredError(RuntimeError):
    pass


async def save_evidence_file(file: UploadFile, *, uid: str, case_type: str) -> dict:
    app = get_firebase_app()
    if app is None:
        raise StorageNotConfiguredError("Firebase Storage가 설정되지 않았습니다.")

    from firebase_admin import storage  # 앱 미초기화 시 임포트 비용을 피하기 위한 지연 임포트

    # Explicit env override also works when another module initialized the app
    # without storageBucket. Never infer a bucket name from the project ID.
    bucket_name = (os.getenv("FIREBASE_STORAGE_BUCKET") or "").strip()
    bucket_name = bucket_name or app.options.get("storageBucket")
    if not bucket_name or not bucket_name.strip():
        raise StorageNotConfiguredError(
            "파일 저장소가 설정되지 않았습니다. 서버의 FIREBASE_STORAGE_BUCKET 설정을 확인해 주세요."
        )
    bucket = storage.bucket(name=bucket_name.strip(), app=app)
    file_id = uuid.uuid4().hex
    timestamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    blob_path = f"evidence/{uid}/{case_type}/{timestamp}_{file_id}_{file.filename}"

    contents = await file.read()
    blob = bucket.blob(blob_path)
    try:
        blob.upload_from_string(contents, content_type=file.content_type)
    except NotFound as exc:
        raise StorageNotConfiguredError(
            "파일 저장소를 찾을 수 없습니다. 서버의 FIREBASE_STORAGE_BUCKET과 실제 버킷 존재 여부를 확인해 주세요."
        ) from exc
    except Forbidden as exc:
        raise StorageNotConfiguredError(
            "파일 저장소에 접근할 수 없습니다. 서버 서비스 계정의 Storage 접근 권한을 확인해 주세요."
        ) from exc
    # TODO(backend/P1): 버킷 기본 암호화 외 추가 KMS 암호화 필요 여부 확인.

    return {
        "file_id": file_id,
        "stored_path": blob_path,
        "content_type": file.content_type or "application/octet-stream",
        "size_bytes": len(contents),
    }
