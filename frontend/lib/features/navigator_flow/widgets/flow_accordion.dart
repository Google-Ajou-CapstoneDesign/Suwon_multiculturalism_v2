import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../theme/app_colors.dart';
import '../models/flow_block.dart';
import 'flow_content_blocks.dart';

/// AccordionBlock.body에 들어갈 수 있는 블록만 그리는 순수 렌더러. 상태를 갖는
/// 블록(WageCalcBlock 등)은 여기 들어오지 않는다 — 정적 정보 전달용 아코디언이라
/// 콜백이 필요한 블록(MessageTemplateBlock 등)도 의도적으로 지원하지 않는다.
Widget buildAccordionBodyBlock(FlowBlock block, AppLanguage lang) {
  return switch (block) {
    NoticeBlock(:final tone, :final title, :final body) => NoticeBox(
      tone: tone,
      title: title.of(lang),
      body: body.of(lang),
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
    _ => const SizedBox.shrink(),
  };
}

/// 접이식 섹션 목록 — 임금 제출방법 4항목, 산재 기관허브 4항목에 공용.
class AccordionList extends StatelessWidget {
  const AccordionList({
    super.key,
    required this.items,
    required this.lang,
    required this.accentColor,
  });
  final List<AccordionItemData> items;
  final AppLanguage lang;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(11),
              ),
              clipBehavior: Clip.antiAlias,
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 2,
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(13, 0, 13, 13),
                  leading: Text(
                    item.icon,
                    style: const TextStyle(fontSize: 18),
                  ),
                  title: Text(
                    item.title.of(lang),
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    item.subtitle.of(lang),
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                  iconColor: accentColor,
                  collapsedIconColor: AppColors.textMuted,
                  children: [
                    for (final block in item.body) ...[
                      buildAccordionBodyBlock(block, lang),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
