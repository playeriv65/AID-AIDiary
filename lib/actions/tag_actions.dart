// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';
import 'dart:typed_data';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/tag.dart';
import 'package:aid_diary/models/tag_category.dart';
import 'package:aid_diary/models/tag_icon_type.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/utils/color_utils.dart';
import 'package:aid_diary/utils/generated/tag_icon_registry.dart';
import 'package:aid_diary/utils/tag_name_sanitizer.dart';
import 'package:aid_diary/utils/templates_tags_transfer.dart';
import 'package:flutter/widgets.dart';

final TagsProvider _tags = TagsProvider.instance;

/// What [AppAction]s say in place of a category id: no category.
const String _none = 'none';

ActionException _notFound(String what, String ref) =>
    ActionException('not_found', 'There is no $what $ref');

/// The id [ref] spells as `#12`, which names no name: the form to use when
/// a name could be a number.
int? _explicitId(String ref) {
  final match = RegExp(r'^#(\d+)$').firstMatch(ref.trim());
  return match == null ? null : int.parse(match[1]!);
}

/// The tag [ref] names: its name (any case), else its id; `#12` is always
/// an id.
Tag findTag(String ref) {
  final wanted = ref.trim().toLowerCase();
  final explicit = _explicitId(wanted);
  for (final tag in _tags.tags) {
    if (explicit == null && tag.name.toLowerCase() == wanted) return tag;
  }
  final id = explicit ?? int.tryParse(wanted);
  for (final tag in _tags.tags) {
    if (tag.id == id) return tag;
  }
  throw _notFound('tag', ref);
}

/// The tags in [refs], a comma-separated list of names and ids.
List<Tag> findTags(String refs) => [
      for (final ref in refs.split(','))
        if (ref.trim().isNotEmpty) findTag(ref),
    ];

TagCategory _findCategory(String ref) {
  final wanted = ref.trim().toLowerCase();
  final explicit = _explicitId(wanted);
  for (final category in _tags.categories) {
    if (explicit == null && category.name.toLowerCase() == wanted) {
      return category;
    }
  }
  final id = explicit ?? int.tryParse(wanted);
  for (final category in _tags.categories) {
    if (category.id == id) return category;
  }
  throw _notFound('category', ref);
}

/// The category id [ref] names; null for `none`.
int? _categoryId(String ref) => ref == _none ? null : _findCategory(ref).id;

String _name(String input, String what) {
  final name = sanitizeTagName(input);
  if (name.isEmpty) {
    throw ActionException('bad_args', 'The $what name is empty');
  }
  return name;
}

int? _color(String text) => text == _none
    ? null
    : colorFromHex(text) ??
        (throw const ActionException(
            'bad_args', 'color must be #RRGGBB, or none for no color'));

({String? icon, TagIconType type}) _icon(String text) {
  if (text == _none) return (icon: null, type: TagIconType.character);
  if (tagIconRegistry.containsKey(text)) {
    return (icon: text, type: TagIconType.materialIcon);
  }
  if (text.characters.length == 1) {
    return (icon: text, type: TagIconType.character);
  }
  throw const ActionException(
      'bad_args',
      'icon must be a key from tag.icons, a single character such as an '
          'emoji, or none for no icon');
}

Map<String, Object?> _iconJson(String? icon, TagIconType type) => {
      'icon': icon,
      'iconType': type == TagIconType.materialIcon ? 'icon' : 'character',
    };

Map<String, Object?> _tagJson(Tag tag) {
  final category =
      _tags.categories.where((c) => c.id == tag.categoryId).firstOrNull;
  return {
    'id': tag.id,
    'name': tag.name,
    'type': tag.tagType.name,
    'color': tag.color == null ? null : colorToHex(tag.color!),
    ..._iconJson(tag.icon, tag.iconType),
    'categoryId': tag.categoryId,
    'category': category?.name,
    'entries': _tags.entryCountForTag(tag.id!),
  };
}

Map<String, Object?> _categoryJson(TagCategory category) => {
      'id': category.id,
      'name': category.name,
      'color': category.color == null ? null : colorToHex(category.color!),
      ..._iconJson(category.icon, category.iconType),
      'tags': _tags.tags.where((tag) => tag.categoryId == category.id).length,
    };

Tag _tagById(ActionArgs args) {
  final id = args['id'] as int;
  return _tags.tags.where((tag) => tag.id == id).firstOrNull ??
      (throw _notFound('tag', '$id'));
}

TagCategory _categoryById(ActionArgs args) {
  final id = args['id'] as int;
  return _tags.categories.where((c) => c.id == id).firstOrNull ??
      (throw _notFound('category', '$id'));
}

/// Names must stay unique so that a name always says which tag is meant.
void _requireFree(
    String name, Iterable<(int?, String)> existing, int? self, String what) {
  final lower = name.toLowerCase();
  for (final (id, other) in existing) {
    if (id != self && other.toLowerCase() == lower) {
      throw ActionException('exists', 'There is a $what named $other already');
    }
  }
}

void _requireFreeTag(String name, {int? self}) => _requireFree(
    name, [for (final tag in _tags.tags) (tag.id, tag.name)], self, 'tag');

void _requireFreeCategory(String name, {int? self}) => _requireFree(
    name,
    [for (final category in _tags.categories) (category.id, category.name)],
    self,
    'category');

/// Moves [item] to [position] (the end by default) in [list].
List<T> _placed<T>(List<T> list, T item, int? position) {
  final others = [
    for (final other in list)
      if (other != item) other,
  ];
  return others
    ..insert((position ?? others.length).clamp(0, others.length), item);
}

Future<Entry> _entry(int id) async {
  await EntryStore.instance.complete;
  return EntryStore.instance.entries
          .where((entry) => entry.id == id)
          .firstOrNull ??
      (throw _notFound('entry', '$id'));
}

Map<String, Object?> _entryTagsJson(int entryId) => {
      'id': entryId,
      'tags': [
        for (final link in _tags.getEntryTagsForEntry(entryId))
          {
            'tag': _tags.tags.firstWhere((tag) => tag.id == link.tagId).name,
            if (link.value != null) 'value': link.value,
          },
      ],
    };

/// Saves [entry] with [tags], as the editor does: the entry counts as
/// changed, so that sync picks it up.
Future<Map<String, Object?>> _writeEntryTags(
    Entry entry, List<EntryTag> tags) async {
  final session = EntryStore.instance.beginDraft(entry);
  await session.save((_) => EntryDraft(
          entry: entry.copy(timeModified: DateTime.now()),
          tags: tags,
          images: [
            for (final image in EntryImagesProvider.instance.getForEntry(entry))
              image.copy(),
          ]));
  await session.commit();
  return _entryTagsJson(entry.id!);
}

/// Writes [bytes], an export, to [path].
Future<void> exportToFile(String path, Uint8List bytes) async {
  try {
    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes);
  } on FileSystemException catch (error) {
    throw ActionException(
        'io_error', 'Could not write $path: ${error.message}');
  }
}

/// Adds what the export in [path] holds, as the import buttons do.
Future<Map<String, Object?>> importFromFile(String path) async {
  final file = File(path);
  if (!await file.exists()) throw _notFound('file', path);
  try {
    final added =
        await TemplatesTagsTransfer.importBytes(await file.readAsBytes());
    return {
      'categoriesAdded': added.categories,
      'tagsAdded': added.tags,
      'templatesAdded': added.templates,
    };
  } on FormatException catch (error) {
    throw ActionException('bad_file', error.message);
  } on TypeError {
    throw ActionException('bad_file', '$path is not an AID Diary export');
  } on ArgumentError {
    throw ActionException('bad_file', '$path is not an AID Diary export');
  }
}

const _nameParam = ActionParam('name', ParamType.string, 'The name');
const _colorParam = ActionParam(
    'color', ParamType.string, 'A color as #RRGGBB, or none for no color',
    required: false);
const _iconParam = ActionParam(
    'icon',
    ParamType.string,
    'An icon key from tag.icons, a single character such as an emoji, or '
        'none for no icon',
    required: false);

final List<AppAction> tagActions = [
  AppAction(
    id: 'tag.list',
    describe: 'Lists the tags in the order of the tag list, with their '
        'categories.',
    risk: ActionRisk.read,
    params: const [
      ActionParam('category', ParamType.string,
          'Only tags of this category, by id or name (#12 is always an id); none for those without',
          required: false),
      ActionParam('type', ParamType.string, 'Only label or tracker tags',
          required: false),
      ActionParam('search', ParamType.string,
          'Only tags whose name or category name has this text',
          required: false),
    ],
    run: (context, args) async {
      final filterByCategory = args['category'] != null;
      final categoryId =
          filterByCategory ? _categoryId(args['category'] as String) : null;
      final type = switch (args['type']) {
        final String name =>
          TagType.values.where((t) => t.name == name).firstOrNull ??
              (throw const ActionException(
                  'bad_args', 'type must be label or tracker')),
        _ => null,
      };
      final sections = _tags.buildSections(args['search'] as String? ?? '');
      return {
        'categories': [
          for (final category in _tags.categories) _categoryJson(category),
        ],
        'tags': [
          for (final section in sections)
            for (final tag in section.tags)
              if ((!filterByCategory || tag.categoryId == categoryId) &&
                  (type == null || tag.tagType == type))
                _tagJson(tag),
        ],
      };
    },
  ),
  AppAction(
    id: 'tag.icons',
    describe: 'Lists the icon keys a tag or category can have, by group.',
    risk: ActionRisk.read,
    run: (context, args) async => {
      'groups': [
        for (final group in tagIconGroups)
          {'group': group.id.name, 'icons': group.keys},
      ],
    },
  ),
  AppAction(
    id: 'tag.create',
    describe: 'Makes a tag: a label to put on entries, or a tracker that '
        'puts a number on them.',
    risk: ActionRisk.write,
    params: const [
      _nameParam,
      ActionParam('type', ParamType.string, 'label (the default) or tracker',
          required: false),
      _colorParam,
      _iconParam,
      ActionParam('category', ParamType.string,
          'The category, by id or name (#12 is always an id); none for no category',
          required: false),
    ],
    run: (context, args) async {
      final name = _name(args['name'] as String, 'tag');
      _requireFreeTag(name);
      final type = switch (args['type']) {
        null || 'label' => TagType.label,
        'tracker' => TagType.tracker,
        _ => throw const ActionException(
            'bad_args', 'type must be label or tracker'),
      };
      final icon = switch (args['icon']) {
        final String text => _icon(text),
        _ => (icon: null, type: TagIconType.character),
      };
      final now = DateTime.now();
      final created = await _tags.add(Tag(
        name: name,
        tagType: type,
        color: switch (args['color']) {
          final String text => _color(text),
          _ => null,
        },
        icon: icon.icon,
        iconType: icon.type,
        categoryId: switch (args['category']) {
          final String ref => _categoryId(ref),
          _ => null,
        },
        timeCreate: now,
        timeModified: now,
      ));
      return _tagJson(created);
    },
  ),
  AppAction(
    id: 'tag.update',
    describe: "Changes a tag's name, color, icon or category. Its type "
        'stays.',
    risk: ActionRisk.write,
    params: const [
      ActionParam('id', ParamType.integer, 'The tag id'),
      ActionParam('name', ParamType.string, 'The new name', required: false),
      _colorParam,
      _iconParam,
      ActionParam('category', ParamType.string,
          'The category, by id or name (#12 is always an id); none for no category',
          required: false),
    ],
    run: (context, args) async {
      final tag = _tagById(args);
      final name = switch (args['name']) {
        final String text => _name(text, 'tag'),
        _ => tag.name,
      };
      _requireFreeTag(name, self: tag.id);
      final icon = switch (args['icon']) {
        final String text => _icon(text),
        _ => (icon: tag.icon, type: tag.iconType),
      };
      // Built directly: copy() cannot clear a color, icon or category.
      final updated = Tag(
        id: tag.id,
        name: name,
        tagType: tag.tagType,
        color: switch (args['color']) {
          final String text => _color(text),
          _ => tag.color,
        },
        icon: icon.icon,
        iconType: icon.type,
        categoryId: switch (args['category']) {
          final String ref => _categoryId(ref),
          _ => tag.categoryId,
        },
        sortOrder: tag.sortOrder,
        timeCreate: tag.timeCreate,
        timeModified: DateTime.now(),
      );
      await _tags.update(updated);
      return _tagJson(updated);
    },
  ),
  AppAction(
    id: 'tag.delete',
    describe: 'Deletes a tag and takes it off every entry and template.',
    risk: ActionRisk.destructive,
    params: const [ActionParam('id', ParamType.integer, 'The tag id')],
    run: (context, args) async {
      final tag = _tagById(args);
      final entries = _tags.entryCountForTag(tag.id!);
      await _tags.remove(tag);
      return {'id': tag.id, 'deleted': true, 'entries': entries};
    },
  ),
  AppAction(
    id: 'tag.move',
    describe: 'Moves a tag to another category and/or to another place in '
        'the tag list.',
    risk: ActionRisk.write,
    params: const [
      ActionParam('id', ParamType.integer, 'The tag id'),
      ActionParam(
          'category',
          ParamType.string,
          'The category to move it to, by id or name (#12 is always an id); none for no category. '
              'It stays in its own by default',
          required: false),
      ActionParam('position', ParamType.integer,
          'Its place among the tags of the category, from 0; last by default',
          required: false),
    ],
    run: (context, args) async {
      final tag = _tagById(args);
      final target = switch (args['category']) {
        final String ref => _categoryId(ref),
        _ => tag.categoryId,
      };
      List<Tag> section(int? categoryId) => [
            for (final other in _tags.tags)
              if (other.categoryId == categoryId) other,
          ];
      await _tags.arrangeTags({
        if (target != tag.categoryId)
          tag.categoryId: [
            for (final other in section(tag.categoryId))
              if (other.id != tag.id) other,
          ],
        target: _placed(section(target), tag, args['position'] as int?),
      });
      return _tagJson(_tags.tags.firstWhere((other) => other.id == tag.id));
    },
  ),
  AppAction(
    id: 'category.list',
    describe: 'Lists the tag categories in order.',
    risk: ActionRisk.read,
    run: (context, args) async => {
      'categories': [
        for (final category in _tags.categories) _categoryJson(category),
      ],
    },
  ),
  AppAction(
    id: 'category.create',
    describe: 'Makes a tag category.',
    risk: ActionRisk.write,
    params: const [_nameParam, _colorParam, _iconParam],
    run: (context, args) async {
      final name = _name(args['name'] as String, 'category');
      _requireFreeCategory(name);
      final icon = switch (args['icon']) {
        final String text => _icon(text),
        _ => (icon: null, type: TagIconType.character),
      };
      final now = DateTime.now();
      final created = await _tags.addCategory(TagCategory(
        name: name,
        color: switch (args['color']) {
          final String text => _color(text),
          _ => null,
        },
        icon: icon.icon,
        iconType: icon.type,
        timeCreate: now,
        timeModified: now,
      ));
      return _categoryJson(created);
    },
  ),
  AppAction(
    id: 'category.update',
    describe: "Changes a category's name, color or icon.",
    risk: ActionRisk.write,
    params: const [
      ActionParam('id', ParamType.integer, 'The category id'),
      ActionParam('name', ParamType.string, 'The new name', required: false),
      _colorParam,
      _iconParam,
    ],
    run: (context, args) async {
      final category = _categoryById(args);
      final name = switch (args['name']) {
        final String text => _name(text, 'category'),
        _ => category.name,
      };
      _requireFreeCategory(name, self: category.id);
      final icon = switch (args['icon']) {
        final String text => _icon(text),
        _ => (icon: category.icon, type: category.iconType),
      };
      // Built directly: copy() cannot clear a color or icon.
      final updated = TagCategory(
        id: category.id,
        name: name,
        color: switch (args['color']) {
          final String text => _color(text),
          _ => category.color,
        },
        icon: icon.icon,
        iconType: icon.type,
        sortOrder: category.sortOrder,
        timeCreate: category.timeCreate,
        timeModified: DateTime.now(),
      );
      await _tags.updateCategory(updated);
      return _categoryJson(updated);
    },
  ),
  AppAction(
    id: 'category.delete',
    describe: 'Deletes a category together with all its tags, which come '
        'off every entry and template.',
    risk: ActionRisk.destructive,
    params: const [ActionParam('id', ParamType.integer, 'The category id')],
    run: (context, args) async {
      final category = _categoryById(args);
      final tags =
          _tags.tags.where((tag) => tag.categoryId == category.id).length;
      await _tags.removeCategoryAndTags(category);
      return {'id': category.id, 'deleted': true, 'tagsDeleted': tags};
    },
  ),
  AppAction(
    id: 'category.move',
    describe: 'Moves a category to another place in the category order.',
    risk: ActionRisk.write,
    params: const [
      ActionParam('id', ParamType.integer, 'The category id'),
      ActionParam('position', ParamType.integer,
          'Its place among the categories, from 0'),
    ],
    run: (context, args) async {
      final category = _categoryById(args);
      await _tags.updateCategorySortOrders(
          _placed(_tags.categories, category, args['position'] as int));
      return _categoryJson(
          _tags.categories.firstWhere((other) => other.id == category.id));
    },
  ),
  AppAction(
    id: 'entry.tag',
    describe: 'Puts a tag on an entry. A tracker needs its number; putting '
        'the tracker on again changes the number.',
    risk: ActionRisk.write,
    params: const [
      ActionParam('id', ParamType.integer, 'The entry id'),
      ActionParam('tag', ParamType.string,
          'The tag, by name or id (#12 is always an id)'),
      ActionParam('value', ParamType.string,
          'The number of a tracker; labels have none',
          required: false),
    ],
    run: (context, args) async {
      final entry = await _entry(args['id'] as int);
      final tag = findTag(args['tag'] as String);
      final value = (args['value'] as String?)?.trim();
      switch (tag.tagType) {
        case TagType.label when value != null:
          throw ActionException(
              'bad_args', '${tag.name} is a label and has no value');
        case TagType.tracker when double.tryParse(value ?? '') == null:
          throw ActionException(
              'bad_args', '${tag.name} is a tracker: give its value a number');
        default:
      }
      final current = _tags.getEntryTagsForEntry(entry.id!);
      final existing =
          current.where((link) => link.tagId == tag.id).firstOrNull;
      if (existing != null && existing.value == value) {
        return _entryTagsJson(entry.id!);
      }
      return _writeEntryTags(entry, [
        for (final link in current)
          if (link.tagId != tag.id) link,
        EntryTag(
            entryId: entry.id!,
            tagId: tag.id!,
            value: value,
            timeCreate: existing?.timeCreate ?? DateTime.now()),
      ]);
    },
  ),
  AppAction(
    id: 'entry.untag',
    describe: 'Takes a tag off an entry.',
    risk: ActionRisk.write,
    params: const [
      ActionParam('id', ParamType.integer, 'The entry id'),
      ActionParam('tag', ParamType.string,
          'The tag, by name or id (#12 is always an id)'),
    ],
    run: (context, args) async {
      final entry = await _entry(args['id'] as int);
      final tag = findTag(args['tag'] as String);
      final current = _tags.getEntryTagsForEntry(entry.id!);
      if (current.every((link) => link.tagId != tag.id)) {
        return _entryTagsJson(entry.id!);
      }
      return _writeEntryTags(entry, [
        for (final link in current)
          if (link.tagId != tag.id) link,
      ]);
    },
  ),
  AppAction(
    id: 'tag.export',
    describe: 'Writes tags, with their categories, to a JSON file that '
        'tag.import and the share screen read.',
    risk: ActionRisk.write,
    params: const [
      ActionParam('path', ParamType.string, 'The file to write'),
      ActionParam('tags', ParamType.string,
          'Which tags, names or ids separated by commas; all by default',
          required: false),
    ],
    run: (context, args) async {
      final chosen = switch (args['tags']) {
        final String refs => findTags(refs),
        _ => _tags.tags,
      };
      final path = args['path'] as String;
      await exportToFile(
          path,
          TemplatesTagsTransfer.exportTags(
              {for (final tag in chosen) tag.id!}));
      return {'path': path, 'tags': chosen.length};
    },
  ),
  AppAction(
    id: 'tag.import',
    describe: 'Adds the tags, categories and templates of an exported file; '
        'those the diary has already are not added twice.',
    risk: ActionRisk.write,
    params: const [ActionParam('path', ParamType.string, 'The file to read')],
    run: (context, args) async => importFromFile(args['path'] as String),
  ),
];
