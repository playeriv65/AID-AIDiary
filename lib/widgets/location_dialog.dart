// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:math';

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/layouts/adaptive_diary_shell.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/providers/entries_provider.dart';
import 'package:aid_diary/services/location_service.dart';
import 'package:aid_diary/services/saved_places.dart';
import 'package:aid_diary/time_manager.dart';
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

/// Sets an entry's place, like Journey: a sheet that locates the device
/// right away and offers the result, the entry's place to rename or
/// remove, and "Pick a place" for searching, saved and nearby places.
Future<LocationChoice?> showLocationDialog(
    BuildContext context, EntryLocation? current,
    {LocationService? service}) {
  return showModalBottomSheet<LocationChoice>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) =>
        _LocationSheet(current: current, service: service ?? LocationService()),
  );
}

String _language(BuildContext context) =>
    TimeManager.currentLocale(context).split('_').first;

class _LocationSheet extends StatefulWidget {
  const _LocationSheet({required this.current, required this.service});
  final EntryLocation? current;
  final LocationService service;

  @override
  State<_LocationSheet> createState() => _LocationSheetState();
}

class _LocationSheetState extends State<_LocationSheet> {
  bool _started = false;
  bool _locating = true;
  EntryLocation? _here;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Needs the locale, so not in initState.
    if (!_started) {
      _started = true;
      _locate();
    }
  }

  Future<void> _locate() async {
    final l10n = AppLocalizations.of(context)!;
    final language = _language(context);
    String? error;
    EntryLocation? here;
    try {
      here = await widget.service.current(languageCode: language);
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
    if (!mounted) return;
    setState(() {
      _locating = false;
      _here = here;
      _error = error;
    });
  }

  void _choose(EntryLocation? location) =>
      Navigator.of(context).pop<LocationChoice>((location: location));

  Future<void> _rename(EntryLocation current) async {
    final name = await showDialog<String>(
        context: context, builder: (_) => _RenameDialog(name: current.name));
    if (name == null || !mounted) return;
    _choose(EntryLocation(
        latitude: current.latitude,
        longitude: current.longitude,
        name: name.isEmpty ? null : name));
  }

  Future<void> _pick() async {
    final picked = await _showPicker(context, widget.service, _here);
    if (picked != null && mounted) _choose(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final current = widget.current;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (current != null) ...[
                ListTile(
                  key: const ValueKey('location-entry'),
                  leading: const Icon(Icons.place_rounded),
                  title: Text(current.label),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    TextButton(
                      key: const ValueKey('location-rename'),
                      onPressed: () => _rename(current),
                      child: Text(l10n.locationRename),
                    ),
                    IconButton(
                      key: const ValueKey('location-remove'),
                      tooltip: l10n.locationRemove,
                      icon: const Icon(Icons.delete_outline_rounded),
                      onPressed: () => _choose(null),
                    ),
                  ]),
                ),
                const Divider(),
              ],
              if (_locating)
                ListTile(
                  leading: const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                  title: Text(l10n.locationLocating),
                )
              else if (_here case final here?)
                ListTile(
                  key: const ValueKey('location-current'),
                  leading: const Icon(Icons.my_location_rounded),
                  title: Text(here.label),
                  subtitle: Text(l10n.locationCurrent),
                  onTap: () => _choose(here),
                )
              else
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(_error ?? l10n.locationUnavailable,
                      style: theme.textTheme.titleMedium),
                ),
              ListTile(
                key: const ValueKey('location-pick'),
                leading: const Icon(Icons.travel_explore_rounded),
                title: Text(l10n.locationPickPlace,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600)),
                onTap: _pick,
              ),
            ]),
      ),
    );
  }
}

/// Full screen on phones, a dialog on wider windows.
Future<EntryLocation?> _showPicker(
    BuildContext context, LocationService service, EntryLocation? here) {
  final picker = _PlacePicker(service: service, here: here);
  final size = MediaQuery.sizeOf(context);
  if (!diarySupportsSplit(size)) {
    return Navigator.of(context).push(
        MaterialPageRoute(fullscreenDialog: true, builder: (_) => picker));
  }
  return showDialog<EntryLocation>(
    context: context,
    builder: (_) => Dialog(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
          width: min(560, size.width - 32),
          height: min(680, size.height - 48),
          child: picker),
    ),
  );
}

/// Search box over the places to choose from: the typed name as is, the
/// current position, saved places, search results, nearby places and the
/// places used lately.
class _PlacePicker extends StatefulWidget {
  const _PlacePicker({required this.service, required this.here});
  final LocationService service;
  final EntryLocation? here;

  @override
  State<_PlacePicker> createState() => _PlacePickerState();
}

class _PlacePickerState extends State<_PlacePicker> {
  final _query = TextEditingController();
  late final List<EntryLocation> _recent = recentPlaces(
      EntriesProvider.instance.entries, AppConfig.instance.recentPlacesLimit);
  List<EntryLocation> _saved = SavedPlaces.all();
  List<PlaceMatch>? _matches;
  List<PlaceMatch>? _nearby;
  bool _searching = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Needs the locale, so not in initState; runs once.
    final here = widget.here;
    if (_nearby == null && here != null && here.hasCoordinates) {
      _nearby = const [];
      widget.service
          .nearby(here.latitude!, here.longitude!,
              languageCode: _language(context))
          .then((places) {
        if (mounted) setState(() => _nearby = places);
      });
    }
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _query.text.trim();
    if (query.isEmpty) return;
    setState(() => _searching = true);
    final matches =
        await widget.service.search(query, languageCode: _language(context));
    if (!mounted) return;
    setState(() {
      _searching = false;
      _matches = matches;
    });
  }

  Future<void> _toggleSaved(EntryLocation place) async {
    await SavedPlaces.toggle(place);
    if (mounted) setState(() => _saved = SavedPlaces.all());
  }

  void _choose(EntryLocation place) => Navigator.of(context).pop(place);

  Widget _place(EntryLocation place,
      {required Key key, required IconData icon, String? detail}) {
    final l10n = AppLocalizations.of(context)!;
    final saved = _saved.contains(place);
    return ListTile(
      key: key,
      leading: Icon(icon),
      title: Text(place.label),
      subtitle: detail == null
          ? null
          : Text(detail, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: place.hasCoordinates
          ? IconButton(
              tooltip:
                  saved ? l10n.locationUnsavePlace : l10n.locationSavePlace,
              icon:
                  Icon(saved ? Icons.star_rounded : Icons.star_outline_rounded),
              onPressed: () => _toggleSaved(place),
            )
          : null,
      onTap: () => _choose(place),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final query = _query.text.trim();
    final here = widget.here;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          key: const ValueKey('location-name'),
          controller: _query,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _search(),
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
              hintText: l10n.locationPlacesHint, border: InputBorder.none),
        ),
        actions: [
          if (_searching)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else
            IconButton(
              key: const ValueKey('location-search'),
              tooltip: l10n.locationSearchHint,
              icon: const Icon(Icons.search_rounded),
              onPressed: _search,
            ),
        ],
      ),
      body: ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        if (query.isNotEmpty)
          ListTile(
            key: const ValueKey('location-custom'),
            leading: const Icon(Icons.edit_location_alt_outlined),
            title: Text(query),
            subtitle: Text(l10n.locationCustom),
            onTap: () => _choose(EntryLocation(name: query)),
          ),
        if (here != null) ...[
          _Header(l10n.locationCurrent),
          _place(here,
              key: const ValueKey('location-here'),
              icon: Icons.my_location_rounded),
        ],
        if (_saved.isNotEmpty) ...[
          _Header(l10n.locationSaved),
          for (final (index, place) in _saved.indexed)
            _place(place,
                key: ValueKey('location-saved-$index'),
                icon: Icons.star_rounded),
        ],
        if (_matches case final matches?) ...[
          _Header(l10n.locationSearchResults),
          if (matches.isEmpty)
            ListTile(title: Text(l10n.locationSearchEmpty))
          else
            for (final (index, match) in matches.indexed)
              _place(match.location,
                  key: ValueKey('location-match-$index'),
                  icon: Icons.place_rounded,
                  detail: match.detail),
        ],
        if (_nearby case final nearby? when nearby.isNotEmpty) ...[
          _Header(l10n.locationNearby),
          for (final (index, match) in nearby.indexed)
            _place(match.location,
                key: ValueKey('location-nearby-$index'),
                icon: Icons.near_me_outlined,
                detail: match.detail),
        ],
        if (_recent.isNotEmpty) ...[
          _Header(l10n.locationRecent),
          for (final (index, place) in _recent.indexed)
            _place(place,
                key: ValueKey('location-recent-$index'),
                icon: Icons.history_rounded),
        ],
      ]),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(text.toUpperCase(),
          style: theme.textTheme.labelMedium
              ?.copyWith(letterSpacing: 1.4, color: theme.colorScheme.primary)),
    );
  }
}

class _RenameDialog extends StatefulWidget {
  const _RenameDialog({required this.name});
  final String? name;

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  late final _name = TextEditingController(text: widget.name ?? '');

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final material = MaterialLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.locationRename),
      content: TextField(
        key: const ValueKey('location-rename-field'),
        controller: _name,
        autofocus: true,
        decoration: InputDecoration(hintText: l10n.locationPlacesHint),
        onSubmitted: (value) => Navigator.of(context).pop(value.trim()),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(material.cancelButtonLabel)),
        FilledButton(
            key: const ValueKey('location-rename-ok'),
            onPressed: () => Navigator.of(context).pop(_name.text.trim()),
            child: Text(material.okButtonLabel)),
      ],
    );
  }
}
