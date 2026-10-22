// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['integration'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/actions/app_actions.dart';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/database/entry_store.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/providers/tags_provider.dart';
import 'package:aid_diary/providers/templates_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/diary_app_harness.dart';

Matcher refused(String code) =>
    throwsA(isA<ActionException>().having((e) => e.code, 'code', code));

void main() {
  DiaryAppHarness().register();
  final actions = AppActions(devBuild: true);

  Future<Map<String, Object?>> run(String id,
      [Map<String, Object?> args = const {}, bool confirmed = false]) async {
    final result = await actions.run(id, args, confirmed: confirmed);
    // What the CLI prints must survive JSON.
    jsonEncode(result);
    return result as Map<String, Object?>;
  }

  test('a template is made, read, changed and deleted', () async {
    await run('tag.create', {'name': 'Evening'});
    await run('tag.create', {'name': 'Gratitude'});
    final created = await run('template.create', {
      'name': 'Evening review',
      'text': 'Today, {{date}}:\n\nGrateful for…',
      'tags': 'Evening, Gratitude',
    });
    final id = '${created['id']}';
    expect(created['tags'], ['Evening', 'Gratitude']);
    expect(TemplatesProvider.instance.templates.single.name, 'Evening review');

    final listed = (await run('template.list'))['templates'] as List;
    expect((listed.single as Map)['preview'], startsWith('Today, {{date}}'));
    expect((await run('template.get', {'id': id}))['text'],
        'Today, {{date}}:\n\nGrateful for…');

    // Only what is given changes; tags stay unless given.
    var changed = await run('template.update', {'id': id, 'text': 'Short'});
    expect(changed['name'], 'Evening review');
    expect(changed['text'], 'Short');
    expect(changed['tags'], ['Evening', 'Gratitude']);
    changed = await run('template.update', {'id': id, 'tags': 'Gratitude'});
    expect(changed['tags'], ['Gratitude']);
    expect(changed['text'], 'Short');
    changed = await run('template.update', {'id': id, 'tags': ''});
    expect(changed['tags'], isEmpty);
    expect(TagsProvider.instance.getTemplateTagsForTemplate(int.parse(id)),
        isEmpty);

    await expectLater(() => run('template.delete', {'id': id}),
        refused('needs_confirmation'));
    await run('template.delete', {'id': id}, true);
    expect(TemplatesProvider.instance.templates, isEmpty);
    await expectLater(
        () => run('template.get', {'id': id}), refused('not_found'));
  });

  test('wrong templates are refused with a reason', () async {
    await expectLater(
        () => run('template.create', {'name': '  '}), refused('bad_args'));
    await expectLater(
        () => run('template.create', {'name': 'A', 'tags': 'Nothing'}),
        refused('not_found'));
    expect(TemplatesProvider.instance.templates, isEmpty);
  });

  test('the ready-made templates are listed with the own ones', () async {
    final listed = await run('template.list');
    expect(listed['templates'], isEmpty);
    final builtin = listed['builtin'] as List;
    expect(builtin, hasLength(6));
    expect((builtin.first as Map).keys,
        containsAll(['id', 'name', 'description', 'text']));
  });

  test('deleting the default template makes entries start empty again',
      () async {
    final created = await run('template.create', {'name': 'Default one'});
    await DiaryAppHarness.setSetting(
        Settings.defaultTemplate, created['id'] as int);
    expect((await run('template.get', {'id': '${created['id']}'}))['default'],
        isTrue);
    await run('template.delete', {'id': '${created['id']}'}, true);
    expect(ConfigProvider.instance.get(Settings.defaultTemplate), -1);
  });

  test('an entry is saved as a template with its tags', () async {
    await run('tag.create', {'name': 'Travel'});
    final entry = await run(
        'entry.create', {'text': '# Packing list\n\nPassport, socks'});
    await run('entry.tag', {'id': '${entry['id']}', 'tag': 'Travel'});

    final template =
        await run('template.create_from_entry', {'id': '${entry['id']}'});
    expect(template['name'], 'Packing list');
    expect(template['text'], '# Packing list\n\nPassport, socks');
    expect(template['tags'], ['Travel']);

    final untitled =
        await run('entry.create', {'text': '', 'day': '2026-10-20'});
    expect(
        (await run(
            'template.create_from_entry', {'id': '${untitled['id']}'}))['name'],
        '2026-10-20');
    await expectLater(() => run('template.create_from_entry', {'id': '9999'}),
        refused('not_found'));
  });

  test('a sealed entry stays sealed when saved as a template', () async {
    final now = DateTime.now();
    final sealed = await EntryStore.instance.add(Entry(
        text: 'A secret',
        timeCreate: now,
        timeModified: now,
        openAt: now.add(const Duration(days: 30))));
    await expectLater(
        () => run('template.create_from_entry', {'id': '${sealed.id}'}),
        refused('sealed'));
    expect(TemplatesProvider.instance.templates, isEmpty);
  });

  test('templates are exported with their tags and imported again', () async {
    await run('category.create', {'name': 'Rituals'});
    await run('tag.create', {'name': 'Morning', 'category': 'Rituals'});
    final kept = await run('template.create',
        {'name': 'Morning pages', 'text': 'Three pages.', 'tags': 'Morning'});
    await run('template.create', {'name': 'Other'});
    final folder = await Directory.systemTemp.createTemp('aid_templates');
    addTearDown(() => folder.delete(recursive: true));
    final path = '${folder.path}/templates.json';

    expect(
        await run(
            'template.export', {'path': path, 'templates': '${kept['id']}'}),
        {'path': path, 'templates': 1});
    final file = jsonDecode(await File(path).readAsString()) as Map;
    expect(file['type'], 'aid_diary_templates');
    expect(file['templates'] as List, hasLength(1));

    await run('template.delete', {'id': '${kept['id']}'}, true);
    final tag = (await run('tag.list', {'search': 'Morning'}))['tags'] as List;
    await run('tag.delete', {'id': '${(tag.single as Map)['id']}'}, true);

    expect(await run('template.import', {'path': path}), {
      'categoriesAdded': 0,
      'tagsAdded': 1,
      'templatesAdded': 1,
    });
    final back = (await run('template.list'))['templates'] as List;
    final restored =
        back.firstWhere((t) => (t as Map)['name'] == 'Morning pages') as Map;
    expect(restored['tags'], ['Morning']);
    expect(back, hasLength(2));

    await expectLater(
        () => run(
            'template.export', {'path': path, 'templates': 'Morning pages'}),
        refused('bad_args'));
  });
}
