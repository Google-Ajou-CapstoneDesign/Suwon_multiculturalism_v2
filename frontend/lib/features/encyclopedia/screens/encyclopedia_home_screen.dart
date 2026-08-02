import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../models/category_item.dart';
import '../widgets/category_icon_chip.dart';
import 'category_detail_arc_screen.dart';
import 'category_detail_telecom_screen.dart';
import 'category_placeholder_screen.dart';

/// Tab 1 · 백과사전 홈. 검색창, 비자 D-day 배너, 그룹A~D 카테고리 목록.
/// TODO(backend): visaExpiryDate는 users 컬렉션에서, categories는 content_categories 컬렉션에서 로드.
class EncyclopediaHomeScreen extends StatelessWidget {
  const EncyclopediaHomeScreen({super.key});

  // TODO(backend): 로그인한 사용자의 비자 만료일로 교체.
  static const _mockDDay = 42;

  void _openCategory(BuildContext context, CategoryItem item) {
    Widget screen;
    switch (item.detailType) {
      case CategoryDetailType.arcDemo:
        screen = const CategoryDetailArcScreen();
        break;
      case CategoryDetailType.telecomDemo:
        screen = const CategoryDetailTelecomScreen();
        break;
      case CategoryDetailType.placeholder:
        screen = CategoryPlaceholderScreen(title: item.title);
        break;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final groups = CategoryGroup.values;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Bridge', style: TextStyle(fontWeight: FontWeight.w700)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(child: Text('KOR', style: TextStyle(color: AppColors.textSecondary))),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          // 검색창 (TODO: 카테고리 실시간 필터링)
          TextField(
            decoration: InputDecoration(
              hintText: '필요한 정보를 검색하세요',
              prefixIcon: const Icon(Icons.search, size: 20),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 비자 만료 D-day 배너
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.amberBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.amberBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.event_note, color: AppColors.amberText),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '체류기간 만료 D-$_mockDDay',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.amberText),
                      ),
                      const Text(
                        'E-9 비자 · 연장 절차 확인하기',
                        style: TextStyle(fontSize: 12, color: AppColors.amberText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          for (final group in groups) ...[
            Text(
              group.label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: mockCategories
                  .where((c) => c.group == group)
                  .map((c) => CategoryIconChip(item: c, onTap: () => _openCategory(context, c)))
                  .toList(),
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}
