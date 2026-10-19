// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

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
  String get dailyReminderTitle => 'Zapiš si dnešek!';

  @override
  String get dailyReminderDescription => 'Zapiš si svůj den…';

  @override
  String get actionTakePhoto => 'Udělej fotku';

  @override
  String get actionToday => 'Dnes';

  @override
  String get actionOtherDay => 'Jiný den';

  @override
  String get pageHomeTitle => 'Hlavní stránka';

  @override
  String get jumpToMonthTitle => 'Skočit na měsíc';

  @override
  String get jumpToLogTitle => 'Skočit na záznam';

  @override
  String get flashbacksTitle => 'Vzpomínky';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Vyřadit špatné dny';

  @override
  String get flaskbacksEmpty => 'Zatím žádné vzpomínky…';

  @override
  String get flashbackGoodDay => 'Dobrý den';

  @override
  String get flashbackRandomDay => 'Náhodný den';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count týdny před',
      one: '$count týden před',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count měsíců zpět',
      one: '$count měsíců zpět',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count roky zpět',
      one: '$count rok zpět',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'Tohoto dne';

  @override
  String get pageGalleryTitle => 'Galerie';

  @override
  String get searchLogsHint => 'Vyhledávání záznamů…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count záznamů',
      one: '$count záznam',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dní/ů',
      one: '$count den',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    return '$count slov';
  }

  @override
  String get noLogs => 'Žádné záznamy…';

  @override
  String get noResults => 'Žádné výsledky…';

  @override
  String get sortDateTitle => 'Datum';

  @override
  String get sortOrderAscendingTitle => 'Stoupající';

  @override
  String get sortOrderDescendingTitle => 'Klesající';

  @override
  String get pageStatisticsTitle => 'Statistiky';

  @override
  String get statisticsNotEnoughData => 'Nedostatek dat…';

  @override
  String get statisticsRangeOneMonth => '1 měsíc';

  @override
  String get statisticsRangeSixMonths => '6 měsíců';

  @override
  String get statisticsRangeOneYear => '1 rok';

  @override
  String get statisticsRangeAllTime => 'Celé období';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag Shrnutí';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag Ve dne';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag Během Času';
  }

  @override
  String get chartGroupingLabel => 'Seskupit podle';

  @override
  String get chartGroupingDay => 'Dne';

  @override
  String get chartGroupingWeek => 'Týdne';

  @override
  String get chartGroupingMonth => 'Měsíce';

  @override
  String get chartGroupingYear => 'Roku';

  @override
  String get chartSmoothingLabel => 'Zahlazování';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Současný Streak $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nejdelší Streak $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dobrých dnů $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dnů od špatného dne $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Nelze přistoupit k Externími uložišti';

  @override
  String get errorExternalStorageAccessDescription =>
      'Pokud používáte síťové úložiště, ujistěte se, že je služba online a že máte přístup k síti.\n\nV opačném případě mohla aplikace ztratit oprávnění pro externí složku. Přejděte do nastavení a znovu vyberte externí složku, abyste jí udělili přístup.\n\nUpozornění: změny nebudou synchronizovány, dokud neobnovíte přístup k externímu úložišti!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Pokračovat s lokální databází';

  @override
  String get databaseMigrationErrorTitle => 'Nepodařilo se přesunout vaše data';

  @override
  String get databaseMigrationErrorDescription =>
      'Vaše záznamy jsou v bezpečí, ale nepodařilo se je přesunout do úložiště aplikace.\n\nZkuste to znovu, v případě opakovaného problému nahlašte chybu.';

  @override
  String get databaseMigrationErrorRetry => 'Zkusit znovu';

  @override
  String get errorReport => 'Nahlásit chybu';

  @override
  String get lastModified => 'Upraveno';

  @override
  String get writeSomethingHint => 'Napiš něco…';

  @override
  String get titleHint => 'Název…';

  @override
  String get deleteLogTitle => 'Smazat záznam';

  @override
  String get deleteLogDescription => 'Chcete smazat tento záznam?';

  @override
  String get deletePhotoTitle => 'Smazat fotografii';

  @override
  String get deletePhotoDescription => 'Chcete smazat tuto fotografii?';

  @override
  String get pageSettingsTitle => 'Nastavení';

  @override
  String get settingsAppearanceTitle => 'Vzhled';

  @override
  String get settingsTheme => 'Téma';

  @override
  String get themeSystem => 'Systém';

  @override
  String get themeLight => 'Světlý';

  @override
  String get themeDark => 'Tmavý';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'První den v týdnu';

  @override
  String get settingsCalendarSystem => 'Kalendářní systém';

  @override
  String get calendarSystemGregorian => 'Gregoriánský';

  @override
  String get calendarSystemJalali => 'Solární kalendář Hidžry';

  @override
  String get settingsUseSystemAccentColor => 'Použít barvu systému';

  @override
  String get settingsCustomAccentColor => 'Vlastní barva';

  @override
  String get settingsShowMarkdownToolbar => 'Zobrazit panel nástrojů';

  @override
  String get settingsShowFlashbacks => 'Zobrazit vzpomínky';

  @override
  String get settingsChangeMoodIcons => 'Změnit ikony nálad';

  @override
  String get moodIconPrompt => 'Vložte ikonu';

  @override
  String get settingsFlashbacksViewLayout => 'Zobrazení rozložení vzpomínek';

  @override
  String get settingsHideImagesInGallery => 'Skrýt obrázky v galerii';

  @override
  String get settingsHideImages => 'Skrýt obrázky';

  @override
  String get pageCalendarTitle => 'Kalendář';

  @override
  String get settingsNotificationsTitle => 'Oznámení';

  @override
  String get settingsDailyReminderOnboarding =>
      'Zapněte si denní připomenutí, abyste byli důslední!';

  @override
  String get settingsNotificationsPermissionsPrompt =>
      'K odeslání připomenutí v náhodný okamžik nebo ve vámi preferovaný čas bude vyžadováno oprávnění „naplánovat alarmy“.';

  @override
  String get settingsDailyReminderTitle => 'Denní připomenutí';

  @override
  String get settingsOnThisDayDescription => 'Připomeňte si minulé vzpomínky';

  @override
  String get settingsDailyReminderDescription => 'Jemné každodenní připomenutí';

  @override
  String get settingsReminderTime => 'Čas připomenutí';

  @override
  String get settingsFixedReminderTimeTitle => 'Pevný čas připomenutí';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Vyberte pevný čas pro připomenutí';

  @override
  String get settingsAlwaysSendReminderTitle => 'Vždy posílat připomenutí';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Poslat připomenutí i když už byl vytvořený zápis';

  @override
  String get settingsCustomizeNotificationTitle => 'Přizpůsobit oznámení';

  @override
  String get settingsTemplatesTitle => 'Šablony';

  @override
  String get settingsDefaultTemplate => 'Výchozí šablona';

  @override
  String get manageTemplates => 'Spravovat šablony';

  @override
  String get addTemplate => 'Přidat šablonu';

  @override
  String get newTemplate => 'Nová šablona';

  @override
  String get noTemplateTitle => 'Žádná';

  @override
  String get noTemplatesDescription => 'Zatím nebyly vytvořeny žádné šablony…';

  @override
  String get templateVariableTime => 'Čas';

  @override
  String get templateDefaultTimestampTitle => 'Časový údaj';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Shrnutí dne';

  @override
  String get templateDefaultSummaryBody => '### Shrnutí\n- \n\n### Citace\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Ohlédnutí za dnem';

  @override
  String get templateDefaultReflectionBody =>
      '### Co jsem si dnes užil?\n- \n\n### Za co jsem rád?\n- \n\n### Na co se těším?\n- ';

  @override
  String get settingsTagsTitle => 'Štítky';

  @override
  String get manageTags => 'Spravovat štítky';

  @override
  String get tagTypeLabelTitle => 'Značka';

  @override
  String get tagTypeTrackerTitle => 'Počítadlo';

  @override
  String get nameHint => 'Název';

  @override
  String get tagColorLabel => 'Barva';

  @override
  String get iconPickerTitle => 'Vyberte ikonu';

  @override
  String get iconPickerIconsTab => 'Ikony';

  @override
  String get iconPickerCustomTab => 'Vlastní';

  @override
  String get iconPickerSearchHint => 'Vyhledat ikony…';

  @override
  String get colorPickerTitle => 'Vyberte barvu';

  @override
  String get colorPickerPaletteTab => 'Barvy';

  @override
  String get iconGroupMoodPeople => 'Pocity a lidé';

  @override
  String get iconGroupHealth => 'Zdraví';

  @override
  String get iconGroupWorkFinance => 'Práce a peníze';

  @override
  String get iconGroupHabitsGoals => 'Zvyky a cíle';

  @override
  String get iconGroupNature => 'Příroda';

  @override
  String get iconGroupFoodDrink => 'Jídlo a pití';

  @override
  String get iconGroupHome => 'Dům';

  @override
  String get iconGroupTravel => 'Cestování';

  @override
  String get iconGroupSymbols => 'Symboly';

  @override
  String get tagCategoryLabel => 'Kategorie';

  @override
  String get tagLabel => 'Štítek';

  @override
  String get tagCategoryUncategorized => 'Nekategorizované';

  @override
  String get newCategoryTitle => 'Nová kategorie';

  @override
  String get shareButtonLabel => 'Sdílet';

  @override
  String get importErrorDescription => 'Nepodařilo se importovat soubor!';

  @override
  String get exportErrorDescription => 'Nepodařilo se exportovat soubor!';

  @override
  String get deleteTitle => 'Smazat';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Využívá se to v $count záznamech.',
      few: ' Využívá se to ve $count záznamech.',
      one: ' Využívá se to v 1 záznamu.',
      zero: '',
    );
    return 'Smazat \"$name\"?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' $count tagů budou smazaný. ',
      few: ' $count tagy budou smazaný. ',
      one: ' 1 tag bude smazaný. ',
      zero: '',
    );
    return 'Smazat \"$name\"?$_temp0';
  }

  @override
  String deleteTemplateMessage(Object name) {
    return 'Smazat „$name“?';
  }

  @override
  String get filterTagsTitle => 'Filtr';

  @override
  String get tagFilterModeAny => 'Jakýkoliv štítek';

  @override
  String get tagFilterModeAll => 'Všechny štítky';

  @override
  String get clearAllFilters => 'Smazat vše';

  @override
  String get noTagsFilterLabel => 'Žádné štítky';

  @override
  String get addTagsTitle => 'Přidat štítky';

  @override
  String get addTagsSearchHint => 'Hledat štítky…';

  @override
  String get tagPickerSortManualLabel => 'Manuální řazení';

  @override
  String get tagPickerSortUsageLabel => 'Řadit podle využití';

  @override
  String get tagFavoriteName => 'Oblíbené';

  @override
  String get tagEnergyName => 'Energie';

  @override
  String get tagCategoryActivitiesName => 'Aktivity';

  @override
  String get tagExerciseName => 'Pohyb';

  @override
  String get tagSocializingName => 'Socializace';

  @override
  String get tagHobbyName => 'Koníček';

  @override
  String get tagEntertainmentName => 'Zábava';

  @override
  String get tagDiningName => 'Jezení';

  @override
  String get tagChoresName => 'Povinnosti';

  @override
  String get tagCategoryEmotionsName => 'Emoce';

  @override
  String get tagExcitedName => 'Nadšený';

  @override
  String get tagGratefulName => 'Vděčný';

  @override
  String get tagCalmName => 'Klidný';

  @override
  String get tagTiredName => 'Unavený';

  @override
  String get tagAnxiousName => 'Úzkostlivý';

  @override
  String get tagAnnoyedName => 'Naštvaný';

  @override
  String get welcomeLogBodyText =>
      '## Welcome to AID Diary\n\n> Every day is worth remembering.\n\nWrite what happened, how you felt, and where you were. Your entries stay on this device.\n\n- **Journal** lists every entry by day\n- **Calendar**, **Media** and **Atlas** look back by date, photo and place\n- **Coach** offers prompts and templates when you don\'t know what to write\n\nAID Diary is a modified version of [Daily You](https://github.com/Demizo/Daily_You) by Demizo and contributors, and not the official Daily You app.';

  @override
  String get settingsStorageTitle => 'Uložiště';

  @override
  String get settingsImageQuality => 'Kvalita fotografie';

  @override
  String get imageQualityHigh => 'Vysoká';

  @override
  String get imageQualityMedium => 'Střední';

  @override
  String get imageQualityLow => 'Nízká';

  @override
  String get imageQualityNoCompression => 'Bez komprese';

  @override
  String get settingsLogFolder => 'Složka záznamů';

  @override
  String get settingsImageFolder => 'Složka obrázků';

  @override
  String get warningTitle => 'Varování';

  @override
  String get logFolderWarningDescription =>
      'Pokud vybraná složka již obsahuje soubor „daily_you.db“, bude použit k přepsání vašich stávajících záznamů!';

  @override
  String get errorTitle => 'Chyba';

  @override
  String get logFolderErrorDescription =>
      'Nepodařilo se změnit složku záznamů!';

  @override
  String get imageFolderErrorDescription =>
      'Nepodařilo se změnit složku obrázků!';

  @override
  String get backupErrorDescription => 'Nepodařilo se vytvořit zálohu!';

  @override
  String get restoreErrorDescription => 'Obnovení zálohy se nezdařilo!';

  @override
  String get settingsBackupRestoreTitle => 'Zálohování a obnovení';

  @override
  String get settingsBackup => 'Zálohovat';

  @override
  String get settingsRestore => 'Obnovit';

  @override
  String get settingsRestorePromptDescription =>
      'Obnovení zálohy přepíše vaše stávající data!';

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
    return 'Přenos… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Vytváření zálohy... $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Obnovení zálohy… $percent%';
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
  String get cleanUpStatus => 'Uklízení…';

  @override
  String migratingImagesStatus(Object current, Object total) {
    return 'Migruju fotky… $current/$total';
  }

  @override
  String get settingsExport => 'Export';

  @override
  String get settingsExportToAnotherFormat => 'Exportovat do jiného formátu';

  @override
  String get settingsExportFormatDescription =>
      'To by nemělo být použito jako záloha!';

  @override
  String get exportLogs => 'Export Logs';

  @override
  String get exportImages => 'Export Images';

  @override
  String get settingsImport => 'Import';

  @override
  String get settingsImportFromAnotherApp => 'Importovat z jiné aplikace';

  @override
  String get settingsTranslateCallToAction =>
      'Každý by měl mít přístup k deníku!';

  @override
  String get settingsHelpTranslate => 'Pomozte s překladem';

  @override
  String get importLogs => 'Import Logs';

  @override
  String get importImages => 'Import Images';

  @override
  String get logFormatTitle => 'Zvolte formát';

  @override
  String get logFormatDescription =>
      'Formát jiné aplikace nemusí podporovat všechny funkce. Nahlaste prosím jakékoli problémy, protože formáty třetích stran se mohou kdykoli změnit. To nebude mít vliv na stávající záznamy!';

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
  String get settingsDeleteAllLogsTitle => 'Smazat všechny záznamy';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Chcete smazat všechny své záznamy?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Zadejte \'$prompt\' pro potvrzení. Tento úkon nelze vrátit zpět!';
  }

  @override
  String get settingsLanguageTitle => 'Jazyk';

  @override
  String get settingsAppLanguageTitle => 'Jazyk aplikace';

  @override
  String get settingsOverrideAppLanguageTitle => 'Přepsat jazyk aplikace';

  @override
  String get settingsSecurityTitle => 'Zabezpečení';

  @override
  String get settingsSecurityRequirePassword => 'Vyžadovat heslo';

  @override
  String get settingsSecurityEnterPassword => 'Zadejte heslo';

  @override
  String get settingsSecuritySetPassword => 'Nastavit heslo';

  @override
  String get settingsSecurityChangePassword => 'Změnit heslo';

  @override
  String get settingsSecurityPassword => 'Heslo';

  @override
  String get settingsSecurityConfirmPassword => 'Potvrďte heslo';

  @override
  String get settingsSecurityOldPassword => 'Staré heslo';

  @override
  String get settingsSecurityIncorrectPassword => 'Nesprávné heslo';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'Hesla se neshodují';

  @override
  String get requiredPrompt => 'Povinné';

  @override
  String get settingsSecurityBiometricUnlock => 'Biometrické odemykání';

  @override
  String get unlockAppPrompt => 'Odemknout aplikaci';

  @override
  String get settingsAboutTitle => 'O nás';

  @override
  String get settingsVersion => 'Verze';

  @override
  String get settingsLicense => 'Licence';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsSourceCode => 'Zdrojový kód';

  @override
  String get settingsOpenSourceLicenses => 'Open Source Licenses';

  @override
  String get settingsMadeWithLove => 'Vyrobeno s ❤️';

  @override
  String get settingsConsiderSupporting => 'zvažte podporu';

  @override
  String get imagesTitle => 'Obrázky';

  @override
  String get tagMoodTitle => 'Nálada';

  @override
  String get calendarTagDisplayLabel => 'Štítek';

  @override
  String get selectTagTitle => 'Vybrat štítek';

  @override
  String get labelPresentLabel => 'Přítomný';

  @override
  String get labelAbsentLabel => 'Nepřítomný';

  @override
  String get labelCoverageLabel => 'Pokrytí';

  @override
  String chartDistributionTitle(Object tag) {
    return 'Distribuce $tag';
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
  String get coachWritePrompt => 'Write about it';

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
      'Short questions that help you notice the small things in a day.';

  @override
  String get coachProgramReflectTitle => 'Looking inward';

  @override
  String get coachProgramReflectDescription =>
      'Questions for slowing down and understanding how you feel.';

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
  String get locationNoCoordinates => 'No coordinates';

  @override
  String get locationUseCurrent => 'Use current location';

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
}
