import 'dart:typed_data';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../core/app_language.dart';
import '../../worklog/models/work_log_report.dart';
import '../../worklog/models/work_log_report_strings.dart';

typedef S = WorkLogReportStrings;

String reportTime(TimeOfDay? time, AppLanguage lang) => time == null
    ? S.missing.of(lang)
    : '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

Future<Uint8List> buildWorkLogPdf({
  required WorkLogReport report,
  required AppLanguage lang,
  PdfPageFormat format = PdfPageFormat.a4,
}) async {
  // 선택 언어와 무관하게 한국어 주소와 다국어 메모를 원문 그대로 출력한다.
  final fonts = <pw.Font>[];
  for (final asset in ['NotoSans', 'NotoSansKR', 'NotoSansSC']) {
    fonts.add(pw.Font.ttf(await rootBundle.load('assets/fonts/$asset.ttf')));
  }
  final base = lang == AppLanguage.ko
      ? fonts[1]
      : lang == AppLanguage.zh
      ? fonts[2]
      : fonts[0];
  final doc = pw.Document(
    theme: pw.ThemeData.withFont(base: base, bold: base, fontFallback: fonts),
  );
  final generated =
      '${reportDate(report.generatedAt)} ${report.generatedAt.hour.toString().padLeft(2, '0')}:${report.generatedAt.minute.toString().padLeft(2, '0')}';
  pw.Widget text(String value, {double size = 9}) =>
      pw.Text(value, style: pw.TextStyle(fontSize: size));
  doc.addPage(
    pw.MultiPage(
      pageFormat: format,
      margin: const pw.EdgeInsets.all(32),
      maxPages: 200,
      header: (_) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          text(
            '${report.isDemo ? '[DEMO] ' : ''}${S.title.of(lang)}',
            size: 17,
          ),
          if (report.isDemo) text(S.demo.of(lang)),
          pw.SizedBox(height: 8),
        ],
      ),
      footer: (context) => pw.Padding(
        padding: const pw.EdgeInsets.only(top: 8),
        child: text(
          'Local Bridge | ${report.period} | ${report.isDemo ? 'DEMO | ' : ''}${context.pageNumber}/${context.pagesCount}',
          size: 8,
        ),
      ),
      build: (_) => [
        text(
          '${S.owner.of(lang)}: ${report.isDemo ? 'DEMO' : report.ownerName}',
        ),
        if (!report.isDemo && report.userId != null)
          text('UID: ${report.userId}'),
        text('${S.period.of(lang)}: ${report.period}'),
        text('${S.generated.of(lang)}: $generated'),
        text('${S.savedDays.of(lang)}: ${report.records.length}'),
        pw.SizedBox(height: 8),
        text(S.note.of(lang), size: 8),
        pw.SizedBox(height: 12),
        pw.TableHelper.fromTextArray(
          headers: [
            S.date.of(lang),
            S.clockIn.of(lang),
            S.clockOut.of(lang),
            S.breaks.of(lang),
            S.location.of(lang),
          ],
          data: [
            for (final day in report.dates)
              [
                reportDate(day),
                reportTime(report.records[day]?.clockIn, lang),
                reportTime(report.records[day]?.clockOut, lang),
                report.records[day] == null
                    ? '-'
                    : '${report.records[day]!.breakMinutes}',
                report.records[day] == null
                    ? S.missing.of(lang)
                    : (report.records[day]!.gpsVerified
                              ? S.verified
                              : S.unverified)
                          .of(lang),
              ],
          ],
          columnWidths: {
            0: const pw.FlexColumnWidth(1.3),
            1: const pw.FlexColumnWidth(1),
            2: const pw.FlexColumnWidth(1),
            3: const pw.FlexColumnWidth(1),
            4: const pw.FlexColumnWidth(2),
          },
          headerStyle: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
          ),
          cellStyle: const pw.TextStyle(fontSize: 8),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
          cellPadding: const pw.EdgeInsets.all(5),
        ),
        pw.SizedBox(height: 16),
        text(S.details.of(lang), size: 13),
        for (final day in report.dates)
          if (report.records[day] case final record?) ...[
            pw.SizedBox(height: 10),
            text(reportDate(day), size: 11),
            text(
              '${S.location.of(lang)}: ${(record.gpsVerified ? S.verified : S.unverified).of(lang)}',
            ),
            // 긴 메모도 페이지를 넘길 수 있도록 나누되 내용은 생략하지 않는다.
            for (final chunk in _chunks(
              '${S.address.of(lang)}: ${record.verifiedAddress ?? S.missing.of(lang)}',
            ))
              text(chunk),
            text(
              '${S.coordinates.of(lang)}: ${record.verifiedLatitude ?? '-'}, ${record.verifiedLongitude ?? '-'}',
            ),
            text('${S.memo.of(lang)}:'),
            for (final chunk in _chunks(
              record.memo.isEmpty ? S.missing.of(lang) : record.memo,
            ))
              text(chunk),
          ],
      ],
    ),
  );
  return doc.save();
}

Iterable<String> _chunks(String value) sync* {
  // 문자 중간(서로게이트 쌍)을 자르지 않으며 줄바꿈도 유지한다.
  for (final line in value.split('\n')) {
    if (line.isEmpty) {
      yield ' ';
      continue;
    }
    final runes = line.runes.toList();
    for (var i = 0; i < runes.length; i += 200) {
      yield String.fromCharCodes(runes.skip(i).take(200));
    }
  }
}
