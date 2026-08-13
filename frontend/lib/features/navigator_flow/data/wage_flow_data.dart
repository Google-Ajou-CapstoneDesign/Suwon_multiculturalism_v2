import '../../../core/app_language.dart';
import '../models/flow_block.dart';
import 'wage_fields.dart';

const _documentTitle = L10nText(
  ko: '임금체불 진정서',
  en: 'Unpaid Wage Complaint',
  zh: '欠薪申诉书',
  vi: 'Đơn khiếu nại nợ lương',
);

/// 임금체불 진정 내비게이터 — 6단계 + 접수 이후 8단계 트래커.
/// html_files/임금체불네비게이터.html의 FLOWS.wage를 이 앱의 실제 데이터 상황에
/// 맞게 옮겼다(재태깅 원칙은 wage_fields.dart 주석 참고).
const wageFlowDefinition = FlowDefinition(
  accent: FlowAccent.amber,
  steps: [
    FlowStep(
      title: L10nText(
        ko: '어떤 방식으로 임금이 밀리셨나요?',
        en: 'How did your pay fall short?',
        zh: '您的工资是以何种方式被拖欠的？',
        vi: 'Lương của bạn bị thiếu theo cách nào?',
      ),
      lead: L10nText(
        ko: '상황을 선택하시면 다음 단계에서 맞춤형 계산과 설명을 도와드립니다. 정해진 선택지로만 나누어, AI가 임의로 법적 판단을 내리지 않도록 설계했습니다.',
        en: 'Choose your situation and the next step tailors the calculation and guidance to it. We use fixed options only, by design, so the AI never makes its own legal judgement.',
        zh: '选择您的情况，下一步会据此提供定制计算与说明。特意仅使用固定选项，以避免AI自行做出法律判断。',
        vi: 'Chọn tình huống của bạn để bước sau tính toán và hướng dẫn phù hợp. Chỉ dùng lựa chọn cố định, để AI không tự phán đoán pháp lý.',
      ),
      blocks: [
        OptionsBlock([
          FlowOption(
            emoji: '💰',
            title: L10nText(
              ko: '급여 전체를 아예 못 받았어요',
              en: 'I received no pay at all',
              zh: '完全没收到工资',
              vi: 'Tôi hoàn toàn chưa nhận lương',
            ),
            subtitle: L10nText(
              ko: '기본 월급 · 일당 · 시급이 전체 미지급',
              en: 'Base monthly, daily or hourly pay is entirely unpaid',
              zh: '基本月薪·日薪·时薪全额未付',
              vi: 'Lương tháng, lương ngày hoặc lương giờ hoàn toàn chưa trả',
            ),
          ),
          FlowOption(
            emoji: '⏱️',
            title: L10nText(
              ko: '주휴수당이나 야근·연장 수당이 안 들어왔어요',
              en: 'Weekly-rest pay or overtime/night pay is missing',
              zh: '周休津贴或加班·夜班津贴未到账',
              vi: 'Chưa nhận phụ cấp ngày nghỉ hoặc phụ cấp làm thêm/đêm',
            ),
            subtitle: L10nText(
              ko: '기본급은 들어왔으나 법정 수당이 누락됨',
              en: 'Base pay arrived, but statutory allowances are missing',
              zh: '基本工资已到账，但法定津贴缺失',
              vi: 'Lương cơ bản đã có nhưng thiếu phụ cấp luật định',
            ),
          ),
          FlowOption(
            emoji: '📅',
            title: L10nText(
              ko: '퇴직금을 못 받았어요',
              en: 'I did not receive severance pay',
              zh: '没有收到退职金',
              vi: 'Tôi chưa nhận trợ cấp thôi việc',
            ),
            subtitle: L10nText(
              ko: '1년 이상 근무 후 퇴사했는데 미지급',
              en: 'Worked over a year, resigned, and it was not paid',
              zh: '工作满1年以上离职后未获支付',
              vi: 'Đã làm trên 1 năm và nghỉ việc nhưng chưa được trả',
            ),
          ),
          FlowOption(
            emoji: '📄',
            title: L10nText(
              ko: '약속한 금액보다 적게 들어왔어요',
              en: 'I received less than agreed',
              zh: '实收金额少于约定',
              vi: 'Tôi nhận ít hơn số đã thỏa thuận',
            ),
            subtitle: L10nText(
              ko: '계약서와 통장 입금액 차이 · 세금·기숙사비 부당 공제',
              en: 'Gap between the contract and the deposit, or unfair tax/lodging deductions',
              zh: '合同与实际入账有差异，或税金·食宿费被不当扣除',
              vi: 'Chênh lệch giữa hợp đồng và tiền vào tài khoản, hoặc bị trừ thuế/ăn ở bất hợp lý',
            ),
          ),
        ]),
      ],
    ),
    FlowStep(
      title: L10nText(
        ko: '체불액을 확인하고 방법을 고르세요',
        en: 'Check the amount and choose how to proceed',
        zh: '确认欠薪额并选择处理方式',
        vi: 'Kiểm tra số tiền và chọn cách xử lý',
      ),
      lead: L10nText(
        ko: '임금계산기로 예상 체불액을 먼저 확인하세요. 이 금액은 참고용 추정치이며, 진정서로 자동으로 넘어가지 않습니다.',
        en: 'Check the estimated amount with the wage calculator first. This figure is a reference estimate and is not carried into the complaint form automatically.',
        zh: '请先用工资计算器确认预估欠薪额。此金额仅供参考，不会自动带入申诉书。',
        vi: 'Trước tiên hãy kiểm tra số tiền ước tính bằng máy tính lương. Đây là số tham khảo và không tự chuyển sang đơn khiếu nại.',
      ),
      blocks: [WageCalcBlock()],
    ),
    FlowStep(
      title: L10nText(
        ko: '진정서 항목을 채워주세요',
        en: 'Fill in the complaint form fields',
        zh: '请填写申诉书各项内容',
        vi: 'Điền các mục trong đơn khiếu nại',
      ),
      lead: L10nText(
        ko: '위 버튼으로 이미 모아둔 데이터를 불러오거나, 빈칸을 직접 입력하세요. 적으신 내용은 고치지 않고 그대로 서류에 들어갑니다.',
        en: 'Import data you already have with the buttons below, or fill in the blanks yourself. What you enter goes into the document exactly as written.',
        zh: '可用下方按钮导入已有数据，或自行填写空白项。您填写的内容将原封不动地写入文件。',
        vi: 'Dùng các nút bên dưới để lấy dữ liệu đã có, hoặc tự điền vào ô trống. Nội dung bạn nhập sẽ vào văn bản nguyên văn.',
      ),
      blocks: [
        ImportButtonsBlock([
          ImportSource.workLog,
          ImportSource.payslip,
          ImportSource.calcResult,
        ]),
        LegendBlock(),
        FormEditBlock(wageFields),
      ],
    ),
    FlowStep(
      title: L10nText(
        ko: '진정서를 확인하고 다운로드하세요',
        en: 'Review and download the complaint form',
        zh: '请核对并下载申诉书',
        vi: 'Xem lại và tải đơn khiếu nại',
      ),
      lead: L10nText(
        ko: '앞에서 적은 내용이 실제 진정서 서식에 이렇게 들어갑니다. 한국어와 본인 언어, 두 가지 PDF로 받을 수 있습니다.',
        en: 'What you wrote is placed into the actual complaint form like this. You can download it as a PDF in Korean and in your own language.',
        zh: '您填写的内容将这样填入实际申诉书格式，可下载韩语版与您的语言版两份PDF。',
        vi: 'Nội dung bạn đã viết được đưa vào mẫu đơn thật như sau. Bạn có thể tải PDF bằng tiếng Hàn và ngôn ngữ của mình.',
      ),
      blocks: [
        LegendBlock(),
        FormReviewBlock(wageFields),
        NoticeBlock(
          tone: NoticeTone.blue,
          title: L10nText(
            ko: '금액은 왜 직접 적나요?',
            en: 'Why do I enter the amount myself?',
            zh: '为什么金额需要自行填写？',
            vi: 'Vì sao tôi phải tự nhập số tiền?',
          ),
          body: L10nText(
            ko: '체불 확정 금액은 근로감독관 조사에서 산정됩니다. 임금계산기 결과를 참고해 본인이 직접 적도록 했고, 계산기 값이 자동으로 넘어오지 않습니다.',
            en: "The confirmed amount is determined during the labor inspector's investigation. You enter it yourself after checking the calculator, and the calculator result is not carried over automatically.",
            zh: '确定金额由劳动监督官调查核定。请参考计算器结果后自行填写，计算器数值不会自动带入。',
            vi: 'Số tiền chính thức do thanh tra lao động xác định. Bạn tự nhập sau khi tham khảo máy tính lương, kết quả không tự động chuyển sang.',
          ),
        ),
        PdfActionsBlock(wageFields, documentTitle: _documentTitle),
      ],
    ),
    FlowStep(
      title: L10nText(
        ko: '제출 방법을 선택하세요',
        en: 'Choose how to submit',
        zh: '请选择提交方式',
        vi: 'Chọn cách nộp đơn',
      ),
      lead: L10nText(
        ko: 'Local Bridge는 서류를 대신 제출하지 않습니다. 아래 네 가지 중에서 고르세요.',
        en: 'Local Bridge does not submit the document on your behalf. Choose one of the four options below.',
        zh: 'Local Bridge 不会代为提交材料，请从以下四种方式中选择。',
        vi: 'Local Bridge không nộp hồ sơ thay bạn. Hãy chọn một trong bốn cách dưới đây.',
      ),
      blocks: [
        AccordionBlock([
          AccordionItemData(
            icon: '💻',
            title: L10nText(
              ko: '노동포털 온라인 접수',
              en: 'File online at the labor portal',
              zh: '劳动门户在线受理',
              vi: 'Nộp trực tuyến trên cổng lao động',
            ),
            subtitle: L10nText(
              ko: '고용노동부 민원마당에서 바로 접수',
              en: "File directly at the Ministry's civil affairs portal",
              zh: '可直接在雇佣劳动部民愿广场受理',
              vi: 'Nộp trực tiếp tại cổng dân nguyện của Bộ',
            ),
            body: [
              ListBlock([
                L10nText(
                  ko: '고용노동부 민원마당(minwon.moel.go.kr)에 접속해 공동인증서나 간편인증으로 로그인합니다.',
                  en: "Go to the Ministry's civil affairs portal (minwon.moel.go.kr) and log in with a certificate or simple authentication.",
                  zh: '登录雇佣劳动部民愿广场（minwon.moel.go.kr），用认证书或简便认证登录。',
                  vi: 'Vào cổng dân nguyện Bộ Lao động (minwon.moel.go.kr) và đăng nhập bằng chứng thư hoặc xác thực đơn giản.',
                ),
                L10nText(
                  ko: "민원신청 → 서식민원에서 '임금체불 진정서'를 검색해 선택합니다.",
                  en: "Go to Apply for civil affairs → Form-based civil affairs, and search 'Unpaid wage complaint'.",
                  zh: '进入民愿申请→表格民愿，搜索"欠薪申诉书"。',
                  vi: "Vào Nộp dân nguyện → Dân nguyện mẫu, tìm 'Đơn khiếu nại nợ lương'.",
                ),
                L10nText(
                  ko: 'Step 4에서 확인한 내용을 그대로 옮겨 입력하고, 증빙 파일을 첨부한 뒤 제출합니다.',
                  en: 'Copy in what you confirmed in Step 4, attach your evidence files, and submit.',
                  zh: '将第4步确认的内容原样填入，附上证据文件后提交。',
                  vi: 'Chép nội dung đã xác nhận ở Bước 4, đính kèm tệp chứng cứ rồi nộp.',
                ),
              ]),
            ],
          ),
          AccordionItemData(
            icon: '🏛️',
            title: L10nText(
              ko: '관할 노동청 방문 · 팩스',
              en: 'Visit or fax your local labor office',
              zh: '前往管辖劳动厅·传真',
              vi: 'Đến hoặc fax cơ quan lao động phụ trách',
            ),
            subtitle: L10nText(
              ko: '등록된 근무지 주소로 관할 관서를 찾아드립니다',
              en: 'Matched to your registered workplace address',
              zh: '根据已登记的工作地址匹配',
              vi: 'Tìm theo địa chỉ nơi làm việc đã đăng ký',
            ),
            body: [
              OrgCardBlock(
                name: L10nText(
                  ko: '고용노동부 고객상담센터',
                  en: 'Ministry of Employment and Labor Contact Center',
                  zh: '雇佣劳动部客户咨询中心',
                  vi: 'Trung tâm tư vấn Bộ Việc làm và Lao động',
                ),
                subtitle: L10nText(
                  ko: '관할 지방고용노동청 안내 및 상담을 받을 수 있습니다',
                  en: 'Can guide you to the regional labor office with jurisdiction and take questions',
                  zh: '可为您指引管辖地方雇佣劳动厅并提供咨询',
                  vi: 'Có thể hướng dẫn Sở Lao động khu vực có thẩm quyền và tư vấn',
                ),
                phone: '1350',
              ),
              NoticeBlock(
                tone: NoticeTone.amber,
                title: L10nText(
                  ko: '실제 관할은 접수 전 전화로 한 번 더 확인하세요',
                  en: 'Confirm the actual jurisdiction by phone once more before filing',
                  zh: '提交前请再次致电确认实际管辖',
                  vi: 'Hãy gọi điện xác nhận lại thẩm quyền trước khi nộp',
                ),
                body: L10nText(
                  ko: '팩스로 낼 때는 진정서 원본과 증빙 사본을 함께 보내고, 전화로 수신 확인을 요청하세요.',
                  en: 'When faxing, send the original complaint with copies of your evidence, and call to confirm receipt.',
                  zh: '传真提交时请连同申诉书原件与证据复印件一并发送，并致电确认已收到。',
                  vi: 'Khi gửi fax, gửi kèm bản gốc đơn và bản sao chứng cứ, rồi gọi điện xác nhận đã nhận.',
                ),
              ),
            ],
          ),
          AccordionItemData(
            icon: '🤝',
            title: L10nText(
              ko: '기관 · 노무사 · 변호사 연결',
              en: 'Connect with an agency, labor attorney or lawyer',
              zh: '对接机构·劳务士·律师',
              vi: 'Kết nối cơ quan · luật sư lao động · luật sư',
            ),
            subtitle: L10nText(
              ko: '무료로 도와줄 수 있는 곳을 안내합니다',
              en: 'Places that can help, often free',
              zh: '可提供帮助的机构，多为免费',
              vi: 'Nơi có thể được hỗ trợ, thường miễn phí',
            ),
            body: [
              OrgCardBlock(
                name: L10nText(
                  ko: '대한법률구조공단',
                  en: 'Korea Legal Aid Corporation',
                  zh: '大韩法律救助公团',
                  vi: 'Tổng công ty Hỗ trợ pháp lý Hàn Quốc',
                ),
                subtitle: L10nText(
                  ko: '소득 요건에 맞으면 상담과 소송을 무료로 도와줍니다',
                  en: 'If you meet the income requirement, offers free counselling and litigation help',
                  zh: '若符合收入条件，可提供免费咨询与诉讼协助',
                  vi: 'Nếu đủ điều kiện thu nhập sẽ hỗ trợ tư vấn và kiện tụng miễn phí',
                ),
                phone: '132',
              ),
              NoticeBlock(
                tone: NoticeTone.blue,
                title: L10nText(
                  ko: '마을노무사 제도도 있습니다',
                  en: "There is also a 'village labor attorney' scheme",
                  zh: '还有"村庄劳务士"制度',
                  vi: "Cũng có chương trình 'luật sư lao động cộng đồng'",
                ),
                body: L10nText(
                  ko: '서류를 무료로 봐주는 제도입니다. 관할 고용센터나 지자체에 배치 여부를 문의해 보세요.',
                  en: 'A scheme that reviews your documents for free. Ask your local employment center or municipality if one is assigned.',
                  zh: '免费审阅材料的制度，可向当地就业中心或地方政府咨询是否有配置。',
                  vi: 'Chương trình xem giấy tờ miễn phí. Hãy hỏi trung tâm việc làm hoặc chính quyền địa phương.',
                ),
              ),
            ],
          ),
          AccordionItemData(
            icon: '💡',
            title: L10nText(
              ko: '혼자 해결하기',
              en: 'Handle it yourself',
              zh: '自己解决',
              vi: 'Tự giải quyết',
            ),
            subtitle: L10nText(
              ko: '접수 없이 사업주와 직접 정리하는 방법',
              en: 'Settling directly with your employer, without filing',
              zh: '无需受理，直接与雇主解决的方法',
              vi: 'Cách tự giải quyết với chủ mà không nộp đơn',
            ),
            body: [
              ListBlock(numbered: false, [
                L10nText(
                  ko: "접수 전에 내용증명(우체국)을 보내면 '언제까지 요청했다'는 공식 기록이 남습니다.",
                  en: 'Sending a certified letter through the post office before filing leaves an official record of your request.',
                  zh: '申诉前通过邮局寄送内容证明，可留下正式的请求记录。',
                  vi: 'Gửi thư bảo đảm nội dung qua bưu điện trước khi nộp sẽ để lại hồ sơ chính thức.',
                ),
                L10nText(
                  ko: '사업주가 답하지 않거나 거부하면, 그때 온라인·방문 접수로 넘어가면 됩니다.',
                  en: 'If the employer does not respond or refuses, move on to filing online or in person.',
                  zh: '若雇主不回应或拒绝，可转为在线或到访提交。',
                  vi: 'Nếu chủ không phản hồi hoặc từ chối, hãy chuyển sang nộp trực tuyến hoặc trực tiếp.',
                ),
                L10nText(
                  ko: '조사에 출석하게 되면 사실관계(날짜·금액)를 메모해 가고, 사업주 주장에 즉흥적으로 대응하지 말고 사실로만 답하세요.',
                  en: 'If called in for the inspector\'s meeting, bring notes of the facts and answer with facts only.',
                  zh: '若需出席调查，请带上事实记录，只陈述事实。',
                  vi: 'Khi đến buổi điều tra, mang theo ghi chú sự việc và chỉ trả lời bằng sự thật.',
                ),
              ]),
            ],
          ),
        ]),
      ],
    ),
    FlowStep(
      title: L10nText(
        ko: '여기서부터는 기다리는 시간입니다',
        en: "From here, it's a waiting game",
        zh: '从这里开始是等待期',
        vi: 'Từ đây là thời gian chờ',
      ),
      lead: L10nText(
        ko: '접수 이후 8단계를 여기서 계속 확인할 수 있습니다. 단계를 누르면 안내가 열리고, 안내 안에서 완료로 표시할 수 있습니다.',
        en: 'Track all eight stages here after filing. Tap a stage to open the guide, and mark it complete from inside the guide.',
        zh: '提交后可在此追踪全部8个阶段。点击某阶段可打开说明，并可在说明内标记为完成。',
        vi: 'Theo dõi cả 8 giai đoạn tại đây sau khi nộp đơn. Nhấn vào giai đoạn để mở hướng dẫn, và đánh dấu hoàn thành trong đó.',
      ),
      blocks: [
        TrackerBlock(now: 3),
        EncyclopediaLinkBlock(
          categoryId: 10,
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
        ko: '체불액 정리',
        en: 'Organizing the unpaid amount',
        zh: '整理拖欠金额',
        vi: 'Tổng hợp số tiền bị nợ',
      ),
      whatHappens: L10nText(
        ko: '근무기록·통장·계약서를 대조해 미지급 금액과 증거를 모으는 단계. 기본급뿐 아니라 주휴수당·연장수당·연차수당·퇴직금까지 빠짐없이 세는 것이 핵심입니다.',
        en: 'Compare your work log, bank statement and contract to gather the amount and the evidence. The key is to count not only base pay but weekly holiday, overtime, annual leave allowance and severance.',
        zh: '比对工作记录、银行账户和合同，汇总未付金额及相关证据。关键是不仅算基本工资，还要算全周休津贴·延长津贴·年假津贴·退职金。',
        vi: 'Đối chiếu nhật ký, sao kê và hợp đồng để tập hợp số tiền và chứng cứ. Điều quan trọng là tính cả phụ cấp ngày nghỉ, làm thêm, phép năm và trợ cấp thôi việc.',
      ),
      documentsNeeded: L10nText(
        ko: '근로계약서, 급여 통장 거래내역서, 급여명세서, 출퇴근 기록',
        en: 'Employment contract, bank transaction statement for your pay account, payslips, clock-in/clock-out records',
        zh: '劳动合同、工资账户交易明细单、工资单、上下班记录',
        vi: 'Hợp đồng lao động, sao kê giao dịch tài khoản nhận lương, phiếu lương, hồ sơ giờ đi làm/tan làm',
      ),
      watchOutFor: L10nText(
        ko: '임금채권 소멸시효는 3년입니다. 통장 내역은 화면 캡처보다 은행에서 발급한 거래내역서로 준비하세요.',
        en: 'Wage claims expire after three years. Get an official bank statement rather than a screenshot.',
        zh: '工资债权时效为3年。存折明细请用银行出具的交易明细书而非截图。',
        vi: 'Quyền đòi lương hết hiệu lực sau 3 năm. Hãy lấy sao kê chính thức thay vì ảnh chụp màn hình.',
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
        ko: '노동청에 알리기 전 체불 내역을 전달해 원만한 해결을 시도하는 단계. 단순 체불은 이 단계에서 끝나는 경우가 많습니다.',
        en: 'Send the breakdown to your employer and try to settle before filing. Simple cases often end here.',
        zh: '在通报劳动厅之前把明细交给雇主，尝试和解。单纯欠薪多在此阶段解决。',
        vi: 'Gửi bảng kê cho chủ và thử giải quyết trước khi khiếu nại. Trường hợp đơn giản thường kết thúc ở đây.',
      ),
      documentsNeeded: L10nText(
        ko: '대화 요청문 템플릿, 미지급 급여 산출 내역서',
        en: 'A message-request template, and a statement calculating the unpaid wage amount',
        zh: '沟通请求文模板、未付工资核算明细单',
        vi: 'Mẫu văn bản yêu cầu trao đổi, bảng tính chi tiết khoản lương chưa trả',
      ),
      watchOutFor: L10nText(
        ko: "돈이 실제로 입금되기 전에는 합의서·취하서에 서명하지 마세요. 합의서를 쓴다면 지급 기일과 '세후 실지급액' 기준 금액을 반드시 적으세요.",
        en: 'Do not sign a settlement or withdrawal before the money actually arrives. If you do write one, state the payment date and the amount as take-home after tax.',
        zh: '实际收到钱之前不要在和解书·撤诉书上签字。若写和解书，务必写明支付日期与"税后实付额"。',
        vi: 'Đừng ký thỏa thuận hay đơn rút trước khi thực nhận tiền. Nếu viết, hãy ghi rõ ngày trả và số tiền thực nhận sau thuế.',
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
        ko: '사업주가 지급하지 못할 때 국가가 먼저 지급하는 제도. 확정 판결 없이 노동청 확인서만으로 받을 수 있습니다.',
        en: 'A system in which the state pays first when the employer is unable to pay. You can receive this without a court ruling — the labor office\'s certificate alone is enough.',
        zh: '在雇主无力支付时，由国家先行垫付的制度。无需法院判决，仅凭劳动厅确认书即可领取。',
        vi: 'Chế độ nhà nước ứng trả trước khi chủ sử dụng lao động không thể chi trả. Có thể nhận được chỉ với giấy xác nhận của Sở Lao động, không cần phán quyết của tòa án.',
      ),
      documentsNeeded: L10nText(
        ko: '체불확인서 원본, 지급청구서, 본인 명의 통장 사본',
        en: 'Original wage-delay confirmation certificate, payment claim form, copy of a bank passbook in your own name',
        zh: '欠薪确认书原件、给付请求书、本人名义银行账户复印件',
        vi: 'Bản gốc giấy xác nhận nợ lương, đơn yêu cầu chi trả, bản sao sổ tài khoản ngân hàng đứng tên bạn',
      ),
      watchOutFor: L10nText(
        ko: '임금·퇴직금 합산 지급 한도가 있습니다(간이대지급금 기준 최대 1,000만원 수준). 한도를 넘는 금액은 민사로 별도 청구해야 합니다.',
        en: 'There is a combined cap on wages and severance paid this way (up to about 10 million won under the simplified scheme). Amounts above the cap must be claimed separately through a civil case.',
        zh: '工资与退职金合计给付有上限（简易代支付金标准最高约1000万韩元）。超出部分须另行提起民事诉讼。',
        vi: 'Có giới hạn tổng số tiền lương và trợ cấp thôi việc được chi trả (tối đa khoảng 10 triệu won theo chế độ tạm ứng đơn giản). Phần vượt giới hạn phải khởi kiện dân sự riêng.',
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
