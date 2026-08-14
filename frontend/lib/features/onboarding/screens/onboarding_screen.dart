import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';
import '../../auth/screens/login_screen.dart';
import '../../auth/screens/signup_form_screen.dart';

/// 최초 실행 온보딩 — 언어 → 체류자격 → 서류 보관함 3단계.
/// 화면 전체를 덮고(스플래시 아래), 완료하거나 첫 단계에서 건너뛰면 사라진다.
/// 서류 보관함은 실제 파일 업로드가 아니라 "넣어뒀다"는 상태만 기록하는 데모다.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;

  static const _totalSteps = 3;

  static const _titles = [
    L10nText(
      ko: '어떤 언어로 볼까요?',
      en: 'Which language do you read?',
      zh: '想用哪种语言查看？',
      vi: 'Bạn đọc bằng ngôn ngữ nào?',
    ),
    L10nText(
      ko: '로그인하고 시작하세요',
      en: 'Log in to get started',
      zh: '登录后开始使用',
      vi: 'Đăng nhập để bắt đầu',
    ),
    L10nText(
      ko: '서류를 미리 넣어두세요',
      en: 'Store your documents now',
      zh: '请提前保存好证件资料',
      vi: 'Hãy lưu giấy tờ trước',
    ),
  ];

  static const _subtitles = [
    L10nText(
      ko: '어떤 언어를 골라도 한국어 표기는 함께 보여드립니다. 기관에서 그대로 말할 수 있도록요.',
      en: 'Whichever you pick, the Korean term stays alongside — so you can say it as-is at an office.',
      zh: '无论选择哪种语言，都会同时显示韩语原文，方便您在机构窗口照原文说出来。',
      vi: 'Dù chọn ngôn ngữ nào, thuật ngữ tiếng Hàn vẫn hiện kèm để bạn nói nguyên văn tại cơ quan.',
    ),
    L10nText(
      ko: '가입할 때 등록한 체류자격이 MY VISA 카드에 자동으로 반영됩니다. 로그인 없이도 계속 진행할 수 있어요.',
      en: 'The visa status you registered is applied to your MY VISA card automatically. You can still continue without logging in.',
      zh: '注册时登记的居留资格将自动显示在MY VISA卡片中。不登录也可以继续。',
      vi: 'Tư cách lưu trú bạn đăng ký sẽ tự động áp dụng vào thẻ MY VISA. Bạn vẫn có thể tiếp tục mà không cần đăng nhập.',
    ),
    L10nText(
      ko: '근로계약서와 임금명세서는 나중에 가장 강한 증거가 됩니다. 지금 넣어두면 잃어버리지 않습니다.',
      en: 'Your contract and payslips become the strongest evidence later. Store them now so you do not lose them.',
      zh: '劳动合同和工资单日后将成为最有力的证据。现在保存好，以免遗失。',
      vi: 'Hợp đồng và phiếu lương sau này là chứng cứ mạnh nhất. Lưu ngay để không bị mất.',
    ),
  ];

  static const _skipLabel = L10nText(
    ko: '로그인 없이 이용하기\n(데모버전)',
    en: 'Continue without login\n(demo)',
    zh: '不登录使用\n（演示版）',
    vi: 'Dùng không cần đăng nhập\n(bản demo)',
  );
  static const _prevLabel = L10nText(
    ko: '이전',
    en: 'Back',
    zh: '上一步',
    vi: 'Trước',
  );
  static const _nextLabel = L10nText(
    ko: '다음',
    en: 'Next',
    zh: '下一步',
    vi: 'Tiếp',
  );
  static const _startLabel = L10nText(
    ko: '시작하기',
    en: 'Get started',
    zh: '开始使用',
    vi: 'Bắt đầu',
  );

  void _next() {
    if (_step < _totalSteps - 1) {
      setState(() => _step++);
    } else {
      widget.onFinished();
    }
  }

  void _prev() {
    if (_step == 0) {
      widget.onFinished();
    } else {
      setState(() => _step--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = UserProfileScope.of(context);
    final lang = profile.language;

    return Material(
      color: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(_totalSteps, (i) {
                      return Expanded(
                        child: Container(
                          height: 3,
                          margin: EdgeInsets.only(
                            right: i < _totalSteps - 1 ? 5 : 0,
                          ),
                          decoration: BoxDecoration(
                            color: i <= _step
                                ? AppColors.primary
                                : AppColors.border,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _titles[_step].of(lang),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _subtitles[_step].of(lang),
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textMuted,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: switch (_step) {
                  0 => _LanguageStep(key: const ValueKey(0), profile: profile),
                  1 => _VisaStep(
                    key: const ValueKey(1),
                    profile: profile,
                    language: lang,
                    onAuthenticated: _next,
                  ),
                  _ => _VaultStep(
                    key: const ValueKey(2),
                    profile: profile,
                    language: lang,
                  ),
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 11, 16, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _prev,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        foregroundColor: AppColors.textSecondary,
                        side: BorderSide.none,
                        backgroundColor: const Color(0xFFF1F5F9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      child: Text(
                        (_step == 0 ? _skipLabel : _prevLabel).of(lang),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _step == 0 ? 11 : 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      child: Text(
                        (_step == _totalSteps - 1 ? _startLabel : _nextLabel)
                            .of(lang),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageStep extends StatelessWidget {
  const _LanguageStep({super.key, required this.profile});
  final UserProfileController profile;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      children: [
        for (final lang in AppLanguage.values)
          _PickRow(
            code: lang.code,
            title: lang.nativeName,
            subtitle: lang.subLabel,
            selected: profile.language == lang,
            onTap: () => profile.setLanguage(lang),
          ),
      ],
    );
  }
}

const _signedInAsLabel = L10nText(
  ko: '로그인됨',
  en: 'Signed in',
  zh: '已登录',
  vi: 'Đã đăng nhập',
);
const _visaNotSetLabel = L10nText(
  ko: '체류자격 미등록 · 설정에서 나중에 등록할 수 있어요',
  en: 'Visa status not set · you can add it later in settings',
  zh: '尚未登记居留资格 · 可稍后在设置中登记',
  vi: 'Chưa đăng ký tư cách lưu trú · có thể thêm sau trong cài đặt',
);
const _noAccountLabel = L10nText(
  ko: '아직 가입하지 않으셨나요? 회원가입하기',
  en: "Haven't signed up yet? Create an account",
  zh: '还没有注册？去注册',
  vi: 'Chưa đăng ký? Đăng ký ngay',
);

class _VisaStep extends StatelessWidget {
  const _VisaStep({
    super.key,
    required this.profile,
    required this.language,
    required this.onAuthenticated,
  });

  final UserProfileController profile;
  final AppLanguage language;
  final VoidCallback onAuthenticated;

  Future<void> _openSignup(BuildContext context) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SignupFormScreen()));
    if (profile.isSignedIn) onAuthenticated();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      children: [
        if (profile.isSignedIn)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.blueBg,
              border: Border.all(color: AppColors.blueBorder),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${profile.displayName ?? profile.email ?? ''} · ${_signedInAsLabel.of(language)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.visaStatus?.label ?? _visaNotSetLabel.of(language),
                        style: TextStyle(
                          fontSize: 11,
                          color: profile.visaStatus != null
                              ? AppColors.textSecondary
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(14),
            ),
            child: LoginFormBody(onSuccess: onAuthenticated),
          ),
          const SizedBox(height: 18),
          Center(
            child: TextButton(
              onPressed: () => _openSignup(context),
              child: Text(
                _noAccountLabel.of(language),
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _VaultStep extends StatelessWidget {
  const _VaultStep({super.key, required this.profile, required this.language});
  final UserProfileController profile;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      children: [
        _VaultPickCard(
          emoji: '📄',
          title: const L10nText(
            ko: '근로계약서 넣기',
            en: 'Add your employment contract',
            zh: '添加劳动合同',
            vi: 'Thêm hợp đồng lao động',
          ).of(language),
          doneLabel: const L10nText(
            ko: '보관됨',
            en: 'Stored',
            zh: '已保存',
            vi: 'Đã lưu',
          ).of(language),
          idleLabel: const L10nText(
            ko: '사진 · PDF · 카카오톡 캡처 모두 됩니다',
            en: 'Photo, PDF or a KakaoTalk screenshot all work',
            zh: '支持照片、PDF、KakaoTalk截图等各种格式',
            vi: 'Ảnh, PDF hay ảnh chụp KakaoTalk đều được',
          ).of(language),
          done: profile.contractStored,
          onTap: profile.toggleContractStored,
        ),
        const SizedBox(height: 9),
        _VaultPickCard(
          emoji: '🧾',
          title: const L10nText(
            ko: '임금명세서 넣기',
            en: 'Add a payslip',
            zh: '添加工资单',
            vi: 'Thêm phiếu lương',
          ).of(language),
          doneLabel: const L10nText(
            ko: '보관됨',
            en: 'Stored',
            zh: '已保存',
            vi: 'Đã lưu',
          ).of(language),
          idleLabel: const L10nText(
            ko: '사진 · PDF · 카카오톡 캡처 모두 됩니다',
            en: 'Photo, PDF or a KakaoTalk screenshot all work',
            zh: '支持照片、PDF、KakaoTalk截图等各种格式',
            vi: 'Ảnh, PDF hay ảnh chụp KakaoTalk đều được',
          ).of(language),
          done: profile.payslipStored,
          onTap: profile.togglePayslipStored,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF7F5),
            border: Border.all(color: const Color(0xFFB4E0D9)),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Text(
            const L10nText(
              ko: '💡 여기서 넣은 서류는 임금체불·산재 신고 때 가장 먼저 요구되는 증거입니다. 실제 업로드는 근무기록장 탭에서도 언제든 할 수 있어요.',
              en: '💡 Documents you store here are the first evidence asked for when filing a wage or injury claim. You can always upload for real from the Work log tab.',
              zh: '💡 在这里保存的资料是申报欠薪、工伤时最先被要求提供的证据。您也可以随时在工作记录本标签页中进行实际上传。',
              vi: '💡 Giấy tờ lưu ở đây là bằng chứng đầu tiên được yêu cầu khi khiếu nại nợ lương hoặc tai nạn lao động. Bạn luôn có thể tải lên thật từ tab Nhật ký làm việc.',
            ).of(language),
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF0F766E),
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _PickRow extends StatelessWidget {
  const _PickRow({
    required this.code,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String code;
  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF3F7FF) : Colors.white,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              constraints: const BoxConstraints(minWidth: 40),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.textMuted,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                code,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check, size: 16, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

class _VaultPickCard extends StatelessWidget {
  const _VaultPickCard({
    required this.emoji,
    required this.title,
    required this.doneLabel,
    required this.idleLabel,
    required this.done,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String doneLabel;
  final String idleLabel;
  final bool done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 13),
        decoration: BoxDecoration(
          color: done ? const Color(0xFFEAF7F5) : const Color(0xFFFBFDFF),
          border: Border.all(
            color: done ? const Color(0xFFB4E0D9) : const Color(0xFFC6D2E2),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 7),
            Text(
              done ? '$title ✓' : title,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: done ? const Color(0xFF0B7267) : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              done ? doneLabel : idleLabel,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10.5,
                color: AppColors.textMuted,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
