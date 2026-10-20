// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:material_ui/material_ui.dart';

/// The entry store as a listenable for widgets.
class EntriesProvider with ChangeNotifier {
  static final EntriesProvider instance = EntriesProvider._init();

  EntriesProvider._init() {
    _store.addListener(notifyListeners);
  }

  final EntryStore _store = EntryStore.instance;

  /// Newest first. Replaced, never changed in place, on every change.
  List<Entry> get entries => _store.entries;

  Future<void> load() => _store.load();

  Future<Entry> add(Entry entry, {bool skipUpdate = false}) =>
      _store.add(entry, skipUpdate: skipUpdate);

  Future<void> deleteAll(Function(String) updateStatus) =>
      _store.deleteAll(updateStatus);

  int getIndexOfEntry(int entryId) => _store.getIndexOfEntry(entryId);

  Entry? getEntryForToday() => _store.getEntryForToday();

  Entry? getEntryForDate(DateTime date) => _store.getEntryForDate(date);

  List<Entry> getEntriesForDate(DateTime date) =>
      _store.getEntriesForDate(date);

  int getEntryDayCount() => _store.getEntryDayCount();

  bool hasEntryAtTimestamp(DateTime timestamp) =>
      _store.hasEntryAtTimestamp(timestamp);
}
