import 'package:flutter/material.dart';
import '../../../core/app_language.dart';

enum CategoryGroupId { a, b, c }

/// 백과사전 카테고리 1개. id는 향후 콘텐츠 확장(전체 20개 항목) 때도
/// 그대로 재사용할 수 있도록 프론트엔드_구상.html의 번호를 그대로 따른다.
class CategoryItem {
  const CategoryItem({
    required this.id,
    required this.icon,
    required this.name,
    required this.group,
  });

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
      zh: '外国人登录证（ARC）办理',
      vi: 'Thẻ đăng ký người nước ngoài (ARC)',
    ),
  ),
  2: CategoryItem(
    id: 2,
    icon: Icons.assignment_ind_outlined,
    group: CategoryGroupId.a,
    name: L10nText(
      ko: '비자 관리 & 체류 연장',
      en: 'Visa management & extension of stay',
      zh: '签证管理与居留延长',
      vi: 'Quản lý visa & gia hạn cư trú',
    ),
  ),
  3: CategoryItem(
    id: 3,
    icon: Icons.signal_cellular_alt,
    group: CategoryGroupId.a,
    name: L10nText(
      ko: '통신 개통',
      en: 'Getting a phone plan',
      zh: '开通通讯（手机）',
      vi: 'Đăng ký điện thoại',
    ),
  ),
  5: CategoryItem(
    id: 5,
    icon: Icons.support_agent,
    group: CategoryGroupId.a,
    name: L10nText(
      ko: '긴급 신고·통역지원',
      en: 'Emergency calls & interpreting',
      zh: '紧急报案与口译支援',
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
      zh: '银行账户与汇款',
      vi: 'Tài khoản ngân hàng & chuyển tiền',
    ),
  ),
  7: CategoryItem(
    id: 7,
    icon: Icons.apartment_outlined,
    group: CategoryGroupId.b,
    name: L10nText(
      ko: '주거',
      en: 'Housing & dormitories',
      zh: '住房与宿舍',
      vi: 'Nhà ở & ký túc xá',
    ),
  ),
  9: CategoryItem(
    id: 9,
    icon: Icons.local_hospital_outlined,
    group: CategoryGroupId.b,
    name: L10nText(
      ko: '의료·건강보험',
      en: 'Healthcare & insurance',
      zh: '医疗与健康保险',
      vi: 'Y tế & bảo hiểm sức khỏe',
    ),
  ),
  10: CategoryItem(
    id: 10,
    icon: Icons.school_outlined,
    group: CategoryGroupId.b,
    name: L10nText(
      ko: '한국어 학습',
      en: 'Learning Korean',
      zh: '学习韩语',
      vi: 'Học tiếng Hàn',
    ),
  ),
  11: CategoryItem(
    id: 11,
    icon: Icons.fact_check_outlined,
    group: CategoryGroupId.c,
    name: L10nText(
      ko: '근로계약서 체크리스트',
      en: 'Employment contract checklist',
      zh: '劳动合同检查清单',
      vi: 'Danh mục kiểm tra hợp đồng',
    ),
  ),
  14: CategoryItem(
    id: 14,
    icon: Icons.edit_calendar_outlined,
    group: CategoryGroupId.c,
    name: L10nText(
      ko: '근무기록장 작성법',
      en: 'Keeping a work log',
      zh: '工作记录本填写方法',
      vi: 'Cách ghi nhật ký làm việc',
    ),
  ),
  15: CategoryItem(
    id: 15,
    icon: Icons.swap_horiz,
    group: CategoryGroupId.c,
    name: L10nText(
      ko: '사업장 변경 제도',
      en: 'Changing workplaces',
      zh: '更换工作单位制度',
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
      zh: '权益救济支援制度',
      vi: 'Chương trình hỗ trợ pháp lý',
    ),
  ),
};

const Map<CategoryGroupId, CategoryGroupData> categoryGroups = {
  CategoryGroupId.a: CategoryGroupData(
    id: CategoryGroupId.a,
    color: Color(0xFF1E40AF),
    backgroundTint: Color(0xFFEEF3FE),
    markLabel: L10nText(ko: '필수행정', en: 'ADMIN', zh: '必办手续', vi: 'THỦ TỤC'),
    name: L10nText(ko: '그룹 A', en: 'Group A ', zh: 'A组', vi: 'Nhóm A'),
    title: L10nText(
      ko: '필수 행정·인증',
      en: 'Essential admin',
      zh: '必办行政·认证',
      vi: 'Thủ tục bắt buộc',
    ),
    itemIds: [1, 2, 3],
    skeletonIds: [5],
  ),
  CategoryGroupId.b: CategoryGroupData(
    id: CategoryGroupId.b,
    color: Color(0xFF0D9488),
    backgroundTint: Color(0xFFE6F6F4),
    markLabel: L10nText(ko: '생활정착', en: 'LIVING', zh: '生活安顿', vi: 'SINH HOẠT'),
    name: L10nText(ko: '그룹 B', en: 'Group B', zh: 'B组', vi: 'Nhóm B'),
    title: L10nText(
      ko: '생활 정착',
      en: 'Settling in',
      zh: '生活安顿',
      vi: 'Ổn định cuộc sống',
    ),
    itemIds: [6, 7, 9],
    skeletonIds: [10],
  ),
  CategoryGroupId.c: CategoryGroupData(
    id: CategoryGroupId.c,
    color: Color(0xFFD97706),
    backgroundTint: Color(0xFFFEF3E2),
    markLabel: L10nText(ko: '노동권익', en: 'RIGHTS', zh: '劳动权益', vi: 'QUYỀN LỢI'),
    name: L10nText(ko: '그룹 C', en: 'Group C', zh: 'C组', vi: 'Nhóm C'),
    title: L10nText(
      ko: '노동 권익',
      en: 'Labor rights',
      zh: '劳动权益',
      vi: 'Quyền lợi lao động',
    ),
    itemIds: [11, 14, 17],
    skeletonIds: [15],
  ),
};

/// 표지의 "자주 보는 항목" 3칩 — (categoryId, 줄바꿈 포함 짧은 라벨)
const quickAccessChips = [
  (
    11,
    L10nText(
      ko: '계약서\n체크',
      en: 'Contract\ncheck',
      zh: '合同\n检查',
      vi: 'Kiểm tra\nhợp đồng',
    ),
  ),
  (
    1,
    L10nText(
      ko: 'ARC\n발급',
      en: 'ARC\nissuance',
      zh: 'ARC\n办理',
      vi: 'Cấp thẻ\nARC',
    ),
  ),
  (
    17,
    L10nText(
      ko: '권리구제\n제도',
      en: 'Legal\nsupport',
      zh: '权益救济\n制度',
      vi: 'Hỗ trợ\npháp lý',
    ),
  ),
];
