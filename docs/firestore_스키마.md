# Firestore 스키마 설계

## 0. 전제 조건

- **DB**: Cloud Firestore (NoSQL 문서형). "테이블"은 Firestore의 **컬렉션(collection)**, "행"은 **문서(document)**에 대응한다.
- **인증**: Firebase Authentication을 이미 사용 중이다 (`backend/app/core/auth.py`가 `Authorization: Bearer <Firebase ID Token>`을 검증해 `uid`를 얻는다). 따라서 **비밀번호는 Firestore에 저장하지 않는다** — Firebase Auth가 자체적으로 안전하게 암호화·검증하므로, 별도로 비밀번호(해시든 평문이든)를 보관하면 오히려 공격 표면과 관리 부담만 늘어난다. `users` 문서의 ID는 Firebase Auth의 `uid`를 그대로 쓴다.
- **필드 네이밍**: Firestore 문서 필드는 **snake_case**로 통일한다 — 이미 구현되어 있는 `chat_history` 컬렉션(`backend/app/services/history_service.py`)이 `message` / `response` / `created_at`처럼 snake_case로 쓰고 있고, Python 백엔드가 `firebase_admin`으로 dict를 그대로 읽고 쓰기 때문이다. REST API 응답(JSON)은 기존처럼 `CamelModel`(`backend/app/schemas/base.py`)이 camelCase로 자동 변환해 Flutter와 맞춘다 — **Firestore(snake_case) ↔ API 응답(camelCase) 변환은 Pydantic 스키마 계층의 책임**이며, 이 문서는 Firestore 쪽 스키마만 다룬다.
- **소프트 삭제**: 요청대로 실제 삭제 대신 `deleted_at`(nullable timestamp)을 채우는 방식을 기본으로 한다. 조회 시 `deleted_at == null` 조건을 추가한다.
- **기존 코드와의 매칭**: 각 필드 옆에 프론트엔드의 어떤 모델/화면과 대응하는지 표시했다 (`frontend/lib/...`). 이미 `TODO(backend)`로 표시된 자리는 🔧로, 이번에 새로 제안하는 컬렉션/필드는 ✨로 표시한다.

---

## 1. `users/{uid}` — 사용자 정보

문서 ID = Firebase Auth `uid`.

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| `user_id` | string | ✅ | Firebase Auth `uid`와 동일값(문서 ID와 중복되지만, `where('user_id', '==', ...)` 류의 collection-group 쿼리 편의를 위해 필드로도 보관). |
| `name` | string | ✅ | 이름. |
| `phone_number` | string | – | E.164 형식 권장(`+821012345678`). |
| `email` | string | – | Firebase Auth 이메일과 동일하게 유지(가입 시 동기화). |
| ~~`password`~~ | – | ❌ **저장 안 함** | Firebase Authentication이 자체 관리한다. 로그인/비밀번호 검증은 클라이언트가 Firebase Auth SDK로 처리하고, 백엔드는 발급된 ID Token만 검증(`core/auth.py`)한다. |
| `visa_type` | string | – | `D-2` / `E-9` / `E-7` / `H-2` / 직접입력 텍스트 — `frontend/lib/core/visa_status.dart`의 `VisaStatus.code`와 동일한 값(단, `ETC` 선택 시엔 사용자가 입력한 자유 텍스트를 그대로 저장한다). |
| `nationality` | string | – | ✨ ISO 3166-1 alpha-2 국가 코드(`VN`, `PH` 등) — `frontend/lib/features/auth/models/country.dart`의 `Country.code`와 동일. 회원가입 폼에서 국가 목록 드롭다운으로 수집한다. |
| `visa_expiry_date` | timestamp | – | 비자 만료일. `frontend/lib/features/encyclopedia/widgets/book_cover.dart`의 D-day 표시(🔧 `visaValue/visaDday`)와 `home_screen.dart`의 `HomeStrings.visaExpiry`를 위한 값 — **D-day는 저장하지 않고 이 날짜에서 매번 계산**한다(정적 정수로 저장하면 하루 지날 때마다 값이 어긋난다). |
| `preferred_language` | string | ✅ | `ko`/`en`/`zh`/`vi` — `frontend/lib/core/app_language.dart`의 `AppLanguage.code`와 동일. 기본값 `ko`. |
| `contract_stored` | boolean | ✅ | 근로계약서 보관함 등록 여부(파일 자체가 아니라 상태만). 기본 `false`. |
| `payslip_stored` | boolean | ✅ | 급여명세서 보관함 등록 여부. 기본 `false`. |
| `onboarding_completed` | boolean | ✅ | 온보딩 완료 여부. 기본 `false`. |
| `lifecycle_stage` | string | – | `backend/app/schemas/chat.py`의 `ChatRequest.lifecycle_stage`와 동일 개념(자유 텍스트) — 에이전트가 답변 맥락을 좁히는 데 사용. |
| `fcm_token` | string | – | ✨(향후) 푸시 알림용 — 비자 만료 D-day 리마인더 등에 쓸 수 있다. 지금 당장 필요한 필드는 아니라 nullable로 열어만 둔다. |
| `created_at` | timestamp | ✅ | 문서 생성 시각(가입 시각). |
| `updated_at` | timestamp | ✅ | 마지막 수정 시각. |
| `deleted_at` | timestamp | – | 소프트 삭제 시각(null이면 활성 사용자). |

> ⚠️ **발견한 불일치**: `backend/app/schemas/chat.py`의 `ChatRequest.visa_group`은 `Literal["E-9", "H-2", "D-2"]`만 허용해 `E-7`이 빠져 있다. `VisaStatus`에는 `E-7`(특정활동)이 있으므로, `users.visa_type`이 `E-7`인 사용자가 챗봇을 쓸 때 값이 씹힌다 — 이 스키마 작업과는 별개로 백엔드 쪽에서 고쳐야 할 항목으로 남겨둔다.

---

## 2. `worklogs` — 캘린더/근무 기록

문서 ID = auto-id. `frontend/lib/features/worklog/controllers/work_log_controller.dart`의 🔧 `TODO(backend): worklogs 컬렉션과 연동`이 가리키는 바로 그 컬렉션이다.

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| `worklog_id` | string | ✅ | 문서 ID와 동일값. |
| `user_id` | string | ✅ | FK → `users.user_id`. 복합 색인: `(user_id, date)`. |
| `date` | timestamp | ✅ | 하루 단위 근무일(자정 기준). 기존 클라이언트의 `Map<DateTime, DailyWorkRecord>` 키에 대응. |
| `clock_in` | timestamp | – | 출근시간. `DailyWorkRecord.clockIn`. |
| `clock_out` | timestamp | – | 퇴근시간. `DailyWorkRecord.clockOut`. |
| `break_minutes` | number(int) | ✅ | 휴게시간(분). 기본 `0`. `DailyWorkRecord.breakMinutes`. |
| `work_type` | string | – | `manufacturing`/`serving`/`delivery`/`other` — `frontend/lib/features/worklog/models/work_type.dart`의 `WorkType`과 동일. |
| `incident_type` | string | – | `normal`/`overtime`/`accident` — 같은 파일의 `IncidentType`과 동일. |
| `memo` | string | ✅ | 비고. 기본 `''`. `DailyWorkRecord.memo`. |
| `is_overtime` | boolean | ✅ | 연장/야간 플래그(달력 점 표시용). 기본 `false`. |
| `is_risk` | boolean | ✅ | 급여 미지급 의심 플래그(달력 붉은 테두리). 기본 `false`. |
| `location_verified` | boolean | ✅ | 위치인증여부. `DailyWorkRecord.gpsVerified` — "📍 위치 인증 완료" vs "📍 사업장 외부 기록" 배지에 대응. 기본 `false`. |
| `verified_latitude` / `verified_longitude` | number | – | ✨(제안) 위치 인증 시점의 좌표. 현재 클라이언트는 bool만 다루지만, 서버 스키마에는 근거 좌표를 남겨 두는 편이 나중에 임금체불·산재 진정 시 증빙력이 있다. |
| `evidence_file_ids` | array\<string\> | – | ✨(제안) 첨부된 사진/명세서 — 아래 §4 `evidence_files.file_id` 참조. 클라이언트의 📷/📎 첨부 버튼(🔧 `work_log_sheet.dart`의 TODO)이 최종적으로 채우게 될 필드. |
| `created_at` / `updated_at` | timestamp | ✅ | 생성/수정 시각. |

> Firestore 관용적으로는 `users/{uid}/worklogs/{date}` 서브컬렉션(문서 ID = `YYYY-MM-DD`)으로 둬도 되지만, 요청하신 대로 `user_id` 컬럼을 명시적으로 두는 평면(top-level) 컬렉션으로 설계했다 — "특정 사용자가 아니라 전체에서 `is_risk=true`인 기록을 찾는" 식의 관리자용 조회가 서브컬렉션보다 단순해지는 장점도 있다.

---

## 3. `organizations` — 기관 정보

문서 ID = auto-id(또는 사람이 읽을 수 있는 slug). 나중에 에이전트가 쓸 `search_support_orgs` 툴(`backend/app/agent/tools.py`)과 `backend/app/services/org_service.py`가 지금은 정적 JSON(`backend/app/data/orgs.json`)을 읽고 있는데, 이 컬렉션으로 옮기는 것을 전제로 설계했다.

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| `org_id` | string | ✅ | 문서 ID와 동일값. |
| `name` | string | ✅ | 기관명. `Org.name`(`frontend/lib/common/models/org.dart`, `backend/app/schemas/org.py`)과 동일. |
| `description` | string | ✅ | 설명(무슨 기관인가). |
| `phone_number` | string | – | 전화번호. |
| `address` | string | ✅ | 주소. |
| `website_url` | string | – | 홈페이지. |
| `email` | string | – | 이메일. |
| `business_hours` | string | – | 이용기간(업무시간). 자유 텍스트(예: `"평일 09:00–18:00, 점심시간 제외"`). |
| `recommended_for` | array\<string\> | – | 추천 대상. 예: `["E-9", "H-2"]`(비자 유형) 또는 `["임금체불", "출산휴가"]`처럼 상황 키워드도 허용. |
| `categories` | array\<string\> | ✅ | 기존 `orgs.json`의 `categories`와 동일(`wage`/`accident`/`general`) — 에이전트 툴이 의도(intent)로 필터링할 때 쓰는 키. |
| `latitude` / `longitude` | number | ✅ | 기존 `orgs.json`의 `lat`/`lng`. `org_service`가 하버사인 거리 계산에 쓴다(`distance_km`는 저장하지 않고 매 요청 시 계산). |
| `languages_supported` | array\<string\> | – | ✨(제안) 상담 가능 언어(`ko`/`en`/`zh`/`vi`). 다국어 지원이 핵심인 앱이라 유용하지만 지금 당장 필수는 아니라 선택 필드로 둔다. |
| `is_active` | boolean | ✅ | 운영 종료된 기관을 물리 삭제 없이 검색에서 숨기기 위한 플래그. 기본 `true`. |
| `created_at` / `updated_at` | timestamp | ✅ | 생성/수정 시각. |

> 마이그레이션: `backend/app/data/orgs.json`의 5개 항목은 `name`/`lat`/`lng`/`categories`만 있으므로, 이 스키마로 옮길 때 `description`/`address`/`phone_number`/`business_hours`/`recommended_for` 등 나머지 필드는 실제 데이터로 채워 넣는 시딩 작업이 별도로 필요하다.

---

## 4. (신규 제안) `evidence_files` — 증빙파일 메타데이터

`backend/app/services/storage_service.py`의 `save_evidence_file()`은 이미 Firebase Storage에 파일을 올리고 `{file_id, stored_path, content_type, size_bytes}`를 반환하지만, 이 결과를 Firestore 어디에도 기록하지 않는다 — 업로드 후 "이 사용자가 어떤 파일을 올렸는지" 목록을 조회할 방법이 없다는 뜻이다. `work_log_sheet.dart`의 📷/📎 첨부 버튼(🔧 TODO)이 실제로 연결되려면 이 메타데이터 컬렉션이 필요하다.

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| `file_id` | string | ✅ | 문서 ID = `storage_service`가 생성하는 `file_id`(uuid4 hex)와 동일값. |
| `user_id` | string | ✅ | FK → `users.user_id`. |
| `case_type` | string | ✅ | `stored_path`의 `{case_type}` 세그먼트와 동일(예: `wage`, `accident`). |
| `stored_path` | string | ✅ | Firebase Storage 경로(`evidence/{uid}/{case_type}/{timestamp}_{file_id}_{filename}`). |
| `content_type` | string | ✅ | MIME 타입. |
| `size_bytes` | number(int) | ✅ | 파일 크기. |
| `worklog_id` | string | – | FK → `worklogs.worklog_id`. 특정 근무기록에 첨부된 경우에만 채운다. |
| `uploaded_at` | timestamp | ✅ | 업로드 시각. |
| `deleted_at` | timestamp | – | 소프트 삭제 시각. |

---

## 5. (이미 구현됨) `chat_history/{uid}/turns/{turnId}`

`backend/app/services/history_service.py`에 이미 구현되어 있다 — 새로 설계할 필요는 없지만, 전체 스키마 그림에서 빠지지 않도록 그대로 문서화해 둔다.

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| `message` | string | ✅ | 사용자 발화. |
| `response` | string | – | 에이전트 응답(`fact_answer`). |
| `created_at` | timestamp | ✅ | 저장 시각. |

---

## 6. (신규 제안, 우선순위 낮음) `user_favorites` — 백과사전 즐겨찾기

`frontend/lib/features/encyclopedia/controllers/encyclopedia_controller.dart`의 `_starredItems`/`_starredGroups`가 지금은 로컬 상태(재시작 시 `{1, 11}`/`{CategoryGroupId.c}`로 리셋)로만 존재한다. 코드에 명시적 `TODO(backend)`는 없지만, 실제 서비스라면 기기를 바꿔도 즐겨찾기가 유지되어야 하므로 서버 저장이 자연스럽다. 다른 항목들보다 우선순위는 낮게 제안한다.

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| `user_id` | string | ✅ | FK → `users.user_id`. |
| `item_type` | string | ✅ | `category_item` \| `category_group`. |
| `item_id` | string | ✅ | 카테고리 항목 ID 또는 그룹 ID(`CategoryGroupId`). |
| `created_at` | timestamp | ✅ | 즐겨찾기에 추가한 시각. |

---

## 7. 인덱스 제안

| 컬렉션 | 복합 색인 | 용도 |
|---|---|---|
| `worklogs` | `user_id ASC, date DESC` | 캘린더 화면에서 특정 사용자의 최근 기록 조회. |
| `worklogs` | `is_risk ASC, date DESC` | (관리자/에이전트) 급여 미지급 의심 기록 전체 조회. |
| `organizations` | `categories ARRAY_CONTAINS, is_active ASC` | 의도(intent)별 활성 기관 검색. |
| `evidence_files` | `user_id ASC, case_type ASC, uploaded_at DESC` | 사용자별 증빙 목록. |

---

## 8. 보안 규칙 스케치 (`firestore.rules`, 초안)

실제 배포용은 아니고, 위 스키마가 어떻게 접근 제어와 맞물리는지 보여주는 스케치다.

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isSignedIn() { return request.auth != null; }
    function isOwner(userId) { return isSignedIn() && request.auth.uid == userId; }

    match /users/{userId} {
      allow read, update: if isOwner(userId);
      allow create: if isOwner(userId);
    }

    match /worklogs/{worklogId} {
      allow read, write: if isSignedIn() && resource.data.user_id == request.auth.uid;
      allow create: if isSignedIn() && request.resource.data.user_id == request.auth.uid;
    }

    match /evidence_files/{fileId} {
      allow read, write: if isSignedIn() && resource.data.user_id == request.auth.uid;
      allow create: if isSignedIn() && request.resource.data.user_id == request.auth.uid;
    }

    // 기관 정보는 누구나 읽을 수 있고(로그인 여부 무관), 쓰기는 백엔드(Admin SDK)만.
    match /organizations/{orgId} {
      allow read: if true;
      allow write: if false;
    }

    match /chat_history/{userId}/turns/{turnId} {
      allow read, write: if isOwner(userId);
    }
  }
}
```
