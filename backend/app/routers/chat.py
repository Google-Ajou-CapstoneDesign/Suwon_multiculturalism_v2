from typing import Optional

from fastapi import APIRouter, Depends

from ..core.auth import CurrentUser, get_optional_user
from ..schemas.chat import ChatRequest, ChatResponse
from ..services import chat_service

router = APIRouter(prefix="/api/chat", tags=["chat"])


@router.post("", response_model=ChatResponse)
async def post_chat(
    request: ChatRequest, user: Optional[CurrentUser] = Depends(get_optional_user)
) -> ChatResponse:
    return await chat_service.answer(request, uid=user.uid if user else None)
