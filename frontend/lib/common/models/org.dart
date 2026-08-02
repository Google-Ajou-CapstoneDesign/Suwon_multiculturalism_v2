/// 위치 기반 추천 기관. 백엔드 라우팅 API 응답 모델과 매칭될 예정.
class Org {
  const Org({required this.name, required this.distanceKm});

  final String name;
  final double distanceKm;
}
