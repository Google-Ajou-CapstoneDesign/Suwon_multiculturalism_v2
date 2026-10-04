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
  vi('VIE', 'Tiếng Việt', '베트남어'),
  uz('UZB', 'Oʻzbekcha', '우즈베크어'),
  tr('TUR', 'Türkçe', '터키어'),
  ne('NEP', 'नेपाली', '네팔어'),
  tet('TET', 'Tetun', '테툼어 · 동티모르'),
  lo('LAO', 'ລາວ', '라오스어'),
  mn('MON', 'Монгол', '몽골어'),
  my('MYA', 'မြန်မာ', '미얀마어'),
  bn('BEN', 'বাংলা', '벵골어 · 방글라데시'),
  si('SIN', 'සිංහල', '싱할라어 · 스리랑카'),
  id('IND', 'Bahasa Indonesia', '인도네시아어'),
  km('KHM', 'ខ្មែរ', '크메르어 · 캄보디아'),
  ky('KYR', 'Кыргызча', '키르기스어'),
  th('THA', 'ไทย', '태국어'),
  ur('URD', 'اردو', '우르두어 · 파키스탄'),
  fil('FIL', 'Filipino', '필리핀어'),
  tg('TGK', 'Тоҷикӣ', '타지크어');

  const AppLanguage(this.code, this.nativeName, this.subLabel);

  final String code;
  final String nativeName;
  final String subLabel;

  bool get isRtl => this == AppLanguage.ur;

  String get fontFamily => switch (this) {
    AppLanguage.ne => 'NotoSansDevanagari',
    AppLanguage.lo => 'NotoSansLao',
    AppLanguage.my => 'NotoSansMyanmar',
    AppLanguage.bn => 'NotoSansBengali',
    AppLanguage.si => 'NotoSansSinhala',
    AppLanguage.km => 'NotoSansKhmer',
    AppLanguage.th => 'NotoSansThai',
    AppLanguage.ur => 'NotoSansArabic',
    _ => 'NotoSans',
  };

  bool get requiresPdfShaping => const {
    AppLanguage.ne,
    AppLanguage.lo,
    AppLanguage.my,
    AppLanguage.bn,
    AppLanguage.si,
    AppLanguage.km,
    AppLanguage.th,
    AppLanguage.ur,
  }.contains(this);
}

/// 총 20개 언어 문자열 묶음. 앞으로 화면에 보여줄 텍스트는 하드코딩
/// 대신 이 타입으로 작성한다 — UI 문구(칩)는 기능별 *_strings.dart에,
/// 콘텐츠(법·제도 설명)는 해당 모델 파일에 둔다.
class L10nText {
  const L10nText({
    required this.ko,
    required this.en,
    required this.zh,
    required this.vi,
    required this.uz,
    required this.tr,
    required this.ne,
    required this.tet,
    required this.lo,
    required this.mn,
    required this.my,
    required this.bn,
    required this.si,
    required this.id,
    required this.km,
    required this.ky,
    required this.th,
    required this.ur,
    required this.fil,
    required this.tg,
  });

  final String ko;
  final String en;
  final String zh;
  final String vi;
  final String uz;
  final String tr;
  final String ne;
  final String tet;
  final String lo;
  final String mn;
  final String my;
  final String bn;
  final String si;
  final String id;
  final String km;
  final String ky;
  final String th;
  final String ur;
  final String fil;
  final String tg;

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
      case AppLanguage.uz:
        return uz;
      case AppLanguage.tr:
        return tr;
      case AppLanguage.ne:
        return ne;
      case AppLanguage.tet:
        return tet;
      case AppLanguage.lo:
        return lo;
      case AppLanguage.mn:
        return mn;
      case AppLanguage.my:
        return my;
      case AppLanguage.bn:
        return bn;
      case AppLanguage.si:
        return si;
      case AppLanguage.id:
        return id;
      case AppLanguage.km:
        return km;
      case AppLanguage.ky:
        return ky;
      case AppLanguage.th:
        return th;
      case AppLanguage.ur:
        return ur;
      case AppLanguage.fil:
        return fil;
      case AppLanguage.tg:
        return tg;
    }
  }
}
