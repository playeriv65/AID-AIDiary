// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:ui' as ui;

import 'package:aid_diary/utils/entry_context_display.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

/// Weather in colour, as a forecast shows it, from the Meteocons "fill" set
/// (MIT, `assets/weather/LICENSE`).
class WeatherIcon extends StatelessWidget {
  const WeatherIcon(this.code, {super.key, this.size = 24});

  /// The WMO weather code.
  final int code;
  final double size;

  static String assetOf(WeatherKind kind) => 'assets/weather/${switch (kind) {
        WeatherKind.clear => 'clear-day',
        WeatherKind.partlyCloudy => 'partly-cloudy-day',
        WeatherKind.cloudy => 'overcast',
        WeatherKind.fog => 'fog',
        WeatherKind.drizzle => 'drizzle',
        WeatherKind.rain => 'rain',
        WeatherKind.snow => 'snow',
        WeatherKind.storm => 'thunderstorms-rain',
      }}.svg';

  @override
  Widget build(BuildContext context) {
    final asset = assetOf(weatherKind(code));
    final icon = SvgPicture.asset(asset, width: size, height: size);
    if (Theme.of(context).brightness == Brightness.dark) return icon;
    // The set's clouds are near white: on a light page a faint blurred
    // silhouette beneath gives them an edge.
    return Stack(children: [
      ImageFiltered(
        imageFilter: ui.ImageFilter.blur(sigmaX: size / 32, sigmaY: size / 32),
        child: SvgPicture.asset(asset,
            width: size,
            height: size,
            colorFilter:
                const ColorFilter.mode(Color(0x66455A70), BlendMode.srcIn)),
      ),
      icon,
    ]);
  }
}
