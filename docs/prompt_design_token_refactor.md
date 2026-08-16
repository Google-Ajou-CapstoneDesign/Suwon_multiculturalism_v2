# Claude Code 프롬프트 — 디자인 토큰 재정립 및 컬러 리팩터링

> 아래 `<<< >>>` 로 표시된 부분은 팀 결정 후 확정해서 보내세요.
> 불필요한 섹션은 지우고 보내도 됩니다.

---

## 프롬프트 본문 (여기부터 복사)

`frontend/` Flutter 앱의 컬러 시스템을 전면 재정립해줘. 아래는 내가 사전에 코드를 분석한 결과이니 다시 조사하지 말고 그대로 전제로 삼되, 수치가 실제와 다르면 알려줘.

### 현재 상태 진단

**1. 팔레트가 Tailwind 기본값 100%다.**
`frontend/lib/theme/app_colors.dart`의 13개 토큰이 전부 Tailwind CSS 기본 램프에서 그대로 가져온 값이다.

| 토큰 | 값 | 정체 |
|---|---|---|
| primary | `#1E40AF` | Tailwind blue-800 |
| secondary | `#0D9488` | Tailwind teal-600 |
| accent | `#D97706` | Tailwind amber-600 |
| background | `#F8FAFC` | Tailwind slate-50 |
| textPrimary | `#1E293B` | Tailwind slate-800 |
| textSecondary | `#64748B` | Tailwind slate-500 |
| textMuted | `#94A3B8` | Tailwind slate-400 |
| border | `#E2E8F0` | Tailwind slate-200 |
| blueBg / blueBorder | `#EFF6FF` / `#BFDBFE` | Tailwind blue-50 / blue-200 |
| amberBg / amberBorder | `#FFFBEB` / `#FDE68A` | Tailwind amber-50 / amber-200 |

Google Capstone 제출물인데 앱 전체에서 실제 Google 색상은 `features/auth/widgets/google_signin_button.dart`의 `#4285F4` 하나뿐이다. 그것도 Google 로그인 브랜드 가이드라인 강제 사항이다.

**2. 토큰을 우회한 하드코딩이 224곳, 25개 파일에 있다.**
`AppColors.` 참조는 402곳인데 `Color(0x...)` 리터럴이 224곳이다. 중복 제외 실사용 색상값은 약 70종이다. **팔레트 파일만 교체하면 앱의 약 64%만 바뀌고 36%는 Tailwind 색으로 남는다. 반드시 함께 정리해야 한다.**

하드코딩이 많은 파일 (내림차순):
- `features/wage_calculator/widgets/wage_result_card.dart` (34)
- `features/navigator_flow/widgets/flow_content_blocks.dart` (32)
- `features/worklog/widgets/work_log_sheet.dart` (21)
- `features/wage_calculator/widgets/wage_form_widgets.dart` (19)
- `features/encyclopedia/widgets/book_cover.dart` (15)
- `features/navigator_flow/widgets/form_editor.dart` (14)
- `features/home/screens/home_screen.dart` (10)
- `features/navigator_flow/widgets/wage_calc_section.dart` (10)
- 그 외 `onboarding_screen`, `splash_screen`, `flow_tracker`, `category_item`, `category_detail_screen`, `main_shell`, `pdf_actions_section`, `injury_guide_section`, `navigator_flow_screen`, `wage_calculator_screen`, `category_toc_page`, `auth_text_field`, `country_sheet`, `signup_form_screen`, `wage_help`, `google_signin_button`

**3. 같은 역할에 서로 다른 값이 중복되어 있다.**
- 파랑 primary 계열 8종: `#1E40AF` `#1D4ED8` `#2563EB` `#1E3A8A` `#16307E` `#2B4E8C` `#2A4C90` `#5B8DEF`
- 틸 secondary 4종: `#0D9488` `#12A594` `#0B7267` `#0F766E`
- 빨강 error 4종: `#DC2626` `#991B1B` `#B33A3A` `#E06060`
- 앰버 경고 텍스트 5종: `#B45309` `#92400E` `#A16207` `#854F0B` `#E08A1E`
- 밝은 배경/면 8종: `#F1F5F9` `#F8FAFC` `#FBFDFF` `#EEF2F7` `#F4F7FC` `#EDF3FB` `#F1F6FC` `#F3F7FF`
- 연파랑 컨테이너 8종: `#EFF6FF` `#EEF3FE` `#F0F5FF` `#EAF0FC` `#E4EBF5` `#E7EDF6` `#DCE6F7` `#C9DBFA`

**근본 원인: `AppColors`에 `error` / `success` / `warning` 시맨틱 토큰이 아예 없다.** 그래서 각 화면이 상태 색을 제각각 발명해 썼다. 이번 리팩터링의 핵심은 색상값 교체가 아니라 이 구조 결함을 없애는 것이다.

**4. 네이비+골드라는 두 번째 테마가 공존한다.**
`#132747` `#1E3A6E` `#0F2947` `#0C1A31` `#152C52` 네이비 + `#E8C88A` 골드 조합이 `splash_screen.dart`, `encyclopedia/widgets/book_cover.dart`, `wage_result_card.dart`, `navigation/main_shell.dart`, `navigator_flow/widgets/pdf_actions_section.dart`, `wage_calc_section.dart`에서 "고급 장정본" 컨셉으로 쓰이고 있다. 전부 `LinearGradient` 기반이라 Material 3의 플랫 원칙과 충돌한다.

**5. 타입 스케일이 없다.**
`fontSize: 7.5`, `10.5`, `11.5`, `12` 같은 임의값이 하드코딩되어 있다. `app_theme.dart`에 `textTheme`은 색상만 지정하고 스케일은 정의하지 않았다.

**6. 다크모드 대응이 없다.**
`app_theme.dart`에 `light`만 있고 `surface: Colors.white`가 하드코딩되어 있다.

---

### 확정된 결정사항

<<< 아래는 예시 값입니다. 팀 결정에 맞춰 수정해서 보내세요. >>>

- **primary**: `#0B57D0` (Material 3 baseline primary)
  - 대안: `#1A73E8` (Google Blue 600, 더 밝음) / `#246BFD` (기존 시안, 단 Google 색 아님)
- **secondary**: 기존 틸 유지하되 `#0F766E` 단일값으로 통일 (40여 곳에서 쓰이므로 제거하지 말 것)
- **error / danger**: `#B3261E` (M3 error)
- **success**: `#1E8E3E` (Google Green 700)
- **warning / caution**: `#F9AB00` (Google Yellow 700)
- **surface / background**: `#FFFFFF` / `#F8F9FA` (Google 중립 그레이. Tailwind slate-50의 푸른기 제거)
- **텍스트**: `#202124` / `#5F6368` / `#80868B`
- **border / outline**: `#DADCE0`
- **컨테이너**: `#E8F0FE`(blue) `#E6F4EA`(green) `#FCE8E6`(red) `#FEF7E0`(yellow)
- **네이비+골드 테마**: `brandNavy` / `brandGold` 토큰으로 명시화해서 유지. 단 그라디언트는 단색 또는 2단계 이하로 단순화
  - 대안 A: 전부 폐기하고 Google 톤으로 통일 (백과·스플래시 재디자인 필요)
  - 대안 B: 스플래시·백과 표지만 유지, 임금결과·PDF·탭바는 Google 톤으로 통일

---

### 작업 범위

**Phase 1 — 토큰 재정의**

1. `frontend/lib/theme/app_colors.dart`를 Material 3 네이밍 체계로 재작성한다.
   - `primary` / `onPrimary` / `primaryContainer` / `onPrimaryContainer`
   - `secondary` / `onSecondary` / `secondaryContainer` / `onSecondaryContainer`
   - `error` / `onError` / `errorContainer` / `onErrorContainer`
   - `success` / `successContainer` / `onSuccessContainer` (M3 표준에 없으므로 확장 토큰으로 명시)
   - `warning` / `warningContainer` / `onWarningContainer`
   - `surface` / `onSurface` / `onSurfaceVariant` / `surfaceContainerLow` / `surfaceContainer` / `surfaceContainerHigh`
   - `outline` / `outlineVariant`
   - `brandNavy` / `brandGold` (확장 토큰)
   - 각 토큰에 "어디에 쓰는 색인지" 한 줄 주석을 단다.
2. `frontend/lib/theme/app_theme.dart`에 `light`와 `dark` 두 `ThemeData`를 만든다.
   - `ColorScheme.fromSeed` 대신 `ColorScheme(...)`로 전 필드를 명시 지정한다. `fromSeed`는 지정하지 않은 필드를 자동 생성해 의도치 않은 색이 섞인다.
   - `textTheme`에 M3 타입 스케일(`displayLarge` ~ `labelSmall`)을 전부 정의한다. 한국어 가독성을 고려해 `height`를 1.4~1.5로 잡는다.
   - `cardTheme`, `filledButtonTheme`, `outlinedButtonTheme`, `chipTheme`, `navigationBarTheme`, `inputDecorationTheme`, `dividerTheme`를 정의해 개별 위젯에서 스타일을 반복 지정할 필요가 없게 한다.

**Phase 2 — 하드코딩 224곳 정리**

3. 먼저 `docs/color_migration_map.md`에 매핑표를 만든다. 컬럼: `기존 hex | 사용 파일:라인 | 추정 역할 | 신규 토큰 | 판단 근거`.
   - 애매한 항목은 임의 판단하지 말고 `[확인필요]`로 표시하고 별도 목록으로 뽑아서 나에게 물어봐라.
4. 매핑표 승인 후 파일별로 치환한다. **한 번에 한 파일씩, 파일 단위로 커밋**해라. 25개 파일을 한 커밋에 몰지 마라.
5. 치환 후 `Color(0x` 리터럴이 남아 있는지 grep으로 검증한다. 남아야 하는 예외는 다음뿐이다:
   - `google_signin_button.dart`의 `#4285F4` (Google 브랜드 가이드라인 강제)
   - 순수 투명도 오버레이 (`Color(0x17FFFFFF)` 등) — 단 이것도 `withOpacity()`로 바꿀 수 있으면 바꿔라

**Phase 3 — 접근성 검증**

6. 모든 전경/배경 조합의 WCAG 대비율을 계산하는 스크립트를 `tool/check_contrast.dart`로 작성하고 실행한다.
   - 본문 텍스트 4.5:1, 큰 텍스트 및 UI 컴포넌트 3:1 기준
   - 미달 항목은 표로 리포트하고 수정 제안까지 낸다
   - 특히 앰버/옐로우 위 흰 텍스트 조합을 반드시 확인해라 (현재 미달 가능성이 높다)
7. 색상만으로 상태를 전달하는 지점(성공=초록 / 위험=빨강)을 찾아서 아이콘이나 텍스트 레이블이 함께 있는지 확인하고, 없으면 목록으로 보고해라. 색맹 사용자 대응이다.

**Phase 4 — 다국어 레이아웃 검증**

8. 이 앱은 이주민 대상 다국어 앱이다(`CLAUDE.md` 참조). 한국어 대비 텍스트가 1.5~2배 길어지는 언어(베트남어, 태국어, 러시아어 등)에서 레이아웃이 깨지지 않는지 확인해라.
   - 고정 `width`/`height`가 걸린 텍스트 컨테이너를 찾아 목록화
   - 버튼·칩·탭 레이블이 `overflow: TextOverflow.ellipsis` 없이 쓰인 곳 목록화
   - 실제 수정은 하지 말고 목록만 먼저 보고해라

---

### 제약 조건

- **기능 동작은 절대 변경하지 마라.** 이번 작업은 순수 시각 리팩터링이다. 로직, 상태 관리, 라우팅, API 호출은 건드리지 않는다.
- **레이아웃 구조를 바꾸지 마라.** 위젯 트리 변경 없이 색상·타이포·테마만 바꾼다. 구조 개선 아이디어가 있으면 코드로 반영하지 말고 별도로 제안해라.
- **`Colors.red` 같은 Flutter 기본 색상 상수를 새로 도입하지 마라.** 전부 `AppColors` 토큰을 경유한다.
- **그라디언트는 새로 추가하지 마라.** 기존 것은 단순화하거나 단색으로 대체한다.
- 각 Phase가 끝나면 멈추고 결과를 보고해라. 내 승인 없이 다음 Phase로 넘어가지 마라.

### 산출물

1. `frontend/lib/theme/app_colors.dart` (재작성)
2. `frontend/lib/theme/app_theme.dart` (재작성, light + dark)
3. `docs/color_migration_map.md` (매핑표)
4. `tool/check_contrast.dart` + 대비 검증 리포트
5. 다국어 레이아웃 리스크 목록
6. 파일 단위 커밋 히스토리

### 시작 방법

먼저 Phase 1만 수행하고 멈춰라. `app_colors.dart`와 `app_theme.dart` 초안을 보여주고, 내가 확인한 뒤 Phase 2로 넘어간다.

작업 전에 위 진단 내용 중 실제 코드와 다른 부분이 있으면 먼저 지적해라.
