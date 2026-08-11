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

  final String location;
  final String emoji;
  final String condition;
  final int tempC;
  final int lowC;
  final int highC;

  static const mock = WeatherInfo(
    location: '수원시',
    emoji: '☀️',
    condition: '맑음',
    tempC: 27,
    lowC: 21,
    highC: 29,
  );
}
