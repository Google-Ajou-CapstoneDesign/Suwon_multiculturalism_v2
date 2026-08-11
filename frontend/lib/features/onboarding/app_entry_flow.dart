import 'package:flutter/material.dart';
import '../../core/user_profile_controller.dart';
import '../../navigation/main_shell.dart';
import 'screens/onboarding_screen.dart';
import 'screens/splash_screen.dart';

enum _EntryStage { splash, onboarding, ready }

/// 앱 진입 오케스트레이션: 스플래시(약 2초) → 온보딩(언어·체류자격·서류) → 메인 셸.
/// MainShell은 처음부터 트리에 마운트해두고 위에 오버레이만 덮는다 — 온보딩이
/// 끝나자마자 별도 전환 애니메이션 없이 바로 이어지고, 탭 상태도 미리 준비된다.
class AppEntryFlow extends StatefulWidget {
  const AppEntryFlow({super.key});

  @override
  State<AppEntryFlow> createState() => _AppEntryFlowState();
}

class _AppEntryFlowState extends State<AppEntryFlow> {
  final _profile = UserProfileController();
  _EntryStage _stage = _EntryStage.splash;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      setState(() => _stage = _EntryStage.onboarding);
    });
  }

  void _finishOnboarding() {
    _profile.completeOnboarding();
    setState(() => _stage = _EntryStage.ready);
  }

  @override
  void dispose() {
    _profile.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UserProfileScope(
      controller: _profile,
      child: Stack(
        children: [
          const MainShell(),
          if (_stage == _EntryStage.onboarding)
            Positioned.fill(child: OnboardingScreen(onFinished: _finishOnboarding)),
          Positioned.fill(
            child: IgnorePointer(
              ignoring: _stage != _EntryStage.splash,
              child: AnimatedOpacity(
                opacity: _stage == _EntryStage.splash ? 1 : 0,
                duration: const Duration(milliseconds: 450),
                child: const SplashScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
