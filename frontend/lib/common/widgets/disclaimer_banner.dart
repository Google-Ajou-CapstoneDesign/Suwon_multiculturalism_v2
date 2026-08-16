import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// 법률 판단이 아님을 알리는 고지문 배너. Amber 배경으로 고정.
class DisclaimerBanner extends StatelessWidget {
  const DisclaimerBanner({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.noticeBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.noticeBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.noticeText),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.noticeText,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
