// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

typedef EntryPreview = ({String? title, String snippet});

final _heading = RegExp(r'^\s{0,3}#{1,6}\s+');
final _listMarker = RegExp(r'^\s*(?:[-*+]|\d+[.)])\s+(?:\[[ xX]\]\s+)?');
final _quote = RegExp(r'^\s*>+\s?');
final _image = RegExp(r'!\[([^\]]*)\]\([^)]*\)');
final _link = RegExp(r'\[([^\]]*)\]\([^)]*\)');
final _emphasis = RegExp(r'(\*\*|__|~~|==|\*|_|`)');
final _rule = RegExp(r'^\s*([-*_])(\s*\1){2,}\s*$');

/// Plain text for one markdown line, without block or inline markers.
String plainMarkdownLine(String line) => line
    .replaceFirst(_heading, '')
    .replaceFirst(_quote, '')
    .replaceFirst(_listMarker, '')
    .replaceAllMapped(_image, (m) => m[1]!)
    .replaceAllMapped(_link, (m) => m[1]!)
    .replaceAll(_emphasis, '')
    .trim();

final _titleLine = RegExp(r'^# +(.*)$');

/// An entry has a title only when the user wrote one: a first line that is a
/// top-level heading. The editor keeps it in a field of its own.
({String title, String body}) splitEntryTitle(String text) {
  final end = text.indexOf('\n');
  final match =
      _titleLine.firstMatch(end == -1 ? text : text.substring(0, end));
  if (match == null) return (title: '', body: text);
  return (
    title: match[1]!.trim(),
    body: end == -1 ? '' : text.substring(end + 1)
  );
}

/// The entry text for a [title], which may be empty, above [body].
String joinEntryTitle(String title, String body) {
  final line = title.replaceAll('\n', ' ').trim();
  return line.isEmpty ? body : '# $line\n$body';
}

/// Splits entry markdown into its title, if written, and a one-line snippet.
EntryPreview entryPreview(String text) {
  final (:title, :body) = splitEntryTitle(text.trimLeft());
  final snippet = body
      .split('\n')
      .where((l) => !_rule.hasMatch(l))
      .map(plainMarkdownLine)
      .where((l) => l.isNotEmpty)
      .join(' ');
  final plainTitle = plainMarkdownLine(title);
  return (title: plainTitle.isEmpty ? null : plainTitle, snippet: snippet);
}
