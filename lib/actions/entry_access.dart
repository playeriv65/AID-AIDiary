// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/entry_link.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/utils/diary_day.dart';

/// What the entry actions share: finding an entry, keeping time capsules
/// shut, and writing an entry the way the editor does.
const ActionParam entryIdParam =
    ActionParam('id', ParamType.integer, 'The entry id');

/// The value of an optional text argument that clears what it sets.
const String noValue = 'none';

/// The entry [args] names, whatever state it is in.
Future<Entry> entryOf(ActionArgs args) async {
  final store = EntryStore.instance;
  await store.complete;
  final id = args['id'] as int;
  for (final entry in store.entries) {
    if (entry.id == id) return entry;
  }
  throw ActionException('not_found', 'There is no entry $id');
}

/// The entry [args] names, unless it is a time capsule that has not opened:
/// as in the GUI, a sealed entry can only be opened early or deleted.
Future<Entry> openEntryOf(ActionArgs args) async {
  final entry = await entryOf(args);
  if (entry.isSealed) {
    throw ActionException(
        'sealed',
        'Entry ${entry.id} is a time capsule sealed until '
            '${DiaryDay.format(entry.openAt!)}');
  }
  return entry;
}

/// Writes [entry] and, when given, [images] (in the order to show, highest
/// rank first) and the entries it cites ([refs]); its tags stay. Files the
/// images no longer name go away.
Future<Entry> saveEntry(Entry entry,
    {List<EntryImage>? images, List<EntryRef>? refs}) async {
  final session = EntryStore.instance.beginDraft(entry);
  final saved = await session.save((_) => EntryDraft(
      entry: entry,
      tags: TagsProvider.instance.getEntryTagsForEntry(entry.id!),
      refs: refs,
      images: images ??
          [
            for (final image in EntryImagesProvider.instance.getForEntry(entry))
              image.copy(),
          ]));
  await session.commit();
  return saved;
}

/// Writes [bytes] to a new file at [path]; an existing file is never
/// replaced, since an action cannot ask first.
Future<void> writeNewFile(String path, List<int> bytes) async {
  final file = File(path);
  try {
    await file.create(exclusive: true);
    await file.writeAsBytes(bytes, flush: true);
  } on FileSystemException catch (error) {
    throw ActionException('write_failed',
        'Could not write $path: ${error.osError?.message ?? error.message}');
  }
}
