from fastapi import APIRouter

from ..schemas.chat import ChatRequest, ChatResponse
from ..services import chat_service

router = APIRouter(prefix="/api/chat", tags=["chat"])


@router.post("", response_model=ChatResponse)
def post_chat(request: ChatRequest) -> ChatResponse:
    return chat_service.answer(request)
