// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/layouts/mobile_scaffold.dart';
import 'package:aid_diary/pages/onboarding_page.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test/support/screenshot_session.dart';

void main() {
  final session = screenshotSession();
  for (final (device, size) in [
    ('phone', const Size(390, 844)),
    ('tablet', const Size(1280, 800)),
  ]) {
    testWidgets('first run and tutorial $device', (tester) async {
      await session.start(tester, size);
      final context = tester.element(find.byType(MobileScaffold));
      Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => const OnboardingPage(next: MobileScaffold()),
      ));
      await tester.pumpAndSettle();
      await session.capture(tester, '$device-first-start');
      await tester.tap(find.byKey(const ValueKey('onboard-new-diary')));
      await tester.pumpAndSettle();
      await session.capture(tester, '$device-tutorial');
      await session.finish(tester);
    });
  }
}
