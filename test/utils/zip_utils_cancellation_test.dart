// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:io';

import 'package:aid_diary/utils/cancellation_token.dart';
import 'package:aid_diary/utils/zip_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';

void main() {
  late Directory work;
  late Directory inputFolder;
  late String archive;

  setUp(() async {
    work = await Directory.systemTemp.createTemp('zip_utils_cancellation');
    archive = join(work.path, 'backup.zip');
    inputFolder = await Directory(join(work.path, 'images')).create();
    for (var i = 0; i < 20; i++) {
      await File(join(inputFolder.path, 'image_$i.jpg'))
          .writeAsString('picture $i' * 1000);
    }
  });

  tearDown(() => work.delete(recursive: true));

  test('a pre-cancelled token stops compression before it starts', () async {
    final token = CancellationToken()..cancel();

    await expectLater(
        ZipUtils.compress(archive, [], [inputFolder.path],
            cancellationToken: token),
        throwsA(isA<BackupCancelledException>()));
    expect(await File(archive).exists(), isFalse);
  });

  test('cancelling mid-compress stops the archive isolate', () async {
    final token = CancellationToken();

    final result = ZipUtils.compress(archive, [], [inputFolder.path],
        cancellationToken: token, onProgress: (_) => token.cancel());

    await expectLater(result, throwsA(isA<BackupCancelledException>()));
  });

  test('an uncancelled token still compresses normally', () async {
    final token = CancellationToken();

    await ZipUtils.compress(archive, [], [inputFolder.path],
        cancellationToken: token);

    expect(await File(archive).exists(), isTrue);
    expect(token.isCancelled, isFalse);
  });

  test(
      'progress covers standalone files and every folder without going backwards',
      () async {
    final other = await Directory(join(work.path, 'other')).create();
    await File(join(other.path, 'note.txt')).writeAsString('another folder');
    final standalone =
        await File(join(work.path, 'index.json')).writeAsString('{}');
    final progress = <double>[];
    await ZipUtils.compress(
        archive, [standalone.path], [inputFolder.path, other.path],
        onProgress: progress.add);
    expect(progress.first, closeTo(100 / 22, 0.001));
    expect(progress.last, 100);
    for (var i = 1; i < progress.length; i++) {
      expect(progress[i], greaterThanOrEqualTo(progress[i - 1]));
      expect(progress[i], inInclusiveRange(0, 100));
    }
    final unpacked = join(work.path, 'unpacked');
    await ZipUtils.extract(archive, unpacked);
    expect(await File(join(unpacked, 'other', 'note.txt')).readAsString(),
        'another folder');
    expect(await File(join(unpacked, 'index.json')).readAsString(), '{}');
  });
}
