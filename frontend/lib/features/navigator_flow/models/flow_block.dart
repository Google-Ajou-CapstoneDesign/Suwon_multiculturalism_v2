import '../../../core/app_language.dart';

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
  });
  final L10nText title;
  final L10nText lead;
  final List<FlowBlock> blocks;
}

/// 트래커 레일의 노드 하나 + 탭했을 때 뜨는 팝업(pop) 3블록.
class TrackStage {
  const TrackStage({
    required this.label,
    required this.whatHappens,
    required this.documentsNeeded,
    required this.watchOutFor,
  });

  final L10nText label;
  final L10nText whatHappens;
  final L10nText documentsNeeded;
  final L10nText watchOutFor;
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
