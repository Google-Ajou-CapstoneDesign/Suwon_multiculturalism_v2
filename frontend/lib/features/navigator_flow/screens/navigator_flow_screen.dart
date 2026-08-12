import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';
import '../models/flow_block.dart';

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
    super.dispose();
  }

  TextEditingController _rawControllerFor(int stepIndex) =>
      _rawControllers.putIfAbsent(stepIndex, TextEditingController.new);

  void _openTrackerPop(TrackStage stage) {
    final lang = UserProfileScope.of(context).language;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
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
              _PopBlock(
                label: _stepLabel.of(lang),
                value: stage.whatHappens.of(lang),
              ),
              _PopBlock(
                label: _documentsLabel.of(lang),
                value: stage.documentsNeeded.of(lang),
              ),
              _PopBlock(
                label: _watchOutLabel.of(lang),
                value: stage.watchOutFor.of(lang),
              ),
            ],
          ),
        );
      },
    );
  }

  void _next() {
    if (_stepIndex == widget.definition.steps.length - 1) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _stepIndex++);
  }

  void _prev() => setState(() => _stepIndex--);

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
                  Text(
                    step.title.of(lang),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1.35,
                    ),
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
        OptionsBlock(:final items) => _OptionsList(
          items: items,
          lang: lang,
          selectedIndex: _selectedOption[_stepIndex],
          onSelect: (i) => setState(() => _selectedOption[_stepIndex] = i),
        ),
        NoticeBlock(:final tone, :final title, :final body) => _NoticeBox(
          tone: tone,
          title: title.of(lang),
          body: body.of(lang),
        ),
        ChecklistBlock(:final items) => _ChecklistCard(
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
        FillCardBlock(:final rows) => _FillCard(rows: rows, lang: lang),
        TrackerBlock(:final now) => _TrackerCard(
          title: widget.title.of(lang),
          accentColor: _accentColor,
          stages: widget.definition.track,
          lang: lang,
          now: now,
          onTapStage: _openTrackerPop,
        ),
      },
    );
  }
}

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

class _OptionsList extends StatelessWidget {
  const _OptionsList({
    required this.items,
    required this.lang,
    required this.selectedIndex,
    required this.onSelect,
  });
  final List<FlowOption> items;
  final AppLanguage lang;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (i) {
        final item = items[i];
        final selected = selectedIndex == i;
        return Padding(
          padding: const EdgeInsets.only(bottom: 9),
          child: InkWell(
            onTap: () => onSelect(i),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFF3F7FF) : Colors.white,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.border,
                  width: selected ? 1.5 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.emoji, style: const TextStyle(fontSize: 17)),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title.of(lang),
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.subtitle.of(lang),
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: AppColors.textMuted,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _NoticeBox extends StatelessWidget {
  const _NoticeBox({
    required this.tone,
    required this.title,
    required this.body,
  });
  final NoticeTone tone;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final (bg, border, titleColor, bodyColor) = switch (tone) {
      NoticeTone.amber => (
        const Color(0xFFFFF8EC),
        const Color(0xFFF5D9A8),
        const Color(0xFF92400E),
        const Color(0xFFA16207),
      ),
      NoticeTone.blue => (
        const Color(0xFFF0F5FF),
        const Color(0xFFC9DBFA),
        const Color(0xFF1E3A8A),
        const Color(0xFF2A4C90),
      ),
      NoticeTone.teal => (
        const Color(0xFFEAF7F5),
        const Color(0xFFB4E0D9),
        const Color(0xFF0B7267),
        const Color(0xFF0F766E),
      ),
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: TextStyle(fontSize: 11, color: bodyColor, height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard({
    required this.items,
    required this.lang,
    required this.checked,
    required this.onToggle,
  });
  final List<L10nText> items;
  final AppLanguage lang;
  final Set<int> checked;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final isChecked = checked.contains(i);
          return InkWell(
            onTap: () => onToggle(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: i < items.length - 1
                        ? const Color(0xFFF1F5F9)
                        : Colors.transparent,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: isChecked
                          ? AppColors.secondary
                          : Colors.transparent,
                      border: Border.all(
                        color: isChecked
                            ? AppColors.secondary
                            : const Color(0xFFCBD5E1),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: isChecked
                        ? const Icon(Icons.check, size: 10, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      items[i].of(lang),
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF334155),
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _FillCard extends StatelessWidget {
  const _FillCard({required this.rows, required this.lang});
  final List<FlowFillRow> rows;
  final AppLanguage lang;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: List.generate(rows.length, (i) {
          final row = rows[i];
          final (
            valueColor,
            italic,
            badgeBg,
            badgeColor,
            badgeLabel,
          ) = switch (row.tag) {
            FillTag.auto => (
              const Color(0xFF0B7267),
              false,
              const Color(0xFFE6F6F4),
              const Color(0xFF0B7267),
              'AUTO',
            ),
            FillTag.raw => (
              const Color(0xFF0F172A),
              false,
              const Color(0xFFEEF3FE),
              const Color(0xFF1D4ED8),
              'RAW',
            ),
            FillTag.blank => (
              const Color(0xFFB9C4D2),
              true,
              const Color(0xFFF1F5F9),
              const Color(0xFF94A3B8),
              'BLANK',
            ),
          };

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: i < rows.length - 1
                      ? const Color(0xFFF1F5F9)
                      : Colors.transparent,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 82,
                  child: Text(
                    row.label.of(lang),
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    row.value.of(lang),
                    style: TextStyle(
                      fontSize: 12,
                      color: valueColor,
                      fontWeight: row.tag == FillTag.auto
                          ? FontWeight.w600
                          : FontWeight.w400,
                      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badgeLabel,
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                      color: badgeColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _TrackerCard extends StatelessWidget {
  const _TrackerCard({
    required this.title,
    required this.accentColor,
    required this.stages,
    required this.lang,
    required this.now,
    required this.onTapStage,
  });
  final String title;
  final Color accentColor;
  final List<TrackStage> stages;
  final AppLanguage lang;
  final int now;
  final ValueChanged<TrackStage> onTapStage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${now + 1} / ${stages.length}',
                style: const TextStyle(
                  fontSize: 9.5,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(stages.length, (i) {
                final done = i < now;
                final isNow = i == now;
                final color = done
                    ? AppColors.secondary
                    : (isNow ? AppColors.accent : const Color(0xFFCBD5E1));
                return SizedBox(
                  width: 58,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 2,
                              color: i == 0
                                  ? Colors.transparent
                                  : (i <= now
                                        ? AppColors.secondary
                                        : const Color(0xFFE2E8F0)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      InkWell(
                        onTap: () => onTapStage(stages[i]),
                        borderRadius: BorderRadius.circular(20),
                        child: Column(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: done || isNow
                                    ? color
                                    : const Color(0xFFCBD5E1),
                                shape: BoxShape.circle,
                                boxShadow: isNow
                                    ? [
                                        const BoxShadow(
                                          color: Color(0xFFFDF0DC),
                                          blurRadius: 0,
                                          spreadRadius: 4,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                done ? '✓' : '${i + 1}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              stages[i].label.of(lang),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 8.5,
                                color: done || isNow
                                    ? AppColors.textSecondary
                                    : AppColors.textMuted,
                                fontWeight: done || isNow
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _PopBlock extends StatelessWidget {
  const _PopBlock({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF334155),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
