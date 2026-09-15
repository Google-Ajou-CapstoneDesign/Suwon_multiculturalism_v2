"""Cross-instance chat quotas. Reservations are never refunded on cancellation."""

import hashlib
import ipaddress
import logging
import math
import os
import time
import uuid
from datetime import datetime, timedelta, timezone

from fastapi import HTTPException, Request
from firebase_admin import firestore

from ..core.firebase import get_firebase_app

logger = logging.getLogger(__name__)
KST = timezone(timedelta(hours=9))
AI_TIMEOUT_SECONDS = 60
LEASE_SECONDS = 90


def client_ip(request: Request) -> str:
    # Cloud Run appends its observed peer to XFF. Never use the spoofable first
    # entry. Additional proxies require an explicit, ingress-enforced hop count.
    hops = int(os.getenv("CHAT_TRUSTED_PROXY_HOPS", "1" if os.getenv("K_SERVICE") else "0"))
    if hops:
        chain = ",".join(request.headers.getlist("x-forwarded-for")).split(",")
        if len(chain) < hops:
            raise HTTPException(400, "Missing trusted client IP")
        value = chain[-hops].strip()
    else:
        value = request.client.host if request.client else ""
    try:
        address = ipaddress.ip_address(value)
        if isinstance(address, ipaddress.IPv6Address) and address.ipv4_mapped:
            address = address.ipv4_mapped
        return str(address)
    except ValueError as exc:
        raise HTTPException(400, "Invalid client IP") from exc


def reject(reason: str, wait: float):
    seconds = max(1, math.ceil(wait))
    raise HTTPException(429, detail={"code": "chat_rate_limited", "reason": reason,
                                    "retryAfterSeconds": seconds},
                        headers={"Retry-After": str(seconds)})


def reserve_state(actor: dict, ip: dict, *, signed_in: bool, now: float, lease: str):
    """Pure quota decision, called inside a Firestore transaction."""
    local = datetime.fromtimestamp(now, KST)
    day = local.date().isoformat()
    midnight = datetime.combine(local.date() + timedelta(days=1), datetime.min.time(), KST)
    daily = actor.get("daily", 0) if actor.get("day") == day else 0
    recent = [t for t in actor.get("recent", []) if t > now - 60]
    ip_recent = [t for t in ip.get("recent", []) if t > now - 60]
    gap, minute, maximum = (3, 10, 50) if signed_in else (5, 5, 10)
    if daily >= maximum:
        reject("daily", midnight.timestamp() - now)
    if actor.get("lease_until", 0) > now:
        reject("in_flight", actor["lease_until"] - now)
    if recent and now - recent[-1] < gap:
        reject("cooldown", gap - (now - recent[-1]))
    if len(recent) >= minute:
        reject("minute", recent[0] + 60 - now)
    if len(ip_recent) >= 60:
        reject("ip_minute", ip_recent[0] + 60 - now)
    expiry = midnight + timedelta(days=1)
    return ({"day": day, "daily": daily + 1, "recent": recent + [now],
             "lease": lease, "lease_until": now + LEASE_SECONDS, "expires_at": expiry},
            {"recent": ip_recent + [now], "expires_at": expiry})


class FirestoreChatLimiter:
    def _db(self):
        app = get_firebase_app()
        if app is None:
            raise RuntimeError("Firebase unavailable for chat quotas")
        return firestore.client(app=app)

    def reserve(self, uid: str | None, ip: str):
        db = self._db()
        digest = lambda value: hashlib.sha256(value.encode()).hexdigest()
        actor_id = digest(f"uid:{uid}" if uid else f"guest:{ip}")
        actor_ref = db.collection("chat_limits").document("actor_" + actor_id)
        ip_ref = db.collection("chat_limits").document("ip_" + digest(ip))
        lease = uuid.uuid4().hex

        @firestore.transactional
        def acquire(transaction):
            actor = actor_ref.get(transaction=transaction, timeout=5).to_dict() or {}
            ip_state = ip_ref.get(transaction=transaction, timeout=5).to_dict() or {}
            actor, ip_state = reserve_state(actor, ip_state, signed_in=uid is not None,
                                             now=time.time(), lease=lease)
            transaction.set(actor_ref, actor)
            transaction.set(ip_ref, ip_state)

        acquire(db.transaction(max_attempts=3))
        return actor_ref.id, lease

    def release(self, reservation):
        db = self._db()
        actor_id, lease = reservation
        ref = db.collection("chat_limits").document(actor_id)

        @firestore.transactional
        def finish(transaction):
            state = ref.get(transaction=transaction, timeout=5).to_dict() or {}
            if state.get("lease") == lease:
                transaction.update(ref, {"lease_until": 0, "lease": None})

        finish(db.transaction(max_attempts=3))


def get_chat_limiter():
    return FirestoreChatLimiter()
