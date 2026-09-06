import 'package:flutter/material.dart';

String? _timeToHm(TimeOfDay? time) => time == null
    ? null
    : '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

TimeOfDay? _timeFromHm(String? value) {
  if (value == null) return null;
  final parts = value.split(':');
  return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
}

/// 하루치 근무기록. 임금체불·산재 신고의 1차 증거로 쓰인다.
class DailyWorkRecord {
  const DailyWorkRecord({
    this.clockIn,
    this.clockOut,
    this.breakMinutes = 0,
    this.memo = '',
    this.isOvertime = false,
    this.isRisk = false,
    this.gpsVerified = false,
    this.verifiedLatitude,
    this.verifiedLongitude,
    this.verifiedAddress,
  });

  static const empty = DailyWorkRecord();

  final TimeOfDay? clockIn;
  final TimeOfDay? clockOut;
  final int breakMinutes;
  final String memo;

  /// 연장·야간 근무 여부(달력 점 표시용).
  final bool isOvertime;

  /// 급여 미지급 의심 등 주의가 필요한 날(달력 빨간 테두리 표시용).
  final bool isRisk;

  /// 사업장 위치에서 기록됐는지 — 판정하지 않고 사실만 기록한다는 원칙에 따라
  /// "위치 인증 완료" / "사업장 외부 기록" 두 상태만 둔다.
  final bool gpsVerified;

  /// 위치 인증 성공 시점의 좌표(POST /api/location/verify가 돌려준 값을 그대로
  /// 보관). gpsVerified == false거나 인증 이전 기록이면 null. 화면에는 좌표
  /// 숫자 대신 [verifiedAddress]를 보여준다 — 증빙용 원본 값이라 계속 갖고
  /// 있는다.
  final double? verifiedLatitude;
  final double? verifiedLongitude;

  /// 서버가 좌표를 역지오코딩해 돌려준 주소 문자열. 지오코딩 실패 시 null일
  /// 수 있다 — 그럴 땐 화면에서 "위치 인증 완료" 문구만 보여주고 주소는
  /// 생략한다.
  final String? verifiedAddress;

  bool get hasEntry => clockIn != null && clockOut != null;

  Duration get workedDuration {
    if (clockIn == null || clockOut == null) return Duration.zero;
    final startMinutes = clockIn!.hour * 60 + clockIn!.minute;
    final endMinutes = clockOut!.hour * 60 + clockOut!.minute;
    final minutes = (endMinutes - startMinutes) - breakMinutes;
    return Duration(minutes: minutes < 0 ? 0 : minutes);
  }

  /// 백엔드 GET/PUT /api/worklog/days 응답(worklogs 문서)을 그대로 반영한다.
  factory DailyWorkRecord.fromJson(Map<String, dynamic> json) => DailyWorkRecord(
    clockIn: _timeFromHm(json['clockIn'] as String?),
    clockOut: _timeFromHm(json['clockOut'] as String?),
    breakMinutes: json['breakMinutes'] as int? ?? 0,
    memo: json['memo'] as String? ?? '',
    isOvertime: json['isOvertime'] as bool? ?? false,
    isRisk: json['isRisk'] as bool? ?? false,
    gpsVerified: json['gpsVerified'] as bool? ?? false,
    verifiedLatitude: (json['verifiedLatitude'] as num?)?.toDouble(),
    verifiedLongitude: (json['verifiedLongitude'] as num?)?.toDouble(),
    verifiedAddress: json['verifiedAddress'] as String?,
  );

  /// PUT /api/worklog/days/{date} 요청 바디 — isOvertime/isRisk는 서버가
  /// 판정하는 값이라 클라이언트가 보내지 않는다. verifiedLatitude/Longitude/
  /// Address는 인증 시점에 받은 값을 그대로 실어 보낸다(재저장 시에도 기존
  /// 값을 유지).
  Map<String, dynamic> toUpsertJson() => {
    'clockIn': _timeToHm(clockIn),
    'clockOut': _timeToHm(clockOut),
    'breakMinutes': breakMinutes,
    'memo': memo,
    'gpsVerified': gpsVerified,
    'verifiedLatitude': verifiedLatitude,
    'verifiedLongitude': verifiedLongitude,
    'verifiedAddress': verifiedAddress,
  };

  DailyWorkRecord copyWith({
    TimeOfDay? clockIn,
    TimeOfDay? clockOut,
    int? breakMinutes,
    String? memo,
    bool? isOvertime,
    bool? isRisk,
    bool? gpsVerified,
    double? verifiedLatitude,
    double? verifiedLongitude,
    String? verifiedAddress,
  }) {
    return DailyWorkRecord(
      clockIn: clockIn ?? this.clockIn,
      clockOut: clockOut ?? this.clockOut,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      memo: memo ?? this.memo,
      isOvertime: isOvertime ?? this.isOvertime,
      isRisk: isRisk ?? this.isRisk,
      gpsVerified: gpsVerified ?? this.gpsVerified,
      verifiedLatitude: verifiedLatitude ?? this.verifiedLatitude,
      verifiedLongitude: verifiedLongitude ?? this.verifiedLongitude,
      verifiedAddress: verifiedAddress ?? this.verifiedAddress,
    );
  }
}
