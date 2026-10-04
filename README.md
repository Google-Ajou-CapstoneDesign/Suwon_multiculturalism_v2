# Local Bridge

수원시 이주민·외국인 근로자·유학생을 위한 노동·생활 정보 통합 플랫폼이다. Flutter 앱에서 다국어 안내, AI 상담, 임금 계산, 근무기록, 증빙 보관, 임금체불·산재 대응 절차를 제공한다.

날짜별 변경 사항은 [업데이트 내역](update_log.md)에 정리한다.

## 기술 구성

| 영역 | 구성 |
|---|---|
| 프론트엔드 | Flutter / Dart, Firebase Authentication |
| 백엔드 | Python / FastAPI, Firebase Admin SDK |
| AI | Gemini, Google ADK, Vertex AI Search 기반 RAG |
| 데이터·파일 | Cloud Firestore, Firebase Admin SDK로 접근하는 Storage / GCS 버킷 |
| 배포 | Flutter 웹 빌드, Docker / Google Cloud Build / Cloud Run |

## 실행 방법

아래 명령은 저장소 루트에서 시작하는 **Windows PowerShell** 기준이다. 백엔드와 프론트엔드는 각각 별도 터미널에서 실행한다.

### 준비 사항

- Dart SDK `^3.10.8`을 지원하는 Flutter SDK와 Chrome. `flutter doctor`로 개발 환경을 확인한다.
- Python 3.11 이상. 백엔드 Docker 이미지는 Python 3.11을 사용한다.
- 실제 로그인·서버 저장을 테스트하려면 Firebase 프로젝트의 Authentication, Firestore와 백엔드 서비스 계정 설정이 필요하다. 프론트엔드 설정은 [firebase_options.dart](frontend/lib/firebase_options.dart)에 있다.
- AI 에이전트는 GCP 프로젝트의 Vertex AI 접근 설정이 필요하며, RAG는 별도로 검색 엔진 설정이 필요하다.

### 1. 백엔드 실행

```powershell
cd backend
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements-dev.txt
```

`python` 명령을 찾지 못하고 Windows Python Launcher가 설치되어 있다면 첫 가상환경 생성 명령을 `py -3 -m venv .venv`로 실행한다.

`backend/.env`에 개발 환경을 설정한다. 파일이 없다면 아래 예시를 참고해 만들고, 이미 있다면 기존 값을 유지하면서 필요한 항목을 수정한다. 저장소에는 `.env.example`이 없으며, 예시의 `YOUR_...`와 자격증명 경로는 실제 개발 설정으로 바꿔야 한다.

```dotenv
AUTH_DEV_BYPASS=false
GOOGLE_APPLICATION_CREDENTIALS=C:/path/to/service-account.json
FIREBASE_STORAGE_BUCKET=YOUR_BUCKET_NAME
GOOGLE_GENAI_USE_VERTEXAI=true
GOOGLE_CLOUD_PROJECT=YOUR_GCP_PROJECT_ID
GOOGLE_CLOUD_LOCATION=us-central1
GENAI_MODEL=gemini-2.5-flash

# RAG를 사용할 때 설정
DISCOVERY_ENGINE_ID=YOUR_SEARCH_ENGINE_ID
DISCOVERY_ENGINE_LOCATION=global
```

| 설정 | 역할 |
|---|---|
| `GOOGLE_APPLICATION_CREDENTIALS` | Firebase Admin 초기화에 사용할 서비스 계정 JSON 경로. Vertex AI 호출에도 해당 계정의 접근 권한이 필요하다. |
| `FIREBASE_CREDENTIALS_JSON` | 위 파일 경로 대신 Firebase 서비스 계정 JSON 원문을 전달하는 방법. 둘 다 설정되면 이 값이 우선한다. |
| `FIREBASE_STORAGE_BUCKET` | 실제 존재하는 파일 버킷 이름. `gs://`를 제외하고 입력한다. |
| `GOOGLE_GENAI_USE_VERTEXAI` | `true`이면 Vertex AI, `false`이면 `GEMINI_API_KEY`를 사용하는 Gemini API 방식이다. |
| `GOOGLE_CLOUD_PROJECT`, `GOOGLE_CLOUD_LOCATION`, `GENAI_MODEL` | Gemini 호출 프로젝트·리전·모델. 위 모델명은 현재 Cloud Build 설정 기준이다. |
| `DISCOVERY_ENGINE_ID`, `DISCOVERY_ENGINE_LOCATION` | Vertex AI Search 엔진 ID·리전. 미설정 또는 검색 실패 시 RAG 도구는 빈 결과를 반환한다. |
| `AUTH_DEV_BYPASS` | Firebase 자격증명이 없을 때 인증이 필요한 API를 `dev-user`로 호출하는 로컬 개발 옵션. 운영에서는 `false`로 둔다. |

Firebase 자격증명 없이도 서버를 시작하고 `/health`를 확인할 수 있다. 다만 **게스트 채팅도 Firestore에 전송 횟수를 저장하므로 Firebase·Firestore 연결이 필요하다.** `AUTH_DEV_BYPASS=true`는 Firestore나 파일 저장소를 대신하지 않는다. Gemini 설정이 없거나 호출이 실패하면, 채팅 전송 제한 검사를 통과한 요청에 대해 키워드 분류와 정적 안내로 대체한다.

설정을 마친 뒤 같은 터미널에서 실행한다.

```powershell
.\.venv\Scripts\python.exe -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8080
```

- 상태 확인: <http://localhost:8080/health>
- API 문서: <http://localhost:8080/docs>
- `.env` 변경 후에는 백엔드를 재시작한다. 프론트엔드 기본 API 포트도 `8080`이다.

### 2. 프론트엔드 실행

새 터미널을 저장소 루트에서 연다.

```powershell
cd frontend
flutter pub get
flutter run -d chrome --dart-define-from-file=env/local.json
```

로컬 API 설정은 [local.json](frontend/env/local.json)의 `http://localhost:8080`이다. 배포된 백엔드에 연결하려면 다음 명령을 사용한다.

```powershell
flutter run -d chrome --dart-define-from-file=env/prod.json
```

다른 API 주소를 사용하려면 `flutter run -d chrome --dart-define=API_BASE_URL=http://YOUR_HOST:8080`으로 지정한다. Android 에뮬레이터에서는 호스트 PC 주소로 `10.0.2.2`를 사용하고, 실제 기기에서는 접속 가능한 PC의 LAN 주소를 지정한다. 위치 인증은 브라우저·기기의 위치 권한과 위치 서비스 활성화가 필요하다.

Firebase 프로젝트를 바꾸는 경우 프론트엔드 Firebase 설정과 백엔드 서비스 계정을 같은 프로젝트에 맞춘다. 웹 Google 로그인은 Firebase Authentication의 공급자·허용 도메인 및 해당 호스팅 환경의 리다이렉트 설정도 확인한다.

### 3. 테스트와 웹 빌드

백엔드 명령은 `backend/`, Flutter 명령은 `frontend/`에서 실행한다.

```powershell
# backend/
.\.venv\Scripts\python.exe -m pytest -q
```

```powershell
# frontend/
flutter analyze
flutter test
flutter build web --dart-define-from-file=env/prod.json
```

웹 결과물은 `frontend/build/web/`에 생성된다. 백엔드 배포 구성은 [Dockerfile](backend/Dockerfile)과 [cloudbuild.yaml](backend/cloudbuild.yaml)에 있다. 현재 Cloud Build는 `backend/`를 빌드 컨텍스트로 사용하며 런타임 환경변수와 Secret Manager의 Firebase 자격증명을 Cloud Run에 연결한다.

## 주요 기능

현재 하단 메뉴는 **홈 · 네비게이터 · 캘린더 · 임금계산기 · 설정**이다. AI 가이드는 채팅 버튼으로 열며, 백과사전은 별도 콘텐츠 모듈로 구성되어 있다.

| 기능 | 제공 내용 |
|---|---|
| 홈 | 날씨·비자 정보, 오늘 출퇴근·휴게·위치 인증, 이번 달 근무일·총 근무시간·예상 임금, 주요 기능 바로가기 |
| 근무기록장 | 날짜별 출퇴근·휴게·메모·위치 인증 기록, 월별 조회, 시급·근무시간 간편 입력, 일별·월별 예상 임금 |
| 임금계산기 | 입력한 근무 조건을 바탕으로 임금 항목을 계산하고 계산 근거·안내 표시 |
| 임금체불·산재 네비게이터 | 상황 확인부터 증빙 준비·기관 안내·서식 작성까지 단계별 안내, 진정서 PDF 미리보기·저장·인쇄 |
| 근무기록 증빙 PDF | 최근 30일 기록의 출퇴근·휴게·위치 인증 요약표와 날짜별 주소·좌표·메모 출력. 한국어·선택 언어 지원 |
| 증빙 보관함 | 근로계약서·임금명세서 등 원본 파일 업로드와 목록 조회, 보관 상태 관리 |
| AI 가이드 | 노동·생활 정보 상담, 추천 질문, 문서 근거 검색, 관련 기관 Top-2 추천 |
| 추천 기관 | 기관명·주소·전화번호·이용 가능 시간·거리 표시, 두 카드를 동일한 폭으로 병렬 배치 |
| 백과사전·사용 안내 | 노동·생활 분야 다국어 콘텐츠와 출처, 첫 실행 화면 투어, 설정의 사용설명서 |
| 로그인·설정 | 이메일·비밀번호 및 Google 로그인, 프로필·비자·언어 설정, 버그 신고 |

로그인 사용자의 근무기록은 서버 API에서 조회·저장하며 홈 집계에도 반영한다. 비로그인 사용자는 데모 기록을 체험할 수 있고 PDF에 데모임을 표시한다. 홈·캘린더의 예상 임금은 설정 시급과 실근무시간을 기준으로 계산하며, 이 시급은 현재 세션에만 적용된다. 실제 수령액 확정이나 계약 시급의 서버 저장 기능과는 구분된다.

버그 신고는 제목·내용을 입력한 뒤 `teameqlab@gmail.com` 수신 정보가 채워진 메일 앱을 연다. 사용자가 직접 메일을 전송하며, 메일 앱을 열 수 없으면 내용을 복사할 수 있다.

### 지원 언어

요청한 17개국의 언어와 기존 한국어·영어·터키어를 포함해 **20개 언어**를 지원한다.

| 구분 | 언어와 코드 |
|---|---|
| 요청한 17개국 | 네팔어 `ne`, 테툼어(동티모르) `tet`, 라오스어 `lo`, 몽골어 `mn`, 미얀마어 `my`, 벵골어(방글라데시) `bn`, 베트남어 `vi`, 싱할라어(스리랑카) `si`, 우즈베크어 `uz`, 인도네시아어 `id`, 중국어 `zh`, 크메르어(캄보디아) `km`, 키르기스어 `ky`, 태국어 `th`, 우르두어(파키스탄) `ur`, 필리핀어 `fil`, 타지크어 `tg` |
| 기존 지원 | 한국어 `ko`, 영어 `en`, 터키어 `tr` |

고정 UI 문구는 [AppLanguage / L10nText](frontend/lib/core/app_language.dart)와 기능별 문자열 파일에서 관리한다. AI 답변은 선택 언어를 백엔드에 전달해 생성한다. 문자별 Noto 글꼴을 사용하며 우르두어에는 오른쪽에서 왼쪽으로 읽는 방향을 적용한다. 새 기계 번역 문구는 원어민 감수가 필요하다.

## 내부 처리 구조

### AI 의도 분류·에이전트·RAG

1. `POST /api/chat`이 인증 상태와 입력 길이·전송 제한을 검사한다.
2. [chat_service.py](backend/app/services/chat_service.py)가 Gemini로 의도를 분류한다. 분류 호출이 실패하면 키워드로 대체한다.
3. 의도는 `wage`(임금), `accident`(산재), `contract`(계약), `life_info`(한국 생활), `org_search`(기관 검색), `meta`(서비스 소개), `off_topic`(범위 밖 질문)으로 나눈다. 범위 밖 질문에는 정적 안내를 반환한다.
4. [pipeline.py](backend/app/agent/pipeline.py)의 ADK 에이전트가 질문·대화 맥락·선택 언어를 받아 필요한 도구를 호출한다.
5. 응답을 사실 안내·위험 안내·화면 이동 대상·추천 기관의 구조로 반환한다. 로그인 상담 이력은 Firestore에 저장하며, 에이전트 호출 실패 시 언어별 정적 안내로 대체한다.

[tools.py](backend/app/agent/tools.py)에서 제공하는 도구는 다음과 같다.

| 도구 | 역할 |
|---|---|
| `get_user_history` | 로그인 사용자의 최근 상담 이력 조회 |
| `calculate_wage` | 임금체불 날짜·금액 정보를 규칙 엔진에 전달해 계산 |
| `search_support_orgs` | 기관 목록에서 상황에 맞는 Top-2 선택 및 위치 기반 거리 계산 |
| `search_reference_documents` | Vertex AI Search에서 문서 제목·검색 조각·링크를 조회해 답변 근거 제공 |
| `flag_urgent_action` | 긴급 위험 상황을 사용자 안내에 반영 |

도구에 전달되는 사용자 UID와 위치는 서버 요청 컨텍스트에서 연결한다. 사용자 UID를 모델이 임의로 지정하는 도구 인자로 받지 않는다. RAG 검색 데이터는 별도로 Vertex AI Search에 등록해야 하며, 앱을 실행하는 것만으로 색인이 생성되지는 않는다.

### 채팅 제한

| 항목 | 로그인 | 게스트 |
|---|---|---|
| 최소 전송 간격 | 3초 | 5초 |
| 최근 1분 최대 요청 | 10회 | 5회 |
| 하루 최대 요청 | 50회 | 10회 |
| 사용자별 동시 처리 | 1개 | 1개 |

게스트는 IP로 구분하며, 동일 IP 전체에 분당 60회 제한도 적용한다. 하루 기준은 한국시간 자정이고 여러 Cloud Run 인스턴스가 Firestore 트랜잭션으로 횟수를 공유한다. 예약된 요청은 취소해도 횟수를 돌려주지 않는다.

메시지는 최대 2,000자, 최근 이력은 최대 6개, 메시지·이력 합계는 최대 12,000자이다. AI 처리 제한은 60초, 요청 잠금의 만료 시간은 90초, 에이전트의 최대 LLM 호출은 4회이다. 전송 제한 초과는 `429`와 재시도 시간, 제한 저장소 장애는 `503`, AI 시간 초과는 `504`로 반환한다. 관련 구현은 [chat_limits.py](backend/app/services/chat_limits.py), [채팅 라우터](backend/app/routers/chat.py), [채팅 스키마](backend/app/schemas/chat.py)에 있다.

### 데이터·증빙 저장

| 저장 위치 | 내용 |
|---|---|
| Firebase Authentication | 로그인 계정과 인증 토큰 |
| Firestore `users` | 프로필·비자·선호 언어·계약서 및 임금명세서 보관 상태 |
| Firestore `worklogs` | 일별 출퇴근·휴게·메모·위치 인증 좌표·주소·증빙 연결 |
| Firestore `evidence_files` | 파일 ID·소유자·종류·저장 경로·크기·업로드 시각 등 메타데이터 |
| Firestore `chat_history` | 로그인 사용자의 상담 이력 |
| Firestore `chat_limits` | 사용자·IP별 요청 횟수와 동시 요청 잠금 |
| Storage / GCS | `evidence/{uid}/{case_type}/...` 경로의 증빙 원본 파일 |

기관 검색의 현재 데이터 원본은 [organizations.json](backend/app/data/organizations.json)이다. Firestore 스키마 문서의 `organizations` 설계와는 별개로, 실행 중인 기관 서비스는 이 JSON을 사용한다.

업로드는 백엔드 API를 거쳐 원본을 저장하며 OCR이나 증빙 내용의 유·불리 판단을 하지 않는다. 버킷 미설정·부재·접근 권한 문제는 업로드 `503`으로 안내한다. 근무기록 PDF의 조회 범위와 데모 처리 기준은 [근무기록 출력 문서](docs/worklog_export.md)에 있다. 복합 문자는 Flutter에서 조합한 이미지로 PDF에 넣으므로 해당 텍스트의 복사·검색은 제한된다.

### 주요 API

로그인 API에는 `Authorization: Bearer <Firebase ID Token>`을 전달한다.

| API | 용도 | 로그인 필요 |
|---|---|---|
| `GET /health` | 서버 상태 확인 | 아니요 |
| `POST /api/chat` | AI 가이드 | 선택, Firestore 전송 제한은 항상 적용 |
| `GET /api/users/me`, `PUT /api/users/me` | 프로필 조회·저장 | 예 |
| `PATCH /api/users/me/vault` | 증빙 보관 상태 변경 | 예 |
| `GET /api/worklog/days?year=YYYY&month=M` | 월별 근무기록 조회 | 예 |
| `PUT /api/worklog/days/{day}` | 일별 기록 저장, 날짜는 `YYYY-MM-DD` | 예 |
| `POST /api/uploads?case_type=contract` | `file` multipart 업로드. `worklog_date`를 추가하면 날짜별 기록에 연결 | 예 |
| `GET /api/uploads` | 본인 증빙 목록, `worklog_date` 필터 지원 | 예 |
| `POST /api/wage/classify` | 임금체불 규칙 판별 | 예 |
| `POST /api/wage/document-mapping` | 서식 필드 매핑 | 예 |
| `POST /api/location/verify` | 좌표 역지오코딩·주소 반환 | 아니요 |
| `GET /api/orgs` | 기관 목록·위치 기반 거리 | 아니요 |
| `GET /api/weather` | 수원 날씨 | 아니요 |

위치 역지오코딩이 실패하면 주소만 비워 반환하고 위치 인증 흐름은 유지한다. 로그인 근무기록 조회 실패는 빈 기록으로 숨기지 않고 `503`으로 구분한다. 자세한 요청·응답 필드는 실행 중인 서버의 `/docs`에서 확인할 수 있다.

## 저장소 구조

```text
frontend/
  lib/core/             API 설정·통신, 언어, 사용자 프로필 상태
  lib/common/           공용 위젯·언어 선택·읽기 방향
  lib/features/         홈, 인증, AI 가이드, 백과사전, 네비게이터,
                        임금계산기, 근무기록, 설정·버그 신고
  lib/navigation/       하단 메뉴와 화면 이동
  assets/fonts/         다국어 글꼴·라이선스
  env/                  로컬·운영 API 주소
  test/                 Flutter 테스트
backend/
  app/routers/          FastAPI 엔드포인트
  app/schemas/          입력 검증·응답 모델
  app/services/         상담, 계산, 저장, 기관·날씨·위치 서비스
  app/agent/            ADK 에이전트 파이프라인·도구
  app/core/             인증, Firebase·Gemini·검색 클라이언트
  app/data/             기관 데이터
  tests/                백엔드 테스트
DB/                     Firestore 보안 규칙·인덱스
docs/                   설계·기능 설명·라이선스
update_log.md           날짜별 업데이트 내역
```
