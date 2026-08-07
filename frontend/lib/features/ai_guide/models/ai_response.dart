import '../../../common/models/org.dart';

enum RoutingModule { module1, module3Wage, module3Accident }

RoutingModule _moduleFromJson(String value) {
  switch (value) {
    case 'module1':
      return RoutingModule.module1;
    case 'module3-wage':
      return RoutingModule.module3Wage;
    case 'module3-accident':
      return RoutingModule.module3Accident;
    default:
      throw FormatException('알 수 없는 routingTarget.module 값: $value');
  }
}

class RoutingTarget {
  const RoutingTarget(this.module, {this.categoryId});

  factory RoutingTarget.fromJson(Map<String, dynamic> json) => RoutingTarget(
        _moduleFromJson(json['module'] as String),
        categoryId: json['categoryId'] as String?,
      );

  final RoutingModule module;
  final String? categoryId;

  String get label {
    switch (module) {
      case RoutingModule.module1:
        return '관련 정보 페이지로 이동';
      case RoutingModule.module3Wage:
        return '임금체불 대응 네비게이터로 이동';
      case RoutingModule.module3Accident:
        return '산재 대응 네비게이터로 이동';
    }
  }
}

/// 챗봇 응답 통일 데이터 모델. backend `ChatResponse`(app/schemas/chat.py)와 1:1 대응.
class AiResponse {
  const AiResponse({this.factAnswer, this.riskNotice, this.routingTarget, this.recommendedOrgs = const []});

  factory AiResponse.fromJson(Map<String, dynamic> json) => AiResponse(
        factAnswer: json['factAnswer'] as String?,
        riskNotice: json['riskNotice'] as String?,
        routingTarget: json['routingTarget'] == null
            ? null
            : RoutingTarget.fromJson(json['routingTarget'] as Map<String, dynamic>),
        recommendedOrgs: (json['recommendedOrgs'] as List<dynamic>? ?? const [])
            .map((e) => Org.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  final String? factAnswer;
  final String? riskNotice;
  final RoutingTarget? routingTarget;
  final List<Org> recommendedOrgs;
}
