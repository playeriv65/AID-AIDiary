// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:ui';

/// Groups items whose projected positions lie within [radius] of a cluster's
/// first item. Order is kept, so clusters stay stable while the map moves.
List<List<T>> clusterByDistance<T>(
    Iterable<T> items, Offset Function(T item) project, double radius) {
  final leaders = <Offset>[];
  final clusters = <List<T>>[];
  for (final item in items) {
    final position = project(item);
    final index =
        leaders.indexWhere((leader) => (leader - position).distance < radius);
    if (index == -1) {
      leaders.add(position);
      clusters.add([item]);
    } else {
      clusters[index].add(item);
    }
  }
  return clusters;
}
