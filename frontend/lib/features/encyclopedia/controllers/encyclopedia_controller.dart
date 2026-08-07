import 'package:flutter/foundation.dart';
import '../models/app_language.dart';
import '../models/category_item.dart';

/// 백과사전 탭 하나가 공유하는 상태: 언어, 즐겨찾기, 현재 열려 있는 그룹(표지/목차 전환).
/// 앱 전역이 아니라 이 탭 범위로만 스코프한다 — 다른 탭에는 다국어를 아직 적용하지 않는다.
class EncyclopediaController extends ChangeNotifier {
  AppLanguage _language = AppLanguage.ko;
  AppLanguage get language => _language;

  CategoryGroupId? _openGroup;
  CategoryGroupId? get openGroup => _openGroup;
  bool get isCoverShowing => _openGroup == null;

  final Set<int> _starredItems = {1, 11};
  Set<int> get starredItems => Set.unmodifiable(_starredItems);

  final Set<CategoryGroupId> _starredGroups = {CategoryGroupId.c};
  Set<CategoryGroupId> get starredGroups => Set.unmodifiable(_starredGroups);

  void setLanguage(AppLanguage lang) {
    if (_language == lang) return;
    _language = lang;
    notifyListeners();
  }

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
