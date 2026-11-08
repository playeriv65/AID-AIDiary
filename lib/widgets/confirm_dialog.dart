// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/settings_actions.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/widgets/haptics.dart';
import 'package:material_ui/material_ui.dart';

/// Asks before doing something, the same way everywhere: [title], then
/// [message] or a [content] widget, Cancel on the left and [confirm] on the
/// right, red when it cannot be undone. True only when confirmed.
///
/// With [phrase], [confirm] stays off until that phrase is typed (case and
/// surrounding spaces aside), for what must not happen by a slip.
///
/// With [askSetting], a "Don't ask again" box: confirming with it ticked
/// turns that setting off, and while it is off this asks nothing and
/// answers true.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  String? message,
  Widget? content,
  required String confirm,
  bool destructive = false,
  Key? confirmKey,
  String? phrase,
  Setting<bool>? askSetting,
}) async {
  if (askSetting != null && !ConfigProvider.instance.get(askSetting)) {
    return true;
  }
  if (destructive) Haptics.warning();
  final answer = await showDialog<_Answer>(
    context: context,
    builder: (_) => _ConfirmDialog(
      title: title,
      message: message,
      content: content,
      confirm: confirm,
      destructive: destructive,
      confirmKey: confirmKey,
      phrase: phrase,
      offerDontAsk: askSetting != null,
    ),
  );
  if (answer == null || !answer.confirmed) return false;
  if (askSetting != null && answer.dontAsk) {
    await changeSetting(askSetting, false);
  }
  return true;
}

/// [showConfirmDialog] with a second way to go on, [decline] (such as
/// "Don't save"), left of Cancel: true when confirmed, false when declined,
/// null when cancelled.
Future<bool?> showConfirmOrDeclineDialog(
  BuildContext context, {
  required String title,
  String? message,
  required String confirm,
  required String decline,
  Key? confirmKey,
  Key? declineKey,
}) async {
  final answer = await showDialog<_Answer>(
    context: context,
    builder: (_) => _ConfirmDialog(
      title: title,
      message: message,
      confirm: confirm,
      confirmKey: confirmKey,
      decline: decline,
      declineKey: declineKey,
    ),
  );
  return answer?.confirmed;
}

/// [showConfirmDialog] for deleting what [message] names.
Future<bool> showDeleteConfirmDialog(BuildContext context,
        {required String message, Key? confirmKey}) =>
    showConfirmDialog(context,
        title: AppLocalizations.of(context)!.deleteTitle,
        message: message,
        confirm: MaterialLocalizations.of(context).deleteButtonTooltip,
        destructive: true,
        confirmKey: confirmKey);

/// How a [_ConfirmDialog] closed other than by cancelling.
typedef _Answer = ({bool confirmed, bool dontAsk});

class _ConfirmDialog extends StatefulWidget {
  const _ConfirmDialog({
    required this.title,
    this.message,
    this.content,
    required this.confirm,
    this.destructive = false,
    this.confirmKey,
    this.phrase,
    this.offerDontAsk = false,
    this.decline,
    this.declineKey,
  });

  final String title;
  final String? message;
  final Widget? content;
  final String confirm;
  final bool destructive;
  final Key? confirmKey;
  final String? phrase;
  final bool offerDontAsk;
  final String? decline;
  final Key? declineKey;

  @override
  State<_ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<_ConfirmDialog> {
  bool _phraseTyped = false;
  bool _dontAsk = false;

  void _typed(String text) {
    final typed =
        text.trim().toLowerCase() == widget.phrase!.trim().toLowerCase();
    if (typed != _phraseTyped) setState(() => _phraseTyped = typed);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final navigator = Navigator.of(context);
    final phrase = widget.phrase;
    final body = widget.content ??
        (widget.message == null ? null : Text(widget.message!));
    final extras = [
      if (phrase != null)
        TextField(
          key: const ValueKey('confirm-phrase'),
          autofocus: true,
          decoration: InputDecoration(hintText: phrase),
          onChanged: _typed,
        ),
      if (widget.offerDontAsk)
        CheckboxListTile(
          key: const ValueKey('confirm-dont-ask'),
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          value: _dontAsk,
          onChanged: (value) => setState(() => _dontAsk = value ?? false),
          title: Text(AppLocalizations.of(context)!.dontAskAgain),
        ),
    ];
    return AlertDialog(
      title: Text(widget.title),
      content: extras.isEmpty
          ? body
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (body != null) body,
                for (final extra in extras) ...[
                  const SizedBox(height: 8),
                  extra,
                ],
              ],
            ),
      actions: [
        if (widget.decline case final decline?)
          TextButton(
            key: widget.declineKey,
            onPressed: () => navigator.pop((confirmed: false, dontAsk: false)),
            child: Text(decline),
          ),
        TextButton(
          onPressed: () => navigator.pop(),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        FilledButton(
          key: widget.confirmKey,
          style: widget.destructive
              ? FilledButton.styleFrom(
                  backgroundColor: colors.error,
                  foregroundColor: colors.onError)
              : null,
          onPressed: phrase != null && !_phraseTyped
              ? null
              : () => navigator.pop((confirmed: true, dontAsk: _dontAsk)),
          child: Text(widget.confirm),
        ),
      ],
    );
  }
}
