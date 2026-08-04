# Local Bridge Backend (P0)

Google Cloud Run(Docker) 배포를 전제로 한 FastAPI 백엔드. 챗봇의 의도 분류에는
`google-genai` SDK(Gemini, Vertex AI 모드)를 쓰고, 실제 안내 문구는 항상 사전
검수된 정적 콘텐츠에서만 가져온다(법률 환각 방지 원칙). 프론트엔드(Flutter)의
`AiResponse` / `DocumentMappingRow` 모델과 필드명이 1:1로 맞도록 JSON 응답을
camelCase로 직렬화한다.

## P0 범위

- Firebase Auth(ID 토큰) 검증 의존성 — `app/core/auth.py`
- 챗봇 라이트 라우팅 — `POST /api/chat`
  - 의도 분류(wage/accident/contract/other)는 google-genai로 시도하고,
    클라이언트가 설정되지 않았거나 호출이 실패하면 키워드 매칭으로 폴백한다.
  - 어느 경로든 사용자에게 나가는 문구는 정적 콘텐츠(`_CONTENT`)뿐 — LLM이 새
    문장을 생성해 응답하지 않는다.
- 임금체불 규칙 엔진(근로기준법 제36조 14일 기준, if-then, LLM 미사용) — `POST /api/wage/classify`
- 표준 서식 자동 채움(사실형/서술형/판단형 필드 구분) — `POST /api/wage/document-mapping`
- 증빙 파일 업로드(Firebase Storage, 원본 그대로 저장·OCR 없음) — `POST /api/uploads`
- 위치 기반 기관 라우팅(고정 목록) — `GET /api/orgs`

**의도적 범위 제한(P0)**: Firestore 연동 없이 스테이트리스로 동작한다. 이용자 사실값은
프론트엔드가 요청 본문에 실어 보내고, 서버는 저장하지 않는다. Firestore 영속화는 P1.

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
| `GENAI_MODEL` | 예: `gemini-2.5-flash` |
| `FIREBASE_CREDENTIALS_JSON` | Secret Manager 연동 권장(서비스 계정 JSON) |
| `FIREBASE_STORAGE_BUCKET` | `<project-id>.appspot.com` |

`AUTH_DEV_BYPASS`는 Cloud Run에 절대 설정하지 않는다(미설정 시 기본값 `false`).
