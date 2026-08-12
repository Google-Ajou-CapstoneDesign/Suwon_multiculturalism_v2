import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../navigator_flow/data/wage_flow_data.dart';
import '../../navigator_flow/screens/navigator_flow_screen.dart';

/// 임금체불 진정 내비게이터 진입점. 실제 화면은 NavigatorFlowScreen 엔진이 그린다.
class WageNavigatorScreen extends StatelessWidget {
  const WageNavigatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavigatorFlowScreen(
      title: L10nText(
        ko: '임금체불 진정',
        en: 'Wage Theft Complaint',
        zh: '欠薪申诉',
        vi: 'Tố cáo nợ lương',
      ),
      definition: wageFlowDefinition,
    );
  }
}
