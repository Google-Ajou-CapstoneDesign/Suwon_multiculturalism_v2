import 'package:flutter/material.dart';
import '../../../common/widgets/rich_note.dart';
import '../../../core/app_language.dart';
import '../../../theme/app_colors.dart';
import '../models/wage_diagnosis.dart';
import 'wage_form_widgets.dart';
import 'wage_help.dart';

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

const _watermark = _S(
  '⚠ 입력값 기준 추정치',
  '⚠ Estimate based on your input',
  '⚠ 基于输入值的估算值',
  '⚠ Ước tính dựa trên giá trị đã nhập',
  "⚠ Sizning maʼlumotlaringiz asosida taxmin",
  "⚠ Girdilerinize göre tahmin",
  "⚠ तपाईंको प्रविष्टिको आधारमा अनुमान",
  "⚠ Estimasaun bazeia ba Ita-nia input",
  "⚠ ຄາດຄະເນຕາມຂໍ້ມູນທີ່ທ່ານປ້ອນ",
  "⚠ Таны оруулсан мэдээллээр хийсэн тооцоо",
  "⚠ သင်၏ ထည့်သွင်းမှုများအပေါ် အခြေခံ၍ ခန့်မှန်းချက်",
  "⚠ আপনার ইনপুট অনুযায়ী অনুমান",
  "⚠ ඔබේ ඇතුළත් කිරීම් මත පදනම්ව අනාවැකි",
  "⚠ Perkiraan berdasarkan masukan Anda",
  "⚠ ការប៉ាន់ស្មានផ្អែកលើការបញ្ចូលរបស់អ្នក",
  "⚠ Сиздин киргизүүлөрүңүзгө ылайык болжолдоо",
  "⚠ ประมาณการตามข้อมูลที่คุณป้อน",
  "⚠ آپ کے اندراجات کی بنیاد پر تخمینہ",
  "⚠ Pagtataya batay sa iyong mga input",
  "⚠ Тахмин бар асоси маълумоти воридкардаи шумо",
);
const _basePay = _S(
  '기본급',
  'Base pay',
  '基本工资',
  'Lương cơ bản',
  "Asosiy ish haqi",
  "Temel ücret",
  "आधारभूत ज्याला",
  "Saláriu báziku",
  "ຄ່າຈ້າງພື້ນຖານ",
  "Үндсэн цалин",
  "အခြေခံလုပ်ခ",
  "মৌলিক মজুরি",
  "මූලික වැටුප",
  "Gaji dasar",
  "ប្រាក់ឈ្នួលមូលដ្ឋាន",
  "Негизги эмгек акы",
  "ค่าจ้างพื้นฐาน",
  "بنیادی اجرت",
  "Basic pay",
  "Музди асосӣ",
);
const _weeklyAllowance = _S(
  '주휴수당',
  'Weekly paid holiday allowance',
  '周休津贴',
  'Phụ cấp ngày nghỉ có lương hàng tuần',
  "Haftalik haq toʻlanadigan taʼtil nafaqasi",
  "Haftalık ücretli tatil ödeneği",
  "साप्ताहिक सशुल्क बिदा भत्ता",
  "Subsídiu feriadu pagu semana nian",
  "ເງິນອຸດໜູນພັກທີ່ໄດ້ຮັບຄ່າຈ້າງປະຈຳອາທິດ",
  "Долоо хоногийн цалинтай амралтын тэтгэмж",
  "အပတ်စဉ် လုပ်ခနှင့်တူသော အားလပ်ရက်စရိတ်",
  "সাপ্তাহিক বেতনভুক্ত ছুটির ভাতা",
  "සතිපතා වැටුප් සහිත නිවාඩු දීමනාව",
  "Tunjangan libur berbayar mingguan",
  "ប្រាក់ឧបត្ថម្ភឈប់សម្រាកដែលមានប្រាក់ឈ្នួលប្រចាំសប្តាហ៍",
  "Жумалык акы төлөнүүчү эс алуу жөлөкпулу",
  "ค่าจ้างวันหยุดประจำสัปดาห์",
  "ہفتہ وار ادا شدہ چھٹی کی اجرت",
  "Allowance para sa lingguhang bayad na holiday",
  "Пардохти рухсатии пулакии ҳафтаина",
);
const _notApplicable = _S(
  '해당없음',
  'N/A',
  '不适用',
  'Không áp dụng',
  "Mavjud emas",
  "Yok",
  "छैन",
  "La iha",
  "ບໍ່ມີ",
  "Байхгүй",
  "မရှိပါ",
  "নেই",
  "කිසිවක් නැත",
  "Tidak Ada",
  "គ្មាន",
  "Жок",
  "ไม่มี",
  "کوئی نہیں",
  "Wala",
  "Нест",
);
const _overtimeAllowance = _S(
  '연장근로수당',
  'Overtime allowance',
  '延长劳动津贴',
  'Phụ cấp làm thêm giờ',
  "Ishdan tashqari vaqt uchun nafaqa",
  "Fazla mesai ödeneği",
  "ओभरटाइम भत्ता",
  "Subsídiu oras estra",
  "ເງິນອຸດໜູນລ່ວງເວລາ",
  "Илүү цагийн тэтгэмж",
  "အချိန်ပိုစရိတ်",
  "ওভারটাইম ভাতা",
  "අතිකාල දීමනාව",
  "Tunjangan lembur",
  "ប្រាក់ឧបត្ថម្ភម៉ោងបន្ថែម",
  "Ашыкча иштөө жөлөкпулу",
  "ค่าล่วงเวลา",
  "اوور ٹائم الاؤنس",
  "Allowance para sa overtime",
  "Пардохти кори изофагӣ",
);
const _nightAllowance = _S(
  '야간근로수당',
  'Night work allowance',
  '夜间劳动津贴',
  'Phụ cấp làm việc ban đêm',
  "Tungi ish uchun nafaqa",
  "Gece çalışması ödeneği",
  "रात्रिकालीन काम भत्ता",
  "Subsídiu servisu kalan",
  "ເງິນອຸດໜູນເຮັດວຽກກາງຄືນ",
  "Шөнийн цагийн тэтгэмж",
  "ညဆိုင်းစရိတ်",
  "রাতের কাজের ভাতা",
  "රාත්‍රී වැඩ දීමනාව",
  "Tunjangan kerja malam",
  "ប្រាក់ឧបត្ថម្ភការងារពេលយប់",
  "Түнкү жумуш жөлөкпулу",
  "ค่าทำงานกลางคืน",
  "رات کے کام کا الاؤنس",
  "Allowance para sa trabaho sa gabi",
  "Пардохти кори шабона",
);
const _holidayAllowance = _S(
  '휴일근로수당',
  'Holiday work allowance',
  '假日劳动津贴',
  'Phụ cấp làm việc ngày lễ',
  "Bayram kunlari ishlaganlik uchun nafaqa",
  "Tatil çalışması ödeneği",
  "बिदाको काम भत्ता",
  "Subsídiu servisu feriadu",
  "ເງິນອຸດໜູນເຮັດວຽກວັນພັກ",
  "Амралтын өдрийн тэтгэмж",
  "အားလပ်ရက် အလုပ်စရိတ်",
  "ছুটির দিনের কাজের ভাতা",
  "නිවාඩු වැඩ දීමනාව",
  "Tunjangan kerja libur",
  "ប្រាក់ឧបត្ថម្ភការងារថ្ងៃឈប់សម្រាក",
  "Майрам күндөрү иштөө жөлөкпулу",
  "ค่าทำงานวันหยุด",
  "چھٹی کے دن کام کا الاؤنس",
  "Allowance para sa trabaho sa holiday",
  "Пардохти кори ид",
);
const _grossTotal = _S(
  '세전 총액',
  'Total before tax',
  '税前总额',
  'Tổng trước thuế',
  "Soliqdan oldingi jami",
  "Vergi öncesi toplam",
  "कर अघिको कुल रकम",
  "Totál antes impostu",
  "ຍອດລວມກ່ອນຫັກພາສີ",
  "Татварын өмнөх нийт дүн",
  "အခွန်မဆောင်မီ စုစုပေါင်း",
  "কর-পূর্ব মোট",
  "බදු පෙර මුළු එකතුව",
  "Total sebelum pajak",
  "ចំនួនសរុបមុនពេលបង់ពន្ធ",
  "Салыкка чейинки жалпы сумма",
  "ยอดรวมก่อนหักภาษี",
  "ٹیکس سے پہلے کا کل",
  "Kabuuang bago ang buwis",
  "Ҷамъи пеш аз андоз",
);
const _ifFourInsurance = _S(
  '🛡 4대보험으로 공제된다면',
  '🛡 If deducted via the 4 major insurances',
  '🛡 如果按四大保险扣除',
  '🛡 Nếu khấu trừ theo 4 loại bảo hiểm',
  "🛡 Agar 4 ta asosiy sugʻurta orqali ushlab qolingan boʻlsa",
  "🛡 4 büyük sigorta aracılığıyla kesilirse",
  "🛡 यदि 4 प्रमुख बीमा मार्फत कटौती गरिएमा",
  "🛡 Se dedús liuhosi seguru boot 4",
  "🛡 ຖ້າຖືກຫັກຜ່ານປະກັນໄພໃຫຍ່ 4",
  "🛡 Хэрэв 4 том даатгалаар суутгагдсан бол",
  "🛡 4 အကြီးစားအာမခံမှတစ်ဆင့် ဖြတ်တောက်ပါက",
  "🛡 যদি 4 প্রধান বীমার মাধ্যমে কেটে নেওয়া হয়",
  "🛡 4 විශාල රක්ෂණය හරහා අඩු කරන්නේ නම්",
  "🛡 Jika dipotong melalui asuransi besar 4",
  "🛡 ប្រសិនបើកាត់តាមរយៈការធានារ៉ាប់រងធំ 4",
  "🛡 4 чоң камсыздандыруу аркылуу чегерилсе",
  "🛡 หากหักผ่านประกันหลัก 4",
  "🛡 اگر 4 بڑے بیمہ کے ذریعے کٹوتی کی جائے",
  "🛡 Kung ibinawas sa pamamagitan ng 4 na malaking seguro",
  "🛡 Агар тавассути суғуртаи калони 4 тарҳ карда шавад",
);
const _roomDeduction = _S(
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
const _expectedNet = _S(
  '예상 실수령액',
  'Expected net pay',
  '预计实际到手金额',
  'Số tiền thực nhận dự kiến',
  "Kutilayotgan sof ish haqi",
  "Beklenen net maaş",
  "अपेक्षित खुद तलब",
  "Saláriu likidu ne'ebé espera",
  "ເງິນເດືອນສຸດທິທີ່ຄາດວ່າຈະໄດ້ຮັບ",
  "Хүлээгдэж буй цэвэр цалин",
  "မျှော်မှန်းထားသော အသားတင်လစာ",
  "প্রত্যাশিত নিট বেতন",
  "අපේක්ෂිත ශුද්ධ වැටුප",
  "Perkiraan gaji bersih",
  "ប្រាក់ខែសុទ្ធដែលរំពឹងទុក",
  "Күтүлгөн таза эмгек акы",
  "เงินเดือนสุทธิที่คาดว่าจะได้รับ",
  "متوقع خالص تنخواہ",
  "Inaasahang netong sahod",
  "Маоши холиси интизорӣ",
);
const _ifBizTax = _S(
  '🧾 3.3% 사업소득으로 공제된다면',
  '🧾 If deducted as 3.3% business income tax',
  '🧾 如果按3.3%事业所得税扣除',
  '🧾 Nếu khấu trừ 3.3% thuế thu nhập kinh doanh',
  "🧾 Agar 3.3% biznes daromad soligʻi sifatida ushlab qolingan boʻlsa",
  "🧾 %3,3 işletme gelir vergisi olarak kesilirse",
  "🧾 यदि 3.3% व्यवसाय आयकरको रूपमा कटौती गरिएमा",
  "🧾 Se dedús nu'udar impostu rendimentu negósiu 3,3%",
  "🧾 ຖ້າຖືກຫັກເປັນພາສີລາຍໄດ້ທຸລະກິດ 3,3%",
  "🧾 Хэрэв 3,3% бизнесийн орлогын албан татвар суутгагдсан бол",
  "🧾 3,3% လုပ်ငန်းဝင်ငွေခွန်အဖြစ် ဖြတ်တောက်ပါက",
  "🧾 যদি 3,3% ব্যবসায়িক আয়কর হিসাবে কেটে নেওয়া হয়",
  "🧾 3,3% ව්‍යාපාර ආදායම් බදු ලෙස අඩු කරන්නේ නම්",
  "🧾 Jika dipotong sebagai pajak penghasilan bisnis 3,3%",
  "🧾 ប្រសិនបើកាត់ 3,3% ជាពន្ធលើប្រាក់ចំណូលអាជីវកម្ម",
  "🧾 %3,3 ишкананын киреше салыгы катары чегерилсе",
  "🧾 หากหักภาษีเงินได้ธุรกิจ 3,3%",
  "🧾 اگر 3,3% کاروباری انکم ٹیکس کے طور پر کٹوتی کی جائے",
  "🧾 Kung ibinawas bilang %3,3 buwis sa kita ng negosyo",
  "🧾 Агар 3,3% ҳамчун андози даромади тиҷорат тарҳ карда шавад",
);
const _bizTaxDeduction = _S(
  '세금 공제 (사업소득세 3.3%)',
  'Tax deduction (3.3% business income tax)',
  '税款扣除（事业所得税3.3%）',
  'Khấu trừ thuế (thuế thu nhập kinh doanh 3.3%)',
  "Soliq chegirmasi (3.3% biznes daromad soligʻi)",
  "Vergi kesintisi (%3,3 işletme gelir vergisi)",
  "कर कटौती (3.3% व्यवसाय आयकर)",
  "Dedusaun impostu (impostu rendimentu negósiu 3,3%)",
  "ການຫັກພາສີ (ພາສີລາຍໄດ້ທຸລະກິດ 3,3%)",
  "Татварын суутгал (3,3% бизнесийн орлогын албан татвар)",
  "အခွန်ဖြတ်တောက်မှု (3,3% လုပ်ငန်းဝင်ငွေခွန်)",
  "কর কর্তন (3,3% ব্যবসায়িক আয়কর)",
  "බදු අඩු කිරීම (3,3% ව්‍යාපාර ආදායම් බදු)",
  "Potongan pajak (pajak penghasilan bisnis 3,3%)",
  "ការកាត់ពន្ធ (ពន្ធលើប្រាក់ចំណូលអាជីវកម្ម 3,3%)",
  "Салыктык чегерүү (%3,3 ишкананын киреше салыгы)",
  "การหักภาษี (ภาษีเงินได้ธุรกิจ 3,3%)",
  "ٹیکس کٹوتی (3,3% کاروباری انکم ٹیکس)",
  "Pagbabawas ng buwis (%3,3 buwis sa kita ng negosyo)",
  "Тарҳи андоз (андози даромади тиҷорат 3,3%)",
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
const _similarAmount = _S(
  '입금액이 계산 결과와 비슷합니다',
  'The deposited amount is similar to the calculated result',
  '入账金额与计算结果相近',
  'Số tiền nhận được gần giống với kết quả tính toán',
  "Depozitga qoʻyilgan summa hisoblangan natijaga oʻxshash",
  "Yatan miktar hesaplanan sonuca benzer",
  "जम्मा गरिएको रकम गणना गरिएको नतिजासँग मिल्दोजुल्दो छ",
  "Montante ne'ebé simu hanesan ho rezultadu kalkuladu",
  "ຈຳນວນເງິນທີ່ຝາກແມ່ນຄ້າຍຄືກັນກັບຜົນການຄິດໄລ່",
  "Төлөгдсөн дүн нь тооцоолсон үр дүнтэй төстэй байна",
  "ပေးချေသည့်ပမာဏသည် တွက်ချက်ထားသောရလဒ်နှင့် ဆင်တူသည်",
  "জমা হওয়া পরিমাণ গণনাকৃত ফলাফলের অনুরূপ",
  "තැන්පත් කළ මුදල ගණනය කළ ප්‍රතිඵලයට සමාන වේ",
  "Jumlah yang disetorkan mirip dengan hasil yang dihitung",
  "ចំនួនទឹកប្រាក់ដែលបានដាក់គឺស្រដៀងនឹងលទ្ធផលដែលបានគណនា",
  "Төлөнгөн сумма эсептелген натыйжага окшош",
  "จำนวนเงินที่ได้รับใกล้เคียงกับผลการคำนวณ",
  "جمع شدہ رقم حساب شدہ نتیجے کے مماثل ہے",
  "Ang halagang idineposito ay katulad ng kinakalkulang resulta",
  "Маблағи пардохтшуда ба натиҷаи ҳисобшуда монанд аст",
);
const _lessThanExpected = _S(
  '받아야 할 금액보다 적게 들어왔습니다',
  'You received less than what you should have',
  '收到的金额少于应得金额',
  'Số tiền nhận được ít hơn số tiền đáng lẽ phải nhận',
  "Siz olishingiz kerak boʻlganidan kamroq oldingiz",
  "Almanız gerekenden daha az aldınız",
  "तपाईंले पाउनुपर्ने भन्दा कम पाउनुभयो",
  "Ita simu menus husi ne'ebé Ita tenke simu",
  "ທ່ານໄດ້ຮັບໜ້ອຍກວ່າທີ່ຄວນຈະໄດ້ຮັບ",
  "Та авах ёстойгоосоо бага авсан байна",
  "သင်ရသင့်သည်ထက် နည်းပါးစွာ ရရှိခဲ့သည်",
  "আপনার যা পাওয়ার কথা ছিল তার চেয়ে কম পেয়েছেন",
  "ඔබට ලැබිය යුතු ප්‍රමාණයට වඩා අඩුවෙන් ලැබී ඇත",
  "Anda menerima kurang dari yang seharusnya",
  "អ្នកបានទទួលតិចជាងអ្វីដែលអ្នកគួរទទួលបាន",
  "Сиз алышыңыз керек болгондон аз алдыңыз",
  "คุณได้รับน้อยกว่าที่ควรจะได้รับ",
  "آپ کو جتنا ملنا چاہیے تھا اس سے کم ملا",
  "Mas kaunti ang natanggap mo kaysa sa dapat mong matanggap",
  "Шумо камтар аз он чизе, ки бояд мегирифтед, гирифтед",
);
const _moreThanCalculated = _S(
  '계산 결과보다 많이 들어왔습니다',
  'You received more than the calculated result',
  '收到的金额多于计算结果',
  'Số tiền nhận được nhiều hơn kết quả tính toán',
  "Siz hisoblangan natijadan koʻproq oldingiz",
  "Hesaplanan sonuçtan daha fazlasını aldınız",
  "तपाईंले गणना गरिएको नतिजा भन्दा बढी पाउनुभयो",
  "Ita simu liu husi rezultadu kalkuladu",
  "ທ່ານໄດ້ຮັບຫຼາຍກວ່າຜົນການຄິດໄລ່",
  "Та тооцоолсон үр дүнгээс илүү авсан байна",
  "တွက်ချက်ထားသောရလဒ်ထက် ပိုမိုရရှိခဲ့သည်",
  "আপনি গণনাকৃত ফলাফলের চেয়ে বেশি পেয়েছেন",
  "ගණනය කළ ප්‍රතිඵලයට වඩා වැඩි ප්‍රමාණයක් ඔබට ලැබී ඇත",
  "Anda menerima lebih dari hasil yang dihitung",
  "អ្នកបានទទួលច្រើនជាងលទ្ធផលដែលបានគណនា",
  "Сиз эсептелген натыйжадан көбүрөөк алдыңыз",
  "คุณได้รับมากกว่าผลการคำนวณ",
  "آپ کو حساب شدہ نتیجے سے زیادہ ملا",
  "Mas marami ang natanggap mo kaysa sa kinakalkulang resulta",
  "Шумо бештар аз натиҷаи ҳисобшуда гирифтед",
);
const _gapLabel = _S(
  '차액',
  'Difference',
  '差额',
  'Chênh lệch',
  "Farq",
  "Fark",
  "फरक",
  "Diferensa",
  "ສ່ວນຕ່າງ",
  "Зөрүү",
  "ကွာခြားချက်",
  "পার্থক্য",
  "වෙනස",
  "Selisih",
  "ភាពខុសគ្នា",
  "Айырма",
  "ส่วนต่าง",
  "فرق",
  "Pagkakaiba",
  "Фарқият",
);
const _aiDiagnosisPositive = _S(
  '🤖 왜 더 받아야 하는지 진단 보기',
  '🤖 See diagnosis on why you should receive more',
  '🤖 查看诊断：为什么应该多收到',
  '🤖 Xem chẩn đoán về lý do bạn nên nhận nhiều hơn',
  "🤖 Nima uchun koʻproq olishingiz kerakligi haqida diagnostikani koʻring",
  "🤖 Neden daha fazlasını almanız gerektiğine dair teşhisi görün",
  "🤖 तपाईंले किन बढी पाउनुपर्थ्यो भन्ने निदान हेर्नुहोस्",
  "🤖 Haree diagnóstiku tanba sá Ita tenke simu liu",
  "🤖 ເບິ່ງການວິນິດໄສວ່າເປັນຫຍັງທ່ານຄວນໄດ້ຮັບຫຼາຍກວ່ານີ້",
  "🤖 Та яагаад илүү авах ёстой байсныг оношийг харна уу",
  "🤖 အဘယ်ကြောင့် ပိုမိုရသင့်သည်ကို ရောဂါရှာဖွေမှုကို ကြည့်ပါ",
  "🤖 কেন আপনার আরও বেশি পাওয়া উচিত তার নির্ণয় দেখুন",
  "🤖 ඔබට වැඩිපුර ලැබිය යුත්තේ මන්දැයි රෝග විනිශ්චය බලන්න",
  "🤖 Lihat diagnosis mengapa Anda seharusnya menerima lebih banyak",
  "🤖 មើលការវិនិច្ឆ័យថាហេតុអ្វីបានជាអ្នកគួរទទួលបានច្រើនជាងនេះ",
  "🤖 Эмне үчүн көбүрөөк алышыңыз керектиги боюнча диагнозду көрүңүз",
  "🤖 ดูการวินิจฉัยว่าทำไมคุณควรได้รับมากขึ้น",
  "🤖 دیکھیں کہ آپ کو زیادہ کیوں ملنا چاہیے تھا",
  "🤖 Tingnan ang diagnosis kung bakit mas marami ang dapat mong matanggap",
  "🤖 Ташхисро бубинед, ки чаро шумо бояд бештар мегирифтед",
);
const _aiDiagnosisNegative = _S(
  '🤖 왜 차이가 나는지 진단 보기',
  '🤖 See diagnosis on why there is a difference',
  '🤖 查看诊断：为什么会有差异',
  '🤖 Xem chẩn đoán về lý do có sự chênh lệch',
  "🤖 Nima uchun farq borligi haqida diagnostikani koʻring",
  "🤖 Neden bir fark olduğuna dair teşhisi görün",
  "🤖 किन फरक छ भन्ने निदान हेर्नुहोस्",
  "🤖 Haree diagnóstiku tanba sá iha diferensa",
  "🤖 ເບິ່ງການວິນິດໄສວ່າເປັນຫຍັງຈຶ່ງມີສ່ວນຕ່າງ",
  "🤖 Яагаад зөрүү гарсан тухай оношийг харна уу",
  "🤖 အဘယ်ကြောင့် ကွာခြားချက်ရှိသည်ကို ရောဂါရှာဖွေမှုကို ကြည့်ပါ",
  "🤖 কেন পার্থক্য আছে তার নির্ণয় দেখুন",
  "🤖 වෙනසක් ඇත්තේ මන්දැයි රෝග විනිශ්චය බලන්න",
  "🤖 Lihat diagnosis mengapa ada selisih",
  "🤖 មើលការវិនិច្ឆ័យថាហេតុអ្វីបានជាមានភាពខុសគ្នា",
  "🤖 Эмне үчүн айырма бар экени боюнча диагнозду көрүңүз",
  "🤖 ดูการวินิจฉัยว่าทำไมจึงมีส่วนต่าง",
  "🤖 دیکھیں کہ فرق کیوں ہے",
  "🤖 Tingnan ang diagnosis kung bakit may pagkakaiba",
  "🤖 Ташхисро бубинед, ки чаро фарқият вуҷуд дорад",
);
const _aiDiagnosisTitle = _S(
  '🤖 AI 맞춤 진단',
  '🤖 AI Custom Diagnosis',
  '🤖 AI定制诊断',
  '🤖 Chẩn đoán AI tùy chỉnh',
  "🤖 AI Maxsus Diagnostika",
  "🤖 Yapay Zeka Özel Teşhisi",
  "🤖 एआई विशेष निदान",
  "🤖 Diagnóstiku Espesiál Intelijénsia Artifisiál",
  "🤖 ການວິນິດໄສພິເສດດ້ວຍປັນຍາປະດິດ",
  "🤖 Хиймэл оюун ухааны тусгай оношлогоо",
  "🤖 AI အထူးရောဂါရှာဖွေမှု",
  "🤖 এআই কাস্টম নির্ণয়",
  "🤖 කෘත්‍රිම බුද්ධි විශේෂ රෝග විනිශ්චය",
  "🤖 Diagnosis Khusus AI",
  "🤖 ការវិនិច្ឆ័យពិសេសដោយ AI",
  "🤖 Жасалма интеллекттин атайын диагнозу",
  "🤖 การวินิจฉัยพิเศษโดย AI",
  "🤖 مصنوعی ذہانت کی خصوصی تشخیص",
  "🤖 AI Espesyal na Diagnosis",
  "🤖 Ташхиси махсуси зеҳни сунъӣ",
);
const _autoMapComplaint = _S(
  '📄 진정서에 내 기록 자동 매핑하기',
  '📄 Auto-fill my records into the complaint',
  '📄 自动将我的记录映射到申诉书',
  '📄 Tự động điền hồ sơ của tôi vào đơn tố cáo',
  "📄 Shikoyatga yozuvlarimni avtomatik toʻldirish",
  "📄 Kayıtlarımı şikayete otomatik doldur",
  "📄 मेरो रेकर्डहरू उजुरीमा स्वतः भर्नुहोस्",
  "📄 Preenche automátikamente ha'u-nia rejistu sira ba keixa",
  "📄 ຕື່ມຂໍ້ມູນບັນທຶກຂອງຂ້ອຍໃສ່ຄຳຮ້ອງທຸກໂດຍອັດຕະໂນມັດ",
  "📄 Миний бүртгэлийг гомдолд автоматаар бөглөх",
  "📄 ကျွန်ုပ်၏ မှတ်တမ်းများကို တိုင်ကြားစာထဲသို့ အလိုအလျောက်ဖြည့်ပါ",
  "📄 আমার রেকর্ডগুলি অভিযোগে স্বয়ংক্রিয়ভাবে পূরণ করুন",
  "📄 මගේ වාර්තා පැමිණිල්ලට ස්වයංක්‍රීයව පුරවන්න",
  "📄 Isi otomatis catatan saya ke dalam keluhan",
  "📄 បំពេញកំណត់ត្រារបស់ខ្ញុំដោយស្វ័យប្រវត្តិទៅក្នុងការតវ៉ា",
  "📄 Менин жазууларымды арызга автоматтык түрдө толтуруу",
  "📄 กรอกข้อมูลของฉันลงในคำร้องเรียนโดยอัตโนมัติ",
  "📄 میری معلومات کو شکایت میں خودکار طور پر بھریں",
  "📄 Awtomatikong punan ang aking mga rekord sa reklamo",
  "📄 Сабтҳои маро ба шикоят ба таври худкор пур кунед",
);
const _findNearbyOrgs = _S(
  '📍 내 근처 관할 기관 찾기',
  '📍 Find nearby authorities',
  '📍 查找我附近的管辖机构',
  '📍 Tìm cơ quan quản lý gần tôi',
  "📍 Yaqin atrofdagi hokimiyatlarni topish",
  "📍 Yakındaki yetkilileri bul",
  "📍 नजिकका अधिकारीहरू खोज्नुहोस्",
  "📍 Buka autoridade sira besik",
  "📍 ຊອກຫາເຈົ້າໜ້າທີ່ໃກ້ຄຽງ",
  "📍 Ойролцоох эрх баригчдыг олох",
  "📍 အနီးအနားရှိ အာဏာပိုင်များကို ရှာပါ",
  "📍 কাছাকাছি কর্তৃপক্ষ খুঁজুন",
  "📍 අසල ඇති බලධාරීන් සොයන්න",
  "📍 Temukan otoritas terdekat",
  "📍 ស្វែងរកអាជ្ញាធរនៅក្បែរ",
  "📍 Жакынкы бийлик органдарын табуу",
  "📍 ค้นหาหน่วยงานใกล้เคียง",
  "📍 قریبی حکام کو تلاش کریں",
  "📍 Hanapin ang mga awtoridad na malapit",
  "📍 Мақомоти наздикро пайдо кунед",
);
const _severanceHeader = _S(
  '🏆 예상 퇴직금 (별도)',
  '🏆 Estimated severance pay (separate)',
  '🏆 预计退休金（另计）',
  '🏆 Trợ cấp thôi việc dự kiến (tính riêng)',
  "🏆 Taxminiy ishdan boʻshatish nafaqasi (alohida)",
  "🏆 Tahmini kıdem tazminatı (ayrı)",
  "🏆 अनुमानित सेवा निवृत्ति भत्ता (छुट्टै)",
  "🏆 Estimativa indemnizasaun servisu (separadu)",
  "🏆 ຄ່າຊົດເຊີຍການອອກຈາກວຽກທີ່ຄາດຄະເນ (ແຍກຕ່າງຫາກ)",
  "🏆 Тооцоолсон тэтгэмж (тусдаа)",
  "🏆 ခန့်မှန်းခြေ အလုပ်သက်တမ်းအလိုက် ဆုကြေးငွေ (သီးခြား)",
  "🏆 আনুমানিক অবসরকালীন ভাতা (আলাদা)",
  "🏆 ඇස්තමේන්තුගත සේවා කාලය සඳහා ගෙවීම (වෙනම)",
  "🏆 Estimasi pesangon (terpisah)",
  "🏆 ប្រាក់បំណាច់អតីតភាពការងារប៉ាន់ស្មាន (ដាច់ដោយឡែក)",
  "🏆 Болжолдуу эмгек стажы үчүн компенсация (өзүнчө)",
  "🏆 เงินชดเชยการทำงานโดยประมาณ (แยกต่างหาก)",
  "🏆 تخمینی سروس گریجویٹی (علیحدہ)",
  "🏆 Tinatayang severance pay (hiwalay)",
  "🏆 Музди хидмати тахминӣ (алоҳида)",
);
const _daysEmployedSuffix = _S(
  '일 재직',
  ' days employed',
  '天在职',
  ' ngày làm việc',
  " ish kunlari",
  " çalışılan gün",
  " काम गरेको दिन",
  " loron servisu",
  " ມື້ເຮັດວຽກ",
  " ажилласан өдөр",
  " အလုပ်လုပ်ခဲ့သည့် ရက်ပေါင်း",
  " কাজের দিন",
  " වැඩ කළ දින",
  " hari kerja",
  " ថ្ងៃធ្វើការ",
  " иштелген күн",
  " วันที่ทำงาน",
  " کام کیے گئے دن",
  " araw na pinagtrabahuhan",
  " рӯзи корӣ",
);
const _severanceNote = _S(
  '임금과 별개로, 퇴직할 때 한 번 받는 돈입니다.',
  'This is a one-time payment received upon resignation, separate from wages.',
  '与工资无关，是离职时一次性领取的钱。',
  'Đây là khoản tiền nhận một lần khi nghỉ việc, tách biệt với lương.',
  "Bu ishdan boʻshatilganda olinadigan bir martalik toʻlov boʻlib, ish haqidan alohida hisoblanadi.",
  "Bu, istifa üzerine alınan, ücretten ayrı, tek seferlik bir ödemedir.",
  "यो राजीनामा दिएपछि प्राप्त हुने, तलबभन्दा छुट्टै, एक पटकको भुक्तानी हो।",
  "Ida ne'e pagamentu ida de'it, la inklui saláriu, ne'ebé simu bainhira rezigna.",
  "ນີ້ແມ່ນການຈ່າຍເງິນທີ່ໄດ້ຮັບເມື່ອລາອອກຈາກວຽກ, ແຍກຕ່າງຫາກຈາກຄ່າຈ້າງ, ເປັນການຈ່າຍເງິນຄັ້ງດຽວ.",
  "Энэ нь ажлаас халагдах үед цалингаас тусад нь олгодог нэг удаагийн төлбөр юм.",
  "၎င်းသည် လစာအပြင် အလုပ်မှနုတ်ထွက်သည့်အခါ တစ်ကြိမ်တည်းပေးသော ငွေဖြစ်သည်။",
  "এটি পদত্যাগের পর প্রাপ্ত এককালীন অর্থপ্রদান, যা বেতন থেকে আলাদা।",
  "මෙය ඉල්ලා අස්වීමෙන් පසු ලැබෙන, වැටුපට අමතරව, එක් වරක් ගෙවන මුදලකි.",
  "Ini adalah pembayaran satu kali yang diterima setelah pengunduran diri, terpisah dari gaji.",
  "នេះគឺជាការទូទាត់តែមួយដង ដែលទទួលបាននៅពេលលាលែងពីតំណែង ដាច់ដោយឡែកពីប្រាក់ឈ្នួល។",
  "Бул кызматтан кеткенде берилүүчү, айлыктан тышкары, бир жолку төлөм.",
  "นี่คือการจ่ายเงินครั้งเดียวที่ได้รับเมื่อลาออก ซึ่งแยกต่างหากจากค่าจ้าง",
  "یہ استعفیٰ دینے پر ملنے والی، تنخواہ سے علیحدہ، ایک بار کی ادائیگی ہے۔",
  "Ito ay isang beses na bayad na natatanggap sa pagbibitiw, hiwalay sa sahod.",
  "Ин пардохти якдафъаина аст, ки ҳангоми истеъфо гирифта мешавад ва аз музди меҳнат ҷудо аст.",
);
const _severanceExplainTitle = _S(
  '💬 퇴직금, 왜 그리고 얼마나 받아야 하는지 보기',
  '💬 See why and how much severance pay you should receive',
  '💬 查看为什么以及应获得多少退休金',
  '💬 Xem lý do và số tiền trợ cấp thôi việc bạn nên nhận',
  "💬 Nima uchun va qancha ishdan boʻshatish nafaqasi olishingiz kerakligini koʻring",
  "💬 Neden ve ne kadar kıdem tazminatı almanız gerektiğini görün",
  "💬 तपाईंले किन र कति सेवा निवृत्ति भत्ता पाउनुपर्छ हेर्नुहोस्",
  "💬 Haree tanba sá no hira mak Ita tenke simu indemnizasaun servisu",
  "💬 ເບິ່ງວ່າເປັນຫຍັງ ແລະ ທ່ານຄວນໄດ້ຮັບຄ່າຊົດເຊີຍການອອກຈາກວຽກເທົ່າໃດ",
  "💬 Та яагаад, хэр их тэтгэмж авах ёстойг харна уу",
  "💬 အလုပ်သက်တမ်းအလိုက် ဆုကြေးငွေကို အဘယ်ကြောင့်နှင့် မည်မျှရသင့်သည်ကို ကြည့်ပါ။",
  "💬 কেন এবং কত অবসরকালীন ভাতা আপনার প্রাপ্য তা দেখুন",
  "💬 ඔබට සේවා කාලය සඳහා ගෙවීමක් ලැබිය යුත්තේ ඇයි සහ කොපමණ දැයි බලන්න",
  "💬 Lihat mengapa dan berapa banyak pesangon yang seharusnya Anda terima",
  "💬 មើលថាហេតុអ្វី និងប៉ុន្មានដែលអ្នកគួរទទួលបានប្រាក់បំណាច់អតីតភាពការងារ",
  "💬 Эмне үчүн жана канча эмгек стажы үчүн компенсация алышыңыз керектигин көрүңүз",
  "💬 ดูว่าทำไมและเท่าไหร่ที่คุณควรได้รับเงินชดเชยการทำงาน",
  "💬 دیکھیں کہ آپ کو سروس گریجویٹی کیوں اور کتنی ملنی چاہیے",
  "💬 Tingnan kung bakit at magkano ang severance pay na dapat mong matanggap",
  "💬 Бубинед, ки чаро ва чӣ қадар музди хидмат бояд гиред",
);
const _severanceNotEligibleTitle = _S(
  '예상 퇴직금 (현재는 요건 미충족)',
  'Estimated severance pay (requirements not yet met)',
  '预计退休金（目前不符合条件）',
  'Trợ cấp thôi việc dự kiến (hiện chưa đủ điều kiện)',
  "Taxminiy ishdan boʻshatish nafaqasi (talablar hali bajarilmagan)",
  "Tahmini kıdem tazminatı (gereksinimler henüz karşılanmadı)",
  "अनुमानित सेवा निवृत्ति भत्ता (आवश्यकताहरू अझै पूरा भएका छैनन्)",
  "Estimativa indemnizasaun servisu (rekizitu seidauk kompletu)",
  "ຄ່າຊົດເຊີຍການອອກຈາກວຽກທີ່ຄາດຄະເນ (ເງື່ອນໄຂຍັງບໍ່ທັນບັນລຸ)",
  "Тооцоолсон тэтгэмж (шаардлага хараахан хангагдаагүй байна)",
  "ခန့်မှန်းခြေ အလုပ်သက်တမ်းအလိုက် ဆုကြေးငွေ (လိုအပ်ချက်များ မပြည့်မီသေးပါ)",
  "আনুমানিক অবসরকালীন ভাতা (প্রয়োজনীয়তা এখনো পূরণ হয়নি)",
  "ඇස්තමේන්තුගත සේවා කාලය සඳහා ගෙවීම (තවමත් අවශ්‍යතා සපුරා නැත)",
  "Estimasi pesangon (persyaratan belum terpenuhi)",
  "ប្រាក់បំណាច់អតីតភាពការងារប៉ាន់ស្មាន (លក្ខខណ្ឌមិនទាន់គ្រប់គ្រាន់)",
  "Болжолдуу эмгек стажы үчүн компенсация (талаптар азырынча аткарыла элек)",
  "เงินชดเชยการทำงานโดยประมาณ (ยังไม่เป็นไปตามข้อกำหนด)",
  "تخمینی سروس گریجویٹی (ضروریات ابھی پوری نہیں ہوئیں)",
  "Tinatayang severance pay (hindi pa natutugunan ang mga kinakailangan)",
  "Музди хидмати тахминӣ (талабот ҳанӯз иҷро нашудаанд)",
);
const _formulaDetailTitle = _S(
  '📐 법률 수식 상세보기',
  '📐 View detailed legal formulas',
  '📐 查看详细法律公式',
  '📐 Xem chi tiết công thức pháp lý',
  "📐 Batafsil huquqiy formulalarni koʻrish",
  "📐 Detaylı yasal formülleri görüntüle",
  "📐 विस्तृत कानूनी सूत्रहरू हेर्नुहोस्",
  "📐 Haree fórmula legál detallu",
  "📐 ເບິ່ງສູດຄິດໄລ່ທາງກົດໝາຍລະອຽດ",
  "📐 Хуулийн нарийвчилсан томьёог харах",
  "📐 အသေးစိတ် ဥပဒေဆိုင်ရာ ဖော်မြူလာများကို ကြည့်ပါ။",
  "📐 বিস্তারিত আইনি সূত্র দেখুন",
  "📐 සවිස්තරාත්මක නීතිමය සූත්‍ර බලන්න",
  "📐 Lihat formula hukum terperinci",
  "📐 មើលរូបមន្តច្បាប់លម្អិត",
  "📐 Толук укуктук формулаларды көрүү",
  "📐 ดูสูตรทางกฎหมายโดยละเอียด",
  "📐 تفصیلی قانونی فارمولے دیکھیں",
  "📐 Tingnan ang detalyadong legal na pormula",
  "📐 Формулаҳои муфассали ҳуқуқиро бубинед",
);
const _formulaHourly = _S(
  '• 통상시급: (월급/연봉) ÷ 월 유급시간(주 40시간 기준 209시간 등)',
  '• Ordinary hourly wage: (monthly/annual pay) ÷ monthly paid hours (e.g. 209 hours for a 40-hour week)',
  '• 通常时薪：（月薪/年薪）÷ 每月有薪时间（以每周40小时为准约209小时等）',
  '• Lương giờ thông thường: (lương tháng/năm) ÷ số giờ có lương trong tháng (ví dụ 209 giờ với tuần 40 giờ)',
  "• Oddiy soatlik ish haqi: (oylik/yillik ish haqi) ÷ oylik haq toʻlanadigan soatlar (masalan, 40 soatlik hafta uchun 209 soat)",
  "• Normal saatlik ücret: (aylık/yıllık maaş) ÷ aylık ödenen saatler (örn. 40 saatlik hafta için 209 saat)",
  "• सामान्य प्रतिघण्टा ज्याला: (मासिक/वार्षिक तलब) ÷ मासिक भुक्तानी गरिएका घण्टाहरू (जस्तै: 40 घण्टाको हप्ताको लागि 209 घण्टा)",
  "• Saláriu normál kada oras: (saláriu fulan/tinan) ÷ oras ne'ebé selu kada fulan (ez. 209 oras ba semana ida ho oras 40)",
  "• ຄ່າຈ້າງລາຍຊົ່ວໂມງປົກກະຕິ: (ເງິນເດືອນ/ເງິນປີ) ÷ ຊົ່ວໂມງທີ່ຈ່າຍຕໍ່ເດືອນ (ຕົວຢ່າງ: 209 ຊົ່ວໂມງ ສຳລັບອາທິດລະ 40 ຊົ່ວໂມງ)",
  "• Ердийн цагийн хөлс: (сарын/жилийн цалин) ÷ сард төлөгдсөн цаг (жишээ нь, 40 цагийн долоо хоногт 209 цаг)",
  "• ပုံမှန်နာရီလုပ်ခ- (လစဉ်/နှစ်စဉ်လစာ) ÷ လစဉ်ပေးချေသည့် နာရီ (ဥပမာ- 40 နာရီအလုပ်ရက်သတ္တပတ်အတွက် 209 နာရီ)",
  "• স্বাভাবিক প্রতি ঘণ্টার মজুরি: (মাসিক/বার্ষিক বেতন) ÷ মাসিক পরিশোধিত ঘণ্টা (যেমন, 40 ঘণ্টার সপ্তাহের জন্য 209 ঘণ্টা)",
  "• සාමාන්‍ය පැයක වැටුප: (මාසික/වාර්ෂික වැටුප) ÷ මාසිකව ගෙවන පැය ගණන (උදා: 40 පැය සතියක් සඳහා 209 පැය)",
  "• Upah per jam normal: (gaji bulanan/tahunan) ÷ jam kerja bulanan (misalnya 40 jam untuk minggu kerja 209 jam)",
  "• អត្រាប្រាក់ឈ្នួលធម្មតាប្រចាំម៉ោង៖ (ប្រាក់ខែប្រចាំខែ/ប្រចាំឆ្នាំ) ÷ ម៉ោងដែលបានបង់ប្រចាំខែ (ឧទាហរណ៍ 40 ម៉ោងសម្រាប់សប្តាហ៍ 209 ម៉ោង)",
  "• Кадимки сааттык эмгек акы: (айлык/жылдык эмгек акы) ÷ айлык төлөнүүчү сааттар (мис., 40 сааттык жума үчүн 209 саат)",
  "• ค่าจ้างรายชั่วโมงปกติ: (เงินเดือนรายเดือน/รายปี) ÷ ชั่วโมงที่ได้รับค่าจ้างต่อเดือน (เช่น 40 ชั่วโมงสำหรับสัปดาห์ทำงาน 209 ชั่วโมง)",
  "• عام فی گھنٹہ اجرت: (ماہانہ/سالانہ تنخواہ) ÷ ماہانہ ادا کیے گئے گھنٹے (مثلاً 40 گھنٹے کے ہفتے کے لیے 209 گھنٹے)",
  "• Normal na orasang sahod: (buwanan/taunang suweldo) ÷ oras na binayaran kada buwan (hal. 209 oras para sa 40 oras na linggo)",
  "• Музди меҳнати муқаррарии соатбайъ: (маоши моҳона/солона) ÷ соатҳои пардохтшудаи моҳона (масалан, 209 соат барои ҳафтаи 40-соата)",
);
const _formulaWeekly = _S(
  '• 주휴수당: (주 소정근로시간 ÷ 40) × 8h × 통상시급 × 4.345주',
  '• Weekly paid holiday allowance: (weekly contracted hours ÷ 40) × 8h × ordinary hourly wage × 4.345 weeks',
  '• 周休津贴：（每周约定工作时间 ÷ 40）× 8小时 × 通常时薪 × 4.345周',
  '• Phụ cấp ngày nghỉ có lương hàng tuần: (giờ làm việc theo hợp đồng hàng tuần ÷ 40) × 8h × lương giờ thông thường × 4.345 tuần',
  "• Haftalik haq toʻlanadigan taʼtil nafaqasi: (haftalik shartnoma soatlari ÷ 40) × 8 soat × oddiy soatlik ish haqi × 4.345 hafta",
  "• Haftalık ücretli tatil ödeneği: (haftalık sözleşmeli saatler ÷ 40) × 8s × normal saatlik ücret × 4.345 hafta",
  "• साप्ताहिक सशुल्क बिदा भत्ता: (साप्ताहिक अनुबंधित घण्टाहरू ÷ 40) × 8 घण्टा × सामान्य प्रतिघण्टा ज्याला × 4.345 हप्ता",
  "• Subsídiu férias selu kada semana: (oras kontratu semana nian ÷ 40) × 8s × saláriu normál kada oras × 4.345 semana",
  "• ເງິນອຸດໜູນວັນພັກທີ່ໄດ້ຮັບຄ່າຈ້າງລາຍອາທິດ: (ຊົ່ວໂມງຕາມສັນຍາລາຍອາທິດ ÷ 40) × 8 ຊົ່ວໂມງ × ຄ່າຈ້າງລາຍຊົ່ວໂມງປົກກະຕິ × 4.345 ອາທິດ",
  "• Долоо хоногийн цалинтай амралтын тэтгэмж: (долоо хоногийн гэрээт цаг ÷ 40) × 8 цаг × ердийн цагийн хөлс × 4.345 долоо хоног",
  "• အပတ်စဉ် အခကြေးငွေရုံးပိတ်ရက်စရိတ်- (အပတ်စဉ် သဘောတူညီထားသော နာရီ ÷ 40) × 8 နာရီ × ပုံမှန်နာရီလုပ်ခ × 4.345 ပတ်",
  "• সাপ্তাহিক বেতনসহ ছুটির ভাতা: (সাপ্তাহিক চুক্তিবদ্ধ ঘণ্টা ÷ 40) × 8s × স্বাভাবিক প্রতি ঘণ্টার মজুরি × 4.345 সপ্তাহ",
  "• සතිපතා වැටුප් සහිත නිවාඩු දීමනාව: (සතිපතා කොන්ත්‍රාත්ගත පැය ගණන ÷ 40) × 8s × සාමාන්‍ය පැයක වැටුප × 4.345 සති",
  "• Tunjangan liburan berbayar mingguan: (jam kontrak mingguan ÷ 40) × 8 jam × upah per jam normal × 4.345 minggu",
  "• ប្រាក់ឧបត្ថម្ភឈប់សម្រាកប្រចាំសប្តាហ៍៖ (ម៉ោងកិច្ចសន្យាប្រចាំសប្តាហ៍ ÷ 40) × 8s × អត្រាប្រាក់ឈ្នួលធម្មតាប្រចាំម៉ោង × 4.345 សប្តាហ៍",
  "• Жумалык акы төлөнүүчү эс алуу жөлөкпулу: (жумалык келишимдик сааттар ÷ 40) × 8с × кадимки сааттык эмгек акы × 4.345 жума",
  "• ค่าจ้างวันหยุดประจำสัปดาห์: (ชั่วโมงตามสัญญาต่อสัปดาห์ ÷ 40) × 8 ชั่วโมง × ค่าจ้างรายชั่วโมงปกติ × 4.345 สัปดาห์",
  "• ہفتہ وار ادا شدہ چھٹی کا الاؤنس: (ہفتہ وار معاہدہ شدہ گھنٹے ÷ 40) × 8s × عام فی گھنٹہ اجرت × 4.345 ہفتے",
  "• Lingguhang bayad na holiday allowance: (lingguhang kontratadong oras ÷ 40) × 8s × normal na orasang sahod × 4.345 linggo",
  "• Иҷозатномаи рухсатии ҳафтаинаи пулакӣ: (соатҳои шартномавии ҳафтаина ÷ 40) × 8с × музди меҳнати муқаррарии соатбайъ × 4.345 ҳафта",
);
const _formulaExtra = _S(
  '• 가산수당: 5인 이상 사업장 연장 1.5배 · 야간 0.5배(가산분) · 휴일 1.5배',
  '• Extra pay: 1.5× overtime, 0.5× night (additional portion), 1.5× holiday at workplaces with 5+ employees',
  '• 加成津贴：5人以上企业延长劳动1.5倍·夜间0.5倍（加成部分）·假日1.5倍',
  '• Phụ cấp thêm: 1.5 lần làm thêm giờ, 0.5 lần ban đêm (phần thêm), 1.5 lần ngày lễ tại nơi có từ 5 nhân viên trở lên',
  "• Qoʻshimcha toʻlov: 5+ xodimga ega ish joylarida 1.5× ishdan tashqari vaqt, 0.5× tun (qoʻshimcha qism), 1.5× bayram",
  "• Ek ödeme: 1.5× fazla mesai, 0.5× gece (ek kısım), 5+ çalışanı olan işyerlerinde 1.5× tatil",
  "• अतिरिक्त भुक्तानी: 1.5 गुणा ओभरटाइम, 0.5 गुणा रात (अतिरिक्त भाग), 5+ कर्मचारी भएका कार्यस्थलहरूमा 1.5 गुणा बिदा",
  "• Pagamentu adisionál: 1.5× oras estra, 0.5× kalan (parte adisionál), 1.5× feriadu iha fatin servisu ho empregadu 5+",
  "• ການຈ່າຍເງິນເພີ່ມເຕີມ: ລ່ວງເວລາ 1.5 ເທົ່າ, ກາງຄືນ 0.5 ເທົ່າ (ສ່ວນເພີ່ມເຕີມ), ວັນພັກ 1.5 ເທົ່າ ໃນບ່ອນເຮັດວຽກທີ່ມີພະນັກງານ 5+ ຄົນ",
  "• Нэмэлт төлбөр: 1.5× илүү цаг, 0.5× шөнийн (нэмэлт хэсэг), 5+ ажилтантай ажлын байранд 1.5× амралт",
  "• အပိုဆောင်းပေးချေမှု- အချိန်ပိုအတွက် 1.5 ဆ၊ ညဘက်အတွက် 0.5 ဆ (အပိုအပိုင်း)၊ ဝန်ထမ်း 5 ဦးနှင့်အထက်ရှိသော လုပ်ငန်းခွင်များတွင် ရုံးပိတ်ရက်အတွက် 1.5 ဆ",
  "• অতিরিক্ত অর্থপ্রদান: 1.5× ওভারটাইম, 0.5× রাত (অতিরিক্ত অংশ), 5+ কর্মচারী আছে এমন কর্মস্থলে 1.5× ছুটি",
  "• අමතර ගෙවීම්: අතිකාල සඳහා 1.5×, රාත්‍රී කාලය සඳහා 0.5× (අමතර කොටස), සේවකයින් 5+ සිටින සේවා ස්ථානවල නිවාඩු සඳහා 1.5×",
  "• Pembayaran tambahan: 1.5× lembur, 0.5× malam (bagian tambahan), 5× hari libur di tempat kerja dengan lebih dari 1.5 karyawan",
  "• ការទូទាត់បន្ថែម៖ 1.5× ម៉ោងបន្ថែម, 0.5× ពេលយប់ (ផ្នែកបន្ថែម), 5+ ថ្ងៃឈប់សម្រាក 1.5× នៅកន្លែងធ្វើការដែលមានបុគ្គលិក",
  "• Кошумча төлөм: 1.5× ашыкча иштөө, 0.5× түнкү (кошумча бөлүгү), 5+ кызматкери бар ишканаларда 1.5× майрам",
  "• การจ่ายเงินเพิ่มเติม: 1.5× ค่าล่วงเวลา, 0.5× กลางคืน (ส่วนเพิ่มเติม), 5× วันหยุดในสถานประกอบการที่มีพนักงาน 1.5+ คน",
  "• اضافی ادائیگی: 1.5× اوور ٹائم، 0.5× رات (اضافی حصہ)، 5+ ملازمین والی جگہوں پر 1.5× چھٹی",
  "• Karagdagang bayad: 1.5× overtime, 0.5× gabi (karagdagang bahagi), 5× holiday sa mga lugar ng trabaho na may 1.5+ na empleyado",
  "• Пардохти иловагӣ: 1.5× изофакорӣ, 0.5× шабона (қисми иловагӣ), 5+ дар ҷойҳои корӣ бо кормандон 1.5× ид",
);
const _formulaSeverance = _S(
  '• 퇴직금: 1일 평균임금 × 30일 × (재직일수 ÷ 365), 평균임금이 통상임금보다 낮으면 통상임금 적용',
  '• Severance pay: average daily wage × 30 days × (days employed ÷ 365); if the average wage is lower than the ordinary wage, the ordinary wage applies',
  '• 退休金：日平均工资 × 30天 ×（在职天数 ÷ 365），若平均工资低于通常工资则适用通常工资',
  '• Trợ cấp thôi việc: lương bình quân 1 ngày × 30 ngày × (số ngày làm việc ÷ 365); nếu lương bình quân thấp hơn lương thông thường thì áp dụng lương thông thường',
  "• Ishdan boʻshatish nafaqasi: oʻrtacha kunlik ish haqi × 30 kun × (ish kunlari ÷ 365); agar oʻrtacha ish haqi oddiy ish haqidan past boʻlsa, oddiy ish haqi qoʻllaniladi",
  "• Kıdem tazminatı: ortalama günlük ücret × 30 gün × (çalışılan gün sayısı ÷ 365); eğer ortalama ücret normal ücretten düşükse, normal ücret uygulanır",
  "• सेवा निवृत्ति भत्ता: औसत दैनिक ज्याला × 30 दिन × (काम गरेको दिन संख्या ÷ 365); यदि औसत ज्याला सामान्य ज्यालाभन्दा कम छ भने, सामान्य ज्याला लागू हुन्छ",
  "• Indemnizasaun servisu: saláriu diáriu médiu × 30 loron × (númeru loron servisu ÷ 365); se saláriu médiu menus husi saláriu normál, saláriu normál mak aplika",
  "• ຄ່າຊົດເຊີຍການອອກຈາກວຽກ: ຄ່າຈ້າງສະເລ່ຍຕໍ່ມື້ × 30 ມື້ × (ຈຳນວນມື້ເຮັດວຽກ ÷ 365); ຖ້າຄ່າຈ້າງສະເລ່ຍຕໍ່າກວ່າຄ່າຈ້າງປົກກະຕິ, ຈະນຳໃຊ້ຄ່າຈ້າງປົກກະຕິ.",
  "• Тэтгэмж: дундаж өдрийн цалин × 30 өдөр × (ажилласан өдрийн тоо ÷ 365); хэрэв дундаж цалин ердийн цалингаас бага бол ердийн цалин хэрэглэгдэнэ",
  "• အလုပ်သက်တမ်းအလိုက် ဆုကြေးငွေ- ပျမ်းမျှနေ့စဉ်လုပ်ခ × 30 ရက် × (အလုပ်လုပ်ခဲ့သည့် ရက်အရေအတွက် ÷ 365); ပျမ်းမျှလုပ်ခသည် ပုံမှန်လုပ်ခထက် နည်းပါက ပုံမှန်လုပ်ခကို အသုံးပြုသည်",
  "• অবসরকালীন ভাতা: গড় দৈনিক মজুরি × 30 দিন × (কাজের দিনের সংখ্যা ÷ 365); যদি গড় মজুরি স্বাভাবিক মজুরির চেয়ে কম হয়, তবে স্বাভাবিক মজুরি প্রযোজ্য হবে",
  "• සේවා කාලය සඳහා ගෙවීම: සාමාන්‍ය දෛනික වැටුප × 30 දින × (වැඩ කළ දින ගණන ÷ 365); සාමාන්‍ය වැටුප සාමාන්‍ය වැටුපට වඩා අඩු නම්, සාමාන්‍ය වැටුප අදාළ වේ",
  "• Pesangon: upah harian rata-rata × 30 hari × (jumlah hari kerja ÷ 365); jika upah rata-rata lebih rendah dari upah normal, upah normal akan diterapkan",
  "• ប្រាក់បំណាច់អតីតភាពការងារ៖ ប្រាក់ឈ្នួលប្រចាំថ្ងៃជាមធ្យម × 30 ថ្ងៃ × (ចំនួនថ្ងៃធ្វើការ ÷ 365); ប្រសិនបើប្រាក់ឈ្នួលជាមធ្យមទាបជាងប្រាក់ឈ្នួលធម្មតា នោះប្រាក់ឈ្នួលធម្មតាត្រូវបានអនុវត្ត",
  "• Эмгек стажы үчүн компенсация: орточо күндүк эмгек акы × 30 күн × (иштелген күндөрдүн саны ÷ 365); эгер орточо эмгек акы кадимки эмгек акыдан төмөн болсо, кадимки эмгек акы колдонулат",
  "• เงินชดเชยการทำงาน: ค่าจ้างรายวันเฉลี่ย × 30 วัน × (จำนวนวันที่ทำงาน ÷ 365); หากค่าจ้างเฉลี่ยต่ำกว่าค่าจ้างปกติ ให้ใช้ค่าจ้างปกติ",
  "• سروس گریجویٹی: اوسط یومیہ اجرت × 30 دن × (کام کیے گئے دنوں کی تعداد ÷ 365)؛ اگر اوسط اجرت عام اجرت سے کم ہو تو عام اجرت لاگو ہوگی",
  "• Severance pay: average na pang-araw-araw na sahod × 30 araw × (bilang ng araw na pinagtrabahuhan ÷ 365); kung ang average na sahod ay mas mababa kaysa sa normal na sahod, ang normal na sahod ang ilalapat",
  "• Музди хидмат: музди миёнаи рӯзона × 30 рӯз × (шумораи рӯзҳои корӣ ÷ 365); агар музди миёна аз музди муқаррарӣ камтар бошад, музди муқаррарӣ татбиқ мешавад",
);
const _legalNoticeTitle = _S(
  '⚠ 이 금액은 참고용 예상액입니다 (법적 고지)',
  '⚠ This amount is a reference estimate (legal notice)',
  '⚠ 此金额仅为参考估算值（法律声明）',
  '⚠ Số tiền này chỉ là ước tính tham khảo (thông báo pháp lý)',
  "⚠ Bu summa maʼlumotnoma hisobi (huquqiy ogohlantirish)",
  "⚠ Bu miktar bir referans tahmindir (yasal uyarı)",
  "⚠ यो रकम एक सन्दर्भ अनुमान हो (कानूनी चेतावनी)",
  "⚠ Montante ne'e estimativa referénsia ida (avizu legál)",
  "⚠ ຈຳນວນນີ້ແມ່ນການຄາດຄະເນເພື່ອອ້າງອີງ (ຄຳເຕືອນທາງກົດໝາຍ)",
  "⚠ Энэ хэмжээ нь зөвхөн лавлагааны тооцоо юм (хуулийн анхааруулга)",
  "⚠ ဤပမာဏသည် ခန့်မှန်းခြေသာဖြစ်သည် (ဥပဒေဆိုင်ရာ သတိပေးချက်)",
  "⚠ এই পরিমাণটি একটি রেফারেন্স অনুমান (আইনি সতর্কতা)",
  "⚠ මෙම මුදල යොමු ඇස්තමේන්තුවකි (නීතිමය වියාචනය)",
  "⚠ Jumlah ini adalah perkiraan referensi (penafian hukum)",
  "⚠ ចំនួននេះគឺជាការប៉ាន់ស្មានយោង (ការបដិសេធការទទួលខុសត្រូវផ្នែកច្បាប់)",
  "⚠ Бул сумма болжолдуу маалымат (укуктук эскертүү)",
  "⚠ จำนวนเงินนี้เป็นการประมาณการอ้างอิง (ข้อจำกัดความรับผิดชอบทางกฎหมาย)",
  "⚠ یہ رقم ایک حوالہ جاتی تخمینہ ہے (قانونی انتباہ)",
  "⚠ Ang halagang ito ay isang tinatayang sanggunian (legal na disclaimer)",
  "⚠ Ин маблағ тахмини истинодӣ аст (огоҳии ҳуқуқӣ)",
);
const _legalNoticeBody = _S(
  '본 계산기는 근로기준법 표준 공식을 적용한 추정치입니다. 사업장의 특수 근로조건에 따라 차이가 발생할 수 있으며, 법적 확정 효력을 갖지 않습니다. 정확한 체불액은 근로감독관 조사에서 산정됩니다.',
  'This calculator provides an estimate based on standard Labor Standards Act formulas. Actual amounts may differ depending on the workplace\'s specific conditions, and this has no legally binding effect. The exact unpaid amount is determined through an investigation by a labor inspector.',
  '本计算器是应用《劳动基准法》标准公式得出的估算值。根据工作场所的特殊劳动条件可能会有所不同，不具有法律确定效力。准确的拖欠金额将在劳动监督官调查中确定。',
  'Máy tính này đưa ra ước tính dựa trên công thức tiêu chuẩn của Luật Tiêu chuẩn Lao động. Số tiền thực tế có thể khác nhau tùy theo điều kiện lao động đặc thù của nơi làm việc và không có hiệu lực pháp lý xác định. Số tiền nợ lương chính xác sẽ được xác định qua điều tra của thanh tra lao động.',
  "Bu kalkulyator Mehnat standartlari toʻgʻrisidagi qonunning standart formulalari asosida hisob-kitobni taqdim etadi. Haqiqiy miqdorlar ish joyining oʻziga xos sharoitlariga qarab farq qilishi mumkin va bu qonuniy kuchga ega emas. Toʻlanmagan aniq miqdor mehnat inspektori tomonidan tekshiruv orqali aniqlanadi.",
  "Bu hesaplayıcı, standart İş Kanunu formüllerine dayanarak bir tahmin sunar. Gerçek miktarlar, işyerinin özel koşullarına göre farklılık gösterebilir ve bunun yasal bağlayıcılığı yoktur. Tam ödenmemiş miktar, bir iş müfettişi tarafından yapılan soruşturma ile belirlenir.",
  "यो क्यालकुलेटरले मानक श्रम कानून सूत्रहरूमा आधारित अनुमान प्रदान गर्दछ। वास्तविक रकमहरू कार्यस्थलको विशेष परिस्थिति अनुसार फरक हुन सक्छन् र यसको कुनै कानूनी बाध्यता छैन। पूर्ण भुक्तानी नभएको रकम श्रम निरीक्षकद्वारा गरिने अनुसन्धानबाट निर्धारण गरिन्छ।",
  "Kalkuladór ne'e fornese estimativa ida bazeia ba fórmula Lei Traballu padraun. Montante reál bele la hanesan tuir kondisaun espesífika fatin servisu nian no la iha obrigasaun legál. Montante ne'ebé la selu tomak sei determina liuhusi investigasaun husi inspetór traballu nian.",
  "ເຄື່ອງຄິດໄລ່ນີ້ສະໜອງການຄາດຄະເນໂດຍອີງໃສ່ສູດມາດຕະຖານຂອງກົດໝາຍແຮງງານ. ຈຳນວນຕົວຈິງອາດແຕກຕ່າງກັນໄປຕາມເງື່ອນໄຂສະເພາະຂອງບ່ອນເຮັດວຽກ ແລະບໍ່ມີຜົນຜູກພັນທາງກົດໝາຍ. ຈຳນວນທີ່ຍັງບໍ່ໄດ້ຈ່າຍເຕັມຈະຖືກກຳນົດໂດຍການສືບສວນຂອງເຈົ້າໜ້າທີ່ກວດກາແຮງງານ.",
  "Энэ тооцоолуур нь Хөдөлмөрийн тухай хуулийн стандарт томьёонд үндэслэн тооцоог гаргадаг. Бодит хэмжээ нь ажлын байрны онцгой нөхцөл байдлаас хамаарч өөр байж болох бөгөөд энэ нь хууль ёсны хүчин төгөлдөр бус юм. Төлөгдөөгүй бодит хэмжээг хөдөлмөрийн байцаагчийн шалгалтаар тогтооно.",
  "ဤဂဏန်းတွက်စက်သည် စံလုပ်သားဥပဒေဖော်မြူလာများအပေါ် အခြေခံ၍ ခန့်မှန်းချက်ကို ပေးပါသည်။ အမှန်တကယ်ပမာဏသည် လုပ်ငန်းခွင်၏ သီးခြားအခြေအနေများပေါ် မူတည်၍ ကွဲပြားနိုင်ပြီး ဥပဒေအရ အတည်မပြုနိုင်ပါ။ အပြည့်အဝမပေးချေရသေးသော ပမာဏကို အလုပ်သမားစစ်ဆေးရေးမှူးမှ စုံစမ်းစစ်ဆေးပြီးနောက် ဆုံးဖြတ်မည်ဖြစ်သည်။",
  "এই ক্যালকুলেটরটি স্ট্যান্ডার্ড শ্রম আইন সূত্রগুলির উপর ভিত্তি করে একটি অনুমান প্রদান করে। প্রকৃত পরিমাণ কর্মস্থলের নির্দিষ্ট পরিস্থিতি অনুযায়ী ভিন্ন হতে পারে এবং এটি আইনত বাধ্যতামূলক নয়। সম্পূর্ণ অপরিশোধিত পরিমাণ একজন শ্রম পরিদর্শক দ্বারা তদন্তের মাধ্যমে নির্ধারিত হয়।",
  "මෙම කැල්කියුලේටරය සම්මත කම්කරු නීති සූත්‍ර මත පදනම්ව ඇස්තමේන්තුවක් සපයයි. සැබෑ මුදල් සේවා ස්ථානයේ නිශ්චිත තත්වයන් අනුව වෙනස් විය හැකි අතර මෙය නීත්‍යානුකූලව බැඳී නොමැත. සම්පූර්ණ නොගෙවූ මුදල කම්කරු පරීක්ෂකවරයෙකු විසින් කරන ලද පරීක්ෂණයකින් තීරණය කරනු ලැබේ.",
  "Kalkulator ini memberikan perkiraan berdasarkan formula standar Undang-Undang Ketenagakerjaan. Jumlah sebenarnya dapat bervariasi tergantung pada kondisi spesifik tempat kerja dan tidak memiliki kekuatan hukum. Jumlah pasti yang belum dibayar akan ditentukan melalui penyelidikan oleh inspektur ketenagakerjaan.",
  "ម៉ាស៊ីនគិតលេខនេះផ្តល់ការប៉ាន់ស្មានដោយផ្អែកលើរូបមន្តស្តង់ដារនៃច្បាប់ការងារ។ ចំនួនពិតប្រាកដអាចខុសគ្នាអាស្រ័យលើលក្ខខណ្ឌជាក់លាក់នៃកន្លែងធ្វើការ ហើយនេះមិនមានកាតព្វកិច្ចផ្លូវច្បាប់ទេ។ ចំនួនទឹកប្រាក់ដែលមិនបានបង់ពេញលេញត្រូវបានកំណត់ដោយការស៊ើបអង្កេតដោយអធិការការងារ។",
  "Бул эсептегич стандарттык Эмгек Мыйзамынын формулаларына негизделген болжолдуу маалыматты берет. Чыныгы суммалар жумуш ордунун өзгөчө шарттарына жараша айырмаланышы мүмкүн жана бул юридикалык жактан милдеттүү эмес. Толук төлөнбөгөн сумма эмгек инспектору тарабынан жүргүзүлгөн иликтөө аркылуу аныкталат.",
  "เครื่องคำนวณนี้ให้การประมาณการตามสูตรมาตรฐานของกฎหมายแรงงาน จำนวนเงินจริงอาจแตกต่างกันไปขึ้นอยู่กับสถานการณ์เฉพาะของสถานที่ทำงาน และไม่มีผลผูกพันทางกฎหมาย จำนวนเงินที่ยังไม่ได้รับทั้งหมดจะถูกกำหนดโดยการสอบสวนของสารวัตรแรงงาน",
  "یہ کیلکولیٹر معیاری لیبر قانون کے فارمولوں کی بنیاد پر ایک تخمینہ پیش کرتا ہے۔ اصل رقم کام کی جگہ کے مخصوص حالات کے مطابق مختلف ہو سکتی ہے اور یہ قانونی طور پر پابند نہیں ہے۔ مکمل غیر ادا شدہ رقم کا تعین لیبر انسپکٹر کی تحقیقات سے ہوتا ہے۔",
  "Ang calculator na ito ay nagbibigay ng pagtatantya batay sa karaniwang pormula ng Labor Standards Act. Ang aktwal na halaga ay maaaring mag-iba depende sa partikular na sitwasyon ng lugar ng trabaho at hindi ito legal na umiiral. Ang eksaktong halaga na hindi nabayaran ay matutukoy sa pamamagitan ng imbestigasyon ng isang labor inspector.",
  "Ин ҳисобкунак тахминро дар асоси формулаҳои стандартии Қонуни меҳнат пешниҳод мекунад. Маблағҳои воқеӣ метавонанд вобаста ба шароити мушаххаси ҷои кор фарқ кунанд ва ин ҳеҷ гуна қувваи қонунӣ надорад. Маблағи пурраи пардохтнашуда тавассути тафтишоти нозири меҳнат муайян карда мешавад.",
);

String _formatWonOrText(num value, _S zeroText, AppLanguage lang) =>
    value > 0 ? formatWon(value, lang) : zeroText.of(lang);

/// 계산 결과 카드. 프론트엔드_계산기_최종.html(v6)의 resultHTML()을 그대로 옮겼다.
class WageResultCard extends StatelessWidget {
  const WageResultCard({
    super.key,
    required this.input,
    required this.result,
    required this.language,
    required this.onOpenWageNavigator,
    required this.onFindNearbyOrgs,
  });

  final WageCalcInput input;
  final WageCalcResult result;
  final AppLanguage language;
  final VoidCallback onOpenWageNavigator;
  final VoidCallback onFindNearbyOrgs;

  void _openHelp(BuildContext context, String key) {
    final entry = buildHelpDict(language)[key];
    if (entry == null) return;
    showWageHelp(context, entry.title, entry.body(context), language);
  }

  void _openAiDiagnosis(BuildContext context) {
    showWageHelp(
      context,
      _aiDiagnosisTitle.of(language),
      RichNote(
        explainGap(input, result, language),
        style: const TextStyle(
          fontSize: 11.5,
          color: AppColors.textSecondary,
          height: 1.7,
        ),
      ),
      language,
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = language;
    final r = result;
    final gapVal = r.gapValue;
    final isZero = gapVal.abs() < 10000;
    final isPos = !isZero && gapVal > 0;
    final isNeg = !isZero && gapVal < 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 데모 워터마크
        Container(
          margin: const EdgeInsets.only(bottom: 9),
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _watermark.of(lang),
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0D47A1),
            ),
          ),
        ),

        // 항목별 산출 내역 (짙은 네이비 카드)
        Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(bottom: 11),
          decoration: BoxDecoration(
            color: const Color(0xFF0D47A1),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${_resultTitle(lang)} (${input.periodLabel(lang)})',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF90CAF9),
                      ),
                    ),
                  ),
                  Text(
                    _noticeYearText(lang),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF90CAF9),
                    ),
                  ),
                ],
              ),
              const Divider(height: 18, color: Color(0x17FFFFFF)),
              _ResRow(
                label: _basePay.of(lang),
                value: formatWon(r.baseTotal, lang),
                onHelp: () => _openHelp(context, 'logic_base'),
              ),
              if (!r.weeklyIncluded)
                _ResRow(
                  label: _weeklyAllowance.of(lang),
                  value: _formatWonOrText(
                    r.weeklyPayTotal,
                    _notApplicable,
                    lang,
                  ),
                  zero: r.weeklyPayTotal <= 0,
                  onHelp: () => _openHelp(context, 'logic_week'),
                ),
              _ResRow(
                label: _overtimeAllowance.of(lang),
                value: r.otPay > 0
                    ? formatWon(r.otPay, lang)
                    : formatWon(0, lang),
                zero: r.otPay <= 0,
                onHelp: () => _openHelp(context, 'ot_info'),
              ),
              _ResRow(
                label: _nightAllowance.of(lang),
                value: r.ntPay > 0
                    ? formatWon(r.ntPay, lang)
                    : formatWon(0, lang),
                zero: r.ntPay <= 0,
                onHelp: () => _openHelp(context, 'nt_info'),
              ),
              if (r.holPay > 0)
                _ResRow(
                  label: _holidayAllowance.of(lang),
                  value: formatWon(r.holPay, lang),
                  onHelp: () => _openHelp(context, 'hol_info'),
                ),

              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 8),
                padding: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0x5990CAF9))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Row(
                      children: [
                        Text(
                          _grossTotal.of(lang),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF90CAF9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        _DarkQMark(
                          onTap: () => _openHelp(context, 'logic_gross'),
                        ),
                      ],
                    ),
                    Text(
                      formatWon(r.gross, lang),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              if (input.tax == TaxMethod.unknown) ...[
                _SubHead(_ifFourInsurance.of(lang)),
                _ResRow(
                  label: taxLabelOf(TaxMethod.four, insuranceRate(), lang),
                  value: '− ${formatWon(r.taxAmtFour!, lang)}',
                  onHelp: () => _openHelp(context, 'tax_info'),
                ),
                if (input.roomOn)
                  _ResRow(
                    label: _roomDeduction.of(lang),
                    value: '− ${formatWon(r.roomAmtTotal, lang)}',
                  ),
                _NetRow(
                  label: _expectedNet.of(lang),
                  value: formatWon(r.netFour!, lang),
                ),
                _SubHead(_ifBizTax.of(lang)),
                _ResRow(
                  label: _bizTaxDeduction.of(lang),
                  value: '− ${formatWon(r.taxAmtBiz!, lang)}',
                ),
                if (input.roomOn)
                  _ResRow(
                    label: _roomDeduction.of(lang),
                    value: '− ${formatWon(r.roomAmtTotal, lang)}',
                  ),
                _NetRow(
                  label: _expectedNet.of(lang),
                  value: formatWon(r.netBiz!, lang),
                ),
              ] else ...[
                _ResRow(
                  label: taxLabelOf(input.tax, r.taxRate, lang),
                  value: r.taxAmt! > 0
                      ? '− ${formatWon(r.taxAmt!, lang)}'
                      : formatWon(0, lang),
                  zero: r.taxAmt! <= 0,
                  onHelp: () => _openHelp(context, 'tax_info'),
                ),
                _ResRow(
                  label: _roomDeduction.of(lang),
                  value: r.roomAmtTotal > 0
                      ? '− ${formatWon(r.roomAmtTotal, lang)}'
                      : formatWon(0, lang),
                  zero: r.roomAmtTotal <= 0,
                ),
                _NetRow(
                  label: _expectedNet.of(lang),
                  value: formatWon(r.net!, lang),
                  onHelp: () => _openHelp(context, 'logic_net'),
                ),
              ],
            ],
          ),
        ),

        if (r.payBelowMin)
          RedNotice(
            title: _belowMinTitle.of(lang),
            body: _payBelowMinBody(r, lang),
          ),

        // 차액 카드 + AI 진단
        Container(
          margin: const EdgeInsets.only(bottom: 11),
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: isZero
                ? const Color(0xFFE8F5E9)
                : isNeg
                ? const Color(0xFFE3F2FD)
                : const Color(0xFFE3F2FD),
            border: Border.all(
              color: isZero
                  ? const Color(0xFFA5D6A7)
                  : isNeg
                  ? const Color(0xFF90CAF9)
                  : const Color(0xFF90CAF9),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isZero
                    ? _similarAmount.of(lang)
                    : (isPos
                          ? _lessThanExpected.of(lang)
                          : _moreThanCalculated.of(lang)),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: isZero
                      ? const Color(0xFF1B5E20)
                      : isNeg
                      ? const Color(0xFF0D47A1)
                      : const Color(0xFF0D47A1),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _gapLabel.of(lang),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    isZero
                        ? '±${formatWon(0, lang)}'
                        : '${gapVal > 0 ? '+' : '−'}${formatWon(gapVal.abs(), lang)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isZero
                          ? const Color(0xFF1B5E20)
                          : isNeg
                          ? const Color(0xFF0D47A1)
                          : const Color(0xFF0D47A1),
                    ),
                  ),
                ],
              ),
              if (!isZero) ...[
                const SizedBox(height: 9),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _openAiDiagnosis(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.7),
                      foregroundColor: isNeg
                          ? const Color(0xFF0D47A1)
                          : const Color(0xFF0D47A1),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: Text(
                      isPos
                          ? _aiDiagnosisPositive.of(lang)
                          : _aiDiagnosisNegative.of(lang),
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        // 체불 의심일 때만 다음 행동 유도(이 앱은 진정 내비게이터·기관 조회가 실제로
        // 연동되어 있어, v6 원본의 "연동 예정" 비활성 버튼 대신 바로 동작하게 한다).
        if (isPos) ...[
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onOpenWageNavigator,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                  child: Text(
                    _autoMapComplaint.of(lang),
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: onFindNearbyOrgs,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                  child: Text(
                    _findNearbyOrgs.of(lang),
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
        ],

        // 퇴직금
        if (r.eligible) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              border: Border.all(color: const Color(0xFFA5D6A7)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              '${_severanceHeader.of(lang)} · ${r.days}${_daysEmployedSuffix.of(lang)}',
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1B5E20),
                              ),
                            ),
                          ),
                          QMark(
                            onTap: () => _openHelp(context, 'severance_intro'),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      formatWon(r.severance, lang),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _severanceNote.of(lang),
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF1B5E20),
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
          MoreBox(
            title: _severanceExplainTitle.of(lang),
            child: RichNote(severanceNarrative(input, result, lang)),
          ),
        ] else if (input.hireDate != null) ...[
          MoreBox(
            title: _severanceNotEligibleTitle.of(lang),
            child: RichNote(severanceNarrative(input, result, lang)),
          ),
        ],

        // 법률 수식 상세
        MoreBox(
          title: _formulaDetailTitle.of(lang),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formulaHourly.of(lang),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _formulaWeekly.of(lang),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _formulaExtra.of(lang),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _formulaTaxText(lang),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _formulaSeverance.of(lang),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),

        // 법적 고지
        MoreBox(
          title: _legalNoticeTitle.of(lang),
          child: Text(
            _legalNoticeBody.of(lang),
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  String _resultTitle(AppLanguage lang) => switch (lang) {
    AppLanguage.ko => '계산 결과',
    AppLanguage.uz => "Hisoblash natijasi",
    AppLanguage.en => 'Calculation result',
    AppLanguage.tr => "Hesaplama sonucu",
    AppLanguage.tg => "Натиҷаи ҳисоб",
    AppLanguage.fil => "Resulta ng pagkalkula",
    AppLanguage.ur => "حساب کا نتیجہ",
    AppLanguage.th => "ผลการคำนวณ",
    AppLanguage.ky => "Эсептөөнүн натыйжасы",
    AppLanguage.km => "លទ្ធផលនៃការគណនា",
    AppLanguage.id => "Hasil perhitungan",
    AppLanguage.si => "ගණනය කිරීමේ ප්‍රතිඵලය",
    AppLanguage.bn => "গণনার ফলাফল",
    AppLanguage.my => "တွက်ချက်မှုရလဒ်",
    AppLanguage.mn => "Тооцооллын үр дүн",
    AppLanguage.lo => "ຜົນການຄິດໄລ່",
    AppLanguage.tet => "Rezultadu kalkulasaun",
    AppLanguage.ne => "गणनाको नतिजा",
    AppLanguage.zh => '计算结果',
    AppLanguage.vi => 'Kết quả tính toán',
  };

  String _noticeYearText(AppLanguage lang) => switch (lang) {
    AppLanguage.ko => '$wageCalcYear년 고시',
    AppLanguage.uz => "$wageCalcYear eslatma",
    AppLanguage.en => '$wageCalcYear notice',
    AppLanguage.tr => "$wageCalcYear bildirimi",
    AppLanguage.tg => "Огоҳиномаи $wageCalcYear",
    AppLanguage.fil => "$wageCalcYear na abiso",
    AppLanguage.ur => "$wageCalcYear اطلاع",
    AppLanguage.th => "การแจ้งเตือน $wageCalcYear",
    AppLanguage.ky => "$wageCalcYear билдирүүсү",
    AppLanguage.km => "ការជូនដំណឹង $wageCalcYear",
    AppLanguage.id => "Pemberitahuan $wageCalcYear",
    AppLanguage.si => "$wageCalcYear දැනුම්දීම",
    AppLanguage.bn => "$wageCalcYear বিজ্ঞপ্তি",
    AppLanguage.my => "$wageCalcYear အကြောင်းကြားချက်",
    AppLanguage.mn => "$wageCalcYear мэдэгдэл",
    AppLanguage.lo => "ແຈ້ງການ $wageCalcYear",
    AppLanguage.tet => "Notifikasaun $wageCalcYear",
    AppLanguage.ne => "$wageCalcYear सूचना",
    AppLanguage.zh => '$wageCalcYear年公告',
    AppLanguage.vi => 'Công bố năm $wageCalcYear',
  };

  String _payBelowMinBody(WageCalcResult r, AppLanguage lang) {
    final hourly = formatWon(r.hourly, lang);
    final mw = formatWon(minWage().$1, lang);
    return switch (lang) {
      AppLanguage.ko => '적용 통상시급 $hourly이 $wageCalcYear년 최저임금 $mw에 미달합니다.',
      AppLanguage.uz =>
        "Qoʻllanilgan oddiy soatlik ish haqi $hourly, $wageCalcYear minimal ish haqi $mw dan past.",
      AppLanguage.en =>
        'The applied ordinary hourly wage of $hourly is below the $wageCalcYear minimum wage of $mw.',
      AppLanguage.tr =>
        "Uygulanan normal saatlik ücret olan $hourly, $wageCalcYear asgari ücreti olan $mw'nin altındadır.",
      AppLanguage.tg =>
        "Музди меҳнати муқаррарии соатбайъи татбиқшуда, ки $hourly аст, аз ҳадди ақали музди меҳнати $wageCalcYear, ки $mw аст, камтар мебошад.",
      AppLanguage.fil =>
        "Ang inilapat na normal na orasang sahod na $hourly ay mas mababa sa minimum na sahod ng $wageCalcYear na $mw.",
      AppLanguage.ur =>
        "لاگو ہونے والی عام فی گھنٹہ اجرت $hourly، $wageCalcYear کی کم از کم اجرت $mw سے کم ہے۔",
      AppLanguage.th =>
        "ค่าจ้างรายชั่วโมงปกติที่ใช้คือ $hourly ซึ่งต่ำกว่าค่าแรงขั้นต่ำของ $wageCalcYear ที่ $mw",
      AppLanguage.ky =>
        "Колдонулган кадимки сааттык эмгек акы $hourly, $wageCalcYear минималдуу эмгек акысы $mw'ден төмөн.",
      AppLanguage.km =>
        "អត្រាប្រាក់ឈ្នួលធម្មតាប្រចាំម៉ោងដែលបានអនុវត្តគឺ $hourly ដែលទាបជាងប្រាក់ឈ្នួលអប្បបរមា $wageCalcYear គឺ $mw។",
      AppLanguage.id =>
        "Upah per jam normal yang diterapkan, yaitu $hourly, berada di bawah upah minimum $wageCalcYear sebesar $mw.",
      AppLanguage.si =>
        "අදාළ වන සාමාන්‍ය පැයක වැටුප වන $hourly, $wageCalcYear අවම වැටුප වන $mw ට වඩා අඩුය.",
      AppLanguage.bn =>
        "প্রযোজ্য স্বাভাবিক প্রতি ঘণ্টার মজুরি $hourly, যা $wageCalcYear এর সর্বনিম্ন মজুরি $mw এর নিচে।",
      AppLanguage.my =>
        "အသုံးပြုထားသော ပုံမှန်နာရီလုပ်ခဖြစ်သည့် $hourly သည် $wageCalcYear ခုနှစ်၏ အနိမ့်ဆုံးလုပ်ခဖြစ်သော $mw အောက်တွင် ရှိနေပါသည်။",
      AppLanguage.mn =>
        "Хэрэглэсэн ердийн цагийн хөлс болох $hourly нь $wageCalcYear оны хамгийн бага цалин болох $mw-оос доогуур байна.",
      AppLanguage.lo =>
        "ຄ່າຈ້າງລາຍຊົ່ວໂມງປົກກະຕິທີ່ນຳໃຊ້ຄື $hourly, ແມ່ນຕໍ່າກວ່າຄ່າແຮງງານຂັ້ນຕໍ່າຂອງປີ $wageCalcYear ເຊິ່ງແມ່ນ $mw.",
      AppLanguage.tet =>
        "Saláriu normál kada oras ne'ebé aplika, $hourly, menus husi saláriu mínimu $wageCalcYear nian, $mw.",
      AppLanguage.ne =>
        "लागू गरिएको सामान्य प्रतिघण्टा ज्याला $hourly, $wageCalcYear को न्यूनतम ज्याला $mw भन्दा कम छ।",
      AppLanguage.zh => '适用的通常时薪 $hourly 低于 $wageCalcYear 年最低工资 $mw。',
      AppLanguage.vi =>
        'Lương giờ thông thường áp dụng $hourly thấp hơn lương tối thiểu năm $wageCalcYear là $mw.',
    };
  }

  String _formulaTaxText(AppLanguage lang) {
    final pct = (insuranceRate() * 100).toStringAsFixed(2);
    return switch (lang) {
      AppLanguage.ko => '• 세금: 4대보험 근로자부담 약 $pct% 또는 사업소득세 3.3%',
      AppLanguage.uz =>
        "• Soliq: 4 ta asosiy sugʻurtaning xodim ulushining taxminan $pct%i yoki 3,3% biznes daromad soligʻi",
      AppLanguage.en =>
        '• Tax: about $pct% employee share of the 4 major insurances, or 3.3% business income tax',
      AppLanguage.tr =>
        "• Vergi: 4 büyük sigortanın yaklaşık %$pct çalışan payı veya %3,3 işletme gelir vergisi",
      AppLanguage.tg =>
        "• Андоз: тақрибан %$pct ҳиссаи корманд аз суғуртаи калони 4 ё %3,3 андози даромади корхона",
      AppLanguage.fil =>
        "• Buwis: humigit-kumulang $pct% bahagi ng empleyado ng 4 na malaking insurance o 3,3% buwis sa kita ng negosyo",
      AppLanguage.ur =>
        "• ٹیکس: 4 بڑے بیمے کا تقریباً %$pct ملازم کا حصہ یا %3,3 کاروباری آمدنی کا ٹیکس",
      AppLanguage.th =>
        "• ภาษี: ประมาณ 4% ของส่วนแบ่งพนักงานสำหรับประกันหลัก $pct หรือ 3,3% ของภาษีเงินได้ธุรกิจ",
      AppLanguage.ky =>
        "• Салык: 4 чоң камсыздандыруунун болжол менен %$pct кызматкердин үлүшү же %3,3 ишкананын киреше салыгы",
      AppLanguage.km =>
        "• ពន្ធ៖ ប្រហែល 4% នៃចំណែកបុគ្គលិកនៃការធានារ៉ាប់រងធំ $pct ឬ 3,3% ពន្ធលើប្រាក់ចំណូលអាជីវកម្ម",
      AppLanguage.id =>
        "• Pajak: Sekitar $pct% bagian karyawan dari empat asuransi besar atau 3,3% pajak penghasilan bisnis dari 4.",
      AppLanguage.si =>
        "• බදු: 4 ප්‍රධාන රක්ෂණයේ දළ වශයෙන් සේවක කොටස $pct% හෝ ව්‍යාපාර ආදායම් බද්ද 3,3%",
      AppLanguage.bn =>
        "• কর: 4 বড় বীমার প্রায় $pct% কর্মচারী অংশ বা 3,3% ব্যবসায়িক আয়কর",
      AppLanguage.my =>
        "• အခွန်- 4 အကြီးစားအာမခံ၏ ခန့်မှန်းခြေ ဝန်ထမ်းဝေစု $pct% သို့မဟုတ် လုပ်ငန်းဝင်ငွေခွန် 3,3%",
      AppLanguage.mn =>
        "• Татвар: 4 том даатгалын ажилтны хувь ойролцоогоор %$pct эсвэл бизнесийн орлогын татвар %3,3",
      AppLanguage.lo =>
        "• ພາສີ: ສ່ວນແບ່ງຂອງພະນັກງານປະມານ $pct% ຂອງປະກັນໄພໃຫຍ່ 4 ຫຼື ພາສີລາຍໄດ້ທຸລະກິດ 3,3%",
      AppLanguage.tet =>
        "• Impostu: Aproximadamente %$pct husi parte empregadu nian ba seguru boot 4 ka %3,3 impostu rendimentu negósiu",
      AppLanguage.ne =>
        "• कर: 4 ठूला बीमाको लगभग %$pct कर्मचारीको हिस्सा वा 3.3% व्यवसाय आयकर",
      AppLanguage.zh => '• 税款：四大保险员工负担约$pct%，或事业所得税3.3%',
      AppLanguage.vi =>
        '• Thuế: khoảng $pct% phần người lao động đóng trong 4 loại bảo hiểm, hoặc thuế thu nhập kinh doanh 3.3%',
    };
  }
}

class _ResRow extends StatelessWidget {
  const _ResRow({
    required this.label,
    required this.value,
    this.zero = false,
    this.onHelp,
  });
  final String label;
  final String value;
  final bool zero;
  final VoidCallback? onHelp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF90CAF9),
                ),
              ),
              if (onHelp != null) _DarkQMark(onTap: onHelp!),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: zero ? 11 : 12.5,
              fontWeight: zero ? FontWeight.w600 : FontWeight.w700,
              color: zero ? const Color(0xFF90CAF9) : const Color(0xFFE3F2FD),
            ),
          ),
        ],
      ),
    );
  }
}

class _NetRow extends StatelessWidget {
  const _NetRow({required this.label, required this.value, this.onHelp});
  final String label;
  final String value;
  final VoidCallback? onHelp;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 2),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0x5990CAF9), style: BorderStyle.solid),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF90CAF9),
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (onHelp != null) _DarkQMark(onTap: onHelp!),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16.5,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SubHead extends StatelessWidget {
  const _SubHead(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 2),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          color: Color(0xFF90CAF9),
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _DarkQMark extends StatelessWidget {
  const _DarkQMark({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 15,
          height: 15,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0x26FFFFFF),
            shape: BoxShape.circle,
          ),
          child: const Text(
            '?',
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF90CAF9),
            ),
          ),
        ),
      ),
    );
  }
}
