// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/utils/imports/import_archive.dart';
import 'package:aid_diary/utils/imports/import_helpers.dart';
import 'package:path/path.dart' as p;
import 'package:xml/xml.dart';

/// Diaro's 1 (great) to 5 (awful) mood scale.
const Map<int, int> _moods = {1: 2, 2: 1, 3: 0, 4: -1, 5: -2};

/// Decodes a Diaro backup zip: `DiaroBackup.xml` with its photos in
/// `media/photo` beside it.
Future<List<ImportedEntry>> decodeDiaroArchive(ArchiveFiles files) async {
  final xmlPath = files.paths.firstWhere(
      (path) => path.endsWith('DiaroBackup.xml'),
      orElse: () => throw Exception('DiaroBackup.xml not found in archive'));
  final xmlBytes = await files.read(xmlPath);
  if (xmlBytes == null) {
    throw Exception('DiaroBackup.xml not found in archive');
  }
  final photoFolder = p.url.join(p.url.dirname(xmlPath), 'media', 'photo');
  return decodeDiaroXml(utf8.decode(xmlBytes), (name) {
    final path = p.url.normalize(p.url.join(photoFolder, name));
    return files.paths.contains(path)
        ? ImportedPhoto(name, () => files.read(path))
        : null;
  });
}

List<ImportedEntry> decodeDiaroXml(
    String xml, ImportedPhoto? Function(String name) photo) {
  final tables = XmlDocument.parse(xml).findAllElements('table');
  XmlElement table(String name) =>
      tables.firstWhere((t) => t.getAttribute('name') == name);

  final photosByEntry = <String, List<(int, String)>>{};
  for (final r in table('diaro_attachments').findAllElements('r')) {
    if (_field(r, 'type') != 'photo') continue;
    final entryUid = _field(r, 'entry_uid');
    final filename = _field(r, 'filename');
    final position = int.tryParse(_field(r, 'position'));
    if (entryUid.isEmpty || filename.isEmpty || position == null) continue;
    photosByEntry.putIfAbsent(entryUid, () => []).add((position, filename));
  }

  return [
    for (final r in table('diaro_entries').findAllElements('r'))
      if (_field(r, 'uid') case final uid when uid.isNotEmpty)
        if (_field(r, 'date') case final date when date.isNotEmpty)
          if (_field(r, 'tz_offset') case final offset when offset.isNotEmpty)
            _entry(r, convertWithOffset(int.parse(date), offset),
                photosByEntry[uid] ?? const [], photo),
  ];
}

String _field(XmlElement row, String name) =>
    row.getElement(name)?.innerText ?? '';

ImportedEntry _entry(
    XmlElement r,
    DateTime created,
    List<(int, String)> attachments,
    ImportedPhoto? Function(String name) photo) {
  final title = _field(r, 'title');
  final text = _field(r, 'text');
  final mood = int.tryParse(_field(r, 'mood'));
  final sorted = [...attachments]..sort((a, b) => a.$1.compareTo(b.$1));
  return ImportedEntry(
    Entry(
      title: title,
      text: text,
      mood: mood == null ? null : _moods[mood.clamp(1, 5)],
      timeCreate: created,
      timeModified: created,
    ),
    photos: [
      for (final (_, name) in sorted)
        if (photo(name) case final found?) found,
    ],
  );
}
