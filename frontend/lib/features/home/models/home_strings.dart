import '../../../core/app_language.dart';

/// 홈 탭 UI 문구. html_files/홈화면.html의 위젯 그리드 홈 리디자인을 옮겼다.
class HomeStrings {
  HomeStrings._();

  static const tabTitle = L10nText(
    ko: '홈',
    en: 'Home',
    tr: "Ana Sayfa",
    zh: '首页',
    vi: 'Trang chủ',
    uz: "Bosh sahifa",
  );
  static const visaNotSet = L10nText(
    ko: '체류자격 미설정',
    en: 'Visa status not set',
    tr: "Vize durumu ayarlanmadı",
    zh: '未设置居留资格',
    vi: 'Chưa đặt tư cách lưu trú',
    uz: "Viza holati oʻrnatilmagan",
  );

  static const wageNavTitle = L10nText(
    ko: '임금체불 진정 안내',
    en: 'Unpaid wage report guide',
    tr: "Ödenmemiş ücret raporu rehberi",
    zh: '拖欠工资申诉指南',
    vi: 'Hướng dẫn khiếu nại nợ lương',
    uz: "Toʻlanmagan ish haqi hisoboti boʻyicha qoʻllanma",
  );
  static const injuryNavTitle = L10nText(
    ko: '산재처리 신청 안내',
    en: 'Workplace injury claim guide',
    tr: "İş kazası tazminat rehberi",
    zh: '工伤申报指南',
    vi: 'Hướng dẫn yêu cầu bồi thường tai nạn lao động',
    uz: "Ish joyidagi jarohat boʻyicha daʼvo qoʻllanmasi",
  );

  // ---------- 인사말 ----------
  static const greetingEyebrow = L10nText(
    ko: 'MY LOCAL BRIDGE',
    en: 'MY LOCAL BRIDGE',
    tr: "YEREL KÖPRÜM",
    zh: 'MY LOCAL BRIDGE',
    vi: 'MY LOCAL BRIDGE',
    uz: "MENING MAHALLIY KOʻPRIGIM",
  );
  static const greetingSubtitle = L10nText(
    ko: '나의 근무와 생활 정보를 한곳에서 확인하세요.',
    en: 'Check your work and daily-life info all in one place.',
    tr: "İş ve günlük yaşam bilgilerinizi tek bir yerden kontrol edin.",
    zh: '在这里一站式查看您的工作和生活信息。',
    vi: 'Xem thông tin công việc và đời sống của bạn ở một nơi.',
    uz: "Ish va kundalik hayot maʼlumotlaringizni bir joyda tekshiring.",
  );

  static const greetingMorning = L10nText(
    ko: '좋은 아침이에요,',
    en: 'Good morning,',
    tr: "Günaydın,",
    zh: '早上好，',
    vi: 'Chào buổi sáng,',
    uz: "Xayrli tong,",
  );
  static const greetingAfternoon = L10nText(
    ko: '좋은 오후예요,',
    en: 'Good afternoon,',
    tr: "Tünaydın,",
    zh: '下午好，',
    vi: 'Chào buổi chiều,',
    uz: "Xayrli kun,",
  );
  static const greetingEvening = L10nText(
    ko: '좋은 저녁이에요,',
    en: 'Good evening,',
    tr: "İyi akşamlar,",
    zh: '晚上好，',
    vi: 'Chào buổi tối,',
    uz: "Xayrli kech,",
  );
  static const guestName = L10nText(
    ko: '게스트',
    en: 'Guest',
    tr: "Misafir",
    zh: '访客',
    vi: 'Khách',
    uz: "Mehmon",
  );

  // ---------- 오늘의 근무 ----------
  static const workTitle = L10nText(
    ko: '오늘의 근무',
    en: "Today's work",
    tr: "Bugünün işi",
    zh: '今日出勤',
    vi: 'Công việc hôm nay',
    uz: "Bugungi ish",
  );
  static const workStatusWorking = L10nText(
    ko: '근무 중',
    en: 'Working',
    tr: "Çalışıyor",
    zh: '工作中',
    vi: 'Đang làm việc',
    uz: "Ishlamoqda",
  );
  static const workStatusDone = L10nText(
    ko: '근무 종료',
    en: 'Finished',
    tr: "Bitti",
    zh: '已下班',
    vi: 'Đã kết thúc',
    uz: "Tugallandi",
  );
  static const workStatusBeforeStart = L10nText(
    ko: '출근 전',
    en: 'Not clocked in yet',
    tr: "Henüz giriş yapılmadı",
    zh: '尚未上班',
    vi: 'Chưa vào ca',
    uz: "Hali ishga kirilmagan",
  );
  static const workGpsVerified = L10nText(
    ko: '위치 인증 완료',
    en: 'Location verified',
    tr: "Konum doğrulandı",
    zh: '已完成位置认证',
    vi: 'Đã xác thực vị trí',
    uz: "Manzil tasdiqlandi",
  );
  static const workGpsVerifyButton = L10nText(
    ko: '위치 인증하기',
    en: 'Verify location',
    tr: "Konumu doğrula",
    zh: '认证位置',
    vi: 'Xác minh vị trí',
    uz: "Manzilni tasdiqlash",
  );
  static const workGpsServiceDisabled = L10nText(
    ko: '기기의 위치 서비스가 꺼져 있어요. 설정에서 켜주세요.',
    en: 'Your device location service is off. Please turn it on in settings.',
    tr: "Cihazınızın konum servisi kapalı. Lütfen ayarlardan açın.",
    zh: '设备的位置服务已关闭，请在设置中打开。',
    vi: 'Dịch vụ vị trí đang tắt. Vui lòng bật trong cài đặt.',
    uz: "Qurilmangizning joylashuv xizmati oʻchiq. Iltimos, sozlamalarda yoqing.",
  );
  static const workGpsPermissionDenied = L10nText(
    ko: '위치 권한이 필요해요. 브라우저나 기기 설정에서 위치 접근을 허용해주세요.',
    en: 'Location permission is required. Please allow location access.',
    tr: "Konum izni gerekli. Lütfen konum erişimine izin verin.",
    zh: '需要位置权限，请允许访问位置信息。',
    vi: 'Cần quyền vị trí. Vui lòng cho phép truy cập vị trí.',
    uz: "Manzilga ruxsat talab qilinadi. Iltimos, manzilga kirishga ruxsat bering.",
  );
  static const workGpsVerifyFailed = L10nText(
    ko: '위치 정보를 받았지만 인증에 실패했어요. 다시 시도해주세요.',
    en: 'Location verification failed. Please try again.',
    tr: "Konum doğrulama başarısız oldu. Lütfen tekrar deneyin.",
    zh: '位置认证失败，请重试。',
    vi: 'Xác minh vị trí thất bại. Vui lòng thử lại.',
    uz: "Manzilni tekshirish muvaffaqiyatsiz tugadi. Iltimos, qayta urinib koʻring.",
  );
  static const workGpsVerifyError = L10nText(
    ko: '위치 인증 중 오류가 발생했어요. 잠시 후 다시 시도해주세요.',
    en: 'Something went wrong during location verification. Please try again.',
    tr: "Konum doğrulaması sırasında bir sorun oluştu. Lütfen tekrar deneyin.",
    zh: '位置认证时发生错误，请稍后重试。',
    vi: 'Đã xảy ra lỗi khi xác minh vị trí. Vui lòng thử lại.',
    uz: "Manzilni tekshirishda xatolik yuz berdi. Iltimos, qayta urinib koʻring.",
  );
  static const workClockInButton = L10nText(
    ko: '출근 기록하기',
    en: 'Clock in',
    tr: "Giriş yap",
    zh: '记录上班',
    vi: 'Ghi giờ vào',
    uz: "Ishga kirish",
  );
  static const workClockOutButton = L10nText(
    ko: '퇴근 기록하기',
    en: 'Clock out',
    tr: "Çıkış yap",
    zh: '记录下班',
    vi: 'Ghi giờ ra',
    uz: "Ishdan chiqish",
  );
  static const workDoneButton = L10nText(
    ko: '오늘 기록 완료',
    en: "Today's record complete",
    tr: "Bugünün kaydı tamamlandı",
    zh: '今日记录已完成',
    vi: 'Đã hoàn tất ghi nhận',
    uz: "Bugungi yozuv yakunlandi",
  );
  static const workMemoButton = L10nText(
    ko: '근무 기록하기',
    en: 'Log work',
    tr: "İş kaydı yap",
    zh: '记录工作',
    vi: 'Ghi nhận công việc',
    uz: "Ishni qayd etish",
  );

  static const workClockLabel = L10nText(
    ko: '출근',
    en: 'Clock in',
    tr: "Giriş yap",
    zh: '上班',
    vi: 'Vào ca',
    uz: "Ishga kirish",
  );
  static const workClockOutLabel = L10nText(
    ko: '퇴근',
    en: 'Clock out',
    tr: "Çıkış yap",
    zh: '下班',
    vi: 'Tan ca',
    uz: "Ishdan chiqish",
  );
  static const workBreakLabel = L10nText(
    ko: '휴게',
    en: 'Break',
    tr: "Mola",
    zh: '休息',
    vi: 'Nghỉ',
    uz: "Tanaffus",
  );
  static const workHoursUnit = L10nText(
    ko: '시간',
    en: 'hrs',
    tr: "saat",
    zh: '小时',
    vi: 'giờ',
    uz: "soat",
  );

  // ---------- 이번 달 근무 ----------
  static const monthlyTitle = L10nText(
    ko: '이번 달 근무',
    en: "This month's work",
    tr: "Bu ayki çalışma",
    zh: '本月出勤',
    vi: 'Công việc tháng này',
    uz: "Bu oydagi ish",
  );
  static const monthlyDaysLabel = L10nText(
    ko: '근무일',
    en: 'Days worked',
    tr: "Çalışılan günler",
    zh: '出勤天数',
    vi: 'Số ngày làm',
    uz: "Ishlangan kunlar",
  );
  static const monthlyHoursLabel = L10nText(
    ko: '총 근무시간',
    en: 'Total hours',
    tr: "Toplam saat",
    zh: '总工时',
    vi: 'Tổng giờ làm',
    uz: "Jami soatlar",
  );
  static const monthlyWageLabel = L10nText(
    ko: '이번 달 임금',
    en: "This month's wages",
    tr: "Bu ayki maaş",
    zh: '本月工资',
    vi: 'Lương tháng này',
    uz: "Bu oydagi ish haqi",
  );
  static const monthlyViewAll = L10nText(
    ko: '전체 기록 →',
    en: 'View all →',
    tr: "Tümünü gör →",
    zh: '查看全部 →',
    vi: 'Xem tất cả →',
    uz: "Hammasini koʻrish →",
  );

  // ---------- 빠른 접근 ----------
  static const quickAccessTitle = L10nText(
    ko: '빠르게 이용하세요',
    en: 'Quick access',
    tr: "Hızlı erişim",
    zh: '快速使用',
    vi: 'Truy cập nhanh',
    uz: "Tezkor kirish",
  );
  static const quickWorklog = L10nText(
    ko: '근무기록장',
    en: 'Work log',
    tr: "İş günlüğü",
    zh: '工作记录本',
    vi: 'Nhật ký làm việc',
    uz: "Ish jurnali",
  );
  static const quickWageCalc = L10nText(
    ko: '임금계산기',
    en: 'Wage calculator',
    tr: "Ücret hesaplayıcı",
    zh: '工资计算器',
    vi: 'Máy tính lương',
    uz: "Ish haqi kalkulyatori",
  );
  static const quickNavigator = L10nText(
    ko: '네비게이터',
    en: 'Navigator',
    tr: "Rehber",
    zh: '导航',
    vi: 'Điều hướng',
    uz: "Navigator",
  );
  static const quickVault = L10nText(
    ko: '내 증빙 보관함',
    en: 'My document vault',
    tr: "Belge kasam",
    zh: '我的证明保管箱',
    vi: 'Kho tài liệu của tôi',
    uz: "Mening hujjatlar omborim",
  );

  // ---------- 도움 가이드 ----------
  static const helpGuidesTitle = L10nText(
    ko: '도움이 필요할 때',
    en: 'When you need help',
    tr: "Yardıma ihtiyacınız olduğunda",
    zh: '需要帮助时',
    vi: 'Khi bạn cần giúp đỡ',
    uz: "Yordam kerak boʻlganda",
  );
  static const wageNavDesc = L10nText(
    ko: '단계별로 진정서까지 안내해드려요.',
    en: 'Step-by-step guidance all the way to filing a report.',
    tr: "Raporlama sürecine kadar adım adım rehberlik.",
    zh: '逐步引导您完成申诉书。',
    vi: 'Hướng dẫn từng bước đến khi nộp đơn khiếu nại.',
    uz: "Hisobot berishgacha bosqichma-bosqich yoʻriqnoma.",
  );
  static const injuryNavDesc = L10nText(
    ko: '단계별로 요양급여 신청까지 안내해드려요.',
    en: 'Step-by-step guidance all the way to your benefit claim.',
    tr: "Yardım talebinize kadar adım adım rehberlik.",
    zh: '逐步引导您完成疗养补偿申请。',
    vi: 'Hướng dẫn từng bước đến khi yêu cầu trợ cấp.',
    uz: "Nafaqangizni talab qilishgacha bosqichma-bosqich yoʻriqnoma.",
  );

  // ---------- 증빙 보관함 카드 ----------
  static const vaultCardTitle = L10nText(
    ko: '사업주 공식 증빙 보관함',
    en: 'Employer document vault',
    tr: "İşveren belge kasası",
    zh: '雇主正式凭证保管箱',
    vi: 'Kho giấy tờ của chủ sử dụng',
    uz: "Ish beruvchining hujjatlar ombori",
  );
  static const vaultContract = L10nText(
    ko: '근로계약서',
    en: 'Employment contract',
    tr: "İş sözleşmesi",
    zh: '劳动合同',
    vi: 'Hợp đồng lao động',
    uz: "Mehnat shartnomasi",
  );
  static const vaultPayslip = L10nText(
    ko: '임금명세서',
    en: 'Payslip',
    tr: "Maaş bordrosu",
    zh: '工资单',
    vi: 'Phiếu lương',
    uz: "Ish haqi varagʻi",
  );
  static const vaultRegistered = L10nText(
    ko: '등록됨',
    en: 'Registered',
    tr: "Kayıtlı",
    zh: '已登记',
    vi: 'Đã đăng ký',
    uz: "Roʻyxatdan oʻtgan",
  );
  static const vaultNotRegistered = L10nText(
    ko: '등록 전',
    en: 'Not yet',
    tr: "Henüz değil",
    zh: '尚未登记',
    vi: 'Chưa đăng ký',
    uz: "Hali yoʻq",
  );

  // ---------- 하단 ----------
  static const bottomNote = L10nText(
    ko: '수원시 이주민 노동·생활 정보 · Local Bridge',
    en: 'Suwon migrant worker & daily-life information · Local Bridge',
    tr: "Suwon göçmen işçi ve günlük yaşam bilgileri · Local Bridge",
    zh: '水原市移民劳动·生活信息 · Local Bridge',
    vi: 'Thông tin lao động & đời sống người di cư Suwon · Local Bridge',
    uz: "Suvonlik migrant ishchi va kundalik hayot maʼlumotlari · Local Bridge",
  );

  static String workClockedInAt(AppLanguage lang, String time, String status) {
    switch (lang) {
      case AppLanguage.ko:
        return '$time 출근 · $status';
      case AppLanguage.uz:
        return "Ish boshlandi $time · $status";
      case AppLanguage.en:
        return 'Clocked in $time · $status';
      case AppLanguage.tr:
        return "Giriş yapıldı $time · $status";
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
    tr: "Örnek: E-9 Niteliksiz",
    zh: '示例：E-9 非专业就业',
    vi: 'Ví dụ: E-9 Lao động phổ thông',
    uz: "Misol: E-9 Malakasiz",
  );

  // ---------- 날씨 ----------
  static String weatherHeatAlert(AppLanguage lang, int feelsLikeC) {
    switch (lang) {
      case AppLanguage.ko:
        return '체감 $feelsLikeC° 이상 · 야외 작업 시 휴식 필요';
      case AppLanguage.uz:
        return "$feelsLikeC°+ ga oʻxshaydi · ochiq havoda ishlashda tanaffus qiling";
      case AppLanguage.en:
        return 'Feels like $feelsLikeC°+ · take breaks during outdoor work';
      case AppLanguage.tr:
        return "Hissedilen $feelsLikeC°+ · dışarıda çalışırken mola verin";
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
    tr: "Devam ediyor",
    zh: '进行中',
    vi: 'Đang xử lý',
    uz: "Jarayonda",
  );
  static const caseTitleWage = L10nText(
    ko: '임금체불 진정',
    en: 'Unpaid wage complaint',
    tr: "Ödenmemiş ücret şikayeti",
    zh: '欠薪申诉',
    vi: 'Khiếu nại nợ lương',
    uz: "Toʻlanmagan ish haqi shikoyati",
  );
  static const caseDemoTag = L10nText(
    ko: '데모',
    en: 'Demo',
    tr: "Demo",
    zh: '演示',
    vi: 'Demo',
    uz: "Demo",
  );

  static String caseBadge(AppLanguage lang, int step, int total) {
    switch (lang) {
      case AppLanguage.ko:
        return '$step / $total 단계';
      case AppLanguage.uz:
        return "$total dan $step bosqich";
      case AppLanguage.en:
        return 'Stage $step of $total';
      case AppLanguage.tr:
        return "$total aşamasından $step. aşama";
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
      case AppLanguage.uz:
        return "Hozirda $stage bosqichda · $date";
      case AppLanguage.en:
        return 'Currently at the $stage stage · $date';
      case AppLanguage.tr:
        return "Şu anda $stage aşamasında · $date";
      case AppLanguage.zh:
        return '目前处于$stage阶段 · $date';
      case AppLanguage.vi:
        return 'Hiện đang ở giai đoạn $stage · $date';
    }
  }

  static const caseStageInvestigation = L10nText(
    ko: '출석 조사',
    en: 'inspector meeting',
    tr: "müfettiş toplantısı",
    zh: '出席调查',
    vi: 'điều tra có mặt',
    uz: "inspektor uchrashuvi",
  );

  // ---------- AI 가이드 ----------
  static const aiTitle = L10nText(
    ko: 'AI 가이드',
    en: 'AI guide',
    tr: "Yapay zeka rehberi",
    zh: 'AI向导',
    vi: 'Hướng dẫn AI',
    uz: "AI yoʻriqnomasi",
  );
  static const aiQuestion = L10nText(
    ko: '무엇이 궁금하신가요?',
    en: 'What would you like to ask?',
    tr: "Ne sormak istersiniz?",
    zh: '您想了解什么？',
    vi: 'Bạn muốn hỏi điều gì?',
    uz: "Nima soʻramoqchisiz?",
  );
  static const aiChipWage = L10nText(
    ko: '월급을 못 받았어요',
    en: "I wasn't paid",
    tr: "Bana ödeme yapılmadı",
    zh: '没收到工资',
    vi: 'Tôi chưa nhận lương',
    uz: "Menga haq toʻlanmadi",
  );
  static const aiChipInjury = L10nText(
    ko: '일하다 다쳤어요',
    en: 'I got hurt at work',
    tr: "İşte yaralandım",
    zh: '工作中受伤了',
    vi: 'Tôi bị thương khi làm việc',
    uz: "Ishda jarohat oldim",
  );
  static const aiChipVisa = L10nText(
    ko: '비자 연장',
    en: 'Visa extension',
    tr: "Vize uzatma",
    zh: '签证延期',
    vi: 'Gia hạn visa',
    uz: "Viza muddatini uzaytirish",
  );

  // ---------- 가까운 도움처 ----------
  static const orgTitle = L10nText(
    ko: '가까운 도움처',
    en: 'Nearby support',
    tr: "Yakındaki destek",
    zh: '附近的帮助机构',
    vi: 'Hỗ trợ gần đây',
    uz: "Yaqin atrofdagi yordam",
  );
  static const orgName = L10nText(
    ko: '수원시외국인복지센터',
    en: 'Suwon Migrant Welfare Center',
    tr: "Suwon Göçmen Refah Merkezi",
    zh: '水原市外国人福利中心',
    vi: 'Trung tâm phúc lợi người nước ngoài Suwon',
    uz: "Suvon migrantlar farovonlik markazi",
  );
  static const orgDesc = L10nText(
    ko: '베트남어 상담 가능 · 2.1km',
    en: 'Vietnamese counselling available · 2.1km',
    tr: "Vietnamca danışmanlık mevcut · 2.1km",
    zh: '可提供越南语咨询 · 2.1km',
    vi: 'Có tư vấn tiếng Việt · 2.1km',
    uz: "Vyetnam tilida maslahat beriladi · 2.1km",
  );
  static const orgCallButton = L10nText(
    ko: '전화',
    en: 'Call',
    tr: "Ara",
    zh: '致电',
    vi: 'Gọi',
    uz: "Qoʻngʻiroq qilish",
  );

  static String orgCallToast(AppLanguage lang, String phone) {
    switch (lang) {
      case AppLanguage.ko:
        return '$phone (으)로 직접 전화해 주세요';
      case AppLanguage.uz:
        return "Iltimos, bevosita $phone ga qoʻngʻiroq qiling";
      case AppLanguage.en:
        return 'Please call $phone directly';
      case AppLanguage.tr:
        return "Lütfen doğrudan $phone numarasını arayın";
      case AppLanguage.zh:
        return '请直接拨打 $phone';
      case AppLanguage.vi:
        return 'Vui lòng gọi trực tiếp tới $phone';
    }
  }
}
