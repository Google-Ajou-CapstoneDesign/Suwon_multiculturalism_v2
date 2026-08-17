import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/api_client.dart';
import '../../../core/app_language.dart';
import '../models/ai_response.dart';
import '../models/chat_message.dart';

/// POST /api/chat 호출. 백엔드가 의도 분류(직전 대화 참고) 후 에이전트 또는
/// 사전 검수된 정적 문구로 응답한다.
class ChatApiService {
  ChatApiService({ApiClient? client, ChatLocationProvider? locationProvider})
    : _client = client ?? ApiClient(),
      _locationProvider = locationProvider ?? _readCurrentLocation;

  final ApiClient _client;
  final ChatLocationProvider _locationProvider;
  Future<ChatLocation?>? _locationFuture;

  /// history는 이번 메시지 이전까지의 대화만 담는다(현재 메시지는 [message]로
  /// 따로 보낸다) — 백엔드가 "그럼 저는 어떻게 해야 하나요?" 같은 맥락 의존
  /// 후속 질문을 직전 대화 없이 혼자 보고 엉뚱하게 분류하는 걸 막기 위함이다.
  ///
  /// [language]는 앱의 현재 언어 설정이다 — 사용자가 메시지를 어떤 언어로
  /// 썼든 답변은 이 설정을 따라야 하므로, 메시지 언어 자동 감지에 맡기지 않고
  /// 매번 명시적으로 함께 보낸다.
  Future<AiResponse> send(
    String message, {
    required AppLanguage language,
    List<ChatMessage> history = const [],
  }) async {
    // 한 채팅 세션에서는 위치 권한을 한 번만 확인한다. 권한 거부나 위치 서비스
    // 비활성화는 채팅 자체를 막지 않고, 백엔드가 거리 없음(null)으로 응답한다.
    final location = await (_locationFuture ??= _loadLocation());
    final json = await _client.postJson('/api/chat', {
      'message': message,
      'history': _historyToJson(history),
      'language': language.name,
      'latitude': ?location?.latitude,
      'longitude': ?location?.longitude,
    });
    return AiResponse.fromJson(json as Map<String, dynamic>);
  }

  Future<ChatLocation?> _loadLocation() async {
    try {
      return await _locationProvider();
    } catch (error) {
      debugPrint('추천 기관 거리 계산용 현재 위치 확인 실패: $error');
      return null;
    }
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

class ChatLocation {
  const ChatLocation({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

typedef ChatLocationProvider = Future<ChatLocation?> Function();

Future<ChatLocation?> _readCurrentLocation() async {
  if (!await Geolocator.isLocationServiceEnabled()) return null;

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    return null;
  }

  final position = await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
  );
  return ChatLocation(
    latitude: position.latitude,
    longitude: position.longitude,
  );
}
