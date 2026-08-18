from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_update_vault_status_without_firestore_returns_404():
    # user_service.update_vault_status()는 문서가 없거나(테스트 환경엔 Firestore
    # 자체가 없음) Firestore가 미설정이면 None을 돌려주고, 라우터는 404로 폴백한다
    # — get_my_profile()의 "프로필이 없습니다" 404와 동일한 취급.
    response = client.patch(
        "/api/users/me/vault",
        json={"contractStored": True},
    )
    assert response.status_code == 404


def test_update_vault_status_accepts_partial_body():
    # 두 필드 다 optional이므로 하나만 보내도 요청 자체는 검증을 통과해야 한다
    # (그 뒤 404가 나는 건 Firestore 미설정 때문이지 검증 실패가 아니다).
    response = client.patch("/api/users/me/vault", json={"payslipStored": False})
    assert response.status_code == 404
