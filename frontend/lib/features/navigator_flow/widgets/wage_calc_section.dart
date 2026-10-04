import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../common/widgets/rich_note.dart';
import '../../../core/app_language.dart';
import '../../../theme/app_colors.dart';
import '../../wage_calculator/models/wage_diagnosis.dart';
import '../../wage_calculator/screens/wage_calculator_screen.dart';
import '../controllers/wage_calc_scratch_controller.dart';
import '../models/flow_block.dart' show NoticeTone;
import 'flow_content_blocks.dart' show NoticeBox;

const _calcRunTitle = L10nText(
  ko: '임금계산기 바로 실행하기',
  en: 'Run the precise calculator',
  tr: "Hassas hesaplayıcıyı çalıştır",
  tg: "Ҳисобкунаки дақиқро иҷро кунед",
  fil: "Patakbuhin ang tumpak na calculator",
  ur: "درست کیلکولیٹر چلائیں",
  th: "เรียกใช้เครื่องคำนวณที่แม่นยำ",
  ky: "Так эсептегичти иштетүү",
  km: "ដំណើរការម៉ាស៊ីនគិតលេខច្បាស់លាស់",
  id: "Jalankan kalkulator presisi",
  si: "නිරවද්‍ය කැල්කියුලේටරය ක්‍රියාත්මක කරන්න",
  bn: "সঠিক ক্যালকুলেটর চালান",
  my: "တိကျသော ဂဏန်းတွက်စက်ကို လုပ်ဆောင်ပါ",
  mn: "Нарийвчилсан тооцоолуур ажиллуулах",
  lo: "ເປີດເຄື່ອງຄິດໄລ່ທີ່ຊັດເຈນ",
  tet: "Haka'as Kalkuladór Presizu",
  ne: "सटीक क्याल्कुलेटर चलाउनुहोस्",
  zh: '立即运行精密工资计算器',
  vi: 'Chạy máy tính lương chính xác',
  uz: "Aniq kalkulyatorni ishga tushirish",
);
const _calcRunSubtitle = L10nText(
  ko: '계산 안 해보신 분',
  en: "Haven't calculated yet",
  tr: "Henüz hesaplanmadı",
  tg: "Ҳанӯз ҳисоб нашудааст",
  fil: "Hindi pa nakalkula",
  ur: "ابھی تک حساب نہیں کیا گیا",
  th: "ยังไม่ได้คำนวณ",
  ky: "Азырынча эсептелген эмес",
  km: "មិនទាន់បានគណនា",
  id: "Belum dihitung",
  si: "තවම ගණනය කර නැත",
  bn: "এখনও গণনা করা হয়নি",
  my: "တွက်ချက်ရသေးပါ",
  mn: "Одоогоор тооцоолоогүй байна",
  lo: "ຍັງບໍ່ທັນໄດ້ຄິດໄລ່ເທື່ອ",
  tet: "Seidauk kalkula",
  ne: "अझै गणना गरिएको छैन",
  zh: '尚未计算过',
  vi: 'Nếu bạn chưa tính',
  uz: "Hali hisoblanmagan",
);
const _calcLoadTitle = L10nText(
  ko: '임금계산기 데이터 불러오기',
  en: 'Load calculator data',
  tr: "Hesaplayıcı verilerini yükle",
  tg: "Маълумоти ҳисобкунакро бор кунед",
  fil: "I-upload ang data ng calculator",
  ur: "کیلکولیٹر کا ڈیٹا اپ لوڈ کریں",
  th: "อัปโหลดข้อมูลเครื่องคำนวณ",
  ky: "Эсептегичтин маалыматтарын жүктөө",
  km: "ផ្ទុកទិន្នន័យម៉ាស៊ីនគិតលេខ",
  id: "Unggah data kalkulator",
  si: "කැල්කියුලේටර දත්ත උඩුගත කරන්න",
  bn: "ক্যালকুলেটরের ডেটা আপলোড করুন",
  my: "ဂဏန်းတွက်စက်ဒေတာ တင်ပါ",
  mn: "Тооцоолуурын өгөгдлийг байршуулах",
  lo: "ອັບໂຫຼດຂໍ້ມູນເຄື່ອງຄິດໄລ່",
  tet: "Upload Dadus Kalkuladór",
  ne: "क्याल्कुलेटरको डेटा अपलोड गर्नुहोस्",
  zh: '导入工资计算器数据',
  vi: 'Tải dữ liệu máy tính lương',
  uz: "Kalkulyator maʼlumotlarini yuklash",
);
const _calcLoadSubtitle = L10nText(
  ko: '이미 계산해보신 분',
  en: 'Already calculated',
  tr: "Zaten hesaplandı",
  tg: "Аллакай ҳисоб шудааст",
  fil: "Nakalkula na",
  ur: "پہلے ہی حساب کیا جا چکا ہے",
  th: "คำนวณแล้ว",
  ky: "Буга чейин эсептелген",
  km: "បានគណនារួចហើយ",
  id: "Sudah dihitung",
  si: "දැනටමත් ගණනය කර ඇත",
  bn: "ইতিমধ্যে গণনা করা হয়েছে",
  my: "တွက်ချက်ပြီးပါပြီ",
  mn: "Аль хэдийн тооцоолсон",
  lo: "ໄດ້ຄິດໄລ່ແລ້ວ",
  tet: "Kalkula ona",
  ne: "पहिले नै गणना गरिसकिएको छ",
  zh: '已经计算过',
  vi: 'Nếu bạn đã tính rồi',
  uz: "Allaqaon hisoblangan",
);
const _calcAlreadyLoadedToast = L10nText(
  ko: '이미 최신 계산 데이터를 사용 중입니다',
  en: 'Already using your latest calculation',
  tr: "Zaten en son hesaplamanızı kullanıyorsunuz",
  tg: "Шумо аллакай ҳисоби охирини худро истифода мебаред",
  fil: "Ginagamit mo na ang iyong pinakabagong kalkulasyon",
  ur: "آپ پہلے ہی اپنی تازہ ترین گنتی استعمال کر رہے ہیں",
  th: "คุณกำลังใช้การคำนวณล่าสุดของคุณอยู่แล้ว",
  ky: "Сиз буга чейин акыркы эсептөөңүздү колдонуп жатасыз",
  km: "អ្នកកំពុងប្រើការគណនាចុងក្រោយបំផុតរបស់អ្នករួចហើយ",
  id: "Anda sudah menggunakan perhitungan terbaru Anda",
  si: "ඔබ දැනටමත් ඔබගේ නවතම ගණනය භාවිතා කරයි",
  bn: "আপনি ইতিমধ্যেই আপনার সর্বশেষ গণনা ব্যবহার করছেন",
  my: "သင်၏ နောက်ဆုံးတွက်ချက်မှုကို အသုံးပြုနေပါပြီ",
  mn: "Та хамгийн сүүлийн тооцооллоо аль хэдийн ашиглаж байна",
  lo: "ທ່ານກຳລັງໃຊ້ການຄິດໄລ່ຫຼ້າສຸດຂອງທ່ານຢູ່ແລ້ວ",
  tet: "Ita-boot uza ona kalkulasaun ikus liu",
  ne: "तपाईंले पहिले नै आफ्नो पछिल्लो गणना प्रयोग गरिरहनुभएको छ",
  zh: '已在使用最新的计算数据',
  vi: 'Đang dùng dữ liệu tính toán mới nhất',
  uz: "Allaqaon soʻnggi hisob-kitobingizdan foydalanilmoqda",
);
const _calcNotYetAvailableToast = L10nText(
  ko: '아직 계산한 데이터가 없습니다. 위 버튼으로 정밀 임금계산기를 먼저 실행해주세요.',
  en: 'No calculation yet. Please run the precise calculator with the button above first.',
  tr: "Henüz hesaplama yapılmadı. Lütfen önce yukarıdaki düğmeyle hassas hesaplayıcıyı çalıştırın.",
  tg: "Ҳанӯз ҳисобкунӣ анҷом дода нашудааст. Лутфан, аввал ҳисобкунаки дақиқро бо тугмаи боло иҷро кунед.",
  fil:
      "Wala pang kalkulasyon. Mangyaring patakbuhin muna ang tumpak na calculator gamit ang button sa itaas.",
  ur: "ابھی تک کوئی حساب نہیں کیا گیا۔ براہ کرم پہلے اوپر والے بٹن سے درست کیلکولیٹر چلائیں۔",
  th: "ยังไม่มีการคำนวณ โปรดเรียกใช้เครื่องคำนวณที่แม่นยำด้วยปุ่มด้านบนก่อน",
  ky: "Азырынча эсептөө жүргүзүлгөн эмес. Сураныч, адегенде жогорудагы баскыч менен так эсептегичти иштетиңиз.",
  km: "មិនទាន់មានការគណនាទេ។ សូមដំណើរការម៉ាស៊ីនគិតលេខច្បាស់លាស់ដោយប្រើប៊ូតុងខាងលើជាមុនសិន។",
  id: "Belum ada perhitungan. Harap jalankan kalkulator presisi dengan tombol di atas terlebih dahulu.",
  si: "තවම ගණනය කර නැත. කරුණාකර පළමුව ඉහත බොත්තම සමඟ නිරවද්‍ය කැල්කියුලේටරය ක්‍රියාත්මක කරන්න.",
  bn: "এখনও কোনো গণনা করা হয়নি। অনুগ্রহ করে প্রথমে উপরের বোতাম দিয়ে সঠিক ক্যালকুলেটর চালান।",
  my: "တွက်ချက်မှု မရှိသေးပါ။ ကျေးဇူးပြု၍ အပေါ်ရှိ ခလုတ်ဖြင့် တိကျသော ဂဏန်းတွက်စက်ကို ဦးစွာ လုပ်ဆောင်ပါ။",
  mn: "Одоогоор тооцоолол хийгдээгүй байна. Эхлээд дээрх товчлуураар нарийвчилсан тооцоолуурыг ажиллуулна уу.",
  lo: "ຍັງບໍ່ທັນໄດ້ມີການຄິດໄລ່ເທື່ອ. ກະລຸນາເປີດເຄື່ອງຄິດໄລ່ທີ່ຊັດເຈນດ້ວຍປຸ່ມຂ້າງເທິງກ່ອນ.",
  tet:
      "Seidauk halo kalkulasaun. Favor haka'as kalkuladór presizu ho butaun iha leten uluk.",
  ne: "अझै गणना गरिएको छैन। कृपया पहिले माथिको बटन प्रयोग गरेर सटीक क्याल्कुलेटर चलाउनुहोस्।",
  zh: '尚无计算数据，请先用上方按钮运行精密工资计算器。',
  vi: 'Chưa có dữ liệu tính toán. Hãy chạy máy tính lương chính xác bằng nút bên trên trước.',
  uz: "Hali hisob-kitob yoʻq. Iltimos, avval yuqoridagi tugma bilan aniq kalkulyatorni ishga tushiring.",
);
const _reportEmptyText = L10nText(
  ko: '아직 계산 데이터가 없습니다. 위 버튼으로 임금계산기를 실행하거나 데이터를 불러오세요.',
  en: 'No calculation yet. Use the buttons above to run the calculator or load your data.',
  tr: "Henüz hesaplama yapılmadı. Hesaplayıcıyı çalıştırmak veya verilerinizi yüklemek için yukarıdaki düğmeleri kullanın.",
  tg: "Ҳанӯз ҳисобкунӣ анҷом дода нашудааст. Барои иҷро кардани ҳисобкунак ё бор кардани маълумоти худ тугмаҳои болоро истифода баред.",
  fil:
      "Wala pang kalkulasyon. Gamitin ang mga button sa itaas upang patakbuhin ang calculator o i-upload ang iyong data.",
  ur: "ابھی تک کوئی حساب نہیں کیا گیا۔ کیلکولیٹر چلانے یا اپنا ڈیٹا اپ لوڈ کرنے کے لیے اوپر والے بٹن استعمال کریں۔",
  th: "ยังไม่มีการคำนวณ โปรดใช้ปุ่มด้านบนเพื่อเรียกใช้เครื่องคำนวณหรืออัปโหลดข้อมูลของคุณ",
  ky: "Азырынча эсептөө жүргүзүлгөн эмес. Эсептегичти иштетүү же маалыматтарыңызды жүктөө үчүн жогорудагы баскычтарды колдонуңуз.",
  km: "មិនទាន់មានការគណនាទេ។ សូមប្រើប៊ូតុងខាងលើដើម្បីដំណើរការម៉ាស៊ីនគិតលេខ ឬផ្ទុកទិន្នន័យរបស់អ្នក។",
  id: "Belum ada perhitungan. Gunakan tombol di atas untuk menjalankan kalkulator atau mengunggah data Anda.",
  si: "තවම ගණනය කර නැත. කැල්කියුලේටරය ක්‍රියාත්මක කිරීමට හෝ ඔබගේ දත්ත උඩුගත කිරීමට ඉහත බොත්තම් භාවිතා කරන්න.",
  bn: "এখনও কোনো গণনা করা হয়নি। ক্যালকুলেটর চালাতে বা আপনার ডেটা আপলোড করতে উপরের বোতামগুলি ব্যবহার করুন।",
  my: "တွက်ချက်မှု မရှိသေးပါ။ ဂဏန်းတွက်စက်ကို လုပ်ဆောင်ရန် သို့မဟုတ် သင်၏ဒေတာကို တင်ရန် အပေါ်ရှိ ခလုတ်များကို အသုံးပြုပါ။",
  mn: "Одоогоор тооцоолол хийгдээгүй байна. Тооцоолуурыг ажиллуулах эсвэл өгөгдлөө байршуулахын тулд дээрх товчлууруудыг ашиглана уу.",
  lo: "ຍັງບໍ່ທັນໄດ້ມີການຄິດໄລ່ເທື່ອ. ໃຊ້ປຸ່ມຂ້າງເທິງເພື່ອເປີດເຄື່ອງຄິດໄລ່ ຫຼື ອັບໂຫຼດຂໍ້ມູນຂອງທ່ານ.",
  tet:
      "Seidauk halo kalkulasaun. Uza butaun sira iha leten atu haka'as kalkuladór ka upload ita-boot nia dadus.",
  ne: "अझै गणना गरिएको छैन। क्याल्कुलेटर चलाउन वा आफ्नो डेटा अपलोड गर्न माथिका बटनहरू प्रयोग गर्नुहोस्।",
  zh: '尚无计算数据，请用上方按钮运行计算器或导入数据。',
  vi: 'Chưa có dữ liệu tính toán. Hãy dùng nút bên trên để chạy máy tính hoặc tải dữ liệu.',
  uz: "Hali hisob-kitob yoʻq. Kalkulyatorni ishga tushirish yoki maʼlumotlaringizni yuklash uchun yuqoridagi tugmalardan foydalaning.",
);
const _expectedLabel = L10nText(
  ko: '법정 예상 실수령액(세후)',
  en: 'Expected legal take-home (after tax)',
  tr: "Beklenen yasal net gelir (vergi sonrası)",
  tg: "Даромади софи қонунии интизорӣ (пас аз андоз)",
  fil: "Inaasahang legal na netong kita (pagkatapos ng buwis)",
  ur: "متوقع قانونی خالص آمدنی (ٹیکس کے بعد)",
  th: "รายได้สุทธิทางกฎหมายที่คาดการณ์ไว้ (หลังหักภาษี)",
  ky: "Күтүлгөн мыйзамдуу таза киреше (салыктан кийин)",
  km: "ប្រាក់ចំណូលសុទ្ធតាមច្បាប់ដែលរំពឹងទុក (ក្រោយបង់ពន្ធ)",
  id: "Perkiraan pendapatan bersih legal (setelah pajak)",
  si: "අපේක්ෂිත නීත්‍යානුකූල ශුද්ධ ආදායම (බදු පසු)",
  bn: "প্রত্যাশিত আইনি নেট আয় (কর-পরবর্তী)",
  my: "မျှော်မှန်းထားသော တရားဝင် အသားတင်ဝင်ငွေ (အခွန်ပြီးနောက်)",
  mn: "Хүлээгдэж буй хууль ёсны цэвэр орлого (татварын дараах)",
  lo: "ລາຍຮັບສຸດທິທີ່ຄາດວ່າຈະໄດ້ຮັບຕາມກົດໝາຍ (ຫຼັງຫັກພາສີ)",
  tet: "Rendimentu Líku Legál Esperadu (depois de impostu)",
  ne: "अपेक्षित कानूनी शुद्ध आम्दानी (कर पछिको)",
  zh: '法定预期实收（税后）',
  vi: 'Lương thực nhận dự kiến (sau thuế)',
  uz: "Kutilayotgan qonuniy sof daromad (soliqdan keyin)",
);
const _receivedRowLabel = L10nText(
  ko: '실제 받은 금액',
  en: 'Actual amount received',
  tr: "Alınan gerçek miktar",
  tg: "Маблағи воқеии гирифташуда",
  fil: "Aktwal na halagang natanggap",
  ur: "اصل موصول شدہ رقم",
  th: "จำนวนเงินจริงที่ได้รับ",
  ky: "Алынган иш жүзүндөгү сумма",
  km: "ចំនួនទឹកប្រាក់ពិតប្រាកដដែលបានទទួល",
  id: "Jumlah aktual yang diterima",
  si: "ලැබුණු සත්‍ය මුදල",
  bn: "প্রকৃত প্রাপ্ত পরিমাণ",
  my: "လက်ခံရရှိသည့် အမှန်တကယ် ပမာဏ",
  mn: "Бодит авсан дүн",
  lo: "ຈຳນວນເງິນຕົວຈິງທີ່ໄດ້ຮັບ",
  tet: "Montante Reál Simu",
  ne: "प्राप्त भएको वास्तविक रकम",
  zh: '实际到账金额',
  vi: 'Số tiền thực nhận',
  uz: "Olingan haqiqiy miqdor",
);
const _gapLabel = L10nText(
  ko: '🚨 예상 미지급 체불액',
  en: '🚨 Estimated unpaid amount',
  tr: "🚨 Tahmini ödenmemiş miktar",
  tg: "🚨 Маблағи тахминии пардохтнашуда",
  fil: "🚨 Tinatayang hindi pa nababayarang halaga",
  ur: "🚨 تخمینہ شدہ غیر ادا شدہ رقم",
  th: "🚨 จำนวนเงินที่ค้างชำระโดยประมาณ",
  ky: "🚨 Болжолдуу төлөнбөгөн сумма",
  km: "🚨 ចំនួនទឹកប្រាក់ដែលមិនទាន់បានបង់ប៉ាន់ស្មាន",
  id: "🚨 Perkiraan jumlah yang belum dibayar",
  si: "🚨 ඇස්තමේන්තුගත නොගෙවූ මුදල",
  bn: "🚨 আনুমানিক বকেয়া পরিমাণ",
  my: "🚨 ခန့်မှန်းခြေ ပေးရန်ကျန်ရှိသော ပမာဏ",
  mn: "🚨 Тооцоолсон төлөгдөөгүй дүн",
  lo: "🚨 ຈຳນວນເງິນທີ່ຄາດວ່າຈະບໍ່ໄດ້ຮັບ",
  tet: "🚨 Montante La Pagu Estimadu",
  ne: "🚨 अनुमानित भुक्तानी नभएको रकम",
  zh: '🚨 预计未付欠薪额',
  vi: '🚨 Số tiền dự kiến bị nợ',
  uz: "🚨 Taxminiy toʻlanmagan miqdor",
);
const _matchLabel = L10nText(
  ko: '✅ 계산 결과와 입금액이 거의 일치합니다',
  en: '✅ This matches what you received',
  tr: "✅ Bu, aldığınız miktarla eşleşiyor",
  tg: "✅ Ин ба маблағи гирифтаи шумо мувофиқат мекунад",
  fil: "✅ Ito ay tumutugma sa halagang natanggap mo",
  ur: "✅ یہ آپ کو موصول ہونے والی رقم سے میل کھاتا ہے",
  th: "✅ ตรงกับจำนวนเงินที่คุณได้รับ",
  ky: "✅ Бул сиз алган суммага дал келет",
  km: "✅ នេះត្រូវគ្នានឹងចំនួនទឹកប្រាក់ដែលអ្នកបានទទួល",
  id: "✅ Ini cocok dengan jumlah yang Anda terima",
  si: "✅ මෙය ඔබ ලැබුණු මුදලට ගැලපේ",
  bn: "✅ এটি আপনার প্রাপ্ত পরিমাণের সাথে মিলে যায়",
  my: "✅ ၎င်းသည် သင်လက်ခံရရှိသည့် ပမာဏနှင့် ကိုက်ညီသည်",
  mn: "✅ Энэ нь таны авсан дүнтэй таарч байна",
  lo: "✅ ອັນນີ້ກົງກັບຈຳນວນເງິນທີ່ທ່ານໄດ້ຮັບ",
  tet: "✅ Ne'e hanesan ho montante ne'ebé ita-boot simu",
  ne: "✅ यो तपाईंले प्राप्त गरेको रकमसँग मेल खान्छ",
  zh: '✅ 计算结果与到账金额基本一致',
  vi: '✅ Kết quả khớp với số tiền đã nhận',
  uz: "✅ Bu siz olgan miqdorga mos keladi",
);
const _calcDiffLabel = L10nText(
  ko: 'ℹ️ 계산 방식 차이로 보이는 금액',
  en: 'ℹ️ Likely a calculation-method difference',
  tr: "ℹ️ Muhtemelen bir hesaplama yöntemi farkı",
  tg: "ℹ️ Эҳтимол фарқияти усули ҳисобкунӣ",
  fil: "ℹ️ Malamang na pagkakaiba sa paraan ng pagkalkula",
  ur: "ℹ️ ممکنہ طور پر حساب کے طریقہ کار میں فرق",
  th: "ℹ️ อาจมีความแตกต่างในวิธีการคำนวณ",
  ky: "ℹ️ Балким, эсептөө ыкмасында айырма бардыр",
  km: "ℹ️ ប្រហែលជាមានភាពខុសគ្នានៃវិធីសាស្ត្រគណនា",
  id: "ℹ️ Kemungkinan perbedaan metode perhitungan",
  si: "ℹ️ බොහෝ විට ගණනය කිරීමේ ක්‍රමයේ වෙනසක්",
  bn: "ℹ️ সম্ভবত একটি গণনা পদ্ধতির পার্থক্য",
  my: "ℹ️ တွက်ချက်မှုနည်းလမ်း ကွာခြားချက် ဖြစ်နိုင်သည်",
  mn: "ℹ️ Магадгүй тооцоолох аргачлалын ялгаа",
  lo: "ℹ️ ອາດຈະມີຄວາມແຕກຕ່າງໃນວິທີການຄິດໄລ່",
  tet: "ℹ️ Karik diferensa iha métodu kalkulasaun",
  ne: "ℹ️ सम्भवतः गणना विधिमा भिन्नता",
  zh: 'ℹ️ 可能是计算方式差异',
  vi: 'ℹ️ Có vẻ là khác biệt cách tính',
  uz: "ℹ️ Hisoblash usuli farqi boʻlishi mumkin",
);
const _refEstimateTitle = L10nText(
  ko: '⚠ 이 금액은 참고용 예상액입니다',
  en: '⚠ This is a reference estimate',
  tr: "⚠ Bu bir referans tahmindir",
  tg: "⚠ Ин як тахмини истинодӣ аст",
  fil: "⚠ Ito ay isang reference na pagtatantya",
  ur: "⚠ یہ ایک حوالہ جاتی تخمینہ ہے",
  th: "⚠ นี่คือการประมาณการอ้างอิง",
  ky: "⚠ Бул маалымдама болжолдоо",
  km: "⚠ នេះគឺជាការប៉ាន់ស្មានយោង",
  id: "⚠ Ini adalah perkiraan referensi",
  si: "⚠ මෙය යොමු ඇස්තමේන්තුවකි",
  bn: "⚠ এটি একটি রেফারেন্স অনুমান",
  my: "⚠ ၎င်းသည် ကိုးကားခန့်မှန်းချက် ဖြစ်သည်",
  mn: "⚠ Энэ бол лавлагааны тооцоо юм",
  lo: "⚠ ນີ້ແມ່ນການຄາດຄະເນເພື່ອອ້າງອີງ",
  tet: "⚠ Ne'e estimativa referénsia ida",
  ne: "⚠ यो एक सन्दर्भ अनुमान हो",
  zh: '⚠ 此金额仅供参考',
  vi: '⚠ Số tiền này chỉ để tham khảo',
  uz: "⚠ Bu maʼlumotnoma hisob-kitobi",
);
const _refEstimateBody = L10nText(
  ko: '근로기준법 기본 공식을 적용한 추정치이며, 정확한 체불액은 근로감독관 조사에서 산정됩니다. 계산기 결과는 진정서로 자동으로 넘어가지 않습니다.',
  en: "This applies the basic formulas of the Labor Standards Act; the confirmed amount is determined by a labor inspector. The result is not carried into the complaint automatically.",
  tr: "Bu, İş Kanunu'nun temel formüllerini uygular; onaylanan miktar bir iş müfettişi tarafından belirlenir. Sonuç otomatik olarak şikayete aktarılmaz.",
  tg: "Ин формулаҳои асосии Қонуни меҳнатро татбиқ мекунад; маблағи тасдиқшуда аз ҷониби нозири меҳнат муайян карда мешавад. Натиҷа ба таври худкор ба шикоят интиқол дода намешавад.",
  fil:
      "Ito ay naglalapat ng mga pangunahing formula ng Labor Law; ang aprubadong halaga ay tinutukoy ng isang labor inspector. Ang resulta ay hindi awtomatikong inililipat sa reklamo.",
  ur: "یہ لیبر قانون کے بنیادی فارمولوں کا اطلاق کرتا ہے؛ منظور شدہ رقم کا تعین لیبر انسپکٹر کرتا ہے۔ نتیجہ خود بخود شکایت میں منتقل نہیں ہوتا۔",
  th: "สิ่งนี้ใช้สูตรพื้นฐานของกฎหมายแรงงาน จำนวนเงินที่ได้รับการอนุมัติจะถูกกำหนดโดยผู้ตรวจแรงงาน ผลลัพธ์จะไม่ถูกโอนไปยังการร้องเรียนโดยอัตโนมัติ",
  ky: "Бул Эмгек мыйзамынын негизги формулаларын колдонот; бекитилген сумма эмгек инспектору тарабынан аныкталат. Жыйынтык автоматтык түрдө арызга өткөрүлүп берилбейт.",
  km: "នេះអនុវត្តរូបមន្តមូលដ្ឋាននៃច្បាប់ការងារ; ចំនួនទឹកប្រាក់ដែលបានអនុម័តត្រូវបានកំណត់ដោយអធិការការងារ។ លទ្ធផលមិនត្រូវបានផ្ទេរដោយស្វ័យប្រវត្តិទៅបណ្តឹងនោះទេ។",
  id: "Ini menerapkan formula dasar Undang-Undang Ketenagakerjaan; jumlah yang disetujui ditentukan oleh inspektur ketenagakerjaan. Hasilnya tidak secara otomatis ditransfer ke keluhan.",
  si: "මෙය කම්කරු නීතියේ මූලික සූත්‍ර යොදයි; අනුමත මුදල කම්කරු පරීක්ෂකවරයෙකු විසින් තීරණය කරනු ලැබේ. ප්‍රතිඵලය ස්වයංක්‍රීයව පැමිණිල්ලට මාරු නොවේ.",
  bn: "এটি শ্রম আইনের মৌলিক সূত্রগুলি প্রয়োগ করে; অনুমোদিত পরিমাণ একজন শ্রম পরিদর্শক দ্বারা নির্ধারিত হয়। ফলাফল স্বয়ংক্রিয়ভাবে অভিযোগে স্থানান্তরিত হয় না।",
  my: "၎င်းသည် အလုပ်သမားဥပဒေ၏ အခြေခံဖော်မြူလာများကို အသုံးပြုထားသည်။ အတည်ပြုထားသော ပမာဏကို အလုပ်သမားစစ်ဆေးရေးမှူးက ဆုံးဖြတ်သည်။ ရလဒ်ကို တိုင်ကြားချက်သို့ အလိုအလျောက် လွှဲပြောင်းပေးမည်မဟုတ်ပါ။",
  mn: "Энэ нь Хөдөлмөрийн тухай хуулийн үндсэн томъёог хэрэглэдэг; батлагдсан дүнг хөдөлмөрийн байцаагч тодорхойлно. Үр дүн нь гомдолд автоматаар шилжихгүй.",
  lo: "ອັນນີ້ແມ່ນນຳໃຊ້ສູດພື້ນຖານຂອງກົດໝາຍແຮງງານ; ຈຳນວນເງິນທີ່ໄດ້ຮັບການອະນຸມັດແມ່ນຖືກກຳນົດໂດຍຜູ້ກວດກາແຮງງານ. ຜົນໄດ້ຮັບຈະບໍ່ຖືກໂອນເຂົ້າໃນຄຳຮ້ອງທຸກໂດຍອັດຕະໂນມັດ.",
  tet:
      "Ne'e aplika fórmula bázika husi Lei Traballu; montante aprovadu sei deside husi inspetór traballu ida. Rezultadu la transferidu automaticamente ba keixa.",
  ne: "यसले श्रम कानूनका आधारभूत सूत्रहरू लागू गर्दछ; स्वीकृत रकम श्रम निरीक्षकद्वारा निर्धारण गरिन्छ। नतिजा स्वचालित रूपमा उजुरीमा स्थानान्तरण हुँदैन।",
  zh: '此为适用《劳动基准法》基本公式的推算值，确切欠薪额由劳动监督官调查核定。计算结果不会自动带入申诉书。',
  vi: 'Đây là ước tính theo công thức cơ bản của Luật Tiêu chuẩn Lao động, số chính thức do thanh tra lao động xác định. Kết quả không tự chuyển sang đơn.',
  uz: "Bu Mehnat standartlari qonunining asosiy formulalarini qoʻllaydi; tasdiqlangan miqdor mehnat inspektori tomonidan belgilanadi. Natija shikoyatga avtomatik ravishda kiritilmaydi.",
);
const _aiReasonLabelPos = L10nText(
  ko: '🔍 AI 체불 원인 분석 · 왜 더 받아야 하는지 근거 보기',
  en: '🔍 AI breakdown · why you may be owed more',
  tr: "🔍 Yapay zeka analizi · neden daha fazla alacağınız olabilir",
  tg: "🔍 Таҳлили зеҳни сунъӣ · чаро шумо метавонед бештар гиред",
  fil: "🔍 Pagsusuri ng AI · bakit maaaring mas malaki ang matatanggap mo",
  ur: "🔍 اے آئی تجزیہ · آپ کو مزید کیوں مل سکتا ہے",
  th: "🔍 การวิเคราะห์ด้วย AI · เหตุผลที่คุณอาจได้รับเงินเพิ่ม",
  ky: "🔍 Жасалма интеллект талдоосу · эмне үчүн көбүрөөк алышыңыз мүмкүн",
  km: "🔍 ការវិភាគដោយបញ្ញាសិប្បនិម្មិត · ហេតុអ្វីអ្នកអាចទទួលបានច្រើនជាងនេះ",
  id: "🔍 Analisis AI · mengapa Anda mungkin menerima lebih banyak",
  si: "🔍 AI විශ්ලේෂණය · ඔබට වැඩිපුර ලැබිය හැකි හේතු",
  bn: "🔍 এআই বিশ্লেষণ · কেন আপনি আরও পেতে পারেন",
  my: "🔍 AI ခွဲခြမ်းစိတ်ဖြာခြင်း · အဘယ်ကြောင့် ပိုမိုရရှိနိုင်သည်ကို သိရှိနိုင်ရန်",
  mn: "🔍 Хиймэл оюун ухааны шинжилгээ · та яагаад илүү их мөнгө авах ёстойг харуулна",
  lo: "🔍 ການວິເຄາະດ້ວຍ AI · ເປັນຫຍັງທ່ານອາດຈະໄດ້ຮັບຫຼາຍກວ່ານີ້",
  tet: "🔍 Análize ho intelijénsia artifisiál · tanba sá bele simu liu",
  ne: "🔍 एआई विश्लेषण · तपाईंले किन बढी पाउन सक्नुहुन्छ",
  zh: '🔍 AI原因分析·查看应多收依据',
  vi: '🔍 Phân tích AI · vì sao bạn nên nhận thêm',
  uz: "🔍 AI tahlili · nima uchun sizga koʻproq pul toʻlanishi mumkin",
);
const _aiReasonLabelOther = L10nText(
  ko: '🔍 금액 차이 원인 보기',
  en: '🔍 See why the amounts differ',
  tr: "🔍 Miktarların neden farklı olduğunu görün",
  tg: "🔍 Бубинед, ки чаро маблағҳо фарқ мекунанд",
  fil: "🔍 Tingnan kung bakit magkaiba ang mga halaga",
  ur: "🔍 دیکھیں کہ رقمیں مختلف کیوں ہیں",
  th: "🔍 ดูว่าทำไมจำนวนเงินถึงแตกต่างกัน",
  ky: "🔍 Суммалар эмне үчүн айырмаланарын көрүңүз",
  km: "🔍 មើលមូលហេតុដែលចំនួនទឹកប្រាក់ខុសគ្នា",
  id: "🔍 Lihat mengapa jumlahnya berbeda",
  si: "🔍 මුදල් ප්‍රමාණයන් වෙනස් වන්නේ ඇයි දැයි බලන්න",
  bn: "🔍 দেখুন কেন পরিমাণ ভিন্ন হতে পারে",
  my: "🔍 ပမာဏများ အဘယ်ကြောင့် ကွာခြားသည်ကို ကြည့်ပါ",
  mn: "🔍 Яагаад дүн өөр байгааг харна уу",
  lo: "🔍 ເບິ່ງວ່າເປັນຫຍັງຈຳນວນເງິນຈຶ່ງແຕກຕ່າງກັນ",
  tet: "🔍 Haree tanba sá montante sira la hanesan",
  ne: "🔍 रकमहरू किन फरक छन् हेर्नुहोस्",
  zh: '🔍 查看金额差异原因',
  vi: '🔍 Xem lý do chênh lệch',
  uz: "🔍 Miqdorlar nima uchun farq qilishini koʻring",
);
const _aiReasonTitle = L10nText(
  ko: 'AI 체불 원인 분석',
  en: 'AI-matched reasons',
  tr: "Yapay zeka eşleşen nedenler",
  tg: "Сабабҳои мувофиқи зеҳни сунъӣ",
  fil: "Mga dahilan na tinukoy ng AI",
  ur: "اے آئی سے مماثل وجوہات",
  th: "เหตุผลที่ AI ตรวจพบ",
  ky: "Жасалма интеллект дал келген себептер",
  km: "មូលហេតុដែល AI រកឃើញ",
  id: "Alasan yang cocok dengan AI",
  si: "AI ගැලපෙන හේතු",
  bn: "এআই মিলে যাওয়া কারণগুলি",
  my: "AI ကိုက်ညီသော အကြောင်းရင်းများ",
  mn: "Хиймэл оюун ухаан таарсан шалтгаанууд",
  lo: "ສາເຫດທີ່ AI ກົງກັນ",
  tet: "Intelijénsia artifisiál identifika razaun sira",
  ne: "एआईले मिल्दो कारणहरू",
  zh: 'AI原因分析',
  vi: 'Phân tích nguyên nhân theo AI',
  uz: "AI mos keladigan sabablar",
);
const _talkOptionTitle = L10nText(
  ko: '💬 사업주와 대화해보기',
  en: '💬 Try talking to your employer',
  tr: "💬 İşvereninizle konuşmayı deneyin",
  tg: "💬 Кӯшиш кунед, ки бо корфармои худ сӯҳбат кунед",
  fil: "💬 Subukang kausapin ang iyong employer",
  ur: "💬 اپنے آجر سے بات کرنے کی کوشش کریں",
  th: "💬 ลองคุยกับนายจ้างของคุณ",
  ky: "💬 Жумуш берүүчүңүз менен сүйлөшүп көрүңүз",
  km: "💬 ព្យាយាមនិយាយជាមួយនិយោជករបស់អ្នក",
  id: "💬 Coba bicara dengan atasan Anda",
  si: "💬 ඔබේ සේවායෝජකයා සමඟ කතා කිරීමට උත්සාහ කරන්න",
  bn: "💬 আপনার নিয়োগকর্তার সাথে কথা বলার চেষ্টা করুন",
  my: "💬 အလုပ်ရှင်နှင့် စကားပြောကြည့်ပါ",
  mn: "💬 Ажил олгогчтойгоо ярилцаж үзээрэй",
  lo: "💬 ລອງລົມກັບນາຍຈ້າງຂອງທ່ານ",
  tet: "💬 Koko koʼalia ho imi-nia empregadór",
  ne: "💬 आफ्नो रोजगारदातासँग कुरा गर्ने प्रयास गर्नुहोस्",
  zh: '💬 先与雇主沟通',
  vi: '💬 Thử nói chuyện với chủ',
  uz: "💬 Ish beruvchingiz bilan gaplashib koʻring",
);
const _talkOptionSubtitle = L10nText(
  ko: '노동청 신고 전 사장님과 대화로 원만히 해결을 시도합니다',
  en: 'Try to resolve it directly with your employer before filing',
  tr: "Şikayette bulunmadan önce doğrudan işvereninizle çözmeye çalışın",
  tg: "Пеш аз шикоят кардан, кӯшиш кунед, ки мустақиман бо корфармои худ ҳал кунед",
  fil:
      "Subukang ayusin muna nang direkta sa iyong employer bago maghain ng reklamo",
  ur: "شکایت درج کرنے سے پہلے براہ راست اپنے آجر کے ساتھ حل کرنے کی کوشش کریں۔",
  th: "พยายามแก้ไขปัญหากับนายจ้างของคุณโดยตรงก่อนที่จะยื่นเรื่องร้องเรียน",
  ky: "Арыз жазуудан мурун, түздөн-түз жумуш берүүчүңүз менен чечүүгө аракет кылыңыз",
  km: "មុននឹងដាក់ពាក្យបណ្តឹង សូមព្យាយាមដោះស្រាយដោយផ្ទាល់ជាមួយនិយោជករបស់អ្នក",
  id: "Coba selesaikan langsung dengan atasan Anda sebelum mengajukan keluhan",
  si: "ඔබ පැමිණිල්ලක් කිරීමට පෙර ඔබේ සේවායෝජකයා සමඟ කෙලින්ම විසඳා ගැනීමට උත්සාහ කරන්න",
  bn: "অভিযোগ দায়ের করার আগে সরাসরি আপনার নিয়োগকর্তার সাথে সমাধান করার চেষ্টা করুন",
  my: "တိုင်ကြားခြင်းမပြုမီ အလုပ်ရှင်နှင့် တိုက်ရိုက်ဖြေရှင်းရန် ကြိုးစားပါ",
  mn: "Гомдол гаргахаасаа өмнө ажил олгогчтойгоо шууд шийдвэрлэхийг хичээгээрэй",
  lo: "ພະຍາຍາມແກ້ໄຂບັນຫາກັບນາຍຈ້າງຂອງທ່ານໂດຍກົງກ່ອນທີ່ຈະຍື່ນຄຳຮ້ອງທຸກ",
  tet: "Koko rezolve diretamente ho imi-nia empregadór antes halo keixa",
  ne: "गुनासो गर्नु अघि, आफ्नो रोजगारदातासँग सिधै समाधान गर्ने प्रयास गर्नुहोस्",
  zh: '在申诉前先尝试与雇主直接沟通解决',
  vi: 'Thử giải quyết trực tiếp với chủ trước khi khiếu nại',
  uz: "Ariza topshirishdan oldin ish beruvchingiz bilan bevosita hal qilishga harakat qiling",
);
const _fileOptionTitle = L10nText(
  ko: '📄 진정서 작성 계속하기',
  en: '📄 Continue to the complaint form',
  tr: "📄 Şikayet formuna devam et",
  tg: "📄 Ба варақаи шикоят идома диҳед",
  fil: "📄 Magpatuloy sa form ng reklamo",
  ur: "📄 شکایت فارم پر جاری رکھیں",
  th: "📄 ดำเนินการต่อที่แบบฟอร์มร้องเรียน",
  ky: "📄 Арыз формасын толтурууну улантуу",
  km: "📄 បន្តទៅទម្រង់ពាក្យបណ្តឹង",
  id: "📄 Lanjutkan ke formulir keluhan",
  si: "📄 පැමිණිලි පෝරමය වෙත යන්න",
  bn: "📄 অভিযোগ ফর্মের সাথে চালিয়ে যান",
  my: "📄 တိုင်ကြားစာပုံစံကို ဆက်လုပ်ပါ",
  mn: "📄 Гомдлын маягтыг үргэлжлүүлэх",
  lo: "📄 ສືບຕໍ່ໄປທີ່ແບບຟອມຄຳຮ້ອງທຸກ",
  tet: "📄 Kontinua ba formuláriu keixa",
  ne: "📄 गुनासो फारममा अगाडि बढ्नुहोस्",
  zh: '📄 继续填写申诉书',
  vi: '📄 Tiếp tục viết đơn khiếu nại',
  uz: "📄 Shikoyat shakliga oʻtish",
);
const _fileOptionSubtitle = L10nText(
  ko: '대화로 해결이 어려울 때 공식 서식을 채웁니다',
  en: "If talking doesn't work, fill in the official form",
  tr: "Konuşmak işe yaramazsa, resmi formu doldurun",
  tg: "Агар сӯҳбат кардан кор накунад, варақаи расмиро пур кунед",
  fil: "Kung hindi gumana ang pakikipag-usap, punan ang opisyal na form",
  ur: "اگر بات کرنے سے کام نہ بنے تو سرکاری فارم پُر کریں۔",
  th: "หากการพูดคุยไม่เป็นผล ให้กรอกแบบฟอร์มอย่างเป็นทางการ",
  ky: "Эгер сүйлөшүү натыйжа бербесе, расмий форманы толтуруңуз",
  km: "ប្រសិនបើការនិយាយមិនបានផល សូមបំពេញទម្រង់បែបបទផ្លូវការ",
  id: "Jika berbicara tidak berhasil, isi formulir resmi",
  si: "කතා කිරීමෙන් පලක් නොවන්නේ නම්, නිල පෝරමය පුරවන්න",
  bn: "যদি কথা বলে কাজ না হয়, তাহলে আনুষ্ঠানিক ফর্মটি পূরণ করুন",
  my: "စကားပြောဆိုခြင်း အဆင်မပြေပါက တရားဝင်ပုံစံကို ဖြည့်ပါ",
  mn: "Хэрэв ярилцах нь үр дүнгүй бол албан ёсны маягтыг бөглөнө үү",
  lo: "ຖ້າການສົນທະນາບໍ່ໄດ້ຜົນ, ໃຫ້ຕື່ມແບບຟອມທາງການ",
  tet: "Se koʼalia la funsiona, preenche formuláriu ofisiál",
  ne: "यदि कुरा गर्दा काम लागेन भने, आधिकारिक फारम भर्नुहोस्",
  zh: '若沟通无效，可填写官方表格',
  vi: 'Nếu nói chuyện không hiệu quả, hãy điền mẫu chính thức',
  uz: "Agar gaplashish ish bermasa, rasmiy shaklni toʻldiring",
);
const _copyLabel = L10nText(
  ko: '📋 문구 복사하기',
  en: '📋 Copy text',
  tr: "📋 Metni kopyala",
  tg: "📋 Матнро нусхабардорӣ кунед",
  fil: "📋 Kopyahin ang teksto",
  ur: "📋 متن کاپی کریں",
  th: "📋 คัดลอกข้อความ",
  ky: "📋 Текстти көчүрүү",
  km: "📋 ចម្លងអត្ថបទ",
  id: "📋 Salin teks",
  si: "📋 පෙළ පිටපත් කරන්න",
  bn: "📋 লেখাটি কপি করুন",
  my: "📋 စာသားကို ကူးယူပါ",
  mn: "📋 Текстийг хуулах",
  lo: "📋 ສຳເນົາຂໍ້ຄວາມ",
  tet: "📋 Kopia testu",
  ne: "📋 पाठ प्रतिलिपि गर्नुहोस्",
  zh: '📋 复制文本',
  vi: '📋 Sao chép',
  uz: "📋 Matnni nusxalash",
);
const _copiedLabel = L10nText(
  ko: '복사했습니다',
  en: 'Copied',
  tr: "Kopyalandı",
  tg: "Нусхабардорӣ шуд",
  fil: "Nakopya",
  ur: "کاپی ہو گیا",
  th: "คัดลอกแล้ว",
  ky: "Көчүрүлдү",
  km: "បានចម្លង",
  id: "Tersalin",
  si: "පිටපත් කරන ලදී",
  bn: "কপি করা হয়েছে",
  my: "ကူးယူပြီးပါပြီ",
  mn: "Хуулсан",
  lo: "ສຳເນົາແລ້ວ",
  tet: "Kopiadu",
  ne: "प्रतिलिपि गरियो",
  zh: '已复制',
  vi: 'Đã sao chép',
  uz: "Nusxa olindi",
);
const _usageInfoLabel = L10nText(
  ko: '💡 이용 안내',
  en: '💡 How to use this',
  tr: "💡 Nasıl kullanılır",
  tg: "💡 Чӣ тавр истифода бурда мешавад",
  fil: "💡 Paano gamitin",
  ur: "💡 کیسے استعمال کریں",
  th: "💡 วิธีใช้งาน",
  ky: "💡 Кантип колдонуу керек",
  km: "💡 របៀបប្រើប្រាស់",
  id: "💡 Cara menggunakan",
  si: "💡 භාවිතා කරන ආකාරය",
  bn: "💡 কিভাবে ব্যবহার করবেন",
  my: "💡 အသုံးပြုနည်း",
  mn: "💡 Хэрхэн ашиглах вэ",
  lo: "💡 ວິທີໃຊ້",
  tet: "💡 Oinsá uza",
  ne: "💡 कसरी प्रयोग गर्ने",
  zh: '💡 使用说明',
  vi: '💡 Hướng dẫn sử dụng',
  uz: "💡 Qanday foydalanish kerak",
);
const _usageInfoBody = L10nText(
  ko: '아래 문장을 복사해 사장님이나 담당자에게 카카오톡·문자로 보내보세요.',
  en: 'Copy the message below and send it to your employer.',
  tr: "Aşağıdaki mesajı kopyalayıp işvereninize gönderin.",
  tg: "Паёми зеринро нусхабардорӣ кунед ва ба корфармои худ фиристед.",
  fil: "Kopyahin ang mensahe sa ibaba at ipadala sa iyong employer.",
  ur: "نیچے دیے گئے پیغام کو کاپی کریں اور اپنے آجر کو بھیجیں۔",
  th: "คัดลอกข้อความด้านล่างแล้วส่งให้นายจ้างของคุณ",
  ky: "Төмөнкү билдирүүнү көчүрүп, жумуш берүүчүңүзгө жөнөтүңүз.",
  km: "ចម្លងសារខាងក្រោម ហើយផ្ញើទៅនិយោជករបស់អ្នក។",
  id: "Salin pesan di bawah ini dan kirimkan ke atasan Anda.",
  si: "පහත පණිවිඩය පිටපත් කර ඔබේ සේවායෝජකයාට යවන්න.",
  bn: "নিচের বার্তাটি কপি করে আপনার নিয়োগকর্তাকে পাঠান।",
  my: "အောက်ပါမက်ဆေ့ချ်ကို ကူးယူပြီး သင့်အလုပ်ရှင်ထံ ပေးပို့ပါ။",
  mn: "Доорх мессежийг хуулж, ажил олгогчдоо илгээнэ үү.",
  lo: "ສຳເນົາຂໍ້ຄວາມຂ້າງລຸ່ມນີ້ ແລະສົ່ງໃຫ້ນາຍຈ້າງຂອງທ່ານ.",
  tet: "Kopia mensajen iha kraik no haruka ba imi-nia empregadór.",
  ne: "तलको सन्देश प्रतिलिपि गरी आफ्नो रोजगारदातालाई पठाउनुहोस्।",
  zh: '复制以下内容发送给雇主或负责人。',
  vi: 'Sao chép câu bên dưới và gửi cho chủ.',
  uz: "Quyidagi xabarni nusxalang va ish beruvchingizga yuboring.",
);
const _viewTranslatedLabel = L10nText(
  ko: '🌐 내 언어로 보기',
  en: '🌐 View in my language',
  tr: "🌐 Kendi dilimde görüntüle",
  tg: "🌐 Бо забони худ бубинед",
  fil: "🌐 Tingnan sa aking wika",
  ur: "🌐 اپنی زبان میں دیکھیں",
  th: "🌐 ดูในภาษาของฉัน",
  ky: "🌐 Өз тилимде көрүү",
  km: "🌐 មើលជាភាសារបស់ខ្ញុំ",
  id: "🌐 Lihat dalam bahasa saya",
  si: "🌐 මගේ භාෂාවෙන් බලන්න",
  bn: "🌐 আমার নিজের ভাষায় দেখুন",
  my: "🌐 ကျွန်ုပ်၏ဘာသာစကားဖြင့် ကြည့်ရှုပါ",
  mn: "🌐 Өөрийн хэлээр харах",
  lo: "🌐 ເບິ່ງໃນພາສາຂອງຂ້ອຍ",
  tet: "🌐 Haree iha haʼu-nia lian rasik",
  ne: "🌐 मेरो आफ्नै भाषामा हेर्नुहोस्",
  zh: '🌐 查看我的语言版',
  vi: '🌐 Xem bằng tiếng của tôi',
  uz: "🌐 Oʻz tilimda koʻrish",
);
const _viewKoreanLabel = L10nText(
  ko: '🇰🇷 한국어로 보기',
  en: '🇰🇷 View in Korean',
  tr: "🇰🇷 Korece görüntüle",
  tg: "🇰🇷 Бо забони кореягӣ бубинед",
  fil: "🇰🇷 Tingnan sa Korean",
  ur: "🇰🇷 کوریائی میں دیکھیں",
  th: "🇰🇷 ดูเป็นภาษาเกาหลี",
  ky: "🇰🇷 Корей тилинде көрүү",
  km: "🇰🇷 មើលជាភាសាកូរ៉េ",
  id: "🇰🇷 Lihat dalam bahasa Korea",
  si: "🇰🇷 කොරියානු භාෂාවෙන් බලන්න",
  bn: "🇰🇷 কোরিয়ান ভাষায় দেখুন",
  my: "🇰🇷 ကိုရီးယားဘာသာဖြင့် ကြည့်ရှုပါ",
  mn: "🇰🇷 Солонгос хэлээр харах",
  lo: "🇰🇷 ເບິ່ງເປັນພາສາເກົາຫຼີ",
  tet: "🇰🇷 Haree iha lian Koreanu",
  ne: "🇰🇷 कोरियनमा हेर्नुहोस्",
  zh: '🇰🇷 查看韩语版',
  vi: '🇰🇷 Xem bằng tiếng Hàn',
  uz: "🇰🇷 Koreys tilida koʻrish",
);
const _amtPlaceholder = L10nText(
  ko: '(임금계산기로 먼저 확인해주세요)',
  en: '(please check with the wage calculator first)',
  tr: "(lütfen önce ücret hesaplayıcı ile kontrol edin)",
  tg: "(лутфан аввал бо ҳисобкунаки музди меҳнат тафтиш кунед)",
  fil: "(pakisuri muna gamit ang calculator ng sahod)",
  ur: "(براہ کرم پہلے اجرت کیلکولیٹر سے چیک کریں)",
  th: "(โปรดตรวจสอบกับเครื่องคำนวณค่าจ้างก่อน)",
  ky: "(алгач эмгек акы калькулятору менен текшерип көрүңүз)",
  km: "(សូមពិនិត្យជាមួយម៉ាស៊ីនគិតប្រាក់ឈ្នួលជាមុនសិន)",
  id: "(mohon periksa dengan kalkulator upah terlebih dahulu)",
  si: "(කරුණාකර වැටුප් කැල්කියුලේටරය සමඟ පළමුව පරීක්ෂා කරන්න)",
  bn: "(দয়া করে প্রথমে বেতন ক্যালকুলেটর দিয়ে পরীক্ষা করুন)",
  my: "(ကျေးဇူးပြု၍ လုပ်ခတွက်ချက်စက်ဖြင့် ဦးစွာစစ်ဆေးပါ)",
  mn: "(эхийг нь цалингийн тооцоолуураар шалгана уу)",
  lo: "(ກະລຸນາກວດສອບກັບເຄື່ອງຄິດໄລ່ຄ່າຈ້າງກ່ອນ)",
  tet: "(favór ida, verifika uluk ho kalkuladór saláriu)",
  ne: "(कृपया पहिले तलब क्यालकुलेटरबाट जाँच गर्नुहोस्)",
  zh: '（请先用工资计算器确认）',
  vi: '(hãy kiểm tra bằng máy tính lương trước)',
  uz: "(iltimos, avval ish haqi kalkulyatori bilan tekshiring)",
);
const _dontSignTitle = L10nText(
  ko: '⚠ 돈을 받기 전에는 서명하지 마세요',
  en: '⚠ Do not sign anything before you are paid',
  tr: "⚠ Ödeme yapılmadan önce hiçbir şey imzalamayın",
  tg: "⚠ Пеш аз пардохт чизеро имзо накунед",
  fil: "⚠ Huwag pumirma ng anuman bago mabayaran",
  ur: "⚠ ادائیگی سے پہلے کچھ بھی دستخط نہ کریں",
  th: "⚠ อย่าเซ็นชื่อใด ๆ ก่อนที่จะได้รับเงิน",
  ky: "⚠ Төлөм жүргүзүлгөнгө чейин эч нерсеге кол койбоңуз",
  km: "⚠ កុំចុះហត្ថលេខាលើអ្វីទាំងអស់មុនពេលទទួលបានការទូទាត់",
  id: "⚠ Jangan menandatangani apa pun sebelum pembayaran dilakukan",
  si: "⚠ ගෙවීම් කිරීමට පෙර කිසිවක් අත්සන් නොකරන්න",
  bn: "⚠ অর্থপ্রদানের আগে কিছুতে স্বাক্ষর করবেন না",
  my: "⚠ ငွေမချေမီ မည်သည့်အရာကိုမျှ လက်မှတ်မထိုးပါနှင့်",
  mn: "⚠ Төлбөр хийгдэхээс өмнө юунд ч гарын үсэг зурахгүй байх",
  lo: "⚠ ຢ່າເຊັນຫຍັງກ່ອນທີ່ຈະໄດ້ຮັບການຊຳລະເງິນ",
  tet: "⚠ Keta asina buat ida antes pagamentu",
  ne: "⚠ भुक्तानी नभएसम्म केही पनि हस्ताक्षर नगर्नुहोस्",
  zh: '⚠ 收到钱之前不要签字',
  vi: '⚠ Đừng ký gì trước khi nhận tiền',
  uz: "⚠ Pul toʻlanmasdan oldin hech narsaga imzo chekmang",
);
const _dontSignBody = L10nText(
  ko: "통장으로 실제 입금받기 전에는 '합의서'나 '진정 취하서'에 절대 서명하지 마세요.",
  en: 'Never sign a settlement or withdrawal letter before the money actually arrives.',
  tr: "Para gerçekten elinize geçmeden önce asla bir uzlaşma veya feragatname imzalamayın.",
  tg: "Ҳеҷ гоҳ созишнома ё даст кашиданро имзо накунед, то даме ки пул воқеан ба дасти шумо нарасад.",
  fil:
      "Huwag kailanman pumirma ng kasunduan o waiver bago mo matanggap ang pera.",
  ur: "جب تک رقم واقعی آپ کے ہاتھ میں نہ آ جائے، کبھی بھی کوئی سمجھوتہ یا دستبرداری پر دستخط نہ کریں۔",
  th: "อย่าเซ็นข้อตกลงหรือการสละสิทธิ์ใด ๆ ก่อนที่คุณจะได้รับเงินจริง ๆ",
  ky: "Акча колуңузга тиймейинче, эч качан макулдашууга же баш тартууга кол койбоңуз.",
  km: "កុំចុះហត្ថលេខាលើកិច្ចព្រមព្រៀង ឬការលះបង់សិទ្ធិណាមួយ រហូតទាល់តែអ្នកពិតជាទទួលបានប្រាក់នៅក្នុងដៃរបស់អ្នក។",
  id: "Jangan pernah menandatangani penyelesaian atau pengabaian sebelum uang benar-benar ada di tangan Anda.",
  si: "මුදල් ඇත්ත වශයෙන්ම ඔබේ අතට ලැබෙන තුරු කිසිවිටෙක සමථයකට හෝ අත්හැරීමකට අත්සන් නොකරන්න.",
  bn: "আপনার হাতে টাকা না আসা পর্যন্ত কোনো নিষ্পত্তি বা মওকুফনামায় স্বাক্ষর করবেন না।",
  my: "သင့်လက်ထဲသို့ ငွေမရောက်မချင်း ပြေလည်မှု သို့မဟုတ် စွန့်လွှတ်ကြောင်း မည်သည့်အခါမျှ လက်မှတ်မထိုးပါနှင့်။",
  mn: "Мөнгө таны гарт орохоос өмнө хэзээ ч тохиролцоо эсвэл татгалзлын бичигт гарын үсэг зурахгүй байх.",
  lo: "ຢ່າເຊັນຂໍ້ຕົກລົງ ຫຼື ການຍົກເວັ້ນໃດໆ ກ່ອນທີ່ທ່ານຈະໄດ້ຮັບເງິນຕົວຈິງ.",
  tet:
      "Keta asina akordu ka renúnsia ida antes osan neʼe loos-loos iha imi-nia liman.",
  ne: "पैसा वास्तवमा तपाईंको हातमा नआएसम्म कहिल्यै पनि सम्झौता वा माफीनामामा हस्ताक्षर नगर्नुहोस्।",
  zh: '在钱实际入账之前，切勿签署"和解书"或"撤诉书"。',
  vi: "Tuyệt đối đừng ký 'thỏa thuận' hay 'đơn rút' trước khi tiền thực sự vào tài khoản.",
  uz: "Pul kelib tushmasdan oldin hech qachon hisob-kitob yoki pul yechib olish xatiga imzo chekmang.",
);

/// 임금체불 내비게이터 2단계 "체불액을 확인하고 방법을 고르세요"의 본문.
/// html_files/임금체불네비게이터_완성본.html의 blocks:[calcbtns, report,
/// aireason, options2]를 그대로 옮겼다 — 계산 입력 자체는 이 화면에 없고,
/// 이미 앱에 있는 정밀 5단계 계산기(WageCalculatorScreen)를 새 화면으로 열어
/// 결과만 콜백으로 돌려받는다("이 화면과는 별개의 로컬 상태" 원칙 유지).
class WageCalcSection extends StatelessWidget {
  const WageCalcSection({
    super.key,
    required this.scratch,
    required this.lang,
    required this.onAdvance,
  });

  final WageCalcScratchController scratch;
  final AppLanguage lang;
  final VoidCallback onAdvance;

  String _gapKind(WageCalcResult r) {
    final gap = r.gapValue;
    if (gap.abs() < 10000) return 'zero';
    return gap > 0 ? 'pos' : 'neg';
  }

  void _runPreciseCalculator(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WageCalculatorScreen(
          onUseResult: (input) {
            scratch.update((_) => input);
            scratch.calculate();
          },
        ),
      ),
    );
  }

  void _loadCalcData(BuildContext context) {
    final message = scratch.loaded
        ? _calcAlreadyLoadedToast.of(lang)
        : _calcNotYetAvailableToast.of(lang);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _openAiReasonPopup(BuildContext context) {
    final result = scratch.result;
    if (result == null) return;
    final text = explainGap(scratch.input, result, lang);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _aiReasonTitle.of(lang),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: RichNote(
                    text,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                      height: 1.7,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openMessageTemplate(BuildContext context) {
    final result = scratch.result;
    final hasAmt = result != null && _gapKind(result) == 'pos';
    final gapText = hasAmt
        ? formatWon(result.gapValue.abs(), lang)
        : _amtPlaceholder.of(lang);
    // 수신자(사장님)는 한국어 사용자이므로 기본 노출은 항상 한국어다 — 앱
    // 언어 설정과 무관하게. "내 언어로 보기"는 보내기 전 뜻을 확인하려는
    // 이용자 본인을 위한 토글일 뿐, 기본값을 바꾸지 않는다.
    final messageKo =
        '사장님, 안녕하세요. 다름이 아니라 그동안 지급해주신 급여 내역을 법정 기준으로 계산해보니 약 $gapText의 차액이 확인되어 연락드렸습니다.\n\n혹시 계산 과정에서 누락이나 착오가 있으셨는지 바쁘시겠지만 한번 확인 부탁드립니다. 감사합니다.';
    final messageTranslated = switch (lang) {
      AppLanguage.ko => messageKo,
      AppLanguage.uz =>
        "Salom, men oʻz maoshimni qonuniy standart boʻyicha hisobladim va taxminan $gapText miqdorida farq topdim. Iltimos, imkon topganingizda biron bir xato yoki kamchilikni tekshira olasizmi? Rahmat.",
      AppLanguage.en =>
        'Hello, I calculated my pay against the legal standard and found a gap of about $gapText. Could you please check for any error or omission when you have a moment? Thank you.',
      AppLanguage.tr =>
        "Merhaba, ücretimi yasal standartlara göre hesapladım ve yaklaşık $gapText kadar bir fark buldum. Müsait olduğunuzda herhangi bir hata veya eksiklik olup olmadığını kontrol edebilir misiniz? Teşekkür ederim.",
      AppLanguage.tg =>
        "Салом, ман музди меҳнати худро мувофиқи стандартҳои қонунӣ ҳисоб кардам ва тақрибан $gapText фарқият ёфтам. Оё шумо метавонед тафтиш кунед, ки оё ягон хато ё камбудӣ вуҷуд дорад, вақте ки шумо вақт доред? Ташаккур.",
      AppLanguage.fil =>
        "Kumusta, kinalkula ko ang aking sahod ayon sa legal na pamantayan at nakita ko ang pagkakaiba na humigit-kumulang $gapText. Maaari mo bang suriin kung may anumang pagkakamali o kakulangan kapag mayroon kang oras? Salamat.",
      AppLanguage.ur =>
        "ہیلو، میں نے اپنی اجرت کا حساب قانونی معیارات کے مطابق لگایا ہے اور مجھے تقریباً $gapText کا فرق ملا ہے۔ کیا آپ دستیاب ہونے پر کسی غلطی یا کمی کی جانچ کر سکتے ہیں؟ شکریہ۔",
      AppLanguage.th =>
        "สวัสดีครับ/ค่ะ ผม/ดิฉันได้คำนวณค่าจ้างตามมาตรฐานทางกฎหมายและพบว่ามีความแตกต่างประมาณ $gapText คุณช่วยตรวจสอบได้ไหมว่ามีข้อผิดพลาดหรือข้อบกพร่องใด ๆ หรือไม่เมื่อคุณสะดวก ขอบคุณครับ/ค่ะ",
      AppLanguage.ky =>
        "Саламатсызбы, мен эмгек акымды мыйзамдуу стандарттарга ылайык эсептеп чыктым жана болжол менен $gapText айырмачылык таптым. Мүмкүнчүлүгүңүз болгондо, каталар же кемчиликтер бар-жогун текшерип коё аласызбы? Рахмат.",
      AppLanguage.km =>
        "ជំរាបសួរ ខ្ញុំបានគណនាប្រាក់ឈ្នួលរបស់ខ្ញុំតាមស្តង់ដារច្បាប់ ហើយបានរកឃើញភាពខុសគ្នាប្រហែល $gapText ។ តើអ្នកអាចពិនិត្យមើលថាតើមានកំហុស ឬការខ្វះខាតណាមួយនៅពេលអ្នកទំនេរបានទេ? អរគុណ។",
      AppLanguage.id =>
        "Halo, saya telah menghitung upah saya berdasarkan standar hukum dan menemukan perbedaan sekitar $gapText. Bisakah Anda memeriksa apakah ada kesalahan atau kelalaian saat Anda senggang? Terima kasih.",
      AppLanguage.si =>
        "ආයුබෝවන්, මම නීතිමය ප්‍රමිතීන්ට අනුව මගේ වැටුප ගණනය කළ අතර, KRW $gapText ක පමණ වෙනසක් සොයා ගත්තා. ඔබ නිදහස් වූ විට කිසියම් දෝෂයක් හෝ අඩුපාඩුවක් තිබේදැයි පරීක්ෂා කළ හැකිද? ස්තූතියි.",
      AppLanguage.bn =>
        "নমস্কার, আমি আইনি মান অনুযায়ী আমার বেতন গণনা করেছি এবং প্রায় $gapText এর একটি পার্থক্য পেয়েছি। আপনি যখন উপলব্ধ থাকবেন তখন কোনো ত্রুটি বা বাদ পড়া আছে কিনা তা পরীক্ষা করতে পারবেন কি? ধন্যবাদ।",
      AppLanguage.my =>
        "မင်္ဂလာပါ၊ ကျွန်ုပ်၏လုပ်ခကို တရားဝင်စံနှုန်းများအတိုင်း တွက်ချက်ကြည့်ရာ ခန့်မှန်းခြေအားဖြင့် $gapText ခန့် ကွာခြားမှုရှိသည်ကို တွေ့ရှိရပါသည်။ အဆင်ပြေသည့်အခါ အမှားအယွင်း သို့မဟုတ် လိုအပ်ချက်များရှိမရှိ စစ်ဆေးပေးနိုင်မလား။ ကျေးဇူးတင်ပါသည်။",
      AppLanguage.mn =>
        "Сайн байна уу, би цалингаа хуулийн стандартаар тооцоход ойролцоогоор $gapText-ийн зөрүү гарсан байна. Та боломжтой үедээ алдаа, дутагдал байгаа эсэхийг шалгаж өгнө үү? Баярлалаа.",
      AppLanguage.lo =>
        "ສະບາຍດີ, ຂ້າພະເຈົ້າໄດ້ຄິດໄລ່ຄ່າຈ້າງຂອງຂ້າພະເຈົ້າຕາມມາດຕະຖານທາງກົດໝາຍ ແລະ ພົບຄວາມແຕກຕ່າງປະມານ $gapText. ທ່ານສາມາດກວດສອບໄດ້ບໍ່ວ່າມີຂໍ້ຜິດພາດ ຫຼື ຂໍ້ບົກພ່ອງໃດໆ ບໍ ເມື່ອທ່ານວ່າງ? ຂອບໃຈ.",
      AppLanguage.tet =>
        "Olá, haʼu kalkula haʼu-nia saláriu tuir padraun legál no hetan diferensa besik $gapText. Bainhira imi livre, bele verifika se iha erru ka falta ruma? Obrigadu.",
      AppLanguage.ne =>
        "नमस्ते, मैले मेरो तलब कानूनी मापदण्ड अनुसार गणना गरेको छु र लगभग $gapText को भिन्नता पाएको छु। तपाईं उपलब्ध हुँदा कुनै त्रुटि वा कमी छ कि छैन भनेर जाँच गर्न सक्नुहुन्छ? धन्यवाद।",
      AppLanguage.zh =>
        '老板您好，我按法定标准核算了工资，发现约有$gapText的差额。方便的话请您确认一下是否有遗漏或误差，谢谢。',
      AppLanguage.vi =>
        'Chào sếp, tôi đã tính lương theo chuẩn luật định và thấy chênh lệch khoảng $gapText. Sếp xem giúp có sai sót gì không ạ. Cảm ơn sếp.',
    };
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      // 이용안내·번역토글·서명주의 문구가 늘어나며 기본 바텀시트 높이를 넘을 수
      // 있다 — isScrollControlled 없이는 넘치는 부분이 히트테스트되지 않는다.
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        var showingTranslated = false;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final currentMessage = showingTranslated
                ? messageTranslated
                : messageKo;
            return Padding(
              padding: EdgeInsets.fromLTRB(
                18,
                16,
                18,
                24 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _talkOptionTitle.of(lang),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _usageInfoLabel.of(lang),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _usageInfoBody.of(lang),
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        currentMessage,
                        style: const TextStyle(fontSize: 12, height: 1.6),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              await Clipboard.setData(
                                ClipboardData(text: currentMessage),
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(_copiedLabel.of(lang)),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              }
                            },
                            child: Text(_copyLabel.of(lang)),
                          ),
                        ),
                        if (lang != AppLanguage.ko) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => setSheetState(
                                () => showingTranslated = !showingTranslated,
                              ),
                              child: Text(
                                (showingTranslated
                                        ? _viewKoreanLabel
                                        : _viewTranslatedLabel)
                                    .of(lang),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),
                    NoticeBox(
                      tone: NoticeTone.amber,
                      title: _dontSignTitle.of(lang),
                      body: _dontSignBody.of(lang),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scratch,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _CalcButton(
                    icon: '🧮',
                    title: _calcRunTitle.of(lang),
                    subtitle: _calcRunSubtitle.of(lang),
                    tone: _CalcButtonTone.primary,
                    onTap: () => _runPreciseCalculator(context),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _CalcButton(
                    icon: '📋',
                    title: _calcLoadTitle.of(lang),
                    subtitle: _calcLoadSubtitle.of(lang),
                    tone: scratch.loaded
                        ? _CalcButtonTone.loaded
                        : _CalcButtonTone.neutral,
                    onTap: () => _loadCalcData(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 11),
            if (scratch.loaded)
              _buildReportCard(lang, scratch.result!)
            else
              _buildEmptyReportCard(),
            const SizedBox(height: 9),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: scratch.loaded
                    ? () => _openAiReasonPopup(context)
                    : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0D47A1),
                  disabledForegroundColor: AppColors.textMuted,
                  side: BorderSide(
                    color: scratch.loaded
                        ? const Color(0xFF90CAF9)
                        : AppColors.border,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                ),
                child: Text(
                  (scratch.loaded && _gapKind(scratch.result!) == 'pos'
                          ? _aiReasonLabelPos
                          : _aiReasonLabelOther)
                      .of(lang),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 14),
            _bigOption(
              icon: '💬',
              title: _talkOptionTitle.of(lang),
              subtitle: _talkOptionSubtitle.of(lang),
              onTap: () => _openMessageTemplate(context),
            ),
            const SizedBox(height: 8),
            _bigOption(
              icon: '📄',
              title: _fileOptionTitle.of(lang),
              subtitle: _fileOptionSubtitle.of(lang),
              onTap: onAdvance,
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyReportCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Text(
        _reportEmptyText.of(lang),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 11.5,
          color: AppColors.textMuted,
          height: 1.7,
        ),
      ),
    );
  }

  /// 1만원 미만 차이는 반올림·계산 오차로 보고 일치("zero")로 처리한다.
  /// 실입금액이 계산값보다 많으면 체불이 아니라 계산 방식 차이("neg")다.
  Widget _buildReportCard(AppLanguage lang, WageCalcResult r) {
    final gap = r.gapValue;
    final kind = _gapKind(r);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: const Color(0xFF0D47A1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _reportRow(_expectedLabel.of(lang), formatWon(r.net ?? 0, lang)),
              _reportRow(
                _receivedRowLabel.of(lang),
                formatWon(r.received, lang),
              ),
              const Divider(color: Colors.white24, height: 18),
              if (kind == 'pos')
                _reportRow(
                  _gapLabel.of(lang),
                  formatWon(gap, lang),
                  emphasize: true,
                )
              else if (kind == 'neg')
                _reportRow(
                  _calcDiffLabel.of(lang),
                  formatWon(gap.abs(), lang),
                  emphasize: false,
                )
              else
                _reportRow(_matchLabel.of(lang), '', emphasize: false),
            ],
          ),
        ),
        const SizedBox(height: 9),
        NoticeBox(
          tone: NoticeTone.amber,
          title: _refEstimateTitle.of(lang),
          body: _refEstimateBody.of(lang),
        ),
      ],
    );
  }

  Widget _reportRow(String label, String value, {bool emphasize = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: emphasize ? 12.5 : 11.5,
                color: const Color(0xFF90CAF9),
              ),
            ),
          ),
          if (value.isNotEmpty)
            Text(
              value,
              style: TextStyle(
                fontSize: emphasize ? 15 : 13,
                fontWeight: FontWeight.w800,
                color: emphasize ? const Color(0xFF90CAF9) : Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _bigOption({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
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

enum _CalcButtonTone { primary, loaded, neutral }

/// calcbtns 블록의 버튼 하나. 정밀 계산기 실행(파란 강조)과 데이터 불러오기
/// (이미 불러왔으면 청록 강조)를 나란히 보여준다.
class _CalcButton extends StatelessWidget {
  const _CalcButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tone,
    required this.onTap,
  });

  final String icon;
  final String title;
  final String subtitle;
  final _CalcButtonTone tone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (bg, border) = switch (tone) {
      _CalcButtonTone.primary => (
        const Color(0xFFE3F2FD),
        const Color(0xFF90CAF9),
      ),
      _CalcButtonTone.loaded => (
        const Color(0xFFE8F5E9),
        const Color(0xFFA5D6A7),
      ),
      _CalcButtonTone.neutral => (Colors.white, AppColors.border),
    };
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 9.5,
                color: AppColors.textMuted,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
