import 'package:flutter/material.dart';
import '../../../common/widgets/app_card.dart';
import '../../../theme/app_colors.dart';

/// Tab 4 · 설정. 언어·비자·프로필·알림 관리.
/// TODO(backend): Firebase Auth 프로필 및 users 컬렉션 값과 연동, 로그아웃 처리.
class SettingsHomeScreen extends StatelessWidget {
  const SettingsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const rows = [
      (Icons.language_outlined, '언어 설정', '한국어'),
      (Icons.badge_outlined, '비자 정보', 'E-9 · 만료 D-42'),
      (Icons.person_outline, '프로필', '홍○○'),
      (Icons.notifications_outlined, '알림 설정', '켜짐'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
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
                    title: Text(rows[i].$2, style: const TextStyle(fontSize: 14)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(rows[i].$3, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted),
                      ],
                    ),
                    onTap: () {},
                    shape: i < rows.length - 1
                        ? const Border(bottom: BorderSide(color: AppColors.border))
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
