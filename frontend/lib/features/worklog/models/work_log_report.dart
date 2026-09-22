import 'daily_work_record.dart';

String reportDate(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';

/// 불러온 시점의 사본. 다운로드와 미리보기는 동일한 날짜/기록을 사용한다.
class WorkLogReport {
  WorkLogReport({
    required this.generatedAt,
    required this.isDemo,
    required this.ownerName,
    required this.userId,
    required Map<DateTime, DailyWorkRecord> records,
  }) : records = Map.unmodifiable(records);

  final DateTime generatedAt;
  final bool isDemo;
  final String ownerName;
  final String? userId;
  final Map<DateTime, DailyWorkRecord> records;

  DateTime get end =>
      DateTime(generatedAt.year, generatedAt.month, generatedAt.day);
  DateTime get start => DateTime(end.year, end.month, end.day - 29);
  List<DateTime> get dates => [
    for (var i = 0; i < 30; i++)
      DateTime(start.year, start.month, start.day + i),
  ];
  String get period => '${reportDate(start)} ~ ${reportDate(end)}';
  String filename(String language) =>
      '${isDemo ? 'DEMO_' : ''}worklog_${reportDate(start)}_${reportDate(end)}_$language.pdf';
}
