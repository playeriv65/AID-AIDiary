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
  static Future<void> compress(
      String outputFile, List<String> inputFiles, List<String> inputFolders,
      {Function(double percent)? onProgress,
      CancellationToken? cancellationToken}) async {
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
      encoder.createWithStream(OutputFileStream(args["outputFile"]));
      opened = true;
      for (var file in args["inputFiles"]) {
        if (cancelled) break;
        await encoder.addFile(File(file));
      }
      for (var folder in args["inputFolders"]) {
        if (cancelled) break;
        // TODO This is not accurate and only works for a single folder
        await encoder.addDirectory(Directory(folder),
            level: 0,
            filter: (_, progress) =>
                cancelled ? ZipFileOperation.cancel : ZipFileOperation.include,
            onProgress: (progress) {
              sendPort.send(progress * 100);
            });
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
    sendPort.send(failure ?? _encodeArchiveDone);
  }

  static Future<void> decodeArchive(Map<String, dynamic> args) async {
    SendPort sendPort = args["port"];
    var decoder = ZipDecoder().decodeStream(InputFileStream(args["inputFile"]));

    // Track number of files for progress indication
    var totalFileCount = decoder.numberOfFiles();
    var processedFileCount = 0;

    for (final entry in decoder) {
      if (entry.isFile) {
        final bytes = entry.readBytes();
        if (bytes == null) continue;
        // Fix for Zip encodings that place / at the start of files paths.
        // All Zip paths should be relative
        String fileName = entry.name;
        if (fileName.startsWith('/')) {
          fileName = fileName.substring(1);
        }
        final file = File(join(args["outputFolder"], fileName));
        await file.create(recursive: true);
        await file.writeAsBytes(bytes);

        // Updates status
        processedFileCount += 1;
        sendPort.send((processedFileCount / totalFileCount) * 100);
      } else {
        await Directory(join(args["outputFolder"], entry.name))
            .create(recursive: true);
      }
    }
  }
}
