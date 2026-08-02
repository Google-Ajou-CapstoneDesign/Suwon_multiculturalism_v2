import 'package:flutter/material.dart';
import '../../../common/widgets/app_card.dart';
import '../../../theme/app_colors.dart';

/// 모듈1 MVP 카테고리 ③ 통신 개통. ARC 유무 필터 + 요금제 비교표 + PASS 인증 스테퍼.
/// TODO(backend): content_categories/telecom 문서에서 실제 비교표 데이터 로드.
class CategoryDetailTelecomScreen extends StatefulWidget {
  const CategoryDetailTelecomScreen({super.key});

  @override
  State<CategoryDetailTelecomScreen> createState() => _CategoryDetailTelecomScreenState();
}

class _CategoryDetailTelecomScreenState extends State<CategoryDetailTelecomScreen> {
  bool _arcOwned = true;

  static const _rows = [
    ('통신 3사', '3~7만원', '필요'),
    ('알뜰폰', '1~3만원', '필요'),
    ('선불 유심', '일 단위 충전', '불필요'),
  ];

  static const _passSteps = ['앱 설치', '본인 확인', '인증서 받기'];
  static const _passCurrent = 3; // 1-based, 완료된 단계까지 포함해 현재 단계 표시

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('통신 개통')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Row(
            children: [
              Expanded(
                child: _FilterPill(
                  label: 'ARC 있음',
                  selected: _arcOwned,
                  onTap: () => setState(() => _arcOwned = true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _FilterPill(
                  label: 'ARC 없음(선불폰)',
                  selected: !_arcOwned,
                  onTap: () => setState(() => _arcOwned = false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _TableRow(cells: const ['구분', '월 요금대', 'ARC'], isHeader: true),
                for (final row in _rows)
                  _TableRow(cells: [row.$1, row.$2, row.$3], highlightLast: row.$3 == '필요'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('PASS 본인인증 연동 단계', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 14),
                Row(
                  children: List.generate(_passSteps.length, (i) {
                    final step = i + 1;
                    final done = step < _passCurrent;
                    final now = step == _passCurrent;
                    final color = done
                        ? AppColors.secondary
                        : now
                            ? AppColors.accent
                            : AppColors.border;
                    return Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              if (i > 0) Expanded(child: Container(height: 2, color: AppColors.border)),
                              Container(
                                width: 22,
                                height: 22,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                                child: Text(
                                  done ? '✓' : '$step',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: done || now ? Colors.white : AppColors.textMuted,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              if (i < _passSteps.length - 1)
                                Expanded(child: Container(height: 2, color: AppColors.border)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(_passSteps[i], style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.primary : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({required this.cells, this.isHeader = false, this.highlightLast = false});
  final List<String> cells;
  final bool isHeader;
  final bool highlightLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isHeader ? AppColors.background : Colors.white,
        border: const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(cells[0], style: _style(isHeader, false))),
          Expanded(flex: 2, child: Text(cells[1], style: _style(isHeader, false))),
          Expanded(
            flex: 1,
            child: Text(cells[2], textAlign: TextAlign.right, style: _style(isHeader, highlightLast)),
          ),
        ],
      ),
    );
  }

  TextStyle _style(bool header, bool highlight) {
    if (header) {
      return const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary);
    }
    if (highlight) {
      return const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary);
    }
    return const TextStyle(fontSize: 13, color: AppColors.textPrimary);
  }
}
