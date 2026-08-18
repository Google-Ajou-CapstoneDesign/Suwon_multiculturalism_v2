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

  /// 사업주 공식 증빙 보관함(계약서/명세서) 등록 여부를 서버에 반영한다.
  /// 둘 다 optional이라 바꾸고 싶은 항목만 보내면 된다.
  Future<Map<String, dynamic>> updateVaultStatus({
    required String idToken,
    bool? contractStored,
    bool? payslipStored,
  }) async {
    final json = await _client.patchJson('/api/users/me/vault', {
      'contractStored': ?contractStored,
      'payslipStored': ?payslipStored,
    }, idToken: idToken);
    return json as Map<String, dynamic>;
  }
}
