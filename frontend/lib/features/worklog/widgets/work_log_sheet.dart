import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../controllers/work_log_controller.dart';
import '../screens/accident_navigator_screen.dart';
import '../screens/wage_navigator_screen.dart';

/// 하단 가운데 "오늘" 버튼으로 여닫는 근무기록장 시트.
/// 화면 전체를 덮지 않고 하단 탭바는 남겨둔다 — 달력 버튼을 다시 눌러 닫을 수 있게 하기 위함.
class WorkLogSheet extends StatefulWidget {
  const WorkLogSheet({super.key, required this.isOpen, required this.onClose});

  final bool isOpen;
  final VoidCallback onClose;

  @override
  State<WorkLogSheet> createState() => _WorkLogSheetState();
}

class _WorkLogSheetState extends State<WorkLogSheet> {
  final _controller = WorkLogController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openDayRecord(DateTime day) {
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
                    _Header(onClose: widget.onClose),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _CalendarBlock(
                              controller: _controller,
                              onDayTap: _openDayRecord,
                            ),
                            const _TapHint(),
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

class _TapHint extends StatelessWidget {
  const _TapHint();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 16, 15, 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(13),
        ),
        child: const Row(
          children: [
            Text('👆', style: TextStyle(fontSize: 18)),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                '날짜를 탭하면 그날의 출퇴근 기록을 확인하고 수정할 수 있어요',
                style: TextStyle(
                  fontSize: 11.5,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ],
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
  const _Header({required this.onClose});
  final VoidCallback onClose;

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
                const Text(
                  '근무기록장',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 3),
                const Text(
                  '매일의 기록이 가장 확실한 증거가 됩니다',
                  style: TextStyle(fontSize: 10.5, color: AppColors.textMuted),
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
            child: const Text(
              '닫기',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarBlock extends StatelessWidget {
  const _CalendarBlock({required this.controller, required this.onDayTap});
  final WorkLogController controller;
  final ValueChanged<DateTime> onDayTap;

  static const _weekdayLabels = ['일', '월', '화', '수', '목', '금', '토'];

  @override
  Widget build(BuildContext context) {
    final month = controller.focusedMonth;
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final leadingBlanks = DateTime(month.year, month.month, 1).weekday % 7;

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
                  '${month.year}년 ${month.month}월',
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
                  ? const Color(0xFFE06060)
                  : i == 6
                  ? const Color(0xFF5B8DEF)
                  : AppColors.textMuted;
              return Expanded(
                child: Text(
                  _weekdayLabels[i],
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
              _LegendDot(color: AppColors.secondary, label: '기록 완료'),
              _LegendDot(color: AppColors.accent, label: '연장·야간'),
              _LegendRiskBox(label: '급여 미지급 의심'),
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
        ? const Color(0xFFE06060)
        : weekday == 6
        ? const Color(0xFF5B8DEF)
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
              ? Border.all(color: const Color(0xFFDC2626), width: 1.5)
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
            border: Border.all(color: const Color(0xFFDC2626), width: 1.5),
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
  const _DailyHookBody({required this.controller, this.scrollController});
  final WorkLogController controller;
  final ScrollController? scrollController;

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
              title: const Text('휴게시간', style: TextStyle(fontSize: 15)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$value분',
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
                    label: '$value분',
                    onChanged: (v) => setState(() => value = v.round()),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(value),
                  child: const Text('확인'),
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: record.gpsVerified
                          ? const Color(0xFFE6F6F4)
                          : const Color(0xFFFEF3E2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      record.gpsVerified ? '📍 위치 인증 완료' : '📍 사업장 외부 기록',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: record.gpsVerified
                            ? const Color(0xFF0B7267)
                            : const Color(0xFFB45309),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 11),
              _TimeRow(
                label: '출근',
                value: _fmtTime(record.clockIn),
                onTap: () => _pickTime(context, isClockIn: true),
              ),
              const SizedBox(height: 8),
              _TimeRow(
                label: '퇴근',
                value: _fmtTime(record.clockOut),
                onTap: () => _pickTime(context, isClockIn: false),
              ),
              const SizedBox(height: 8),
              _TimeRow(
                label: '휴게',
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
                    const Text(
                      '실근무시간',
                      style: TextStyle(
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
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _AttachButton(label: '📷 타임스탬프 사진', onTap: () {}),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: _AttachButton(label: '📎 급여명세서 첨부', onTap: () {}),
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
                  hintText: '오늘 있었던 일을 적어두세요 (예: 사장님이 30분 더 일하라고 함)',
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
        const SizedBox(height: 14),
        const Text(
          '기록이 쌓였다면',
          style: TextStyle(
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
            const SizedBox(width: 9),
            Expanded(
              child: _EntryCard(
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
        side: const BorderSide(color: Color(0xFFC6D2E2)),
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
