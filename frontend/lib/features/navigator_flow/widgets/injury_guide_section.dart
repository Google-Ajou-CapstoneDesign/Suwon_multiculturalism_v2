import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../theme/app_colors.dart';
import '../models/flow_block.dart';

const _accidentToggleLabel = L10nText(
  ko: '💥 사고성 재해 가이드 보기',
  en: '💥 View accident guidance',
  zh: '💥 查看事故性灾害指南',
  vi: '💥 Xem hướng dẫn tai nạn',
);
const _illnessToggleLabel = L10nText(
  ko: '🩺 질병성 재해 가이드 보기',
  en: '🩺 View illness guidance',
  zh: '🩺 查看疾病性灾害指南',
  vi: '🩺 Xem hướng dẫn bệnh nghề nghiệp',
);
const _stageBadgeHint = L10nText(
  ko: '💡 안내를 확인하셨나요? 원하시는 산재 신청 방식을 선택하세요.',
  en: "💡 Have you read the guidance? Choose how you'd like to file.",
  zh: '💡 您看过说明了吗？请选择您想要的申请方式。',
  vi: '💡 Bạn đã đọc hướng dẫn chưa? Hãy chọn cách bạn muốn nộp đơn.',
);
const _delegateTitle = L10nText(
  ko: '🏥 병원 원무과 대행 제출로 끝내기 (안내 종료)',
  en: '🏥 Let the hospital file for you (done)',
  zh: '🏥 委托医院窗口代为提交（结束）',
  vi: '🏥 Nhờ bệnh viện nộp thay (hoàn tất)',
);
const _delegateSubtitle = L10nText(
  ko: '원무과에 서류를 내고 진행 트래커(Step 6)에서 진행 상황을 기록합니다',
  en: 'File at the front desk, then track progress in Step 6',
  zh: '在窗口提交材料，并在进度追踪器（第6步）中记录进展',
  vi: 'Nộp hồ sơ tại quầy, sau đó theo dõi tiến độ ở Bước 6',
);
const _selfFileTitle = L10nText(
  ko: '📄 근로자 직접 신청 / 서식 작성하기',
  en: '📄 File it myself / fill in the form',
  zh: '📄 劳动者本人申请／填写表格',
  vi: '📄 Tự nộp đơn / điền biểu mẫu',
);
const _selfFileSubtitle = L10nText(
  ko: 'Step 3(요양급여신청서 작성)으로 이동합니다',
  en: 'Move on to Step 3, filling in the claim form',
  zh: '前往第3步（填写疗养给付申请书）',
  vi: 'Chuyển sang Bước 3, điền đơn xin trợ cấp',
);
const _delegateToast = L10nText(
  ko: '진행 트래커로 이동합니다',
  en: 'Moving to the progress tracker',
  zh: '正在前往进度追踪器',
  vi: 'Đang chuyển đến trình theo dõi tiến độ',
);

/// 산재 2단계 — 사고/질병 토글 + 근거조항 카드 3개 + "병원 위임"(트래커로 점프)
/// / "직접 신청"(다음 단계로) 분기. html_files/산재처리네비게이터.html의
/// INJURY_GUIDE를 그대로 옮겼다.
class InjuryGuideView extends StatefulWidget {
  const InjuryGuideView({
    super.key,
    required this.accidentCards,
    required this.illnessCards,
    required this.currentType,
    required this.onTypeChanged,
    required this.onDelegate,
    required this.onSelfFile,
    required this.lang,
    required this.accentColor,
  });

  final List<LegalCitationCard> accidentCards;
  final List<LegalCitationCard> illnessCards;

  /// 0=사고성, 1=질병성 — 1단계 OptionsBlock 선택과 같은 값을 공유한다.
  /// null이면(1단계에서 아직 안 골랐으면) 사고성을 기본으로 보여준다.
  final int? currentType;
  final ValueChanged<int> onTypeChanged;
  final VoidCallback onDelegate;
  final VoidCallback onSelfFile;
  final AppLanguage lang;
  final Color accentColor;

  @override
  State<InjuryGuideView> createState() => _InjuryGuideViewState();
}

class _InjuryGuideViewState extends State<InjuryGuideView> {
  final _expanded = <int>{};

  @override
  Widget build(BuildContext context) {
    final type = widget.currentType ?? 0;
    final cards = type == 1 ? widget.illnessCards : widget.accidentCards;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _ToggleButton(
                label: _accidentToggleLabel.of(widget.lang),
                selected: type == 0,
                accentColor: widget.accentColor,
                onTap: () => widget.onTypeChanged(0),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ToggleButton(
                label: _illnessToggleLabel.of(widget.lang),
                selected: type == 1,
                accentColor: widget.accentColor,
                onTap: () => widget.onTypeChanged(1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < cards.length; i++) ...[
          _LegalCard(
            card: cards[i],
            lang: widget.lang,
            expanded: _expanded.contains(i),
            accentColor: widget.accentColor,
            onTap: () => setState(() {
              if (!_expanded.add(i)) _expanded.remove(i);
            }),
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            _stageBadgeHint.of(widget.lang),
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF1B5E20),
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 10),
        _BigOptionButton(
          icon: '🏥',
          title: _delegateTitle.of(widget.lang),
          subtitle: _delegateSubtitle.of(widget.lang),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_delegateToast.of(widget.lang)),
                duration: const Duration(seconds: 1),
              ),
            );
            widget.onDelegate();
          },
        ),
        const SizedBox(height: 8),
        _BigOptionButton(
          icon: '📄',
          title: _selfFileTitle.of(widget.lang),
          subtitle: _selfFileSubtitle.of(widget.lang),
          onTap: widget.onSelfFile,
        ),
      ],
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.label,
    required this.selected,
    required this.accentColor,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? accentColor : Colors.white,
          border: Border.all(color: selected ? accentColor : AppColors.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _LegalCard extends StatelessWidget {
  const _LegalCard({
    required this.card,
    required this.lang,
    required this.expanded,
    required this.accentColor,
    required this.onTap,
  });
  final LegalCitationCard card;
  final AppLanguage lang;
  final bool expanded;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(11),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(card.icon, style: const TextStyle(fontSize: 17)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.title.of(lang),
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          card.subtitle.of(lang),
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: AppColors.textMuted,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    size: 18,
                    color: expanded ? accentColor : AppColors.textMuted,
                  ),
                ],
              ),
              if (expanded) ...[
                const SizedBox(height: 9),
                Text(
                  card.body.of(lang),
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BigOptionButton extends StatelessWidget {
  const _BigOptionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
