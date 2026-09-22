import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:frontend/core/app_language.dart';
import 'package:frontend/core/api_client.dart';
import 'package:frontend/common/widgets/language_sheet.dart';
import 'package:frontend/features/settings/models/settings_strings.dart';
import 'package:frontend/features/encyclopedia/models/encyclopedia_strings.dart';
import 'package:frontend/features/ai_guide/services/chat_api_service.dart';

void main() {
  test('Turkish labels and interpolated values', () {
    expect(AppLanguage.tr.name, 'tr');
    expect(AppLanguage.tr.nativeName, 'Türkçe');
    expect(SettingsStrings.tabTitle.of(AppLanguage.tr), 'Ayarlar');
    expect(EncyclopediaStrings.itemCount(AppLanguage.tr, 12), '12 öğe');
  });

  test('chat forwards Turkish language to backend', () async {
    final client = ApiClient(
      client: MockClient((request) async {
        expect(jsonDecode(request.body)['language'], 'tr');
        return http.Response(
          '{"factAnswer":"Merhaba","recommendedOrgs":[]}',
          200,
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
      (await chat.send('Merhaba', language: AppLanguage.tr)).factAnswer,
      'Merhaba',
    );
  });

  testWidgets('Turkish can be selected on a small screen', (tester) async {
    tester.view.physicalSize = const Size(375, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    AppLanguage? selected;
    await tester.pumpWidget(
      MaterialApp(
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
    await tester.ensureVisible(find.text('Türkçe'));
    await tester.tap(find.text('Türkçe'));
    await tester.pumpAndSettle();
    expect(selected, AppLanguage.tr);
    expect(tester.takeException(), isNull);
  });
}
