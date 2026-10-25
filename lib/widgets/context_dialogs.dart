// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/config/app_config.dart';
import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/day_weather.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/services/weather_service.dart';
import 'package:aid_diary/utils/entry_context_display.dart';
import 'package:aid_diary/widgets/weather_icon.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

/// The answer of the weather dialog: weather looked up or set by hand, or
/// null to remove it.
typedef WeatherChoice = ({EntryWeather? weather, WeatherSource source});

/// Shows a day's weather at a place, looks it up for [time] there, or
/// takes it by hand.
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
  late WeatherKind? _kind =
      widget.current == null ? null : weatherKind(widget.current!.code);
  late int? _code = widget.current?.code;
  late final _temperature = TextEditingController(
      text: widget.current == null
          ? ''
          : '${inChosenUnit(widget.current!.temperature).round()}');

  /// Looked up and not changed since.
  EntryWeather? _fetched;

  /// Anything picked, typed or looked up; otherwise OK leaves the weather.
  bool _touched = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _temperature.dispose();
    super.dispose();
  }

  EntryWeather? get _weather {
    final typed = double.tryParse(_temperature.text.replaceAll(',', '.'));
    if (_code == null || typed == null) return null;
    return EntryWeather(
        code: _code!, temperature: celsiusFromChosenUnit(typed));
  }

  void _pick(WeatherKind kind) => setState(() {
        _kind = kind;
        _code = kind.code;
        _fetched = null;
        _touched = true;
      });

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
        return;
      }
      _kind = weatherKind(weather.code);
      _code = weather.code;
      _temperature.text = '${inChosenUnit(weather.temperature).round()}';
      _fetched = weather;
      _touched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final canFetch = widget.location?.hasCoordinates ?? false;
    final config = AppConfig.instance;
    final weather = _weather;
    return AlertDialog(
      title: Text(l10n.weatherTitle),
      content: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final kind in WeatherKind.values)
                    ChoiceChip(
                      key: ValueKey('weather-kind-${kind.name}'),
                      avatar: WeatherIcon(kind.code, size: 20),
                      label: Text(weatherLabel(kind.code, l10n)),
                      showCheckmark: false,
                      selected: _kind == kind,
                      onSelected: (_) => _pick(kind),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                key: const ValueKey('weather-temperature'),
                controller: _temperature,
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[-0-9.,]')),
                ],
                decoration: InputDecoration(
                  labelText: l10n.weatherTemperature,
                  suffixText: temperatureUnit,
                ),
                onChanged: (_) => setState(() {
                  _fetched = null;
                  _touched = true;
                }),
              ),
              const SizedBox(height: 8),
              if (!canFetch)
                Text(l10n.weatherNeedsLocation,
                    style: theme.textTheme.bodyMedium)
              else if (_loading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(),
                  ),
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
      ),
      actions: [
        if (widget.current != null)
          TextButton(
            onPressed: () => Navigator.of(context).pop<WeatherChoice>(
                (weather: null, source: WeatherSource.manual)),
            child: Text(l10n.weatherRemove),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        FilledButton(
          key: const ValueKey('weather-save'),
          onPressed: weather == null
              ? null
              : () => Navigator.of(context).pop<WeatherChoice>(!_touched
                  ? null
                  : _fetched != null
                      ? (weather: _fetched, source: WeatherSource.queried)
                      : (weather: weather, source: WeatherSource.manual)),
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    );
  }
}
