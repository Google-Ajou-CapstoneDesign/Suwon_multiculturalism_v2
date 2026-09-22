import '../../../core/app_language.dart';

/// 네비게이터 선택 화면(Tab 1) 문구 — 임금체불/산재 두 내비게이터 중 하나를
/// 고르는 화면. 카드 문구는 홈 화면 도움 가이드(home_strings.dart의
/// wageNavTitle/wageNavDesc/injuryNavTitle/injuryNavDesc)와 같은 내용이지만,
/// 피처 간 역방향 의존을 피하기 위해 이 피처 안에 따로 둔다.
class NavigatorHomeStrings {
  NavigatorHomeStrings._();

  static const eyebrow = L10nText(
    ko: 'NAVIGATOR',
    en: 'NAVIGATOR',
    tr: "NAVİGATÖR",
    zh: 'NAVIGATOR',
    vi: 'NAVIGATOR',
    uz: "NAVIGATOR",
  );
  static const title = L10nText(
    ko: '네비게이터',
    en: 'Navigator',
    tr: "Rehber",
    zh: '导航',
    vi: 'Điều hướng',
    uz: "Navigator",
  );
  static const subtitle = L10nText(
    ko: '어떤 문제인지 골라주시면 신고·신청까지 단계별로 안내해드려요.',
    en: 'Pick your situation and we’ll guide you step by step, all the way to filing.',
    tr: "Durumunuzu seçin, dosyalama sürecine kadar adım adım size rehberlik edelim.",
    zh: '选择您的情况，我们将逐步引导您完成申诉或申请。',
    vi: 'Chọn tình huống của bạn, chúng tôi sẽ hướng dẫn từng bước đến khi nộp đơn.',
    uz: "Vaziyatingizni tanlang va biz sizga bosqichma-bosqich, arizani topshirguncha yoʻl koʻrsatamiz.",
  );

  static const wageTitle = L10nText(
    ko: '임금체불 진정 안내',
    en: 'Unpaid wage report guide',
    tr: "Ödenmemiş ücret raporu rehberi",
    zh: '拖欠工资申诉指南',
    vi: 'Hướng dẫn khiếu nại nợ lương',
    uz: "Toʻlanmagan ish haqi hisoboti boʻyicha qoʻllanma",
  );
  static const wageDesc = L10nText(
    ko: '단계별로 진정서까지 안내해드려요.',
    en: 'Step-by-step guidance all the way to filing a report.',
    tr: "Raporlama sürecine kadar adım adım rehberlik.",
    zh: '逐步引导您完成申诉书。',
    vi: 'Hướng dẫn từng bước đến khi nộp đơn khiếu nại.',
    uz: "Hisobot berishgacha bosqichma-bosqich yoʻriqnoma.",
  );
  static const injuryTitle = L10nText(
    ko: '산재처리 신청 안내',
    en: 'Workplace injury claim guide',
    tr: "İş kazası tazminat rehberi",
    zh: '工伤申报指南',
    vi: 'Hướng dẫn yêu cầu bồi thường tai nạn lao động',
    uz: "Ish joyidagi jarohat boʻyicha daʼvo qoʻllanmasi",
  );
  static const injuryDesc = L10nText(
    ko: '단계별로 요양급여 신청까지 안내해드려요.',
    en: 'Step-by-step guidance all the way to your benefit claim.',
    tr: "Yardım talebinize kadar adım adım rehberlik.",
    zh: '逐步引导您完成疗养补偿申请。',
    vi: 'Hướng dẫn từng bước đến khi yêu cầu trợ cấp.',
    uz: "Nafaqangizni talab qilishgacha bosqichma-bosqich yoʻriqnoma.",
  );
}
