import 'package:flutter/material.dart';
import '../../../common/models/org.dart';
import '../../../core/app_language.dart';
import '../../../theme/app_colors.dart';

/// 서버의 관련도 순서를 유지해 상위 두 기관을 나란히 표시한다.
class RecommendedOrgCard extends StatelessWidget {
  const RecommendedOrgCard({
    super.key,
    required this.orgs,
    required this.language,
  });

  final List<Org> orgs;
  final AppLanguage language;

  static const _title = L10nText(
    ko: '추천 기관',
    en: 'Recommended organizations',
    zh: '推荐机构',
    vi: 'Cơ quan được đề xuất',
    uz: 'Tavsiya etilgan tashkilotlar',
  );
  static const _address = L10nText(
    ko: '주소',
    en: 'Address',
    zh: '地址',
    vi: 'Địa chỉ',
    uz: 'Manzil',
  );
  static const _phone = L10nText(
    ko: '전화번호',
    en: 'Phone',
    zh: '电话',
    vi: 'Điện thoại',
    uz: 'Telefon',
  );
  static const _hours = L10nText(
    ko: '이용가능시간',
    en: 'Opening hours',
    zh: '开放时间',
    vi: 'Giờ hoạt động',
    uz: 'Ish vaqti',
  );
  static const _distance = L10nText(
    ko: '거리',
    en: 'Distance',
    zh: '距离',
    vi: 'Khoảng cách',
    uz: 'Masofa',
  );
  static const _unknown = L10nText(
    ko: '정보 없음',
    en: 'Not available',
    zh: '暂无信息',
    vi: 'Chưa có thông tin',
    uz: 'Maʼlumot yoʻq',
  );
  static const _distanceUnavailable = L10nText(
    ko: '거리 정보 없음',
    en: 'Distance unavailable',
    zh: '无距离信息',
    vi: 'Không có khoảng cách',
    uz: "Masofa mavjud emas",
  );

  String _distanceLabel(Org org) {
    final distance = org.distanceKm;
    if (distance == null) return _distanceUnavailable.of(language);
    if (distance < 0.1) return '<0.1km';
    return '${distance.toStringAsFixed(1)}km';
  }

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
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final selected = orgs.take(2).toList();
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var index = 0; index < selected.length; index++) ...[
                    if (index > 0) const SizedBox(width: 12),
                    Expanded(child: _orgTile(selected[index], index + 1)),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _orgTile(Org org, int rank) => Container(
    key: ValueKey('recommended-org-$rank'),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColors.blueBorder),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$rank. ${org.name}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _detail(Icons.location_on_outlined, _address, org.address),
        _detail(Icons.phone_outlined, _phone, org.phoneNumber),
        _detail(Icons.schedule, _hours, org.businessHours),
        _detail(Icons.near_me_outlined, _distance, _distanceLabel(org)),
      ],
    ),
  );

  Widget _detail(IconData icon, L10nText label, String? value) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.of(language),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 2),
              SelectableText(
                value == null || value.trim().isEmpty
                    ? _unknown.of(language)
                    : value,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
