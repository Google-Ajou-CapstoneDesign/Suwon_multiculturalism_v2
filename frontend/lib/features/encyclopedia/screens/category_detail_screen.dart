import 'package:flutter/material.dart';
import '../../../common/widgets/app_card.dart';
import '../../../common/widgets/rich_note.dart';
import '../../../theme/app_colors.dart';
import '../../../core/app_language.dart';
import '../models/category_detail.dart';
import '../models/category_item.dart';
import '../models/encyclopedia_strings.dart';

/// 카테고리 상세 화면. categoryDetailById에 콘텐츠가 있으면 "책 쪽"(BookPage)
/// 여러 개를 순서대로 보여주고, 없으면(아직 검수 전인 항목) "2차 단계에서
/// 채웁니다" 안내만 보여준다.
class CategoryDetailScreen extends StatefulWidget {
  const CategoryDetailScreen({
    super.key,
    required this.categoryId,
    required this.language,
    required this.starred,
    required this.onToggleStar,
  });

  final int categoryId;
  final AppLanguage language;
  final bool starred;
  final VoidCallback onToggleStar;

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  late bool _starred = widget.starred;
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page, int pageCount) {
    if (page < 0 || page >= pageCount || page == _currentPage) return;

    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = categoryById[widget.categoryId]!;
    final group = categoryGroups[item.group]!;
    final detail = categoryDetailById[widget.categoryId];
    final sub = widget.language == AppLanguage.ko ? null : item.name.ko;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: group.color,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.name.of(widget.language),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            if (sub != null)
              Text(
                sub,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: Color(0xB8FFFFFF),
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() => _starred = !_starred);
              widget.onToggleStar();
            },
            icon: Icon(
              _starred ? Icons.star : Icons.star_border,
              color: _starred ? const Color(0xFF90CAF9) : Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: group.backgroundTint,
      body: detail == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  EncyclopediaStrings.notReady.of(widget.language),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    reverse: true,
                    itemCount: detail.pages.length,
                    onPageChanged: (page) {
                      setState(() => _currentPage = page);
                    },
                    itemBuilder: (context, i) => ListView(
                      key: PageStorageKey(
                        'encyclopedia-${widget.categoryId}-$i',
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                      children: [
                        _BookPageSection(
                          page: detail.pages[i],
                          pageNumber: i + 1,
                          groupColor: group.color,
                          language: widget.language,
                          source: item.source,
                        ),
                      ],
                    ),
                  ),
                ),
                _PageNavigation(
                  currentPage: _currentPage,
                  pageCount: detail.pages.length,
                  color: group.color,
                  language: widget.language,
                  onPageSelected: (page) =>
                      _goToPage(page, detail.pages.length),
                ),
              ],
            ),
    );
  }
}

class _BookPageSection extends StatelessWidget {
  const _BookPageSection({
    required this.page,
    required this.pageNumber,
    required this.groupColor,
    required this.language,
    required this.source,
  });

  final BookPage page;
  final int pageNumber;
  final Color groupColor;
  final AppLanguage language;
  final String source;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: groupColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$pageNumber',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  page.title.of(language),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border(left: BorderSide(color: groupColor, width: 4)),
            ),
            child: Text(
              page.summary.of(language),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: groupColor,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 11),
          if (page.form != null)
            _FormPreviewCard(
              form: page.form!,
              groupColor: groupColor,
              language: language,
            ),
          for (final block in page.blocks) ...[
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    block.title.of(language),
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 7),
                  for (final bullet in block.bullets)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: Text(
                              '•',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: groupColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: RichNote(
                              bullet.of(language),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 2),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${EncyclopediaStrings.sourceLabel.of(language)}: $source',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 9,
                color: AppColors.textMuted,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageNavigation extends StatelessWidget {
  const _PageNavigation({
    required this.currentPage,
    required this.pageCount,
    required this.color,
    required this.language,
    required this.onPageSelected,
  });

  final int currentPage;
  final int pageCount;
  final Color color;
  final AppLanguage language;
  final ValueChanged<int> onPageSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 7, 8, 9),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: currentPage == 0
                    ? null
                    : () => onPageSelected(currentPage - 1),
                icon: const Icon(Icons.chevron_left, size: 20),
                label: Text(EncyclopediaStrings.previousPage.of(language)),
              ),
            ),
            SizedBox(
              width: 126,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(pageCount, (index) {
                      final selected = index == currentPage;
                      return Semantics(
                        button: true,
                        selected: selected,
                        label: '${index + 1} / $pageCount',
                        child: InkWell(
                          onTap: () => onPageSelected(index),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 2,
                              vertical: 3,
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: selected ? 14 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: selected ? color : AppColors.border,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${currentPage + 1} / $pageCount',
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TextButton.icon(
                onPressed: currentPage == pageCount - 1
                    ? null
                    : () => onPageSelected(currentPage + 1),
                iconAlignment: IconAlignment.end,
                icon: const Icon(Icons.chevron_right, size: 20),
                label: Text(EncyclopediaStrings.nextPage.of(language)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 관공서 서식(진정서·신청서) 미리보기 카드. 항목마다 자동입력/직접입력/
/// 그대로 옮김 여부를 색으로 구분해 실제 서식을 채울 때 헷갈리지 않게 한다.
class _FormPreviewCard extends StatelessWidget {
  const _FormPreviewCard({
    required this.form,
    required this.groupColor,
    required this.language,
  });

  final FormPreview form;
  final Color groupColor;
  final AppLanguage language;

  static const _tagColors = {
    'auto': Color(0xFF2196F3),
    'blank': Color(0xFF0D47A1),
    'raw': Color(0xFF6B7280),
  };

  L10nText _tagLabel(String tag) {
    switch (tag) {
      case 'auto':
        return EncyclopediaStrings.formTagAuto;
      case 'blank':
        return EncyclopediaStrings.formTagBlank;
      default:
        return EncyclopediaStrings.formTagRaw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: groupColor.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  form.title.of(language),
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: groupColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  form.subtitle.of(language),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final row in form.rows)
                  row.isSection
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 4),
                          child: Row(
                            children: [
                              Text(
                                row.sectionTitle!.of(language),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  row.sectionSub!.of(language),
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    color: AppColors.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 96,
                                child: Text(
                                  row.label!.of(language),
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  row.value!.of(language),
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      (_tagColors[row.tag] ??
                                              _tagColors['raw']!)
                                          .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  _tagLabel(row.tag ?? 'raw').of(language),
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        _tagColors[row.tag] ??
                                        _tagColors['raw'],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
