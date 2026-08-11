import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../models/wage_diagnosis.dart';

/// 도움말(?)/AI 진단 팝업에서 쓰는 아주 작은 서식 파서. 원본 HTML의 `<b>`(강조)·
/// `<br>`(줄바꿈) 두 태그만 지원한다 — 전체 HTML 렌더러를 들이는 대신, 이 화면에
/// 실제로 쓰이는 두 태그만 가볍게 처리한다.
List<InlineSpan> parseRichSpans(
  String raw, {
  TextStyle? style,
  TextStyle? boldStyle,
}) {
  final spans = <InlineSpan>[];
  final lines = raw.split('<br>');
  final boldPattern = RegExp(r'<b>(.*?)</b>');

  for (var li = 0; li < lines.length; li++) {
    final line = lines[li];
    var last = 0;
    for (final m in boldPattern.allMatches(line)) {
      if (m.start > last) {
        spans.add(TextSpan(text: line.substring(last, m.start)));
      }
      spans.add(
        TextSpan(
          text: m.group(1),
          style: boldStyle ?? const TextStyle(fontWeight: FontWeight.w800),
        ),
      );
      last = m.end;
    }
    if (last < line.length) spans.add(TextSpan(text: line.substring(last)));
    if (li < lines.length - 1) spans.add(const TextSpan(text: '\n'));
  }
  return spans;
}

class RichNote extends StatelessWidget {
  const RichNote(this.raw, {super.key, this.style});
  final String raw;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final base =
        style ??
        const TextStyle(
          fontSize: 11,
          color: AppColors.textSecondary,
          height: 1.6,
        );
    return Text.rich(
      TextSpan(
        style: base,
        children: parseRichSpans(raw, style: base),
      ),
    );
  }
}

void showWageHelp(BuildContext context, String title, Widget body) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, style: const TextStyle(fontSize: 14.5)),
      content: SizedBox(width: 340, child: SingleChildScrollView(child: body)),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('확인'),
        ),
      ],
    ),
  );
}

class HelpEntry {
  HelpEntry({required this.title, required this.body});
  final String title;
  final Widget Function(BuildContext context) body;
}

class _TaxTableRow extends TableRow {
  _TaxTableRow(List<String> cells, {bool isHeader = false})
    : super(
        decoration: isHeader
            ? const BoxDecoration(color: Color(0xFFF1F5F9))
            : null,
        children: cells
            .map(
              (c) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Text(
                  c,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isHeader ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            )
            .toList(),
      );
}

Widget _taxInfoBody(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Table(
        border: TableBorder.all(color: AppColors.border),
        children: [
          _TaxTableRow(const ['4대보험', '근로자(급여공제)', '사업주'], isHeader: true),
          _TaxTableRow(const ['국민연금 (9%)', '4.5%', '4.5%']),
          _TaxTableRow(const ['건강보험료 (6.99%)', '3.495%', '3.495%']),
          _TaxTableRow(const [
            '장기요양보험 (건강보험료의 12.27%)',
            '건강보험료 × 12.27%',
            '건강보험료 × 12.27%',
          ]),
          _TaxTableRow(const ['고용보험', '0.9%', '기업규모별 상이']),
          _TaxTableRow(const ['산재보험', '없음', '업종별 상이']),
        ],
      ),
      const SizedBox(height: 8),
      Text(
        '1) 4대보험 공제 시 근로자 부담률 합계는 약 ${(insuranceRate() * 100).toStringAsFixed(2)}%입니다. 월 60시간 미만 근로자는 가입 대상이 아니라 세금 차감이 없습니다.',
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.textSecondary,
          height: 1.6,
        ),
      ),
      const SizedBox(height: 6),
      const Text(
        '2) 소득세 3.3% 공제 = 소득세 3% + 지방소득세(소득세액의 10%)',
        style: TextStyle(
          fontSize: 11,
          color: AppColors.textSecondary,
          height: 1.6,
        ),
      ),
    ],
  );
}

/// 원본 HELP_DICT를 그대로 옮긴 도움말 사전. 최저임금처럼 값이 매년 바뀌는 항목은
/// 호출 시점에 다시 계산하도록 body를 함수로 둔다.
Map<String, HelpEntry> buildHelpDict() {
  final mw = minWage();
  return {
    'pm_month': HelpEntry(
      title: '이번달만 확인',
      body: (context) => _TextBody('이번 달 1개월치 급여 및 체불 내역만 정산합니다.'),
    ),
    'pm_multi': HelpEntry(
      title: '여러달 체불 확인',
      body: (context) => _TextBody(
        '최근 몇 개월 동안 급여가 밀렸는지 선택합니다. 입력하는 근무시간과 입금액은 해당 개월 수 전체의 합계입니다.',
      ),
    ),
    'pm_range': HelpEntry(
      title: '기간 직접 지정',
      body: (context) =>
          _TextBody('체불이 시작된 월부터 종료된 월까지 설정합니다. 임금채권 소멸시효는 3년입니다.'),
    ),
    'minw': HelpEntry(
      title: '$wageCalcYear년 최저임금 기준',
      body: (context) => _TextBody(
        '• 시간급: <b>${formatWon(mw.$1)}</b><br>'
        '• 월급 환산(주 40시간·월 209시간 기준): <b>${formatWon(mw.$2)}</b><br>'
        '• 연봉 환산(월급×12): 약 <b>${formatWon(mw.$2 * 12)}</b><br>'
        '• 최저임금 미달 계약은 그 부분이 무효이며 차액 청구가 가능합니다.',
      ),
    ),
    'biz_size': HelpEntry(
      title: '사업장 규모 기준',
      body: (context) => _TextBody(
        '<b>• 5인 이상:</b> 연장·야간·휴일근로 가산수당(1.5배~2배) 적용.<br>'
        '<b>• 5인 미만:</b> 가산수당 미적용 (일한 시간만큼 1.0배 지급).<br>'
        '<b>• 잘 모르겠어요:</b> 근로자에게 불리하지 않도록 5인 미만 기준으로 보수적으로 계산합니다. 정확한 인원은 임금명세서나 4대보험 가입자 수로 확인할 수 있어요.',
      ),
    ),
    'week_h': HelpEntry(
      title: '주당 약정 근로시간',
      body: (context) =>
          _TextBody('근로계약서상 일하기로 약정한 주당 시간입니다. (월급제 기본값 40시간 = 월 209시간)'),
    ),
    'ot_info': HelpEntry(
      title: '연장근로 수당',
      body: (context) => _TextBody(
        '연장근로는 계약서상 정규근로시간 이외에 초과하여 근로한 행위를 말합니다.<br>'
        '<b>계산식: (연장근무시간 × 계약시급) × 1.5</b><br>'
        '• 상시 근로자수 5인 이상 사업장: 통상임금의 50%를 가산해서 지급<br>'
        '• 상시 근로자수 5인 미만: 통상임금만 지급',
      ),
    ),
    'nt_info': HelpEntry(
      title: '야간근로 수당',
      body: (context) => _TextBody(
        '야간근로는 오후 10시부터 다음 날 오전 6시 사이의 시간에 근로한 행위를 말합니다.<br>'
        '<b>계산식: (야간근무시간 × 계약시급) × 0.5(가산분)</b><br>'
        '• 5인 이상 사업장: 야간근로 자체에 대한 가산수당 50%를 별도로 추가 지급<br>'
        '• 5인 미만 사업장: 가산수당이 없으며 주간 근로와 동일한 통상임금만 지급',
      ),
    ),
    'hol_info': HelpEntry(
      title: '휴일근로 수당',
      body: (context) => _TextBody(
        '휴일근로는 근로계약서나 법정 제도상 지정된 휴일에 출근하여 근로한 행위를 말합니다.<br>'
        '<b>계산식: (휴일근무시간 × 계약시급) × 1.5 (8시간 초과분은 2.0)</b><br>'
        '• 5인 이상 사업장: 8시간 이하는 50% 가산, 8시간 초과분은 100% 가산<br>'
        '• 5인 미만 사업장: 가산수당이 없으며 실제 일한 시간만큼의 통상임금만 지급',
      ),
    ),
    'tenure_info': HelpEntry(
      title: '재직 기간 안내',
      body: (context) => _TextBody(
        '여기서 입력하는 재직 기간(입사일~퇴사일)은 퇴직금 지급 요건 — ① 계속근로 1년 이상, ② 주 평균 15시간 이상 — 을 판단하는 용도로만 사용됩니다. '
        '앞서 고르신 확인 기간(체불 기간)과는 별개예요.',
      ),
    ),
    'severance_extra': HelpEntry(
      title: '퇴직금 정밀 산정 추가 입력',
      body: (context) => _TextBody(
        '정기 상여금과 미사용 연차수당은 평균임금 계산 시 각 연간 총액의 3/12(25%)만큼 3개월 임금총액에 합산됩니다. 모르면 0으로 두어도 기본 계산은 진행됩니다.',
      ),
    ),
    'severance_intro': HelpEntry(
      title: '예상 퇴직금이란',
      body: (context) => _TextBody(
        '재직 기간이 1년 이상이고 주 평균 15시간 이상 근무했다면, 근로 형태·사업장 규모와 관계없이 발생하는 별도의 법정 금액입니다. 임금과는 별도로 계산됩니다.',
      ),
    ),
    'tax_info': HelpEntry(title: '근로자의 세금 적용 방식', body: _taxInfoBody),
    'logic_base': HelpEntry(
      title: '기본급 산정 원리',
      body: (context) =>
          _TextBody('약정 근로시간(또는 근무일수)에 통상시급(또는 일급)을 곱하여 산정한 기본 급여입니다.'),
    ),
    'logic_week': HelpEntry(
      title: '주휴수당 산정 원리',
      body: (context) => _TextBody(
        '주 15시간 이상 개근 시 지급되는 유급휴일 수당입니다. (월급제·연봉제는 이미 포함되어 별도로 더하지 않습니다)',
      ),
    ),
    'logic_gross': HelpEntry(
      title: '세전 총액',
      body: (context) => _TextBody(
        '기본급 + 주휴수당 + 가산수당(연장·야간·휴일)을 모두 더한 금액입니다. 여기서 세금과 숙식비를 빼면 실수령액이 됩니다.',
      ),
    ),
    'logic_net': HelpEntry(
      title: '예상 실수령액',
      body: (context) => _TextBody('세전 총액에서 선택하신 세금 공제와 숙식비 공제를 뺀 금액입니다.'),
    ),
  };
}

/// 고정 문자열을 RichNote로 렌더링하는 얇은 래퍼 — HelpEntry.body 시그니처(위젯 빌더)에 맞추기 위함.
class _TextBody extends StatelessWidget {
  const _TextBody(this.raw);
  final String raw;

  @override
  Widget build(BuildContext context) => RichNote(raw);
}
