// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/services/feedback_service.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

/// Feedback in one step: what is typed is sent to the AID Diary server.
/// Those who want an answer or a public issue open their mail app or GitHub
/// with the same text.
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key, this.launch, this.service});
  final Future<bool> Function(Uri)? launch;
  final FeedbackService? service;

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _text = TextEditingController();
  late final _service = widget.service ?? FeedbackService();
  bool _busy = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _tell(String message) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _busy = true);
    final sent = await _service.send(_text.text.trim(),
        locale: Localizations.localeOf(context).toLanguageTag());
    if (!mounted) return;
    setState(() => _busy = false);
    if (sent) _text.clear();
    _tell(sent ? l10n.feedbackSent : l10n.feedbackSendFailed);
  }

  Future<void> _open(bool email) async {
    final l10n = AppLocalizations.of(context)!;
    final config = AppConfig.instance;
    final subject = '${l10n.appTitle}: ${l10n.feedbackTitle}';
    final body = _text.text.trim();
    final uri = email
        ? Uri(
            scheme: 'mailto',
            path: config.feedbackEmail,
            query:
                'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}')
        : config.feedbackIssuesUrl.replace(queryParameters: {
            ...config.feedbackIssuesUrl.queryParameters,
            'title': subject,
            'body': body,
          });
    setState(() => _busy = true);
    var opened = false;
    try {
      opened = await (widget.launch?.call(uri) ??
          launchUrl(uri, mode: LaunchMode.externalApplication));
    } on Exception {
      opened = false;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
    if (!opened && mounted) _tell(l10n.feedbackOpenFailed);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final empty = _text.text.trim().isEmpty;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.feedbackTitle)),
      body: Center(
          child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView(padding: const EdgeInsets.all(20), children: [
          TextField(
            key: const ValueKey('feedback-text'),
            controller: _text,
            minLines: 6,
            maxLines: 12,
            decoration: InputDecoration(
                hintText: l10n.feedbackHint,
                helperText: l10n.feedbackSendNote,
                helperMaxLines: 3,
                border: const OutlineInputBorder()),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
              key: const ValueKey('feedback-send'),
              onPressed: _busy || empty ? null : _send,
              icon: _busy
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.send_rounded),
              label: Text(l10n.feedbackSend)),
          const SizedBox(height: 12),
          Wrap(spacing: 12, runSpacing: 12, children: [
            OutlinedButton.icon(
                key: const ValueKey('feedback-github'),
                onPressed: _busy ? null : () => _open(false),
                icon: const Icon(Icons.open_in_new_rounded),
                label: Text(l10n.feedbackGithub)),
            OutlinedButton.icon(
                key: const ValueKey('feedback-email'),
                onPressed: _busy ? null : () => _open(true),
                icon: const Icon(Icons.mail_outline_rounded),
                label: Text(l10n.feedbackEmail)),
          ]),
        ]),
      )),
    );
  }
}
