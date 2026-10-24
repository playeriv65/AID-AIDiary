// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/services/weather_service.dart';
import 'package:aid_diary/utils/entry_context_display.dart';
import 'package:aid_diary/widgets/weather_icon.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

/// The answer of a context dialog; a null value removes it from the entry.
typedef WeatherChoice = ({EntryWeather? weather});

/// Shows the entry's weather and fetches it for its place and time.
Future<WeatherChoice?> showWeatherDialog(BuildContext context,
    EntryWeather? current, EntryLocation? location, DateTime time,
    {WeatherService? service}) {
  return showDialog<WeatherChoice>(
    context: context,
    builder: (_) => _WeatherDialog(
        current: current,
        location: location,
        time: time,
        service: service ?? WeatherService()),
  );
}

class _WeatherDialog extends StatefulWidget {
  const _WeatherDialog(
      {required this.current,
      required this.location,
      required this.time,
      required this.service});
  final EntryWeather? current;
  final EntryLocation? location;
  final DateTime time;
  final WeatherService service;

  @override
  State<_WeatherDialog> createState() => _WeatherDialogState();
}

class _WeatherDialogState extends State<_WeatherDialog> {
  late EntryWeather? _weather = widget.current;
  bool _loading = false;
  String? _error;

  Future<void> _fetch() async {
    final location = widget.location!;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _loading = true;
      _error = null;
    });
    final weather = await widget.service
        .at(location.latitude!, location.longitude!, widget.time);
    if (!mounted) return;
    setState(() {
      _loading = false;
      if (weather == null) {
        _error = l10n.weatherUnavailable;
      } else {
        _weather = weather;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final canFetch = widget.location?.hasCoordinates ?? false;
    final config = AppConfig.instance;
    return AlertDialog(
      title: Text(l10n.weatherTitle),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        if (_weather != null)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: WeatherIcon(_weather!.code, size: 32),
            title: Text(weatherLabel(_weather!.code, l10n)),
            subtitle: Text(formatTemperature(_weather!.temperature)),
          ),
        if (!canFetch)
          Text(l10n.weatherNeedsLocation, style: theme.textTheme.bodyMedium)
        else if (_loading)
          const Padding(
            padding: EdgeInsets.all(12),
            child: CircularProgressIndicator(),
          )
        else
          TextButton.icon(
            key: const ValueKey('weather-fetch'),
            onPressed: _fetch,
            icon: const Icon(Icons.cloud_download_outlined),
            label: Text(l10n.weatherFetch),
          ),
        if (_error != null)
          Text(_error!,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.error)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => launchUrl(Uri.parse(config.weatherAttributionUrl)),
          child: Text(config.weatherAttribution,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: theme.colorScheme.outline)),
        ),
      ]),
      actions: [
        if (widget.current != null)
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop<WeatherChoice>((weather: null)),
            child: Text(l10n.weatherRemove),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        FilledButton(
          key: const ValueKey('weather-save'),
          onPressed: _weather == null
              ? null
              : () =>
                  Navigator.of(context).pop<WeatherChoice>((weather: _weather)),
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    );
  }
}
