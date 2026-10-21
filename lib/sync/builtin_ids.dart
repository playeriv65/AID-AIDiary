// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/models/tag_category.dart';
import 'package:aid_diary/models/tag_icon_type.dart';
import 'package:aid_diary/models/template.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/sync/sync_schema.dart';
import 'package:sqflite/sqflite.dart';

/// File name of the welcome entry's photo.
const String welcomeImageName = 'welcome_first_steps.webp';

/// Gives what every install makes for itself (default tags, categories and
/// templates, and the welcome entry) the same id everywhere, so two devices
/// joining one space share one copy instead of syncing two. The oldest row
/// that matches takes the id, and only while no row has it yet.
Future<void> assignBuiltinIds(DatabaseExecutor db,
    {required List<String> defaultTemplateNames}) async {
  final materialIcon = TagIconType.materialIcon.toInt();
  for (final icon in TagsProvider.defaultCategoryIcons) {
    await _claim(
        db,
        tagCategoriesTable,
        'builtin-category-$icon',
        '${TagCategoryFields.icon} = ? AND ${TagCategoryFields.iconType} = ?',
        [icon, materialIcon]);
  }
  for (final icon in TagsProvider.defaultTagIcons) {
    await _claim(
        db,
        tagsTable,
        'builtin-tag-$icon',
        '${TagFields.icon} = ? AND ${TagFields.iconType} = ?',
        [icon, materialIcon]);
  }
  for (final (index, name) in defaultTemplateNames.indexed) {
    await _claim(db, templatesTable, 'builtin-template-${index + 1}',
        '${TemplatesFields.name} = ?', [name]);
  }
  await _claim(db, imagesTable, 'builtin-image-welcome',
      '${EntryImageFields.imgPath} = ?', [welcomeImageName]);
  await _claim(
      db,
      entriesTable,
      'builtin-entry-welcome',
      'id = (SELECT ${EntryImageFields.entryId} FROM $imagesTable '
          'WHERE $syncIdColumn = ?)',
      ['builtin-image-welcome']);
}

Future<void> _claim(DatabaseExecutor db, String table, String id, String where,
    List<Object?> args) async {
  final taken = await db.query(table,
      columns: ['id'], where: '$syncIdColumn = ?', whereArgs: [id], limit: 1);
  if (taken.isNotEmpty) return;
  final match = await db.query(table,
      columns: ['id'], where: where, whereArgs: args, orderBy: 'id', limit: 1);
  if (match.isEmpty) return;
  await db.update(table, {syncIdColumn: id},
      where: 'id = ?', whereArgs: [match.single['id']]);
}
