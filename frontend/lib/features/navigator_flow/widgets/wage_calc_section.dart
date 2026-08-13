import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../common/widgets/rich_note.dart';
import '../../../core/app_language.dart';
import '../../../theme/app_colors.dart';
import '../../wage_calculator/models/wage_diagnosis.dart';
import '../controllers/wage_calc_scratch_controller.dart';

const _sectionTitle = L10nText(
  ko: '체불액 예상 계산',
  en: 'Estimate the unpaid amount',
  zh: '预估欠薪金额',
  vi: 'Ước tính số tiền bị nợ',
);
const _payTypeLabel = L10nText(
  ko: '급여 형태',
  en: 'Pay type',
  zh: '薪资形式',
  vi: 'Hình thức lương',
);
const _payLabel = L10nText(
  ko: '계약된 금액',
  en: 'Contracted amount',
  zh: '约定金额',
  vi: 'Số tiền theo hợp đồng',
);
const _weekHoursLabel = L10nText(
  ko: '주당 근로시간',
  en: 'Weekly hours',
  zh: '每周工作时长',
  vi: 'Giờ làm mỗi tuần',
);
const _hireDateLabel = L10nText(
  ko: '입사일',
  en: 'Hire date',
  zh: '入职日',
  vi: 'Ngày vào làm',
);
const _leaveDateLabel = L10nText(
  ko: '퇴사일(재직 중이면 비움)',
  en: 'Leave date (blank if still working)',
  zh: '离职日（在职留空）',
  vi: 'Ngày nghỉ (bỏ trống nếu còn làm)',
);
const _sizeLabel = L10nText(
  ko: '사업장 규모',
  en: 'Workplace size',
  zh: '单位规模',
  vi: 'Quy mô cơ sở',
);
const _receivedLabel = L10nText(
  ko: '실제 받은 금액(세후)',
  en: 'Amount actually received (after tax)',
  zh: '实际到账金额（税后）',
  vi: 'Số tiền thực nhận (sau thuế)',
);
const _calcButtonLabel = L10nText(
  ko: '🧮 계산하기',
  en: '🧮 Calculate',
  zh: '🧮 计算',
  vi: '🧮 Tính toán',
);
const _expectedLabel = L10nText(
  ko: '법정 예상 실수령액(세후)',
  en: 'Expected legal take-home (after tax)',
  zh: '法定预期实收（税后）',
  vi: 'Lương thực nhận dự kiến (sau thuế)',
);
const _receivedRowLabel = L10nText(
  ko: '실제 받은 금액',
  en: 'Actual amount received',
  zh: '实际到账金额',
  vi: 'Số tiền thực nhận',
);
const _gapLabel = L10nText(
  ko: '🚨 예상 미지급 체불액',
  en: '🚨 Estimated unpaid amount',
  zh: '🚨 预计未付欠薪额',
  vi: '🚨 Số tiền dự kiến bị nợ',
);
const _matchLabel = L10nText(
  ko: '✅ 계산 결과와 입금액이 거의 일치합니다',
  en: '✅ This matches what you received',
  zh: '✅ 计算结果与到账金额基本一致',
  vi: '✅ Kết quả khớp với số tiền đã nhận',
);
const _aiReasonLabel = L10nText(
  ko: '🔍 AI 원인분석 · 왜 차이가 나는지 보기',
  en: '🔍 AI breakdown · why the gap',
  zh: '🔍 AI原因分析 · 查看差异原因',
  vi: '🔍 Phân tích AI · vì sao chênh lệch',
);
const _aiReasonTitle = L10nText(
  ko: 'AI 체불 원인 분석',
  en: 'AI-matched reasons',
  zh: 'AI原因分析',
  vi: 'Phân tích nguyên nhân theo AI',
);
const _talkOptionTitle = L10nText(
  ko: '💬 사업주와 대화해보기',
  en: '💬 Try talking to your employer',
  zh: '💬 先与雇主沟通',
  vi: '💬 Thử nói chuyện với chủ',
);
const _talkOptionSubtitle = L10nText(
  ko: '노동청 신고 전 사장님과 대화로 원만히 해결을 시도합니다',
  en: 'Try to resolve it directly with your employer before filing',
  zh: '在申诉前先尝试与雇主直接沟通解决',
  vi: 'Thử giải quyết trực tiếp với chủ trước khi khiếu nại',
);
const _fileOptionTitle = L10nText(
  ko: '📄 진정서 작성 계속하기',
  en: '📄 Continue to the complaint form',
  zh: '📄 继续填写申诉书',
  vi: '📄 Tiếp tục viết đơn khiếu nại',
);
const _fileOptionSubtitle = L10nText(
  ko: '대화로 해결이 어려울 때 공식 서식을 채웁니다',
  en: "If talking doesn't work, fill in the official form",
  zh: '若沟通无效，可填写官方表格',
  vi: 'Nếu nói chuyện không hiệu quả, hãy điền mẫu chính thức',
);
const _copyLabel = L10nText(
  ko: '📋 문구 복사하기',
  en: '📋 Copy text',
  zh: '📋 复制文本',
  vi: '📋 Sao chép',
);
const _copiedLabel = L10nText(
  ko: '복사했습니다',
  en: 'Copied',
  zh: '已复制',
  vi: 'Đã sao chép',
);

const _payTypeHourLabel = L10nText(
  ko: '시급',
  en: 'Hourly',
  zh: '时薪',
  vi: 'Theo giờ',
);
const _payTypeDayLabel = L10nText(
  ko: '일급',
  en: 'Daily',
  zh: '日薪',
  vi: 'Theo ngày',
);
const _payTypeMonthLabel = L10nText(
  ko: '월급',
  en: 'Monthly',
  zh: '月薪',
  vi: 'Theo tháng',
);
const _sizeOver5Label = L10nText(
  ko: '5인 이상',
  en: '5 or more',
  zh: '5人以上',
  vi: 'Từ 5 người',
);
const _sizeUnder5Label = L10nText(
  ko: '5인 미만',
  en: 'Under 5',
  zh: '不足5人',
  vi: 'Dưới 5 người',
);
const _sizeUnknownLabel = L10nText(
  ko: '잘 모름',
  en: 'Not sure',
  zh: '不清楚',
  vi: 'Không rõ',
);

class WageCalcSection extends StatefulWidget {
  const WageCalcSection({
    super.key,
    required this.scratch,
    required this.lang,
    required this.accentColor,
    required this.onAdvance,
  });

  final WageCalcScratchController scratch;
  final AppLanguage lang;
  final Color accentColor;
  final VoidCallback onAdvance;

  @override
  State<WageCalcSection> createState() => _WageCalcSectionState();
}

class _WageCalcSectionState extends State<WageCalcSection> {
  final _payController = TextEditingController();
  final _weekHoursController = TextEditingController(text: '40');
  final _receivedController = TextEditingController();

  @override
  void dispose() {
    _payController.dispose();
    _weekHoursController.dispose();
    _receivedController.dispose();
    super.dispose();
  }

  void _openAiReasonPopup() {
    final lang = widget.lang;
    final result = widget.scratch.result;
    if (result == null) return;
    final text = explainGap(widget.scratch.input, result, lang);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _aiReasonTitle.of(lang),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: RichNote(
                    text,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                      height: 1.7,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openMessageTemplate() {
    final lang = widget.lang;
    final result = widget.scratch.result;
    final gapText = result != null
        ? formatWon(result.gapValue.abs(), lang)
        : '';
    final message = switch (lang) {
      AppLanguage.ko =>
        '사장님, 안녕하세요. 다름이 아니라 그동안 지급해주신 급여 내역을 법정 기준으로 계산해보니 약 $gapText의 차액이 확인되어 연락드렸습니다.\n\n혹시 계산 과정에서 누락이나 착오가 있으셨는지 바쁘시겠지만 한번 확인 부탁드립니다. 감사합니다.',
      AppLanguage.en =>
        'Hello, I calculated my pay against the legal standard and found a gap of about $gapText. Could you please check for any error or omission when you have a moment? Thank you.',
      AppLanguage.zh =>
        '老板您好，我按法定标准核算了工资，发现约有$gapText的差额。方便的话请您确认一下是否有遗漏或误差，谢谢。',
      AppLanguage.vi =>
        'Chào sếp, tôi đã tính lương theo chuẩn luật định và thấy chênh lệch khoảng $gapText. Sếp xem giúp có sai sót gì không ạ. Cảm ơn sếp.',
    };
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _talkOptionTitle.of(lang),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                message,
                style: const TextStyle(fontSize: 12, height: 1.6),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: message));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_copiedLabel.of(lang)),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
                child: Text(_copyLabel.of(lang)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.lang;
    final scratch = widget.scratch;
    return AnimatedBuilder(
      animation: scratch,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _sectionTitle.of(lang),
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _fieldLabel(_payTypeLabel.of(lang)),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 6,
                    children: [
                      _payTypeChip(PayType.hour, _payTypeHourLabel.of(lang)),
                      _payTypeChip(PayType.day, _payTypeDayLabel.of(lang)),
                      _payTypeChip(PayType.month, _payTypeMonthLabel.of(lang)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _numberField(_payLabel.of(lang), _payController, (v) {
                    scratch.update(
                      (c) => WageCalcInput(
                        periodMode: c.periodMode,
                        visa: c.visa,
                        payType: c.payType,
                        pay: double.tryParse(v) ?? 0,
                        weekHours: c.weekHours,
                        hireDate: c.hireDate,
                        leaveDate: c.leaveDate,
                        size: c.size,
                        received: c.received,
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  _numberField(_weekHoursLabel.of(lang), _weekHoursController, (
                    v,
                  ) {
                    scratch.update(
                      (c) => WageCalcInput(
                        periodMode: c.periodMode,
                        visa: c.visa,
                        payType: c.payType,
                        pay: c.pay,
                        weekHours: double.tryParse(v) ?? 40,
                        hireDate: c.hireDate,
                        leaveDate: c.leaveDate,
                        size: c.size,
                        received: c.received,
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  _dateField(_hireDateLabel.of(lang), scratch.input.hireDate, (
                    d,
                  ) {
                    scratch.update(
                      (c) => WageCalcInput(
                        periodMode: c.periodMode,
                        visa: c.visa,
                        payType: c.payType,
                        pay: c.pay,
                        weekHours: c.weekHours,
                        hireDate: d,
                        leaveDate: c.leaveDate,
                        size: c.size,
                        received: c.received,
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  _dateField(
                    _leaveDateLabel.of(lang),
                    scratch.input.leaveDate,
                    (d) {
                      scratch.update(
                        (c) => WageCalcInput(
                          periodMode: c.periodMode,
                          visa: c.visa,
                          payType: c.payType,
                          pay: c.pay,
                          weekHours: c.weekHours,
                          hireDate: c.hireDate,
                          leaveDate: d,
                          size: c.size,
                          received: c.received,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _fieldLabel(_sizeLabel.of(lang)),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 6,
                    children: [
                      _sizeChip(BizSize.over5, _sizeOver5Label.of(lang)),
                      _sizeChip(BizSize.under5, _sizeUnder5Label.of(lang)),
                      _sizeChip(BizSize.unknown, _sizeUnknownLabel.of(lang)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _numberField(_receivedLabel.of(lang), _receivedController, (
                    v,
                  ) {
                    scratch.update(
                      (c) => WageCalcInput(
                        periodMode: c.periodMode,
                        visa: c.visa,
                        payType: c.payType,
                        pay: c.pay,
                        weekHours: c.weekHours,
                        hireDate: c.hireDate,
                        leaveDate: c.leaveDate,
                        size: c.size,
                        received: double.tryParse(v) ?? 0,
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: scratch.calculate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(_calcButtonLabel.of(lang)),
                    ),
                  ),
                ],
              ),
            ),
            if (scratch.loaded) ...[
              const SizedBox(height: 11),
              _buildReportCard(lang, scratch.result!),
              const SizedBox(height: 9),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _openAiReasonPopup,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1E3A8A),
                    side: const BorderSide(color: Color(0xFFC9DBFA)),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                  child: Text(
                    _aiReasonLabel.of(lang),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _bigOption(
                icon: '💬',
                title: _talkOptionTitle.of(lang),
                subtitle: _talkOptionSubtitle.of(lang),
                onTap: _openMessageTemplate,
              ),
              const SizedBox(height: 8),
              _bigOption(
                icon: '📄',
                title: _fileOptionTitle.of(lang),
                subtitle: _fileOptionSubtitle.of(lang),
                onTap: widget.onAdvance,
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildReportCard(AppLanguage lang, WageCalcResult r) {
    final gap = r.gapValue;
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2947),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _reportRow(_expectedLabel.of(lang), formatWon(r.net ?? 0, lang)),
          _reportRow(_receivedRowLabel.of(lang), formatWon(r.received, lang)),
          const Divider(color: Colors.white24, height: 18),
          if (gap > 0)
            _reportRow(
              _gapLabel.of(lang),
              formatWon(gap, lang),
              emphasize: true,
            )
          else if (gap < 0)
            _reportRow(_matchLabel.of(lang), '', emphasize: false)
          else
            _reportRow(_matchLabel.of(lang), '', emphasize: false),
        ],
      ),
    );
  }

  Widget _reportRow(String label, String value, {bool emphasize = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: emphasize ? 12.5 : 11.5,
                color: const Color(0xFFA8BEDC),
              ),
            ),
          ),
          if (value.isNotEmpty)
            Text(
              value,
              style: TextStyle(
                fontSize: emphasize ? 15 : 13,
                fontWeight: FontWeight.w800,
                color: emphasize ? const Color(0xFFE8C88A) : Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: AppColors.textSecondary,
    ),
  );

  Widget _numberField(
    String label,
    TextEditingController controller,
    ValueChanged<String> onChanged,
  ) {
    return Row(
      children: [
        Expanded(flex: 3, child: _fieldLabel(label)),
        Expanded(
          flex: 2,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 12.5),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 9, vertical: 8),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _dateField(
    String label,
    DateTime? value,
    ValueChanged<DateTime> onPick,
  ) {
    return Row(
      children: [
        Expanded(flex: 3, child: _fieldLabel(label)),
        Expanded(
          flex: 2,
          child: InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: value ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) onPick(picked);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                value == null
                    ? '-'
                    : '${value.year}.${value.month.toString().padLeft(2, '0')}.${value.day.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _payTypeChip(PayType type, String label) {
    final selected = widget.scratch.input.payType == type;
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 11.5)),
      selected: selected,
      onSelected: (_) => widget.scratch.update(
        (c) => WageCalcInput(
          periodMode: c.periodMode,
          visa: c.visa,
          payType: type,
          pay: c.pay,
          weekHours: c.weekHours,
          hireDate: c.hireDate,
          leaveDate: c.leaveDate,
          size: c.size,
          received: c.received,
        ),
      ),
    );
  }

  Widget _sizeChip(BizSize size, String label) {
    final selected = widget.scratch.input.size == size;
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 11.5)),
      selected: selected,
      onSelected: (_) => widget.scratch.update(
        (c) => WageCalcInput(
          periodMode: c.periodMode,
          visa: c.visa,
          payType: c.payType,
          pay: c.pay,
          weekHours: c.weekHours,
          hireDate: c.hireDate,
          leaveDate: c.leaveDate,
          size: size,
          received: c.received,
        ),
      ),
    );
  }

  Widget _bigOption({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
