import '../../../core/app_language.dart';

class WorkLogReportStrings {
  static const step = L10nText(
    ko: '근무기록장의 내용을 증거물로 출력하세요',
    en: 'Export your work log as supporting material',
    zh: '导出工作记录作为证明材料',
    vi: 'Xuất nhật ký làm việc làm tài liệu chứng minh',
    uz: 'Ish qaydlarini tasdiqlovchi hujjat sifatida chiqaring',
    tr: 'Çalışma kayıtlarınızı destekleyici belge olarak dışa aktarın',
  );
  static const title = L10nText(
    ko: '근무기록 확인자료',
    en: 'Work log report',
    zh: '工作记录资料',
    vi: 'Báo cáo nhật ký làm việc',
    uz: 'Ish qaydlari hisoboti',
    tr: 'Çalışma kayıt raporu',
  );
  static const lead = L10nText(
    ko: '오늘을 포함한 최근 30일의 저장된 출퇴근·휴게시간·위치 인증·메모를 불러옵니다. 한국어 또는 내 언어 PDF로 저장해 진정서에 첨부할 수 있습니다.',
    en: 'Load saved clock-in/out times, breaks, location verification and notes for the last 30 days including today. Save a Korean or translated PDF to attach to your complaint.',
    zh: '读取包括今天在内最近30天的上下班、休息、位置认证和备注记录。可保存韩语或所选语言PDF，作为申诉附件。',
    vi: 'Tải giờ vào/ra, giờ nghỉ, xác minh vị trí và ghi chú trong 30 ngày gồm hôm nay. Lưu PDF tiếng Hàn hoặc ngôn ngữ của bạn để đính kèm đơn.',
    uz: 'Bugunni ham hisobga olgan oxirgi 30 kunning kelish/ketish, tanaffus, joylashuv tasdigʻi va izohlarini yuklang. Shikoyatga ilova qilish uchun koreyscha yoki oʻz tilingizda PDF saqlang.',
    tr: 'Bugün dahil son 30 günün giriş/çıkış, mola, konum doğrulama ve not kayıtlarını yükleyin. Şikayete eklemek için Korece veya kendi dilinizde PDF kaydedin.',
  );
  static const demo = L10nText(
    ko: '데모 기록 - 실제 제출용이 아닙니다. 로그인하면 내 기록을 불러옵니다.',
    en: 'DEMO records - not for submission. Sign in to load your own records.',
    zh: '演示记录 - 不可提交。登录后读取本人记录。',
    vi: 'Dữ liệu DEMO - không dùng để nộp. Đăng nhập để tải bản ghi của bạn.',
    uz: 'DEMO qaydlar - topshirish uchun emas. Oʻz qaydlaringizni yuklash uchun kiring.',
    tr: 'DEMO kayıtları - başvuru için kullanılamaz. Kendi kayıtlarınız için giriş yapın.',
  );
  static const note = L10nText(
    ko: '사용자가 앱에 저장한 기록의 사본입니다. 위치 인증은 해당 날짜에 저장된 상태이며 출근·퇴근 각각의 위치나 인증 시각을 증명하지 않습니다. 미기록은 결근을 뜻하지 않습니다. 메모와 주소는 원문 그대로 출력됩니다.',
    en: 'A copy of records saved by the user. Location status is recorded per day; it does not certify separate clock-in/out locations or verification times. Missing records do not mean absence. Notes and addresses retain their original text.',
    zh: '本资料为用户保存记录的副本。位置状态按日记录，不证明上下班各自的位置或认证时间。无记录不代表缺勤。备注和地址保持原文。',
    vi: 'Bản sao dữ liệu người dùng đã lưu. Trạng thái vị trí theo ngày không xác nhận riêng vị trí vào/ra hay thời điểm xác minh. Thiếu bản ghi không có nghĩa là vắng mặt. Ghi chú và địa chỉ giữ nguyên văn.',
    uz: 'Foydalanuvchi saqlagan qaydlar nusxasi. Kunlik joylashuv holati alohida kelish/ketish joylari yoki tasdiqlash vaqtini isbotlamaydi. Qayd yoʻqligi ishga kelmaganlikni anglatmaydi. Izoh va manzillar asl holida chiqariladi.',
    tr: 'Kullanıcının kaydettiği verilerin kopyasıdır. Günlük konum durumu, ayrı giriş/çıkış konumlarını veya doğrulama saatini kanıtlamaz. Kayıt olmaması devamsızlık anlamına gelmez. Notlar ve adresler aynen aktarılır.',
  );
  static const load = L10nText(
    ko: '기록 새로 불러오기',
    en: 'Reload records',
    zh: '重新读取记录',
    vi: 'Tải lại bản ghi',
    uz: 'Qaydlarni qayta yuklash',
    tr: 'Kayıtları yeniden yükle',
  );
  static const loading = L10nText(
    ko: '근무기록을 불러오는 중입니다…',
    en: 'Loading work records…',
    zh: '正在读取工作记录…',
    vi: 'Đang tải nhật ký…',
    uz: 'Ish qaydlari yuklanmoqda…',
    tr: 'Çalışma kayıtları yükleniyor…',
  );
  static const error = L10nText(
    ko: '기록을 불러오지 못했습니다. 로그인 상태와 연결을 확인하고 다시 시도하세요.',
    en: 'Could not load records. Check your sign-in and connection, then retry.',
    zh: '读取失败。请检查登录和网络后重试。',
    vi: 'Không tải được. Kiểm tra đăng nhập, kết nối rồi thử lại.',
    uz: 'Yuklab boʻlmadi. Hisob va ulanishni tekshirib, qayta urinib koʻring.',
    tr: 'Kayıtlar yüklenemedi. Giriş ve bağlantınızı kontrol edip yeniden deneyin.',
  );
  static const empty = L10nText(
    ko: '최근 30일 동안 저장된 기록이 없습니다.',
    en: 'No saved records in the last 30 days.',
    zh: '最近30天没有保存的记录。',
    vi: 'Không có bản ghi trong 30 ngày qua.',
    uz: 'Oxirgi 30 kunda saqlangan qaydlar yoʻq.',
    tr: 'Son 30 günde kaydedilmiş kayıt yok.',
  );
  static const pdfError = L10nText(
    ko: 'PDF를 만들거나 저장하지 못했습니다. 다시 시도하세요.',
    en: 'Could not create or save the PDF. Please retry.',
    zh: '无法生成或保存PDF，请重试。',
    vi: 'Không tạo hoặc lưu được PDF. Hãy thử lại.',
    uz: 'PDF yaratilmadi yoki saqlanmadi. Qayta urinib koʻring.',
    tr: 'PDF oluşturulamadı veya kaydedilemedi. Yeniden deneyin.',
  );
  static const koreanPdf = L10nText(
    ko: '한국어 PDF 저장',
    en: 'Save Korean PDF',
    zh: '保存韩语PDF',
    vi: 'Lưu PDF tiếng Hàn',
    uz: 'Koreyscha PDF saqlash',
    tr: 'Korece PDF kaydet',
  );
  static const myPdf = L10nText(
    ko: '내 언어 PDF 저장',
    en: 'Save PDF in my language',
    zh: '保存所选语言PDF',
    vi: 'Lưu PDF ngôn ngữ của tôi',
    uz: 'Oʻz tilimda PDF saqlash',
    tr: 'Kendi dilimde PDF kaydet',
  );
  static const preview = L10nText(
    ko: 'PDF 미리보기 및 인쇄',
    en: 'Preview and print PDF',
    zh: '预览及打印PDF',
    vi: 'Xem và in PDF',
    uz: 'PDFni koʻrish va chop etish',
    tr: 'PDF önizleme ve yazdırma',
  );
  static const date = L10nText(
    ko: '날짜',
    en: 'Date',
    zh: '日期',
    vi: 'Ngày',
    uz: 'Sana',
    tr: 'Tarih',
  );
  static const clockIn = L10nText(
    ko: '출근',
    en: 'Clock in',
    zh: '上班',
    vi: 'Vào',
    uz: 'Kelish',
    tr: 'Giriş',
  );
  static const clockOut = L10nText(
    ko: '퇴근',
    en: 'Clock out',
    zh: '下班',
    vi: 'Ra',
    uz: 'Ketish',
    tr: 'Çıkış',
  );
  static const breaks = L10nText(
    ko: '휴게(분)',
    en: 'Break (min)',
    zh: '休息(分)',
    vi: 'Nghỉ (phút)',
    uz: 'Tanaffus (daq)',
    tr: 'Mola (dk)',
  );
  static const location = L10nText(
    ko: '위치 인증',
    en: 'Location status',
    zh: '位置认证',
    vi: 'Xác minh vị trí',
    uz: 'Joylashuv tasdigʻi',
    tr: 'Konum doğrulama',
  );
  static const verified = L10nText(
    ko: '인증 기록 있음',
    en: 'Verification recorded',
    zh: '有认证记录',
    vi: 'Có bản ghi xác minh',
    uz: 'Tasdiq qayd etilgan',
    tr: 'Doğrulama kayıtlı',
  );
  static const unverified = L10nText(
    ko: '인증 기록 없음',
    en: 'No verification recorded',
    zh: '无认证记录',
    vi: 'Không có xác minh',
    uz: 'Tasdiq qaydi yoʻq',
    tr: 'Doğrulama kaydı yok',
  );
  static const missing = L10nText(
    ko: '미기록',
    en: 'Not recorded',
    zh: '未记录',
    vi: 'Chưa ghi',
    uz: 'Qayd etilmagan',
    tr: 'Kaydedilmemiş',
  );
  static const address = L10nText(
    ko: '저장된 주소',
    en: 'Saved address',
    zh: '保存的地址',
    vi: 'Địa chỉ đã lưu',
    uz: 'Saqlangan manzil',
    tr: 'Kayıtlı adres',
  );
  static const coordinates = L10nText(
    ko: '저장된 좌표(위도, 경도)',
    en: 'Saved coordinates (latitude, longitude)',
    zh: '保存的坐标(纬度、经度)',
    vi: 'Tọa độ đã lưu (vĩ độ, kinh độ)',
    uz: 'Saqlangan koordinatalar (kenglik, uzunlik)',
    tr: 'Kayıtlı koordinatlar (enlem, boylam)',
  );
  static const memo = L10nText(
    ko: '메모(원문)',
    en: 'Notes (original)',
    zh: '备注(原文)',
    vi: 'Ghi chú (nguyên văn)',
    uz: 'Izohlar (asl)',
    tr: 'Notlar (orijinal)',
  );
  static const owner = L10nText(
    ko: '기록자',
    en: 'Record owner',
    zh: '记录人',
    vi: 'Người ghi',
    uz: 'Qayd egasi',
    tr: 'Kayıt sahibi',
  );
  static const period = L10nText(
    ko: '조회 기간(30일)',
    en: 'Period (30 days)',
    zh: '查询期间(30天)',
    vi: 'Khoảng thời gian (30 ngày)',
    uz: 'Davr (30 kun)',
    tr: 'Dönem (30 gün)',
  );
  static const generated = L10nText(
    ko: '불러온 시각(한국시간)',
    en: 'Retrieved at (KST)',
    zh: '读取时间(韩国时间)',
    vi: 'Thời điểm tải (KST)',
    uz: 'Yuklangan vaqt (KST)',
    tr: 'Yükleme zamanı (KST)',
  );
  static const savedDays = L10nText(
    ko: '저장된 날짜 수',
    en: 'Days with records',
    zh: '有记录的天数',
    vi: 'Số ngày có bản ghi',
    uz: 'Qaydli kunlar soni',
    tr: 'Kayıt bulunan gün sayısı',
  );
  static const details = L10nText(
    ko: '일별 상세 기록',
    en: 'Daily details',
    zh: '每日详细记录',
    vi: 'Chi tiết từng ngày',
    uz: 'Kunlik tafsilotlar',
    tr: 'Günlük ayrıntılar',
  );
}
