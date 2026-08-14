import '../../../core/app_language.dart';
import '../models/flow_block.dart';
import 'wage_fields.dart';

const _documentTitle = L10nText(
  ko: '임금체불 진정서',
  en: 'Unpaid Wage Complaint',
  zh: '欠薪申诉书',
  vi: 'Đơn khiếu nại nợ lương',
);
// html_files 원본은 이 줄을 언어와 무관하게 항상 한국어 그대로 둔다(실제 정부
// 서식 명칭이라 번역하지 않음) — 여기서도 동일하게 4개 언어 모두 같은 문자열이다.
const _documentSubtitle = L10nText(
  ko: '고용노동부 · 진정서 (노동포털 접수 서식)',
  en: '고용노동부 · 진정서 (노동포털 접수 서식)',
  zh: '고용노동부 · 진정서 (노동포털 접수 서식)',
  vi: '고용노동부 · 진정서 (노동포털 접수 서식)',
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
        FormEditBlock(
          wageFields,
          documentTitle: _documentTitle,
          formSubtitle: _documentSubtitle,
        ),
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
        FormReviewBlock(
          wageFields,
          documentTitle: _documentTitle,
          formSubtitle: _documentSubtitle,
        ),
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
        NoticeBlock(
          tone: NoticeTone.blue,
          title: L10nText(
            ko: '왜 대신 접수하지 않나요?',
            en: "Why doesn't it file for me?",
            zh: '为什么不能代为受理？',
            vi: 'Vì sao không nộp thay?',
          ),
          body: L10nText(
            ko: '공인노무사법 제2조에 따라 서류 제출은 근로자 본인이 직접 해야 합니다. Local Bridge는 서식을 채워 보여드리는 것까지만 합니다.',
            en: 'Under the Certified Public Labor Attorney Act Article 2, the worker must submit the documents in person. Local Bridge only fills in and displays the form.',
            zh: '根据《公认劳务士法》第2条，材料须由劳动者本人提交。Local Bridge 仅负责填写并展示表格。',
            vi: 'Theo Điều 2 Luật Luật sư lao động, người lao động phải tự nộp hồ sơ. Local Bridge chỉ điền và hiển thị biểu mẫu.',
          ),
        ),
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
                  ko: '고용노동부 수원고용복지＋센터',
                  en: 'Suwon Employment and Welfare Plus Center',
                  zh: '雇佣劳动部 水原雇佣福利＋中心',
                  vi: 'Trung tâm việc làm & phúc lợi Suwon',
                ),
                subtitle: L10nText(
                  ko: '임금체불 진정서를 실제로 접수하는 곳입니다. 통역 서비스를 미리 신청할 수 있고, 사업주와 분리 조사도 요청할 수 있습니다.',
                  en: 'This is where you actually file the unpaid-wage complaint. You can request interpreting in advance, and ask to be questioned separately from your employer.',
                  zh: '这是实际受理欠薪申诉书的地方。可事先申请翻译服务，也可要求与雇主分开调查。',
                  vi: 'Đây là nơi thực sự nộp đơn khiếu nại nợ lương. Có thể đăng ký phiên dịch trước và yêu cầu điều tra riêng với chủ.',
                ),
                phone: '1350',
                legalBasis: L10nText(
                  ko: '등록하신 근무지 주소를 기준으로 찾은 관할 기관입니다. 실제 관할은 접수 전 전화로 한 번 더 확인하는 것이 안전합니다.',
                  en: 'Based on your registered workplace address, this is the responsible office. Confirm by phone once more before filing, to be safe.',
                  zh: '根据您登记的工作地址，这是对应的管辖机关。提交前建议再电话确认一次管辖范围。',
                  vi: 'Dựa trên địa chỉ nơi làm việc đã đăng ký, đây là cơ quan phụ trách. Nên gọi điện xác nhận lại trước khi nộp.',
                ),
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
                  ko: '대한법률구조공단 수원지부',
                  en: 'Korea Legal Aid Corporation, Suwon',
                  zh: '大韩法律救助公团 水原支部',
                  vi: 'Trung tâm Trợ giúp pháp lý Hàn Quốc, Suwon',
                ),
                subtitle: L10nText(
                  ko: '월 평균임금이 일정 기준 미만이면 민사소송과 강제집행을 무료로 도와줍니다. 소득 요건을 먼저 확인하세요.',
                  en: 'If your average monthly wage is below a set threshold, they handle civil suits and enforcement for free. Check the income requirement first.',
                  zh: '若月平均工资低于一定标准，可免费协助民事诉讼与强制执行。请先确认收入条件。',
                  vi: 'Nếu lương bình quân tháng dưới ngưỡng quy định, họ hỗ trợ kiện dân sự và thi hành án miễn phí. Hãy kiểm tra điều kiện thu nhập trước.',
                ),
                phone: '132',
                legalBasis: L10nText(
                  ko: '소득 요건에 맞으면 아래 기관에서 상담과 소송을 무료로 도와줍니다. 노무사·변호사를 개인적으로 선임할 수도 있습니다.',
                  en: 'If you meet the income requirement, the agency below offers free counselling and litigation help. You may also hire a labor attorney or lawyer privately.',
                  zh: '若符合收入条件，以下机构可提供免费咨询与诉讼协助，您也可自行聘请劳务士·律师。',
                  vi: 'Nếu đủ điều kiện thu nhập, cơ quan dưới đây hỗ trợ tư vấn và kiện tụng miễn phí. Bạn cũng có thể tự thuê luật sư.',
                ),
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
        en: 'Tally & evidence',
        zh: '整理欠薪额',
        vi: 'Tổng hợp & chứng cứ',
      ),
      whatHappens: L10nText(
        ko: '근무기록·통장 거래내역·근로계약서를 대조해 미지급 금액과 증거를 모으는 단계입니다. 기본급뿐 아니라 주휴수당·연장수당·연차수당·퇴직금까지 빠짐없이 세는 것이 핵심입니다.',
        en: 'Compare your work log, bank statement and contract to gather the amount and the evidence. The key is to count not only base pay but weekly holiday, overtime, annual leave allowance and severance.',
        zh: '比对工作记录·存折交易明细·劳动合同，收集未付金额与证据。关键是不仅算基本工资，还要算全周休津贴·延长津贴·年假津贴·退职金。',
        vi: 'Đối chiếu nhật ký, sao kê và hợp đồng để tập hợp số tiền và chứng cứ. Điều quan trọng là tính cả phụ cấp ngày nghỉ, làm thêm, phép năm và trợ cấp thôi việc.',
      ),
      documentsNeeded: L10nText(
        ko: '근로계약서 / 급여 통장 거래내역서 / 임금명세서 / 출퇴근 기록',
        en: 'Contract / bank statement / payslips / work log',
        zh: '劳动合同／工资存折交易明细／工资单／出勤记录',
        vi: 'Hợp đồng / sao kê ngân hàng / phiếu lương / nhật ký làm việc',
      ),
      watchOutFor: L10nText(
        ko: '임금채권 소멸시효는 3년입니다. 통장 내역은 화면 캡처보다 은행에서 발급한 거래내역서로 준비하세요. 대화 기록은 필요한 부분만 자르지 말고 앞뒤를 통째로 보관해야 흐름이 왜곡되지 않습니다.',
        en: 'Wage claims expire after three years. Get an official bank statement rather than a screenshot. Keep whole chat threads, not clipped fragments, so the context is not distorted.',
        zh: '工资债权时效为3年。存折明细请用银行出具的交易明细书而非截图。对话记录不要只截取片段，应完整保存前后文以免语境失真。',
        vi: 'Quyền đòi lương hết hiệu lực sau 3 năm. Hãy lấy sao kê chính thức thay vì ảnh chụp màn hình. Lưu toàn bộ đoạn hội thoại, không cắt xén, để không bóp méo ngữ cảnh.',
      ),
    ),
    TrackStage(
      label: L10nText(
        ko: '사장님과 대화',
        en: 'Talk with employer',
        zh: '与雇主沟通',
        vi: 'Nói chuyện với chủ',
      ),
      whatHappens: L10nText(
        ko: '노동청에 알리기 전 체불 내역을 전달해 원만한 해결을 시도하는 단계입니다. 단순 체불은 이 단계에서 끝나는 경우가 많습니다.',
        en: 'Send the breakdown to your employer and try to settle before filing. Simple cases often end here.',
        zh: '在通报劳动厅之前把明细交给雇主，尝试和解。单纯欠薪多在此阶段解决。',
        vi: 'Gửi bảng kê cho chủ và thử giải quyết trước khi khiếu nại. Trường hợp đơn giản thường kết thúc ở đây.',
      ),
      documentsNeeded: L10nText(
        ko: '대화 요청문 템플릿 / 미지급 급여 산출 내역서',
        en: 'Message template / breakdown of unpaid wages',
        zh: '沟通请求模板／未付工资计算明细',
        vi: 'Mẫu tin nhắn / bảng kê lương chưa trả',
      ),
      watchOutFor: L10nText(
        ko: "돈이 실제로 입금되기 전에는 합의서·취하서에 서명하지 마세요. 합의서를 쓴다면 지급 기일과 '세후 실지급액' 기준 금액을 반드시 적고, '언제까지 얼마가 입금되면 취하서를 낸다'는 순서로 정하는 것이 가장 안전합니다.",
        en: 'Do not sign a settlement or withdrawal before the money actually arrives. If you do write one, state the payment date and the amount as take-home after tax, and order it as: withdrawal will be filed once the money is received.',
        zh: '实际收到钱之前不要在和解书·撤诉书上签字。若写和解书，务必写明支付日期与"税后实付额"，并按"何时入账多少后再提交撤诉书"的顺序约定最为安全。',
        vi: 'Đừng ký thỏa thuận hay đơn rút trước khi thực nhận tiền. Nếu viết, hãy ghi rõ ngày trả và số tiền thực nhận sau thuế, theo thứ tự: nhận đủ tiền rồi mới nộp đơn rút.',
      ),
    ),
    TrackStage(
      label: L10nText(
        ko: '진정 접수',
        en: 'File complaint',
        zh: '申诉受理',
        vi: 'Nộp khiếu nại',
      ),
      whatHappens: L10nText(
        ko: '관할 지방고용노동청에 체불 사실을 알리고 해결을 공식 요청하는 단계입니다. 노동포털 온라인, 방문, 우편, 팩스 모두 가능합니다.',
        en: 'Formally notify your regional labor office and request resolution. You can file online, in person, by post or by fax.',
        zh: '向管辖地方雇佣劳动厅正式告知并请求解决。可在线·到访·邮寄·传真受理。',
        vi: 'Chính thức báo cho cơ quan lao động khu vực và yêu cầu giải quyết. Có thể nộp trực tuyến, trực tiếp, qua bưu điện hoặc fax.',
      ),
      documentsNeeded: L10nText(
        ko: '임금체불 진정서 / 신분증(외국인등록증)',
        en: 'Complaint form / ID (ARC)',
        zh: '欠薪申诉书／身份证（外国人登录证）',
        vi: 'Đơn khiếu nại / giấy tờ tùy thân (ARC)',
      ),
      watchOutFor: L10nText(
        ko: '진정은 처벌보다 지급 지도가 목적입니다. 접수 후 대개 일주일 안에 근로감독관이 배정되고 2주 안팎으로 출석 조사가 잡힙니다. 형사 고소는 처벌을 구하는 별개 절차이므로 목적에 맞게 고르세요.',
        en: 'A complaint aims at getting you paid, not punishment. An inspector is usually assigned within a week and the meeting scheduled within about two weeks. A criminal complaint is a separate route seeking punishment — choose by your purpose.',
        zh: '申诉的目的是督促支付而非处罚。受理后通常一周内指派劳动监督官，约两周内安排出席调查。刑事告诉是另一条以处罚为目的的程序，请按目的选择。',
        vi: 'Khiếu nại nhằm được trả lương chứ không phải trừng phạt. Thường trong 1 tuần có thanh tra viên và khoảng 2 tuần có buổi điều tra. Tố cáo hình sự là thủ tục riêng nhằm xử phạt.',
      ),
    ),
    TrackStage(
      label: L10nText(
        ko: '출석 조사',
        en: 'Inspector meeting',
        zh: '出席调查',
        vi: 'Điều tra có mặt',
      ),
      whatHappens: L10nText(
        ko: '담당 근로감독관의 호출에 따라 출석해 조사를 받는 단계입니다. 사업주와 주장이 엇갈리면 삼자대면이 잡힐 수 있습니다.',
        en: 'Attend the labor office when the inspector calls you in. If accounts differ, a three-way meeting may be arranged.',
        zh: '应劳动监督官传唤出席接受调查。若与雇主主张不一致，可能安排三方对质。',
        vi: 'Đến cơ quan lao động khi thanh tra viên triệu tập. Nếu lời khai khác nhau, có thể có buổi đối chất ba bên.',
      ),
      documentsNeeded: L10nText(
        ko: '신분증 / 제출 증거자료 원본 / 출석 통지서',
        en: 'ID / original evidence / summons letter',
        zh: '身份证／提交证据原件／出席通知书',
        vi: 'Giấy tờ tùy thân / bản gốc chứng cứ / giấy triệu tập',
      ),
      watchOutFor: L10nText(
        ko: '사업주와 함께 있는 것이 불편하면 분리 조사를 요구할 수 있고, 통역원 동석도 미리 신청할 수 있습니다. 첫 조사에서 서류를 다 못 냈어도 이후 이메일·팩스·서면 의견서로 얼마든지 보완할 수 있으니 위축되지 마세요. 감독관이 합의를 권해도 받을 금액을 서둘러 깎을 이유는 없습니다.',
        en: 'You may ask to be questioned separately from your employer, and request an interpreter in advance. If you could not submit everything at the first meeting, you can supplement later by email, fax or written statement — do not be intimidated. Even if the inspector suggests settling, there is no reason to hastily cut what you are owed.',
        zh: '若不便与雇主同席，可要求分开调查，并可事先申请翻译陪同。首次调查未能提交齐全的材料，之后可通过邮件·传真·书面意见书补充，不必畏缩。即使监督官劝和解，也没有理由匆忙削减应得金额。',
        vi: 'Bạn có thể yêu cầu điều tra riêng và đăng ký phiên dịch trước. Nếu chưa nộp đủ giấy tờ ở buổi đầu, có thể bổ sung sau bằng email, fax hoặc văn bản — đừng nao núng. Dù thanh tra khuyên hòa giải, không có lý do vội giảm số tiền đáng nhận.',
      ),
    ),
    TrackStage(
      label: L10nText(
        ko: '체불확인서',
        en: 'Confirmation letter',
        zh: '欠薪确认书',
        vi: 'Giấy xác nhận',
      ),
      whatHappens: L10nText(
        ko: "체불 사실이 확정된 뒤 공식 확인서를 발급받는 단계입니다. 정식 명칭은 '체불 임금등·사업주 확인서'입니다.",
        en: 'Get the official confirmation once the unpaid wages are established. Its formal name is the Confirmation of Unpaid Wages and Employer.',
        zh: '欠薪事实确定后领取正式确认书。正式名称为"欠薪等·雇主确认书"。',
        vi: 'Nhận giấy xác nhận chính thức sau khi xác định nợ lương. Tên chính thức là Giấy xác nhận nợ lương và chủ sử dụng.',
      ),
      documentsNeeded: L10nText(
        ko: '체불임금등·사업주확인서 발급 신청서',
        en: 'Application for the confirmation letter',
        zh: '欠薪等·雇主确认书发放申请书',
        vi: 'Đơn xin cấp giấy xác nhận',
      ),
      watchOutFor: L10nText(
        ko: '이 확인서가 있어야 다음 단계인 대지급금이나 민사로 넘어갈 수 있습니다. 발급받으면 원본을 잃어버리지 말고 사본을 따로 보관하세요.',
        en: 'This letter is what lets you move on to the state advance payment or civil action. Keep the original safe and store a copy separately.',
        zh: '有此确认书才能进入下一步的代付金或民事程序。领取后请妥善保管原件并另存副本。',
        vi: 'Giấy này cho phép bạn chuyển sang bước tạm ứng nhà nước hoặc kiện dân sự. Giữ bản gốc cẩn thận và lưu thêm bản sao.',
      ),
    ),
    TrackStage(
      label: L10nText(
        ko: '간이대지급금',
        en: 'State advance',
        zh: '简易代付金',
        vi: 'Tạm ứng nhà nước',
      ),
      whatHappens: L10nText(
        ko: '사업주가 지급하지 못하거나 거부할 때 국가가 먼저 지급하는 제도입니다. 임금과 퇴직금을 합해 최대 1,000만원 한도로 알려져 있습니다.',
        en: 'When the employer cannot or will not pay, the state pays you first. The cap is reported as 10 million won in total for wages and severance combined.',
        zh: '雇主无力或拒绝支付时，由国家先行支付。据载工资与退职金合计上限为1,000万韩元。',
        vi: 'Khi chủ không thể hoặc không chịu trả, nhà nước trả trước. Hạn mức được nêu là tổng 10 triệu won cho lương và trợ cấp thôi việc.',
      ),
      documentsNeeded: L10nText(
        ko: '체불확인서 원본 / 지급청구서 / 본인 명의 통장 사본',
        en: 'Original confirmation letter / claim form / copy of your bankbook',
        zh: '确认书原件／支付请求书／本人名下存折复印件',
        vi: 'Bản gốc giấy xác nhận / đơn yêu cầu / bản sao sổ ngân hàng',
      ),
      watchOutFor: L10nText(
        ko: '법원 판결 없이 노동청 확인서만으로 청구할 수 있고, 접수 후 대략 두 달 안에 지급되는 것으로 알려져 있습니다. 청구 기한이 정해져 있으므로 확인서를 받으면 미루지 말고 바로 진행하세요.',
        en: 'You can claim with the labor office letter alone, without a court judgement, and payment is reported to take about two months. There is a filing deadline, so proceed as soon as you have the letter.',
        zh: '无需法院判决，仅凭劳动厅确认书即可请求，据载约两个月内支付。有申请期限，拿到确认书后请勿拖延。',
        vi: 'Có thể yêu cầu chỉ với giấy của cơ quan lao động, không cần phán quyết tòa, và thường được chi trả trong khoảng hai tháng. Có thời hạn nộp, nên hãy làm ngay khi nhận giấy.',
      ),
    ),
    TrackStage(
      label: L10nText(
        ko: '민사·지급명령',
        en: 'Civil action',
        zh: '民事·支付令',
        vi: 'Kiện dân sự',
      ),
      whatHappens: L10nText(
        ko: '체불액이 대지급금 한도를 넘거나 사업주가 계속 버틸 때 집행권원을 확보하는 단계입니다. 지급명령은 법정에 나가지 않고 서류만으로 진행됩니다.',
        en: 'When the amount exceeds the advance cap or the employer keeps refusing, secure a court order. A payment order proceeds on documents alone, without a hearing.',
        zh: '欠薪额超过代付金上限或雇主继续拖延时，取得执行依据。支付令仅凭书面进行，无需出庭。',
        vi: 'Khi số tiền vượt hạn mức tạm ứng hoặc chủ tiếp tục chây ì, hãy xin lệnh thi hành. Lệnh thanh toán chỉ tiến hành trên giấy tờ, không cần ra tòa.',
      ),
      documentsNeeded: L10nText(
        ko: '체불확인서 / 민사소장 또는 지급명령 신청서',
        en: 'Confirmation letter / civil complaint or payment order application',
        zh: '确认书／民事诉状或支付令申请书',
        vi: 'Giấy xác nhận / đơn kiện hoặc đơn xin lệnh thanh toán',
      ),
      watchOutFor: L10nText(
        ko: '월 평균임금이 일정 기준 미만이면 대한법률구조공단(대표번호 132)의 무료 법률구조를 받을 수 있습니다. 소득 요건을 먼저 확인하세요. 체불액이 3,000만원 이하면 소액사건심판으로 더 간단히 갈 수 있습니다.',
        en: 'If your average monthly wage is below a set threshold, the Korea Legal Aid Corporation (132) provides free assistance — check the income requirement first. Claims of 30 million won or less can go through the simplified small-claims procedure.',
        zh: '若月平均工资低于一定标准，可获大韩法律救助公团（代表号132）免费法律救助，请先确认收入条件。欠薪额在3,000万韩元以下可走更简便的小额审判程序。',
        vi: 'Nếu lương bình quân tháng dưới ngưỡng quy định, Trung tâm Trợ giúp pháp lý Hàn Quốc (132) hỗ trợ miễn phí — hãy kiểm tra điều kiện thu nhập. Số tiền từ 30 triệu won trở xuống có thể theo thủ tục án nhỏ đơn giản hơn.',
      ),
    ),
    TrackStage(
      label: L10nText(
        ko: '집행·이직',
        en: 'Enforcement & moving on',
        zh: '执行·转职',
        vi: 'Thi hành & chuyển việc',
      ),
      whatHappens: L10nText(
        ko: '사업주 재산에 대한 압류·경매를 진행하고, 체불로 인한 사업장 변경을 처리하는 단계입니다.',
        en: "Enforce against the employer's assets and handle a workplace change caused by the unpaid wages.",
        zh: '对雇主财产进行扣押·拍卖，并办理因欠薪的单位变更。',
        vi: 'Thi hành đối với tài sản của chủ và xử lý việc chuyển nơi làm do bị nợ lương.',
      ),
      documentsNeeded: L10nText(
        ko: '확정 판결문·지급명령 결정문 / 사업장 변경 신청서',
        en: 'Final judgement or payment order / workplace change application',
        zh: '确定判决书·支付令决定书／单位变更申请书',
        vi: 'Bản án/lệnh thanh toán / đơn xin chuyển nơi làm việc',
      ),
      watchOutFor: L10nText(
        ko: '판결을 받아도 사업주에게 압류할 재산이 없으면 실제 회수가 어렵습니다. 노동청 단계부터 사업자 계좌·차량·거래처 같은 재산 상태를 함께 살펴두고, 재산을 빼돌리는 정황이 보이면 가압류를 먼저 걸어두는 편이 낫습니다. 체불이 증명되면 사업장 변경 횟수에서 차감되지 않습니다.',
        en: 'Even with a judgement, recovery is hard if there are no assets to seize. From the labor office stage, check for business accounts, vehicles and clients, and consider provisional attachment if assets are being moved. If the unpaid wages are proven, this change does not count against your workplace-change quota.',
        zh: '即使取得判决，若雇主无可扣押财产也难以实际回收。从劳动厅阶段起就一并了解其账户·车辆·交易方等财产状况，若发现转移财产迹象宜先申请假扣押。欠薪一经证明，此次变更不计入单位变更次数。',
        vi: 'Dù có phán quyết, khó thu hồi nếu chủ không còn tài sản. Ngay từ giai đoạn cơ quan lao động, hãy nắm tài khoản, xe, đối tác của chủ; nếu thấy tẩu tán tài sản, nên xin phong tỏa tạm thời. Nếu chứng minh được nợ lương, lần chuyển việc này không bị trừ vào hạn mức.',
      ),
    ),
  ],
);
