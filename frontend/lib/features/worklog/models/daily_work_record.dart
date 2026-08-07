import 'package:flutter/material.dart';

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

  bool get hasEntry => clockIn != null && clockOut != null;

  Duration get workedDuration {
    if (clockIn == null || clockOut == null) return Duration.zero;
    final startMinutes = clockIn!.hour * 60 + clockIn!.minute;
    final endMinutes = clockOut!.hour * 60 + clockOut!.minute;
    final minutes = (endMinutes - startMinutes) - breakMinutes;
    return Duration(minutes: minutes < 0 ? 0 : minutes);
  }

  DailyWorkRecord copyWith({
    TimeOfDay? clockIn,
    TimeOfDay? clockOut,
    int? breakMinutes,
    String? memo,
    bool? isOvertime,
    bool? isRisk,
    bool? gpsVerified,
  }) {
    return DailyWorkRecord(
      clockIn: clockIn ?? this.clockIn,
      clockOut: clockOut ?? this.clockOut,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      memo: memo ?? this.memo,
      isOvertime: isOvertime ?? this.isOvertime,
      isRisk: isRisk ?? this.isRisk,
      gpsVerified: gpsVerified ?? this.gpsVerified,
    );
  }
}
