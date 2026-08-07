# Local Bridge Frontend

수원시 이주민을 위한 노동 정보 통합 플랫폼의 Flutter 클라이언트
백엔드는 Google Cloud Run(FastAPI + google-genai)에서 서비스된다
- [../backend/README.md](../backend/README.md) 참고

## 실행 방법

```bash
flutter pub get
flutter run --dart-define-from-file=env/local.json   # 로컬 백엔드(localhost:8080) 대상
flutter run --dart-define-from-file=env/prod.json     # 배포된 Cloud Run API 대상
```

- API 주소는 소스에 하드코딩하지 않고 `env/*.json`(dart-define)으로 주입
- 자세한 내용은 [lib/core/api_config.dart](lib/core/api_config.dart) 참고

## 개발 내역

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
