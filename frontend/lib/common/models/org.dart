/// 위치 기반 추천 기관. 백엔드 라우팅 API(/api/orgs, /api/chat) 응답과 매칭된다.
class Org {
  const Org({required this.name, required this.distanceKm});

  factory Org.fromJson(Map<String, dynamic> json) => Org(
    name: json['name'] as String,
    distanceKm: (json['distanceKm'] as num).toDouble(),
  );

  final String name;
  final double distanceKm;
}
