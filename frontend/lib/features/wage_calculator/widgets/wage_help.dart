import 'package:flutter/material.dart';
import '../../../common/widgets/rich_note.dart';
import '../../../core/app_language.dart';
import '../../../theme/app_colors.dart';
import '../models/wage_diagnosis.dart';

const _okLabel = L10nText(ko: '확인', en: 'OK', zh: '确定', vi: 'Xác nhận');

void showWageHelp(
  BuildContext context,
  String title,
  Widget body,
  AppLanguage lang,
) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, style: const TextStyle(fontSize: 14.5)),
      content: SizedBox(width: 340, child: SingleChildScrollView(child: body)),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(_okLabel.of(lang)),
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

const _taxTableHeader = [
  L10nText(
    ko: '4대보험',
    en: '4 Major Insurances',
    zh: '四大保险',
    vi: '4 loại bảo hiểm',
  ),
  L10nText(
    ko: '근로자(급여공제)',
    en: 'Employee (payroll deduction)',
    zh: '劳动者（工资扣除）',
    vi: 'Người lao động (khấu trừ lương)',
  ),
  L10nText(ko: '사업주', en: 'Employer', zh: '雇主', vi: 'Người sử dụng lao động'),
];
const _pensionLabel = L10nText(
  ko: '국민연금 (9%)',
  en: 'National Pension (9%)',
  zh: '国民年金 (9%)',
  vi: 'Bảo hiểm hưu trí quốc dân (9%)',
);
const _healthLabel = L10nText(
  ko: '건강보험료 (6.99%)',
  en: 'Health Insurance (6.99%)',
  zh: '健康保险 (6.99%)',
  vi: 'Bảo hiểm y tế (6.99%)',
);
const _ltcLabel = L10nText(
  ko: '장기요양보험 (건강보험료의 12.27%)',
  en: 'Long-term Care Insurance (12.27% of health insurance)',
  zh: '长期护理保险（健康保险费的12.27%）',
  vi: 'Bảo hiểm chăm sóc dài hạn (12,27% phí bảo hiểm y tế)',
);
const _healthTimesLtc = L10nText(
  ko: '건강보험료 × 12.27%',
  en: 'Health insurance × 12.27%',
  zh: '健康保险费 × 12.27%',
  vi: 'Phí BHYT × 12,27%',
);
const _employmentLabel = L10nText(
  ko: '고용보험',
  en: 'Employment Insurance',
  zh: '雇佣保险',
  vi: 'Bảo hiểm việc làm',
);
const _variesByCompany = L10nText(
  ko: '기업규모별 상이',
  en: 'Varies by company size',
  zh: '因企业规模而异',
  vi: 'Khác nhau theo quy mô doanh nghiệp',
);
const _accidentLabel = L10nText(
  ko: '산재보험',
  en: 'Industrial Accident Insurance',
  zh: '工伤保险',
  vi: 'Bảo hiểm tai nạn lao động',
);
const _noneLabel = L10nText(ko: '없음', en: 'None', zh: '无', vi: 'Không có');
const _variesByIndustry = L10nText(
  ko: '업종별 상이',
  en: 'Varies by industry',
  zh: '因行业而异',
  vi: 'Khác nhau theo ngành nghề',
);

Widget _taxInfoBody(BuildContext context, AppLanguage lang) {
  String t(L10nText s) => s.of(lang);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Table(
        border: TableBorder.all(color: AppColors.border),
        children: [
          _TaxTableRow(_taxTableHeader.map(t).toList(), isHeader: true),
          _TaxTableRow([t(_pensionLabel), '4.5%', '4.5%']),
          _TaxTableRow([t(_healthLabel), '3.495%', '3.495%']),
          _TaxTableRow([t(_ltcLabel), t(_healthTimesLtc), t(_healthTimesLtc)]),
          _TaxTableRow([t(_employmentLabel), '0.9%', t(_variesByCompany)]),
          _TaxTableRow([
            t(_accidentLabel),
            t(_noneLabel),
            t(_variesByIndustry),
          ]),
        ],
      ),
      const SizedBox(height: 8),
      Text(
        switch (lang) {
          AppLanguage.ko =>
            '1) 4대보험 공제 시 근로자 부담률 합계는 약 ${(insuranceRate() * 100).toStringAsFixed(2)}%입니다. 월 60시간 미만 근로자는 가입 대상이 아니라 세금 차감이 없습니다.',
          AppLanguage.en =>
            "1) When the 4 Major Insurances are deducted, the employee's total contribution rate is about ${(insuranceRate() * 100).toStringAsFixed(2)}%. Workers under 60 hours/month are not required to enroll, so there is no deduction.",
          AppLanguage.zh =>
            '1) 扣除四大保险时，劳动者的负担率合计约为${(insuranceRate() * 100).toStringAsFixed(2)}%。每月工作不满60小时的劳动者不属于参保对象，故无税金扣除。',
          AppLanguage.vi =>
            '1) Khi khấu trừ 4 loại bảo hiểm, tổng tỷ lệ đóng góp của người lao động khoảng ${(insuranceRate() * 100).toStringAsFixed(2)}%. Người lao động dưới 60 giờ/tháng không thuộc đối tượng tham gia nên không bị khấu trừ.',
        },
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.textSecondary,
          height: 1.6,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        switch (lang) {
          AppLanguage.ko => '2) 소득세 3.3% 공제 = 소득세 3% + 지방소득세(소득세액의 10%)',
          AppLanguage.en =>
            '2) The 3.3% income tax deduction = 3% income tax + local income tax (10% of the income tax amount)',
          AppLanguage.zh => '2) 所得税3.3%扣除 = 所得税3% + 地方所得税（所得税额的10%）',
          AppLanguage.vi =>
            '2) Khấu trừ thuế thu nhập 3,3% = thuế thu nhập 3% + thuế thu nhập địa phương (10% số thuế thu nhập)',
        },
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.textSecondary,
          height: 1.6,
        ),
      ),
    ],
  );
}

class _E {
  const _E(this.title, this.body);
  final L10nText title;
  final L10nText body;
}

const _entries = {
  'pm_month': _E(
    L10nText(
      ko: '이번달만 확인',
      en: 'Check this month only',
      zh: '仅确认本月',
      vi: 'Chỉ kiểm tra tháng này',
    ),
    L10nText(
      ko: '이번 달 1개월치 급여 및 체불 내역만 정산합니다.',
      en: "Settles only this month's pay and any unpaid amount.",
      zh: '仅结算本月一个月的工资和欠薪情况。',
      vi: 'Chỉ tính lương và tình trạng nợ lương của 1 tháng này.',
    ),
  ),
  'pm_multi': _E(
    L10nText(
      ko: '여러달 체불 확인',
      en: 'Check unpaid wages over several months',
      zh: '确认多个月的欠薪',
      vi: 'Kiểm tra nợ lương nhiều tháng',
    ),
    L10nText(
      ko: '최근 몇 개월 동안 급여가 밀렸는지 선택합니다. 입력하는 근무시간과 입금액은 해당 개월 수 전체의 합계입니다.',
      en: 'Choose how many recent months your pay has been delayed. The work hours and amounts you enter should be the total across all those months.',
      zh: '选择最近几个月工资被拖欠的情况。您输入的工作时间和到账金额应为这些月份的总计。',
      vi: 'Chọn số tháng gần đây bị chậm lương. Giờ làm và số tiền bạn nhập là tổng cộng của toàn bộ số tháng đó.',
    ),
  ),
  'pm_range': _E(
    L10nText(
      ko: '기간 직접 지정',
      en: 'Set a custom period',
      zh: '自定义期间',
      vi: 'Tự chọn khoảng thời gian',
    ),
    L10nText(
      ko: '체불이 시작된 월부터 종료된 월까지 설정합니다. 임금채권 소멸시효는 3년입니다.',
      en: 'Set the month the unpaid wages started and the month they ended. Wage claims expire after 3 years.',
      zh: '设置欠薪开始月份和结束月份。工资债权的诉讼时效为3年。',
      vi: 'Đặt tháng bắt đầu và tháng kết thúc nợ lương. Thời hiệu yêu cầu tiền lương là 3 năm.',
    ),
  ),
  'biz_size': _E(
    L10nText(
      ko: '사업장 규모 기준',
      en: 'Business size criteria',
      zh: '企业规模标准',
      vi: 'Tiêu chí quy mô doanh nghiệp',
    ),
    L10nText(
      ko:
          '<b>• 5인 이상:</b> 연장·야간·휴일근로 가산수당(1.5배~2배) 적용.<br>'
          '<b>• 5인 미만:</b> 가산수당 미적용 (일한 시간만큼 1.0배 지급).<br>'
          '<b>• 잘 모르겠어요:</b> 근로자에게 불리하지 않도록 5인 미만 기준으로 보수적으로 계산합니다. 정확한 인원은 임금명세서나 4대보험 가입자 수로 확인할 수 있어요.',
      en:
          '<b>• 5+ employees:</b> overtime/night/holiday premium pay (1.5x–2x) applies.<br>'
          '<b>• Fewer than 5:</b> no premium pay (paid 1.0x for hours worked).<br>'
          "<b>• Not sure:</b> calculated conservatively as under-5 so it doesn't disadvantage you. You can check the exact headcount via your payslip or 4-major-insurance enrollment count.",
      zh:
          '<b>• 5人以上：</b>适用加班·夜间·休息日加班津贴（1.5倍~2倍）。<br>'
          '<b>• 5人以下：</b>不适用加成津贴（按工作时间1.0倍支付）。<br>'
          '<b>• 不确定：</b>为避免对劳动者不利，暂按5人以下的标准保守计算。准确人数可通过工资单或四大保险参保人数确认。',
      vi:
          '<b>• Từ 5 người trở lên:</b> áp dụng phụ cấp làm thêm/đêm/ngày nghỉ (1,5–2 lần).<br>'
          '<b>• Dưới 5 người:</b> không áp dụng phụ cấp (trả 1,0 lần theo giờ làm).<br>'
          '<b>• Không chắc:</b> tính bảo thủ theo mức dưới 5 người để không bất lợi cho người lao động. Có thể xác nhận số người chính xác qua phiếu lương hoặc số người tham gia 4 loại bảo hiểm.',
    ),
  ),
  'week_h': _E(
    L10nText(
      ko: '주당 약정 근로시간',
      en: 'Contracted weekly hours',
      zh: '每周约定工作时间',
      vi: 'Giờ làm theo tuần đã thỏa thuận',
    ),
    L10nText(
      ko: '근로계약서상 일하기로 약정한 주당 시간입니다. (월급제 기본값 40시간 = 월 209시간)',
      en: 'The weekly hours agreed in your employment contract. (Default for monthly pay: 40 hrs/week = 209 hrs/month)',
      zh: '劳动合同中约定的每周工作时间。（月薪制默认值：每周40小时 = 每月209小时）',
      vi: 'Số giờ mỗi tuần đã thỏa thuận trong hợp đồng lao động. (Mặc định cho lương tháng: 40 giờ/tuần = 209 giờ/tháng)',
    ),
  ),
  'ot_info': _E(
    L10nText(
      ko: '연장근로 수당',
      en: 'Overtime pay',
      zh: '加班津贴',
      vi: 'Phụ cấp làm thêm giờ',
    ),
    L10nText(
      ko:
          '연장근로는 계약서상 정규근로시간 이외에 초과하여 근로한 행위를 말합니다.<br>'
          '<b>계산식: (연장근무시간 × 계약시급) × 1.5</b><br>'
          '• 상시 근로자수 5인 이상 사업장: 통상임금의 50%를 가산해서 지급<br>'
          '• 상시 근로자수 5인 미만: 통상임금만 지급',
      en:
          'Overtime means working beyond the regular hours set in your contract.<br>'
          '<b>Formula: (overtime hours × contracted hourly wage) × 1.5</b><br>'
          '• 5+ employee workplaces: pay an extra 50% of ordinary wage<br>'
          '• Fewer than 5 employees: pay ordinary wage only',
      zh:
          '加班是指超出合同规定正常工作时间之外的劳动。<br>'
          '<b>计算公式：（加班时间 × 合同时薪）× 1.5</b><br>'
          '• 常雇员工5人以上单位：加发通常工资的50%<br>'
          '• 常雇员工不足5人：仅支付通常工资',
      vi:
          'Làm thêm giờ là làm việc vượt quá giờ làm việc chính thức theo hợp đồng.<br>'
          '<b>Công thức: (số giờ làm thêm × lương giờ theo hợp đồng) × 1,5</b><br>'
          '• Nơi làm việc từ 5 người trở lên: trả thêm 50% lương thông thường<br>'
          '• Nơi làm việc dưới 5 người: chỉ trả lương thông thường',
    ),
  ),
  'nt_info': _E(
    L10nText(
      ko: '야간근로 수당',
      en: 'Night work pay',
      zh: '夜班津贴',
      vi: 'Phụ cấp làm đêm',
    ),
    L10nText(
      ko:
          '야간근로는 오후 10시부터 다음 날 오전 6시 사이의 시간에 근로한 행위를 말합니다.<br>'
          '<b>계산식: (야간근무시간 × 계약시급) × 0.5(가산분)</b><br>'
          '• 5인 이상 사업장: 야간근로 자체에 대한 가산수당 50%를 별도로 추가 지급<br>'
          '• 5인 미만 사업장: 가산수당이 없으며 주간 근로와 동일한 통상임금만 지급',
      en:
          'Night work means working between 10 PM and 6 AM the next day.<br>'
          '<b>Formula: (night hours × contracted hourly wage) × 0.5 (premium portion)</b><br>'
          '• 5+ employee workplaces: an additional 50% premium is paid on top, specifically for night work<br>'
          '• Fewer than 5 employees: no premium; paid the same ordinary wage as daytime work',
      zh:
          '夜班是指晚上10点到次日早上6点之间的劳动。<br>'
          '<b>计算公式：（夜班时间 × 合同时薪）× 0.5（加成部分）</b><br>'
          '• 5人以上单位：针对夜班本身另外加发50%的津贴<br>'
          '• 不足5人单位：无加成津贴，与白班同样只支付通常工资',
      vi:
          'Làm đêm là làm việc trong khoảng từ 22 giờ đến 6 giờ sáng hôm sau.<br>'
          '<b>Công thức: (số giờ làm đêm × lương giờ theo hợp đồng) × 0,5 (phần phụ cấp)</b><br>'
          '• Nơi làm việc từ 5 người trở lên: trả thêm riêng 50% phụ cấp cho làm đêm<br>'
          '• Nơi làm việc dưới 5 người: không có phụ cấp, chỉ trả lương thông thường như ban ngày',
    ),
  ),
  'hol_info': _E(
    L10nText(
      ko: '휴일근로 수당',
      en: 'Holiday work pay',
      zh: '休息日加班津贴',
      vi: 'Phụ cấp làm ngày nghỉ',
    ),
    L10nText(
      ko:
          '휴일근로는 근로계약서나 법정 제도상 지정된 휴일에 출근하여 근로한 행위를 말합니다.<br>'
          '<b>계산식: (휴일근무시간 × 계약시급) × 1.5 (8시간 초과분은 2.0)</b><br>'
          '• 5인 이상 사업장: 8시간 이하는 50% 가산, 8시간 초과분은 100% 가산<br>'
          '• 5인 미만 사업장: 가산수당이 없으며 실제 일한 시간만큼의 통상임금만 지급',
      en:
          'Holiday work means working on a day designated as a holiday by your contract or by law.<br>'
          '<b>Formula: (holiday hours × contracted hourly wage) × 1.5 (2.0 for hours beyond 8)</b><br>'
          '• 5+ employee workplaces: 50% premium up to 8 hours, 100% premium beyond 8 hours<br>'
          '• Fewer than 5 employees: no premium; paid ordinary wage only for actual hours worked',
      zh:
          '休息日加班是指在合同或法定制度指定的休息日出勤劳动。<br>'
          '<b>计算公式：（休息日工作时间 × 合同时薪）× 1.5（超过8小时部分为2.0）</b><br>'
          '• 5人以上单位：8小时以内加发50%，超过8小时部分加发100%<br>'
          '• 不足5人单位：无加成津贴，仅按实际工作时间支付通常工资',
      vi:
          'Làm ngày nghỉ là làm việc vào ngày được quy định là ngày nghỉ theo hợp đồng hoặc pháp luật.<br>'
          '<b>Công thức: (số giờ làm ngày nghỉ × lương giờ theo hợp đồng) × 1,5 (phần vượt 8 giờ là 2,0)</b><br>'
          '• Nơi làm việc từ 5 người trở lên: phụ cấp 50% trong 8 giờ đầu, 100% cho phần vượt 8 giờ<br>'
          '• Nơi làm việc dưới 5 người: không có phụ cấp, chỉ trả lương thông thường theo giờ thực làm',
    ),
  ),
  'tenure_info': _E(
    L10nText(
      ko: '재직 기간 안내',
      en: 'About your tenure period',
      zh: '在职期间说明',
      vi: 'Hướng dẫn về thời gian làm việc',
    ),
    L10nText(
      ko:
          '여기서 입력하는 재직 기간(입사일~퇴사일)은 퇴직금 지급 요건 — ① 계속근로 1년 이상, ② 주 평균 15시간 이상 — 을 판단하는 용도로만 사용됩니다. '
          '앞서 고르신 확인 기간(체불 기간)과는 별개예요.',
      en:
          'The tenure period you enter here (hire date to resignation date) is used only to check the severance-pay eligibility conditions — ① 1+ year of continuous service, ② 15+ hours/week on average. '
          'It is separate from the check period (unpaid-wage period) you chose earlier.',
      zh:
          '此处输入的在职期间（入职日期~离职日期）仅用于判断退休金发放条件——①连续工作1年以上，②周平均工作15小时以上。'
          '这与您之前选择的确认期间（欠薪期间）是分开的。',
      vi:
          'Thời gian làm việc bạn nhập ở đây (ngày vào làm~ngày nghỉ việc) chỉ dùng để xét điều kiện nhận trợ cấp thôi việc — ① làm việc liên tục từ 1 năm trở lên, ② trung bình từ 15 giờ/tuần trở lên. '
          'Đây là mục riêng biệt với khoảng thời gian kiểm tra (thời gian nợ lương) bạn đã chọn trước đó.',
    ),
  ),
  'severance_extra': _E(
    L10nText(
      ko: '퇴직금 정밀 산정 추가 입력',
      en: 'Additional input for precise severance calculation',
      zh: '退休金精确计算的附加输入',
      vi: 'Nhập thêm để tính chính xác trợ cấp thôi việc',
    ),
    L10nText(
      ko: '정기 상여금과 미사용 연차수당은 평균임금 계산 시 각 연간 총액의 3/12(25%)만큼 3개월 임금총액에 합산됩니다. 모르면 0으로 두어도 기본 계산은 진행됩니다.',
      en: "Regular bonuses and unused annual-leave pay are each added to the 3-month wage total at 3/12 (25%) of their annual amount when calculating average wage. If you don't know, leaving it at 0 still lets the basic calculation proceed.",
      zh: '计算平均工资时，定期奖金和未使用年假补贴将分别按各自年度总额的3/12（25%）计入3个月工资总额。如果不清楚，留空为0也可以进行基本计算。',
      vi: 'Khi tính lương bình quân, tiền thưởng định kỳ và phụ cấp phép năm chưa dùng sẽ được cộng vào tổng lương 3 tháng theo tỷ lệ 3/12 (25%) của tổng số hàng năm. Nếu không biết, để 0 vẫn có thể tính toán cơ bản.',
    ),
  ),
  'severance_intro': _E(
    L10nText(
      ko: '예상 퇴직금이란',
      en: 'What is estimated severance pay',
      zh: '预计退休金是什么',
      vi: 'Trợ cấp thôi việc dự kiến là gì',
    ),
    L10nText(
      ko: '재직 기간이 1년 이상이고 주 평균 15시간 이상 근무했다면, 근로 형태·사업장 규모와 관계없이 발생하는 별도의 법정 금액입니다. 임금과는 별도로 계산됩니다.',
      en: 'If you worked 1+ year with a weekly average of 15+ hours, this is a separate statutory amount that applies regardless of your employment type or business size. It is calculated separately from wages.',
      zh: '如果在职期间1年以上且周平均工作15小时以上，无论用工形式或企业规模如何，都会产生这笔单独的法定金额。此金额与工资分开计算。',
      vi: 'Nếu làm việc từ 1 năm trở lên và trung bình từ 15 giờ/tuần trở lên, đây là khoản tiền pháp định riêng, phát sinh bất kể hình thức lao động hay quy mô doanh nghiệp. Được tính riêng, không gộp vào lương.',
    ),
  ),
  'logic_base': _E(
    L10nText(
      ko: '기본급 산정 원리',
      en: 'How base pay is calculated',
      zh: '基本工资计算原理',
      vi: 'Nguyên lý tính lương cơ bản',
    ),
    L10nText(
      ko: '약정 근로시간(또는 근무일수)에 통상시급(또는 일급)을 곱하여 산정한 기본 급여입니다.',
      en: 'Base pay is calculated by multiplying your contracted hours (or days worked) by your ordinary hourly (or daily) wage.',
      zh: '基本工资是用约定工作时间（或工作天数）乘以通常时薪（或日薪）计算得出的。',
      vi: 'Lương cơ bản được tính bằng cách nhân số giờ làm việc thỏa thuận (hoặc số ngày làm việc) với lương giờ thông thường (hoặc lương ngày).',
    ),
  ),
  'logic_week': _E(
    L10nText(
      ko: '주휴수당 산정 원리',
      en: 'How weekly holiday allowance is calculated',
      zh: '周休津贴计算原理',
      vi: 'Nguyên lý tính phụ cấp nghỉ hằng tuần',
    ),
    L10nText(
      ko: '주 15시간 이상 개근 시 지급되는 유급휴일 수당입니다. (월급제·연봉제는 이미 포함되어 별도로 더하지 않습니다)',
      en: 'A paid-holiday allowance given when you work 15+ hours a week with perfect attendance. (Already included for monthly/annual pay, so it is not added separately.)',
      zh: '每周工作15小时以上且全勤时发放的带薪假期津贴。（月薪制、年薪制已包含在内，不另行增加）',
      vi: 'Là phụ cấp ngày nghỉ có lương khi làm từ 15 giờ/tuần trở lên và đi làm đầy đủ. (Đã bao gồm trong lương tháng/lương năm nên không cộng thêm riêng)',
    ),
  ),
  'logic_gross': _E(
    L10nText(
      ko: '세전 총액',
      en: 'Total before tax',
      zh: '税前总额',
      vi: 'Tổng trước thuế',
    ),
    L10nText(
      ko: '기본급 + 주휴수당 + 가산수당(연장·야간·휴일)을 모두 더한 금액입니다. 여기서 세금과 숙식비를 빼면 실수령액이 됩니다.',
      en: 'This is base pay + weekly holiday allowance + premium pay (overtime/night/holiday) added together. Subtracting tax and board/lodging from this gives your take-home pay.',
      zh: '这是基本工资+周休津贴+加成津贴（加班·夜班·休息日）相加的金额。从中扣除税金和食宿费后即为实际到手金额。',
      vi: 'Đây là lương cơ bản + phụ cấp nghỉ hằng tuần + phụ cấp thêm (làm thêm giờ/đêm/ngày nghỉ) cộng lại. Trừ thuế và tiền ăn ở khỏi số này sẽ ra số tiền thực nhận.',
    ),
  ),
  'logic_net': _E(
    L10nText(
      ko: '예상 실수령액',
      en: 'Estimated take-home pay',
      zh: '预计实际到手金额',
      vi: 'Số tiền thực nhận dự kiến',
    ),
    L10nText(
      ko: '세전 총액에서 선택하신 세금 공제와 숙식비 공제를 뺀 금액입니다.',
      en: 'This is the pre-tax total minus the tax deduction and board/lodging deduction you selected.',
      zh: '这是税前总额减去您所选的税金扣除和食宿费扣除后的金额。',
      vi: 'Đây là tổng trước thuế trừ đi khoản khấu trừ thuế và tiền ăn ở mà bạn đã chọn.',
    ),
  ),
};

/// 원본 HELP_DICT를 그대로 옮긴 도움말 사전. 최저임금처럼 값이 매년 바뀌는 항목은
/// 호출 시점에 다시 계산하도록 body를 함수로 둔다.
Map<String, HelpEntry> buildHelpDict(AppLanguage lang) {
  final mw = minWage();
  final dict = <String, HelpEntry>{
    for (final e in _entries.entries)
      e.key: HelpEntry(
        title: e.value.title.of(lang),
        body: (context) => _TextBody(e.value.body.of(lang)),
      ),
  };

  dict['minw'] = HelpEntry(
    title: switch (lang) {
      AppLanguage.ko => '$wageCalcYear년 최저임금 기준',
      AppLanguage.en => '$wageCalcYear Minimum Wage',
      AppLanguage.zh => '$wageCalcYear年最低工资标准',
      AppLanguage.vi => 'Mức lương tối thiểu năm $wageCalcYear',
    },
    body: (context) => _TextBody(switch (lang) {
      AppLanguage.ko =>
        '• 시간급: <b>${formatWon(mw.$1, lang)}</b><br>'
            '• 월급 환산(주 40시간·월 209시간 기준): <b>${formatWon(mw.$2, lang)}</b><br>'
            '• 연봉 환산(월급×12): 약 <b>${formatWon(mw.$2 * 12, lang)}</b><br>'
            '• 최저임금 미달 계약은 그 부분이 무효이며 차액 청구가 가능합니다.',
      AppLanguage.en =>
        '• Hourly wage: <b>${formatWon(mw.$1, lang)}</b><br>'
            '• Monthly equivalent (40 hrs/week, 209 hrs/month): <b>${formatWon(mw.$2, lang)}</b><br>'
            '• Annual equivalent (monthly × 12): approx. <b>${formatWon(mw.$2 * 12, lang)}</b><br>'
            '• A contract below minimum wage is invalid for that portion, and you can claim the difference.',
      AppLanguage.zh =>
        '• 时薪：<b>${formatWon(mw.$1, lang)}</b><br>'
            '• 月薪换算（每周40小时·每月209小时）：<b>${formatWon(mw.$2, lang)}</b><br>'
            '• 年薪换算（月薪×12）：约 <b>${formatWon(mw.$2 * 12, lang)}</b><br>'
            '• 低于最低工资的合同条款无效，可以要求补足差额。',
      AppLanguage.vi =>
        '• Lương giờ: <b>${formatWon(mw.$1, lang)}</b><br>'
            '• Quy đổi lương tháng (40 giờ/tuần, 209 giờ/tháng): <b>${formatWon(mw.$2, lang)}</b><br>'
            '• Quy đổi lương năm (lương tháng×12): khoảng <b>${formatWon(mw.$2 * 12, lang)}</b><br>'
            '• Hợp đồng dưới mức lương tối thiểu thì phần đó vô hiệu, bạn có thể yêu cầu khoản chênh lệch.',
    }),
  );

  dict['tax_info'] = HelpEntry(
    title: switch (lang) {
      AppLanguage.ko => '근로자의 세금 적용 방식',
      AppLanguage.en => 'How taxes apply to workers',
      AppLanguage.zh => '劳动者的税务适用方式',
      AppLanguage.vi => 'Cách áp dụng thuế cho người lao động',
    },
    body: (context) => _taxInfoBody(context, lang),
  );

  return dict;
}

/// 고정 문자열을 RichNote로 렌더링하는 얇은 래퍼 — HelpEntry.body 시그니처(위젯 빌더)에 맞추기 위함.
class _TextBody extends StatelessWidget {
  const _TextBody(this.raw);
  final String raw;

  @override
  Widget build(BuildContext context) => RichNote(raw);
}
