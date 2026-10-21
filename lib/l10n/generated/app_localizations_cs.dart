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
  String get flashbacksTitle => 'Vzpomínky';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Vyřadit špatné dny';

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
  String get settingsShowFlashbacks => 'Zobrazit vzpomínky';

  @override
  String get settingsChangeMoodIcons => 'Změnit ikony nálad';

  @override
  String get moodIconPrompt => 'Vložte ikonu';

  @override
  String get settingsHideImages => 'Skrýt obrázky';

  @override
  String get pageCalendarTitle => 'Kalendář';

  @override
  String get settingsNotificationsTitle => 'Oznámení';

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
  String get manageTemplates => 'Spravovat šablony';

  @override
  String get noTemplateTitle => 'Žádná';

  @override
  String get noTemplatesDescription => 'Zatím nebyly vytvořeny žádné šablony…';

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
      '## Welcome to AID Diary\n\n> A quiet place for your days.\n\nWrite what happened, how you felt, and where you were. Your entries stay on this device.\n\n- **Journal** lists every entry by day\n- **Calendar**, **Media** and **Atlas** look back by date, photo and place\n- **Coach** offers prompts and templates when you don\'t know what to write';

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
      'Pokud vybraná složka již obsahuje soubor „aid_diary.db“, bude použit k přepsání vašich stávajících záznamů!';

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
  String get settingsExportToAnotherFormat => 'Exportovat do jiného formátu';

  @override
  String get settingsExportFormatDescription =>
      'To by nemělo být použito jako záloha!';

  @override
  String get settingsImportFromAnotherApp => 'Importovat z jiné aplikace';

  @override
  String get logFormatTitle => 'Zvolte formát';

  @override
  String get logFormatDescription =>
      'Formát jiné aplikace nemusí podporovat všechny funkce. Nahlaste prosím jakékoli problémy, protože formáty třetích stran se mohou kdykoli změnit. To nebude mít vliv na stávající záznamy!';

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
  String get settingsOpenSourceLicenses => 'Open Source Licenses';

  @override
  String get tagMoodTitle => 'Nálada';

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
  String get atlasMyLocation => 'My location';

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
  String get settingsDayStart => 'A diary day starts at';

  @override
  String get settingsDayStartMidnight => 'Midnight';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Entries written after midnight but before this belong to the day before: in the journal, the calendar, streaks, reviews and every statistic. Their time stays as written.';

  @override
  String get lateNightBadge =>
      'Written late at night, counted for the day before';

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
      'Yes: in Settings → Data & storage, import exports from Daylio, Diarium, Diaro, DayBook, My Brain, OneShot and Pixels, or a JSON export.';

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

  @override
  String get channelReminders => 'Reminders';

  @override
  String get channelOnThisDay => 'On this day';

  @override
  String get channelCoach => 'Coach prompts';

  @override
  String get channelNudges => 'Nudges after quiet days';

  @override
  String get channelQuickWrite => 'Quick write';

  @override
  String get channelBackup => 'Backups';

  @override
  String get formatJsonExport => 'JSON (AID Diary export)';

  @override
  String get aboutModifiedNotice =>
      'A modified version of Daily You by Demizo and contributors. It is not the official Daily You app.';

  @override
  String get toolbarPhotos => 'Add photos';

  @override
  String get toolbarMedia => 'Photos and videos';

  @override
  String get mediaFromGallery => 'Choose from gallery';

  @override
  String get editorLeaveTitle => 'Save this entry?';

  @override
  String get editorLeaveDiscard => 'Don\'t save';

  @override
  String get editorTitleHint => 'Title';

  @override
  String get editorLocating => 'Locating…';

  @override
  String get toolbarVideo => 'Video';

  @override
  String get toolbarAudio => 'Voice note';

  @override
  String get toolbarTags => 'Tags';

  @override
  String get toolbarBulletList => 'Bulleted list';

  @override
  String get toolbarHeading => 'Heading';

  @override
  String get toolbarBold => 'Bold';

  @override
  String get toolbarItalic => 'Italic';

  @override
  String get toolbarHighlight => 'Highlight';

  @override
  String get toolbarStrikethrough => 'Strikethrough';

  @override
  String get toolbarQuote => 'Quote';

  @override
  String get toolbarLink => 'Link';

  @override
  String get toolbarInsert => 'Insert';

  @override
  String get toolbarUndo => 'Undo';

  @override
  String get toolbarRedo => 'Redo';

  @override
  String get toolbarInsertDate => 'Insert the date';

  @override
  String get toolbarInsertTime => 'Insert the time';
}
