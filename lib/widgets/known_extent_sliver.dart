// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A lazy list whose known heights support constant-time index offsets and
/// logarithmic offset lookup. Flutter's varied-extent list scans preceding
/// heights repeatedly during layout, even when no skipped widgets are built.
class KnownExtentSliver extends SliverMultiBoxAdaptorWidget {
  KnownExtentSliver(
      {super.key,
      required this.extents,
      required NullableIndexedWidgetBuilder itemBuilder})
      : super(
            delegate: SliverChildBuilderDelegate(itemBuilder,
                childCount: extents.length));

  final List<double> extents;

  @override
  RenderKnownExtentSliver createRenderObject(BuildContext context) =>
      RenderKnownExtentSliver(
          childManager: context as SliverMultiBoxAdaptorElement,
          extents: extents);

  @override
  void updateRenderObject(
      BuildContext context, RenderKnownExtentSliver renderObject) {
    renderObject.extents = extents;
  }
}

class RenderKnownExtentSliver extends RenderSliverFixedExtentBoxAdaptor {
  RenderKnownExtentSliver(
      {required super.childManager, required List<double> extents}) {
    this.extents = extents;
  }

  List<double> _extents = const [];
  List<double> _offsets = const [0];
  set extents(List<double> value) {
    if (identical(value, _extents)) return;
    _extents = value;
    final offsets = <double>[0];
    for (final extent in value) {
      assert(extent > 0 && extent.isFinite);
      offsets.add(offsets.last + extent);
    }
    _offsets = offsets;
    markNeedsLayout();
  }

  @override
  double? get itemExtent => null;

  @override
  ItemExtentBuilder get itemExtentBuilder => _extentAt;

  double? _extentAt(int index, SliverLayoutDimensions _) =>
      index < _extents.length ? _extents[index] : null;

  int _indexFor(double offset, {required bool includeBoundary}) {
    var low = 0;
    var high = _offsets.length;
    while (low < high) {
      final mid = (low + high) ~/ 2;
      if (_offsets[mid] < offset ||
          (includeBoundary && _offsets[mid] == offset)) {
        low = mid + 1;
      } else {
        high = mid;
      }
    }
    return math.max(0, math.min(low - 1, _extents.length - 1));
  }

  @override
  double indexToLayoutOffset(double itemExtent, int index) => _offsets[index];

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset, double itemExtent) =>
      _indexFor(scrollOffset + precisionErrorTolerance, includeBoundary: true);

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset, double itemExtent) =>
      _indexFor(scrollOffset - precisionErrorTolerance, includeBoundary: false);

  @override
  double computeMaxScrollOffset(
          SliverConstraints constraints, double itemExtent) =>
      _offsets.last;

  @override
  double estimateMaxScrollOffset(SliverConstraints constraints,
          {int? firstIndex,
          int? lastIndex,
          double? leadingScrollOffset,
          double? trailingScrollOffset}) =>
      _offsets.last;
}
