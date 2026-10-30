@Tags(['widget'])
library;

import 'package:aid_diary/services/app_updates.dart';
import 'package:aid_diary/widgets/app_update_prompt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();

  final update = AppUpdate(
    version: '0.1.0',
    build: 261029205,
    notes: const {
      'en': ['Updates by themselves'],
      'zh': ['打开应用时会检查新版本'],
    },
    url: Uri.parse('https://aid.example/updates/aid-diary.apk'),
    sha256: '00',
    size: 1,
  );

  testWidgets('the update dialog speaks the app language, buttons in a row',
      (tester) async {
    // A phone held upright.
    DiaryAppHarness.size(tester, const Size(360, 800));
    await tester.pumpWidget(harness.app(Builder(
        builder: (context) => TextButton(
            onPressed: () => showUpdateDialog(context, update),
            child: const Text('open')))));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.textContaining('打开应用时会检查新版本'), findsOneWidget);
    expect(find.textContaining('Updates by themselves'), findsNothing);
    final rows = {
      for (final label in ['跳过此版本', '以后再说', '更新'])
        tester.getCenter(find.text(label)).dy,
    };
    expect(rows, hasLength(1));
    expect(tester.takeException(), isNull);
  });
}
