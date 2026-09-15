import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../core/api_client.dart';
import '../../../core/api_config.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';
import '../../worklog/screens/accident_navigator_screen.dart';
import '../../worklog/screens/wage_navigator_screen.dart';
import '../models/ai_response.dart';
import '../models/chat_message.dart';
import '../services/chat_api_service.dart';
import '../widgets/ai_response_card.dart';

class _ChatStrings {
  _ChatStrings._();

  static const title = L10nText(
    ko: 'AI 가이드',
    en: 'AI Guide',
    zh: 'AI引导',
    vi: 'Trợ lý AI',
    uz: "AI Yordamchi",
  );
  static const close = L10nText(
    ko: '닫기',
    en: 'Close',
    zh: '关闭',
    vi: 'Đóng',
    uz: "Yopish",
  );
  static const emptyTitle = L10nText(
    ko: '무엇이든 물어보세요',
    en: 'Ask me anything',
    zh: '请随时提问',
    vi: 'Hỏi bất cứ điều gì',
    uz: "Mendan istalgan narsani soʻrang",
  );
  static const emptySubtitle = L10nText(
    ko: '임금·체불, 산업재해, 근로계약서 등 노동 관련 궁금한 점을 편하게 물어보세요.',
    en: 'Feel free to ask about wages, unpaid pay, workplace injuries, employment contracts, and other labor topics.',
    zh: '关于工资、欠薪、工伤、劳动合同等劳动相关问题，请随时提问。',
    vi: 'Hãy thoải mái hỏi về lương, nợ lương, tai nạn lao động, hợp đồng lao động và các vấn đề lao động khác.',
    uz: "Ish haqi, toʻlanmagan ish haqi, ish joyidagi jarohatlar, mehnat shartnomalari va boshqa mehnat mavzulari haqida bemalol soʻrang.",
  );
  static const inputHint = L10nText(
    ko: '메시지를 입력하세요',
    en: 'Type a message',
    zh: '请输入消息',
    vi: 'Nhập tin nhắn',
    uz: "Xabar yozing",
  );
  static const serverError = L10nText(
    ko: '서버에 연결할 수 없어요. 잠시 후 다시 시도해 주세요.',
    en: 'Could not connect to the server. Please try again shortly.',
    zh: '无法连接服务器，请稍后重试。',
    vi: 'Không thể kết nối máy chủ. Vui lòng thử lại sau.',
    uz: "Serverga ulanib boʻlmadi. Iltimos, birozdan keyin qayta urinib koʻring.",
  );
  static const wait = L10nText(
    ko: '{seconds}초 후 다시 전송할 수 있어요.',
    en: 'You can send again in {seconds} seconds.',
    zh: '{seconds}秒后可以再次发送。',
    vi: 'Bạn có thể gửi lại sau {seconds} giây.',
    uz: '{seconds} soniyadan keyin yana yuborishingiz mumkin.',
  );
  static const daily = L10nText(
    ko: '오늘의 AI 이용 한도에 도달했어요. 한국 시간 자정에 초기화됩니다.',
    en: 'You have reached your daily AI limit. It resets at midnight in Korea.',
    zh: '已达到今日AI使用上限，将在韩国时间午夜重置。',
    vi: 'Bạn đã đạt giới hạn AI hôm nay. Giới hạn đặt lại lúc nửa đêm giờ Hàn Quốc.',
    uz: 'Bugungi AI limitiga yetdingiz. Limit Koreya vaqti bilan yarim tunda yangilanadi.',
  );
  static const tooLong = L10nText(
    ko: '메시지는 2,000자 이내로 입력해 주세요.',
    en: 'Please keep your message within 2,000 characters.',
    zh: '消息请勿超过2,000个字符。',
    vi: 'Vui lòng nhập tin nhắn không quá 2.000 ký tự.',
    uz: 'Xabaringiz 2 000 belgidan oshmasin.',
  );
}

/// AI 가이드 챗봇. 라이트 라우팅 기반 안내 화면.
/// 하단 탭이 아니라 우측 하단 AI 버블 → 슬라이드업 시트로 진입한다(AiChatSheet).
/// 사용자가 보내는 메시지는 실제 백엔드(POST /api/chat)를 호출한다.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, this.onClose, this.chatApi});

  final ChatApiService? chatApi;

  /// 시트로 띄워졌을 때 닫기 버튼에 연결한다. null이면 닫기 버튼을 숨긴다.
  final VoidCallback? onClose;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late final _chatApi = widget.chatApi ?? ChatApiService();
  bool _isSending = false;
  Timer? _retryTimer;
  DateTime? _retryAt;
  bool _dailyLimit = false;
  L10nText? _error;
  String? _actorUid;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uid = UserProfileScope.of(context).uid;
    if (_actorUid != uid) {
      _actorUid = uid;
      _retryTimer?.cancel();
      _retryAt = null;
      _dailyLimit = false;
      _error = null;
    }
  }

  int get _remaining => _retryAt == null
      ? 0
      : ((_retryAt!.difference(DateTime.now()).inMilliseconds / 1000).ceil())
            .clamp(0, 86400);

  void _startLimit(Map<String, dynamic> detail) {
    final seconds = (detail['retryAfterSeconds'] as num?)?.toInt() ?? 5;
    _retryAt = DateTime.now().add(Duration(seconds: seconds.clamp(1, 86400)));
    _dailyLimit = detail['reason'] == 'daily';
    _retryTimer?.cancel();
    _retryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_remaining == 0) {
          _retryAt = null;
          _dailyLimit = false;
          timer.cancel();
        }
      });
    });
  }

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
    if (text.isEmpty || _isSending || _remaining > 0) return;
    if (text.runes.length > 2000) {
      setState(() => _error = _ChatStrings.tooLong);
      return;
    }

    // 지금까지의 대화(직전 턴들)를 먼저 스냅샷 떠둔다 — 새 사용자 메시지를
    // 리스트에 추가하기 전이라야 "현재 메시지 이전까지의 이력"이 된다.
    final history = List<ChatMessage>.unmodifiable(_messages);

    setState(() {
      _messages.add(ChatMessage.user(text));
      _isSending = true;
      _error = null;
    });
    _scrollToBottom();

    try {
      if (!mounted) return;
      final language = UserProfileScope.of(context).language;
      final response = await _chatApi.send(
        text,
        language: language,
        history: history,
      );
      if (!mounted) return;
      _controller.clear();
      setState(() => _messages.add(ChatMessage.bot(response)));
    } catch (e) {
      // ApiConfig.baseUrl(디버그 콘솔에 출력)이 의도한 배포 주소가 맞는지부터 확인할 것 —
      // dart-define 없이 실행하면 로컬 기본값(localhost:8080)으로 떨어져 항상 여기로 온다.
      debugPrint('POST /api/chat 실패 (baseUrl=${ApiConfig.baseUrl}): $e');
      if (!mounted) return;
      setState(() {
        _messages.removeLast();
        _error = _ChatStrings.serverError;
        if (e is ApiException && e.statusCode == 429) {
          try {
            final detail = jsonDecode(e.body)['detail'] as Map<String, dynamic>;
            _startLimit(detail);
            _error = null;
          } catch (_) {
            /* Keep the generic error for malformed responses. */
          }
        }
      });
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
        _scrollToBottom();
      }
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
    _retryTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = UserProfileScope.of(context).language;

    return Scaffold(
      appBar: AppBar(
        title: Text(_ChatStrings.title.of(lang)),
        automaticallyImplyLeading: false,
        actions: [
          if (widget.onClose != null)
            IconButton(
              onPressed: widget.onClose,
              icon: const Icon(Icons.close),
              tooltip: _ChatStrings.close.of(lang),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty && !_isSending
                ? _EmptyState(language: lang)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_isSending ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (i == _messages.length) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: _TypingBubble(),
                        );
                      }
                      final message = _messages[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: message.isUser
                            ? _UserBubble(text: message.text!)
                            : AiResponseCard(
                                response: message.aiResponse!,
                                language: lang,
                                onRoutingTap: _openRouting,
                              ),
                      );
                    },
                  ),
          ),
          if (_error != null || _remaining > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                _error?.of(lang) ??
                    (_dailyLimit
                        ? _ChatStrings.daily.of(lang)
                        : _ChatStrings.wait
                              .of(lang)
                              .replaceAll('{seconds}', '$_remaining')),
                style: const TextStyle(color: AppColors.textMuted),
              ),
            ),
          _ChatInputBar(
            controller: _controller,
            onSend: _send,
            isSending: _isSending,
            isLimited: _remaining > 0,
            language: lang,
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.language});
  final AppLanguage language;

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
            Text(
              _ChatStrings.emptyTitle.of(language),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _ChatStrings.emptySubtitle.of(language),
              textAlign: TextAlign.center,
              style: const TextStyle(
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

/// AI 답변을 기다리는 동안 보여주는 말풍선 — 세 점이 순서대로 밝아졌다 어두워지며
/// "생성 중"임을 나타낸다.
class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
            bottomRight: Radius.circular(14),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                final t = (_controller.value - i * 0.2) % 1.0;
                final peak = (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Opacity(
                    opacity: 0.25 + 0.75 * peak,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.textMuted,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
            );
          },
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
    required this.isLimited,
    required this.language,
  });
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isSending;
  final bool isLimited;
  final AppLanguage language;

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
                  maxLength: 2000,
                  decoration: InputDecoration(
                    hintText: _ChatStrings.inputHint.of(language),
                  ),
                  onSubmitted: (_) => onSend(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: isSending || isLimited ? null : onSend,
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
