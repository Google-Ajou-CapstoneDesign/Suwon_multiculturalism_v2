import '../../../core/visa_status.dart';

/// 회원가입 폼(SignupFormScreen)에서 동의 화면(ConsentScreen)으로 넘기는 임시 값.
/// 화면 2개짜리 짧은 흐름이라 별도 컨트롤러 없이 생성자 인자로만 전달한다.
class SignupDraft {
  const SignupDraft({
    required this.name,
    required this.email,
    this.password,
    required this.isGoogleFlow,
    required this.visa,
    this.customVisaText,
    required this.countryCode,
  });

  final String name;
  final String email;

  /// 이메일 가입 경로일 때만 채워진다.
  final String? password;

  /// true면 Google 로그인으로 이미 Firebase Auth 인증이 끝난 상태 —
  /// ConsentScreen에서 별도로 계정을 만들지 않고 바로 프로필만 저장한다.
  final bool isGoogleFlow;

  final VisaStatus visa;
  final String? customVisaText;
  final String countryCode;

  /// 서버에 보낼 visaType 값 — 직접입력이면 사용자가 쓴 텍스트, 아니면 코드.
  String get visaTypeValue =>
      visa == VisaStatus.etc ? (customVisaText ?? '') : visa.code;
}
