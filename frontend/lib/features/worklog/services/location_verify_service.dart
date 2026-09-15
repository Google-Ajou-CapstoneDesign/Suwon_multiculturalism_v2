import 'package:geolocator/geolocator.dart';

import '../../../core/api_client.dart';
import '../../../core/app_language.dart';

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
    this.address,
  });

  final bool verified;
  final double latitude;
  final double longitude;

  /// 서버가 역지오코딩으로 변환해 돌려준 주소 문자열. 좌표는 항상 오지만,
  /// 지오코딩 API 장애 등으로 이 값만 없을 수 있다(null) — 그럴 땐 화면에
  /// 좌표 숫자 대신 아무것도 보여주지 않는다(판정하지 않고 사실만 기록한다는
  /// 원칙상 좌표를 그대로 노출하지는 않는다).
  final String? address;
}

/// [LocationVerifyService.verifyCurrentLocation]의 반환값 — 상태와 함께,
/// verified일 때만 실제 좌표([result])를 같이 돌려준다. 호출부가 상태로
/// 분기하면서도 성공 시엔 화면에 인증된 위치를 그대로 표시할 수 있게 한다.
class LocationVerifyOutcome {
  const LocationVerifyOutcome(this.status, [this.result]);

  final LocationVerifyStatus status;
  final LocationVerifyResult? result;
}

class LocationVerifyService {
  LocationVerifyService({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  /// 기기 위치 권한 확인부터 백엔드 검증까지 홈과 캘린더가 공유하는 전체 흐름.
  /// [language]는 서버가 주소 문자열을 어떤 언어로 돌려줄지 정한다 — 앱의
  /// 현재 언어 설정을 그대로 넘긴다.
  Future<LocationVerifyOutcome> verifyCurrentLocation({
    required AppLanguage language,
  }) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const LocationVerifyOutcome(
          LocationVerifyStatus.serviceDisabled,
        );
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return const LocationVerifyOutcome(
          LocationVerifyStatus.permissionDenied,
        );
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
        language: language,
      );
      return result.verified
          ? LocationVerifyOutcome(LocationVerifyStatus.verified, result)
          : LocationVerifyOutcome(LocationVerifyStatus.rejected, result);
    } catch (_) {
      return const LocationVerifyOutcome(LocationVerifyStatus.error);
    }
  }

  Future<LocationVerifyResult> verify({
    required double latitude,
    required double longitude,
    double? accuracyM,
    required AppLanguage language,
  }) async {
    final json = await _client.postJson('/api/location/verify', {
      'latitude': latitude,
      'longitude': longitude,
      'accuracyM': ?accuracyM,
      'language': language.name,
    });
    final map = json as Map<String, dynamic>;
    return LocationVerifyResult(
      verified: map['verified'] as bool,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      address: map['address'] as String?,
    );
  }
}
