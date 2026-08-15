import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';
import '../controllers/form_values_controller.dart';
import '../controllers/wage_calc_scratch_controller.dart';
import '../models/flow_block.dart';
import '../widgets/flow_accordion.dart';
import '../widgets/flow_content_blocks.dart';
import '../widgets/flow_tracker.dart';
import '../widgets/form_editor.dart';
import '../widgets/injury_guide_section.dart';
import '../widgets/pdf_actions_section.dart';
import '../widgets/wage_calc_section.dart';

const _stepLabel = L10nText(
  ko: '이 단계는',
  en: 'This stage',
  zh: '这个阶段',
  vi: 'Giai đoạn này',
);
const _documentsLabel = L10nText(
  ko: '필요한 서류',
  en: 'Documents needed',
  zh: '所需文件',
  vi: 'Giấy tờ cần thiết',
);
const _watchOutLabel = L10nText(
  ko: '주의할 점',
  en: 'Things to watch out for',
  zh: '注意事项',
  vi: 'Điều cần lưu ý',
);
const _homeLabel = L10nText(
  ko: '홈으로 돌아가기',
  en: 'Back to home',
  zh: '返回首页',
  vi: 'Quay về trang chủ',
);
const _nextLabel = L10nText(ko: '다음', en: 'Next', zh: '下一步', vi: 'Tiếp theo');
const _prevLabel = L10nText(
  ko: '이전',
  en: 'Previous',
  zh: '上一步',
  vi: 'Quay lại',
);
const _markCompleteLabel = L10nText(
  ko: '✓ 이 단계 완료로 표시',
  en: '✓ Mark this stage complete',
  zh: '✓ 标记此阶段完成',
  vi: '✓ Đánh dấu hoàn thành giai đoạn này',
);
const _undoCompleteLabel = L10nText(
  ko: '완료 표시를 취소합니다',
  en: 'Undo complete',
  zh: '取消完成标记',
  vi: 'Bỏ đánh dấu hoàn thành',
);

/// 임금체불/산재 내비게이터 공용 엔진. 프론트엔드_구상_확장.html의 `.sheet.down`
/// 내비게이터 플로우(nf-head/stepper/nf-body/nf-foot + tracker/pop) 형식을 그대로 옮겼다.
/// 안전 원칙: 어떤 단계에서도 새 법적 판단 문장을 생성하지 않는다 — 전부 사전 검수된
/// 정적 콘텐츠(FlowDefinition)만 렌더링한다.
class NavigatorFlowScreen extends StatefulWidget {
  const NavigatorFlowScreen({
    super.key,
    required this.title,
    required this.definition,
  });

  final L10nText title;
  final FlowDefinition definition;

  @override
  State<NavigatorFlowScreen> createState() => _NavigatorFlowScreenState();
}

class _NavigatorFlowScreenState extends State<NavigatorFlowScreen> {
  int _stepIndex = 0;
  final _selectedOption = <int, int>{};
  final _checkedItems = <int, Set<int>>{};
  final _rawControllers = <int, TextEditingController>{};

  /// 트래커에서 사용자가 직접 "완료로 표시"한 단계 — 세션 한정 상태(재시작 시 초기화),
  /// UserProfileController/EncyclopediaController와 동일한 인메모리 컨벤션을 따른다.
  final _completedStages = <int>{};

  /// 진정서/신청서 서식 입력값 — 화면 인스턴스당 하나, 세션 한정.
  late final _formValues = FormValuesController();
  late final _wageScratch = WageCalcScratchController();
  final _importedSources = <ImportSource>{};

  Color get _accentColor => widget.definition.accent == FlowAccent.amber
      ? AppColors.accent
      : AppColors.secondary;
  Color get _accentBg => widget.definition.accent == FlowAccent.amber
      ? const Color(0xFFFEF3E2)
      : const Color(0xFFE6F6F4);
  Color get _accentText => widget.definition.accent == FlowAccent.amber
      ? const Color(0xFFB45309)
      : const Color(0xFF0B7267);

  @override
  void dispose() {
    for (final c in _rawControllers.values) {
      c.dispose();
    }
    _formValues.dispose();
    _wageScratch.dispose();
    super.dispose();
  }

  TextEditingController _rawControllerFor(int stepIndex) =>
      _rawControllers.putIfAbsent(stepIndex, TextEditingController.new);

  void _openTrackerPop(int stageIndex) {
    final lang = UserProfileScope.of(context).language;
    final stage = widget.definition.track[stageIndex];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final done = _completedStages.contains(stageIndex);
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          stage.label.of(lang),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, size: 18),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  PopBlock(
                    label: _stepLabel.of(lang),
                    value: stage.whatHappens.of(lang),
                  ),
                  PopBlock(
                    label: _documentsLabel.of(lang),
                    value: stage.documentsNeeded.of(lang),
                  ),
                  PopBlock(
                    label: _watchOutLabel.of(lang),
                    value: stage.watchOutFor.of(lang),
                  ),
                  if (stage.extra != null)
                    PopBlock(label: '', value: stage.extra!.of(lang)),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          if (!_completedStages.add(stageIndex)) {
                            _completedStages.remove(stageIndex);
                          }
                        });
                        setSheetState(() {});
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: done
                            ? AppColors.textMuted
                            : AppColors.secondary,
                        side: BorderSide(
                          color: done ? AppColors.border : AppColors.secondary,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                      ),
                      child: Text(
                        (done ? _undoCompleteLabel : _markCompleteLabel).of(
                          lang,
                        ),
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _goToStep(int index) {
    setState(
      () => _stepIndex = index.clamp(0, widget.definition.steps.length - 1),
    );
  }

  void _openStepHelp(StepHelp help, AppLanguage lang) {
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
            Row(
              children: [
                Text(help.icon, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    help.title.of(lang),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              help.body.of(lang),
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _next() {
    // 경위 서술 단계(RawTextBlock)를 지나칠 때 원문 그대로 서식의 'content'
    // 필드로 옮긴다 — FormFieldSpec.tag가 raw인 필드는 이렇게 손대지 않고
    // 그대로 옮겨진다는 게 보장돼야 한다.
    final rawController = _rawControllers[_stepIndex];
    if (rawController != null) {
      _formValues.setValue('content', rawController.text);
    }
    if (_stepIndex == widget.definition.steps.length - 1) {
      Navigator.of(context).pop();
      return;
    }
    _goToStep(_stepIndex + 1);
  }

  void _prev() => _goToStep(_stepIndex - 1);

  @override
  Widget build(BuildContext context) {
    final lang = UserProfileScope.of(context).language;
    final steps = widget.definition.steps;
    final step = steps[_stepIndex];
    final isLast = _stepIndex == steps.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _FlowHeader(
              title: widget.title.of(lang),
              stepIndex: _stepIndex,
              totalSteps: steps.length,
              accentBg: _accentBg,
              accentText: _accentText,
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(15, 14, 15, 20),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          step.title.of(lang),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            height: 1.35,
                          ),
                        ),
                      ),
                      if (step.help case final help?)
                        InkWell(
                          onTap: () => _openStepHelp(help, lang),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 22,
                            height: 22,
                            margin: const EdgeInsets.only(left: 6),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              '❓',
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    step.lead.of(lang),
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textMuted,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 13),
                  for (final block in step.blocks) _buildBlock(block, lang),
                ],
              ),
            ),
            _FlowFooter(
              showPrev: _stepIndex > 0,
              nextLabel: (isLast ? _homeLabel : _nextLabel).of(lang),
              prevLabel: _prevLabel.of(lang),
              accentColor: AppColors.primary,
              onPrev: _prev,
              onNext: _next,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlock(FlowBlock block, AppLanguage lang) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: switch (block) {
        OptionsBlock(:final items) => OptionsList(
          items: items,
          lang: lang,
          selectedIndex: _selectedOption[_stepIndex],
          onSelect: (i) => setState(() => _selectedOption[_stepIndex] = i),
        ),
        NoticeBlock(:final tone, :final title, :final body) => NoticeBox(
          tone: tone,
          title: title.of(lang),
          body: body.of(lang),
        ),
        ChecklistBlock(:final items) => ChecklistCard(
          items: items,
          lang: lang,
          checked: _checkedItems[_stepIndex] ?? const {},
          onToggle: (i) => setState(() {
            final set = _checkedItems.putIfAbsent(_stepIndex, () => {});
            if (!set.add(i)) set.remove(i);
          }),
        ),
        RawTextBlock(:final placeholder) => TextField(
          controller: _rawControllerFor(_stepIndex),
          minLines: 4,
          maxLines: 8,
          style: const TextStyle(fontSize: 12),
          decoration: InputDecoration(
            hintText: placeholder.of(lang),
            hintStyle: const TextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
              height: 1.5,
            ),
            filled: true,
            fillColor: const Color(0xFFFBFDFF),
            contentPadding: const EdgeInsets.all(11),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
        ),
        FillCardBlock(:final rows) => FillCard(rows: rows, lang: lang),
        TrackerBlock(:final now) => TrackerCard(
          title: widget.title.of(lang),
          accentColor: _accentColor,
          stages: widget.definition.track,
          lang: lang,
          now: now,
          completedStages: _completedStages,
          onTapStage: _openTrackerPop,
        ),
        ListBlock(:final items, :final numbered) => ListBlockView(
          items: items,
          numbered: numbered,
          lang: lang,
        ),
        OrgCardBlock(
          :final name,
          :final subtitle,
          :final phone,
          :final legalBasis,
          :final tags,
        ) =>
          OrgCardView(
            name: name,
            subtitle: subtitle,
            phone: phone,
            legalBasis: legalBasis,
            tags: tags,
            lang: lang,
          ),
        AccordionBlock(:final items) => AccordionList(
          items: items,
          lang: lang,
          accentColor: _accentColor,
        ),
        LegendBlock() => LegendView(lang: lang),
        EncyclopediaLinkBlock(:final label) => SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Text('📖'),
            label: Text(label.of(lang)),
            style: OutlinedButton.styleFrom(
              foregroundColor: _accentColor,
              side: BorderSide(color: _accentColor),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        ImportButtonsBlock(:final sources) => ImportButtonsRow(
          sources: sources,
          imported: _importedSources,
          lang: lang,
          onImport: _handleImport,
        ),
        FormEditBlock(
          :final sections,
          :final documentTitle,
          :final formSubtitle,
        ) =>
          FormEditorView(
            sections: sections,
            values: _formValues,
            lang: lang,
            documentTitle: documentTitle,
            formSubtitle: formSubtitle,
          ),
        FormReviewBlock(
          :final sections,
          :final documentTitle,
          :final formSubtitle,
        ) =>
          FormReviewView(
            sections: sections,
            values: _formValues,
            lang: lang,
            documentTitle: documentTitle,
            formSubtitle: formSubtitle,
          ),
        PdfActionsBlock(:final sections, :final documentTitle) =>
          PdfActionsSection(
            documentTitle: documentTitle,
            sections: sections,
            values: _formValues,
            lang: lang,
            filePrefix: widget.title.ko,
          ),
        WageCalcBlock() => WageCalcSection(
          scratch: _wageScratch,
          lang: lang,
          accentColor: _accentColor,
          onAdvance: _next,
        ),
        // 임금 플로우에선 쓰이지 않는 블록.
        MessageTemplateBlock() => const SizedBox.shrink(),
        InjuryGuideBlock(
          :final accidentCards,
          :final illnessCards,
          :final delegateJumpToStep,
        ) =>
          InjuryGuideView(
            accidentCards: accidentCards,
            illnessCards: illnessCards,
            currentType: _selectedOption[0],
            onTypeChanged: (i) => setState(() => _selectedOption[0] = i),
            onDelegate: () => _goToStep(delegateJumpToStep),
            onSelfFile: _next,
            lang: lang,
            accentColor: _accentColor,
          ),
      },
    );
  }

  void _handleImport(ImportSource source) {
    setState(() => _importedSources.add(source));
    if (source == ImportSource.calcResult && _wageScratch.loaded) {
      final input = _wageScratch.input;
      _formValues.setValue('workers', input.size.name);
      if (input.hireDate != null) {
        _formValues.setValue(
          'start',
          input.hireDate!.toIso8601String().split('T').first,
        );
      }
      if (input.leaveDate != null) {
        _formValues.setValue(
          'end',
          input.leaveDate!.toIso8601String().split('T').first,
        );
        _formValues.setValue('resigned', 'resigned');
      } else {
        _formValues.setValue('resigned', 'working');
      }
    }
    final lang = UserProfileScope.of(context).language;
    _formValues.setValue(
      'attach',
      _importedSources.map((s) => _importSourceLabel(s).of(lang)).join(' · '),
    );
  }
}

const _attachWorkLogLabel = L10nText(
  ko: '근무기록장',
  en: 'Work log',
  zh: '工作记录',
  vi: 'Nhật ký làm việc',
);
const _attachPayslipLabel = L10nText(
  ko: '임금명세서',
  en: 'Payslip',
  zh: '工资单',
  vi: 'Phiếu lương',
);
const _attachCalcLabel = L10nText(
  ko: '계산기 데이터',
  en: 'Calculator data',
  zh: '计算器数据',
  vi: 'Dữ liệu máy tính lương',
);
const _attachProfileLabel = L10nText(
  ko: '프로필 정보',
  en: 'Profile info',
  zh: '个人资料',
  vi: 'Thông tin hồ sơ',
);

L10nText _importSourceLabel(ImportSource source) => switch (source) {
  ImportSource.workLog => _attachWorkLogLabel,
  ImportSource.payslip => _attachPayslipLabel,
  ImportSource.calcResult => _attachCalcLabel,
  ImportSource.profile => _attachProfileLabel,
};

class _FlowHeader extends StatelessWidget {
  const _FlowHeader({
    required this.title,
    required this.stepIndex,
    required this.totalSteps,
    required this.accentBg,
    required this.accentText,
    required this.onBack,
  });

  final String title;
  final int stepIndex;
  final int totalSteps;
  final Color accentBg;
  final Color accentText;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 14, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back, size: 19),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: accentBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${stepIndex + 1} / $totalSteps',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: accentText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            children: List.generate(totalSteps, (i) {
              final color = i < stepIndex
                  ? AppColors.secondary
                  : i == stepIndex
                  ? AppColors.primary
                  : AppColors.border;
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

class _FlowFooter extends StatelessWidget {
  const _FlowFooter({
    required this.showPrev,
    required this.nextLabel,
    required this.prevLabel,
    required this.accentColor,
    required this.onPrev,
    required this.onNext,
  });

  final bool showPrev;
  final String nextLabel;
  final String prevLabel;
  final Color accentColor;
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
      child: Row(
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
                child: Text(
                  prevLabel,
                  style: const TextStyle(
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
