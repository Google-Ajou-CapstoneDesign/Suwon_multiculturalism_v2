/// 임금·체불 정밀 진단 계산 엔진. 프론트엔드_계산기_최종.html(v6)의 calcWage()/
/// severanceNarrative()/explainGap()을 그대로 옮긴 순수 함수다 — 근로기준법
/// 산식을 규칙 기반으로 계산할 뿐, AI나 임의 판단이 개입하지 않는다("AI 진단"
/// 문구도 실제 LLM 호출이 아니라 계산값을 근거로 미리 정해둔 문장을 조립할 뿐이다).
library;

import 'dart:math' as math;

import '../../../core/app_language.dart';

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

  String labelOf(AppLanguage lang) {
    if (this != VisaChoice.etc) return code;
    return switch (lang) {
      AppLanguage.ko => '기타',
      AppLanguage.en => 'Other',
      AppLanguage.zh => '其他',
      AppLanguage.vi => 'Khác',
    };
  }
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

  String periodLabel(AppLanguage lang) {
    final n = periodsCount();
    if (periodMode == PeriodMode.month) {
      return switch (lang) {
        AppLanguage.ko => '1개월 (이번 달)',
        AppLanguage.en => '1 month (this month)',
        AppLanguage.zh => '1个月（本月）',
        AppLanguage.vi => '1 tháng (tháng này)',
      };
    }
    if (periodMode == PeriodMode.multi) {
      return switch (lang) {
        AppLanguage.ko => '$n개월',
        AppLanguage.en => '$n months',
        AppLanguage.zh => '$n个月',
        AppLanguage.vi => '$n tháng',
      };
    }
    if (periodMode == PeriodMode.range &&
        rangeStart != null &&
        rangeEnd != null) {
      final range = '${_fmtMonth(rangeStart!)}~${_fmtMonth(rangeEnd!)}';
      return switch (lang) {
        AppLanguage.ko => '$range ($n개월)',
        AppLanguage.en => '$range ($n months)',
        AppLanguage.zh => '$range（$n个月）',
        AppLanguage.vi => '$range ($n tháng)',
      };
    }
    return switch (lang) {
      AppLanguage.ko => '$n개월',
      AppLanguage.en => '$n months',
      AppLanguage.zh => '$n个月',
      AppLanguage.vi => '$n tháng',
    };
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
  final otH = c.otH < 0 ? 0.0 : c.otH;
  final ntH = c.nightH < 0 ? 0.0 : c.nightH;
  final holH = c.holH < 0 ? 0.0 : c.holH;
  final otPay = otH * hourly * otMul;
  final ntPay = ntH * hourly * ntMul;
  // 휴일근로: 8시간 이내 1.5배, 8시간 초과분 2.0배 (5인 미만 사업장은 전부 1.0배).
  final holIn = holH < 8 ? holH : 8.0;
  final holOut = holH > 8 ? holH - 8 : 0.0;
  final holPay = over5
      ? (holIn * hourly * 1.5 + holOut * hourly * 2.0)
      : holH * hourly * 1.0;

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

String taxLabelOf(TaxMethod tax, double? rate, AppLanguage lang) {
  if (tax == TaxMethod.four) {
    final pct = ((rate ?? 0) * 100).toStringAsFixed(2);
    return switch (lang) {
      AppLanguage.ko => '4대보험 $pct%',
      AppLanguage.en => '4 Major Insurances $pct%',
      AppLanguage.zh => '四大保险 $pct%',
      AppLanguage.vi => '4 loại bảo hiểm $pct%',
    };
  }
  if (tax == TaxMethod.biz) {
    return switch (lang) {
      AppLanguage.ko => '사업소득세 3.3%',
      AppLanguage.en => 'Business income tax 3.3%',
      AppLanguage.zh => '营业所得税 3.3%',
      AppLanguage.vi => 'Thuế thu nhập kinh doanh 3.3%',
    };
  }
  return switch (lang) {
    AppLanguage.ko => '공제 없음',
    AppLanguage.en => 'No deduction',
    AppLanguage.zh => '无扣除',
    AppLanguage.vi => 'Không khấu trừ',
  };
}

/// 재직 기간을 언어별 자연스러운 표현으로 변환한다("3년 2개월" / "3 yr 2 mo" 등).
String _tenureText(int days, AppLanguage lang) {
  final yrs = days ~/ 365;
  final remDays = days - yrs * 365;
  final months = (remDays / daysPerMonth).floor();
  switch (lang) {
    case AppLanguage.ko:
      var t = '';
      if (yrs > 0) t += '$yrs년 ';
      if (months > 0) t += '$months개월';
      return t.isEmpty ? '$days일' : t;
    case AppLanguage.en:
      var t = '';
      if (yrs > 0) t += '$yrs yr ';
      if (months > 0) t += '$months mo';
      return t.trim().isEmpty ? '$days days' : t.trim();
    case AppLanguage.zh:
      var t = '';
      if (yrs > 0) t += '$yrs年';
      if (months > 0) t += '$months个月';
      return t.isEmpty ? '$days天' : t;
    case AppLanguage.vi:
      var t = '';
      if (yrs > 0) t += '$yrs năm ';
      if (months > 0) t += '$months tháng';
      return t.trim().isEmpty ? '$days ngày' : t.trim();
  }
}

/// 퇴직금 서술 — 계산값을 근거로 미리 정해둔 문장을 조립한다(LLM 미사용).
/// <b>...</b>는 강조 표시 마커이며, 위젯에서 파싱해 굵게 렌더링한다.
String severanceNarrative(WageCalcInput c, WageCalcResult r, AppLanguage lang) {
  if (c.hireDate == null) {
    return switch (lang) {
      AppLanguage.ko => '입사일을 입력하시면 재직 기간을 계산해 퇴직금 여부를 알려드립니다.',
      AppLanguage.en =>
        'Enter your hire date and we will calculate your tenure to tell you whether severance pay applies.',
      AppLanguage.zh => '请输入入职日期，我们将计算在职期间并告知您是否符合退休金条件。',
      AppLanguage.vi =>
        'Hãy nhập ngày vào làm để chúng tôi tính thời gian làm việc và cho bạn biết có được nhận trợ cấp thôi việc hay không.',
    };
  }

  final tenureTxt = _tenureText(r.days, lang);

  if (!r.eligible) {
    final reasons = <String>[];
    if (r.days < 365) {
      reasons.add(switch (lang) {
        AppLanguage.ko =>
          '아직 계속근로기간이 1년(365일)을 채우지 못했어요(현재 ${r.days}일, 약 $tenureTxt)',
        AppLanguage.en =>
          'your continuous service has not yet reached 1 year (365 days) — currently ${r.days} days, about $tenureTxt',
        AppLanguage.zh => '连续工作年限尚未满1年（365天）（目前${r.days}天，约$tenureTxt）',
        AppLanguage.vi =>
          'thời gian làm việc liên tục chưa đủ 1 năm (365 ngày) (hiện tại ${r.days} ngày, khoảng $tenureTxt)',
      });
    }
    if (!r.over15) {
      reasons.add(switch (lang) {
        AppLanguage.ko => '주당 약정 근로시간이 15시간 미만이에요',
        AppLanguage.en =>
          'your contracted weekly working hours are under 15 hours',
        AppLanguage.zh => '每周约定工作时间不足15小时',
        AppLanguage.vi => 'giờ làm việc theo hợp đồng hàng tuần dưới 15 giờ',
      });
    }
    final sep = lang == AppLanguage.zh ? '，' : ', ';
    final reasonsText = reasons.join(sep);
    return switch (lang) {
      AppLanguage.ko =>
        '「근로자퇴직급여 보장법」은 ① 계속근로기간 1년 이상, ② 4주 평균 주 15시간 이상, 두 조건을 모두 충족해야 퇴직금이 발생한다고 정하고 있어요. '
            '지금 입력하신 내용으로는 $reasonsText라서 아직 퇴직금 요건을 채우지 못한 상태예요. 조건을 채우게 되면 이 계산기에서 바로 예상 금액을 보여드릴게요.',
      AppLanguage.en =>
        'The Employee Retirement Benefit Security Act requires both of these to be met before severance pay applies: ① at least 1 year of continuous service, and ② an average of at least 15 hours a week over 4 weeks. '
            'Based on what you entered, $reasonsText, so the severance pay requirement is not yet met. Once you meet both conditions, this calculator will show your estimated amount right away.',
      AppLanguage.zh =>
        '《劳动者退休金保障法》规定，必须同时满足以下两个条件才能获得退休金：①连续工作年限1年以上，②近4周平均每周工作15小时以上。'
            '根据您目前输入的内容，$reasonsText，因此目前尚未满足退休金条件。一旦满足条件，本计算器会立即为您显示预估金额。',
      AppLanguage.vi =>
        'Luật Bảo đảm trợ cấp hưu trí cho người lao động quy định phải đáp ứng đồng thời hai điều kiện sau mới phát sinh trợ cấp thôi việc: ① thời gian làm việc liên tục từ 1 năm trở lên, ② trung bình từ 15 giờ/tuần trở lên tính theo 4 tuần. '
            'Với nội dung bạn đã nhập, $reasonsText nên hiện chưa đáp ứng điều kiện nhận trợ cấp thôi việc. Khi đáp ứng đủ điều kiện, máy tính này sẽ hiển thị ngay số tiền dự kiến.',
    };
  }

  final periodPhrase = switch (lang) {
    AppLanguage.ko => c.leaveDate != null ? '퇴사일까지' : '오늘까지',
    AppLanguage.en => c.leaveDate != null ? 'to your last day' : 'to today',
    AppLanguage.zh => c.leaveDate != null ? '到离职日' : '到今天',
    AppLanguage.vi =>
      c.leaveDate != null ? 'đến ngày nghỉ việc' : 'đến hôm nay',
  };

  final usedOrdinaryNote = r.usedOrdinary
      ? switch (lang) {
          AppLanguage.ko => ' 최근 임금이 적었던 기간이 있어 평균임금 대신 통상임금 기준으로 계산했어요.',
          AppLanguage.en =>
            ' Because there was a period of lower pay recently, this was calculated using the ordinary wage instead of the average wage.',
          AppLanguage.zh => ' 由于近期存在工资较低的时期，因此按通常工资而非平均工资计算。',
          AppLanguage.vi =>
            ' Vì có giai đoạn lương thấp gần đây nên đã tính theo lương thông thường thay vì lương bình quân.',
        }
      : '';

  return switch (lang) {
    AppLanguage.ko =>
      '입사일부터 $periodPhrase 총 ${r.days}일, 약 $tenureTxt 동안 계속 근무하셨어요. '
          '이는 「근로자퇴직급여 보장법」이 정한 두 가지 요건 — ① 계속근로기간 1년 이상, ② 4주 평균 주 15시간 이상 — 을 모두 충족합니다. '
          '그래서 근로 형태(정규직·계약직·아르바이트 상관없이)와 사업장 규모(5인 미만 포함)에 관계없이 퇴직금을 받을 권리가 있어요.'
          '$usedOrdinaryNote'
          ' 계산식은 1일 평균임금 ${formatWon(r.baseDaily, lang)} × 30일 × (재직일수 ${r.days}일 ÷ 365) 이며, 그 결과 약 <b>${formatWon(r.severance, lang)}</b>을 받으셔야 해요. '
          '퇴직금은 퇴직일로부터 14일 이내에 지급되어야 하고, 청구권은 퇴직 후 3년이 지나면 시효로 소멸된다는 점도 기억해 두세요.',
    AppLanguage.en =>
      'From your hire date $periodPhrase, you have worked a total of ${r.days} days, about $tenureTxt continuously. '
          'This satisfies both requirements set by the Employee Retirement Benefit Security Act — ① at least 1 year of continuous service, and ② an average of at least 15 hours a week over 4 weeks. '
          'So regardless of your employment type (regular, contract, or part-time) or company size (even under 5 employees), you have the right to receive severance pay.'
          '$usedOrdinaryNote'
          ' The formula is: average daily wage ${formatWon(r.baseDaily, lang)} × 30 days × (${r.days} days of service ÷ 365), which comes to about <b>${formatWon(r.severance, lang)}</b>. '
          'Remember: severance pay must be paid within 14 days of your last day, and your right to claim it expires 3 years after leaving.',
    AppLanguage.zh =>
      '从入职之日$periodPhrase，您已连续工作共${r.days}天，约$tenureTxt。'
          '这符合《劳动者退休金保障法》规定的两项条件——①连续工作年限1年以上，②近4周平均每周工作15小时以上——两项均已满足。'
          '因此无论用工形式（正式工·合同工·兼职均可）和企业规模（含5人以下），您都有权领取退休金。'
          '$usedOrdinaryNote'
          ' 计算公式为：日平均工资${formatWon(r.baseDaily, lang)} × 30天 × （在职天数${r.days}天 ÷ 365），计算结果约为<b>${formatWon(r.severance, lang)}</b>。'
          '请记住，退休金须在离职之日起14天内支付，且请求权自离职后满3年即因时效而消灭。',
    AppLanguage.vi =>
      'Từ ngày vào làm $periodPhrase, bạn đã làm việc liên tục tổng cộng ${r.days} ngày, khoảng $tenureTxt. '
          'Điều này đáp ứng đầy đủ hai điều kiện theo Luật Bảo đảm trợ cấp hưu trí cho người lao động — ① thời gian làm việc liên tục từ 1 năm trở lên, ② trung bình từ 15 giờ/tuần trở lên tính theo 4 tuần. '
          'Vì vậy, bất kể hình thức lao động (chính thức, hợp đồng, hay thời vụ) hay quy mô doanh nghiệp (kể cả dưới 5 người), bạn đều có quyền nhận trợ cấp thôi việc.'
          '$usedOrdinaryNote'
          ' Công thức tính là: lương bình quân 1 ngày ${formatWon(r.baseDaily, lang)} × 30 ngày × (số ngày làm việc ${r.days} ngày ÷ 365), kết quả bạn sẽ nhận được khoảng <b>${formatWon(r.severance, lang)}</b>. '
          'Hãy nhớ rằng trợ cấp thôi việc phải được trả trong vòng 14 ngày kể từ ngày nghỉ việc, và quyền yêu cầu sẽ hết hiệu lực sau 3 năm kể từ khi nghỉ việc.',
  };
}

/// "AI 진단" 문구 — 실제로는 계산값을 근거로 미리 정해둔 규칙에 따라 문장을
/// 조립할 뿐이다(법률 환각 방지: LLM이 새 판단을 만들지 않는다).
String explainGap(WageCalcInput c, WageCalcResult r, AppLanguage lang) {
  final gapVal = r.gapValue;
  // 1만원 미만 차이는 반올림·계산 오차로 보고 "체불/차이" 판정 대신 일치로 처리한다.
  if (gapVal.abs() < 10000) {
    return switch (lang) {
      AppLanguage.ko =>
        '계산 결과와 실제 받으신 금액이 거의 일치해요(차이 ${formatWon(gapVal.abs(), lang)} 미만). 지금 입력한 값으로는 특별히 의심되는 미지급이 없어요.',
      AppLanguage.en =>
        'The calculated amount and what you actually received are nearly identical (a difference under ${formatWon(gapVal.abs(), lang)}). Based on what you entered, nothing looks specifically unpaid.',
      AppLanguage.zh =>
        '计算结果与实际收到的金额基本一致（差额不足${formatWon(gapVal.abs(), lang)}）。根据目前输入的内容，没有特别可疑的欠薪项目。',
      AppLanguage.vi =>
        'Kết quả tính toán và số tiền bạn thực nhận gần như trùng khớp (chênh lệch dưới ${formatWon(gapVal.abs(), lang)}). Với dữ liệu đã nhập, không có khoản nào đáng nghi bị thiếu.',
    };
  }
  final parts = <String>[];

  if (gapVal > 0) {
    if (r.payBelowMin) {
      parts.add(switch (lang) {
        AppLanguage.ko =>
          '계약된 통상시급이 <b>${formatWon(r.hourly, lang)}</b>으로 $wageCalcYear년 최저임금 <b>${formatWon(minWage().$1, lang)}</b>보다 낮아요. '
              '이 부분은 계약을 그렇게 맺었더라도 무효이고, 최저임금과의 차액은 반드시 청구할 수 있어요.',
        AppLanguage.en =>
          'Your contracted ordinary hourly wage is <b>${formatWon(r.hourly, lang)}</b>, which is lower than the $wageCalcYear minimum wage of <b>${formatWon(minWage().$1, lang)}</b>. '
              'This part of the contract is invalid even if both sides agreed to it, and you can always claim the difference from the minimum wage.',
        AppLanguage.zh =>
          '合同约定的通常时薪为<b>${formatWon(r.hourly, lang)}</b>，低于$wageCalcYear年最低工资<b>${formatWon(minWage().$1, lang)}</b>。'
              '即使合同这样约定，该部分也是无效的，您可以要求补足与最低工资之间的差额。',
        AppLanguage.vi =>
          'Mức lương giờ thông thường theo hợp đồng là <b>${formatWon(r.hourly, lang)}</b>, thấp hơn mức lương tối thiểu năm $wageCalcYear là <b>${formatWon(minWage().$1, lang)}</b>. '
              'Phần này vô hiệu dù hai bên đã thỏa thuận như vậy, và bạn luôn có thể yêu cầu khoản chênh lệch so với lương tối thiểu.',
      });
    }
    if (!r.weeklyIncluded && r.weeklyPayTotal > 0) {
      parts.add(switch (lang) {
        AppLanguage.ko =>
          '주휴수당 <b>${formatWon(r.weeklyPayTotal, lang)}</b>이 계산에 포함되어 있어요. 실제로 받으신 돈에 이 항목이 빠져 있다면, 당신은 이 금액만큼 더 받아야 해요. (근로기준법 제55조)',
        AppLanguage.en =>
          'The weekly paid-holiday allowance of <b>${formatWon(r.weeklyPayTotal, lang)}</b> is included in this calculation. If it is missing from what you actually received, you are owed this amount. (Labor Standards Act Art.55)',
        AppLanguage.zh =>
          '计算中包含了周休津贴<b>${formatWon(r.weeklyPayTotal, lang)}</b>。如果您实际收到的钱中没有这一项，您应当多获得这笔金额。（《劳动基准法》第55条）',
        AppLanguage.vi =>
          'Phụ cấp ngày nghỉ có lương hàng tuần <b>${formatWon(r.weeklyPayTotal, lang)}</b> đã được tính vào kết quả này. Nếu khoản này bị thiếu trong số tiền bạn thực nhận, bạn cần được trả thêm đúng số tiền này. (Điều 55 Luật Tiêu chuẩn Lao động)',
      });
    }
    if (r.otPay > 0) {
      final otNote = r.over5
          ? switch (lang) {
              AppLanguage.ko => '5인 이상 사업장은 통상시급의 1.5배를 지급해야 해요. (근로기준법 제56조)',
              AppLanguage.en =>
                'Workplaces with 5 or more employees must pay 1.5 times the ordinary hourly wage. (Labor Standards Act Art.56)',
              AppLanguage.zh => '5人以上企业必须按通常时薪的1.5倍支付。（《劳动基准法》第56条）',
              AppLanguage.vi =>
                'Nơi làm việc từ 5 người trở lên phải trả 1,5 lần lương giờ thông thường. (Điều 56 Luật Tiêu chuẩn Lao động)',
            }
          : switch (lang) {
              AppLanguage.ko => '5인 미만이라도 일한 시간만큼 통상임금(1.0배)은 지급되어야 해요.',
              AppLanguage.en =>
                'Even with under 5 employees, you must still be paid the ordinary wage (1.0×) for hours worked.',
              AppLanguage.zh => '即使不足5人，也必须按工作时间支付通常工资（1.0倍）。',
              AppLanguage.vi =>
                'Dù dưới 5 người, vẫn phải trả lương thông thường (1,0 lần) cho số giờ đã làm.',
            };
      parts.add(switch (lang) {
        AppLanguage.ko =>
          '연장근로 ${r.otH}시간에 대한 가산수당 <b>${formatWon(r.otPay, lang)}</b>이 포함되어 있어요. $otNote',
        AppLanguage.en =>
          'The premium pay for ${r.otH} hours of overtime, <b>${formatWon(r.otPay, lang)}</b>, is included. $otNote',
        AppLanguage.zh =>
          '已包含加班${r.otH}小时的加班费<b>${formatWon(r.otPay, lang)}</b>。$otNote',
        AppLanguage.vi =>
          'Đã bao gồm phụ cấp làm thêm giờ cho ${r.otH} giờ, số tiền <b>${formatWon(r.otPay, lang)}</b>. $otNote',
      });
    }
    if (r.ntPay > 0) {
      parts.add(switch (lang) {
        AppLanguage.ko =>
          '야간근로(22시~06시) ${r.ntH}시간에 대한 가산수당 <b>${formatWon(r.ntPay, lang)}</b>이 포함되어 있어요.',
        AppLanguage.en =>
          'The premium pay for ${r.ntH} hours of night work (10 PM–6 AM), <b>${formatWon(r.ntPay, lang)}</b>, is included.',
        AppLanguage.zh =>
          '已包含夜间工作（22:00~06:00）${r.ntH}小时的加班费<b>${formatWon(r.ntPay, lang)}</b>。',
        AppLanguage.vi =>
          'Đã bao gồm phụ cấp làm việc ban đêm (22:00–06:00) cho ${r.ntH} giờ, số tiền <b>${formatWon(r.ntPay, lang)}</b>.',
      });
    }
    if (r.holPay > 0) {
      parts.add(switch (lang) {
        AppLanguage.ko =>
          '휴일근로 ${r.holH}시간에 대한 수당 <b>${formatWon(r.holPay, lang)}</b>이 포함되어 있어요.',
        AppLanguage.en =>
          'The allowance for ${r.holH} hours of holiday work, <b>${formatWon(r.holPay, lang)}</b>, is included.',
        AppLanguage.zh =>
          '已包含休息日工作${r.holH}小时的津贴<b>${formatWon(r.holPay, lang)}</b>。',
        AppLanguage.vi =>
          'Đã bao gồm phụ cấp làm việc ngày nghỉ cho ${r.holH} giờ, số tiền <b>${formatWon(r.holPay, lang)}</b>.',
      });
    }
    if (c.roomOn && r.roomAmtTotal > 0) {
      final roomExtra = r.roomBelowMin
          ? switch (lang) {
              AppLanguage.ko => ' 특히 지금은 숙식비를 빼고 나면 최저임금 아래로 내려가는 상태예요.',
              AppLanguage.en =>
                ' In particular, once the room/board deduction is subtracted, your pay falls below the minimum wage.',
              AppLanguage.zh => ' 尤其是扣除食宿费后，工资会低于最低工资标准。',
              AppLanguage.vi =>
                ' Đặc biệt, sau khi trừ tiền ăn ở, mức lương sẽ xuống dưới lương tối thiểu.',
            }
          : '';
      parts.add(switch (lang) {
        AppLanguage.ko =>
          '숙식비 <b>${formatWon(r.roomAmtTotal, lang)}</b>이 공제 대상으로 계산되어 있어요. 서면 동의 없이 공제됐거나 지나치게 큰 금액이라면 그 자체가 문제일 수 있어요.$roomExtra',
        AppLanguage.en =>
          'A room/board deduction of <b>${formatWon(r.roomAmtTotal, lang)}</b> is factored in. If this was deducted without written consent, or the amount is excessive, that itself can be a problem.$roomExtra',
        AppLanguage.zh =>
          '计算中包含了食宿费扣除<b>${formatWon(r.roomAmtTotal, lang)}</b>。如果未经书面同意扣除，或金额过高，这本身就可能是问题。$roomExtra',
        AppLanguage.vi =>
          'Khoản khấu trừ tiền ăn ở <b>${formatWon(r.roomAmtTotal, lang)}</b> đã được tính vào. Nếu bị trừ mà không có sự đồng ý bằng văn bản, hoặc số tiền quá lớn, bản thân điều đó có thể là vấn đề.$roomExtra',
      });
    }
    if (c.tax == TaxMethod.biz) {
      parts.add(switch (lang) {
        AppLanguage.ko =>
          '지금 사업소득 3.3%로 공제되고 있다면, 실제 근무 형태(출퇴근 시간이 정해져 있고 지시를 받는 등)에 따라 근로자로 인정될 수 있어요. '
              '그렇다면 세금 처리 방식과 별개로 주휴수당·퇴직금 같은 다른 권리도 함께 놓치고 있을 가능성이 있어요.',
        AppLanguage.en =>
          'If 3.3% business income tax is currently being deducted, you may still legally be an employee depending on your actual working conditions (fixed hours, receiving directions, etc.). '
              'If so, regardless of how taxes are handled, you may also be missing out on other rights such as the weekly paid-holiday allowance or severance pay.',
        AppLanguage.zh =>
          '如果目前按3.3%的营业所得税扣除，根据实际工作形态（有固定上下班时间、接受指示等），您仍可能被认定为劳动者。'
              '如果是这样，无论税务处理方式如何，您也可能同时错失周休津贴、退休金等其他权利。',
        AppLanguage.vi =>
          'Nếu hiện đang bị khấu trừ 3,3% thuế thu nhập kinh doanh, tùy theo hình thức làm việc thực tế (có giờ giấc cố định, nhận chỉ đạo, v.v.) bạn vẫn có thể được công nhận là người lao động. '
              'Nếu vậy, bất kể cách xử lý thuế thế nào, bạn có thể đang bỏ lỡ các quyền khác như phụ cấp ngày nghỉ hàng tuần hay trợ cấp thôi việc.',
      });
    }
    if (c.size == BizSize.unknown) {
      parts.add(switch (lang) {
        AppLanguage.ko =>
          '사업장 규모를 정확히 몰라 지금은 5인 미만(가산수당 없음) 기준으로 보수적으로 계산했어요. 실제로 5인 이상이라면, 당신은 지금 계산된 것보다 더 큰 금액을 받으셔야 해요.',
        AppLanguage.en =>
          'Since the exact company size is unknown, this was conservatively calculated as under 5 employees (no premium pay). If it actually has 5 or more, you are owed more than this calculation shows.',
        AppLanguage.zh =>
          '由于不确定企业规模，目前按5人以下（无加班费）保守计算。如果实际为5人以上，您应得的金额会比现在计算的更多。',
        AppLanguage.vi =>
          'Vì chưa rõ quy mô doanh nghiệp, hiện tính theo hướng thận trọng là dưới 5 người (không có phụ cấp thêm). Nếu thực tế từ 5 người trở lên, bạn cần được nhận nhiều hơn số tiền đã tính ở đây.',
      });
    }
    if (r.eligible) {
      parts.add(switch (lang) {
        AppLanguage.ko =>
          '1년 이상 근무하고 주 평균 15시간 이상 일했다면 퇴직금 <b>${formatWon(r.severance, lang)}</b>이 발생해요. (근로자퇴직급여 보장법 제8조)',
        AppLanguage.en =>
          'Working a year or more, averaging 15+ hours a week, accrues severance pay of <b>${formatWon(r.severance, lang)}</b>. (Employee Retirement Benefit Security Act Art.8)',
        AppLanguage.zh =>
          '工作满1年以上且周平均15小时以上，将产生退职金<b>${formatWon(r.severance, lang)}</b>。（《劳动者退职给付保障法》第8条）',
        AppLanguage.vi =>
          'Nếu làm từ 1 năm trở lên và bình quân từ 15 giờ/tuần, sẽ phát sinh trợ cấp thôi việc <b>${formatWon(r.severance, lang)}</b>. (Điều 8 Luật Bảo đảm trợ cấp thôi việc)',
      });
    }

    final head = switch (lang) {
      AppLanguage.ko =>
        '지금까지 입력하신 내용을 바탕으로 보면, 당신은 최소 약 <b>${formatWon(gapVal.abs(), lang)}</b>을 더 받으셔야 할 가능성이 높아요. '
            '아래 항목들을 확인해 보세요.',
      AppLanguage.en =>
        'Based on what you have entered so far, it is likely that you are owed at least about <b>${formatWon(gapVal.abs(), lang)}</b> more. '
            'Please check the items below.',
      AppLanguage.zh =>
        '根据您目前输入的内容来看，您很可能至少应多获得约<b>${formatWon(gapVal.abs(), lang)}</b>。'
            '请核对以下各项。',
      AppLanguage.vi =>
        'Dựa trên nội dung bạn đã nhập, nhiều khả năng bạn cần được nhận thêm ít nhất khoảng <b>${formatWon(gapVal.abs(), lang)}</b>. '
            'Hãy kiểm tra các mục dưới đây.',
    };
    final noSpecificCause = switch (lang) {
      AppLanguage.ko => '구체적인 원인은 특정하기 어렵지만, 임금명세서 항목을 하나씩 대조해 보시길 권해요.',
      AppLanguage.en =>
        'It is hard to pinpoint the specific cause, but we recommend checking your payslip items one by one.',
      AppLanguage.zh => '虽然难以明确具体原因，但建议您逐项核对工资单内容。',
      AppLanguage.vi =>
        'Khó xác định nguyên nhân cụ thể, nhưng bạn nên đối chiếu từng mục trong phiếu lương.',
    };
    final body = parts.isNotEmpty
        ? parts.map((p) => '· $p').join('\n\n')
        : noSpecificCause;
    final foot = switch (lang) {
      AppLanguage.ko =>
        '이 진단은 입력값을 근거로 한 참고용 추정이에요. 확정된 체불액은 근로감독관 조사에서 정해지니, 먼저 임금명세서를 요청해 항목별로 비교해 보고 그래도 설명이 안 되면 고용노동부에 상담해 보세요.',
      AppLanguage.en =>
        'This diagnosis is a reference estimate based on your input. The confirmed unpaid amount is determined by a labor inspector\'s investigation, so first request your payslip and compare it item by item — if that still does not explain it, consult the Ministry of Employment and Labor.',
      AppLanguage.zh =>
        '此诊断仅为根据输入值得出的参考性估算。确定的欠薪金额需经劳动监察官调查后才能确定，请先索取工资单逐项对照，若仍无法解释，请咨询劳动部。',
      AppLanguage.vi =>
        'Chẩn đoán này chỉ là ước tính tham khảo dựa trên dữ liệu bạn nhập. Số tiền nợ lương chính thức sẽ do thanh tra lao động điều tra xác định, vì vậy hãy yêu cầu phiếu lương để đối chiếu từng mục trước, nếu vẫn không giải thích được hãy liên hệ Bộ Việc làm và Lao động.',
    };
    return '$head\n\n$body\n\n$foot\n\n${_gapMethodologyNote(lang)}';
  } else {
    parts.add(switch (lang) {
      AppLanguage.ko => '포괄임금제 계약이라면 연장·야간수당이 월급에 미리 합산되어 있을 수 있어요.',
      AppLanguage.en =>
        'If your contract uses a comprehensive (all-inclusive) wage system, overtime and night-work pay may already be built into your monthly salary.',
      AppLanguage.zh => '如果是包干工资制合同，加班费和夜班津贴可能已经预先包含在月薪中。',
      AppLanguage.vi =>
        'Nếu hợp đồng theo hình thức lương trọn gói, phụ cấp làm thêm và làm đêm có thể đã được gộp sẵn vào lương tháng.',
    });
    parts.add(switch (lang) {
      AppLanguage.ko => '상여금, 식대, 교통비처럼 이 계산기가 반영하지 않는 항목이 함께 지급되었을 수 있어요.',
      AppLanguage.en =>
        'Items this calculator does not account for — such as bonuses, meal allowance, or transportation allowance — may have been paid together.',
      AppLanguage.zh => '奖金、伙食费、交通补贴等本计算器未纳入的项目，可能也一并发放了。',
      AppLanguage.vi =>
        'Các khoản mà máy tính này chưa tính đến — như tiền thưởng, tiền ăn, tiền đi lại — có thể đã được trả kèm theo.',
    });
    if (c.tax == TaxMethod.none) {
      parts.add(switch (lang) {
        AppLanguage.ko =>
          '세금이 공제되지 않는다고 선택하셨는데, 실제로는 일부 공제되고 있다면 반대로 계산이 달라질 수 있어요.',
        AppLanguage.en =>
          'You selected that no tax is deducted — if some tax is actually being withheld, the calculation could change the other way.',
        AppLanguage.zh => '您选择了不扣税，但如果实际上确实扣除了部分税款，计算结果则可能相反。',
        AppLanguage.vi =>
          'Bạn đã chọn không bị khấu trừ thuế — nhưng nếu thực tế có khấu trừ một phần, kết quả tính có thể thay đổi theo chiều ngược lại.',
      });
    }

    final head = switch (lang) {
      AppLanguage.ko =>
        '계산 결과보다 약 <b>${formatWon(gapVal.abs(), lang)}</b> 더 받으셨어요. 체불은 아니고, 대부분 계산 방식의 차이예요.',
      AppLanguage.en =>
        'You received about <b>${formatWon(gapVal.abs(), lang)}</b> more than the calculated result. This is not unpaid wages — it is mostly a difference in calculation method.',
      AppLanguage.zh =>
        '您实际收到的金额比计算结果多约<b>${formatWon(gapVal.abs(), lang)}</b>。这不是欠薪，多半是计算方式的差异所致。',
      AppLanguage.vi =>
        'Bạn đã nhận nhiều hơn kết quả tính khoảng <b>${formatWon(gapVal.abs(), lang)}</b>. Đây không phải nợ lương, phần lớn là do khác biệt trong cách tính.',
    };
    final body = parts.map((p) => '· $p').join('\n\n');
    final foot = switch (lang) {
      AppLanguage.ko => '임금명세서의 항목 구성을 확인해 보시면 어떤 항목이 더 포함되어 있는지 알 수 있어요.',
      AppLanguage.en =>
        'Checking the breakdown on your payslip will show you which additional items are included.',
      AppLanguage.zh => '查看工资单的项目构成，即可了解具体多包含了哪些项目。',
      AppLanguage.vi =>
        'Hãy kiểm tra cơ cấu các khoản trong phiếu lương để biết khoản nào đã được cộng thêm.',
    };
    return '$head\n\n$body\n\n$foot\n\n${_gapMethodologyNote(lang)}';
  }
}

/// "이 목록은 어떻게 만들어지나요?" 투명성 안내 — AI가 새 법적 판단을 만들지
/// 않는다는 것을 매번 명시한다.
String _gapMethodologyNote(AppLanguage lang) => switch (lang) {
  AppLanguage.ko =>
    '<b>이 목록은 어떻게 만들어지나요?</b>\n사전에 검수된 법 조항 설명 중, 입력하신 계산값에 해당하는 항목만 규칙에 따라 골라 보여드립니다. AI가 새로운 법적 주장을 만들지 않습니다.',
  AppLanguage.en =>
    '<b>How is this list made?</b>\nWe select, by fixed rule, only pre-reviewed article explanations matching your figures. The AI does not generate new legal arguments.',
  AppLanguage.zh =>
    '<b>此列表如何生成？</b>\n仅按固定规则挑选与您计算数值匹配的、已预先审核的法条说明，AI不会生成新的法律主张。',
  AppLanguage.vi =>
    '<b>Danh sách này được tạo thế nào?</b>\nChúng tôi chỉ chọn theo quy tắc cố định các giải thích điều luật đã kiểm duyệt phù hợp với số liệu của bạn. AI không tạo lập luận pháp lý mới.',
};

String formatWon(num value, AppLanguage lang) {
  final rounded = value.round();
  final digits = rounded.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  final sign = rounded < 0 ? '-' : '';
  final suffix = switch (lang) {
    AppLanguage.ko => '원',
    AppLanguage.en => ' KRW',
    AppLanguage.zh => '韩元',
    AppLanguage.vi => ' KRW',
  };
  return '$sign$buffer$suffix';
}
