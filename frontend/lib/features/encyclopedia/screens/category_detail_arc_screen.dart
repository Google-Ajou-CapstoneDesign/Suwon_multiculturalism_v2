import 'package:flutter/material.dart';
import '../../../common/widgets/app_card.dart';
import '../../../theme/app_colors.dart';

/// 모듈1 MVP 카테고리 ① 외국인등록증(ARC) 발급.
/// 5단 카드 템플릿(①아이콘·제목 ②접근경로 ③정의 ④사용시점 ⑤단계별가이드) + 준비서류 체크리스트.
/// TODO(backend): content_categories/arc 문서에서 실제 검수 콘텐츠 로드.
class CategoryDetailArcScreen extends StatefulWidget {
  const CategoryDetailArcScreen({super.key});

  @override
  State<CategoryDetailArcScreen> createState() => _CategoryDetailArcScreenState();
}

class _CategoryDetailArcScreenState extends State<CategoryDetailArcScreen> {
  final _checklist = {
    '여권': false,
    '표준규격사진 1매': false,
    '수수료 3만원': false,
  };

  static const _steps = [
    _StepContent('① 아이콘·제목', '출입국사무소에서 발급하는 외국인 신분증'),
    _StepContent('② 접근 경로', '관할 출입국·외국인청 방문 (사전 예약 필요)'),
    _StepContent('③ 정의', '한국 내 체류자격을 증명하는 신분증으로, 은행·통신·행정 서비스 이용의 기본 전제 조건'),
    _StepContent('④ 사용 시점', '입국 후 90일 이내, 은행·통신 개통 전 필수'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('외국인등록증(ARC) 발급')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          for (final step in _steps) ...[
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StepLabel(text: step.label),
                  const SizedBox(height: 6),
                  Text(step.body, style: const TextStyle(fontSize: 14, height: 1.4)),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],

          // ⑤ 단계별 가이드 (화면 캡처 자리 — TODO: Storage에서 이미지 로드)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _StepLabel(text: '⑤ 단계별 가이드'),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(3, (i) {
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.border.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.image_outlined, color: AppColors.textMuted),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // 준비 서류 체크리스트
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('준비 서류 체크리스트', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 4),
                for (final entry in _checklist.entries)
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    value: entry.value,
                    title: Text(entry.key, style: const TextStyle(fontSize: 14)),
                    onChanged: (v) => setState(() => _checklist[entry.key] = v ?? false),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepContent {
  const _StepContent(this.label, this.body);
  final String label;
  final String body;
}

class _StepLabel extends StatelessWidget {
  const _StepLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.blueBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
      ),
    );
  }
}
