import 'package:flutter/material.dart';
import '../screens/evidence_files_screen.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';
import '../../wage_calculator/models/wage_diagnosis.dart' show formatWon;
import '../controllers/work_log_controller.dart';
import '../models/daily_work_record.dart';
import '../screens/accident_navigator_screen.dart';
import '../screens/wage_navigator_screen.dart';
import '../services/location_verify_service.dart';
import 'vault_box.dart';

/// 근무기록장 UI 문구.
class _WorkLogStrings {
  _WorkLogStrings._();

  static const title = L10nText(
    ko: '근무기록장',
    en: 'Work Log',
    tr: "Çalışma Günlüğü",
    tg: "Рӯзномаи корӣ",
    fil: "Work Log",
    ur: "ورک لاگ",
    th: "บันทึกการทำงาน",
    ky: "Жумуш Журналы",
    km: "កំណត់ហេតុការងារ",
    id: "Buku Kerja",
    si: "වැඩ ලොගය",
    bn: "কাজের ডায়েরি",
    my: "အလုပ်မှတ်တမ်း",
    mn: "Ажлын бүртгэл",
    lo: "ບັນທຶກການເຮັດວຽກ",
    tet: "Rejistu Servisu",
    ne: "कार्य लग",
    zh: '工作记录本',
    vi: 'Nhật ký làm việc',
    uz: "Ish jurnali",
  );
  static const subtitle = L10nText(
    ko: '매일의 기록이 가장 확실한 증거가 됩니다',
    en: 'Daily records are your strongest evidence',
    tr: "Günlük kayıtlar en güçlü kanıtınızdır",
    tg: "Сабтҳои ҳаррӯза далели қавитарини шумоянд",
    fil:
        "Ang mga pang-araw-araw na tala ay ang iyong pinakamalakas na ebidensya",
    ur: "روزانہ کے ریکارڈ آپ کا سب سے مضبوط ثبوت ہیں۔",
    th: "บันทึกประจำวันคือหลักฐานที่แข็งแกร่งที่สุดของคุณ",
    ky: "Күнүмдүк жазуулар сиздин эң күчтүү далилиңиз",
    km: "កំណត់ត្រាប្រចាំថ្ងៃគឺជាភស្តុតាងដ៏រឹងមាំបំផុតរបស់អ្នក",
    id: "Catatan harian adalah bukti terkuat Anda",
    si: "දිනපතා වාර්තා ඔබේ ප්‍රබලතම සාක්ෂියයි",
    bn: "দৈনিক রেকর্ডগুলি আপনার সবচেয়ে শক্তিশালী প্রমাণ",
    my: "နေ့စဉ်မှတ်တမ်းများသည် သင့်အတွက် အခိုင်မာဆုံး အထောက်အထားများ ဖြစ်သည်",
    mn: "Өдөр тутмын бүртгэл бол таны хамгийн хүчтэй нотолгоо юм",
    lo: "ບັນທຶກປະຈໍາວັນແມ່ນຫຼັກຖານທີ່ເຂັ້ມແຂງທີ່ສຸດຂອງທ່ານ",
    tet: "Rejistu loron-loron nian mak imi-nia prova forte liu",
    ne: "दैनिक रेकर्डहरू तपाईंको सबैभन्दा बलियो प्रमाण हुन्",
    zh: '每天的记录就是最确凿的证据',
    vi: 'Ghi chép hằng ngày là bằng chứng chắc chắn nhất',
    uz: "Kundalik yozuvlar sizning eng kuchli dalilingizdir",
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
  static const legendLogged = L10nText(
    ko: '기록 완료',
    en: 'Recorded',
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
    zh: '已记录',
    vi: 'Đã ghi nhận',
    uz: "Yozilgan",
  );
  static const legendOvertime = L10nText(
    ko: '연장·야간',
    en: 'Overtime/night',
    tr: "Fazla mesai/gece",
    tg: "Кори изофӣ/шабона",
    fil: "Overtime/Gabi",
    ur: "اوور ٹائم/رات",
    th: "ค่าล่วงเวลา/กลางคืน",
    ky: "Ашыкча иштөө/түнкү",
    km: "ម៉ោងបន្ថែម/ពេលយប់",
    id: "Lembur/malam",
    si: "අතිකාල/රාත්‍රී",
    bn: "ওভারটাইম/রাতের কাজ",
    my: "အချိန်ပို/ညဆိုင်း",
    mn: "Илүү цаг/шөнийн",
    lo: "ລ່ວງເວລາ/ກາງຄືນ",
    tet: "Oras estra/kalan",
    ne: "ओभरटाइम/रात",
    zh: '加班·夜班',
    vi: 'Tăng ca/làm đêm',
    uz: "Ishdan tashqari/tun",
  );
  static const legendRisk = L10nText(
    ko: '급여 미지급 의심',
    en: 'Possible unpaid wages',
    tr: "Olası ödenmemiş ücretler",
    tg: "Музди меҳнати эҳтимолии пардохтнашуда",
    fil: "Posibleng hindi nabayarang sahod",
    ur: "ممکنہ غیر ادا شدہ اجرت",
    th: "ค่าจ้างที่อาจไม่ได้รับ",
    ky: "Төлөнбөгөн эмгек акылар",
    km: "ប្រាក់ឈ្នួលដែលមិនបានបង់ដែលអាចកើតមាន",
    id: "Potensi upah yang belum dibayar",
    si: "ගෙවා නොතිබිය හැකි වැටුප්",
    bn: "সম্ভাব্য বকেয়া মজুরি",
    my: "မရရှိသေးသော လုပ်ခများ",
    mn: "Төлөгдөөгүй байж болзошгүй цалин",
    lo: "ຄ່າຈ້າງທີ່ອາດຈະຍັງບໍ່ໄດ້ຈ່າຍ",
    tet: "Saláriu ne'ebé karik seidauk selu",
    ne: "सम्भावित भुक्तानी नगरिएको ज्याला",
    zh: '疑似欠薪',
    vi: 'Nghi ngờ chưa trả lương',
    uz: "Toʻlanmagan ish haqi boʻlishi mumkin",
  );

  static const breakTimeTitle = L10nText(
    ko: '휴게시간',
    en: 'Break time',
    tr: "Mola süresi",
    tg: "Вақти танаффус",
    fil: "Oras ng pahinga",
    ur: "وقفے کا وقت",
    th: "เวลาพัก",
    ky: "Тыныгуу убактысы",
    km: "រយៈពេលសម្រាក",
    id: "Waktu istirahat",
    si: "විවේක කාලය",
    bn: "বিরতির সময়",
    my: "နားချိန်",
    mn: "Завсарлагааны хугацаа",
    lo: "ເວລາພັກຜ່ອນ",
    tet: "Oras deskansa",
    ne: "ब्रेक समय",
    zh: '休息时间',
    vi: 'Thời gian nghỉ',
    uz: "Tanaffus vaqti",
  );
  static const cancel = L10nText(
    ko: '취소',
    en: 'Cancel',
    tr: "İptal",
    tg: "Бекор кардан",
    fil: "Kanselahin",
    ur: "منسوخ کریں۔",
    th: "ยกเลิก",
    ky: "Жокко чыгаруу",
    km: "បោះបង់",
    id: "Batal",
    si: "අවලංගු කරන්න",
    bn: "বাতিল করুন",
    my: "ပယ်ဖျက်ရန်",
    mn: "Цуцлах",
    lo: "ຍົກເລີກ",
    tet: "Kansela",
    ne: "रद्द गर्नुहोस्",
    zh: '取消',
    vi: 'Hủy',
    uz: "Bekor qilish",
  );
  static const confirm = L10nText(
    ko: '확인',
    en: 'Confirm',
    tr: "Onayla",
    tg: "Тасдиқ кунед",
    fil: "Kumpirmahin",
    ur: "تصدیق کریں۔",
    th: "ยืนยัน",
    ky: "Ырастоо",
    km: "បញ្ជាក់",
    id: "Konfirmasi",
    si: "තහවුරු කරන්න",
    bn: "নিশ্চিত করুন",
    my: "အတည်ပြုရန်",
    mn: "Баталгаажуулах",
    lo: "ຢືນຢັນ",
    tet: "Konfirma",
    ne: "पुष्टि गर्नुहोस्",
    zh: '确认',
    vi: 'Xác nhận',
    uz: "Tasdiqlash",
  );

  static const gpsVerified = L10nText(
    ko: '📍 위치 인증 완료',
    en: '📍 Location verified',
    tr: "📍 Konum doğrulandı",
    tg: "📍 Ҷойгиршавӣ тасдиқ шуд",
    fil: "📍 Lokasyon na-verify",
    ur: "📍 مقام کی تصدیق ہو گئی۔",
    th: "📍 ยืนยันตำแหน่งแล้ว",
    ky: "📍 Жайгашкан жер ырасталды",
    km: "📍 ទីតាំងត្រូវបានផ្ទៀងផ្ទាត់",
    id: "📍 Lokasi terverifikasi",
    si: "📍 ස්ථානය තහවුරු කරන ලදී",
    bn: "📍 অবস্থান যাচাই করা হয়েছে",
    my: "📍 တည်နေရာကို အတည်ပြုပြီးပါပြီ",
    mn: "📍 Байршил баталгаажсан",
    lo: "📍 ຢືນຢັນສະຖານທີ່ແລ້ວ",
    tet: "📍 Lokál verifika ona",
    ne: "📍 स्थान प्रमाणित भयो",
    zh: '📍 位置认证完成',
    vi: '📍 Đã xác minh vị trí',
    uz: "📍 Manzil tasdiqlandi",
  );
  static const gpsUnverified = L10nText(
    ko: '📍 사업장 외부 기록',
    en: '📍 Recorded outside workplace',
    tr: "📍 İş yeri dışında kaydedildi",
    tg: "📍 Берун аз ҷои кор сабт шуд",
    fil: "📍 Na-record sa labas ng lugar ng trabaho",
    ur: "📍 کام کی جگہ سے باہر ریکارڈ کیا گیا۔",
    th: "📍 บันทึกไว้นอกสถานที่ทำงาน",
    ky: "📍 Жумуш ордунан тышкары сакталды",
    km: "📍 បានកត់ត្រានៅខាងក្រៅកន្លែងធ្វើការ",
    id: "📍 Direkam di luar tempat kerja",
    si: "📍 සේවා ස්ථානයෙන් පිටත සටහන් කර ඇත",
    bn: "📍 কর্মস্থলের বাইরে রেকর্ড করা হয়েছে",
    my: "📍 အလုပ်နေရာပြင်ပတွင် မှတ်တမ်းတင်ထားသည်",
    mn: "📍 Ажлын байрнаас гадуур бүртгэгдсэн",
    lo: "📍 ບັນທຶກຢູ່ນອກສະຖານທີ່ເຮັດວຽກ",
    tet: "📍 Rejista iha li'ur fatin servisu nian",
    ne: "📍 कार्यस्थल बाहिर रेकर्ड गरियो",
    zh: '📍 工作场所外记录',
    vi: '📍 Ghi nhận ngoài nơi làm việc',
    uz: "📍 Ish joyidan tashqarida qayd etilgan",
  );
  static const gpsVerifyButton = L10nText(
    ko: '📍 위치 인증하기',
    en: '📍 Verify location',
    tr: "📍 Konumu doğrula",
    tg: "📍 Ҷойгиршавиро тасдиқ кунед",
    fil: "📍 I-verify ang lokasyon",
    ur: "📍 مقام کی تصدیق کریں۔",
    th: "📍 ยืนยันตำแหน่ง",
    ky: "📍 Жайгашкан жерди ырастоо",
    km: "📍 ផ្ទៀងផ្ទាត់ទីតាំង",
    id: "📍 Verifikasi lokasi",
    si: "📍 ස්ථානය තහවුරු කරන්න",
    bn: "📍 অবস্থান যাচাই করুন",
    my: "📍 တည်နေရာကို အတည်ပြုရန်",
    mn: "📍 Байршлыг баталгаажуулах",
    lo: "📍 ຢືນຢັນສະຖານທີ່",
    tet: "📍 Verifika lokál",
    ne: "📍 स्थान प्रमाणित गर्नुहोस्",
    zh: '📍 认证位置',
    vi: '📍 Xác minh vị trí',
    uz: "📍 Manzilni tasdiqlash",
  );
  static const gpsServiceDisabled = L10nText(
    ko: '기기의 위치 서비스가 꺼져 있어요. 설정에서 켜주세요.',
    en: 'Your device\'s location service is off. Please turn it on in settings.',
    tr: "Cihazınızın konum hizmeti kapalı. Lütfen ayarlardan açın.",
    tg: "Хидмати ҷойгиршавии дастгоҳи шумо хомӯш аст. Лутфан онро аз танзимот фаъол созед.",
    fil:
        "Naka-off ang serbisyo ng lokasyon ng iyong device. Paki-on ito sa settings.",
    ur: "آپ کے آلے کی لوکیشن سروس بند ہے۔ براہ کرم اسے سیٹنگز سے آن کریں۔",
    th: "บริการระบุตำแหน่งของอุปกรณ์ของคุณปิดอยู่ โปรดเปิดใช้งานในการตั้งค่า",
    ky: "Түзмөгүңүздүн жайгашкан жерди аныктоо кызматы өчүк. Сураныч, жөндөөлөрдөн күйгүзүңүз.",
    km: "សេវាកម្មទីតាំងរបស់ឧបករណ៍របស់អ្នកត្រូវបានបិទ។ សូមបើកវានៅក្នុងការកំណត់។",
    id: "Layanan lokasi perangkat Anda mati. Harap nyalakan di pengaturan.",
    si: "ඔබගේ උපාංගයේ ස්ථාන සේවාව අක්‍රිය කර ඇත. කරුණාකර සැකසීම් තුළ එය ක්‍රියාත්මක කරන්න.",
    bn: "আপনার ডিভাইসের অবস্থান পরিষেবা বন্ধ আছে। অনুগ্রহ করে সেটিংস থেকে এটি চালু করুন।",
    my: "သင့်စက်၏ တည်နေရာဝန်ဆောင်မှုကို ပိတ်ထားပါသည်။ ကျေးဇူးပြု၍ ဆက်တင်များတွင် ဖွင့်ပါ။",
    mn: "Таны төхөөрөмжийн байршлын үйлчилгээ унтарсан байна. Тохиргооноос асаана уу.",
    lo: "ບໍລິການສະຖານທີ່ຂອງອຸປະກອນຂອງທ່ານຖືກປິດຢູ່. ກະລຸນາເປີດມັນໃນການຕັ້ງຄ່າ.",
    tet:
        "Servisu lokál iha imi-nia aparéllu la funsiona. Favor loke iha konfigurasaun.",
    ne: "तपाईंको उपकरणको स्थान सेवा बन्द छ। कृपया सेटिङहरूबाट खोल्नुहोस्।",
    zh: '设备的位置服务已关闭，请在设置中打开。',
    vi: 'Dịch vụ vị trí của thiết bị đang tắt. Vui lòng bật trong cài đặt.',
    uz: "Qurilmangizning joylashuv xizmati oʻchirilgan. Iltimos, sozlamalarda yoqing.",
  );
  static const gpsPermissionDenied = L10nText(
    ko: '위치 권한이 필요해요. 브라우저나 기기 설정에서 위치 접근을 허용해주세요.',
    en: 'Location permission is needed. Please allow location access in your browser or device settings.',
    tr: "Konum izni gerekiyor. Lütfen tarayıcınızda veya cihaz ayarlarınızda konum erişimine izin verin.",
    tg: "Иҷозати ҷойгиршавӣ лозим аст. Лутфан дастрасӣ ба ҷойгиршавиро дар браузер ё танзимоти дастгоҳи худ иҷозат диҳед.",
    fil:
        "Kailangan ng pahintulot sa lokasyon. Mangyaring payagan ang access sa lokasyon sa iyong browser o sa settings ng device.",
    ur: "مقام کی اجازت درکار ہے۔ براہ کرم اپنے براؤزر یا ڈیوائس کی سیٹنگز میں مقام تک رسائی کی اجازت دیں۔",
    th: "ต้องได้รับอนุญาตการเข้าถึงตำแหน่ง โปรดอนุญาตการเข้าถึงตำแหน่งในเบราว์เซอร์หรือการตั้งค่าอุปกรณ์ของคุณ",
    ky: "Жайгашкан жерге уруксат талап кылынат. Сураныч, браузериңизде же түзмөгүңүздүн жөндөөлөрүндө жайгашкан жерге кирүүгө уруксат бериңиз.",
    km: "ត្រូវការការអនុញ្ញាតទីតាំង។ សូមអនុញ្ញាតការចូលប្រើទីតាំងនៅក្នុងកម្មវិធីរុករក ឬការកំណត់ឧបករណ៍របស់អ្នក។",
    id: "Izin lokasi diperlukan. Harap izinkan akses lokasi di browser atau pengaturan perangkat Anda.",
    si: "ස්ථාන අවසරය අවශ්‍යයි. කරුණාකර ඔබගේ බ්‍රවුසරයේ හෝ උපාංග සැකසීම් තුළ ස්ථාන ප්‍රවේශයට ඉඩ දෙන්න.",
    bn: "অবস্থানের অনুমতি প্রয়োজন। অনুগ্রহ করে আপনার ব্রাউজার বা ডিভাইস সেটিংসে অবস্থানের অ্যাক্সেসের অনুমতি দিন।",
    my: "တည်နေရာခွင့်ပြုချက် လိုအပ်ပါသည်။ ကျေးဇူးပြု၍ သင့်ဘရောက်ဆာ သို့မဟုတ် စက်ဆက်တင်များတွင် တည်နေရာဝင်ရောက်ခွင့်ကို ခွင့်ပြုပါ။",
    mn: "Байршлын зөвшөөрөл шаардлагатай. Хөтөч эсвэл төхөөрөмжийнхөө тохиргооноос байршилд нэвтрэхийг зөвшөөрнө үү.",
    lo: "ຕ້ອງການການອະນຸຍາດສະຖານທີ່. ກະລຸນາອະນຸຍາດການເຂົ້າເຖິງສະຖານທີ່ໃນບຣາວເຊີ ຫຼື ການຕັ້ງຄ່າອຸປະກອນຂອງທ່ານ.",
    tet:
        "Presiza lisensa lokál. Favor fó permisaun asesu lokál iha imi-nia navegadór ka konfigurasaun aparéllu nian.",
    ne: "स्थान अनुमति आवश्यक छ। कृपया आफ्नो ब्राउजर वा उपकरण सेटिङहरूमा स्थान पहुँचलाई अनुमति दिनुहोस्।",
    zh: '需要位置权限，请在浏览器或设备设置中允许访问位置信息。',
    vi: 'Cần quyền truy cập vị trí. Vui lòng cho phép truy cập vị trí trong cài đặt trình duyệt hoặc thiết bị.',
    uz: "Manzilga ruxsat kerak. Iltimos, brauzeringiz yoki qurilma sozlamalarida joylashuvga kirishga ruxsat bering.",
  );
  static const gpsVerifyFailed = L10nText(
    ko: '위치 정보를 받았지만 인증에 실패했어요. 다시 시도해주세요.',
    en: 'We received your location but verification failed. Please try again.',
    tr: "Konumunuzu aldık ancak doğrulama başarısız oldu. Lütfen tekrar deneyin.",
    tg: "Мо ҷойгиршавии шуморо гирифтем, аммо тасдиқ ноком шуд. Лутфан дубора кӯшиш кунед.",
    fil:
        "Nakuha namin ang iyong lokasyon ngunit nabigo ang pag-verify. Pakisubukang muli.",
    ur: "ہم نے آپ کا مقام حاصل کر لیا ہے لیکن تصدیق ناکام ہو گئی۔ براہ کرم دوبارہ کوشش کریں۔",
    th: "เราได้รับตำแหน่งของคุณแล้ว แต่การยืนยันล้มเหลว โปรดลองอีกครั้ง",
    ky: "Биз сиздин жайгашкан жериңизди алдык, бирок ырастоо ишке ашкан жок. Сураныч, кайра аракет кылыңыз.",
    km: "យើងបានទទួលទីតាំងរបស់អ្នកហើយ ប៉ុន្តែការផ្ទៀងផ្ទាត់បានបរាជ័យ។ សូមព្យាយាមម្តងទៀត។",
    id: "Kami telah menerima lokasi Anda, tetapi verifikasi gagal. Harap coba lagi.",
    si: "අපි ඔබේ ස්ථානය ලබා ගත්තෙමු, නමුත් සත්‍යාපනය අසාර්ථක විය. කරුණාකර නැවත උත්සාහ කරන්න.",
    bn: "আমরা আপনার অবস্থান পেয়েছি কিন্তু যাচাইকরণ ব্যর্থ হয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।",
    my: "သင့်တည်နေရာကို ကျွန်ုပ်တို့ ရရှိခဲ့သော်လည်း အတည်ပြုခြင်း မအောင်မြင်ပါ။ ကျေးဇူးပြု၍ ထပ်မံကြိုးစားပါ။",
    mn: "Бид таны байршлыг авсан боловч баталгаажуулалт амжилтгүй боллоо. Дахин оролдоно уу.",
    lo: "ພວກເຮົາໄດ້ຮັບສະຖານທີ່ຂອງທ່ານແລ້ວ ແຕ່ການຢືນຢັນບໍ່ສຳເລັດ. ກະລຸນາລອງໃໝ່ອີກຄັ້ງ.",
    tet:
        "Ami simu ona imi-nia lokál maibé verifikasaun la susesu. Favor koko fali.",
    ne: "हामीले तपाईंको स्थान प्राप्त गर्यौं तर प्रमाणीकरण असफल भयो। कृपया फेरि प्रयास गर्नुहोस्।",
    zh: '已收到位置信息，但认证失败，请重试。',
    vi: 'Đã nhận vị trí nhưng xác minh thất bại. Vui lòng thử lại.',
    uz: "Biz sizning manzilingizni oldik, ammo tasdiqlash muvaffaqiyatsiz tugadi. Iltimos, qayta urinib koʻring.",
  );
  static const gpsVerifyError = L10nText(
    ko: '위치 인증 중 오류가 발생했어요. 잠시 후 다시 시도해주세요.',
    en: 'Something went wrong while verifying your location. Please try again shortly.',
    tr: "Konumunuz doğrulanırken bir sorun oluştu. Lütfen kısa süre sonra tekrar deneyin.",
    tg: "Ҳангоми тасдиқи ҷойгиршавии шумо мушкилот пеш омад. Лутфан баъдтар дубора кӯшиш кунед.",
    fil:
        "Nagkaroon ng problema sa pag-verify ng iyong lokasyon. Pakisubukang muli pagkatapos ng ilang sandali.",
    ur: "آپ کے مقام کی تصدیق کرتے وقت ایک مسئلہ پیش آیا۔ براہ کرم تھوڑی دیر بعد دوبارہ کوشش کریں۔",
    th: "เกิดปัญหาขณะยืนยันตำแหน่งของคุณ โปรดลองอีกครั้งในภายหลัง",
    ky: "Сиздин жайгашкан жериңизди ырастоодо көйгөй келип чыкты. Сураныч, бир аздан кийин кайра аракет кылыңыз.",
    km: "មានបញ្ហាក្នុងការផ្ទៀងផ្ទាត់ទីតាំងរបស់អ្នក។ សូមព្យាយាមម្តងទៀតក្នុងពេលបន្តិចទៀត។",
    id: "Terjadi masalah saat memverifikasi lokasi Anda. Harap coba lagi sebentar lagi.",
    si: "ඔබගේ ස්ථානය සත්‍යාපනය කිරීමේදී ගැටලුවක් ඇති විය. කරුණාකර ටික වේලාවකින් නැවත උත්සාහ කරන්න.",
    bn: "আপনার অবস্থান যাচাই করার সময় একটি সমস্যা হয়েছে। অনুগ্রহ করে কিছুক্ষণ পরে আবার চেষ্টা করুন।",
    my: "သင့်တည်နေရာကို အတည်ပြုရာတွင် ပြဿနာတစ်ခု ဖြစ်ပေါ်ခဲ့ပါသည်။ ကျေးဇူးပြု၍ ခဏအကြာတွင် ထပ်မံကြိုးစားပါ။",
    mn: "Таны байршлыг баталгаажуулахад асуудал гарлаа. Удахгүй дахин оролдоно уу.",
    lo: "ເກີດບັນຫາໃນຂະນະທີ່ກຳລັງຢືນຢັນສະຖານທີ່ຂອງທ່ານ. ກະລຸນາລອງໃໝ່ອີກຄັ້ງໃນໄວໆນີ້.",
    tet:
        "Mosu problema ida bainhira verifika imi-nia lokál. Favor koko fali uitoan tan.",
    ne: "तपाईंको स्थान प्रमाणित गर्दा समस्या भयो। कृपया केही समयपछि फेरि प्रयास गर्नुहोस्।",
    zh: '认证位置时发生错误，请稍后重试。',
    vi: 'Đã xảy ra lỗi khi xác minh vị trí. Vui lòng thử lại sau.',
    uz: "Manzilingizni tasdiqlashda nimadir notoʻgʻri ketdi. Iltimos, birozdan keyin qayta urinib koʻring.",
  );

  static const clockIn = L10nText(
    ko: '출근',
    en: 'Clock in',
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
    zh: '上班',
    vi: 'Vào ca',
    uz: "Ishga kirish",
  );
  static const clockOut = L10nText(
    ko: '퇴근',
    en: 'Clock out',
    tr: "Çıkış yap",
    tg: "Баромадан",
    fil: "Mag-log out",
    ur: "لاگ آؤٹ کریں",
    th: "ออกจากระบบ",
    ky: "Чыгуу",
    km: "ចេញពីគណនី",
    id: "Keluar",
    si: "ලොග් අවුට් වන්න",
    bn: "লগ আউট করুন",
    my: "အကောင့်ထွက်ရန်",
    mn: "Гарах",
    lo: "ອອກຈາກລະບົບ",
    tet: "Sai",
    ne: "लग आउट गर्नुहोस्",
    zh: '下班',
    vi: 'Tan ca',
    uz: "Ishdan chiqish",
  );
  static const breakLabel = L10nText(
    ko: '휴게',
    en: 'Break',
    tr: "Mola",
    tg: "Танаффус",
    fil: "Pahinga",
    ur: "وقفہ",
    th: "พักเบรก",
    ky: "Тыныгуу",
    km: "សម្រាក",
    id: "Istirahat",
    si: "විරාමය",
    bn: "বিরতি",
    my: "နားချိန်",
    mn: "Завсарлага",
    lo: "ພັກຜ່ອນ",
    tet: "Deskansa",
    ne: "ब्रेक",
    zh: '休息',
    vi: 'Nghỉ',
    uz: "Tanaffus",
  );

  static const actualWorkedTime = L10nText(
    ko: '실근무시간',
    en: 'Actual hours worked',
    tr: "Gerçek çalışma saatleri",
    tg: "Соатҳои воқеии кор",
    fil: "Aktwal na oras ng trabaho",
    ur: "اصل کام کے اوقات",
    th: "ชั่วโมงทำงานจริง",
    ky: "Иш жүзүндөгү иш сааттары",
    km: "ម៉ោងធ្វើការជាក់ស្តែង",
    id: "Jam kerja aktual",
    si: "සැබෑ වැඩ කරන වේලාවන්",
    bn: "প্রকৃত কাজের সময়",
    my: "အမှန်တကယ် အလုပ်ချိန်",
    mn: "Бодит ажлын цаг",
    lo: "ຊົ່ວໂມງເຮັດວຽກຕົວຈິງ",
    tet: "Oras servisu loos",
    ne: "वास्तविक काम गर्ने घण्टा",
    zh: '实际工作时长',
    vi: 'Thời gian làm việc thực tế',
    uz: "Ishlagan haqiqiy soatlar",
  );
  static const estimatedWage = L10nText(
    ko: '예상 임금(세전)',
    en: 'Estimated wage (pre-tax)',
    tr: "Tahmini ücret (vergi öncesi)",
    tg: "Музди меҳнати тахминӣ (пеш аз андоз)",
    fil: "Tinantyang sahod (bago ang buwis)",
    ur: "تخمینی اجرت (ٹیکس سے پہلے)",
    th: "ค่าจ้างโดยประมาณ (ก่อนหักภาษี)",
    ky: "Болжолдуу эмгек акы (салыкка чейин)",
    km: "ប្រាក់ឈ្នួលប៉ាន់ស្មាន (មុនបង់ពន្ធ)",
    id: "Perkiraan upah (sebelum pajak)",
    si: "ඇස්තමේන්තුගත වැටුප (බදු පෙර)",
    bn: "আনুমানিক মজুরি (কর পূর্ব)",
    my: "ခန့်မှန်းခြေ လုပ်ခ (အခွန်မဆောင်မီ)",
    mn: "Тооцоолсон цалин (татварын өмнө)",
    lo: "ຄ່າຈ້າງທີ່ຄາດຄະເນ (ກ່ອນຫັກພາສີ)",
    tet: "Saláriu estimadu (antes impostu)",
    ne: "अनुमानित ज्याला (कर अघि)",
    zh: '预计工资（税前）',
    vi: 'Lương dự kiến (trước thuế)',
    uz: "Taxminiy ish haqi (soliqdan oldin)",
  );

  /// "이번 달 총 임금 (근무 15일)" — 시안의 "9월 총합계 (근무 15일)"에 대응.
  static String monthTotalWageWithDays(AppLanguage lang, int days) =>
      switch (lang) {
        AppLanguage.ko => '이번 달 총 임금 (근무 $days일)',
        AppLanguage.uz => "Bu oydagi jami ($days kun ishlangan)",
        AppLanguage.en => "This month's total ($days days worked)",
        AppLanguage.tr => "Bu ayın toplamı ($days gün çalışıldı)",
        AppLanguage.tg => "Ҷамъи ин моҳ ($days рӯз кор карда шуд)",
        AppLanguage.fil =>
          "Kabuuang para sa buwang ito ($days araw na nagtrabaho)",
        AppLanguage.ur => "اس مہینے کا کل ($days دن کام کیا گیا)",
        AppLanguage.th => "รวมของเดือนนี้ (ทำงาน $days วัน)",
        AppLanguage.ky => "Бул айдын жалпы суммасы ($days күн иштеген)",
        AppLanguage.km => "សរុបខែនេះ (ធ្វើការបាន $days ថ្ងៃ)",
        AppLanguage.id => "Total bulan ini (bekerja $days hari)",
        AppLanguage.si => "මෙම මාසයේ මුළු එකතුව (වැඩ කළ දින $days)",
        AppLanguage.bn => "এই মাসের মোট ($days দিন কাজ করা হয়েছে)",
        AppLanguage.my => "ဒီလ စုစုပေါင်း ($days ရက် အလုပ်လုပ်ခဲ့သည်)",
        AppLanguage.mn => "Энэ сарын нийт ($days өдөр ажилласан)",
        AppLanguage.lo => "ລວມທັງໝົດຂອງເດືອນນີ້ (ເຮັດວຽກ $days ວັນ)",
        AppLanguage.tet => "Totál fulan ida-ne'e (serbisu loron $days)",
        AppLanguage.ne => "यस महिनाको कुल ($days दिन काम गरियो)",
        AppLanguage.zh => '本月总工资（工作 $days 天）',
        AppLanguage.vi => 'Tổng lương tháng này ($days ngày làm)',
      };

  // ── 간편 입력(시안의 "⚡ 간편 입력" 카드 + 모달) ──────────────────────
  static const quickInputTitle = L10nText(
    ko: '⚡ 간편 입력',
    en: '⚡ Quick entry',
    tr: "⚡ Hızlı giriş",
    tg: "⚡ Вуруди зуд",
    fil: "⚡ Mabilis na pag-input",
    ur: "⚡ فوری اندراج",
    th: "⚡ บันทึกด่วน",
    ky: "⚡ Тез киргизүү",
    km: "⚡ បញ្ចូលរហ័ស",
    id: "⚡ Entri cepat",
    si: "⚡ ඉක්මන් ඇතුළත් කිරීම",
    bn: "⚡ দ্রুত এন্ট্রি",
    my: "⚡ အမြန်ထည့်သွင်းမှု",
    mn: "⚡ Хурдан оруулах",
    lo: "⚡ ປ້ອນຂໍ້ມູນດ່ວນ",
    tet: "⚡ Entrada lalais",
    ne: "⚡ द्रुत प्रविष्टि",
    zh: '⚡ 快速录入',
    vi: '⚡ Nhập nhanh',
    uz: "⚡ Tez kiritish",
  );
  static const quickInputSub = L10nText(
    ko: '시급 × 시간 등록',
    en: 'Set wage × hours',
    tr: "Belirlenen ücret × saat",
    tg: "Музди муайяншуда × соат",
    fil: "Itinakdang sahod × oras",
    ur: "مقررہ اجرت × گھنٹے",
    th: "ค่าจ้างที่กำหนด × ชั่วโมง",
    ky: "Белгиленген эмгек акы × саат",
    km: "ប្រាក់ឈ្នួលដែលបានកំណត់ × ម៉ោង",
    id: "Upah yang ditentukan × jam",
    si: "නිශ්චිත වැටුප × පැය",
    bn: "নির্ধারিত মজুরি × ঘন্টা",
    my: "သတ်မှတ်ထားသော လုပ်ခ × နာရီ",
    mn: "Тогтоосон цалин × цаг",
    lo: "ຄ່າຈ້າງທີ່ກຳນົດ × ຊົ່ວໂມງ",
    tet: "Saláriu estabelesidu × oras",
    ne: "निर्धारित ज्याला × घण्टा",
    zh: '登记时薪 × 时长',
    vi: 'Đăng ký lương × giờ',
    uz: "Ish haqi × soatlarni belgilash",
  );
  static const quickSheetTitle = L10nText(
    ko: '⚡ 간편 근무 입력',
    en: '⚡ Quick work entry',
    tr: "⚡ Hızlı iş girişi",
    tg: "⚡ Вуруди зуди кор",
    fil: "⚡ Mabilis na pag-input ng trabaho",
    ur: "⚡ فوری کام کا اندراج",
    th: "⚡ บันทึกงานด่วน",
    ky: "⚡ Тез жумуш киргизүү",
    km: "⚡ បញ្ចូលការងាររហ័ស",
    id: "⚡ Entri kerja cepat",
    si: "⚡ ඉක්මන් වැඩ ඇතුළත් කිරීම",
    bn: "⚡ দ্রুত কাজের এন্ট্রি",
    my: "⚡ အမြန်အလုပ်ထည့်သွင်းမှု",
    mn: "⚡ Ажлын хурдан бүртгэл",
    lo: "⚡ ປ້ອນຂໍ້ມູນວຽກດ່ວນ",
    tet: "⚡ Entrada servisu lalais",
    ne: "⚡ द्रुत काम प्रविष्टि",
    zh: '⚡ 快速工作录入',
    vi: '⚡ Nhập công việc nhanh',
    uz: "⚡ Tez ish kiritish",
  );
  static const todayWage = L10nText(
    ko: '오늘 예상 임금',
    en: "Today's estimated wage",
    tr: "Bugünün tahmini ücreti",
    tg: "Музди меҳнати тахминии имрӯза",
    fil: "Tinantyang sahod ngayon",
    ur: "آج کی تخمینی اجرت",
    th: "ค่าจ้างโดยประมาณของวันนี้",
    ky: "Бүгүнкү болжолдуу эмгек акы",
    km: "ប្រាក់ឈ្នួលប៉ាន់ស្មានថ្ងៃនេះ",
    id: "Perkiraan upah hari ini",
    si: "අද දින ඇස්තමේන්තුගත වැටුප",
    bn: "আজকের আনুমানিক মজুরি",
    my: "ယနေ့ ခန့်မှန်းခြေ လုပ်ခ",
    mn: "Өнөөдрийн тооцоолсон цалин",
    lo: "ຄ່າຈ້າງທີ່ຄາດຄະເນຂອງມື້ນີ້",
    tet: "Saláriu estimadu ba ohin",
    ne: "आजको अनुमानित ज्याला",
    zh: '今日预计工资',
    vi: 'Lương dự kiến hôm nay',
    uz: "Bugungi taxminiy ish haqi",
  );
  static const todayWageWithTax = L10nText(
    ko: '오늘 예상 임금 (세전)',
    en: "Today's estimated wage (pre-tax)",
    tr: "Bugünün tahmini ücreti (vergi öncesi)",
    tg: "Музди меҳнати тахминии имрӯза (пеш аз андоз)",
    fil: "Tinantyang sahod ngayon (bago ang buwis)",
    ur: "آج کی تخمینی اجرت (ٹیکس سے پہلے)",
    th: "ค่าจ้างโดยประมาณของวันนี้ (ก่อนหักภาษี)",
    ky: "Бүгүнкү болжолдуу эмгек акы (салыкка чейин)",
    km: "ប្រាក់ឈ្នួលប៉ាន់ស្មានថ្ងៃនេះ (មុនបង់ពន្ធ)",
    id: "Perkiraan upah hari ini (sebelum pajak)",
    si: "අද දින ඇස්තමේන්තුගත වැටුප (බදු පෙර)",
    bn: "আজকের আনুমানিক মজুরি (কর পূর্ব)",
    my: "ယနေ့ ခန့်မှန်းခြေ လုပ်ခ (အခွန်မဆောင်မီ)",
    mn: "Өнөөдрийн тооцоолсон цалин (татварын өмнө)",
    lo: "ຄ່າຈ້າງທີ່ຄາດຄະເນຂອງມື້ນີ້ (ກ່ອນຫັກພາສີ)",
    tet: "Saláriu estimadu ba ohin (antes impostu)",
    ne: "आजको अनुमानित ज्याला (कर अघि)",
    zh: '今日预计工资（税前）',
    vi: 'Lương dự kiến hôm nay (trước thuế)',
    uz: "Bugungi taxminiy ish haqi (soliqdan oldin)",
  );

  /// "시급 10,320원 (세전)" — 오늘 예상 임금 카드의 보조 문구.
  static String hourlyWageMeta(AppLanguage lang, String wage) => switch (lang) {
    AppLanguage.ko => '시급 $wage (세전)',
    AppLanguage.uz => "$wage/soat (soliqdan oldin)",
    AppLanguage.en => '$wage/hour (pre-tax)',
    AppLanguage.tr => "$wage/saat (vergi öncesi)",
    AppLanguage.tg => "$wage/соат (пеш аз андоз)",
    AppLanguage.fil => "$wage/oras (bago ang buwis)",
    AppLanguage.ur => "$wage/گھنٹہ (ٹیکس سے پہلے)",
    AppLanguage.th => "$wage/ชั่วโมง (ก่อนหักภาษี)",
    AppLanguage.ky => "$wage/саат (салыкка чейин)",
    AppLanguage.km => "$wage/ម៉ោង (មុនបង់ពន្ធ)",
    AppLanguage.id => "$wage/jam (sebelum pajak)",
    AppLanguage.si => "පැයකට KRW $wage (බදු පෙර)",
    AppLanguage.bn => "$wage/ঘণ্টা (কর পূর্ব)",
    AppLanguage.my => "$wage/နာရီ (အခွန်မဆောင်မီ)",
    AppLanguage.mn => "$wage/цаг (татварын өмнө)",
    AppLanguage.lo => "$wage/ຊົ່ວໂມງ (ກ່ອນຫັກພາສີ)",
    AppLanguage.tet => "$wage/oras (antes impostu)",
    AppLanguage.ne => "$wage/घण्टा (कर अघि)",
    AppLanguage.zh => '时薪 $wage（税前）',
    AppLanguage.vi => '$wage/giờ (trước thuế)',
  };

  static const hourlyWageDialogTitle = L10nText(
    ko: '적용 시급',
    en: 'Hourly wage',
    tr: "Saatlik ücret",
    tg: "Музди меҳнати соатбайъ",
    fil: "Orasang sahod",
    ur: "فی گھنٹہ اجرت",
    th: "ค่าจ้างรายชั่วโมง",
    ky: "Сааттык эмгек акы",
    km: "ប្រាក់ឈ្នួលក្នុងមួយម៉ោង",
    id: "Upah per jam",
    si: "පැයක වැටුප",
    bn: "ঘণ্টাপ্রতি মজুরি",
    my: "တစ်နာရီ လုပ်ခ",
    mn: "Цагийн хөлс",
    lo: "ຄ່າຈ້າງລາຍຊົ່ວໂມງ",
    tet: "Saláriu kada oras",
    ne: "प्रति घण्टा ज्याला",
    zh: '适用时薪',
    vi: 'Lương theo giờ',
    uz: "Soatlik ish haqi",
  );
  static const hourlyWageInputHint = L10nText(
    ko: '숫자를 눌러 직접 입력할 수 있어요',
    en: 'Tap the number to type it directly',
    tr: "Doğrudan yazmak için sayıya dokunun",
    tg: "Барои мустақиман навиштан ба рақам ламс кунед",
    fil: "I-tap ang numero para direktang mag-type",
    ur: "براہ راست لکھنے کے لیے نمبر پر ٹیپ کریں۔",
    th: "แตะที่ตัวเลขเพื่อพิมพ์โดยตรง",
    ky: "Түз жазуу үчүн санды басыңыз",
    km: "ប៉ះលេខដើម្បីវាយបញ្ចូលដោយផ្ទាល់",
    id: "Ketuk angka untuk mengetik langsung",
    si: "සෘජුවම ටයිප් කිරීමට අංකය තට්ටු කරන්න",
    bn: "সরাসরি টাইপ করতে সংখ্যায় ট্যাপ করুন",
    my: "တိုက်ရိုက်ရိုက်ထည့်ရန် နံပါတ်ကို နှိပ်ပါ",
    mn: "Шууд бичихийн тулд тоон дээр дарна уу",
    lo: "ແຕະທີ່ຕົວເລກເພື່ອພິມໂດຍກົງ",
    tet: "Buka númeru atu hakerek direitamente",
    ne: "सीधा लेख्नको लागि संख्यामा ट्याप गर्नुहोस्",
    zh: '点击数字可直接输入',
    vi: 'Chạm vào số để nhập trực tiếp',
    uz: "Raqamni toʻgʻridan-toʻgʻri kiritish uchun bosing",
  );
  static const workedHoursLabel = L10nText(
    ko: '오늘 일한 시간',
    en: 'Hours worked today',
    tr: "Bugün çalışılan saat",
    tg: "Соатҳои имрӯз коркардашуда",
    fil: "Oras na nagtrabaho ngayon",
    ur: "آج کام کیے گئے گھنٹے",
    th: "ชั่วโมงทำงานวันนี้",
    ky: "Бүгүн иштеген саат",
    km: "ម៉ោងធ្វើការថ្ងៃនេះ",
    id: "Jam kerja hari ini",
    si: "අද වැඩ කළ පැය",
    bn: "আজ কাজ করা ঘন্টা",
    my: "ယနေ့ အလုပ်လုပ်ခဲ့သော နာရီ",
    mn: "Өнөөдөр ажилласан цаг",
    lo: "ຊົ່ວໂມງທີ່ເຮັດວຽກໃນມື້ນີ້",
    tet: "Oras servisu ohin",
    ne: "आज काम गरेको घण्टा",
    zh: '今天工作时长',
    vi: 'Số giờ làm hôm nay',
    uz: "Bugun ishlagan soatlar",
  );
  static const workedHoursHint = L10nText(
    ko: '휴게시간 제외 실근무',
    en: 'Actual hours, excluding breaks',
    tr: "Molalar hariç gerçek saatler",
    tg: "Соатҳои воқеӣ ба истиснои танаффусҳо",
    fil: "Aktwal na oras, hindi kasama ang mga break",
    ur: "وقفوں کے علاوہ اصل گھنٹے",
    th: "ชั่วโมงจริงไม่รวมเวลาพัก",
    ky: "Тыныгууларды кошпогондогу иш жүзүндөгү сааттар",
    km: "ម៉ោងជាក់ស្តែងមិនរាប់បញ្ចូលម៉ោងសម្រាក",
    id: "Jam aktual tidak termasuk istirahat",
    si: "විවේක හැර සැබෑ පැය ගණන",
    bn: "বিরতি বাদে প্রকৃত ঘন্টা",
    my: "နားချိန်များ မပါဝင်သော အမှန်တကယ် နာရီများ",
    mn: "Завсарлагаанаас бусад бодит цаг",
    lo: "ຊົ່ວໂມງຕົວຈິງ ບໍ່ລວມເວລາພັກຜ່ອນ",
    tet: "Oras loos la inklui deskansa",
    ne: "ब्रेक बाहेक वास्तविक घण्टा",
    zh: '不含休息的实际工时',
    vi: 'Giờ làm thực tế, không tính nghỉ',
    uz: "Haqiqiy soatlar, tanaffuslarsiz",
  );
  static const quickSaveButton = L10nText(
    ko: '오늘 임금 기록 저장하기',
    en: "Save today's wage record",
    tr: "Bugünün ücret kaydını kaydet",
    tg: "Сабти музди меҳнати имрӯзаро захира кунед",
    fil: "I-save ang record ng sahod ngayon",
    ur: "آج کی اجرت کا ریکارڈ محفوظ کریں۔",
    th: "บันทึกค่าจ้างวันนี้",
    ky: "Бүгүнкү эмгек акы жазуусун сактоо",
    km: "រក្សាទុកកំណត់ត្រាប្រាក់ឈ្នួលថ្ងៃនេះ",
    id: "Simpan catatan upah hari ini",
    si: "අද දින වැටුප් වාර්තාව සුරකින්න",
    bn: "আজকের মজুরি রেকর্ড সংরক্ষণ করুন",
    my: "ယနေ့ လုပ်ခမှတ်တမ်းကို သိမ်းဆည်းရန်",
    mn: "Өнөөдрийн цалингийн бүртгэлийг хадгалах",
    lo: "ບັນທຶກຄ່າຈ້າງຂອງມື້ນີ້",
    tet: "Rai rejistu saláriu ohin nian",
    ne: "आजको ज्याला रेकर्ड बचत गर्नुहोस्",
    zh: '保存今天的工资记录',
    vi: 'Lưu ghi chép lương hôm nay',
    uz: "Bugungi ish haqi yozuvini saqlash",
  );
  static const quickSavedToast = L10nText(
    ko: '근무 기록이 업데이트되었어요.',
    en: 'Your work record has been updated.',
    tr: "Çalışma kaydınız güncellendi.",
    tg: "Сабти кори шумо нав карда шуд.",
    fil: "Na-update ang iyong record ng trabaho.",
    ur: "آپ کا کام کا ریکارڈ اپ ڈیٹ کر دیا گیا ہے۔",
    th: "บันทึกการทำงานของคุณได้รับการอัปเดตแล้ว",
    ky: "Сиздин жумуш жазууңуз жаңыртылды.",
    km: "កំណត់ត្រាការងាររបស់អ្នកត្រូវបានធ្វើបច្ចុប្បន្នភាព។",
    id: "Catatan kerja Anda telah diperbarui.",
    si: "ඔබගේ වැඩ වාර්තාව යාවත්කාලීන කරන ලදී.",
    bn: "আপনার কাজের রেকর্ড আপডেট করা হয়েছে।",
    my: "သင့်အလုပ်မှတ်တမ်းကို အပ်ဒိတ်လုပ်ပြီးပါပြီ။",
    mn: "Таны ажлын бүртгэл шинэчлэгдлээ.",
    lo: "ບັນທຶກການເຮັດວຽກຂອງທ່ານໄດ້ຖືກອັບເດດແລ້ວ.",
    tet: "Imi-nia rejistu servisu atualiza ona.",
    ne: "तपाईंको कामको रेकर्ड अद्यावधिक गरिएको छ।",
    zh: '工作记录已更新。',
    vi: 'Ghi chép làm việc đã được cập nhật.',
    uz: "Ish yozuvingiz yangilandi.",
  );
  static const hourlyWageDialogSubtitle = L10nText(
    ko: '실근무시간 × 시급으로 대략적인 임금을 계산해요. 정확한 계산은 임금계산기 탭을 이용하세요.',
    en: 'We estimate wages as hours worked × hourly wage. For an exact calculation, use the Wage Calculator tab.',
    tr: "Ücretleri çalışılan saat × saatlik ücret olarak tahmin ediyoruz. Kesin bir hesaplama için Ücret Hesaplayıcı sekmesini kullanın.",
    tg: "Мо музди меҳнатро ҳамчун соатҳои корӣ × музди соатбайъ тахмин мекунем. Барои ҳисобкунии дақиқ, ҷадвали Ҳисобкунаки музди меҳнатро истифода баред.",
    fil:
        "Tinatantya namin ang sahod bilang oras na nagtrabaho × orasang sahod. Para sa tumpak na kalkulasyon, gamitin ang tab na Wage Calculator.",
    ur: "ہم کام کیے گئے گھنٹوں × فی گھنٹہ اجرت کے حساب سے اجرت کا تخمینہ لگاتے ہیں۔ درست حساب کے لیے اجرت کیلکولیٹر ٹیب استعمال کریں۔",
    th: "เราประมาณค่าจ้างจากชั่วโมงทำงาน × ค่าจ้างรายชั่วโมง สำหรับการคำนวณที่แม่นยำ โปรดใช้แท็บเครื่องคำนวณค่าจ้าง",
    ky: "Биз эмгек акыны иштеген саат × сааттык эмгек акы катары эсептейбиз. Так эсептөө үчүн Эмгек акы калькулятору өтмөгүн колдонуңуз.",
    km: "យើងប៉ាន់ស្មានប្រាក់ឈ្នួលជាម៉ោងធ្វើការ × ប្រាក់ឈ្នួលក្នុងមួយម៉ោង។ សម្រាប់ការគណនាជាក់លាក់ សូមប្រើផ្ទាំងម៉ាស៊ីនគិតលេខប្រាក់ឈ្នួល។",
    id: "Kami memperkirakan upah sebagai jam kerja × upah per jam. Untuk perhitungan yang akurat, gunakan tab Kalkulator Upah.",
    si: "අපි වැඩ කළ පැය × පැයක වැටුප ලෙස වැටුප් ඇස්තමේන්තු කරමු. නිවැරදි ගණනය කිරීමක් සඳහා වැටුප් කැල්කියුලේටරය ටැබය භාවිතා කරන්න.",
    bn: "আমরা কাজ করা ঘন্টা × ঘণ্টাপ্রতি মজুরি হিসাবে মজুরি অনুমান করি। একটি সঠিক গণনার জন্য, মজুরি ক্যালকুলেটর ট্যাবটি ব্যবহার করুন।",
    my: "လုပ်ခများကို အလုပ်လုပ်ခဲ့သော နာရီ × တစ်နာရီ လုပ်ခအဖြစ် ခန့်မှန်းပါသည်။ တိကျသော တွက်ချက်မှုအတွက် လုပ်ခတွက်စက် တက်ဘ်ကို အသုံးပြုပါ။",
    mn: "Бид цалинг ажилласан цаг × цагийн хөлсөөр тооцдог. Нарийвчилсан тооцоо хийхийн тулд Цалин тооцоологч таб ашиглана уу.",
    lo: "ພວກເຮົາຄາດຄະເນຄ່າຈ້າງໂດຍການຄູນຊົ່ວໂມງທີ່ເຮັດວຽກກັບຄ່າຈ້າງລາຍຊົ່ວໂມງ. ສໍາລັບການຄິດໄລ່ທີ່ຊັດເຈນ, ໃຫ້ໃຊ້ແຖບເຄື່ອງຄິດໄລ່ຄ່າຈ້າງ.",
    tet:
        "Ami estimasaun saláriu hanesan oras servisu × saláriu kada oras. Atu halo kalkulasaun ne'ebé loos, uza tab Kalkuladór Saláriu nian.",
    ne: "हामी काम गरेको घण्टा × प्रति घण्टा ज्यालाको रूपमा ज्याला अनुमान गर्छौं। सटीक गणनाको लागि ज्याला क्याल्कुलेटर ट्याब प्रयोग गर्नुहोस्।",
    zh: '按"实际工作时长 × 时薪"估算工资。精确计算请使用工资计算器标签页。',
    vi: 'Lương được ước tính bằng giờ làm thực tế × lương theo giờ. Để tính chính xác, hãy dùng tab Máy tính lương.',
    uz: "Ish haqini ishlagan soatlar × soatlik ish haqi deb hisoblaymiz. Aniq hisoblash uchun Ish haqi kalkulyatori yorligʻidan foydalaning.",
  );

  static const photoAttach = L10nText(
    ko: '📷 사진 첨부',
    en: '📷 Attach photo',
    tr: "📷 Fotoğraf ekle",
    tg: "📷 Акс илова кунед",
    fil: "📷 Magdagdag ng larawan",
    ur: "📷 تصویر شامل کریں۔",
    th: "📷 เพิ่มรูปภาพ",
    ky: "📷 Сүрөт кошуу",
    km: "📷 បន្ថែមរូបថត",
    id: "📷 Tambah foto",
    si: "📷 ඡායාරූපයක් එක් කරන්න",
    bn: "📷 ছবি যোগ করুন",
    my: "📷 ဓာတ်ပုံထည့်ရန်",
    mn: "📷 Зураг нэмэх",
    lo: "📷 ເພີ່ມຮູບພາບ",
    tet: "📷 Tau fotografia",
    ne: "📷 फोटो थप्नुहोस्",
    zh: '📷 添加照片',
    vi: '📷 Thêm ảnh',
    uz: "📷 Surat biriktirish",
  );
  static const transitCardAttach = L10nText(
    ko: '🚌 교통카드 기록',
    en: '🚌 Transit card record',
    tr: "🚌 Ulaşım kartı kaydı",
    tg: "🚌 Бақайдгирии корти нақлиётӣ",
    fil: "🚌 Pagpaparehistro ng transport card",
    ur: "🚌 ٹرانسپورٹ کارڈ کی رجسٹریشن",
    th: "🚌 ลงทะเบียนบัตรโดยสาร",
    ky: "🚌 Унаа картасын каттоо",
    km: "🚌 ការចុះឈ្មោះកាតធ្វើដំណើរ",
    id: "🚌 Pendaftaran kartu transportasi",
    si: "🚌 ප්‍රවාහන කාඩ්පත ලියාපදිංචි කරන්න",
    bn: "🚌 পরিবহন কার্ড নিবন্ধন",
    my: "🚌 သယ်ယူပို့ဆောင်ရေးကတ် မှတ်ပုံတင်ခြင်း",
    mn: "🚌 Тээврийн картын бүртгэл",
    lo: "🚌 ການລົງທະບຽນບັດໂດຍສານ",
    tet: "🚌 Rejistu karta transporte",
    ne: "🚌 यातायात कार्ड दर्ता",
    zh: '🚌 交通卡记录',
    vi: '🚌 Lịch sử thẻ giao thông',
    uz: "🚌 Transport karta yozuvi",
  );
  static const audioRecord = L10nText(
    ko: '🎙️ 녹음 첨부',
    en: '🎙️ Attach audio',
    tr: "🎙️ Ses kaydı ekle",
    tg: "🎙️ Сабти овоз илова кунед",
    fil: "🎙️ Magdagdag ng audio recording",
    ur: "🎙️ آڈیو ریکارڈنگ شامل کریں",
    th: "🎙️ เพิ่มเสียงบันทึก",
    ky: "🎙️ Үн жазуусун кошуу",
    km: "🎙️ បន្ថែមការថតសំឡេង",
    id: "🎙️ Tambahkan rekaman suara",
    si: "🎙️ හඬ පටයක් එක් කරන්න",
    bn: "🎙️ ভয়েস রেকর্ডিং যোগ করুন",
    my: "🎙️ အသံမှတ်တမ်း ထည့်သွင်းပါ",
    mn: "🎙️ Дуут бичлэг нэмэх",
    lo: "🎙️ ເພີ່ມການບັນທຶກສຽງ",
    tet: "🎙️ Tau rejistu lian",
    ne: "🎙️ अडियो रेकर्डिङ थप्नुहोस्",
    zh: '🎙️ 添加录音',
    vi: '🎙️ Thêm bản ghi âm',
    uz: "🎙️ Audio biriktirish",
  );

  static const memoHint = L10nText(
    ko: '오늘 있었던 일을 적어두세요 (예: 사장님이 30분 더 일하라고 함)',
    en: 'Write down what happened today (e.g. "Boss asked me to work 30 minutes extra")',
    tr: "Bugün ne olduğunu yazın (örn. \"Patron benden 30 dakika fazla çalışmamı istedi\")",
    tg: "Нависед, ки имрӯз чӣ шуд (масалан, \"Сардор аз ман хоҳиш кард, ки 30 дақиқа зиёдтар кор кунам\")",
    fil:
        "Isulat kung ano ang nangyari ngayon (hal. \"Pinakiusapan ako ng amo na magtrabaho ng 30 minuto nang mas matagal\")",
    ur: "آج کیا ہوا لکھیں (مثلاً، \"باس نے مجھ سے 30 منٹ زیادہ کام کرنے کو کہا\")",
    th: "เขียนสิ่งที่เกิดขึ้นในวันนี้ (เช่น 'เจ้านายขอให้ฉันทำงานล่วงเวลา 30 นาที')",
    ky: "Бүгүн эмне болгонун жазыңыз (мис., \"Кожоюн менден 30 мүнөт ашык иштөөнү суранды\")",
    km: "សរសេរអ្វីដែលបានកើតឡើងនៅថ្ងៃនេះ (ឧទាហរណ៍៖ «ថៅកែបានស្នើសុំឱ្យខ្ញុំធ្វើការបន្ថែម 30 នាទី»)",
    id: "Tulis apa yang terjadi hari ini (misalnya, \"Bos meminta saya bekerja lembur 30 menit\")",
    si: "අද සිදු වූ දේ ලියන්න (උදා: \"අධිපති මට අමතරව විනාඩි 30 ක් වැඩ කරන්න කිව්වා\")",
    bn: "আজ কী ঘটেছে তা লিখুন (যেমন: \"বস আমাকে 30 মিনিট বেশি কাজ করতে বলেছেন\")",
    my: "ဒီနေ့ဘာဖြစ်ခဲ့လဲ ရေးပါ။ (ဥပမာ- \"သူဌေးက ကျွန်တော့်ကို 30 မိနစ် ပိုအလုပ်လုပ်ခိုင်းတယ်\")",
    mn: "Өнөөдөр юу болсныг бичнэ үү (жишээ нь: \"Дарга намайг 30 минут илүү ажиллахыг хүссэн\")",
    lo: "ຂຽນສິ່ງທີ່ເກີດຂຶ້ນໃນມື້ນີ້ (ຕົວຢ່າງ: \"ນາຍຈ້າງຂໍໃຫ້ຂ້ອຍເຮັດວຽກລ່ວງເວລາ 30 ນາທີ\")",
    tet:
        "Hakerek saida mak akontese ohin (ezemplu: \"Xefe husu ha'u atu serbisu tan 30 minutu\")",
    ne: "आज के भयो लेख्नुहोस् (उदाहरण: \"मालिकले मलाई 30 मिनेट बढी काम गर्न भन्नुभयो\")",
    zh: '记下今天发生的事（例如：老板让我多干30分钟）',
    vi: 'Ghi lại những gì đã xảy ra hôm nay (VD: chủ bảo làm thêm 30 phút)',
    uz: "Bugun nima boʻlganini yozing (masalan, \"Boshliq mendan 30 daqiqa qoʻshimcha ishlashni soʻradi\")",
  );

  static const nextStepsLabel = L10nText(
    ko: '기록이 쌓였다면',
    en: 'Once you have records',
    tr: "Kayıtlarınız olduğunda",
    tg: "Вақте ки шумо сабтҳо доред",
    fil: "Kapag mayroon kang mga rekord",
    ur: "جب آپ کے پاس ریکارڈز ہوں",
    th: "เมื่อคุณมีบันทึก",
    ky: "Жазууларыңыз болгондо",
    km: "នៅពេលអ្នកមានកំណត់ត្រា",
    id: "Saat Anda memiliki catatan",
    si: "ඔබට වාර්තා ඇති විට",
    bn: "যখন আপনার রেকর্ড থাকবে",
    my: "သင့်တွင် မှတ်တမ်းများရှိပါက",
    mn: "Таны бүртгэлүүд бэлэн болсон үед",
    lo: "ເມື່ອທ່ານມີບັນທຶກ",
    tet: "Bainhira iha ita-nia rejistu sira",
    ne: "जब तपाईंसँग रेकर्डहरू हुन्छन्",
    zh: '记录积累之后',
    vi: 'Khi đã có đủ ghi chép',
    uz: "Yozuvlaringiz boʻlgach",
  );

  static const wageEntryTitle = L10nText(
    ko: '임금체불 진정 내비게이터',
    en: 'Unpaid Wage Navigator',
    tr: "Ödenmemiş Ücret Rehberi",
    tg: "Дастури музди меҳнати пардохтнашуда",
    fil: "Gabay sa Hindi Nabayarang Sahod",
    ur: "غیر ادا شدہ اجرت کی گائیڈ",
    th: "คู่มือค่าจ้างค้างจ่าย",
    ky: "Төлөнбөгөн эмгек акы боюнча колдонмо",
    km: "មគ្គុទ្ទេសក៍ប្រាក់ឈ្នួលមិនទាន់បានបង់",
    id: "Panduan Gaji yang Belum Dibayar",
    si: "නොගෙවූ වැටුප් මාර්ගෝපදේශය",
    bn: "অপ্রদত্ত মজুরি নির্দেশিকা",
    my: "မရရှိသေးသော လုပ်ခလစာ လမ်းညွှန်",
    mn: "Цалин хөлс аваагүй үеийн гарын авлага",
    lo: "ຄູ່ມືຄ່າຈ້າງທີ່ບໍ່ໄດ້ຮັບ",
    tet: "Gias Saláriu La Selu",
    ne: "भुक्तानी नभएको ज्यालाको लागि मार्गनिर्देशन",
    zh: '拖欠工资申诉导航',
    vi: 'Hướng dẫn khiếu nại nợ lương',
    uz: "Toʻlanmagan ish haqi navigatori",
  );
  static const wageEntrySubtitle = L10nText(
    ko: '단계별로 진정서까지 안내',
    en: 'Step by step, all the way to the report',
    tr: "Adım adım, raporlamaya kadar",
    tg: "Қадам ба қадам, то гузоришдиҳӣ",
    fil: "Hakbang-hakbang, hanggang sa pag-uulat",
    ur: "قدم بہ قدم، رپورٹنگ تک",
    th: "ทีละขั้นตอน จนถึงการรายงาน",
    ky: "Кадам сайын, билдирүүгө чейин",
    km: "មួយជំហានម្តងៗ រហូតដល់ការរាយការណ៍",
    id: "Langkah demi langkah, hingga pelaporan",
    si: "පියවරෙන් පියවර, වාර්තා කිරීම දක්වා",
    bn: "ধাপে ধাপে, রিপোর্ট করা পর্যন্ত",
    my: "အဆင့်ဆင့်၊ တိုင်ကြားသည်အထိ",
    mn: "Алхам алхмаар, тайлагнах хүртэл",
    lo: "ເທື່ອລະຂັ້ນຕອນ, ຈົນເຖິງການລາຍງານ",
    tet: "Pasu ba pasu, to'o relata",
    ne: "चरण-दर-चरण, रिपोर्टिङसम्म",
    zh: '逐步引导直到提交申诉书',
    vi: 'Hướng dẫn từng bước đến khi nộp đơn',
    uz: "Bosqichma-bosqich, hisobotgacha",
  );
  static const injuryEntryTitle = L10nText(
    ko: '산재처리 신청 내비게이터',
    en: 'Workplace Injury Navigator',
    tr: "İş Kazası Rehberi",
    tg: "Дастури садамаи меҳнатӣ",
    fil: "Gabay sa Aksidente sa Trabaho",
    ur: "کام پر حادثے کی گائیڈ",
    th: "คู่มืออุบัติเหตุจากการทำงาน",
    ky: "Өндүрүштүк кырсык боюнча колдонмо",
    km: "មគ្គុទ្ទេសក៍គ្រោះថ្នាក់ការងារ",
    id: "Panduan Kecelakaan Kerja",
    si: "රැකියා අනතුරු මාර්ගෝපදේශය",
    bn: "কর্মক্ষেত্রে দুর্ঘটনা নির্দেশিকা",
    my: "လုပ်ငန်းခွင်ထိခိုက်မှု လမ်းညွှန်",
    mn: "Ажлын ослын гарын авлага",
    lo: "ຄູ່ມືອຸບັດຕິເຫດໃນບ່ອນເຮັດວຽກ",
    tet: "Gias Asidente Serbisu",
    ne: "कार्यस्थल दुर्घटना मार्गनिर्देशन",
    zh: '工伤申报导航',
    vi: 'Hướng dẫn yêu cầu bồi thường tai nạn lao động',
    uz: "Ish joyidagi jarohat navigatori",
  );
  static const injuryEntrySubtitle = L10nText(
    ko: '단계별로 요양급여 신청까지',
    en: 'Step by step, all the way to the benefit claim',
    tr: "Adım adım, tazminat talebine kadar",
    tg: "Қадам ба қадам, то талаби ҷуброн",
    fil: "Hakbang-hakbang, hanggang sa pag-claim ng kompensasyon",
    ur: "قدم بہ قدم، معاوضے کے دعوے تک",
    th: "ทีละขั้นตอน จนถึงการเรียกร้องค่าชดเชย",
    ky: "Кадам сайын, компенсация талабына чейин",
    km: "មួយជំហានម្តងៗ រហូតដល់ការទាមទារសំណង",
    id: "Langkah demi langkah, hingga klaim kompensasi",
    si: "පියවරෙන් පියවර, වන්දි ඉල්ලීම දක්වා",
    bn: "ধাপে ধাপে, ক্ষতিপূরণের দাবি পর্যন্ত",
    my: "အဆင့်ဆင့်၊ လျော်ကြေးတောင်းခံသည်အထိ",
    mn: "Алхам алхмаар, нөхөн олговор нэхэмжлэх хүртэл",
    lo: "ເທື່ອລະຂັ້ນຕອນ, ຈົນເຖິງການຮຽກຮ້ອງຄ່າຊົດເຊີຍ",
    tet: "Pasu ba pasu, to'o husu kompensasaun",
    ne: "चरण-दर-चरण, क्षतिपूर्ति दाबीसम्म",
    zh: '逐步引导直到申请疗养补偿',
    vi: 'Hướng dẫn từng bước đến khi yêu cầu trợ cấp',
    uz: "Bosqichma-bosqich, nafaqa talabigacha",
  );

  // Gregorian calendar names and short weekdays from Unicode CLDR.
  // See docs/licenses/Unicode-CLDR.txt for the data license.
  static const _monthNamesLo = [
    "ມັງກອນ",
    "ກຸມພາ",
    "ມີນາ",
    "ເມສາ",
    "ພຶດສະພາ",
    "ມິຖຸນາ",
    "ກໍລະກົດ",
    "ສິງຫາ",
    "ກັນຍາ",
    "ຕຸລາ",
    "ພະຈິກ",
    "ທັນວາ",
  ];
  static const _weekdayLabelsLo = ["ອາ.", "ຈ.", "ອ.", "ພ.", "ພຫ.", "ສຸ.", "ສ."];
  static const _monthNamesMn = [
    "Нэгдүгээр сар",
    "Хоёрдугаар сар",
    "Гуравдугаар сар",
    "Дөрөвдүгээр сар",
    "Тавдугаар сар",
    "Зургаадугаар сар",
    "Долоодугаар сар",
    "Наймдугаар сар",
    "Есдүгээр сар",
    "Аравдугаар сар",
    "Арван нэгдүгээр сар",
    "Арван хоёрдугаар сар",
  ];
  static const _weekdayLabelsMn = ["Ня", "Да", "Мя", "Лх", "Пү", "Ба", "Бя"];
  static const _monthNamesMy = [
    "ဇန်နဝါရီ",
    "ဖေဖော်ဝါရီ",
    "မတ်",
    "ဧပြီ",
    "မေ",
    "ဇွန်",
    "ဇူလိုင်",
    "ဩဂုတ်",
    "စက်တင်ဘာ",
    "အောက်တိုဘာ",
    "နိုဝင်ဘာ",
    "ဒီဇင်ဘာ",
  ];
  static const _weekdayLabelsMy = [
    "နွေ",
    "လာ",
    "ဂါ",
    "ဟူး",
    "တေး",
    "ကြာ",
    "နေ",
  ];
  static const _monthNamesBn = [
    "জানুয়ারি",
    "ফেব্রুয়ারি",
    "মার্চ",
    "এপ্রিল",
    "মে",
    "জুন",
    "জুলাই",
    "আগস্ট",
    "সেপ্টেম্বর",
    "অক্টোবর",
    "নভেম্বর",
    "ডিসেম্বর",
  ];
  static const _weekdayLabelsBn = [
    "রঃ",
    "সোঃ",
    "মঃ",
    "বুঃ",
    "বৃঃ",
    "শুঃ",
    "শনি",
  ];
  static const _monthNamesSi = [
    "ජනවාරි",
    "පෙබරවාරි",
    "මාර්තු",
    "අප්‍රේල්",
    "මැයි",
    "ජූනි",
    "ජූලි",
    "අගෝස්තු",
    "සැප්තැම්බර්",
    "ඔක්තෝබර්",
    "නොවැම්බර්",
    "දෙසැම්බර්",
  ];
  static const _weekdayLabelsSi = [
    "ඉරි",
    "සඳු",
    "අඟ",
    "බදා",
    "බ්‍රහ",
    "සිකු",
    "සෙන",
  ];
  static const _monthNamesId = [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember",
  ];
  static const _weekdayLabelsId = [
    "Min",
    "Sen",
    "Sel",
    "Rab",
    "Kam",
    "Jum",
    "Sab",
  ];
  static const _monthNamesKm = [
    "មករា",
    "កុម្ភៈ",
    "មីនា",
    "មេសា",
    "ឧសភា",
    "មិថុនា",
    "កក្កដា",
    "សីហា",
    "កញ្ញា",
    "តុលា",
    "វិច្ឆិកា",
    "ធ្នូ",
  ];
  static const _weekdayLabelsKm = ["អា", "ច", "អ", "ពុ", "ព្រ", "សុ", "ស"];
  static const _monthNamesKy = [
    "Январь",
    "Февраль",
    "Март",
    "Апрель",
    "Май",
    "Июнь",
    "Июль",
    "Август",
    "Сентябрь",
    "Октябрь",
    "Ноябрь",
    "Декабрь",
  ];
  static const _weekdayLabelsKy = [
    "жш.",
    "дш.",
    "шш.",
    "шр.",
    "бш.",
    "жм.",
    "иш.",
  ];
  static const _monthNamesTh = [
    "มกราคม",
    "กุมภาพันธ์",
    "มีนาคม",
    "เมษายน",
    "พฤษภาคม",
    "มิถุนายน",
    "กรกฎาคม",
    "สิงหาคม",
    "กันยายน",
    "ตุลาคม",
    "พฤศจิกายน",
    "ธันวาคม",
  ];
  static const _weekdayLabelsTh = ["อา.", "จ.", "อ.", "พ.", "พฤ.", "ศ.", "ส."];
  static const _monthNamesUr = [
    "جنوری",
    "فروری",
    "مارچ",
    "اپریل",
    "مئی",
    "جون",
    "جولائی",
    "اگست",
    "ستمبر",
    "اکتوبر",
    "نومبر",
    "دسمبر",
  ];
  static const _weekdayLabelsUr = [
    "اتوار",
    "پیر",
    "منگل",
    "بدھ",
    "جمعرات",
    "جمعہ",
    "ہفتہ",
  ];
  static const _monthNamesFil = [
    "Enero",
    "Pebrero",
    "Marso",
    "Abril",
    "Mayo",
    "Hunyo",
    "Hulyo",
    "Agosto",
    "Setyembre",
    "Oktubre",
    "Nobyembre",
    "Disyembre",
  ];
  static const _weekdayLabelsFil = [
    "Lin",
    "Lun",
    "Mar",
    "Miy",
    "Huw",
    "Biy",
    "Sab",
  ];
  static const _monthNamesTg = [
    "Январ",
    "Феврал",
    "Март",
    "Апрел",
    "Май",
    "Июн",
    "Июл",
    "Август",
    "Сентябр",
    "Октябр",
    "Ноябр",
    "Декабр",
  ];
  static const _weekdayLabelsTg = [
    "Яшб",
    "Дшб",
    "Сшб",
    "Чшб",
    "Пшб",
    "Ҷмъ",
    "Шнб",
  ];

  static const _monthNamesEn = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// 연·월 표기 — intl 없이 언어별로 손으로 조합한다.
  static String monthLabel(AppLanguage lang, DateTime month) {
    switch (lang) {
      case AppLanguage.ko:
        return '${month.year}년 ${month.month}월';
      case AppLanguage.uz:
        return "${_monthNamesEn[month.month - 1]} ${month.year}";
      case AppLanguage.en:
        return '${_monthNamesEn[month.month - 1]} ${month.year}';
      case AppLanguage.tr:
        return "${_monthNamesTr[month.month - 1]} ${month.year}";
      case AppLanguage.ne:
        return '${_monthNamesNe[month.month - 1]} ${month.year}';
      case AppLanguage.tet:
        return '${_monthNamesTet[month.month - 1]} ${month.year}';
      case AppLanguage.lo:
        return '${_monthNamesLo[month.month - 1]} ${month.year}';
      case AppLanguage.mn:
        return '${_monthNamesMn[month.month - 1]} ${month.year}';
      case AppLanguage.my:
        return '${_monthNamesMy[month.month - 1]} ${month.year}';
      case AppLanguage.bn:
        return '${_monthNamesBn[month.month - 1]} ${month.year}';
      case AppLanguage.si:
        return '${_monthNamesSi[month.month - 1]} ${month.year}';
      case AppLanguage.id:
        return '${_monthNamesId[month.month - 1]} ${month.year}';
      case AppLanguage.km:
        return '${_monthNamesKm[month.month - 1]} ${month.year}';
      case AppLanguage.ky:
        return '${_monthNamesKy[month.month - 1]} ${month.year}';
      case AppLanguage.th:
        return '${_monthNamesTh[month.month - 1]} ${month.year}';
      case AppLanguage.ur:
        return '${_monthNamesUr[month.month - 1]} ${month.year}';
      case AppLanguage.fil:
        return '${_monthNamesFil[month.month - 1]} ${month.year}';
      case AppLanguage.tg:
        return '${_monthNamesTg[month.month - 1]} ${month.year}';
      case AppLanguage.zh:
        return '${month.year}年${month.month}月';
      case AppLanguage.vi:
        return 'Tháng ${month.month}, ${month.year}';
    }
  }

  static const _weekdayLabelsKo = ['일', '월', '화', '수', '목', '금', '토'];
  static const _weekdayLabelsEn = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];
  static const _weekdayLabelsZh = ['日', '一', '二', '三', '四', '五', '六'];
  static const _weekdayLabelsVi = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
  static const _weekdayLabelsUz = [
    'Yak',
    'Du',
    'Se',
    'Chor',
    'Pay',
    'Ju',
    'Shan',
  ];
  static const _weekdayLabelsTr = [
    'Paz',
    'Pzt',
    'Sal',
    'Çar',
    'Per',
    'Cum',
    'Cmt',
  ];
  static const _monthNamesTr = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık',
  ];
  // Korean work records use the Gregorian calendar, also in Nepali.
  static const _monthNamesNe = [
    'जनवरी',
    'फेब्रुअरी',
    'मार्च',
    'अप्रिल',
    'मे',
    'जुन',
    'जुलाई',
    'अगस्ट',
    'सेप्टेम्बर',
    'अक्टोबर',
    'नोभेम्बर',
    'डिसेम्बर',
  ];
  static const _weekdayLabelsNe = [
    'आइत',
    'सोम',
    'मङ्गल',
    'बुध',
    'बिही',
    'शुक्र',
    'शनि',
  ];
  static const _monthNamesTet = [
    'Janeiru',
    'Fevereiru',
    'Marsu',
    'Abril',
    'Maiu',
    'Juñu',
    'Jullu',
    'Agostu',
    'Setembru',
    'Outubru',
    'Novembru',
    'Dezembru',
  ];
  static const _weekdayLabelsTet = [
    'Dom',
    'Seg',
    'Ter',
    'Kua',
    'Kin',
    'Ses',
    'Sáb',
  ];

  static List<String> weekdayLabels(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.ko:
        return _weekdayLabelsKo;
      case AppLanguage.en:
        return _weekdayLabelsEn;
      case AppLanguage.zh:
        return _weekdayLabelsZh;
      case AppLanguage.vi:
        return _weekdayLabelsVi;
      case AppLanguage.uz:
        return _weekdayLabelsUz;
      case AppLanguage.tr:
        return _weekdayLabelsTr;
      case AppLanguage.ne:
        return _weekdayLabelsNe;
      case AppLanguage.tet:
        return _weekdayLabelsTet;
      case AppLanguage.lo:
        return _weekdayLabelsLo;
      case AppLanguage.mn:
        return _weekdayLabelsMn;
      case AppLanguage.my:
        return _weekdayLabelsMy;
      case AppLanguage.bn:
        return _weekdayLabelsBn;
      case AppLanguage.si:
        return _weekdayLabelsSi;
      case AppLanguage.id:
        return _weekdayLabelsId;
      case AppLanguage.km:
        return _weekdayLabelsKm;
      case AppLanguage.ky:
        return _weekdayLabelsKy;
      case AppLanguage.th:
        return _weekdayLabelsTh;
      case AppLanguage.ur:
        return _weekdayLabelsUr;
      case AppLanguage.fil:
        return _weekdayLabelsFil;
      case AppLanguage.tg:
        return _weekdayLabelsTg;
    }
  }
}

/// 하단 가운데 "오늘" 버튼으로 여닫는 근무기록장 시트.
/// 화면 전체를 덮지 않고 하단 탭바는 남겨둔다 — 달력 버튼을 다시 눌러 닫을 수 있게 하기 위함.
class WorkLogSheet extends StatefulWidget {
  const WorkLogSheet({
    super.key,
    required this.isOpen,
    required this.onClose,
    required this.controller,
  });

  final bool isOpen;
  final VoidCallback onClose;

  /// MainShell이 소유한 단일 인스턴스 — 홈 화면의 "오늘의 근무" 위젯과 상태를
  /// 공유한다(홈에서 출근 기록하면 여기서도 바로 보여야 한다).
  final WorkLogController controller;

  @override
  State<WorkLogSheet> createState() => _WorkLogSheetState();
}

class _WorkLogSheetState extends State<WorkLogSheet> {
  WorkLogController get _controller => widget.controller;

  void _openDayRecord(DateTime day, AppLanguage language) {
    _controller.selectDay(day);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Material(
              color: AppColors.background,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              clipBehavior: Clip.antiAlias,
              child: ListenableBuilder(
                listenable: _controller,
                builder: (context, _) {
                  return Column(
                    children: [
                      const _Grabber(),
                      Expanded(
                        child: _DailyHookBody(
                          controller: _controller,
                          scrollController: scrollController,
                          language: language,
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = UserProfileScope.of(context).language;
    return IgnorePointer(
      ignoring: !widget.isOpen,
      child: AnimatedSlide(
        offset: widget.isOpen ? Offset.zero : const Offset(0, 1),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        child: Material(
          color: AppColors.background,
          child: SafeArea(
            top: false,
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, _) {
                return Column(
                  children: [
                    const _Grabber(),
                    _Header(onClose: widget.onClose, language: lang),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _CalendarBlock(
                              controller: _controller,
                              onDayTap: (day) => _openDayRecord(day, lang),
                              language: lang,
                            ),
                            _WageSummarySection(
                              controller: _controller,
                              language: lang,
                              onOpenToday: () =>
                                  _openDayRecord(_controller.today, lang),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// 출퇴근 버튼이 있던 자리 — html_files/frontend_근무기록장_총임금추가.html의
/// "⚡ 간편 입력 + 오늘 예상 임금" 듀얼 카드와 그 아래 "총합계" 배너를 그대로
/// 옮겼다. 간편 입력 카드를 누르면 시급·근무시간 스테퍼 시트가 올라온다.
class _WageSummarySection extends StatelessWidget {
  const _WageSummarySection({
    required this.controller,
    required this.language,
    required this.onOpenToday,
  });

  final WorkLogController controller;
  final AppLanguage language;

  /// 오늘 예상 임금 카드를 누르면 오늘의 일일 기록 시트를 연다(시안의
  /// openDayDetail과 동일).
  final VoidCallback onOpenToday;

  Future<void> _openQuickInput(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          _QuickWageInputSheet(controller: controller, language: language),
    );
    if (saved != true) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(_WorkLogStrings.quickSavedToast.of(language)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 22),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 10,
                  child: _QuickInputCard(
                    language: language,
                    onTap: () => _openQuickInput(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 13,
                  child: _TodayWageCard(
                    controller: controller,
                    language: language,
                    onTap: onOpenToday,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _MonthTotalBanner(controller: controller, language: language),
        ],
      ),
    );
  }
}

/// 시안의 `.btn-quick-record` — FAST 배지가 달린 흰 카드.
class _QuickInputCard extends StatelessWidget {
  const _QuickInputCard({required this.language, required this.onTap});

  final AppLanguage language;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF93C5FD), width: 1.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'FAST',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFD97706),
                ),
              ),
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                _WorkLogStrings.quickInputTitle.of(language),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _WorkLogStrings.quickInputSub.of(language),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

/// 시안의 `.today-pay-preview-card` — 오늘 예상 임금 그라데이션 카드.
class _TodayWageCard extends StatelessWidget {
  const _TodayWageCard({
    required this.controller,
    required this.language,
    required this.onTap,
  });

  final WorkLogController controller;
  final AppLanguage language;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2196F3), Color(0xFF0D47A1)],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    _WorkLogStrings.todayWage.of(language),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${controller.todayWorkedHours.toStringAsFixed(1)}h',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                formatWon(controller.todayWage, language),
                style: const TextStyle(
                  fontSize: 19,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _WorkLogStrings.hourlyWageMeta(
                language,
                formatWon(controller.hourlyWage, language),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.5,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 시안의 `.month-settle-banner` — 이번 달 총합계. 정산 화면은 아직 없어
/// "정산하기" 버튼 대신 금액만 보여준다.
class _MonthTotalBanner extends StatelessWidget {
  const _MonthTotalBanner({required this.controller, required this.language});

  final WorkLogController controller;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _WorkLogStrings.monthTotalWageWithDays(
                    language,
                    controller.monthWorkedDays,
                  ),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    formatWon(controller.monthTotalWage, language),
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.receipt_long_outlined,
            size: 22,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }
}

/// 시안의 `#modal-quick` — 시급과 오늘 일한 시간을 스테퍼로 조절하면 예상
/// 임금이 실시간으로 계산되는 간편 입력 시트.
class _QuickWageInputSheet extends StatefulWidget {
  const _QuickWageInputSheet({
    required this.controller,
    required this.language,
  });

  final WorkLogController controller;
  final AppLanguage language;

  @override
  State<_QuickWageInputSheet> createState() => _QuickWageInputSheetState();
}

class _QuickWageInputSheetState extends State<_QuickWageInputSheet> {
  static const _wageStep = 1000.0;
  static const _hourStep = 0.5;
  static const _minWageInput = 1000.0;
  static const _maxWageInput = 1000000.0;
  static const _maxHours = 24.0;

  late double _wage = widget.controller.hourlyWage;
  late double _hours = widget.controller.todayWorkedHours;
  late final TextEditingController _wageText = TextEditingController(
    text: _wage.round().toString(),
  );

  @override
  void dispose() {
    _wageText.dispose();
    super.dispose();
  }

  void _changeWage(double delta) {
    setState(() {
      _wage = (_wage + delta).clamp(_minWageInput, _maxWageInput);
      _wageText.text = _wage.round().toString();
      _wageText.selection = TextSelection.collapsed(
        offset: _wageText.text.length,
      );
    });
  }

  void _onWageTyped(String value) {
    final parsed = double.tryParse(value.replaceAll(',', '').trim());
    if (parsed == null) return;
    setState(() => _wage = parsed.clamp(0, _maxWageInput));
  }

  void _changeHours(double delta) {
    setState(() => _hours = (_hours + delta).clamp(0, _maxHours));
  }

  void _save() {
    widget.controller.setHourlyWage(_wage);
    widget.controller.setTodayWorkedHours(_hours);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.language;
    return Padding(
      // 시급을 직접 입력할 때 키보드가 시트를 가리지 않도록 밀어 올린다.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Material(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        _WorkLogStrings.quickSheetTitle.of(lang),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      icon: const Icon(Icons.close, size: 20),
                      color: AppColors.textMuted,
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(6),
                      tooltip: _WorkLogStrings.close.of(lang),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                _StepperRow(
                  label: _WorkLogStrings.hourlyWageDialogTitle.of(lang),
                  hint: _WorkLogStrings.hourlyWageInputHint.of(lang),
                  onMinus: () => _changeWage(-_wageStep),
                  onPlus: () => _changeWage(_wageStep),
                  control: SizedBox(
                    width: 104,
                    child: TextField(
                      controller: _wageText,
                      onChanged: _onWageTyped,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        suffixText: lang == AppLanguage.ko ? '원' : 'KRW',
                        suffixStyle: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.blueBorder,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.blueBorder,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _StepperRow(
                  label: _WorkLogStrings.workedHoursLabel.of(lang),
                  hint: _WorkLogStrings.workedHoursHint.of(lang),
                  onMinus: () => _changeHours(-_hourStep),
                  onPlus: () => _changeHours(_hourStep),
                  control: SizedBox(
                    width: 60,
                    child: Text(
                      '${_hours.toStringAsFixed(1)}h',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: AppColors.blueBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _WorkLogStrings.todayWageWithTax.of(lang),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          formatWon(_wage * _hours, lang),
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _WorkLogStrings.hourlyWageDialogSubtitle.of(lang),
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textMuted,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _wage > 0 ? _save : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _WorkLogStrings.quickSaveButton.of(lang),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
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

/// 시안의 `.stepper-row` — 왼쪽 라벨/설명, 오른쪽 [−] 값 [+].
class _StepperRow extends StatelessWidget {
  const _StepperRow({
    required this.label,
    required this.hint,
    required this.control,
    required this.onMinus,
    required this.onPlus,
  });

  final String label;
  final String hint;
  final Widget control;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hint,
                  style: const TextStyle(
                    fontSize: 9.5,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _StepButton(icon: Icons.remove, onTap: onMinus),
          const SizedBox(width: 6),
          control,
          const SizedBox(width: 6),
          _StepButton(icon: Icons.add, onTap: onPlus),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.blueBg,
          border: Border.all(color: AppColors.blueBorder),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
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

class _Header extends StatelessWidget {
  const _Header({required this.onClose, required this.language});
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
                  _WorkLogStrings.title.of(language),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _WorkLogStrings.subtitle.of(language),
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
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
              _WorkLogStrings.close.of(language),
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarBlock extends StatelessWidget {
  const _CalendarBlock({
    required this.controller,
    required this.onDayTap,
    required this.language,
  });
  final WorkLogController controller;
  final ValueChanged<DateTime> onDayTap;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final month = controller.focusedMonth;
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final leadingBlanks = DateTime(month.year, month.month, 1).weekday % 7;
    final weekdayLabels = _WorkLogStrings.weekdayLabels(language);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: controller.goToPreviousMonth,
                icon: const Icon(
                  Icons.chevron_left,
                  size: 18,
                  color: AppColors.textMuted,
                ),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
              SizedBox(
                width: 96,
                child: Text(
                  _WorkLogStrings.monthLabel(language, month),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                onPressed: controller.goToNextMonth,
                icon: const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.textMuted,
                ),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(7, (i) {
              final color = i == 0
                  ? const Color(0xFF2196F3)
                  : i == 6
                  ? const Color(0xFF2196F3)
                  : AppColors.textMuted;
              return Expanded(
                child: Text(
                  weekdayLabels[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              );
            }),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 2),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.92,
            ),
            itemCount: leadingBlanks + daysInMonth,
            itemBuilder: (context, index) {
              if (index < leadingBlanks) return const SizedBox.shrink();
              final day = DateTime(
                month.year,
                month.month,
                index - leadingBlanks + 1,
              );
              return _DayCell(
                day: day,
                controller: controller,
                onTap: onDayTap,
              );
            },
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 11,
            runSpacing: 4,
            children: [
              _LegendDot(
                color: AppColors.secondary,
                label: _WorkLogStrings.legendLogged.of(language),
              ),
              _LegendDot(
                color: AppColors.accent,
                label: _WorkLogStrings.legendOvertime.of(language),
              ),
              _LegendRiskBox(label: _WorkLogStrings.legendRisk.of(language)),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.controller,
    required this.onTap,
  });
  final DateTime day;
  final WorkLogController controller;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    final isToday = DateUtils.isSameDay(day, controller.today);
    final isSelected = DateUtils.isSameDay(day, controller.selectedDay);
    final isRisk = controller.isRiskDay(day);
    final logged = controller.hasRecord(day);
    final overtime = controller.isOvertimeDay(day);
    final weekday = day.weekday % 7;

    final textColor = isToday
        ? Colors.white
        : weekday == 0
        ? const Color(0xFF2196F3)
        : weekday == 6
        ? const Color(0xFF2196F3)
        : AppColors.textPrimary;

    return InkWell(
      onTap: () => onTap(day),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          color: isToday ? AppColors.primary : null,
          borderRadius: BorderRadius.circular(8),
          border: isRisk
              ? Border.all(color: const Color(0xFF0D47A1), width: 1.5)
              : isSelected
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: TextStyle(
                fontSize: 11,
                color: textColor,
                fontWeight: isToday ? FontWeight.w800 : FontWeight.w400,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (logged)
                  _Dot(color: isToday ? Colors.white : AppColors.secondary),
                if (overtime) ...[
                  const SizedBox(width: 2),
                  _Dot(color: isToday ? Colors.white : AppColors.accent),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 9.5, color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _LegendRiskBox extends StatelessWidget {
  const _LegendRiskBox({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: const Color(0xFF0D47A1), width: 1.5),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 9.5, color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _DailyHookBody extends StatelessWidget {
  const _DailyHookBody({
    required this.controller,
    this.scrollController,
    required this.language,
  });
  final WorkLogController controller;
  final ScrollController? scrollController;
  final AppLanguage language;

  Future<void> _pickTime(
    BuildContext context, {
    required bool isClockIn,
  }) async {
    final record = controller.selectedRecord;
    final initial =
        (isClockIn ? record.clockIn : record.clockOut) ??
        const TimeOfDay(hour: 9, minute: 0);
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;
    controller.updateSelectedRecord(
      (r) => isClockIn
          ? r.copyWith(clockIn: picked)
          : r.copyWith(clockOut: picked),
    );
  }

  Future<void> _pickBreakMinutes(BuildContext context) async {
    var value = controller.selectedRecord.breakMinutes;
    final result = await showDialog<int>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                _WorkLogStrings.breakTimeTitle.of(language),
                style: const TextStyle(fontSize: 15),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${value}m',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  Slider(
                    value: value.toDouble(),
                    min: 0,
                    max: 120,
                    divisions: 12,
                    label: '${value}m',
                    onChanged: (v) => setState(() => value = v.round()),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(_WorkLogStrings.cancel.of(language)),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(value),
                  child: Text(_WorkLogStrings.confirm.of(language)),
                ),
              ],
            );
          },
        );
      },
    );
    if (result == null) return;
    controller.updateSelectedRecord((r) => r.copyWith(breakMinutes: result));
  }

  String _fmtTime(TimeOfDay? t) => t == null
      ? '--:--'
      : '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final record = controller.selectedRecord;
    final day = controller.selectedDay;
    final worked = record.workedDuration;

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(15, 13, 15, 20),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${day.year}.${day.month.toString().padLeft(2, '0')}.${day.day.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  _LocationVerifyBadge(
                    record: record,
                    isToday: DateUtils.isSameDay(day, controller.today),
                    language: language,
                    onVerified: (lat, lng, address) =>
                        controller.updateSelectedRecord(
                          (r) => r.copyWith(
                            gpsVerified: true,
                            verifiedLatitude: lat,
                            verifiedLongitude: lng,
                            verifiedAddress: address,
                          ),
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 11),
              _TimeRow(
                label: _WorkLogStrings.clockIn.of(language),
                value: _fmtTime(record.clockIn),
                onTap: () => _pickTime(context, isClockIn: true),
              ),
              const SizedBox(height: 8),
              _TimeRow(
                label: _WorkLogStrings.clockOut.of(language),
                value: _fmtTime(record.clockOut),
                onTap: () => _pickTime(context, isClockIn: false),
              ),
              const SizedBox(height: 8),
              _TimeRow(
                label: _WorkLogStrings.breakLabel.of(language),
                value: '${record.breakMinutes}m',
                onTap: () => _pickBreakMinutes(context),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.blueBg,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _WorkLogStrings.actualWorkedTime.of(language),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${worked.inHours}h ${(worked.inMinutes % 60).toString().padLeft(2, '0')}m',
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.green50,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _WorkLogStrings.estimatedWage.of(language),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.green900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      formatWon(controller.wageForDay(day), language),
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.green900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _AttachButton(
                      label: _WorkLogStrings.photoAttach.of(language),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EvidenceFilesScreen(
                            title: _WorkLogStrings.photoAttach.of(language),
                            category: 'worklog_photo',
                            day: day,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: _AttachButton(
                      label: _WorkLogStrings.audioRecord.of(language),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EvidenceFilesScreen(
                            title: _WorkLogStrings.audioRecord.of(language),
                            category: 'worklog_audio',
                            day: day,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: _AttachButton(
                      label: _WorkLogStrings.transitCardAttach.of(language),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EvidenceFilesScreen(
                            title: _WorkLogStrings.transitCardAttach.of(
                              language,
                            ),
                            category: 'worklog_transit',
                            day: day,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              TextField(
                minLines: 2,
                maxLines: 4,
                controller: TextEditingController(text: record.memo)
                  ..selection = TextSelection.collapsed(
                    offset: record.memo.length,
                  ),
                onChanged: (v) =>
                    controller.updateSelectedRecord((r) => r.copyWith(memo: v)),
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  hintText: _WorkLogStrings.memoHint.of(language),
                  hintStyle: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFFBFDFF),
                  contentPadding: const EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 11),
        VaultBox(language: language),
        const SizedBox(height: 14),
        Text(
          _WorkLogStrings.nextStepsLabel.of(language),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _EntryCard(
                gradient: const [Color(0xFF2196F3), Color(0xFF0D47A1)],
                emoji: '💸',
                title: _WorkLogStrings.wageEntryTitle.of(language),
                subtitle: _WorkLogStrings.wageEntrySubtitle.of(language),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const WageNavigatorScreen(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: _EntryCard(
                gradient: const [Color(0xFF4CAF50), Color(0xFF1B5E20)],
                emoji: '⛑️',
                title: _WorkLogStrings.injuryEntryTitle.of(language),
                subtitle: _WorkLogStrings.injuryEntrySubtitle.of(language),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AccidentNavigatorScreen(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TimeRow extends StatelessWidget {
  const _TimeRow({
    required this.label,
    required this.value,
    required this.onTap,
  });
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 44,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Text(
                    '▾',
                    style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 오늘 기록이면서 아직 인증 전이면 "위치 인증하기" 버튼을, 그 외에는 기존
/// 완료/사업장 외부 안내 배지를 보여준다. 과거 날짜는 GPS를 다시 딸 수 없으니
/// 그때 기록된 값을 그대로 배지로만 보여주고 버튼을 띄우지 않는다.
class _LocationVerifyBadge extends StatefulWidget {
  const _LocationVerifyBadge({
    required this.record,
    required this.isToday,
    required this.language,
    required this.onVerified,
  });

  final DailyWorkRecord record;
  final bool isToday;
  final AppLanguage language;
  final void Function(double latitude, double longitude, String? address)
  onVerified;

  @override
  State<_LocationVerifyBadge> createState() => _LocationVerifyBadgeState();
}

class _LocationVerifyBadgeState extends State<_LocationVerifyBadge> {
  bool _verifying = false;

  Future<void> _verify() async {
    final lang = widget.language;
    setState(() => _verifying = true);
    try {
      final outcome = await LocationVerifyService().verifyCurrentLocation(
        language: lang,
      );
      switch (outcome.status) {
        case LocationVerifyStatus.verified:
          widget.onVerified(
            outcome.result!.latitude,
            outcome.result!.longitude,
            outcome.result!.address,
          );
          break;
        case LocationVerifyStatus.serviceDisabled:
          _showMessage(_WorkLogStrings.gpsServiceDisabled.of(lang));
          break;
        case LocationVerifyStatus.permissionDenied:
          _showMessage(_WorkLogStrings.gpsPermissionDenied.of(lang));
          break;
        case LocationVerifyStatus.rejected:
          _showMessage(_WorkLogStrings.gpsVerifyFailed.of(lang));
          break;
        case LocationVerifyStatus.error:
          _showMessage(_WorkLogStrings.gpsVerifyError.of(lang));
          break;
      }
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final record = widget.record;
    final lang = widget.language;

    if (widget.isToday && !record.gpsVerified) {
      return InkWell(
        onTap: _verifying ? null : _verify,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_verifying) ...[
                const SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.6,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                _WorkLogStrings.gpsVerifyButton.of(lang),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 150),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: record.gpsVerified
            ? const Color(0xFFE8F5E9)
            : const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            record.gpsVerified
                ? _WorkLogStrings.gpsVerified.of(lang)
                : _WorkLogStrings.gpsUnverified.of(lang),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: record.gpsVerified
                  ? const Color(0xFF1B5E20)
                  : const Color(0xFF0D47A1),
            ),
          ),
          // 좌표 숫자 대신 서버가 역지오코딩으로 돌려준 주소 문자열을 보여준다
          // — 지오코딩 실패 시(verifiedAddress == null)엔 위 완료 문구만
          // 남기고 조용히 생략한다.
          if (record.gpsVerified && record.verifiedAddress != null)
            Text(
              record.verifiedAddress!,
              maxLines: 2,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 8.5, color: Color(0xFF1B5E20)),
            ),
        ],
      ),
    );
  }
}

class _AttachButton extends StatelessWidget {
  const _AttachButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF90CAF9)),
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({
    required this.gradient,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final List<Color> gradient;
  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 17)),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 9.5,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
