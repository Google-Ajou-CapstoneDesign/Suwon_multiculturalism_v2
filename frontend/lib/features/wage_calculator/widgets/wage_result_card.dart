import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../models/wage_diagnosis.dart';

/// 계산 결과 카드. 프론트엔드_계산기.html의 calcAndRender() 결과 렌더링을 그대로 옮겼다.
class WageResultCard extends StatelessWidget {
  const WageResultCard({
    super.key,
    required this.input,
    required this.result,
    required this.onOpenWageNavigator,
    required this.onFindNearbyOrgs,
  });

  final WageDiagnosisInput input;
  final WageDiagnosisResult result;
  final VoidCallback onOpenWageNavigator;
  final VoidCallback onFindNearbyOrgs;

  bool get _isWeek => input.checkPeriod == CheckPeriod.thisPeriod && input.monthScope == MonthScope.week;

  @override
  Widget build(BuildContext context) {
    final eduTips = <String>[
      if (!result.weeklyIncludedInBase && result.weeklyHolidayPay > 0)
        '💡 주휴수당 받는 거 아셨나요? 1주 15시간 이상 일하고 결근이 없으면, 쉬는 날에도 하루치 임금을 추가로 받을 수 있어요. (근로기준법 제55조)',
      if (result.overtimePay > 0) '💡 연장수당 받는 거 아셨나요? 하루 8시간이나 주 40시간을 넘겨 일하면, 초과한 시간은 시급의 1.5배(5인 이상 사업장)를 받을 수 있어요. (근로기준법 제56조)',
      if (result.nightPay > 0) '💡 야간수당 받는 거 아셨나요? 밤 10시부터 새벽 6시 사이에 일하면, 그 시간만큼 시급의 50%를 추가로 받을 수 있어요. (근로기준법 제56조)',
      if (result.holidayPay > 0) '💡 휴일수당 받는 거 아셨나요? 주휴일이나 정해진 휴일에 일하면 시급의 1.5배(8시간을 넘는 부분은 2배)를 받을 수 있어요. (근로기준법 제56조)',
      if (result.severanceEligible)
        '💡 퇴직금 받을 수 있는 거 아셨나요? 한 사업장에서 1년 이상, 주 평균 15시간 이상 일했다면 그만둘 때 퇴직금을 받을 권리가 있어요. (근로자퇴직급여 보장법 제8조)',
    ];

    final mainNet = input.taxType == TaxType.unknown ? result.netOf(result.taxScenarios['ssi']!) : result.netOf(result.taxScenarios['main']!);

    late final Widget gapSection;
    late final bool isPos;
    if (input.checkPeriod == CheckPeriod.unpaidLong) {
      final months = input.unpaidMonths > 0 ? input.unpaidMonths : 1.0;
      final believed = input.believedTotalAmount;
      final receivedTotal = input.receivedTotalAmount;
      final legalTotal = mainNet * months;
      final gap = legalTotal - receivedTotal;
      isPos = gap > 10000;
      gapSection = _ArrearsGapSection(months: months, legalTotal: legalTotal, believed: believed, receivedTotal: receivedTotal, gap: gap, isPos: isPos);
    } else {
      final received = input.receivedAmount;
      final gap = mainNet - received;
      final kind = gap.abs() < 10000 ? _GapKind.zero : (gap > 0 ? _GapKind.pos : _GapKind.neg);
      isPos = kind == _GapKind.pos;
      gapSection = _SinglePeriodGapSection(legalNet: mainNet, received: received, gap: gap, kind: kind);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 항목별 산출 내역
        _SectionBox(
          title: _isWeek ? '📊 이번 주 항목별 산출 내역' : '📊 이번 달 항목별 산출 내역',
          child: Column(
            children: [
              _ResultRow(
                label: '기본급',
                value: formatWon(result.basePay),
                sub: input.contractType == ContractType.hourly
                    ? '${formatWon(result.hourlyRate)} × ${result.monthlyStandardHours.toStringAsFixed(1)}h'
                    : null,
              ),
              if (result.weeklyIncludedInBase)
                const _ResultRow(label: '주휴수당', value: '월급에 포함됨')
              else if (!result.over15HoursPerWeek)
                const _ResultRow(label: '주휴수당', value: '0원', sub: '주 15시간 미만')
              else if (input.absentThisMonth)
                const _ResultRow(label: '주휴수당', value: '0원', sub: '이번 달 결근이 있어요')
              else
                _ResultRow(label: '주휴수당', value: formatWon(result.weeklyHolidayPay)),
              if (result.overtimeHours > 0)
                _ResultRow(label: '연장근로수당', value: formatWon(result.overtimePay), sub: '${result.over5 ? "1.5×" : "1.0×"} · ${result.overtimeHours}h'),
              if (result.nightHours > 0)
                _ResultRow(label: '야간근로 가산', value: formatWon(result.nightPay), sub: '${result.over5 ? "+0.5×" : "+0×"} · ${result.nightHours}h'),
              if (result.holidayHours > 0)
                _ResultRow(label: '휴일근로수당', value: formatWon(result.holidayPay), sub: '${result.over5 ? "1.5~2.0×" : "1.0×"} · ${result.holidayHours}h'),
              const Divider(height: 18),
              _ResultRow(label: '세전 총액', value: formatWon(result.grossTotal), bold: true),
            ],
          ),
        ),

        // 2. 교육 팁
        for (final tip in eduTips) _EduTip(text: tip),

        // 3. 최저임금 경고
        if (result.isBelowMinWage)
          _WarningBox(
            title: '⚠ 계약된 시급이 최저임금보다 낮아요 (${formatWon(result.hourlyRate)} < ${formatWon(minimumWage)})',
            body: '최저임금에 못 미치는 부분은 무효이고 차액을 청구할 수 있습니다.',
          ),
        if (result.isBelowMinWageAfterRoom)
          _WarningBox(
            title: '⚠ 숙식비를 뺀 뒤 최저임금 아래로 내려가요 (${formatWon(result.hourlyAfterRoomDeduction)} < ${formatWon(minimumWage)})',
            body: '숙식비 공제 근거와 금액을 사업주에게 서면으로 요청해 확인해보세요.',
          ),

        // 4. 세금/실수령액
        _SectionBox(
          title: input.taxType == TaxType.unknown ? '💳 공제 방식을 몰라서 두 가지로 계산했어요' : '💳 공제 후 예상 실수령액',
          child: input.taxType == TaxType.unknown
              ? Column(
                  children: [
                    _ResultRow(label: '4대보험(약 9.7%) 가정', value: formatWon(result.netOf(result.taxScenarios['ssi']!))),
                    _ResultRow(label: '3.3% 사업소득세 가정', value: formatWon(result.netOf(result.taxScenarios['biz']!))),
                  ],
                )
              : Column(
                  children: [
                    _ResultRow(
                      label: '세금 공제',
                      value: result.taxScenarios['main']!.amount > 0 ? '− ${formatWon(result.taxScenarios['main']!.amount)}' : '0원',
                      sub: '${(result.taxScenarios['main']!.rate * 100).toStringAsFixed(2)}%',
                    ),
                    if (result.roomAmount > 0) _ResultRow(label: '숙식비 공제', value: '− ${formatWon(result.roomAmount)}'),
                    const Divider(height: 18),
                    _ResultRow(label: '예상 실수령액', value: formatWon(result.netOf(result.taxScenarios['main']!)), bold: true, valueColor: AppColors.primary, big: true),
                  ],
                ),
        ),

        // 5. 체불 괴리 분석
        gapSection,
        if (isPos) ...[
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onOpenWageNavigator,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 11)),
                  child: const Text('📄 진정서에 내 기록 자동 매핑하기', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: onFindNearbyOrgs,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 11)),
                  child: const Text('📍 내 근처 관할 기관 찾기', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ],

        // 6. 퇴직금
        if (result.severanceEligible) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.blueBg, border: Border.all(color: AppColors.blueBorder), borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text('예상 퇴직금 · ${result.tenureDays.round()}일 재직', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ),
                    Text(formatWon(result.severancePay), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('평균임금과 통상임금 중 큰 값을 적용한 참고용 추정치예요.', style: TextStyle(fontSize: 10.5, color: AppColors.textMuted)),
              ],
            ),
          ),
        ],

        // 7. 소멸시효 안내
        if (isPos) ...[
          const SizedBox(height: 12),
          Builder(builder: (context) {
            final today = DateTime.now();
            final cutoff = DateTime(today.year - 3, today.month, today.day);
            String fmt(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
            return Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(color: const Color(0xFFFFF8EC), border: Border.all(color: const Color(0xFFFCD9A8)), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('⏳ 임금채권 소멸시효', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF92400E))),
                  const SizedBox(height: 5),
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF92400E), height: 1.6),
                      children: [
                        const TextSpan(text: '임금채권의 소멸시효는 근로기준법 제49조에 따라 3년입니다. 오늘('),
                        TextSpan(text: fmt(today)),
                        const TextSpan(text: ') 기준으로, '),
                        TextSpan(text: fmt(cutoff), style: const TextStyle(fontWeight: FontWeight.w800)),
                        const TextSpan(text: ' 이전에 발생한 임금은 시효가 지나 청구가 어려울 수 있고, 그 이후분만 청구할 수 있습니다.'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],

        // 8. 법적 안전 고지
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: AppColors.background, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(12)),
          child: const Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 10.5, color: AppColors.textMuted, height: 1.6),
              children: [
                TextSpan(text: '⚠️ '),
                TextSpan(text: '[법적 안전 고지] ', style: TextStyle(fontWeight: FontWeight.w700)),
                TextSpan(
                  text: '이 결과는 입력하신 사실관계를 바탕으로 근로기준법 기본 공식을 적용한 참고용 추정치이며, 확정된 임금액이나 법적 승소를 보장하지 않습니다. '
                      '정확한 체불액은 고용노동부 조사 과정에서 확정됩니다.',
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

enum _GapKind { pos, neg, zero }

class _SinglePeriodGapSection extends StatelessWidget {
  const _SinglePeriodGapSection({required this.legalNet, required this.received, required this.gap, required this.kind});
  final double legalNet;
  final double received;
  final double gap;
  final _GapKind kind;

  @override
  Widget build(BuildContext context) {
    final (bg, border, diffColor) = switch (kind) {
      _GapKind.pos => (const Color(0xFFFEF2F2), const Color(0xFFFECACA), const Color(0xFFDC2626)),
      _GapKind.neg => (const Color(0xFFEFF6FF), const Color(0xFFBFDBFE), AppColors.primary),
      _GapKind.zero => (AppColors.blueBg.withValues(alpha: 0.4), AppColors.border, AppColors.textSecondary),
    };
    final note = switch (kind) {
      _GapKind.pos => '계산된 예상 수령액보다 실제로 적게 받으셨어요. 근로기준법 제43조(임금 전액 지급 원칙)에 비추어 확인이 필요할 수 있습니다.',
      _GapKind.neg => '이 경우는 체불이 아니라 계산 방식의 차이일 가능성이 높아요. 포괄임금제로 수당이 미리 합산되어 있거나, 상여금·식대·교통비가 함께 지급되었을 수 있어요. 임금명세서의 항목 구성을 확인해보세요.',
      _GapKind.zero => '계산 결과와 실제 입금액이 거의 같아요.',
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: bg, border: Border.all(color: border), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(alignment: Alignment.centerLeft, child: _GapBadge(kind: kind)),
          const SizedBox(height: 8),
          _ResultRow(label: '법정 예상 실수령액', value: formatWon(legalNet)),
          _ResultRow(label: '실제 입금액', value: formatWon(received)),
          const Divider(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('차액', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
              Text('${gap >= 0 ? '+' : '−'}${formatWon(gap.abs())}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: diffColor)),
            ],
          ),
          const SizedBox(height: 8),
          Text(note, style: const TextStyle(fontSize: 11, color: Color(0xFF334155), height: 1.6)),
        ],
      ),
    );
  }
}

class _ArrearsGapSection extends StatelessWidget {
  const _ArrearsGapSection({required this.months, required this.legalTotal, required this.believed, required this.receivedTotal, required this.gap, required this.isPos});
  final double months;
  final double legalTotal;
  final double believed;
  final double receivedTotal;
  final double gap;
  final bool isPos;

  @override
  Widget build(BuildContext context) {
    final bg = isPos ? const Color(0xFFFEF2F2) : AppColors.blueBg.withValues(alpha: 0.4);
    final border = isPos ? const Color(0xFFFECACA) : AppColors.border;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: bg, border: Border.all(color: border), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _GapBadge(kind: isPos ? _GapKind.pos : _GapKind.zero),
              Text('${months.toStringAsFixed(0)}개월 누적 · 근사치', style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted)),
            ],
          ),
          const SizedBox(height: 8),
          _ResultRow(label: '법정 예상 총액', value: formatWon(legalTotal)),
          _ResultRow(label: '본인이 알던 총액', value: formatWon(believed)),
          _ResultRow(label: '실제 받은 총액', value: formatWon(receivedTotal)),
          const Divider(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('법정 총액 − 실제 받은 총액', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
              Text('${gap >= 0 ? '+' : ''}${formatWon(gap)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFFDC2626))),
            ],
          ),
          if (isPos) ...[
            const SizedBox(height: 8),
            const Text(
              '법정 기준 예상 수령액과 실제 받은 금액 사이에 차이가 있어요. 정확한 체불액은 근로감독관 조사에서 산정되니, 아래 버튼으로 사실관계부터 정리해보세요.',
              style: TextStyle(fontSize: 11, color: Color(0xFF92400E), height: 1.6),
            ),
          ],
        ],
      ),
    );
  }
}

class _GapBadge extends StatelessWidget {
  const _GapBadge({required this.kind});
  final _GapKind kind;

  @override
  Widget build(BuildContext context) {
    final isBad = kind == _GapKind.pos;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(color: isBad ? const Color(0xFFDC2626) : AppColors.secondary, borderRadius: BorderRadius.circular(20)),
      child: Text(
        isBad ? '🚨 임금체불(괴리) 의심' : '정상 지급 범위',
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
      ),
    );
  }
}

class _SectionBox extends StatelessWidget {
  const _SectionBox({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.background, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value, this.sub, this.bold = false, this.valueColor, this.big = false});
  final String label;
  final String value;
  final String? sub;
  final bool bold;
  final Color? valueColor;
  final bool big;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Row(
            children: [
              Text(label, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
              if (sub != null) ...[const SizedBox(width: 5), Text(sub!, style: const TextStyle(fontSize: 10, color: AppColors.textMuted))],
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: big ? 17 : 13,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _EduTip extends StatelessWidget {
  const _EduTip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(color: AppColors.blueBg, border: Border(left: BorderSide(color: AppColors.primary, width: 3))),
      child: Text(text, style: const TextStyle(fontSize: 11.5, color: Color(0xFF1E3A8A), height: 1.6)),
    );
  }
}

class _WarningBox extends StatelessWidget {
  const _WarningBox({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(color: const Color(0xFFFEF2F2), border: Border.all(color: const Color(0xFFFECACA)), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF991B1B))),
          const SizedBox(height: 4),
          Text(body, style: const TextStyle(fontSize: 11, color: Color(0xFF991B1B), height: 1.6)),
        ],
      ),
    );
  }
}
