// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/entry_dao.dart';
import 'package:aid_diary/database/entry_image_dao.dart';
import 'package:aid_diary/database/entry_tag_dao.dart';
import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:sqflite/sqflite.dart';

final Logger _logger = Logger('EntryStore');

class EntryDraft {
  final Entry entry;
  final List<EntryTag> tags;
  final List<EntryImage> images;

  const EntryDraft({
    required this.entry,
    this.tags = const [],
    this.images = const [],
  });
}

/// [saved] is this builder's own previous result, so a caller editing a brand
/// new entry picks up the id it was just given.
typedef EntryDraftBuilder = EntryDraft Function(Entry? saved);

/// One editing session. Saves land in the database as they come, so nothing
/// is lost if the app dies, but the session can still be [discard]ed:
/// attachment files it takes off the entry are only deleted on [commit].
class EntryDraftSession {
  EntryDraftSession._(this._store, this._original);

  final EntryStore _store;

  /// The entry as it was before the session; null for a new entry.
  final EntryDraft? _original;
  final Set<String> _removedFiles = {};
  Entry? _lastSaved;
  EntryDraftBuilder? _pendingBuild;
  Completer<Entry>? _pendingCompleter;
  Completer<void>? _idle;

  Future<Entry> save(EntryDraftBuilder buildDraft) {
    _pendingBuild = buildDraft;
    _pendingCompleter ??= Completer<Entry>();
    final future = _pendingCompleter!.future;
    if (_idle == null) {
      _idle = Completer<void>();
      unawaited(_runPending());
    }
    return future;
  }

  Future<void> _runPending() async {
    while (_pendingBuild != null) {
      final buildDraft = _pendingBuild!;
      final completer = _pendingCompleter!;
      _pendingBuild = null;
      _pendingCompleter = null;
      try {
        final saved = await _store._writeDraft(buildDraft(_lastSaved),
            removedFiles: _removedFiles);
        _lastSaved = saved;
        completer.complete(saved);
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    }
    final idle = _idle!;
    _idle = null;
    idle.complete();
  }

  /// Keeps what was saved: deletes the files the session took off.
  Future<void> commit() async {
    await _idle?.future;
    await _store._deleteImageFiles(_removedFiles);
    _removedFiles.clear();
  }

  /// Undoes every save: a new entry goes away for good, an existing one gets
  /// its text, context, tags and attachments back.
  Future<void> discard() async {
    await _idle?.future;
    final saved = _lastSaved;
    if (saved == null) return;
    final original = _original;
    if (original == null) {
      await _store.erase(saved);
    } else {
      await _store._writeDraft(original, removedFiles: _removedFiles);
      // Original files were only set aside; the rest came with the session.
      _removedFiles
          .removeAll(original.images.map((image) => image.imgPath).toSet());
    }
    await _store._deleteImageFiles(_removedFiles);
    _removedFiles.clear();
    _lastSaved = null;
  }
}

typedef _TagWrite = ({List<EntryTag> tags, bool changed});

typedef _ImageWrite = ({
  List<EntryImage> images,
  List<String> removedFiles,
  bool changed
});

class EntryStore with ChangeNotifier {
  static final EntryStore instance = EntryStore._init();

  EntryStore._init();

  List<Entry> _entries = List.empty(growable: true);

  List<Entry> _visibleEntries = const [];
  Set<int> _visibleEntryIds = const {};

  /// Ordinary views never receive hidden entries, even after a local reveal.
  List<Entry> get entries => _visibleEntries;

  Set<int> get visibleEntryIds => _visibleEntryIds;

  /// Complete storage contents for backup/import bookkeeping, never a UI list.
  List<Entry> get allEntries => _entries;

  List<Entry> get hiddenEntries =>
      _entries.where((entry) => entry.isHidden).toList(growable: false);

  @visibleForTesting
  set entries(List<Entry> entries) {
    _entries = entries;
    _indexEntriesByDay();
  }

  Map<DateTime, List<Entry>> _entriesByDay = {};

  /// Starts editing [original], or a new entry when it is null.
  EntryDraftSession beginDraft([Entry? original]) => EntryDraftSession._(
      this,
      original == null
          ? null
          : EntryDraft(
              entry: original,
              tags: TagsProvider.instance.getEntryTagsForEntry(original.id!),
              images: [
                  for (final image
                      in EntryImagesProvider.instance.getForEntry(original))
                    image.copy()
                ]));

  Future<void> _complete = Future.value();

  /// Completes once [entries] holds every entry. Changes wait for it, so a
  /// background read cannot replace an entry written in the meantime.
  Future<void> get complete => _complete;

  /// Reads every entry. With [firstScreen], it returns once that many of the
  /// newest are in [entries], enough to show the journal, and reads the
  /// rest in the background; the time to show the journal then no longer
  /// grows with the diary.
  Future<void> load({int? firstScreen}) async {
    await _complete;
    await _purgeExpired();
    if (firstScreen != null) {
      _setEntries(await EntryDao.getAll(limit: firstScreen));
      if (_entries.length < firstScreen) return;
    }
    final rest = EntryDao.getAll().then(_setEntries);
    _complete = rest;
    if (firstScreen == null) return rest;
    unawaited(rest.then((_) {}, onError: (Object error, StackTrace stackTrace) {
      _logger.severe('Reading the older entries failed', error, stackTrace);
    }));
  }

  void _setEntries(List<Entry> entries) {
    _entries = entries;
    _indexEntriesByDay();
    notifyListeners();
  }

  /// Moves an entry to Recently deleted; its photos and tags stay with it.
  Future<void> delete(Entry entry) async {
    await _complete;
    await EntryDao.setDeleted(entry.id!, DateTime.now());
    _entries = _entries.where((existing) => existing.id != entry.id).toList();
    _indexEntriesByDay();
    await AppDatabase.instance.updateExternalDatabase();
    notifyListeners();
  }

  Future<List<DeletedEntry>> deleted({bool includeHidden = false}) async => [
        for (final item in await EntryDao.getDeleted())
          if (includeHidden || !item.entry.isHidden) item,
      ];

  /// Visibility is stored with the entry; revealing requires the local UI.
  Future<Entry> setHidden(Entry entry, bool hidden) async {
    await _complete;
    final updated = entry.copy(isHidden: hidden, timeModified: DateTime.now());
    await EntryDao.update(updated);
    _entries = [
      for (final existing in _entries)
        existing.id == entry.id ? updated : existing,
    ];
    _indexEntriesByDay();
    await AppDatabase.instance.updateExternalDatabase();
    notifyListeners();
    return updated;
  }

  /// Seals an entry as a time capsule until [openAt], or opens it with null.
  Future<Entry> setOpenAt(Entry entry, DateTime? openAt) async {
    await _complete;
    final updated = entry.copy(openAt: openAt);
    await EntryDao.update(updated);
    _entries = [
      for (final existing in _entries)
        existing.id == entry.id ? updated : existing,
    ];
    _indexEntriesByDay();
    await AppDatabase.instance.updateExternalDatabase();
    notifyListeners();
    return updated;
  }

  /// Sets the weather of an entry, or removes it with null.
  Future<Entry> setWeather(Entry entry, EntryWeather? weather) async {
    await _complete;
    final updated = entry.copy(weather: weather, timeModified: DateTime.now());
    await EntryDao.update(updated);
    _entries = [
      for (final existing in _entries)
        existing.id == entry.id ? updated : existing,
    ];
    _indexEntriesByDay();
    await AppDatabase.instance.updateExternalDatabase();
    notifyListeners();
    return updated;
  }

  /// Brings an entry back from Recently deleted.
  Future<void> restore(Entry entry) async {
    await _complete;
    await EntryDao.setDeleted(entry.id!, null);
    _entries = [..._entries, entry];
    _sortEntries();
    _indexEntriesByDay();
    await AppDatabase.instance.updateExternalDatabase();
    notifyListeners();
  }

  /// Erases entries that sat in Recently deleted past the retention period.
  Future<void> _purgeExpired() async {
    final cutoff = DateTime.now().subtract(AppConfig.instance.deletedRetention);
    for (final item in await EntryDao.getDeleted()) {
      if (item.deletedAt.isBefore(cutoff)) await erase(item.entry);
    }
  }

  /// Removes an entry, its tags and its attachment files for good.
  Future<void> erase(Entry entry) async {
    await _eraseRows(entry);
    TagsProvider.instance.applyEntryTags(entry.id!, const []);
    EntryImagesProvider.instance.applyForEntry(entry.id!, const []);
    await AppDatabase.instance.updateExternalDatabase();
    notifyListeners();
  }

  /// Erases [entries] for good like [erase], but tells listeners once, when
  /// all are gone; [onProgress] gets how many are done.
  Future<void> eraseMany(List<Entry> entries,
      {void Function(int done)? onProgress}) async {
    var done = 0;
    for (final entry in entries) {
      await _eraseRows(entry);
      onProgress?.call(++done);
    }
    await TagsProvider.instance.load();
    await EntryImagesProvider.instance.load();
    await AppDatabase.instance.updateExternalDatabase();
    notifyListeners();
  }

  Future<void> _eraseRows(Entry entry) async {
    // From the database: this also runs while loading, before the image
    // provider has its list.
    final images = await EntryImageDao.getForEntry(entry.id!);

    await AppDatabase.instance.database!.transaction((transaction) async {
      for (final image in images) {
        await EntryImageDao.remove(image, executor: transaction);
      }
      await EntryTagDao.removeAllForEntry(entry.id!, executor: transaction);
      await EntryDao.remove(entry.id!, executor: transaction);
    });

    await _deleteImageFiles(images.map((image) => image.imgPath));

    _entries = _entries.where((existing) => existing.id != entry.id).toList();
    _indexEntriesByDay();
  }

  /// Erases everything in Recently deleted for good; how many entries.
  Future<int> emptyDeleted() async {
    final items = await deleted();
    await eraseMany([for (final item in items) item.entry]);
    return items.length;
  }

  Future<Entry> add(Entry entry, {bool skipUpdate = false}) async {
    await _complete;
    final entryWithId = await EntryDao.add(entry);
    _entries = [..._entries, entryWithId];
    await AppDatabase.instance.updateExternalDatabase();

    if (!skipUpdate) {
      _sortEntries();
      _indexEntriesByDay();
      notifyListeners();
    }
    return entryWithId;
  }

  /// Erases every entry, including those in Recently deleted, and the
  /// attachment files nothing refers to any more.
  Future<void> deleteAll(Function(String) updateStatus) async {
    await _complete;
    updateStatus("0%");
    final allEntries = [
      ...this.allEntries,
      for (final item in await EntryDao.getDeleted()) item.entry,
    ];
    await eraseMany(allEntries,
        onProgress: (done) =>
            updateStatus("${((done / allEntries.length) * 100).round()}%"));

    await load();
    await AppDatabase.instance.updateExternalDatabase();
    await ImageStorage.instance.garbageCollectImages();
  }

  int getIndexOfEntry(int entryId) {
    return _entries.indexWhere((entry) => entry.id == entryId);
  }

  Entry? getEntryForToday() {
    if (entries.isNotEmpty && entries.first.day == DiaryDay.today()) {
      return entries.first;
    }
    return null;
  }

  /// Reads the hours that pick a new entry's default diary day. Existing
  /// entries keep theirs; only "today" may move, so pages redraw.
  void applyDiaryDaySettings() {
    final config = ConfigProvider.instance;
    DiaryDay.startHour = config.get(Settings.dayStartHour);
    DiaryDay.askUntilHour = config.get(Settings.dayAskUntilHour);
    notifyListeners();
  }

  Entry? getEntryForDate(DateTime date) {
    return getEntriesForDate(date).firstOrNull;
  }

  /// Entries of the diary day [date] falls on.
  List<Entry> getEntriesForDate(DateTime date) =>
      _entriesByDay[DiaryDay.dateOf(date)] ?? const [];

  int getEntryDayCount() => _entriesByDay.length;

  bool hasEntryAtTimestamp(DateTime timestamp) {
    return _entries.any((entry) => entry.timeCreate == timestamp);
  }

  /// Writes [draft]; attachment files it drops go to [removedFiles] for the
  /// session to delete later.
  Future<Entry> _writeDraft(EntryDraft draft,
      {required Set<String> removedFiles}) async {
    await _complete;
    late Entry saved;
    late _TagWrite tagWrite;
    late _ImageWrite imageWrite;
    final entryChanged = _entryNeedsWrite(draft.entry);

    await AppDatabase.instance.database!.transaction((transaction) async {
      if (draft.entry.id == null) {
        saved = await EntryDao.add(draft.entry, executor: transaction);
      } else {
        if (entryChanged) {
          await EntryDao.update(draft.entry, executor: transaction);
        }
        saved = draft.entry;
      }
      tagWrite = await _writeEntryTags(transaction, saved.id!, draft.tags);
      imageWrite = await _writeEntryImages(transaction, saved, draft.images);
    });

    if (!entryChanged && !tagWrite.changed && !imageWrite.changed) return saved;

    removedFiles.addAll(imageWrite.removedFiles);

    final index = getIndexOfEntry(saved.id!);
    if (index == -1) {
      _entries = [..._entries, saved];
    } else {
      _entries = [..._entries]..[index] = saved;
    }
    _sortEntries();
    _indexEntriesByDay();

    TagsProvider.instance.applyEntryTags(saved.id!, tagWrite.tags);
    EntryImagesProvider.instance.applyForEntry(saved.id!, imageWrite.images);

    await AppDatabase.instance.updateExternalDatabase();
    notifyListeners();
    return saved;
  }

  bool _entryNeedsWrite(Entry entry) {
    if (entry.id == null) return true;
    final index = getIndexOfEntry(entry.id!);
    if (index == -1) return true;
    final stored = _entries[index];
    return !mapEquals(stored.toJson(), entry.toJson());
  }

  Future<_TagWrite> _writeEntryTags(
      DatabaseExecutor executor, int entryId, List<EntryTag> desired) async {
    // Tags can be deleted while editing entries, drop dead tags
    final liveTagIds = TagsProvider.instance.tags.map((tag) => tag.id).toSet();
    final current = TagsProvider.instance.getEntryTagsForEntry(entryId);
    final currentByTag = {
      for (final entryTag in current) entryTag.tagId: entryTag
    };
    final desiredTagIds = desired
        .map((entryTag) => entryTag.tagId)
        .where(liveTagIds.contains)
        .toSet();
    var changed = false;

    for (final entryTag in current) {
      if (desiredTagIds.contains(entryTag.tagId)) continue;
      await EntryTagDao.remove(entryTag.id!, executor: executor);
      changed = true;
    }

    final written = <EntryTag>[];
    for (final wanted in desired) {
      if (!liveTagIds.contains(wanted.tagId)) continue;
      final existing = currentByTag[wanted.tagId];
      if (existing == null) {
        written.add(await EntryTagDao.add(
          EntryTag(
            entryId: entryId,
            tagId: wanted.tagId,
            value: wanted.value,
            timeCreate: wanted.timeCreate,
          ),
          executor: executor,
        ));
        changed = true;
      } else if (existing.value != wanted.value) {
        final updated = EntryTag(
          id: existing.id,
          entryId: entryId,
          tagId: wanted.tagId,
          value: wanted.value,
          timeCreate: existing.timeCreate,
        );
        await EntryTagDao.update(updated, executor: executor);
        written.add(updated);
        changed = true;
      } else {
        written.add(existing);
      }
    }
    return (tags: written, changed: changed);
  }

  Future<_ImageWrite> _writeEntryImages(
      DatabaseExecutor executor, Entry entry, List<EntryImage> desired) async {
    final current = EntryImagesProvider.instance.getForEntry(entry);
    final written = <EntryImage>[];
    var changed = false;

    for (final image in desired) {
      final wanted = image.copy(entryId: entry.id);
      final existing =
          current.where((saved) => saved.id == wanted.id).firstOrNull;
      if (existing == null) {
        written.add(await EntryImageDao.add(wanted, executor: executor));
        changed = true;
      } else if (existing.imgRank != wanted.imgRank) {
        await EntryImageDao.update(wanted, executor: executor);
        written.add(wanted);
        changed = true;
      } else {
        written.add(existing);
      }
    }

    final desiredIds = desired.map((image) => image.id).nonNulls.toSet();
    final removedFiles = <String>[];
    for (final existing in current) {
      if (desiredIds.contains(existing.id)) continue;
      await EntryImageDao.remove(existing, executor: executor);
      removedFiles.add(existing.imgPath);
      changed = true;
    }

    return (images: written, removedFiles: removedFiles, changed: changed);
  }

  Future<void> _deleteImageFiles(Iterable<String> names) async {
    for (final name in names) {
      await ImageStorage.instance.delete(name);
    }
  }

  void _sortEntries() {
    // By diary day first: an entry written later about a past day sits
    // with that day.
    _entries.sort((a, b) {
      final byDay = b.day.compareTo(a.day);
      return byDay != 0 ? byDay : _compareDateOnly(b.timeCreate, a.timeCreate);
    });
  }

  void _indexEntriesByDay() {
    _visibleEntries =
        List.unmodifiable(_entries.where((entry) => !entry.isHidden));
    _visibleEntryIds = Set.unmodifiable(
        _visibleEntries.map((entry) => entry.id).whereType<int>());
    final index = <DateTime, List<Entry>>{};
    for (final entry in _visibleEntries) {
      index.putIfAbsent(entry.day, () => []).add(entry);
    }
    _entriesByDay = index;
  }
}

extension DeletedEntryRetention on DeletedEntry {
  /// Whole days before Recently deleted erases this entry, rounded up.
  int get daysLeft {
    final expires = deletedAt.add(AppConfig.instance.deletedRetention);
    final days = expires.difference(DateTime.now()).inHours / 24;
    return days.ceil().clamp(0, 9999);
  }
}

int _compareDateOnly(DateTime a, DateTime b) {
  if (a.year != b.year) return a.year.compareTo(b.year);
  if (a.month != b.month) return a.month.compareTo(b.month);
  if (a.day != b.day) return a.day.compareTo(b.day);
  if (a.hour != b.hour) return a.hour.compareTo(b.hour);
  return a.minute.compareTo(b.minute);
}
