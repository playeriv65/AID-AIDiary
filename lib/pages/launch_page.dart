// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:io';

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/device_info_service.dart';
import 'package:aid_diary/launch_intent.dart';
import 'package:aid_diary/main.dart';
import 'package:aid_diary/notification_manager.dart';
import 'package:aid_diary/pages/onboarding_page.dart';
import 'package:aid_diary/services/coach_service.dart';
import 'package:aid_diary/services/home_widget_service.dart';
import 'package:aid_diary/utils/auto_backup_schedule.dart';
import 'package:aid_diary/widgets/auth_popup.dart';
import 'package:material_ui/material_ui.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:logging/logging.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaunchPage extends StatefulWidget {
  final Widget nextPage;
  const LaunchPage({super.key, required this.nextPage});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  final Logger _logger = Logger('LaunchPage');
  bool isLoading = true;
  bool _initialized = false;
  Future<void> _launchIntentRead = Future.value();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;

      _initializeApp();
    }
  }

  Future _initializeApp() async {
    // Only the database holds up the journal. The notification text is
    // bookkeeping for later, and the shortcuts only have to be read before
    // the journal looks at the launch intent.
    final l10n = AppLocalizations.of(context)!;
    final materialL10n = MaterialLocalizations.of(context);
    unawaited(_storeLocalizedNotificationStrings(l10n, materialL10n)
        .then((_) {}, onError: (Object error, StackTrace stackTrace) {
      _logger.severe('Storing notification text failed', error, stackTrace);
    }));
    _launchIntentRead = _updateAppShortcuts(l10n).then((_) {},
        onError: (Object error, StackTrace stackTrace) {
      _logger.severe('Reading the launch shortcut failed', error, stackTrace);
    });
    await _checkDatabaseConnection();
  }

  Future<void> _updateAppShortcuts(AppLocalizations l10n) async {
    if (!Platform.isAndroid) return;
    final widgetUri = await HomeWidgetService.launchUri();
    if (HomeWidgetService.isWrite(widgetUri)) {
      DeviceInfoService().launchIntent = LaunchIntent.logToday();
    } else if (HomeWidgetService.isNewEntry(widgetUri)) {
      DeviceInfoService().launchIntent = LaunchIntent.newEntry();
    } else if (HomeWidgetService.entryOf(widgetUri) case final id?) {
      DeviceInfoService().launchIntent = LaunchIntent.openEntry(id);
    }
    final QuickActions quickActions = const QuickActions();
    await quickActions.initialize((shortcutType) {
      if (shortcutType == 'action_log_today') {
        DeviceInfoService().launchIntent = LaunchIntent.logToday();
      } else if (shortcutType == 'action_take_photo') {
        DeviceInfoService().launchIntent = LaunchIntent.takePhoto();
      }
    });

    await quickActions.clearShortcutItems();
    await quickActions.setShortcutItems(<ShortcutItem>[
      ShortcutItem(
        type: 'action_log_today',
        localizedTitle: l10n.dailyReminderTitle,
        icon: '@drawable/ic_shortcut_edit',
      ),
      ShortcutItem(
        type: 'action_take_photo',
        localizedTitle: l10n.actionTakePhoto,
        icon: '@drawable/ic_shortcut_camera_alt',
      )
    ]);
  }

  /// Stores the text that notifications show when they are posted from a
  /// background isolate, which has no localizations of its own.
  static Future<void> _storeLocalizedNotificationStrings(
      AppLocalizations l10n, MaterialLocalizations materialL10n) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      for (final (key, value) in [
        ('dailyReminderTitle', l10n.dailyReminderTitle),
        ('dailyReminderDescription', l10n.dailyReminderDescription),
        ('onThisDayNotificationTitle', l10n.flashbackOnThisDay),
        ('onThisDayNotificationDescription', l10n.settingsOnThisDayDescription),
        ('autoBackupFailedTitle', l10n.autoBackupFailedTitle),
        ('backupCancelActionLabel', materialL10n.cancelButtonLabel),
        (
          'creatingBackupStatusTemplate',
          l10n.creatingBackupStatus('{percent}')
        ),
        (
          'encryptingBackupStatusTemplate',
          l10n.encryptingBackupStatus('{percent}')
        ),
        ('tranferStatusTemplate', l10n.tranferStatus('{percent}')),
        (channelNameKey(reminderChannelId), l10n.channelReminders),
        (channelNameKey(onThisDayChannelId), l10n.channelOnThisDay),
        (channelNameKey(coachChannelId), l10n.channelCoach),
        (channelNameKey(nudgeChannelId), l10n.channelNudges),
        (channelNameKey(quickWriteChannelId), l10n.channelQuickWrite),
        (channelNameKey(backupNotificationChannelId), l10n.channelBackup),
        ('nudgeTitle', l10n.nudgeTitle),
      ])
        prefs.setString(key, value),
      // Monday first, as DateTime.weekday counts.
      prefs.setStringList('nudgeMessages', [
        l10n.nudgeMonday,
        l10n.nudgeTuesday,
        l10n.nudgeWednesday,
        l10n.nudgeThursday,
        l10n.nudgeFriday,
        l10n.nudgeSaturday,
        l10n.nudgeSunday,
      ]),
      CoachService.storeNotificationText(l10n),
    ]);
    if (!Platform.isAndroid) return;
    // A lasting notification does not survive a restart; put it back.
    if (ConfigProvider.instance.get(Settings.quickWriteNotification)) {
      await NotificationManager.instance
          .showQuickWrite(l10n.quickWriteTitle, l10n.quickWriteText);
    }
    // These alarms rearm themselves from their callback; arming them again
    // here mends a chain a failed run broke. Fixed hours, so this is a no-op
    // otherwise.
    if (CoachService.current(l10n) != null) await setCoachAlarm();
    if (ConfigProvider.instance.get(Settings.inactivityNudges)) {
      await setNudgeAlarm();
    }
  }

  Future _checkDatabaseConnection() async {
    // Prompt unlock before initializing database
    if (ConfigProvider.instance.get(Settings.requirePassword)) {
      if (!mounted) return;
      await showDialog(
          context: context,
          builder: (context) => AuthPopup(
                mode: AuthPopupMode.unlock,
                title: AppLocalizations.of(context)!.unlockAppPrompt,
                showBiometrics:
                    ConfigProvider.instance.get(Settings.biometricUnlock),
                dismissable: false,
                onSuccess: (_) {},
              ));
    }
    //Initialize Database
    bool initialized;
    try {
      initialized = await AppDatabase.instance
          .init(firstScreen: AppConfig.instance.launchFirstScreenEntries);
    } catch (error, stackTrace) {
      _logger.severe('Database initialization failed', error, stackTrace);
      initialized = false;
    }

    if (initialized) {
      if (ImageStorage.instance.usingExternalLocation()) {
        if (await ImageStorage.instance.hasExternalLocationPermission()) {
          unawaited(ImageStorage.instance.syncImageFolder(false).then((_) {},
              onError: (Object error, StackTrace stackTrace) {
            _logger.severe(
                'Syncing the image folder failed', error, stackTrace);
          }));
          unawaited(_catchUpMissedAutoBackup());
          await _nextPage();
          return;
        }
      } else {
        unawaited(_catchUpMissedAutoBackup());
        await _nextPage();
        return;
      }
    }

    // The database or the external folder could not be reached.
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _catchUpMissedAutoBackup() async {
    if (!Platform.isAndroid) return;
    final configProvider = ConfigProvider.instance;
    if (!configProvider.get(Settings.autoBackupEnabled)) return;

    final overdue = autoBackupIsOverdue(
      now: DateTime.now(),
      lastRun: DateTime.tryParse(configProvider.get(Settings.lastAutoBackup)),
      interval: AutoBackupInterval.fromKey(
          configProvider.get(Settings.autoBackupInterval)),
    );
    if (!overdue) return;

    await enqueueAutoBackupCatchup();
  }

  Future _forceLocalDatabase() async {
    try {
      await AppDatabase.instance.init(
          forceWithoutSync: true,
          firstScreen: AppConfig.instance.launchFirstScreenEntries);
      await _nextPage();
    } catch (error, stackTrace) {
      _logger.severe(
          'Forced local database initialization failed', error, stackTrace);
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _nextPage() async {
    // The welcome pages come first, once.
    final onboarded = ConfigProvider.instance.get(Settings.onboardingDone);
    await _launchIntentRead;
    if (!mounted) return;
    // The journal replaces the launch screen at once, the way content
    // replaces a splash screen; a page transition here only delays it.
    await Navigator.of(context).pushReplacement(PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, _, __) =>
            onboarded ? widget.nextPage : OnboardingPage(next: widget.nextPage),
        allowSnapshotting: false));
  }

  Widget _buildErrorScaffold({
    required String title,
    required String description,
    required List<Widget> actions,
  }) {
    return Scaffold(
      extendBody: true,
      body: Center(
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  description,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              ...actions,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: SizedBox());

    final localizations = AppLocalizations.of(context)!;

    return _buildErrorScaffold(
      title: localizations.errorExternalStorageAccessTitle,
      description: localizations.errorExternalStorageAccessDescription,
      actions: [
        TextButton(
            onPressed: _forceLocalDatabase,
            child: Text(localizations.errorExternalStorageAccessContinue)),
      ],
    );
  }
}
