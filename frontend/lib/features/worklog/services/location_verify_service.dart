import 'package:geolocator/geolocator.dart';

import '../../../core/api_client.dart';

enum LocationVerifyStatus {
  verified,
  serviceDisabled,
  permissionDenied,
  rejected,
  error,
}

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

  /// 기기 위치 권한 확인부터 백엔드 검증까지 홈과 캘린더가 공유하는 전체 흐름.
  Future<LocationVerifyStatus> verifyCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return LocationVerifyStatus.serviceDisabled;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return LocationVerifyStatus.permissionDenied;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      final result = await verify(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracyM: position.accuracy,
      );
      return result.verified
          ? LocationVerifyStatus.verified
          : LocationVerifyStatus.rejected;
    } catch (_) {
      return LocationVerifyStatus.error;
    }
  }

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
