import 'package:flutter/material.dart';
import '../../../common/widgets/app_card.dart';
import '../../../common/widgets/language_sheet.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';
import '../../worklog/screens/accident_navigator_screen.dart';
import '../../worklog/screens/wage_navigator_screen.dart';
import '../models/home_strings.dart';
import '../models/weather_info.dart';

/// Tab 1 · 홈. 날씨·MY VISA 요약과 임금체불/산재처리 내비게이터 바로가기를 모아 보여준다.
/// 앱 전역 언어 전환 버튼이 이 화면 우측 상단에 있다(과거엔 백과사전 탭에 있었다) —
/// 온보딩에서 고른 언어와 항상 같은 값을 읽고 쓴다(UserProfileScope).
/// TODO(backend): 날씨는 목업(WeatherInfo.mock), 비자 D-day는 users 컬렉션 값으로 교체 필요.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _visaDDay = 42;

  @override
  Widget build(BuildContext context) {
    final profile = UserProfileScope.of(context);
    final lang = profile.language;
    final visaStatus = profile.visaStatus;
    const weather = WeatherInfo.mock;

    return Scaffold(
      appBar: AppBar(
        title: Text(HomeStrings.tabTitle.of(lang)),
        actions: [
          TextButton.icon(
            onPressed: () => showLanguageSheet(
              context,
              current: lang,
              onSelect: profile.setLanguage,
            ),
            icon: const Icon(Icons.language, size: 16),
            label: Text(lang.code),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: _WeatherCard(weather: weather, language: lang),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _VisaCard(
                  label:
                      visaStatus?.fullLabel ?? HomeStrings.visaNotSet.of(lang),
                  dDay: _visaDDay,
                  language: lang,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            HomeStrings.quickAccessLabel.of(lang),
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _QuickActionCard(
                  gradient: const [Color(0xFFE08A1E), Color(0xFFB45309)],
                  emoji: '💸',
                  title: HomeStrings.wageCardTitle.of(lang),
                  subtitle: HomeStrings.wageCardSubtitle.of(lang),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const WageNavigatorScreen(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _QuickActionCard(
                  gradient: const [Color(0xFF12A594), Color(0xFF0B7267)],
                  emoji: '⛑️',
                  title: HomeStrings.injuryCardTitle.of(lang),
                  subtitle: HomeStrings.injuryCardSubtitle.of(lang),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AccidentNavigatorScreen(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  const _WeatherCard({required this.weather, required this.language});
  final WeatherInfo weather;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            weather.location.of(language),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(weather.emoji, style: const TextStyle(fontSize: 26)),
              const SizedBox(width: 8),
              Text(
                '${weather.tempC}°',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${weather.condition.of(language)} · ${weather.lowC}° / ${weather.highC}°',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _VisaCard extends StatelessWidget {
  const _VisaCard({
    required this.label,
    required this.dDay,
    required this.language,
  });
  final String label;
  final int dDay;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MY VISA',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.blueBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              HomeStrings.visaExpiry(language, dDay),
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.gradient,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final List<Color> gradient;
  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 19)),
            const SizedBox(height: 7),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
