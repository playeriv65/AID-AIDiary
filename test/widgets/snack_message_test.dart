@Tags(['widget'])
library;

import 'package:aid_diary/widgets/snack_message.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Future<void> show(WidgetTester tester,
      {SnackBarAction? action, bool accessibleNavigation = false}) async {
    await tester.pumpWidget(MaterialApp(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(accessibleNavigation: accessibleNavigation),
            child: child!),
        home: Scaffold(
            body: Builder(
                builder: (context) => TextButton(
                    onPressed: () =>
                        showSnackMessage(context, 'Updated', action: action),
                    child: const Text('show'))))));
    await tester.tap(find.text('show'));
    await tester.pumpAndSettle();
    expect(find.text('Updated'), findsOneWidget);
  }

  testWidgets('a message goes away by itself', (tester) async {
    await show(tester);
    await tester.pump(snackMessageDuration);
    await tester.pumpAndSettle();
    expect(find.text('Updated'), findsNothing);
  });

  testWidgets('a message with an action goes away by itself, a little later',
      (tester) async {
    await show(tester,
        action: SnackBarAction(label: "What's new", onPressed: () {}));
    await tester.pump(snackMessageDuration);
    await tester.pumpAndSettle();
    expect(find.text('Updated'), findsOneWidget);
    await tester.pump(snackActionDuration - snackMessageDuration);
    await tester.pumpAndSettle();
    expect(find.text('Updated'), findsNothing);
  });

  // Android's embedding sets accessibleNavigation for the rest of the
  // session once any accessibility service queries a node, ad skippers too.
  testWidgets(
      'a message with an action still goes away under accessible '
      'navigation', (tester) async {
    await show(tester,
        action: SnackBarAction(label: "What's new", onPressed: () {}),
        accessibleNavigation: true);
    await tester.pump(snackActionDuration);
    await tester.pumpAndSettle();
    expect(find.text('Updated'), findsNothing);
  });
}
