import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../worklog/screens/wage_navigator_screen.dart';
import '../models/wage_diagnosis.dart';
import '../widgets/wage_result_card.dart';

/// 임금·체불 정밀 진단 계산기. 프론트엔드_계산기.html 형식을 그대로 옮겼다.
/// 계약 방식·확인 기간을 고르면 근로기준법 기준 예상 수령액을 항목별로 계산해
/// 실제 입금액과 비교한다 — 계산 결과는 참고용 추정치이며, 진정서 금액은
/// 근로감독관 조사에서 확정된다(WageNavigatorScreen 4단계 fillcard와 동일한 원칙).
class WageCalculatorScreen extends StatefulWidget {
  const WageCalculatorScreen({super.key});

  @override
  State<WageCalculatorScreen> createState() => _WageCalculatorScreenState();
}

class _WageCalculatorScreenState extends State<WageCalculatorScreen> {
  ContractType _contractType = ContractType.hourly;
  CheckPeriod _checkPeriod = CheckPeriod.thisPeriod;
  MonthScope _monthScope = MonthScope.month;
  BusinessSize _businessSize = BusinessSize.over5;
  VisaTrack _visaTrack = VisaTrack.e9h2;
  TaxType _taxType = TaxType.socialInsurance;
  RoomType _roomType = RoomType.dorm;
  bool _absentThisMonth = false;
  bool _roomOn = false;
  bool _showResult = false;

  late final _amountCtrl = TextEditingController(text: _amountDefault(_contractType).toStringAsFixed(0));
  final _weekHoursCtrl = TextEditingController(text: '40');
  final _dailyHoursCtrl = TextEditingController(text: '8');
  final _workDaysCtrl = TextEditingController(text: '5');
  final _dayCountCtrl = TextEditingController(text: '22');
  final _otCtrl = TextEditingController(text: '0');
  final _ntCtrl = TextEditingController(text: '0');
  final _holCtrl = TextEditingController(text: '0');
  final _tenureYCtrl = TextEditingController(text: '0');
  final _tenureMCtrl = TextEditingController(text: '0');
  final _tenureWCtrl = TextEditingController(text: '0');
  final _tenureDCtrl = TextEditingController(text: '0');
  final _receivedCtrl = TextEditingController(text: '1800000');
  final _monthsCtrl = TextEditingController(text: '3');
  final _believedCtrl = TextEditingController(text: '6000000');
  final _receivedTotalCtrl = TextEditingController(text: '0');
  final _roomAmtCtrl = TextEditingController(text: '200000');

  @override
  void dispose() {
    for (final c in [
      _amountCtrl,
      _weekHoursCtrl,
      _dailyHoursCtrl,
      _workDaysCtrl,
      _dayCountCtrl,
      _otCtrl,
      _ntCtrl,
      _holCtrl,
      _tenureYCtrl,
      _tenureMCtrl,
      _tenureWCtrl,
      _tenureDCtrl,
      _receivedCtrl,
      _monthsCtrl,
      _believedCtrl,
      _receivedTotalCtrl,
      _roomAmtCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  double _amountDefault(ContractType type) => switch (type) {
        ContractType.hourly => minimumWage,
        ContractType.daily => 90000,
        ContractType.weekly => 400000,
        ContractType.monthly => 2200000,
        ContractType.annual => 30000000,
      };

  String _amountLabel(ContractType type) => switch (type) {
        ContractType.hourly => '시급 (원)',
        ContractType.daily => '일급 (원)',
        ContractType.weekly => '주급 (원)',
        ContractType.monthly => '월 약정 급여 (원, 주휴수당 포함 금액)',
        ContractType.annual => '연봉 총액 (원)',
      };

  double _num(TextEditingController c) => double.tryParse(c.text) ?? 0;

  void _setContractType(ContractType type) {
    setState(() {
      _contractType = type;
      _amountCtrl.text = _amountDefault(type).toStringAsFixed(0);
    });
  }

  void _setMonthScope(MonthScope scope) {
    setState(() {
      _monthScope = scope;
      _dayCountCtrl.text = scope == MonthScope.week ? '5' : '22';
    });
  }

  void _fillFromWorklogDemo() {
    setState(() {
      _contractType = ContractType.hourly;
      _checkPeriod = CheckPeriod.thisPeriod;
      _monthScope = MonthScope.month;
      _amountCtrl.text = minimumWage.toStringAsFixed(0);
      _weekHoursCtrl.text = '40';
      _otCtrl.text = '20';
      _ntCtrl.text = '8';
      _holCtrl.text = '0';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('데모입니다 — 실제 근무기록장 연동은 추후 지원됩니다. 샘플 값을 채워 넣었어요.')),
    );
  }

  WageDiagnosisInput _buildInput() {
    return WageDiagnosisInput(
      contractType: _contractType,
      checkPeriod: _checkPeriod,
      monthScope: _monthScope,
      businessSize: _businessSize,
      visaTrack: _visaTrack,
      taxType: _taxType,
      amount: _num(_amountCtrl),
      weekHours: _num(_weekHoursCtrl),
      dailyHours: _num(_dailyHoursCtrl),
      workDaysPerWeek: _num(_workDaysCtrl),
      dayCount: _num(_dayCountCtrl),
      overtimeHours: _num(_otCtrl),
      nightHours: _num(_ntCtrl),
      holidayHours: _num(_holCtrl),
      absentThisMonth: _absentThisMonth,
      tenureYears: _num(_tenureYCtrl),
      tenureMonths: _num(_tenureMCtrl),
      tenureWeeksPart: _num(_tenureWCtrl),
      tenureDaysPart: _num(_tenureDCtrl),
      roomDeductionOn: _roomOn,
      roomAmount: _num(_roomAmtCtrl),
      roomType: _roomType,
      receivedAmount: _num(_receivedCtrl),
      unpaidMonths: _num(_monthsCtrl),
      believedTotalAmount: _num(_believedCtrl),
      receivedTotalAmount: _num(_receivedTotalCtrl),
    );
  }

  void _openTaxInfoModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('근로자의 세금 적용 방법', style: TextStyle(fontSize: 15)),
        content: SizedBox(
          width: 380,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '1) 4대보험 약 9.72% 공제 — 근로자를 회사와 고용관계에 있다고 보고 4대보험에 가입하여 세금을 적용하는 방법입니다.',
                  style: TextStyle(fontSize: 12, height: 1.5),
                ),
                const SizedBox(height: 10),
                Table(
                  border: TableBorder.all(color: AppColors.border),
                  children: [
                    _TaxTableRow(const ['', '근로자(급여공제)', '사업주'], isHeader: true),
                    _TaxTableRow(['국민연금 (9.5%)', '4.75%', '4.75%']),
                    _TaxTableRow(['건강보험료 (7.19%)', '3.595%', '3.595%']),
                    _TaxTableRow(['장기요양보험', '건보료의 13.14%', '건보료의 13.14%']),
                    _TaxTableRow(['고용보험', '0.9%', '기업규모별 상이']),
                    _TaxTableRow(['산재보험', '없음', '업종별 상이(전액 사업주 부담)']),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  '월 60시간 미만으로 일하는 초단시간 근로자는 국민연금·건강보험 가입대상이 아닌 경우가 일반적이라 이 공제가 없을 수 있어요. '
                  '2) 소득세 3.3% 공제 = 소득세 3% + 지방소득세(소득세의 10%). 정확한 가입 대상 여부는 국민연금공단·국민건강보험공단에 확인하는 것이 가장 정확합니다.',
                  style: TextStyle(fontSize: 12, height: 1.5),
                ),
                const SizedBox(height: 8),
                const Text('출처: 국민연금공단·국민건강보험공단·고용보험 2026년 요율 고시', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
              ],
            ),
          ),
        ),
        actions: [FilledButton(onPressed: () => Navigator.of(context).pop(), child: const Text('확인'))],
      ),
    );
  }

  void _openRoomTipModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🏠 숙식비 공제', style: TextStyle(fontSize: 15)),
        content: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            border: const Border(left: BorderSide(color: AppColors.accent, width: 3)),
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('노무 진단 팁', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF78350F))),
              SizedBox(height: 5),
              Text(
                '급여에서 숙식비를 공제하는 것은 근로자의 명확한 서면 동의가 있어야만 적법합니다. 동의 없이 공제되었거나 과도하게 차감되었다면 '
                '임금체불에 해당할 수 있으니 근로계약서를 다시 확인해 보세요! 또한 공제 후 환산 시급이 최저임금보다 낮아지면 안 됩니다.',
                style: TextStyle(fontSize: 12, height: 1.55, color: Color(0xFF78350F)),
              ),
            ],
          ),
        ),
        actions: [FilledButton(onPressed: () => Navigator.of(context).pop(), child: const Text('확인'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final input = _buildInput();
    final result = _showResult ? calculateWageDiagnosis(input) : null;
    final showBelievedHint =
        _checkPeriod == CheckPeriod.unpaidLong && (_contractType == ContractType.monthly || _contractType == ContractType.annual);
    final monthlyAmtForHint = _contractType == ContractType.annual ? _num(_amountCtrl) / 12 : _num(_amountCtrl);
    final months = _num(_monthsCtrl);

    return Scaffold(
      appBar: AppBar(title: const Text('임금 계산기')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeaderCard(onImportDemo: _fillFromWorklogDemo),
          const SizedBox(height: 14),

          // 계약 방식
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: AppColors.blueBg, border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1.5), borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💼 급여 계약 방식 (내 계약 형태)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                const SizedBox(height: 9),
                Row(
                  children: [
                    Expanded(child: _ChoiceButton(label: '시급', selected: _contractType == ContractType.hourly, color: AppColors.primary, onTap: () => _setContractType(ContractType.hourly))),
                    const SizedBox(width: 6),
                    Expanded(child: _ChoiceButton(label: '일급', selected: _contractType == ContractType.daily, color: AppColors.primary, onTap: () => _setContractType(ContractType.daily))),
                    const SizedBox(width: 6),
                    Expanded(child: _ChoiceButton(label: '주급', selected: _contractType == ContractType.weekly, color: AppColors.primary, onTap: () => _setContractType(ContractType.weekly))),
                  ],
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Expanded(child: _ChoiceButton(label: '월급', selected: _contractType == ContractType.monthly, color: AppColors.primary, onTap: () => _setContractType(ContractType.monthly))),
                    const SizedBox(width: 6),
                    Expanded(child: _ChoiceButton(label: '연봉', selected: _contractType == ContractType.annual, color: AppColors.primary, onTap: () => _setContractType(ContractType.annual))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // 확인할 기간
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.05), border: Border.all(color: AppColors.secondary.withValues(alpha: 0.25), width: 1.5), borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('⏳ 확인할 기간', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.secondary)),
                const SizedBox(height: 9),
                _ChoiceButton(
                  label: '📅 이번 달만 검사',
                  selected: _checkPeriod == CheckPeriod.thisPeriod,
                  color: AppColors.secondary,
                  onTap: () => setState(() => _checkPeriod = CheckPeriod.thisPeriod),
                ),
                const SizedBox(height: 7),
                _ChoiceButton(
                  label: '⏳ 여러 달 동안 못 받았어요',
                  selected: _checkPeriod == CheckPeriod.unpaidLong,
                  color: AppColors.secondary,
                  onTap: () => setState(() => _checkPeriod = CheckPeriod.unpaidLong),
                ),
                if (_checkPeriod == CheckPeriod.thisPeriod) ...[
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 9),
                  const Text('이번 달 중 어떤 기간을 확인하시겠어요?', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Expanded(child: _ChoiceButton(label: '1주일치만', selected: _monthScope == MonthScope.week, color: AppColors.primary, small: true, onTap: () => _setMonthScope(MonthScope.week))),
                      const SizedBox(width: 6),
                      Expanded(child: _ChoiceButton(label: '한 달 전체', selected: _monthScope == MonthScope.month, color: AppColors.primary, small: true, onTap: () => _setMonthScope(MonthScope.month))),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),

          // 사업장 규모 · 비자
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.background, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('사업장 상시 근로자 수 (★ 가산수당 적용 기준)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                const SizedBox(height: 5),
                _Dropdown<BusinessSize>(
                  value: _businessSize,
                  items: const {
                    BusinessSize.over5: '5인 이상 사업장 (연장·야간·휴일에 가산수당 적용)',
                    BusinessSize.under5: '5인 미만 사업장 (가산수당 미적용, 1.0배)',
                    BusinessSize.unknown: '잘 모름 (일단 5인 미만으로 계산)',
                  },
                  onChanged: (v) => setState(() => _businessSize = v),
                ),
                const SizedBox(height: 12),
                const Text('체류 자격 (참고용 — 계산에는 반영하지 않음)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                const SizedBox(height: 5),
                _Dropdown<VisaTrack>(
                  value: _visaTrack,
                  items: const {
                    VisaTrack.e9h2: 'E-9 / H-2 (고용허가제 노동자)',
                    VisaTrack.d2: 'D-2 (유학생)',
                    VisaTrack.etc: '기타 체류 자격',
                  },
                  onChanged: (v) => setState(() => _visaTrack = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // 동적 입력
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: AppColors.blueBg.withValues(alpha: 0.35), border: Border.all(color: AppColors.blueBorder), borderRadius: BorderRadius.circular(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('📝 근무 조건 입력', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                const SizedBox(height: 10),
                _NumberField(label: _amountLabel(_contractType), controller: _amountCtrl, onChanged: () => setState(() {})),
                const SizedBox(height: 9),
                if (_contractType == ContractType.daily) ...[
                  _NumberField(label: '하루 약정 근무시간 (시간)', controller: _dailyHoursCtrl, help: '하루에 보통 몇 시간 일하시나요? 주휴수당·통상시급 계산의 기준이 돼요', onChanged: () => setState(() {})),
                  const SizedBox(height: 9),
                  _NumberField(label: '주당 근무일수 (일)', controller: _workDaysCtrl, onChanged: () => setState(() {})),
                  const SizedBox(height: 9),
                  _NumberField(
                    label: _monthScope == MonthScope.week ? '이번 주 근무 일수' : '이번 달 근무 일수',
                    controller: _dayCountCtrl,
                    onChanged: () => setState(() {}),
                  ),
                ] else
                  _NumberField(label: '주당 약정 근무시간 (시간)', controller: _weekHoursCtrl, help: '월 소정근로시간·주휴수당 계산의 기준이 돼요', onChanged: () => setState(() {})),
                const SizedBox(height: 14),
                const Text('추가 근로시간 (해당 없으면 0)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                _NumberField(label: '연장근로 (시간)', controller: _otCtrl, help: '하루 8h·주 40h를 넘긴 시간', onChanged: () => setState(() {})),
                const SizedBox(height: 9),
                _NumberField(label: '야간근로 22~06시 (시간)', controller: _ntCtrl, onChanged: () => setState(() {})),
                const SizedBox(height: 9),
                _NumberField(label: '휴일근로 (시간)', controller: _holCtrl, help: '주휴일·약정휴일에 일한 시간', onChanged: () => setState(() {})),
                const SizedBox(height: 10),
                _CheckRow(
                  label: '이번 달 결근한 날이 있어요 (지각·조퇴는 결근 아님)',
                  value: _absentThisMonth,
                  onChanged: (v) => setState(() => _absentThisMonth = v),
                ),
                const SizedBox(height: 12),
                const Text('이 일터에서 일한 기간 (모르면 0)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(child: _TinyNumberField(label: '년', controller: _tenureYCtrl, onChanged: () => setState(() {}))),
                    const SizedBox(width: 6),
                    Expanded(child: _TinyNumberField(label: '개월', controller: _tenureMCtrl, onChanged: () => setState(() {}))),
                    const SizedBox(width: 6),
                    Expanded(child: _TinyNumberField(label: '주', controller: _tenureWCtrl, onChanged: () => setState(() {}))),
                    const SizedBox(width: 6),
                    Expanded(child: _TinyNumberField(label: '일', controller: _tenureDCtrl, onChanged: () => setState(() {}))),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text('365일 이상이면 퇴직금 대상 여부를 함께 알려드려요', style: TextStyle(fontSize: 9.5, color: AppColors.textMuted)),
                ),
                const SizedBox(height: 14),
                if (_checkPeriod == CheckPeriod.unpaidLong) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFFFFBEB), border: Border.all(color: const Color(0xFFFDE68A)), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('⏳ 여러 달 못 받은 급여 정보', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF92400E))),
                        const SizedBox(height: 9),
                        _NumberField(label: '못 받은 개월 수', controller: _monthsCtrl, help: '위 근무조건이 매달 같다고 가정한 근사치예요', onChanged: () => setState(() {})),
                        const SizedBox(height: 9),
                        _NumberField(label: '그 기간 동안 총 받기로 약속된 금액 (전체 합계)', controller: _believedCtrl, help: '한 달치가 아니라 전체 기간 합계예요. 예: 월급×개월수', onChanged: () => setState(() {})),
                        const SizedBox(height: 9),
                        _NumberField(label: '그 기간 실제로 받은 금액 합계 (못 받았으면 0)', controller: _receivedTotalCtrl, onChanged: () => setState(() {})),
                        if (showBelievedHint) ...[
                          const SizedBox(height: 6),
                          Text(
                            '참고로 계약 조건으로는 약 ${formatWon(monthlyAmtForHint * months)} (${formatWon(monthlyAmtForHint)} × ${months.toStringAsFixed(0)})',
                            style: const TextStyle(fontSize: 10.5, color: Color(0xFF92400E)),
                          ),
                        ],
                      ],
                    ),
                  ),
                ] else
                  _NumberField(label: '실제로 통장에 들어온 금액 (원)', controller: _receivedCtrl, help: '나눠서 받았으면 모두 더해서 적어주세요', onChanged: () => setState(() {})),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // 세금/공제
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.background, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🏷️ 세금 및 공제 유형 선택', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    _InfoButton(onTap: _openTaxInfoModal),
                  ],
                ),
                const SizedBox(height: 9),
                _TaxOptionCard(value: TaxType.socialInsurance, groupValue: _taxType, title: '4대보험 적용 (약 9.7%)', subtitle: '국민연금·건강보험·고용보험이 정식으로 빠지는 월급', onChanged: (v) => setState(() => _taxType = v)),
                const SizedBox(height: 7),
                _TaxOptionCard(value: TaxType.businessTax, groupValue: _taxType, title: "3.3%만 떼요 (사업소득세)", subtitle: "⚠️ 회사가 '프리랜서'로 신고했을 가능성", onChanged: (v) => setState(() => _taxType = v)),
                const SizedBox(height: 7),
                _TaxOptionCard(value: TaxType.none, groupValue: _taxType, title: '세금을 안 떼요', subtitle: '현금이나 전액 그대로 수령', onChanged: (v) => setState(() => _taxType = v)),
                const SizedBox(height: 7),
                _TaxOptionCard(value: TaxType.unknown, groupValue: _taxType, title: '잘 모르겠어요', subtitle: '두 가지 경우를 함께 보여드려요', onChanged: (v) => setState(() => _taxType = v)),
                if (_taxType == TaxType.businessTax) ...[
                  const SizedBox(height: 9),
                  Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(color: const Color(0xFFFFFBEB), border: Border.all(color: const Color(0xFFFCD34D)), borderRadius: BorderRadius.circular(10)),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('⚠️', style: TextStyle(fontSize: 15)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "[위장 프리랜서 확인이 필요할 수 있어요] 매일 정해진 시간에 출퇴근하고 사장님의 지시를 받으며 일하는데 3.3%만 떼고 있다면, "
                            '계약상 이름과 관계없이 근로기준법상 근로자로 인정될 수 있습니다. 근로자로 인정되면 주휴수당·퇴직금·4대보험을 요구할 수 있습니다. '
                            '다만 이는 근로감독관 조사나 법원 판단으로 확정되는 사안입니다.',
                            style: TextStyle(fontSize: 11, color: Color(0xFF78350F), height: 1.55),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),

          // 숙식비 공제
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.background, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🏠 숙식비 공제', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    _InfoButton(onTap: _openRoomTipModal),
                  ],
                ),
                const SizedBox(height: 9),
                _CheckRow(
                  label: '기숙사비·식비 명목으로 급여에서 빠지는 금액이 있어요',
                  value: _roomOn,
                  onChanged: (v) => setState(() => _roomOn = v),
                ),
                if (_roomOn) ...[
                  const SizedBox(height: 10),
                  _NumberField(label: '이번 달 숙식비 공제액 (원)', controller: _roomAmtCtrl, onChanged: () => setState(() {})),
                  const SizedBox(height: 9),
                  const Text('숙식 제공 형태', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  const SizedBox(height: 5),
                  _Dropdown<RoomType>(
                    value: _roomType,
                    items: const {RoomType.dorm: '기숙사', RoomType.studio: '원룸·주택', RoomType.mealOnly: '식사만'},
                    onChanged: (v) => setState(() => _roomType = v),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => _showResult = true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
              ),
              child: const Text('✨ 정밀 임금 및 체불 진단 리포트 생성하기', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            ),
          ),

          if (result != null) ...[
            const SizedBox(height: 20),
            const Divider(thickness: 2, color: AppColors.primary),
            const SizedBox(height: 16),
            WageResultCard(
              input: input,
              result: result,
              onOpenWageNavigator: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WageNavigatorScreen())),
              onFindNearbyOrgs: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('관할 지방고용노동청과 외국인노동자지원센터 위치·연락처를 보여드립니다. (준비 중)')),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TaxTableRow extends TableRow {
  _TaxTableRow(List<String> cells, {bool isHeader = false})
      : super(
          decoration: isHeader ? const BoxDecoration(color: Color(0xFFF1F5F9)) : null,
          children: cells
              .map(
                (c) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  child: Text(
                    c,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10.5, fontWeight: isHeader ? FontWeight.w700 : FontWeight.w400),
                  ),
                ),
              )
              .toList(),
        );
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.onImportDemo});
  final VoidCallback onImportDemo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
            decoration: BoxDecoration(color: AppColors.blueBg, borderRadius: BorderRadius.circular(20)),
            child: const Text('Local Bridge · 외국인 노동자 임금 진단', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
          ),
          const SizedBox(height: 8),
          const Text(
            '외국인 노동자 맞춤형 정밀 임금·체불 진단 계산기',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text(
            '계약 방식과 확인할 기간을 고르면, 근로기준법 기준으로 받아야 할 금액을 항목별로 계산해서 실제 입금액과 비교해 드려요.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.5, color: AppColors.textMuted, height: 1.5),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: const [
              _Chip('기본급'),
              _Chip('주휴수당(제55조)'),
              _Chip('연장·야간·휴일 가산(제56조)'),
              _Chip('최저임금 미달 확인'),
              _Chip('체불 괴리 감지'),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onImportDemo,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.secondary,
              backgroundColor: AppColors.secondary.withValues(alpha: 0.08),
              side: BorderSide(color: AppColors.secondary.withValues(alpha: 0.3)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('📋 근무기록장에서 불러오기 (데모)', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({required this.label, required this.selected, required this.color, required this.onTap, this.small = false});
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: small ? 9 : 11),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          border: Border.all(color: selected ? color : AppColors.border),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: small ? 11 : 12, fontWeight: FontWeight.w700, color: selected ? Colors.white : AppColors.textSecondary),
        ),
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({required this.label, required this.controller, this.help, this.onChanged});
  final String label;
  final TextEditingController controller;
  final String? help;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (_) => onChanged?.call(),
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 11),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: AppColors.border)),
          ),
        ),
        if (help != null) Padding(padding: const EdgeInsets.only(top: 3), child: Text(help!, style: const TextStyle(fontSize: 9.5, color: AppColors.textMuted))),
      ],
    );
  }
}

class _TinyNumberField extends StatelessWidget {
  const _TinyNumberField({required this.label, required this.controller, this.onChanged});
  final String label;
  final TextEditingController controller;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9.5, color: AppColors.textMuted)),
        const SizedBox(height: 3),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (_) => onChanged?.call(),
          style: const TextStyle(fontSize: 12.5),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
          ),
        ),
      ],
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({required this.label, required this.value, required this.onChanged});
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(value: value, onChanged: (v) => onChanged(v ?? false), visualDensity: VisualDensity.compact),
          const SizedBox(width: 4),
          Expanded(child: Padding(padding: const EdgeInsets.only(top: 12), child: Text(label, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, height: 1.4)))),
        ],
      ),
    );
  }
}

class _Dropdown<T> extends StatelessWidget {
  const _Dropdown({required this.value, required this.items, required this.onChanged});
  final T value;
  final Map<T, String> items;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimary),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 11),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: AppColors.border)),
      ),
      items: items.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value, overflow: TextOverflow.ellipsis))).toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}

class _InfoButton extends StatelessWidget {
  const _InfoButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 18,
          height: 18,
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: AppColors.border, shape: BoxShape.circle),
          child: const Text('?', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
        ),
      ),
    );
  }
}

class _TaxOptionCard extends StatelessWidget {
  const _TaxOptionCard({required this.value, required this.groupValue, required this.title, required this.subtitle, required this.onChanged});
  final TaxType value;
  final TaxType groupValue;
  final String title;
  final String subtitle;
  final ValueChanged<TaxType> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(11),
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: selected ? AppColors.primary : AppColors.border, width: selected ? 1.5 : 1),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, size: 17, color: selected ? AppColors.primary : AppColors.textMuted),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
