import 'package:flutter/material.dart';

/// 진정서/신청서 편집 서식의 사용자 입력값. NavigatorFlowScreen 인스턴스마다
/// 하나씩 만들고 dispose 시 정리한다 — 세션 한정 상태(재시작 시 초기화),
/// UserProfileController/EncyclopediaController와 동일한 인메모리 컨벤션.
class FormValuesController extends ChangeNotifier {
  final Map<String, String> _values = {};

  String valueOf(String key) => _values[key] ?? '';

  void setValue(String key, String value) {
    _values[key] = value;
    notifyListeners();
  }

  /// 여러 필드를 한 번에 덮어쓴다(불러오기 버튼용) — 이미 사용자가 입력해둔 값은
  /// 보존하고, 비어 있는 필드만 채운다.
  void importValues(Map<String, String> values) {
    var changed = false;
    for (final entry in values.entries) {
      if ((_values[entry.key] ?? '').isEmpty && entry.value.isNotEmpty) {
        _values[entry.key] = entry.value;
        changed = true;
      }
    }
    if (changed) notifyListeners();
  }
}
