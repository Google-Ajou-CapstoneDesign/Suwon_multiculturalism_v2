import 'package:flutter/material.dart';
import '../../../common/widgets/app_card.dart';
import '../../../common/widgets/language_sheet.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';

/// Tab 4 · 설정. 언어·비자·프로필·알림 관리.
/// TODO(backend): Firebase Auth 프로필 및 users 컬렉션 값과 연동, 로그아웃 처리.
class SettingsHomeScreen extends StatelessWidget {
  const SettingsHomeScreen({super.key});

  static const _tabTitle = L10nText(
    ko: '설정',
    en: 'Settings',
    zh: '设置',
    vi: 'Cài đặt',
  );
  static const _languageLabel = L10nText(
    ko: '언어 설정',
    en: 'Language',
    zh: '语言设置',
    vi: 'Ngôn ngữ',
  );
  static const _visaLabel = L10nText(
    ko: '비자 정보',
    en: 'Visa info',
    zh: '签证信息',
    vi: 'Thông tin visa',
  );
  static const _profileLabel = L10nText(
    ko: '프로필',
    en: 'Profile',
    zh: '个人资料',
    vi: 'Hồ sơ',
  );
  static const _notificationLabel = L10nText(
    ko: '알림 설정',
    en: 'Notifications',
    zh: '通知设置',
    vi: 'Thông báo',
  );
  static const _notificationOn = L10nText(
    ko: '켜짐',
    en: 'On',
    zh: '已开启',
    vi: 'Bật',
  );

  @override
  Widget build(BuildContext context) {
    final profile = UserProfileScope.of(context);
    final lang = profile.language;

    final rows = [
      (
        Icons.language_outlined,
        _languageLabel.of(lang),
        lang.nativeName,
        () => showLanguageSheet(
          context,
          current: lang,
          onSelect: profile.setLanguage,
        ),
      ),
      (Icons.badge_outlined, _visaLabel.of(lang), 'E-9 · D-42', () {}),
      (Icons.person_outline, _profileLabel.of(lang), '홍○○', () {}),
      (
        Icons.notifications_outlined,
        _notificationLabel.of(lang),
        _notificationOn.of(lang),
        () {},
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(_tabTitle.of(lang))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < rows.length; i++)
                  ListTile(
                    leading: Icon(rows[i].$1, color: AppColors.primary),
                    title: Text(
                      rows[i].$2,
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          rows[i].$3,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.chevron_right,
                          size: 18,
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                    onTap: rows[i].$4,
                    shape: i < rows.length - 1
                        ? const Border(
                            bottom: BorderSide(color: AppColors.border),
                          )
                        : null,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
