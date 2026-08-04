from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .routers import chat, health, orgs, uploads, wage

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
