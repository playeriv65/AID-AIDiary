// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/models/tag_category.dart';
import 'package:aid_diary/sync/sync_schema.dart';
import 'package:aid_diary/utils/sync_ids.dart';

class TagCategoryDao {
  static Future<List<TagCategory>> getAll() async {
    final db = AppDatabase.instance.database!;
    final rows = await db.query(tagCategoriesTable,
        orderBy:
            '${TagCategoryFields.sortOrder} ASC, ${TagCategoryFields.name} ASC');
    return rows.map((json) => TagCategory.fromJson(json)).toList();
  }

  /// Adds [category] with the sync id of its name, as `TagDao.add` does.
  static Future<TagCategory> add(TagCategory category) async {
    final db = AppDatabase.instance.database!;
    final id = await db.insert(tagCategoriesTable, {
      ...category.toJson(),
      syncIdColumn: await freeSyncId(
          db, tagCategoriesTable, categorySyncId(category.name)),
    });
    return category.copy(id: id);
  }

  static Future<void> update(TagCategory category) async {
    final db = AppDatabase.instance.database!;
    await db.update(
      tagCategoriesTable,
      category.toJson(),
      where: '${TagCategoryFields.id} = ?',
      whereArgs: [category.id],
    );
  }

  static Future<void> remove(int id) async {
    final db = AppDatabase.instance.database!;
    await db.delete(
      tagCategoriesTable,
      where: '${TagCategoryFields.id} = ?',
      whereArgs: [id],
    );
  }
}
