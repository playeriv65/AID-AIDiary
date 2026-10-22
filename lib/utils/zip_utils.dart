// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:aid_diary/utils/cancellation_token.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

class ZipUtils {
  /// Zips [inputFiles] and [inputFolders]; each folder's contents go under
  /// its name, or at the zip's root when [foldersAtRoot] is set.
  static Future<void> compress(
      String outputFile, List<String> inputFiles, List<String> inputFolders,
      {Function(double percent)? onProgress,
      CancellationToken? cancellationToken,
      bool foldersAtRoot = false}) async {
    if (cancellationToken?.isCancelled ?? false) {
      throw BackupCancelledException();
    }

    var rxPort = ReceivePort();
    var completer = Completer<void>();
    final exitPort = ReceivePort();
    final exited = exitPort.first;
    SendPort? controlPort;

    rxPort.listen((data) {
      if (data is SendPort) {
        controlPort = data;
        if (cancellationToken?.isCancelled ?? false) data.send('cancel');
      } else if (data is String && data == _encodeArchiveDone) {
        if (!completer.isCompleted) {
          if (cancellationToken?.isCancelled ?? false) {
            completer.completeError(BackupCancelledException());
          } else {
            completer.complete();
          }
        }
      } else if (data is String) {
        if (!completer.isCompleted) completer.completeError(Exception(data));
      } else {
        onProgress?.call(data);
      }
    });

    await Isolate.spawn(
        encodeArchive,
        {
          "outputFile": outputFile,
          "inputFiles": inputFiles,
          "inputFolders": inputFolders,
          "foldersAtRoot": foldersAtRoot,
          "port": rxPort.sendPort,
        },
        onExit: exitPort.sendPort);

    // Cooperative cancellation lets the encoder close its streams before
    // reporting cancellation; killing an isolate skips its finally blocks.
    cancellationToken?.attachNativeCancel(() => controlPort?.send('cancel'));

    try {
      await completer.future;
    } finally {
      cancellationToken?.detach();
      rxPort.close();
      await exited;
      exitPort.close();
    }
  }

  static Future<void> extract(String inputFile, String outputFolder,
      {Function(double percent)? onProgress}) async {
    var rxPort = ReceivePort();

    rxPort.listen((data) {
      if (onProgress != null) {
        onProgress(data);
      }
    });

    await compute(decodeArchive, {
      "inputFile": inputFile,
      "outputFolder": outputFolder,
      "port": rxPort.sendPort,
    });

    rxPort.close();
  }

  static const _encodeArchiveDone = 'done';

  static Future<void> encodeArchive(Map<String, dynamic> args) async {
    SendPort sendPort = args["port"];
    final control = ReceivePort();
    var cancelled = false;
    control.listen((_) => cancelled = true);
    sendPort.send(control.sendPort);
    final encoder = ZipFileEncoder();
    var opened = false;
    String? failure;
    try {
      final files = List<String>.from(args['inputFiles']);
      final folders = List<String>.from(args['inputFolders']);
      final counts = <int>[];
      for (final folder in folders) {
        if (isWithin(
            absolute(folder), absolute(args['outputFile'] as String))) {
          throw ArgumentError(
              'The output archive must be outside its input folders.');
        }
        counts.add(await Directory(folder).list(recursive: true).length);
      }
      final total =
          files.length + counts.fold<int>(0, (sum, count) => sum + count);
      var completed = 0;
      encoder.createWithStream(OutputFileStream(args["outputFile"]));
      opened = true;
      for (var file in files) {
        if (cancelled) break;
        await encoder.addFile(File(file));
        completed++;
        sendPort.send(completed / total * 100);
      }
      for (final (index, folder) in folders.indexed) {
        if (cancelled) break;
        await encoder.addDirectory(Directory(folder),
            includeDirName: !(args["foldersAtRoot"] as bool),
            level: 0,
            filter: (_, progress) =>
                cancelled ? ZipFileOperation.cancel : ZipFileOperation.include,
            onProgress: (progress) {
              if (total > 0) {
                sendPort
                    .send((completed + counts[index] * progress) / total * 100);
              }
            });
        completed += counts[index];
      }
    } catch (error) {
      failure = error.toString();
    } finally {
      if (opened) {
        try {
          await encoder.close();
        } catch (error) {
          failure ??= error.toString();
        }
      }
      control.close();
    }
    if (failure == null && !cancelled) sendPort.send(100.0);
    sendPort.send(failure ?? _encodeArchiveDone);
  }

  static Future<void> decodeArchive(Map<String, dynamic> args) async {
    SendPort sendPort = args["port"];
    final input = InputFileStream(args["inputFile"]);
    try {
      final destination = Directory(args['outputFolder'] as String);
      await destination.create(recursive: true);
      final root = await destination.resolveSymbolicLinks();
      var decoder = ZipDecoder().decodeStream(input);

      // Track number of files for progress indication
      var totalFileCount = decoder.numberOfFiles();
      var processedFileCount = 0;

      for (final entry in decoder) {
        final name = entry.name.replaceAll('\\', '/');
        if (entry.isSymbolicLink ||
            RegExp(r'^(?:/|[A-Za-z]:)').hasMatch(name) ||
            name.split('/').contains('..')) {
          throw FormatException('Archive entry has an unsafe path.');
        }
        final target = normalize(join(root, name));
        if (!isWithin(root, target)) {
          throw FormatException('Archive entry is outside the destination.');
        }
        var current = root;
        for (final part in split(relative(target, from: root))) {
          current = join(current, part);
          if (await FileSystemEntity.type(current, followLinks: false) ==
              FileSystemEntityType.link) {
            throw FormatException('Archive entry traverses a symbolic link.');
          }
        }
        if (entry.isFile) {
          final bytes = entry.readBytes();
          if (bytes == null) continue;
          final file = File(target);
          await file.create(recursive: true);
          await file.writeAsBytes(bytes);

          // Updates status
          processedFileCount += 1;
          sendPort.send((processedFileCount / totalFileCount) * 100);
        } else {
          await Directory(target).create(recursive: true);
        }
      }
    } finally {
      // Open, the file cannot be deleted on Windows.
      await input.close();
    }
  }
}
