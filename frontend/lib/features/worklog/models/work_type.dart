import '../../../core/app_language.dart';

enum WorkType { manufacturing, serving, delivery, other }

enum IncidentType { normal, overtime, accident }

extension WorkTypeLabel on WorkType {
  L10nText get label => switch (this) {
    WorkType.manufacturing => const L10nText(
      ko: '제조',
      en: 'Manufacturing',
      zh: '制造',
      vi: 'Sản xuất',
    ),
    WorkType.serving => const L10nText(
      ko: '서빙',
      en: 'Serving',
      zh: '服务员',
      vi: 'Phục vụ',
    ),
    WorkType.delivery => const L10nText(
      ko: '배달',
      en: 'Delivery',
      zh: '配送',
      vi: 'Giao hàng',
    ),
    WorkType.other => const L10nText(
      ko: '기타',
      en: 'Other',
      zh: '其他',
      vi: 'Khác',
    ),
  };
}

extension IncidentTypeLabel on IncidentType {
  L10nText get label => switch (this) {
    IncidentType.normal => const L10nText(
      ko: '정상근무',
      en: 'Normal work',
      zh: '正常工作',
      vi: 'Làm việc bình thường',
    ),
    IncidentType.overtime => const L10nText(
      ko: '연장근무',
      en: 'Overtime work',
      zh: '加班',
      vi: 'Làm thêm giờ',
    ),
    IncidentType.accident => const L10nText(
      ko: '사고·부상',
      en: 'Accident/injury',
      zh: '事故·受伤',
      vi: 'Tai nạn/thương tích',
    ),
  };
}
