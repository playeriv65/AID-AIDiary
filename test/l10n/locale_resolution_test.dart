import 'package:aid_diary/l10n/locale_resolution.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final cases = <List<Locale>, Locale>{
    []: const Locale('en'),
    [const Locale('xx')]: const Locale('en'),
    [const Locale('xx'), const Locale('ja')]: const Locale('ja'),
    [const Locale('en', 'GB')]: const Locale('en'),
    [const Locale('pt', 'BR')]: const Locale('pt', 'BR'),
    [const Locale('pt', 'PT')]: const Locale('pt'),
    [const Locale('zh', 'CN')]: const Locale('zh'),
    [const Locale('zh', 'SG')]: const Locale('zh'),
    [const Locale('zh', 'TW')]:
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    [const Locale('zh', 'HK')]:
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    [const Locale('zh', 'MO')]:
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    [const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')]:
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    [
      const Locale.fromSubtags(
          languageCode: 'zh', scriptCode: 'Hans', countryCode: 'TW')
    ]: const Locale('zh'),
  };

  test('missing platform locale defaults to English', () {
    expect(resolveAppLocale(null, appSupportedLocales), const Locale('en'));
  });

  for (final entry in cases.entries) {
    test('resolves ${entry.key} to ${entry.value}', () {
      expect(resolveAppLocale(entry.key, appSupportedLocales), entry.value);
    });
  }
}
