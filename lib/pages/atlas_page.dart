// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/pages/entry_view_page.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/services/location_service.dart';
import 'package:aid_diary/utils/entry_navigation.dart';
import 'package:aid_diary/utils/map_clusters.dart';
import 'package:aid_diary/widgets/list_detail_layout.dart';
import 'package:aid_diary/widgets/top_search_card.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// Entries with coordinates as markers on a map.
class AtlasPage extends StatefulWidget {
  const AtlasPage({super.key});

  /// Replaces tile loading in tests, which reach the page through the app
  /// shell and must not start the network tile cache.
  @visibleForTesting
  static TileProvider? tileProviderOverride;

  @override
  State<AtlasPage> createState() => _AtlasPageState();
}

class _AtlasPageState extends State<AtlasPage>
    with AutomaticKeepAliveClientMixin {
  final MapController _controller = MapController();
  int? _selectedId;

  /// The device position, once location access is granted.
  LatLng? _here;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Opening the map is the moment to ask for location access; an empty map
    // then starts where the user is.
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _locate(move: geotagged().isEmpty, report: false));
  }

  /// Finds the device; [report] says why it failed, for an explicit tap.
  Future<void> _locate({required bool move, required bool report}) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    String? error;
    try {
      final here = await LocationService().position();
      if (!mounted) return;
      setState(() => _here = here);
      if (move) _controller.move(here, AppConfig.instance.mapEntryZoom);
    } on LocationException catch (e) {
      error = switch (e.reason) {
        LocationFailure.serviceDisabled => l10n.locationServiceDisabled,
        LocationFailure.permissionDenied => l10n.locationPermissionDenied,
        LocationFailure.unavailable => l10n.locationUnavailable,
      };
    } catch (_) {
      // No location support on this platform.
      error = l10n.locationUnavailable;
    }
    if (report && error != null) {
      messenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static List<Entry> geotagged() => EntriesProvider.instance.entries
      .where((e) => !e.isSealed && (e.location?.hasCoordinates ?? false))
      .toList();

  static LatLng _point(Entry entry) =>
      LatLng(entry.location!.latitude!, entry.location!.longitude!);

  void _fitAll(List<Entry> entries) {
    if (entries.isEmpty) return;
    _controller.fitCamera(CameraFit.coordinates(
      coordinates: entries.map(_point).toList(),
      padding: const EdgeInsets.fromLTRB(48, 120, 48, 48),
      maxZoom: AppConfig.instance.mapEntryZoom,
    ));
  }

  void _open(BuildContext context, Entry entry,
      {required bool split, List<Entry> Function()? entries}) {
    if (split) {
      setState(() => _selectedId = entry.id);
    } else {
      EntryNavigation.view(context, entry, entries: entries ?? geotagged);
    }
  }

  /// Zooms into a cluster; one that cannot split further opens its entries.
  void _openCluster(BuildContext context, List<Entry> cluster,
      {required bool split}) {
    final points = cluster.map(_point).toSet();
    final maxZoom = AppConfig.instance.mapMaxZoom;
    if (points.length == 1 || _controller.camera.zoom >= maxZoom) {
      _open(context, cluster.first, split: split, entries: () => cluster);
      return;
    }
    _controller.fitCamera(CameraFit.coordinates(
      coordinates: points.toList(),
      padding: const EdgeInsets.fromLTRB(48, 120, 48, 48),
      maxZoom: maxZoom,
    ));
  }

  Marker _entryMarker(BuildContext context, Entry entry,
      {required bool split}) {
    final cs = Theme.of(context).colorScheme;
    return Marker(
      point: _point(entry),
      width: 44,
      height: 44,
      alignment: Alignment.topCenter,
      child: GestureDetector(
        key: ValueKey('atlas-marker-${entry.id}'),
        onTap: () => _open(context, entry, split: split),
        child: Icon(Icons.location_on_rounded,
            size: 44,
            color: entry.id == _selectedId ? cs.tertiary : cs.primary),
      ),
    );
  }

  Marker _clusterMarker(BuildContext context, List<Entry> cluster,
      {required bool split}) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final points = cluster.map(_point);
    final center = LatLng(
        points.map((p) => p.latitude).reduce((a, b) => a + b) / cluster.length,
        points.map((p) => p.longitude).reduce((a, b) => a + b) /
            cluster.length);
    final selected = cluster.any((e) => e.id == _selectedId);
    return Marker(
      point: center,
      width: 48,
      height: 48,
      child: GestureDetector(
        key: ValueKey('atlas-cluster-${cluster.first.id}'),
        onTap: () => _openCluster(context, cluster, split: split),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? cs.tertiary : cs.primary,
            border: Border.all(color: cs.surface, width: 3),
            boxShadow: [
              BoxShadow(color: cs.shadow.withValues(alpha: .25), blurRadius: 6)
            ],
          ),
          child: Center(
            child: Text('${cluster.length}',
                style: theme.textTheme.titleSmall?.copyWith(
                    color: selected ? cs.onTertiary : cs.onPrimary,
                    fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    context.watch<EntriesProvider>();
    final entries = geotagged();
    final selected = entries.any((e) => e.id == _selectedId);
    return ListDetailLayout(
      detail: selected
          ? EntryViewPage(
              key: ValueKey('atlas-detail-$_selectedId'),
              entryId: _selectedId!,
              embedded: true)
          : null,
      listBuilder: (context, split) => _map(context, entries, split: split),
    );
  }

  Widget _map(BuildContext context, List<Entry> entries,
      {required bool split}) {
    final config = AppConfig.instance;
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    return Stack(children: [
      FlutterMap(
        key: const ValueKey('atlas-map'),
        mapController: _controller,
        options: MapOptions(
          initialCenter:
              entries.isEmpty ? const LatLng(20, 0) : _point(entries.first),
          initialZoom:
              entries.isEmpty ? config.mapDefaultZoom : config.mapEntryZoom - 3,
          maxZoom: config.mapMaxZoom,
          onMapReady: () => _fitAll(entries),
        ),
        children: [
          TileLayer(
            urlTemplate: config.tileUrlTemplate,
            userAgentPackageName: config.userAgentPackageName,
            tileProvider: AtlasPage.tileProviderOverride,
          ),
          // Reads the camera, so clusters regroup as the map zooms.
          Builder(builder: (context) {
            final camera = MapCamera.of(context);
            final clusters = clusterByDistance(
                entries,
                (entry) => camera.projectAtZoom(_point(entry)),
                config.mapClusterRadius);
            return MarkerLayer(markers: [
              if (_here case final here?)
                Marker(
                  point: here,
                  width: 22,
                  height: 22,
                  child: DecoratedBox(
                    key: const ValueKey('atlas-here'),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cs.secondary,
                      border: Border.all(color: cs.surface, width: 3),
                    ),
                  ),
                ),
              for (final cluster in clusters)
                if (cluster.length == 1)
                  _entryMarker(context, cluster.single, split: split)
                else
                  _clusterMarker(context, cluster, split: split),
            ]);
          }),
          // Bottom left, clear of the fit button.
          RichAttributionWidget(
              alignment: AttributionAlignment.bottomLeft,
              attributions: [
                TextSourceAttribution(config.mapAttribution,
                    onTap: () =>
                        launchUrl(Uri.parse(config.mapAttributionUrl))),
              ]),
        ],
      ),
      const Positioned(top: 16, left: 16, right: 16, child: TopSearchCard()),
      if (entries.isEmpty)
        Center(
          child: IgnorePointer(
            child: Card(
              color: cs.surface.withValues(alpha: .9),
              child: EmptyState(
                  icon: Icons.map_outlined,
                  title: l10n.atlasEmpty,
                  hint: l10n.atlasEmptyHint),
            ),
          ),
        ),
      PositionedDirectional(
        end: 16,
        // Phones keep the new-entry button in that corner.
        bottom: split ? 16 : 88,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          FloatingActionButton.small(
            key: const ValueKey('atlas-locate'),
            heroTag: 'atlas-locate',
            tooltip: l10n.atlasMyLocation,
            onPressed: () => _locate(move: true, report: true),
            child: const Icon(Icons.my_location_rounded),
          ),
          if (entries.isNotEmpty) ...[
            const SizedBox(height: 8),
            FloatingActionButton.small(
              key: const ValueKey('atlas-fit'),
              heroTag: 'atlas-fit',
              tooltip: l10n.atlasShowAll,
              onPressed: () => _fitAll(entries),
              child: const Icon(Icons.fit_screen_rounded),
            ),
          ],
        ]),
      ),
    ]);
  }
}
