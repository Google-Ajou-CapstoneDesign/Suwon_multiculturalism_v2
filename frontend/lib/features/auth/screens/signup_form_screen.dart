import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../core/visa_status.dart';
import '../../../theme/app_colors.dart';
import '../models/country.dart';
import '../models/signup_draft.dart';
import '../services/auth_service.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/country_sheet.dart';
import '../widgets/google_signin_button.dart';
import '../widgets/visa_picker.dart';
import 'consent_screen.dart';

class _S {
  _S._();

  static const title = L10nText(
    ko: '회원가입',
    en: 'Sign up',
    tr: "Kaydol",
    tg: "Сабти ном",
    fil: "Magrehistro",
    ur: "سائن اپ کریں",
    th: "ลงทะเบียน",
    ky: "Катталуу",
    km: "ចុះឈ្មោះ",
    id: "Daftar",
    si: "ලියාපදිංචි වන්න",
    bn: "সাইন আপ করুন",
    my: "အကောင့်ဖွင့်ရန်",
    mn: "Бүртгүүлэх",
    lo: "ລົງທະບຽນ",
    tet: "Rejistu",
    ne: "दर्ता गर्नुहोस्",
    zh: '注册',
    vi: 'Đăng ký',
    uz: "Roʻyxatdan oʻtish",
  );
  static const googleLabel = L10nText(
    ko: 'Google로 계속 가입하기',
    en: 'Continue signing up with Google',
    tr: "Google ile kaydolmaya devam et",
    tg: "Сабти номро бо Google идома диҳед",
    fil: "Magpatuloy sa pagrehistro gamit ang Google",
    ur: "گوگل کے ساتھ سائن اپ جاری رکھیں",
    th: "ดำเนินการลงทะเบียนด้วย Google ต่อไป",
    ky: "Google аркылуу каттоону улантуу",
    km: "បន្តចុះឈ្មោះជាមួយ Google",
    id: "Lanjutkan pendaftaran dengan Google",
    si: "ගූගල් සමඟ ලියාපදිංචි වීම දිගටම කරගෙන යන්න",
    bn: "গুগল দিয়ে সাইন আপ করা চালিয়ে যান",
    my: "Google ဖြင့် ဆက်လက်၍ အကောင့်ဖွင့်ရန်",
    mn: "Google-ээр бүртгүүлэхээ үргэлжлүүлэх",
    lo: "ສືບຕໍ່ລົງທະບຽນດ້ວຍ Google",
    tet: "Kontinua rejistu ho Google",
    ne: "गुगलबाट दर्ता गर्न जारी राख्नुहोस्",
    zh: '使用Google继续注册',
    vi: 'Tiếp tục đăng ký bằng Google',
    uz: "Google orqali roʻyxatdan oʻtishni davom ettirish",
  );
  static const googleDoneLabel = L10nText(
    ko: 'Google 계정으로 연결됨',
    en: 'Connected with your Google account',
    tr: "Google hesabınızla bağlandı",
    tg: "Бо ҳисоби Google-и шумо пайваст шуд",
    fil: "Nakakonekta sa iyong Google account",
    ur: "آپ کے گوگل اکاؤنٹ سے منسلک ہو گیا ہے۔",
    th: "เชื่อมต่อกับบัญชี Google ของคุณแล้ว",
    ky: "Google аккаунтуңуз менен туташты",
    km: "បានភ្ជាប់ជាមួយគណនី Google របស់អ្នក។",
    id: "Terhubung dengan akun Google Anda",
    si: "ඔබගේ ගූගල් ගිණුම සමඟ සම්බන්ධයි",
    bn: "আপনার গুগল অ্যাকাউন্টের সাথে সংযুক্ত হয়েছে",
    my: "သင်၏ Google အကောင့်ဖြင့် ချိတ်ဆက်ထားသည်",
    mn: "Таны Google бүртгэлтэй холбогдсон",
    lo: "ເຊື່ອມຕໍ່ກັບບັນຊີ Google ຂອງທ່ານແລ້ວ",
    tet: "Konektadu ona ho Ita-nia konta Google",
    ne: "तपाईंको गुगल खातासँग जोडिएको छ",
    zh: '已通过Google账号连接',
    vi: 'Đã liên kết bằng tài khoản Google',
    uz: "Google hisobingiz bilan bogʻlangan",
  );
  static const orDivider = L10nText(
    ko: '또는 이메일로 가입',
    en: 'Or sign up with email',
    tr: "Veya e-posta ile kaydolun",
    tg: "Ё бо почтаи электронӣ сабти ном кунед",
    fil: "O magrehistro gamit ang email",
    ur: "یا ای میل کے ساتھ سائن اپ کریں۔",
    th: "หรือลงทะเบียนด้วยอีเมล",
    ky: "Же электрондук почта аркылуу катталыңыз",
    km: "ឬចុះឈ្មោះដោយប្រើអ៊ីមែល",
    id: "Atau daftar dengan email",
    si: "නැතහොත් ඊමේල් සමඟ ලියාපදිංචි වන්න",
    bn: "অথবা ইমেইল দিয়ে সাইন আপ করুন",
    my: "သို့မဟုတ် အီးမေးလ်ဖြင့် အကောင့်ဖွင့်ရန်",
    mn: "Эсвэл имэйлээр бүртгүүлэх",
    lo: "ຫຼື ລົງທະບຽນດ້ວຍອີເມວ",
    tet: "Ka rejistu ho email",
    ne: "वा इमेलबाट दर्ता गर्नुहोस्",
    zh: '或使用邮箱注册',
    vi: 'Hoặc đăng ký bằng email',
    uz: "Yoki elektron pochta orqali roʻyxatdan oʻting",
  );
  static const nameLabel = L10nText(
    ko: '성명',
    en: 'Full name',
    tr: "Tam ad",
    tg: "Номи пурра",
    fil: "Buong pangalan",
    ur: "پورا نام",
    th: "ชื่อ-นามสกุล",
    ky: "Толук аты-жөнү",
    km: "ឈ្មោះពេញ",
    id: "Nama lengkap",
    si: "සම්පූර්ණ නම",
    bn: "পুরো নাম",
    my: "အမည်အပြည့်အစုံ",
    mn: "Бүтэн нэр",
    lo: "ຊື່ເຕັມ",
    tet: "Naran kompletu",
    ne: "पूरा नाम",
    zh: '姓名',
    vi: 'Họ tên',
    uz: "Toʻliq ism",
  );
  static const emailLabel = L10nText(
    ko: '이메일 (아이디)',
    en: 'Email (ID)',
    tr: "E-posta (Kimlik)",
    tg: "Почтаи электронӣ (ID)",
    fil: "Email (ID)",
    ur: "ای میل (شناخت)",
    th: "อีเมล (ID)",
    ky: "Электрондук почта (Идентификатор)",
    km: "អ៊ីមែល (អត្តសញ្ញាណ)",
    id: "Email (ID)",
    si: "ඊමේල් (හැඳුනුම්පත)",
    bn: "ইমেইল (আইডি)",
    my: "အီးမေးလ် (အိုင်ဒီ)",
    mn: "Имэйл (ID)",
    lo: "ອີເມວ (ID)",
    tet: "Email (Identifikasaun)",
    ne: "इमेल (आईडी)",
    zh: '邮箱（账号）',
    vi: 'Email (tài khoản)',
    uz: "Elektron pochta (ID)",
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
  static const passwordConfirmLabel = L10nText(
    ko: '비밀번호 확인',
    en: 'Confirm password',
    tr: "Şifreyi onayla",
    tg: "Тасдиқи парол",
    fil: "Kumpirmahin ang password",
    ur: "پاس ورڈ کی تصدیق کریں",
    th: "ยืนยันรหัสผ่าน",
    ky: "Сырсөздү ырастоо",
    km: "បញ្ជាក់ពាក្យសម្ងាត់",
    id: "Konfirmasi kata sandi",
    si: "මුරපදය තහවුරු කරන්න",
    bn: "পাসওয়ার্ড নিশ্চিত করুন",
    my: "စကားဝှက်ကို အတည်ပြုပါ",
    mn: "Нууц үгийг баталгаажуулах",
    lo: "ຢືນຢັນລະຫັດຜ່ານ",
    tet: "Konfirma password",
    ne: "पासवर्ड पुष्टि गर्नुहोस्",
    zh: '确认密码',
    vi: 'Xác nhận mật khẩu',
    uz: "Parolni tasdiqlash",
  );
  static const nationalityLabel = L10nText(
    ko: '국적',
    en: 'Nationality',
    tr: "Uyruk",
    tg: "Миллат",
    fil: "Nasyonalidad",
    ur: "قومیت",
    th: "สัญชาติ",
    ky: "Улуту",
    km: "សញ្ជាតិ",
    id: "Kebangsaan",
    si: "ජාතිකත්වය",
    bn: "জাতীয়তা",
    my: "နိုင်ငံသား",
    mn: "Иргэншил",
    lo: "ສັນຊາດ",
    tet: "Nasaun",
    ne: "राष्ट्रियता",
    zh: '国籍',
    vi: 'Quốc tịch',
    uz: "Millat",
  );
  static const nationalityPlaceholder = L10nText(
    ko: '국적을 선택해주세요',
    en: 'Select your nationality',
    tr: "Uyruğunuzu seçin",
    tg: "Миллати худро интихоб кунед",
    fil: "Piliin ang iyong nasyonalidad",
    ur: "اپنی قومیت منتخب کریں",
    th: "เลือกสัญชาติของคุณ",
    ky: "Улутуңузду тандаңыз",
    km: "ជ្រើសរើសសញ្ជាតិរបស់អ្នក។",
    id: "Pilih kebangsaan Anda",
    si: "ඔබගේ ජාතිකත්වය තෝරන්න",
    bn: "আপনার জাতীয়তা নির্বাচন করুন",
    my: "သင်၏ နိုင်ငံသားကို ရွေးချယ်ပါ",
    mn: "Иргэншлээ сонгоно уу",
    lo: "ເລືອກສັນຊາດຂອງທ່ານ",
    tet: "Hili Ita-nia nasaun",
    ne: "आफ्नो राष्ट्रियता छान्नुहोस्",
    zh: '请选择国籍',
    vi: 'Chọn quốc tịch của bạn',
    uz: "Millatingizni tanlang",
  );
  static const nextLabel = L10nText(
    ko: '다음',
    en: 'Next',
    tr: "İleri",
    tg: "Баъдӣ",
    fil: "Susunod",
    ur: "اگلا",
    th: "ถัดไป",
    ky: "Кийинки",
    km: "បន្ទាប់",
    id: "Lanjut",
    si: "ඊළඟ",
    bn: "পরবর্তী",
    my: "နောက်တစ်ခု",
    mn: "Дараах",
    lo: "ຕໍ່ໄປ",
    tet: "Tuir mai",
    ne: "अगाडि बढ्नुहोस्",
    zh: '下一步',
    vi: 'Tiếp theo',
    uz: "Keyingi",
  );

  static const errorName = L10nText(
    ko: '성명을 입력해주세요',
    en: 'Please enter your name',
    tr: "Lütfen adınızı girin",
    tg: "Лутфан, номи худро ворид кунед",
    fil: "Pakipasok ang iyong pangalan",
    ur: "براہ کرم اپنا نام درج کریں۔",
    th: "กรุณากรอกชื่อของคุณ",
    ky: "Сураныч, атыңызды киргизиңиз",
    km: "សូមបញ្ចូលឈ្មោះរបស់អ្នក។",
    id: "Mohon masukkan nama Anda",
    si: "කරුණාකර ඔබගේ නම ඇතුළත් කරන්න",
    bn: "অনুগ্রহ করে আপনার নাম লিখুন",
    my: "ကျေးဇူးပြု၍ သင့်အမည်ကို ထည့်သွင်းပါ",
    mn: "Та өөрийн нэрийг оруулна уу",
    lo: "ກະລຸນາໃສ່ຊື່ຂອງທ່ານ",
    tet: "Favor ida, hatama Ita-nia naran",
    ne: "कृपया आफ्नो नाम प्रविष्ट गर्नुहोस्",
    zh: '请输入姓名',
    vi: 'Vui lòng nhập họ tên',
    uz: "Iltimos, ismingizni kiriting",
  );
  static const errorEmail = L10nText(
    ko: '올바른 이메일을 입력해주세요',
    en: 'Please enter a valid email',
    tr: "Lütfen geçerli bir e-posta adresi girin",
    tg: "Лутфан, суроғаи почтаи электронии дурустро ворид кунед",
    fil: "Pakipasok ang isang balidong email address",
    ur: "براہ کرم ایک درست ای میل ایڈریس درج کریں۔",
    th: "กรุณากรอกที่อยู่อีเมลที่ถูกต้อง",
    ky: "Сураныч, жарактуу электрондук почта дарегин киргизиңиз",
    km: "សូមបញ្ចូលអាសយដ្ឋានអ៊ីមែលដែលមានសុពលភាព។",
    id: "Mohon masukkan alamat email yang valid",
    si: "කරුණාකර වලංගු ඊමේල් ලිපිනයක් ඇතුළත් කරන්න",
    bn: "অনুগ্রহ করে একটি বৈধ ইমেইল ঠিকানা লিখুন",
    my: "ကျေးဇူးပြု၍ မှန်ကန်သော အီးမေးလ်လိပ်စာကို ထည့်သွင်းပါ",
    mn: "Хүчинтэй имэйл хаяг оруулна уу",
    lo: "ກະລຸນາໃສ່ທີ່ຢູ່ອີເມວທີ່ຖືກຕ້ອງ",
    tet: "Favor ida, hatama email ida ne'ebé válidu",
    ne: "कृपया मान्य इमेल ठेगाना प्रविष्ट गर्नुहोस्",
    zh: '请输入有效的邮箱地址',
    vi: 'Vui lòng nhập email hợp lệ',
    uz: "Iltimos, toʻgʻri elektron pochta manzilini kiriting",
  );
  static const errorPassword = L10nText(
    ko: '비밀번호는 6자 이상이어야 해요',
    en: 'Password must be at least 6 characters',
    tr: "Şifre en az 6 karakter olmalı",
    tg: "Парол бояд на камтар аз 6 аломат дошта бошад",
    fil: "Ang password ay dapat na hindi bababa sa 6 na karakter",
    ur: "پاس ورڈ کم از کم 6 حروف پر مشتمل ہونا چاہیے۔",
    th: "รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร",
    ky: "Сырсөз кеминде 6 белгиден турушу керек",
    km: "ពាក្យសម្ងាត់ត្រូវមានយ៉ាងតិច 6 តួអក្សរ",
    id: "Kata sandi harus minimal 6 karakter",
    si: "මුරපදය අවම වශයෙන් අක්ෂර 6 ක් විය යුතුය",
    bn: "পাসওয়ার্ড কমপক্ষে 6 অক্ষরের হতে হবে",
    my: "စကားဝှက်သည် အနည်းဆုံး စာလုံးရေ 6 လုံး ရှိရမည်",
    mn: "Нууц үг нь дор хаяж 6 тэмдэгтээс бүрдсэн байх ёстой",
    lo: "ລະຫັດຜ່ານຕ້ອງມີຢ່າງໜ້ອຍ 6 ຕົວອັກສອນ",
    tet: "Password tenke iha karater mínimu 6",
    ne: "पासवर्ड कम्तिमा 6 अक्षरको हुनुपर्छ",
    zh: '密码至少需要6位',
    vi: 'Mật khẩu phải có ít nhất 6 ký tự',
    uz: "Parol kamida 6 ta belgidan iborat boʻlishi kerak",
  );
  static const errorPasswordMismatch = L10nText(
    ko: '비밀번호가 일치하지 않아요',
    en: 'Passwords do not match',
    tr: "Şifreler eşleşmiyor",
    tg: "Паролҳо мувофиқат намекунанд",
    fil: "Hindi magkatugma ang mga password",
    ur: "پاس ورڈز مماثل نہیں ہیں۔",
    th: "รหัสผ่านไม่ตรงกัน",
    ky: "Сырсөздөр дал келбейт",
    km: "ពាក្យសម្ងាត់មិនត្រូវគ្នាទេ។",
    id: "Kata sandi tidak cocok",
    si: "මුරපද නොගැලපේ",
    bn: "পাসওয়ার্ড মিলছে না",
    my: "စကားဝှက်များ မတူညီပါ",
    mn: "Нууц үг таарахгүй байна",
    lo: "ລະຫັດຜ່ານບໍ່ກົງກັນ",
    tet: "Password sira la hanesan",
    ne: "पासवर्डहरू मेल खाँदैनन्",
    zh: '两次输入的密码不一致',
    vi: 'Mật khẩu không khớp',
    uz: "Parollar mos kelmadi",
  );
  static const errorCustomVisa = L10nText(
    ko: '체류자격을 입력해주세요',
    en: 'Please enter your visa status',
    tr: "Lütfen vize durumunuzu girin",
    tg: "Лутфан, ҳолати раводиди худро ворид кунед",
    fil: "Pakipasok ang iyong visa status",
    ur: "براہ کرم اپنی ویزا کی حیثیت درج کریں۔",
    th: "กรุณากรอกสถานะวีซ่าของคุณ",
    ky: "Сураныч, виза статусуңузду киргизиңиз",
    km: "សូមបញ្ចូលស្ថានភាពទិដ្ឋាការរបស់អ្នក។",
    id: "Mohon masukkan status visa Anda",
    si: "කරුණාකර ඔබගේ වීසා තත්ත්වය ඇතුළත් කරන්න",
    bn: "অনুগ্রহ করে আপনার ভিসার অবস্থা লিখুন",
    my: "ကျေးဇူးပြု၍ သင်၏ ဗီဇာအခြေအနေကို ထည့်သွင်းပါ",
    mn: "Та визийн статусаа оруулна уу",
    lo: "ກະລຸນາໃສ່ສະຖານະວີຊາຂອງທ່ານ",
    tet: "Favor ida, hatama Ita-nia estatutu viza",
    ne: "कृपया आफ्नो भिसा स्थिति प्रविष्ट गर्नुहोस्",
    zh: '请输入居留资格',
    vi: 'Vui lòng nhập tư cách lưu trú',
    uz: "Iltimos, viza holatingizni kiriting",
  );
  static const errorCountry = L10nText(
    ko: '국적을 선택해주세요',
    en: 'Please select your nationality',
    tr: "Lütfen uyruğunuzu seçin",
    tg: "Лутфан, миллати худро интихоб кунед",
    fil: "Pakipili ang iyong nasyonalidad",
    ur: "براہ کرم اپنی قومیت منتخب کریں۔",
    th: "กรุณาเลือกสัญชาติของคุณ",
    ky: "Сураныч, улутуңузду тандаңыз",
    km: "សូមជ្រើសរើសសញ្ជាតិរបស់អ្នក។",
    id: "Mohon pilih kebangsaan Anda",
    si: "කරුණාකර ඔබගේ ජාතිකත්වය තෝරන්න",
    bn: "অনুগ্রহ করে আপনার জাতীয়তা নির্বাচন করুন",
    my: "ကျေးဇူးပြု၍ သင်၏ နိုင်ငံသားကို ရွေးချယ်ပါ",
    mn: "Та иргэншлээ сонгоно уу",
    lo: "ກະລຸນາເລືອກສັນຊາດຂອງທ່ານ",
    tet: "Favor ida, hili Ita-nia nasaun",
    ne: "कृपया आफ्नो राष्ट्रियता छान्नुहोस्",
    zh: '请选择国籍',
    vi: 'Vui lòng chọn quốc tịch',
    uz: "Iltimos, millatingizni tanlang",
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

class SignupFormScreen extends StatefulWidget {
  const SignupFormScreen({
    super.key,
    this.isGoogleFlow = false,
    this.initialName,
    this.initialEmail,
    this.onGoogleSignupComplete,
  });

  /// true면 이미 Google로 인증된 상태에서 진입한 것 — 이메일/비밀번호 필드를
  /// 숨기고 성명·이메일을 미리 채운다(AppEntryFlow가 리다이렉트 복귀 후
  /// 새 사용자를 여기로 바로 보낼 때 씀).
  final bool isGoogleFlow;
  final String? initialName;
  final String? initialEmail;

  /// isGoogleFlow일 때만 쓰인다 — 이 화면이 Navigator.push로 들어온 게 아니라
  /// AppEntryFlow가 오버레이로 직접 띄운 것이라 pop 대신 콜백으로 완료를 알린다.
  final VoidCallback? onGoogleSignupComplete;

  @override
  State<SignupFormScreen> createState() => _SignupFormScreenState();
}

class _SignupFormScreenState extends State<SignupFormScreen> {
  final _authService = AuthService();
  late final _nameController = TextEditingController(
    text: widget.initialName ?? '',
  );
  late final _emailController = TextEditingController(
    text: widget.initialEmail ?? '',
  );
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _customVisaController = TextEditingController();

  VisaStatus _visa = VisaStatus.e9;
  Country? _country;
  late bool _isGoogleFlow = widget.isGoogleFlow;
  bool _googleLoading = false;

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _passwordConfirmError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _customVisaController.dispose();
    super.dispose();
  }

  /// 웹에서는 signInWithRedirect라 페이지가 곧 이동한다 — 여기서 결과를
  /// 기다리지 않는다(돌아온 뒤엔 AppEntryFlow가 이어서 처리한다).
  Future<void> _continueWithGoogle(AppLanguage lang) async {
    setState(() => _googleLoading = true);
    try {
      final credential = await _authService.signInWithGoogle();
      if (credential == null) return; // 웹: 리다이렉트로 페이지 이동. 모바일: 사용자가 취소함.
      final user = credential.user;
      setState(() {
        _isGoogleFlow = true;
        _nameController.text = user?.displayName ?? _nameController.text;
        _emailController.text = user?.email ?? _emailController.text;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_S.googleFailed.of(lang))));
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  bool _validate(AppLanguage lang) {
    setState(() {
      _nameError = _nameController.text.trim().isEmpty
          ? _S.errorName.of(lang)
          : null;
      _emailError = _emailController.text.trim().contains('@')
          ? null
          : _S.errorEmail.of(lang);
      if (!_isGoogleFlow) {
        _passwordError = _passwordController.text.length < 6
            ? _S.errorPassword.of(lang)
            : null;
        _passwordConfirmError =
            _passwordController.text != _passwordConfirmController.text
            ? _S.errorPasswordMismatch.of(lang)
            : null;
      } else {
        _passwordError = null;
        _passwordConfirmError = null;
      }
    });
    if (_nameError != null ||
        _emailError != null ||
        _passwordError != null ||
        _passwordConfirmError != null) {
      return false;
    }
    if (_visa == VisaStatus.etc && _customVisaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_S.errorCustomVisa.of(lang))));
      return false;
    }
    if (_country == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_S.errorCountry.of(lang))));
      return false;
    }
    return true;
  }

  void _next(AppLanguage lang) {
    if (!_validate(lang)) return;
    final draft = SignupDraft(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _isGoogleFlow ? null : _passwordController.text,
      isGoogleFlow: _isGoogleFlow,
      visa: _visa,
      customVisaText: _visa == VisaStatus.etc
          ? _customVisaController.text.trim()
          : null,
      countryCode: _country!.code,
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ConsentScreen(
          draft: draft,
          onComplete: widget.onGoogleSignupComplete,
        ),
      ),
    );
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
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            if (_isGoogleFlow)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.blueBg,
                  border: Border.all(color: AppColors.blueBorder),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _S.googleDoneLabel.of(lang),
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              GoogleSignInButton(
                label: _S.googleLabel,
                language: lang,
                onPressed: _googleLoading
                    ? () {}
                    : () => _continueWithGoogle(lang),
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
            ],
            AuthTextField(
              label: _S.nameLabel.of(lang),
              controller: _nameController,
              errorText: _nameError,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              label: _S.emailLabel.of(lang),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              errorText: _emailError,
            ),
            if (!_isGoogleFlow) ...[
              const SizedBox(height: 12),
              AuthTextField(
                label: _S.passwordLabel.of(lang),
                controller: _passwordController,
                obscureText: true,
                errorText: _passwordError,
              ),
              const SizedBox(height: 12),
              AuthTextField(
                label: _S.passwordConfirmLabel.of(lang),
                controller: _passwordConfirmController,
                obscureText: true,
                errorText: _passwordConfirmError,
              ),
            ],
            const SizedBox(height: 18),
            VisaPicker(
              language: lang,
              value: _visa,
              onChanged: (v) => setState(() => _visa = v),
              customTextController: _customVisaController,
            ),
            const SizedBox(height: 18),
            Text(
              _S.nationalityLabel.of(lang),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => showCountrySheet(
                context,
                language: lang,
                current: _country?.code,
                onSelect: (c) => setState(() => _country = c),
              ),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBFDFF),
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _country?.name.of(lang) ??
                            _S.nationalityPlaceholder.of(lang),
                        style: TextStyle(
                          fontSize: 13.5,
                          color: _country == null
                              ? AppColors.textMuted
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const Icon(Icons.expand_more, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _next(lang),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                child: Text(
                  _S.nextLabel.of(lang),
                  style: const TextStyle(
                    fontSize: 13.5,
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
