import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';
import '../models/onboarding_guide_strings.dart';

/// 앱 사용 설명서 — 원래는 최초 온보딩의 마지막 단계였지만, 로그인 없이도
/// 언제든 다시 볼 수 있도록 설정 탭의 "사용설명서" 항목으로 옮겼다.
class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  static const _moduleIcons = <IconData>[
    Icons.menu_book_rounded,
    Icons.smart_toy_rounded,
    Icons.calendar_month_rounded,
    Icons.calculate_rounded,
    Icons.alt_route_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final lang = UserProfileScope.of(context).language;

    return Scaffold(
      appBar: AppBar(title: Text(OnboardingGuideStrings.pageTitle.of(lang))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
        children: [
          const Text(
            'Local Bridge',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            OnboardingGuideStrings.tagline.of(lang),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 13),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.blueBg,
              border: Border.all(color: AppColors.blueBorder),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(
              OnboardingGuideStrings.introduction.of(lang),
              style: const TextStyle(
                fontSize: 11.5,
                color: AppColors.textSecondary,
                height: 1.65,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: List.generate(
                OnboardingGuideStrings.modules.length,
                (index) => Column(
                  children: [
                    _GuideModuleRow(
                      number: index + 1,
                      icon: _moduleIcons[index],
                      module: OnboardingGuideStrings.modules[index],
                      language: lang,
                    ),
                    if (index < OnboardingGuideStrings.modules.length - 1)
                      const Divider(height: 1, color: AppColors.border),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.green50,
              border: Border.all(color: AppColors.green200),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  OnboardingGuideStrings.creatorTitle.of(lang),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.green900,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Team EQ LAB',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.green900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  OnboardingGuideStrings.creatorNames.of(lang),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.green900,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideModuleRow extends StatelessWidget {
  const _GuideModuleRow({
    required this.number,
    required this.icon,
    required this.module,
    required this.language,
  });

  final int number;
  final IconData icon;
  final OnboardingGuideModuleText module;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: number.isEven ? AppColors.green50 : AppColors.blueBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 19,
              color: number.isEven ? AppColors.green900 : AppColors.primary,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${number.toString().padLeft(2, '0')}  ${module.title.of(language)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  module.description.of(language),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
