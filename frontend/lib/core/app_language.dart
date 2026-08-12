/// 앱 전역 언어 상태. 선택 언어가 주 표기, 한국어는 (선택 언어가 한국어가
/// 아닐 때만) 보조로 함께 보여준다 — 출입국사무소·은행 창구에서 실제로는
/// 한국어 단어를 말해야 하기 때문에, 번역만 보여주면 현장에서 못 쓴다.
/// 온보딩(최초 실행)에서 고른 값이 앱 전역 기본값이 되고(UserProfileController),
/// 홈 화면의 언어 전환 버튼에서도 바꿀 수 있다 — 어디서 바꾸든 항상 같은 값이다.
///
/// 새 언어를 추가하려면: 1) 여기 값 하나 추가 2) L10nText에 필드 추가
/// 3) L10nText.of()에 분기 추가. 그 다음부터는 dart analyze가 안내하는 대로
/// 모든 L10nText(...) 리터럴에 새 필드값만 채우면 된다.
enum AppLanguage {
  ko('KOR', '한국어', 'Korean'),
  en('ENG', 'English', '영어'),
  zh('CHN', '中文', '중국어'),
  vi('VIE', 'Tiếng Việt', '베트남어');

  const AppLanguage(this.code, this.nativeName, this.subLabel);

  final String code;
  final String nativeName;
  final String subLabel;
}

/// ko/en/zh/vi 4개 언어 문자열 묶음. 앞으로 화면에 보여줄 텍스트는 하드코딩
/// 대신 이 타입으로 작성한다 — UI 문구(칩)는 기능별 *_strings.dart에,
/// 콘텐츠(법·제도 설명)는 해당 모델 파일에 둔다.
class L10nText {
  const L10nText({
    required this.ko,
    required this.en,
    required this.zh,
    required this.vi,
  });

  final String ko;
  final String en;
  final String zh;
  final String vi;

  String of(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.ko:
        return ko;
      case AppLanguage.en:
        return en;
      case AppLanguage.zh:
        return zh;
      case AppLanguage.vi:
        return vi;
    }
  }
}
