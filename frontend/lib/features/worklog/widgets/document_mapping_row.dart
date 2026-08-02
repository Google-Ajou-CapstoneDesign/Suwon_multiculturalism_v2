import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

enum MappingStatus {
  /// 사실형 필드 — 값이 그대로 서식 칸에 자동 치환됨(성명·날짜·금액 등).
  auto,

  /// 이용자가 입력한 문장을 가공 없이 원문 그대로 출력(5W1H 서술 등).
  verbatim,

  /// 판단·계산이 필요해 공란으로 남기고 전문가 상담을 안내하는 필드.
  blocked,
}

/// 모듈3 4단계 · '내가 입력한 값이 서식 어디에 들어가는지' 시각화하는 행.
class DocumentMappingRow extends StatelessWidget {
  const DocumentMappingRow({
    super.key,
    required this.label,
    this.value,
    required this.status,
    this.notice,
  });

  final String label;
  final String? value;
  final MappingStatus status;
  final String? notice;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case MappingStatus.blocked:
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.amberBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.amberBorder),
          ),
          child: Text(notice ?? '', style: const TextStyle(fontSize: 11, color: AppColors.amberText)),
        );

      case MappingStatus.verbatim:
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$label (원문 그대로 출력)', style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
              const SizedBox(height: 4),
              Text(value ?? '', style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.4)),
            ],
          ),
        );

      case MappingStatus.auto:
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              Row(
                children: [
                  Text(value ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, size: 12, color: AppColors.primary),
                ],
              ),
            ],
          ),
        );
    }
  }
}
