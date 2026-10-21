// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

// Work that runs without the app on screen: Android alarms (reminder, on
// this day, coach prompt, nudge) and the automatic backup. Each entry point
// starts its own engine, so it sets up what it needs itself.

import 'dart:async';
import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/device_info_service.dart';
import 'package:aid_diary/models/coach_program.dart';
import 'package:aid_diary/notification_manager.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/services/coach_service.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:aid_diary/utils/auto_backup_schedule.dart';
import 'package:aid_diary/utils/backup_restore_utils.dart';
import 'package:aid_diary/utils/logging.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:workmanager/workmanager.dart';

const String _autoBackupPeriodicWorkName = 'auto_backup_periodic';
const String _autoBackupCatchupWorkName = 'auto_backup_catchup';
const String _autoBackupPeriodicTaskName = 'autoBackupPeriodic';
const String _autoBackupCatchupTaskName = 'autoBackupCatchup';
const String _autoBackupRetryAttemptPrefsKey = 'autoBackupRetryAttempt';
const String _alarmDispatcherBuildPrefsKey = 'alarmDispatcherBuild';

// Max backup retry attempts
const int _autoBackupMaxAttempts = 3;

// Lets onTaskStopped wait for the running task's cleanup to actually finish
Completer<void>? _autoBackupCleanupComplete;

/// What every background entry point (alarms, backup work) needs before it
/// reads settings or the diary: it starts without main().
Future<void> _initBackground() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureLogging();
  await ConfigProvider.instance.init();
  await AppConfig.load();
  EntryStore.instance.applyDiaryDaySettings();
}

/// The alarm callback running in this isolate, if any.
Future<void> _alarmQueue = Future.value();

/// Runs an alarm callback, then [rearm] even when it failed: the alarms
/// rearm themselves, so one error would otherwise end them for good.
/// Callbacks due together share this isolate and the one database
/// connection, so they run one after another.
Future<void> _runAlarm(
    String name, Future<void> Function() body, Future<void> Function() rearm) {
  Future<void> step(String what, Future<void> Function() action) async {
    try {
      await action();
    } catch (error, stackTrace) {
      Logger('Alarms').severe('$name alarm: $what failed', error, stackTrace);
    }
  }

  Future<void> run() async {
    await step('run', () async {
      await _initBackground();
      await body();
    });
    await step('rearm', rearm);
  }

  return _alarmQueue = _alarmQueue.then((_) => run());
}

@pragma('vm:entry-point')
void autoBackupCallbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    await _initBackground();

    _autoBackupCleanupComplete = Completer<void>();
    try {
      if (!ConfigProvider.instance.get(Settings.autoBackupEnabled)) {
        return true;
      }
      await NotificationManager.instance.init();
      return await _runAutoBackupWithBoundedRetry();
    } finally {
      if (!_autoBackupCleanupComplete!.isCompleted) {
        _autoBackupCleanupComplete!.complete();
      }
    }
  }, onTaskStopped: (taskName, stopReason) async {
    // Any system-initiated stop, not just a notification tap.
    await NotificationManager.instance.requestBackupCancel();
    await _autoBackupCleanupComplete?.future
        .timeout(const Duration(seconds: 10), onTimeout: () {});
  });
}

Future<bool> _runAutoBackupWithBoundedRetry() async {
  final prefs = await currentPrefs();
  final outcome = await BackupRestoreUtils.runAutoBackupAndNotify();

  if (outcome != AutoBackupOutcome.failed) {
    await prefs.remove(_autoBackupRetryAttemptPrefsKey);
    return true;
  }

  final attempt = (prefs.getInt(_autoBackupRetryAttemptPrefsKey) ?? 0) + 1;
  if (attempt >= _autoBackupMaxAttempts) {
    await prefs.remove(_autoBackupRetryAttemptPrefsKey);
    return true;
  }
  await prefs.setInt(_autoBackupRetryAttemptPrefsKey, attempt);
  return false;
}

@pragma('vm:entry-point')
void onThisDayCallbackDispatcher() => _runAlarm(
    'On this day', _showOnThisDay, () => setOnThisDayAlarm(firstSet: false));

Future<void> _showOnThisDay() async {
  // Skip syncing and migration for the alarm background task
  final ready =
      await AppDatabase.instance.init(forceWithoutSync: true, background: true);

  if (ready) {
    final now = DiaryDay.today();
    final isJalali = TimeManager.isJalaliCalendarFromPlatform();
    final hasOnThisDayEntries = EntriesProvider.instance.entries.any((e) =>
        TimeManager.isSameCalendarDayOfYear(e.day, now, isJalali) &&
        TimeManager.calendarYearOf(e.day, isJalali) !=
            TimeManager.calendarYearOf(now, isJalali));

    if (hasOnThisDayEntries) {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin.initialize(
          settings: const InitializationSettings(
              android:
                  AndroidInitializationSettings('@drawable/ic_notification')));

      // Localized notification text is stored in SharedPreferences upon startup
      var prefs = await currentPrefs();
      var title = prefs.getString('onThisDayNotificationTitle');
      var description = prefs.getString('onThisDayNotificationDescription');

      var androidDetails = AndroidNotificationDetails(
        onThisDayChannelId,
        channelName(prefs, onThisDayChannelId),
        icon: '@drawable/ic_notification',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      );

      if (title != null && description != null) {
        await flutterLocalNotificationsPlugin.show(
            id: 1,
            title: title,
            body: description,
            notificationDetails: NotificationDetails(android: androidDetails),
            payload: DateTime.now().toIso8601String());
      }
    }

    await AppDatabase.instance.close();
  }
}

/// Alarm and notification id of the coach program's prompt.
const int coachAlarmId = 3;

@pragma('vm:entry-point')
void coachCallbackDispatcher() {
  CoachSchedule? schedule;
  _runAlarm('Coach', () async => schedule = await _showCoachPrompt(), () async {
    // Rearm daily until the last prompt has been announced; with no
    // enrolment there is nothing to rearm.
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    if (schedule?.finishedOn(tomorrow) == false) await setCoachAlarm();
  });
}

/// Shows today's prompt when it is new; returns the running schedule.
Future<CoachSchedule?> _showCoachPrompt() async {
  // Localized program text is stored in SharedPreferences upon startup
  final prefs = await currentPrefs();
  final title = prefs.getString(CoachService.titleKey);
  final prompts = prefs.getStringList(CoachService.promptsKey);
  final days = prefs.getInt(CoachService.daysKey);
  final start =
      DateTime.tryParse(ConfigProvider.instance.get(Settings.coachStartDate));
  if (title == null || prompts == null || days == null || start == null) {
    return null;
  }
  final schedule =
      CoachSchedule(start: start, days: days, steps: prompts.length);
  final now = DiaryDay.today();
  if (schedule.newPromptOn(now)) {
    final notifications = FlutterLocalNotificationsPlugin();
    await notifications.initialize(
        settings: const InitializationSettings(
            android:
                AndroidInitializationSettings('@drawable/ic_notification')));
    await notifications.show(
        id: coachAlarmId,
        title: title,
        body: prompts[schedule.stepOn(now)],
        notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
                coachChannelId, channelName(prefs, coachChannelId),
                icon: '@drawable/ic_notification')));
  }
  return schedule;
}

/// Alarm id of the nudge after days without an entry.
const int nudgeAlarmId = 4;

@pragma('vm:entry-point')
void nudgeCallbackDispatcher() =>
    _runAlarm('Nudge', _showNudge, () => setNudgeAlarm());

Future<void> _showNudge() async {
  // Skip syncing and migration for the alarm background task
  final ready =
      await AppDatabase.instance.init(forceWithoutSync: true, background: true);
  if (ready) {
    final latest = EntriesProvider.instance.entries
        .map((e) => e.day)
        .fold<DateTime?>(null, (a, b) => a == null || b.isAfter(a) ? b : a);
    final now = DiaryDay.today();
    final after = AppConfig.instance.nudgeAfterDays;
    final quietDays = latest == null
        ? 0
        : DateTime.utc(now.year, now.month, now.day)
            .difference(DateTime.utc(latest.year, latest.month, latest.day))
            .inDays;
    // Every few quiet days rather than every day.
    if (quietDays >= after && quietDays % after == 0) {
      // Localized notification text is stored in SharedPreferences upon startup
      final prefs = await currentPrefs();
      final title = prefs.getString('nudgeTitle');
      final messages = prefs.getStringList('nudgeMessages');
      if (title != null && messages != null && messages.length == 7) {
        final notifications = FlutterLocalNotificationsPlugin();
        await notifications.initialize(
            settings: const InitializationSettings(
                android: AndroidInitializationSettings(
                    '@drawable/ic_notification')));
        await notifications.show(
            id: nudgeNotificationId,
            title: title,
            body: messages[now.weekday - 1],
            notificationDetails: NotificationDetails(
                android: AndroidNotificationDetails(
                    nudgeChannelId, channelName(prefs, nudgeChannelId),
                    icon: '@drawable/ic_notification')));
      }
    }
    await AppDatabase.instance.close();
  }
}

/// Arms the nudge alarm for the next time its hour comes round.
Future<void> setNudgeAlarm() => _armDaily(
    nudgeAlarmId, AppConfig.instance.nudgeHour, nudgeCallbackDispatcher);

/// Arms the coach prompt alarm for the next time its hour comes round.
Future<void> setCoachAlarm() => _armDaily(
    coachAlarmId, AppConfig.instance.coachPromptHour, coachCallbackDispatcher);

/// Arms [callback] for [hour] today, or tomorrow once past. A run that
/// comes late (the device was off) so still gets today's turn.
Future<void> _armDaily(int id, int hour, void Function() callback) async {
  final now = DateTime.now();
  var at = DateTime(now.year, now.month, now.day, hour);
  if (!at.isAfter(now)) at = DateTime(now.year, now.month, now.day + 1, hour);
  final exact = await NotificationManager.instance.canScheduleExactAlarms();
  await AndroidAlarmManager.oneShotAt(at, id, callback,
      allowWhileIdle: true, exact: exact, rescheduleOnReboot: true);
}

@pragma('vm:entry-point')
void callbackDispatcher() =>
    _runAlarm('Reminder', _showReminder, () => setAlarm(firstSet: false));

Future<void> _showReminder() async {
  // Skip syncing and migration for the alarm background task
  final ready =
      await AppDatabase.instance.init(forceWithoutSync: true, background: true);

  // The alarm fires daily and rearms itself; off days just stay quiet.
  final remindToday = ConfigProvider.instance
      .get(Settings.reminderWeekdays)
      .contains(DiaryDay.today().weekday);
  if (ready) {
    if (remindToday &&
        (EntriesProvider.instance.getEntryForDate(DiaryDay.today()) == null ||
            ConfigProvider.instance.get(Settings.alwaysRemind))) {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin.initialize(
          settings: const InitializationSettings(
              android:
                  AndroidInitializationSettings('@drawable/ic_notification')));

      // Localized notification text is stored in SharedPreferences upon startup
      var prefs = await currentPrefs();
      var title = prefs.getString('dailyReminderTitle');
      var description = prefs.getString('dailyReminderDescription');

      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        reminderChannelId,
        channelName(prefs, reminderChannelId),
        icon: '@drawable/ic_notification',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      );

      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      if (title != null && description != null) {
        await flutterLocalNotificationsPlugin.show(
            id: 0,
            title: title,
            body: description,
            notificationDetails: platformChannelSpecifics,
            payload: DateTime.now().toIso8601String());
      }
    }
    await AppDatabase.instance.close();
  }
}

/// Records the alarm plugin's callback dispatcher once per build.
///
/// [AndroidAlarmManager.initialize] stores the dispatcher's handle and also
/// starts a second Flutter engine that stays up for as long as the process
/// does; the alarm service starts that engine by itself when an alarm fires,
/// so running it on every launch only costs memory and start-up time.
Future<void> recordAlarmDispatcher() async {
  final info = DeviceInfoService().appInfo;
  final build = '${info?.version}+${info?.buildNumber}';
  final prefs = await currentPrefs();
  if (prefs.getString(_alarmDispatcherBuildPrefsKey) == build) return;
  if (await AndroidAlarmManager.initialize()) {
    await prefs.setString(_alarmDispatcherBuildPrefsKey, build);
  }
}

Future<void> setAlarm({bool firstSet = false}) async {
  DateTime referenceTime = TimeManager.startOfDay(DateTime.now());
  Duration currentTime = DateTime.now().difference(referenceTime);

  Duration reminderTime;
  if (ConfigProvider.instance.get(Settings.setReminderTime)) {
    reminderTime = TimeManager.addTimeOfDay(
            referenceTime, TimeManager.scheduledReminderTime())
        .difference(referenceTime);
    if (!firstSet || reminderTime <= currentTime) {
      reminderTime += Duration(days: 1);
    }
  } else {
    final random = Random();
    final timeRange = TimeManager.getReminderTimeRange();

    Duration startTime =
        TimeManager.addTimeOfDay(referenceTime, timeRange.start)
            .difference(referenceTime);
    Duration endTime = TimeManager.addTimeOfDay(referenceTime, timeRange.end)
        .difference(referenceTime);

    if (endTime < startTime) {
      // Extend end time to next day
      endTime += Duration(days: 1);
    }

    // Make alarm today if possible
    if (firstSet && (startTime < currentTime) && (endTime > currentTime)) {
      startTime = currentTime;
    }

    int randomTimeInMinutes =
        random.nextInt(endTime.inMinutes - startTime.inMinutes + 1);
    reminderTime = startTime + Duration(minutes: randomTimeInMinutes);

    if (!firstSet || (reminderTime <= currentTime)) {
      reminderTime += Duration(days: 1);
    }
  }

  DateTime reminderDateTime = DateTime.now().add(reminderTime - currentTime);

  bool exact = await NotificationManager.instance.canScheduleExactAlarms();
  await AndroidAlarmManager.oneShotAt(reminderDateTime, 0, callbackDispatcher,
      allowWhileIdle: true, exact: exact, rescheduleOnReboot: true);
}

Future<void> setOnThisDayAlarm({bool firstSet = false}) async {
  DateTime referenceTime = TimeManager.startOfDay(DateTime.now());
  Duration currentTime = DateTime.now().difference(referenceTime);

  int hour = ConfigProvider.instance.get(Settings.onThisDayNotificationHour);
  int minute =
      ConfigProvider.instance.get(Settings.onThisDayNotificationMinute);
  Duration reminderTime = TimeManager.addTimeOfDay(
          referenceTime, TimeOfDay(hour: hour, minute: minute))
      .difference(referenceTime);

  if (!firstSet || reminderTime <= currentTime) {
    reminderTime += const Duration(days: 1);
  }

  DateTime reminderDateTime = DateTime.now().add(reminderTime - currentTime);
  bool exact = await NotificationManager.instance.canScheduleExactAlarms();
  await AndroidAlarmManager.oneShotAt(
      reminderDateTime, 1, onThisDayCallbackDispatcher,
      allowWhileIdle: true, exact: exact, rescheduleOnReboot: true);
}

// Safe to call repeatedly: ExistingPeriodicWorkPolicy.update updates a
// pending request in place rather than resetting it.
Future<void> armAutoBackupWork() async {
  if (!ConfigProvider.instance.get(Settings.autoBackupEnabled)) {
    await Workmanager().cancelByUniqueName(_autoBackupPeriodicWorkName);
    return;
  }

  final interval = AutoBackupInterval.fromKey(
      ConfigProvider.instance.get(Settings.autoBackupInterval));
  final requireCharging =
      ConfigProvider.instance.get(Settings.autoBackupRequireCharging);

  await Workmanager().registerPeriodicTask(
    _autoBackupPeriodicWorkName,
    _autoBackupPeriodicTaskName,
    frequency: interval.duration,
    existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
    constraints: Constraints(
      requiresDeviceIdle: true,
      requiresCharging: requireCharging,
    ),
    foregroundServiceConfig: await _autoBackupForegroundServiceConfig(),
  );
}

// Kept under its own unique name with ExistingWorkPolicy.keep, so reopening
// the app while a catch-up is already queued doesn't register a duplicate.
// Skips entirely if the periodic work is already running.
Future<void> enqueueAutoBackupCatchup() async {
  if (await isAutoBackupPeriodicRunning()) return;

  await Workmanager().registerOneOffTask(
    _autoBackupCatchupWorkName,
    _autoBackupCatchupTaskName,
    existingWorkPolicy: ExistingWorkPolicy.keep,
    foregroundServiceConfig: await _autoBackupForegroundServiceConfig(),
  );
}

Future<bool> isAutoBackupPeriodicRunning() async {
  final workInfo = await Workmanager().getWorkInfo(_autoBackupPeriodicWorkName);
  return workInfo?.state == WorkState.running;
}

Future<ForegroundServiceConfig> _autoBackupForegroundServiceConfig() async {
  final prefs = await currentPrefs();
  return ForegroundServiceConfig(
    notificationId: backupNotificationId,
    notificationChannelId: backupNotificationChannelId,
    notificationChannelName: channelName(prefs, backupNotificationChannelId),
    notificationTitle: prefs
        .getString('creatingBackupStatusTemplate')
        ?.replaceFirst('{percent}', '0'),
    foregroundServiceType: ForegroundServiceType.dataSync,
  );
}
