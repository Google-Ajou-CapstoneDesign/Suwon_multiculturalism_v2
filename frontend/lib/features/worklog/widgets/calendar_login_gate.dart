import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../../theme/app_colors.dart';
import '../../auth/screens/login_screen.dart';
import '../../auth/screens/signup_form_screen.dart';

/// 캘린더(근무기록장) 진입 게이트 문구. 온보딩에 있던 로그인 단계를 그대로
/// 옮겨왔다 — 이 앱에서 로그인이 실제로 필요한 탭은 캘린더뿐이라, 앱을 열자마자
/// 로그인부터 강제하는 대신 캘린더를 켤 때만 물어보고 데모로도 계속 이용할 수
/// 있게 한다.
class _S {
  _S._();

  static const title = L10nText(
    ko: '로그인하고 근무기록을 저장하세요',
    en: 'Log in to save your work log',
    zh: '登录后保存工作记录',
    vi: 'Đăng nhập để lưu nhật ký làm việc',
  );
  static const subtitle = L10nText(
    ko: '로그인하면 출퇴근·위치 인증 기록이 서버에 안전하게 저장돼요. 로그인 없이도 데모로 먼저 둘러볼 수 있어요.',
    en: "Logging in keeps your clock-in/out and location records safely on the server. You can still explore the demo without logging in.",
    zh: '登录后，上下班打卡和位置认证记录会安全保存在服务器上。不登录也可以先体验演示版。',
    vi: 'Đăng nhập giúp lưu an toàn giờ vào/ra ca và xác minh vị trí lên máy chủ. Bạn vẫn có thể dùng thử bản demo mà không cần đăng nhập.',
  );
  static const close = L10nText(ko: '닫기', en: 'Close', zh: '关闭', vi: 'Đóng');
  static const noAccountLabel = L10nText(
    ko: '아직 가입하지 않으셨나요? 회원가입하기',
    en: "Haven't signed up yet? Create an account",
    zh: '还没有注册？去注册',
    vi: 'Chưa đăng ký? Đăng ký ngay',
  );
  static const orDivider = L10nText(ko: '또는', en: 'or', zh: '或', vi: 'hoặc');
  static const demoLabel = L10nText(
    ko: '로그인 없이 이용하기 (데모버전)',
    en: 'Continue without login (demo)',
    zh: '不登录使用（演示版）',
    vi: 'Dùng không cần đăng nhập (bản demo)',
  );
}

/// 하단 "캘린더" 탭을 켤 때, 로그인하지 않았고 이번 세션에서 아직 데모를
/// 선택하지도 않았다면 [MainShell]이 [WorkLogSheet] 대신 이 게이트를 먼저
/// 띄운다. [onLoginSuccess]나 [onContinueAsDemo]가 호출되면 그제서야 실제
/// 캘린더가 열린다 — [onClose]는 아무것도 선택하지 않고 그냥 닫을 때(뒤로가기,
/// X 버튼, 캘린더 탭 재탭)만 쓰인다.
class CalendarLoginGate extends StatelessWidget {
  const CalendarLoginGate({
    super.key,
    required this.isOpen,
    required this.onClose,
    required this.onContinueAsDemo,
    required this.onLoginSuccess,
  });

  final bool isOpen;
  final VoidCallback onClose;
  final VoidCallback onContinueAsDemo;
  final VoidCallback onLoginSuccess;

  Future<void> _openSignup(BuildContext context) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SignupFormScreen()));
    if (context.mounted && UserProfileScope.of(context).isSignedIn) {
      onLoginSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = UserProfileScope.of(context).language;
    return IgnorePointer(
      ignoring: !isOpen,
      child: AnimatedSlide(
        offset: isOpen ? Offset.zero : const Offset(0, 1),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        child: Material(
          color: AppColors.background,
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                const _Grabber(),
                _GateHeader(onClose: onClose, language: lang),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: LoginFormBody(onSuccess: onLoginSuccess),
                        ),
                        const SizedBox(height: 14),
                        Center(
                          child: TextButton(
                            onPressed: () => _openSignup(context),
                            child: Text(
                              _S.noAccountLabel.of(lang),
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                _S.orDivider.of(lang),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 18),
                        OutlinedButton(
                          onPressed: onContinueAsDemo,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textSecondary,
                            backgroundColor: const Color(0xFFF1F5F9),
                            side: BorderSide.none,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                          child: Text(
                            _S.demoLabel.of(lang),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Grabber extends StatelessWidget {
  const _Grabber();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 4,
      margin: const EdgeInsets.only(top: 8, bottom: 2),
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _GateHeader extends StatelessWidget {
  const _GateHeader({required this.onClose, required this.language});
  final VoidCallback onClose;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 12, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _S.title.of(language),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _S.subtitle.of(language),
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textMuted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onClose,
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFF1F5F9),
              foregroundColor: AppColors.textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              _S.close.of(language),
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
