# Local Bridge Backend (P1)

Google Cloud Run(Docker) 배포를 전제로 한 FastAPI 백엔드. 챗봇은 `google-adk`
기반 에이전트 파이프라인으로 동작한다(`에이전트구상.png` 참고) — 주제 판별은
`google-genai`(Gemini)로 가볍게 분류하고, 판별을 통과한 요청만 Tools(사용자
이력 조회·임금 계산·기관 조회)를 갖춘 Gemini 에이전트 루프로 넘겨 최종 답변을
만든다. 임금 계산처럼 수치가 나가는 부분은 반드시 도구 호출로 근거를 확보하게
하고, genai/에이전트 호출이 실패하면 사전 검수된 정적 문구로 폴백한다(법률
환각 방지 원칙은 유지). 프론트엔드(Flutter)의 `AiResponse` / `DocumentMappingRow`
모델과 필드명이 1:1로 맞도록 JSON 응답을 camelCase로 직렬화한다.

## 범위

- Firebase Auth(ID 토큰) 검증 의존성 — `app/core/auth.py`. 챗봇은 인증이 없어도
  동작하되(`get_optional_user`), 로그인한 사용자는 이력 조회/저장이 활성화된다.
- 챗봇 에이전트 파이프라인 — `POST /api/chat` (`app/services/chat_service.py`)
  1. 주제 판별(wage/accident/contract/other)은 google-genai로 시도하고, 클라이언트가
     설정되지 않았거나 호출이 실패하면 키워드 매칭으로 폴백한다.
  2. `other`로 판별되면(=답변 가능한 소재가 아니면) 에이전트를 호출하지 않고 정적
     안내 문구만 반환한다.
  3. 그 외에는 `app/agent/pipeline.py`의 ADK `Agent`+`Runner`가 Gemini 함수 호출
     루프를 돌며 Tools(`app/agent/tools.py`)를 필요할 때 호출해 최종 답변을 만든다.
  4. 에이전트 호출이 실패하면(자격증명 없음, 네트워크 오류 등) 사전 검수된 정적
     문구로 폴백한다.
  5. 로그인한 사용자는 이번 대화가 Firestore(`app/services/history_service.py`)에
     저장되고, 다음 대화의 `get_user_history` 도구 호출에서 조회된다.
- 임금체불 규칙 엔진(근로기준법 제36조 14일 기준, if-then, LLM 미사용) — `POST /api/wage/classify`.
  같은 로직을 에이전트의 `calculate_wage` 도구가 재사용한다.
- 표준 서식 자동 채움(사실형/서술형/판단형 필드 구분) — `POST /api/wage/document-mapping`
- 증빙 파일 업로드(Firebase Storage, 원본 그대로 저장·OCR 없음) — `POST /api/uploads`
- 위치 기반 기관 라우팅(고정 목록) — `GET /api/orgs`. 같은 데이터를 에이전트의
  `search_support_orgs` 도구가 재사용한다.

**의도적 범위 제한**: 상담 이력 Firestore 저장은 로그인 사용자에 한한다. 익명
요청은 이력 없이(도구가 빈 목록을 반환) 매번 새 대화로 처리된다.

## 로컬 실행

```bash
cp .env.example .env   # 로컬은 AUTH_DEV_BYPASS=true 로 인증 우회, genai는 미설정 시 키워드 폴백만 동작
pip install -r requirements-dev.txt
uvicorn app.main:app --reload
```

`http://localhost:8000/docs` 에서 Swagger UI 확인 가능.

로컬에서 실제 Gemini 분류까지 테스트하려면 `.env`에 `GOOGLE_GENAI_USE_VERTEXAI=false`,
`GEMINI_API_KEY`를 채우거나, `gcloud auth application-default login` 후
`GOOGLE_GENAI_USE_VERTEXAI=true` + `GOOGLE_CLOUD_PROJECT`를 채운다.

## 테스트

```bash
pytest
```

CI(GitHub Actions)도 genai 자격증명 없이 동일하게 동작한다 — `_classify_with_genai`가
클라이언트 미설정으로 `None`을 반환해 키워드 폴백 경로로 빠지기 때문이다.

## Google Cloud Run 배포

### 사전 준비 (1회)

```bash
gcloud services enable run.googleapis.com artifactregistry.googleapis.com aiplatform.googleapis.com

gcloud artifacts repositories create local-bridge \
  --repository-format=docker --location=asia-northeast3

# Cloud Run 서비스 계정에 Vertex AI(Gemini) 호출 권한 부여
gcloud projects add-iam-policy-binding <PROJECT_ID> \
  --member="serviceAccount:<PROJECT_NUMBER>-compute@developer.gserviceaccount.com" \
  --role="roles/aiplatform.user"
```

### 배포 방식 — 둘 중 하나만 선택

**A. Cloud Run 콘솔의 "저장소에서 지속적 배포" (권장, YAML 관리 불필요)**
Cloud Run → 서비스 만들기 → "저장소에서 지속적으로 새 버전 배포" → GitHub 저장소 연결 →
소스 디렉터리를 `backend`로 지정 → 빌드 구성으로 `backend/cloudbuild.yaml` 선택.
이 경로를 쓴다면 `.github/workflows/deploy-backend.yml`은 삭제하거나 비활성화한다
(이중 배포 방지).

**B. GitHub Actions (`.github/workflows/deploy-backend.yml`)**
Workload Identity Federation으로 키 파일 없이 인증한다. 저장소 Settings → Secrets에
`WIF_PROVIDER`, `WIF_SERVICE_ACCOUNT`, `GCP_PROJECT_ID`를 등록해야 한다 — 값은 아래로 생성:

```bash
gcloud iam workload-identity-pools create github-pool --location=global

gcloud iam workload-identity-pools providers create-oidc github-provider \
  --location=global --workload-identity-pool=github-pool \
  --issuer-uri=https://token.actions.githubusercontent.com \
  --attribute-mapping=google.subject=assertion.sub,attribute.repository=assertion.repository

gcloud iam service-accounts create local-bridge-deployer

gcloud iam service-accounts add-iam-policy-binding \
  local-bridge-deployer@<PROJECT_ID>.iam.gserviceaccount.com \
  --role=roles/iam.workloadIdentityUser \
  --member="principalSet://iam.googleapis.com/projects/<PROJECT_NUMBER>/locations/global/workloadIdentityPools/github-pool/attribute.repository/<GITHUB_ORG>/<REPO>"
```

`local-bridge-deployer`에는 `roles/run.admin`, `roles/artifactregistry.writer`,
`roles/iam.serviceAccountUser`를 부여한다.

### 런타임 환경변수 (Cloud Run 서비스 설정)

| 변수 | 값 |
|---|---|
| `GOOGLE_GENAI_USE_VERTEXAI` | `true` |
| `GOOGLE_CLOUD_PROJECT` | 프로젝트 ID |
| `GOOGLE_CLOUD_LOCATION` | 예: `us-central1` |
| `GENAI_MODEL` | 예: `gemini-3.5-flash` (에이전트와 주제 판별이 같은 값을 쓴다) |
| `FIREBASE_CREDENTIALS_JSON` | Secret Manager 연동 권장(서비스 계정 JSON) — Firestore 상담 이력 저장/조회에도 쓰인다 |
| `FIREBASE_STORAGE_BUCKET` | `<project-id>.appspot.com` |

`AUTH_DEV_BYPASS`는 Cloud Run에 절대 설정하지 않는다(미설정 시 기본값 `false`).
ADK 에이전트는 별도 환경변수 없이 위 `GOOGLE_GENAI_USE_VERTEXAI`/`GOOGLE_CLOUD_PROJECT`/
`GOOGLE_CLOUD_LOCATION`(또는 `GEMINI_API_KEY`)를 그대로 재사용한다(google-genai
SDK와 동일한 자격증명 해석 로직).
