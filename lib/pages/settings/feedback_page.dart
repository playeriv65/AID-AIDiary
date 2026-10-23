// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

/// The user reviews and sends their own text in GitHub or their mail app.
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key, this.launch});
  final Future<bool> Function(Uri)? launch;

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _text = TextEditingController();
  bool _opening = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
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
    setState(() => _opening = true);
    var opened = false;
    try {
      opened = await (widget.launch?.call(uri) ??
          launchUrl(uri, mode: LaunchMode.externalApplication));
    } on Exception {
      opened = false;
    } finally {
      if (mounted) setState(() => _opening = false);
    }
    if (!opened && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.feedbackLaunchFailed)));
    }
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: _text.text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.feedbackCopied)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                border: const OutlineInputBorder()),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Wrap(spacing: 12, runSpacing: 12, children: [
            FilledButton.icon(
                key: const ValueKey('feedback-github'),
                onPressed: _opening ? null : () => _open(false),
                icon: const Icon(Icons.open_in_new_rounded),
                label: Text(l10n.feedbackGithub)),
            OutlinedButton.icon(
                key: const ValueKey('feedback-email'),
                onPressed: _opening ? null : () => _open(true),
                icon: const Icon(Icons.mail_outline_rounded),
                label: Text(l10n.feedbackEmail)),
            TextButton.icon(
                key: const ValueKey('feedback-copy'),
                onPressed: _text.text.trim().isEmpty ? null : _copy,
                icon: const Icon(Icons.copy_rounded),
                label: Text(l10n.feedbackCopy)),
          ]),
          const SizedBox(height: 20),
          SelectableText(AppConfig.instance.feedbackEmail),
        ]),
      )),
    );
  }
}
