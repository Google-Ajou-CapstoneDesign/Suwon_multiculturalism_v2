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
        tr: "Ücret Hırsızlığı Şikayeti",
        tg: "Шикоят оид ба дуздии музд",
        fil: "Reklamo sa Pagnanakaw ng Sahod",
        ur: "اجرت کی چوری کی شکایت",
        th: "การร้องเรียนการขโมยค่าจ้าง",
        ky: "Эмгек акыны уурдоо боюнча арыз",
        km: "បណ្ដឹងលួចប្រាក់ឈ្នួល",
        id: "Pengaduan Pencurian Upah",
        si: "වැටුප් සොරකම් පැමිණිල්ල",
        bn: "বেতন চুরির অভিযোগ",
        my: "လုပ်ခခိုးယူမှု တိုင်ကြားခြင်း",
        mn: "Цалин хулгайлсан тухай гомдол",
        lo: "ການຮ້ອງຮຽນການລັກຄ່າຈ້າງ",
        tet: "Keixa kona-ba Na'ok Saláriu",
        ne: "तलब चोरीको उजुरी",
        zh: '欠薪申诉',
        vi: 'Tố cáo nợ lương',
        uz: "Ish haqi oʻgʻirligi boʻyicha shikoyat",
      ),
      definition: wageFlowDefinition,
    );
  }
}
