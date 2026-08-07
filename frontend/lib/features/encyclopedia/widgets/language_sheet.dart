import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../models/app_language.dart';
import '../models/encyclopedia_strings.dart';

/// 언어 선택 바텀시트. 어떤 언어를 고르든 한국어 표기(subLabel)를 함께 보여준다.
Future<void> showLanguageSheet(
  BuildContext context, {
  required AppLanguage current,
  required ValueChanged<AppLanguage> onSelect,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              EncyclopediaStrings.languageSheetTitle.of(current),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 3),
            Text(
              EncyclopediaStrings.languageSheetSubtitle.of(current),
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.5),
            ),
            const SizedBox(height: 14),
            for (final lang in AppLanguage.values)
              _LanguageOption(
                lang: lang,
                selected: lang == current,
                onTap: () {
                  onSelect(lang);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      );
    },
  );
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({required this.lang, required this.selected, required this.onTap});

  final AppLanguage lang;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.blueBg : Colors.white,
          border: Border.all(color: selected ? AppColors.primary : AppColors.border),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.textMuted,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                lang.code,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lang.nativeName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(lang.subLabel, style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted)),
                ],
              ),
            ),
            if (selected) const Icon(Icons.check, size: 16, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
