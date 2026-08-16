import 'package:flutter/material.dart';
import '../../../common/widgets/rich_note.dart';
import '../../../core/app_language.dart';
import '../../../theme/app_colors.dart';
import '../models/flow_block.dart';

/// navigator_flow_screen.dart에서 분리한 "정적" 블록 위젯 모음 — 옵션 목록·공지·
/// 체크리스트·읽기전용 서식 카드처럼 로컬 콜백만 있고 자체 상태가 없는 것들.
class OptionsList extends StatelessWidget {
  const OptionsList({
    super.key,
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
                color: selected ? const Color(0xFFE3F2FD) : Colors.white,
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

class NoticeBox extends StatelessWidget {
  const NoticeBox({
    super.key,
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
        const Color(0xFFE3F2FD),
        const Color(0xFF90CAF9),
        const Color(0xFF0D47A1),
        const Color(0xFF0D47A1),
      ),
      NoticeTone.blue => (
        const Color(0xFFE3F2FD),
        const Color(0xFF90CAF9),
        const Color(0xFF0D47A1),
        const Color(0xFF0D47A1),
      ),
      NoticeTone.teal => (
        const Color(0xFFE8F5E9),
        const Color(0xFFA5D6A7),
        const Color(0xFF1B5E20),
        const Color(0xFF1B5E20),
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

class ChecklistCard extends StatelessWidget {
  const ChecklistCard({
    super.key,
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

class FillCard extends StatelessWidget {
  const FillCard({super.key, required this.rows, required this.lang});
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
              const Color(0xFF1B5E20),
              false,
              const Color(0xFFE8F5E9),
              const Color(0xFF1B5E20),
              'AUTO',
            ),
            FillTag.raw => (
              const Color(0xFF0F172A),
              false,
              const Color(0xFFE3F2FD),
              const Color(0xFF2196F3),
              'RAW',
            ),
            FillTag.blank => (
              const Color(0xFF90CAF9),
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

/// 번호/글머리 목록 — 온라인접수 3단계, 혼자해결하기 팁 등에 공용.
class ListBlockView extends StatelessWidget {
  const ListBlockView({
    super.key,
    required this.items,
    required this.numbered,
    required this.lang,
  });
  final List<L10nText> items;
  final bool numbered;
  final AppLanguage lang;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(items.length, (i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 18,
                child: Text(
                  numbered ? '${i + 1}.' : '•',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Expanded(
                child: RichNote(
                  items[i].of(lang),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.55,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

/// 기관 안내 카드 — 접이식 섹션 본문 안에서 쓰인다.
class OrgCardView extends StatelessWidget {
  const OrgCardView({
    super.key,
    required this.name,
    required this.subtitle,
    required this.lang,
    this.phone,
    this.legalBasis,
    this.tags = const [],
  });
  final L10nText name;
  final L10nText subtitle;
  final AppLanguage lang;
  final String? phone;
  final L10nText? legalBasis;
  final List<L10nText> tags;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name.of(lang),
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle.of(lang),
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          if (phone != null) ...[
            const SizedBox(height: 5),
            Text(
              '☎ $phone',
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
          if (legalBasis != null) ...[
            const SizedBox(height: 4),
            Text(
              legalBasis!.of(lang),
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textMuted,
                height: 1.4,
              ),
            ),
          ],
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        tag.of(lang),
                        style: const TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

const _legendLabelAuto = L10nText(
  ko: '자동채움',
  en: 'Auto-filled',
  zh: '自动填充',
  vi: 'Tự điền',
);
const _legendLabelRaw = L10nText(
  ko: '원문 그대로',
  en: 'As you wrote it',
  zh: '原文照录',
  vi: 'Nguyên văn',
);
const _legendLabelBlank = L10nText(
  ko: '공란 유지',
  en: 'Left blank',
  zh: '保持空白',
  vi: 'Để trống',
);

/// auto/raw/blank 3색 범례 — 서식 편집·검토·PDF 안내 앞에 공용으로 붙는다.
class LegendView extends StatelessWidget {
  const LegendView({super.key, required this.lang});
  final AppLanguage lang;

  @override
  Widget build(BuildContext context) {
    Widget chip(Color color, String label) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      );
    }

    return Wrap(
      spacing: 14,
      runSpacing: 6,
      children: [
        chip(const Color(0xFF1B5E20), _legendLabelAuto.of(lang)),
        chip(const Color(0xFF2196F3), _legendLabelRaw.of(lang)),
        chip(const Color(0xFF94A3B8), _legendLabelBlank.of(lang)),
      ],
    );
  }
}
