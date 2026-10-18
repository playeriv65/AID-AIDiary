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

/// Splits entry markdown into an optional short title and a one-line snippet.
///
/// A first line counts as a title when it is a heading, or when it is short
/// and more text follows, the way a handwritten diary page starts.
EntryPreview entryPreview(String text, {int maxTitleLength = 40}) {
  final lines = text
      .split('\n')
      .where((l) => !_rule.hasMatch(l))
      .map((l) => (raw: l, plain: plainMarkdownLine(l)))
      .where((l) => l.plain.isNotEmpty)
      .toList();
  if (lines.isEmpty) return (title: null, snippet: '');
  final first = lines.first;
  final rest = lines.skip(1).map((l) => l.plain).join(' ');
  final isTitle = _heading.hasMatch(first.raw) ||
      (rest.isNotEmpty && first.plain.length <= maxTitleLength);
  if (!isTitle) {
    return (title: null, snippet: lines.map((l) => l.plain).join(' '));
  }
  return (title: first.plain, snippet: rest);
}
