import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// 웹/데스크톱처럼 화면이 넓은 환경에서 모바일 폭 UI가 가로로 늘어나 보이지 않도록,
/// 화면 가운데에 [maxContentWidth] 폭으로 고정하고 나머지 영역은 배경으로 채운다.
/// 실제 모바일 기기(화면 폭이 [maxContentWidth] 이하)에서는 아무 효과가 없다.
class WebCenteredFrame extends StatelessWidget {
  const WebCenteredFrame({super.key, required this.child, this.maxContentWidth = 480});

  final Widget child;
  final double maxContentWidth;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.border,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.10), blurRadius: 24),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
