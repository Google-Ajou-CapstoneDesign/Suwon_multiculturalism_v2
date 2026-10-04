import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
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
import 'package:frontend/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Tetum labels and interpolated values', () {
    expect(AppLanguage.tet.name, 'tet');
    expect(AppLanguage.tet.nativeName, 'Tetun');
    expect(SettingsStrings.tabTitle.of(AppLanguage.tet), 'Definisaun');
    expect(EncyclopediaStrings.itemCount(AppLanguage.tet, 12), contains('12'));
  });

  test('chat forwards Tetum language code', () async {
    final client = ApiClient(
      client: MockClient((request) async {
        expect(jsonDecode(request.body)['language'], 'tet');
        return http.Response.bytes(
          utf8.encode(
            jsonEncode({'factAnswer': 'Bondia', 'recommendedOrgs': []}),
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
      (await chat.send('Bondia', language: AppLanguage.tet)).factAnswer,
      'Bondia',
    );
  });

  testWidgets('Tetum is selectable on a small language sheet', (tester) async {
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
    await tester.ensureVisible(find.text('Tetun'));
    await tester.tap(find.text('Tetun'));
    await tester.pumpAndSettle();
    expect(selected, AppLanguage.tet);
    expect(tester.takeException(), isNull);
  });

  test('Tetum complaint PDF renders accents and filled values', () async {
    const title = L10nText(
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
    final values = FormValuesController()
      ..setValue('memo', "Ha'u seidauk simu saláriu. Ita bele ajuda ha'u?");
    addTearDown(values.dispose);
    final bytes = await buildComplaintPdf(
      documentTitle: title,
      sections: const [
        FormSection(
          title: title,
          fields: [
            FormFieldSpec(
              key: 'memo',
              label: title,
              type: FormFieldType.textarea,
              tag: FillTag.raw,
            ),
          ],
        ),
      ],
      values: values,
      lang: AppLanguage.tet,
      format: PdfPageFormat.a4,
    );
    expect(ascii.decode(bytes.take(5).toList()), '%PDF-');
    if (const bool.fromEnvironment('NEPALI_QA')) {
      final directory = Directory('build/nepali_qa')
        ..createSync(recursive: true);
      File('${directory.path}/complaint-tet.pdf').writeAsBytesSync(bytes);
    }
  });
}
