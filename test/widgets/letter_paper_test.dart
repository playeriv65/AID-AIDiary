// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

@Tags(['widget'])
library;

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/widgets/letter_paper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../support/config_provider_harness.dart';
import '../support/diary_app_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  useTemporaryConfig();
  testWidgets('paper ornaments stay behind content in light and dark modes',
      (tester) async {
    var taps = 0;
    for (final brightness in Brightness.values) {
      for (final decoration in ['none', 'botanical', 'stars', 'washi']) {
        await DiaryAppHarness.setSetting(Settings.paperStyle, 'lined');
        await DiaryAppHarness.setSetting(Settings.paperDecoration, decoration);
        await tester.pumpWidget(ChangeNotifierProvider.value(
            value: ConfigProvider.instance,
            child: MaterialApp(
                theme: ThemeData(brightness: brightness),
                home: Scaffold(
                    body: LetterPaper(
                        child: Center(
                            child: TextButton(
                                onPressed: () => taps++,
                                child: const Text('Write'))))))));
        await tester.tap(find.text('Write'));
        await tester.pump();
        expect(tester.takeException(), isNull);
      }
    }
    expect(taps, 8);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
