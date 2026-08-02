import 'package:flutter/material.dart';
import '../../../common/models/org.dart';
import '../../../theme/app_colors.dart';
import '../../worklog/screens/accident_navigator_screen.dart';
import '../../worklog/screens/wage_navigator_screen.dart';
import '../models/ai_response.dart';
import '../models/chat_message.dart';
import '../widgets/ai_response_card.dart';

/// Tab 2 · AI 가이드 챗봇. 라이트 라우팅 기반 안내 화면.
/// TODO(backend): 메시지 전송 시 POST /chat 호출, 규칙 기반 에이전트 응답을 AiResponse로 렌더링.
/// 지금은 UI 시안(UI3.png)과 동일한 데모 대화를 정적 목데이터로 보여준다.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

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

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage.user(text));
      // TODO(backend): 실제 에이전트 응답으로 교체. 지금은 데모용 고정 응답.
      _messages.add(
        const ChatMessage.bot(
          AiResponse(
            factAnswer: '관련 정보를 정리해 뒀어요 — 백과사전 탭에서 자세히 확인할 수 있어요.',
            recommendedOrgs: [Org(name: '수원시비정규직노동자복지센터', distanceKm: 1.1)],
          ),
        ),
      );
    });
    _controller.clear();
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
          _ChatInputBar(controller: _controller, onSend: _send),
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
  const _ChatInputBar({required this.controller, required this.onSend});
  final TextEditingController controller;
  final VoidCallback onSend;

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
                  decoration: const InputDecoration(hintText: '메시지를 입력하세요'),
                  onSubmitted: (_) => onSend(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: onSend,
                style: IconButton.styleFrom(backgroundColor: AppColors.primary),
                icon: const Icon(Icons.send, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
