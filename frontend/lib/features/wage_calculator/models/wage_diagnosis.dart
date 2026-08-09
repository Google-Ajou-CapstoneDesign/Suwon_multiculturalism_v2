/// 임금·체불 정밀 진단 계산 엔진. 프론트엔드_계산기.html의 calcMonthly()/readInputs()를
/// 그대로 옮긴 순수 함수다 — 근로기준법 산식을 규칙 기반으로 계산할 뿐, AI나 임의
/// 판단이 개입하지 않는다.
library;

enum ContractType { hourly, daily, weekly, monthly, annual }

enum CheckPeriod { thisPeriod, unpaidLong }

enum MonthScope { week, month }

enum BusinessSize { over5, under5, unknown }

enum VisaTrack { e9h2, d2, etc }

enum TaxType { socialInsurance, businessTax, none, unknown }

enum RoomType { dorm, studio, mealOnly }

/// TODO: 매년 고용노동부 고시로 최저임금·4대보험 요율을 대조해야 한다.
const int wageDiagnosisYear = 2026;
const Map<int, int> minimumWageTable = {2025: 10030, 2026: 10320};
double get minimumWage => (minimumWageTable[wageDiagnosisYear] ?? minimumWageTable.values.last).toDouble();

// 2026년 근로자 부담분 — 국민연금 4.75% + 건강보험 3.595%(+장기요양 13.14%) + 고용보험 0.9%
const double _pensionRate = 0.0475;
const double _healthInsuranceRate = 0.03595;
const double _longTermCareOfHealthInsurance = 0.1314;
const double _employmentInsuranceRate = 0.009;
final double insuranceRate = _pensionRate + _healthInsuranceRate + _healthInsuranceRate * _longTermCareOfHealthInsurance + _employmentInsuranceRate; // ≈ 9.72%
const double businessTaxRate = 0.033; // 3.3% 사업소득세

const double weeksPerMonth = 4.345;
const double daysPerMonth = 30.4167;

class WageDiagnosisInput {
  const WageDiagnosisInput({
    this.contractType = ContractType.hourly,
    this.checkPeriod = CheckPeriod.thisPeriod,
    this.monthScope = MonthScope.month,
    this.businessSize = BusinessSize.over5,
    this.visaTrack = VisaTrack.e9h2,
    this.taxType = TaxType.socialInsurance,
    this.amount = 0,
    this.weekHours = 40,
    this.dailyHours = 8,
    this.workDaysPerWeek = 5,
    this.dayCount = 22,
    this.overtimeHours = 0,
    this.nightHours = 0,
    this.holidayHours = 0,
    this.absentThisMonth = false,
    this.tenureYears = 0,
    this.tenureMonths = 0,
    this.tenureWeeksPart = 0,
    this.tenureDaysPart = 0,
    this.roomDeductionOn = false,
    this.roomAmount = 0,
    this.roomType = RoomType.dorm,
    this.receivedAmount = 0,
    this.unpaidMonths = 0,
    this.believedTotalAmount = 0,
    this.receivedTotalAmount = 0,
  });

  final ContractType contractType;
  final CheckPeriod checkPeriod;
  final MonthScope monthScope;
  final BusinessSize businessSize;
  final VisaTrack visaTrack;
  final TaxType taxType;

  final double amount;
  final double weekHours;
  final double dailyHours;
  final double workDaysPerWeek;
  final double dayCount;
  final double overtimeHours;
  final double nightHours;
  final double holidayHours;
  final bool absentThisMonth;

  final double tenureYears;
  final double tenureMonths;
  final double tenureWeeksPart;
  final double tenureDaysPart;

  final bool roomDeductionOn;
  final double roomAmount;
  final RoomType roomType;

  /// 이번 달/주만 확인할 때 실제로 입금된 금액.
  final double receivedAmount;

  /// 여러 달 못 받았을 때 입력하는 3개 필드.
  final double unpaidMonths;
  final double believedTotalAmount;
  final double receivedTotalAmount;

  double get totalTenureDays => tenureYears * 365 + tenureMonths * daysPerMonth + tenureWeeksPart * 7 + tenureDaysPart;
}

class TaxScenario {
  const TaxScenario({required this.rate, required this.amount});
  final double rate;
  final double amount;
}

class WageDiagnosisResult {
  const WageDiagnosisResult({
    required this.over5,
    required this.hourlyRate,
    required this.basePay,
    required this.weeklyHolidayPay,
    required this.weeklyIncludedInBase,
    required this.over15HoursPerWeek,
    required this.monthlyStandardHours,
    required this.overtimePay,
    required this.nightPay,
    required this.holidayPay,
    required this.overtimeHours,
    required this.nightHours,
    required this.holidayHours,
    required this.grossTotal,
    required this.roomAmount,
    required this.hourlyAfterRoomDeduction,
    required this.isBelowMinWageAfterRoom,
    required this.isBelowMinWage,
    required this.taxScenarios,
    required this.severanceEligible,
    required this.severancePay,
    required this.tenureDays,
  });

  final bool over5;
  final double hourlyRate;
  final double basePay;
  final double weeklyHolidayPay;
  final bool weeklyIncludedInBase;
  final bool over15HoursPerWeek;
  final double monthlyStandardHours;
  final double overtimePay;
  final double nightPay;
  final double holidayPay;
  final double overtimeHours;
  final double nightHours;
  final double holidayHours;
  final double grossTotal;
  final double roomAmount;
  final double hourlyAfterRoomDeduction;
  final bool isBelowMinWageAfterRoom;
  final bool isBelowMinWage;

  /// tax==unknown이면 {'ssi':.., 'biz':..} 두 시나리오, 아니면 {'main':..} 하나.
  final Map<String, TaxScenario> taxScenarios;

  final bool severanceEligible;
  final double severancePay;
  final double tenureDays;

  double netOf(TaxScenario scenario) => grossTotal - scenario.amount - roomAmount;
}

WageDiagnosisResult calculateWageDiagnosis(WageDiagnosisInput input) {
  final effectiveWeekHours = input.contractType == ContractType.daily
      ? input.dailyHours * (input.workDaysPerWeek < 1 ? 1 : input.workDaysPerWeek)
      : input.weekHours;

  final periods = (input.checkPeriod == CheckPeriod.thisPeriod && input.monthScope == MonthScope.week) ? 1.0 : weeksPerMonth;

  var payType = input.contractType == ContractType.annual ? ContractType.monthly : input.contractType;
  var amount = input.contractType == ContractType.annual ? input.amount / 12 : input.amount;

  if (payType == ContractType.weekly) {
    amount = effectiveWeekHours > 0 ? amount / effectiveWeekHours : 0;
    payType = ContractType.hourly;
  }

  final over5 = input.businessSize == BusinessSize.over5;
  final weekHours = effectiveWeekHours < 0 ? 0.0 : effectiveWeekHours;
  final legalH = weekHours < 40 ? weekHours : 40.0;
  final over15 = weekHours >= 15;
  final weeklyRestH = (over15 && !input.absentThisMonth) ? (legalH / 40) * 8 : 0.0;
  final monthStdH = weekHours * periods;
  final monthRestH = weeklyRestH * periods;

  double hourly;
  if (payType == ContractType.hourly) {
    hourly = amount;
  } else if (payType == ContractType.daily) {
    final dh = input.dailyHours > 0 ? input.dailyHours : (weekHours > 0 ? weekHours / 5 : 8);
    hourly = dh > 0 ? amount / dh : 0;
  } else {
    final denom = monthStdH + monthRestH;
    hourly = denom > 0 ? amount / denom : 0;
  }

  double base;
  var weeklyPay = hourly * monthRestH;
  var weeklyIncluded = false;
  if (payType == ContractType.hourly) {
    base = hourly * monthStdH;
  } else if (payType == ContractType.daily) {
    base = amount * (input.dayCount < 0 ? 0 : input.dayCount);
  } else {
    base = amount * (periods / weeksPerMonth);
    weeklyPay = 0;
    weeklyIncluded = true;
  }

  final otH = input.overtimeHours < 0 ? 0.0 : input.overtimeHours;
  final ntH = input.nightHours < 0 ? 0.0 : input.nightHours;
  final holH = input.holidayHours < 0 ? 0.0 : input.holidayHours;
  final otMul = over5 ? 1.5 : 1.0;
  final ntMul = over5 ? 0.5 : 0.0;
  final otPay = otH * hourly * otMul;
  final ntPay = ntH * hourly * ntMul;
  final holIn = holH < 8 ? holH : 8.0;
  final holOut = (holH - 8) > 0 ? (holH - 8) : 0.0;
  final holPay = over5 ? (holIn * hourly * 1.5 + holOut * hourly * 2.0) : (holH * hourly * 1.0);

  final gross = base + weeklyPay + otPay + ntPay + holPay;

  final roomAmt = input.roomDeductionOn ? (input.roomAmount < 0 ? 0.0 : input.roomAmount) : 0.0;
  final totalH = monthStdH + monthRestH + otH + holH;
  final afterRoomHourly = totalH > 0 ? (gross - roomAmt) / totalH : 0.0;
  final roomBelowMin = roomAmt > 0 && afterRoomHourly > 0 && afterRoomHourly < minimumWage;
  final payBelowMin = hourly > 0 && hourly < minimumWage;

  TaxScenario taxOf(TaxType method) {
    final rate = method == TaxType.socialInsurance
        ? insuranceRate
        : method == TaxType.businessTax
            ? businessTaxRate
            : 0.0;
    return TaxScenario(rate: rate, amount: gross * rate);
  }

  final taxScenarios = input.taxType == TaxType.unknown
      ? {'ssi': taxOf(TaxType.socialInsurance), 'biz': taxOf(TaxType.businessTax)}
      : {'main': taxOf(input.taxType)};

  final tenureDays = input.totalTenureDays;
  final eligible = tenureDays >= 365 && over15;
  final avgDaily = gross / daysPerMonth;
  final rawDailyStdH = weekHours > 0 ? weekHours / 5 : 8.0;
  final dailyStdH = rawDailyStdH < 8 ? rawDailyStdH : 8.0;
  final ordDaily = hourly * dailyStdH;
  final baseDaily = avgDaily > ordDaily ? avgDaily : ordDaily;
  final severance = eligible ? baseDaily * 30 * (tenureDays / 365) : 0.0;

  return WageDiagnosisResult(
    over5: over5,
    hourlyRate: hourly,
    basePay: base,
    weeklyHolidayPay: weeklyPay,
    weeklyIncludedInBase: weeklyIncluded,
    over15HoursPerWeek: over15,
    monthlyStandardHours: monthStdH,
    overtimePay: otPay,
    nightPay: ntPay,
    holidayPay: holPay,
    overtimeHours: otH,
    nightHours: ntH,
    holidayHours: holH,
    grossTotal: gross,
    roomAmount: roomAmt,
    hourlyAfterRoomDeduction: afterRoomHourly,
    isBelowMinWageAfterRoom: roomBelowMin,
    isBelowMinWage: payBelowMin,
    taxScenarios: taxScenarios,
    severanceEligible: eligible,
    severancePay: severance,
    tenureDays: tenureDays,
  );
}

String formatWon(num value) {
  final rounded = value.round();
  final digits = rounded.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return '${rounded < 0 ? '-' : ''}$buffer원';
}
