import 'package:flutter/material.dart';
import '../../../common/widgets/app_card.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';
import '../models/navigator_home_strings.dart';
import 'accident_navigator_screen.dart';
import 'wage_navigator_screen.dart';

/// Tab 1 · 네비게이터. 원래 이 자리는 백과사전 탭이었으나, 임금체불/산재
/// 두 내비게이터로 바로 들어갈 수 있는 선택 화면으로 교체했다(백과사전
/// 자체는 features/encyclopedia에 그대로 남아 있다 — encyclopedia_home_screen.dart
/// 상단 코멘트 참고). 카드를 탭하면 홈 화면 도움 가이드와 동일하게 각
/// 내비게이터 화면을 push한다.
class NavigatorHomeScreen extends StatelessWidget {
  const NavigatorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = UserProfileScope.of(context).language;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
          children: [
            Text(
              NavigatorHomeStrings.eyebrow.of(lang),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              NavigatorHomeStrings.title.of(lang),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 20),
            _NavigatorOptionCard(
              emoji: '💸',
              iconBg: AppColors.pale,
              title: NavigatorHomeStrings.wageTitle.of(lang),
              description: NavigatorHomeStrings.wageDesc.of(lang),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const WageNavigatorScreen()),
              ),
            ),
            const SizedBox(height: 12),
            _NavigatorOptionCard(
              emoji: '⛑️',
              iconBg: AppColors.greenBg,
              title: NavigatorHomeStrings.injuryTitle.of(lang),
              description: NavigatorHomeStrings.injuryDesc.of(lang),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AccidentNavigatorScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 임금체불/산재 중 하나를 고르는 카드 — home_screen.dart의 도움 가이드
/// 카드(_GuideCard)와 같은 톤이다.
class _NavigatorOptionCard extends StatelessWidget {
  const _NavigatorOptionCard({
    required this.emoji,
    required this.iconBg,
    required this.title,
    required this.description,
    required this.onTap,
  });
  final String emoji;
  final Color iconBg;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 19)),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
