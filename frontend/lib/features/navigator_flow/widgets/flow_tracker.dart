import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../theme/app_colors.dart';
import '../models/flow_block.dart';

/// 접수 이후 진행 트래커 카드 — navigator_flow_screen.dart에서 분리.
/// now는 데모용 "지금 단계", completedStages는 사용자가 직접 완료 표시한
/// 단계(세션 한정 상태) — 두 조건 중 하나만 맞아도 완료로 그린다.
class TrackerCard extends StatelessWidget {
  const TrackerCard({
    super.key,
    required this.title,
    required this.accentColor,
    required this.stages,
    required this.lang,
    required this.now,
    required this.completedStages,
    required this.onTapStage,
  });
  final String title;
  final Color accentColor;
  final List<TrackStage> stages;
  final AppLanguage lang;
  final int now;
  final Set<int> completedStages;
  final ValueChanged<int> onTapStage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${now + 1} / ${stages.length}',
                style: const TextStyle(
                  fontSize: 9.5,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(stages.length, (i) {
                final done = i < now || completedStages.contains(i);
                final isNow = i == now && !completedStages.contains(i);
                final color = done
                    ? AppColors.secondary
                    : (isNow ? AppColors.accent : const Color(0xFFCBD5E1));
                return SizedBox(
                  width: 58,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 2,
                              color: i == 0
                                  ? Colors.transparent
                                  : (i <= now || completedStages.contains(i - 1)
                                        ? AppColors.secondary
                                        : const Color(0xFFE2E8F0)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      InkWell(
                        onTap: () => onTapStage(i),
                        borderRadius: BorderRadius.circular(20),
                        child: Column(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: done || isNow
                                    ? color
                                    : const Color(0xFFCBD5E1),
                                shape: BoxShape.circle,
                                boxShadow: isNow
                                    ? [
                                        const BoxShadow(
                                          color: Color(0xFFE3F2FD),
                                          blurRadius: 0,
                                          spreadRadius: 4,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                done ? '✓' : '${i + 1}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              stages[i].label.of(lang),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 8.5,
                                color: done || isNow
                                    ? AppColors.textSecondary
                                    : AppColors.textMuted,
                                fontWeight: done || isNow
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class PopBlock extends StatelessWidget {
  const PopBlock({super.key, required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF334155),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
