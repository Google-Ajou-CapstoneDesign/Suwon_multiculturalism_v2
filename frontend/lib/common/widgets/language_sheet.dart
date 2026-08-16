import 'package:flutter/material.dart';
import '../../core/app_language.dart';
import '../../theme/app_colors.dart';

/// 앱 전역 언어 선택 바텀시트. 어떤 언어를 고르든 한국어 표기(subLabel)를
/// 함께 보여준다 — 출입국사무소·은행 창구에서 실제로는 한국어 단어를 말해야
/// 하기 때문. 홈 화면 상단 언어 버튼에서 연다(과거엔 백과사전 탭 전용이었다).
const _title = L10nText(
  ko: '언어 선택',
  en: 'Choose a language',
  zh: '选择语言',
  vi: 'Chọn ngôn ngữ',
);
const _subtitle = L10nText(
  ko: '어떤 언어를 골라도 한국어 표기는 함께 보여드립니다.',
  en: 'Whichever language you pick, the Korean term stays below it',
  zh: '无论选择哪种语言，都会一并显示韩语原文。',
  vi: 'Dù chọn ngôn ngữ nào, tên tiếng Hàn vẫn hiển thị bên dưới',
);

Future<void> showLanguageSheet(
  BuildContext context, {
  required AppLanguage current,
  required ValueChanged<AppLanguage> onSelect,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _title.of(current),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              _subtitle.of(current),
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
                height: 1.5,
              ),
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
  const _LanguageOption({
    required this.lang,
    required this.selected,
    required this.onTap,
  });

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
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
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
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.nativeName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lang.subLabel,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check, size: 16, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
