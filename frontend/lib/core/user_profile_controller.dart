import 'package:flutter/widgets.dart';
import 'app_language.dart';
import 'visa_status.dart';

/// 앱 전역 사용자 프로필 상태 — 언어는 온보딩에서, 체류자격·서류 보관 상태는
/// 회원가입/로그인 및 설정 화면에서 채워지고,
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

  /// 알림 설정 — 실제 푸시 인프라(FCM 등)는 아직 없어 이 기기에만 저장되는
  /// 로컬 선호값이다. 기본값 true는 지금까지 설정 화면에 하드코딩돼 있던
  /// "켜짐" 표시와 동일하게 맞춘 것.
  bool _notificationsEnabled = true;
  bool get notificationsEnabled => _notificationsEnabled;

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

  /// 계정 관련 정보를 전부 지운다 — visaStatus/증빙 보관함 상태까지 지워야
  /// 로그아웃 뒤 게스트로 돌아가거나 다른 계정으로 로그인했을 때 이전
  /// 사용자의 정보가 남아있지 않는다. onboardingCompleted는 기기 단위
  /// 값이라 그대로 둔다.
  void signOut() {
    _uid = null;
    _email = null;
    _displayName = null;
    _nationality = null;
    _visaStatus = null;
    _contractStored = false;
    _payslipStored = false;
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

  /// 설정 화면의 프로필 편집 모달이 쓴다 — 로그인 여부와 무관하게 로컬
  /// 상태만 갱신한다(백엔드에 저장할지는 호출부 책임 — 게스트는 저장할
  /// 서버 계정이 없으니 로컬에만 남긴다).
  void updateProfileFields({
    String? name,
    String? nationality,
    VisaStatus? visa,
  }) {
    if (name != null) _displayName = name;
    if (nationality != null) _nationality = nationality;
    if (visa != null) _visaStatus = visa;
    notifyListeners();
  }

  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
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
