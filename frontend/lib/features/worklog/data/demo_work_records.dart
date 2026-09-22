import 'package:flutter/material.dart';
import '../models/daily_work_record.dart';

/// 캘린더와 증빙 미리보기가 공유하는 예시. 실제 사용자 기록으로 저장하지 않는다.
Map<DateTime, DailyWorkRecord> demoWorkRecords(DateTime today) => {
  for (var i = 1; i <= 6; i++)
    DateTime(today.year, today.month, today.day - i): DailyWorkRecord(
      clockIn: const TimeOfDay(hour: 8, minute: 0),
      clockOut: i == 1 || i == 3
          ? const TimeOfDay(hour: 20, minute: 30)
          : const TimeOfDay(hour: 17, minute: 0),
      breakMinutes: 60,
      isOvertime: i == 1 || i == 3,
      isRisk: i == 4,
      gpsVerified: true,
    ),
};
