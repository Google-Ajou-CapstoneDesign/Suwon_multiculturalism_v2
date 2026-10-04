import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../core/app_language.dart';
import '../controllers/form_values_controller.dart';
import '../models/form_field_spec.dart';
import '../pdf/complaint_pdf_builder.dart';
import '../screens/pdf_preview_screen.dart';

const _pdfBoxTitle = L10nText(
  ko: 'PDF로 저장',
  en: 'Save as PDF',
  tr: "PDF olarak kaydet",
  tg: "Ҳамчун PDF захира кунед",
  fil: "I-save bilang PDF",
  ur: "پی ڈی ایف کے طور پر محفوظ کریں",
  th: "บันทึกเป็น PDF",
  ky: "PDF катары сактоо",
  km: "រក្សាទុកជា PDF",
  id: "Simpan sebagai PDF",
  si: "PDF ලෙස සුරකින්න",
  bn: "পিডিএফ হিসাবে সংরক্ষণ করুন",
  my: "PDF အဖြစ် သိမ်းဆည်းပါ",
  mn: "PDF хэлбэрээр хадгалах",
  lo: "ບັນທຶກເປັນ PDF",
  tet: "Save nu'udar PDF",
  ne: "पीडीएफको रूपमा बचत गर्नुहोस्",
  zh: '保存为PDF',
  vi: 'Lưu thành PDF',
  uz: "PDF sifatida saqlash",
);
const _pdfKoLabel = L10nText(
  ko: '🇰🇷 한국어 PDF',
  en: '🇰🇷 Korean PDF',
  tr: "🇰🇷 Korece PDF",
  tg: "🇰🇷 PDF бо забони кореягӣ",
  fil: "🇰🇷 Korean PDF",
  ur: "🇰🇷 کوریائی پی ڈی ایف",
  th: "🇰🇷 PDF ภาษาเกาหลี",
  ky: "🇰🇷 Корей тилиндеги PDF",
  km: "🇰🇷 PDF ជាភាសាកូរ៉េ",
  id: "🇰🇷 PDF Korea",
  si: "🇰🇷 කොරියානු PDF",
  bn: "🇰🇷 কোরিয়ান পিডিএফ",
  my: "🇰🇷 ကိုရီးယား PDF",
  mn: "🇰🇷 Солонгос хэл дээрх PDF",
  lo: "🇰🇷 PDF ພາສາເກົາຫຼີ",
  tet: "🇰🇷 PDF iha Lian Koreanu",
  ne: "🇰🇷 कोरियन पीडीएफ",
  zh: '🇰🇷 韩语PDF',
  vi: '🇰🇷 PDF tiếng Hàn',
  uz: "🇰🇷 Koreyscha PDF",
);
const _pdfMyLabel = L10nText(
  ko: '🌐 내 언어 PDF',
  en: '🌐 My-language PDF',
  tr: "🌐 Kendi dilimde PDF",
  tg: "🌐 PDF бо забони ман",
  fil: "🌐 PDF sa aking wika",
  ur: "🌐 میری اپنی زبان میں پی ڈی ایف",
  th: "🌐 PDF ในภาษาของฉัน",
  ky: "🌐 Менин тилимдеги PDF",
  km: "🌐 PDF ជាភាសារបស់ខ្ញុំ",
  id: "🌐 PDF dalam bahasa saya",
  si: "🌐 මගේ භාෂාවෙන් PDF",
  bn: "🌐 আমার নিজের ভাষায় পিডিএফ",
  my: "🌐 ကျွန်ုပ်၏ဘာသာစကားဖြင့် PDF",
  mn: "🌐 Миний хэл дээрх PDF",
  lo: "🌐 PDF ໃນພາສາຂອງຂ້ອຍເອງ",
  tet: "🌐 PDF iha Ha'u-nia Lian",
  ne: "🌐 मेरो आफ्नै भाषामा पीडीएफ",
  zh: '🌐 我的语言PDF',
  vi: '🌐 PDF ngôn ngữ của tôi',
  uz: "🌐 Oʻz tilimdagi PDF",
);
const _pdfPreviewLabel = L10nText(
  ko: '👁 PDF 미리보기',
  en: '👁 Preview the PDF',
  tr: "👁 PDF'i önizle",
  tg: "👁 PDF-ро пешнамоиш кунед",
  fil: "👁 I-preview ang PDF",
  ur: "👁 پی ڈی ایف کا پیش منظر دیکھیں",
  th: "👁 ดูตัวอย่าง PDF",
  ky: "👁 PDFти алдын ала көрүү",
  km: "👁 មើល PDF ជាមុន",
  id: "👁 Pratinjau PDF",
  si: "👁 PDF පෙරදසුන් කරන්න",
  bn: "👁 পিডিএফ প্রিভিউ করুন",
  my: "👁 PDF ကို ကြိုတင်ကြည့်ရှုပါ",
  mn: "👁 PDF-ийг урьдчилан харах",
  lo: "👁 ເບິ່ງຕົວຢ່າງ PDF",
  tet: "👁 Pre-vizualiza PDF",
  ne: "👁 पीडीएफ पूर्वावलोकन गर्नुहोस्",
  zh: '👁 预览PDF',
  vi: '👁 Xem trước PDF',
  uz: "👁 PDFni koʻrish",
);

/// 한국어 PDF/내 언어 PDF/미리보기 버튼 묶음 — complaint_pdf_builder.dart의
/// buildComplaintPdf()를 다운로드·미리보기 양쪽에서 동일하게 사용한다.
class PdfActionsSection extends StatelessWidget {
  const PdfActionsSection({
    super.key,
    required this.documentTitle,
    required this.sections,
    required this.values,
    required this.lang,
    required this.filePrefix,
  });

  final L10nText documentTitle;
  final List<FormSection> sections;
  final FormValuesController values;
  final AppLanguage lang;
  final String filePrefix;

  Future<void> _download(AppLanguage pdfLang) async {
    final bytes = await buildComplaintPdf(
      documentTitle: documentTitle,
      sections: sections,
      values: values,
      lang: pdfLang,
      format: PdfPageFormat.a4,
    );
    await Printing.sharePdf(
      bytes: bytes,
      filename: '${filePrefix}_${pdfLang.name}.pdf',
    );
  }

  void _openPreview(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PdfPreviewScreen(
          documentTitle: documentTitle,
          sections: sections,
          values: values,
          lang: lang,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D47A1),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _pdfBoxTitle.of(lang),
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFFE3F2FD),
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _download(AppLanguage.ko),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: Colors.white54),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                  child: Text(
                    _pdfKoLabel.of(lang),
                    style: const TextStyle(fontSize: 11.5),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: lang == AppLanguage.ko
                      ? null
                      : () => _download(lang),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: Colors.white54),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                  child: Text(
                    _pdfMyLabel.of(lang),
                    style: const TextStyle(fontSize: 11.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => _openPreview(context),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF90CAF9),
              ),
              child: Text(
                _pdfPreviewLabel.of(lang),
                style: const TextStyle(fontSize: 11.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
