import 'package:flutter/material.dart';
import '../../navigator_flow/data/injury_flow_data.dart';
import '../../navigator_flow/screens/navigator_flow_screen.dart';

/// 산재처리 신청 내비게이터 진입점. 실제 화면은 NavigatorFlowScreen 엔진이 그린다.
class AccidentNavigatorScreen extends StatelessWidget {
  const AccidentNavigatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavigatorFlowScreen(title: '산재처리 신청', definition: injuryFlowDefinition);
  }
}
