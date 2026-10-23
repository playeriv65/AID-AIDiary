// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/template.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:aid_diary/utils/entry_preview.dart';

/// Entry-level actions from the detail page's menu.
class EntryActions {
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
