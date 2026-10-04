import 'package:flutter/material.dart';
import '../../../core/app_language.dart';
import '../../navigator_flow/data/injury_flow_data.dart';
import '../../navigator_flow/screens/navigator_flow_screen.dart';

/// 산재처리 신청 내비게이터 진입점. 실제 화면은 NavigatorFlowScreen 엔진이 그린다.
class AccidentNavigatorScreen extends StatelessWidget {
  const AccidentNavigatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavigatorFlowScreen(
      title: L10nText(
        ko: '산재처리 신청',
        en: 'Workplace Injury Claim',
        tr: "İşyeri Yaralanması Talebi",
        tg: "Талабот оид ба ҷароҳати корӣ",
        fil: "Claim para sa Pinsala sa Trabaho",
        ur: "کام پر چوٹ کا دعویٰ",
        th: "การเรียกร้องค่าชดเชยการบาดเจ็บจากการทำงาน",
        ky: "Жумуштагы жаракат боюнча доомат",
        km: "ការទាមទារសំណងរបួសនៅកន្លែងធ្វើការ",
        id: "Klaim Cedera di Tempat Kerja",
        si: "සේවා ස්ථාන තුවාල හිමිකම් පෑම",
        bn: "কর্মক্ষেত্রে আঘাতের দাবি",
        my: "လုပ်ငန်းခွင်ထိခိုက်မှု တောင်းဆိုခြင်း",
        mn: "Ажлын байрны гэмтлийн нэхэмжлэл",
        lo: "ການຮ້ອງຂໍຄ່າຊົດເຊີຍການບາດເຈັບໃນບ່ອນເຮັດວຽກ",
        tet: "Pedidu ba Kanek iha Servisu",
        ne: "कार्यस्थलमा चोटपटकको दाबी",
        zh: '工伤处理申请',
        vi: 'Yêu cầu xử lý tai nạn lao động',
        uz: "Ish joyidagi jarohat boʻyicha daʼvo",
      ),
      definition: injuryFlowDefinition,
    );
  }
}
