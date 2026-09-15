import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:frontend/core/api_client.dart';
import 'package:frontend/core/app_language.dart';
import 'package:frontend/core/user_profile_controller.dart';
import 'package:frontend/features/ai_guide/models/chat_message.dart';
import 'package:frontend/features/ai_guide/screens/chat_screen.dart';
import 'package:frontend/features/ai_guide/services/chat_api_service.dart';

void main() {
  test(
    'chat sends auth token and keeps history within the input budget',
    () async {
      final client = ApiClient(
        client: MockClient((request) async {
          expect(request.headers['authorization'], 'Bearer test-token');
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          final history = body['history'] as List;
          expect(history.length, lessThanOrEqualTo(6));
          final size = history.fold<int>(
            (body['message'] as String).runes.length,
            (sum, turn) => sum + (turn['text'] as String).runes.length,
          );
          expect(size, lessThanOrEqualTo(12000));
          expect(history.last['text'], 'latest');
          return http.Response('{"factAnswer":"ok"}', 200);
        }),
      );
      addTearDown(client.dispose);
      await ChatApiService(
        client: client,
        locationProvider: () async => null,
        tokenProvider: () async => 'test-token',
      ).send(
        'hello',
        language: AppLanguage.en,
        history: [
          ...List.generate(8, (_) => ChatMessage.user('a' * 3000)),
          ChatMessage.user('latest'),
        ],
      );
    },
  );

  testWidgets('429 preserves input and enables sending after countdown', (
    tester,
  ) async {
    final profile = UserProfileController();
    addTearDown(profile.dispose);
    var calls = 0;
    final client = ApiClient(
      client: MockClient((request) async {
        calls++;
        return http.Response(
          jsonEncode({
            'detail': {
              'code': 'chat_rate_limited',
              'reason': 'cooldown',
              'retryAfterSeconds': 2,
            },
          }),
          429,
        );
      }),
    );
    addTearDown(client.dispose);
    final service = ChatApiService(
      client: client,
      locationProvider: () async => null,
      tokenProvider: () async => null,
    );
    await tester.pumpWidget(
      UserProfileScope(
        controller: profile,
        child: MaterialApp(home: ChatScreen(chatApi: service)),
      ),
    );
    await tester.enterText(find.byType(TextField), '임금 질문');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();
    await tester.pump();
    expect(calls, 1);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      '임금 질문',
    );
    expect(find.text('2초 후 다시 전송할 수 있어요.'), findsOneWidget);
    final send = find.ancestor(
      of: find.byIcon(Icons.send),
      matching: find.byType(IconButton),
    );
    expect(tester.widget<IconButton>(send).onPressed, isNull);
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(seconds: 2)),
    );
    await tester.pump(const Duration(seconds: 2));
    expect(tester.widget<IconButton>(send).onPressed, isNotNull);
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();
    await tester.pump();
    expect(calls, 2);
    expect(tester.widget<IconButton>(send).onPressed, isNull);
    profile.applyAuthenticatedProfile(
      uid: 'new-user',
      email: 'test@example.com',
    );
    await tester.pump();
    expect(tester.widget<IconButton>(send).onPressed, isNotNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
