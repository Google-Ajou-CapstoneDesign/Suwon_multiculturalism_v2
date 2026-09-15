import asyncio
import logging
from typing import Optional

from fastapi import APIRouter, Depends, Header, HTTPException, Request

from ..core.auth import CurrentUser, get_current_user
from ..schemas.chat import ChatRequest, ChatResponse
from ..services import chat_service
from ..services.chat_limits import AI_TIMEOUT_SECONDS, client_ip, get_chat_limiter

logger = logging.getLogger(__name__)


async def chat_user(authorization: Optional[str] = Header(default=None)):
    if authorization is None:
        return None
    return await get_current_user(authorization=authorization)

router = APIRouter(prefix="/api/chat", tags=["chat"])


@router.post("", response_model=ChatResponse)
async def post_chat(
    request: ChatRequest, http_request: Request,
    user: Optional[CurrentUser] = Depends(chat_user),
    limiter=Depends(get_chat_limiter),
) -> ChatResponse:
    ip = client_ip(http_request)
    uid = user.uid if user else None
    try:
        reservation = await asyncio.wait_for(
            asyncio.to_thread(limiter.reserve, uid, ip), timeout=10
        )
    except HTTPException:
        raise
    except Exception:
        logger.exception("Chat quota storage unavailable")
        raise HTTPException(503, detail={"code": "chat_unavailable"})
    try:
        async with asyncio.timeout(AI_TIMEOUT_SECONDS):
            return await chat_service.answer(request, uid=uid)
    except TimeoutError:
        raise HTTPException(504, detail={"code": "chat_timeout"})
    finally:
        try:
            await asyncio.wait_for(
                asyncio.shield(asyncio.to_thread(limiter.release, reservation)), timeout=3
            )
        except Exception:
            # A crashed process/storage outage recovers through the lease expiry.
            logger.exception("Chat quota lease release failed")
