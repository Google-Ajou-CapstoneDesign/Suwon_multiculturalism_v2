# 근무기록 증빙 PDF

임금체불 네비게이터의 진정서 확인·다운로드 다음에 근무기록 출력 단계를 제공한다.

- 조회 기간: 한국시간 오늘을 포함한 최근 30일. 월·연도를 넘어도 해당 월들을 모두 조회한다.
- 기존 인증 API `GET /api/worklog/days?year=2026&month=9`를 재사용한다. 사용자 ID는 백엔드 인증에서 결정한다.
- 로그인: 본인이 저장한 기록을 표시한다. 조회 실패는 오류와 재시도를 표시하며 데모로 대체하지 않는다.
- 비로그인: 캘린더와 공통인 데모 생성기를 사용한다. 화면과 PDF 각 페이지에 제출용이 아님을 표시하고 파일명에 `DEMO_`를 붙인다.
- PDF: 30일 출퇴근·휴게·위치 인증 요약표와 저장된 날짜별 주소·좌표·메모를 출력한다. 한국어 및 현재 선택한 언어로 저장하거나 미리보기·인쇄할 수 있다.
- 기록이 없는 날짜/시각은 미기록으로 표시한다. 기록이 전혀 없으면 다운로드를 제공하지 않는다.
- 위치 인증은 기존 데이터의 일별 상태다. 별도로 저장되지 않는 출근/퇴근 각각의 위치나 인증 시각은 만들어내지 않는다. 주소와 메모는 번역하지 않는다.
- 백엔드 월별 조회 장애는 빈 목록 대신 HTTP 503으로 반환한다. 실제 빈 달은 HTTP 200과 `days: []`다.

## 검증

- `cd backend` → `.\.venv\Scripts\python.exe -m pytest tests/test_worklog.py -q`
- `cd frontend` → `flutter test --no-pub test/work_log_report_test.dart`
- `flutter analyze --no-pub lib/features/navigator_flow lib/features/worklog test/work_log_report_test.dart`
- PDF 시각 검증용 샘플: `flutter test --no-pub --dart-define=WORKLOG_PDF_QA=true test/work_log_report_test.dart` 실행 시 `frontend/build/worklog_pdf_qa/`에 6개 언어 PDF를 생성한다. 샘플에는 실제 개인정보를 사용하지 않는다.

운영 반영은 별도 프론트엔드/백엔드 배포 저장소에 변경 파일을 복사한 뒤 각각 배포해야 한다. 이 작업에서는 운영 배포를 수행하지 않았다.
