import 'package:flutter/material.dart';
import '../../../common/widgets/app_card.dart';
import '../../../core/app_language.dart';
import '../../../theme/app_colors.dart';
import '../controllers/encyclopedia_controller.dart';
import '../models/category_item.dart';
import '../models/encyclopedia_strings.dart';
import 'category_detail_screen.dart';

/// 백과사전 검색 화면 — 표지 검색창에서 진입한다. 카테고리명(4개 언어 전부)에
/// 대해 부분일치로 12개 항목을 필터링한다.
class CategorySearchScreen extends StatefulWidget {
  const CategorySearchScreen({
    super.key,
    required this.language,
    required this.controller,
  });

  final AppLanguage language;
  final EncyclopediaController controller;

  @override
  State<CategorySearchScreen> createState() => _CategorySearchScreenState();
}

class _CategorySearchScreenState extends State<CategorySearchScreen> {
  final _queryController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  List<CategoryItem> get _results {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return categoryById.values.where((item) {
      final name = item.name;
      return name.ko.toLowerCase().contains(q) ||
          name.en.toLowerCase().contains(q) ||
          name.zh.toLowerCase().contains(q) ||
          name.vi.toLowerCase().contains(q);
    }).toList();
  }

  void _openDetail(int id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoryDetailScreen(
          categoryId: id,
          language: widget.language,
          starred: widget.controller.isItemStarred(id),
          onToggleStar: () => widget.controller.toggleItemStar(id),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.language;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _queryController,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: EncyclopediaStrings.searchHint.of(lang),
          ),
          onChanged: (value) => setState(() => _query = value),
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          if (_query.trim().isEmpty) {
            return _CenteredHint(
              text: EncyclopediaStrings.searchEmptyPrompt.of(lang),
            );
          }

          final results = _results;
          if (results.isEmpty) {
            return _CenteredHint(
              text: EncyclopediaStrings.searchNoResults.of(lang),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                EncyclopediaStrings.itemCount(lang, results.length),
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 8),
              for (final item in results)
                _SearchResultCard(
                  item: item,
                  language: lang,
                  controller: widget.controller,
                  onTap: () => _openDetail(item.id),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _CenteredHint extends StatelessWidget {
  const _CenteredHint({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
            height: 1.6,
          ),
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({
    required this.item,
    required this.language,
    required this.controller,
    required this.onTap,
  });

  final CategoryItem item;
  final AppLanguage language;
  final EncyclopediaController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final group = categoryGroups[item.group]!;
    final sub = language == AppLanguage.ko ? null : item.name.ko;
    final starred = controller.isItemStarred(item.id);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: group.backgroundTint,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(item.icon, size: 16, color: group.color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name.of(language),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (sub != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      sub,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              onPressed: () => controller.toggleItemStar(item.id),
              icon: Icon(
                starred ? Icons.star : Icons.star_border,
                size: 18,
                color: starred ? AppColors.accent : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
