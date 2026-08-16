# 컬러 마이그레이션 맵

Phase 2에서 `Color(0x...)` 하드코딩 210건(24개 파일)을 `AppColors` 토큰으로 치환한 기록.
적용 스크립트: 정규식 기반 exact-hex 치환(`const Color(0xFFXXXXXX)` / `Color(0xFFXXXXXX)` → `AppColors.token`),
이후 `flutter analyze`로 `const` 컨텍스트 충돌(withValues는 const 메서드가 아님)을 전수 확인해 수동 수정.

| 기존 hex | 건수 | 사용 파일:라인(대표) | 신규 토큰 | 판단 근거 |
|---|---|---|---|---|
| `0xFF0B7267` | 17 | navigation/main_shell.dart:254<br>features/worklog/widgets/work_log_sheet.dart:1090<br>features/worklog/widgets/work_log_sheet.dart:1299<br>features/worklog/widgets/work_log_sheet.dart:1565<br>features/wage_calculator/widgets/wage_result_card.dart:488<br>features/wage_calculator/widgets/wage_result_card.dart:513<br>… 외 11곳 | `AppColors.onSecondaryContainer` |  |
| `0xFFF1F5F9` | 15 | features/worklog/widgets/work_log_sheet.dart:549<br>features/worklog/widgets/work_log_sheet.dart:1553<br>features/wage_calculator/screens/wage_calculator_screen.dart:1272<br>features/wage_calculator/widgets/wage_form_widgets.dart:137<br>features/wage_calculator/widgets/wage_form_widgets.dart:262<br>features/wage_calculator/widgets/wage_help.dart:40<br>… 외 9곳 | `AppColors.surfaceContainer` |  |
| `0xFFE8C88A` | 9 | navigation/main_shell.dart:431<br>features/encyclopedia/widgets/book_cover.dart:74<br>features/encyclopedia/widgets/book_cover.dart:126<br>features/wage_calculator/widgets/wage_result_card.dart:303<br>features/wage_calculator/widgets/wage_result_card.dart:373<br>features/wage_calculator/widgets/wage_result_card.dart:849<br>… 외 3곳 | `AppColors.brandGold` |  |
| `0xFFFBFDFF` | 9 | features/worklog/widgets/work_log_sheet.dart:1048<br>features/wage_calculator/widgets/wage_form_widgets.dart:138<br>features/wage_calculator/widgets/wage_form_widgets.dart:228<br>features/navigator_flow/screens/navigator_flow_screen.dart:401<br>features/navigator_flow/widgets/form_editor.dart:201<br>features/onboarding/screens/onboarding_screen.dart:585<br>… 외 3곳 | `AppColors.surfaceContainerLowest` |  |
| `0xFFE6F6F4` | 8 | features/encyclopedia/models/category_item.dart:178<br>features/worklog/widgets/work_log_sheet.dart:1287<br>features/worklog/widgets/work_log_sheet.dart:1552<br>features/navigator_flow/screens/navigator_flow_screen.dart:98<br>features/navigator_flow/widgets/flow_content_blocks.dart:252<br>features/navigator_flow/widgets/form_editor.dart:29<br>… 외 2곳 | `AppColors.secondaryContainer` |  |
| `0xFF1D4ED8` | 8 | features/wage_calculator/screens/wage_calculator_screen.dart:771<br>features/wage_calculator/widgets/wage_form_widgets.dart:347<br>features/navigator_flow/widgets/flow_content_blocks.dart:260<br>features/navigator_flow/widgets/flow_content_blocks.dart:482<br>features/navigator_flow/widgets/flow_content_blocks.dart:548<br>features/navigator_flow/widgets/form_editor.dart:35<br>… 외 2곳 | `AppColors.onPrimaryContainer` |  |
| `0xFFEAF7F5` | 7 | features/wage_calculator/widgets/wage_result_card.dart:462<br>features/wage_calculator/widgets/wage_result_card.dart:605<br>features/navigator_flow/widgets/flow_content_blocks.dart:110<br>features/navigator_flow/widgets/injury_guide_section.dart:135<br>features/navigator_flow/widgets/wage_calc_section.dart:694<br>features/onboarding/screens/onboarding_screen.dart:451<br>… 외 1곳 | `AppColors.secondaryContainer` |  |
| `0xFFEEF3FE` | 6 | features/encyclopedia/models/category_item.dart:164<br>features/wage_calculator/screens/wage_calculator_screen.dart:759<br>features/navigator_flow/widgets/flow_content_blocks.dart:259<br>features/navigator_flow/widgets/flow_content_blocks.dart:474<br>features/navigator_flow/widgets/form_editor.dart:34<br>features/navigator_flow/widgets/form_editor.dart:276 | `AppColors.primaryContainer` |  |
| `0xFF1E3A8A` | 6 | features/worklog/widgets/work_log_sheet.dart:999<br>features/wage_calculator/widgets/wage_result_card.dart:490<br>features/wage_calculator/widgets/wage_result_card.dart:515<br>features/wage_calculator/widgets/wage_result_card.dart:530<br>features/navigator_flow/widgets/flow_content_blocks.dart:106<br>features/navigator_flow/widgets/wage_calc_section.dart:477 | `AppColors.onPrimaryContainer` |  |
| `0xFFB4E0D9` | 6 | features/wage_calculator/widgets/wage_result_card.dart:468<br>features/wage_calculator/widgets/wage_result_card.dart:606<br>features/navigator_flow/widgets/flow_content_blocks.dart:111<br>features/navigator_flow/widgets/wage_calc_section.dart:695<br>features/onboarding/screens/onboarding_screen.dart:452<br>features/onboarding/screens/onboarding_screen.dart:587 | `AppColors.secondary` |  |
| `0xFFFEF3E2` | 5 | features/encyclopedia/models/category_item.dart:192<br>features/worklog/widgets/work_log_sheet.dart:1288<br>features/worklog/widgets/work_log_sheet.dart:1361<br>features/wage_calculator/widgets/wage_result_card.dart:270<br>features/navigator_flow/screens/navigator_flow_screen.dart:97 | `AppColors.warningContainer` |  |
| `0xFFB45309` | 5 | features/worklog/widgets/work_log_sheet.dart:1076<br>features/worklog/widgets/work_log_sheet.dart:1300<br>features/wage_calculator/widgets/wage_result_card.dart:278<br>features/navigator_flow/screens/navigator_flow_screen.dart:100<br>features/home/screens/home_screen.dart:992 | `AppColors.onWarningContainer` |  |
| `0xFF334155` | 5 | features/wage_calculator/widgets/wage_form_widgets.dart:113<br>features/wage_calculator/widgets/wage_form_widgets.dart:202<br>features/wage_calculator/widgets/wage_form_widgets.dart:433<br>features/navigator_flow/widgets/flow_tracker.dart:179<br>features/navigator_flow/widgets/flow_content_blocks.dart:210 | `AppColors.onSurfaceVariant` |  |
| `0xFFF3F7FF` | 5 | features/wage_calculator/widgets/wage_form_widgets.dart:334<br>features/wage_calculator/widgets/wage_form_widgets.dart:382<br>features/navigator_flow/widgets/flow_content_blocks.dart:36<br>features/navigator_flow/widgets/wage_calc_section.dart:690<br>features/onboarding/screens/onboarding_screen.dart:498 | `AppColors.primaryContainer` |  |
| `0xFF991B1B` | 4 | features/wage_calculator/widgets/wage_form_widgets.dart:473<br>features/wage_calculator/widgets/wage_result_card.dart:491<br>features/wage_calculator/widgets/wage_result_card.dart:516<br>features/wage_calculator/widgets/wage_result_card.dart:531 | `AppColors.onErrorContainer` |  |
| `0xFFCBD5E1` | 4 | features/wage_calculator/widgets/wage_form_widgets.dart:584<br>features/navigator_flow/widgets/flow_tracker.dart:69<br>features/navigator_flow/widgets/flow_tracker.dart:101<br>features/navigator_flow/widgets/flow_content_blocks.dart:195 | `AppColors.outlineVariant` |  |
| `0xFFA8BEDC` | 4 | features/wage_calculator/widgets/wage_result_card.dart:802<br>features/wage_calculator/widgets/wage_result_card.dart:915<br>features/navigator_flow/widgets/pdf_actions_section.dart:142<br>features/navigator_flow/widgets/wage_calc_section.dart:597 | `AppColors.onInverseSurface` |  |
| `0xFF12A594` | 3 | navigation/main_shell.dart:254<br>features/worklog/widgets/work_log_sheet.dart:1090<br>features/home/screens/home_screen.dart:1004 | `AppColors.secondary` |  |
| `0xFF0D9488` | 3 | navigation/main_shell.dart:258<br>features/encyclopedia/models/category_item.dart:177<br>features/onboarding/screens/splash_screen.dart:108 | `AppColors.secondary` |  |
| `0xFFDC2626` | 3 | features/encyclopedia/screens/category_detail_screen.dart:266<br>features/worklog/widgets/work_log_sheet.dart:731<br>features/worklog/widgets/work_log_sheet.dart:819 | `AppColors.error` |  |
| `0xFFF8FAFC` | 3 | features/wage_calculator/widgets/wage_form_widgets.dart:583<br>features/navigator_flow/widgets/flow_content_blocks.dart:415<br>features/navigator_flow/widgets/wage_calc_section.dart:367 | `AppColors.surfaceContainerLow` |  |
| `0xFF0F2947` | 3 | features/wage_calculator/widgets/wage_result_card.dart:288<br>features/navigator_flow/widgets/pdf_actions_section.dart:86<br>features/navigator_flow/widgets/wage_calc_section.dart:547 | `AppColors.brandNavy` |  |
| `0xFFC9DBFA` | 3 | features/wage_calculator/widgets/wage_result_card.dart:470<br>features/navigator_flow/widgets/flow_content_blocks.dart:105<br>features/navigator_flow/widgets/wage_calc_section.dart:481 | `AppColors.primary` |  |
| `0xFF0F766E` | 3 | features/wage_calculator/widgets/wage_result_card.dart:649<br>features/navigator_flow/widgets/flow_content_blocks.dart:113<br>features/onboarding/screens/onboarding_screen.dart:464 | `AppColors.secondary` |  |
| `0xFF94A3B8` | 3 | features/navigator_flow/widgets/flow_content_blocks.dart:267<br>features/navigator_flow/widgets/flow_content_blocks.dart:549<br>features/navigator_flow/widgets/form_editor.dart:40 | `AppColors.textMuted` |  |
| `0xFF152C52` | 2 | navigation/main_shell.dart:409<br>navigation/main_shell.dart:413 | `AppColors.brandNavy` |  |
| `0xFF1E40AF` | 2 | features/encyclopedia/models/category_item.dart:163<br>features/home/screens/home_screen.dart:913 | `AppColors.primary` |  |
| `0xFF1E3A6E` | 2 | features/encyclopedia/widgets/book_cover.dart:27<br>features/onboarding/screens/splash_screen.dart:40 | `AppColors.brandNavy` |  |
| `0xFF132747` | 2 | features/encyclopedia/widgets/book_cover.dart:27<br>features/onboarding/screens/splash_screen.dart:40 | `AppColors.brandNavy` |  |
| `0xFFDCE7F7` | 2 | features/encyclopedia/widgets/book_cover.dart:191<br>features/encyclopedia/widgets/book_cover.dart:198 | `AppColors.primaryContainer` |  |
| `0xFFEEF2F7` | 2 | features/encyclopedia/widgets/category_toc_page.dart:133<br>features/encyclopedia/widgets/category_toc_page.dart:217 | `AppColors.outlineVariant` |  |
| `0xFFE06060` | 2 | features/worklog/widgets/work_log_sheet.dart:632<br>features/worklog/widgets/work_log_sheet.dart:717 | `AppColors.error` |  |
| `0xFF5B8DEF` | 2 | features/worklog/widgets/work_log_sheet.dart:634<br>features/worklog/widgets/work_log_sheet.dart:719 | `AppColors.primary` |  |
| `0xFFE08A1E` | 2 | features/worklog/widgets/work_log_sheet.dart:1076<br>features/home/screens/home_screen.dart:992 | `AppColors.warning` |  |
| `0xFFC6D2E2` | 2 | features/worklog/widgets/work_log_sheet.dart:1588<br>features/onboarding/screens/onboarding_screen.dart:587 | `AppColors.outlineVariant` |  |
| `0xFFFEF2F2` | 2 | features/wage_calculator/widgets/wage_form_widgets.dart:461<br>features/wage_calculator/widgets/wage_result_card.dart:465 | `AppColors.errorContainer` |  |
| `0xFFF6C9C9` | 2 | features/wage_calculator/widgets/wage_form_widgets.dart:462<br>features/wage_calculator/widgets/wage_result_card.dart:471 | `AppColors.error` |  |
| `0x59E8C88A` | 2 | features/wage_calculator/widgets/wage_result_card.dart:360<br>features/wage_calculator/widgets/wage_result_card.dart:835 | `AppColors.brandGold.withValues(alpha: 0.35)` | 투명 오버레이 → 토큰 + withValues |
| `0xFFF0F5FF` | 2 | features/wage_calculator/widgets/wage_result_card.dart:464<br>features/navigator_flow/widgets/flow_content_blocks.dart:104 | `AppColors.primaryContainer` |  |
| `0xFFF1F6FC` | 2 | features/wage_calculator/widgets/wage_result_card.dart:813<br>features/navigator_flow/widgets/pdf_actions_section.dart:97 | `AppColors.surfaceContainer` |  |
| `0xFFB9C4D2` | 2 | features/navigator_flow/widgets/flow_content_blocks.dart:264<br>features/navigator_flow/widgets/form_editor.dart:447 | `AppColors.textMuted` |  |
| `0xFFE4EBF5` | 2 | features/home/screens/home_screen.dart:196<br>features/home/screens/home_screen.dart:247 | `AppColors.outlineVariant` |  |
| `0xFFE7EDF6` | 2 | features/home/screens/home_screen.dart:409<br>features/home/screens/home_screen.dart:863 | `AppColors.outlineVariant` |  |
| `0xFF2B4E8C` | 1 | navigation/main_shell.dart:409 | `AppColors.brandNavy` |  |
| `0xFFD97706` | 1 | features/encyclopedia/models/category_item.dart:191 | `AppColors.tertiary` |  |
| `0xB8E8C88A` | 1 | features/encyclopedia/widgets/book_cover.dart:42 | `AppColors.brandGold.withValues(alpha: 0.72)` | 투명 오버레이 → 토큰 + withValues |
| `0xFFF4F7FC` | 1 | features/encyclopedia/widgets/book_cover.dart:52 | `AppColors.surfaceContainerLow` |  |
| `0x99D6E4F8` | 1 | features/encyclopedia/widgets/book_cover.dart:63 | `AppColors.inversePrimary.withValues(alpha: 0.6)` | 투명 오버레이 → 토큰 + withValues |
| `0x00E8C88A` | 1 | features/encyclopedia/widgets/book_cover.dart:74 | `AppColors.brandGold.withValues(alpha: 0.0)` | 투명 오버레이 → 토큰 + withValues |
| `0x48E8C88A` | 1 | features/encyclopedia/widgets/book_cover.dart:85 | `AppColors.brandGold.withValues(alpha: 0.28)` | 투명 오버레이 → 토큰 + withValues |
| `0xCCE8C88A` | 1 | features/encyclopedia/widgets/book_cover.dart:101 | `AppColors.brandGold.withValues(alpha: 0.8)` | 투명 오버레이 → 토큰 + withValues |
| `0xFFEDF3FB` | 1 | features/encyclopedia/widgets/book_cover.dart:112 | `AppColors.surfaceContainer` |  |
| `0xFF3D2E12` | 1 | features/encyclopedia/widgets/book_cover.dart:132 | `AppColors.onTertiaryContainer` |  |
| `0x8CD6E4F8` | 1 | features/encyclopedia/widgets/book_cover.dart:144 | `AppColors.inversePrimary.withValues(alpha: 0.55)` | 투명 오버레이 → 토큰 + withValues |
| `0x80D6E4F8` | 1 | features/encyclopedia/widgets/book_cover.dart:157 | `AppColors.inversePrimary.withValues(alpha: 0.5)` | 투명 오버레이 → 토큰 + withValues |
| `0xFF7C8BA1` | 1 | features/encyclopedia/widgets/book_cover.dart:228 | `AppColors.onSurfaceVariant` |  |
| `0xB8FFFFFF` | 1 | features/encyclopedia/screens/category_detail_screen.dart:59 | `AppColors.surface.withValues(alpha: 0.72)` | 투명 오버레이 → 토큰 + withValues |
| `0xFFFDE047` | 1 | features/encyclopedia/screens/category_detail_screen.dart:72 | `AppColors.warning` |  |
| `0xFF2563EB` | 1 | features/encyclopedia/screens/category_detail_screen.dart:265 | `AppColors.primary` |  |
| `0xFF6B7280` | 1 | features/encyclopedia/screens/category_detail_screen.dart:267 | `AppColors.onSurfaceVariant` |  |
| `0xFFEFF6FF` | 1 | features/worklog/widgets/work_log_sheet.dart:1251 | `AppColors.primaryContainer` |  |
| `0xFFB33A3A` | 1 | features/wage_calculator/widgets/wage_form_widgets.dart:481 | `AppColors.onErrorContainer` |  |
| `0xFFEEF2FF` | 1 | features/wage_calculator/widgets/wage_form_widgets.dart:615 | `AppColors.primaryContainer` |  |
| `0xFFC7D2FE` | 1 | features/wage_calculator/widgets/wage_form_widgets.dart:616 | `AppColors.primary` |  |
| `0xFF3730A3` | 1 | features/wage_calculator/widgets/wage_form_widgets.dart:624 | `AppColors.onPrimaryContainer` |  |
| `0xFF8FA9CC` | 1 | features/wage_calculator/widgets/wage_result_card.dart:311 | `AppColors.onInverseSurface` |  |
| `0x17FFFFFF` | 1 | features/wage_calculator/widgets/wage_result_card.dart:316 | `AppColors.surface.withValues(alpha: 0.09)` | 투명 오버레이 → 토큰 + withValues |
| `0xFF6D86AC` | 1 | features/wage_calculator/widgets/wage_result_card.dart:813 | `AppColors.onSurfaceVariant` |  |
| `0x26FFFFFF` | 1 | features/wage_calculator/widgets/wage_result_card.dart:907 | `AppColors.surface.withValues(alpha: 0.15)` | 투명 오버레이 → 토큰 + withValues |
| `0xFFE2E8F0` | 1 | features/navigator_flow/widgets/flow_tracker.dart:83 | `AppColors.outline` |  |
| `0xFFFDF0DC` | 1 | features/navigator_flow/widgets/flow_tracker.dart:106 | `AppColors.warningContainer` |  |
| `0xFFFFF8EC` | 1 | features/navigator_flow/widgets/flow_content_blocks.dart:98 | `AppColors.warningContainer` |  |
| `0xFFF5D9A8` | 1 | features/navigator_flow/widgets/flow_content_blocks.dart:99 | `AppColors.warning` |  |
| `0xFF92400E` | 1 | features/navigator_flow/widgets/flow_content_blocks.dart:100 | `AppColors.onWarningContainer` |  |
| `0xFFA16207` | 1 | features/navigator_flow/widgets/flow_content_blocks.dart:101 | `AppColors.onWarningContainer` |  |
| `0xFF2A4C90` | 1 | features/navigator_flow/widgets/flow_content_blocks.dart:107 | `AppColors.onPrimaryContainer` |  |
| `0xFF0F172A` | 1 | features/navigator_flow/widgets/flow_content_blocks.dart:257 | `AppColors.onSurface` |  |
| `0xFFBFDBFE` | 1 | features/navigator_flow/widgets/wage_calc_section.dart:691 | `AppColors.primary` |  |
| `0xFF0C1A31` | 1 | features/onboarding/screens/splash_screen.dart:40 | `AppColors.brandNavy` |  |
| `0xB8CEDEF5` | 1 | features/onboarding/screens/splash_screen.dart:83 | `AppColors.inversePrimary.withValues(alpha: 0.72)` | 투명 오버레이 → 토큰 + withValues |
| `0x8CE8C88A` | 1 | features/onboarding/screens/splash_screen.dart:127 | `AppColors.brandGold.withValues(alpha: 0.55)` | 투명 오버레이 → 토큰 + withValues |
| `0xFFDCE6F7` | 1 | features/home/screens/home_screen.dart:558 | `AppColors.primaryContainer` |  |
| `0xFF16307E` | 1 | features/home/screens/home_screen.dart:913 | `AppColors.brandNavy` |  |
| `0xFFEAF0FC` | 1 | features/home/screens/home_screen.dart:964 | `AppColors.primaryContainer` |  |
| `0xFF4285F4` | 1 | features/auth/widgets/google_signin_button.dart:39 | `(예외 유지 — Google 로그인 브랜드 가이드라인)` | Google 브랜드 고정색, 토큰화 금지 대상 |
