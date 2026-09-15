import '../../../core/app_language.dart';

/// 설정 탭 UI 문구.
class SettingsStrings {
  SettingsStrings._();

  static const eyebrow = L10nText(
    ko: 'MY SETTINGS',
    en: 'MY SETTINGS',
    zh: 'MY SETTINGS',
    vi: 'MY SETTINGS',
    uz: "MENING SOZLAMALARIM",
  );
  static const tabTitle = L10nText(
    ko: '설정',
    en: 'Settings',
    zh: '设置',
    vi: 'Cài đặt',
    uz: "Sozlamalar",
  );

  // ---------- 프로필 요약 카드 ----------
  static const guestName = L10nText(
    ko: '게스트',
    en: 'Guest',
    zh: '访客',
    vi: 'Khách',
    uz: "Mehmon",
  );
  static const guestSubtitle = L10nText(
    ko: '모든 기록을 안전하게 이어가세요.',
    en: 'Keep all your records safely.',
    zh: '安全地延续您的所有记录。',
    vi: 'Giữ an toàn mọi bản ghi của bạn.',
    uz: "Barcha yozuvlaringizni xavfsiz saqlang.",
  );
  static const loginButton = L10nText(
    ko: '로그인',
    en: 'Log in',
    zh: '登录',
    vi: 'Đăng nhập',
    uz: "Kirish",
  );

  // ---------- 기본 설정 카드 ----------
  static const languageLabel = L10nText(
    ko: '언어 설정',
    en: 'Language',
    zh: '语言设置',
    vi: 'Ngôn ngữ',
    uz: "Til",
  );
  static const visaLabel = L10nText(
    ko: '비자 정보',
    en: 'Visa info',
    zh: '签证信息',
    vi: 'Thông tin visa',
    uz: "Viza maʼlumotlari",
  );
  static const profileLabel = L10nText(
    ko: '프로필',
    en: 'Profile',
    zh: '个人资料',
    vi: 'Hồ sơ',
    uz: "Profil",
  );
  static const notificationLabel = L10nText(
    ko: '알림 설정',
    en: 'Notifications',
    zh: '通知设置',
    vi: 'Thông báo',
    uz: "Bildirishnomalar",
  );
  static const notificationOn = L10nText(
    ko: '켜짐',
    en: 'On',
    zh: '已开启',
    vi: 'Bật',
    uz: "Yoqish",
  );
  static const notificationOff = L10nText(
    ko: '꺼짐',
    en: 'Off',
    zh: '已关闭',
    vi: 'Tắt',
    uz: "Oʻchirish",
  );
  static const notificationToast = L10nText(
    ko: '알림 설정은 이 기기에만 저장돼요.',
    en: 'Notification settings are saved on this device only.',
    zh: '通知设置仅保存在此设备上。',
    vi: 'Cài đặt thông báo chỉ được lưu trên thiết bị này.',
    uz: "Bildirishnoma sozlamalari faqat shu qurilmada saqlanadi.",
  );
  static const visaNotSet = L10nText(
    ko: '미설정',
    en: 'Not set',
    zh: '未设置',
    vi: 'Chưa đặt',
    uz: "Oʻrnatilmagan",
  );

  // ---------- 부가 설정 카드 ----------
  static const vaultLabel = L10nText(
    ko: '내 증빙 보관함',
    en: 'My document vault',
    zh: '我的证明保管箱',
    vi: 'Kho tài liệu của tôi',
    uz: "Mening hujjatlar omborim",
  );
  static const closeButton = L10nText(
    ko: '닫기',
    en: 'Close',
    zh: '关闭',
    vi: 'Đóng',
    uz: "Yopish",
  );
  static const guideLabel = L10nText(
    ko: '사용 가이드',
    en: 'User guide',
    zh: '使用说明',
    vi: 'Hướng dẫn sử dụng',
    uz: "Foydalanuvchi qoʻllanmasi",
  );
  static const aiGuideLabel = L10nText(
    ko: 'AI 가이드',
    en: 'AI guide',
    zh: 'AI向导',
    vi: 'Hướng dẫn AI',
    uz: "AI yoʻriqnomasi",
  );

  // ---------- 프로필 편집 모달 ----------
  static const profileEditTitle = L10nText(
    ko: '프로필',
    en: 'Profile',
    zh: '个人资料',
    vi: 'Hồ sơ',
    uz: "Profil",
  );
  static const nameFieldLabel = L10nText(
    ko: '이름',
    en: 'Name',
    zh: '姓名',
    vi: 'Họ tên',
    uz: "Ism",
  );
  static const nationalityFieldLabel = L10nText(
    ko: '국적',
    en: 'Nationality',
    zh: '国籍',
    vi: 'Quốc tịch',
    uz: "Millat",
  );
  static const nationalityPlaceholder = L10nText(
    ko: '국적을 선택해주세요',
    en: 'Select your nationality',
    zh: '请选择国籍',
    vi: 'Chọn quốc tịch của bạn',
    uz: "Millatingizni tanlang",
  );
  static const saveButton = L10nText(
    ko: '저장',
    en: 'Save',
    zh: '保存',
    vi: 'Lưu',
    uz: "Saqlash",
  );
  static const profileSaved = L10nText(
    ko: '저장했어요.',
    en: 'Saved.',
    zh: '已保存。',
    vi: 'Đã lưu.',
    uz: "Saqlandi.",
  );
  static const errorName = L10nText(
    ko: '이름을 입력해주세요',
    en: 'Please enter your name',
    zh: '请输入姓名',
    vi: 'Vui lòng nhập họ tên',
    uz: "Iltimos, ismingizni kiriting",
  );
  static const errorCustomVisa = L10nText(
    ko: '체류자격을 입력해주세요',
    en: 'Please enter your visa status',
    zh: '请输入居留资格',
    vi: 'Vui lòng nhập tư cách lưu trú',
    uz: "Iltimos, viza holatingizni kiriting",
  );

  // ---------- 로그아웃 / 하단 ----------
  static const logoutButton = L10nText(
    ko: '로그아웃',
    en: 'Log out',
    zh: '登出',
    vi: 'Đăng xuất',
    uz: "Chiqish",
  );
  static const bottomNote = L10nText(
    ko: 'Local Bridge\n수원시 이주민 노동·생활 정보',
    en: 'Local Bridge\nSuwon migrant worker & daily-life information',
    zh: 'Local Bridge\n水原市移民劳动·生活信息',
    vi: 'Local Bridge\nThông tin lao động & đời sống người di cư Suwon',
    uz: "Local Bridge\nSuvonlik migrant ishchilar va kundalik hayot maʼlumotlari",
  );
}
