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
      AppLanguage.uz => "Boshqa",
      AppLanguage.en => 'Other',
      AppLanguage.tr => "Diğer",
      AppLanguage.tg => "Дигар",
      AppLanguage.fil => "Iba pa",
      AppLanguage.ur => "دیگر",
      AppLanguage.th => "อื่น ๆ",
      AppLanguage.ky => "Башка",
      AppLanguage.km => "ផ្សេងៗ",
      AppLanguage.id => "Lainnya",
      AppLanguage.si => "වෙනත්",
      AppLanguage.bn => "অন্যান্য",
      AppLanguage.my => "အခြား",
      AppLanguage.mn => "Бусад",
      AppLanguage.lo => "ອື່ນໆ",
      AppLanguage.tet => "Seluk",
      AppLanguage.ne => "अन्य",
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
        AppLanguage.uz => "1 oy (joriy oy)",
        AppLanguage.en => '1 month (this month)',
        AppLanguage.tr => "1 ay (bu ay)",
        AppLanguage.tg => "1 моҳ (ин моҳ)",
        AppLanguage.fil => "1 buwan (ngayong buwan)",
        AppLanguage.ur => "1 مہینہ (یہ مہینہ)",
        AppLanguage.th => "1 เดือน (เดือนนี้)",
        AppLanguage.ky => "1 ай (ушул ай)",
        AppLanguage.km => "ខែ 1 (ខែនេះ)",
        AppLanguage.id => "1 bulan (bulan ini)",
        AppLanguage.si => "1 මාසය (මෙම මාසය)",
        AppLanguage.bn => "1 মাস (এই মাস)",
        AppLanguage.my => "1 လ (ယခုလ)",
        AppLanguage.mn => "1 сар (энэ сар)",
        AppLanguage.lo => "1 ເດືອນ (ເດືອນນີ້)",
        AppLanguage.tet => "Fulan 1 (fulan ne'e)",
        AppLanguage.ne => "1 महिना (यो महिना)",
        AppLanguage.zh => '1个月（本月）',
        AppLanguage.vi => '1 tháng (tháng này)',
      };
    }
    if (periodMode == PeriodMode.multi) {
      return switch (lang) {
        AppLanguage.ko => '$n개월',
        AppLanguage.uz => "$n oy",
        AppLanguage.en => '$n months',
        AppLanguage.tr => "$n ay",
        AppLanguage.tg => "$n моҳ",
        AppLanguage.fil => "$n buwan",
        AppLanguage.ur => "$n مہینہ",
        AppLanguage.th => "$n เดือน",
        AppLanguage.ky => "$n ай",
        AppLanguage.km => "ខែ $n",
        AppLanguage.id => "$n bulan",
        AppLanguage.si => "$n මාසය",
        AppLanguage.bn => "$n মাস",
        AppLanguage.my => "$n လ",
        AppLanguage.mn => "$n сар",
        AppLanguage.lo => "$n ເດືອນ",
        AppLanguage.tet => "Fulan $n",
        AppLanguage.ne => "$n महिना",
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
        AppLanguage.uz => "$range ($n oy)",
        AppLanguage.en => '$range ($n months)',
        AppLanguage.tr => "$range ($n ay)",
        AppLanguage.tg => "$range ($n моҳ)",
        AppLanguage.fil => "$range ($n buwan)",
        AppLanguage.ur => "$range ($n مہینہ)",
        AppLanguage.th => "$range ($n เดือน)",
        AppLanguage.ky => "$range ($n ай)",
        AppLanguage.km => "$range ($n ខែ)",
        AppLanguage.id => "$range ($n bulan)",
        AppLanguage.si => "$range ($n මාසය)",
        AppLanguage.bn => "$range ($n মাস)",
        AppLanguage.my => "$range ($n လ)",
        AppLanguage.mn => "$range ($n сар)",
        AppLanguage.lo => "$range ($n ເດືອນ)",
        AppLanguage.tet => "$range (fulan $n)",
        AppLanguage.ne => "$range ($n महिना)",
        AppLanguage.zh => '$range（$n个月）',
        AppLanguage.vi => '$range ($n tháng)',
      };
    }
    return switch (lang) {
      AppLanguage.ko => '$n개월',
      AppLanguage.uz => "$n oy",
      AppLanguage.en => '$n months',
      AppLanguage.tr => "$n ay",
      AppLanguage.tg => "$n моҳ",
      AppLanguage.fil => "$n buwan",
      AppLanguage.ur => "$n مہینہ",
      AppLanguage.th => "$n เดือน",
      AppLanguage.ky => "$n ай",
      AppLanguage.km => "ខែ $n",
      AppLanguage.id => "$n bulan",
      AppLanguage.si => "$n මාසය",
      AppLanguage.bn => "$n মাস",
      AppLanguage.my => "$n လ",
      AppLanguage.mn => "$n сар",
      AppLanguage.lo => "$n ເດືອນ",
      AppLanguage.tet => "Fulan $n",
      AppLanguage.ne => "$n महिना",
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
      AppLanguage.uz => "4 ta asosiy sugʻurta $pct%",
      AppLanguage.en => '4 Major Insurances $pct%',
      AppLanguage.tr => "4 Büyük Sigorta $pct%",
      AppLanguage.tg => "4 Суғуртаи калон $pct%",
      AppLanguage.fil => "4 Malaking Seguro $pct%",
      AppLanguage.ur => "4 بڑا بیمہ $pct%",
      AppLanguage.th => "ประกันภัยหลัก 4% $pct",
      AppLanguage.ky => "4 Чоң камсыздандыруу $pct%",
      AppLanguage.km => "ធានារ៉ាប់រងធំ 4 $pct%",
      AppLanguage.id => "4 Asuransi Besar $pct%",
      AppLanguage.si => "4 විශාල රක්ෂණය $pct%",
      AppLanguage.bn => "4 বড় বীমা $pct%",
      AppLanguage.my => "4 အဓိက အာမခံ $pct%",
      AppLanguage.mn => "4 Том Даатгал $pct%",
      AppLanguage.lo => "4 ປະກັນໄພໃຫຍ່ $pct%",
      AppLanguage.tet => "4 Seguru Boot $pct%",
      AppLanguage.ne => "4 प्रमुख बीमा $pct%",
      AppLanguage.zh => '四大保险 $pct%',
      AppLanguage.vi => '4 loại bảo hiểm $pct%',
    };
  }
  if (tax == TaxMethod.biz) {
    return switch (lang) {
      AppLanguage.ko => '사업소득세 3.3%',
      AppLanguage.uz => "Biznes daromad soligʻi 3.3%",
      AppLanguage.en => 'Business income tax 3.3%',
      AppLanguage.tr => "İşletme gelir vergisi %3.3",
      AppLanguage.tg => "Андози даромади тиҷорат %3.3",
      AppLanguage.fil => "Buwis sa kita ng negosyo 3.3%",
      AppLanguage.ur => "کاروباری آمدنی پر ٹیکس %3.3",
      AppLanguage.th => "ภาษีเงินได้ธุรกิจ 3.3%",
      AppLanguage.ky => "Ишкананын киреше салыгы 3.3%",
      AppLanguage.km => "ពន្ធលើប្រាក់ចំណូលអាជីវកម្ម 3.3%",
      AppLanguage.id => "Pajak penghasilan bisnis %3.3",
      AppLanguage.si => "ව්‍යාපාර ආදායම් බදු 3.3%",
      AppLanguage.bn => "ব্যবসা আয়কর 3.3%",
      AppLanguage.my => "စီးပွားရေးလုပ်ငန်း ဝင်ငွေခွန် 3.3%",
      AppLanguage.mn => "Бизнесийн орлогын татвар 3.3%",
      AppLanguage.lo => "ພາສີລາຍໄດ້ທຸລະກິດ 3.3%",
      AppLanguage.tet => "Impostu rendimentu negósiu 3.3%",
      AppLanguage.ne => "व्यवसाय आयकर 3.3%",
      AppLanguage.zh => '营业所得税 3.3%',
      AppLanguage.vi => 'Thuế thu nhập kinh doanh 3.3%',
    };
  }
  return switch (lang) {
    AppLanguage.ko => '공제 없음',
    AppLanguage.uz => "Chegirma yoʻq",
    AppLanguage.en => 'No deduction',
    AppLanguage.tr => "Kesinti yok",
    AppLanguage.tg => "Тарҳ нест",
    AppLanguage.fil => "Walang bawas",
    AppLanguage.ur => "کوئی کٹوتی نہیں",
    AppLanguage.th => "ไม่มีการหักลดหย่อน",
    AppLanguage.ky => "Эч кандай чегерүү жок",
    AppLanguage.km => "គ្មានការកាត់កង",
    AppLanguage.id => "Tidak ada potongan",
    AppLanguage.si => "කිසිදු අඩු කිරීමක් නැත",
    AppLanguage.bn => "কোনো কর্তন নেই",
    AppLanguage.my => "နုတ်ယူခြင်းမရှိပါ",
    AppLanguage.mn => "Суутгал байхгүй",
    AppLanguage.lo => "ບໍ່ມີການຫັກ",
    AppLanguage.tet => "La iha dedusaun",
    AppLanguage.ne => "कुनै कटौती छैन",
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
    case AppLanguage.uz:
      var t = '';
      if (yrs > 0) t += '$yrs yil ';
      if (months > 0) t += '$months oy';
      return t.trim().isEmpty ? '$days kun' : t.trim();
    case AppLanguage.en:
      var t = '';
      if (yrs > 0) t += '$yrs yr ';
      if (months > 0) t += '$months mo';
      return t.trim().isEmpty ? '$days days' : t.trim();
    case AppLanguage.tr:
      var t = '';
      if (yrs > 0) t += '$yrs yıl ';
      if (months > 0) t += '$months ay';
      return t.trim().isEmpty ? '$days gün' : t.trim();
    case AppLanguage.tg:
      var t = '';
      if (yrs > 0) t += "$yrs сол ";
      if (months > 0) t += "$months моҳ";
      return t.trim().isEmpty ? "$days рӯз" : t.trim();
    case AppLanguage.fil:
      var t = '';
      if (yrs > 0) t += "$yrs taon ";
      if (months > 0) t += "$months buwan";
      return t.trim().isEmpty ? "$days araw" : t.trim();
    case AppLanguage.ur:
      var t = '';
      if (yrs > 0) t += "$yrs سال ";
      if (months > 0) t += "$months ماہ";
      return t.trim().isEmpty ? "$days دن" : t.trim();
    case AppLanguage.th:
      var t = '';
      if (yrs > 0) t += "$yrs ปี ";
      if (months > 0) t += "$months เดือน";
      return t.trim().isEmpty ? "$days วัน" : t.trim();
    case AppLanguage.ky:
      var t = '';
      if (yrs > 0) t += "$yrs жыл ";
      if (months > 0) t += "$months ай";
      return t.trim().isEmpty ? "$days күн" : t.trim();
    case AppLanguage.km:
      var t = '';
      if (yrs > 0) t += "$yrs ឆ្នាំ ";
      if (months > 0) t += "$months ខែ";
      return t.trim().isEmpty ? "$days ថ្ងៃ" : t.trim();
    case AppLanguage.id:
      var t = '';
      if (yrs > 0) t += "$yrs tahun ";
      if (months > 0) t += "$months bulan";
      return t.trim().isEmpty ? "$days hari" : t.trim();
    case AppLanguage.si:
      var t = '';
      if (yrs > 0) t += "$yrs වසර ";
      if (months > 0) t += "$months මාසය";
      return t.trim().isEmpty ? "$days දිනය" : t.trim();
    case AppLanguage.bn:
      var t = '';
      if (yrs > 0) t += "$yrs বছর ";
      if (months > 0) t += "$months মাস";
      return t.trim().isEmpty ? "$days দিন" : t.trim();
    case AppLanguage.my:
      var t = '';
      if (yrs > 0) t += "$yrs နှစ် ";
      if (months > 0) t += "$months လ";
      return t.trim().isEmpty ? "$days ရက်" : t.trim();
    case AppLanguage.mn:
      var t = '';
      if (yrs > 0) t += "$yrs жил ";
      if (months > 0) t += "$months сар";
      return t.trim().isEmpty ? "$days өдөр" : t.trim();
    case AppLanguage.lo:
      var t = '';
      if (yrs > 0) t += "$yrs ປີ ";
      if (months > 0) t += "$months ເດືອນ";
      return t.trim().isEmpty ? "$days ມື້" : t.trim();
    case AppLanguage.tet:
      var t = '';
      if (yrs > 0) t += "$yrs tinan ";
      if (months > 0) t += "$months fulan";
      return t.trim().isEmpty ? "$days loron" : t.trim();
    case AppLanguage.ne:
      var t = '';
      if (yrs > 0) t += "$yrs वर्ष ";
      if (months > 0) t += "$months महिना";
      return t.trim().isEmpty ? "$days दिन" : t.trim();
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
      AppLanguage.uz =>
        "Ishga kirgan sanangizni kiriting va biz sizning ish stajingizni hisoblab, ishdan boʻshatish nafaqasi qoʻllanilishini aytamiz.",
      AppLanguage.en =>
        'Enter your hire date and we will calculate your tenure to tell you whether severance pay applies.',
      AppLanguage.tr =>
        "İşe başlama tarihinizi girin, kıdem tazminatının uygulanıp uygulanmadığını size bildirmek için hizmet sürenizi hesaplayacağız.",
      AppLanguage.tg =>
        "Санаи оғози корро ворид кунед, мо мӯҳлати хидмати шуморо ҳисоб мекунем, то ба шумо хабар диҳем, ки оё ҷуброни хизматӣ татбиқ мешавад ё не.",
      AppLanguage.fil =>
        "Ilagay ang iyong petsa ng pagsisimula ng trabaho, at kakalkulahin namin ang iyong tagal ng serbisyo upang ipaalam sa iyo kung nalalapat ang severance pay.",
      AppLanguage.ur =>
        "اپنی ملازمت شروع کرنے کی تاریخ درج کریں، ہم آپ کی سروس کی مدت کا حساب لگائیں گے تاکہ آپ کو یہ بتا سکیں کہ آیا آپ کو علیحدگی کا معاوضہ لاگو ہوتا ہے۔",
      AppLanguage.th =>
        "กรุณากรอกวันที่เริ่มทำงานของคุณ เราจะคำนวณระยะเวลาการทำงานของคุณเพื่อแจ้งให้ทราบว่าคุณมีสิทธิ์ได้รับเงินชดเชยการเลิกจ้างหรือไม่",
      AppLanguage.ky =>
        "Жумушка орношкон күнүңүздү киргизиңиз, биз кызмат мөөнөтүңүздү эсептеп, кызмат акысы колдонулабы же жокпу, сизге билдиребиз.",
      AppLanguage.km =>
        "សូមបញ្ចូលកាលបរិច្ឆេទចាប់ផ្តើមការងាររបស់អ្នក យើងនឹងគណនារយៈពេលបម្រើការងាររបស់អ្នក ដើម្បីប្រាប់អ្នកថាតើប្រាក់បំណាច់អតីតភាពការងារត្រូវបានអនុវត្តឬអត់។",
      AppLanguage.id =>
        "Masukkan tanggal mulai kerja Anda, kami akan menghitung masa kerja Anda untuk memberi tahu apakah pesangon berlaku.",
      AppLanguage.si =>
        "ඔබගේ සේවා ආරම්භක දිනය ඇතුළත් කරන්න, සේවා කාලය ගණනය කර සේවා කාලය සඳහා වන්දි අදාළ වේද යන්න අපි ඔබට දන්වන්නෙමු.",
      AppLanguage.bn =>
        "আপনার কর্মসংস্থান শুরুর তারিখ লিখুন, আমরা আপনার চাকরির সময়কাল গণনা করব যাতে আপনাকে জানানো যায় যে আপনার বিচ্ছেদ বেতন প্রযোজ্য কিনা।",
      AppLanguage.my =>
        "သင်၏အလုပ်စတင်သည့်ရက်စွဲကို ထည့်သွင်းပါ၊ အလုပ်သက်တမ်းလျော်ကြေး ပေးဆောင်ရခြင်းရှိမရှိကို အသိပေးရန်အတွက် သင်၏ဝန်ဆောင်မှုသက်တမ်းကို ကျွန်ုပ်တို့ တွက်ချက်ပေးပါမည်။",
      AppLanguage.mn =>
        "Ажилд орсон огноогоо оруулна уу, бид таны ажилласан хугацааг тооцоолж, тэтгэмж олгох эсэхийг мэдэгдэнэ.",
      AppLanguage.lo =>
        "ໃສ່ວັນທີເລີ່ມຕົ້ນການເຮັດວຽກຂອງທ່ານ, ພວກເຮົາຈະຄິດໄລ່ໄລຍະເວລາການບໍລິການຂອງທ່ານເພື່ອແຈ້ງໃຫ້ທ່ານຊາບວ່າເງິນຊົດເຊີຍການອອກຈາກວຽກແມ່ນຖືກນຳໃຊ້ຫຼືບໍ່.",
      AppLanguage.tet =>
        "Hatama ita-nia data hahú servisu, ami sei kalkula ita-nia tempu servisu atu informa ba ita se pagamentu indemnizasaun aplika ka lae.",
      AppLanguage.ne =>
        "आफ्नो काम सुरु गरेको मिति प्रविष्ट गर्नुहोस्, र हामी तपाईंको सेवा अवधि गणना गर्नेछौं ताकि तपाईंलाई उपदान लागू हुन्छ वा हुँदैन भनेर जानकारी दिन सकियोस्।",
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
        AppLanguage.uz =>
          "sizning uzluksiz xizmatingiz hali 1 yilga (365 kun) yetmagan — hozirda ${r.days} kun, taxminan $tenureTxt",
        AppLanguage.en =>
          'your continuous service has not yet reached 1 year (365 days) — currently ${r.days} days, about $tenureTxt',
        AppLanguage.tr =>
          "Kesintisiz hizmet süreniz henüz 1 yıla (365 gün) ulaşmadı — şu anda ${r.days} gün, yaklaşık $tenureTxt",
        AppLanguage.tg =>
          "Муддати хидмати бефосилаи шумо ҳанӯз ба 1 сол (365 рӯз) нарасидааст — ҳоло ${r.days} рӯз, тақрибан $tenureTxt",
        AppLanguage.fil =>
          "Ang iyong tuloy-tuloy na panahon ng serbisyo ay hindi pa umaabot sa 1 taon (365 araw) — sa kasalukuyan ay ${r.days} araw, humigit-kumulang $tenureTxt",
        AppLanguage.ur =>
          "آپ کی مسلسل سروس کی مدت ابھی تک 1 سال (365 دن) تک نہیں پہنچی ہے — فی الحال یہ ${r.days} دن ہے، تقریباً $tenureTxt",
        AppLanguage.th =>
          "ระยะเวลาการทำงานต่อเนื่องของคุณยังไม่ถึง 1 ปี (365 วัน) — ปัจจุบันคือ ${r.days} วัน ประมาณ $tenureTxt",
        AppLanguage.ky =>
          "Сиздин үзгүлтүксүз кызмат мөөнөтүңүз азырынча 1 жылга (365 күн) жеткен жок — учурда ${r.days} күн, болжол менен $tenureTxt",
        AppLanguage.km =>
          "រយៈពេលបម្រើការងារបន្តរបស់អ្នកមិនទាន់ដល់ 1 ឆ្នាំ (365 ថ្ងៃ) នៅឡើយទេ — បច្ចុប្បន្ននេះគឺ ${r.days} ថ្ងៃ ប្រហែល $tenureTxt",
        AppLanguage.id =>
          "Masa kerja berkelanjutan Anda belum mencapai 1 tahun (365 hari) — saat ini ${r.days} hari, sekitar $tenureTxt.",
        AppLanguage.si =>
          "ඔබගේ අඛණ්ඩ සේවා කාලය තවමත් වසර 1 (දින 365) දක්වා ළඟා වී නොමැත — දැනට දින ${r.days} ක්, ආසන්න වශයෙන් $tenureTxt.",
        AppLanguage.bn =>
          "আপনার নিরবচ্ছিন্ন পরিষেবার সময় এখনও 1 বছর (365 দিন) হয়নি — বর্তমানে এটি ${r.days} দিন, প্রায় $tenureTxt।",
        AppLanguage.my =>
          "သင်၏ အဆက်မပြတ် ဝန်ဆောင်မှုကာလသည် 1 နှစ် (365 ရက်) မပြည့်သေးပါ — လက်ရှိတွင် ${r.days} ရက်၊ ခန့်မှန်းခြေအားဖြင့် $tenureTxt ဖြစ်ပါသည်။",
        AppLanguage.mn =>
          "Таны тасралтгүй ажилласан хугацаа одоогоор 1 жил (365 өдөр) хүрээгүй байна — одоогоор ${r.days} өдөр, ойролцоогоор $tenureTxt.",
        AppLanguage.lo =>
          "ໄລຍະເວລາການບໍລິການຕໍ່ເນື່ອງຂອງທ່ານຍັງບໍ່ທັນຮອດ 1 ປີ (365 ມື້) — ປະຈຸບັນນີ້ແມ່ນ ${r.days} ມື້, ປະມານ $tenureTxt",
        AppLanguage.tet =>
          "Ita-nia tempu serbisu kontínu seidauk to'o 1 tinan (365 loron) — agora ${r.days} loron, aproximadamente $tenureTxt",
        AppLanguage.ne =>
          "तपाईंको निरन्तर सेवा अवधि अझै 1 वर्ष (365 दिन) पुगेको छैन — हाल ${r.days} दिन, लगभग $tenureTxt",
        AppLanguage.zh => '连续工作年限尚未满1年（365天）（目前${r.days}天，约$tenureTxt）',
        AppLanguage.vi =>
          'thời gian làm việc liên tục chưa đủ 1 năm (365 ngày) (hiện tại ${r.days} ngày, khoảng $tenureTxt)',
      });
    }
    if (!r.over15) {
      reasons.add(switch (lang) {
        AppLanguage.ko => '주당 약정 근로시간이 15시간 미만이에요',
        AppLanguage.uz =>
          "sizning shartnoma boʻyicha haftalik ish soatlaringiz 15 soatdan kam",
        AppLanguage.en =>
          'your contracted weekly working hours are under 15 hours',
        AppLanguage.tr =>
          "Sözleşmeli haftalık çalışma saatleriniz 15 saatin altında.",
        AppLanguage.tg =>
          "Соатҳои кории ҳафтаинаи шартномавии шумо аз 15 соат камтар аст.",
        AppLanguage.fil =>
          "Ang iyong nakakontratang lingguhang oras ng trabaho ay mas mababa sa 15 oras.",
        AppLanguage.ur =>
          "آپ کے معاہدے کے مطابق ہفتہ وار کام کے اوقات 15 گھنٹے سے کم ہیں۔",
        AppLanguage.th =>
          "ชั่วโมงการทำงานต่อสัปดาห์ตามสัญญาของคุณต่ำกว่า 15 ชั่วโมง",
        AppLanguage.ky =>
          "Келишим боюнча жумалык иш сааттарыңыз 15 сааттан аз.",
        AppLanguage.km =>
          "ម៉ោងធ្វើការប្រចាំសប្តាហ៍តាមកិច្ចសន្យារបស់អ្នកគឺតិចជាង 15 ម៉ោង។",
        AppLanguage.id =>
          "Jam kerja mingguan yang Anda sepakati kurang dari 15 jam.",
        AppLanguage.si =>
          "ඔබගේ කොන්ත්‍රාත්ගත සතිපතා වැඩ කරන වේලාවන් පැය 15 ට වඩා අඩුය.",
        AppLanguage.bn => "আপনার চুক্তিবদ্ধ সাপ্তাহিক কাজের সময় 15 ঘন্টার কম।",
        AppLanguage.my =>
          "သင်၏ စာချုပ်ပါ အပတ်စဉ် အလုပ်ချိန်သည် 15 နာရီအောက် လျော့နည်းနေပါသည်။",
        AppLanguage.mn =>
          "Таны гэрээт долоо хоногийн ажлын цаг 15 цагаас бага байна.",
        AppLanguage.lo =>
          "ຊົ່ວໂມງເຮັດວຽກຕໍ່ອາທິດຕາມສັນຍາຂອງທ່ານແມ່ນຕໍ່າກວ່າ 15 ຊົ່ວໂມງ.",
        AppLanguage.tet =>
          "Ita-nia oras serbisu semana-semana tuir kontratu menus husi 15 oras.",
        AppLanguage.ne =>
          "तपाईंको अनुबंधित साप्ताहिक काम गर्ने घण्टा 15 घण्टाभन्दा कम छ।",
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
      AppLanguage.uz =>
        "Xodimlar pensiya nafaqasi xavfsizligi toʻgʻrisidagi qonun ishdan boʻshatish nafaqasi qoʻllanilishi uchun ikkala shart ham bajarilishini talab qiladi: ① kamida 1 yillik uzluksiz xizmat va ② 4 hafta davomida haftasiga oʻrtacha kamida 15 soat. Siz kiritgan maʼlumotlarga koʻra, $reasonsText, shuning uchun ishdan boʻshatish nafaqasi talabi hali bajarilmagan. Ikkala shartni ham bajarganingizdan soʻng, ushbu kalkulyator sizning taxminiy miqdoringizni darhol koʻrsatadi.",
      AppLanguage.en =>
        'The Employee Retirement Benefit Security Act requires both of these to be met before severance pay applies: ① at least 1 year of continuous service, and ② an average of at least 15 hours a week over 4 weeks. '
            'Based on what you entered, $reasonsText, so the severance pay requirement is not yet met. Once you meet both conditions, this calculator will show your estimated amount right away.',
      AppLanguage.tr =>
        "Kıdem Tazminatı Güvence Yasası, kıdem tazminatı uygulanmadan önce bu iki koşulun da yerine getirilmesini gerektirir: ① en az 1 yıl kesintisiz hizmet ve ② 4 hafta boyunca haftada ortalama en az 15 saat. Girdiğiniz bilgilere göre, $reasonsText, bu nedenle kıdem tazminatı şartı henüz karşılanmamıştır. Her iki koşulu da karşıladığınızda, bu hesaplayıcı tahmini tutarınızı hemen gösterecektir.",
      AppLanguage.tg =>
        "Қонун дар бораи кафолати ҷуброни хизмат талаб мекунад, ки пеш аз татбиқи ҷуброни хизмат ҳардуи ин шартҳо иҷро шаванд: ① на камтар аз 1 соли хидмати бефосила ва ② ба ҳисоби миёна на камтар аз 4 соат дар як ҳафта дар тӯли 15 ҳафта. Мувофиқи маълумоти воридкардаи шумо, $reasonsText, аз ин рӯ, шарти ҷуброни хизмат ҳанӯз иҷро нашудааст. Вақте ки шумо ҳарду шартро иҷро мекунед, ин ҳисобкунак фавран маблағи тахминии шуморо нишон медиҳад.",
      AppLanguage.fil =>
        "Ang Batas sa Garantiya ng Severance Pay ay nangangailangan na matugunan ang dalawang kondisyong ito bago maipatupad ang severance pay: ① hindi bababa sa 1 taon ng tuloy-tuloy na serbisyo, at ② isang average ng hindi bababa sa 15 oras bawat linggo sa loob ng 4 na linggo. Batay sa impormasyong iyong inilagay, $reasonsText, kaya hindi pa natutugunan ang kinakailangan para sa severance pay. Kapag natugunan mo ang parehong kondisyon, agad na ipapakita ng calculator na ito ang iyong tinatayang halaga.",
      AppLanguage.ur =>
        "سینیورٹی پے گارنٹی ایکٹ کے تحت، سینیورٹی پے لاگو ہونے سے پہلے ان دونوں شرائط کا پورا ہونا ضروری ہے: ① کم از کم 1 سال کی مسلسل سروس اور ② 4 ہفتوں کے دوران اوسطاً کم از کم 15 گھنٹے فی ہفتہ۔ آپ کی فراہم کردہ معلومات کے مطابق، $reasonsText، اس لیے سینیورٹی پے کی شرط ابھی پوری نہیں ہوئی ہے۔ جب آپ دونوں شرائط پوری کر لیں گے، تو یہ کیلکولیٹر آپ کی تخمینی رقم فوراً دکھا دے گا۔",
      AppLanguage.th =>
        "พระราชบัญญัติการรับประกันเงินชดเชยการออกจากงานกำหนดให้ต้องปฏิบัติตามเงื่อนไขทั้งสองข้อนี้ก่อนที่จะมีการจ่ายเงินชดเชยการออกจากงาน: ① การทำงานต่อเนื่องอย่างน้อย 1 ปี และ ② เฉลี่ยอย่างน้อย 4 ชั่วโมงต่อสัปดาห์เป็นเวลา 15 สัปดาห์ จากข้อมูลที่คุณป้อน $reasonsText ดังนั้นเงื่อนไขการจ่ายเงินชดเชยการออกจากงานจึงยังไม่เป็นไปตามข้อกำหนด เมื่อคุณปฏิบัติตามเงื่อนไขทั้งสองข้อนี้ เครื่องคำนวณนี้จะแสดงจำนวนเงินโดยประมาณของคุณทันที",
      AppLanguage.ky =>
        "Иштен бошотуу жөлөкпулун камсыздоо мыйзамы иштен бошотуу жөлөкпулу колдонулгуча бул эки шарттын тең аткарылышын талап кылат: ① кеминде 1 жыл үзгүлтүксүз кызмат жана ② 4 жума бою жумасына орточо кеминде 15 саат. Сиз киргизген маалыматтарга ылайык, $reasonsText, ошондуктан иштен бошотуу жөлөкпулунун шарты азырынча аткарылган жок. Эки шартты тең аткарганыңызда, бул эсептегич болжолдуу суммаңызды дароо көрсөтөт.",
      AppLanguage.km =>
        "ច្បាប់ស្តីពីការធានាប្រាក់បំណាច់អតីតភាពការងារ តម្រូវឱ្យបំពេញលក្ខខណ្ឌទាំងពីរនេះ មុនពេលដែលប្រាក់បំណាច់អតីតភាពការងារត្រូវបានអនុវត្ត៖ ① បម្រើការងារបន្តយ៉ាងតិច 1 ឆ្នាំ និង ② យ៉ាងតិច 15 ម៉ោងជាមធ្យមក្នុងមួយសប្តាហ៍ សម្រាប់រយៈពេល 4 សប្តាហ៍។ ផ្អែកលើព័ត៌មានដែលអ្នកបានបញ្ចូល $reasonsText ដូច្នេះលក្ខខណ្ឌសម្រាប់ប្រាក់បំណាច់អតីតភាពការងារមិនទាន់ត្រូវបានបំពេញនៅឡើយទេ។ នៅពេលដែលអ្នកបំពេញលក្ខខណ្ឌទាំងពីរនេះ ម៉ាស៊ីនគិតលេខនេះនឹងបង្ហាញចំនួនទឹកប្រាក់ប៉ាន់ស្មានរបស់អ្នកភ្លាមៗ។",
      AppLanguage.id =>
        "Undang-Undang Jaminan Pesangon mensyaratkan kedua kondisi ini terpenuhi sebelum pesangon berlaku: ① setidaknya 1 tahun masa kerja berkelanjutan, dan ② rata-rata minimal 4 jam per minggu selama 15 minggu. Berdasarkan informasi yang Anda masukkan, $reasonsText, oleh karena itu, persyaratan pesangon belum terpenuhi. Setelah Anda memenuhi kedua kondisi tersebut, kalkulator ini akan segera menampilkan perkiraan jumlah Anda.",
      AppLanguage.si =>
        "සේවා කාලය සඳහා වන්දි ගෙවීමට පෙර මෙම කොන්දේසි දෙකම සපුරාලිය යුතු බව සේවා කාලය සඳහා වන්දි සහතික කිරීමේ පනත මගින් නියම කරයි: ① අවම වශයෙන් වසර 1 ක අඛණ්ඩ සේවාවක් සහ ② සති 4 ක් සඳහා සතියකට සාමාන්‍යයෙන් අවම වශයෙන් පැය 15 ක්. ඔබ ඇතුළත් කළ තොරතුරු අනුව, $reasonsText, එබැවින් සේවා කාලය සඳහා වන්දි ගෙවීමේ අවශ්‍යතාවය තවමත් සපුරා නොමැත. ඔබ කොන්දේසි දෙකම සපුරාලන විට, මෙම ගණක යන්ත්‍රය ඔබගේ ඇස්තමේන්තුගත මුදල වහාම පෙන්වනු ඇත.",
      AppLanguage.bn =>
        "সেভারেন্স পে গ্যারান্টি অ্যাক্ট সেভারেন্স পে প্রয়োগ করার আগে এই দুটি শর্ত পূরণ করা আবশ্যক: ① কমপক্ষে 1 বছরের নিরবচ্ছিন্ন পরিষেবা এবং ② 4 সপ্তাহের জন্য প্রতি সপ্তাহে গড়ে কমপক্ষে 15 ঘন্টা। আপনার প্রবেশ করা তথ্যের উপর ভিত্তি করে, $reasonsText, তাই সেভারেন্স পে-এর শর্ত এখনও পূরণ হয়নি। যখন আপনি উভয় শর্ত পূরণ করবেন, তখন এই ক্যালকুলেটরটি আপনার আনুমানিক পরিমাণ অবিলম্বে দেখাবে।",
      AppLanguage.my =>
        "အလုပ်သက်တမ်းအလိုက် ဆုကြေးငွေ အာမခံဥပဒေအရ အလုပ်သက်တမ်းအလိုက် ဆုကြေးငွေ မပေးမီ အောက်ပါအခြေအနေနှစ်ခုလုံး ပြည့်မီရပါမည်- ① အနည်းဆုံး အဆက်မပြတ် ဝန်ဆောင်မှု 1 နှစ်နှင့် ② 4 ပတ်အတွင်း ပျမ်းမျှ အနည်းဆုံး တစ်ပတ်လျှင် 15 နာရီ။ သင်ထည့်သွင်းထားသော အချက်အလက်များအရ $reasonsText ဖြစ်သောကြောင့် အလုပ်သက်တမ်းအလိုက် ဆုကြေးငွေအတွက် လိုအပ်ချက် မပြည့်မီသေးပါ။ အခြေအနေနှစ်ခုလုံး ပြည့်မီပါက ဤဂဏန်းတွက်စက်သည် သင်၏ ခန့်မှန်းခြေပမာဏကို ချက်ချင်းပြသပါမည်။",
      AppLanguage.mn =>
        "Ажлаас халагдсаны тэтгэмжийн баталгааны тухай хуульд ажлаас халагдсаны тэтгэмж олгохоос өмнө дараах хоёр нөхцөлийг хангасан байхыг шаарддаг: ① тасралтгүй 1-өөс доошгүй жил ажилласан байх, ② 4 долоо хоногийн турш долоо хоногт дунджаар 15-оос доошгүй цаг ажилласан байх. Таны оруулсан мэдээллээр $reasonsText тул ажлаас халагдсаны тэтгэмжийн шаардлага хараахан хангагдаагүй байна. Та хоёр нөхцөлийг хоёуланг нь хангасан тохиолдолд энэхүү тооцоолуур таны ойролцоо дүнг нэн даруй харуулах болно.",
      AppLanguage.lo =>
        "ກົດໝາຍວ່າດ້ວຍການຄໍ້າປະກັນເງິນອຸດໜູນການອອກຈາກວຽກຮຽກຮ້ອງໃຫ້ມີການປະຕິບັດຕາມເງື່ອນໄຂສອງຢ່າງນີ້ກ່ອນທີ່ຈະມີການນຳໃຊ້ເງິນອຸດໜູນການອອກຈາກວຽກ: ① ການບໍລິການຕໍ່ເນື່ອງຢ່າງໜ້ອຍ 1 ປີ ແລະ ② ສະເລ່ຍຢ່າງໜ້ອຍ 15 ຊົ່ວໂມງຕໍ່ອາທິດເປັນເວລາ 4 ອາທິດ. ອີງຕາມຂໍ້ມູນທີ່ທ່ານປ້ອນເຂົ້າ, $reasonsText, ດັ່ງນັ້ນເງື່ອນໄຂການໄດ້ຮັບເງິນອຸດໜູນການອອກຈາກວຽກຍັງບໍ່ທັນຖືກປະຕິບັດເທື່ອ. ເມື່ອທ່ານປະຕິບັດຕາມເງື່ອນໄຂທັງສອງຢ່າງ, ເຄື່ອງຄິດໄລ່ນີ້ຈະສະແດງຈຳນວນເງິນທີ່ຄາດຄະເນຂອງທ່ານທັນທີ.",
      AppLanguage.tet =>
        "Lei Garantia Indemnizasaun Serbisu ezije katak kondisaun rua ne'e tenke kumpre antes atu aplika indemnizasaun serbisu: ① serbisu kontínu mínimu 1 tinan no ② média mínimu 15 oras kada semana durante 4 semana. Tuir informasaun ne'ebé ita hatama, $reasonsText, tanba ne'e, kondisaun ba indemnizasaun serbisu seidauk kumpre. Kuandu ita kumpre kondisaun rua ne'e, kalkuladora ne'e sei hatudu kedas ita-nia montante estimadu.",
      AppLanguage.ne =>
        "सेवा निवृत्ति भत्ता सुरक्षा ऐनले सेवा निवृत्ति भत्ता लागू हुनु अघि यी दुई सर्तहरू पूरा गर्नुपर्ने आवश्यकता राख्छ: ① कम्तिमा 1 वर्षको निरन्तर सेवा र ② 4 हप्तासम्म प्रति हप्ता औसत कम्तिमा 15 घण्टा। तपाईंले प्रविष्ट गर्नुभएको जानकारी अनुसार, $reasonsText, यसैले सेवा निवृत्ति भत्ताको शर्त अझै पूरा भएको छैन। जब तपाईंले दुवै सर्तहरू पूरा गर्नुहुन्छ, यो क्यालकुलेटरले तपाईंको अनुमानित रकम तुरुन्तै देखाउनेछ।",
      AppLanguage.zh =>
        '《劳动者退休金保障法》规定，必须同时满足以下两个条件才能获得退休金：①连续工作年限1年以上，②近4周平均每周工作15小时以上。'
            '根据您目前输入的内容，$reasonsText，因此目前尚未满足退休金条件。一旦满足条件，本计算器会立即为您显示预估金额。',
      AppLanguage.vi =>
        'Luật Bảo đảm trợ cấp hưu trí cho người lao động quy định phải đáp ứng đồng thời hai điều kiện sau mới phát sinh trợ cấp thôi việc: ① thời gian làm việc liên tục từ 1 năm trở lên, ② trung bình từ 15 giờ/tuần trở lên tính theo 4 tuần. '
            'Với nội dung bạn đã nhập, $reasonsText nên hiện chưa đáp ứng điều kiện nhận trợ cấp thôi việc. Khi đáp ứng đủ điều kiện, máy tính này sẽ hiển thị ngay số tiền dự kiến.',
    };
  }

  final periodPhrase = switch (lang) {
    AppLanguage.uz =>
      c.leaveDate != null ? 'oxirgi ish kunigacha' : 'bugungacha',
    AppLanguage.ko => c.leaveDate != null ? '퇴사일까지' : '오늘까지',
    AppLanguage.en => c.leaveDate != null ? 'to your last day' : 'to today',
    AppLanguage.tr =>
      c.leaveDate != null ? 'son çalışma gününüze kadar' : 'bugüne kadar',
    AppLanguage.tg =>
      c.leaveDate != null ? "то рӯзи охирини кории шумо" : "то имрӯз",
    AppLanguage.fil =>
      c.leaveDate != null
          ? "hanggang sa iyong huling araw ng trabaho"
          : "hanggang ngayon",
    AppLanguage.ur => c.leaveDate != null ? "آپ کے آخری کام کے دن تک" : "آج تک",
    AppLanguage.th =>
      c.leaveDate != null ? "จนถึงวันทำงานสุดท้ายของคุณ" : "จนถึงวันนี้",
    AppLanguage.ky =>
      c.leaveDate != null
          ? "акыркы жумуш күнүңүзгө чейин"
          : "бүгүнкү күнгө чейин",
    AppLanguage.km =>
      c.leaveDate != null
          ? "រហូតដល់ថ្ងៃធ្វើការចុងក្រោយរបស់អ្នក"
          : "រហូតមកដល់បច្ចុប្បន្ន",
    AppLanguage.id =>
      c.leaveDate != null
          ? "sampai hari kerja terakhir Anda"
          : "sampai hari ini",
    AppLanguage.si =>
      c.leaveDate != null ? "ඔබේ අවසාන වැඩ කරන දිනය දක්වා" : "අද දක්වා",
    AppLanguage.bn =>
      c.leaveDate != null ? "আপনার শেষ কর্মদিবস পর্যন্ত" : "আজ পর্যন্ত",
    AppLanguage.my =>
      c.leaveDate != null ? "သင်၏ နောက်ဆုံးအလုပ်လုပ်သည့်နေ့အထိ" : "ယနေ့အထိ",
    AppLanguage.mn =>
      c.leaveDate != null
          ? "тань сүүлийн ажлын өдөр хүртэл"
          : "өнөөдрийг хүртэл",
    AppLanguage.lo =>
      c.leaveDate != null ? "ຈົນເຖິງມື້ເຮັດວຽກສຸດທ້າຍຂອງທ່ານ" : "ຈົນເຖິງມື້ນີ້",
    AppLanguage.ne =>
      c.leaveDate != null ? 'अन्तिम काम गरेको दिनसम्म' : 'आजसम्म',
    AppLanguage.tet =>
      c.leaveDate != null ? "to'o loron servisu ikus" : "to'o ohin",
    AppLanguage.zh => c.leaveDate != null ? '到离职日' : '到今天',
    AppLanguage.vi =>
      c.leaveDate != null ? 'đến ngày nghỉ việc' : 'đến hôm nay',
  };

  final usedOrdinaryNote = r.usedOrdinary
      ? switch (lang) {
          AppLanguage.ko => ' 최근 임금이 적었던 기간이 있어 평균임금 대신 통상임금 기준으로 계산했어요.',
          AppLanguage.uz =>
            " Yaqinda ish haqi kamroq boʻlganligi sababli, bu oʻrtacha ish haqi oʻrniga oddiy ish haqi yordamida hisoblandi.",
          AppLanguage.en =>
            ' Because there was a period of lower pay recently, this was calculated using the ordinary wage instead of the average wage.',
          AppLanguage.tr =>
            "Yakın zamanda daha düşük ücretli bir dönem olduğu için, bu hesaplama ortalama ücret yerine normal ücret kullanılarak yapılmıştır.",
          AppLanguage.tg =>
            "Азбаски ба наздикӣ давраи каммузд буд, ин ҳисоб бо истифода аз музди меҳнати муқаррарӣ ба ҷои музди миёна анҷом дода шудааст.",
          AppLanguage.fil =>
            "Dahil mayroong kamakailang panahon ng mas mababang sahod, ang pagkalkulang ito ay ginawa gamit ang normal na sahod sa halip na average na sahod.",
          AppLanguage.ur =>
            "چونکہ حال ہی میں کم اجرت کا دور رہا ہے، اس لیے یہ حساب اوسط اجرت کے بجائے عام اجرت کا استعمال کرتے ہوئے کیا گیا ہے۔",
          AppLanguage.th =>
            "เนื่องจากมีช่วงเวลาที่ได้รับค่าจ้างต่ำกว่าปกติเมื่อเร็วๆ นี้ การคำนวณนี้จึงใช้ค่าจ้างปกติแทนค่าจ้างเฉลี่ย",
          AppLanguage.ky =>
            "Жакында төмөн айлык акы төлөнгөн мезгил болгондуктан, бул эсептөө орточо айлык акынын ордуна кадимки айлык акыны колдонуу менен жүргүзүлдү.",
          AppLanguage.km =>
            "ដោយសារតែមានរយៈពេលដែលទទួលបានប្រាក់ឈ្នួលទាបជាងថ្មីៗនេះ ការគណនានេះត្រូវបានធ្វើឡើងដោយប្រើប្រាក់ឈ្នួលធម្មតា ជំនួសឱ្យប្រាក់ឈ្នួលមធ្យម។",
          AppLanguage.id =>
            "Karena ada periode dengan upah yang lebih rendah baru-baru ini, perhitungan ini menggunakan upah normal daripada upah rata-rata.",
          AppLanguage.si =>
            "මෑතකදී අඩු වැටුප් සහිත කාලයක් පැවති බැවින්, මෙම ගණනය කිරීම සාමාන්‍ය වැටුප වෙනුවට සාමාන්‍ය වැටුප භාවිතා කර සිදු කර ඇත.",
          AppLanguage.bn =>
            "যেহেতু সম্প্রতি একটি কম বেতনের সময় ছিল, তাই এই গণনাটি গড় বেতনের পরিবর্তে স্বাভাবিক বেতন ব্যবহার করে করা হয়েছে।",
          AppLanguage.my =>
            "မကြာသေးမီက လုပ်ခနည်းသော ကာလတစ်ခုရှိခဲ့သောကြောင့် ဤတွက်ချက်မှုကို ပျမ်းမျှလုပ်ခအစား ပုံမှန်လုပ်ခကို အသုံးပြု၍ ပြုလုပ်ထားပါသည်။",
          AppLanguage.mn =>
            "Сүүлийн үед цалин багатай байсан тул энэхүү тооцооллыг дундаж цалингийн оронд ердийн цалингаар хийсэн болно.",
          AppLanguage.lo =>
            "ເນື່ອງຈາກມີໄລຍະເວລາທີ່ໄດ້ຮັບຄ່າຈ້າງຕໍ່າກວ່າໃນບໍ່ດົນມານີ້, ການຄິດໄລ່ນີ້ແມ່ນເຮັດໂດຍໃຊ້ຄ່າຈ້າງປົກກະຕິແທນທີ່ຈະເປັນຄ່າຈ້າງສະເລ່ຍ.",
          AppLanguage.tet =>
            "Tanba iha períodu ida ho saláriu ki'ik liu iha tempu resente, kalkulasaun ne'e halo ho saláriu normál, la'ós saláriu médiu.",
          AppLanguage.ne =>
            "हालै कम तलबको अवधि भएकोले, यो गणना औसत तलबको सट्टा सामान्य तलब प्रयोग गरेर गरिएको छ।",
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
    AppLanguage.uz =>
      "Ishga kirgan sanangiz $periodPhrase dan boshlab, siz jami ${r.days} kun, taxminan $tenureTxt uzluksiz ishladingiz. Bu Xodimlar pensiya nafaqasi xavfsizligi toʻgʻrisidagi qonun tomonidan belgilangan ikkala talabni ham qondiradi — ① kamida 1 yillik uzluksiz xizmat va ② 4 hafta davomida haftasiga oʻrtacha kamida 15 soat. Shunday qilib, sizning ish turi (doimiy, shartnoma yoki toʻliqsiz ish kuni) yoki kompaniya hajmidan (hatto 5 nafardan kam xodim boʻlsa ham) qatʼi nazar, siz ishdan boʻshatish nafaqasini olish huquqiga egasiz.$usedOrdinaryNote Formula quyidagicha: oʻrtacha kunlik ish haqi ${formatWon(r.baseDaily, lang)} × 30 kun × (${r.days} xizmat kunlari ÷ 365), bu taxminan <b>${formatWon(r.severance, lang)}</b> ni tashkil qiladi. Esda tuting: ishdan boʻshatish nafaqasi oxirgi ish kuningizdan keyin 14 kun ichida toʻlanishi kerak va uni talab qilish huquqingiz ishdan ketganingizdan keyin 3 yil oʻtgach tugaydi.",
    AppLanguage.en =>
      'From your hire date $periodPhrase, you have worked a total of ${r.days} days, about $tenureTxt continuously. '
          'This satisfies both requirements set by the Employee Retirement Benefit Security Act — ① at least 1 year of continuous service, and ② an average of at least 15 hours a week over 4 weeks. '
          'So regardless of your employment type (regular, contract, or part-time) or company size (even under 5 employees), you have the right to receive severance pay.'
          '$usedOrdinaryNote'
          ' The formula is: average daily wage ${formatWon(r.baseDaily, lang)} × 30 days × (${r.days} days of service ÷ 365), which comes to about <b>${formatWon(r.severance, lang)}</b>. '
          'Remember: severance pay must be paid within 14 days of your last day, and your right to claim it expires 3 years after leaving.',
    AppLanguage.tr =>
      "İşe başlama tarihiniz $periodPhrase itibarıyla, toplam ${r.days} gün, yaklaşık $tenureTxt kesintisiz çalıştınız. Bu, Kıdem Tazminatı Güvence Yasası tarafından belirlenen her iki şartı da karşılamaktadır — ① en az 1 yıl kesintisiz hizmet ve ② 4 hafta boyunca haftada ortalama en az 15 saat. Bu nedenle, istihdam türünüz (düzenli, sözleşmeli veya yarı zamanlı) veya şirket büyüklüğünüz (5 çalışanın altında bile olsa) ne olursa olsun, kıdem tazminatı alma hakkınız vardır.$usedOrdinaryNote Formül şöyledir: ortalama günlük ücret ${formatWon(r.baseDaily, lang)} × 30 gün × (${r.days} hizmet günü ÷ 365), bu da yaklaşık <b>${formatWon(r.severance, lang)}</b> tutarındadır. Unutmayın: kıdem tazminatı son iş gününüzden itibaren 14 gün içinde ödenmeli ve talep hakkınız işten ayrıldıktan 3 yıl sonra sona erer.",
    AppLanguage.tg =>
      "Аз санаи оғози кор $periodPhrase, шумо дар маҷмӯъ ${r.days} рӯз, тақрибан $tenureTxt бефосила кор кардед. Ин ҳарду шартро, ки Қонун дар бораи кафолати ҷуброни хизмат муқаррар кардааст, иҷро мекунад — ① на камтар аз 1 соли хидмати бефосила ва ② ба ҳисоби миёна на камтар аз 4 соат дар як ҳафта дар тӯли 15 ҳафта. Аз ин рӯ, новобаста аз намуди шуғли шумо (доимӣ, шартномавӣ ё нопурра) ё андозаи ширкати шумо (ҳатто агар он аз 5 корманд камтар бошад ҳам), шумо ҳуқуқ доред, ки ҷуброни хизмат гиред.$usedOrdinaryNote Формула чунин аст: музди миёнаи рӯзона ${formatWon(r.baseDaily, lang)} × 30 рӯз × (${r.days} рӯзи хидмат ÷ 365), ки тақрибан <b>${formatWon(r.severance, lang)}</b> мебошад. Дар хотир доред: ҷуброни хизмат бояд дар давоми 14 рӯз аз рӯзи охирини кори шумо пардохт карда шавад ва ҳуқуқи даъвои шумо пас аз 3 сол аз тарк кардани кор ба охир мерасад.",
    AppLanguage.fil =>
      "Mula sa iyong petsa ng pagsisimula ng trabaho na $periodPhrase, nagtrabaho ka nang tuloy-tuloy sa loob ng kabuuang ${r.days} araw, humigit-kumulang $tenureTxt. Natutugunan nito ang parehong kondisyon na itinakda ng Batas sa Garantiya ng Severance Pay — ① hindi bababa sa 1 taon ng tuloy-tuloy na serbisyo, at ② isang average ng hindi bababa sa 15 oras bawat linggo sa loob ng 4 na linggo. Samakatuwid, karapat-dapat kang makatanggap ng severance pay, anuman ang iyong uri ng trabaho (regular, kontraktwal, o part-time) o laki ng kumpanya (kahit na mas mababa sa 5 na empleyado).$usedOrdinaryNote Ang pormula ay: average na pang-araw-araw na sahod ${formatWon(r.baseDaily, lang)} × 30 na araw × (${r.days} araw ng serbisyo ÷ 365), na humigit-kumulang <b>${formatWon(r.severance, lang)}</b>. Tandaan: ang severance pay ay dapat bayaran sa loob ng 14 araw mula sa iyong huling araw ng trabaho, at ang iyong karapatan na mag-claim ay mag-e-expire 3 taon pagkatapos mong umalis sa trabaho.",
    AppLanguage.ur =>
      "آپ کی ملازمت کی تاریخ $periodPhrase سے، آپ نے کل ${r.days} دن، تقریباً $tenureTxt مسلسل کام کیا ہے۔ یہ سینیورٹی پے گارنٹی ایکٹ کے ذریعے مقرر کردہ دونوں شرائط کو پورا کرتا ہے — ① کم از کم 1 سال کی مسلسل سروس اور ② 4 ہفتوں کے دوران اوسطاً کم از کم 15 گھنٹے فی ہفتہ۔ لہذا، آپ کو سینیورٹی پے حاصل کرنے کا حق ہے، قطع نظر اس کے کہ آپ کی ملازمت کی قسم (باقاعدہ، معاہدہ یا جز وقتی) یا آپ کی کمپنی کا سائز (چاہے 5 ملازمین سے کم ہی کیوں نہ ہو)۔$usedOrdinaryNote فارمولا یہ ہے: اوسط یومیہ اجرت ${formatWon(r.baseDaily, lang)} × 30 دن × (${r.days} سروس کے دن ÷ 365)، جو تقریباً <b>${formatWon(r.severance, lang)}</b> بنتا ہے۔ یاد رکھیں: سینیورٹی پے آپ کے آخری کام کے دن سے 14 دنوں کے اندر ادا کی جانی چاہیے، اور آپ کا دعویٰ کرنے کا حق ملازمت چھوڑنے کے 3 سال بعد ختم ہو جاتا ہے۔",
    AppLanguage.th =>
      "ณ วันที่เริ่มงานของคุณคือ $periodPhrase คุณได้ทำงานต่อเนื่องรวม ${r.days} วัน ประมาณ $tenureTxt ซึ่งเป็นไปตามเงื่อนไขทั้งสองข้อที่กำหนดโดยพระราชบัญญัติการรับประกันเงินชดเชยการออกจากงาน — ① การทำงานต่อเนื่องอย่างน้อย 1 ปี และ ② เฉลี่ยอย่างน้อย 4 ชั่วโมงต่อสัปดาห์เป็นเวลา 15 สัปดาห์ ดังนั้น ไม่ว่าประเภทการจ้างงานของคุณจะเป็นแบบใด (ประจำ, สัญญาจ้าง, หรือพาร์ทไทม์) หรือขนาดของบริษัทของคุณ (แม้ว่าจะน้อยกว่า 5 คน) คุณก็มีสิทธิ์ได้รับเงินชดเชยการออกจากงาน$usedOrdinaryNote สูตรคือ: ค่าจ้างรายวันเฉลี่ย ${formatWon(r.baseDaily, lang)} × 30 วัน × (${r.days} วันที่ทำงาน ÷ 365) ซึ่งเท่ากับประมาณ <b>${formatWon(r.severance, lang)}</b> โปรดทราบ: เงินชดเชยการออกจากงานจะต้องจ่ายภายใน 14 วันนับจากวันทำงานสุดท้ายของคุณ และสิทธิ์ในการเรียกร้องของคุณจะหมดอายุใน 3 ปีหลังจากที่คุณออกจากงาน",
    AppLanguage.ky =>
      "Сиздин жумушка кирген күнүңүз $periodPhrase болгондуктан, жалпы ${r.days} күн, болжол менен $tenureTxt үзгүлтүксүз иштедиңиз. Бул Иштен бошотуу жөлөкпулун камсыздоо мыйзамы тарабынан белгиленген эки шартты тең аткарат — ① кеминде 1 жыл үзгүлтүксүз кызмат жана ② 4 жума бою жумасына орточо кеминде 15 саат. Ошондуктан, сиздин жумуштун түрүңүзгө (туруктуу, келишимдик же толук эмес убакыт) же компаниянын көлөмүнө (5 кызматкерден аз болсо да) карабастан, иштен бошотуу жөлөкпулун алууга укугуңуз бар.$usedOrdinaryNote Формула төмөнкүдөй: орточо күндүк эмгек акы ${formatWon(r.baseDaily, lang)} × 30 күн × (${r.days} кызмат күнү ÷ 365), бул болжол менен <b>${formatWon(r.severance, lang)}</b> сумманы түзөт. Эсиңизде болсун: иштен бошотуу жөлөкпулу акыркы иш күнүңүздөн кийин 14 күндүн ичинде төлөнүшү керек жана аны талап кылуу укугуңуз жумуштан кеткенден кийин 3 жылдан кийин бүтөт.",
    AppLanguage.km =>
      "គិតត្រឹមថ្ងៃចាប់ផ្តើមការងាររបស់អ្នកគឺ $periodPhrase អ្នកបានធ្វើការបន្តសរុប ${r.days} ថ្ងៃ ប្រហែល $tenureTxt។ នេះបំពេញតាមលក្ខខណ្ឌទាំងពីរដែលកំណត់ដោយច្បាប់ស្តីពីការធានាប្រាក់បំណាច់អតីតភាពការងារ — ① បម្រើការងារបន្តយ៉ាងតិច 1 ឆ្នាំ និង ② យ៉ាងតិច 15 ម៉ោងជាមធ្យមក្នុងមួយសប្តាហ៍ សម្រាប់រយៈពេល 4 សប្តាហ៍។ ដូច្នេះ អ្នកមានសិទ្ធិទទួលបានប្រាក់បំណាច់អតីតភាពការងារ ដោយមិនគិតពីប្រភេទការងាររបស់អ្នក (ធម្មតា កិច្ចសន្យា ឬក្រៅម៉ោង) ឬទំហំក្រុមហ៊ុនរបស់អ្នក (ទោះបីជាមានបុគ្គលិកតិចជាង 5 នាក់ក៏ដោយ)។$usedOrdinaryNote រូបមន្តគឺ៖ ប្រាក់ឈ្នួលប្រចាំថ្ងៃជាមធ្យម ${formatWon(r.baseDaily, lang)} × 30 ថ្ងៃ × (${r.days} ថ្ងៃបម្រើការងារ ÷ 365) ដែលមានចំនួនប្រហែល <b>${formatWon(r.severance, lang)}</b>។ សូមចំណាំ៖ ប្រាក់បំណាច់អតីតភាពការងារត្រូវតែបង់ក្នុងរយៈពេល 14 ថ្ងៃគិតចាប់ពីថ្ងៃធ្វើការចុងក្រោយរបស់អ្នក ហើយសិទ្ធិទាមទាររបស់អ្នកនឹងផុតកំណត់បន្ទាប់ពី 3 ឆ្នាំគិតចាប់ពីថ្ងៃឈប់ពីការងារ។",
    AppLanguage.id =>
      "Sejak tanggal mulai kerja Anda pada $periodPhrase, Anda telah bekerja secara berkelanjutan selama total ${r.days} hari, sekitar $tenureTxt. Ini memenuhi kedua persyaratan yang ditetapkan oleh Undang-Undang Jaminan Pesangon — ① setidaknya 1 tahun masa kerja berkelanjutan, dan ② rata-rata minimal 4 jam per minggu selama 15 minggu. Oleh karena itu, Anda berhak atas pesangon, terlepas dari jenis pekerjaan Anda (tetap, kontrak, atau paruh waktu) atau ukuran perusahaan Anda (bahkan jika di bawah 5 karyawan).$usedOrdinaryNote Rumusnya adalah: upah harian rata-rata ${formatWon(r.baseDaily, lang)} × 30 hari × (${r.days} hari kerja ÷ 365), yang berjumlah sekitar <b>${formatWon(r.severance, lang)}</b>. Ingat: pesangon harus dibayarkan dalam waktu 14 hari sejak hari kerja terakhir Anda, dan hak Anda untuk mengklaim berakhir 3 tahun setelah Anda berhenti bekerja.",
    AppLanguage.si =>
      "ඔබගේ සේවා ආරම්භක දිනය වන $periodPhrase සිට, ඔබ දින ${r.days} ක්, එනම් ආසන්න වශයෙන් අඛණ්ඩව වසර $tenureTxt ක් සේවය කර ඇත. මෙය විශ්‍රාම වැටුප් සහතික කිරීමේ පනත මගින් නියම කර ඇති කොන්දේසි දෙකම සපුරාලයි — ① අවම වශයෙන් වසර 1 ක අඛණ්ඩ සේවාවක් සහ ② සති 4 ක් සඳහා සතියකට සාමාන්‍යයෙන් අවම වශයෙන් පැය 15 ක්. එබැවින්, ඔබගේ රැකියා වර්ගය (සාමාන්‍ය, කොන්ත්‍රාත් හෝ අර්ධ-කාලීන) හෝ සමාගමේ ප්‍රමාණය (සේවකයින් 5 ට අඩු වුවද) කුමක් වුවත්, ඔබට විශ්‍රාම වැටුපක් ලැබීමට හිමිකම් ඇත.$usedOrdinaryNote සූත්‍රය වන්නේ: සාමාන්‍ය දෛනික වැටුප ${formatWon(r.baseDaily, lang)} × දින 30 × (සේවා දින ${r.days} ÷ 365) වන අතර, එය ආසන්න වශයෙන් <b>${formatWon(r.severance, lang)}</b> කි. මතක තබා ගන්න: විශ්‍රාම වැටුප ඔබගේ අවසාන සේවා දිනයේ සිට දින 14 ක් ඇතුළත ගෙවිය යුතු අතර, ඉල්ලා සිටීමේ අයිතිය රැකියාවෙන් ඉවත් වී වසර 3 කට පසු අවසන් වේ.",
    AppLanguage.bn =>
      "$periodPhrase তারিখে আপনার কর্মসংস্থান শুরু হওয়ার পর থেকে, আপনি মোট ${r.days} দিন, প্রায় $tenureTxt নিরবচ্ছিন্নভাবে কাজ করেছেন। এটি সেভারেন্স পে গ্যারান্টি অ্যাক্ট দ্বারা নির্ধারিত উভয় শর্ত পূরণ করে — ① কমপক্ষে 1 বছরের নিরবচ্ছিন্ন পরিষেবা এবং ② 4 সপ্তাহের জন্য প্রতি সপ্তাহে গড়ে কমপক্ষে 15 ঘন্টা। অতএব, আপনার কর্মসংস্থানের ধরন (নিয়মিত, চুক্তিভিত্তিক, বা খণ্ডকালীন) বা কোম্পানির আকার (এমনকি 5 কর্মচারীর নিচে হলেও) নির্বিশেষে, আপনি সেভারেন্স পে পাওয়ার অধিকারী।$usedOrdinaryNote সূত্রটি হল: গড় দৈনিক বেতন ${formatWon(r.baseDaily, lang)} × 30 দিন × (${r.days} পরিষেবার দিন ÷ 365), যা প্রায় <b>${formatWon(r.severance, lang)}</b>। মনে রাখবেন: সেভারেন্স পে আপনার শেষ কর্মদিবস থেকে 14 দিনের মধ্যে পরিশোধ করতে হবে এবং আপনার দাবি করার অধিকার চাকরি ছাড়ার 3 বছর পর শেষ হয়ে যায়।",
    AppLanguage.my =>
      "$periodPhrase တွင် အလုပ်စတင်ခဲ့သည့်နေ့မှစ၍ သင်သည် စုစုပေါင်း ${r.days} ရက်၊ ခန့်မှန်းခြေအားဖြင့် $tenureTxt အဆက်မပြတ် အလုပ်လုပ်ခဲ့ပါသည်။ ၎င်းသည် အလုပ်သက်တမ်းအလိုက် ဆုကြေးငွေ အာမခံဥပဒေမှ သတ်မှတ်ထားသော အခြေအနေနှစ်ခုလုံးကို ပြည့်မီပါသည် — ① အနည်းဆုံး အဆက်မပြတ် ဝန်ဆောင်မှု 1 နှစ်နှင့် ② 4 ပတ်အတွင်း ပျမ်းမျှ အနည်းဆုံး တစ်ပတ်လျှင် 15 နာရီ။ ထို့ကြောင့် သင်၏ အလုပ်အမျိုးအစား (ပုံမှန်၊ စာချုပ် သို့မဟုတ် အချိန်ပိုင်း) သို့မဟုတ် ကုမ္ပဏီအရွယ်အစား (5 ဝန်ထမ်းအောက်ပင်ဖြစ်စေ) မည်သို့ပင်ရှိစေကာမူ အလုပ်သက်တမ်းအလိုက် ဆုကြေးငွေ ရရှိရန် သင်သည် အရည်အချင်းပြည့်မီပါသည်။$usedOrdinaryNote ဖော်မြူလာမှာ- ပျမ်းမျှနေ့စဉ်လုပ်ခ ${formatWon(r.baseDaily, lang)} × 30 ရက် × (${r.days} ဝန်ဆောင်မှုရက် ÷ 365) ဖြစ်ပြီး ၎င်းသည် ခန့်မှန်းခြေအားဖြင့် <b>${formatWon(r.severance, lang)}</b> ဖြစ်ပါသည်။ မှတ်သားရန်- အလုပ်သက်တမ်းအလိုက် ဆုကြေးငွေကို သင်၏ နောက်ဆုံးအလုပ်လုပ်သည့်နေ့မှစ၍ 14 ရက်အတွင်း ပေးချေရမည်ဖြစ်ပြီး တောင်းဆိုပိုင်ခွင့်သည် အလုပ်မှထွက်ပြီးနောက် 3 နှစ်အကြာတွင် သက်တမ်းကုန်ဆုံးပါသည်။",
    AppLanguage.mn =>
      "Таны ажлын эхлэх огноо $periodPhrase-өөс хойш нийт ${r.days} өдөр, ойролцоогоор $tenureTxt тасралтгүй ажилласан байна. Энэ нь Ажлаас халагдсаны тэтгэмжийн баталгааны тухай хуулиар тогтоосон хоёр нөхцөлийг хоёуланг нь хангаж байна — ① тасралтгүй 1-өөс доошгүй жил ажилласан байх, ② 4 долоо хоногийн турш долоо хоногт дунджаар 15-оос доошгүй цаг ажилласан байх. Тиймээс таны ажлын төрөл (байнгын, гэрээт эсвэл хагас цагийн) эсвэл компанийн хэмжээнээс үл хамааран (5 ажилтнаас бага байсан ч) та ажлаас халагдсаны тэтгэмж авах эрхтэй.$usedOrdinaryNote Томъёо нь: дундаж өдрийн цалин ${formatWon(r.baseDaily, lang)} × 30 өдөр × (${r.days} ажилласан өдөр ÷ 365), энэ нь ойролцоогоор <b>${formatWon(r.severance, lang)}</b> болно. Санах хэрэгтэй: ажлаас халагдсаны тэтгэмжийг таны сүүлийн ажлын өдрөөс хойш 14 хоногийн дотор төлөх ёстой бөгөөд таны нэхэмжлэх эрх ажлаас гарснаас хойш 3 жилийн дараа дуусна.",
    AppLanguage.lo =>
      "ນັບຕັ້ງແຕ່ວັນທີເລີ່ມຕົ້ນເຮັດວຽກຂອງທ່ານ $periodPhrase, ທ່ານໄດ້ເຮັດວຽກຕໍ່ເນື່ອງທັງໝົດ ${r.days} ມື້, ປະມານ $tenureTxt. ນີ້ແມ່ນປະຕິບັດຕາມເງື່ອນໄຂທັງສອງຢ່າງທີ່ກຳນົດໄວ້ໂດຍກົດໝາຍວ່າດ້ວຍການຄໍ້າປະກັນເງິນອຸດໜູນການອອກຈາກວຽກ — ① ການບໍລິການຕໍ່ເນື່ອງຢ່າງໜ້ອຍ 1 ປີ ແລະ ② ສະເລ່ຍຢ່າງໜ້ອຍ 15 ຊົ່ວໂມງຕໍ່ອາທິດເປັນເວລາ 4 ອາທິດ. ດັ່ງນັ້ນ, ບໍ່ວ່າປະເພດການຈ້າງງານຂອງທ່ານ (ປົກກະຕິ, ຕາມສັນຍາ ຫຼື ເຮັດວຽກບໍ່ເຕັມເວລາ) ຫຼື ຂະໜາດຂອງບໍລິສັດຂອງທ່ານ (ເຖິງແມ່ນວ່າມີພະນັກງານຕໍ່າກວ່າ 5 ຄົນ) ກໍຕາມ, ທ່ານມີສິດໄດ້ຮັບເງິນອຸດໜູນການອອກຈາກວຽກ.$usedOrdinaryNote ສູດຄິດໄລ່ແມ່ນ: ຄ່າຈ້າງສະເລ່ຍຕໍ່ມື້ ${formatWon(r.baseDaily, lang)} × 30 ມື້ × (${r.days} ມື້ບໍລິການ ÷ 365), ເຊິ່ງເທົ່າກັບປະມານ <b>${formatWon(r.severance, lang)}</b>. ຈົ່ງຈື່ໄວ້ວ່າ: ເງິນອຸດໜູນການອອກຈາກວຽກຕ້ອງຖືກຈ່າຍພາຍໃນ 14 ມື້ ນັບຕັ້ງແຕ່ວັນເຮັດວຽກສຸດທ້າຍຂອງທ່ານ ແລະ ສິດໃນການຮຽກຮ້ອງຂອງທ່ານຈະໝົດອາຍຸພາຍຫຼັງ 3 ປີ ນັບຕັ້ງແຕ່ທ່ານອອກຈາກວຽກ.",
    AppLanguage.tet =>
      "Husi data hahú serbisu $periodPhrase, ita serbisu kontínu totál ${r.days} loron, aproximadamente $tenureTxt. Ida ne'e kumpre kondisaun rua ne'ebé Lei Garantia Indemnizasaun Serbisu estabelese — ① serbisu kontínu mínimu 1 tinan no ② média mínimu 15 oras kada semana durante 4 semana. Tanba ne'e, maski ita-nia tipu empregu (permanente, kontratu ka part-time) ka tamañu empreza (maski menus husi 5 funsionáriu), ita iha direitu atu simu indemnizasaun serbisu.$usedOrdinaryNote Fórmula mak hanesan ne'e: saláriu diáriu médiu ${formatWon(r.baseDaily, lang)} × 30 loron × (${r.days} loron serbisu ÷ 365), ida ne'e hamutuk aproximadamente <b>${formatWon(r.severance, lang)}</b>. Keta haluha: indemnizasaun serbisu tenke selu iha loron 14 nia laran hahú husi ita-nia loron serbisu ikus, no ita-nia direitu atu halo reklamasaun sei hotu depois tinan 3 husi ita-nia rezignasaun.",
    AppLanguage.ne =>
      "तपाईंको काम सुरु भएको मिति $periodPhrase अनुसार, तपाईंले कुल ${r.days} दिन, लगभग $tenureTxt निरन्तर काम गर्नुभयो। यसले सेवा निवृत्ति भत्ता सुरक्षा ऐनले तोकेका दुवै सर्तहरू पूरा गर्दछ — ① कम्तिमा 1 वर्षको निरन्तर सेवा र ② 4 हप्तासम्म प्रति हप्ता औसत कम्तिमा 15 घण्टा। यसैले, तपाईंको रोजगारीको प्रकार (नियमित, करारमा वा पार्ट-टाइम) वा कम्पनीको आकार (5 जना कर्मचारीभन्दा कम भए पनि) जेसुकै भए पनि, तपाईंलाई सेवा निवृत्ति भत्ता पाउने अधिकार छ।$usedOrdinaryNote सूत्र यस प्रकार छ: औसत दैनिक तलब ${formatWon(r.baseDaily, lang)} × 30 दिन × (${r.days} सेवा दिन ÷ 365), जुन लगभग <b>${formatWon(r.severance, lang)}</b> बराबर हुन्छ। याद राख्नुहोस्: सेवा निवृत्ति भत्ता तपाईंको अन्तिम काम गरेको दिनबाट 14 दिन भित्र भुक्तानी गरिनुपर्छ र दाबी गर्ने तपाईंको अधिकार काम छोडेको 3 वर्ष पछि समाप्त हुन्छ।",
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
      AppLanguage.uz =>
        "Hisoblangan miqdor va siz haqiqatda olgan miqdor deyarli bir xil (${formatWon(gapVal.abs(), lang)} dan kam farq). Siz kiritgan maʼlumotlarga koʻra, hech narsa toʻlanmagan koʻrinmaydi.",
      AppLanguage.en =>
        'The calculated amount and what you actually received are nearly identical (a difference under ${formatWon(gapVal.abs(), lang)}). Based on what you entered, nothing looks specifically unpaid.',
      AppLanguage.tr =>
        "Hesaplanan tutar ile fiilen aldığınız tutar neredeyse aynıdır (${formatWon(gapVal.abs(), lang)} altında bir fark). Girdiğiniz bilgilere göre, özel olarak ödenmemiş görünen bir şey yok.",
      AppLanguage.tg =>
        "Маблағи ҳисобшуда ва маблағи воқеан гирифташуда қариб якхелаанд (фарқият камтар аз ${formatWon(gapVal.abs(), lang)}). Мувофиқи маълумоти воридкардаи шумо, чизе нест, ки махсус пардохт нашуда бошад.",
      AppLanguage.fil =>
        "Ang kinakalkulang halaga at ang aktwal na halagang natanggap mo ay halos pareho (isang pagkakaiba na mas mababa sa ${formatWon(gapVal.abs(), lang)}). Batay sa impormasyong iyong inilagay, walang partikular na lumilitaw na hindi nabayaran.",
      AppLanguage.ur =>
        "حساب شدہ رقم اور آپ کو اصل میں موصول ہونے والی رقم تقریباً یکساں ہے (${formatWon(gapVal.abs(), lang)} سے کم کا فرق)۔ آپ کی فراہم کردہ معلومات کے مطابق، ایسا کچھ بھی نہیں ہے جو خاص طور پر غیر ادا شدہ نظر آئے۔",
      AppLanguage.th =>
        "จำนวนเงินที่คำนวณได้และจำนวนเงินที่คุณได้รับจริงเกือบจะเท่ากัน (ความแตกต่างน้อยกว่า ${formatWon(gapVal.abs(), lang)}) จากข้อมูลที่คุณป้อน ดูเหมือนว่าจะไม่มีอะไรที่ยังไม่ได้รับเป็นพิเศษ",
      AppLanguage.ky =>
        "Эсептелген сумма менен иш жүзүндө алган сумма дээрлик бирдей (${formatWon(gapVal.abs(), lang)} астындагы айырма). Сиз киргизген маалыматтарга ылайык, атайын төлөнбөгөн эч нерсе жоктой көрүнөт.",
      AppLanguage.km =>
        "ចំនួនទឹកប្រាក់ដែលបានគណនា និងចំនួនទឹកប្រាក់ដែលអ្នកបានទទួលគឺស្ទើរតែដូចគ្នា (ខុសគ្នាតិចជាង ${formatWon(gapVal.abs(), lang)})។ ផ្អែកលើព័ត៌មានដែលអ្នកបានបញ្ចូល ហាក់ដូចជាគ្មានអ្វីដែលមិនទាន់បានបង់ជាពិសេសនោះទេ។",
      AppLanguage.id =>
        "Jumlah yang dihitung dan jumlah yang sebenarnya Anda terima hampir sama (perbedaan di bawah ${formatWon(gapVal.abs(), lang)}). Berdasarkan informasi yang Anda masukkan, tidak ada yang tampak belum dibayar secara khusus.",
      AppLanguage.si =>
        "ගණනය කළ මුදල සහ ඔබට ලැබුණු මුදල ආසන්න වශයෙන් සමාන වේ (වෙනස ${formatWon(gapVal.abs(), lang)} ට වඩා අඩුය). ඔබ ඇතුළත් කළ තොරතුරු අනුව, විශේෂයෙන් නොගෙවූ කිසිවක් නොමැත.",
      AppLanguage.bn =>
        "গণনা করা পরিমাণ এবং আপনি প্রকৃতপক্ষে যে পরিমাণ পেয়েছেন তা প্রায় একই (${formatWon(gapVal.abs(), lang)} এর নিচে পার্থক্য)। আপনার প্রবেশ করা তথ্যের উপর ভিত্তি করে, বিশেষভাবে অপরিশোধিত বলে মনে হয় এমন কিছু নেই।",
      AppLanguage.my =>
        "တွက်ချက်ထားသော ပမာဏနှင့် သင်အမှန်တကယ်ရရှိသော ပမာဏသည် အတူတူနီးပါးဖြစ်သည် (${formatWon(gapVal.abs(), lang)} အောက် ကွာခြားမှု)။ သင်ထည့်သွင်းထားသော အချက်အလက်များအရ အထူးတလည် မပေးချေရသေးသော မည်သည့်အရာမှ မရှိပါ။",
      AppLanguage.mn =>
        "Тооцоолсон дүн болон таны бодитоор авсан дүн бараг ижил байна (${formatWon(gapVal.abs(), lang)}-аас бага зөрүү). Таны оруулсан мэдээллээр, тусгайлан төлөгдөөгүй зүйл байхгүй бололтой.",
      AppLanguage.lo =>
        "ຈຳນວນເງິນທີ່ຄິດໄລ່ ແລະ ຈຳນວນເງິນທີ່ທ່ານໄດ້ຮັບຕົວຈິງແມ່ນເກືອບຄືກັນ (ຄວາມແຕກຕ່າງຕໍ່າກວ່າ ${formatWon(gapVal.abs(), lang)}). ອີງຕາມຂໍ້ມູນທີ່ທ່ານປ້ອນເຂົ້າ, ບໍ່ມີສິ່ງໃດທີ່ເບິ່ງຄືວ່າບໍ່ໄດ້ຈ່າຍເປັນພິເສດ.",
      AppLanguage.tet =>
        "Montante ne'ebé kalkula no montante ne'ebé ita simu iha realidade kuaze hanesan (diferensa menus husi ${formatWon(gapVal.abs(), lang)}). Tuir informasaun ne'ebé ita hatama, la iha buat ida ne'ebé parese la selu espesifikamente.",
      AppLanguage.ne =>
        "गणना गरिएको रकम र तपाईंले वास्तवमा प्राप्त गरेको रकम लगभग समान छ (${formatWon(gapVal.abs(), lang)} भन्दा कम भिन्नता)। तपाईंले प्रविष्ट गर्नुभएको जानकारी अनुसार, विशेष गरी भुक्तानी नभएको जस्तो केही देखिँदैन।",
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
        AppLanguage.uz =>
          "Sizning shartnoma boʻyicha oddiy soatlik ish haqingiz <b>${formatWon(r.hourly, lang)}</b>, bu $wageCalcYear yilgi minimal ish haqi <b>${formatWon(minWage().$1, lang)}</b> dan past. Shartnomaning bu qismi, hatto ikkala tomon ham rozi boʻlsa ham, haqiqiy emas va siz har doim minimal ish haqi oʻrtasidagi farqni talab qilishingiz mumkin.",
        AppLanguage.en =>
          'Your contracted ordinary hourly wage is <b>${formatWon(r.hourly, lang)}</b>, which is lower than the $wageCalcYear minimum wage of <b>${formatWon(minWage().$1, lang)}</b>. '
              'This part of the contract is invalid even if both sides agreed to it, and you can always claim the difference from the minimum wage.',
        AppLanguage.tr =>
          "Sözleşmeli normal saatlik ücretiniz <b>${formatWon(r.hourly, lang)}</b>, bu da $wageCalcYear asgari ücreti olan <b>${formatWon(minWage().$1, lang)}</b>'den düşüktür. Sözleşmenin bu kısmı, her iki taraf anlaşmış olsa bile geçersizdir ve asgari ücret farkını her zaman talep edebilirsiniz.",
        AppLanguage.tg =>
          "Музди меҳнати муқаррарии соатбаёни шартномавии шумо <b>${formatWon(r.hourly, lang)}</b> аст, ки аз музди ҳадди ақали $wageCalcYear, ки <b>${formatWon(minWage().$1, lang)}</b> аст, камтар мебошад. Ин қисми шартнома, ҳатто агар ҳарду тараф розӣ бошанд ҳам, беэътибор аст ва шумо ҳамеша метавонед фарқияти музди ҳадди ақалро талаб кунед.",
        AppLanguage.fil =>
          "Ang iyong nakakontratang normal na orasang sahod ay <b>${formatWon(r.hourly, lang)}</b>, na mas mababa kaysa sa minimum na sahod na <b>${formatWon(minWage().$1, lang)}</b> para sa $wageCalcYear. Ang bahaging ito ng kontrata ay walang bisa, kahit na sumang-ayon ang magkabilang panig, at maaari mong i-claim ang pagkakaiba sa minimum na sahod anumang oras.",
        AppLanguage.ur =>
          "آپ کی معاہدے کے مطابق عام فی گھنٹہ اجرت <b>${formatWon(r.hourly, lang)}</b> ہے، جو $wageCalcYear کی کم از کم اجرت <b>${formatWon(minWage().$1, lang)}</b> سے کم ہے۔ معاہدے کا یہ حصہ، چاہے دونوں فریق متفق ہوں، باطل ہے اور آپ ہمیشہ کم از کم اجرت کے فرق کا دعویٰ کر سکتے ہیں۔",
        AppLanguage.th =>
          "ค่าจ้างรายชั่วโมงปกติของคุณตามสัญญาคือ <b>${formatWon(r.hourly, lang)}</b> ซึ่งต่ำกว่าค่าแรงขั้นต่ำของ $wageCalcYear ที่ <b>${formatWon(minWage().$1, lang)}</b> ส่วนนี้ของสัญญาเป็นโมฆะแม้ว่าทั้งสองฝ่ายจะตกลงกันก็ตาม และคุณสามารถเรียกร้องส่วนต่างค่าแรงขั้นต่ำได้เสมอ",
        AppLanguage.ky =>
          "Сиздин келишим боюнча кадимки сааттык эмгек акыңыз <b>${formatWon(r.hourly, lang)}</b>, бул $wageCalcYear минималдуу эмгек акысы болгон <b>${formatWon(minWage().$1, lang)}</b> KRWдан төмөн. Келишимдин бул бөлүгү, эки тарап макулдашса дагы, жараксыз жана сиз ар дайым минималдуу эмгек акынын айырмасын талап кыла аласыз.",
        AppLanguage.km =>
          "អត្រាប្រាក់ឈ្នួលម៉ោងធម្មតាតាមកិច្ចសន្យារបស់អ្នកគឺ <b>${formatWon(r.hourly, lang)}</b> ដែលទាបជាងប្រាក់ឈ្នួលអប្បបរមាសម្រាប់ឆ្នាំ $wageCalcYear គឺ <b>${formatWon(minWage().$1, lang)}</b>។ ផ្នែកនៃកិច្ចសន្យានេះគឺមិនត្រឹមត្រូវទេ ទោះបីជាភាគីទាំងពីរបានយល់ព្រមគ្នាក៏ដោយ ហើយអ្នកតែងតែអាចទាមទារភាពខុសគ្នានៃប្រាក់ឈ្នួលអប្បបរមាបាន។",
        AppLanguage.id =>
          "Upah per jam normal yang Anda sepakati adalah <b>${formatWon(r.hourly, lang)}</b>, yang lebih rendah dari upah minimum $wageCalcYear sebesar <b>${formatWon(minWage().$1, lang)}</b>. Bagian kontrak ini tidak berlaku, bahkan jika kedua belah pihak telah menyetujuinya, dan Anda selalu dapat mengklaim selisih upah minimum.",
        AppLanguage.si =>
          "ඔබගේ කොන්ත්‍රාත් සාමාන්‍ය පැයක වැටුප <b>${formatWon(r.hourly, lang)}</b> වන අතර, එය $wageCalcYear අවම වැටුප වන <b>${formatWon(minWage().$1, lang)}</b> ට වඩා අඩුය. කොන්ත්‍රාත්තුවේ මෙම කොටස, දෙපාර්ශවයම එකඟ වුවද, අවලංගු වන අතර, ඔබට සෑම විටම අවම වැටුප් වෙනස ඉල්ලා සිටිය හැක.",
        AppLanguage.bn =>
          "আপনার চুক্তিবদ্ধ স্বাভাবিক প্রতি ঘন্টার বেতন <b>${formatWon(r.hourly, lang)}</b>, যা $wageCalcYear এর ন্যূনতম মজুরি <b>${formatWon(minWage().$1, lang)}</b> এর চেয়ে কম। চুক্তির এই অংশটি উভয় পক্ষ সম্মত হলেও অবৈধ এবং আপনি সর্বদা ন্যূনতম মজুরির পার্থক্য দাবি করতে পারেন।",
        AppLanguage.my =>
          "သင်၏ စာချုပ်ပါ ပုံမှန်နာရီလုပ်ခသည် <b>${formatWon(r.hourly, lang)}</b> ဖြစ်ပြီး ၎င်းသည် $wageCalcYear ခုနှစ်၏ အနိမ့်ဆုံးလုပ်ခ <b>${formatWon(minWage().$1, lang)}</b> ထက် နည်းပါသည်။ စာချုပ်၏ ဤအပိုင်းသည် နှစ်ဖက်သဘောတူထားသော်လည်း တရားမဝင်ပါ၊ သင်သည် အနိမ့်ဆုံးလုပ်ခ ကွာခြားချက်ကို အမြဲတမ်း တောင်းဆိုနိုင်ပါသည်။",
        AppLanguage.mn =>
          "Таны гэрээт ердийн цагийн цалин <b>${formatWon(r.hourly, lang)}</b> бөгөөд энэ нь $wageCalcYear оны хамгийн бага цалин болох <b>${formatWon(minWage().$1, lang)}</b>-аас бага байна. Гэрээний энэ хэсэг нь хоёр тал тохиролцсон байсан ч хүчингүй бөгөөд та хамгийн бага цалингийн зөрүүг үргэлж нэхэмжилж болно.",
        AppLanguage.lo =>
          "ຄ່າຈ້າງປົກກະຕິຕໍ່ຊົ່ວໂມງຕາມສັນຍາຂອງທ່ານແມ່ນ <b>${formatWon(r.hourly, lang)}</b>, ເຊິ່ງຕໍ່າກວ່າຄ່າແຮງງານຂັ້ນຕໍ່າຂອງປີ $wageCalcYear ທີ່ເປັນ <b>${formatWon(minWage().$1, lang)}</b>. ສ່ວນນີ້ຂອງສັນຍາແມ່ນບໍ່ຖືກຕ້ອງ, ເຖິງແມ່ນວ່າທັງສອງຝ່າຍໄດ້ຕົກລົງກັນແລ້ວກໍຕາມ, ແລະທ່ານສາມາດຮຽກຮ້ອງຄວາມແຕກຕ່າງຂອງຄ່າແຮງງານຂັ້ນຕໍ່າໄດ້ຕະຫຼອດເວລາ.",
        AppLanguage.tet =>
          "Ita-nia saláriu oras normál tuir kontratu mak <b>${formatWon(r.hourly, lang)}</b>, ida ne'e ki'ik liu fali saláriu mínimu $wageCalcYear nian, ne'ebé mak <b>${formatWon(minWage().$1, lang)}</b>. Parte kontratu ne'e inválidu, maski parte rua konkorda, no ita bele sempre husu diferensa saláriu mínimu.",
        AppLanguage.ne =>
          "तपाईंको अनुबंधित सामान्य प्रति घण्टा तलब <b>${formatWon(r.hourly, lang)}</b> छ, जुन $wageCalcYear को न्यूनतम तलब <b>${formatWon(minWage().$1, lang)}</b> भन्दा कम छ। सम्झौताको यो अंश, दुवै पक्ष सहमत भए पनि, अमान्य छ र तपाईंले सधैं न्यूनतम तलबको भिन्नता दाबी गर्न सक्नुहुन्छ।",
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
        AppLanguage.uz =>
          "Haftalik haq toʻlanadigan dam olish kuni uchun <b>${formatWon(r.weeklyPayTotal, lang)}</b> ushbu hisob-kitobga kiritilgan. Agar bu haq sizga toʻlanmagan boʻlsa, uni talab qilishingiz mumkin. (Mehnat standartlari toʻgʻrisidagi qonun, 55-modda)",
        AppLanguage.en =>
          'The weekly paid-holiday allowance of <b>${formatWon(r.weeklyPayTotal, lang)}</b> is included in this calculation. If it is missing from what you actually received, you are owed this amount. (Labor Standards Act Art.55)',
        AppLanguage.tr =>
          "Haftalık ücretli tatil ödeneği olan <b>${formatWon(r.weeklyPayTotal, lang)}</b> bu hesaplamaya dahildir. Fiilen aldığınızda eksikse, bu miktar size borçludur. (İş Kanunu Madde 55)",
        AppLanguage.tg =>
          "Пардохти рухсатии ҳафтаинаи музднок, ки <b>${formatWon(r.weeklyPayTotal, lang)}</b> аст, ба ин ҳисоб дохил карда шудааст. Агар ҳангоми гирифтани он камбудӣ бошад, ин маблағ ба шумо қарздор аст. (Моддаи 55-и Қонуни меҳнат)",
        AppLanguage.fil =>
          "Ang lingguhang bayad sa holiday na <b>${formatWon(r.weeklyPayTotal, lang)}</b> ay kasama sa pagkalkulang ito. Kung ito ay kulang kapag aktwal mong natanggap, ang halagang ito ay utang sa iyo. (Artikulo 55 ng Batas sa Paggawa)",
        AppLanguage.ur =>
          "ہفتہ وار ادا شدہ چھٹی کا الاؤنس، جو <b>${formatWon(r.weeklyPayTotal, lang)}</b> ہے، اس حساب میں شامل ہے۔ اگر آپ کو اصل میں یہ کم ملا ہے، تو یہ رقم آپ کو واجب الادا ہے۔ (لیبر اسٹینڈرڈز ایکٹ آرٹیکل 55)",
        AppLanguage.th =>
          "ค่าจ้างวันหยุดประจำสัปดาห์ที่ได้รับค่าจ้างจำนวน <b>${formatWon(r.weeklyPayTotal, lang)}</b> รวมอยู่ในการคำนวณนี้ หากคุณได้รับไม่ครบเมื่อได้รับจริง จำนวนเงินนี้เป็นหนี้คุณ (มาตรา 55 แห่งพระราชบัญญัติแรงงาน)",
        AppLanguage.ky =>
          "Жумалык акы төлөнүүчү өргүү жөлөкпулу <b>${formatWon(r.weeklyPayTotal, lang)}</b> KRW бул эсептөөгө киргизилген. Эгерде сиз иш жүзүндө алганда жетишсиз болсо, бул сумма сизге карыз. (Эмгек кодексинин 55-беренеси)",
        AppLanguage.km =>
          "ប្រាក់ឧបត្ថម្ភថ្ងៃឈប់សម្រាកប្រចាំសប្តាហ៍ដែលមានប្រាក់ឈ្នួលចំនួន <b>${formatWon(r.weeklyPayTotal, lang)}</b> ត្រូវបានរាប់បញ្ចូលក្នុងការគណនានេះ។ ប្រសិនបើអ្នកមិនបានទទួលចំនួននេះនៅពេលជាក់ស្តែងទេ ចំនួននេះគឺជំពាក់អ្នក។ (មាត្រា 55 នៃច្បាប់ស្តីពីស្តង់ដារការងារ)",
        AppLanguage.id =>
          "Tunjangan cuti berbayar mingguan sebesar <b>${formatWon(r.weeklyPayTotal, lang)}</b> termasuk dalam perhitungan ini. Jika Anda tidak menerimanya secara penuh, jumlah ini adalah hak Anda. (Undang-Undang Ketenagakerjaan Pasal 55)",
        AppLanguage.si =>
          "සතිපතා වැටුප් සහිත නිවාඩු දීමනාව වන <b>${formatWon(r.weeklyPayTotal, lang)}</b> මෙම ගණනයට ඇතුළත් වේ. ඔබට එය ලැබුණු විට අඩු නම්, මෙම මුදල ඔබට හිමි වේ. (කම්කරු නීතියේ 55 වගන්තිය)",
        AppLanguage.bn =>
          "সাপ্তাহিক বেতনভুক্ত ছুটির ভাতা <b>${formatWon(r.weeklyPayTotal, lang)}</b> এই গণনায় অন্তর্ভুক্ত। আপনি যখন এটি প্রকৃতপক্ষে পান তখন যদি এটি অনুপস্থিত থাকে, তবে এই পরিমাণটি আপনার কাছে পাওনা। (শ্রম আইন ধারা 55)",
        AppLanguage.my =>
          "အပတ်စဉ် အခကြေးငွေရုံးပိတ်ရက် ထောက်ပံ့ကြေး <b>${formatWon(r.weeklyPayTotal, lang)}</b> ကို ဤတွက်ချက်မှုတွင် ထည့်သွင်းထားပါသည်။ သင်အမှန်တကယ်ရရှိသောအခါ လျော့နည်းနေပါက ဤပမာဏကို သင့်အား ပေးရန်ရှိပါသည်။ (အလုပ်သမားဥပဒေ ပုဒ်မ 55)",
        AppLanguage.mn =>
          "Долоо хоногийн цалинтай амралтын тэтгэмж болох <b>${formatWon(r.weeklyPayTotal, lang)}</b> энэхүү тооцоололд багтсан болно. Хэрэв та бодитоор авахдаа дутуу байвал энэ мөнгийг танд өртэй байна. (Хөдөлмөрийн тухай хуулийн 55-р зүйл)",
        AppLanguage.lo =>
          "ເງິນອຸດໜູນວັນພັກທີ່ມີຄ່າຈ້າງຕໍ່ອາທິດ <b>${formatWon(r.weeklyPayTotal, lang)}</b> ແມ່ນລວມຢູ່ໃນການຄິດໄລ່ນີ້. ຖ້າທ່ານໄດ້ຮັບຕົວຈິງບໍ່ຄົບ, ຈຳນວນນີ້ແມ່ນເປັນໜີ້ທ່ານ. (ມາດຕາ 55 ຂອງກົດໝາຍແຮງງານ)",
        AppLanguage.tet =>
          "Subsídiu férias semana-semana ho pagamentu, hamutuk <b>${formatWon(r.weeklyPayTotal, lang)}</b>, inklui iha kalkulasaun ne'e. Se iha realidade ita simu menus, montante ne'e empreza deve ita. (Lei Traballu Artigu 55)",
        AppLanguage.ne =>
          "साप्ताहिक सशुल्क बिदा भत्ता <b>${formatWon(r.weeklyPayTotal, lang)}</b> यस गणनामा समावेश छ। यदि तपाईंले वास्तवमा प्राप्त गर्दा यो अपुग छ भने, यो रकम तपाईंलाई तिर्नुपर्नेछ। (श्रम कानून धारा 55)",
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
              AppLanguage.uz =>
                "5 yoki undan ortiq xodimi boʻlgan ish joylari odatdagi soatlik ish haqining 1,5 barobarini toʻlashi kerak. (Mehnat standartlari toʻgʻrisidagi qonun, 56-modda)",
              AppLanguage.en =>
                'Workplaces with 5 or more employees must pay 1.5 times the ordinary hourly wage. (Labor Standards Act Art.56)',
              AppLanguage.tr =>
                "5 veya daha fazla çalışanı olan işyerleri, normal saatlik ücretin 1.5 katını ödemelidir. (İş Kanunu Madde 56)",
              AppLanguage.tg =>
                "Корхонаҳое, ки 5 ё зиёда корманд доранд, бояд 1.5 баробари музди меҳнати муқаррарии соатбайъ пардохт кунанд. (Моддаи 56-и Қонуни меҳнат)",
              AppLanguage.fil =>
                "Ang mga lugar ng trabaho na may 5 o higit pang empleyado ay dapat magbayad ng 1.5 beses ng normal na orasang sahod. (Artikulo 56 ng Batas sa Paggawa)",
              AppLanguage.ur =>
                "5 یا اس سے زیادہ ملازمین والے کام کی جگہوں کو عام فی گھنٹہ اجرت کا 1.5 گنا ادا کرنا چاہیے۔ (لیبر اسٹینڈرڈز ایکٹ آرٹیکل 56)",
              AppLanguage.th =>
                "สถานประกอบการที่มีพนักงาน 5 คนขึ้นไปจะต้องจ่ายค่าจ้างปกติ 1.5 เท่า (มาตรา 56 แห่งพระราชบัญญัติแรงงาน)",
              AppLanguage.ky =>
                "5 же андан көп кызматкери бар ишканалар кадимки сааттык эмгек акынын 1.5 эселенген өлчөмүн төлөшү керек. (Эмгек кодексинин 56-беренеси)",
              AppLanguage.km =>
                "កន្លែងធ្វើការដែលមានបុគ្គលិក 5 នាក់ ឬច្រើនជាងនេះ ត្រូវតែបង់ប្រាក់ 1.5 ដងនៃអត្រាប្រាក់ឈ្នួលម៉ោងធម្មតា។ (មាត្រា 56 នៃច្បាប់ស្តីពីស្តង់ដារការងារ)",
              AppLanguage.id =>
                "Tempat kerja dengan 5 karyawan atau lebih harus membayar 1.5 kali upah per jam normal. (Undang-Undang Ketenagakerjaan Pasal 56)",
              AppLanguage.si =>
                "5 හෝ ඊට වැඩි සේවකයන් සිටින සේවා ස්ථාන සාමාන්‍ය පැයක වැටුප මෙන් 1.5 ගුණයක් ගෙවිය යුතුය. (කම්කරු ප්‍රමිතීන් පනතේ 56 වගන්තිය)",
              AppLanguage.bn =>
                "5 বা তার বেশি কর্মচারী সহ কর্মস্থলগুলিকে স্বাভাবিক প্রতি ঘন্টার বেতনের 1.5 গুণ পরিশোধ করতে হবে। (শ্রম আইন ধারা 56)",
              AppLanguage.my =>
                "ဝန်ထမ်း 5 ဦး သို့မဟုတ် ထို့ထက်ပိုသော လုပ်ငန်းခွင်များသည် ပုံမှန်နာရီလုပ်ခ၏ 1.5 ဆကို ပေးချေရပါမည်။ (အလုပ်သမားဥပဒေ ပုဒ်မ 56)",
              AppLanguage.mn =>
                "5 ба түүнээс дээш ажилтантай ажлын байрууд ердийн цагийн цалингийн 1.5 дахин их хэмжээг төлөх ёстой. (Хөдөлмөрийн тухай хуулийн 56-р зүйл)",
              AppLanguage.lo =>
                "ສະຖານທີ່ເຮັດວຽກທີ່ມີພະນັກງານ 5 ຄົນ ຫຼື ຫຼາຍກວ່ານັ້ນ, ຕ້ອງຈ່າຍຄ່າຈ້າງຕໍ່ຊົ່ວໂມງປົກກະຕິ 1.5 ເທົ່າ. (ມາດຕາ 56 ຂອງກົດໝາຍແຮງງານ)",
              AppLanguage.tet =>
                "Fatin serbisu ne'ebé iha funsionáriu 5 ka liu, tenke selu 1.5 vezes saláriu oras normál. (Lei Traballu Artigu 56)",
              AppLanguage.ne =>
                "5 वा सोभन्दा बढी कर्मचारी भएका कार्यस्थलहरूले सामान्य प्रति घण्टा तलबको 1.5 गुणा भुक्तानी गर्नुपर्छ। (श्रम कानून धारा 56)",
              AppLanguage.zh => '5人以上企业必须按通常时薪的1.5倍支付。（《劳动基准法》第56条）',
              AppLanguage.vi =>
                'Nơi làm việc từ 5 người trở lên phải trả 1,5 lần lương giờ thông thường. (Điều 56 Luật Tiêu chuẩn Lao động)',
            }
          : switch (lang) {
              AppLanguage.ko => '5인 미만이라도 일한 시간만큼 통상임금(1.0배)은 지급되어야 해요.',
              AppLanguage.uz =>
                "5 nafardan kam xodim boʻlsa ham, ishlagan soatlaringiz uchun oddiy ish haqi (1,0×) toʻlanishi shart.",
              AppLanguage.en =>
                'Even with under 5 employees, you must still be paid the ordinary wage (1.0×) for hours worked.',
              AppLanguage.tr =>
                "5 çalışanın altında bile olsa, çalışılan saatler için normal ücret (1.0×) ödenmelidir.",
              AppLanguage.tg =>
                "Ҳатто агар аз 5 корманд камтар бошад ҳам, барои соатҳои корӣ музди меҳнати муқаррарӣ (1.0×) бояд пардохт карда шавад.",
              AppLanguage.fil =>
                "Kahit na mas mababa sa 5 na empleyado, ang normal na sahod (1.0×) ay dapat bayaran para sa mga oras na nagtrabaho.",
              AppLanguage.ur =>
                "چاہے 5 ملازمین سے کم ہی کیوں نہ ہوں، کام کے اوقات کے لیے عام اجرت (1.0×) ادا کی جانی چاہیے۔",
              AppLanguage.th =>
                "แม้ว่าจะมีพนักงานน้อยกว่า 5 คน ก็ควรจ่ายค่าจ้างปกติ (1.0 เท่า) สำหรับชั่วโมงที่ทำงาน",
              AppLanguage.ky =>
                "5 кызматкерден аз болсо дагы, иштеген сааттар үчүн кадимки эмгек акы (1.0×) төлөнүшү керек.",
              AppLanguage.km =>
                "ទោះបីជាមានបុគ្គលិកតិចជាង 5 នាក់ក៏ដោយ ក៏ប្រាក់ឈ្នួលធម្មតា (1.0×) ត្រូវតែបង់សម្រាប់ម៉ោងធ្វើការ។",
              AppLanguage.id =>
                "Bahkan jika di bawah 5 karyawan, upah normal (1.0×) harus dibayarkan untuk jam kerja.",
              AppLanguage.si =>
                "5 සේවකයන්ට වඩා අඩු වුවද, වැඩ කරන පැය ගණන සඳහා සාමාන්‍ය වැටුප (1.0×) ගෙවිය යුතුය.",
              AppLanguage.bn =>
                "এমনকি 5 কর্মচারীর নিচে হলেও, কাজ করা ঘন্টার জন্য স্বাভাবিক বেতন (1.0×) পরিশোধ করতে হবে।",
              AppLanguage.my =>
                "ဝန်ထမ်း 5 ဦးအောက်ပင်ဖြစ်စေကာမူ အလုပ်လုပ်ခဲ့သော နာရီများအတွက် ပုံမှန်လုပ်ခ (1.0×) ကို ပေးချေရပါမည်။",
              AppLanguage.mn =>
                "5 ажилтнаас бага байсан ч ажилласан цагийн хувьд ердийн цалин (1.0×) төлөх ёстой.",
              AppLanguage.lo =>
                "ເຖິງແມ່ນວ່າມີພະນັກງານຕໍ່າກວ່າ 5 ຄົນກໍຕາມ, ຄ່າຈ້າງປົກກະຕິ (1.0×) ຕ້ອງຖືກຈ່າຍສຳລັບຊົ່ວໂມງທີ່ເຮັດວຽກ.",
              AppLanguage.tet =>
                "Maski menus husi 5 funsionáriu, saláriu normál (1.0×) ba oras serbisu tenke selu.",
              AppLanguage.ne =>
                "5 जना कर्मचारीभन्दा कम भए पनि, काम गरेको घण्टाको लागि सामान्य तलब (1.0 गुणा) भुक्तानी गरिनुपर्छ।",
              AppLanguage.zh => '即使不足5人，也必须按工作时间支付通常工资（1.0倍）。',
              AppLanguage.vi =>
                'Dù dưới 5 người, vẫn phải trả lương thông thường (1,0 lần) cho số giờ đã làm.',
            };
      parts.add(switch (lang) {
        AppLanguage.ko =>
          '연장근로 ${r.otH}시간에 대한 가산수당 <b>${formatWon(r.otPay, lang)}</b>이 포함되어 있어요. $otNote',
        AppLanguage.uz =>
          "Qoʻshimcha ish vaqti uchun ${r.otH} soatlik ustama haqi, <b>${formatWon(r.otPay, lang)}</b>, kiritilgan. $otNote",
        AppLanguage.en =>
          'The premium pay for ${r.otH} hours of overtime, <b>${formatWon(r.otPay, lang)}</b>, is included. $otNote',
        AppLanguage.tr =>
          "${r.otH} saatlik fazla mesai için prim ücreti, <b>${formatWon(r.otPay, lang)}</b>, dahildir. $otNote",
        AppLanguage.tg =>
          "Пардохти иловагӣ барои ${r.otH} соат кори изофа, <b>${formatWon(r.otPay, lang)}</b>, дохил карда шудааст. $otNote",
        AppLanguage.fil =>
          "Ang premium pay para sa ${r.otH} oras ng overtime ay kasama, na <b>${formatWon(r.otPay, lang)}</b>. $otNote",
        AppLanguage.ur =>
          "${r.otH} گھنٹے کے اوور ٹائم کے لیے پریمیم اجرت، <b>${formatWon(r.otPay, lang)}</b>، شامل ہے۔ $otNote",
        AppLanguage.th =>
          "ค่าจ้างพิเศษสำหรับการทำงานล่วงเวลา ${r.otH} ชั่วโมง จำนวน <b>${formatWon(r.otPay, lang)}</b> รวมอยู่ด้วย $otNote",
        AppLanguage.ky =>
          "${r.otH} сааттык ашыкча иштеген убакыт үчүн премиум эмгек акы, <b>${formatWon(r.otPay, lang)}</b> KRW, киргизилген. $otNote",
        AppLanguage.km =>
          "ប្រាក់ឈ្នួលបន្ថែមសម្រាប់ការធ្វើការថែមម៉ោង ${r.otH} ម៉ោង ចំនួន <b>${formatWon(r.otPay, lang)}</b> ត្រូវបានរាប់បញ្ចូល។ $otNote",
        AppLanguage.id =>
          "Upah premi untuk ${r.otH} jam lembur, sebesar <b>${formatWon(r.otPay, lang)}</b>, sudah termasuk. $otNote",
        AppLanguage.si =>
          "${r.otH} පැය අතිකාල සඳහා වාරික ගාස්තුව, <b>${formatWon(r.otPay, lang)}</b>, ඇතුළත් වේ. $otNote",
        AppLanguage.bn =>
          "${r.otH} ঘন্টার ওভারটাইমের জন্য প্রিমিয়াম বেতন, <b>${formatWon(r.otPay, lang)}</b>, অন্তর্ভুক্ত। $otNote",
        AppLanguage.my =>
          "${r.otH} နာရီ အချိန်ပိုလုပ်ခအတွက် ပရီမီယံလုပ်ခ <b>${formatWon(r.otPay, lang)}</b> ကို ထည့်သွင်းထားပါသည်။ $otNote",
        AppLanguage.mn =>
          "${r.otH} цагийн илүү цагийн нэмэгдэл цалин болох <b>${formatWon(r.otPay, lang)}</b> багтсан болно. $otNote",
        AppLanguage.lo =>
          "ຄ່າຈ້າງພິເສດສຳລັບການເຮັດວຽກລ່ວງເວລາ ${r.otH} ຊົ່ວໂມງ, <b>${formatWon(r.otPay, lang)}</b>, ແມ່ນລວມຢູ່ແລ້ວ. $otNote",
        AppLanguage.tet =>
          "Saláriu prémiu ba oras extra ${r.otH}, <b>${formatWon(r.otPay, lang)}</b>, inklui. $otNote",
        AppLanguage.ne =>
          "${r.otH} घण्टाको ओभरटाइमको लागि प्रिमियम तलब, <b>${formatWon(r.otPay, lang)}</b>, समावेश छ। $otNote",
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
        AppLanguage.uz =>
          "Tungi ish (22:00–06:00) uchun ${r.ntH} soatlik ustama haqi, <b>${formatWon(r.ntPay, lang)}</b>, kiritilgan.",
        AppLanguage.en =>
          'The premium pay for ${r.ntH} hours of night work (10 PM–6 AM), <b>${formatWon(r.ntPay, lang)}</b>, is included.',
        AppLanguage.tr =>
          "${r.ntH} saatlik gece çalışması (22:00–06:00) için prim ücreti, <b>${formatWon(r.ntPay, lang)}</b>, dahildir.",
        AppLanguage.tg =>
          "Пардохти иловагӣ барои ${r.ntH} соат кори шабона (22:00–06:00), <b>${formatWon(r.ntPay, lang)}</b>, дохил карда шудааст.",
        AppLanguage.fil =>
          "Ang premium pay para sa ${r.ntH} oras ng trabaho sa gabi (22:00–06:00) ay kasama, na <b>${formatWon(r.ntPay, lang)}</b>.",
        AppLanguage.ur =>
          "${r.ntH} گھنٹے کے رات کے کام (22:00–06:00) کے لیے پریمیم اجرت، <b>${formatWon(r.ntPay, lang)}</b>، شامل ہے۔",
        AppLanguage.th =>
          "ค่าจ้างพิเศษสำหรับการทำงานกะกลางคืน ${r.ntH} ชั่วโมง (22:00–06:00) จำนวน <b>${formatWon(r.ntPay, lang)}</b> รวมอยู่ด้วย",
        AppLanguage.ky =>
          "${r.ntH} сааттык түнкү жумуш (22:00–06:00) үчүн премиум эмгек акы, <b>${formatWon(r.ntPay, lang)}</b> KRW, киргизилген.",
        AppLanguage.km =>
          "ប្រាក់ឈ្នួលបន្ថែមសម្រាប់ការធ្វើការពេលយប់ ${r.ntH} ម៉ោង (22:00–06:00) ចំនួន <b>${formatWon(r.ntPay, lang)}</b> ត្រូវបានរាប់បញ្ចូល។",
        AppLanguage.id =>
          "Upah premi untuk ${r.ntH} jam kerja malam (22:00–06:00), sebesar <b>${formatWon(r.ntPay, lang)}</b>, sudah termasuk.",
        AppLanguage.si =>
          "${r.ntH} පැය රාත්‍රී වැඩ සඳහා (ප.ව. 22:00–පෙ.ව. 06:00) වාරික ගාස්තුව, <b>${formatWon(r.ntPay, lang)}</b>, ඇතුළත් වේ.",
        AppLanguage.bn =>
          "${r.ntH} ঘন্টার রাতের কাজের (22:00–06:00) জন্য প্রিমিয়াম বেতন, <b>${formatWon(r.ntPay, lang)}</b>, অন্তর্ভুক্ত।",
        AppLanguage.my =>
          "${r.ntH} နာရီ ညဆိုင်းလုပ်ခ (22:00–06:00) အတွက် ပရီမီယံလုပ်ခ <b>${formatWon(r.ntPay, lang)}</b> ကို ထည့်သွင်းထားပါသည်။",
        AppLanguage.mn =>
          "${r.ntH} цагийн шөнийн ажлын (22:00–06:00) нэмэгдэл цалин болох <b>${formatWon(r.ntPay, lang)}</b> багтсан болно.",
        AppLanguage.lo =>
          "ຄ່າຈ້າງພິເສດສຳລັບການເຮັດວຽກກາງຄືນ ${r.ntH} ຊົ່ວໂມງ (22:00–06:00), <b>${formatWon(r.ntPay, lang)}</b>, ແມ່ນລວມຢູ່ແລ້ວ.",
        AppLanguage.tet =>
          "Saláriu prémiu ba oras serbisu kalan ${r.ntH} (22:00–06:00), <b>${formatWon(r.ntPay, lang)}</b>, inklui.",
        AppLanguage.ne =>
          "${r.ntH} घण्टाको रात्रिकालीन काम (22:00–06:00) को लागि प्रिमियम तलब, <b>${formatWon(r.ntPay, lang)}</b>, समावेश छ।",
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
        AppLanguage.uz =>
          "Bayram kunlaridagi ish uchun ${r.holH} soatlik nafaqa, <b>${formatWon(r.holPay, lang)}</b>, kiritilgan.",
        AppLanguage.en =>
          'The allowance for ${r.holH} hours of holiday work, <b>${formatWon(r.holPay, lang)}</b>, is included.',
        AppLanguage.tr =>
          "${r.holH} saatlik tatil çalışması ödeneği, <b>${formatWon(r.holPay, lang)}</b>, dahildir.",
        AppLanguage.tg =>
          "Пардохти рухсатии ${r.holH} соат, <b>${formatWon(r.holPay, lang)}</b>, дохил карда шудааст.",
        AppLanguage.fil =>
          "Ang bayad sa trabaho sa holiday para sa ${r.holH} oras ay kasama, na <b>${formatWon(r.holPay, lang)}</b>.",
        AppLanguage.ur =>
          "${r.holH} گھنٹے کی چھٹی کے کام کا الاؤنس، <b>${formatWon(r.holPay, lang)}</b>، شامل ہے۔",
        AppLanguage.th =>
          "ค่าจ้างพิเศษสำหรับการทำงานในวันหยุด ${r.holH} ชั่วโมง จำนวน <b>${formatWon(r.holPay, lang)}</b> รวมอยู่ด้วย",
        AppLanguage.ky =>
          "${r.holH} сааттык майрам күндөрү иштегендиги үчүн жөлөкпул, <b>${formatWon(r.holPay, lang)}</b> KRW, киргизилген.",
        AppLanguage.km =>
          "ប្រាក់ឧបត្ថម្ភសម្រាប់ការធ្វើការនៅថ្ងៃឈប់សម្រាក ${r.holH} ម៉ោង ចំនួន <b>${formatWon(r.holPay, lang)}</b> ត្រូវបានរាប់បញ្ចូល។",
        AppLanguage.id =>
          "Tunjangan kerja libur untuk ${r.holH} jam, sebesar <b>${formatWon(r.holPay, lang)}</b>, sudah termasuk.",
        AppLanguage.si =>
          "${r.holH} පැය නිවාඩු වැඩ දීමනාව, <b>${formatWon(r.holPay, lang)}</b>, ඇතුළත් වේ.",
        AppLanguage.bn =>
          "${r.holH} ঘন্টার ছুটির কাজের ভাতা, <b>${formatWon(r.holPay, lang)}</b>, অন্তর্ভুক্ত।",
        AppLanguage.my =>
          "${r.holH} နာရီ ရုံးပိတ်ရက်လုပ်ခ ထောက်ပံ့ကြေး <b>${formatWon(r.holPay, lang)}</b> ကို ထည့်သွင်းထားပါသည်။",
        AppLanguage.mn =>
          "${r.holH} цагийн амралтын өдрийн ажлын нэмэгдэл цалин болох <b>${formatWon(r.holPay, lang)}</b> багтсан болно.",
        AppLanguage.lo =>
          "ເງິນອຸດໜູນການເຮັດວຽກໃນວັນພັກ ${r.holH} ຊົ່ວໂມງ, <b>${formatWon(r.holPay, lang)}</b>, ແມ່ນລວມຢູ່ແລ້ວ.",
        AppLanguage.tet =>
          "Subsídiu serbisu feriadu oras ${r.holH}, <b>${formatWon(r.holPay, lang)}</b>, inklui.",
        AppLanguage.ne =>
          "${r.holH} घण्टाको बिदाको कामको भत्ता, <b>${formatWon(r.holPay, lang)}</b>, समावेश छ।",
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
              AppLanguage.uz =>
                " Xususan, yotoqxona/ovqatlanish uchun chegirma olib tashlangandan soʻng, maoshingiz eng kam ish haqidan past boʻladi.",
              AppLanguage.en =>
                ' In particular, once the room/board deduction is subtracted, your pay falls below the minimum wage.',
              AppLanguage.tr =>
                "Özellikle, oda/yemek kesintisi yapıldıktan sonra, ücretiniz asgari ücretin altına düşmektedir.",
              AppLanguage.tg =>
                "Махсусан, пас аз тарҳ кардани маблағи хона/хӯрок, музди меҳнати шумо аз музди ҳадди ақал камтар мешавад.",
              AppLanguage.fil =>
                "Kapansin-pansin, pagkatapos ng pagbawas para sa silid/pagkain, ang iyong sahod ay bumaba sa ibaba ng minimum na sahod.",
              AppLanguage.ur =>
                "خاص طور پر، کمرے/کھانے کی کٹوتی کے بعد، آپ کی اجرت کم از کم اجرت سے کم ہو جاتی ہے۔",
              AppLanguage.th =>
                "โดยเฉพาะอย่างยิ่ง หลังจากหักค่าที่พัก/อาหารแล้ว ค่าจ้างของคุณจะต่ำกว่าค่าแรงขั้นต่ำ",
              AppLanguage.ky =>
                "Өзгөчө, бөлмө/тамак-аш үчүн кармоо жүргүзүлгөндөн кийин, эмгек акыңыз минималдуу эмгек акыдан төмөн түшүп жатат.",
              AppLanguage.km =>
                "ជាពិសេស បន្ទាប់ពីការកាត់ប្រាក់សម្រាប់បន្ទប់/អាហារ ប្រាក់ឈ្នួលរបស់អ្នកបានធ្លាក់ចុះក្រោមប្រាក់ឈ្នួលអប្បបរមា។",
              AppLanguage.id =>
                "Secara khusus, setelah pemotongan kamar/makan, upah Anda turun di bawah upah minimum.",
              AppLanguage.si =>
                "විශේෂයෙන්ම, කාමර/ආහාර අඩු කිරීමෙන් පසු, ඔබේ වැටුප අවම වැටුපට වඩා අඩු වේ.",
              AppLanguage.bn =>
                "বিশেষ করে, রুম/খাবারের জন্য কর্তন করার পর, আপনার বেতন ন্যূনতম মজুরির নিচে নেমে আসে।",
              AppLanguage.my =>
                "အထူးသဖြင့် အခန်း/အစားအသောက် ဖြတ်တောက်ပြီးနောက် သင်၏လုပ်ခသည် အနိမ့်ဆုံးလုပ်ခအောက်သို့ ကျဆင်းသွားပါသည်။",
              AppLanguage.mn =>
                "Ялангуяа, өрөө/хоолны хасалт хийсний дараа таны цалин хамгийн бага цалингаас доогуур болж байна.",
              AppLanguage.lo =>
                "ໂດຍສະເພາະ, ຫຼັງຈາກການຫັກຄ່າຫ້ອງ/ອາຫານ, ຄ່າຈ້າງຂອງທ່ານແມ່ນຕໍ່າກວ່າຄ່າແຮງງານຂັ້ນຕໍ່າ.",
              AppLanguage.tet =>
                "Espesialmente, depois halo dedusaun ba kuartu/ai-han, ita-nia saláriu tun ba menus husi saláriu mínimu.",
              AppLanguage.ne =>
                "विशेष गरी, कोठा/खाना कटौती गरिसकेपछि, तपाईंको तलब न्यूनतम तलबभन्दा कम हुन्छ।",
              AppLanguage.zh => ' 尤其是扣除食宿费后，工资会低于最低工资标准。',
              AppLanguage.vi =>
                ' Đặc biệt, sau khi trừ tiền ăn ở, mức lương sẽ xuống dưới lương tối thiểu.',
            }
          : '';
      parts.add(switch (lang) {
        AppLanguage.ko =>
          '숙식비 <b>${formatWon(r.roomAmtTotal, lang)}</b>이 공제 대상으로 계산되어 있어요. 서면 동의 없이 공제됐거나 지나치게 큰 금액이라면 그 자체가 문제일 수 있어요.$roomExtra',
        AppLanguage.uz =>
          "Yotoqxona/ovqatlanish uchun <b>${formatWon(r.roomAmtTotal, lang)}</b> miqdorida chegirma hisobga olingan. Agar bu yozma roziliksiz chegirilgan boʻlsa yoki miqdor haddan tashqari koʻp boʻlsa, bu oʻz-oʻzidan muammo boʻlishi mumkin.$roomExtra",
        AppLanguage.en =>
          'A room/board deduction of <b>${formatWon(r.roomAmtTotal, lang)}</b> is factored in. If this was deducted without written consent, or the amount is excessive, that itself can be a problem.$roomExtra',
        AppLanguage.tr =>
          "<b>${formatWon(r.roomAmtTotal, lang)}</b> tutarında bir oda/yemek kesintisi hesaba katılmıştır. Bu, yazılı onay olmadan kesildiyse veya miktar aşırıysa, bu başlı başına bir sorun olabilir.$roomExtra",
        AppLanguage.tg =>
          "Тарҳи хона/хӯрок ба маблағи <b>${formatWon(r.roomAmtTotal, lang)}</b> ба назар гирифта шудааст. Агар ин бе розигии хаттӣ тарҳ карда шуда бошад ё маблағ аз ҳад зиёд бошад, ин метавонад худ як мушкилот бошад.$roomExtra",
        AppLanguage.fil =>
          "Isang pagbawas para sa silid/pagkain na nagkakahalaga ng <b>${formatWon(r.roomAmtTotal, lang)}</b> ang isinasaalang-alang. Kung ito ay ibinawas nang walang nakasulat na pahintulot o kung ang halaga ay labis, ito mismo ay maaaring maging isang problema.$roomExtra",
        AppLanguage.ur =>
          "<b>${formatWon(r.roomAmtTotal, lang)}</b> کی کمرے/کھانے کی کٹوتی کو مدنظر رکھا گیا ہے۔ اگر یہ تحریری اجازت کے بغیر کاٹا گیا تھا یا رقم بہت زیادہ تھی، تو یہ بذات خود ایک مسئلہ ہو سکتا ہے۔$roomExtra",
        AppLanguage.th =>
          "มีการพิจารณาการหักค่าที่พัก/อาหารจำนวน <b>${formatWon(r.roomAmtTotal, lang)}</b> หากมีการหักเงินนี้โดยไม่ได้รับความยินยอมเป็นลายลักษณ์อักษร หรือจำนวนเงินมากเกินไป อาจเป็นปัญหาในตัวมันเอง$roomExtra",
        AppLanguage.ky =>
          "<b>${formatWon(r.roomAmtTotal, lang)}</b> KRW суммасындагы бөлмө/тамак-аш үчүн кармоо эске алынган. Эгерде бул жазуу жүзүндөгү макулдуксуз кармалса же сумма ашыкча болсо, бул өзүнчө көйгөй болушу мүмкүн.$roomExtra",
        AppLanguage.km =>
          "ការកាត់ប្រាក់សម្រាប់បន្ទប់/អាហារចំនួន <b>${formatWon(r.roomAmtTotal, lang)}</b> ត្រូវបានរាប់បញ្ចូល។ ប្រសិនបើនេះត្រូវបានកាត់ដោយគ្មានការយល់ព្រមជាលាយលក្ខណ៍អក្សរ ឬចំនួនទឹកប្រាក់ច្រើនហួសហេតុ នេះអាចជាបញ្ហាដោយខ្លួនឯង។$roomExtra",
        AppLanguage.id =>
          "Pemotongan kamar/makan sebesar <b>${formatWon(r.roomAmtTotal, lang)}</b> telah diperhitungkan. Jika ini dipotong tanpa persetujuan tertulis atau jumlahnya berlebihan, ini bisa menjadi masalah tersendiri.$roomExtra",
        AppLanguage.si =>
          "<b>${formatWon(r.roomAmtTotal, lang)}</b> කාමර/ආහාර අඩු කිරීමක් සැලකිල්ලට ගෙන ඇත. මෙය ලිඛිත අනුමැතියකින් තොරව අඩු කර ඇත්නම් හෝ මුදල අධික නම්, එයම ගැටලුවක් විය හැකිය.$roomExtra",
        AppLanguage.bn =>
          "<b>${formatWon(r.roomAmtTotal, lang)}</b> পরিমাণের একটি রুম/খাবারের কর্তন বিবেচনা করা হয়েছে। যদি এটি লিখিত সম্মতি ছাড়াই কর্তন করা হয় বা পরিমাণটি অতিরিক্ত হয়, তবে এটি নিজেই একটি সমস্যা হতে পারে।$roomExtra",
        AppLanguage.my =>
          "<b>${formatWon(r.roomAmtTotal, lang)}</b> ပမာဏရှိသော အခန်း/အစားအသောက် ဖြတ်တောက်မှုကို ထည့်သွင်းစဉ်းစားထားပါသည်။ ၎င်းကို စာဖြင့်ရေးသားခွင့်ပြုချက်မရှိဘဲ ဖြတ်တောက်ခဲ့ပါက သို့မဟုတ် ပမာဏသည် အလွန်အကျွံဖြစ်ပါက ၎င်းသည် ပြဿနာတစ်ခု ဖြစ်နိုင်ပါသည်။$roomExtra",
        AppLanguage.mn =>
          "<b>${formatWon(r.roomAmtTotal, lang)}</b> хэмжээний өрөө/хоолны хасалтыг тооцоолсон болно. Хэрэв үүнийг бичгээр зөвшөөрөлгүйгээр хассан эсвэл хэмжээ нь хэтэрхий их байвал энэ нь өөрөө асуудал байж болно.$roomExtra",
        AppLanguage.lo =>
          "ການຫັກຄ່າຫ້ອງ/ອາຫານຈຳນວນ <b>${formatWon(r.roomAmtTotal, lang)}</b> ໄດ້ຖືກນຳມາພິຈາລະນາແລ້ວ. ຖ້າສິ່ງນີ້ຖືກຫັກໂດຍບໍ່ມີການຍິນຍອມເປັນລາຍລັກອັກສອນ ຫຼື ຈຳນວນເງິນຫຼາຍເກີນໄປ, ນີ້ອາດຈະເປັນບັນຫາໃນຕົວມັນເອງ.$roomExtra",
        AppLanguage.tet =>
          "Dedusaun ba kuartu/ai-han ho montante <b>${formatWon(r.roomAmtTotal, lang)}</b> inklui ona iha kalkulasaun. Se ida ne'e deduzidu la ho autorizasaun hakerek ka montante ne'e boot liu, ida ne'e bele sai problema ida mesak.$roomExtra",
        AppLanguage.ne =>
          "<b>${formatWon(r.roomAmtTotal, lang)}</b> रकमको कोठा/खाना कटौती हिसाबमा लिइएको छ। यदि यो लिखित सहमति बिना कटौती गरिएको हो वा रकम अत्यधिक छ भने, यो आफैंमा एउटा समस्या हुन सक्छ।$roomExtra",
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
        AppLanguage.uz =>
          "Agar hozirda 3,3% biznes daromad soligʻi chegirilayotgan boʻlsa, siz haqiqiy ish sharoitlaringizga (belgilangan ish soatlari, koʻrsatmalar olish va h.k.) qarab qonuniy ravishda hali ham xodim boʻlishingiz mumkin. Agar shunday boʻlsa, soliqlar qanday boshqarilishidan qatʼi nazar, siz haftalik pullik taʼtil nafaqasi yoki ishdan boʻshatish nafaqasi kabi boshqa huquqlardan ham mahrum boʻlishingiz mumkin.",
        AppLanguage.en =>
          'If 3.3% business income tax is currently being deducted, you may still legally be an employee depending on your actual working conditions (fixed hours, receiving directions, etc.). '
              'If so, regardless of how taxes are handled, you may also be missing out on other rights such as the weekly paid-holiday allowance or severance pay.',
        AppLanguage.tr =>
          "Şu anda %3.3 oranında ticari gelir vergisi kesiliyorsa, gerçek çalışma koşullarınıza (sabit saatler, talimat alma vb.) bağlı olarak yasal olarak hala bir çalışan olabilirsiniz. Eğer öyleyse, vergilerin nasıl ele alındığına bakılmaksızın, haftalık ücretli tatil ödeneği veya kıdem tazminatı gibi diğer haklardan da mahrum kalıyor olabilirsiniz.",
        AppLanguage.tg =>
          "Агар айни замон андози даромади тиҷоратӣ бо меъёри %3.3 тарҳ карда шавад, шумо метавонед вобаста ба шароити воқеии кори худ (соатҳои муқаррарӣ, гирифтани дастурҳо ва ғайра) аз ҷиҳати қонунӣ ҳанӯз ҳам корманд бошед. Агар ин тавр бошад, новобаста аз он ки андозҳо чӣ гуна коркард мешаванд, шумо метавонед аз дигар ҳуқуқҳо, ба монанди пардохти рухсатии ҳафтаинаи музднок ё ҷуброни хизмат, маҳрум бошед.",
        AppLanguage.fil =>
          "Kung kasalukuyan kang binabawasan ng 3.3% na buwis sa kita ng negosyo, maaari ka pa ring legal na isang empleyado depende sa iyong aktwal na kondisyon sa pagtatrabaho (nakapirming oras, pagtanggap ng mga tagubilin, atbp.). Kung gayon, anuman ang paraan ng paghawak sa mga buwis, maaari ka ring nawawalan ng iba pang mga karapatan tulad ng lingguhang bayad sa holiday o severance pay.",
        AppLanguage.ur =>
          "اگر فی الحال 3.3% کی کاروباری آمدنی پر ٹیکس کاٹا جا رہا ہے، تو آپ کی اصل کام کی شرائط (مقررہ اوقات، ہدایات وصول کرنا وغیرہ) کے لحاظ سے آپ قانونی طور پر اب بھی ایک ملازم ہو سکتے ہیں۔ اگر ایسا ہے، تو ٹیکسوں کو کس طرح سنبھالا جاتا ہے اس سے قطع نظر، آپ دیگر حقوق، جیسے ہفتہ وار ادا شدہ چھٹی کا الاؤنس یا سینیورٹی پے، سے بھی محروم ہو سکتے ہیں۔",
        AppLanguage.th =>
          "หากปัจจุบันมีการหักภาษีรายได้ธุรกิจในอัตราร้อยละ 3.3 คุณอาจยังคงเป็นลูกจ้างตามกฎหมาย ขึ้นอยู่กับสภาพการทำงานจริงของคุณ (ชั่วโมงคงที่ การรับคำสั่ง ฯลฯ) หากเป็นเช่นนั้น ไม่ว่าภาษีจะถูกจัดการอย่างไร คุณอาจถูกปฏิเสธสิทธิ์อื่นๆ เช่น ค่าจ้างวันหยุดประจำสัปดาห์ที่ได้รับค่าจ้าง หรือเงินชดเชยการออกจากงาน",
        AppLanguage.ky =>
          "Эгерде учурда %3.3 коммерциялык киреше салыгы кармалып жатса, анда сиздин иш жүзүндөгү эмгек шарттарыңызга (туруктуу сааттар, көрсөтмөлөрдү алуу ж.б.) жараша, сиз дагы эле мыйзамдуу түрдө кызматкер болушуңуз мүмкүн. Эгер ошондой болсо, салыктар кандайча каралганына карабастан, жумалык акы төлөнүүчү өргүү жөлөкпулу же иштен бошотуу жөлөкпулу сыяктуу башка укуктардан да ажырап калышыңыз мүмкүн.",
        AppLanguage.km =>
          "ប្រសិនបើអ្នកកំពុងត្រូវបានកាត់ពន្ធលើប្រាក់ចំណូលអាជីវកម្មក្នុងអត្រា 3.3% បច្ចុប្បន្ននេះ អ្នកនៅតែអាចជាបុគ្គលិកស្របច្បាប់ អាស្រ័យលើលក្ខខណ្ឌការងារជាក់ស្តែងរបស់អ្នក (ម៉ោងកំណត់ ការទទួលការណែនាំជាដើម)។ ប្រសិនបើដូច្នេះមែន ដោយមិនគិតពីរបៀបដែលពន្ធត្រូវបានដោះស្រាយ អ្នកក៏អាចនឹងបាត់បង់សិទ្ធិផ្សេងទៀតដូចជា ប្រាក់ឧបត្ថម្ភថ្ងៃឈប់សម្រាកប្រចាំសប្តាហ៍ដែលមានប្រាក់ឈ្នួល ឬប្រាក់បំណាច់អតីតភាពការងារផងដែរ។",
        AppLanguage.id =>
          "Jika Anda saat ini dipotong pajak penghasilan bisnis sebesar 3.3%, Anda mungkin masih secara hukum adalah seorang karyawan, tergantung pada kondisi kerja Anda yang sebenarnya (jam kerja tetap, menerima instruksi, dll.). Jika demikian, terlepas dari bagaimana pajak ditangani, Anda mungkin juga kehilangan hak-hak lain seperti tunjangan cuti berbayar mingguan atau pesangon.",
        AppLanguage.si =>
          "වර්තමානයේ ඔබෙන් වාණිජ ආදායම් බදු 3.3%ක් අඩු කරන්නේ නම්, ඔබේ සැබෑ සේවා කොන්දේසි (ස්ථාවර පැය ගණන, උපදෙස් ලබා ගැනීම, ආදිය) අනුව ඔබ තවමත් නීත්‍යානුකූලව සේවකයෙකු විය හැකිය. එසේ නම්, බදු හසුරුවන ආකාරය නොසලකා, ඔබට සතිපතා වැටුප් සහිත නිවාඩු දීමනා හෝ සේවා කාලය සඳහා වන්දි වැනි වෙනත් අයිතිවාසිකම් ද අහිමි විය හැකිය.",
        AppLanguage.bn =>
          "যদি বর্তমানে %3.3 হারে ব্যবসায়িক আয়কর কর্তন করা হয়, তবে আপনার প্রকৃত কাজের শর্তাবলী (নির্দিষ্ট ঘন্টা, নির্দেশাবলী গ্রহণ ইত্যাদি) এর উপর নির্ভর করে আপনি আইনত এখনও একজন কর্মচারী হতে পারেন। যদি তাই হয়, তবে করগুলি কীভাবে পরিচালিত হয় তা নির্বিশেষে, আপনি সাপ্তাহিক বেতনভুক্ত ছুটির ভাতা বা সেভারেন্স পে-এর মতো অন্যান্য অধিকার থেকেও বঞ্চিত হতে পারেন।",
        AppLanguage.my =>
          "လက်ရှိတွင် စီးပွားရေးဝင်ငွေခွန် 3.3% ဖြတ်တောက်ခံရပါက သင်၏ အမှန်တကယ် အလုပ်အခြေအနေများ (သတ်မှတ်နာရီများ၊ ညွှန်ကြားချက်များ လက်ခံရရှိခြင်း စသည်ဖြင့်) ပေါ်မူတည်၍ သင်သည် တရားဝင် ဝန်ထမ်းတစ်ဦး ဖြစ်နေနိုင်ပါသည်။ ထိုသို့ဆိုပါက အခွန်များကို မည်သို့ကိုင်တွယ်သည်ဖြစ်စေ အပတ်စဉ် အခကြေးငွေရုံးပိတ်ရက် ထောက်ပံ့ကြေး သို့မဟုတ် အလုပ်သက်တမ်းအလိုက် ဆုကြေးငွေကဲ့သို့သော အခြားအခွင့်အရေးများကိုလည်း သင်ဆုံးရှုံးနေနိုင်ပါသည်။",
        AppLanguage.mn =>
          "Хэрэв одоогоор 3.3%-ийн бизнесийн орлогын татвар суутгагдаж байгаа бол таны бодит ажлын нөхцөл байдлаас (тогтмол цаг, заавар авах гэх мэт) хамааран та хууль ёсны дагуу ажилтан хэвээр байж болно. Хэрэв тийм бол татварыг хэрхэн зохицуулж байгаагаас үл хамааран долоо хоногийн цалинтай амралтын тэтгэмж эсвэл ажлаас халагдсаны тэтгэмж зэрэг бусад эрхээ алдаж байж болно.",
        AppLanguage.lo =>
          "ຖ້າປະຈຸບັນນີ້ມີການຫັກພາສີລາຍໄດ້ທາງທຸລະກິດໃນອັດຕາ 3.3%, ທ່ານອາດຈະຍັງຄົງເປັນພະນັກງານຕາມກົດໝາຍໂດຍອີງໃສ່ເງື່ອນໄຂການເຮັດວຽກຕົວຈິງຂອງທ່ານ (ຊົ່ວໂມງຄົງທີ່, ການໄດ້ຮັບຄຳສັ່ງ, ແລະອື່ນໆ). ຖ້າເປັນແນວນັ້ນ, ບໍ່ວ່າພາສີຈະຖືກຈັດການແນວໃດກໍຕາມ, ທ່ານອາດຈະຖືກລິດຮອນສິດອື່ນໆເຊັ່ນ: ເງິນອຸດໜູນວັນພັກທີ່ມີຄ່າຈ້າງຕໍ່ອາທິດ ຫຼື ເງິນອຸດໜູນການອອກຈາກວຽກ.",
        AppLanguage.tet =>
          "Se agora deduz ona impostu rendimentu komersiál ho taxa %3.3, ita bele kontinua sai funsionáriu legalmente, depende ba ita-nia kondisaun serbisu reál (oras fixu, simu instrusaun, no seluk-seluk tan). Se nune'e, maski la haree ba oinsá impostu sira trata, ita bele lakon direitu seluk hanesan subsídiu férias semana-semana ho pagamentu ka indemnizasaun serbisu.",
        AppLanguage.ne =>
          "यदि हाल 3.3% को व्यावसायिक आयकर कटौती भइरहेको छ भने, तपाईंको वास्तविक काम गर्ने अवस्थाहरू (निश्चित घण्टा, निर्देशन प्राप्त गर्ने आदि) को आधारमा तपाईं कानूनी रूपमा अझै पनि एक कर्मचारी हुन सक्नुहुन्छ। यदि त्यसो हो भने, करहरू कसरी ह्यान्डल गरिन्छ भन्ने कुरालाई ध्यान नदिई, तपाईं साप्ताहिक सशुल्क बिदा भत्ता वा सेवा निवृत्ति भत्ता जस्ता अन्य अधिकारहरूबाट पनि वञ्चित भइरहेको हुन सक्नुहुन्छ।",
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
        AppLanguage.uz =>
          "Kompaniyaning aniq hajmi nomaʼlum boʻlganligi sababli, bu 5 nafardan kam xodim (ustama haqi yoʻq) deb ehtiyotkorlik bilan hisoblangan. Agar u aslida 5 yoki undan koʻp boʻlsa, sizga ushbu hisob-kitob koʻrsatganidan koʻproq pul toʻlanishi kerak.",
        AppLanguage.en =>
          'Since the exact company size is unknown, this was conservatively calculated as under 5 employees (no premium pay). If it actually has 5 or more, you are owed more than this calculation shows.',
        AppLanguage.tr =>
          "Şirketin tam büyüklüğü bilinmediği için, bu, muhafazakar bir yaklaşımla 5 çalışanın altında (prim ödemesi yok) olarak hesaplanmıştır. Eğer aslında 5 veya daha fazla çalışanı varsa, bu hesaplamanın gösterdiğinden daha fazlası size borçludur.",
        AppLanguage.tg =>
          "Азбаски андозаи пурраи ширкат маълум нест, ин бо равиши консервативӣ ҳамчун камтар аз 5 корманд (бе пардохти иловагӣ) ҳисоб карда шудааст. Агар дар асл 5 ё зиёда корманд дошта бошад, ба шумо бештар аз он чизе, ки ин ҳисоб нишон медиҳад, қарздор аст.",
        AppLanguage.fil =>
          "Dahil hindi alam ang eksaktong laki ng kumpanya, ito ay kinakalkula sa ilalim ng 5 na empleyado (walang premium pay) sa isang konserbatibong paraan. Kung sa katunayan ay mayroon itong 5 o higit pang empleyado, mas malaki ang utang sa iyo kaysa sa ipinapakita ng pagkalkulang ito.",
        AppLanguage.ur =>
          "چونکہ کمپنی کا مکمل سائز معلوم نہیں ہے، اس لیے اس کا حساب ایک محتاط انداز میں 5 ملازمین سے کم (کوئی پریمیم ادائیگی نہیں) کے طور پر کیا گیا ہے۔ اگر اصل میں 5 یا اس سے زیادہ ملازمین ہیں، تو یہ حساب جو دکھاتا ہے اس سے زیادہ آپ کو واجب الادا ہے۔",
        AppLanguage.th =>
          "เนื่องจากไม่ทราบขนาดบริษัทที่แน่นอน การคำนวณนี้จึงใช้แนวทางอนุรักษ์นิยมโดยถือว่ามีพนักงานน้อยกว่า 5 คน (ไม่มีการจ่ายค่าจ้างพิเศษ) หากบริษัทมีพนักงาน 5 คนขึ้นไป คุณจะได้รับเงินมากกว่าที่การคำนวณนี้แสดง",
        AppLanguage.ky =>
          "Компаниянын толук көлөмү белгисиз болгондуктан, бул консервативдүү ыкма менен 5 кызматкерден аз (премиум төлөмү жок) деп эсептелген. Эгерде чындыгында 5 же андан көп кызматкери болсо, анда бул эсептөө көрсөткөндөн да көп сумма сизге карыз.",
        AppLanguage.km =>
          "ដោយសារតែទំហំពេញលេញនៃក្រុមហ៊ុនមិនត្រូវបានគេដឹង នេះត្រូវបានគណនាដោយវិធីសាស្រ្តអភិរក្សថាមានបុគ្គលិកតិចជាង 5 នាក់ (គ្មានការបង់ប្រាក់បន្ថែម)។ ប្រសិនបើតាមពិតមានបុគ្គលិក 5 នាក់ ឬច្រើនជាងនេះ អ្នកជំពាក់ច្រើនជាងអ្វីដែលការគណនានេះបង្ហាញ។",
        AppLanguage.id =>
          "Karena ukuran perusahaan yang tepat tidak diketahui, ini dihitung dengan pendekatan konservatif sebagai di bawah 5 karyawan (tidak ada pembayaran premi). Jika sebenarnya ada 5 karyawan atau lebih, Anda berhak atas lebih dari yang ditunjukkan oleh perhitungan ini.",
        AppLanguage.si =>
          "සමාගමේ සම්පූර්ණ ප්‍රමාණය නොදන්නා බැවින්, මෙය ගතානුගතික ප්‍රවේශයක් ලෙස 5 සේවකයන්ට වඩා අඩු (වාරික ගෙවීම් නොමැතිව) ලෙස ගණනය කර ඇත. ඇත්ත වශයෙන්ම සේවකයන් 5ක් හෝ ඊට වැඩි සංඛ්‍යාවක් සිටී නම්, මෙම ගණනය කිරීමෙන් පෙන්වන ප්‍රමාණයට වඩා වැඩි මුදලක් ඔබට හිමි වේ.",
        AppLanguage.bn =>
          "কোম্পানির সঠিক আকার অজানা থাকায়, এটি একটি রক্ষণশীল পদ্ধতির সাথে 5 কর্মচারীর নিচে (কোন প্রিমিয়াম পরিশোধ নেই) হিসাবে গণনা করা হয়েছে। যদি আসলে 5 বা তার বেশি কর্মচারী থাকে, তবে এই গণনা যা দেখায় তার চেয়ে বেশি আপনার কাছে পাওনা।",
        AppLanguage.my =>
          "ကုမ္ပဏီ၏ အပြည့်အစုံအရွယ်အစားကို မသိရသောကြောင့် ၎င်းကို ဝန်ထမ်း 5 ဦးအောက် (ပရီမီယံလုပ်ခမရှိ) ဟု သတိထား၍ တွက်ချက်ထားပါသည်။ အကယ်၍ အမှန်တကယ် ဝန်ထမ်း 5 ဦး သို့မဟုတ် ထို့ထက်ပိုရှိပါက ဤတွက်ချက်မှုက ပြသသည်ထက် ပိုမိုများပြားသော ပမာဏကို သင့်အား ပေးရန်ရှိပါသည်။",
        AppLanguage.mn =>
          "Компанийн бүрэн хэмжээг мэдэх боломжгүй тул үүнийг 5 ажилтнаас бага (нэмэгдэл төлбөргүй) гэж консерватив аргаар тооцоолсон болно. Хэрэв үнэндээ 5 ба түүнээс дээш ажилтантай бол энэхүү тооцоололд зааснаас илүүг танд өртэй байна.",
        AppLanguage.lo =>
          "ເນື່ອງຈາກຂະໜາດເຕັມຂອງບໍລິສັດບໍ່ເປັນທີ່ຮູ້ຈັກ, ນີ້ແມ່ນຖືກຄິດໄລ່ໂດຍວິທີການແບບອະນຸລັກນິຍົມວ່າຕໍ່າກວ່າ 5 ຄົນ (ບໍ່ມີການຈ່າຍເງິນພິເສດ). ຖ້າຕົວຈິງແລ້ວມີພະນັກງານ 5 ຄົນ ຫຼື ຫຼາຍກວ່ານັ້ນ, ທ່ານຈະເປັນໜີ້ຫຼາຍກວ່າທີ່ການຄິດໄລ່ນີ້ສະແດງໃຫ້ເຫັນ.",
        AppLanguage.tet =>
          "Tanba tamañu empreza nian la hatene ho loloos, ida ne'e kalkula ho abordajen konservadora katak menus husi 5 funsionáriu (la iha pagamentu prémiu). Se iha realidade iha funsionáriu 5 ka liu, empreza deve ita liu fali buat ne'ebé kalkulasaun ne'e hatudu.",
        AppLanguage.ne =>
          "कम्पनीको पूर्ण आकार थाहा नभएकोले, यो रूढिवादी दृष्टिकोणका साथ 5 जना कर्मचारीभन्दा कम (प्रिमियम भुक्तानी छैन) को रूपमा गणना गरिएको छ। यदि वास्तवमा 5 वा सोभन्दा बढी कर्मचारी छन् भने, यो गणनाले देखाएको भन्दा बढी तपाईंलाई तिर्नुपर्नेछ।",
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
        AppLanguage.uz =>
          "Bir yil yoki undan koʻproq ishlash, haftasiga oʻrtacha 15+ soat ishlash <b>${formatWon(r.severance, lang)}</b> miqdorida ishdan boʻshatish nafaqasini toʻplaydi. (Xodimlar pensiya nafaqasi xavfsizligi toʻgʻrisidagi qonun 8-modda)",
        AppLanguage.en =>
          'Working a year or more, averaging 15+ hours a week, accrues severance pay of <b>${formatWon(r.severance, lang)}</b>. (Employee Retirement Benefit Security Act Art.8)',
        AppLanguage.tr =>
          "Bir yıl veya daha fazla çalışmak, haftada ortalama 15+ saat, <b>${formatWon(r.severance, lang)}</b> tutarında kıdem tazminatı biriktirir. (Kıdem Tazminatı Güvence Yasası Madde 8)",
        AppLanguage.tg =>
          "Кор кардан дар тӯли як сол ё бештар аз он, ба ҳисоби миёна 15+ соат дар як ҳафта, ҷуброни хизматро ба маблағи <b>${formatWon(r.severance, lang)}</b> ҷамъ мекунад. (Моддаи 8-и Қонун дар бораи кафолати ҷуброни хизмат)",
        AppLanguage.fil =>
          "Ang pagtatrabaho ng isang taon o higit pa, na may average na 15+ oras bawat linggo, ay nag-iipon ng severance pay na nagkakahalaga ng <b>${formatWon(r.severance, lang)}</b>. (Artikulo 8 ng Batas sa Garantiya ng Severance Pay)",
        AppLanguage.ur =>
          "ایک سال یا اس سے زیادہ کام کرنے سے، اوسطاً 15+ گھنٹے فی ہفتہ، <b>${formatWon(r.severance, lang)}</b> کی سینیورٹی پے جمع ہوتی ہے۔ (سینیورٹی پے گارنٹی ایکٹ آرٹیکل 8)",
        AppLanguage.th =>
          "การทำงานหนึ่งปีขึ้นไป โดยเฉลี่ย 15+ ชั่วโมงต่อสัปดาห์ จะสะสมเงินชดเชยการออกจากงานจำนวน <b>${formatWon(r.severance, lang)}</b> (มาตรา 8 แห่งพระราชบัญญัติการรับประกันเงินชดเชยการออกจากงาน)",
        AppLanguage.ky =>
          "Бир жыл же андан көп иштөө, жумасына орточо 15+ саат, <b>${formatWon(r.severance, lang)}</b> KRW суммасында иштен бошотуу жөлөкпулун топтойт. (Иштен бошотуу жөлөкпулун камсыздоо мыйзамынын 8-беренеси)",
        AppLanguage.km =>
          "ការធ្វើការមួយឆ្នាំ ឬច្រើនជាងនេះ ជាមួយនឹងមធ្យមភាគ 15+ ម៉ោងក្នុងមួយសប្តាហ៍ នឹងប្រមូលបានប្រាក់បំណាច់អតីតភាពការងារចំនួន <b>${formatWon(r.severance, lang)}</b>។ (មាត្រា 8 នៃច្បាប់ស្តីពីការធានាប្រាក់បំណាច់អតីតភាពការងារ)",
        AppLanguage.id =>
          "Bekerja selama satu tahun atau lebih, rata-rata 15+ jam per minggu, mengumpulkan pesangon sebesar <b>${formatWon(r.severance, lang)}</b>. (Undang-Undang Jaminan Pesangon Pasal 8)",
        AppLanguage.si =>
          "වසරක් හෝ ඊට වැඩි කාලයක් සේවය කිරීමෙන්, සතියකට සාමාන්‍යයෙන් පැය 15කට වඩා වැඩ කිරීමෙන්, ඔබට දළ වශයෙන් KRW <b>${formatWon(r.severance, lang)}</b>ක සේවා කාලය සඳහා වන්දි මුදලක් හිමි වේ. (සේවා කාලය සඳහා වන්දි සහතික කිරීමේ පනතේ 8 වගන්තිය)",
        AppLanguage.bn =>
          "এক বছর বা তার বেশি কাজ করা, প্রতি সপ্তাহে গড়ে 15+ ঘন্টা, <b>${formatWon(r.severance, lang)}</b> পরিমাণের সেভারেন্স পে জমা করে। (সেভারেন্স পে গ্যারান্টি অ্যাক্ট ধারা 8)",
        AppLanguage.my =>
          "တစ်နှစ် သို့မဟုတ် ထို့ထက်ပို၍ အလုပ်လုပ်ခြင်း၊ တစ်ပတ်လျှင် ပျမ်းမျှ 15+ နာရီ အလုပ်လုပ်ခြင်းသည် <b>${formatWon(r.severance, lang)}</b> ပမာဏရှိသော အလုပ်သက်တမ်းအလိုက် ဆုကြေးငွေကို စုဆောင်းပေးပါသည်။ (အလုပ်သက်တမ်းအလိုက် ဆုကြေးငွေ အာမခံဥပဒေ ပုဒ်မ 8)",
        AppLanguage.mn =>
          "Нэг ба түүнээс дээш жил ажиллах, долоо хоногт дунджаар 15+ цаг ажиллах нь <b>${formatWon(r.severance, lang)}</b> хэмжээний ажлаас халагдсаны тэтгэмж хуримтлуулдаг. (Ажлаас халагдсаны тэтгэмжийн баталгааны тухай хуулийн 8-р зүйл)",
        AppLanguage.lo =>
          "ການເຮັດວຽກໜຶ່ງປີ ຫຼື ຫຼາຍກວ່ານັ້ນ, ສະເລ່ຍ 15+ ຊົ່ວໂມງຕໍ່ອາທິດ, ຈະສະສົມເງິນອຸດໜູນການອອກຈາກວຽກຈຳນວນ <b>${formatWon(r.severance, lang)}</b>. (ມາດຕາ 8 ຂອງກົດໝາຍວ່າດ້ວຍການຄໍ້າປະກັນເງິນອຸດໜູນການອອກຈາກວຽກ)",
        AppLanguage.tet =>
          "Serbisu tinan ida ka liu, média 15+ oras kada semana, sei akumula indemnizasaun serbisu ho montante <b>${formatWon(r.severance, lang)}</b>. (Lei Garantia Indemnizasaun Serbisu Artigu 8)",
        AppLanguage.ne =>
          "एक वर्ष वा सोभन्दा बढी काम गर्दा, प्रति हप्ता औसत 15+ घण्टा, <b>${formatWon(r.severance, lang)}</b> रकमको सेवा निवृत्ति भत्ता जम्मा हुन्छ। (सेवा निवृत्ति भत्ता सुरक्षा ऐन धारा 8)",
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
      AppLanguage.uz =>
        "Hozirgacha kiritgan maʼlumotlaringizga asoslanib, sizga kamida <b>${formatWon(gapVal.abs(), lang)}</b> koʻproq pul toʻlanishi kerak. Iltimos, quyidagi bandlarni tekshiring.",
      AppLanguage.en =>
        'Based on what you have entered so far, it is likely that you are owed at least about <b>${formatWon(gapVal.abs(), lang)}</b> more. '
            'Please check the items below.',
      AppLanguage.tr =>
        "Şimdiye kadar girdiğiniz bilgilere göre, size en az yaklaşık <b>${formatWon(gapVal.abs(), lang)}</b> daha fazla borçlu olunması muhtemeldir. Lütfen aşağıdaki maddeleri kontrol edin.",
      AppLanguage.tg =>
        "Мувофиқи маълумоти то ҳол воридкардаи шумо, эҳтимол дорад, ки ба шумо на камтар аз тақрибан <b>${formatWon(gapVal.abs(), lang)}</b> бештар қарздор бошанд. Лутфан ба бандҳои зерин назар андозед.",
      AppLanguage.fil =>
        "Batay sa impormasyong iyong inilagay sa ngayon, malamang na may utang sa iyo ng hindi bababa sa humigit-kumulang <b>${formatWon(gapVal.abs(), lang)}</b> pa. Mangyaring suriin ang mga sumusunod na item.",
      AppLanguage.ur =>
        "اب تک آپ کی فراہم کردہ معلومات کے مطابق، آپ کو کم از کم تقریباً <b>${formatWon(gapVal.abs(), lang)}</b> مزید واجب الادا ہونے کا امکان ہے۔ براہ کرم درج ذیل اشیاء کو چیک کریں۔",
      AppLanguage.th =>
        "จากข้อมูลที่คุณป้อนจนถึงตอนนี้ มีแนวโน้มว่าคุณจะได้รับเงินเพิ่มอีกอย่างน้อยประมาณ <b>${formatWon(gapVal.abs(), lang)}</b> โปรดตรวจสอบรายการด้านล่าง",
      AppLanguage.ky =>
        "Буга чейин киргизген маалыматтарыңызга ылайык, сизге кеминде болжол менен <b>${formatWon(gapVal.abs(), lang)}</b> KRW көбүрөөк карыз болушу мүмкүн. Сураныч, төмөнкү пункттарды текшериңиз.",
      AppLanguage.km =>
        "ផ្អែកលើព័ត៌មានដែលអ្នកបានបញ្ចូលរហូតមកដល់ពេលនេះ វាទំនងជាថាអ្នកជំពាក់យ៉ាងហោចណាស់ប្រហែល <b>${formatWon(gapVal.abs(), lang)}</b> បន្ថែមទៀត។ សូមពិនិត្យមើលចំណុចខាងក្រោម។",
      AppLanguage.id =>
        "Berdasarkan informasi yang telah Anda masukkan sejauh ini, kemungkinan besar Anda berhak atas setidaknya sekitar <b>${formatWon(gapVal.abs(), lang)}</b> lebih banyak. Silakan periksa poin-poin di bawah ini.",
      AppLanguage.si =>
        "ඔබ මේ වන විට ඇතුළත් කර ඇති තොරතුරු අනුව, ඔබට අවම වශයෙන් KRW <b>${formatWon(gapVal.abs(), lang)}</b>ක් පමණ වැඩිපුර ලැබිය යුතු විය හැකිය. කරුණාකර පහත කරුණු පරීක්ෂා කරන්න.",
      AppLanguage.bn =>
        "এখন পর্যন্ত আপনার প্রবেশ করা তথ্যের উপর ভিত্তি করে, আপনার কাছে সম্ভবত কমপক্ষে প্রায় <b>${formatWon(gapVal.abs(), lang)}</b> বেশি পাওনা রয়েছে। অনুগ্রহ করে নিচের আইটেমগুলি পরীক্ষা করুন।",
      AppLanguage.my =>
        "ယခုအချိန်အထိ သင်ထည့်သွင်းထားသော အချက်အလက်များအရ သင့်အား အနည်းဆုံး ခန့်မှန်းခြေအားဖြင့် <b>${formatWon(gapVal.abs(), lang)}</b> ပိုမိုပေးရန်ရှိနိုင်ပါသည်။ ကျေးဇူးပြု၍ အောက်ပါအချက်များကို စစ်ဆေးပါ။",
      AppLanguage.mn =>
        "Одоог хүртэл оруулсан мэдээллээр танд дор хаяж ойролцоогоор <b>${formatWon(gapVal.abs(), lang)}</b> илүү өртэй байх магадлалтай. Доорх зүйлсийг шалгана уу.",
      AppLanguage.lo =>
        "ອີງຕາມຂໍ້ມູນທີ່ທ່ານໄດ້ປ້ອນເຂົ້າຈົນເຖິງປະຈຸບັນ, ມັນເປັນໄປໄດ້ວ່າທ່ານເປັນໜີ້ຢ່າງໜ້ອຍປະມານ <b>${formatWon(gapVal.abs(), lang)}</b> ຕື່ມອີກ. ກະລຸນາກວດສອບລາຍການຕໍ່ໄປນີ້.",
      AppLanguage.tet =>
        "Tuir informasaun ne'ebé ita hatama to'o agora, empreza provavel deve ita liu tan mínimu aproximadamente <b>${formatWon(gapVal.abs(), lang)}</b>. Favor verifika pontu sira tuir mai.",
      AppLanguage.ne =>
        "अहिलेसम्म तपाईंले प्रविष्ट गर्नुभएको जानकारी अनुसार, तपाईंलाई कम्तिमा लगभग <b>${formatWon(gapVal.abs(), lang)}</b> बढी तिर्नुपर्ने सम्भावना छ। कृपया तलका बुँदाहरू जाँच गर्नुहोस्।",
      AppLanguage.zh =>
        '根据您目前输入的内容来看，您很可能至少应多获得约<b>${formatWon(gapVal.abs(), lang)}</b>。'
            '请核对以下各项。',
      AppLanguage.vi =>
        'Dựa trên nội dung bạn đã nhập, nhiều khả năng bạn cần được nhận thêm ít nhất khoảng <b>${formatWon(gapVal.abs(), lang)}</b>. '
            'Hãy kiểm tra các mục dưới đây.',
    };
    final noSpecificCause = switch (lang) {
      AppLanguage.ko => '구체적인 원인은 특정하기 어렵지만, 임금명세서 항목을 하나씩 대조해 보시길 권해요.',
      AppLanguage.uz =>
        "Aniq sababni aniqlash qiyin, ammo biz ish haqi varagʻingizdagi bandlarni birma-bir tekshirishni tavsiya qilamiz.",
      AppLanguage.en =>
        'It is hard to pinpoint the specific cause, but we recommend checking your payslip items one by one.',
      AppLanguage.tr =>
        "Belirli nedeni tam olarak belirlemek zor, ancak maaş bordronuzdaki kalemleri tek tek kontrol etmenizi öneririz.",
      AppLanguage.tg =>
        "Муайян кардани сабаби дақиқ душвор аст, аммо мо тавсия медиҳем, ки шумо бандҳои варақаи музди меҳнати худро як ба як тафтиш кунед.",
      AppLanguage.fil =>
        "Mahirap matukoy ang eksaktong dahilan, ngunit inirerekomenda namin na suriin mo ang mga item sa iyong payslip nang paisa-isa.",
      AppLanguage.ur =>
        "مخصوص وجہ کا مکمل تعین کرنا مشکل ہے، لیکن ہم تجویز کرتے ہیں کہ آپ اپنی پے سلپ پر موجود اشیاء کو ایک ایک کرکے چیک کریں۔",
      AppLanguage.th =>
        "เป็นการยากที่จะระบุสาเหตุที่เฉพาะเจาะจงได้อย่างแม่นยำ แต่เราขอแนะนำให้คุณตรวจสอบรายการในสลิปเงินเดือนของคุณทีละรายการ",
      AppLanguage.ky =>
        "Белгилүү себебин так аныктоо кыйын, бирок эмгек акы баракчаңыздагы пункттарды бир-бирден текшерүүнү сунуштайбыз.",
      AppLanguage.km =>
        "វាពិបាកក្នុងការកំណត់មូលហេតុជាក់លាក់ទាំងស្រុង ប៉ុន្តែយើងណែនាំឱ្យអ្នកពិនិត្យមើលធាតុនីមួយៗនៅលើប័ណ្ណបើកប្រាក់បៀវត្សរ៍របស់អ្នក។",
      AppLanguage.id =>
        "Sulit untuk menentukan penyebab pastinya, tetapi kami menyarankan Anda untuk memeriksa item-item pada slip gaji Anda satu per satu.",
      AppLanguage.si =>
        "නිශ්චිත හේතුව හරියටම තීරණය කිරීම අපහසුයි, නමුත් ඔබේ වැටුප් පත්‍රිකාවේ ඇති අයිතම එකින් එක පරීක්ෂා කිරීමට අපි යෝජනා කරමු.",
      AppLanguage.bn =>
        "নির্দিষ্ট কারণটি সঠিকভাবে নির্ধারণ করা কঠিন, তবে আমরা আপনাকে আপনার বেতন স্লিপের আইটেমগুলি একে একে পরীক্ষা করার পরামর্শ দিই।",
      AppLanguage.my =>
        "တိကျသော အကြောင်းရင်းကို အတိအကျဆုံးဖြတ်ရန် ခက်ခဲသော်လည်း သင်၏ လစာစာရင်းရှိ အချက်အလက်များကို တစ်ခုချင်းစီ စစ်ဆေးရန် အကြံပြုအပ်ပါသည်။",
      AppLanguage.mn =>
        "Тодорхой шалтгааныг яг таг тогтооход хэцүү ч таны цалингийн хуудасны зүйлсийг нэг нэгээр нь шалгахыг зөвлөж байна.",
      AppLanguage.lo =>
        "ມັນຍາກທີ່ຈະກຳນົດສາເຫດສະເພາະເຈາະຈົງໄດ້ຢ່າງຄົບຖ້ວນ, ແຕ່ພວກເຮົາແນະນຳໃຫ້ທ່ານກວດສອບລາຍການຕ່າງໆໃນໃບແຈ້ງເງິນເດືອນຂອງທ່ານເທື່ອລະອັນ.",
      AppLanguage.tet =>
        "Difísil atu determina razaun espesífika ho loloos, maibé ami sujere atu ita verifika item sira iha ita-nia folla saláriu ida-ida.",
      AppLanguage.ne =>
        "निश्चित कारण ठ्याक्कै पत्ता लगाउन गाह्रो छ, तर हामी तपाईंलाई आफ्नो तलब पर्चीमा भएका वस्तुहरू एक-एक गरी जाँच गर्न सिफारिस गर्छौं।",
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
      AppLanguage.uz =>
        "Ushbu tashxis sizning kiritgan maʼlumotlaringizga asoslangan taxminiy hisob-kitobdir. Tasdiqlangan toʻlanmagan miqdor mehnat inspektorining tekshiruvi bilan aniqlanadi, shuning uchun avval ish haqi varagʻingizni soʻrang va uni bandma-band solishtiring — agar bu ham tushuntira olmasa, Mehnat va bandlik vazirligiga murojaat qiling.",
      AppLanguage.en =>
        'This diagnosis is a reference estimate based on your input. The confirmed unpaid amount is determined by a labor inspector\'s investigation, so first request your payslip and compare it item by item — if that still does not explain it, consult the Ministry of Employment and Labor.',
      AppLanguage.tr =>
        "Bu teşhis, girdilerinize dayalı bir referans tahmindir. Onaylanmış ödenmemiş miktar, bir iş müfettişinin soruşturmasıyla belirlenir, bu nedenle öncelikle maaş bordronuzu isteyin ve kalem kalem karşılaştırın — eğer bu hala açıklamazsa, Çalışma ve Sosyal Güvenlik Bakanlığı'na danışın.",
      AppLanguage.tg =>
        "Ин ташхис як тахмини истинодӣ дар асоси маълумоти воридкардаи шумост. Маблағи тасдиқшудаи пардохтнашуда тавассути тафтишоти нозири меҳнат муайян карда мешавад, аз ин рӯ, аввал варақаи музди меҳнати худро талаб кунед ва банд ба банд муқоиса кунед — агар ин ҳам шарҳ надиҳад, ба Вазорати меҳнат ва шуғли аҳолӣ муроҷиат кунед.",
      AppLanguage.fil =>
        "Ang diagnosis na ito ay isang reference estimate batay sa iyong mga input. Ang kumpirmadong halaga ng hindi nabayaran ay tinutukoy sa pamamagitan ng imbestigasyon ng isang inspektor ng paggawa, kaya una, humingi ng iyong payslip at ihambing ang bawat item — kung hindi pa rin ito nagpapaliwanag, kumonsulta sa Ministry of Employment and Labor.",
      AppLanguage.ur =>
        "یہ تشخیص آپ کے ان پٹ پر مبنی ایک حوالہ تخمینہ ہے۔ تصدیق شدہ غیر ادا شدہ رقم کا تعین ایک لیبر انسپکٹر کی تحقیقات سے ہوتا ہے، لہذا پہلے اپنی پے سلپ کی درخواست کریں اور اشیاء کا موازنہ کریں — اگر یہ اب بھی وضاحت نہیں کرتا ہے، تو وزارت محنت اور روزگار سے مشورہ کریں۔",
      AppLanguage.th =>
        "การวินิจฉัยนี้เป็นการประมาณการอ้างอิงตามข้อมูลที่คุณป้อน จำนวนเงินที่ยังไม่ได้รับที่ได้รับการยืนยันจะถูกกำหนดโดยการสอบสวนของเจ้าหน้าที่ตรวจสอบแรงงาน ดังนั้น โปรดขอสลิปเงินเดือนของคุณก่อนและเปรียบเทียบทีละรายการ — หากยังไม่สามารถอธิบายได้ ให้ปรึกษากระทรวงแรงงานและการจ้างงาน",
      AppLanguage.ky =>
        "Бул диагноз сиздин киргизүүлөрүңүзгө негизделген болжолдуу маалымат. Тастыкталган төлөнбөгөн сумма эмгек инспекторунун иликтөөсү менен аныкталат, ошондуктан алгач эмгек акы баракчаңызды сурап, пункттарды салыштырыңыз — эгер бул дагы эле түшүндүрбөсө, Эмгек жана социалдык камсыздоо министрлигине кайрылыңыз.",
      AppLanguage.km =>
        "ការវិនិច្ឆ័យនេះគឺជាការប៉ាន់ស្មានយោងផ្អែកលើការបញ្ចូលរបស់អ្នក។ ចំនួនទឹកប្រាក់ដែលមិនទាន់បានបង់ដែលបានបញ្ជាក់ត្រូវបានកំណត់ដោយការស៊ើបអង្កេតរបស់អធិការការងារ ដូច្នេះដំបូងសូមស្នើសុំប័ណ្ណបើកប្រាក់បៀវត្សរ៍របស់អ្នក ហើយប្រៀបធៀបធាតុនីមួយៗ — ប្រសិនបើវានៅតែមិនអាចពន្យល់បាន សូមពិគ្រោះជាមួយក្រសួងការងារ និងសុខុមាលភាព។",
      AppLanguage.id =>
        "Diagnosis ini adalah perkiraan referensi berdasarkan masukan Anda. Jumlah yang belum dibayar yang dikonfirmasi ditentukan melalui penyelidikan oleh inspektur ketenagakerjaan, jadi pertama-tama mintalah slip gaji Anda dan bandingkan item per item — jika ini masih belum menjelaskan, konsultasikan dengan Kementerian Ketenagakerjaan dan Tenaga Kerja.",
      AppLanguage.si =>
        "මෙම රෝග විනිශ්චය ඔබ ඇතුළත් කළ දත්ත මත පදනම් වූ යොමු ඇස්තමේන්තුවකි. තහවුරු කරන ලද නොගෙවූ මුදල කම්කරු පරීක්ෂකවරයෙකුගේ පරීක්ෂණයකින් තීරණය කරනු ලැබේ, එබැවින් පළමුව ඔබේ වැටුප් පත්‍රිකාව ඉල්ලා අයිතමයෙන් අයිතමය සසඳන්න — එය තවමත් පැහැදිලි නොකරන්නේ නම්, කම්කරු හා රැකියා අමාත්‍යාංශය අමතන්න.",
      AppLanguage.bn =>
        "এই নির্ণয়টি আপনার ইনপুটগুলির উপর ভিত্তি করে একটি রেফারেন্স অনুমান। নিশ্চিত অপরিশোধিত পরিমাণ একজন শ্রম পরিদর্শকের তদন্তের মাধ্যমে নির্ধারিত হয়, তাই প্রথমে আপনার বেতন স্লিপের জন্য জিজ্ঞাসা করুন এবং আইটেম অনুসারে তুলনা করুন — যদি এটি এখনও ব্যাখ্যা না করে, তবে শ্রম ও কর্মসংস্থান মন্ত্রণালয়ের সাথে পরামর্শ করুন।",
      AppLanguage.my =>
        "ဤရောဂါရှာဖွေမှုသည် သင်၏ ထည့်သွင်းမှုများအပေါ် အခြေခံ၍ ရည်ညွှန်းခန့်မှန်းချက်တစ်ခုဖြစ်သည်။ အတည်ပြုထားသော မပေးချေရသေးသော ပမာဏကို အလုပ်သမားစစ်ဆေးရေးမှူး၏ စုံစမ်းစစ်ဆေးမှုဖြင့် ဆုံးဖြတ်မည်ဖြစ်သောကြောင့် ဦးစွာ သင်၏ လစာစာရင်းကို တောင်းခံပြီး အချက်အလက်များကို တစ်ခုချင်းစီ နှိုင်းယှဉ်ပါ — ၎င်းသည် ရှင်းပြနိုင်ခြင်းမရှိသေးပါက အလုပ်သမားနှင့် လူမှုဖူလုံရေးဝန်ကြီးဌာနသို့ ဆက်သွယ်ပါ။",
      AppLanguage.mn =>
        "Энэхүү оношлогоо нь таны оруулсан мэдээлэлд үндэслэсэн лавлагааны тооцоолол юм. Баталгаажсан төлөгдөөгүй дүнг хөдөлмөрийн байцаагчийн шалгалтаар тогтоодог тул эхлээд цалингийн хуудсаа хүсэж, зүйл зүйлээр нь харьцуулна уу — хэрэв энэ нь одоо ч тайлбарлахгүй бол Хөдөлмөр, нийгмийн хамгааллын яаманд хандана уу.",
      AppLanguage.lo =>
        "ການວິນິດໄສນີ້ແມ່ນການຄາດຄະເນອ້າງອີງໂດຍອີງໃສ່ຂໍ້ມູນທີ່ທ່ານປ້ອນເຂົ້າ. ຈຳນວນເງິນທີ່ບໍ່ໄດ້ຈ່າຍທີ່ໄດ້ຮັບການຢືນຢັນແມ່ນຖືກກຳນົດໂດຍການສືບສວນຂອງເຈົ້າໜ້າທີ່ກວດກາແຮງງານ, ດັ່ງນັ້ນ, ກ່ອນອື່ນໝົດໃຫ້ຂໍໃບແຈ້ງເງິນເດືອນຂອງທ່ານ ແລະ ປຽບທຽບລາຍການຕໍ່ລາຍການ — ຖ້າສິ່ງນີ້ຍັງບໍ່ສາມາດອະທິບາຍໄດ້, ໃຫ້ປຶກສາຫາລືກັບກະຊວງແຮງງານ ແລະ ສະຫວັດດີການສັງຄົມ.",
      AppLanguage.tet =>
        "Diagnóstiku ne'e estimativa referénsia ida bazeia ba ita-nia input. Montante la selu ne'ebé konfirmadu sei determina husi investigasaun inspetór traballu nian, tanba ne'e, primeiru husu ita-nia folla saláriu no kompara item por item — se ida ne'e seidauk esplika, konsulta Ministériu Traballu no Seguransa Sosiál.",
      AppLanguage.ne =>
        "यो निदान, तपाईंको प्रविष्टिहरूमा आधारित एक सन्दर्भ अनुमान हो। पुष्टि गरिएको भुक्तानी नभएको रकम, एक श्रम निरीक्षकको अनुसन्धानबाट निर्धारण गरिन्छ, त्यसैले पहिले आफ्नो तलब पर्ची माग्नुहोस् र वस्तु-वस्तु तुलना गर्नुहोस् — यदि यसले अझै स्पष्ट पार्दैन भने, श्रम तथा रोजगार मन्त्रालयसँग परामर्श गर्नुहोस्।",
      AppLanguage.zh =>
        '此诊断仅为根据输入值得出的参考性估算。确定的欠薪金额需经劳动监察官调查后才能确定，请先索取工资单逐项对照，若仍无法解释，请咨询劳动部。',
      AppLanguage.vi =>
        'Chẩn đoán này chỉ là ước tính tham khảo dựa trên dữ liệu bạn nhập. Số tiền nợ lương chính thức sẽ do thanh tra lao động điều tra xác định, vì vậy hãy yêu cầu phiếu lương để đối chiếu từng mục trước, nếu vẫn không giải thích được hãy liên hệ Bộ Việc làm và Lao động.',
    };
    return '$head\n\n$body\n\n$foot\n\n${_gapMethodologyNote(lang)}';
  } else {
    parts.add(switch (lang) {
      AppLanguage.ko => '포괄임금제 계약이라면 연장·야간수당이 월급에 미리 합산되어 있을 수 있어요.',
      AppLanguage.uz =>
        "Agar shartnomangizda kompleks (barcha xarajatlarni qamrab oluvchi) ish haqi tizimi qoʻllanilgan boʻlsa, qoʻshimcha ish va tungi ish haqi allaqachon oylik maoshingizga kiritilgan boʻlishi mumkin.",
      AppLanguage.en =>
        'If your contract uses a comprehensive (all-inclusive) wage system, overtime and night-work pay may already be built into your monthly salary.',
      AppLanguage.tr =>
        "Sözleşmeniz kapsamlı (her şey dahil) bir ücret sistemi kullanıyorsa, fazla mesai ve gece çalışması ücreti aylık maaşınıza zaten dahil edilmiş olabilir.",
      AppLanguage.tg =>
        "Агар шартномаи шумо системаи музди меҳнати ҳамаҷонибаро (ҳама чиз дохил) истифода барад, музди кори изофа ва кори шабона метавонад аллакай ба музди меҳнати моҳонаи шумо дохил карда шуда бошад.",
      AppLanguage.fil =>
        "Kung ang iyong kontrata ay gumagamit ng isang komprehensibong (all-inclusive) sistema ng sahod, ang overtime at night work pay ay maaaring kasama na sa iyong buwanang sahod.",
      AppLanguage.ur =>
        "اگر آپ کا معاہدہ ایک جامع (سب کچھ شامل) اجرت کا نظام استعمال کرتا ہے، تو اوور ٹائم اور رات کے کام کی اجرت آپ کی ماہانہ تنخواہ میں پہلے ہی شامل ہو سکتی ہے۔",
      AppLanguage.th =>
        "หากสัญญาของคุณใช้ระบบค่าจ้างแบบครอบคลุม (รวมทุกอย่าง) ค่าจ้างล่วงเวลาและค่าจ้างกะกลางคืนอาจรวมอยู่ในเงินเดือนรายเดือนของคุณแล้ว",
      AppLanguage.ky =>
        "Эгерде сиздин келишимиңиз комплекстүү (баарын камтыган) эмгек акы системасын колдонсо, ашыкча иштеген убакыт жана түнкү жумуш үчүн эмгек акы айлык маянаңызга мурунтан эле киргизилген болушу мүмкүн.",
      AppLanguage.km =>
        "ប្រសិនបើកិច្ចសន្យារបស់អ្នកប្រើប្រព័ន្ធប្រាក់ឈ្នួលរួម (all-inclusive) ប្រាក់ឈ្នួលសម្រាប់ការធ្វើការថែមម៉ោង និងការធ្វើការពេលយប់អាចត្រូវបានរាប់បញ្ចូលរួចហើយនៅក្នុងប្រាក់បៀវត្សរ៍ប្រចាំខែរបស់អ្នក។",
      AppLanguage.id =>
        "Jika kontrak Anda menggunakan sistem upah komprehensif (all-inclusive), upah lembur dan kerja malam mungkin sudah termasuk dalam gaji bulanan Anda.",
      AppLanguage.si =>
        "ඔබේ කොන්ත්‍රාත්තුව පුළුල් (සියල්ල ඇතුළත්) වැටුප් ක්‍රමයක් භාවිතා කරන්නේ නම්, අතිකාල සහ රාත්‍රී වැඩ සඳහා වන වැටුප් දැනටමත් ඔබේ මාසික වැටුපට ඇතුළත් කර තිබිය හැක.",
      AppLanguage.bn =>
        "যদি আপনার চুক্তি একটি ব্যাপক (সর্ব-অন্তর্ভুক্ত) বেতন ব্যবস্থা ব্যবহার করে, তবে ওভারটাইম এবং রাতের কাজের বেতন আপনার মাসিক বেতনে ইতিমধ্যেই অন্তর্ভুক্ত থাকতে পারে।",
      AppLanguage.my =>
        "သင်၏ စာချုပ်သည် ပြည့်စုံသော (အားလုံးပါဝင်သော) လုပ်ခစနစ်ကို အသုံးပြုပါက အချိန်ပိုနှင့် ညဆိုင်းလုပ်ခကို သင်၏ လစဉ်လစာတွင် ထည့်သွင်းပြီးသား ဖြစ်နိုင်ပါသည်။",
      AppLanguage.mn =>
        "Хэрэв таны гэрээнд цогц (бүх зүйлийг багтаасан) цалингийн систем ашигласан бол илүү цаг болон шөнийн ажлын цалин таны сарын цалинд аль хэдийн багтсан байж болно.",
      AppLanguage.lo =>
        "ຖ້າສັນຍາຂອງທ່ານໃຊ້ລະບົບຄ່າຈ້າງແບບຄົບວົງຈອນ (ລວມທຸກຢ່າງ), ຄ່າຈ້າງລ່ວງເວລາ ແລະ ຄ່າຈ້າງເຮັດວຽກກາງຄືນອາດຈະຖືກລວມເຂົ້າໃນເງິນເດືອນປະຈຳເດືອນຂອງທ່ານແລ້ວ.",
      AppLanguage.tet =>
        "Se ita-nia kontratu uza sistema saláriu kompreensivu (inklui hotu-hotu), saláriu oras extra no serbisu kalan bele inklui ona iha ita-nia saláriu fulan-fulan.",
      AppLanguage.ne =>
        "यदि तपाईंको सम्झौताले व्यापक (सबै समावेशी) तलब प्रणाली प्रयोग गर्छ भने, ओभरटाइम र रात्रिकालीन कामको तलब तपाईंको मासिक तलबमा पहिले नै समावेश गरिएको हुन सक्छ।",
      AppLanguage.zh => '如果是包干工资制合同，加班费和夜班津贴可能已经预先包含在月薪中。',
      AppLanguage.vi =>
        'Nếu hợp đồng theo hình thức lương trọn gói, phụ cấp làm thêm và làm đêm có thể đã được gộp sẵn vào lương tháng.',
    });
    parts.add(switch (lang) {
      AppLanguage.ko => '상여금, 식대, 교통비처럼 이 계산기가 반영하지 않는 항목이 함께 지급되었을 수 있어요.',
      AppLanguage.uz =>
        "Ushbu kalkulyator hisobga olmaydigan bandlar — masalan, bonuslar, ovqatlanish nafaqasi yoki transport nafaqasi — birga toʻlangan boʻlishi mumkin.",
      AppLanguage.en =>
        'Items this calculator does not account for — such as bonuses, meal allowance, or transportation allowance — may have been paid together.',
      AppLanguage.tr =>
        "Bu hesaplayıcının dikkate almadığı kalemler — örneğin ikramiyeler, yemek ödeneği veya ulaşım ödeneği — birlikte ödenmiş olabilir.",
      AppLanguage.tg =>
        "Банде, ки ин ҳисобкунак ба назар нагирифтааст — масалан, мукофотпулӣ, кӯмакпулӣ барои хӯрок ё кӯмакпулӣ барои нақлиёт — метавонад якҷоя пардохт шуда бошад.",
      AppLanguage.fil =>
        "Ang mga item na hindi isinasaalang-alang ng calculator na ito — halimbawa, mga bonus, allowance sa pagkain, o allowance sa transportasyon — ay maaaring nabayaran nang magkasama.",
      AppLanguage.ur =>
        "وہ اشیاء جنہیں یہ کیلکولیٹر مدنظر نہیں رکھتا — مثال کے طور پر بونس، کھانے کا الاؤنس یا ٹرانسپورٹ الاؤنس — ایک ساتھ ادا کی گئی ہو سکتی ہیں۔",
      AppLanguage.th =>
        "รายการที่เครื่องคำนวณนี้ไม่ได้พิจารณา — เช่น โบนัส ค่าอาหาร หรือค่าเดินทาง — อาจถูกจ่ายรวมกัน",
      AppLanguage.ky =>
        "Бул эсептегич эске албаган пункттар — мисалы, бонустар, тамак-аш жөлөкпулу же транспорттук жөлөкпул — чогуу төлөнгөн болушу мүмкүн.",
      AppLanguage.km =>
        "ធាតុដែលម៉ាស៊ីនគិតលេខនេះមិនបានគិតគូរ — ឧទាហរណ៍ ប្រាក់រង្វាន់ ប្រាក់ឧបត្ថម្ភអាហារ ឬប្រាក់ឧបត្ថម្ភធ្វើដំណើរ — អាចត្រូវបានបង់រួមគ្នា។",
      AppLanguage.id =>
        "Item-item yang tidak diperhitungkan oleh kalkulator ini — misalnya, bonus, tunjangan makan, atau tunjangan transportasi — mungkin telah dibayarkan bersama.",
      AppLanguage.si =>
        "මෙම ගණක යන්ත්‍රය සැලකිල්ලට නොගන්නා අයිතම — උදාහරණයක් ලෙස, බෝනස්, ආහාර දීමනා හෝ ප්‍රවාහන දීමනා — එකට ගෙවා තිබිය හැක.",
      AppLanguage.bn =>
        "এই ক্যালকুলেটরটি যে আইটেমগুলি বিবেচনা করে না — উদাহরণস্বরূপ বোনাস, খাবারের ভাতা বা পরিবহন ভাতা — সেগুলি একসাথে পরিশোধ করা হতে পারে।",
      AppLanguage.my =>
        "ဤဂဏန်းတွက်စက်က ထည့်သွင်းစဉ်းစားခြင်းမရှိသော အချက်အလက်များ — ဥပမာ- ဘောနပ်စ်များ၊ အစားအသောက်စရိတ် သို့မဟုတ် သယ်ယူပို့ဆောင်ရေးစရိတ် — ကို အတူတကွ ပေးချေပြီးသား ဖြစ်နိုင်ပါသည်။",
      AppLanguage.mn =>
        "Энэхүү тооцоолуурын харгалзан үзээгүй зүйлс — жишээлбэл, урамшуулал, хоолны тэтгэмж эсвэл тээврийн тэтгэмж — хамтдаа төлөгдсөн байж болно.",
      AppLanguage.lo =>
        "ລາຍການທີ່ເຄື່ອງຄິດໄລ່ນີ້ບໍ່ໄດ້ພິຈາລະນາ — ຕົວຢ່າງ: ເງິນໂບນັດ, ເງິນອຸດໜູນອາຫານ ຫຼື ເງິນອຸດໜູນຄ່າເດີນທາງ — ອາດຈະຖືກຈ່າຍຮ່ວມກັນ.",
      AppLanguage.tet =>
        "Item sira ne'ebé kalkuladora ne'e la konsidera — ezemplu, bónus, subsídiu ai-han ka subsídiu transporte — bele selu hamutuk ona.",
      AppLanguage.ne =>
        "यो क्यालकुलेटरले ध्यान नदिएका वस्तुहरू — उदाहरणका लागि बोनस, खाना भत्ता वा यातायात भत्ता — सँगै भुक्तानी गरिएको हुन सक्छ।",
      AppLanguage.zh => '奖金、伙食费、交通补贴等本计算器未纳入的项目，可能也一并发放了。',
      AppLanguage.vi =>
        'Các khoản mà máy tính này chưa tính đến — như tiền thưởng, tiền ăn, tiền đi lại — có thể đã được trả kèm theo.',
    });
    if (c.tax == TaxMethod.none) {
      parts.add(switch (lang) {
        AppLanguage.ko =>
          '세금이 공제되지 않는다고 선택하셨는데, 실제로는 일부 공제되고 있다면 반대로 계산이 달라질 수 있어요.',
        AppLanguage.uz =>
          "Siz soliq chegirilmaydi deb tanladingiz — agar aslida qandaydir soliq ushlab qolinayotgan boʻlsa, hisob-kitob boshqa tomonga oʻzgarishi mumkin.",
        AppLanguage.en =>
          'You selected that no tax is deducted — if some tax is actually being withheld, the calculation could change the other way.',
        AppLanguage.tr =>
          "Vergi kesintisi yapılmadığını seçtiniz — eğer aslında bir miktar vergi kesiliyorsa, hesaplama farklı yönde değişebilir.",
        AppLanguage.tg =>
          "Шумо интихоб кардед, ки тарҳи андоз анҷом дода нашудааст — агар дар асл миқдори муайяни андоз тарҳ карда шавад, ҳисоб метавонад ба самти дигар тағйир ёбад.",
        AppLanguage.fil =>
          "Pinili mo na walang bawas sa buwis — kung sa katunayan ay mayroong ilang bawas sa buwis, maaaring magbago ang pagkalkula sa ibang direksyon.",
        AppLanguage.ur =>
          "آپ نے ٹیکس کٹوتی نہ ہونے کا انتخاب کیا ہے — اگر اصل میں کچھ ٹیکس کاٹا جا رہا ہے، تو حساب مختلف سمت میں بدل سکتا ہے۔",
        AppLanguage.th =>
          "คุณเลือกที่จะไม่หักภาษี — หากมีการหักภาษีจริง การคำนวณอาจเปลี่ยนแปลงไปในทิศทางที่แตกต่างกัน",
        AppLanguage.ky =>
          "Сиз салык кармалбайт деп тандадыңыз — эгерде чындыгында бир аз салык кармалса, эсептөө башка багытта өзгөрүшү мүмкүн.",
        AppLanguage.km =>
          "អ្នកបានជ្រើសរើសថាគ្មានការកាត់ពន្ធ — ប្រសិនបើតាមពិតមានការកាត់ពន្ធមួយចំនួន ការគណនាអាចផ្លាស់ប្តូរក្នុងទិសដៅផ្សេង។",
        AppLanguage.id =>
          "Anda memilih bahwa tidak ada pemotongan pajak — jika sebenarnya ada pemotongan pajak, perhitungannya mungkin berubah ke arah yang berbeda.",
        AppLanguage.si =>
          "ඔබ බදු අඩු කිරීමක් සිදු නොකළ බව තෝරාගෙන ඇත — ඇත්ත වශයෙන්ම යම් බදු ප්‍රමාණයක් අඩු කර ඇත්නම්, ගණනය කිරීම වෙනස් ආකාරයකින් වෙනස් විය හැක.",
        AppLanguage.bn =>
          "আপনি কর কর্তন করা হয়নি নির্বাচন করেছেন — যদি আসলে কিছু কর কর্তন করা হয়, তবে গণনা ভিন্ন দিকে পরিবর্তিত হতে পারে।",
        AppLanguage.my =>
          "သင်သည် အခွန်ဖြတ်တောက်ခြင်းမရှိဟု ရွေးချယ်ထားပါသည် — အကယ်၍ အမှန်တကယ် အခွန်အချို့ ဖြတ်တောက်ခံရပါက တွက်ချက်မှုသည် ကွဲပြားသော ဦးတည်ရာသို့ ပြောင်းလဲသွားနိုင်ပါသည်။",
        AppLanguage.mn =>
          "Та татвар суутгагдаагүй гэж сонгосон — хэрэв үнэндээ тодорхой хэмжээний татвар суутгагдаж байгаа бол тооцоолол өөр чиглэлд өөрчлөгдөж болно.",
        AppLanguage.lo =>
          "ທ່ານໄດ້ເລືອກວ່າບໍ່ມີການຫັກພາສີ — ຖ້າຕົວຈິງແລ້ວມີການຫັກພາສີບາງສ່ວນ, ການຄິດໄລ່ອາດຈະປ່ຽນແປງໄປໃນທິດທາງທີ່ແຕກຕ່າງກັນ.",
        AppLanguage.tet =>
          "Ita hili katak la iha dedusaun impostu — se iha realidade iha impostu ruma ne'ebé deduzidu, kalkulasaun bele muda ba direksaun seluk.",
        AppLanguage.ne =>
          "तपाईंले कर कटौती नगरिएको छान्नुभयो — यदि वास्तवमा केही कर कटौती भइरहेको छ भने, गणना फरक दिशामा परिवर्तन हुन सक्छ।",
        AppLanguage.zh => '您选择了不扣税，但如果实际上确实扣除了部分税款，计算结果则可能相反。',
        AppLanguage.vi =>
          'Bạn đã chọn không bị khấu trừ thuế — nhưng nếu thực tế có khấu trừ một phần, kết quả tính có thể thay đổi theo chiều ngược lại.',
      });
    }

    final head = switch (lang) {
      AppLanguage.ko =>
        '계산 결과보다 약 <b>${formatWon(gapVal.abs(), lang)}</b> 더 받으셨어요. 체불은 아니고, 대부분 계산 방식의 차이예요.',
      AppLanguage.uz =>
        "Siz hisoblangan natijadan taxminan <b>${formatWon(gapVal.abs(), lang)}</b> koʻproq oldingiz. Bu toʻlanmagan ish haqi emas — bu asosan hisoblash usulidagi farqdir.",
      AppLanguage.en =>
        'You received about <b>${formatWon(gapVal.abs(), lang)}</b> more than the calculated result. This is not unpaid wages — it is mostly a difference in calculation method.',
      AppLanguage.tr =>
        "Hesaplanan sonuçtan yaklaşık <b>${formatWon(gapVal.abs(), lang)}</b> daha fazla aldınız. Bu, ödenmemiş ücret değildir — çoğunlukla hesaplama yöntemindeki bir farktır.",
      AppLanguage.tg =>
        "Шумо тақрибан <b>${formatWon(gapVal.abs(), lang)}</b> бештар аз натиҷаи ҳисобшуда гирифтед. Ин музди меҳнати пардохтнашуда нест — он асосан фарқият дар усули ҳисобкунӣ мебошад.",
      AppLanguage.fil =>
        "Nakakuha ka ng humigit-kumulang <b>${formatWon(gapVal.abs(), lang)}</b> na mas malaki kaysa sa kinakalkulang resulta. Hindi ito hindi nabayarang sahod — kadalasan ay isang pagkakaiba sa paraan ng pagkalkula.",
      AppLanguage.ur =>
        "آپ کو حساب شدہ نتیجے سے تقریباً <b>${formatWon(gapVal.abs(), lang)}</b> زیادہ ملا ہے۔ یہ غیر ادا شدہ اجرت نہیں ہے — زیادہ تر یہ حساب کے طریقہ کار میں فرق ہے۔",
      AppLanguage.th =>
        "คุณได้รับเงินมากกว่าผลการคำนวณประมาณ <b>${formatWon(gapVal.abs(), lang)}</b> นี่ไม่ใช่ค่าจ้างที่ยังไม่ได้รับ — ส่วนใหญ่เป็นความแตกต่างในวิธีการคำนวณ",
      AppLanguage.ky =>
        "Сиз эсептелген натыйжадан болжол менен <b>${formatWon(gapVal.abs(), lang)}</b> KRW көбүрөөк алдыңыз. Бул төлөнбөгөн эмгек акы эмес — көбүнчө эсептөө ыкмасындагы айырма.",
      AppLanguage.km =>
        "អ្នកបានទទួលប្រហែល <b>${formatWon(gapVal.abs(), lang)}</b> ច្រើនជាងលទ្ធផលដែលបានគណនា។ នេះមិនមែនជាប្រាក់ឈ្នួលដែលមិនទាន់បានបង់ទេ — ភាគច្រើនវាគឺជាភាពខុសគ្នានៃវិធីសាស្ត្រគណនា។",
      AppLanguage.id =>
        "Anda menerima sekitar <b>${formatWon(gapVal.abs(), lang)}</b> lebih banyak dari hasil yang dihitung. Ini bukan upah yang belum dibayar — ini sebagian besar adalah perbedaan dalam metode perhitungan.",
      AppLanguage.si =>
        "ඔබට ගණනය කළ ප්‍රතිඵලයට වඩා KRW <b>${formatWon(gapVal.abs(), lang)}</b>ක් පමණ වැඩිපුර ලැබී ඇත. මෙය නොගෙවූ වැටුපක් නොවේ — බොහෝ විට එය ගණනය කිරීමේ ක්‍රමයේ වෙනසකි.",
      AppLanguage.bn =>
        "আপনি গণনা করা ফলাফলের চেয়ে প্রায় <b>${formatWon(gapVal.abs(), lang)}</b> বেশি পেয়েছেন। এটি অপরিশোধিত মজুরি নয় — বেশিরভাগ ক্ষেত্রে এটি গণনা পদ্ধতির একটি পার্থক্য।",
      AppLanguage.my =>
        "တွက်ချက်ထားသော ရလဒ်ထက် ခန့်မှန်းခြေအားဖြင့် <b>${formatWon(gapVal.abs(), lang)}</b> ပိုမိုရရှိခဲ့ပါသည်။ ၎င်းသည် မပေးချေရသေးသော လုပ်ခမဟုတ်ပါ — အများအားဖြင့် တွက်ချက်မှုနည်းလမ်း ကွာခြားမှုတစ်ခုသာ ဖြစ်ပါသည်။",
      AppLanguage.mn =>
        "Та тооцоолсон үр дүнгээс ойролцоогоор <b>${formatWon(gapVal.abs(), lang)}</b> илүү авсан байна. Энэ нь төлөгдөөгүй цалин биш — ихэнхдээ тооцоолох аргачлалын зөрүү юм.",
      AppLanguage.lo =>
        "ທ່ານໄດ້ຮັບຫຼາຍກວ່າຜົນການຄິດໄລ່ປະມານ <b>${formatWon(gapVal.abs(), lang)}</b>. ນີ້ບໍ່ແມ່ນຄ່າຈ້າງທີ່ບໍ່ໄດ້ຈ່າຍ — ສ່ວນຫຼາຍແມ່ນຄວາມແຕກຕ່າງໃນວິທີການຄິດໄລ່.",
      AppLanguage.tet =>
        "Ita simu liu tan aproximadamente <b>${formatWon(gapVal.abs(), lang)}</b> husi rezultadu kalkuladu. Ida ne'e la'ós saláriu la selu — maibé liu-liu diferensa ida iha métodu kalkulasaun.",
      AppLanguage.ne =>
        "तपाईंले गणना गरिएको नतिजा भन्दा लगभग <b>${formatWon(gapVal.abs(), lang)}</b> बढी प्राप्त गर्नुभयो। यो भुक्तानी नभएको तलब होइन — प्रायः यो गणना विधिमा भएको भिन्नता हो।",
      AppLanguage.zh =>
        '您实际收到的金额比计算结果多约<b>${formatWon(gapVal.abs(), lang)}</b>。这不是欠薪，多半是计算方式的差异所致。',
      AppLanguage.vi =>
        'Bạn đã nhận nhiều hơn kết quả tính khoảng <b>${formatWon(gapVal.abs(), lang)}</b>. Đây không phải nợ lương, phần lớn là do khác biệt trong cách tính.',
    };
    final body = parts.map((p) => '· $p').join('\n\n');
    final foot = switch (lang) {
      AppLanguage.ko => '임금명세서의 항목 구성을 확인해 보시면 어떤 항목이 더 포함되어 있는지 알 수 있어요.',
      AppLanguage.uz =>
        "Ish haqi varagʻingizdagi tafsilotlarni tekshirish sizga qaysi qoʻshimcha bandlar kiritilganligini koʻrsatadi.",
      AppLanguage.en =>
        'Checking the breakdown on your payslip will show you which additional items are included.',
      AppLanguage.tr =>
        "Maaş bordronuzdaki dökümü kontrol etmek, hangi ek kalemlerin dahil olduğunu gösterecektir.",
      AppLanguage.tg =>
        "Тафтиши тақсимоти варақаи музди меҳнати шумо нишон медиҳад, ки кадом бандҳои иловагӣ дохил карда шудаанд.",
      AppLanguage.fil =>
        "Ang pagsusuri sa breakdown sa iyong payslip ay magpapakita kung anong mga karagdagang item ang kasama.",
      AppLanguage.ur =>
        "اپنی پے سلپ پر موجود تفصیلات کو چیک کرنے سے یہ ظاہر ہو گا کہ کون سی اضافی اشیاء شامل تھیں۔",
      AppLanguage.th =>
        "การตรวจสอบรายละเอียดในสลิปเงินเดือนของคุณจะแสดงให้เห็นว่ามีรายการเพิ่มเติมใดบ้างที่รวมอยู่",
      AppLanguage.ky =>
        "Эмгек акы баракчаңыздагы бөлүштүрүүнү текшерүү, кайсы кошумча пункттар камтылганын көрсөтөт.",
      AppLanguage.km =>
        "ការពិនិត្យមើលការបែងចែកនៅលើប័ណ្ណបើកប្រាក់បៀវត្សរ៍របស់អ្នកនឹងបង្ហាញថាមានធាតុបន្ថែមអ្វីខ្លះដែលត្រូវបានរាប់បញ្ចូល។",
      AppLanguage.id =>
        "Memeriksa rincian pada slip gaji Anda akan menunjukkan item tambahan apa yang termasuk.",
      AppLanguage.si =>
        "ඔබේ වැටුප් පත්‍රිකාවේ ඇති විස්තර පරීක්ෂා කිරීමෙන්, ඇතුළත් කර ඇති අමතර අයිතම මොනවාදැයි පෙන්වනු ඇත.",
      AppLanguage.bn =>
        "আপনার বেতন স্লিপের বিবরণ পরীক্ষা করলে কোন অতিরিক্ত আইটেমগুলি অন্তর্ভুক্ত ছিল তা দেখাবে।",
      AppLanguage.my =>
        "သင်၏ လစာစာရင်းရှိ အသေးစိတ်အချက်အလက်များကို စစ်ဆေးခြင်းဖြင့် မည်သည့်အပိုပစ္စည်းများ ပါဝင်သည်ကို ပြသပါမည်။",
      AppLanguage.mn =>
        "Таны цалингийн хуудасны дэлгэрэнгүй мэдээллийг шалгах нь ямар нэмэлт зүйлс багтсаныг харуулах болно.",
      AppLanguage.lo =>
        "ການກວດສອບລາຍລະອຽດໃນໃບແຈ້ງເງິນເດືອນຂອງທ່ານ, ຈະສະແດງໃຫ້ເຫັນວ່າລາຍການເພີ່ມເຕີມໃດແດ່ທີ່ຖືກລວມເຂົ້າ.",
      AppLanguage.tet =>
        "Verifika detallu iha ita-nia folla saláriu, sei hatudu item adisionál sira ne'ebé inklui.",
      AppLanguage.ne =>
        "तपाईंको तलब पर्चीमा भएको विवरण जाँच गर्दा, कुन अतिरिक्त वस्तुहरू समावेश छन् भन्ने देखाउनेछ।",
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
  AppLanguage.uz =>
    "<b>Bu roʻyxat qanday tuziladi?</b>\nBiz faqat sizning raqamlaringizga mos keladigan oldindan koʻrib chiqilgan maqola tushuntirishlarini qatʼiy qoida boʻyicha tanlaymiz. AI yangi huquqiy dalillarni yaratmaydi.",
  AppLanguage.en =>
    '<b>How is this list made?</b>\nWe select, by fixed rule, only pre-reviewed article explanations matching your figures. The AI does not generate new legal arguments.',
  AppLanguage.tr =>
    "<b>Bu liste nasıl oluşturulur?</b>\nSabit bir kurala göre, yalnızca rakamlarınızla eşleşen önceden incelenmiş makale açıklamalarını seçiyoruz. Yapay zeka yeni hukuki argümanlar üretmez.",
  AppLanguage.tg =>
    "<b>Ин рӯйхат чӣ гуна тартиб дода мешавад?</b>\nМувофиқи қоидаи муқарраршуда, мо танҳо тавсифи мақолаҳои қаблан тафтишшударо интихоб мекунем, ки ба рақамҳои шумо мувофиқат мекунанд. Зеҳни сунъӣ далелҳои нави ҳуқуқӣ эҷод намекунад.",
  AppLanguage.fil =>
    "<b>Paano nabuo ang listahang ito?</b>\nSa pamamagitan ng isang nakapirming panuntunan, pinipili lang namin ang mga pre-vetted na paglalarawan ng artikulo na tumutugma sa iyong mga numero. Hindi gumagawa ang AI ng mga bagong legal na argumento.",
  AppLanguage.ur =>
    "<b>یہ فہرست کیسے بنائی جاتی ہے؟</b>\nایک مقررہ اصول کے مطابق، ہم صرف پہلے سے جائزہ لیے گئے مضامین کی وضاحتیں منتخب کرتے ہیں جو آپ کے اعداد و شمار سے مطابقت رکھتی ہیں۔ مصنوعی ذہانت نئے قانونی دلائل پیدا نہیں کرتی ہے۔",
  AppLanguage.th =>
    "<b>รายการนี้สร้างขึ้นได้อย่างไร</b>\nเราเลือกเฉพาะคำอธิบายบทความที่ตรวจสอบแล้วซึ่งตรงกับตัวเลขของคุณตามกฎที่กำหนด ปัญญาประดิษฐ์ไม่ได้สร้างข้อโต้แย้งทางกฎหมายใหม่",
  AppLanguage.ky =>
    "<b>Бул тизме кантип түзүлөт?</b>\nТуруктуу эреже боюнча, биз сиздин сандарыңызга дал келген алдын ала каралган макала сүрөттөмөлөрүн гана тандайбыз. Жасалма интеллект жаңы укуктук аргументтерди жаратпайт.",
  AppLanguage.km =>
    "<b>តើបញ្ជីនេះត្រូវបានបង្កើតឡើងដោយរបៀបណា?</b>\nតាមក្បួនកំណត់ យើងជ្រើសរើសតែការពិពណ៌នាអត្ថបទដែលបានពិនិត្យជាមុនដែលត្រូវគ្នានឹងលេខរបស់អ្នក។ បញ្ញាសិប្បនិម្មិតមិនបង្កើតអំណះអំណាងផ្លូវច្បាប់ថ្មីទេ។",
  AppLanguage.id =>
    "<b>Bagaimana daftar ini dibuat?</b>\nBerdasarkan aturan yang ketat, kami hanya memilih deskripsi artikel yang telah ditinjau sebelumnya yang cocok dengan angka Anda. AI tidak menghasilkan argumen hukum baru.",
  AppLanguage.si =>
    "<b>මෙම ලැයිස්තුව සාදා ඇත්තේ කෙසේද?</b>\nස්ථාවර රීතියකට අනුව, අපි ඔබේ සංඛ්‍යා සමඟ ගැලපෙන පූර්ව පරීක්ෂා කරන ලද ලිපි විස්තර පමණක් තෝරා ගනිමු. කෘතිම බුද්ධිය නව නීතිමය තර්ක ජනනය නොකරයි.",
  AppLanguage.bn =>
    "<b>এই তালিকাটি কীভাবে তৈরি হয়?</b>\nএকটি নির্দিষ্ট নিয়ম অনুসারে, আমরা শুধুমাত্র আপনার সংখ্যার সাথে মিলে যাওয়া পূর্ব-পর্যালোচিত নিবন্ধের বিবরণ নির্বাচন করি। এআই নতুন আইনি যুক্তি তৈরি করে না।",
  AppLanguage.my =>
    "<b>ဤစာရင်းကို မည်သို့ဖန်တီးထားသနည်း။</b>\nကျွန်ုပ်တို့သည် သင်၏ ကိန်းဂဏန်းများနှင့် ကိုက်ညီသော ကြိုတင်စစ်ဆေးထားသည့် ဆောင်းပါးဖော်ပြချက်များကိုသာ ရွေးချယ်ပါသည်။ ဉာဏ်ရည်တုသည် ဥပဒေရေးရာ အငြင်းပွားမှုအသစ်များကို ထုတ်လုပ်ခြင်းမရှိပါ။",
  AppLanguage.mn =>
    "<b>Энэ жагсаалтыг хэрхэн үүсгэдэг вэ?</b>\nБид тогтсон дүрмийн дагуу таны тоон мэдээлэлтэй таарч байгаа урьдчилан шалгасан нийтлэлийн тайлбаруудыг л сонгодог. Хиймэл оюун ухаан шинэ хууль эрх зүйн аргументуудыг үүсгэдэггүй.",
  AppLanguage.lo =>
    "<b>ລາຍການນີ້ຖືກສ້າງຂຶ້ນແນວໃດ?</b>\nອີງຕາມກົດລະບຽບທີ່ກຳນົດໄວ້, ພວກເຮົາເລືອກສະເພາະຄຳອະທິບາຍບົດຄວາມທີ່ໄດ້ກວດສອບກ່ອນໜ້ານີ້ທີ່ກົງກັບຕົວເລກຂອງທ່ານເທົ່ານັ້ນ. ປັນຍາປະດິດບໍ່ໄດ້ສ້າງຂໍ້ໂຕ້ແຍ້ງທາງກົດໝາຍໃໝ່.",
  AppLanguage.tet =>
    "<b>Oinsá lista ne'e kria?</b>\nTuir regra fixu ida, ami hili de'it deskrisaun artigu ne'ebé revistu ona no koresponde ho ita-nia númeru sira. Intelijénsia artifisiál la kria argumentu legál foun.",
  AppLanguage.ne =>
    "<b>यो सूची कसरी बनाइन्छ?</b>\nएक निश्चित नियम अनुसार, हामी तपाईंको तथ्याङ्कहरूसँग मिल्ने पूर्व-जाँच गरिएका लेख विवरणहरू मात्र चयन गर्छौं। कृत्रिम बुद्धिमत्ताले नयाँ कानूनी तर्कहरू उत्पन्न गर्दैन।",
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
    AppLanguage.uz => " KRW",
    AppLanguage.en => ' KRW',
    AppLanguage.tr => " KRW",
    AppLanguage.tg => " KRW",
    AppLanguage.fil => " KRW",
    AppLanguage.ur => " KRW",
    AppLanguage.th => " วอน",
    AppLanguage.ky => " KRW",
    AppLanguage.km => " វ៉ុន",
    AppLanguage.id => " KRW",
    AppLanguage.si => " KRW",
    AppLanguage.bn => " KRW",
    AppLanguage.my => " KRW",
    AppLanguage.mn => " вон",
    AppLanguage.lo => " KRW",
    AppLanguage.tet => " KRW",
    AppLanguage.ne => " KRW",
    AppLanguage.zh => '韩元',
    AppLanguage.vi => ' KRW',
  };
  return '$sign$buffer$suffix';
}
