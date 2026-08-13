import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/app_language.dart';
import '../controllers/form_values_controller.dart';
import '../models/form_field_spec.dart';

/// 언어별 폰트 파일 — 기본 PDF 내장 폰트엔 한글/중국어/베트남어 성조 글리프가 없어
/// 반드시 번들 폰트를 로드해야 한다. ko→Noto Sans KR, zh→Noto Sans SC,
/// en/vi→Noto Sans(라틴 확장 포함, 베트남어 성조 지원).
String _fontAssetFor(AppLanguage lang) => switch (lang) {
  AppLanguage.ko => 'assets/fonts/NotoSansKR.ttf',
  AppLanguage.zh => 'assets/fonts/NotoSansSC.ttf',
  AppLanguage.en || AppLanguage.vi => 'assets/fonts/NotoSans.ttf',
};

final Map<String, pw.Font> _fontCache = {};

Future<pw.Font> _loadFont(String asset) async {
  final cached = _fontCache[asset];
  if (cached != null) return cached;
  final data = await rootBundle.load(asset);
  final font = pw.Font.ttf(data);
  _fontCache[asset] = font;
  return font;
}

String _displayValue(
  FormFieldSpec field,
  FormValuesController values,
  AppLanguage lang,
) {
  final raw = values.valueOf(field.key);
  if (raw.isEmpty) return '';
  if (field.type == FormFieldType.segmented) {
    final opt = field.options.where((o) => o.value == raw).firstOrNull;
    return opt?.label.of(lang) ?? raw;
  }
  return raw;
}

/// sections+values 하나로 다운로드용 PDF와 미리보기(PdfPreview)가 동일한 결과를
/// 그리도록 하는 단일 빌더. lang만 바꿔 "한국어 PDF"/"내 언어 PDF"를 만든다.
Future<Uint8List> buildComplaintPdf({
  required L10nText documentTitle,
  required List<FormSection> sections,
  required FormValuesController values,
  required AppLanguage lang,
  required PdfPageFormat format,
}) async {
  final font = await _loadFont(_fontAssetFor(lang));
  final doc = pw.Document(
    theme: pw.ThemeData.withFont(base: font, bold: font),
  );

  doc.addPage(
    pw.MultiPage(
      pageFormat: format,
      margin: const pw.EdgeInsets.all(28),
      build: (context) => [
        pw.Text(
          documentTitle.of(lang),
          style: const pw.TextStyle(fontSize: 18),
        ),
        pw.SizedBox(height: 3),
        pw.Text(
          'Local Bridge · ${DateTime.now().toIso8601String().split('T').first}',
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
        ),
        pw.SizedBox(height: 14),
        for (final section in sections) ...[
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            margin: const pw.EdgeInsets.only(top: 10, bottom: 2),
            color: PdfColors.grey200,
            child: pw.Text(
              section.title.of(lang),
              style: const pw.TextStyle(fontSize: 11),
            ),
          ),
          for (final field in section.fields)
            _buildFieldRow(field, values, lang),
        ],
        pw.SizedBox(height: 16),
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Text(
            _disclaimer(lang),
            style: const pw.TextStyle(
              fontSize: 8.5,
              color: PdfColors.grey700,
              lineSpacing: 2,
            ),
          ),
        ),
      ],
    ),
  );

  return doc.save();
}

pw.Widget _buildFieldRow(
  FormFieldSpec field,
  FormValuesController values,
  AppLanguage lang,
) {
  final display = _displayValue(field, values, lang);
  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(vertical: 6),
    decoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
      ),
    ),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 130,
          child: pw.Text(
            field.label.of(lang),
            style: const pw.TextStyle(fontSize: 9.5, color: PdfColors.grey700),
          ),
        ),
        pw.SizedBox(width: 10),
        pw.Expanded(
          child: display.isEmpty
              // 빈 칸은 안내 문구 대신 밑줄만 그어 실제 서류의 "직접 채우세요" 관례를 따른다.
              ? pw.Container(
                  height: 10,
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        color: PdfColors.grey400,
                        width: 0.7,
                      ),
                    ),
                  ),
                )
              : pw.Text(display, style: const pw.TextStyle(fontSize: 10)),
        ),
      ],
    ),
  );
}

String _disclaimer(AppLanguage lang) => switch (lang) {
  AppLanguage.ko =>
    '본 문서는 입력하신 사실관계를 양식에 옮긴 것이며, 법적 주장이나 판단을 포함하지 않습니다. 작성 내용에 대한 법적 책임은 이용자 본인에게 있습니다.',
  AppLanguage.en =>
    'This document transfers the facts you entered into the form and contains no legal argument or judgement. You are responsible for the content you enter.',
  AppLanguage.zh => '本文件仅将您填写的事实转录至表格，不含法律主张或判断。填写内容的法律责任由使用者本人承担。',
  AppLanguage.vi =>
    'Tài liệu này chỉ chuyển các sự việc bạn nhập vào mẫu, không chứa lập luận hay phán đoán pháp lý. Bạn chịu trách nhiệm về nội dung đã nhập.',
};
