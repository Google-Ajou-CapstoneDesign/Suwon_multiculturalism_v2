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
  static const workRingLabel = L10nText(
    ko: '실근무',
    en: 'Worked',
    zh: '实际工时',
    vi: 'Đã làm',
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
  static const visaTitle = L10nText(
    ko: '내 비자',
    en: 'My visa',
    zh: '我的签证',
    vi: 'Visa của tôi',
  );
  static const visaDaysLeft = L10nText(
    ko: 'DAYS LEFT',
    en: 'DAYS LEFT',
    zh: 'DAYS LEFT',
    vi: 'DAYS LEFT',
  );
  static const visaDemoTag = L10nText(
    ko: '데모',
    en: 'Demo',
    zh: '演示',
    vi: 'Demo',
  );
  static const visaDemoHint = L10nText(
    ko: '로그인하면 내 정보로 표시돼요',
    en: 'Log in to see your own info here',
    zh: '登录后将显示您本人的信息',
    vi: 'Đăng nhập để xem thông tin của bạn',
  );
  static const visaSampleLabel = L10nText(
    ko: '예시: E-9 비전문취업',
    en: 'Example: E-9 Non-professional',
    zh: '示例：E-9 非专业就业',
    vi: 'Ví dụ: E-9 Lao động phổ thông',
  );

  static String visaExpiry(AppLanguage lang, int dDay) {
    switch (lang) {
      case AppLanguage.ko:
        return '만료 D-$dDay';
      case AppLanguage.en:
        return 'Expires in D-$dDay';
      case AppLanguage.zh:
        return '距到期 D-$dDay';
      case AppLanguage.vi:
        return 'Hết hạn D-$dDay';
    }
  }

  // ---------- 날씨 ----------
  static String weatherFeelsLike(AppLanguage lang, int feelsLikeC) {
    switch (lang) {
      case AppLanguage.ko:
        return '체감 $feelsLikeC°';
      case AppLanguage.en:
        return 'Feels like $feelsLikeC°';
      case AppLanguage.zh:
        return '体感 $feelsLikeC°';
      case AppLanguage.vi:
        return 'Cảm nhận $feelsLikeC°';
    }
  }

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
