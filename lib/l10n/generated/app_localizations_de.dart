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
  String get themeColorTitle => 'Themenfarbe';

  @override
  String get themeColorHint => 'Wählen Sie eine Farbe für diese Palette.';

  @override
  String get themeColorBlue => 'Himmelblau';

  @override
  String get themeColorGreen => 'Waldgrün';

  @override
  String get themeColorBrown => 'Warmer Kaffee';

  @override
  String get themeColorPurple => 'Lavendel';

  @override
  String get themeColorRose => 'Staubige Rose';

  @override
  String get themeColorAmber => 'Bernstein';

  @override
  String get themeColorPreview => 'Jeden Tag ein bisschen';

  @override
  String get themeTintBackgroundTitle =>
      'Tönen Sie Hintergründe mit der Themenfarbe';

  @override
  String get themeTintBackgroundHint =>
      'Für neutrale graue Hintergründe deaktivieren; Die Knöpfe behalten die gewählte Farbe.';

  @override
  String get dailyReminderTitle => 'Heute eintragen!';

  @override
  String get dailyReminderDescription => 'Mache deinen Eintrag …';

  @override
  String get actionTakePhoto => 'Foto machen';

  @override
  String get flashbacksTitle => 'Rückblicke';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Schließe schlechte Tage aus';

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
  String get settingsShowFlashbacks => 'Zeige Rückblicke';

  @override
  String get settingsChangeMoodIcons => 'Stimmung-Symbole ändern';

  @override
  String get moodIconPrompt => 'Symbol hier eingeben';

  @override
  String get settingsHideImages => 'Bilder verbergen';

  @override
  String get pageCalendarTitle => 'Kalender';

  @override
  String get settingsNotificationsTitle => 'Benachrichtigung';

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
  String get manageTemplates => 'Vorlagen verwalten';

  @override
  String get noTemplateTitle => 'Keine';

  @override
  String get noTemplatesDescription => 'Noch keine Vorlagen erstellt…';

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
  String get tagNameExists => 'Es gibt bereits einen Tag mit diesem Namen';

  @override
  String get categoryNameExists =>
      'Es gibt bereits eine Kategorie mit diesem Namen';

  @override
  String deleteTemplateMessage(Object name) {
    return 'Lösche „$name“?';
  }

  @override
  String get addTagsTitle => 'Schlagwörter hinzufügen';

  @override
  String get addTagsSearchHint => 'Schlagwörter suchen…';

  @override
  String get tagFavoriteName => 'Favorit';

  @override
  String get iconGroupActivities => 'Aktivitäten';

  @override
  String get iconGroupHobbies => 'Unterhaltung';

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
      'Wenn der ausgewählte Ordner bereits eine \'aid_diary.db\'-Datei enthält, wird diese verwendet, um Ihre bestehenden Einträge zu überschreiben!';

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
  String get settingsBackupPasswordProtect => 'Passwortgeschützte Backups';

  @override
  String get backupEncryptedTitle => 'Verschlüsseltes Backup';

  @override
  String get backupEncryptedContent => 'Dieses Backup ist passwortgeschützt.';

  @override
  String get settingsAutoBackup => 'Automatische Backups';

  @override
  String get settingsAutoBackupLocation => 'Backup-Speicherort';

  @override
  String get settingsAutoBackupInterval => 'Sicherungsintervall';

  @override
  String get settingsAutoBackupIntervalDaily => 'Täglich';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Wöchentlich';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Monatlich';

  @override
  String get settingsAutoBackupMaxCount => 'Backups zum Aufbewahren';

  @override
  String get settingsAutoBackupRequireCharging =>
      'Nur während des Ladevorgangs';

  @override
  String settingsBackupLast(Object time) {
    return 'Letzte Sicherung $time';
  }

  @override
  String get settingsBackupNever => 'Nie gesichert';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Nächstes Backup $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'Alle';

  @override
  String get autoBackupFailedTitle => 'Sicherung fehlgeschlagen';

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
    return 'Backup verschlüsseln… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Backup entschlüsseln… $percent%';
  }

  @override
  String get cleanUpStatus => 'Aufräumen…';

  @override
  String get settingsExportToAnotherFormat => 'In anderes Format exportieren';

  @override
  String get settingsExportFormatDescription =>
      'Das sollte nicht als Backup verwendet werden!';

  @override
  String get settingsImportFromAnotherApp => 'Aus anderen App importieren';

  @override
  String get logFormatTitle => 'Format Auswählen';

  @override
  String get logFormatDescription =>
      'Die Formate anderer Apps könnten ggf. nicht alle Funktionen beinhalten. Bitte melde alle Probleme, da Formate anderer Apps sich jederzeit ändern können. Das wird sich nicht auf aktuelle Einträge auswirken!';

  @override
  String get formatDayOne => 'Day One';

  @override
  String get formatDaybook => 'Daybook';

  @override
  String get formatDaylio => 'Daylio';

  @override
  String get formatDiarium => 'Diarium';

  @override
  String get formatDiaro => 'Diaro';

  @override
  String get formatJourney => 'Journey';

  @override
  String get formatMyBrain => 'My Brain';

  @override
  String get formatOneDiary => 'One Diary';

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
  String get settingsAppLanguageTitle => 'App Sprache';

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
  String get settingsOpenSourceLicenses => 'Open-Source-Lizenzen';

  @override
  String get tagMoodTitle => 'Stimmung';

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
  String get shareAddToLogPickerTitle => 'Wählen Sie einen Tagebucheintrag';

  @override
  String get adaptiveEmptyDay => 'Für diesen Tag gibt es noch keine Einträge';

  @override
  String get adaptiveNewEntry => 'Schreiben Sie einen Eintrag';

  @override
  String get pageJournalTitle => 'Tagebuch';

  @override
  String get coachPrompt1 => 'Was hat dich heute zum Lächeln gebracht?';

  @override
  String get coachPrompt2 => 'Was haben Sie heute gelernt?';

  @override
  String get coachPrompt3 =>
      'Mit wem haben Sie heute gesprochen und wie hat sich das angefühlt?';

  @override
  String get coachPrompt4 => 'Wofür bist du gerade dankbar?';

  @override
  String get coachPrompt5 => 'Was hat Ihnen heute am meisten Energie gekostet?';

  @override
  String get coachPrompt6 =>
      'Beschreiben Sie einen kleinen Moment, an den Sie sich erinnern möchten.';

  @override
  String get coachPrompt7 => 'Was würde morgen zu einem guten Tag machen?';

  @override
  String get coachPrompt8 => 'Was ging Ihnen in letzter Zeit durch den Kopf?';

  @override
  String get coachPrompt9 => 'Was hast du heute nur für dich getan?';

  @override
  String get coachPrompt10 =>
      'Wenn es heute einen Titel gäbe, welcher wäre dieser?';

  @override
  String get pageMediaTitle => 'Medien';

  @override
  String get pageAtlasTitle => 'Atlas';

  @override
  String get pageCoachTitle => 'Trainer';

  @override
  String get noEntrySelected => 'Kein Eintrag ausgewählt.';

  @override
  String get entryShare => 'Teilen';

  @override
  String get entryFavorite => 'Stern';

  @override
  String get entryEdit => 'Bearbeiten';

  @override
  String get entryPrevious => 'Vorheriger Eintrag';

  @override
  String get entryNext => 'Nächster Eintrag';

  @override
  String get journalStories => 'Geschichten';

  @override
  String get journalEntries => 'Einträge';

  @override
  String get journalEmptyHint =>
      'Beginnen Sie Ihr Tagebuch, indem Sie einen neuen Eintrag hinzufügen.';

  @override
  String get storyToday => 'Heute';

  @override
  String get storyThrowback => 'Rückblick';

  @override
  String get storyNoThrowback => 'Kein Rückblick heute';

  @override
  String get mediaFiles => 'Mediendateien';

  @override
  String get mediaEmpty => 'Noch keine Fotos.';

  @override
  String get mediaEmptyHint =>
      'Den Einträgen beigefügte Fotos werden hier angezeigt.';

  @override
  String get atlasEmpty => 'Keine Einträge mit Ortsangabe.';

  @override
  String get atlasEmptyHint => 'Hier werden Einträge mit Ortsangabe angezeigt.';

  @override
  String get atlasShowAll => 'Alle Einträge anzeigen';

  @override
  String get atlasMyLocation => 'Mein Standort';

  @override
  String get coachAll => 'Alle';

  @override
  String get coachPrograms => 'Programme';

  @override
  String get coachTemplates => 'Vorlagen';

  @override
  String get coachKindProgram => 'Programm';

  @override
  String get coachKindTemplate => 'Vorlage';

  @override
  String get coachNoTemplates => 'Keine Programme oder Vorlagen.';

  @override
  String get coachUseTemplate => 'Schreiben Sie mit dieser Vorlage';

  @override
  String get coachProgramEverydayTitle => 'Alltägliche Momente';

  @override
  String get coachProgramEverydayDescription =>
      'Fünf kurze Fragen, eine pro Tag. Jeder dauert ein oder zwei Minuten und hilft Ihnen zu erkennen, was den Tag zu Ihrem gemacht hat. Eine sanfte Möglichkeit, es sich zur Gewohnheit zu machen, jeden Tag ein wenig zu schreiben.';

  @override
  String get coachProgramReflectTitle => 'Nach innen schauen';

  @override
  String get coachProgramReflectDescription =>
      'Eine tiefergehende Frage pro Woche, fünf Wochen lang. Nehmen Sie sich Zeit für alles: wie Sie sich gefühlt haben, was Sie ermüdet, wofür Sie dankbar sind.';

  @override
  String get searchFilters => 'Filter';

  @override
  String get searchFilterTags => 'Schlagworte';

  @override
  String get searchFilterStarred => 'Mit einem Stern versehen';

  @override
  String get searchHint =>
      'Geben Sie ein, um zu suchen, oder wählen Sie einen Filter aus.';

  @override
  String get locationTitle => 'Standort';

  @override
  String get locationName => 'Ortsname';

  @override
  String get locationRemove => 'Entfernen';

  @override
  String get locationServiceDisabled => 'Ortungsdienste sind deaktiviert.';

  @override
  String get locationPermissionDenied =>
      'Die Standortgenehmigung wurde verweigert.';

  @override
  String get locationUnavailable =>
      'Der aktuelle Standort konnte nicht ermittelt werden.';

  @override
  String get calendarJumpToToday => 'Springe zum heutigen Tag';

  @override
  String get editorStartWriting =>
      'Beginnen Sie mit dem Schreiben oder wählen Sie ein ';

  @override
  String get editorTemplateLink => 'Vorlage';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Wählen Sie eine Vorlage';

  @override
  String get templateFeatured => 'Empfohlene Vorlagen';

  @override
  String get templateMine => 'Meine Vorlagen';

  @override
  String get templateDailyName => 'Täglicher Rückblick';

  @override
  String get templateDailyDescription =>
      'Was ist passiert, wie es sich angefühlt hat und was als nächstes kommt.';

  @override
  String get templateDailyText =>
      '## Was heute passiert ist\n\n\n## Wie ich mich fühlte\n\n\n## Drei Dinge, für die ich dankbar bin\n1. \n2. \n3. \n\n## Morgen\n';

  @override
  String get templateTravelName => 'Reisetagebucheintrag';

  @override
  String get templateTravelDescription =>
      'Orte, Momente und Essen von unterwegs.';

  @override
  String get templateTravelText =>
      '## Wo ich hingegangen bin\n\n\n## Der Moment, an den ich mich am meisten erinnere\n\n\n## Was ich gegessen habe\n\n\n## Pläne für morgen\n';

  @override
  String get templateReadingName => 'Notizen lesen';

  @override
  String get templateReadingDescription =>
      'Zitate und Gedanken aus dem, was Sie gelesen haben.';

  @override
  String get templateReadingText =>
      '## Buch\n\n\n## Wo ich bin\n\n\n## Zitate\n> \n\n## Meine Gedanken\n';

  @override
  String get templateWeeklyName => 'Wöchentlicher Rückblick';

  @override
  String get templateWeeklyDescription =>
      'Höhepunkte, Schwierigkeiten und der Fokus der nächsten Woche.';

  @override
  String get templateWeeklyText =>
      '## Highlights\n\n\n## Was war schwer\n\n\n## Was ich gelernt habe\n\n\n## Konzentrieren Sie sich auf die nächste Woche\n';

  @override
  String get entrySaveAsTemplate => 'Als Vorlage speichern';

  @override
  String get entrySavedAsTemplate => 'Als Vorlage gespeichert';

  @override
  String get storyStatistics => 'Statistiken';

  @override
  String get storyMoodChart => 'Stimmungsdiagramm';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return '$entries Einträge · $days Tage';
  }

  @override
  String get storyThisYear => 'Dieses Jahr';

  @override
  String get storyLastYear => 'Letztes Jahr';

  @override
  String get storyTapToOpen => 'Tippen Sie auf einen Tag, um ihn zu öffnen';

  @override
  String get settingsGeneralTitle => 'Allgemein';

  @override
  String get settingsDataTitle => 'Daten & Speicherung';

  @override
  String get settingsStoriesTitle => 'Geschichten';

  @override
  String get settingsHelpTitle => 'Hilfe & Info';

  @override
  String get weatherTitle => 'Wetter';

  @override
  String get weatherClear => 'Klar';

  @override
  String get weatherPartlyCloudy => 'Teilweise bewölkt';

  @override
  String get weatherCloudy => 'Bewölkt';

  @override
  String get weatherFog => 'Nebel';

  @override
  String get weatherDrizzle => 'Nieselregen';

  @override
  String get weatherRain => 'Regen';

  @override
  String get weatherSnow => 'Schnee';

  @override
  String get weatherStorm => 'Gewitter';

  @override
  String get weatherFetch => 'Holen Sie sich das Wetter für diesen Eintrag';

  @override
  String get weatherNeedsLocation =>
      'Fügen Sie zunächst einen Standort mit Koordinaten hinzu.';

  @override
  String get weatherUnavailable =>
      'Für diesen Ort und diese Zeit ist kein Wetter verfügbar.';

  @override
  String get weatherRemove => 'Wetter entfernen';

  @override
  String get activityTitle => 'Aktivität';

  @override
  String get activityStill => 'Trotzdem';

  @override
  String get activityWalking => 'Gehen';

  @override
  String get activityRunning => 'Laufen';

  @override
  String get activityCycling => 'Radfahren';

  @override
  String get activityVehicle => 'In einem Fahrzeug';

  @override
  String get activityFlying => 'Fliegen';

  @override
  String get activityExercise => 'Übung';

  @override
  String get activityDetect => 'Aktuelle Aktivität erkennen';

  @override
  String get activityDetectFailed =>
      'Es konnte keine Aktivität erkannt werden.';

  @override
  String get activityRemove => 'Aktivität entfernen';

  @override
  String get settingsAutoAddTitle => 'Automatisch hinzufügen';

  @override
  String get settingsAutoAddLocation => 'Standort';

  @override
  String get settingsAutoAddWeather => 'Wetter';

  @override
  String get settingsAutoAddHint =>
      'Neue Einträge werden beim Erstellen ausgefüllt.';

  @override
  String get settingsTemperatureUnit => 'Temperatureinheit';

  @override
  String get settingsCelsius => 'Celsius (°C)';

  @override
  String get settingsFahrenheit => 'Fahrenheit (°F)';

  @override
  String get moodGreat => 'Großartig';

  @override
  String get moodGood => 'Gut';

  @override
  String get moodOkay => 'Okay';

  @override
  String get moodBad => 'Schlecht';

  @override
  String get moodAwful => 'Schrecklich';

  @override
  String get locationSearchHint => 'Suchen Sie nach einem Ort';

  @override
  String get locationSearchEmpty => 'Keine Orte gefunden';

  @override
  String get settingsWallpaper => 'Tapete';

  @override
  String get wallpaperNone => 'Keine';

  @override
  String get wallpaperDots => 'Punkte';

  @override
  String get wallpaperGrid => 'Gitter';

  @override
  String get wallpaperLines => 'Linien';

  @override
  String get wallpaperPhoto => 'Foto…';

  @override
  String get settingsFontFamily => 'Schriftart';

  @override
  String get fontSystem => 'System';

  @override
  String get fontSerif => 'Serife';

  @override
  String get fontMono => 'Monospace';

  @override
  String get settingsFontSize => 'Schriftgröße';

  @override
  String get fontSizeSmall => 'Klein';

  @override
  String get fontSizeMedium => 'Mittel';

  @override
  String get fontSizeLarge => 'Groß';

  @override
  String get fontSizeExtraLarge => 'Extra groß';

  @override
  String get settingsLineSpacing => 'Zeilenabstand';

  @override
  String get lineSpacingCompact => 'Kompakt';

  @override
  String get lineSpacingNormal => 'Normal';

  @override
  String get lineSpacingRelaxed => 'Entspannt';

  @override
  String get moodAssociationsTitle => 'Was gibt mir das Gefühl...';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching von $total-Einträgen';
  }

  @override
  String get videoRecord => 'Nehmen Sie ein Video auf';

  @override
  String get videoChoose => 'Wählen Sie ein Video';

  @override
  String get audioRecordTitle => 'Nehmen Sie eine Sprachnotiz auf';

  @override
  String get audioChoose => 'Wählen Sie eine Audiodatei';

  @override
  String get audioStart => 'Aufnahme';

  @override
  String get audioStop => 'Stoppen und speichern';

  @override
  String get audioPermissionDenied =>
      'Der Mikrofonzugriff ist deaktiviert. Erlauben Sie es in den Systemeinstellungen.';

  @override
  String get mediaTooLarge => 'Dieses Video ist zu groß zum Anhängen.';

  @override
  String get mediaUnavailable =>
      'Dieser Anhang ist auf diesem Gerät nicht verfügbar.';

  @override
  String get widgetDone => 'Der heutige Eintrag ist geschrieben';

  @override
  String get widgetPending => 'Wie war dein Tag?';

  @override
  String get widgetWrite => 'Schreiben';

  @override
  String get insertChecklist => 'Checkliste';

  @override
  String get insertNumberedList => 'Nummerierte Liste';

  @override
  String get insertTable => 'Tisch';

  @override
  String get insertDivider => 'Teiler';

  @override
  String get insertCodeBlock => 'Codeblock';

  @override
  String get journalSortTitle => 'Einträge sortieren';

  @override
  String get journalSortUpdated => 'Zuletzt aktualisiert';

  @override
  String get settingsTimeFormat => 'Zeitformat';

  @override
  String get settingsDayStart => 'Neue Einträge gelten für den Vortag bis';

  @override
  String get settingsDayAskUntil => 'Dann fragen Sie, bis zu welchem Tag';

  @override
  String get settingsDayStartMidnight => 'Aus';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Jeder Eintrag behält den Tag, zu dem er gehört, neben der Zeit, zu der er geschrieben wurde, und Sie können diesen Tag im Editor jederzeit ändern. Diese Stunden wählen nur den Tag für neue Einträge aus, sodass durch eine Änderung kein vorhandener Eintrag verschoben wird.';

  @override
  String get lateNightBadge =>
      'Spät in der Nacht geschrieben, gezählt für den Vortag';

  @override
  String editorDayAsk(String time) {
    return 'Geschrieben bei $time. Für welchen Tag ist es?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (gestern)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (heute)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'Geschrieben $when';
  }

  @override
  String get timeFormat12 => '12 Stunden';

  @override
  String get timeFormat24 => '24 Stunden';

  @override
  String get settingsReminderDays => 'Erinnere mich daran';

  @override
  String get locationRecent => 'Aktuelle Orte';

  @override
  String get shareImage => 'Bild teilen';

  @override
  String get shareSaveImage => 'Bild speichern';

  @override
  String get shareSaved => 'Bild gespeichert';

  @override
  String get deletedTitle => 'Kürzlich gelöscht';

  @override
  String get deletedNone => 'Kürzlich wurde nichts gelöscht';

  @override
  String deletedHint(int days) {
    return 'Gelöschte Einträge bleiben $days Tage lang hier und werden dann gelöscht.';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days verbleibende Tage';
  }

  @override
  String get deletedRestore => 'Wiederherstellen';

  @override
  String get deletedDeleteForever => 'Für immer löschen';

  @override
  String get deletedDeleteForeverDescription =>
      'Der Eintrag und seine Anhänge werden gelöscht. Dies kann nicht rückgängig gemacht werden.';

  @override
  String get deletedEmpty => 'Leer';

  @override
  String get deletedEmptyDescription =>
      'Jeden Eintrag in „Zuletzt gelöscht?“ löschen. Dies kann nicht rückgängig gemacht werden.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Zufälliger Spaziergang';

  @override
  String get randomSubtitle => 'Öffnen Sie einen früheren Eintrag';

  @override
  String get randomNext => 'Ein anderer';

  @override
  String get randomAll => 'Alle';

  @override
  String get randomWithPhotos => 'Mit Fotos';

  @override
  String get randomGoodDays => 'Gute Tage';

  @override
  String get randomEmpty => 'Keine Einträge zur Auswahl';

  @override
  String get reviewWeekTitle => 'Diese Woche';

  @override
  String get reviewWeekSubtitle => 'Deine Woche bisher';

  @override
  String get reviewYearTitle => 'Dieses Jahr';

  @override
  String get reviewEmpty => 'Noch nichts geschrieben';

  @override
  String get reviewEntries => 'Einträge';

  @override
  String get reviewDaysWritten => 'Tage geschrieben';

  @override
  String get reviewWords => 'Worte';

  @override
  String get reviewPhotos => 'Fotos';

  @override
  String get reviewLongestRun => 'Längste Anzahl von Tagen';

  @override
  String get reviewAverageMood => 'Durchschnittliche Stimmung';

  @override
  String get reviewFavorites => 'Am häufigsten';

  @override
  String get reviewByMonth => 'Monatlich';

  @override
  String get reviewHighlight => 'Hervorheben';

  @override
  String get yearInPixels => 'Jahr in Pixel';

  @override
  String get capsuleSeal => 'Als Zeitkapsel versiegeln';

  @override
  String get capsuleTitle => 'Zeitkapsel';

  @override
  String capsuleOpensOn(Object date) {
    return 'Öffnet am $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Geschrieben am $date';
  }

  @override
  String get capsuleOpenEarly => 'Früh geöffnet';

  @override
  String get capsuleOpenEarlyDescription =>
      'Die Kapsel öffnet sich nun und bleibt offen.';

  @override
  String get capsuleOpened => 'Zeitkapsel geöffnet';

  @override
  String get templateMorningName => 'Morgenseiten';

  @override
  String get templateMorningDescription =>
      'Richten Sie den Tag in drei Minuten ein';

  @override
  String get templateMorningText =>
      '## Drei Dinge, die ich heute gut machen möchte\n1. \n2. \n3. \n\n## Etwas, auf das ich mich freue\n\n## Eine Anmerkung an mich selbst\n';

  @override
  String get templateEveningName => 'Abendrückblick';

  @override
  String get templateEveningDescription =>
      'Schließen Sie den Tag mit dem ab, was gut gelaufen ist';

  @override
  String get templateEveningText =>
      '## Drei gute Dinge heute\n1. \n2. \n3. \n\n## Was ich gelernt habe\n\n## Was könnte morgen besser laufen\n';

  @override
  String get routineMorning => 'Guten Morgen';

  @override
  String get routineEvening => 'Abendrückblick';

  @override
  String get settingsRoutinePrompts => 'Morgen- und Abendaufforderungen';

  @override
  String get settingsRoutinePromptsHint =>
      'Schlagen Sie in Stories die Morgen- oder Abendvorlage vor';

  @override
  String get checkInTitle => 'Schneller Check-in';

  @override
  String get checkInSubtitle => 'Stimmung in zwei Schritten';

  @override
  String get checkInMood => 'Wie fühlst du dich?';

  @override
  String get checkInActivity => 'Was machst du?';

  @override
  String get checkInNote => 'Eine Zeile dazu (optional)';

  @override
  String get checkInSave => 'Speichern';

  @override
  String editorWordCount(int words, int characters) {
    return '$words Wörter · $characters Zeichen';
  }

  @override
  String get coachProgramEverydayTagline =>
      'Beachten Sie die kleinen Dinge an einem Tag.';

  @override
  String get coachProgramReflectTagline =>
      'Machen Sie es langsamer und hören Sie auf sich selbst.';

  @override
  String get coachDuration => 'Dauer';

  @override
  String get coachInterval => 'Intervall';

  @override
  String get coachDifficulty => 'Schwierigkeit';

  @override
  String get coachIntervalDaily => 'Täglich';

  @override
  String get coachIntervalWeekly => 'Wöchentlich';

  @override
  String get coachDifficultyBeginner => 'Anfänger';

  @override
  String get coachDifficultyIntermediate => 'Mittelstufe';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage',
      one: '$count Tag',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Wochen',
      one: '$count Woche',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'Tag $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Woche $n';
  }

  @override
  String get coachEnroll => 'Melden Sie sich an';

  @override
  String get coachEndProgram => 'Programm beenden';

  @override
  String get coachAuthor => 'Autor';

  @override
  String get coachAuthorBio =>
      'Für diese App geschriebene Eingabeaufforderungen.';

  @override
  String get coachEnrolledTip =>
      'Alles klar! Ihre Fragen werden in Stories angezeigt.';

  @override
  String get coachGoToStories => 'Gehen Sie zu Geschichten';

  @override
  String get coachAnswerHint => 'Schreiben Sie Ihre Antwort ...';

  @override
  String get storyWrapUp => 'Das ist alles für heute.';

  @override
  String get storyTapToClose => 'Zum Schließen tippen';

  @override
  String get coachAnswerDone => 'Fertig';

  @override
  String get coachAnswered => 'Beantwortet, zum Öffnen tippen';

  @override
  String get coachAnsweredEarlier => 'Beantwortet';

  @override
  String get locationLocating => 'Lokalisieren…';

  @override
  String get locationPickPlace => 'Wählen Sie einen Ort';

  @override
  String get locationPlacesHint => 'Adresse oder Name des Ortes';

  @override
  String get locationCustom => 'Benutzerdefinierter Ort';

  @override
  String get locationCurrent => 'Aktueller Standort';

  @override
  String get locationSaved => 'Gespeicherte Orte';

  @override
  String get locationSearchResults => 'Suchergebnisse';

  @override
  String get locationNearby => 'Orte in der Nähe';

  @override
  String get locationRename => 'Umbenennen';

  @override
  String get locationSavePlace => 'Platz speichern';

  @override
  String get locationUnsavePlace => 'Aus gespeicherten Orten entfernen';

  @override
  String get shareAs => 'Teilen als…';

  @override
  String get shareAsImage => 'Bild';

  @override
  String get shareAsZip => 'ZIP mit dem Originalmedium';

  @override
  String get shareAsPlainText => 'Klartext';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Willkommen bei AID Diary';

  @override
  String get onboardWelcomeText =>
      'Beginnen Sie hier oder verbinden Sie dieses Gerät mit einem, das Sie bereits verwenden.';

  @override
  String get onboardStart => 'Fangen Sie an zu schreiben';

  @override
  String get helpFaq => 'Häufig gestellte Fragen';

  @override
  String get helpFaq1Q => 'Wo wird mein Tagebuch gespeichert?';

  @override
  String get helpFaq1A =>
      'Ihr Tagebuch wird auf diesem Gerät gespeichert. Es erreicht andere Geräte oder Speicher nur, wenn Sie die Synchronisierung, Freigabe oder den Export aktivieren. Die Synchronisierung erfolgt Ende-zu-Ende-verschlüsselt.';

  @override
  String get helpFaq2Q =>
      'Wie behalte ich eine Kopie oder wechsle auf ein neues Gerät?';

  @override
  String get helpFaq2A =>
      'Stellen Sie unter Einstellungen → Daten & Speicher → Synchronisieren eine Verbindung zu einem vorhandenen Gerät her und bestätigen Sie die Autorisierung auf dem Gerät, auf dem sich Ihr Tagebuch befindet. Beide Geräte bleiben nutzbar. Sie können auch ein Backup erstellen und es auf einem anderen Gerät wiederherstellen.';

  @override
  String get helpFaq3Q =>
      'Kann ich Einträge aus anderen Tagebuch-Apps übernehmen?';

  @override
  String get helpFaq3A =>
      'Ja: Importieren Sie unter Einstellungen → Daten & Speicher Exporte aus Daylio, Diarium, Diaro, DayBook, My Brain, OneShot und Pixels oder einen JSON-Export.';

  @override
  String get helpFaq4Q => 'Wie funktionieren Coach-Programme?';

  @override
  String get helpFaq4A =>
      'Melden Sie sich auf der Coach-Seite für ein Programm an. Jeden Tag oder jede Woche wartet in Stories eine neue Frage auf Sie. Ihre Antwort wird als Eintrag gespeichert.';

  @override
  String get helpFaq5Q => 'Was passiert, wenn ich meinen Passcode vergesse?';

  @override
  String get helpFaq5A =>
      'Der Passcode kann nicht wiederhergestellt werden. Bewahren Sie daher eine Sicherungskopie Ihres Tagebuchs auf.';

  @override
  String get helpPrivacy => 'Privatsphäre';

  @override
  String get helpPrivacyText =>
      'Tagebuchinhalte und Medien bleiben auf diesem Gerät, es sei denn, Sie aktivieren die verschlüsselte Synchronisierung oder teilen/exportieren sie. Karten, Ortssuche und Wetter nutzen die konfigurierten Dienste und senden den Standort oder die Suchanfrage, die für diese Anfrage erforderlich ist, keinen Tagebuchtext.';

  @override
  String get photoMetaTitle => 'Die Details des Fotos verwenden?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Zählen Sie diesen Eintrag für $date und setzen Sie seinen Platz auf $place, wie auf dem Foto aufgezeichnet?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Zählen Sie diesen Eintrag für $date, wann wurde das Foto aufgenommen?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Stellen Sie den Ort dieses Eintrags auf $place ein. Wo wurde das Foto aufgenommen?';
  }

  @override
  String get photoMetaApply => 'Benutze sie';

  @override
  String get quickWriteTitle => 'Schnell schreiben';

  @override
  String get quickWriteText => 'Tippen Sie, um einen neuen Eintrag zu starten.';

  @override
  String get settingsQuickWriteTitle =>
      'Schreiben Sie schnell Benachrichtigungen ein';

  @override
  String get settingsQuickWriteDescription =>
      'Behalten Sie eine Benachrichtigung bei, die einen neuen Eintrag öffnet.';

  @override
  String get settingsNudgesTitle => 'Stupse mich nach einer ruhigen Strecke an';

  @override
  String settingsNudgesDescription(int days) {
    return 'Eine sanfte Erinnerung, wenn Sie seit $days Tagen nicht geschrieben haben.';
  }

  @override
  String get nudgeTitle => 'Es ist schon eine Weile her';

  @override
  String get nudgeMonday => 'Eine neue Woche: Worauf freust du dich?';

  @override
  String get nudgeTuesday => 'Zwei Zeilen reichen aus. Wie geht es dir heute?';

  @override
  String get nudgeWednesday => 'Mitte der Woche. Was ist bisher aufgefallen?';

  @override
  String get nudgeThursday =>
      'Gibt es irgendetwas Kleines, das es wert ist, von heute behalten zu werden?';

  @override
  String get nudgeFriday =>
      'Die Woche geht zu Ende. Beachten Sie einen guten Moment.';

  @override
  String get nudgeSaturday =>
      'Ein langsamer Samstag ist ein guter Tag zum Schreiben.';

  @override
  String get nudgeSunday =>
      'Schauen Sie noch einmal auf die Woche zurück, bevor sie zu Ende geht.';

  @override
  String get photoWidgetEmpty =>
      'Fotos, die Sie zu Einträgen hinzufügen, werden hier angezeigt.';

  @override
  String get channelReminders => 'Erinnerungen';

  @override
  String get channelOnThisDay => 'An diesem Tag';

  @override
  String get channelCoach => 'Coach-Eingabeaufforderungen';

  @override
  String get channelNudges => 'Stupser nach ruhigen Tagen';

  @override
  String get channelQuickWrite => 'Schnell schreiben';

  @override
  String get channelBackup => 'Backups';

  @override
  String get formatJsonExport => 'JSON (AID Diary-Export)';

  @override
  String get aboutModifiedNotice =>
      'Eine modifizierte Version von Daily You von Demizo und Mitwirkenden. Es handelt sich nicht um die offizielle Daily You-App.';

  @override
  String get toolbarPhotos => 'Fügen Sie Fotos hinzu';

  @override
  String get toolbarMedia => 'Fotos und Videos';

  @override
  String get mediaFromGallery => 'Wählen Sie aus der Galerie';

  @override
  String get mediaFromFiles => 'Wählen Sie aus Dateien';

  @override
  String get editorLeaveTitle => 'Diesen Eintrag speichern?';

  @override
  String get editorLeaveDiscard => 'Sparen Sie nicht';

  @override
  String get editorTitleHint => 'Titel';

  @override
  String get editorLocating => 'Lokalisieren…';

  @override
  String get toolbarVideo => 'Video';

  @override
  String get toolbarAudio => 'Sprachnotiz';

  @override
  String get toolbarTags => 'Schlagworte';

  @override
  String get toolbarBulletList => 'Liste mit Aufzählungszeichen';

  @override
  String get toolbarHeading => 'Überschrift';

  @override
  String get toolbarBold => 'Fett';

  @override
  String get toolbarItalic => 'Kursiv';

  @override
  String get toolbarHighlight => 'Hervorheben';

  @override
  String get toolbarStrikethrough => 'Durchgestrichen';

  @override
  String get toolbarQuote => 'Zitat';

  @override
  String get toolbarLink => 'Link';

  @override
  String get toolbarInsert => 'Einfügen';

  @override
  String get toolbarUndo => 'Rückgängig machen';

  @override
  String get toolbarRedo => 'Wiederholen';

  @override
  String get toolbarInsertDate => 'Geben Sie das Datum ein';

  @override
  String get toolbarInsertTime => 'Geben Sie die Uhrzeit ein';

  @override
  String get settingsSyncTitle => 'Cloud-Synchronisierung';

  @override
  String get syncOffDescription =>
      'Halten Sie dieses Tagebuch auf allen Ihren Geräten über Google Drive oder einen WebDAV-Server wie Nextcloud, Synology oder Jianguoyun gleich.';

  @override
  String get syncUseGoogleDrive => 'Mit Google Drive synchronisieren';

  @override
  String get syncOrWebDav => 'Oder ein WebDAV-Server';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn =>
      'Angemeldet. Sie können zu AID Diary zurückkehren.';

  @override
  String get syncGoogleSignInAgain =>
      'Bei Google müssen Sie sich erneut anmelden.';

  @override
  String get syncSignInAgain => 'Melden Sie sich erneut an';

  @override
  String get settingsCommandLineTitle => 'Befehlszeile';

  @override
  String get commandLineToggle => 'Befehlszeilenschnittstelle';

  @override
  String get commandLineToggleHint =>
      'Ermöglicht dem Hilfsbefehl und anderen Programmen auf diesem Gerät, die Befehle der App zu verwenden.';

  @override
  String get commandLineAlwaysOn => 'In Entwicklungs-Builds immer aktiviert.';

  @override
  String commandLineListening(int port) {
    return 'Lauschen auf Port $port';
  }

  @override
  String get commandPaletteTitle => 'Alle Befehle';

  @override
  String get commandPaletteSearch => 'Suchbefehle';

  @override
  String get commandPaletteRun => 'Lauf';

  @override
  String get commandPaletteConfirm =>
      'Dies lässt sich nicht einfach rückgängig machen. Ausführen?';

  @override
  String syncReceiving(int done, int total) {
    return 'Empfang von $done von $total…';
  }

  @override
  String syncSending(int done, int total) {
    return 'Senden von $done von $total…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'Der Zugriff auf Google Drive war nicht erlaubt. Stellen Sie erneut eine Verbindung her und kreuzen Sie auf der Google-Seite Google Drive an.';

  @override
  String get syncEntryUnsynced =>
      'Nicht synchronisiert: Die letzte Synchronisierung wurde nicht durchgeführt';

  @override
  String get syncUseOfficial => 'Verwenden Sie den AID-Synchronisierungsserver';

  @override
  String get syncServer => 'Serveradresse';

  @override
  String get syncUsername => 'Benutzername';

  @override
  String get syncPassword => 'Passwort';

  @override
  String get syncConnect => 'Verbinden';

  @override
  String get syncConnecting => 'Verbinden…';

  @override
  String get syncSignInFailed =>
      'Anmeldung fehlgeschlagen. Überprüfen Sie die Adresse, den Benutzernamen und das Passwort.';

  @override
  String syncConnectFailed(String error) {
    return 'Es konnte keine Verbindung hergestellt werden: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Beginnen Sie mit der Synchronisierung';

  @override
  String get syncNewSpaceDescription =>
      'Es gibt hier noch kein synchronisiertes Tagebuch. Dieses Tagebuch wird hochgeladen und mit einem Schlüssel Ende-zu-Ende-verschlüsselt, der auf Ihren Geräten verbleibt.';

  @override
  String get syncJoinTitle => 'Treten Sie dem synchronisierten Tagebuch bei';

  @override
  String get syncWrongKey =>
      'Dieser Wiederherstellungscode öffnet das synchronisierte Tagebuch nicht.';

  @override
  String syncLastSynced(String time) {
    return 'Zuletzt synchronisiert $time';
  }

  @override
  String get syncNever => 'Noch nicht synchronisiert';

  @override
  String get syncSyncing => 'Synchronisierung…';

  @override
  String syncFailed(String error) {
    return 'Die letzte Synchronisierung ist fehlgeschlagen: $error';
  }

  @override
  String get syncLocked =>
      'Das synchronisierte Tagebuch gehört jetzt zu anderen Geräten oder wurde neu gestartet. Koppeln Sie mit einem von ihnen oder verwenden Sie den Wiederherstellungscode, um die Synchronisierung fortzusetzen.';

  @override
  String get syncNow => 'Jetzt synchronisieren';

  @override
  String get syncUnlock => 'Entsperren';

  @override
  String get syncEncrypted => 'Ende-zu-Ende verschlüsselt';

  @override
  String get syncDisconnect => 'Stoppen Sie die Synchronisierung';

  @override
  String get syncDisconnectDescription =>
      'Dieses Gerät stoppt die Synchronisierung. Das Tagebuch hier und die synchronisierte Kopie bleiben unverändert.';

  @override
  String get syncOwnRecoveryPassword =>
      'Verwenden Sie mein eigenes Wiederherstellungskennwort';

  @override
  String get syncRecoveryPassword => 'Wiederherstellungspasswort';

  @override
  String get syncRecoveryPasswordRepeat =>
      'Wiederholen Sie das Wiederherstellungskennwort';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Verwenden Sie mindestens $min-Zeichen';
  }

  @override
  String get syncRecoveryPasswordMismatch =>
      'Die Passwörter sind unterschiedlich';

  @override
  String get syncRecoveryCode => 'Wiederherstellungscode';

  @override
  String get syncRecoveryCodeTitle =>
      'Speichern Sie Ihren Wiederherstellungscode';

  @override
  String get syncRecoveryCodeDescription =>
      'Wenn jedes Ihrer Geräte verloren geht, stellt dieser Code Ihr synchronisiertes Tagebuch wieder her. Bewahren Sie es in einem Passwort-Manager oder auf Papier auf. Es wird nur einmal angezeigt.';

  @override
  String get syncRecoveryCodeCopied => 'Wiederherstellungscode kopiert';

  @override
  String get syncRecoveryCodeSaved => 'Ich habe es gespeichert';

  @override
  String get syncJoinNeedsKey =>
      'Dieses synchronisierte Tagebuch gehört zu Ihren anderen Geräten. Koppeln Sie es mit einem von ihnen oder verwenden Sie den Wiederherstellungscode. Die Einträge auf diesem Gerät werden hinzugefügt.';

  @override
  String get syncPairDevice => 'Mit einem Gerät koppeln';

  @override
  String get syncUseRecoveryCode => 'Verwenden Sie den Wiederherstellungscode';

  @override
  String get syncAddDevice => 'Fügen Sie ein Gerät hinzu';

  @override
  String get syncChangeRecoveryCode => 'Ändern Sie den Wiederherstellungscode';

  @override
  String get syncChangeRecoveryDescription =>
      'Ein neuer Code ersetzt den aktuellen, der nicht mehr funktioniert. Ihre Daten und andere Geräte bleiben unverändert.';

  @override
  String get syncNewRandomCode => 'Neuer Zufallscode';

  @override
  String get syncRecoveryCodeChanged => 'Wiederherstellungscode geändert';

  @override
  String get syncResetSpace =>
      'Starten Sie das synchronisierte Tagebuch erneut';

  @override
  String get syncResetSpaceDescription =>
      'Nur wenn kein Gerät und kein Wiederherstellungscode es mehr öffnet: Die synchronisierte Kopie wird durch das Tagebuch auf diesem Gerät unter den Schlüsseln dieses Geräts ersetzt. Ihre anderen Geräte koppeln sich dann erneut.';

  @override
  String get syncPairTitle => 'Geräte koppeln';

  @override
  String get syncPairShow => 'Zeigen Sie einen Code an';

  @override
  String get syncPairEnter => 'Geben Sie einen Code ein';

  @override
  String get syncPairShowHint =>
      'Öffnen Sie auf Ihrem anderen Gerät „Geräte koppeln“, wählen Sie „Code eingeben“ und geben Sie diesen ein oder scannen Sie ihn.';

  @override
  String get syncPairEnterHint =>
      'Geben Sie den Code ein, den Ihr anderes Gerät anzeigt, oder scannen Sie ihn.';

  @override
  String get syncPairCode => 'Pairing-Code';

  @override
  String get syncPairScan => 'Scannen';

  @override
  String get syncPairStart => 'Paar';

  @override
  String get syncPairWaiting => 'Warten auf das andere Gerät…';

  @override
  String syncPairDone(String device) {
    return 'Gepaart mit $device';
  }

  @override
  String get syncPairWrongCode =>
      'Der Code stimmte nicht überein. Zeigen Sie einen neuen Code an und versuchen Sie es erneut.';

  @override
  String get syncPairNoOffer =>
      'Kein Gerät zeigt diesen Code an. Möglicherweise ist es abgelaufen.';

  @override
  String get syncPairTimedOut =>
      'Das andere Gerät antwortete nicht rechtzeitig.';

  @override
  String get syncPairNeither =>
      'Auf keinem der Geräte ist dieses synchronisierte Tagebuch eingerichtet.';

  @override
  String get syncPairBoth =>
      'Beide Geräte öffnen dieses synchronisierte Tagebuch bereits.';

  @override
  String syncPairFailed(String error) {
    return 'Kopplung fehlgeschlagen: $error';
  }

  @override
  String get syncMediaPending =>
      'Tagebuch synchronisiert · Einige Medien werden noch übertragen';

  @override
  String get syncWaitingForDevices =>
      'Tagebuch synchronisiert · Warten auf die Übertragung von Medien durch ein anderes Gerät';

  @override
  String get syncCacheNotice =>
      'Cloud-Medien sind vorübergehend. Bewahren Sie die Originale auf Ihren Geräten auf; Die Synchronisierung ist kein Backup.';

  @override
  String get paperTitle => 'Briefpapier';

  @override
  String get paperPlain => 'Einfach';

  @override
  String get paperLined => 'Gefüttert';

  @override
  String get paperGrid => 'Gitter';

  @override
  String get paperTinted => 'Getönt';

  @override
  String get paperDecorationTitle => 'Dekorationen';

  @override
  String get paperDecorationNone => 'Keine';

  @override
  String get paperDecorationBotanical => 'Blätter';

  @override
  String get paperDecorationStars => 'Sterne';

  @override
  String get paperDecorationWashi => 'Washi-Tape';

  @override
  String get themeDarkChoice => 'Dunkles Aussehen';

  @override
  String get themeDarkSame => 'Folgen Sie der Lichtpalette';

  @override
  String get themeDarkCustom => 'Separate Palette';

  @override
  String get themeDarkAccent => 'Dunkle Akzentfarbe';

  @override
  String get themeColorTeal => 'Blaugrün';

  @override
  String get themeColorCyan => 'Cyan';

  @override
  String get themeColorIndigo => 'Indigo';

  @override
  String get themeColorCoral => 'Koralle';

  @override
  String get themeColorOlive => 'Olive';

  @override
  String get themeColorSlate => 'Schiefer';

  @override
  String get drawingTitle => 'Zeichnen';

  @override
  String get drawingPen => 'Stift';

  @override
  String get drawingEraser => 'Radiergummi';

  @override
  String get drawingUndo => 'Rückgängig machen';

  @override
  String get drawingClear => 'Klar';

  @override
  String get drawingWidth => 'Stiftbreite';

  @override
  String get drawingStylusOnly => 'Nur Stift';

  @override
  String get drawingDiscardTitle => 'Zeichnung verwerfen?';

  @override
  String get drawingDiscardBody => 'Diese Zeichnung wurde nicht gespeichert.';

  @override
  String get drawingSaveError =>
      'Die Zeichnung konnte nicht gespeichert werden.';

  @override
  String get syncNetworkTitle => 'Netzwerkdiagnose';

  @override
  String get syncNetworkRefresh => 'Aktualisieren';

  @override
  String get syncNetworkSelectedRoute => 'Aktueller Pfad';

  @override
  String get syncNetworkAvailableRoutes => 'Verfügbare Pfade';

  @override
  String get syncNetworkSignaling => 'Geräteverzeichnisverbindung';

  @override
  String get syncNetworkRelayRemaining => 'Verbleibendes Staffelgeld';

  @override
  String get syncNetworkIcePair => 'Direktverbindungskandidaten';

  @override
  String get syncNetworkPeerTrusted => 'Authentifiziertes Gerät';

  @override
  String get syncNetworkNoRoute => 'Warten auf eine Verbindung';

  @override
  String get syncNetworkUnavailable => 'Die Diagnose ist nicht verfügbar';

  @override
  String get syncMediaCopiesTitle => 'Medienlieferung und Kopien';

  @override
  String get syncMediaPendingCount => 'Warten auf die Übertragung';

  @override
  String get syncMediaDurableCount => 'In den persönlichen Lagerraum geliefert';

  @override
  String get syncMediaTemporaryCount => 'Temporäre oder unbestätigte Kopien';

  @override
  String get syncMediaReceiptExplanation =>
      'Diese Zählungen beziehen sich auf abgeschlossene Lieferungen und nicht auf eine erneute Prüfung der verbleibenden Backups.';

  @override
  String get syncMediaCacheExplanation =>
      'Temporäre Cloud-Medien können ablaufen. Bewahren Sie Ihre Originale oder ein separates Backup auf.';

  @override
  String get momentsTitle => 'Fotomomente';

  @override
  String get momentsHint =>
      'Finden Sie Gruppen mithilfe lokaler Fotozeiten und optionaler Koordinaten. Fotos werden nur angehängt, wenn Sie eine Karte auswählen.';

  @override
  String get momentsScan => 'Finden Sie Momente';

  @override
  String get momentsChooseFolder => 'Wählen Sie einen Fotoordner';

  @override
  String get momentsLocation => 'Geben Sie Fotostandorte an';

  @override
  String get momentsEmpty => 'Keine aktuellen Fotogruppen.';

  @override
  String get momentsCreate => 'Schreiben Sie über diese Fotos';

  @override
  String get momentsDismiss => 'Entlassen';

  @override
  String get momentsError => 'Lokale Fotos konnten nicht gelesen werden.';

  @override
  String get momentsCreated => 'Fotoeintrag erstellt.';

  @override
  String get momentsPermission =>
      'Erlauben Sie den Zugriff auf Fotos, um lokale Vorschläge zu finden.';

  @override
  String get momentsScope =>
      'Nur aktuelle Fotos; maximal 500 Fotos und 20 Fotos pro Karte.';

  @override
  String momentsPhotoCount(int count) {
    return '$count Fotos';
  }

  @override
  String get nearbyTitle => 'Geräte verbinden';

  @override
  String get nearbySend => 'Autorisieren Sie ein anderes Gerät';

  @override
  String get nearbyReceive =>
      'Stellen Sie eine Verbindung zu einem vorhandenen Gerät her';

  @override
  String get nearbyInstructions =>
      'Verbinden Sie beide Geräte mit demselben Wi-Fi oder mit dem Hotspot des anderen. Bestätigen Sie die Autorisierung auf dem vorhandenen Gerät; Beide Geräte bleiben nutzbar. Es ist kein Internet erforderlich.';

  @override
  String get nearbyCompare =>
      'Vergleichen Sie diesen Code auf beiden Geräten, bevor Sie ihn genehmigen.';

  @override
  String get nearbyConfirm => 'Die Codes stimmen überein';

  @override
  String get nearbyScan => 'Scannen Sie den Code des anderen Geräts';

  @override
  String get nearbyPaste => 'Einladung einfügen';

  @override
  String get nearbyWaiting => 'Warten auf Genehmigung auf dem anderen Gerät';

  @override
  String get nearbyWorking =>
      'Autorisieren und Synchronisieren Ihres Tagebuchs und Ihrer Anhänge …';

  @override
  String get nearbyPending =>
      'Einige Anhänge müssen noch synchronisiert werden. Lassen Sie das andere Gerät online und versuchen Sie es erneut.';

  @override
  String get nearbyComplete =>
      'Gerät angeschlossen; Tagebuch und Anhänge synchronisiert';

  @override
  String get nearbyFailed =>
      'Die Verbindung wurde nicht hergestellt. Überprüfen Sie die lokale Verbindung und versuchen Sie es erneut.';

  @override
  String get nearbyEmptyRequired =>
      'Verwenden Sie ein Gerät mit leerem Tagebuch, das noch nicht mit der Synchronisierung verbunden ist.';

  @override
  String get nearbyRetry => 'Setzen Sie die Synchronisierung fort';

  @override
  String get nearbyWifi => 'Wi-Fi-Einstellungen';

  @override
  String get nearbyHotspot => 'Hotspot-Einstellungen';

  @override
  String get nearbyKeepOpen =>
      'Lassen Sie diese Seite geöffnet, bis das neue Gerät fertig ist. Die Einladung läuft nach zwei Minuten ab.';

  @override
  String get syncDevicesTitle => 'Autorisierte Geräte';

  @override
  String get syncDevicesDescription =>
      'Nur zugelassene Geräte können auf dieses AID-Konto zugreifen. Durch das Sperren eines Geräts wird der Server blockiert, ein bereits darauf kopierter Hauptschlüssel oder ein bereits kopiertes Tagebuch kann jedoch nicht gelöscht werden.';

  @override
  String get syncDeviceRequest =>
      'Zeigen Sie diesen Autorisierungs-QR einem zugelassenen Gerät vor';

  @override
  String get syncDeviceAuthorize => 'Autorisieren Sie ein Gerät';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Scannen oder fügen Sie die Autorisierungsanfrage des neuen Geräts ein.';

  @override
  String get syncDeviceRevoke => 'Widerrufen';

  @override
  String get syncDeviceRotate =>
      'Drehen Sie den Signaturschlüssel dieses Geräts';

  @override
  String get syncDeviceCheck => 'Berechtigung prüfen';

  @override
  String get syncDeviceHardware => 'Hardwaregestützter Signaturschlüssel';

  @override
  String get syncDeviceSoftware =>
      'Nicht exportierbarer Software-Signaturschlüssel';

  @override
  String get syncDeviceUnavailable =>
      'Die Geräteautorisierung ist nicht verfügbar. Genehmigen Sie dieses Gerät von einem anderen autorisierten Gerät und versuchen Sie es erneut.';

  @override
  String get syncDeviceRevoked => 'Widerrufen';

  @override
  String get syncDeviceLocal => 'Dieses Gerät';

  @override
  String get cloudTrafficTitle =>
      'Monatliches Cloud-Datenübertragungskontingent für Mediendateien';

  @override
  String get cloudTrafficLimit => 'Monatliches Datenübertragungskontingent';

  @override
  String get cloudTrafficUsed => 'Datenübertragung genutzt';

  @override
  String get cloudTrafficRemaining => 'Datenübertragung bleibt bestehen';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'Das Datenübertragungskontingent wird $time zurückgesetzt';
  }

  @override
  String get cloudTrafficExhausted =>
      'Das Cloud-Datenübertragungskontingent für Mediendateien ist aufgebraucht. Fehlende Mediendateien werden automatisch synchronisiert, wenn eine direkte Verbindung verfügbar ist oder das Kontingent zurückgesetzt wird.';

  @override
  String get cloudTrafficExplanation =>
      'Zwischenspeicherung von Mediendateien und Live-Relay teilen sich dieses Datenübertragungskontingent. Direktverbindungen verbrauchen es nicht. Für Tagebuchtexte und Verbindungskontrollnachrichten gelten separate kleine Tageslimits.';

  @override
  String get appearanceThemeSection => 'App-Thema';

  @override
  String get appearancePaperSection => 'Tagebuchpapier';

  @override
  String get appearanceTypographySection => 'Tagebuchtext';

  @override
  String get appearancePreferencesSection => 'Allgemeine Vorlieben';

  @override
  String get themeSystemAccentHint =>
      'Verwendet die Systempalette anstelle benutzerdefinierter Farben. Schalten Sie es aus, um Ihr eigenes auszuwählen.';

  @override
  String get syncDeviceNameSaveFailed =>
      'Der Gerätename konnte nicht gespeichert werden. Bitte versuchen Sie es erneut.';

  @override
  String get nearbyConnectionHelp => 'Verbindungshilfe';

  @override
  String get syncAllSynced => 'Alles synchronisiert';

  @override
  String get syncDetailsTitle => 'Details synchronisieren';

  @override
  String get syncMore => 'Weitere Optionen';

  @override
  String get syncDeviceName => 'Gerätename';

  @override
  String get syncDeviceNameHint => 'Zum Beispiel: Mein Tablet';

  @override
  String get syncDeviceNameInvalid => 'Verwenden Sie 1 bis 32 Zeichen';

  @override
  String get syncDeviceKeyDetails => 'Sicherheitsdetails';

  @override
  String get syncConnectionProblem =>
      'Die Synchronisierung ist derzeit nicht möglich. Automatischer Wiederholungsversuch.';

  @override
  String get syncCopyComplete =>
      'Vollständige Kopie Ihres Tagebuchs und Ihrer Mediendateien';

  @override
  String get syncCopyPartial => 'Einige Medien fehlen noch';

  @override
  String get syncCopyOlder => 'Neue Änderungen warten auf die Synchronisierung';

  @override
  String get syncCopyUnavailable =>
      'Kopierdetails sind nicht verfügbar. Versuchen Sie es später noch einmal.';

  @override
  String get syncCopyLastKnown =>
      'Andere Geräte zeigen ihre letzte bestätigte Kopie. Offline-Geräte können derzeit nicht überprüft werden.';

  @override
  String get syncCopyTemporary =>
      'Temporärer Cache. Bewahren Sie die Originale auf Ihren Geräten auf.';

  @override
  String get syncCopyStorage =>
      'Ihr Synchronisierungsspeicher. Abgeschlossene Medien-Uploads werden in der Diagnose aufgeführt.';

  @override
  String syncCopyChecked(String time) {
    return 'Zuletzt bestätigt $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Verbleibende Datenübertragung in diesem Monat: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Beginnen Sie hier';

  @override
  String get onboardConnect => 'Mit vorhandenem Gerät verbinden';

  @override
  String get onboardFailed =>
      'Die Einrichtung konnte nicht abgeschlossen werden. Ihr Tagebuch ist sicher; Bitte versuchen Sie es noch einmal.';

  @override
  String get tutorialTitle => 'So verwenden Sie das Tagebuch';

  @override
  String get tutorialWriteTitle => 'Schreiben Sie Ihren ersten Tagebucheintrag';

  @override
  String get tutorialWriteText =>
      'Tippen Sie auf +, um einen Tagebucheintrag zu schreiben. Fügen Sie einen optionalen Titel hinzu, wählen Sie das Tagebuchdatum und tippen Sie zum Speichern auf das Häkchen. Sie können Ihren Tagebucheintrag jederzeit wieder bearbeiten.';

  @override
  String get tutorialMediaTitle =>
      'Fügen Sie Fotos, Audio oder Handschrift hinzu';

  @override
  String get tutorialMediaText =>
      'Verwenden Sie + im Tagebucheditor, um Fotos, Videos oder eine Sprachaufnahme anzuhängen oder um die Handschrift-Leinwand zu öffnen. Diese Anhänge werden mit dem Tagebucheintrag gespeichert.';

  @override
  String get tutorialReviewTitle => 'Finden Sie wieder einen Tag';

  @override
  String get tutorialReviewText =>
      'Durchsuchen Sie Ihr Tagebuch oder Ihren Kalender, durchsuchen Sie Ihre Texte und organisieren Sie Einträge mit Tags. Auf den Seiten „Medien“ und „Atlas“ können Sie frühere Einträge nach Foto oder Ort finden.';

  @override
  String get tutorialSyncTitle => 'Verwenden Sie mehr als ein Gerät';

  @override
  String get tutorialSyncText =>
      'Verbinde dich unter Einstellungen → Daten & Speicher → Synchronisierung mit einem vorhandenen Gerät und bestätige die Freigabe dort. Beide Geräte bleiben nutzbar. Zuerst wird der Tagebuchtext synchronisiert. Anhänge folgen je nach Verbindung und verbleibendem Datenkontingent.';

  @override
  String get tutorialPrivacyTitle => 'Bewahren Sie Ihr Tagebuch sicher auf';

  @override
  String get tutorialPrivacyText =>
      'Tagebucheinträge bleiben auf diesem Gerät, es sei denn, Sie aktivieren die Synchronisierung oder teilen oder exportieren sie. Die Synchronisierung erfolgt Ende-zu-Ende-verschlüsselt. In den Einstellungen können Sie auch einen App-Passcode festlegen, Backups erstellen und dieses Tutorial erneut öffnen.';

  @override
  String get editorDiaryDay => 'Tagebuchtag';

  @override
  String get editorDiaryDayPicker =>
      'Tagebuchtag · Zu welchem Tag gehört dieser Eintrag?';

  @override
  String editorCreatedAt(String time) {
    return 'Erstellt $time';
  }

  @override
  String get editorDiaryDayHint =>
      'Der Tag, zu dem dieser Eintrag gehört. Eine Änderung lässt den Erstellungszeitpunkt unverändert.';

  @override
  String get hiddenDiaryTitle => 'Verborgene Einträge';

  @override
  String get hiddenDiaryHide => 'Eintrag verbergen';

  @override
  String get hiddenDiaryShow => 'Eintrag einblenden';

  @override
  String get hiddenDiaryEmpty => 'Keine verborgenen Einträge';

  @override
  String get hiddenDiaryUnlock => 'Verborgene Einträge entsperren';

  @override
  String get hiddenDiaryAuthHint =>
      'Verwende die App-Sperre oder die Bildschirmsperre deines Geräts.';

  @override
  String get moodClear => 'Stimmung entfernen';

  @override
  String get scrollToTop => 'Nach oben';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackHint => 'Beschreibe ein Problem oder einen Vorschlag';

  @override
  String get feedbackGithub => 'GitHub-Issue';

  @override
  String get feedbackEmail => 'E-Mail senden';

  @override
  String get feedbackCopy => 'Text kopieren';

  @override
  String get feedbackLaunchFailed =>
      'Die App konnte nicht geöffnet werden. Kopiere den Text und nutze die E-Mail-Adresse unten.';

  @override
  String get feedbackCopied => 'Feedback kopiert';
}
