// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:aid_diary/actions/agent_api.dart';
import 'package:aid_diary/background/background_work.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/notification_manager.dart';
import 'package:aid_diary/l10n/shown_language.dart';

/// What a setting's change sets going besides being stored.
enum _Effect {
  /// The daily reminder alarm follows its on/off and times.
  reminders,

  /// The "on this day" alarm follows its on/off and time.
  onThisDay,
  nudges,
  quickWrite,

  /// The hours a new entry counts for the day before.
  diaryDay,

  /// The background backup job follows its schedule.
  autoBackup,

  /// The command line server starts or stops.
  agentApi,
}

/// Changes settings the way the settings pages do: stores the value, then
/// does what the app must do about it (arms an alarm, applies the diary day
/// hours, starts the command line server). `settings.set` and
/// `settings.set_many` come here, and the pages reach them through
/// `changeSetting`, so a setting means the same wherever it is changed. The
/// theme needs nothing: it follows the stored values by itself.
class SettingsService {
  SettingsService._();

  static final SettingsService instance = SettingsService._();

  static final Map<Setting<Object?>, _Effect> _effects = {
    Settings.dailyReminders: _Effect.reminders,
    Settings.setReminderTime: _Effect.reminders,
    Settings.scheduledReminderHour: _Effect.reminders,
    Settings.scheduledReminderMinute: _Effect.reminders,
    Settings.reminderStartHour: _Effect.reminders,
    Settings.reminderStartMinute: _Effect.reminders,
    Settings.reminderEndHour: _Effect.reminders,
    Settings.reminderEndMinute: _Effect.reminders,
    Settings.onThisDayNotifications: _Effect.onThisDay,
    Settings.onThisDayNotificationHour: _Effect.onThisDay,
    Settings.onThisDayNotificationMinute: _Effect.onThisDay,
    Settings.inactivityNudges: _Effect.nudges,
    Settings.quickWriteNotification: _Effect.quickWrite,
    Settings.dayStartHour: _Effect.diaryDay,
    Settings.dayAskUntilHour: _Effect.diaryDay,
    Settings.autoBackupEnabled: _Effect.autoBackup,
    Settings.autoBackupInterval: _Effect.autoBackup,
    Settings.autoBackupRequireCharging: _Effect.autoBackup,
    Settings.agentApi: _Effect.agentApi,
  };

  /// Turning these on shows notifications, so Android must allow them.
  static final Set<Setting<Object?>> _needNotifications = {
    Settings.dailyReminders,
    Settings.onThisDayNotifications,
    Settings.inactivityNudges,
    Settings.quickWriteNotification,
    Settings.autoBackupEnabled,
  };

  ConfigProvider get _config => ConfigProvider.instance;

  NotificationManager get _notifications => NotificationManager.instance;

  /// Stores [value] and does what it calls for. False, with nothing
  /// changed, when it needs the notification permission and that was not
  /// given.
  Future<bool> set<T>(Setting<T> setting, T value) => setMany({setting: value});

  /// Stores every change first, then does what they call for once each, so
  /// a new time (hour and minute) rearms its alarm once.
  Future<bool> setMany(Map<Setting<Object?>, Object?> changes) async {
    if (Platform.isAndroid &&
        changes.entries.any((change) =>
            change.value == true && _needNotifications.contains(change.key)) &&
        !await _notifications.hasNotificationPermission()) {
      return false;
    }
    for (final MapEntry(:key, :value) in changes.entries) {
      await _config.set(key, value);
    }
    // A chosen colour replaces following the system's.
    if (changes.containsKey(Settings.accentColor)) {
      await _config.set(Settings.followSystemColor, false);
    }
    for (final effect in {
      for (final setting in changes.keys)
        if (_effects[setting] case final effect?) effect
    }) {
      await _apply(effect);
    }
    return true;
  }

  Future<void> _apply(_Effect effect) async {
    switch (effect) {
      case _Effect.diaryDay:
        EntryStore.instance.applyDiaryDaySettings();
      case _Effect.agentApi:
        await AgentApiSwitch.instance.apply();
      // The rest are Android's: the notification and background services
      // exist nowhere else, and the settings pages hide them there.
      case _ when !Platform.isAndroid:
        break;
      case _Effect.reminders:
        await _notifications.stopDailyReminders();
        if (_config.get(Settings.dailyReminders)) {
          await _notifications.startScheduledDailyReminders();
        }
      case _Effect.onThisDay:
        await _notifications.stopOnThisDayNotifications();
        if (_config.get(Settings.onThisDayNotifications)) {
          await _notifications.startOnThisDayNotifications();
        }
      case _Effect.nudges:
        _config.get(Settings.inactivityNudges)
            ? await _notifications.startNudges()
            : await _notifications.stopNudges();
      case _Effect.quickWrite:
        final l10n = shownLocalizations();
        _config.get(Settings.quickWriteNotification)
            ? await _notifications.showQuickWrite(
                l10n.quickWriteTitle, l10n.quickWriteText)
            : await _notifications.hideQuickWrite();
      case _Effect.autoBackup:
        await armAutoBackupWork();
    }
  }
}
