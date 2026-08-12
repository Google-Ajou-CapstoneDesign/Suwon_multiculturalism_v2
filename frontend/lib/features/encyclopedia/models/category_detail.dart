import '../../../core/app_language.dart';

/// 5단 카드 템플릿의 캡션(①~⑤) 인덱스(0~4)와 본문.
class DetailStep {
  const DetailStep({required this.captionIndex, required this.text});

  final int captionIndex;
  final L10nText text;
}

/// 하위 문서 1개(예: 비자 관리 카테고리의 "하이코리아 회원가입" 문서).
/// 카테고리 하나가 여러 하위 문서로 쪼개질 때만 쓴다(subDocuments 참고).
class SubDocument {
  const SubDocument({
    required this.title,
    required this.description,
    required this.body,
    required this.checklist,
  });

  final L10nText title;
  final L10nText description;

  /// 문단 단위 본문(순서대로 렌더링).
  final List<L10nText> body;
  final List<L10nText> checklist;
}

/// 카테고리 상세 콘텐츠. 검수를 마친 카테고리만 채워져 있고, 나머지는
/// categoryDetailById에 키가 없어 "이 항목은 2차 단계에서 채웁니다" 안내로 대체된다.
class CategoryDetail {
  const CategoryDetail({
    required this.steps,
    this.hasGuidePhotos = false,
    this.checklist = const [],
    this.subDocuments = const [],
  });

  final List<DetailStep> steps;

  /// true면 ⑤ 단계별 가이드(화면 캡처 자리)를 추가로 보여준다.
  final bool hasGuidePhotos;

  /// 카테고리 전체에 걸리는 단일 체크리스트. subDocuments가 있으면 보통 비워둔다
  /// (체크리스트는 하위 문서마다 따로 있기 때문).
  final List<L10nText> checklist;

  /// 이 카테고리가 여러 하위 문서로 나뉘어 있으면 채운다(예: 비자 관리 & 체류 연장).
  final List<SubDocument> subDocuments;
}

const Map<int, CategoryDetail> categoryDetailById = {
  1: CategoryDetail(
    steps: [
      DetailStep(
        captionIndex: 0,
        text: L10nText(
          ko: '출입국사무소에서 발급하는 외국인 신분증입니다.',
          en: 'The ID card for foreign residents, issued by the immigration office.',
          zh: '由出入境管理事务所颁发的外国人身份证件。',
          vi: 'Thẻ căn cước cho người nước ngoài, do cơ quan xuất nhập cảnh cấp.',
        ),
      ),
      DetailStep(
        captionIndex: 1,
        text: L10nText(
          ko: '관할 출입국·외국인청 방문 (사전 예약 필요)',
          en: 'Visit your local immigration office (book an appointment first).',
          zh: '前往管辖出入境·外国人厅（需提前预约）',
          vi: 'Đến văn phòng xuất nhập cảnh phụ trách (cần đặt lịch trước).',
        ),
      ),
      DetailStep(
        captionIndex: 2,
        text: L10nText(
          ko: '한국에 90일 넘게 머무는 외국인이 반드시 발급받아야 하는 신분증입니다.',
          en: 'Required for anyone staying in Korea longer than 90 days.',
          zh: '在韩国停留超过90天的外国人必须办理的身份证件。',
          vi: 'Bắt buộc với người ở Hàn Quốc trên 90 ngày.',
        ),
      ),
      DetailStep(
        captionIndex: 3,
        text: L10nText(
          ko: '입국 후 90일 이내. 은행 계좌와 휴대폰 개통 전에 먼저 필요합니다.',
          en: 'Within 90 days of arrival. You need it before opening a bank account or getting a phone.',
          zh: '入境后90天内。在开设银行账户和办理手机开通之前需要先办理。',
          vi: 'Trong vòng 90 ngày sau khi nhập cảnh. Cần có trước khi mở tài khoản hoặc đăng ký điện thoại.',
        ),
      ),
    ],
    hasGuidePhotos: true,
    checklist: [
      L10nText(ko: '여권', en: 'Passport', zh: '护照', vi: 'Hộ chiếu'),
      L10nText(
        ko: '표준규격 사진 1매',
        en: 'One standard ID photo',
        zh: '标准规格照片1张',
        vi: 'Một ảnh thẻ tiêu chuẩn',
      ),
      L10nText(
        ko: '수수료 3만원',
        en: 'Fee: 30,000 KRW',
        zh: '手续费3万韩元',
        vi: 'Lệ phí: 30.000 KRW',
      ),
      L10nText(
        ko: '체류지 입증 서류',
        en: 'Proof of address',
        zh: '居住地证明文件',
        vi: 'Giấy tờ chứng minh nơi ở',
      ),
    ],
  ),
  2: CategoryDetail(
    steps: [
      DetailStep(
        captionIndex: 1,
        text: L10nText(
          ko: '하이코리아 전자민원 또는 관할 출입국·외국인청',
          en: 'HiKorea e-Application, or your local immigration office',
          zh: 'HiKorea电子民愿或管辖出入境·外国人厅',
          vi: 'Dịch vụ điện tử HiKorea hoặc văn phòng xuất nhập cảnh',
        ),
      ),
      DetailStep(
        captionIndex: 2,
        text: L10nText(
          ko: "체류자격(비자)은 '한국에서 무엇을 해도 되는지'를 정한 것이고, 체류기간은 '언제까지 있어도 되는지'입니다. 두 가지는 별개로 관리해야 합니다.",
          en: 'Your status of stay defines what you may do in Korea; your period of stay defines how long you may remain. They are managed separately.',
          zh: '居留资格（签证）规定的是"在韩国可以做什么"，居留期限规定的是"可以停留到什么时候"。这两者需要分别管理。',
          vi: 'Tư cách lưu trú quy định bạn được làm gì; thời hạn lưu trú quy định bạn được ở đến bao giờ. Hai thứ quản lý riêng.',
        ),
      ),
      DetailStep(
        captionIndex: 3,
        text: L10nText(
          ko: '체류만료일 4개월 전부터 만료일까지 신청할 수 있습니다. 하루라도 넘기면 불법체류가 되고 범칙금이 붙습니다.',
          en: 'You can apply from four months before expiry up to the expiry date. Even one day over means unlawful stay and a fine.',
          zh: '可以从居留到期日前4个月开始申请，直到到期日为止。哪怕超期一天也会构成非法滞留并被处以罚款。',
          vi: 'Có thể nộp từ 4 tháng trước hạn đến ngày hết hạn. Quá một ngày là cư trú bất hợp pháp và bị phạt.',
        ),
      ),
    ],
    subDocuments: [
      SubDocument(
        title: L10nText(
          ko: '하이코리아 회원가입 & 비밀번호 찾기',
          en: 'HiKorea sign-up & password recovery',
          zh: 'HiKorea会员注册与找回密码',
          vi: 'Đăng ký HiKorea & lấy lại mật khẩu',
        ),
        description: L10nText(
          ko: '외국인등록번호가 있어야 가입됩니다',
          en: 'You need your ARC number to sign up',
          zh: '需要有外国人登录号码才能注册',
          vi: 'Cần số thẻ đăng ký người nước ngoài để đăng ký',
        ),
        body: [
          L10nText(
            ko: '① hikorea.go.kr → [회원가입] → 외국인 회원을 선택합니다. 외국인등록번호와 여권번호가 모두 필요합니다.',
            en: '① hikorea.go.kr → [Sign up] → choose foreign member. You need both your ARC number and passport number.',
            zh: '① 进入 hikorea.go.kr → [会员注册] → 选择外国人会员。需要同时提供外国人登录号码和护照号码。',
            vi: '① hikorea.go.kr → [Đăng ký] → chọn thành viên nước ngoài. Cần cả số ARC và số hộ chiếu.',
          ),
          L10nText(
            ko: '② 아이디는 영문+숫자 조합이며 나중에 바꿀 수 없습니다. 적어두고 프로필 보관함에 저장해두세요.',
            en: '② Your ID is letters + numbers and cannot be changed later. Write it down and keep it in your profile vault.',
            zh: '② 账号由英文字母和数字组成，之后无法更改。请记下并保存在个人资料保管箱中。',
            vi: '② ID gồm chữ và số, sau này không đổi được. Hãy ghi lại và lưu vào kho hồ sơ.',
          ),
          L10nText(
            ko: '③ 비밀번호를 잊었다면 [비밀번호 찾기]에서 외국인등록번호와 가입 시 등록한 휴대폰 번호로 본인확인을 합니다. 번호가 바뀌었다면 관서 방문이 필요합니다.',
            en: '③ If you forget your password, use [Find password] with your ARC number and the phone number you registered. If that number changed, you must visit the office in person.',
            zh: '③ 如果忘记密码，可在[找回密码]中使用外国人登录号码和注册时登记的手机号码进行本人验证。如果号码已更换，则需要亲自前往机构办理。',
            vi: '③ Quên mật khẩu thì dùng [Tìm mật khẩu] với số ARC và số điện thoại đã đăng ký. Nếu đổi số, phải đến văn phòng.',
          ),
          L10nText(
            ko: "④ 전자민원으로 처리 가능한 것과 반드시 방문해야 하는 것이 나뉩니다. 신청 화면에서 '온라인 신청 가능' 표시를 먼저 확인하세요.",
            en: "④ Some applications can be done online, others require a visit. Check the 'online available' mark on the application screen first.",
            zh: '④ 有些事项可通过电子民愿处理，有些则必须亲自前往办理。请先在申请页面确认是否标有"可在线申请"字样。',
            vi: "④ Một số việc làm được trực tuyến, số khác phải đến trực tiếp. Hãy kiểm tra dấu 'có thể nộp trực tuyến' trước.",
          ),
        ],
        checklist: [
          L10nText(
            ko: '아이디·비밀번호를 안전하게 기록했는가',
            en: 'Did you record your ID and password safely?',
            zh: '是否已安全记录账号和密码？',
            vi: 'Đã ghi lại ID và mật khẩu an toàn chưa?',
          ),
          L10nText(
            ko: '가입에 쓴 휴대폰 번호가 지금 쓰는 번호인가',
            en: 'Is the registered phone number the one you use now?',
            zh: '注册时使用的手机号码是否为现在使用的号码？',
            vi: 'Số điện thoại đã đăng ký có phải số đang dùng không?',
          ),
        ],
      ),
      SubDocument(
        title: L10nText(
          ko: '체류기간 연장 신청 절차 (D-2·E-9·E-7)',
          en: 'Extending your stay (D-2 · E-9 · E-7)',
          zh: '居留期限延长申请程序（D-2·E-9·E-7）',
          vi: 'Gia hạn thời gian lưu trú (D-2 · E-9 · E-7)',
        ),
        description: L10nText(
          ko: '자격마다 요구 서류가 다릅니다. 공통 서류부터 챙기세요',
          en: 'Required documents differ by status. Start with the common ones',
          zh: '不同资格所需材料不同，请先准备通用材料',
          vi: 'Giấy tờ khác nhau theo tư cách. Hãy bắt đầu từ giấy tờ chung',
        ),
        body: [
          L10nText(
            ko: '① 공통 서류: 여권, 외국인등록증, 통합신청서, 수수료, 체류지 입증 서류. 이 다섯 가지는 어떤 자격이든 들어갑니다.',
            en: '① Common documents: passport, ARC, integrated application form, fee, proof of address. These five apply to every status.',
            zh: '① 通用材料：护照、外国人登录证、综合申请表、手续费、居住地证明文件。无论何种资格都需要这五项。',
            vi: '① Giấy tờ chung: hộ chiếu, ARC, đơn tích hợp, lệ phí, chứng minh nơi ở. Năm thứ này áp dụng cho mọi tư cách.',
          ),
          L10nText(
            ko: '② D-2(유학): 재학증명서, 성적증명서, 등록금 납입증명, 잔고증명이 추가됩니다. 출석률과 성적이 기준에 못 미치면 연장이 제한될 수 있습니다.',
            en: '② D-2 (student): add enrolment certificate, transcript, tuition receipt and proof of funds. Low attendance or grades can restrict extension.',
            zh: '② D-2（留学）：需另外提交在读证明、成绩单、学费缴纳证明、存款证明。若出勤率或成绩未达标，延长可能受限。',
            vi: '② D-2 (du học): thêm giấy xác nhận đang học, bảng điểm, biên lai học phí, chứng minh tài chính. Điểm hoặc chuyên cần thấp có thể bị hạn chế.',
          ),
          L10nText(
            ko: '③ E-9(비전문취업): 사업주가 신청 주체가 되는 절차가 많습니다. 고용허가서, 근로계약서, 사업자등록증 사본이 필요하며 사업주 협조가 필수입니다.',
            en: '③ E-9 (non-professional): the employer often initiates. You need the employment permit, contract and business registration copy — employer cooperation is essential.',
            zh: '③ E-9（非专业就业）：很多程序需以雇主为申请主体。需要就业许可证、劳动合同、营业执照复印件，雇主的配合是必不可少的。',
            vi: '③ E-9 (lao động phổ thông): chủ sử dụng thường là bên nộp. Cần giấy phép tuyển dụng, hợp đồng, bản sao đăng ký kinh doanh — cần chủ hợp tác.',
          ),
          L10nText(
            ko: '④ E-7(특정활동): 고용계약서, 사업자등록증, 학위·경력 증빙, 사업체 재정 자료가 들어갑니다. 임금 요건이 붙는 자격이라 계약 임금액을 미리 확인하세요.',
            en: '④ E-7 (specific activity): employment contract, business registration, degree or career evidence, and company financials. There is a wage requirement — check your contracted pay first.',
            zh: '④ E-7（特定活动）：需要提交劳动合同、营业执照、学历·经历证明、企业财务资料。该资格附带工资要求，请提前确认合同工资金额。',
            vi: '④ E-7 (hoạt động đặc định): hợp đồng lao động, đăng ký kinh doanh, bằng cấp/kinh nghiệm, tài chính công ty. Có yêu cầu về lương — hãy kiểm tra mức lương hợp đồng.',
          ),
          L10nText(
            ko: '⑤ 사업주가 연장 서류를 안 해준다면 그것 자체가 문제 상황입니다. 권리구제 가이드와 AI 가이드로 연결됩니다.',
            en: '⑤ If your employer refuses to help with extension paperwork, that is itself a problem. This links to the rights guide and the AI guide.',
            zh: '⑤ 如果雇主不配合准备延长材料，这本身就是需要关注的问题情况。可前往权益救济指南和AI引导获取帮助。',
            vi: '⑤ Nếu chủ không hỗ trợ giấy tờ gia hạn, bản thân đó đã là vấn đề. Sẽ liên kết tới hướng dẫn quyền lợi và AI.',
          ),
        ],
        checklist: [
          L10nText(
            ko: '체류만료일 4개월 전부터 신청 가능함을 알고 있는가',
            en: 'Do you know you can apply from four months before expiry?',
            zh: '是否知道可以从居留到期日前4个月开始申请？',
            vi: 'Bạn biết có thể nộp từ 4 tháng trước hạn chứ?',
          ),
          L10nText(
            ko: '공통 서류 5종을 모두 준비했는가',
            en: 'Do you have all five common documents?',
            zh: '是否已准备好全部5种通用材料？',
            vi: 'Đã chuẩn bị đủ 5 loại giấy tờ chung chưa?',
          ),
          L10nText(
            ko: '자격별 추가 서류를 확인했는가',
            en: 'Did you check the extra documents for your status?',
            zh: '是否已确认各资格所需的附加材料？',
            vi: 'Đã kiểm tra giấy tờ bổ sung theo tư cách chưa?',
          ),
          L10nText(
            ko: '만료일 전에 예약이 잡혀 있는가',
            en: 'Is your appointment before the expiry date?',
            zh: '预约时间是否安排在到期日之前？',
            vi: 'Lịch hẹn có trước ngày hết hạn không?',
          ),
        ],
      ),
      SubDocument(
        title: L10nText(
          ko: '체류자격 변경 (D-2→E-7, E-9→E-7-4)',
          en: 'Changing status (D-2→E-7, E-9→E-7-4)',
          zh: '居留资格变更（D-2→E-7，E-9→E-7-4）',
          vi: 'Đổi tư cách lưu trú (D-2→E-7, E-9→E-7-4)',
        ),
        description: L10nText(
          ko: '요약 안내입니다. 요건이 자주 바뀌므로 반드시 원문을 확인하세요',
          en: 'A summary. Requirements change often — always check the official notice',
          zh: '以下为简要说明。相关要求经常变动，请务必查阅官方原文',
          vi: 'Đây là tóm tắt. Điều kiện thay đổi thường xuyên, hãy kiểm tra văn bản gốc',
        ),
        body: [
          L10nText(
            ko: '① D-2 → E-7 (유학생 취업): 국내 대학 졸업(예정) 후 전공과 관련된 직무로 취업할 때 신청합니다. 학위, 전공-직무 연관성, 고용계약, 임금 요건이 함께 심사됩니다.',
            en: '① D-2 → E-7 (student to work): apply when you take a job related to your major after graduating from a Korean university. Degree, major-job relevance, contract and wage are reviewed together.',
            zh: '① D-2 → E-7（留学生就业）：适用于（即将）从韩国国内大学毕业后，从事与所学专业相关工作的情况。学历、专业与岗位的关联性、雇佣合同、工资要求将一并接受审查。',
            vi: '① D-2 → E-7 (du học sinh đi làm): nộp khi làm công việc liên quan chuyên ngành sau khi tốt nghiệp đại học tại Hàn. Bằng cấp, độ liên quan, hợp đồng và lương được xét cùng lúc.',
          ),
          L10nText(
            ko: '② E-9 → E-7-4 (숙련기능인력): 일정 기간 이상 성실히 근무한 E-9 근로자가 장기 체류로 전환하는 제도입니다. 근무 기간, 소득, 한국어 능력, 사업주 추천이 평가 요소입니다.',
            en: '② E-9 → E-7-4 (skilled worker): a route for E-9 workers with a solid work record to move to long-term stay. Length of service, income, Korean ability and employer recommendation are assessed.',
            zh: '② E-9 → E-7-4（熟练技能人才）：供在一定期限内诚实工作的E-9劳动者转为长期居留的制度。评估要素包括工作年限、收入、韩语水平及雇主推荐。',
            vi: '② E-9 → E-7-4 (lao động lành nghề): lộ trình cho lao động E-9 có quá trình làm việc tốt chuyển sang lưu trú dài hạn. Thời gian làm việc, thu nhập, tiếng Hàn và thư giới thiệu được đánh giá.',
          ),
          L10nText(
            ko: '③ 두 경로 모두 점수제·쿼터제가 걸려 있고 요건이 자주 바뀝니다. 이 화면의 내용은 방향만 잡는 요약이고, 실제 신청 전에는 반드시 하이코리아 공지 원문과 대조하세요.',
            en: '③ Both routes involve points and quotas, and requirements change often. This screen is orientation only — always cross-check the official HiKorea notice before applying.',
            zh: '③ 两条途径均涉及积分制和配额制，且要求经常变动。本页内容仅作方向性概要，正式申请前请务必与HiKorea官方公告原文核对。',
            vi: '③ Cả hai đều theo hệ điểm và hạn ngạch, điều kiện thay đổi thường xuyên. Màn hình này chỉ định hướng — hãy đối chiếu thông báo chính thức của HiKorea trước khi nộp.',
          ),
          L10nText(
            ko: '④ 소득 요건은 계약서상 금액이 아니라 실제 지급된 금액으로 확인되는 경우가 많습니다. 임금명세서와 통장 내역을 계속 모아두세요.',
            en: '④ Income requirements are often verified by what was actually paid, not what the contract says. Keep collecting payslips and bank records.',
            zh: '④ 收入要求多以实际发放金额而非合同金额为准进行核实，请持续保存工资单和银行流水。',
            vi: '④ Yêu cầu thu nhập thường được xác minh bằng số tiền thực nhận, không phải theo hợp đồng. Hãy tiếp tục lưu phiếu lương và sao kê.',
          ),
        ],
        checklist: [
          L10nText(
            ko: '졸업(또는 근무) 요건 충족 시점을 확인했는가',
            en: 'Did you check when you meet the graduation or service requirement?',
            zh: '是否已确认达到毕业（或工作年限）要求的时间点？',
            vi: 'Đã xác định thời điểm đủ điều kiện tốt nghiệp hoặc thâm niên chưa?',
          ),
          L10nText(
            ko: '전공-직무 연관성 또는 숙련도 요건을 확인했는가',
            en: 'Did you check major-job relevance or skill requirements?',
            zh: '是否已确认专业与岗位关联性或技能要求？',
            vi: 'Đã kiểm tra độ liên quan chuyên ngành hoặc yêu cầu tay nghề chưa?',
          ),
          L10nText(
            ko: '임금명세서와 통장 내역을 보관하고 있는가',
            en: 'Are you keeping payslips and bank records?',
            zh: '是否保存有工资单和银行流水？',
            vi: 'Bạn có giữ phiếu lương và sao kê không?',
          ),
          L10nText(
            ko: '하이코리아 최신 공지 원문을 확인했는가',
            en: 'Did you check the latest official HiKorea notice?',
            zh: '是否已查阅HiKorea最新公告原文？',
            vi: 'Đã xem thông báo mới nhất của HiKorea chưa?',
          ),
        ],
      ),
    ],
  ),
  11: CategoryDetail(
    steps: [
      DetailStep(
        captionIndex: 0,
        text: L10nText(
          ko: '계약서에 반드시 있어야 할 항목을 확인합니다.',
          en: 'Check that your contract includes everything it must.',
          zh: '确认合同中必须包含的事项。',
          vi: 'Kiểm tra hợp đồng có đủ các mục bắt buộc.',
        ),
      ),
      DetailStep(
        captionIndex: 1,
        text: L10nText(
          ko: '앱에서 확인 · 사업주에게 사본 요청',
          en: 'Check in the app, and ask your employer for a copy.',
          zh: '在应用内确认·向雇主索取副本',
          vi: 'Xem trong ứng dụng và yêu cầu chủ sử dụng lao động bản sao.',
        ),
      ),
      DetailStep(
        captionIndex: 2,
        text: L10nText(
          ko: '임금·근로시간·휴일 등 근로조건을 문서로 남긴 것입니다.',
          en: 'A written record of your pay, hours, and days off.',
          zh: '以书面形式记录工资、工作时间、休息日等劳动条件的文件。',
          vi: 'Văn bản ghi lại tiền lương, giờ làm và ngày nghỉ.',
        ),
      ),
      DetailStep(
        captionIndex: 3,
        text: L10nText(
          ko: '서명하기 직전에 확인하세요.',
          en: 'Check it right before you sign.',
          zh: '请在签字前务必确认。',
          vi: 'Kiểm tra ngay trước khi ký.',
        ),
      ),
    ],
    checklist: [
      L10nText(
        ko: '임금 구성 항목이 적혀 있는가',
        en: 'Is the breakdown of pay written out?',
        zh: '是否写明了工资构成项目？',
        vi: 'Đã ghi rõ các khoản lương chưa?',
      ),
      L10nText(
        ko: '근로시간과 휴게시간이 적혀 있는가',
        en: 'Are working hours and breaks written out?',
        zh: '是否写明了工作时间和休息时间？',
        vi: 'Đã ghi giờ làm và giờ nghỉ chưa?',
      ),
      L10nText(
        ko: '수습기간과 그때의 임금이 적혀 있는가',
        en: 'Is the probation period and its pay written out?',
        zh: '是否写明了试用期及该期间的工资？',
        vi: 'Đã ghi thời gian thử việc và mức lương chưa?',
      ),
      L10nText(
        ko: '내가 아는 언어로 된 사본을 받았는가',
        en: 'Did you get a copy in a language you read?',
        zh: '是否拿到了用自己能看懂的语言写成的副本？',
        vi: 'Bạn đã nhận bản sao bằng ngôn ngữ mình đọc được chưa?',
      ),
    ],
  ),
  17: CategoryDetail(
    steps: [
      DetailStep(
        captionIndex: 0,
        text: L10nText(
          ko: '혼자 해결하기 어려울 때 도와줄 곳을 연결합니다.',
          en: "Connects you to people who can help when you can't fix it alone.",
          zh: '在您难以独自解决问题时，为您连接可提供帮助的机构。',
          vi: 'Kết nối bạn với nơi có thể giúp khi bạn không tự giải quyết được.',
        ),
      ),
      DetailStep(
        captionIndex: 1,
        text: L10nText(
          ko: '경기도 마을노무사 제도 · 수원시비정규직노동자복지센터',
          en: 'Gyeonggi Village Labor Attorney program · Suwon Non-regular Workers Welfare Center',
          zh: '京畿道乡村劳务士制度·水原市非正规劳动者福利中心',
          vi: 'Chương trình luật sư lao động Gyeonggi · Trung tâm phúc lợi lao động Suwon',
        ),
      ),
      DetailStep(
        captionIndex: 2,
        text: L10nText(
          ko: '노무사 선임 비용을 지원받아 상담과 대리를 받는 제도입니다.',
          en: 'A program that covers the cost of hiring a labor attorney for advice and representation.',
          zh: '该制度可获得聘请劳务士的费用支援，从而接受咨询和代理服务。',
          vi: 'Chương trình hỗ trợ chi phí thuê luật sư lao động để tư vấn và đại diện.',
        ),
      ),
      DetailStep(
        captionIndex: 3,
        text: L10nText(
          ko: '임금을 못 받았거나 다쳤는데 회사가 처리해주지 않을 때',
          en: "When you haven't been paid, or you were injured and your workplace won't act.",
          zh: '当您未能领到工资，或受伤后公司却不予处理时',
          vi: 'Khi bạn chưa được trả lương, hoặc bị thương mà công ty không xử lý.',
        ),
      ),
    ],
    checklist: [
      L10nText(
        ko: '신청 조건 확인하기',
        en: 'Check whether you qualify',
        zh: '确认申请条件',
        vi: 'Kiểm tra điều kiện đăng ký',
      ),
      L10nText(
        ko: '가까운 상담기관 찾기',
        en: 'Find the nearest support center',
        zh: '查找附近的咨询机构',
        vi: 'Tìm trung tâm hỗ trợ gần nhất',
      ),
      L10nText(
        ko: '상담 전 준비할 서류',
        en: 'Documents to bring to your appointment',
        zh: '咨询前需准备的材料',
        vi: 'Giấy tờ cần mang khi tư vấn',
      ),
    ],
  ),
};

/// 5단 카드 캡션 라벨(①~⑤), 언어별.
const detailStepCaptions = [
  L10nText(ko: '① 아이콘·제목', en: '① Title', zh: '① 图标·标题', vi: '① Tiêu đề'),
  L10nText(
    ko: '② 접근 경로',
    en: '② Where to go',
    zh: '② 办理途径',
    vi: '② Nơi thực hiện',
  ),
  L10nText(ko: '③ 정의', en: '③ What it is', zh: '③ 定义', vi: '③ Định nghĩa'),
  L10nText(
    ko: '④ 사용 시점',
    en: '④ When you need it',
    zh: '④ 使用时机',
    vi: '④ Thời điểm cần',
  ),
  L10nText(
    ko: '⑤ 단계별 가이드',
    en: '⑤ Step-by-step guide',
    zh: '⑤ 分步指南',
    vi: '⑤ Hướng dẫn từng bước',
  ),
];
