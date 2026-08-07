/// 백엔드(Cloud Run) API 기본 URL.
///
/// 소스에 실제 배포 주소를 하드코딩하지 않는다 — 빌드/실행 시
/// `--dart-define=API_BASE_URL=...` 또는 `--dart-define-from-file=env/prod.json`
/// 으로 주입한다. 아무 값도 주지 않으면 로컬에서 backend를 직접 띄워 테스트할 때
/// 쓰는 기본값(localhost:8080)으로 폴백한다.
///
/// 예)
///   flutter run --dart-define-from-file=env/prod.json
///   flutter build web --dart-define-from-file=env/prod.json
class ApiConfig {
  ApiConfig._();

  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );
}
