import 'package:flutter/material.dart';
import '../../navigator_flow/data/wage_flow_data.dart';
import '../../navigator_flow/screens/navigator_flow_screen.dart';

/// 임금체불 진정 내비게이터 진입점. 실제 화면은 NavigatorFlowScreen 엔진이 그린다.
class WageNavigatorScreen extends StatelessWidget {
  const WageNavigatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavigatorFlowScreen(title: '임금체불 진정', definition: wageFlowDefinition);
  }
}
