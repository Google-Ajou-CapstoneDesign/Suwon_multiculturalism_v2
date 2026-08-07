import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../screens/chat_screen.dart';

/// 우측 하단 AI 버블로 여닫는 챗봇 시트. WorkLogSheet와 같은 슬라이드업 패턴이며,
/// 하단 탭바는 가리지 않고 그대로 남겨둔다.
class AiChatSheet extends StatelessWidget {
  const AiChatSheet({super.key, required this.isOpen, required this.onClose});

  final bool isOpen;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isOpen,
      child: AnimatedSlide(
        offset: isOpen ? Offset.zero : const Offset(0, 1),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        child: Material(
          color: AppColors.background,
          child: SafeArea(top: false, child: ChatScreen(onClose: onClose)),
        ),
      ),
    );
  }
}
