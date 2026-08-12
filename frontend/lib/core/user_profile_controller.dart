import 'package:flutter/widgets.dart';
import 'app_language.dart';
import 'visa_status.dart';

/// 앱 전역 사용자 프로필 상태 — 온보딩(언어·체류자격·서류 보관)에서 채워지고,
/// 백과사전의 언어 전환·MY VISA 카드가 이 값을 그대로 읽고 쓴다.
/// TODO(backend): 로그인 연동 전까지는 세션 동안만 유지되는 로컬 상태다(재시작 시 초기화).
class UserProfileController extends ChangeNotifier {
  AppLanguage _language = AppLanguage.ko;
  AppLanguage get language => _language;

  VisaStatus? _visaStatus;
  VisaStatus? get visaStatus => _visaStatus;

  /// 근로계약서 보관함에 넣었는지 — 실제 파일 업로드가 아니라 "넣어뒀다"는 상태만 기록한다.
  bool _contractStored = false;
  bool get contractStored => _contractStored;

  bool _payslipStored = false;
  bool get payslipStored => _payslipStored;

  bool _onboardingCompleted = false;
  bool get onboardingCompleted => _onboardingCompleted;

  void setLanguage(AppLanguage lang) {
    if (_language == lang) return;
    _language = lang;
    notifyListeners();
  }

  void setVisaStatus(VisaStatus status) {
    _visaStatus = status;
    notifyListeners();
  }

  void toggleContractStored() {
    _contractStored = !_contractStored;
    notifyListeners();
  }

  void togglePayslipStored() {
    _payslipStored = !_payslipStored;
    notifyListeners();
  }

  void completeOnboarding() {
    _onboardingCompleted = true;
    notifyListeners();
  }
}

/// 위젯 트리 어디서나 UserProfileController에 접근할 수 있게 하는 스코프.
class UserProfileScope extends InheritedNotifier<UserProfileController> {
  const UserProfileScope({
    super.key,
    required UserProfileController controller,
    required super.child,
  }) : super(notifier: controller);

  static UserProfileController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<UserProfileScope>();
    assert(scope != null, 'UserProfileScope가 위젯 트리 위쪽에 없습니다.');
    return scope!.notifier!;
  }
}
