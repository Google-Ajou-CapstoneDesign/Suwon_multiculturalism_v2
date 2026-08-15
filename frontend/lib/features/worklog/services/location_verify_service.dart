import '../../../core/api_client.dart';

/// POST /api/location/verify 응답. 사업장 좌표가 등록돼 있지 않아 지오펜싱은
/// 하지 않는다 — [verified]는 "그럴듯한 좌표가 실제로 수신됐는지"만 뜻한다.
class LocationVerifyResult {
  const LocationVerifyResult({
    required this.verified,
    required this.latitude,
    required this.longitude,
  });

  final bool verified;
  final double latitude;
  final double longitude;
}

class LocationVerifyService {
  LocationVerifyService({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<LocationVerifyResult> verify({
    required double latitude,
    required double longitude,
    double? accuracyM,
  }) async {
    final json = await _client.postJson('/api/location/verify', {
      'latitude': latitude,
      'longitude': longitude,
      'accuracyM': ?accuracyM,
    });
    final map = json as Map<String, dynamic>;
    return LocationVerifyResult(
      verified: map['verified'] as bool,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
    );
  }
}
