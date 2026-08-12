import '../../../core/app_language.dart';

/// 홈 탭 UI 문구.
class HomeStrings {
  HomeStrings._();

  static const tabTitle = L10nText(
    ko: '홈',
    en: 'Home',
    zh: '首页',
    vi: 'Trang chủ',
  );
  static const visaNotSet = L10nText(
    ko: '체류자격 미설정',
    en: 'Visa status not set',
    zh: '未设置居留资格',
    vi: 'Chưa đặt tư cách lưu trú',
  );
  static const quickAccessLabel = L10nText(
    ko: '바로가기',
    en: 'Quick links',
    zh: '快捷入口',
    vi: 'Lối tắt',
  );
  static const wageCardTitle = L10nText(
    ko: '임금체불 진정 안내',
    en: 'Unpaid wage report guide',
    zh: '拖欠工资申诉指南',
    vi: 'Hướng dẫn khiếu nại nợ lương',
  );
  static const wageCardSubtitle = L10nText(
    ko: '단계별로 진정서까지 안내',
    en: 'Step by step, all the way to the report',
    zh: '逐步引导直到提交申诉书',
    vi: 'Hướng dẫn từng bước đến khi nộp đơn',
  );
  static const injuryCardTitle = L10nText(
    ko: '산재처리 신청 안내',
    en: 'Workplace injury claim guide',
    zh: '工伤申报指南',
    vi: 'Hướng dẫn yêu cầu bồi thường tai nạn lao động',
  );
  static const injuryCardSubtitle = L10nText(
    ko: '단계별로 요양급여 신청까지',
    en: 'Step by step, all the way to the benefit claim',
    zh: '逐步引导直到申请疗养补偿',
    vi: 'Hướng dẫn từng bước đến khi yêu cầu trợ cấp',
  );

  static String visaExpiry(AppLanguage lang, int dDay) {
    switch (lang) {
      case AppLanguage.ko:
        return '만료 D-$dDay';
      case AppLanguage.en:
        return 'Expires in D-$dDay';
      case AppLanguage.zh:
        return '距到期 D-$dDay';
      case AppLanguage.vi:
        return 'Hết hạn D-$dDay';
    }
  }
}
