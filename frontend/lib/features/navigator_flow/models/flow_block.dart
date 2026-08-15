import '../../../core/app_language.dart';
import 'form_field_spec.dart';

/// 임금체불/산재 내비게이터의 단계별 콘텐츠 블록.
/// 프론트엔드_구상_확장.html의 FLOWS 데이터 구조(opt/notice/check/raw/fill/tracker)를
/// 그대로 옮긴 것 — 화면(NavigatorFlowScreen)은 이 블록 타입만 보고 렌더링을 분기한다.
sealed class FlowBlock {
  const FlowBlock();
}

class OptionsBlock extends FlowBlock {
  const OptionsBlock(this.items);
  final List<FlowOption> items;
}

class FlowOption {
  const FlowOption({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });
  final String emoji;
  final L10nText title;
  final L10nText subtitle;
}

enum NoticeTone { amber, blue, teal }

class NoticeBlock extends FlowBlock {
  const NoticeBlock({
    required this.tone,
    required this.title,
    required this.body,
  });
  final NoticeTone tone;
  final L10nText title;
  final L10nText body;
}

class ChecklistBlock extends FlowBlock {
  const ChecklistBlock(this.items);
  final List<L10nText> items;
}

/// 자유 서술형(5W1H) 입력 — 가공 없이 원문 그대로 서식에 옮겨진다는 것을 전제로 한다.
class RawTextBlock extends FlowBlock {
  const RawTextBlock(this.placeholder);
  final L10nText placeholder;
}

enum FillTag { auto, raw, blank }

class FlowFillRow {
  const FlowFillRow({
    required this.label,
    required this.value,
    required this.tag,
  });
  final L10nText label;
  final L10nText value;
  final FillTag tag;
}

class FillCardBlock extends FlowBlock {
  const FillCardBlock(this.rows);
  final List<FlowFillRow> rows;
}

/// 접수 이후 진행 상황을 보여주는 트래커. now는 데모용 고정 현재 단계 인덱스.
class TrackerBlock extends FlowBlock {
  const TrackerBlock({required this.now});
  final int now;
}

class FlowStep {
  const FlowStep({
    required this.title,
    required this.lead,
    required this.blocks,
    this.help,
  });
  final L10nText title;
  final L10nText lead;
  final List<FlowBlock> blocks;

  /// 제목 옆 "❓" 버튼으로 여는 보충 설명 팝업 — 없으면 버튼 자체가 안 뜬다.
  final StepHelp? help;
}

/// FlowStep.help 팝업 하나(아이콘+제목+본문).
class StepHelp {
  const StepHelp({required this.icon, required this.title, required this.body});
  final String icon;
  final L10nText title;
  final L10nText body;
}

/// 트래커 레일의 노드 하나 + 탭했을 때 뜨는 팝업(pop) 3블록(+선택적 4번째 블록).
class TrackStage {
  const TrackStage({
    required this.label,
    required this.whatHappens,
    required this.documentsNeeded,
    required this.watchOutFor,
    this.extra,
  });

  final L10nText label;
  final L10nText whatHappens;
  final L10nText documentsNeeded;
  final L10nText watchOutFor;

  /// 일부 단계에만 붙는 추가 안내(예: 임금체불의 "간이대지급금" 설명) — 없으면 렌더링하지 않는다.
  final L10nText? extra;
}

/// 번호/글머리 목록 — 아코디언 본문의 "온라인접수 3단계", "혼자해결하기 팁" 등에 공용.
class ListBlock extends FlowBlock {
  const ListBlock(this.items, {this.numbered = true});
  final List<L10nText> items;
  final bool numbered;
}

/// 기관/전문가 안내 카드 — 접이식 섹션 본문 안에서 쓰인다.
class OrgCardBlock extends FlowBlock {
  const OrgCardBlock({
    required this.name,
    required this.subtitle,
    this.phone,
    this.legalBasis,
    this.tags = const [],
  });
  final L10nText name;
  final L10nText subtitle;
  final String? phone;
  final L10nText? legalBasis;
  final List<L10nText> tags;
}

/// 접이식 섹션 하나(아이콘+제목+부제 헤더, 펼치면 body).
class AccordionItemData {
  const AccordionItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.body,
  });
  final String icon;
  final L10nText title;
  final L10nText subtitle;

  /// body는 기존/신규 FlowBlock을 재귀적으로 재사용한다(예: ListBlock, OrgCardBlock,
  /// NoticeBlock) — 단, 별도 콜백이 필요한 블록(MessageTemplateBlock 등)은 여기 넣지 않는다.
  final List<FlowBlock> body;
}

/// 임금 제출방법 4항목, 산재 기관허브 4항목에 공용으로 쓰는 접이식 섹션 목록.
class AccordionBlock extends FlowBlock {
  const AccordionBlock(this.items);
  final List<AccordionItemData> items;
}

/// auto/raw/blank 색상 범례 — 파라미터 없음, 정적.
class LegendBlock extends FlowBlock {
  const LegendBlock();
}

/// 백과사전 특정 카테고리로 이동하는 딥링크 버튼.
class EncyclopediaLinkBlock extends FlowBlock {
  const EncyclopediaLinkBlock({required this.categoryId, required this.label});
  final int categoryId;
  final L10nText label;
}

/// 근무기록장/임금명세서/계산기값 등에서 값을 불러오는 토글 버튼 묶음.
enum ImportSource { workLog, payslip, calcResult, profile }

class ImportButtonsBlock extends FlowBlock {
  const ImportButtonsBlock(this.sources);
  final List<ImportSource> sources;
}

/// 실제 입력 가능한 서식 — wage_fields.dart/injury_fields.dart가 sections를 공급한다.
/// documentTitle/formSubtitle을 채우면 실제 정부 서식처럼 상단에 "문서명 · 부제"
/// 배너가 뜬다(html_files 원본의 .fdh 헤더).
class FormEditBlock extends FlowBlock {
  const FormEditBlock(this.sections, {this.documentTitle, this.formSubtitle});
  final List<FormSection> sections;
  final L10nText? documentTitle;
  final L10nText? formSubtitle;
}

/// 같은 sections를 읽기 전용으로 다시 그린다(검토 단계).
class FormReviewBlock extends FlowBlock {
  const FormReviewBlock(this.sections, {this.documentTitle, this.formSubtitle});
  final List<FormSection> sections;
  final L10nText? documentTitle;
  final L10nText? formSubtitle;
}

/// 한국어 PDF/내 언어 PDF/미리보기 버튼 묶음 — FormEditBlock과 같은 sections를 공유한다.
class PdfActionsBlock extends FlowBlock {
  const PdfActionsBlock(this.sections, {required this.documentTitle});
  final List<FormSection> sections;
  final L10nText documentTitle;
}

/// 임금체불 2단계: 계산기 실행/불러오기 → 결과카드 → AI원인분석 → 대화/진정서 분기.
/// 계산 상태 자체는 화면이 소유한 로컬 상태다(FlowDefinition엔 없음).
class WageCalcBlock extends FlowBlock {
  const WageCalcBlock();
}

/// "사업주와 대화" 메시지 템플릿 팝업(번역 토글 + 복사).
class MessageTemplateBlock extends FlowBlock {
  const MessageTemplateBlock({
    required this.buttonLabel,
    required this.template,
  });
  final L10nText buttonLabel;
  final L10nText template;
}

/// 산재 2단계: 사고/질병 토글 + 근거조항 카드 + "병원에 위임"(트래커로 점프)/"직접 신청" 분기.
class LegalCitationCard {
  const LegalCitationCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.body,
  });
  final String icon;
  final L10nText title;
  final L10nText subtitle;
  final L10nText body;
}

class InjuryGuideBlock extends FlowBlock {
  const InjuryGuideBlock({
    required this.accidentCards,
    required this.illnessCards,
    required this.delegateJumpToStep,
  });
  final List<LegalCitationCard> accidentCards;
  final List<LegalCitationCard> illnessCards;
  final int delegateJumpToStep;
}

enum FlowAccent { amber, teal }

class FlowDefinition {
  const FlowDefinition({
    required this.accent,
    required this.steps,
    required this.track,
  });
  final FlowAccent accent;
  final List<FlowStep> steps;
  final List<TrackStage> track;
}
