import 'package:flutter/material.dart';
import '../../auth/services/auth_service.dart';
import '../../wage_calculator/models/wage_diagnosis.dart' show minWage;
import '../models/daily_work_record.dart';
import '../data/demo_work_records.dart';
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

  /// 이번 달 총 임금·일별 예상 임금 계산에 쓰는 시급 — 아직 서버에 저장하지
  /// 않는(세션 한정) 값이라 기본값은 올해 최저임금으로 시작한다.
  /// TODO(backend): 근로계약서에 등록된 실제 계약 시급이 생기면 그 값으로 대체한다.
  double _hourlyWage = minWage().$1;
  double get hourlyWage => _hourlyWage;

  void setHourlyWage(double value) {
    if (value <= 0 || value == _hourlyWage) return;
    _hourlyWage = value;
    notifyListeners();
  }

  /// 하루치 예상 임금(세전, 시급 × 실근무시간) — 연장·야간 가산 등 정밀 계산은
  /// 임금계산기 탭의 몫이고, 여기서는 간단한 곱셈으로 대략적인 금액만 보여준다.
  double wageForDay(DateTime day) =>
      recordFor(day).workedDuration.inMinutes / 60 * _hourlyWage;

  /// 오늘 실근무시간(시간 단위) — 간편 입력 시트의 초기값.
  double get todayWorkedHours => todayRecord.workedDuration.inMinutes / 60;

  /// 오늘 예상 임금.
  double get todayWage => wageForDay(today);

  /// 간편 입력 시트에서 "오늘 일한 시간"을 직접 정할 때 쓴다. 이 앱의 기록은
  /// 출퇴근 시각이 원본이라, 입력받은 실근무시간에 맞춰 퇴근 시각을 거꾸로
  /// 계산해 넣는다(출근 시각이 없으면 09:00으로 시작). 휴게시간은 그대로 두고
  /// 그만큼 퇴근 시각을 뒤로 민다.
  void setTodayWorkedHours(double hours) {
    // 자정을 넘기는 기록은 TimeOfDay 두 개로 표현할 수 없어 하루 안에 맞춘다.
    const dayEndMinutes = 23 * 60 + 59;
    final key = today;
    final current = _records[key] ?? DailyWorkRecord.empty;

    final workMinutes = (hours * 60).round().clamp(0, dayEndMinutes);
    final spanMinutes = (workMinutes + current.breakMinutes).clamp(
      0,
      dayEndMinutes,
    );
    var startMinutes = current.clockIn == null
        ? 9 * 60
        : current.clockIn!.hour * 60 + current.clockIn!.minute;
    if (startMinutes + spanMinutes > dayEndMinutes) {
      startMinutes = dayEndMinutes - spanMinutes;
    }
    final endMinutes = startMinutes + spanMinutes;

    _records[key] = current.copyWith(
      clockIn: TimeOfDay(hour: startMinutes ~/ 60, minute: startMinutes % 60),
      clockOut: TimeOfDay(hour: endMinutes ~/ 60, minute: endMinutes % 60),
    );
    _selectedDay = key;
    _focusedMonth = key;
    notifyListeners();
    _persistDay(key);
  }

  /// [focusedMonth] 기준 이번 달 총 예상 임금 — 출퇴근 버튼이 있던 자리에
  /// 대신 보여준다.
  double get monthTotalWage {
    final month = focusedMonth;
    var total = 0.0;
    for (final entry in _records.entries) {
      if (entry.key.year == month.year && entry.key.month == month.month) {
        total += entry.value.workedDuration.inMinutes / 60 * _hourlyWage;
      }
    }
    return total;
  }

  /// [focusedMonth] 기준 출퇴근이 모두 기록된 날 수 — 홈 화면 "이번 달 근무" 카드.
  int get monthWorkedDays {
    final month = focusedMonth;
    return _records.entries
        .where(
          (e) =>
              e.key.year == month.year &&
              e.key.month == month.month &&
              e.value.hasEntry,
        )
        .length;
  }

  /// [focusedMonth] 기준 총 실근무시간 — 홈 화면 "이번 달 근무" 카드.
  Duration get monthTotalWorkedDuration {
    final month = focusedMonth;
    var total = Duration.zero;
    for (final entry in _records.entries) {
      if (entry.key.year == month.year && entry.key.month == month.month) {
        total += entry.value.workedDuration;
      }
    }
    return total;
  }

  /// 홈 요약은 캘린더에서 선택한 달과 무관하게 실제 이번 달을 집계한다.
  Iterable<DailyWorkRecord> get _currentMonthRecords {
    final now = today;
    return _records.entries
        .where(
          (entry) => entry.key.year == now.year && entry.key.month == now.month,
        )
        .map((entry) => entry.value);
  }

  int get currentMonthWorkedDays =>
      _currentMonthRecords.where((record) => record.hasEntry).length;

  Duration get currentMonthWorkedDuration => _currentMonthRecords.fold(
    Duration.zero,
    (total, record) => total + record.workedDuration,
  );

  double get currentMonthWage =>
      currentMonthWorkedDuration.inMinutes / 60 * _hourlyWage;

  void _seedDemoData() {
    final now = today;
    _records.addEntries(demoWorkRecords(now).entries.where(
      (entry) => entry.key.month == now.month && entry.key.year == now.year,
    ));
  }

  /// 로그인 상태가 바뀔 때(MainShell이 UserProfileController를 지켜보다가)
  /// 호출한다 — 게스트로 전환되면 데모 데이터로, 로그인 상태로 전환되면
  /// 서버의 이번 달 근무기록으로 교체한다. 값이 그대로면 아무 일도 하지 않는다.
  Future<void> setSignedIn(bool signedIn) async {
    if (_signedIn == signedIn) return;
    _signedIn = signedIn;
    _records.clear();
    if (signedIn) {
      final now = today;
      await _loadMonth(now);
      if (_focusedMonth.year != now.year || _focusedMonth.month != now.month) {
        await _loadMonth(_focusedMonth);
      }
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

  void markTodayLocationVerified({
    required double latitude,
    required double longitude,
    String? address,
  }) {
    final key = today;
    final current = _records[key] ?? DailyWorkRecord.empty;
    if (current.clockIn == null || current.gpsVerified) return;
    _records[key] = current.copyWith(
      gpsVerified: true,
      verifiedLatitude: latitude,
      verifiedLongitude: longitude,
      verifiedAddress: address,
    );
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
