import 'package:flutter/material.dart';
import '../../../core/app_language.dart';

enum CategoryGroupId { a, b, c }

/// 백과사전 카테고리 1개. html_files/생활백과사전.html의 12개 항목(그룹당 4개)
/// 그대로를 옮긴 것이라 id는 그 순서를 그대로 따른다(1~4=A, 5~8=B, 9~12=C).
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
    this.skeletonIds = const [],
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
  /// 지금은 그룹당 4개 항목이 전부 채워져 있어 비어 있다.
  final List<int> skeletonIds;
}

const Map<int, CategoryItem> categoryById = {
  // ── Group A · 필수 행정 ──────────────────────────────────────────
  1: CategoryItem(
    id: 1,
    icon: Icons.badge_outlined,
    group: CategoryGroupId.a,
    name: L10nText(ko: '등록증', en: 'ARC', zh: '外国人登录证', vi: 'Thẻ đăng ký'),
  ),
  2: CategoryItem(
    id: 2,
    icon: Icons.assignment_ind_outlined,
    group: CategoryGroupId.a,
    name: L10nText(ko: '비자', en: 'Visa', zh: '签证', vi: 'Visa'),
  ),
  3: CategoryItem(
    id: 3,
    icon: Icons.work_outline,
    group: CategoryGroupId.a,
    name: L10nText(
      ko: '취업수속',
      en: 'Employment procedures',
      zh: '就业手续',
      vi: 'Thủ tục việc làm',
    ),
  ),
  4: CategoryItem(
    id: 4,
    icon: Icons.assignment_outlined,
    group: CategoryGroupId.a,
    name: L10nText(
      ko: '체류신고',
      en: 'Residence reporting',
      zh: '居留申报',
      vi: 'Khai báo cư trú',
    ),
  ),

  // ── Group B · 생활 정착 ──────────────────────────────────────────
  5: CategoryItem(
    id: 5,
    icon: Icons.local_hospital_outlined,
    group: CategoryGroupId.b,
    name: L10nText(ko: '병원', en: 'Hospitals', zh: '医院', vi: 'Bệnh viện'),
  ),
  6: CategoryItem(
    id: 6,
    icon: Icons.health_and_safety_outlined,
    group: CategoryGroupId.b,
    name: L10nText(ko: '보험', en: 'Insurance', zh: '保险', vi: 'Bảo hiểm'),
  ),
  7: CategoryItem(
    id: 7,
    icon: Icons.apartment_outlined,
    group: CategoryGroupId.b,
    name: L10nText(ko: '주거', en: 'Housing', zh: '住房', vi: 'Nhà ở'),
  ),
  8: CategoryItem(
    id: 8,
    icon: Icons.directions_bus_outlined,
    group: CategoryGroupId.b,
    name: L10nText(ko: '교통', en: 'Transportation', zh: '交通', vi: 'Giao thông'),
  ),

  // ── Group C · 노동 권익 ──────────────────────────────────────────
  9: CategoryItem(
    id: 9,
    icon: Icons.fact_check_outlined,
    group: CategoryGroupId.c,
    name: L10nText(
      ko: '근로계약서',
      en: 'Employment contract',
      zh: '劳动合同',
      vi: 'Hợp đồng lao động',
    ),
  ),
  10: CategoryItem(
    id: 10,
    icon: Icons.payments_outlined,
    group: CategoryGroupId.c,
    name: L10nText(ko: '임금체불', en: 'Unpaid wages', zh: '拖欠工资', vi: 'Nợ lương'),
  ),
  11: CategoryItem(
    id: 11,
    icon: Icons.medical_services_outlined,
    group: CategoryGroupId.c,
    name: L10nText(
      ko: '산업재해',
      en: 'Workplace injury',
      zh: '工伤',
      vi: 'Tai nạn lao động',
    ),
  ),
  12: CategoryItem(
    id: 12,
    icon: Icons.support_agent,
    group: CategoryGroupId.c,
    name: L10nText(
      ko: '상담기관',
      en: 'Support organizations',
      zh: '咨询机构',
      vi: 'Cơ quan tư vấn',
    ),
  ),
};

const Map<CategoryGroupId, CategoryGroupData> categoryGroups = {
  CategoryGroupId.a: CategoryGroupData(
    id: CategoryGroupId.a,
    color: Color(0xFF2196F3),
    backgroundTint: Color(0xFFE3F2FD),
    markLabel: L10nText(ko: '필수행정', en: 'ADMIN', zh: '必办手续', vi: 'THỦ TỤC'),
    name: L10nText(ko: '그룹 A', en: 'Group A ', zh: 'A组', vi: 'Nhóm A'),
    title: L10nText(
      ko: '필수 행정',
      en: 'Essential admin',
      zh: '必办行政',
      vi: 'Thủ tục bắt buộc',
    ),
    itemIds: [1, 2, 3, 4],
  ),
  CategoryGroupId.b: CategoryGroupData(
    id: CategoryGroupId.b,
    color: Color(0xFF4CAF50),
    backgroundTint: Color(0xFFE8F5E9),
    markLabel: L10nText(ko: '생활정착', en: 'LIVING', zh: '生活安顿', vi: 'SINH HOẠT'),
    name: L10nText(ko: '그룹 B', en: 'Group B', zh: 'B组', vi: 'Nhóm B'),
    title: L10nText(
      ko: '생활 정착',
      en: 'Settling in',
      zh: '生活安顿',
      vi: 'Ổn định cuộc sống',
    ),
    itemIds: [5, 6, 7, 8],
  ),
  CategoryGroupId.c: CategoryGroupData(
    id: CategoryGroupId.c,
    color: Color(0xFF2196F3),
    backgroundTint: Color(0xFFE3F2FD),
    markLabel: L10nText(ko: '노동권익', en: 'RIGHTS', zh: '劳动权益', vi: 'QUYỀN LỢI'),
    name: L10nText(ko: '그룹 C', en: 'Group C', zh: 'C组', vi: 'Nhóm C'),
    title: L10nText(
      ko: '노동 권익',
      en: 'Labor rights',
      zh: '劳动权益',
      vi: 'Quyền lợi lao động',
    ),
    itemIds: [9, 10, 11, 12],
  ),
};

/// 표지의 "자주 보는 항목" 3칩 — (categoryId, 줄바꿈 포함 짧은 라벨).
/// html_files/생활백과사전.html 홈 화면의 퀵버튼(계약서 체크·ARC 발급·권리구제)과 동일하게 맞췄다.
const quickAccessChips = [
  (
    9,
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
    10,
    L10nText(
      ko: '임금체불\n대응',
      en: 'Unpaid wage\nresponse',
      zh: '拖欠工资\n应对',
      vi: 'Ứng phó\nnợ lương',
    ),
  ),
];
