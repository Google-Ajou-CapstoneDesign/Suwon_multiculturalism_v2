import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../models/category_item.dart';
import '../models/encyclopedia_strings.dart';

/// 백과사전 표지(닫힌 책 상태). 비자 D-day, 자주 보는 항목 3개, 검색창을 보여준다.
/// TODO(backend): visaValue/visaDday는 users 컬렉션의 실제 비자 정보로 교체.
class BookCover extends StatelessWidget {
  const BookCover({super.key, required this.language, required this.onOpenItem});

  final AppLanguage language;
  final ValueChanged<int> onOpenItem;

  static const _visaDDay = 42;

  /// 표지 배경(짙은 네이비 그라데이션). BookPageSwitcher가 만드는 공용 프레임
  /// 안을 그대로 채우도록, 카드 자체의 여백·모서리·그림자는 여기서 갖지 않는다.
  static const background = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1E3A6E), Color(0xFF132747)],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final visaStatus = UserProfileScope.of(context).visaStatus;
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LOCAL BRIDGE',
            style: TextStyle(color: Color(0xB8E8C88A), fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 3.5),
          ),
          const SizedBox(height: 12),
          Text(
            EncyclopediaStrings.coverTitle.of(language),
            style: const TextStyle(color: Color(0xFFF4F7FC), fontSize: 26, fontWeight: FontWeight.w800, height: 1.16, letterSpacing: -0.4),
          ),
          const SizedBox(height: 10),
          Text(
            EncyclopediaStrings.coverSubtitle.of(language),
            style: const TextStyle(color: Color(0x99D6E4F8), fontSize: 12, height: 1.6),
          ),
          const SizedBox(height: 16),
          Container(
            width: 110,
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFE8C88A), Color(0x00E8C88A)]),
            ),
          ),
          const SizedBox(height: 20),

          // 비자 정보 플레이트
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07),
              border: Border.all(color: const Color(0x48E8C88A)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            EncyclopediaStrings.visaLabel.of(language),
                            style: const TextStyle(color: Color(0xCCE8C88A), fontSize: 9.5, fontWeight: FontWeight.w600, letterSpacing: 1),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            visaStatus?.fullLabel ?? EncyclopediaStrings.visaNotSet.of(language),
                            style: const TextStyle(color: Color(0xFFEDF3FB), fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(color: const Color(0xFFE8C88A), borderRadius: BorderRadius.circular(6)),
                      child: const Text(
                        'D-$_visaDDay',
                        style: TextStyle(color: Color(0xFF3D2E12), fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  EncyclopediaStrings.visaNote.of(language),
                  style: const TextStyle(color: Color(0x8CD6E4F8), fontSize: 10.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 자주 보는 항목
          Text(
            EncyclopediaStrings.quickAccessLabel.of(language),
            style: const TextStyle(color: Color(0x80D6E4F8), fontSize: 9.5, fontWeight: FontWeight.w600, letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          Row(
            children: quickAccessChips.map((chip) {
              final (id, label) = chip;
              final item = categoryById[id]!;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: InkWell(
                    onTap: () => onOpenItem(id),
                    borderRadius: BorderRadius.circular(9),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.09),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.13)),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Column(
                        children: [
                          Icon(item.icon, size: 16, color: const Color(0xFFDCE7F7)),
                          const SizedBox(height: 5),
                          Text(
                            label.of(language),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xFFDCE7F7), fontSize: 9.5, fontWeight: FontWeight.w500, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // 검색창 (비활성 — 2차 단계에서 실제 검색 연결)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.94),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Text('🔍', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 8),
                Text(
                  EncyclopediaStrings.searchHint.of(language),
                  style: const TextStyle(color: Color(0xFF7C8BA1), fontSize: 11.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
