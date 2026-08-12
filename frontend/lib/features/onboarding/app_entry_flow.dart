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
  bool _prepareStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 스플래시 로고를 여기서 미리 캐싱해두고, 그게 끝날 때까지(느린 네트워크
    // 대비 최대 8초) 화면 전환을 미루면 "로고가 아직 안 떠서 흰 박스만 보이는"
    // 문제가 사라진다. 8초 캡은 이미지 요청 자체가 실패(404 등)해도 스플래시에
    // 영원히 갇히지 않도록 하는 안전장치일 뿐이다. didChangeDependencies에서
    // 호출해야 precacheImage가 필요로 하는 상위 InheritedWidget(MediaQuery 등)이
    // 완전히 연결된 상태를 보장할 수 있다.
    if (_prepareStarted) return;
    _prepareStarted = true;
    _prepareAndAdvance();
  }

  Future<void> _prepareAndAdvance() async {
    final minDelay = Future.delayed(const Duration(milliseconds: 2200));
    final logoReady = precacheImage(
      const AssetImage('assets/images/logo.png'),
      context,
    ).timeout(const Duration(milliseconds: 8000), onTimeout: () {});
    await Future.wait([minDelay, logoReady]);
    if (!mounted) return;
    setState(() => _stage = _EntryStage.onboarding);
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
            Positioned.fill(
              child: OnboardingScreen(onFinished: _finishOnboarding),
            ),
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
