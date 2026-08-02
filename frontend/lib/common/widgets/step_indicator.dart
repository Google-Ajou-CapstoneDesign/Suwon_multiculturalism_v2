import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// 임금체불/산재 대응 네비게이터 공통 단계 표시기.
/// done=Teal, now=Amber, upcoming=Gray
class StepIndicator extends StatelessWidget {
  const StepIndicator({super.key, required this.total, required this.current});

  final int total;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final step = i + 1;
        final isDone = step < current;
        final isNow = step == current;
        final color = isDone
            ? AppColors.secondary
            : isNow
                ? AppColors.accent
                : AppColors.border;

        return Expanded(
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Text(
                  isDone ? '✓' : '$step',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isNow || isDone ? Colors.white : AppColors.textMuted,
                  ),
                ),
              ),
              if (step < total)
                Expanded(child: Container(height: 2, color: AppColors.border)),
            ],
          ),
        );
      }),
    );
  }
}
