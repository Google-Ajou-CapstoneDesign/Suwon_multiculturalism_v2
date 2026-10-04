import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';

/// 최초 실행 온보딩 — 언어 선택 한 단계뿐이다.
/// 로그인·사용설명서는 여기 있던 걸 각각 캘린더 진입 게이트(CalendarLoginGate)와
/// 설정 탭(GuideScreen)으로 옮겼다 — 이 앱에서 로그인이 실제로 필요한 곳은
/// 캘린더뿐이라, 앱을 열자마자 로그인부터 강제할 이유가 없었다. 언어를 고르고
/// "시작하기"를 누르면 곧바로 홈으로 들어간다.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key, required this.onFinished});

  final VoidCallback onFinished;

  static const _title = L10nText(
    ko: '어떤 언어로 볼까요?',
    en: 'Which language do you read?',
    tr: "Hangi dili okuyorsunuz?",
    tg: "Шумо кадом забонро мехонед?",
    fil: "Anong wika ang binabasa mo?",
    ur: "آپ کون سی زبان پڑھ رہے ہیں؟",
    th: "คุณอ่านภาษาอะไร",
    ky: "Кайсы тилди окуйсуз?",
    km: "តើអ្នកកំពុងអានភាសាអ្វី?",
    id: "Bahasa apa yang Anda baca?",
    si: "ඔබ කියවන භාෂාව කුමක්ද?",
    bn: "আপনি কোন ভাষা পড়ছেন?",
    my: "မည်သည့်ဘာသာစကားကို ဖတ်ရှုလိုပါသလဲ။",
    mn: "Та ямар хэлээр уншиж байна вэ?",
    lo: "ທ່ານກຳລັງອ່ານພາສາໃດ?",
    tet: "Lian saida mak imi lee?",
    ne: "तपाईं कुन भाषा पढ्दै हुनुहुन्छ?",
    zh: '想用哪种语言查看？',
    vi: 'Bạn đọc bằng ngôn ngữ nào?',
    uz: "Qaysi tilda oʻqiysiz?",
  );
  static const _subtitle = L10nText(
    ko: '어떤 언어를 골라도 한국어 표기는 함께 보여드립니다. 기관에서 그대로 말할 수 있도록요.',
    en: 'Whichever you pick, the Korean term stays alongside — so you can say it as-is at an office.',
    tr: "Hangisini seçerseniz seçin, Korece terim yanında kalır — böylece bir ofiste olduğu gibi söyleyebilirsiniz.",
    tg: "Кадомеро, ки интихоб кунед, истилоҳи кореягӣ дар паҳлӯи он боқӣ мемонад — то шумо онро мисли дар идора гуфта тавонед.",
    fil:
        "Anuman ang piliin mo, mananatili ang terminong Korean sa tabi nito — para masabi mo ito tulad ng sa isang opisina.",
    ur: "آپ جو بھی منتخب کریں، کوریائی اصطلاح ساتھ رہے گی — تاکہ آپ اسے دفتر میں بھی کہہ سکیں۔",
    th: "ไม่ว่าคุณจะเลือกภาษาใด คำศัพท์ภาษาเกาหลีจะยังคงอยู่ข้าง ๆ — เพื่อให้คุณสามารถพูดได้เหมือนอยู่ในสำนักงาน",
    ky: "Кайсынысын тандабаңыз, корей термини жанында калат — ошондуктан аны кеңседе айткандай айта аласыз.",
    km: "មិនថាអ្នកជ្រើសរើសមួយណាទេ ពាក្យកូរ៉េនៅតែមាន — ដូច្នេះអ្នកអាចនិយាយវាដូចជានៅការិយាល័យ។",
    id: "Apa pun yang Anda pilih, istilah Korea tetap ada di sampingnya — sehingga Anda dapat mengatakannya seperti di kantor.",
    si: "ඔබ කුමක් තෝරා ගත්තද, කොරියානු පදය ඒ අසලම පවතී - එවිට ඔබට එය කාර්යාලයකදී මෙන් පැවසිය හැකිය.",
    bn: "আপনি যা-ই নির্বাচন করুন না কেন, কোরিয়ান শব্দটি পাশে থাকবে — যাতে আপনি অফিসের মতো করে বলতে পারেন।",
    my: "သင်မည်သည့်ဘာသာစကားကို ရွေးချယ်သည်ဖြစ်စေ ကိုရီးယားဝေါဟာရသည် ဘေးတွင်ရှိနေမည်ဖြစ်သည် — ထို့ကြောင့် ရုံးတွင်ပြောသကဲ့သို့ ပြောဆိုနိုင်ပါသည်။",
    mn: "Таны сонгосон хэлээс үл хамааран солонгос нэр томъёо хажууд нь хэвээр үлдэнэ — ингэснээр та үүнийг албан газарт байгаа мэт хэлж чадна.",
    lo: "ບໍ່ວ່າທ່ານຈະເລືອກອັນໃດ, ຄຳສັບພາສາເກົາຫຼີຈະຍັງຄົງຢູ່ຄຽງຂ້າງ — ເພື່ອໃຫ້ທ່ານສາມາດເວົ້າໄດ້ຄືກັບຢູ່ໃນຫ້ອງການ.",
    tet:
        "Kualkér ida mak imi hili, termu Koreanu sei nafatin iha sorin — nuneʼe imi bele dehan hanesan imi dehan iha eskritóriu.",
    ne: "तपाईंले जुनसुकै भाषा रोज्नुभए पनि, कोरियन शब्द सँगै रहन्छ — ताकि तपाईंले कार्यालयमा जस्तै भन्न सक्नुहुन्छ।",
    zh: '无论选择哪种语言，都会同时显示韩语原文，方便您在机构窗口照原文说出来。',
    vi: 'Dù chọn ngôn ngữ nào, thuật ngữ tiếng Hàn vẫn hiện kèm để bạn nói nguyên văn tại cơ quan.',
    uz: "Qaysi birini tanlamang, koreyscha atama yonida qoladi — shuning uchun uni ofisda boricha ayta olasiz.",
  );
  static const _startLabel = L10nText(
    ko: '시작하기',
    en: 'Get started',
    tr: "Başlayın",
    tg: "Оғоз кунед",
    fil: "Magsimula",
    ur: "شروع کریں",
    th: "เริ่มต้น",
    ky: "Баштоо",
    km: "ចាប់ផ្តើម",
    id: "Mulai",
    si: "ආරම්භ කරන්න",
    bn: "শুরু করুন",
    my: "စတင်ရန်",
    mn: "Эхлэх",
    lo: "ເລີ່ມຕົ້ນ",
    tet: "Haʼu-hú",
    ne: "सुरु गर्नुहोस्",
    zh: '开始使用',
    vi: 'Bắt đầu',
    uz: "Boshlash",
  );

  @override
  Widget build(BuildContext context) {
    final profile = UserProfileScope.of(context);
    final lang = profile.language;

    return Material(
      color: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _title.of(lang),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _subtitle.of(lang),
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textMuted,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _LanguageStep(profile: profile)),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 11, 16, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: ElevatedButton(
                onPressed: onFinished,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                child: Text(
                  _startLabel.of(lang),
                  style: const TextStyle(
                    fontSize: 13,
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

class _LanguageStep extends StatelessWidget {
  const _LanguageStep({required this.profile});
  final UserProfileController profile;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      children: [
        for (final lang in AppLanguage.values)
          _PickRow(
            code: lang.code,
            title: lang.nativeName,
            subtitle: lang.subLabel,
            selected: profile.language == lang,
            onTap: () => profile.setLanguage(lang),
          ),
      ],
    );
  }
}

class _PickRow extends StatelessWidget {
  const _PickRow({
    required this.code,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String code;
  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE3F2FD) : Colors.white,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              constraints: const BoxConstraints(minWidth: 40),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.textMuted,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                code,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check, size: 16, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
