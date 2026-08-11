import 'package:flutter/material.dart';
import '../../../core/api_config.dart';
import '../../../theme/app_colors.dart';
import '../../worklog/screens/accident_navigator_screen.dart';
import '../../worklog/screens/wage_navigator_screen.dart';
import '../models/ai_response.dart';
import '../models/chat_message.dart';
import '../services/chat_api_service.dart';
import '../widgets/ai_response_card.dart';

/// AI 가이드 챗봇. 라이트 라우팅 기반 안내 화면.
/// 하단 탭이 아니라 우측 하단 AI 버블 → 슬라이드업 시트로 진입한다(AiChatSheet).
/// 사용자가 보내는 메시지는 실제 백엔드(POST /api/chat)를 호출한다.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, this.onClose});

  /// 시트로 띄워졌을 때 닫기 버튼에 연결한다. null이면 닫기 버튼을 숨긴다.
  final VoidCallback? onClose;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _chatApi = ChatApiService();
  bool _isSending = false;

  final List<ChatMessage> _messages = [];

  void _openRouting(RoutingTarget target) {
    switch (target.module) {
      case RoutingModule.module3Wage:
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const WageNavigatorScreen()));
        break;
      case RoutingModule.module3Accident:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AccidentNavigatorScreen()),
        );
        break;
      case RoutingModule.module1:
        Navigator.of(context).pop(); // 백과사전 탭으로 안내 (P1: 카테고리 딥링크 연결)
        break;
    }
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _messages.add(ChatMessage.user(text));
      _isSending = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final response = await _chatApi.send(text);
      setState(() => _messages.add(ChatMessage.bot(response)));
    } catch (e) {
      // ApiConfig.baseUrl(디버그 콘솔에 출력)이 의도한 배포 주소가 맞는지부터 확인할 것 —
      // dart-define 없이 실행하면 로컬 기본값(localhost:8080)으로 떨어져 항상 여기로 온다.
      debugPrint('POST /api/chat 실패 (baseUrl=${ApiConfig.baseUrl}): $e');
      setState(
        () => _messages.add(
          const ChatMessage.bot(
            AiResponse(riskNotice: '서버에 연결할 수 없어요. 잠시 후 다시 시도해 주세요.'),
          ),
        ),
      );
    } finally {
      setState(() => _isSending = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 가이드'),
        automaticallyImplyLeading: false,
        actions: [
          if (widget.onClose != null)
            IconButton(
              onPressed: widget.onClose,
              icon: const Icon(Icons.close),
              tooltip: '닫기',
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const _EmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, i) {
                      final message = _messages[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: message.isUser
                            ? _UserBubble(text: message.text!)
                            : AiResponseCard(
                                response: message.aiResponse!,
                                onRoutingTap: _openRouting,
                              ),
                      );
                    },
                  ),
          ),
          _ChatInputBar(
            controller: _controller,
            onSend: _send,
            isSending: _isSending,
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.blueBg,
                shape: BoxShape.circle,
              ),
              child: const Text('🧭', style: TextStyle(fontSize: 22)),
            ),
            const SizedBox(height: 14),
            const Text(
              '무엇이든 물어보세요',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '임금·체불, 산업재해, 근로계약서 등 노동 관련 궁금한 점을 편하게 물어보세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                color: AppColors.textMuted,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
            bottomLeft: Radius.circular(14),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar({
    required this.controller,
    required this.onSend,
    required this.isSending,
  });
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isSending;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: !isSending,
                  decoration: const InputDecoration(hintText: '메시지를 입력하세요'),
                  onSubmitted: (_) => onSend(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: isSending ? null : onSend,
                style: IconButton.styleFrom(backgroundColor: AppColors.primary),
                icon: isSending
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
