// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/config/app_config.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/pages/entry_view_page.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/utils/entry_navigation.dart';
import 'package:daily_you/widgets/list_detail_layout.dart';
import 'package:daily_you/widgets/top_search_card.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// Entries with coordinates as markers on a map.
class AtlasPage extends StatefulWidget {
  const AtlasPage({super.key, this.tileProvider});

  /// Overrides tile loading, for tests.
  final TileProvider? tileProvider;

  @override
  State<AtlasPage> createState() => _AtlasPageState();
}

class _AtlasPageState extends State<AtlasPage>
    with AutomaticKeepAliveClientMixin {
  final MapController _controller = MapController();
  int? _selectedId;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static List<Entry> geotagged() => EntriesProvider.instance.entries
      .where((e) => e.location?.hasCoordinates ?? false)
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
            tileProvider: widget.tileProvider,
          ),
          MarkerLayer(markers: [
            for (final entry in entries)
              Marker(
                point: _point(entry),
                width: 44,
                height: 44,
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  key: ValueKey('atlas-marker-${entry.id}'),
                  onTap: () => split
                      ? setState(() => _selectedId = entry.id)
                      : EntryNavigation.view(context, entry,
                          entries: geotagged),
                  child: Icon(Icons.location_on_rounded,
                      size: 44,
                      color:
                          entry.id == _selectedId ? cs.tertiary : cs.primary),
                ),
              ),
          ]),
          RichAttributionWidget(attributions: [
            TextSourceAttribution(config.mapAttribution,
                onTap: () => launchUrl(Uri.parse(config.mapAttributionUrl))),
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
        )
      else
        PositionedDirectional(
          end: 16,
          // Phones keep the new-entry button in that corner.
          bottom: split ? 16 : 88,
          child: FloatingActionButton.small(
            key: const ValueKey('atlas-fit'),
            heroTag: 'atlas-fit',
            tooltip: l10n.atlasShowAll,
            onPressed: () => _fitAll(entries),
            child: const Icon(Icons.fit_screen_rounded),
          ),
        ),
    ]);
  }
}
