// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

// Everything the GUI can open, the command line can open too
// (docs/ARCHITECTURE.md, "Agent-native"): screens open only through the
// places in lib/routing/, which `ui.navigate` reaches.

import 'dart:io';

import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/routing/destinations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

/// Files outside lib/routing/ that may push a route themselves, and why
/// what they open is not a place of its own.
const Map<String, String> _notPlaces = {
  'pages/launch_page.dart': 'replaces itself with the app once it is ready',
  'pages/onboarding_page.dart': 'replaces itself with the app when done',
  'pages/share_page.dart': 'turns into the editor for what was shared',
  'pages/journal_page.dart':
      'takes what another app shares; the command line adds entries with '
          'entry.create',
  'pages/edit_entry_page.dart':
      'the full-screen text field is a mode of the editor (ui.navigate '
          'to=editor)',
  'widgets/location_dialog.dart':
      'the map is a step of picking a place inside the editor',
  'widgets/progress_dialog.dart': 'shows progress over the current screen',
};

final _routePush =
    RegExp(r'MaterialPageRoute\b|PageRouteBuilder\b|CupertinoPageRoute\b|'
        r'Navigator\.(?:of\([^)]*\)\.)?push\w*\(|[Nn]avigator\w*\.push\w*\(');
final _openPlace = RegExp(r'''openPlace\(\s*\w+,\s*'([^']+)'\s*[,)]''');

Iterable<(String, List<String>)> _sources() sync* {
  for (final entity in Directory('lib').listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    final file = p.posix.joinAll(p.split(p.relative(entity.path, from: 'lib')));
    if (file.startsWith('l10n/generated/')) continue;
    yield (file, entity.readAsLinesSync());
  }
}

void main() {
  test('only lib/routing/ opens screens', () {
    final pushes = <String>[];
    for (final (file, lines) in _sources()) {
      if (file.startsWith('routing/') || _notPlaces.containsKey(file)) {
        continue;
      }
      for (final (index, line) in lines.indexed) {
        final code = line.trimLeft();
        if (code.startsWith('//')) continue;
        if (_routePush.hasMatch(code)) {
          pushes.add('lib/$file:${index + 1}: ${code.trim()}');
        }
      }
    }
    expect(pushes, isEmpty,
        reason: 'Open it as a place in lib/routing/ so ui.navigate reaches '
            'it, or name in _notPlaces why it is not one.');
  });

  test('the places opened by name exist, once each', () {
    final names = [for (final place in destinations) place.name];
    expect(names.toSet(), hasLength(names.length));
    final unknown = <String>[];
    for (final (file, lines) in _sources()) {
      for (final match in _openPlace.allMatches(lines.join('\n'))) {
        if (!names.contains(match[1])) unknown.add('lib/$file: ${match[1]}');
      }
    }
    expect(unknown, isEmpty);
  });

  // One feature, one implementation (docs/ARCHITECTURE.md, "Shared
  // components"): a place's arguments say what to show, never switch parts
  // of the page on or off for one entry point.
  test('places take no on/off switches', () {
    final switches = [
      for (final place in destinations)
        for (final param in place.params)
          if (param.type == ParamType.boolean) '${place.name} ${param.name}',
    ];
    expect(switches, isEmpty,
        reason: 'A flag that shows part of a place to some callers makes '
            'two features out of one page: open the same page from every '
            'entry point, or give the other content its own place.');
  });

  test('the rule sees the ways to push a route', () {
    for (final code in [
      'Navigator.of(context).push(MaterialPageRoute(',
      'navigator.push(route);',
      'await Navigator.of(context, rootNavigator: true).push(PageRouteBuilder(',
      'Navigator.pushNamed(context, "x");',
      'Navigator.of(context).pushReplacement(x);',
    ]) {
      expect(_routePush.hasMatch(code), isTrue, reason: code);
    }
    for (final code in [
      'HomeWidgetService.push(snapshot);',
      "openPlace(context, 'settings');",
    ]) {
      expect(_routePush.hasMatch(code), isFalse, reason: code);
    }
  });
}
