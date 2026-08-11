import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../worklog/screens/wage_navigator_screen.dart';
import '../models/wage_diagnosis.dart';
import '../widgets/wage_form_widgets.dart';
import '../widgets/wage_help.dart';
import '../widgets/wage_result_card.dart';

/// 정밀 임금·체불 계산기 (5단계 위저드 + 결과). 프론트엔드_계산기_최종.html(v6)을
/// 그대로 옮겼다 — STEP1(확인기간+임금+비자+사업장) → STEP2(근무시간) →
/// STEP3(재직기간) → STEP4(세금·숙식비) → STEP5(실입금액) → 결과.
///
/// v6는 "이 단독 파일엔 근무기록장·OCR 모듈이 없다"는 이유로 두 불러오기 버튼과
/// 결과 화면의 진정서·기관찾기 버튼을 데모/비활성으로 남겨둔다. 이 앱은 그 모듈이
/// 실제로 있으므로: 근무기록장 불러오기는 데모 값 채우기로 동작시키고, 결과 화면의
/// 진정서 자동매핑·기관찾기 버튼은 실제 네비게이션으로 살려둔다(WageResultCard 참고).
/// OCR(임금명세서 자동 인식)만 실제 이미지 인식 파이프라인이 없어 준비 중 안내로 남긴다.
class WageCalculatorScreen extends StatefulWidget {
  const WageCalculatorScreen({super.key});

  @override
  State<WageCalculatorScreen> createState() => _WageCalculatorScreenState();
}

class _WageCalculatorScreenState extends State<WageCalculatorScreen> {
  static const _totalSteps = 5;
  int _step = 0;
  bool _showResult = false;

  PeriodMode _periodMode = PeriodMode.month;
  VisaChoice _visa = VisaChoice.e9;
  PayType _payType = PayType.hour;
  BizSize _size = BizSize.over5;
  TaxMethod _tax = TaxMethod.four;
  RoomType _roomType = RoomType.dorm;
  bool _absent = false;
  bool _roomOn = false;

  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime? _hireDate;
  DateTime? _leaveDate;

  late final _payCtrl = TextEditingController(
    text: minWage().$1.toStringAsFixed(0),
  );
  final _fixedMonthCtrl = TextEditingController(text: '1');
  final _dailyHoursCtrl = TextEditingController(text: '8');
  final _dayCountTotalCtrl = TextEditingController(text: '22');
  final _weekHoursCtrl = TextEditingController(text: '40');
  final _otCtrl = TextEditingController(text: '0');
  final _nightCtrl = TextEditingController(text: '0');
  final _holCtrl = TextEditingController(text: '0');
  final _multiMonthsCtrl = TextEditingController(text: '3');
  final _bonus1yCtrl = TextEditingController(text: '0');
  final _vacation1yCtrl = TextEditingController(text: '0');
  final _roomAmtCtrl = TextEditingController(text: '0');
  final _receivedCtrl = TextEditingController(text: '0');
  final _visaCustomCtrl = TextEditingController(text: '');

  @override
  void dispose() {
    for (final c in [
      _payCtrl,
      _fixedMonthCtrl,
      _dailyHoursCtrl,
      _dayCountTotalCtrl,
      _weekHoursCtrl,
      _otCtrl,
      _nightCtrl,
      _holCtrl,
      _multiMonthsCtrl,
      _bonus1yCtrl,
      _vacation1yCtrl,
      _roomAmtCtrl,
      _receivedCtrl,
      _visaCustomCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  double _num(TextEditingController c) => double.tryParse(c.text) ?? 0;

  WageCalcInput _buildInput() {
    return WageCalcInput(
      periodMode: _periodMode,
      multiMonths: _num(_multiMonthsCtrl),
      rangeStart: _rangeStart,
      rangeEnd: _rangeEnd,
      visa: _visa,
      visaCustom: _visaCustomCtrl.text,
      payType: _payType,
      pay: _num(_payCtrl),
      dailyHours: _num(_dailyHoursCtrl),
      dayCountTotal: _num(_dayCountTotalCtrl),
      weekHours: _num(_weekHoursCtrl),
      otH: _num(_otCtrl),
      nightH: _num(_nightCtrl),
      holH: _num(_holCtrl),
      hireDate: _hireDate,
      leaveDate: _leaveDate,
      absent: _absent,
      bonus1y: _num(_bonus1yCtrl),
      vacation1y: _num(_vacation1yCtrl),
      size: _size,
      tax: _tax,
      roomOn: _roomOn,
      roomAmtTotal: _num(_roomAmtCtrl),
      roomType: _roomType,
      received: _num(_receivedCtrl),
    );
  }

  void _openHelp(String key) {
    final entry = buildHelpDict()[key];
    if (entry == null) return;
    showWageHelp(context, entry.title, entry.body(context));
  }

  void _setPayType(PayType type) {
    setState(() {
      _payType = type;
      _payCtrl.text = switch (type) {
        PayType.hour => minWage().$1.toStringAsFixed(0),
        PayType.day => '90000',
        PayType.week => '400000',
        PayType.year => '26000000',
        PayType.month => '2200000',
      };
    });
  }

  void _importFromWorklog() {
    setState(() {
      _payType = PayType.hour;
      _payCtrl.text = minWage().$1.toStringAsFixed(0);
      _weekHoursCtrl.text = '40';
      _otCtrl.text = '12';
      _nightCtrl.text = '6';
      _holCtrl.text = '0';
      _hireDate ??= DateTime(2024, 3, 2);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('근무기록장 연동은 준비 중이라 예시 데이터로 채워드렸어요.')),
    );
  }

  void _importFromPayslip() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('임금명세서 자동 인식(OCR)은 준비 중이에요. 값을 직접 입력해 주세요.'),
      ),
    );
  }

  void _goNext() {
    if (_step < _totalSteps - 1) {
      setState(() => _step++);
    } else {
      setState(() => _showResult = true);
    }
  }

  void _goPrev() {
    if (_showResult) {
      setState(() => _showResult = false);
    } else if (_step > 0) {
      setState(() => _step--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final input = _buildInput();
    final result = _showResult ? calcWage(input) : null;

    return Scaffold(
      appBar: AppBar(title: const Text('정밀 임금계산기')),
      body: Column(
        children: [
          _StepHeader(
            stepIndex: _step,
            totalSteps: _totalSteps,
            resultMode: _showResult,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _showResult
                  ? WageResultCard(
                      input: input,
                      result: result!,
                      onOpenWageNavigator: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const WageNavigatorScreen(),
                        ),
                      ),
                      onFindNearbyOrgs: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                '관할 지방고용노동청과 외국인노동자지원센터 위치·연락처를 보여드립니다. (준비 중)',
                              ),
                            ),
                          ),
                    )
                  : _buildStepBody(input),
            ),
          ),
          _StepFooter(
            resultMode: _showResult,
            showPrev: _step > 0,
            nextLabel: _step == _totalSteps - 1 ? '계산하기' : '다음',
            onPrev: _goPrev,
            onNext: _goNext,
          ),
        ],
      ),
    );
  }

  Widget _buildStepBody(WageCalcInput input) {
    switch (_step) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      case 3:
        return _buildStep4(input);
      default:
        return _buildStep5(input);
    }
  }

  // ---------- STEP 1 · 확인 기간 및 임금/사업장 조건 ----------
  Widget _buildStep1() {
    final belowMin =
        _payType == PayType.hour &&
        _num(_payCtrl) > 0 &&
        _num(_payCtrl) < minWage().$1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            ImportButton(label: '📁 근무기록장 불러오기', onTap: _importFromWorklog),
            const SizedBox(width: 7),
            ImportButton(label: '📄 임금명세서 불러오기', onTap: _importFromPayslip),
          ],
        ),
        const SizedBox(height: 12),

        const SectionH4(
          title: '확인하실 기간을 먼저 골라주세요',
          lead: '이번 달 급여만 확인하실지, 여러 달 동안 밀린 급여를 확인하실지 고르세요.',
        ),
        Seg<PeriodMode>(
          options: const [
            ('이번달만', PeriodMode.month),
            ('여러달 체불', PeriodMode.multi),
            ('기간 직접 지정', PeriodMode.range),
          ],
          value: _periodMode,
          onChanged: (v) => setState(() => _periodMode = v),
        ),
        if (_periodMode == PeriodMode.month)
          FGroup(
            children: [
              FRow(
                label: '못 받은 개월 수',
                controller: _fixedMonthCtrl,
                unit: '개월',
                readOnly: true,
                help: () => _openHelp('pm_month'),
              ),
            ],
          )
        else if (_periodMode == PeriodMode.multi)
          FGroup(
            children: [
              FRow(
                label: '못 받은 개월 수',
                controller: _multiMonthsCtrl,
                unit: '개월',
                help: () => _openHelp('pm_multi'),
              ),
            ],
          )
        else
          FGroup(
            title: '체불 시작월 ~ 종료월',
            help: () => _openHelp('pm_range'),
            children: [
              FDateRow(
                label: '시작월',
                value: _rangeStart,
                monthOnly: true,
                onPick: (d) =>
                    setState(() => _rangeStart = DateTime(d.year, d.month, 1)),
              ),
              FDateRow(
                label: '종료월',
                value: _rangeEnd,
                monthOnly: true,
                onPick: (d) =>
                    setState(() => _rangeEnd = DateTime(d.year, d.month, 1)),
              ),
            ],
          ),

        const SectionH4(
          title: '임금과 사업장 조건을 알려주세요',
          lead: '계약서에 적힌 방식 그대로 골라주세요.',
          topGap: 4,
        ),
        FGroup(
          title: '체류자격 (비자)',
          children: [
            Chips<VisaChoice>(
              compact: true,
              options: VisaChoice.values.map((v) => (v.label, v)).toList(),
              value: _visa,
              onChanged: (v) => setState(() => _visa = v),
            ),
            if (_visa == VisaChoice.etc) ...[
              const SizedBox(height: 6),
              FRow(label: '비자 직접입력', controller: _visaCustomCtrl),
            ],
          ],
        ),

        InkWell(
          onTap: () => setState(() {
            _payType = PayType.hour;
            _payCtrl.text = minWage().$1.toStringAsFixed(0);
          }),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            margin: const EdgeInsets.only(bottom: 11),
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF3FE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    '⚖ $wageCalcYear년 최저임금 넣기 (${formatWon(minWage().$1)})',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D4ED8),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                QMark(onTap: () => _openHelp('minw')),
              ],
            ),
          ),
        ),

        FGroup(
          title: '임금 지급 방식',
          children: [
            Seg<PayType>(
              options: const [
                ('시급', PayType.hour),
                ('일급', PayType.day),
                ('주급', PayType.week),
              ],
              value: _payType,
              onChanged: _setPayType,
            ),
            Seg<PayType>(
              options: const [('월급', PayType.month), ('연봉', PayType.year)],
              value: _payType,
              onChanged: _setPayType,
            ),
            FRow(
              label: _payAmountLabel(_payType),
              controller: _payCtrl,
              unit: '원',
            ),
            if (_payType == PayType.day) ...[
              FRow(
                label: '하루 약정 근무시간',
                controller: _dailyHoursCtrl,
                unit: '시간',
              ),
              FRow(
                label: '기간 전체 근무일수',
                controller: _dayCountTotalCtrl,
                unit: '일',
              ),
            ],
          ],
        ),

        if (belowMin)
          RedNotice(
            title: '⚠ 최저임금보다 낮습니다',
            body:
                '계약된 시급 ${formatWon(_num(_payCtrl))}이 $wageCalcYear년 최저임금 ${formatWon(minWage().$1)}보다 낮아요. 미달분은 무효이며 차액을 청구할 수 있습니다.',
          ),

        FGroup(
          title: '사업장 규모',
          help: () => _openHelp('biz_size'),
          children: [
            OptButton(
              icon: '🏢',
              title: '상시 5인 이상',
              selected: _size == BizSize.over5,
              onTap: () => setState(() => _size = BizSize.over5),
            ),
            OptButton(
              icon: '🏠',
              title: '5인 미만',
              selected: _size == BizSize.under5,
              onTap: () => setState(() => _size = BizSize.under5),
            ),
            OptButton(
              icon: '❓',
              title: '잘 모르겠어요',
              selected: _size == BizSize.unknown,
              onTap: () => setState(() => _size = BizSize.unknown),
            ),
          ],
        ),
      ],
    );
  }

  String _payAmountLabel(PayType type) => switch (type) {
    PayType.hour => '시급',
    PayType.day => '일급',
    PayType.week => '주급',
    PayType.month => '월급 (세전)',
    PayType.year => '연봉 (세전)',
  };

  // ---------- STEP 2 · 근무시간 ----------
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionH4(
          title: '근무시간을 알려주세요',
          lead: '약정 시간과 실제 근무 시간의 차이를 계산합니다.',
        ),
        FGroup(
          title: '주당 근로시간',
          help: () => _openHelp('week_h'),
          children: [
            FRow(label: '주당 약정 근로시간', controller: _weekHoursCtrl, unit: '시간'),
          ],
        ),
        FGroup(
          title: '선택 기간 전체 초과 근무',
          children: [
            FRow(
              label: '연장근로',
              controller: _otCtrl,
              unit: '시간',
              help: () => _openHelp('ot_info'),
            ),
            FRow(
              label: '야간근로 (22시~06시)',
              controller: _nightCtrl,
              unit: '시간',
              help: () => _openHelp('nt_info'),
            ),
            FRow(
              label: '휴일근로',
              controller: _holCtrl,
              unit: '시간',
              help: () => _openHelp('hol_info'),
            ),
          ],
        ),
      ],
    );
  }

  // ---------- STEP 3 · 재직 기간 ----------
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionH4(
          title: '재직 기간을 알려주세요',
          lead: '입사일과 퇴사일을 입력해 주세요.',
          help: () => _openHelp('tenure_info'),
        ),
        FGroup(
          title: '근속 기간',
          children: [
            FDateRow(
              label: '입사일',
              value: _hireDate,
              onPick: (d) => setState(() => _hireDate = d),
            ),
            FDateRow(
              label: '퇴사일 (해당 시)',
              value: _leaveDate,
              onPick: (d) => setState(() => _leaveDate = d),
            ),
          ],
        ),
        FGroup(
          title: '결근 여부',
          children: [
            ToggleRow(
              label: '확인 기간 중 결근이 있습니다',
              value: _absent,
              onChanged: (v) => setState(() => _absent = v),
            ),
          ],
        ),
        const MoreBox(
          title: '왜 체불 기간과 재직 기간을 분리하나요?',
          child: Text(
            '2년을 일했지만 최근 3개월치 급여만 밀린 경우처럼 "다닌 기간"과 "못 받은 기간"이 다를 수 있습니다. 여기서 입력하는 재직 기간은 퇴직금 요건 산정에만 사용됩니다.',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ),
        MoreBox(
          title: '퇴직금 정밀 산정용 추가 입력 (선택)',
          help: () => _openHelp('severance_extra'),
          child: Column(
            children: [
              FRow(
                label: '최근 1년 정기상여금 총액',
                controller: _bonus1yCtrl,
                unit: '원',
              ),
              FRow(
                label: '최근 1년 미사용 연차수당',
                controller: _vacation1yCtrl,
                unit: '원',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------- STEP 4 · 세금 및 숙식비 공제 ----------
  Widget _buildStep4(WageCalcInput input) {
    final r = calcWage(input);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionH4(title: '어떻게 공제되고 있나요?', lead: '임금명세서의 공제 항목을 참고하세요.'),
        FGroup(
          title: '세금 공제 방식',
          help: () => _openHelp('tax_info'),
          children: [
            OptButton(
              icon: '🛡',
              title: '4대보험 가입',
              selected: _tax == TaxMethod.four,
              onTap: () => setState(() => _tax = TaxMethod.four),
            ),
            OptButton(
              icon: '🧾',
              title: '사업소득 3.3% 공제',
              selected: _tax == TaxMethod.biz,
              onTap: () => setState(() => _tax = TaxMethod.biz),
            ),
            OptButton(
              icon: '–',
              title: '세금 미공제 (그대로 수령)',
              selected: _tax == TaxMethod.none,
              onTap: () => setState(() => _tax = TaxMethod.none),
            ),
            OptButton(
              icon: '❓',
              title: '잘 모르겠어요',
              selected: _tax == TaxMethod.unknown,
              onTap: () => setState(() => _tax = TaxMethod.unknown),
            ),
          ],
        ),
        FGroup(
          title: '숙식비 공제',
          children: [
            ToggleRow(
              label: '숙식비를 공제하고 있습니다',
              value: _roomOn,
              onChanged: (v) => setState(() => _roomOn = v),
            ),
            if (_roomOn) ...[
              const SizedBox(height: 6),
              FRow(label: '숙식비 공제 총액', controller: _roomAmtCtrl, unit: '원'),
              const SizedBox(height: 6),
              const Text(
                '숙식 제공 형태',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Chips<RoomType>(
                options: const [
                  ('기숙사', RoomType.dorm),
                  ('원룸·주택', RoomType.studio),
                  ('식사만', RoomType.meal),
                ],
                value: _roomType,
                onChanged: (v) => setState(() => _roomType = v),
              ),
            ],
          ],
        ),
        if (r.roomBelowMin)
          RedNotice(
            title: '⚠ 숙식비를 빼면 최저임금 아래로 내려갑니다',
            body:
                '공제 후 환산 시급 ${formatWon(r.afterRoomHourly)} < 최저임금 ${formatWon(minWage().$1)}. 공제 근거와 금액을 사업주에게 서면으로 요청해 확인해 보세요.',
          ),
      ],
    );
  }

  // ---------- STEP 5 · 통장 실입금액 ----------
  Widget _buildStep5(WageCalcInput input) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionH4(
          title: '실제로 받으신 금액을 적어주세요',
          lead: '계산 결과와 실제 통장 입금액을 대조합니다.',
        ),
        MoreBox(
          title: '기간 대조 안내 (필독)',
          initiallyOpen: true,
          child: RichNote(
            '설정하신 확인 기간(총 <b>${input.periodLabel()}</b>) 동안 사업주로부터 통장으로 실제 전달받은 금액의 <b>전체 합계</b>를 입력하세요.',
          ),
        ),
        FGroup(
          title: '실입금액 합계 (${input.periodLabel()})',
          children: [
            FRow(label: '실제 받은 돈 총액', controller: _receivedCtrl, unit: '원'),
          ],
        ),
        QuickButton(
          label: '0원 (전액 미지급)',
          onTap: () => setState(() => _receivedCtrl.text = '0'),
        ),
      ],
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({
    required this.stepIndex,
    required this.totalSteps,
    required this.resultMode,
  });
  final int stepIndex;
  final int totalSteps;
  final bool resultMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.blueBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                resultMode ? 'RESULT' : 'STEP ${stepIndex + 1} / $totalSteps',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(totalSteps, (i) {
              final done = resultMode || i < stepIndex;
              final current = !resultMode && i == stepIndex;
              final color = done
                  ? AppColors.secondary
                  : (current ? AppColors.primary : AppColors.border);
              return Expanded(
                child: Container(
                  height: 3,
                  margin: EdgeInsets.only(right: i < totalSteps - 1 ? 4 : 0),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _StepFooter extends StatelessWidget {
  const _StepFooter({
    required this.resultMode,
    required this.showPrev,
    required this.nextLabel,
    required this.onPrev,
    required this.onNext,
  });

  final bool resultMode;
  final bool showPrev;
  final String nextLabel;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 11, 15, 11),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: resultMode
          ? SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onPrev,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                child: const Text(
                  '✏️ 입력값 수정하기',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
            )
          : Row(
              children: [
                if (showPrev) ...[
                  SizedBox(
                    width: 92,
                    child: OutlinedButton(
                      onPressed: onPrev,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        foregroundColor: AppColors.textSecondary,
                        side: BorderSide.none,
                        backgroundColor: const Color(0xFFF1F5F9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      child: const Text(
                        '이전',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    child: Text(
                      nextLabel,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
