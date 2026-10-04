import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';
import '../models/signup_draft.dart';
import '../services/auth_service.dart';
import '../services/user_profile_api_service.dart';

class _S {
  _S._();

  static const title = L10nText(
    ko: '개인정보 처리방침 동의',
    en: 'Privacy Policy Agreement',
    tr: "Gizlilik Politikası Sözleşmesi",
    tg: "Созишномаи сиёсати махфият",
    fil: "Kasunduan sa Patakaran sa Privacy",
    ur: "رازداری کی پالیسی کا معاہدہ",
    th: "ข้อตกลงนโยบายความเป็นส่วนตัว",
    ky: "Купуялык саясаты келишими",
    km: "កិច្ចព្រមព្រៀងគោលការណ៍ឯកជនភាព",
    id: "Perjanjian Kebijakan Privasi",
    si: "පෞද්ගලිකත්ව ප්‍රතිපත්ති ගිවිසුම",
    bn: "গোপনীয়তা নীতি চুক্তি",
    my: "ကိုယ်ရေးကိုယ်တာမူဝါဒ သဘောတူညီချက်",
    mn: "Нууцлалын бодлогын гэрээ",
    lo: "ສັນຍານະໂຍບາຍຄວາມເປັນສ່ວນຕົວ",
    tet: "Akordu Polítika Privacidade",
    ne: "गोपनीयता नीति सम्झौता",
    zh: '同意隐私政策',
    vi: 'Đồng ý chính sách bảo mật',
    uz: "Maxfiylik siyosati kelishuvi",
  );
  static const heading = L10nText(
    ko: 'Local Bridge가 수집하는 정보',
    en: 'Information Local Bridge collects',
    tr: "Local Bridge'in topladığı bilgiler",
    tg: "Маълумоти ҷамъовардаи Local Bridge",
    fil: "Impormasyong kinokolekta ng Local Bridge",
    ur: "Local Bridge کی جمع کردہ معلومات",
    th: "ข้อมูลที่ Local Bridge รวบรวม",
    ky: "Local Bridge чогулткан маалыматтар",
    km: "ព័ត៌មានដែល Local Bridge ប្រមូល",
    id: "Informasi yang dikumpulkan oleh Local Bridge",
    si: "Local Bridge විසින් රැස් කරන තොරතුරු",
    bn: "Local Bridge দ্বারা সংগৃহীত তথ্য",
    my: "Local Bridge မှ စုဆောင်းထားသော အချက်အလက်များ",
    mn: "Local Bridge-ийн цуглуулдаг мэдээлэл",
    lo: "ຂໍ້ມູນທີ່ Local Bridge ເກັບກຳ",
    tet: "Informasaun ne'ebé Local Bridge halibur",
    ne: "लोकल ब्रिजले सङ्कलन गर्ने जानकारी",
    zh: 'Local Bridge收集的信息',
    vi: 'Thông tin Local Bridge thu thập',
    uz: "Local Bridge toʻplaydigan maʼlumotlar",
  );
  // 수집 항목·보관 기간 안내. docs/firestore_스키마.md의 users 컬렉션 필드와
  // 일치시켰다 — 실제로 저장하지 않는 항목(비밀번호 등)을 여기 적으면 안 된다.
  static const body = L10nText(
    ko:
        '회원가입 시 성명, 이메일, 체류자격, 국적, 선호 언어를 수집합니다. '
        '비밀번호는 Firebase Authentication이 암호화해 별도로 안전하게 보관하며, '
        'Local Bridge 서버에는 저장되지 않습니다.\n\n'
        '수집한 정보는 맞춤형 노동 상담·서식 자동 작성 등 서비스 제공 목적으로만 사용하며, '
        '회원 탈퇴 또는 삭제 요청 시까지 보관한 뒤 지체 없이 파기합니다. '
        '동의를 거부할 수 있으나, 이 경우 회원가입이 제한됩니다.',
    en:
        'When you sign up, we collect your name, email, visa status, nationality, and preferred language. '
        'Your password is encrypted and securely stored by Firebase Authentication only — it is never stored on Local Bridge servers.\n\n'
        'Collected information is used only to provide the service (personalized labor guidance, auto-filled forms, etc.) and is retained '
        'until you withdraw your account or request deletion, after which it is destroyed without delay. You may decline consent, but '
        'signing up will not be possible without it.',
    tr: "Kaydolduğunuzda adınız, e-posta adresiniz, vize durumunuz, uyruğunuz ve tercih ettiğiniz dil toplanır. Şifreniz yalnızca Firebase Authentication tarafından şifrelenir ve güvenli bir şekilde saklanır; Local Bridge sunucularında asla saklanmaz.\n\nToplanan bilgiler yalnızca hizmeti sağlamak (kişiselleştirilmiş iş rehberliği, otomatik doldurulmuş formlar vb.) için kullanılır ve hesabınızı iptal edene veya silme talebinde bulunana kadar saklanır, sonrasında gecikmeksizin imha edilir. Onay vermeyi reddedebilirsiniz, ancak onaysız kayıt olmak mümkün olmayacaktır.",
    tg: "Ҳангоми сабти ном, ном, суроғаи почтаи электронӣ, ҳолати раводид, миллат ва забони афзалиятноки шумо ҷамъоварӣ карда мешаванд. Пароли шумо танҳо аз ҷониби Firebase Authentication рамзгузорӣ ва бехатар нигоҳ дошта мешавад; он ҳеҷ гоҳ дар серверҳои Local Bridge нигоҳ дошта намешавад.\n\nМаълумоти ҷамъовардашуда танҳо барои пешниҳоди хидмат (дастури фардии корӣ, шаклҳои худкор пуршуда ва ғайра) истифода мешавад ва то лағви ҳисоби шумо ё дархости несткунӣ нигоҳ дошта мешавад, ки пас аз он фавран нест карда мешавад. Шумо метавонед аз додани розигӣ даст кашед, аммо сабти ном бидуни розигӣ имконнопазир хоҳад буд.",
    fil:
        "Kapag nagparehistro ka, kinokolekta ang iyong pangalan, email address, status ng visa, nasyonalidad, at gustong wika. Ang iyong password ay naka-encrypt lamang ng Firebase Authentication at ligtas na nakaimbak; hindi ito kailanman iniimbak sa mga server ng Local Bridge.\n\nAng kinokolektang impormasyon ay ginagamit lamang upang maibigay ang serbisyo (tulad ng personalized na gabay sa trabaho, auto-filled na mga form, atbp.) at iniimbak hanggang sa kanselahin mo ang iyong account o humiling ng pagtanggal, pagkatapos nito ay agad itong sisirain. Maaari mong tanggihan ang pagbibigay ng pahintulot, ngunit hindi magiging posible ang pagpaparehistro nang walang pahintulot.",
    ur: "جب آپ رجسٹر کرتے ہیں تو آپ کا نام، ای میل ایڈریس، ویزا کی حیثیت، قومیت اور ترجیحی زبان جمع کی جاتی ہے۔ آپ کا پاس ورڈ صرف Firebase Authentication کے ذریعے انکرپٹ کیا جاتا ہے اور محفوظ طریقے سے ذخیرہ کیا جاتا ہے؛ اسے کبھی بھی Local Bridge سرورز پر ذخیرہ نہیں کیا جاتا ہے۔\n\nجمع کردہ معلومات صرف سروس فراہم کرنے (ذاتی نوعیت کی ملازمت کی رہنمائی، خودکار طور پر بھرے جانے والے فارمز وغیرہ) کے لیے استعمال کی جاتی ہیں اور آپ کے اکاؤنٹ کو منسوخ کرنے یا حذف کرنے کی درخواست کرنے تک ذخیرہ کی جاتی ہیں، جس کے بعد اسے بغیر کسی تاخیر کے تلف کر دیا جاتا ہے۔ آپ رضامندی دینے سے انکار کر سکتے ہیں، لیکن رضامندی کے بغیر رجسٹر کرنا ممکن نہیں ہوگا۔",
    th: "เมื่อคุณลงทะเบียน ชื่อ ที่อยู่อีเมล สถานะวีซ่า สัญชาติ และภาษาที่คุณต้องการจะถูกรวบรวม รหัสผ่านของคุณจะถูกเข้ารหัสโดย Firebase Authentication เท่านั้นและจัดเก็บไว้อย่างปลอดภัย โดยจะไม่ถูกจัดเก็บไว้ในเซิร์ฟเวอร์ของ Local Bridge\n\nข้อมูลที่รวบรวมจะใช้เพื่อให้บริการเท่านั้น (เช่น คำแนะนำการทำงานส่วนบุคคล แบบฟอร์มที่กรอกอัตโนมัติ ฯลฯ) และจะถูกเก็บไว้จนกว่าคุณจะยกเลิกบัญชีหรือร้องขอให้ลบ หลังจากนั้นจะถูกทำลายโดยไม่ชักช้า คุณสามารถปฏิเสธที่จะให้ความยินยอมได้ แต่จะไม่สามารถลงทะเบียนได้หากไม่ให้ความยินยอม",
    ky: "Катталганыңызда атыңыз, электрондук почта дарегиңиз, виза статусуңуз, жарандыгыңыз жана артыкчылык берген тилиңиз чогултулат. Сырсөзүңүз Firebase Authentication тарабынан шифрленип, коопсуз сакталат; ал эч качан Local Bridge серверлеринде сакталбайт.\n\nЧогултулган маалыматтар кызматты көрсөтүү үчүн гана колдонулат (жекелештирилген жумуш боюнча көрсөтмөлөр, автоматтык түрдө толтурулган формалар ж.б.) жана сиз аккаунтуңузду жокко чыгаргыча же өчүрүү өтүнүчүн бергиче сакталат, андан кийин кечиктирилбестен жок кылынат. Сиз макулдук берүүдөн баш тарта аласыз, бирок макулдуксуз каттоо мүмкүн болбойт.",
    km: "នៅពេលអ្នកចុះឈ្មោះ ឈ្មោះ អាសយដ្ឋានអ៊ីមែល ស្ថានភាពទិដ្ឋាការ សញ្ជាតិ និងភាសាដែលអ្នកពេញចិត្តនឹងត្រូវបានប្រមូល។ ពាក្យសម្ងាត់របស់អ្នកត្រូវបានអ៊ិនគ្រីបដោយ Firebase Authentication ហើយរក្សាទុកដោយសុវត្ថិភាព។ វាមិនត្រូវបានរក្សាទុកនៅលើម៉ាស៊ីនមេរបស់ Local Bridge ឡើយ។\n\nព័ត៌មានដែលបានប្រមូលត្រូវបានប្រើប្រាស់សម្រាប់តែការផ្តល់សេវាកម្ម (ការណែនាំការងារផ្ទាល់ខ្លួន ទម្រង់បំពេញដោយស្វ័យប្រវត្តិ។ល។) ហើយត្រូវបានរក្សាទុក រហូតដល់អ្នកលុបគណនីរបស់អ្នក ឬស្នើសុំលុប បន្ទាប់មកវានឹងត្រូវបានបំផ្លាញដោយគ្មានការពន្យារពេល។ អ្នកអាចបដិសេធមិនផ្តល់ការយល់ព្រម ប៉ុន្តែការចុះឈ្មោះដោយគ្មានការយល់ព្រមនឹងមិនអាចធ្វើទៅបានទេ។",
    id: "Saat Anda mendaftar, nama, alamat email, status visa, kewarganegaraan, dan bahasa pilihan Anda akan dikumpulkan. Kata sandi Anda hanya dienkripsi oleh Firebase Authentication dan disimpan dengan aman; tidak pernah disimpan di server Local Bridge.\n\nInformasi yang dikumpulkan hanya digunakan untuk menyediakan layanan (panduan pekerjaan yang dipersonalisasi, formulir yang diisi otomatis, dll.) dan disimpan sampai Anda membatalkan akun Anda atau meminta penghapusan, setelah itu akan dimusnahkan tanpa penundaan. Anda dapat menolak untuk memberikan persetujuan, tetapi pendaftaran tanpa persetujuan tidak akan mungkin dilakukan.",
    si: "ඔබ ලියාපදිංචි වන විට, ඔබගේ නම, ඊමේල් ලිපිනය, වීසා තත්ත්වය, ජාතිකත්වය සහ කැමති භාෂාව රැස් කරනු ලැබේ. ඔබගේ මුරපදය Firebase Authentication මගින් පමණක් සංකේතනය කර ආරක්ෂිතව ගබඩා කර ඇති අතර, Local Bridge සේවාදායකයන් තුළ කිසිවිටෙක ගබඩා නොවේ.\n\nරැස් කරන ලද තොරතුරු සේවාව සැපයීම සඳහා පමණක් (පුද්ගලීකරණය කළ රැකියා මාර්ගෝපදේශය, ස්වයංක්‍රීයව පුරවන ලද පෝරම ආදිය) භාවිතා කරන අතර, ඔබ ඔබගේ ගිණුම අවලංගු කරන තෙක් හෝ මකා දැමීමට ඉල්ලීමක් කරන තෙක් ගබඩා කරනු ලැබේ, ඉන්පසු එය ප්‍රමාදයකින් තොරව විනාශ කරනු ලැබේ. ඔබට එකඟ වීම ප්‍රතික්ෂේප කළ හැක, නමුත් එකඟ නොවී ලියාපදිංචි වීමට නොහැකි වනු ඇත.",
    bn: "আপনি যখন সাইন আপ করেন, তখন আপনার নাম, ইমেল ঠিকানা, ভিসার অবস্থা, জাতীয়তা এবং পছন্দের ভাষা সংগ্রহ করা হয়। আপনার পাসওয়ার্ড শুধুমাত্র ফায়ারবেস অথেনটিকেশন দ্বারা এনক্রিপ্ট করা হয় এবং নিরাপদে সংরক্ষণ করা হয়; এটি কখনই Local Bridge সার্ভারে সংরক্ষণ করা হয় না।\n\nসংগৃহীত তথ্য শুধুমাত্র পরিষেবা প্রদানের জন্য (ব্যক্তিগতকৃত কাজের নির্দেশনা, স্বয়ংক্রিয়ভাবে পূরণ করা ফর্ম ইত্যাদি) ব্যবহার করা হয় এবং আপনার অ্যাকাউন্ট বাতিল না করা পর্যন্ত বা আপনি মুছে ফেলার অনুরোধ না করা পর্যন্ত সংরক্ষণ করা হয়, যার পরে এটি অবিলম্বে ধ্বংস করা হয়। আপনি সম্মতি দিতে অস্বীকার করতে পারেন, তবে সম্মতি ছাড়া নিবন্ধন করা সম্ভব হবে না।",
    my: "သင်အကောင့်ဖွင့်သည့်အခါ သင့်အမည်၊ အီးမေးလ်လိပ်စာ၊ ဗီဇာအခြေအနေ၊ နိုင်ငံသားဖြစ်မှုနှင့် နှစ်သက်ရာဘာသာစကားတို့ကို စုဆောင်းပါသည်။ သင့်စကားဝှက်ကို Firebase Authentication မှသာ ကုဒ်ဝှက်ထားပြီး လုံခြုံစွာသိမ်းဆည်းထားပြီး Local Bridge ဆာဗာများတွင် မည်သည့်အခါမျှ သိမ်းဆည်းထားခြင်းမရှိပါ။\n\nစုဆောင်းထားသော အချက်အလက်များကို ဝန်ဆောင်မှုပေးရန် (ကိုယ်ပိုင်အလုပ်လမ်းညွှန်မှု၊ အလိုအလျောက်ဖြည့်သွင်းထားသော ဖောင်များ စသည်ဖြင့်) အတွက်သာ အသုံးပြုပြီး သင့်အကောင့်ကို ပယ်ဖျက်ခြင်း သို့မဟုတ် ဖျက်သိမ်းရန် တောင်းဆိုခြင်းမပြုမချင်း သိမ်းဆည်းထားမည်ဖြစ်ပြီး ထို့နောက် နှောင့်နှေးခြင်းမရှိဘဲ ဖျက်ဆီးပစ်မည်ဖြစ်သည်။ သင်သည် သဘောတူညီရန် ငြင်းဆိုနိုင်သော်လည်း သဘောတူညီချက်မပါဘဲ အကောင့်ဖွင့်နိုင်မည်မဟုတ်ပါ။",
    mn: "Та бүртгүүлэх үед таны нэр, и-мэйл хаяг, визийн статус, иргэншил, болон таны сонгосон хэл цуглуулагдана. Таны нууц үгийг зөвхөн Firebase Authentication-ээр шифрлэж, аюулгүй хадгална; Local Bridge-ийн серверүүдэд хэзээ ч хадгалахгүй.\n\nЦуглуулсан мэдээллийг зөвхөн үйлчилгээ үзүүлэх (хувийн тохиргоотой ажлын удирдамж, автоматаар бөглөгдсөн маягт гэх мэт) зорилгоор ашиглах бөгөөд таны бүртгэлийг цуцлах эсвэл устгах хүсэлт гаргах хүртэл хадгална, үүний дараа нэн даруй устгана. Та зөвшөөрөхөөс татгалзаж болно, гэхдээ зөвшөөрөлгүйгээр бүртгүүлэх боломжгүй.",
    lo: "ເມື່ອທ່ານລົງທະບຽນ, ຊື່, ທີ່ຢູ່ອີເມວ, ສະຖານະວີຊາ, ສັນຊາດ ແລະ ພາສາທີ່ທ່ານຕ້ອງການຈະຖືກເກັບກຳ. ລະຫັດຜ່ານຂອງທ່ານຈະຖືກເຂົ້າລະຫັດໂດຍ Firebase Authentication ເທົ່ານັ້ນ ແລະ ເກັບຮັກສາໄວ້ຢ່າງປອດໄພ; ມັນຈະບໍ່ຖືກເກັບຮັກສາໄວ້ໃນເຊີບເວີຂອງ Local Bridge.\n\nຂໍ້ມູນທີ່ເກັບກຳຈະຖືກນຳໃຊ້ເພື່ອໃຫ້ບໍລິການເທົ່ານັ້ນ (ເຊັ່ນ: ການແນະນຳວຽກທີ່ເໝາະສົມ, ແບບຟອມທີ່ຕື່ມອັດຕະໂນມັດ, ແລະອື່ນໆ) ແລະຈະຖືກເກັບຮັກສາໄວ້ຈົນກວ່າທ່ານຈະຍົກເລີກບັນຊີຂອງທ່ານ ຫຼືຮ້ອງຂໍໃຫ້ລຶບ, ຫຼັງຈາກນັ້ນມັນຈະຖືກທຳລາຍໂດຍບໍ່ມີການຊັກຊ້າ. ທ່ານສາມາດປະຕິເສດທີ່ຈະໃຫ້ຄວາມຍິນຍອມໄດ້, ແຕ່ການລົງທະບຽນໂດຍບໍ່ມີການຍິນຍອມຈະບໍ່ສາມາດເຮັດໄດ້.",
    tet:
        "Kuandu Ita rejista, Ita-nia naran, email, estatutu viza, nasionalidade no lian ne'ebé Ita prefere sei halibur. Ita-nia password sei enkrípta de'it husi Firebase Authentication no rai seguru; la rai iha servidor Local Bridge nian.\n\nInformasaun ne'ebé halibur uza de'it atu fornese servisu (hanesan orientasaun serbisu personalizadu, formuláriu preenxe-an automátiku, no seluk tan) no sei rai to'o Ita kansela Ita-nia konta ka husu atu hamoos, depois sei hamoos kedas. Ita bele la konkorda, maibé la bele rejista se la konkorda.",
    ne: "तपाईंले दर्ता गर्दा, तपाईंको नाम, इमेल ठेगाना, भिसा स्थिति, राष्ट्रियता र मनपर्ने भाषा सङ्कलन गरिन्छ। तपाईंको पासवर्ड Firebase प्रमाणीकरणद्वारा मात्र इन्क्रिप्ट गरिन्छ र सुरक्षित रूपमा भण्डारण गरिन्छ; यो लोकल ब्रिज सर्भरहरूमा कहिल्यै भण्डारण गरिँदैन।\n\nसङ्कलन गरिएको जानकारी सेवा प्रदान गर्न (व्यक्तिगत रोजगार मार्गदर्शन, स्वतः भरिएका फारमहरू, आदि) मात्र प्रयोग गरिन्छ र तपाईंले आफ्नो खाता रद्द नगरेसम्म वा मेटाउन अनुरोध नगरेसम्म भण्डारण गरिन्छ, त्यसपछि यसलाई ढिलाइ नगरी नष्ट गरिन्छ। तपाईंले सहमति दिन अस्वीकार गर्न सक्नुहुन्छ, तर सहमति बिना दर्ता गर्न सम्भव हुनेछैन।",
    zh:
        '注册时我们会收集您的姓名、邮箱、居留资格、国籍和首选语言。'
        '密码由Firebase Authentication加密安全保管，不会存储在Local Bridge服务器上。\n\n'
        '所收集的信息仅用于提供服务（个性化劳动咨询、自动填写表格等），'
        '将保留至您注销账号或申请删除为止，之后将被立即销毁。您可以拒绝同意，但拒绝将导致无法完成注册。',
    vi:
        'Khi đăng ký, chúng tôi thu thập họ tên, email, tư cách lưu trú, quốc tịch và ngôn ngữ ưa thích của bạn. '
        'Mật khẩu được Firebase Authentication mã hóa và lưu trữ an toàn riêng — không bao giờ được lưu trên máy chủ Local Bridge.\n\n'
        'Thông tin thu thập được chỉ dùng để cung cấp dịch vụ (tư vấn lao động cá nhân hóa, tự động điền biểu mẫu, v.v.) và được lưu giữ '
        'cho đến khi bạn hủy tài khoản hoặc yêu cầu xóa, sau đó sẽ bị hủy ngay lập tức. Bạn có thể từ chối đồng ý, nhưng khi đó sẽ không thể đăng ký.',
    uz: "Roʻyxatdan oʻtganingizda, biz ismingizni, elektron pochtangizni, viza holatingizni, millatingizni va afzal koʻrgan tilingizni yigʻamiz. Parolingiz faqat Firebase Authentication tomonidan shifrlanadi va xavfsiz saqlanadi — u hech qachon Local Bridge serverlarida saqlanmaydi.\n\nYigʻilgan maʼlumotlar faqat xizmat koʻrsatish (shaxsiylashtirilgan mehnat boʻyicha yoʻl-yoʻriq, avtomatik toʻldirilgan shakllar va h.k.) uchun ishlatiladi va siz hisobingizni bekor qilmaguningizcha yoki oʻchirishni soʻramaguningizcha saqlanadi, shundan soʻng u kechiktirmasdan yoʻq qilinadi. Siz rozilikni rad etishingiz mumkin, ammo usiz roʻyxatdan oʻtish mumkin boʻlmaydi.",
  );
  static const agreeLabel = L10nText(
    ko: '위 내용을 확인했으며 개인정보 수집·이용에 동의합니다 (필수)',
    en: 'I have read the above and agree to the collection and use of my personal information (required)',
    tr: "Yukarıdakileri okudum ve kişisel bilgilerimin toplanmasına ve kullanılmasına onay veriyorum (gerekli)",
    tg: "Ман матни болоро хондам ва ба ҷамъоварӣ ва истифодаи маълумоти шахсии худ розӣ ҳастам (ҳатмӣ)",
    fil:
        "Nabasa ko ang nasa itaas at sumasang-ayon ako sa pagkolekta at paggamit ng aking personal na impormasyon (kinakailangan)",
    ur: "میں نے مندرجہ بالا پڑھ لیا ہے اور اپنی ذاتی معلومات کے جمع کرنے اور استعمال کرنے پر رضامندی دیتا ہوں (ضروری)",
    th: "ฉันได้อ่านและยินยอมให้มีการรวบรวมและใช้ข้อมูลส่วนบุคคลของฉัน (จำเป็น)",
    ky: "Мен жогоруда айтылгандарды окуп чыктым жана жеке маалыматтарымды чогултууга жана колдонууга макулдук берем (милдеттүү)",
    km: "ខ្ញុំបានអានខាងលើ ហើយយល់ព្រមចំពោះការប្រមូល និងការប្រើប្រាស់ព័ត៌មានផ្ទាល់ខ្លួនរបស់ខ្ញុំ (ចាំបាច់)",
    id: "Saya telah membaca dan menyetujui pengumpulan dan penggunaan informasi pribadi saya di atas (wajib)",
    si: "මම ඉහත සඳහන් දෑ කියවා ඇති අතර මගේ පුද්ගලික තොරතුරු රැස් කිරීමට සහ භාවිතා කිරීමට එකඟ වෙමි (අවශ්‍යයි)",
    bn: "আমি উপরেরটি পড়েছি এবং আমার ব্যক্তিগত তথ্য সংগ্রহ ও ব্যবহারে সম্মতি দিচ্ছি (প্রয়োজনীয়)",
    my: "အထက်ဖော်ပြပါအချက်များကို ဖတ်ပြီးဖြစ်ပြီး ကျွန်ုပ်၏ကိုယ်ရေးကိုယ်တာအချက်အလက်များကို စုဆောင်းအသုံးပြုခြင်းကို သဘောတူပါသည် (လိုအပ်သည်)",
    mn: "Би дээрхийг уншиж, хувийн мэдээллээ цуглуулах, ашиглахыг зөвшөөрч байна (шаардлагатай)",
    lo: "ຂ້າພະເຈົ້າໄດ້ອ່ານຂໍ້ຄວາມຂ້າງເທິງນີ້ ແລະ ຍິນຍອມໃຫ້ເກັບກຳ ແລະ ນຳໃຊ້ຂໍ້ມູນສ່ວນຕົວຂອງຂ້າພະເຈົ້າ (ຈຳເປັນ)",
    tet:
        "Ha'u lee ona no konkorda ho halibur no uza ha'u-nia informasaun pesoál (presiza)",
    ne: "मैले माथिका कुराहरू पढेको छु र मेरो व्यक्तिगत जानकारी सङ्कलन र प्रयोग गर्न म सहमत छु (आवश्यक)।",
    zh: '我已阅读以上内容并同意收集和使用我的个人信息（必填）',
    vi: 'Tôi đã đọc nội dung trên và đồng ý việc thu thập, sử dụng thông tin cá nhân (bắt buộc)',
    uz: "Yuqoridagilarni oʻqidim va shaxsiy maʼlumotlarimni yigʻish va ulardan foydalanishga rozilik beraman (majburiy)",
  );
  static const submitLabel = L10nText(
    ko: '가입 완료',
    en: 'Complete sign-up',
    tr: "Kaydolmayı tamamla",
    tg: "Бақайдгириро анҷом диҳед",
    fil: "Kumpletuhin ang Pagpaparehistro",
    ur: "رجسٹریشن مکمل کریں",
    th: "ลงทะเบียนให้เสร็จสมบูรณ์",
    ky: "Катталууну аяктоо",
    km: "បញ្ចប់ការចុះឈ្មោះ",
    id: "Selesaikan pendaftaran",
    si: "ලියාපදිංචිය සම්පූර්ණ කරන්න",
    bn: "সাইন আপ সম্পূর্ণ করুন",
    my: "အကောင့်ဖွင့်ခြင်း ပြီးဆုံးပါပြီ",
    mn: "Бүртгэлийг дуусгах",
    lo: "ສຳເລັດການລົງທະບຽນ",
    tet: "Remata Rejistu",
    ne: "दर्ता पूरा गर्नुहोस्",
    zh: '完成注册',
    vi: 'Hoàn tất đăng ký',
    uz: "Roʻyxatdan oʻtishni yakunlash",
  );
  static const errorConsentRequired = L10nText(
    ko: '동의해야 가입을 완료할 수 있어요',
    en: 'You must agree to continue',
    tr: "Devam etmek için kabul etmelisiniz",
    tg: "Барои идома додан шумо бояд розӣ шавед",
    fil: "Kailangan mong sumang-ayon upang magpatuloy",
    ur: "جاری رکھنے کے لیے آپ کو قبول کرنا ہوگا",
    th: "คุณต้องยอมรับเพื่อดำเนินการต่อ",
    ky: "Улантуу үчүн макул болушуңуз керек",
    km: "អ្នកត្រូវតែយល់ព្រមដើម្បីបន្ត",
    id: "Anda harus menyetujui untuk melanjutkan",
    si: "ඉදිරියට යාමට ඔබ එකඟ විය යුතුය",
    bn: "চালিয়ে যেতে আপনাকে অবশ্যই সম্মত হতে হবে",
    my: "ဆက်လက်လုပ်ဆောင်ရန် သင်သဘောတူရပါမည်။",
    mn: "Үргэлжлүүлэхийн тулд та зөвшөөрөх ёстой",
    lo: "ທ່ານຕ້ອງຍອມຮັບເພື່ອສືບຕໍ່",
    tet: "Ita tenke konkorda atu kontinua",
    ne: "अगाडि बढ्नको लागि तपाईंले स्वीकार गर्नुपर्छ।",
    zh: '需要同意才能完成注册',
    vi: 'Bạn cần đồng ý để hoàn tất đăng ký',
    uz: "Davom etish uchun rozi boʻlishingiz kerak",
  );
  static String errorFor(FirebaseAuthException e, AppLanguage lang) {
    switch (e.code) {
      case 'email-already-in-use':
        return switch (lang) {
          AppLanguage.ko => '이미 가입된 이메일이에요. 로그인해 주세요.',
          AppLanguage.uz =>
            "Bu elektron pochta allaqachon roʻyxatdan oʻtgan. Iltimos, buning oʻrniga tizimga kiring.",
          AppLanguage.en =>
            'This email is already registered. Please log in instead.',
          AppLanguage.tr =>
            "Bu e-posta zaten kayıtlı. Lütfen bunun yerine giriş yapın.",
          AppLanguage.tg =>
            "Ин почтаи электронӣ аллакай сабти ном шудааст. Лутфан ба ҷои он ворид шавед.",
          AppLanguage.fil =>
            "Nakarehistro na ang email na ito. Mangyaring mag-log in na lang.",
          AppLanguage.ur =>
            "یہ ای میل پہلے ہی رجسٹرڈ ہے۔ براہ کرم اس کے بجائے لاگ ان کریں۔",
          AppLanguage.th => "อีเมลนี้ลงทะเบียนแล้ว โปรดเข้าสู่ระบบแทน",
          AppLanguage.ky =>
            "Бул электрондук почта буга чейин катталган. Анын ордуна кириңиз.",
          AppLanguage.km => "អ៊ីមែលនេះបានចុះឈ្មោះរួចហើយ។ សូមចូលគណនីជំនួសវិញ។",
          AppLanguage.id =>
            "Email ini sudah terdaftar. Silakan masuk sebagai gantinya.",
          AppLanguage.si =>
            "මෙම ඊමේල් ලිපිනය දැනටමත් ලියාපදිංචි වී ඇත. කරුණාකර ඒ වෙනුවට පිවිසෙන්න.",
          AppLanguage.bn =>
            "এই ইমেলটি ইতিমধ্যেই নিবন্ধিত। অনুগ্রহ করে এর পরিবর্তে লগ ইন করুন।",
          AppLanguage.my =>
            "ဤအီးမေးလ်ကို မှတ်ပုံတင်ထားပြီးဖြစ်သည်။ ကျေးဇူးပြု၍ ဝင်ရောက်ပါ။",
          AppLanguage.mn =>
            "Энэ и-мэйл хаяг аль хэдийн бүртгэгдсэн байна. Оронд нь нэвтэрнэ үү.",
          AppLanguage.lo => "ອີເມວນີ້ໄດ້ລົງທະບຽນແລ້ວ. ກະລຸນາເຂົ້າສູ່ລະບົບແທນ.",
          AppLanguage.tet => "Email ida ne'e rejista ona. Favor halo login.",
          AppLanguage.ne =>
            "यो इमेल पहिले नै दर्ता भइसकेको छ। कृपया यसको सट्टा लगइन गर्नुहोस्।",
          AppLanguage.zh => '该邮箱已注册，请登录。',
          AppLanguage.vi => 'Email này đã được đăng ký. Vui lòng đăng nhập.',
        };
      case 'invalid-email':
        return switch (lang) {
          AppLanguage.ko => '이메일 형식이 올바르지 않아요.',
          AppLanguage.uz => "Elektron pochta formati notoʻgʻri.",
          AppLanguage.en => 'The email format is invalid.',
          AppLanguage.tr => "E-posta biçimi geçersiz.",
          AppLanguage.tg => "Формати почтаи электронӣ нодуруст аст.",
          AppLanguage.fil => "Hindi balido ang format ng email.",
          AppLanguage.ur => "ای میل فارمیٹ غلط ہے۔",
          AppLanguage.th => "รูปแบบอีเมลไม่ถูกต้อง",
          AppLanguage.ky => "Электрондук почта форматы жараксыз.",
          AppLanguage.km => "ទម្រង់អ៊ីមែលមិនត្រឹមត្រូវ។",
          AppLanguage.id => "Format email tidak valid.",
          AppLanguage.si => "ඊමේල් ආකෘතිය වලංගු නොවේ.",
          AppLanguage.bn => "ইমেলের বিন্যাস অবৈধ।",
          AppLanguage.my => "အီးမေးလ်ပုံစံ မမှန်ကန်ပါ။",
          AppLanguage.mn => "И-мэйл хаягийн формат буруу байна.",
          AppLanguage.lo => "ຮູບແບບອີເມວບໍ່ຖືກຕ້ອງ.",
          AppLanguage.tet => "Formatu email la válidu.",
          AppLanguage.ne => "इमेल ढाँचा अमान्य छ।",
          AppLanguage.zh => '邮箱格式不正确。',
          AppLanguage.vi => 'Định dạng email không hợp lệ.',
        };
      case 'weak-password':
        return switch (lang) {
          AppLanguage.ko => '비밀번호가 너무 간단해요.',
          AppLanguage.uz => "Parol juda zaif.",
          AppLanguage.en => 'The password is too weak.',
          AppLanguage.tr => "Şifre çok zayıf.",
          AppLanguage.tg => "Парол хеле заиф аст.",
          AppLanguage.fil => "Masyadong mahina ang password.",
          AppLanguage.ur => "پاس ورڈ بہت کمزور ہے۔",
          AppLanguage.th => "รหัสผ่านอ่อนเกินไป",
          AppLanguage.ky => "Сырсөз өтө начар.",
          AppLanguage.km => "ពាក្យសម្ងាត់ខ្សោយពេក។",
          AppLanguage.id => "Kata sandi terlalu lemah.",
          AppLanguage.si => "මුරපදය ඉතා දුර්වලයි.",
          AppLanguage.bn => "পাসওয়ার্ড খুব দুর্বল।",
          AppLanguage.my => "စကားဝှက် အားနည်းလွန်းသည်။",
          AppLanguage.mn => "Нууц үг хэтэрхий сул байна.",
          AppLanguage.lo => "ລະຫັດຜ່ານອ່ອນເກີນໄປ.",
          AppLanguage.tet => "Password fraku liu.",
          AppLanguage.ne => "पासवर्ड धेरै कमजोर छ।",
          AppLanguage.zh => '密码强度太弱。',
          AppLanguage.vi => 'Mật khẩu quá yếu.',
        };
      default:
        return switch (lang) {
          AppLanguage.ko => '가입 중 문제가 생겼어요. 잠시 후 다시 시도해주세요.',
          AppLanguage.uz =>
            "Roʻyxatdan oʻtishda nimadir notoʻgʻri ketdi. Iltimos, birozdan keyin qayta urinib koʻring.",
          AppLanguage.en =>
            'Something went wrong while signing up. Please try again shortly.',
          AppLanguage.tr =>
            "Kaydolurken bir şeyler ters gitti. Lütfen kısa süre içinde tekrar deneyin.",
          AppLanguage.tg =>
            "Ҳангоми сабти ном чизе хато шуд. Лутфан ба зудӣ дубора кӯшиш кунед.",
          AppLanguage.fil =>
            "May nagkamali habang nagpaparehistro. Mangyaring subukang muli sa lalong madaling panahon.",
          AppLanguage.ur =>
            "رجسٹر کرتے وقت کچھ غلط ہو گیا۔ براہ کرم تھوڑی دیر بعد دوبارہ کوشش کریں۔",
          AppLanguage.th =>
            "มีบางอย่างผิดพลาดขณะลงทะเบียน โปรดลองอีกครั้งในไม่ช้า",
          AppLanguage.ky =>
            "Катталуу учурунда бир нерсе туура эмес болуп кетти. Сураныч, бир аздан кийин кайра аракет кылыңыз.",
          AppLanguage.km =>
            "មានអ្វីមួយខុសប្រក្រតីពេលចុះឈ្មោះ។ សូមព្យាយាមម្តងទៀតក្នុងពេលឆាប់ៗនេះ។",
          AppLanguage.id =>
            "Terjadi kesalahan saat mendaftar. Silakan coba lagi sebentar lagi.",
          AppLanguage.si =>
            "ලියාපදිංචි වීමේදී යමක් වැරදී ඇත. කරුණාකර ටික වේලාවකින් නැවත උත්සාහ කරන්න.",
          AppLanguage.bn =>
            "সাইন আপ করার সময় কিছু ভুল হয়েছে। অনুগ্রহ করে কিছুক্ষণ পরে আবার চেষ্টা করুন।",
          AppLanguage.my =>
            "အကောင့်ဖွင့်ရာတွင် တစ်ခုခုမှားယွင်းသွားပါသည်။ ကျေးဇူးပြု၍ ခဏအကြာတွင် ထပ်မံကြိုးစားပါ။",
          AppLanguage.mn =>
            "Бүртгүүлэх үед алдаа гарлаа. Удахгүй дахин оролдоно уу.",
          AppLanguage.lo =>
            "ມີບາງຢ່າງຜິດພາດໃນຂະນະທີ່ລົງທະບຽນ. ກະລຸນາລອງໃໝ່ອີກຄັ້ງໃນໄວໆນີ້.",
          AppLanguage.tet =>
            "Iha buat ruma la la'o di'ak bainhira rejista. Favor koko fali uitoan tan.",
          AppLanguage.ne =>
            "दर्ता गर्दा केही गडबड भयो। कृपया छिट्टै फेरि प्रयास गर्नुहोस्।",
          AppLanguage.zh => '注册过程中出现问题，请稍后重试。',
          AppLanguage.vi =>
            'Đã xảy ra sự cố khi đăng ký. Vui lòng thử lại sau.',
        };
    }
  }
}

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key, required this.draft, this.onComplete});

  final SignupDraft draft;

  /// SignupFormScreen이 AppEntryFlow의 오버레이로(Navigator.push 없이) 진입한
  /// 경우에만 채워진다 — pop 대신 이 콜백으로 완료를 알린다.
  final VoidCallback? onComplete;

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  final _authService = AuthService();
  final _userProfileApi = UserProfileApiService();
  bool _agreed = false;
  bool _submitting = false;

  Future<void> _submit(AppLanguage lang) async {
    if (!_agreed) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_S.errorConsentRequired.of(lang))));
      return;
    }
    setState(() => _submitting = true);
    try {
      final draft = widget.draft;
      String uid;
      String? email;
      if (draft.isGoogleFlow) {
        final user = _authService.currentUser;
        uid = user!.uid;
        email = user.email;
      } else {
        final credential = await _authService.signUpWithEmail(
          draft.email,
          draft.password!,
        );
        await _authService.updateDisplayName(draft.name);
        uid = credential.user!.uid;
        email = credential.user!.email;
      }

      final idToken = await _authService.currentIdToken();
      await _userProfileApi.upsertProfile(
        idToken: idToken!,
        name: draft.name,
        visaType: draft.visaTypeValue,
        nationality: draft.countryCode,
        preferredLanguage: lang.code.toLowerCase(),
      );

      if (!mounted) return;
      UserProfileScope.of(context).applyAuthenticatedProfile(
        uid: uid,
        email: email,
        name: draft.name,
        visa: draft.visa,
        nationality: draft.countryCode,
      );
      if (widget.onComplete != null) {
        widget.onComplete!();
      } else {
        // 회원가입 폼 + 동의 화면 둘 다 닫고 온보딩(체류자격 화면)으로 복귀.
        Navigator.of(context)
          ..pop()
          ..pop();
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_S.errorFor(e, lang))));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(switch (lang) {
            AppLanguage.ko => '가입 중 문제가 생겼어요. 잠시 후 다시 시도해주세요.',
            AppLanguage.uz =>
              "Roʻyxatdan oʻtishda nimadir notoʻgʻri ketdi. Iltimos, birozdan keyin qayta urinib koʻring.",
            AppLanguage.en =>
              'Something went wrong while signing up. Please try again shortly.',
            AppLanguage.tr =>
              "Kaydolurken bir şeyler ters gitti. Lütfen kısa süre içinde tekrar deneyin.",
            AppLanguage.tg =>
              "Ҳангоми сабти ном чизе хато шуд. Лутфан ба зудӣ дубора кӯшиш кунед.",
            AppLanguage.fil =>
              "May nagkamali habang nagpaparehistro. Mangyaring subukang muli sa lalong madaling panahon.",
            AppLanguage.ur =>
              "رجسٹر کرتے وقت کچھ غلط ہو گیا۔ براہ کرم تھوڑی دیر بعد دوبارہ کوشش کریں۔",
            AppLanguage.th =>
              "มีบางอย่างผิดพลาดขณะลงทะเบียน โปรดลองอีกครั้งในไม่ช้า",
            AppLanguage.ky =>
              "Катталуу учурунда бир нерсе туура эмес болуп кетти. Сураныч, бир аздан кийин кайра аракет кылыңыз.",
            AppLanguage.km =>
              "មានអ្វីមួយខុសប្រក្រតីពេលចុះឈ្មោះ។ សូមព្យាយាមម្តងទៀតក្នុងពេលឆាប់ៗនេះ។",
            AppLanguage.id =>
              "Terjadi kesalahan saat mendaftar. Silakan coba lagi sebentar lagi.",
            AppLanguage.si =>
              "ලියාපදිංචි වීමේදී යමක් වැරදී ඇත. කරුණාකර ටික වේලාවකින් නැවත උත්සාහ කරන්න.",
            AppLanguage.bn =>
              "সাইন আপ করার সময় কিছু ভুল হয়েছে। অনুগ্রহ করে কিছুক্ষণ পরে আবার চেষ্টা করুন।",
            AppLanguage.my =>
              "အကောင့်ဖွင့်ရာတွင် တစ်ခုခုမှားယွင်းသွားပါသည်။ ကျေးဇူးပြု၍ ခဏအကြာတွင် ထပ်မံကြိုးစားပါ။",
            AppLanguage.mn =>
              "Бүртгүүлэх үед алдаа гарлаа. Удахгүй дахин оролдоно уу.",
            AppLanguage.lo =>
              "ມີບາງຢ່າງຜິດພາດໃນຂະນະທີ່ລົງທະບຽນ. ກະລຸນາລອງໃໝ່ອີກຄັ້ງໃນໄວໆນີ້.",
            AppLanguage.tet =>
              "Iha buat ruma la la'o di'ak bainhira rejista. Favor koko fali uitoan tan.",
            AppLanguage.ne =>
              "दर्ता गर्दा केही गडबड भयो। कृपया छिट्टै फेरि प्रयास गर्नुहोस्।",
            AppLanguage.zh => '注册过程中出现问题，请稍后重试。',
            AppLanguage.vi =>
              'Đã xảy ra sự cố khi đăng ký. Vui lòng thử lại sau.',
          }),
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
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
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  Text(
                    _S.heading.of(lang),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _S.body.of(lang),
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                        height: 1.7,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => setState(() => _agreed = !_agreed),
                    borderRadius: BorderRadius.circular(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _agreed,
                          onChanged: (v) =>
                              setState(() => _agreed = v ?? false),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 13),
                            child: Text(
                              _S.agreeLabel.of(lang),
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitting ? null : () => _submit(lang),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _S.submitLabel.of(lang),
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
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
