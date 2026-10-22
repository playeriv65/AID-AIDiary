@Tags(['integration'])
library;

import 'dart:io';
import 'package:aid_diary/utils/zip_utils.dart';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  for (final name in [
    '../outside.txt',
    '..\\outside.txt',
    '/outside.txt',
    'C:/outside.txt'
  ]) {
    test('rejects archive path $name', () async {
      final folder = await Directory.systemTemp.createTemp('zip-paths-');
      try {
        final input = File(p.join(folder.path, 'bad.zip'));
        final archive = Archive()
          ..addFile(ArchiveFile.string(name, 'unexpected'));
        await input.writeAsBytes(ZipEncoder().encode(archive));
        await expectLater(
            ZipUtils.extract(input.path, p.join(folder.path, 'output')),
            throwsA(isA<FormatException>()));
        expect(
            await File(p.join(folder.path, 'outside.txt')).exists(), isFalse);
      } finally {
        await folder.delete(recursive: true);
      }
    });
  }
}
