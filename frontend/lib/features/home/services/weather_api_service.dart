import '../../../core/api_client.dart';
import '../models/weather_info.dart';

/// 백엔드 GET /api/weather — 로그인 여부와 무관하게 누구나 호출 가능한 공개
/// 엔드포인트라 idToken이 필요 없다.
class WeatherApiService {
  WeatherApiService({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<WeatherInfo> fetchSuwonWeather() async {
    final json = await _client.getJson('/api/weather');
    return WeatherInfo.fromJson(json as Map<String, dynamic>);
  }
}
