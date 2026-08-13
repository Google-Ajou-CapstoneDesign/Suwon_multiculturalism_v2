import 'package:flutter/material.dart';
import '../../wage_calculator/models/wage_diagnosis.dart';

/// 임금체불 내비게이터 2단계(WageCalcBlock)가 소유하는 계산 스크래치패드.
/// 정식 임금계산기 화면과는 별개의 화면 로컬 상태다(세션 한정) — 계산기 결과를
/// 진정서로 자동으로 넘기지 않는다는 원칙을 지키기 위해 unpaidtotal 등은 여기
/// 값을 참고용 힌트로만 보여주고, 실제 서식 입력은 사용자가 직접 한다.
class WageCalcScratchController extends ChangeNotifier {
  WageCalcInput input = const WageCalcInput();
  WageCalcResult? result;

  bool get loaded => result != null;

  void update(WageCalcInput Function(WageCalcInput current) updater) {
    input = updater(input);
    notifyListeners();
  }

  void calculate() {
    result = calcWage(input);
    notifyListeners();
  }

  void reset() {
    result = null;
    notifyListeners();
  }
}
