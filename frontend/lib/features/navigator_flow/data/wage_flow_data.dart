import '../../../core/app_language.dart';
import '../models/flow_block.dart';

/// 임금체불 진정 내비게이터 — 6단계 + 접수 이후 8단계 트래커.
/// 프론트엔드_구상_확장.html의 FLOWS.wage(한국어)를 그대로 옮겼다.
const wageFlowDefinition = FlowDefinition(
  accent: FlowAccent.amber,
  steps: [
    FlowStep(
      title: L10nText(
        ko: '어떤 문제인가요?',
        en: "What's the problem?",
        zh: '是什么问题？',
        vi: 'Vấn đề của bạn là gì?',
      ),
      lead: L10nText(
        ko: '정해진 선택지로 먼저 나눕니다. AI가 법적으로 판단하지 않기 위한 절차입니다.',
        en: 'We start by sorting your case into fixed categories. This step exists so the AI does not make legal judgments.',
        zh: '首先按照固定选项进行分类。这是为了避免AI做出法律判断的程序。',
        vi: 'Trước tiên sẽ phân loại theo các lựa chọn có sẵn. Đây là quy trình để AI không tự đưa ra phán đoán pháp lý.',
      ),
      blocks: [
        OptionsBlock([
          FlowOption(
            emoji: '💰',
            title: L10nText(
              ko: '단순 임금체불',
              en: 'Simple wage delay',
              zh: '单纯欠薪',
              vi: 'Nợ lương đơn giản',
            ),
            subtitle: L10nText(
              ko: '월급이나 일당이 며칠 밀렸어요',
              en: 'My monthly or daily pay is a few days overdue',
              zh: '月薪或日薪被拖欠了几天',
              vi: 'Lương tháng hoặc lương ngày bị chậm trả vài ngày',
            ),
          ),
          FlowOption(
            emoji: '⚠️',
            title: L10nText(
              ko: '부당 삭감·수당 미지급·복합',
              en: 'Unfair deduction, unpaid allowance, or combined issues',
              zh: '不当扣减·津贴未付·复合问题',
              vi: 'Bị trừ lương bất hợp lý · không trả phụ cấp · nhiều vấn đề',
            ),
            subtitle: L10nText(
              ko: '금액이 깎였거나 여러 문제가 겹쳐 있어요',
              en: 'The amount was cut, or several problems overlap',
              zh: '金额被克扣，或多个问题交织在一起',
              vi: 'Số tiền bị cắt giảm hoặc nhiều vấn đề chồng chéo nhau',
            ),
          ),
        ]),
      ],
    ),
    FlowStep(
      title: L10nText(
        ko: '먼저 사장님과 이야기해보세요',
        en: 'First, try talking to your employer',
        zh: '请先与老板沟通',
        vi: 'Trước tiên hãy thử nói chuyện với chủ sử dụng lao động',
      ),
      lead: L10nText(
        ko: '단순 체불은 신고 전에 직접 대화하면 가장 빨리 해결되는 경우가 많습니다.',
        en: 'For a simple wage delay, talking directly before filing a report is often the fastest way to resolve it.',
        zh: '对于单纯的欠薪问题，在举报前直接沟通往往是解决问题最快的方式。',
        vi: 'Với nợ lương đơn giản, nói chuyện trực tiếp trước khi báo cáo thường là cách giải quyết nhanh nhất.',
      ),
      blocks: [
        NoticeBlock(
          tone: NoticeTone.amber,
          title: L10nText(
            ko: '돈을 받기 전에는 서명하지 마세요',
            en: 'Do not sign anything before you receive the money',
            zh: '在收到钱之前请不要签字',
            vi: 'Đừng ký bất kỳ giấy tờ nào trước khi nhận được tiền',
          ),
          body: L10nText(
            ko: '합의서나 진정 취하서에 먼저 서명하면 이후 처벌을 요구할 수 없게 됩니다(반의사불벌).',
            en: 'If you sign a settlement agreement or a complaint-withdrawal form before being paid, you will no longer be able to request punishment afterward — wage theft is an offense that is not prosecuted once the victim expresses they do not wish it (banuisabulbeol).',
            zh: '如果在拿到钱之前先签署和解书或撤诉书，之后将无法再要求处罚——这是一种只要受害人表示不追究就不予处罚的犯罪（反意思不罚罪）。',
            vi: 'Nếu ký vào biên bản hòa giải hoặc đơn rút đơn tố cáo trước khi nhận được tiền, sau đó bạn sẽ không thể yêu cầu xử phạt nữa — đây là loại tội chỉ không bị xử phạt khi nạn nhân bày tỏ ý muốn không truy cứu (phản ý tư bất phạt).',
          ),
        ),
        OptionsBlock([
          FlowOption(
            emoji: '💬',
            title: L10nText(
              ko: '사장님께 보낼 내역서 만들기',
              en: 'Create a statement to send to your employer',
              zh: '制作要发送给老板的明细单',
              vi: 'Tạo bảng kê để gửi cho chủ sử dụng lao động',
            ),
            subtitle: L10nText(
              ko: '근무기록장 데이터로 문자·카카오톡 템플릿을 자동으로 만듭니다',
              en: 'Automatically creates a text/KakaoTalk message template using your work-log data',
              zh: '使用工作记录本的数据自动生成短信·KakaoTalk消息模板',
              vi: 'Tự động tạo mẫu tin nhắn/KakaoTalk từ dữ liệu sổ ghi công',
            ),
          ),
          FlowOption(
            emoji: '➡️',
            title: L10nText(
              ko: '그래도 진정서 작성 계속하기',
              en: 'Continue writing the complaint anyway',
              zh: '仍然继续填写申诉书',
              vi: 'Vẫn tiếp tục viết đơn tố cáo',
            ),
            subtitle: L10nText(
              ko: '바로 다음 단계로 넘어갑니다',
              en: 'Moves straight to the next step',
              zh: '直接进入下一步',
              vi: 'Chuyển thẳng sang bước tiếp theo',
            ),
          ),
        ]),
      ],
    ),
    FlowStep(
      title: L10nText(
        ko: '무슨 일이 있었는지 적어주세요',
        en: 'Write down what happened',
        zh: '请写下发生了什么事',
        vi: 'Hãy viết lại chuyện đã xảy ra',
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
            ko: '근로계약서를 썼다',
            en: 'I signed an employment contract',
            zh: '已签订劳动合同',
            vi: 'Đã ký hợp đồng lao động',
          ),
          L10nText(
            ko: '급여가 들어오는 통장 내역이 있다',
            en: 'I have bank records showing my pay deposits',
            zh: '有工资入账的银行流水',
            vi: 'Có sao kê ngân hàng ghi nhận tiền lương chuyển vào',
          ),
          L10nText(
            ko: '근무기록장에 출퇴근을 적어뒀다',
            en: 'I recorded my clock-in/clock-out times in the work log',
            zh: '已在工作记录本中记录了上下班时间',
            vi: 'Đã ghi giờ đi làm/tan làm trong sổ ghi công',
          ),
          L10nText(
            ko: '카카오톡·문자·녹음이 남아 있다',
            en: 'I have KakaoTalk messages, texts, or recordings saved',
            zh: '保留有KakaoTalk消息、短信或录音',
            vi: 'Còn lưu tin nhắn KakaoTalk, SMS hoặc bản ghi âm',
          ),
        ]),
        RawTextBlock(
          L10nText(
            ko: '예: 7월 급여일이 지났는데 아직 못 받았습니다. 사장님은 거래처에서 돈이 안 들어와서 다음 달에 준다고 했습니다.',
            en: "Example: My July payday has passed and I still haven't been paid. My employer said a client hasn't paid them yet, so they'll pay me next month.",
            zh: '例：7月的发薪日已过，但我至今仍未收到工资。老板说客户还没有付款，所以要下个月才能给我。',
            vi: 'Ví dụ: Ngày trả lương tháng 7 đã qua nhưng tôi vẫn chưa nhận được lương. Chủ nói vì đối tác chưa chuyển tiền nên sẽ trả vào tháng sau.',
          ),
        ),
      ],
    ),
    FlowStep(
      title: L10nText(
        ko: '진정서에 이렇게 들어갑니다',
        en: 'This is how it will appear in your complaint form',
        zh: '申诉书中将这样填写',
        vi: 'Đây là nội dung sẽ được đưa vào đơn tố cáo',
      ),
      lead: L10nText(
        ko: '자동으로 채우는 칸과 비워두는 칸이 나뉩니다. 색으로 구분해서 보여드립니다.',
        en: 'Some fields are filled in automatically, and others are left blank. We show the difference by color.',
        zh: '分为自动填写的栏目和留空的栏目，我们用颜色加以区分显示。',
        vi: 'Có ô được điền tự động và ô để trống. Chúng tôi phân biệt bằng màu sắc.',
      ),
      blocks: [
        FillCardBlock([
          FlowFillRow(
            label: L10nText(
              ko: '진정인',
              en: 'Complainant',
              zh: '申诉人',
              vi: 'Người tố cáo',
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
              ko: '피진정인',
              en: 'Respondent',
              zh: '被申诉人',
              vi: 'Người bị tố cáo',
            ),
            value: L10nText(
              ko: '○○산업 대표 김○○',
              en: 'Kim ○○, CEO of ○○ Industries',
              zh: '○○产业 代表金○○',
              vi: 'Giám đốc Kim ○○, Công ty ○○',
            ),
            tag: FillTag.auto,
          ),
          FlowFillRow(
            label: L10nText(
              ko: '근무기간',
              en: 'Employment period',
              zh: '工作期间',
              vi: 'Thời gian làm việc',
            ),
            value: L10nText(
              ko: '2025.04.01 ~ 2026.07.31',
              en: '2025.04.01 ~ 2026.07.31',
              zh: '2025.04.01 ~ 2026.07.31',
              vi: '2025.04.01 ~ 2026.07.31',
            ),
            tag: FillTag.auto,
          ),
          FlowFillRow(
            label: L10nText(
              ko: '체불임금 총액',
              en: 'Total unpaid wages',
              zh: '拖欠工资总额',
              vi: 'Tổng số lương bị nợ',
            ),
            value: L10nText(
              ko: '직접 입력해주세요',
              en: 'Please enter this yourself',
              zh: '请自行填写',
              vi: 'Vui lòng tự nhập',
            ),
            tag: FillTag.blank,
          ),
          FlowFillRow(
            label: L10nText(
              ko: '청구 취지 및 이유',
              en: 'Claim purpose and reasons',
              zh: '请求宗旨及理由',
              vi: 'Mục đích và lý do yêu cầu',
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
              ko: '위반 법조항',
              en: 'Violated legal provision',
              zh: '违反的法律条款',
              vi: 'Điều khoản pháp luật bị vi phạm',
            ),
            value: L10nText(
              ko: '근로감독관이 판단합니다',
              en: 'Determined by the labor inspector',
              zh: '由劳动监督官判断',
              vi: 'Do thanh tra lao động xác định',
            ),
            tag: FillTag.blank,
          ),
        ]),
        NoticeBlock(
          tone: NoticeTone.blue,
          title: L10nText(
            ko: '금액은 왜 비어 있나요?',
            en: 'Why is the amount left blank?',
            zh: '为什么金额栏是空的？',
            vi: 'Vì sao số tiền lại để trống?',
          ),
          body: L10nText(
            ko:
                '체불 확정 금액은 근로감독관 조사에서 산정됩니다. 앱이 미리 정해두면 다툼의 대상이 되기 때문에, '
                '임금계산기 결과를 보고 본인이 직접 적도록 했습니다.',
            en: "The confirmed amount of unpaid wages is calculated during the labor inspector's investigation. If the app pre-filled this figure, it could become a point of dispute, so we ask you to enter it yourself after checking the result from the wage calculator.",
            zh: '拖欠金额的最终确定是在劳动监督官的调查过程中核算的。如果由本应用提前填写，可能会成为争议对象，因此需要您查看工资计算器的结果后自行填写。',
            vi: 'Số tiền lương bị nợ được xác định trong quá trình điều tra của thanh tra lao động. Nếu ứng dụng tự điền sẵn con số này, nó có thể trở thành đối tượng tranh chấp, vì vậy chúng tôi để bạn tự nhập sau khi xem kết quả từ máy tính lương.',
          ),
        ),
      ],
    ),
    FlowStep(
      title: L10nText(
        ko: '직접 제출하셔야 합니다',
        en: 'You must submit this yourself',
        zh: '您必须亲自提交',
        vi: 'Bạn phải tự mình nộp hồ sơ',
      ),
      lead: L10nText(
        ko: '두 가지 방법 중에 고르세요.',
        en: 'Choose one of the two methods below.',
        zh: '请从以下两种方式中选择一种。',
        vi: 'Hãy chọn một trong hai cách sau.',
      ),
      blocks: [
        NoticeBlock(
          tone: NoticeTone.amber,
          title: L10nText(
            ko: 'Local Bridge는 서류를 대신 내지 않습니다',
            en: 'Local Bridge does not submit documents on your behalf',
            zh: 'Local Bridge不会代为提交文件',
            vi: 'Local Bridge không nộp hồ sơ thay bạn',
          ),
          body: L10nText(
            ko: '공인노무사법 제2조에 따라 서류 제출은 근로자 본인이 직접 진행해야 합니다.',
            en: 'Under Article 2 of the Certified Labor Affairs Consultant Act, only the worker themselves may submit these documents.',
            zh: '根据《公认劳务士法》第2条，文件提交必须由劳动者本人亲自进行。',
            vi: 'Theo Điều 2 Luật Tư vấn viên Lao động được chứng nhận, việc nộp hồ sơ phải do chính người lao động thực hiện.',
          ),
        ),
        OptionsBlock([
          FlowOption(
            emoji: '💻',
            title: L10nText(
              ko: '노동포털 온라인 접수',
              en: 'Online filing via the Labor Portal',
              zh: '通过劳动门户网站在线申请',
              vi: 'Nộp trực tuyến qua Cổng thông tin lao động',
            ),
            subtitle: L10nText(
              ko: '집에서 접수하는 방법을 화면 그대로 안내합니다',
              en: 'We guide you screen-by-screen through filing from home',
              zh: '按实际界面为您演示如何在家申请',
              vi: 'Hướng dẫn từng màn hình cách nộp hồ sơ tại nhà',
            ),
          ),
          FlowOption(
            emoji: '🏛️',
            title: L10nText(
              ko: '관할 노동청 방문·팩스',
              en: 'Visit or fax the labor office with jurisdiction',
              zh: '前往管辖劳动厅或传真提交',
              vi: 'Đến trực tiếp hoặc gửi fax tới Sở Lao động có thẩm quyền',
            ),
            subtitle: L10nText(
              ko: '등록된 근무지 주소로 관할 관서를 찾아드립니다',
              en: 'We find the office with jurisdiction based on your registered workplace address',
              zh: '根据登记的工作地地址为您查找管辖机构',
              vi: 'Tìm cơ quan có thẩm quyền theo địa chỉ nơi làm việc đã đăng ký',
            ),
          ),
        ]),
      ],
    ),
    FlowStep(
      title: L10nText(
        ko: '여기서부터는 기다리는 시간입니다',
        en: "From here on, it's a waiting period",
        zh: '从这里开始就是等待的时间了',
        vi: 'Từ đây trở đi là thời gian chờ đợi',
      ),
      lead: L10nText(
        ko: '접수 이후 8단계를 여기서 계속 확인할 수 있습니다. 각 단계를 누르면 자세한 안내가 열립니다.',
        en: 'You can keep track of the 8 stages after filing right here. Tap each stage to see detailed guidance.',
        zh: '受理之后的8个阶段可以在这里持续查看。点击每个阶段即可打开详细说明。',
        vi: 'Bạn có thể tiếp tục theo dõi 8 giai đoạn sau khi nộp hồ sơ tại đây. Nhấn vào từng giai đoạn để xem hướng dẫn chi tiết.',
      ),
      blocks: [TrackerBlock(now: 3)],
    ),
  ],
  track: [
    TrackStage(
      label: L10nText(
        ko: '체불액 정리',
        en: 'Organizing the unpaid amount',
        zh: '整理拖欠金额',
        vi: 'Tổng hợp số tiền bị nợ',
      ),
      whatHappens: L10nText(
        ko: '근무기록·통장·계약서를 대조해 미지급 금액과 증거를 모으는 단계',
        en: 'The stage where you cross-check your work log, bank records, and contract to gather the unpaid amount and supporting evidence',
        zh: '对照工作记录、银行账户和合同，汇总未付金额及相关证据的阶段',
        vi: 'Giai đoạn đối chiếu sổ ghi công, sao kê ngân hàng và hợp đồng để tổng hợp số tiền chưa trả và bằng chứng',
      ),
      documentsNeeded: L10nText(
        ko: '근로계약서, 급여 통장 거래내역서, 급여명세서, 출퇴근 기록',
        en: 'Employment contract, bank transaction statement for your pay account, payslips, clock-in/clock-out records',
        zh: '劳动合同、工资账户交易明细单、工资单、上下班记录',
        vi: 'Hợp đồng lao động, sao kê giao dịch tài khoản nhận lương, phiếu lương, hồ sơ giờ đi làm/tan làm',
      ),
      watchOutFor: L10nText(
        ko: '임금채권 소멸시효는 3년입니다. 체불이 생기면 바로 증거를 모으세요.',
        en: 'The statute of limitations for wage claims is 3 years. Start gathering evidence as soon as a delay occurs.',
        zh: '工资债权的消灭时效为3年。一旦发生欠薪，请立即开始收集证据。',
        vi: 'Thời hiệu khiếu nại tiền lương là 3 năm. Hãy thu thập bằng chứng ngay khi bị nợ lương.',
      ),
    ),
    TrackStage(
      label: L10nText(
        ko: '사장님과 대화',
        en: 'Talking with your employer',
        zh: '与老板沟通',
        vi: 'Trao đổi với chủ sử dụng lao động',
      ),
      whatHappens: L10nText(
        ko: '노동청에 알리기 전 체불 내역을 전달해 원만한 해결을 시도하는 단계',
        en: 'The stage where you share the details of unpaid wages before notifying the labor office, to try to resolve it amicably',
        zh: '在通报劳动厅之前，先将拖欠明细告知对方，尝试友好解决的阶段',
        vi: 'Giai đoạn thông báo chi tiết khoản nợ lương trước khi báo lên Sở Lao động, nhằm thử giải quyết êm thấm',
      ),
      documentsNeeded: L10nText(
        ko: '대화 요청문 템플릿, 미지급 급여 산출 내역서',
        en: 'A message-request template, and a statement calculating the unpaid wage amount',
        zh: '沟通请求文模板、未付工资核算明细单',
        vi: 'Mẫu văn bản yêu cầu trao đổi, bảng tính chi tiết khoản lương chưa trả',
      ),
      watchOutFor: L10nText(
        ko: '돈을 실제로 받기 전에는 합의서·취하서에 서명하지 마세요.',
        en: 'Do not sign a settlement or withdrawal form until you have actually received the money.',
        zh: '在实际收到钱款之前，请不要签署和解书或撤诉书。',
        vi: 'Đừng ký biên bản hòa giải hay đơn rút đơn cho đến khi thực sự nhận được tiền.',
      ),
    ),
    TrackStage(
      label: L10nText(
        ko: '진정 접수',
        en: 'Filing the complaint',
        zh: '提交申诉',
        vi: 'Nộp đơn tố cáo',
      ),
      whatHappens: L10nText(
        ko: '관할 지방고용노동청에 체불 사실을 알리고 해결을 공식 요청하는 단계',
        en: 'The stage where you notify the Regional Employment and Labor Office of the wage delay and formally request resolution',
        zh: '向管辖地方雇佣劳动厅通报欠薪事实，并正式请求解决的阶段',
        vi: 'Giai đoạn thông báo việc bị nợ lương cho Sở Lao động và Việc làm khu vực có thẩm quyền và chính thức yêu cầu giải quyết',
      ),
      documentsNeeded: L10nText(
        ko: '임금체불 진정서, 신분증(외국인등록증)',
        en: 'Wage-theft complaint form, ID (Alien Registration Card)',
        zh: '欠薪申诉书、身份证件（外国人登录证）',
        vi: 'Đơn tố cáo nợ lương, giấy tờ tùy thân (Thẻ đăng ký người nước ngoài)',
      ),
      watchOutFor: L10nText(
        ko: '진정은 처벌보다 지급 지도가 목적입니다. 체류자격과 무관하게 접수할 수 있습니다.',
        en: 'The purpose of the complaint is to guide payment, not to punish. You can file it regardless of your visa status.',
        zh: '申诉的目的在于督促支付，而非处罚。无论居留资格如何都可以提交。',
        vi: 'Mục đích của đơn tố cáo là hướng dẫn chi trả chứ không phải xử phạt. Bạn có thể nộp đơn bất kể tư cách lưu trú.',
      ),
    ),
    TrackStage(
      label: L10nText(
        ko: '출석 조사',
        en: 'Attending the investigation',
        zh: '到场接受调查',
        vi: 'Tham gia điều tra',
      ),
      whatHappens: L10nText(
        ko: '담당 근로감독관의 호출에 따라 출석해 조사를 받는 단계',
        en: 'The stage where you attend and are questioned at the call of the assigned labor inspector',
        zh: '根据负责劳动监督官的传唤到场接受调查的阶段',
        vi: 'Giai đoạn có mặt theo triệu tập của thanh tra lao động phụ trách để tiến hành điều tra',
      ),
      documentsNeeded: L10nText(
        ko: '신분증, 제출 증거자료 원본, 출석 통지서',
        en: 'ID, original copies of your evidence, notice of attendance',
        zh: '身份证件、提交证据材料原件、出庭通知书',
        vi: 'Giấy tờ tùy thân, bản gốc tài liệu chứng cứ đã nộp, giấy triệu tập',
      ),
      watchOutFor: L10nText(
        ko: '사업주와 함께 있는 것이 불편하면 분리 조사를 요구할 수 있고, 통역원 동석도 미리 신청할 수 있습니다.',
        en: 'If being in the same room as your employer makes you uncomfortable, you can request a separate interview, and you can also request an interpreter in advance.',
        zh: '如果与雇主同处一室感到不便，可以要求分开调查，也可以提前申请翻译人员陪同。',
        vi: 'Nếu cảm thấy không thoải mái khi ở cùng chủ sử dụng lao động, bạn có thể yêu cầu điều tra riêng, và cũng có thể xin thông dịch viên đi cùng trước.',
      ),
    ),
    TrackStage(
      label: L10nText(
        ko: '체불확인서',
        en: 'Wage-delay confirmation certificate',
        zh: '欠薪确认书',
        vi: 'Giấy xác nhận nợ lương',
      ),
      whatHappens: L10nText(
        ko: '체불 사실이 확정된 뒤 공식 확인서를 발급받는 단계',
        en: 'The stage where you receive an official certificate after the wage delay has been confirmed',
        zh: '在欠薪事实被确认后，领取正式确认书的阶段',
        vi: 'Giai đoạn nhận giấy xác nhận chính thức sau khi việc nợ lương được xác định',
      ),
      documentsNeeded: L10nText(
        ko: '체불임금등·사업주확인서 발급 신청서',
        en: 'Application for issuance of the unpaid wages and employer confirmation certificate',
        zh: '拖欠工资等·雇主确认书核发申请书',
        vi: 'Đơn xin cấp giấy xác nhận tiền lương bị nợ và xác nhận của chủ sử dụng lao động',
      ),
      watchOutFor: L10nText(
        ko: '이 확인서가 있어야 다음 단계인 대지급금이나 민사로 넘어갈 수 있습니다.',
        en: 'You need this certificate to move on to the next stage — the state wage replacement payment (daejigeumgeum) or a civil case.',
        zh: '必须持有此确认书才能进入下一阶段——代支付金申请或民事程序。',
        vi: 'Phải có giấy xác nhận này mới có thể chuyển sang bước tiếp theo — khoản tạm ứng lương của nhà nước (daejigeumgeum) hoặc thủ tục dân sự.',
      ),
    ),
    TrackStage(
      label: L10nText(
        ko: '대지급금 청구',
        en: 'Claiming the state wage replacement payment',
        zh: '申请代支付金',
        vi: 'Yêu cầu khoản tạm ứng lương của nhà nước',
      ),
      whatHappens: L10nText(
        ko: '사업주가 지급하지 못할 때 국가가 먼저 지급하는 제도',
        en: 'A system in which the state pays first when the employer is unable to pay',
        zh: '在雇主无力支付时，由国家先行垫付的制度',
        vi: 'Chế độ nhà nước ứng trả trước khi chủ sử dụng lao động không thể chi trả',
      ),
      documentsNeeded: L10nText(
        ko: '체불확인서 원본, 지급청구서, 본인 명의 통장 사본',
        en: 'Original wage-delay confirmation certificate, payment claim form, copy of a bank passbook in your own name',
        zh: '欠薪确认书原件、给付请求书、本人名义银行账户复印件',
        vi: 'Bản gốc giấy xác nhận nợ lương, đơn yêu cầu chi trả, bản sao sổ tài khoản ngân hàng đứng tên bạn',
      ),
      watchOutFor: L10nText(
        ko: '법원 판결 없이 노동청 확인서만으로 받을 수 있습니다.',
        en: "You can receive this without a court ruling — the labor office's certificate alone is enough.",
        zh: '无需法院判决，仅凭劳动厅确认书即可领取。',
        vi: 'Có thể nhận được chỉ với giấy xác nhận của Sở Lao động, không cần phán quyết của tòa án.',
      ),
    ),
    TrackStage(
      label: L10nText(
        ko: '민사·지급명령',
        en: 'Civil suit / payment order',
        zh: '民事诉讼·支付命令',
        vi: 'Kiện dân sự · lệnh chi trả',
      ),
      whatHappens: L10nText(
        ko: '체불액이 대지급금 한도를 넘을 때 집행권원을 확보하는 단계',
        en: 'The stage where you secure a title of execution when the unpaid amount exceeds the wage replacement payment limit',
        zh: '当拖欠金额超过代支付金上限时，获取执行依据的阶段',
        vi: 'Giai đoạn xin văn bản có hiệu lực cưỡng chế thi hành khi số tiền bị nợ vượt quá giới hạn của khoản tạm ứng lương nhà nước',
      ),
      documentsNeeded: L10nText(
        ko: '체불확인서, 민사소장 또는 지급명령 신청서',
        en: 'Wage-delay confirmation certificate, civil complaint or application for a payment order',
        zh: '欠薪确认书、民事起诉状或支付命令申请书',
        vi: 'Giấy xác nhận nợ lương, đơn khởi kiện dân sự hoặc đơn xin lệnh chi trả',
      ),
      watchOutFor: L10nText(
        ko: '대한법률구조공단에서 무료로 도와줍니다. 소득 요건을 먼저 확인하세요.',
        en: 'The Korea Legal Aid Corporation can help you free of charge. Check the income eligibility requirement first.',
        zh: '大韩法律救助公团可提供免费帮助，请先确认收入条件是否符合。',
        vi: 'Tổng công ty Hỗ trợ pháp lý Hàn Quốc sẽ hỗ trợ miễn phí. Hãy kiểm tra điều kiện thu nhập trước.',
      ),
    ),
    TrackStage(
      label: L10nText(
        ko: '집행·이직',
        en: 'Enforcement / changing jobs',
        zh: '执行·转职',
        vi: 'Cưỡng chế thi hành · chuyển việc',
      ),
      whatHappens: L10nText(
        ko: '사업주 재산에 대한 집행과, 체불로 인한 사업장 변경 처리 단계',
        en: "The stage covering enforcement against the employer's assets and processing a workplace change due to the wage delay",
        zh: '针对雇主财产的强制执行，以及因欠薪而办理更换工作单位的阶段',
        vi: 'Giai đoạn cưỡng chế thi hành đối với tài sản của chủ sử dụng lao động và xử lý chuyển nơi làm việc do bị nợ lương',
      ),
      documentsNeeded: L10nText(
        ko: '확정 판결문·지급명령 결정문, 사업장 변경 신청서',
        en: 'Final judgment or payment order decision, workplace change application',
        zh: '确定判决书·支付命令决定书、工作单位变更申请书',
        vi: 'Bản án có hiệu lực · quyết định lệnh chi trả, đơn xin chuyển nơi làm việc',
      ),
      watchOutFor: L10nText(
        ko: '체불이 증명되면 사업장 변경 횟수에서 차감되지 않습니다.',
        en: 'If the wage delay is proven, it will not be counted against your workplace-change limit.',
        zh: '如果欠薪事实得到证明，将不会计入更换工作单位的次数限制。',
        vi: 'Nếu chứng minh được việc bị nợ lương, sẽ không bị trừ vào số lần được phép chuyển nơi làm việc.',
      ),
    ),
  ],
);
