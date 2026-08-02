import 'package:flutter/material.dart';
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
      home: const MainShell(),
    );
  }
}
