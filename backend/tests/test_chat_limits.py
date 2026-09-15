import asyncio
from datetime import datetime
from unittest.mock import AsyncMock

import pytest
from fastapi import HTTPException
from fastapi.testclient import TestClient
from pydantic import ValidationError
from starlette.requests import Request

from app.main import app
from app.core.auth import CurrentUser
from app.routers import chat
from app.schemas.chat import ChatRequest
from app.services.chat_limits import KST, client_ip, get_chat_limiter, reserve_state

NOW = datetime(2026, 9, 15, 12, tzinfo=KST).timestamp()


def reserve(actor=None, ip=None, signed_in=False, now=NOW):
    return reserve_state(actor or {}, ip or {}, signed_in=signed_in, now=now, lease="new")


@pytest.mark.parametrize("signed_in,gap,minute,maximum", [(False, 5, 5, 10), (True, 3, 10, 50)])
def test_actor_limits(signed_in, gap, minute, maximum):
    actor, ip = reserve(signed_in=signed_in)
    with pytest.raises(HTTPException) as error:
        reserve(actor, ip, signed_in=signed_in, now=NOW + 1)
    assert error.value.detail["reason"] == "in_flight"
    actor["lease_until"] = 0
    with pytest.raises(HTTPException) as error:
        reserve(actor, ip, signed_in=signed_in, now=NOW + gap - .1)
    assert error.value.detail["reason"] == "cooldown"
    for i in range(1, minute):
        actor, ip = reserve(actor, ip, signed_in=signed_in, now=NOW + i * gap)
        actor["lease_until"] = 0
    with pytest.raises(HTTPException) as error:
        reserve(actor, ip, signed_in=signed_in, now=NOW + minute * gap)
    assert error.value.detail["reason"] == "minute"
    actor, ip = reserve(actor, ip, signed_in=signed_in, now=NOW + 60)
    assert actor["daily"] == minute + 1
    actor.update(daily=maximum, lease_until=0)
    with pytest.raises(HTTPException) as error:
        reserve(actor, ip, signed_in=signed_in, now=NOW + 120)
    assert error.value.detail["reason"] == "daily"
    assert int(error.value.headers["Retry-After"]) == 12 * 3600 - 120


def test_ip_limit_and_kst_midnight():
    with pytest.raises(HTTPException) as error:
        reserve(ip={"recent": [NOW - 1] * 60}, signed_in=True)
    assert error.value.detail["reason"] == "ip_minute"
    midnight = datetime(2026, 9, 16, tzinfo=KST).timestamp()
    actor, ip = reserve(now=midnight - 1)
    actor.update(daily=10, lease_until=0)
    # Midnight clears only daily counts: burst protection remains active.
    with pytest.raises(HTTPException) as error:
        reserve(actor, ip, now=midnight)
    assert error.value.detail["reason"] == "cooldown"
    actor, _ = reserve(actor, ip, now=midnight + 4)
    assert actor["daily"] == 1


@pytest.mark.parametrize("payload", [
    {"message": " "}, {"message": "x" * 2001},
    {"message": "x", "history": [{"role": "user", "text": "x"}] * 7},
    {"message": "x", "history": [{"role": "assistant", "text": "x" * 12000}]},
])
def test_input_budget(payload):
    with pytest.raises(ValidationError):
        ChatRequest.model_validate(payload)


def test_client_ip_ignores_spoofed_prefix(monkeypatch):
    request = Request({"type": "http", "client": ("192.0.2.1", 123),
        "headers": [(b"x-forwarded-for", b"6.6.6.6, 203.0.113.8")]})
    monkeypatch.setenv("CHAT_TRUSTED_PROXY_HOPS", "0")
    assert client_ip(request) == "192.0.2.1"
    monkeypatch.setenv("CHAT_TRUSTED_PROXY_HOPS", "1")
    assert client_ip(request) == "203.0.113.8"


def test_rejection_precedes_ai_and_storage_outage_fails_closed(monkeypatch):
    answer = AsyncMock()
    monkeypatch.setattr(chat.chat_service, "answer", answer)

    class Limiter:
        def reserve(self, uid, ip):
            raise HTTPException(429, detail={"reason": "daily"}, headers={"Retry-After": "10"})

    app.dependency_overrides[get_chat_limiter] = Limiter
    try:
        client = TestClient(app, client=("127.0.0.1", 123))
        response = client.post("/api/chat", json={"message": "hello"})
        assert response.status_code == 429
        assert response.headers["retry-after"] == "10"
        answer.assert_not_called()
        def unavailable(*args):
            raise RuntimeError("offline")
        monkeypatch.setattr(Limiter, "reserve", unavailable)
        assert client.post("/api/chat", json={"message": "hello"}).status_code == 503
        answer.assert_not_called()
    finally:
        app.dependency_overrides.pop(get_chat_limiter, None)


def test_timeout_releases_lease(monkeypatch):
    released = []
    class Limiter:
        def reserve(self, uid, ip):
            return "reservation"
        def release(self, reservation):
            released.append(reservation)
    async def slow(*args, **kwargs):
        await asyncio.sleep(1)
    monkeypatch.setattr(chat, "AI_TIMEOUT_SECONDS", .01)
    monkeypatch.setattr(chat.chat_service, "answer", slow)
    app.dependency_overrides[get_chat_limiter] = Limiter
    try:
        response = TestClient(app, client=("127.0.0.1", 123)).post("/api/chat", json={"message": "hello"})
        assert response.status_code == 504
        assert released == ["reservation"]
    finally:
        app.dependency_overrides.pop(get_chat_limiter, None)


def test_invalid_token_is_not_downgraded_to_guest(monkeypatch):
    async def invalid(**kwargs):
        raise HTTPException(401, "Invalid token")
    monkeypatch.setattr(chat, "get_current_user", invalid)
    answer = AsyncMock()
    monkeypatch.setattr(chat.chat_service, "answer", answer)
    response = TestClient(app, client=("127.0.0.1", 123)).post(
        "/api/chat", json={"message": "hello"}, headers={"Authorization": "Bearer invalid"})
    assert response.status_code == 401
    answer.assert_not_called()


def test_verified_uid_is_used_for_quota_and_answer(monkeypatch):
    from app.schemas.chat import ChatResponse
    seen = []
    class Limiter:
        def reserve(self, uid, ip):
            seen.append((uid, ip))
            return "lease"
        def release(self, reservation):
            pass
    monkeypatch.setattr(chat, "get_current_user", AsyncMock(return_value=CurrentUser("verified-user")))
    answer = AsyncMock(return_value=ChatResponse(fact_answer="ok"))
    monkeypatch.setattr(chat.chat_service, "answer", answer)
    app.dependency_overrides[get_chat_limiter] = Limiter
    try:
        response = TestClient(app, client=("127.0.0.1", 123)).post(
            "/api/chat", json={"message": "hello"}, headers={"Authorization": "Bearer valid"})
        assert response.status_code == 200
        assert seen == [("verified-user", "127.0.0.1")]
        assert answer.call_args.kwargs["uid"] == "verified-user"
    finally:
        app.dependency_overrides.pop(get_chat_limiter, None)


def test_parallel_reservations_and_stale_release(monkeypatch):
    """Exercise the store adapter with serialized transactions, without live writes."""
    from concurrent.futures import ThreadPoolExecutor
    from threading import Lock
    from app.services import chat_limits
    data = {}
    lock = Lock()
    class Snapshot:
        def __init__(self, value):
            self.value = value
        def to_dict(self):
            return self.value.copy()
    class Ref:
        def __init__(self, identity):
            self.id = identity
        def get(self, **kwargs):
            return Snapshot(data.get(self.id, {}))
    class Transaction:
        def set(self, ref, value):
            data[ref.id] = value.copy()
        def update(self, ref, value):
            data[ref.id].update(value)
    class DB:
        def collection(self, name):
            assert name == "chat_limits"
            return self
        def document(self, identity):
            return Ref(identity)
        def transaction(self, **kwargs):
            return Transaction()
    def transactional(fn):
        def invoke(transaction):
            with lock:
                return fn(transaction)
        return invoke
    limiter = chat_limits.FirestoreChatLimiter()
    monkeypatch.setattr(limiter, "_db", DB)
    monkeypatch.setattr(chat_limits.firestore, "transactional", transactional)
    monkeypatch.setattr(chat_limits.time, "time", lambda: NOW)
    def attempt(_):
        try:
            return limiter.reserve("user", "127.0.0.1")
        except HTTPException as exc:
            return exc.status_code
    with ThreadPoolExecutor(max_workers=2) as pool:
        results = list(pool.map(attempt, range(2)))
    assert results.count(429) == 1
    reservation = next(result for result in results if result != 429)
    actor = data[reservation[0]]
    assert actor["daily"] == 1
    limiter.release((reservation[0], "old-lease"))
    assert actor["lease_until"] > NOW
    limiter.release(reservation)
    assert actor["lease_until"] == 0
    assert actor["daily"] == 1
