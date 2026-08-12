import 'package:flutter/material.dart';
import '../../../common/widgets/app_card.dart';
import '../../../theme/app_colors.dart';
import '../../../core/app_language.dart';
import '../models/category_detail.dart';
import '../models/category_item.dart';
import '../models/encyclopedia_strings.dart';
import 'sub_document_screen.dart';

/// 카테고리 상세 화면. categoryDetailById에 콘텐츠가 있으면 5단 카드+체크리스트를,
/// 없으면(아직 검수 전인 항목) "2차 단계에서 채웁니다" 안내만 보여준다.
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

  final _checked = <int>{};

  @override
  Widget build(BuildContext context) {
    final item = categoryById[widget.categoryId]!;
    final detail = categoryDetailById[widget.categoryId];
    final sub = widget.language == AppLanguage.ko ? null : item.name.ko;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
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
                  color: AppColors.textMuted,
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
              color: _starred ? AppColors.accent : AppColors.textMuted,
            ),
          ),
        ],
      ),
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
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                for (final step in detail.steps) ...[
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _StepLabel(
                          text: detailStepCaptions[step.captionIndex].of(
                            widget.language,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          step.text.of(widget.language),
                          style: const TextStyle(fontSize: 14, height: 1.45),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                if (detail.hasGuidePhotos) ...[
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _StepLabel(
                          text: detailStepCaptions[4].of(widget.language),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: List.generate(3, (i) {
                            return Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                                height: 72,
                                decoration: BoxDecoration(
                                  color: AppColors.border.withValues(
                                    alpha: 0.4,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.image_outlined,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                if (detail.subDocuments.isNotEmpty) ...[
                  Text(
                    EncyclopediaStrings.subDocumentsTitle.of(widget.language),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (var i = 0; i < detail.subDocuments.length; i++)
                          _SubDocumentRow(
                            index: i + 1,
                            doc: detail.subDocuments[i],
                            language: widget.language,
                            isLast: i == detail.subDocuments.length - 1,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SubDocumentScreen(
                                  doc: detail.subDocuments[i],
                                  language: widget.language,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                if (detail.checklist.isNotEmpty) ...[
                  Text(
                    EncyclopediaStrings.checklistTitle.of(widget.language),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (var i = 0; i < detail.checklist.length; i++)
                          CheckboxListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 13,
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _checked.contains(i),
                            title: Text(
                              detail.checklist[i].of(widget.language),
                              style: const TextStyle(fontSize: 12.5),
                            ),
                            onChanged: (v) => setState(() {
                              if (v ?? false) {
                                _checked.add(i);
                              } else {
                                _checked.remove(i);
                              }
                            }),
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}

class _SubDocumentRow extends StatelessWidget {
  const _SubDocumentRow({
    required this.index,
    required this.doc,
    required this.language,
    required this.isLast,
    required this.onTap,
  });

  final int index;
  final SubDocument doc;
  final AppLanguage language;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isLast ? Colors.transparent : const Color(0xFFF1F5F9),
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.blueBg,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$index',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doc.title.of(language),
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    doc.description.of(language),
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _StepLabel extends StatelessWidget {
  const _StepLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.blueBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
