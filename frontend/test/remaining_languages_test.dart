import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pdf/pdf.dart';
import 'package:frontend/common/widgets/language_directionality.dart';
import 'package:frontend/core/app_language.dart';
import 'package:frontend/core/api_client.dart';
import 'package:frontend/core/user_profile_controller.dart';
import 'package:frontend/common/widgets/language_sheet.dart';
import 'package:frontend/features/settings/models/settings_strings.dart';
import 'package:frontend/features/encyclopedia/models/encyclopedia_strings.dart';
import 'package:frontend/features/ai_guide/services/chat_api_service.dart';
import 'package:frontend/features/auth/services/auth_service.dart';
import 'package:frontend/features/home/screens/home_screen.dart';
import 'package:frontend/features/worklog/controllers/work_log_controller.dart';
import 'package:frontend/features/worklog/widgets/work_log_sheet.dart';
import 'package:frontend/features/navigator_flow/controllers/form_values_controller.dart';
import 'package:frontend/features/navigator_flow/models/form_field_spec.dart';
import 'package:frontend/features/navigator_flow/models/flow_block.dart';
import 'package:frontend/features/navigator_flow/pdf/complaint_pdf_builder.dart';
import 'package:frontend/features/navigator_flow/pdf/work_log_pdf_builder.dart';
import 'package:frontend/features/worklog/models/daily_work_record.dart';
import 'package:frontend/features/worklog/models/work_log_report.dart';
import 'package:frontend/theme/app_theme.dart';

const languages = [
  AppLanguage.lo,
  AppLanguage.mn,
  AppLanguage.my,
  AppLanguage.bn,
  AppLanguage.si,
  AppLanguage.id,
  AppLanguage.km,
  AppLanguage.ky,
  AppLanguage.th,
  AppLanguage.ur,
  AppLanguage.fil,
  AppLanguage.tg,
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final icons = FontLoader('MaterialIcons');
    icons.addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
    for (final family in [
      'LB KR',
      'NotoSans',
      'NotoSansLao',
      'NotoSansMyanmar',
      'NotoSansBengali',
      'NotoSansSinhala',
      'NotoSansKhmer',
      'NotoSansThai',
      'NotoSansArabic',
    ]) {
      final loader = FontLoader(family);
      final asset = family == 'LB KR'
          ? 'LBKR-400'
          : family == 'NotoSans'
          ? family
          : '$family-400';
      loader.addFont(rootBundle.load('assets/fonts/$asset.ttf'));
      await loader.load();
    }
  });

  for (final lang in languages) {
    test('${lang.name}: translation interpolation and UTF-8 chat', () async {
      expect(SettingsStrings.tabTitle.of(lang).trim(), isNotEmpty);
      expect(EncyclopediaStrings.itemCount(lang, 12), contains('12'));
      final client = ApiClient(
        client: MockClient((request) async {
          expect(jsonDecode(request.body)['language'], lang.name);
          return http.Response.bytes(
            utf8.encode(
              jsonEncode({
                'factAnswer': lang.nativeName,
                'recommendedOrgs': [],
              }),
            ),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }),
      );
      addTearDown(client.dispose);
      final chat = ChatApiService(
        client: client,
        tokenProvider: () async => null,
        locationProvider: () async => null,
      );
      expect(
        (await chat.send(lang.nativeName, language: lang)).factAnswer,
        lang.nativeName,
      );
    });

    testWidgets('${lang.name}: selectable on narrow language sheet', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(375, 480);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      AppLanguage? selected;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => showLanguageSheet(
                  context,
                  current: AppLanguage.ko,
                  onSelect: (value) => selected = value,
                ),
                child: const Text('languages'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('languages'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text(lang.nativeName));
      await tester.tap(find.text(lang.nativeName));
      await tester.pumpAndSettle();
      expect(selected, lang);
      expect(tester.takeException(), isNull);
    });

    testWidgets('${lang.name}: home and calendar fit a narrow screen', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final profile = UserProfileController()..setLanguage(lang);
      final worklog = WorkLogController(
        authService: AuthService(auth: _GuestAuth()),
      );
      addTearDown(profile.dispose);
      addTearDown(worklog.dispose);
      final boundaryKey = GlobalKey();
      Widget app(Widget child) => UserProfileScope(
        controller: profile,
        child: MaterialApp(
          theme: AppTheme.light,
          builder: (context, child) => LanguageDirectionality(child: child!),
          home: RepaintBoundary(key: boundaryKey, child: child),
        ),
      );
      await tester.pumpWidget(
        app(
          HomeScreen(
            workLogController: worklog,
            onOpenWorkLog: () {},
            onOpenWageCalculator: () {},
            onOpenNavigator: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      // Button text styles must retain the script fallbacks, including on web.
      for (final buttonType in [ElevatedButton, OutlinedButton]) {
        final label = find
            .descendant(
              of: find.byType(buttonType).first,
              matching: find.byType(Text),
            )
            .first;
        expect(
          DefaultTextStyle.of(tester.element(label)).style.fontFamilyFallback,
          contains(lang.fontFamily),
        );
      }
      if (const bool.fromEnvironment('LANGUAGE_QA')) {
        await tester.runAsync(() => _capture(boundaryKey, 'home-${lang.name}'));
      }
      await tester.pumpWidget(
        app(
          Scaffold(
            body: WorkLogSheet(
              isOpen: true,
              onClose: () {},
              controller: worklog,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      if (const bool.fromEnvironment('LANGUAGE_QA')) {
        await tester.runAsync(
          () => _capture(boundaryKey, 'calendar-${lang.name}'),
        );
      }
    });

    test(
      '${lang.name}: complaint and worklog PDF with mixed script input',
      () async {
        final label = SettingsStrings.tabTitle;
        final values = FormValuesController()
          ..setValue(
            'memo',
            '${lang.nativeName} · 수원시 · 2026-10-04 · 123,456 KRW',
          );
        addTearDown(values.dispose);
        final complaint = await buildComplaintPdf(
          documentTitle: label,
          sections: [
            FormSection(
              title: label,
              fields: [
                FormFieldSpec(
                  key: 'memo',
                  label: label,
                  type: FormFieldType.textarea,
                  tag: FillTag.raw,
                ),
              ],
            ),
          ],
          values: values,
          lang: lang,
          format: PdfPageFormat.a4,
        );
        final report = WorkLogReport(
          generatedAt: DateTime(2026, 10, 4),
          isDemo: false,
          userId: 'language-test',
          ownerName: lang.nativeName,
          records: {
            DateTime(2026, 10, 4): DailyWorkRecord(
              clockIn: const TimeOfDay(hour: 9, minute: 0),
              clockOut: const TimeOfDay(hour: 18, minute: 0),
              memo: '${lang.nativeName} · 수원시 · 123,456 KRW',
            ),
          },
        );
        final worklog = await buildWorkLogPdf(report: report, lang: lang);
        for (final bytes in [complaint, worklog]) {
          expect(ascii.decode(bytes.take(5).toList()), '%PDF-');
          if (lang.requiresPdfShaping) {
            expect(
              RegExp(r'/Subtype\s*/Image').hasMatch(latin1.decode(bytes)),
              isTrue,
            );
          }
        }
        if (const bool.fromEnvironment('LANGUAGE_QA')) {
          final directory = Directory('build/language_qa')
            ..createSync(recursive: true);
          File(
            '${directory.path}/complaint-${lang.name}.pdf',
          ).writeAsBytesSync(complaint);
          File(
            '${directory.path}/worklog-${lang.name}.pdf',
          ).writeAsBytesSync(worklog);
        }
      },
    );
  }

  testWidgets('app switches Urdu direction live and restores LTR', (
    tester,
  ) async {
    final profile = UserProfileController();
    addTearDown(profile.dispose);
    final key = GlobalKey();
    await tester.pumpWidget(
      UserProfileScope(
        controller: profile,
        child: MaterialApp(
          builder: (context, child) => LanguageDirectionality(child: child!),
          home: Scaffold(key: key, body: const Text('direction')),
        ),
      ),
    );
    await tester.pump();
    final context = key.currentContext!;
    profile.setLanguage(AppLanguage.ur);
    await tester.pump();
    expect(Directionality.of(context), TextDirection.rtl);
    profile.setLanguage(AppLanguage.lo);
    await tester.pump();
    expect(Directionality.of(context), TextDirection.ltr);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('all language glyphs render with bundled fonts', (tester) async {
    if (!const bool.fromEnvironment('LANGUAGE_QA')) return;
    tester.view.physicalSize = const Size(900, 1080);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: RepaintBoundary(
          key: key,
          child: Scaffold(
            body: Column(
              children: [
                for (final lang in languages)
                  Directionality(
                    textDirection: lang.isRtl
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: ListTile(
                      title: Text(
                        '${lang.nativeName} · ${SettingsStrings.tabTitle.of(lang)}',
                      ),
                      subtitle: Text(EncyclopediaStrings.itemCount(lang, 12)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 1.5);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      Directory('build/language_qa').createSync(recursive: true);
      File(
        'build/language_qa/languages.png',
      ).writeAsBytesSync(data!.buffer.asUint8List());
      image.dispose();
    });
  });
}

class _GuestAuth extends Fake implements FirebaseAuth {
  @override
  User? get currentUser => null;
}

Future<void> _capture(GlobalKey key, String name) async {
  final boundary =
      key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: 1.5);
  try {
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    Directory('build/language_qa').createSync(recursive: true);
    File(
      'build/language_qa/$name.png',
    ).writeAsBytesSync(data!.buffer.asUint8List());
  } finally {
    image.dispose();
  }
}
