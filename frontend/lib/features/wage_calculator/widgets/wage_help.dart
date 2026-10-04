import 'package:flutter/material.dart';
import '../../../common/widgets/rich_note.dart';
import '../../../core/app_language.dart';
import '../../../theme/app_colors.dart';
import '../models/wage_diagnosis.dart';

const _okLabel = L10nText(
  ko: '확인',
  en: 'OK',
  tr: "Tamam",
  tg: "Тасдиқ",
  fil: "OK",
  ur: "ٹھیک ہے",
  th: "ตกลง",
  ky: "Даяр",
  km: "រួចរាល់",
  id: "Selesai",
  si: "හරි",
  bn: "সম্পন্ন",
  my: "ပြီးပါပြီ",
  mn: "Баталгаажуулах",
  lo: "ຕົກລົງ",
  tet: "Prontu",
  ne: "ठीक छ",
  zh: '确定',
  vi: 'Xác nhận',
  uz: "OK",
);

void showWageHelp(
  BuildContext context,
  String title,
  Widget body,
  AppLanguage lang,
) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, style: const TextStyle(fontSize: 14.5)),
      content: SizedBox(width: 340, child: SingleChildScrollView(child: body)),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(_okLabel.of(lang)),
        ),
      ],
    ),
  );
}

class HelpEntry {
  HelpEntry({required this.title, required this.body});
  final String title;
  final Widget Function(BuildContext context) body;
}

class _TaxTableRow extends TableRow {
  _TaxTableRow(List<String> cells, {bool isHeader = false})
    : super(
        decoration: isHeader
            ? const BoxDecoration(color: Color(0xFFF1F5F9))
            : null,
        children: cells
            .map(
              (c) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Text(
                  c,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isHeader ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            )
            .toList(),
      );
}

const _taxTableHeader = [
  L10nText(
    ko: '4대보험',
    en: '4 Major Insurances',
    tr: "4 Büyük Sigorta",
    tg: "4 Суғуртаи асосӣ",
    fil: "4 Pangunahing Seguro",
    ur: "4 بڑا بیمہ",
    th: "ประกันหลัก 4 ประเภท",
    ky: "4 Чоң камсыздандыруу",
    km: "ធានារ៉ាប់រងធំ 4",
    id: "4 Asuransi Utama",
    si: "4 ප්‍රධාන රක්ෂණය",
    bn: "4 প্রধান বীমা",
    my: "4 အဓိကအာမခံ",
    mn: "4 Том Даатгал",
    lo: "ປະກັນໄພໃຫຍ່ 4",
    tet: "Seguru Boot 4",
    ne: "4 प्रमुख बीमा",
    zh: '四大保险',
    vi: '4 loại bảo hiểm',
    uz: "4 ta asosiy sugʻurta",
  ),
  L10nText(
    ko: '근로자(급여공제)',
    en: 'Employee (payroll deduction)',
    tr: "Çalışan (maaş kesintisi)",
    tg: "Корманд (тарҳи музди меҳнат)",
    fil: "Empleyado (bawas sa sahod)",
    ur: "ملازم (تنخواہ کی کٹوتی)",
    th: "ลูกจ้าง (หักจากเงินเดือน)",
    ky: "Кызматкер (айлыктан кармоо)",
    km: "និយោជិត (ការកាត់ប្រាក់ឈ្នួល)",
    id: "Karyawan (pemotongan gaji)",
    si: "සේවකයා (වැටුපෙන් අඩු කිරීම)",
    bn: "কর্মচারী (বেতন কর্তন)",
    my: "ဝန်ထမ်း (လစာနုတ်ယူခြင်း)",
    mn: "Ажилтан (цалингийн суутгал)",
    lo: "ພະນັກງານ (ຫັກຄ່າຈ້າງ)",
    tet: "Traballadór (dedusaun saláriu)",
    ne: "कर्मचारी (तलब कटौती)",
    zh: '劳动者（工资扣除）',
    vi: 'Người lao động (khấu trừ lương)',
    uz: "Xodim (ish haqidan ushlab qolish)",
  ),
  L10nText(
    ko: '사업주',
    en: 'Employer',
    tr: "İşveren",
    tg: "Корфармо",
    fil: "Employer",
    ur: "آجر",
    th: "นายจ้าง",
    ky: "Иш берүүчү",
    km: "និយោជក",
    id: "Pemberi Kerja",
    si: "සේවායෝජකයා",
    bn: "নিয়োগকর্তা",
    my: "အလုပ်ရှင်",
    mn: "Ажил олгогч",
    lo: "ນາຍຈ້າງ",
    tet: "Empregadór",
    ne: "रोजगारदाता",
    zh: '雇主',
    vi: 'Người sử dụng lao động',
    uz: "Ish beruvchi",
  ),
];
const _pensionLabel = L10nText(
  ko: '국민연금 (9%)',
  en: 'National Pension (9%)',
  tr: "Ulusal Emeklilik (%9)",
  tg: "Нафақаи миллӣ (9%)",
  fil: "Pambansang Pensiyon (9%)",
  ur: "قومی پنشن (9%)",
  th: "เงินบำนาญแห่งชาติ (9%)",
  ky: "Улуттук пенсия (9%)",
  km: "ប្រាក់សោធននិវត្តន៍ជាតិ (9%)",
  id: "Pensiun Nasional (9%)",
  si: "ජාතික විශ්‍රාම වැටුප (9%)",
  bn: "জাতীয় পেনশন (9%)",
  my: "အမျိုးသားပင်စင် (9%)",
  mn: "Үндэсний тэтгэвэр (9%)",
  lo: "ເງິນບໍານານແຫ່ງຊາດ (%9)",
  tet: "Pensaun Nasionál (%9)",
  ne: "राष्ट्रिय पेन्सन (%9)",
  zh: '国民年金 (9%)',
  vi: 'Bảo hiểm hưu trí quốc dân (9%)',
  uz: "Milliy pensiya (9%)",
);
const _healthLabel = L10nText(
  ko: '건강보험료 (6.99%)',
  en: 'Health Insurance (6.99%)',
  tr: "Sağlık Sigortası (%6.99)",
  tg: "Суғуртаи тиббӣ (6.99%)",
  fil: "Seguro sa Kalusugan (6.99%)",
  ur: "صحت بیمہ (6.99%)",
  th: "ประกันสุขภาพ (6.99%)",
  ky: "Медициналык камсыздандыруу (6.99%)",
  km: "ធានារ៉ាប់រងសុខភាព (6.99%)",
  id: "Asuransi Kesehatan (6.99%)",
  si: "සෞඛ්‍ය රක්ෂණය (6.99%)",
  bn: "স্বাস্থ্য বীমা (6.99%)",
  my: "ကျန်းမာရေးအာမခံ (6.99%)",
  mn: "Эрүүл мэндийн даатгал (6.99%)",
  lo: "ປະກັນໄພສຸຂະພາບ (%6.99)",
  tet: "Seguru Saúde (%6.99)",
  ne: "स्वास्थ्य बीमा (%6.99)",
  zh: '健康保险 (6.99%)',
  vi: 'Bảo hiểm y tế (6.99%)',
  uz: "Tibbiy sugʻurta (6.99%)",
);
const _ltcLabel = L10nText(
  ko: '장기요양보험 (건강보험료의 12.27%)',
  en: 'Long-term Care Insurance (12.27% of health insurance)',
  tr: "Uzun Süreli Bakım Sigortası (sağlık sigortasının %12.27'si)",
  tg: "Суғуртаи нигоҳубини дарозмуддат (12.27% аз суғуртаи тиббӣ)",
  fil: "Seguro sa Pangmatagalang Pangangalaga (12.27% ng seguro sa kalusugan)",
  ur: "طویل مدتی نگہداشت بیمہ (صحت بیمہ کا 12.27%)",
  th: "ประกันการดูแลระยะยาว (12.27% ของประกันสุขภาพ)",
  ky: "Узак мөөнөттүү кам көрүү камсыздандыруусу (медициналык камсыздандыруунун 12.27%)",
  km: "ធានារ៉ាប់រងថែទាំរយៈពេលវែង (12.27% នៃធានារ៉ាប់រងសុខភាព)",
  id: "Asuransi Perawatan Jangka Panjang (12.27% dari asuransi kesehatan)",
  si: "දිගුකාලීන සත්කාර රක්ෂණය (සෞඛ්‍ය රක්ෂණයෙන් 12.27%)",
  bn: "দীর্ঘমেয়াদী যত্ন বীমা (স্বাস্থ্য বীমার 12.27%)",
  my: "ရေရှည်စောင့်ရှောက်မှုအာမခံ (ကျန်းမာရေးအာမခံ၏ 12.27%)",
  mn: "Урт хугацааны асаргааны даатгал (эрүүл мэндийн даатгалын 12.27%)",
  lo: "ປະກັນໄພການດູແລໄລຍະຍາວ (12.27% ຂອງປະກັນໄພສຸຂະພາບ)",
  tet: "Seguru Kuidadu Longu Prazu (%12.27 husi seguru saúde)",
  ne: "दीर्घकालीन हेरचाह बीमा (स्वास्थ्य बीमाको %12.27)",
  zh: '长期护理保险（健康保险费的12.27%）',
  vi: 'Bảo hiểm chăm sóc dài hạn (12,27% phí bảo hiểm y tế)',
  uz: "Uzoq muddatli parvarish sugʻurtasi (tibbiy sugʻurtaning 12.27%)",
);
const _healthTimesLtc = L10nText(
  ko: '건강보험료 × 12.27%',
  en: 'Health insurance × 12.27%',
  tr: "Sağlık sigortası × %12.27",
  tg: "Суғуртаи тиббӣ × 12.27%",
  fil: "Seguro sa kalusugan × 12.27%",
  ur: "صحت بیمہ × 12.27%",
  th: "ประกันสุขภาพ × 12.27%",
  ky: "Медициналык камсыздандыруу × 12.27%",
  km: "ធានារ៉ាប់រងសុខភាព × 12.27%",
  id: "Asuransi kesehatan × 12.27%",
  si: "සෞඛ්‍ය රක්ෂණය × 12.27%",
  bn: "স্বাস্থ্য বীমা × 12.27%",
  my: "ကျန်းမာရေးအာမခံ × 12.27%",
  mn: "Эрүүл мэндийн даатгал × 12.27%",
  lo: "ປະກັນໄພສຸຂະພາບ × %12.27",
  tet: "Seguru saúde × %12.27",
  ne: "स्वास्थ्य बीमा × %12.27",
  zh: '健康保险费 × 12.27%',
  vi: 'Phí BHYT × 12,27%',
  uz: "Tibbiy sugʻurta × 12.27%",
);
const _employmentLabel = L10nText(
  ko: '고용보험',
  en: 'Employment Insurance',
  tr: "İşsizlik Sigortası",
  tg: "Суғуртаи бекорӣ",
  fil: "Seguro sa Pagkawala ng Trabaho",
  ur: "بے روزگاری بیمہ",
  th: "ประกันการว่างงาน",
  ky: "Жумушсуздук камсыздандыруусу",
  km: "ការធានារ៉ាប់រងភាពអត់ការងារធ្វើ",
  id: "Asuransi Pengangguran",
  si: "රැකියා විරහිත රක්ෂණය",
  bn: "বেকারত্ব বীমা",
  my: "အလုပ်လက်မဲ့ အာမခံ",
  mn: "Ажилгүйдлийн даатгал",
  lo: "ປະກັນໄພການຫວ່າງງານ",
  tet: "Seguru Dezempregu",
  ne: "बेरोजगारी बीमा",
  zh: '雇佣保险',
  vi: 'Bảo hiểm việc làm',
  uz: "Ish bilan taʼminlash sugʻurtasi",
);
const _variesByCompany = L10nText(
  ko: '기업규모별 상이',
  en: 'Varies by company size',
  tr: "Şirket büyüklüğüne göre değişir",
  tg: "Вобаста ба андозаи ширкат фарқ мекунад",
  fil: "Nag-iiba ayon sa laki ng kumpanya",
  ur: "کمپنی کے سائز کے لحاظ سے مختلف ہوتا ہے",
  th: "แตกต่างกันไปตามขนาดบริษัท",
  ky: "Компаниянын көлөмүнө жараша өзгөрөт",
  km: "ប្រែប្រួលទៅតាមទំហំក្រុមហ៊ុន",
  id: "Bervariasi berdasarkan ukuran perusahaan",
  si: "සමාගමේ ප්‍රමාණය අනුව වෙනස් වේ",
  bn: "কোম্পানির আকার অনুযায়ী পরিবর্তিত হয়",
  my: "ကုမ္ပဏီအရွယ်အစားအလိုက် ကွဲပြားသည်",
  mn: "Компанийн хэмжээнээс хамаарна",
  lo: "ແຕກຕ່າງກັນໄປຕາມຂະໜາດຂອງບໍລິສັດ",
  tet: "Varia tuir tamañu empreza",
  ne: "कम्पनीको आकार अनुसार फरक पर्छ",
  zh: '因企业规模而异',
  vi: 'Khác nhau theo quy mô doanh nghiệp',
  uz: "Kompaniya hajmiga qarab farq qiladi",
);
const _accidentLabel = L10nText(
  ko: '산재보험',
  en: 'Industrial Accident Insurance',
  tr: "İş Kazası Sigortası",
  tg: "Суғуртаи садамаи меҳнатӣ",
  fil: "Seguro sa Aksidente sa Trabaho",
  ur: "کام پر حادثے کی انشورنس",
  th: "ประกันการบาดเจ็บจากการทำงาน",
  ky: "Өндүрүштүк кырсыктан камсыздандыруу",
  km: "ការធានារ៉ាប់រងគ្រោះថ្នាក់ការងារ",
  id: "Asuransi Kecelakaan Kerja",
  si: "කාර්මික අනතුරු රක්ෂණය",
  bn: "শিল্প দুর্ঘটনা বীমা",
  my: "လုပ်ငန်းခွင်ထိခိုက်မှုအာမခံ",
  mn: "Ажлын ослын даатгал",
  lo: "ປະກັນໄພອຸບັດຕິເຫດໃນການເຮັດວຽກ",
  tet: "Seguru Asidente Servisu",
  ne: "औद्योगिक दुर्घटना बीमा",
  zh: '工伤保险',
  vi: 'Bảo hiểm tai nạn lao động',
  uz: "Ishlab chiqarishdagi baxtsiz hodisalardan sugʻurta",
);
const _noneLabel = L10nText(
  ko: '없음',
  en: 'None',
  tr: "Yok",
  tg: "Нест",
  fil: "Wala",
  ur: "کوئی نہیں",
  th: "ไม่มี",
  ky: "Жок",
  km: "គ្មាន",
  id: "Tidak Ada",
  si: "කිසිවක් නැත",
  bn: "নেই",
  my: "မရှိပါ",
  mn: "Байхгүй",
  lo: "ບໍ່ມີ",
  tet: "La iha",
  ne: "छैन",
  zh: '无',
  vi: 'Không có',
  uz: "Hech qanday",
);
const _variesByIndustry = L10nText(
  ko: '업종별 상이',
  en: 'Varies by industry',
  tr: "Sektöre göre değişir",
  tg: "Вобаста ба соҳа фарқ мекунад",
  fil: "Nag-iiba ayon sa industriya",
  ur: "صنعت کے لحاظ سے مختلف ہوتا ہے",
  th: "แตกต่างกันไปตามประเภทธุรกิจ",
  ky: "Тармакка жараша өзгөрөт",
  km: "ប្រែប្រួលទៅតាមវិស័យ",
  id: "Bervariasi berdasarkan industri",
  si: "කර්මාන්තය අනුව වෙනස් වේ",
  bn: "শিল্প অনুযায়ী পরিবর্তিত হয়",
  my: "လုပ်ငန်းအမျိုးအစားအလိုက် ကွဲပြားသည်",
  mn: "Салбараас хамаарна",
  lo: "ແຕກຕ່າງກັນໄປຕາມຂະແໜງການ",
  tet: "Varia tuir setór",
  ne: "उद्योग अनुसार फरक पर्छ",
  zh: '因行业而异',
  vi: 'Khác nhau theo ngành nghề',
  uz: "Sohaga qarab farq qiladi",
);

Widget _taxInfoBody(BuildContext context, AppLanguage lang) {
  String t(L10nText s) => s.of(lang);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Table(
        border: TableBorder.all(color: AppColors.border),
        children: [
          _TaxTableRow(_taxTableHeader.map(t).toList(), isHeader: true),
          _TaxTableRow([t(_pensionLabel), '4.5%', '4.5%']),
          _TaxTableRow([t(_healthLabel), '3.495%', '3.495%']),
          _TaxTableRow([t(_ltcLabel), t(_healthTimesLtc), t(_healthTimesLtc)]),
          _TaxTableRow([t(_employmentLabel), '0.9%', t(_variesByCompany)]),
          _TaxTableRow([
            t(_accidentLabel),
            t(_noneLabel),
            t(_variesByIndustry),
          ]),
        ],
      ),
      const SizedBox(height: 8),
      Text(
        switch (lang) {
          AppLanguage.ko =>
            '1) 4대보험 공제 시 근로자 부담률 합계는 약 ${(insuranceRate() * 100).toStringAsFixed(2)}%입니다. 월 60시간 미만 근로자는 가입 대상이 아니라 세금 차감이 없습니다.',
          AppLanguage.uz =>
            "1) 4 ta asosiy sugʻurta ushlab qolinganida, xodimning umumiy badal stavkasi taxminan ${(insuranceRate() * 100).toStringAsFixed(2)}% ni tashkil qiladi. Oyiga 60 soatdan kam ishlaydigan ishchilar roʻyxatdan oʻtishlari shart emas, shuning uchun hech qanday chegirma yoʻq.",
          AppLanguage.en =>
            "1) When the 4 Major Insurances are deducted, the employee's total contribution rate is about ${(insuranceRate() * 100).toStringAsFixed(2)}%. Workers under 60 hours/month are not required to enroll, so there is no deduction.",
          AppLanguage.tr =>
            "1) 4 Büyük Sigorta kesildiğinde, çalışanın toplam katkı oranı yaklaşık ${(insuranceRate() * 100).toStringAsFixed(2)}%'dir. Ayda 60 saatin altında çalışanların kaydolması gerekmez, bu nedenle kesinti yapılmaz.",
          AppLanguage.tg =>
            "1) Ҳангоми тарҳ кардани Суғуртаи калони 4, меъёри умумии саҳми корманд тақрибан ${(insuranceRate() * 100).toStringAsFixed(2)}% аст. Кормандоне, ки дар як моҳ камтар аз 60 соат кор мекунанд, ба қайд гирифтан лозим нест, аз ин рӯ тарҳ карда намешавад.",
          AppLanguage.fil =>
            "1) Kapag ibinawas ang 4 na Malaking Seguro, ang kabuuang rate ng kontribusyon ng empleyado ay humigit-kumulang ${(insuranceRate() * 100).toStringAsFixed(2)}%. Ang mga nagtatrabaho nang mas mababa sa 60 oras bawat buwan ay hindi kailangang magparehistro, kaya walang pagbabawas.",
          AppLanguage.ur =>
            "1) جب 4 بڑا بیمہ کاٹا جاتا ہے، تو ملازم کی کل شراکت کی شرح تقریباً ${(insuranceRate() * 100).toStringAsFixed(2)}% ہوتی ہے۔ جو لوگ ماہانہ 60 گھنٹے سے کم کام کرتے ہیں انہیں اندراج کرنے کی ضرورت نہیں ہوتی، لہذا کوئی کٹوتی نہیں کی جاتی۔",
          AppLanguage.th =>
            "1) เมื่อหักประกันหลัก 4 อัตราส่วนการสมทบรวมของพนักงานจะอยู่ที่ประมาณ ${(insuranceRate() * 100).toStringAsFixed(2)}% ผู้ที่ทำงานน้อยกว่า 60 ชั่วโมงต่อเดือนไม่จำเป็นต้องลงทะเบียน ดังนั้นจึงไม่มีการหักเงิน",
          AppLanguage.ky =>
            "1) 4 Чоң камсыздандыруу чегерилгенде, кызматкердин жалпы салымынын үлүшү болжол менен ${(insuranceRate() * 100).toStringAsFixed(2)}% түзөт. Ай сайын 60 сааттан аз иштегендер катталууга милдеттүү эмес, ошондуктан чегерүү жүргүзүлбөйт.",
          AppLanguage.km =>
            "1) នៅពេលដែលការធានារ៉ាប់រងធំ 4 ត្រូវបានកាត់ ភាគរយនៃការរួមចំណែកសរុបរបស់និយោជិតគឺប្រហែល ${(insuranceRate() * 100).toStringAsFixed(2)}%។ អ្នកដែលធ្វើការតិចជាង 60 ម៉ោងក្នុងមួយខែ មិនចាំបាច់ចុះឈ្មោះទេ ដូច្នេះហើយមិនមានការកាត់ទេ។",
          AppLanguage.id =>
            "1) Ketika Asuransi Besar 4 dipotong, tingkat kontribusi total karyawan adalah sekitar ${(insuranceRate() * 100).toStringAsFixed(2)}%. Mereka yang bekerja kurang dari 60 jam per bulan tidak perlu mendaftar, sehingga tidak ada potongan.",
          AppLanguage.si =>
            "1) 4 විශාල රක්ෂණය අඩු කළ විට, සේවකයාගේ මුළු දායකත්ව අනුපාතය දළ වශයෙන් ${(insuranceRate() * 100).toStringAsFixed(2)}% කි. මසකට පැය 60ට අඩුවෙන් වැඩ කරන අය ලියාපදිංචි විය යුතු නැත, එබැවින් අඩු කිරීමක් සිදු නොවේ.",
          AppLanguage.bn =>
            "1) যখন 4 প্রধান বীমা কেটে নেওয়া হয়, তখন কর্মচারীর মোট অবদানের হার প্রায় ${(insuranceRate() * 100).toStringAsFixed(2)}%। যারা মাসে 60 ঘন্টার কম কাজ করেন তাদের নিবন্ধন করার প্রয়োজন নেই, তাই কোনো কর্তন করা হয় না।",
          AppLanguage.my =>
            "1) 4 အကြီးစားအာမခံကို ဖြတ်တောက်ပါက ဝန်ထမ်း၏ စုစုပေါင်းထည့်ဝင်ငွေမှာ ခန့်မှန်းခြေ ${(insuranceRate() * 100).toStringAsFixed(2)}% ဖြစ်သည်။ တစ်လလျှင် 60 နာရီအောက် အလုပ်လုပ်သူများသည် စာရင်းသွင်းရန် မလိုအပ်သောကြောင့် ဖြတ်တောက်မှု မရှိပါ။",
          AppLanguage.mn =>
            "1) 4 том даатгалыг суутгахад ажилтны нийт хувь нэмрийн хэмжээ ойролцоогоор ${(insuranceRate() * 100).toStringAsFixed(2)}% байна. Сард 60 цагаас бага ажилладаг хүмүүс бүртгүүлэх шаардлагагүй тул суутгал хийгдэхгүй.",
          AppLanguage.lo =>
            "1) ເມື່ອຫັກປະກັນໄພໃຫຍ່ 4, ອັດຕາການປະກອບສ່ວນທັງໝົດຂອງພະນັກງານແມ່ນປະມານ ${(insuranceRate() * 100).toStringAsFixed(2)}%. ຜູ້ທີ່ເຮັດວຽກໜ້ອຍກວ່າ 60 ຊົ່ວໂມງຕໍ່ເດືອນບໍ່ຈຳເປັນຕ້ອງລົງທະບຽນ, ດັ່ງນັ້ນຈຶ່ງບໍ່ມີການຫັກ.",
          AppLanguage.tet =>
            "1) Bainhira dedús Seguru Boot 4, taxa kontribuisaun totál empregadu nian mak aprosimadamente ${(insuranceRate() * 100).toStringAsFixed(2)}%. Empregadu sira ne'ebé servisu menus husi 60 oras kada fulan la presiza rejista, tanba ne'e la iha dedusaun.",
          AppLanguage.ne =>
            "1) 4 प्रमुख बीमा कटौती गर्दा, कर्मचारीको कुल योगदान दर लगभग ${(insuranceRate() * 100).toStringAsFixed(2)}% हुन्छ। प्रति महिना 60 घण्टा भन्दा कम काम गर्ने कर्मचारीहरूले दर्ता गर्नुपर्दैन, त्यसैले कुनै कटौती गरिँदैन।",
          AppLanguage.zh =>
            '1) 扣除四大保险时，劳动者的负担率合计约为${(insuranceRate() * 100).toStringAsFixed(2)}%。每月工作不满60小时的劳动者不属于参保对象，故无税金扣除。',
          AppLanguage.vi =>
            '1) Khi khấu trừ 4 loại bảo hiểm, tổng tỷ lệ đóng góp của người lao động khoảng ${(insuranceRate() * 100).toStringAsFixed(2)}%. Người lao động dưới 60 giờ/tháng không thuộc đối tượng tham gia nên không bị khấu trừ.',
        },
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.textSecondary,
          height: 1.6,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        switch (lang) {
          AppLanguage.ko => '2) 소득세 3.3% 공제 = 소득세 3% + 지방소득세(소득세액의 10%)',
          AppLanguage.uz =>
            "2) 3,3% daromad soligʻi chegirmasi = 3% daromad soligʻi + mahalliy daromad soligʻi (daromad soligʻi miqdorining 10%)",
          AppLanguage.en =>
            '2) The 3.3% income tax deduction = 3% income tax + local income tax (10% of the income tax amount)',
          AppLanguage.tr =>
            "2) %3,3 gelir vergisi kesintisi = %3 gelir vergisi + yerel gelir vergisi (gelir vergisi miktarının %10'u)",
          AppLanguage.tg =>
            "2) Тарҳи андози даромад 3,3% = андози даромад 3% + андози даромади маҳаллӣ (10% аз маблағи андози даромад)",
          AppLanguage.fil =>
            "2) %3,3 pagbabawas ng buwis sa kita = %3 buwis sa kita + lokal na buwis sa kita (10% ng halaga ng buwis sa kita)",
          AppLanguage.ur =>
            "2) 3,3% انکم ٹیکس کٹوتی = 3% انکم ٹیکس + مقامی انکم ٹیکس (انکم ٹیکس کی رقم کا 10%)",
          AppLanguage.th =>
            "2) การหักภาษีเงินได้ 3,3% = ภาษีเงินได้ 3% + ภาษีเงินได้ท้องถิ่น (10% ของจำนวนภาษีเงินได้)",
          AppLanguage.ky =>
            "2) %3,3 киреше салыгын чегерүү = %3 киреше салыгы + жергиликтүү киреше салыгы (киреше салыгынын суммасынын %10)",
          AppLanguage.km =>
            "2) ការកាត់ពន្ធលើប្រាក់ចំណូល 3,3% = ពន្ធលើប្រាក់ចំណូល 3% + ពន្ធលើប្រាក់ចំណូលមូលដ្ឋាន (10% នៃចំនួនពន្ធលើប្រាក់ចំណូល)",
          AppLanguage.id =>
            "2) Potongan pajak penghasilan 3,3% = pajak penghasilan 3% + pajak penghasilan daerah (10% dari jumlah pajak penghasilan)",
          AppLanguage.si =>
            "2) 3,3% ආදායම් බදු අඩු කිරීම = 3% ආදායම් බදු + දේශීය ආදායම් බදු (ආදායම් බදු ප්‍රමාණයෙන් 10%)",
          AppLanguage.bn =>
            "2) 3,3% আয়কর কর্তন = 3% আয়কর + স্থানীয় আয়কর (আয়করের পরিমাণের 10%)",
          AppLanguage.my =>
            "2) 3,3% ဝင်ငွေခွန်ဖြတ်တောက်မှု = 3% ဝင်ငွေခွန် + ဒေသန္တရဝင်ငွေခွန် (ဝင်ငွေခွန်ပမာဏ၏ 10%)",
          AppLanguage.mn =>
            "2) 3,3% орлогын албан татварын суутгал = 3% орлогын албан татвар + орон нутгийн орлогын албан татвар (орлогын албан татварын дүнгийн 10%)",
          AppLanguage.lo =>
            "2) ການຫັກພາສີລາຍໄດ້ 3,3% = ພາສີລາຍໄດ້ 3% + ພາສີລາຍໄດ້ທ້ອງຖິ່ນ (10% ຂອງຈຳນວນພາສີລາຍໄດ້)",
          AppLanguage.tet =>
            "2) Dedusaun impostu rendimentu 3,3% = impostu rendimentu 3% + impostu rendimentu lokál (10% husi montante impostu rendimentu)",
          AppLanguage.ne =>
            "2) 3.3% आयकर कटौती = 3% आयकर + स्थानीय आयकर (आयकर रकमको 10%)",
          AppLanguage.zh => '2) 所得税3.3%扣除 = 所得税3% + 地方所得税（所得税额的10%）',
          AppLanguage.vi =>
            '2) Khấu trừ thuế thu nhập 3,3% = thuế thu nhập 3% + thuế thu nhập địa phương (10% số thuế thu nhập)',
        },
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.textSecondary,
          height: 1.6,
        ),
      ),
    ],
  );
}

class _E {
  const _E(this.title, this.body);
  final L10nText title;
  final L10nText body;
}

const _entries = {
  'pm_month': _E(
    L10nText(
      ko: '이번달만 확인',
      en: 'Check this month only',
      tr: "Sadece bu ayı kontrol et",
      tg: "Танҳо ин моҳро тафтиш кунед",
      fil: "Suriin lamang ang buwang ito",
      ur: "صرف اس مہینے کی جانچ کریں",
      th: "ตรวจสอบเฉพาะเดือนนี้",
      ky: "Бул айды гана текшерүү",
      km: "ពិនិត្យតែខែនេះ",
      id: "Periksa hanya bulan ini",
      si: "මෙම මාසය පමණක් පරීක්ෂා කරන්න",
      bn: "শুধুমাত্র এই মাসটি পরীক্ষা করুন",
      my: "ဒီလအတွက်ပဲ စစ်ဆေးပါ",
      mn: "Зөвхөн энэ сарыг шалгах",
      lo: "ກວດສອບສະເພາະເດືອນນີ້",
      tet: "Verifika fulan ida-ne'e de'it",
      ne: "यो महिना मात्र जाँच गर्नुहोस्",
      zh: '仅确认本月',
      vi: 'Chỉ kiểm tra tháng này',
      uz: "Faqat shu oyni tekshirish",
    ),
    L10nText(
      ko: '이번 달 1개월치 급여 및 체불 내역만 정산합니다.',
      en: "Settles only this month's pay and any unpaid amount.",
      tr: "Yalnızca bu ayın maaşını ve ödenmemiş tutarı hesaplar.",
      tg: "Танҳо музди меҳнати ин моҳ ва маблағи пардохтнашударо ҳисоб мекунад.",
      fil:
          "Kinakalkula lamang ang sahod at hindi nabayarang halaga para sa buwang ito.",
      ur: "صرف اس مہینے کی تنخواہ اور غیر ادا شدہ رقم کا حساب لگاتا ہے۔",
      th: "คำนวณเฉพาะเงินเดือนและจำนวนเงินที่ยังไม่ได้รับชำระของเดือนนี้",
      ky: "Бул айдын гана эмгек акысын жана төлөнбөгөн сумманы эсептейт.",
      km: "គណនាប្រាក់ឈ្នួល និងចំនួនទឹកប្រាក់ដែលមិនទាន់បានបង់សម្រាប់តែខែនេះប៉ុណ្ណោះ។",
      id: "Hanya menghitung gaji bulan ini dan jumlah yang belum dibayar.",
      si: "මෙම මාසයේ වැටුප සහ නොගෙවූ මුදල පමණක් ගණනය කරයි.",
      bn: "শুধুমাত্র এই মাসের বেতন এবং অপরিশোধিত পরিমাণ গণনা করে।",
      my: "ဒီလအတွက် လစာနဲ့ မပေးရသေးတဲ့ ပမာဏကိုသာ တွက်ချက်ပါမည်။",
      mn: "Зөвхөн энэ сарын цалин болон төлөгдөөгүй дүнг тооцно.",
      lo: "ຄິດໄລ່ສະເພາະຄ່າຈ້າງຂອງເດືອນນີ້ ແລະຈຳນວນທີ່ຍັງຄ້າງຈ່າຍ.",
      tet:
          "Kalkula de'it saláriu fulan ida-ne'e no montante ne'ebé seidauk selu.",
      ne: "यस महिनाको तलब मात्र र भुक्तान नगरिएको रकम गणना गर्छ।",
      zh: '仅结算本月一个月的工资和欠薪情况。',
      vi: 'Chỉ tính lương và tình trạng nợ lương của 1 tháng này.',
      uz: "Faqat shu oyning ish haqi va toʻlanmagan summani hisoblaydi.",
    ),
  ),
  'pm_multi': _E(
    L10nText(
      ko: '여러달 체불 확인',
      en: 'Check unpaid wages over several months',
      tr: "Birkaç aylık ödenmemiş ücretleri kontrol edin",
      tg: "Музди меҳнати пардохтнашударо барои якчанд моҳ тафтиш кунед",
      fil: "Suriin ang hindi nabayarang sahod sa loob ng ilang buwan",
      ur: "کئی مہینوں کی غیر ادا شدہ اجرتوں کی جانچ کریں",
      th: "ตรวจสอบค่าจ้างที่ยังไม่ได้รับชำระหลายเดือน",
      ky: "Бир нече айлык төлөнбөгөн эмгек акыны текшерүү",
      km: "ពិនិត្យប្រាក់ឈ្នួលដែលមិនទាន់បានបង់សម្រាប់រយៈពេលជាច្រើនខែ",
      id: "Periksa upah yang belum dibayar selama beberapa bulan",
      si: "මාස කිහිපයක නොගෙවූ වැටුප් පරීක්ෂා කරන්න",
      bn: "কয়েক মাসের অপরিশোধিত মজুরি পরীক্ষা করুন",
      my: "လပေါင်းများစွာ မပေးရသေးသော လုပ်ခများကို စစ်ဆေးပါ",
      mn: "Хэдэн сарын төлөгдөөгүй цалинг шалгах",
      lo: "ກວດສອບຄ່າຈ້າງທີ່ຍັງຄ້າງຈ່າຍຫຼາຍເດືອນ",
      tet: "Verifika saláriu ne'ebé seidauk selu ba fulan balun",
      ne: "धेरै महिनाको भुक्तान नगरिएको ज्याला जाँच गर्नुहोस्",
      zh: '确认多个月的欠薪',
      vi: 'Kiểm tra nợ lương nhiều tháng',
      uz: "Bir necha oylik toʻlanmagan ish haqini tekshirish",
    ),
    L10nText(
      ko: '최근 몇 개월 동안 급여가 밀렸는지 선택합니다. 입력하는 근무시간과 입금액은 해당 개월 수 전체의 합계입니다.',
      en: 'Choose how many recent months your pay has been delayed. The work hours and amounts you enter should be the total across all those months.',
      tr: "Maaşınızın kaç aydır geciktiğini seçin. Girdiğiniz çalışma saatleri ve tutarlar, tüm bu ayların toplamı olmalıdır.",
      tg: "Интихоб кунед, ки музди меҳнати шумо чанд моҳ қафо мондааст. Соатҳои корӣ ва маблағҳое, ки шумо ворид мекунед, бояд ҷамъи ин ҳама моҳҳо бошанд.",
      fil:
          "Piliin kung ilang buwan na ang iyong sahod ay huli. Ang mga oras ng trabaho at halagang inilagay mo ay dapat na kabuuan para sa lahat ng mga buwang ito.",
      ur: "منتخب کریں کہ آپ کی تنخواہ کتنے مہینوں سے تاخیر کا شکار ہے۔ آپ کے درج کردہ کام کے اوقات اور رقم ان تمام مہینوں کا مجموعہ ہونی چاہیے۔",
      th: "เลือกจำนวนเดือนที่เงินเดือนของคุณล่าช้า ชั่วโมงทำงานและจำนวนเงินที่คุณป้อนควรเป็นยอดรวมสำหรับทุกเดือนเหล่านี้",
      ky: "Эмгек акыңыз канча айга кечиктирилгенин тандаңыз. Сиз киргизген иш сааттары жана суммалар ошол айлардын бардыгынын жалпы суммасы болушу керек.",
      km: "ជ្រើសរើសចំនួនខែដែលប្រាក់ឈ្នួលរបស់អ្នកត្រូវបានពន្យារពេល។ ម៉ោងធ្វើការ និងចំនួនទឹកប្រាក់ដែលអ្នកបានបញ្ចូលគួរតែជាចំនួនសរុបសម្រាប់ខែទាំងអស់នេះ។",
      id: "Pilih berapa bulan gaji Anda tertunda. Jam kerja dan jumlah yang Anda masukkan harus merupakan total dari semua bulan tersebut.",
      si: "ඔබේ වැටුප කොපමණ මාස ගණනක් ප්‍රමාද වී ඇත්දැයි තෝරන්න. ඔබ ඇතුළත් කරන වැඩ කරන වේලාවන් සහ මුදල් එම සියලු මාසවල එකතුව විය යුතුය.",
      bn: "আপনার বেতন কত মাস ধরে বকেয়া আছে তা নির্বাচন করুন। আপনার প্রবেশ করা কাজের সময় এবং পরিমাণ এই সমস্ত মাসের মোট হওয়া উচিত।",
      my: "သင့်လစာ ဘယ်နှစ်လ နောက်ကျနေလဲဆိုတာ ရွေးချယ်ပါ။ သင်ထည့်သွင်းထားသော အလုပ်ချိန်နှင့် ပမာဏများသည် ထိုလများအားလုံး၏ စုစုပေါင်းဖြစ်ရပါမည်။",
      mn: "Таны цалин хэдэн сараар хоцорсныг сонгоно уу. Таны оруулсан ажлын цаг болон дүн нь эдгээр бүх сарын нийлбэр байх ёстой.",
      lo: "ເລືອກວ່າຄ່າຈ້າງຂອງທ່ານຄ້າງຈ່າຍຈັກເດືອນ. ຊົ່ວໂມງເຮັດວຽກ ແລະຈຳນວນເງິນທີ່ທ່ານປ້ອນຕ້ອງເປັນຍອດລວມຂອງທຸກໆເດືອນເຫຼົ່ານີ້.",
      tet:
          "Hili hira fulan ona mak ó nia saláriu tarde. Oras serbisu no montante ne'ebé ó hatama tenke sai totál ba fulan sira-ne'e hotu.",
      ne: "तपाईंको तलब कति महिनादेखि ढिलो भएको छ, छान्नुहोस्। तपाईंले प्रविष्ट गर्नुभएको कामको घण्टा र रकमहरू, यी सबै महिनाहरूको कुल योग हुनुपर्छ।",
      zh: '选择最近几个月工资被拖欠的情况。您输入的工作时间和到账金额应为这些月份的总计。',
      vi: 'Chọn số tháng gần đây bị chậm lương. Giờ làm và số tiền bạn nhập là tổng cộng của toàn bộ số tháng đó.',
      uz: "Ish haqingiz necha oydan beri kechikayotganini tanlang. Siz kiritgan ish soatlari va miqdorlari barcha oylar boʻyicha umumiy boʻlishi kerak.",
    ),
  ),
  'pm_range': _E(
    L10nText(
      ko: '기간 직접 지정',
      en: 'Set a custom period',
      tr: "Özel bir dönem belirleyin",
      tg: "Давраи мушаххасро муайян кунед",
      fil: "Magtakda ng partikular na panahon",
      ur: "ایک مخصوص مدت مقرر کریں",
      th: "กำหนดช่วงเวลาที่เฉพาะเจาะจง",
      ky: "Өзгөчө мезгилди белгилөө",
      km: "កំណត់រយៈពេលជាក់លាក់មួយ",
      id: "Tentukan periode khusus",
      si: "විශේෂිත කාලසීමාවක් සකසන්න",
      bn: "একটি নির্দিষ্ট সময়কাল সেট করুন",
      my: "သတ်မှတ်ထားသော ကာလတစ်ခုကို သတ်မှတ်ပါ",
      mn: "Тодорхой хугацааг тохируулах",
      lo: "ກໍານົດໄລຍະເວລາສະເພາະ",
      tet: "Define períodu espesífiku",
      ne: "एक विशेष अवधि तोक्नुहोस्",
      zh: '自定义期间',
      vi: 'Tự chọn khoảng thời gian',
      uz: "Maxsus davrni belgilash",
    ),
    L10nText(
      ko: '체불이 시작된 월부터 종료된 월까지 설정합니다. 임금채권 소멸시효는 3년입니다.',
      en: 'Set the month the unpaid wages started and the month they ended. Wage claims expire after 3 years.',
      tr: "Ödenmemiş ücretlerin başladığı ayı ve bittiği ayı belirleyin. Ücret alacakları 3 yıl sonra zaman aşımına uğrar.",
      tg: "Моҳеро, ки музди меҳнати пардохтнашуда оғоз ёфтааст ва моҳеро, ки ба охир расидааст, муайян кунед. Қарзҳои музди меҳнат пас аз 3 сол мӯҳлати амали худро аз даст медиҳанд.",
      fil:
          "Itakda ang buwan kung kailan nagsimula at natapos ang hindi nabayarang sahod. Ang mga claim sa sahod ay nag-e-expire pagkatapos ng 3 taon.",
      ur: "وہ مہینہ مقرر کریں جب غیر ادا شدہ اجرتیں شروع ہوئیں اور وہ مہینہ جب وہ ختم ہوئیں۔ اجرت کے دعوے 3 سال بعد ختم ہو جاتے ہیں۔",
      th: "กำหนดเดือนที่ค่าจ้างที่ยังไม่ได้รับชำระเริ่มต้นและเดือนที่สิ้นสุด การเรียกร้องค่าจ้างจะหมดอายุหลังจาก 3 ปี",
      ky: "Төлөнбөгөн эмгек акы башталган айды жана аяктаган айды белгилеңиз. Эмгек акы талаптары 3 жылдан кийин мөөнөтү өтүп кетет.",
      km: "កំណត់ខែដែលប្រាក់ឈ្នួលមិនទាន់បានបង់បានចាប់ផ្តើម និងខែដែលវាបានបញ្ចប់។ ការទាមទារប្រាក់ឈ្នួលនឹងផុតកំណត់បន្ទាប់ពី 3 ឆ្នាំ។",
      id: "Tentukan bulan dimulainya dan bulan berakhirnya upah yang belum dibayar. Klaim upah akan kedaluwarsa setelah 3 tahun.",
      si: "නොගෙවූ වැටුප් ආරම්භ වූ මාසය සහ අවසන් වූ මාසය සඳහන් කරන්න. වැටුප් හිඟ මුදල් වසර 3 කට පසු කල් ඉකුත් වේ.",
      bn: "অপরিশোধিত মজুরি শুরু হওয়ার মাস এবং শেষ হওয়ার মাস সেট করুন। মজুরি দাবি 3 বছর পর মেয়াদোত্তীর্ণ হয়।",
      my: "မပေးရသေးသော လုပ်ခများ စတင်သည့်လနှင့် ပြီးဆုံးသည့်လကို သတ်မှတ်ပါ။ လုပ်ခကြွေးများသည် 3 နှစ်အကြာတွင် သက်တမ်းကုန်ဆုံးပါသည်။",
      mn: "Төлөгдөөгүй цалин эхэлсэн сар болон дууссан сарыг тохируулна уу. Цалингийн нэхэмжлэл 3 жилийн дараа хугацаа дуусна.",
      lo: "ກໍານົດເດືອນທີ່ຄ່າຈ້າງທີ່ຍັງຄ້າງຈ່າຍເລີ່ມຕົ້ນ ແລະເດືອນທີ່ສິ້ນສຸດ. ການຮຽກຮ້ອງຄ່າຈ້າງຈະໝົດອາຍຸຫຼັງຈາກ 3 ປີ.",
      tet:
          "Define fulan ne'ebé saláriu ne'ebé seidauk selu hahú no fulan ne'ebé remata. Direitu ba saláriu sei preskreve depois tinan 3.",
      ne: "भुक्तान नगरिएको ज्याला सुरु भएको महिना र समाप्त भएको महिना तोक्नुहोस्। ज्याला दाबीहरू 3 वर्ष पछि समय सीमा समाप्त हुन्छन्।",
      zh: '设置欠薪开始月份和结束月份。工资债权的诉讼时效为3年。',
      vi: 'Đặt tháng bắt đầu và tháng kết thúc nợ lương. Thời hiệu yêu cầu tiền lương là 3 năm.',
      uz: "Toʻlanmagan ish haqi boshlangan va tugagan oyni belgilang. Ish haqi daʼvolari 3 yildan keyin tugaydi.",
    ),
  ),
  'biz_size': _E(
    L10nText(
      ko: '사업장 규모 기준',
      en: 'Business size criteria',
      tr: "İşletme büyüklüğü kriterleri",
      tg: "Меъёрҳои андозаи корхона",
      fil: "Pamantayan sa laki ng negosyo",
      ur: "کاروباری سائز کے معیار",
      th: "เกณฑ์ขนาดธุรกิจ",
      ky: "Ишкананын көлөмү критерийлери",
      km: "លក្ខណៈវិនិច្ឆ័យទំហំអាជីវកម្ម",
      id: "Kriteria ukuran bisnis",
      si: "ව්‍යාපාර ප්‍රමාණයේ නිර්ණායක",
      bn: "ব্যবসার আকারের মানদণ্ড",
      my: "လုပ်ငန်းအရွယ်အစား သတ်မှတ်ချက်များ",
      mn: "Бизнесийн хэмжээний шалгуур",
      lo: "ມາດຖານຂະໜາດທຸລະກິດ",
      tet: "Kritériu tamañu empreza",
      ne: "व्यवसायको आकार मापदण्ड",
      zh: '企业规模标准',
      vi: 'Tiêu chí quy mô doanh nghiệp',
      uz: "Korxona hajmi mezonlari",
    ),
    L10nText(
      ko:
          '<b>• 5인 이상:</b> 연장·야간·휴일근로 가산수당(1.5배~2배) 적용.<br>'
          '<b>• 5인 미만:</b> 가산수당 미적용 (일한 시간만큼 1.0배 지급).<br>'
          '<b>• 잘 모르겠어요:</b> 근로자에게 불리하지 않도록 5인 미만 기준으로 보수적으로 계산합니다. 정확한 인원은 임금명세서나 4대보험 가입자 수로 확인할 수 있어요.',
      en:
          '<b>• 5+ employees:</b> overtime/night/holiday premium pay (1.5x–2x) applies.<br>'
          '<b>• Fewer than 5:</b> no premium pay (paid 1.0x for hours worked).<br>'
          "<b>• Not sure:</b> calculated conservatively as under-5 so it doesn't disadvantage you. You can check the exact headcount via your payslip or 4-major-insurance enrollment count.",
      tr: "<b>• 5+ çalışan:</b> fazla mesai/gece/tatil primi (1.5x–2x) uygulanır.<br><b>• 5'ten az:</b> prim ödemesi yok (çalışılan saatler için 1.0x ödenir).<br><b>• Emin değilim:</b> aleyhinize olmaması için 5'ten az olarak muhafazakar bir şekilde hesaplanır. Tam çalışan sayısını maaş bordronuzdan veya 4 ana sigorta kayıt sayısından kontrol edebilirsiniz.",
      tg: "<b>• Кормандони 5+:</b> мукофоти изофакорӣ/шабона/ид (1.5x–2x) татбиқ мешавад.<br><b>• Камтар аз 5:</b> пардохти мукофотпулӣ нест (барои соатҳои корӣ 1.0x пардохт мешавад).<br><b>• Мутмаин нестам:</b> барои он ки ба зарари шумо набошад, консервативӣ ҳамчун камтар аз 5 ҳисоб карда мешавад. Шумо метавонед шумораи дақиқи кормандонро аз варақаи музди меҳнат ё рақами бақайдгирии суғуртаи асосии 4 тафтиш кунед.",
      fil:
          "<b>• 5+ empleyado:</b> overtime/gabi/holiday premium (1.5x–2x) ay inilalapat.<br><b>• Mas mababa sa 5:</b> walang premium na bayad (binabayaran ng 1.0x para sa mga oras na nagtrabaho).<br><b>• Hindi sigurado:</b> kinakalkula nang konserbatibo bilang mas mababa sa 5 upang hindi ka mapinsala. Maaari mong suriin ang eksaktong bilang ng empleyado mula sa iyong payslip o sa 4 bilang ng rehistro ng pangunahing seguro.",
      ur: "<b>• 5+ ملازمین:</b> اوور ٹائم/رات/چھٹی کا پریمیم (1.5x–2x) لاگو ہوتا ہے۔<br><b>• 5 سے کم:</b> کوئی پریمیم ادائیگی نہیں (کام کے اوقات کے لیے 1.0x ادا کیا جاتا ہے)۔<br><b>• یقین نہیں:</b> آپ کے نقصان سے بچنے کے لیے 5 سے کم کے طور پر قدامت پسندانہ حساب لگایا جاتا ہے۔ آپ اپنے پے سلپ یا 4 کے مرکزی بیمہ ریکارڈ کی تعداد سے ملازمین کی صحیح تعداد کی جانچ کر سکتے ہیں۔",
      th: "<b>• พนักงาน 5 คนขึ้นไป:</b> มีการจ่ายค่าล่วงเวลา/กลางคืน/วันหยุดพิเศษ (1.5x–2x)<br><b>• น้อยกว่า 5 คน:</b> ไม่มีค่าจ้างพิเศษ (จ่าย 1.0x สำหรับชั่วโมงทำงาน)<br><b>• ไม่แน่ใจ:</b> คำนวณแบบอนุรักษ์นิยมว่าน้อยกว่า 5 คน เพื่อไม่ให้เสียเปรียบ คุณสามารถตรวจสอบจำนวนพนักงานที่แน่นอนได้จากสลิปเงินเดือนของคุณ หรือจากจำนวนการลงทะเบียนประกันหลัก 4",
      ky: "<b>• 5+ кызматкер:</b> ашыкча иштөө/түнкү/майрамдык кошумча төлөм (1.5x–2x) колдонулат.<br><b>• 5ден аз:</b> кошумча төлөм жок (иштелген сааттар үчүн 1.0x төлөнөт).<br><b>• Ишенбейм:</b> сизге каршы болбошу үчүн 5тен аз деп консервативдүү эсептелет. Кызматкерлердин так санын эмгек акы ведомостуңуздан же 4 негизги камсыздандыруу каттоо санынан текшере аласыз.",
      km: "<b>• និយោជិត 5+ នាក់៖</b> ប្រាក់បន្ថែមម៉ោង/ពេលយប់/ថ្ងៃឈប់សម្រាក (1.5x–2x) ត្រូវបានអនុវត្ត។<br><b>• និយោជិតតិចជាង 5 នាក់៖</b> គ្មានប្រាក់បន្ថែម (បង់ 1.0x សម្រាប់ម៉ោងធ្វើការ)។<br><b>• មិនប្រាកដ៖</b> ត្រូវបានគណនាដោយប្រុងប្រយ័ត្នថាមានតិចជាង 5 នាក់ ដើម្បីកុំឱ្យប៉ះពាល់ដល់អ្នក។ អ្នកអាចពិនិត្យមើលចំនួននិយោជិតពិតប្រាកដពីប័ណ្ណបើកប្រាក់ខែរបស់អ្នក ឬពីចំនួនចុះឈ្មោះធានារ៉ាប់រងសំខាន់ 4។",
      id: "<b>• 5+ karyawan:</b> premi lembur/malam/libur (1.5x–2x) berlaku.<br><b>• Kurang dari 5:</b> tidak ada pembayaran premi (dibayar 1.0x untuk jam kerja).<br><b>• Tidak yakin:</b> dihitung secara konservatif sebagai kurang dari 5 agar tidak merugikan Anda. Anda dapat memeriksa jumlah karyawan yang tepat dari slip gaji Anda atau nomor pendaftaran asuransi utama 4.",
      si: "<b>• 5+ සේවකයින්:</b> අතිකාල/රාත්‍රී/නිවාඩු වාරිකය (1.5x–2x) අදාළ වේ.<br><b>• 5 ට අඩු:</b> වාරික ගෙවීමක් නැත (වැඩ කරන වේලාවන් සඳහා 1.0x ගෙවනු ලැබේ).<br><b>• මට විශ්වාස නැත:</b> ඔබට අවාසිදායක නොවන පරිදි 5 ට අඩු ලෙස ගතානුගතිකව ගණනය කෙරේ. ඔබට ඔබේ වැටුප් පත්‍රිකාවෙන් හෝ 4 ප්‍රධාන රක්ෂණ වාර්තා අංකයෙන් සේවකයින්ගේ නිශ්චිත සංඛ්‍යාව පරීක්ෂා කළ හැක.",
      bn: "<b>• 5+ কর্মচারী:</b> ওভারটাইম/রাত্রি/ছুটির প্রিমিয়াম (1.5x–2x) প্রযোজ্য।<br><b>• 5 এর কম:</b> কোনো প্রিমিয়াম প্রদান করা হয় না (কাজ করা ঘন্টার জন্য 1.0x প্রদান করা হয়)।<br><b>• নিশ্চিত নই:</b> আপনার প্রতিকূলে না হওয়ার জন্য 5 এর কম হিসাবে রক্ষণশীলভাবে গণনা করা হয়। আপনি আপনার বেতন স্লিপ বা 4 প্রধান বীমা নিবন্ধন সংখ্যা থেকে সঠিক কর্মচারীর সংখ্যা পরীক্ষা করতে পারেন।",
      my: "<b>• ဝန်ထမ်း 5 ဦးနှင့်အထက်- </b> အချိန်ပို/ညပိုင်း/အားလပ်ရက် ပရီမီယံ (1.5x–2x) အကျုံးဝင်ပါသည်။<br><b>• 5 ဦးအောက်- </b> ပရီမီယံပေးချေမှု မရှိပါ (အလုပ်လုပ်ခဲ့သော နာရီများအတွက် 1.0x ပေးချေပါသည်)။<br><b>• မသေချာပါ- </b> သင့်အတွက် အဆင်မပြေမှု မဖြစ်စေရန် 5 ဦးအောက်ဟု သတ်မှတ်၍ သတိထားပြီး တွက်ချက်ထားပါသည်။ သင့်လစာစာရင်း သို့မဟုတ် 4 ပင်မအာမခံ မှတ်တမ်းစာမျက်နှာမှ အတိအကျ ဝန်ထမ်းအရေအတွက်ကို စစ်ဆေးနိုင်ပါသည်။",
      mn: "<b>• 5+ ажилтан:</b> илүү цаг/шөнийн/амралтын өдрийн нэмэгдэл (1.5x–2x) хэрэглэгдэнэ.<br><b>• 5-оос бага:</b> нэмэгдэл төлбөр байхгүй (ажилласан цагийн хувьд 1.0x төлөгдөнө).<br><b>• Эргэлзэж байна:</b> танд сөрөг нөлөө үзүүлэхгүйн тулд 5-оос бага гэж консерватив байдлаар тооцно. Та ажилчдын тоог цалингийн хуудас эсвэл 4 үндсэн даатгалын бүртгэлийн дугаараас шалгаж болно.",
      lo: "<b>• ພະນັກງານ 5+ ຄົນ:</b> ຄ່າລ່ວງເວລາ/ກາງຄືນ/ວັນພັກ (1.5x–2x) ຖືກນຳໃຊ້.<br><b>• ໜ້ອຍກວ່າ 5 ຄົນ:</b> ບໍ່ມີການຈ່າຍເງິນພິເສດ (ຈ່າຍ 1.0x ສໍາລັບຊົ່ວໂມງເຮັດວຽກ).<br><b>• ບໍ່ແນ່ໃຈ:</b> ຖືກຄິດໄລ່ແບບລະມັດລະວັງວ່າໜ້ອຍກວ່າ 5 ເພື່ອບໍ່ໃຫ້ເປັນຜົນຮ້າຍຕໍ່ທ່ານ. ທ່ານສາມາດກວດສອບຈໍານວນພະນັກງານທັງໝົດຈາກໃບແຈ້ງເງິນເດືອນຂອງທ່ານ ຫຼື ຈາກຈໍານວນການລົງທະບຽນປະກັນໄພຫຼັກ 4.",
      tet:
          "<b>• Empregadu 5+:</b> prémiu oras estra/kalan/ferias (1.5x–2x) aplika.<br><b>• Menus husi 5:</b> la iha pagamentu prémiu (selu 1.0x ba oras serbisu).<br><b>• La iha serteza:</b> kalkula konservadoramente hanesan menus husi 5 atu labele prejudika ó. Ó bele verifika númeru empregadu kompletu husi ó nia folha saláriu ka númeru rejistu seguru prinsipal 4.",
      ne: "<b>• 5+ कर्मचारी:</b> ओभरटाइम/रात/बिदाको प्रिमियम (1.5x–2x) लागू हुन्छ।<br><b>• 5 भन्दा कम:</b> प्रिमियम भुक्तानी छैन (काम गरेको घण्टाको लागि 1.0x भुक्तानी गरिन्छ)।<br><b>• निश्चित छैन:</b> तपाईंको विपक्षमा नहोस् भनेर 5 भन्दा कमको रूपमा रूढिवादी तरिकाले गणना गरिन्छ। तपाईंले आफ्नो तलब पर्ची वा 4 मुख्य बीमा दर्ता संख्याबाट कुल कर्मचारी संख्या जाँच गर्न सक्नुहुन्छ।",
      zh:
          '<b>• 5人以上：</b>适用加班·夜间·休息日加班津贴（1.5倍~2倍）。<br>'
          '<b>• 5人以下：</b>不适用加成津贴（按工作时间1.0倍支付）。<br>'
          '<b>• 不确定：</b>为避免对劳动者不利，暂按5人以下的标准保守计算。准确人数可通过工资单或四大保险参保人数确认。',
      vi:
          '<b>• Từ 5 người trở lên:</b> áp dụng phụ cấp làm thêm/đêm/ngày nghỉ (1,5–2 lần).<br>'
          '<b>• Dưới 5 người:</b> không áp dụng phụ cấp (trả 1,0 lần theo giờ làm).<br>'
          '<b>• Không chắc:</b> tính bảo thủ theo mức dưới 5 người để không bất lợi cho người lao động. Có thể xác nhận số người chính xác qua phiếu lương hoặc số người tham gia 4 loại bảo hiểm.',
      uz: "<b>• 5+ xodim:</b> ishdan tashqari/tungi/bayram kunlari uchun qoʻshimcha haq (1,5x–2x) qoʻllaniladi.<br><b>• 5 dan kam:</b> qoʻshimcha haq yoʻq (ishlagan soatlar uchun 1,0x toʻlanadi).<br><b>• Aniq emas:</b> sizga zarar yetkazmaslik uchun 5 dan kam deb konservativ hisoblanadi. Aniq xodimlar sonini ish haqi varaqangiz yoki 4 ta asosiy sugʻurta roʻyxatga olish soni orqali tekshirishingiz mumkin.",
    ),
  ),
  'week_h': _E(
    L10nText(
      ko: '주당 약정 근로시간',
      en: 'Contracted weekly hours',
      tr: "Sözleşmeli haftalık saatler",
      tg: "Соатҳои ҳафтаинаи шартномавӣ",
      fil: "Lingguhang oras na nakasaad sa kontrata",
      ur: "معاہدے کے مطابق ہفتہ وار اوقات",
      th: "ชั่วโมงการทำงานต่อสัปดาห์ตามสัญญา",
      ky: "Келишим боюнча жумалык сааттар",
      km: "ម៉ោងប្រចាំសប្តាហ៍តាមកិច្ចសន្យា",
      id: "Jam mingguan yang dikontrak",
      si: "කොන්ත්‍රාත්ගත සතිපතා පැය ගණන",
      bn: "চুক্তিবদ্ধ সাপ্তাহিক কাজের সময়",
      my: "သဘောတူထားသော အပတ်စဉ် နာရီများ",
      mn: "Долоо хоногийн гэрээт цаг",
      lo: "ຊົ່ວໂມງຕໍ່ອາທິດຕາມສັນຍາ",
      tet: "Oras semana-semana kontratadu",
      ne: "अनुबन्धित साप्ताहिक घण्टा",
      zh: '每周约定工作时间',
      vi: 'Giờ làm theo tuần đã thỏa thuận',
      uz: "Shartnomaviy haftalik soatlar",
    ),
    L10nText(
      ko: '근로계약서상 일하기로 약정한 주당 시간입니다. (월급제 기본값 40시간 = 월 209시간)',
      en: 'The weekly hours agreed in your employment contract. (Default for monthly pay: 40 hrs/week = 209 hrs/month)',
      tr: "İş sözleşmenizde anlaşılan haftalık çalışma saatleri. (Aylık maaş için varsayılan: 40 saat/hafta = 209 saat/ay)",
      tg: "Соатҳои кории ҳафтаина, ки дар шартномаи меҳнатии шумо мувофиқа шудаанд. (Барои музди меҳнати моҳона пешфарз: 40 соат/ҳафта = 209 соат/моҳ)",
      fil:
          "Ang lingguhang oras ng trabaho na napagkasunduan sa iyong kontrata sa trabaho. (Default para sa buwanang sahod: 40 oras/linggo = 209 oras/buwan)",
      ur: "آپ کے ملازمت کے معاہدے میں طے شدہ ہفتہ وار کام کے اوقات۔ (ماہانہ تنخواہ کے لیے ڈیفالٹ: 40 گھنٹے/ہفتہ = 209 گھنٹے/مہینہ)",
      th: "ชั่วโมงทำงานต่อสัปดาห์ที่ตกลงกันในสัญญาจ้างงานของคุณ (สำหรับเงินเดือนรายเดือน ค่าเริ่มต้น: 40 ชั่วโมง/สัปดาห์ = 209 ชั่วโมง/เดือน)",
      ky: "Эмгек келишимиңизде макулдашылган жумалык иш сааттары. (Айлык эмгек акы үчүн демейки: 40 саат/жума = 209 саат/ай)",
      km: "ម៉ោងធ្វើការប្រចាំសប្តាហ៍ដែលបានព្រមព្រៀងក្នុងកិច្ចសន្យាការងាររបស់អ្នក។ (លំនាំដើមសម្រាប់ប្រាក់ខែប្រចាំខែ៖ 40 ម៉ោង/សប្តាហ៍ = 209 ម៉ោង/ខែ)",
      id: "Jam kerja mingguan yang disepakati dalam kontrak kerja Anda. (Default untuk gaji bulanan: 40 jam/minggu = 209 jam/bulan)",
      si: "ඔබේ රැකියා කොන්ත්‍රාත්තුවේ එකඟ වූ සතිපතා වැඩ කරන වේලාවන්. (මාසික වැටුප සඳහා පෙරනිමි: සතියකට පැය 40 = මසකට පැය 209)",
      bn: "আপনার কর্মসংস্থান চুক্তিতে সম্মত সাপ্তাহিক কাজের সময়। (মাসিক বেতনের জন্য ডিফল্ট: 40 ঘন্টা/সপ্তাহ = 209 ঘন্টা/মাস)",
      my: "သင်၏ အလုပ်ခန့်စာချုပ်တွင် သဘောတူထားသော အပတ်စဉ် အလုပ်ချိန်။ (လစဉ်လစာအတွက် မူရင်း- 40 နာရီ/အပတ် = 209 နာရီ/လ)",
      mn: "Таны хөдөлмөрийн гэрээнд тохиролцсон долоо хоногийн ажлын цаг. (Сарын цалингийн хувьд анхдагч утга: 40 цаг/долоо хоног = 209 цаг/сар)",
      lo: "ຊົ່ວໂມງເຮັດວຽກຕໍ່ອາທິດທີ່ຕົກລົງກັນໃນສັນຍາຈ້າງງານຂອງທ່ານ. (ຄ່າເລີ່ມຕົ້ນສໍາລັບເງິນເດືອນ: 40 ຊົ່ວໂມງ/ອາທິດ = 209 ຊົ່ວໂມງ/ເດືອນ)",
      tet:
          "Oras serbisu semana-semana ne'ebé akordu iha ó nia kontratu serbisu. (Default ba saláriu fulan-fulan: 40 oras/semana = 209 oras/fulan)",
      ne: "तपाईंको रोजगार सम्झौतामा सहमत साप्ताहिक कामको घण्टा। (मासिक तलबको लागि पूर्वनिर्धारित: 40 घण्टा/हप्ता = 209 घण्टा/महिना)",
      zh: '劳动合同中约定的每周工作时间。（月薪制默认值：每周40小时 = 每月209小时）',
      vi: 'Số giờ mỗi tuần đã thỏa thuận trong hợp đồng lao động. (Mặc định cho lương tháng: 40 giờ/tuần = 209 giờ/tháng)',
      uz: "Mehnat shartnomangizda kelishilgan haftalik ish soatlari. (Oylik ish haqi uchun standart: haftasiga 40 soat = oyiga 209 soat)",
    ),
  ),
  'ot_info': _E(
    L10nText(
      ko: '연장근로 수당',
      en: 'Overtime pay',
      tr: "Fazla mesai ücreti",
      tg: "Музди меҳнати изофакорӣ",
      fil: "Bayad sa overtime",
      ur: "اوور ٹائم اجرت",
      th: "ค่าล่วงเวลา",
      ky: "Ашыкча иштөө үчүн эмгек акы",
      km: "ប្រាក់ឈ្នួលបន្ថែមម៉ោង",
      id: "Upah lembur",
      si: "අතිකාල වැටුප්",
      bn: "ওভারটাইম মজুরি",
      my: "အချိန်ပိုလုပ်အားခ",
      mn: "Илүү цагийн хөлс",
      lo: "ຄ່າລ່ວງເວລາ",
      tet: "Pagamentu oras estra",
      ne: "ओभरटाइम ज्याला",
      zh: '加班津贴',
      vi: 'Phụ cấp làm thêm giờ',
      uz: "Ishdan tashqari ish haqi",
    ),
    L10nText(
      ko:
          '연장근로는 계약서상 정규근로시간 이외에 초과하여 근로한 행위를 말합니다.<br>'
          '<b>계산식: (연장근무시간 × 계약시급) × 1.5</b><br>'
          '• 상시 근로자수 5인 이상 사업장: 통상임금의 50%를 가산해서 지급<br>'
          '• 상시 근로자수 5인 미만: 통상임금만 지급',
      en:
          'Overtime means working beyond the regular hours set in your contract.<br>'
          '<b>Formula: (overtime hours × contracted hourly wage) × 1.5</b><br>'
          '• 5+ employee workplaces: pay an extra 50% of ordinary wage<br>'
          '• Fewer than 5 employees: pay ordinary wage only',
      tr: "Fazla mesai, sözleşmenizde belirlenen normal çalışma saatlerinin ötesinde çalışmak demektir.<br><b>Formül: (fazla mesai saatleri × sözleşmeli saatlik ücret) × 1.5</b><br>• 5+ çalışanı olan işyerleri: normal ücretin %50'si kadar ek ödeme yapar<br>• 5'ten az çalışanı olan işyerleri: sadece normal ücret öder",
      tg: "Изофакорӣ маънои кор карданро берун аз соатҳои кории муқаррарӣ, ки дар шартномаи шумо муайян шудааст, дорад.<br><b>Формула: (соатҳои изофакорӣ × музди меҳнати соатии шартномавӣ) × 1.5</b><br>• Корхонаҳое, ки 5+ корманд доранд: 50% иловагӣ аз музди меҳнати муқаррарӣ пардохт мекунанд.<br>• Корхонаҳое, ки камтар аз 5 корманд доранд: танҳо музди меҳнати муқаррарӣ пардохт мекунанд",
      fil:
          "Ang overtime ay nangangahulugang pagtatrabaho nang lampas sa normal na oras ng trabaho na itinakda sa iyong kontrata.<br><b>Formula: (oras ng overtime × kinontratang orasang sahod) × 1.5</b><br>• Mga lugar ng trabaho na may 5+ empleyado: nagbabayad ng karagdagang 50% ng normal na sahod<br>• Mga lugar ng trabaho na may mas mababa sa 5 empleyado: nagbabayad lamang ng normal na sahod",
      ur: "اوور ٹائم کا مطلب ہے آپ کے معاہدے میں طے شدہ معمول کے کام کے اوقات سے زیادہ کام کرنا۔<br><b>فارمولا: (اوور ٹائم کے اوقات × معاہدہ شدہ فی گھنٹہ اجرت) × 1.5</b><br>• 5+ ملازمین والے کام کی جگہیں: معمول کی اجرت کا 50% اضافی ادا کرتی ہیں<br>• 5 سے کم ملازمین والے کام کی جگہیں: صرف معمول کی اجرت ادا کرتی ہیں",
      th: "ค่าล่วงเวลาหมายถึงการทำงานเกินกว่าชั่วโมงทำงานปกติที่ระบุในสัญญาของคุณ<br><b>สูตร: (ชั่วโมงล่วงเวลา × ค่าจ้างรายชั่วโมงตามสัญญา) × 1.5</b><br>• สถานประกอบการที่มีพนักงาน 5 คนขึ้นไป: จ่ายเพิ่ม 50% ของค่าจ้างปกติ<br>• สถานประกอบการที่มีพนักงานน้อยกว่า 5 คน: จ่ายเฉพาะค่าจ้างปกติ",
      ky: "Ашыкча иштөө – бул келишимиңизде белгиленген кадимки иш сааттарынан тышкары иштөө дегенди билдирет.<br><b>Формула: (ашыкча иштөө сааттары × келишимдик сааттык эмгек акы) × 1.5</b><br>• 5+ кызматкери бар ишканалар: кадимки эмгек акынын 50% кошумча төлөмүн төлөйт<br>• 5тен аз кызматкери бар ишканалар: кадимки эмгек акыны гана төлөйт",
      km: "ការងារបន្ថែមម៉ោងមានន័យថាធ្វើការលើសពីម៉ោងធ្វើការធម្មតាដែលបានកំណត់ក្នុងកិច្ចសន្យារបស់អ្នក។<br><b>រូបមន្ត៖ (ម៉ោងបន្ថែមម៉ោង × ប្រាក់ឈ្នួលម៉ោងតាមកិច្ចសន្យា) × 1.5</b><br>• កន្លែងធ្វើការដែលមាននិយោជិត 5+ នាក់៖ បង់ប្រាក់បន្ថែម 50% នៃប្រាក់ឈ្នួលធម្មតា<br>• កន្លែងធ្វើការដែលមាននិយោជិតតិចជាង 5 នាក់៖ បង់តែប្រាក់ឈ្នួលធម្មតា",
      id: "Lembur berarti bekerja di luar jam kerja normal yang ditetapkan dalam kontrak Anda.<br><b>Rumus: (jam lembur × upah per jam yang disepakati) × 1.5</b><br>• Tempat kerja dengan 5+ karyawan: membayar tambahan 50% dari upah normal<br>• Tempat kerja dengan kurang dari 5 karyawan: hanya membayar upah normal",
      si: "අතිකාල යනු ඔබේ කොන්ත්‍රාත්තුවේ දක්වා ඇති සාමාන්‍ය වැඩ කරන වේලාවන් ඉක්මවා වැඩ කිරීමයි.<br><b>සූත්‍රය: (අතිකාල වේලාවන් × කොන්ත්‍රාත්තුගත පැයක වැටුප) × 1.5</b><br>• 5+ සේවකයින් සිටින සේවා ස්ථාන: සාමාන්‍ය වැටුපෙන් 50% ක අමතර ගෙවීමක් කරයි<br>• 5 ට අඩු සේවකයින් සිටින සේවා ස්ථාන: සාමාන්‍ය වැටුප පමණක් ගෙවයි",
      bn: "ওভারটাইম মানে আপনার চুক্তিতে নির্ধারিত স্বাভাবিক কাজের সময়ের বাইরে কাজ করা।<br><b>সূত্র: (ওভারটাইম ঘন্টা × চুক্তিবদ্ধ প্রতি ঘণ্টার মজুরি) × 1.5</b><br>• 5+ কর্মচারী সহ কর্মস্থল: স্বাভাবিক বেতনের অতিরিক্ত 50% প্রদান করে<br>• 5 এর কম কর্মচারী সহ কর্মস্থল: শুধুমাত্র স্বাভাবিক বেতন প্রদান করে",
      my: "အချိန်ပိုဆိုသည်မှာ သင့်စာချုပ်တွင် သတ်မှတ်ထားသော ပုံမှန်အလုပ်ချိန်ထက် ပိုမိုလုပ်ကိုင်ခြင်းကို ဆိုလိုပါသည်။<br><b>ဖော်မြူလာ- (အချိန်ပိုနာရီများ × စာချုပ်ပါ တစ်နာရီလုပ်အားခ) × 1.5</b><br>• ဝန်ထမ်း 5 ဦးနှင့်အထက်ရှိသော လုပ်ငန်းခွင်များ- ပုံမှန်လုပ်အားခ၏ 50% ကို ထပ်ဆောင်းပေးချေရပါမည်။<br>• ဝန်ထမ်း 5 ဦးအောက်ရှိသော လုပ်ငန်းခွင်များ- ပုံမှန်လုပ်အားခကိုသာ ပေးချေရပါမည်။",
      mn: "Илүү цаг гэдэг нь таны гэрээнд заасан хэвийн ажлын цагаас хэтрүүлэн ажиллахыг хэлнэ.<br><b>Томъёо: (илүү цагийн цаг × гэрээт цагийн хөлс) × 1.5</b><br>• 5+ ажилтантай ажлын байр: хэвийн цалингийн 50%-иар нэмэлт төлбөр төлнө<br>• 5-оос бага ажилтантай ажлын байр: зөвхөн хэвийн цалин төлнө",
      lo: "ການເຮັດວຽກລ່ວງເວລາໝາຍເຖິງການເຮັດວຽກເກີນຊົ່ວໂມງເຮັດວຽກປົກກະຕິທີ່ກຳນົດໄວ້ໃນສັນຍາຂອງທ່ານ.<br><b>ສູດ: (ຊົ່ວໂມງລ່ວງເວລາ × ຄ່າແຮງງານລາຍຊົ່ວໂມງຕາມສັນຍາ) × 1.5</b><br>• ສະຖານທີ່ເຮັດວຽກທີ່ມີພະນັກງານ 5+ ຄົນ: ຈ່າຍເພີ່ມ 50% ຂອງຄ່າແຮງງານປົກກະຕິ<br>• ສະຖານທີ່ເຮັດວຽກທີ່ມີພະນັກງານໜ້ອຍກວ່າ 5 ຄົນ: ຈ່າຍສະເພາະຄ່າແຮງງານປົກກະຕິ",
      tet:
          "Oras estra katak serbisu liu oras serbisu normál ne'ebé define iha ó nia kontratu.<br><b>Fórmula: (oras estra × saláriu oras nian ne'ebé kontratu) × 1.5</b><br>• Empreza ho empregadu 5+: halo pagamentu adisionál %50 husi saláriu normál<br>• Empreza ho empregadu menus husi 5: selu de'it saláriu normál",
      ne: "ओभरटाइम भनेको तपाईंको सम्झौतामा तोकिएको सामान्य कामको घण्टाभन्दा बढी काम गर्नु हो।<br><b>सूत्र: (ओभरटाइम घण्टा × अनुबन्धित प्रतिघण्टा ज्याला) × 1.5</b><br>• 5+ कर्मचारी भएका कार्यस्थलहरू: सामान्य ज्यालाको 50% अतिरिक्त भुक्तानी गर्छन्<br>• 5 भन्दा कम कर्मचारी भएका कार्यस्थलहरू: सामान्य ज्याला मात्र भुक्तानी गर्छन्",
      zh:
          '加班是指超出合同规定正常工作时间之外的劳动。<br>'
          '<b>计算公式：（加班时间 × 合同时薪）× 1.5</b><br>'
          '• 常雇员工5人以上单位：加发通常工资的50%<br>'
          '• 常雇员工不足5人：仅支付通常工资',
      vi:
          'Làm thêm giờ là làm việc vượt quá giờ làm việc chính thức theo hợp đồng.<br>'
          '<b>Công thức: (số giờ làm thêm × lương giờ theo hợp đồng) × 1,5</b><br>'
          '• Nơi làm việc từ 5 người trở lên: trả thêm 50% lương thông thường<br>'
          '• Nơi làm việc dưới 5 người: chỉ trả lương thông thường',
      uz: "Ishdan tashqari ish – bu shartnomangizda belgilangan muntazam soatlardan tashqari ishlashni anglatadi.<br><b>Formula: (ishdan tashqari soatlar × shartnomadagi soatlik ish haqi) × 1,5</b><br>• 5+ xodimli ish joylari: oddiy ish haqining qoʻshimcha 50% ini toʻlaydi<br>• 5 dan kam xodim: faqat oddiy ish haqi toʻlanadi",
    ),
  ),
  'nt_info': _E(
    L10nText(
      ko: '야간근로 수당',
      en: 'Night work pay',
      tr: "Gece çalışması ücreti",
      tg: "Музди меҳнати шабона",
      fil: "Bayad sa trabaho sa gabi",
      ur: "رات کے کام کی اجرت",
      th: "ค่าทำงานกลางคืน",
      ky: "Түнкү иштөө үчүн эмгек акы",
      km: "ប្រាក់ឈ្នួលការងារពេលយប់",
      id: "Upah kerja malam",
      si: "රාත්‍රී වැඩ වැටුප්",
      bn: "রাত্রিকালীন কাজের মজুরি",
      my: "ညဆိုင်းလုပ်အားခ",
      mn: "Шөнийн ажлын хөлс",
      lo: "ຄ່າແຮງງານເຮັດວຽກກາງຄືນ",
      tet: "Pagamentu serbisu kalan",
      ne: "रात्रिकालीन कामको ज्याला",
      zh: '夜班津贴',
      vi: 'Phụ cấp làm đêm',
      uz: "Tungi ish haqi",
    ),
    L10nText(
      ko:
          '야간근로는 오후 10시부터 다음 날 오전 6시 사이의 시간에 근로한 행위를 말합니다.<br>'
          '<b>계산식: (야간근무시간 × 계약시급) × 0.5(가산분)</b><br>'
          '• 5인 이상 사업장: 야간근로 자체에 대한 가산수당 50%를 별도로 추가 지급<br>'
          '• 5인 미만 사업장: 가산수당이 없으며 주간 근로와 동일한 통상임금만 지급',
      en:
          'Night work means working between 10 PM and 6 AM the next day.<br>'
          '<b>Formula: (night hours × contracted hourly wage) × 0.5 (premium portion)</b><br>'
          '• 5+ employee workplaces: an additional 50% premium is paid on top, specifically for night work<br>'
          '• Fewer than 5 employees: no premium; paid the same ordinary wage as daytime work',
      tr: "Gece çalışması, akşam 10 ile ertesi sabah 6 arasında çalışmak demektir.<br><b>Formül: (gece saatleri × sözleşmeli saatlik ücret) × 0.5 (prim kısmı)</b><br>• 5+ çalışanı olan işyerleri: gece çalışması için ayrıca %50 ek prim ödenir<br>• 5'ten az çalışanı olan işyerleri: prim yok; gündüz çalışmasıyla aynı normal ücret ödenir",
      tg: "Кори шабона маънои кор карданро дар байни соати 10 шаб ва 6 субҳи рӯзи дигар дорад.<br><b>Формула: (соатҳои шабона × музди меҳнати соатии шартномавӣ) × 0.5 (қисми мукофотпулӣ)</b><br>• Корхонаҳое, ки 5+ корманд доранд: барои кори шабона иловатан 50% мукофотпулӣ пардохт карда мешавад.<br>• Корхонаҳое, ки камтар аз 5 корманд доранд: мукофотпулӣ нест; ҳамон музди меҳнати муқаррарӣ барои кори рӯзона пардохт карда мешавад",
      fil:
          "Ang trabaho sa gabi ay nangangahulugang pagtatrabaho sa pagitan ng 10 ng gabi at 6 ng umaga.<br><b>Formula: (oras ng gabi × kinontratang orasang sahod) × 0.5 (bahagi ng premium)</b><br>• Mga lugar ng trabaho na may 5+ empleyado: karagdagang 50% premium ang binabayaran para sa trabaho sa gabi<br>• Mga lugar ng trabaho na may mas mababa sa 5 empleyado: walang premium; binabayaran ang parehong normal na sahod tulad ng trabaho sa araw",
      ur: "رات کے کام کا مطلب ہے شام 10 سے اگلی صبح 6 کے درمیان کام کرنا۔<br><b>فارمولا: (رات کے اوقات × معاہدہ شدہ فی گھنٹہ اجرت) × 0.5 (پریمیم حصہ)</b><br>• 5+ ملازمین والے کام کی جگہیں: رات کے کام کے لیے مزید 50% اضافی پریمیم ادا کیا جاتا ہے<br>• 5 سے کم ملازمین والے کام کی جگہیں: کوئی پریمیم نہیں؛ دن کے کام کی طرح معمول کی اجرت ادا کی جاتی ہے",
      th: "ค่าทำงานกลางคืนหมายถึงการทำงานระหว่างเวลา 10 น. ถึง 6 น. ของเช้าวันถัดไป<br><b>สูตร: (ชั่วโมงทำงานกลางคืน × ค่าจ้างรายชั่วโมงตามสัญญา) × 0.5 (ส่วนของค่าจ้างพิเศษ)</b><br>• สถานประกอบการที่มีพนักงาน 5 คนขึ้นไป: จ่ายค่าทำงานกลางคืนเพิ่มอีก 50%<br>• สถานประกอบการที่มีพนักงานน้อยกว่า 5 คน: ไม่มีค่าจ้างพิเศษ; จ่ายค่าจ้างปกติเท่ากับการทำงานกลางวัน",
      ky: "Түнкү иштөө – бул кечки саат 10 менен эртеси эртең мененки саат 6 ортосунда иштөө дегенди билдирет.<br><b>Формула: (түнкү сааттар × келишимдик сааттык эмгек акы) × 0.5 (кошумча төлөм бөлүгү)</b><br>• 5+ кызматкери бар ишканалар: түнкү иштөө үчүн кошумча 50% кошумча төлөм төлөнөт<br>• 5тен аз кызматкери бар ишканалар: кошумча төлөм жок; күндүзгү иштөөдөгүдөй эле кадимки эмгек акы төлөнөт",
      km: "ការងារពេលយប់មានន័យថាធ្វើការចន្លោះពីម៉ោង 10 ល្ងាច ដល់ម៉ោង 6 ព្រឹកថ្ងៃបន្ទាប់។<br><b>រូបមន្ត៖ (ម៉ោងពេលយប់ × ប្រាក់ឈ្នួលម៉ោងតាមកិច្ចសន្យា) × 0.5 (ផ្នែកបន្ថែម)</b><br>• កន្លែងធ្វើការដែលមាននិយោជិត 5+ នាក់៖ បង់ប្រាក់បន្ថែម 50% សម្រាប់ការងារពេលយប់<br>• កន្លែងធ្វើការដែលមាននិយោជិតតិចជាង 5 នាក់៖ គ្មានប្រាក់បន្ថែម; បង់ប្រាក់ឈ្នួលធម្មតាដូចការងារពេលថ្ងៃ",
      id: "Kerja malam berarti bekerja antara pukul 10 malam dan 6 pagi keesokan harinya.<br><b>Rumus: (jam malam × upah per jam yang disepakati) × 0.5 (bagian premi)</b><br>• Tempat kerja dengan 5+ karyawan: premi tambahan 50% dibayarkan secara terpisah untuk kerja malam<br>• Tempat kerja dengan kurang dari 5 karyawan: tidak ada premi; upah normal yang sama dengan kerja siang dibayarkan",
      si: "රාත්‍රී වැඩ යනු සවස 10 සිට පසුදා උදෑසන 6 දක්වා වැඩ කිරීමයි.<br><b>සූත්‍රය: (රාත්‍රී වේලාවන් × කොන්ත්‍රාත්තුගත පැයක වැටුප) × 0.5 (වාරික කොටස)</b><br>• 5+ සේවකයින් සිටින සේවා ස්ථාන: රාත්‍රී වැඩ සඳහා අමතර 50% ක වාරිකයක් ගෙවනු ලැබේ<br>• 5 ට අඩු සේවකයින් සිටින සේවා ස්ථාන: වාරිකයක් නැත; දිවා කාලයේ වැඩ සඳහා සමාන සාමාන්‍ය වැටුපක් ගෙවනු ලැබේ",
      bn: "রাত্রিকালীন কাজ মানে সন্ধ্যা 10 থেকে পরের দিন সকাল 6 এর মধ্যে কাজ করা।<br><b>সূত্র: (রাত্রিকালীন ঘন্টা × চুক্তিবদ্ধ প্রতি ঘণ্টার মজুরি) × 0.5 (প্রিমিয়াম অংশ)</b><br>• 5+ কর্মচারী সহ কর্মস্থল: রাত্রিকালীন কাজের জন্য অতিরিক্ত 50% প্রিমিয়াম প্রদান করা হয়<br>• 5 এর কম কর্মচারী সহ কর্মস্থল: কোনো প্রিমিয়াম নেই; দিনের কাজের মতোই স্বাভাবিক বেতন প্রদান করা হয়",
      my: "ညဆိုင်းဆိုသည်မှာ ညနေ 10 မှ နောက်နေ့မနက် 6 အကြား အလုပ်လုပ်ခြင်းကို ဆိုလိုပါသည်။<br><b>ဖော်မြူလာ- (ညဆိုင်းနာရီများ × စာချုပ်ပါ တစ်နာရီလုပ်အားခ) × 0.5 (အပိုဆုကြေးအပိုင်း)</b><br>• ဝန်ထမ်း 5 ဦးနှင့်အထက်ရှိသော လုပ်ငန်းခွင်များ- ညဆိုင်းအတွက် 50% အပိုဆုကြေးကို သီးခြားပေးချေရပါမည်။<br>• ဝန်ထမ်း 5 ဦးအောက်ရှိသော လုပ်ငန်းခွင်များ- အပိုဆုကြေးမရှိပါ။ နေ့ဆိုင်းလုပ်အားခနှင့် တူညီသော ပုံမှန်လုပ်အားခကိုသာ ပေးချေရပါမည်။",
      mn: "Шөнийн ажил гэдэг нь оройн 10 цагаас маргааш өглөөний 6 цагийн хооронд ажиллахыг хэлнэ.<br><b>Томъёо: (шөнийн цаг × гэрээт цагийн хөлс) × 0.5 (нэмэгдлийн хэсэг)</b><br>• 5+ ажилтантай ажлын байр: шөнийн ажлын хувьд нэмэлт 50% нэмэгдэл төлнө<br>• 5-оос бага ажилтантай ажлын байр: нэмэгдэл байхгүй; өдрийн ажилтай адил хэвийн цалин төлнө",
      lo: "ການເຮັດວຽກກາງຄືນໝາຍເຖິງການເຮັດວຽກລະຫວ່າງ 10 ຕອນແລງ ຫາ 6 ຕອນເຊົ້າຂອງມື້ຕໍ່ໄປ.<br><b>ສູດ: (ຊົ່ວໂມງກາງຄືນ × ຄ່າແຮງງານລາຍຊົ່ວໂມງຕາມສັນຍາ) × 0.5 (ສ່ວນເງິນພິເສດ)</b><br>• ສະຖານທີ່ເຮັດວຽກທີ່ມີພະນັກງານ 5+ ຄົນ: ຈ່າຍເງິນພິເສດເພີ່ມເຕີມ 50% ສໍາລັບການເຮັດວຽກກາງຄືນ<br>• ສະຖານທີ່ເຮັດວຽກທີ່ມີພະນັກງານໜ້ອຍກວ່າ 5 ຄົນ: ບໍ່ມີເງິນພິເສດ; ຈ່າຍຄ່າແຮງງານປົກກະຕິເທົ່າກັບການເຮັດວຽກກາງເວັນ",
      tet:
          "Serbisu kalan katak serbisu entre tuku 10 kalan to'o tuku 6 dadeer.<br><b>Fórmula: (oras kalan × saláriu oras nian ne'ebé kontratu) × 0.5 (parte prémiu)</b><br>• Empreza ho empregadu 5+: prémiu adisionál %50 selu ba serbisu kalan<br>• Empreza ho empregadu menus husi 5: la iha prémiu; selu saláriu normál hanesan serbisu loron",
      ne: "रात्रिकालीन काम भनेको बेलुका 10 बजेदेखि भोलिपल्ट बिहान 6 बजेसम्म काम गर्नु हो।<br><b>सूत्र: (रातको घण्टा × अनुबन्धित प्रतिघण्टा ज्याला) × 0.5 (प्रिमियम भाग)</b><br>• 5+ कर्मचारी भएका कार्यस्थलहरू: रात्रिकालीन कामको लागि थप 50% प्रिमियम भुक्तानी गरिन्छ<br>• 5 भन्दा कम कर्मचारी भएका कार्यस्थलहरू: प्रिमियम छैन; दिउँसोको काम जस्तै सामान्य ज्याला भुक्तानी गरिन्छ",
      zh:
          '夜班是指晚上10点到次日早上6点之间的劳动。<br>'
          '<b>计算公式：（夜班时间 × 合同时薪）× 0.5（加成部分）</b><br>'
          '• 5人以上单位：针对夜班本身另外加发50%的津贴<br>'
          '• 不足5人单位：无加成津贴，与白班同样只支付通常工资',
      vi:
          'Làm đêm là làm việc trong khoảng từ 22 giờ đến 6 giờ sáng hôm sau.<br>'
          '<b>Công thức: (số giờ làm đêm × lương giờ theo hợp đồng) × 0,5 (phần phụ cấp)</b><br>'
          '• Nơi làm việc từ 5 người trở lên: trả thêm riêng 50% phụ cấp cho làm đêm<br>'
          '• Nơi làm việc dưới 5 người: không có phụ cấp, chỉ trả lương thông thường như ban ngày',
      uz: "Tungi ish – bu kechki soat 22:00 dan keyingi kun ertalab soat 6:00 gacha ishlashni anglatadi.<br><b>Formula: (tungi soatlar × shartnomadagi soatlik ish haqi) × 0,5 (qoʻshimcha qism)</b><br>• 5+ xodimli ish joylari: tungi ish uchun qoʻshimcha 50% ustama toʻlanadi<br>• 5 dan kam xodim: ustama yoʻq; kunduzgi ish bilan bir xil oddiy ish haqi toʻlanadi",
    ),
  ),
  'hol_info': _E(
    L10nText(
      ko: '휴일근로 수당',
      en: 'Holiday work pay',
      tr: "Tatil çalışması ücreti",
      tg: "Музди меҳнати кор дар рӯзи ид",
      fil: "Bayad sa trabaho sa holiday",
      ur: "چھٹی کے کام کی اجرت",
      th: "ค่าทำงานวันหยุด",
      ky: "Майрам күндөрү иштөө үчүн эмгек акы",
      km: "ប្រាក់ឈ្នួលការងារថ្ងៃឈប់សម្រាក",
      id: "Upah kerja libur",
      si: "නිවාඩු දින වැඩ වැටුප්",
      bn: "ছুটির দিনের কাজের মজুরি",
      my: "အားလပ်ရက်လုပ်အားခ",
      mn: "Амралтын өдрийн ажлын хөлс",
      lo: "ຄ່າແຮງງານເຮັດວຽກວັນພັກ",
      tet: "Pagamentu serbisu ferias",
      ne: "बिदाको कामको ज्याला",
      zh: '休息日加班津贴',
      vi: 'Phụ cấp làm ngày nghỉ',
      uz: "Bayram kunlari ishlaganlik uchun haq",
    ),
    L10nText(
      ko:
          '휴일근로는 근로계약서나 법정 제도상 지정된 휴일에 출근하여 근로한 행위를 말합니다.<br>'
          '<b>계산식: (휴일근무시간 × 계약시급) × 1.5 (8시간 초과분은 2.0)</b><br>'
          '• 5인 이상 사업장: 8시간 이하는 50% 가산, 8시간 초과분은 100% 가산<br>'
          '• 5인 미만 사업장: 가산수당이 없으며 실제 일한 시간만큼의 통상임금만 지급',
      en:
          'Holiday work means working on a day designated as a holiday by your contract or by law.<br>'
          '<b>Formula: (holiday hours × contracted hourly wage) × 1.5 (2.0 for hours beyond 8)</b><br>'
          '• 5+ employee workplaces: 50% premium up to 8 hours, 100% premium beyond 8 hours<br>'
          '• Fewer than 5 employees: no premium; paid ordinary wage only for actual hours worked',
      tr: "Tatil çalışması, sözleşmeniz veya yasa tarafından tatil olarak belirlenen bir günde çalışmak demektir.<br><b>Formül: (tatil saatleri × sözleşmeli saatlik ücret) × 1.5 (8 saatin üzerindeki saatler için 2.0)</b><br>• 5+ çalışanı olan işyerleri: 8 saate kadar %50 prim, 8 saatin üzerinde %100 prim<br>• 5'ten az çalışanı olan işyerleri: prim yok; sadece fiilen çalışılan saatler için normal ücret ödenir",
      tg: "Кори ид маънои кор карданро дар рӯзе дорад, ки дар шартномаи шумо ё қонун ҳамчун ид муайян шудааст.<br><b>Формула: (соатҳои ид × музди меҳнати соатии шартномавӣ) × 1.5 (барои соатҳои зиёда аз 8 соат 2.0)</b><br>• Корхонаҳое, ки 5+ корманд доранд: 50% мукофотпулӣ то 8 соат, 100% мукофотпулӣ барои зиёда аз 8 соат.<br>• Корхонаҳое, ки камтар аз 5 корманд доранд: мукофотпулӣ нест; танҳо музди меҳнати муқаррарӣ барои соатҳои воқеан коркардашуда пардохт карда мешавад",
      fil:
          "Ang trabaho sa holiday ay nangangahulugang pagtatrabaho sa isang araw na itinakda bilang holiday ng iyong kontrata o ng batas.<br><b>Formula: (oras ng holiday × kinontratang orasang sahod) × 1.5 (8 para sa mga oras na lampas sa 2.0 oras)</b><br>• Mga lugar ng trabaho na may 5+ empleyado: 50% premium hanggang 8 oras, 100% premium sa lampas sa 8 oras<br>• Mga lugar ng trabaho na may mas mababa sa 5 empleyado: walang premium; binabayaran lamang ang normal na sahod para sa aktwal na oras na nagtrabaho",
      ur: "چھٹی کے کام کا مطلب ہے کسی ایسے دن کام کرنا جسے آپ کے معاہدے یا قانون کے ذریعے چھٹی کے طور پر نامزد کیا گیا ہو۔<br><b>فارمولا: (چھٹی کے اوقات × معاہدہ شدہ فی گھنٹہ اجرت) × 1.5 (8 گھنٹے سے زیادہ کے اوقات کے لیے 2.0)</b><br>• 5+ ملازمین والے کام کی جگہیں: 8 گھنٹے تک 50% پریمیم، 8 گھنٹے سے زیادہ 100% پریمیم<br>• 5 سے کم ملازمین والے کام کی جگہیں: کوئی پریمیم نہیں؛ صرف اصل میں کام کیے گئے اوقات کے لیے معمول کی اجرت ادا کی جاتی ہے",
      th: "ค่าทำงานวันหยุดหมายถึงการทำงานในวันที่กำหนดให้เป็นวันหยุดตามสัญญาหรือตามกฎหมาย<br><b>สูตร: (ชั่วโมงทำงานวันหยุด × ค่าจ้างรายชั่วโมงตามสัญญา) × 1.5 (สำหรับชั่วโมงที่เกิน 8 ชั่วโมงคือ 2.0)</b><br>• สถานประกอบการที่มีพนักงาน 5 คนขึ้นไป: ค่าจ้างพิเศษ 8% สำหรับไม่เกิน 50 ชั่วโมง, 8% สำหรับเกิน 100 ชั่วโมง<br>• สถานประกอบการที่มีพนักงานน้อยกว่า 5 คน: ไม่มีค่าจ้างพิเศษ; จ่ายเฉพาะค่าจ้างปกติสำหรับชั่วโมงที่ทำงานจริง",
      ky: "Майрам күндөрү иштөө – бул келишимиңиз же мыйзам тарабынан майрам деп белгиленген күнү иштөө дегенди билдирет.<br><b>Формула: (майрамдык сааттар × келишимдик сааттык эмгек акы) × 1.5 (8 сааттан ашкан сааттар үчүн 2.0)</b><br>• 5+ кызматкери бар ишканалар: 8 саатка чейин 50% кошумча төлөм, 8 сааттан ашканда 100% кошумча төлөм<br>• 5тен аз кызматкери бар ишканалар: кошумча төлөм жок; иш жүзүндө иштеген сааттар үчүн гана кадимки эмгек акы төлөнөт",
      km: "ការងារថ្ងៃឈប់សម្រាកមានន័យថាធ្វើការនៅថ្ងៃដែលត្រូវបានកំណត់ជាថ្ងៃឈប់សម្រាកដោយកិច្ចសន្យារបស់អ្នក ឬដោយច្បាប់។<br><b>រូបមន្ត៖ (ម៉ោងថ្ងៃឈប់សម្រាក × ប្រាក់ឈ្នួលម៉ោងតាមកិច្ចសន្យា) × 1.5 (សម្រាប់ម៉ោងលើសពី 8 ម៉ោងគឺ 2.0)</b><br>• កន្លែងធ្វើការដែលមាននិយោជិត 5+ នាក់៖ ប្រាក់បន្ថែម 50% រហូតដល់ 8 ម៉ោង, ប្រាក់បន្ថែម 100% លើសពី 8 ម៉ោង<br>• កន្លែងធ្វើការដែលមាននិយោជិតតិចជាង 5 នាក់៖ គ្មានប្រាក់បន្ថែម; បង់តែប្រាក់ឈ្នួលធម្មតាសម្រាប់ម៉ោងធ្វើការជាក់ស្តែង",
      id: "Kerja libur berarti bekerja pada hari yang ditetapkan sebagai hari libur oleh kontrak Anda atau hukum.<br><b>Rumus: (jam libur × upah per jam yang disepakati) × 1.5 (8 untuk jam di atas 2.0 jam)</b><br>• Tempat kerja dengan 5+ karyawan: premi 50% hingga 8 jam, premi 100% di atas 8 jam<br>• Tempat kerja dengan kurang dari 5 karyawan: tidak ada premi; hanya upah normal yang dibayarkan untuk jam kerja aktual",
      si: "නිවාඩු දින වැඩ යනු ඔබේ කොන්ත්‍රාත්තුවෙන් හෝ නීතියෙන් නිවාඩු දිනයක් ලෙස නියම කර ඇති දිනක වැඩ කිරීමයි.<br><b>සූත්‍රය: (නිවාඩු දින වේලාවන් × කොන්ත්‍රාත්තුගත පැයක වැටුප) × 1.5 (පැය 8 ට වැඩි වේලාවන් සඳහා 2.0)</b><br>• 5+ සේවකයින් සිටින සේවා ස්ථාන: පැය 8 දක්වා 50% වාරිකය, පැය 8 ට වැඩි 100% වාරිකය<br>• 5 ට අඩු සේවකයින් සිටින සේවා ස්ථාන: වාරිකයක් නැත; සැබවින්ම වැඩ කරන වේලාවන් සඳහා සාමාන්‍ය වැටුප පමණක් ගෙවනු ලැබේ",
      bn: "ছুটির দিনের কাজ মানে আপনার চুক্তি বা আইন দ্বারা ছুটি হিসাবে নির্ধারিত দিনে কাজ করা।<br><b>সূত্র: (ছুটির দিনের ঘন্টা × চুক্তিবদ্ধ প্রতি ঘণ্টার মজুরি) × 1.5 (8 ঘন্টার বেশি ঘন্টার জন্য 2.0)</b><br>• 5+ কর্মচারী সহ কর্মস্থল: 8 ঘন্টা পর্যন্ত 50% প্রিমিয়াম, 8 ঘন্টার বেশি 100% প্রিমিয়াম<br>• 5 এর কম কর্মচারী সহ কর্মস্থল: কোনো প্রিমিয়াম নেই; শুধুমাত্র প্রকৃতপক্ষে কাজ করা ঘন্টার জন্য স্বাভাবিক বেতন প্রদান করা হয়",
      my: "အားလပ်ရက်လုပ်အားခဆိုသည်မှာ သင့်စာချုပ် သို့မဟုတ် ဥပဒေအရ အားလပ်ရက်အဖြစ် သတ်မှတ်ထားသောနေ့တွင် အလုပ်လုပ်ခြင်းကို ဆိုလိုပါသည်။<br><b>ဖော်မြူလာ- (အားလပ်ရက်နာရီများ × စာချုပ်ပါ တစ်နာရီလုပ်အားခ) × 1.5 (8 နာရီကျော်လွန်သော နာရီများအတွက် 2.0)</b><br>• ဝန်ထမ်း 5 ဦးနှင့်အထက်ရှိသော လုပ်ငန်းခွင်များ- 8 နာရီအထိ 50% အပိုဆုကြေး၊ 8 နာရီကျော်လွန်ပါက 100% အပိုဆုကြေး<br>• ဝန်ထမ်း 5 ဦးအောက်ရှိသော လုပ်ငန်းခွင်များ- အပိုဆုကြေးမရှိပါ။ အမှန်တကယ်လုပ်ကိုင်ခဲ့သော နာရီများအတွက် ပုံမှန်လုပ်အားခကိုသာ ပေးချေရပါမည်။",
      mn: "Амралтын өдрийн ажил гэдэг нь таны гэрээ эсвэл хуулиар амралтын өдөр гэж тогтоосон өдөр ажиллахыг хэлнэ.<br><b>Томъёо: (амралтын өдрийн цаг × гэрээт цагийн хөлс) × 1.5 (8 цагаас дээш цагийн хувьд 2.0)</b><br>• 5+ ажилтантай ажлын байр: 8 цаг хүртэл 50% нэмэгдэл, 8 цагаас дээш 100% нэмэгдэл<br>• 5-оос бага ажилтантай ажлын байр: нэмэгдэл байхгүй; зөвхөн бодитоор ажилласан цагийн хувьд хэвийн цалин төлнө",
      lo: "ການເຮັດວຽກວັນພັກໝາຍເຖິງການເຮັດວຽກໃນມື້ທີ່ຖືກກຳນົດໃຫ້ເປັນວັນພັກໂດຍສັນຍາຂອງທ່ານ ຫຼື ໂດຍກົດໝາຍ.<br><b>ສູດ: (ຊົ່ວໂມງວັນພັກ × ຄ່າແຮງງານລາຍຊົ່ວໂມງຕາມສັນຍາ) × 1.5 (ສໍາລັບຊົ່ວໂມງເກີນ 8 ຊົ່ວໂມງແມ່ນ 2.0)</b><br>• ສະຖານທີ່ເຮັດວຽກທີ່ມີພະນັກງານ 5+ ຄົນ: ເງິນພິເສດ 50% ສໍາລັບເຖິງ 8 ຊົ່ວໂມງ, ເງິນພິເສດ 100% ສໍາລັບເກີນ 8 ຊົ່ວໂມງ<br>• ສະຖານທີ່ເຮັດວຽກທີ່ມີພະນັກງານໜ້ອຍກວ່າ 5 ຄົນ: ບໍ່ມີເງິນພິເສດ; ຈ່າຍສະເພາະຄ່າແຮງງານປົກກະຕິສໍາລັບຊົ່ວໂມງທີ່ເຮັດວຽກຕົວຈິງ",
      tet:
          "Serbisu ferias katak serbisu iha loron ne'ebé define hanesan ferias iha ó nia kontratu ka lei.<br><b>Fórmula: (oras ferias × saláriu oras nian ne'ebé kontratu) × 1.5 (ba oras liu 8 oras 2.0)</b><br>• Empreza ho empregadu 5+: prémiu %50 to'o oras 8, prémiu %100 ba oras liu 8<br>• Empreza ho empregadu menus husi 5: la iha prémiu; selu de'it saláriu normál ba oras ne'ebé serbisu duni",
      ne: "बिदाको काम भनेको तपाईंको सम्झौता वा कानूनद्वारा बिदाको रूपमा तोकिएको दिनमा काम गर्नु हो।<br><b>सूत्र: (बिदाको घण्टा × अनुबन्धित प्रतिघण्टा ज्याला) × 1.5 (8 घण्टा भन्दा बढीको लागि 2.0)</b><br>• 5+ कर्मचारी भएका कार्यस्थलहरू: 8 घण्टासम्म 50% प्रिमियम, 8 घण्टाभन्दा बढीको लागि 100% प्रिमियम<br>• 5 भन्दा कम कर्मचारी भएका कार्यस्थलहरू: प्रिमियम छैन; वास्तवमा काम गरेको घण्टाको लागि मात्र सामान्य ज्याला भुक्तानी गरिन्छ",
      zh:
          '休息日加班是指在合同或法定制度指定的休息日出勤劳动。<br>'
          '<b>计算公式：（休息日工作时间 × 合同时薪）× 1.5（超过8小时部分为2.0）</b><br>'
          '• 5人以上单位：8小时以内加发50%，超过8小时部分加发100%<br>'
          '• 不足5人单位：无加成津贴，仅按实际工作时间支付通常工资',
      vi:
          'Làm ngày nghỉ là làm việc vào ngày được quy định là ngày nghỉ theo hợp đồng hoặc pháp luật.<br>'
          '<b>Công thức: (số giờ làm ngày nghỉ × lương giờ theo hợp đồng) × 1,5 (phần vượt 8 giờ là 2,0)</b><br>'
          '• Nơi làm việc từ 5 người trở lên: phụ cấp 50% trong 8 giờ đầu, 100% cho phần vượt 8 giờ<br>'
          '• Nơi làm việc dưới 5 người: không có phụ cấp, chỉ trả lương thông thường theo giờ thực làm',
      uz: "Bayram kunlari ishlash – bu shartnomangiz yoki qonun bilan bayram kuni deb belgilangan kunda ishlashni anglatadi.<br><b>Formula: (bayram soatlari × shartnomadagi soatlik ish haqi) × 1,5 (8 soatdan ortiq soatlar uchun 2,0)</b><br>• 5+ xodimli ish joylari: 8 soatgacha 50% ustama, 8 soatdan ortiq boʻlsa 100% ustama<br>• 5 dan kam xodim: ustama yoʻq; faqat haqiqiy ishlagan soatlar uchun oddiy ish haqi toʻlanadi",
    ),
  ),
  'tenure_info': _E(
    L10nText(
      ko: '재직 기간 안내',
      en: 'About your tenure period',
      tr: "Kıdem süreniz hakkında",
      tg: "Дар бораи собиқаи кории шумо",
      fil: "Tungkol sa iyong tagal ng serbisyo",
      ur: "آپ کی مدت ملازمت کے بارے میں",
      th: "เกี่ยวกับระยะเวลาการทำงานของคุณ",
      ky: "Иш стажыңыз жөнүндө",
      km: "អំពីអតីតភាពការងាររបស់អ្នក",
      id: "Tentang masa kerja Anda",
      si: "ඔබේ සේවා කාලය පිළිබඳව",
      bn: "আপনার চাকরির মেয়াদ সম্পর্কে",
      my: "သင်၏ လုပ်သက်အကြောင်း",
      mn: "Таны ажилласан хугацааны тухай",
      lo: "ກ່ຽວກັບໄລຍະເວລາການເຮັດວຽກຂອງທ່ານ",
      tet: "Kona-ba ó nia tempu serbisu",
      ne: "तपाईंको सेवा अवधिको बारेमा",
      zh: '在职期间说明',
      vi: 'Hướng dẫn về thời gian làm việc',
      uz: "Ish stajingiz haqida",
    ),
    L10nText(
      ko:
          '여기서 입력하는 재직 기간(입사일~퇴사일)은 퇴직금 지급 요건 — ① 계속근로 1년 이상, ② 주 평균 15시간 이상 — 을 판단하는 용도로만 사용됩니다. '
          '앞서 고르신 확인 기간(체불 기간)과는 별개예요.',
      en:
          'The tenure period you enter here (hire date to resignation date) is used only to check the severance-pay eligibility conditions — ① 1+ year of continuous service, ② 15+ hours/week on average. '
          'It is separate from the check period (unpaid-wage period) you chose earlier.',
      tr: "Buraya girdiğiniz kıdem süresi (işe giriş tarihinden istifa tarihine kadar), yalnızca kıdem tazminatı uygunluk koşullarını kontrol etmek için kullanılır — ① 1+ yıl kesintisiz hizmet, ② haftada ortalama 15+ saat. Bu süre, daha önce seçtiğiniz kontrol süresinden (ödenmemiş ücret dönemi) ayrıdır.",
      tg: "Собиқаи корӣ (аз санаи оғози кор то санаи истеъфо), ки шумо дар ин ҷо ворид мекунед, танҳо барои тафтиши шартҳои мувофиқат ба ҷуброни хидмат истифода мешавад — ① 1+ соли хидмати бефосила, ② ба ҳисоби миёна 15+ соат дар як ҳафта. Ин давра аз давраи санҷиши қаблан интихобкардаи шумо (давраи музди меҳнати пардохтнашуда) фарқ мекунад.",
      fil:
          "Ang tagal ng serbisyo na inilagay mo dito (mula sa petsa ng pagpasok hanggang sa petsa ng pagbibitiw) ay ginagamit lamang upang suriin ang mga kondisyon ng pagiging karapat-dapat para sa severance pay — ① 1+ taon ng tuloy-tuloy na serbisyo, ② average na 15+ oras bawat linggo. Ang panahong ito ay hiwalay sa panahon ng pagsusuri (panahon ng hindi nabayarang sahod) na iyong pinili kanina.",
      ur: "یہاں آپ کی درج کردہ مدت ملازمت (ملازمت شروع کرنے کی تاریخ سے استعفیٰ کی تاریخ تک) صرف علیحدگی تنخواہ کی اہلیت کی شرائط کو جانچنے کے لیے استعمال ہوتی ہے — ① 1+ سال کی مسلسل سروس، ② اوسطاً 15+ گھنٹے فی ہفتہ۔ یہ مدت آپ کی پہلے منتخب کردہ جانچ کی مدت (غیر ادا شدہ اجرت کی مدت) سے الگ ہے۔",
      th: "ระยะเวลาการทำงานที่คุณป้อนที่นี่ (ตั้งแต่วันที่เริ่มงานจนถึงวันที่ลาออก) ใช้เพื่อตรวจสอบคุณสมบัติในการรับเงินชดเชยการเลิกจ้างเท่านั้น — ① ทำงานต่อเนื่อง 1 ปีขึ้นไป, ② เฉลี่ย 15 ชั่วโมงต่อสัปดาห์ขึ้นไป ระยะเวลานี้แยกต่างหากจากช่วงเวลาตรวจสอบที่คุณเลือกไว้ก่อนหน้านี้ (ช่วงเวลาค่าจ้างที่ยังไม่ได้รับชำระ)",
      ky: "Бул жерге киргизген иш стажыңыз (жумушка кирген күндөн отставкага кеткен күнгө чейин) кызматтан бошотуу жөлөкпулуна ылайыктуулук шарттарын текшерүү үчүн гана колдонулат — ① 1+ жыл үзгүлтүксүз кызмат, ② жумасына орточо 15+ саат. Бул мезгил сиз мурда тандаган текшерүү мезгилинен (төлөнбөгөн эмгек акы мезгили) өзүнчө.",
      km: "អតីតភាពការងារដែលអ្នកបានបញ្ចូលនៅទីនេះ (ពីកាលបរិច្ឆេទចាប់ផ្តើមការងារដល់កាលបរិច្ឆេទលាលែងពីការងារ) ត្រូវបានប្រើប្រាស់សម្រាប់តែការត្រួតពិនិត្យលក្ខខណ្ឌនៃសិទ្ធិទទួលបានប្រាក់បំណាច់អតីតភាពការងារប៉ុណ្ណោះ — ① បម្រើការងារបន្តបន្ទាប់ 1+ ឆ្នាំ, ② ជាមធ្យម 15+ ម៉ោងក្នុងមួយសប្តាហ៍។ រយៈពេលនេះគឺដាច់ដោយឡែកពីរយៈពេលត្រួតពិនិត្យដែលអ្នកបានជ្រើសរើសពីមុន (រយៈពេលប្រាក់ឈ្នួលមិនទាន់បានបង់)។",
      id: "Masa kerja yang Anda masukkan di sini (dari tanggal mulai bekerja hingga tanggal pengunduran diri) hanya digunakan untuk memeriksa kondisi kelayakan pesangon — ① 1+ tahun layanan tanpa gangguan, ② rata-rata 15+ jam per minggu. Periode ini terpisah dari periode pemeriksaan yang Anda pilih sebelumnya (periode upah yang belum dibayar).",
      si: "ඔබ මෙහි ඇතුළත් කරන සේවා කාලය (රැකියාවට බැඳුණු දිනයේ සිට ඉල්ලා අස් වූ දිනය දක්වා) භාවිතා කරනු ලබන්නේ සේවා කාලය සඳහා සුදුසුකම් ලැබීමේ කොන්දේසි පරීක්ෂා කිරීමට පමණි — ① 1+ වසරක අඛණ්ඩ සේවය, ② සතියකට සාමාන්‍යයෙන් පැය 15+. මෙම කාලය ඔබ කලින් තෝරාගත් පරීක්ෂා කිරීමේ කාලයෙන් (නොගෙවූ වැටුප් කාලය) වෙනස් වේ.",
      bn: "এখানে আপনি যে চাকরির মেয়াদ (যোগদানের তারিখ থেকে পদত্যাগের তারিখ পর্যন্ত) প্রবেশ করেছেন, তা শুধুমাত্র সেভারেন্স পে যোগ্যতার শর্তগুলি পরীক্ষা করার জন্য ব্যবহৃত হয় — ① 1+ বছর নিরবচ্ছিন্ন পরিষেবা, ② সপ্তাহে গড়ে 15+ ঘন্টা। এই সময়কাল আপনার পূর্বে নির্বাচিত পর্যালোচনা সময়কাল (অপরিশোধিত মজুরি সময়কাল) থেকে আলাদা।",
      my: "ဤနေရာတွင် သင်ထည့်သွင်းထားသော လုပ်သက် (အလုပ်စဝင်သည့်ရက်မှ နုတ်ထွက်သည့်ရက်အထိ) ကို လုပ်သက်ဆုကြေးရရှိရန် အရည်အချင်းပြည့်မီမှု အခြေအနေများကို စစ်ဆေးရန်အတွက်သာ အသုံးပြုပါသည်။ — ① 1 နှစ်နှင့်အထက် အဆက်မပြတ်ဝန်ဆောင်မှု၊ ② တစ်ပတ်လျှင် ပျမ်းမျှ 15 နာရီနှင့်အထက်။ ဤကာလသည် သင်ယခင်က ရွေးချယ်ထားသော စစ်ဆေးမှုကာလ (မပေးရသေးသော လုပ်အားခကာလ) နှင့် သီးခြားစီဖြစ်သည်။",
      mn: "Энд оруулсан таны ажилласан хугацаа (ажилд орсон өдрөөс ажлаас гарсан өдөр хүртэл) нь зөвхөн тэтгэмжийн шаардлагыг шалгахад ашиглагдана — ① 1+ жил тасралтгүй ажилласан, ② долоо хоногт дунджаар 15+ цаг. Энэ хугацаа нь таны өмнө сонгосон шалгалтын хугацаанаас (төлөгдөөгүй цалингийн хугацаа) тусдаа байна.",
      lo: "ໄລຍະເວລາການເຮັດວຽກທີ່ທ່ານປ້ອນຢູ່ນີ້ (ຈາກວັນທີເລີ່ມຕົ້ນຈົນເຖິງວັນທີລາອອກ), ຖືກນໍາໃຊ້ພຽງແຕ່ເພື່ອກວດສອບເງື່ອນໄຂການມີສິດໄດ້ຮັບເງິນຊົດເຊີຍການອອກຈາກວຽກ — ① ການບໍລິການຕໍ່ເນື່ອງ 1+ ປີ, ② ສະເລ່ຍ 15+ ຊົ່ວໂມງຕໍ່ອາທິດ. ໄລຍະເວລານີ້ແມ່ນແຍກຕ່າງຫາກຈາກໄລຍະເວລາການກວດສອບທີ່ທ່ານເລືອກໄວ້ກ່ອນໜ້ານີ້ (ໄລຍະເວລາຄ່າຈ້າງທີ່ຍັງຄ້າງຈ່າຍ).",
      tet:
          "Tempu serbisu ne'ebé ó hatama iha ne'e (husi data hahú serbisu to'o data rezignasaun), uza de'it atu verifika kondisaun elegibilidade ba indemnizasaun tempu serbisu — ① 1+ tinan serbisu kontinuu, ② média 15+ oras kada semana. Períodu ida-ne'e la hanesan ho períodu verifikasaun ne'ebé ó hili ona (períodu saláriu ne'ebé seidauk selu).",
      ne: "तपाईंले यहाँ प्रविष्ट गर्नुभएको सेवा अवधि (काम सुरु गरेको मितिदेखि राजीनामा दिएको मितिसम्म), केवल सेवा निवृत्ति भत्ताको योग्यताका शर्तहरू जाँच गर्न प्रयोग गरिन्छ — ① 1+ वर्ष निरन्तर सेवा, ② प्रति हप्ता औसत 15+ घण्टा। यो अवधि, तपाईंले पहिले चयन गर्नुभएको जाँच अवधि (भुक्तान नगरिएको ज्याला अवधि) भन्दा फरक छ।",
      zh:
          '此处输入的在职期间（入职日期~离职日期）仅用于判断退休金发放条件——①连续工作1年以上，②周平均工作15小时以上。'
          '这与您之前选择的确认期间（欠薪期间）是分开的。',
      vi:
          'Thời gian làm việc bạn nhập ở đây (ngày vào làm~ngày nghỉ việc) chỉ dùng để xét điều kiện nhận trợ cấp thôi việc — ① làm việc liên tục từ 1 năm trở lên, ② trung bình từ 15 giờ/tuần trở lên. '
          'Đây là mục riêng biệt với khoảng thời gian kiểm tra (thời gian nợ lương) bạn đã chọn trước đó.',
      uz: "Bu yerga kiritgan ish stajingiz (ishga kirish sanasidan ishdan boʻshash sanasigacha) faqat ishdan boʻshatish nafaqasi huquqini tekshirish uchun ishlatiladi — ① 1 yildan ortiq uzluksiz xizmat, ② haftasiga oʻrtacha 15+ soat. Bu siz avval tanlagan tekshirish davridan (toʻlanmagan ish haqi davri) alohida.",
    ),
  ),
  'severance_extra': _E(
    L10nText(
      ko: '퇴직금 정밀 산정 추가 입력',
      en: 'Additional input for precise severance calculation',
      tr: "Hassas kıdem tazminatı hesaplaması için ek giriş",
      tg: "Вуруди иловагӣ барои ҳисобкунии дақиқи ҷуброни хидмат",
      fil: "Karagdagang input para sa tumpak na pagkalkula ng severance pay",
      ur: "علیحدگی تنخواہ کے درست حساب کے لیے اضافی اندراج",
      th: "ข้อมูลเพิ่มเติมสำหรับการคำนวณเงินชดเชยการเลิกจ้างที่แม่นยำ",
      ky: "Так кызматтан бошотуу жөлөкпулун эсептөө үчүн кошумча киргизүү",
      km: "ការបញ្ចូលបន្ថែមសម្រាប់ការគណនាប្រាក់បំណាច់អតីតភាពការងារឱ្យបានត្រឹមត្រូវ",
      id: "Input tambahan untuk perhitungan pesangon yang akurat",
      si: "නිවැරදි සේවා කාලය ගණනය කිරීම සඳහා අමතර ඇතුළත් කිරීම",
      bn: "সঠিক সেভারেন্স পে গণনার জন্য অতিরিক্ত ইনপুট",
      my: "လုပ်သက်ဆုကြေးကို တိကျစွာတွက်ချက်ရန်အတွက် ထပ်ဆောင်းထည့်သွင်းမှု",
      mn: "Тэтгэмжийн нарийн тооцоололд зориулсан нэмэлт мэдээлэл",
      lo: "ການປ້ອນຂໍ້ມູນເພີ່ມເຕີມສໍາລັບການຄິດໄລ່ເງິນຊົດເຊີຍການອອກຈາກວຽກທີ່ຊັດເຈນ",
      tet:
          "Hatama dadus adisionál ba kalkulasaun indemnizasaun tempu serbisu ne'ebé presizu",
      ne: "सटीक सेवा निवृत्ति भत्ता गणनाको लागि थप प्रविष्टि",
      zh: '退休金精确计算的附加输入',
      vi: 'Nhập thêm để tính chính xác trợ cấp thôi việc',
      uz: "Aniqlik uchun qoʻshimcha maʼlumotlar",
    ),
    L10nText(
      ko: '정기 상여금과 미사용 연차수당은 평균임금 계산 시 각 연간 총액의 3/12(25%)만큼 3개월 임금총액에 합산됩니다. 모르면 0으로 두어도 기본 계산은 진행됩니다.',
      en: "Regular bonuses and unused annual-leave pay are each added to the 3-month wage total at 3/12 (25%) of their annual amount when calculating average wage. If you don't know, leaving it at 0 still lets the basic calculation proceed.",
      tr: "Ortalama ücret hesaplanırken, düzenli ikramiyeler ve kullanılmayan yıllık izin ücretleri, yıllık tutarlarının 3/12'si (%25) oranında 3 aylık ücret toplamına eklenir. Bilmiyorsanız, 0 olarak bırakmak temel hesaplamanın devam etmesini sağlar.",
      tg: "Ҳангоми ҳисоб кардани музди миёна, мукофотпулиҳои мунтазам ва пардохтҳои рухсатии солонаи истифоданашуда ба андозаи 3/12 (25%) аз маблағи солонаи онҳо ба маҷмӯи музди меҳнати 3 моҳа илова карда мешаванд. Агар шумо намедонед, гузоштани он ҳамчун 0 имкон медиҳад, ки ҳисобкунии асосӣ идома ёбад.",
      fil:
          "Kapag kinakalkula ang average na sahod, ang regular na bonus at bayad para sa hindi nagamit na taunang bakasyon ay idinagdag sa kabuuang 3 buwanang sahod sa rate na 3/12 (25%) ng kanilang taunang halaga. Kung hindi mo alam, ang pag-iwan nito bilang 0 ay magpapatuloy sa pangunahing pagkalkula.",
      ur: "اوسط اجرت کا حساب لگاتے وقت، باقاعدہ بونس اور غیر استعمال شدہ سالانہ چھٹیوں کی اجرت، ان کی سالانہ رقم کا 3/12 (25%) کے تناسب سے 3 ماہانہ اجرت کے مجموعے میں شامل کیا جاتا ہے۔ اگر آپ نہیں جانتے تو، اسے 0 چھوڑنے سے بنیادی حساب جاری رہے گا۔",
      th: "ในการคำนวณค่าจ้างเฉลี่ย โบนัสปกติและค่าจ้างวันหยุดพักผ่อนประจำปีที่ไม่ได้ใช้ จะถูกเพิ่มเข้าไปในค่าจ้างรายเดือนรวม 3 ในอัตราส่วน 3/12 (25%) ของจำนวนเงินรายปี หากคุณไม่ทราบ การเว้นว่างไว้เป็น 0 จะช่วยให้การคำนวณพื้นฐานดำเนินต่อไปได้",
      ky: "Орточо эмгек акыны эсептөөдө, туруктуу бонустар жана пайдаланылбаган жылдык өргүү акысы, алардын жылдык суммасынын 3/12 бөлүгү (%25) катары 3 айлык эмгек акынын жалпы суммасына кошулат. Эгер билбесеңиз, 0 катары калтыруу негизги эсептөөнүн уланышына мүмкүндүк берет.",
      km: "នៅពេលគណនាប្រាក់ឈ្នួលជាមធ្យម ប្រាក់រង្វាន់ទៀងទាត់ និងប្រាក់ឈ្នួលឈប់សម្រាកប្រចាំឆ្នាំដែលមិនបានប្រើប្រាស់ ត្រូវបានបន្ថែមទៅក្នុងចំនួនប្រាក់ឈ្នួលប្រចាំខែសរុប 3 ក្នុងអត្រា 3/12 (25%) នៃចំនួនប្រចាំឆ្នាំរបស់ពួកគេ។ ប្រសិនបើអ្នកមិនដឹងទេ ការទុកវាជា 0 នឹងអនុញ្ញាតឱ្យការគណនាមូលដ្ឋានបន្តដំណើរការ។",
      id: "Saat menghitung gaji rata-rata, bonus reguler dan upah cuti tahunan yang tidak terpakai ditambahkan ke total gaji bulanan 3 sebesar 3/12 (25%) dari jumlah tahunan mereka. Jika Anda tidak tahu, membiarkannya sebagai 0 akan melanjutkan perhitungan dasar.",
      si: "සාමාන්‍ය වැටුප ගණනය කිරීමේදී, නිත්‍ය ප්‍රසාද දීමනා සහ භාවිත නොකළ වාර්ෂික නිවාඩු වැටුප්, ඒවායේ වාර්ෂික මුදලින් 3/12 (25%) අනුපාතයකින් 3 මාසික වැටුප් එකතුවට එකතු කරනු ලැබේ. ඔබ නොදන්නේ නම්, එය 0 ලෙස තැබීමෙන් මූලික ගණනය කිරීම දිගටම කරගෙන යාමට ඉඩ සලසයි.",
      bn: "গড় মজুরি গণনা করার সময়, নিয়মিত বোনাস এবং অব্যবহৃত বার্ষিক ছুটির বেতন তাদের বার্ষিক পরিমাণের 3/12 (25%) হিসাবে 3 মাসিক মজুরির মোট যোগ করা হয়। যদি আপনি না জানেন, এটি 0 হিসাবে রেখে দিলে মৌলিক গণনা চলতে থাকবে।",
      my: "ပျမ်းမျှလုပ်ခကို တွက်ချက်ရာတွင် ပုံမှန်ဆုကြေးငွေများနှင့် အသုံးမပြုရသေးသော နှစ်စဉ်ခွင့်ရက်များအတွက် လုပ်ခများကို ၎င်းတို့၏ နှစ်စဉ်ပမာဏ၏ 3/12 (25%) အချိုးအစားဖြင့် စုစုပေါင်း 3 လစာထဲသို့ ထည့်သွင်းပါသည်။ အကယ်၍ သင်မသိပါက၊ ၎င်းကို 0 အဖြစ်ထားခြင်းဖြင့် အခြေခံတွက်ချက်မှုကို ဆက်လက်လုပ်ဆောင်နိုင်မည်ဖြစ်သည်။",
      mn: "Дундаж цалинг тооцохдоо тогтмол урамшуулал болон ашиглагдаагүй жилийн амралтын төлбөрийг жилийн нийт дүнгийн 3/12 буюу (25%)-иар 3 сарын цалингийн нийлбэрт нэмнэ. Хэрэв та мэдэхгүй бол 0 гэж орхисноор үндсэн тооцоо үргэлжилнэ.",
      lo: "ໃນເວລາຄິດໄລ່ຄ່າຈ້າງສະເລ່ຍ, ເງິນໂບນັດປົກກະຕິ ແລະ ຄ່າຈ້າງພັກປະຈຳປີທີ່ບໍ່ໄດ້ໃຊ້ຈະຖືກເພີ່ມເຂົ້າໃນຍອດລວມຄ່າຈ້າງລາຍເດືອນ 3 ໃນອັດຕາສ່ວນ 3/12 (25%) ຂອງຈຳນວນເງິນປະຈຳປີ. ຖ້າທ່ານບໍ່ຮູ້, ການປ່ອຍໃຫ້ 0 ຫວ່າງໄວ້ຈະຊ່ວຍໃຫ້ການຄິດໄລ່ພື້ນຖານດຳເນີນຕໍ່ໄປ.",
      tet:
          "Bainhira kalkula saláriu médiu, bonús regulár no pagamentu lisensa anuál ne'ebé la uza sei tau hamutuk ba totál saláriu fulan nian 3 iha taxa 3/12 (25%) husi montante anuál. Se Ita la hatene, husik hela nu'udar 0 sei permite kalkulasaun bázika atu kontinua.",
      ne: "औसत ज्याला गणना गर्दा, नियमित बोनस र प्रयोग नगरिएको वार्षिक बिदाको भुक्तानी तिनीहरूको वार्षिक रकमको 3/12 (25%) को दरमा 3 महिनाको ज्यालाको कुलमा थपिन्छ। यदि तपाईंलाई थाहा छैन भने, यसलाई 0 छोड्दा आधारभूत गणना अगाडि बढ्न मद्दत गर्छ।",
      zh: '计算平均工资时，定期奖金和未使用年假补贴将分别按各自年度总额的3/12（25%）计入3个月工资总额。如果不清楚，留空为0也可以进行基本计算。',
      vi: 'Khi tính lương bình quân, tiền thưởng định kỳ và phụ cấp phép năm chưa dùng sẽ được cộng vào tổng lương 3 tháng theo tỷ lệ 3/12 (25%) của tổng số hàng năm. Nếu không biết, để 0 vẫn có thể tính toán cơ bản.',
      uz: "Oʻrtacha ish haqini hisoblashda muntazam bonuslar va foydalanilmagan yillik taʼtil haqi har biri yillik miqdorining 3/12 (25%) qismi sifatida 3 oylik ish haqi yigʻindisiga qoʻshiladi. Agar bilmasangiz, 0 qoldirish ham asosiy hisob-kitobni davom ettirishga imkon beradi.",
    ),
  ),
  'severance_intro': _E(
    L10nText(
      ko: '예상 퇴직금이란',
      en: 'What is estimated severance pay',
      tr: "Tahmini kıdem tazminatı nedir",
      tg: "Ҷуброни тахминии хизмати собиқа чист?",
      fil: "Ano ang tinatayang severance pay?",
      ur: "تخمینی سروس انعام کیا ہے؟",
      th: "เงินชดเชยการเลิกจ้างโดยประมาณคือเท่าไร",
      ky: "Болжолдуу кызматтан бошотуу жөлөкпулу деген эмне?",
      km: "តើប្រាក់បំណាច់អតីតភាពការងារប៉ាន់ស្មានមានប៉ុន្មាន?",
      id: "Apa itu perkiraan pesangon?",
      si: "අනාවැකි පළ කරන ලද සේවා කාලය සඳහා වන්දි මුදල කුමක්ද?",
      bn: "আনুমানিক অবসরকালীন ভাতা কী?",
      my: "ခန့်မှန်းခြေ ဝန်ထမ်းသက်တမ်းအလိုက် ဆုကြေးငွေက ဘယ်လောက်လဲ",
      mn: "Тооцоолсон тэтгэмж гэж юу вэ?",
      lo: "ເງິນຊົດເຊີຍການອອກຈາກວຽກທີ່ຄາດຄະເນແມ່ນຫຍັງ",
      tet: "Saida mak estimasaun pagamentu indemnizasaun?",
      ne: "अनुमानित सेवा निवृत्ति भत्ता (severance pay) के हो?",
      zh: '预计退休金是什么',
      vi: 'Trợ cấp thôi việc dự kiến là gì',
      uz: "Taxminiy ishdan boʻshatish nafaqasi nima?",
    ),
    L10nText(
      ko: '재직 기간이 1년 이상이고 주 평균 15시간 이상 근무했다면, 근로 형태·사업장 규모와 관계없이 발생하는 별도의 법정 금액입니다. 임금과는 별도로 계산됩니다.',
      en: 'If you worked 1+ year with a weekly average of 15+ hours, this is a separate statutory amount that applies regardless of your employment type or business size. It is calculated separately from wages.',
      tr: "Haftalık ortalama 15+ saat ile 1+ yıl çalıştıysanız, bu, istihdam türünüz veya işletme büyüklüğünüz ne olursa olsun uygulanan ayrı bir yasal tutardır. Ücretlerden ayrı olarak hesaplanır.",
      tg: "Агар шумо ба ҳисоби миёна дар як ҳафта 15+ соат ва 1+ сол кор карда бошед, ин маблағи алоҳидаи қонунӣ мебошад, ки новобаста аз намуди шуғл ё андозаи тиҷорати шумо татбиқ мегардад. Он аз музди меҳнат алоҳида ҳисоб карда мешавад.",
      fil:
          "Kung nagtrabaho ka ng 15+ oras bawat linggo at 1+ taon, ito ay isang hiwalay na legal na halaga na inilalapat anuman ang uri ng iyong trabaho o laki ng negosyo. Kinakalkula ito nang hiwalay mula sa sahod.",
      ur: "اگر آپ نے اوسطاً ہفتے میں 15+ گھنٹے اور 1+ سال کام کیا ہے، تو یہ ایک علیحدہ قانونی رقم ہے جو آپ کے روزگار کی قسم یا کاروبار کے سائز سے قطع نظر لاگو ہوتی ہے۔ اس کا حساب اجرت سے الگ کیا جاتا ہے۔",
      th: "หากคุณทำงาน 15+ ชั่วโมงต่อสัปดาห์ เป็นเวลา 1+ ปี นี่คือจำนวนเงินตามกฎหมายแยกต่างหากที่บังคับใช้ ไม่ว่าประเภทการจ้างงานหรือขนาดธุรกิจของคุณจะเป็นอย่างไร โดยจะคำนวณแยกต่างหากจากค่าจ้าง",
      ky: "Эгер сиз жумасына орточо 15+ сааттан 1+ жыл иштеген болсоңуз, бул сиздин жумуштун түрүнө же ишкананын көлөмүнө карабастан колдонулуучу өзүнчө мыйзамдуу сумма. Ал эмгек акыдан өзүнчө эсептелет.",
      km: "ប្រសិនបើអ្នកបានធ្វើការ 15+ ម៉ោងក្នុងមួយសប្តាហ៍ និង 1+ ឆ្នាំ នេះគឺជាចំនួនទឹកប្រាក់ស្របច្បាប់ដាច់ដោយឡែកដែលត្រូវបានអនុវត្តដោយមិនគិតពីប្រភេទការងារ ឬទំហំអាជីវកម្មរបស់អ្នក។ វាត្រូវបានគណនាដាច់ដោយឡែកពីប្រាក់ឈ្នួល។",
      id: "Jika Anda telah bekerja rata-rata 15+ jam per minggu selama 1+ tahun, ini adalah jumlah hukum terpisah yang berlaku terlepas dari jenis pekerjaan atau ukuran bisnis Anda. Ini dihitung secara terpisah dari upah.",
      si: "ඔබ සතියකට පැය 15+ක් සහ වසර 1+ක් සේවය කර ඇත්නම්, මෙය ඔබේ රැකියා වර්ගය හෝ ව්‍යාපාරයේ ප්‍රමාණය කුමක් වුවත් අදාළ වන වෙනම නීත්‍යානුකූල මුදලකි. එය වැටුපෙන් වෙන්ව ගණනය කෙරේ.",
      bn: "যদি আপনি সপ্তাহে 15+ ঘন্টা এবং 1+ বছর ধরে কাজ করে থাকেন, তাহলে এটি একটি পৃথক আইনি পরিমাণ যা আপনার কর্মসংস্থানের ধরন বা ব্যবসার আকার নির্বিশেষে প্রযোজ্য। এটি মজুরি থেকে আলাদাভাবে গণনা করা হয়।",
      my: "အကယ်၍ သင်သည် တစ်ပတ်လျှင် 15+ နာရီနှင့် 1+ နှစ်ကြာ အလုပ်လုပ်ခဲ့ပါက၊ ၎င်းသည် သင်၏ အလုပ်အမျိုးအစား သို့မဟုတ် လုပ်ငန်းအရွယ်အစား မည်သို့ပင်ရှိစေကာမူ သက်ဆိုင်သည့် သီးခြားတရားဝင်ပမာဏတစ်ခုဖြစ်သည်။ ၎င်းကို လုပ်ခများမှ သီးခြားတွက်ချက်ပါသည်။",
      mn: "Хэрэв та долоо хоногт дунджаар 15+ цаг, 1+ жил ажилласан бол энэ нь таны ажлын төрөл, бизнесийн хэмжээнээс үл хамааран хэрэгждэг тусдаа хууль ёсны хэмжээ юм. Энэ нь цалингаас тусад нь тооцогддог.",
      lo: "ຖ້າທ່ານໄດ້ເຮັດວຽກສະເລ່ຍ 15+ ຊົ່ວໂມງຕໍ່ອາທິດ ເປັນເວລາ 1+ ປີ, ນີ້ແມ່ນຈຳນວນເງິນຕາມກົດໝາຍແຍກຕ່າງຫາກທີ່ນຳໃຊ້ໂດຍບໍ່ຄຳນຶງເຖິງປະເພດການຈ້າງງານ ຫຼື ຂະໜາດທຸລະກິດຂອງທ່ານ. ມັນຖືກຄິດໄລ່ແຍກຕ່າງຫາກຈາກຄ່າຈ້າງ.",
      tet:
          "Se Ita servisu ona ho média 15+ oras kada semana no 1+ tinan, ida ne'e mak montante legál separadu ne'ebé aplika, la importa Ita-nia tipu empregu ka tamañu negósiu. Kalkula separadu husi saláriu.",
      ne: "यदि तपाईंले प्रति हप्ता औसत 15+ घण्टाको साथ 1+ वर्ष काम गर्नुभएको छ भने, यो तपाईंको रोजगारीको प्रकार वा व्यवसायको आकार जस्तोसुकै भए पनि लागू हुने छुट्टै कानूनी रकम हो। यो ज्यालाबाट छुट्टै गणना गरिन्छ।",
      zh: '如果在职期间1年以上且周平均工作15小时以上，无论用工形式或企业规模如何，都会产生这笔单独的法定金额。此金额与工资分开计算。',
      vi: 'Nếu làm việc từ 1 năm trở lên và trung bình từ 15 giờ/tuần trở lên, đây là khoản tiền pháp định riêng, phát sinh bất kể hình thức lao động hay quy mô doanh nghiệp. Được tính riêng, không gộp vào lương.',
      uz: "Agar siz haftasiga oʻrtacha 15+ soat bilan 1 yildan ortiq ishlagan boʻlsangiz, bu sizning ish turi yoki korxona hajmiga qaramay qoʻllaniladigan alohida qonuniy miqdordir. U ish haqidan alohida hisoblanadi.",
    ),
  ),
  'logic_base': _E(
    L10nText(
      ko: '기본급 산정 원리',
      en: 'How base pay is calculated',
      tr: "Temel ücret nasıl hesaplanır",
      tg: "Музди асосӣ чӣ гуна ҳисоб карда мешавад?",
      fil: "Paano kinakalkula ang basic pay?",
      ur: "بنیادی اجرت کا حساب کیسے لگایا جاتا ہے؟",
      th: "ค่าจ้างพื้นฐานคำนวณอย่างไร",
      ky: "Негизги эмгек акы кантип эсептелет?",
      km: "តើប្រាក់ឈ្នួលមូលដ្ឋានត្រូវបានគណនាដោយរបៀបណា?",
      id: "Bagaimana gaji dasar dihitung?",
      si: "මූලික වැටුප ගණනය කරන්නේ කෙසේද?",
      bn: "মৌলিক মজুরি কীভাবে গণনা করা হয়?",
      my: "အခြေခံလုပ်ခကို ဘယ်လိုတွက်ချက်သလဲ",
      mn: "Үндсэн цалинг хэрхэн тооцох вэ?",
      lo: "ຄ່າຈ້າງພື້ນຖານຖືກຄິດໄລ່ແນວໃດ",
      tet: "Oinsá mak kalkula saláriu báziku?",
      ne: "आधारभूत ज्याला कसरी गणना गरिन्छ?",
      zh: '基本工资计算原理',
      vi: 'Nguyên lý tính lương cơ bản',
      uz: "Asosiy ish haqi qanday hisoblanadi?",
    ),
    L10nText(
      ko: '약정 근로시간(또는 근무일수)에 통상시급(또는 일급)을 곱하여 산정한 기본 급여입니다.',
      en: 'Base pay is calculated by multiplying your contracted hours (or days worked) by your ordinary hourly (or daily) wage.',
      tr: "Temel ücret, sözleşmeli saatlerinizin (veya çalışılan günlerin) normal saatlik (veya günlük) ücretinizle çarpılmasıyla hesaplanır.",
      tg: "Музди асосӣ бо роҳи зарб кардани соатҳои шартномавии шумо (ё рӯзҳои корӣ) ба меъёри муқаррарии соатбайъ (ё рӯзонаи) шумо ҳисоб карда мешавад.",
      fil:
          "Ang basic pay ay kinakalkula sa pamamagitan ng pagpaparami ng iyong mga oras na nakasaad sa kontrata (o mga araw na nagtrabaho) sa iyong normal na oras-oras (o araw-araw) na rate ng sahod.",
      ur: "بنیادی اجرت کا حساب آپ کے معاہدے کے اوقات (یا کام کے دنوں) کو آپ کی عام فی گھنٹہ (یا یومیہ) اجرت سے ضرب دے کر کیا جاتا ہے۔",
      th: "ค่าจ้างพื้นฐานคำนวณโดยการนำชั่วโมงตามสัญญา (หรือวันที่ทำงาน) คูณด้วยอัตราค่าจ้างรายชั่วโมง (หรือรายวัน) ปกติของคุณ",
      ky: "Негизги эмгек акы келишимде көрсөтүлгөн сааттарды (же иштеген күндөрдү) кадимки сааттык (же күндүк) эмгек акыңызга көбөйтүү менен эсептелет.",
      km: "ប្រាក់ឈ្នួលមូលដ្ឋានត្រូវបានគណនាដោយការគុណម៉ោងតាមកិច្ចសន្យារបស់អ្នក (ឬថ្ងៃធ្វើការ) ជាមួយនឹងអត្រាប្រាក់ឈ្នួលធម្មតារបស់អ្នកក្នុងមួយម៉ោង (ឬក្នុងមួយថ្ងៃ)។",
      id: "Gaji dasar dihitung dengan mengalikan jam kontrak Anda (atau hari kerja) dengan upah per jam (atau harian) normal Anda.",
      si: "මූලික වැටුප ගණනය කරනු ලබන්නේ ඔබේ කොන්ත්‍රාත්ගත පැය ගණන (හෝ වැඩ කළ දින ගණන) ඔබේ සාමාන්‍ය පැයකට (හෝ දිනකට) වැටුපෙන් ගුණ කිරීමෙනි.",
      bn: "মৌলিক মজুরি আপনার চুক্তিবদ্ধ ঘন্টা (বা কাজের দিন) আপনার স্বাভাবিক প্রতি ঘন্টা (বা দৈনিক) মজুরি দ্বারা গুণ করে গণনা করা হয়।",
      my: "အခြေခံလုပ်ခကို သင်၏ စာချုပ်ပါနာရီများ (သို့မဟုတ် အလုပ်လုပ်ခဲ့သည့်ရက်များ) ကို သင်၏ ပုံမှန်နာရီအလိုက် (သို့မဟုတ် နေ့အလိုက်) လုပ်ခဖြင့် မြှောက်ခြင်းဖြင့် တွက်ချက်ပါသည်။",
      mn: "Үндсэн цалинг таны гэрээт цагийг (эсвэл ажилласан өдрийг) ердийн цагийн (эсвэл өдрийн) цалингаар үржүүлж тооцно.",
      lo: "ຄ່າຈ້າງພື້ນຖານແມ່ນຄິດໄລ່ໂດຍການຄູນຊົ່ວໂມງຕາມສັນຍາຂອງທ່ານ (ຫຼື ມື້ເຮັດວຽກ) ດ້ວຍອັດຕາຄ່າຈ້າງປົກກະຕິຕໍ່ຊົ່ວໂມງ (ຫຼື ຕໍ່ມື້) ຂອງທ່ານ.",
      tet:
          "Saláriu báziku kalkula hosi oras kontratu (ka loron servisu) Ita-nian multiplika ho Ita-nia taxa oras (ka loron) normál.",
      ne: "आधारभूत ज्याला तपाईंको अनुबन्धित घण्टा (वा काम गरेको दिन) लाई तपाईंको सामान्य प्रति घण्टा (वा दैनिक) ज्यालाले गुणन गरेर गणना गरिन्छ।",
      zh: '基本工资是用约定工作时间（或工作天数）乘以通常时薪（或日薪）计算得出的。',
      vi: 'Lương cơ bản được tính bằng cách nhân số giờ làm việc thỏa thuận (hoặc số ngày làm việc) với lương giờ thông thường (hoặc lương ngày).',
      uz: "Asosiy ish haqi shartnomadagi soatlaringiz (yoki ishlagan kunlaringiz)ni oddiy soatlik (yoki kunlik) ish haqingizga koʻpaytirish orqali hisoblanadi.",
    ),
  ),
  'logic_week': _E(
    L10nText(
      ko: '주휴수당 산정 원리',
      en: 'How weekly holiday allowance is calculated',
      tr: "Haftalık tatil ödeneği nasıl hesaplanır",
      tg: "Пардохти рухсатии ҳафтаина чӣ гуна ҳисоб карда мешавад?",
      fil: "Paano kinakalkula ang allowance para sa lingguhang holiday?",
      ur: "ہفتہ وار چھٹی کی اجرت کا حساب کیسے لگایا جاتا ہے؟",
      th: "ค่าจ้างวันหยุดประจำสัปดาห์คำนวณอย่างไร",
      ky: "Жумалык эс алуу акысы кантип эсептелет?",
      km: "តើប្រាក់ឧបត្ថម្ភឈប់សម្រាកប្រចាំសប្តាហ៍ត្រូវបានគណនាដោយរបៀបណា?",
      id: "Bagaimana tunjangan libur mingguan dihitung?",
      si: "සතිපතා නිවාඩු දීමනාව ගණනය කරන්නේ කෙසේද?",
      bn: "সাপ্তাহিক ছুটির ভাতা কীভাবে গণনা করা হয়?",
      my: "အပတ်စဉ် အားလပ်ရက်စရိတ်ကို ဘယ်လိုတွက်ချက်သလဲ",
      mn: "Долоо хоногийн амралтын тэтгэмжийг хэрхэн тооцох вэ?",
      lo: "ເງິນອຸດໜູນພັກປະຈຳອາທິດຖືກຄິດໄລ່ແນວໃດ",
      tet: "Oinsá mak kalkula subsídiu feriadu semana nian?",
      ne: "साप्ताहिक बिदा भत्ता कसरी गणना गरिन्छ?",
      zh: '周休津贴计算原理',
      vi: 'Nguyên lý tính phụ cấp nghỉ hằng tuần',
      uz: "Haftalik dam olish nafaqasi qanday hisoblanadi?",
    ),
    L10nText(
      ko: '주 15시간 이상 개근 시 지급되는 유급휴일 수당입니다. (월급제·연봉제는 이미 포함되어 별도로 더하지 않습니다)',
      en: 'A paid-holiday allowance given when you work 15+ hours a week with perfect attendance. (Already included for monthly/annual pay, so it is not added separately.)',
      tr: "Haftada 15+ saat tam katılım ile çalıştığınızda verilen ücretli tatil ödeneği. (Aylık/yıllık ücrete zaten dahildir, bu nedenle ayrıca eklenmez.)",
      tg: "Пардохти рухсатии пулакӣ, ки ҳангоми кор кардани шумо бо иштироки пурра 15+ соат дар як ҳафта дода мешавад. (Он аллакай ба музди моҳона/солона дохил карда шудааст, аз ин рӯ алоҳида илова карда намешавад.)",
      fil:
          "Ang bayad na allowance sa holiday na ibinibigay kapag nagtatrabaho ka ng 15+ oras bawat linggo na may buong pagdalo. (Kasama na ito sa buwanan/taunang sahod, kaya hindi na ito idinadagdag pa.)",
      ur: "جب آپ ہفتے میں 15+ گھنٹے مکمل حاضری کے ساتھ کام کرتے ہیں تو ادا کی جانے والی چھٹی کی اجرت۔ (یہ پہلے ہی ماہانہ/سالانہ اجرت میں شامل ہوتی ہے، لہذا اسے الگ سے شامل نہیں کیا جاتا۔)",
      th: "ค่าจ้างวันหยุดประจำสัปดาห์ที่ได้รับเมื่อคุณทำงานครบ 15+ ชั่วโมงต่อสัปดาห์ (รวมอยู่ในค่าจ้างรายเดือน/รายปีอยู่แล้ว จึงไม่ถูกเพิ่มแยกต่างหาก)",
      ky: "Жумасына 15+ саат толук катышуу менен иштегенде берилүүчү акы төлөнүүчү эс алуу жөлөкпулу. (Ал айлык/жылдык эмгек акыга мурунтан эле киргизилген, ошондуктан кошумча кошулбайт.)",
      km: "ប្រាក់ឧបត្ថម្ភឈប់សម្រាកដែលមានប្រាក់ឈ្នួលដែលត្រូវបានផ្តល់ឱ្យនៅពេលអ្នកធ្វើការពេញម៉ោង 15+ ម៉ោងក្នុងមួយសប្តាហ៍។ (វាត្រូវបានរួមបញ្ចូលរួចហើយនៅក្នុងប្រាក់ឈ្នួលប្រចាំខែ/ប្រចាំឆ្នាំ ដូច្នេះវាមិនត្រូវបានបន្ថែមដាច់ដោយឡែកនោះទេ។)",
      id: "Tunjangan libur berbayar yang diberikan saat Anda bekerja 15+ jam seminggu dengan kehadiran penuh. (Sudah termasuk dalam gaji bulanan/tahunan, jadi tidak ditambahkan secara terpisah.)",
      si: "සතියකට පැය 15+ක් සම්පූර්ණ පැමිණීමකින් වැඩ කරන විට ගෙවන වැටුප් සහිත නිවාඩු දීමනාව. (එය දැනටමත් මාසික/වාර්ෂික වැටුපට ඇතුළත් කර ඇති බැවින්, එය වෙන වෙනම එකතු නොවේ.)",
      bn: "সপ্তাহে 15+ ঘন্টা পূর্ণ উপস্থিতিতে কাজ করলে প্রদত্ত বেতনভুক্ত ছুটির ভাতা। (এটি মাসিক/বার্ষিক বেতনের মধ্যে ইতিমধ্যেই অন্তর্ভুক্ত, তাই এটি আলাদাভাবে যোগ করা হয় না।)",
      my: "တစ်ပတ်လျှင် 15+ နာရီ အပြည့်အဝ တက်ရောက်၍ အလုပ်လုပ်သည့်အခါ ပေးချေသည့် လုပ်ခနှင့်တူသော အားလပ်ရက်စရိတ်။ (၎င်းသည် လစဉ်/နှစ်စဉ်လုပ်ခတွင် ပါဝင်ပြီးဖြစ်သောကြောင့် သီးခြားထပ်ပေါင်းထည့်ရန် မလိုအပ်ပါ။)",
      mn: "Долоо хоногт 15+ цаг бүрэн ажилласан тохиолдолд олгох цалинтай амралтын тэтгэмж. (Энэ нь сарын/жилийн цалинд багтсан байдаг тул тусад нь нэмэгдэхгүй.)",
      lo: "ເງິນອຸດໜູນພັກທີ່ໄດ້ຮັບຄ່າຈ້າງແມ່ນໃຫ້ເມື່ອທ່ານເຮັດວຽກຄົບຖ້ວນ 15+ ຊົ່ວໂມງຕໍ່ອາທິດ. (ມັນໄດ້ຖືກລວມຢູ່ໃນຄ່າຈ້າງລາຍເດືອນ/ລາຍປີແລ້ວ, ດັ່ງນັ້ນຈຶ່ງບໍ່ໄດ້ເພີ່ມຕື່ມອີກ.)",
      tet:
          "Subsídiu feriadu pagu ne'ebé fó bainhira Ita servisu ho prezensa kompleta ba 15+ oras kada semana. (Ida ne'e inklui ona iha saláriu fulan/anuál, tanba ne'e la presiza tau tan.)",
      ne: "प्रति हप्ता 15+ घण्टा पूर्ण उपस्थितिका साथ काम गर्दा दिइने सशुल्क बिदा भत्ता। (यो मासिक/वार्षिक तलबमा पहिले नै समावेश हुन्छ, त्यसैले छुट्टै थपिँदैन।)",
      zh: '每周工作15小时以上且全勤时发放的带薪假期津贴。（月薪制、年薪制已包含在内，不另行增加）',
      vi: 'Là phụ cấp ngày nghỉ có lương khi làm từ 15 giờ/tuần trở lên và đi làm đầy đủ. (Đã bao gồm trong lương tháng/lương năm nên không cộng thêm riêng)',
      uz: "Haftasiga 15+ soat toʻliq qatnashib ishlaganda beriladigan pullik dam olish nafaqasi. (Oylik/yillik ish haqiga allaqachon kiritilgan, shuning uchun alohida qoʻshilmaydi.)",
    ),
  ),
  'logic_gross': _E(
    L10nText(
      ko: '세전 총액',
      en: 'Total before tax',
      tr: "Vergi öncesi toplam",
      tg: "Ҷамъи пеш аз андоз",
      fil: "Kabuuang bago ang buwis",
      ur: "ٹیکس سے پہلے کا کل",
      th: "ยอดรวมก่อนหักภาษี",
      ky: "Салыкка чейинки жалпы сумма",
      km: "ចំនួនសរុបមុនពេលបង់ពន្ធ",
      id: "Total sebelum pajak",
      si: "බදු පෙර මුළු එකතුව",
      bn: "কর-পূর্ব মোট",
      my: "အခွန်မဆောင်မီ စုစုပေါင်း",
      mn: "Татварын өмнөх нийт дүн",
      lo: "ຍອດລວມກ່ອນຫັກພາສີ",
      tet: "Totál antes impostu",
      ne: "कर अघिको कुल रकम",
      zh: '税前总额',
      vi: 'Tổng trước thuế',
      uz: "Soliqdan oldingi jami",
    ),
    L10nText(
      ko: '기본급 + 주휴수당 + 가산수당(연장·야간·휴일)을 모두 더한 금액입니다. 여기서 세금과 숙식비를 빼면 실수령액이 됩니다.',
      en: 'This is base pay + weekly holiday allowance + premium pay (overtime/night/holiday) added together. Subtracting tax and board/lodging from this gives your take-home pay.',
      tr: "Bu, temel ücret + haftalık tatil ödeneği + prim ücreti (fazla mesai/gece/tatil) toplamıdır. Bundan vergi ve yemek/konaklama çıkarıldığında net maaşınız elde edilir.",
      tg: "Ин маҷмӯи музди асосӣ + пардохти рухсатии ҳафтаина + музди иловагӣ (коркарди изофагӣ/шабона/ид). Аз ин андоз ва хӯрок/манзил тарҳ карда мешавад, то маоши холиси шуморо ба даст орад.",
      fil:
          "Ito ang kabuuan ng basic pay + allowance para sa lingguhang holiday + premium pay (overtime/gabi/holiday). Kapag ibinawas ang buwis at pagkain/tirahan mula rito, makukuha mo ang iyong netong sahod.",
      ur: "یہ بنیادی اجرت + ہفتہ وار چھٹی کی اجرت + پریمیم اجرت (اوور ٹائم/رات/چھٹی) کا مجموعہ ہے۔ اس میں سے ٹیکس اور کھانے/رہائش کی کٹوتی کے بعد آپ کی خالص تنخواہ حاصل ہوتی ہے۔",
      th: "นี่คือผลรวมของค่าจ้างพื้นฐาน + ค่าจ้างวันหยุดประจำสัปดาห์ + ค่าจ้างพิเศษ (ล่วงเวลา/กลางคืน/วันหยุด) เมื่อหักภาษีและค่าอาหาร/ที่พักออกจากจำนวนนี้ คุณจะได้เงินเดือนสุทธิของคุณ",
      ky: "Бул негизги эмгек акы + жумалык эс алуу акысы + премиум акы (ашыкча иштөө/түнкү/майрам күндөрү) суммасы. Мындан салык жана тамак-аш/турак жай чыгарылганда таза эмгек акыңыз алынат.",
      km: "នេះគឺជាផលបូកនៃប្រាក់ឈ្នួលមូលដ្ឋាន + ប្រាក់ឧបត្ថម្ភឈប់សម្រាកប្រចាំសប្តាហ៍ + ប្រាក់ឈ្នួលបុព្វលាភ (ម៉ោងបន្ថែម/ពេលយប់/ថ្ងៃឈប់សម្រាក)។ ការដកពន្ធ និងអាហារ/កន្លែងស្នាក់នៅពីនេះ នឹងផ្តល់ឱ្យអ្នកនូវប្រាក់ខែសុទ្ធរបស់អ្នក។",
      id: "Ini adalah total gaji dasar + tunjangan libur mingguan + upah premium (lembur/malam/libur). Setelah dikurangi pajak dan biaya makan/akomodasi, ini akan menjadi gaji bersih Anda.",
      si: "මෙය මූලික වැටුප + සතිපතා නිවාඩු දීමනාව + වාරික වැටුප (අතිකාල/රාත්‍රී/නිවාඩු) එකතුවයි. මෙයින් බදු සහ ආහාර/නවාතැන් අඩු කළ විට ඔබේ ශුද්ධ වැටුප ලැබේ.",
      bn: "এটি মৌলিক মজুরি + সাপ্তাহিক ছুটির ভাতা + প্রিমিয়াম মজুরি (ওভারটাইম/রাত্রি/ছুটি) এর মোট। এটি থেকে কর এবং খাবার/আবাসন বাদ দিলে আপনার নিট বেতন পাওয়া যায়।",
      my: "၎င်းသည် အခြေခံလုပ်ခ + အပတ်စဉ် အားလပ်ရက်စရိတ် + ပရီမီယံလုပ်ခ (အချိန်ပို/ညဆိုင်း/အားလပ်ရက်) တို့၏ စုစုပေါင်းဖြစ်သည်။ ၎င်းမှ အခွန်နှင့် အစားအသောက်/နေထိုင်စရိတ်များကို နုတ်လိုက်ပါက သင်၏ အသားတင်လစာကို ရရှိမည်ဖြစ်သည်။",
      mn: "Энэ нь үндсэн цалин + долоо хоногийн амралтын тэтгэмж + нэмэгдэл цалин (илүү цаг/шөнийн/амралтын өдөр) нийлбэр юм. Үүнээс татвар болон хоол/байрны зардлыг хассанаар таны цэвэр цалин гарна.",
      lo: "ນີ້ແມ່ນຍອດລວມຂອງຄ່າຈ້າງພື້ນຖານ + ເງິນອຸດໜູນພັກປະຈຳອາທິດ + ຄ່າຈ້າງພິເສດ (ລ່ວງເວລາ/ກາງຄືນ/ວັນພັກ). ເມື່ອຫັກພາສີ ແລະ ຄ່າອາຫານ/ທີ່ພັກອອກຈາກຈຳນວນນີ້, ທ່ານຈະໄດ້ຮັບເງິນເດືອນສຸດທິຂອງທ່ານ.",
      tet:
          "Ida ne'e mak totál saláriu báziku + subsídiu feriadu semana nian + saláriu prémiu (oras estra/kalan/feríadu). Husi ida ne'e, bainhira hasai impostu no hahán/akomodasaun, Ita sei hetan Ita-nia saláriu likidu.",
      ne: "यो आधारभूत ज्याला + साप्ताहिक बिदा भत्ता + प्रिमियम ज्याला (ओभरटाइम/रात/बिदा) को कुल योग हो। यसबाट कर र खाना/आवास घटाउँदा तपाईंको खुद तलब प्राप्त हुन्छ।",
      zh: '这是基本工资+周休津贴+加成津贴（加班·夜班·休息日）相加的金额。从中扣除税金和食宿费后即为实际到手金额。',
      vi: 'Đây là lương cơ bản + phụ cấp nghỉ hằng tuần + phụ cấp thêm (làm thêm giờ/đêm/ngày nghỉ) cộng lại. Trừ thuế và tiền ăn ở khỏi số này sẽ ra số tiền thực nhận.',
      uz: "Bu asosiy ish haqi + haftalik dam olish nafaqasi + qoʻshimcha haq (ishdan tashqari/tungi/bayram) yigʻindisidir. Bundan soliq va yotoqxona/ovqatlanishni ayirish sizning qoʻlingizga tegadigan ish haqini beradi.",
    ),
  ),
  'logic_net': _E(
    L10nText(
      ko: '예상 실수령액',
      en: 'Estimated take-home pay',
      tr: "Tahmini net maaş",
      tg: "Маоши холиси тахминӣ",
      fil: "Tinatayang netong sahod",
      ur: "تخمینی خالص تنخواہ",
      th: "เงินเดือนสุทธิโดยประมาณ",
      ky: "Болжолдуу таза эмгек акы",
      km: "ប្រាក់ខែសុទ្ធប៉ាន់ស្មាន",
      id: "Perkiraan gaji bersih",
      si: "අනාවැකි පළ කරන ලද ශුද්ධ වැටුප",
      bn: "আনুমানিক নিট বেতন",
      my: "ခန့်မှန်းခြေ အသားတင်လစာ",
      mn: "Тооцоолсон цэвэр цалин",
      lo: "ເງິນເດືອນສຸດທິທີ່ຄາດຄະເນ",
      tet: "Estimasaun saláriu likidu",
      ne: "अनुमानित खुद तलब",
      zh: '预计实际到手金额',
      vi: 'Số tiền thực nhận dự kiến',
      uz: "Taxminiy qoʻlingizga tegadigan ish haqi",
    ),
    L10nText(
      ko: '세전 총액에서 선택하신 세금 공제와 숙식비 공제를 뺀 금액입니다.',
      en: 'This is the pre-tax total minus the tax deduction and board/lodging deduction you selected.',
      tr: "Bu, seçtiğiniz vergi kesintisi ve yemek/konaklama kesintisi çıkarıldıktan sonraki vergi öncesi toplamdır.",
      tg: "Ин маҷмӯи пеш аз андоз пас аз тарҳ кардани тарҳи андози интихобкардаи шумо ва тарҳи хӯрок/манзил мебошад.",
      fil:
          "Ito ang kabuuang bago ang buwis pagkatapos ibawas ang iyong napiling pagbabawas ng buwis at pagbabawas para sa pagkain/tirahan.",
      ur: "یہ آپ کے منتخب کردہ ٹیکس کٹوتی اور کھانے/رہائش کی کٹوتی کے بعد ٹیکس سے پہلے کا کل ہے۔",
      th: "นี่คือยอดรวมก่อนหักภาษี หลังจากหักภาษีที่คุณเลือกและค่าอาหาร/ที่พัก",
      ky: "Бул сиз тандаган салыктык чегерүү жана тамак-аш/турак жай чегерүүсү чыгарылгандан кийинки салыкка чейинки жалпы сумма.",
      km: "នេះគឺជាចំនួនសរុបមុនពេលបង់ពន្ធ បន្ទាប់ពីដកការកាត់ពន្ធដែលអ្នកបានជ្រើសរើស និងការកាត់អាហារ/កន្លែងស្នាក់នៅ។",
      id: "Ini adalah total sebelum pajak setelah dikurangi potongan pajak dan potongan makan/akomodasi yang Anda pilih.",
      si: "මෙය ඔබ තෝරාගත් බදු අඩු කිරීම සහ ආහාර/නවාතැන් අඩු කිරීමෙන් පසු බදු පෙර මුළු එකතුවයි.",
      bn: "এটি আপনার নির্বাচিত কর কর্তন এবং খাবার/আবাসন কর্তন বাদ দেওয়ার পরে কর-পূর্ব মোট।",
      my: "၎င်းသည် သင်ရွေးချယ်ထားသော အခွန်ဖြတ်တောက်မှုနှင့် အစားအသောက်/နေထိုင်စရိတ် ဖြတ်တောက်မှုတို့ကို နုတ်ပြီးနောက် အခွန်မဆောင်မီ စုစုပေါင်းဖြစ်သည်။",
      mn: "Энэ нь таны сонгосон татварын суутгал болон хоол/байрны суутгалыг хассаны дараах татварын өмнөх нийт дүн юм.",
      lo: "ນີ້ແມ່ນຍອດລວມກ່ອນຫັກພາສີ ຫຼັງຈາກຫັກພາສີທີ່ທ່ານເລືອກ ແລະ ຄ່າອາຫານ/ທີ່ພັກ.",
      tet:
          "Ida ne'e mak totál antes impostu depois hasai dedusaun impostu ne'ebé Ita hili no dedusaun hahán/akomodasaun.",
      ne: "यो तपाईंले रोजेको कर कटौती र खाना/आवास कटौती घटाएपछि कर अघिको कुल रकम हो।",
      zh: '这是税前总额减去您所选的税金扣除和食宿费扣除后的金额。',
      vi: 'Đây là tổng trước thuế trừ đi khoản khấu trừ thuế và tiền ăn ở mà bạn đã chọn.',
      uz: "Bu soliqdan oldingi jami miqdoridan siz tanlagan soliq chegirmasi va yotoqxona/ovqatlanish chegirmasi ayirilgan miqdor.",
    ),
  ),
};

/// 원본 HELP_DICT를 그대로 옮긴 도움말 사전. 최저임금처럼 값이 매년 바뀌는 항목은
/// 호출 시점에 다시 계산하도록 body를 함수로 둔다.
Map<String, HelpEntry> buildHelpDict(AppLanguage lang) {
  final mw = minWage();
  final dict = <String, HelpEntry>{
    for (final e in _entries.entries)
      e.key: HelpEntry(
        title: e.value.title.of(lang),
        body: (context) => _TextBody(e.value.body.of(lang)),
      ),
  };

  dict['minw'] = HelpEntry(
    title: switch (lang) {
      AppLanguage.ko => '$wageCalcYear년 최저임금 기준',
      AppLanguage.uz => "$wageCalcYear Minimal ish haqi",
      AppLanguage.en => '$wageCalcYear Minimum Wage',
      AppLanguage.tr => "$wageCalcYear Asgari Ücret",
      AppLanguage.tg => "Музди ҳадди ақал дар соли $wageCalcYear",
      AppLanguage.fil => "$wageCalcYear Minimum na Sahod",
      AppLanguage.ur => "$wageCalcYear کم از کم اجرت",
      AppLanguage.th => "ค่าแรงขั้นต่ำ $wageCalcYear",
      AppLanguage.ky => "$wageCalcYear Минималдуу эмгек акы",
      AppLanguage.km => "ប្រាក់ឈ្នួលអប្បបរមា $wageCalcYear",
      AppLanguage.id => "Upah Minimum $wageCalcYear",
      AppLanguage.si => "$wageCalcYear අවම වැටුප",
      AppLanguage.bn => "$wageCalcYear ন্যূনতম মজুরি",
      AppLanguage.my => "$wageCalcYear အနိမ့်ဆုံးလုပ်ခ",
      AppLanguage.mn => "$wageCalcYear оны хамгийн бага цалин",
      AppLanguage.lo => "ຄ່າແຮງງານຂັ້ນຕ່ຳ $wageCalcYear",
      AppLanguage.tet => "Saláriu Mínimu $wageCalcYear",
      AppLanguage.ne => "$wageCalcYear न्यूनतम ज्याला",
      AppLanguage.zh => '$wageCalcYear年最低工资标准',
      AppLanguage.vi => 'Mức lương tối thiểu năm $wageCalcYear',
    },
    body: (context) => _TextBody(switch (lang) {
      AppLanguage.ko =>
        '• 시간급: <b>${formatWon(mw.$1, lang)}</b><br>'
            '• 월급 환산(주 40시간·월 209시간 기준): <b>${formatWon(mw.$2, lang)}</b><br>'
            '• 연봉 환산(월급×12): 약 <b>${formatWon(mw.$2 * 12, lang)}</b><br>'
            '• 최저임금 미달 계약은 그 부분이 무효이며 차액 청구가 가능합니다.',
      AppLanguage.uz =>
        "• Soatlik ish haqi: <b>${formatWon(mw.$1, lang)}</b><br>• Oylik ekvivalenti (haftasiga 40 soat, oyiga 209 soat): <b>${formatWon(mw.$2, lang)}</b><br>• Yillik ekvivalenti (oylik × 12): taxminan <b>${formatWon(mw.$2 * 12, lang)}</b><br>• Minimal ish haqidan past boʻlgan shartnoma shu qismi uchun haqiqiy emas va siz farqni talab qilishingiz mumkin.",
      AppLanguage.en =>
        '• Hourly wage: <b>${formatWon(mw.$1, lang)}</b><br>'
            '• Monthly equivalent (40 hrs/week, 209 hrs/month): <b>${formatWon(mw.$2, lang)}</b><br>'
            '• Annual equivalent (monthly × 12): approx. <b>${formatWon(mw.$2 * 12, lang)}</b><br>'
            '• A contract below minimum wage is invalid for that portion, and you can claim the difference.',
      AppLanguage.tr =>
        "• Saatlik ücret: <b>${formatWon(mw.$1, lang)}</b><br>• Aylık karşılığı (haftada 40 saat, ayda 209 saat): <b>${formatWon(mw.$2, lang)}</b><br>• Yıllık karşılığı (aylık × 12): yaklaşık <b>${formatWon(mw.$2 * 12, lang)}</b><br>• Asgari ücretin altında bir sözleşme, o kısım için geçersizdir ve farkı talep edebilirsiniz.",
      AppLanguage.tg =>
        "• Музди соатбайъ: <b>${formatWon(mw.$1, lang)}</b><br>• Муодили моҳона (дар як ҳафта 40 соат, дар як моҳ 209 соат): <b>${formatWon(mw.$2, lang)}</b><br>• Муодили солона (моҳона × 12): тақрибан <b>${formatWon(mw.$2 * 12, lang)}</b><br>• Шартномае, ки аз музди ҳадди ақал камтар аст, барои он қисм беэътибор аст ва шумо метавонед фарқиятро талаб кунед.",
      AppLanguage.fil =>
        "• Oras-oras na sahod: <b>${formatWon(mw.$1, lang)}</b><br>• Katumbas na buwanan (40 oras bawat linggo, 209 oras bawat buwan): <b>${formatWon(mw.$2, lang)}</b><br>• Katumbas na taunan (buwanan × 12): humigit-kumulang <b>${formatWon(mw.$2 * 12, lang)}</b><br>• Ang isang kontrata na mas mababa sa minimum na sahod ay walang bisa para sa bahaging iyon, at maaari mong hingin ang pagkakaiba.",
      AppLanguage.ur =>
        "• فی گھنٹہ اجرت: <b>${formatWon(mw.$1, lang)}</b><br>• ماہانہ مساوی (ہفتے میں 40 گھنٹے، ماہانہ 209 گھنٹے): <b>${formatWon(mw.$2, lang)}</b><br>• سالانہ مساوی (ماہانہ × 12): تقریباً <b>${formatWon(mw.$2 * 12, lang)}</b><br>• کم از کم اجرت سے کم کا معاہدہ اس حصے کے لیے باطل ہے اور آپ فرق کا دعویٰ کر سکتے ہیں۔",
      AppLanguage.th =>
        "• ค่าจ้างรายชั่วโมง: <b>${formatWon(mw.$1, lang)}</b><br>• เทียบเท่ารายเดือน (ทำงาน 40 ชั่วโมงต่อสัปดาห์, 209 ชั่วโมงต่อเดือน): <b>${formatWon(mw.$2, lang)}</b><br>• เทียบเท่ารายปี (รายเดือน × 12): ประมาณ <b>${formatWon(mw.$2 * 12, lang)}</b><br>• สัญญาที่ต่ำกว่าค่าแรงขั้นต่ำจะถือเป็นโมฆะในส่วนนั้น และคุณสามารถเรียกร้องส่วนต่างได้",
      AppLanguage.ky =>
        "• Сааттык эмгек акы: <b>${formatWon(mw.$1, lang)}</b><br>• Айлык эквиваленти (жумасына 40 саат, айына 209 саат): <b>${formatWon(mw.$2, lang)}</b><br>• Жылдык эквиваленти (айлык × 12): болжол менен <b>${formatWon(mw.$2 * 12, lang)}</b><br>• Минималдуу эмгек акыдан төмөн келишим, ошол бөлүгү үчүн жараксыз жана сиз айырманы талап кыла аласыз.",
      AppLanguage.km =>
        "• ប្រាក់ឈ្នួលក្នុងមួយម៉ោង៖ <b>${formatWon(mw.$1, lang)}</b><br>• ប្រាក់ឈ្នួលប្រចាំខែ (40 ម៉ោងក្នុងមួយសប្តាហ៍, 209 ម៉ោងក្នុងមួយខែ)៖ <b>${formatWon(mw.$2, lang)}</b><br>• ប្រាក់ឈ្នួលប្រចាំឆ្នាំ (ប្រចាំខែ × 12)៖ ប្រហែល <b>${formatWon(mw.$2 * 12, lang)}</b><br>• កិច្ចសន្យាដែលទាបជាងប្រាក់ឈ្នួលអប្បបរមាគឺមិនត្រឹមត្រូវសម្រាប់ផ្នែកនោះ ហើយអ្នកអាចទាមទារភាពខុសគ្នាបាន។",
      AppLanguage.id =>
        "• Upah per jam: <b>${formatWon(mw.$1, lang)}</b><br>• Setara bulanan (40 jam/minggu, 209 jam/bulan): <b>${formatWon(mw.$2, lang)}</b><br>• Setara tahunan (bulanan × 12): sekitar <b>${formatWon(mw.$2 * 12, lang)}</b><br>• Kontrak di bawah upah minimum tidak berlaku untuk bagian tersebut, dan Anda dapat menuntut selisihnya.",
      AppLanguage.si =>
        "• පැයකට වැටුප: <b>${formatWon(mw.$1, lang)}</b><br>• මාසික සමානතාව (සතියකට පැය 40, මසකට පැය 209): <b>${formatWon(mw.$2, lang)}</b><br>• වාර්ෂික සමානතාව (මාසික × 12): දළ වශයෙන් <b>${formatWon(mw.$2 * 12, lang)}</b><br>• අවම වැටුපට වඩා අඩු කොන්ත්‍රාත්තුවක් එම කොටස සඳහා අවලංගු වන අතර, ඔබට වෙනස ඉල්ලා සිටිය හැක.",
      AppLanguage.bn =>
        "• প্রতি ঘণ্টার মজুরি: <b>${formatWon(mw.$1, lang)}</b><br>• মাসিক সমতুল্য (সপ্তাহে 40 ঘন্টা, মাসে 209 ঘন্টা): <b>${formatWon(mw.$2, lang)}</b><br>• বার্ষিক সমতুল্য (মাসিক × 12): প্রায় <b>${formatWon(mw.$2 * 12, lang)}</b><br>• ন্যূনতম মজুরির নিচে একটি চুক্তি সেই অংশের জন্য অবৈধ এবং আপনি পার্থক্য দাবি করতে পারেন।",
      AppLanguage.my =>
        "• နာရီအလိုက်လုပ်ခ: <b>${formatWon(mw.$1, lang)}</b><br>• လစဉ်နှင့်ညီမျှသော (တစ်ပတ်လျှင် 40 နာရီ၊ တစ်လလျှင် 209 နာရီ): <b>${formatWon(mw.$2, lang)}</b><br>• နှစ်စဉ်နှင့်ညီမျှသော (လစဉ် × 12): ခန့်မှန်းခြေ <b>${formatWon(mw.$2 * 12, lang)}</b><br>• အနိမ့်ဆုံးလုပ်ခအောက် စာချုပ်သည် ထိုအပိုင်းအတွက် တရားမဝင်ဘဲ သင်သည် ကွာခြားချက်ကို တောင်းဆိုနိုင်ပါသည်။",
      AppLanguage.mn =>
        "• Цагийн хөлс: <b>${formatWon(mw.$1, lang)}</b><br>• Сарын эквивалент (долоо хоногт 40 цаг, сард 209 цаг): <b>${formatWon(mw.$2, lang)}</b><br>• Жилийн эквивалент (сарын × 12): ойролцоогоор <b>${formatWon(mw.$2 * 12, lang)}</b><br>• Хамгийн бага цалингаас доогуур гэрээ нь тухайн хэсэгт хүчингүй бөгөөд та зөрүүг нэхэмжлэх боломжтой.",
      AppLanguage.lo =>
        "• ຄ່າຈ້າງລາຍຊົ່ວໂມງ: <b>${formatWon(mw.$1, lang)}</b><br>• ທຽບເທົ່າລາຍເດືອນ (40 ຊົ່ວໂມງຕໍ່ອາທິດ, 209 ຊົ່ວໂມງຕໍ່ເດືອນ): <b>${formatWon(mw.$2, lang)}</b><br>• ທຽບເທົ່າລາຍປີ (ລາຍເດືອນ × 12): ປະມານ <b>${formatWon(mw.$2 * 12, lang)}</b><br>• ສັນຍາທີ່ຕໍ່າກວ່າຄ່າແຮງງານຂັ້ນຕ່ຳແມ່ນບໍ່ຖືກຕ້ອງສຳລັບພາກສ່ວນນັ້ນ ແລະ ທ່ານສາມາດຮຽກຮ້ອງສ່ວນຕ່າງໄດ້.",
      AppLanguage.tet =>
        "• Saláriu kada oras: <b>${formatWon(mw.$1, lang)}</b><br>• Ekuivalente fulan nian (40 oras kada semana, 209 oras kada fulan): <b>${formatWon(mw.$2, lang)}</b><br>• Ekuivalente anuál (fulan nian × 12): aprosimadamente <b>${formatWon(mw.$2 * 12, lang)}</b><br>• Kontratu ida ne'ebé menus husi saláriu mínimu la válidu ba parte ne'e, no Ita bele husu diferensa.",
      AppLanguage.ne =>
        "• प्रति घण्टा ज्याला: <b>${formatWon(mw.$1, lang)}</b><br>• मासिक बराबर (प्रति हप्ता 40 घण्टा, प्रति महिना 209 घण्टा): <b>${formatWon(mw.$2, lang)}</b><br>• वार्षिक बराबर (मासिक × 12): लगभग <b>${formatWon(mw.$2 * 12, lang)}</b><br>• न्यूनतम ज्याला भन्दा कमको सम्झौता त्यस भागको लागि अमान्य हुन्छ, र तपाईंले फरक रकम दाबी गर्न सक्नुहुन्छ।",
      AppLanguage.zh =>
        '• 时薪：<b>${formatWon(mw.$1, lang)}</b><br>'
            '• 月薪换算（每周40小时·每月209小时）：<b>${formatWon(mw.$2, lang)}</b><br>'
            '• 年薪换算（月薪×12）：约 <b>${formatWon(mw.$2 * 12, lang)}</b><br>'
            '• 低于最低工资的合同条款无效，可以要求补足差额。',
      AppLanguage.vi =>
        '• Lương giờ: <b>${formatWon(mw.$1, lang)}</b><br>'
            '• Quy đổi lương tháng (40 giờ/tuần, 209 giờ/tháng): <b>${formatWon(mw.$2, lang)}</b><br>'
            '• Quy đổi lương năm (lương tháng×12): khoảng <b>${formatWon(mw.$2 * 12, lang)}</b><br>'
            '• Hợp đồng dưới mức lương tối thiểu thì phần đó vô hiệu, bạn có thể yêu cầu khoản chênh lệch.',
    }),
  );

  dict['tax_info'] = HelpEntry(
    title: switch (lang) {
      AppLanguage.ko => '근로자의 세금 적용 방식',
      AppLanguage.uz => "Ishchilarga soliqlar qanday qoʻllaniladi?",
      AppLanguage.en => 'How taxes apply to workers',
      AppLanguage.tr => "Vergilendirme çalışanlara nasıl uygulanır",
      AppLanguage.tg => "Андозбандӣ ба кормандон чӣ гуна татбиқ мешавад?",
      AppLanguage.fil => "Paano inilalapat ang pagbubuwis sa mga empleyado?",
      AppLanguage.ur => "ملازمین پر ٹیکس کیسے لاگو ہوتا ہے؟",
      AppLanguage.th => "การเก็บภาษีมีผลกับพนักงานอย่างไร",
      AppLanguage.ky => "Салык салуу кызматкерлерге кандайча колдонулат?",
      AppLanguage.km => "តើការបង់ពន្ធត្រូវបានអនុវត្តចំពោះនិយោជិតដោយរបៀបណា?",
      AppLanguage.id => "Bagaimana perpajakan diterapkan pada karyawan?",
      AppLanguage.si => "බදුකරණය සේවකයින්ට අදාළ වන්නේ කෙසේද?",
      AppLanguage.bn => "কর্মচারীদের উপর কর কীভাবে প্রযোজ্য হয়?",
      AppLanguage.my =>
        "အခွန်ကောက်ခံမှုကို ဝန်ထမ်းများအပေါ် မည်သို့အသုံးပြုသနည်း",
      AppLanguage.mn => "Татвар ажилчдад хэрхэн хэрэгждэг вэ?",
      AppLanguage.lo => "ການເກັບພາສີຖືກນຳໃຊ້ກັບພະນັກງານແນວໃດ",
      AppLanguage.tet => "Oinsá mak impostu aplika ba empregadu sira?",
      AppLanguage.ne => "कर्मचारीहरूमा कर कसरी लागू गरिन्छ?",
      AppLanguage.zh => '劳动者的税务适用方式',
      AppLanguage.vi => 'Cách áp dụng thuế cho người lao động',
    },
    body: (context) => _taxInfoBody(context, lang),
  );

  return dict;
}

/// 고정 문자열을 RichNote로 렌더링하는 얇은 래퍼 — HelpEntry.body 시그니처(위젯 빌더)에 맞추기 위함.
class _TextBody extends StatelessWidget {
  const _TextBody(this.raw);
  final String raw;

  @override
  Widget build(BuildContext context) => RichNote(raw);
}
