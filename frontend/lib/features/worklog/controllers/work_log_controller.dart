import 'package:flutter/material.dart';
import '../../auth/services/auth_service.dart';
import '../models/daily_work_record.dart';
import '../services/work_log_api_service.dart';

/// 근무기록장(캘린더 + 일일 기록) 상태.
/// 게스트(비로그인)면 데모 기록만 로컬에 시드하고, 로그인 상태면
/// [setSignedIn]으로 전환될 때 GET /api/worklog/days에서 실제 데이터를
/// 가져와 표시한다 — MainShell이 UserProfileController.isSignedIn 변화를
/// 감지해 이 메서드를 호출한다.
class WorkLogController extends ChangeNotifier {
  WorkLogController({WorkLogApiService? api, AuthService? authService})
    : _api = api ?? WorkLogApiService(),
      _authService = authService ?? AuthService() {
    _seedDemoData();
  }

  final WorkLogApiService _api;
  final AuthService _authService;

  bool _signedIn = false;

  bool _loading = false;
  bool get loading => _loading;

  DateTime _focusedMonth = DateUtils.dateOnly(DateTime.now());
  DateTime get focusedMonth =>
      DateTime(_focusedMonth.year, _focusedMonth.month);

  DateTime _selectedDay = DateUtils.dateOnly(DateTime.now());
  DateTime get selectedDay => _selectedDay;

  DateTime get today => DateUtils.dateOnly(DateTime.now());

  final Map<DateTime, DailyWorkRecord> _records = {};

  void _seedDemoData() {
    final now = today;
    // 오늘은 실제 출근/퇴근 버튼으로 기록할 수 있도록 비워 둔다.
    for (var i = 1; i <= 6; i++) {
      final day = now.subtract(Duration(days: i));
      if (day.month != now.month) continue; // 데모 데이터는 이번 달 범위로만 제한
      final isOvertime = i == 1 || i == 3;
      _records[day] = DailyWorkRecord(
        clockIn: const TimeOfDay(hour: 8, minute: 0),
        clockOut: isOvertime
            ? const TimeOfDay(hour: 20, minute: 30)
            : const TimeOfDay(hour: 17, minute: 0),
        breakMinutes: 60,
        isOvertime: isOvertime,
        isRisk: i == 4,
        gpsVerified: true,
      );
    }
  }

  /// 로그인 상태가 바뀔 때(MainShell이 UserProfileController를 지켜보다가)
  /// 호출한다 — 게스트로 전환되면 데모 데이터로, 로그인 상태로 전환되면
  /// 서버의 이번 달 근무기록으로 교체한다. 값이 그대로면 아무 일도 하지 않는다.
  Future<void> setSignedIn(bool signedIn) async {
    if (_signedIn == signedIn) return;
    _signedIn = signedIn;
    _records.clear();
    if (signedIn) {
      await _loadMonth(_focusedMonth);
    } else {
      _seedDemoData();
      notifyListeners();
    }
  }

  Future<void> _loadMonth(DateTime month) async {
    if (!_signedIn) return;
    _loading = true;
    notifyListeners();
    try {
      final idToken = await _authService.currentIdToken();
      if (idToken == null) return;
      final fetched = await _api.fetchMonth(
        idToken: idToken,
        year: month.year,
        month: month.month,
      );
      _records
        ..removeWhere(
          (day, _) => day.year == month.year && day.month == month.month,
        )
        ..addAll(fetched);
    } catch (_) {
      // 조회 실패해도 화면 자체는 그대로 둔다(빈 캘린더로 보여줄 뿐 크래시하지 않는다).
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> _persistDay(DateTime day) async {
    if (!_signedIn) return;
    try {
      final idToken = await _authService.currentIdToken();
      if (idToken == null) return;
      final record = _records[day] ?? DailyWorkRecord.empty;
      final saved = await _api.upsertDay(
        idToken: idToken,
        day: day,
        record: record,
      );
      _records[day] = saved; // 서버가 계산한 isOvertime 등을 그대로 반영한다.
      notifyListeners();
    } catch (_) {
      // 저장 실패해도 로컬 상태는 이미 반영돼 있으니 조용히 넘어간다.
    }
  }

  /// 오늘 기록 — 홈 화면의 "오늘의 근무" 위젯이 직접 읽는다.
  DailyWorkRecord get todayRecord => recordFor(today);

  void clockInToday() {
    final now = DateTime.now();
    final key = DateUtils.dateOnly(now);
    final current = _records[key] ?? DailyWorkRecord.empty;
    if (current.clockIn != null) return;
    _records[key] = current.copyWith(clockIn: TimeOfDay.fromDateTime(now));
    _selectedDay = key;
    _focusedMonth = key;
    notifyListeners();
    _persistDay(key);
  }

  void clockOutToday() {
    final now = DateTime.now();
    final key = DateUtils.dateOnly(now);
    final current = _records[key] ?? DailyWorkRecord.empty;
    if (current.clockIn == null || current.clockOut != null) return;
    _records[key] = current.copyWith(clockOut: TimeOfDay.fromDateTime(now));
    _selectedDay = key;
    _focusedMonth = key;
    notifyListeners();
    _persistDay(key);
  }

  void markTodayLocationVerified() {
    final key = today;
    final current = _records[key] ?? DailyWorkRecord.empty;
    if (current.clockIn == null || current.gpsVerified) return;
    _records[key] = current.copyWith(gpsVerified: true);
    notifyListeners();
    _persistDay(key);
  }

  DailyWorkRecord recordFor(DateTime day) =>
      _records[DateUtils.dateOnly(day)] ?? DailyWorkRecord.empty;

  DailyWorkRecord get selectedRecord => recordFor(_selectedDay);

  bool hasRecord(DateTime day) =>
      _records.containsKey(DateUtils.dateOnly(day)) && recordFor(day).hasEntry;

  bool isOvertimeDay(DateTime day) => recordFor(day).isOvertime;

  bool isRiskDay(DateTime day) => recordFor(day).isRisk;

  void selectDay(DateTime day) {
    _selectedDay = DateUtils.dateOnly(day);
    notifyListeners();
  }

  void goToPreviousMonth() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    notifyListeners();
    _loadMonth(_focusedMonth);
  }

  void goToNextMonth() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    notifyListeners();
    _loadMonth(_focusedMonth);
  }

  void updateSelectedRecord(
    DailyWorkRecord Function(DailyWorkRecord current) update,
  ) {
    final key = _selectedDay;
    _records[key] = update(_records[key] ?? DailyWorkRecord.empty);
    notifyListeners();
    _persistDay(key);
  }
}
