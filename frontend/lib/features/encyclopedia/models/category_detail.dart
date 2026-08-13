import 'category_detail_a.dart';
import 'category_detail_b.dart';
import 'category_detail_c.dart';
import '../../../core/app_language.dart';

/// 카테고리 상세 콘텐츠 한 "쪽"(html_files/생활백과사전.html의 book-page 1개에
/// 대응). 여러 쪽이 모여 CategoryDetail 하나를 이룬다 — 표지·목차 같은 책
/// 디자인은 그대로 두고, 탭했을 때 보이는 내용만 이 구조로 채운다.
class BookPage {
  const BookPage({
    required this.title,
    required this.summary,
    this.blocks = const [],
    this.form,
  });

  final L10nText title;
  final L10nText summary;
  final List<ContentBlock> blocks;

  /// 일부 쪽(임금체불 진정서, 요양급여신청서 등)은 불릿 카드 대신 실제
  /// 관공서 서식 미리보기로 구성된다 — 있으면 이걸 우선 렌더링한다.
  final FormPreview? form;
}

/// 쪽 안의 소제목 + 불릿 목록 카드 1개.
class ContentBlock {
  const ContentBlock({required this.title, required this.bullets});

  final L10nText title;
  final List<L10nText> bullets;
}

/// 관공서 서식(진정서·신청서 등) 미리보기 한 장.
class FormPreview {
  const FormPreview({
    required this.title,
    required this.subtitle,
    required this.rows,
  });

  final L10nText title;
  final L10nText subtitle;
  final List<FormRowData> rows;
}

/// tag: 'auto'(프로필/기록에서 자동 입력) · 'blank'(사용자가 직접 입력) ·
/// 'raw'(이전 단계 내용을 그대로 옮겨적음). section이 있으면 구간 제목 행,
/// 없으면 항목-값 행이다.
class FormRowData {
  const FormRowData.section({required L10nText section, required L10nText sub})
    : sectionTitle = section,
      sectionSub = sub,
      label = null,
      value = null,
      tag = null;

  const FormRowData.field({
    required this.label,
    required this.value,
    required this.tag,
  }) : sectionTitle = null,
       sectionSub = null;

  final L10nText? sectionTitle;
  final L10nText? sectionSub;
  final L10nText? label;
  final L10nText? value;
  final String? tag;

  bool get isSection => sectionTitle != null;
}

/// 카테고리 상세 콘텐츠 전체 — 여러 쪽(BookPage)으로 구성된다.
class CategoryDetail {
  const CategoryDetail({required this.pages});

  final List<BookPage> pages;
}

/// 그룹 A/B/C별로 category_detail_a/b/c.dart에 나눠 담아뒀다가 여기서 합친다
/// — 번역 작업을 그룹별로 병렬 진행할 때 파일이 겹치지 않게 하기 위함.
const Map<int, CategoryDetail> categoryDetailById = {
  ...categoryDetailDataA,
  ...categoryDetailDataB,
  ...categoryDetailDataC,
};
