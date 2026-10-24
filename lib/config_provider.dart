// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:aid_diary/language_option.dart';
import 'package:aid_diary/storage/secret_store.dart';
import 'package:aid_diary/time_manager.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:material_ui/material_ui.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting<T> {
  const Setting(this.key, this.defaultValue,
      {this.secure = false,
      this.secretStore = false,
      this.choices,
      this.range});

  final String key;
  final T defaultValue;
  final bool secure;
  final bool secretStore;

  /// The only values a text setting takes, when it has a fixed list.
  final List<String>? choices;

  /// The lowest and highest value a number setting takes.
  final (int, int)? range;
}

const _hours = (0, 23);
const _minutes = (0, 59);

class Settings {
  static const configVersion = Setting<String>("configVersion", "2");
  static const theme = Setting<String>("theme", "system",
      choices: ["system", "light", "dark", "amoled"]);
  static const useExternalDb = Setting<bool>("useExternalDb", false);
  static const externalDbUri = Setting<String>("externalDbUri", "");
  static const useExternalImg = Setting<bool>("useExternalImg", false);
  static const externalImgUri = Setting<String>("externalImgUri", "");
  static const startingDayOfWeek =
      Setting<String>("startingDayOfWeek", "system", choices: [
    "system",
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday"
  ]);
  static const veryHappyIcon = Setting<String>("veryHappyIcon", "☺️");
  static const happyIcon = Setting<String>("happyIcon", "🙂");
  static const neutralIcon = Setting<String>("neutralIcon", "😐");
  static const sadIcon = Setting<String>("sadIcon", "😕");
  static const verySadIcon = Setting<String>("verySadIcon", "😔");
  static const followSystemColor = Setting<bool>("followSystemColor", true);
  static const accentColor = Setting<int>("accentColor", 0xff62A0EA);
  static const tintThemeBackground = Setting<bool>("tintThemeBackground", true);
  static const darkTheme =
      Setting<String>('darkTheme', 'same', choices: ['same', 'dark', 'amoled']);
  static const darkAccentColor = Setting<int>('darkAccentColor', 0xff8f9be8);
  static const darkFollowSystemColor =
      Setting<bool>('darkFollowSystemColor', false);
  static const paperStyle = Setting<String>('paperStyle', 'plain',
      choices: ['plain', 'lined', 'grid', 'tinted']);
  static const paperDecoration = Setting<String>('paperDecoration', 'none',
      choices: ['none', 'botanical', 'stars', 'washi']);
  static const localPhotoFolder = Setting<String>('localPhotoFolder', '');
  static const photoSuggestionsLocation =
      Setting<bool>('photoSuggestionsLocation', false);
  static const dismissedPhotoSuggestions =
      Setting<List<dynamic>>('dismissedPhotoSuggestions', []);
  static const importedPhotoSuggestions =
      Setting<List<dynamic>>('importedPhotoSuggestions', []);
  static const dailyReminders = Setting<bool>("dailyReminders", false);
  static const setReminderTime = Setting<bool>("setReminderTime", false);
  static const scheduledReminderHour =
      Setting<int>("scheduledReminderHour", 12, range: _hours);
  static const scheduledReminderMinute =
      Setting<int>("scheduledReminderMinute", 0, range: _minutes);
  static const reminderStartHour =
      Setting<int>("reminderStartHour", 9, range: _hours);
  static const reminderStartMinute =
      Setting<int>("reminderStartMinute", 0, range: _minutes);
  static const reminderEndHour =
      Setting<int>("reminderEndHour", 21, range: _hours);
  static const reminderEndMinute =
      Setting<int>("reminderEndMinute", 0, range: _minutes);
  static const alwaysRemind = Setting<bool>("alwaysRemind", false);
  static const onThisDayNotifications =
      Setting<bool>("onThisDayNotifications", false);
  static const onThisDayNotificationHour =
      Setting<int>("onThisDayNotificationHour", 12, range: _hours);
  static const onThisDayNotificationMinute =
      Setting<int>("onThisDayNotificationMinute", 0, range: _minutes);
  static const defaultTemplate = Setting<int>("defaultTemplate", -1);

  /// Whether new photos are stored compressed (about 1 MB of WebP) rather
  /// than as they come.
  static const compressPhotos = Setting<bool>("compressPhotos", false);
  static const overrideLanguage =
      Setting<Map<String, dynamic>?>("overrideLanguage", null);
  static const showFlashbacks = Setting<bool>("showFlashbacks", true);
  static const temperatureUnit = Setting<String>("temperatureUnit", "celsius",
      choices: ["celsius", "fahrenheit"]);
  // "system", "12" or "24".
  static const timeFormat =
      Setting<String>("timeFormat", "system", choices: ["system", "12", "24"]);
  static const routinePrompts = Setting<bool>("routinePrompts", true);
  // The coach program the user is enrolled in ("" for none), the day it
  // started (yyyy-MM-dd) and the last step answered (-1 for none).
  static const coachProgram = Setting<String>("coachProgram", "");
  static const coachStartDate = Setting<String>("coachStartDate", "");
  static const coachAnsweredStep = Setting<int>("coachAnsweredStep", -1);
  // Starred places for the location picker: {name, latitude, longitude}.
  static const savedPlaces = Setting<List<dynamic>>("savedPlaces", []);
  // The welcome pages have been seen.
  static const onboardingDone = Setting<bool>("onboardingDone", false);
  // A lasting notification that opens a new entry (Android).
  static const quickWriteNotification =
      Setting<bool>("quickWriteNotification", false);
  // A nudge after some days without an entry (Android).
  static const inactivityNudges = Setting<bool>("inactivityNudges", false);
  // "newest", "oldest" or "updated".
  static const journalSort = Setting<String>("journalSort", "newest",
      choices: ["newest", "oldest", "updated"]);
  // Weekdays (1 = Monday) the daily reminder fires on.
  static const reminderWeekdays =
      Setting<List<dynamic>>("reminderWeekdays", [1, 2, 3, 4, 5, 6, 7]);
  // Keys into the typography section of assets/config/app_config.json.
  static const entryFontFamily = Setting<String>("entryFontFamily", "system",
      choices: ["system", "serif", "mono"]);
  static const entryFontSize = Setting<String>("entryFontSize", "medium",
      choices: ["small", "medium", "large", "extraLarge"]);
  static const entryLineSpacing = Setting<String>("entryLineSpacing", "normal",
      choices: ["compact", "normal", "relaxed"]);
  static const wallpaper = Setting<String>("wallpaper", "none",
      choices: ["none", "dots", "grid", "lines", "photo"]);
  static const wallpaperImage = Setting<String>("wallpaperImage", "");
  // Off by default: each one asks for a permission or uses the network.
  static const autoAddLocation = Setting<bool>("autoAddLocation", true);

  /// Whether editing an entry from an earlier day asks first.
  static const confirmEditPast = Setting<bool>("confirmEditPast", true);
  static const autoAddWeather = Setting<bool>("autoAddWeather", true);
  static const dayAskUntilHour =
      Setting<int>("dayAskUntilHour", 6, range: _hours);
  static const dayStartHour = Setting<int>("dayStartHour", 4, range: _hours);
  static const excludeBadDaysFromFlashbacks =
      Setting<bool>("excludeBadDaysFromFlashbacks", false);
  static const showflashbackYearsAgo =
      Setting<bool>("showflashbackYearsAgo", true);
  static const showflashback6MonthsAgo =
      Setting<bool>("showflashback6MonthsAgo", true);
  static const showflashback1MonthAgo =
      Setting<bool>("showflashback1MonthAgo", true);
  static const showflashback1WeekAgo =
      Setting<bool>("showflashback1WeekAgo", true);
  static const showflashbackGoodDay =
      Setting<bool>("showflashbackGoodDay", true);
  static const showflashbackRandomDay =
      Setting<bool>("showflashbackRandomDay", true);
  static const hideImagesInGallery =
      Setting<bool>("hideImagesInGallery", false);
  static const calendarSystem = Setting<String>("calendarSystem", "system",
      choices: ["system", "gregorian", "jalali"]);
  static const moodOverTimeGrouping =
      Setting<String?>("moodOverTimeGrouping", null);
  static const moodOverTimeSmoothing =
      Setting<bool>("moodOverTimeSmoothing", true);
  static const statsRange = Setting<String>("statsRange", "allTime");
  static const statsSubject = Setting<String>("statsSubject", "mood");
  static const requirePassword =
      Setting<bool>("requirePassword", false, secure: true);
  static const biometricUnlock =
      Setting<bool>("biometricUnlock", false, secure: true);
  static const passwordHash =
      Setting<String>("passwordHash", "", secure: true, secretStore: true);
  static const passwordIsPin =
      Setting<bool>("passwordIsPin", false, secure: true);
  static const backupPasswordEnabled =
      Setting<bool>("backupPasswordEnabled", false, secure: true);
  static const backupPassword =
      Setting<String>("backupPassword", "", secure: true, secretStore: true);
  static const autoBackupEnabled = Setting<bool>("autoBackupEnabled", false);
  static const autoBackupLocationUri =
      Setting<String>("autoBackupLocationUri", "");
  static const autoBackupInterval = Setting<String>(
      "autoBackupInterval", "weekly",
      choices: ["daily", "weekly", "monthly"]);
  static const autoBackupRequireCharging =
      Setting<bool>("autoBackupRequireCharging", false);
  static const autoBackupMaxCount = Setting<int>("autoBackupMaxCount", 3);
  static const lastBackup = Setting<String>("lastBackup", "", secure: true);
  static const lastAutoBackup =
      Setting<String>("lastAutoBackup", "", secure: true);

  /// Where this device syncs, as JSON; empty when it does not. Kept on the
  /// device, like the secrets that go with it.
  static const syncTarget = Setting<String>("syncTarget", "", secure: true);
  static const deviceName = Setting<String>("deviceName", "", secure: true);
  static const syncDeviceId = Setting<String>("syncDeviceId", "", secure: true);

  /// The sync login's password or token, as JSON.
  static const syncSecrets =
      Setting<String>("syncSecrets", "", secure: true, secretStore: true);

  /// Whose diary this is: the user id and master key every device of the
  /// user shares (sync/identity.dart), as JSON.
  static const identity =
      Setting<String>("identity", "", secure: true, secretStore: true);

  /// An unfinished nearby transfer, including its temporary encryption key.
  static const nearbyMigration =
      Setting<String>("nearbyMigration", "", secure: true, secretStore: true);

  /// Public device registrations and native key aliases; never private keys.
  static const deviceAuthorizations = Setting<String>(
      "deviceAuthorizations", "",
      secure: true, secretStore: true);
  static const pendingDeviceApprovals = Setting<String>(
      "pendingDeviceApprovals", "",
      secure: true, secretStore: true);
  static const lastSync = Setting<String>("lastSync", "", secure: true);
  // The agent API for the `aid` command line, in builds where it is not on
  // anyway.
  static const agentApi = Setting<bool>("agentApi", false);

  static const List<Setting<Object?>> all = [
    darkTheme,
    localPhotoFolder,
    photoSuggestionsLocation,
    dismissedPhotoSuggestions,
    importedPhotoSuggestions,
    darkAccentColor,
    darkFollowSystemColor,
    paperStyle,
    paperDecoration,
    configVersion,
    theme,
    useExternalDb,
    externalDbUri,
    useExternalImg,
    externalImgUri,
    startingDayOfWeek,
    veryHappyIcon,
    happyIcon,
    neutralIcon,
    sadIcon,
    verySadIcon,
    followSystemColor,
    accentColor,
    tintThemeBackground,
    dailyReminders,
    setReminderTime,
    scheduledReminderHour,
    scheduledReminderMinute,
    reminderStartHour,
    reminderStartMinute,
    reminderEndHour,
    reminderEndMinute,
    alwaysRemind,
    onThisDayNotifications,
    onThisDayNotificationHour,
    onThisDayNotificationMinute,
    defaultTemplate,
    compressPhotos,
    overrideLanguage,
    showFlashbacks,
    temperatureUnit,
    timeFormat,
    routinePrompts,
    coachProgram,
    coachStartDate,
    coachAnsweredStep,
    savedPlaces,
    onboardingDone,
    quickWriteNotification,
    inactivityNudges,
    journalSort,
    reminderWeekdays,
    entryFontFamily,
    entryFontSize,
    entryLineSpacing,
    wallpaper,
    wallpaperImage,
    autoAddLocation,
    confirmEditPast,
    autoAddWeather,
    dayStartHour,
    dayAskUntilHour,
    excludeBadDaysFromFlashbacks,
    showflashbackYearsAgo,
    showflashback6MonthsAgo,
    showflashback1MonthAgo,
    showflashback1WeekAgo,
    showflashbackGoodDay,
    showflashbackRandomDay,
    hideImagesInGallery,
    calendarSystem,
    moodOverTimeGrouping,
    moodOverTimeSmoothing,
    statsRange,
    statsSubject,
    requirePassword,
    biometricUnlock,
    passwordHash,
    passwordIsPin,
    backupPasswordEnabled,
    backupPassword,
    autoBackupEnabled,
    autoBackupLocationUri,
    autoBackupInterval,
    autoBackupRequireCharging,
    autoBackupMaxCount,
    lastBackup,
    lastAutoBackup,
    syncTarget,
    deviceName,
    syncDeviceId,
    syncSecrets,
    identity,
    nearbyMigration,
    deviceAuthorizations,
    pendingDeviceApprovals,
    lastSync,
    agentApi,
  ];

  static const moodIcons = <int, Setting<String>>{
    2: veryHappyIcon,
    1: happyIcon,
    0: neutralIcon,
    -1: sadIcon,
    -2: verySadIcon,
  };
}

class ConfigProvider with ChangeNotifier {
  static final ConfigProvider instance = ConfigProvider._init();

  ConfigProvider._init();

  final Logger _logger = Logger('ConfigProvider');

  String configFilePath = '';

  Map<String, dynamic> _config = {};

  static final Set<String> _secureKeys = {
    for (final setting in Settings.all)
      if (setting.secure) setting.key,
  };

  T get<T>(Setting<T> setting) {
    final value = _config[setting.key];
    // Not null: with T inferred as Object? an unset setting would read as
    // null rather than its default.
    return value != null && value is T ? value : setting.defaultValue;
  }

  Future<void> set<T>(Setting<T> setting, T value) async {
    _config[setting.key] = value;
    notifyListeners();

    if (setting.secretStore) {
      await SecretStore.instance.write(setting.key, json.encode(value));
    } else if (setting.secure) {
      final prefs = await SharedPreferences.getInstance();
      // Store as JSON for type safety
      await prefs.setString(setting.key, json.encode(value));
    } else {
      await writeConfig();
    }
  }

  Future<void> init() async {
    initializeDateFormatting();

    final dbPath = await getApplicationSupportDirectory();
    if (!dbPath.existsSync()) dbPath.createSync(recursive: true);
    configFilePath = join(dbPath.path, 'config.json');

    // The file replaces the whole map, so it comes first. The two stores
    // fill in their own keys and each takes tens of milliseconds to open, so
    // they load side by side.
    await readConfig();
    await Future.wait([loadSecureConfig(), loadSecretStoreConfig()]);
    await _pruneUnknownKeys();
  }

  Future<void> _pruneUnknownKeys() async {
    final declaredKeys = {for (final setting in Settings.all) setting.key};
    final unknownKeys =
        _config.keys.where((key) => !declaredKeys.contains(key)).toList();
    if (unknownKeys.isEmpty) return;

    _config.removeWhere((key, _) => unknownKeys.contains(key));
    await writeConfig();
  }

  Future<void> loadSecureConfig() async {
    final prefs = await SharedPreferences.getInstance();
    for (final setting in Settings.all
        .where((setting) => setting.secure && !setting.secretStore)) {
      final stored = prefs.getString(setting.key);
      if (stored == null) {
        _config[setting.key] = setting.defaultValue;
        // Store as JSON for type safety
        await prefs.setString(setting.key, json.encode(setting.defaultValue));
        continue;
      }
      _decodeInto(setting, stored);
    }
  }

  Future<void> loadSecretStoreConfig() async {
    for (final setting
        in Settings.all.where((setting) => setting.secretStore)) {
      final stored = await _readSecret(setting.key);
      if (stored == null) {
        _config[setting.key] = setting.defaultValue;
        continue;
      }
      _decodeInto(setting, stored);
    }
  }

  Future<String?> _readSecret(String key) async {
    try {
      return await SecretStore.instance.read(key);
    } catch (error, stackTrace) {
      _logger.warning(
          'Could not read $key from secret storage', error, stackTrace);
      return null;
    }
  }

  void _decodeInto(Setting<Object?> setting, String stored) {
    try {
      _config[setting.key] = json.decode(stored);
    } catch (error, stackTrace) {
      _logger.warning('${setting.key} is not valid JSON, reading it raw', error,
          stackTrace);
      _config[setting.key] = stored;
    }
  }

  Future<void> readConfig() async {
    final configFile = File(configFilePath);

    if (!await configFile.exists()) {
      _config = {};
      return;
    }

    try {
      final content = await configFile.readAsString();
      final decoded = json.decode(content);

      if (decoded is Map<String, dynamic>) {
        _config = decoded;
      } else {
        throw const FormatException('Config is not a map');
      }
    } catch (error, stackTrace) {
      // Corrupted config: reset to defaults
      _logger.severe('Config could not be read, falling back to defaults',
          error, stackTrace);
      _config = {};
    }
  }

  Future<void> writeConfig() async {
    EasyDebounce.debounce("save-config", Duration(seconds: 1), () {
      // The queue owns failures even when no caller is awaiting a debounce.
      unawaited(_saveConfigSnapshot()
          .then<void>((_) {}, onError: (Object error, StackTrace stack) {}));
    });
  }

  Future<void> _configWriteTail = Future.value();

  Future<void> _saveConfigSnapshot() {
    final path = configFilePath;
    final filtered = Map<String, dynamic>.from(_config)
      ..removeWhere((key, _) => _secureKeys.contains(key));
    final contents = json.encode(filtered);
    final result = _configWriteTail.then((_) async {
      final temporary = File('$path.tmp');
      try {
        await temporary.writeAsString(contents, flush: true);
        await temporary.rename(path);
      } finally {
        if (await temporary.exists()) await temporary.delete();
      }
    });
    _configWriteTail =
        result.then<void>((_) {}, onError: (Object error, StackTrace stack) {
      _logger.severe('Writing configuration failed', error, stack);
    });
    return result;
  }

  /// Drains the debounce and waits until the last atomic file replacement ends.
  Future<void> flushConfig() {
    EasyDebounce.cancel('save-config');
    return _saveConfigSnapshot();
  }

  Future<void> waitForConfigWrites() => _configWriteTail;

  /// The 12/24-hour choice from settings; null follows the system.
  bool? get chosen24HourFormat => switch (get(Settings.timeFormat)) {
        '24' => true,
        '12' => false,
        _ => null,
      };

  bool is24HourFormat() {
    if (chosen24HourFormat case final chosen?) return chosen;
    if (PlatformDispatcher.instance.alwaysUse24HourFormat) return true;
    String formattedTime =
        DateFormat.jm(PlatformDispatcher.instance.locale.toString())
            .format(DateTime.now());
    // If the output contains text, it's a 12-hour format
    return !formattedTime.contains(RegExp(r'[A-Za-z]'));
  }

  int getFirstDayOfWeekIndex(BuildContext context) =>
      firstDayOfWeekIndexFor(TimeManager.currentLocale(context));

  /// The first day of the week, Monday = 0: the setting, or what the
  /// language named [dateLocale] uses.
  int firstDayOfWeekIndexFor(String dateLocale) {
    final startingDay = get(Settings.startingDayOfWeek);
    if (startingDay == 'system') {
      return DateFormat.yMd(dateLocale).dateSymbols.FIRSTDAYOFWEEK;
    } else {
      return TimeManager.dayOfWeekIndexMapping.keys.firstWhere(
          (k) => TimeManager.dayOfWeekIndexMapping[k] == startingDay);
    }
  }

  Locale? getOverrideLanguage() {
    LanguageOption? currentOverride =
        LanguageOption.fromJsonOrNull(get(Settings.overrideLanguage));
    if (currentOverride != null) {
      return currentOverride.toLocale();
    }
    return null;
  }
}
