import 'package:flutter/material.dart';
import '../../../common/widgets/app_card.dart';
import '../../../common/widgets/language_sheet.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../core/visa_status.dart';
import '../../../theme/app_colors.dart';
import '../../auth/models/country.dart';
import '../../auth/screens/login_screen.dart';
import '../../auth/services/auth_service.dart';
import '../../auth/services/user_profile_api_service.dart';
import '../../auth/widgets/auth_text_field.dart';
import '../../auth/widgets/country_sheet.dart';
import '../../auth/widgets/visa_picker.dart';
import '../../onboarding/screens/guide_screen.dart';
import '../../worklog/widgets/vault_box.dart';
import '../models/settings_strings.dart';

/// Tab 4 · 설정. design_files/App_Design.html의 settingsHTML() 레이아웃을
/// 그대로 옮겼다 — 프로필 요약 카드 → 기본 설정(언어/비자/프로필/알림) →
/// 부가 설정(증빙 보관함/사용 가이드/AI 가이드) → (로그인 상태면) 로그아웃.
/// 시안에서 "비자 정보"와 "프로필"은 같은 편집 모달을 연다.
class SettingsHomeScreen extends StatelessWidget {
  const SettingsHomeScreen({super.key, required this.onOpenAiChat});

  /// AI 가이드 행 — MainShell이 오버레이로 띄우는 AI 챗봇 시트를 연다.
  final VoidCallback onOpenAiChat;

  void _openVault(BuildContext context, AppLanguage lang) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 26),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(sheetContext).size.height * 0.85,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF1F5F9),
                    foregroundColor: AppColors.textSecondary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    SettingsStrings.closeButton.of(lang),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: VaultBox(language: lang),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openProfileEditor(BuildContext context, UserProfileController profile) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProfileEditSheet(profile: profile),
    );
  }

  Future<void> _logout(
    BuildContext context,
    UserProfileController profile,
  ) async {
    try {
      await AuthService().signOut();
    } catch (_) {
      // Firebase 로그아웃이 실패해도 로컬 상태는 정리한다 — 다음 로그인 전까지
      // 계정 정보가 남아있는 쪽이 더 나쁘다.
    }
    if (context.mounted) profile.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final profile = UserProfileScope.of(context);
    final lang = profile.language;
    final signedIn = profile.isSignedIn;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
          children: [
            Text(
              SettingsStrings.eyebrow.of(lang),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              SettingsStrings.tabTitle.of(lang),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 16),

            // 프로필 요약 카드.
            AppCard(
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.pale,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      size: 22,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.displayNameOrEmailPrefix ??
                              SettingsStrings.guestName.of(lang),
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          signedIn
                              ? (profile.email ?? '')
                              : SettingsStrings.guestSubtitle.of(lang),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!signedIn)
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 9,
                        ),
                        textStyle: const TextStyle(fontSize: 12.5),
                      ),
                      child: Text(SettingsStrings.loginButton.of(lang)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 기본 설정 카드.
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsRow(
                    icon: Icons.language_outlined,
                    label: SettingsStrings.languageLabel.of(lang),
                    value: lang.nativeName,
                    onTap: () => showLanguageSheet(
                      context,
                      current: lang,
                      onSelect: profile.setLanguage,
                    ),
                  ),
                  _SettingsRow(
                    icon: Icons.badge_outlined,
                    label: SettingsStrings.visaLabel.of(lang),
                    value:
                        profile.visaStatus?.code ??
                        SettingsStrings.visaNotSet.of(lang),
                    onTap: () => _openProfileEditor(context, profile),
                  ),
                  _SettingsRow(
                    icon: Icons.person_outline,
                    label: SettingsStrings.profileLabel.of(lang),
                    value: profile.displayNameOrEmailPrefix ?? '',
                    onTap: () => _openProfileEditor(context, profile),
                  ),
                  _SettingsToggleRow(
                    icon: Icons.notifications_outlined,
                    label: SettingsStrings.notificationLabel.of(lang),
                    value: profile.notificationsEnabled,
                    onChanged: (_) {
                      profile.toggleNotifications();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            SettingsStrings.notificationToast.of(lang),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 부가 설정 카드.
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsRow(
                    icon: Icons.folder_shared_outlined,
                    label: SettingsStrings.vaultLabel.of(lang),
                    onTap: () => _openVault(context, lang),
                  ),
                  _SettingsRow(
                    icon: Icons.menu_book_outlined,
                    label: SettingsStrings.guideLabel.of(lang),
                    onTap: () => Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => const GuideScreen())),
                  ),
                  _SettingsRow(
                    icon: Icons.smart_toy_outlined,
                    label: SettingsStrings.aiGuideLabel.of(lang),
                    onTap: onOpenAiChat,
                    isLast: true,
                  ),
                ],
              ),
            ),

            if (signedIn) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _logout(context, profile),
                  child: Text(SettingsStrings.logoutButton.of(lang)),
                ),
              ),
            ],

            const SizedBox(height: 20),
            Text(
              SettingsStrings.bottomNote.of(lang),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    this.value,
    required this.onTap,
    this.isLast = false,
  });
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Row(
              children: [
                Icon(icon, size: 19, color: AppColors.primary),
                const SizedBox(width: 13),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                if (value != null && value!.isNotEmpty) ...[
                  Text(
                    value!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: AppColors.border,
          ),
      ],
    );
  }
}

class _SettingsToggleRow extends StatelessWidget {
  const _SettingsToggleRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          child: Row(
            children: [
              Icon(icon, size: 19, color: AppColors.primary),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeTrackColor: AppColors.primary,
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: AppColors.border,
          ),
      ],
    );
  }
}

/// "비자 정보"/"프로필" 행이 함께 여는 편집 모달 — 이름·국적·체류자격을 한
/// 폼에서 받아 저장한다. 로그인 상태면 PUT /api/users/me까지 호출하고,
/// 게스트면 로컬 상태만 갱신한다(시안의 state.profile={...} 동작과 동일).
class _ProfileEditSheet extends StatefulWidget {
  const _ProfileEditSheet({required this.profile});
  final UserProfileController profile;

  @override
  State<_ProfileEditSheet> createState() => _ProfileEditSheetState();
}

class _ProfileEditSheetState extends State<_ProfileEditSheet> {
  late final _nameController = TextEditingController(
    text: widget.profile.displayName ?? '',
  );
  final _customVisaController = TextEditingController();
  late VisaStatus _visa = widget.profile.visaStatus ?? VisaStatus.e9;
  String? _nationalityCode;
  bool _saving = false;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    _nationalityCode = widget.profile.nationality;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _customVisaController.dispose();
    super.dispose();
  }

  Country? get _selectedCountry =>
      countries.where((c) => c.code == _nationalityCode).firstOrNull;

  Future<void> _save(AppLanguage lang) async {
    final name = _nameController.text.trim();
    setState(
      () => _nameError = name.isEmpty ? SettingsStrings.errorName.of(lang) : null,
    );
    if (name.isEmpty) return;
    if (_visa == VisaStatus.etc && _customVisaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(SettingsStrings.errorCustomVisa.of(lang))),
      );
      return;
    }

    setState(() => _saving = true);
    final visaTypeValue = _visa == VisaStatus.etc
        ? _customVisaController.text.trim()
        : _visa.code;
    final profile = widget.profile;
    if (profile.isSignedIn) {
      try {
        final idToken = await AuthService().currentIdToken();
        if (idToken != null) {
          await UserProfileApiService().upsertProfile(
            idToken: idToken,
            name: name,
            visaType: visaTypeValue,
            nationality: _nationalityCode,
            preferredLanguage: lang.code.toLowerCase(),
          );
        }
      } catch (_) {
        // 저장 실패해도 아래에서 로컬 상태는 반영한다(다른 편집 흐름과 동일한
        // 낙관적 업데이트) — 게스트도 이 경로를 그대로 타면서 서버 호출만 건너뛴다.
      }
    }
    profile.updateProfileFields(
      name: name,
      nationality: _nationalityCode,
      visa: _visa,
    );
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(SettingsStrings.profileSaved.of(lang)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.profile.language;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        builder: (context, scrollController) {
          return Material(
            color: AppColors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(23)),
            clipBehavior: Clip.antiAlias,
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 26),
              children: [
                Text(
                  SettingsStrings.profileEditTitle.of(lang),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 18),
                AuthTextField(
                  label: SettingsStrings.nameFieldLabel.of(lang),
                  controller: _nameController,
                  errorText: _nameError,
                ),
                const SizedBox(height: 16),
                Text(
                  SettingsStrings.nationalityFieldLabel.of(lang),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => showCountrySheet(
                    context,
                    language: lang,
                    current: _nationalityCode,
                    onSelect: (c) => setState(() => _nationalityCode = c.code),
                  ),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedCountry?.name.of(lang) ??
                                SettingsStrings.nationalityPlaceholder.of(lang),
                            style: TextStyle(
                              fontSize: 13.5,
                              color: _selectedCountry == null
                                  ? AppColors.textMuted
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const Icon(Icons.expand_more, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                VisaPicker(
                  language: lang,
                  value: _visa,
                  onChanged: (v) => setState(() => _visa = v),
                  customTextController: _customVisaController,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : () => _save(lang),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(SettingsStrings.saveButton.of(lang)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
