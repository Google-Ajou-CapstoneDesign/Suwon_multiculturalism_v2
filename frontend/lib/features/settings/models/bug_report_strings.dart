import '../../../core/app_language.dart';

class BugReportStrings {
  static const title = L10nText(
    ko: '버그 리포트',
    en: 'Report a bug',
    zh: '报告问题',
    vi: 'Báo cáo lỗi',
    uz: "Xato haqida xabar berish",
  );
  static const subject = L10nText(
    ko: '제목',
    en: 'Subject',
    zh: '标题',
    vi: 'Tiêu đề',
    uz: "Mavzu",
  );
  static const description = L10nText(
    ko: '어떤 문제가 발생했나요?',
    en: 'What went wrong?',
    zh: '发生了什么问题？',
    vi: 'Bạn gặp vấn đề gì?',
    uz: "Nima notoʻgʻri ketdi?",
  );
  static const hint = L10nText(
    ko: '문제가 발생한 화면과 순서, 예상한 동작을 알려주세요.',
    en: 'Describe the screen, steps to reproduce, and expected behavior.',
    zh: '请描述出错页面、操作步骤和预期结果。',
    vi: 'Mô tả màn hình, các bước gây lỗi và kết quả mong đợi.',
    uz: "Ekranni, takrorlash bosqichlarini va kutilgan xatti-harakatni tasvirlang.",
  );
  static const required = L10nText(
    ko: '내용을 입력해주세요.',
    en: 'Please fill in this field.',
    zh: '请填写此项。',
    vi: 'Vui lòng điền mục này.',
    uz: "Iltimos, ushbu maydonni toʻldiring.",
  );
  static const open = L10nText(
    ko: '메일 앱에서 보내기',
    en: 'Send using email app',
    zh: '通过邮件应用发送',
    vi: 'Gửi bằng ứng dụng email',
    uz: "Elektron pochta ilovasi orqali yuborish",
  );
  static const note = L10nText(
    ko: '메일 작성창에서 내용을 확인하고 전송해주세요.',
    en: 'Review and send the report in your email app.',
    zh: '请在邮件应用中确认内容并发送。',
    vi: 'Kiểm tra và gửi báo cáo trong ứng dụng email.',
    uz: "Hisobotni elektron pochta ilovangizda koʻrib chiqing va yuboring.",
  );
  static const copy = L10nText(
    ko: '내용 복사',
    en: 'Copy report',
    zh: '复制报告',
    vi: 'Sao chép báo cáo',
    uz: "Hisobotni nusxalash",
  );
  static const copied = L10nText(
    ko: '수신 주소와 내용을 복사했습니다.',
    en: 'Recipient and report copied.',
    zh: '已复制收件地址和报告。',
    vi: 'Đã sao chép địa chỉ nhận và báo cáo.',
    uz: "Qabul qiluvchi va hisobot nusxalandi.",
  );
  static const copyFailed = L10nText(
    ko: '복사하지 못했습니다. 입력한 내용을 직접 복사해주세요.',
    en: 'Could not copy. Please copy the text manually.',
    zh: '无法复制，请手动复制内容。',
    vi: 'Không thể sao chép. Vui lòng sao chép thủ công.',
    uz: "Nusxalashning iloji boʻlmadi. Iltimos, matnni qoʻlda nusxalang.",
  );
  static const failed = L10nText(
    ko: '메일 앱을 열지 못했습니다. 내용을 복사해 아래 주소로 보내주세요.',
    en: 'Could not open an email app. Copy the report and send it to the address below.',
    zh: '无法打开邮件应用，请复制报告并发送至以下地址。',
    vi: 'Không mở được ứng dụng email. Sao chép báo cáo và gửi đến địa chỉ bên dưới.',
    uz: "Elektron pochta ilovasini ochib boʻlmadi. Hisobotni nusxalang va quyidagi manzilga yuboring.",
  );
}
