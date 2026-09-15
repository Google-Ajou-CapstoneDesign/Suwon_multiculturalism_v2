import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../core/visa_status.dart';
import '../../../theme/app_colors.dart';
import 'auth_text_field.dart';

class _S {
  _S._();

  static const label = L10nText(
    ko: '체류자격(비자)',
    en: 'Visa status',
    zh: '居留资格（签证）',
    vi: 'Tư cách lưu trú (visa)',
    uz: "Viza holati",
  );
  static const customPlaceholder = L10nText(
    ko: '체류자격을 직접 입력해주세요',
    en: 'Enter your visa status',
    zh: '请输入居留资格',
    vi: 'Nhập tư cách lưu trú của bạn',
    uz: "Viza holatingizni kiriting",
  );
}

/// 체류자격 선택 UI(ChoiceChip 목록 + ETC 선택 시 자유 입력란) — 회원가입과
/// 설정 화면의 프로필 편집 모달이 함께 쓴다. 원래 signup_form_screen.dart에
/// 인라인으로만 있던 걸 공용 위젯으로 뺀 것.
class VisaPicker extends StatelessWidget {
  const VisaPicker({
    super.key,
    required this.language,
    required this.value,
    required this.onChanged,
    required this.customTextController,
    this.showLabel = true,
  });

  final AppLanguage language;
  final VisaStatus value;
  final ValueChanged<VisaStatus> onChanged;

  /// value가 VisaStatus.etc일 때만 보여주는 자유 입력란의 컨트롤러 —
  /// 호출부가 소유·dispose한다.
  final TextEditingController customTextController;

  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Text(
            _S.label.of(language),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: VisaStatus.values.map((visa) {
            final selected = value == visa;
            return ChoiceChip(
              label: Text(visa.fullLabel, style: const TextStyle(fontSize: 12)),
              selected: selected,
              onSelected: (_) => onChanged(visa),
              selectedColor: AppColors.blueBg,
              labelStyle: TextStyle(
                color: selected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              ),
              side: BorderSide(
                color: selected ? AppColors.primary : AppColors.border,
              ),
            );
          }).toList(),
        ),
        if (value == VisaStatus.etc) ...[
          const SizedBox(height: 10),
          AuthTextField(
            label: _S.customPlaceholder.of(language),
            controller: customTextController,
          ),
        ],
      ],
    );
  }
}
