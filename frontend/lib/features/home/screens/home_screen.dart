import 'package:flutter/material.dart';
import '../../../common/widgets/app_card.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';
import '../../worklog/screens/accident_navigator_screen.dart';
import '../../worklog/screens/wage_navigator_screen.dart';
import '../models/weather_info.dart';

/// Tab 1 · 홈. 날씨·MY VISA 요약과 임금체불/산재처리 내비게이터 바로가기를 모아 보여준다.
/// TODO(backend): 날씨는 목업(WeatherInfo.mock), 비자 D-day는 users 컬렉션 값으로 교체 필요.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _visaDDay = 42;

  @override
  Widget build(BuildContext context) {
    final visaStatus = UserProfileScope.of(context).visaStatus;
    const weather = WeatherInfo.mock;

    return Scaffold(
      appBar: AppBar(title: const Text('홈')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(child: _WeatherCard(weather: weather)),
              const SizedBox(width: 12),
              Expanded(
                child: _VisaCard(
                  label: visaStatus?.fullLabel ?? '체류자격 미설정',
                  dDay: _visaDDay,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const Text(
            '바로가기',
            style: TextStyle(
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
                  title: '임금체불 진정 내비게이터',
                  subtitle: '단계별로 진정서까지 안내',
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
                  title: '산재처리 신청 내비게이터',
                  subtitle: '단계별로 요양급여 신청까지',
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
  const _WeatherCard({required this.weather});
  final WeatherInfo weather;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            weather.location,
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
            '${weather.condition} · ${weather.lowC}° / ${weather.highC}°',
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
  const _VisaCard({required this.label, required this.dDay});
  final String label;
  final int dDay;

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
              '만료 D-$dDay',
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
