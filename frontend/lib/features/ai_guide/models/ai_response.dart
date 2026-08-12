import '../../../common/models/org.dart';
import '../../../core/app_language.dart';

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

  String labelOf(AppLanguage lang) {
    switch (module) {
      case RoutingModule.module1:
        return const L10nText(
          ko: '관련 정보 페이지로 이동',
          en: 'Go to related info',
          zh: '前往相关信息页面',
          vi: 'Đi đến trang thông tin liên quan',
        ).of(lang);
      case RoutingModule.module3Wage:
        return const L10nText(
          ko: '임금체불 대응 네비게이터로 이동',
          en: 'Go to the unpaid wage navigator',
          zh: '前往拖欠工资应对导航',
          vi: 'Đi đến hướng dẫn xử lý nợ lương',
        ).of(lang);
      case RoutingModule.module3Accident:
        return const L10nText(
          ko: '산재 대응 네비게이터로 이동',
          en: 'Go to the workplace injury navigator',
          zh: '前往工伤应对导航',
          vi: 'Đi đến hướng dẫn xử lý tai nạn lao động',
        ).of(lang);
    }
  }
}

/// 챗봇 응답 통일 데이터 모델. backend `ChatResponse`(app/schemas/chat.py)와 1:1 대응.
class AiResponse {
  const AiResponse({
    this.factAnswer,
    this.riskNotice,
    this.routingTarget,
    this.recommendedOrgs = const [],
  });

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
