import 'package:flutter/material.dart';
import '../../../common/widgets/rich_note.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';
import '../../worklog/screens/wage_navigator_screen.dart';
import '../models/wage_diagnosis.dart';
import '../widgets/wage_form_widgets.dart';
import '../widgets/wage_help.dart';
import '../widgets/wage_result_card.dart';

/// 정밀 임금·체불 계산기 (5단계 위저드 + 결과). 프론트엔드_계산기_최종.html(v6)을
/// 그대로 옮겼다 — STEP1(확인기간+임금+비자+사업장) → STEP2(근무시간) →
/// STEP3(재직기간) → STEP4(세금·숙식비) → STEP5(실입금액) → 결과.
///
/// v6는 "이 단독 파일엔 근무기록장·OCR 모듈이 없다"는 이유로 두 불러오기 버튼과
/// 결과 화면의 진정서·기관찾기 버튼을 데모/비활성으로 남겨둔다. 이 앱은 그 모듈이
/// 실제로 있으므로: 근무기록장 불러오기는 데모 값 채우기로 동작시키고, 결과 화면의
/// 진정서 자동매핑·기관찾기 버튼은 실제 네비게이션으로 살려둔다(WageResultCard 참고).
/// OCR(임금명세서 자동 인식)만 실제 이미지 인식 파이프라인이 없어 준비 중 안내로 남긴다.
class WageCalculatorScreen extends StatefulWidget {
  const WageCalculatorScreen({super.key, this.onUseResult});

  /// 임금체불 내비게이터 2단계에서 이 화면을 열었을 때만 전달된다. 있으면
  /// 결과 화면의 "진정서에 내 기록 자동 매핑하기" 버튼이 새 내비게이터를
  /// 여는 대신, 계산값을 콜백으로 돌려주고 이 화면만 닫아 원래 내비게이터
  /// 단계로 되돌아간다(html_files 원본의 WAGE.fromNav 분기와 동일한 동작).
  final ValueChanged<WageCalcInput>? onUseResult;

  @override
  State<WageCalculatorScreen> createState() => _WageCalculatorScreenState();
}

class _S {
  const _S(
    this.ko,
    this.en,
    this.zh,
    this.vi,
    this.uz,
    this.tr,
    this.ne,
    this.tet,
    this.lo,
    this.mn,
    this.my,
    this.bn,
    this.si,
    this.id,
    this.km,
    this.ky,
    this.th,
    this.ur,
    this.fil,
    this.tg,
  );
  final String ko;
  final String en;
  final String zh;
  final String vi;
  final String uz;
  final String tr;
  final String ne;
  final String tet;
  final String lo;
  final String mn;
  final String my;
  final String bn;
  final String si;
  final String id;
  final String km;
  final String ky;
  final String th;
  final String ur;
  final String fil;
  final String tg;

  L10nText get t => L10nText(
    ko: ko,
    en: en,
    zh: zh,
    vi: vi,
    uz: uz,
    tr: tr,
    ne: ne,
    tet: tet,
    lo: lo,
    mn: mn,
    my: my,
    bn: bn,
    si: si,
    id: id,
    km: km,
    ky: ky,
    th: th,
    ur: ur,
    fil: fil,
    tg: tg,
  );
  String of(AppLanguage lang) => t.of(lang);
}

const _appBarTitle = _S(
  '임금계산기',
  'Wage Calculator',
  '工资计算器',
  'Máy tính lương',
  "Ish haqi kalkulyatori",
  "Ücret Hesaplayıcı",
  "तलब क्यालकुलेटर",
  "Kalkuladór Saláriu",
  "ເຄື່ອງຄິດໄລ່ຄ່າຈ້າງ",
  "Цалингийн тооцоолуур",
  "လုပ်ခတွက်ချက်စက်",
  "বেতন ক্যালকুলেটর",
  "වැටුප් කැල්කියුලේටරය",
  "Kalkulator Upah",
  "ម៉ាស៊ីនគិតប្រាក់ឈ្នួល",
  "Эмгек акы калькулятору",
  "เครื่องคำนวณค่าจ้าง",
  "اجرت کیلکولیٹر",
  "Wage Calculator",
  "Ҳисобкунаки музди меҳнат",
);
const _importWorklog = _S(
  '📁 근무기록장 불러오기',
  '📁 Import work log',
  '📁 导入工作日志',
  '📁 Nhập nhật ký làm việc',
  "📁 Ish jurnalini import qilish",
  "📁 Çalışma günlüğü aktar",
  "📁 कार्य लग अपलोड गर्नुहोस्",
  "📁 Importa rejistu serbisu",
  "📁 ອັບໂຫຼດບັນທຶກການເຮັດວຽກ",
  "📁 Ажлын бүртгэл оруулах",
  "📁 အလုပ်မှတ်တမ်း တင်သွင်းရန်",
  "📁 কাজের লগ আপলোড করুন",
  "📁 වැඩ වාර්තාව උඩුගත කරන්න",
  "📁 Unggah log kerja",
  "📁 ផ្ទុកកំណត់ហេតុការងារ",
  "📁 Иш журналын жүктөө",
  "📁 อัปโหลดบันทึกการทำงาน",
  "📁 کام کا لاگ اپ لوڈ کریں",
  "📁 Mag-upload ng log ng trabaho",
  "📁 Журнали корро боргузорӣ кунед",
);
const _importPayslip = _S(
  '📄 임금명세서 불러오기',
  '📄 Import payslip',
  '📄 导入工资单',
  '📄 Nhập phiếu lương',
  "📄 Ish haqi varagʻini import qilish",
  "📄 Maaş bordrosu aktar",
  "📄 तलब पर्ची अपलोड गर्नुहोस्",
  "📄 Importa folla saláriu",
  "📄 ອັບໂຫຼດໃບແຈ້ງເງິນເດືອນ",
  "📄 Цалингийн хуудас оруулах",
  "📄 လစာစာရင်း တင်သွင်းရန်",
  "📄 বেতন স্লিপ আপলোড করুন",
  "📄 වැටුප් පත්‍රිකාව උඩුගත කරන්න",
  "📄 Unggah slip gaji",
  "📄 ផ្ទុកប័ណ្ណបើកប្រាក់បៀវត្សរ៍",
  "📄 Эмгек акы баракчасын жүктөө",
  "📄 อัปโหลดสลิปเงินเดือน",
  "📄 پے سلپ اپ لوڈ کریں",
  "📄 Mag-upload ng payslip",
  "📄 Варақаи музди меҳнатро боргузорӣ кунед",
);
const _worklogSnack = _S(
  '근무기록장 연동은 준비 중이라 예시 데이터로 채워드렸어요.',
  'Work log integration is coming soon, so we filled in sample data for you.',
  '工作日志联动功能正在准备中，已为您填入示例数据。',
  'Tính năng liên kết nhật ký làm việc đang được chuẩn bị nên chúng tôi đã điền dữ liệu mẫu cho bạn.',
  "Ish jurnalini integratsiya qilish tez orada ishga tushadi, shuning uchun biz siz uchun namunaviy maʼlumotlarni toʻldirdik.",
  "Çalışma günlüğü entegrasyonu yakında geliyor, bu yüzden sizin için örnek verileri doldurduk.",
  "कार्य लग एकीकरण चाँडै आउँदैछ, त्यसैले हामीले तपाईंको लागि नमूना डेटा भर्यौं।",
  "Integrasaun rejistu serbisu sei mai lalais, tanba ne'e ami preenche ona dadus ezemplu ba ita.",
  "ການເຊື່ອມໂຍງບັນທຶກການເຮັດວຽກຈະມາໃນໄວໆນີ້, ດັ່ງນັ້ນພວກເຮົາຈຶ່ງໄດ້ປ້ອນຂໍ້ມູນຕົວຢ່າງໃຫ້ທ່ານ.",
  "Ажлын бүртгэлийн нэгдсэн систем удахгүй нэвтэрнэ, тиймээс бид танд зориулж жишээ өгөгдлийг бөглөсөн болно.",
  "အလုပ်မှတ်တမ်း ပေါင်းစည်းမှု မကြာမီ ရောက်ရှိလာတော့မည်ဖြစ်သောကြောင့် သင့်အတွက် နမူနာဒေတာများကို ဖြည့်သွင်းထားပါသည်။",
  "কাজের লগ ইন্টিগ্রেশন শীঘ্রই আসছে, তাই আমরা আপনার জন্য নমুনা ডেটা পূরণ করেছি।",
  "වැඩ වාර්තා ඒකාබද්ධ කිරීම ඉක්මනින් පැමිණේ, එබැවින් අපි ඔබ වෙනුවෙන් නියැදි දත්ත පුරවා ඇත.",
  "Integrasi log kerja akan segera hadir, jadi kami telah mengisi data contoh untuk Anda.",
  "ការបញ្ចូលកំណត់ហេតុការងារនឹងមកដល់ឆាប់ៗនេះ ដូច្នេះយើងបានបំពេញទិន្នន័យគំរូសម្រាប់អ្នក។",
  "Иш журналын интеграциялоо жакында жеткиликтүү болот, ошондуктан биз сиз үчүн үлгү маалыматтарды толтурдук.",
  "การรวมบันทึกการทำงานจะมาเร็วๆ นี้ ดังนั้นเราจึงกรอกข้อมูลตัวอย่างให้คุณแล้ว",
  "کام کے لاگ کا انضمام جلد آ رہا ہے، اس لیے ہم نے آپ کے لیے نمونہ ڈیٹا پُر کر دیا ہے۔",
  "Malapit na ang pagsasama ng log ng trabaho, kaya pinunan namin ang sample data para sa iyo.",
  "Интегратсияи журнали кор ба зудӣ меояд, аз ин рӯ мо барои шумо маълумоти намунавӣ пур кардем.",
);
const _payslipSnack = _S(
  '임금명세서 자동 인식(OCR)은 준비 중이에요. 값을 직접 입력해 주세요.',
  'Automatic payslip recognition (OCR) is coming soon. Please enter the values manually.',
  '工资单自动识别（OCR）功能正在准备中。请直接输入数值。',
  'Tính năng nhận dạng phiếu lương tự động (OCR) đang được chuẩn bị. Vui lòng nhập giá trị trực tiếp.',
  "Ish haqi varagʻini avtomatik tanib olish (OCR) tez orada ishga tushadi. Iltimos, qiymatlarni qoʻlda kiriting.",
  "Otomatik maaş bordrosu tanıma (OCR) yakında geliyor. Lütfen değerleri manuel olarak girin.",
  "स्वचालित तलब पर्ची पहिचान (OCR) चाँडै आउँदैछ। कृपया मानहरू म्यानुअल रूपमा प्रविष्ट गर्नुहोस्।",
  "Rekonhesimentu automátiku folla saláriu (OCR) sei mai lalais. Favor hatama valór sira manualmente.",
  "ການຮັບຮູ້ໃບແຈ້ງເງິນເດືອນອັດຕະໂນມັດ (OCR) ຈະມາໃນໄວໆນີ້. ກະລຸນາປ້ອນຄ່າຕ່າງໆດ້ວຍຕົນເອງ.",
  "Цалингийн хуудасны автомат таних (OCR) удахгүй нэвтэрнэ. Утгуудыг гараар оруулна уу.",
  "အလိုအလျောက် လစာစာရင်း မှတ်မိခြင်း (OCR) မကြာမီ ရောက်ရှိလာတော့မည်။ ကျေးဇူးပြု၍ တန်ဖိုးများကို ကိုယ်တိုင်ထည့်သွင်းပါ။",
  "স্বয়ংক্রিয় বেতন স্লিপ স্বীকৃতি (OCR) শীঘ্রই আসছে। অনুগ্রহ করে ম্যানুয়ালি মানগুলি প্রবেশ করুন।",
  "ස්වයංක්‍රීය වැටුප් පත්‍රිකා හඳුනාගැනීම (OCR) ඉක්මනින් පැමිණේ. කරුණාකර අගයන් අතින් ඇතුළත් කරන්න.",
  "Pengenalan slip gaji otomatis (OCR) akan segera hadir. Harap masukkan nilai secara manual.",
  "ការស្គាល់ប័ណ្ណបើកប្រាក់បៀវត្សរ៍ដោយស្វ័យប្រវត្តិ (OCR) នឹងមកដល់ឆាប់ៗនេះ។ សូមបញ្ចូលតម្លៃដោយដៃ។",
  "Эмгек акы баракчасын автоматтык таануу (OCR) жакында жеткиликтүү болот. Сураныч, маанилерди кол менен киргизиңиз.",
  "การจดจำสลิปเงินเดือนอัตโนมัติ (OCR) จะมาเร็วๆ นี้ โปรดป้อนค่าด้วยตนเอง",
  "خودکار پے سلپ کی شناخت (OCR) جلد آ رہی ہے۔ براہ کرم اقدار دستی طور پر درج کریں۔",
  "Malapit na ang awtomatikong pagkilala ng payslip (OCR). Mangyaring ilagay nang manu-mano ang mga halaga.",
  "Шинохти автоматии варақаи музди меҳнат (OCR) ба зудӣ меояд. Лутфан арзишҳоро дастӣ ворид кунед.",
);
const _findOrgsSnack = _S(
  '관할 지방고용노동청과 외국인노동자지원센터 위치·연락처를 보여드립니다. (준비 중)',
  'We will show the location and contact info of your local labor office and migrant worker support center. (Coming soon)',
  '为您显示管辖地方劳动厅和外国劳动者支援中心的位置及联系方式。（准备中）',
  'Chúng tôi sẽ hiển thị vị trí và thông tin liên hệ của Sở Lao động địa phương và Trung tâm hỗ trợ lao động nước ngoài. (Đang chuẩn bị)',
  "Biz sizning mahalliy mehnat idorangiz va migrant ishchilarni qoʻllab-quvvatlash markazining joylashuvi va aloqa maʼlumotlarini koʻrsatamiz. (Tez orada)",
  "Yerel çalışma ofisinizin ve göçmen işçi destek merkezinizin konumunu ve iletişim bilgilerini göstereceğiz. (Yakında)",
  "हामी तपाईंको स्थानीय श्रम कार्यालय र आप्रवासी कामदार सहायता केन्द्रको स्थान र सम्पर्क जानकारी देखाउनेछौं। (चाँडै आउँदैछ)",
  "Ami sei hatudu fatin no informasaun kontaktu ba Ita-nia eskritóriu serbisu lokál no sentru apoiu traballadór migrante. (Lakleur)",
  "ພວກເຮົາຈະສະແດງສະຖານທີ່ ແລະ ຂໍ້ມູນຕິດຕໍ່ຂອງຫ້ອງການແຮງງານທ້ອງຖິ່ນຂອງທ່ານ ແລະ ສູນຊ່ວຍເຫຼືອແຮງງານເຄື່ອນຍ້າຍ. (ຈະມາໃນໄວໆນີ້)",
  "Таны орон нутгийн хөдөлмөрийн газар болон цагаач ажилчдыг дэмжих төвийн байршил, холбоо барих мэдээллийг бид харуулах болно. (Удахгүй)",
  "သင်၏ဒေသတွင်း အလုပ်သမားရုံးနှင့် ရွှေ့ပြောင်းလုပ်သား ပံ့ပိုးရေးစင်တာ၏ တည်နေရာနှင့် ဆက်သွယ်ရန်အချက်အလက်များကို ကျွန်ုပ်တို့ ပြသပါမည်။ (မကြာမီလာမည်)",
  "আমরা আপনার স্থানীয় শ্রম অফিস এবং অভিবাসী শ্রমিক সহায়তা কেন্দ্রের অবস্থান এবং যোগাযোগের তথ্য দেখাবো। (শীঘ্রই আসছে)",
  "අපි ඔබේ ප්‍රාදේශීය කම්කරු කාර්යාලයේ සහ සංක්‍රමණික සේවක ආධාරක මධ්‍යස්ථානයේ ස්ථානය සහ සම්බන්ධතා තොරතුරු පෙන්වන්නෙමු. (ළඟදීම)",
  "Kami akan menampilkan lokasi dan informasi kontak kantor tenaga kerja lokal Anda dan pusat dukungan pekerja migran. (Segera hadir)",
  "យើងនឹងបង្ហាញទីតាំង និងព័ត៌មានទំនាក់ទំនងរបស់ការិយាល័យការងារក្នុងស្រុក និងមជ្ឈមណ្ឌលគាំទ្រពលករចំណាកស្រុករបស់អ្នក។ (ឆាប់ៗនេះ)",
  "Жергиликтүү эмгек кеңсесиңиздин жана мигрант жумушчуларды колдоо борборуңуздун жайгашкан жерин жана байланыш маалыматын көрсөтөбүз. (Жакында)",
  "เราจะแสดงที่ตั้งและข้อมูลติดต่อของสำนักงานแรงงานท้องถิ่นและศูนย์สนับสนุนแรงงานต่างชาติของคุณ (เร็วๆ นี้)",
  "ہم آپ کے مقامی لیبر آفس اور تارکین وطن کارکنوں کے امدادی مرکز کا مقام اور رابطہ کی معلومات دکھائیں گے۔ (جلد آرہا ہے)",
  "Ipapakita namin ang lokasyon at impormasyon sa pakikipag-ugnayan ng inyong lokal na tanggapan ng paggawa at sentro ng suporta para sa mga migranteng manggagawa. (Malapit na)",
  "Мо макон ва маълумоти тамоси идораи маҳаллии меҳнатии шумо ва маркази дастгирии коргарони муҳоҷирро нишон медиҳем. (Ба қарибӣ)",
);
const _calcLabel = _S(
  '계산하기',
  'Calculate',
  '计算',
  'Tính toán',
  "Hisoblash",
  "Hesapla",
  "गणना गर्नुहोस्",
  "Kalkula",
  "ຄິດໄລ່",
  "Тооцоолох",
  "တွက်ချက်ရန်",
  "হিসাব করুন",
  "ගණනය කරන්න",
  "Hitung",
  "គណនា",
  "Эсептөө",
  "คำนวณ",
  "حساب لگائیں",
  "Kalkulahin",
  "Ҳисоб кунед",
);
const _nextLabel = _S(
  '다음',
  'Next',
  '下一步',
  'Tiếp theo',
  "Keyingi",
  "İleri",
  "अगाडि बढ्नुहोस्",
  "Tuir mai",
  "ຕໍ່ໄປ",
  "Дараах",
  "နောက်တစ်ခု",
  "পরবর্তী",
  "ඊළඟ",
  "Lanjut",
  "បន្ទាប់",
  "Кийинки",
  "ถัดไป",
  "اگلا",
  "Susunod",
  "Баъдӣ",
);
const _prevLabel = _S(
  '이전',
  'Back',
  '上一步',
  'Quay lại',
  "Orqaga",
  "Geri",
  "पछाडि",
  "Fila",
  "ກັບຄືນ",
  "Буцах",
  "နောက်သို့",
  "পেছনে",
  "ආපසු",
  "Kembali",
  "ថយក្រោយ",
  "Артка",
  "ย้อนกลับ",
  "واپس",
  "Bumalik",
  "Бозгашт",
);
const _editValuesLabel = _S(
  '✏️ 입력값 수정하기',
  '✏️ Edit values',
  '✏️ 修改输入值',
  '✏️ Chỉnh sửa giá trị',
  "✏️ Qiymatlarni tahrirlash",
  "✏️ Değerleri düzenle",
  "✏️ मानहरू सम्पादन गर्नुहोस्",
  "✏️ Edita valór sira",
  "✏️ ແກ້ໄຂຄ່າ",
  "✏️ Утгыг засах",
  "✏️ တန်ဖိုးများ တည်းဖြတ်ရန်",
  "✏️ মান সম্পাদনা করুন",
  "✏️ අගයන් සංස්කරණය කරන්න",
  "✏️ Edit nilai",
  "✏️ កែសម្រួលតម្លៃ",
  "✏️ Маанилерди түзөтүү",
  "✏️ แก้ไขค่า",
  "✏️ اقدار میں ترمیم کریں",
  "✏️ I-edit ang mga halaga",
  "✏️ Қиматҳоро таҳрир кунед",
);
const _resultBadge = _S(
  'RESULT',
  'RESULT',
  '结果',
  'KẾT QUẢ',
  "NATIJA",
  "SONUÇ",
  "नतिजा",
  "REZULTADU",
  "ຜົນໄດ້ຮັບ",
  "ҮР ДҮН",
  "ရလဒ်",
  "ফলাফল",
  "ප්‍රතිඵලය",
  "HASIL",
  "លទ្ធផល",
  "ЖЫЙЫНТЫК",
  "ผลลัพธ์",
  "نتیجہ",
  "RESULTA",
  "НАТИҶА",
);
const _stepWord = _S(
  'STEP',
  'STEP',
  '步骤',
  'BƯỚC',
  "BOSQICH",
  "ADIM",
  "चरण",
  "PASU",
  "ຂັ້ນຕອນ",
  "АЛХАМ",
  "အဆင့်",
  "ধাপ",
  "පියවර",
  "LANGKAH",
  "ជំហាន",
  "КАДАМ",
  "ขั้นตอน",
  "مرحلہ",
  "HAKBANG",
  "ҚАДАМ",
);

const _step1Title1 = _S(
  '확인하실 기간을 먼저 골라주세요',
  'First, choose the period you want to check',
  '请先选择您要确认的期间',
  'Trước tiên, hãy chọn khoảng thời gian bạn muốn kiểm tra',
  "Avval, tekshirmoqchi boʻlgan davrni tanlang",
  "Öncelikle, kontrol etmek istediğiniz dönemi seçin",
  "सर्वप्रथम, तपाईंले जाँच गर्न चाहनुभएको अवधि चयन गर्नुहोस्",
  "Primeiru, hili períodu ne'ebé Ita hakarak verifika",
  "ກ່ອນອື່ນໝົດ, ເລືອກໄລຍະເວລາທີ່ທ່ານຕ້ອງການກວດສອບ",
  "Эхлээд, шалгахыг хүссэн хугацаагаа сонгоно уу",
  "ပထမဦးစွာ၊ သင်စစ်ဆေးလိုသည့် ကာလကို ရွေးချယ်ပါ",
  "প্রথমে, আপনি যে সময়কালটি পরীক্ষা করতে চান তা নির্বাচন করুন",
  "පළමුව, ඔබට පරීක්ෂා කිරීමට අවශ්‍ය කාල සීමාව තෝරන්න",
  "Pertama, pilih periode yang ingin Anda periksa",
  "ជាដំបូង សូមជ្រើសរើសរយៈពេលដែលអ្នកចង់ពិនិត្យ",
  "Биринчиден, текшергиңиз келген мезгилди тандаңыз",
  "อันดับแรก โปรดเลือกช่วงเวลาที่คุณต้องการตรวจสอบ",
  "سب سے پہلے، وہ مدت منتخب کریں جس کی آپ جانچ کرنا چاہتے ہیں",
  "Una, piliin ang panahon na nais ninyong suriin",
  "Аввалан, давраеро интихоб кунед, ки мехоҳед тафтиш кунед",
);
const _step1Lead1 = _S(
  '이번 달 급여만 확인하실지, 여러 달 동안 밀린 급여를 확인하실지 고르세요.',
  'Choose whether to check only this month\'s pay or unpaid wages over several months.',
  '请选择是仅确认本月工资，还是确认多个月的拖欠工资。',
  'Hãy chọn xem bạn muốn kiểm tra lương tháng này hay lương chưa trả trong nhiều tháng.',
  "Faqat shu oydagi ish haqini yoki bir necha oydagi toʻlanmagan ish haqini tekshirishni tanlang.",
  "Sadece bu ayın maaşını mı yoksa birkaç aylık ödenmemiş ücretleri mi kontrol etmek istediğinizi seçin.",
  "तपाईं यस महिनाको तलब मात्र जाँच गर्न चाहनुहुन्छ वा धेरै महिनाको नतिरेको ज्याला जाँच गर्न चाहनुहुन्छ, चयन गर्नुहोस्।",
  "Hili se Ita hakarak verifika saláriu fulan ida-ne'e de'it ka saláriu ne'ebé seidauk selu ba fulan balun.",
  "ເລືອກວ່າທ່ານຕ້ອງການກວດສອບເງິນເດືອນຂອງເດືອນນີ້ເທົ່ານັ້ນ ຫຼື ຄ່າຈ້າງທີ່ຄ້າງຈ່າຍຫຼາຍເດືອນ.",
  "Та зөвхөн энэ сарын цалинг эсвэл хэд хэдэн сарын хугацаанд төлөгдөөгүй цалинг шалгахыг хүсэж байгаа эсэхээ сонгоно уу.",
  "သင်သည် ဤလ၏လစာကိုသာ စစ်ဆေးလိုပါသလား သို့မဟုတ် လပေါင်းများစွာ ပေးချေရန်ကျန်ရှိနေသေးသော လစာများကို စစ်ဆေးလိုပါသလား ရွေးချယ်ပါ။",
  "আপনি শুধুমাত্র এই মাসের বেতন বা কয়েক মাসের বকেয়া বেতন পরীক্ষা করতে চান কিনা তা নির্বাচন করুন।",
  "ඔබට මෙම මාසයේ වැටුප හෝ මාස කිහිපයක නොගෙවූ වැටුප් පරීක්ෂා කිරීමට අවශ්‍යද යන්න තෝරන්න.",
  "Pilih apakah Anda ingin memeriksa gaji bulan ini saja atau upah yang belum dibayar selama beberapa bulan.",
  "សូមជ្រើសរើសថាតើអ្នកចង់ពិនិត្យប្រាក់ខែសម្រាប់តែខែនេះ ឬប្រាក់ឈ្នួលដែលមិនទាន់បានបង់សម្រាប់រយៈពេលប៉ុន្មានខែ។",
  "Ушул айдын гана айлыгын же бир нече айлык төлөнбөгөн эмгек акыны текшергиңиз келеби, тандаңыз.",
  "โปรดเลือกที่คุณต้องการตรวจสอบเงินเดือนของเดือนนี้เท่านั้น หรือค่าจ้างที่ค้างชำระหลายเดือน",
  "منتخب کریں کہ کیا آپ صرف اس مہینے کی تنخواہ یا کئی مہینوں کی غیر ادا شدہ اجرتوں کی جانچ کرنا چاہتے ہیں۔",
  "Piliin kung nais ninyong suriin ang sahod para sa buwang ito lamang o ang hindi nabayarang sahod para sa ilang buwan.",
  "Интихоб кунед, ки оё шумо мехоҳед танҳо музди меҳнати ин моҳро ё музди меҳнати чанд моҳи пардохтнашударо тафтиш кунед.",
);
const _segMonthOnly = _S(
  '이번달만',
  'This month only',
  '仅本月',
  'Chỉ tháng này',
  "Faqat shu oy",
  "Sadece bu ay",
  "यस महिना मात्र",
  "Fulan ida-ne'e de'it",
  "ສະເພາະເດືອນນີ້",
  "Зөвхөн энэ сар",
  "ဤလအတွက်သာ",
  "শুধুমাত্র এই মাস",
  "මෙම මාසය පමණි",
  "Hanya bulan ini",
  "សម្រាប់តែខែនេះ",
  "Ушул ай гана",
  "เฉพาะเดือนนี้",
  "صرف یہ مہینہ",
  "Buwan na ito lamang",
  "Танҳо ҳамин моҳ",
);
const _segMultiUnpaid = _S(
  '여러달 체불',
  'Multiple unpaid months',
  '多月拖欠',
  'Nhiều tháng chưa trả',
  "Bir necha toʻlanmagan oylar",
  "Birden fazla ödenmemiş ay",
  "धेरै महिनाको नतिरेको ज्याला",
  "Fulan barak ne'ebé seidauk selu",
  "ຫຼາຍເດືອນທີ່ຍັງບໍ່ໄດ້ຈ່າຍ",
  "Хэд хэдэн төлөгдөөгүй сар",
  "ပေးချေရန်ကျန်ရှိသော လများစွာ",
  "একাধিক বকেয়া মাস",
  "නොගෙවූ මාස කිහිපයක්",
  "Beberapa bulan yang belum dibayar",
  "ច្រើនខែដែលមិនទាន់បានបង់",
  "Бир нече төлөнбөгөн ай",
  "หลายเดือนที่ค้างชำระ",
  "ایک سے زیادہ غیر ادا شدہ مہینے",
  "Maraming buwan na hindi nabayaran",
  "Якчанд моҳи пардохтнашуда",
);
const _segRangeCustom = _S(
  '기간 직접 지정',
  'Custom period',
  '自定义期间',
  'Khoảng thời gian tùy chỉnh',
  "Maxsus davr",
  "Özel dönem",
  "विशेष अवधि",
  "Períodu espesífiku",
  "ໄລຍະເວລາສະເພາະ",
  "Тусгай хугацаа",
  "သတ်မှတ်ကာလ",
  "নির্দিষ্ট সময়কাল",
  "විශේෂ කාල සීමාව",
  "Periode khusus",
  "រយៈពេលជាក់លាក់",
  "Өзгөчө мезгил",
  "ช่วงเวลาที่กำหนดเอง",
  "مخصوص مدت",
  "Tiyak na panahon",
  "Давраи мушаххас",
);
const _unpaidMonthsLabel = _S(
  '못 받은 개월 수',
  'Number of unpaid months',
  '未收到工资的月数',
  'Số tháng chưa nhận lương',
  "Toʻlanmagan oylar soni",
  "Ödenmemiş ay sayısı",
  "नतिरेको महिनाहरूको संख्या",
  "Númeru fulan ne'ebé seidauk selu",
  "ຈໍານວນເດືອນທີ່ຍັງບໍ່ໄດ້ຈ່າຍ",
  "Төлөгдөөгүй сарын тоо",
  "ပေးချေရန်ကျန်ရှိသော လအရေအတွက်",
  "বকেয়া মাসের সংখ্যা",
  "නොගෙවූ මාස ගණන",
  "Jumlah bulan yang belum dibayar",
  "ចំនួនខែដែលមិនទាន់បានបង់",
  "Төлөнбөгөн айлардын саны",
  "จำนวนเดือนที่ค้างชำระ",
  "غیر ادا شدہ مہینوں کی تعداد",
  "Bilang ng buwan na hindi nabayaran",
  "Шумораи моҳҳои пардохтнашуда",
);
const _monthUnit = _S(
  '개월',
  'months',
  '个月',
  'tháng',
  "oylar",
  "ay",
  "महिना",
  "fulan",
  "ເດືອນ",
  "сар",
  "လ",
  "মাস",
  "මාස",
  "bulan",
  "ខែ",
  "ай",
  "เดือน",
  "مہینہ",
  "buwan",
  "моҳ",
);
const _rangeTitle = _S(
  '체불 시작월 ~ 종료월',
  'Unpaid period: start ~ end month',
  '拖欠开始月 ~ 结束月',
  'Tháng bắt đầu ~ kết thúc nợ lương',
  "Toʻlanmagan davr: boshlanish ~ tugash oyi",
  "Ödenmemiş dönem: başlangıç ~ bitiş ayı",
  "नतिरेको अवधि: सुरु ~ अन्तिम महिना",
  "Períodu ne'ebé seidauk selu: fulan hahú ~ fulan ramata",
  "ໄລຍະເວລາທີ່ຍັງບໍ່ໄດ້ຈ່າຍ: ເດືອນເລີ່ມຕົ້ນ ~ ເດືອນສິ້ນສຸດ",
  "Төлөгдөөгүй хугацаа: эхлэх ~ дуусах сар",
  "ပေးချေရန်ကျန်ရှိသောကာလ- စတင်သည့်လ ~ ပြီးဆုံးသည့်လ",
  "বকেয়া সময়কাল: শুরু ~ শেষ মাস",
  "නොගෙවූ කාල සීමාව: ආරම්භක ~ අවසන් මාසය",
  "Periode yang belum dibayar: bulan awal ~ akhir",
  "រយៈពេលដែលមិនទាន់បានបង់៖ ខែចាប់ផ្តើម ~ ខែបញ្ចប់",
  "Төлөнбөгөн мезгил: башталышы ~ аяктоо айы",
  "ช่วงเวลาที่ค้างชำระ: เดือนเริ่มต้น ~ เดือนสิ้นสุด",
  "غیر ادا شدہ مدت: آغاز ~ اختتامی مہینہ",
  "Panahon na hindi nabayaran: simula ~ katapusan ng buwan",
  "Давраи пардохтнашуда: моҳи оғоз ~ моҳи анҷом",
);
const _startMonthLabel = _S(
  '시작월',
  'Start month',
  '开始月',
  'Tháng bắt đầu',
  "Boshlanish oyi",
  "Başlangıç ayı",
  "सुरु महिना",
  "Fulan hahú",
  "ເດືອນເລີ່ມຕົ້ນ",
  "Эхлэх сар",
  "စတင်သည့်လ",
  "শুরুর মাস",
  "ආරම්භක මාසය",
  "Bulan awal",
  "ខែចាប់ផ្តើម",
  "Башталыш айы",
  "เดือนเริ่มต้น",
  "آغاز کا مہینہ",
  "Buwan ng pagsisimula",
  "Моҳи оғоз",
);
const _endMonthLabel = _S(
  '종료월',
  'End month',
  '结束月',
  'Tháng kết thúc',
  "Tugash oyi",
  "Bitiş ayı",
  "अन्तिम महिना",
  "Fulan ramata",
  "ເດືອນສິ້ນສຸດ",
  "Дуусах сар",
  "ပြီးဆုံးသည့်လ",
  "শেষ মাস",
  "අවසන් මාසය",
  "Bulan akhir",
  "ខែបញ្ចប់",
  "Аяктоо айы",
  "เดือนสิ้นสุด",
  "اختتامی مہینہ",
  "Buwan ng pagtatapos",
  "Моҳи анҷом",
);
const _step1Title2 = _S(
  '임금과 사업장 조건을 알려주세요',
  'Tell us about your wage and workplace conditions',
  '请告诉我们工资和工作场所的情况',
  'Hãy cho chúng tôi biết về lương và điều kiện nơi làm việc',
  "Ish haqingiz va ish joyingiz sharoitlari haqida bizga xabar bering",
  "Ücretiniz ve çalışma koşullarınız hakkında bilgi verin",
  "तपाईंको ज्याला र काम गर्ने अवस्थाहरू बारे जानकारी दिनुहोस्",
  "Fornese informasaun kona-ba Ita-nia saláriu no kondisaun serbisu",
  "ໃຫ້ຂໍ້ມູນກ່ຽວກັບຄ່າຈ້າງ ແລະ ເງື່ອນໄຂການເຮັດວຽກຂອງທ່ານ",
  "Таны цалин, ажлын нөхцлийн талаар мэдээлэл өгнө үү",
  "သင်၏လုပ်ခနှင့် အလုပ်လုပ်ကိုင်မှုအခြေအနေများအကြောင်း အချက်အလက်ထည့်သွင်းပါ",
  "আপনার বেতন এবং কাজের শর্তাবলী সম্পর্কে তথ্য দিন",
  "ඔබේ වැටුප සහ සේවා කොන්දේසි පිළිබඳ තොරතුරු සපයන්න",
  "Berikan informasi tentang upah dan kondisi kerja Anda",
  "សូមផ្តល់ព័ត៌មានអំពីប្រាក់ឈ្នួល និងលក្ខខណ្ឌការងាររបស់អ្នក",
  "Эмгек акыңыз жана иштөө шарттарыңыз жөнүндө маалымат бериңиз",
  "โปรดระบุข้อมูลเกี่ยวกับค่าจ้างและสภาพการทำงานของคุณ",
  "اپنی اجرت اور کام کے حالات کے بارے میں معلومات فراہم کریں",
  "Ibigay ang impormasyon tungkol sa inyong sahod at kondisyon sa pagtatrabaho",
  "Маълумот дар бораи музди меҳнат ва шароити кории худро пешниҳод кунед",
);
const _step1Lead2 = _S(
  '계약서에 적힌 방식 그대로 골라주세요.',
  'Please choose exactly as written in your contract.',
  '请按照合同上记载的方式选择。',
  'Vui lòng chọn đúng như trong hợp đồng.',
  "Iltimos, shartnomangizda yozilganidek tanlang.",
  "Lütfen sözleşmenizde yazıldığı gibi seçin.",
  "कृपया तपाईंको सम्झौतामा लेखिए अनुसार चयन गर्नुहोस्।",
  "Favór ida, hili tuir buat ne'ebé hakerek iha Ita-nia kontratu.",
  "ກະລຸນາເລືອກຕາມທີ່ລະບຸໄວ້ໃນສັນຍາຂອງທ່ານ.",
  "Гэрээнд зааснаар сонгоно уу.",
  "သင်၏စာချုပ်တွင် ရေးသားထားသည့်အတိုင်း ရွေးချယ်ပါ။",
  "অনুগ্রহ করে আপনার চুক্তিতে লেখা অনুযায়ী নির্বাচন করুন।",
  "කරුණාකර ඔබේ කොන්ත්‍රාත්තුවේ සඳහන් පරිදි තෝරන්න.",
  "Silakan pilih sesuai dengan yang tertulis di kontrak Anda.",
  "សូមជ្រើសរើសដូចដែលបានសរសេរនៅក្នុងកិច្ចសន្យារបស់អ្នក។",
  "Келишимиңизде жазылгандай тандаңыз.",
  "โปรดเลือกตามที่ระบุไว้ในสัญญาของคุณ",
  "براہ کرم اپنے معاہدے میں لکھے گئے کے مطابق منتخب کریں۔",
  "Mangyaring piliin ayon sa nakasulat sa inyong kontrata.",
  "Лутфан, тавре ки дар шартномаи шумо навишта шудааст, интихоб кунед.",
);
const _visaLabel = _S(
  '체류자격 (비자)',
  'Residence status (visa)',
  '居留资格（签证）',
  'Tình trạng cư trú (visa)',
  "Yashash maqomi (viza)",
  "İkamet durumu (vize)",
  "निवास स्थिति (भिसा)",
  "Estadu rezidénsia (viza)",
  "ສະຖານະການຢູ່ອາໄສ (ວີຊາ)",
  "Оршин суух статус (виз)",
  "နေထိုင်မှုအခြေအနေ (ဗီဇာ)",
  "আবাসিক অবস্থা (ভিসা)",
  "පදිංචි තත්ත්වය (වීසා)",
  "Status tinggal (visa)",
  "ស្ថានភាពស្នាក់នៅ (ទិដ្ឋាការ)",
  "Жашоо статусу (виза)",
  "สถานะการพำนัก (วีซ่า)",
  "رہائش کی حیثیت (ویزا)",
  "Katayuan ng paninirahan (visa)",
  "Вазъи истиқомат (виза)",
);
const _visaCustomLabel = _S(
  '비자 직접입력',
  'Enter visa manually',
  '手动输入签证',
  'Nhập visa thủ công',
  "Vizani qoʻlda kiriting",
  "Vizeyi manuel girin",
  "भिसा म्यानुअल रूपमा प्रविष्ट गर्नुहोस्",
  "Hatama viza ho manuál",
  "ປ້ອນວີຊາດ້ວຍຕົນເອງ",
  "Визээ гараар оруулна уу",
  "ဗီဇာကို ကိုယ်တိုင်ထည့်သွင်းပါ",
  "ম্যানুয়ালি ভিসা লিখুন",
  "වීසා අතින් ඇතුළත් කරන්න",
  "Masukkan visa secara manual",
  "បញ្ចូលទិដ្ឋាការដោយដៃ",
  "Визаны кол менен киргизүү",
  "ป้อนวีซ่าด้วยตนเอง",
  "ویزا دستی طور پر درج کریں",
  "Manu-manong ilagay ang visa",
  "Визаро дастӣ ворид кунед",
);
const _payMethodLabel = _S(
  '임금 지급 방식',
  'Wage payment method',
  '工资支付方式',
  'Hình thức trả lương',
  "Ish haqi toʻlash usuli",
  "Ücret ödeme yöntemi",
  "ज्याला भुक्तानी विधि",
  "Métodu pagamentu saláriu",
  "ວິທີການຈ່າຍຄ່າຈ້າງ",
  "Цалин олгох арга",
  "လုပ်ခပေးချေမှုနည်းလမ်း",
  "বেতন পরিশোধের পদ্ধতি",
  "වැටුප් ගෙවීමේ ක්‍රමය",
  "Metode pembayaran upah",
  "វិធីសាស្រ្តទូទាត់ប្រាក់ឈ្នួល",
  "Эмгек акы төлөө ыкмасы",
  "วิธีการจ่ายค่าจ้าง",
  "اجرت کی ادائیگی کا طریقہ",
  "Paraan ng pagbabayad ng sahod",
  "Усули пардохти музди меҳнат",
);
const _hourLabel = _S(
  '시급',
  'Hourly',
  '时薪',
  'Theo giờ',
  "Soatlik",
  "Saatlik",
  "प्रति घण्टा",
  "Oras-oras",
  "ລາຍຊົ່ວໂມງ",
  "Цагийн",
  "နာရီအလိုက်",
  "ঘণ্টাভিত্তিক",
  "පැයකට",
  "Per jam",
  "ក្នុងមួយម៉ោង",
  "Сааттык",
  "รายชั่วโมง",
  "فی گھنٹہ",
  "Orasan",
  "Соатбайъ",
);
const _dayLabel = _S(
  '일급',
  'Daily',
  '日薪',
  'Theo ngày',
  "Kunlik",
  "Günlük",
  "दैनिक",
  "Loron-loron",
  "ລາຍວັນ",
  "Өдрийн",
  "နေ့အလိုက်",
  "দৈনিক",
  "දිනකට",
  "Harian",
  "ក្នុងមួយថ្ងៃ",
  "Күндүк",
  "รายวัน",
  "روزانہ",
  "Arawan",
  "Рӯзбайъ",
);
const _weekLabel = _S(
  '주급',
  'Weekly',
  '周薪',
  'Theo tuần',
  "Haftalik",
  "Haftalık",
  "साप्ताहिक",
  "Semana-semana",
  "ລາຍອາທິດ",
  "Долоо хоногийн",
  "အပတ်အလိုက်",
  "সাপ্তাহিক",
  "සතිපතා",
  "Mingguan",
  "ក្នុងមួយសប្តាហ៍",
  "Апталык",
  "รายสัปดาห์",
  "ہفتہ وار",
  "Lingguhan",
  "Ҳафтабайъ",
);
const _monthLabel = _S(
  '월급',
  'Monthly',
  '月薪',
  'Theo tháng',
  "Oylik",
  "Aylık",
  "मासिक",
  "Fulan-fulan",
  "ລາຍເດືອນ",
  "Сарын",
  "လအလိုက်",
  "মাসিক",
  "මාසික",
  "Bulanan",
  "ក្នុងមួយខែ",
  "Айлык",
  "รายเดือน",
  "ماہانہ",
  "Buwanan",
  "Моҳона",
);
const _yearLabel = _S(
  '연봉',
  'Annual',
  '年薪',
  'Theo năm',
  "Yillik",
  "Yıllık",
  "वार्षिक",
  "Tinan-tinan",
  "ລາຍປີ",
  "Жилийн",
  "နှစ်အလိုက်",
  "বার্ষিক",
  "වාර්ෂික",
  "Tahunan",
  "ក្នុងមួយឆ្នាំ",
  "Жылдык",
  "รายปี",
  "سالانہ",
  "Taunan",
  "Солона",
);
const _monthPretaxLabel = _S(
  '월급 (세전)',
  'Monthly (pre-tax)',
  '月薪（税前）',
  'Theo tháng (trước thuế)',
  "Oylik (soliqdan oldin)",
  "Aylık (vergi öncesi)",
  "मासिक (कर अघि)",
  "Fulan-fulan (antes impostu)",
  "ລາຍເດືອນ (ກ່ອນຫັກພາສີ)",
  "Сарын (татварын өмнөх)",
  "လအလိုက် (အခွန်မဆောင်မီ)",
  "মাসিক (কর পূর্ব)",
  "මාසික (බදු පෙර)",
  "Bulanan (sebelum pajak)",
  "ប្រចាំខែ (មុនបង់ពន្ធ)",
  "Айлык (салыкка чейин)",
  "รายเดือน (ก่อนหักภาษี)",
  "ماہانہ (ٹیکس سے پہلے)",
  "Buwanan (bago ang buwis)",
  "Моҳона (пеш аз андоз)",
);
const _yearPretaxLabel = _S(
  '연봉 (세전)',
  'Annual (pre-tax)',
  '年薪（税前）',
  'Theo năm (trước thuế)',
  "Yillik (soliqdan oldin)",
  "Yıllık (vergi öncesi)",
  "वार्षिक (कर अघि)",
  "Tinan-tinan (antes impostu)",
  "ລາຍປີ (ກ່ອນຫັກພາສີ)",
  "Жилийн (татварын өмнөх)",
  "နှစ်အလိုက် (အခွန်မဆောင်မီ)",
  "বার্ষিক (কর পূর্ব)",
  "වාර්ෂික (බදු පෙර)",
  "Tahunan (sebelum pajak)",
  "ប្រចាំឆ្នាំ (មុនបង់ពន្ធ)",
  "Жылдык (салыкка чейин)",
  "รายปี (ก่อนหักภาษี)",
  "سالانہ (ٹیکس سے پہلے)",
  "Taunan (bago ang buwis)",
  "Солона (пеш аз андоз)",
);
const _wonUnit = _S(
  '원',
  'KRW',
  '韩元',
  'KRW',
  "KRW",
  "KRW",
  "KRW",
  "KRW",
  "KRW",
  "KRW",
  "KRW",
  "KRW",
  "KRW",
  "KRW",
  "វ៉ុនកូរ៉េ",
  "KRW",
  "วอนเกาหลี",
  "KRW",
  "KRW",
  "KRW",
);
const _dailyHoursLabel = _S(
  '하루 약정 근무시간',
  'Contracted daily hours',
  '每日约定工作时间',
  'Giờ làm việc theo hợp đồng mỗi ngày',
  "Shartnomadagi kunlik ish soatlari",
  "Sözleşmeli günlük çalışma saatleri",
  "सम्झौता अनुसार दैनिक काम गर्ने घण्टा",
  "Oras serbisu loron-loron tuir kontratu",
  "ຊົ່ວໂມງເຮັດວຽກຕໍ່ມື້ຕາມສັນຍາ",
  "Гэрээт өдрийн ажлын цаг",
  "စာချုပ်ပါ နေ့စဉ်အလုပ်ချိန်",
  "চুক্তি অনুযায়ী দৈনিক কাজের সময়",
  "කොන්ත්‍රාත්තුගත දෛනික වැඩ කරන පැය ගණන",
  "Jam kerja harian yang dikontrak",
  "ម៉ោងធ្វើការប្រចាំថ្ងៃតាមកិច្ចសន្យា",
  "Келишим боюнча күнүмдүк жумуш убактысы",
  "ชั่วโมงทำงานต่อวันตามสัญญา",
  "معاہدے کے مطابق روزانہ کام کے اوقات",
  "Mga oras ng pagtatrabaho bawat araw ayon sa kontrata",
  "Соатҳои кории ҳаррӯзаи шартномавӣ",
);
const _hourUnit = _S(
  '시간',
  'hours',
  '小时',
  'giờ',
  "soat",
  "saat",
  "घण्टा",
  "oras",
  "ຊົ່ວໂມງ",
  "цаг",
  "နာရီ",
  "ঘণ্টা",
  "පැය",
  "jam",
  "ម៉ោង",
  "саат",
  "ชั่วโมง",
  "گھنٹہ",
  "oras",
  "соат",
);
const _totalWorkDaysLabel = _S(
  '기간 전체 근무일수',
  'Total work days in the period',
  '期间总工作天数',
  'Tổng số ngày làm việc trong kỳ',
  "Davrdagi jami ish kunlari",
  "Dönemdeki toplam çalışma günü",
  "अवधिमा कुल काम गर्ने दिन",
  "Totál loron serbisu iha períodu",
  "ຈໍານວນມື້ເຮັດວຽກທັງໝົດໃນໄລຍະເວລາ",
  "Хугацаан дахь нийт ажлын өдөр",
  "ကာလအတွင်း စုစုပေါင်းအလုပ်လုပ်ရက်",
  "সময়কালে মোট কাজের দিন",
  "කාල සීමාව තුළ මුළු වැඩ කරන දින ගණන",
  "Total hari kerja dalam periode tersebut",
  "ចំនួនថ្ងៃធ្វើការសរុបក្នុងរយៈពេល",
  "Мезгилдеги жалпы жумуш күндөрү",
  "จำนวนวันทำงานทั้งหมดในช่วงเวลา",
  "مدت میں کام کے کل دن",
  "Kabuuang araw ng pagtatrabaho sa panahon",
  "Шумораи умумии рӯзҳои корӣ дар давра",
);
const _dayUnit = _S(
  '일',
  'days',
  '天',
  'ngày',
  "kunlar",
  "gün",
  "दिन",
  "loron",
  "ມື້",
  "өдөр",
  "ရက်",
  "দিন",
  "දින",
  "hari",
  "ថ្ងៃ",
  "күн",
  "วัน",
  "دن",
  "araw",
  "рӯз",
);
const _belowMinTitle = _S(
  '⚠ 최저임금보다 낮습니다',
  '⚠ Below minimum wage',
  '⚠ 低于最低工资',
  '⚠ Thấp hơn lương tối thiểu',
  "⚠ Minimal ish haqidan past",
  "⚠ Asgari ücretin altında",
  "⚠ न्यूनतम ज्याला भन्दा कम",
  "⚠ Menus husi saláriu mínimu",
  "⚠ ຕ່ຳກວ່າຄ່າແຮງງານຂັ້ນຕ່ຳ",
  "⚠ Хамгийн бага цалингаас доогуур",
  "⚠ အနိမ့်ဆုံးလုပ်ခအောက်",
  "⚠ ন্যূনতম মজুরির নিচে",
  "⚠ අවම වැටුපට වඩා අඩුයි",
  "⚠ Di bawah upah minimum",
  "⚠ ទាបជាងប្រាក់ឈ្នួលអប្បបរមា",
  "⚠ Эң төмөнкү эмгек акыдан төмөн",
  "⚠ ต่ำกว่าค่าแรงขั้นต่ำ",
  "⚠ کم از کم اجرت سے کم",
  "⚠ Mas mababa sa minimum na sahod",
  "⚠ Аз ҳадди ақали музди меҳнат камтар",
);
const _bizSizeLabel = _S(
  '사업장 규모',
  'Business size',
  '企业规模',
  'Quy mô doanh nghiệp',
  "Biznes hajmi",
  "İşletme büyüklüğü",
  "व्यवसायको आकार",
  "Tamañu empreza",
  "ຂະໜາດທຸລະກິດ",
  "Бизнесийн хэмжээ",
  "လုပ်ငန်းအရွယ်အစား",
  "প্রতিষ্ঠানের আকার",
  "ව්‍යාපාර ප්‍රමාණය",
  "Ukuran bisnis",
  "ទំហំអាជីវកម្ម",
  "Ишкананын көлөмү",
  "ขนาดธุรกิจ",
  "کاروبار کا سائز",
  "Laki ng negosyo",
  "Андозаи корхона",
);
const _over5Label = _S(
  '상시 5인 이상',
  '5 or more regular employees',
  '常驻员工5人以上',
  'Từ 5 nhân viên thường xuyên trở lên',
  "5 yoki undan ortiq doimiy xodimlar",
  "5 veya daha fazla düzenli çalışan",
  "5 वा सो भन्दा बढी नियमित कर्मचारीहरू",
  "5 ka liután traballadór permanente",
  "ພະນັກງານປະຈຳ 5 ຄົນ ຫຼື ຫຼາຍກວ່ານັ້ນ",
  "5 ба түүнээс дээш байнгын ажилтан",
  "5 သို့မဟုတ် ထို့ထက်ပိုသော ပုံမှန်ဝန်ထမ်းများ",
  "5 বা তার বেশি নিয়মিত কর্মচারী",
  "5 හෝ ඊට වැඩි ස්ථිර සේවකයින්",
  "5 atau lebih karyawan tetap",
  "បុគ្គលិកធម្មតា 5 នាក់ ឬច្រើនជាងនេះ",
  "5 же андан көп туруктуу кызматкер",
  "พนักงานประจำ 5 คนขึ้นไป",
  "5 یا اس سے زیادہ باقاعدہ ملازمین",
  "5 o higit pang regular na empleyado",
  "5 ё бештар кормандони доимӣ",
);
const _under5Label = _S(
  '5인 미만',
  'Fewer than 5',
  '不足5人',
  'Dưới 5 người',
  "5 dan kam",
  "5'ten az",
  "5 भन्दा कम",
  "Menos hosi 5",
  "ໜ້ອຍກວ່າ 5 ຄົນ",
  "5-өөс бага",
  "5 ထက်နည်းသည်။",
  "5 এর কম",
  "5 ට අඩු",
  "Kurang dari 5",
  "តិចជាង 5 នាក់",
  "5дон аз",
  "น้อยกว่า 5 คน",
  "5 سے کم",
  "Mas mababa sa 5",
  "Камтар аз 5",
);
const _unknownLabel = _S(
  '잘 모르겠어요',
  'Not sure',
  '不清楚',
  'Không chắc chắn',
  "Ishonchim komil emas",
  "Emin değilim",
  "निश्चित छैन",
  "La iha serteza",
  "ບໍ່ແນ່ໃຈ",
  "Эргэлзэж байна",
  "မသေချာပါ",
  "আমি নিশ্চিত নই",
  "මට විශ්වාස නැත",
  "Tidak yakin",
  "មិនប្រាកដ",
  "Ишенбейм",
  "ไม่แน่ใจ",
  "یقین نہیں",
  "Hindi sigurado",
  "Мутмаин нестам",
);
const _selectPlaceholder = _S(
  '선택',
  'Select',
  '选择',
  'Chọn',
  "Tanlash",
  "Seçiniz",
  "चयन गर्नुहोस्",
  "Hili",
  "ເລືອກ",
  "Сонгоно уу",
  "ရွေးချယ်ပါ",
  "নির্বাচন করুন",
  "තෝරන්න",
  "Pilih",
  "ជ្រើសរើស",
  "Тандоо",
  "เลือก",
  "منتخب کریں",
  "Pumili",
  "Интихоб кунед",
);

const _step2Title = _S(
  '근무시간을 알려주세요',
  'Tell us your work hours',
  '请告诉我们您的工作时间',
  'Cho chúng tôi biết giờ làm việc của bạn',
  "Ish vaqtingizni ayting",
  "Çalışma saatlerinizi bize bildirin",
  "हामीलाई आफ्नो काम गर्ने घण्टा बताउनुहोस्",
  "Informami ami kona-ba ó-nia oras servisu",
  "ແຈ້ງຊົ່ວໂມງເຮັດວຽກຂອງທ່ານໃຫ້ພວກເຮົາຊາບ",
  "Та ажлын цагаа бидэнд мэдэгдэнэ үү",
  "သင်၏အလုပ်ချိန်များကို ကျွန်ုပ်တို့အား ပြောပြပါ",
  "আপনার কাজের সময় আমাদের জানান",
  "ඔබගේ වැඩ කරන වේලාවන් අපට කියන්න",
  "Beritahu kami jam kerja Anda",
  "សូមប្រាប់យើងពីម៉ោងធ្វើការរបស់អ្នក",
  "Иш убактыңызды бизге билдириңиз",
  "โปรดแจ้งชั่วโมงการทำงานของคุณให้เราทราบ",
  "اپنے کام کے اوقات ہمیں بتائیں",
  "Ipaalam sa amin ang iyong mga oras ng trabaho",
  "Лутфан, соатҳои кории худро ба мо хабар диҳед",
);
const _step2Lead = _S(
  '약정 시간과 실제 근무 시간의 차이를 계산합니다.',
  'We calculate the difference between contracted hours and actual work hours.',
  '计算约定时间与实际工作时间的差异。',
  'Chúng tôi tính toán chênh lệch giữa giờ theo hợp đồng và giờ làm việc thực tế.',
  "Biz shartnomaviy ish soatlari va haqiqiy ish soatlari oʻrtasidagi farqni hisoblaymiz.",
  "Sözleşmeli saatler ile fiili çalışma saatleri arasındaki farkı hesaplıyoruz.",
  "हामी अनुबन्धित घण्टा र वास्तविक काम गर्ने घण्टा बीचको भिन्नता गणना गर्छौं।",
  "Ami kalkula diferensa entre oras servisu kontratadu no oras servisu real.",
  "ພວກເຮົາຄິດໄລ່ຄວາມແຕກຕ່າງລະຫວ່າງຊົ່ວໂມງຕາມສັນຍາ ແລະ ຊົ່ວໂມງເຮັດວຽກຕົວຈິງ.",
  "Бид гэрээт цаг болон бодит ажлын цагийн зөрүүг тооцоолно.",
  "ကျွန်ုပ်တို့သည် သဘောတူညီထားသော နာရီများနှင့် အမှန်တကယ် အလုပ်လုပ်ခဲ့သော နာရီများအကြား ကွာခြားချက်ကို တွက်ချက်ပါသည်။",
  "আমরা চুক্তিবদ্ধ কাজের সময় এবং প্রকৃত কাজের সময়ের মধ্যে পার্থক্য গণনা করি।",
  "අපි කොන්ත්‍රාත්ගත පැය ගණන සහ සැබෑ වැඩ කරන වේලාවන් අතර වෙනස ගණනය කරමු.",
  "Kami menghitung perbedaan antara jam yang dikontrak dan jam kerja aktual.",
  "យើងកំពុងគណនាភាពខុសគ្នារវាងម៉ោងធ្វើការតាមកិច្ចសន្យា និងម៉ោងធ្វើការជាក់ស្តែង។",
  "Биз келишимде көрсөтүлгөн сааттар менен иш жүзүндөгү иш сааттарынын ортосундагы айырманы эсептейбиз.",
  "เราจะคำนวณความแตกต่างระหว่างชั่วโมงการทำงานตามสัญญาและชั่วโมงการทำงานจริง",
  "ہم معاہدے کے اوقات اور اصل کام کے اوقات کے درمیان فرق کا حساب لگاتے ہیں۔",
  "Kinakalkula namin ang pagkakaiba sa pagitan ng mga oras na nakasaad sa kontrata at ng aktwal na oras ng trabaho.",
  "Мо фарқи байни соатҳои шартномавӣ ва соатҳои воқеии кориро ҳисоб мекунем.",
);
const _weeklyHoursLabel = _S(
  '주당 근로시간',
  'Weekly work hours',
  '每周工作时间',
  'Giờ làm việc hàng tuần',
  "Haftalik ish soatlari",
  "Haftalık çalışma saatleri",
  "साप्ताहिक काम गर्ने घण्टा",
  "Oras servisu semana-semana",
  "ຊົ່ວໂມງເຮັດວຽກຕໍ່ອາທິດ",
  "Долоо хоногийн ажлын цаг",
  "အပတ်စဉ် အလုပ်ချိန်များ",
  "সাপ্তাহিক কাজের সময়",
  "සතිපතා වැඩ කරන වේලාවන්",
  "Jam kerja mingguan",
  "ម៉ោងធ្វើការប្រចាំសប្តាហ៍",
  "Жумалык иш сааттары",
  "ชั่วโมงการทำงานต่อสัปดาห์",
  "ہفتہ وار کام کے اوقات",
  "Lingguhang oras ng trabaho",
  "Соатҳои кории ҳафтаина",
);
const _weeklyContractLabel = _S(
  '주당 약정 근로시간',
  'Contracted weekly hours',
  '每周约定工作时间',
  'Giờ làm việc theo hợp đồng hàng tuần',
  "Shartnomaviy haftalik soatlar",
  "Sözleşmeli haftalık saatler",
  "अनुबन्धित साप्ताहिक घण्टा",
  "Oras semana-semana kontratadu",
  "ຊົ່ວໂມງຕໍ່ອາທິດຕາມສັນຍາ",
  "Долоо хоногийн гэрээт цаг",
  "သဘောတူထားသော အပတ်စဉ် နာရီများ",
  "চুক্তিবদ্ধ সাপ্তাহিক কাজের সময়",
  "කොන්ත්‍රාත්ගත සතිපතා පැය ගණන",
  "Jam mingguan yang dikontrak",
  "ម៉ោងប្រចាំសប្តាហ៍តាមកិច្ចសន្យា",
  "Келишим боюнча жумалык сааттар",
  "ชั่วโมงการทำงานต่อสัปดาห์ตามสัญญา",
  "معاہدے کے مطابق ہفتہ وار اوقات",
  "Lingguhang oras na nakasaad sa kontrata",
  "Соатҳои ҳафтаинаи шартномавӣ",
);
const _overtimeSectionTitle = _S(
  '선택 기간 전체 초과 근무',
  'Total overtime in the selected period',
  '所选期间的总加班',
  'Tổng số giờ làm thêm trong kỳ đã chọn',
  "Tanlangan davrdagi jami qoʻshimcha ish vaqti",
  "Seçilen dönemdeki toplam fazla mesai",
  "चयन गरिएको अवधिमा कुल अतिरिक्त समय",
  "Total oras-extra iha períodu ne'ebé hili",
  "ຊົ່ວໂມງລ່ວງເວລារວມໃນໄລຍະເວລາທີ່ເລືອກ",
  "Сонгосон хугацааны нийт илүү цаг",
  "ရွေးချယ်ထားသော ကာလအတွင်း စုစုပေါင်း အချိန်ပို",
  "নির্বাচিত সময়ের মধ্যে মোট ওভারটাইম",
  "තෝරාගත් කාල සීමාව තුළ මුළු අතිකාල",
  "Total lembur dalam periode yang dipilih",
  "ម៉ោងបន្ថែមសរុបក្នុងរយៈពេលដែលបានជ្រើសរើស",
  "Тандалган мезгилдеги жалпы ашыкча иштөө",
  "ค่าล่วงเวลาทั้งหมดในช่วงเวลาที่เลือก",
  "منتخب کردہ مدت میں کل اوور ٹائم",
  "Kabuuang overtime sa napiling panahon",
  "Ҳаҷми умумии коркарди изофагӣ дар давраи интихобшуда",
);
const _otLabel = _S(
  '연장근로',
  'Overtime work',
  '延长劳动',
  'Làm thêm giờ',
  "Qoʻshimcha ish",
  "Fazla mesai",
  "अतिरिक्त समय",
  "Oras-extra",
  "ຊົ່ວໂມງລ່ວງເວລາ",
  "Илүү цаг",
  "အချိန်ပို",
  "ওভারটাইম",
  "අතිකාල",
  "Lembur",
  "ម៉ោងបន្ថែម",
  "Ашыкча иштөө",
  "ค่าล่วงเวลา",
  "اوور ٹائم",
  "Overtime",
  "Коркарди изофагӣ",
);
const _nightLabel = _S(
  '야간근로 (22시~06시)',
  'Night work (22:00–06:00)',
  '夜间劳动（22点~6点）',
  'Làm việc ban đêm (22h~6h)',
  "Tungi ish (22:00–06:00)",
  "Gece çalışması (22:00–06:00)",
  "रातको काम (22:00–06:00)",
  "Servisu kalan (22:00–06:00)",
  "ການເຮັດວຽກໃນຕອນກາງຄືນ (22:00–06:00)",
  "Шөнийн ажил (22:00–06:00)",
  "ညဆိုင်းအလုပ် (22:00–06:00)",
  "রাতের কাজ (22:00–06:00)",
  "රාත්‍රී වැඩ (22:00–06:00)",
  "Kerja malam (22:00–06:00)",
  "ការងារពេលយប់ (22:00–06:00)",
  "Түнкү жумуш (22:00–06:00)",
  "การทำงานกะกลางคืน (22:00–06:00)",
  "رات کا کام (22:00–06:00)",
  "Panggabing trabaho (22:00–06:00)",
  "Кори шабона (22:00–06:00)",
);
const _holLabel = _S(
  '휴일근로',
  'Holiday work',
  '假日劳动',
  'Làm việc ngày lễ',
  "Bayramdagi ish",
  "Tatil çalışması",
  "बिदाको काम",
  "Servisu feriadu",
  "ການເຮັດວຽກໃນວັນພັກ",
  "Баярын өдрийн ажил",
  "အားလပ်ရက် အလုပ်",
  "ছুটির দিনের কাজ",
  "නිවාඩු දින වැඩ",
  "Kerja libur",
  "ការងារថ្ងៃឈប់សម្រាក",
  "Майрам күндөрү иштөө",
  "การทำงานในวันหยุด",
  "چھٹی کے دن کا کام",
  "Trabaho sa holiday",
  "Кори идона",
);

const _step3Title = _S(
  '재직 기간을 알려주세요',
  'Tell us your employment period',
  '请告诉我们您的在职期间',
  'Cho chúng tôi biết thời gian làm việc của bạn',
  "Ishga joylashish davringizni ayting",
  "Bize istihdam sürenizi söyleyin",
  "हामीलाई आफ्नो रोजगारीको अवधि बताउनुहोस्",
  "Favor hateten mai ami kona-ba ó-nia períodu empregu",
  "ບອກໄລຍະເວລາການຈ້າງງານຂອງທ່ານໃຫ້ພວກເຮົາຊາບ",
  "Бидэнд ажилласан хугацаагаа хэлнэ үү",
  "သင်၏ အလုပ်ခန့်ထားမှု ကာလကို ကျွန်ုပ်တို့အား ပြောပြပါ",
  "আপনার কর্মসংস্থানের সময়কাল আমাদের বলুন",
  "ඔබගේ සේවා කාලය අපට කියන්න",
  "Beritahu kami durasi kerja Anda",
  "សូមប្រាប់យើងពីរយៈពេលការងាររបស់អ្នក",
  "Бизге иштеген мөөнөтүңүздү айтыңыз",
  "โปรดแจ้งระยะเวลาการจ้างงานของคุณให้เราทราบ",
  "ہمیں اپنی ملازمت کی مدت بتائیں",
  "Sabihin sa amin ang tagal ng iyong pagtatrabaho",
  "Лутфан, муҳлати шуғли худро ба мо хабар диҳед",
);
const _step3Lead = _S(
  '입사일과 퇴사일을 입력해 주세요.',
  'Please enter your hire date and resignation date.',
  '请输入入职日期和离职日期。',
  'Vui lòng nhập ngày vào làm và ngày nghỉ việc.',
  "Iltimos, ishga kirgan sanangizni va ishdan boʻshagan sanangizni kiriting.",
  "Lütfen işe başlama ve işten ayrılma tarihinizi girin.",
  "कृपया आफ्नो काम सुरु गरेको र काम छोडेको मिति प्रविष्ट गर्नुहोस्।",
  "Favor hatama ó-nia data hahú servisu no data sai husi servisu.",
  "ກະລຸນາປ້ອນວັນທີເລີ່ມຕົ້ນເຮັດວຽກ ແລະ ວັນທີສິ້ນສຸດການເຮັດວຽກຂອງທ່ານ.",
  "Ажилд орсон болон ажлаас гарсан огноогоо оруулна уу.",
  "ကျေးဇူးပြု၍ သင်၏ အလုပ်စတင်သည့်ရက်စွဲနှင့် အလုပ်မှထွက်သည့်ရက်စွဲကို ထည့်သွင်းပါ။",
  "অনুগ্রহ করে আপনার শুরু এবং শেষ হওয়ার তারিখ লিখুন।",
  "කරුණාකර ඔබගේ රැකියාව ආරම්භ කළ දිනය සහ රැකියාවෙන් ඉවත් වූ දිනය ඇතුළත් කරන්න.",
  "Mohon masukkan tanggal mulai dan tanggal berhenti kerja Anda.",
  "សូមបញ្ចូលកាលបរិច្ឆេទចាប់ផ្តើមការងារ និងកាលបរិច្ឆេទឈប់សម្រាករបស់អ្នក។",
  "Сураныч, жумушка кирген жана жумуштан кеткен күнүңүздү киргизиңиз.",
  "โปรดระบุวันที่เริ่มงานและวันที่สิ้นสุดการจ้างงานของคุณ",
  "براہ کرم اپنی ملازمت شروع کرنے اور ختم کرنے کی تاریخ درج کریں۔",
  "Pakipasok ang iyong petsa ng pagsisimula at pagtatapos ng trabaho.",
  "Лутфан, санаи оғози кор ва санаи қатъи корро ворид кунед.",
);
const _tenureLabel = _S(
  '근속 기간',
  'Tenure period',
  '在职期间',
  'Thời gian làm việc',
  "Ish staji davri",
  "Çalışma süresi",
  "काम गर्ने अवधि",
  "Períodu servisu",
  "ໄລຍະເວລາການເຮັດວຽກ",
  "Ажилласан хугацаа",
  "အလုပ်ခန့်ထားမှု ကာလ",
  "কর্মসংস্থানের সময়কাল",
  "සේවා කාලය",
  "Durasi kerja",
  "រយៈពេលការងារ",
  "Иштеген мөөнөтү",
  "ระยะเวลาการทำงาน",
  "ملازمت کی مدت",
  "Tagal ng pagtatrabaho",
  "Муҳлати кор",
);
const _hireDateLabel = _S(
  '입사일',
  'Hire date',
  '入职日期',
  'Ngày vào làm',
  "Ishga qabul qilingan sana",
  "İşe alım tarihi",
  "भर्ना मिति",
  "Data rekrutamentu",
  "ວັນທີເລີ່ມເຮັດວຽກ",
  "Ажилд орсон огноо",
  "အလုပ်စတင်သည့်ရက်စွဲ",
  "নিয়োগের তারিখ",
  "සේවයට බැඳුණු දිනය",
  "Tanggal perekrutan",
  "កាលបរិច្ឆេទជ្រើសរើស",
  "Жумушка алынган күнү",
  "วันที่เริ่มจ้างงาน",
  "ملازمت کی تاریخ",
  "Petsa ng pagkuha sa trabaho",
  "Санаи ба кор қабул",
);
const _leaveDateLabel = _S(
  '퇴사일 (해당 시)',
  'Resignation date (if applicable)',
  '离职日期（如适用）',
  'Ngày nghỉ việc (nếu có)',
  "Ishdan boʻshash sanasi (agar mavjud boʻlsa)",
  "İşten ayrılma tarihi (varsa)",
  "काम छोडेको मिति (यदि छ भने)",
  "Data sai husi servisu (se iha)",
  "ວັນທີສິ້ນສຸດການເຮັດວຽກ (ຖ້າມີ)",
  "Ажлаас гарсан огноо (хэрэв байгаа бол)",
  "အလုပ်မှထွက်သည့်ရက်စွဲ (ရှိပါက)",
  "চাকরি ছাড়ার তারিখ (যদি থাকে)",
  "රැකියාවෙන් ඉවත් වූ දිනය (ඇත්නම්)",
  "Tanggal berhenti kerja (jika ada)",
  "កាលបរិច្ឆេទឈប់សម្រាក (ប្រសិនបើមាន)",
  "Жумуштан кеткен күнү (эгер болсо)",
  "วันที่สิ้นสุดการจ้างงาน (ถ้ามี)",
  "ملازمت ختم ہونے کی تاریخ (اگر قابل اطلاق ہو)",
  "Petsa ng pagtatapos ng trabaho (kung mayroon)",
  "Санаи қатъи кор (агар мавҷуд бошад)",
);
const _absenceLabel = _S(
  '결근 여부',
  'Absence status',
  '缺勤情况',
  'Tình trạng vắng mặt',
  "Yoʻqlik holati",
  "Devamsızlık durumu",
  "अनुपस्थितिको स्थिति",
  "Situasaun la mai servisu",
  "ສະຖານະການຂາດວຽກ",
  "Эзгүйдэл",
  "ခွင့်မဲ့ပျက်ကွက်မှု အခြေအနေ",
  "অনুপস্থিতির অবস্থা",
  "නොපැමිණීමේ තත්ත්වය",
  "Status ketidakhadiran",
  "ស្ថានភាពអវត្តមាន",
  "Жумушка чыкпаган абал",
  "สถานะการขาดงาน",
  "غیر حاضری کی صورتحال",
  "Katayuan ng pagliban",
  "Ҳолати ғоибшавӣ",
);
const _absenceToggle = _S(
  '확인 기간 중 결근이 있습니다',
  'There was an absence during the period',
  '确认期间内有缺勤',
  'Có vắng mặt trong kỳ xác nhận',
  "Davr mobaynida yoʻqlik boʻlgan",
  "Dönem içinde devamsızlık vardı",
  "अवधिमा अनुपस्थिति थियो",
  "Iha períodu ne'e, iha la mai servisu",
  "ມີການຂາດວຽກໃນໄລຍະເວລາ",
  "Тус хугацаанд эзгүйдэл байсан",
  "ကာလအတွင်း ခွင့်မဲ့ပျက်ကွက်မှု ရှိခဲ့သည်",
  "সময়কালের মধ্যে অনুপস্থিতি ছিল",
  "කාල සීමාව තුළ නොපැමිණීමක් තිබුණි",
  "Ada ketidakhadiran selama periode tersebut",
  "មានការអវត្តមានក្នុងអំឡុងពេលនេះ",
  "Мезгил ичинде жумушка чыкпаган учурлар болгон",
  "มีการขาดงานในช่วงเวลาดังกล่าว",
  "مدت کے دوران غیر حاضری تھی",
  "Nagkaroon ng pagliban sa loob ng panahon",
  "Дар давраи мазкур ғоибшавӣ буд",
);
const _whySeparateTitle = _S(
  '왜 체불 기간과 재직 기간을 분리하나요?',
  'Why separate the unpaid period from the employment period?',
  '为什么要将拖欠期间与在职期间分开？',
  'Tại sao lại tách riêng kỳ nợ lương và thời gian làm việc?',
  "Nima uchun haq toʻlanmagan davrni ishga joylashish davridan ajratish kerak?",
  "Ücretsiz dönemi neden istihdam süresinden ayırıyoruz?",
  "हामी किन भुक्तानी नगरिएको अवधिलाई रोजगारीको अवधिबाट अलग गर्छौं?",
  "Tanba sá mak ami fahe períodu la selu husi períodu empregu?",
  "ເປັນຫຍັງພວກເຮົາຈຶ່ງແຍກໄລຍະເວລາທີ່ບໍ່ໄດ້ຮັບຄ່າຈ້າງອອກຈາກໄລຍະເວລາການຈ້າງງານ?",
  "Бид яагаад цалингүй хугацааг ажилласан хугацаанаас тусад нь авч үздэг вэ?",
  "အလုပ်ခန့်ထားမှု ကာလမှ လစာမဲ့ကာလကို အဘယ်ကြောင့် ခွဲထုတ်ရသနည်း။",
  "কেন আমরা কর্মসংস্থানের সময়কাল থেকে অবৈতনিক সময়কাল আলাদা করি?",
  "සේවා කාලයෙන් වැටුප් රහිත කාලය වෙන් කරන්නේ ඇයි?",
  "Mengapa kami memisahkan periode tidak berbayar dari durasi kerja?",
  "ហេតុអ្វីបានជាយើងបំបែករយៈពេលគ្មានប្រាក់ឈ្នួលចេញពីរយៈពេលការងារ?",
  "Эмне үчүн акы төлөнбөгөн мезгилди иштеген мөөнөттөн бөлүп жатабыз?",
  "เหตุใดเราจึงแยกช่วงเวลาที่ไม่มีค่าจ้างออกจากระยะเวลาการจ้างงาน",
  "ہم ملازمت کی مدت سے بلا معاوضہ مدت کو کیوں الگ کرتے ہیں؟",
  "Bakit namin hinihiwalay ang panahon na walang bayad mula sa tagal ng pagtatrabaho?",
  "Чаро мо давраи бемуздро аз муҳлати шуғл ҷудо мекунем?",
);
const _whySeparateBody = _S(
  '2년을 일했지만 최근 3개월치 급여만 밀린 경우처럼 "다닌 기간"과 "못 받은 기간"이 다를 수 있습니다. 여기서 입력하는 재직 기간은 퇴직금 요건 산정에만 사용됩니다.',
  'The "employment period" and the "unpaid period" can differ — for example, working for 2 years but only the last 3 months\' pay being unpaid. The employment period entered here is used only to calculate severance pay eligibility.',
  '"在职期间"和"未收到工资的期间"可能不同，例如工作了2年但只有最近3个月的工资被拖欠。此处输入的在职期间仅用于计算退休金资格。',
  '"Thời gian làm việc" và "thời gian chưa nhận lương" có thể khác nhau, ví dụ làm việc 2 năm nhưng chỉ 3 tháng gần nhất chưa được trả lương. Thời gian làm việc nhập ở đây chỉ dùng để tính điều kiện trợ cấp thôi việc.',
  "“Ishga joylashish davri” va “haq toʻlanmagan davr” farq qilishi mumkin — masalan, 2 yil ishlagan, ammo faqat oxirgi 3 oylik ish haqi toʻlanmagan. Bu yerda kiritilgan ishga joylashish davri faqat ishdan boʻshatish nafaqasiga boʻlgan huquqni hisoblash uchun ishlatiladi.",
  "\"İstihdam süresi\" ve \"ücretsiz dönem\" farklılık gösterebilir — örneğin, 2 yıl çalışıp sadece son 3 ayın ücretinin ödenmemesi gibi. Buraya girilen istihdam süresi yalnızca kıdem tazminatı uygunluğunu hesaplamak için kullanılır.",
  "“रोजगारीको अवधि” र “भुक्तानी नगरिएको अवधि” फरक हुन सक्छ — उदाहरणका लागि, 2 वर्ष काम गरेर अन्तिम 3 महिनाको मात्र तलब नपाएको हुन सक्छ। यहाँ प्रविष्ट गरिएको रोजगारीको अवधि केवल सेवा निवृत्त लाभको योग्यता गणना गर्न प्रयोग गरिन्छ।",
  "\"Períodu empregu\" no \"períodu la selu\" bele la hanesan — ezemplu, servisu ba tinan 2 maibé fulan 3 ikus de'it mak la selu. Períodu empregu ne'ebé hatama iha ne'e uza de'it atu kalkula elegibilidade ba kompensasaun despedimentu.",
  "“ໄລຍະເວລາການຈ້າງງານ” ແລະ “ໄລຍະເວລາທີ່ບໍ່ໄດ້ຮັບຄ່າຈ້າງ” ອາດຈະແຕກຕ່າງກັນ — ຕົວຢ່າງເຊັ່ນ, ເຮັດວຽກ 2 ປີ ແຕ່ບໍ່ໄດ້ຮັບຄ່າຈ້າງພຽງແຕ່ 3 ເດືອນສຸດທ້າຍ. ໄລຍະເວລາການຈ້າງງານທີ່ປ້ອນຢູ່ນີ້ ຖືກນໍາໃຊ້ພຽງແຕ່ເພື່ອຄິດໄລ່ເງື່ອນໄຂການໄດ້ຮັບເງິນຊົດເຊີຍການອອກຈາກວຽກ.",
  "Ажилласан хугацаа болон цалингүй хугацаа нь өөр байж болно — жишээлбэл, та 2 жил ажилласан боловч сүүлийн 3 сарын цалингаа аваагүй байж болно. Энд оруулсан ажилласан хугацааг зөвхөн тэтгэмжийн шалгуурыг тооцоолоход ашиглана.",
  "“အလုပ်ခန့်ထားမှု ကာလ” နှင့် “လစာမဲ့ကာလ” ကွာခြားနိုင်သည် — ဥပမာအားဖြင့်၊ 2 နှစ် အလုပ်လုပ်ခဲ့သော်လည်း နောက်ဆုံး 3 လအတွက် လစာမရရှိခြင်းမျိုး ဖြစ်နိုင်သည်။ ဤနေရာတွင် ထည့်သွင်းထားသော အလုပ်ခန့်ထားမှု ကာလကို အလုပ်သက်တမ်းအလိုက် ဆုကြေးငွေ ရရှိရန် အရည်အချင်းပြည့်မီမှုကို တွက်ချက်ရန်အတွက်သာ အသုံးပြုပါသည်။",
  "\"কর্মসংস্থানের সময়কাল\" এবং \"অবৈতনিক সময়কাল\" ভিন্ন হতে পারে — উদাহরণস্বরূপ, 2 বছর কাজ করা কিন্তু শুধুমাত্র শেষ 3 মাসের জন্য বেতন না পাওয়া। এখানে প্রবেশ করা কর্মসংস্থানের সময়কাল শুধুমাত্র সেভারেন্স পে-এর যোগ্যতা গণনা করতে ব্যবহৃত হয়।",
  "“සේවා කාලය” සහ “වැටුප් රහිත කාලය” වෙනස් විය හැක — උදාහරණයක් ලෙස, ඔබ වසර 2ක් සේවය කර ඇති නමුත් අවසාන මාස 3 සඳහා පමණක් වැටුප් නොලැබීම වැනි. මෙහි ඇතුළත් කර ඇති සේවා කාලය භාවිතා කරනු ලබන්නේ සේවා කාලය සඳහා වන්දි ගෙවීමට ඇති අයිතිය ගණනය කිරීම සඳහා පමණි.",
  "\"Durasi kerja\" dan \"periode tidak berbayar\" mungkin berbeda — misalnya, Anda bekerja selama 2 tahun tetapi hanya 3 bulan terakhir yang tidak dibayar. Durasi kerja yang dimasukkan di sini hanya digunakan untuk menghitung kelayakan pesangon.",
  "«រយៈពេលការងារ» និង «រយៈពេលគ្មានប្រាក់ឈ្នួល» អាចខុសគ្នា — ឧទាហរណ៍ ធ្វើការ 2 ឆ្នាំ ប៉ុន្តែមានតែ 3 ខែចុងក្រោយប៉ុណ្ណោះដែលមិនបានបង់ប្រាក់។ រយៈពេលការងារដែលបានបញ្ចូលនៅទីនេះ គឺសម្រាប់តែការគណនាសិទ្ធិទទួលបានប្រាក់បំណាច់អតីតភាពការងារប៉ុណ្ណោះ។",
  "«Иштеген мөөнөт» жана «акы төлөнбөгөн мезгил» ар кандай болушу мүмкүн — мисалы, 2 жыл иштеп, акыркы 3 айдын гана эмгек акысы төлөнбөгөн сыяктуу. Бул жерге киргизилген иштеген мөөнөт кызмат өтөө мөөнөтү үчүн компенсацияга жарамдуулукту эсептөө үчүн гана колдонулат.",
  "“ระยะเวลาการจ้างงาน” และ “ช่วงเวลาที่ไม่มีค่าจ้าง” อาจแตกต่างกันได้ — ตัวอย่างเช่น ทำงานมา 2 ปี แต่ไม่ได้รับค่าจ้างในช่วง 3 เดือนสุดท้าย ระยะเวลาการจ้างงานที่ป้อนที่นี่ใช้เพื่อคำนวณสิทธิ์ในการรับเงินชดเชยการเลิกจ้างเท่านั้น",
  "ملازمت کی مدت اور بلا معاوضہ مدت مختلف ہو سکتی ہے — مثال کے طور پر، 2 سال کام کرنے کے بعد صرف آخری 3 ماہ کی تنخواہ ادا نہ کی گئی ہو۔ یہاں درج کی گئی ملازمت کی مدت صرف علیحدگی کے معاوضے کی اہلیت کا حساب لگانے کے لیے استعمال ہوتی ہے۔",
  "Maaaring magkaiba ang \"tagal ng pagtatrabaho\" at \"panahon na walang bayad\" — halimbawa, nagtrabaho ka ng 2 taon ngunit ang huling 3 buwan lang ang hindi nabayaran. Ang tagal ng pagtatrabaho na inilagay dito ay ginagamit lamang upang kalkulahin ang pagiging karapat-dapat para sa severance pay.",
  "«Муҳлати шуғл» ва «давраи бемузд» метавонанд фарқ кунанд — масалан, 2 сол кор карда, танҳо музди 3 моҳи охир пардохт нашудааст. Муҳлати шуғли дар ин ҷо воридшуда танҳо барои ҳисоб кардани ҳуқуқ ба ҷуброни собиқаи корӣ истифода мешавад.",
);
const _severanceExtraTitle = _S(
  '퇴직금 정밀 산정용 추가 입력 (선택)',
  'Additional input for precise severance calculation (optional)',
  '用于精确计算退休金的附加输入（可选）',
  'Nhập thêm để tính chính xác trợ cấp thôi việc (không bắt buộc)',
  "Aniq ishdan boʻshatish nafaqasini hisoblash uchun qoʻshimcha maʼlumot (ixtiyoriy)",
  "Hassas kıdem tazminatı hesaplaması için ek giriş (isteğe bağlı)",
  "सटीक सेवा निवृत्त लाभ गणनाको लागि अतिरिक्त प्रविष्टि (ऐच्छिक)",
  "Informasaun adisionál (opsionál) ba kalkulasaun kompensasaun despedimentu ne'ebé presiza",
  "ຂໍ້ມູນເພີ່ມເຕີມສໍາລັບການຄິດໄລ່ເງິນຊົດເຊີຍການອອກຈາກວຽກທີ່ລະອຽດ (ທາງເລືອກ)",
  "Тэтгэмжийг нарийн тооцоолох нэмэлт мэдээлэл (заавал биш)",
  "တိကျသော အလုပ်သက်တမ်းအလိုက် ဆုကြေးငွေ တွက်ချက်မှုအတွက် ထပ်ဆောင်းထည့်သွင်းမှု (ရွေးချယ်နိုင်သည်)",
  "সঠিক সেভারেন্স পে গণনার জন্য অতিরিক্ত ইনপুট (ঐচ্ছিক)",
  "නිවැරදි සේවා කාලය සඳහා වන්දි ගණනය කිරීම සඳහා අමතර ඇතුළත් කිරීම් (විකල්ප)",
  "Input tambahan untuk perhitungan pesangon yang akurat (opsional)",
  "ការបញ្ចូលបន្ថែមសម្រាប់ការគណនាប្រាក់បំណាច់អតីតភាពការងារបានត្រឹមត្រូវ (ស្រេចចិត្ត)",
  "Кызмат өтөө мөөнөтү үчүн компенсацияны так эсептөө үчүн кошумча маалымат (милдеттүү эмес)",
  "ข้อมูลเพิ่มเติมสำหรับการคำนวณเงินชดเชยการเลิกจ้างที่แม่นยำ (ไม่บังคับ)",
  "علیحدگی کے معاوضے کے درست حساب کے لیے اضافی معلومات (اختیاری)",
  "Karagdagang input para sa tumpak na pagkalkula ng severance pay (opsyonal)",
  "Маълумоти иловагӣ барои ҳисоби дақиқи ҷуброни собиқаи корӣ (ихтиёрӣ)",
);
const _bonus1yLabel = _S(
  '최근 1년 정기상여금 총액',
  'Total regular bonus in the last year',
  '最近1年定期奖金总额',
  'Tổng tiền thưởng định kỳ trong 1 năm gần nhất',
  "Oʻtgan yildagi jami muntazam bonus",
  "Son bir yıldaki toplam düzenli ikramiye",
  "पछिल्लो एक वर्षमा कुल नियमित बोनस",
  "Total bónus regulár iha tinan ikus",
  "ເງິນໂບນັດປົກກະຕິລວມໃນໜຶ່ງປີທີ່ຜ່ານມາ",
  "Сүүлийн нэг жилийн нийт тогтмол урамшуулал",
  "နောက်ဆုံးတစ်နှစ်အတွင်း စုစုပေါင်း ပုံမှန်ဆုကြေးငွေ",
  "গত এক বছরে মোট নিয়মিত বোনাস",
  "පසුගිය වසරේ මුළු සාමාන්‍ය ප්‍රසාද දීමනාව",
  "Total bonus reguler dalam satu tahun terakhir",
  "ប្រាក់រង្វាន់ធម្មតាសរុបក្នុងរយៈពេលមួយឆ្នាំចុងក្រោយ",
  "Акыркы бир жылдагы жалпы үзгүлтүксүз бонус",
  "โบนัสปกติทั้งหมดในปีที่ผ่านมา",
  "گزشتہ ایک سال میں کل باقاعدہ بونس",
  "Kabuuang regular na bonus sa huling isang taon",
  "Ҳаҷми умумии мукофотпулии муқаррарӣ дар як соли охир",
);
const _vacation1yLabel = _S(
  '최근 1년 미사용 연차수당',
  'Unused annual leave pay in the last year',
  '最近1年未使用年假补贴',
  'Tiền phép năm chưa sử dụng trong 1 năm gần nhất',
  "Oʻtgan yildagi foydalanilmagan yillik taʼtil haqi",
  "Son bir yıldaki kullanılmayan yıllık izin ücreti",
  "पछिल्लो एक वर्षमा प्रयोग नगरिएको वार्षिक बिदाको तलब",
  "Saláriu lisensa anuál ne'ebé la uza iha tinan ikus",
  "ຄ່າຈ້າງວັນພັກປະຈໍາປີທີ່ບໍ່ໄດ້ໃຊ້ໃນໜຶ່ງປີທີ່ຜ່ານມາ",
  "Сүүлийн нэг жилийн ашиглагдаагүй жилийн амралтын цалин",
  "နောက်ဆုံးတစ်နှစ်အတွင်း အသုံးမပြုရသေးသော နှစ်စဉ်ခွင့်ရက်အတွက် လစာ",
  "গত এক বছরে অব্যবহৃত বার্ষিক ছুটির বেতন",
  "පසුගිය වසරේ භාවිත නොකළ වාර්ෂික නිවාඩු වැටුප්",
  "Pembayaran cuti tahunan yang tidak terpakai dalam satu tahun terakhir",
  "ប្រាក់ឈ្នួលឈប់សម្រាកប្រចាំឆ្នាំដែលមិនបានប្រើប្រាស់ក្នុងរយៈពេលមួយឆ្នាំចុងក្រោយ",
  "Акыркы бир жылдагы пайдаланылбаган жылдык өргүү үчүн төлөм",
  "ค่าจ้างวันหยุดพักร้อนประจำปีที่ไม่ได้ใช้ในปีที่ผ่านมา",
  "گزشتہ ایک سال میں غیر استعمال شدہ سالانہ چھٹی کی تنخواہ",
  "Bayad para sa hindi nagamit na taunang bakasyon sa huling isang taon",
  "Музди рухсатии солонаи истифоданашуда дар як соли охир",
);

const _step4Title = _S(
  '어떻게 공제되고 있나요?',
  'How are deductions being made?',
  '扣除方式是怎样的？',
  'Các khoản khấu trừ như thế nào?',
  "Chegirmalar qanday amalga oshirilmoqda?",
  "Kesintiler nasıl yapılıyor?",
  "कटौती कसरी गरिन्छ?",
  "Oinsá mak dedusaun sira halo?",
  "ການຫັກເງິນຖືກເຮັດແນວໃດ?",
  "Суутгалыг хэрхэн хийдэг вэ?",
  "နုတ်ယူမှုများကို မည်သို့ပြုလုပ်သနည်း။",
  "কীভাবে কর্তন করা হয়?",
  "කැප කිරීම් සිදු කරන්නේ කෙසේද?",
  "Bagaimana pemotongan dilakukan?",
  "តើការកាត់កងត្រូវបានធ្វើឡើងដោយរបៀបណា?",
  "Кемитүүлөр кантип жасалат?",
  "การหักเงินทำได้อย่างไร",
  "کٹوتی کیسے کی جاتی ہے؟",
  "Paano ginagawa ang mga bawas?",
  "Тарҳҳо чӣ гуна анҷом дода мешаванд?",
);
const _step4Lead = _S(
  '임금명세서의 공제 항목을 참고하세요.',
  'Refer to the deduction items on your payslip.',
  '请参考工资单上的扣除项目。',
  'Hãy tham khảo các mục khấu trừ trên phiếu lương của bạn.',
  "Ish haqi varagʻingizdagi chegirma bandlariga qarang.",
  "Maaş bordronuzdaki kesinti kalemlerine bakın.",
  "आफ्नो तलब पर्चीमा कटौतीका वस्तुहरू हेर्नुहोस्।",
  "Hare'e ba item dedusaun sira iha ó-nia folha saláriu.",
  "ເບິ່ງລາຍການຫັກເງິນໃນໃບແຈ້ງເງິນເດືອນຂອງທ່ານ.",
  "Цалингийн хуудаснаас суутгалын зүйлсийг харна уу.",
  "သင်၏ လစာစာရင်းရှိ နုတ်ယူမှုအမျိုးအစားများကို ကြည့်ပါ။",
  "আপনার বেতন স্লিপে কর্তনের আইটেমগুলি দেখুন।",
  "ඔබගේ වැටුප් පත්‍රිකාවේ අඩු කිරීම් අයිතම බලන්න.",
  "Lihat item pemotongan pada slip gaji Anda.",
  "សូមមើលធាតុនៃការកាត់កងនៅលើប័ណ្ណបើកប្រាក់បៀវត្សរ៍របស់អ្នក។",
  "Эмгек акы баракчаңыздагы кемитүү пункттарын караңыз.",
  "โปรดดูรายการหักเงินในสลิปเงินเดือนของคุณ",
  "اپنی تنخواہ کی پرچی پر کٹوتی کی اشیاء دیکھیں۔",
  "Tingnan ang mga item ng bawas sa iyong payslip.",
  "Ба бандҳои тарҳ дар варақаи музди меҳнати худ назар кунед.",
);
const _taxMethodLabel = _S(
  '세금 공제 방식',
  'Tax deduction method',
  '税款扣除方式',
  'Hình thức khấu trừ thuế',
  "Soliqni ushlab qolish usuli",
  "Vergi kesintisi yöntemi",
  "कर कटौती विधि",
  "Métodu dedusaun impostu",
  "ວິທີການຫັກພາສີ",
  "Татварын суутгалын арга",
  "အခွန်နုတ်ယူမှု နည်းလမ်း",
  "কর কর্তনের পদ্ধতি",
  "බදු අඩු කිරීමේ ක්‍රමය",
  "Metode pemotongan pajak",
  "វិធីសាស្ត្រកាត់ពន្ធ",
  "Салыкты кармоо ыкмасы",
  "วิธีการหักภาษี",
  "ٹیکس کٹوتی کا طریقہ",
  "Paraan ng pagbawas ng buwis",
  "Усули тарҳи андоз",
);
const _fourInsuranceLabel = _S(
  '4대보험 가입',
  'Enrolled in the 4 major insurances',
  '加入四大保险',
  'Tham gia 4 loại bảo hiểm',
  "4 ta asosiy sugʻurtaga aʼzo boʻlgan",
  "4 ana sigortaya kayıtlı",
  "4 मुख्य बीमामा दर्ता",
  "Rejistradu iha seguru prinsipál 4",
  "ລົງທະບຽນປະກັນໄພຫຼັກ 4",
  "4 үндсэн даатгалд бүртгэлтэй",
  "4 အဓိက အာမခံတွင် မှတ်ပုံတင်ထားသည်",
  "4 প্রধান বীমার জন্য নিবন্ধিত",
  "4 ප්‍රධාන රක්ෂණයට ලියාපදිංචි වී ඇත",
  "Terdaftar di 4 asuransi utama",
  "បានចុះឈ្មោះក្នុងធានារ៉ាប់រងសំខាន់ៗទាំង 4",
  "4 негизги камсыздандырууга катталган",
  "ลงทะเบียนประกันหลัก 4 รายการ",
  "4 اہم بیمہ میں رجسٹرڈ",
  "Nakarehistro sa 4 pangunahing insurance",
  "Ба 4 суғуртаи асосӣ ба қайд гирифта шудааст",
);
const _bizTaxLabel = _S(
  '사업소득 3.3% 공제',
  'Business income 3.3% withholding',
  '扣除事业所得税3.3%',
  'Khấu trừ 3.3% thu nhập kinh doanh',
  "Biznes daromadidan 3,3% ushlab qolish",
  "İş geliri %3,3 stopaj",
  "कामको आम्दानीमा 3.3% अग्रिम कर",
  "Rendimentu servisu %3,3 retensaun impostu",
  "ການຫັກພາສີລາຍໄດ້ຈາກການເຮັດວຽກ %3,3",
  "Ажлын орлогын %3,3 суутгал",
  "အလုပ်မှရသော ဝင်ငွေ %3,3 နုတ်ယူခြင်း",
  "কর্মসংস্থান আয়ের উপর %3,3 উইথহোল্ডিং ট্যাক্স",
  "රැකියා ආදායම 3,3% බදු අඩු කිරීම",
  "Penahanan pajak penghasilan kerja 3,3%",
  "ប្រាក់ចំណូលការងារកាត់ទុក 3,3%",
  "Иш кирешесинен %3,3 кармоо",
  "หักภาษี ณ ที่จ่ายจากรายได้จากการทำงาน 3,3%",
  "ملازمت کی آمدنی پر %3,3 ودہولڈنگ ٹیکس",
  "Pagbawas ng buwis sa kita ng trabaho na 3,3%",
  "Даромади корӣ 3,3% андозбандии пешакӣ",
);
const _noTaxLabel = _S(
  '세금 미공제 (그대로 수령)',
  'No tax withheld (received as is)',
  '未扣税（原样领取）',
  'Không khấu trừ thuế (nhận nguyên)',
  "Soliq ushlab qolinmagan (oʻz holicha olingan)",
  "Vergi kesintisi yok (olduğu gibi alındı)",
  "कर कटौती छैन (जस्तो छ त्यस्तै प्राप्त भयो)",
  "La iha dedusaun impostu (simu hanesan ne'e)",
  "ບໍ່ມີການຫັກພາສີ (ໄດ້ຮັບຕາມຕົວຈິງ)",
  "Татварын суутгал байхгүй (байгаагаар нь авсан)",
  "အခွန်နုတ်ယူခြင်း မရှိပါ (အတိုင်းအတာအတိုင်း ရရှိသည်)",
  "কোনো কর কর্তন নেই (যেমন আছে তেমনই নেওয়া হয়েছে)",
  "බදු අඩු කිරීමක් නැත (ලැබුණු පරිදි)",
  "Tidak ada pemotongan pajak (diterima apa adanya)",
  "គ្មានការកាត់ពន្ធ (បានទទួលដូចដើម)",
  "Салык кармалбайт (кандай болсо ошондой алынган)",
  "ไม่มีการหักภาษี (ได้รับตามจริง)",
  "کوئی ٹیکس کٹوتی نہیں (جیسا کہ وصول کیا گیا)",
  "Walang bawas sa buwis (natanggap nang buo)",
  "Тарҳи андоз нест (чунон ки гирифта шудааст)",
);
const _roomDeductLabel = _S(
  '숙식비 공제',
  'Room & board deduction',
  '食宿费扣除',
  'Khấu trừ tiền ăn ở',
  "Yotoqxona va ovqatlanish uchun chegirma",
  "Oda ve yemek kesintisi",
  "कोठा र खाना कटौती",
  "Dedusaun kuartu no hahán",
  "ການຫັກຄ່າຫ້ອງ ແລະ ຄ່າອາຫານ",
  "Байр, хоолны суутгал",
  "အခန်းနှင့် အစားအသောက် နုတ်ယူခြင်း",
  "আবাসন এবং খাবার কর্তন",
  "නවාතැන් සහ ආහාර අඩු කිරීම",
  "Pemotongan kamar dan makan",
  "ការកាត់កងថ្លៃបន្ទប់ និងអាហារ",
  "Жатакана жана тамак-аш үчүн кемитүү",
  "การหักค่าที่พักและอาหาร",
  "رہائش اور کھانے کی کٹوتی",
  "Bawas para sa tirahan at pagkain",
  "Тарҳи манзил ва хӯрокворӣ",
);
const _roomToggle = _S(
  '숙식비를 공제하고 있습니다',
  'Room & board is being deducted',
  '正在扣除食宿费',
  'Đang khấu trừ tiền ăn ở',
  "Yotoqxona va ovqatlanish uchun chegirma qilinmoqda",
  "Konaklama ve yemek ücreti kesiliyor",
  "आवास र खाना शुल्क कटौती गरिन्छ",
  "Kustu akomodasaun no hahán deduzidu",
  "ຄ່າທີ່ພັກ ແລະ ຄ່າອາຫານຖືກຫັກ",
  "Байр, хоолны төлбөр суутгагдсан",
  "နေထိုင်ခွင့်နှင့် အစားအသောက်အတွက် ကုန်ကျစရိတ်ကို နုတ်ယူသည်",
  "আবাসন এবং খাবারের খরচ কাটা হয়",
  "නවාතැන් සහ ආහාර සඳහා ගාස්තු අඩු කරනු ලැබේ",
  "Biaya akomodasi dan makan dipotong",
  "ថ្លៃស្នាក់នៅ និងអាហារត្រូវបានកាត់កង",
  "Жатакана жана тамак-аш үчүн акы кармалат",
  "มีการหักค่าที่พักและอาหาร",
  "رہائش اور کھانے کی فیس کاٹی جاتی ہے",
  "Binabawasan ang bayad sa tirahan at pagkain",
  "Пардохти манзил ва хӯрокворӣ тарҳ карда мешавад",
);
const _roomDeductTotalLabel = _S(
  '숙식비 공제 총액',
  'Total room & board deduction',
  '食宿费扣除总额',
  'Tổng tiền khấu trừ ăn ở',
  "Yotoqxona va ovqatlanish uchun jami chegirma",
  "Toplam konaklama ve yemek kesintisi",
  "कुल आवास र खाना कटौती",
  "Total dedusaun akomodasaun no hahán",
  "ການຫັກຄ່າທີ່ພັກ ແລະ ຄ່າອາຫານລວມ",
  "Нийт байр, хоолны суутгал",
  "စုစုပေါင်း နေထိုင်ခွင့်နှင့် အစားအသောက် နုတ်ယူမှု",
  "মোট আবাসন এবং খাবার কর্তন",
  "මුළු නවාතැන් සහ ආහාර අඩු කිරීම",
  "Total pemotongan akomodasi dan makan",
  "ការកាត់កងថ្លៃស្នាក់នៅ និងអាហារសរុប",
  "Жатакана жана тамак-аш үчүн жалпы кемитүү",
  "ยอดรวมการหักค่าที่พักและอาหาร",
  "رہائش اور کھانے کی کل کٹوتی",
  "Kabuuang bawas para sa tirahan at pagkain",
  "Ҳаҷми умумии тарҳи манзил ва хӯрокворӣ",
);
const _roomTypeLabel = _S(
  '숙식 제공 형태',
  'Type of room & board provided',
  '食宿提供形式',
  'Hình thức cung cấp ăn ở',
  "Taʼminlangan yotoqxona va ovqatlanish turi",
  "Sağlanan konaklama ve yemek türü",
  "प्रदान गरिएको आवास र खानाको प्रकार",
  "Tipu akomodasaun no hahán ne'ebé fornese",
  "ປະເພດທີ່ພັກ ແລະ ອາຫານທີ່ໄດ້ຮັບ",
  "Олгосон байр, хоолны төрөл",
  "ပေးအပ်ထားသော နေထိုင်ခွင့်နှင့် အစားအသောက် အမျိုးအစား",
  "প্রদত্ত আবাসন এবং খাবারের ধরন",
  "ලබා දෙන නවාතැන් සහ ආහාර වර්ගය",
  "Jenis akomodasi dan makan yang disediakan",
  "ប្រភេទកន្លែងស្នាក់នៅ និងអាហារដែលបានផ្តល់",
  "Берилген жатакана жана тамак-аштын түрү",
  "ประเภทของที่พักและอาหารที่จัดให้",
  "فراہم کردہ رہائش اور کھانے کی قسم",
  "Uri ng tirahan at pagkain na ibinigay",
  "Навъи манзил ва хӯроки таъминшуда",
);
const _dormLabel = _S(
  '기숙사',
  'Dormitory',
  '宿舍',
  'Ký túc xá',
  "Yotoqxona",
  "Yurt",
  "छात्रावास",
  "Dormitóriu",
  "ຫໍພັກ",
  "Дотуур байр",
  "အဆောင်",
  "ডরমিটরি",
  "නේවාසිකාගාරය",
  "Asrama",
  "អន្តេវាសិកដ្ឋាន",
  "Жатакана",
  "หอพัก",
  "ڈارمیٹری",
  "Dormitoryo",
  "Хобгоҳ",
);
const _studioLabel = _S(
  '원룸·주택',
  'Studio/House',
  '单间房·住宅',
  'Phòng trọ/Nhà ở',
  "Studiya/Uy",
  "Stüdyo/Ev",
  "स्टुडियो/घर",
  "Estúdiu/Uma",
  "ຫ້ອງສະຕູດິໂອ/ເຮືອນ",
  "Студи/Байшин",
  "စတူဒီယို/အိမ်",
  "স্টুডিও/বাড়ি",
  "ස්ටුඩියෝ/නිවස",
  "Studio/Rumah",
  "ស្ទូឌីយោ/ផ្ទះ",
  "Студия/Үй",
  "สตูดิโอ/บ้าน",
  "اسٹوڈیو/گھر",
  "Studio/Bahay",
  "Студия/Хона",
);
const _mealLabel = _S(
  '식사만',
  'Meals only',
  '仅供餐',
  'Chỉ ăn',
  "Faqat ovqat",
  "Sadece yemek",
  "केवल खाना",
  "Hahán de'it",
  "ສະເພາະອາຫານ",
  "Зөвхөн хоол",
  "အစားအသောက်သာ",
  "শুধুমাত্র খাবার",
  "ආහාර පමණි",
  "Hanya makan",
  "អាហារតែប៉ុណ្ណោះ",
  "Жөн гана тамак-аш",
  "เฉพาะอาหาร",
  "صرف کھانا",
  "Pagkain lamang",
  "Танҳо хӯрок",
);
const _roomBelowMinTitle = _S(
  '⚠ 숙식비를 빼면 최저임금 아래로 내려갑니다',
  '⚠ Falls below minimum wage after room & board deduction',
  '⚠ 扣除食宿费后低于最低工资',
  '⚠ Sau khi khấu trừ tiền ăn ở sẽ thấp hơn lương tối thiểu',
  "⚠ Turar joy va ovqatlanish uchun ushlab qolinganidan keyin eng kam ish haqidan past",
  "⚠ Konaklama ve yemek kesintisinden sonra asgari ücretin altına düşüyor",
  "⚠ आवास र खाना कटौती पछि न्यूनतम ज्याला भन्दा कम हुन्छ",
  "⚠ Depois dedusaun akomodasaun no hahán, tun ba menus husi saláriu mínimu",
  "⚠ ຫຼັງຈາກການຫັກຄ່າທີ່ພັກ ແລະ ຄ່າອາຫານ, ຕໍ່າກວ່າຄ່າແຮງງານຂັ້ນຕໍ່າ",
  "⚠ Байр, хоолны суутгалын дараа хамгийн бага цалингаас доош орсон",
  "⚠ နေထိုင်ခွင့်နှင့် အစားအသောက် နုတ်ယူပြီးနောက် အနိမ့်ဆုံးလစာအောက်သို့ ကျဆင်းသွားသည်",
  "⚠ আবাসন এবং খাবার কর্তনের পরে ন্যূনতম মজুরির নিচে নেমে যায়",
  "⚠ නවාතැන් සහ ආහාර අඩු කිරීමෙන් පසු අවම වැටුපට වඩා අඩු වේ",
  "⚠ Setelah pemotongan akomodasi dan makan, gaji menjadi di bawah upah minimum",
  "⚠ ធ្លាក់ចុះក្រោមប្រាក់ឈ្នួលអប្បបរមា បន្ទាប់ពីកាត់កងថ្លៃស្នាក់នៅ និងអាហារ",
  "⚠ Жатакана жана тамак-аш үчүн кемитүүдөн кийин минималдуу эмгек акыдан төмөн түшөт",
  "⚠ หลังหักค่าที่พักและอาหารแล้ว ต่ำกว่าค่าแรงขั้นต่ำ",
  "⚠ رہائش اور کھانے کی کٹوتی کے بعد کم از کم اجرت سے کم ہو جاتا ہے",
  "⚠ Bumaba sa minimum na sahod pagkatapos ng bawas para sa tirahan at pagkain",
  "⚠ Пас аз тарҳи манзил ва хӯрокворӣ аз музди меҳнати ҳадди ақал камтар мешавад",
);

const _step5Title = _S(
  '실제로 받으신 금액을 적어주세요',
  'Please enter the amount you actually received',
  '请填写您实际收到的金额',
  'Vui lòng nhập số tiền bạn đã thực nhận',
  "Iltimos, haqiqatda olgan miqdorni kiriting",
  "Lütfen fiilen aldığınız tutarı girin",
  "कृपया तपाईंले वास्तवमा प्राप्त गरेको रकम प्रविष्ट गर्नुहोस्",
  "Favor hatama montante ne'ebé ó simu duni",
  "ກະລຸນາປ້ອນຈໍານວນເງິນທີ່ທ່ານໄດ້ຮັບຕົວຈິງ",
  "Таны бодитоор авсан дүнг оруулна уу",
  "ကျေးဇူးပြု၍ သင်အမှန်တကယ် ရရှိခဲ့သော ပမာဏကို ထည့်သွင်းပါ။",
  "অনুগ্রহ করে আপনি যে পরিমাণ অর্থ পেয়েছেন তা লিখুন",
  "කරුණාකර ඔබට සැබවින්ම ලැබුණු මුදල ඇතුළත් කරන්න",
  "Mohon masukkan jumlah yang benar-benar Anda terima",
  "សូមបញ្ចូលចំនួនទឹកប្រាក់ដែលអ្នកបានទទួលជាក់ស្តែង",
  "Сураныч, иш жүзүндө алган суммаңызды киргизиңиз",
  "โปรดระบุจำนวนเงินที่คุณได้รับจริง",
  "براہ کرم وہ رقم درج کریں جو آپ نے اصل میں وصول کی ہے",
  "Pakipasok ang aktwal na halagang natanggap mo",
  "Лутфан, маблағи воқеан гирифтаатонро ворид кунед",
);
const _step5Lead = _S(
  '계산 결과와 실제 통장 입금액을 대조합니다.',
  'We compare the calculated result with the actual bank deposit amount.',
  '将计算结果与实际银行存款金额进行对照。',
  'Chúng tôi đối chiếu kết quả tính toán với số tiền thực nhận vào tài khoản.',
  "Biz hisoblangan natijani bankka haqiqatda qoʻyilgan summa bilan solishtiramiz.",
  "Hesaplanan sonucu, bankaya fiilen yatırılan tutarla karşılaştırıyoruz.",
  "हामी गणना गरिएको परिणामलाई बैंकमा वास्तवमा जम्मा गरिएको रकमसँग तुलना गर्छौं।",
  "Ami kompara rezultadu kalkuladu ho montante ne'ebé depozita duni iha banku.",
  "ພວກເຮົາປຽບທຽບຜົນການຄິດໄລ່ ກັບຈໍານວນເງິນທີ່ຖືກໂອນເຂົ້າບັນຊີທະນາຄານຕົວຈິງ.",
  "Бид тооцоолсон үр дүнг банкинд бодитоор шилжүүлсэн дүнтэй харьцуулна.",
  "ကျွန်ုပ်တို့သည် တွက်ချက်ထားသော ရလဒ်ကို ဘဏ်သို့ အမှန်တကယ် လွှဲပြောင်းပေးခဲ့သော ပမာဏနှင့် နှိုင်းယှဉ်ပါသည်။",
  "আমরা গণনা করা ফলাফলকে ব্যাঙ্কে প্রকৃত জমা করা পরিমাণের সাথে তুলনা করি।",
  "අපි ගණනය කළ ප්‍රතිඵලය බැංකුවට සැබවින්ම තැන්පත් කළ මුදල සමඟ සසඳමු.",
  "Kami membandingkan hasil yang dihitung dengan jumlah yang sebenarnya disetorkan ke bank.",
  "យើងប្រៀបធៀបលទ្ធផលដែលបានគណនាជាមួយនឹងចំនួនទឹកប្រាក់ដែលបានដាក់ចូលធនាគារជាក់ស្តែង។",
  "Биз эсептелген натыйжаны банкка иш жүзүндө которулган сумма менен салыштырабыз.",
  "เราจะเปรียบเทียบผลการคำนวณกับจำนวนเงินที่โอนเข้าธนาคารจริง",
  "ہم حسابی نتیجے کا موازنہ بینک میں اصل میں جمع کی گئی رقم سے کرتے ہیں۔",
  "Ikinukumpara namin ang kinakalkulang resulta sa aktwal na halagang idineposito sa bangko.",
  "Мо натиҷаи ҳисобшударо бо маблағи воқеан ба бонк гузаронидашуда муқоиса мекунем.",
);
const _periodNoticeTitle = _S(
  '기간 대조 안내 (필독)',
  'Period comparison notice (please read)',
  '期间对照说明（必读）',
  'Lưu ý đối chiếu kỳ (vui lòng đọc)',
  "Davrni solishtirish haqida bildirishnoma (iltimos, oʻqing)",
  "Dönem karşılaştırma bildirimi (lütfen okuyun)",
  "अवधि तुलना सूचना (कृपया पढ्नुहोस्)",
  "Notifikasaun komparasaun períodu (favor lee)",
  "ການແຈ້ງເຕືອນການປຽບທຽບໄລຍະເວລາ (ກະລຸນາອ່ານ)",
  "Хугацааны харьцуулалтын мэдэгдэл (уншина уу)",
  "ကာလနှိုင်းယှဉ်မှု အသိပေးချက် (ဖတ်ရှုပါ)",
  "সময়কাল তুলনা বিজ্ঞপ্তি (অনুগ্রহ করে পড়ুন)",
  "කාලසීමා සංසන්දනය කිරීමේ දැනුම්දීම (කරුණාකර කියවන්න)",
  "Pemberitahuan perbandingan periode (harap baca)",
  "សេចក្ដីជូនដំណឹងប្រៀបធៀបរយៈពេល (សូមអាន)",
  "Мезгилди салыштыруу билдирүүсү (окуп коюңуз)",
  "การแจ้งเตือนการเปรียบเทียบช่วงเวลา (โปรดอ่าน)",
  "مدت کے موازنے کا نوٹیفکیشن (براہ کرم پڑھیں)",
  "Abiso sa paghahambing ng panahon (pakibasa)",
  "Огоҳиномаи муқоисаи давра (лутфан хонед)",
);
const _totalReceivedLabel = _S(
  '실제 받은 돈 총액',
  'Total amount actually received',
  '实际收到金额总计',
  'Tổng số tiền thực nhận',
  "Haqiqatda olingan umumiy summa",
  "Fiilen alınan toplam tutar",
  "वास्तवमा प्राप्त भएको कुल रकम",
  "Montante totál ne'ebé simu duni",
  "ຈຳນວນເງິນທັງໝົດທີ່ໄດ້ຮັບຕົວຈິງ",
  "Бодитоор авсан нийт дүн",
  "လက်တွေ့ရရှိသော စုစုပေါင်းပမာဏ",
  "প্রকৃতপক্ষে প্রাপ্ত মোট পরিমাণ",
  "සැබවින්ම ලැබුණු මුළු මුදල",
  "Jumlah total yang benar-benar diterima",
  "ចំនួនទឹកប្រាក់សរុបដែលបានទទួលជាក់ស្តែង",
  "Иш жүзүндө алынган жалпы сумма",
  "จำนวนเงินรวมที่ได้รับจริง",
  "اصل میں وصول کی گئی کل رقم",
  "Aktwal na kabuuang halagang natanggap",
  "Маблағи умумии воқеан гирифташуда",
);
const _zeroButtonLabel = _S(
  '0원 (전액 미지급)',
  '0 KRW (fully unpaid)',
  '0韩元（全部未支付）',
  '0 KRW (chưa trả toàn bộ)',
  "0 KRW (toʻliq toʻlanmagan)",
  "0 KRW (tamamen ödenmemiş)",
  "0 KRW (पूर्ण रूपमा भुक्तान नगरिएको)",
  "0 KRW (seidauk selu hotu)",
  "0 ວອນ (ຍັງບໍ່ໄດ້ຈ່າຍຄົບ)",
  "0 KRW (бүрэн төлөгдөөгүй)",
  "0 KRW (အပြည့်အဝ မပေးချေရသေးပါ)",
  "0 KRW (সম্পূর্ণ অপরিশোধিত)",
  "0 KRW (සම්පූර්ණයෙන් නොගෙවා ඇත)",
  "0 KRW (belum dibayar penuh)",
  "0 វ៉ុនកូរ៉េ (មិនទាន់បានបង់ពេញលេញ)",
  "0 KRW (толугу менен төлөнбөгөн)",
  "0 วอน (ยังไม่ได้รับชำระเต็มจำนวน)",
  "0 KRW (مکمل طور پر ادا نہیں کی گئی)",
  "0 KRW (hindi pa nababayaran nang buo)",
  "0 KRW (пурра пардохтнашуда)",
);

class _WageCalculatorScreenState extends State<WageCalculatorScreen> {
  static const _totalSteps = 5;
  int _step = 0;
  bool _showResult = false;

  PeriodMode _periodMode = PeriodMode.month;
  VisaChoice _visa = VisaChoice.e9;
  PayType _payType = PayType.hour;
  BizSize _size = BizSize.over5;
  TaxMethod _tax = TaxMethod.four;
  RoomType _roomType = RoomType.dorm;
  bool _absent = false;
  bool _roomOn = false;

  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime? _hireDate;
  DateTime? _leaveDate;

  late final _payCtrl = TextEditingController(
    text: minWage().$1.toStringAsFixed(0),
  );
  final _fixedMonthCtrl = TextEditingController(text: '1');
  final _dailyHoursCtrl = TextEditingController(text: '8');
  final _dayCountTotalCtrl = TextEditingController(text: '22');
  final _weekHoursCtrl = TextEditingController(text: '40');
  final _otCtrl = TextEditingController(text: '0');
  final _nightCtrl = TextEditingController(text: '0');
  final _holCtrl = TextEditingController(text: '0');
  final _multiMonthsCtrl = TextEditingController(text: '3');
  final _bonus1yCtrl = TextEditingController(text: '0');
  final _vacation1yCtrl = TextEditingController(text: '0');
  final _roomAmtCtrl = TextEditingController(text: '0');
  final _receivedCtrl = TextEditingController(text: '0');
  final _visaCustomCtrl = TextEditingController(text: '');

  @override
  void dispose() {
    for (final c in [
      _payCtrl,
      _fixedMonthCtrl,
      _dailyHoursCtrl,
      _dayCountTotalCtrl,
      _weekHoursCtrl,
      _otCtrl,
      _nightCtrl,
      _holCtrl,
      _multiMonthsCtrl,
      _bonus1yCtrl,
      _vacation1yCtrl,
      _roomAmtCtrl,
      _receivedCtrl,
      _visaCustomCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  double _num(TextEditingController c) => double.tryParse(c.text) ?? 0;

  WageCalcInput _buildInput() {
    return WageCalcInput(
      periodMode: _periodMode,
      multiMonths: _num(_multiMonthsCtrl),
      rangeStart: _rangeStart,
      rangeEnd: _rangeEnd,
      visa: _visa,
      visaCustom: _visaCustomCtrl.text,
      payType: _payType,
      pay: _num(_payCtrl),
      dailyHours: _num(_dailyHoursCtrl),
      dayCountTotal: _num(_dayCountTotalCtrl),
      weekHours: _num(_weekHoursCtrl),
      otH: _num(_otCtrl),
      nightH: _num(_nightCtrl),
      holH: _num(_holCtrl),
      hireDate: _hireDate,
      leaveDate: _leaveDate,
      absent: _absent,
      bonus1y: _num(_bonus1yCtrl),
      vacation1y: _num(_vacation1yCtrl),
      size: _size,
      tax: _tax,
      roomOn: _roomOn,
      roomAmtTotal: _num(_roomAmtCtrl),
      roomType: _roomType,
      received: _num(_receivedCtrl),
    );
  }

  void _openHelp(String key, AppLanguage lang) {
    final entry = buildHelpDict(lang)[key];
    if (entry == null) return;
    showWageHelp(context, entry.title, entry.body(context), lang);
  }

  void _setPayType(PayType type) {
    setState(() {
      _payType = type;
      _payCtrl.text = switch (type) {
        PayType.hour => minWage().$1.toStringAsFixed(0),
        PayType.day => '90000',
        PayType.week => '400000',
        PayType.year => '26000000',
        PayType.month => '2200000',
      };
    });
  }

  void _importFromWorklog(AppLanguage lang) {
    setState(() {
      _payType = PayType.hour;
      _payCtrl.text = minWage().$1.toStringAsFixed(0);
      _weekHoursCtrl.text = '40';
      _otCtrl.text = '12';
      _nightCtrl.text = '6';
      _holCtrl.text = '0';
      _hireDate ??= DateTime(2024, 3, 2);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_worklogSnack.of(lang))));
  }

  void _importFromPayslip(AppLanguage lang) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_payslipSnack.of(lang))));
  }

  void _goNext() {
    if (_step < _totalSteps - 1) {
      setState(() => _step++);
    } else {
      setState(() => _showResult = true);
    }
  }

  void _goPrev() {
    if (_showResult) {
      setState(() => _showResult = false);
    } else if (_step > 0) {
      setState(() => _step--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = UserProfileScope.of(context).language;
    final input = _buildInput();
    final result = _showResult ? calcWage(input) : null;

    return Scaffold(
      appBar: AppBar(title: Text(_appBarTitle.of(lang))),
      body: Column(
        children: [
          _StepHeader(
            stepIndex: _step,
            totalSteps: _totalSteps,
            resultMode: _showResult,
            language: lang,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _showResult
                  ? WageResultCard(
                      input: input,
                      result: result!,
                      language: lang,
                      onOpenWageNavigator: widget.onUseResult != null
                          ? () {
                              widget.onUseResult!(input);
                              Navigator.of(context).pop();
                            }
                          : () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const WageNavigatorScreen(),
                              ),
                            ),
                      onFindNearbyOrgs: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(_findOrgsSnack.of(lang))),
                          ),
                    )
                  : _buildStepBody(input, lang),
            ),
          ),
          _StepFooter(
            resultMode: _showResult,
            showPrev: _step > 0,
            nextLabel: _step == _totalSteps - 1
                ? _calcLabel.of(lang)
                : _nextLabel.of(lang),
            prevLabel: _prevLabel.of(lang),
            editValuesLabel: _editValuesLabel.of(lang),
            onPrev: _goPrev,
            onNext: _goNext,
          ),
        ],
      ),
    );
  }

  Widget _buildStepBody(WageCalcInput input, AppLanguage lang) {
    switch (_step) {
      case 0:
        return _buildStep1(lang);
      case 1:
        return _buildStep2(lang);
      case 2:
        return _buildStep3(lang);
      case 3:
        return _buildStep4(input, lang);
      default:
        return _buildStep5(input, lang);
    }
  }

  // ---------- STEP 1 · 확인 기간 및 임금/사업장 조건 ----------
  Widget _buildStep1(AppLanguage lang) {
    final belowMin =
        _payType == PayType.hour &&
        _num(_payCtrl) > 0 &&
        _num(_payCtrl) < minWage().$1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            ImportButton(
              label: _importWorklog.of(lang),
              onTap: () => _importFromWorklog(lang),
            ),
            const SizedBox(width: 7),
            ImportButton(
              label: _importPayslip.of(lang),
              onTap: () => _importFromPayslip(lang),
            ),
          ],
        ),
        const SizedBox(height: 12),

        SectionH4(title: _step1Title1.of(lang), lead: _step1Lead1.of(lang)),
        Seg<PeriodMode>(
          options: [
            (_segMonthOnly.of(lang), PeriodMode.month),
            (_segMultiUnpaid.of(lang), PeriodMode.multi),
            (_segRangeCustom.of(lang), PeriodMode.range),
          ],
          value: _periodMode,
          onChanged: (v) => setState(() => _periodMode = v),
        ),
        if (_periodMode == PeriodMode.month)
          FGroup(
            children: [
              FRow(
                label: _unpaidMonthsLabel.of(lang),
                controller: _fixedMonthCtrl,
                unit: _monthUnit.of(lang),
                readOnly: true,
                help: () => _openHelp('pm_month', lang),
              ),
            ],
          )
        else if (_periodMode == PeriodMode.multi)
          FGroup(
            children: [
              FRow(
                label: _unpaidMonthsLabel.of(lang),
                controller: _multiMonthsCtrl,
                unit: _monthUnit.of(lang),
                help: () => _openHelp('pm_multi', lang),
              ),
            ],
          )
        else
          FGroup(
            title: _rangeTitle.of(lang),
            help: () => _openHelp('pm_range', lang),
            children: [
              FDateRow(
                label: _startMonthLabel.of(lang),
                value: _rangeStart,
                monthOnly: true,
                placeholder: _selectPlaceholder.of(lang),
                onPick: (d) =>
                    setState(() => _rangeStart = DateTime(d.year, d.month, 1)),
              ),
              FDateRow(
                label: _endMonthLabel.of(lang),
                value: _rangeEnd,
                monthOnly: true,
                placeholder: _selectPlaceholder.of(lang),
                onPick: (d) =>
                    setState(() => _rangeEnd = DateTime(d.year, d.month, 1)),
              ),
            ],
          ),

        SectionH4(
          title: _step1Title2.of(lang),
          lead: _step1Lead2.of(lang),
          topGap: 4,
        ),
        FGroup(
          title: _visaLabel.of(lang),
          children: [
            Chips<VisaChoice>(
              compact: true,
              options: VisaChoice.values
                  .map((v) => (v.labelOf(lang), v))
                  .toList(),
              value: _visa,
              onChanged: (v) => setState(() => _visa = v),
            ),
            if (_visa == VisaChoice.etc) ...[
              const SizedBox(height: 6),
              FRow(
                label: _visaCustomLabel.of(lang),
                controller: _visaCustomCtrl,
              ),
            ],
          ],
        ),

        InkWell(
          onTap: () => setState(() {
            _payType = PayType.hour;
            _payCtrl.text = minWage().$1.toStringAsFixed(0);
          }),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            margin: const EdgeInsets.only(bottom: 11),
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    '⚖ $wageCalcYear ${_minWageButtonSuffix(lang)} (${formatWon(minWage().$1, lang)})',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2196F3),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                QMark(onTap: () => _openHelp('minw', lang)),
              ],
            ),
          ),
        ),

        FGroup(
          title: _payMethodLabel.of(lang),
          children: [
            Seg<PayType>(
              options: [
                (_hourLabel.of(lang), PayType.hour),
                (_dayLabel.of(lang), PayType.day),
                (_weekLabel.of(lang), PayType.week),
              ],
              value: _payType,
              onChanged: _setPayType,
            ),
            Seg<PayType>(
              options: [
                (_monthLabel.of(lang), PayType.month),
                (_yearLabel.of(lang), PayType.year),
              ],
              value: _payType,
              onChanged: _setPayType,
            ),
            FRow(
              label: _payAmountLabel(_payType, lang),
              controller: _payCtrl,
              unit: _wonUnit.of(lang),
            ),
            if (_payType == PayType.day) ...[
              FRow(
                label: _dailyHoursLabel.of(lang),
                controller: _dailyHoursCtrl,
                unit: _hourUnit.of(lang),
              ),
              FRow(
                label: _totalWorkDaysLabel.of(lang),
                controller: _dayCountTotalCtrl,
                unit: _dayUnit.of(lang),
              ),
            ],
          ],
        ),

        if (belowMin)
          RedNotice(title: _belowMinTitle.of(lang), body: _belowMinBody(lang)),

        FGroup(
          title: _bizSizeLabel.of(lang),
          help: () => _openHelp('biz_size', lang),
          children: [
            OptButton(
              icon: '🏢',
              title: _over5Label.of(lang),
              selected: _size == BizSize.over5,
              onTap: () => setState(() => _size = BizSize.over5),
            ),
            OptButton(
              icon: '🏠',
              title: _under5Label.of(lang),
              selected: _size == BizSize.under5,
              onTap: () => setState(() => _size = BizSize.under5),
            ),
            OptButton(
              icon: '❓',
              title: _unknownLabel.of(lang),
              selected: _size == BizSize.unknown,
              onTap: () => setState(() => _size = BizSize.unknown),
            ),
          ],
        ),
      ],
    );
  }

  String _minWageButtonSuffix(AppLanguage lang) => switch (lang) {
    AppLanguage.ko => '년 최저임금 넣기',
    AppLanguage.uz => "eng kam ish haqi",
    AppLanguage.en => 'minimum wage',
    AppLanguage.tr => "asgari ücret",
    AppLanguage.tg => "музди меҳнати ҳадди ақал",
    AppLanguage.fil => "minimum na sahod",
    AppLanguage.ur => "کم از کم اجرت",
    AppLanguage.th => "ค่าแรงขั้นต่ำ",
    AppLanguage.ky => "минималдуу эмгек акы",
    AppLanguage.km => "ប្រាក់ឈ្នួលអប្បបរមា",
    AppLanguage.id => "Upah minimum",
    AppLanguage.si => "අවම වැටුප",
    AppLanguage.bn => "সর্বনিম্ন মজুরি",
    AppLanguage.my => "အနိမ့်ဆုံးလုပ်ခ",
    AppLanguage.mn => "Хамгийн бага цалин",
    AppLanguage.lo => "ຄ່າແຮງງານຂັ້ນຕ່ຳ",
    AppLanguage.tet => "saláriu mínimu",
    AppLanguage.ne => "न्यूनतम ज्याला",
    AppLanguage.zh => '年最低工资',
    AppLanguage.vi => 'lương tối thiểu năm',
  };

  String _belowMinBody(AppLanguage lang) {
    final pay = formatWon(_num(_payCtrl), lang);
    final mw = formatWon(minWage().$1, lang);
    return switch (lang) {
      AppLanguage.ko =>
        '계약된 시급 $pay이 $wageCalcYear년 최저임금 $mw보다 낮아요. 미달분은 무효이며 차액을 청구할 수 있습니다.',
      AppLanguage.uz =>
        "Sizning shartnoma boʻyicha soatlik ish haqingiz $pay, eng kam ish haqi $mw boʻlgan $wageCalcYear dan past. Kamchilik haqiqiy emas va siz farqni talab qilishingiz mumkin.",
      AppLanguage.en =>
        'Your contracted hourly wage of $pay is lower than the $wageCalcYear minimum wage of $mw. The shortfall is invalid and you can claim the difference.',
      AppLanguage.tr =>
        "Sözleşmeli saatlik ücretiniz olan $pay, $wageCalcYear asgari ücreti olan $mw'den düşüktür. Bu eksiklik geçersizdir ve farkı talep edebilirsiniz.",
      AppLanguage.tg =>
        "Музди меҳнати соатии шартномавии шумо $pay аз музди меҳнати ҳадди ақали $wageCalcYear, ки $mw аст, камтар аст. Ин камбудӣ беэътибор аст ва шумо метавонед фарқиятро талаб кунед.",
      AppLanguage.fil =>
        "Ang iyong kinontratang orasang sahod na $pay ay mas mababa kaysa sa minimum na sahod na $mw para sa $wageCalcYear. Ang kakulangang ito ay hindi balido at maaari mong hingin ang pagkakaiba.",
      AppLanguage.ur =>
        "آپ کی معاہدہ شدہ فی گھنٹہ اجرت $pay ہے، جو کہ $wageCalcYear کی کم از کم اجرت $mw سے کم ہے۔ یہ کمی غلط ہے اور آپ فرق کا دعویٰ کر سکتے ہیں۔",
      AppLanguage.th =>
        "ค่าจ้างรายชั่วโมงตามสัญญาของคุณคือ $pay ซึ่งต่ำกว่าค่าแรงขั้นต่ำของปี $wageCalcYear ที่ $mw การขาดแคลนนี้ไม่ถูกต้องและคุณสามารถเรียกร้องส่วนต่างได้",
      AppLanguage.ky =>
        "Сиздин келишимдик сааттык эмгек акыңыз $pay, $wageCalcYear минималдуу эмгек акысы $mw'ден төмөн. Бул кемчилик жараксыз жана сиз айырманы талап кыла аласыз.",
      AppLanguage.km =>
        "ប្រាក់ឈ្នួលម៉ោងតាមកិច្ចសន្យារបស់អ្នកគឺ $pay ដែលទាបជាងប្រាក់ឈ្នួលអប្បបរមារបស់ $wageCalcYear គឺ $mw។ កង្វះខាតនេះគឺមិនត្រឹមត្រូវទេ ហើយអ្នកអាចទាមទារសំណងបាន។",
      AppLanguage.id =>
        "Upah per jam yang Anda sepakati, yaitu $pay, lebih rendah dari upah minimum $wageCalcYear sebesar $mw. Kekurangan ini tidak sah, dan Anda dapat mengklaim selisihnya.",
      AppLanguage.si =>
        "ඔබගේ කොන්ත්‍රාත්තුගත පැයක වැටුප වන $pay යනු $wageCalcYear අවම වැටුප වන $mw ට වඩා අඩුය. මෙම ඌනතාවය වලංගු නොවන අතර ඔබට වෙනස ඉල්ලා සිටිය හැක.",
      AppLanguage.bn =>
        "আপনার চুক্তিবদ্ধ প্রতি ঘণ্টার মজুরি $pay হলো $wageCalcYear এর সর্বনিম্ন মজুরি $mw এর চেয়ে কম। এই ঘাটতি অবৈধ এবং আপনি এর পার্থক্য দাবি করতে পারেন।",
      AppLanguage.my =>
        "သင်၏စာချုပ်ပါ နာရီလုပ်ခ $pay သည် $wageCalcYear ၏ အနိမ့်ဆုံးလုပ်ခ $mw ထက် နည်းနေပါသည်။ ဤကွာဟချက်သည် တရားမဝင်ပါ၊ ထို့ကြောင့် သင်သည် ကွာခြားချက်ကို တောင်းဆိုနိုင်ပါသည်။",
      AppLanguage.mn =>
        "Таны гэрээт цагийн хөлс болох $pay нь $wageCalcYear оны хамгийн бага цалин болох $mw-оос бага байна. Энэ дутагдал нь хүчингүй бөгөөд та зөрүүг нэхэмжлэх боломжтой.",
      AppLanguage.lo =>
        "ຄ່າແຮງງານລາຍຊົ່ວໂມງຕາມສັນຍາຂອງທ່ານແມ່ນ $pay ຕ່ຳກວ່າຄ່າແຮງງານຂັ້ນຕ່ຳຂອງປີ $wageCalcYear ເຊິ່ງແມ່ນ $mw. ການຂາດດຸນນີ້ແມ່ນບໍ່ຖືກຕ້ອງ ແລະທ່ານສາມາດຮຽກຮ້ອງສ່ວນຕ່າງໄດ້.",
      AppLanguage.tet =>
        "Ó nia saláriu oras nian ne'ebé kontratu mak $pay, ki'ik liu fali saláriu mínimu $wageCalcYear nian, ne'ebé mak $mw. Falta ida-ne'e la válidu no ó bele husu atu selu diferensa.",
      AppLanguage.ne =>
        "तपाईंको अनुबन्धित प्रतिघण्टा ज्याला $pay, $wageCalcYear को न्यूनतम ज्याला $mw भन्दा कम छ। यो कमी अमान्य छ र तपाईंले फरक रकम दाबी गर्न सक्नुहुन्छ।",
      AppLanguage.zh =>
        '合同约定的时薪 $pay 低于 $wageCalcYear 年最低工资 $mw。不足部分无效，您可以要求补足差额。',
      AppLanguage.vi =>
        'Lương giờ theo hợp đồng $pay thấp hơn lương tối thiểu năm $wageCalcYear là $mw. Phần thiếu không có hiệu lực và bạn có thể yêu cầu trả phần chênh lệch.',
    };
  }

  String _payAmountLabel(PayType type, AppLanguage lang) => switch (type) {
    PayType.hour => _hourLabel.of(lang),
    PayType.day => _dayLabel.of(lang),
    PayType.week => _weekLabel.of(lang),
    PayType.month => _monthPretaxLabel.of(lang),
    PayType.year => _yearPretaxLabel.of(lang),
  };

  // ---------- STEP 2 · 근무시간 ----------
  Widget _buildStep2(AppLanguage lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionH4(title: _step2Title.of(lang), lead: _step2Lead.of(lang)),
        FGroup(
          title: _weeklyHoursLabel.of(lang),
          help: () => _openHelp('week_h', lang),
          children: [
            FRow(
              label: _weeklyContractLabel.of(lang),
              controller: _weekHoursCtrl,
              unit: _hourUnit.of(lang),
            ),
          ],
        ),
        FGroup(
          title: _overtimeSectionTitle.of(lang),
          children: [
            FRow(
              label: _otLabel.of(lang),
              controller: _otCtrl,
              unit: _hourUnit.of(lang),
              help: () => _openHelp('ot_info', lang),
            ),
            FRow(
              label: _nightLabel.of(lang),
              controller: _nightCtrl,
              unit: _hourUnit.of(lang),
              help: () => _openHelp('nt_info', lang),
            ),
            FRow(
              label: _holLabel.of(lang),
              controller: _holCtrl,
              unit: _hourUnit.of(lang),
              help: () => _openHelp('hol_info', lang),
            ),
          ],
        ),
      ],
    );
  }

  // ---------- STEP 3 · 재직 기간 ----------
  Widget _buildStep3(AppLanguage lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionH4(
          title: _step3Title.of(lang),
          lead: _step3Lead.of(lang),
          help: () => _openHelp('tenure_info', lang),
        ),
        FGroup(
          title: _tenureLabel.of(lang),
          children: [
            FDateRow(
              label: _hireDateLabel.of(lang),
              value: _hireDate,
              placeholder: _selectPlaceholder.of(lang),
              onPick: (d) => setState(() => _hireDate = d),
            ),
            FDateRow(
              label: _leaveDateLabel.of(lang),
              value: _leaveDate,
              placeholder: _selectPlaceholder.of(lang),
              onPick: (d) => setState(() => _leaveDate = d),
            ),
          ],
        ),
        FGroup(
          title: _absenceLabel.of(lang),
          children: [
            ToggleRow(
              label: _absenceToggle.of(lang),
              value: _absent,
              onChanged: (v) => setState(() => _absent = v),
            ),
          ],
        ),
        MoreBox(
          title: _whySeparateTitle.of(lang),
          child: Text(
            _whySeparateBody.of(lang),
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ),
        MoreBox(
          title: _severanceExtraTitle.of(lang),
          help: () => _openHelp('severance_extra', lang),
          child: Column(
            children: [
              FRow(
                label: _bonus1yLabel.of(lang),
                controller: _bonus1yCtrl,
                unit: _wonUnit.of(lang),
              ),
              FRow(
                label: _vacation1yLabel.of(lang),
                controller: _vacation1yCtrl,
                unit: _wonUnit.of(lang),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------- STEP 4 · 세금 및 숙식비 공제 ----------
  Widget _buildStep4(WageCalcInput input, AppLanguage lang) {
    final r = calcWage(input);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionH4(title: _step4Title.of(lang), lead: _step4Lead.of(lang)),
        FGroup(
          title: _taxMethodLabel.of(lang),
          help: () => _openHelp('tax_info', lang),
          children: [
            OptButton(
              icon: '🛡',
              title: _fourInsuranceLabel.of(lang),
              selected: _tax == TaxMethod.four,
              onTap: () => setState(() => _tax = TaxMethod.four),
            ),
            OptButton(
              icon: '🧾',
              title: _bizTaxLabel.of(lang),
              selected: _tax == TaxMethod.biz,
              onTap: () => setState(() => _tax = TaxMethod.biz),
            ),
            OptButton(
              icon: '–',
              title: _noTaxLabel.of(lang),
              selected: _tax == TaxMethod.none,
              onTap: () => setState(() => _tax = TaxMethod.none),
            ),
            OptButton(
              icon: '❓',
              title: _unknownLabel.of(lang),
              selected: _tax == TaxMethod.unknown,
              onTap: () => setState(() => _tax = TaxMethod.unknown),
            ),
          ],
        ),
        FGroup(
          title: _roomDeductLabel.of(lang),
          children: [
            ToggleRow(
              label: _roomToggle.of(lang),
              value: _roomOn,
              onChanged: (v) => setState(() => _roomOn = v),
            ),
            if (_roomOn) ...[
              const SizedBox(height: 6),
              FRow(
                label: _roomDeductTotalLabel.of(lang),
                controller: _roomAmtCtrl,
                unit: _wonUnit.of(lang),
              ),
              const SizedBox(height: 6),
              Text(
                _roomTypeLabel.of(lang),
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Chips<RoomType>(
                options: [
                  (_dormLabel.of(lang), RoomType.dorm),
                  (_studioLabel.of(lang), RoomType.studio),
                  (_mealLabel.of(lang), RoomType.meal),
                ],
                value: _roomType,
                onChanged: (v) => setState(() => _roomType = v),
              ),
            ],
          ],
        ),
        if (r.roomBelowMin)
          RedNotice(
            title: _roomBelowMinTitle.of(lang),
            body: _roomBelowMinBody(r, lang),
          ),
      ],
    );
  }

  String _roomBelowMinBody(WageCalcResult r, AppLanguage lang) {
    final after = formatWon(r.afterRoomHourly, lang);
    final mw = formatWon(minWage().$1, lang);
    return switch (lang) {
      AppLanguage.ko =>
        '공제 후 환산 시급 $after < 최저임금 $mw. 공제 근거와 금액을 사업주에게 서면으로 요청해 확인해 보세요.',
      AppLanguage.uz =>
        "Chegirmadan keyingi soatlik ish haqi $after < eng kam ish haqi $mw. Ish beruvchingizdan chegirma asosi va miqdori haqida yozma tasdiqni soʻrang.",
      AppLanguage.en =>
        'Hourly wage after deduction $after < minimum wage $mw. Request written confirmation of the deduction basis and amount from your employer.',
      AppLanguage.tr =>
        "Kesinti sonrası saatlik ücret $after < asgari ücret $mw. İşvereninizden kesinti dayanağı ve miktarı hakkında yazılı onay isteyin.",
      AppLanguage.tg =>
        "Музди меҳнати соатӣ пас аз тарҳ $after < музди меҳнати ҳадди ақал $mw. Аз корфармои худ тасдиқи хаттӣ дар бораи асос ва миқдори тарҳро талаб кунед.",
      AppLanguage.fil =>
        "Ang orasang sahod pagkatapos ng bawas na $after < minimum na sahod na $mw. Humingi ng nakasulat na kumpirmasyon mula sa iyong employer tungkol sa batayan at halaga ng bawas.",
      AppLanguage.ur =>
        "کٹوتی کے بعد فی گھنٹہ اجرت $after < کم از کم اجرت $mw۔ اپنے آجر سے کٹوتی کی بنیاد اور رقم کے بارے میں تحریری تصدیق طلب کریں۔",
      AppLanguage.th =>
        "ค่าจ้างรายชั่วโมงหลังหักเงิน $after < ค่าแรงขั้นต่ำ $mw โปรดขอเอกสารยืนยันจากนายจ้างเกี่ยวกับเหตุผลและจำนวนเงินที่ถูกหัก",
      AppLanguage.ky =>
        "Кармоодон кийинки сааттык эмгек акы $after < минималдуу эмгек акы $mw. Жумуш берүүчүңүздөн кармоонун негизи жана суммасы жөнүндө жазуу жүзүндөгү ырастоону сураңыз.",
      AppLanguage.km =>
        "ប្រាក់ឈ្នួលម៉ោងបន្ទាប់ពីកាត់កងគឺ $after < ប្រាក់ឈ្នួលអប្បបរមា $mw។ សូមស្នើសុំការយល់ព្រមជាលាយលក្ខណ៍អក្សរពីនិយោជករបស់អ្នកអំពីមូលដ្ឋាន និងចំនួននៃការកាត់កង។",
      AppLanguage.id =>
        "Upah per jam setelah pemotongan adalah $after < upah minimum $mw. Mintalah persetujuan tertulis dari atasan Anda mengenai dasar dan jumlah pemotongan.",
      AppLanguage.si =>
        "අඩු කිරීමෙන් පසු පැයක වැටුප $after < අවම වැටුප $mw. අඩු කිරීමේ පදනම සහ ප්‍රමාණය පිළිබඳව ඔබේ සේවායෝජකයාගෙන් ලිඛිත තහවුරු කිරීමක් ඉල්ලා සිටින්න.",
      AppLanguage.bn =>
        "কর্তনের পর প্রতি ঘণ্টার মজুরি $after < সর্বনিম্ন মজুরি $mw। আপনার নিয়োগকর্তার কাছে কর্তনের ভিত্তি এবং পরিমাণ সম্পর্কে লিখিত অনুমোদন চাইতে পারেন।",
      AppLanguage.my =>
        "နုတ်ယူပြီးနောက် နာရီလုပ်ခ $after < အနိမ့်ဆုံးလုပ်ခ $mw။ သင်၏အလုပ်ရှင်ထံမှ နုတ်ယူခြင်း၏ အကြောင်းရင်းနှင့် ပမာဏအတွက် စာဖြင့်ရေးသားထားသော အတည်ပြုချက်ကို တောင်းဆိုပါ။",
      AppLanguage.mn =>
        "Суутгалын дараах цагийн хөлс $after < хамгийн бага цалин $mw. Ажил олгогчоос суутгалын үндэслэл, хэмжээний талаар бичгээр баталгаажуулахыг хүснэ үү.",
      AppLanguage.lo =>
        "ຄ່າແຮງງານລາຍຊົ່ວໂມງຫຼັງຫັກຄ່າໃຊ້ຈ່າຍແມ່ນ $after < ຄ່າແຮງງານຂັ້ນຕ່ຳ $mw. ກະລຸນາຂໍການຢືນຢັນເປັນລາຍລັກອັກສອນຈາກນາຍຈ້າງຂອງທ່ານກ່ຽວກັບພື້ນຖານແລະຈໍານວນການຫັກຄ່າໃຊ້ຈ່າຍ.",
      AppLanguage.tet =>
        "Saláriu oras nian depois dedusaun $after < saláriu mínimu $mw. Husu ba ó nia empregadór atu fó konfirmasaun eskrita kona-ba baze no montante dedusaun.",
      AppLanguage.ne =>
        "कटौती पछिको प्रतिघण्टा ज्याला $after < न्यूनतम ज्याला $mw। आफ्नो रोजगारदाताबाट कटौतीको आधार र रकमको बारेमा लिखित पुष्टि माग्नुहोस्।",
      AppLanguage.zh => '扣除后折算时薪 $after < 最低工资 $mw。请向雇主书面索取扣除依据及金额进行确认。',
      AppLanguage.vi =>
        'Lương giờ quy đổi sau khấu trừ $after < lương tối thiểu $mw. Hãy yêu cầu chủ sử dụng lao động xác nhận bằng văn bản về căn cứ và số tiền khấu trừ.',
    };
  }

  // ---------- STEP 5 · 통장 실입금액 ----------
  Widget _buildStep5(WageCalcInput input, AppLanguage lang) {
    final period = input.periodLabel(lang);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionH4(title: _step5Title.of(lang), lead: _step5Lead.of(lang)),
        MoreBox(
          title: _periodNoticeTitle.of(lang),
          initiallyOpen: true,
          child: RichNote(_periodNoticeBody(period, lang)),
        ),
        FGroup(
          title: _totalReceivedTitle(period, lang),
          children: [
            FRow(
              label: _totalReceivedLabel.of(lang),
              controller: _receivedCtrl,
              unit: _wonUnit.of(lang),
            ),
          ],
        ),
        QuickButton(
          label: _zeroButtonLabel.of(lang),
          onTap: () => setState(() => _receivedCtrl.text = '0'),
        ),
      ],
    );
  }

  String _periodNoticeBody(String period, AppLanguage lang) => switch (lang) {
    AppLanguage.ko =>
      '설정하신 확인 기간(총 <b>$period</b>) 동안 사업주로부터 통장으로 실제 전달받은 금액의 <b>전체 합계</b>를 입력하세요.',
    AppLanguage.uz =>
      "Tekshiruv davrida (<b>$period</b>) ish beruvchingizdan bank oʻtkazmasi orqali haqiqatda olgan summaning <b>umumiy yigʻindisini</b> kiriting.",
    AppLanguage.en =>
      'Enter the <b>total sum</b> of the amount you actually received from your employer via bank transfer during the checking period (<b>$period</b>).',
    AppLanguage.tr =>
      "Kontrol dönemi (<b>$period</b>) boyunca işvereninizden banka havalesi yoluyla fiilen aldığınız miktarın <b>toplamını</b> girin.",
    AppLanguage.tg =>
      "Маблағи <b>умумиеро</b> ворид кунед, ки шумо дар давраи санҷиш (<b>$period</b>) тавассути интиқоли бонкӣ аз корфармои худ воқеан гирифтаед.",
    AppLanguage.fil =>
      "Ilagay ang <b>kabuuang halaga</b> na aktwal mong natanggap mula sa iyong employer sa pamamagitan ng bank transfer sa panahon ng pagsusuri (<b>$period</b>).",
    AppLanguage.ur =>
      "براہ کرم چیک کی مدت (<b>$period</b>) کے دوران اپنے آجر سے بینک ٹرانسفر کے ذریعے اصل میں وصول کی گئی رقم کا <b>مجموعہ</b> درج کریں۔",
    AppLanguage.th =>
      "โปรดระบุ<b>จำนวนเงินรวม</b>ที่คุณได้รับจริงจากนายจ้างผ่านการโอนเงินธนาคารในช่วงระยะเวลาตรวจสอบ (<b>$period</b>)",
    AppLanguage.ky =>
      "Текшерүү мезгилинде (<b>$period</b>) жумуш берүүчүңүздөн банктык которуу аркылуу иш жүзүндө алган сумманын <b>жалпысын</b> киргизиңиз.",
    AppLanguage.km =>
      "សូមបញ្ចូល<b>ចំនួនសរុប</b>នៃទឹកប្រាក់ដែលអ្នកបានទទួលជាក់ស្តែងពីនិយោជករបស់អ្នកតាមរយៈការផ្ទេរប្រាក់តាមធនាគារក្នុងអំឡុងពេលត្រួតពិនិត្យ (<b>$period</b>)។",
    AppLanguage.id =>
      "Masukkan <b>jumlah total</b> yang benar-benar Anda terima dari atasan Anda melalui transfer bank selama periode pemeriksaan (<b>$period</b>).",
    AppLanguage.si =>
      "පරීක්ෂා කිරීමේ කාලය (<b>$period</b>) තුළ ඔබේ සේවායෝජකයාගෙන් බැංකු හුවමාරුවක් හරහා ඔබට සැබවින්ම ලැබුණු මුදලේ <b>මුළු එකතුව</b> ඇතුළත් කරන්න.",
    AppLanguage.bn =>
      "পর্যালোচনা সময়কাল (<b>$period</b>) এর মধ্যে আপনার নিয়োগকর্তার কাছ থেকে ব্যাংক স্থানান্তরের মাধ্যমে আপনি প্রকৃতপক্ষে যে পরিমাণ অর্থ পেয়েছেন তার <b>মোট</b> লিখুন।",
    AppLanguage.my =>
      "စစ်ဆေးသည့်ကာလ (<b>$period</b>) အတွင်း သင်၏အလုပ်ရှင်ထံမှ ဘဏ်ငွေလွှဲခြင်းဖြင့် လက်တွေ့ရရှိခဲ့သော ပမာဏ၏ <b>စုစုပေါင်းကို</b> ထည့်သွင်းပါ။",
    AppLanguage.mn =>
      "Шалгах хугацаанд (<b>$period</b>) ажил олгогчоос банкны шилжүүлгээр бодитоор авсан <b>нийт дүнгээ</b> оруулна уу.",
    AppLanguage.lo =>
      "ໃນລະຫວ່າງໄລຍະເວລາການກວດສອບ (<b>$period</b>) ກະລຸນາປ້ອນ <b>ຈຳນວນເງິນທັງໝົດ</b> ທີ່ທ່ານໄດ້ຮັບຕົວຈິງຈາກນາຍຈ້າງຂອງທ່ານຜ່ານການໂອນເງິນຜ່ານທະນາຄານ.",
    AppLanguage.tet =>
      "Durante períodu verifikasaun (<b>$period</b>), fó hatene <b>totál</b> montante ne'ebé ó simu duni husi ó nia empregadór liuhusi transferénsia bankária.",
    AppLanguage.ne =>
      "जाँच अवधि (<b>$period</b>) भरि तपाईंले आफ्नो रोजगारदाताबाट बैंक स्थानान्तरण मार्फत वास्तवमा प्राप्त गर्नुभएको रकमको <b>कुल</b> प्रविष्ट गर्नुहोस्।",
    AppLanguage.zh =>
      '请输入在您设置的确认期间（共 <b>$period</b>）内，实际从雇主处收到的银行转账金额的<b>总计</b>。',
    AppLanguage.vi =>
      'Vui lòng nhập <b>tổng số tiền</b> bạn đã thực nhận qua chuyển khoản ngân hàng từ chủ sử dụng lao động trong kỳ xác nhận (<b>$period</b>).',
  };

  String _totalReceivedTitle(String period, AppLanguage lang) => switch (lang) {
    AppLanguage.ko => '실입금액 합계 ($period)',
    AppLanguage.uz => "Olingan umumiy summa ($period)",
    AppLanguage.en => 'Total amount received ($period)',
    AppLanguage.tr => "Alınan toplam miktar ($period)",
    AppLanguage.tg => "Маблағи умумии гирифташуда ($period)",
    AppLanguage.fil => "Kabuuang halagang natanggap ($period)",
    AppLanguage.ur => "وصول شدہ کل رقم ($period)",
    AppLanguage.th => "จำนวนเงินรวมที่ได้รับ ($period)",
    AppLanguage.ky => "Алынган жалпы сумма ($period)",
    AppLanguage.km => "ចំនួនទឹកប្រាក់សរុបដែលបានទទួល ($period)",
    AppLanguage.id => "Jumlah total yang diterima ($period)",
    AppLanguage.si => "ලැබුණු මුළු මුදල ($period)",
    AppLanguage.bn => "প্রাপ্ত মোট পরিমাণ ($period)",
    AppLanguage.my => "ရရှိသော စုစုပေါင်းပမာဏ ($period)",
    AppLanguage.mn => "Авсан нийт дүн ($period)",
    AppLanguage.lo => "ຈຳນວນເງິນທັງໝົດທີ່ໄດ້ຮັບ ($period)",
    AppLanguage.tet => "Montante totál ne'ebé simu ($period)",
    AppLanguage.ne => "प्राप्त कुल रकम ($period)",
    AppLanguage.zh => '实际入账金额总计（$period）',
    AppLanguage.vi => 'Tổng số tiền thực nhận ($period)',
  };
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({
    required this.stepIndex,
    required this.totalSteps,
    required this.resultMode,
    required this.language,
  });
  final int stepIndex;
  final int totalSteps;
  final bool resultMode;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.blueBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                resultMode
                    ? _resultBadge.of(language)
                    : '${_stepWord.of(language)} ${stepIndex + 1} / $totalSteps',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(totalSteps, (i) {
              final done = resultMode || i < stepIndex;
              final current = !resultMode && i == stepIndex;
              final color = done
                  ? AppColors.secondary
                  : (current ? AppColors.primary : AppColors.border);
              return Expanded(
                child: Container(
                  height: 3,
                  margin: EdgeInsets.only(right: i < totalSteps - 1 ? 4 : 0),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _StepFooter extends StatelessWidget {
  const _StepFooter({
    required this.resultMode,
    required this.showPrev,
    required this.nextLabel,
    required this.prevLabel,
    required this.editValuesLabel,
    required this.onPrev,
    required this.onNext,
  });

  final bool resultMode;
  final bool showPrev;
  final String nextLabel;
  final String prevLabel;
  final String editValuesLabel;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 11, 15, 11),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: resultMode
          ? SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onPrev,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                child: Text(
                  editValuesLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          : Row(
              children: [
                if (showPrev) ...[
                  SizedBox(
                    width: 92,
                    child: OutlinedButton(
                      onPressed: onPrev,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        foregroundColor: AppColors.textSecondary,
                        side: BorderSide.none,
                        backgroundColor: const Color(0xFFF1F5F9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      child: Text(
                        prevLabel,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    child: Text(
                      nextLabel,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
