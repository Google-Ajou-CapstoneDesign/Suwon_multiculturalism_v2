import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../core/visa_status.dart';
import '../../../theme/app_colors.dart';
import '../services/auth_service.dart';
import '../services/user_profile_api_service.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/google_signin_button.dart';
import 'signup_form_screen.dart';

class _S {
  _S._();

  static const title = L10nText(
    ko: '로그인',
    en: 'Log in',
    zh: '登录',
    vi: 'Đăng nhập',
  );
  static const emailLabel = L10nText(
    ko: '이메일',
    en: 'Email',
    zh: '邮箱',
    vi: 'Email',
  );
  static const passwordLabel = L10nText(
    ko: '비밀번호',
    en: 'Password',
    zh: '密码',
    vi: 'Mật khẩu',
  );
  static const loginLabel = L10nText(
    ko: '로그인',
    en: 'Log in',
    zh: '登录',
    vi: 'Đăng nhập',
  );
  static const googleLabel = L10nText(
    ko: 'Google로 로그인',
    en: 'Log in with Google',
    zh: '使用Google登录',
    vi: 'Đăng nhập bằng Google',
  );
  static const orDivider = L10nText(ko: '또는', en: 'or', zh: '或', vi: 'hoặc');
  static const noAccountLabel = L10nText(
    ko: '아직 가입하지 않으셨나요? 회원가입하기',
    en: "Haven't signed up yet? Create an account",
    zh: '还没有注册？去注册',
    vi: 'Chưa đăng ký? Đăng ký ngay',
  );
  static const errorInvalid = L10nText(
    ko: '이메일 또는 비밀번호가 올바르지 않아요.',
    en: 'Incorrect email or password.',
    zh: '邮箱或密码不正确。',
    vi: 'Email hoặc mật khẩu không đúng.',
  );
  static const googleFailed = L10nText(
    ko: 'Google 로그인에 실패했어요. 잠시 후 다시 시도해주세요.',
    en: 'Google sign-in failed. Please try again shortly.',
    zh: 'Google登录失败，请稍后重试。',
    vi: 'Đăng nhập Google thất bại. Vui lòng thử lại sau.',
  );
}

/// 이메일/비밀번호 + Google 로그인 폼 본체. 독립 화면([LoginScreen])과
/// 온보딩 단계([_VisaStep]) 양쪽에서 그대로 재사용한다 — 로그인 성공 시
/// [onSuccess]를 호출할 뿐, 화면 전환(pop 또는 다음 단계 이동)은 호출부가 정한다.
class LoginFormBody extends StatefulWidget {
  const LoginFormBody({super.key, required this.onSuccess});

  final VoidCallback onSuccess;

  @override
  State<LoginFormBody> createState() => _LoginFormBodyState();
}

class _LoginFormBodyState extends State<LoginFormBody> {
  final _authService = AuthService();
  final _userProfileApi = UserProfileApiService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _applyProfileAfterLogin(String uid, String? email) async {
    try {
      final idToken = await _authService.currentIdToken();
      if (idToken == null) return;
      final profile = await _userProfileApi.fetchProfile(idToken: idToken);
      if (!mounted) return;
      final visaCode = profile?['visaType'] as String?;
      final visa = VisaStatus.values
          .where((v) => v.code == visaCode)
          .firstOrNull;
      UserProfileScope.of(context).applyAuthenticatedProfile(
        uid: uid,
        email: email,
        name: profile?['name'] as String?,
        visa: visa,
        nationality: profile?['nationality'] as String?,
      );
    } catch (_) {
      // 프로필 조회 실패해도 로그인 자체는 성공한 상태이므로 조용히 넘어간다.
    }
  }

  Future<void> _login(AppLanguage lang) async {
    setState(() => _loading = true);
    try {
      final credential = await _authService.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
      await _applyProfileAfterLogin(credential.user!.uid, credential.user!.email);
      if (!mounted) return;
      widget.onSuccess();
    } on FirebaseAuthException catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_S.errorInvalid.of(lang))));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loginWithGoogle(AppLanguage lang) async {
    setState(() => _loading = true);
    try {
      final credential = await _authService.signInWithGoogle();
      if (credential == null) return; // 취소 또는 웹 리다이렉트로 페이지 이동
      await _applyProfileAfterLogin(credential.user!.uid, credential.user!.email);
      if (!mounted) return;
      widget.onSuccess();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_S.googleFailed.of(lang))));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = UserProfileScope.of(context).language;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          label: _S.emailLabel.of(lang),
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        AuthTextField(
          label: _S.passwordLabel.of(lang),
          controller: _passwordController,
          obscureText: true,
        ),
        const SizedBox(height: 18),
        ElevatedButton(
          onPressed: _loading ? null : () => _login(lang),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11),
            ),
          ),
          child: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  _S.loginLabel.of(lang),
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                _S.orDivider.of(lang),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        GoogleSignInButton(
          label: _S.googleLabel,
          language: lang,
          onPressed: _loading ? () {} : () => _loginWithGoogle(lang),
        ),
      ],
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = UserProfileScope.of(context).language;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_S.title.of(lang)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            LoginFormBody(onSuccess: () => Navigator.of(context).pop()),
            const SizedBox(height: 22),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SignupFormScreen()),
                ),
                child: Text(
                  _S.noAccountLabel.of(lang),
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
