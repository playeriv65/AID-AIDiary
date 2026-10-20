// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'package:aid_diary/database/app_database.dart';
import 'package:aid_diary/database/entry_image_dao.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/models/image.dart';
import 'package:material_ui/material_ui.dart';

class EntryImagesProvider with ChangeNotifier {
  static final EntryImagesProvider instance = EntryImagesProvider._init();

  EntryImagesProvider._init();

  List<EntryImage> _images = [];
  List<EntryImage> get images => _images;

  @visibleForTesting
  set images(List<EntryImage> value) {
    _images = value;
    _rebuildCache();
  }

  /// Each entry's images, highest rank first, so lookups while building
  /// pages do not scan every image.
  Map<int, List<EntryImage>> _byEntry = {};

  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  @visibleForTesting
  set isLoaded(bool value) => _isLoaded = value;

  void _rebuildCache() {
    final byEntry = <int, List<EntryImage>>{};
    for (final img in _images) {
      final id = img.entryId;
      if (id != null) byEntry.putIfAbsent(id, () => []).add(img);
    }
    for (final list in byEntry.values) {
      list.sort((a, b) => b.imgRank.compareTo(a.imgRank));
    }
    _byEntry = byEntry;
  }

  /// Load the provider's data from the app database
  Future<void> load() async {
    _images = await EntryImageDao.getAll();
    _rebuildCache();
    _isLoaded = true;
    notifyListeners();
  }

  // CRUD operations

  Future<void> add(EntryImage image, {skipUpdate = false}) async {
    final imageWithId = await EntryImageDao.add(image);
    _images.add(imageWithId);
    _rebuildCache();
    await AppDatabase.instance.updateExternalDatabase();
    if (!skipUpdate) {
      notifyListeners();
    }
  }

  Future<void> remove(EntryImage image) async {
    await EntryImageDao.remove(image);
    _images.removeWhere((x) => x.id == image.id);
    _rebuildCache();
    await AppDatabase.instance.updateExternalDatabase();
    notifyListeners();
  }

  Future<void> update(EntryImage image) async {
    await EntryImageDao.update(image);
    final index = _images.indexWhere((x) => x.id == image.id);
    _images[index] = image;
    _rebuildCache();
    await AppDatabase.instance.updateExternalDatabase();
    notifyListeners();
  }

  /// Replaces the cached images for [entryId] with rows already written
  /// elsewhere.
  void applyForEntry(int entryId, List<EntryImage> written) {
    _images = [
      ..._images.where((image) => image.entryId != entryId),
      ...written,
    ];
    _rebuildCache();
    notifyListeners();
  }

  EntryImage? getFirstImageForEntry(int entryId) =>
      _byEntry[entryId]?.firstOrNull;

  /// The images of [entry], highest rank first. Do not modify the list.
  List<EntryImage> getForEntry(Entry entry) => _byEntry[entry.id] ?? const [];
}
