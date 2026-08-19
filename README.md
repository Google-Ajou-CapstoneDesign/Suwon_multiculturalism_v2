# Suwon_multiculturalism_v2
Suwon_multiculturalism_v2'

## 업데이트 내역

### 2026-08-01 — 프로젝트 시작
- 초기 커밋, 참고 문서 정리(`계획서.md`, `모듈구체화방안.md`, `frontend구상.md`, `CLAUDE.md`)

### 2026-08-02 — 프론트엔드 P0 뼈대
- Flutter 프로젝트 초기화
- 하단 탭 4개(백과사전 · AI가이드 · 근무기록 · 설정) 구조와 탭별 Navigator 구성
- UI 설계 목업(`UI_설계/UI1~3.png`)을 기준으로 화면 구현
  - 백과사전: 홈, ARC 발급(5단 카드+체크리스트), 통신 개통(비교표+PASS 인증 스테퍼), 나머지 18개 카테고리 placeholder
  - AI 가이드: 챗봇 화면(FactAnswer/RiskNotice/RoutingCTA/추천기관 카드)
  - 근무기록: 데일리 훅 + 임금체불·산재 대응 네비게이터(각 5단계, 서식 매핑 시각화 포함)
  - 설정: 언어/비자/프로필/알림 목록
- 공용 위젯(`AppCard`, `DisclaimerBanner`, `StepIndicator`) 및 브랜드 컬러 테마 정의

### 2026-08-04 — 백엔드 P0 + Cloud Run 전환
- FastAPI 백엔드 초안을 Hugging Face Spaces 기준으로 작성했다가, 배포 방침이 **Google Cloud Run(Docker) + GitHub 지속적 배포**로 변경되어 전면 재작업
- Firebase Auth(ID 토큰) 검증, 임금체불 14일 규칙엔진, 표준 서식 자동 매핑(사실형/서술형/판단형 필드 구분), 증빙 파일 업로드, 위치 기반 기관 라우팅 API 구현
- 챗봇 의도 분류에 `google-genai` SDK(Vertex AI 모드)를 도입 — LLM은 분류에만 쓰고, 실제 안내 문구는 사전 검수된 정적 콘텐츠만 사용(법률 환각 방지 원칙)
- `Dockerfile`/`cloudbuild.yaml`/GitHub Actions 워크플로 작성, pytest 11건 통과

### 2026-08-04 — 프론트엔드 ↔ 배포된 API 연결 (진행 중)
- 배포된 Cloud Run API(`local-bridge-api-for-backend-git-*.run.app`)와 실제 연동
- `lib/core/api_config.dart` / `api_client.dart` 추가 — API 주소는 dart-define(`env/*.json`)으로 외부화, 소스 하드코딩 없음
- `AiResponse` / `RoutingTarget` / `Org`에 `fromJson` 추가해 백엔드 camelCase 응답과 매핑
- AI 가이드 챗봇 화면을 `POST /api/chat` 실제 호출로 전환(전송 중 로딩, 실패 시 폴백 메시지 처리)
- Android `INTERNET` 권한 추가
- 남은 일: 임금체불/업로드 등 인증이 필요한 엔드포인트는 Firebase Auth 로그인 플로우 구현 후 연결 예정

### 2026-08-07 — 백과사전 리디자인 & 다국어 전환
- 백과사전 화면 디자인 변경
- 언어 전환 기능 추가

### 2026-08-08 — 캘린더 · 임금계산기 · 네비게이터 뼈대
- 근무기록 캘린더 UI, 임금 계산기 인터페이스 추가
- 임금체불·산재처리 네비게이터 기능 및 하위 페이지 구현

### 2026-08-09 — 임금계산기 · 백과사전 콘텐츠 보완
- 임금계산기 로직 수정
- 백과사전 콘텐츠 수정

### 2026-08-11 — 에이전트 루프 + RAG 연동
- `google-adk` 기반 Gemini 함수 호출 에이전트 루프(`app/agent/pipeline.py`, `tools.py`) 도입
- 사용자별 상담 이력 저장 서비스(`history_service.py`, Firestore `chat_history`) 추가
- 에이전트의 도구 호출·사고 과정 로그를 API 응답에 포함해 디버깅 가능하게 함
- Vertex AI Search(Discovery Engine) 연동 — 법령·안내 문서를 검색해 근거로 인용하는 RAG 도구(`document_search_service.py`) 추가
- 채팅 인터페이스에 기본으로 떠 있던 대화 노출 버그 수정

### 2026-08-12 — Firestore 스키마 설계 + 안정화
- `DB/firestore.rules` / `firestore.indexes.json` / `firebase.json`, `docs/firestore_스키마.md`(users·worklogs·organizations·evidence_files 컬렉션 설계) 작성 — Firestore 연동 준비
- 임금 계산기 로직 수정, 로딩화면 버그 수정
- 에이전트 도구 호출 실패 시 빈 결과로 안전하게 폴백하도록 로깅·예외 처리 정비
- 전체 UI 다국어 번역 기능 추가

### 2026-08-13 — 에이전트 직접 판단 + 다국어 완성 + 기관 검색
- 위험 상황 안내 등 보조 판단을 에이전트가 도구 호출로 직접 내리는 방식(`flag_urgent_action` 계열)으로 변경, 응답에 thinking 과정이 그대로 노출되던 버그 수정
- AI 챗봇 응답에 마크다운 렌더링 지원
- 기관 검색 도구(`search_support_orgs`) 추가 및 실제 기관 데이터(`organizations.json`) 반영, 시간 계산 버그 수정
- 사용자가 설정한 언어로 항상 답변하도록 에이전트 프롬프트 개선
- 남은 UI·콘텐츠 번역 전부 마무리
- 잡담(off_topic)류 질문에 답변이 안 나오던 버그 수정
- 네비게이터 항목 구성 변경

### 2026-08-14 — 로그인 · 사용자 프로필 엔드포인트
- 로그인 화면 UI 변경
- `GET/PUT /api/users/me`(Firestore `users/{uid}`) 엔드포인트 추가 — 사용자 정보를 프론트에 전달
- 홈 화면 디자인 개편, 홈 화면에 임금체불·산재처리 네비게이터 바로가기 버튼 추가
- 네비게이터 세부 수정

### 2026-08-15 — 날씨 · 위치인증 · 증빙 보관함
- 수원시 날씨 연동(`GET /api/weather`)
- GPS 위치 인증 기능 활성화(`GET /api/location`, 위치 인증 API)
- 사업주 공식 증빙 보관함(근로계약서·임금명세서 등록 상태) UI 추가
- 임금체불 2단계, 산재처리 3단계 버튼 구현 및 네비게이터 수정
- 앱/화면 이름 정리(chore)

### 2026-08-16 — 홈 화면 다듬기
- 버튼 크기 조정(가독성 개선)
- 홈 화면에서도 위치 인증 가능하도록 수정
- 시작 화면에 사용설명서 추가

### 2026-08-17 — 추천 기관 거리 표시
- 사용자 위치정보 기반으로 추천 기관까지의 거리를 계산해 표시하는 기능 추가(`org_service.py` 하버사인 거리 계산)

### 2026-08-18 — 백과사전 출처 표기 + 근무기록장 백엔드 연동
- 백과사전 콘텐츠에 문서 출처 표기 추가
- 근무기록장(캘린더) 전용 Firestore 컬렉션(`worklogs`, `evidence_files`) 및 API(`GET/PUT /api/worklog/days`, `PATCH /api/users/me/vault`) 신설 — 게스트는 데모 데이터, 로그인 사용자는 실제 서버 데이터로 표시되도록 프론트 연동
