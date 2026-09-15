# AI 가이드 전송 제한

`POST /api/chat`에서 입력 검증 및 Firebase 토큰 검증 후, 의도 분류 전에 제한한다.

| 기준 | 비회원(IP) | 로그인(Firebase UID) |
| --- | --- | --- |
| 최소 간격 | 5초 | 3초 |
| 최근 60초 | 5회 | 10회 |
| 일일 | 10회 | 50회 |
| 진행 중 요청 | 1개 | 1개 |

동일 IP에서는 로그인 여부와 관계없이 최근 60초간 합계 60회까지 허용한다.
일일 횟수는 한국 시간 자정에 초기화한다. 짧은 시간 제한과 진행 중 요청은
자정에도 유지한다. 예약에 성공한 요청은 실패·취소 시에도 횟수를 돌려주지 않는다.

- 메시지 최대 2,000 Unicode 코드 포인트, 이력 최대 6개, 메시지와 이력 합계 12,000자.
- 의도 분류 최대 1회 + ADK `RunConfig(max_llm_calls=4)`로 모델 호출 총 5회 이하.
  SDK 자동 재시도도 1회 시도로 제한한다.
- AI 처리 제한 60초. 분류 HTTP 요청 15초, 에이전트 HTTP 요청 45초 제한.
  진행 중인 외부 요청은 취소해도 이미 발생한 비용을 되돌릴 수 없다.
- 제한 시 429와 `Retry-After`, JSON `detail.reason`, `detail.retryAfterSeconds` 반환.
  저장소 장애는 AI 호출 없이 503, 처리 시간 초과는 504.
- 앱은 Firebase ID 토큰을 보내며 제한 사유·남은 대기 시간을 5개 언어로 표시한다.
  실패 시 작성 내용을 보존하고 실패한 메시지는 후속 이력에서 제외한다.

## 저장소와 운영

기존 `(default)` Firestore STANDARD 데이터베이스의 `chat_limits` 컬렉션을 사용한다.
사용자/IP 카운터를 한 트랜잭션에서 예약하여 Cloud Run 인스턴스 간 경쟁을 방지한다.
UID/IP 원문 대신 SHA-256 문서 ID를 사용한다(해시는 완전한 익명화를 보장하지 않는다).
진행 중 요청은 90초 임대이며 정상 종료 시 즉시 해제된다. 서버 종료나 저장소 장애 시
임대 만료로 복구한다. 해제 시 예약 ID를 비교하므로 이전 요청이 새 요청의 임대를
해제할 수 없다. 기존 Firestore 규칙에서 해당 컬렉션은 클라이언트 접근이 허용되지 않는다.
Admin SDK 서비스 계정에는 Firestore 읽기·쓰기 권한이 필요하다.

`expires_at` 필드를 TTL로 지정하면 오래된 카운터를 정리할 수 있다.
TTL 삭제 지연은 제한 계산에 영향을 주지 않는다. TTL을 켜지 않아도 제한은 동작한다.
이 변경은 코드만 수정하며 실제 배포·IAM·TTL 설정은 수행하지 않는다.

## 프록시 IP

Docker의 Uvicorn은 `--no-proxy-headers`로 시작하여 임의의 전달 헤더를 먼저 신뢰하지 않는다.
로컬 기본값은 연결 상대 IP. Cloud Run(`K_SERVICE` 있음)은 X-Forwarded-For의
오른쪽 끝 1개 신뢰 구간을 사용한다. 헤더의 왼쪽 첫 값은 사용자가 위조할 수 있어 사용하지 않는다.
앞단에 로드 밸런서/CDN을 추가하면 `CHAT_TRUSTED_PROXY_HOPS`를 실제 경로에 맞추고
직접 접근을 차단해야 한다. 잘못 늘리면 사용자가 IP 제한을 우회할 수 있다.
프록시를 변경한 배포에서는 위조된 X-Forwarded-For로도 동일 IP 한도가 적용되는지 확인한다.

Google의 헤더 설명: https://docs.cloud.google.com/functions/docs/reference/headers
로드 밸런서의 추가 IP 설명: https://docs.cloud.google.com/load-balancing/docs/https#x-forwarded-for_header
