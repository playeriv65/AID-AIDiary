// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:io';

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/notification_manager.dart';
import 'package:aid_diary/storage/file_store.dart';
import 'package:aid_diary/storage/local_file_store.dart';
import 'package:aid_diary/storage/storage_picker.dart';
import 'package:aid_diary/utils/backup_encryption.dart';
import 'package:aid_diary/utils/cancellation_token.dart';
import 'package:aid_diary/utils/operation_outcome.dart';
import 'package:aid_diary/utils/password_store.dart';
import 'package:aid_diary/utils/zip_utils.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class _RestoreCancelled implements Exception {}

enum AutoBackupOutcome { succeeded, cancelled, failed, skipped }

/// What a backup or a restore is doing, as its progress reports it.
enum BackupStage { compress, encrypt, transfer, cleanup, decrypt, restore }

typedef BackupProgress = void Function(BackupStage stage, double percent);

/// What to tell the user about [stage] being [percent] done.
String backupStatusText(
        AppLocalizations localizations, BackupStage stage, double percent) =>
    switch (stage) {
      BackupStage.compress =>
        localizations.creatingBackupStatus("${percent.round()}"),
      BackupStage.encrypt =>
        localizations.encryptingBackupStatus("${percent.round()}"),
      BackupStage.transfer => localizations.tranferStatus("${percent.round()}"),
      BackupStage.cleanup => localizations.cleanUpStatus,
      BackupStage.decrypt =>
        localizations.decryptingBackupStatus("${percent.round()}"),
      BackupStage.restore =>
        localizations.restoringBackupStatus("${percent.round()}"),
    };

class BackupRestoreUtils {
  static final Logger _logger = Logger('BackupRestoreUtils');

  // Prevent periodic and catch-up backups from colliding
  static bool _autoBackupRunning = false;

  static const String manualBackupPrefix = 'aid_diary_backup_';
  static const String autoBackupPrefix = 'aid_diary_auto_backup_';

  static String? _backupPassword() =>
      BackupPasswordStore.isEnabled ? BackupPasswordStore.password : null;

  static String _backupName(String prefix) =>
      "$prefix${DateTime.now().toIso8601String().replaceAll(':', '-')}.zip";

  /// Writes a backup into [destination] and returns its file name: encrypted
  /// with the backup password when one is set.
  static Future<String> _writeBackup({
    required PickedDirectory destination,
    required String name,
    required BackupProgress onProgress,
    CancellationToken? cancellationToken,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final stagedArchive = File(join(tempDir.path, name));
    final encryptedArchive = File('${stagedArchive.path}.enc');
    // Unique to prevent overlap if multiple backups manage to run concurrently
    final snapshotDir = Directory(join(tempDir.path, '$name.snapshot'));
    final databaseSnapshot =
        File(join(snapshotDir.path, AppDatabase.databaseFileName));
    final password = _backupPassword();
    final outputName = password != null ? '$name.enc' : name;

    try {
      if (await snapshotDir.exists()) await snapshotDir.delete(recursive: true);
      await snapshotDir.create(recursive: true);
      if (!await AppDatabase.instance.exportSnapshotTo(databaseSnapshot.path)) {
        throw Exception('Failed to create a consistent database snapshot');
      }

      onProgress(BackupStage.compress, 0);
      await ZipUtils.compress(stagedArchive.path, [databaseSnapshot.path],
          [await ImageStorage.instance.getInternalFolder()],
          onProgress: (percent) => onProgress(BackupStage.compress, percent),
          cancellationToken: cancellationToken);

      if (cancellationToken?.isCancelled ?? false) {
        throw BackupCancelledException();
      }
      if (await stagedArchive.length() == 0) {
        throw Exception('Created backup is empty');
      }

      var backupFile = stagedArchive;
      if (password != null) {
        onProgress(BackupStage.encrypt, 0);
        await BackupEncryption.encryptFile(
            stagedArchive.path, encryptedArchive.path, password,
            onProgress: (percent) => onProgress(BackupStage.encrypt, percent),
            cancellationToken: cancellationToken);
        if (cancellationToken?.isCancelled ?? false) {
          throw BackupCancelledException();
        }
        backupFile = encryptedArchive;
      }

      onProgress(BackupStage.transfer, 0);
      final transferred = await destination.copyFileInto(
          backupFile.path, outputName,
          mimeType:
              password != null ? "application/octet-stream" : "application/zip",
          onProgress: (percent) => onProgress(BackupStage.transfer, percent));
      if (!transferred) {
        throw Exception('Failed to transfer backup to $outputName');
      }
      return outputName;
    } finally {
      onProgress(BackupStage.cleanup, 0);
      if (await stagedArchive.exists()) {
        await stagedArchive.delete();
      }
      if (await encryptedArchive.exists()) {
        await encryptedArchive.delete();
      }
      if (await snapshotDir.exists()) {
        await snapshotDir.delete(recursive: true);
      }
    }
  }

  static Future<void> _recordBackup({bool automatic = false}) async {
    final now = DateTime.now().toIso8601String();
    await ConfigProvider.instance.set(Settings.lastBackup, now);
    if (automatic) {
      await ConfigProvider.instance.set(Settings.lastAutoBackup, now);
    }
  }

  /// Throws [BackupCancelledException] when cancelled
  static Future<bool> runAutoBackup(
      {BackupProgress? onProgress,
      CancellationToken? cancellationToken}) async {
    final destinationUri =
        ConfigProvider.instance.get(Settings.autoBackupLocationUri);
    if (destinationUri.isEmpty) return false;
    final destination = PickedDirectory(destinationUri);
    if (!await destination.store.isAvailable()) {
      _logger.severe('Automatic backup skipped: no access to $destinationUri');
      return false;
    }
    if (!await File(await AppDatabase.instance.getInternalPath()).exists()) {
      _logger.info('Automatic backup skipped: no database yet');
      return false;
    }

    final databaseAlreadyOpen = AppDatabase.instance.database != null;
    if (!databaseAlreadyOpen &&
        !await AppDatabase.instance
            .init(forceWithoutSync: true, background: true)) {
      _logger.severe('Automatic backup skipped: could not open database');
      return false;
    }

    try {
      await _writeBackup(
        destination: destination,
        name: _backupName(autoBackupPrefix),
        onProgress: onProgress ?? (_, __) {},
        cancellationToken: cancellationToken,
      );
    } on BackupCancelledException {
      rethrow;
    } catch (error, stackTrace) {
      _logger.severe('Automatic backup failed', error, stackTrace);
      return false;
    } finally {
      if (!databaseAlreadyOpen) await AppDatabase.instance.close();
    }

    await _recordBackup(automatic: true);

    try {
      await _pruneAutoBackups(destination.store,
          ConfigProvider.instance.get(Settings.autoBackupMaxCount));
    } catch (error, stackTrace) {
      _logger.severe('Pruning old backups failed', error, stackTrace);
    }
    return true;
  }

  static Future<AutoBackupOutcome> runAutoBackupAndNotify() async {
    if (_autoBackupRunning) return AutoBackupOutcome.skipped;
    _autoBackupRunning = true;
    try {
      return await _runAutoBackupAndNotify();
    } finally {
      _autoBackupRunning = false;
    }
  }

  static Future<AutoBackupOutcome> _runAutoBackupAndNotify() async {
    final prefs = await currentPrefs();
    final creatingTemplate = prefs.getString('creatingBackupStatusTemplate');
    final encryptingTemplate =
        prefs.getString('encryptingBackupStatusTemplate');
    final transferringTemplate = prefs.getString('tranferStatusTemplate');
    final failedTitle = prefs.getString('autoBackupFailedTitle') ?? '';
    final cancelLabel = prefs.getString('backupCancelActionLabel');

    String stageTitle(String? template, int percent) =>
        template?.replaceFirst('{percent}', '$percent') ?? '';

    await NotificationManager.instance.clearBackupCancelRequest();
    final cancellationToken = CancellationToken();
    final cancelPoll =
        Timer.periodic(const Duration(milliseconds: 300), (_) async {
      if (cancellationToken.isCancelled) return;
      if (await NotificationManager.instance.isBackupCancelRequested()) {
        cancellationToken.cancel();
      }
    });

    try {
      await NotificationManager.instance.showBackupProgress(
          0, stageTitle(creatingTemplate, 0),
          cancelLabel: cancelLabel);
    } catch (error, stackTrace) {
      _logger.warning(
          'Could not show backup progress notification', error, stackTrace);
    }

    var success = false;
    var cancelled = false;
    try {
      String? shownTemplate = creatingTemplate;
      var shownPercent = 0;
      void showStage(String? template, double percent) {
        final rounded = percent.round();
        if (template == shownTemplate && rounded - shownPercent < 5) return;
        shownTemplate = template;
        shownPercent = rounded;
        NotificationManager.instance.showBackupProgress(
            rounded, stageTitle(template, rounded),
            cancelLabel: cancelLabel);
      }

      success = await runAutoBackup(
        cancellationToken: cancellationToken,
        onProgress: (stage, percent) {
          final template = switch (stage) {
            BackupStage.compress => creatingTemplate,
            BackupStage.encrypt => encryptingTemplate,
            BackupStage.transfer => transferringTemplate,
            _ => null,
          };
          if (template != null) showStage(template, percent);
        },
      );
    } on BackupCancelledException {
      cancelled = true;
      _logger.info('Automatic backup cancelled by the user');
    } finally {
      cancelPoll.cancel();
      try {
        if (cancelled || success) {
          await NotificationManager.instance.stopBackupProgress();
        } else {
          await NotificationManager.instance.showBackupFailed(failedTitle);
        }
      } catch (error, stackTrace) {
        _logger.warning(
            'Could not update backup result notification', error, stackTrace);
      }
    }
    if (cancelled) return AutoBackupOutcome.cancelled;
    return success ? AutoBackupOutcome.succeeded : AutoBackupOutcome.failed;
  }

  static Future<void> _pruneAutoBackups(FileStore destination, int keep) async {
    if (keep <= 0) return;
    // Oldest first: the names carry their date.
    final backups = (await destination.list())
        .where((name) =>
            name.startsWith(autoBackupPrefix) &&
            (name.endsWith('.zip') || name.endsWith('.zip.enc')))
        .toList()
      ..sort();
    if (backups.length <= keep) return;

    for (final name in backups.take(backups.length - keep)) {
      await destination.delete(name);
    }
  }

  static Future<void> _extractBackup(File archive, Directory destination,
      void Function(double percent) onProgress) async {
    if (await destination.exists()) {
      await destination.delete(recursive: true);
    }
    await destination.create(recursive: true);
    await ZipUtils.extract(archive.path, destination.path,
        onProgress: onProgress);
  }

  /// Decrypts with the saved backup password, else with one [askPassword]
  /// gets from the user (null cancels).
  static Future<void> _decryptBackup(
      File encrypted,
      File destination,
      void Function(double percent) onProgress,
      Future<String?> Function() askPassword) async {
    try {
      final password =
          BackupPasswordStore.isEnabled ? BackupPasswordStore.password : null;
      if (password == null) throw BackupDecryptionFailedException();
      await BackupEncryption.decryptFile(
          encrypted.path, destination.path, password,
          onProgress: onProgress);
    } catch (_) {
      final password = await askPassword();
      if (password == null) throw _RestoreCancelled();
      await BackupEncryption.decryptFile(
          encrypted.path, destination.path, password,
          onProgress: onProgress);
    }
  }

  /// Backs up the diary into [destination] and records it as the last
  /// backup. Returns the backup's file name.
  static Future<String> backupTo(PickedDirectory destination,
      {BackupProgress? onProgress}) async {
    final name = await _writeBackup(
      destination: destination,
      name: _backupName(manualBackupPrefix),
      onProgress: onProgress ?? (_, __) {},
    );
    await _recordBackup();
    return name;
  }

  static Future<OperationOutcome> backupToZip(
      PickedDirectory destination,
      AppLocalizations localizations,
      void Function(String) updateStatus) async {
    try {
      await backupTo(destination,
          onProgress: (stage, percent) =>
              updateStatus(backupStatusText(localizations, stage, percent)));
      return const OperationOutcome.succeeded();
    } catch (error) {
      return OperationOutcome.failed(error);
    }
  }

  /// Restores a picked backup, replacing the diary; [askPassword] asks for
  /// the password of an encrypted one the saved password does not open
  /// (null cancels).
  static Future<OperationOutcome> restoreFromZip(PickedFile archive,
      AppLocalizations localizations, void Function(String) updateStatus,
      {required Future<String?> Function() askPassword}) async {
    void progress(BackupStage stage, double percent) =>
        updateStatus(backupStatusText(localizations, stage, percent));
    var outcome = const OperationOutcome.succeeded();
    // Its own folder, so a file Windows still holds from the last restore
    // cannot get in the way.
    final work = await (await getTemporaryDirectory()).createTemp('restore');
    const tempImportName = "backup_import";
    final tempImportFile = File(join(work.path, tempImportName));
    final tempZipFile = File(join(work.path, "backup.zip"));
    final restoreFolder = Directory(join(work.path, "Restore"));

    try {
      // Import archive
      progress(BackupStage.transfer, 0);
      await archive.copyInto(work.path, tempImportName,
          onProgress: (percent) => progress(BackupStage.transfer, percent));

      if (await BackupEncryption.looksEncrypted(tempImportFile)) {
        await _decryptBackup(tempImportFile, tempZipFile,
            (percent) => progress(BackupStage.decrypt, percent), askPassword);
      } else {
        if (await tempZipFile.exists()) await tempZipFile.delete();
        await tempImportFile.copy(tempZipFile.path);
      }

      // Restore archive
      progress(BackupStage.restore, 0);

      await _extractBackup(tempZipFile, restoreFolder,
          (percent) => progress(BackupStage.restore, percent));

      final restoreStore = LocalFileStore(restoreFolder.path);
      final databaseBytes =
          await restoreStore.read(AppDatabase.databaseFileName);
      if (databaseBytes != null) {
        // Import database
        await AppDatabase.instance.close();
        await AppDatabase.instance.internalStore
            .write(AppDatabase.databaseFileName, databaseBytes);
        await AppDatabase.instance.open();
        await AppDatabase.instance.updateExternalDatabase();

        // Import images. These will be garbage collected after import
        final restoredImages =
            LocalFileStore(join(restoreFolder.path, "Images"));
        if (await restoredImages.isAvailable()) {
          // Also show cleanup status here since images may take awhile
          progress(BackupStage.cleanup, 0);
          await ImageStorage.instance.whileNotSyncing(() async => restoreImages(
              restoredImages, await ImageStorage.instance.internalStore()));
          if (ImageStorage.instance.usingExternalLocation()) {
            await ImageStorage.instance.syncImageFolder(true);
          }
          ImageStorage.instance.invalidateCache();
        }
      } else {
        outcome = const OperationOutcome.failed();
      }
    } on _RestoreCancelled {
      outcome = const OperationOutcome.cancelled();
    } catch (error) {
      outcome = OperationOutcome.failed(error);
    }

    // Delete temp files
    progress(BackupStage.cleanup, 0);
    await _deleteTemporary(work);

    return outcome;
  }

  /// Deletes what a finished restore left in the temporary folder. Failing
  /// to is no reason to fail the restore: Windows may still hold a file
  /// that was just in use.
  static Future<void> _deleteTemporary(FileSystemEntity leftover) async {
    try {
      if (await leftover.exists()) await leftover.delete(recursive: true);
    } on FileSystemException catch (error, stackTrace) {
      _logger.warning('Could not delete ${leftover.path}', error, stackTrace);
    }
  }

  static Future<void> restoreImages(
      FileStore backup, FileStore destination) async {
    for (final imageName in await backup.list()) {
      final bytes = await backup.read(imageName);
      if (bytes != null) await destination.write(imageName, bytes);
    }
  }
}
