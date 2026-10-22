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

/// Longest snippet: more than two lines hold in the widest list, so a long
/// entry is not read and laid out in full for a line or two of it.
const snippetCharacters = 300;

/// Splits entry markdown into its title, if written, and a one-line snippet
/// of at most [snippetCharacters], ending in an ellipsis when cut.
EntryPreview entryPreview(String text) {
  final (:title, :body) = splitEntryTitle(text.trimLeft());
  final snippet = StringBuffer();
  for (var start = 0;
      start < body.length && snippet.length <= snippetCharacters;) {
    final newline = body.indexOf('\n', start);
    final end = newline == -1 ? body.length : newline;
    final line = body.substring(start, end);
    start = end + 1;
    if (_rule.hasMatch(line)) continue;
    final plain = plainMarkdownLine(line);
    if (plain.isEmpty) continue;
    if (snippet.isNotEmpty) snippet.write(' ');
    snippet.write(plain);
  }
  final plainTitle = plainMarkdownLine(title);
  return (
    title: plainTitle.isEmpty ? null : plainTitle,
    snippet: cutSnippet(snippet.toString(), snippetCharacters),
  );
}

/// [snippet] cut to [maxCharacters] and an ellipsis, when longer.
String cutSnippet(String snippet, int maxCharacters) {
  if (snippet.length <= maxCharacters) return snippet;
  var end = maxCharacters;
  // Not between the two halves of an emoji or other surrogate pair.
  final last = snippet.codeUnitAt(end - 1);
  if (last >= 0xD800 && last <= 0xDBFF) end--;
  return '${snippet.substring(0, end)}…';
}
