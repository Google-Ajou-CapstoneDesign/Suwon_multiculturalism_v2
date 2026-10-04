import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';
import '../screens/evidence_files_screen.dart';

class _VaultStrings {
  _VaultStrings._();

  static const vaultTitle = L10nText(
    ko: '사업주 공식 증빙 보관함',
    en: 'Employer document vault',
    tr: "İşveren belge kasası",
    tg: "Ҷузвдони ҳуҷҷатҳои корфармо",
    fil: "Document vault ng employer",
    ur: "آجر کی دستاویزات کا والٹ",
    th: "ตู้เก็บเอกสารของนายจ้าง",
    ky: "Жумуш берүүчүнүн документтери",
    km: "កន្លែងផ្ទុកឯកសារនិយោជក",
    id: "Kotak dokumen pemberi kerja",
    si: "සේවායෝජක ලේඛන ගබඩාව",
    bn: "নিয়োগকর্তার ডকুমেন্ট বক্স",
    my: "အလုပ်ရှင် စာရွက်စာတမ်းသေတ္တာ",
    mn: "Ажил олгогчийн баримт бичгийн сан",
    lo: "ຕູ້ເກັບເອກະສານຂອງນາຍຈ້າງ",
    tet: "Kofre dokumentu empregadór nian",
    ne: "नियोक्ता कागजात भण्डार",
    zh: '雇主正式凭证保管箱',
    vi: 'Kho giấy tờ của chủ sử dụng',
    uz: "Ish beruvchining hujjatlar ombori",
  );
  static const vaultSubtitle = L10nText(
    ko: '근로계약서 · 임금명세서 · 사업주 메시지 — 눌러서 펼치기',
    en: 'Contract · payslips · employer messages — tap to expand',
    tr: "Sözleşme · maaş bordroları · işveren mesajları — genişletmek için dokunun",
    tg: "Шартнома · варақаҳои музди меҳнат · паёмҳои корфармо — барои васеъ кардан ламс кунед",
    fil:
        "Kontrata · mga payslip · mga mensahe ng employer — i-tap para palawakin",
    ur: "معاہدہ · پے سلپس · آجر کے پیغامات — پھیلانے کے لیے ٹیپ کریں",
    th: "สัญญา · สลิปเงินเดือน · ข้อความจากนายจ้าง — แตะเพื่อขยาย",
    ky: "Келишим · эмгек акы баракчалары · жумуш берүүчүнүн билдирүүлөрү — кеңейтүү үчүн басыңыз",
    km: "កិច្ចសន្យា · បង្កាន់ដៃប្រាក់ខែ · សារពីនិយោជក — ចុចដើម្បីពង្រីក",
    id: "Kontrak · slip gaji · pesan dari atasan — ketuk untuk memperluas",
    si: "ගිවිසුම · වැටුප් පත්‍රිකා · සේවායෝජක පණිවිඩ — පුළුල් කිරීමට තට්ටු කරන්න",
    bn: "চুক্তি · বেতন স্লিপ · নিয়োগকর্তার বার্তা — প্রসারিত করতে ট্যাপ করুন",
    my: "စာချုပ် · လုပ်ခလစာ · အလုပ်ရှင်မက်ဆေ့ချ်များ — ချဲ့ရန် နှိပ်ပါ",
    mn: "Гэрээ · цалингийн хуудас · ажил олгогчийн мессеж — дэлгэрүүлэхийн тулд товшино уу",
    lo: "ສັນຍາ · ໃບແຈ້ງເງິນເດືອນ · ຂໍ້ຄວາມຈາກນາຍຈ້າງ — ແຕະເພື່ອຂະຫຍາຍ",
    tet: "Kontratu · folla saláriu · mensajen empregadór nian — toka atu loke",
    ne: "सम्झौता · तलब स्लिपहरू · रोजगारदाताका सन्देशहरू — विस्तार गर्न ट्याप गर्नुहोस्",
    zh: '劳动合同·工资单·雇主消息 — 点击展开',
    vi: 'Hợp đồng · phiếu lương · tin nhắn của chủ — nhấn để mở',
    uz: "Shartnoma · ish haqi varaqalari · ish beruvchi xabarlari — kengaytirish uchun bosing",
  );
  static const vaultContractTitle = L10nText(
    ko: '근로계약서',
    en: 'Employment contract',
    tr: "İş sözleşmesi",
    tg: "Шартномаи корӣ",
    fil: "Kontrata sa trabaho",
    ur: "کام کا معاہدہ",
    th: "สัญญาจ้างงาน",
    ky: "Эмгек келишими",
    km: "កិច្ចសន្យាការងារ",
    id: "Kontrak Kerja",
    si: "රැකියා කොන්ත්‍රාත්තුව",
    bn: "কাজের চুক্তি",
    my: "အလုပ်သမား စာချုပ်",
    mn: "Хөдөлмөрийн гэрээ",
    lo: "ສັນຍາຈ້າງງານ",
    tet: "Kontratu Traballu",
    ne: "रोजगार सम्झौता",
    zh: '劳动合同',
    vi: 'Hợp đồng lao động',
    uz: "Mehnat shartnomasi",
  );
  static const vaultPayslipTitle = L10nText(
    ko: '임금명세서',
    en: 'Payslip',
    tr: "Maaş bordrosu",
    tg: "Варақаи музд",
    fil: "Payslip",
    ur: "تنخواہ کی پرچی",
    th: "สลิปเงินเดือน",
    ky: "Эмгек акы ведомосту",
    km: "ប័ណ្ណបើកប្រាក់ខែ",
    id: "Slip gaji",
    si: "වැටුප් පත්‍රිකාව",
    bn: "বেতন স্লিপ",
    my: "လုပ်ခလစာ စာရွက်",
    mn: "Цалингийн хуудас",
    lo: "ໃບແຈ້ງເງິນເດືອນ",
    tet: "Folla saláriu",
    ne: "तलब स्लिप",
    zh: '工资单',
    vi: 'Phiếu lương',
    uz: "Ish haqi varagʻi",
  );
  static const vaultMessageTitle = L10nText(
    ko: '사업주 카톡 · 문자',
    en: 'Employer messages',
    tr: "İşveren mesajları",
    tg: "Паёмҳои корфармо",
    fil: "Mga mensahe ng employer",
    ur: "آجر کے پیغامات",
    th: "ข้อความจากนายจ้าง",
    ky: "Жумуш берүүчүнүн билдирүүлөрү",
    km: "សារពីនិយោជក",
    id: "Pesan dari atasan",
    si: "සේවායෝජක පණිවිඩ",
    bn: "নিয়োগকর্তার বার্তা",
    my: "အလုပ်ရှင်မက်ဆေ့ချ်များ",
    mn: "Ажил олгогчийн мессеж",
    lo: "ຂໍ້ຄວາມຈາກນາຍຈ້າງ",
    tet: "Mensajen empregadór nian",
    ne: "रोजगारदाताका सन्देशहरू",
    zh: '雇主KakaoTalk·短信',
    vi: 'Tin nhắn của chủ',
    uz: "Ish beruvchi xabarlari",
  );
  static const vaultCallTitle = L10nText(
    ko: '사업주 통화 녹음',
    en: 'Recorded call with employer',
    tr: "İşverenle kaydedilmiş görüşme",
    tg: "Мусоҳибаи сабтшуда бо корфармо",
    fil: "Naitalang pag-uusap sa employer",
    ur: "آجر کے ساتھ محفوظ شدہ گفتگو",
    th: "การสนทนาที่บันทึกไว้กับนายจ้าง",
    ky: "Жумуш берүүчү менен катталган сүйлөшүү",
    km: "ការសន្ទនាដែលបានកត់ត្រាជាមួយនិយោជក",
    id: "Percakapan yang direkam dengan atasan",
    si: "සේවායෝජකයා සමඟ වාර්තාගත සංවාදය",
    bn: "নিয়োগকর্তার সাথে কথোপকথন রেকর্ড করা হয়েছে",
    my: "အလုပ်ရှင်နှင့် မှတ်တမ်းတင်ထားသော စကားပြောဆိုမှု",
    mn: "Ажил олгогчтой хийсэн ярианы бичлэг",
    lo: "ການສົນທະນາທີ່ຖືກບັນທຶກໄວ້ກັບນາຍຈ້າງ",
    tet: "Konversa rejistradu ho empregadór",
    ne: "रोजगारदातासँग रेकर्ड गरिएको कुराकानी",
    zh: '与雇主的通话录音',
    vi: 'Ghi âm cuộc gọi với chủ',
    uz: "Ish beruvchi bilan yozib olingan qoʻngʻiroq",
  );
  static const vaultStoredSubtitle = L10nText(
    ko: '보관함에 등록되어 있습니다',
    en: 'Registered in your vault',
    tr: "Kasanıza kaydedildi",
    tg: "Дар сейфи шумо захира шудааст",
    fil: "Na-save sa iyong vault",
    ur: "آپ کے والٹ میں محفوظ کر لیا گیا",
    th: "บันทึกไว้ในตู้เซฟของคุณแล้ว",
    ky: "Сейфиңизге сакталды",
    km: "បានរក្សាទុកក្នុងសុវត្ថិភាពរបស់អ្នក",
    id: "Disimpan ke brankas Anda",
    si: "ඔබගේ සුරක්ෂිතාගාරයේ සුරැකිණි",
    bn: "আপনার ভল্টে সংরক্ষণ করা হয়েছে",
    my: "သင်၏ဘေးကင်းခန်းတွင် သိမ်းဆည်းထားသည်",
    mn: "Таны хадгалах санд хадгалагдсан",
    lo: "ຖືກບັນທຶກໄວ້ໃນຕູ້ເຊຟຂອງທ່ານ",
    tet: "Rai ona iha imi-nia kofre",
    ne: "तपाईंको भल्टमा सुरक्षित गरियो",
    zh: '已在保管箱中登记',
    vi: 'Đã lưu trong kho',
    uz: "Omboringizda roʻyxatdan oʻtgan",
  );
  static const vaultContractEmptySubtitle = L10nText(
    ko: '아직 없습니다 — 사업주에게 사본을 요청하세요',
    en: 'None yet — ask your employer for a copy',
    tr: "Henüz yok — işvereninize bir kopyasını sorun",
    tg: "Ҳоло вуҷуд надорад — аз корфармои худ нусха пурсед",
    fil: "Wala pa — humingi ng kopya sa iyong employer",
    ur: "ابھی تک کوئی نہیں — اپنے آجر سے ایک کاپی طلب کریں",
    th: "ยังไม่มี — ขอสำเนาจากนายจ้างของคุณ",
    ky: "Азырынча жок — жумуш берүүчүңүздөн көчүрмөсүн сураңыз",
    km: "មិនទាន់មាន — សុំច្បាប់ចម្លងពីនិយោជករបស់អ្នក",
    id: "Belum ada — minta salinannya kepada atasan Anda",
    si: "තවම නැත — ඔබේ සේවායෝජකයාගෙන් පිටපතක් ඉල්ලන්න",
    bn: "এখনও নেই — আপনার নিয়োগকর্তাকে একটি কপির জন্য জিজ্ঞাসা করুন",
    my: "မရှိသေးပါ — သင်၏အလုပ်ရှင်ကို မိတ္တူတစ်စောင် တောင်းပါ",
    mn: "Одоогоор байхгүй — ажил олгогчоос хуулбарыг нь асуугаарай",
    lo: "ຍັງບໍ່ມີ — ກະລຸນາຂໍສຳເນົາຈາກນາຍຈ້າງຂອງທ່ານ",
    tet: "Seidauk iha — husu kopia ida ba imi-nia empregadór",
    ne: "अहिलेसम्म छैन — आफ्नो रोजगारदातालाई प्रतिलिपि माग्नुहोस्",
    zh: '尚无 — 请向雇主索取副本',
    vi: 'Chưa có — hãy yêu cầu chủ cấp bản sao',
    uz: "Hali yoʻq — ish beruvchingizdan nusxasini soʻrang",
  );
  static const vaultPayslipEmptySubtitle = L10nText(
    ko: '아직 없습니다 — 매달 명세서를 저장해 두세요',
    en: 'None yet — save your payslip each month',
    tr: "Henüz yok — maaş bordronuzu her ay kaydedin",
    tg: "Ҳанӯз нест — ҳар моҳ варақаи музди меҳнати худро сабт кунед",
    fil: "Wala pa — i-record ang iyong payslip bawat buwan",
    ur: "ابھی نہیں — اپنی پے سلپ ہر ماہ ریکارڈ کریں۔",
    th: "ยังไม่มี — บันทึกสลิปเงินเดือนของคุณทุกเดือน",
    ky: "Азырынча жок — ай сайын эмгек акыңызды сактаңыз",
    km: "មិនទាន់មាន — សូមកត់ត្រាបង្កាន់ដៃបើកប្រាក់ខែរបស់អ្នកជារៀងរាល់ខែ",
    id: "Belum ada — catat slip gaji Anda setiap bulan",
    si: "තවම නැත — සෑම මසකම ඔබේ වැටුප් පත්‍රිකා සුරකින්න",
    bn: "এখনও নেই — প্রতি মাসে আপনার বেতন স্লিপ রেকর্ড করুন",
    my: "မရှိသေးပါ — လစဉ် လစာရှင်းတမ်းများကို မှတ်တမ်းတင်ထားပါ",
    mn: "Одоогоор байхгүй байна — цалингийн хуудсаа сар бүр хадгалаарай",
    lo: "ຍັງບໍ່ມີ — ບັນທຶກໃບແຈ້ງເງິນເດືອນຂອງທ່ານທຸກໆເດືອນ",
    tet: "Seidauk iha — rejista imi-nia saláriu fulan-fulan",
    ne: "अहिलेसम्म छैन — आफ्नो तलब स्लिप हरेक महिना रेकर्ड गर्नुहोस्",
    zh: '尚无 — 请每月保存工资单',
    vi: 'Chưa có — hãy lưu phiếu lương mỗi tháng',
    uz: "Hali yoʻq — har oy ish haqi varaqangizni saqlang",
  );
  static const vaultMessageEmptySubtitle = L10nText(
    ko: '메시지 캡처 파일 보기 · 추가',
    en: 'View or add message screenshots',
    tr: "Mesaj ekran görüntülerini görüntüle veya ekle",
    tg: "Скриншотҳои паёмҳоро бинед ё илова кунед",
    fil: "Tingnan o magdagdag ng mga screenshot ng mensahe",
    ur: "پیغام کے اسکرین شاٹس دیکھیں یا شامل کریں۔",
    th: "ดูหรือเพิ่มภาพหน้าจอข้อความ",
    ky: "Билдирүүлөрдүн скриншотторун көрүү же кошуу",
    km: "មើល ឬបន្ថែមរូបថតអេក្រង់សារ",
    id: "Lihat atau tambahkan tangkapan layar pesan",
    si: "පණිවිඩ තිරපිටපත් බලන්න හෝ එක් කරන්න",
    bn: "বার্তার স্ক্রিনশট দেখুন বা যোগ করুন",
    my: "မက်ဆေ့ချ် စခရင်ရှော့များကို ကြည့်ရန် သို့မဟုတ် ထည့်ရန်",
    mn: "Зурвасын дэлгэцийн агшингуудыг харах эсвэл нэмэх",
    lo: "ເບິ່ງ ຫຼື ເພີ່ມຮູບໜ້າຈໍຂໍ້ຄວາມ",
    tet: "Haree ka tau printskrin mensajen",
    ne: "सन्देशको स्क्रिनसटहरू हेर्नुहोस् वा थप्नुहोस्",
    zh: '查看或添加消息截图',
    vi: 'Xem hoặc thêm ảnh chụp tin nhắn',
    uz: "Xabar skrinshotlarini koʻrish yoki qoʻshish",
  );
  static const vaultCallEmptySubtitle = L10nText(
    ko: '녹음 파일 보기 · 추가',
    en: 'View or add audio files',
    tr: "Ses dosyalarını görüntüle veya ekle",
    tg: "Файлҳои аудиоиро бинед ё илова кунед",
    fil: "Tingnan o magdagdag ng mga audio file",
    ur: "آڈیو فائلیں دیکھیں یا شامل کریں۔",
    th: "ดูหรือเพิ่มไฟล์เสียง",
    ky: "Аудио файлдарды көрүү же кошуу",
    km: "មើល ឬបន្ថែមឯកសារសំឡេង",
    id: "Lihat atau tambahkan file audio",
    si: "ශ්‍රව්‍ය ගොනු බලන්න හෝ එක් කරන්න",
    bn: "অডিও ফাইল দেখুন বা যোগ করুন",
    my: "အသံဖိုင်များကို ကြည့်ရန် သို့မဟုတ် ထည့်ရန်",
    mn: "Дууны файлуудыг харах эсвэл нэмэх",
    lo: "ເບິ່ງ ຫຼື ເພີ່ມໄຟລ໌ສຽງ",
    tet: "Haree ka tau filé áudiu",
    ne: "अडियो फाइलहरू हेर्नुहोस् वा थप्नुहोस्",
    zh: '查看或添加录音文件',
    vi: 'Xem hoặc thêm tệp ghi âm',
    uz: "Audio fayllarni koʻrish yoki qoʻshish",
  );
  static const vaultStoredTag = L10nText(
    ko: '보관됨',
    en: 'Stored',
    tr: "Kaydedildi",
    tg: "Сабт шуд",
    fil: "Na-save",
    ur: "محفوظ کر لیا گیا۔",
    th: "บันทึกแล้ว",
    ky: "Сакталды",
    km: "បានរក្សាទុក",
    id: "Tersimpan",
    si: "සුරැකිණි",
    bn: "সংরক্ষিত",
    my: "သိမ်းဆည်းပြီးပါပြီ",
    mn: "Хадгалсан",
    lo: "ບັນທຶກແລ້ວ",
    tet: "Rai ona",
    ne: "रेकर्ड गरियो",
    zh: '已保存',
    vi: 'Đã lưu',
    uz: "Saqlangan",
  );
  static const vaultAddTag = L10nText(
    ko: '추가',
    en: 'Add',
    tr: "Ekle",
    tg: "Илова кунед",
    fil: "Idagdag",
    ur: "شامل کریں۔",
    th: "เพิ่ม",
    ky: "Кошуу",
    km: "បន្ថែម",
    id: "Tambah",
    si: "එකතු කරන්න",
    bn: "যোগ করুন",
    my: "ထည့်ရန်",
    mn: "Нэмэх",
    lo: "ເພີ່ມ",
    tet: "Tau",
    ne: "थप्नुहोस्",
    zh: '添加',
    vi: 'Thêm',
    uz: "Qoʻshish",
  );
  static const vaultComingSoonMessage = L10nText(
    ko: '아직 준비 중인 기능입니다. 곧 연동될 예정이에요.',
    en: "This feature isn't ready yet. It's coming soon.",
    tr: "Bu özellik henüz hazır değil. Yakında geliyor.",
    tg: "Ин хусусият ҳанӯз омода нест. Ба қарибӣ дастрас мешавад.",
    fil:
        "Hindi pa handa ang feature na ito. Malapit na itong maging available.",
    ur: "یہ خصوصیت ابھی تیار نہیں ہے۔ جلد ہی دستیاب ہوگی۔",
    th: "คุณสมบัตินี้ยังไม่พร้อมใช้งาน จะพร้อมให้บริการเร็วๆ นี้",
    ky: "Бул функция азырынча даяр эмес. Жакында жеткиликтүү болот.",
    km: "មុខងារនេះមិនទាន់រួចរាល់ទេ។ នឹងមកដល់ឆាប់ៗនេះ។",
    id: "Fitur ini belum siap. Segera hadir.",
    si: "මෙම විශේෂාංගය තවම සූදානම් නැත. එය ඉක්මනින් පැමිණේ.",
    bn: "এই বৈশিষ্ট্যটি এখনও প্রস্তুত নয়। শীঘ্রই আসছে।",
    my: "ဤလုပ်ဆောင်ချက်ကို မရသေးပါ။ မကြာမီလာမည်။",
    mn: "Энэ функц хараахан бэлэн болоогүй байна. Удахгүй гарах болно.",
    lo: "ຄຸນສົມບັດນີ້ຍັງບໍ່ທັນພ້ອມໃຊ້ງານເທື່ອ. ຈະມາໃນໄວໆນີ້.",
    tet: "Karaterístika ne'e seidauk prontu. Sei mai lalais.",
    ne: "यो सुविधा अझै तयार छैन। चाँडै आउँदैछ।",
    zh: '该功能尚在准备中，即将上线。',
    vi: 'Tính năng này đang được chuẩn bị và sẽ sớm ra mắt.',
    uz: "Bu funksiya hali tayyor emas. Tez orada ishga tushadi.",
  );
  static const vaultOcrButton = L10nText(
    ko: '📷 OCR로 읽기 (베타)',
    en: '📷 Read with OCR (beta)',
    tr: "📷 OCR ile Oku (beta)",
    tg: "📷 Бо OCR хонед (бета)",
    fil: "📷 Basahin gamit ang OCR (beta)",
    ur: "📷 OCR کے ساتھ پڑھیں (بیٹا)",
    th: "📷 อ่านด้วย OCR (เบต้า)",
    ky: "📷 OCR менен окуу (бета)",
    km: "📷 អានដោយ OCR (សាកល្បង)",
    id: "📷 Baca dengan OCR (beta)",
    si: "📷 OCR සමඟ කියවන්න (බීටා)",
    bn: "📷 OCR দিয়ে পড়ুন (বিটা)",
    my: "📷 OCR ဖြင့် ဖတ်ရန် (beta)",
    mn: "📷 OCR-ээр унших (бета)",
    lo: "📷 ອ່ານດ້ວຍ OCR (ເບຕ້າ)",
    tet: "📷 Lee ho OCR (beta)",
    ne: "📷 OCR मार्फत पढ्नुहोस् (बेटा)",
    zh: '📷 用OCR读取（测试版）',
    vi: '📷 Đọc bằng OCR (beta)',
    uz: "📷 OCR bilan oʻqish (beta)",
  );
  static const vaultStrongNote = L10nText(
    ko: '이 서랍의 문서가 다툼이 생겼을 때 가장 먼저 요구받는 것들입니다. 계약서를 못 받았다면 지금 사업주에게 사본을 요청하세요. 교부는 사업주의 의무입니다.',
    en: 'These are the documents you will be asked for first if a dispute arises. If you never received a contract, ask your employer for a copy now — providing one is their obligation.',
    tr: "Bir anlaşmazlık durumunda sizden ilk istenecek belgeler bunlardır. Hiç sözleşme almadıysanız, şimdi işvereninizden bir kopyasını isteyin — bir tane sağlamak onların yükümlülüğüdür.",
    tg: "Дар ҳолати баҳс, инҳо ҳуҷҷатҳое мебошанд, ки аз шумо аввал талаб карда мешаванд. Агар шумо ҳеҷ гоҳ шартнома нагирифта бошед, ҳоло аз корфармои худ нусхаи онро талаб кунед — таъмин кардани он вазифаи онҳост.",
    fil:
        "Ito ang mga dokumentong unang hihingin sa iyo kung sakaling magkaroon ng hindi pagkakaunawaan. Kung hindi ka pa nakakatanggap ng kontrata, humingi ng kopya sa iyong employer ngayon — obligasyon nilang magbigay nito.",
    ur: "تنازعہ کی صورت میں یہ وہ پہلی دستاویزات ہیں جو آپ سے طلب کی جائیں گی۔ اگر آپ کو کبھی کوئی معاہدہ نہیں ملا، تو ابھی اپنے آجر سے اس کی ایک کاپی طلب کریں — ایک فراہم کرنا ان کی ذمہ داری ہے۔",
    th: "เอกสารเหล่านี้เป็นเอกสารแรกที่คุณจะถูกขอในกรณีที่มีข้อพิพาท หากคุณไม่เคยได้รับสัญญา โปรดขอสำเนาจากนายจ้างของคุณตอนนี้ — การจัดหาสัญญาเป็นหน้าที่ของพวกเขา",
    ky: "Талаш-тартыш болгон учурда сизден биринчи талап кылына турган документтер ушулар. Эгерде сиз эч качан келишим албаган болсоңуз, азыр жумуш берүүчүңүздөн көчүрмөсүн сураңыз — аны берүү алардын милдети.",
    km: "ទាំងនេះគឺជាឯកសារដំបូងដែលនឹងត្រូវបានស្នើសុំពីអ្នកក្នុងករណីមានវិវាទ។ ប្រសិនបើអ្នកមិនទាន់បានទទួលកិច្ចសន្យាណាមួយទេ សូមស្នើសុំច្បាប់ចម្លងពីនិយោជករបស់អ្នកឥឡូវនេះ — វាជាកាតព្វកិច្ចរបស់ពួកគេក្នុងការផ្តល់ជូន។",
    id: "Ini adalah dokumen pertama yang akan diminta dari Anda jika terjadi perselisihan. Jika Anda belum pernah menerima kontrak, mintalah salinannya dari atasan Anda sekarang — mereka wajib memberikannya.",
    si: "ආරවුලක් ඇති වුවහොත්, ඔබෙන් මුලින්ම ඉල්ලා සිටින ලේඛන මේවාය. ඔබට කිසිදු කොන්ත්‍රාත්තුවක් ලැබී නොමැති නම්, දැන් ඔබේ සේවායෝජකයාගෙන් පිටපතක් ඉල්ලා සිටින්න — එකක් සැපයීම ඔවුන්ගේ වගකීමකි.",
    bn: "বিরোধের ক্ষেত্রে, এইগুলিই প্রথম নথি যা আপনার কাছে চাওয়া হবে। যদি আপনি কখনও চুক্তি না পেয়ে থাকেন, তাহলে এখনই আপনার নিয়োগকর্তার কাছে একটি কপির জন্য জিজ্ঞাসা করুন — একটি সরবরাহ করা তাদের বাধ্যবাধকতা।",
    my: "အငြင်းပွားမှုဖြစ်လာပါက ဤစာရွက်စာတမ်းများကို သင့်အား ဦးစွာတောင်းဆိုပါလိမ့်မည်။ အကယ်၍ သင်သည် စာချုပ်တစ်စောင်မျှ မရရှိသေးပါက ယခုပင် သင့်အလုပ်ရှင်ထံမှ မိတ္တူတစ်စောင် တောင်းခံပါ — ၎င်းတို့သည် ပေးဆောင်ရန် တာဝန်ရှိပါသည်။",
    mn: "Маргаан гарсан тохиолдолд танаас эхлээд эдгээр баримт бичгийг шаардах болно. Хэрэв танд ямар ч гэрээ байхгүй бол одоо ажил олгогчоосоо хуулбарыг нь хүсээрэй — энэ нь тэдний үүрэг юм.",
    lo: "ໃນກໍລະນີທີ່ມີຂໍ້ຂັດແຍ່ງ, ເອກະສານເຫຼົ່ານີ້ແມ່ນສິ່ງທຳອິດທີ່ຈະຖືກຮ້ອງຂໍຈາກທ່ານ. ຖ້າທ່ານບໍ່ເຄີຍໄດ້ຮັບສັນຍາ, ໃຫ້ຮ້ອງຂໍສຳເນົາຈາກນາຍຈ້າງຂອງທ່ານດຽວນີ້ — ການສະໜອງສັນຍາແມ່ນພັນທະຂອງພວກເຂົາ.",
    tet:
        "Dokumentu sira-ne'e mak sei husu ba imi uluk liu bainhira mosu problema. Se imi seidauk simu kontratu, husu ba imi-nia empregadór atu fó kopia ida agora — sira-nia obrigasaun mak atu fó ida.",
    ne: "विवादको अवस्थामा, तपाईंबाट पहिले यी कागजातहरू मागिनेछन्। यदि तपाईंले कुनै सम्झौता प्राप्त गर्नुभएको छैन भने, अहिले नै आफ्नो रोजगारदातासँग यसको प्रतिलिपि माग्नुहोस् — एउटा उपलब्ध गराउनु उहाँहरूको दायित्व हो।",
    zh: '这些是发生争议时最先被索取的文件。若未拿到合同，请立即向雇主索取副本，交付是雇主的义务。',
    vi: 'Đây là những giấy tờ được yêu cầu đầu tiên khi có tranh chấp. Nếu chưa nhận hợp đồng, hãy yêu cầu chủ cấp bản sao ngay — đó là nghĩa vụ của chủ.',
    uz: "Nizo kelib chiqqan taqdirda, sizdan birinchi navbatda ushbu hujjatlar soʻraladi. Agar siz hech qachon shartnoma olmagan boʻlsangiz, hozir ish beruvchingizdan nusxasini soʻrang — uni taqdim etish ularning majburiyatidir.",
  );
}

/// 사업주 공식 증빙 보관함 — 근무기록장 시트와 설정 화면이 공용으로 쓴다.
/// 각 자료를 선택하면 인증된 업로드·목록 화면을 연다.
class VaultBox extends StatefulWidget {
  const VaultBox({super.key, required this.language});
  final AppLanguage language;

  @override
  State<VaultBox> createState() => _VaultBoxState();
}

class _VaultBoxState extends State<VaultBox> {
  bool _open = false;

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_VaultStrings.vaultComingSoonMessage.of(widget.language)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openFiles(String category, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EvidenceFilesScreen(title: title, category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = UserProfileScope.of(context);
    final lang = widget.language;
    return AnimatedBuilder(
      animation: profile,
      builder: (context, _) {
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => setState(() => _open = !_open),
                child: Padding(
                  padding: const EdgeInsets.all(13),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('📁', style: TextStyle(fontSize: 15)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _VaultStrings.vaultTitle.of(lang),
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _VaultStrings.vaultSubtitle.of(lang),
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textMuted,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedRotation(
                        turns: _open ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          size: 18,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_open)
                Padding(
                  padding: const EdgeInsets.fromLTRB(13, 0, 13, 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(height: 1, color: AppColors.border),
                      const SizedBox(height: 11),
                      _VaultFileRow(
                        icon: '📄',
                        title: _VaultStrings.vaultContractTitle.of(lang),
                        subtitle: profile.contractStored
                            ? _VaultStrings.vaultStoredSubtitle.of(lang)
                            : _VaultStrings.vaultContractEmptySubtitle.of(lang),
                        stored: profile.contractStored,
                        language: lang,
                        onTap: () => _openFiles(
                          'contract',
                          _VaultStrings.vaultContractTitle.of(lang),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _VaultFileRow(
                        icon: '🧾',
                        title: _VaultStrings.vaultPayslipTitle.of(lang),
                        subtitle: profile.payslipStored
                            ? _VaultStrings.vaultStoredSubtitle.of(lang)
                            : _VaultStrings.vaultPayslipEmptySubtitle.of(lang),
                        stored: profile.payslipStored,
                        language: lang,
                        onTap: () => _openFiles(
                          'payslip',
                          _VaultStrings.vaultPayslipTitle.of(lang),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _VaultFileRow(
                        icon: '💬',
                        title: _VaultStrings.vaultMessageTitle.of(lang),
                        subtitle: _VaultStrings.vaultMessageEmptySubtitle.of(
                          lang,
                        ),
                        stored: false,
                        language: lang,
                        onTap: () => _openFiles(
                          'message',
                          _VaultStrings.vaultMessageTitle.of(lang),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _VaultFileRow(
                        icon: '🎙',
                        title: _VaultStrings.vaultCallTitle.of(lang),
                        subtitle: _VaultStrings.vaultCallEmptySubtitle.of(lang),
                        stored: false,
                        language: lang,
                        onTap: () => _openFiles(
                          'recording',
                          _VaultStrings.vaultCallTitle.of(lang),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => _showComingSoon(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textSecondary,
                            side: const BorderSide(color: AppColors.border),
                            padding: const EdgeInsets.symmetric(vertical: 9),
                          ),
                          child: Text(
                            _VaultStrings.vaultOcrButton.of(lang),
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        _VaultStrings.vaultStrongNote.of(lang),
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textMuted,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _VaultFileRow extends StatelessWidget {
  const _VaultFileRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.stored,
    required this.language,
    required this.onTap,
  });

  final String icon;
  final String title;
  final String subtitle;
  final bool stored;
  final AppLanguage language;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 15)),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: AppColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: stored
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                (stored
                        ? _VaultStrings.vaultStoredTag
                        : _VaultStrings.vaultAddTag)
                    .of(language),
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: stored
                      ? const Color(0xFF1B5E20)
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
