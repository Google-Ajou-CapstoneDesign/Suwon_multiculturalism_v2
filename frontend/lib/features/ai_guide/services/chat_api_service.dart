import '../../../core/api_client.dart';
import '../models/ai_response.dart';
import '../models/chat_message.dart';

/// POST /api/chat 호출. 백엔드가 의도 분류(직전 대화 참고) 후 에이전트 또는
/// 사전 검수된 정적 문구로 응답한다.
class ChatApiService {
  ChatApiService({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  /// history는 이번 메시지 이전까지의 대화만 담는다(현재 메시지는 [message]로
  /// 따로 보낸다) — 백엔드가 "그럼 저는 어떻게 해야 하나요?" 같은 맥락 의존
  /// 후속 질문을 직전 대화 없이 혼자 보고 엉뚱하게 분류하는 걸 막기 위함이다.
  Future<AiResponse> send(
    String message, {
    List<ChatMessage> history = const [],
  }) async {
    final json = await _client.postJson('/api/chat', {
      'message': message,
      'history': _historyToJson(history),
    });
    return AiResponse.fromJson(json as Map<String, dynamic>);
  }

  List<Map<String, String>> _historyToJson(List<ChatMessage> history) {
    const limit = 6;
    final recent = history.length > limit
        ? history.sublist(history.length - limit)
        : history;
    return recent
        .map(
          (m) => {
            'role': m.isUser ? 'user' : 'assistant',
            'text': m.isUser
                ? (m.text ?? '')
                : (m.aiResponse?.factAnswer ?? m.aiResponse?.riskNotice ?? ''),
          },
        )
        .where((turn) => turn['text']!.isNotEmpty)
        .toList();
  }
}
