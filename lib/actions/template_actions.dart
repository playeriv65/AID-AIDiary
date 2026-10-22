// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/tag_actions.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/l10n/shown_language.dart';
import 'package:aid_diary/models/builtin_templates.dart';
import 'package:aid_diary/models/template.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:aid_diary/utils/diary_day.dart';
import 'package:aid_diary/utils/entry_actions.dart';
import 'package:aid_diary/utils/templates_tags_transfer.dart';

final TemplatesProvider _templates = TemplatesProvider.instance;

Template _template(int id) =>
    _templates.templates.where((template) => template.id == id).firstOrNull ??
    (throw ActionException('not_found', 'There is no template $id'));

Map<String, Object?> _summary(Template template) {
  final text = template.text ?? '';
  return {
    'id': template.id,
    'name': template.name,
    'preview': text.length > 80 ? '${text.substring(0, 80)}…' : text,
    'default':
        ConfigProvider.instance.get(Settings.defaultTemplate) == template.id,
    'tags': _tagNames(template),
  };
}

List<String> _tagNames(Template template) => [
      for (final link
          in TagsProvider.instance.getTemplateTagsForTemplate(template.id!))
        TagsProvider.instance.tags
            .firstWhere((tag) => tag.id == link.tagId)
            .name,
    ];

Map<String, Object?> _details(Template template) => {
      ..._summary(template),
      'text': template.text ?? '',
      'modified': template.timeModified.toIso8601String(),
    };

/// The ids of the tags in [refs], a comma-separated list of names and ids.
List<int> _tagIds(String refs) => [for (final tag in findTags(refs)) tag.id!];

String _name(String input) {
  final name = input.trim();
  if (name.isEmpty) {
    throw const ActionException('bad_args', 'The template name is empty');
  }
  return name;
}

const _tagsParam = ActionParam(
    'tags',
    ParamType.string,
    'Tags to put on new entries made from it, '
        'names or ids (#12 is always an id) separated by commas',
    required: false);

final List<AppAction> templateActions = [
  AppAction(
    id: 'template.list',
    describe: 'Lists your templates, and the ready-made ones the app offers '
        'under Coach.',
    risk: ActionRisk.read,
    run: (context, args) async {
      final l10n = await loadShownLocalizations();
      return {
        'templates': [
          for (final template in _templates.templates) _summary(template),
        ],
        'builtin': [
          for (final template in BuiltinTemplate.all(l10n))
            {
              'id': template.id,
              'name': template.name,
              'description': template.description,
              'text': template.text,
            },
        ],
      };
    },
  ),
  AppAction(
    id: 'template.get',
    describe: 'Shows one template in full.',
    risk: ActionRisk.read,
    params: const [ActionParam('id', ParamType.integer, 'The template id')],
    run: (context, args) async => _details(_template(args['id'] as int)),
  ),
  AppAction(
    id: 'template.create',
    describe: 'Makes a template: text to start an entry from, with the tags '
        'to put on it. {{date}} and {{time}} in the text become the date and '
        'time when the template is used.',
    risk: ActionRisk.write,
    params: const [
      ActionParam('name', ParamType.string, 'The name'),
      ActionParam('text', ParamType.string, 'The text', required: false),
      _tagsParam,
    ],
    run: (context, args) async {
      final now = DateTime.now();
      final saved = await _templates.save(
          Template(
              name: _name(args['name'] as String),
              text: args['text'] as String? ?? '',
              timeCreate: now,
              timeModified: now),
          _tagIds(args['tags'] as String? ?? ''));
      return _details(saved);
    },
  ),
  AppAction(
    id: 'template.update',
    describe: "Changes a template's name, text or tags.",
    risk: ActionRisk.write,
    params: const [
      ActionParam('id', ParamType.integer, 'The template id'),
      ActionParam('name', ParamType.string, 'The new name', required: false),
      ActionParam('text', ParamType.string, 'The new text', required: false),
      ActionParam('tags', ParamType.string,
          'The new tags, names or ids (#12 is always an id) separated by commas; empty for none',
          required: false),
    ],
    run: (context, args) async {
      final template = _template(args['id'] as int);
      final tagIds = switch (args['tags']) {
        final String refs => _tagIds(refs),
        _ => [
            for (final link in TagsProvider.instance
                .getTemplateTagsForTemplate(template.id!))
              link.tagId,
          ],
      };
      final saved = await _templates.save(
          template.copy(
              name: switch (args['name']) {
                final String name => _name(name),
                _ => null,
              },
              text: args['text'] as String?,
              timeModified: DateTime.now()),
          tagIds);
      return _details(saved);
    },
  ),
  AppAction(
    id: 'template.delete',
    describe: 'Deletes a template. If it was the default one, new entries '
        'start empty again.',
    risk: ActionRisk.destructive,
    params: const [ActionParam('id', ParamType.integer, 'The template id')],
    run: (context, args) async {
      final template = _template(args['id'] as int);
      await _templates.remove(template);
      return {'id': template.id, 'deleted': true};
    },
  ),
  AppAction(
    id: 'template.create_from_entry',
    describe: "Saves an entry's text and tags as a template, as the entry "
        "view's Save as template does. It is named after the entry's title.",
    risk: ActionRisk.write,
    params: const [
      ActionParam('id', ParamType.integer, 'The entry id'),
      ActionParam('name', ParamType.string,
          "The name when the entry has no title; the entry's day by default",
          required: false),
    ],
    run: (context, args) async {
      await EntryStore.instance.complete;
      final id = args['id'] as int;
      final entry = EntryStore.instance.entries
              .where((entry) => entry.id == id)
              .firstOrNull ??
          (throw ActionException('not_found', 'There is no entry $id'));
      if (entry.isSealed) {
        throw ActionException('sealed',
            'Entry $id is a time capsule, sealed until ${entry.openAt}');
      }
      final saved = await EntryActions.saveAsTemplate(
          entry, args['name'] as String? ?? DiaryDay.format(entry.day));
      return _details(saved);
    },
  ),
  AppAction(
    id: 'template.export',
    describe: 'Writes templates, with their tags and categories, to a JSON '
        'file that template.import and the share screen read.',
    risk: ActionRisk.write,
    params: const [
      ActionParam('path', ParamType.string, 'The file to write'),
      ActionParam('templates', ParamType.string,
          'Which templates, ids separated by commas; all by default',
          required: false),
    ],
    run: (context, args) async {
      final ids = switch (args['templates']) {
        final String refs => {
            for (final ref in refs.split(','))
              if (ref.trim().isNotEmpty)
                _template(int.tryParse(ref.trim()) ??
                        (throw ActionException(
                            'bad_args', 'Template ids are numbers, not $ref')))
                    .id!,
          },
        _ => {for (final template in _templates.templates) template.id!},
      };
      final path = args['path'] as String;
      await exportToFile(path, TemplatesTagsTransfer.exportTemplates(ids));
      return {'path': path, 'templates': ids.length};
    },
  ),
  AppAction(
    id: 'template.import',
    describe: 'Adds the templates, tags and categories of an exported file; '
        'tags and categories the diary has already are not added twice.',
    risk: ActionRisk.write,
    params: const [ActionParam('path', ParamType.string, 'The file to read')],
    run: (context, args) async => importFromFile(args['path'] as String),
  ),
];
