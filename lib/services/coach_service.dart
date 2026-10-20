// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:daily_you/config_provider.dart';
import 'package:daily_you/database/entry_store.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/main.dart';
import 'package:daily_you/models/coach_program.dart';
import 'package:daily_you/models/entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enrolment in a coach program: one at a time, its prompts answered from
/// the stories, a notification on each day that brings a new one.
class CoachService {
  /// What the background notification needs, refreshed at every start so
  /// it follows the app language.
  static const titleKey = 'coachNotificationTitle';
  static const promptsKey = 'coachNotificationPrompts';
  static const daysKey = 'coachNotificationDays';

  /// The running enrolment, or null when there is none or it has finished.
  static CoachEnrollment? current(AppLocalizations l10n, {DateTime? now}) {
    final config = ConfigProvider.instance;
    final program = CoachProgram.byId(l10n, config.get(Settings.coachProgram));
    final start = DateTime.tryParse(config.get(Settings.coachStartDate));
    if (program == null || start == null) return null;
    final enrollment = CoachEnrollment(
        program: program,
        start: start,
        answered: config.get(Settings.coachAnsweredStep));
    return enrollment.schedule.finishedOn(now ?? DateTime.now())
        ? null
        : enrollment;
  }

  static Future<void> enroll(AppLocalizations l10n, CoachProgram program,
      {DateTime? now}) async {
    final day = now ?? DateTime.now();
    final config = ConfigProvider.instance;
    await config.set(Settings.coachProgram, program.id);
    await config.set(Settings.coachStartDate,
        DateTime(day.year, day.month, day.day).toIso8601String());
    await config.set(Settings.coachAnsweredStep, -1);
    if (Platform.isAndroid) {
      await storeNotificationText(l10n);
      await setCoachAlarm(firstSet: true);
    }
  }

  static Future<void> end() async {
    final config = ConfigProvider.instance;
    await config.set(Settings.coachProgram, '');
    await config.set(Settings.coachStartDate, '');
    await config.set(Settings.coachAnsweredStep, -1);
    if (Platform.isAndroid) await AndroidAlarmManager.cancel(coachAlarmId);
  }

  /// Saves the answer to [prompt] as an entry and marks [step] answered.
  static Future<Entry> answer(String prompt, String answer, int step) async {
    final now = DateTime.now();
    final entry = await EntryStore.instance.add(Entry(
        text: '## $prompt\n\n${answer.trim()}',
        timeCreate: now,
        timeModified: now));
    await ConfigProvider.instance.set(Settings.coachAnsweredStep, step);
    return entry;
  }

  static Future<void> storeNotificationText(AppLocalizations l10n) async {
    final prefs = await SharedPreferences.getInstance();
    final enrollment = current(l10n);
    if (enrollment == null) {
      await prefs.remove(titleKey);
      await prefs.remove(promptsKey);
      await prefs.remove(daysKey);
      return;
    }
    await prefs.setString(titleKey, enrollment.program.title);
    await prefs.setStringList(promptsKey, enrollment.program.prompts);
    await prefs.setInt(daysKey, enrollment.program.days);
  }
}
