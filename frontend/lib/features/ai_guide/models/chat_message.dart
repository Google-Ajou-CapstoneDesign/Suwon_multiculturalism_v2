import 'ai_response.dart';

class ChatMessage {
  const ChatMessage.user(this.text) : aiResponse = null, isUser = true;
  const ChatMessage.bot(this.aiResponse) : text = null, isUser = false;

  final bool isUser;
  final String? text;
  final AiResponse? aiResponse;
}
