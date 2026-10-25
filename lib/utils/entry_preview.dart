// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/models/entry.dart';

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
final _blankLines = RegExp(r'^(?:[ \t]*\n)+');

/// The title in text from where an entry's title is its first line, when
/// that is a top-level heading: older versions of this diary and the
/// journals it imports from. Blank lines after it go with it.
({String title, String body}) splitEntryTitle(String text) {
  final end = text.indexOf('\n');
  final match =
      _titleLine.firstMatch(end == -1 ? text : text.substring(0, end));
  if (match == null) return (title: '', body: text);
  return (
    title: match[1]!.trim(),
    body: end == -1 ? '' : text.substring(end + 1).replaceFirst(_blankLines, '')
  );
}

/// [entry] without a title of its own, titled by the heading its text
/// starts with, if any.
Entry titledByHeading(Entry entry) {
  if (entry.title.isNotEmpty) return entry;
  final (:title, :body) = splitEntryTitle(entry.text);
  return title.isEmpty ? entry : entry.copy(title: title, text: body);
}

/// Shared text goes below the entry's own, after a blank line.
String mergeSharedText(String baseText, String? sharedText) {
  if (sharedText == null) return baseText;
  return baseText.isEmpty ? sharedText : '$baseText\n\n$sharedText';
}

/// Longest snippet: more than two lines hold in the widest list, so a long
/// entry is not read and laid out in full for a line or two of it.
const snippetCharacters = 300;

/// An entry's title, when it has one, and [entrySnippet] of its text.
EntryPreview entryPreview(Entry entry) {
  final title = entry.title.trim();
  return (
    title: title.isEmpty ? null : title,
    snippet: entrySnippet(entry.text),
  );
}

/// Entry markdown as one line of plain text of at most [snippetCharacters],
/// ending in an ellipsis when cut.
String entrySnippet(String body) {
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
  return cutSnippet(snippet.toString(), snippetCharacters);
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
