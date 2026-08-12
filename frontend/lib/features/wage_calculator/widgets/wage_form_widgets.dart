import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// 프론트엔드_계산기_최종.html(v6)의 .fgroup/.frow/.seg/.chips/.opt/.togrow/.more-box
/// 등 폼 부품을 그대로 옮긴 공용 위젯 모음. 5단계 위저드 화면 전용이라 이 폴더
/// 바깥에서는 쓰지 않는다.

class QMark extends StatelessWidget {
  const QMark({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 16,
          height: 16,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.border,
            shape: BoxShape.circle,
          ),
          child: const Text(
            '?',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class FGroup extends StatelessWidget {
  const FGroup({super.key, this.title, this.help, required this.children});
  final String? title;
  final VoidCallback? help;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (help != null) QMark(onTap: help!),
                ],
              ),
            ),
          ...children,
        ],
      ),
    );
  }
}

class FRow extends StatelessWidget {
  const FRow({
    super.key,
    required this.label,
    required this.controller,
    this.unit,
    this.help,
    this.readOnly = false,
  });
  final String label;
  final TextEditingController controller;
  final String? unit;
  final VoidCallback? help;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF334155),
                    ),
                  ),
                ),
                if (help != null) QMark(onTap: help!),
              ],
            ),
          ),
          const SizedBox(width: 9),
          SizedBox(
            width: 104,
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              enabled: !readOnly,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12.5),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: readOnly
                    ? const Color(0xFFF1F5F9)
                    : const Color(0xFFFBFDFF),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 7,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ),
          if (unit != null) ...[
            const SizedBox(width: 5),
            Text(
              unit!,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}

class FDateRow extends StatelessWidget {
  const FDateRow({
    super.key,
    required this.label,
    required this.value,
    required this.onPick,
    this.help,
    this.monthOnly = false,
    this.placeholder = '선택',
  });
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onPick;
  final VoidCallback? help;
  final bool monthOnly;
  final String placeholder;

  String get _text {
    if (value == null) return placeholder;
    final v = value!;
    return monthOnly
        ? '${v.year}-${v.month.toString().padLeft(2, '0')}'
        : '${v.year}-${v.month.toString().padLeft(2, '0')}-${v.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF334155),
                    ),
                  ),
                ),
                if (help != null) QMark(onTap: help!),
              ],
            ),
          ),
          const SizedBox(width: 9),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: value ?? DateTime.now(),
                firstDate: DateTime(2015),
                lastDate: DateTime(2035),
              );
              if (picked != null) onPick(picked);
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 145,
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFFBFDFF),
              ),
              child: Text(
                _text,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Seg<T> extends StatelessWidget {
  const Seg({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
  });
  final List<(String, T)> options;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: options.map((o) {
          final selected = o.$2 == value;
          return Expanded(
            child: InkWell(
              onTap: () => onChanged(o.$2),
              borderRadius: BorderRadius.circular(9),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? Colors.white : null,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  o.$1,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: selected ? AppColors.primary : AppColors.textMuted,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class Chips<T> extends StatelessWidget {
  const Chips({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.compact = false,
  });
  final List<(String, T)> options;
  final T value;
  final ValueChanged<T> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: options.map((o) {
        final selected = o.$2 == value;
        return InkWell(
          onTap: () => onChanged(o.$2),
          borderRadius: BorderRadius.circular(compact ? 14 : 20),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 9 : 11,
              vertical: compact ? 5 : 7,
            ),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFF3F7FF) : Colors.white,
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.border,
                width: selected ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(compact ? 14 : 20),
            ),
            child: Text(
              o.$1,
              style: TextStyle(
                fontSize: compact ? 10.5 : 11,
                fontWeight: FontWeight.w600,
                color: selected
                    ? const Color(0xFF1D4ED8)
                    : AppColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class OptButton extends StatelessWidget {
  const OptButton({
    super.key,
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });
  final String icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF3F7FF) : Colors.white,
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ToggleRow extends StatelessWidget {
  const ToggleRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 12, color: Color(0xFF334155)),
              ),
            ),
            const SizedBox(width: 10),
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: Colors.white,
              activeTrackColor: AppColors.secondary,
            ),
          ],
        ),
      ),
    );
  }
}

class RedNotice extends StatelessWidget {
  const RedNotice({super.key, required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        border: Border.all(color: const Color(0xFFF6C9C9)),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Color(0xFF991B1B),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            body,
            style: const TextStyle(
              fontSize: 10.5,
              color: Color(0xFFB33A3A),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class MoreBox extends StatefulWidget {
  const MoreBox({
    super.key,
    required this.title,
    required this.child,
    this.help,
    this.initiallyOpen = false,
  });
  final String title;
  final Widget child;
  final VoidCallback? help;
  final bool initiallyOpen;

  @override
  State<MoreBox> createState() => _MoreBoxState();
}

class _MoreBoxState extends State<MoreBox> {
  late bool _open = widget.initiallyOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (widget.help != null) QMark(onTap: widget.help!),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _open ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.expand_more,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (_open)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: widget.child,
            ),
        ],
      ),
    );
  }
}

class QuickButton extends StatelessWidget {
  const QuickButton({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          border: Border.all(color: const Color(0xFFCBD5E1)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class ImportButton extends StatelessWidget {
  const ImportButton({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFEEF2FF),
            border: Border.all(color: const Color(0xFFC7D2FE)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3730A3),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class SectionH4 extends StatelessWidget {
  const SectionH4({
    super.key,
    required this.title,
    required this.lead,
    this.help,
    this.topGap = 0,
  });
  final String title;
  final String lead;
  final VoidCallback? help;
  final double topGap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topGap, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              if (help != null) QMark(onTap: help!),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            lead,
            style: const TextStyle(
              fontSize: 11.5,
              color: AppColors.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
