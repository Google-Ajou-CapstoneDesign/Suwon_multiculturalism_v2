import '../../../common/models/org.dart';
import '../../../core/app_language.dart';

enum RoutingModule { module1, module3Wage, module3Accident }

RoutingModule _moduleFromJson(String value) {
  switch (value) {
    case 'module1':
      return RoutingModule.module1;
    case 'module3-wage':
      return RoutingModule.module3Wage;
    case 'module3-accident':
      return RoutingModule.module3Accident;
    default:
      throw FormatException('알 수 없는 routingTarget.module 값: $value');
  }
}

class RoutingTarget {
  const RoutingTarget(this.module, {this.categoryId});

  factory RoutingTarget.fromJson(Map<String, dynamic> json) => RoutingTarget(
    _moduleFromJson(json['module'] as String),
    categoryId: json['categoryId'] as String?,
  );

  final RoutingModule module;
  final String? categoryId;

  String labelOf(AppLanguage lang) {
    switch (module) {
      case RoutingModule.module1:
        return const L10nText(
          ko: '관련 정보 페이지로 이동',
          en: 'Go to related info',
          tr: "İlgili bilgilere git",
          tg: "Ба маълумоти дахлдор гузаред",
          fil: "Pumunta sa kaugnay na impormasyon",
          ur: "متعلقہ معلومات پر جائیں",
          th: "ไปที่ข้อมูลที่เกี่ยวข้อง",
          ky: "Тиешелүү маалыматка өтүү",
          km: "ចូលទៅកាន់ព័ត៌មានពាក់ព័ន្ធ",
          id: "Buka informasi terkait",
          si: "අදාළ තොරතුරු වෙත යන්න",
          bn: "সম্পর্কিত তথ্যে যান",
          my: "ဆက်စပ်အချက်အလက်များသို့ သွားပါ",
          mn: "Холбогдох мэдээлэл рүү очих",
          lo: "ໄປທີ່ຂໍ້ມູນທີ່ກ່ຽວຂ້ອງ",
          tet: "Ba informasaun relevante",
          ne: "सम्बन्धित जानकारीमा जानुहोस्",
          zh: '前往相关信息页面',
          vi: 'Đi đến trang thông tin liên quan',
          uz: "Tegishli maʼlumotga oʻtish",
        ).of(lang);
      case RoutingModule.module3Wage:
        return const L10nText(
          ko: '임금체불 대응 네비게이터로 이동',
          en: 'Go to the unpaid wage navigator',
          tr: "Ödenmemiş ücret rehberine git",
          tg: "Ба дастури музди пардохтнашуда гузаред",
          fil: "Pumunta sa gabay sa hindi nabayarang sahod",
          ur: "غیر ادا شدہ اجرت کی رہنمائی پر جائیں",
          th: "ไปที่คู่มือค่าจ้างค้างชำระ",
          ky: "Төлөнбөгөн эмгек акы боюнча колдонмого өтүү",
          km: "ចូលទៅកាន់ការណែនាំអំពីប្រាក់ឈ្នួលមិនទាន់បានបង់",
          id: "Buka panduan upah yang belum dibayar",
          si: "නොගෙවූ වැටුප් මාර්ගෝපදේශය වෙත යන්න",
          bn: "অপ্রদত্ত মজুরি নির্দেশিকাতে যান",
          my: "မရရှိသေးသော လုပ်ခလစာ လမ်းညွှန်သို့ သွားပါ",
          mn: "Цалин хөлсний гарын авлага руу очих",
          lo: "ໄປທີ່ຄູ່ມືຄ່າຈ້າງທີ່ຄ້າງຈ່າຍ",
          tet: "Ba guia kona-ba saláriu la selu",
          ne: "भुक्तानी नगरिएको ज्यालाको मार्गनिर्देशनमा जानुहोस्",
          zh: '前往拖欠工资应对导航',
          vi: 'Đi đến hướng dẫn xử lý nợ lương',
          uz: "Toʻlanmagan ish haqi navigatoriga oʻtish",
        ).of(lang);
      case RoutingModule.module3Accident:
        return const L10nText(
          ko: '산재 대응 네비게이터로 이동',
          en: 'Go to the workplace injury navigator',
          tr: "İş kazası rehberine git",
          tg: "Ба дастури садамаи корӣ гузаред",
          fil: "Pumunta sa gabay sa aksidente sa trabaho",
          ur: "کام کے حادثے کی رہنمائی پر جائیں",
          th: "ไปที่คู่มืออุบัติเหตุจากการทำงาน",
          ky: "Өндүрүштүк кырсык боюнча колдонмого өтүү",
          km: "ចូលទៅកាន់ការណែនាំអំពីគ្រោះថ្នាក់ការងារ",
          id: "Buka panduan kecelakaan kerja",
          si: "කාර්මික අනතුරු මාර්ගෝපදේශය වෙත යන්න",
          bn: "কর্মক্ষেত্রে আঘাত নির্দেশিকাতে যান",
          my: "လုပ်ငန်းခွင်ထိခိုက်မှု လမ်းညွှန်သို့ သွားပါ",
          mn: "Ажлын ослын гарын авлага руу очих",
          lo: "ໄປທີ່ຄູ່ມືອຸບັດຕິເຫດໃນບ່ອນເຮັດວຽກ",
          tet: "Ba guia kona-ba asidente servisu",
          ne: "कार्यस्थल दुर्घटना मार्गनिर्देशनमा जानुहोस्",
          zh: '前往工伤应对导航',
          vi: 'Đi đến hướng dẫn xử lý tai nạn lao động',
          uz: "Ish joyidagi jarohat navigatoriga oʻtish",
        ).of(lang);
    }
  }
}

/// 챗봇 응답 통일 데이터 모델. backend `ChatResponse`(app/schemas/chat.py)와 1:1 대응.
class AiResponse {
  const AiResponse({
    this.factAnswer,
    this.riskNotice,
    this.routingTarget,
    this.recommendedOrgs = const [],
  });

  factory AiResponse.fromJson(Map<String, dynamic> json) => AiResponse(
    factAnswer: json['factAnswer'] as String?,
    riskNotice: json['riskNotice'] as String?,
    routingTarget: json['routingTarget'] == null
        ? null
        : RoutingTarget.fromJson(json['routingTarget'] as Map<String, dynamic>),
    recommendedOrgs: (json['recommendedOrgs'] as List<dynamic>? ?? const [])
        .map((e) => Org.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  final String? factAnswer;
  final String? riskNotice;
  final RoutingTarget? routingTarget;
  final List<Org> recommendedOrgs;
}
