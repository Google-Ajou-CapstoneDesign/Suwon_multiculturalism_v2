import 'package:flutter/material.dart';
import '../../../common/widgets/language_sheet.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';
import '../../auth/screens/login_screen.dart';
import '../../wage_calculator/models/wage_diagnosis.dart' show formatWon;
import '../../worklog/controllers/work_log_controller.dart';
import '../../worklog/models/daily_work_record.dart';
import '../../worklog/screens/accident_navigator_screen.dart';
import '../../worklog/screens/wage_navigator_screen.dart';
import '../../worklog/services/location_verify_service.dart';
import '../models/home_strings.dart';
import '../models/weather_info.dart';
import '../services/weather_api_service.dart';

/// Tab 1 · 홈. design_files/App_Design.html의 homeHTML() 레이아웃·구성을
/// 그대로 옮겼다 — 인사말(비자 태그만, D-day 없음) → 오늘의 근무/이번 달 근무
/// 2장 → 빠른 접근 4개 → 도움 가이드 2개 → 증빙 보관함 카드 → 하단 안내문
/// 순서. 시안엔 없지만 안전 관련 기능인 폭염 경고만 "이번 달 근무" 카드에
/// 조건부로 남겨뒀다.
///
/// TODO(backend): 날씨는 목업(WeatherInfo.mock), 이번달 근무 요약은 로컬
/// 캘린더 데이터 기준이라 아직 백엔드 집계가 아니다.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.workLogController,
    required this.onOpenWorkLog,
    required this.onOpenWageCalculator,
    required this.onOpenNavigator,
  });

  final WorkLogController workLogController;
  final VoidCallback onOpenWorkLog;
  final VoidCallback onOpenWageCalculator;
  final VoidCallback onOpenNavigator;

  @override
  Widget build(BuildContext context) {
    final profile = UserProfileScope.of(context);
    final lang = profile.language;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
          children: [
            _GreetingSection(profile: profile, lang: lang),
            const SizedBox(height: 16),
            _TodayWorkCard(
              controller: workLogController,
              lang: lang,
              onOpenWorkLog: onOpenWorkLog,
            ),
            const SizedBox(height: 10),
            _MonthlyWorkCard(
              controller: workLogController,
              lang: lang,
              onOpenWorkLog: onOpenWorkLog,
            ),
            const SizedBox(height: 22),
            _SectionTitle(text: HomeStrings.quickAccessTitle.of(lang)),
            const SizedBox(height: 10),
            _QuickAccessGrid(
              lang: lang,
              onOpenWorkLog: onOpenWorkLog,
              onOpenWageCalculator: onOpenWageCalculator,
              onOpenNavigator: onOpenNavigator,
            ),
            const SizedBox(height: 22),
            _SectionTitle(text: HomeStrings.helpGuidesTitle.of(lang)),
            const SizedBox(height: 10),
            _HelpGuidesSection(lang: lang),
            const SizedBox(height: 10),
            _VaultStatusCard(
              profile: profile,
              lang: lang,
              onOpenWorkLog: onOpenWorkLog,
            ),
            const SizedBox(height: 18),
            Text(
              HomeStrings.bottomNote.of(lang),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
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

String _formatHours(Duration d) {
  final totalMinutes = d.inMinutes;
  final h = totalMinutes ~/ 60;
  final m = totalMinutes % 60;
  return m == 0 ? '$h' : '$h.${(m * 10 / 60).round()}';
}

String _formatTimeOfDay(TimeOfDay? t) => t == null
    ? '--:--'
    : '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

/// 인사말 — eyebrow + h1(그리팅+이름) + subtitle + 비자 태그 + 언어 버튼.
class _GreetingSection extends StatelessWidget {
  const _GreetingSection({required this.profile, required this.lang});
  final UserProfileController profile;
  final AppLanguage lang;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final greeting = switch (now.hour) {
      < 12 => HomeStrings.greetingMorning,
      < 18 => HomeStrings.greetingAfternoon,
      _ => HomeStrings.greetingEvening,
    };
    final name =
        profile.displayNameOrEmailPrefix ?? HomeStrings.guestName.of(lang);
    final signedIn = profile.isSignedIn;
    final visaLabel = signedIn
        ? (profile.visaStatus?.fullLabel ?? HomeStrings.visaNotSet.of(lang))
        : HomeStrings.visaSampleLabel.of(lang);

    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  HomeStrings.greetingEyebrow.of(lang),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                      height: 1.3,
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
                const SizedBox(height: 6),
                Text(
                  HomeStrings.greetingSubtitle.of(lang),
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textMuted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: signedIn
                    ? null
                    : () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.pale,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    visaLabel,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => showLanguageSheet(
                  context,
                  current: lang,
                  onSelect: profile.setLanguage,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🌐', style: TextStyle(fontSize: 10)),
                      const SizedBox(width: 4),
                      Text(
                        lang.code,
                        style: const TextStyle(
                          fontSize: 10,
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
        ],
      ),
    );
  }
}

/// 공용 흰 카드 셸(빠른 접근/도움 가이드/증빙 보관함이 재사용). "오늘의 근무"만
/// 별도로 파란 그라데이션을 쓴다.
class _HomeCard extends StatelessWidget {
  const _HomeCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
    this.gradient,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppColors.cardRadius);
    final content = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? Colors.white : null,
        gradient: gradient,
        borderRadius: radius,
        border: gradient == null ? Border.all(color: AppColors.border) : null,
        boxShadow: AppColors.cardShadow,
      ),
      child: child,
    );
    if (onTap == null) return content;
    return InkWell(borderRadius: radius, onTap: onTap, child: content);
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: AppColors.navy,
      ),
    );
  }
}

/// 오늘의 근무 — 파란 그라데이션 hero 카드. 큰 실근무시간 숫자 + 출근/퇴근/휴게
/// 3항목 행 + 출퇴근·근무기록장 버튼 2개 + 위치 인증 행.
class _TodayWorkCard extends StatelessWidget {
  const _TodayWorkCard({
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
        final status = !hasClockIn
            ? HomeStrings.workStatusBeforeStart
            : (hasClockOut
                  ? HomeStrings.workStatusDone
                  : HomeStrings.workStatusWorking);

        return _HomeCard(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1769EF), Color(0xFF2860DF)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      HomeStrings.workTitle.of(lang),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status.of(lang),
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              // work-numbers — 오늘 실근무시간 큰 숫자.
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      _formatHours(elapsed),
                      style: const TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -1,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      HomeStrings.workHoursUnit.of(lang),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFC9DEFF),
                      ),
                    ),
                  ],
                ),
              ),
              // clock-row — 출근/퇴근/휴게 3항목.
              Row(
                children: [
                  _ClockItem(
                    label: HomeStrings.workClockLabel.of(lang),
                    value: _formatTimeOfDay(record.clockIn),
                  ),
                  _ClockItem(
                    label: HomeStrings.workClockOutLabel.of(lang),
                    value: _formatTimeOfDay(record.clockOut),
                  ),
                  _ClockItem(
                    label: HomeStrings.workBreakLabel.of(lang),
                    value: '${record.breakMinutes}m',
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        disabledBackgroundColor: Colors.white.withValues(
                          alpha: 0.35,
                        ),
                        disabledForegroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        hasClockOut
                            ? HomeStrings.workDoneButton.of(lang)
                            : (hasClockIn
                                  ? HomeStrings.workClockOutButton.of(lang)
                                  : HomeStrings.workClockInButton.of(lang)),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onOpenWorkLog,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.transparent,
                        side: const BorderSide(color: Colors.white54),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        HomeStrings.workMemoButton.of(lang),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (hasClockIn) ...[
                const SizedBox(height: 12),
                _HomeLocationVerification(
                  verified: record.gpsVerified,
                  address: record.verifiedAddress,
                  language: lang,
                  onVerified: (lat, lng, address) =>
                      controller.markTodayLocationVerified(
                        latitude: lat,
                        longitude: lng,
                        address: address,
                      ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ClockItem extends StatelessWidget {
  const _ClockItem({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10.5, color: Color(0xFFC9DEFF)),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// 위치 인증 행 — 인증 완료면 초록 점+주소, 아니면 인증 버튼(로딩 상태 포함).
/// 파란 배경 카드 위에 올라가므로 흰색 계열 텍스트/보더를 쓴다.
class _HomeLocationVerification extends StatefulWidget {
  const _HomeLocationVerification({
    required this.verified,
    this.address,
    required this.language,
    required this.onVerified,
  });

  final bool verified;

  /// 서버가 역지오코딩으로 돌려준 주소 — verified == true일 때만 값이 있을
  /// 수 있다(지오코딩 실패 시엔 인증은 됐어도 null).
  final String? address;
  final AppLanguage language;
  final void Function(double latitude, double longitude, String? address)
  onVerified;

  @override
  State<_HomeLocationVerification> createState() =>
      _HomeLocationVerificationState();
}

class _HomeLocationVerificationState extends State<_HomeLocationVerification> {
  bool _verifying = false;

  Future<void> _verify() async {
    setState(() => _verifying = true);
    try {
      final outcome = await LocationVerifyService().verifyCurrentLocation(
        language: widget.language,
      );
      if (!mounted) return;
      switch (outcome.status) {
        case LocationVerifyStatus.verified:
          widget.onVerified(
            outcome.result!.latitude,
            outcome.result!.longitude,
            outcome.result!.address,
          );
          break;
        case LocationVerifyStatus.serviceDisabled:
          _showMessage(HomeStrings.workGpsServiceDisabled.of(widget.language));
          break;
        case LocationVerifyStatus.permissionDenied:
          _showMessage(HomeStrings.workGpsPermissionDenied.of(widget.language));
          break;
        case LocationVerifyStatus.rejected:
          _showMessage(HomeStrings.workGpsVerifyFailed.of(widget.language));
          break;
        case LocationVerifyStatus.error:
          _showMessage(HomeStrings.workGpsVerifyError.of(widget.language));
          break;
      }
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.verified) {
      // 좌표 숫자 대신 서버가 역지오코딩으로 돌려준 주소 문자열을 보여준다 —
      // 지오코딩 실패 시(address == null)엔 인증 완료 문구만 남긴다.
      return Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFF7FE0B0),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: HomeStrings.workGpsVerified.of(widget.language),
                style: const TextStyle(fontSize: 11.5, color: Colors.white),
                children: widget.address == null
                    ? null
                    : [
                        TextSpan(
                          text: ' (${widget.address})',
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFFC9DEFF),
                          ),
                        ),
                      ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: _verifying ? null : _verify,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            border: Border.all(color: Colors.white54),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_verifying) ...[
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
              ] else ...[
                const Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
              ],
              Flexible(
                child: Text(
                  HomeStrings.workGpsVerifyButton.of(widget.language),
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 이번 달 근무 — 근무일·시간·임금 + 이번 주 미니 달력 + 날씨.
class _MonthlyWorkCard extends StatefulWidget {
  const _MonthlyWorkCard({
    required this.controller,
    required this.lang,
    required this.onOpenWorkLog,
  });
  final WorkLogController controller;
  final AppLanguage lang;
  final VoidCallback onOpenWorkLog;

  @override
  State<_MonthlyWorkCard> createState() => _MonthlyWorkCardState();
}

class _MonthlyWorkCardState extends State<_MonthlyWorkCard> {
  final _api = WeatherApiService();

  // 실제 응답이 올 때까지(또는 조회 실패 시 계속) 목업을 보여준다.
  WeatherInfo _weather = WeatherInfo.mock;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final fetched = await _api.fetchSuwonWeather();
      if (mounted) setState(() => _weather = fetched);
    } catch (_) {
      // 실패해도 목업이 이미 표시 중이므로 조용히 넘어간다.
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.lang;
    final controller = widget.controller;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final today = controller.today;
        final weekStart = today.subtract(Duration(days: today.weekday - 1));
        final weekDays = List.generate(
          7,
          (i) => weekStart.add(Duration(days: i)),
        );

        return _HomeCard(
          onTap: widget.onOpenWorkLog,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      HomeStrings.monthlyTitle.of(lang),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _MonthlyStat(
                      value: '${controller.currentMonthWorkedDays}',
                      label: HomeStrings.monthlyDaysLabel.of(lang),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MonthlyStat(
                      value: _formatHours(
                        controller.currentMonthWorkedDuration,
                      ),
                      label: HomeStrings.monthlyHoursLabel.of(lang),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: _MonthlyStat(
                      value: controller.loading
                          ? '…'
                          : formatWon(controller.currentMonthWage, lang),
                      label: HomeStrings.monthlyWageLabel.of(lang),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: weekDays.map((day) {
                  final isToday = DateUtils.isSameDay(day, today);
                  final has = controller.hasRecord(day);
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isToday
                              ? AppColors.primary
                              : (has ? AppColors.pale : Colors.transparent),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isToday
                                ? Colors.white
                                : (has
                                      ? AppColors.primary
                                      : AppColors.textMuted),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${_weather.location.of(lang)} · ${_weather.tempC}°',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    HomeStrings.monthlyViewAll.of(lang),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              if (_weather.heatWarning) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.noticeBg,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🥵', style: TextStyle(fontSize: 10)),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          HomeStrings.weatherHeatAlert(
                            lang,
                            _weather.feelsLikeC,
                          ),
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.noticeText,
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
      },
    );
  }
}

class _MonthlyStat extends StatelessWidget {
  const _MonthlyStat({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.navy,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted),
        ),
      ],
    );
  }
}

/// 빠른 접근 — 4열 아이콘 그리드.
class _QuickAccessGrid extends StatelessWidget {
  const _QuickAccessGrid({
    required this.lang,
    required this.onOpenWorkLog,
    required this.onOpenWageCalculator,
    required this.onOpenNavigator,
  });
  final AppLanguage lang;
  final VoidCallback onOpenWorkLog;
  final VoidCallback onOpenWageCalculator;
  final VoidCallback onOpenNavigator;

  @override
  Widget build(BuildContext context) {
    return _HomeCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Row(
        children: [
          _QuickAccessItem(
            icon: Icons.calendar_month_outlined,
            iconBg: AppColors.pale,
            iconFg: AppColors.primary,
            label: HomeStrings.quickWorklog.of(lang),
            onTap: onOpenWorkLog,
          ),
          _QuickAccessItem(
            icon: Icons.calculate_outlined,
            iconBg: AppColors.greenBg,
            iconFg: AppColors.greenFg,
            label: HomeStrings.quickWageCalc.of(lang),
            onTap: onOpenWageCalculator,
          ),
          _QuickAccessItem(
            icon: Icons.explore_outlined,
            iconBg: AppColors.orangeBg,
            iconFg: AppColors.orangeFg,
            label: HomeStrings.quickNavigator.of(lang),
            onTap: onOpenNavigator,
          ),
          _QuickAccessItem(
            icon: Icons.folder_shared_outlined,
            iconBg: AppColors.purpleBg,
            iconFg: AppColors.purpleFg,
            label: HomeStrings.quickVault.of(lang),
            onTap: onOpenWorkLog,
          ),
        ],
      ),
    );
  }
}

class _QuickAccessItem extends StatelessWidget {
  const _QuickAccessItem({
    required this.icon,
    required this.iconBg,
    required this.iconFg,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final Color iconBg;
  final Color iconFg;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, size: 22, color: iconFg),
              ),
              const SizedBox(height: 7),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 도움 가이드 — 임금체불/산재처리 네비게이터로 이동하는 리스트형 카드 2개.
class _HelpGuidesSection extends StatelessWidget {
  const _HelpGuidesSection({required this.lang});
  final AppLanguage lang;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _GuideCard(
          emoji: '💸',
          iconBg: AppColors.pale,
          title: HomeStrings.wageNavTitle.of(lang),
          description: HomeStrings.wageNavDesc.of(lang),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const WageNavigatorScreen()),
          ),
        ),
        const SizedBox(height: 9),
        _GuideCard(
          emoji: '⛑️',
          iconBg: AppColors.greenBg,
          title: HomeStrings.injuryNavTitle.of(lang),
          description: HomeStrings.injuryNavDesc.of(lang),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AccidentNavigatorScreen()),
          ),
        ),
      ],
    );
  }
}

class _GuideCard extends StatelessWidget {
  const _GuideCard({
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
    return _HomeCard(
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

/// 사업주 공식 증빙 보관함 — 근로계약서/임금명세서 등록 여부만 보여주고,
/// 실제 등록/토글은 근무기록장 시트 안 보관함 섹션에서 한다.
class _VaultStatusCard extends StatelessWidget {
  const _VaultStatusCard({
    required this.profile,
    required this.lang,
    required this.onOpenWorkLog,
  });
  final UserProfileController profile;
  final AppLanguage lang;
  final VoidCallback onOpenWorkLog;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: profile,
      builder: (context, _) {
        return _HomeCard(
          onTap: onOpenWorkLog,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                HomeStrings.vaultCardTitle.of(lang),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _VaultItem(
                      icon: Icons.description_outlined,
                      label: HomeStrings.vaultContract.of(lang),
                      registered: profile.contractStored,
                      lang: lang,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _VaultItem(
                      icon: Icons.receipt_long_outlined,
                      label: HomeStrings.vaultPayslip.of(lang),
                      registered: profile.payslipStored,
                      lang: lang,
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

class _VaultItem extends StatelessWidget {
  const _VaultItem({
    required this.icon,
    required this.label,
    required this.registered,
    required this.lang,
  });
  final IconData icon;
  final String label;
  final bool registered;
  final AppLanguage lang;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  registered
                      ? HomeStrings.vaultRegistered.of(lang)
                      : HomeStrings.vaultNotRegistered.of(lang),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: registered ? AppColors.greenFg : AppColors.textMuted,
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
