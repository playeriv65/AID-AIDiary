// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:material_ui/material_ui.dart';

/// Asks for a piece of text, the same way everywhere: [title], one field
/// starting at [initial], Cancel and [confirm]. Returns the text (trimmed
/// unless [trim] is off, as a password is taken exactly), or null when
/// cancelled. [validate] returns why a text is refused, or null. [scan],
/// when given, adds a button that fills the answer from a QR code.
Future<String?> showTextInputDialog(
  BuildContext context, {
  required String title,
  required String confirm,
  String initial = '',
  String? hint,
  String? label,
  String? Function(String text)? validate,
  int? maxLength,
  int maxLines = 1,
  bool trim = true,
  bool plain = false,
  TextCapitalization capitalization = TextCapitalization.none,
  Future<String?> Function(BuildContext context)? scan,
  Key? fieldKey,
  Key? confirmKey,
}) =>
    showDialog<String>(
        context: context,
        builder: (_) => _TextInputDialog(
            title: title,
            confirm: confirm,
            initial: initial,
            hint: hint,
            label: label,
            validate: validate,
            maxLength: maxLength,
            maxLines: maxLines,
            trim: trim,
            plain: plain,
            capitalization: capitalization,
            scan: scan,
            fieldKey: fieldKey,
            confirmKey: confirmKey));

class _TextInputDialog extends StatefulWidget {
  const _TextInputDialog({
    required this.title,
    required this.confirm,
    required this.initial,
    required this.hint,
    required this.label,
    required this.validate,
    required this.maxLength,
    required this.maxLines,
    required this.trim,
    required this.plain,
    required this.capitalization,
    required this.scan,
    required this.fieldKey,
    required this.confirmKey,
  });

  final String title;
  final String confirm;
  final String initial;
  final String? hint;
  final String? label;
  final String? Function(String text)? validate;
  final int? maxLength;
  final int maxLines;
  final bool trim;
  final bool plain;
  final TextCapitalization capitalization;
  final Future<String?> Function(BuildContext context)? scan;
  final Key? fieldKey;
  final Key? confirmKey;

  @override
  State<_TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<_TextInputDialog> {
  late final _text = TextEditingController(text: widget.initial);
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  String _value(String text) => widget.trim ? text.trim() : text;

  void _submit() {
    if (_form.currentState!.validate()) {
      Navigator.of(context).pop(_value(_text.text));
    }
  }

  Future<void> _scan() async {
    final scanned = await widget.scan!(context);
    if (scanned != null && mounted) Navigator.of(context).pop(scanned);
  }

  @override
  Widget build(BuildContext context) {
    final validate = widget.validate;
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _form,
        child: TextFormField(
          key: widget.fieldKey,
          controller: _text,
          autofocus: true,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          autocorrect: !widget.plain,
          enableSuggestions: !widget.plain,
          textCapitalization: widget.capitalization,
          decoration:
              InputDecoration(hintText: widget.hint, labelText: widget.label),
          validator:
              validate == null ? null : (text) => validate(_value(text ?? '')),
          onFieldSubmitted: widget.maxLines == 1 ? (_) => _submit() : null,
        ),
      ),
      actions: [
        if (widget.scan != null)
          IconButton(onPressed: _scan, icon: const Icon(Icons.qr_code_scanner)),
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel)),
        FilledButton(
            key: widget.confirmKey,
            onPressed: _submit,
            child: Text(widget.confirm)),
      ],
    );
  }
}
