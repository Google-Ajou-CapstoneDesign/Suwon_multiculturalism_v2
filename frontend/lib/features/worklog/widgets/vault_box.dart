import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';
import '../../auth/services/auth_service.dart';
import '../../auth/services/user_profile_api_service.dart';

class _VaultStrings {
  _VaultStrings._();

  static const vaultTitle = L10nText(
    ko: '사업주 공식 증빙 보관함',
    en: 'Employer document vault',
    zh: '雇主正式凭证保管箱',
    vi: 'Kho giấy tờ của chủ sử dụng',
  );
  static const vaultSubtitle = L10nText(
    ko: '근로계약서 · 임금명세서 · 사업주 메시지 — 눌러서 펼치기',
    en: 'Contract · payslips · employer messages — tap to expand',
    zh: '劳动合同·工资单·雇主消息 — 点击展开',
    vi: 'Hợp đồng · phiếu lương · tin nhắn của chủ — nhấn để mở',
  );
  static const vaultContractTitle = L10nText(
    ko: '근로계약서',
    en: 'Employment contract',
    zh: '劳动合同',
    vi: 'Hợp đồng lao động',
  );
  static const vaultPayslipTitle = L10nText(
    ko: '임금명세서',
    en: 'Payslip',
    zh: '工资单',
    vi: 'Phiếu lương',
  );
  static const vaultMessageTitle = L10nText(
    ko: '사업주 카톡 · 문자',
    en: 'Employer messages',
    zh: '雇主KakaoTalk·短信',
    vi: 'Tin nhắn của chủ',
  );
  static const vaultCallTitle = L10nText(
    ko: '사업주 통화 녹음',
    en: 'Recorded call with employer',
    zh: '与雇主的通话录音',
    vi: 'Ghi âm cuộc gọi với chủ',
  );
  static const vaultStoredSubtitle = L10nText(
    ko: '보관함에 등록되어 있습니다',
    en: 'Registered in your vault',
    zh: '已在保管箱中登记',
    vi: 'Đã lưu trong kho',
  );
  static const vaultContractEmptySubtitle = L10nText(
    ko: '아직 없습니다 — 사업주에게 사본을 요청하세요',
    en: 'None yet — ask your employer for a copy',
    zh: '尚无 — 请向雇主索取副本',
    vi: 'Chưa có — hãy yêu cầu chủ cấp bản sao',
  );
  static const vaultPayslipEmptySubtitle = L10nText(
    ko: '아직 없습니다 — 매달 명세서를 저장해 두세요',
    en: 'None yet — save your payslip each month',
    zh: '尚无 — 请每月保存工资单',
    vi: 'Chưa có — hãy lưu phiếu lương mỗi tháng',
  );
  static const vaultMessageEmptySubtitle = L10nText(
    ko: '아직 없습니다 — 지급 약속 메시지를 저장해 두세요',
    en: 'None yet — save any message promising payment',
    zh: '尚无 — 请保存承诺支付的消息',
    vi: 'Chưa có — hãy lưu tin nhắn hứa trả lương',
  );
  static const vaultCallEmptySubtitle = L10nText(
    ko: '아직 없습니다 — 본인이 참여한 대화만 녹음할 수 있습니다',
    en: 'None yet — you may only record conversations you take part in',
    zh: '尚无 — 只能录制本人参与的对话',
    vi: 'Chưa có — chỉ được ghi âm cuộc trò chuyện bạn tham gia',
  );
  static const vaultStoredTag = L10nText(
    ko: '보관됨',
    en: 'Stored',
    zh: '已保存',
    vi: 'Đã lưu',
  );
  static const vaultAddTag = L10nText(
    ko: '추가',
    en: 'Add',
    zh: '添加',
    vi: 'Thêm',
  );
  static const vaultComingSoonMessage = L10nText(
    ko: '아직 준비 중인 기능입니다. 곧 연동될 예정이에요.',
    en: "This feature isn't ready yet. It's coming soon.",
    zh: '该功能尚在准备中，即将上线。',
    vi: 'Tính năng này đang được chuẩn bị và sẽ sớm ra mắt.',
  );
  static const vaultOcrButton = L10nText(
    ko: '📷 OCR로 읽기 (베타)',
    en: '📷 Read with OCR (beta)',
    zh: '📷 用OCR读取（测试版）',
    vi: '📷 Đọc bằng OCR (beta)',
  );
  static const vaultStrongNote = L10nText(
    ko: '이 서랍의 문서가 다툼이 생겼을 때 가장 먼저 요구받는 것들입니다. 계약서를 못 받았다면 지금 사업주에게 사본을 요청하세요. 교부는 사업주의 의무입니다.',
    en: 'These are the documents you will be asked for first if a dispute arises. If you never received a contract, ask your employer for a copy now — providing one is their obligation.',
    zh: '这些是发生争议时最先被索取的文件。若未拿到合同，请立即向雇主索取副本，交付是雇主的义务。',
    vi: 'Đây là những giấy tờ được yêu cầu đầu tiên khi có tranh chấp. Nếu chưa nhận hợp đồng, hãy yêu cầu chủ cấp bản sao ngay — đó là nghĩa vụ của chủ.',
  );
}

/// 사업주 공식 증빙 보관함 — 근무기록장 시트와 설정 화면이 공용으로 쓴다.
/// 근로계약서/임금명세서는 실제로 등록 여부를 토글하고 로그인 상태면
/// 백엔드(PATCH /api/users/me/vault)에도 반영한다. 카톡·통화녹음은 아직
/// 저장할 방법이 없어 "준비 중" 안내만 띄운다.
class VaultBox extends StatefulWidget {
  const VaultBox({super.key, required this.language});
  final AppLanguage language;

  @override
  State<VaultBox> createState() => _VaultBoxState();
}

class _VaultBoxState extends State<VaultBox> {
  bool _open = false;
  final _authService = AuthService();
  final _userProfileApi = UserProfileApiService();

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _VaultStrings.vaultComingSoonMessage.of(widget.language),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleContract(UserProfileController profile) {
    profile.toggleContractStored();
    _syncVault(profile, contractStored: profile.contractStored);
  }

  void _togglePayslip(UserProfileController profile) {
    profile.togglePayslipStored();
    _syncVault(profile, payslipStored: profile.payslipStored);
  }

  Future<void> _syncVault(
    UserProfileController profile, {
    bool? contractStored,
    bool? payslipStored,
  }) async {
    if (!profile.isSignedIn) return;
    try {
      final idToken = await _authService.currentIdToken();
      if (idToken == null) return;
      await _userProfileApi.updateVaultStatus(
        idToken: idToken,
        contractStored: contractStored,
        payslipStored: payslipStored,
      );
    } catch (_) {
      // 저장 실패해도 로컬 상태는 이미 반영돼 있으니 조용히 넘어간다.
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = UserProfileScope.of(context);
    final lang = widget.language;
    return AnimatedBuilder(
      animation: profile,
      builder: (context, _) {
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => setState(() => _open = !_open),
                child: Padding(
                  padding: const EdgeInsets.all(13),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('📁', style: TextStyle(fontSize: 15)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _VaultStrings.vaultTitle.of(lang),
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _VaultStrings.vaultSubtitle.of(lang),
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textMuted,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedRotation(
                        turns: _open ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          size: 18,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_open)
                Padding(
                  padding: const EdgeInsets.fromLTRB(13, 0, 13, 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(height: 1, color: AppColors.border),
                      const SizedBox(height: 11),
                      _VaultFileRow(
                        icon: '📄',
                        title: _VaultStrings.vaultContractTitle.of(lang),
                        subtitle: profile.contractStored
                            ? _VaultStrings.vaultStoredSubtitle.of(lang)
                            : _VaultStrings.vaultContractEmptySubtitle.of(
                                lang,
                              ),
                        stored: profile.contractStored,
                        language: lang,
                        onTap: () => _toggleContract(profile),
                      ),
                      const SizedBox(height: 8),
                      _VaultFileRow(
                        icon: '🧾',
                        title: _VaultStrings.vaultPayslipTitle.of(lang),
                        subtitle: profile.payslipStored
                            ? _VaultStrings.vaultStoredSubtitle.of(lang)
                            : _VaultStrings.vaultPayslipEmptySubtitle.of(
                                lang,
                              ),
                        stored: profile.payslipStored,
                        language: lang,
                        onTap: () => _togglePayslip(profile),
                      ),
                      const SizedBox(height: 8),
                      _VaultFileRow(
                        icon: '💬',
                        title: _VaultStrings.vaultMessageTitle.of(lang),
                        subtitle: _VaultStrings.vaultMessageEmptySubtitle.of(
                          lang,
                        ),
                        stored: false,
                        language: lang,
                        onTap: () => _showComingSoon(context),
                      ),
                      const SizedBox(height: 8),
                      _VaultFileRow(
                        icon: '🎙',
                        title: _VaultStrings.vaultCallTitle.of(lang),
                        subtitle: _VaultStrings.vaultCallEmptySubtitle.of(
                          lang,
                        ),
                        stored: false,
                        language: lang,
                        onTap: () => _showComingSoon(context),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => _showComingSoon(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textSecondary,
                            side: const BorderSide(color: AppColors.border),
                            padding: const EdgeInsets.symmetric(vertical: 9),
                          ),
                          child: Text(
                            _VaultStrings.vaultOcrButton.of(lang),
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        _VaultStrings.vaultStrongNote.of(lang),
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textMuted,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _VaultFileRow extends StatelessWidget {
  const _VaultFileRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.stored,
    required this.language,
    required this.onTap,
  });

  final String icon;
  final String title;
  final String subtitle;
  final bool stored;
  final AppLanguage language;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 15)),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: AppColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: stored
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                (stored ? _VaultStrings.vaultStoredTag : _VaultStrings.vaultAddTag)
                    .of(language),
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: stored
                      ? const Color(0xFF1B5E20)
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
