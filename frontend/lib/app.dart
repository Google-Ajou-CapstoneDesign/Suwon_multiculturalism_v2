import 'package:flutter/material.dart';
import 'common/widgets/web_centered_frame.dart';
import 'navigation/main_shell.dart';
import 'theme/app_theme.dart';

/// TODO(backend): Firebase 초기화 후 AuthGate를 앞단에 추가해
/// 로그인 상태에 따라 Onboarding ↔ MainShell 분기.
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
      home: const MainShell(),
    );
  }
}
