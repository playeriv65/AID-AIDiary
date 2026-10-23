@Tags(['widget'])
library;

import 'package:aid_diary/widgets/known_extent_sliver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('mixed heights align at distant boundaries and after updates',
      (tester) async {
    final controller = ScrollController();
    final extents =
        ValueNotifier([for (var i = 0; i < 4000; i++) 40.0 + (i % 4) * 20]);
    addTearDown(controller.dispose);
    addTearDown(extents.dispose);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: ValueListenableBuilder<List<double>>(
        valueListenable: extents,
        builder: (context, heights, child) => CustomScrollView(
          controller: controller,
          slivers: [
            KnownExtentSliver(
                extents: heights,
                itemBuilder: (_, index) => ColoredBox(
                    key: ValueKey(index),
                    color: const Color(0xffeeeeee),
                    child: Text('Row $index')))
          ],
        ),
      ),
    )));
    await tester.pumpAndSettle();
    Future<void> check(int index, double within) async {
      final offset =
          extents.value.take(index).fold(0.0, (sum, height) => sum + height);
      controller.jumpTo(offset + within);
      await tester.pumpAndSettle();
      final rect = tester.getRect(find.byKey(ValueKey(index)));
      expect(rect.top, closeTo(-within, .001));
      expect(rect.height, extents.value[index]);
      expect(tester.takeException(), isNull);
    }

    for (final index in [1, 997, 2998]) {
      await check(index, 0);
      await check(index, .25);
    }
    final total = extents.value.fold(0.0, (sum, height) => sum + height);
    expect(controller.position.maxScrollExtent, total - 600);
    extents.value = [for (final height in extents.value) height * 2];
    await tester.pumpAndSettle();
    await check(1501, 0);
    expect(controller.position.maxScrollExtent, total * 2 - 600);
    extents.value = [];
    await tester.pumpAndSettle();
    expect(controller.position.maxScrollExtent, 0);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
