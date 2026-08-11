/// 임금·체불 정밀 진단 계산 엔진. 프론트엔드_계산기_최종.html(v6)의 calcWage()/
/// severanceNarrative()/explainGap()을 그대로 옮긴 순수 함수다 — 근로기준법
/// 산식을 규칙 기반으로 계산할 뿐, AI나 임의 판단이 개입하지 않는다("AI 진단"
/// 문구도 실제 LLM 호출이 아니라 계산값을 근거로 미리 정해둔 문장을 조립할 뿐이다).
library;

import 'dart:math' as math;

enum PeriodMode { month, multi, range }

enum VisaChoice {
  d2('D-2', 'D-2'),
  e9('E-9', 'E-9'),
  e7('E-7', 'E-7'),
  h2('H-2', 'H-2'),
  etc('etc', '기타');

  const VisaChoice(this.code, this.label);
  final String code;
  final String label;
}

enum PayType { hour, day, week, month, year }

enum BizSize { over5, under5, unknown }

enum TaxMethod { four, biz, none, unknown }

enum RoomType { dorm, studio, meal }

/// TODO: 매년 고용노동부 고시로 최저임금·4대보험 요율을 대조해야 한다.
const int wageCalcYear = 2026;
const Map<int, (double hour, double month)> minWageTable = {
  2025: (10030, 2096270),
  2026: (10320, 2156880),
};
(double hour, double month) minWage() =>
    minWageTable[wageCalcYear] ?? minWageTable.values.last;

// v4 수정사항 문서 기준 2026년 근로자 부담률: 국민연금9%(근로자4.5%) · 건강보험6.99%(근로자3.495%) ·
// 장기요양보험(건강보험료의 12.27%) · 고용보험0.9% → 합계 약 9.32%
const double _pensionRate = 0.045;
const double _healthRate = 0.03495;
const double _ltcOfHealthRate = 0.1227;
const double _employmentRate = 0.009;
double insuranceRate() =>
    _pensionRate +
    _healthRate +
    (_healthRate * _ltcOfHealthRate) +
    _employmentRate;
const double bizTaxRate = 0.033; // 사업소득세 3% + 지방소득세 0.3%

const double weeksPerMonth = 4.345;
const double daysPerMonth = 30.4167;

class WageCalcInput {
  const WageCalcInput({
    this.periodMode = PeriodMode.month,
    this.multiMonths = 3,
    this.rangeStart,
    this.rangeEnd,
    this.visa = VisaChoice.e9,
    this.visaCustom = '',
    this.payType = PayType.hour,
    this.pay = 0,
    this.dailyHours = 8,
    this.dayCountTotal = 22,
    this.weekHours = 40,
    this.otH = 0,
    this.nightH = 0,
    this.holH = 0,
    this.hireDate,
    this.leaveDate,
    this.absent = false,
    this.bonus1y = 0,
    this.vacation1y = 0,
    this.size = BizSize.over5,
    this.tax = TaxMethod.four,
    this.roomOn = false,
    this.roomAmtTotal = 0,
    this.roomType = RoomType.dorm,
    this.received = 0,
  });

  final PeriodMode periodMode;
  final double multiMonths;

  /// "월 직접 지정" 시작/종료월 — 일(day)은 항상 1로 두고 연·월만 쓴다.
  final DateTime? rangeStart;
  final DateTime? rangeEnd;

  final VisaChoice visa;
  final String visaCustom;

  final PayType payType;
  final double pay;
  final double dailyHours;
  final double dayCountTotal;
  final double weekHours;
  final double otH;
  final double nightH;
  final double holH;

  final DateTime? hireDate;
  final DateTime? leaveDate;
  final bool absent;

  /// 퇴직금 정밀 산정용 — 최근 1년 정기상여금·미사용 연차수당 총액.
  final double bonus1y;
  final double vacation1y;

  final BizSize size;
  final TaxMethod tax;
  final bool roomOn;
  final double roomAmtTotal;
  final RoomType roomType;

  final double received;

  int periodsCount() {
    if (periodMode == PeriodMode.multi) {
      final n = multiMonths.round();
      return n < 1 ? 1 : n;
    }
    if (periodMode == PeriodMode.range) {
      if (rangeStart == null || rangeEnd == null) return 1;
      final months =
          (rangeEnd!.year - rangeStart!.year) * 12 +
          (rangeEnd!.month - rangeStart!.month) +
          1;
      return months < 1 ? 1 : months;
    }
    return 1;
  }

  String periodLabel() {
    final n = periodsCount();
    if (periodMode == PeriodMode.month) return '1개월 (이번 달)';
    if (periodMode == PeriodMode.multi) return '$n개월';
    if (periodMode == PeriodMode.range &&
        rangeStart != null &&
        rangeEnd != null) {
      return '${_fmtMonth(rangeStart!)}~${_fmtMonth(rangeEnd!)} ($n개월)';
    }
    return '$n개월';
  }
}

String _fmtMonth(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}';

int _daysBetween(DateTime? hire, DateTime? leave) {
  if (hire == null) return 0;
  final end = leave ?? DateTime.now();
  final diff = end.difference(hire).inDays;
  return diff < 0 ? 0 : diff;
}

class WageCalcResult {
  const WageCalcResult({
    required this.over5,
    required this.periods,
    required this.hourly,
    required this.baseTotal,
    required this.weeklyPayTotal,
    required this.weeklyIncluded,
    required this.over15,
    required this.otH,
    required this.ntH,
    required this.holH,
    required this.otPay,
    required this.ntPay,
    required this.holPay,
    required this.gross,
    this.taxRate,
    this.taxAmt,
    this.taxAmtFour,
    this.taxAmtBiz,
    required this.roomAmtTotal,
    this.net,
    this.netFour,
    this.netBiz,
    required this.payBelowMin,
    required this.roomBelowMin,
    required this.afterRoomHourly,
    required this.days,
    required this.eligible,
    required this.severance,
    required this.baseDaily,
    required this.avgDaily,
    required this.ordDaily,
    required this.usedOrdinary,
    required this.received,
    this.gap,
    this.gapFour,
    this.gapBiz,
  });

  final bool over5;
  final int periods;
  final double hourly;
  final double baseTotal;
  final double weeklyPayTotal;
  final bool weeklyIncluded;
  final bool over15;
  final double otH;
  final double ntH;
  final double holH;
  final double otPay;
  final double ntPay;
  final double holPay;
  final double gross;

  /// tax != unknown일 때만 채워진다.
  final double? taxRate;
  final double? taxAmt;

  /// tax == unknown일 때만 채워진다(4대보험/사업소득세 두 시나리오).
  final double? taxAmtFour;
  final double? taxAmtBiz;

  final double roomAmtTotal;
  final double? net;
  final double? netFour;
  final double? netBiz;

  final bool payBelowMin;
  final bool roomBelowMin;
  final double afterRoomHourly;

  final int days;
  final bool eligible;
  final double severance;
  final double baseDaily;
  final double avgDaily;
  final double ordDaily;
  final bool usedOrdinary;

  final double received;
  final double? gap;
  final double? gapFour;
  final double? gapBiz;

  /// tax==unknown이면 두 시나리오 중 더 불리한(작은) 차액을 대표값으로 쓴다.
  double get gapValue => gap ?? math.min(gapFour!, gapBiz!);
}

WageCalcResult calcWage(WageCalcInput c) {
  final over5 = c.size == BizSize.over5;
  final periods = c.periodsCount();

  final contractH = c.weekHours < 0 ? 0.0 : c.weekHours;
  final legalH = contractH < 40 ? contractH : 40.0;
  final over15 = contractH >= 15;
  final weeklyRestH = (over15 && !c.absent) ? (legalH / 40) * 8 : 0.0;
  final monthStdH = contractH * weeksPerMonth;
  final monthRestH = weeklyRestH * weeksPerMonth;
  final totalStdH = monthStdH * periods;
  final totalRestH = monthRestH * periods;

  double hourly;
  double baseTotal;
  double weeklyPayTotal;
  var weeklyIncluded = false;

  switch (c.payType) {
    case PayType.hour:
      hourly = c.pay < 0 ? 0.0 : c.pay;
      baseTotal = hourly * totalStdH;
      weeklyPayTotal = hourly * totalRestH;
      break;
    case PayType.day:
      final dailyH = c.dailyHours > 0 ? c.dailyHours : 8.0;
      hourly = dailyH > 0 ? c.pay / dailyH : 0.0;
      baseTotal = c.pay * (c.dayCountTotal < 0 ? 0.0 : c.dayCountTotal);
      weeklyPayTotal = hourly * totalRestH;
      break;
    case PayType.week:
      hourly = contractH > 0 ? c.pay / contractH : 0.0;
      baseTotal = hourly * totalStdH;
      weeklyPayTotal = hourly * totalRestH;
      break;
    case PayType.year:
      final monthlyPay = c.pay / 12;
      final denom = monthStdH + monthRestH;
      hourly = denom > 0 ? monthlyPay / denom : 0.0;
      baseTotal = monthlyPay * periods;
      weeklyPayTotal = 0;
      weeklyIncluded = true;
      break;
    case PayType.month:
      final denom = monthStdH + monthRestH;
      hourly = denom > 0 ? c.pay / denom : 0.0;
      baseTotal = (c.pay < 0 ? 0.0 : c.pay) * periods;
      weeklyPayTotal = 0;
      weeklyIncluded = true;
      break;
  }

  final otMul = over5 ? 1.5 : 1.0;
  final ntMul = over5 ? 0.5 : 0.0;
  final holMul = over5 ? 1.5 : 1.0;
  final otH = c.otH < 0 ? 0.0 : c.otH;
  final ntH = c.nightH < 0 ? 0.0 : c.nightH;
  final holH = c.holH < 0 ? 0.0 : c.holH;
  final otPay = otH * hourly * otMul;
  final ntPay = ntH * hourly * ntMul;
  final holPay = holH * hourly * holMul;

  final gross = baseTotal + weeklyPayTotal + otPay + ntPay + holPay;
  final roomAmtTotal = c.roomOn
      ? (c.roomAmtTotal < 0 ? 0.0 : c.roomAmtTotal)
      : 0.0;

  double? taxRate;
  double? taxAmt;
  double? net;
  double? netFour;
  double? netBiz;
  double? taxAmtFour;
  double? taxAmtBiz;
  if (c.tax == TaxMethod.unknown) {
    taxAmtFour = gross * insuranceRate();
    taxAmtBiz = gross * bizTaxRate;
    netFour = gross - taxAmtFour - roomAmtTotal;
    netBiz = gross - taxAmtBiz - roomAmtTotal;
  } else {
    taxRate = c.tax == TaxMethod.four
        ? insuranceRate()
        : c.tax == TaxMethod.biz
        ? bizTaxRate
        : 0.0;
    taxAmt = gross * taxRate;
    net = gross - taxAmt - roomAmtTotal;
  }

  final totalH = totalStdH + totalRestH + otH + holH;
  final afterRoomHourly = totalH > 0 ? (gross - roomAmtTotal) / totalH : 0.0;
  final roomBelowMin =
      roomAmtTotal > 0 && afterRoomHourly > 0 && afterRoomHourly < minWage().$1;
  final payBelowMin = hourly > 0 && hourly < minWage().$1;

  final days = _daysBetween(c.hireDate, c.leaveDate);
  final eligible = c.hireDate != null && days >= 365 && over15;

  final monthlyGrossAvg = periods > 0 ? gross / periods : gross;
  final bonus3m = c.bonus1y * (3 / 12);
  final vacation3m = c.vacation1y * (3 / 12);
  final avgDaily =
      (monthlyGrossAvg * 3 + bonus3m + vacation3m) / (daysPerMonth * 3);

  final dailyStdH = math.min(contractH > 0 ? contractH / 5 : 8.0, 8.0);
  final ordDaily = hourly * dailyStdH;
  final baseDaily = avgDaily > ordDaily ? avgDaily : ordDaily;
  final usedOrdinary = ordDaily > avgDaily;
  final severance = eligible ? baseDaily * 30 * (days / 365) : 0.0;

  final received = c.received < 0 ? 0.0 : c.received;
  double? gap;
  double? gapFour;
  double? gapBiz;
  if (c.tax == TaxMethod.unknown) {
    gapFour = netFour! - received;
    gapBiz = netBiz! - received;
  } else {
    gap = net! - received;
  }

  return WageCalcResult(
    over5: over5,
    periods: periods,
    hourly: hourly,
    baseTotal: baseTotal,
    weeklyPayTotal: weeklyPayTotal,
    weeklyIncluded: weeklyIncluded,
    over15: over15,
    otH: otH,
    ntH: ntH,
    holH: holH,
    otPay: otPay,
    ntPay: ntPay,
    holPay: holPay,
    gross: gross,
    taxRate: taxRate,
    taxAmt: taxAmt,
    taxAmtFour: taxAmtFour,
    taxAmtBiz: taxAmtBiz,
    roomAmtTotal: roomAmtTotal,
    net: net,
    netFour: netFour,
    netBiz: netBiz,
    payBelowMin: payBelowMin,
    roomBelowMin: roomBelowMin,
    afterRoomHourly: afterRoomHourly,
    days: days,
    eligible: eligible,
    severance: severance,
    baseDaily: baseDaily,
    avgDaily: avgDaily,
    ordDaily: ordDaily,
    usedOrdinary: usedOrdinary,
    received: received,
    gap: gap,
    gapFour: gapFour,
    gapBiz: gapBiz,
  );
}

String taxLabelOf(TaxMethod tax, double? rate) {
  if (tax == TaxMethod.four) {
    return '4대보험 ${((rate ?? 0) * 100).toStringAsFixed(2)}%';
  }
  if (tax == TaxMethod.biz) return '사업소득세 3.3%';
  return '공제 없음';
}

/// 퇴직금 서술 — 계산값을 근거로 미리 정해둔 문장을 조립한다(LLM 미사용).
/// <b>...</b>는 강조 표시 마커이며, 위젯에서 파싱해 굵게 렌더링한다.
String severanceNarrative(WageCalcInput c, WageCalcResult r) {
  if (c.hireDate == null) return '입사일을 입력하시면 재직 기간을 계산해 퇴직금 여부를 알려드립니다.';

  final yrs = r.days ~/ 365;
  final remDays = r.days - yrs * 365;
  final months = (remDays / daysPerMonth).floor();
  var tenureTxt = '';
  if (yrs > 0) tenureTxt += '$yrs년 ';
  if (months > 0) tenureTxt += '$months개월';
  if (tenureTxt.isEmpty) tenureTxt = '${r.days}일';

  if (!r.eligible) {
    final reasons = <String>[];
    if (r.days < 365) {
      reasons.add('아직 계속근로기간이 1년(365일)을 채우지 못했어요(현재 ${r.days}일, 약 $tenureTxt)');
    }
    if (!r.over15) reasons.add('주당 약정 근로시간이 15시간 미만이에요');
    return '「근로자퇴직급여 보장법」은 ① 계속근로기간 1년 이상, ② 4주 평균 주 15시간 이상, 두 조건을 모두 충족해야 퇴직금이 발생한다고 정하고 있어요. '
        '지금 입력하신 내용으로는 ${reasons.join(", ")}라서 아직 퇴직금 요건을 채우지 못한 상태예요. 조건을 채우게 되면 이 계산기에서 바로 예상 금액을 보여드릴게요.';
  }

  return '입사일부터 ${c.leaveDate != null ? "퇴사일까지" : "오늘까지"} 총 ${r.days}일, 약 $tenureTxt 동안 계속 근무하셨어요. '
      '이는 「근로자퇴직급여 보장법」이 정한 두 가지 요건 — ① 계속근로기간 1년 이상, ② 4주 평균 주 15시간 이상 — 을 모두 충족합니다. '
      '그래서 근로 형태(정규직·계약직·아르바이트 상관없이)와 사업장 규모(5인 미만 포함)에 관계없이 퇴직금을 받을 권리가 있어요.'
      '${r.usedOrdinary ? " 최근 임금이 적었던 기간이 있어 평균임금 대신 통상임금 기준으로 계산했어요." : ""}'
      ' 계산식은 1일 평균임금 ${formatWon(r.baseDaily)} × 30일 × (재직일수 ${r.days}일 ÷ 365) 이며, 그 결과 약 <b>${formatWon(r.severance)}</b>을 받으셔야 해요. '
      '퇴직금은 퇴직일로부터 14일 이내에 지급되어야 하고, 청구권은 퇴직 후 3년이 지나면 시효로 소멸된다는 점도 기억해 두세요.';
}

/// "AI 진단" 문구 — 실제로는 계산값을 근거로 미리 정해둔 규칙에 따라 문장을
/// 조립할 뿐이다(법률 환각 방지: LLM이 새 판단을 만들지 않는다).
String explainGap(WageCalcInput c, WageCalcResult r) {
  final gapVal = r.gapValue;
  final parts = <String>[];

  if (gapVal > 0) {
    if (r.payBelowMin) {
      parts.add(
        '계약된 통상시급이 <b>${formatWon(r.hourly)}</b>으로 $wageCalcYear년 최저임금 <b>${formatWon(minWage().$1)}</b>보다 낮아요. '
        '이 부분은 계약을 그렇게 맺었더라도 무효이고, 최저임금과의 차액은 반드시 청구할 수 있어요.',
      );
    }
    if (!r.weeklyIncluded && r.weeklyPayTotal > 0) {
      parts.add(
        '주휴수당 <b>${formatWon(r.weeklyPayTotal)}</b>이 계산에 포함되어 있어요. 실제로 받으신 돈에 이 항목이 빠져 있다면, 당신은 이 금액만큼 더 받아야 해요.',
      );
    }
    if (r.otPay > 0) {
      parts.add(
        '연장근로 ${r.otH}시간에 대한 가산수당 <b>${formatWon(r.otPay)}</b>이 포함되어 있어요. '
        '${r.over5 ? "5인 이상 사업장은 통상시급의 1.5배를 지급해야 해요." : "5인 미만이라도 일한 시간만큼 통상임금(1.0배)은 지급되어야 해요."}',
      );
    }
    if (r.ntPay > 0) {
      parts.add(
        '야간근로(22시~06시) ${r.ntH}시간에 대한 가산수당 <b>${formatWon(r.ntPay)}</b>이 포함되어 있어요.',
      );
    }
    if (r.holPay > 0) {
      parts.add(
        '휴일근로 ${r.holH}시간에 대한 수당 <b>${formatWon(r.holPay)}</b>이 포함되어 있어요.',
      );
    }
    if (c.roomOn && r.roomAmtTotal > 0) {
      parts.add(
        '숙식비 <b>${formatWon(r.roomAmtTotal)}</b>이 공제 대상으로 계산되어 있어요. 서면 동의 없이 공제됐거나 지나치게 큰 금액이라면 그 자체가 문제일 수 있어요.'
        '${r.roomBelowMin ? " 특히 지금은 숙식비를 빼고 나면 최저임금 아래로 내려가는 상태예요." : ""}',
      );
    }
    if (c.tax == TaxMethod.biz) {
      parts.add(
        '지금 사업소득 3.3%로 공제되고 있다면, 실제 근무 형태(출퇴근 시간이 정해져 있고 지시를 받는 등)에 따라 근로자로 인정될 수 있어요. '
        '그렇다면 세금 처리 방식과 별개로 주휴수당·퇴직금 같은 다른 권리도 함께 놓치고 있을 가능성이 있어요.',
      );
    }
    if (c.size == BizSize.unknown) {
      parts.add(
        '사업장 규모를 정확히 몰라 지금은 5인 미만(가산수당 없음) 기준으로 보수적으로 계산했어요. 실제로 5인 이상이라면, 당신은 지금 계산된 것보다 더 큰 금액을 받으셔야 해요.',
      );
    }

    final head =
        '지금까지 입력하신 내용을 바탕으로 보면, 당신은 최소 약 <b>${formatWon(gapVal.abs())}</b>을 더 받으셔야 할 가능성이 높아요. '
        '아래 항목들을 확인해 보세요.';
    final body = parts.isNotEmpty
        ? parts.map((p) => '· $p').join('\n\n')
        : '구체적인 원인은 특정하기 어렵지만, 임금명세서 항목을 하나씩 대조해 보시길 권해요.';
    const foot =
        '이 진단은 입력값을 근거로 한 참고용 추정이에요. 확정된 체불액은 근로감독관 조사에서 정해지니, 먼저 임금명세서를 요청해 항목별로 비교해 보고 그래도 설명이 안 되면 고용노동부에 상담해 보세요.';
    return '$head\n\n$body\n\n$foot';
  } else {
    parts.add('포괄임금제 계약이라면 연장·야간수당이 월급에 미리 합산되어 있을 수 있어요.');
    parts.add('상여금, 식대, 교통비처럼 이 계산기가 반영하지 않는 항목이 함께 지급되었을 수 있어요.');
    if (c.tax == TaxMethod.none) {
      parts.add('세금이 공제되지 않는다고 선택하셨는데, 실제로는 일부 공제되고 있다면 반대로 계산이 달라질 수 있어요.');
    }

    final head =
        '계산 결과보다 약 <b>${formatWon(gapVal.abs())}</b> 더 받으셨어요. 체불은 아니고, 대부분 계산 방식의 차이예요.';
    final body = parts.map((p) => '· $p').join('\n\n');
    const foot = '임금명세서의 항목 구성을 확인해 보시면 어떤 항목이 더 포함되어 있는지 알 수 있어요.';
    return '$head\n\n$body\n\n$foot';
  }
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
