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
    zh: '添加文件',
    vi: 'Thêm tệp',
    uz: "Fayl qoʻshish",
  );
  static const login = L10nText(
    ko: '로그인 후 자료를 보관할 수 있습니다.',
    en: 'Log in to store files.',
    tr: "Dosyaları depolamak için giriş yapın.",
    zh: '登录后可保存文件。',
    vi: 'Đăng nhập để lưu tệp.',
    uz: "Fayllarni saqlash uchun tizimga kiring.",
  );
  static const loginButton = L10nText(
    ko: '로그인',
    en: 'Log in',
    tr: "Giriş yap",
    zh: '登录',
    vi: 'Đăng nhập',
    uz: "Kirish",
  );
  static const empty = L10nText(
    ko: '등록된 파일이 없습니다.',
    en: 'No files yet.',
    tr: "Henüz dosya yok.",
    zh: '暂无文件。',
    vi: 'Chưa có tệp.',
    uz: "Hali fayllar yoʻq.",
  );
  static const failed = L10nText(
    ko: '처리하지 못했습니다. 연결 상태를 확인한 뒤 다시 시도해주세요.',
    en: 'Could not complete the request. Check your connection and try again.',
    tr: "İstek tamamlanamadı. Bağlantınızı kontrol edin ve tekrar deneyin.",
    zh: '操作失败，请检查网络后重试。',
    vi: 'Không thể hoàn tất. Kiểm tra kết nối và thử lại.',
    uz: "Soʻrovni bajarib boʻlmadi. Ulanishingizni tekshiring va qayta urinib koʻring.",
  );
  static const uncertain = L10nText(
    ko: '업로드 결과를 확인하지 못했습니다. 새로고침으로 목록을 확인해주세요.',
    en: 'Could not confirm the upload. Refresh the file list.',
    tr: "Yükleme onaylanamadı. Dosya listesini yenileyin.",
    zh: '无法确认上传结果，请刷新列表。',
    vi: 'Chưa xác nhận được tải lên. Hãy làm mới danh sách.',
    uz: "Yuklashni tasdiqlab boʻlmadi. Fayllar roʻyxatini yangilang.",
  );
  static const limit = L10nText(
    ko: '빈 파일은 올릴 수 없으며, 파일당 최대 20MB까지 가능합니다.',
    en: 'Choose a non-empty file up to 20 MB.',
    tr: "20 MB'a kadar boş olmayan bir dosya seçin.",
    zh: '请选择不为空且不超过20MB的文件。',
    vi: 'Chọn tệp không rỗng, tối đa 20 MB.',
    uz: "20 MB gacha boʻlgan boʻsh boʻlmagan faylni tanlang.",
  );
  static const success = L10nText(
    ko: '파일을 보관했습니다.',
    en: 'File saved.',
    tr: "Dosya kaydedildi.",
    zh: '文件已保存。',
    vi: 'Đã lưu tệp.',
    uz: "Fayl saqlandi.",
  );
  static const refresh = L10nText(
    ko: '새로고침',
    en: 'Refresh',
    tr: "Yenile",
    zh: '刷新',
    vi: 'Làm mới',
    uz: "Yangilash",
  );
  static const uploading = L10nText(
    ko: '업로드 중…',
    en: 'Uploading…',
    tr: "Yükleniyor…",
    zh: '上传中…',
    vi: 'Đang tải lên…',
    uz: "Yuklanmoqda…",
  );
  static const statusFailed = L10nText(
    ko: '파일은 저장됐지만 홈의 보관 상태를 갱신하지 못했습니다.',
    en: 'File saved, but the home vault status could not be updated.',
    tr: "Dosya kaydedildi, ancak ana kasa durumu güncellenemedi.",
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
