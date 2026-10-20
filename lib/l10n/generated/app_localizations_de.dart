// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => 'Theme color';

  @override
  String get themeColorHint =>
      'Pick a color to stop following the system accent. Applies to light and dark themes.';

  @override
  String get themeColorBlue => 'Sky blue';

  @override
  String get themeColorGreen => 'Forest green';

  @override
  String get themeColorBrown => 'Warm coffee';

  @override
  String get themeColorPurple => 'Lavender';

  @override
  String get themeColorRose => 'Dusty rose';

  @override
  String get themeColorAmber => 'Amber';

  @override
  String get themeColorPreview => 'A little every day';

  @override
  String get themeTintBackgroundTitle => 'Tint backgrounds with theme color';

  @override
  String get themeTintBackgroundHint =>
      'Turn off for neutral gray backgrounds; buttons keep your chosen color.';

  @override
  String get dailyReminderTitle => 'Heute eintragen!';

  @override
  String get dailyReminderDescription => 'Mache deinen Eintrag …';

  @override
  String get actionTakePhoto => 'Foto machen';

  @override
  String get actionToday => 'Heute';

  @override
  String get actionOtherDay => 'Anderer Tag';

  @override
  String get pageHomeTitle => 'Start';

  @override
  String get jumpToMonthTitle => 'Springe zu Monat';

  @override
  String get jumpToLogTitle => 'Wechsle zum Log';

  @override
  String get flashbacksTitle => 'Rückblicke';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Schließe schlechte Tage aus';

  @override
  String get flaskbacksEmpty => 'Bis jetzt keine Rückblicke…';

  @override
  String get flashbackGoodDay => 'Ein guter Tag';

  @override
  String get flashbackRandomDay => 'Ein zufälliger Tag';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Wochen her',
      one: '$count Woche her',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Monate her',
      one: '$count Monat her',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Jahre her',
      one: '$count Jahr her',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'An diesem Tag';

  @override
  String get pageGalleryTitle => 'Galerie';

  @override
  String get searchLogsHint => 'Einträge durchsuchen …';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge',
      one: '$count Eintrag',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage',
      one: '$count Tag',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Wörter',
      one: '$count Wort',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Keine Einträge vorhanden …';

  @override
  String get noResults => 'Keine Ergebnisse…';

  @override
  String get sortDateTitle => 'Datum';

  @override
  String get sortOrderAscendingTitle => 'Aufsteigend';

  @override
  String get sortOrderDescendingTitle => 'Absteigend';

  @override
  String get pageStatisticsTitle => 'Statistiken';

  @override
  String get statisticsNotEnoughData => 'Nicht genügend Daten …';

  @override
  String get statisticsRangeOneMonth => '1 Monat';

  @override
  String get statisticsRangeSixMonths => '6 Monate';

  @override
  String get statisticsRangeOneYear => '1 Jahr';

  @override
  String get statisticsRangeAllTime => 'Gesamt';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag Übersicht';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag pro Tag';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag Über die Zeit';
  }

  @override
  String get chartGroupingLabel => 'Gruppieren nach';

  @override
  String get chartGroupingDay => 'Tag';

  @override
  String get chartGroupingWeek => 'Woche';

  @override
  String get chartGroupingMonth => 'Monat';

  @override
  String get chartGroupingYear => 'Jahr';

  @override
  String get chartSmoothingLabel => 'Glättung';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aktuell Serie $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Längste Serie $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Großartige Tage $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tage seit einem schlechten Tag $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Kann nicht auf externen Speicher zugreifen';

  @override
  String get errorExternalStorageAccessDescription =>
      'Wenn Sie Netzwerkspeicher verwenden, stellen Sie sicher, dass der Dienst online ist und Sie Zugriff auf das Netzwerk haben.\n\nAndernfalls hat die App möglicherweise die Berechtigungen für den externen Ordner verloren. Gehen Sie zu den Einstellungen und wählen Sie den externen Ordner erneut aus, um den Zugriff zu gewähren.\n\nAchtung: Änderungen werden erst synchronisiert, wenn Sie den Zugriff auf den externen Speicherort wiederherstellen!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Weiter mit lokaler Datenbank';

  @override
  String get databaseMigrationErrorTitle => 'Konnte Daten nicht verschieben';

  @override
  String get databaseMigrationErrorDescription =>
      'Deine Einträge sind sicher, konnten aber nicht in den Appspeicher verschoben werden.\n\nVersuche es erneut und melde das Problem, sofern es weiterhin auftritt.';

  @override
  String get databaseMigrationErrorRetry => 'Erneut versuchen';

  @override
  String get errorReport => 'Problem melden';

  @override
  String get lastModified => 'Geändert';

  @override
  String get writeSomethingHint => 'Schreibe etwas …';

  @override
  String get titleHint => 'Titel…';

  @override
  String get deleteLogTitle => 'Eintrag löschen';

  @override
  String get deleteLogDescription => 'Möchtest du diesen Eintrag löschen?';

  @override
  String get deletePhotoTitle => 'Foto löschen';

  @override
  String get deletePhotoDescription => 'Möchtest du das Foto löschen?';

  @override
  String get pageSettingsTitle => 'Einstellungen';

  @override
  String get settingsAppearanceTitle => 'Aussehen';

  @override
  String get settingsTheme => 'Farbschema';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Erster Tag der Woche';

  @override
  String get settingsCalendarSystem => 'Kalendersystem';

  @override
  String get calendarSystemGregorian => 'Gregorianisch';

  @override
  String get calendarSystemJalali => 'Jalali';

  @override
  String get settingsUseSystemAccentColor => 'System-Akzentfarbe verwenden';

  @override
  String get settingsCustomAccentColor => 'Eigene Akzentfarbe';

  @override
  String get settingsShowMarkdownToolbar => 'Zeige Markdown Werkzeugleiste';

  @override
  String get settingsShowFlashbacks => 'Zeige Rückblicke';

  @override
  String get settingsChangeMoodIcons => 'Stimmung-Symbole ändern';

  @override
  String get moodIconPrompt => 'Symbol hier eingeben';

  @override
  String get settingsFlashbacksViewLayout => 'Layout der Rückblicksansicht';

  @override
  String get settingsHideImagesInGallery => 'Bilder in der Galerie verbergen';

  @override
  String get settingsHideImages => 'Bilder verbergen';

  @override
  String get pageCalendarTitle => 'Kalender';

  @override
  String get settingsNotificationsTitle => 'Benachrichtigung';

  @override
  String get settingsDailyReminderOnboarding =>
      'Aktivieren Sie tägliche Erinnerungen um Konstant Einträge zu machen!';

  @override
  String get settingsNotificationsPermissionsPrompt =>
      'Die Berechtigung \"Planen von genauen Weckern\" wird angefragt, um eine Errinnerung an dich zu einer zufälligen Zeit oder zu deiner ausgewählten Zeit zu senden.';

  @override
  String get settingsDailyReminderTitle => 'Tägliche Erinnerung';

  @override
  String get settingsOnThisDayDescription => 'Erlebe alte Erinnerungen neu';

  @override
  String get settingsDailyReminderDescription =>
      'Eine kleine Erinnerung jeden Tag';

  @override
  String get settingsReminderTime => 'Erinnerungszeit';

  @override
  String get settingsFixedReminderTimeTitle => 'Feste Erinnerungszeit';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Wähle eine feste Zeit für die Erinnerung';

  @override
  String get settingsAlwaysSendReminderTitle => 'Erinnerung immer zeigen';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Sende Erinnerungen, auch wenn ein Eintrag schon angefangen wurde';

  @override
  String get settingsCustomizeNotificationTitle =>
      'Benachrichtigungen Bearbeiten';

  @override
  String get settingsTemplatesTitle => 'Vorlagen';

  @override
  String get settingsDefaultTemplate => 'Standardvorlage';

  @override
  String get manageTemplates => 'Vorlagen verwalten';

  @override
  String get addTemplate => 'Vorlage hinzufügen';

  @override
  String get newTemplate => 'Neu Vorlage';

  @override
  String get noTemplateTitle => 'Keine';

  @override
  String get noTemplatesDescription => 'Noch keine Vorlagen erstellt…';

  @override
  String get templateVariableTime => 'Uhrzeit';

  @override
  String get templateDefaultTimestampTitle => 'Zeitstempel';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Tageszusammenfassung';

  @override
  String get templateDefaultSummaryBody =>
      '### Zusammenfassung\n- \n\n### Zitat\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Rückblick';

  @override
  String get templateDefaultReflectionBody =>
      '### Was hat dir heute spaß gemachty?\n- \n\n### Wofür bist du heute Dankbar?\n- \n\n### Worauf Freist du dich?\n- ';

  @override
  String get settingsTagsTitle => 'Schlagwörter';

  @override
  String get manageTags => 'Schlagwörter verwalten';

  @override
  String get tagTypeLabelTitle => 'Beschriftung';

  @override
  String get tagTypeTrackerTitle => 'Tracker';

  @override
  String get nameHint => 'Name';

  @override
  String get tagColorLabel => 'Farbe';

  @override
  String get iconPickerTitle => 'Symbol wählen';

  @override
  String get iconPickerIconsTab => 'Symbole';

  @override
  String get iconPickerCustomTab => 'Benutzerdefiniert';

  @override
  String get iconPickerSearchHint => 'Symbole suchen…';

  @override
  String get colorPickerTitle => 'Farbe auswählen';

  @override
  String get colorPickerPaletteTab => 'Farben';

  @override
  String get iconGroupMoodPeople => 'Stimmung & Personen';

  @override
  String get iconGroupHealth => 'Gesundheit';

  @override
  String get iconGroupWorkFinance => 'Arbeit & Finanzen';

  @override
  String get iconGroupHabitsGoals => 'Gewohnheiten & Ziele';

  @override
  String get iconGroupNature => 'Natur';

  @override
  String get iconGroupFoodDrink => 'Essen & Trinken';

  @override
  String get iconGroupHome => 'Start';

  @override
  String get iconGroupTravel => 'Reisen';

  @override
  String get iconGroupSymbols => 'Symbole';

  @override
  String get tagCategoryLabel => 'Kategorie';

  @override
  String get tagLabel => 'Schlagwort';

  @override
  String get tagCategoryUncategorized => 'Nicht kategorisiert';

  @override
  String get newCategoryTitle => 'Neue Kategorie';

  @override
  String get shareButtonLabel => 'Teilen';

  @override
  String get importErrorDescription => 'Konnte Datei nicht importieren!';

  @override
  String get exportErrorDescription => 'Konnte Datei nicht exportieren!';

  @override
  String get deleteTitle => 'Löschen';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Es wird in $count Einträgen verwendet.',
      one: ' Es wird in 1 Eintrag verwendet.',
      zero: '',
    );
    return '„$name“ löschen?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Ihre $count Schlagwörter werden auch gelöscht.',
      one: ' Ihr 1 Schlagwort wird auch gelöscht.',
      zero: '',
    );
    return '„$name“ löschen?$_temp0';
  }

  @override
  String deleteTemplateMessage(Object name) {
    return 'Lösche „$name“?';
  }

  @override
  String get addTagsTitle => 'Schlagwörter hinzufügen';

  @override
  String get addTagsSearchHint => 'Schlagwörter suchen…';

  @override
  String get tagPickerSortManualLabel => 'Manuelle Reihenfolge';

  @override
  String get tagPickerSortUsageLabel => 'Sortiere nach Nutzung';

  @override
  String get tagFavoriteName => 'Favorit';

  @override
  String get tagEnergyName => 'Energie';

  @override
  String get tagCategoryActivitiesName => 'Aktivitäten';

  @override
  String get tagExerciseName => 'Übungen';

  @override
  String get tagSocializingName => 'Gemeinschaft';

  @override
  String get tagHobbyName => 'Hobby';

  @override
  String get tagEntertainmentName => 'Unterhaltung';

  @override
  String get tagDiningName => 'Essen gehen';

  @override
  String get tagChoresName => 'Hausarbeiten';

  @override
  String get tagCategoryEmotionsName => 'Emotionen';

  @override
  String get tagExcitedName => 'Aufgeregt';

  @override
  String get tagGratefulName => 'Dankbar';

  @override
  String get tagCalmName => 'Ruhig';

  @override
  String get tagTiredName => 'Müde';

  @override
  String get tagAnxiousName => 'Ängstlich';

  @override
  String get tagAnnoyedName => 'Genervt';

  @override
  String get welcomeLogBodyText =>
      '## Welcome to AID Diary\n\n> Every day is worth remembering.\n\nWrite what happened, how you felt, and where you were. Your entries stay on this device.\n\n- **Journal** lists every entry by day\n- **Calendar**, **Media** and **Atlas** look back by date, photo and place\n- **Coach** offers prompts and templates when you don\'t know what to write\n\nAID Diary is a modified version of [Daily You](https://github.com/Demizo/Daily_You) by Demizo and contributors, and not the official Daily You app.';

  @override
  String get settingsStorageTitle => 'Speicher';

  @override
  String get settingsImageQuality => 'Bildqualität';

  @override
  String get imageQualityHigh => 'Hoch';

  @override
  String get imageQualityMedium => 'Mittel';

  @override
  String get imageQualityLow => 'Niedrig';

  @override
  String get imageQualityNoCompression => 'Keine Komprimierung';

  @override
  String get settingsLogFolder => 'Einträge Ordner';

  @override
  String get settingsImageFolder => 'Bild Ordner';

  @override
  String get warningTitle => 'Achtung';

  @override
  String get logFolderWarningDescription =>
      'Wenn der ausgewählte Ordner bereits eine \'daily_you.db\'-Datei enthält, wird diese verwendet, um Ihre bestehenden Einträge zu überschreiben!';

  @override
  String get errorTitle => 'Fehler';

  @override
  String get logFolderErrorDescription =>
      'Eintragsordneränderung fehlgeschlagen!';

  @override
  String get imageFolderErrorDescription =>
      'Bilderordneränderung fehlgeschlagen!';

  @override
  String get backupErrorDescription => 'Sicherung Fehlgeschlagen!';

  @override
  String get restoreErrorDescription =>
      'Wiederherstellung der Sicherung Fehlgeschlagen!';

  @override
  String get settingsBackupRestoreTitle => 'Sichern & Wiederherstellen';

  @override
  String get settingsBackup => 'Sicherung';

  @override
  String get settingsRestore => 'Wiederherstellen';

  @override
  String get settingsRestorePromptDescription =>
      'Wiederherstellung einer Sicherung überschreibt vorhandene Daten!';

  @override
  String get settingsBackupPasswordProtect => 'Password Protect Backups';

  @override
  String get backupEncryptedTitle => 'Encrypted Backup';

  @override
  String get backupEncryptedContent => 'This backup is password protected.';

  @override
  String get settingsAutoBackup => 'Automatic Backups';

  @override
  String get settingsAutoBackupLocation => 'Backup Location';

  @override
  String get settingsAutoBackupInterval => 'Backup Interval';

  @override
  String get settingsAutoBackupIntervalDaily => 'Daily';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Weekly';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Monthly';

  @override
  String get settingsAutoBackupMaxCount => 'Backups To Keep';

  @override
  String get settingsAutoBackupRequireCharging => 'Only While Charging';

  @override
  String settingsBackupLast(Object time) {
    return 'Last backup $time';
  }

  @override
  String get settingsBackupNever => 'Never backed up';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Next backup $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'All';

  @override
  String get autoBackupFailedTitle => 'Backup Failed';

  @override
  String tranferStatus(Object percent) {
    return 'Übertragen... $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Erstelle Backup... $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Stelle Sicherung wieder her... $percent%';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return 'Encrypting Backup… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Decrypting Backup… $percent%';
  }

  @override
  String get cleanUpStatus => 'Aufräumen…';

  @override
  String migratingImagesStatus(Object current, Object total) {
    return 'Übertrage Fotos… $current/$total';
  }

  @override
  String get settingsExport => 'Exportieren';

  @override
  String get settingsExportToAnotherFormat => 'In anderes Format exportieren';

  @override
  String get settingsExportFormatDescription =>
      'Das sollte nicht als Backup verwendet werden!';

  @override
  String get exportLogs => 'Einträge Exportieren';

  @override
  String get exportImages => 'Bilder Exportieren';

  @override
  String get settingsImport => 'Importieren';

  @override
  String get settingsImportFromAnotherApp => 'Aus anderen App importieren';

  @override
  String get settingsTranslateCallToAction =>
      'Jede*r sollte das Recht auf einen Eintrag haben!';

  @override
  String get settingsHelpTranslate => 'Hilf übersetzen';

  @override
  String get importLogs => 'Einträge Importieren';

  @override
  String get importImages => 'Bilder Importieren';

  @override
  String get logFormatTitle => 'Format Auswählen';

  @override
  String get logFormatDescription =>
      'Die Formate anderer Apps könnten ggf. nicht alle Funktionen beinhalten. Bitte melde alle Probleme, da Formate anderer Apps sich jederzeit ändern können. Das wird sich nicht auf aktuelle Einträge auswirken!';

  @override
  String get formatDailyYouJson => 'Daily You (JSON)';

  @override
  String get formatDaybook => 'Daybook';

  @override
  String get formatDaylio => 'Daylio';

  @override
  String get formatDiarium => 'Diarium';

  @override
  String get formatDiaro => 'Diaro';

  @override
  String get formatMyBrain => 'My Brain';

  @override
  String get formatOneShot => 'OneShot';

  @override
  String get formatPixels => 'Pixels';

  @override
  String get formatMarkdown => 'Markdown';

  @override
  String get settingsDeleteAllLogsTitle => 'Alle Einträge löschen';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Möchtest du alle Einträge löschen?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Zum Bestätigen gib \'$prompt\' ein. Das kann nicht rückgängig gemacht werden!';
  }

  @override
  String get settingsLanguageTitle => 'Sprache';

  @override
  String get settingsAppLanguageTitle => 'App Sprache';

  @override
  String get settingsOverrideAppLanguageTitle => 'Überschreibe App Sprache';

  @override
  String get settingsSecurityTitle => 'Sicherheit';

  @override
  String get settingsSecurityRequirePassword => 'Benötige Passwort';

  @override
  String get settingsSecurityEnterPassword => 'Passwort eingeben';

  @override
  String get settingsSecuritySetPassword => 'Passwort setzen';

  @override
  String get settingsSecurityChangePassword => 'Ändere Passwort';

  @override
  String get settingsSecurityPassword => 'Passwort';

  @override
  String get settingsSecurityConfirmPassword => 'Bestätige Passwort';

  @override
  String get settingsSecurityOldPassword => 'Altes Passwort';

  @override
  String get settingsSecurityIncorrectPassword => 'Falsches Passwort';

  @override
  String get settingsSecurityPasswordsDoNotMatch =>
      'Passwörter sind nicht identisch';

  @override
  String get requiredPrompt => 'Notwendig';

  @override
  String get settingsSecurityBiometricUnlock => 'Biometrisch Entsperren';

  @override
  String get unlockAppPrompt => 'App entsperren';

  @override
  String get settingsAboutTitle => 'Über';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsLicense => 'Lizenz';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsSourceCode => 'Quellcode';

  @override
  String get settingsOpenSourceLicenses => 'Open Source Licenses';

  @override
  String get settingsMadeWithLove => 'Mit ❤️ gemacht';

  @override
  String get settingsConsiderSupporting => 'unterstützen';

  @override
  String get imagesTitle => 'Bilder';

  @override
  String get tagMoodTitle => 'Stimmung';

  @override
  String get calendarTagDisplayLabel => 'Schlagwort';

  @override
  String get selectTagTitle => 'Schlagwort wählen';

  @override
  String get labelPresentLabel => 'Anwesend';

  @override
  String get labelAbsentLabel => 'Abwesend';

  @override
  String get labelCoverageLabel => 'Abdeckung';

  @override
  String chartDistributionTitle(Object tag) {
    return '$tag-Verteilung';
  }

  @override
  String get shareAddToLogPickerTitle => 'Choose a log';

  @override
  String get adaptiveEmptyDay => 'No entries for this day yet';

  @override
  String get adaptiveNewEntry => 'Write an entry';

  @override
  String get pageJournalTitle => 'Journal';

  @override
  String get coachPrompt1 => 'What made you smile today?';

  @override
  String get coachPrompt2 => 'What is one thing you learned today?';

  @override
  String get coachPrompt3 => 'Who did you talk to today, and how did it feel?';

  @override
  String get coachPrompt4 => 'What are you grateful for right now?';

  @override
  String get coachPrompt5 => 'What took most of your energy today?';

  @override
  String get coachPrompt6 => 'Describe a small moment you want to remember.';

  @override
  String get coachPrompt7 => 'What would make tomorrow a good day?';

  @override
  String get coachPrompt8 => 'What has been on your mind lately?';

  @override
  String get coachPrompt9 => 'What did you do today just for yourself?';

  @override
  String get coachPrompt10 => 'If today had a title, what would it be?';

  @override
  String entryReadingTime(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count min read',
      one: '1 min read',
    );
    return '$_temp0';
  }

  @override
  String get pageMediaTitle => 'Media';

  @override
  String get pageAtlasTitle => 'Atlas';

  @override
  String get pageCoachTitle => 'Coach';

  @override
  String get noEntrySelected => 'No entry selected.';

  @override
  String get profileLocalOnly => 'Your diary stays on this device';

  @override
  String get entryShare => 'Share';

  @override
  String get entryFavorite => 'Star';

  @override
  String get entryEdit => 'Edit';

  @override
  String get entryPrevious => 'Previous entry';

  @override
  String get entryNext => 'Next entry';

  @override
  String get journalStories => 'Stories';

  @override
  String get journalEntries => 'Entries';

  @override
  String get journalEmptyHint => 'Begin your diary by adding a new entry.';

  @override
  String get storyToday => 'Today';

  @override
  String get storyThrowback => 'Throwback';

  @override
  String get storyNoThrowback => 'No throwback today';

  @override
  String get mediaFiles => 'Media files';

  @override
  String get mediaEmpty => 'No photos yet.';

  @override
  String get mediaEmptyHint => 'Photos attached to entries will be shown here.';

  @override
  String get atlasEmpty => 'No entries with a location.';

  @override
  String get atlasEmptyHint => 'Entries with a location will be shown here.';

  @override
  String get atlasShowAll => 'Show all entries';

  @override
  String get coachAll => 'All';

  @override
  String get coachPrograms => 'Programs';

  @override
  String get coachTemplates => 'Templates';

  @override
  String get coachKindProgram => 'Program';

  @override
  String get coachKindTemplate => 'Template';

  @override
  String get coachNoTemplates => 'No programs or templates.';

  @override
  String get coachUseTemplate => 'Write with this template';

  @override
  String get coachProgramEverydayTitle => 'Everyday moments';

  @override
  String get coachProgramEverydayDescription =>
      'Five short questions, one a day. Each takes a minute or two and helps you see what made the day yours. A gentle way to build the habit of writing a little every day.';

  @override
  String get coachProgramReflectTitle => 'Looking inward';

  @override
  String get coachProgramReflectDescription =>
      'One deeper question a week, for five weeks. Take your time with each: how you have been feeling, what wears you out, what you are grateful for.';

  @override
  String get searchFilters => 'Filters';

  @override
  String get searchFilterTags => 'Tags';

  @override
  String get searchFilterStarred => 'Starred';

  @override
  String get searchHint => 'Type to search, or pick a filter.';

  @override
  String get locationTitle => 'Location';

  @override
  String get locationName => 'Place name';

  @override
  String get locationRemove => 'Remove';

  @override
  String get locationServiceDisabled => 'Location services are turned off.';

  @override
  String get locationPermissionDenied => 'Location permission was denied.';

  @override
  String get locationUnavailable => 'Could not get the current location.';

  @override
  String get calendarJumpToToday => 'Jump to today';

  @override
  String get editorStartWriting => 'Start writing or choose a ';

  @override
  String get editorTemplateLink => 'Template';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Choose a template';

  @override
  String get templateFeatured => 'Featured templates';

  @override
  String get templateMine => 'My templates';

  @override
  String get templateDailyName => 'Daily review';

  @override
  String get templateDailyDescription =>
      'What happened, how it felt, and what comes next.';

  @override
  String get templateDailyText =>
      '## What happened today\n\n\n## How I felt\n\n\n## Three things I\'m grateful for\n1. \n2. \n3. \n\n## Tomorrow\n';

  @override
  String get templateTravelName => 'Travel log';

  @override
  String get templateTravelDescription =>
      'Places, moments and food from the road.';

  @override
  String get templateTravelText =>
      '## Where I went\n\n\n## The moment I remember most\n\n\n## What I ate\n\n\n## Plans for tomorrow\n';

  @override
  String get templateReadingName => 'Reading notes';

  @override
  String get templateReadingDescription =>
      'Quotes and thoughts from what you read.';

  @override
  String get templateReadingText =>
      '## Book\n\n\n## Where I am\n\n\n## Quotes\n> \n\n## My thoughts\n';

  @override
  String get templateWeeklyName => 'Weekly review';

  @override
  String get templateWeeklyDescription =>
      'Highlights, struggles and next week\'s focus.';

  @override
  String get templateWeeklyText =>
      '## Highlights\n\n\n## What was hard\n\n\n## What I learned\n\n\n## Focus for next week\n';

  @override
  String get entryDuplicate => 'Duplicate';

  @override
  String get entryDuplicated => 'Entry duplicated';

  @override
  String get entrySaveAsTemplate => 'Save as template';

  @override
  String get entrySavedAsTemplate => 'Saved as a template';

  @override
  String get storyStatistics => 'Statistics';

  @override
  String get storyMoodChart => 'Mood chart';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return '$entries entries · $days days';
  }

  @override
  String get storyThisYear => 'This year';

  @override
  String get storyLastYear => 'Last year';

  @override
  String get storyTapToOpen => 'Tap a day to open it';

  @override
  String get settingsGeneralTitle => 'General';

  @override
  String get settingsDataTitle => 'Data & storage';

  @override
  String get settingsStoriesTitle => 'Stories';

  @override
  String get settingsHelpTitle => 'Help & about';

  @override
  String get weatherTitle => 'Weather';

  @override
  String get weatherClear => 'Clear';

  @override
  String get weatherPartlyCloudy => 'Partly cloudy';

  @override
  String get weatherCloudy => 'Cloudy';

  @override
  String get weatherFog => 'Fog';

  @override
  String get weatherDrizzle => 'Drizzle';

  @override
  String get weatherRain => 'Rain';

  @override
  String get weatherSnow => 'Snow';

  @override
  String get weatherStorm => 'Thunderstorm';

  @override
  String get weatherFetch => 'Get weather for this entry';

  @override
  String get weatherNeedsLocation => 'Add a location with coordinates first.';

  @override
  String get weatherUnavailable =>
      'Weather is unavailable for this place and time.';

  @override
  String get weatherRemove => 'Remove weather';

  @override
  String get activityTitle => 'Activity';

  @override
  String get activityStill => 'Still';

  @override
  String get activityWalking => 'Walking';

  @override
  String get activityRunning => 'Running';

  @override
  String get activityCycling => 'Cycling';

  @override
  String get activityVehicle => 'In a vehicle';

  @override
  String get activityFlying => 'Flying';

  @override
  String get activityExercise => 'Exercise';

  @override
  String get activityDetect => 'Detect current activity';

  @override
  String get activityDetectFailed => 'Couldn\'t detect an activity.';

  @override
  String get activityRemove => 'Remove activity';

  @override
  String get settingsAutoAddTitle => 'Add automatically';

  @override
  String get settingsAutoAddLocation => 'Location';

  @override
  String get settingsAutoAddWeather => 'Weather';

  @override
  String get settingsAutoAddActivity => 'Activity';

  @override
  String get settingsAutoAddHint =>
      'New entries get these filled in when they are created.';

  @override
  String get settingsTemperatureUnit => 'Temperature unit';

  @override
  String get settingsCelsius => 'Celsius (°C)';

  @override
  String get settingsFahrenheit => 'Fahrenheit (°F)';

  @override
  String get moodGreat => 'Great';

  @override
  String get moodGood => 'Good';

  @override
  String get moodOkay => 'Okay';

  @override
  String get moodBad => 'Bad';

  @override
  String get moodAwful => 'Awful';

  @override
  String get locationSearchHint => 'Search for a place';

  @override
  String get locationSearchEmpty => 'No places found';

  @override
  String get settingsWallpaper => 'Wallpaper';

  @override
  String get wallpaperNone => 'None';

  @override
  String get wallpaperDots => 'Dots';

  @override
  String get wallpaperGrid => 'Grid';

  @override
  String get wallpaperLines => 'Lines';

  @override
  String get wallpaperPhoto => 'Photo…';

  @override
  String get settingsFontFamily => 'Font';

  @override
  String get fontSystem => 'System';

  @override
  String get fontSerif => 'Serif';

  @override
  String get fontMono => 'Monospace';

  @override
  String get settingsFontSize => 'Font size';

  @override
  String get fontSizeSmall => 'Small';

  @override
  String get fontSizeMedium => 'Medium';

  @override
  String get fontSizeLarge => 'Large';

  @override
  String get fontSizeExtraLarge => 'Extra large';

  @override
  String get settingsLineSpacing => 'Line spacing';

  @override
  String get lineSpacingCompact => 'Compact';

  @override
  String get lineSpacingNormal => 'Normal';

  @override
  String get lineSpacingRelaxed => 'Relaxed';

  @override
  String get moodAssociationsTitle => 'What makes me feel…';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching of $total entries';
  }

  @override
  String get videoRecord => 'Record a video';

  @override
  String get videoChoose => 'Choose a video';

  @override
  String get audioRecordTitle => 'Record a voice note';

  @override
  String get audioChoose => 'Choose an audio file';

  @override
  String get audioStart => 'Record';

  @override
  String get audioStop => 'Stop and save';

  @override
  String get audioPermissionDenied =>
      'Microphone access is off. Allow it in the system settings.';

  @override
  String get mediaTooLarge => 'This video is too large to attach.';

  @override
  String get mediaUnavailable =>
      'This attachment is not available on this device.';

  @override
  String get widgetDone => 'Today\'s entry is written';

  @override
  String get widgetPending => 'How was your day?';

  @override
  String get widgetWrite => 'Write';

  @override
  String get insertChecklist => 'Checklist';

  @override
  String get insertNumberedList => 'Numbered list';

  @override
  String get insertTable => 'Table';

  @override
  String get insertDivider => 'Divider';

  @override
  String get insertCodeBlock => 'Code block';

  @override
  String get journalSortTitle => 'Sort entries';

  @override
  String get journalSortUpdated => 'Last updated';

  @override
  String get settingsTimeFormat => 'Time format';

  @override
  String get timeFormat12 => '12-hour';

  @override
  String get timeFormat24 => '24-hour';

  @override
  String get settingsReminderDays => 'Remind me on';

  @override
  String get locationRecent => 'Recent places';

  @override
  String get shareImage => 'Share image';

  @override
  String get shareSaveImage => 'Save image';

  @override
  String get shareSaved => 'Image saved';

  @override
  String get deletedTitle => 'Recently deleted';

  @override
  String get deletedNone => 'Nothing deleted recently';

  @override
  String deletedHint(int days) {
    return 'Deleted entries stay here for $days days, then are erased.';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days days left';
  }

  @override
  String get deletedRestore => 'Restore';

  @override
  String get deletedDeleteForever => 'Delete forever';

  @override
  String get deletedDeleteForeverDescription =>
      'The entry and its attachments are erased. This cannot be undone.';

  @override
  String get deletedEmpty => 'Empty';

  @override
  String get deletedEmptyDescription =>
      'Erase every entry in Recently deleted? This cannot be undone.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Random walk';

  @override
  String get randomSubtitle => 'Open a past entry';

  @override
  String get randomNext => 'Another';

  @override
  String get randomAll => 'All';

  @override
  String get randomWithPhotos => 'With photos';

  @override
  String get randomGoodDays => 'Good days';

  @override
  String get randomEmpty => 'No entries to pick from';

  @override
  String get reviewWeekTitle => 'This week';

  @override
  String get reviewWeekSubtitle => 'Your week so far';

  @override
  String get reviewYearTitle => 'This year';

  @override
  String get reviewEmpty => 'Nothing written yet';

  @override
  String get reviewEntries => 'Entries';

  @override
  String get reviewDaysWritten => 'Days written';

  @override
  String get reviewWords => 'Words';

  @override
  String get reviewPhotos => 'Photos';

  @override
  String get reviewLongestRun => 'Longest run of days';

  @override
  String get reviewAverageMood => 'Average mood';

  @override
  String get reviewFavorites => 'Most often';

  @override
  String get reviewByMonth => 'By month';

  @override
  String get reviewHighlight => 'Highlight';

  @override
  String get yearInPixels => 'Year in pixels';

  @override
  String get capsuleSeal => 'Seal as a time capsule';

  @override
  String get capsuleTitle => 'Time capsule';

  @override
  String capsuleOpensOn(Object date) {
    return 'Opens on $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Written on $date';
  }

  @override
  String get capsuleOpenEarly => 'Open early';

  @override
  String get capsuleOpenEarlyDescription =>
      'The capsule opens now and stays open.';

  @override
  String get capsuleOpened => 'Time capsule opened';

  @override
  String get templateMorningName => 'Morning pages';

  @override
  String get templateMorningDescription => 'Set up the day in three minutes';

  @override
  String get templateMorningText =>
      '## Three things I want to do well today\n1. \n2. \n3. \n\n## Something I look forward to\n\n## A note to myself\n';

  @override
  String get templateEveningName => 'Evening review';

  @override
  String get templateEveningDescription => 'Close the day with what went well';

  @override
  String get templateEveningText =>
      '## Three good things today\n1. \n2. \n3. \n\n## What I learned\n\n## What could go better tomorrow\n';

  @override
  String get routineMorning => 'Good morning';

  @override
  String get routineEvening => 'Evening review';

  @override
  String get settingsRoutinePrompts => 'Morning and evening prompts';

  @override
  String get settingsRoutinePromptsHint =>
      'Suggest the morning or evening template in Stories';

  @override
  String get checkInTitle => 'Quick check-in';

  @override
  String get checkInSubtitle => 'Mood in two taps';

  @override
  String get checkInMood => 'How do you feel?';

  @override
  String get checkInActivity => 'What are you doing?';

  @override
  String get checkInNote => 'A line about it (optional)';

  @override
  String get checkInSave => 'Save';

  @override
  String editorWordCount(int words, int characters) {
    return '$words words · $characters characters';
  }

  @override
  String get coachProgramEverydayTagline => 'Notice the small things in a day.';

  @override
  String get coachProgramReflectTagline => 'Slow down and listen to yourself.';

  @override
  String get coachDuration => 'Duration';

  @override
  String get coachInterval => 'Interval';

  @override
  String get coachDifficulty => 'Difficulty';

  @override
  String get coachIntervalDaily => 'Daily';

  @override
  String get coachIntervalWeekly => 'Weekly';

  @override
  String get coachDifficultyBeginner => 'Beginner';

  @override
  String get coachDifficultyIntermediate => 'Intermediate';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks',
      one: '1 week',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'Day $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Week $n';
  }

  @override
  String get coachEnroll => 'Enroll';

  @override
  String get coachEndProgram => 'End program';

  @override
  String get coachAuthor => 'Author';

  @override
  String get coachAuthorBio => 'Prompts written for this app.';

  @override
  String get coachEnrolledTip =>
      'All set! Your questions will show up in Stories.';

  @override
  String get coachGoToStories => 'Go to Stories';

  @override
  String get coachAnswerHint => 'Write your answer…';

  @override
  String get storyWrapUp => 'That\'s all for today.';

  @override
  String get storyTapToClose => 'Tap to close';

  @override
  String get coachAnswerDone => 'Done';

  @override
  String get coachAnswered => 'Answered, tap to open';

  @override
  String get coachAnsweredEarlier => 'Answered';

  @override
  String get locationLocating => 'Locating…';

  @override
  String get locationPickPlace => 'Pick a place';

  @override
  String get locationPlacesHint => 'Address or name of the place';

  @override
  String get locationCustom => 'Custom place';

  @override
  String get locationCurrent => 'Current location';

  @override
  String get locationSaved => 'Saved places';

  @override
  String get locationSearchResults => 'Search results';

  @override
  String get locationNearby => 'Nearby places';

  @override
  String get locationRename => 'Rename';

  @override
  String get locationSavePlace => 'Save place';

  @override
  String get locationUnsavePlace => 'Remove from saved places';

  @override
  String get shareAs => 'Share as…';

  @override
  String get shareAsImage => 'Image';

  @override
  String get shareAsZip => 'ZIP with the original media';

  @override
  String get shareAsPlainText => 'Plain text';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Welcome to AID Diary';

  @override
  String get onboardWelcomeText =>
      'A quiet place for your days. Tap Next to look around.';

  @override
  String get onboardIntroTitle => 'Write a little, remember a lot';

  @override
  String get onboardIntroText =>
      'Photos, places, weather and moods sit beside your words. Stories bring old days back.';

  @override
  String get onboardPrivateTitle => 'Safe and private';

  @override
  String get onboardPrivateText =>
      'Your diary stays on this device. Add a passcode to keep it to yourself.';

  @override
  String get onboardPrivateAction => 'Set a passcode';

  @override
  String get onboardNotifyTitle => 'A gentle reminder';

  @override
  String get onboardNotifyText =>
      'Turn on reminders to build the habit; coach programs tell you when a new question is ready.';

  @override
  String get onboardNotifyAction => 'Turn on reminders';

  @override
  String get onboardNotifyOn => 'Reminders are on';

  @override
  String get onboardDoneTitle => 'All set';

  @override
  String get onboardDoneText =>
      'Start with today: what is one thing you want to remember?';

  @override
  String get onboardNext => 'Next';

  @override
  String get onboardBack => 'Back';

  @override
  String get onboardStart => 'Start writing';

  @override
  String get onboardSkip => 'Skip';

  @override
  String get helpFaq => 'Frequently asked questions';

  @override
  String get helpFaq1Q => 'Where is my diary stored?';

  @override
  String get helpFaq1A =>
      'Only on this device, in the app\'s own folder. Nothing is uploaded; there is no account.';

  @override
  String get helpFaq2Q => 'How do I keep a copy or move to a new device?';

  @override
  String get helpFaq2A =>
      'Settings → Data & storage → Backup & Restore makes one file with entries, photos and settings, optionally with a password. Restore it on the new device. Backups can also run on a schedule.';

  @override
  String get helpFaq3Q => 'Can I bring in entries from other diary apps?';

  @override
  String get helpFaq3A =>
      'Yes: in Settings → Data & storage, import exports from Daylio, Diarium, Diaro, DayBook, My Brain, OneShot and Pixels, or a Daily You JSON file.';

  @override
  String get helpFaq4Q => 'How do coach programs work?';

  @override
  String get helpFaq4A =>
      'Enroll in a program on the Coach page. Each day or week a new question waits in Stories; your answer is saved as an entry.';

  @override
  String get helpFaq5Q => 'What if I forget my passcode?';

  @override
  String get helpFaq5A =>
      'The passcode cannot be recovered, so keep a backup of your diary.';

  @override
  String get helpPrivacy => 'Privacy';

  @override
  String get helpPrivacyText =>
      'Entries, photos and settings never leave this device unless you share or back them up. The app only goes online for map tiles and place names (OpenStreetMap, Nominatim, Overpass) and weather (Open-Meteo), sending coordinates or a place name, never your writing.';

  @override
  String get photoMetaTitle => 'Use the photo\'s details?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Change this entry\'s time to $date and its place to $place, as recorded in the photo?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Change this entry\'s time to $date, when the photo was taken?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Set this entry\'s place to $place, where the photo was taken?';
  }

  @override
  String get photoMetaApply => 'Use them';

  @override
  String get quickWriteTitle => 'Quick write';

  @override
  String get quickWriteText => 'Tap to start a new entry.';

  @override
  String get settingsQuickWriteTitle => 'Quick write in notifications';

  @override
  String get settingsQuickWriteDescription =>
      'Keep a notification that opens a new entry.';

  @override
  String get settingsNudgesTitle => 'Nudge me after a quiet stretch';

  @override
  String settingsNudgesDescription(int days) {
    return 'A gentle reminder when you haven\'t written for $days days.';
  }

  @override
  String get nudgeTitle => 'It\'s been a while';

  @override
  String get nudgeMonday => 'A new week: what are you looking forward to?';

  @override
  String get nudgeTuesday => 'Two lines are enough. How are you today?';

  @override
  String get nudgeWednesday =>
      'Halfway through the week. What stood out so far?';

  @override
  String get nudgeThursday => 'Anything small worth keeping from today?';

  @override
  String get nudgeFriday => 'The week is wrapping up. Note one good moment.';

  @override
  String get nudgeSaturday => 'A slow Saturday is a good day to write.';

  @override
  String get nudgeSunday => 'Look back on the week before it ends.';

  @override
  String get photoWidgetEmpty => 'Photos you add to entries show up here.';
}
