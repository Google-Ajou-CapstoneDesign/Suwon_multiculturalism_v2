import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/api_client.dart';
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
    tr: "Giriş yap",
    tg: "Ворид шудан",
    fil: "Mag-log in",
    ur: "لاگ ان کریں",
    th: "เข้าสู่ระบบ",
    ky: "Кирүү",
    km: "ចូលគណនី",
    id: "Masuk",
    si: "පිවිසෙන්න",
    bn: "লগ ইন করুন",
    my: "ဝင်ရောက်ပါ",
    mn: "Нэвтрэх",
    lo: "ເຂົ້າສູ່ລະບົບ",
    tet: "Login",
    ne: "लगइन गर्नुहोस्",
    zh: '登录',
    vi: 'Đăng nhập',
    uz: "Kirish",
  );
  static const emailLabel = L10nText(
    ko: '이메일',
    en: 'Email',
    tr: "E-posta",
    tg: "Почтаи электронӣ",
    fil: "Email",
    ur: "ای میل",
    th: "อีเมล",
    ky: "Электрондук почта",
    km: "អ៊ីមែល",
    id: "Email",
    si: "ඊමේල්",
    bn: "ইমেল",
    my: "အီးမေးလ်",
    mn: "И-мэйл",
    lo: "ອີເມວ",
    tet: "Email",
    ne: "इमेल",
    zh: '邮箱',
    vi: 'Email',
    uz: "Elektron pochta",
  );
  static const passwordLabel = L10nText(
    ko: '비밀번호',
    en: 'Password',
    tr: "Şifre",
    tg: "Парол",
    fil: "Password",
    ur: "پاس ورڈ",
    th: "รหัสผ่าน",
    ky: "Сырсөз",
    km: "ពាក្យសម្ងាត់",
    id: "Kata Sandi",
    si: "මුරපදය",
    bn: "পাসওয়ার্ড",
    my: "စကားဝှက်",
    mn: "Нууц үг",
    lo: "ລະຫັດຜ່ານ",
    tet: "Password",
    ne: "पासवर्ड",
    zh: '密码',
    vi: 'Mật khẩu',
    uz: "Parol",
  );
  static const loginLabel = L10nText(
    ko: '로그인',
    en: 'Log in',
    tr: "Giriş yap",
    tg: "Ворид шудан",
    fil: "Mag-log in",
    ur: "لاگ ان کریں",
    th: "เข้าสู่ระบบ",
    ky: "Кирүү",
    km: "ចូលគណនី",
    id: "Masuk",
    si: "පිවිසෙන්න",
    bn: "লগ ইন করুন",
    my: "ဝင်ရောက်ပါ",
    mn: "Нэвтрэх",
    lo: "ເຂົ້າສູ່ລະບົບ",
    tet: "Login",
    ne: "लगइन गर्नुहोस्",
    zh: '登录',
    vi: 'Đăng nhập',
    uz: "Kirish",
  );
  static const googleLabel = L10nText(
    ko: 'Google로 로그인',
    en: 'Log in with Google',
    tr: "Google ile giriş yap",
    tg: "Бо Google ворид шавед",
    fil: "Mag-log in gamit ang Google",
    ur: "گوگل کے ساتھ لاگ ان کریں",
    th: "เข้าสู่ระบบด้วย Google",
    ky: "Google аркылуу кирүү",
    km: "ចូលគណនីជាមួយ Google",
    id: "Masuk dengan Google",
    si: "Google සමඟ පිවිසෙන්න",
    bn: "গুগল দিয়ে লগ ইন করুন",
    my: "Google ဖြင့် ဝင်ရောက်ပါ",
    mn: "Google-ээр нэвтрэх",
    lo: "ເຂົ້າສູ່ລະບົບດ້ວຍ Google",
    tet: "Login ho Google",
    ne: "गुगल मार्फत लगइन गर्नुहोस्",
    zh: '使用Google登录',
    vi: 'Đăng nhập bằng Google',
    uz: "Google orqali kirish",
  );
  static const orDivider = L10nText(
    ko: '또는',
    en: 'or',
    tr: "veya",
    tg: "ё",
    fil: "o",
    ur: "یا",
    th: "หรือ",
    ky: "же",
    km: "ឬ",
    id: "atau",
    si: "හෝ",
    bn: "অথবা",
    my: "သို့မဟုတ်",
    mn: "эсвэл",
    lo: "ຫຼື",
    tet: "ka",
    ne: "वा",
    zh: '或',
    vi: 'hoặc',
    uz: "yoki",
  );
  static const noAccountLabel = L10nText(
    ko: '아직 가입하지 않으셨나요? 회원가입하기',
    en: "Haven't signed up yet? Create an account",
    tr: "Henüz kaydolmadınız mı? Bir hesap oluşturun",
    tg: "Ҳанӯз сабти ном нашудаед? Ҳисоб эҷод кунед",
    fil: "Hindi pa nakarehistro? Gumawa ng account",
    ur: "ابھی تک رجسٹر نہیں ہوئے؟ ایک اکاؤنٹ بنائیں",
    th: "ยังไม่ได้ลงทะเบียนใช่ไหม? สร้างบัญชี",
    ky: "Азырынча каттала элексизби? Аккаунт түзүңүз",
    km: "មិនទាន់ចុះឈ្មោះមែនទេ? បង្កើតគណនី",
    id: "Belum mendaftar? Buat akun",
    si: "තවම ලියාපදිංචි වී නැද්ද? ගිණුමක් සාදන්න",
    bn: "এখনও সাইন আপ করেননি? একটি অ্যাকাউন্ট তৈরি করুন",
    my: "အကောင့်မရှိသေးဘူးလား။ အကောင့်တစ်ခု ဖန်တီးပါ",
    mn: "Бүртгүүлээгүй байна уу? Бүртгэл үүсгэх",
    lo: "ຍັງບໍ່ໄດ້ລົງທະບຽນບໍ? ສ້າງບັນຊີ",
    tet: "Seidauk rejista? Kria konta ida",
    ne: "अझै दर्ता गर्नुभएको छैन? एउटा खाता सिर्जना गर्नुहोस्।",
    zh: '还没有注册？去注册',
    vi: 'Chưa đăng ký? Đăng ký ngay',
    uz: "Hali roʻyxatdan oʻtmaganmisiz? Hisob yaratish",
  );
  static const errorInvalid = L10nText(
    ko: '올바르지 않은 아이디 또는 비밀번호 입니다',
    en: 'Incorrect email or password.',
    tr: "Yanlış e-posta veya şifre.",
    tg: "Почтаи электронӣ ё парол нодуруст аст.",
    fil: "Maling email o password.",
    ur: "غلط ای میل یا پاس ورڈ۔",
    th: "อีเมลหรือรหัสผ่านไม่ถูกต้อง",
    ky: "Туура эмес электрондук почта же сырсөз.",
    km: "អ៊ីមែល ឬពាក្យសម្ងាត់ខុស។",
    id: "Email atau kata sandi salah.",
    si: "වැරදි ඊමේල් හෝ මුරපදය.",
    bn: "ভুল ইমেল বা পাসওয়ার্ড।",
    my: "အီးမေးလ် သို့မဟုတ် စကားဝှက် မှားယွင်းနေပါသည်။",
    mn: "Буруу и-мэйл эсвэл нууц үг.",
    lo: "ອີເມວ ຫຼື ລະຫັດຜ່ານບໍ່ຖືກຕ້ອງ.",
    tet: "Email ka password sala.",
    ne: "गलत इमेल वा पासवर्ड।",
    zh: '账号或密码不正确。',
    vi: 'Tài khoản hoặc mật khẩu không đúng.',
    uz: "Notoʻgʻri elektron pochta yoki parol.",
  );
  static const googleFailed = L10nText(
    ko: 'Google 로그인에 실패했어요. 잠시 후 다시 시도해주세요.',
    en: 'Google sign-in failed. Please try again shortly.',
    tr: "Google ile giriş başarısız oldu. Lütfen kısa süre içinde tekrar deneyin.",
    tg: "Воридшавӣ бо Google ноком шуд. Лутфан, ба қарибӣ дубора кӯшиш кунед.",
    fil:
        "Hindi nagtagumpay ang pag-log in gamit ang Google. Pakisubukang muli sa lalong madaling panahon.",
    ur: "گوگل کے ساتھ لاگ ان ناکام ہو گیا۔ براہ کرم تھوڑی دیر بعد دوبارہ کوشش کریں۔",
    th: "การเข้าสู่ระบบด้วย Google ไม่สำเร็จ กรุณาลองใหม่อีกครั้งในภายหลัง",
    ky: "Google аркылуу кирүү ишке ашкан жок. Сураныч, жакында кайра аракет кылыңыз.",
    km: "ការចូលដោយ Google បរាជ័យ។ សូមព្យាយាមម្ដងទៀតក្នុងពេលឆាប់ៗនេះ។",
    id: "Gagal masuk dengan Google. Silakan coba lagi sebentar lagi.",
    si: "ගූගල් සමඟ පිවිසීම අසාර්ථක විය. කරුණාකර ටික වේලාවකින් නැවත උත්සාහ කරන්න.",
    bn: "গুগল দিয়ে লগইন ব্যর্থ হয়েছে। অনুগ্রহ করে কিছুক্ষণ পর আবার চেষ্টা করুন।",
    my: "Google ဖြင့် ဝင်ရောက်ခြင်း မအောင်မြင်ပါ။ ခဏအကြာတွင် ထပ်မံကြိုးစားပါ။",
    mn: "Google-ээр нэвтрэх амжилтгүй боллоо. Түр хүлээгээд дахин оролдоно уу.",
    lo: "ການເຂົ້າສູ່ລະບົບດ້ວຍ Google ບໍ່ສຳເລັດ. ກະລຸນາລອງໃໝ່ອີກຄັ້ງໃນໄວໆນີ້.",
    tet: "Login ho Google la susesu. Favor ida, koko fali iha tempu badak.",
    ne: "गुगलबाट लगइन असफल भयो। कृपया केही समयपछि फेरि प्रयास गर्नुहोस्।",
    zh: 'Google登录失败，请稍后重试。',
    vi: 'Đăng nhập Google thất bại. Vui lòng thử lại sau.',
    uz: "Google orqali kirish amalga oshmadi. Iltimos, birozdan keyin qayta urinib koʻring.",
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

  Future<void> _applyProfileAfterLogin(
    String uid,
    String? email,
    AppLanguage lang,
  ) async {
    if (!mounted) return;
    // Firebase Auth 로그인 자체는 이미 성공했으니, 아래 백엔드 프로필 조회
    // 결과와 무관하게 uid/email부터 즉시 반영한다 — isSignedIn이 이 조회
    // 성공 여부에 좌우되면, 조회가 실패했을 때(네트워크·백엔드 미기동·
    // Firestore 미설정 등) 로그인 자체가 안 된 것처럼 보이는 문제가 생긴다.
    UserProfileScope.of(
      context,
    ).applyAuthenticatedProfile(uid: uid, email: email);
    try {
      final idToken = await _authService.currentIdToken();
      if (idToken == null) return;
      final profile = await _fetchOrCreateProfile(
        idToken: idToken,
        email: email,
        lang: lang,
      );
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
      // 프로필 조회/생성 실패해도 uid는 이미 반영돼 로그인 상태로 보이니 조용히 넘어간다.
    }
  }

  /// 프로필을 조회하되, 404(Firestore에 users/{uid} 문서가 아직 없는 계정 —
  /// 이 엔드포인트가 생기기 전에 가입했거나 가입 중 PUT이 실패한 경우)면
  /// 최소 정보로 지금 만들어서 다음부터는 정상 조회되게 한다(자가치유).
  Future<Map<String, dynamic>?> _fetchOrCreateProfile({
    required String idToken,
    required String? email,
    required AppLanguage lang,
  }) async {
    try {
      return await _userProfileApi.fetchProfile(idToken: idToken);
    } on ApiException catch (e) {
      if (e.statusCode != 404) rethrow;
      final fallbackName =
          _authService.currentUser?.displayName ??
          email?.split('@').first ??
          '';
      return await _userProfileApi.upsertProfile(
        idToken: idToken,
        name: fallbackName,
        preferredLanguage: lang.code.toLowerCase(),
      );
    }
  }

  Future<void> _login(AppLanguage lang) async {
    setState(() => _loading = true);
    try {
      final credential = await _authService.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
      await _applyProfileAfterLogin(
        credential.user!.uid,
        credential.user!.email,
        lang,
      );
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
      await _applyProfileAfterLogin(
        credential.user!.uid,
        credential.user!.email,
        lang,
      );
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
