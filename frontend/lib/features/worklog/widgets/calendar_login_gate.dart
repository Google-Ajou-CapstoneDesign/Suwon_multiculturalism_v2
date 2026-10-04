import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';
import '../../auth/screens/login_screen.dart';
import '../../auth/screens/signup_form_screen.dart';

/// 캘린더(근무기록장) 진입 게이트 문구. 온보딩에 있던 로그인 단계를 그대로
/// 옮겨왔다 — 이 앱에서 로그인이 실제로 필요한 탭은 캘린더뿐이라, 앱을 열자마자
/// 로그인부터 강제하는 대신 캘린더를 켤 때만 물어보고 데모로도 계속 이용할 수
/// 있게 한다.
class _S {
  _S._();

  static const title = L10nText(
    ko: '로그인하고 근무기록을 저장하세요',
    en: 'Log in to save your work log',
    tr: "Çalışma günlüğünüzü kaydetmek için giriş yapın",
    tg: "Барои захира кардани рӯзномаи кории худ ворид шавед",
    fil: "Mag-log in para i-save ang iyong work log",
    ur: "اپنا ورک لاگ محفوظ کرنے کے لیے لاگ ان کریں",
    th: "เข้าสู่ระบบเพื่อบันทึกบันทึกการทำงานของคุณ",
    ky: "Жумуш журналыңызды сактоо үчүн кириңиз",
    km: "ចូលគណនីដើម្បីរក្សាទុកកំណត់ហេតុការងាររបស់អ្នក",
    id: "Masuk untuk menyimpan catatan kerja Anda",
    si: "ඔබගේ වැඩ සටහන සුරැකීමට පුරන්න",
    bn: "আপনার কাজের লগ রেকর্ড করতে লগইন করুন",
    my: "သင်၏အလုပ်မှတ်တမ်းကို သိမ်းဆည်းရန် လော့ဂ်အင်ဝင်ပါ",
    mn: "Ажлын тэмдэглэлээ хадгалахын тулд нэвтэрнэ үү",
    lo: "ເຂົ້າສູ່ລະບົບເພື່ອບັນທຶກບັນທຶກການເຮັດວຽກຂອງທ່ານ",
    tet: "Login atu rai imi-nia rejistu servisu",
    ne: "आफ्नो कार्य लग सुरक्षित गर्न लगइन गर्नुहोस्",
    zh: '登录后保存工作记录',
    vi: 'Đăng nhập để lưu nhật ký làm việc',
    uz: "Ish jurnalingizni saqlash uchun tizimga kiring",
  );
  static const subtitle = L10nText(
    ko: '로그인하면 출퇴근·위치 인증 기록이 서버에 안전하게 저장돼요. 로그인 없이도 데모로 먼저 둘러볼 수 있어요.',
    en: "Logging in keeps your clock-in/out and location records safely on the server. You can still explore the demo without logging in.",
    tr: "Giriş yapmak, giriş/çıkış ve konum kayıtlarınızı sunucuda güvenli bir şekilde tutar. Giriş yapmadan da demoyu keşfedebilirsiniz.",
    tg: "Воридшавӣ сабтҳои вуруд/хуруҷ ва макони шуморо дар сервер бехатар нигоҳ медорад. Шумо метавонед намоишро бидуни воридшавӣ низ омӯзед.",
    fil:
        "Ang pag-log in ay ligtas na nagpapanatili ng iyong mga record ng pagpasok/paglabas at lokasyon sa server. Maaari mo ring i-explore ang demo nang hindi nagla-log in.",
    ur: "لاگ ان کرنے سے آپ کے اندر/باہر اور مقام کے ریکارڈ سرور پر محفوظ رہتے ہیں۔ آپ لاگ ان کیے بغیر بھی ڈیمو دیکھ سکتے ہیں۔",
    th: "การเข้าสู่ระบบจะช่วยให้บันทึกการเข้า/ออกและตำแหน่งของคุณปลอดภัยบนเซิร์ฟเวอร์ คุณยังสามารถสำรวจการสาธิตได้โดยไม่ต้องเข้าสู่ระบบ",
    ky: "Кирүү сиздин кирүү/чыгуу жана жайгашкан жер жазууларыңызды серверде коопсуз сактайт. Кирбестен да демону изилдей аласыз.",
    km: "ការចូលគណនីរក្សាទុកកំណត់ត្រាចូល/ចេញ និងទីតាំងរបស់អ្នកដោយសុវត្ថិភាពនៅលើ server។ អ្នកក៏អាចស្វែងយល់ពីការបង្ហាញដោយមិនចាំបាច់ចូលគណនីផងដែរ។",
    id: "Masuk akan menyimpan catatan masuk/keluar dan lokasi Anda dengan aman di server. Anda dapat menjelajahi demo tanpa masuk.",
    si: "පිවිසීමෙන් ඔබගේ ඇතුල්වීම/පිටවීම සහ ස්ථාන වාර්තා සේවාදායකයේ ආරක්ෂිතව තබා ගනී. ඔබට පුරන්නේ නැතිව නිරූපණය ගවේෂණය කළ හැක.",
    bn: "লগইন করলে আপনার ইন/আউট এবং অবস্থানের রেকর্ডগুলি সার্ভারে নিরাপদে রাখা হবে। আপনি লগইন না করেও ডেমোটি অন্বেষণ করতে পারেন।",
    my: "လော့ဂ်အင်ဝင်ခြင်းက သင်၏ အဝင်/အထွက်နှင့် တည်နေရာ မှတ်တမ်းများကို ဆာဗာပေါ်တွင် လုံခြုံစွာ ထိန်းသိမ်းထားသည်။ လော့ဂ်အင်မဝင်ဘဲ သရုပ်ပြကိုလည်း ကြည့်ရှုနိုင်သည်။",
    mn: "Нэвтрэх нь таны ирж очих болон байршлын бүртгэлийг серверт найдвартай хадгална. Та нэвтрэхгүйгээр демог үзэх боломжтой.",
    lo: "ການເຂົ້າສູ່ລະບົບຈະເກັບຮັກສາບັນທຶກການເຂົ້າ/ອອກ ແລະ ສະຖານທີ່ຂອງທ່ານໄວ້ໃນເຊີບເວີຢ່າງປອດໄພ. ທ່ານຍັງສາມາດສຳຫຼວດຕົວຢ່າງໄດ້ໂດຍບໍ່ຕ້ອງເຂົ້າສູ່ລະບົບ.",
    tet:
        "Login sei rai imi-nia rejistu tama/sai no fatin nian ho seguru iha server. Imi bele mós explora demo ne'e la presiza login.",
    ne: "लगइन गर्दा तपाईंको इन/आउट र स्थान रेकर्डहरू सर्भरमा सुरक्षित रूपमा राखिन्छ। तपाईं लगइन नगरी पनि डेमो अन्वेषण गर्न सक्नुहुन्छ।",
    zh: '登录后，上下班打卡和位置认证记录会安全保存在服务器上。不登录也可以先体验演示版。',
    vi: 'Đăng nhập giúp lưu an toàn giờ vào/ra ca và xác minh vị trí lên máy chủ. Bạn vẫn có thể dùng thử bản demo mà không cần đăng nhập.',
    uz: "Tizimga kirish ishga kirish/chiqish va joylashuv yozuvlaringizni serverda xavfsiz saqlaydi. Tizimga kirmasdan ham demo-versiyani oʻrganishingiz mumkin.",
  );
  static const close = L10nText(
    ko: '닫기',
    en: 'Close',
    tr: "Kapat",
    tg: "Пӯшидан",
    fil: "Isara",
    ur: "بند کریں",
    th: "ปิด",
    ky: "Жабуу",
    km: "បិទ",
    id: "Tutup",
    si: "වසා දමන්න",
    bn: "বন্ধ করুন",
    my: "ပိတ်မည်",
    mn: "Хаах",
    lo: "ປິດ",
    tet: "Taka",
    ne: "बन्द गर्नुहोस्",
    zh: '关闭',
    vi: 'Đóng',
    uz: "Yopish",
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
  static const demoLabel = L10nText(
    ko: '로그인 없이 이용하기 (데모버전)',
    en: 'Continue without login (demo)',
    tr: "Giriş yapmadan devam et (demo)",
    tg: "Бидуни воридшавӣ идома диҳед (намоиш)",
    fil: "Magpatuloy nang hindi nagla-log in (demo)",
    ur: "لاگ ان کیے بغیر جاری رکھیں (ڈیمو)",
    th: "ดำเนินการต่อโดยไม่เข้าสู่ระบบ (สาธิต)",
    ky: "Кирбестен улантуу (демо)",
    km: "បន្តដោយមិនចាំបាច់ចូលគណនី (បង្ហាញ)",
    id: "Lanjutkan tanpa masuk (demo)",
    si: "පුරන්නේ නැතිව ඉදිරියට යන්න (නිරූපණය)",
    bn: "লগইন না করে চালিয়ে যান (ডেমো)",
    my: "လော့ဂ်အင်မဝင်ဘဲ ဆက်လုပ်ပါ (သရုပ်ပြ)",
    mn: "Нэвтрэхгүйгээр үргэлжлүүлэх (демо)",
    lo: "ສືບຕໍ່ໂດຍບໍ່ຕ້ອງເຂົ້າສູ່ລະບົບ (ຕົວຢ່າງ)",
    tet: "Kontinua la presiza login (demo)",
    ne: "लगइन नगरी जारी राख्नुहोस् (डेमो)",
    zh: '不登录使用（演示版）',
    vi: 'Dùng không cần đăng nhập (bản demo)',
    uz: "Tizimga kirmasdan davom etish (demo)",
  );
}

/// 하단 "캘린더" 탭을 켤 때, 로그인하지 않았고 이번 세션에서 아직 데모를
/// 선택하지도 않았다면 [MainShell]이 [WorkLogSheet] 대신 이 게이트를 먼저
/// 띄운다. [onLoginSuccess]나 [onContinueAsDemo]가 호출되면 그제서야 실제
/// 캘린더가 열린다 — [onClose]는 아무것도 선택하지 않고 그냥 닫을 때(뒤로가기,
/// X 버튼, 캘린더 탭 재탭)만 쓰인다.
class CalendarLoginGate extends StatelessWidget {
  const CalendarLoginGate({
    super.key,
    required this.isOpen,
    required this.onClose,
    required this.onContinueAsDemo,
    required this.onLoginSuccess,
  });

  final bool isOpen;
  final VoidCallback onClose;
  final VoidCallback onContinueAsDemo;
  final VoidCallback onLoginSuccess;

  Future<void> _openSignup(BuildContext context) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SignupFormScreen()));
    if (context.mounted && UserProfileScope.of(context).isSignedIn) {
      onLoginSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = UserProfileScope.of(context).language;
    return IgnorePointer(
      ignoring: !isOpen,
      child: AnimatedSlide(
        offset: isOpen ? Offset.zero : const Offset(0, 1),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        child: Material(
          color: AppColors.background,
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                const _Grabber(),
                _GateHeader(onClose: onClose, language: lang),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: LoginFormBody(onSuccess: onLoginSuccess),
                        ),
                        const SizedBox(height: 14),
                        Center(
                          child: TextButton(
                            onPressed: () => _openSignup(context),
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
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
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
                        const SizedBox(height: 18),
                        OutlinedButton(
                          onPressed: onContinueAsDemo,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textSecondary,
                            backgroundColor: const Color(0xFFF1F5F9),
                            side: BorderSide.none,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                          child: Text(
                            _S.demoLabel.of(lang),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Grabber extends StatelessWidget {
  const _Grabber();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 4,
      margin: const EdgeInsets.only(top: 8, bottom: 2),
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _GateHeader extends StatelessWidget {
  const _GateHeader({required this.onClose, required this.language});
  final VoidCallback onClose;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 12, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _S.title.of(language),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _S.subtitle.of(language),
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textMuted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onClose,
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFF1F5F9),
              foregroundColor: AppColors.textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              _S.close.of(language),
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
