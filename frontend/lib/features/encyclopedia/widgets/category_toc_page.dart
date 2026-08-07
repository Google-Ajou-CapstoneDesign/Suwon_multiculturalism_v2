import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../models/app_language.dart';
import '../models/category_item.dart';
import '../models/encyclopedia_strings.dart';

/// 그룹 하나를 열었을 때 보이는 목차(TOC) 페이지.
/// itemIds는 탭 가능, skeletonIds는 "준비 중" 배지만 달고 탭할 수 없다(HTML 원본과 동일).
class CategoryTocPage extends StatelessWidget {
  const CategoryTocPage({
    super.key,
    required this.group,
    required this.language,
    required this.isStarred,
    required this.onToggleStar,
    required this.onOpenItem,
  });

  final CategoryGroupData group;
  final AppLanguage language;
  final bool Function(int id) isStarred;
  final void Function(int id) onToggleStar;
  final ValueChanged<int> onOpenItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(width: 9, height: 9, decoration: BoxDecoration(color: group.color, shape: BoxShape.circle)),
                  const SizedBox(width: 7),
                  Text(
                    group.name.of(language),
                    style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.4),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Text(
                group.title.of(language),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.4),
              ),
              const SizedBox(height: 5),
              Text(
                EncyclopediaStrings.itemCount(language, group.itemIds.length),
                style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            children: [
              for (var i = 0; i < group.itemIds.length; i++)
                _TocRow(
                  index: i + 1,
                  item: categoryById[group.itemIds[i]]!,
                  group: group,
                  language: language,
                  starred: isStarred(group.itemIds[i]),
                  onTap: () => onOpenItem(group.itemIds[i]),
                  onToggleStar: () => onToggleStar(group.itemIds[i]),
                ),
              for (final skeletonId in group.skeletonIds)
                _SkeletonRow(item: categoryById[skeletonId]!, language: language),
            ],
          ),
        ),
      ],
    );
  }
}

class _TocRow extends StatelessWidget {
  const _TocRow({
    required this.index,
    required this.item,
    required this.group,
    required this.language,
    required this.starred,
    required this.onTap,
    required this.onToggleStar,
  });

  final int index;
  final CategoryItem item;
  final CategoryGroupData group;
  final AppLanguage language;
  final bool starred;
  final VoidCallback onTap;
  final VoidCallback onToggleStar;

  @override
  Widget build(BuildContext context) {
    final sub = language == AppLanguage.ko ? null : item.name.ko;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEEF2F7)))),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              child: Text(
                index.toString().padLeft(2, '0'),
                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textMuted),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: group.backgroundTint, borderRadius: BorderRadius.circular(9)),
              child: Icon(item.icon, size: 16, color: group.color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name.of(language),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  if (sub != null) ...[
                    const SizedBox(height: 3),
                    Text(sub, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  ],
                ],
              ),
            ),
            IconButton(
              onPressed: onToggleStar,
              icon: Icon(starred ? Icons.star : Icons.star_border, size: 18, color: starred ? AppColors.accent : AppColors.textMuted),
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(6),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow({required this.item, required this.language});

  final CategoryItem item;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final sub = language == AppLanguage.ko ? null : item.name.ko;

    return Opacity(
      opacity: 0.55,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEEF2F7)))),
        child: Row(
          children: [
            const SizedBox(width: 18, child: Text('–', style: TextStyle(fontSize: 10.5, color: AppColors.textMuted))),
            const SizedBox(width: 10),
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(9)),
              child: const Icon(Icons.add, size: 16, color: AppColors.textMuted),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name.of(language),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  if (sub != null) ...[
                    const SizedBox(height: 3),
                    Text(sub, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: AppColors.border)),
              child: Text(
                EncyclopediaStrings.soonBadge.of(language),
                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
