// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:aid_diary/main.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

const int backupNotificationId = 2;
const int nudgeNotificationId = 4;
const int quickWriteNotificationId = 5;

// Notification channels. Android lists each under its localized name,
// stored in SharedPreferences at startup so background isolates have it.
const String reminderChannelId = 'aid_diary_reminder';
const String onThisDayChannelId = 'aid_diary_on_this_day';
const String coachChannelId = 'aid_diary_coach';
const String nudgeChannelId = 'aid_diary_nudge';
const String quickWriteChannelId = 'aid_diary_quick_write';
const String backupNotificationChannelId = 'aid_diary_backup';

/// Channel ids from before the rename, deleted at start so each channel is
/// listed once in Android's settings.
const List<String> _legacyChannelIds = [
  'daily_you_reminder',
  'daily_you_on_this_day',
  'daily_you_coach',
  'daily_you_nudge',
  'daily_you_quick_write',
  'daily_you_backup',
];

String channelNameKey(String channelId) => 'channelName.$channelId';

/// The localized name stored for [channelId], or the id before the app has
/// run once.
String channelName(SharedPreferences prefs, String channelId) =>
    prefs.getString(channelNameKey(channelId)) ?? channelId;
const String backupCancelActionId = 'cancel_auto_backup';
const String _backupCancelRequestedPrefsKey = 'autoBackupCancelRequested';

// May run on its own background isolate, separate from the backup's.
@pragma('vm:entry-point')
void backupCancelBackgroundHandler(NotificationResponse response) async {
  if (response.actionId != backupCancelActionId) return;
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationManager.instance.requestBackupCancel();
}

class NotificationManager {
  static final NotificationManager instance = NotificationManager._init();

  static FlutterLocalNotificationsPlugin? _notifications;

  bool justLaunched = true;

  /// Taps on notifications that open a new entry while the app runs.
  final newEntryTaps = StreamController<void>.broadcast();

  FlutterLocalNotificationsPlugin get notifications {
    return _notifications!;
  }

  NotificationManager._init();

  static final NotificationManager _instance = NotificationManager._internal();

  factory NotificationManager() {
    return _instance;
  }

  NotificationManager._internal();

  Future<void> init() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    _notifications = flutterLocalNotificationsPlugin;

    await _notifications!.initialize(
        settings: const InitializationSettings(
            android:
                AndroidInitializationSettings('@drawable/ic_notification')),
        onDidReceiveNotificationResponse: _onResponse,
        onDidReceiveBackgroundNotificationResponse:
            backupCancelBackgroundHandler);
    if (Platform.isAndroid) {
      for (final id in _legacyChannelIds) {
        await _android.deleteNotificationChannel(channelId: id);
      }
    }
  }

  /// A tap while the app runs; a cold start reads the launch details.
  void _onResponse(NotificationResponse response) {
    if (response.actionId == backupCancelActionId) {
      backupCancelBackgroundHandler(response);
    } else if (response.id == quickWriteNotificationId ||
        response.id == nudgeNotificationId) {
      newEntryTaps.add(null);
    }
  }

  /// The lasting "quick write" notification; tapping it opens a new entry.
  /// Its text stays stored while it is on, so QuickWriteRestoreReceiver on
  /// Android can put it back after a restart.
  Future<void> showQuickWrite(String title, String text) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_quickWriteTitleKey, title);
    await prefs.setString(_quickWriteTextKey, text);
    await _notifications!.show(
        id: quickWriteNotificationId,
        title: title,
        body: text,
        notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
                quickWriteChannelId, channelName(prefs, quickWriteChannelId),
                icon: '@drawable/ic_notification',
                importance: Importance.low,
                priority: Priority.low,
                ongoing: true,
                autoCancel: false,
                showWhen: false,
                playSound: false)));
  }

  Future<void> hideQuickWrite() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_quickWriteTitleKey);
    await prefs.remove(_quickWriteTextKey);
    await _notifications!.cancel(id: quickWriteNotificationId);
  }

  static const _quickWriteTitleKey = 'quickWriteTitle';
  static const _quickWriteTextKey = 'quickWriteText';

  Future<void> startNudges() => setNudgeAlarm(firstSet: true);

  Future<void> stopNudges() async {
    await AndroidAlarmManager.cancel(nudgeAlarmId);
    await _notifications!.cancel(id: nudgeNotificationId);
  }

  // SharedPreferencesAsync, not SharedPreferences.getInstance() which caches the whole map
  Future<void> requestBackupCancel() =>
      _asyncPrefs.setBool(_backupCancelRequestedPrefsKey, true);

  Future<bool> isBackupCancelRequested() async =>
      (await _asyncPrefs.getBool(_backupCancelRequestedPrefsKey)) ?? false;

  Future<void> clearBackupCancelRequest() =>
      _asyncPrefs.remove(_backupCancelRequestedPrefsKey);

  final SharedPreferencesAsync _asyncPrefs = SharedPreferencesAsync();

  Future<bool> hasNotificationPermission() async {
    if (Platform.isAndroid) {
      var hasPermissions = await _notifications!
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();

      if (hasPermissions ?? false) {
        await requestExactAlarmPermission();
        return true;
      }
    }
    return false;
  }

  /// Prompt the user to grant exact alarm scheduling.
  /// It is not a requirement, reminders will fall back to inexact.
  Future<void> requestExactAlarmPermission() async {
    if (!await _supportsExactAlarmPermission()) {
      return;
    }

    var status = await Permission.scheduleExactAlarm.status;
    if (!status.isGranted) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  Future<bool> canScheduleExactAlarms() async {
    if (!await _supportsExactAlarmPermission()) {
      return true;
    }
    return (await Permission.scheduleExactAlarm.status).isGranted;
  }

  Future<bool> _supportsExactAlarmPermission() async {
    if (!Platform.isAndroid) {
      return false;
    }
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt > 30;
  }

  Future<void> dismissReminderNotification() async {
    var activeNotifications = await NotificationManager.instance.notifications
        .getActiveNotifications();
    for (var notif in activeNotifications) {
      if (notif.id == 0) {
        await NotificationManager.instance.notifications.cancel(id: 0);
      }
    }
  }

  Future<void> dismissOnThisDayNotification() async {
    var activeNotifications = await NotificationManager.instance.notifications
        .getActiveNotifications();
    for (var notif in activeNotifications) {
      if (notif.id == 1) {
        await NotificationManager.instance.notifications.cancel(id: 1);
      }
    }
  }

  Future<void> stopDailyReminders() async {
    await AndroidAlarmManager.cancel(0);
    await dismissReminderNotification();
  }

  Future<void> startScheduledDailyReminders() async {
    setAlarm(firstSet: true);
  }

  Future<void> stopOnThisDayNotifications() async {
    await AndroidAlarmManager.cancel(1);
    await dismissOnThisDayNotification();
  }

  Future<void> startOnThisDayNotifications() async {
    setOnThisDayAlarm(firstSet: true);
  }

  AndroidFlutterLocalNotificationsPlugin get _android =>
      _notifications!.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!;

  Future<void> showBackupProgress(int percent, String title,
      {String? cancelLabel}) async {
    await _android.startForegroundService(
      id: backupNotificationId,
      title: title,
      notificationDetails: AndroidNotificationDetails(
        backupNotificationChannelId,
        channelName(
            await SharedPreferences.getInstance(), backupNotificationChannelId),
        icon: '@drawable/ic_notification',
        importance: Importance.low,
        priority: Priority.low,
        showProgress: true,
        maxProgress: 100,
        progress: percent,
        onlyAlertOnce: true,
        actions: cancelLabel == null
            ? null
            : [
                AndroidNotificationAction(
                  backupCancelActionId,
                  cancelLabel,
                  showsUserInterface: false,
                ),
              ],
      ),
      foregroundServiceTypes: const {
        AndroidServiceForegroundType.foregroundServiceTypeDataSync
      },
    );
  }

  Future<void> stopBackupProgress() => _android.stopForegroundService();

  Future<void> showBackupFailed(String title) async {
    await _android.stopForegroundService();
    await _notifications!.show(
        id: backupNotificationId,
        title: title,
        body: null,
        notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
          backupNotificationChannelId,
          channelName(await SharedPreferences.getInstance(),
              backupNotificationChannelId),
          icon: '@drawable/ic_notification',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        )),
        payload: DateTime.now().toIso8601String());
  }
}
