import 'package:flutter/material.dart';
import '../controllers/encyclopedia_controller.dart';
import '../models/category_item.dart';
import '../widgets/book_cover.dart';
import '../widgets/book_page_switcher.dart';
import '../widgets/category_toc_page.dart';
import '../widgets/group_bookmark_rail.dart';
import '../widgets/language_sheet.dart';
import 'category_detail_screen.dart';
import 'favorites_screen.dart';

/// Tab 1 · 백과사전. "책 표지 + 세로 북마크" 컨셉(프론트엔드_구상.html 기반).
/// 표지(닫힌 책)를 기본으로 보여주고, 우측 세로 북마크(A/B/C)를 탭하면 해당
/// 그룹의 목차로 전환된다. 상세·즐겨찾기는 별도 화면으로 push한다.
class EncyclopediaHomeScreen extends StatefulWidget {
  const EncyclopediaHomeScreen({super.key});

  @override
  State<EncyclopediaHomeScreen> createState() => _EncyclopediaHomeScreenState();
}

class _EncyclopediaHomeScreenState extends State<EncyclopediaHomeScreen> {
  final _controller = EncyclopediaController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openDetail(int id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoryDetailScreen(
          categoryId: id,
          language: _controller.language,
          starred: _controller.isItemStarred(id),
          onToggleStar: () => _controller.toggleItemStar(id),
        ),
      ),
    );
  }

  void _openFavorites() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => FavoritesScreen(controller: _controller)));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final lang = _controller.language;

        return PopScope(
          canPop: _controller.isCoverShowing,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            _controller.closeToCover();
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Local Bridge', style: TextStyle(fontWeight: FontWeight.w700)),
              leading: IconButton(
                tooltip: 'Favorites',
                onPressed: _openFavorites,
                icon: const Icon(Icons.star_border),
              ),
              actions: [
                TextButton.icon(
                  onPressed: () => showLanguageSheet(context, current: lang, onSelect: _controller.setLanguage),
                  icon: const Icon(Icons.language, size: 16),
                  label: Text(lang.code),
                ),
                const SizedBox(width: 4),
              ],
            ),
            body: Stack(
              children: [
                Positioned.fill(
                  child: BookPageSwitcher(
                    pageKey: _controller.isCoverShowing ? 'cover' : 'toc-${_controller.openGroup}',
                    child: _controller.isCoverShowing
                        ? DecoratedBox(
                            decoration: BookCover.background,
                            child: SingleChildScrollView(
                              child: BookCover(language: lang, onOpenItem: _openDetail),
                            ),
                          )
                        : ColoredBox(
                            color: Colors.white,
                            child: CategoryTocPage(
                              group: categoryGroups[_controller.openGroup]!,
                              language: lang,
                              isStarred: _controller.isItemStarred,
                              onToggleStar: _controller.toggleItemStar,
                              onOpenItem: _openDetail,
                            ),
                          ),
                  ),
                ),
                Positioned(right: 0, top: 24, child: GroupBookmarkRail(controller: _controller)),
              ],
            ),
          ),
        );
      },
    );
  }
}
