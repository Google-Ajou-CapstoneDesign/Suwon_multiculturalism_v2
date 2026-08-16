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
  zh: '保存为PDF',
  vi: 'Lưu thành PDF',
);
const _pdfKoLabel = L10nText(
  ko: '🇰🇷 한국어 PDF',
  en: '🇰🇷 Korean PDF',
  zh: '🇰🇷 韩语PDF',
  vi: '🇰🇷 PDF tiếng Hàn',
);
const _pdfMyLabel = L10nText(
  ko: '🌐 내 언어 PDF',
  en: '🌐 My-language PDF',
  zh: '🌐 我的语言PDF',
  vi: '🌐 PDF ngôn ngữ của tôi',
);
const _pdfPreviewLabel = L10nText(
  ko: '👁 PDF 미리보기',
  en: '👁 Preview the PDF',
  zh: '👁 预览PDF',
  vi: '👁 Xem trước PDF',
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
