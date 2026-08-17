import 'package:flutter/material.dart';
import '../../../common/widgets/rich_note.dart';
import '../../../core/app_language.dart';
import '../../../theme/app_colors.dart';
import '../models/wage_diagnosis.dart';
import 'wage_form_widgets.dart';
import 'wage_help.dart';

class _S {
  const _S(this.ko, this.en, this.zh, this.vi);
  final String ko;
  final String en;
  final String zh;
  final String vi;

  L10nText get t => L10nText(ko: ko, en: en, zh: zh, vi: vi);
  String of(AppLanguage lang) => t.of(lang);
}

const _watermark = _S(
  '⚠ 입력값 기준 추정치',
  '⚠ Estimate based on your input',
  '⚠ 基于输入值的估算值',
  '⚠ Ước tính dựa trên giá trị đã nhập',
);
const _basePay = _S('기본급', 'Base pay', '基本工资', 'Lương cơ bản');
const _weeklyAllowance = _S(
  '주휴수당',
  'Weekly paid holiday allowance',
  '周休津贴',
  'Phụ cấp ngày nghỉ có lương hàng tuần',
);
const _notApplicable = _S('해당없음', 'N/A', '不适用', 'Không áp dụng');
const _overtimeAllowance = _S(
  '연장근로수당',
  'Overtime allowance',
  '延长劳动津贴',
  'Phụ cấp làm thêm giờ',
);
const _nightAllowance = _S(
  '야간근로수당',
  'Night work allowance',
  '夜间劳动津贴',
  'Phụ cấp làm việc ban đêm',
);
const _holidayAllowance = _S(
  '휴일근로수당',
  'Holiday work allowance',
  '假日劳动津贴',
  'Phụ cấp làm việc ngày lễ',
);
const _grossTotal = _S('세전 총액', 'Total before tax', '税前总额', 'Tổng trước thuế');
const _ifFourInsurance = _S(
  '🛡 4대보험으로 공제된다면',
  '🛡 If deducted via the 4 major insurances',
  '🛡 如果按四大保险扣除',
  '🛡 Nếu khấu trừ theo 4 loại bảo hiểm',
);
const _roomDeduction = _S(
  '숙식비 공제',
  'Room & board deduction',
  '食宿费扣除',
  'Khấu trừ tiền ăn ở',
);
const _expectedNet = _S(
  '예상 실수령액',
  'Expected net pay',
  '预计实际到手金额',
  'Số tiền thực nhận dự kiến',
);
const _ifBizTax = _S(
  '🧾 3.3% 사업소득으로 공제된다면',
  '🧾 If deducted as 3.3% business income tax',
  '🧾 如果按3.3%事业所得税扣除',
  '🧾 Nếu khấu trừ 3.3% thuế thu nhập kinh doanh',
);
const _bizTaxDeduction = _S(
  '세금 공제 (사업소득세 3.3%)',
  'Tax deduction (3.3% business income tax)',
  '税款扣除（事业所得税3.3%）',
  'Khấu trừ thuế (thuế thu nhập kinh doanh 3.3%)',
);
const _belowMinTitle = _S(
  '⚠ 최저임금보다 낮습니다',
  '⚠ Below minimum wage',
  '⚠ 低于最低工资',
  '⚠ Thấp hơn lương tối thiểu',
);
const _similarAmount = _S(
  '입금액이 계산 결과와 비슷합니다',
  'The deposited amount is similar to the calculated result',
  '入账金额与计算结果相近',
  'Số tiền nhận được gần giống với kết quả tính toán',
);
const _lessThanExpected = _S(
  '받아야 할 금액보다 적게 들어왔습니다',
  'You received less than what you should have',
  '收到的金额少于应得金额',
  'Số tiền nhận được ít hơn số tiền đáng lẽ phải nhận',
);
const _moreThanCalculated = _S(
  '계산 결과보다 많이 들어왔습니다',
  'You received more than the calculated result',
  '收到的金额多于计算结果',
  'Số tiền nhận được nhiều hơn kết quả tính toán',
);
const _gapLabel = _S('차액', 'Difference', '差额', 'Chênh lệch');
const _aiDiagnosisPositive = _S(
  '🤖 왜 더 받아야 하는지 진단 보기',
  '🤖 See diagnosis on why you should receive more',
  '🤖 查看诊断：为什么应该多收到',
  '🤖 Xem chẩn đoán về lý do bạn nên nhận nhiều hơn',
);
const _aiDiagnosisNegative = _S(
  '🤖 왜 차이가 나는지 진단 보기',
  '🤖 See diagnosis on why there is a difference',
  '🤖 查看诊断：为什么会有差异',
  '🤖 Xem chẩn đoán về lý do có sự chênh lệch',
);
const _aiDiagnosisTitle = _S(
  '🤖 AI 맞춤 진단',
  '🤖 AI Custom Diagnosis',
  '🤖 AI定制诊断',
  '🤖 Chẩn đoán AI tùy chỉnh',
);
const _autoMapComplaint = _S(
  '📄 진정서에 내 기록 자동 매핑하기',
  '📄 Auto-fill my records into the complaint',
  '📄 自动将我的记录映射到申诉书',
  '📄 Tự động điền hồ sơ của tôi vào đơn tố cáo',
);
const _findNearbyOrgs = _S(
  '📍 내 근처 관할 기관 찾기',
  '📍 Find nearby authorities',
  '📍 查找我附近的管辖机构',
  '📍 Tìm cơ quan quản lý gần tôi',
);
const _severanceHeader = _S(
  '🏆 예상 퇴직금 (별도)',
  '🏆 Estimated severance pay (separate)',
  '🏆 预计退休金（另计）',
  '🏆 Trợ cấp thôi việc dự kiến (tính riêng)',
);
const _daysEmployedSuffix = _S(
  '일 재직',
  ' days employed',
  '天在职',
  ' ngày làm việc',
);
const _severanceNote = _S(
  '임금과 별개로, 퇴직할 때 한 번 받는 돈입니다.',
  'This is a one-time payment received upon resignation, separate from wages.',
  '与工资无关，是离职时一次性领取的钱。',
  'Đây là khoản tiền nhận một lần khi nghỉ việc, tách biệt với lương.',
);
const _severanceExplainTitle = _S(
  '💬 퇴직금, 왜 그리고 얼마나 받아야 하는지 보기',
  '💬 See why and how much severance pay you should receive',
  '💬 查看为什么以及应获得多少退休金',
  '💬 Xem lý do và số tiền trợ cấp thôi việc bạn nên nhận',
);
const _severanceNotEligibleTitle = _S(
  '예상 퇴직금 (현재는 요건 미충족)',
  'Estimated severance pay (requirements not yet met)',
  '预计退休金（目前不符合条件）',
  'Trợ cấp thôi việc dự kiến (hiện chưa đủ điều kiện)',
);
const _formulaDetailTitle = _S(
  '📐 법률 수식 상세보기',
  '📐 View detailed legal formulas',
  '📐 查看详细法律公式',
  '📐 Xem chi tiết công thức pháp lý',
);
const _formulaHourly = _S(
  '• 통상시급: (월급/연봉) ÷ 월 유급시간(주 40시간 기준 209시간 등)',
  '• Ordinary hourly wage: (monthly/annual pay) ÷ monthly paid hours (e.g. 209 hours for a 40-hour week)',
  '• 通常时薪：（月薪/年薪）÷ 每月有薪时间（以每周40小时为准约209小时等）',
  '• Lương giờ thông thường: (lương tháng/năm) ÷ số giờ có lương trong tháng (ví dụ 209 giờ với tuần 40 giờ)',
);
const _formulaWeekly = _S(
  '• 주휴수당: (주 소정근로시간 ÷ 40) × 8h × 통상시급 × 4.345주',
  '• Weekly paid holiday allowance: (weekly contracted hours ÷ 40) × 8h × ordinary hourly wage × 4.345 weeks',
  '• 周休津贴：（每周约定工作时间 ÷ 40）× 8小时 × 通常时薪 × 4.345周',
  '• Phụ cấp ngày nghỉ có lương hàng tuần: (giờ làm việc theo hợp đồng hàng tuần ÷ 40) × 8h × lương giờ thông thường × 4.345 tuần',
);
const _formulaExtra = _S(
  '• 가산수당: 5인 이상 사업장 연장 1.5배 · 야간 0.5배(가산분) · 휴일 1.5배',
  '• Extra pay: 1.5× overtime, 0.5× night (additional portion), 1.5× holiday at workplaces with 5+ employees',
  '• 加成津贴：5人以上企业延长劳动1.5倍·夜间0.5倍（加成部分）·假日1.5倍',
  '• Phụ cấp thêm: 1.5 lần làm thêm giờ, 0.5 lần ban đêm (phần thêm), 1.5 lần ngày lễ tại nơi có từ 5 nhân viên trở lên',
);
const _formulaSeverance = _S(
  '• 퇴직금: 1일 평균임금 × 30일 × (재직일수 ÷ 365), 평균임금이 통상임금보다 낮으면 통상임금 적용',
  '• Severance pay: average daily wage × 30 days × (days employed ÷ 365); if the average wage is lower than the ordinary wage, the ordinary wage applies',
  '• 退休金：日平均工资 × 30天 ×（在职天数 ÷ 365），若平均工资低于通常工资则适用通常工资',
  '• Trợ cấp thôi việc: lương bình quân 1 ngày × 30 ngày × (số ngày làm việc ÷ 365); nếu lương bình quân thấp hơn lương thông thường thì áp dụng lương thông thường',
);
const _legalNoticeTitle = _S(
  '⚠ 이 금액은 참고용 예상액입니다 (법적 고지)',
  '⚠ This amount is a reference estimate (legal notice)',
  '⚠ 此金额仅为参考估算值（法律声明）',
  '⚠ Số tiền này chỉ là ước tính tham khảo (thông báo pháp lý)',
);
const _legalNoticeBody = _S(
  '본 계산기는 근로기준법 표준 공식을 적용한 추정치입니다. 사업장의 특수 근로조건에 따라 차이가 발생할 수 있으며, 법적 확정 효력을 갖지 않습니다. 정확한 체불액은 근로감독관 조사에서 산정됩니다.',
  'This calculator provides an estimate based on standard Labor Standards Act formulas. Actual amounts may differ depending on the workplace\'s specific conditions, and this has no legally binding effect. The exact unpaid amount is determined through an investigation by a labor inspector.',
  '本计算器是应用《劳动基准法》标准公式得出的估算值。根据工作场所的特殊劳动条件可能会有所不同，不具有法律确定效力。准确的拖欠金额将在劳动监督官调查中确定。',
  'Máy tính này đưa ra ước tính dựa trên công thức tiêu chuẩn của Luật Tiêu chuẩn Lao động. Số tiền thực tế có thể khác nhau tùy theo điều kiện lao động đặc thù của nơi làm việc và không có hiệu lực pháp lý xác định. Số tiền nợ lương chính xác sẽ được xác định qua điều tra của thanh tra lao động.',
);

String _formatWonOrText(num value, _S zeroText, AppLanguage lang) =>
    value > 0 ? formatWon(value, lang) : zeroText.of(lang);

/// 계산 결과 카드. 프론트엔드_계산기_최종.html(v6)의 resultHTML()을 그대로 옮겼다.
class WageResultCard extends StatelessWidget {
  const WageResultCard({
    super.key,
    required this.input,
    required this.result,
    required this.language,
    required this.onOpenWageNavigator,
    required this.onFindNearbyOrgs,
  });

  final WageCalcInput input;
  final WageCalcResult result;
  final AppLanguage language;
  final VoidCallback onOpenWageNavigator;
  final VoidCallback onFindNearbyOrgs;

  void _openHelp(BuildContext context, String key) {
    final entry = buildHelpDict(language)[key];
    if (entry == null) return;
    showWageHelp(context, entry.title, entry.body(context), language);
  }

  void _openAiDiagnosis(BuildContext context) {
    showWageHelp(
      context,
      _aiDiagnosisTitle.of(language),
      RichNote(
        explainGap(input, result, language),
        style: const TextStyle(
          fontSize: 11.5,
          color: AppColors.textSecondary,
          height: 1.7,
        ),
      ),
      language,
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = language;
    final r = result;
    final gapVal = r.gapValue;
    final isZero = gapVal.abs() < 10000;
    final isPos = !isZero && gapVal > 0;
    final isNeg = !isZero && gapVal < 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 데모 워터마크
        Container(
          margin: const EdgeInsets.only(bottom: 9),
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _watermark.of(lang),
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0D47A1),
            ),
          ),
        ),

        // 항목별 산출 내역 (짙은 네이비 카드)
        Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(bottom: 11),
          decoration: BoxDecoration(
            color: const Color(0xFF0D47A1),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${_resultTitle(lang)} (${input.periodLabel(lang)})',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF90CAF9),
                      ),
                    ),
                  ),
                  Text(
                    _noticeYearText(lang),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF90CAF9),
                    ),
                  ),
                ],
              ),
              const Divider(height: 18, color: Color(0x17FFFFFF)),
              _ResRow(
                label: _basePay.of(lang),
                value: formatWon(r.baseTotal, lang),
                onHelp: () => _openHelp(context, 'logic_base'),
              ),
              if (!r.weeklyIncluded)
                _ResRow(
                  label: _weeklyAllowance.of(lang),
                  value: _formatWonOrText(
                    r.weeklyPayTotal,
                    _notApplicable,
                    lang,
                  ),
                  zero: r.weeklyPayTotal <= 0,
                  onHelp: () => _openHelp(context, 'logic_week'),
                ),
              _ResRow(
                label: _overtimeAllowance.of(lang),
                value: r.otPay > 0
                    ? formatWon(r.otPay, lang)
                    : formatWon(0, lang),
                zero: r.otPay <= 0,
                onHelp: () => _openHelp(context, 'ot_info'),
              ),
              _ResRow(
                label: _nightAllowance.of(lang),
                value: r.ntPay > 0
                    ? formatWon(r.ntPay, lang)
                    : formatWon(0, lang),
                zero: r.ntPay <= 0,
                onHelp: () => _openHelp(context, 'nt_info'),
              ),
              if (r.holPay > 0)
                _ResRow(
                  label: _holidayAllowance.of(lang),
                  value: formatWon(r.holPay, lang),
                  onHelp: () => _openHelp(context, 'hol_info'),
                ),

              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 8),
                padding: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0x5990CAF9))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Row(
                      children: [
                        Text(
                          _grossTotal.of(lang),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF90CAF9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        _DarkQMark(
                          onTap: () => _openHelp(context, 'logic_gross'),
                        ),
                      ],
                    ),
                    Text(
                      formatWon(r.gross, lang),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              if (input.tax == TaxMethod.unknown) ...[
                _SubHead(_ifFourInsurance.of(lang)),
                _ResRow(
                  label: taxLabelOf(TaxMethod.four, insuranceRate(), lang),
                  value: '− ${formatWon(r.taxAmtFour!, lang)}',
                  onHelp: () => _openHelp(context, 'tax_info'),
                ),
                if (input.roomOn)
                  _ResRow(
                    label: _roomDeduction.of(lang),
                    value: '− ${formatWon(r.roomAmtTotal, lang)}',
                  ),
                _NetRow(
                  label: _expectedNet.of(lang),
                  value: formatWon(r.netFour!, lang),
                ),
                _SubHead(_ifBizTax.of(lang)),
                _ResRow(
                  label: _bizTaxDeduction.of(lang),
                  value: '− ${formatWon(r.taxAmtBiz!, lang)}',
                ),
                if (input.roomOn)
                  _ResRow(
                    label: _roomDeduction.of(lang),
                    value: '− ${formatWon(r.roomAmtTotal, lang)}',
                  ),
                _NetRow(
                  label: _expectedNet.of(lang),
                  value: formatWon(r.netBiz!, lang),
                ),
              ] else ...[
                _ResRow(
                  label: taxLabelOf(input.tax, r.taxRate, lang),
                  value: r.taxAmt! > 0
                      ? '− ${formatWon(r.taxAmt!, lang)}'
                      : formatWon(0, lang),
                  zero: r.taxAmt! <= 0,
                  onHelp: () => _openHelp(context, 'tax_info'),
                ),
                _ResRow(
                  label: _roomDeduction.of(lang),
                  value: r.roomAmtTotal > 0
                      ? '− ${formatWon(r.roomAmtTotal, lang)}'
                      : formatWon(0, lang),
                  zero: r.roomAmtTotal <= 0,
                ),
                _NetRow(
                  label: _expectedNet.of(lang),
                  value: formatWon(r.net!, lang),
                  onHelp: () => _openHelp(context, 'logic_net'),
                ),
              ],
            ],
          ),
        ),

        if (r.payBelowMin)
          RedNotice(
            title: _belowMinTitle.of(lang),
            body: _payBelowMinBody(r, lang),
          ),

        // 차액 카드 + AI 진단
        Container(
          margin: const EdgeInsets.only(bottom: 11),
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: isZero
                ? const Color(0xFFE8F5E9)
                : isNeg
                ? const Color(0xFFE3F2FD)
                : const Color(0xFFE3F2FD),
            border: Border.all(
              color: isZero
                  ? const Color(0xFFA5D6A7)
                  : isNeg
                  ? const Color(0xFF90CAF9)
                  : const Color(0xFF90CAF9),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isZero
                    ? _similarAmount.of(lang)
                    : (isPos
                          ? _lessThanExpected.of(lang)
                          : _moreThanCalculated.of(lang)),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: isZero
                      ? const Color(0xFF1B5E20)
                      : isNeg
                      ? const Color(0xFF0D47A1)
                      : const Color(0xFF0D47A1),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _gapLabel.of(lang),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    isZero
                        ? '±${formatWon(0, lang)}'
                        : '${gapVal > 0 ? '+' : '−'}${formatWon(gapVal.abs(), lang)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isZero
                          ? const Color(0xFF1B5E20)
                          : isNeg
                          ? const Color(0xFF0D47A1)
                          : const Color(0xFF0D47A1),
                    ),
                  ),
                ],
              ),
              if (!isZero) ...[
                const SizedBox(height: 9),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _openAiDiagnosis(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.7),
                      foregroundColor: isNeg
                          ? const Color(0xFF0D47A1)
                          : const Color(0xFF0D47A1),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: Text(
                      isPos
                          ? _aiDiagnosisPositive.of(lang)
                          : _aiDiagnosisNegative.of(lang),
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        // 체불 의심일 때만 다음 행동 유도(이 앱은 진정 내비게이터·기관 조회가 실제로
        // 연동되어 있어, v6 원본의 "연동 예정" 비활성 버튼 대신 바로 동작하게 한다).
        if (isPos) ...[
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onOpenWageNavigator,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                  child: Text(
                    _autoMapComplaint.of(lang),
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: onFindNearbyOrgs,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                  child: Text(
                    _findNearbyOrgs.of(lang),
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
        ],

        // 퇴직금
        if (r.eligible) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              border: Border.all(color: const Color(0xFFA5D6A7)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              '${_severanceHeader.of(lang)} · ${r.days}${_daysEmployedSuffix.of(lang)}',
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1B5E20),
                              ),
                            ),
                          ),
                          QMark(
                            onTap: () => _openHelp(context, 'severance_intro'),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      formatWon(r.severance, lang),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _severanceNote.of(lang),
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF1B5E20),
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
          MoreBox(
            title: _severanceExplainTitle.of(lang),
            child: RichNote(severanceNarrative(input, result, lang)),
          ),
        ] else if (input.hireDate != null) ...[
          MoreBox(
            title: _severanceNotEligibleTitle.of(lang),
            child: RichNote(severanceNarrative(input, result, lang)),
          ),
        ],

        // 법률 수식 상세
        MoreBox(
          title: _formulaDetailTitle.of(lang),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formulaHourly.of(lang),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _formulaWeekly.of(lang),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _formulaExtra.of(lang),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _formulaTaxText(lang),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _formulaSeverance.of(lang),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),

        // 법적 고지
        MoreBox(
          title: _legalNoticeTitle.of(lang),
          child: Text(
            _legalNoticeBody.of(lang),
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  String _resultTitle(AppLanguage lang) => switch (lang) {
    AppLanguage.ko => '계산 결과',
    AppLanguage.en => 'Calculation result',
    AppLanguage.zh => '计算结果',
    AppLanguage.vi => 'Kết quả tính toán',
  };

  String _noticeYearText(AppLanguage lang) => switch (lang) {
    AppLanguage.ko => '$wageCalcYear년 고시',
    AppLanguage.en => '$wageCalcYear notice',
    AppLanguage.zh => '$wageCalcYear年公告',
    AppLanguage.vi => 'Công bố năm $wageCalcYear',
  };

  String _payBelowMinBody(WageCalcResult r, AppLanguage lang) {
    final hourly = formatWon(r.hourly, lang);
    final mw = formatWon(minWage().$1, lang);
    return switch (lang) {
      AppLanguage.ko => '적용 통상시급 $hourly이 $wageCalcYear년 최저임금 $mw에 미달합니다.',
      AppLanguage.en =>
        'The applied ordinary hourly wage of $hourly is below the $wageCalcYear minimum wage of $mw.',
      AppLanguage.zh => '适用的通常时薪 $hourly 低于 $wageCalcYear 年最低工资 $mw。',
      AppLanguage.vi =>
        'Lương giờ thông thường áp dụng $hourly thấp hơn lương tối thiểu năm $wageCalcYear là $mw.',
    };
  }

  String _formulaTaxText(AppLanguage lang) {
    final pct = (insuranceRate() * 100).toStringAsFixed(2);
    return switch (lang) {
      AppLanguage.ko => '• 세금: 4대보험 근로자부담 약 $pct% 또는 사업소득세 3.3%',
      AppLanguage.en =>
        '• Tax: about $pct% employee share of the 4 major insurances, or 3.3% business income tax',
      AppLanguage.zh => '• 税款：四大保险员工负担约$pct%，或事业所得税3.3%',
      AppLanguage.vi =>
        '• Thuế: khoảng $pct% phần người lao động đóng trong 4 loại bảo hiểm, hoặc thuế thu nhập kinh doanh 3.3%',
    };
  }
}

class _ResRow extends StatelessWidget {
  const _ResRow({
    required this.label,
    required this.value,
    this.zero = false,
    this.onHelp,
  });
  final String label;
  final String value;
  final bool zero;
  final VoidCallback? onHelp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF90CAF9),
                ),
              ),
              if (onHelp != null) _DarkQMark(onTap: onHelp!),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: zero ? 11 : 12.5,
              fontWeight: zero ? FontWeight.w600 : FontWeight.w700,
              color: zero ? const Color(0xFF90CAF9) : const Color(0xFFE3F2FD),
            ),
          ),
        ],
      ),
    );
  }
}

class _NetRow extends StatelessWidget {
  const _NetRow({required this.label, required this.value, this.onHelp});
  final String label;
  final String value;
  final VoidCallback? onHelp;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 2),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0x5990CAF9), style: BorderStyle.solid),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF90CAF9),
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (onHelp != null) _DarkQMark(onTap: onHelp!),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16.5,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SubHead extends StatelessWidget {
  const _SubHead(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 2),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          color: Color(0xFF90CAF9),
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _DarkQMark extends StatelessWidget {
  const _DarkQMark({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 15,
          height: 15,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0x26FFFFFF),
            shape: BoxShape.circle,
          ),
          child: const Text(
            '?',
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF90CAF9),
            ),
          ),
        ),
      ),
    );
  }
}
