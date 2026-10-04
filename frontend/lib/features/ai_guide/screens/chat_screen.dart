import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../core/api_client.dart';
import '../../../core/api_config.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';
import '../../worklog/screens/accident_navigator_screen.dart';
import '../../worklog/screens/wage_navigator_screen.dart';
import '../models/ai_response.dart';
import '../models/chat_message.dart';
import '../services/chat_api_service.dart';
import '../widgets/ai_response_card.dart';

class _ChatStrings {
  _ChatStrings._();

  static const title = L10nText(
    ko: 'AI 가이드',
    en: 'AI Guide',
    tr: "Yapay Zeka Rehberi",
    tg: "Дастури зеҳни сунъӣ",
    fil: "Gabay ng AI",
    ur: "مصنوعی ذہانت کی رہنمائی",
    th: "คู่มือ AI",
    ky: "Жасалма интеллект колдонмосу",
    km: "ការណែនាំអំពីបញ្ញាសិប្បនិម្មិត",
    id: "Panduan AI",
    si: "AI මාර්ගෝපදේශය",
    bn: "এআই গাইড",
    my: "AI လမ်းညွှန်",
    mn: "Хиймэл оюун ухааны гарын авлага",
    lo: "ຄູ່ມື AI",
    tet: "Guia Intelijénsia Artifisiál",
    ne: "एआई गाइड",
    zh: 'AI引导',
    vi: 'Trợ lý AI',
    uz: "AI Yordamchi",
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
  static const emptyTitle = L10nText(
    ko: '무엇이든 물어보세요',
    en: 'Ask me anything',
    tr: "Bana her şeyi sor",
    tg: "Ҳама чизро аз ман пурсед",
    fil: "Tanungin mo ako ng kahit ano",
    ur: "مجھ سے کچھ بھی پوچھیں",
    th: "ถามฉันได้ทุกเรื่อง",
    ky: "Мага баарын сураңыз",
    km: "សួរខ្ញុំអ្វីក៏បាន",
    id: "Tanyakan apa saja kepada saya",
    si: "ඕනෑම දෙයක් මාගෙන් අසන්න",
    bn: "আমাকে যেকোনো কিছু জিজ্ঞাসা করুন",
    my: "ကျွန်ုပ်ကို မည်သည့်အရာမဆို မေးမြန်းပါ",
    mn: "Надаас юу ч асуу",
    lo: "ຖາມຂ້ອຍໄດ້ທຸກຢ່າງ",
    tet: "Husu ha’u buat hotu",
    ne: "मलाई जे पनि सोध्नुहोस्",
    zh: '请随时提问',
    vi: 'Hỏi bất cứ điều gì',
    uz: "Mendan istalgan narsani soʻrang",
  );
  static const emptySubtitle = L10nText(
    ko: '임금·체불, 산업재해, 근로계약서 등 노동 관련 궁금한 점을 편하게 물어보세요.',
    en: 'Feel free to ask about wages, unpaid pay, workplace injuries, employment contracts, and other labor topics.',
    tr: "Ücretler, ödenmemiş maaşlar, iş kazaları, iş sözleşmeleri ve diğer işçilik konuları hakkında soru sormaktan çekinmeyin.",
    tg: "Дар бораи музди меҳнат, маоши пардохтнашуда, садамаҳои корӣ, шартномаҳои меҳнатӣ ва дигар масъалаҳои меҳнатӣ савол доданро дареғ надоред.",
    fil:
        "Huwag mag-atubiling magtanong tungkol sa sahod, hindi nabayarang sahod, aksidente sa trabaho, kontrata sa trabaho, at iba pang isyu sa paggawa.",
    ur: "اجرت، غیر ادا شدہ تنخواہ، کام کے حادثات، ملازمت کے معاہدوں اور دیگر مزدوروں کے مسائل کے بارے میں سوالات پوچھنے میں ہچکچاہٹ محسوس نہ کریں۔",
    th: "โปรดสอบถามเกี่ยวกับค่าจ้าง ค่าจ้างค้างชำระ อุบัติเหตุจากการทำงาน สัญญาจ้างงาน และประเด็นด้านแรงงานอื่น ๆ",
    ky: "Эмгек акы, төлөнбөгөн айлыктар, өндүрүштүк кырсыктар, эмгек келишимдери жана башка эмгек маселелери боюнча суроо берүүдөн тартынбаңыз.",
    km: "កុំស្ទាក់ស្ទើរក្នុងការសួរអំពីប្រាក់ឈ្នួល ប្រាក់ខែមិនទាន់បានបង់ គ្រោះថ្នាក់ការងារ កិច្ចសន្យាការងារ និងបញ្ហាការងារផ្សេងទៀត។",
    id: "Jangan ragu untuk bertanya tentang upah, upah yang belum dibayar, kecelakaan kerja, kontrak kerja, dan masalah ketenagakerjaan lainnya.",
    si: "වැටුප්, නොගෙවූ වැටුප්, කාර්මික අනතුරු, රැකියා කොන්ත්‍රාත්තු සහ වෙනත් කම්කරු ගැටළු පිළිබඳව විමසීමට පසුබට නොවන්න.",
    bn: "মজুরি, বকেয়া বেতন, কর্মক্ষেত্রে আঘাত, চাকরির চুক্তি এবং অন্যান্য শ্রম সংক্রান্ত বিষয়ে প্রশ্ন করতে দ্বিধা করবেন না।",
    my: "လုပ်ခလစာ၊ မရရှိသေးသော လုပ်ခလစာ၊ လုပ်ငန်းခွင်ထိခိုက်မှုများ၊ အလုပ်သမားစာချုပ်များနှင့် အခြားအလုပ်သမားရေးရာ ကိစ္စရပ်များအကြောင်း မေးမြန်းရန် မတွန့်ဆုတ်ပါနှင့်။",
    mn: "Цалин хөлс, цалингийн хоцрогдол, ажлын осол, хөдөлмөрийн гэрээ болон бусад хөдөлмөрийн асуудлаар асуулт асуухаас бүү эргэлзээрэй.",
    lo: "ຢ່າລັງເລທີ່ຈະຖາມກ່ຽວກັບຄ່າຈ້າງ, ຄ່າຈ້າງທີ່ຄ້າງຈ່າຍ, ອຸບັດຕິເຫດໃນບ່ອນເຮັດວຽກ, ສັນຍາການຈ້າງງານ, ແລະບັນຫາແຮງງານອື່ນໆ.",
    tet:
        "Keta ta’uk atu husu kona-ba saláriu, saláriu la selu, asidente servisu, kontratu servisu, no kestaun seluk kona-ba traballu.",
    ne: "ज्याला, भुक्तानी नगरिएको तलब, कार्यस्थल दुर्घटना, रोजगार सम्झौता र अन्य श्रम सम्बन्धी मामिलाहरूको बारेमा सोध्न नहिचकिचाउनुहोस्।",
    zh: '关于工资、欠薪、工伤、劳动合同等劳动相关问题，请随时提问。',
    vi: 'Hãy thoải mái hỏi về lương, nợ lương, tai nạn lao động, hợp đồng lao động và các vấn đề lao động khác.',
    uz: "Ish haqi, toʻlanmagan ish haqi, ish joyidagi jarohatlar, mehnat shartnomalari va boshqa mehnat mavzulari haqida bemalol soʻrang.",
  );
  static const inputHint = L10nText(
    ko: '메시지를 입력하세요',
    en: 'Type a message',
    tr: "Bir mesaj yazın",
    tg: "Паём нависед",
    fil: "Sumulat ng mensahe",
    ur: "ایک پیغام لکھیں",
    th: "เขียนข้อความ",
    ky: "Кабар жазыңыз",
    km: "សរសេរសារ",
    id: "Ketik pesan",
    si: "පණිවිඩයක් ලියන්න",
    bn: "একটি বার্তা লিখুন",
    my: "မက်ဆေ့ချ် ရေးပါ",
    mn: "Зурвас бичих",
    lo: "ຂຽນຂໍ້ຄວາມ",
    tet: "Hakerek mensajen ida",
    ne: "एउटा सन्देश लेख्नुहोस्",
    zh: '请输入消息',
    vi: 'Nhập tin nhắn',
    uz: "Xabar yozing",
  );

  /// 첫 화면 추천 질문 — 카드를 누르면 이 문구가 그대로 사용자 메시지로 전송된다.
  /// 화면에 보이는 문구와 전송되는 문구가 같아야 대화 흐름이 자연스럽다.
  static const suggestWage = L10nText(
    ko: '임금체불 진정과정 알려줘',
    en: 'How do I file an unpaid wage complaint?',
    tr: "Ödenmemiş ücret şikayetini nasıl yaparım?",
    tg: "Чӣ тавр шикояти музди пардохтнашударо пешниҳод кунам?",
    fil: "Paano ako maghahain ng reklamo para sa hindi nabayarang sahod?",
    ur: "میں غیر ادا شدہ اجرت کی شکایت کیسے درج کروں؟",
    th: "ฉันจะยื่นเรื่องร้องเรียนค่าจ้างค้างชำระได้อย่างไร",
    ky: "Төлөнбөгөн эмгек акы боюнча арызды кантип жазсам болот?",
    km: "តើខ្ញុំអាចដាក់ពាក្យបណ្ដឹងប្រាក់ឈ្នួលមិនទាន់បានបង់ដោយរបៀបណា?",
    id: "Bagaimana cara mengajukan keluhan upah yang belum dibayar?",
    si: "නොගෙවූ වැටුප් පිළිබඳ පැමිණිල්ලක් කරන්නේ කෙසේද?",
    bn: "আমি কীভাবে বকেয়া বেতনের অভিযোগ দায়ের করব?",
    my: "မရရှိသေးသော လုပ်ခလစာ တိုင်ကြားချက်ကို မည်သို့ပြုလုပ်ရမည်နည်း။",
    mn: "Би цалингийн хоцрогдлын талаар хэрхэн гомдол гаргах вэ?",
    lo: "ຂ້ອຍຈະຮ້ອງຮຽນຄ່າຈ້າງທີ່ຄ້າງຈ່າຍໄດ້ແນວໃດ?",
    tet: "Oinsá mak ha’u bele halo keixa kona-ba saláriu la selu?",
    ne: "मैले भुक्तानी नगरिएको ज्यालाको उजुरी कसरी गर्ने?",
    zh: '欠薪申诉的流程是怎样的？',
    vi: 'Quy trình khiếu nại nợ lương như thế nào?',
    uz: "Toʻlanmagan ish haqi boʻyicha shikoyat qanday beriladi?",
  );
  static const suggestInjury = L10nText(
    ko: '산재처리 신청과정 알려줘',
    en: 'How do I file a workplace injury claim?',
    tr: "İş kazası talebini nasıl yaparım?",
    tg: "Чӣ тавр талаботи садамаи кориро пешниҳод кунам?",
    fil: "Paano ako maghahain ng claim para sa aksidente sa trabaho?",
    ur: "میں کام کے حادثے کا دعویٰ کیسے کروں؟",
    th: "ฉันจะยื่นเรื่องเรียกร้องค่าสินไหมทดแทนจากอุบัติเหตุจากการทำงานได้อย่างไร",
    ky: "Өндүрүштүк кырсык боюнча арызды кантип жазсам болот?",
    km: "តើខ្ញុំអាចដាក់ពាក្យបណ្ដឹងគ្រោះថ្នាក់ការងារដោយរបៀបណា?",
    id: "Bagaimana cara mengajukan klaim kecelakaan kerja?",
    si: "කාර්මික අනතුරක් සඳහා හිමිකම් පෑමක් කරන්නේ කෙසේද?",
    bn: "আমি কীভাবে কর্মক্ষেত্রে আঘাতের দাবি করব?",
    my: "လုပ်ငန်းခွင်ထိခိုက်မှု တောင်းဆိုချက်ကို မည်သို့ပြုလုပ်ရမည်နည်း။",
    mn: "Би ажлын ослын нэхэмжлэлийг хэрхэн гаргах вэ?",
    lo: "ຂ້ອຍຈະຮ້ອງຂໍຄ່າຊົດເຊີຍອຸບັດຕິເຫດໃນບ່ອນເຮັດວຽກໄດ້ແນວໃດ?",
    tet: "Oinsá mak ha’u bele halo pedidu kona-ba asidente servisu?",
    ne: "मैले कार्यस्थल दुर्घटनाको दाबी कसरी गर्ने?",
    zh: '工伤认定的申请流程是怎样的？',
    vi: 'Quy trình yêu cầu bồi thường tai nạn lao động ra sao?',
    uz: "Ish joyidagi jarohat boʻyicha ariza qanday topshiriladi?",
  );
  static const suggestOrg = L10nText(
    ko: '근처에 상담 가능한 기관 알려줘',
    en: 'Which support centers near me can help?',
    tr: "Yakınımdaki hangi destek merkezleri yardımcı olabilir?",
    tg: "Кадом марказҳои дастгирӣ дар наздикии ман метавонанд кӯмак расонанд?",
    fil: "Anong mga support center malapit sa akin ang makakatulong?",
    ur: "میرے قریب کون سے امدادی مراکز مدد کر سکتے ہیں؟",
    th: "ศูนย์สนับสนุนใดบ้างที่อยู่ใกล้ฉันและสามารถช่วยเหลือได้",
    ky: "Мага жакын кайсы колдоо борборлору жардам бере алат?",
    km: "តើមជ្ឈមណ្ឌលជំនួយណាខ្លះនៅក្បែរខ្ញុំអាចជួយបាន?",
    id: "Pusat dukungan mana di dekat saya yang dapat membantu?",
    si: "මට ආසන්නයේ ඇති කුමන ආධාරක මධ්‍යස්ථානවලට උදව් කළ හැකිද?",
    bn: "আমার কাছাকাছি কোন সহায়তা কেন্দ্রগুলি সাহায্য করতে পারে?",
    my: "ကျွန်ုပ်အနီးရှိ မည်သည့်ပံ့ပိုးကူညီရေးစင်တာများက ကူညီနိုင်သနည်း။",
    mn: "Надад ойрхон ямар дэмжлэгийн төвүүд тусалж чадах вэ?",
    lo: "ສູນຊ່ວຍເຫຼືອໃດແດ່ທີ່ຢູ່ໃກ້ຂ້ອຍສາມາດຊ່ວຍໄດ້?",
    tet: "Sentru apoiu sira ne’ebé besik ha’u bele ajuda?",
    ne: "मेरो नजिकका कुन सहायता केन्द्रहरूले मद्दत गर्न सक्छन्?",
    zh: '附近有哪些可以咨询的机构？',
    vi: 'Gần đây có cơ quan nào có thể tư vấn?',
    uz: "Yaqin atrofda qaysi maslahat markazlari yordam bera oladi?",
  );
  static const serverError = L10nText(
    ko: '서버에 연결할 수 없어요. 잠시 후 다시 시도해 주세요.',
    en: 'Could not connect to the server. Please try again shortly.',
    tr: "Sunucuya bağlanılamadı. Lütfen kısa süre sonra tekrar deneyin.",
    tg: "Ба сервер пайваст шудан ғайриимкон аст. Лутфан баъд аз муддате дубора кӯшиш кунед.",
    fil:
        "Hindi makakonekta sa server. Pakisubukang muli pagkatapos ng ilang sandali.",
    ur: "سرور سے رابطہ نہیں ہو سکا۔ براہ کرم تھوڑی دیر بعد دوبارہ کوشش کریں۔",
    th: "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้ โปรดลองอีกครั้งในภายหลัง",
    ky: "Серверге туташуу мүмкүн болгон жок. Сураныч, бир аздан кийин кайра аракет кылыңыз.",
    km: "មិនអាចភ្ជាប់ទៅម៉ាស៊ីនមេបានទេ។ សូមព្យាយាមម្ដងទៀតក្នុងពេលឆាប់ៗនេះ។",
    id: "Tidak dapat terhubung ke server. Silakan coba lagi sebentar lagi.",
    si: "සේවාදායකයට සම්බන්ධ වීමට නොහැකි විය. කරුණාකර ටික වේලාවකින් නැවත උත්සාහ කරන්න.",
    bn: "সার্ভারের সাথে সংযোগ করা যায়নি। অনুগ্রহ করে কিছুক্ষণ পরে আবার চেষ্টা করুন।",
    my: "ဆာဗာသို့ ချိတ်ဆက်၍မရပါ။ ခဏအကြာတွင် ထပ်မံကြိုးစားပါ။",
    mn: "Серверт холбогдож чадсангүй. Удахгүй дахин оролдоно уу.",
    lo: "ບໍ່ສາມາດເຊື່ອມຕໍ່ກັບເຊີບເວີໄດ້. ກະລຸນາລອງໃໝ່ອີກຄັ້ງໃນໄວໆນີ້.",
    tet: "La konsege konekta ba servidor. Favor ida, koko fali uitoan tan.",
    ne: "सर्भरमा जडान गर्न सकिएन। कृपया केही समयपछि फेरि प्रयास गर्नुहोस्।",
    zh: '无法连接服务器，请稍后重试。',
    vi: 'Không thể kết nối máy chủ. Vui lòng thử lại sau.',
    uz: "Serverga ulanib boʻlmadi. Iltimos, birozdan keyin qayta urinib koʻring.",
  );
  static const wait = L10nText(
    ko: '{seconds}초 후 다시 전송할 수 있어요.',
    en: 'You can send again in {seconds} seconds.',
    tr: "{seconds} saniye içinde tekrar gönderebilirsiniz.",
    tg: "Шумо метавонед пас аз {seconds} сония дубора ирсол кунед.",
    fil: "Maaari kang magpadala muli sa loob ng {seconds} segundo.",
    ur: "آپ {seconds} سیکنڈ میں دوبارہ بھیج سکتے ہیں۔",
    th: "คุณสามารถส่งอีกครั้งได้ใน {seconds} วินาที",
    ky: "{seconds} секунда ичинде кайра жөнөтө аласыз.",
    km: "អ្នកអាចផ្ញើម្ដងទៀតក្នុងរយៈពេល {seconds} វិនាទី។",
    id: "Anda dapat mengirim ulang dalam {seconds} detik.",
    si: "ඔබට තත්පර {seconds} කින් නැවත යැවිය හැක.",
    bn: "আপনি {seconds} সেকেন্ডের মধ্যে আবার পাঠাতে পারবেন।",
    my: "{seconds} စက္ကန့်အတွင်း ထပ်မံပေးပို့နိုင်ပါသည်။",
    mn: "Та {seconds} секундын дараа дахин илгээж болно.",
    lo: "ທ່ານສາມາດສົ່ງອີກຄັ້ງໄດ້ພາຍໃນ {seconds} ວິນາທີ.",
    tet: "Ita bele haruka fali iha {seconds} segundu nia laran.",
    ne: "तपाईं {seconds} सेकेन्ड भित्र फेरि पठाउन सक्नुहुन्छ।",
    zh: '{seconds}秒后可以再次发送。',
    vi: 'Bạn có thể gửi lại sau {seconds} giây.',
    uz: '{seconds} soniyadan keyin yana yuborishingiz mumkin.',
  );
  static const daily = L10nText(
    ko: '오늘의 AI 이용 한도에 도달했어요. 한국 시간 자정에 초기화됩니다.',
    en: 'You have reached your daily AI limit. It resets at midnight in Korea.',
    tr: "Günlük yapay zeka limitinize ulaştınız. Kore saatiyle gece yarısı sıfırlanacaktır.",
    tg: "Шумо ба лимити ҳаррӯзаи зеҳни сунъӣ расидед. Он дар нисфи шаб ба вақти Корея аз нав барқарор карда мешавад.",
    fil:
        "Naabot mo na ang iyong pang-araw-araw na limitasyon sa AI. Magre-reset ito sa hatinggabi ng oras ng Korea.",
    ur: "آپ اپنی روزانہ کی مصنوعی ذہانت کی حد تک پہنچ چکے ہیں۔ یہ کوریائی وقت کے مطابق آدھی رات کو دوبارہ سیٹ ہو جائے گی۔",
    th: "คุณใช้ขีดจำกัด AI รายวันครบแล้ว จะรีเซ็ตในเวลาเที่ยงคืนตามเวลาเกาหลี",
    ky: "Күнүмдүк жасалма интеллект чегине жеттиңиз. Корея убактысы боюнча түн ортосунда баштапкы абалга келтирилет.",
    km: "អ្នកបានឈានដល់ដែនកំណត់ AI ប្រចាំថ្ងៃរបស់អ្នកហើយ។ វានឹងកំណត់ឡើងវិញនៅពាក់កណ្តាលអធ្រាត្រម៉ោងកូរ៉េ។",
    id: "Anda telah mencapai batas AI harian Anda. Ini akan diatur ulang pada tengah malam waktu Korea.",
    si: "ඔබ දිනපතා AI සීමාවට ළඟා වී ඇත. එය කොරියානු වේලාවෙන් මධ්‍යම රාත්‍රියේදී යළි පිහිටුවනු ඇත.",
    bn: "আপনি আপনার দৈনিক এআই সীমা পূরণ করেছেন। এটি কোরিয়ান সময় মধ্যরাতে রিসেট হবে।",
    my: "သင်၏ နေ့စဉ် AI ကန့်သတ်ချက်သို့ ရောက်ရှိသွားပါပြီ။ ကိုရီးယားစံတော်ချိန် သန်းခေါင်ယံတွင် ပြန်လည်သတ်မှတ်ပါမည်။",
    mn: "Та өдрийн хиймэл оюун ухааны хязгаарт хүрсэн байна. Солонгосын цагаар шөнө дунд шинэчлэгдэнэ.",
    lo: "ທ່ານໄດ້ເຖິງຂີດຈຳກັດ AI ປະຈຳວັນຂອງທ່ານແລ້ວ. ມັນຈະຖືກຣີເຊັດໃນເວລາທ່ຽງຄືນຕາມເວລາເກົາຫຼີ.",
    tet:
        "Ita to’o ona ba limitu diáriu intelijénsia artifisiál nian. Ne’e sei reset iha kalan-boot, tuir oras Koreia nian.",
    ne: "तपाईंले आफ्नो दैनिक एआई सीमामा पुग्नुभएको छ। यो कोरियाली समय अनुसार मध्यरातमा रिसेट हुनेछ।",
    zh: '已达到今日AI使用上限，将在韩国时间午夜重置。',
    vi: 'Bạn đã đạt giới hạn AI hôm nay. Giới hạn đặt lại lúc nửa đêm giờ Hàn Quốc.',
    uz: 'Bugungi AI limitiga yetdingiz. Limit Koreya vaqti bilan yarim tunda yangilanadi.',
  );
  static const tooLong = L10nText(
    ko: '메시지는 2,000자 이내로 입력해 주세요.',
    en: 'Please keep your message within 2,000 characters.',
    tr: "Lütfen mesajınızı 2.000 karakterle sınırlayın.",
    tg: "Лутфан паёми худро бо 2.000 аломат маҳдуд кунед.",
    fil: "Mangyaring limitahan ang iyong mensahe sa 2.000 na karakter.",
    ur: "براہ کرم اپنے پیغام کو 2.000 حروف تک محدود رکھیں۔",
    th: "โปรดจำกัดข้อความของคุณไว้ที่ 2.000 ตัวอักษร",
    ky: "Сураныч, билдирүүңүздү 2.000 символ менен чектеңиз.",
    km: "សូមកំណត់សាររបស់អ្នកត្រឹម 2.000 តួអក្សរ។",
    id: "Harap batasi pesan Anda hingga 2.000 karakter.",
    si: "කරුණාකර ඔබගේ පණිවිඩය අක්ෂර 2.000 කට සීමා කරන්න.",
    bn: "অনুগ্রহ করে আপনার বার্তা 2.000 অক্ষরের মধ্যে সীমাবদ্ধ রাখুন।",
    my: "သင်၏ မက်ဆေ့ချ်ကို စာလုံးရေ 2.000 အတွင်း ကန့်သတ်ပေးပါ။",
    mn: "Таны зурвасыг 2.000 тэмдэгтээр хязгаарлана уу.",
    lo: "ກະລຸນາຈຳກັດຂໍ້ຄວາມຂອງທ່ານບໍ່ໃຫ້ເກີນ 2.000 ຕົວອັກສອນ.",
    tet: "Favor ida, limita Ita-nia mensajen ba karater 2.000.",
    ne: "कृपया आफ्नो सन्देशलाई 2,000 अक्षरमा सीमित गर्नुहोस्।",
    zh: '消息请勿超过2,000个字符。',
    vi: 'Vui lòng nhập tin nhắn không quá 2.000 ký tự.',
    uz: 'Xabaringiz 2 000 belgidan oshmasin.',
  );
}

/// AI 가이드 챗봇. 라이트 라우팅 기반 안내 화면.
/// 하단 탭이 아니라 우측 하단 AI 버블 → 슬라이드업 시트로 진입한다(AiChatSheet).
/// 사용자가 보내는 메시지는 실제 백엔드(POST /api/chat)를 호출한다.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, this.onClose, this.chatApi});

  final ChatApiService? chatApi;

  /// 시트로 띄워졌을 때 닫기 버튼에 연결한다. null이면 닫기 버튼을 숨긴다.
  final VoidCallback? onClose;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late final _chatApi = widget.chatApi ?? ChatApiService();
  bool _isSending = false;
  Timer? _retryTimer;
  DateTime? _retryAt;
  bool _dailyLimit = false;
  L10nText? _error;
  String? _actorUid;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uid = UserProfileScope.of(context).uid;
    if (_actorUid != uid) {
      _actorUid = uid;
      _retryTimer?.cancel();
      _retryAt = null;
      _dailyLimit = false;
      _error = null;
    }
  }

  int get _remaining => _retryAt == null
      ? 0
      : ((_retryAt!.difference(DateTime.now()).inMilliseconds / 1000).ceil())
            .clamp(0, 86400);

  void _startLimit(Map<String, dynamic> detail) {
    final seconds = (detail['retryAfterSeconds'] as num?)?.toInt() ?? 5;
    _retryAt = DateTime.now().add(Duration(seconds: seconds.clamp(1, 86400)));
    _dailyLimit = detail['reason'] == 'daily';
    _retryTimer?.cancel();
    _retryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_remaining == 0) {
          _retryAt = null;
          _dailyLimit = false;
          timer.cancel();
        }
      });
    });
  }

  final List<ChatMessage> _messages = [];

  void _openRouting(RoutingTarget target) {
    switch (target.module) {
      case RoutingModule.module3Wage:
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const WageNavigatorScreen()));
        break;
      case RoutingModule.module3Accident:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AccidentNavigatorScreen()),
        );
        break;
      case RoutingModule.module1:
        Navigator.of(context).pop(); // 백과사전 탭으로 안내 (P1: 카테고리 딥링크 연결)
        break;
    }
  }

  /// [preset]은 첫 화면 추천 질문 카드가 넘기는 문구다 — 입력창에 타이핑한
  /// 경우와 똑같이 처리한다(사용자 말풍선으로 남고 이력에도 포함된다).
  Future<void> _send({String? preset}) async {
    final text = (preset ?? _controller.text).trim();
    if (text.isEmpty || _isSending || _remaining > 0) return;
    if (text.runes.length > 2000) {
      setState(() => _error = _ChatStrings.tooLong);
      return;
    }

    // 지금까지의 대화(직전 턴들)를 먼저 스냅샷 떠둔다 — 새 사용자 메시지를
    // 리스트에 추가하기 전이라야 "현재 메시지 이전까지의 이력"이 된다.
    final history = List<ChatMessage>.unmodifiable(_messages);

    setState(() {
      _messages.add(ChatMessage.user(text));
      _isSending = true;
      _error = null;
    });
    _scrollToBottom();

    try {
      if (!mounted) return;
      final language = UserProfileScope.of(context).language;
      final response = await _chatApi.send(
        text,
        language: language,
        history: history,
      );
      if (!mounted) return;
      _controller.clear();
      setState(() => _messages.add(ChatMessage.bot(response)));
    } catch (e) {
      // ApiConfig.baseUrl(디버그 콘솔에 출력)이 의도한 배포 주소가 맞는지부터 확인할 것 —
      // dart-define 없이 실행하면 로컬 기본값(localhost:8080)으로 떨어져 항상 여기로 온다.
      debugPrint('POST /api/chat 실패 (baseUrl=${ApiConfig.baseUrl}): $e');
      if (!mounted) return;
      setState(() {
        _messages.removeLast();
        _error = _ChatStrings.serverError;
        if (e is ApiException && e.statusCode == 429) {
          try {
            final detail = jsonDecode(e.body)['detail'] as Map<String, dynamic>;
            _startLimit(detail);
            _error = null;
          } catch (_) {
            /* Keep the generic error for malformed responses. */
          }
        }
      });
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = UserProfileScope.of(context).language;

    return Scaffold(
      appBar: AppBar(
        title: Text(_ChatStrings.title.of(lang)),
        automaticallyImplyLeading: false,
        actions: [
          if (widget.onClose != null)
            IconButton(
              onPressed: widget.onClose,
              icon: const Icon(Icons.close),
              tooltip: _ChatStrings.close.of(lang),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty && !_isSending
                ? _EmptyState(
                    language: lang,
                    // 전송 제한 중에는 눌러도 아무 일이 없으니 아예 비활성으로 보여준다.
                    onQuestionTap: _remaining > 0
                        ? null
                        : (text) => _send(preset: text),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_isSending ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (i == _messages.length) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: _TypingBubble(),
                        );
                      }
                      final message = _messages[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: message.isUser
                            ? _UserBubble(text: message.text!)
                            : AiResponseCard(
                                response: message.aiResponse!,
                                language: lang,
                                onRoutingTap: _openRouting,
                              ),
                      );
                    },
                  ),
          ),
          if (_error != null || _remaining > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                _error?.of(lang) ??
                    (_dailyLimit
                        ? _ChatStrings.daily.of(lang)
                        : _ChatStrings.wait
                              .of(lang)
                              .replaceAll('{seconds}', '$_remaining')),
                style: const TextStyle(color: AppColors.textMuted),
              ),
            ),
          _ChatInputBar(
            controller: _controller,
            onSend: _send,
            isSending: _isSending,
            isLimited: _remaining > 0,
            language: lang,
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.language, required this.onQuestionTap});

  final AppLanguage language;

  /// 추천 질문 카드를 눌렀을 때 그 문구를 그대로 전송한다. null이면(전송 제한 중)
  /// 카드를 흐리게 표시하고 누를 수 없게 한다.
  final void Function(String question)? onQuestionTap;

  @override
  Widget build(BuildContext context) {
    // 카드까지 더하면 작은 화면(슬라이드업 시트)에서 넘칠 수 있어, 들어가면
    // 가운데 정렬하고 넘치면 스크롤되게 한다.
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.blueBg,
                shape: BoxShape.circle,
              ),
              child: const Text('🧭', style: TextStyle(fontSize: 22)),
            ),
            const SizedBox(height: 14),
            Text(
              _ChatStrings.emptyTitle.of(language),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _ChatStrings.emptySubtitle.of(language),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11.5,
                color: AppColors.textMuted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            _SuggestionCard(
              emoji: '💸',
              label: _ChatStrings.suggestWage.of(language),
              onTap: onQuestionTap,
            ),
            const SizedBox(height: 8),
            _SuggestionCard(
              emoji: '⛑️',
              label: _ChatStrings.suggestInjury.of(language),
              onTap: onQuestionTap,
            ),
            const SizedBox(height: 8),
            _SuggestionCard(
              emoji: '🏢',
              label: _ChatStrings.suggestOrg.of(language),
              onTap: onQuestionTap,
            ),
          ],
        ),
      ),
    );
  }
}

/// 첫 화면 추천 질문 카드 — 누르면 [label] 문구가 그대로 전송된다.
class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final void Function(String question)? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: InkWell(
        onTap: enabled ? () => onTap!(label) : null,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.blueBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 15)),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.arrow_forward_ios,
                size: 11,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// AI 답변을 기다리는 동안 보여주는 말풍선 — 세 점이 순서대로 밝아졌다 어두워지며
/// "생성 중"임을 나타낸다.
class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
            bottomRight: Radius.circular(14),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                final t = (_controller.value - i * 0.2) % 1.0;
                final peak = (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Opacity(
                    opacity: 0.25 + 0.75 * peak,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.textMuted,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
            bottomLeft: Radius.circular(14),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar({
    required this.controller,
    required this.onSend,
    required this.isSending,
    required this.isLimited,
    required this.language,
  });
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isSending;
  final bool isLimited;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: !isSending,
                  maxLength: 2000,
                  decoration: InputDecoration(
                    hintText: _ChatStrings.inputHint.of(language),
                  ),
                  onSubmitted: (_) => onSend(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: isSending || isLimited ? null : onSend,
                style: IconButton.styleFrom(backgroundColor: AppColors.primary),
                icon: isSending
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
