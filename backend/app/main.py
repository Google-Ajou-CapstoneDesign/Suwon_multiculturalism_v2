import logging

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .routers import chat, health, orgs, uploads, wage

# 루트 로거 레벨을 INFO로 올린다 — 미설정 시 기본값(WARNING)에서는
# app.agent.pipeline의 도구 호출·사고 과정 로그가 보이지 않는다. Cloud Run은
# stdout/stderr를 그대로 로그로 수집하므로 별도 핸들러 설정 없이 이걸로 충분하다.
logging.basicConfig(level=logging.INFO)

app = FastAPI(title="Local Bridge Backend", version="0.1.0")

# TODO(backend/prod): 배포 도메인이 확정되면 allow_origins를 구체 도메인으로 좁힌다.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(health.router)
app.include_router(chat.router)
app.include_router(wage.router)
app.include_router(uploads.router)
app.include_router(orgs.router)
