import '../../../core/app_language.dart';
import '../models/flow_block.dart';

/// 산재처리 신청 내비게이터 — 6단계 + 접수 이후 6단계 트래커.
/// 프론트엔드_구상_확장.html의 FLOWS.injury(한국어)를 그대로 옮겼다.
const injuryFlowDefinition = FlowDefinition(
  accent: FlowAccent.teal,
  steps: [
    FlowStep(
      title: L10nText(
        ko: '어떻게 다치셨나요?',
        en: 'How were you injured?',
        zh: '您是如何受伤的？',
        vi: 'Bạn bị thương như thế nào?',
      ),
      lead: L10nText(
        ko: '사고인지 질병인지에 따라 필요한 증거가 달라집니다.',
        en: "The evidence you need differs depending on whether it's an accident or an occupational disease.",
        zh: '根据是事故还是疾病，所需的证据也不同。',
        vi: 'Bằng chứng cần thiết khác nhau tùy vào đó là tai nạn hay bệnh nghề nghiệp.',
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
              ko: '넘어짐·베임·끼임·추락·찔림',
              en: 'Falls, cuts, being caught in machinery, falling from height, punctures',
              zh: '跌倒·割伤·夹伤·坠落·刺伤',
              vi: 'Ngã · đứt tay · kẹt máy · rơi từ trên cao · đâm',
            ),
          ),
          FlowOption(
            emoji: '🦠',
            title: L10nText(
              ko: '질병성 재해',
              en: 'Occupational disease',
              zh: '疾病性灾害',
              vi: 'Bệnh nghề nghiệp',
            ),
            subtitle: L10nText(
              ko: '근골격계 질환·화학물질 장기 노출·직업성 질병',
              en: 'Musculoskeletal disorders, long-term exposure to chemicals, occupational illness',
              zh: '肌肉骨骼疾病·长期接触化学物质·职业性疾病',
              vi: 'Bệnh cơ xương khớp · phơi nhiễm hóa chất lâu dài · bệnh nghề nghiệp',
            ),
          ),
        ]),
      ],
    ),
    FlowStep(
      title: L10nText(
        ko: '가장 먼저 할 일',
        en: 'The first thing to do',
        zh: '首先要做的事',
        vi: 'Việc cần làm đầu tiên',
      ),
      lead: L10nText(
        ko: '노무사 검수를 마친 안내입니다.',
        en: 'This guidance has been reviewed by a certified labor affairs consultant.',
        zh: '本指南已经过劳务士审核。',
        vi: 'Đây là hướng dẫn đã được tư vấn viên lao động thẩm định.',
      ),
      blocks: [
        NoticeBlock(
          tone: NoticeTone.teal,
          title: L10nText(
            ko: '초진소견서를 꼭 받으세요',
            en: 'Be sure to get an initial medical opinion (chojin sogyeonseo)',
            zh: '请务必取得初诊所见书',
            vi: 'Hãy chắc chắn xin giấy chẩn đoán ban đầu',
          ),
          body: L10nText(
            ko: "병원 원무과에 '일하다 다쳤다'고 분명히 말해야 산재 치료로 기록됩니다. 업무와의 연관성을 증명하는 것이 핵심입니다.",
            en: "You must clearly tell the hospital's admissions office that you were 'injured while working' for it to be recorded as an industrial-accident treatment. Proving the connection to your work is the key.",
            zh: '必须在医院挂号处明确告知"是在工作时受的伤"，才能被记录为工伤治疗。证明与工作的关联性是关键。',
            vi: 'Phải nói rõ với phòng hành chính bệnh viện rằng "bị thương khi đang làm việc" thì mới được ghi nhận là điều trị tai nạn lao động. Chứng minh mối liên hệ với công việc là điều mấu chốt.',
          ),
        ),
        NoticeBlock(
          tone: NoticeTone.amber,
          title: L10nText(
            ko: '공상처리 제안을 조심하세요',
            en: 'Be careful of offers to handle it as a private injury settlement',
            zh: '请警惕私了（工伤私下处理）的提议',
            vi: 'Hãy cẩn thận với đề nghị xử lý riêng (không qua bảo hiểm tai nạn lao động)',
          ),
          body: L10nText(
            ko: '현금으로 합의하자는 제안에 응하면 나중에 후유증이 생겨도 치료비를 받을 수 없습니다.',
            en: 'If you accept an offer to settle in cash, you will not be able to receive treatment costs later even if aftereffects develop.',
            zh: '如果接受现金和解的提议，之后即使出现后遗症也无法获得治疗费。',
            vi: 'Nếu đồng ý thỏa thuận bằng tiền mặt, sau này dù có di chứng cũng không thể nhận được tiền điều trị.',
          ),
        ),
      ],
    ),
    FlowStep(
      title: L10nText(
        ko: '사고 상황을 적어주세요',
        en: 'Write down the circumstances of the accident',
        zh: '请写下事故经过',
        vi: 'Hãy viết lại tình huống xảy ra tai nạn',
      ),
      lead: L10nText(
        ko: '여기 적은 내용은 고치지 않고 그대로 서류에 들어갑니다.',
        en: 'What you write here will go into the document exactly as written, without any edits.',
        zh: '在这里写的内容将原封不动地录入文件，不会被修改。',
        vi: 'Nội dung bạn viết ở đây sẽ được đưa nguyên văn vào hồ sơ, không chỉnh sửa.',
      ),
      blocks: [
        ChecklistBlock([
          L10nText(
            ko: '초진소견서 또는 진단서가 있다',
            en: 'I have an initial medical opinion or a diagnosis certificate',
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
        ]),
        RawTextBlock(
          L10nText(
            ko: '예: 8월 4일 오후 3시경 3번 라인에서 부품을 옮기다가 지게차에 발등을 찍혔습니다. 옆에 있던 동료 ○○가 봤습니다.',
            en: 'Example: On August 4th, around 3 p.m., while moving parts at Line 3, a forklift ran over the top of my foot. My coworker ○○, who was nearby, saw it happen.',
            zh: '例：8月4日下午3点左右，在3号生产线搬运零件时，被叉车压到了脚背。当时在旁边的同事○○看到了。',
            vi: 'Ví dụ: Khoảng 3 giờ chiều ngày 4 tháng 8, trong lúc di chuyển linh kiện tại chuyền số 3, tôi bị xe nâng cán qua mu bàn chân. Đồng nghiệp ○○ đứng gần đó đã nhìn thấy.',
          ),
        ),
      ],
    ),
    FlowStep(
      title: L10nText(
        ko: '요양급여신청서에 이렇게 들어갑니다',
        en: 'This is how it will appear on the medical care benefit application',
        zh: '疗养给付申请书中将这样填写',
        vi: 'Đây là nội dung sẽ được đưa vào đơn xin trợ cấp điều trị',
      ),
      lead: L10nText(
        ko: '의학적 판단은 앱이 하지 않습니다.',
        en: 'The app does not make medical judgments.',
        zh: '本应用不会做出医学判断。',
        vi: 'Ứng dụng không đưa ra phán đoán y tế.',
      ),
      blocks: [
        FillCardBlock([
          FlowFillRow(
            label: L10nText(
              ko: '신청인',
              en: 'Applicant',
              zh: '申请人',
              vi: 'Người nộp đơn',
            ),
            value: L10nText(
              ko: '응우옌 반 남 (E-9)',
              en: 'Nguyen Van Nam (E-9)',
              zh: '阮文南 (E-9)',
              vi: 'Nguyễn Văn Nam (E-9)',
            ),
            tag: FillTag.auto,
          ),
          FlowFillRow(
            label: L10nText(
              ko: '사업장 정보',
              en: 'Workplace information',
              zh: '工作单位信息',
              vi: 'Thông tin nơi làm việc',
            ),
            value: L10nText(
              ko: '○○산업 · 경기 수원시',
              en: '○○ Industries · Suwon, Gyeonggi',
              zh: '○○产业·京畿道水原市',
              vi: 'Công ty ○○ · Suwon, Gyeonggi',
            ),
            tag: FillTag.auto,
          ),
          FlowFillRow(
            label: L10nText(
              ko: '재해 일시·장소',
              en: 'Date, time, and location of the accident',
              zh: '灾害发生日期时间及地点',
              vi: 'Thời gian và địa điểm xảy ra tai nạn',
            ),
            value: L10nText(
              ko: '2026.08.04 15:00 · 3번 라인',
              en: '2026.08.04 15:00 · Line 3',
              zh: '2026.08.04 15:00·3号线',
              vi: '2026.08.04 15:00 · Chuyền số 3',
            ),
            tag: FillTag.auto,
          ),
          FlowFillRow(
            label: L10nText(
              ko: '재해 발생 경위',
              en: 'How the accident occurred',
              zh: '灾害发生经过',
              vi: 'Diễn biến xảy ra tai nạn',
            ),
            value: L10nText(
              ko: '앞 단계에서 적은 내용 그대로',
              en: 'Exactly what you wrote in the previous step',
              zh: '与上一步所写内容完全相同',
              vi: 'Đúng như nội dung đã viết ở bước trước',
            ),
            tag: FillTag.raw,
          ),
          FlowFillRow(
            label: L10nText(
              ko: '의학적 소견',
              en: 'Medical opinion',
              zh: '医学所见',
              vi: 'Ý kiến y khoa',
            ),
            value: L10nText(
              ko: '의사가 작성합니다',
              en: 'Written by the doctor',
              zh: '由医生填写',
              vi: 'Do bác sĩ ghi',
            ),
            tag: FillTag.blank,
          ),
          FlowFillRow(
            label: L10nText(
              ko: '재해조사 소견',
              en: 'Accident investigation findings',
              zh: '灾害调查所见',
              vi: 'Kết quả điều tra tai nạn',
            ),
            value: L10nText(
              ko: '공단 조사관이 작성합니다',
              en: "Written by the Service's investigator",
              zh: '由公团调查员填写',
              vi: 'Do điều tra viên của Cơ quan ghi',
            ),
            tag: FillTag.blank,
          ),
        ]),
        NoticeBlock(
          tone: NoticeTone.blue,
          title: L10nText(
            ko: '승인 여부는 앱이 정하지 않습니다',
            en: 'Approval is not decided by the app',
            zh: '是否核准并非由本应用决定',
            vi: 'Ứng dụng không quyết định việc có được phê duyệt hay không',
          ),
          body: L10nText(
            ko: '제출된 소견서와 근로복지공단 심사를 통해 최종 승인 여부가 결정됩니다.',
            en: "Final approval is decided through the submitted medical opinion and review by the Korea Workers' Compensation and Welfare Service (KCOMWEL).",
            zh: '最终是否核准将根据提交的所见书和韩国劳动福祉公团的审查结果决定。',
            vi: 'Việc phê duyệt cuối cùng được quyết định thông qua giấy ý kiến đã nộp và thẩm định của Cơ quan Phúc lợi và Bồi thường Lao động Hàn Quốc (KCOMWEL).',
          ),
        ),
      ],
    ),
    FlowStep(
      title: L10nText(
        ko: '제출 방법을 고르세요',
        en: 'Choose how to submit',
        zh: '请选择提交方式',
        vi: 'Hãy chọn cách nộp hồ sơ',
      ),
      lead: L10nText(
        ko: '병원에 맡기는 방법이 가장 편합니다.',
        en: 'Leaving it to the hospital is the most convenient method.',
        zh: '交给医院办理是最方便的方式。',
        vi: 'Nhờ bệnh viện thực hiện là cách thuận tiện nhất.',
      ),
      blocks: [
        OptionsBlock([
          FlowOption(
            emoji: '🏥',
            title: L10nText(
              ko: '산재지정병원에 위임 (권장)',
              en: "Delegate to a workers' compensation designated hospital (recommended)",
              zh: '委托工伤指定医院办理（推荐）',
              vi: 'Ủy quyền cho bệnh viện chỉ định bảo hiểm tai nạn lao động (khuyến nghị)',
            ),
            subtitle: L10nText(
              ko: '병원이 서류를 대신 접수해줍니다',
              en: 'The hospital files the documents on your behalf',
              zh: '由医院代为提交文件',
              vi: 'Bệnh viện sẽ nộp hồ sơ thay bạn',
            ),
          ),
          FlowOption(
            emoji: '🏛️',
            title: L10nText(
              ko: '근로복지공단에 직접 제출',
              en: 'Submit directly to KCOMWEL',
              zh: '直接提交至韩国劳动福祉公团',
              vi: 'Nộp trực tiếp cho Cơ quan Phúc lợi và Bồi thường Lao động Hàn Quốc',
            ),
            subtitle: L10nText(
              ko: '가까운 지사를 찾아드립니다',
              en: 'We help you find the nearest branch office',
              zh: '为您查找附近的分支机构',
              vi: 'Tìm chi nhánh gần nhất giúp bạn',
            ),
          ),
        ]),
        NoticeBlock(
          tone: NoticeTone.amber,
          title: L10nText(
            ko: '사업주 도장은 필요 없습니다',
            en: "You do not need your employer's stamp",
            zh: '无需雇主盖章',
            vi: 'Không cần con dấu của chủ sử dụng lao động',
          ),
          body: L10nText(
            ko: '사업주가 날인을 거부해도 근로자 혼자 신청할 수 있습니다. Local Bridge는 신청을 대행하지 않습니다.',
            en: 'Even if the employer refuses to stamp the form, the worker can apply alone. Local Bridge does not file the application on your behalf.',
            zh: '即使雇主拒绝盖章，劳动者本人也可以单独申请。Local Bridge不会代为申请。',
            vi: 'Ngay cả khi chủ sử dụng lao động từ chối đóng dấu, người lao động vẫn có thể tự nộp đơn một mình. Local Bridge không nộp đơn thay bạn.',
          ),
        ),
      ],
    ),
    FlowStep(
      title: L10nText(
        ko: '여기서부터는 심사 기간입니다',
        en: "From here on, it's the review period",
        zh: '从这里开始就是审查期了',
        vi: 'Từ đây trở đi là thời gian thẩm định',
      ),
      lead: L10nText(
        ko: '신청 이후 6단계를 여기서 확인할 수 있습니다. 각 단계를 누르면 자세한 안내가 열립니다.',
        en: 'You can check the 6 stages after applying right here. Tap each stage to see detailed guidance.',
        zh: '申请之后的6个阶段可以在这里查看。点击每个阶段即可打开详细说明。',
        vi: 'Bạn có thể xem 6 giai đoạn sau khi nộp đơn tại đây. Nhấn vào từng giai đoạn để xem hướng dẫn chi tiết.',
      ),
      blocks: [TrackerBlock(now: 2)],
    ),
  ],
  track: [
    TrackStage(
      label: L10nText(
        ko: '초진소견서',
        en: 'Initial medical opinion',
        zh: '初诊所见书',
        vi: 'Giấy chẩn đoán ban đầu',
      ),
      whatHappens: L10nText(
        ko: '다친 즉시 치료를 받고 초진소견서를 발급받는 단계',
        en: 'The stage where you receive treatment immediately after the injury and obtain an initial medical opinion',
        zh: '受伤后立即接受治疗并取得初诊所见书的阶段',
        vi: 'Giai đoạn được điều trị ngay sau khi bị thương và nhận giấy chẩn đoán ban đầu',
      ),
      documentsNeeded: L10nText(
        ko: '병원 의무기록지, 초진소견서(진단서)',
        en: 'Hospital medical record, initial medical opinion (diagnosis certificate)',
        zh: '医院医疗记录单、初诊所见书（诊断书）',
        vi: 'Hồ sơ bệnh án của bệnh viện, giấy chẩn đoán ban đầu (giấy chẩn đoán)',
      ),
      watchOutFor: L10nText(
        ko: '신청 기한은 3년입니다(장해·사망은 5년).',
        en: 'The filing deadline is 3 years (5 years for disability or death).',
        zh: '申请期限为3年（伤残·死亡为5年）。',
        vi: 'Thời hạn nộp đơn là 3 năm (di chứng · tử vong là 5 năm).',
      ),
    ),
    TrackStage(
      label: L10nText(
        ko: '증거 수집',
        en: 'Gathering evidence',
        zh: '收集证据',
        vi: 'Thu thập bằng chứng',
      ),
      whatHappens: L10nText(
        ko: '업무 중 발생했음을 증명할 자료와 목격자를 확보하는 단계',
        en: 'The stage where you secure materials and witnesses proving the injury occurred while working',
        zh: '确保能证明事故发生在工作过程中的资料及目击者的阶段',
        vi: 'Giai đoạn thu thập tài liệu và nhân chứng chứng minh sự việc xảy ra trong khi làm việc',
      ),
      documentsNeeded: L10nText(
        ko: '현장 사진, CCTV, 목격자 진술서, 근무기록장 GPS 기록',
        en: 'Scene photos, CCTV footage, witness statement, GPS records from the work log',
        zh: '现场照片、监控录像、目击者陈述书、工作记录本的GPS记录',
        vi: 'Ảnh hiện trường, camera an ninh, bản tường trình của nhân chứng, dữ liệu GPS trong sổ ghi công',
      ),
      watchOutFor: L10nText(
        ko: '현금 합의 제안에 응하지 말고 정식으로 신청하세요.',
        en: 'Do not accept a cash-settlement offer — file the official application instead.',
        zh: '请不要接受现金和解的提议，应正式提出申请。',
        vi: 'Đừng đồng ý đề nghị thỏa thuận bằng tiền mặt, hãy nộp đơn chính thức.',
      ),
    ),
    TrackStage(
      label: L10nText(
        ko: '요양급여 신청',
        en: 'Applying for medical care benefits',
        zh: '申请疗养给付',
        vi: 'Nộp đơn xin trợ cấp điều trị',
      ),
      whatHappens: L10nText(
        ko: '근로복지공단에 치료비와 휴업수당 지급을 요청하는 단계',
        en: 'The stage where you request payment of treatment costs and leave allowance from KCOMWEL',
        zh: '向韩国劳动福祉公团申请支付治疗费和停工津贴的阶段',
        vi: 'Giai đoạn yêu cầu Cơ quan Phúc lợi và Bồi thường Lao động Hàn Quốc chi trả tiền điều trị và trợ cấp nghỉ việc',
      ),
      documentsNeeded: L10nText(
        ko: '요양급여신청서, 초진소견서',
        en: 'Medical care benefit application form, initial medical opinion',
        zh: '疗养给付申请书、初诊所见书',
        vi: 'Đơn xin trợ cấp điều trị, giấy chẩn đoán ban đầu',
      ),
      watchOutFor: L10nText(
        ko: '사업주에게 거부권이 없습니다. 근로자 혼자 신청할 수 있습니다.',
        en: 'The employer has no right to refuse. The worker can apply alone.',
        zh: '雇主没有拒绝权，劳动者可以单独申请。',
        vi: 'Chủ sử dụng lao động không có quyền từ chối. Người lao động có thể tự nộp đơn một mình.',
      ),
    ),
    TrackStage(
      label: L10nText(
        ko: '현장 조사',
        en: 'On-site investigation',
        zh: '现场调查',
        vi: 'Điều tra hiện trường',
      ),
      whatHappens: L10nText(
        ko: '공단과 질병판정위원회가 업무 연관성을 심사하는 과정',
        en: 'The process where KCOMWEL and the Occupational Disease Adjudication Committee review the connection to work',
        zh: '由公团和疾病判定委员会审查与工作关联性的过程',
        vi: 'Quá trình Cơ quan và Ủy ban thẩm định bệnh nghề nghiệp xem xét mối liên hệ với công việc',
      ),
      documentsNeeded: L10nText(
        ko: '작업 내용 설명서, 근무 시간표, 작업 환경 사진',
        en: 'Description of work duties, work schedule, photos of the work environment',
        zh: '工作内容说明书、工作时间表、作业环境照片',
        vi: 'Bản mô tả nội dung công việc, lịch làm việc, ảnh môi trường làm việc',
      ),
      watchOutFor: L10nText(
        ko: '요양 기간과 그 후 30일 동안은 해고할 수 없습니다(근로기준법 제23조②).',
        en: 'You cannot be dismissed during the medical care period and for 30 days afterward (Labor Standards Act Article 23, Paragraph 2).',
        zh: '在疗养期间及其后30天内不得解雇（《劳动基准法》第23条第2款）。',
        vi: 'Không thể bị sa thải trong thời gian điều trị và 30 ngày sau đó (Điều 23 Khoản 2 Luật Tiêu chuẩn Lao động).',
      ),
    ),
    TrackStage(
      label: L10nText(
        ko: '승인·보상',
        en: 'Approval and compensation',
        zh: '核准·补偿',
        vi: 'Phê duyệt · bồi thường',
      ),
      whatHappens: L10nText(
        ko: '산재 승인 후 보상금을 수령하는 단계',
        en: "The stage where you receive compensation after the workers' compensation claim is approved",
        zh: '工伤获批后领取补偿金的阶段',
        vi: 'Giai đoạn nhận tiền bồi thường sau khi được phê duyệt tai nạn lao động',
      ),
      documentsNeeded: L10nText(
        ko: '요양비 청구서, 휴업급여 청구서',
        en: 'Medical expense claim form, leave benefit claim form',
        zh: '疗养费请求书、停工给付请求书',
        vi: 'Đơn yêu cầu chi phí điều trị, đơn yêu cầu trợ cấp nghỉ việc',
      ),
      watchOutFor: L10nText(
        ko: '휴업급여는 평균임금의 70%입니다. 간병급여·직업재활급여도 확인해보세요.',
        en: 'The leave benefit is 70% of your average wage. Also check the nursing benefit and vocational rehabilitation benefit.',
        zh: '停工给付为平均工资的70%。也请确认护理给付和职业康复给付。',
        vi: 'Trợ cấp nghỉ việc bằng 70% lương bình quân. Hãy kiểm tra thêm trợ cấp chăm sóc và trợ cấp phục hồi nghề nghiệp.',
      ),
    ),
    TrackStage(
      label: L10nText(
        ko: '불승인 불복',
        en: 'Appealing a denial',
        zh: '不予核准的申诉',
        vi: 'Khiếu nại khi bị từ chối',
      ),
      whatHappens: L10nText(
        ko: '산재가 불승인되었을 때 이의를 제기하는 단계',
        en: "The stage where you raise an objection if your workers' compensation claim is denied",
        zh: '工伤申请未获核准时提出异议的阶段',
        vi: 'Giai đoạn khiếu nại khi đơn yêu cầu tai nạn lao động bị từ chối',
      ),
      documentsNeeded: L10nText(
        ko: '불승인 결정 통지서, 심사청구서, 보완 전문의 소견서',
        en: 'Notice of denial decision, request for review, supplementary specialist medical opinion',
        zh: '不予核准决定通知书、审查请求书、补充专科医生所见书',
        vi: 'Thông báo quyết định từ chối, đơn yêu cầu thẩm định lại, ý kiến bổ sung của bác sĩ chuyên khoa',
      ),
      watchOutFor: L10nText(
        ko: '심사청구와 재심사청구는 각각 90일 안에 해야 합니다.',
        en: 'Both the request for review and the request for re-review must each be filed within 90 days.',
        zh: '审查请求和再审查请求均需分别在90天内提出。',
        vi: 'Đơn yêu cầu thẩm định và đơn yêu cầu tái thẩm định đều phải nộp trong vòng 90 ngày.',
      ),
    ),
  ],
);
