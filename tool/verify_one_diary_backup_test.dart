// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

// Explicit opt-in: decode a local archive entirely in memory. Never imports
// entries, launches an app, contacts the network or prints diary content.
import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/config/one_diary_config.dart';
import 'package:aid_diary/utils/formats/one_diary_format.dart';
import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test/utils/formats/archive_files.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('read-only verification of an explicitly selected local backup',
      () async {
    final path = Platform.environment['ONE_DIARY_BACKUP'];
    final output = Platform.environment['ONE_DIARY_REPORT'];
    if (path == null || output == null) {
      fail('Set ONE_DIARY_BACKUP and ONE_DIARY_REPORT for this opt-in check');
    }
    final file = File(path);
    final bytes = await file.readAsBytes();
    final originalHash = sha256.convert(bytes).toString();
    final files = MemoryArchive({
      for (final item in ZipDecoder().decodeBytes(bytes))
        if (item.isFile) item.name: item.content,
    });
    final protocol = await loadOneDiaryProtocol();
    final rows = await decodeOneDiaryArchive(files, protocol);
    final daily = <String, Map<String, Object?>>{};
    final details = <Map<String, Object?>>[];
    final offsets = <String, int>{};
    final codec = OneDiaryCodec(protocol);
    final originals =
        codec.decode('source.json', files.files['source.json']!) as List;
    final byId = {for (final row in originals) row['uuid']: row};
    var dayChanges = 0, photoCount = 0;
    for (final row in rows) {
      final original = byId[row.source!.id];
      final entry = row.entry;
      expect(
          entry.createdInstant.millisecondsSinceEpoch, original['createTime'],
          reason: 'Original instant must survive');
      expect(entry.day.year, original['year']);
      expect(entry.day.month, original['monthOfYear']);
      expect(entry.day.day, original['dayOfMonth']);
      final day = entry.day.toIso8601String().substring(0, 10);
      final instant = entry.createdInstant;
      final sourceDate = DateTime.utc(
          original['year'], original['monthOfYear'], original['dayOfMonth']);
      final chinaDisplay = instant.add(const Duration(hours: 8));
      final chinaDate =
          DateTime.utc(chinaDisplay.year, chinaDisplay.month, chinaDisplay.day);
      if (chinaDate != sourceDate) dayChanges++;
      final offset = '${entry.utcOffset}';
      offsets.update(offset, (n) => n + 1, ifAbsent: () => 1);
      final hasLocation = entry.location?.hasCoordinates == true;
      final detail = <String, Object?>{
        'sourceIdHash': sha256.convert(utf8.encode(row.source!.id)).toString(),
        'day': day,
        'createdUtc': instant.toIso8601String(),
        'writtenWall': entry.timeCreate.toIso8601String(),
        'offsetMinutes': entry.utcOffset,
        'hasSourceCoordinates': hasLocation,
        'hidden': entry.isHidden,
        'photos': row.photos.length,
      };
      details.add(detail);
      if (hasLocation) daily[day] = {'offsetMinutes': entry.utcOffset};
      photoCount += row.photos.length;
      for (final photo in row.photos) {
        final photoBytes = await photo.read();
        expect(photoBytes, isNotEmpty);
      }
    }
    final summary = {
      'mode': 'decode-only; no app import or data deletion',
      'sha256': originalHash,
      'entries': rows.length,
      'hidden': rows.where((row) => row.entry.isHidden).length,
      'photos': photoCount,
      'originalInstantsAndDiaryDaysVerified': true,
      'diaryDaysDifferentFromChinaDisplayDate': dayChanges,
      'offsetCounts': offsets,
      'coordinateTimezoneEvidenceByDay': daily,
      'entriesWithoutSourceCoordinates': rows
          .where((row) => row.entry.location?.hasCoordinates != true)
          .length,
      'records': details,
    };
    expect(sha256.convert(await file.readAsBytes()).toString(), originalHash);
    await File(output)
        .writeAsString(const JsonEncoder.withIndent('  ').convert(summary));
    // Only aggregate, non-content evidence enters the test log.
    // ignore: avoid_print
    print(jsonEncode(Map.of(summary)
      ..remove('records')
      ..remove('coordinateTimezoneEvidenceByDay')));
  });
}
