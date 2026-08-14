import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../core/visa_status.dart';
import '../../../theme/app_colors.dart';
import '../models/country.dart';
import '../models/signup_draft.dart';
import '../services/auth_service.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/country_sheet.dart';
import '../widgets/google_signin_button.dart';
import 'consent_screen.dart';

class _S {
  _S._();

  static const title = L10nText(
    ko: '회원가입',
    en: 'Sign up',
    zh: '注册',
    vi: 'Đăng ký',
  );
  static const googleLabel = L10nText(
    ko: 'Google로 계속 가입하기',
    en: 'Continue signing up with Google',
    zh: '使用Google继续注册',
    vi: 'Tiếp tục đăng ký bằng Google',
  );
  static const googleDoneLabel = L10nText(
    ko: 'Google 계정으로 연결됨',
    en: 'Connected with your Google account',
    zh: '已通过Google账号连接',
    vi: 'Đã liên kết bằng tài khoản Google',
  );
  static const orDivider = L10nText(
    ko: '또는 이메일로 가입',
    en: 'Or sign up with email',
    zh: '或使用邮箱注册',
    vi: 'Hoặc đăng ký bằng email',
  );
  static const nameLabel = L10nText(
    ko: '성명',
    en: 'Full name',
    zh: '姓名',
    vi: 'Họ tên',
  );
  static const emailLabel = L10nText(
    ko: '이메일 (아이디)',
    en: 'Email (ID)',
    zh: '邮箱（账号）',
    vi: 'Email (tài khoản)',
  );
  static const passwordLabel = L10nText(
    ko: '비밀번호',
    en: 'Password',
    zh: '密码',
    vi: 'Mật khẩu',
  );
  static const passwordConfirmLabel = L10nText(
    ko: '비밀번호 확인',
    en: 'Confirm password',
    zh: '确认密码',
    vi: 'Xác nhận mật khẩu',
  );
  static const visaLabel = L10nText(
    ko: '체류자격(비자)',
    en: 'Visa status',
    zh: '居留资格（签证）',
    vi: 'Tư cách lưu trú (visa)',
  );
  static const customVisaPlaceholder = L10nText(
    ko: '체류자격을 직접 입력해주세요',
    en: 'Enter your visa status',
    zh: '请输入居留资格',
    vi: 'Nhập tư cách lưu trú của bạn',
  );
  static const nationalityLabel = L10nText(
    ko: '국적',
    en: 'Nationality',
    zh: '国籍',
    vi: 'Quốc tịch',
  );
  static const nationalityPlaceholder = L10nText(
    ko: '국적을 선택해주세요',
    en: 'Select your nationality',
    zh: '请选择国籍',
    vi: 'Chọn quốc tịch của bạn',
  );
  static const nextLabel = L10nText(
    ko: '다음',
    en: 'Next',
    zh: '下一步',
    vi: 'Tiếp theo',
  );

  static const errorName = L10nText(
    ko: '성명을 입력해주세요',
    en: 'Please enter your name',
    zh: '请输入姓名',
    vi: 'Vui lòng nhập họ tên',
  );
  static const errorEmail = L10nText(
    ko: '올바른 이메일을 입력해주세요',
    en: 'Please enter a valid email',
    zh: '请输入有效的邮箱地址',
    vi: 'Vui lòng nhập email hợp lệ',
  );
  static const errorPassword = L10nText(
    ko: '비밀번호는 6자 이상이어야 해요',
    en: 'Password must be at least 6 characters',
    zh: '密码至少需要6位',
    vi: 'Mật khẩu phải có ít nhất 6 ký tự',
  );
  static const errorPasswordMismatch = L10nText(
    ko: '비밀번호가 일치하지 않아요',
    en: 'Passwords do not match',
    zh: '两次输入的密码不一致',
    vi: 'Mật khẩu không khớp',
  );
  static const errorCustomVisa = L10nText(
    ko: '체류자격을 입력해주세요',
    en: 'Please enter your visa status',
    zh: '请输入居留资格',
    vi: 'Vui lòng nhập tư cách lưu trú',
  );
  static const errorCountry = L10nText(
    ko: '국적을 선택해주세요',
    en: 'Please select your nationality',
    zh: '请选择国籍',
    vi: 'Vui lòng chọn quốc tịch',
  );
  static const googleFailed = L10nText(
    ko: 'Google 로그인에 실패했어요. 잠시 후 다시 시도해주세요.',
    en: 'Google sign-in failed. Please try again shortly.',
    zh: 'Google登录失败，请稍后重试。',
    vi: 'Đăng nhập Google thất bại. Vui lòng thử lại sau.',
  );
}

class SignupFormScreen extends StatefulWidget {
  const SignupFormScreen({
    super.key,
    this.isGoogleFlow = false,
    this.initialName,
    this.initialEmail,
    this.onGoogleSignupComplete,
  });

  /// true면 이미 Google로 인증된 상태에서 진입한 것 — 이메일/비밀번호 필드를
  /// 숨기고 성명·이메일을 미리 채운다(AppEntryFlow가 리다이렉트 복귀 후
  /// 새 사용자를 여기로 바로 보낼 때 씀).
  final bool isGoogleFlow;
  final String? initialName;
  final String? initialEmail;

  /// isGoogleFlow일 때만 쓰인다 — 이 화면이 Navigator.push로 들어온 게 아니라
  /// AppEntryFlow가 오버레이로 직접 띄운 것이라 pop 대신 콜백으로 완료를 알린다.
  final VoidCallback? onGoogleSignupComplete;

  @override
  State<SignupFormScreen> createState() => _SignupFormScreenState();
}

class _SignupFormScreenState extends State<SignupFormScreen> {
  final _authService = AuthService();
  late final _nameController = TextEditingController(
    text: widget.initialName ?? '',
  );
  late final _emailController = TextEditingController(
    text: widget.initialEmail ?? '',
  );
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _customVisaController = TextEditingController();

  VisaStatus _visa = VisaStatus.e9;
  Country? _country;
  late bool _isGoogleFlow = widget.isGoogleFlow;
  bool _googleLoading = false;

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _passwordConfirmError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _customVisaController.dispose();
    super.dispose();
  }

  /// 웹에서는 signInWithRedirect라 페이지가 곧 이동한다 — 여기서 결과를
  /// 기다리지 않는다(돌아온 뒤엔 AppEntryFlow가 이어서 처리한다).
  Future<void> _continueWithGoogle(AppLanguage lang) async {
    setState(() => _googleLoading = true);
    try {
      final credential = await _authService.signInWithGoogle();
      if (credential == null) return; // 웹: 리다이렉트로 페이지 이동. 모바일: 사용자가 취소함.
      final user = credential.user;
      setState(() {
        _isGoogleFlow = true;
        _nameController.text = user?.displayName ?? _nameController.text;
        _emailController.text = user?.email ?? _emailController.text;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_S.googleFailed.of(lang))));
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  bool _validate(AppLanguage lang) {
    setState(() {
      _nameError = _nameController.text.trim().isEmpty
          ? _S.errorName.of(lang)
          : null;
      _emailError = _emailController.text.trim().contains('@')
          ? null
          : _S.errorEmail.of(lang);
      if (!_isGoogleFlow) {
        _passwordError = _passwordController.text.length < 6
            ? _S.errorPassword.of(lang)
            : null;
        _passwordConfirmError =
            _passwordController.text != _passwordConfirmController.text
            ? _S.errorPasswordMismatch.of(lang)
            : null;
      } else {
        _passwordError = null;
        _passwordConfirmError = null;
      }
    });
    if (_nameError != null ||
        _emailError != null ||
        _passwordError != null ||
        _passwordConfirmError != null) {
      return false;
    }
    if (_visa == VisaStatus.etc && _customVisaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_S.errorCustomVisa.of(lang))));
      return false;
    }
    if (_country == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_S.errorCountry.of(lang))));
      return false;
    }
    return true;
  }

  void _next(AppLanguage lang) {
    if (!_validate(lang)) return;
    final draft = SignupDraft(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _isGoogleFlow ? null : _passwordController.text,
      isGoogleFlow: _isGoogleFlow,
      visa: _visa,
      customVisaText: _visa == VisaStatus.etc
          ? _customVisaController.text.trim()
          : null,
      countryCode: _country!.code,
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ConsentScreen(
          draft: draft,
          onComplete: widget.onGoogleSignupComplete,
        ),
      ),
    );
  }

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
            if (_isGoogleFlow)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.blueBg,
                  border: Border.all(color: AppColors.blueBorder),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _S.googleDoneLabel.of(lang),
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              GoogleSignInButton(
                label: _S.googleLabel,
                language: lang,
                onPressed: _googleLoading
                    ? () {}
                    : () => _continueWithGoogle(lang),
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
            ],
            AuthTextField(
              label: _S.nameLabel.of(lang),
              controller: _nameController,
              errorText: _nameError,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              label: _S.emailLabel.of(lang),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              errorText: _emailError,
            ),
            if (!_isGoogleFlow) ...[
              const SizedBox(height: 12),
              AuthTextField(
                label: _S.passwordLabel.of(lang),
                controller: _passwordController,
                obscureText: true,
                errorText: _passwordError,
              ),
              const SizedBox(height: 12),
              AuthTextField(
                label: _S.passwordConfirmLabel.of(lang),
                controller: _passwordConfirmController,
                obscureText: true,
                errorText: _passwordConfirmError,
              ),
            ],
            const SizedBox(height: 18),
            Text(
              _S.visaLabel.of(lang),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: VisaStatus.values.map((visa) {
                final selected = _visa == visa;
                return ChoiceChip(
                  label: Text(
                    visa.fullLabel,
                    style: const TextStyle(fontSize: 12),
                  ),
                  selected: selected,
                  onSelected: (_) => setState(() => _visa = visa),
                  selectedColor: AppColors.blueBg,
                  labelStyle: TextStyle(
                    color: selected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  ),
                  side: BorderSide(
                    color: selected ? AppColors.primary : AppColors.border,
                  ),
                );
              }).toList(),
            ),
            if (_visa == VisaStatus.etc) ...[
              const SizedBox(height: 10),
              AuthTextField(
                label: _S.customVisaPlaceholder.of(lang),
                controller: _customVisaController,
              ),
            ],
            const SizedBox(height: 18),
            Text(
              _S.nationalityLabel.of(lang),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => showCountrySheet(
                context,
                language: lang,
                current: _country?.code,
                onSelect: (c) => setState(() => _country = c),
              ),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBFDFF),
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _country?.name.of(lang) ??
                            _S.nationalityPlaceholder.of(lang),
                        style: TextStyle(
                          fontSize: 13.5,
                          color: _country == null
                              ? AppColors.textMuted
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const Icon(Icons.expand_more, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _next(lang),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                child: Text(
                  _S.nextLabel.of(lang),
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
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
