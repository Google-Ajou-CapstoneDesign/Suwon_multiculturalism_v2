import 'package:flutter/material.dart';
import '../../../common/models/org.dart';
import '../../../common/widgets/app_card.dart';
import '../../../common/widgets/disclaimer_banner.dart';
import '../../../common/widgets/step_indicator.dart';
import '../../../theme/app_colors.dart';
import '../widgets/document_mapping_row.dart';

/// 임금체불 대응 네비게이터 5단계.
/// 1.유형분류 2.절차안내 3.사실입력+증빙 4.표준서식 자동채움 5.기관라우팅
/// 안전 원칙: 자유서술형 최소화(5W1H만 예외), 어떤 단계에서도 AI가 새 법적 판단 문장을 생성하지 않는다.
/// TODO(backend): 1·3단계 입력값을 wage_cases 컬렉션에 저장하고, 4단계는 서버의 템플릿 치환 API 결과로 교체.
class WageNavigatorScreen extends StatefulWidget {
  const WageNavigatorScreen({super.key});

  @override
  State<WageNavigatorScreen> createState() => _WageNavigatorScreenState();
}

class _WageNavigatorScreenState extends State<WageNavigatorScreen> {
  static const _total = 5;
  int _current = 1;
  int _caseType = 0; // 0: 단순 임금체불, 1: 그 외(수당 등)

  void _next() => setState(() => _current = (_current + 1).clamp(1, _total));
  void _prev() => setState(() => _current = (_current - 1).clamp(1, _total));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('임금체불 대응 · $_current/$_total단계')),
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
        return _TypeSelectStep(selected: _caseType, onChanged: (v) => setState(() => _caseType = v));
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
  const _TypeSelectStep({required this.selected, required this.onChanged});
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const options = [
      ('단순 임금체불', '약정 금액 자체를 못 받은 경우 (예: 200만원 약정에 150만원만 지급)'),
      ('그 외 (수당 체불 등)', '연장·야간·휴일수당 등 계산 근거가 필요한 경우'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('임금체불 유형을 선택해 주세요', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: 12),
        for (var i = 0; i < options.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              onTap: () => onChanged(i),
              child: Row(
                children: [
                  Icon(
                    selected == i ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: selected == i ? AppColors.primary : AppColors.textMuted,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(options[i].$1, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        const SizedBox(height: 2),
                        Text(options[i].$2, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (selected == 1)
          const DisclaimerBanner(
            message: '수당 계산은 법률적 판단이 필요한 영역이에요. 사실관계 정리까지만 도와드리고, 금액 확정은 노무사 상담으로 안내할게요.',
          ),
      ],
    );
  }
}

class _ProcedureGuideStep extends StatelessWidget {
  const _ProcedureGuideStep();

  static const _points = [
    '진정 제기 — 관할 고용노동지청에 임금체불 진정서 접수',
    '근로감독관 조사 — 사업주 출석 요구 및 사실관계 확인',
    '시정지시·처리 — 사업주가 지급하면 종결, 미이행 시 형사 절차 진행',
    '소액체당금 — 요건 충족 시 국가가 대신 지급 후 사업주에게 구상',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('임금체불 진정 절차 (간략 안내)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
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
                        decoration: const BoxDecoration(color: AppColors.blueBg, shape: BoxShape.circle),
                        child: Text('${i + 1}', style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w700)),
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
        const DisclaimerBanner(message: '이 안내는 절차 흐름 설명이며, 승소 가능성이나 위법 여부를 판단하지 않습니다.'),
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
        const Text('사실관계 입력', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: 4),
        const Text(
          '근무기록장에 이미 기록된 항목은 자동으로 불러와요. 날짜·숫자·선택형 값만 입력합니다.',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 12),
        const _LabeledField(label: '근무 시작일', hint: '2026-03-01'),
        const _LabeledField(label: '마지막 근무일', hint: '2026-07-20'),
        const _LabeledField(label: '약정 월급 (원)', hint: '2,000,000', keyboardType: TextInputType.number),
        const _LabeledField(label: '미지급 금액 (원)', hint: '500,000', keyboardType: TextInputType.number),
        const _LabeledField(label: '사업장명', hint: 'OO식당'),
        const SizedBox(height: 6),
        const Text('경위 (5W1H로 사실만 서술 — 원문 그대로 서식에 옮겨집니다)',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: '언제, 어디서, 무엇을, 어떻게 — 있었던 사실만 적어주세요',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          // TODO(backend): 파일 원본 암호화 저장(Firebase Storage), OCR·내용분석 없음.
          onPressed: () {},
          icon: const Icon(Icons.attach_file, size: 18),
          label: const Text('증빙 첨부 (근로계약서·급여명세서·출퇴근기록 등)'),
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
  const _LabeledField({required this.label, required this.hint, this.keyboardType});
  final String label;
  final String hint;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          TextField(
            keyboardType: keyboardType,
            decoration: InputDecoration(hintText: hint),
          ),
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
        const Text('표준 서식 자동 매핑 — 고용노동부 진정서', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: 12),
        AppCard(
          child: const Column(
            children: [
              DocumentMappingRow(label: '성명', value: '홍○○', status: MappingStatus.auto),
              DocumentMappingRow(label: '사업장명', value: 'OO식당', status: MappingStatus.auto),
              DocumentMappingRow(label: '근무기간', value: '26.3.1-7.20', status: MappingStatus.auto),
              DocumentMappingRow(label: '미지급액', value: '500,000원', status: MappingStatus.auto),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const DisclaimerBanner(message: '정확한 금액은 조사 과정에서 확정됩니다', icon: Icons.info_outline),
        const SizedBox(height: 10),
        const DocumentMappingRow(
          label: '진정 취지 및 경위',
          value: '"3월 1일부터 7월 20일까지 근무했는데 7월 급여 50만원을 아직 받지 못했습니다..."',
          status: MappingStatus.verbatim,
        ),
        const Text('시스템은 이 문장을 가공·수정하지 않습니다', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
        const SizedBox(height: 10),
        const DocumentMappingRow(
          label: '통상임금·시간외수당 등',
          status: MappingStatus.blocked,
          notice: '복잡 산정 항목은 공란으로 남겨요. 상담 시 노무사·근로감독관과 함께 작성하세요.',
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
    Org(name: '경기지방고용노동청 수원지청', distanceKm: 2.4),
    Org(name: '수원시비정규직노동자복지센터', distanceKm: 1.1),
    Org(name: '대한법률구조공단 수원지부', distanceKm: 3.6),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('이런 기관이 있습니다', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: 4),
        const Text(
          '제출은 이용자 본인이 직접 접수합니다. 서비스가 접수를 대행하지 않습니다.',
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
                    backgroundColor: AppColors.primary,
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
