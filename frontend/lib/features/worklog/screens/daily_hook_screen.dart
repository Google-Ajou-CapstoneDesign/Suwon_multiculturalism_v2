import 'package:flutter/material.dart';
import '../../../common/widgets/app_card.dart';
import '../../../theme/app_colors.dart';
import '../models/work_type.dart';
import 'accident_navigator_screen.dart';
import 'wage_navigator_screen.dart';

/// Tab 3 홈 · 데일리 훅(일일 근무기록장).
/// TODO(backend): 저장 시 worklogs 컬렉션에 근무일자·출퇴근시각·업무내용·사진URL·특이사항 기록.
class DailyHookScreen extends StatefulWidget {
  const DailyHookScreen({super.key});

  @override
  State<DailyHookScreen> createState() => _DailyHookScreenState();
}

class _DailyHookScreenState extends State<DailyHookScreen> {
  TimeOfDay _clockIn = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _clockOut = const TimeOfDay(hour: 18, minute: 0);
  WorkType _workType = WorkType.manufacturing;
  IncidentType _incident = IncidentType.normal;
  bool _hasPhoto = false;

  Duration get _workedDuration {
    final start = Duration(hours: _clockIn.hour, minutes: _clockIn.minute);
    final end = Duration(hours: _clockOut.hour, minutes: _clockOut.minute);
    final diff = end - start;
    return diff.isNegative ? Duration.zero : diff;
  }

  Future<void> _pickTime({required bool isClockIn}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isClockIn ? _clockIn : _clockOut,
    );
    if (picked == null) return;
    setState(() => isClockIn ? _clockIn = picked : _clockOut = picked);
  }

  void _onIncidentSelected(IncidentType type) {
    setState(() => _incident = type);
    if (type == IncidentType.accident) {
      // 사고·부상 선택 시 산재 대응 네비게이터로 즉시 전환(사실값 프리필은 TODO).
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AccidentNavigatorScreen()));
    }
  }

  String _fmt(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final worked = _workedDuration;
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 근무기록'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${today.month}.${today.day}(${_weekdayLabel(today.weekday)})',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          AppCard(
            child: Row(
              children: [
                Expanded(child: _TimeStat(label: '출근', value: _fmt(_clockIn), onTap: () => _pickTime(isClockIn: true))),
                Expanded(child: _TimeStat(label: '퇴근', value: _fmt(_clockOut), onTap: () => _pickTime(isClockIn: false))),
                Expanded(
                  child: _TimeStat(label: '실근무', value: '${worked.inHours}h ${worked.inMinutes % 60}m'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          Wrap(
            spacing: 8,
            children: WorkType.values.map((t) {
              final selected = t == _workType;
              return ChoiceChip(
                label: Text(t.label),
                selected: selected,
                onSelected: (_) => setState(() => _workType = t),
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(color: selected ? Colors.white : AppColors.textPrimary, fontSize: 13),
                backgroundColor: Colors.white,
                side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          OutlinedButton.icon(
            // TODO(backend): image_picker + Firebase Storage 업로드, 타임스탬프 자동 삽입.
            onPressed: () => setState(() => _hasPhoto = !_hasPhoto),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              minimumSize: const Size.fromHeight(0),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: Icon(_hasPhoto ? Icons.check_circle : Icons.camera_alt_outlined,
                size: 18, color: _hasPhoto ? AppColors.secondary : AppColors.textSecondary),
            label: Text(
              _hasPhoto ? '현장 사진 1장 첨부됨' : '현장 사진 첨부(선택)',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ),
          const SizedBox(height: 18),

          const Text('특이사항', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: IncidentType.values.map((t) {
              final selected = t == _incident;
              final color = t == IncidentType.accident ? AppColors.accent : AppColors.primary;
              return ChoiceChip(
                label: Text(t.label),
                selected: selected,
                onSelected: (_) => _onIncidentSelected(t),
                selectedColor: color,
                labelStyle: TextStyle(color: selected ? Colors.white : AppColors.textPrimary, fontSize: 13),
                backgroundColor: Colors.white,
                side: BorderSide(color: selected ? color : AppColors.border),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          const Text('문제가 생겼다면', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _NavigatorButton(
                  label: '임금체불 대응',
                  icon: Icons.receipt_long_outlined,
                  color: AppColors.secondary,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WageNavigatorScreen())),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _NavigatorButton(
                  label: '산재 대응',
                  icon: Icons.local_hospital_outlined,
                  color: AppColors.accent,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AccidentNavigatorScreen())),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _weekdayLabel(int weekday) => const ['월', '화', '수', '목', '금', '토', '일'][weekday - 1];
}

class _TimeStat extends StatelessWidget {
  const _TimeStat({required this.label, required this.value, this.onTap});
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _NavigatorButton extends StatelessWidget {
  const _NavigatorButton({required this.label, required this.icon, required this.color, required this.onTap});
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }
}
