@Tags(['widget'])
library;

import 'package:aid_diary/layouts/mobile_scaffold.dart';
import 'package:aid_diary/models/image.dart';
import 'package:aid_diary/pages/entry_view_page.dart';
import 'package:aid_diary/providers/entry_images_provider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../support/diary_app_harness.dart';

/// What a screen reader finds on the main screens: every control says
/// what it is and that it is a button, and list items are things to read.
void main() {
  final harness = DiaryAppHarness()..register();

  /// The nodes a screen reader visits, with what it reads for each.
  List<SemanticsData> visited(WidgetTester tester) {
    final nodes = <SemanticsData>[];
    bool visit(SemanticsNode node) {
      if (!node.isMergedIntoParent) nodes.add(node.getSemanticsData());
      node.visitChildren(visit);
      return true;
    }

    visit(tester
        .binding.renderViews.first.owner!.semanticsOwner!.rootSemanticsNode!);
    return nodes;
  }

  void expectLabelledButtons(WidgetTester tester) {
    final controls = [
      for (final node in visited(tester))
        if (node.hasAction(SemanticsAction.tap)) node
    ];
    expect(controls, isNotEmpty);
    for (final node in controls) {
      expect(node.label.isNotEmpty || node.tooltip.isNotEmpty, isTrue,
          reason: 'unlabelled control $node');
      expect(node.flagsCollection.isButton, isTrue,
          reason: 'control without a role $node');
    }
  }

  /// The items of the list under [list]: each one has something to read.
  void expectReadableItems(WidgetTester tester, Finder list) {
    final items = <SemanticsData>[];
    bool visit(SemanticsNode node) {
      if (node.indexInParent != null) {
        items.add(node.getSemanticsData());
      } else {
        node.visitChildren(visit);
      }
      return true;
    }

    tester.getSemantics(list).visitChildren(visit);
    expect(items, isNotEmpty);
    for (final item in items) {
      expect(item.label, isNotEmpty, reason: 'silent list item $item');
    }
  }

  testWidgets('journal, media and entry controls are labelled buttons',
      (tester) async {
    final handle = tester.ensureSemantics();
    final now = DateTime.now();
    final entry =
        await DiaryAppHarness.addEntry(tester, '正文', now, title: '标题', mood: 3);
    await DiaryAppHarness.addEntry(tester, '同一天', now);
    await DiaryAppHarness.addEntry(
        tester, '昨天的', now.subtract(const Duration(days: 1)));
    await tester.runAsync(() async {
      for (final (rank, name) in [(0, 'a.jpg'), (1, 'clip.mp4')]) {
        await EntryImagesProvider.instance.add(EntryImage(
            entryId: entry.id, imgPath: name, imgRank: rank, timeCreate: now));
      }
    });
    DiaryAppHarness.size(tester, const Size(390, 844));
    await tester.pumpWidget(harness.app(const MobileScaffold()));
    await tester.pumpAndSettle();

    expectLabelledButtons(tester);
    expectReadableItems(tester, find.byKey(const ValueKey('journal-stories')));
    // A row reads as one button with its title, time and text.
    final row = tester
        .getSemantics(find.byKey(ValueKey('journal-entry-${entry.id}')))
        .getSemanticsData();
    expect(row.flagsCollection.isButton, isTrue);
    expect(row.hasAction(SemanticsAction.tap), isTrue);
    expect(row.label, matches(RegExp('标题.*正文', dotAll: true)));
    // A day is its date with one node per row under it, nothing between.
    final day = tester
        .getSemantics(find.byKey(ValueKey('journal-entry-${entry.id}')))
        .parent!;
    expect(day.label, contains(' · '));
    expect(day.childrenCount, 2);

    await DiaryAppHarness.goTo(tester, 1);
    expectLabelledButtons(tester);
    final tiles = visited(tester).where((node) => node.label.endsWith('的附件'));
    expect(tiles, hasLength(2));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(harness.app(EntryViewPage(entryId: entry.id!)));
    await tester.pumpAndSettle();
    expectLabelledButtons(tester);
    final photo = tester
        .getSemantics(find.byKey(const ValueKey('entry-attachment-0')))
        .getSemanticsData();
    expect(photo.flagsCollection.isButton, isTrue);
    expect(photo.label, endsWith('的附件'));

    await tester.pumpWidget(const SizedBox.shrink());
    handle.dispose();
  });
}
