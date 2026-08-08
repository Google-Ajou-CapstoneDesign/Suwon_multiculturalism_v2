import '../models/flow_block.dart';

/// 산재처리 신청 내비게이터 — 6단계 + 접수 이후 6단계 트래커.
/// 프론트엔드_구상_확장.html의 FLOWS.injury(한국어)를 그대로 옮겼다.
const injuryFlowDefinition = FlowDefinition(
  accent: FlowAccent.teal,
  steps: [
    FlowStep(
      title: '어떻게 다치셨나요?',
      lead: '사고인지 질병인지에 따라 필요한 증거가 달라집니다.',
      blocks: [
        OptionsBlock([
          FlowOption(emoji: '💥', title: '사고성 재해', subtitle: '넘어짐·베임·끼임·추락·찔림'),
          FlowOption(emoji: '🦠', title: '질병성 재해', subtitle: '근골격계 질환·화학물질 장기 노출·직업성 질병'),
        ]),
      ],
    ),
    FlowStep(
      title: '가장 먼저 할 일',
      lead: '노무사 검수를 마친 안내입니다.',
      blocks: [
        NoticeBlock(
          tone: NoticeTone.teal,
          title: '초진소견서를 꼭 받으세요',
          body: "병원 원무과에 '일하다 다쳤다'고 분명히 말해야 산재 치료로 기록됩니다. 업무와의 연관성을 증명하는 것이 핵심입니다.",
        ),
        NoticeBlock(
          tone: NoticeTone.amber,
          title: '공상처리 제안을 조심하세요',
          body: '현금으로 합의하자는 제안에 응하면 나중에 후유증이 생겨도 치료비를 받을 수 없습니다.',
        ),
      ],
    ),
    FlowStep(
      title: '사고 상황을 적어주세요',
      lead: '여기 적은 내용은 고치지 않고 그대로 서류에 들어갑니다.',
      blocks: [
        ChecklistBlock([
          '초진소견서 또는 진단서가 있다',
          '사고 현장 사진을 찍어뒀다',
          '목격자가 있다',
          '근무기록장에 그날 기록이 있다',
        ]),
        RawTextBlock('예: 8월 4일 오후 3시경 3번 라인에서 부품을 옮기다가 지게차에 발등을 찍혔습니다. 옆에 있던 동료 ○○가 봤습니다.'),
      ],
    ),
    FlowStep(
      title: '요양급여신청서에 이렇게 들어갑니다',
      lead: '의학적 판단은 앱이 하지 않습니다.',
      blocks: [
        FillCardBlock([
          FlowFillRow(label: '신청인', value: '응우옌 반 남 (E-9)', tag: FillTag.auto),
          FlowFillRow(label: '사업장 정보', value: '○○산업 · 경기 수원시', tag: FillTag.auto),
          FlowFillRow(label: '재해 일시·장소', value: '2026.08.04 15:00 · 3번 라인', tag: FillTag.auto),
          FlowFillRow(label: '재해 발생 경위', value: '앞 단계에서 적은 내용 그대로', tag: FillTag.raw),
          FlowFillRow(label: '의학적 소견', value: '의사가 작성합니다', tag: FillTag.blank),
          FlowFillRow(label: '재해조사 소견', value: '공단 조사관이 작성합니다', tag: FillTag.blank),
        ]),
        NoticeBlock(
          tone: NoticeTone.blue,
          title: '승인 여부는 앱이 정하지 않습니다',
          body: '제출된 소견서와 근로복지공단 심사를 통해 최종 승인 여부가 결정됩니다.',
        ),
      ],
    ),
    FlowStep(
      title: '제출 방법을 고르세요',
      lead: '병원에 맡기는 방법이 가장 편합니다.',
      blocks: [
        OptionsBlock([
          FlowOption(emoji: '🏥', title: '산재지정병원에 위임 (권장)', subtitle: '병원이 서류를 대신 접수해줍니다'),
          FlowOption(emoji: '🏛️', title: '근로복지공단에 직접 제출', subtitle: '가까운 지사를 찾아드립니다'),
        ]),
        NoticeBlock(
          tone: NoticeTone.amber,
          title: '사업주 도장은 필요 없습니다',
          body: '사업주가 날인을 거부해도 근로자 혼자 신청할 수 있습니다. Local Bridge는 신청을 대행하지 않습니다.',
        ),
      ],
    ),
    FlowStep(
      title: '여기서부터는 심사 기간입니다',
      lead: '신청 이후 6단계를 여기서 확인할 수 있습니다. 각 단계를 누르면 자세한 안내가 열립니다.',
      blocks: [TrackerBlock(now: 2)],
    ),
  ],
  track: [
    TrackStage(
      label: '초진소견서',
      whatHappens: '다친 즉시 치료를 받고 초진소견서를 발급받는 단계',
      documentsNeeded: '병원 의무기록지, 초진소견서(진단서)',
      watchOutFor: '신청 기한은 3년입니다(장해·사망은 5년).',
    ),
    TrackStage(
      label: '증거 수집',
      whatHappens: '업무 중 발생했음을 증명할 자료와 목격자를 확보하는 단계',
      documentsNeeded: '현장 사진, CCTV, 목격자 진술서, 근무기록장 GPS 기록',
      watchOutFor: '현금 합의 제안에 응하지 말고 정식으로 신청하세요.',
    ),
    TrackStage(
      label: '요양급여 신청',
      whatHappens: '근로복지공단에 치료비와 휴업수당 지급을 요청하는 단계',
      documentsNeeded: '요양급여신청서, 초진소견서',
      watchOutFor: '사업주에게 거부권이 없습니다. 근로자 혼자 신청할 수 있습니다.',
    ),
    TrackStage(
      label: '현장 조사',
      whatHappens: '공단과 질병판정위원회가 업무 연관성을 심사하는 과정',
      documentsNeeded: '작업 내용 설명서, 근무 시간표, 작업 환경 사진',
      watchOutFor: '요양 기간과 그 후 30일 동안은 해고할 수 없습니다(근로기준법 제23조②).',
    ),
    TrackStage(
      label: '승인·보상',
      whatHappens: '산재 승인 후 보상금을 수령하는 단계',
      documentsNeeded: '요양비 청구서, 휴업급여 청구서',
      watchOutFor: '휴업급여는 평균임금의 70%입니다. 간병급여·직업재활급여도 확인해보세요.',
    ),
    TrackStage(
      label: '불승인 불복',
      whatHappens: '산재가 불승인되었을 때 이의를 제기하는 단계',
      documentsNeeded: '불승인 결정 통지서, 심사청구서, 보완 전문의 소견서',
      watchOutFor: '심사청구와 재심사청구는 각각 90일 안에 해야 합니다.',
    ),
  ],
);
