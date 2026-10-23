// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

// Everything the GUI changes, the command line can change too
// (docs/ARCHITECTURE.md, "Agent-native"): the GUI changes data by running
// actions, never by writing to the stores and services behind them.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

/// Files of the GUI that may write directly, and why no action stands in.
const Map<String, String> _writesDirectly = {
  'pages/edit_entry_view_model.dart':
      'the editor saves a draft as you type; entry.create and entry.update '
          'make the same entry',
  'pages/settings/security_settings.dart':
      'the app lock stays in the GUI on purpose (docs/ARCHITECTURE.md)',
  'widgets/auth_popup.dart':
      'sets the app lock and backup passwords, which stay in the GUI',
  'widgets/hidden_diary_scope.dart':
      'hidden-entry reveal, restore and deletion require a short-lived local '
          'authentication capability; actions cannot bypass that boundary',
};

/// The stores and services that hold the app's data, and the ones the GUI
/// reaches through a variable (`config`, `tagsProvider`, ...).
const _owners = r'(?:EntryStore\.instance|EntriesProvider\.instance|'
    r'TagsProvider\.instance|TemplatesProvider\.instance|'
    r'EntryImagesProvider\.instance|ConfigProvider\.instance|'
    r'SettingsService\.instance|SyncService\.instance|CoachService|'
    r'\w*[Pp]rovider|config)';

/// Their methods that change data.
const _writes = r'(?:add|addCategory|update|updateCategory|'
    r'updateCategorySortOrders|remove|arrangeTags|batchUpdateTags|'
    r'addEntryTag|updateEntryTag|removeEntryTag|setFavorite|setTemplateTags|'
    r'removeAllTemplateTagsForTemplate|removeCategoryAndTags|save|delete|'
    r'setOpenAt|setWeather|restore|erase|eraseMany|emptyDeleted|deleteAll|'
    r'set|setMany|enroll|end|answer|syncNow|createSpace|joinSpace|unlock|'
    r'signInAgain|disconnect|changePassphrase|resetEncryption)';

final _directWrite = RegExp('\\b$_owners\\s*\\.\\s*$_writes\\s*[<(]');

void main() {
  test('the GUI changes data only through actions', () {
    final writes = <String>[];
    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final file =
          p.posix.joinAll(p.split(p.relative(entity.path, from: 'lib')));
      if (!['pages/', 'widgets/', 'layouts/'].any(file.startsWith) ||
          _writesDirectly.containsKey(file)) {
        continue;
      }
      // Whole files, as a call often breaks its line before `.set(`.
      final code = entity
          .readAsLinesSync()
          .map((line) => line.trimLeft().startsWith('//') ? '' : line)
          .join('\n');
      for (final match in _directWrite.allMatches(code)) {
        final line = '\n'.allMatches(code.substring(0, match.start)).length + 1;
        writes.add('lib/$file:$line: '
            '${match[0]!.replaceAll(RegExp(r'\s+'), ' ')}');
      }
    }
    // In full: a failed expect shows only the start of a long list.
    writes.forEach(printOnFailure);
    expect(writes, isEmpty,
        reason: 'Run an action (AppActions.instance.run) so the command line '
            'can do the same, or name in _writesDirectly why none can.');
  });

  test('the rule sees direct writes, not reads', () {
    for (final code in [
      'await TagsProvider.instance.add(tag);',
      'config.set(Settings.theme, value);',
      'ConfigProvider.instance.set<bool>(Settings.x, true);',
      'await EntryStore.instance.delete(entry);',
      'await CoachService.end();',
      'tagsProvider.remove(tag);',
      'await SettingsService.instance\n      .set(Settings.autoBackupEnabled, true)',
    ]) {
      expect(_directWrite.hasMatch(code), isTrue, reason: code);
    }
    for (final code in [
      'final tags = TagsProvider.instance.tags;',
      'ConfigProvider.instance.get(Settings.theme);',
      "AppActions.instance.run('entry.delete', {'id': id});",
      'final entries = EntriesProvider.instance.entries;',
    ]) {
      expect(_directWrite.hasMatch(code), isFalse, reason: code);
    }
  });
}
