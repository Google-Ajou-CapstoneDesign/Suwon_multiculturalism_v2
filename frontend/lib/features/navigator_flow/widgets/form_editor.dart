import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../theme/app_colors.dart';
import '../controllers/form_values_controller.dart';
import '../models/flow_block.dart';
import '../models/form_field_spec.dart';

const _tagAutoLabel = L10nText(
  ko: '자동채움',
  en: 'Auto-filled',
  zh: '自动填充',
  vi: 'Tự điền',
);
const _tagRawLabel = L10nText(
  ko: '원문 그대로',
  en: 'As you wrote it',
  zh: '原文照录',
  vi: 'Nguyên văn',
);
const _tagBlankLabel = L10nText(
  ko: '공란 유지',
  en: 'Left blank',
  zh: '保持空白',
  vi: 'Để trống',
);

(Color, Color, L10nText) _tagStyle(FillTag tag) => switch (tag) {
  FillTag.auto => (
    const Color(0xFFE6F6F4),
    const Color(0xFF0B7267),
    _tagAutoLabel,
  ),
  FillTag.raw => (
    const Color(0xFFEEF3FE),
    const Color(0xFF1D4ED8),
    _tagRawLabel,
  ),
  FillTag.blank => (
    const Color(0xFFF1F5F9),
    const Color(0xFF94A3B8),
    _tagBlankLabel,
  ),
};

class _TagBadge extends StatelessWidget {
  const _TagBadge({required this.tag, required this.lang});
  final FillTag tag;
  final AppLanguage lang;

  @override
  Widget build(BuildContext context) {
    final (bg, color, label) = _tagStyle(tag);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label.of(lang),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

/// 실제 입력 가능한 서식 편집 화면. text/number/textarea는 자체 TextEditingController로
/// 커서 위치를 지키고, date/segmented는 FormValuesController를 직접 듣는다.
class FormEditorView extends StatefulWidget {
  const FormEditorView({
    super.key,
    required this.sections,
    required this.values,
    required this.lang,
    this.documentTitle,
    this.formSubtitle,
  });
  final List<FormSection> sections;
  final FormValuesController values;
  final AppLanguage lang;
  final L10nText? documentTitle;
  final L10nText? formSubtitle;

  @override
  State<FormEditorView> createState() => _FormEditorViewState();
}

class _FormEditorViewState extends State<FormEditorView> {
  final _controllers = <String, TextEditingController>{};

  TextEditingController _controllerFor(FormFieldSpec field) {
    return _controllers.putIfAbsent(
      field.key,
      () => TextEditingController(text: widget.values.valueOf(field.key)),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.values,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.documentTitle != null)
              _FormHeader(
                title: widget.documentTitle!,
                subtitle: widget.formSubtitle,
                lang: widget.lang,
              ),
            for (final section in widget.sections) ...[
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 6),
                child: Text(
                  section.title.of(widget.lang),
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Column(
                  children: [
                    for (final field in section.fields) _buildFieldRow(field),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildFieldRow(FormFieldSpec field) {
    final lang = widget.lang;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  field.label.of(lang),
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              _TagBadge(tag: field.tag, lang: lang),
            ],
          ),
          const SizedBox(height: 6),
          _buildInput(field),
          if (field.hint != null) ...[
            const SizedBox(height: 3),
            Text(
              field.hint!.of(lang),
              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
          ],
        ],
      ),
    );
  }

  InputDecoration _decoration(FormFieldSpec field) => InputDecoration(
    isDense: true,
    hintText: field.placeholder?.of(widget.lang),
    hintStyle: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
    filled: true,
    fillColor: const Color(0xFFFBFDFF),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.border),
    ),
  );

  Widget _buildInput(FormFieldSpec field) {
    switch (field.type) {
      case FormFieldType.text:
      case FormFieldType.number:
        return TextField(
          controller: _controllerFor(field),
          keyboardType: field.type == FormFieldType.number
              ? TextInputType.number
              : TextInputType.text,
          style: const TextStyle(fontSize: 12.5),
          decoration: _decoration(field),
          onChanged: (v) => widget.values.setValue(field.key, v),
        );
      case FormFieldType.textarea:
        return TextField(
          controller: _controllerFor(field),
          minLines: 3,
          maxLines: 6,
          style: const TextStyle(fontSize: 12.5),
          decoration: _decoration(field),
          onChanged: (v) => widget.values.setValue(field.key, v),
        );
      case FormFieldType.date:
        final current = widget.values.valueOf(field.key);
        return InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.tryParse(current) ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              widget.values.setValue(
                field.key,
                picked.toIso8601String().split('T').first,
              );
            }
          },
          child: InputDecorator(
            decoration: _decoration(field),
            child: Text(
              current.isEmpty
                  ? (field.placeholder?.of(widget.lang) ?? '')
                  : current,
              style: TextStyle(
                fontSize: 12.5,
                color: current.isEmpty
                    ? AppColors.textMuted
                    : AppColors.textPrimary,
              ),
            ),
          ),
        );
      case FormFieldType.segmented:
        final current = widget.values.valueOf(field.key);
        return Wrap(
          spacing: 6,
          runSpacing: 6,
          children: field.options.map((opt) {
            final selected = current == opt.value;
            return ChoiceChip(
              label: Text(
                opt.label.of(widget.lang),
                style: const TextStyle(fontSize: 11.5),
              ),
              selected: selected,
              onSelected: (_) => widget.values.setValue(field.key, opt.value),
              selectedColor: const Color(0xFFEEF3FE),
              labelStyle: TextStyle(
                color: selected
                    ? const Color(0xFF1D4ED8)
                    : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              ),
              side: BorderSide(
                color: selected ? const Color(0xFF1D4ED8) : AppColors.border,
              ),
            );
          }).toList(),
        );
      case FormFieldType.readonly:
        final value = widget.values.valueOf(field.key);
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value.isEmpty ? (field.placeholder?.of(widget.lang) ?? '') : value,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        );
    }
  }
}

/// 문서명 · 부제 배너 — 실제 정부 서식 상단(html_files 원본의 .fdh)을 재현한다.
class _FormHeader extends StatelessWidget {
  const _FormHeader({required this.title, required this.lang, this.subtitle});
  final L10nText title;
  final L10nText? subtitle;
  final AppLanguage lang;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.of(lang),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!.of(lang),
              style: const TextStyle(
                fontSize: 10.5,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 같은 sections를 읽기 전용으로 다시 그린다(검토 단계).
class FormReviewView extends StatelessWidget {
  const FormReviewView({
    super.key,
    required this.sections,
    required this.values,
    required this.lang,
    this.documentTitle,
    this.formSubtitle,
  });
  final List<FormSection> sections;
  final FormValuesController values;
  final AppLanguage lang;
  final L10nText? documentTitle;
  final L10nText? formSubtitle;

  String _displayValue(FormFieldSpec field) {
    final raw = values.valueOf(field.key);
    if (raw.isEmpty) return '';
    if (field.type == FormFieldType.segmented) {
      final opt = field.options.where((o) => o.value == raw).firstOrNull;
      return opt?.label.of(lang) ?? raw;
    }
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: values,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (documentTitle != null)
              _FormHeader(
                title: documentTitle!,
                subtitle: formSubtitle,
                lang: lang,
              ),
            for (final section in sections) ...[
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 6),
                child: Text(
                  section.title.of(lang),
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: List.generate(section.fields.length, (i) {
                    final field = section.fields[i];
                    final display = _displayValue(field);
                    final isEmpty = display.isEmpty;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: i < section.fields.length - 1
                                ? const Color(0xFFF1F5F9)
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 84,
                            child: Text(
                              field.label.of(lang),
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
                              isEmpty ? '—' : display,
                              style: TextStyle(
                                fontSize: 12,
                                color: isEmpty
                                    ? const Color(0xFFB9C4D2)
                                    : AppColors.textPrimary,
                                fontStyle: isEmpty
                                    ? FontStyle.italic
                                    : FontStyle.normal,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          _TagBadge(tag: field.tag, lang: lang),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

const _importWorkLogLabel = L10nText(
  ko: '근무기록장 불러오기',
  en: 'Load work log',
  zh: '导入工作记录',
  vi: 'Tải nhật ký làm việc',
);
const _importPayslipLabel = L10nText(
  ko: '임금명세서 불러오기',
  en: 'Load payslip',
  zh: '导入工资单',
  vi: 'Tải phiếu lương',
);
const _importCalcLabel = L10nText(
  ko: '계산기 결과 불러오기',
  en: 'Load calculator result',
  zh: '导入计算器结果',
  vi: 'Tải kết quả máy tính lương',
);
const _importProfileLabel = L10nText(
  ko: '프로필 정보 불러오기',
  en: 'Load profile info',
  zh: '导入个人资料',
  vi: 'Tải thông tin hồ sơ',
);
const _comingSoonMessage = L10nText(
  ko: '아직 준비 중인 기능입니다. 곧 연동될 예정이에요.',
  en: "This feature isn't ready yet. It's coming soon.",
  zh: '该功能尚在准备中，即将上线。',
  vi: 'Tính năng này đang được chuẩn bị và sẽ sớm ra mắt.',
);

L10nText _importLabelFor(ImportSource source) => switch (source) {
  ImportSource.workLog => _importWorkLogLabel,
  ImportSource.payslip => _importPayslipLabel,
  ImportSource.calcResult => _importCalcLabel,
  ImportSource.profile => _importProfileLabel,
};

String _importIconFor(ImportSource source) => switch (source) {
  ImportSource.workLog => '📅',
  ImportSource.payslip => '🧾',
  ImportSource.calcResult => '🧮',
  ImportSource.profile => '👤',
};

/// 근무기록장/임금명세서/계산기값/프로필 불러오기 토글 버튼 묶음.
class ImportButtonsRow extends StatelessWidget {
  const ImportButtonsRow({
    super.key,
    required this.sources,
    required this.imported,
    required this.lang,
    required this.onImport,
    this.comingSoon = false,
  });
  final List<ImportSource> sources;
  final Set<ImportSource> imported;
  final AppLanguage lang;
  final ValueChanged<ImportSource> onImport;

  /// true면 실제로 불러오지 않고 "준비 중" 안내 스낵바만 띄운다.
  final bool comingSoon;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: sources.map((source) {
        final done = imported.contains(source);
        return InkWell(
          onTap: () {
            if (comingSoon) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_comingSoonMessage.of(lang)),
                  duration: const Duration(seconds: 2),
                ),
              );
              return;
            }
            onImport(source);
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: done ? const Color(0xFFE6F6F4) : Colors.white,
              border: Border.all(
                color: done ? AppColors.secondary : AppColors.border,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _importIconFor(source),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 6),
                Text(
                  _importLabelFor(source).of(lang),
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: done ? AppColors.secondary : AppColors.textSecondary,
                  ),
                ),
                if (done) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.check_circle,
                    size: 14,
                    color: AppColors.secondary,
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
