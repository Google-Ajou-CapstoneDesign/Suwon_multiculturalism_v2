import '../../../core/app_language.dart';
import '../models/flow_block.dart';
import 'injury_fields.dart';

const _documentTitle = L10nText(
  ko: '산업재해보상보험 요양급여신청서',
  en: 'Industrial Accident Medical Benefit Claim',
  zh: '产业灾害补偿保险疗养给付申请书',
  vi: 'Đơn xin trợ cấp điều trị bảo hiểm tai nạn lao động',
);
// html_files 원본과 동일하게 이 줄은 언어와 무관하게 항상 한국어로 둔다(공식 서식 명칭).
const _documentSubtitle = L10nText(
  ko: '근로복지공단 · 별지 제2호 서식 (처리기간 7일)',
  en: '근로복지공단 · 별지 제2호 서식 (처리기간 7일)',
  zh: '근로복지공단 · 별지 제2호 서식 (처리기간 7일)',
  vi: '근로복지공단 · 별지 제2호 서식 (처리기간 7일)',
);

/// 산재처리 신청 내비게이터 — 6단계 + 접수 이후 6단계 트래커.
/// html_files/산재처리네비게이터.html의 FLOWS.injury(전용 상세본)를 이 앱의 실제
/// 데이터 상황에 맞게 옮겼다(재태깅 원칙은 injury_fields.dart 주석 참고).
const injuryFlowDefinition = FlowDefinition(
  accent: FlowAccent.teal,
  steps: [
    FlowStep(
      title: L10nText(
        ko: '어떤 상황에서 다치시거나 병을 얻으셨나요?',
        en: 'What kind of situation caused your injury or illness?',
        zh: '您是在什么情况下受伤或患病的？',
        vi: 'Bạn bị thương hoặc mắc bệnh trong tình huống nào?',
      ),
      lead: L10nText(
        ko: '사고성 재해와 질병성 재해는 행정 절차가 완전히 다릅니다. 아래에서 상황을 고르면 다음 단계부터 맞춤 안내를 보여드립니다.',
        en: 'The procedure differs completely between an accident and an occupational illness. Choose your situation below and the next steps will be tailored to it.',
        zh: '事故性灾害与疾病性灾害的行政程序完全不同。请在下方选择您的情况，接下来的步骤将据此为您提供定制指引。',
        vi: 'Thủ tục hành chính khác nhau hoàn toàn giữa tai nạn và bệnh nghề nghiệp. Hãy chọn tình huống của bạn bên dưới để các bước tiếp theo được điều chỉnh phù hợp.',
      ),
      help: StepHelp(
        icon: '❓',
        title: L10nText(
          ko: '왜 사고와 질병을 구분하나요?',
          en: 'Why separate accident from illness?',
          zh: '为什么要区分事故和疾病？',
          vi: 'Vì sao phải phân biệt tai nạn và bệnh nghề nghiệp?',
        ),
        body: L10nText(
          ko: '사고성 재해는 다친 현장과 시점이 명확해 산재 지정 병원 원무과에서 요양급여신청을 직접 대행해 주는 경우가 많고, 산업재해보상보험법 시행규칙 제21조에 따라 자문의 소견만으로 비교적 빠르게(통상 2주 안팎) 승인 여부가 정해집니다. 반면 질병성 재해는 통증·직업병이 업무와 인과관계가 있는지를 근로자가 스스로 입증해야 하므로, 산업재해보상보험법 제38조에 따른 업무상질병판정위원회 심의를 거쳐야 하고 최근 12주(3개월) 이상의 근무 기록과 작업 환경 증거를 모아 신청해야 합니다.',
          en: "An accident has a clear time and place, so the designated hospital's front desk often files the medical benefit claim on your behalf, and under Enforcement Rule Article 21 of the Industrial Accident Compensation Insurance Act it is usually decided within about two weeks on an advisory physician's opinion alone. An occupational illness, however, requires the worker to prove the causal link between the condition and the work under Article 38 of the Act — it goes through the Occupational Disease Adjudication Committee, so you must gather at least twelve weeks (three months) of work records and workplace-environment evidence yourself.",
          zh: '事故性灾害的受伤地点和时间明确，工伤指定医院的窗口经常可以代为申请疗养给付，并且根据《产业灾害补偿保险法施行规则》第21条，仅凭顾问医生的意见即可较快（通常约2周）决定是否核准。相反，疾病性灾害需要劳动者自行证明病痛·职业病与工作之间的因果关系，须经《产业灾害补偿保险法》第38条规定的业务上疾病判定委员会审议，因此需要收集最近12周（3个月）以上的工作记录和作业环境证据后再申请。',
          vi: 'Tai nạn lao động có thời điểm và địa điểm rõ ràng nên quầy tiếp tân của bệnh viện chỉ định thường có thể nộp đơn xin trợ cấp điều trị thay bạn, và theo Điều 21 Quy tắc thi hành Luật Bảo hiểm bồi thường tai nạn lao động, việc phê duyệt thường được quyết định khá nhanh (khoảng 2 tuần) chỉ dựa trên ý kiến của bác sĩ tư vấn. Ngược lại, bệnh nghề nghiệp đòi hỏi người lao động phải tự chứng minh mối quan hệ nhân quả giữa bệnh và công việc theo Điều 38 của Luật, phải qua thẩm định của Ủy ban phán định bệnh nghề nghiệp, nên cần thu thập hồ sơ làm việc và bằng chứng môi trường làm việc trong ít nhất 12 tuần (3 tháng) gần nhất trước khi nộp đơn.',
        ),
      ),
      blocks: [
        OptionsBlock([
          FlowOption(
            emoji: '💥',
            title: L10nText(
              ko: '사고성 재해',
              en: 'Accidental injury',
              zh: '事故性灾害',
              vi: 'Tai nạn lao động',
            ),
            subtitle: L10nText(
              ko: '작업 중 사고 · 교통사고 · 넘어짐 · 끼임 — 기계 끼임, 추락, 베임, 찔림, 길 가다 넘어짐, 출퇴근 교통사고 등',
              en: 'Work accident, traffic accident, slip, caught in machinery — entanglement, fall, cut, puncture, slipping, commuting accident, etc.',
              zh: '作业中事故·交通事故·跌倒·夹伤——机械夹伤、坠落、割伤、刺伤、路上跌倒、上下班交通事故等',
              vi: 'Tai nạn khi làm việc, tai nạn giao thông, trượt ngã, kẹt máy — vướng kẹt, rơi từ trên cao, đứt tay, đâm, trượt ngã, tai nạn khi đi làm, v.v.',
            ),
          ),
          FlowOption(
            emoji: '🩺',
            title: L10nText(
              ko: '질병성 재해',
              en: 'Occupational illness',
              zh: '疾病性灾害',
              vi: 'Bệnh nghề nghiệp',
            ),
            subtitle: L10nText(
              ko: '직업병 · 근골격계 통증 · 만성 질환 · 과로 — 허리·관절 통증, 독성물질 중독, 난청, 뇌심혈관계 질환 등',
              en: 'Occupational disease, musculoskeletal pain, chronic illness, overwork — back or joint pain, toxic exposure, hearing loss, cerebro-cardiovascular disease, etc.',
              zh: '职业病·肌肉骨骼疼痛·慢性病·过劳——腰部关节疼痛、中毒、听力受损、脑心血管疾病等',
              vi: 'Bệnh nghề nghiệp, đau cơ xương khớp, bệnh mãn tính, làm việc quá sức — đau lưng/khớp, nhiễm độc, giảm thính lực, bệnh tim mạch não, v.v.',
            ),
          ),
        ]),
      ],
    ),
    FlowStep(
      title: L10nText(
        ko: '상황에 맞는 대응 가이드입니다',
        en: 'Guidance matched to your situation',
        zh: '这是符合您情况的应对指南',
        vi: 'Hướng dẫn phù hợp với tình huống của bạn',
      ),
      lead: L10nText(
        ko: '노무사 검수를 마친 안내입니다. 카드를 눌러 자세히 보고, 아래에서 다음 행동을 골라주세요.',
        en: 'This guidance has been reviewed by a labor attorney. Tap a card to read more, then choose what to do next below.',
        zh: '本指南已经过劳务士审核。点击卡片查看详情，并在下方选择下一步操作。',
        vi: 'Đây là hướng dẫn đã được luật sư lao động thẩm định. Nhấn vào thẻ để xem chi tiết, sau đó chọn hành động tiếp theo bên dưới.',
      ),
      blocks: [
        InjuryGuideBlock(
          delegateJumpToStep: 5,
          accidentCards: [
            LegalCitationCard(
              icon: '🏥',
              title: L10nText(
                ko: '산재 지정 병원 이용 시 (가장 간편한 방법)',
                en: 'Using a designated hospital (the easiest way)',
                zh: '使用工伤指定医院时（最简便的方法）',
                vi: 'Khi dùng bệnh viện chỉ định (cách đơn giản nhất)',
              ),
              subtitle: L10nText(
                ko: '원무과에 위임하면 병원이 공단에 직접 제출합니다',
                en: 'Delegate to the front desk and the hospital files for you',
                zh: '委托窗口后由医院直接向公团提交',
                vi: 'Ủy quyền cho quầy tiếp tân, bệnh viện sẽ nộp thay bạn',
              ),
              body: L10nText(
                ko: '병원 원무과 산재 담당자에게 "일하다 다쳤으니 산재 신청해 주세요"라고 요청하고, 요양급여신청서(별지 제2호 서식) 하단의 \'요양급여신청 등의 대행에 관한 위임장\'에 서명하면 병원이 근로복지공단에 신청서와 초진소견서(별지 제3호 서식)를 직접 제출해 줍니다. 산업재해보상보험법 시행규칙 제21조는 산재보험 의료기관이 근로자를 대행해 요양급여를 신청할 수 있도록 정하고 있습니다.',
                en: 'Ask the hospital front desk\'s workers\'-compensation staff to "file a claim because I was injured while working," and sign the delegation form for filing the medical benefit claim at the bottom of the claim form (Form No.2) — the hospital will then submit the claim form and the initial medical opinion (Form No.3) to COMWEL directly. Enforcement Rule Article 21 of the Industrial Accident Compensation Insurance Act allows a designated medical institution to file the claim on the worker\'s behalf.',
                zh: '请向医院窗口工伤负责人说明"因工作受伤，请办理工伤申请"，并在要养给付申请书（别纸第2号）下方的"要养给付申请等代行委任状"上签字，医院就会直接向劳动福利公团提交申请书和初诊所见书（别纸第3号）。《产业灾害补偿保险法施行规则》第21条规定，工伤保险医疗机构可代劳动者申请疗养给付。',
                vi: 'Hãy yêu cầu nhân viên phụ trách tai nạn lao động tại quầy bệnh viện "xin nộp đơn tai nạn lao động vì tôi bị thương khi làm việc", và ký vào giấy ủy quyền nộp đơn xin trợ cấp điều trị ở cuối đơn (mẫu số 2) — bệnh viện sẽ trực tiếp nộp đơn và giấy chẩn đoán ban đầu (mẫu số 3) cho Cơ quan Phúc lợi Lao động. Điều 21 Quy tắc thi hành Luật Bảo hiểm bồi thường tai nạn lao động cho phép cơ sở y tế chỉ định nộp đơn thay người lao động.',
              ),
            ),
            LegalCitationCard(
              icon: '🚫',
              title: L10nText(
                ko: '사장님이 산재를 거부하거나 도장을 안 찍어 줄 때',
                en: "If your employer refuses or won't stamp the form",
                zh: '老板拒绝工伤或不肯盖章时',
                vi: 'Khi chủ từ chối hoặc không chịu đóng dấu',
              ),
              subtitle: L10nText(
                ko: '사업주 승인이 없어도 근로자 혼자 신청할 수 있습니다',
                en: "You can file alone even without your employer's approval",
                zh: '即使没有业主批准，劳动者也可单独申请',
                vi: 'Vẫn có thể tự nộp đơn dù không có sự đồng ý của chủ',
              ),
              body: L10nText(
                ko: '사업주의 승인(날인)이 없어도 근로자 단독으로 신청할 수 있습니다. 산업재해보상보험법 제41조는 요양급여를 받으려는 사람이 직접 근로복지공단에 신청하도록 정하고 있어 사업주에게 거부권이 없습니다. 접수 후 공단은 사업주에게 \'보험가입자 의견서\'를 보내 의견을 확인할 뿐입니다. 요양으로 휴업한 기간과 그 후 30일 동안은 근로기준법 제23조 제2항에 따라 해고할 수 없고, 산업재해보상보험법 제111조는 산재 신청·요양을 이유로 한 불이익 처우를 금지하며 위반 시 500만원 이하 벌금에 처합니다.',
                en: 'You can file on your own even without the employer\'s approval or seal. Article 41 of the Industrial Accident Compensation Insurance Act requires the person seeking medical benefits to apply directly to COMWEL, so the employer has no right to refuse. After filing, COMWEL merely sends the employer an "insured party opinion form" to check their view. You cannot be dismissed during your medical leave and for 30 days after under Labor Standards Act Article 23(2), and Article 111 of the Act prohibits retaliation for filing or receiving treatment, punishable by a fine of up to 5 million won.',
                zh: '即使没有业主的批准（盖章），劳动者也可以单独申请。《产业灾害补偿保险法》第41条规定，希望获得疗养给付的人应直接向劳动福利公团申请，业主没有拒绝权。受理后，公团只会向业主发送"参保人意见书"以确认意见。根据《劳动基准法》第23条第2款，在疗养休业期间及其后30天内不得解雇；《产业灾害补偿保险法》第111条禁止以申请工伤或疗养为由给予不利待遇，违反者处以500万韩元以下罚款。',
                vi: 'Ngay cả khi không có sự đồng ý (đóng dấu) của chủ sử dụng lao động, người lao động vẫn có thể tự nộp đơn. Điều 41 Luật Bảo hiểm bồi thường tai nạn lao động quy định người muốn nhận trợ cấp điều trị phải trực tiếp nộp đơn cho Cơ quan Phúc lợi Lao động nên chủ không có quyền từ chối. Sau khi nộp, Cơ quan chỉ gửi "ý kiến của người tham gia bảo hiểm" cho chủ để xác nhận ý kiến. Không thể bị sa thải trong thời gian nghỉ điều trị và 30 ngày sau đó theo Điều 23 Khoản 2 Luật Tiêu chuẩn Lao động, và Điều 111 của Luật cấm đối xử bất lợi vì lý do nộp đơn/điều trị tai nạn lao động, vi phạm sẽ bị phạt tiền tới 5 triệu won.',
              ),
            ),
            LegalCitationCard(
              icon: '📄',
              title: L10nText(
                ko: '사고 입증 필수 준비 서류',
                en: 'Documents you need to prove the accident',
                zh: '证明事故所需的必备文件',
                vi: 'Giấy tờ cần thiết để chứng minh tai nạn',
              ),
              subtitle: L10nText(
                ko: '소견서·현장사진·목격자진술·이송기록이 핵심 증거입니다',
                en: 'Medical opinion, scene photos, witness statement, ambulance record are key',
                zh: '医生意见书·现场照片·目击者陈述·转运记录是核心证据',
                vi: 'Giấy chẩn đoán, ảnh hiện trường, lời khai nhân chứng, hồ sơ vận chuyển là bằng chứng cốt lõi',
              ),
              body: L10nText(
                ko: '초진소견서(별지 제3호 서식)/진단서, 사고 현장 사진, 동료 목격자 진술서, 119 구급대 이송 기록, 출퇴근 재해라면 대중교통 이용 내역(교통카드 사용 기록)이 핵심 증거입니다. 산업재해보상보험법 시행규칙 제20조는 요양급여신청서에 재해 경위를 증명할 수 있는 자료를 첨부하도록 정하고 있습니다.',
                en: 'The initial medical opinion (Form No.3) or a diagnosis, photos of the accident scene, a coworker witness statement, the 119 ambulance transport record, and — for a commuting accident — your public-transit usage history (transit card record) are the key evidence. Enforcement Rule Article 20 of the Industrial Accident Compensation Insurance Act requires attaching material proving the circumstances of the accident to the medical benefit claim.',
                zh: '初诊所见书（别纸第3号）/诊断书、事故现场照片、同事目击者陈述书、119救护车转运记录，如果是通勤灾害则公共交通使用记录（交通卡使用记录）是核心证据。《产业灾害补偿保险法施行规则》第20条规定，须在疗养给付申请书中附上能证明灾害经过的资料。',
                vi: 'Giấy chẩn đoán ban đầu (mẫu số 3)/giấy chẩn đoán, ảnh hiện trường tai nạn, lời khai của đồng nghiệp chứng kiến, hồ sơ vận chuyển của xe cấp cứu 119, và nếu là tai nạn khi đi làm thì lịch sử sử dụng phương tiện công cộng (thẻ giao thông) là bằng chứng cốt lõi. Điều 20 Quy tắc thi hành Luật Bảo hiểm bồi thường tai nạn lao động yêu cầu đính kèm tài liệu chứng minh diễn biến tai nạn vào đơn xin trợ cấp điều trị.',
              ),
            ),
          ],
          illnessCards: [
            LegalCitationCard(
              icon: '⏱️',
              title: L10nText(
                ko: '발병 전 12주(3개월) 근무 기록 확보 필수',
                en: 'You must secure 12 weeks of work records before onset',
                zh: '发病前须确保12周（3个月）的工作记录',
                vi: 'Bắt buộc phải có hồ sơ làm việc 12 tuần trước khi phát bệnh',
              ),
              subtitle: L10nText(
                ko: '최근 3개월 근무시간·작업강도 기록이 결정적 증거입니다',
                en: 'Your recent hours and workload are the decisive evidence',
                zh: '最近3个月的工时和作业强度记录是决定性证据',
                vi: 'Hồ sơ giờ làm và cường độ công việc gần đây là bằng chứng quyết định',
              ),
              body: L10nText(
                ko: '업무상질병판정위원회 심의(산업재해보상보험법 제38조)를 위해 최근 3개월간 실제 근무한 시간, 무거운 물건을 들거나 반복한 작업의 빈도·강도 기록이 핵심 증거입니다. 근골격계 질환은 산업재해보상보험법 시행령 별표3의 업무상 질병 인정기준에서 신체 부담업무의 기간·강도를 구체적으로 살피므로, Local Bridge [근무기록장]에 쌓인 일별 근무시간 데이터가 결정적 증거가 됩니다.',
                en: 'For the Occupational Disease Adjudication Committee review (Article 38 of the Act), your actual working hours over the last three months and the frequency/intensity of heavy lifting or repetitive tasks are the key evidence. For musculoskeletal disorders, the recognition criteria in Schedule 3 of the Enforcement Decree examine the duration and intensity of physically demanding work in detail, so the daily work-hour data accumulated in Local Bridge\'s [Work Log] becomes decisive evidence.',
                zh: '为了业务上疾病判定委员会的审议（《产业灾害补偿保险法》第38条），最近3个月的实际工作时间以及搬运重物或重复作业的频率·强度记录是核心证据。肌肉骨骼疾病在《产业灾害补偿保险法施行令》附表3的业务上疾病认定标准中会具体审查身体负担作业的期间·强度，因此Local Bridge【工作记录本】中积累的每日工时数据将成为决定性证据。',
                vi: 'Để phục vụ thẩm định của Ủy ban phán định bệnh nghề nghiệp (Điều 38 của Luật), giờ làm việc thực tế trong 3 tháng gần nhất và tần suất/cường độ của việc bê vác nặng hoặc thao tác lặp lại là bằng chứng cốt lõi. Đối với bệnh cơ xương khớp, tiêu chuẩn công nhận trong Phụ lục 3 Nghị định thi hành xem xét cụ thể thời gian và cường độ công việc gây áp lực cơ thể, vì vậy dữ liệu giờ làm hằng ngày tích lũy trong [Sổ ghi công] của Local Bridge sẽ là bằng chứng quyết định.',
              ),
            ),
            LegalCitationCard(
              icon: '📸',
              title: L10nText(
                ko: '작업 환경 사진 및 과거 치료 내역 준비',
                en: 'Prepare workplace photos and past treatment records',
                zh: '准备作业环境照片及既往治疗记录',
                vi: 'Chuẩn bị ảnh môi trường làm việc và hồ sơ điều trị trước đây',
              ),
              subtitle: L10nText(
                ko: '기왕력 확인과 위험 요소 촬영이 함께 필요합니다',
                en: 'Check prior history and photograph the hazards',
                zh: '需同时确认既往病史并拍摄风险因素',
                vi: 'Cần kiểm tra tiền sử bệnh và chụp ảnh các yếu tố nguy hiểm',
              ),
              body: L10nText(
                ko: '입사 전 동일 부위·동일 질환 치료 이력이 있는지 먼저 확인하세요. 기왕력은 업무관련성 판단에서 함께 고려되는 요소입니다. 현재 근무지의 부적절한 작업 자세, 반복 동작, 소음·분진·화학물질 노출 등 위험 요소를 사진이나 동영상으로 촬영해두면 업무상질병판정위원회 심의 자료로 쓰입니다.',
                en: 'First check whether you were treated for the same body part or the same condition before joining this job — prior history (giwangnyeok) is a factor considered alongside work-relatedness. Photograph or record risk factors at your current workplace — poor posture, repetitive motion, noise, dust, chemical exposure — as this becomes material for the Occupational Disease Adjudication Committee\'s review.',
                zh: '请先确认入职前是否有相同部位·相同疾病的治疗史。既往病史是判断业务关联性时一并考虑的因素。将现工作单位不当的作业姿势、重复动作、噪音·粉尘·化学物质暴露等风险因素拍成照片或视频保存，可作为业务上疾病判定委员会的审议资料。',
                vi: 'Trước hết hãy kiểm tra xem trước khi vào làm bạn có từng điều trị cùng bộ phận/cùng bệnh hay không — tiền sử bệnh là yếu tố được xem xét cùng với mối liên quan đến công việc. Hãy chụp ảnh hoặc quay video các yếu tố nguy hiểm tại nơi làm việc hiện tại — tư thế làm việc không phù hợp, động tác lặp lại, tiếng ồn, bụi, tiếp xúc hóa chất — vì đây sẽ là tài liệu cho việc thẩm định của Ủy ban phán định bệnh nghề nghiệp.',
              ),
            ),
            LegalCitationCard(
              icon: '⚠️',
              title: L10nText(
                ko: "사장님의 '공상 처리(현금 합의)' 제안 주의",
                en: 'Beware an off-the-books cash settlement',
                zh: '警惕老板提出"私了（现金和解）"',
                vi: 'Cẩn thận với đề nghị "xử lý riêng (thỏa thuận tiền mặt)"',
              ),
              subtitle: L10nText(
                ko: '현금 합의는 추후 후유증 보상을 막을 수 있습니다',
                en: 'A cash settlement can block compensation for later complications',
                zh: '现金和解可能妨碍日后后遗症的赔偿',
                vi: 'Thỏa thuận tiền mặt có thể ngăn bồi thường di chứng sau này',
              ),
              body: L10nText(
                ko: '사장님이 "병원비 줄 테니 산재 신청하지 말자"고 제안할 때 현금으로 합의하면, 추후 증상이 재발하거나 후유증(장해)이 생겨도 공단으로부터 치료비·장해급여를 받을 수 없습니다. 산재보험 급여를 받을 권리는 사업주와의 사적 합의로 미리 포기할 수 없다는 것이 확립된 판례이며, 요양 중 및 그 후 30일간 해고도 금지됩니다(근로기준법 제23조 제2항).',
                en: 'If you accept a cash settlement when your employer offers "I\'ll pay the medical bills, let\'s not file for workers\' comp," you will not be able to receive treatment costs or disability benefits from COMWEL later even if symptoms recur or aftereffects develop. Established case law holds that the right to workers\' compensation benefits cannot be waived in advance through a private agreement with the employer, and dismissal is also prohibited during medical care and for 30 days after (Labor Standards Act Article 23(2)).',
                zh: '如果在老板提议"我出医药费，别申请工伤了"时以现金和解，日后即使症状复发或出现后遗症（残疾），也无法从公团获得治疗费·残疾给付。确立的判例认为，工伤保险给付的权利不能通过与业主的私下协议预先放弃，并且在疗养期间及其后30天内也禁止解雇（《劳动基准法》第23条第2款）。',
                vi: 'Nếu đồng ý thỏa thuận tiền mặt khi chủ đề nghị "tôi sẽ trả tiền viện phí, đừng nộp đơn tai nạn lao động", thì sau này dù triệu chứng tái phát hay có di chứng cũng không thể nhận tiền điều trị/trợ cấp thương tật từ Cơ quan. Án lệ đã xác lập rằng quyền nhận trợ cấp bảo hiểm tai nạn lao động không thể bị từ bỏ trước thông qua thỏa thuận riêng với chủ, và việc sa thải cũng bị cấm trong thời gian điều trị và 30 ngày sau đó (Điều 23 Khoản 2 Luật Tiêu chuẩn Lao động).',
              ),
            ),
          ],
        ),
      ],
    ),
    FlowStep(
      title: L10nText(
        ko: '요양급여신청서 항목을 채워주세요',
        en: 'Fill in the medical benefit claim form',
        zh: '请填写疗养给付申请书项目',
        vi: 'Điền các mục trong đơn xin trợ cấp điều trị',
      ),
      lead: L10nText(
        ko: '재해자·사업장·재해 경위 정보를 채워주세요. 재해 발생 경위는 고치지 않고 원문 그대로 서식에 들어갑니다.',
        en: 'Fill in the injured worker, workplace and incident information. How the injury happened goes into the form exactly as you write it.',
        zh: '请填写受灾者·单位·灾害经过信息。灾害发生经过将原封不动地录入表格。',
        vi: 'Hãy điền thông tin người bị nạn, nơi làm việc và diễn biến tai nạn. Diễn biến tai nạn sẽ được đưa vào biểu mẫu nguyên văn như bạn viết.',
      ),
      blocks: [
        LegendBlock(),
        FormEditBlock(
          injuryFields,
          documentTitle: _documentTitle,
          formSubtitle: _documentSubtitle,
        ),
        ChecklistBlock([
          L10nText(
            ko: '초진소견서 또는 진단서가 있다',
            en: 'I have an initial medical opinion or a diagnosis',
            zh: '已取得初诊所见书或诊断书',
            vi: 'Đã có giấy chẩn đoán ban đầu hoặc giấy chẩn đoán',
          ),
          L10nText(
            ko: '사고 현장 사진을 찍어뒀다',
            en: 'I took photos of the accident scene',
            zh: '已拍摄事故现场照片',
            vi: 'Đã chụp ảnh hiện trường tai nạn',
          ),
          L10nText(
            ko: '목격자가 있다',
            en: 'There is a witness',
            zh: '有目击者',
            vi: 'Có người chứng kiến',
          ),
          L10nText(
            ko: '근무기록장에 그날 기록이 있다',
            en: "That day's record is in my work log",
            zh: '工作记录本中有当天的记录',
            vi: 'Sổ ghi công có ghi lại ngày hôm đó',
          ),
          L10nText(
            ko: '동료나 관리자에게 다친 사실을 알렸다',
            en: 'I told a coworker or manager about the injury',
            zh: '已将受伤事实告知同事或管理者',
            vi: 'Đã báo cho đồng nghiệp hoặc quản lý về việc bị thương',
          ),
        ]),
      ],
    ),
    FlowStep(
      title: L10nText(
        ko: '요양급여신청서에 이렇게 들어갑니다',
        en: 'This is how it will appear on the claim form',
        zh: '疗养给付申请书中将这样填写',
        vi: 'Đây là nội dung sẽ được đưa vào đơn xin trợ cấp',
      ),
      lead: L10nText(
        ko: '근로복지공단 별지 제2호 서식에 앞 단계 내용이 1:1로 매핑됩니다. 한국어·모국어 PDF를 각각 받을 수 있습니다.',
        en: 'This is COMWEL Form No.2. What you wrote in the previous step is mapped one-to-one. You can download it as a PDF in Korean and in your own language.',
        zh: '前一步骤的内容将1:1对应填入劳动福利公团别纸第2号表格。您可以分别下载韩语版与您本国语言版的PDF。',
        vi: 'Nội dung ở bước trước sẽ được ánh xạ 1:1 vào mẫu số 2 của Cơ quan Phúc lợi Lao động. Bạn có thể tải PDF bằng tiếng Hàn và ngôn ngữ của mình.',
      ),
      blocks: [
        LegendBlock(),
        FormReviewBlock(
          injuryFields,
          documentTitle: _documentTitle,
          formSubtitle: _documentSubtitle,
        ),
        NoticeBlock(
          tone: NoticeTone.blue,
          title: L10nText(
            ko: '재해 발생 경위는 왜 그대로 나오나요?',
            en: 'Why does the description appear exactly as written?',
            zh: '为什么灾害发生经过原样显示？',
            vi: 'Vì sao diễn biến tai nạn hiển thị nguyên văn?',
          ),
          body: L10nText(
            ko: "업무와 재해 사이의 인과관계 주장이 담긴 '재해 발생 경위'는 이용자가 입력한 원문을 고치지 않고 그대로 서식에 옮깁니다. 시스템이 문장을 새로 만들거나 다듬어 법률적 주장을 자동 생성하면 공인노무사법 제2조, 변호사법 제109조가 금지하는 '무자격자의 서류 대리 작성'에 해당할 위험이 있기 때문입니다. 상병명·소견·재해조사 소견처럼 의학적·법적 판단이 필요한 항목은 공란으로 두고, 담당 의사나 근로복지공단 조사관이 직접 작성하도록 안내합니다.",
            en: "The \"circumstances of the accident\" section carries your claim about the causal link between the injury and your work, so what you entered is transferred to the form exactly as written, without edits. If the system generated or polished new sentences on its own, that would risk being \"drafting legal documents without a license,\" which Article 2 of the Certified Public Labor Attorney Act and Article 109 of the Attorney-at-Law Act prohibit. Items requiring medical or legal judgement — diagnosis, opinion, investigation findings — are left blank for your doctor or the COMWEL investigator to complete.",
            zh: '"灾害发生经过"承载着业务与灾害之间因果关系的主张，因此使用者输入的原文将原封不动地转入表格，不做修改。若系统自行新造或润色语句，则有可能构成《公认劳务士法》第2条、《律师法》第109条所禁止的"无资格者代写文件"。伤病名·所见·灾害调查所见等需要医学·法律判断的项目将保持空白，由主治医生或劳动福利公团调查员直接填写。',
            vi: 'Phần "diễn biến tai nạn" chứa lập luận về mối quan hệ nhân quả giữa công việc và tai nạn, nên nội dung bạn nhập được chuyển vào biểu mẫu nguyên văn, không chỉnh sửa. Nếu hệ thống tự tạo hoặc chỉnh sửa câu văn, điều đó có nguy cơ vi phạm quy định cấm "soạn thảo văn bản pháp lý không có chứng chỉ" theo Điều 2 Luật Luật sư lao động công nhận và Điều 109 Luật Luật sư. Các mục cần phán đoán y tế/pháp lý — tên bệnh, ý kiến, kết quả điều tra tai nạn — được để trống để bác sĩ điều trị hoặc điều tra viên của Cơ quan Phúc lợi Lao động trực tiếp ghi.',
          ),
        ),
        NoticeBlock(
          tone: NoticeTone.teal,
          title: L10nText(
            ko: '출퇴근재해 · 제3자 행위재해라면 서류가 자동으로 더 붙습니다',
            en: 'Commuting or third-party accidents attach extra forms automatically',
            zh: '若为通勤灾害·第3方行为灾害，将自动附加文件',
            vi: 'Tai nạn khi đi làm · tai nạn liên quan bên thứ ba sẽ tự động đính kèm thêm giấy tờ',
          ),
          body: L10nText(
            ko: '4번 항목에서 출퇴근재해라고 답하면 출퇴근재해 발생신고서(시행규칙 별지 제5호 서식)가, 제3자 행위재해라고 답하면 제3자 행위재해신고서(시행규칙 별지 제1호의2 서식)가 함께 연동되어 출력됩니다. 제3자에게 손해배상을 받으면 그만큼 산재보험 급여에서 공제될 수 있습니다(같은 법 제87조 · 구상권).',
            en: 'If you answer "yes" to the commuting-accident question in item 4, the commuting-accident report (Enforcement Rule Form No.5) is printed together; if you answer "yes" to third-party involvement, the third-party accident report (Enforcement Rule Form No.1-2) is printed together. If you receive damages from the third party, that amount may be deducted from your insurance benefit (Article 87, subrogation).',
            zh: '在第4项中若回答为通勤灾害，将一并打印出通勤灾害发生申报书（施行规则别纸第5号）；若回答为第3方行为灾害，将一并打印出第3方行为灾害申报书（施行规则别纸第1号之2）。若从第3方获得损害赔偿，该金额可能会从工伤保险给付中扣除（同法第87条·代位求偿权）。',
            vi: 'Nếu trả lời "có" cho câu hỏi tai nạn khi đi làm ở mục 4, báo cáo tai nạn khi đi làm (mẫu số 5 Quy tắc thi hành) sẽ được in kèm; nếu trả lời "có" cho câu hỏi liên quan bên thứ ba, báo cáo tai nạn bên thứ ba (mẫu số 1-2 Quy tắc thi hành) sẽ được in kèm. Nếu nhận bồi thường từ bên thứ ba, số tiền đó có thể bị trừ vào trợ cấp bảo hiểm (Điều 87, quyền thế quyền).',
          ),
        ),
        PdfActionsBlock(injuryFields, documentTitle: _documentTitle),
        NoticeBlock(
          tone: NoticeTone.amber,
          title: L10nText(
            ko: '팩스 · 방문 제출용 안내',
            en: 'Fax / in-person submission guide',
            zh: '传真·到访提交指南',
            vi: 'Hướng dẫn nộp qua fax / trực tiếp',
          ),
          body: L10nText(
            ko: '팩스로 낼 때는 요양급여신청서 원본과 증빙 사본을 함께 보내고, 근로복지공단 대표번호(1588-0075)로 전화해 정상 수신 여부를 확인하세요. 방문 접수 시에는 신분증(외국인등록증)과 서류 원본을 지참하세요. 관할 지사 주소는 경기도 수원시 영통구 청명남로 14입니다.',
            en: 'If faxing, send the original claim form with copies of your evidence, then call COMWEL\'s main line (1588-0075) to confirm it arrived. For an in-person visit, bring your ID (ARC) and the original documents. The branch address is 14 Cheongmyeongnam-ro, Yeongtong-gu, Suwon.',
            zh: '传真提交时请将疗养给付申请书原件与证据复印件一并发送，并致电劳动福利公团代表号（1588-0075）确认是否正常收到。到访提交时请携带身份证件（外国人登录证）和文件原件。管辖支社地址为京畿道水原市灵通区清明南路14。',
            vi: 'Nếu gửi fax, hãy gửi kèm bản gốc đơn xin trợ cấp điều trị và bản sao chứng cứ, sau đó gọi số đường dây chính của Cơ quan (1588-0075) để xác nhận đã nhận được. Khi nộp trực tiếp, mang theo giấy tờ tùy thân (ARC) và bản gốc hồ sơ. Địa chỉ chi nhánh phụ trách là 14 Cheongmyeongnam-ro, Yeongtong-gu, Suwon.',
          ),
        ),
      ],
    ),
    FlowStep(
      title: L10nText(
        ko: '도와줄 기관과 전문가입니다',
        en: 'Agencies and experts who can help',
        zh: '这是可以帮助您的机构与专家',
        vi: 'Đây là các cơ quan và chuyên gia có thể giúp bạn',
      ),
      lead: L10nText(
        ko: '버튼을 누르면 주소·전화번호와 함께 자세한 안내가 열립니다.',
        en: 'Tap a card to see the address, phone number and detailed guidance.',
        zh: '点击卡片即可查看地址、电话号码及详细说明。',
        vi: 'Nhấn vào thẻ để xem địa chỉ, số điện thoại và hướng dẫn chi tiết.',
      ),
      blocks: [
        AccordionBlock([
          AccordionItemData(
            icon: '🏛️',
            title: L10nText(
              ko: '관할 근로복지공단 지사',
              en: 'Your regional COMWEL branch',
              zh: '管辖劳动福利公团支社',
              vi: 'Chi nhánh Cơ quan Phúc lợi Lao động khu vực',
            ),
            subtitle: L10nText(
              ko: '요양급여신청서 접수 · 문의',
              en: 'File and inquire about the claim',
              zh: '受理·咨询疗养给付申请书',
              vi: 'Nộp và hỏi đáp về đơn xin trợ cấp',
            ),
            body: [
              OrgCardBlock(
                name: L10nText(
                  ko: '근로복지공단 수원지사 · 경기지방고용노동청',
                  en: 'COMWEL Suwon Branch · Gyeonggi Regional Employment and Labor Office',
                  zh: '劳动福利公团水原支社·京畿地方雇佣劳动厅',
                  vi: 'Chi nhánh COMWEL Suwon · Sở Lao động và Việc làm khu vực Gyeonggi',
                ),
                subtitle: L10nText(
                  ko: '요양급여신청서(별지 제2호) 접수, 사업장관리번호 조회, 처리 진행상황 확인을 담당합니다. 산업재해보상보험법 제41조에 따라 신청은 근로복지공단 소속 기관에 합니다.',
                  en: 'Handles filing the claim form (No.2), looking up your workplace management number, and checking processing status. Under Article 41 of the Act, claims are filed with a COMWEL office.',
                  zh: '负责受理疗养给付申请书（别纸第2号）、查询单位管理号、确认处理进度。根据《产业灾害补偿保险法》第41条，申请须向劳动福利公团所属机构提交。',
                  vi: 'Phụ trách nộp đơn (mẫu số 2), tra cứu số quản lý cơ sở, kiểm tra tiến độ xử lý. Theo Điều 41 của Luật, đơn phải nộp cho cơ quan trực thuộc COMWEL.',
                ),
                phone: '1588-0075',
                legalBasis: L10nText(
                  ko: '📍 경기도 수원시 영통구 청명남로 14 · 접수 전 전화로 관할 여부를 한 번 더 확인하는 것이 안전합니다.',
                  en: '📍 14 Cheongmyeongnam-ro, Yeongtong-gu, Suwon, Gyeonggi · Confirm jurisdiction by phone once more before filing, to be safe.',
                  zh: '📍 京畿道水原市灵通区清明南路14 · 提交前建议再次电话确认管辖范围。',
                  vi: '📍 14 Cheongmyeongnam-ro, Yeongtong-gu, Suwon, Gyeonggi · Nên gọi điện xác nhận lại thẩm quyền trước khi nộp.',
                ),
              ),
            ],
          ),
          AccordionItemData(
            icon: '🏥',
            title: L10nText(
              ko: '관내 산재 지정 병원',
              en: 'Designated hospitals nearby',
              zh: '辖区内工伤指定医院',
              vi: 'Bệnh viện chỉ định gần đây',
            ),
            subtitle: L10nText(
              ko: '응급 · 통원 치료, 원무과 대행 제출',
              en: 'Emergency & outpatient care, front-desk filing',
              zh: '急诊·门诊治疗，窗口代为提交',
              vi: 'Cấp cứu & điều trị ngoại trú, nộp thay qua quầy tiếp tân',
            ),
            body: [
              OrgCardBlock(
                name: L10nText(
                  ko: '수원한국병원 · 아주대학교병원 등',
                  en: 'Suwon Korea Hospital, Ajou University Hospital, and others',
                  zh: '水原韩国医院·亚洲大学医院等',
                  vi: 'Bệnh viện Hàn Quốc Suwon, Bệnh viện Đại học Ajou, v.v.',
                ),
                subtitle: L10nText(
                  ko: '근로복지공단이 지정한 산재보험 의료기관에서 치료를 받으면 원무과 산재 담당자를 통해 요양급여신청 대행이 가능합니다(산업재해보상보험법 시행규칙 제21조). 방문 전 원무과에 산재 지정 여부와 담당 직통번호를 전화로 확인하세요.',
                  en: 'Getting treatment at a hospital designated by COMWEL lets the front-desk workers\' compensation staff file the claim on your behalf (Enforcement Rule Art.21). Call the front desk before visiting to confirm designation status and a direct line.',
                  zh: '在劳动福利公团指定的工伤保险医疗机构接受治疗，可通过窗口工伤负责人代为申请疗养给付（施行规则第21条）。就诊前请致电窗口确认是否为工伤指定医院及负责人直线电话。',
                  vi: 'Điều trị tại cơ sở y tế do COMWEL chỉ định giúp nhân viên phụ trách tại quầy tiếp tân nộp đơn thay bạn (Điều 21 Quy tắc thi hành). Hãy gọi điện xác nhận trước khi đến.',
                ),
                legalBasis: L10nText(
                  ko: '근로복지공단 홈페이지(comwel.or.kr) \'산재보험 의료기관 찾기\'에서 가까운 지정병원을 검색할 수 있습니다.',
                  en: "Search for the nearest designated hospital at COMWEL's website (comwel.or.kr), under 'Find a workers' compensation medical institution.'",
                  zh: '可在劳动福利公团网站（comwel.or.kr）"查找工伤保险医疗机构"中搜索附近的指定医院。',
                  vi: 'Có thể tìm bệnh viện chỉ định gần nhất tại trang web COMWEL (comwel.or.kr), mục "Tìm cơ sở y tế bảo hiểm tai nạn lao động".',
                ),
              ),
            ],
          ),
          AccordionItemData(
            icon: '👨‍⚖️',
            title: L10nText(
              ko: '산재 전문 노무사 · 변호사',
              en: 'Labor attorneys and lawyers for injury claims',
              zh: '工伤专业劳务士·律师',
              vi: 'Luật sư lao động và luật sư chuyên về tai nạn lao động',
            ),
            subtitle: L10nText(
              ko: '승인율 상담, 불승인 시 이의신청 대리',
              en: 'Consult on approval odds, represent you on appeal',
              zh: '核准率咨询，未核准时代理异议申请',
              vi: 'Tư vấn khả năng được duyệt, đại diện khiếu nại khi bị từ chối',
            ),
            body: [
              OrgCardBlock(
                name: L10nText(
                  ko: '경기도 마을노무사',
                  en: "Gyeonggi 'Village Labor Attorney' scheme",
                  zh: '京畿道村庄劳务士',
                  vi: 'Chương trình "Luật sư lao động cộng đồng" Gyeonggi',
                ),
                subtitle: L10nText(
                  ko: '관할 고용센터·지자체를 통해 무료로 서류 검토와 초기 상담을 받을 수 있습니다.',
                  en: 'Get free document review and initial consultation through your local employment center or municipality.',
                  zh: '可通过管辖就业中心·地方政府获得免费的材料审阅和初步咨询。',
                  vi: 'Nhận đánh giá hồ sơ và tư vấn ban đầu miễn phí qua trung tâm việc làm hoặc chính quyền địa phương.',
                ),
              ),
              OrgCardBlock(
                name: L10nText(
                  ko: '대한법률구조공단 수원지부',
                  en: 'Korea Legal Aid Corporation, Suwon',
                  zh: '大韩法律救助公团水原支部',
                  vi: 'Trung tâm Trợ giúp pháp lý Hàn Quốc, Suwon',
                ),
                subtitle: L10nText(
                  ko: '소득 요건을 충족하면 심사청구·재심사청구·행정소송까지 무료로 대리해 줍니다.',
                  en: 'If you meet the income requirement, they represent you free of charge through review requests, re-review requests, and administrative litigation.',
                  zh: '若符合收入条件，可免费代理审查请求·再审查请求乃至行政诉讼。',
                  vi: 'Nếu đủ điều kiện thu nhập, sẽ đại diện miễn phí qua đơn thẩm định, tái thẩm định và kiện hành chính.',
                ),
                phone: '132',
                legalBasis: L10nText(
                  ko: '공인노무사법 제2조는 요양급여신청서 등 산재 서류의 작성·제출 대행을 공인노무사의 직무로 정합니다. 불승인에 대한 이의신청(심사청구·재심사청구, 산업재해보상보험법 제103조·제106조)은 특히 전문가 상담을 권장합니다.',
                  en: 'Article 2 of the Certified Public Labor Attorney Act defines drafting and filing workers\'-compensation documents as the duty of a certified labor attorney. Expert consultation is especially recommended for appealing a denial (review/re-review request, Articles 103 and 106 of the Act).',
                  zh: '《公认劳务士法》第2条规定代写及提交工伤文件为公认劳务士的职责。对于不核准的异议申请（审查请求·再审查请求，《产业灾害补偿保险法》第103条·第106条），尤其建议咨询专家。',
                  vi: 'Điều 2 Luật Luật sư lao động công nhận quy định việc soạn thảo và nộp hồ sơ tai nạn lao động là nhiệm vụ của luật sư lao động công nhận. Đặc biệt nên tư vấn chuyên gia khi khiếu nại quyết định từ chối (đơn thẩm định/tái thẩm định, Điều 103, 106 của Luật).',
                ),
              ),
            ],
          ),
          AccordionItemData(
            icon: '🤝',
            title: L10nText(
              ko: '외국인주민센터 · 통역 지원',
              en: 'Migrant support center & interpreting',
              zh: '外国人居民中心·翻译支援',
              vi: 'Trung tâm hỗ trợ cư dân nước ngoài · phiên dịch',
            ),
            subtitle: L10nText(
              ko: '모국어 상담, 서류 통역',
              en: 'Counselling and interpreting in your language',
              zh: '母语咨询，文件翻译',
              vi: 'Tư vấn và phiên dịch bằng tiếng mẹ đẻ',
            ),
            body: [
              OrgCardBlock(
                name: L10nText(
                  ko: '수원시외국인복지센터',
                  en: 'Suwon Migrant Welfare Center',
                  zh: '水原市外国人福利中心',
                  vi: 'Trung tâm phúc lợi người nước ngoài Suwon',
                ),
                subtitle: L10nText(
                  ko: '베트남어·중국어·몽골어·캄보디아어 등 담당 상담사가 배치되어 산재 절차를 모국어로 설명받을 수 있습니다.',
                  en: 'Counsellors for Vietnamese, Chinese, Mongolian, Cambodian and more explain the workers\'-compensation process in your language.',
                  zh: '设有越南语·中文·蒙古语·柬埔寨语等负责咨询师，可用母语了解工伤程序。',
                  vi: 'Có tư vấn viên tiếng Việt, Trung, Mông Cổ, Campuchia, v.v. giải thích quy trình tai nạn lao động bằng tiếng mẹ đẻ.',
                ),
              ),
              OrgCardBlock(
                name: L10nText(
                  ko: 'HRD Korea 외국인근로자 상담센터',
                  en: 'HRD Korea Migrant Worker Counselling Center',
                  zh: 'HRD Korea外国人劳动者咨询中心',
                  vi: 'Trung tâm tư vấn lao động nước ngoài HRD Korea',
                ),
                subtitle: L10nText(
                  ko: '17개 언어로 통역을 지원하며, 근로복지공단 방문·전화 상담 시 통역을 사전에 신청할 수 있습니다.',
                  en: 'Interpreting is available in 17 languages, and you can request an interpreter in advance for a COMWEL visit or phone consultation.',
                  zh: '支持17种语言口译，在到访或电话咨询劳动福利公团前可提前申请翻译。',
                  vi: 'Hỗ trợ phiên dịch 17 ngôn ngữ, có thể đăng ký phiên dịch trước khi đến hoặc gọi điện tư vấn với COMWEL.',
                ),
                phone: '1577-0071',
                legalBasis: L10nText(
                  ko: '외국인근로자의 고용 등에 관한 법률 제24조는 외국인근로자를 위한 상담 지원 사업의 근거를 두고 있습니다.',
                  en: 'Article 24 of the Act on Employment of Foreign Workers, etc. provides the legal basis for counselling support services for migrant workers.',
                  zh: '《外国人劳动者雇佣等相关法律》第24条为外国劳动者咨询支援事业提供依据。',
                  vi: 'Điều 24 Luật về việc làm của lao động nước ngoài, v.v. là cơ sở pháp lý cho dịch vụ hỗ trợ tư vấn lao động nước ngoài.',
                ),
              ),
            ],
          ),
        ]),
      ],
    ),
    FlowStep(
      title: L10nText(
        ko: '여기서부터는 기다리는 시간입니다',
        en: "From here, it's a waiting game",
        zh: '从这里开始就是等待期',
        vi: 'Từ đây trở đi là thời gian chờ',
      ),
      lead: L10nText(
        ko: '접수 이후 6단계를 여기서 계속 확인할 수 있습니다. 단계를 누르면 안내가 열리고, 안내 안에서 완료로 표시할 수 있습니다.',
        en: 'Track all six stages here after filing. Tap a stage to open the guide, and mark it complete from inside the guide.',
        zh: '提交后可在此持续查看全部6个阶段。点击某阶段即可打开说明，并可在说明内标记为完成。',
        vi: 'Bạn có thể theo dõi cả 6 giai đoạn tại đây sau khi nộp đơn. Nhấn vào giai đoạn để mở hướng dẫn, và đánh dấu hoàn thành trong đó.',
      ),
      blocks: [
        TrackerBlock(now: 2),
        EncyclopediaLinkBlock(
          categoryId: 11,
          label: L10nText(
            ko: '백과사전에서 더 자세히 보기',
            en: 'See more in the encyclopedia',
            zh: '在百科全书中查看更多',
            vi: 'Xem thêm trong cẩm nang',
          ),
        ),
      ],
    ),
  ],
  track: [
    TrackStage(
      label: L10nText(
        ko: '병원 치료 · 초진소견서',
        en: 'Hospital care · initial opinion',
        zh: '医院治疗·初诊所见书',
        vi: 'Điều trị bệnh viện · giấy chẩn đoán ban đầu',
      ),
      whatHappens: L10nText(
        ko: '다친 즉시 병원 응급 치료를 받고 초진소견서(별지 제3호 서식) 또는 진단서를 발급받는 단계입니다. 의사 소견서에 \'업무상 재해 가능성\'과 \'치료 예정 기간\'이 함께 적혀 있는지 확인하세요. 4일 이상 치료가 필요한 경우에 산재로 신청할 수 있습니다(산업재해보상보험법 시행령 제40조).',
        en: 'Get emergency treatment right away and obtain the initial medical opinion (Form No.3) or a diagnosis. Check that the opinion states both the possibility of a work-related injury and the expected treatment period. A claim is possible when treatment of four days or more is required (Enforcement Decree Art.40).',
        zh: '受伤后立即接受医院急诊治疗，并取得初诊所见书（别纸第3号）或诊断书的阶段。请确认医生意见书中是否同时写明"业务上灾害可能性"和"预计治疗期间"。需要治疗4日以上时方可申请工伤（《产业灾害补偿保险法施行令》第40条）。',
        vi: 'Giai đoạn được điều trị cấp cứu ngay sau khi bị thương và nhận giấy chẩn đoán ban đầu (mẫu số 3) hoặc giấy chẩn đoán. Hãy kiểm tra ý kiến bác sĩ có ghi cả "khả năng tai nạn lao động" và "thời gian điều trị dự kiến" hay không. Có thể nộp đơn tai nạn lao động khi cần điều trị từ 4 ngày trở lên (Điều 40 Nghị định thi hành).',
      ),
      documentsNeeded: L10nText(
        ko: '초진소견서(별지 제3호) / 진단서 / 의무기록지 / 영상 판독지 / 응급기록지',
        en: 'Initial opinion (Form No.3) / diagnosis / medical records / imaging report / ER record',
        zh: '初诊所见书（别纸第3号）／诊断书／病历／影像判读书／急诊记录',
        vi: 'Giấy chẩn đoán ban đầu (mẫu 3) / giấy chẩn đoán / hồ sơ bệnh án / kết quả chẩn đoán hình ảnh / hồ sơ cấp cứu',
      ),
      watchOutFor: L10nText(
        ko: '신청 기한은 재해일로부터 3년, 장해·사망은 5년입니다(산업재해보상보험법 제112조). 퇴사했더라도 재해 당시 산재보험이 적용되는 사업장의 근로자였다면 3년 안에 신청할 수 있습니다. 주치의가 소견서 작성을 거부해도 상병명과 치료기간이 적힌 진단서로 대체 제출할 수 있습니다.',
        en: 'The deadline is three years from the injury, five for disability or death (Art.112). Even if you have left the job, you can file within three years if you were covered at the time. If your doctor refuses the opinion form, a diagnosis stating the condition and treatment period can be substituted.',
        zh: '申请期限为自灾害发生之日起3年，残疾·死亡为5年（《产业灾害补偿保险法》第112条）。即使已离职，只要事发时属于适用工伤保险单位的劳动者，3年内仍可申请。主治医生拒绝出具意见书时，可用写明伤病名和治疗期间的诊断书代替提交。',
        vi: 'Thời hạn nộp đơn là 3 năm kể từ ngày tai nạn, 5 năm đối với thương tật/tử vong (Điều 112). Dù đã nghỉ việc, vẫn có thể nộp trong 3 năm nếu khi đó là người lao động thuộc cơ sở áp dụng bảo hiểm tai nạn lao động. Nếu bác sĩ điều trị từ chối viết giấy ý kiến, có thể nộp thay bằng giấy chẩn đoán ghi tên bệnh và thời gian điều trị.',
      ),
    ),
    TrackStage(
      label: L10nText(
        ko: '요양급여신청서 작성 완료',
        en: 'Claim form completed',
        zh: '疗养给付申请书填写完成',
        vi: 'Hoàn tất điền đơn xin trợ cấp',
      ),
      whatHappens: L10nText(
        ko: 'Step 3~4에서 재해자·사업장·재해 경위 정보를 채우고, Local Bridge에서 한국어 제출용 PDF 서식을 준비하는 단계입니다. 재해 발생 경위는 입력한 원문 그대로 서식에 반영되며, 상병명·소견처럼 의학적 판단이 필요한 항목은 공란으로 남겨 담당 의사가 작성하도록 안내합니다.',
        en: 'Fill in the injured worker, workplace and incident information in Steps 3–4, and prepare the Korean submission PDF with Local Bridge. What you write is copied into the form verbatim, and fields needing medical judgement — diagnosis, opinion — are left blank for your doctor.',
        zh: '在第3~4步中填写受灾者·单位·灾害经过信息，并在Local Bridge准备韩语提交用PDF表格的阶段。灾害发生经过按输入原文原样反映到表格中，伤病名·所见等需要医学判断的项目留空，由主治医生填写。',
        vi: 'Giai đoạn điền thông tin người bị nạn, nơi làm việc, diễn biến tai nạn ở Bước 3-4, và chuẩn bị PDF nộp bằng tiếng Hàn với Local Bridge. Nội dung bạn viết được sao chép nguyên văn vào biểu mẫu, các mục cần phán đoán y tế — tên bệnh, ý kiến — được để trống cho bác sĩ điền.',
      ),
      documentsNeeded: L10nText(
        ko: '요양급여신청서(별지 제2호) 한국어 PDF / 목격자 인적사항 / (해당 시) 출퇴근재해 발생신고서·제3자 행위재해신고서',
        en: 'Claim form (No.2) Korean PDF / witness details / (if applicable) commuting-accident report, third-party report',
        zh: '疗养给付申请书（别纸第2号）韩语PDF／目击者信息／（如适用）通勤灾害发生申报书·第3方行为灾害申报书',
        vi: 'PDF tiếng Hàn đơn (mẫu số 2) / thông tin nhân chứng / (nếu có) báo cáo tai nạn khi đi làm, báo cáo tai nạn bên thứ ba',
      ),
      watchOutFor: L10nText(
        ko: '사업주 날인은 필요하지 않습니다(산업재해보상보험법 제41조). 서류를 완성한 뒤에도 접수 전 인적사항과 사업장 정보를 다시 한 번 확인하세요.',
        en: "No employer seal is required (Art.41). Even after completing the form, check the personal and workplace details once more before filing.",
        zh: '不需要业主盖章（《产业灾害补偿保险法》第41条）。文件完成后，提交前也请再次确认个人信息和单位信息。',
        vi: 'Không cần con dấu của chủ sử dụng lao động (Điều 41). Sau khi hoàn thành hồ sơ, hãy kiểm tra lại thông tin cá nhân và nơi làm việc trước khi nộp.',
      ),
    ),
    TrackStage(
      label: L10nText(
        ko: '근로복지공단 지사 제출',
        en: 'File with your COMWEL branch',
        zh: '向劳动福利公团支社提交',
        vi: 'Nộp cho chi nhánh COMWEL',
      ),
      whatHappens: L10nText(
        ko: '완성한 요양급여신청서를 관할 근로복지공단 지사에 방문·팩스·우편으로 제출하거나, 산재지정병원 원무과에 대행 위임장을 제출하는 단계입니다.',
        en: 'Submit the completed claim form to your COMWEL branch in person, by fax or by post, or hand the delegation form to a designated hospital\'s front desk.',
        zh: '将完成的疗养给付申请书通过到访·传真·邮寄提交至管辖劳动福利公团支社，或向工伤指定医院窗口提交代行委任状的阶段。',
        vi: 'Giai đoạn nộp đơn đã hoàn thành cho chi nhánh COMWEL bằng cách đến trực tiếp, fax hoặc bưu điện, hoặc nộp giấy ủy quyền cho quầy tiếp tân bệnh viện chỉ định.',
      ),
      documentsNeeded: L10nText(
        ko: '요양급여신청서(별지 제2호) / 요양급여신청 소견서(별지 제3호) / 신분증(외국인등록증) 사본',
        en: 'Claim form (No.2) / medical opinion (No.3) / copy of ID (ARC)',
        zh: '疗养给付申请书（别纸第2号）／疗养给付申请意见书（别纸第3号）／身份证（外国人登录证）复印件',
        vi: 'Đơn (mẫu số 2) / giấy ý kiến (mẫu số 3) / bản sao giấy tờ tùy thân (ARC)',
      ),
      watchOutFor: L10nText(
        ko: '팩스로 제출했다면 근로복지공단 대표번호(1588-0075)로 전화해 정상 수신 여부를 반드시 확인하세요. 병원 위임 제출은 접수 사실을 따로 알려주지 않는 경우가 있으니 며칠 뒤 직접 확인하는 것이 안전합니다.',
        en: "If you faxed it, call COMWEL's main line (1588-0075) to confirm it arrived. A hospital may not notify you once it has filed, so check back yourself a few days later.",
        zh: '如通过传真提交，请务必致电劳动福利公团代表号（1588-0075）确认是否正常收到。医院代为提交有时不会另行通知受理情况，几天后自行确认较为稳妥。',
        vi: 'Nếu gửi fax, hãy gọi số đường dây chính COMWEL (1588-0075) để xác nhận đã nhận được. Bệnh viện nộp thay đôi khi không thông báo riêng nên vài ngày sau bạn nên tự kiểm tra lại.',
      ),
    ),
    TrackStage(
      label: L10nText(
        ko: '공단 현장·재해 조사 및 심사',
        en: 'Investigation and review',
        zh: '公团现场·灾害调查及审查',
        vi: 'Điều tra hiện trường và thẩm định',
      ),
      whatHappens: L10nText(
        ko: '근로복지공단이 업무와 재해 사이의 인과관계를 조사·심사하는 단계입니다. 사고성 재해는 자문의 소견으로 비교적 빠르게, 질병성 재해는 업무상질병판정위원회 심의를 거쳐 최소 1~3개월 이상 걸립니다(산업재해보상보험법 제38조).',
        en: 'COMWEL investigates and reviews the causal link between work and the injury. Accidents are usually decided quickly on an advisory physician\'s opinion; occupational illnesses go through the Occupational Disease Adjudication Committee and take at least one to three months (Art.38).',
        zh: '劳动福利公团审查工作与灾害之间因果关系的阶段。事故性灾害凭顾问医生意见较快决定，疾病性灾害须经业务上疾病判定委员会审议，至少需要1~3个月以上（《产业灾害补偿保险法》第38条）。',
        vi: 'Giai đoạn COMWEL điều tra và thẩm định mối quan hệ nhân quả giữa công việc và tai nạn. Tai nạn thường được quyết định nhanh dựa trên ý kiến bác sĩ tư vấn; bệnh nghề nghiệp phải qua Ủy ban phán định bệnh nghề nghiệp, mất ít nhất 1-3 tháng (Điều 38).',
      ),
      documentsNeeded: L10nText(
        ko: '작업 내용 설명서 / 근무 시간표(근무기록장) / 작업 환경 사진 / 목격자 진술',
        en: 'Job description / work schedule (work log) / workplace photos / witness statement',
        zh: '作业内容说明书／工时表（工作记录本）／作业环境照片／目击者陈述',
        vi: 'Bản mô tả công việc / lịch làm việc (sổ ghi công) / ảnh môi trường làm việc / lời khai nhân chứng',
      ),
      watchOutFor: L10nText(
        ko: '요양으로 휴업한 기간과 그 후 30일 동안은 해고할 수 없습니다(근로기준법 제23조②). 산재 신청·조사 협조를 이유로 불이익을 주면 산업재해보상보험법 제111조 위반으로 500만원 이하 벌금 대상이며, 그런 일이 생기면 관할 고용노동청에 별도로 신고할 수 있습니다.',
        en: 'You cannot be dismissed during recovery leave and for 30 days after (Labor Standards Act Art.23(2)). Retaliation for filing or cooperating with the investigation violates Art.111 of the Act, punishable by a fine of up to 5 million won — report it separately to the labor office if it happens.',
        zh: '在疗养休业期间及其后30天内不得解雇（《劳动基准法》第23条第2款）。以申请工伤·配合调查为由给予不利待遇，违反《产业灾害补偿保险法》第111条，可处500万韩元以下罚款；如发生此类情况，可另行向管辖雇佣劳动厅申报。',
        vi: 'Không thể bị sa thải trong thời gian nghỉ điều trị và 30 ngày sau đó (Điều 23 Khoản 2 Luật Tiêu chuẩn Lao động). Trả đũa vì nộp đơn/hợp tác điều tra vi phạm Điều 111 của Luật, bị phạt tới 5 triệu won — hãy báo riêng cho Sở Lao động nếu việc này xảy ra.',
      ),
    ),
    TrackStage(
      label: L10nText(
        ko: '승인 여부 결과 통지 확인',
        en: 'Check the decision notice',
        zh: '确认核准与否结果通知',
        vi: 'Kiểm tra thông báo kết quả phê duyệt',
      ),
      whatHappens: L10nText(
        ko: '심사가 끝나면 근로복지공단이 승인 또는 불승인 결정을 문자 · 우편으로 통지하는 단계입니다. 공단에서 문자로 결과가 발송됩니다.',
        en: 'Once the review ends, COMWEL notifies you of approval or refusal by text message and post.',
        zh: '审查结束后，劳动福利公团通过短信·邮寄通知核准或不核准决定的阶段。公团会以短信方式发送结果。',
        vi: 'Sau khi thẩm định kết thúc, COMWEL thông báo quyết định phê duyệt hoặc từ chối qua tin nhắn và bưu điện.',
      ),
      documentsNeeded: L10nText(
        ko: '산재보험급여 결정 통지서(승인/불승인)',
        en: 'Insurance benefit decision notice (approved/refused)',
        zh: '工伤保险给付决定通知书（核准/不核准）',
        vi: 'Thông báo quyết định trợ cấp bảo hiểm (phê duyệt/từ chối)',
      ),
      watchOutFor: L10nText(
        ko: '불승인 결정에 이의가 있으면 결정이 있음을 안 날부터 90일 이내에 심사청구를, 심사청구 결정 후 90일 이내에 재심사청구를 할 수 있습니다(산업재해보상보험법 제103조·제106조). 기간을 넘기면 권리를 잃으므로 통지를 받으면 날짜를 바로 기록해두세요.',
        en: 'If you dispute a refusal, you may request a review within 90 days of learning the decision, and a re-review within 90 days of that decision (Art.103, Art.106). Missing the deadline forfeits the right, so record the date as soon as you receive the notice.',
        zh: '若对不核准决定有异议，可在知悉决定之日起90日内提出审查请求，审查请求决定后90日内提出再审查请求（《产业灾害补偿保险法》第103条·第106条）。逾期将丧失权利，收到通知后请立即记下日期。',
        vi: 'Nếu khiếu nại quyết định từ chối, có thể nộp đơn thẩm định trong 90 ngày kể từ khi biết quyết định, và tái thẩm định trong 90 ngày sau quyết định đó (Điều 103, 106). Quá hạn sẽ mất quyền, nên hãy ghi lại ngày ngay khi nhận thông báo.',
      ),
    ),
    TrackStage(
      label: L10nText(
        ko: '4대 보상금 청구 및 입금 확인',
        en: 'Claim benefits & confirm payment',
        zh: '申请4大补偿金及确认入账',
        vi: 'Yêu cầu trợ cấp và xác nhận thanh toán',
      ),
      whatHappens: L10nText(
        ko: '승인 후 치료비(요양급여) · 휴업급여 · 장해급여 등 해당하는 보상금을 청구하고 입금을 확인하는 단계입니다.',
        en: 'After approval, claim the benefits that apply — medical, lost-wage, disability — and confirm the payment.',
        zh: '核准后申请治疗费（疗养给付）·停工给付·残疾给付等相应补偿金并确认入账的阶段。',
        vi: 'Sau khi được phê duyệt, yêu cầu các khoản trợ cấp áp dụng — điều trị, nghỉ việc, thương tật — và xác nhận thanh toán.',
      ),
      documentsNeeded: L10nText(
        ko: '요양비 청구서 / 휴업급여 청구서 / 간병 필요성 소견서(해당 시) / 장해진단서(치료 종결 후)',
        en: 'Treatment cost claim / lost-wage claim / nursing necessity opinion (if applicable) / disability diagnosis (after treatment ends)',
        zh: '疗养费请求书／停工给付请求书／看护必要性意见书（如适用）／残疾诊断书（治疗结束后）',
        vi: 'Đơn yêu cầu chi phí điều trị / đơn trợ cấp nghỉ việc / ý kiến về nhu cầu chăm sóc (nếu có) / giấy chẩn đoán thương tật (sau khi kết thúc điều trị)',
      ),
      watchOutFor: L10nText(
        ko: '치료로 일하지 못한 기간에는 평균임금의 70%가 휴업급여로 산업재해보상보험법 제52조에 따라 지급됩니다. 간병급여는 주치의의 간병 필요성 소견서가 있어야 청구할 수 있고, 치료 종결 후 장해가 남으면 같은 법 제57조에 따라 장해급여를 별도로 신청합니다.',
        en: 'For the period you cannot work due to treatment, lost-wage benefit is paid at 70% of average wage under Article 52. Nursing benefit requires your doctor\'s opinion on the need for care, and if impairment remains after treatment ends, disability benefit is claimed separately under Article 57.',
        zh: '因治疗无法工作的期间，按《产业灾害补偿保险法》第52条支付平均工资70%的停工给付。看护给付须有主治医生的看护必要性意见书方可申请，治疗结束后仍留有残疾的，依同法第57条另行申请残疾给付。',
        vi: 'Trong thời gian không thể làm việc do điều trị, trợ cấp nghỉ việc được trả bằng 70% lương bình quân theo Điều 52. Trợ cấp chăm sóc cần có ý kiến của bác sĩ về nhu cầu chăm sóc, và nếu còn thương tật sau khi kết thúc điều trị thì nộp đơn trợ cấp thương tật riêng theo Điều 57.',
      ),
    ),
  ],
);
