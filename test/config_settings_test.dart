import 'dart:io';

import 'package:aid_diary/config_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Startup prunes config keys missing from Settings.all, so a setting left
  // out of it is forgotten on every restart.
  test('every declared setting is listed in Settings.all', () {
    final source = File('lib/config_provider.dart').readAsStringSync();
    final declared = RegExp(r'Setting<[^>]*>\(\s*"(\w+)"')
        .allMatches(source)
        .map((m) => m.group(1)!)
        .toSet();
    final listed = {for (final setting in Settings.all) setting.key};
    expect(declared.difference(listed), isEmpty);
  });
}
