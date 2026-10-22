@Tags(['widget'])
library;

import 'package:aid_diary/config_provider.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/sync/local_device.dart';
import 'package:aid_diary/widgets/device_name_tile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import '../support/diary_app_harness.dart';

void main() {
  final harness = DiaryAppHarness()..register();
  testWidgets('a device can keep its default or save a name without a profile',
      (tester) async {
    expect(LocalDevice.name, isNotEmpty);
    final firstId = await LocalDevice.id();
    expect(await LocalDevice.id(), firstId);
    await tester
        .pumpWidget(harness.app(const Scaffold(body: DeviceNameTile())));
    await tester.tap(find.byKey(const ValueKey('sync-device-name')));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const ValueKey('sync-device-name-input')), '');
    await tester.tap(find.byKey(const ValueKey('sync-device-name-save')));
    await tester.pump();
    final l10n =
        AppLocalizations.of(tester.element(find.byType(DeviceNameTile)))!;
    expect(find.text(l10n.syncDeviceNameInvalid), findsOneWidget);
    await tester.enterText(
        find.byKey(const ValueKey('sync-device-name-input')), 'My tablet');
    await tester.tap(find.byKey(const ValueKey('sync-device-name-save')));
    await tester.pumpAndSettle();
    expect(ConfigProvider.instance.get(Settings.deviceName), 'My tablet');
    expect(find.text('My tablet'), findsOneWidget);
    expect(await LocalDevice.id(), firstId);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
