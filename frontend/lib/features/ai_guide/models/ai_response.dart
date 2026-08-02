import '../../../common/models/org.dart';

enum RoutingModule { module1, module3Wage, module3Accident }

class RoutingTarget {
  const RoutingTarget(this.module, {this.categoryId});
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

/// 챗봇 응답 통일 데이터 모델. 백엔드 에이전트 API 응답 스키마와 1:1 대응 예정.
/// TODO(backend): POST /chat 응답을 이 모델로 파싱.
class AiResponse {
  const AiResponse({this.factAnswer, this.riskNotice, this.routingTarget, this.recommendedOrgs = const []});

  final String? factAnswer;
  final String? riskNotice;
  final RoutingTarget? routingTarget;
  final List<Org> recommendedOrgs;
}
