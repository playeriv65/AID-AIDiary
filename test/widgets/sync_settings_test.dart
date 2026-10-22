@Tags(['widget'])
library;

import 'dart:convert';
import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/pages/settings/sync_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();
  testWidgets(
      'everyday sync shows its result and keeps account controls inside',
      (tester) async {
    DiaryAppHarness.size(tester, const Size(800, 1000));
    await DiaryAppHarness.setSetting(
        Settings.syncTarget,
        jsonEncode({
          'type': 'webdav',
          'server': 'https://example.org/dav/',
          'username': 'storage-account',
          'spaceId': 'test-space'
        }));
    await DiaryAppHarness.setSetting(Settings.lastSync, '2026-10-22T12:00:00Z');
    await tester.pumpWidget(harness.app(const SyncSettings()));
    await tester.pumpAndSettle();
    final l10n =
        AppLocalizations.of(tester.element(find.byType(SyncSettings)))!;
    expect(find.text(l10n.syncAllSynced), findsOneWidget);
    expect(find.textContaining('storage-account'), findsNothing);
    await tester.tap(find.byKey(const ValueKey('sync-more')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('sync-change-recovery')), findsOneWidget);
    expect(find.textContaining('storage-account'), findsOneWidget);
    expect(find.byKey(const ValueKey('nearby-migration-settings')),
        findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
