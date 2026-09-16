/// 위치 기반 추천 기관. 백엔드 라우팅 API(/api/orgs, /api/chat) 응답과 매칭된다.
class Org {
  const Org({
    required this.name,
    required this.distanceKm,
    this.address,
    this.phoneNumber,
    this.businessHours,
  });

  factory Org.fromJson(Map<String, dynamic> json) => Org(
    name: json['name'] as String,
    distanceKm: (json['distanceKm'] as num?)?.toDouble(),
    address: json['address'] as String?,
    phoneNumber: json['phoneNumber'] as String?,
    businessHours: json['businessHours'] as String?,
  );

  final String name;
  final double? distanceKm;
  final String? address;
  final String? phoneNumber;
  final String? businessHours;
}
