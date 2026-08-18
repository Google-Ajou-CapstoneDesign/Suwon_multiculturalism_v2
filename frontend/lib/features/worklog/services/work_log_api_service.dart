import '../../../core/api_client.dart';
import '../models/daily_work_record.dart';

String _isoDate(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';

/// 백엔드 GET/PUT /api/worklog/days — 로그인한 사용자의 근무기록 캘린더 연동.
class WorkLogApiService {
  WorkLogApiService({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

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
