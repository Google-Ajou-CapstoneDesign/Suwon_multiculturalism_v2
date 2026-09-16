from io import BytesIO
from types import SimpleNamespace
from unittest.mock import Mock

import pytest
from fastapi import UploadFile
from fastapi.testclient import TestClient
from firebase_admin import storage
from google.api_core.exceptions import Forbidden, NotFound

from app.main import app
from app.core.auth import CurrentUser, get_current_user
from app.services import storage_service


def test_missing_bucket_returns_503_before_upload(monkeypatch):
    monkeypatch.delenv("FIREBASE_STORAGE_BUCKET", raising=False)
    monkeypatch.setattr(storage_service, "get_firebase_app", lambda: SimpleNamespace(options={}))
    bucket = Mock()
    monkeypatch.setattr(storage, "bucket", bucket)
    app.dependency_overrides[get_current_user] = lambda: CurrentUser("test-user")
    try:
        response = TestClient(app).post("/api/uploads?case_type=contract",
            files={"file": ("contract.txt", b"test", "text/plain")})
        assert response.status_code == 503
        assert "FIREBASE_STORAGE_BUCKET" in response.json()["detail"]
        bucket.assert_not_called()
    finally:
        app.dependency_overrides.pop(get_current_user, None)


@pytest.mark.parametrize("configured_env,options,expected", [
    ("actual-bucket", {}, "actual-bucket"),
    ("override-bucket", {"storageBucket": "old-bucket"}, "override-bucket"),
    ("", {"storageBucket": "app-bucket"}, "app-bucket"),
])
async def test_explicit_bucket_and_app_fallback(monkeypatch, configured_env, options, expected):
    monkeypatch.setenv("FIREBASE_STORAGE_BUCKET", configured_env)
    app_instance = SimpleNamespace(options=options)
    monkeypatch.setattr(storage_service, "get_firebase_app", lambda: app_instance)
    bucket = Mock()
    monkeypatch.setattr(storage, "bucket", bucket)
    result = await storage_service.save_evidence_file(
        UploadFile(filename="contract.txt", file=BytesIO(b"test")), uid="user", case_type="contract")
    bucket.assert_called_once_with(name=expected, app=app_instance)
    bucket.return_value.blob.return_value.upload_from_string.assert_called_once()
    assert result["stored_path"].startswith("evidence/user/contract/")
    assert result["size_bytes"] == 4


@pytest.mark.parametrize("failure", [NotFound("missing"), Forbidden("denied")])
def test_storage_configuration_failures_do_not_record_success(monkeypatch, failure):
    from app.services import evidence_service
    monkeypatch.setenv("FIREBASE_STORAGE_BUCKET", "test-bucket")
    monkeypatch.setattr(storage_service, "get_firebase_app", lambda: SimpleNamespace(options={}))
    bucket = Mock()
    bucket.return_value.blob.return_value.upload_from_string.side_effect = failure
    monkeypatch.setattr(storage, "bucket", bucket)
    record = Mock()
    monkeypatch.setattr(evidence_service, "record_evidence_file", record)
    app.dependency_overrides[get_current_user] = lambda: CurrentUser("test-user")
    try:
        response = TestClient(app).post("/api/uploads?case_type=contract",
            files={"file": ("contract.txt", b"test", "text/plain")})
        assert response.status_code == 503
        assert response.json()["detail"]
        record.assert_not_called()
    finally:
        app.dependency_overrides.pop(get_current_user, None)
