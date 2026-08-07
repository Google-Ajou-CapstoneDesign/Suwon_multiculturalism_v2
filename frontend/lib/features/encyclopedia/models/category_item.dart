import 'package:flutter/material.dart';
import 'app_language.dart';

enum CategoryGroupId { a, b, c }

/// 백과사전 카테고리 1개. id는 향후 콘텐츠 확장(전체 20개 항목) 때도
/// 그대로 재사용할 수 있도록 프론트엔드_구상.html의 번호를 그대로 따른다.
class CategoryItem {
  const CategoryItem({required this.id, required this.icon, required this.name, required this.group});

  final int id;
  final IconData icon;
  final L10nText name;
  final CategoryGroupId group;
}

/// 그룹(북마크) 1개 — 표지 우측의 세로 탭 A/B/C에 대응.
class CategoryGroupData {
  const CategoryGroupData({
    required this.id,
    required this.color,
    required this.backgroundTint,
    required this.markLabel,
    required this.name,
    required this.title,
    required this.itemIds,
    required this.skeletonIds,
  });

  final CategoryGroupId id;
  final Color color;
  final Color backgroundTint;

  /// 세로 북마크에 쓰는 짧은 라벨(예: "필수행정")
  final L10nText markLabel;

  /// 목차 상단에 쓰는 그룹명(예: "그룹 A · 필수 행정·인증")
  final L10nText name;

  /// 목차 상단 큰 제목(예: "입국 후 처음 해야 할 일")
  final L10nText title;

  final List<int> itemIds;

  /// 아직 콘텐츠가 없는 "준비 중" 항목 — 목차엔 노출하되 탭할 수 없다.
  final List<int> skeletonIds;
}

const Map<int, CategoryItem> categoryById = {
  1: CategoryItem(
    id: 1,
    icon: Icons.badge_outlined,
    group: CategoryGroupId.a,
    name: L10nText(
      ko: '외국인등록증(ARC) 발급',
      en: 'Alien Registration Card (ARC)',
      vi: 'Thẻ đăng ký người nước ngoài (ARC)',
    ),
  ),
  2: CategoryItem(
    id: 2,
    icon: Icons.fingerprint,
    group: CategoryGroupId.a,
    name: L10nText(
      ko: '본인인증 앱 (PASS·카카오톡)',
      en: 'Identity apps (PASS, KakaoTalk)',
      vi: 'Ứng dụng xác thực (PASS, KakaoTalk)',
    ),
  ),
  3: CategoryItem(
    id: 3,
    icon: Icons.signal_cellular_alt,
    group: CategoryGroupId.a,
    name: L10nText(ko: '통신 개통', en: 'Getting a phone plan', vi: 'Đăng ký điện thoại'),
  ),
  5: CategoryItem(
    id: 5,
    icon: Icons.support_agent,
    group: CategoryGroupId.a,
    name: L10nText(
      ko: '긴급 신고·통역지원',
      en: 'Emergency calls & interpreting',
      vi: 'Gọi khẩn cấp & phiên dịch',
    ),
  ),
  6: CategoryItem(
    id: 6,
    icon: Icons.account_balance_outlined,
    group: CategoryGroupId.b,
    name: L10nText(
      ko: '은행 계좌·송금',
      en: 'Bank account & sending money',
      vi: 'Tài khoản ngân hàng & chuyển tiền',
    ),
  ),
  7: CategoryItem(
    id: 7,
    icon: Icons.apartment_outlined,
    group: CategoryGroupId.b,
    name: L10nText(ko: '주거', en: 'Housing & dormitories', vi: 'Nhà ở & ký túc xá'),
  ),
  9: CategoryItem(
    id: 9,
    icon: Icons.local_hospital_outlined,
    group: CategoryGroupId.b,
    name: L10nText(
      ko: '의료·건강보험',
      en: 'Healthcare & insurance',
      vi: 'Y tế & bảo hiểm sức khỏe',
    ),
  ),
  10: CategoryItem(
    id: 10,
    icon: Icons.school_outlined,
    group: CategoryGroupId.b,
    name: L10nText(ko: '한국어 학습', en: 'Learning Korean', vi: 'Học tiếng Hàn'),
  ),
  11: CategoryItem(
    id: 11,
    icon: Icons.fact_check_outlined,
    group: CategoryGroupId.c,
    name: L10nText(
      ko: '근로계약서 체크리스트',
      en: 'Employment contract checklist',
      vi: 'Danh mục kiểm tra hợp đồng',
    ),
  ),
  14: CategoryItem(
    id: 14,
    icon: Icons.edit_calendar_outlined,
    group: CategoryGroupId.c,
    name: L10nText(ko: '근무기록장 작성법', en: 'Keeping a work log', vi: 'Cách ghi nhật ký làm việc'),
  ),
  15: CategoryItem(
    id: 15,
    icon: Icons.swap_horiz,
    group: CategoryGroupId.c,
    name: L10nText(
      ko: '사업장 변경 제도',
      en: 'Changing workplaces',
      vi: 'Chuyển đổi nơi làm việc',
    ),
  ),
  17: CategoryItem(
    id: 17,
    icon: Icons.gavel_outlined,
    group: CategoryGroupId.c,
    name: L10nText(
      ko: '권리구제 지원제도',
      en: 'Legal support programs',
      vi: 'Chương trình hỗ trợ pháp lý',
    ),
  ),
};

const Map<CategoryGroupId, CategoryGroupData> categoryGroups = {
  CategoryGroupId.a: CategoryGroupData(
    id: CategoryGroupId.a,
    color: Color(0xFF1E40AF),
    backgroundTint: Color(0xFFEEF3FE),
    markLabel: L10nText(ko: '필수행정', en: 'ADMIN', vi: 'THỦ TỤC'),
    name: L10nText(ko: '그룹 A · 필수 행정·인증', en: 'Group A · Essential admin', vi: 'Nhóm A · Thủ tục bắt buộc'),
    title: L10nText(ko: '입국 후 처음 해야 할 일', en: 'Your first steps after arrival', vi: 'Việc cần làm đầu tiên'),
    itemIds: [1, 2, 3],
    skeletonIds: [5],
  ),
  CategoryGroupId.b: CategoryGroupData(
    id: CategoryGroupId.b,
    color: Color(0xFF0D9488),
    backgroundTint: Color(0xFFE6F6F4),
    markLabel: L10nText(ko: '생활정착', en: 'LIVING', vi: 'SINH HOẠT'),
    name: L10nText(ko: '그룹 B · 생활 정착', en: 'Group B · Settling in', vi: 'Nhóm B · Ổn định cuộc sống'),
    title: L10nText(ko: '자리를 잡기 위한 것들', en: 'What you need to settle in', vi: 'Những việc để an cư'),
    itemIds: [6, 7, 9],
    skeletonIds: [10],
  ),
  CategoryGroupId.c: CategoryGroupData(
    id: CategoryGroupId.c,
    color: Color(0xFFD97706),
    backgroundTint: Color(0xFFFEF3E2),
    markLabel: L10nText(ko: '노동권익', en: 'RIGHTS', vi: 'QUYỀN LỢI'),
    name: L10nText(ko: '그룹 C · 노동 권익', en: 'Group C · Labor rights', vi: 'Nhóm C · Quyền lợi lao động'),
    title: L10nText(ko: '일하면서 지켜야 할 권리', en: 'Rights to protect at work', vi: 'Quyền cần bảo vệ khi làm việc'),
    itemIds: [11, 14, 17],
    skeletonIds: [15],
  ),
};

/// 표지의 "자주 보는 항목" 3칩 — (categoryId, 줄바꿈 포함 짧은 라벨)
const quickAccessChips = [
  (11, L10nText(ko: '계약서\n체크', en: 'Contract\ncheck', vi: 'Kiểm tra\nhợp đồng')),
  (1, L10nText(ko: 'ARC\n발급', en: 'ARC\nissuance', vi: 'Cấp thẻ\nARC')),
  (17, L10nText(ko: '권리구제\n제도', en: 'Legal\nsupport', vi: 'Hỗ trợ\npháp lý')),
];
