import 'package:flutter/material.dart';

enum CategoryDetailType { arcDemo, telecomDemo, placeholder }

/// 백과사전 20개 카테고리 항목. group A~D, 5개씩.
/// P0에서는 ARC 발급 · 통신 개통 2개만 실제 화면으로 연결하고 나머지는 스켈레톤.
class CategoryItem {
  const CategoryItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.group,
    this.detailType = CategoryDetailType.placeholder,
  });

  final String id;
  final String title;
  final IconData icon;
  final CategoryGroup group;
  final CategoryDetailType detailType;
}

enum CategoryGroup {
  a('그룹 A · 필수 행정·인증'),
  b('그룹 B · 생활 정착'),
  c('그룹 C · 노동 권익'),
  d('그룹 D · 심화·커뮤니티');

  const CategoryGroup(this.label);
  final String label;
}

const mockCategories = <CategoryItem>[
  // 그룹 A
  CategoryItem(
    id: 'arc',
    title: 'ARC 발급',
    icon: Icons.badge_outlined,
    group: CategoryGroup.a,
    detailType: CategoryDetailType.arcDemo,
  ),
  CategoryItem(id: 'auth_app', title: '본인인증', icon: Icons.fingerprint, group: CategoryGroup.a),
  CategoryItem(
    id: 'telecom',
    title: '통신개통',
    icon: Icons.signal_cellular_alt,
    group: CategoryGroup.a,
    detailType: CategoryDetailType.telecomDemo,
  ),
  CategoryItem(id: 'residence', title: '전입신고', icon: Icons.home_outlined, group: CategoryGroup.a),
  CategoryItem(id: 'emergency', title: '긴급신고', icon: Icons.support_agent, group: CategoryGroup.a),

  // 그룹 B
  CategoryItem(id: 'bank', title: '은행·송금', icon: Icons.account_balance_outlined, group: CategoryGroup.b),
  CategoryItem(id: 'housing', title: '주거', icon: Icons.apartment_outlined, group: CategoryGroup.b),
  CategoryItem(id: 'transit', title: '대중교통', icon: Icons.directions_bus_outlined, group: CategoryGroup.b),
  CategoryItem(id: 'health', title: '의료·건강보험', icon: Icons.local_hospital_outlined, group: CategoryGroup.b),
  CategoryItem(id: 'korean', title: '한국어 학습', icon: Icons.school_outlined, group: CategoryGroup.b),

  // 그룹 C
  CategoryItem(id: 'contract_check', title: '계약서 체크', icon: Icons.fact_check_outlined, group: CategoryGroup.c),
  CategoryItem(id: 'min_wage', title: '최저임금', icon: Icons.attach_money, group: CategoryGroup.c),
  CategoryItem(id: 'insurance4', title: '4대보험', icon: Icons.shield_outlined, group: CategoryGroup.c),
  CategoryItem(id: 'worklog_guide', title: '근무기록장', icon: Icons.edit_calendar_outlined, group: CategoryGroup.c),
  CategoryItem(id: 'workplace_change', title: '사업장 변경', icon: Icons.swap_horiz, group: CategoryGroup.c),

  // 그룹 D
  CategoryItem(id: 'counsel_org', title: '상담기관 안내', icon: Icons.groups_outlined, group: CategoryGroup.d),
  CategoryItem(id: 'legal_aid', title: '권리구제 지원', icon: Icons.gavel_outlined, group: CategoryGroup.d),
  CategoryItem(id: 'visa_calendar', title: '비자 만료 알림', icon: Icons.event_outlined, group: CategoryGroup.d),
  CategoryItem(id: 'community', title: '국가별 커뮤니티', icon: Icons.public_outlined, group: CategoryGroup.d),
  CategoryItem(id: 'faq', title: 'FAQ', icon: Icons.help_outline, group: CategoryGroup.d),
];
