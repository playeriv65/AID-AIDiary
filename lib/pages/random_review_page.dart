// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:math';

import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/pages/entry_view_page.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/providers/entry_images_provider.dart';
import 'package:daily_you/widgets/list_detail_layout.dart';
import 'package:material_ui/material_ui.dart';

/// Which entries a random walk draws from.
enum RandomFilter { all, photos, goodDays }

/// Deals entries in a shuffled order so none repeats until all were shown.
class RandomDeck {
  RandomDeck(this._random);

  final Random _random;
  final List<int> _queue = [];

  /// The next entry id among [ids], or null when there are none.
  int? next(List<int> ids, {int? avoid}) {
    _queue.removeWhere((id) => !ids.contains(id));
    if (_queue.isEmpty) {
      _queue.addAll(List.of(ids)..shuffle(_random));
      // A fresh round should not open on the entry just shown.
      if (_queue.length > 1 && _queue.first == avoid) {
        _queue.add(_queue.removeAt(0));
      }
    }
    return _queue.isEmpty ? null : _queue.removeAt(0);
  }
}

/// One random past entry at a time, like flipping through an old diary.
class RandomReviewPage extends StatefulWidget {
  const RandomReviewPage({super.key, this.random});

  /// Overrides the shuffle, for tests.
  final Random? random;

  static Future<void> open(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute(
          allowSnapshotting: false, builder: (_) => const RandomReviewPage()));

  @override
  State<RandomReviewPage> createState() => _RandomReviewPageState();
}

class _RandomReviewPageState extends State<RandomReviewPage> {
  late final _deck = RandomDeck(widget.random ?? Random());
  RandomFilter _filter = RandomFilter.all;
  int? _entryId;

  @override
  void initState() {
    super.initState();
    _shuffle();
  }

  bool _matches(Entry entry) =>
      !entry.isSealed &&
      switch (_filter) {
        RandomFilter.all => true,
        RandomFilter.photos => EntryImagesProvider.instance
            .getForEntry(entry)
            .any((image) => image.isImage),
        RandomFilter.goodDays => (entry.mood ?? -3) >= 1,
      };

  void _shuffle() {
    final ids = [
      for (final entry in EntriesProvider.instance.entries)
        if (_matches(entry)) entry.id!,
    ];
    setState(() => _entryId = _deck.next(ids, avoid: _entryId));
  }

  void _setFilter(RandomFilter filter) {
    _filter = filter;
    _entryId = null;
    _shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final id = _entryId;
    return Scaffold(
      body: id == null
          ? Scaffold(
              appBar: AppBar(title: Text(l10n.randomTitle)),
              body: EmptyState(
                  icon: Icons.shuffle_rounded, title: l10n.randomEmpty))
          : EntryViewPage(key: ValueKey('random-$id'), entryId: id),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Row(children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  for (final (filter, label) in [
                    (RandomFilter.all, l10n.randomAll),
                    (RandomFilter.photos, l10n.randomWithPhotos),
                    (RandomFilter.goodDays, l10n.randomGoodDays),
                  ])
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        key: ValueKey('random-filter-${filter.name}'),
                        label: Text(label),
                        selected: _filter == filter,
                        onSelected: (_) => _setFilter(filter),
                      ),
                    ),
                ]),
              ),
            ),
            FilledButton.icon(
              key: const ValueKey('random-next'),
              onPressed: _shuffle,
              icon: const Icon(Icons.shuffle_rounded),
              label: Text(l10n.randomNext),
            ),
          ]),
        ),
      ),
    );
  }
}
