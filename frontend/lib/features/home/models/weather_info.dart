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
  });

  final L10nText location;
  final String emoji;
  final L10nText condition;
  final int tempC;
  final int lowC;
  final int highC;

  static const mock = WeatherInfo(
    location: L10nText(
      ko: '수원시',
      en: 'Suwon',
      zh: '水原市',
      vi: 'Thành phố Suwon',
    ),
    emoji: '☀️',
    condition: L10nText(ko: '맑음', en: 'Clear', zh: '晴', vi: 'Trời quang'),
    tempC: 27,
    lowC: 21,
    highC: 29,
  );
}
