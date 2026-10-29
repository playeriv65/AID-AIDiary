// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';

/// Network endpoints and map settings from `assets/config/app_config.json`.
class AppConfig {
  AppConfig._(this._json);

  static const assetPath = 'assets/config/app_config.json';

  static AppConfig? _instance;
  static AppConfig get instance {
    final config = _instance;
    if (config == null) {
      throw StateError('AppConfig.load() must run before use');
    }
    return config;
  }

  static Future<AppConfig> load({AssetBundle? bundle}) async {
    final raw = await (bundle ?? rootBundle).loadString(assetPath);
    return _instance = AppConfig._(jsonDecode(raw) as Map<String, dynamic>);
  }

  /// Replaces the loaded config, for tests.
  static void setForTesting(Map<String, dynamic> json) =>
      _instance = AppConfig._(json);

  final Map<String, dynamic> _json;

  Map<String, dynamic> _section(String name) =>
      _json[name] as Map<String, dynamic>;

  String get tileUrlTemplate => _section('map')['tileUrlTemplate'] as String;
  String get mapAttribution => _section('map')['attribution'] as String;
  String get mapAttributionUrl => _section('map')['attributionUrl'] as String;
  String get userAgentPackageName =>
      _section('map')['userAgentPackageName'] as String;
  double get mapDefaultZoom =>
      (_section('map')['defaultZoom'] as num).toDouble();
  double get mapEntryZoom => (_section('map')['entryZoom'] as num).toDouble();
  double get mapMaxZoom => (_section('map')['maxZoom'] as num).toDouble();

  /// Markers closer than this many logical pixels merge into a cluster.
  double get mapClusterRadius =>
      (_section('map')['clusterRadius'] as num).toDouble();

  /// Degrees two fingers must turn before the map rotates rather than zooms.
  double get mapRotationThreshold =>
      (_section('map')['rotationThreshold'] as num).toDouble();

  /// A map left turned less than this from north turns back to north.
  double get mapNorthSnapDegrees =>
      (_section('map')['northSnapDegrees'] as num).toDouble();

  /// The narrowest the whole world may get, as a share of the map's width:
  /// zooming out stops there.
  double get mapMinWorldWidth =>
      (_section('map')['minWorldWidth'] as num).toDouble();

  Uri get reverseGeocodeUrl =>
      Uri.parse(_section('geocoding')['reverseUrl'] as String);
  Uri get placeSearchUrl =>
      Uri.parse(_section('geocoding')['searchUrl'] as String);
  int get placeSearchLimit => _section('geocoding')['searchLimit'] as int;
  String get geocodeUserAgent => _section('geocoding')['userAgent'] as String;
  Duration get geocodeTimeout =>
      Duration(seconds: _section('geocoding')['timeoutSeconds'] as int);

  /// Overpass endpoint and bounds for named places around a position.
  Uri get nearbyUrl => Uri.parse(_section('nearby')['url'] as String);
  int get nearbyRadiusMeters => _section('nearby')['radiusMeters'] as int;
  int get nearbyLimit => _section('nearby')['limit'] as int;
  Duration get nearbyTimeout =>
      Duration(seconds: _section('nearby')['timeoutSeconds'] as int);

  Map<String, double> get fontSizes => _numbers('typography', 'fontSizes');
  Map<String, double> get lineSpacings =>
      _numbers('typography', 'lineSpacings');

  /// Font family names per choice, first preferred; empty means the theme's.
  Map<String, List<String>> get fontFamilies => {
        for (final MapEntry(:key, :value)
            in (_section('typography')['fontFamilies'] as Map).entries)
          key as String: (value as List).cast<String>(),
      };

  /// Photo files the file picker offers next to videos and audio.
  List<String> get imageExtensions =>
      (_section('media')['imageExtensions'] as List).cast<String>();
  List<String> get videoExtensions =>
      (_section('media')['videoExtensions'] as List).cast<String>();
  List<String> get audioExtensions =>
      (_section('media')['audioExtensions'] as List).cast<String>();
  String get recordingExtension =>
      _section('media')['recordingExtension'] as String;
  Duration get maxVideoDuration =>
      Duration(minutes: _section('media')['maxVideoMinutes'] as int);

  /// Attachments are held in memory while stored and synced, so videos
  /// above this size are refused.
  int get maxVideoBytes =>
      (_section('media')['maxVideoMegabytes'] as int) * 1024 * 1024;

  /// A compressed photo aims to be at most this many bytes, its shorter
  /// side at most [compressedPhotoShortSide] pixels, trying each quality in
  /// [compressedPhotoQualities] (WebP's scale) until it fits.
  int get compressedPhotoBytes =>
      _section('media')['compressedPhotoBytes'] as int;
  int get compressedPhotoShortSide =>
      _section('media')['compressedPhotoShortSide'] as int;
  List<int> get compressedPhotoQualities =>
      (_section('media')['compressedPhotoQualities'] as List).cast<int>();

  /// The morning prompt shows before this hour, the evening one from the
  /// other on.
  int get morningEndsHour => _section('routine')['morningEndsHour'] as int;
  int get eveningStartsHour => _section('routine')['eveningStartsHour'] as int;

  /// Hour of the day a coach program's new prompt is announced.
  int get coachPromptHour => _section('coach')['promptHour'] as int;

  /// Days without an entry before a nudge, and the hour it may come at.
  int get nudgeAfterDays => _section('nudges')['afterDays'] as int;
  int get nudgeHour => _section('nudges')['hour'] as int;

  /// Entries in Recently deleted are erased after this long.
  Duration get deletedRetention =>
      Duration(days: _section('recentlyDeleted')['retentionDays'] as int);

  /// Share cards are laid out this wide and rendered at [sharePixelRatio].
  double get shareCardWidth =>
      (_section('share')['cardWidth'] as num).toDouble();
  double get sharePixelRatio =>
      (_section('share')['pixelRatio'] as num).toDouble();
  int get shareMaxCharacters => _section('share')['maxCharacters'] as int;

  String get wallpaperDirectory => _section('wallpaper')['directory'] as String;
  double get wallpaperScrimOpacity =>
      (_section('wallpaper')['photoScrimOpacity'] as num).toDouble();
  double get wallpaperPatternSpacing =>
      (_section('wallpaper')['patternSpacing'] as num).toDouble();

  Map<String, double> _numbers(String section, String name) => {
        for (final MapEntry(:key, :value)
            in (_section(section)[name] as Map).entries)
          key as String: (value as num).toDouble(),
      };

  Duration get locationTimeout =>
      Duration(seconds: _section('location')['timeoutSeconds'] as int);
  int get recentPlacesLimit => _section('location')['recentPlaces'] as int;

  /// How many tags the pickers offer as used lately, and over how many days.
  int get recentTagsLimit => _section('tags')['recentCount'] as int;
  int get recentTagsDays => _section('tags')['recentDays'] as int;

  Uri get weatherForecastUrl =>
      Uri.parse(_section('weather')['forecastUrl'] as String);
  Uri get weatherArchiveUrl =>
      Uri.parse(_section('weather')['archiveUrl'] as String);

  /// Dates within this many days use the forecast endpoint; older ones the
  /// archive, which lags a few days behind.
  int get weatherRecentDays => _section('weather')['recentDays'] as int;

  /// The hour whose weather stands for a day an entry was not written on.
  int get weatherDayHour => _section('weather')['dayHour'] as int;
  Duration get weatherTimeout =>
      Duration(seconds: _section('weather')['timeoutSeconds'] as int);
  String get weatherAttribution => _section('weather')['attribution'] as String;
  String get weatherAttributionUrl =>
      _section('weather')['attributionUrl'] as String;

  /// How many photos the photo widget gets to pick its daily one from.
  int get photoWidgetCandidates => _section('photoWidget')['candidates'] as int;

  /// Newest entries read before the journal shows at launch; more than a
  /// tall screen holds, so the first scroll does not run out.
  int get launchFirstScreenEntries =>
      _section('launch')['firstScreenEntries'] as int;

  /// Tail of a Windows mouse-wheel burst; zero disables smoothing.
  Duration get wheelScrollDuration =>
      Duration(milliseconds: _section('scrolling')['wheelDurationMs'] as int);

  double get backToTopScreens =>
      (_section('scrolling')['backToTopScreens'] as num).toDouble();

  /// How long the back-to-top button takes to drop in, and the list to
  /// glide back to the top.
  int get backToTopSlideMs => _section('scrolling')['backToTopSlideMs'] as int;
  int get backToTopScrollMs =>
      _section('scrolling')['backToTopScrollMs'] as int;
  Uri get feedbackIssuesUrl =>
      Uri.parse(_section('feedback')['issuesUrl'] as String);
  String get feedbackEmail => _section('feedback')['email'] as String;

  /// Where the feedback page sends a message itself.
  Uri get feedbackSubmitUrl =>
      Uri.parse(_section('feedback')['submitUrl'] as String);
  Duration get feedbackTimeout =>
      Duration(seconds: _section('feedback')['timeoutSeconds'] as int);

  /// Where the release manifest is, tried in order: the AID server, which
  /// mainland China reaches, then GitHub (docs/UPDATES.md).
  List<Uri> get updateManifestUrls => [
        for (final url in _section('updates')['manifestUrls'] as List)
          Uri.parse(url as String)
      ];

  /// The shortest time between two checks the app makes by itself.
  Duration get updateCheckInterval =>
      Duration(hours: _section('updates')['checkHours'] as int);
  Duration get updateTimeout =>
      Duration(seconds: _section('updates')['timeoutSeconds'] as int);
  Duration get updateDownloadTimeout =>
      Duration(minutes: _section('updates')['downloadTimeoutMinutes'] as int);

  /// Hours before which a new entry may count for the day before; 0 never.
  List<int> get dayStartHourChoices =>
      (_section('diaryDay')['startHourChoices'] as List).cast<int>();

  /// Hours until which the editor may ask which day a new entry is for.
  List<int> get dayAskUntilHourChoices =>
      (_section('diaryDay')['askUntilHourChoices'] as List).cast<int>();

  /// Quiet time after a change before it syncs, so a burst of edits goes
  /// up together.
  Duration get syncAfterChange =>
      Duration(seconds: _section('sync')['afterChangeSeconds'] as int);

  /// How often the app syncs while it stays open.
  Duration get syncWhileOpen =>
      Duration(minutes: _section('sync')['whileOpenMinutes'] as int);

  /// Changes up to this many bytes of JSON go into one pack.
  int get syncPackBytes => (_section('sync')['packKiB'] as int) * 1024;

  /// Packs in a space beyond which they are folded into a snapshot.
  int get syncCompactAfterPacks => _section('sync')['compactAfterPacks'] as int;

  /// A sync shows how far it is only once it has run this long; quick ones
  /// just sync.
  Duration get syncProgressAfter =>
      Duration(seconds: _section('sync')['progressAfterSeconds'] as int);

  /// Files a sync moves at the same time.
  int get syncParallelTransfers => _section('sync')['parallelTransfers'] as int;

  Map<String, dynamic> get syncTransfer =>
      (_section('sync')['transfer'] as Map).cast<String, dynamic>();

  /// The AID sync server's WebDAV address (server/ in this repository).
  String get syncOfficialServer => _section('sync')['officialServer'] as String;

  /// An address shown as an example in the server field.
  String get syncExampleServer => _section('sync')['exampleServer'] as String;

  /// The loopback port of the agent API the `aid` CLI talks to.
  int get agentApiPort => _section('agentApi')['port'] as int;

  /// The in-app agent's model service (OpenAI-compatible) and model, until
  /// the user picks others.
  String get agentBaseUrl => _section('agent')['baseUrl'] as String;
  String get agentModel => _section('agent')['model'] as String;

  /// How many model turns one request may take.
  int get agentMaxTurns => _section('agent')['maxTurns'] as int;

  /// The most characters of one command's output the model sees.
  int get agentOutputChars => _section('agent')['outputChars'] as int;

  /// The most rows one `sql` query prints.
  int get agentSqlRows => _section('agent')['sqlRows'] as int;

  /// Agents on this computer that speak ACP, by name: how to start each,
  /// with environment variables of their own (Codex needs the network for
  /// `aid` to reach the app).
  Map<String, ({String command, List<String> args, Map<String, String> env})>
      get acpAgents => {
            for (final MapEntry(:key, :value)
                in (_section('agent')['acpAgents'] as Map<String, dynamic>)
                    .entries)
              key: (
                command: value['command'] as String,
                args: (value['args'] as List).cast<String>(),
                env: (value['env'] as Map<String, dynamic>? ?? const {})
                    .cast<String, String>(),
              ),
          };

  GoogleDriveConfig get googleDrive => GoogleDriveConfig._(
      (_section('sync')['googleDrive'] as Map).cast<String, dynamic>());

  Map<String, dynamic> get _recovery =>
      (_section('sync')['recovery'] as Map).cast<String, dynamic>();

  /// Random bytes in a new recovery code (base32 in groups of four).
  int get recoveryCodeBytes => _recovery['codeBytes'] as int;

  /// The shortest recovery password a person may choose instead.
  int get recoveryMinPasswordLength => _recovery['minPasswordLength'] as int;

  /// Argon2id cost of the key that locks the master key in the space, which
  /// anyone holding the space could try passwords against.
  int get recoveryArgon2MemoryKiB => _recovery['argon2MemoryKiB'] as int;
  int get recoveryArgon2Iterations => _recovery['argon2Iterations'] as int;

  Map<String, dynamic> get _pairing =>
      (_section('sync')['pairing'] as Map).cast<String, dynamic>();

  /// Digits of a pairing code to type; a scanned code is longer.
  int get pairingCodeDigits => _pairing['codeDigits'] as int;

  /// How often a pairing looks for the other device's message.
  Duration get pairingPoll =>
      Duration(milliseconds: _pairing['pollMilliseconds'] as int);

  /// How long a pairing waits for the other device.
  Duration get pairingTimeout =>
      Duration(seconds: _pairing['timeoutSeconds'] as int);
}

/// The app's Google Cloud registration and the endpoints it signs in and
/// syncs with. See docs/GOOGLE_DRIVE.md.
class GoogleDriveConfig {
  GoogleDriveConfig._(this._json);

  final Map<String, dynamic> _json;

  /// The web client, which Android sign-in names as its server.
  String get webClientId => _json['webClientId'] as String;

  /// The desktop client, signing in through the browser on Windows.
  String get desktopClientId => _json['desktopClientId'] as String;

  /// Not a secret for an installed app, but Google asks for it. It stays out
  /// of the public sources: a build gets it with
  /// `--dart-define=AID_GOOGLE_DESKTOP_SECRET=...` (docs/GOOGLE_DRIVE.md).
  String get desktopClientSecret =>
      desktopClientSecretForTesting ?? _desktopClientSecret;

  static const _desktopClientSecret =
      String.fromEnvironment('AID_GOOGLE_DESKTOP_SECRET');

  @visibleForTesting
  static String? desktopClientSecretForTesting;

  Uri get authUrl => Uri.parse(_json['authUrl'] as String);
  Uri get tokenUrl => Uri.parse(_json['tokenUrl'] as String);
  Uri get apiUrl => Uri.parse(_json['apiUrl'] as String);
  Uri get uploadUrl => Uri.parse(_json['uploadUrl'] as String);

  /// How long the browser sign-in may take before it is given up.
  Duration get signInTimeout =>
      Duration(minutes: _json['signInTimeoutMinutes'] as int);
}
