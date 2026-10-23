import 'dart:convert';
import 'dart:io';

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, String> messages(File file) {
  final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  return {
    for (final entry in json.entries)
      if (!entry.key.startsWith('@')) entry.key: entry.value as String,
  };
}

Set<String> arguments(String message) =>
    RegExp(r'\{\s*([A-Za-z_][A-Za-z0-9_]*)\s*(?:\}|,)')
        .allMatches(message)
        .map((match) => match.group(1)!)
        .toSet();

void main() {
  final template = messages(File('lib/l10n/intl_en.arb'));
  final files = Directory('lib/l10n')
      .listSync()
      .whereType<File>()
      .where((file) => file.path.endsWith('.arb'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  for (final file in files) {
    test('${file.path} covers every message and preserves arguments', () {
      final translated = messages(file);
      expect(template.keys.toSet().difference(translated.keys.toSet()), isEmpty,
          reason: 'Every offered locale needs its own translation.');
      for (final entry in template.entries) {
        final value = translated[entry.key]!;
        expect(value.trim(), isNotEmpty, reason: entry.key);
        expect(arguments(value), arguments(entry.value), reason: entry.key);
      }
    });
  }

  for (final locale in AppLocalizations.supportedLocales) {
    test('$locale renders counts and cloud allowances with their values',
        () async {
      final l10n = await AppLocalizations.delegate.load(locale);
      expect(l10n.syncReceiving(123, 456),
          allOf(contains('123'), contains('456')));
      expect(l10n.cloudTrafficSummary('128 MB', '1 GB'),
          allOf(contains('128 MB'), contains('1 GB')));
      expect(l10n.deleteTagMessage(42, 'TestTag'), contains('TestTag'));
      expect(l10n.deleteTagMessage(0, 'TestTag'), isNot(contains('0')));
      for (final count in [0, 1, 2, 5, 11, 42, 101]) {
        expect(l10n.logCount(count).trim(), isNotEmpty);
      }
    });
  }

  test('Russian day counts use the singular form again at 21', () async {
    final l10n = await AppLocalizations.delegate.load(AppLocalizations
        .supportedLocales
        .firstWhere((locale) => locale.languageCode == 'ru'));
    expect(l10n.coachDurationDays(1), '1 день');
    expect(l10n.coachDurationDays(2), '2 дня');
    expect(l10n.coachDurationDays(5), '5 дней');
    expect(l10n.coachDurationDays(21), '21 день');
  });

  test('Arabic day counts distinguish singular, dual and plural', () async {
    final l10n = await AppLocalizations.delegate.load(AppLocalizations
        .supportedLocales
        .firstWhere((locale) => locale.languageCode == 'ar'));
    expect(l10n.coachDurationDays(1), 'يوم واحد');
    expect(l10n.coachDurationDays(2), 'يومان');
    expect(l10n.coachDurationDays(3), '3 أيام');
    expect(l10n.coachDurationDays(11), '11 يومًا');
  });
}
