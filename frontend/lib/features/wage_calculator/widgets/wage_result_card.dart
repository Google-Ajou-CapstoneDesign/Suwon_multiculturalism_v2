import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../models/wage_diagnosis.dart';
import 'wage_form_widgets.dart';
import 'wage_help.dart';

/// 계산 결과 카드. 프론트엔드_계산기_최종.html(v6)의 resultHTML()을 그대로 옮겼다.
class WageResultCard extends StatelessWidget {
  const WageResultCard({
    super.key,
    required this.input,
    required this.result,
    required this.onOpenWageNavigator,
    required this.onFindNearbyOrgs,
  });

  final WageCalcInput input;
  final WageCalcResult result;
  final VoidCallback onOpenWageNavigator;
  final VoidCallback onFindNearbyOrgs;

  void _openHelp(BuildContext context, String key) {
    final entry = buildHelpDict()[key];
    if (entry == null) return;
    showWageHelp(context, entry.title, entry.body(context));
  }

  void _openAiDiagnosis(BuildContext context) {
    showWageHelp(
      context,
      '🤖 AI 맞춤 진단',
      RichNote(
        explainGap(input, result),
        style: const TextStyle(
          fontSize: 11.5,
          color: AppColors.textSecondary,
          height: 1.7,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            color: const Color(0xFFFEF3E2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            '⚠ 입력값 기준 추정치',
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFFB45309),
            ),
          ),
        ),

        // 항목별 산출 내역 (짙은 네이비 카드)
        Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(bottom: 11),
          decoration: BoxDecoration(
            color: const Color(0xFF0F2947),
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
                      '계산 결과 (${input.periodLabel()})',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFE8C88A),
                      ),
                    ),
                  ),
                  Text(
                    '$wageCalcYear년 고시',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF8FA9CC),
                    ),
                  ),
                ],
              ),
              const Divider(height: 18, color: Color(0x17FFFFFF)),
              _ResRow(
                label: '기본급',
                value: formatWon(r.baseTotal),
                onHelp: () => _openHelp(context, 'logic_base'),
              ),
              if (!r.weeklyIncluded)
                _ResRow(
                  label: '주휴수당',
                  value: r.weeklyPayTotal > 0
                      ? formatWon(r.weeklyPayTotal)
                      : '해당없음',
                  zero: r.weeklyPayTotal <= 0,
                  onHelp: () => _openHelp(context, 'logic_week'),
                ),
              _ResRow(
                label: '연장근로수당',
                value: r.otPay > 0 ? formatWon(r.otPay) : '0원',
                zero: r.otPay <= 0,
                onHelp: () => _openHelp(context, 'ot_info'),
              ),
              _ResRow(
                label: '야간근로수당',
                value: r.ntPay > 0 ? formatWon(r.ntPay) : '0원',
                zero: r.ntPay <= 0,
                onHelp: () => _openHelp(context, 'nt_info'),
              ),
              if (r.holPay > 0)
                _ResRow(
                  label: '휴일근로수당',
                  value: formatWon(r.holPay),
                  onHelp: () => _openHelp(context, 'hol_info'),
                ),

              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 8),
                padding: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0x59E8C88A))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '세전 총액',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFE8C88A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        _DarkQMark(
                          onTap: () => _openHelp(context, 'logic_gross'),
                        ),
                      ],
                    ),
                    Text(
                      formatWon(r.gross),
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
                const _SubHead('🛡 4대보험으로 공제된다면'),
                _ResRow(
                  label: taxLabelOf(TaxMethod.four, insuranceRate()),
                  value: '− ${formatWon(r.taxAmtFour!)}',
                  onHelp: () => _openHelp(context, 'tax_info'),
                ),
                if (input.roomOn)
                  _ResRow(
                    label: '숙식비 공제',
                    value: '− ${formatWon(r.roomAmtTotal)}',
                  ),
                _NetRow(label: '예상 실수령액', value: formatWon(r.netFour!)),
                const _SubHead('🧾 3.3% 사업소득으로 공제된다면'),
                _ResRow(
                  label: '세금 공제 (사업소득세 3.3%)',
                  value: '− ${formatWon(r.taxAmtBiz!)}',
                ),
                if (input.roomOn)
                  _ResRow(
                    label: '숙식비 공제',
                    value: '− ${formatWon(r.roomAmtTotal)}',
                  ),
                _NetRow(label: '예상 실수령액', value: formatWon(r.netBiz!)),
              ] else ...[
                _ResRow(
                  label: taxLabelOf(input.tax, r.taxRate),
                  value: r.taxAmt! > 0 ? '− ${formatWon(r.taxAmt!)}' : '0원',
                  zero: r.taxAmt! <= 0,
                  onHelp: () => _openHelp(context, 'tax_info'),
                ),
                _ResRow(
                  label: '숙식비 공제',
                  value: r.roomAmtTotal > 0
                      ? '− ${formatWon(r.roomAmtTotal)}'
                      : '0원',
                  zero: r.roomAmtTotal <= 0,
                ),
                _NetRow(
                  label: '예상 실수령액',
                  value: formatWon(r.net!),
                  onHelp: () => _openHelp(context, 'logic_net'),
                ),
              ],
            ],
          ),
        ),

        if (r.payBelowMin)
          RedNotice(
            title: '⚠ 최저임금보다 낮습니다',
            body:
                '적용 통상시급 ${formatWon(r.hourly)}이 $wageCalcYear년 최저임금 ${formatWon(minWage().$1)}에 미달합니다.',
          ),

        // 차액 카드 + AI 진단
        Container(
          margin: const EdgeInsets.only(bottom: 11),
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: isZero
                ? const Color(0xFFEAF7F5)
                : isNeg
                ? const Color(0xFFF0F5FF)
                : const Color(0xFFFEF2F2),
            border: Border.all(
              color: isZero
                  ? const Color(0xFFB4E0D9)
                  : isNeg
                  ? const Color(0xFFC9DBFA)
                  : const Color(0xFFF6C9C9),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isZero
                    ? '입금액이 계산 결과와 비슷합니다'
                    : (isPos ? '받아야 할 금액보다 적게 들어왔습니다' : '계산 결과보다 많이 들어왔습니다'),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: isZero
                      ? const Color(0xFF0B7267)
                      : isNeg
                      ? const Color(0xFF1E3A8A)
                      : const Color(0xFF991B1B),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '차액',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    isZero
                        ? '±0원'
                        : '${gapVal > 0 ? '+' : '−'}${formatWon(gapVal.abs())}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isZero
                          ? const Color(0xFF0B7267)
                          : isNeg
                          ? const Color(0xFF1E3A8A)
                          : const Color(0xFF991B1B),
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
                          ? const Color(0xFF1E3A8A)
                          : const Color(0xFF991B1B),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: Text(
                      isPos
                          ? '🤖 왜 더 받아야 하는지 AI 진단 보기'
                          : '🤖 왜 차이가 나는지 AI 진단 보기',
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
                  child: const Text(
                    '📄 진정서에 내 기록 자동 매핑하기',
                    style: TextStyle(
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
                  child: const Text(
                    '📍 내 근처 관할 기관 찾기',
                    style: TextStyle(
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
              color: const Color(0xFFEAF7F5),
              border: Border.all(color: const Color(0xFFB4E0D9)),
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
                              '🏆 예상 퇴직금 (별도) · ${r.days}일 재직',
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0B7267),
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
                      formatWon(r.severance),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0B7267),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  '임금과 별개로, 퇴직할 때 한 번 받는 돈입니다.',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF0F766E),
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
          MoreBox(
            title: '💬 퇴직금, 왜 그리고 얼마나 받아야 하는지 보기',
            child: RichNote(severanceNarrative(input, result)),
          ),
        ] else if (input.hireDate != null) ...[
          MoreBox(
            title: '예상 퇴직금 (현재는 요건 미충족)',
            child: RichNote(severanceNarrative(input, result)),
          ),
        ],

        // 법률 수식 상세
        MoreBox(
          title: '📐 법률 수식 상세보기',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '• 통상시급: (월급/연봉) ÷ 월 유급시간(주 40시간 기준 209시간 등)',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                '• 주휴수당: (주 소정근로시간 ÷ 40) × 8h × 통상시급 × 4.345주',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                '• 가산수당: 5인 이상 사업장 연장 1.5배 · 야간 0.5배(가산분) · 휴일 1.5배',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '• 세금: 4대보험 근로자부담 약 ${(insuranceRate() * 100).toStringAsFixed(2)}% 또는 사업소득세 3.3%',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                '• 퇴직금: 1일 평균임금 × 30일 × (재직일수 ÷ 365), 평균임금이 통상임금보다 낮으면 통상임금 적용',
                style: TextStyle(
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
          title: '⚠ 이 금액은 참고용 예상액입니다 (법적 고지)',
          child: const Text(
            '본 계산기는 근로기준법 표준 공식을 적용한 추정치입니다. 사업장의 특수 근로조건에 따라 차이가 발생할 수 있으며, 법적 확정 효력을 갖지 않습니다. '
            '정확한 체불액은 근로감독관 조사에서 산정됩니다.',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
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
                  color: Color(0xFFA8BEDC),
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
              color: zero ? const Color(0xFF6D86AC) : const Color(0xFFF1F6FC),
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
          top: BorderSide(color: Color(0x59E8C88A), style: BorderStyle.solid),
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
                  color: Color(0xFFE8C88A),
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
          color: Color(0xFFE8C88A),
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
              color: Color(0xFFA8BEDC),
            ),
          ),
        ),
      ),
    );
  }
}
