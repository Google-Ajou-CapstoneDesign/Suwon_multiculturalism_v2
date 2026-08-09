import 'package:flutter/material.dart';
import 'common/widgets/web_centered_frame.dart';
import 'features/onboarding/app_entry_flow.dart';
import 'theme/app_theme.dart';

/// TODO(backend): Firebase 초기화 후 로그인 상태를 온보딩 완료 여부와 함께 확인해야 한다.
/// 지금은 매 실행마다 스플래시→온보딩을 다시 보여준다(세션 재시작 시 초기화).
class LocalBridgeApp extends StatelessWidget {
  const LocalBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Bridge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // 웹처럼 뷰포트가 넓을 때 모바일 UI를 가운데 정렬해 보여준다.
      builder: (context, child) => WebCenteredFrame(child: child ?? const SizedBox.shrink()),
      home: const AppEntryFlow(),
    );
  }
}
