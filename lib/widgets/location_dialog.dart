// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/config/app_config.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/services/location_service.dart';
import 'package:daily_you/time_manager.dart';
import 'package:material_ui/material_ui.dart';

/// The dialog's answer; a null [location] removes the entry's location.
typedef LocationChoice = ({EntryLocation? location});

/// Named places from [entries] (newest first), each name once.
List<EntryLocation> recentPlaces(List<Entry> entries, int limit) {
  final seen = <String>{};
  return [
    for (final entry in entries)
      if (entry.location case final place?)
        if (place.name case final name? when name.isNotEmpty)
          if (seen.add(name)) place,
  ].take(limit).toList();
}

/// Sets an entry's place from the device position or by name.
Future<LocationChoice?> showLocationDialog(
    BuildContext context, EntryLocation? current,
    {LocationService? service}) {
  return showDialog<LocationChoice>(
    context: context,
    builder: (_) => _LocationDialog(
        current: current, service: service ?? LocationService()),
  );
}

class _LocationDialog extends StatefulWidget {
  const _LocationDialog({required this.current, required this.service});
  final EntryLocation? current;
  final LocationService service;

  @override
  State<_LocationDialog> createState() => _LocationDialogState();
}

class _LocationDialogState extends State<_LocationDialog> {
  late final _name = TextEditingController(text: widget.current?.name ?? '');
  late double? _latitude = widget.current?.latitude;
  late double? _longitude = widget.current?.longitude;
  late final List<EntryLocation> _recent = recentPlaces(
      EntriesProvider.instance.entries, AppConfig.instance.recentPlacesLimit);
  bool _locating = false;
  bool _searching = false;
  List<PlaceMatch>? _matches;
  String? _error;

  String get _language => TimeManager.currentLocale(context).split('_').first;

  Future<void> _search() async {
    final query = _name.text.trim();
    if (query.isEmpty) return;
    setState(() {
      _searching = true;
      _error = null;
    });
    final matches = await widget.service.search(query, languageCode: _language);
    if (!mounted) return;
    setState(() {
      _searching = false;
      _matches = matches;
    });
  }

  void _pick(PlaceMatch match) => setState(() {
        _latitude = match.location.latitude;
        _longitude = match.location.longitude;
        _name.text = match.location.name ?? _name.text;
        _matches = null;
      });

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _locate() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _locating = true;
      _error = null;
      _matches = null;
    });
    try {
      final found = await widget.service.current(languageCode: _language);
      final name = found.name;
      if (!mounted) return;
      setState(() {
        _latitude = found.latitude;
        _longitude = found.longitude;
        if (name != null) _name.text = name;
      });
    } on LocationException catch (e) {
      if (!mounted) return;
      setState(() => _error = switch (e.reason) {
            LocationFailure.serviceDisabled => l10n.locationServiceDisabled,
            LocationFailure.permissionDenied => l10n.locationPermissionDenied,
            LocationFailure.unavailable => l10n.locationUnavailable,
          });
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final hasCoordinates = _latitude != null && _longitude != null;
    return AlertDialog(
      title: Text(l10n.locationTitle),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          key: const ValueKey('location-name'),
          controller: _name,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _search(),
          decoration: InputDecoration(
            labelText: l10n.locationName,
            prefixIcon: const Icon(Icons.place_outlined),
            suffixIcon: _searching
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2)))
                : IconButton(
                    key: const ValueKey('location-search'),
                    tooltip: l10n.locationSearchHint,
                    icon: const Icon(Icons.search_rounded),
                    onPressed: _search,
                  ),
          ),
        ),
        if (_matches == null && _recent.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l10n.locationRecent, style: theme.textTheme.labelMedium),
              const SizedBox(height: 4),
              Wrap(spacing: 6, runSpacing: 6, children: [
                for (final (index, place) in _recent.indexed)
                  ActionChip(
                    key: ValueKey('location-recent-$index'),
                    avatar: const Icon(Icons.history_rounded, size: 18),
                    label: Text(place.name!),
                    onPressed: () => _pick((location: place, detail: null)),
                  ),
              ]),
            ]),
          ),
        if (_matches case final matches?)
          if (matches.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(l10n.locationSearchEmpty,
                  style: theme.textTheme.bodySmall),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 240),
              // AlertDialog sizes by intrinsic width, which lists lack.
              child: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                for (final (index, match) in matches.indexed)
                  ListTile(
                    key: ValueKey('location-match-$index'),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.place_rounded),
                    title: Text(match.location.name ?? match.detail ?? ''),
                    subtitle: match.detail == null
                        ? null
                        : Text(match.detail!,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                    onTap: () => _pick(match),
                  ),
              ])),
            ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: Text(
                hasCoordinates
                    ? '${_latitude!.toStringAsFixed(5)}, ${_longitude!.toStringAsFixed(5)}'
                    : l10n.locationNoCoordinates,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ),
          if (_locating)
            const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2))
          else
            TextButton.icon(
              key: const ValueKey('location-current'),
              onPressed: _locate,
              icon: const Icon(Icons.my_location_rounded),
              label: Text(l10n.locationUseCurrent),
            ),
        ]),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(_error!,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.error)),
          ),
      ]),
      actions: [
        if (widget.current != null)
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop<LocationChoice>((location: null)),
            child: Text(l10n.locationRemove),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        FilledButton(
          key: const ValueKey('location-save'),
          onPressed: () {
            final location = EntryLocation(
                latitude: _latitude,
                longitude: _longitude,
                name: _name.text.trim().isEmpty ? null : _name.text.trim());
            Navigator.of(context).pop<LocationChoice>(
                (location: location.isEmpty ? null : location));
          },
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    );
  }
}
