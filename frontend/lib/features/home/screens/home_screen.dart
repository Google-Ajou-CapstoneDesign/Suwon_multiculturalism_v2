import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../common/widgets/language_sheet.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';
import '../../auth/screens/login_screen.dart';
import '../../worklog/controllers/work_log_controller.dart';
import '../../worklog/models/daily_work_record.dart';
import '../../worklog/screens/wage_navigator_screen.dart';
import '../models/home_strings.dart';
import '../models/weather_info.dart';

/// Tab 1 · 홈. html_files/홈화면.html의 위젯 그리드 리디자인을 옮겼다 — 위젯을
/// 사용자가 직접 추가/삭제하는 편집 모드는 만들지 않고 구성을 고정했다(기본 6개
/// 세트 + 즐겨찾기/도움처 2개 = 총 8개).
///
/// 핵심 기능: 내 비자 위젯은 게스트(비로그인)면 데모 표시, 로그인하면 실제
/// 프로필의 체류자격으로 바뀐다 — UserProfileController.isSignedIn/visaStatus를 그대로 읽는다.
///
/// TODO(backend): 날씨는 목업(WeatherInfo.mock), 비자 만료일(D-day)·이번달 근무
/// 요약·즐겨찾기·가까운 도움처는 아직 백엔드 데이터가 없어 데모 값을 보여준다.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.workLogController,
    required this.onOpenWorkLog,
    required this.onOpenAiChat,
  });

  final WorkLogController workLogController;
  final VoidCallback onOpenWorkLog;
  final VoidCallback onOpenAiChat;

  @override
  Widget build(BuildContext context) {
    final profile = UserProfileScope.of(context);
    final lang = profile.language;
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _HomeHeader(profile: profile, lang: lang, now: now),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 4, 14, 24),
                children: [
                  _WorkWidget(
                    controller: workLogController,
                    lang: lang,
                    onOpenWorkLog: onOpenWorkLog,
                  ),
                  const SizedBox(height: 9),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _VisaWidget(profile: profile, lang: lang),
                        ),
                        const SizedBox(width: 9),
                        Expanded(child: _WeatherWidget(lang: lang)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 9),
                  _CaseWidget(lang: lang),
                  const SizedBox(height: 9),
                  _AiWidget(lang: lang, onOpen: onOpenAiChat),
                  const SizedBox(height: 9),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: _MonthWidget(lang: lang, now: now)),
                        const SizedBox(width: 9),
                        Expanded(child: _FavWidget(lang: lang)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 9),
                  _OrgWidget(lang: lang),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _weekdayKo = ['월', '화', '수', '목', '금', '토', '일'];
const _weekdayEn = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _weekdayZh = ['一', '二', '三', '四', '五', '六', '日'];
const _weekdayVi = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

String _formatDate(AppLanguage lang, DateTime now) {
  final idx = now.weekday - 1;
  switch (lang) {
    case AppLanguage.ko:
      return '${now.month}월 ${now.day}일 ${_weekdayKo[idx]}요일';
    case AppLanguage.en:
      return '${_weekdayEn[idx]}, ${_monthNameEn(now.month)} ${now.day}';
    case AppLanguage.zh:
      return '${now.month}月${now.day}日 周${_weekdayZh[idx]}';
    case AppLanguage.vi:
      return '${_weekdayVi[idx]}, ${now.day}/${now.month}';
  }
}

String _monthNameEn(int month) => const [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
][month - 1];

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.profile,
    required this.lang,
    required this.now,
  });
  final UserProfileController profile;
  final AppLanguage lang;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final greeting = switch (now.hour) {
      < 12 => HomeStrings.greetingMorning,
      < 18 => HomeStrings.greetingAfternoon,
      _ => HomeStrings.greetingEvening,
    };
    final name = profile.isSignedIn
        ? (profile.displayName ?? HomeStrings.guestName.of(lang))
        : HomeStrings.guestName.of(lang);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 14, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(lang, now),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 3),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                      height: 1.25,
                      letterSpacing: -0.4,
                    ),
                    children: [
                      TextSpan(text: '${greeting.of(lang)}\n'),
                      TextSpan(
                        text: name,
                        style: const TextStyle(color: AppColors.primary),
                      ),
                      if (lang == AppLanguage.ko) const TextSpan(text: '님'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => showLanguageSheet(
              context,
              current: lang,
              onSelect: profile.setLanguage,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE4EBF5)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🌐', style: TextStyle(fontSize: 11)),
                  const SizedBox(width: 4),
                  Text(
                    lang.code,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 위젯 카드 공통 셸 — 흰 배경(또는 그라데이션) + 옅은 그림자.
class _HomeWidgetCard extends StatelessWidget {
  const _HomeWidgetCard({
    required this.child,
    this.minHeight = 86,
    this.onTap,
    this.gradient,
  });

  final Widget child;
  final double minHeight;
  final VoidCallback? onTap;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeight),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: gradient == null ? Colors.white : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(18),
        border: gradient == null
            ? Border.all(color: const Color(0xFFE4EBF5))
            : null,
        boxShadow: gradient == null
            ? [
                BoxShadow(
                  color: AppColors.navy.withValues(alpha: 0.04),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
                BoxShadow(
                  color: AppColors.navy.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: child,
    );
    if (onTap == null) return content;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: content,
    );
  }
}

class _WidgetLabel extends StatelessWidget {
  const _WidgetLabel({required this.icon, required this.text, this.color});
  final String icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 11)),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color ?? AppColors.textMuted,
              letterSpacing: -0.1,
            ),
          ),
        ),
      ],
    );
  }
}

class _DemoTag extends StatelessWidget {
  const _DemoTag({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.amberBg,
        border: Border.all(color: AppColors.amberBorder),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: AppColors.amberText,
        ),
      ),
    );
  }
}

/// 원형 진행률 링 — 근무기록·비자 위젯이 공용으로 쓴다.
class _RingIndicator extends StatelessWidget {
  const _RingIndicator({
    required this.size,
    required this.strokeWidth,
    required this.fraction,
    required this.color,
    required this.big,
    required this.small,
    this.bigFontSize = 12,
    this.smallFontSize = 7,
  });

  final double size;
  final double strokeWidth;
  final double fraction;
  final Color color;
  final String big;
  final String small;
  final double bigFontSize;
  final double smallFontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              fraction: fraction,
              color: color,
              strokeWidth: strokeWidth,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                big,
                style: TextStyle(
                  fontSize: bigFontSize,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                  height: 1,
                ),
              ),
              Text(
                small,
                style: TextStyle(
                  fontSize: smallFontSize,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.fraction,
    required this.color,
    required this.strokeWidth,
  });
  final double fraction;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width - strokeWidth) / 2;
    final bg = Paint()
      ..color = const Color(0xFFE7EDF6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final fg = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bg);
    final sweep = 2 * math.pi * fraction.clamp(0.0, 1.0);
    if (sweep > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweep,
        false,
        fg,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.fraction != fraction || oldDelegate.color != color;
}

Duration _elapsedToday(DailyWorkRecord record) {
  if (record.clockIn == null) return Duration.zero;
  if (record.clockOut != null) return record.workedDuration;
  final now = TimeOfDay.now();
  final startMinutes = record.clockIn!.hour * 60 + record.clockIn!.minute;
  final nowMinutes = now.hour * 60 + now.minute;
  final minutes = (nowMinutes - startMinutes) - record.breakMinutes;
  return Duration(minutes: minutes < 0 ? 0 : minutes);
}

String _formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes % 60;
  return '$h:${m.toString().padLeft(2, '0')}';
}

String _formatTimeOfDay(TimeOfDay t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

class _WorkWidget extends StatelessWidget {
  const _WorkWidget({
    required this.controller,
    required this.lang,
    required this.onOpenWorkLog,
  });
  final WorkLogController controller;
  final AppLanguage lang;
  final VoidCallback onOpenWorkLog;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final record = controller.todayRecord;
        final hasClockIn = record.clockIn != null;
        final hasClockOut = record.clockOut != null;
        final elapsed = _elapsedToday(record);
        final fraction = elapsed.inMinutes / (8 * 60);
        final status = !hasClockIn
            ? HomeStrings.workStatusBeforeStart
            : (hasClockOut
                  ? HomeStrings.workStatusDone
                  : HomeStrings.workStatusWorking);

        return _HomeWidgetCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _WidgetLabel(icon: '🕐', text: HomeStrings.workTitle.of(lang)),
              const SizedBox(height: 9),
              Row(
                children: [
                  _RingIndicator(
                    size: 46,
                    strokeWidth: 5,
                    fraction: fraction,
                    color: AppColors.primary,
                    big: _formatDuration(elapsed),
                    small: HomeStrings.workRingLabel.of(lang),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasClockIn
                              ? HomeStrings.workClockedInAt(
                                  lang,
                                  _formatTimeOfDay(record.clockIn!),
                                  status.of(lang),
                                )
                              : status.of(lang),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.navy,
                            letterSpacing: -0.2,
                          ),
                        ),
                        if (hasClockIn) ...[
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: AppColors.secondary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                HomeStrings.workGpsVerified.of(lang),
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: hasClockOut
                          ? null
                          : (hasClockIn
                                ? controller.clockOutToday
                                : controller.clockInToday),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFFDCE6F7),
                        disabledForegroundColor: AppColors.textMuted,
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        hasClockOut
                            ? HomeStrings.workDoneButton.of(lang)
                            : (hasClockIn
                                  ? HomeStrings.workClockOutButton.of(lang)
                                  : HomeStrings.workClockInButton.of(lang)),
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onOpenWorkLog,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        backgroundColor: AppColors.blueBg,
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        HomeStrings.workMemoButton.of(lang),
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 핵심 기능: 게스트(비로그인)면 데모 값, 로그인하면 실제 프로필 체류자격을 보여준다.
class _VisaWidget extends StatelessWidget {
  const _VisaWidget({required this.profile, required this.lang});
  final UserProfileController profile;
  final AppLanguage lang;

  static const _demoDDay = 42;
  static const _dDayScale = 90;

  @override
  Widget build(BuildContext context) {
    final signedIn = profile.isSignedIn;
    final visa = profile.visaStatus;
    final showRing = !signedIn || visa != null;
    // TODO(backend): 실제 체류 만료일이 없어 로그인 여부와 무관하게 예시 D-day를 쓴다.
    const dDay = _demoDDay;

    return _HomeWidgetCard(
      minHeight: 150,
      onTap: signedIn
          ? null
          : () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const LoginScreen())),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _WidgetLabel(
                  icon: '🪪',
                  text: HomeStrings.visaTitle.of(lang),
                ),
              ),
              if (!signedIn) _DemoTag(text: HomeStrings.visaDemoTag.of(lang)),
            ],
          ),
          SizedBox(
            height: 82,
            child: Center(
              child: showRing
                  ? Opacity(
                      opacity: signedIn ? 1 : 0.55,
                      child: _RingIndicator(
                        size: 70,
                        strokeWidth: 6,
                        fraction: dDay / _dDayScale,
                        color: AppColors.primary,
                        big: '$dDay',
                        small: HomeStrings.visaDaysLeft.of(lang),
                        bigFontSize: 19,
                        smallFontSize: 8,
                      ),
                    )
                  : const Icon(
                      Icons.badge_outlined,
                      size: 34,
                      color: AppColors.textMuted,
                    ),
            ),
          ),
          Column(
            children: [
              Text(
                signedIn
                    ? (visa?.fullLabel ?? HomeStrings.visaNotSet.of(lang))
                    : HomeStrings.visaSampleLabel.of(lang),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                signedIn
                    ? (visa != null ? HomeStrings.visaExpiry(lang, dDay) : '')
                    : HomeStrings.visaDemoHint.of(lang),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 9.5,
                  color: AppColors.textMuted,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeatherWidget extends StatelessWidget {
  const _WeatherWidget({required this.lang});
  final AppLanguage lang;

  @override
  Widget build(BuildContext context) {
    const weather = WeatherInfo.mock;
    return _HomeWidgetCard(
      minHeight: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _WidgetLabel(icon: '📍', text: weather.location.of(lang)),
          const SizedBox(height: 7),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.tempC}°',
                      style: const TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                        letterSpacing: -0.6,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${weather.condition.of(lang)} · ${HomeStrings.weatherFeelsLike(lang, weather.feelsLikeC)}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Text(weather.emoji, style: const TextStyle(fontSize: 20)),
            ],
          ),
          if (weather.heatWarning) ...[
            Container(
              margin: const EdgeInsets.only(top: 7),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.amberBg,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🥵', style: TextStyle(fontSize: 10)),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      HomeStrings.weatherHeatAlert(lang, weather.feelsLikeC),
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.amberText,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CaseWidget extends StatelessWidget {
  const _CaseWidget({required this.lang});
  final AppLanguage lang;

  static const _total = 8;
  static const _now = 3; // 0-based index of the "진행 중" segment

  @override
  Widget build(BuildContext context) {
    return _HomeWidgetCard(
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const WageNavigatorScreen())),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.amberBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  HomeStrings.caseBadge(lang, _now + 1, _total),
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.amberText,
                  ),
                ),
              ),
              const SizedBox(width: 7),
              Text(
                HomeStrings.caseTitleWage.of(lang),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                ),
              ),
              const Spacer(),
              _DemoTag(text: HomeStrings.caseDemoTag.of(lang)),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            children: List.generate(_total, (i) {
              final color = i < _now
                  ? AppColors.secondary
                  : (i == _now ? AppColors.accent : const Color(0xFFE7EDF6));
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i < _total - 1 ? 3 : 0),
                  height: 4,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 9),
          Text.rich(
            TextSpan(
              style: const TextStyle(
                fontSize: 10.5,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: HomeStrings.caseNow(
                    lang,
                    HomeStrings.caseStageInvestigation.of(lang),
                    '8.21',
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

class _AiWidget extends StatelessWidget {
  const _AiWidget({required this.lang, required this.onOpen});
  final AppLanguage lang;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return _HomeWidgetCard(
      onTap: onOpen,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1E40AF), Color(0xFF16307E)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _WidgetLabel(
            icon: '💬',
            text: HomeStrings.aiTitle.of(lang),
            color: Colors.white.withValues(alpha: 0.75),
          ),
          const SizedBox(height: 8),
          Text(
            HomeStrings.aiQuestion.of(lang),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final chip in [
                  HomeStrings.aiChipWage,
                  HomeStrings.aiChipInjury,
                  HomeStrings.aiChipVisa,
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: onOpen,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.11),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.22),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          chip.of(lang),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFFEAF0FC),
                          ),
                        ),
                      ),
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

class _MonthWidget extends StatelessWidget {
  const _MonthWidget({required this.lang, required this.now});
  final AppLanguage lang;
  final DateTime now;

  static const _bars = [0.40, 0.65, 0.55, 0.85, 0.60, 0.70, 0.95, 0.50];
  static const _hiBars = {3, 6};

  @override
  Widget build(BuildContext context) {
    return _HomeWidgetCard(
      minHeight: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _WidgetLabel(
            icon: '📊',
            text: HomeStrings.monthTitle(lang, now.month),
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: '168',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                    letterSpacing: -0.6,
                  ),
                ),
                TextSpan(
                  text: ' ${HomeStrings.monthHoursUnit.of(lang)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            HomeStrings.monthSummary(lang, 21, 12),
            style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 26,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_bars.length, (i) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: i < _bars.length - 1 ? 2.5 : 0,
                    ),
                    child: FractionallySizedBox(
                      heightFactor: _bars[i],
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _hiBars.contains(i)
                              ? AppColors.primary
                              : const Color(0xFFDCE6F7),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _FavWidget extends StatelessWidget {
  const _FavWidget({required this.lang});
  final AppLanguage lang;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('📋', HomeStrings.favContract.of(lang)),
      ('🪪', HomeStrings.favArc.of(lang)),
      ('🛟', HomeStrings.favRights.of(lang)),
    ];
    return _HomeWidgetCard(
      minHeight: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _WidgetLabel(icon: '⭐', text: HomeStrings.favTitle.of(lang)),
          const SizedBox(height: 8),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.blueBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(item.$1, style: const TextStyle(fontSize: 12)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.$2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
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

class _OrgWidget extends StatelessWidget {
  const _OrgWidget({required this.lang});
  final AppLanguage lang;

  static const _phone = '031-000-0000';

  @override
  Widget build(BuildContext context) {
    return _HomeWidgetCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _WidgetLabel(icon: '🏢', text: HomeStrings.orgTitle.of(lang)),
          const SizedBox(height: 9),
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F6F4),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Text('🏢', style: TextStyle(fontSize: 14)),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      HomeStrings.orgName.of(lang),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      HomeStrings.orgDesc.of(lang),
                      style: const TextStyle(
                        fontSize: 9.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(HomeStrings.orgCallToast(lang, _phone)),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: Text(
                  HomeStrings.orgCallButton.of(lang),
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
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
