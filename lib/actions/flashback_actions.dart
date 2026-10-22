// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/flashback_manager.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:aid_diary/l10n/shown_language.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:intl/intl.dart';

/// Today's flashbacks: the memories the journal shows above its entries.
final List<AppAction> flashbackActions = [
  AppAction(
    id: 'flashback.list',
    describe: "Lists today's flashbacks as the journal shows them, in the "
        "app's language, each with the entries it brings back. Empty when "
        'flashbacks are switched off. ui.navigate to=flashback index=N '
        'opens one.',
    risk: ActionRisk.read,
    run: (context, args) async {
      await EntryStore.instance.complete;
      final locale = shownLocale();
      final intlLocale = TimeManager.dateLocaleName(locale);
      final flashbacks = FlashbackManager.forToday(
        EntryStore.instance.entries,
        l10n: await loadShownLocalizations(),
        isJalali: TimeManager.isJalaliCalendarFor(locale),
        timeFormat: ConfigProvider.instance.is24HourFormat()
            ? DateFormat.Hm(intlLocale)
            : DateFormat.jm(intlLocale),
      );
      return {
        'flashbacks': [
          for (final (index, flashback) in flashbacks.indexed)
            {
              'index': index,
              'title': flashback.title,
              'onThisDay': flashback.isOnThisDay,
              'entries': [
                for (final (position, entry) in flashback.entries.indexed)
                  {
                    'id': entry.id,
                    'day': DiaryDay.format(entry.day),
                    'label': flashback.entryLabels[position],
                  },
              ],
            },
        ],
      };
    },
  ),
];
