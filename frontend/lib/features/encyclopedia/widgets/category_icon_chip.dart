import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../models/category_item.dart';

/// 카테고리 아이콘 칩. 노동 권익(그룹C)은 Secondary(Teal) 톤, 나머지는 Primary(Blue) 톤.
class CategoryIconChip extends StatelessWidget {
  const CategoryIconChip({super.key, required this.item, required this.onTap});

  final CategoryItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tone = item.group == CategoryGroup.c ? AppColors.secondary : AppColors.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 68,
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: tone.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(item.icon, color: tone, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              item.title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
