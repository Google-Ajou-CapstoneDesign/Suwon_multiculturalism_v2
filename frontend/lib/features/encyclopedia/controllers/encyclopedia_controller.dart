import 'package:flutter/foundation.dart';
import '../models/category_item.dart';

/// 백과사전 탭 하나가 공유하는 상태: 즐겨찾기, 현재 열려 있는 그룹(표지/목차 전환).
/// 언어는 더 이상 이 컨트롤러가 들고 있지 않는다 — 앱 전역 UserProfileController가
/// 유일한 출처이고(홈 화면의 언어 전환 버튼에서 바꾼다), 화면들은 그때그때
/// UserProfileScope.of(context).language를 읽는다.
class EncyclopediaController extends ChangeNotifier {
  CategoryGroupId? _openGroup;
  CategoryGroupId? get openGroup => _openGroup;
  bool get isCoverShowing => _openGroup == null;

  final Set<int> _starredItems = {1, 9};
  Set<int> get starredItems => Set.unmodifiable(_starredItems);

  final Set<CategoryGroupId> _starredGroups = {CategoryGroupId.c};
  Set<CategoryGroupId> get starredGroups => Set.unmodifiable(_starredGroups);

  void openGroupPage(CategoryGroupId group) {
    _openGroup = group;
    notifyListeners();
  }

  void closeToCover() {
    _openGroup = null;
    notifyListeners();
  }

  void toggleGroup(CategoryGroupId group) {
    if (_openGroup == group) {
      closeToCover();
    } else {
      openGroupPage(group);
    }
  }

  bool isItemStarred(int id) => _starredItems.contains(id);

  void toggleItemStar(int id) {
    if (!_starredItems.add(id)) _starredItems.remove(id);
    notifyListeners();
  }

  bool isGroupStarred(CategoryGroupId group) => _starredGroups.contains(group);

  void toggleGroupStar(CategoryGroupId group) {
    if (!_starredGroups.add(group)) _starredGroups.remove(group);
    notifyListeners();
  }
}
