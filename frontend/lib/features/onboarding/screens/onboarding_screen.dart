import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';
import '../../auth/screens/login_screen.dart';
import '../../auth/screens/signup_form_screen.dart';
import '../models/onboarding_guide_strings.dart';

/// 최초 실행 온보딩 — 언어 → 체류자격 → 사용 설명서 3단계.
/// 화면 전체를 덮고(스플래시 아래), 완료하거나 첫 단계에서 건너뛰면 사라진다.
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
    OnboardingGuideStrings.pageTitle,
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
    OnboardingGuideStrings.pageSubtitle,
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

  void _skipLoginAndOpenGuide() {
    setState(() => _step = _totalSteps - 1);
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
                  _ => _GuideStep(key: const ValueKey(2), language: lang),
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
                      onPressed: _step == 0 ? _skipLoginAndOpenGuide : _prev,
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
                        profile.visaStatus?.label ??
                            _visaNotSetLabel.of(language),
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

class _GuideStep extends StatelessWidget {
  const _GuideStep({super.key, required this.language});
  final AppLanguage language;

  static const _moduleIcons = <IconData>[
    Icons.menu_book_rounded,
    Icons.smart_toy_rounded,
    Icons.calendar_month_rounded,
    Icons.calculate_rounded,
    Icons.alt_route_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
      children: [
        const Text(
          'Local Bridge',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          OnboardingGuideStrings.tagline.of(language),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 13),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.blueBg,
            border: Border.all(color: AppColors.blueBorder),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Text(
            OnboardingGuideStrings.introduction.of(language),
            style: const TextStyle(
              fontSize: 11.5,
              color: AppColors.textSecondary,
              height: 1.65,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: List.generate(
              OnboardingGuideStrings.modules.length,
              (index) => Column(
                children: [
                  _GuideModuleRow(
                    number: index + 1,
                    icon: _moduleIcons[index],
                    module: OnboardingGuideStrings.modules[index],
                    language: language,
                  ),
                  if (index < OnboardingGuideStrings.modules.length - 1)
                    const Divider(height: 1, color: AppColors.border),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.green50,
            border: Border.all(color: AppColors.green200),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                OnboardingGuideStrings.creatorTitle.of(language),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.green900,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Team EQ LAB',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.green900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                OnboardingGuideStrings.creatorNames.of(language),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.green900,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GuideModuleRow extends StatelessWidget {
  const _GuideModuleRow({
    required this.number,
    required this.icon,
    required this.module,
    required this.language,
  });

  final int number;
  final IconData icon;
  final OnboardingGuideModuleText module;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: number.isEven ? AppColors.green50 : AppColors.blueBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 19,
              color: number.isEven ? AppColors.green900 : AppColors.primary,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${number.toString().padLeft(2, '0')}  ${module.title.of(language)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  module.description.of(language),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
          color: selected ? const Color(0xFFE3F2FD) : Colors.white,
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
