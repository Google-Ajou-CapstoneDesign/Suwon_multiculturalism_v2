import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

/// firebase_auth 얇은 래퍼 — 이메일/비밀번호 가입·로그인과 Google 로그인만 지원한다
/// (OAuth 제공자는 1차로 Google만, 추후 확장 가능).
class AuthService {
  AuthService({FirebaseAuth? auth, GoogleSignIn? googleSignIn})
    : _auth = auth ?? FirebaseAuth.instance,
      _providedGoogleSignIn = googleSignIn;

  final FirebaseAuth _auth;
  final GoogleSignIn? _providedGoogleSignIn;
  GoogleSignIn? _googleSignInInstance;

  /// google_sign_in의 플랫폼 초기화는 실제로 로그인/로그아웃을 시도할 때만
  /// 일어나야 한다 — AuthService를 만드는 것만으로(예: 화면의 필드 초기화 시점)
  /// 바로 인스턴스를 만들면 웹에서 클라이언트 ID 설정 여부에 따라 화면 빌드
  /// 자체가 실패할 수 있다.
  GoogleSignIn get _googleSignIn =>
      _providedGoogleSignIn ?? (_googleSignInInstance ??= GoogleSignIn());

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signUpWithEmail(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// 웹에서는 signInWithPopup 대신 signInWithRedirect를 쓴다 — 최신 Chrome의
  /// Cross-Origin-Opener-Policy가 팝업의 window.closed 감지를 막아버려서
  /// 로그인 팝업이 뜨자마자 응답 없이 끝나버리는 문제가 있다(호스팅 서버가
  /// COOP 헤더를 따로 설정해주지 않는 한 재현됨). 리다이렉트는 이 문제 자체가
  /// 없고 호스팅 설정에 의존하지 않는다 — 대신 페이지 전체가 이동했다 돌아오므로
  /// 여기서는 값을 돌려주지 못한다(호출 직후 화면이 사라짐). 앱 재시작 시
  /// [consumeRedirectResult]로 결과를 받는다.
  ///
  /// 웹이 아닌 플랫폼(모바일)은 google_sign_in으로 즉시 로그인하고 결과를
  /// 바로 반환한다 — 사용자가 취소하면 null(에러 아님).
  Future<UserCredential?> signInWithGoogle() async {
    if (kIsWeb) {
      await _auth.signInWithRedirect(GoogleAuthProvider());
      return null;
    }
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  /// 앱이 (다시) 시작될 때 한 번 호출한다 — [signInWithGoogle]의 리다이렉트로
  /// 떠났다가 돌아온 경우 그 결과를 받는다. 리다이렉트가 없었던 평범한 로딩이면
  /// null을 반환한다.
  Future<UserCredential?> consumeRedirectResult() async {
    if (!kIsWeb) return null;
    final result = await _auth.getRedirectResult();
    return result.user == null ? null : result;
  }

  Future<void> updateDisplayName(String name) async {
    await _auth.currentUser?.updateDisplayName(name);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    if (!kIsWeb) await _googleSignIn.signOut();
  }

  Future<String?> currentIdToken() =>
      _auth.currentUser?.getIdToken() ?? Future.value(null);
}
