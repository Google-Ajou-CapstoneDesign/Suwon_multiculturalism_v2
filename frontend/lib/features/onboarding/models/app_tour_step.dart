import 'package:flutter/widgets.dart';
import '../../../core/app_language.dart';

/// [SpotlightTourOverlay] 한 단계 — 실제 화면에 이미 떠 있는 위젯 하나를
/// [targetKey]로 가리켜 스포트라이트를 비추고, 그 옆에 설명 카드를 띄운다.
/// html_files/frontend_설명서.html의 코치마크 투어와 같은 형식(제목·본문·
/// "왜 중요한지" 팁·단계 표시)을 실제 화면 요소 위에 그대로 구현한 것이다.
class AppTourStep {
  const AppTourStep({
    required this.targetKey,
    required this.title,
    required this.body,
    this.tip,
  });

  /// 이 단계에서 스포트라이트를 비출 실제 위젯의 키.
  final GlobalKey targetKey;
  final L10nText title;
  final L10nText body;

  /// "왜 중요한지" 짧은 팁 — html의 cm-legal-why 파란 박스에 대응. 없으면 생략.
  final L10nText? tip;
}
