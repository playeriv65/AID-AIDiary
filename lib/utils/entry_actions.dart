// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/database/image_storage.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/models/template.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:aid_diary/utils/entry_preview.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

/// Entry-level actions from the detail page's menu.
class EntryActions {
  /// Copies [entry] with its tags and its own copies of the photos.
  static Future<Entry> duplicate(Entry entry) async {
    final now = DateTime.now();
    final copy = await EntriesProvider.instance.add(
        Entry(
            text: entry.text,
            isHidden: entry.isHidden,
            mood: entry.mood,
            day: entry.day,
            weather: entry.weather,
            activity: entry.activity,
            utcOffset: entry.utcOffset,
            timeCreate: entry.timeCreate,
            timeModified: now,
            location: entry.location),
        skipUpdate: true);
    final copyId = copy.id!;
    final tags = TagsProvider.instance;
    for (final tag in tags.getEntryTagsForEntry(entry.id!)) {
      await tags.addEntryTag(EntryTag(
          entryId: copyId,
          tagId: tag.tagId,
          value: tag.value,
          timeCreate: now));
    }
    final images = EntryImagesProvider.instance;
    for (final image in images.getForEntry(entry)) {
      final bytes = await ImageStorage.instance.getBytes(image.imgPath);
      if (bytes == null) continue;
      final name = await ImageStorage.instance.create(
          '${const Uuid().v4()}${p.extension(image.imgPath)}', bytes,
          currTime: now);
      if (name == null) continue;
      await images.add(EntryImage(
          entryId: copyId,
          imgPath: name,
          imgRank: image.imgRank,
          timeCreate: now));
    }
    // Publish the new entry once its tags and photos are in place.
    await EntriesProvider.instance.load();
    return copy;
  }

  /// Saves [entry]'s text and tags as a template named after its title.
  static Future<Template> saveAsTemplate(
      Entry entry, String fallbackName) async {
    final now = DateTime.now();
    final title = entryPreview(entry.text).title;
    final template = await TemplatesProvider.instance.add(Template(
        name: title ?? fallbackName,
        text: entry.text,
        timeCreate: now,
        timeModified: now));
    final tagIds = TagsProvider.instance
        .getEntryTagsForEntry(entry.id!)
        .map((t) => t.tagId)
        .toList();
    if (tagIds.isNotEmpty) {
      await TagsProvider.instance.setTemplateTags(template.id!, tagIds);
    }
    return template;
  }
}
