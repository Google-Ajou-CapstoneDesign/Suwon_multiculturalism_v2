# Local Bridge Frontend

수원시 이주민을 위한 노동 정보 통합 플랫폼의 Flutter 클라이언트
백엔드는 Google Cloud Run(FastAPI + Gemini / Google ADK)에서 서비스된다
- 실행 설정과 내부 기능은 [프로젝트 README](../README.md)를 참고한다.

## 실행 방법

```bash
flutter pub get
flutter run --dart-define-from-file=env/local.json   # 로컬 백엔드(localhost:8080) 대상
flutter run --dart-define-from-file=env/prod.json     # 배포된 Cloud Run API 대상
```

- API 주소는 소스에 하드코딩하지 않고 `env/*.json`(dart-define)으로 주입
- 자세한 내용은 [lib/core/api_config.dart](lib/core/api_config.dart) 참고

## 프로젝트 문서

- [실행 설정·전체 기능·내부 구조](../README.md)
- [날짜별 업데이트 내역](../update_log.md)
