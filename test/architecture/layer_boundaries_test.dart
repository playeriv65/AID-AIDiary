// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

// Keeps the dependency direction of docs/ARCHITECTURE.md: the UI depends on
// the data layer, the data layer on pure models and logic, never back.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

/// What a folder under lib/ must not import, and why.
typedef Rule = ({
  List<String> from,
  List<String> forbidden,
  String why,
});

const List<Rule> _rules = [
  (
    from: ['models/', 'stats/'],
    forbidden: [
      'pages/', 'widgets/', 'layouts/', 'routing/', 'database/', //
      'providers/', 'services/', 'storage/', 'background/', 'main.dart',
      'package:flutter/material.dart', 'package:flutter/widgets.dart',
      'package:flutter/cupertino.dart', 'package:material_ui/',
    ],
    why: 'models and statistics are plain Dart: no UI, no storage',
  ),
  (
    from: [
      'database/',
      'storage/',
      'services/',
      'providers/',
      'background/',
      'sync/',
    ],
    forbidden: ['pages/', 'widgets/', 'layouts/', 'routing/', 'main.dart'],
    why: 'the data layer never reaches up into the UI',
  ),
  (
    from: ['actions/'],
    forbidden: ['pages/', 'widgets/', 'layouts/', 'routing/', 'main.dart'],
    why: 'actions run without a GUI too; the GUI calls them, not back',
  ),
  (
    from: ['pages/', 'widgets/', 'layouts/', 'routing/'],
    forbidden: [
      'database/entry_dao.dart', 'database/entry_image_dao.dart', //
      'database/entry_tag_dao.dart', 'database/tag_dao.dart',
      'database/tag_category_dao.dart', 'database/template_dao.dart',
      'database/template_tag_dao.dart'
    ],
    why: 'the UI reads and writes through stores, never DAOs',
  ),
  (
    from: ['widgets/'],
    forbidden: ['pages/'],
    why: 'shared widgets open screens through routing/',
  ),
  (
    from: ['utils/'],
    forbidden: ['pages/', 'widgets/', 'layouts/', 'routing/', 'main.dart'],
    why: 'helpers are shared by every layer, so they depend on no UI',
  ),
  (
    from: [''],
    forbidden: ['main.dart'],
    why: 'main.dart only starts the app; nothing depends on it',
  ),
];

final _directive = RegExp(r'''^(?:import|export)\s+['"]([^'"]+)['"]''');

/// What [uri], written in [file] (relative to lib/), names: a path under
/// lib/ for the app's own files, else the URI itself.
String _target(String file, String uri) {
  const own = 'package:aid_diary/';
  if (uri.startsWith(own)) return uri.substring(own.length);
  if (uri.contains(':')) return uri;
  return p.posix.normalize(p.posix.join(p.posix.dirname(file), uri));
}

bool _matches(String path, String pattern) =>
    pattern.endsWith('/') || pattern.startsWith('package:')
        ? path.startsWith(pattern)
        : path == pattern;

void main() {
  test('layers only depend downwards', () {
    final violations = <String>[];
    final lib = Directory('lib');
    for (final entity in lib.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final file =
          p.posix.joinAll(p.split(p.relative(entity.path, from: 'lib')));
      if (file.startsWith('l10n/generated/')) continue;
      for (final line in entity.readAsLinesSync()) {
        final match = _directive.firstMatch(line.trim());
        if (match == null) continue;
        final target = _target(file, match[1]!);
        for (final rule in _rules) {
          if (!rule.from.any(file.startsWith)) continue;
          if (rule.forbidden.any((pattern) => _matches(target, pattern)) &&
              target != file) {
            violations.add('lib/$file imports $target: ${rule.why}');
          }
        }
      }
    }
    expect(violations, isEmpty, reason: 'See docs/ARCHITECTURE.md.');
  });

  test('the rules catch what they are meant to', () {
    bool breaks(String file, String uri) => _rules.any((rule) =>
        rule.from.any(file.startsWith) &&
        rule.forbidden.any((pattern) => _matches(_target(file, uri), pattern)));
    expect(breaks('models/entry.dart', '../pages/search_page.dart'), isTrue);
    expect(breaks('models/entry.dart', 'package:material_ui/material_ui.dart'),
        isTrue);
    expect(
        breaks('database/entry_store.dart',
            'package:aid_diary/widgets/mood_icon.dart'),
        isTrue);
    expect(
        breaks('pages/search_page.dart',
            'package:aid_diary/database/entry_dao.dart'),
        isTrue);
    expect(
        breaks('widgets/top_search_card.dart',
            'package:aid_diary/pages/search_page.dart'),
        isTrue);
    expect(breaks('services/coach_service.dart', 'package:aid_diary/main.dart'),
        isTrue);
    expect(
        breaks('pages/search_page.dart',
            'package:aid_diary/database/entry_store.dart'),
        isFalse);
    expect(
        breaks('routing/app_navigation.dart',
            'package:aid_diary/pages/search_page.dart'),
        isFalse);
  });
}
