import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';
import '../../wage_calculator/models/wage_diagnosis.dart' show formatWon;
import '../controllers/work_log_controller.dart';
import '../models/daily_work_record.dart';
import '../screens/accident_navigator_screen.dart';
import '../screens/wage_navigator_screen.dart';
import '../services/location_verify_service.dart';
import 'vault_box.dart';

/// 근무기록장 UI 문구.
class _WorkLogStrings {
  _WorkLogStrings._();

  static const title = L10nText(
    ko: '근무기록장',
    en: 'Work Log',
    zh: '工作记录本',
    vi: 'Nhật ký làm việc',
  );
  static const subtitle = L10nText(
    ko: '매일의 기록이 가장 확실한 증거가 됩니다',
    en: 'Daily records are your strongest evidence',
    zh: '每天的记录就是最确凿的证据',
    vi: 'Ghi chép hằng ngày là bằng chứng chắc chắn nhất',
  );
  static const close = L10nText(ko: '닫기', en: 'Close', zh: '关闭', vi: 'Đóng');
  static const legendLogged = L10nText(
    ko: '기록 완료',
    en: 'Recorded',
    zh: '已记录',
    vi: 'Đã ghi nhận',
  );
  static const legendOvertime = L10nText(
    ko: '연장·야간',
    en: 'Overtime/night',
    zh: '加班·夜班',
    vi: 'Tăng ca/làm đêm',
  );
  static const legendRisk = L10nText(
    ko: '급여 미지급 의심',
    en: 'Possible unpaid wages',
    zh: '疑似欠薪',
    vi: 'Nghi ngờ chưa trả lương',
  );

  static const breakTimeTitle = L10nText(
    ko: '휴게시간',
    en: 'Break time',
    zh: '休息时间',
    vi: 'Thời gian nghỉ',
  );
  static const cancel = L10nText(ko: '취소', en: 'Cancel', zh: '取消', vi: 'Hủy');
  static const confirm = L10nText(
    ko: '확인',
    en: 'Confirm',
    zh: '确认',
    vi: 'Xác nhận',
  );

  static const gpsVerified = L10nText(
    ko: '📍 위치 인증 완료',
    en: '📍 Location verified',
    zh: '📍 位置认证完成',
    vi: '📍 Đã xác minh vị trí',
  );
  static const gpsUnverified = L10nText(
    ko: '📍 사업장 외부 기록',
    en: '📍 Recorded outside workplace',
    zh: '📍 工作场所外记录',
    vi: '📍 Ghi nhận ngoài nơi làm việc',
  );
  static const gpsVerifyButton = L10nText(
    ko: '📍 위치 인증하기',
    en: '📍 Verify location',
    zh: '📍 认证位置',
    vi: '📍 Xác minh vị trí',
  );
  static const gpsServiceDisabled = L10nText(
    ko: '기기의 위치 서비스가 꺼져 있어요. 설정에서 켜주세요.',
    en: 'Your device\'s location service is off. Please turn it on in settings.',
    zh: '设备的位置服务已关闭，请在设置中打开。',
    vi: 'Dịch vụ vị trí của thiết bị đang tắt. Vui lòng bật trong cài đặt.',
  );
  static const gpsPermissionDenied = L10nText(
    ko: '위치 권한이 필요해요. 브라우저나 기기 설정에서 위치 접근을 허용해주세요.',
    en: 'Location permission is needed. Please allow location access in your browser or device settings.',
    zh: '需要位置权限，请在浏览器或设备设置中允许访问位置信息。',
    vi: 'Cần quyền truy cập vị trí. Vui lòng cho phép truy cập vị trí trong cài đặt trình duyệt hoặc thiết bị.',
  );
  static const gpsVerifyFailed = L10nText(
    ko: '위치 정보를 받았지만 인증에 실패했어요. 다시 시도해주세요.',
    en: 'We received your location but verification failed. Please try again.',
    zh: '已收到位置信息，但认证失败，请重试。',
    vi: 'Đã nhận vị trí nhưng xác minh thất bại. Vui lòng thử lại.',
  );
  static const gpsVerifyError = L10nText(
    ko: '위치 인증 중 오류가 발생했어요. 잠시 후 다시 시도해주세요.',
    en: 'Something went wrong while verifying your location. Please try again shortly.',
    zh: '认证位置时发生错误，请稍后重试。',
    vi: 'Đã xảy ra lỗi khi xác minh vị trí. Vui lòng thử lại sau.',
  );

  static const clockIn = L10nText(
    ko: '출근',
    en: 'Clock in',
    zh: '上班',
    vi: 'Vào ca',
  );
  static const clockOut = L10nText(
    ko: '퇴근',
    en: 'Clock out',
    zh: '下班',
    vi: 'Tan ca',
  );
  static const breakLabel = L10nText(
    ko: '휴게',
    en: 'Break',
    zh: '休息',
    vi: 'Nghỉ',
  );

  static const actualWorkedTime = L10nText(
    ko: '실근무시간',
    en: 'Actual hours worked',
    zh: '实际工作时长',
    vi: 'Thời gian làm việc thực tế',
  );
  static const estimatedWage = L10nText(
    ko: '예상 임금(세전)',
    en: 'Estimated wage (pre-tax)',
    zh: '预计工资（税前）',
    vi: 'Lương dự kiến (trước thuế)',
  );

  static const monthTotalWage = L10nText(
    ko: '이번 달 총 임금',
    en: "This month's total wage",
    zh: '本月总工资',
    vi: 'Tổng lương tháng này',
  );
  static const monthTotalWageHint = L10nText(
    ko: '탭하여 시급 수정',
    en: 'Tap to edit hourly wage',
    zh: '点击修改时薪',
    vi: 'Chạm để sửa lương theo giờ',
  );
  static const hourlyWageDialogTitle = L10nText(
    ko: '적용 시급',
    en: 'Hourly wage',
    zh: '适用时薪',
    vi: 'Lương theo giờ',
  );
  static const hourlyWageDialogSubtitle = L10nText(
    ko: '실근무시간 × 시급으로 대략적인 임금을 계산해요. 정확한 계산은 임금계산기 탭을 이용하세요.',
    en: 'We estimate wages as hours worked × hourly wage. For an exact calculation, use the Wage Calculator tab.',
    zh: '按"实际工作时长 × 时薪"估算工资。精确计算请使用工资计算器标签页。',
    vi: 'Lương được ước tính bằng giờ làm thực tế × lương theo giờ. Để tính chính xác, hãy dùng tab Máy tính lương.',
  );

  static const photoAttach = L10nText(
    ko: '📷 타임스탬프 사진',
    en: '📷 Timestamped photo',
    zh: '📷 时间戳照片',
    vi: '📷 Ảnh có dấu thời gian',
  );
  static const transitCardAttach = L10nText(
    ko: '🚌 교통카드 기록',
    en: '🚌 Transit card record',
    zh: '🚌 交通卡记录',
    vi: '🚌 Lịch sử thẻ giao thông',
  );
  static const audioRecord = L10nText(
    ko: '🎙️ 녹음하기',
    en: '🎙️ Record audio',
    zh: '🎙️ 录音',
    vi: '🎙️ Ghi âm',
  );

  static const memoHint = L10nText(
    ko: '오늘 있었던 일을 적어두세요 (예: 사장님이 30분 더 일하라고 함)',
    en: 'Write down what happened today (e.g. "Boss asked me to work 30 minutes extra")',
    zh: '记下今天发生的事（例如：老板让我多干30分钟）',
    vi: 'Ghi lại những gì đã xảy ra hôm nay (VD: chủ bảo làm thêm 30 phút)',
  );

  static const nextStepsLabel = L10nText(
    ko: '기록이 쌓였다면',
    en: 'Once you have records',
    zh: '记录积累之后',
    vi: 'Khi đã có đủ ghi chép',
  );

  static const wageEntryTitle = L10nText(
    ko: '임금체불 진정 내비게이터',
    en: 'Unpaid Wage Navigator',
    zh: '拖欠工资申诉导航',
    vi: 'Hướng dẫn khiếu nại nợ lương',
  );
  static const wageEntrySubtitle = L10nText(
    ko: '단계별로 진정서까지 안내',
    en: 'Step by step, all the way to the report',
    zh: '逐步引导直到提交申诉书',
    vi: 'Hướng dẫn từng bước đến khi nộp đơn',
  );
  static const injuryEntryTitle = L10nText(
    ko: '산재처리 신청 내비게이터',
    en: 'Workplace Injury Navigator',
    zh: '工伤申报导航',
    vi: 'Hướng dẫn yêu cầu bồi thường tai nạn lao động',
  );
  static const injuryEntrySubtitle = L10nText(
    ko: '단계별로 요양급여 신청까지',
    en: 'Step by step, all the way to the benefit claim',
    zh: '逐步引导直到申请疗养补偿',
    vi: 'Hướng dẫn từng bước đến khi yêu cầu trợ cấp',
  );

  static const _monthNamesEn = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// 연·월 표기 — intl 없이 언어별로 손으로 조합한다.
  static String monthLabel(AppLanguage lang, DateTime month) {
    switch (lang) {
      case AppLanguage.ko:
        return '${month.year}년 ${month.month}월';
      case AppLanguage.en:
        return '${_monthNamesEn[month.month - 1]} ${month.year}';
      case AppLanguage.zh:
        return '${month.year}年${month.month}月';
      case AppLanguage.vi:
        return 'Tháng ${month.month}, ${month.year}';
    }
  }

  static const _weekdayLabelsKo = ['일', '월', '화', '수', '목', '금', '토'];
  static const _weekdayLabelsEn = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];
  static const _weekdayLabelsZh = ['日', '一', '二', '三', '四', '五', '六'];
  static const _weekdayLabelsVi = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];

  static List<String> weekdayLabels(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.ko:
        return _weekdayLabelsKo;
      case AppLanguage.en:
        return _weekdayLabelsEn;
      case AppLanguage.zh:
        return _weekdayLabelsZh;
      case AppLanguage.vi:
        return _weekdayLabelsVi;
    }
  }
}

/// 하단 가운데 "오늘" 버튼으로 여닫는 근무기록장 시트.
/// 화면 전체를 덮지 않고 하단 탭바는 남겨둔다 — 달력 버튼을 다시 눌러 닫을 수 있게 하기 위함.
class WorkLogSheet extends StatefulWidget {
  const WorkLogSheet({
    super.key,
    required this.isOpen,
    required this.onClose,
    required this.controller,
  });

  final bool isOpen;
  final VoidCallback onClose;

  /// MainShell이 소유한 단일 인스턴스 — 홈 화면의 "오늘의 근무" 위젯과 상태를
  /// 공유한다(홈에서 출근 기록하면 여기서도 바로 보여야 한다).
  final WorkLogController controller;

  @override
  State<WorkLogSheet> createState() => _WorkLogSheetState();
}

class _WorkLogSheetState extends State<WorkLogSheet> {
  WorkLogController get _controller => widget.controller;

  void _openDayRecord(DateTime day, AppLanguage language) {
    _controller.selectDay(day);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Material(
              color: AppColors.background,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              clipBehavior: Clip.antiAlias,
              child: ListenableBuilder(
                listenable: _controller,
                builder: (context, _) {
                  return Column(
                    children: [
                      const _Grabber(),
                      Expanded(
                        child: _DailyHookBody(
                          controller: _controller,
                          scrollController: scrollController,
                          language: language,
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = UserProfileScope.of(context).language;
    return IgnorePointer(
      ignoring: !widget.isOpen,
      child: AnimatedSlide(
        offset: widget.isOpen ? Offset.zero : const Offset(0, 1),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        child: Material(
          color: AppColors.background,
          child: SafeArea(
            top: false,
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, _) {
                return Column(
                  children: [
                    const _Grabber(),
                    _Header(onClose: widget.onClose, language: lang),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _CalendarBlock(
                              controller: _controller,
                              onDayTap: (day) => _openDayRecord(day, lang),
                              language: lang,
                            ),
                            _MonthlyWageCard(
                              controller: _controller,
                              language: lang,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// 출퇴근 버튼이 있던 자리 — 대신 이번 달 총 예상 임금을 보여준다.
/// html_files/frontend_근무기록장_총임금추가.html의 "9월 총합계" 배너와
/// 같은 자리·역할이다. 탭하면 계산에 쓸 시급을 바꿀 수 있다.
class _MonthlyWageCard extends StatelessWidget {
  const _MonthlyWageCard({required this.controller, required this.language});

  final WorkLogController controller;
  final AppLanguage language;

  Future<void> _editHourlyWage(BuildContext context) async {
    final textController = TextEditingController(
      text: controller.hourlyWage.round().toString(),
    );
    final result = await showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            _WorkLogStrings.hourlyWageDialogTitle.of(language),
            style: const TextStyle(fontSize: 15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _WorkLogStrings.hourlyWageDialogSubtitle.of(language),
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.textMuted,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textController,
                keyboardType: TextInputType.number,
                autofocus: true,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
                decoration: InputDecoration(
                  suffixText: language == AppLanguage.ko ? '원' : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(_WorkLogStrings.cancel.of(language)),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(double.tryParse(textController.text)),
              child: Text(_WorkLogStrings.confirm.of(language)),
            ),
          ],
        );
      },
    );
    if (result != null && result > 0) controller.setHourlyWage(result);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 16, 15, 24),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _editHourlyWage(context),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2196F3), Color(0xFF0D47A1)],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _WorkLogStrings.monthTotalWage.of(language),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatWon(controller.monthTotalWage, language),
                    style: const TextStyle(
                      fontSize: 21,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _WorkLogStrings.monthTotalWageHint.of(language),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 8.5,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Grabber extends StatelessWidget {
  const _Grabber();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 4,
      margin: const EdgeInsets.only(top: 8, bottom: 2),
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onClose, required this.language});
  final VoidCallback onClose;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 12, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _WorkLogStrings.title.of(language),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _WorkLogStrings.subtitle.of(language),
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onClose,
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFF1F5F9),
              foregroundColor: AppColors.textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              _WorkLogStrings.close.of(language),
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarBlock extends StatelessWidget {
  const _CalendarBlock({
    required this.controller,
    required this.onDayTap,
    required this.language,
  });
  final WorkLogController controller;
  final ValueChanged<DateTime> onDayTap;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final month = controller.focusedMonth;
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final leadingBlanks = DateTime(month.year, month.month, 1).weekday % 7;
    final weekdayLabels = _WorkLogStrings.weekdayLabels(language);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: controller.goToPreviousMonth,
                icon: const Icon(
                  Icons.chevron_left,
                  size: 18,
                  color: AppColors.textMuted,
                ),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
              SizedBox(
                width: 96,
                child: Text(
                  _WorkLogStrings.monthLabel(language, month),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                onPressed: controller.goToNextMonth,
                icon: const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.textMuted,
                ),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(7, (i) {
              final color = i == 0
                  ? const Color(0xFF2196F3)
                  : i == 6
                  ? const Color(0xFF2196F3)
                  : AppColors.textMuted;
              return Expanded(
                child: Text(
                  weekdayLabels[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              );
            }),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 2),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.92,
            ),
            itemCount: leadingBlanks + daysInMonth,
            itemBuilder: (context, index) {
              if (index < leadingBlanks) return const SizedBox.shrink();
              final day = DateTime(
                month.year,
                month.month,
                index - leadingBlanks + 1,
              );
              return _DayCell(
                day: day,
                controller: controller,
                onTap: onDayTap,
              );
            },
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 11,
            runSpacing: 4,
            children: [
              _LegendDot(
                color: AppColors.secondary,
                label: _WorkLogStrings.legendLogged.of(language),
              ),
              _LegendDot(
                color: AppColors.accent,
                label: _WorkLogStrings.legendOvertime.of(language),
              ),
              _LegendRiskBox(label: _WorkLogStrings.legendRisk.of(language)),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.controller,
    required this.onTap,
  });
  final DateTime day;
  final WorkLogController controller;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    final isToday = DateUtils.isSameDay(day, controller.today);
    final isSelected = DateUtils.isSameDay(day, controller.selectedDay);
    final isRisk = controller.isRiskDay(day);
    final logged = controller.hasRecord(day);
    final overtime = controller.isOvertimeDay(day);
    final weekday = day.weekday % 7;

    final textColor = isToday
        ? Colors.white
        : weekday == 0
        ? const Color(0xFF2196F3)
        : weekday == 6
        ? const Color(0xFF2196F3)
        : AppColors.textPrimary;

    return InkWell(
      onTap: () => onTap(day),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          color: isToday ? AppColors.primary : null,
          borderRadius: BorderRadius.circular(8),
          border: isRisk
              ? Border.all(color: const Color(0xFF0D47A1), width: 1.5)
              : isSelected
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: TextStyle(
                fontSize: 11,
                color: textColor,
                fontWeight: isToday ? FontWeight.w800 : FontWeight.w400,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (logged)
                  _Dot(color: isToday ? Colors.white : AppColors.secondary),
                if (overtime) ...[
                  const SizedBox(width: 2),
                  _Dot(color: isToday ? Colors.white : AppColors.accent),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 9.5, color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _LegendRiskBox extends StatelessWidget {
  const _LegendRiskBox({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: const Color(0xFF0D47A1), width: 1.5),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 9.5, color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _DailyHookBody extends StatelessWidget {
  const _DailyHookBody({
    required this.controller,
    this.scrollController,
    required this.language,
  });
  final WorkLogController controller;
  final ScrollController? scrollController;
  final AppLanguage language;

  Future<void> _pickTime(
    BuildContext context, {
    required bool isClockIn,
  }) async {
    final record = controller.selectedRecord;
    final initial =
        (isClockIn ? record.clockIn : record.clockOut) ??
        const TimeOfDay(hour: 9, minute: 0);
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;
    controller.updateSelectedRecord(
      (r) => isClockIn
          ? r.copyWith(clockIn: picked)
          : r.copyWith(clockOut: picked),
    );
  }

  Future<void> _pickBreakMinutes(BuildContext context) async {
    var value = controller.selectedRecord.breakMinutes;
    final result = await showDialog<int>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                _WorkLogStrings.breakTimeTitle.of(language),
                style: const TextStyle(fontSize: 15),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${value}m',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  Slider(
                    value: value.toDouble(),
                    min: 0,
                    max: 120,
                    divisions: 12,
                    label: '${value}m',
                    onChanged: (v) => setState(() => value = v.round()),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(_WorkLogStrings.cancel.of(language)),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(value),
                  child: Text(_WorkLogStrings.confirm.of(language)),
                ),
              ],
            );
          },
        );
      },
    );
    if (result == null) return;
    controller.updateSelectedRecord((r) => r.copyWith(breakMinutes: result));
  }

  String _fmtTime(TimeOfDay? t) => t == null
      ? '--:--'
      : '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final record = controller.selectedRecord;
    final day = controller.selectedDay;
    final worked = record.workedDuration;

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(15, 13, 15, 20),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${day.year}.${day.month.toString().padLeft(2, '0')}.${day.day.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  _LocationVerifyBadge(
                    record: record,
                    isToday: DateUtils.isSameDay(day, controller.today),
                    language: language,
                    onVerified: (lat, lng, address) =>
                        controller.updateSelectedRecord(
                          (r) => r.copyWith(
                            gpsVerified: true,
                            verifiedLatitude: lat,
                            verifiedLongitude: lng,
                            verifiedAddress: address,
                          ),
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 11),
              _TimeRow(
                label: _WorkLogStrings.clockIn.of(language),
                value: _fmtTime(record.clockIn),
                onTap: () => _pickTime(context, isClockIn: true),
              ),
              const SizedBox(height: 8),
              _TimeRow(
                label: _WorkLogStrings.clockOut.of(language),
                value: _fmtTime(record.clockOut),
                onTap: () => _pickTime(context, isClockIn: false),
              ),
              const SizedBox(height: 8),
              _TimeRow(
                label: _WorkLogStrings.breakLabel.of(language),
                value: '${record.breakMinutes}m',
                onTap: () => _pickBreakMinutes(context),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.blueBg,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _WorkLogStrings.actualWorkedTime.of(language),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${worked.inHours}h ${(worked.inMinutes % 60).toString().padLeft(2, '0')}m',
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.green50,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _WorkLogStrings.estimatedWage.of(language),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.green900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      formatWon(controller.wageForDay(day), language),
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.green900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _AttachButton(
                      label: _WorkLogStrings.photoAttach.of(language),
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: _AttachButton(
                      label: _WorkLogStrings.audioRecord.of(language),
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: _AttachButton(
                      label: _WorkLogStrings.transitCardAttach.of(language),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              TextField(
                minLines: 2,
                maxLines: 4,
                controller: TextEditingController(text: record.memo)
                  ..selection = TextSelection.collapsed(
                    offset: record.memo.length,
                  ),
                onChanged: (v) =>
                    controller.updateSelectedRecord((r) => r.copyWith(memo: v)),
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  hintText: _WorkLogStrings.memoHint.of(language),
                  hintStyle: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFFBFDFF),
                  contentPadding: const EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 11),
        VaultBox(language: language),
        const SizedBox(height: 14),
        Text(
          _WorkLogStrings.nextStepsLabel.of(language),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _EntryCard(
                gradient: const [Color(0xFF2196F3), Color(0xFF0D47A1)],
                emoji: '💸',
                title: _WorkLogStrings.wageEntryTitle.of(language),
                subtitle: _WorkLogStrings.wageEntrySubtitle.of(language),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const WageNavigatorScreen(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: _EntryCard(
                gradient: const [Color(0xFF4CAF50), Color(0xFF1B5E20)],
                emoji: '⛑️',
                title: _WorkLogStrings.injuryEntryTitle.of(language),
                subtitle: _WorkLogStrings.injuryEntrySubtitle.of(language),
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
    );
  }
}

class _TimeRow extends StatelessWidget {
  const _TimeRow({
    required this.label,
    required this.value,
    required this.onTap,
  });
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 44,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Text(
                    '▾',
                    style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 오늘 기록이면서 아직 인증 전이면 "위치 인증하기" 버튼을, 그 외에는 기존
/// 완료/사업장 외부 안내 배지를 보여준다. 과거 날짜는 GPS를 다시 딸 수 없으니
/// 그때 기록된 값을 그대로 배지로만 보여주고 버튼을 띄우지 않는다.
class _LocationVerifyBadge extends StatefulWidget {
  const _LocationVerifyBadge({
    required this.record,
    required this.isToday,
    required this.language,
    required this.onVerified,
  });

  final DailyWorkRecord record;
  final bool isToday;
  final AppLanguage language;
  final void Function(double latitude, double longitude, String? address)
  onVerified;

  @override
  State<_LocationVerifyBadge> createState() => _LocationVerifyBadgeState();
}

class _LocationVerifyBadgeState extends State<_LocationVerifyBadge> {
  bool _verifying = false;

  Future<void> _verify() async {
    final lang = widget.language;
    setState(() => _verifying = true);
    try {
      final outcome = await LocationVerifyService().verifyCurrentLocation(
        language: lang,
      );
      switch (outcome.status) {
        case LocationVerifyStatus.verified:
          widget.onVerified(
            outcome.result!.latitude,
            outcome.result!.longitude,
            outcome.result!.address,
          );
          break;
        case LocationVerifyStatus.serviceDisabled:
          _showMessage(_WorkLogStrings.gpsServiceDisabled.of(lang));
          break;
        case LocationVerifyStatus.permissionDenied:
          _showMessage(_WorkLogStrings.gpsPermissionDenied.of(lang));
          break;
        case LocationVerifyStatus.rejected:
          _showMessage(_WorkLogStrings.gpsVerifyFailed.of(lang));
          break;
        case LocationVerifyStatus.error:
          _showMessage(_WorkLogStrings.gpsVerifyError.of(lang));
          break;
      }
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final record = widget.record;
    final lang = widget.language;

    if (widget.isToday && !record.gpsVerified) {
      return InkWell(
        onTap: _verifying ? null : _verify,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_verifying) ...[
                const SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.6,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                _WorkLogStrings.gpsVerifyButton.of(lang),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 150),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: record.gpsVerified
            ? const Color(0xFFE8F5E9)
            : const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            record.gpsVerified
                ? _WorkLogStrings.gpsVerified.of(lang)
                : _WorkLogStrings.gpsUnverified.of(lang),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: record.gpsVerified
                  ? const Color(0xFF1B5E20)
                  : const Color(0xFF0D47A1),
            ),
          ),
          // 좌표 숫자 대신 서버가 역지오코딩으로 돌려준 주소 문자열을 보여준다
          // — 지오코딩 실패 시(verifiedAddress == null)엔 위 완료 문구만
          // 남기고 조용히 생략한다.
          if (record.gpsVerified && record.verifiedAddress != null)
            Text(
              record.verifiedAddress!,
              maxLines: 2,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 8.5, color: Color(0xFF1B5E20)),
            ),
        ],
      ),
    );
  }
}

class _AttachButton extends StatelessWidget {
  const _AttachButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // TODO(backend): image_picker/파일 첨부 + Firebase Storage 업로드 연동.
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF90CAF9)),
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({
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
        padding: const EdgeInsets.all(13),
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
            Text(emoji, style: const TextStyle(fontSize: 17)),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 9.5,
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
