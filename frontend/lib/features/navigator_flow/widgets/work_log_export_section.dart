import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../../../core/app_language.dart';
import '../../../core/user_profile_controller.dart';
import '../../worklog/models/work_log_report.dart';
import '../../worklog/models/work_log_report_strings.dart';
import '../../worklog/services/work_log_report_service.dart';
import '../pdf/work_log_pdf_builder.dart';

typedef S = WorkLogReportStrings;

class WorkLogExportSection extends StatefulWidget {
  const WorkLogExportSection({super.key, this.loader = loadWorkLogReport});
  final WorkLogReportLoader loader;

  @override
  State<WorkLogExportSection> createState() => _WorkLogExportSectionState();
}

class _WorkLogExportSectionState extends State<WorkLogExportSection> {
  WorkLogReport? _report;
  String? _uid;
  bool _initialized = false;
  bool _loading = false;
  bool _failed = false;
  bool _exporting = false;
  int _generation = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uid = UserProfileScope.of(context).uid;
    if (!_initialized || uid != _uid) {
      _initialized = true;
      _uid = uid;
      _reload();
    }
  }

  Future<void> _reload() async {
    final generation = ++_generation;
    final profile = UserProfileScope.of(context);
    setState(() {
      _loading = true;
      _failed = false;
      _report = null;
    });
    try {
      final report = await widget
          .loader(_uid, profile.displayNameOrEmailPrefix ?? '')
          .timeout(const Duration(seconds: 35));
      if (!mounted || generation != _generation) return;
      setState(() => _report = report);
    } catch (_) {
      if (!mounted || generation != _generation) return;
      setState(() => _failed = true);
    } finally {
      if (mounted && generation == _generation) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _download(AppLanguage language) async {
    final report = _report;
    if (report == null || _exporting) return;
    final generation = _generation;
    setState(() => _exporting = true);
    try {
      final bytes = await buildWorkLogPdf(report: report, lang: language);
      if (!mounted || generation != _generation) return;
      await Printing.sharePdf(
        bytes: bytes,
        filename: report.filename(language.name),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.pdfError.of(UserProfileScope.of(context).language)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  void _preview(AppLanguage lang) {
    final report = _report!;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          final sameUser = UserProfileScope.of(context).uid == report.userId;
          return Scaffold(
            appBar: AppBar(title: Text(S.preview.of(lang))),
            body: sameUser
                ? PdfPreview(
                    build: (format) => buildWorkLogPdf(
                      report: report,
                      lang: lang,
                      format: format,
                    ),
                    pdfFileName: report.filename(lang.name),
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                    canDebug: false,
                    onError: (context, error) =>
                        Center(child: Text(S.pdfError.of(lang))),
                  )
                : Center(child: Text(S.error.of(lang))),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = UserProfileScope.of(context).language;
    final report = _report;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_uid == null)
          Card(
            color: const Color(0xFFFFF3CD),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(S.demo.of(lang)),
            ),
          ),
        if (_loading) ...[
          const LinearProgressIndicator(),
          const SizedBox(height: 8),
          Text(S.loading.of(lang)),
        ],
        if (_failed)
          Text(
            S.error.of(lang),
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        OutlinedButton.icon(
          onPressed: _loading || _exporting ? null : _reload,
          icon: const Icon(Icons.refresh),
          label: Text(S.load.of(lang)),
        ),
        if (report != null) ...[
          Text('${S.period.of(lang)}: ${report.period}'),
          Text('${S.savedDays.of(lang)}: ${report.records.length}'),
          const SizedBox(height: 8),
          Text(S.note.of(lang), style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 12),
          if (report.records.isEmpty)
            Text(S.empty.of(lang))
          else ...[
            if (_exporting) const LinearProgressIndicator(),
            FilledButton.icon(
              onPressed: _exporting ? null : () => _download(AppLanguage.ko),
              icon: const Icon(Icons.download),
              label: Text(S.koreanPdf.of(lang)),
            ),
            if (lang != AppLanguage.ko)
              OutlinedButton.icon(
                onPressed: _exporting ? null : () => _download(lang),
                icon: const Icon(Icons.language),
                label: Text(S.myPdf.of(lang)),
              ),
            TextButton.icon(
              onPressed: _exporting ? null : () => _preview(lang),
              icon: const Icon(Icons.picture_as_pdf),
              label: Text(S.preview.of(lang)),
            ),
            for (final day in report.dates)
              if (report.records[day] case final record?)
                Card(
                  child: ExpansionTile(
                    title: Text(reportDate(day)),
                    subtitle: Text(
                      '${S.clockIn.of(lang)} ${reportTime(record.clockIn, lang)} · ${S.clockOut.of(lang)} ${reportTime(record.clockOut, lang)}\n${(record.gpsVerified ? S.verified : S.unverified).of(lang)}',
                    ),
                    childrenPadding: const EdgeInsets.all(12),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${S.breaks.of(lang)}: ${record.breakMinutes}'),
                      Text(
                        '${S.address.of(lang)}: ${record.verifiedAddress ?? S.missing.of(lang)}',
                      ),
                      Text(
                        '${S.coordinates.of(lang)}: ${record.verifiedLatitude ?? '-'}, ${record.verifiedLongitude ?? '-'}',
                      ),
                      Text(
                        '${S.memo.of(lang)}: ${record.memo.isEmpty ? S.missing.of(lang) : record.memo}',
                      ),
                    ],
                  ),
                ),
          ],
        ],
      ],
    );
  }
}
