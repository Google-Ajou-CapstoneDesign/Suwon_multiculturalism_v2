import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/user_profile_controller.dart';
import 'package:frontend/features/settings/models/bug_report_email.dart';
import 'package:frontend/features/settings/screens/bug_report_screen.dart';

void main() {
  test('email preserves Korean, special characters and line breaks', () {
    const report = BugReportEmail(
      title: '로그인 & 화면 오류',
      description: '버튼 + 클릭\n오류? #100%',
    );
    expect(report.uri.scheme, 'mailto');
    expect(report.uri.path, 'teameqlab@gmail.com');
    expect(report.uri.queryParameters['subject'], report.subject);
    expect(report.uri.queryParameters['body'], report.body);
    expect(report.uri.toString(), contains('%20'));
    expect(report.uri.toString(), isNot(contains('+')));
    expect(report.clipboardText, contains('teameqlab@gmail.com'));
  });

  Future<void> showForm(
    WidgetTester tester,
    Future<bool> Function(Uri) launch,
  ) async {
    final profile = UserProfileController();
    addTearDown(profile.dispose);
    await tester.pumpWidget(
      UserProfileScope(
        controller: profile,
        child: MaterialApp(home: BugReportScreen(openEmail: launch)),
      ),
    );
  }

  testWidgets('blank report cannot open mail app', (tester) async {
    var calls = 0;
    await showForm(tester, (_) async {
      calls++;
      return true;
    });
    await tester.ensureVisible(find.text('메일 앱에서 보내기'));
    await tester.tap(find.text('메일 앱에서 보내기'));
    await tester.pumpAndSettle();
    expect(calls, 0);
    expect(find.text('내용을 입력해주세요.'), findsNWidgets(2));
  });

  testWidgets('failed mail launch retains report and offers copy', (
    tester,
  ) async {
    Uri? launched;
    await showForm(tester, (uri) async {
      launched = uri;
      return false;
    });
    await tester.enterText(find.byType(TextFormField).at(0), '화면 오류');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      '설정에서 버튼을 누르면 멈춥니다.',
    );
    await tester.ensureVisible(find.text('메일 앱에서 보내기'));
    await tester.tap(find.text('메일 앱에서 보내기'));
    await tester.pumpAndSettle();
    expect(launched!.path, BugReportEmail.recipient);
    expect(launched!.queryParameters['body'], '설정에서 버튼을 누르면 멈춥니다.');
    expect(find.textContaining('메일 앱을 열지 못했습니다'), findsOneWidget);
    expect(find.text('설정에서 버튼을 누르면 멈춥니다.'), findsOneWidget);
    expect(find.text('내용 복사'), findsOneWidget);
  });
}
