import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';
import '../../core/user_profile_controller.dart';
import '../../core/visa_status.dart';
import '../../navigation/main_shell.dart';
import '../auth/screens/signup_form_screen.dart';
import '../auth/services/auth_service.dart';
import '../auth/services/user_profile_api_service.dart';
import 'screens/onboarding_screen.dart';
import 'screens/splash_screen.dart';

enum _EntryStage { splash, onboarding, googleSignupCompletion, ready }

enum _RedirectOutcome { none, existingUser, newGoogleUser }

/// 앱 진입 오케스트레이션: 스플래시(약 2초) → 온보딩(언어·체류자격·사용 설명서) → 메인 셸.
/// MainShell은 처음부터 트리에 마운트해두고 위에 오버레이만 덮는다 — 온보딩이
/// 끝나자마자 별도 전환 애니메이션 없이 바로 이어지고, 탭 상태도 미리 준비된다.
///
/// Google 로그인은 웹에서 signInWithRedirect를 쓰기 때문에(AuthService 참고)
/// 페이지 전체가 갔다가 돌아온다 — 그래서 스플래시 준비 단계에서 항상
/// [AuthService.consumeRedirectResult]를 먼저 확인한다: 기존 회원이면 온보딩을
/// 건너뛰고 바로 메인으로, 신규 Google 가입자면 체류자격·국적·동의만 마저
/// 받는 화면으로 보낸다.
class AppEntryFlow extends StatefulWidget {
  const AppEntryFlow({super.key});

  @override
  State<AppEntryFlow> createState() => _AppEntryFlowState();
}

class _AppEntryFlowState extends State<AppEntryFlow> {
  _EntryStage _stage = _EntryStage.splash;
  bool _prepareStarted = false;
  User? _pendingGoogleUser;

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
      const AssetImage('img/Logo.png'),
      context,
    ).timeout(const Duration(milliseconds: 8000), onTimeout: () {});
    final redirectOutcome = _consumeGoogleRedirect();
    await Future.wait([minDelay, logoReady]);
    final outcome = await redirectOutcome;
    if (!mounted) return;
    setState(() {
      _stage = switch (outcome) {
        _RedirectOutcome.none => _EntryStage.onboarding,
        _RedirectOutcome.existingUser => _EntryStage.ready,
        _RedirectOutcome.newGoogleUser => _EntryStage.googleSignupCompletion,
      };
    });
  }

  Future<_RedirectOutcome> _consumeGoogleRedirect() async {
    try {
      final authService = AuthService();
      final credential = await authService.consumeRedirectResult();
      final user = credential?.user;
      if (user == null) return _RedirectOutcome.none;

      final idToken = await authService.currentIdToken();
      if (idToken == null) return _RedirectOutcome.none;

      Map<String, dynamic>? profile;
      try {
        profile = await UserProfileApiService().fetchProfile(idToken: idToken);
      } catch (_) {
        profile = null; // 프로필 없음(신규) 또는 일시적 조회 실패 — 둘 다 신규로 취급
      }

      if (!mounted) return _RedirectOutcome.none;
      if (profile != null) {
        final visaCode = profile['visaType'] as String?;
        UserProfileScope.of(context).applyAuthenticatedProfile(
          uid: user.uid,
          email: user.email,
          name: profile['name'] as String?,
          visa: VisaStatus.values.where((v) => v.code == visaCode).firstOrNull,
          nationality: profile['nationality'] as String?,
        );
        UserProfileScope.of(context).completeOnboarding();
        return _RedirectOutcome.existingUser;
      }
      _pendingGoogleUser = user;
      return _RedirectOutcome.newGoogleUser;
    } catch (_) {
      return _RedirectOutcome.none;
    }
  }

  void _finishOnboarding() {
    UserProfileScope.of(context).completeOnboarding();
    setState(() => _stage = _EntryStage.ready);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const MainShell(),
        if (_stage == _EntryStage.onboarding)
          Positioned.fill(
            child: OnboardingScreen(onFinished: _finishOnboarding),
          ),
        if (_stage == _EntryStage.googleSignupCompletion)
          Positioned.fill(
            child: SignupFormScreen(
              isGoogleFlow: true,
              initialName: _pendingGoogleUser?.displayName,
              initialEmail: _pendingGoogleUser?.email,
              onGoogleSignupComplete: _finishOnboarding,
            ),
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
    );
  }
}
