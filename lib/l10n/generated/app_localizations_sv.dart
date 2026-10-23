// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => 'Tema färg';

  @override
  String get themeColorHint => 'Välj en färg för denna palett.';

  @override
  String get themeColorBlue => 'Himmelsblå';

  @override
  String get themeColorGreen => 'Skogsgrönt';

  @override
  String get themeColorBrown => 'Varmt kaffe';

  @override
  String get themeColorPurple => 'Lavendel';

  @override
  String get themeColorRose => 'Dammig ros';

  @override
  String get themeColorAmber => 'Bärnsten';

  @override
  String get themeColorPreview => 'Lite varje dag';

  @override
  String get themeTintBackgroundTitle => 'Tint bakgrunder med tema färg';

  @override
  String get themeTintBackgroundHint =>
      'Stäng av för neutral grå bakgrund; knappar behåller din valda färg.';

  @override
  String get dailyReminderTitle => 'Logga dagen!';

  @override
  String get dailyReminderDescription => 'Ta din dagliga dagboksanteckning...';

  @override
  String get actionTakePhoto => 'Ta foto';

  @override
  String get flashbacksTitle => 'Återblickar';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Uteslut dåliga dagar';

  @override
  String get flashbackGoodDay => 'En bra dag';

  @override
  String get flashbackRandomDay => 'En slumpmässig dag';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count veckor sedan',
      one: '$count vecka sedan',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count månader sedan',
      one: '$count månad sedan',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count år sedan',
      one: '$count år sedan',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'På denna dag';

  @override
  String get searchLogsHint => 'Sök i dagboksposter...';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagboksanteckningar',
      one: '$count dagboksanteckning',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagar',
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
  String get noLogs => 'Inga dagboksanteckningar...';

  @override
  String get noResults => 'Inga resultat...';

  @override
  String get sortOrderAscendingTitle => 'Stigande';

  @override
  String get sortOrderDescendingTitle => 'Fallande';

  @override
  String get pageStatisticsTitle => 'Statistik';

  @override
  String get statisticsNotEnoughData => 'Inte tillräckligt med data...';

  @override
  String get statisticsRangeOneMonth => '1 månad';

  @override
  String get statisticsRangeSixMonths => '6 månader';

  @override
  String get statisticsRangeOneYear => '1 år';

  @override
  String get statisticsRangeAllTime => 'Hela tiden';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag Sammanfattning';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag per dag';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag över tid';
  }

  @override
  String get chartGroupingLabel => 'Gruppera efter';

  @override
  String get chartGroupingDay => 'dag';

  @override
  String get chartGroupingWeek => 'Vecka';

  @override
  String get chartGroupingMonth => 'Månad';

  @override
  String get chartGroupingYear => 'år';

  @override
  String get chartSmoothingLabel => 'Utjämning';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aktuell rad $count',
      one: 'Aktuell serie $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Längsta rad $count',
      one: 'Längsta rad $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Stora dagar $count',
      one: 'Stora dagar $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dagar sedan en dålig dag $count',
      one: 'Dagar sedan en dålig dag $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Kan inte komma åt extern lagring';

  @override
  String get errorExternalStorageAccessDescription =>
      'Om du använder nätverkslagring se till att tjänsten är online och att du har nätverksåtkomst.\n\nAnnars kan appen ha förlorat behörigheter för den externa mappen. Gå till inställningar och välj den externa mappen igen för att ge åtkomst.\n\nVarning, ändringar kommer inte att synkroniseras förrän du återställer åtkomsten till den externa lagringsplatsen!';

  @override
  String get errorExternalStorageAccessContinue => 'Fortsätt med lokal databas';

  @override
  String get lastModified => 'Modifierad';

  @override
  String get writeSomethingHint => 'Skriv något...';

  @override
  String get titleHint => 'Titel...';

  @override
  String get deleteLogTitle => 'Ta bort dagboksinlägg';

  @override
  String get deleteLogDescription =>
      'Posten flyttas till Nyligen raderad, där du kan återställa den.';

  @override
  String get deletePhotoTitle => 'Ta bort bilaga';

  @override
  String get deletePhotoDescription =>
      'Är du säker på att du vill ta bort den här bilagan?';

  @override
  String get pageSettingsTitle => 'Inställningar';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Ljus';

  @override
  String get themeDark => 'Mörkt';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Veckans första dag';

  @override
  String get settingsCalendarSystem => 'Kalendersystem';

  @override
  String get calendarSystemGregorian => 'gregoriansk';

  @override
  String get calendarSystemJalali => 'Jalali';

  @override
  String get settingsUseSystemAccentColor => 'Använd System Accent Color';

  @override
  String get settingsCustomAccentColor => 'Anpassad accentfärg';

  @override
  String get settingsShowFlashbacks => 'Visa tillbakablickar';

  @override
  String get settingsChangeMoodIcons => 'Ändra humör ikoner';

  @override
  String get moodIconPrompt => 'Ange en ikon';

  @override
  String get settingsHideImages => 'Dölj bilder';

  @override
  String get pageCalendarTitle => 'Kalender';

  @override
  String get settingsNotificationsTitle => 'Aviseringar';

  @override
  String get settingsDailyReminderTitle => 'Daglig påminnelse';

  @override
  String get settingsOnThisDayDescription => 'Återbesök tidigare minnen';

  @override
  String get settingsDailyReminderDescription => 'En mild påminnelse varje dag';

  @override
  String get settingsReminderTime => 'Påminnelsetid';

  @override
  String get settingsFixedReminderTimeTitle => 'Fast påminnelsetid';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Välj en fast tid för påminnelsen';

  @override
  String get settingsAlwaysSendReminderTitle => 'Skicka alltid påminnelse';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Skicka påminnelse även om en dagboksanteckning redan har påbörjats';

  @override
  String get settingsCustomizeNotificationTitle => 'Anpassa aviseringar';

  @override
  String get settingsTemplatesTitle => 'Mallar';

  @override
  String get manageTemplates => 'Hantera mallar';

  @override
  String get noTemplateTitle => 'Inga';

  @override
  String get noTemplatesDescription => 'Inga mallar har skapats ännu...';

  @override
  String get templateDefaultTimestampTitle => 'Tidsstämpel';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Dagens sammanfattning';

  @override
  String get templateDefaultSummaryBody =>
      '### Sammanfattning\n- \n\n### Citat\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Reflektion';

  @override
  String get templateDefaultReflectionBody =>
      '### Vad tyckte du om idag?\n- \n\n### Vad är du tacksam för?\n- \n\n### Vad ser du fram emot?\n- ';

  @override
  String get settingsTagsTitle => 'Taggar';

  @override
  String get manageTags => 'Hantera taggar';

  @override
  String get tagTypeLabelTitle => 'Etikett';

  @override
  String get tagTypeTrackerTitle => 'Spårare';

  @override
  String get nameHint => 'Namn';

  @override
  String get tagColorLabel => 'Färg';

  @override
  String get iconPickerTitle => 'Välj ikon';

  @override
  String get iconPickerIconsTab => 'Ikoner';

  @override
  String get iconPickerCustomTab => 'Anpassad';

  @override
  String get iconPickerSearchHint => 'Sökikoner...';

  @override
  String get colorPickerTitle => 'Välj Färg';

  @override
  String get colorPickerPaletteTab => 'Färger';

  @override
  String get iconGroupMoodPeople => 'Humör & Människor';

  @override
  String get iconGroupHealth => 'Hälsa';

  @override
  String get iconGroupWorkFinance => 'Arbete & Ekonomi';

  @override
  String get iconGroupHabitsGoals => 'Vanor & mål';

  @override
  String get iconGroupNature => 'Naturen';

  @override
  String get iconGroupFoodDrink => 'Mat & Dryck';

  @override
  String get iconGroupHome => 'Hem';

  @override
  String get iconGroupTravel => 'Resor';

  @override
  String get iconGroupSymbols => 'Symboler';

  @override
  String get tagCategoryLabel => 'Kategori';

  @override
  String get tagLabel => 'Tagga';

  @override
  String get tagCategoryUncategorized => 'Okategoriserad';

  @override
  String get newCategoryTitle => 'Ny kategori';

  @override
  String get shareButtonLabel => 'Dela';

  @override
  String get importErrorDescription => 'Det gick inte att importera filen!';

  @override
  String get exportErrorDescription => 'Det gick inte att exportera filen!';

  @override
  String get deleteTitle => 'Ta bort';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Den används i $count dagboksanteckningar.',
      one: ' Den används i $count dagboksanteckning.',
      zero: '',
    );
    return 'Ta bort \"$name\"?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Dess $count-taggar kommer också att raderas.',
      one: ' Dess $count-tagg kommer också att raderas.',
      zero: '',
    );
    return 'Ta bort \"$name\"?$_temp0';
  }

  @override
  String get tagNameExists => 'Det finns redan en tagg med detta namn';

  @override
  String get categoryNameExists => 'Det finns redan en kategori med detta namn';

  @override
  String deleteTemplateMessage(Object name) {
    return 'Ta bort \"$name\"?';
  }

  @override
  String get addTagsTitle => 'Lägg till taggar';

  @override
  String get addTagsSearchHint => 'Sök taggar...';

  @override
  String get tagPickerSortManualLabel => 'Manuell beställning';

  @override
  String get tagPickerSortUsageLabel => 'Sortera efter användning';

  @override
  String get tagFavoriteName => 'Favorit';

  @override
  String get tagEnergyName => 'Energi';

  @override
  String get tagCategoryActivitiesName => 'Aktiviteter';

  @override
  String get tagExerciseName => 'Träning';

  @override
  String get tagSocializingName => 'Umgås';

  @override
  String get tagHobbyName => 'Hobby';

  @override
  String get tagEntertainmentName => 'Underhållning';

  @override
  String get tagDiningName => 'Matsal';

  @override
  String get tagChoresName => 'Sysslor';

  @override
  String get tagCategoryEmotionsName => 'Känslor';

  @override
  String get tagExcitedName => 'Upphetsad';

  @override
  String get tagGratefulName => 'Tacksam';

  @override
  String get tagCalmName => 'Lugn';

  @override
  String get tagTiredName => 'Trött';

  @override
  String get tagAnxiousName => 'Orolig';

  @override
  String get tagAnnoyedName => 'Irriterad';

  @override
  String get settingsStorageTitle => 'Förvaring';

  @override
  String get settingsImageQuality => 'Bildkvalitet';

  @override
  String get imageQualityHigh => 'Hög';

  @override
  String get imageQualityMedium => 'Medium';

  @override
  String get imageQualityLow => 'Låg';

  @override
  String get imageQualityNoCompression => 'Ingen kompression';

  @override
  String get settingsLogFolder => 'dagboksanteckning Mapp';

  @override
  String get settingsImageFolder => 'Bildmapp';

  @override
  String get warningTitle => 'Varning';

  @override
  String get logFolderWarningDescription =>
      'Om den valda mappen redan innehåller en \'aid_diary.db\'-fil, kommer den att användas för att skriva över dina befintliga dagboksposter!';

  @override
  String get errorTitle => 'Fel';

  @override
  String get logFolderErrorDescription =>
      'Det gick inte att ändra dagbokspostmapp!';

  @override
  String get imageFolderErrorDescription => 'Det gick inte att ändra bildmapp!';

  @override
  String get backupErrorDescription =>
      'Det gick inte att skapa säkerhetskopia!';

  @override
  String get restoreErrorDescription =>
      'Det gick inte att återställa säkerhetskopian!';

  @override
  String get settingsBackupRestoreTitle => 'Säkerhetskopiera och återställa';

  @override
  String get settingsBackup => 'Säkerhetskopiering';

  @override
  String get settingsRestore => 'Återställ';

  @override
  String get settingsRestorePromptDescription =>
      'Att återställa en säkerhetskopia kommer att skriva över dina befintliga data!';

  @override
  String get settingsBackupPasswordProtect =>
      'Lösenordsskyddade säkerhetskopior';

  @override
  String get backupEncryptedTitle => 'Krypterad säkerhetskopiering';

  @override
  String get backupEncryptedContent =>
      'Denna säkerhetskopia är lösenordsskyddad.';

  @override
  String get settingsAutoBackup => 'Automatiska säkerhetskopieringar';

  @override
  String get settingsAutoBackupLocation => 'Säkerhetskopieringsplats';

  @override
  String get settingsAutoBackupInterval => 'Backup intervall';

  @override
  String get settingsAutoBackupIntervalDaily => 'Dagligen';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Varje vecka';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Månadsvis';

  @override
  String get settingsAutoBackupMaxCount => 'Säkerhetskopieringar att behålla';

  @override
  String get settingsAutoBackupRequireCharging => 'Endast under laddning';

  @override
  String settingsBackupLast(Object time) {
    return 'Senaste säkerhetskopian $time';
  }

  @override
  String get settingsBackupNever => 'Aldrig säkerhetskopierat';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Nästa säkerhetskopia $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'Alla';

  @override
  String get autoBackupFailedTitle => 'Säkerhetskopieringen misslyckades';

  @override
  String tranferStatus(Object percent) {
    return 'Överför... $percent %';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Skapar säkerhetskopia... $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Återställer säkerhetskopia... $percent%';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return 'Krypterar säkerhetskopia... $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Dekrypterar säkerhetskopia... $percent%';
  }

  @override
  String get cleanUpStatus => 'Städar upp...';

  @override
  String get settingsExportToAnotherFormat => 'Exportera till ett annat format';

  @override
  String get settingsExportFormatDescription =>
      'Detta bör inte användas som backup!';

  @override
  String get settingsImportFromAnotherApp => 'Importera från en annan app';

  @override
  String get logFormatTitle => 'Välj Format';

  @override
  String get logFormatDescription =>
      'En annan app format kanske inte stöder alla funktioner. Vänligen rapportera eventuella problem eftersom tredje parts format kan ändras när som helst. Detta påverkar inte befintliga dagboksanteckningar!';

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
  String get settingsDeleteAllLogsTitle => 'Ta bort alla dagboksposter';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Vill du radera alla dina dagboksanteckningar?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Ange \'$prompt\' för att bekräfta. Detta kan inte ångras!';
  }

  @override
  String get settingsLanguageTitle => 'Språk';

  @override
  String get settingsAppLanguageTitle => 'Appens språk';

  @override
  String get settingsOverrideAppLanguageTitle => 'Åsidosätt appspråk';

  @override
  String get settingsSecurityTitle => 'Säkerhet';

  @override
  String get settingsSecurityRequirePassword => 'Kräv lösenord';

  @override
  String get settingsSecurityEnterPassword => 'Ange lösenord';

  @override
  String get settingsSecuritySetPassword => 'Ange lösenord';

  @override
  String get settingsSecurityChangePassword => 'Ändra lösenord';

  @override
  String get settingsSecurityPassword => 'Lösenord';

  @override
  String get settingsSecurityConfirmPassword => 'Bekräfta lösenord';

  @override
  String get settingsSecurityOldPassword => 'Gammalt lösenord';

  @override
  String get settingsSecurityIncorrectPassword => 'Felaktigt lösenord';

  @override
  String get settingsSecurityPasswordsDoNotMatch =>
      'Lösenord stämmer inte överens';

  @override
  String get requiredPrompt => 'Obligatoriskt';

  @override
  String get settingsSecurityBiometricUnlock => 'Biometrisk upplåsning';

  @override
  String get unlockAppPrompt => 'Lås upp appen';

  @override
  String get settingsAboutTitle => 'Om';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsLicense => 'Licens';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsOpenSourceLicenses => 'Licenser med öppen källkod';

  @override
  String get tagMoodTitle => 'Humör';

  @override
  String get selectTagTitle => 'Välj Tag';

  @override
  String get labelPresentLabel => 'Närvarande';

  @override
  String get labelAbsentLabel => 'Frånvarande';

  @override
  String get labelCoverageLabel => 'Täckning';

  @override
  String chartDistributionTitle(Object tag) {
    return '$tag Distribution';
  }

  @override
  String get shareAddToLogPickerTitle => 'Välj en dagboksanteckning';

  @override
  String get adaptiveEmptyDay => 'Inga anmälningar för denna dag än';

  @override
  String get adaptiveNewEntry => 'Skriv ett inlägg';

  @override
  String get pageJournalTitle => 'Dagbok';

  @override
  String get coachPrompt1 => 'Vad fick dig att le idag?';

  @override
  String get coachPrompt2 => 'Vad är en sak du lärde dig idag?';

  @override
  String get coachPrompt3 => 'Vem pratade du med idag och hur kändes det?';

  @override
  String get coachPrompt4 => 'Vad är du tacksam för just nu?';

  @override
  String get coachPrompt5 => 'Vad tog mest av din energi idag?';

  @override
  String get coachPrompt6 => 'Beskriv ett litet ögonblick du vill minnas.';

  @override
  String get coachPrompt7 => 'Vad skulle göra morgondagen till en bra dag?';

  @override
  String get coachPrompt8 => 'Vad har du tänkt på den senaste tiden?';

  @override
  String get coachPrompt9 => 'Vad gjorde du idag bara för dig själv?';

  @override
  String get coachPrompt10 => 'Om idag hade en titel, vad skulle det vara?';

  @override
  String get pageMediaTitle => 'Medier';

  @override
  String get pageAtlasTitle => 'Atlas';

  @override
  String get pageCoachTitle => 'Coach';

  @override
  String get noEntrySelected => 'Ingen post har valts.';

  @override
  String get entryShare => 'Dela';

  @override
  String get entryFavorite => 'Stjärna';

  @override
  String get entryEdit => 'Redigera';

  @override
  String get entryPrevious => 'Tidigare inlägg';

  @override
  String get entryNext => 'Nästa inlägg';

  @override
  String get journalStories => 'Berättelser';

  @override
  String get journalEntries => 'Inlägg';

  @override
  String get journalEmptyHint =>
      'Börja din dagbok genom att lägga till en ny post.';

  @override
  String get storyToday => 'Idag';

  @override
  String get storyThrowback => 'Tillbakablick';

  @override
  String get storyNoThrowback => 'Ingen återgång idag';

  @override
  String get mediaFiles => 'Mediafiler';

  @override
  String get mediaEmpty => 'Inga foton än.';

  @override
  String get mediaEmptyHint => 'Foton som bifogas bidrag kommer att visas här.';

  @override
  String get atlasEmpty => 'Inga poster med en plats.';

  @override
  String get atlasEmptyHint => 'Poster med en plats kommer att visas här.';

  @override
  String get atlasShowAll => 'Visa alla poster';

  @override
  String get atlasMyLocation => 'Min plats';

  @override
  String get coachAll => 'Alla';

  @override
  String get coachPrograms => 'Program';

  @override
  String get coachTemplates => 'Mallar';

  @override
  String get coachKindProgram => 'Program';

  @override
  String get coachKindTemplate => 'Mall';

  @override
  String get coachNoTemplates => 'Inga program eller mallar.';

  @override
  String get coachUseTemplate => 'Skriv med denna mall';

  @override
  String get coachProgramEverydayTitle => 'Vardagliga stunder';

  @override
  String get coachProgramEverydayDescription =>
      'Fem korta frågor, en om dagen. Varje tar en minut eller två och hjälper dig att se vad som gjorde dagen till din. Ett skonsamt sätt att bygga upp vanan att skriva lite varje dag.';

  @override
  String get coachProgramReflectTitle => 'Tittar inåt';

  @override
  String get coachProgramReflectDescription =>
      'En djupare fråga i veckan, i fem veckor. Ta dig tid med var och en: hur du har mått, vad sliter ut dig, vad du är tacksam för.';

  @override
  String get searchFilters => 'Filter';

  @override
  String get searchFilterTags => 'Taggar';

  @override
  String get searchFilterStarred => 'Stjärnmärkt';

  @override
  String get searchHint => 'Skriv för att söka eller välj ett filter.';

  @override
  String get locationTitle => 'Plats';

  @override
  String get locationName => 'Ortsnamn';

  @override
  String get locationRemove => 'Ta bort';

  @override
  String get locationServiceDisabled => 'Platstjänster är avstängda.';

  @override
  String get locationPermissionDenied => 'Platstillstånd nekades.';

  @override
  String get locationUnavailable =>
      'Det gick inte att hämta den aktuella platsen.';

  @override
  String get calendarJumpToToday => 'Hoppa till idag';

  @override
  String get editorStartWriting => 'Börja skriva eller välj ett ';

  @override
  String get editorTemplateLink => 'Mall';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Välj en mall';

  @override
  String get templateFeatured => 'Utvalda mallar';

  @override
  String get templateMine => 'Mina mallar';

  @override
  String get templateDailyName => 'Daglig genomgång';

  @override
  String get templateDailyDescription =>
      'Vad hände, hur det kändes och vad som kommer härnäst.';

  @override
  String get templateDailyText =>
      '## Vad hände idag\n\n\n## Hur jag kände mig\n\n\n## Tre saker jag är tacksam för\n1. \n2. \n3. \n\n## Imorgon\n';

  @override
  String get templateTravelName => 'Resedagboksanteckning';

  @override
  String get templateTravelDescription =>
      'Platser, stunder och mat från vägen.';

  @override
  String get templateTravelText =>
      '## Vart jag gick\n\n\n## Det ögonblick jag minns mest\n\n\n## Vad jag åt\n\n\n## Planer för morgondagen\n';

  @override
  String get templateReadingName => 'Läser anteckningar';

  @override
  String get templateReadingDescription =>
      'Citat och tankar från det du läser.';

  @override
  String get templateReadingText =>
      '## Bok\n\n\n## Där jag är\n\n\n## Citat\n> \n\n## Mina tankar\n';

  @override
  String get templateWeeklyName => 'Veckoöversyn';

  @override
  String get templateWeeklyDescription =>
      'Höjdpunkter, kämpar och nästa veckas fokus.';

  @override
  String get templateWeeklyText =>
      '## Höjdpunkter\n\n\n## Vad var svårt\n\n\n## Vad jag lärde mig\n\n\n## Fokus för nästa vecka\n';

  @override
  String get entryDuplicate => 'Duplicera';

  @override
  String get entryDuplicated => 'Posten duplicerad';

  @override
  String get entrySaveAsTemplate => 'Spara som mall';

  @override
  String get entrySavedAsTemplate => 'Sparad som mall';

  @override
  String get storyStatistics => 'Statistik';

  @override
  String get storyMoodChart => 'Humördiagram';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return '$entries-poster · $days dagar';
  }

  @override
  String get storyThisYear => 'I år';

  @override
  String get storyLastYear => 'Förra året';

  @override
  String get storyTapToOpen => 'Tryck på en dag för att öppna den';

  @override
  String get settingsGeneralTitle => 'Allmänt';

  @override
  String get settingsDataTitle => 'Data & lagring';

  @override
  String get settingsStoriesTitle => 'Berättelser';

  @override
  String get settingsHelpTitle => 'Hjälp & om';

  @override
  String get weatherTitle => 'Väder';

  @override
  String get weatherClear => 'Rensa';

  @override
  String get weatherPartlyCloudy => 'Delvis molnigt';

  @override
  String get weatherCloudy => 'Molnigt';

  @override
  String get weatherFog => 'Dimma';

  @override
  String get weatherDrizzle => 'Duggregn';

  @override
  String get weatherRain => 'Regn';

  @override
  String get weatherSnow => 'Snö';

  @override
  String get weatherStorm => 'Åskväder';

  @override
  String get weatherFetch => 'Få väder för detta inlägg';

  @override
  String get weatherNeedsLocation =>
      'Lägg till en plats med koordinater först.';

  @override
  String get weatherUnavailable =>
      'Vädret är inte tillgängligt för denna plats och tid.';

  @override
  String get weatherRemove => 'Ta bort väder';

  @override
  String get activityTitle => 'Aktivitet';

  @override
  String get activityStill => 'Ändå';

  @override
  String get activityWalking => 'Promenader';

  @override
  String get activityRunning => 'Löpning';

  @override
  String get activityCycling => 'Cykling';

  @override
  String get activityVehicle => 'I ett fordon';

  @override
  String get activityFlying => 'Flygande';

  @override
  String get activityExercise => 'Träning';

  @override
  String get activityDetect => 'Upptäck aktuell aktivitet';

  @override
  String get activityDetectFailed => 'Det gick inte att upptäcka en aktivitet.';

  @override
  String get activityRemove => 'Ta bort aktivitet';

  @override
  String get settingsAutoAddTitle => 'Lägg till automatiskt';

  @override
  String get settingsAutoAddLocation => 'Plats';

  @override
  String get settingsAutoAddWeather => 'Väder';

  @override
  String get settingsAutoAddHint =>
      'Nya poster får dessa ifyllda när de skapas.';

  @override
  String get settingsTemperatureUnit => 'Temperaturenhet';

  @override
  String get settingsCelsius => 'Celsius (°C)';

  @override
  String get settingsFahrenheit => 'Fahrenheit (°F)';

  @override
  String get moodGreat => 'Bra';

  @override
  String get moodGood => 'Bra';

  @override
  String get moodOkay => 'Okej';

  @override
  String get moodBad => 'Dåligt';

  @override
  String get moodAwful => 'Hemskt';

  @override
  String get locationSearchHint => 'Sök efter en plats';

  @override
  String get locationSearchEmpty => 'Inga platser hittades';

  @override
  String get settingsWallpaper => 'Bakgrund';

  @override
  String get wallpaperNone => 'Inga';

  @override
  String get wallpaperDots => 'Prickar';

  @override
  String get wallpaperGrid => 'Grid';

  @override
  String get wallpaperLines => 'Linjer';

  @override
  String get wallpaperPhoto => 'Foto...';

  @override
  String get settingsFontFamily => 'Teckensnitt';

  @override
  String get fontSystem => 'System';

  @override
  String get fontSerif => 'Serif';

  @override
  String get fontMono => 'Monospace';

  @override
  String get settingsFontSize => 'Teckenstorlek';

  @override
  String get fontSizeSmall => 'Liten';

  @override
  String get fontSizeMedium => 'Medium';

  @override
  String get fontSizeLarge => 'Stora';

  @override
  String get fontSizeExtraLarge => 'Extra stor';

  @override
  String get settingsLineSpacing => 'Radavstånd';

  @override
  String get lineSpacingCompact => 'Kompakt';

  @override
  String get lineSpacingNormal => 'Normal';

  @override
  String get lineSpacingRelaxed => 'Avslappnad';

  @override
  String get moodAssociationsTitle => 'Vad får mig att känna...';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching av $total-poster';
  }

  @override
  String get videoRecord => 'Spela in en video';

  @override
  String get videoChoose => 'Välj en video';

  @override
  String get audioRecordTitle => 'Spela in en röstanteckning';

  @override
  String get audioChoose => 'Välj en ljudfil';

  @override
  String get audioStart => 'Spela in';

  @override
  String get audioStop => 'Stanna och spara';

  @override
  String get audioPermissionDenied =>
      'Mikrofonåtkomst är avstängd. Tillåt det i systeminställningarna.';

  @override
  String get mediaTooLarge => 'Den här videon är för stor för att bifoga.';

  @override
  String get mediaUnavailable =>
      'Den här bilagan är inte tillgänglig på den här enheten.';

  @override
  String get widgetDone => 'Dagens inlägg är skrivet';

  @override
  String get widgetPending => 'Hur var din dag?';

  @override
  String get widgetWrite => 'Skriv';

  @override
  String get insertChecklist => 'Checklista';

  @override
  String get insertNumberedList => 'Numrerad lista';

  @override
  String get insertTable => 'Tabell';

  @override
  String get insertDivider => 'Avdelare';

  @override
  String get insertCodeBlock => 'Kodblock';

  @override
  String get journalSortTitle => 'Sortera poster';

  @override
  String get journalSortUpdated => 'Senast uppdaterad';

  @override
  String get settingsTimeFormat => 'Tidsformat';

  @override
  String get settingsDayStart => 'Nya anmälningar räknas för dagen innan t.o.m';

  @override
  String get settingsDayAskUntil => 'Fråga sedan vilken dag fram till';

  @override
  String get settingsDayStartMidnight => 'Av';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Varje post behåller dagen den tillhör bredvid tiden den skrevs, och du kan ändra den dagen i editorn när som helst. Dessa timmar väljer bara dagen för nya poster, så om du ändrar dem flyttas ingen befintlig post.';

  @override
  String get lateNightBadge =>
      'Skrivet sent på kvällen, räknat för dagen innan';

  @override
  String editorDayAsk(String time) {
    return 'Skrivet på $time. Vilken dag är det för?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (igår)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (idag)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'Skrivet $when';
  }

  @override
  String get timeFormat12 => '12 timmar';

  @override
  String get timeFormat24 => '24 timmar om dygnet';

  @override
  String get settingsReminderDays => 'Påminn mig om';

  @override
  String get locationRecent => 'Senaste platserna';

  @override
  String get shareImage => 'Dela bild';

  @override
  String get shareSaveImage => 'Spara bild';

  @override
  String get shareSaved => 'Bilden sparad';

  @override
  String get deletedTitle => 'Nyligen raderad';

  @override
  String get deletedNone => 'Inget har raderats nyligen';

  @override
  String deletedHint(int days) {
    return 'Raderade poster stannar här i $days dagar och raderas sedan.';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days dagar kvar';
  }

  @override
  String get deletedRestore => 'Återställ';

  @override
  String get deletedDeleteForever => 'Ta bort för alltid';

  @override
  String get deletedDeleteForeverDescription =>
      'Posten och dess bilagor raderas. Detta kan inte ångras.';

  @override
  String get deletedEmpty => 'Tom';

  @override
  String get deletedEmptyDescription =>
      'Radera varje post i Nyligen raderad? Detta kan inte ångras.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Slumpmässig promenad';

  @override
  String get randomSubtitle => 'Öppna en tidigare post';

  @override
  String get randomNext => 'En annan';

  @override
  String get randomAll => 'Alla';

  @override
  String get randomWithPhotos => 'Med foton';

  @override
  String get randomGoodDays => 'Bra dagar';

  @override
  String get randomEmpty => 'Inga poster att välja på';

  @override
  String get reviewWeekTitle => 'Denna vecka';

  @override
  String get reviewWeekSubtitle => 'Din vecka hittills';

  @override
  String get reviewYearTitle => 'I år';

  @override
  String get reviewEmpty => 'Inget skrivet ännu';

  @override
  String get reviewEntries => 'Inlägg';

  @override
  String get reviewDaysWritten => 'Dagar skrivna';

  @override
  String get reviewWords => 'Ord';

  @override
  String get reviewPhotos => 'Foton';

  @override
  String get reviewLongestRun => 'Längsta loppet av dagar';

  @override
  String get reviewAverageMood => 'Genomsnittligt humör';

  @override
  String get reviewFavorites => 'Oftast';

  @override
  String get reviewByMonth => 'Efter månad';

  @override
  String get reviewHighlight => 'Markera';

  @override
  String get yearInPixels => 'År i pixlar';

  @override
  String get capsuleSeal => 'Försegla som en tidskapsel';

  @override
  String get capsuleTitle => 'Tidskapsel';

  @override
  String capsuleOpensOn(Object date) {
    return 'Öppnar på $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Skrivet på $date';
  }

  @override
  String get capsuleOpenEarly => 'Öppet tidigt';

  @override
  String get capsuleOpenEarlyDescription =>
      'Kapseln öppnas nu och förblir öppen.';

  @override
  String get capsuleOpened => 'Tidskapsel öppnad';

  @override
  String get templateMorningName => 'Morgonsidor';

  @override
  String get templateMorningDescription => 'Ställ in dagen på tre minuter';

  @override
  String get templateMorningText =>
      '## Tre saker jag vill göra bra idag\n1. \n2. \n3. \n\n## Något jag ser fram emot\n\n## En anteckning till mig själv\n';

  @override
  String get templateEveningName => 'Kvällsrecension';

  @override
  String get templateEveningDescription => 'Avsluta dagen med vad som gick bra';

  @override
  String get templateEveningText =>
      '## Tre bra saker idag\n1. \n2. \n3. \n\n## Vad jag lärde mig\n\n## Vad kan gå bättre imorgon\n';

  @override
  String get routineMorning => 'God morgon';

  @override
  String get routineEvening => 'Kvällsrecension';

  @override
  String get settingsRoutinePrompts => 'Uppmaningar morgon och kväll';

  @override
  String get settingsRoutinePromptsHint =>
      'Föreslå morgon- eller kvällsmallen i Stories';

  @override
  String get checkInTitle => 'Snabb incheckning';

  @override
  String get checkInSubtitle => 'Humör i två tryck';

  @override
  String get checkInMood => 'Hur känner du dig?';

  @override
  String get checkInActivity => 'Vad gör du?';

  @override
  String get checkInNote => 'En rad om det (valfritt)';

  @override
  String get checkInSave => 'Spara';

  @override
  String editorWordCount(int words, int characters) {
    return '$words ord · $characters tecken';
  }

  @override
  String get coachProgramEverydayTagline =>
      'Lägg märke till de små sakerna på en dag.';

  @override
  String get coachProgramReflectTagline => 'Sakta ner och lyssna på dig själv.';

  @override
  String get coachDuration => 'Varaktighet';

  @override
  String get coachInterval => 'Intervall';

  @override
  String get coachDifficulty => 'Svårighet';

  @override
  String get coachIntervalDaily => 'Dagligen';

  @override
  String get coachIntervalWeekly => 'Varje vecka';

  @override
  String get coachDifficultyBeginner => 'Nybörjare';

  @override
  String get coachDifficultyIntermediate => 'Mellanliggande';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagar',
      one: '$count dag',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count veckor',
      one: '$count vecka',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'Dag $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Vecka $n';
  }

  @override
  String get coachEnroll => 'Anmäl dig';

  @override
  String get coachEndProgram => 'Avsluta programmet';

  @override
  String get coachAuthor => 'Författare';

  @override
  String get coachAuthorBio => 'Uppmaningar skrivna för den här appen.';

  @override
  String get coachEnrolledTip =>
      'Allt klart! Dina frågor kommer att dyka upp i Stories.';

  @override
  String get coachGoToStories => 'Gå till Stories';

  @override
  String get coachAnswerHint => 'Skriv ditt svar...';

  @override
  String get storyWrapUp => 'Det var allt för idag.';

  @override
  String get storyTapToClose => 'Tryck för att stänga';

  @override
  String get coachAnswerDone => 'Klart';

  @override
  String get coachAnswered => 'Besvarade, tryck för att öppna';

  @override
  String get coachAnsweredEarlier => 'Svarade';

  @override
  String get locationLocating => 'Hittar...';

  @override
  String get locationPickPlace => 'Välj en plats';

  @override
  String get locationPlacesHint => 'Adress eller namn på platsen';

  @override
  String get locationCustom => 'Anpassad plats';

  @override
  String get locationCurrent => 'Nuvarande plats';

  @override
  String get locationSaved => 'Sparade platser';

  @override
  String get locationSearchResults => 'Sökresultat';

  @override
  String get locationNearby => 'Närliggande platser';

  @override
  String get locationRename => 'Byt namn';

  @override
  String get locationSavePlace => 'Spara plats';

  @override
  String get locationUnsavePlace => 'Ta bort från sparade platser';

  @override
  String get shareAs => 'Dela som...';

  @override
  String get shareAsImage => 'Bild';

  @override
  String get shareAsZip => 'ZIP med originalmediet';

  @override
  String get shareAsPlainText => 'Vanlig text';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Välkommen till AID Diary';

  @override
  String get onboardWelcomeText =>
      'Börja här eller anslut den här enheten till en du redan använder.';

  @override
  String get onboardStart => 'Börja skriva';

  @override
  String get helpFaq => 'Vanliga frågor';

  @override
  String get helpFaq1Q => 'Var förvaras min dagbok?';

  @override
  String get helpFaq1A =>
      'Din dagbok lagras på den här enheten. Den når andra enheter eller lagring endast när du aktiverar synkronisering, dela eller exportera den. Synkronisering är krypterad från ände till ände.';

  @override
  String get helpFaq2Q =>
      'Hur behåller jag en kopia eller flyttar till en ny enhet?';

  @override
  String get helpFaq2A =>
      'Anslut till en befintlig enhet i Inställningar → Data & lagring → Synkronisera och bekräfta auktorisering på enheten som har din dagbok. Båda enheterna förblir användbara. Du kan också skapa en säkerhetskopia och återställa den på en annan enhet.';

  @override
  String get helpFaq3Q => 'Kan jag ta in poster från andra dagboksappar?';

  @override
  String get helpFaq3A =>
      'Ja: i Inställningar → Data & lagring, importera exporter från Daylio, Diarium, Diaro, DayBook, My Brain, OneShot och Pixels, eller en JSON-export.';

  @override
  String get helpFaq4Q => 'Hur fungerar coachprogram?';

  @override
  String get helpFaq4A =>
      'Anmäl dig till ett program på Coach-sidan. Varje dag eller vecka väntar en ny fråga i Stories; ditt svar sparas som en post.';

  @override
  String get helpFaq5Q => 'Vad händer om jag glömmer mitt lösenord?';

  @override
  String get helpFaq5A =>
      'Lösenordet kan inte återställas, så behåll en säkerhetskopia av din dagbok.';

  @override
  String get helpPrivacy => 'Sekretess';

  @override
  String get helpPrivacyText =>
      'Dagboksinnehåll och media finns kvar på den här enheten om du inte aktiverar krypterad synkronisering eller delar/exporterar dem. Kartor, platssökning och väder använder de konfigurerade tjänsterna och skickar platsen eller sökfrågan som behövs för den begäran, inte dagbokstext.';

  @override
  String get photoMetaTitle => 'Använd fotots detaljer?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Räkna den här posten för $date och ställ in dess plats på $place, enligt bilden?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Räkna denna post för $date, när bilden togs?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Ställ in denna posts plats till $place, var bilden togs?';
  }

  @override
  String get photoMetaApply => 'Använd dem';

  @override
  String get quickWriteTitle => 'Skriv snabbt';

  @override
  String get quickWriteText => 'Tryck för att starta en ny post.';

  @override
  String get settingsQuickWriteTitle => 'Skriv snabbt i aviseringar';

  @override
  String get settingsQuickWriteDescription =>
      'Behåll en avisering som öppnar en ny post.';

  @override
  String get settingsNudgesTitle => 'Knuffa mig efter en lugn sträcka';

  @override
  String settingsNudgesDescription(int days) {
    return 'En mild påminnelse när du inte har skrivit på $days dagar.';
  }

  @override
  String get nudgeTitle => 'Det var ett tag sedan';

  @override
  String get nudgeMonday => 'En ny vecka: vad ser du fram emot?';

  @override
  String get nudgeTuesday => 'Två rader räcker. Hur mår du idag?';

  @override
  String get nudgeWednesday => 'Halvvägs i veckan. Vad stack ut så här långt?';

  @override
  String get nudgeThursday => 'Något litet värt att behålla från idag?';

  @override
  String get nudgeFriday =>
      'Veckan går mot sitt slut. Notera ett bra ögonblick.';

  @override
  String get nudgeSaturday => 'En långsam lördag är en bra dag att skriva.';

  @override
  String get nudgeSunday => 'Se tillbaka på veckan innan den tar slut.';

  @override
  String get photoWidgetEmpty => 'Foton du lägger till i poster visas här.';

  @override
  String get channelReminders => 'Påminnelser';

  @override
  String get channelOnThisDay => 'På denna dag';

  @override
  String get channelCoach => 'Coach uppmaningar';

  @override
  String get channelNudges => 'Knuffar efter lugna dagar';

  @override
  String get channelQuickWrite => 'Skriv snabbt';

  @override
  String get channelBackup => 'Säkerhetskopieringar';

  @override
  String get formatJsonExport => 'JSON (export från AID Diary)';

  @override
  String get aboutModifiedNotice =>
      'En modifierad version av Daily You av Demizo och bidragsgivare. Det är inte den officiella Daily You-appen.';

  @override
  String get toolbarPhotos => 'Lägg till foton';

  @override
  String get toolbarMedia => 'Foton och videor';

  @override
  String get mediaFromGallery => 'Välj från galleri';

  @override
  String get mediaFromFiles => 'Välj bland filer';

  @override
  String get editorLeaveTitle => 'Spara denna post?';

  @override
  String get editorLeaveDiscard => 'Spara inte';

  @override
  String get editorTitleHint => 'Titel';

  @override
  String get editorLocating => 'Hittar...';

  @override
  String get toolbarVideo => 'Video';

  @override
  String get toolbarAudio => 'Röstanteckning';

  @override
  String get toolbarTags => 'Taggar';

  @override
  String get toolbarBulletList => 'Punktlista';

  @override
  String get toolbarHeading => 'Rubrik';

  @override
  String get toolbarBold => 'Fet';

  @override
  String get toolbarItalic => 'Kursiv';

  @override
  String get toolbarHighlight => 'Markera';

  @override
  String get toolbarStrikethrough => 'Genomstruken';

  @override
  String get toolbarQuote => 'Citat';

  @override
  String get toolbarLink => 'Länk';

  @override
  String get toolbarInsert => 'Sätt in';

  @override
  String get toolbarUndo => 'Ångra';

  @override
  String get toolbarRedo => 'Gör om';

  @override
  String get toolbarInsertDate => 'Sätt in datumet';

  @override
  String get toolbarInsertTime => 'Sätt in tiden';

  @override
  String get settingsSyncTitle => 'Molnsynkronisering';

  @override
  String get syncOffDescription =>
      'Håll den här dagboken likadan på alla dina enheter via Google Drive eller en WebDAV-server, som Nextcloud, Synology eller Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'Synkronisera med Google Drive';

  @override
  String get syncOrWebDav => 'Eller en WebDAV-server';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn =>
      'Inloggad. Du kan gå tillbaka till AID Diary.';

  @override
  String get syncGoogleSignInAgain => 'Google kräver att du loggar in igen.';

  @override
  String get syncSignInAgain => 'Logga in igen';

  @override
  String get settingsCommandLineTitle => 'Kommandorad';

  @override
  String get commandLineToggle => 'Kommandoradsgränssnitt';

  @override
  String get commandLineToggleHint =>
      'Låter hjälpkommandot och andra program på den här enheten använda appens kommandon.';

  @override
  String get commandLineAlwaysOn => 'Alltid på i utvecklingsbyggen.';

  @override
  String commandLineListening(int port) {
    return 'Lyssnar på port $port';
  }

  @override
  String get commandPaletteTitle => 'Alla kommandon';

  @override
  String get commandPaletteSearch => 'Sökkommandon';

  @override
  String get commandPaletteRun => 'Kör';

  @override
  String get commandPaletteConfirm => 'Detta kan inte bara ångras. Kör den?';

  @override
  String syncReceiving(int done, int total) {
    return 'Tar emot $done av $total...';
  }

  @override
  String syncSending(int done, int total) {
    return 'Skickar $done av $total...';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'Åtkomst till Google Drive var inte tillåten. Anslut igen och markera Google Drive på Googles sida.';

  @override
  String get syncEntryUnsynced =>
      'Ej synkroniserad: den senaste synkroniseringen gick inte igenom';

  @override
  String get syncUseOfficial => 'Använd AID-synkroniseringsservern';

  @override
  String get syncServer => 'Serveradress';

  @override
  String get syncUsername => 'Användarnamn';

  @override
  String get syncPassword => 'Lösenord';

  @override
  String get syncConnect => 'Anslut';

  @override
  String get syncConnecting => 'Ansluter...';

  @override
  String get syncSignInFailed =>
      'Det gick inte att logga in. Kontrollera adressen, användarnamnet och lösenordet.';

  @override
  String syncConnectFailed(String error) {
    return 'Kunde inte ansluta: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Börja synkronisera';

  @override
  String get syncNewSpaceDescription =>
      'Det finns ingen synkroniserad dagbok här ännu. Den här dagboken kommer att laddas upp, krypterad från början med en nyckel som finns kvar på dina enheter.';

  @override
  String get syncJoinTitle => 'Gå med i den synkroniserade dagboken';

  @override
  String get syncWrongKey =>
      'Denna återställningskod öppnar inte den synkroniserade dagboken.';

  @override
  String syncLastSynced(String time) {
    return 'Senast synkroniserade $time';
  }

  @override
  String get syncNever => 'Inte synkroniserat ännu';

  @override
  String get syncSyncing => 'Synkroniseras...';

  @override
  String syncFailed(String error) {
    return 'Den senaste synkroniseringen misslyckades: $error';
  }

  @override
  String get syncLocked =>
      'Den synkroniserade dagboken tillhör nu andra enheter eller har startat om. Para ihop med en av dem eller använd återställningskoden för att fortsätta synkronisera.';

  @override
  String get syncNow => 'Synkronisera nu';

  @override
  String get syncUnlock => 'Lås upp';

  @override
  String get syncEncrypted => 'End-to-end krypterad';

  @override
  String get syncDisconnect => 'Sluta synkronisera';

  @override
  String get syncDisconnectDescription =>
      'Den här enheten slutar synkronisera. Dagboken här och den synkroniserade kopian stannar som de är.';

  @override
  String get syncOwnRecoveryPassword =>
      'Använd mitt eget återställningslösenord';

  @override
  String get syncRecoveryPassword => 'Återställningslösenord';

  @override
  String get syncRecoveryPasswordRepeat => 'Upprepa återställningslösenordet';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Använd minst $min-tecken';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'Lösenorden skiljer sig åt';

  @override
  String get syncRecoveryCode => 'Återställningskod';

  @override
  String get syncRecoveryCodeTitle => 'Spara din återställningskod';

  @override
  String get syncRecoveryCodeDescription =>
      'Om alla dina enheter tappas bort, återställer den här koden din synkroniserade dagbok. Förvara det i en lösenordshanterare eller på papper. Den visas bara denna gång.';

  @override
  String get syncRecoveryCodeCopied => 'Återställningskoden har kopierats';

  @override
  String get syncRecoveryCodeSaved => 'Jag har sparat den';

  @override
  String get syncJoinNeedsKey =>
      'Den här synkroniserade dagboken tillhör dina andra enheter. Para ihop med en av dem eller använd återställningskoden. Posterna på den här enheten kommer att läggas till den.';

  @override
  String get syncPairDevice => 'Para ihop med en enhet';

  @override
  String get syncUseRecoveryCode => 'Använd återställningskoden';

  @override
  String get syncAddDevice => 'Lägg till en enhet';

  @override
  String get syncChangeRecoveryCode => 'Ändra återställningskoden';

  @override
  String get syncChangeRecoveryDescription =>
      'En ny kod ersätter den nuvarande, som slutar fungera. Din data och andra enheter förblir som de är.';

  @override
  String get syncNewRandomCode => 'Ny slumpmässig kod';

  @override
  String get syncRecoveryCodeChanged => 'Återställningskoden har ändrats';

  @override
  String get syncResetSpace => 'Starta om den synkroniserade dagboken';

  @override
  String get syncResetSpaceDescription =>
      'Endast när ingen enhet och ingen återställningskod öppnar den längre: den synkroniserade kopian ersätts av dagboken på den här enheten, under enhetens nycklar. Dina andra enheter kopplas sedan ihop igen.';

  @override
  String get syncPairTitle => 'Para ihop enheter';

  @override
  String get syncPairShow => 'Visa en kod';

  @override
  String get syncPairEnter => 'Ange en kod';

  @override
  String get syncPairShowHint =>
      'Öppna Koppla enheter på din andra enhet, välj Ange en kod och skriv eller skanna detta.';

  @override
  String get syncPairEnterHint =>
      'Skriv in koden som din andra enhet visar eller skanna den.';

  @override
  String get syncPairCode => 'Parningskod';

  @override
  String get syncPairScan => 'Skanna';

  @override
  String get syncPairStart => 'Par';

  @override
  String get syncPairWaiting => 'Väntar på den andra enheten...';

  @override
  String syncPairDone(String device) {
    return 'Parat med $device';
  }

  @override
  String get syncPairWrongCode =>
      'Koden stämde inte. Visa en ny kod och försök igen.';

  @override
  String get syncPairNoOffer =>
      'Ingen enhet visar denna kod. Det kan ha gått ut.';

  @override
  String get syncPairTimedOut => 'Den andra enheten svarade inte i tid.';

  @override
  String get syncPairNeither =>
      'Ingen av enheterna har konfigurerats med denna synkroniserade dagbok ännu.';

  @override
  String get syncPairBoth =>
      'Båda enheterna öppnar redan denna synkroniserade dagbok.';

  @override
  String syncPairFailed(String error) {
    return 'Parning misslyckades: $error';
  }

  @override
  String get syncMediaPending =>
      'Dagbok synkroniserad · en del media överförs fortfarande';

  @override
  String get syncWaitingForDevices =>
      'Dagbok synkroniserad · väntar på att en annan enhet ska överföra media';

  @override
  String get syncCacheNotice =>
      'Molnmedia är tillfälligt. Behåll originalen på dina enheter; synkronisering är inte en säkerhetskopia.';

  @override
  String get paperTitle => 'Brevpapper';

  @override
  String get paperPlain => 'Vanligt';

  @override
  String get paperLined => 'Fodrad';

  @override
  String get paperGrid => 'Grid';

  @override
  String get paperTinted => 'Tonade';

  @override
  String get paperDecorationTitle => 'Dekorationer';

  @override
  String get paperDecorationNone => 'Inga';

  @override
  String get paperDecorationBotanical => 'Blad';

  @override
  String get paperDecorationStars => 'Stjärnor';

  @override
  String get paperDecorationWashi => 'Washi tejp';

  @override
  String get themeDarkChoice => 'Mörkt utseende';

  @override
  String get themeDarkSame => 'Följ ljus palett';

  @override
  String get themeDarkCustom => 'Separat palett';

  @override
  String get themeDarkAccent => 'Mörk accentfärg';

  @override
  String get themeColorTeal => 'Kricka';

  @override
  String get themeColorCyan => 'Cyan';

  @override
  String get themeColorIndigo => 'Indigo';

  @override
  String get themeColorCoral => 'Korall';

  @override
  String get themeColorOlive => 'Oliv';

  @override
  String get themeColorSlate => 'Skiffer';

  @override
  String get drawingTitle => 'Ritning';

  @override
  String get drawingPen => 'Penna';

  @override
  String get drawingEraser => 'Suddgummi';

  @override
  String get drawingUndo => 'Ångra';

  @override
  String get drawingClear => 'Rensa';

  @override
  String get drawingWidth => 'Pennans bredd';

  @override
  String get drawingStylusOnly => 'Endast penna';

  @override
  String get drawingDiscardTitle => 'Släng ritningen?';

  @override
  String get drawingDiscardBody => 'Denna ritning har inte sparats.';

  @override
  String get drawingSaveError => 'Det gick inte att spara ritningen.';

  @override
  String get syncNetworkTitle => 'Nätverksdiagnostik';

  @override
  String get syncNetworkRefresh => 'Uppdatera';

  @override
  String get syncNetworkSelectedRoute => 'Aktuell väg';

  @override
  String get syncNetworkAvailableRoutes => 'Tillgängliga vägar';

  @override
  String get syncNetworkSignaling => 'Enhetskataloganslutning';

  @override
  String get syncNetworkRelayRemaining => 'Återstående stafettpeng';

  @override
  String get syncNetworkIcePair => 'Direktanslutna kandidater';

  @override
  String get syncNetworkPeerTrusted => 'Autentiserad enhet';

  @override
  String get syncNetworkNoRoute => 'Väntar på en anslutning';

  @override
  String get syncNetworkUnavailable => 'Diagnostik är inte tillgänglig';

  @override
  String get syncMediaCopiesTitle => 'Medialeverans och kopior';

  @override
  String get syncMediaPendingCount => 'Väntar på överföring';

  @override
  String get syncMediaDurableCount => 'Levereras till personlig förvaring';

  @override
  String get syncMediaTemporaryCount => 'Tillfälliga eller obekräftade kopior';

  @override
  String get syncMediaReceiptExplanation =>
      'Dessa siffror beskriver genomförda leveranser, inte en ny granskning av överlevande säkerhetskopior.';

  @override
  String get syncMediaCacheExplanation =>
      'Tillfälliga molnmedia kan upphöra att gälla. Behåll dina original eller en separat säkerhetskopia.';

  @override
  String get momentsTitle => 'Fotoögonblick';

  @override
  String get momentsHint =>
      'Hitta grupper med hjälp av lokala fototider och valfria koordinater. Bilder bifogas endast när du väljer ett kort.';

  @override
  String get momentsScan => 'Hitta ögonblick';

  @override
  String get momentsChooseFolder => 'Välj fotomapp';

  @override
  String get momentsLocation => 'Inkludera fotoplatser';

  @override
  String get momentsEmpty => 'Inga nya fotogrupper.';

  @override
  String get momentsCreate => 'Skriv om dessa bilder';

  @override
  String get momentsDismiss => 'Avvisa';

  @override
  String get momentsError => 'Kunde inte läsa lokala bilder.';

  @override
  String get momentsCreated => 'Fotopost skapad.';

  @override
  String get momentsPermission =>
      'Tillåt åtkomst till foton för att hitta lokala förslag.';

  @override
  String get momentsScope =>
      'Endast senaste foton; högst 500 bilder och 20 bilder per kort.';

  @override
  String momentsPhotoCount(int count) {
    return '$count bilder';
  }

  @override
  String get nearbyTitle => 'Anslut enheter';

  @override
  String get nearbySend => 'Auktorisera en annan enhet';

  @override
  String get nearbyReceive => 'Anslut till en befintlig enhet';

  @override
  String get nearbyInstructions =>
      'Anslut båda enheterna till samma Wi-Fi eller till varandras hotspot. Bekräfta auktorisering på den befintliga enheten; båda enheterna förblir användbara. Inget internet krävs.';

  @override
  String get nearbyCompare =>
      'Jämför den här koden på båda enheterna innan du godkänner.';

  @override
  String get nearbyConfirm => 'Koderna matchar';

  @override
  String get nearbyScan => 'Skanna den andra enhetens kod';

  @override
  String get nearbyPaste => 'Klistra in inbjudan';

  @override
  String get nearbyWaiting => 'Väntar på godkännande på den andra enheten';

  @override
  String get nearbyWorking =>
      'Auktorisera och synkronisera din dagbok och bilagor...';

  @override
  String get nearbyPending =>
      'Vissa bilagor behöver fortfarande synkroniseras. Håll den andra enheten online och försök igen.';

  @override
  String get nearbyComplete =>
      'Enhet ansluten; dagbok och bilagor synkroniserade';

  @override
  String get nearbyFailed =>
      'Anslutningen slutfördes inte. Kontrollera den lokala anslutningen och försök igen.';

  @override
  String get nearbyEmptyRequired =>
      'Använd en enhet med en tom dagbok som inte är ansluten till synkronisering ännu.';

  @override
  String get nearbyRetry => 'Fortsätt synkronisera';

  @override
  String get nearbyWifi => 'Wi-Fi-inställningar';

  @override
  String get nearbyHotspot => 'Hotspot-inställningar';

  @override
  String get nearbyKeepOpen =>
      'Håll den här sidan öppen tills den nya enheten är klar. Inbjudan upphör efter två minuter.';

  @override
  String get syncDevicesTitle => 'Auktoriserade enheter';

  @override
  String get syncDevicesDescription =>
      'Endast godkända enheter kan komma åt detta AID-konto. Att återkalla en enhet blockerar servern men kan inte radera en huvudnyckel eller dagbok som redan har kopierats till den.';

  @override
  String get syncDeviceRequest =>
      'Visa denna auktoriserings-QR för en godkänd enhet';

  @override
  String get syncDeviceAuthorize => 'Auktorisera en enhet';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Skanna eller klistra in den nya enhetens auktoriseringsbegäran.';

  @override
  String get syncDeviceRevoke => 'Återkalla';

  @override
  String get syncDeviceRotate => 'Rotera enhetens signeringsnyckel';

  @override
  String get syncDeviceCheck => 'Kontrollera behörigheten';

  @override
  String get syncDeviceHardware => 'Maskinvarustödd signeringsnyckel';

  @override
  String get syncDeviceSoftware => 'Icke-exporterbar mjukvarusigneringsnyckel';

  @override
  String get syncDeviceUnavailable =>
      'Enhetsauktorisering är inte tillgänglig. Godkänn den här enheten från en annan auktoriserad enhet och försök igen.';

  @override
  String get syncDeviceRevoked => 'Återkallad';

  @override
  String get syncDeviceLocal => 'Denna enhet';

  @override
  String get cloudTrafficTitle =>
      'Månatlig molndataöverföringskvot för mediafiler';

  @override
  String get cloudTrafficLimit => 'Månatlig dataöverföringskvot';

  @override
  String get cloudTrafficUsed => 'Dataöverföring används';

  @override
  String get cloudTrafficRemaining => 'Dataöverföring kvar';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'Dataöverföringskvoten återställer $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'Molndataöverföringskvoten för mediefiler har förbrukats. Saknade mediefiler synkroniseras automatiskt när en direktanslutning är tillgänglig eller kvoten återställs.';

  @override
  String get cloudTrafficExplanation =>
      'Mediafilcachning och liverelä delar denna dataöverföringskvot. Direktanslutningar förbrukar inte det. Dagbokstext och anslutningskontrollmeddelanden har separata små dagliga gränser.';

  @override
  String get appearanceThemeSection => 'App-tema';

  @override
  String get appearancePaperSection => 'Dagbokspapper';

  @override
  String get appearanceTypographySection => 'Dagbokstext';

  @override
  String get appearancePreferencesSection => 'Allmänna preferenser';

  @override
  String get themeSystemAccentHint =>
      'Använder systempaletten istället för anpassade färger. Stäng av den för att välja din egen.';

  @override
  String get syncDeviceNameSaveFailed =>
      'Det gick inte att spara enhetsnamnet. Försök igen.';

  @override
  String get nearbyConnectionHelp => 'Anslutningshjälp';

  @override
  String get syncAllSynced => 'Allt synkroniserat';

  @override
  String get syncDetailsTitle => 'Synkronisera detaljer';

  @override
  String get syncMore => 'Fler alternativ';

  @override
  String get syncDeviceName => 'Enhetens namn';

  @override
  String get syncDeviceNameHint => 'Till exempel: Min surfplatta';

  @override
  String get syncDeviceNameInvalid => 'Använd 1 till 32 tecken';

  @override
  String get syncDeviceKeyDetails => 'Säkerhetsdetaljer';

  @override
  String get syncConnectionProblem =>
      'Det går inte att synkronisera just nu. Försöker igen automatiskt.';

  @override
  String get syncCopyComplete => 'Komplett kopia av din dagbok och mediefiler';

  @override
  String get syncCopyPartial => 'Vissa medier saknas fortfarande';

  @override
  String get syncCopyOlder => 'Nya ändringar väntar på att synkroniseras';

  @override
  String get syncCopyUnavailable =>
      'Kopieringsinformation är inte tillgänglig. Försök igen senare.';

  @override
  String get syncCopyLastKnown =>
      'Andra enheter visar sin senaste bekräftade kopia. Offlineenheter kan inte kontrolleras nu.';

  @override
  String get syncCopyTemporary =>
      'Tillfällig cache. Behåll originalen på dina enheter.';

  @override
  String get syncCopyStorage =>
      'Din synkroniseringslagring. Slutförda mediauppladdningar listas i diagnostik.';

  @override
  String syncCopyChecked(String time) {
    return 'Senast bekräftad $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Dataöverföring kvar denna månad: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Börja här';

  @override
  String get onboardConnect => 'Anslut till en befintlig enhet';

  @override
  String get onboardFailed =>
      'Installationen kunde inte slutföras. Din dagbok är säker; försök igen.';

  @override
  String get tutorialTitle => 'Hur man använder dagboken';

  @override
  String get tutorialWriteTitle => 'Skriv ditt första dagboksinlägg';

  @override
  String get tutorialWriteText =>
      'Tryck på + för att skriva en dagboksanteckning. Lägg till en valfri titel, välj dagboksdatum och tryck på bockmarkeringen för att spara. Du kan när som helst redigera din dagboksanteckning igen.';

  @override
  String get tutorialMediaTitle => 'Lägg till foton, ljud eller handstil';

  @override
  String get tutorialMediaText =>
      'Använd + i dagboksredigeraren för att bifoga foton, videor eller en röstinspelning, eller för att öppna handskriftsduken. Dessa bilagor sparas med dagboksanteckningen.';

  @override
  String get tutorialReviewTitle => 'Hitta en dag igen';

  @override
  String get tutorialReviewText =>
      'Bläddra i din dagbok eller kalender, sök efter dina texter och organisera poster med taggar. Media- och Atlas-sidorna låter dig hitta tidigare bidrag efter foto eller plats.';

  @override
  String get tutorialSyncTitle => 'Använd mer än en enhet';

  @override
  String get tutorialSyncText =>
      'I Inställningar → Data & lagring → Synkronisera, anslut till en befintlig enhet och bekräfta auktorisering på den enheten. Båda enheterna kan fortsätta använda dagboken. Dagbokstext synkroniseras först. Mediafiler synkroniseras härnäst när nätverksanslutningen och återstående dataöverföringskvot tillåter det.';

  @override
  String get tutorialPrivacyTitle => 'Håll din dagbok säker';

  @override
  String get tutorialPrivacyText =>
      'Dagboksanteckningar finns kvar på den här enheten om du inte aktiverar synkronisering eller delar eller exporterar dem. Synkronisering är krypterad från ände till ände. I Inställningar kan du också ställa in ett applösenord, skapa säkerhetskopior och öppna den här handledningen igen.';

  @override
  String get editorDiaryDay => 'Dagboksdatum';

  @override
  String get editorDiaryDayPicker => 'Dagboksdatum · skapandetiden behålls';

  @override
  String get editorDiaryDayHint =>
      'Dagen som det här inlägget hör till. En ändring ändrar inte tidpunkten då inlägget skapades.';

  @override
  String get hiddenDiaryTitle => 'Dolda inlägg';

  @override
  String get hiddenDiaryHide => 'Dölj inlägg';

  @override
  String get hiddenDiaryShow => 'Visa inlägg';

  @override
  String get hiddenDiaryEmpty => 'Inga dolda inlägg';

  @override
  String get hiddenDiaryUnlock => 'Lås upp dolda inlägg';

  @override
  String get hiddenDiaryAuthHint =>
      'Använd appens lås eller enhetens skärmlås.';

  @override
  String get hiddenDiaryLocalOnly =>
      'Dolda inlägg stannar på denna enhet och synkroniseringen pausas. Använd krypterade säkerhetskopior. Befintliga kopior på andra platser ändras inte.';

  @override
  String get moodClear => 'Rensa humör';
}
