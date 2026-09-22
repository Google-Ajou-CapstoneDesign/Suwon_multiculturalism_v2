import '../../../core/app_language.dart';

enum WorkType { manufacturing, serving, delivery, other }

enum IncidentType { normal, overtime, accident }

extension WorkTypeLabel on WorkType {
  L10nText get label => switch (this) {
    WorkType.manufacturing => const L10nText(
      ko: '제조',
      en: 'Manufacturing',
      tr: "İmalat",
      zh: '制造',
      vi: 'Sản xuất',
      uz: "Ishlab chiqarish",
    ),
    WorkType.serving => const L10nText(
      ko: '서빙',
      en: 'Serving',
      tr: "Hizmet",
      zh: '服务员',
      vi: 'Phục vụ',
      uz: "Xizmat koʻrsatish",
    ),
    WorkType.delivery => const L10nText(
      ko: '배달',
      en: 'Delivery',
      tr: "Teslimat",
      zh: '配送',
      vi: 'Giao hàng',
      uz: "Yetkazib berish",
    ),
    WorkType.other => const L10nText(
      ko: '기타',
      en: 'Other',
      tr: "Diğer",
      zh: '其他',
      vi: 'Khác',
      uz: "Boshqa",
    ),
  };
}

extension IncidentTypeLabel on IncidentType {
  L10nText get label => switch (this) {
    IncidentType.normal => const L10nText(
      ko: '정상근무',
      en: 'Normal work',
      tr: "Normal çalışma",
      zh: '正常工作',
      vi: 'Làm việc bình thường',
      uz: "Oddiy ish",
    ),
    IncidentType.overtime => const L10nText(
      ko: '연장근무',
      en: 'Overtime work',
      tr: "Fazla mesai",
      zh: '加班',
      vi: 'Làm thêm giờ',
      uz: "Qoʻshimcha ish",
    ),
    IncidentType.accident => const L10nText(
      ko: '사고·부상',
      en: 'Accident/injury',
      tr: "Kaza/yaralanma",
      zh: '事故·受伤',
      vi: 'Tai nạn/thương tích',
      uz: "Baxtsiz hodisa/jarohat",
    ),
  };
}
