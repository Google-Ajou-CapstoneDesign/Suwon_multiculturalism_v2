import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../theme/app_colors.dart';
import '../models/flow_block.dart';

const _accidentToggleLabel = L10nText(
  ko: '💥 사고성 재해 가이드 보기',
  en: '💥 View accident guidance',
  tr: "💥 Kaza rehberliğini görüntüle",
  tg: "💥 Дастури садамаро бинед",
  fil: "💥 Tingnan ang gabay sa aksidente",
  ur: "💥 حادثے کی رہنمائی دیکھیں",
  th: "💥 ดูคู่มือการเกิดอุบัติเหตุ",
  ky: "💥 Кырсык боюнча колдонмону көрүү",
  km: "💥 មើលការណែនាំអំពីគ្រោះថ្នាក់",
  id: "💥 Lihat panduan kecelakaan",
  si: "💥 අනතුරු මාර්ගෝපදේශය බලන්න",
  bn: "💥 দুর্ঘটনার নির্দেশিকা দেখুন",
  my: "💥 မတော်တဆမှု လမ်းညွှန်ချက်ကို ကြည့်ရှုပါ",
  mn: "💥 Осол гэмтлийн гарын авлагыг үзэх",
  lo: "💥 ເບິ່ງຄູ່ມືອຸບັດຕິເຫດ",
  tet: "💥 Haree Gía Asidente",
  ne: "💥 दुर्घटना मार्गदर्शन हेर्नुहोस्",
  zh: '💥 查看事故性灾害指南',
  vi: '💥 Xem hướng dẫn tai nạn',
  uz: "💥 Baxtsiz hodisa boʻyicha yoʻriqnomani koʻrish",
);
const _illnessToggleLabel = L10nText(
  ko: '🩺 질병성 재해 가이드 보기',
  en: '🩺 View illness guidance',
  tr: "🩺 Hastalık rehberini görüntüle",
  tg: "🩺 Дастури бемориро бинед",
  fil: "🩺 Tingnan ang gabay sa sakit",
  ur: "🩺 بیماری کی رہنمائی دیکھیں",
  th: "🩺 ดูคู่มือการเจ็บป่วย",
  ky: "🩺 Оору боюнча колдонмону көрүү",
  km: "🩺 មើលការណែនាំអំពីជំងឺ",
  id: "🩺 Lihat panduan penyakit",
  si: "🩺 රෝග මාර්ගෝපදේශය බලන්න",
  bn: "🩺 অসুস্থতার নির্দেশিকা দেখুন",
  my: "🩺 ဖျားနာမှု လမ်းညွှန်ချက်ကို ကြည့်ရှုပါ",
  mn: "🩺 Өвчний гарын авлагыг үзэх",
  lo: "🩺 ເບິ່ງຄູ່ມືການເຈັບປ່ວຍ",
  tet: "🩺 Haree Gía Moras",
  ne: "🩺 बिरामी मार्गदर्शन हेर्नुहोस्",
  zh: '🩺 查看疾病性灾害指南',
  vi: '🩺 Xem hướng dẫn bệnh nghề nghiệp',
  uz: "🩺 Kasallik boʻyicha yoʻriqnomani koʻrish",
);
const _stageBadgeHint = L10nText(
  ko: '💡 안내를 확인하셨나요? 원하시는 산재 신청 방식을 선택하세요.',
  en: "💡 Have you read the guidance? Choose how you'd like to file.",
  tr: "💡 Rehberi okudunuz mu? Nasıl dosyalayacağınızı seçin.",
  tg: "💡 Оё шумо дастурро хондед? Чӣ тавр ҳуҷҷатгузорӣ карданро интихоб кунед.",
  fil: "💡 Nabasa mo na ba ang gabay? Piliin kung paano mag-file.",
  ur: "💡 کیا آپ نے رہنمائی پڑھ لی ہے؟ فائل کرنے کا طریقہ منتخب کریں۔",
  th: "💡 คุณได้อ่านคู่มือแล้วหรือยัง? เลือกวิธีที่คุณจะยื่นเรื่อง",
  ky: "💡 Колдонмону окудуңузбу? Кантип арыз берериңизди тандаңыз.",
  km: "💡 តើអ្នកបានអានការណែនាំហើយឬនៅ? ជ្រើសរើសរបៀបដាក់ពាក្យ។",
  id: "💡 Sudahkah Anda membaca panduan? Pilih cara mengajukan.",
  si: "💡 ඔබ මාර්ගෝපදේශය කියෙව්වාද? ගොනු කරන ආකාරය තෝරන්න.",
  bn: "💡 আপনি কি নির্দেশিকা পড়েছেন? কিভাবে ফাইল করবেন তা নির্বাচন করুন।",
  my: "💡 လမ်းညွှန်ချက်ကို ဖတ်ပြီးပြီလား။ တင်သွင်းမည့်နည်းလမ်းကို ရွေးချယ်ပါ။",
  mn: "💡 Та гарын авлагыг уншсан уу? Хэрхэн бүртгүүлэхээ сонгоно уу.",
  lo: "💡 ທ່ານໄດ້ອ່ານຄູ່ມືແລ້ວບໍ? ເລືອກວິທີການຍື່ນ.",
  tet: "💡 Ita-boot lee ona gia? Hili oinsá atu submete.",
  ne: "💡 के तपाईंले मार्गदर्शन पढ्नुभयो? कसरी फाइल गर्ने छान्नुहोस्।",
  zh: '💡 您看过说明了吗？请选择您想要的申请方式。',
  vi: '💡 Bạn đã đọc hướng dẫn chưa? Hãy chọn cách bạn muốn nộp đơn.',
  uz: "💡 Yoʻriqnomani oʻqidingizmi? Qanday ariza topshirishni tanlang.",
);
const _delegateTitle = L10nText(
  ko: '🏥 병원 원무과 대행 제출로 끝내기 (안내 종료)',
  en: '🏥 Let the hospital file for you (done)',
  tr: "🏥 Hastanenin sizin için dosyalama yapmasına izin verin (tamamlandı)",
  tg: "🏥 Бигзор беморхона барои шумо ҳуҷҷатгузорӣ кунад (анҷом ёфт)",
  fil: "🏥 Hayaan ang ospital na mag-file para sa iyo (kumpleto)",
  ur: "🏥 ہسپتال کو آپ کے لیے فائل کرنے کی اجازت دیں (مکمل ہو گیا)",
  th: "🏥 ให้โรงพยาบาลยื่นเรื่องให้คุณ (เสร็จสมบูรณ์แล้ว)",
  ky: "🏥 Ооруканага сиз үчүн арыз берүүгө уруксат бериңиз (бүттү)",
  km: "🏥 អនុញ្ញាតឱ្យមន្ទីរពេទ្យដាក់ពាក្យជំនួសអ្នក (បានបញ្ចប់)",
  id: "🏥 Biarkan rumah sakit mengajukan untuk Anda (selesai)",
  si: "🏥 රෝහලට ඔබ වෙනුවෙන් ගොනු කිරීමට ඉඩ දෙන්න (සම්පූර්ණයි)",
  bn: "🏥 হাসপাতালকে আপনার জন্য ফাইল করতে দিন (সম্পূর্ণ)",
  my: "🏥 ဆေးရုံမှ သင့်အတွက် တင်သွင်းခွင့်ပြုပါ (ပြီးစီး)",
  mn: "🏥 Эмнэлэгт таны өмнөөс бүртгүүлэхийг зөвшөөрөх (бүрэн)",
  lo: "🏥 ໃຫ້ໂຮງໝໍຍື່ນເອກະສານໃຫ້ທ່ານ (ສຳເລັດແລ້ວ)",
  tet: "🏥 Husik ospitál submete ba ita-boot (kompletu)",
  ne: "🏥 अस्पताललाई तपाईंको लागि फाइल गर्न दिनुहोस् (सम्पन्न भयो)",
  zh: '🏥 委托医院窗口代为提交（结束）',
  vi: '🏥 Nhờ bệnh viện nộp thay (hoàn tất)',
  uz: "🏥 Shifoxona siz uchun ariza topshirsin (bajarildi)",
);
const _delegateSubtitle = L10nText(
  ko: '원무과에 서류를 내고 진행 트래커(Step 6)에서 진행 상황을 기록합니다',
  en: 'File at the front desk, then track progress in Step 6',
  tr: "Ön büroda dosyalayın, ardından 6. Adımda ilerlemeyi takip edin",
  tg: "Дар қабулгоҳ ҳуҷҷатгузорӣ кунед, сипас пешрафтро дар қадами 6 пайгирӣ кунед",
  fil:
      "Mag-file sa front desk, pagkatapos ay sundin ang pag-usad sa Hakbang 6.",
  ur: "فرنٹ ڈیسک پر فائل کریں، پھر 6 قدم پر پیشرفت کی پیروی کریں",
  th: "ยื่นเรื่องที่แผนกต้อนรับ จากนั้นติดตามความคืบหน้าในขั้นตอนที่ 6",
  ky: "Кабылдамада арыз бериңиз, андан кийин 6-кадамда прогрессти көзөмөлдөңүз",
  km: "ដាក់ពាក្យនៅការិយាល័យខាងមុខ បន្ទាប់មកតាមដានវឌ្ឍនភាពនៅជំហាន 6។",
  id: "Ajukan di meja depan, lalu ikuti kemajuan di langkah 6",
  si: "ඉදිරිපස මේසයේ ගොනු කරන්න, ඉන්පසු 6 පියවරේ ප්‍රගතිය නිරීක්ෂණය කරන්න",
  bn: "ফ্রন্ট ডেস্কে ফাইল করুন, তারপর 6 ধাপে অগ্রগতি অনুসরণ করুন",
  my: "ရှေ့တန်းတွင် တင်သွင်းပြီးနောက် အဆင့် 6 တွင် တိုးတက်မှုကို ခြေရာခံပါ",
  mn: "Урд талын ширээнд бүртгүүлээд, дараа нь 6 алхамд явцыг хянах",
  lo: "ຍື່ນເອກະສານຢູ່ໂຕະຕ້ອນຮັບ, ຈາກນັ້ນຕິດຕາມຄວາມຄືບໜ້າໃນຂັ້ນຕອນທີ 6.",
  tet: "Submete iha resepsaun, depois akompaña progresu iha Pásu 6.",
  ne: "अगाडिको डेस्कमा फाइल गर्नुहोस्, त्यसपछि चरण 6 मा प्रगति ट्र्याक गर्नुहोस्",
  zh: '在窗口提交材料，并在进度追踪器（第6步）中记录进展',
  vi: 'Nộp hồ sơ tại quầy, sau đó theo dõi tiến độ ở Bước 6',
  uz: "Qabulxonada ariza topshiring, soʻng 6-qadamda jarayonni kuzatib boring",
);
const _selfFileTitle = L10nText(
  ko: '📄 근로자 직접 신청 / 서식 작성하기',
  en: '📄 File it myself / fill in the form',
  tr: "📄 Kendim dosyalayacağım / formu dolduracağım",
  tg: "📄 Худам ҳуҷҷатгузорӣ мекунам / варақаро пур мекунам",
  fil: "📄 Ako mismo ang magfa-file / magpupuno ng form",
  ur: "📄 میں خود فائل کروں گا / فارم پُر کروں گا",
  th: "📄 ฉันจะยื่นเรื่อง/กรอกแบบฟอร์มด้วยตัวเอง",
  ky: "📄 Мен өзүм арыз берем / форманы толтурам",
  km: "📄 ខ្ញុំនឹងដាក់ពាក្យ/បំពេញទម្រង់បែបបទដោយខ្លួនឯង",
  id: "📄 Saya akan mengajukan/mengisi formulir sendiri",
  si: "📄 මමම ගොනු කරන්නම් / පෝරමය පුරවන්නම්",
  bn: "📄 আমি নিজে ফাইল করব / ফর্ম পূরণ করব",
  my: "📄 ကျွန်ုပ်ကိုယ်တိုင် တင်သွင်း/ပုံစံဖြည့်ပါမည်",
  mn: "📄 Би өөрөө бүртгүүлнэ / маягтыг бөглөнө",
  lo: "📄 ຂ້ອຍຈະຍື່ນເອກະສານເອງ / ຕື່ມແບບຟອມ",
  tet: "📄 Ha'u sei submete rasik / preenxe formuláriu",
  ne: "📄 म आफैं फाइल गर्नेछु / फारम भर्नेछु",
  zh: '📄 劳动者本人申请／填写表格',
  vi: '📄 Tự nộp đơn / điền biểu mẫu',
  uz: "📄 Oʻzim ariza topshiraman / shaklni toʻldiraman",
);
const _selfFileSubtitle = L10nText(
  ko: 'Step 3(요양급여신청서 작성)으로 이동합니다',
  en: 'Move on to Step 3, filling in the claim form',
  tr: "3. Adıma geçin, talep formunu doldurun",
  tg: "Ба қадами 3 гузаред, варақаи дархостро пур кунед",
  fil: "Pumunta sa Hakbang 3, punan ang claim form",
  ur: "3 قدم پر جائیں، دعوے کا فارم پُر کریں",
  th: "ไปที่ขั้นตอนที่ 3 กรอกแบบฟอร์มการเรียกร้อง",
  ky: "3-кадамга өтүңүз, арыз формасын толтуруңуз",
  km: "បន្តទៅជំហាន 3 បំពេញទម្រង់បែបបទទាមទារ",
  id: "Lanjutkan ke langkah 3, isi formulir klaim",
  si: "3 පියවරට යන්න, හිමිකම් පෝරමය පුරවන්න",
  bn: "3 ধাপে যান, দাবি ফর্ম পূরণ করুন",
  my: "အဆင့် 3 သို့သွား၍ တောင်းဆိုမှုပုံစံကို ဖြည့်ပါ",
  mn: "3 алхам руу очиж, нэхэмжлэлийн маягтыг бөглөнө үү",
  lo: "ໄປທີ່ຂັ້ນຕອນທີ 3, ຕື່ມແບບຟອມຮ້ອງຂໍ",
  tet: "Ba Pásu 3 no preenxe formuláriu pedidu",
  ne: "चरण 3 मा जानुहोस्, दाबी फारम भर्नुहोस्",
  zh: '前往第3步（填写疗养给付申请书）',
  vi: 'Chuyển sang Bước 3, điền đơn xin trợ cấp',
  uz: "3-qadamga oʻting, daʼvo arizasi shaklini toʻldiring",
);
const _delegateToast = L10nText(
  ko: '진행 트래커로 이동합니다',
  en: 'Moving to the progress tracker',
  tr: "İlerleme takipçisine geçiliyor",
  tg: "Ба пайгирии пешрафт гузаштан",
  fil: "Pumupunta sa progress tracker",
  ur: "پیشرفت ٹریکر پر جا رہا ہے",
  th: "กำลังไปที่ตัวติดตามความคืบหน้า",
  ky: "Прогрессти көзөмөлдөөчүгө өтүү",
  km: "កំពុងបន្តទៅកម្មវិធីតាមដានវឌ្ឍនភាព",
  id: "Lanjutkan ke pelacak kemajuan",
  si: "ප්‍රගති ට්‍රැකර් වෙත යමින්",
  bn: "অগ্রগতি ট্র্যাকারে যাচ্ছে",
  my: "တိုးတက်မှု ခြေရာခံစနစ်သို့ သွားနေသည်",
  mn: "Явцын хяналт руу шилжих",
  lo: "ໄປທີ່ເຄື່ອງຕິດຕາມຄວາມຄືບໜ້າ",
  tet: "Hakat ba Akompaña Progresu",
  ne: "प्रगति ट्र्याकरमा जाँदैछ",
  zh: '正在前往进度追踪器',
  vi: 'Đang chuyển đến trình theo dõi tiến độ',
  uz: "Jarayon kuzatuvchisiga oʻtish",
);

/// 산재 2단계 — 사고/질병 토글 + 근거조항 카드 3개 + "병원 위임"(트래커로 점프)
/// / "직접 신청"(다음 단계로) 분기. html_files/산재처리네비게이터.html의
/// INJURY_GUIDE를 그대로 옮겼다.
class InjuryGuideView extends StatefulWidget {
  const InjuryGuideView({
    super.key,
    required this.accidentCards,
    required this.illnessCards,
    required this.currentType,
    required this.onTypeChanged,
    required this.onDelegate,
    required this.onSelfFile,
    required this.lang,
    required this.accentColor,
  });

  final List<LegalCitationCard> accidentCards;
  final List<LegalCitationCard> illnessCards;

  /// 0=사고성, 1=질병성 — 1단계 OptionsBlock 선택과 같은 값을 공유한다.
  /// null이면(1단계에서 아직 안 골랐으면) 사고성을 기본으로 보여준다.
  final int? currentType;
  final ValueChanged<int> onTypeChanged;
  final VoidCallback onDelegate;
  final VoidCallback onSelfFile;
  final AppLanguage lang;
  final Color accentColor;

  @override
  State<InjuryGuideView> createState() => _InjuryGuideViewState();
}

class _InjuryGuideViewState extends State<InjuryGuideView> {
  final _expanded = <int>{};

  @override
  Widget build(BuildContext context) {
    final type = widget.currentType ?? 0;
    final cards = type == 1 ? widget.illnessCards : widget.accidentCards;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _ToggleButton(
                label: _accidentToggleLabel.of(widget.lang),
                selected: type == 0,
                accentColor: widget.accentColor,
                onTap: () => widget.onTypeChanged(0),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ToggleButton(
                label: _illnessToggleLabel.of(widget.lang),
                selected: type == 1,
                accentColor: widget.accentColor,
                onTap: () => widget.onTypeChanged(1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < cards.length; i++) ...[
          _LegalCard(
            card: cards[i],
            lang: widget.lang,
            expanded: _expanded.contains(i),
            accentColor: widget.accentColor,
            onTap: () => setState(() {
              if (!_expanded.add(i)) _expanded.remove(i);
            }),
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            _stageBadgeHint.of(widget.lang),
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF1B5E20),
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 10),
        _BigOptionButton(
          icon: '🏥',
          title: _delegateTitle.of(widget.lang),
          subtitle: _delegateSubtitle.of(widget.lang),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_delegateToast.of(widget.lang)),
                duration: const Duration(seconds: 1),
              ),
            );
            widget.onDelegate();
          },
        ),
        const SizedBox(height: 8),
        _BigOptionButton(
          icon: '📄',
          title: _selfFileTitle.of(widget.lang),
          subtitle: _selfFileSubtitle.of(widget.lang),
          onTap: widget.onSelfFile,
        ),
      ],
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.label,
    required this.selected,
    required this.accentColor,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? accentColor : Colors.white,
          border: Border.all(color: selected ? accentColor : AppColors.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _LegalCard extends StatelessWidget {
  const _LegalCard({
    required this.card,
    required this.lang,
    required this.expanded,
    required this.accentColor,
    required this.onTap,
  });
  final LegalCitationCard card;
  final AppLanguage lang;
  final bool expanded;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(11),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(card.icon, style: const TextStyle(fontSize: 17)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.title.of(lang),
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          card.subtitle.of(lang),
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: AppColors.textMuted,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    size: 18,
                    color: expanded ? accentColor : AppColors.textMuted,
                  ),
                ],
              ),
              if (expanded) ...[
                const SizedBox(height: 9),
                Text(
                  card.body.of(lang),
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BigOptionButton extends StatelessWidget {
  const _BigOptionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
