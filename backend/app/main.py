import logging
import sys

from dotenv import load_dotenv

# 로컬 개발 전용 — backend/.env를 프로세스 환경변수로 읽어들인다. Cloud Run
# 배포본에는 .env 파일 자체가 없으므로(.dockerignore) 이 호출은 조용히
# no-op이 된다. core.auth의 AUTH_DEV_BYPASS처럼 "모듈 임포트 시점"에 바로
# os.getenv()를 읽는 코드가 있어서, 아래 라우터 임포트보다 먼저 실행해야 한다.
#
# pytest 아래에서는 절대 로드하지 않는다 — README의 "CI(GitHub Actions)도 genai
# 자격증명 없이 동일하게 동작한다" 전제가 깨지면 안 되기 때문이다. 개발자
# 로컬에 실제 자격증명이 든 .env가 있어도 테스트는 항상 자격증명 없는 것과
# 동일하게 동작해야 한다(그래야 dev-bypass 인증 경로·Discovery Engine 미설정
# 폴백 경로가 테스트에서 그대로 검증된다).
if "pytest" not in sys.modules:
    load_dotenv()

from fastapi import FastAPI  # noqa: E402
from fastapi.middleware.cors import CORSMiddleware  # noqa: E402

from .routers import chat, health, location, orgs, uploads, users, wage, weather, worklog  # noqa: E402

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
app.include_router(users.router)
app.include_router(weather.router)
app.include_router(location.router)
app.include_router(worklog.router)
