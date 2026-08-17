import '../../../core/app_language.dart';

/// 백과사전 탭 UI 문구(콘텐츠가 아니라 버튼·안내문). 콘텐츠 문구(카테고리명·
/// 상세 설명)와 분리해서 관리한다 — 콘텐츠만 노무사 감수 대상이기 때문.
class EncyclopediaStrings {
  EncyclopediaStrings._();

  static const coverTitle = L10nText(
    ko: '한국 생활\n백과사전',
    en: 'Living in\nKorea',
    zh: '韩国生活\n指南',
    vi: 'Cẩm nang\nsống ở Hàn Quốc',
  );
  static const coverSubtitle = L10nText(
    ko: '한국에서 일하고 살아가는 데 필요한 절차를 정리했습니다',
    en: "We've organized the steps you need to work and live in Korea",
    zh: '我们整理了在韩国工作生活所需的各项手续',
    vi: 'Chúng tôi đã tổng hợp các thủ tục cần thiết để làm việc và sinh sống tại Hàn Quốc',
  );
  static const visaLabel = L10nText(
    ko: 'MY VISA',
    en: 'MY VISA',
    zh: 'MY VISA',
    vi: 'MY VISA',
  );
  static const visaValue = L10nText(
    ko: 'E-9 비전문취업',
    en: 'E-9 Non-professional',
    zh: 'E-9 非专业就业',
    vi: 'E-9 Lao động phổ thông',
  );
  static const visaNotSet = L10nText(
    ko: '체류자격 미설정',
    en: 'Visa status not set',
    zh: '未设置居留资格',
    vi: 'Chưa đặt tư cách lưu trú',
  );
  static const visaNote = L10nText(
    ko: '연장 절차 확인하기 →',
    en: 'Check renewal steps →',
    zh: '查看延长手续 →',
    vi: 'Xem thủ tục gia hạn →',
  );
  static const visaNoteNotSet = L10nText(
    ko: '설정에서 등록하세요 →',
    en: 'Register it in Settings →',
    zh: '请在设置中登记 →',
    vi: 'Đăng ký trong Cài đặt →',
  );
  static const quickAccessLabel = L10nText(
    ko: '자주 보는 항목',
    en: 'WHAT YOU OPEN MOST',
    zh: '常用项目',
    vi: 'MỤC BẠN HAY MỞ',
  );
  static const searchHint = L10nText(
    ko: '필요한 정보를 검색하세요',
    en: 'Search for what you need',
    zh: '搜索您需要的信息',
    vi: 'Tìm thông tin bạn cần',
  );
  static const searchNoResults = L10nText(
    ko: '검색 결과가 없습니다.\n다른 단어로 검색해 보세요.',
    en: 'No results found.\nTry a different search term.',
    zh: '没有搜索结果。\n请尝试其他关键词。',
    vi: 'Không có kết quả.\nHãy thử từ khóa khác.',
  );
  static const searchEmptyPrompt = L10nText(
    ko: '카테고리 이름으로 검색해 보세요',
    en: 'Try searching by category name',
    zh: '请尝试用分类名称搜索',
    vi: 'Hãy thử tìm theo tên danh mục',
  );
  static const soonBadge = L10nText(
    ko: '준비 중',
    en: 'Coming soon',
    zh: '准备中',
    vi: 'Sắp có',
  );
  static const notReady = L10nText(
    ko: '이 항목은 2차 단계에서 채웁니다.',
    en: 'This item will be added in the next phase.',
    zh: '该项目将在第二阶段补充。',
    vi: 'Mục này sẽ được bổ sung ở giai đoạn sau.',
  );
  static const favoritesTitle = L10nText(
    ko: '★ 즐겨찾기',
    en: '★ Favorites',
    zh: '★ 收藏',
    vi: '★ Mục yêu thích',
  );
  static const favoritesSubtitle = L10nText(
    ko: '그룹·카테고리 어디서든 별표로 담을 수 있습니다',
    en: 'Star any group or item to keep it here',
    zh: '在任意分组或分类中点击星标即可收藏',
    vi: 'Nhấn dấu sao ở bất kỳ nhóm hay mục nào để lưu tại đây',
  );
  static const favoritesItemsLabel = L10nText(
    ko: '저장한 항목',
    en: 'Saved items',
    zh: '已收藏项目',
    vi: 'Mục đã lưu',
  );
  static const favoritesGroupsLabel = L10nText(
    ko: '저장한 그룹',
    en: 'Saved groups',
    zh: '已收藏分组',
    vi: 'Nhóm đã lưu',
  );
  static const favoritesEmpty = L10nText(
    ko: '아직 담은 항목이 없습니다.\n목록에서 ☆를 눌러 자주 쓰는 항목을 담아두세요.',
    en: 'Nothing saved yet.\nTap ☆ on any item to keep it here.',
    zh: '还没有收藏的项目。\n请在列表中点击☆收藏常用项目。',
    vi: 'Chưa lưu mục nào.\nNhấn ☆ ở mục bất kỳ để lưu tại đây.',
  );
  static const formTagAuto = L10nText(
    ko: '자동입력',
    en: 'Auto-filled',
    zh: '自动填写',
    vi: 'Tự động điền',
  );
  static const formTagBlank = L10nText(
    ko: '직접입력',
    en: 'You fill in',
    zh: '需自行填写',
    vi: 'Tự nhập',
  );
  static const formTagRaw = L10nText(
    ko: '그대로 옮김',
    en: 'Copied as-is',
    zh: '原样填写',
    vi: 'Chép nguyên văn',
  );
  static const previousPage = L10nText(
    ko: '이전',
    en: 'Previous',
    zh: '上一页',
    vi: 'Trước',
  );
  static const nextPage = L10nText(ko: '다음', en: 'Next', zh: '下一页', vi: 'Tiếp');
  static String itemCount(AppLanguage lang, int n) {
    switch (lang) {
      case AppLanguage.ko:
        return '$n개 항목';
      case AppLanguage.en:
        return '$n items';
      case AppLanguage.zh:
        return '$n个项目';
      case AppLanguage.vi:
        return '$n mục';
    }
  }
}
