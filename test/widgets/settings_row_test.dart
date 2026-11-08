@Tags(['widget'])
library;

import 'package:aid_diary/widgets/settings_row.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Widget row({required bool busy}) => MaterialApp(
      home: Scaffold(
          body: SettingsRow(
              icon: Icons.sync_rounded, title: 'Sync', busy: busy)));

  testWidgets('a busy row shows progress where its icon was', (tester) async {
    await tester.pumpWidget(row(busy: true));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byIcon(Icons.sync_rounded), findsNothing);

    await tester.pumpWidget(row(busy: false));
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byIcon(Icons.sync_rounded), findsOneWidget);
  });
}
