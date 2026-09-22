import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:frontend/core/api_client.dart';
import 'package:frontend/core/app_language.dart';
import 'package:frontend/core/user_profile_controller.dart';
import 'package:frontend/features/worklog/models/daily_work_record.dart';
import 'package:frontend/features/worklog/models/work_log_report.dart';
import 'package:frontend/features/worklog/models/work_log_report_strings.dart';
import 'package:frontend/features/worklog/services/work_log_api_service.dart';
import 'package:frontend/features/worklog/services/work_log_report_service.dart';
import 'package:frontend/features/navigator_flow/pdf/work_log_pdf_builder.dart';
import 'package:frontend/features/navigator_flow/widgets/work_log_export_section.dart';
import 'package:frontend/features/navigator_flow/data/wage_flow_data.dart';
import 'package:frontend/features/navigator_flow/models/flow_block.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    '30-day range handles year boundary and retains partial/location-only records',
    () async {
      final months = <String>[];
      final api = WorkLogApiService(
        client: ApiClient(
          client: MockClient((request) async {
            expect(request.headers['Authorization'], 'Bearer token');
            expect(request.url.path, '/api/worklog/days');
            months.add(
              '${request.url.queryParameters['year']}-${request.url.queryParameters['month']}',
            );
            return http.Response(
              jsonEncode({
                'days': request.url.queryParameters['month'] == '12'
                    ? [
                        {'date': '2025-12-23'},
                        {'date': '2025-12-24', 'clockIn': '09:00'},
                      ]
                    : [
                        {
                          'date': '2026-01-22',
                          'gpsVerified': true,
                          'verifiedLatitude': 37.2,
                          'verifiedLongitude': 127.0,
                        },
                        {'date': '2026-01-23'},
                      ],
              }),
              200,
            );
          }),
        ),
      );
      final records = await api.fetchRecent30Days(
        idToken: 'token',
        today: DateTime(2026, 1, 22),
      );
      expect(months, ['2025-12', '2026-1']);
      expect(records.keys, [DateTime(2025, 12, 24), DateTime(2026, 1, 22)]);
      expect(records.values.first.clockOut, isNull);
      expect(records.values.last.verifiedLatitude, 37.2);
    },
  );

  test('30 days around February can require three monthly requests', () async {
    final months = <String>[];
    final api = WorkLogApiService(
      client: ApiClient(
        client: MockClient((request) async {
          months.add(request.url.queryParameters['month']!);
          return http.Response('{"days":[]}', 200);
        }),
      ),
    );
    await api.fetchRecent30Days(idToken: 'token', today: DateTime(2026, 3, 1));
    expect(months, ['1', '2', '3']);
  });

  test('failed monthly request does not return a partial report', () async {
    final api = WorkLogApiService(
      client: ApiClient(
        client: MockClient(
          (request) async => request.url.queryParameters['month'] == '8'
              ? http.Response('unavailable', 503)
              : http.Response(
                  '{"days":[{"date":"2026-09-01","clockIn":"09:00"}]}',
                  200,
                ),
        ),
      ),
    );
    await expectLater(
      api.fetchRecent30Days(idToken: 'token', today: DateTime(2026, 9, 22)),
      throwsA(isA<ApiException>()),
    );
  });

  test('export follows complaint review and precedes submission', () {
    final steps = wageFlowDefinition.steps;
    final index = steps.indexWhere(
      (s) => s.blocks.any((b) => b is WorkLogExportBlock),
    );
    expect(steps[index - 1].blocks.any((b) => b is PdfActionsBlock), isTrue);
    expect(steps[index + 1].title.ko, '제출 방법을 선택하세요');
  });

  test(
    'guest loads clearly identified demo records without Firebase initialization',
    () async {
      final report = await loadWorkLogReport(null, '');
      expect(report.isDemo, isTrue);
      expect(report.userId, isNull);
      expect(report.records.length, 6);
      expect(report.dates.length, 30);
      expect(report.filename('ko'), startsWith('DEMO_'));
    },
  );

  test(
    'PDF supports all app languages, 30 days and long mixed-script notes',
    () async {
      final records = <DateTime, DailyWorkRecord>{
        for (var i = 0; i < 30; i++)
          DateTime(2026, 9, 22 - i): DailyWorkRecord(
            clockIn: const TimeOfDay(hour: 8, minute: 15),
            clockOut: i == 0 ? null : const TimeOfDay(hour: 18, minute: 30),
            breakMinutes: 60,
            gpsVerified: i % 2 == 0,
            verifiedAddress: i % 2 == 0 ? '경기도 수원시 영통구 월드컵로 206' : null,
            verifiedLatitude: i % 2 == 0 ? 37.283 : null,
            verifiedLongitude: i % 2 == 0 ? 127.046 : null,
            memo: i == 3
                ? List.filled(
                    100,
                    '원문 기록 中文 Tiếng Việt Oʻzbekcha Türkçe. ',
                  ).join()
                : '근무 기록 원문',
          ),
      };
      for (final lang in AppLanguage.values) {
        final report = WorkLogReport(
          generatedAt: DateTime.utc(2026, 9, 22, 14, 25),
          isDemo: true,
          ownerName: 'DEMO',
          userId: null,
          records: records,
        );
        final bytes = await buildWorkLogPdf(report: report, lang: lang);
        expect(ascii.decode(bytes.take(5).toList()), '%PDF-');
        if (const bool.fromEnvironment('WORKLOG_PDF_QA')) {
          final directory = Directory('build/worklog_pdf_qa')
            ..createSync(recursive: true);
          File('${directory.path}/${lang.name}.pdf').writeAsBytesSync(bytes);
        }
      }
    },
  );

  Widget screen(UserProfileController profile, WorkLogReportLoader loader) =>
      UserProfileScope(
        controller: profile,
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: WorkLogExportSection(loader: loader),
            ),
          ),
        ),
      );

  testWidgets(
    'load error offers retry, never replaces signed-in records with demo',
    (tester) async {
      final profile = UserProfileController()
        ..applyAuthenticatedProfile(uid: 'u', name: 'Tester');
      addTearDown(profile.dispose);
      var attempts = 0;
      await tester.pumpWidget(
        screen(profile, (uid, owner) async {
          expect(uid, 'u');
          if (++attempts == 1) throw StateError('offline');
          return WorkLogReport(
            generatedAt: DateTime(2026, 9, 22),
            isDemo: false,
            ownerName: owner,
            userId: uid,
            records: {},
          );
        }),
      );
      await tester.pumpAndSettle();
      expect(find.text(WorkLogReportStrings.error.ko), findsOneWidget);
      expect(find.text(WorkLogReportStrings.demo.ko), findsNothing);
      expect(find.text(WorkLogReportStrings.koreanPdf.ko), findsNothing);
      await tester.tap(find.text(WorkLogReportStrings.load.ko));
      await tester.pumpAndSettle();
      expect(find.text(WorkLogReportStrings.empty.ko), findsOneWidget);
    },
  );

  testWidgets('late previous-account response cannot replace guest demo', (
    tester,
  ) async {
    final profile = UserProfileController()
      ..applyAuthenticatedProfile(uid: 'u', name: 'Tester');
    addTearDown(profile.dispose);
    final pending = Completer<WorkLogReport>();
    await tester.pumpWidget(
      screen(
        profile,
        (uid, name) =>
            uid == null ? loadWorkLogReport(null, '') : pending.future,
      ),
    );
    profile.signOut();
    await tester.pumpAndSettle();
    expect(find.text(WorkLogReportStrings.demo.ko), findsOneWidget);
    pending.complete(
      WorkLogReport(
        generatedAt: DateTime(2026, 9, 22),
        isDemo: false,
        ownerName: 'OLD USER',
        userId: 'u',
        records: {},
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(WorkLogReportStrings.empty.ko), findsNothing);
    expect(find.text(WorkLogReportStrings.koreanPdf.ko), findsOneWidget);
  });
}
