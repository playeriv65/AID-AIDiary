// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aid_diary/config/one_diary_config.dart';
import 'package:aid_diary/utils/formats/one_diary_format.dart';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';

import 'archive_files.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Map<String, dynamic> protocol;
  late MemoryArchive archive;

  setUp(() async {
    protocol = await loadOneDiaryProtocol();
    archive = MemoryArchive({
      for (final item in ZipDecoder().decodeBytes(
          File('test/fixtures/one_diary/v3.zip').readAsBytesSync()))
        if (item.isFile) item.name: item.content,
    });
  });

  test('reads independent CBC/SHA-256 vectors, without a user password', () {
    final vector = jsonDecode(
        File('test/fixtures/one_diary/vector.json').readAsStringSync());
    final codec = OneDiaryCodec(protocol);
    expect(
        codec.decode('version',
            Uint8List.fromList(utf8.encode(vector['versionCiphertext']))),
        3);
    final rows = codec.decode('source.json',
        Uint8List.fromList(utf8.encode(vector['sourceCiphertext']))) as List;
    expect(rows, hasLength(2));
    expect(rows.first['content'], 'Evening notes.');
  });

  test('keeps the explicit diary day and the original creation instant',
      () async {
    final rows = await decodeOneDiaryArchive(archive, protocol);
    final entry = rows.first.entry;
    expect(entry.timeCreate, DateTime(2025, 8, 15, 23, 55, 54, 799));
    expect(entry.day, DateTime(2025, 8, 15));
    expect(entry.utcOffset, -300);
    expect(entry.createdInstant, DateTime.utc(2025, 8, 16, 4, 55, 54, 799));
    expect(
        entry.timeModified.toUtc(), DateTime.utc(2025, 8, 16, 4, 56, 54, 799));
    expect(entry.text, '# A day\n\nEvening notes.');
    expect(rows[1].entry.day, DateTime(2025, 8, 14));
    expect(rows[1].entry.isHidden, isTrue);
  });

  test('restores scaled coordinates, categories as tags and ordered media',
      () async {
    final row = (await decodeOneDiaryArchive(archive, protocol)).first;
    expect(row.entry.location!.latitude, closeTo(44.97177448, 0.00000001));
    expect(row.entry.location!.longitude, closeTo(-93.219249, 0.00000001));
    expect(row.tags, [(name: 'Travel', value: null)]);
    expect(row.entry.weather!.code, 0);
    expect(row.entry.weather!.temperature, 21);
    expect(row.photos.single.name, 'photo.jpg');
    expect(await row.photos.single.read(), archive.files['photo.jpg']);
    expect(jsonDecode(row.source!.json)['weather'], 'Clear');
  });

  test('external identities stay distinct even with identical timestamps',
      () async {
    final rows = await decodeOneDiaryArchive(archive, protocol);
    expect(rows.map((row) => row.source!.id), ['fixture-a', 'fixture-b']);
    expect(rows.map((row) => row.source!.hash).toSet(), hasLength(2));
  });

  test('content revision includes attachment bytes', () async {
    final first = await decodeOneDiaryArchive(archive, protocol);
    archive.files['photo.jpg'] = Uint8List.fromList([42]);
    final changed = await decodeOneDiaryArchive(archive, protocol);
    expect(changed.first.source!.hash, isNot(first.first.source!.hash));
    expect(changed.last.source!.hash, first.last.source!.hash);
  });

  test('missing media fails instead of fetching a remote URL or dropping it',
      () async {
    archive.files.remove('photo.jpg');
    await expectLater(
        decodeOneDiaryArchive(archive, protocol), throwsFormatException);
  });

  test('ambiguous attachment basenames fail before any entry is added',
      () async {
    archive.files['nested/photo.jpg'] = Uint8List.fromList([1]);
    await expectLater(
        decodeOneDiaryArchive(archive, protocol), throwsFormatException);
  });

  test('unknown versions and truncated payloads fail with nonprivate errors',
      () async {
    await expectLater(
        decodeOneDiaryArchive(archive, {...protocol, 'version': 4}),
        throwsFormatException);
    archive.files['source.json'] = Uint8List.fromList(utf8.encode('AA=='));
    await expectLater(
        decodeOneDiaryArchive(archive, protocol),
        throwsA(isA<FormatException>().having((e) => e.message, 'message',
            'Invalid One Diary backup member: source.json')));
  });

  test('required manifests cannot silently become an empty successful import',
      () async {
    archive.files.remove('source.json');
    await expectLater(
        decodeOneDiaryArchive(archive, protocol), throwsFormatException);
  });
}
