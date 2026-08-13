import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// 콘텐츠 텍스트에 섞인 아주 작은 서식만 지원하는 경량 파서. `<b>`(강조)·
/// `<br>`(줄바꿈) 두 태그만 처리한다 — 전체 HTML 렌더러를 들이는 대신, 실제로
/// 콘텐츠(임금계산기 도움말, 백과사전 본문 등)에 쓰이는 두 태그만 가볍게 처리한다.
List<InlineSpan> parseRichSpans(
  String raw, {
  TextStyle? style,
  TextStyle? boldStyle,
}) {
  final spans = <InlineSpan>[];
  final lines = raw.split('<br>');
  final boldPattern = RegExp(r'<b>(.*?)</b>');

  for (var li = 0; li < lines.length; li++) {
    final line = lines[li];
    var last = 0;
    for (final m in boldPattern.allMatches(line)) {
      if (m.start > last) {
        spans.add(TextSpan(text: line.substring(last, m.start)));
      }
      spans.add(
        TextSpan(
          text: m.group(1),
          style: boldStyle ?? const TextStyle(fontWeight: FontWeight.w800),
        ),
      );
      last = m.end;
    }
    if (last < line.length) spans.add(TextSpan(text: line.substring(last)));
    if (li < lines.length - 1) spans.add(const TextSpan(text: '\n'));
  }
  return spans;
}

class RichNote extends StatelessWidget {
  const RichNote(this.raw, {super.key, this.style});
  final String raw;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final base =
        style ??
        const TextStyle(
          fontSize: 11,
          color: AppColors.textSecondary,
          height: 1.6,
        );
    return Text.rich(
      TextSpan(
        style: base,
        children: parseRichSpans(raw, style: base),
      ),
    );
  }
}
