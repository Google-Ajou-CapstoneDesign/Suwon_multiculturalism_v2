import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../../core/app_language.dart';
import '../../../theme/app_colors.dart';
import '../controllers/form_values_controller.dart';
import '../models/form_field_spec.dart';
import '../pdf/complaint_pdf_builder.dart';

const _previewTitle = L10nText(
  ko: 'PDF 미리보기',
  en: 'PDF preview',
  zh: 'PDF预览',
  vi: 'Xem trước PDF',
);

/// complaint_pdf_builder.dart의 같은 빌더를 그대로 써서 다운로드와 미리보기가
/// 절대 어긋나지 않게 한다.
class PdfPreviewScreen extends StatelessWidget {
  const PdfPreviewScreen({
    super.key,
    required this.documentTitle,
    required this.sections,
    required this.values,
    required this.lang,
  });

  final L10nText documentTitle;
  final List<FormSection> sections;
  final FormValuesController values;
  final AppLanguage lang;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_previewTitle.of(lang)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0.5,
      ),
      body: PdfPreview(
        build: (format) => buildComplaintPdf(
          documentTitle: documentTitle,
          sections: sections,
          values: values,
          lang: lang,
          format: format,
        ),
        allowSharing: true,
        allowPrinting: true,
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
      ),
    );
  }
}
