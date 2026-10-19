// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/services/location_service.dart';
import 'package:daily_you/time_manager.dart';
import 'package:material_ui/material_ui.dart';

/// The dialog's answer; a null [location] removes the entry's location.
typedef LocationChoice = ({EntryLocation? location});

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
  bool _locating = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _locate() async {
    final l10n = AppLocalizations.of(context)!;
    final language = TimeManager.currentLocale(context).split('_').first;
    setState(() {
      _locating = true;
      _error = null;
    });
    try {
      final found = await widget.service.current(languageCode: language);
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
          decoration: InputDecoration(
              labelText: l10n.locationName,
              prefixIcon: const Icon(Icons.place_outlined)),
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
