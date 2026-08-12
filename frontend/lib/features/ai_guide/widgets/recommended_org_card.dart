import 'package:flutter/material.dart';
import '../../../common/models/org.dart';
import '../../../core/app_language.dart';
import '../../../theme/app_colors.dart';

/// 모든 응답 하단에 고정 노출되는 위치 기반 추천 기관 카드.
class RecommendedOrgCard extends StatelessWidget {
  const RecommendedOrgCard({
    super.key,
    required this.orgs,
    required this.language,
  });

  final List<Org> orgs;
  final AppLanguage language;

  static const _title = L10nText(
    ko: '◎ 내 위치 기반 추천 기관',
    en: '◎ Recommended nearby offices',
    zh: '◎ 基于您位置推荐的机构',
    vi: '◎ Cơ quan gợi ý theo vị trí của bạn',
  );

  @override
  Widget build(BuildContext context) {
    if (orgs.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.blueBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blueBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _title.of(language),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          for (final org in orgs)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    org.name,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${org.distanceKm}km',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
