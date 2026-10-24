// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => 'Tema farve';

  @override
  String get themeColorHint => 'Vælg en farve til denne palet.';

  @override
  String get themeColorBlue => 'Himmelblå';

  @override
  String get themeColorGreen => 'Skov grøn';

  @override
  String get themeColorBrown => 'Varm kaffe';

  @override
  String get themeColorPurple => 'Lavendel';

  @override
  String get themeColorRose => 'Støvet rose';

  @override
  String get themeColorAmber => 'Rav';

  @override
  String get themeColorPreview => 'Lidt hver dag';

  @override
  String get themeTintBackgroundTitle => 'Farve baggrunde med temafarve';

  @override
  String get themeTintBackgroundHint =>
      'Sluk for neutrale grå baggrunde; knapper holder din valgte farve.';

  @override
  String get dailyReminderTitle => 'Log i dag!';

  @override
  String get dailyReminderDescription => 'Skriv din daglige log…';

  @override
  String get actionTakePhoto => 'Tag billede';

  @override
  String get flashbacksTitle => 'Minder';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Ekskluder dårlige dage';

  @override
  String get flashbackGoodDay => 'En god dag';

  @override
  String get flashbackRandomDay => 'En tilfældig dag';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uger siden',
      one: '$count uge siden',
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
  String get flashbackOnThisDay => 'På denne dag';

  @override
  String get searchLogsHint => 'Søg i logs…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagbogsnotater',
      one: '$count dagbogsnotat',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dage',
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
  String get noLogs => 'Ingen logs…';

  @override
  String get noResults => 'Ingen resultater...';

  @override
  String get sortOrderAscendingTitle => 'Stigende';

  @override
  String get sortOrderDescendingTitle => 'Faldende';

  @override
  String get pageStatisticsTitle => 'Statistikker';

  @override
  String get statisticsNotEnoughData => 'Ikke nok data…';

  @override
  String get statisticsRangeOneMonth => '1 måned';

  @override
  String get statisticsRangeSixMonths => '6 måneder';

  @override
  String get statisticsRangeOneYear => '1 år';

  @override
  String get statisticsRangeAllTime => 'Altid';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag oversigt';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag efter dag';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag over tid';
  }

  @override
  String get chartGroupingLabel => 'Grupper efter';

  @override
  String get chartGroupingDay => 'dag';

  @override
  String get chartGroupingWeek => 'uge';

  @override
  String get chartGroupingMonth => 'Måned';

  @override
  String get chartGroupingYear => 'år';

  @override
  String get chartSmoothingLabel => 'Udglatning';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nuværende stribe $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Længste stribe $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Store dage $count',
      one: 'Store dage $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dage siden en dårlig dag $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle => 'Kan ikke tilgå eksternt lager';

  @override
  String get errorExternalStorageAccessDescription =>
      'Hvis du bruger netværkslagring, skal du sikre, at tjenesten er online, og at du har netværksadgang.\n\nEllers kan appen have mistet tilladelser til den eksterne mappe. Gå til indstillinger og vælg den igen for at gendanne adgang.\n\nAdvarsel: Ændringer synkroniseres ikke, før adgangen til lagringsplaceringen er gendannet!';

  @override
  String get errorExternalStorageAccessContinue => 'Fortsæt med lokal database';

  @override
  String get lastModified => 'Ændret';

  @override
  String get writeSomethingHint => 'Skriv noget…';

  @override
  String get titleHint => 'Titel…';

  @override
  String get deleteLogTitle => 'Slet log';

  @override
  String get deleteLogDescription => 'Vil du slette denne log?';

  @override
  String get deletePhotoTitle => 'Slet foto';

  @override
  String get deletePhotoDescription => 'Vil du slette dette foto?';

  @override
  String get pageSettingsTitle => 'Indstillinger';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Lys';

  @override
  String get themeDark => 'Mørk';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Ugens første dag';

  @override
  String get settingsCalendarSystem => 'Kalendersystem';

  @override
  String get calendarSystemGregorian => 'gregoriansk';

  @override
  String get calendarSystemJalali => 'Jalali';

  @override
  String get settingsUseSystemAccentColor => 'Brug systemets accentfarve';

  @override
  String get settingsCustomAccentColor => 'Brugerdefineret accentfarve';

  @override
  String get settingsShowFlashbacks => 'Vis minder';

  @override
  String get settingsChangeMoodIcons => 'Skift humør-ikoner';

  @override
  String get moodIconPrompt => 'Angiv et ikon';

  @override
  String get settingsHideImages => 'Skjul billeder';

  @override
  String get pageCalendarTitle => 'Kalender';

  @override
  String get settingsNotificationsTitle => 'Meddelelser';

  @override
  String get settingsDailyReminderTitle => 'Daglig påmindelse';

  @override
  String get settingsOnThisDayDescription => 'Gense tidligere minder';

  @override
  String get settingsDailyReminderDescription =>
      'Lad appen køre i baggrunden for bedste resultater';

  @override
  String get settingsReminderTime => 'Påmindelsestid';

  @override
  String get settingsFixedReminderTimeTitle => 'Fast påmindelsestid';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Vælg et fast tidspunkt for påmindelsen';

  @override
  String get settingsAlwaysSendReminderTitle => 'Send altid påmindelse';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Send påmindelse, selvom en log allerede er startet';

  @override
  String get settingsCustomizeNotificationTitle => 'Tilpas meddelelser';

  @override
  String get settingsTemplatesTitle => 'Skabeloner';

  @override
  String get manageTemplates => 'Administrer skabeloner';

  @override
  String get noTemplateTitle => 'Ingen';

  @override
  String get noTemplatesDescription => 'Ingen skabeloner oprettet endnu…';

  @override
  String get templateDefaultTimestampTitle => 'Tidsstempel';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Dagsoversigt';

  @override
  String get templateDefaultSummaryBody => '### Resumé\n- \n\n### Citat\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Refleksion';

  @override
  String get templateDefaultReflectionBody =>
      '### Hvad kunne du lide ved i dag?\n- \n\n### Hvad er du taknemmelig for?\n- \n\n### Hvad glæder du dig til?\n- ';

  @override
  String get settingsTagsTitle => 'Tags';

  @override
  String get manageTags => 'Administrer tags';

  @override
  String get tagTypeLabelTitle => 'Etiket';

  @override
  String get tagTypeTrackerTitle => 'Tracker';

  @override
  String get nameHint => 'Navn';

  @override
  String get tagColorLabel => 'Farve';

  @override
  String get iconPickerTitle => 'Vælg ikon';

  @override
  String get iconPickerIconsTab => 'Ikoner';

  @override
  String get iconPickerCustomTab => 'Brugerdefineret';

  @override
  String get iconPickerSearchHint => 'Søg ikoner...';

  @override
  String get colorPickerTitle => 'Vælg Farve';

  @override
  String get colorPickerPaletteTab => 'Farver';

  @override
  String get iconGroupMoodPeople => 'Stemning og mennesker';

  @override
  String get iconGroupHealth => 'Sundhed';

  @override
  String get iconGroupWorkFinance => 'Arbejde & Økonomi';

  @override
  String get iconGroupHabitsGoals => 'Vaner og mål';

  @override
  String get iconGroupNature => 'Naturen';

  @override
  String get iconGroupFoodDrink => 'Mad & drikke';

  @override
  String get iconGroupHome => 'Hjem';

  @override
  String get iconGroupTravel => 'Rejser';

  @override
  String get iconGroupSymbols => 'Symboler';

  @override
  String get tagCategoryLabel => 'Kategori';

  @override
  String get tagLabel => 'Tag';

  @override
  String get tagCategoryUncategorized => 'Ikke kategoriseret';

  @override
  String get newCategoryTitle => 'Ny kategori';

  @override
  String get shareButtonLabel => 'Del';

  @override
  String get importErrorDescription => 'Kunne ikke importere filen!';

  @override
  String get exportErrorDescription => 'Filen kunne ikke eksporteres!';

  @override
  String get deleteTitle => 'Slet';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Det bruges i $count dagbogsoptegnelser.',
      one: ' Det bruges i $count dagbogsoptegnelse.',
      zero: '',
    );
    return 'Vil du slette \"$name\"?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Dens $count tags vil også blive slettet.',
      one: ' Dens $count tag vil også blive slettet.',
      zero: '',
    );
    return 'Vil du slette \"$name\"?$_temp0';
  }

  @override
  String get tagNameExists => 'Der er allerede et tag med dette navn';

  @override
  String get categoryNameExists => 'Der er allerede en kategori med dette navn';

  @override
  String deleteTemplateMessage(Object name) {
    return 'Vil du slette \"$name\"?';
  }

  @override
  String get addTagsTitle => 'Tilføj tags';

  @override
  String get addTagsSearchHint => 'Søg tags...';

  @override
  String get tagFavoriteName => 'Favorit';

  @override
  String get iconGroupActivities => 'Aktiviteter';

  @override
  String get iconGroupHobbies => 'Underholdning';

  @override
  String get settingsStorageTitle => 'Lager';

  @override
  String get settingsImageQuality => 'Billedkvalitet';

  @override
  String get imageQualityHigh => 'Høj';

  @override
  String get imageQualityMedium => 'Middel';

  @override
  String get imageQualityLow => 'Lav';

  @override
  String get imageQualityNoCompression => 'Ingen komprimering';

  @override
  String get settingsLogFolder => 'Logmappe';

  @override
  String get settingsImageFolder => 'Billedmappe';

  @override
  String get warningTitle => 'Advarsel';

  @override
  String get logFolderWarningDescription =>
      'Hvis den valgte mappe allerede indeholder en \'aid_diary.db\'-fil, bruges den til at overskrive dine eksisterende logs!';

  @override
  String get errorTitle => 'Fejl';

  @override
  String get logFolderErrorDescription => 'Kunne ikke ændre logmappe!';

  @override
  String get imageFolderErrorDescription => 'Kunne ikke ændre billedmappe!';

  @override
  String get backupErrorDescription => 'Kunne ikke oprette sikkerhedskopi!';

  @override
  String get restoreErrorDescription => 'Kunne ikke gendanne sikkerhedskopi!';

  @override
  String get settingsBackupRestoreTitle => 'Sikkerhedskopiering og gendannelse';

  @override
  String get settingsBackup => 'Sikkerhedskopiér';

  @override
  String get settingsRestore => 'Gendan';

  @override
  String get settingsRestorePromptDescription =>
      'Gendannelse af en sikkerhedskopi overskriver dine eksisterende data!';

  @override
  String get settingsBackupPasswordProtect =>
      'Adgangskodebeskytte sikkerhedskopier';

  @override
  String get backupEncryptedTitle => 'Krypteret sikkerhedskopiering';

  @override
  String get backupEncryptedContent =>
      'Denne backup er beskyttet med adgangskode.';

  @override
  String get settingsAutoBackup => 'Automatiske sikkerhedskopier';

  @override
  String get settingsAutoBackupLocation => 'Backup placering';

  @override
  String get settingsAutoBackupInterval => 'Backup interval';

  @override
  String get settingsAutoBackupIntervalDaily => 'Dagligt';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Ugentligt';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Månedligt';

  @override
  String get settingsAutoBackupMaxCount => 'Sikkerhedskopier at beholde';

  @override
  String get settingsAutoBackupRequireCharging => 'Kun under opladning';

  @override
  String settingsBackupLast(Object time) {
    return 'Sidste backup $time';
  }

  @override
  String get settingsBackupNever => 'Aldrig sikkerhedskopieret';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Næste backup $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'Alle';

  @override
  String get autoBackupFailedTitle => 'Sikkerhedskopiering mislykkedes';

  @override
  String tranferStatus(Object percent) {
    return 'Overfører… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Opretter sikkerhedskopi… $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Gendanner sikkerhedskopi… $percent%';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return 'Krypterer sikkerhedskopiering… $percent %';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Dekrypterer sikkerhedskopien… $percent %';
  }

  @override
  String get cleanUpStatus => 'Rydder op…';

  @override
  String get settingsExportToAnotherFormat => 'Eksporter til et andet format';

  @override
  String get settingsExportFormatDescription =>
      'Dette bør ikke bruges som backup!';

  @override
  String get settingsImportFromAnotherApp => 'Importér fra en anden app';

  @override
  String get logFormatTitle => 'Vælg format';

  @override
  String get logFormatDescription =>
      'En anden apps format understøtter muligvis ikke alle funktioner. Dette påvirker ikke eksisterende logs!';

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
  String get settingsDeleteAllLogsTitle => 'Slet alle logs';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Vil du slette alle dine logs?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Indtast \'$prompt\' for at bekræfte. Dette kan ikke fortrydes!';
  }

  @override
  String get settingsAppLanguageTitle => 'App sprog';

  @override
  String get settingsSecurityTitle => 'Sikkerhed';

  @override
  String get settingsSecurityRequirePassword => 'Kræv adgangskode';

  @override
  String get settingsSecurityEnterPassword => 'Indtast adgangskode';

  @override
  String get settingsSecuritySetPassword => 'Indstil adgangskode';

  @override
  String get settingsSecurityChangePassword => 'Skift adgangskode';

  @override
  String get settingsSecurityPassword => 'Adgangskode';

  @override
  String get settingsSecurityConfirmPassword => 'Bekræft adgangskode';

  @override
  String get settingsSecurityOldPassword => 'Gammel adgangskode';

  @override
  String get settingsSecurityIncorrectPassword => 'Forkert adgangskode';

  @override
  String get settingsSecurityPasswordsDoNotMatch =>
      'Adgangskoder stemmer ikke overens';

  @override
  String get requiredPrompt => 'Påkrævet';

  @override
  String get settingsSecurityBiometricUnlock => 'Biometrisk oplåsning';

  @override
  String get unlockAppPrompt => 'Lås appen op';

  @override
  String get settingsAboutTitle => 'Om';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsLicense => 'Licens';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsOpenSourceLicenses => 'Open Source-licenser';

  @override
  String get tagMoodTitle => 'Humør';

  @override
  String get selectTagTitle => 'Vælg Tag';

  @override
  String get labelPresentLabel => 'Til stede';

  @override
  String get labelAbsentLabel => 'Fraværende';

  @override
  String get labelCoverageLabel => 'Dækning';

  @override
  String chartDistributionTitle(Object tag) {
    return '$tag Distribution';
  }

  @override
  String get shareAddToLogPickerTitle => 'Vælg en dagbogsoptegnelse';

  @override
  String get adaptiveEmptyDay => 'Ingen tilmeldinger for denne dag endnu';

  @override
  String get adaptiveNewEntry => 'Skriv et indlæg';

  @override
  String get pageJournalTitle => 'Dagbog';

  @override
  String get coachPrompt1 => 'Hvad fik dig til at smile i dag?';

  @override
  String get coachPrompt2 => 'Hvad er én ting, du har lært i dag?';

  @override
  String get coachPrompt3 => 'Hvem talte du med i dag, og hvordan føltes det?';

  @override
  String get coachPrompt4 => 'Hvad er du taknemmelig for lige nu?';

  @override
  String get coachPrompt5 => 'Hvad tog det meste af din energi i dag?';

  @override
  String get coachPrompt6 => 'Beskriv et lille øjeblik, du gerne vil huske.';

  @override
  String get coachPrompt7 => 'Hvad ville gøre i morgen til en god dag?';

  @override
  String get coachPrompt8 => 'Hvad har du haft på det seneste?';

  @override
  String get coachPrompt9 => 'Hvad lavede du i dag kun for dig selv?';

  @override
  String get coachPrompt10 =>
      'Hvis i dag havde en titel, hvad ville det så være?';

  @override
  String get pageMediaTitle => 'Medier';

  @override
  String get pageAtlasTitle => 'Atlas';

  @override
  String get pageCoachTitle => 'Træner';

  @override
  String get noEntrySelected => 'Ingen post valgt.';

  @override
  String get entryShare => 'Del';

  @override
  String get entryFavorite => 'Stjerne';

  @override
  String get entryEdit => 'Rediger';

  @override
  String get entryPrevious => 'Tidligere indgang';

  @override
  String get entryNext => 'Næste indgang';

  @override
  String get journalStories => 'Historier';

  @override
  String get journalEntries => 'Indgange';

  @override
  String get journalEmptyHint => 'Begynd din dagbog ved at tilføje en ny post.';

  @override
  String get storyToday => 'I dag';

  @override
  String get storyThrowback => 'Tilbageblik';

  @override
  String get storyNoThrowback => 'Ingen tilbagevenden i dag';

  @override
  String get mediaFiles => 'Mediefiler';

  @override
  String get mediaEmpty => 'Ingen billeder endnu.';

  @override
  String get mediaEmptyHint => 'Billeder vedhæftet bidrag vil blive vist her.';

  @override
  String get atlasEmpty => 'Ingen poster med en placering.';

  @override
  String get atlasEmptyHint => 'Indlæg med en placering vil blive vist her.';

  @override
  String get atlasShowAll => 'Vis alle poster';

  @override
  String get atlasMyLocation => 'Min placering';

  @override
  String get coachAll => 'Alle';

  @override
  String get coachPrograms => 'Programmer';

  @override
  String get coachTemplates => 'Skabeloner';

  @override
  String get coachKindProgram => 'Program';

  @override
  String get coachKindTemplate => 'Skabelon';

  @override
  String get coachNoTemplates => 'Ingen programmer eller skabeloner.';

  @override
  String get coachUseTemplate => 'Skriv med denne skabelon';

  @override
  String get coachProgramEverydayTitle => 'Hverdagens øjeblikke';

  @override
  String get coachProgramEverydayDescription =>
      'Fem korte spørgsmål, et om dagen. Hver tager et minut eller to og hjælper dig med at se, hvad der gjorde dagen til din. En blid måde at opbygge en vane med at skrive lidt hver dag.';

  @override
  String get coachProgramReflectTitle => 'Kigger indad';

  @override
  String get coachProgramReflectDescription =>
      'Et dybere spørgsmål om ugen i fem uger. Tag din tid med hver enkelt: hvordan du har haft det, hvad slider dig, hvad du er taknemmelig for.';

  @override
  String get searchFilters => 'Filtre';

  @override
  String get searchFilterTags => 'Tags';

  @override
  String get searchFilterStarred => 'Stjernemarkeret';

  @override
  String get searchHint => 'Skriv for at søge, eller vælg et filter.';

  @override
  String get locationTitle => 'Beliggenhed';

  @override
  String get locationName => 'Stednavn';

  @override
  String get locationRemove => 'Fjern';

  @override
  String get locationServiceDisabled => 'Placeringstjenester er slået fra.';

  @override
  String get locationPermissionDenied => 'Placeringstilladelse blev nægtet.';

  @override
  String get locationUnavailable => 'Kunne ikke hente den aktuelle placering.';

  @override
  String get calendarJumpToToday => 'Hop til i dag';

  @override
  String get editorStartWriting => 'Begynd at skrive eller vælg en ';

  @override
  String get editorTemplateLink => 'Skabelon';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Vælg en skabelon';

  @override
  String get templateFeatured => 'Udvalgte skabeloner';

  @override
  String get templateMine => 'Mine skabeloner';

  @override
  String get templateDailyName => 'Daglig gennemgang';

  @override
  String get templateDailyDescription =>
      'Hvad skete der, hvordan føltes det, og hvad kommer dernæst.';

  @override
  String get templateDailyText =>
      '## Hvad skete der i dag\n\n\n## Hvordan jeg havde det\n\n\n## Tre ting, jeg er taknemmelig for\n1. \n2. \n3. \n\n## I morgen\n';

  @override
  String get templateTravelName => 'Rejsedagbogsoptegnelse';

  @override
  String get templateTravelDescription => 'Steder, øjeblikke og mad fra vejen.';

  @override
  String get templateTravelText =>
      '## Hvor jeg gik\n\n\n## Det øjeblik, jeg husker mest\n\n\n## Hvad jeg spiste\n\n\n## Planer for i morgen\n';

  @override
  String get templateReadingName => 'Læsning af noter';

  @override
  String get templateReadingDescription =>
      'Citater og tanker fra det du læser.';

  @override
  String get templateReadingText =>
      '## Bog\n\n\n## Hvor jeg er\n\n\n## Citater\n> \n\n## Mine tanker\n';

  @override
  String get templateWeeklyName => 'Ugentlig gennemgang';

  @override
  String get templateWeeklyDescription =>
      'Højdepunkter, kampe og næste uges fokus.';

  @override
  String get templateWeeklyText =>
      '## Højdepunkter\n\n\n## Hvad var svært\n\n\n## Hvad jeg lærte\n\n\n## Fokus for næste uge\n';

  @override
  String get entrySaveAsTemplate => 'Gem som skabelon';

  @override
  String get entrySavedAsTemplate => 'Gemt som skabelon';

  @override
  String get storyStatistics => 'Statistik';

  @override
  String get storyMoodChart => 'Stemningsdiagram';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return '$entries poster · $days dage';
  }

  @override
  String get storyThisYear => 'I år';

  @override
  String get storyLastYear => 'Sidste år';

  @override
  String get storyTapToOpen => 'Tryk på en dag for at åbne den';

  @override
  String get settingsGeneralTitle => 'Generelt';

  @override
  String get settingsDataTitle => 'Data & opbevaring';

  @override
  String get settingsStoriesTitle => 'Historier';

  @override
  String get settingsHelpTitle => 'Hjælp & om';

  @override
  String get weatherTitle => 'Vejret';

  @override
  String get weatherClear => 'Ryd';

  @override
  String get weatherPartlyCloudy => 'Delvis skyet';

  @override
  String get weatherCloudy => 'Overskyet';

  @override
  String get weatherFog => 'Tåge';

  @override
  String get weatherDrizzle => 'Støvregn';

  @override
  String get weatherRain => 'Regn';

  @override
  String get weatherSnow => 'Sne';

  @override
  String get weatherStorm => 'Tordenvejr';

  @override
  String get weatherFetch => 'Få vejr til denne post';

  @override
  String get weatherNeedsLocation =>
      'Tilføj først en placering med koordinater.';

  @override
  String get weatherUnavailable =>
      'Vejret er ikke tilgængeligt for dette sted og tidspunkt.';

  @override
  String get weatherRemove => 'Fjern vejret';

  @override
  String get activityTitle => 'Aktivitet';

  @override
  String get activityStill => 'Stadig';

  @override
  String get activityWalking => 'Gåture';

  @override
  String get activityRunning => 'Løb';

  @override
  String get activityCycling => 'Cykling';

  @override
  String get activityVehicle => 'I et køretøj';

  @override
  String get activityFlying => 'Flyvende';

  @override
  String get activityExercise => 'Motion';

  @override
  String get activityDetect => 'Registrer aktuel aktivitet';

  @override
  String get activityDetectFailed => 'Kunne ikke registrere en aktivitet.';

  @override
  String get activityRemove => 'Fjern aktivitet';

  @override
  String get settingsAutoAddTitle => 'Tilføj automatisk';

  @override
  String get settingsAutoAddLocation => 'Beliggenhed';

  @override
  String get settingsAutoAddWeather => 'Vejret';

  @override
  String get settingsAutoAddHint =>
      'Nye poster får disse udfyldt, når de oprettes.';

  @override
  String get settingsTemperatureUnit => 'Temperaturenhed';

  @override
  String get settingsCelsius => 'Celsius (°C)';

  @override
  String get settingsFahrenheit => 'Fahrenheit (°F)';

  @override
  String get moodGreat => 'Fantastisk';

  @override
  String get moodGood => 'Godt';

  @override
  String get moodOkay => 'Okay';

  @override
  String get moodBad => 'Dårligt';

  @override
  String get moodAwful => 'Forfærdeligt';

  @override
  String get locationSearchHint => 'Søg efter et sted';

  @override
  String get locationSearchEmpty => 'Ingen steder fundet';

  @override
  String get settingsWallpaper => 'Tapet';

  @override
  String get wallpaperNone => 'Ingen';

  @override
  String get wallpaperDots => 'Prikker';

  @override
  String get wallpaperGrid => 'Gitter';

  @override
  String get wallpaperLines => 'Linjer';

  @override
  String get wallpaperPhoto => 'Foto...';

  @override
  String get settingsFontFamily => 'Skrifttype';

  @override
  String get fontSystem => 'System';

  @override
  String get fontSerif => 'Serif';

  @override
  String get fontMono => 'Monospace';

  @override
  String get settingsFontSize => 'Skriftstørrelse';

  @override
  String get fontSizeSmall => 'Lille';

  @override
  String get fontSizeMedium => 'Medium';

  @override
  String get fontSizeLarge => 'Stor';

  @override
  String get fontSizeExtraLarge => 'Ekstra stor';

  @override
  String get settingsLineSpacing => 'Linjeafstand';

  @override
  String get lineSpacingCompact => 'Kompakt';

  @override
  String get lineSpacingNormal => 'Normal';

  @override
  String get lineSpacingRelaxed => 'Afslappet';

  @override
  String get moodAssociationsTitle => 'Hvad får mig til at føle...';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching af $total poster';
  }

  @override
  String get videoRecord => 'Optag en video';

  @override
  String get videoChoose => 'Vælg en video';

  @override
  String get audioRecordTitle => 'Optag en stemmebesked';

  @override
  String get audioChoose => 'Vælg en lydfil';

  @override
  String get audioStart => 'Optag';

  @override
  String get audioStop => 'Stop og gem';

  @override
  String get audioPermissionDenied =>
      'Mikrofonadgang er slået fra. Tillad det i systemindstillingerne.';

  @override
  String get mediaTooLarge => 'Denne video er for stor til at vedhæfte.';

  @override
  String get mediaUnavailable =>
      'Denne vedhæftede fil er ikke tilgængelig på denne enhed.';

  @override
  String get widgetDone => 'Dagens indlæg er skrevet';

  @override
  String get widgetPending => 'Hvordan var din dag?';

  @override
  String get widgetWrite => 'Skriv';

  @override
  String get insertChecklist => 'Tjekliste';

  @override
  String get insertNumberedList => 'Nummereret liste';

  @override
  String get insertTable => 'Bord';

  @override
  String get insertDivider => 'Afdeler';

  @override
  String get insertCodeBlock => 'Kodeblok';

  @override
  String get journalSortTitle => 'Sorter poster';

  @override
  String get journalSortUpdated => 'Sidst opdateret';

  @override
  String get settingsTimeFormat => 'Tidsformat';

  @override
  String get settingsDayStart => 'Nye tilmeldinger tæller dagen før til kl';

  @override
  String get settingsDayAskUntil => 'Spørg så hvilken dag indtil';

  @override
  String get settingsDayStartMidnight => 'Fra';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Hvert indlæg beholder den dag, det tilhører, ved siden af det tidspunkt, det blev skrevet, og du kan til enhver tid ændre den dag i editoren. Disse timer vælger kun dagen for nye poster, så hvis du ændrer dem, flyttes ingen eksisterende post.';

  @override
  String get lateNightBadge => 'Skrevet sent om aftenen, regnet for dagen før';

  @override
  String editorDayAsk(String time) {
    return 'Skrevet på $time. Hvilken dag er det til?';
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
  String get timeFormat24 => '24 timer';

  @override
  String get settingsReminderDays => 'Mind mig om';

  @override
  String get locationRecent => 'Seneste steder';

  @override
  String get shareImage => 'Del billede';

  @override
  String get shareSaveImage => 'Gem billede';

  @override
  String get shareSaved => 'Billedet er gemt';

  @override
  String get deletedTitle => 'For nylig slettet';

  @override
  String get deletedNone => 'Intet slettet for nylig';

  @override
  String deletedHint(int days) {
    return 'Slettede poster bliver her i $days dage, og bliver derefter slettet.';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days dage tilbage';
  }

  @override
  String get deletedRestore => 'Gendan';

  @override
  String get deletedDeleteForever => 'Slet for altid';

  @override
  String get deletedDeleteForeverDescription =>
      'Indtastningen og dens vedhæftede filer slettes. Dette kan ikke fortrydes.';

  @override
  String get deletedEmpty => 'Tom';

  @override
  String get deletedEmptyDescription =>
      'Slet hver post i Slettet for nylig? Dette kan ikke fortrydes.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Tilfældig gåtur';

  @override
  String get randomSubtitle => 'Åbn en tidligere post';

  @override
  String get randomNext => 'En anden';

  @override
  String get randomAll => 'Alle';

  @override
  String get randomWithPhotos => 'Med fotos';

  @override
  String get randomGoodDays => 'Gode dage';

  @override
  String get randomEmpty => 'Ingen poster at vælge imellem';

  @override
  String get reviewWeekTitle => 'Denne uge';

  @override
  String get reviewWeekSubtitle => 'Din uge indtil videre';

  @override
  String get reviewYearTitle => 'I år';

  @override
  String get reviewEmpty => 'Intet skrevet endnu';

  @override
  String get reviewEntries => 'Indgange';

  @override
  String get reviewDaysWritten => 'Dage skrevet';

  @override
  String get reviewWords => 'Ord';

  @override
  String get reviewPhotos => 'Fotos';

  @override
  String get reviewLongestRun => 'Længste løb af dage';

  @override
  String get reviewAverageMood => 'Gennemsnitlig humør';

  @override
  String get reviewFavorites => 'Oftest';

  @override
  String get reviewByMonth => 'Efter måned';

  @override
  String get reviewHighlight => 'Fremhæv';

  @override
  String get yearInPixels => 'Årstal i pixels';

  @override
  String get capsuleSeal => 'Forsegl som en tidskapsel';

  @override
  String get capsuleTitle => 'Tidskapsel';

  @override
  String capsuleOpensOn(Object date) {
    return 'Åbner på $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Skrevet på $date';
  }

  @override
  String get capsuleOpenEarly => 'Åben tidligt';

  @override
  String get capsuleOpenEarlyDescription =>
      'Kapslen åbner nu og forbliver åben.';

  @override
  String get capsuleOpened => 'Tidskapsel åbnet';

  @override
  String get templateMorningName => 'Morgen sider';

  @override
  String get templateMorningDescription => 'Indstil dagen på tre minutter';

  @override
  String get templateMorningText =>
      '## Tre ting, jeg vil gøre godt i dag\n1. \n2. \n3. \n\n## Noget jeg ser frem til\n\n## En note til mig selv\n';

  @override
  String get templateEveningName => 'Aften anmeldelse';

  @override
  String get templateEveningDescription =>
      'Luk dagen af med, hvad der gik godt';

  @override
  String get templateEveningText =>
      '## Tre gode ting i dag\n1. \n2. \n3. \n\n## Hvad jeg lærte\n\n## Hvad kunne gå bedre i morgen\n';

  @override
  String get routineMorning => 'Godmorgen';

  @override
  String get routineEvening => 'Aften anmeldelse';

  @override
  String get settingsRoutinePrompts => 'Morgen- og aftenopfordringer';

  @override
  String get settingsRoutinePromptsHint =>
      'Foreslå morgen- eller aftenskabelonen i Stories';

  @override
  String get checkInTitle => 'Hurtig check-in';

  @override
  String get checkInSubtitle => 'Stemning i to tryk';

  @override
  String get checkInMood => 'Hvordan har du det?';

  @override
  String get checkInActivity => 'Hvad laver du?';

  @override
  String get checkInNote => 'En linje om det (valgfrit)';

  @override
  String get checkInSave => 'Gem';

  @override
  String editorWordCount(int words, int characters) {
    return '$words ord · $characters tegn';
  }

  @override
  String get coachProgramEverydayTagline =>
      'Læg mærke til de små ting på en dag.';

  @override
  String get coachProgramReflectTagline =>
      'Sæt farten ned og lyt til dig selv.';

  @override
  String get coachDuration => 'Varighed';

  @override
  String get coachInterval => 'Interval';

  @override
  String get coachDifficulty => 'Sværhedsgrad';

  @override
  String get coachIntervalDaily => 'Dagligt';

  @override
  String get coachIntervalWeekly => 'Ugentligt';

  @override
  String get coachDifficultyBeginner => 'Begynder';

  @override
  String get coachDifficultyIntermediate => 'Mellemliggende';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dage',
      one: '$count dag',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uger',
      one: '$count uge',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'Dag $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Uge $n';
  }

  @override
  String get coachEnroll => 'Tilmeld dig';

  @override
  String get coachEndProgram => 'Afslut program';

  @override
  String get coachAuthor => 'Forfatter';

  @override
  String get coachAuthorBio => 'Spørgsmål skrevet til denne app.';

  @override
  String get coachEnrolledTip => 'Alt klar! Dine spørgsmål vises i Stories.';

  @override
  String get coachGoToStories => 'Gå til Historier';

  @override
  String get coachAnswerHint => 'Skriv dit svar...';

  @override
  String get storyWrapUp => 'Det var alt for i dag.';

  @override
  String get storyTapToClose => 'Tryk for at lukke';

  @override
  String get coachAnswerDone => 'Færdig';

  @override
  String get coachAnswered => 'Besvaret, tryk for at åbne';

  @override
  String get coachAnsweredEarlier => 'Besvarede';

  @override
  String get locationLocating => 'Finder...';

  @override
  String get locationPickPlace => 'Vælg et sted';

  @override
  String get locationPlacesHint => 'Adresse eller navn på stedet';

  @override
  String get locationCustom => 'Brugerdefineret sted';

  @override
  String get locationCurrent => 'Nuværende placering';

  @override
  String get locationSaved => 'Gemte steder';

  @override
  String get locationSearchResults => 'Søgeresultater';

  @override
  String get locationNearby => 'Nærliggende steder';

  @override
  String get locationRename => 'Omdøb';

  @override
  String get locationSavePlace => 'Gem sted';

  @override
  String get locationUnsavePlace => 'Fjern fra gemte steder';

  @override
  String get shareAs => 'Del som...';

  @override
  String get shareAsImage => 'Billede';

  @override
  String get shareAsZip => 'ZIP med det originale medie';

  @override
  String get shareAsPlainText => 'Almindelig tekst';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Velkommen til AID Diary';

  @override
  String get onboardWelcomeText =>
      'Start her, eller tilslut denne enhed til en, du allerede bruger.';

  @override
  String get onboardStart => 'Begynd at skrive';

  @override
  String get helpFaq => 'Ofte stillede spørgsmål';

  @override
  String get helpFaq1Q => 'Hvor er min dagbog gemt?';

  @override
  String get helpFaq1A =>
      'Din dagbog er gemt på denne enhed. Det når kun andre enheder eller lager, når du aktiverer synkronisering, deler eller eksporterer det. Synkronisering er ende-til-ende-krypteret.';

  @override
  String get helpFaq2Q =>
      'Hvordan beholder jeg en kopi eller flytter til en ny enhed?';

  @override
  String get helpFaq2A =>
      'Opret forbindelse til en eksisterende enhed i Indstillinger → Data og lagring → Synkroniser og bekræft godkendelse på den enhed, der har din dagbog. Begge enheder forbliver brugbare. Du kan også oprette en sikkerhedskopi og gendanne den på en anden enhed.';

  @override
  String get helpFaq3Q => 'Kan jeg hente indlæg fra andre dagbogsapps?';

  @override
  String get helpFaq3A =>
      'Ja: i Indstillinger → Data og lagring, importer eksporter fra Daylio, Diarium, Diaro, DayBook, My Brain, OneShot og Pixels eller en JSON-eksport.';

  @override
  String get helpFaq4Q => 'Hvordan fungerer coachprogrammer?';

  @override
  String get helpFaq4A =>
      'Tilmeld dig et program på Coach-siden. Hver dag eller uge venter et nyt spørgsmål i Stories; dit svar gemmes som en post.';

  @override
  String get helpFaq5Q => 'Hvad hvis jeg glemmer min adgangskode?';

  @override
  String get helpFaq5A =>
      'Adgangskoden kan ikke gendannes, så hold en sikkerhedskopi af din dagbog.';

  @override
  String get helpPrivacy => 'Privatliv';

  @override
  String get helpPrivacyText =>
      'Dagbogsindhold og medier forbliver på denne enhed, medmindre du aktiverer krypteret synkronisering eller deler/eksporterer dem. Kort, stedopslag og vejr bruger de konfigurerede tjenester og sender den placering eller søgeforespørgsel, der er nødvendig for den anmodning, ikke dagbogstekst.';

  @override
  String get photoMetaTitle => 'Vil du bruge billedets detaljer?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Tæl denne post for $date og sæt dens plads til $place, som registreret på billedet?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Tælle denne post for $date, hvornår billedet blev taget?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Indstil denne posts plads til $place, hvor billedet blev taget?';
  }

  @override
  String get photoMetaApply => 'Brug dem';

  @override
  String get quickWriteTitle => 'Hurtig skriv';

  @override
  String get quickWriteText => 'Tryk for at starte en ny post.';

  @override
  String get settingsQuickWriteTitle => 'Skriv hurtigt i notifikationer';

  @override
  String get settingsQuickWriteDescription =>
      'Behold en notifikation, der åbner en ny post.';

  @override
  String get settingsNudgesTitle => 'Skub mig efter et stille stræk';

  @override
  String settingsNudgesDescription(int days) {
    return 'En blid påmindelse, når du ikke har skrevet i $days dage.';
  }

  @override
  String get nudgeTitle => 'Det er et stykke tid siden';

  @override
  String get nudgeMonday => 'En ny uge: hvad ser du frem til?';

  @override
  String get nudgeTuesday => 'To linjer er nok. Hvordan har du det i dag?';

  @override
  String get nudgeWednesday =>
      'Halvvejs gennem ugen. Hvad skilte sig ud indtil videre?';

  @override
  String get nudgeThursday => 'Noget småt værd at beholde fra i dag?';

  @override
  String get nudgeFriday => 'Ugen er ved at være slut. Bemærk et godt øjeblik.';

  @override
  String get nudgeSaturday => 'En langsom lørdag er en god dag at skrive.';

  @override
  String get nudgeSunday => 'Se tilbage på ugen før den slutter.';

  @override
  String get photoWidgetEmpty => 'Billeder, du føjer til poster, vises her.';

  @override
  String get channelReminders => 'Påmindelser';

  @override
  String get channelOnThisDay => 'På denne dag';

  @override
  String get channelCoach => 'Coach opfordrer';

  @override
  String get channelNudges => 'Nuds efter stille dage';

  @override
  String get channelQuickWrite => 'Hurtig skriv';

  @override
  String get channelBackup => 'Sikkerhedskopier';

  @override
  String get formatJsonExport => 'JSON (AID Diary eksport)';

  @override
  String get aboutModifiedNotice =>
      'En modificeret version af Daily You af Demizo og bidragydere. Det er ikke den officielle Daily You-app.';

  @override
  String get toolbarPhotos => 'Tilføj billeder';

  @override
  String get toolbarMedia => 'Fotos og videoer';

  @override
  String get mediaFromGallery => 'Vælg fra galleri';

  @override
  String get mediaFromFiles => 'Vælg mellem filer';

  @override
  String get editorLeaveTitle => 'Vil du gemme denne post?';

  @override
  String get editorLeaveDiscard => 'Gem ikke';

  @override
  String get editorTitleHint => 'Titel';

  @override
  String get editorLocating => 'Finder...';

  @override
  String get toolbarVideo => 'Video';

  @override
  String get toolbarAudio => 'Stemmenote';

  @override
  String get toolbarTags => 'Tags';

  @override
  String get toolbarBulletList => 'Punktliste';

  @override
  String get toolbarHeading => 'Overskrift';

  @override
  String get toolbarBold => 'Fed';

  @override
  String get toolbarItalic => 'Kursiv';

  @override
  String get toolbarHighlight => 'Fremhæv';

  @override
  String get toolbarStrikethrough => 'Gennemstregning';

  @override
  String get toolbarQuote => 'Citat';

  @override
  String get toolbarLink => 'Link';

  @override
  String get toolbarInsert => 'Indsæt';

  @override
  String get toolbarUndo => 'Fortryd';

  @override
  String get toolbarRedo => 'Gentag';

  @override
  String get toolbarInsertDate => 'Indsæt datoen';

  @override
  String get toolbarInsertTime => 'Indsæt tiden';

  @override
  String get settingsSyncTitle => 'Synkronisering via skyen';

  @override
  String get syncOffDescription =>
      'Hold denne dagbog den samme på alle dine enheder gennem Google Drive eller en WebDAV-server, såsom Nextcloud, Synology eller Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'Synkroniser med Google Drive';

  @override
  String get syncOrWebDav => 'Eller en WebDAV-server';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn =>
      'Logget ind. Du kan gå tilbage til AID Diary.';

  @override
  String get syncGoogleSignInAgain =>
      'Google har brug for, at du logger ind igen.';

  @override
  String get syncSignInAgain => 'Log ind igen';

  @override
  String get settingsCommandLineTitle => 'Kommandolinje';

  @override
  String get commandLineToggle => 'Kommandolinjegrænseflade';

  @override
  String get commandLineToggleHint =>
      'Lader hjælpekommandoen og andre programmer på denne enhed bruge appens kommandoer.';

  @override
  String get commandLineAlwaysOn => 'Altid på i udviklingsbygninger.';

  @override
  String commandLineListening(int port) {
    return 'Lytter på port $port';
  }

  @override
  String get commandPaletteTitle => 'Alle kommandoer';

  @override
  String get commandPaletteSearch => 'Søg kommandoer';

  @override
  String get commandPaletteRun => 'Løb';

  @override
  String get commandPaletteConfirm =>
      'Dette kan ikke bare fortrydes. Køre det?';

  @override
  String syncReceiving(int done, int total) {
    return 'Modtager $done af $total...';
  }

  @override
  String syncSending(int done, int total) {
    return 'Sender $done af $total...';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'Adgang til Google Drive var ikke tilladt. Tilslut igen og sæt flueben i Google Drive på Googles side.';

  @override
  String get syncEntryUnsynced =>
      'Ikke synkroniseret: den sidste synkronisering gik ikke igennem';

  @override
  String get syncUseOfficial => 'Brug AID-synkroniseringsserveren';

  @override
  String get syncServer => 'Serveradresse';

  @override
  String get syncUsername => 'Brugernavn';

  @override
  String get syncPassword => 'Adgangskode';

  @override
  String get syncConnect => 'Forbind';

  @override
  String get syncConnecting => 'Opretter forbindelse...';

  @override
  String get syncSignInFailed =>
      'Kunne ikke logge ind. Tjek adressen, brugernavnet og adgangskoden.';

  @override
  String syncConnectFailed(String error) {
    return 'Kunne ikke oprette forbindelse: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Begynd at synkronisere';

  @override
  String get syncNewSpaceDescription =>
      'Der er endnu ingen synkroniseret dagbog her. Denne dagbog vil blive uploadet, ende-til-ende krypteret med en nøgle, der forbliver på dine enheder.';

  @override
  String get syncJoinTitle => 'Deltag i den synkroniserede dagbog';

  @override
  String get syncWrongKey =>
      'Denne gendannelseskode åbner ikke den synkroniserede dagbog.';

  @override
  String syncLastSynced(String time) {
    return 'Sidst synkroniseret $time';
  }

  @override
  String get syncNever => 'Ikke synkroniseret endnu';

  @override
  String get syncSyncing => 'Synkroniserer...';

  @override
  String syncFailed(String error) {
    return 'Den sidste synkronisering mislykkedes: $error';
  }

  @override
  String get syncLocked =>
      'Den synkroniserede dagbog tilhører nu andre enheder eller er startet forfra. Par med en af ​​dem, eller brug gendannelseskoden til at fortsætte med at synkronisere.';

  @override
  String get syncNow => 'Synkroniser nu';

  @override
  String get syncUnlock => 'Lås op';

  @override
  String get syncEncrypted => 'End-to-end krypteret';

  @override
  String get syncDisconnect => 'Stop synkronisering';

  @override
  String get syncDisconnectDescription =>
      'Denne enhed stopper med at synkronisere. Dagbogen her og den synkroniserede kopi bliver som de er.';

  @override
  String get syncOwnRecoveryPassword => 'Brug min egen gendannelsesadgangskode';

  @override
  String get syncRecoveryPassword => 'Gendannelsesadgangskode';

  @override
  String get syncRecoveryPasswordRepeat => 'Gentag gendannelsesadgangskoden';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Brug mindst $min tegn';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'Adgangskoderne er forskellige';

  @override
  String get syncRecoveryCode => 'Gendannelseskode';

  @override
  String get syncRecoveryCodeTitle => 'Gem din gendannelseskode';

  @override
  String get syncRecoveryCodeDescription =>
      'Hvis alle dine enheder går tabt, gendanner denne kode din synkroniserede dagbog. Opbevar det i en adgangskodemanager eller på papir. Det vises kun denne ene gang.';

  @override
  String get syncRecoveryCodeCopied => 'Gendannelseskode kopieret';

  @override
  String get syncRecoveryCodeSaved => 'Jeg har gemt den';

  @override
  String get syncJoinNeedsKey =>
      'Denne synkroniserede dagbog tilhører dine andre enheder. Par med en af ​​dem, eller brug gendannelseskoden. Indtastningerne på denne enhed føjes til den.';

  @override
  String get syncPairDevice => 'Par med en enhed';

  @override
  String get syncUseRecoveryCode => 'Brug gendannelseskoden';

  @override
  String get syncAddDevice => 'Tilføj en enhed';

  @override
  String get syncChangeRecoveryCode => 'Skift gendannelseskoden';

  @override
  String get syncChangeRecoveryDescription =>
      'En ny kode erstatter den nuværende, som holder op med at virke. Dine data og andre enheder forbliver, som de er.';

  @override
  String get syncNewRandomCode => 'Ny tilfældig kode';

  @override
  String get syncRecoveryCodeChanged => 'Gendannelseskode ændret';

  @override
  String get syncResetSpace => 'Start den synkroniserede dagbog forfra';

  @override
  String get syncResetSpaceDescription =>
      'Kun når ingen enhed og ingen gendannelseskode åbner den længere: Den synkroniserede kopi erstattes af dagbogen på denne enhed under denne enheds nøgler. Dine andre enheder parrer derefter igen.';

  @override
  String get syncPairTitle => 'Par enheder';

  @override
  String get syncPairShow => 'Vis en kode';

  @override
  String get syncPairEnter => 'Indtast en kode';

  @override
  String get syncPairShowHint =>
      'Åbn Par enheder på din anden enhed, vælg Indtast en kode, og skriv eller scan denne.';

  @override
  String get syncPairEnterHint =>
      'Indtast koden, som din anden enhed viser, eller scan den.';

  @override
  String get syncPairCode => 'Parringskode';

  @override
  String get syncPairScan => 'Scan';

  @override
  String get syncPairStart => 'Par';

  @override
  String get syncPairWaiting => 'Venter på den anden enhed...';

  @override
  String syncPairDone(String device) {
    return 'Parret med $device';
  }

  @override
  String get syncPairWrongCode =>
      'Koden stemte ikke. Vis en ny kode, og prøv igen.';

  @override
  String get syncPairNoOffer =>
      'Ingen enhed viser denne kode. Det kan være udløbet.';

  @override
  String get syncPairTimedOut => 'Den anden enhed svarede ikke i tide.';

  @override
  String get syncPairNeither =>
      'Ingen af enhederne er konfigureret med denne synkroniserede dagbog endnu.';

  @override
  String get syncPairBoth =>
      'Begge enheder åbner allerede denne synkroniserede dagbog.';

  @override
  String syncPairFailed(String error) {
    return 'Parring mislykkedes: $error';
  }

  @override
  String get syncMediaPending =>
      'Dagbog synkroniseret · nogle medier overføres stadig';

  @override
  String get syncWaitingForDevices =>
      'Dagbog synkroniseret · venter på, at en anden enhed overfører medier';

  @override
  String get syncCacheNotice =>
      'Cloud-medier er midlertidige. Opbevar originalerne på dine enheder; synkronisering er ikke en sikkerhedskopi.';

  @override
  String get paperTitle => 'Brevpapir';

  @override
  String get paperPlain => 'Almindelig';

  @override
  String get paperLined => 'Foret';

  @override
  String get paperGrid => 'Gitter';

  @override
  String get paperTinted => 'Tonet';

  @override
  String get paperDecorationTitle => 'Dekorationer';

  @override
  String get paperDecorationNone => 'Ingen';

  @override
  String get paperDecorationBotanical => 'Blade';

  @override
  String get paperDecorationStars => 'Stjerner';

  @override
  String get paperDecorationWashi => 'Washi tape';

  @override
  String get themeDarkChoice => 'Mørkt udseende';

  @override
  String get themeDarkSame => 'Følg lyspaletten';

  @override
  String get themeDarkCustom => 'Separat palette';

  @override
  String get themeDarkAccent => 'Mørk accent farve';

  @override
  String get themeColorTeal => 'Blågrøn';

  @override
  String get themeColorCyan => 'Cyan';

  @override
  String get themeColorIndigo => 'Indigo';

  @override
  String get themeColorCoral => 'Koral';

  @override
  String get themeColorOlive => 'Oliven';

  @override
  String get themeColorSlate => 'Skifer';

  @override
  String get drawingTitle => 'Tegning';

  @override
  String get drawingPen => 'Pen';

  @override
  String get drawingEraser => 'Viskelæder';

  @override
  String get drawingUndo => 'Fortryd';

  @override
  String get drawingClear => 'Ryd';

  @override
  String get drawingWidth => 'Pennebredde';

  @override
  String get drawingStylusOnly => 'Kun stylus';

  @override
  String get drawingDiscardTitle => 'Kasser tegningen?';

  @override
  String get drawingDiscardBody => 'Denne tegning er ikke blevet gemt.';

  @override
  String get drawingSaveError => 'Kunne ikke gemme tegningen.';

  @override
  String get syncNetworkTitle => 'Netværksdiagnostik';

  @override
  String get syncNetworkRefresh => 'Opdater';

  @override
  String get syncNetworkSelectedRoute => 'Nuværende vej';

  @override
  String get syncNetworkAvailableRoutes => 'Tilgængelige stier';

  @override
  String get syncNetworkSignaling => 'Enhedens biblioteksforbindelse';

  @override
  String get syncNetworkRelayRemaining => 'Resterende relætillæg';

  @override
  String get syncNetworkIcePair => 'Direkte tilslutningskandidater';

  @override
  String get syncNetworkPeerTrusted => 'Autentificeret enhed';

  @override
  String get syncNetworkNoRoute => 'Venter på en forbindelse';

  @override
  String get syncNetworkUnavailable => 'Diagnostik er ikke tilgængelig';

  @override
  String get syncMediaCopiesTitle => 'Medielevering og kopier';

  @override
  String get syncMediaPendingCount => 'Venter på overførsel';

  @override
  String get syncMediaDurableCount => 'Leveres til personlig opbevaring';

  @override
  String get syncMediaTemporaryCount => 'Midlertidige eller ubekræftede kopier';

  @override
  String get syncMediaReceiptExplanation =>
      'Disse tællinger beskriver gennemførte leverancer, ikke en ny revision af overlevende backups.';

  @override
  String get syncMediaCacheExplanation =>
      'Midlertidige cloudmedier kan udløbe. Gem dine originaler eller en separat sikkerhedskopi.';

  @override
  String get momentsTitle => 'Fotoøjeblikke';

  @override
  String get momentsHint =>
      'Find grupper ved hjælp af lokale fototider og valgfri koordinater. Billeder vedhæftes kun, når du vælger et kort.';

  @override
  String get momentsScan => 'Find øjeblikke';

  @override
  String get momentsChooseFolder => 'Vælg billedmappe';

  @override
  String get momentsLocation => 'Inkluder fotoplaceringer';

  @override
  String get momentsEmpty => 'Ingen nylige fotogrupper.';

  @override
  String get momentsCreate => 'Skriv om disse billeder';

  @override
  String get momentsDismiss => 'Afvis';

  @override
  String get momentsError => 'Kunne ikke læse lokale billeder.';

  @override
  String get momentsCreated => 'Fotoindlæg oprettet.';

  @override
  String get momentsPermission =>
      'Tillad adgang til billeder for at finde lokale forslag.';

  @override
  String get momentsScope =>
      'Kun seneste fotos; højst 500 billeder og 20 billeder pr. kort.';

  @override
  String momentsPhotoCount(int count) {
    return '$count billeder';
  }

  @override
  String get nearbyTitle => 'Tilslut enheder';

  @override
  String get nearbySend => 'Godkend en anden enhed';

  @override
  String get nearbyReceive => 'Opret forbindelse til en eksisterende enhed';

  @override
  String get nearbyInstructions =>
      'Tilslut begge enheder til den samme Wi-Fi eller til hinandens hotspot. Bekræft autorisation på den eksisterende enhed; begge enheder forbliver brugbare. Intet internet er påkrævet.';

  @override
  String get nearbyCompare =>
      'Sammenlign denne kode på begge enheder, før du godkender.';

  @override
  String get nearbyConfirm => 'Koderne stemmer overens';

  @override
  String get nearbyScan => 'Scan den anden enheds kode';

  @override
  String get nearbyPaste => 'Indsæt invitation';

  @override
  String get nearbyWaiting => 'Venter på godkendelse på den anden enhed';

  @override
  String get nearbyWorking =>
      'Godkender og synkroniserer din dagbog og vedhæftede filer...';

  @override
  String get nearbyPending =>
      'Nogle vedhæftede filer skal stadig synkroniseres. Hold den anden enhed online, og prøv igen.';

  @override
  String get nearbyComplete =>
      'Enhed tilsluttet; dagbog og vedhæftede filer synkroniseret';

  @override
  String get nearbyFailed =>
      'Forbindelsen blev ikke afsluttet. Tjek den lokale forbindelse, og prøv igen.';

  @override
  String get nearbyEmptyRequired =>
      'Brug en enhed med en tom dagbog, der ikke er tilsluttet til synkronisering endnu.';

  @override
  String get nearbyRetry => 'Fortsæt med at synkronisere';

  @override
  String get nearbyWifi => 'Wi-Fi indstillinger';

  @override
  String get nearbyHotspot => 'Hotspot-indstillinger';

  @override
  String get nearbyKeepOpen =>
      'Hold denne side åben, indtil den nye enhed er færdig. Invitationen udløber efter to minutter.';

  @override
  String get syncDevicesTitle => 'Autoriserede enheder';

  @override
  String get syncDevicesDescription =>
      'Kun godkendte enheder kan få adgang til denne AID-konto. Tilbagekaldelse af en enhed blokerer serveren, men kan ikke slette en hovednøgle eller dagbog, der allerede er kopieret til den.';

  @override
  String get syncDeviceRequest =>
      'Vis denne autorisations-QR til en godkendt enhed';

  @override
  String get syncDeviceAuthorize => 'Godkend en enhed';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Scan eller indsæt den nye enheds godkendelsesanmodning.';

  @override
  String get syncDeviceRevoke => 'Tilbagekald';

  @override
  String get syncDeviceRotate => 'Drej denne enheds signeringsnøgle';

  @override
  String get syncDeviceCheck => 'Tjek autorisation';

  @override
  String get syncDeviceHardware => 'Hardware-understøttet signeringsnøgle';

  @override
  String get syncDeviceSoftware => 'Ikke-eksportabel softwaresigneringsnøgle';

  @override
  String get syncDeviceUnavailable =>
      'Enhedsgodkendelse er ikke tilgængelig. Godkend denne enhed fra en anden autoriseret enhed, og prøv igen.';

  @override
  String get syncDeviceRevoked => 'Tilbagekaldt';

  @override
  String get syncDeviceLocal => 'Denne enhed';

  @override
  String get cloudTrafficTitle =>
      'Månedlig skydataoverførselskvote for mediefiler';

  @override
  String get cloudTrafficLimit => 'Månedlig dataoverførselskvote';

  @override
  String get cloudTrafficUsed => 'Dataoverførsel brugt';

  @override
  String get cloudTrafficRemaining => 'Dataoverførsel tilbage';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'Dataoverførselskvoten nulstiller $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'Cloud dataoverførselskvoten for mediefiler er brugt op. Manglende mediefiler synkroniseres automatisk, når en direkte forbindelse er tilgængelig, eller kvoten nulstilles.';

  @override
  String get cloudTrafficExplanation =>
      'Mediefilcaching og live-relæ deler denne dataoverførselskvote. Direkte forbindelser bruger det ikke. Dagbogstekst og forbindelseskontrolmeddelelser har separate små daglige grænser.';

  @override
  String get appearanceThemeSection => 'App tema';

  @override
  String get appearancePaperSection => 'Dagbog papir';

  @override
  String get appearanceTypographySection => 'Dagbogstekst';

  @override
  String get appearancePreferencesSection => 'Generelle præferencer';

  @override
  String get themeSystemAccentHint =>
      'Bruger systempaletten i stedet for brugerdefinerede farver. Sluk den for at vælge din egen.';

  @override
  String get syncDeviceNameSaveFailed =>
      'Enhedens navn kunne ikke gemmes. Prøv venligst igen.';

  @override
  String get nearbyConnectionHelp => 'Hjælp til forbindelse';

  @override
  String get syncAllSynced => 'Alt synkroniseret';

  @override
  String get syncDetailsTitle => 'Synkroniser detaljer';

  @override
  String get syncMore => 'Flere muligheder';

  @override
  String get syncDeviceName => 'Enhedens navn';

  @override
  String get syncDeviceNameHint => 'For eksempel: Min tablet';

  @override
  String get syncDeviceNameInvalid => 'Brug 1 til 32 tegn';

  @override
  String get syncDeviceKeyDetails => 'Sikkerhedsdetaljer';

  @override
  String get syncConnectionProblem =>
      'Kan ikke synkronisere i øjeblikket. Forsøger automatisk igen.';

  @override
  String get syncCopyComplete => 'Komplet kopi af din dagbog og mediefiler';

  @override
  String get syncCopyPartial => 'Nogle medier mangler stadig';

  @override
  String get syncCopyOlder => 'Nye ændringer venter på at blive synkroniseret';

  @override
  String get syncCopyUnavailable =>
      'Kopioplysninger er ikke tilgængelige. Prøv igen senere.';

  @override
  String get syncCopyLastKnown =>
      'Andre enheder viser deres sidste bekræftede kopi. Offline-enheder kan ikke kontrolleres nu.';

  @override
  String get syncCopyTemporary =>
      'Midlertidig cache. Gem originalerne på dine enheder.';

  @override
  String get syncCopyStorage =>
      'Din synkroniseringslagring. Fuldførte medieuploads er angivet i diagnostik.';

  @override
  String syncCopyChecked(String time) {
    return 'Sidst bekræftet $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Dataoverførsel tilbage denne måned: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Start her';

  @override
  String get onboardConnect => 'Opret forbindelse til en eksisterende enhed';

  @override
  String get onboardFailed =>
      'Opsætningen kunne ikke fuldføres. Din dagbog er sikker; prøv venligst igen.';

  @override
  String get tutorialTitle => 'Sådan bruger du dagbogen';

  @override
  String get tutorialWriteTitle => 'Skriv dit første dagbogsindlæg';

  @override
  String get tutorialWriteText =>
      'Tryk på + for at skrive en dagbogspost. Tilføj en valgfri titel, vælg dagbogsdatoen, og tryk på fluebenet for at gemme. Du kan til enhver tid redigere din dagbogspost igen.';

  @override
  String get tutorialMediaTitle => 'Tilføj billeder, lyd eller håndskrift';

  @override
  String get tutorialMediaText =>
      'Brug + i dagbogseditoren til at vedhæfte billeder, videoer eller en stemmeoptagelse eller til at åbne håndskriftslærredet. Disse vedhæftede filer gemmes med dagbogsposten.';

  @override
  String get tutorialReviewTitle => 'Find en dag igen';

  @override
  String get tutorialReviewText =>
      'Gennemse din dagbog eller kalender, søg i dine tekster, og organiser poster med tags. Medie- og Atlas-siderne giver dig mulighed for at finde tidligere indlæg efter foto eller sted.';

  @override
  String get tutorialSyncTitle => 'Brug mere end én enhed';

  @override
  String get tutorialSyncText =>
      'I Indstillinger → Data og lagring → Synkroniser skal du oprette forbindelse til en eksisterende enhed og bekræfte godkendelsen på den enhed. Begge enheder kan blive ved med at bruge dagbogen. Dagbogstekst synkroniseres først. Mediefiler synkroniseres derefter, når netværksforbindelsen og den resterende dataoverførselskvote tillader det.';

  @override
  String get tutorialPrivacyTitle => 'Hold din dagbog sikker';

  @override
  String get tutorialPrivacyText =>
      'Dagbogsoptegnelser forbliver på denne enhed, medmindre du aktiverer synkronisering eller deler eller eksporterer dem. Synkronisering er ende-til-ende-krypteret. I Indstillinger kan du også indstille en app-adgangskode, oprette sikkerhedskopier og genåbne denne vejledning.';

  @override
  String get editorDiaryDay => 'Dagbogsdato';

  @override
  String get editorDiaryDayPicker =>
      'Dagbogsdato · Hvilken dag handler indlægget om?';

  @override
  String editorCreatedAt(String time) {
    return 'Oprettet $time';
  }

  @override
  String get editorDiaryDayHint =>
      'Den dag, dette indlæg hører til. En ændring ændrer ikke tidspunktet, hvor indlægget blev oprettet.';

  @override
  String get hiddenDiaryTitle => 'Skjulte indlæg';

  @override
  String get hiddenDiaryHide => 'Skjul indlæg';

  @override
  String get hiddenDiaryShow => 'Vis indlæg';

  @override
  String get hiddenDiaryEmpty => 'Ingen skjulte indlæg';

  @override
  String get hiddenDiaryUnlock => 'Lås skjulte indlæg op';

  @override
  String get hiddenDiaryAuthHint => 'Brug appens lås eller enhedens skærmlås.';

  @override
  String get moodClear => 'Ryd humør';

  @override
  String get scrollToTop => 'Til toppen';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackHint => 'Beskriv et problem eller forslag';

  @override
  String get feedbackGithub => 'GitHub-issue';

  @override
  String get feedbackEmail => 'Send e-mail';

  @override
  String get feedbackCopy => 'Kopiér tekst';

  @override
  String get feedbackLaunchFailed =>
      'Appen kunne ikke åbnes. Kopiér teksten og brug e-mailadressen nedenfor.';

  @override
  String get feedbackCopied => 'Feedback kopieret';
}
