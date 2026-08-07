import 'package:flutter/material.dart';
import '../controllers/encyclopedia_controller.dart';
import '../models/category_item.dart';

/// 화면 우측 가장자리에 고정되는 세로 북마크(A/B/C) 3개.
/// 탭하면 해당 그룹의 목차로 전환하고, 이미 열려 있는 그룹을 다시 탭하면 표지로 되돌아간다.
class GroupBookmarkRail extends StatelessWidget {
  const GroupBookmarkRail({super.key, required this.controller});

  final EncyclopediaController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: CategoryGroupId.values.map((groupId) {
            final group = categoryGroups[groupId]!;
            final isOpen = controller.openGroup == groupId;
            final dimmed = !controller.isCoverShowing && !isOpen;

            return Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: _Bookmark(
                letter: groupId.name.toUpperCase(),
                label: group.markLabel.of(controller.language),
                color: group.color,
                dimmed: dimmed,
                onTap: () => controller.toggleGroup(groupId),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _Bookmark extends StatelessWidget {
  const _Bookmark({
    required this.letter,
    required this.label,
    required this.color,
    required this.dimmed,
    required this.onTap,
  });

  final String letter;
  final String label;
  final Color color;
  final bool dimmed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: dimmed ? 0.55 : 1,
      duration: const Duration(milliseconds: 180),
      child: Material(
        color: color,
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(8), topRight: Radius.circular(8)),
        elevation: 3,
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.only(bottomRight: Radius.circular(8), topRight: Radius.circular(8)),
          child: SizedBox(
            width: 30,
            height: 112,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 15,
                  height: 15,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.24), shape: BoxShape.circle),
                  child: Text(
                    letter,
                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 6),
                RotatedBox(
                  quarterTurns: 1,
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
