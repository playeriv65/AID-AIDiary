// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:markdown/markdown.dart' as md;

/// One entry as plain text, an HTML page or a ZIP with its original media.
/// [heading] is the line above the text, e.g. the mood and date.
class EntryShare {
  static String plainText(Entry entry, String heading) =>
      '$heading\n${entry.text}';

  /// A standalone page; media is linked by [mediaFolder]/name, as laid out
  /// in [zip], or left out when [media] is empty.
  static String html(Entry entry, String heading,
      {List<EntryImage> media = const [], String mediaFolder = 'media'}) {
    const escape = HtmlEscape();
    final body =
        md.markdownToHtml(entry.text, extensionSet: md.ExtensionSet.gitHubWeb);
    final attachments = [
      for (final item in media)
        switch (item.kind) {
          MediaKind.image => '<img src="$mediaFolder/${item.imgPath}" alt="">',
          MediaKind.video =>
            '<video src="$mediaFolder/${item.imgPath}" controls></video>',
          MediaKind.audio =>
            '<audio src="$mediaFolder/${item.imgPath}" controls></audio>',
        },
    ];
    return '''
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${escape.convert(heading)}</title>
<style>
body { font-family: system-ui, sans-serif; line-height: 1.6; max-width: 720px; margin: 2rem auto; padding: 0 1rem; }
img, video { max-width: 100%; border-radius: 12px; display: block; margin: 1rem 0; }
.date { color: #666; }
</style>
</head>
<body>
<p class="date">${escape.convert(heading)}</p>
${attachments.join('\n')}
$body
</body>
</html>
''';
  }

  /// entry.md and entry.html beside a media folder with the original files.
  /// Files [read] cannot find are skipped.
  static Future<Uint8List> zip(
      Entry entry,
      String heading,
      List<EntryImage> media,
      Future<Uint8List?> Function(String name) read) async {
    final archive = Archive()
      ..add(ArchiveFile.string('entry.md', plainText(entry, heading)));
    final included = <EntryImage>[];
    for (final item in media) {
      final bytes = await read(item.imgPath);
      if (bytes == null) continue;
      archive.add(ArchiveFile.bytes('media/${item.imgPath}', bytes));
      included.add(item);
    }
    archive.add(ArchiveFile.string(
        'entry.html', html(entry, heading, media: included)));
    return ZipEncoder().encodeBytes(archive);
  }
}
