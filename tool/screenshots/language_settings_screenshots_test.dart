// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/pages/settings/appearance_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import '../../test/support/screenshot_session.dart';

void main() {
  final session = screenshotSession();
  for (final (name, size) in [
    ('phone', const Size(360, 800)),
    ('tablet', const Size(1280, 800)),
  ]) {
    testWidgets('direct app language selector $name', (tester) async {
      await session.start(tester, size);
      final navigator =
          Navigator.of(tester.element(find.byType(Scaffold).first));
      navigator.push(
          MaterialPageRoute<void>(builder: (_) => const AppearanceSettings()));
      await tester.pumpAndSettle();
      final field = find.byKey(const ValueKey('settings-app-language'));
      await tester.scrollUntilVisible(field, 500,
          scrollable: find.byType(Scrollable).last);
      await tester.pumpAndSettle();
      await session.capture(tester, '$name-language-setting');
      await session.finish(tester);
    });
  }
}
