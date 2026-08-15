import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../common/widgets/rich_note.dart';
import '../../../core/app_language.dart';
import '../../../theme/app_colors.dart';
import '../../wage_calculator/models/wage_diagnosis.dart';
import '../../wage_calculator/screens/wage_calculator_screen.dart';
import '../controllers/wage_calc_scratch_controller.dart';
import '../models/flow_block.dart' show NoticeTone;
import 'flow_content_blocks.dart' show NoticeBox;

const _calcRunTitle = L10nText(
  ko: '정밀 임금계산기 바로 실행하기',
  en: 'Run the precise calculator',
  zh: '立即运行精密工资计算器',
  vi: 'Chạy máy tính lương chính xác',
);
const _calcRunSubtitle = L10nText(
  ko: '계산 안 해보신 분',
  en: "Haven't calculated yet",
  zh: '尚未计算过',
  vi: 'Nếu bạn chưa tính',
);
const _calcLoadTitle = L10nText(
  ko: '임금계산기 데이터 불러오기',
  en: 'Load calculator data',
  zh: '导入工资计算器数据',
  vi: 'Tải dữ liệu máy tính lương',
);
const _calcLoadSubtitle = L10nText(
  ko: '이미 계산해보신 분',
  en: 'Already calculated',
  zh: '已经计算过',
  vi: 'Nếu bạn đã tính rồi',
);
const _calcAlreadyLoadedToast = L10nText(
  ko: '이미 최신 계산 데이터를 사용 중입니다',
  en: 'Already using your latest calculation',
  zh: '已在使用最新的计算数据',
  vi: 'Đang dùng dữ liệu tính toán mới nhất',
);
const _calcNotYetAvailableToast = L10nText(
  ko: '아직 계산한 데이터가 없습니다. 위 버튼으로 정밀 임금계산기를 먼저 실행해주세요.',
  en: 'No calculation yet. Please run the precise calculator with the button above first.',
  zh: '尚无计算数据，请先用上方按钮运行精密工资计算器。',
  vi: 'Chưa có dữ liệu tính toán. Hãy chạy máy tính lương chính xác bằng nút bên trên trước.',
);
const _reportEmptyText = L10nText(
  ko: '아직 계산 데이터가 없습니다. 위 버튼으로 임금계산기를 실행하거나 데이터를 불러오세요.',
  en: 'No calculation yet. Use the buttons above to run the calculator or load your data.',
  zh: '尚无计算数据，请用上方按钮运行计算器或导入数据。',
  vi: 'Chưa có dữ liệu tính toán. Hãy dùng nút bên trên để chạy máy tính hoặc tải dữ liệu.',
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
const _calcDiffLabel = L10nText(
  ko: 'ℹ️ 계산 방식 차이로 보이는 금액',
  en: 'ℹ️ Likely a calculation-method difference',
  zh: 'ℹ️ 可能是计算方式差异',
  vi: 'ℹ️ Có vẻ là khác biệt cách tính',
);
const _refEstimateTitle = L10nText(
  ko: '⚠ 이 금액은 참고용 예상액입니다',
  en: '⚠ This is a reference estimate',
  zh: '⚠ 此金额仅供参考',
  vi: '⚠ Số tiền này chỉ để tham khảo',
);
const _refEstimateBody = L10nText(
  ko: '근로기준법 기본 공식을 적용한 추정치이며, 정확한 체불액은 근로감독관 조사에서 산정됩니다. 계산기 결과는 진정서로 자동으로 넘어가지 않습니다.',
  en: "This applies the basic formulas of the Labor Standards Act; the confirmed amount is determined by a labor inspector. The result is not carried into the complaint automatically.",
  zh: '此为适用《劳动基准法》基本公式的推算值，确切欠薪额由劳动监督官调查核定。计算结果不会自动带入申诉书。',
  vi: 'Đây là ước tính theo công thức cơ bản của Luật Tiêu chuẩn Lao động, số chính thức do thanh tra lao động xác định. Kết quả không tự chuyển sang đơn.',
);
const _aiReasonLabelPos = L10nText(
  ko: '🔍 AI 체불 원인 분석 · 왜 더 받아야 하는지 근거 보기',
  en: '🔍 AI breakdown · why you may be owed more',
  zh: '🔍 AI原因分析·查看应多收依据',
  vi: '🔍 Phân tích AI · vì sao bạn nên nhận thêm',
);
const _aiReasonLabelOther = L10nText(
  ko: '🔍 금액 차이 원인 보기',
  en: '🔍 See why the amounts differ',
  zh: '🔍 查看金额差异原因',
  vi: '🔍 Xem lý do chênh lệch',
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
const _usageInfoLabel = L10nText(
  ko: '💡 이용 안내',
  en: '💡 How to use this',
  zh: '💡 使用说明',
  vi: '💡 Hướng dẫn sử dụng',
);
const _usageInfoBody = L10nText(
  ko: '아래 문장을 복사해 사장님이나 담당자에게 카카오톡·문자로 보내보세요.',
  en: 'Copy the message below and send it to your employer.',
  zh: '复制以下内容发送给雇主或负责人。',
  vi: 'Sao chép câu bên dưới và gửi cho chủ.',
);
const _viewTranslatedLabel = L10nText(
  ko: '🌐 내 언어로 보기',
  en: '🌐 View in my language',
  zh: '🌐 查看我的语言版',
  vi: '🌐 Xem bằng tiếng của tôi',
);
const _viewKoreanLabel = L10nText(
  ko: '🇰🇷 한국어로 보기',
  en: '🇰🇷 View in Korean',
  zh: '🇰🇷 查看韩语版',
  vi: '🇰🇷 Xem bằng tiếng Hàn',
);
const _amtPlaceholder = L10nText(
  ko: '(임금계산기로 먼저 확인해주세요)',
  en: '(please check with the wage calculator first)',
  zh: '（请先用工资计算器确认）',
  vi: '(hãy kiểm tra bằng máy tính lương trước)',
);
const _dontSignTitle = L10nText(
  ko: '⚠ 돈을 받기 전에는 서명하지 마세요',
  en: '⚠ Do not sign anything before you are paid',
  zh: '⚠ 收到钱之前不要签字',
  vi: '⚠ Đừng ký gì trước khi nhận tiền',
);
const _dontSignBody = L10nText(
  ko: "통장으로 실제 입금받기 전에는 '합의서'나 '진정 취하서'에 절대 서명하지 마세요.",
  en: 'Never sign a settlement or withdrawal letter before the money actually arrives.',
  zh: '在钱实际入账之前，切勿签署"和解书"或"撤诉书"。',
  vi: "Tuyệt đối đừng ký 'thỏa thuận' hay 'đơn rút' trước khi tiền thực sự vào tài khoản.",
);

/// 임금체불 내비게이터 2단계 "체불액을 확인하고 방법을 고르세요"의 본문.
/// html_files/임금체불네비게이터_완성본.html의 blocks:[calcbtns, report,
/// aireason, options2]를 그대로 옮겼다 — 계산 입력 자체는 이 화면에 없고,
/// 이미 앱에 있는 정밀 5단계 계산기(WageCalculatorScreen)를 새 화면으로 열어
/// 결과만 콜백으로 돌려받는다("이 화면과는 별개의 로컬 상태" 원칙 유지).
class WageCalcSection extends StatelessWidget {
  const WageCalcSection({
    super.key,
    required this.scratch,
    required this.lang,
    required this.onAdvance,
  });

  final WageCalcScratchController scratch;
  final AppLanguage lang;
  final VoidCallback onAdvance;

  String _gapKind(WageCalcResult r) {
    final gap = r.gapValue;
    if (gap.abs() < 10000) return 'zero';
    return gap > 0 ? 'pos' : 'neg';
  }

  void _runPreciseCalculator(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WageCalculatorScreen(
          onUseResult: (input) {
            scratch.update((_) => input);
            scratch.calculate();
          },
        ),
      ),
    );
  }

  void _loadCalcData(BuildContext context) {
    final message = scratch.loaded
        ? _calcAlreadyLoadedToast.of(lang)
        : _calcNotYetAvailableToast.of(lang);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _openAiReasonPopup(BuildContext context) {
    final result = scratch.result;
    if (result == null) return;
    final text = explainGap(scratch.input, result, lang);
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

  void _openMessageTemplate(BuildContext context) {
    final result = scratch.result;
    final hasAmt = result != null && _gapKind(result) == 'pos';
    final gapText = hasAmt
        ? formatWon(result.gapValue.abs(), lang)
        : _amtPlaceholder.of(lang);
    // 수신자(사장님)는 한국어 사용자이므로 기본 노출은 항상 한국어다 — 앱
    // 언어 설정과 무관하게. "내 언어로 보기"는 보내기 전 뜻을 확인하려는
    // 이용자 본인을 위한 토글일 뿐, 기본값을 바꾸지 않는다.
    final messageKo =
        '사장님, 안녕하세요. 다름이 아니라 그동안 지급해주신 급여 내역을 법정 기준으로 계산해보니 약 $gapText의 차액이 확인되어 연락드렸습니다.\n\n혹시 계산 과정에서 누락이나 착오가 있으셨는지 바쁘시겠지만 한번 확인 부탁드립니다. 감사합니다.';
    final messageTranslated = switch (lang) {
      AppLanguage.ko => messageKo,
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
      // 이용안내·번역토글·서명주의 문구가 늘어나며 기본 바텀시트 높이를 넘을 수
      // 있다 — isScrollControlled 없이는 넘치는 부분이 히트테스트되지 않는다.
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        var showingTranslated = false;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final currentMessage = showingTranslated
                ? messageTranslated
                : messageKo;
            return Padding(
              padding: EdgeInsets.fromLTRB(
                18,
                16,
                18,
                24 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
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
                    Text(
                      _usageInfoLabel.of(lang),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _usageInfoBody.of(lang),
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                        height: 1.5,
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
                        currentMessage,
                        style: const TextStyle(fontSize: 12, height: 1.6),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              await Clipboard.setData(
                                ClipboardData(text: currentMessage),
                              );
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
                        if (lang != AppLanguage.ko) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => setSheetState(
                                () => showingTranslated = !showingTranslated,
                              ),
                              child: Text(
                                (showingTranslated
                                        ? _viewKoreanLabel
                                        : _viewTranslatedLabel)
                                    .of(lang),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),
                    NoticeBox(
                      tone: NoticeTone.amber,
                      title: _dontSignTitle.of(lang),
                      body: _dontSignBody.of(lang),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scratch,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _CalcButton(
                    icon: '🧮',
                    title: _calcRunTitle.of(lang),
                    subtitle: _calcRunSubtitle.of(lang),
                    tone: _CalcButtonTone.primary,
                    onTap: () => _runPreciseCalculator(context),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _CalcButton(
                    icon: '📋',
                    title: _calcLoadTitle.of(lang),
                    subtitle: _calcLoadSubtitle.of(lang),
                    tone: scratch.loaded
                        ? _CalcButtonTone.loaded
                        : _CalcButtonTone.neutral,
                    onTap: () => _loadCalcData(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 11),
            if (scratch.loaded)
              _buildReportCard(lang, scratch.result!)
            else
              _buildEmptyReportCard(),
            const SizedBox(height: 9),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: scratch.loaded
                    ? () => _openAiReasonPopup(context)
                    : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1E3A8A),
                  disabledForegroundColor: AppColors.textMuted,
                  side: BorderSide(
                    color: scratch.loaded
                        ? const Color(0xFFC9DBFA)
                        : AppColors.border,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                ),
                child: Text(
                  (scratch.loaded && _gapKind(scratch.result!) == 'pos'
                          ? _aiReasonLabelPos
                          : _aiReasonLabelOther)
                      .of(lang),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 14),
            _bigOption(
              icon: '💬',
              title: _talkOptionTitle.of(lang),
              subtitle: _talkOptionSubtitle.of(lang),
              onTap: () => _openMessageTemplate(context),
            ),
            const SizedBox(height: 8),
            _bigOption(
              icon: '📄',
              title: _fileOptionTitle.of(lang),
              subtitle: _fileOptionSubtitle.of(lang),
              onTap: onAdvance,
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyReportCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Text(
        _reportEmptyText.of(lang),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 11.5,
          color: AppColors.textMuted,
          height: 1.7,
        ),
      ),
    );
  }

  /// 1만원 미만 차이는 반올림·계산 오차로 보고 일치("zero")로 처리한다.
  /// 실입금액이 계산값보다 많으면 체불이 아니라 계산 방식 차이("neg")다.
  Widget _buildReportCard(AppLanguage lang, WageCalcResult r) {
    final gap = r.gapValue;
    final kind = _gapKind(r);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: const Color(0xFF0F2947),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _reportRow(_expectedLabel.of(lang), formatWon(r.net ?? 0, lang)),
              _reportRow(
                _receivedRowLabel.of(lang),
                formatWon(r.received, lang),
              ),
              const Divider(color: Colors.white24, height: 18),
              if (kind == 'pos')
                _reportRow(
                  _gapLabel.of(lang),
                  formatWon(gap, lang),
                  emphasize: true,
                )
              else if (kind == 'neg')
                _reportRow(
                  _calcDiffLabel.of(lang),
                  formatWon(gap.abs(), lang),
                  emphasize: false,
                )
              else
                _reportRow(_matchLabel.of(lang), '', emphasize: false),
            ],
          ),
        ),
        const SizedBox(height: 9),
        NoticeBox(
          tone: NoticeTone.amber,
          title: _refEstimateTitle.of(lang),
          body: _refEstimateBody.of(lang),
        ),
      ],
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

enum _CalcButtonTone { primary, loaded, neutral }

/// calcbtns 블록의 버튼 하나. 정밀 계산기 실행(파란 강조)과 데이터 불러오기
/// (이미 불러왔으면 청록 강조)를 나란히 보여준다.
class _CalcButton extends StatelessWidget {
  const _CalcButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tone,
    required this.onTap,
  });

  final String icon;
  final String title;
  final String subtitle;
  final _CalcButtonTone tone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (bg, border) = switch (tone) {
      _CalcButtonTone.primary => (
        const Color(0xFFF3F7FF),
        const Color(0xFFBFDBFE),
      ),
      _CalcButtonTone.loaded => (
        const Color(0xFFEAF7F5),
        const Color(0xFFB4E0D9),
      ),
      _CalcButtonTone.neutral => (Colors.white, AppColors.border),
    };
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 9.5,
                color: AppColors.textMuted,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
