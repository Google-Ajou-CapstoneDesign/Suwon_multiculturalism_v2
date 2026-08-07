/// 임금계산기 입력값. 기본값은 시안(프론트엔드_구상_확장.html)의 자리표시자를 그대로 따른다.
/// TODO: hourlyWage 기본값(10,320원)은 고용노동부 최저임금 고시로 매년 대조가 필요하다.
class WageInputs {
  const WageInputs({
    this.hourlyWage = 10320,
    this.weeklyHours = 40,
    this.overtimeHours = 10,
    this.nightHours = 8,
    this.unusedLeaveDays = 5,
    this.employedDays = 400,
  });

  final int hourlyWage;
  final double weeklyHours;
  final double overtimeHours;
  final double nightHours;
  final double unusedLeaveDays;
  final int employedDays;

  WageInputs copyWith({
    int? hourlyWage,
    double? weeklyHours,
    double? overtimeHours,
    double? nightHours,
    double? unusedLeaveDays,
    int? employedDays,
  }) {
    return WageInputs(
      hourlyWage: hourlyWage ?? this.hourlyWage,
      weeklyHours: weeklyHours ?? this.weeklyHours,
      overtimeHours: overtimeHours ?? this.overtimeHours,
      nightHours: nightHours ?? this.nightHours,
      unusedLeaveDays: unusedLeaveDays ?? this.unusedLeaveDays,
      employedDays: employedDays ?? this.employedDays,
    );
  }
}

class WageCalculationResult {
  const WageCalculationResult({
    required this.baseMonthlyPay,
    required this.weeklyHolidayPay,
    required this.overtimePay,
    required this.nightPay,
    required this.unusedLeavePay,
    required this.estimatedSeverance,
  });

  final double baseMonthlyPay;
  final double weeklyHolidayPay;
  final double overtimePay;
  final double nightPay;
  final double unusedLeavePay;
  final double estimatedSeverance;

  double get total => baseMonthlyPay + weeklyHolidayPay + overtimePay + nightPay + unusedLeavePay + estimatedSeverance;
}

/// 근로기준법 기준 개략 계산. 실제 체불 진정서에 들어가는 확정 금액이 아니라
/// 참고용 예상치일 뿐이다 — 화면에서도 이 경계를 반드시 함께 보여줘야 한다.
WageCalculationResult calculateWage(WageInputs input) {
  const weeksPerMonth = 4.345;

  final base = input.hourlyWage * input.weeklyHours * weeksPerMonth;
  final holidayEligibleHours = input.weeklyHours / 5 < 8 ? input.weeklyHours / 5 : 8;
  final holiday = input.weeklyHours >= 15 ? input.hourlyWage * holidayEligibleHours * weeksPerMonth : 0.0;
  final overtime = input.hourlyWage * 1.5 * input.overtimeHours;
  final night = input.hourlyWage * 0.5 * input.nightHours;
  final unusedLeave = input.hourlyWage * 8 * input.unusedLeaveDays;
  final monthlyAverage = base + holiday + overtime + night;
  final severance = input.employedDays >= 365 ? monthlyAverage * (input.employedDays / 365) : 0.0;

  return WageCalculationResult(
    baseMonthlyPay: base,
    weeklyHolidayPay: holiday,
    overtimePay: overtime,
    nightPay: night,
    unusedLeavePay: unusedLeave,
    estimatedSeverance: severance,
  );
}
