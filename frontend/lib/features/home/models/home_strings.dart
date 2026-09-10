import '../../../core/app_language.dart';

/// 홈 탭 UI 문구. html_files/홈화면.html의 위젯 그리드 홈 리디자인을 옮겼다.
class HomeStrings {
  HomeStrings._();

  static const tabTitle = L10nText(
    ko: '홈',
    en: 'Home',
    zh: '首页',
    vi: 'Trang chủ',
  );
  static const visaNotSet = L10nText(
    ko: '체류자격 미설정',
    en: 'Visa status not set',
    zh: '未设置居留资格',
    vi: 'Chưa đặt tư cách lưu trú',
  );

  static const wageNavTitle = L10nText(
    ko: '임금체불 진정 안내',
    en: 'Unpaid wage report guide',
    zh: '拖欠工资申诉指南',
    vi: 'Hướng dẫn khiếu nại nợ lương',
  );
  static const injuryNavTitle = L10nText(
    ko: '산재처리 신청 안내',
    en: 'Workplace injury claim guide',
    zh: '工伤申报指南',
    vi: 'Hướng dẫn yêu cầu bồi thường tai nạn lao động',
  );

  // ---------- 인사말 ----------
  static const greetingEyebrow = L10nText(
    ko: 'MY LOCAL BRIDGE',
    en: 'MY LOCAL BRIDGE',
    zh: 'MY LOCAL BRIDGE',
    vi: 'MY LOCAL BRIDGE',
  );
  static const greetingSubtitle = L10nText(
    ko: '나의 근무와 생활 정보를 한곳에서 확인하세요.',
    en: 'Check your work and daily-life info all in one place.',
    zh: '在这里一站式查看您的工作和生活信息。',
    vi: 'Xem thông tin công việc và đời sống của bạn ở một nơi.',
  );

  static const greetingMorning = L10nText(
    ko: '좋은 아침이에요,',
    en: 'Good morning,',
    zh: '早上好，',
    vi: 'Chào buổi sáng,',
  );
  static const greetingAfternoon = L10nText(
    ko: '좋은 오후예요,',
    en: 'Good afternoon,',
    zh: '下午好，',
    vi: 'Chào buổi chiều,',
  );
  static const greetingEvening = L10nText(
    ko: '좋은 저녁이에요,',
    en: 'Good evening,',
    zh: '晚上好，',
    vi: 'Chào buổi tối,',
  );
  static const guestName = L10nText(
    ko: '게스트',
    en: 'Guest',
    zh: '访客',
    vi: 'Khách',
  );

  // ---------- 오늘의 근무 ----------
  static const workTitle = L10nText(
    ko: '오늘의 근무',
    en: "Today's work",
    zh: '今日出勤',
    vi: 'Công việc hôm nay',
  );
  static const workStatusWorking = L10nText(
    ko: '근무 중',
    en: 'Working',
    zh: '工作中',
    vi: 'Đang làm việc',
  );
  static const workStatusDone = L10nText(
    ko: '근무 종료',
    en: 'Finished',
    zh: '已下班',
    vi: 'Đã kết thúc',
  );
  static const workStatusBeforeStart = L10nText(
    ko: '출근 전',
    en: 'Not clocked in yet',
    zh: '尚未上班',
    vi: 'Chưa vào ca',
  );
  static const workGpsVerified = L10nText(
    ko: '위치 인증 완료',
    en: 'Location verified',
    zh: '已完成位置认证',
    vi: 'Đã xác thực vị trí',
  );
  static const workGpsVerifyButton = L10nText(
    ko: '위치 인증하기',
    en: 'Verify location',
    zh: '认证位置',
    vi: 'Xác minh vị trí',
  );
  static const workGpsServiceDisabled = L10nText(
    ko: '기기의 위치 서비스가 꺼져 있어요. 설정에서 켜주세요.',
    en: 'Your device location service is off. Please turn it on in settings.',
    zh: '设备的位置服务已关闭，请在设置中打开。',
    vi: 'Dịch vụ vị trí đang tắt. Vui lòng bật trong cài đặt.',
  );
  static const workGpsPermissionDenied = L10nText(
    ko: '위치 권한이 필요해요. 브라우저나 기기 설정에서 위치 접근을 허용해주세요.',
    en: 'Location permission is required. Please allow location access.',
    zh: '需要位置权限，请允许访问位置信息。',
    vi: 'Cần quyền vị trí. Vui lòng cho phép truy cập vị trí.',
  );
  static const workGpsVerifyFailed = L10nText(
    ko: '위치 정보를 받았지만 인증에 실패했어요. 다시 시도해주세요.',
    en: 'Location verification failed. Please try again.',
    zh: '位置认证失败，请重试。',
    vi: 'Xác minh vị trí thất bại. Vui lòng thử lại.',
  );
  static const workGpsVerifyError = L10nText(
    ko: '위치 인증 중 오류가 발생했어요. 잠시 후 다시 시도해주세요.',
    en: 'Something went wrong during location verification. Please try again.',
    zh: '位置认证时发生错误，请稍后重试。',
    vi: 'Đã xảy ra lỗi khi xác minh vị trí. Vui lòng thử lại.',
  );
  static const workClockInButton = L10nText(
    ko: '출근 기록하기',
    en: 'Clock in',
    zh: '记录上班',
    vi: 'Ghi giờ vào',
  );
  static const workClockOutButton = L10nText(
    ko: '퇴근 기록하기',
    en: 'Clock out',
    zh: '记录下班',
    vi: 'Ghi giờ ra',
  );
  static const workDoneButton = L10nText(
    ko: '오늘 기록 완료',
    en: "Today's record complete",
    zh: '今日记录已完成',
    vi: 'Đã hoàn tất ghi nhận',
  );
  static const workMemoButton = L10nText(
    ko: '근무 기록하기',
    en: 'Log work',
    zh: '记录工作',
    vi: 'Ghi nhận công việc',
  );

  static const workClockLabel = L10nText(
    ko: '출근',
    en: 'Clock in',
    zh: '上班',
    vi: 'Vào ca',
  );
  static const workClockOutLabel = L10nText(
    ko: '퇴근',
    en: 'Clock out',
    zh: '下班',
    vi: 'Tan ca',
  );
  static const workBreakLabel = L10nText(
    ko: '휴게',
    en: 'Break',
    zh: '休息',
    vi: 'Nghỉ',
  );
  static const workHoursUnit = L10nText(
    ko: '시간',
    en: 'hrs',
    zh: '小时',
    vi: 'giờ',
  );

  // ---------- 이번 달 근무 ----------
  static const monthlyTitle = L10nText(
    ko: '이번 달 근무',
    en: "This month's work",
    zh: '本月出勤',
    vi: 'Công việc tháng này',
  );
  static const monthlyDaysLabel = L10nText(
    ko: '근무일',
    en: 'Days worked',
    zh: '出勤天数',
    vi: 'Số ngày làm',
  );
  static const monthlyHoursLabel = L10nText(
    ko: '총 근무시간',
    en: 'Total hours',
    zh: '总工时',
    vi: 'Tổng giờ làm',
  );
  static const monthlyViewAll = L10nText(
    ko: '전체 기록 →',
    en: 'View all →',
    zh: '查看全部 →',
    vi: 'Xem tất cả →',
  );

  // ---------- 빠른 접근 ----------
  static const quickAccessTitle = L10nText(
    ko: '빠르게 이용하세요',
    en: 'Quick access',
    zh: '快速使用',
    vi: 'Truy cập nhanh',
  );
  static const quickWorklog = L10nText(
    ko: '근무기록장',
    en: 'Work log',
    zh: '工作记录本',
    vi: 'Nhật ký làm việc',
  );
  static const quickWageCalc = L10nText(
    ko: '임금계산기',
    en: 'Wage calculator',
    zh: '工资计算器',
    vi: 'Máy tính lương',
  );
  static const quickNavigator = L10nText(
    ko: '네비게이터',
    en: 'Navigator',
    zh: '导航',
    vi: 'Điều hướng',
  );
  static const quickVault = L10nText(
    ko: '내 증빙 보관함',
    en: 'My document vault',
    zh: '我的证明保管箱',
    vi: 'Kho tài liệu của tôi',
  );

  // ---------- 도움 가이드 ----------
  static const helpGuidesTitle = L10nText(
    ko: '도움이 필요할 때',
    en: 'When you need help',
    zh: '需要帮助时',
    vi: 'Khi bạn cần giúp đỡ',
  );
  static const wageNavDesc = L10nText(
    ko: '단계별로 진정서까지 안내해드려요.',
    en: 'Step-by-step guidance all the way to filing a report.',
    zh: '逐步引导您完成申诉书。',
    vi: 'Hướng dẫn từng bước đến khi nộp đơn khiếu nại.',
  );
  static const injuryNavDesc = L10nText(
    ko: '단계별로 요양급여 신청까지 안내해드려요.',
    en: 'Step-by-step guidance all the way to your benefit claim.',
    zh: '逐步引导您完成疗养补偿申请。',
    vi: 'Hướng dẫn từng bước đến khi yêu cầu trợ cấp.',
  );

  // ---------- 증빙 보관함 카드 ----------
  static const vaultCardTitle = L10nText(
    ko: '사업주 공식 증빙 보관함',
    en: 'Employer document vault',
    zh: '雇主正式凭证保管箱',
    vi: 'Kho giấy tờ của chủ sử dụng',
  );
  static const vaultContract = L10nText(
    ko: '근로계약서',
    en: 'Employment contract',
    zh: '劳动合同',
    vi: 'Hợp đồng lao động',
  );
  static const vaultPayslip = L10nText(
    ko: '임금명세서',
    en: 'Payslip',
    zh: '工资单',
    vi: 'Phiếu lương',
  );
  static const vaultRegistered = L10nText(
    ko: '등록됨',
    en: 'Registered',
    zh: '已登记',
    vi: 'Đã đăng ký',
  );
  static const vaultNotRegistered = L10nText(
    ko: '등록 전',
    en: 'Not yet',
    zh: '尚未登记',
    vi: 'Chưa đăng ký',
  );

  // ---------- 하단 ----------
  static const bottomNote = L10nText(
    ko: '수원시 이주민 노동·생활 정보 · Local Bridge',
    en: 'Suwon migrant worker & daily-life information · Local Bridge',
    zh: '水原市移民劳动·生活信息 · Local Bridge',
    vi: 'Thông tin lao động & đời sống người di cư Suwon · Local Bridge',
  );

  static String workClockedInAt(AppLanguage lang, String time, String status) {
    switch (lang) {
      case AppLanguage.ko:
        return '$time 출근 · $status';
      case AppLanguage.en:
        return 'Clocked in $time · $status';
      case AppLanguage.zh:
        return '$time 上班 · $status';
      case AppLanguage.vi:
        return 'Vào ca $time · $status';
    }
  }

  // ---------- 내 비자 ----------
  static const visaSampleLabel = L10nText(
    ko: '예시: E-9 비전문취업',
    en: 'Example: E-9 Non-professional',
    zh: '示例：E-9 非专业就业',
    vi: 'Ví dụ: E-9 Lao động phổ thông',
  );

  // ---------- 날씨 ----------
  static String weatherHeatAlert(AppLanguage lang, int feelsLikeC) {
    switch (lang) {
      case AppLanguage.ko:
        return '체감 $feelsLikeC° 이상 · 야외 작업 시 휴식 필요';
      case AppLanguage.en:
        return 'Feels like $feelsLikeC°+ · take breaks during outdoor work';
      case AppLanguage.zh:
        return '体感$feelsLikeC°以上 · 户外作业请注意休息';
      case AppLanguage.vi:
        return 'Cảm nhận trên $feelsLikeC° · nghỉ ngơi khi làm ngoài trời';
    }
  }

  // ---------- 진행 중인 사건 ----------
  static const caseLabel = L10nText(
    ko: '진행 중',
    en: 'In progress',
    zh: '进行中',
    vi: 'Đang xử lý',
  );
  static const caseTitleWage = L10nText(
    ko: '임금체불 진정',
    en: 'Unpaid wage complaint',
    zh: '欠薪申诉',
    vi: 'Khiếu nại nợ lương',
  );
  static const caseDemoTag = L10nText(
    ko: '데모',
    en: 'Demo',
    zh: '演示',
    vi: 'Demo',
  );

  static String caseBadge(AppLanguage lang, int step, int total) {
    switch (lang) {
      case AppLanguage.ko:
        return '$step / $total 단계';
      case AppLanguage.en:
        return 'Stage $step of $total';
      case AppLanguage.zh:
        return '第$step / $total阶段';
      case AppLanguage.vi:
        return 'Giai đoạn $step / $total';
    }
  }

  static String caseNow(AppLanguage lang, String stage, String date) {
    switch (lang) {
      case AppLanguage.ko:
        return '지금은 $stage 단계입니다 · $date';
      case AppLanguage.en:
        return 'Currently at the $stage stage · $date';
      case AppLanguage.zh:
        return '目前处于$stage阶段 · $date';
      case AppLanguage.vi:
        return 'Hiện đang ở giai đoạn $stage · $date';
    }
  }

  static const caseStageInvestigation = L10nText(
    ko: '출석 조사',
    en: 'inspector meeting',
    zh: '出席调查',
    vi: 'điều tra có mặt',
  );

  // ---------- AI 가이드 ----------
  static const aiTitle = L10nText(
    ko: 'AI 가이드',
    en: 'AI guide',
    zh: 'AI向导',
    vi: 'Hướng dẫn AI',
  );
  static const aiQuestion = L10nText(
    ko: '무엇이 궁금하신가요?',
    en: 'What would you like to ask?',
    zh: '您想了解什么？',
    vi: 'Bạn muốn hỏi điều gì?',
  );
  static const aiChipWage = L10nText(
    ko: '월급을 못 받았어요',
    en: "I wasn't paid",
    zh: '没收到工资',
    vi: 'Tôi chưa nhận lương',
  );
  static const aiChipInjury = L10nText(
    ko: '일하다 다쳤어요',
    en: 'I got hurt at work',
    zh: '工作中受伤了',
    vi: 'Tôi bị thương khi làm việc',
  );
  static const aiChipVisa = L10nText(
    ko: '비자 연장',
    en: 'Visa extension',
    zh: '签证延期',
    vi: 'Gia hạn visa',
  );

  // ---------- 가까운 도움처 ----------
  static const orgTitle = L10nText(
    ko: '가까운 도움처',
    en: 'Nearby support',
    zh: '附近的帮助机构',
    vi: 'Hỗ trợ gần đây',
  );
  static const orgName = L10nText(
    ko: '수원시외국인복지센터',
    en: 'Suwon Migrant Welfare Center',
    zh: '水原市外国人福利中心',
    vi: 'Trung tâm phúc lợi người nước ngoài Suwon',
  );
  static const orgDesc = L10nText(
    ko: '베트남어 상담 가능 · 2.1km',
    en: 'Vietnamese counselling available · 2.1km',
    zh: '可提供越南语咨询 · 2.1km',
    vi: 'Có tư vấn tiếng Việt · 2.1km',
  );
  static const orgCallButton = L10nText(
    ko: '전화',
    en: 'Call',
    zh: '致电',
    vi: 'Gọi',
  );

  static String orgCallToast(AppLanguage lang, String phone) {
    switch (lang) {
      case AppLanguage.ko:
        return '$phone (으)로 직접 전화해 주세요';
      case AppLanguage.en:
        return 'Please call $phone directly';
      case AppLanguage.zh:
        return '请直接拨打 $phone';
      case AppLanguage.vi:
        return 'Vui lòng gọi trực tiếp tới $phone';
    }
  }
}
