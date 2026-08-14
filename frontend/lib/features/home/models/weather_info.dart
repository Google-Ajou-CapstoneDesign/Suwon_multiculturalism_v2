import '../../../core/app_language.dart';

/// 홈 화면 상단 날씨 카드용 데이터.
/// TODO(backend): 기상청/날씨 API 연동 후 실제 값으로 교체 — 지금은 수원시 고정 목업.
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

  static const mock = WeatherInfo(
    location: L10nText(
      ko: '수원시',
      en: 'Suwon',
      zh: '水原市',
      vi: 'Thành phố Suwon',
    ),
    emoji: '☀️',
    condition: L10nText(ko: '맑음', en: 'Clear', zh: '晴', vi: 'Trời quang'),
    tempC: 31,
    lowC: 24,
    highC: 33,
    feelsLikeC: 34,
  );
}
