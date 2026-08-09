/// 앱 전역 언어 상태. 선택 언어가 주 표기, 한국어는 (선택 언어가 한국어가
/// 아닐 때만) 보조로 함께 보여준다 — 출입국사무소·은행 창구에서 실제로는
/// 한국어 단어를 말해야 하기 때문에, 번역만 보여주면 현장에서 못 쓴다.
/// 온보딩(최초 실행)에서 고른 값이 기본값이 되고, 백과사전 탭에서도 바꿀 수 있다.
enum AppLanguage {
  ko('KOR', '한국어', 'Korean'),
  en('ENG', 'English', '영어'),
  vi('VIE', 'Tiếng Việt', '베트남어');

  const AppLanguage(this.code, this.nativeName, this.subLabel);

  final String code;
  final String nativeName;
  final String subLabel;
}

/// ko/en/vi 3개 언어 문자열 묶음. 언어가 늘어나면 여기만 확장하면 된다.
class L10nText {
  const L10nText({required this.ko, required this.en, required this.vi});

  final String ko;
  final String en;
  final String vi;

  String of(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.ko:
        return ko;
      case AppLanguage.en:
        return en;
      case AppLanguage.vi:
        return vi;
    }
  }
}
