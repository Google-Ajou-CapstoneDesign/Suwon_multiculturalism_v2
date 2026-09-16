import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/common/models/org.dart';
import 'package:frontend/core/app_language.dart';
import 'package:frontend/features/ai_guide/widgets/recommended_org_card.dart';

void main() {
  testWidgets('top two show details in order side by side', (tester) async {
    final first = Org.fromJson({
      'name': '기관 A',
      'address': '수원시 주소',
      'phoneNumber': '031-123-4567',
      'businessHours': '평일 09:00~18:00',
      'distanceKm': 12.3,
    });
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RecommendedOrgCard(
            orgs: [
              first,
              const Org(name: '기관 B', distanceKm: null),
              const Org(name: '기관 C', distanceKm: 1),
            ],
            language: AppLanguage.ko,
          ),
        ),
      ),
    );
    expect(find.text('수원시 주소'), findsOneWidget);
    expect(find.text('031-123-4567'), findsOneWidget);
    expect(find.text('평일 09:00~18:00'), findsOneWidget);
    expect(find.text('12.3km'), findsOneWidget);
    expect(find.text('거리 정보 없음'), findsOneWidget);
    expect(find.text('정보 없음'), findsNWidgets(3));
    expect(find.text('3. 기관 C'), findsNothing);
    final a = tester.getTopLeft(find.text('1. 기관 A'));
    final b = tester.getTopLeft(find.text('2. 기관 B'));
    expect(a.dy, b.dy);
    expect(a.dx, lessThan(b.dx));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'narrow screen shows equal-width cards without horizontal scrolling',
    (tester) async {
      tester.view.physicalSize = const Size(320, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
            child: Scaffold(
              body: SingleChildScrollView(
                child: RecommendedOrgCard(
                  orgs: const [
                    Org(name: '긴 이름의 외국인 상담 지원 기관', distanceKm: 3),
                    Org(name: '두 번째 기관', distanceKm: 4),
                  ],
                  language: AppLanguage.ko,
                ),
              ),
            ),
          ),
        ),
      );
      final scroller = find.byWidgetPredicate(
        (w) =>
            w is SingleChildScrollView && w.scrollDirection == Axis.horizontal,
      );
      expect(scroller, findsNothing);
      final first = tester.getRect(
        find.byKey(const ValueKey('recommended-org-1')),
      );
      final second = tester.getRect(
        find.byKey(const ValueKey('recommended-org-2')),
      );
      expect(first.width, second.width);
      expect(first.top, second.top);
      expect(first.left, greaterThanOrEqualTo(0));
      expect(second.right, lessThanOrEqualTo(320));
      expect(tester.takeException(), isNull);
      expect(find.text('2. 두 번째 기관').hitTestable(), findsOneWidget);
    },
  );
}
