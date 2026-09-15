import os

# 테스트에서는 Firebase 자격증명 없이 인증 우회 모드로 동작한다.
# 앱 모듈이 import되기 전에 설정되어야 하므로 conftest 최상단에 둔다.
os.environ.setdefault("AUTH_DEV_BYPASS", "true")

import pytest


@pytest.fixture
def chat_quota(monkeypatch):
    """Isolate ordinary chat tests from the real quota database."""
    from app.main import app
    from app.routers import chat
    from app.services.chat_limits import get_chat_limiter

    class Limiter:
        def reserve(self, uid, ip):
            return ("test", "lease")

        def release(self, reservation):
            pass

    app.dependency_overrides[get_chat_limiter] = Limiter
    monkeypatch.setattr(chat, "client_ip", lambda request: "127.0.0.1")
    yield
    app.dependency_overrides.pop(get_chat_limiter, None)
