// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => 'Thema kleur';

  @override
  String get themeColorHint => 'Kies een kleur voor dit palet.';

  @override
  String get themeColorBlue => 'Hemelsblauw';

  @override
  String get themeColorGreen => 'Bosgroen';

  @override
  String get themeColorBrown => 'Warme koffie';

  @override
  String get themeColorPurple => 'Lavendel';

  @override
  String get themeColorRose => 'Stoffige roos';

  @override
  String get themeColorAmber => 'Amber';

  @override
  String get themeColorPreview => 'Elke dag een beetje';

  @override
  String get themeTintBackgroundTitle => 'Tint achtergronden met themakleur';

  @override
  String get themeTintBackgroundHint =>
      'Schakel uit voor neutrale grijze achtergronden; knoppen behouden de door u gekozen kleur.';

  @override
  String get dailyReminderTitle => 'Log vandaag!';

  @override
  String get dailyReminderDescription => 'Schrijf je dagelijkse log…';

  @override
  String get actionTakePhoto => 'Trek foto';

  @override
  String get flashbacksTitle => 'Terugblikken';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Sluit slechte dagen uit';

  @override
  String get flashbackGoodDay => 'Een goede dag';

  @override
  String get flashbackRandomDay => 'Een willekeurige dag';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weken geleden',
      one: '$count week geleden',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count maanden geleden',
      one: '$count maand geleden',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jaren geleden',
      one: '$count jaar geleden',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'Op deze dag';

  @override
  String get searchLogsHint => 'Doorzoek logboeken…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagboeknotities',
      one: '$count dagboeknotitie',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagen',
      one: '$count dag',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count woorden',
      one: '$count woord',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Geen logs te tonen…';

  @override
  String get noResults => 'Geen resultaten…';

  @override
  String get sortOrderAscendingTitle => 'Oplopend';

  @override
  String get sortOrderDescendingTitle => 'Aflopend';

  @override
  String get pageStatisticsTitle => 'Statistieken';

  @override
  String get statisticsNotEnoughData => 'Niet genoeg data…';

  @override
  String get statisticsRangeOneMonth => '1 maand';

  @override
  String get statisticsRangeSixMonths => '6 maanden';

  @override
  String get statisticsRangeOneYear => '1 jaar';

  @override
  String get statisticsRangeAllTime => 'Alles';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag Samenvatting';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag per dag';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag in de loop van de tijd';
  }

  @override
  String get chartGroupingLabel => 'Groepeer op';

  @override
  String get chartGroupingDay => 'Dag';

  @override
  String get chartGroupingWeek => 'Week';

  @override
  String get chartGroupingMonth => 'Maand';

  @override
  String get chartGroupingYear => 'Jaar';

  @override
  String get chartSmoothingLabel => 'Gladmaken';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Huidige reeks $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Langste reeks $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Geweldige dagen $count',
      one: 'Geweldige dagen $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dagen sinds een slechte dag $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Geen toegang tot externe opslag';

  @override
  String get errorExternalStorageAccessDescription =>
      'Als je netwerkopslag gebruikt, zorg ervoor dat de service online is en dat je netwerktoegang hebt.\n\nHet kan ook zijn dat de app privileges voor de externe map is verloren. Ga naar instellingen en selecteer de externe map om toegang te geven.\n\nWaarschuwing, veranderingen worden niet gesynchroniseerd totdat je toegang tot de externe opslag hersteld!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Ga door met lokale database';

  @override
  String get lastModified => 'Gewijzigd';

  @override
  String get writeSomethingHint => 'Schrijf iets op…';

  @override
  String get titleHint => 'Titel…';

  @override
  String get deleteLogTitle => 'Verwijder log';

  @override
  String get deleteLogDescription =>
      'Weet je zeker dat je deze log wil verwijderen?';

  @override
  String get deletePhotoTitle => 'Verwijder foto';

  @override
  String get deletePhotoDescription =>
      'Weet je zeker dat je deze foto wil verwijderen?';

  @override
  String get pageSettingsTitle => 'Instellingen';

  @override
  String get settingsTheme => 'Thema';

  @override
  String get themeSystem => 'Systeem';

  @override
  String get themeLight => 'Licht';

  @override
  String get themeDark => 'Donker';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Eerste dag van de week';

  @override
  String get settingsCalendarSystem => 'Kalendersysteem';

  @override
  String get calendarSystemGregorian => 'Gregoriaans';

  @override
  String get calendarSystemJalali => 'Jalali';

  @override
  String get settingsUseSystemAccentColor =>
      'Gebruik accentkleur van het systeem';

  @override
  String get settingsCustomAccentColor => 'Eigen accentkleur';

  @override
  String get settingsShowFlashbacks => 'Toon terugblikken';

  @override
  String get settingsChangeMoodIcons => 'Wijzig humeuriconen';

  @override
  String get moodIconPrompt => 'Voer een icoon in';

  @override
  String get settingsHideImages => 'Afbeeldingen verbergen';

  @override
  String get pageCalendarTitle => 'Kalender';

  @override
  String get settingsNotificationsTitle => 'Meldingen';

  @override
  String get settingsDailyReminderTitle => 'Dagelijkse herinnering';

  @override
  String get settingsOnThisDayDescription =>
      'Haal herinneringen uit het verleden opnieuw op';

  @override
  String get settingsDailyReminderDescription =>
      'Iedere dag een kleine herinnering';

  @override
  String get settingsReminderTime => 'Herinneringstijd';

  @override
  String get settingsFixedReminderTimeTitle => 'Vaste herinneringstijd';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Kies een vaste tijd voor de herinnering';

  @override
  String get settingsAlwaysSendReminderTitle => 'Stuur altijd een herinnering';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Stuur ook een herinnering als er al gelogd is';

  @override
  String get settingsCustomizeNotificationTitle => 'Meldingen aanpassen';

  @override
  String get settingsTemplatesTitle => 'Sjablonen';

  @override
  String get manageTemplates => 'Sjablonen beheren';

  @override
  String get noTemplateTitle => 'Geen';

  @override
  String get noTemplatesDescription => 'Nog geen sjablonen aangemaakt…';

  @override
  String get templateDefaultTimestampTitle => 'Tijdstempel';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Dagoverzicht';

  @override
  String get templateDefaultSummaryBody =>
      '### Samenvatting\n- \n\n### Citaat\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Reflectie';

  @override
  String get templateDefaultReflectionBody =>
      '### Wat vond je leuk aan vandaag?\n- \n\n### Waar ben jij dankbaar voor?\n- \n\n### Waar kijk je naar uit?\n- ';

  @override
  String get settingsTagsTitle => 'Labels';

  @override
  String get manageTags => 'Beheer tags';

  @override
  String get tagTypeLabelTitle => 'Etiket';

  @override
  String get tagTypeTrackerTitle => 'Volger';

  @override
  String get nameHint => 'Naam';

  @override
  String get tagColorLabel => 'Kleur';

  @override
  String get iconPickerTitle => 'Kies Pictogram';

  @override
  String get iconPickerIconsTab => 'Pictogrammen';

  @override
  String get iconPickerCustomTab => 'Aangepast';

  @override
  String get iconPickerSearchHint => 'Zoekpictogrammen…';

  @override
  String get colorPickerTitle => 'Kies Kleur';

  @override
  String get colorPickerPaletteTab => 'Kleuren';

  @override
  String get iconGroupMoodPeople => 'Stemming en mensen';

  @override
  String get iconGroupHealth => 'Gezondheid';

  @override
  String get iconGroupWorkFinance => 'Werk & Financiën';

  @override
  String get iconGroupHabitsGoals => 'Gewoonten en doelen';

  @override
  String get iconGroupNature => 'Natuur';

  @override
  String get iconGroupFoodDrink => 'Eten en drinken';

  @override
  String get iconGroupHome => 'Thuis';

  @override
  String get iconGroupTravel => 'Reizen';

  @override
  String get iconGroupSymbols => 'Symbolen';

  @override
  String get tagCategoryLabel => 'Categorie';

  @override
  String get tagLabel => 'Label';

  @override
  String get tagCategoryUncategorized => 'Niet gecategoriseerd';

  @override
  String get newCategoryTitle => 'Nieuwe categorie';

  @override
  String get shareButtonLabel => 'Deel';

  @override
  String get importErrorDescription => 'Kan bestand niet importeren!';

  @override
  String get exportErrorDescription => 'Kan bestand niet exporteren!';

  @override
  String get deleteTitle => 'Verwijderen';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Het wordt gebruikt in $count dagboekaantekeningen.',
      one: ' Het wordt gebruikt in $count dagboekaantekening.',
      zero: '',
    );
    return '\"$name\" verwijderen?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' De $count-tags worden ook verwijderd.',
      one: ' De $count-tag wordt ook verwijderd.',
      zero: '',
    );
    return '\"$name\" verwijderen?$_temp0';
  }

  @override
  String get tagNameExists => 'Er bestaat al een tag met deze naam';

  @override
  String get categoryNameExists => 'Er bestaat al een categorie met deze naam';

  @override
  String deleteTemplateMessage(Object name) {
    return '\"$name\" verwijderen?';
  }

  @override
  String get addTagsTitle => 'Tags toevoegen';

  @override
  String get addTagsSearchHint => 'Tags zoeken…';

  @override
  String get tagPickerSortManualLabel => 'Handmatige bestelling';

  @override
  String get tagPickerSortUsageLabel => 'Sorteer op gebruik';

  @override
  String get tagFavoriteName => 'Favoriet';

  @override
  String get tagEnergyName => 'Energie';

  @override
  String get tagCategoryActivitiesName => 'Activiteiten';

  @override
  String get tagExerciseName => 'Oefening';

  @override
  String get tagSocializingName => 'Socialiseren';

  @override
  String get tagHobbyName => 'Hobby';

  @override
  String get tagEntertainmentName => 'Amusement';

  @override
  String get tagDiningName => 'Dineren';

  @override
  String get tagChoresName => 'Klusjes';

  @override
  String get tagCategoryEmotionsName => 'Emoties';

  @override
  String get tagExcitedName => 'Opgewonden';

  @override
  String get tagGratefulName => 'Dankbaar';

  @override
  String get tagCalmName => 'Kalm';

  @override
  String get tagTiredName => 'Moe';

  @override
  String get tagAnxiousName => 'Angstig';

  @override
  String get tagAnnoyedName => 'Geërgerd';

  @override
  String get settingsStorageTitle => 'Opslag';

  @override
  String get settingsImageQuality => 'Afbeeldingskwaliteit';

  @override
  String get imageQualityHigh => 'Hoog';

  @override
  String get imageQualityMedium => 'Middel';

  @override
  String get imageQualityLow => 'Laag';

  @override
  String get imageQualityNoCompression => 'Geen compressie';

  @override
  String get settingsLogFolder => 'Logmap';

  @override
  String get settingsImageFolder => 'Afbeeldingsmap';

  @override
  String get warningTitle => 'Waarschuwing';

  @override
  String get logFolderWarningDescription =>
      'Als de geselecteerde map al een \'aid_diary.db\' bestand bevat, zal het gebruikt worden om je bestaande logs te overschrijven!';

  @override
  String get errorTitle => 'Fout';

  @override
  String get logFolderErrorDescription => 'Kan de logmap niet wijzigen!';

  @override
  String get imageFolderErrorDescription =>
      'Kan de afbeeldingsmap niet wijzigen!';

  @override
  String get backupErrorDescription => 'Kan geen back-up maken!';

  @override
  String get restoreErrorDescription => 'Kan back-up niet herstellen!';

  @override
  String get settingsBackupRestoreTitle => 'Back-up & Herstellen';

  @override
  String get settingsBackup => 'Back-up';

  @override
  String get settingsRestore => 'Herstellen';

  @override
  String get settingsRestorePromptDescription =>
      'Het herstellen van een back-up zal je huidige data overschrijven!';

  @override
  String get settingsBackupPasswordProtect =>
      'Back-ups met wachtwoord beveiligen';

  @override
  String get backupEncryptedTitle => 'Gecodeerde back-up';

  @override
  String get backupEncryptedContent =>
      'Deze back-up is beveiligd met een wachtwoord.';

  @override
  String get settingsAutoBackup => 'Automatische back-ups';

  @override
  String get settingsAutoBackupLocation => 'Back-uplocatie';

  @override
  String get settingsAutoBackupInterval => 'Back-upinterval';

  @override
  String get settingsAutoBackupIntervalDaily => 'Dagelijks';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Wekelijks';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Maandelijks';

  @override
  String get settingsAutoBackupMaxCount => 'Back-ups om te bewaren';

  @override
  String get settingsAutoBackupRequireCharging => 'Alleen tijdens het opladen';

  @override
  String settingsBackupLast(Object time) {
    return 'Laatste back-up $time';
  }

  @override
  String get settingsBackupNever => 'Nooit een back-up gemaakt';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Volgende back-up $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'Allemaal';

  @override
  String get autoBackupFailedTitle => 'Back-up mislukt';

  @override
  String tranferStatus(Object percent) {
    return 'Overzetten... $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Back-up maken... $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Back-up herstellen... $percent%';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return 'Back-up coderen… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Back-up decoderen... $percent%';
  }

  @override
  String get cleanUpStatus => 'Schoonmaken…';

  @override
  String get settingsExportToAnotherFormat =>
      'Exporteren naar een ander formaat';

  @override
  String get settingsExportFormatDescription =>
      'Dit zou niet als een back-up gebruikt moeten worden!';

  @override
  String get settingsImportFromAnotherApp => 'Importeer vanuit een andere app';

  @override
  String get logFormatTitle => 'Kies formaat';

  @override
  String get logFormatDescription =>
      'Het formaat van een andere app ondersteunt mogelijk niet alle functies. Meld eventuele problemen, aangezien formaten van derden op ieder moment kunnen veranderen. Dit heeft geen invloed op bestaande logs!';

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
  String get formatOneShot => 'EénShot';

  @override
  String get formatPixels => 'Pixels';

  @override
  String get formatMarkdown => 'Markdown';

  @override
  String get settingsDeleteAllLogsTitle => 'Verwijder alle logs';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Weet je zeker dat je alle logs wilt verwijderen?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Voer \'$prompt\' in om te bevestigen. Dit kan niet ongedaan worden gemaakt!';
  }

  @override
  String get settingsAppLanguageTitle => 'Taal van de app';

  @override
  String get settingsSecurityTitle => 'Beveiliging';

  @override
  String get settingsSecurityRequirePassword => 'Vereis wachtwoord';

  @override
  String get settingsSecurityEnterPassword => 'Voer wachtwoord in';

  @override
  String get settingsSecuritySetPassword => 'Stel wachtwoord in';

  @override
  String get settingsSecurityChangePassword => 'Verander wachtwoord';

  @override
  String get settingsSecurityPassword => 'Wachtwoord';

  @override
  String get settingsSecurityConfirmPassword => 'Bevestig wachtwoord';

  @override
  String get settingsSecurityOldPassword => 'Oud wachtwoord';

  @override
  String get settingsSecurityIncorrectPassword => 'Onjuist wachtwoord';

  @override
  String get settingsSecurityPasswordsDoNotMatch =>
      'Wachtwoorden komen niet overeen';

  @override
  String get requiredPrompt => 'Vereist';

  @override
  String get settingsSecurityBiometricUnlock => 'Biometrische ontgrendeling';

  @override
  String get unlockAppPrompt => 'Ontgrendel de app';

  @override
  String get settingsAboutTitle => 'Over';

  @override
  String get settingsVersion => 'Versie';

  @override
  String get settingsLicense => 'Licentie';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsOpenSourceLicenses => 'Open Source-licenties';

  @override
  String get tagMoodTitle => 'Humeur';

  @override
  String get selectTagTitle => 'Selecteer Label';

  @override
  String get labelPresentLabel => 'Aanwezig';

  @override
  String get labelAbsentLabel => 'Afwezig';

  @override
  String get labelCoverageLabel => 'Dekking';

  @override
  String chartDistributionTitle(Object tag) {
    return '$tag-distributie';
  }

  @override
  String get shareAddToLogPickerTitle => 'Kies een dagboekaantekening';

  @override
  String get adaptiveEmptyDay => 'Er zijn nog geen aanmeldingen voor deze dag';

  @override
  String get adaptiveNewEntry => 'Schrijf een vermelding';

  @override
  String get pageJournalTitle => 'Journaal';

  @override
  String get coachPrompt1 => 'Wat deed je glimlachen vandaag?';

  @override
  String get coachPrompt2 => 'Wat is één ding dat je vandaag hebt geleerd?';

  @override
  String get coachPrompt3 =>
      'Met wie heb je vandaag gesproken en hoe voelde dat?';

  @override
  String get coachPrompt4 => 'Waar ben jij op dit moment dankbaar voor?';

  @override
  String get coachPrompt5 => 'Wat kostte vandaag de meeste energie?';

  @override
  String get coachPrompt6 =>
      'Beschrijf een klein moment dat je wilt onthouden.';

  @override
  String get coachPrompt7 => 'Wat zou van morgen een goede dag maken?';

  @override
  String get coachPrompt8 => 'Waar heb je de laatste tijd aan gedacht?';

  @override
  String get coachPrompt9 => 'Wat heb jij vandaag alleen voor jezelf gedaan?';

  @override
  String get coachPrompt10 =>
      'Als vandaag een titel zou hebben, welke zou dat dan zijn?';

  @override
  String get pageMediaTitle => 'Media';

  @override
  String get pageAtlasTitle => 'Atlas';

  @override
  String get pageCoachTitle => 'Coach';

  @override
  String get noEntrySelected => 'Geen item geselecteerd.';

  @override
  String get entryShare => 'Deel';

  @override
  String get entryFavorite => 'Ster';

  @override
  String get entryEdit => 'Bewerken';

  @override
  String get entryPrevious => 'Vorige invoer';

  @override
  String get entryNext => 'Volgende invoer';

  @override
  String get journalStories => 'Verhalen';

  @override
  String get journalEntries => 'Inzendingen';

  @override
  String get journalEmptyHint =>
      'Begin uw dagboek door een nieuw item toe te voegen.';

  @override
  String get storyToday => 'Vandaag';

  @override
  String get storyThrowback => 'Teruggooi';

  @override
  String get storyNoThrowback => 'Geen terugblik vandaag';

  @override
  String get mediaFiles => 'Mediabestanden';

  @override
  String get mediaEmpty => 'Nog geen foto\'s.';

  @override
  String get mediaEmptyHint =>
      'Foto\'s die bij de inzendingen zijn gevoegd, worden hier getoond.';

  @override
  String get atlasEmpty => 'Geen vermeldingen met een locatie.';

  @override
  String get atlasEmptyHint =>
      'Inzendingen met een locatie worden hier weergegeven.';

  @override
  String get atlasShowAll => 'Toon alle vermeldingen';

  @override
  String get atlasMyLocation => 'Mijn locatie';

  @override
  String get coachAll => 'Allemaal';

  @override
  String get coachPrograms => 'Programma\'s';

  @override
  String get coachTemplates => 'Sjablonen';

  @override
  String get coachKindProgram => 'Programma';

  @override
  String get coachKindTemplate => 'Sjabloon';

  @override
  String get coachNoTemplates => 'Geen programma\'s of sjablonen.';

  @override
  String get coachUseTemplate => 'Schrijf met dit sjabloon';

  @override
  String get coachProgramEverydayTitle => 'Alledaagse momenten';

  @override
  String get coachProgramEverydayDescription =>
      'Vijf korte vragen, één per dag. Elk duurt een minuut of twee en helpt je te zien wat de dag voor jou maakte. Een zachte manier om de gewoonte op te bouwen om elke dag een beetje te schrijven.';

  @override
  String get coachProgramReflectTitle => 'Naar binnen kijken';

  @override
  String get coachProgramReflectDescription =>
      'Eén diepere vraag per week, vijf weken lang. Neem de tijd voor elk van deze dingen: hoe u zich voelt, waar u uitgeput van raakt, waar u dankbaar voor bent.';

  @override
  String get searchFilters => 'Filters';

  @override
  String get searchFilterTags => 'Labels';

  @override
  String get searchFilterStarred => 'Met ster';

  @override
  String get searchHint => 'Typ om te zoeken of kies een filter.';

  @override
  String get locationTitle => 'Locatie';

  @override
  String get locationName => 'Plaatsnaam';

  @override
  String get locationRemove => 'Verwijderen';

  @override
  String get locationServiceDisabled => 'Locatieservices zijn uitgeschakeld.';

  @override
  String get locationPermissionDenied => 'Locatietoestemming is geweigerd.';

  @override
  String get locationUnavailable => 'Kan de huidige locatie niet ophalen.';

  @override
  String get calendarJumpToToday => 'Spring naar vandaag';

  @override
  String get editorStartWriting => 'Begin met schrijven of kies een ';

  @override
  String get editorTemplateLink => 'Sjabloon';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Kies een sjabloon';

  @override
  String get templateFeatured => 'Uitgelichte sjablonen';

  @override
  String get templateMine => 'Mijn sjablonen';

  @override
  String get templateDailyName => 'Dagelijks overzicht';

  @override
  String get templateDailyDescription =>
      'Wat er gebeurde, hoe het voelde en wat er daarna komt.';

  @override
  String get templateDailyText =>
      '## Wat is er vandaag gebeurd\n\n\n## Hoe ik me voelde\n\n\n## Drie dingen waar ik dankbaar voor ben\n1. \n2. \n3. \n\n## Morgen\n';

  @override
  String get templateTravelName => 'Reisdagboekinvoer';

  @override
  String get templateTravelDescription =>
      'Plaatsen, momenten en eten van onderweg.';

  @override
  String get templateTravelText =>
      '## Waar ik ging\n\n\n## Het moment dat ik me het meest herinner\n\n\n## Wat ik heb gegeten\n\n\n## Plannen voor morgen\n';

  @override
  String get templateReadingName => 'Noten lezen';

  @override
  String get templateReadingDescription =>
      'Citaten en gedachten uit wat je leest.';

  @override
  String get templateReadingText =>
      '## Boek\n\n\n## Waar ik ben\n\n\n## Citaten\n> \n\n## Mijn gedachten\n';

  @override
  String get templateWeeklyName => 'Wekelijkse beoordeling';

  @override
  String get templateWeeklyDescription =>
      'Hoogtepunten, worstelingen en de focus van volgende week.';

  @override
  String get templateWeeklyText =>
      '## Hoogtepunten\n\n\n## Wat was moeilijk\n\n\n## Wat ik heb geleerd\n\n\n## Focus voor volgende week\n';

  @override
  String get entryDuplicate => 'Duplicaat';

  @override
  String get entryDuplicated => 'Invoer gedupliceerd';

  @override
  String get entrySaveAsTemplate => 'Opslaan als sjabloon';

  @override
  String get entrySavedAsTemplate => 'Opgeslagen als sjabloon';

  @override
  String get storyStatistics => 'Statistieken';

  @override
  String get storyMoodChart => 'Stemmingsgrafiek';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return '$entries-invoer · $days dagen';
  }

  @override
  String get storyThisYear => 'Dit jaar';

  @override
  String get storyLastYear => 'Vorig jaar';

  @override
  String get storyTapToOpen => 'Tik op een dag om deze te openen';

  @override
  String get settingsGeneralTitle => 'Algemeen';

  @override
  String get settingsDataTitle => 'Gegevens & opslag';

  @override
  String get settingsStoriesTitle => 'Verhalen';

  @override
  String get settingsHelpTitle => 'Hulp & over';

  @override
  String get weatherTitle => 'Weer';

  @override
  String get weatherClear => 'Duidelijk';

  @override
  String get weatherPartlyCloudy => 'Gedeeltelijk bewolkt';

  @override
  String get weatherCloudy => 'Bewolkt';

  @override
  String get weatherFog => 'Mist';

  @override
  String get weatherDrizzle => 'Motregen';

  @override
  String get weatherRain => 'Regen';

  @override
  String get weatherSnow => 'Sneeuw';

  @override
  String get weatherStorm => 'Onweer';

  @override
  String get weatherFetch => 'Ontvang het weer voor dit bericht';

  @override
  String get weatherNeedsLocation =>
      'Voeg eerst een locatie met coördinaten toe.';

  @override
  String get weatherUnavailable =>
      'Het weer is niet beschikbaar voor deze plaats en tijd.';

  @override
  String get weatherRemove => 'Weer verwijderen';

  @override
  String get activityTitle => 'Activiteit';

  @override
  String get activityStill => 'Nog steeds';

  @override
  String get activityWalking => 'Lopen';

  @override
  String get activityRunning => 'Rennen';

  @override
  String get activityCycling => 'Fietsen';

  @override
  String get activityVehicle => 'In een voertuig';

  @override
  String get activityFlying => 'Vliegen';

  @override
  String get activityExercise => 'Oefening';

  @override
  String get activityDetect => 'Detecteer huidige activiteit';

  @override
  String get activityDetectFailed => 'Kan een activiteit niet detecteren.';

  @override
  String get activityRemove => 'Activiteit verwijderen';

  @override
  String get settingsAutoAddTitle => 'Automatisch toevoegen';

  @override
  String get settingsAutoAddLocation => 'Locatie';

  @override
  String get settingsAutoAddWeather => 'Weer';

  @override
  String get settingsAutoAddHint =>
      'Nieuwe vermeldingen worden ingevuld wanneer ze worden gemaakt.';

  @override
  String get settingsTemperatureUnit => 'Temperatuur eenheid';

  @override
  String get settingsCelsius => 'Celsius (°C)';

  @override
  String get settingsFahrenheit => 'Fahrenheit (°F)';

  @override
  String get moodGreat => 'Geweldig';

  @override
  String get moodGood => 'Goed';

  @override
  String get moodOkay => 'Oké';

  @override
  String get moodBad => 'Slecht';

  @override
  String get moodAwful => 'Verschrikkelijk';

  @override
  String get locationSearchHint => 'Zoek een plaats';

  @override
  String get locationSearchEmpty => 'Geen plaatsen gevonden';

  @override
  String get settingsWallpaper => 'Behang';

  @override
  String get wallpaperNone => 'Geen';

  @override
  String get wallpaperDots => 'Punten';

  @override
  String get wallpaperGrid => 'Raster';

  @override
  String get wallpaperLines => 'Lijnen';

  @override
  String get wallpaperPhoto => 'Foto…';

  @override
  String get settingsFontFamily => 'Lettertype';

  @override
  String get fontSystem => 'Systeem';

  @override
  String get fontSerif => 'Serif';

  @override
  String get fontMono => 'Monoruimte';

  @override
  String get settingsFontSize => 'Lettergrootte';

  @override
  String get fontSizeSmall => 'Klein';

  @override
  String get fontSizeMedium => 'Middelmatig';

  @override
  String get fontSizeLarge => 'Groot';

  @override
  String get fontSizeExtraLarge => 'Extra groot';

  @override
  String get settingsLineSpacing => 'Regelafstand';

  @override
  String get lineSpacingCompact => 'Compact';

  @override
  String get lineSpacingNormal => 'Normaal';

  @override
  String get lineSpacingRelaxed => 'Ontspannen';

  @override
  String get moodAssociationsTitle => 'Wat mij doet voelen…';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching van $total-gegevens';
  }

  @override
  String get videoRecord => 'Neem een video op';

  @override
  String get videoChoose => 'Kies een video';

  @override
  String get audioRecordTitle => 'Neem een spraaknotitie op';

  @override
  String get audioChoose => 'Kies een audiobestand';

  @override
  String get audioStart => 'Opnemen';

  @override
  String get audioStop => 'Stop en bespaar';

  @override
  String get audioPermissionDenied =>
      'Microfoontoegang is uitgeschakeld. Sta dit toe in de systeeminstellingen.';

  @override
  String get mediaTooLarge => 'Deze video is te groot om bij te voegen.';

  @override
  String get mediaUnavailable =>
      'Deze bijlage is niet beschikbaar op dit apparaat.';

  @override
  String get widgetDone => 'De inzending van vandaag is geschreven';

  @override
  String get widgetPending => 'Hoe was je dag?';

  @override
  String get widgetWrite => 'Schrijf';

  @override
  String get insertChecklist => 'Controlelijst';

  @override
  String get insertNumberedList => 'Genummerde lijst';

  @override
  String get insertTable => 'Tafel';

  @override
  String get insertDivider => 'Verdeler';

  @override
  String get insertCodeBlock => 'Codeblok';

  @override
  String get journalSortTitle => 'Sorteer de vermeldingen';

  @override
  String get journalSortUpdated => 'Laatst bijgewerkt';

  @override
  String get settingsTimeFormat => 'Tijdformaat';

  @override
  String get settingsDayStart =>
      'Nieuwe inschrijvingen tellen mee voor de dag ervoor tot';

  @override
  String get settingsDayAskUntil => 'Vraag dan welke dag tot';

  @override
  String get settingsDayStartMidnight => 'Uit';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Bij elk bericht wordt de dag behouden waartoe het behoort, naast het tijdstip waarop het is geschreven, en u kunt die dag op elk gewenst moment in de editor wijzigen. Deze uren bepalen alleen de dag voor nieuwe vermeldingen, dus als u deze wijzigt, wordt geen bestaande vermelding verplaatst.';

  @override
  String get lateNightBadge =>
      '\'s Avonds laat geschreven, geteld voor de dag ervoor';

  @override
  String editorDayAsk(String time) {
    return 'Geschreven op $time. Voor welke dag is het?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (gisteren)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (vandaag)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'Geschreven $when';
  }

  @override
  String get timeFormat12 => '12 uur';

  @override
  String get timeFormat24 => '24 uur per dag';

  @override
  String get settingsReminderDays => 'Herinner me eraan';

  @override
  String get locationRecent => 'Recente plaatsen';

  @override
  String get shareImage => 'Deel afbeelding';

  @override
  String get shareSaveImage => 'Afbeelding opslaan';

  @override
  String get shareSaved => 'Afbeelding opgeslagen';

  @override
  String get deletedTitle => 'Onlangs verwijderd';

  @override
  String get deletedNone => 'Niets recentelijk verwijderd';

  @override
  String deletedHint(int days) {
    return 'Verwijderde vermeldingen blijven hier $days dagen staan en worden daarna gewist.';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days dagen resterend';
  }

  @override
  String get deletedRestore => 'Herstellen';

  @override
  String get deletedDeleteForever => 'Voor altijd verwijderen';

  @override
  String get deletedDeleteForeverDescription =>
      'De invoer en de bijlagen worden gewist. Dit kan niet ongedaan worden gemaakt.';

  @override
  String get deletedEmpty => 'Leeg';

  @override
  String get deletedEmptyDescription =>
      'Wis elk item in Recent verwijderd? Dit kan niet ongedaan worden gemaakt.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Willekeurige wandeling';

  @override
  String get randomSubtitle => 'Open een eerder item';

  @override
  String get randomNext => 'Een ander';

  @override
  String get randomAll => 'Allemaal';

  @override
  String get randomWithPhotos => 'Met foto\'s';

  @override
  String get randomGoodDays => 'Goede dagen';

  @override
  String get randomEmpty => 'Geen vermeldingen om uit te kiezen';

  @override
  String get reviewWeekTitle => 'Deze week';

  @override
  String get reviewWeekSubtitle => 'Jouw week tot nu toe';

  @override
  String get reviewYearTitle => 'Dit jaar';

  @override
  String get reviewEmpty => 'Nog niets geschreven';

  @override
  String get reviewEntries => 'Inzendingen';

  @override
  String get reviewDaysWritten => 'Dagen geschreven';

  @override
  String get reviewWords => 'Woorden';

  @override
  String get reviewPhotos => 'Foto\'s';

  @override
  String get reviewLongestRun => 'Langste reeks dagen';

  @override
  String get reviewAverageMood => 'Gemiddeld humeur';

  @override
  String get reviewFavorites => 'Meestal';

  @override
  String get reviewByMonth => 'Per maand';

  @override
  String get reviewHighlight => 'Hoogtepunt';

  @override
  String get yearInPixels => 'Jaar in pixels';

  @override
  String get capsuleSeal => 'Zegel als een tijdcapsule';

  @override
  String get capsuleTitle => 'Tijdcapsule';

  @override
  String capsuleOpensOn(Object date) {
    return 'Opent op $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Geschreven op $date';
  }

  @override
  String get capsuleOpenEarly => 'Vroeg geopend';

  @override
  String get capsuleOpenEarlyDescription =>
      'De capsule gaat nu open en blijft open.';

  @override
  String get capsuleOpened => 'Tijdcapsule geopend';

  @override
  String get templateMorningName => 'Ochtendpagina\'s';

  @override
  String get templateMorningDescription => 'Regel de dag in drie minuten';

  @override
  String get templateMorningText =>
      '## Drie dingen die ik vandaag goed wil doen\n1. \n2. \n3. \n\n## Iets waar ik naar uitkijk\n\n## Een opmerking voor mezelf\n';

  @override
  String get templateEveningName => 'Avondoverzicht';

  @override
  String get templateEveningDescription => 'Sluit de dag af met wat goed ging';

  @override
  String get templateEveningText =>
      '## Drie goede dingen vandaag\n1. \n2. \n3. \n\n## Wat ik heb geleerd\n\n## Wat kan er morgen beter gaan\n';

  @override
  String get routineMorning => 'Goedemorgen';

  @override
  String get routineEvening => 'Avondoverzicht';

  @override
  String get settingsRoutinePrompts => 'Ochtend- en avondaanwijzingen';

  @override
  String get settingsRoutinePromptsHint =>
      'Stel de ochtend- of avondsjabloon voor in Stories';

  @override
  String get checkInTitle => 'Snel inchecken';

  @override
  String get checkInSubtitle => 'Stemming in twee tikken';

  @override
  String get checkInMood => 'Hoe voel je je?';

  @override
  String get checkInActivity => 'Wat ben je aan het doen?';

  @override
  String get checkInNote => 'Een regel erover (optioneel)';

  @override
  String get checkInSave => 'Opslaan';

  @override
  String editorWordCount(int words, int characters) {
    return '$words-woorden · $characters-tekens';
  }

  @override
  String get coachProgramEverydayTagline =>
      'Let op de kleine dingen op een dag.';

  @override
  String get coachProgramReflectTagline => 'Vertraag en luister naar jezelf.';

  @override
  String get coachDuration => 'Duur';

  @override
  String get coachInterval => 'Interval';

  @override
  String get coachDifficulty => 'Moeilijkheidsgraad';

  @override
  String get coachIntervalDaily => 'Dagelijks';

  @override
  String get coachIntervalWeekly => 'Wekelijks';

  @override
  String get coachDifficultyBeginner => 'Beginner';

  @override
  String get coachDifficultyIntermediate => 'Gemiddeld';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagen',
      one: '$count dag',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weken',
      one: '$count week',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'Dag $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Week $n';
  }

  @override
  String get coachEnroll => 'Schrijf je in';

  @override
  String get coachEndProgram => 'Einde programma';

  @override
  String get coachAuthor => 'Auteur';

  @override
  String get coachAuthorBio => 'Prompts geschreven voor deze app.';

  @override
  String get coachEnrolledTip =>
      'Helemaal klaar! Je vragen verschijnen in Stories.';

  @override
  String get coachGoToStories => 'Ga naar Verhalen';

  @override
  String get coachAnswerHint => 'Schrijf je antwoord…';

  @override
  String get storyWrapUp => 'Dat is alles voor vandaag.';

  @override
  String get storyTapToClose => 'Tik om te sluiten';

  @override
  String get coachAnswerDone => 'Klaar';

  @override
  String get coachAnswered => 'Beantwoord, tik om te openen';

  @override
  String get coachAnsweredEarlier => 'Beantwoord';

  @override
  String get locationLocating => 'Lokaliseren...';

  @override
  String get locationPickPlace => 'Kies een plaats';

  @override
  String get locationPlacesHint => 'Adres of naam van de plaats';

  @override
  String get locationCustom => 'Aangepaste plaats';

  @override
  String get locationCurrent => 'Huidige locatie';

  @override
  String get locationSaved => 'Opgeslagen plaatsen';

  @override
  String get locationSearchResults => 'Zoekresultaten';

  @override
  String get locationNearby => 'Plaatsen in de buurt';

  @override
  String get locationRename => 'Hernoemen';

  @override
  String get locationSavePlace => 'Bewaar plaats';

  @override
  String get locationUnsavePlace => 'Verwijderen uit opgeslagen plaatsen';

  @override
  String get shareAs => 'Deel als…';

  @override
  String get shareAsImage => 'Afbeelding';

  @override
  String get shareAsZip => 'ZIP met de originele media';

  @override
  String get shareAsPlainText => 'Platte tekst';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Welkom bij AID Diary';

  @override
  String get onboardWelcomeText =>
      'Begin hier of sluit dit apparaat aan op een apparaat dat u al gebruikt.';

  @override
  String get onboardStart => 'Begin met schrijven';

  @override
  String get helpFaq => 'Veelgestelde vragen';

  @override
  String get helpFaq1Q => 'Waar wordt mijn dagboek bewaard?';

  @override
  String get helpFaq1A =>
      'Uw dagboek wordt op dit apparaat opgeslagen. Het bereikt alleen andere apparaten of opslag wanneer u synchronisatie inschakelt, deelt of exporteert. De synchronisatie is end-to-end gecodeerd.';

  @override
  String get helpFaq2Q =>
      'Hoe bewaar ik een kopie of verplaats ik naar een nieuw apparaat?';

  @override
  String get helpFaq2A =>
      'Maak verbinding met een bestaand apparaat in Instellingen → Gegevens en opslag → Synchroniseren en bevestig autorisatie op het apparaat waarop uw agenda staat. Beide apparaten blijven bruikbaar. U kunt ook een back-up maken en deze op een ander apparaat terugzetten.';

  @override
  String get helpFaq3Q =>
      'Kan ik aantekeningen uit andere dagboekapps overbrengen?';

  @override
  String get helpFaq3A =>
      'Ja: importeer in Instellingen → Gegevens en opslag exports van Daylio, Diarium, Diaro, DayBook, My Brain, OneShot en Pixels, of een JSON-export.';

  @override
  String get helpFaq4Q => 'Hoe werken coachprogramma’s?';

  @override
  String get helpFaq4A =>
      'Schrijf je in voor een programma op de Coachpagina. Elke dag of week wacht er een nieuwe vraag in Stories; uw antwoord wordt opgeslagen als invoer.';

  @override
  String get helpFaq5Q => 'Wat moet ik doen als ik mijn toegangscode vergeet?';

  @override
  String get helpFaq5A =>
      'De toegangscode kan niet worden hersteld, dus bewaar een back-up van uw dagboek.';

  @override
  String get helpPrivacy => 'Privacy';

  @override
  String get helpPrivacyText =>
      'Dagboekinhoud en media blijven op dit apparaat staan, tenzij u gecodeerde synchronisatie inschakelt of deze deelt/exporteert. Kaarten, opzoeken van plaatsen en het weer gebruiken de geconfigureerde services en verzenden de locatie of zoekopdracht die nodig is voor dat verzoek, geen dagboektekst.';

  @override
  String get photoMetaTitle => 'Gegevens van de foto gebruiken?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Tel deze invoer voor $date en stel de plaats in op $place, zoals vastgelegd op de foto?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Tel deze invoer mee voor $date, toen de foto werd gemaakt?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'De plaats van dit bericht instellen op $place, waar de foto is genomen?';
  }

  @override
  String get photoMetaApply => 'Gebruik ze';

  @override
  String get quickWriteTitle => 'Snel schrijven';

  @override
  String get quickWriteText => 'Tik om een nieuw item te starten.';

  @override
  String get settingsQuickWriteTitle => 'Snel schrijven in meldingen';

  @override
  String get settingsQuickWriteDescription =>
      'Houd een melding bij waarmee een nieuw item wordt geopend.';

  @override
  String get settingsNudgesTitle => 'Geef me een duwtje na een rustig stuk';

  @override
  String settingsNudgesDescription(int days) {
    return 'Een vriendelijke herinnering als je $days dagen niet hebt geschreven.';
  }

  @override
  String get nudgeTitle => 'Het is een tijdje geleden';

  @override
  String get nudgeMonday => 'Een nieuwe week: waar kijk jij naar uit?';

  @override
  String get nudgeTuesday =>
      'Twee regels zijn voldoende. Hoe gaat het vandaag met je?';

  @override
  String get nudgeWednesday => 'Halverwege de week. Wat viel tot nu toe op?';

  @override
  String get nudgeThursday =>
      'Iets kleins dat de moeite waard is om te bewaren van vandaag?';

  @override
  String get nudgeFriday => 'De week loopt ten einde. Noteer één goed moment.';

  @override
  String get nudgeSaturday =>
      'Een rustige zaterdag is een goede dag om te schrijven.';

  @override
  String get nudgeSunday => 'Kijk terug op de week voordat deze eindigt.';

  @override
  String get photoWidgetEmpty =>
      'Foto\'s die u aan inzendingen toevoegt, worden hier weergegeven.';

  @override
  String get channelReminders => 'Herinneringen';

  @override
  String get channelOnThisDay => 'Op deze dag';

  @override
  String get channelCoach => 'Coach vraagt';

  @override
  String get channelNudges => 'Nudges na rustige dagen';

  @override
  String get channelQuickWrite => 'Snel schrijven';

  @override
  String get channelBackup => 'Back-ups';

  @override
  String get formatJsonExport => 'JSON (AID Diary-export)';

  @override
  String get aboutModifiedNotice =>
      'Een aangepaste versie van Daily You door Demizo en medewerkers. Het is niet de officiële Daily You-app.';

  @override
  String get toolbarPhotos => 'Voeg foto\'s toe';

  @override
  String get toolbarMedia => 'Foto\'s en video\'s';

  @override
  String get mediaFromGallery => 'Kies uit galerij';

  @override
  String get mediaFromFiles => 'Kies uit bestanden';

  @override
  String get editorLeaveTitle => 'Deze invoer opslaan?';

  @override
  String get editorLeaveDiscard => 'Bewaar niet';

  @override
  String get editorTitleHint => 'Titel';

  @override
  String get editorLocating => 'Lokaliseren...';

  @override
  String get toolbarVideo => 'Video';

  @override
  String get toolbarAudio => 'Spraaknotitie';

  @override
  String get toolbarTags => 'Labels';

  @override
  String get toolbarBulletList => 'Lijst met opsommingstekens';

  @override
  String get toolbarHeading => 'Rubriek';

  @override
  String get toolbarBold => 'Vet';

  @override
  String get toolbarItalic => 'Cursief';

  @override
  String get toolbarHighlight => 'Hoogtepunt';

  @override
  String get toolbarStrikethrough => 'Doorhalen';

  @override
  String get toolbarQuote => 'Citaat';

  @override
  String get toolbarLink => 'Koppeling';

  @override
  String get toolbarInsert => 'Invoegen';

  @override
  String get toolbarUndo => 'Ongedaan maken';

  @override
  String get toolbarRedo => 'Opnieuw uitvoeren';

  @override
  String get toolbarInsertDate => 'Voer de datum in';

  @override
  String get toolbarInsertTime => 'Voer de tijd in';

  @override
  String get settingsSyncTitle => 'Cloudsynchronisatie';

  @override
  String get syncOffDescription =>
      'Houd dit dagboek hetzelfde bij op al uw apparaten via Google Drive of een WebDAV-server, zoals Nextcloud, Synology of Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'Synchroniseren met Google Drive';

  @override
  String get syncOrWebDav => 'Of een WebDAV-server';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn => 'Ingelogd. U kunt teruggaan naar AID Diary.';

  @override
  String get syncGoogleSignInAgain => 'Google wil dat je opnieuw inlogt.';

  @override
  String get syncSignInAgain => 'Meld u opnieuw aan';

  @override
  String get settingsCommandLineTitle => 'Commandoregel';

  @override
  String get commandLineToggle => 'Commandoregelinterface';

  @override
  String get commandLineToggleHint =>
      'Hiermee kunnen de hulpopdrachten en andere programma\'s op dit apparaat de opdrachten van de app gebruiken.';

  @override
  String get commandLineAlwaysOn => 'Altijd bezig met ontwikkelingsbuilds.';

  @override
  String commandLineListening(int port) {
    return 'Luisteren op poort $port';
  }

  @override
  String get commandPaletteTitle => 'Alle commando\'s';

  @override
  String get commandPaletteSearch => 'Zoekopdrachten';

  @override
  String get commandPaletteRun => 'Rennen';

  @override
  String get commandPaletteConfirm =>
      'Dit kan niet zomaar ongedaan worden gemaakt. Voer het uit?';

  @override
  String syncReceiving(int done, int total) {
    return '$done of $total ontvangen…';
  }

  @override
  String syncSending(int done, int total) {
    return '$done van $total verzenden…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'Toegang tot Google Drive was niet toegestaan. Maak opnieuw verbinding en vink Google Drive aan op de pagina van Google.';

  @override
  String get syncEntryUnsynced =>
      'Niet gesynchroniseerd: de laatste synchronisatie is niet gelukt';

  @override
  String get syncUseOfficial => 'Gebruik de AID-synchronisatieserver';

  @override
  String get syncServer => 'Serveradres';

  @override
  String get syncUsername => 'Gebruikersnaam';

  @override
  String get syncPassword => 'Wachtwoord';

  @override
  String get syncConnect => 'Verbinden';

  @override
  String get syncConnecting => 'Verbinden…';

  @override
  String get syncSignInFailed =>
      'Kon niet inloggen. Controleer het adres, de gebruikersnaam en het wachtwoord.';

  @override
  String syncConnectFailed(String error) {
    return 'Kon geen verbinding maken: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Begin met synchroniseren';

  @override
  String get syncNewSpaceDescription =>
      'Er is hier nog geen gesynchroniseerd dagboek. Dit dagboek wordt end-to-end gecodeerd geüpload met een sleutel die op uw apparaten blijft staan.';

  @override
  String get syncJoinTitle => 'Sluit u aan bij het gesynchroniseerde dagboek';

  @override
  String get syncWrongKey =>
      'Deze herstelcode opent het gesynchroniseerde dagboek niet.';

  @override
  String syncLastSynced(String time) {
    return 'Laatst gesynchroniseerd $time';
  }

  @override
  String get syncNever => 'Nog niet gesynchroniseerd';

  @override
  String get syncSyncing => 'Synchroniseren...';

  @override
  String syncFailed(String error) {
    return 'De laatste synchronisatie is mislukt: $error';
  }

  @override
  String get syncLocked =>
      'Het gesynchroniseerde dagboek behoort nu toe aan andere apparaten of is opnieuw begonnen. Koppel met een van hen of gebruik de herstelcode om te blijven synchroniseren.';

  @override
  String get syncNow => 'Synchroniseer nu';

  @override
  String get syncUnlock => 'Ontgrendelen';

  @override
  String get syncEncrypted => 'End-to-end gecodeerd';

  @override
  String get syncDisconnect => 'Stop met synchroniseren';

  @override
  String get syncDisconnectDescription =>
      'Dit apparaat stopt met synchroniseren. Het dagboek hier en de gesynchroniseerde kopie blijven zoals ze zijn.';

  @override
  String get syncOwnRecoveryPassword => 'Gebruik mijn eigen herstelwachtwoord';

  @override
  String get syncRecoveryPassword => 'Herstelwachtwoord';

  @override
  String get syncRecoveryPasswordRepeat => 'Herhaal het herstelwachtwoord';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Gebruik minimaal $min-tekens';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'De wachtwoorden verschillen';

  @override
  String get syncRecoveryCode => 'Herstelcode';

  @override
  String get syncRecoveryCodeTitle => 'Sla uw herstelcode op';

  @override
  String get syncRecoveryCodeDescription =>
      'Als elk apparaat van u verloren gaat, herstelt deze code uw gesynchroniseerde dagboek. Bewaar het in een wachtwoordbeheerder of op papier. Het wordt slechts één keer getoond.';

  @override
  String get syncRecoveryCodeCopied => 'Herstelcode gekopieerd';

  @override
  String get syncRecoveryCodeSaved => 'Ik heb het opgeslagen';

  @override
  String get syncJoinNeedsKey =>
      'Dit gesynchroniseerde dagboek is eigendom van uw andere apparaten. Koppel met een van hen of gebruik de herstelcode. De vermeldingen op dit apparaat worden eraan toegevoegd.';

  @override
  String get syncPairDevice => 'Koppelen met een apparaat';

  @override
  String get syncUseRecoveryCode => 'Gebruik de herstelcode';

  @override
  String get syncAddDevice => 'Voeg een apparaat toe';

  @override
  String get syncChangeRecoveryCode => 'Wijzig de herstelcode';

  @override
  String get syncChangeRecoveryDescription =>
      'Een nieuwe code vervangt de huidige, die niet meer werkt. Uw gegevens en andere apparaten blijven zoals ze zijn.';

  @override
  String get syncNewRandomCode => 'Nieuwe willekeurige code';

  @override
  String get syncRecoveryCodeChanged => 'Herstelcode gewijzigd';

  @override
  String get syncResetSpace => 'Start het gesynchroniseerde dagboek opnieuw';

  @override
  String get syncResetSpaceDescription =>
      'Alleen wanneer geen enkel apparaat en geen herstelcode het meer opent: de gesynchroniseerde kopie wordt vervangen door het dagboek op dit apparaat, onder de sleutels van dit apparaat. Uw andere apparaten koppelen vervolgens opnieuw.';

  @override
  String get syncPairTitle => 'Koppel apparaten';

  @override
  String get syncPairShow => 'Laat een code zien';

  @override
  String get syncPairEnter => 'Voer een code in';

  @override
  String get syncPairShowHint =>
      'Open op uw andere apparaat Apparaten koppelen, kies Voer een code in en typ of scan deze.';

  @override
  String get syncPairEnterHint =>
      'Typ de code die op uw andere apparaat wordt weergegeven, of scan deze.';

  @override
  String get syncPairCode => 'Koppelingscode';

  @override
  String get syncPairScan => 'Scannen';

  @override
  String get syncPairStart => 'Paar';

  @override
  String get syncPairWaiting => 'Wachten op het andere apparaat…';

  @override
  String syncPairDone(String device) {
    return 'Gecombineerd met $device';
  }

  @override
  String get syncPairWrongCode =>
      'De code kwam niet overeen. Toon een nieuwe code en probeer het opnieuw.';

  @override
  String get syncPairNoOffer =>
      'Geen enkel apparaat toont deze code. Mogelijk is deze verlopen.';

  @override
  String get syncPairTimedOut => 'Het andere apparaat antwoordde niet op tijd.';

  @override
  String get syncPairNeither =>
      'Geen van beide apparaten is nog ingesteld met dit gesynchroniseerde dagboek.';

  @override
  String get syncPairBoth =>
      'Beide apparaten openen dit gesynchroniseerde dagboek al.';

  @override
  String syncPairFailed(String error) {
    return 'Koppelen mislukt: $error';
  }

  @override
  String get syncMediaPending =>
      'Dagboek gesynchroniseerd · sommige media worden nog steeds overgedragen';

  @override
  String get syncWaitingForDevices =>
      'Dagboek gesynchroniseerd · wachtend tot een ander apparaat media overdraagt';

  @override
  String get syncCacheNotice =>
      'Cloudmedia zijn tijdelijk. Bewaar de originelen op uw apparaten; synchroniseren is geen back-up.';

  @override
  String get paperTitle => 'Briefpapier';

  @override
  String get paperPlain => 'Gewoon';

  @override
  String get paperLined => 'Gevoerd';

  @override
  String get paperGrid => 'Raster';

  @override
  String get paperTinted => 'Getint';

  @override
  String get paperDecorationTitle => 'Decoraties';

  @override
  String get paperDecorationNone => 'Geen';

  @override
  String get paperDecorationBotanical => 'Bladeren';

  @override
  String get paperDecorationStars => 'Sterren';

  @override
  String get paperDecorationWashi => 'Washi-tape';

  @override
  String get themeDarkChoice => 'Donker uiterlijk';

  @override
  String get themeDarkSame => 'Volg het lichtpalet';

  @override
  String get themeDarkCustom => 'Apart palet';

  @override
  String get themeDarkAccent => 'Donkere accentkleur';

  @override
  String get themeColorTeal => 'Wintertaling';

  @override
  String get themeColorCyan => 'Cyaan';

  @override
  String get themeColorIndigo => 'Indigo';

  @override
  String get themeColorCoral => 'Koraal';

  @override
  String get themeColorOlive => 'Olijf';

  @override
  String get themeColorSlate => 'Leisteen';

  @override
  String get drawingTitle => 'Tekening';

  @override
  String get drawingPen => 'Pen';

  @override
  String get drawingEraser => 'Gum';

  @override
  String get drawingUndo => 'Ongedaan maken';

  @override
  String get drawingClear => 'Duidelijk';

  @override
  String get drawingWidth => 'Penbreedte';

  @override
  String get drawingStylusOnly => 'Alleen stylus';

  @override
  String get drawingDiscardTitle => 'Tekening weggooien?';

  @override
  String get drawingDiscardBody => 'Deze tekening is niet opgeslagen.';

  @override
  String get drawingSaveError => 'Kan de tekening niet opslaan.';

  @override
  String get syncNetworkTitle => 'Netwerkdiagnostiek';

  @override
  String get syncNetworkRefresh => 'Vernieuwen';

  @override
  String get syncNetworkSelectedRoute => 'Huidig pad';

  @override
  String get syncNetworkAvailableRoutes => 'Beschikbare paden';

  @override
  String get syncNetworkSignaling => 'Verbinding met apparaatmap';

  @override
  String get syncNetworkRelayRemaining => 'Resterende estafettevergoeding';

  @override
  String get syncNetworkIcePair => 'Kandidaten voor directe verbinding';

  @override
  String get syncNetworkPeerTrusted => 'Geauthenticeerd apparaat';

  @override
  String get syncNetworkNoRoute => 'Wachten op verbinding';

  @override
  String get syncNetworkUnavailable => 'Diagnostiek is niet beschikbaar';

  @override
  String get syncMediaCopiesTitle => 'Medialevering en kopieën';

  @override
  String get syncMediaPendingCount => 'Wachten op overdracht';

  @override
  String get syncMediaDurableCount => 'Afgeleverd in persoonlijke opslag';

  @override
  String get syncMediaTemporaryCount => 'Tijdelijke of onbevestigde kopieën';

  @override
  String get syncMediaReceiptExplanation =>
      'Deze tellingen beschrijven voltooide leveringen, niet een nieuwe audit van overgebleven back-ups.';

  @override
  String get syncMediaCacheExplanation =>
      'Tijdelijke cloudmedia kunnen verlopen. Bewaar uw originelen of een aparte back-up.';

  @override
  String get momentsTitle => 'Fotomomenten';

  @override
  String get momentsHint =>
      'Vind groepen met behulp van lokale fototijden en optionele coördinaten. Er worden alleen foto\'s bijgevoegd als u een kaart kiest.';

  @override
  String get momentsScan => 'Vind momenten';

  @override
  String get momentsChooseFolder => 'Kies fotomap';

  @override
  String get momentsLocation => 'Voeg fotolocaties toe';

  @override
  String get momentsEmpty => 'Geen recente fotogroepen.';

  @override
  String get momentsCreate => 'Schrijf over deze foto\'s';

  @override
  String get momentsDismiss => 'Negeren';

  @override
  String get momentsError => 'Kan lokale foto\'s niet lezen.';

  @override
  String get momentsCreated => 'Foto-invoer gemaakt.';

  @override
  String get momentsPermission =>
      'Geef toegang tot foto\'s om lokale suggesties te vinden.';

  @override
  String get momentsScope =>
      'Alleen recente foto\'s; maximaal 500 foto\'s en 20 foto\'s per kaart.';

  @override
  String momentsPhotoCount(int count) {
    return '$count-foto\'s';
  }

  @override
  String get nearbyTitle => 'Sluit apparaten aan';

  @override
  String get nearbySend => 'Autoriseer een ander apparaat';

  @override
  String get nearbyReceive => 'Maak verbinding met een bestaand apparaat';

  @override
  String get nearbyInstructions =>
      'Verbind beide apparaten met dezelfde Wi-Fi of met elkaars hotspot. Bevestig autorisatie op het bestaande apparaat; beide apparaten blijven bruikbaar. Er is geen internet vereist.';

  @override
  String get nearbyCompare =>
      'Vergelijk deze code op beide apparaten voordat u deze goedkeurt.';

  @override
  String get nearbyConfirm => 'De codes komen overeen';

  @override
  String get nearbyScan => 'Scan de code van het andere apparaat';

  @override
  String get nearbyPaste => 'Uitnodiging plakken';

  @override
  String get nearbyWaiting => 'Wachten op goedkeuring op het andere apparaat';

  @override
  String get nearbyWorking =>
      'Uw agenda en bijlagen autoriseren en synchroniseren…';

  @override
  String get nearbyPending =>
      'Sommige bijlagen moeten nog worden gesynchroniseerd. Houd het andere apparaat online en probeer het opnieuw.';

  @override
  String get nearbyComplete =>
      'Apparaat aangesloten; dagboek en bijlagen gesynchroniseerd';

  @override
  String get nearbyFailed =>
      'De verbinding is niet voltooid. Controleer de lokale verbinding en probeer het opnieuw.';

  @override
  String get nearbyEmptyRequired =>
      'Gebruik een apparaat met een leeg dagboek dat nog niet is aangesloten om te synchroniseren.';

  @override
  String get nearbyRetry => 'Ga door met synchroniseren';

  @override
  String get nearbyWifi => 'Wi-Fi-instellingen';

  @override
  String get nearbyHotspot => 'Hotspot-instellingen';

  @override
  String get nearbyKeepOpen =>
      'Houd deze pagina open totdat het nieuwe apparaat klaar is. De uitnodiging vervalt na twee minuten.';

  @override
  String get syncDevicesTitle => 'Geautoriseerde apparaten';

  @override
  String get syncDevicesDescription =>
      'Alleen goedgekeurde apparaten hebben toegang tot dit AID-account. Als u een apparaat intrekt, wordt de server geblokkeerd, maar kan een hoofdsleutel of agenda die er al naartoe is gekopieerd niet worden gewist.';

  @override
  String get syncDeviceRequest =>
      'Toon deze autorisatie-QR aan een goedgekeurd apparaat';

  @override
  String get syncDeviceAuthorize => 'Autoriseer een apparaat';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Scan of plak het autorisatieverzoek van het nieuwe apparaat.';

  @override
  String get syncDeviceRevoke => 'Intrekken';

  @override
  String get syncDeviceRotate =>
      'Draai de ondertekeningssleutel van dit apparaat';

  @override
  String get syncDeviceCheck => 'Controleer autorisatie';

  @override
  String get syncDeviceHardware =>
      'Door hardware ondersteunde ondertekeningssleutel';

  @override
  String get syncDeviceSoftware =>
      'Niet-exporteerbare softwareondertekeningssleutel';

  @override
  String get syncDeviceUnavailable =>
      'Apparaatautorisatie is niet beschikbaar. Keur dit apparaat goed vanaf een ander geautoriseerd apparaat en probeer het opnieuw.';

  @override
  String get syncDeviceRevoked => 'Ingetrokken';

  @override
  String get syncDeviceLocal => 'Dit apparaat';

  @override
  String get cloudTrafficTitle =>
      'Maandelijks quotum voor gegevensoverdracht in de cloud voor mediabestanden';

  @override
  String get cloudTrafficLimit => 'Maandelijks quotum voor gegevensoverdracht';

  @override
  String get cloudTrafficUsed => 'Gebruikte gegevensoverdracht';

  @override
  String get cloudTrafficRemaining => 'Resterende gegevensoverdracht';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'Het quotum voor gegevensoverdracht wordt opnieuw ingesteld op $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'Het quotum voor gegevensoverdracht in de cloud voor mediabestanden is opgebruikt. Ontbrekende mediabestanden worden automatisch gesynchroniseerd wanneer er een directe verbinding beschikbaar is of het quotum opnieuw wordt ingesteld.';

  @override
  String get cloudTrafficExplanation =>
      'Caching van mediabestanden en live relay delen dit quotum voor gegevensoverdracht. Directe verbindingen verbruiken het niet. Dagboektekst en verbindingscontroleberichten hebben aparte kleine dagelijkse limieten.';

  @override
  String get appearanceThemeSection => 'App-thema';

  @override
  String get appearancePaperSection => 'Dagboek papier';

  @override
  String get appearanceTypographySection => 'Dagboek tekst';

  @override
  String get appearancePreferencesSection => 'Algemene voorkeuren';

  @override
  String get themeSystemAccentHint =>
      'Gebruikt het systeempalet in plaats van aangepaste kleuren. Schakel het uit om uw eigen te kiezen.';

  @override
  String get syncDeviceNameSaveFailed =>
      'Kan de apparaatnaam niet opslaan. Probeer het opnieuw.';

  @override
  String get nearbyConnectionHelp => 'Hulp bij verbinding';

  @override
  String get syncAllSynced => 'Alles gesynchroniseerd';

  @override
  String get syncDetailsTitle => 'Synchroniseer details';

  @override
  String get syncMore => 'Meer opties';

  @override
  String get syncDeviceName => 'Apparaatnaam';

  @override
  String get syncDeviceNameHint => 'Bijvoorbeeld: Mijn tablet';

  @override
  String get syncDeviceNameInvalid => 'Gebruik 1 tot 32 tekens';

  @override
  String get syncDeviceKeyDetails => 'Beveiligingsdetails';

  @override
  String get syncConnectionProblem =>
      'Kan momenteel niet synchroniseren. Automatisch opnieuw proberen.';

  @override
  String get syncCopyComplete =>
      'Volledige kopie van uw dagboek en mediabestanden';

  @override
  String get syncCopyPartial => 'Sommige media ontbreken nog';

  @override
  String get syncCopyOlder => 'Nieuwe wijzigingen wachten op synchronisatie';

  @override
  String get syncCopyUnavailable =>
      'Kopieergegevens zijn niet beschikbaar. Probeer het later opnieuw.';

  @override
  String get syncCopyLastKnown =>
      'Andere apparaten tonen hun laatste bevestigde exemplaar. Offline apparaten kunnen nu niet worden gecontroleerd.';

  @override
  String get syncCopyTemporary =>
      'Tijdelijke cache. Bewaar de originelen op uw apparaten.';

  @override
  String get syncCopyStorage =>
      'Uw synchronisatieopslag. Voltooide media-uploads worden vermeld in de diagnostische gegevens.';

  @override
  String syncCopyChecked(String time) {
    return 'Laatst bevestigde $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Resterende gegevensoverdracht deze maand: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Begin hier';

  @override
  String get onboardConnect => 'Maak verbinding met een bestaand apparaat';

  @override
  String get onboardFailed =>
      'De installatie kon niet worden voltooid. Je dagboek is veilig; Probeer het opnieuw.';

  @override
  String get tutorialTitle => 'Hoe het dagboek te gebruiken';

  @override
  String get tutorialWriteTitle => 'Schrijf uw eerste dagboekaantekening';

  @override
  String get tutorialWriteText =>
      'Tik op + om een dagboekaantekening te schrijven. Voeg een optionele titel toe, kies de dagboekdatum en tik op het vinkje om op te slaan. U kunt uw dagboekaantekening op elk gewenst moment opnieuw bewerken.';

  @override
  String get tutorialMediaTitle => 'Voeg foto\'s, audio of handschrift toe';

  @override
  String get tutorialMediaText =>
      'Gebruik + in de dagboekeditor om foto\'s, video\'s of een spraakopname toe te voegen, of om het handschriftcanvas te openen. Deze bijlagen worden bij de dagboekaantekening bewaard.';

  @override
  String get tutorialReviewTitle => 'Zoek opnieuw een dag';

  @override
  String get tutorialReviewText =>
      'Blader door uw agenda of agenda, doorzoek uw schrijfsels en organiseer vermeldingen met tags. Op de Media- en Atlas-pagina\'s kunt u eerdere inzendingen vinden op foto of locatie.';

  @override
  String get tutorialSyncTitle => 'Gebruik meer dan één apparaat';

  @override
  String get tutorialSyncText =>
      'Maak in Instellingen → Gegevens en opslag → Synchroniseren verbinding met een bestaand apparaat en bevestig de autorisatie op dat apparaat. Beide apparaten kunnen het dagboek blijven gebruiken. Dagboektekst wordt eerst gesynchroniseerd. Mediabestanden worden vervolgens gesynchroniseerd wanneer de netwerkverbinding en het resterende quotum voor gegevensoverdracht dit toestaan.';

  @override
  String get tutorialPrivacyTitle => 'Bewaar uw dagboek veilig';

  @override
  String get tutorialPrivacyText =>
      'Dagboekaantekeningen blijven op dit apparaat staan, tenzij u synchronisatie inschakelt of ze deelt of exporteert. De synchronisatie is end-to-end gecodeerd. In Instellingen kunt u ook een app-toegangscode instellen, back-ups maken en deze tutorial opnieuw openen.';

  @override
  String get editorDiaryDay => 'Dagboekdag';

  @override
  String get editorDiaryDayPicker => 'Dagboekdag · aanmaaktijd blijft';

  @override
  String get editorDiaryDayHint =>
      'De dag waarbij deze notitie hoort. Een wijziging verandert het aanmaaktijdstip niet.';

  @override
  String get hiddenDiaryTitle => 'Verborgen berichten';

  @override
  String get hiddenDiaryHide => 'Bericht verbergen';

  @override
  String get hiddenDiaryShow => 'Bericht weergeven';

  @override
  String get hiddenDiaryEmpty => 'Geen verborgen berichten';

  @override
  String get hiddenDiaryUnlock => 'Verborgen berichten ontgrendelen';

  @override
  String get hiddenDiaryAuthHint =>
      'Gebruik de appvergrendeling of schermvergrendeling van je apparaat.';

  @override
  String get hiddenDiaryLocalOnly =>
      'Verborgen berichten blijven op dit apparaat en pauzeren de synchronisatie. Gebruik versleutelde back-ups. Bestaande kopieën elders blijven ongewijzigd.';

  @override
  String get moodClear => 'Stemming wissen';
}
