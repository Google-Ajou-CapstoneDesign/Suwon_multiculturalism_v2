import 'package:flutter/material.dart';
import '../../../common/models/org.dart';
import '../../../core/api_config.dart';
import '../../../theme/app_colors.dart';
import '../../worklog/screens/accident_navigator_screen.dart';
import '../../worklog/screens/wage_navigator_screen.dart';
import '../models/ai_response.dart';
import '../models/chat_message.dart';
import '../services/chat_api_service.dart';
import '../widgets/ai_response_card.dart';

/// Tab 2 · AI 가이드 챗봇. 라이트 라우팅 기반 안내 화면.
/// 최초 노출되는 대화 한 쌍은 UI 시안(UI3.png)을 보여주기 위한 고정 예시이고,
/// 이후 사용자가 보내는 메시지는 실제 백엔드(POST /api/chat)를 호출한다.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _chatApi = ChatApiService();
  bool _isSending = false;

  final List<ChatMessage> _messages = [
    const ChatMessage.user('임금 못받은지 3주됐어요 어떻게 해요?'),
    ChatMessage.bot(
      const AiResponse(
        factAnswer: '근로기준법상 사용자는 퇴직·지급일로부터 14일 이내에 임금을 지급해야 해요. 이미 기간이 지났다면 진정 제기가 가능해요.',
        riskNotice: '즉시 대응이 필요한 사안으로 보여요. 정확한 판단은 AI가 아닌 아래 네비게이터·전문가를 통해 확인해 주세요.',
        routingTarget: RoutingTarget(RoutingModule.module3Wage),
        recommendedOrgs: [
          Org(name: '경기지방고용노동청 수원지청', distanceKm: 2.4),
          Org(name: '수원시비정규직노동자복지센터', distanceKm: 1.1),
        ],
      ),
    ),
  ];

  void _openRouting(RoutingTarget target) {
    switch (target.module) {
      case RoutingModule.module3Wage:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WageNavigatorScreen()));
        break;
      case RoutingModule.module3Accident:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AccidentNavigatorScreen()));
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
      setState(() => _messages.add(
            const ChatMessage.bot(
              AiResponse(riskNotice: '서버에 연결할 수 없어요. 잠시 후 다시 시도해 주세요.'),
            ),
          ));
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
      appBar: AppBar(title: const Text('AI 가이드')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final message = _messages[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: message.isUser
                      ? _UserBubble(text: message.text!)
                      : AiResponseCard(response: message.aiResponse!, onRoutingTap: _openRouting),
                );
              },
            ),
          ),
          _ChatInputBar(controller: _controller, onSend: _send, isSending: _isSending),
        ],
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
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
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
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 13)),
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar({required this.controller, required this.onSend, required this.isSending});
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
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
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
