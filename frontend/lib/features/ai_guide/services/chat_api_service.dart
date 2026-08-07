import '../../../core/api_client.dart';
import '../models/ai_response.dart';

/// POST /api/chat 호출. 백엔드가 의도 분류 후 사전 검수된 정적 문구로 응답한다.
class ChatApiService {
  ChatApiService({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<AiResponse> send(String message) async {
    final json = await _client.postJson('/api/chat', {'message': message});
    return AiResponse.fromJson(json as Map<String, dynamic>);
  }
}
