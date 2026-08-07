import 'package:flutter/material.dart';
import '../models/daily_work_record.dart';

/// 근무기록장(캘린더 + 일일 기록) 상태.
/// TODO(backend): worklogs 컬렉션과 연동 — 지금은 최근 며칠치 데모 기록만 로컬에 시드한다.
class WorkLogController extends ChangeNotifier {
  WorkLogController() {
    _seedDemoData();
  }

  DateTime _focusedMonth = DateUtils.dateOnly(DateTime.now());
  DateTime get focusedMonth => DateTime(_focusedMonth.year, _focusedMonth.month);

  DateTime _selectedDay = DateUtils.dateOnly(DateTime.now());
  DateTime get selectedDay => _selectedDay;

  DateTime get today => DateUtils.dateOnly(DateTime.now());

  final Map<DateTime, DailyWorkRecord> _records = {};

  void _seedDemoData() {
    final now = today;
    for (var i = 0; i < 6; i++) {
      final day = now.subtract(Duration(days: i));
      if (day.month != now.month) continue; // 데모 데이터는 이번 달 범위로만 제한
      final isOvertime = i == 1 || i == 3;
      _records[day] = DailyWorkRecord(
        clockIn: const TimeOfDay(hour: 8, minute: 0),
        clockOut: isOvertime ? const TimeOfDay(hour: 20, minute: 30) : const TimeOfDay(hour: 17, minute: 0),
        breakMinutes: 60,
        isOvertime: isOvertime,
        isRisk: i == 4,
        gpsVerified: true,
      );
    }
  }

  DailyWorkRecord recordFor(DateTime day) => _records[DateUtils.dateOnly(day)] ?? DailyWorkRecord.empty;

  DailyWorkRecord get selectedRecord => recordFor(_selectedDay);

  bool hasRecord(DateTime day) => _records.containsKey(DateUtils.dateOnly(day)) && recordFor(day).hasEntry;

  bool isOvertimeDay(DateTime day) => recordFor(day).isOvertime;

  bool isRiskDay(DateTime day) => recordFor(day).isRisk;

  void selectDay(DateTime day) {
    _selectedDay = DateUtils.dateOnly(day);
    notifyListeners();
  }

  void goToPreviousMonth() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    notifyListeners();
  }

  void goToNextMonth() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    notifyListeners();
  }

  void updateSelectedRecord(DailyWorkRecord Function(DailyWorkRecord current) update) {
    final key = _selectedDay;
    _records[key] = update(_records[key] ?? DailyWorkRecord.empty);
    notifyListeners();
  }
}
