import '../../../core/app_language.dart';

class OnboardingGuideModuleText {
  const OnboardingGuideModuleText({
    required this.title,
    required this.description,
  });

  final L10nText title;
  final L10nText description;
}

class OnboardingGuideStrings {
  OnboardingGuideStrings._();

  static const pageTitle = L10nText(
    ko: 'Local Bridge 사용 설명서',
    en: 'Local Bridge User Guide',
    zh: 'Local Bridge 使用指南',
    vi: 'Hướng dẫn sử dụng Local Bridge',
  );

  static const pageSubtitle = L10nText(
    ko: '주요 기능과 이용 방법을 한눈에 확인하세요.',
    en: 'See the main features and how to use them at a glance.',
    zh: '快速了解主要功能及使用方法。',
    vi: 'Xem nhanh các chức năng chính và cách sử dụng.',
  );

  static const tagline = L10nText(
    ko: 'AI 기반 외국인 노동자를 위한 정보제공 및 권익보호 플랫폼',
    en: 'An AI-powered information and rights protection platform for migrant workers',
    zh: '面向外籍劳动者的 AI 信息服务与权益保护平台',
    vi: 'Nền tảng AI cung cấp thông tin và bảo vệ quyền lợi cho lao động nước ngoài',
  );

  static const introduction = L10nText(
    ko: "'Local Bridge'는 지역 사회(Local)와 외국인 노동자를 유기적으로 연결(Bridge)한다는 뜻으로, 외국인 노동자들의 정보 격차 문제를 해소하고 모국어 기반의 사전 권익 보호와 사후 문제 해결을 추구하는 AI 통합 플랫폼입니다.",
    en: "'Local Bridge' means organically connecting local communities with migrant workers. It is an integrated AI platform that aims to close information gaps and support both preventive rights protection and post-incident problem solving in each worker's native language.",
    zh: '“Local Bridge”寓意将地方社区（Local）与外籍劳动者有机连接（Bridge）。这是一个 AI 综合平台，旨在缩小外籍劳动者的信息差距，并以其母语提供事前权益保护和事后问题解决支持。',
    vi: "'Local Bridge' mang ý nghĩa kết nối chặt chẽ cộng đồng địa phương (Local) với người lao động nước ngoài (Bridge). Đây là nền tảng AI tích hợp nhằm thu hẹp khoảng cách thông tin, bảo vệ quyền lợi từ sớm và hỗ trợ giải quyết vấn đề sau khi phát sinh bằng tiếng mẹ đẻ của người lao động.",
  );

  static const modules = <OnboardingGuideModuleText>[
    OnboardingGuideModuleText(
      title: L10nText(
        ko: '생활 백과사전',
        en: 'Daily Life Encyclopedia',
        zh: '生活百科全书',
        vi: 'Bách khoa đời sống',
      ),
      description: L10nText(
        ko: '한국 생활에 필요한 정보를 필수 행정, 생활 정착, 노동 권익의 3대 분야와 12개 카테고리로 정리합니다.',
        en: 'Organizes essential information for life in Korea into 12 categories across three areas: essential administration, daily settlement, and labor rights.',
        zh: '将韩国生活所需的信息按必备行政、生活安顿、劳动权益三大领域整理为 12 个类别。',
        vi: 'Sắp xếp thông tin cần thiết cho cuộc sống tại Hàn Quốc thành 12 danh mục thuộc ba lĩnh vực: hành chính thiết yếu, ổn định cuộc sống và quyền lợi lao động.',
      ),
    ),
    OnboardingGuideModuleText(
      title: L10nText(
        ko: 'AI 챗봇',
        en: 'AI Chatbot',
        zh: 'AI 聊天助手',
        vi: 'Chatbot AI',
      ),
      description: L10nText(
        ko: '백과사전 카드, 근무기록장, 임금계산기 등 필요한 기능과 관할 기관으로 연결하는 AI Agent 챗봇 도우미입니다.',
        en: 'An AI Agent assistant that connects users to the right features—such as encyclopedia cards, the work log, and the wage calculator—and to the relevant authorities.',
        zh: 'AI Agent 聊天助手，可将用户连接到百科卡片、工作记录本、工资计算器等所需功能及相关主管机构。',
        vi: 'Trợ lý chatbot AI Agent kết nối người dùng với các chức năng cần thiết như thẻ bách khoa, nhật ký làm việc, máy tính lương và các cơ quan có thẩm quyền.',
      ),
    ),
    OnboardingGuideModuleText(
      title: L10nText(
        ko: '근무기록장',
        en: 'Work Log',
        zh: '工作记录本',
        vi: 'Nhật ký làm việc',
      ),
      description: L10nText(
        ko: '출퇴근, 휴게, GPS 위치 인증, 타임스탬프 사진, 버스카드 기록 등을 근로자 단독 계정에 축적합니다.',
        en: "Stores clock-in/out times, breaks, GPS verification, timestamped photos, transit-card records, and more in the worker's private account.",
        zh: '将上下班、休息、GPS 位置认证、带时间戳的照片、交通卡记录等保存在劳动者的个人账户中。',
        vi: 'Lưu giờ vào/ra ca, thời gian nghỉ, xác minh vị trí GPS, ảnh có dấu thời gian, lịch sử thẻ giao thông và các dữ liệu khác trong tài khoản riêng của người lao động.',
      ),
    ),
    OnboardingGuideModuleText(
      title: L10nText(
        ko: '임금계산기',
        en: 'Wage Calculator',
        zh: '工资计算器',
        vi: 'Máy tính lương',
      ),
      description: L10nText(
        ko: '최저임금과 사업장 규모를 반영해 주휴수당, 연장·야간·휴일수당 등을 계산합니다.',
        en: 'Calculates weekly holiday pay and overtime, night, and holiday-work premiums based on the minimum wage and workplace size.',
        zh: '根据最低工资和用人单位规模，计算周休津贴、加班、夜间及节假日工作津贴等。',
        vi: 'Tính tiền nghỉ hằng tuần có lương, phụ cấp làm thêm giờ, làm đêm và làm ngày nghỉ dựa trên mức lương tối thiểu và quy mô nơi làm việc.',
      ),
    ),
    OnboardingGuideModuleText(
      title: L10nText(
        ko: '임금체불·산재 네비게이터',
        en: 'Unpaid Wage & Workplace Injury Navigator',
        zh: '欠薪与工伤导航',
        vi: 'Điều hướng nợ lương và tai nạn lao động',
      ),
      description: L10nText(
        ko: '임금체불과 산업재해 피해 발생 시 진정 및 신청 절차를 단계별로 안내합니다.',
        en: 'Provides step-by-step guidance for filing an unpaid-wage complaint or an occupational-accident claim.',
        zh: '发生欠薪或工伤损害时，分步骤指导申诉及申请流程。',
        vi: 'Hướng dẫn từng bước quy trình khiếu nại nợ lương và yêu cầu giải quyết tai nạn lao động.',
      ),
    ),
  ];

  static const creatorTitle = L10nText(
    ko: '제작자',
    en: 'Created by',
    zh: '制作团队',
    vi: 'Đơn vị phát triển',
  );

  static const creatorNames = L10nText(
    ko: '아주대학교 학생: 이건영, 정수환, 김형우',
    en: 'Ajou University students: 이건영, 정수환, 김형우',
    zh: '亚洲大学学生：이건영、정수환、김형우',
    vi: 'Sinh viên Đại học Ajou: 이건영, 정수환, 김형우',
  );
}
