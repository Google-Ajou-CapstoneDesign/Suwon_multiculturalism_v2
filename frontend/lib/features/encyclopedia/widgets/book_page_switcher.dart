import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 표지 ⇄ 목차 전환을 감싸는 공용 "페이지" 프레임.
/// 표지든 목차든 항상 같은 크기·모서리 둥근 사각형 안에 들어가고, 전환 시에는
/// 오른쪽 북마크 쪽을 책등(spine) 삼아 페이지를 넘기는 듯한 3D 회전으로 바뀐다.
class BookPageSwitcher extends StatelessWidget {
  const BookPageSwitcher({
    super.key,
    required this.pageKey,
    required this.child,
  });

  /// 이 값이 바뀔 때만 넘기는 애니메이션이 트리거된다(표지="cover", 목차="toc-A" 등).
  final Object pageKey;
  final Widget child;

  static const _radius = 20.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 26,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_radius),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 420),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            layoutBuilder: (currentChild, previousChildren) {
              // Positioned.fill로 강제해, 콘텐츠 길이와 무관하게 두 상태 모두
              // 프레임을 정확히 꽉 채우게 한다(안 그러면 짧은 페이지가 프레임보다 작게 보일 수 있음).
              return Stack(
                children: [
                  for (final previous in previousChildren)
                    Positioned.fill(child: previous),
                  if (currentChild != null)
                    Positioned.fill(child: currentChild),
                ],
              );
            },
            transitionBuilder: (widgetChild, animation) {
              return AnimatedBuilder(
                animation: animation,
                child: widgetChild,
                builder: (context, animatedChild) {
                  // 0(옆으로 세워짐, 책등에 붙은 상태) → 1(평평하게 펼쳐짐)
                  final angle = (1 - animation.value) * math.pi / 2.2;
                  return Opacity(
                    opacity: animation.value.clamp(0, 1),
                    child: Transform(
                      alignment: Alignment.centerRight, // 오른쪽 북마크 쪽이 책등
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.0012)
                        ..rotateY(-angle),
                      child: animatedChild,
                    ),
                  );
                },
              );
            },
            child: KeyedSubtree(key: ValueKey(pageKey), child: child),
          ),
        ),
      ),
    );
  }
}
