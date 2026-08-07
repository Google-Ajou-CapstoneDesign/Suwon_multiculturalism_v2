import 'package:flutter/material.dart';
import '../../../common/widgets/app_card.dart';
import '../../../common/widgets/disclaimer_banner.dart';
import '../../../theme/app_colors.dart';
import '../models/wage_calculation.dart';

/// 임금계산기. 계산 결과는 참고용 예상액일 뿐, 체불 진정서(WageNavigatorScreen)로
/// 자동으로 넘어가지 않는다 — 스스로 확인하는 계산과, 다툼 있는 체불액을 서류에
/// 확정해 넣는 행위는 법적 성격이 다르기 때문(프론트엔드_구상_확장.html 설계 노트).
class WageCalculatorScreen extends StatefulWidget {
  const WageCalculatorScreen({super.key});

  @override
  State<WageCalculatorScreen> createState() => _WageCalculatorScreenState();
}

class _WageCalculatorScreenState extends State<WageCalculatorScreen> {
  WageInputs _inputs = const WageInputs();

  late final _hourlyWageController = TextEditingController(text: '${_inputs.hourlyWage}');

  void _applyMinimumWage() {
    setState(() => _inputs = _inputs.copyWith(hourlyWage: 10320));
    _hourlyWageController.text = '10320';
  }

  @override
  void dispose() {
    _hourlyWageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = calculateWage(_inputs);

    return Scaffold(
      appBar: AppBar(title: const Text('내 임금 계산기')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'MODULE · WAGE',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 1),
          ),
          const SizedBox(height: 4),
          const Text('내가 입력한 값으로 예상 금액을 계산합니다', style: TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
          const SizedBox(height: 14),
          const DisclaimerBanner(
            icon: Icons.info_outline,
            message: '⚠ 이 금액은 참고용 예상액입니다\n'
                '체불 진정서에 들어가는 확정 금액이 아닙니다. 정확한 체불액은 근로감독관 조사에서 산정됩니다. '
                '계산 결과는 진정서로 자동으로 넘어가지 않습니다.',
          ),
          const SizedBox(height: 14),
          _InputGroup(
            title: '기본 정보',
            description: '시급과 주 소정근로시간을 입력하세요',
            trailing: ActionChip(
              label: const Text('↩ 최저임금 넣기 · ※ 고시 수치 확인 필요', style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600)),
              backgroundColor: AppColors.blueBg,
              side: BorderSide.none,
              onPressed: _applyMinimumWage,
            ),
            children: [
              _InputRow(
                label: '시급',
                unit: '원',
                controller: _hourlyWageController,
                onChanged: (v) => setState(() => _inputs = _inputs.copyWith(hourlyWage: int.tryParse(v) ?? 0)),
              ),
              _InputRow(
                label: '주 소정근로시간',
                unit: '시간',
                initialValue: _inputs.weeklyHours,
                onChanged: (v) => setState(() => _inputs = _inputs.copyWith(weeklyHours: double.tryParse(v) ?? 0)),
              ),
            ],
          ),
          const SizedBox(height: 11),
          _InputGroup(
            title: '연장·야간 근로',
            description: '이번 달 실제로 더 일한 시간',
            children: [
              _InputRow(
                label: '연장근로(월)',
                unit: '시간',
                initialValue: _inputs.overtimeHours,
                onChanged: (v) => setState(() => _inputs = _inputs.copyWith(overtimeHours: double.tryParse(v) ?? 0)),
              ),
              _InputRow(
                label: '야간근로(월)',
                unit: '시간',
                initialValue: _inputs.nightHours,
                onChanged: (v) => setState(() => _inputs = _inputs.copyWith(nightHours: double.tryParse(v) ?? 0)),
              ),
            ],
          ),
          const SizedBox(height: 11),
          _InputGroup(
            title: '연차·퇴직금',
            description: '쓰지 못한 연차와 재직 기간',
            children: [
              _InputRow(
                label: '미사용 연차',
                unit: '일',
                initialValue: _inputs.unusedLeaveDays,
                onChanged: (v) => setState(() => _inputs = _inputs.copyWith(unusedLeaveDays: double.tryParse(v) ?? 0)),
              ),
              _InputRow(
                label: '재직일수',
                unit: '일',
                initialValue: _inputs.employedDays.toDouble(),
                onChanged: (v) => setState(() => _inputs = _inputs.copyWith(employedDays: int.tryParse(v) ?? 0)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _ResultPanel(result: result),
        ],
      ),
    );
  }
}

class _InputGroup extends StatelessWidget {
  const _InputGroup({required this.title, required this.description, required this.children, this.trailing});

  final String title;
  final String description;
  final List<Widget> children;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text(description, style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted, height: 1.5)),
          if (trailing != null) ...[const SizedBox(height: 9), Align(alignment: Alignment.centerLeft, child: trailing!)],
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _InputRow extends StatelessWidget {
  const _InputRow({required this.label, required this.unit, this.controller, this.initialValue, required this.onChanged});

  final String label;
  final String unit;
  final TextEditingController? controller;
  final double? initialValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF334155)))),
          SizedBox(
            width: 82,
            child: TextFormField(
              controller: controller,
              initialValue: controller == null ? _formatInitial(initialValue) : null,
              onChanged: onChanged,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimary),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
                filled: true,
                fillColor: const Color(0xFFFBFDFF),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
              ),
            ),
          ),
          SizedBox(width: 30, child: Text('  $unit', style: const TextStyle(fontSize: 11, color: AppColors.textMuted))),
        ],
      ),
    );
  }

  String _formatInitial(double? v) {
    if (v == null) return '';
    return v == v.roundToDouble() ? v.toInt().toString() : v.toString();
  }
}

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({required this.result});
  final WageCalculationResult result;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('월 기본급', result.baseMonthlyPay),
      ('주휴수당', result.weeklyHolidayPay),
      ('연장근로수당 (1.5배)', result.overtimePay),
      ('야간근로 가산 (0.5배)', result.nightPay),
      ('연차미사용수당', result.unusedLeavePay),
      ('퇴직금 예상액', result.estimatedSeverance),
    ];

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color(0xFF0F2947), borderRadius: BorderRadius.circular(13)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final row in rows)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 7),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0x17FFFFFF)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(row.$1, style: const TextStyle(fontSize: 11.5, color: Color(0xFFA8BEDC))),
                  Text(_won(row.$2), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFFF1F6FC))),
                ],
              ),
            ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.only(top: 12),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0x59E8C88A)))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('합계 (예상)', style: TextStyle(fontSize: 12.5, color: Color(0xFFE8C88A), fontWeight: FontWeight.w600)),
                Text(_won(result.total), style: const TextStyle(fontSize: 19, color: Colors.white, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const SizedBox(height: 9),
          const Text(
            '주휴수당은 주 15시간 이상 근무 시 발생합니다. 퇴직금은 1년 이상 계속 근로한 경우에만 청구할 수 있습니다.',
            style: TextStyle(fontSize: 10, color: Color(0xFF7E97BC), height: 1.6),
          ),
        ],
      ),
    );
  }

  String _won(double value) {
    final rounded = value.round();
    final digits = rounded.abs().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return '${rounded < 0 ? '-' : ''}$buffer원';
  }
}
