import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';
import '../models/signup_draft.dart';
import '../services/auth_service.dart';
import '../services/user_profile_api_service.dart';

class _S {
  _S._();

  static const title = L10nText(
    ko: '개인정보 처리방침 동의',
    en: 'Privacy Policy Agreement',
    zh: '同意隐私政策',
    vi: 'Đồng ý chính sách bảo mật',
  );
  static const heading = L10nText(
    ko: 'Local Bridge가 수집하는 정보',
    en: 'Information Local Bridge collects',
    zh: 'Local Bridge收集的信息',
    vi: 'Thông tin Local Bridge thu thập',
  );
  // 수집 항목·보관 기간 안내. docs/firestore_스키마.md의 users 컬렉션 필드와
  // 일치시켰다 — 실제로 저장하지 않는 항목(비밀번호 등)을 여기 적으면 안 된다.
  static const body = L10nText(
    ko:
        '회원가입 시 성명, 이메일, 체류자격, 국적, 선호 언어를 수집합니다. '
        '비밀번호는 Firebase Authentication이 암호화해 별도로 안전하게 보관하며, '
        'Local Bridge 서버에는 저장되지 않습니다.\n\n'
        '수집한 정보는 맞춤형 노동 상담·서식 자동 작성 등 서비스 제공 목적으로만 사용하며, '
        '회원 탈퇴 또는 삭제 요청 시까지 보관한 뒤 지체 없이 파기합니다. '
        '동의를 거부할 수 있으나, 이 경우 회원가입이 제한됩니다.',
    en:
        'When you sign up, we collect your name, email, visa status, nationality, and preferred language. '
        'Your password is encrypted and securely stored by Firebase Authentication only — it is never stored on Local Bridge servers.\n\n'
        'Collected information is used only to provide the service (personalized labor guidance, auto-filled forms, etc.) and is retained '
        'until you withdraw your account or request deletion, after which it is destroyed without delay. You may decline consent, but '
        'signing up will not be possible without it.',
    zh:
        '注册时我们会收集您的姓名、邮箱、居留资格、国籍和首选语言。'
        '密码由Firebase Authentication加密安全保管，不会存储在Local Bridge服务器上。\n\n'
        '所收集的信息仅用于提供服务（个性化劳动咨询、自动填写表格等），'
        '将保留至您注销账号或申请删除为止，之后将被立即销毁。您可以拒绝同意，但拒绝将导致无法完成注册。',
    vi:
        'Khi đăng ký, chúng tôi thu thập họ tên, email, tư cách lưu trú, quốc tịch và ngôn ngữ ưa thích của bạn. '
        'Mật khẩu được Firebase Authentication mã hóa và lưu trữ an toàn riêng — không bao giờ được lưu trên máy chủ Local Bridge.\n\n'
        'Thông tin thu thập được chỉ dùng để cung cấp dịch vụ (tư vấn lao động cá nhân hóa, tự động điền biểu mẫu, v.v.) và được lưu giữ '
        'cho đến khi bạn hủy tài khoản hoặc yêu cầu xóa, sau đó sẽ bị hủy ngay lập tức. Bạn có thể từ chối đồng ý, nhưng khi đó sẽ không thể đăng ký.',
  );
  static const agreeLabel = L10nText(
    ko: '위 내용을 확인했으며 개인정보 수집·이용에 동의합니다 (필수)',
    en: 'I have read the above and agree to the collection and use of my personal information (required)',
    zh: '我已阅读以上内容并同意收集和使用我的个人信息（必填）',
    vi: 'Tôi đã đọc nội dung trên và đồng ý việc thu thập, sử dụng thông tin cá nhân (bắt buộc)',
  );
  static const submitLabel = L10nText(
    ko: '가입 완료',
    en: 'Complete sign-up',
    zh: '完成注册',
    vi: 'Hoàn tất đăng ký',
  );
  static const errorConsentRequired = L10nText(
    ko: '동의해야 가입을 완료할 수 있어요',
    en: 'You must agree to continue',
    zh: '需要同意才能完成注册',
    vi: 'Bạn cần đồng ý để hoàn tất đăng ký',
  );
  static String errorFor(FirebaseAuthException e, AppLanguage lang) {
    switch (e.code) {
      case 'email-already-in-use':
        return switch (lang) {
          AppLanguage.ko => '이미 가입된 이메일이에요. 로그인해 주세요.',
          AppLanguage.en =>
            'This email is already registered. Please log in instead.',
          AppLanguage.zh => '该邮箱已注册，请登录。',
          AppLanguage.vi => 'Email này đã được đăng ký. Vui lòng đăng nhập.',
        };
      case 'invalid-email':
        return switch (lang) {
          AppLanguage.ko => '이메일 형식이 올바르지 않아요.',
          AppLanguage.en => 'The email format is invalid.',
          AppLanguage.zh => '邮箱格式不正确。',
          AppLanguage.vi => 'Định dạng email không hợp lệ.',
        };
      case 'weak-password':
        return switch (lang) {
          AppLanguage.ko => '비밀번호가 너무 간단해요.',
          AppLanguage.en => 'The password is too weak.',
          AppLanguage.zh => '密码强度太弱。',
          AppLanguage.vi => 'Mật khẩu quá yếu.',
        };
      default:
        return switch (lang) {
          AppLanguage.ko => '가입 중 문제가 생겼어요. 잠시 후 다시 시도해주세요.',
          AppLanguage.en =>
            'Something went wrong while signing up. Please try again shortly.',
          AppLanguage.zh => '注册过程中出现问题，请稍后重试。',
          AppLanguage.vi =>
            'Đã xảy ra sự cố khi đăng ký. Vui lòng thử lại sau.',
        };
    }
  }
}

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key, required this.draft, this.onComplete});

  final SignupDraft draft;

  /// SignupFormScreen이 AppEntryFlow의 오버레이로(Navigator.push 없이) 진입한
  /// 경우에만 채워진다 — pop 대신 이 콜백으로 완료를 알린다.
  final VoidCallback? onComplete;

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  final _authService = AuthService();
  final _userProfileApi = UserProfileApiService();
  bool _agreed = false;
  bool _submitting = false;

  Future<void> _submit(AppLanguage lang) async {
    if (!_agreed) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_S.errorConsentRequired.of(lang))));
      return;
    }
    setState(() => _submitting = true);
    try {
      final draft = widget.draft;
      String uid;
      String? email;
      if (draft.isGoogleFlow) {
        final user = _authService.currentUser;
        uid = user!.uid;
        email = user.email;
      } else {
        final credential = await _authService.signUpWithEmail(
          draft.email,
          draft.password!,
        );
        await _authService.updateDisplayName(draft.name);
        uid = credential.user!.uid;
        email = credential.user!.email;
      }

      final idToken = await _authService.currentIdToken();
      await _userProfileApi.upsertProfile(
        idToken: idToken!,
        name: draft.name,
        visaType: draft.visaTypeValue,
        nationality: draft.countryCode,
        preferredLanguage: lang.code.toLowerCase(),
      );

      if (!mounted) return;
      UserProfileScope.of(context).applyAuthenticatedProfile(
        uid: uid,
        email: email,
        name: draft.name,
        visa: draft.visa,
        nationality: draft.countryCode,
      );
      if (widget.onComplete != null) {
        widget.onComplete!();
      } else {
        // 회원가입 폼 + 동의 화면 둘 다 닫고 온보딩(체류자격 화면)으로 복귀.
        Navigator.of(context)
          ..pop()
          ..pop();
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_S.errorFor(e, lang))));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(switch (lang) {
            AppLanguage.ko => '가입 중 문제가 생겼어요. 잠시 후 다시 시도해주세요.',
            AppLanguage.en =>
              'Something went wrong while signing up. Please try again shortly.',
            AppLanguage.zh => '注册过程中出现问题，请稍后重试。',
            AppLanguage.vi =>
              'Đã xảy ra sự cố khi đăng ký. Vui lòng thử lại sau.',
          }),
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
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
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  Text(
                    _S.heading.of(lang),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _S.body.of(lang),
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                        height: 1.7,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => setState(() => _agreed = !_agreed),
                    borderRadius: BorderRadius.circular(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _agreed,
                          onChanged: (v) =>
                              setState(() => _agreed = v ?? false),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 13),
                            child: Text(
                              _S.agreeLabel.of(lang),
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitting ? null : () => _submit(lang),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _S.submitLabel.of(lang),
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
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
