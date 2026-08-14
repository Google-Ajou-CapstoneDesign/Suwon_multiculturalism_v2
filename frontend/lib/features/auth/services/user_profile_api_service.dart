import '../../../core/api_client.dart';

/// 백엔드 GET/PUT /api/users/me — 회원가입·로그인 후 프로필을 만들거나 가져온다.
class UserProfileApiService {
  UserProfileApiService({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<Map<String, dynamic>> upsertProfile({
    required String idToken,
    required String name,
    String? visaType,
    String? nationality,
    required String preferredLanguage,
  }) async {
    final json = await _client.putJson('/api/users/me', {
      'name': name,
      'visaType': visaType,
      'nationality': nationality,
      'preferredLanguage': preferredLanguage,
    }, idToken: idToken);
    return json as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>?> fetchProfile({required String idToken}) async {
    final json = await _client.getJson('/api/users/me', idToken: idToken);
    return json as Map<String, dynamic>?;
  }
}
