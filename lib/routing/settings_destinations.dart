// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/device_info_service.dart';
import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/pages/recently_deleted_page.dart';
import 'package:aid_diary/pages/search_page.dart';
import 'package:aid_diary/pages/settings/about_settings.dart';
import 'package:aid_diary/pages/settings/appearance_settings.dart';
import 'package:aid_diary/pages/settings/backup_restore_settings.dart';
import 'package:aid_diary/pages/settings/command_line_settings.dart';
import 'package:aid_diary/pages/settings/data_settings.dart';
import 'package:aid_diary/pages/settings/flashback_settings.dart';
import 'package:aid_diary/pages/settings/help_page.dart';
import 'package:aid_diary/pages/settings/language_settings.dart';
import 'package:aid_diary/pages/settings/notification_settings.dart';
import 'package:aid_diary/pages/settings/security_settings.dart';
import 'package:aid_diary/pages/settings/storage_settings.dart';
import 'package:aid_diary/pages/settings/sync_settings.dart';
import 'package:aid_diary/pages/settings/sync_copy_settings.dart';
import 'package:aid_diary/pages/settings/sync_network_settings.dart';
import 'package:aid_diary/pages/settings/nearby_migration_settings.dart';
import 'package:aid_diary/pages/settings/sync_device_settings.dart';
import 'package:aid_diary/widgets/pairing_dialog.dart';
import 'package:aid_diary/pages/settings/tags_settings.dart';
import 'package:aid_diary/pages/settings/templates_page.dart';
import 'package:aid_diary/pages/settings_page.dart';
import 'package:aid_diary/pages/statistics_page.dart';
import 'package:aid_diary/pages/tutorial_page.dart';
import 'package:aid_diary/routing/destination.dart';
import 'package:aid_diary/widgets/auto_backup_settings_dialog.dart';
import 'package:aid_diary/widgets/command_palette.dart';
import 'package:material_ui/material_ui.dart';

/// Search, statistics and every page of the settings.
final List<Destination> settingsDestinations = [
  pageDestination('search', 'Search entries', (_) => const SearchPage()),
  pageDestination(
      'statistics',
      'Statistics: streaks, moods, tags',
      (context) => Scaffold(
          appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.pageStatisticsTitle)),
          body: const StatsPage())),
  pageDestination('settings', 'The settings', (_) => const SettingsPage()),
  pageDestination(
      'settings/appearance',
      'Theme, colours, fonts, calendar and more',
      (_) => const AppearanceSettings()),
  pageDestination(
      'settings/language', 'The app language', (_) => const LanguageSettings()),
  pageDestination('settings/data', 'Sync, backup, storage, recently deleted',
      (_) => const DataSettings()),
  pageDestination('sync', 'Sync', (_) => const SyncSettings()),
  pageDestination(
      'settings/sync/copies',
      'Named device copies and last confirmations',
      (_) => const SyncCopySettings()),
  pageDestination('settings/sync/network', 'Network paths and media receipts',
      (_) => const SyncNetworkSettings()),
  Destination(
      'settings/sync/nearby',
      'Offline device pairing and diary migration',
      (context, args) => pushPlace(
          context,
          'settings/sync/nearby',
          (_) => NearbyMigrationSettings(
              receive: args['receive'] as bool? ?? false)),
      params: const [
        ActionParam('receive', ParamType.boolean,
            'Open directly as a new receiving device',
            required: false)
      ]),
  pageDestination(
      'settings/sync/devices',
      'Authorize, revoke and rotate device signing keys',
      (_) => const SyncDeviceSettings()),
  Destination(
      'sync/pairing',
      'Pairs this device with another of the user\'s: shows a code or '
          'takes one',
      (context, args) => showPlaceDialog<void>(
          context, 'sync/pairing', (_) => const PairingDialog())),
  pageDestination('settings/backup', 'Backup, restore, import and export',
      (_) => const BackupRestoreSettings()),
  Destination(
      'settings/auto_backup',
      'Automatic backups: where to and how often',
      (context, args) => showPlaceDialog<void>(context, 'settings/auto_backup',
          (_) => const AutoBackupSettingsDialog())),
  pageDestination('settings/storage', 'Where the diary and media are stored',
      (_) => const StorageSettings()),
  pageDestination('recently_deleted', 'Entries deleted in the last days',
      (_) => const RecentlyDeletedPage()),
  pageDestination('settings/stories', 'Flashbacks and stories',
      (_) => const FlashbackSettings()),
  pageDestination('settings/notifications', 'Reminders (Android)',
      (_) => const NotificationSettings()),
  pageDestination('settings/security', 'App lock and backup password',
      (_) => const SecuritySettings()),
  pageDestination('settings/command_line', 'The command line and its token',
      (_) => const CommandLineSettings()),
  Destination(
      'commands',
      'The command palette: every action, searchable and runnable',
      (context, args) => showPlaceDialog<void>(
          context, 'commands', (_) => const CommandPalette())),
  pageDestination('tags', 'Tags and categories', (_) => const TagsSettings()),
  pageDestination('templates', 'Templates', (_) => const TemplateSettings()),
  pageDestination('settings/help', 'Help', (_) => const HelpPage()),
  pageDestination('settings/tutorial', 'Learn to use the diary',
      (_) => const TutorialPage()),
  pageDestination(
      'settings/about', 'Version and licenses', (_) => const AboutSettings()),
  pageDestination(
      'settings/license', 'The license text', (_) => const LicenseTextPage()),
  pageDestination(
      'settings/licenses',
      'Open-source licenses',
      (context) => LicensePage(
          applicationName: AppLocalizations.of(context)!.appTitle,
          applicationVersion: DeviceInfoService().appInfo?.version ?? '')),
];
