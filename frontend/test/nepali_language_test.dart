import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pdf/pdf.dart';
import 'package:frontend/core/app_language.dart';
import 'package:frontend/core/api_client.dart';
import 'package:frontend/common/widgets/language_sheet.dart';
import 'package:frontend/features/settings/models/settings_strings.dart';
import 'package:frontend/features/encyclopedia/models/encyclopedia_strings.dart';
import 'package:frontend/features/ai_guide/services/chat_api_service.dart';
import 'package:frontend/features/navigator_flow/controllers/form_values_controller.dart';
import 'package:frontend/features/navigator_flow/models/form_field_spec.dart';
import 'package:frontend/features/navigator_flow/models/flow_block.dart';
import 'package:frontend/features/navigator_flow/pdf/complaint_pdf_builder.dart';
import 'package:frontend/features/navigator_flow/pdf/shaped_pdf_text.dart';
import 'package:frontend/features/navigator_flow/pdf/work_log_pdf_builder.dart';
import 'package:frontend/features/worklog/models/daily_work_record.dart';
import 'package:frontend/features/worklog/models/work_log_report.dart';
import 'package:frontend/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Nepali localization and interpolated values', () {
    expect(AppLanguage.ne.name, 'ne');
    expect(AppLanguage.ne.nativeName, 'नेपाली');
    expect(SettingsStrings.tabTitle.of(AppLanguage.ne), 'सेटिङहरू');
    expect(EncyclopediaStrings.itemCount(AppLanguage.ne, 12), contains('12'));
    expect(
      EncyclopediaStrings.itemCount(AppLanguage.ne, 12),
      matches(RegExp(r'[\u0900-\u097f]')),
    );
  });

  test('chat forwards selected Nepali language', () async {
    final client = ApiClient(
      client: MockClient((request) async {
        expect(jsonDecode(request.body)['language'], 'ne');
        return http.Response.bytes(
          utf8.encode(
            jsonEncode({'factAnswer': 'नमस्ते', 'recommendedOrgs': []}),
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
      (await chat.send('नमस्ते', language: AppLanguage.ne)).factAnswer,
      'नमस्ते',
    );
  });

  testWidgets('Nepali can be selected on a narrow language sheet', (
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
    await tester.ensureVisible(find.text('नेपाली'));
    await tester.tap(find.text('नेपाली'));
    await tester.pumpAndSettle();
    expect(selected, AppLanguage.ne);
    expect(tester.takeException(), isNull);
  });

  const label = L10nText(
    ko: '근로계약',
    en: 'Employment contract',
    zh: '劳动合同',
    vi: 'Hợp đồng lao động',
    uz: 'Mehnat shartnomasi',
    tr: 'İş sözleşmesi',
    tg: "Шартномаи корӣ",
    fil: "Kontrata sa trabaho",
    ur: "کام کا معاہدہ",
    th: "สัญญาจ้างงาน",
    ky: "Эмгек келишими",
    km: "កិច្ចសន្យាការងារ",
    id: "Kontrak Kerja",
    si: "රැකියා කොන්ත්‍රාත්තුව",
    bn: "কাজের চুক্তি",
    my: "အလုပ်သမား စာချုပ်",
    mn: "Хөдөлмөрийн гэрээ",
    lo: "ສັນຍາຈ້າງງານ",
    ne: 'रोजगार सम्झौता',
    tet: 'Kontratu servisu',
  );

  test('Korean PDF retains Nepali text entered by the user', () async {
    final values = FormValuesController()
      ..setValue('memo', 'मैले तलब पाएको छैन।');
    addTearDown(values.dispose);
    final bytes = await buildComplaintPdf(
      documentTitle: label,
      sections: const [
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
      lang: AppLanguage.ko,
      format: PdfPageFormat.a4,
    );
    expect(RegExp(r'/Subtype\s*/Image').hasMatch(latin1.decode(bytes)), isTrue);
  });

  test('Korean worklog PDF retains a Nepali owner and memo', () async {
    final report = WorkLogReport(
      generatedAt: DateTime(2026, 10, 3),
      isDemo: false,
      ownerName: 'राम',
      userId: 'test-user',
      records: {
        DateTime(2026, 10, 3): const DailyWorkRecord(
          clockIn: TimeOfDay(hour: 9, minute: 0),
          clockOut: TimeOfDay(hour: 18, minute: 0),
          memo: 'मैले आज काम गरेँ।',
        ),
      },
    );
    final bytes = await buildWorkLogPdf(report: report, lang: AppLanguage.ko);
    expect(ascii.decode(bytes.take(5).toList()), '%PDF-');
    expect(RegExp(r'/Subtype\s*/Image').hasMatch(latin1.decode(bytes)), isTrue);
  });

  test(
    'Nepali complaint PDF shapes long text and preserves input values',
    () async {
      final values = FormValuesController()
        ..setValue(
          'memo',
          List.filled(
            80,
            'मैले तलब पाएको छैन। रोजगार सम्झौता · 수원시 2026-10-03',
          ).join('\n'),
        );
      addTearDown(values.dispose);
      final bytes = await buildComplaintPdf(
        documentTitle: label,
        sections: const [
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
        lang: AppLanguage.ne,
        format: PdfPageFormat.a4,
      );
      expect(ascii.decode(bytes.take(5).toList()), '%PDF-');
      expect(
        RegExp(r'/Subtype\s*/Image').hasMatch(latin1.decode(bytes)),
        isTrue,
      );
      expect(values.valueOf('memo'), contains('수원시 2026-10-03'));
      if (const bool.fromEnvironment('NEPALI_QA')) {
        final directory = Directory('build/nepali_qa')
          ..createSync(recursive: true);
        File('${directory.path}/complaint-ne.pdf').writeAsBytesSync(bytes);
      }
    },
  );

  testWidgets('Nepali font renders conjuncts and mixed-script UI', (
    tester,
  ) async {
    // Also loads actual bundled fonts instead of the test-only Ahem font.
    await tester.runAsync(() async {
      await ShapedPdfText().lines('नेपाली', width: 300);
      final loader = FontLoader('LB KR')
        ..addFont(rootBundle.load('assets/fonts/LBKR-400.ttf'));
      await loader.load();
    });
    final key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: RepaintBoundary(
            key: key,
            child: Container(
              color: Colors.white,
              width: 375,
              padding: const EdgeInsets.all(20),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('नेपाली', style: TextStyle(fontSize: 24)),
                  SizedBox(height: 12),
                  Text(
                    'रोजगार सम्झौता · ज्याला · कार्यस्थल दुर्घटना',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'मैले तलब पाएको छैन। कहाँ सम्पर्क गर्ने?',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text('수원시 · Local Bridge · KRW 10,320'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    if (const bool.fromEnvironment('NEPALI_QA')) {
      final boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 2);
        final data = await image.toByteData(format: ui.ImageByteFormat.png);
        final directory = Directory('build/nepali_qa')
          ..createSync(recursive: true);
        File(
          '${directory.path}/nepali-ui.png',
        ).writeAsBytesSync(data!.buffer.asUint8List());
        image.dispose();
      });
    }
  });
}
