import 'package:flutter/material.dart';
import '../../../common/models/org.dart';
import '../../../common/widgets/app_card.dart';
import '../../../common/widgets/disclaimer_banner.dart';
import '../../../common/widgets/step_indicator.dart';
import '../../../theme/app_colors.dart';
import '../widgets/document_mapping_row.dart';

/// 산업재해 대응 네비게이터 5단계.
/// 1.유형분류 2.절차안내 3.사고사실입력+증빙+5W1H 4.요양급여신청서 자동채움 5.기관라우팅
/// 임금체불과 동일한 안전 원칙: 과실·인과관계 판단 문장 생성 금지, 사실형 필드만 자동 채움.
/// TODO(backend): 1·3단계 입력값을 accident_cases 컬렉션에 저장, 4단계는 서버 템플릿 치환 API로 교체.
class AccidentNavigatorScreen extends StatefulWidget {
  const AccidentNavigatorScreen({super.key});

  @override
  State<AccidentNavigatorScreen> createState() => _AccidentNavigatorScreenState();
}

class _AccidentNavigatorScreenState extends State<AccidentNavigatorScreen> {
  static const _total = 5;
  int _current = 1;
  int _accidentType = 0;

  void _next() => setState(() => _current = (_current + 1).clamp(1, _total));
  void _prev() => setState(() => _current = (_current - 1).clamp(1, _total));

  static const _types = ['끼임 사고', '떨어짐(추락)', '넘어짐(전도)', '절단·베임·찔림', '물체에 맞음(낙하·비래)', '기타'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('산재 대응 · $_current/$_total단계')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: StepIndicator(total: _total, current: _current),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [_buildStep(_current)],
            ),
          ),
          _BottomNav(
            current: _current,
            total: _total,
            onPrev: _current > 1 ? _prev : null,
            onNext: _current < _total ? _next : null,
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int step) {
    switch (step) {
      case 1:
        return _TypeSelectStep(types: _types, selected: _accidentType, onChanged: (v) => setState(() => _accidentType = v));
      case 2:
        return const _ProcedureGuideStep();
      case 3:
        return const _FactInputStep();
      case 4:
        return const _DocumentMappingStep();
      default:
        return const _OrgRoutingStep();
    }
  }
}

class _TypeSelectStep extends StatelessWidget {
  const _TypeSelectStep({required this.types, required this.selected, required this.onChanged});
  final List<String> types;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('산재 피해 유형을 선택해 주세요', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(types.length, (i) {
            final isSelected = i == selected;
            return ChoiceChip(
              label: Text(types[i]),
              selected: isSelected,
              onSelected: (_) => onChanged(i),
              selectedColor: AppColors.accent,
              labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary, fontSize: 13),
              backgroundColor: Colors.white,
              side: BorderSide(color: isSelected ? AppColors.accent : AppColors.border),
            );
          }),
        ),
      ],
    );
  }
}

class _ProcedureGuideStep extends StatelessWidget {
  const _ProcedureGuideStep();

  static const _points = [
    '병원 진단 — 산재 지정 의료기관에서 진단서 발급',
    '요양급여 신청 — 근로복지공단에 신청서 제출',
    '공단 조사 — 재해 경위·업무관련성 확인',
    '승인·불승인 결정 — 불승인 시 심사·재심사 청구 가능',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('산재 신청 절차 (간략 안내)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < _points.length; i++)
                Padding(
                  padding: EdgeInsets.only(bottom: i < _points.length - 1 ? 10 : 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(color: AppColors.amberBg, shape: BoxShape.circle),
                        child: Text('${i + 1}', style: const TextStyle(fontSize: 11, color: AppColors.amberText, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(_points[i], style: const TextStyle(fontSize: 13, height: 1.4))),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const DisclaimerBanner(message: '치료비 본인 부담을 거절할 수 있는 절차 안내이며, 산재 인정 여부를 판단하지 않습니다.'),
      ],
    );
  }
}

class _FactInputStep extends StatelessWidget {
  const _FactInputStep();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('사고 사실 입력', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: 12),
        const _LabeledField(label: '사고 일시', hint: '2026-07-30 14:20'),
        const _LabeledField(label: '사고 장소', hint: '작업장 2층 창고'),
        const _LabeledField(label: '부상 부위', hint: '오른손 손가락'),
        const SizedBox(height: 6),
        const Text('목격자 유무', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          children: ['있음', '없음'].map((l) => ChoiceChip(label: Text(l), selected: l == '있음', onSelected: (_) {})).toList(),
        ),
        const SizedBox(height: 12),
        const Text('경위 (5W1H로 사실만 서술 — 원문 그대로 서식에 옮겨집니다)',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: '언제, 어디서, 무엇을 하다가, 어떻게 다쳤는지 사실만 적어주세요',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          // TODO(backend): 진단서 등 원본 암호화 저장(Firebase Storage), OCR·내용분석 없음.
          onPressed: () {},
          icon: const Icon(Icons.attach_file, size: 18),
          label: const Text('증빙 첨부 (진단서·사고현장 사진·목격자 진술 등)'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            minimumSize: const Size.fromHeight(0),
          ),
        ),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.hint});
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          TextField(decoration: InputDecoration(hintText: hint)),
        ],
      ),
    );
  }
}

class _DocumentMappingStep extends StatelessWidget {
  const _DocumentMappingStep();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('표준 서식 자동 매핑 — 요양급여신청서', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: 12),
        AppCard(
          child: const Column(
            children: [
              DocumentMappingRow(label: '신청인 성명', value: '홍○○', status: MappingStatus.auto),
              DocumentMappingRow(label: '사업장명', value: 'OO식당', status: MappingStatus.auto),
              DocumentMappingRow(label: '재해 발생 일시', value: '26.7.30 14:20', status: MappingStatus.auto),
              DocumentMappingRow(label: '최초 요양기관', value: '수원산재병원', status: MappingStatus.auto),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const DocumentMappingRow(
          label: '재해 경위',
          value: '"창고에서 물건을 옮기던 중 오른손이 선반에 끼여 다쳤습니다..."',
          status: MappingStatus.verbatim,
        ),
        const Text('시스템은 이 문장을 가공·수정하지 않습니다', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
        const SizedBox(height: 10),
        const DocumentMappingRow(
          label: '업무상 재해 인정 여부·과실 비율',
          status: MappingStatus.blocked,
          notice: '판단이 필요한 항목은 공란으로 남겨요. 근로복지공단 조사·노무사 상담으로 안내할게요.',
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            // TODO(backend): 서버에서 PDF 생성 API 호출 (템플릿 치환, LLM 미사용).
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.download, size: 18),
            label: const Text('PDF로 다운로드', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(height: 6),
        const Center(
          child: Text('제출 대행 불가 · 직접 방문 또는 팩스 제출 전용',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ),
      ],
    );
  }
}

class _OrgRoutingStep extends StatelessWidget {
  const _OrgRoutingStep();

  static const _orgs = [
    Org(name: '근로복지공단 수원지사', distanceKm: 2.1),
    Org(name: '안전보건공단 경기지역본부', distanceKm: 4.3),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('이런 기관이 있습니다', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: 4),
        const Text(
          '승인 여부 등 진행 상태는 이용자가 직접 기록합니다.',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 12),
        for (final org in _orgs)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(child: Text(org.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
                  Text('${org.distanceKm}km', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.current, required this.total, this.onPrev, this.onNext});
  final int current;
  final int total;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            children: [
              if (onPrev != null)
                Expanded(
                  child: OutlinedButton(
                    onPressed: onPrev,
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: const Text('이전'),
                  ),
                ),
              if (onPrev != null) const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: onNext ?? () => Navigator.of(context).popUntil((r) => r.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(onNext != null ? '다음 (${current + 1}/$total)' : '완료'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
