import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../auth/screens/login_screen.dart';
import '../../auth/services/auth_service.dart';
import '../../auth/services/user_profile_api_service.dart';
import '../services/evidence_api_service.dart';

class _S {
  static const add = L10nText(
    ko: '파일 추가',
    en: 'Add file',
    tr: "Dosya ekle",
    tg: "Файл илова кунед",
    fil: "Magdagdag ng file",
    ur: "فائل شامل کریں",
    th: "เพิ่มไฟล์",
    ky: "Файл кошуу",
    km: "ភ្ជាប់ឯកសារ",
    id: "Lampirkan berkas",
    si: "ගොනුවක් අමුණන්න",
    bn: "ফাইল যোগ করুন",
    my: "ဖိုင်ထည့်ပါ",
    mn: "Файл хавсаргах",
    lo: "ເພີ່ມໄຟລ໌",
    tet: "Aumenta file",
    ne: "फाइल संलग्न गर्नुहोस्",
    zh: '添加文件',
    vi: 'Thêm tệp',
    uz: "Fayl qoʻshish",
  );
  static const login = L10nText(
    ko: '로그인 후 자료를 보관할 수 있습니다.',
    en: 'Log in to store files.',
    tr: "Dosyaları depolamak için giriş yapın.",
    tg: "Барои нигоҳ доштани файлҳо ворид шавед.",
    fil: "Mag-log in para mag-imbak ng mga file.",
    ur: "فائلیں محفوظ کرنے کے لیے لاگ ان کریں۔",
    th: "เข้าสู่ระบบเพื่อจัดเก็บไฟล์",
    ky: "Файлдарды сактоо үчүн кириңиз.",
    km: "ចូលគណនីដើម្បីរក្សាទុកឯកសារ។",
    id: "Masuk untuk menyimpan berkas.",
    si: "ගොනු ගබඩා කිරීමට පුරන්න.",
    bn: "ফাইল সংরক্ষণ করতে লগইন করুন।",
    my: "ဖိုင်များ သိမ်းဆည်းရန် လော့ဂ်အင်ဝင်ပါ",
    mn: "Файлуудыг хадгалахын тулд нэвтэрнэ үү.",
    lo: "ເຂົ້າສູ່ລະບົບເພື່ອເກັບຮັກສາໄຟລ໌.",
    tet: "Login atu rai file sira.",
    ne: "फाइलहरू भण्डारण गर्न लगइन गर्नुहोस्।",
    zh: '登录后可保存文件。',
    vi: 'Đăng nhập để lưu tệp.',
    uz: "Fayllarni saqlash uchun tizimga kiring.",
  );
  static const loginButton = L10nText(
    ko: '로그인',
    en: 'Log in',
    tr: "Giriş yap",
    tg: "Ворид шудан",
    fil: "Mag-log in",
    ur: "لاگ ان کریں",
    th: "เข้าสู่ระบบ",
    ky: "Кирүү",
    km: "ចូលគណនី",
    id: "Masuk",
    si: "පිවිසෙන්න",
    bn: "লগ ইন করুন",
    my: "ဝင်ရောက်ပါ",
    mn: "Нэвтрэх",
    lo: "ເຂົ້າສູ່ລະບົບ",
    tet: "Login",
    ne: "लगइन गर्नुहोस्",
    zh: '登录',
    vi: 'Đăng nhập',
    uz: "Kirish",
  );
  static const empty = L10nText(
    ko: '등록된 파일이 없습니다.',
    en: 'No files yet.',
    tr: "Henüz dosya yok.",
    tg: "Ҳоло файлҳо вуҷуд надоранд.",
    fil: "Wala pang file.",
    ur: "ابھی تک کوئی فائل نہیں ہے۔",
    th: "ยังไม่มีไฟล์",
    ky: "Азырынча файлдар жок.",
    km: "មិនទាន់មានឯកសារនៅឡើយទេ។",
    id: "Belum ada berkas.",
    si: "තවම ගොනු නැත.",
    bn: "এখনও কোনো ফাইল নেই।",
    my: "ဖိုင်များ မရှိသေးပါ",
    mn: "Одоогоор файл байхгүй байна.",
    lo: "ຍັງບໍ່ມີໄຟລ໌.",
    tet: "Seidauk iha file.",
    ne: "अहिलेसम्म कुनै फाइल छैन।",
    zh: '暂无文件。',
    vi: 'Chưa có tệp.',
    uz: "Hali fayllar yoʻq.",
  );
  static const failed = L10nText(
    ko: '처리하지 못했습니다. 연결 상태를 확인한 뒤 다시 시도해주세요.',
    en: 'Could not complete the request. Check your connection and try again.',
    tr: "İstek tamamlanamadı. Bağlantınızı kontrol edin ve tekrar deneyin.",
    tg: "Дархост анҷом наёфт. Пайвасти худро тафтиш кунед ва дубора кӯшиш кунед.",
    fil:
        "Hindi makumpleto ang kahilingan. Pakisuri ang iyong koneksyon at subukang muli.",
    ur: "درخواست مکمل نہیں ہو سکی۔ اپنا کنکشن چیک کریں اور دوبارہ کوشش کریں۔",
    th: "ไม่สามารถดำเนินการตามคำขอได้ โปรดตรวจสอบการเชื่อมต่อของคุณแล้วลองอีกครั้ง",
    ky: "Суроо-талап аткарылган жок. Байланышыңызды текшерип, кайра аракет кылыңыз.",
    km: "សំណើមិនអាចបញ្ចប់បានទេ។ សូមពិនិត្យមើលការតភ្ជាប់របស់អ្នក ហើយព្យាយាមម្ដងទៀត។",
    id: "Permintaan tidak dapat diselesaikan. Periksa koneksi Anda dan coba lagi.",
    si: "ඉල්ලීම සම්පූර්ණ කළ නොහැකි විය. ඔබේ සම්බන්ධතාවය පරීක්ෂා කර නැවත උත්සාහ කරන්න.",
    bn: "অনুরোধটি সম্পূর্ণ করা যায়নি। আপনার সংযোগ পরীক্ষা করুন এবং আবার চেষ্টা করুন।",
    my: "တောင်းဆိုမှု မပြီးမြောက်ပါ။ သင်၏ချိတ်ဆက်မှုကို စစ်ဆေးပြီး ထပ်ကြိုးစားပါ။",
    mn: "Хүсэлтийг гүйцээж чадсангүй. Холболтоо шалгаад дахин оролдоно уу.",
    lo: "ບໍ່ສາມາດສຳເລັດການຮ້ອງຂໍໄດ້. ກະລຸນາກວດສອບການເຊື່ອມຕໍ່ຂອງທ່ານ ແລະ ລອງໃໝ່ອີກຄັ້ງ.",
    tet:
        "Pedidu la konsege kompletu. Favor verifika imi-nia koneksaun no koko fali.",
    ne: "अनुरोध पूरा हुन सकेन। आफ्नो इन्टरनेट जडान जाँच गर्नुहोस् र फेरि प्रयास गर्नुहोस्।",
    zh: '操作失败，请检查网络后重试。',
    vi: 'Không thể hoàn tất. Kiểm tra kết nối và thử lại.',
    uz: "Soʻrovni bajarib boʻlmadi. Ulanishingizni tekshiring va qayta urinib koʻring.",
  );
  static const uncertain = L10nText(
    ko: '업로드 결과를 확인하지 못했습니다. 새로고침으로 목록을 확인해주세요.',
    en: 'Could not confirm the upload. Refresh the file list.',
    tr: "Yükleme onaylanamadı. Dosya listesini yenileyin.",
    tg: "Боргузорӣ тасдиқ нашуд. Рӯйхати файлҳоро навсозӣ кунед.",
    fil: "Hindi makumpirma ang pag-upload. I-refresh ang listahan ng file.",
    ur: "اپ لوڈ کی تصدیق نہیں ہو سکی۔ براہ کرم فائلوں کی فہرست کو ریفریش کریں۔",
    th: "ไม่สามารถยืนยันการอัปโหลดได้ โปรดรีเฟรชรายการไฟล์",
    ky: "Жүктөө ырасталбай калды. Файлдардын тизмесин жаңыртыңыз.",
    km: "មិនអាចបញ្ជាក់ការផ្ទុកឡើងបានទេ។ សូមធ្វើឱ្យបញ្ជីឯកសារស្រស់ឡើងវិញ។",
    id: "Unggahan tidak dapat dikonfirmasi. Segarkan daftar berkas.",
    si: "උඩුගත කිරීම තහවුරු කළ නොහැකි විය. ගොනු ලැයිස්තුව නැවුම් කරන්න.",
    bn: "আপলোড নিশ্চিত করা যায়নি। ফাইলের তালিকা রিফ্রেশ করুন।",
    my: "အပ်လုဒ်တင်ခြင်းကို အတည်မပြုနိုင်ပါ။ ဖိုင်စာရင်းကို ပြန်လည်စတင်ပါ။",
    mn: "Байршуулалтыг баталгаажуулж чадсангүй. Файлын жагсаалтыг шинэчилнэ үү.",
    lo: "ບໍ່ສາມາດຢືນຢັນການອັບໂຫຼດໄດ້. ກະລຸນາໂຫຼດລາຍການໄຟລ໌ຄືນໃໝ່.",
    tet: "Upload la konsege konfirma. Favor refresh lista file nian.",
    ne: "अपलोड पुष्टि गर्न सकिएन। फाइल सूची रिफ्रेस गर्नुहोस्।",
    zh: '无法确认上传结果，请刷新列表。',
    vi: 'Chưa xác nhận được tải lên. Hãy làm mới danh sách.',
    uz: "Yuklashni tasdiqlab boʻlmadi. Fayllar roʻyxatini yangilang.",
  );
  static const limit = L10nText(
    ko: '빈 파일은 올릴 수 없으며, 파일당 최대 20MB까지 가능합니다.',
    en: 'Choose a non-empty file up to 20 MB.',
    tr: "20 MB'a kadar boş olmayan bir dosya seçin.",
    tg: "Файли холӣ набударо то 20 МБ интихоб кунед.",
    fil: "Pumili ng hindi-walang laman na file hanggang 20 MB.",
    ur: "20 MB تک کی کوئی خالی فائل منتخب کریں۔",
    th: "เลือกไฟล์ที่ไม่ว่างเปล่าขนาดไม่เกิน 20 MB",
    ky: "20 МБ чейинки бош эмес файлды тандаңыз.",
    km: "សូមជ្រើសរើសឯកសារដែលមិនទទេររហូតដល់ 20 MB។",
    id: "Pilih berkas tidak kosong hingga 20 MB.",
    si: "20 MB දක්වා හිස් නොවන ගොනුවක් තෝරන්න.",
    bn: "20 MB পর্যন্ত একটি নন-এমটি ফাইল নির্বাচন করুন।",
    my: "20 MB အထိရှိသော ဖိုင်တစ်ခုကို ရွေးချယ်ပါ။",
    mn: "20 MB-аас ихгүй хэмжээтэй, хоосон биш файл сонгоно уу.",
    lo: "ເລືອກໄຟລ໌ທີ່ບໍ່ຫວ່າງເປົ່າ, ສູງສຸດ 20 MB.",
    tet: "Hili file ida ne'ebé la mamuk no to'o 20 MB.",
    ne: "20 MB सम्मको खाली नभएको फाइल चयन गर्नुहोस्।",
    zh: '请选择不为空且不超过20MB的文件。',
    vi: 'Chọn tệp không rỗng, tối đa 20 MB.',
    uz: "20 MB gacha boʻlgan boʻsh boʻlmagan faylni tanlang.",
  );
  static const success = L10nText(
    ko: '파일을 보관했습니다.',
    en: 'File saved.',
    tr: "Dosya kaydedildi.",
    tg: "Файл захира карда шуд.",
    fil: "Na-save ang file.",
    ur: "فائل محفوظ کر لی گئی ہے۔",
    th: "บันทึกไฟล์แล้ว",
    ky: "Файл сакталды.",
    km: "ឯកសារត្រូវបានរក្សាទុក។",
    id: "Berkas disimpan.",
    si: "ගොනුව සුරැකිණි.",
    bn: "ফাইল সংরক্ষণ করা হয়েছে।",
    my: "ဖိုင်ကို သိမ်းဆည်းပြီးပါပြီ။",
    mn: "Файл хадгалагдсан.",
    lo: "ໄຟລ໌ຖືກບັນທຶກແລ້ວ.",
    tet: "File rai ona.",
    ne: "फाइल सुरक्षित गरियो।",
    zh: '文件已保存。',
    vi: 'Đã lưu tệp.',
    uz: "Fayl saqlandi.",
  );
  static const refresh = L10nText(
    ko: '새로고침',
    en: 'Refresh',
    tr: "Yenile",
    tg: "Навсозӣ",
    fil: "I-refresh",
    ur: "ریفریش کریں",
    th: "รีเฟรช",
    ky: "Жаңыртуу",
    km: "ធ្វើឱ្យស្រស់",
    id: "Segarkan",
    si: "නැවුම් කරන්න",
    bn: "রিফ্রেশ করুন",
    my: "ပြန်လည်စတင်ရန်",
    mn: "Шинэчлэх",
    lo: "ໂຫຼດຄືນໃໝ່",
    tet: "Refresh",
    ne: "रिफ्रेस गर्नुहोस्",
    zh: '刷新',
    vi: 'Làm mới',
    uz: "Yangilash",
  );
  static const uploading = L10nText(
    ko: '업로드 중…',
    en: 'Uploading…',
    tr: "Yükleniyor…",
    tg: "Боргузорӣ мешавад…",
    fil: "Nag-a-upload…",
    ur: "اپ لوڈ ہو رہا ہے…",
    th: "กำลังอัปโหลด...",
    ky: "Жүктөлүүдө…",
    km: "កំពុងផ្ទុកឡើង...",
    id: "Mengunggah…",
    si: "උඩුගත කරමින්...",
    bn: "আপলোড হচ্ছে…",
    my: "တင်နေသည်...",
    mn: "Байршуулж байна…",
    lo: "ກຳລັງອັບໂຫຼດ…",
    tet: "Halo upload…",
    ne: "अपलोड हुँदैछ…",
    zh: '上传中…',
    vi: 'Đang tải lên…',
    uz: "Yuklanmoqda…",
  );
  static const statusFailed = L10nText(
    ko: '파일은 저장됐지만 홈의 보관 상태를 갱신하지 못했습니다.',
    en: 'File saved, but the home vault status could not be updated.',
    tr: "Dosya kaydedildi, ancak ana kasa durumu güncellenemedi.",
    tg: "Файл захира карда шуд, аммо ҳолати сейфи асосӣ навсозӣ нашуд.",
    fil:
        "Na-save ang file, ngunit hindi na-update ang status ng pangunahing vault.",
    ur: "فائل محفوظ کر لی گئی ہے، لیکن مرکزی والٹ کی حیثیت کو اپ ڈیٹ نہیں کیا جا سکا۔",
    th: "บันทึกไฟล์แล้ว แต่ไม่สามารถอัปเดตสถานะตู้เซฟหลักได้",
    ky: "Файл сакталды, бирок негизги сейфтин абалы жаңыртылган жок.",
    km: "ឯកសារត្រូវបានរក្សាទុក ប៉ុន្តែស្ថានភាពសុវត្ថិភាពសំខាន់មិនអាចធ្វើបច្ចុប្បន្នភាពបានទេ។",
    id: "Berkas disimpan, tetapi status brankas utama tidak dapat diperbarui.",
    si: "ගොනුව සුරැකිණි, නමුත් ප්‍රධාන සුරක්ෂිතාගාරයේ තත්ත්වය යාවත්කාලීන කිරීමට නොහැකි විය.",
    bn: "ফাইল সংরক্ষণ করা হয়েছে, কিন্তু প্রধান ভল্টের স্থিতি আপডেট করা যায়নি।",
    my: "ဖိုင်ကို သိမ်းဆည်းပြီးပါပြီ၊ သို့သော် အဓိကဘေးကင်းခန်း အခြေအနေကို အပ်ဒိတ်လုပ်၍ မရပါ။",
    mn: "Файл хадгалагдсан боловч үндсэн хадгалах сангийн төлөвийг шинэчилж чадсангүй.",
    lo: "ໄຟລ໌ຖືກບັນທຶກແລ້ວ, ແຕ່ບໍ່ສາມາດອັບເດດສະຖານະຂອງຕູ້ເຊຟຫຼັກໄດ້.",
    tet: "File rai ona, maibé la konsege atualiza status kofre prinsipál nian.",
    ne: "फाइल सुरक्षित गरियो, तर मुख्य भल्टको स्थिति अद्यावधिक गर्न सकिएन।",
    zh: '文件已保存，但主页状态更新失败。',
    vi: 'Đã lưu tệp nhưng chưa cập nhật trạng thái trang chủ.',
    uz: "Fayl saqlandi, ammo asosiy ombor holatini yangilab boʻlmadi.",
  );
}

/// 기존 인증 업로드 API를 사용하는 공용 보관함. 날짜가 있으면 근무일에 연결한다.
class EvidenceFilesScreen extends StatefulWidget {
  const EvidenceFilesScreen({
    super.key,
    required this.title,
    required this.category,
    this.day,
  });
  final String title;
  final String category;
  final DateTime? day;

  @override
  State<EvidenceFilesScreen> createState() => _EvidenceFilesScreenState();
}

class _EvidenceFilesScreenState extends State<EvidenceFilesScreen> {
  final _api = EvidenceApiService();
  final _auth = AuthService();
  String? _uid;
  List<EvidenceFile> _files = [];
  bool _loading = false;
  bool _uploading = false;
  L10nText? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uid = UserProfileScope.of(context).uid;
    if (_uid != uid) {
      _uid = uid;
      _files = [];
      _error = null;
      _loading = false;
      if (uid != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _uid == uid) _load();
        });
      }
    }
  }

  bool _active(String? uid) => mounted && uid != null && _uid == uid;

  Future<void> _load() async {
    final uid = _uid;
    if (uid == null || _loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final token = await _auth.currentIdToken();
      if (token == null || !_active(uid)) throw StateError('signed out');
      final files = await _api.list(token, day: widget.day);
      if (_active(uid)) {
        setState(
          () => _files = files
              .where((f) => f.category == widget.category)
              .toList(),
        );
      }
    } catch (_) {
      if (_active(uid)) setState(() => _error = _S.failed);
    } finally {
      if (_active(uid)) setState(() => _loading = false);
    }
  }

  Future<void> _upload() async {
    final profile = UserProfileScope.of(context);
    final uid = profile.uid;
    if (uid == null || _uploading) return;
    setState(() {
      _uploading = true;
      _error = null;
    });
    var sent = false;
    try {
      final file = await openFile();
      if (file == null || !_active(uid)) return;
      final size = await file.length();
      if (size == 0 || size > 20 * 1024 * 1024) {
        if (_active(uid)) setState(() => _error = _S.limit);
        return;
      }
      final bytes = await file.readAsBytes();
      final token = await _auth.currentIdToken();
      if (token == null || !_active(uid)) throw StateError('signed out');
      sent = true;
      final id = await _api.upload(
        token: token,
        category: widget.category,
        filename: file.name,
        bytes: bytes,
        contentType:
            lookupMimeType(file.name, headerBytes: bytes) ??
            'application/octet-stream',
        day: widget.day,
      );
      final files = await _api.list(token, day: widget.day);
      if (!_active(uid)) return;
      setState(
        () =>
            _files = files.where((f) => f.category == widget.category).toList(),
      );
      if (!_files.any((f) => f.id == id)) {
        setState(() => _error = _S.uncertain);
        return;
      }
      if (widget.category == 'contract' || widget.category == 'payslip') {
        try {
          await UserProfileApiService().updateVaultStatus(
            idToken: token,
            contractStored: widget.category == 'contract' ? true : null,
            payslipStored: widget.category == 'payslip' ? true : null,
          );
          if (!_active(uid)) return;
          if (widget.category == 'contract' && !profile.contractStored) {
            profile.toggleContractStored();
          }
          if (widget.category == 'payslip' && !profile.payslipStored) {
            profile.togglePayslipStored();
          }
        } catch (_) {
          if (_active(uid)) setState(() => _error = _S.statusFailed);
        }
      }
      if (mounted && _active(uid)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_S.success.of(profile.language))),
        );
      }
    } catch (_) {
      if (_active(uid)) {
        setState(() => _error = sent ? _S.uncertain : _S.failed);
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = UserProfileScope.of(context);
    final lang = profile.language;
    return PopScope(
      canPop: !_uploading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            if (profile.isSignedIn)
              IconButton(
                tooltip: _S.refresh.of(lang),
                onPressed: _loading || _uploading ? null : _load,
                icon: const Icon(Icons.refresh),
              ),
          ],
        ),
        body: !profile.isSignedIn
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_S.login.of(lang)),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                      child: Text(_S.loginButton.of(lang)),
                    ),
                  ],
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (widget.day case final day?)
                    Text(
                      '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}',
                    ),
                  FilledButton.icon(
                    onPressed: _uploading || _loading ? null : _upload,
                    icon: const Icon(Icons.upload_file),
                    label: Text((_uploading ? _S.uploading : _S.add).of(lang)),
                  ),
                  if (_uploading || _loading) const LinearProgressIndicator(),
                  if (_error case final error?)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        error.of(lang),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  if (!_loading && _error == null && _files.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(_S.empty.of(lang)),
                    ),
                  for (final file in _files)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.insert_drive_file_outlined),
                      title: Text(file.name),
                      subtitle: Text(
                        '${(file.size / 1024).toStringAsFixed(1)} KB',
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
