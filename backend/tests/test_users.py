from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_upsert_profile_without_firestore_returns_503():
    # 테스트 환경엔 Firebase 자격증명이 없으므로(conftest AUTH_DEV_BYPASS만 켜둠)
    # user_service.upsert_user()가 None을 돌려주고, 라우터는 503으로 폴백해야 한다 —
    # 500(원인불명 에러)이 아니라 "Firestore 미설정"이라는 구체적인 상태로.
    response = client.put(
        "/api/users/me",
        json={"name": "홍길동", "visaType": "E-9", "nationality": "VN", "preferredLanguage": "ko"},
    )
    assert response.status_code == 503


def test_get_profile_without_firestore_returns_404():
    response = client.get("/api/users/me")
    assert response.status_code == 404
