import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/user_profile_controller.dart';
import '../models/bug_report_email.dart';
import '../models/bug_report_strings.dart';

class BugReportScreen extends StatefulWidget {
  const BugReportScreen({super.key, this.openEmail});
  final Future<bool> Function(Uri)? openEmail;

  @override
  State<BugReportScreen> createState() => _BugReportScreenState();
}

class _BugReportScreenState extends State<BugReportScreen> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  bool _opening = false;
  bool _launchFailed = false;

  BugReportEmail get _report =>
      BugReportEmail(title: _title.text, description: _description.text);

  Future<void> _open() async {
    if (_opening || !_form.currentState!.validate()) return;
    setState(() {
      _opening = true;
      _launchFailed = false;
    });
    try {
      final opened =
          await (widget.openEmail?.call(_report.uri) ?? launchUrl(_report.uri));
      if (!mounted) return;
      setState(() => _launchFailed = !opened);
      if (opened) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              BugReportStrings.note.of(UserProfileScope.of(context).language),
            ),
          ),
        );
      }
    } catch (_) {
      if (mounted) setState(() => _launchFailed = true);
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  Future<void> _copy() async {
    if (!_form.currentState!.validate()) return;
    final lang = UserProfileScope.of(context).language;
    try {
      await Clipboard.setData(ClipboardData(text: _report.clipboardText));
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(BugReportStrings.copied.of(lang))));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(BugReportStrings.copyFailed.of(lang))),
      );
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = UserProfileScope.of(context).language;
    return Scaffold(
      appBar: AppBar(title: Text(BugReportStrings.title.of(lang))),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SelectableText(BugReportEmail.recipient),
            const SizedBox(height: 8),
            Text(BugReportStrings.note.of(lang)),
            const SizedBox(height: 20),
            TextFormField(
              controller: _title,
              maxLength: 100,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: BugReportStrings.subject.of(lang),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? BugReportStrings.required.of(lang)
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _description,
              minLines: 6,
              maxLines: 12,
              maxLength: 2000,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: BugReportStrings.description.of(lang),
                hintText: BugReportStrings.hint.of(lang),
                alignLabelWithHint: true,
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? BugReportStrings.required.of(lang)
                  : null,
            ),
            if (_launchFailed) ...[
              const SizedBox(height: 12),
              Text(
                BugReportStrings.failed.of(lang),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SelectableText(BugReportEmail.recipient),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _opening ? null : _open,
              icon: const Icon(Icons.mail_outline),
              label: Text(BugReportStrings.open.of(lang)),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _copy,
              icon: const Icon(Icons.copy_outlined),
              label: Text(BugReportStrings.copy.of(lang)),
            ),
          ],
        ),
      ),
    );
  }
}
