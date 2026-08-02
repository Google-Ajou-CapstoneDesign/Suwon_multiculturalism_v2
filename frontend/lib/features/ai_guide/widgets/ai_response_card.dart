import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../models/ai_response.dart';
import 'recommended_org_card.dart';

/// AI 응답 렌더링: 사실 답변(FactAnswer) / 위험 안내(RiskNotice+라우팅 버튼) / 추천기관 카드.
class AiResponseCard extends StatelessWidget {
  const AiResponseCard({super.key, required this.response, required this.onRoutingTap});

  final AiResponse response;
  final ValueChanged<RoutingTarget> onRoutingTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (response.factAnswer != null)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
                bottomRight: Radius.circular(14),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              response.factAnswer!,
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.4),
            ),
          ),
        if (response.riskNotice != null)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.amberBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.amberBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.amberText),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    response.riskNotice!,
                    style: const TextStyle(fontSize: 11, color: AppColors.amberText, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        if (response.routingTarget != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => onRoutingTap(response.routingTarget!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: Text(response.routingTarget!.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        RecommendedOrgCard(orgs: response.recommendedOrgs),
      ],
    );
  }
}
