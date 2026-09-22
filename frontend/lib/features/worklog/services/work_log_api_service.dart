import '../../../core/api_client.dart';
import '../models/daily_work_record.dart';

String _isoDate(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';

/// 백엔드 GET/PUT /api/worklog/days — 로그인한 사용자의 근무기록 캘린더 연동.
class WorkLogApiService {
  WorkLogApiService({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  void dispose() => _client.dispose();

  /// 월/연도를 넘는 최근 30일도 기존 월별 API로 조회한다. 부분 실패 시
  /// 일부 달만 반환하지 않고 전체 요청을 실패시켜 불완전한 증빙 출력을 막는다.
  Future<Map<DateTime, DailyWorkRecord>> fetchRecent30Days({
    required String idToken,
    required DateTime today,
  }) async {
    final end = DateTime(today.year, today.month, today.day);
    final start = DateTime(end.year, end.month, end.day - 29);
    final months = <DateTime>[
      for (
        var m = DateTime(start.year, start.month);
        !m.isAfter(end);
        m = DateTime(m.year, m.month + 1)
      )
        m,
    ];
    final responses = await Future.wait(
      months.map(
        (month) =>
            fetchMonth(idToken: idToken, year: month.year, month: month.month),
      ),
    ).timeout(const Duration(seconds: 30));
    final entries =
        responses
            .expand((records) => records.entries)
            .where((e) => !e.key.isBefore(start) && !e.key.isAfter(end))
            .toList()
          ..sort((a, b) => a.key.compareTo(b.key));
    return Map.fromEntries(entries);
  }

  Future<Map<DateTime, DailyWorkRecord>> fetchMonth({
    required String idToken,
    required int year,
    required int month,
  }) async {
    final json = await _client.getJson(
      '/api/worklog/days',
      query: {'year': '$year', 'month': '$month'},
      idToken: idToken,
    );
    final days = (json as Map<String, dynamic>)['days'] as List<dynamic>;
    final result = <DateTime, DailyWorkRecord>{};
    for (final raw in days) {
      final map = raw as Map<String, dynamic>;
      final date = DateTime.parse(map['date'] as String);
      result[DateTime(date.year, date.month, date.day)] =
          DailyWorkRecord.fromJson(map);
    }
    return result;
  }

  Future<DailyWorkRecord> upsertDay({
    required String idToken,
    required DateTime day,
    required DailyWorkRecord record,
  }) async {
    final json = await _client.putJson(
      '/api/worklog/days/${_isoDate(day)}',
      record.toUpsertJson(),
      idToken: idToken,
    );
    return DailyWorkRecord.fromJson(json as Map<String, dynamic>);
  }
}
