@Tags(['widget'])
library;

import 'package:aid_diary/pages/settings/sync_copy_settings.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();
  testWidgets('named last-confirmed copies distinguish missing and older data',
      (tester) async {
    DiaryAppHarness.size(tester, const Size(800, 1000));
    await tester.pumpWidget(harness.app(SyncCopySettings(
        load: () async => {
              'devices': [
                {
                  'name': 'My tablet',
                  'present': 2,
                  'total': 2,
                  'current': true,
                  'checkedAt': '2026-10-22T12:00:00Z'
                },
                {
                  'name': 'My phone',
                  'present': 1,
                  'total': 2,
                  'current': true,
                  'checkedAt': '2026-10-22T12:00:00Z'
                },
                {
                  'name': 'Old laptop',
                  'present': 2,
                  'total': 2,
                  'current': false,
                  'checkedAt': '2026-10-20T12:00:00Z'
                },
              ],
              'storage': 'webdav',
              'storageHost': 'example.org',
              'temporaryStorage': true,
            })));
    await tester.pumpAndSettle();
    expect(find.text('My tablet'), findsOneWidget);
    final l10n =
        AppLocalizations.of(tester.element(find.byType(SyncCopySettings)))!;
    expect(find.textContaining(l10n.syncCopyComplete), findsOneWidget);
    expect(find.textContaining(l10n.syncCopyPartial), findsOneWidget);
    expect(find.textContaining(l10n.syncCopyOlder), findsOneWidget);
    expect(find.text(l10n.syncCopyTemporary), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
