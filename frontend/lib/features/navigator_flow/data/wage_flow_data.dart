import '../models/flow_block.dart';

/// 임금체불 진정 내비게이터 — 6단계 + 접수 이후 8단계 트래커.
/// 프론트엔드_구상_확장.html의 FLOWS.wage(한국어)를 그대로 옮겼다.
const wageFlowDefinition = FlowDefinition(
  accent: FlowAccent.amber,
  steps: [
    FlowStep(
      title: '어떤 문제인가요?',
      lead: '정해진 선택지로 먼저 나눕니다. AI가 법적으로 판단하지 않기 위한 절차입니다.',
      blocks: [
        OptionsBlock([
          FlowOption(emoji: '💰', title: '단순 임금체불', subtitle: '월급이나 일당이 며칠 밀렸어요'),
          FlowOption(emoji: '⚠️', title: '부당 삭감·수당 미지급·복합', subtitle: '금액이 깎였거나 여러 문제가 겹쳐 있어요'),
        ]),
      ],
    ),
    FlowStep(
      title: '먼저 사장님과 이야기해보세요',
      lead: '단순 체불은 신고 전에 직접 대화하면 가장 빨리 해결되는 경우가 많습니다.',
      blocks: [
        NoticeBlock(
          tone: NoticeTone.amber,
          title: '돈을 받기 전에는 서명하지 마세요',
          body: '합의서나 진정 취하서에 먼저 서명하면 이후 처벌을 요구할 수 없게 됩니다(반의사불벌).',
        ),
        OptionsBlock([
          FlowOption(emoji: '💬', title: '사장님께 보낼 내역서 만들기', subtitle: '근무기록장 데이터로 문자·카카오톡 템플릿을 자동으로 만듭니다'),
          FlowOption(emoji: '➡️', title: '그래도 진정서 작성 계속하기', subtitle: '바로 다음 단계로 넘어갑니다'),
        ]),
      ],
    ),
    FlowStep(
      title: '무슨 일이 있었는지 적어주세요',
      lead: '여기 적은 내용은 고치지 않고 그대로 서류에 들어갑니다.',
      blocks: [
        ChecklistBlock([
          '근로계약서를 썼다',
          '급여가 들어오는 통장 내역이 있다',
          '근무기록장에 출퇴근을 적어뒀다',
          '카카오톡·문자·녹음이 남아 있다',
        ]),
        RawTextBlock('예: 7월 급여일이 지났는데 아직 못 받았습니다. 사장님은 거래처에서 돈이 안 들어와서 다음 달에 준다고 했습니다.'),
      ],
    ),
    FlowStep(
      title: '진정서에 이렇게 들어갑니다',
      lead: '자동으로 채우는 칸과 비워두는 칸이 나뉩니다. 색으로 구분해서 보여드립니다.',
      blocks: [
        FillCardBlock([
          FlowFillRow(label: '진정인', value: '응우옌 반 남 (E-9)', tag: FillTag.auto),
          FlowFillRow(label: '피진정인', value: '○○산업 대표 김○○', tag: FillTag.auto),
          FlowFillRow(label: '근무기간', value: '2025.04.01 ~ 2026.07.31', tag: FillTag.auto),
          FlowFillRow(label: '체불임금 총액', value: '직접 입력해주세요', tag: FillTag.blank),
          FlowFillRow(label: '청구 취지 및 이유', value: '앞 단계에서 적은 내용 그대로', tag: FillTag.raw),
          FlowFillRow(label: '위반 법조항', value: '근로감독관이 판단합니다', tag: FillTag.blank),
        ]),
        NoticeBlock(
          tone: NoticeTone.blue,
          title: '금액은 왜 비어 있나요?',
          body: '체불 확정 금액은 근로감독관 조사에서 산정됩니다. 앱이 미리 정해두면 다툼의 대상이 되기 때문에, '
              '임금계산기 결과를 보고 본인이 직접 적도록 했습니다.',
        ),
      ],
    ),
    FlowStep(
      title: '직접 제출하셔야 합니다',
      lead: '두 가지 방법 중에 고르세요.',
      blocks: [
        NoticeBlock(
          tone: NoticeTone.amber,
          title: 'Local Bridge는 서류를 대신 내지 않습니다',
          body: '공인노무사법 제2조에 따라 서류 제출은 근로자 본인이 직접 진행해야 합니다.',
        ),
        OptionsBlock([
          FlowOption(emoji: '💻', title: '노동포털 온라인 접수', subtitle: '집에서 접수하는 방법을 화면 그대로 안내합니다'),
          FlowOption(emoji: '🏛️', title: '관할 노동청 방문·팩스', subtitle: '등록된 근무지 주소로 관할 관서를 찾아드립니다'),
        ]),
      ],
    ),
    FlowStep(
      title: '여기서부터는 기다리는 시간입니다',
      lead: '접수 이후 8단계를 여기서 계속 확인할 수 있습니다. 각 단계를 누르면 자세한 안내가 열립니다.',
      blocks: [TrackerBlock(now: 3)],
    ),
  ],
  track: [
    TrackStage(
      label: '체불액 정리',
      whatHappens: '근무기록·통장·계약서를 대조해 미지급 금액과 증거를 모으는 단계',
      documentsNeeded: '근로계약서, 급여 통장 거래내역서, 급여명세서, 출퇴근 기록',
      watchOutFor: '임금채권 소멸시효는 3년입니다. 체불이 생기면 바로 증거를 모으세요.',
    ),
    TrackStage(
      label: '사장님과 대화',
      whatHappens: '노동청에 알리기 전 체불 내역을 전달해 원만한 해결을 시도하는 단계',
      documentsNeeded: '대화 요청문 템플릿, 미지급 급여 산출 내역서',
      watchOutFor: '돈을 실제로 받기 전에는 합의서·취하서에 서명하지 마세요.',
    ),
    TrackStage(
      label: '진정 접수',
      whatHappens: '관할 지방고용노동청에 체불 사실을 알리고 해결을 공식 요청하는 단계',
      documentsNeeded: '임금체불 진정서, 신분증(외국인등록증)',
      watchOutFor: '진정은 처벌보다 지급 지도가 목적입니다. 체류자격과 무관하게 접수할 수 있습니다.',
    ),
    TrackStage(
      label: '출석 조사',
      whatHappens: '담당 근로감독관의 호출에 따라 출석해 조사를 받는 단계',
      documentsNeeded: '신분증, 제출 증거자료 원본, 출석 통지서',
      watchOutFor: '사업주와 함께 있는 것이 불편하면 분리 조사를 요구할 수 있고, 통역원 동석도 미리 신청할 수 있습니다.',
    ),
    TrackStage(
      label: '체불확인서',
      whatHappens: '체불 사실이 확정된 뒤 공식 확인서를 발급받는 단계',
      documentsNeeded: '체불임금등·사업주확인서 발급 신청서',
      watchOutFor: '이 확인서가 있어야 다음 단계인 대지급금이나 민사로 넘어갈 수 있습니다.',
    ),
    TrackStage(
      label: '대지급금 청구',
      whatHappens: '사업주가 지급하지 못할 때 국가가 먼저 지급하는 제도',
      documentsNeeded: '체불확인서 원본, 지급청구서, 본인 명의 통장 사본',
      watchOutFor: '법원 판결 없이 노동청 확인서만으로 받을 수 있습니다.',
    ),
    TrackStage(
      label: '민사·지급명령',
      whatHappens: '체불액이 대지급금 한도를 넘을 때 집행권원을 확보하는 단계',
      documentsNeeded: '체불확인서, 민사소장 또는 지급명령 신청서',
      watchOutFor: '대한법률구조공단에서 무료로 도와줍니다. 소득 요건을 먼저 확인하세요.',
    ),
    TrackStage(
      label: '집행·이직',
      whatHappens: '사업주 재산에 대한 집행과, 체불로 인한 사업장 변경 처리 단계',
      documentsNeeded: '확정 판결문·지급명령 결정문, 사업장 변경 신청서',
      watchOutFor: '체불이 증명되면 사업장 변경 횟수에서 차감되지 않습니다.',
    ),
  ],
);
