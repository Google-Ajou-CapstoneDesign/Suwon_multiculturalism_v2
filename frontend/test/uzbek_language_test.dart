import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';
import 'package:frontend/core/app_language.dart';
import 'package:frontend/core/api_client.dart';
import 'package:frontend/common/widgets/language_sheet.dart';
import 'package:frontend/features/settings/models/settings_strings.dart';
import 'package:frontend/features/encyclopedia/models/encyclopedia_strings.dart';
import 'package:frontend/features/ai_guide/services/chat_api_service.dart';

void main() {
  test('Uzbek has translated labels and interpolated counts', () {
    expect(AppLanguage.uz.name, 'uz');
    expect(AppLanguage.uz.nativeName, 'Oʻzbekcha');
    expect(SettingsStrings.tabTitle.of(AppLanguage.uz), 'Sozlamalar');
    expect(EncyclopediaStrings.itemCount(AppLanguage.uz, 12), contains('12'));
    expect(
      EncyclopediaStrings.itemCount(AppLanguage.uz, 12),
      isNot(contains('items')),
    );
  });

  test('chat sends uz as the API language', () async {
    final client = ApiClient(
      client: MockClient((request) async {
        expect(jsonDecode(request.body)['language'], 'uz');
        return http.Response(
          '{"factAnswer":"Salom","recommendedOrgs":[]}',
          200,
        );
      }),
    );
    addTearDown(client.dispose);
    final chat = ChatApiService(
      tokenProvider: () async => null,
      client: client,
      locationProvider: () async => null,
    );
    final response = await chat.send('Salom', language: AppLanguage.uz);
    expect(response.factAnswer, 'Salom');
  });

  testWidgets('language picker scrolls to Uzbek on a short screen', (
    tester,
  ) async {
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
                onSelect: (lang) => selected = lang,
              ),
              child: const Text('languages'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('languages'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Oʻzbekcha'));
    await tester.tap(find.text('Oʻzbekcha'));
    await tester.pumpAndSettle();
    expect(selected, AppLanguage.uz);
    expect(tester.takeException(), isNull);
  });
}
