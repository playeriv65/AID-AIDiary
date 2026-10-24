// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => 'Tema farge';

  @override
  String get themeColorHint => 'Velg en farge for denne paletten.';

  @override
  String get themeColorBlue => 'Himmelblå';

  @override
  String get themeColorGreen => 'Skoggrønn';

  @override
  String get themeColorBrown => 'Varm kaffe';

  @override
  String get themeColorPurple => 'Lavendel';

  @override
  String get themeColorRose => 'Støvete rose';

  @override
  String get themeColorAmber => 'Rav';

  @override
  String get themeColorPreview => 'Litt hver dag';

  @override
  String get themeTintBackgroundTitle => 'Farge bakgrunner med temafarge';

  @override
  String get themeTintBackgroundHint =>
      'Slå av for nøytral grå bakgrunn; knapper holder den valgte fargen.';

  @override
  String get dailyReminderTitle => 'Skriv i dagboken din i dag!';

  @override
  String get dailyReminderDescription => 'Ta din daglige dagbokoppføring...';

  @override
  String get actionTakePhoto => 'Ta bilde';

  @override
  String get flashbacksTitle => 'Tilbakeblikk';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Utelukk dårlige dager';

  @override
  String get flashbackGoodDay => 'En god dag';

  @override
  String get flashbackRandomDay => 'En tilfeldig dag';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uker siden',
      one: '$count uke siden',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count måneder siden',
      one: '$count måned siden',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count år siden',
      one: '$count år siden',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'På denne dagen';

  @override
  String get searchLogsHint => 'Søk i dagbokoppføringer...';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagbokoppføringer',
      one: '$count dagbokoppføring',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dager',
      one: '$count dag',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ord',
      one: '$count ord',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Ingen dagbokoppføringer...';

  @override
  String get noResults => 'Ingen resultater...';

  @override
  String get sortOrderAscendingTitle => 'Stigende';

  @override
  String get sortOrderDescendingTitle => 'Synkende';

  @override
  String get pageStatisticsTitle => 'Statistikk';

  @override
  String get statisticsNotEnoughData => 'Ikke nok data...';

  @override
  String get statisticsRangeOneMonth => '1 måned';

  @override
  String get statisticsRangeSixMonths => '6 måneder';

  @override
  String get statisticsRangeOneYear => '1 år';

  @override
  String get statisticsRangeAllTime => 'Hele tiden';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag Sammendrag';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag etter dag';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag Over tid';
  }

  @override
  String get chartGroupingLabel => 'Grupper etter';

  @override
  String get chartGroupingDay => 'dag';

  @override
  String get chartGroupingWeek => 'Uke';

  @override
  String get chartGroupingMonth => 'Måned';

  @override
  String get chartGroupingYear => 'år';

  @override
  String get chartSmoothingLabel => 'Utjevning';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nåværende strek $count',
      one: 'Nåværende rekke $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lengste rekke $count',
      one: 'Lengste rekke $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Flotte dager $count',
      one: 'Store dager $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dager siden en dårlig dag $count',
      one: 'Dager siden en dårlig dag $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Får ikke tilgang til ekstern lagring';

  @override
  String get errorExternalStorageAccessDescription =>
      'Hvis du bruker nettverkslagring, sørg for at tjenesten er online og at du har nettverkstilgang.\n\nEllers kan appen ha mistet tillatelsene for den eksterne mappen. Gå til innstillinger, og velg den eksterne mappen på nytt for å gi tilgang.\n\nAdvarsel, endringer vil ikke bli synkronisert før du gjenoppretter tilgangen til den eksterne lagringsplassen!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Fortsett med lokal database';

  @override
  String get lastModified => 'Modifisert';

  @override
  String get writeSomethingHint => 'Skriv noe...';

  @override
  String get titleHint => 'Tittel...';

  @override
  String get deleteLogTitle => 'Slett dagbokoppføring';

  @override
  String get deleteLogDescription =>
      'Oppføringen flyttes til Nylig slettet, hvor du kan gjenopprette den.';

  @override
  String get deletePhotoTitle => 'Slett vedlegg';

  @override
  String get deletePhotoDescription =>
      'Er du sikker på at du vil slette dette vedlegget?';

  @override
  String get pageSettingsTitle => 'Innstillinger';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Lys';

  @override
  String get themeDark => 'Mørkt';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Første dag i uken';

  @override
  String get settingsCalendarSystem => 'Kalendersystem';

  @override
  String get calendarSystemGregorian => 'gregoriansk';

  @override
  String get calendarSystemJalali => 'Jalali';

  @override
  String get settingsUseSystemAccentColor => 'Bruk System Accent Color';

  @override
  String get settingsCustomAccentColor => 'Egendefinert aksentfarge';

  @override
  String get settingsShowFlashbacks => 'Vis tilbakeblikk';

  @override
  String get settingsChangeMoodIcons => 'Endre humørikoner';

  @override
  String get moodIconPrompt => 'Skriv inn et ikon';

  @override
  String get settingsHideImages => 'Skjul bilder';

  @override
  String get pageCalendarTitle => 'Kalender';

  @override
  String get settingsNotificationsTitle => 'Varsler';

  @override
  String get settingsDailyReminderTitle => 'Daglig påminnelse';

  @override
  String get settingsOnThisDayDescription => 'Gå tilbake til tidligere minner';

  @override
  String get settingsDailyReminderDescription => 'En mild påminnelse hver dag';

  @override
  String get settingsReminderTime => 'Påminnelsestid';

  @override
  String get settingsFixedReminderTimeTitle => 'Fast påminnelsestid';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Velg et fast tidspunkt for påminnelsen';

  @override
  String get settingsAlwaysSendReminderTitle => 'Send alltid påminnelse';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Send påminnelse selv om en dagbokoppføring allerede er startet';

  @override
  String get settingsCustomizeNotificationTitle => 'Tilpass varsler';

  @override
  String get settingsTemplatesTitle => 'Maler';

  @override
  String get manageTemplates => 'Administrer maler';

  @override
  String get noTemplateTitle => 'Ingen';

  @override
  String get noTemplatesDescription => 'Ingen maler opprettet ennå...';

  @override
  String get templateDefaultTimestampTitle => 'Tidsstempel';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Dagsoppsummering';

  @override
  String get templateDefaultSummaryBody =>
      '### Sammendrag\n- \n\n### Sitat\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Refleksjon';

  @override
  String get templateDefaultReflectionBody =>
      '### Hva likte du i dag?\n- \n\n### Hva er du takknemlig for?\n- \n\n### Hva ser du frem til?\n- ';

  @override
  String get settingsTagsTitle => 'Tagger';

  @override
  String get manageTags => 'Administrer tagger';

  @override
  String get tagTypeLabelTitle => 'Etikett';

  @override
  String get tagTypeTrackerTitle => 'Tracker';

  @override
  String get nameHint => 'Navn';

  @override
  String get tagColorLabel => 'Farge';

  @override
  String get iconPickerTitle => 'Velg ikon';

  @override
  String get iconPickerIconsTab => 'Ikoner';

  @override
  String get iconPickerCustomTab => 'Egendefinert';

  @override
  String get iconPickerSearchHint => 'Søkeikoner...';

  @override
  String get colorPickerTitle => 'Velg Farge';

  @override
  String get colorPickerPaletteTab => 'Farger';

  @override
  String get iconGroupMoodPeople => 'Stemning og mennesker';

  @override
  String get iconGroupHealth => 'Helse';

  @override
  String get iconGroupWorkFinance => 'Arbeid og økonomi';

  @override
  String get iconGroupHabitsGoals => 'Vaner og mål';

  @override
  String get iconGroupNature => 'Naturen';

  @override
  String get iconGroupFoodDrink => 'Mat og drikke';

  @override
  String get iconGroupHome => 'Hjem';

  @override
  String get iconGroupTravel => 'Reise';

  @override
  String get iconGroupSymbols => 'Symboler';

  @override
  String get tagCategoryLabel => 'Kategori';

  @override
  String get tagLabel => 'Tag';

  @override
  String get tagCategoryUncategorized => 'Ukategorisert';

  @override
  String get newCategoryTitle => 'Ny kategori';

  @override
  String get shareButtonLabel => 'Del';

  @override
  String get importErrorDescription => 'Kunne ikke importere filen!';

  @override
  String get exportErrorDescription => 'Kunne ikke eksportere filen!';

  @override
  String get deleteTitle => 'Slett';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Den brukes i $count dagbokoppføringer.',
      one: ' Den brukes i $count dagbokoppføring.',
      zero: '',
    );
    return 'Vil du slette \"$name\"?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Dens $count-tagger vil også bli slettet.',
      one: ' Dens $count-tag vil også bli slettet.',
      zero: '',
    );
    return 'Vil du slette \"$name\"?$_temp0';
  }

  @override
  String get tagNameExists => 'Det er allerede en tag med dette navnet';

  @override
  String get categoryNameExists =>
      'Det er allerede en kategori med dette navnet';

  @override
  String deleteTemplateMessage(Object name) {
    return 'Vil du slette \"$name\"?';
  }

  @override
  String get addTagsTitle => 'Legg til tagger';

  @override
  String get addTagsSearchHint => 'Søk etiketter...';

  @override
  String get tagPickerSortManualLabel => 'Manuell bestilling';

  @override
  String get tagPickerSortUsageLabel => 'Sorter etter bruk';

  @override
  String get tagFavoriteName => 'Favoritt';

  @override
  String get tagEnergyName => 'Energi';

  @override
  String get tagCategoryActivitiesName => 'Aktiviteter';

  @override
  String get tagExerciseName => 'Trening';

  @override
  String get tagSocializingName => 'Sosialt samvær';

  @override
  String get tagHobbyName => 'Hobby';

  @override
  String get tagEntertainmentName => 'Underholdning';

  @override
  String get tagDiningName => 'Servering';

  @override
  String get tagChoresName => 'Arbeidsoppgaver';

  @override
  String get tagCategoryEmotionsName => 'Følelser';

  @override
  String get tagExcitedName => 'Spent';

  @override
  String get tagGratefulName => 'Takknemlig';

  @override
  String get tagCalmName => 'Rolig';

  @override
  String get tagTiredName => 'Sliten';

  @override
  String get tagAnxiousName => 'Engstelig';

  @override
  String get tagAnnoyedName => 'Irritert';

  @override
  String get settingsStorageTitle => 'Oppbevaring';

  @override
  String get settingsImageQuality => 'Bildekvalitet';

  @override
  String get imageQualityHigh => 'Høy';

  @override
  String get imageQualityMedium => 'Middels';

  @override
  String get imageQualityLow => 'Lavt';

  @override
  String get imageQualityNoCompression => 'Ingen kompresjon';

  @override
  String get settingsLogFolder => 'dagbokoppføringsmappe';

  @override
  String get settingsImageFolder => 'Bildemappen';

  @override
  String get warningTitle => 'Advarsel';

  @override
  String get logFolderWarningDescription =>
      'Hvis den valgte mappen allerede inneholder en \'aid_diary.db\'-fil, vil den bli brukt til å overskrive dine eksisterende dagbokoppføringer!';

  @override
  String get errorTitle => 'Feil';

  @override
  String get logFolderErrorDescription =>
      'Kunne ikke endre dagbokoppføringsmappe!';

  @override
  String get imageFolderErrorDescription => 'Kunne ikke endre bildemappe!';

  @override
  String get backupErrorDescription => 'Kunne ikke opprette sikkerhetskopi!';

  @override
  String get restoreErrorDescription =>
      'Kunne ikke gjenopprette sikkerhetskopien!';

  @override
  String get settingsBackupRestoreTitle =>
      'Sikkerhetskopiering og gjenoppretting';

  @override
  String get settingsBackup => 'Sikkerhetskopiering';

  @override
  String get settingsRestore => 'Gjenopprett';

  @override
  String get settingsRestorePromptDescription =>
      'Gjenoppretting av en sikkerhetskopi vil overskrive eksisterende data!';

  @override
  String get settingsBackupPasswordProtect =>
      'Passordbeskytte sikkerhetskopier';

  @override
  String get backupEncryptedTitle => 'Kryptert sikkerhetskopi';

  @override
  String get backupEncryptedContent =>
      'Denne sikkerhetskopien er passordbeskyttet.';

  @override
  String get settingsAutoBackup => 'Automatiske sikkerhetskopier';

  @override
  String get settingsAutoBackupLocation => 'Sikkerhetskopieringssted';

  @override
  String get settingsAutoBackupInterval => 'Sikkerhetskopieringsintervall';

  @override
  String get settingsAutoBackupIntervalDaily => 'Daglig';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Ukentlig';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Månedlig';

  @override
  String get settingsAutoBackupMaxCount => 'Sikkerhetskopier å beholde';

  @override
  String get settingsAutoBackupRequireCharging => 'Kun under lading';

  @override
  String settingsBackupLast(Object time) {
    return 'Siste sikkerhetskopi $time';
  }

  @override
  String get settingsBackupNever => 'Aldri sikkerhetskopiert';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Neste sikkerhetskopi $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'Alle';

  @override
  String get autoBackupFailedTitle => 'Sikkerhetskopiering mislyktes';

  @override
  String tranferStatus(Object percent) {
    return 'Overfører … $percent %';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Oppretter sikkerhetskopi … $percent %';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Gjenoppretter sikkerhetskopien … $percent %';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return 'Krypterer sikkerhetskopi … $percent %';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Dekrypterer sikkerhetskopien … $percent %';
  }

  @override
  String get cleanUpStatus => 'Rydder opp...';

  @override
  String get settingsExportToAnotherFormat => 'Eksporter til et annet format';

  @override
  String get settingsExportFormatDescription =>
      'Dette bør ikke brukes som backup!';

  @override
  String get settingsImportFromAnotherApp => 'Importer fra en annen app';

  @override
  String get logFormatTitle => 'Velg Format';

  @override
  String get logFormatDescription =>
      'En annen app-format støtter kanskje ikke alle funksjoner. Vennligst rapporter eventuelle problemer siden tredjeparts formater kan endres når som helst. Dette vil ikke påvirke eksisterende dagbokoppføringer!';

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
  String get settingsDeleteAllLogsTitle => 'Slett alle dagbokoppføringer';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Vil du slette alle dagbokoppføringene dine?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Skriv inn \'$prompt\' for å bekrefte. Dette kan ikke angres!';
  }

  @override
  String get settingsAppLanguageTitle => 'App-språk';

  @override
  String get settingsSecurityTitle => 'Sikkerhet';

  @override
  String get settingsSecurityRequirePassword => 'Krev passord';

  @override
  String get settingsSecurityEnterPassword => 'Skriv inn passord';

  @override
  String get settingsSecuritySetPassword => 'Angi passord';

  @override
  String get settingsSecurityChangePassword => 'Endre passord';

  @override
  String get settingsSecurityPassword => 'Passord';

  @override
  String get settingsSecurityConfirmPassword => 'Bekreft passord';

  @override
  String get settingsSecurityOldPassword => 'Gammelt passord';

  @override
  String get settingsSecurityIncorrectPassword => 'Feil passord';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'Passord stemmer ikke';

  @override
  String get requiredPrompt => 'Obligatorisk';

  @override
  String get settingsSecurityBiometricUnlock => 'Biometrisk opplåsing';

  @override
  String get unlockAppPrompt => 'Lås opp appen';

  @override
  String get settingsAboutTitle => 'Om';

  @override
  String get settingsVersion => 'Versjon';

  @override
  String get settingsLicense => 'Lisens';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsOpenSourceLicenses => 'Åpen kildekode-lisenser';

  @override
  String get tagMoodTitle => 'Stemning';

  @override
  String get selectTagTitle => 'Velg Tag';

  @override
  String get labelPresentLabel => 'Tilstede';

  @override
  String get labelAbsentLabel => 'Fraværende';

  @override
  String get labelCoverageLabel => 'Dekning';

  @override
  String chartDistributionTitle(Object tag) {
    return '$tag distribusjon';
  }

  @override
  String get shareAddToLogPickerTitle => 'Velg en dagbokoppføring';

  @override
  String get adaptiveEmptyDay => 'Ingen påmeldinger for denne dagen ennå';

  @override
  String get adaptiveNewEntry => 'Skriv en oppføring';

  @override
  String get pageJournalTitle => 'Dagbok';

  @override
  String get coachPrompt1 => 'Hva fikk deg til å smile i dag?';

  @override
  String get coachPrompt2 => 'Hva er en ting du lærte i dag?';

  @override
  String get coachPrompt3 =>
      'Hvem snakket du med i dag, og hvordan føltes det?';

  @override
  String get coachPrompt4 => 'Hva er du takknemlig for akkurat nå?';

  @override
  String get coachPrompt5 => 'Hva tok mesteparten av energien din i dag?';

  @override
  String get coachPrompt6 => 'Beskriv et lite øyeblikk du vil huske.';

  @override
  String get coachPrompt7 => 'Hva ville gjøre morgendagen til en god dag?';

  @override
  String get coachPrompt8 => 'Hva har du tenkt på i det siste?';

  @override
  String get coachPrompt9 => 'Hva gjorde du i dag bare for deg selv?';

  @override
  String get coachPrompt10 =>
      'Hvis dagen i dag hadde en tittel, hva ville den vært?';

  @override
  String get pageMediaTitle => 'Media';

  @override
  String get pageAtlasTitle => 'Atlas';

  @override
  String get pageCoachTitle => 'Trener';

  @override
  String get noEntrySelected => 'Ingen oppføring valgt.';

  @override
  String get entryShare => 'Del';

  @override
  String get entryFavorite => 'Stjerne';

  @override
  String get entryEdit => 'Rediger';

  @override
  String get entryPrevious => 'Forrige oppføring';

  @override
  String get entryNext => 'Neste oppføring';

  @override
  String get journalStories => 'Historier';

  @override
  String get journalEntries => 'Oppføringer';

  @override
  String get journalEmptyHint =>
      'Start dagboken din ved å legge til en ny oppføring.';

  @override
  String get storyToday => 'I dag';

  @override
  String get storyThrowback => 'Tilbakeslag';

  @override
  String get storyNoThrowback => 'Ingen tilbakevending i dag';

  @override
  String get mediaFiles => 'Mediefiler';

  @override
  String get mediaEmpty => 'Ingen bilder ennå.';

  @override
  String get mediaEmptyHint => 'Bilder vedlagt bidrag vil bli vist her.';

  @override
  String get atlasEmpty => 'Ingen oppføringer med en plassering.';

  @override
  String get atlasEmptyHint => 'Oppføringer med en plassering vises her.';

  @override
  String get atlasShowAll => 'Vis alle oppføringer';

  @override
  String get atlasMyLocation => 'Min plassering';

  @override
  String get coachAll => 'Alle';

  @override
  String get coachPrograms => 'Programmer';

  @override
  String get coachTemplates => 'Maler';

  @override
  String get coachKindProgram => 'Program';

  @override
  String get coachKindTemplate => 'Mal';

  @override
  String get coachNoTemplates => 'Ingen programmer eller maler.';

  @override
  String get coachUseTemplate => 'Skriv med denne malen';

  @override
  String get coachProgramEverydayTitle => 'Hverdagsøyeblikk';

  @override
  String get coachProgramEverydayDescription =>
      'Fem korte spørsmål, ett om dagen. Hver tar et minutt eller to og hjelper deg å se hva som gjorde dagen til din. En skånsom måte å bygge opp en vane med å skrive litt hver dag.';

  @override
  String get coachProgramReflectTitle => 'Ser innover';

  @override
  String get coachProgramReflectDescription =>
      'Ett dypere spørsmål i uken, i fem uker. Ta deg tid til hver enkelt: hvordan du har følt deg, hva sliter deg ut, hva du er takknemlig for.';

  @override
  String get searchFilters => 'Filtre';

  @override
  String get searchFilterTags => 'Tagger';

  @override
  String get searchFilterStarred => 'Stjernemerket';

  @override
  String get searchHint => 'Skriv for å søke, eller velg et filter.';

  @override
  String get locationTitle => 'Beliggenhet';

  @override
  String get locationName => 'Stedsnavn';

  @override
  String get locationRemove => 'Fjern';

  @override
  String get locationServiceDisabled => 'Stedstjenester er slått av.';

  @override
  String get locationPermissionDenied => 'Plasseringstillatelse ble nektet.';

  @override
  String get locationUnavailable => 'Kunne ikke hente gjeldende plassering.';

  @override
  String get calendarJumpToToday => 'Hopp til i dag';

  @override
  String get editorStartWriting => 'Begynn å skrive eller velg en ';

  @override
  String get editorTemplateLink => 'Mal';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Velg en mal';

  @override
  String get templateFeatured => 'Utvalgte maler';

  @override
  String get templateMine => 'Mine maler';

  @override
  String get templateDailyName => 'Daglig gjennomgang';

  @override
  String get templateDailyDescription =>
      'Hva skjedde, hvordan det føltes og hva som kommer etterpå.';

  @override
  String get templateDailyText =>
      '## Hva skjedde i dag\n\n\n## Hvordan jeg følte meg\n\n\n## Tre ting jeg er takknemlig for\n1. \n2. \n3. \n\n## I morgen\n';

  @override
  String get templateTravelName => 'Reisedagbokoppføring';

  @override
  String get templateTravelDescription => 'Steder, øyeblikk og mat fra veien.';

  @override
  String get templateTravelText =>
      '## Hvor jeg gikk\n\n\n## Øyeblikket jeg husker mest\n\n\n## Hva jeg spiste\n\n\n## Planer for morgendagen\n';

  @override
  String get templateReadingName => 'Lese notater';

  @override
  String get templateReadingDescription =>
      'Sitater og tanker fra det du leser.';

  @override
  String get templateReadingText =>
      '## Bok\n\n\n## Hvor jeg er\n\n\n## Sitater\n> \n\n## Mine tanker\n';

  @override
  String get templateWeeklyName => 'Ukentlig gjennomgang';

  @override
  String get templateWeeklyDescription =>
      'Høydepunkter, slit og neste ukes fokus.';

  @override
  String get templateWeeklyText =>
      '## Høydepunkter\n\n\n## Hva var vanskelig\n\n\n## Det jeg lærte\n\n\n## Fokus for neste uke\n';

  @override
  String get entrySaveAsTemplate => 'Lagre som mal';

  @override
  String get entrySavedAsTemplate => 'Lagret som en mal';

  @override
  String get storyStatistics => 'Statistikk';

  @override
  String get storyMoodChart => 'Stemningsdiagram';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return '$entries oppføringer · $days dager';
  }

  @override
  String get storyThisYear => 'I år';

  @override
  String get storyLastYear => 'I fjor';

  @override
  String get storyTapToOpen => 'Trykk på en dag for å åpne den';

  @override
  String get settingsGeneralTitle => 'Generelt';

  @override
  String get settingsDataTitle => 'Data og lagring';

  @override
  String get settingsStoriesTitle => 'Historier';

  @override
  String get settingsHelpTitle => 'Hjelp og om';

  @override
  String get weatherTitle => 'Vær';

  @override
  String get weatherClear => 'Tøm';

  @override
  String get weatherPartlyCloudy => 'Delvis skyet';

  @override
  String get weatherCloudy => 'Overskyet';

  @override
  String get weatherFog => 'Tåke';

  @override
  String get weatherDrizzle => 'Duskregn';

  @override
  String get weatherRain => 'Regn';

  @override
  String get weatherSnow => 'Snø';

  @override
  String get weatherStorm => 'Tordenvær';

  @override
  String get weatherFetch => 'Få vær for denne oppføringen';

  @override
  String get weatherNeedsLocation => 'Legg til et sted med koordinater først.';

  @override
  String get weatherUnavailable =>
      'Været er utilgjengelig for dette stedet og tidspunktet.';

  @override
  String get weatherRemove => 'Fjern vær';

  @override
  String get activityTitle => 'Aktivitet';

  @override
  String get activityStill => 'Likevel';

  @override
  String get activityWalking => 'Går';

  @override
  String get activityRunning => 'Løper';

  @override
  String get activityCycling => 'Sykling';

  @override
  String get activityVehicle => 'I et kjøretøy';

  @override
  String get activityFlying => 'Flyreise';

  @override
  String get activityExercise => 'Trening';

  @override
  String get activityDetect => 'Oppdag gjeldende aktivitet';

  @override
  String get activityDetectFailed => 'Kunne ikke oppdage en aktivitet.';

  @override
  String get activityRemove => 'Fjern aktivitet';

  @override
  String get settingsAutoAddTitle => 'Legg til automatisk';

  @override
  String get settingsAutoAddLocation => 'Beliggenhet';

  @override
  String get settingsAutoAddWeather => 'Vær';

  @override
  String get settingsAutoAddHint =>
      'Nye oppføringer får disse fylt ut når de opprettes.';

  @override
  String get settingsTemperatureUnit => 'Temperaturenhet';

  @override
  String get settingsCelsius => 'Celsius (°C)';

  @override
  String get settingsFahrenheit => 'Fahrenheit (°F)';

  @override
  String get moodGreat => 'Flott';

  @override
  String get moodGood => 'Bra';

  @override
  String get moodOkay => 'Ok';

  @override
  String get moodBad => 'Dårlig';

  @override
  String get moodAwful => 'Forferdelig';

  @override
  String get locationSearchHint => 'Søk etter et sted';

  @override
  String get locationSearchEmpty => 'Ingen steder funnet';

  @override
  String get settingsWallpaper => 'Bakgrunn';

  @override
  String get wallpaperNone => 'Ingen';

  @override
  String get wallpaperDots => 'Prikker';

  @override
  String get wallpaperGrid => 'Rutenett';

  @override
  String get wallpaperLines => 'Linjer';

  @override
  String get wallpaperPhoto => 'Bilde...';

  @override
  String get settingsFontFamily => 'Font';

  @override
  String get fontSystem => 'System';

  @override
  String get fontSerif => 'Serif';

  @override
  String get fontMono => 'Monospace';

  @override
  String get settingsFontSize => 'Skriftstørrelse';

  @override
  String get fontSizeSmall => 'Liten';

  @override
  String get fontSizeMedium => 'Middels';

  @override
  String get fontSizeLarge => 'Stor';

  @override
  String get fontSizeExtraLarge => 'Ekstra stor';

  @override
  String get settingsLineSpacing => 'Linjeavstand';

  @override
  String get lineSpacingCompact => 'Kompakt';

  @override
  String get lineSpacingNormal => 'Normal';

  @override
  String get lineSpacingRelaxed => 'Avslappet';

  @override
  String get moodAssociationsTitle => 'Hva får meg til å føle...';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching av $total-oppføringer';
  }

  @override
  String get videoRecord => 'Ta opp en video';

  @override
  String get videoChoose => 'Velg en video';

  @override
  String get audioRecordTitle => 'Ta opp et talenotat';

  @override
  String get audioChoose => 'Velg en lydfil';

  @override
  String get audioStart => 'Ta opp';

  @override
  String get audioStop => 'Stopp og lagre';

  @override
  String get audioPermissionDenied =>
      'Mikrofontilgang er av. Tillat det i systeminnstillingene.';

  @override
  String get mediaTooLarge => 'Denne videoen er for stor til å legge ved.';

  @override
  String get mediaUnavailable =>
      'Dette vedlegget er ikke tilgjengelig på denne enheten.';

  @override
  String get widgetDone => 'Dagens bidrag er skrevet';

  @override
  String get widgetPending => 'Hvordan var dagen din?';

  @override
  String get widgetWrite => 'Skriv';

  @override
  String get insertChecklist => 'Sjekkliste';

  @override
  String get insertNumberedList => 'Nummerert liste';

  @override
  String get insertTable => 'Tabell';

  @override
  String get insertDivider => 'Avdeler';

  @override
  String get insertCodeBlock => 'Kodeblokk';

  @override
  String get journalSortTitle => 'Sorter oppføringer';

  @override
  String get journalSortUpdated => 'Sist oppdatert';

  @override
  String get settingsTimeFormat => 'Tidsformat';

  @override
  String get settingsDayStart => 'Nye påmeldinger teller dagen før til kl';

  @override
  String get settingsDayAskUntil => 'Spør så hvilken dag frem til';

  @override
  String get settingsDayStartMidnight => 'Av';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Hver oppføring beholder dagen den tilhører ved siden av tidspunktet den ble skrevet, og du kan når som helst endre den dagen i editoren. Disse timene velger bare dagen for nye oppføringer, så hvis du endrer dem, flyttes ingen eksisterende oppføring.';

  @override
  String get lateNightBadge => 'Skrevet sent på kvelden, regnet for dagen før';

  @override
  String editorDayAsk(String time) {
    return 'Skrevet på $time. Hvilken dag er det for?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (i går)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (i dag)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'Skrevet $when';
  }

  @override
  String get timeFormat12 => '12 timer';

  @override
  String get timeFormat24 => '24 timer i døgnet';

  @override
  String get settingsReminderDays => 'Minn meg på';

  @override
  String get locationRecent => 'Nylige steder';

  @override
  String get shareImage => 'Del bildet';

  @override
  String get shareSaveImage => 'Lagre bildet';

  @override
  String get shareSaved => 'Bildet er lagret';

  @override
  String get deletedTitle => 'Nylig slettet';

  @override
  String get deletedNone => 'Ingenting slettet nylig';

  @override
  String deletedHint(int days) {
    return 'Slettede oppføringer blir værende her i $days dager, og blir deretter slettet.';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days dager igjen';
  }

  @override
  String get deletedRestore => 'Gjenopprett';

  @override
  String get deletedDeleteForever => 'Slett for alltid';

  @override
  String get deletedDeleteForeverDescription =>
      'Oppføringen og dens vedlegg slettes. Dette kan ikke angres.';

  @override
  String get deletedEmpty => 'Tom';

  @override
  String get deletedEmptyDescription =>
      'Slette alle oppføringer i Nylig slettet? Dette kan ikke angres.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Tilfeldig gange';

  @override
  String get randomSubtitle => 'Åpne en tidligere oppføring';

  @override
  String get randomNext => 'En annen';

  @override
  String get randomAll => 'Alle';

  @override
  String get randomWithPhotos => 'Med bilder';

  @override
  String get randomGoodDays => 'Gode dager';

  @override
  String get randomEmpty => 'Ingen oppføringer å velge mellom';

  @override
  String get reviewWeekTitle => 'Denne uken';

  @override
  String get reviewWeekSubtitle => 'Uken din så langt';

  @override
  String get reviewYearTitle => 'I år';

  @override
  String get reviewEmpty => 'Ingenting skrevet ennå';

  @override
  String get reviewEntries => 'Oppføringer';

  @override
  String get reviewDaysWritten => 'Dager skrevet';

  @override
  String get reviewWords => 'Ord';

  @override
  String get reviewPhotos => 'Bilder';

  @override
  String get reviewLongestRun => 'Lengste løp av dager';

  @override
  String get reviewAverageMood => 'Gjennomsnittlig humør';

  @override
  String get reviewFavorites => 'Oftest';

  @override
  String get reviewByMonth => 'Etter måned';

  @override
  String get reviewHighlight => 'Marker';

  @override
  String get yearInPixels => 'År i piksler';

  @override
  String get capsuleSeal => 'Forsegle som en tidskapsel';

  @override
  String get capsuleTitle => 'Tidskapsel';

  @override
  String capsuleOpensOn(Object date) {
    return 'Åpner på $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Skrevet på $date';
  }

  @override
  String get capsuleOpenEarly => 'Åpne tidlig';

  @override
  String get capsuleOpenEarlyDescription =>
      'Kapselen åpnes nå og forblir åpen.';

  @override
  String get capsuleOpened => 'Tidskapsel åpnet';

  @override
  String get templateMorningName => 'Morgen sider';

  @override
  String get templateMorningDescription => 'Sett opp dagen på tre minutter';

  @override
  String get templateMorningText =>
      '## Tre ting jeg vil gjøre godt i dag\n1. \n2. \n3. \n\n## Noe jeg ser frem til\n\n## En merknad til meg selv\n';

  @override
  String get templateEveningName => 'Kveldsanmeldelse';

  @override
  String get templateEveningDescription => 'Avslutt dagen med det som gikk bra';

  @override
  String get templateEveningText =>
      '## Tre gode ting i dag\n1. \n2. \n3. \n\n## Det jeg lærte\n\n## Hva kan gå bedre i morgen\n';

  @override
  String get routineMorning => 'God morgen';

  @override
  String get routineEvening => 'Kveldsanmeldelse';

  @override
  String get settingsRoutinePrompts => 'Forespørsler om morgen og kveld';

  @override
  String get settingsRoutinePromptsHint =>
      'Foreslå morgen- eller kveldsmalen i Stories';

  @override
  String get checkInTitle => 'Rask innsjekking';

  @override
  String get checkInSubtitle => 'Stemning i to trykk';

  @override
  String get checkInMood => 'Hvordan føler du deg?';

  @override
  String get checkInActivity => 'Hva gjør du?';

  @override
  String get checkInNote => 'En linje om det (valgfritt)';

  @override
  String get checkInSave => 'Lagre';

  @override
  String editorWordCount(int words, int characters) {
    return '$words ord · $characters tegn';
  }

  @override
  String get coachProgramEverydayTagline =>
      'Legg merke til de små tingene på en dag.';

  @override
  String get coachProgramReflectTagline => 'Senk farten og lytt til deg selv.';

  @override
  String get coachDuration => 'Varighet';

  @override
  String get coachInterval => 'Intervall';

  @override
  String get coachDifficulty => 'Vanskelighetsgrad';

  @override
  String get coachIntervalDaily => 'Daglig';

  @override
  String get coachIntervalWeekly => 'Ukentlig';

  @override
  String get coachDifficultyBeginner => 'Nybegynner';

  @override
  String get coachDifficultyIntermediate => 'Middels';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dager',
      one: '$count dag',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uker',
      one: '$count uke',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'Dag $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Uke $n';
  }

  @override
  String get coachEnroll => 'Meld deg på';

  @override
  String get coachEndProgram => 'Avslutt programmet';

  @override
  String get coachAuthor => 'Forfatter';

  @override
  String get coachAuthorBio => 'Forespørsler skrevet for denne appen.';

  @override
  String get coachEnrolledTip => 'Alt klart! Spørsmålene dine vises i Stories.';

  @override
  String get coachGoToStories => 'Gå til Stories';

  @override
  String get coachAnswerHint => 'Skriv svaret ditt...';

  @override
  String get storyWrapUp => 'Det var alt for i dag.';

  @override
  String get storyTapToClose => 'Trykk for å lukke';

  @override
  String get coachAnswerDone => 'Ferdig';

  @override
  String get coachAnswered => 'Besvart, trykk for å åpne';

  @override
  String get coachAnsweredEarlier => 'Besvart';

  @override
  String get locationLocating => 'Finner …';

  @override
  String get locationPickPlace => 'Velg et sted';

  @override
  String get locationPlacesHint => 'Adresse eller navn på stedet';

  @override
  String get locationCustom => 'Egendefinert sted';

  @override
  String get locationCurrent => 'Gjeldende plassering';

  @override
  String get locationSaved => 'Lagrede steder';

  @override
  String get locationSearchResults => 'Søkeresultater';

  @override
  String get locationNearby => 'Steder i nærheten';

  @override
  String get locationRename => 'Gi nytt navn';

  @override
  String get locationSavePlace => 'Lagre plass';

  @override
  String get locationUnsavePlace => 'Fjern fra lagrede steder';

  @override
  String get shareAs => 'Del som...';

  @override
  String get shareAsImage => 'Bilde';

  @override
  String get shareAsZip => 'ZIP med originalmediet';

  @override
  String get shareAsPlainText => 'Ren tekst';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Velkommen til AID Diary';

  @override
  String get onboardWelcomeText =>
      'Start her, eller koble denne enheten til en du allerede bruker.';

  @override
  String get onboardStart => 'Begynn å skrive';

  @override
  String get helpFaq => 'Ofte stilte spørsmål';

  @override
  String get helpFaq1Q => 'Hvor er dagboken min lagret?';

  @override
  String get helpFaq1A =>
      'Dagboken din er lagret på denne enheten. Den når andre enheter eller lagring kun når du aktiverer synkronisering, deling eller eksport. Synkronisering er ende-til-ende-kryptert.';

  @override
  String get helpFaq2Q =>
      'Hvordan beholder jeg en kopi eller flytter til en ny enhet?';

  @override
  String get helpFaq2A =>
      'Koble til en eksisterende enhet i Innstillinger → Data og lagring → Synkroniser og bekreft autorisasjonen på enheten som har dagboken din. Begge enhetene forblir brukbare. Du kan også lage en sikkerhetskopi og gjenopprette den på en annen enhet.';

  @override
  String get helpFaq3Q =>
      'Kan jeg hente inn oppføringer fra andre dagbok-apper?';

  @override
  String get helpFaq3A =>
      'Ja: i Innstillinger → Data og lagring, importer eksporter fra Daylio, Diarium, Diaro, DayBook, My Brain, OneShot og Pixels, eller en JSON-eksport.';

  @override
  String get helpFaq4Q => 'Hvordan fungerer trenerprogrammer?';

  @override
  String get helpFaq4A =>
      'Meld deg på et program på Coach-siden. Hver dag eller uke venter et nytt spørsmål i Stories; svaret ditt er lagret som en oppføring.';

  @override
  String get helpFaq5Q => 'Hva om jeg glemmer passordet mitt?';

  @override
  String get helpFaq5A =>
      'Passordet kan ikke gjenopprettes, så ta vare på en sikkerhetskopi av dagboken din.';

  @override
  String get helpPrivacy => 'Personvern';

  @override
  String get helpPrivacyText =>
      'Dagbokinnhold og media forblir på denne enheten med mindre du aktiverer kryptert synkronisering eller deler/eksporterer dem. Kart, stedsoppslag og vær bruker de konfigurerte tjenestene og sender plasseringen eller søket som trengs for den forespørselen, ikke dagboktekst.';

  @override
  String get photoMetaTitle => 'Vil du bruke detaljene til bildet?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Telle denne oppføringen for $date og angi dens plass til $place, som registrert på bildet?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Telle denne oppføringen for $date, når bildet ble tatt?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Sette denne oppføringens plass til $place, hvor ble bildet tatt?';
  }

  @override
  String get photoMetaApply => 'Bruk dem';

  @override
  String get quickWriteTitle => 'Skriv raskt';

  @override
  String get quickWriteText => 'Trykk for å starte en ny oppføring.';

  @override
  String get settingsQuickWriteTitle => 'Rask skriv i varsler';

  @override
  String get settingsQuickWriteDescription =>
      'Behold et varsel som åpner en ny oppføring.';

  @override
  String get settingsNudgesTitle => 'Dytt meg etter en stille strekning';

  @override
  String settingsNudgesDescription(int days) {
    return 'En mild påminnelse når du ikke har skrevet på $days dager.';
  }

  @override
  String get nudgeTitle => 'Det er en stund siden';

  @override
  String get nudgeMonday => 'En ny uke: hva ser du frem til?';

  @override
  String get nudgeTuesday => 'To linjer er nok. Hvordan har du det i dag?';

  @override
  String get nudgeWednesday => 'Halvveis i uken. Hva skilte seg ut så langt?';

  @override
  String get nudgeThursday => 'Noe lite verdt å beholde fra i dag?';

  @override
  String get nudgeFriday =>
      'Uken går mot slutten. Legg merke til ett godt øyeblikk.';

  @override
  String get nudgeSaturday => 'En treg lørdag er en god dag å skrive.';

  @override
  String get nudgeSunday => 'Se tilbake på uken før den er over.';

  @override
  String get photoWidgetEmpty =>
      'Bilder du legger til i oppføringer vises her.';

  @override
  String get channelReminders => 'Påminnelser';

  @override
  String get channelOnThisDay => 'På denne dagen';

  @override
  String get channelCoach => 'Trener spør';

  @override
  String get channelNudges => 'Dytter etter rolige dager';

  @override
  String get channelQuickWrite => 'Skriv raskt';

  @override
  String get channelBackup => 'Sikkerhetskopier';

  @override
  String get formatJsonExport => 'JSON (AID Diary eksport)';

  @override
  String get aboutModifiedNotice =>
      'En modifisert versjon av Daily You av Demizo og bidragsytere. Det er ikke den offisielle Daily You-appen.';

  @override
  String get toolbarPhotos => 'Legg til bilder';

  @override
  String get toolbarMedia => 'Bilder og videoer';

  @override
  String get mediaFromGallery => 'Velg fra galleri';

  @override
  String get mediaFromFiles => 'Velg fra filer';

  @override
  String get editorLeaveTitle => 'Lagre denne oppføringen?';

  @override
  String get editorLeaveDiscard => 'Ikke spar';

  @override
  String get editorTitleHint => 'Tittel';

  @override
  String get editorLocating => 'Finner …';

  @override
  String get toolbarVideo => 'Video';

  @override
  String get toolbarAudio => 'Stemmenotat';

  @override
  String get toolbarTags => 'Tagger';

  @override
  String get toolbarBulletList => 'Punktliste';

  @override
  String get toolbarHeading => 'Overskrift';

  @override
  String get toolbarBold => 'Fet';

  @override
  String get toolbarItalic => 'Kursiv';

  @override
  String get toolbarHighlight => 'Marker';

  @override
  String get toolbarStrikethrough => 'Gjennomstreking';

  @override
  String get toolbarQuote => 'Sitat';

  @override
  String get toolbarLink => 'Link';

  @override
  String get toolbarInsert => 'Sett inn';

  @override
  String get toolbarUndo => 'Angre';

  @override
  String get toolbarRedo => 'Gjenta';

  @override
  String get toolbarInsertDate => 'Sett inn datoen';

  @override
  String get toolbarInsertTime => 'Sett inn tiden';

  @override
  String get settingsSyncTitle => 'Skysynkronisering';

  @override
  String get syncOffDescription =>
      'Hold denne dagboken den samme på alle enhetene dine gjennom Google Drive eller en WebDAV-server, for eksempel Nextcloud, Synology eller Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'Synkroniser med Google Drive';

  @override
  String get syncOrWebDav => 'Eller en WebDAV-server';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn => 'Pålogget. Du kan gå tilbake til AID Diary.';

  @override
  String get syncGoogleSignInAgain => 'Google trenger at du logger på igjen.';

  @override
  String get syncSignInAgain => 'Logg på igjen';

  @override
  String get settingsCommandLineTitle => 'Kommandolinje';

  @override
  String get commandLineToggle => 'Kommandolinjegrensesnitt';

  @override
  String get commandLineToggleHint =>
      'Lar hjelpekommandoen og andre programmer på denne enheten bruke appens kommandoer.';

  @override
  String get commandLineAlwaysOn => 'Alltid på i utviklingsbygg.';

  @override
  String commandLineListening(int port) {
    return 'Lytter på port $port';
  }

  @override
  String get commandPaletteTitle => 'Alle kommandoer';

  @override
  String get commandPaletteSearch => 'Søkekommandoer';

  @override
  String get commandPaletteRun => 'Løp';

  @override
  String get commandPaletteConfirm => 'Dette kan ikke bare angres. Kjøre det?';

  @override
  String syncReceiving(int done, int total) {
    return 'Mottar $done av $total...';
  }

  @override
  String syncSending(int done, int total) {
    return 'Sender $done av $total …';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'Tilgang til Google Drive var ikke tillatt. Koble til igjen og huk av for Google Drive på Googles side.';

  @override
  String get syncEntryUnsynced =>
      'Ikke synkronisert: den siste synkroniseringen gikk ikke gjennom';

  @override
  String get syncUseOfficial => 'Bruk AID-synkroniseringsserveren';

  @override
  String get syncServer => 'Serveradresse';

  @override
  String get syncUsername => 'Brukernavn';

  @override
  String get syncPassword => 'Passord';

  @override
  String get syncConnect => 'Koble til';

  @override
  String get syncConnecting => 'Kobler til …';

  @override
  String get syncSignInFailed =>
      'Kunne ikke logge på. Sjekk adressen, brukernavnet og passordet.';

  @override
  String syncConnectFailed(String error) {
    return 'Kunne ikke koble til: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Begynn å synkronisere';

  @override
  String get syncNewSpaceDescription =>
      'Det er ingen synkronisert dagbok her ennå. Denne dagboken vil bli lastet opp, ende-til-ende kryptert med en nøkkel som blir værende på enhetene dine.';

  @override
  String get syncJoinTitle => 'Bli med i den synkroniserte dagboken';

  @override
  String get syncWrongKey =>
      'Denne gjenopprettingskoden åpner ikke den synkroniserte dagboken.';

  @override
  String syncLastSynced(String time) {
    return 'Sist synkronisert $time';
  }

  @override
  String get syncNever => 'Ikke synkronisert ennå';

  @override
  String get syncSyncing => 'Synkroniserer …';

  @override
  String syncFailed(String error) {
    return 'Den siste synkroniseringen mislyktes: $error';
  }

  @override
  String get syncLocked =>
      'Den synkroniserte dagboken tilhører nå andre enheter, eller ble startet på nytt. Par med en av dem eller bruk gjenopprettingskoden for å fortsette å synkronisere.';

  @override
  String get syncNow => 'Synkroniser nå';

  @override
  String get syncUnlock => 'Lås opp';

  @override
  String get syncEncrypted => 'Ende-til-ende kryptert';

  @override
  String get syncDisconnect => 'Stopp synkroniseringen';

  @override
  String get syncDisconnectDescription =>
      'Denne enheten slutter å synkronisere. Dagboken her og den synkroniserte kopien blir som de er.';

  @override
  String get syncOwnRecoveryPassword => 'Bruk mitt eget gjenopprettingspassord';

  @override
  String get syncRecoveryPassword => 'Gjenopprettingspassord';

  @override
  String get syncRecoveryPasswordRepeat => 'Gjenta gjenopprettingspassordet';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Bruk minst $min tegn';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'Passordene er forskjellige';

  @override
  String get syncRecoveryCode => 'Gjenopprettingskode';

  @override
  String get syncRecoveryCodeTitle => 'Lagre gjenopprettingskoden';

  @override
  String get syncRecoveryCodeDescription =>
      'Hvis alle enhetene dine går tapt, gjenoppretter denne koden din synkroniserte dagbok. Oppbevar det i en passordbehandling eller på papir. Den vises kun denne ene gang.';

  @override
  String get syncRecoveryCodeCopied => 'Gjenopprettingskoden er kopiert';

  @override
  String get syncRecoveryCodeSaved => 'Jeg har lagret den';

  @override
  String get syncJoinNeedsKey =>
      'Denne synkroniserte dagboken tilhører de andre enhetene dine. Par med en av dem, eller bruk gjenopprettingskoden. Oppføringene på denne enheten vil bli lagt til den.';

  @override
  String get syncPairDevice => 'Par med en enhet';

  @override
  String get syncUseRecoveryCode => 'Bruk gjenopprettingskoden';

  @override
  String get syncAddDevice => 'Legg til en enhet';

  @override
  String get syncChangeRecoveryCode => 'Endre gjenopprettingskoden';

  @override
  String get syncChangeRecoveryDescription =>
      'En ny kode erstatter den nåværende, som slutter å fungere. Dataene dine og andre enheter forblir som de er.';

  @override
  String get syncNewRandomCode => 'Ny tilfeldig kode';

  @override
  String get syncRecoveryCodeChanged => 'Gjenopprettingskoden er endret';

  @override
  String get syncResetSpace => 'Start den synkroniserte dagboken på nytt';

  @override
  String get syncResetSpaceDescription =>
      'Bare når ingen enhet og ingen gjenopprettingskode åpner den lenger: den synkroniserte kopien erstattes av dagboken på denne enheten, under denne enhetens nøkler. De andre enhetene dine pares deretter på nytt.';

  @override
  String get syncPairTitle => 'Par enheter';

  @override
  String get syncPairShow => 'Vis en kode';

  @override
  String get syncPairEnter => 'Skriv inn en kode';

  @override
  String get syncPairShowHint =>
      'På den andre enheten åpner du Sammenkoble enheter, velger Skriv inn en kode, og skriv eller skann denne.';

  @override
  String get syncPairEnterHint =>
      'Skriv inn koden den andre enheten viser, eller skann den.';

  @override
  String get syncPairCode => 'Paringskode';

  @override
  String get syncPairScan => 'Skann';

  @override
  String get syncPairStart => 'Par';

  @override
  String get syncPairWaiting => 'Venter på den andre enheten …';

  @override
  String syncPairDone(String device) {
    return 'Sammenkoblet med $device';
  }

  @override
  String get syncPairWrongCode =>
      'Koden stemte ikke. Vis en ny kode og prøv igjen.';

  @override
  String get syncPairNoOffer =>
      'Ingen enhet viser denne koden. Det kan ha gått ut på dato.';

  @override
  String get syncPairTimedOut => 'Den andre enheten svarte ikke i tide.';

  @override
  String get syncPairNeither =>
      'Ingen av enhetene er konfigurert med denne synkroniserte dagboken ennå.';

  @override
  String get syncPairBoth =>
      'Begge enhetene åpner allerede denne synkroniserte dagboken.';

  @override
  String syncPairFailed(String error) {
    return 'Sammenkobling mislyktes: $error';
  }

  @override
  String get syncMediaPending =>
      'Dagbok synkronisert · noen medier overføres fortsatt';

  @override
  String get syncWaitingForDevices =>
      'Dagbok synkronisert · venter på at en annen enhet skal overføre media';

  @override
  String get syncCacheNotice =>
      'Skymedia er midlertidig. Behold originalene på enhetene dine; synkronisering er ikke en sikkerhetskopi.';

  @override
  String get paperTitle => 'Brevpapir';

  @override
  String get paperPlain => 'Vanlig';

  @override
  String get paperLined => 'Foret';

  @override
  String get paperGrid => 'Rutenett';

  @override
  String get paperTinted => 'Tonet';

  @override
  String get paperDecorationTitle => 'Dekorasjoner';

  @override
  String get paperDecorationNone => 'Ingen';

  @override
  String get paperDecorationBotanical => 'Blader';

  @override
  String get paperDecorationStars => 'Stjerner';

  @override
  String get paperDecorationWashi => 'Washi tape';

  @override
  String get themeDarkChoice => 'Mørkt utseende';

  @override
  String get themeDarkSame => 'Følg lyspalett';

  @override
  String get themeDarkCustom => 'Separat palett';

  @override
  String get themeDarkAccent => 'Mørk aksentfarge';

  @override
  String get themeColorTeal => 'Blågrønn';

  @override
  String get themeColorCyan => 'Cyan';

  @override
  String get themeColorIndigo => 'Indigo';

  @override
  String get themeColorCoral => 'Koraller';

  @override
  String get themeColorOlive => 'Oliven';

  @override
  String get themeColorSlate => 'Skifer';

  @override
  String get drawingTitle => 'Tegning';

  @override
  String get drawingPen => 'Penn';

  @override
  String get drawingEraser => 'Viskelær';

  @override
  String get drawingUndo => 'Angre';

  @override
  String get drawingClear => 'Tøm';

  @override
  String get drawingWidth => 'Pennebredde';

  @override
  String get drawingStylusOnly => 'Kun pekepenn';

  @override
  String get drawingDiscardTitle => 'Forkaste tegningen?';

  @override
  String get drawingDiscardBody => 'Denne tegningen er ikke lagret.';

  @override
  String get drawingSaveError => 'Kunne ikke lagre tegningen.';

  @override
  String get syncNetworkTitle => 'Nettverksdiagnostikk';

  @override
  String get syncNetworkRefresh => 'Oppdater';

  @override
  String get syncNetworkSelectedRoute => 'Gjeldende bane';

  @override
  String get syncNetworkAvailableRoutes => 'Tilgjengelige stier';

  @override
  String get syncNetworkSignaling => 'Enhetskatalogtilkobling';

  @override
  String get syncNetworkRelayRemaining => 'Gjenstående stafettgodtgjørelse';

  @override
  String get syncNetworkIcePair => 'Direkte koblingskandidater';

  @override
  String get syncNetworkPeerTrusted => 'Autentisert enhet';

  @override
  String get syncNetworkNoRoute => 'Venter på en tilkobling';

  @override
  String get syncNetworkUnavailable => 'Diagnostikk er utilgjengelig';

  @override
  String get syncMediaCopiesTitle => 'Medielevering og kopier';

  @override
  String get syncMediaPendingCount => 'Venter på overføring';

  @override
  String get syncMediaDurableCount => 'Leveres til personlig oppbevaring';

  @override
  String get syncMediaTemporaryCount => 'Midlertidige eller ubekreftede kopier';

  @override
  String get syncMediaReceiptExplanation =>
      'Disse tellingene beskriver fullførte leveranser, ikke en ny revisjon av overlevende sikkerhetskopier.';

  @override
  String get syncMediaCacheExplanation =>
      'Midlertidige skymedier kan utløpe. Behold originalene eller en separat sikkerhetskopi.';

  @override
  String get momentsTitle => 'Fotoøyeblikk';

  @override
  String get momentsHint =>
      'Finn grupper ved å bruke lokale fototider og valgfrie koordinater. Bilder legges ved kun når du velger et kort.';

  @override
  String get momentsScan => 'Finn øyeblikk';

  @override
  String get momentsChooseFolder => 'Velg bildemappe';

  @override
  String get momentsLocation => 'Inkluder bildeplasseringer';

  @override
  String get momentsEmpty => 'Ingen nylige bildegrupper.';

  @override
  String get momentsCreate => 'Skriv om disse bildene';

  @override
  String get momentsDismiss => 'Avvis';

  @override
  String get momentsError => 'Kunne ikke lese lokale bilder.';

  @override
  String get momentsCreated => 'Bildeinnlegg opprettet.';

  @override
  String get momentsPermission =>
      'Gi tilgang til bilder for å finne lokale forslag.';

  @override
  String get momentsScope =>
      'Kun siste bilder; maksimalt 500 bilder og 20 bilder per kort.';

  @override
  String momentsPhotoCount(int count) {
    return '$count bilder';
  }

  @override
  String get nearbyTitle => 'Koble til enheter';

  @override
  String get nearbySend => 'Autoriser en annen enhet';

  @override
  String get nearbyReceive => 'Koble til en eksisterende enhet';

  @override
  String get nearbyInstructions =>
      'Koble begge enhetene til samme Wi-Fi eller til hverandres hotspot. Bekreft autorisasjon på den eksisterende enheten; begge enhetene forblir brukbare. Ingen internett er nødvendig.';

  @override
  String get nearbyCompare =>
      'Sammenlign denne koden på begge enhetene før du godkjenner.';

  @override
  String get nearbyConfirm => 'Kodene stemmer overens';

  @override
  String get nearbyScan => 'Skann den andre enhetens kode';

  @override
  String get nearbyPaste => 'Lim inn invitasjon';

  @override
  String get nearbyWaiting => 'Venter på godkjenning på den andre enheten';

  @override
  String get nearbyWorking =>
      'Godkjenner og synkroniserer dagboken og vedleggene ...';

  @override
  String get nearbyPending =>
      'Noen vedlegg trenger fortsatt synkronisering. Hold den andre enheten tilkoblet og prøv igjen.';

  @override
  String get nearbyComplete =>
      'Enhet tilkoblet; dagbok og vedlegg synkronisert';

  @override
  String get nearbyFailed =>
      'Tilkoblingen ble ikke fullført. Sjekk den lokale tilkoblingen og prøv igjen.';

  @override
  String get nearbyEmptyRequired =>
      'Bruk en enhet med en tom dagbok som ikke er koblet til synkronisering ennå.';

  @override
  String get nearbyRetry => 'Fortsett synkroniseringen';

  @override
  String get nearbyWifi => 'Wi-Fi-innstillinger';

  @override
  String get nearbyHotspot => 'Hotspot-innstillinger';

  @override
  String get nearbyKeepOpen =>
      'Hold denne siden åpen til den nye enheten er ferdig. Invitasjonen utløper etter to minutter.';

  @override
  String get syncDevicesTitle => 'Autoriserte enheter';

  @override
  String get syncDevicesDescription =>
      'Bare godkjente enheter har tilgang til denne AID-kontoen. Å tilbakekalle en enhet blokkerer serveren, men kan ikke slette en hovednøkkel eller dagbok som allerede er kopiert til den.';

  @override
  String get syncDeviceRequest =>
      'Vis denne autorisasjons-QR-en til en godkjent enhet';

  @override
  String get syncDeviceAuthorize => 'Autoriser en enhet';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Skann eller lim inn den nye enhetens autorisasjonsforespørsel.';

  @override
  String get syncDeviceRevoke => 'Oppheve';

  @override
  String get syncDeviceRotate => 'Roter denne enhetens signeringsnøkkel';

  @override
  String get syncDeviceCheck => 'Sjekk autorisasjonen';

  @override
  String get syncDeviceHardware => 'Maskinvarestøttet signeringsnøkkel';

  @override
  String get syncDeviceSoftware =>
      'Ikke-eksporterbar programvaresigneringsnøkkel';

  @override
  String get syncDeviceUnavailable =>
      'Enhetsautorisasjon er utilgjengelig. Godkjenn denne enheten fra en annen autorisert enhet og prøv på nytt.';

  @override
  String get syncDeviceRevoked => 'Opphevet';

  @override
  String get syncDeviceLocal => 'Denne enheten';

  @override
  String get cloudTrafficTitle =>
      'Månedlig skydataoverføringskvote for mediefiler';

  @override
  String get cloudTrafficLimit => 'Månedlig dataoverføringskvote';

  @override
  String get cloudTrafficUsed => 'Dataoverføring brukt';

  @override
  String get cloudTrafficRemaining => 'Dataoverføring gjenstår';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'Dataoverføringskvoten tilbakestiller $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'Skydataoverføringskvoten for mediefiler er brukt opp. Manglende mediefiler synkroniseres automatisk når en direkte tilkobling er tilgjengelig eller kvoten tilbakestilles.';

  @override
  String get cloudTrafficExplanation =>
      'Mediefilbufring og live relé deler denne dataoverføringskvoten. Direkte tilkoblinger bruker det ikke. Dagboktekst og tilkoblingskontrollmeldinger har separate små daglige grenser.';

  @override
  String get appearanceThemeSection => 'App-tema';

  @override
  String get appearancePaperSection => 'Dagbok papir';

  @override
  String get appearanceTypographySection => 'Dagboktekst';

  @override
  String get appearancePreferencesSection => 'Generelle preferanser';

  @override
  String get themeSystemAccentHint =>
      'Bruker systempaletten i stedet for egendefinerte farger. Slå den av for å velge din egen.';

  @override
  String get syncDeviceNameSaveFailed =>
      'Kunne ikke lagre enhetsnavnet. Vennligst prøv igjen.';

  @override
  String get nearbyConnectionHelp => 'Tilkoblingshjelp';

  @override
  String get syncAllSynced => 'Alt synkronisert';

  @override
  String get syncDetailsTitle => 'Synkroniser detaljer';

  @override
  String get syncMore => 'Flere alternativer';

  @override
  String get syncDeviceName => 'Enhetsnavn';

  @override
  String get syncDeviceNameHint => 'For eksempel: Nettbrettet mitt';

  @override
  String get syncDeviceNameInvalid => 'Bruk 1 til 32 tegn';

  @override
  String get syncDeviceKeyDetails => 'Sikkerhetsdetaljer';

  @override
  String get syncConnectionProblem =>
      'Kan ikke synkronisere foreløpig. Prøver automatisk på nytt.';

  @override
  String get syncCopyComplete => 'Komplett kopi av dagboken og mediefiler';

  @override
  String get syncCopyPartial => 'Noen medier mangler fortsatt';

  @override
  String get syncCopyOlder => 'Nye endringer venter på å synkroniseres';

  @override
  String get syncCopyUnavailable =>
      'Kopidetaljer er utilgjengelige. Prøv igjen senere.';

  @override
  String get syncCopyLastKnown =>
      'Andre enheter viser sin siste bekreftede kopi. Frakoblede enheter kan ikke sjekkes nå.';

  @override
  String get syncCopyTemporary =>
      'Midlertidig cache. Behold originalene på enhetene dine.';

  @override
  String get syncCopyStorage =>
      'Din synkroniseringslagring. Fullførte medieopplastinger er oppført i diagnostikk.';

  @override
  String syncCopyChecked(String time) {
    return 'Sist bekreftet $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Gjenstående dataoverføring denne måneden: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Start her';

  @override
  String get onboardConnect => 'Koble til en eksisterende enhet';

  @override
  String get onboardFailed =>
      'Konfigurasjonen kunne ikke fullføres. Dagboken din er trygg; vennligst prøv igjen.';

  @override
  String get tutorialTitle => 'Hvordan bruke dagboken';

  @override
  String get tutorialWriteTitle => 'Skriv din første dagbokoppføring';

  @override
  String get tutorialWriteText =>
      'Trykk på + for å skrive en dagbokoppføring. Legg til en valgfri tittel, velg dagbokdatoen og trykk på haken for å lagre. Du kan når som helst redigere dagbokoppføringen din igjen.';

  @override
  String get tutorialMediaTitle => 'Legg til bilder, lyd eller håndskrift';

  @override
  String get tutorialMediaText =>
      'Bruk + i dagbokredigering for å legge ved bilder, videoer eller et stemmeopptak, eller for å åpne håndskriftslerretet. Disse vedleggene lagres sammen med dagbokoppføringen.';

  @override
  String get tutorialReviewTitle => 'Finn en dag igjen';

  @override
  String get tutorialReviewText =>
      'Bla gjennom dagboken eller kalenderen din, søk i teksten din og organiser oppføringer med etiketter. Media- og Atlas-sidene lar deg finne tidligere oppføringer etter bilde eller sted.';

  @override
  String get tutorialSyncTitle => 'Bruk mer enn én enhet';

  @override
  String get tutorialSyncText =>
      'I Innstillinger → Data og lagring → Synkroniser, koble til en eksisterende enhet og bekreft autorisasjon på den enheten. Begge enhetene kan fortsette å bruke dagboken. Dagboktekst synkroniseres først. Mediefiler synkroniseres neste gang når nettverkstilkoblingen og gjenværende dataoverføringskvote tillater det.';

  @override
  String get tutorialPrivacyTitle => 'Ta vare på dagboken din';

  @override
  String get tutorialPrivacyText =>
      'Dagbokoppføringer forblir på denne enheten med mindre du aktiverer synkronisering eller deler eller eksporterer dem. Synkronisering er ende-til-ende-kryptert. I Innstillinger kan du også angi en app-passord, lage sikkerhetskopier og åpne denne opplæringen på nytt.';

  @override
  String get editorDiaryDay => 'Dagbokdato';

  @override
  String get editorDiaryDayPicker => 'Dagbokdato · opprettelsestid beholdes';

  @override
  String get editorDiaryDayHint =>
      'Dagen dette innlegget tilhører. En endring endrer ikke tidspunktet innlegget ble opprettet.';

  @override
  String get hiddenDiaryTitle => 'Skjulte innlegg';

  @override
  String get hiddenDiaryHide => 'Skjul innlegg';

  @override
  String get hiddenDiaryShow => 'Vis innlegg';

  @override
  String get hiddenDiaryEmpty => 'Ingen skjulte innlegg';

  @override
  String get hiddenDiaryUnlock => 'Lås opp skjulte innlegg';

  @override
  String get hiddenDiaryAuthHint => 'Bruk applåsen eller enhetens skjermlås.';

  @override
  String get moodClear => 'Fjern humør';

  @override
  String get scrollToTop => 'Til toppen';

  @override
  String get feedbackTitle => 'Tilbakemelding';

  @override
  String get feedbackHint => 'Beskriv et problem eller forslag';

  @override
  String get feedbackGithub => 'GitHub-sak';

  @override
  String get feedbackEmail => 'Send e-post';

  @override
  String get feedbackCopy => 'Kopier tekst';

  @override
  String get feedbackLaunchFailed =>
      'Kunne ikke åpne appen. Kopier teksten og bruk e-postadressen nedenfor.';

  @override
  String get feedbackCopied => 'Tilbakemelding kopiert';
}
