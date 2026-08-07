import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';

/// 백엔드가 2xx 이외를 반환했을 때 던지는 예외.
class ApiException implements Exception {
  ApiException(this.statusCode, this.body);

  final int statusCode;
  final String body;

  @override
  String toString() => 'ApiException($statusCode): $body';
}

/// Local Bridge 백엔드(Cloud Run) 공용 HTTP 클라이언트.
/// 베이스 URL은 [ApiConfig]에서 가져오며, 여기서는 하드코딩하지 않는다.
///
/// TODO(auth): Firebase Auth 연동 후, 인증이 필요한 엔드포인트
/// (/api/wage/*, /api/uploads)에는 `Authorization: Bearer` + ID 토큰 헤더를 추가해야 한다.
class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static final Uri _base = Uri.parse(ApiConfig.baseUrl);

  Future<dynamic> postJson(String path, Map<String, dynamic> body) async {
    final response = await _client.post(
      _base.replace(path: path),
      headers: const {'Content-Type': 'application/json; charset=utf-8'},
      body: jsonEncode(body),
    );
    return _decode(response);
  }

  Future<dynamic> getJson(String path, {Map<String, String>? query}) async {
    final uri = _base.replace(path: path, queryParameters: query);
    final response = await _client.get(uri);
    return _decode(response);
  }

  dynamic _decode(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    throw ApiException(response.statusCode, response.body);
  }

  void dispose() => _client.close();
}
