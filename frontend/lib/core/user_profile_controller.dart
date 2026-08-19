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

  /// Firebase Auth uid — null이면 로그인하지 않은 게스트 상태.
  String? _uid;
  String? get uid => _uid;

  String? _email;
  String? get email => _email;

  String? _displayName;
  String? get displayName => _displayName;

  /// ISO 3166-1 alpha-2 국가 코드(frontend/lib/features/auth/models/country.dart 참고).
  String? _nationality;
  String? get nationality => _nationality;

  bool get isSignedIn => _uid != null;

  /// 화면에 보여줄 이름 — 프로필에 저장된 이름이 없으면(예: 아직 백엔드에
  /// name을 채우지 않은 계정) 이메일의 '@' 앞부분을 대신 쓴다. 비로그인이면
  /// null이라 호출부가 게스트 문구로 대체한다.
  String? get displayNameOrEmailPrefix {
    if (!isSignedIn) return null;
    if (_displayName != null && _displayName!.isNotEmpty) return _displayName;
    final email = _email;
    if (email == null || email.isEmpty) return null;
    final at = email.indexOf('@');
    return at > 0 ? email.substring(0, at) : email;
  }

  /// 로그인/회원가입 성공 직후 한 번에 반영한다.
  void applyAuthenticatedProfile({
    required String uid,
    String? email,
    String? name,
    VisaStatus? visa,
    String? nationality,
  }) {
    _uid = uid;
    _email = email;
    _displayName = name;
    if (visa != null) _visaStatus = visa;
    _nationality = nationality;
    notifyListeners();
  }

  void signOut() {
    _uid = null;
    _email = null;
    _displayName = null;
    _nationality = null;
    notifyListeners();
  }

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
