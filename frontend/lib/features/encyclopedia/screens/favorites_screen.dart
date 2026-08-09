import 'package:flutter/material.dart';
import '../../../common/widgets/app_card.dart';
import '../../../theme/app_colors.dart';
import '../controllers/encyclopedia_controller.dart';
import '../../../core/app_language.dart';
import '../models/category_item.dart';
import '../models/encyclopedia_strings.dart';
import 'category_detail_screen.dart';

/// 즐겨찾기(★) 화면 — 저장한 항목과 저장한 그룹을 모아 보여준다.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key, required this.controller});

  final EncyclopediaController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final lang = controller.language;
        final starredItems = controller.starredItems.toList();
        final starredGroups = controller.starredGroups.toList();

        return Scaffold(
          appBar: AppBar(title: Text(EncyclopediaStrings.favoritesTitle.of(lang))),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                EncyclopediaStrings.favoritesSubtitle.of(lang),
                style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted, height: 1.5),
              ),
              const SizedBox(height: 18),
              Text(
                EncyclopediaStrings.favoritesItemsLabel.of(lang),
                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.6),
              ),
              const SizedBox(height: 8),
              if (starredItems.isEmpty)
                _EmptyBox(text: EncyclopediaStrings.favoritesEmpty.of(lang))
              else
                for (final id in starredItems) _FavoriteItemCard(id: id, language: lang, controller: controller),
              const SizedBox(height: 18),
              Text(
                EncyclopediaStrings.favoritesGroupsLabel.of(lang),
                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.6),
              ),
              const SizedBox(height: 8),
              for (final groupId in starredGroups) _FavoriteGroupCard(groupId: groupId, language: lang, controller: controller),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyBox extends StatelessWidget {
  const _EmptyBox({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(11)),
      child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted, height: 1.6)),
    );
  }
}

class _FavoriteItemCard extends StatelessWidget {
  const _FavoriteItemCard({required this.id, required this.language, required this.controller});
  final int id;
  final AppLanguage language;
  final EncyclopediaController controller;

  @override
  Widget build(BuildContext context) {
    final item = categoryById[id]!;
    final group = categoryGroups[item.group]!;
    final sub = language == AppLanguage.ko ? null : item.name.ko;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CategoryDetailScreen(
              categoryId: id,
              language: language,
              starred: controller.isItemStarred(id),
              onToggleStar: () => controller.toggleItemStar(id),
            ),
          ),
        ),
        child: Row(
          children: [
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
                  Text(item.name.of(language), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  if (sub != null) ...[
                    const SizedBox(height: 3),
                    Text(sub, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  ],
                ],
              ),
            ),
            const Icon(Icons.star, size: 16, color: AppColors.accent),
          ],
        ),
      ),
    );
  }
}

class _FavoriteGroupCard extends StatelessWidget {
  const _FavoriteGroupCard({required this.groupId, required this.language, required this.controller});
  final CategoryGroupId groupId;
  final AppLanguage language;
  final EncyclopediaController controller;

  @override
  Widget build(BuildContext context) {
    final group = categoryGroups[groupId]!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        onTap: () {
          controller.openGroupPage(groupId);
          Navigator.of(context).pop();
        },
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: group.backgroundTint, borderRadius: BorderRadius.circular(9)),
              child: Text(
                groupId.name.toUpperCase(),
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: group.color),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(group.title.of(language), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text(group.name.of(language), style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                ],
              ),
            ),
            const Icon(Icons.star, size: 16, color: AppColors.accent),
          ],
        ),
      ),
    );
  }
}
