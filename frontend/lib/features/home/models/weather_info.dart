import '../../../core/app_language.dart';

const _locationSuwon = L10nText(
  ko: '수원시',
  en: 'Suwon',
  tr: "Suwon",
  zh: '水原市',
  vi: 'Thành phố Suwon',
  uz: "Suvon",
);

/// 백엔드가 내려주는 conditionCode → 4개 언어 문구. 날씨 상태 자체는 백엔드가
/// 판단하지만(Open-Meteo WMO 코드 매핑), 번역은 이 앱의 다른 데이터와 마찬가지로
/// 항상 프론트 쪽 책임이다.
const _conditionLabels = <String, L10nText>{
  'clear': L10nText(
    ko: '맑음',
    en: 'Clear',
    tr: "Açık",
    zh: '晴',
    vi: 'Trời quang',
    uz: "Ochiq",
  ),
  'partlyCloudy': L10nText(
    ko: '구름 조금',
    en: 'Partly cloudy',
    tr: "Parçalı bulutlu",
    zh: '少云',
    vi: 'Ít mây',
    uz: "Qisman bulutli",
  ),
  'cloudy': L10nText(
    ko: '흐림',
    en: 'Cloudy',
    tr: "Bulutlu",
    zh: '多云',
    vi: 'Nhiều mây',
    uz: "Bulutli",
  ),
  'fog': L10nText(
    ko: '안개',
    en: 'Fog',
    tr: "Sisli",
    zh: '雾',
    vi: 'Sương mù',
    uz: "Tuman",
  ),
  'drizzle': L10nText(
    ko: '이슬비',
    en: 'Drizzle',
    tr: "Çiseleme",
    zh: '毛毛雨',
    vi: 'Mưa phùn',
    uz: "Mayda yomgʻir",
  ),
  'rain': L10nText(
    ko: '비',
    en: 'Rain',
    tr: "Yağmurlu",
    zh: '雨',
    vi: 'Mưa',
    uz: "Yomgʻir",
  ),
  'snow': L10nText(
    ko: '눈',
    en: 'Snow',
    tr: "Karlı",
    zh: '雪',
    vi: 'Tuyết',
    uz: "Qor",
  ),
  'thunderstorm': L10nText(
    ko: '뇌우',
    en: 'Thunderstorm',
    tr: "Gök gürültülü fırtına",
    zh: '雷雨',
    vi: 'Dông bão',
    uz: "Momaqaldiroq",
  ),
};

/// 홈 화면 상단 날씨 카드용 데이터. GET /api/weather(수원시 좌표 고정, Open-Meteo
/// 실시간 연동)를 우선 쓰고, 조회에 실패하면 [mock]으로 대체한다.
class WeatherInfo {
  const WeatherInfo({
    required this.location,
    required this.emoji,
    required this.condition,
    required this.tempC,
    required this.lowC,
    required this.highC,
    required this.feelsLikeC,
  });

  final L10nText location;
  final String emoji;
  final L10nText condition;
  final int tempC;
  final int lowC;
  final int highC;

  /// 체감온도 — 33도 이상이면 홈 화면에 온열질환 주의 안내가 붙는다.
  final int feelsLikeC;

  /// 온열질환 주의를 띄울 기준(기상청 폭염특보 실무 기준과 동일하게 33도).
  bool get heatWarning => feelsLikeC >= 33;

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    final code = json['conditionCode'] as String? ?? 'cloudy';
    return WeatherInfo(
      location: _locationSuwon,
      emoji: json['emoji'] as String? ?? '☁️',
      condition: _conditionLabels[code] ?? _conditionLabels['cloudy']!,
      tempC: (json['tempC'] as num).round(),
      feelsLikeC: (json['feelsLikeC'] as num).round(),
      lowC: (json['lowC'] as num).round(),
      highC: (json['highC'] as num).round(),
    );
  }

  /// 서버 연결 전(로딩 중) 또는 조회 실패 시 보여주는 대체 값.
  static const mock = WeatherInfo(
    location: _locationSuwon,
    emoji: '☀️',
    condition: L10nText(
      ko: '맑음',
      en: 'Clear',
      tr: "Açık",
      zh: '晴',
      vi: 'Trời quang',
      uz: "Ochiq",
    ),
    tempC: 31,
    lowC: 24,
    highC: 33,
    feelsLikeC: 34,
  );
}
