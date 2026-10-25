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
  String get themeColorTitle => 'Barva motivu';

  @override
  String get themeColorHint => 'Vyberte barvu pro tuto paletu.';

  @override
  String get themeColorBlue => 'Nebesky modrá';

  @override
  String get themeColorGreen => 'Lesní zelená';

  @override
  String get themeColorBrown => 'Teplá káva';

  @override
  String get themeColorPurple => 'Levandule';

  @override
  String get themeColorRose => 'Zaprášená růže';

  @override
  String get themeColorAmber => 'Jantarová';

  @override
  String get themeColorPreview => 'Každý den trochu';

  @override
  String get themeTintBackgroundTitle => 'Odstín pozadí barvou motivu';

  @override
  String get themeTintBackgroundHint =>
      'Vypnout pro neutrální šedé pozadí; tlačítka udrží vámi zvolenou barvu.';

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
  String get tagNameExists => 'Značka s tímto názvem již existuje';

  @override
  String get categoryNameExists => 'Kategorie s tímto názvem již existuje';

  @override
  String deleteTemplateMessage(Object name) {
    return 'Smazat „$name“?';
  }

  @override
  String get addTagsTitle => 'Přidat štítky';

  @override
  String get addTagsSearchHint => 'Hledat štítky…';

  @override
  String get tagFavoriteName => 'Oblíbené';

  @override
  String get iconGroupActivities => 'Aktivity';

  @override
  String get iconGroupHobbies => 'Zábava';

  @override
  String get settingsStorageTitle => 'Uložiště';

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
  String get settingsBackupPasswordProtect => 'Zálohy chráněné heslem';

  @override
  String get backupEncryptedTitle => 'Šifrovaná záloha';

  @override
  String get backupEncryptedContent => 'Tato záloha je chráněna heslem.';

  @override
  String get settingsAutoBackup => 'Automatické zálohování';

  @override
  String get settingsAutoBackupLocation => 'Umístění zálohy';

  @override
  String get settingsAutoBackupInterval => 'Interval zálohování';

  @override
  String get settingsAutoBackupIntervalDaily => 'Denně';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Týdenní';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Měsíční';

  @override
  String get settingsAutoBackupMaxCount => 'Zálohy k uchování';

  @override
  String get settingsAutoBackupRequireCharging => 'Pouze při nabíjení';

  @override
  String settingsBackupLast(Object time) {
    return 'Poslední záloha $time';
  }

  @override
  String get settingsBackupNever => 'Nikdy nezálohováno';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Další záloha $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'všechny';

  @override
  String get autoBackupFailedTitle => 'Zálohování se nezdařilo';

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
    return 'Šifrování zálohy… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Dešifrování zálohy… $percent%';
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
  String get formatOneDiary => 'One Diary';

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
  String get settingsAppLanguageTitle => 'Jazyk aplikace';

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
  String get settingsOpenSourceLicenses => 'Open Source licence';

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
  String get shareAddToLogPickerTitle => 'Vyberte záznam v deníku';

  @override
  String get adaptiveEmptyDay => 'Pro tento den zatím nejsou žádné záznamy';

  @override
  String get adaptiveNewEntry => 'Napište záznam';

  @override
  String get pageJournalTitle => 'Deník';

  @override
  String get coachPrompt1 => 'Co tě dnes rozesmálo?';

  @override
  String get coachPrompt2 => 'Jakou jednu věc jste se dnes naučili?';

  @override
  String get coachPrompt3 => 'S kým jsi dnes mluvil a jaký to byl pocit?';

  @override
  String get coachPrompt4 => 'Za co jsi právě teď vděčný?';

  @override
  String get coachPrompt5 => 'Co vám dnes vzalo nejvíce energie?';

  @override
  String get coachPrompt6 =>
      'Popište malý okamžik, který si chcete zapamatovat.';

  @override
  String get coachPrompt7 => 'Co by udělalo zítra dobrý den?';

  @override
  String get coachPrompt8 => 'Co se vám v poslední době honí hlavou?';

  @override
  String get coachPrompt9 => 'Co jsi dnes udělal jen pro sebe?';

  @override
  String get coachPrompt10 => 'Kdyby měl dnešek nějaký titul, jaký by to byl?';

  @override
  String get pageMediaTitle => 'Média';

  @override
  String get pageAtlasTitle => 'Atlas';

  @override
  String get pageCoachTitle => 'Trenér';

  @override
  String get noEntrySelected => 'Není vybrán žádný záznam.';

  @override
  String get entryShare => 'Sdílejte';

  @override
  String get entryFavorite => 'hvězda';

  @override
  String get entryEdit => 'Upravit';

  @override
  String get entryPrevious => 'Předchozí záznam';

  @override
  String get entryNext => 'Další záznam';

  @override
  String get journalStories => 'Příběhy';

  @override
  String get journalEntries => 'Příspěvky';

  @override
  String get journalEmptyHint => 'Začněte svůj deník přidáním nového záznamu.';

  @override
  String get storyToday => 'dnes';

  @override
  String get storyThrowback => 'Vzpomínka';

  @override
  String get storyNoThrowback => 'Dnes žádný návrat';

  @override
  String get mediaFiles => 'Mediální soubory';

  @override
  String get mediaEmpty => 'Zatím žádné fotky.';

  @override
  String get mediaEmptyHint =>
      'Zde se zobrazí fotografie připojené k příspěvkům.';

  @override
  String get atlasEmpty => 'Žádné záznamy s umístěním.';

  @override
  String get atlasEmptyHint => 'Zde se zobrazí záznamy s umístěním.';

  @override
  String get atlasShowAll => 'Zobrazit všechny položky';

  @override
  String get atlasMyLocation => 'Moje poloha';

  @override
  String get coachAll => 'všechny';

  @override
  String get coachPrograms => 'Programy';

  @override
  String get coachTemplates => 'Šablony';

  @override
  String get coachKindProgram => 'Program';

  @override
  String get coachKindTemplate => 'Šablona';

  @override
  String get coachNoTemplates => 'Žádné programy ani šablony.';

  @override
  String get coachUseTemplate => 'Pište pomocí této šablony';

  @override
  String get coachProgramEverydayTitle => 'Každodenní okamžiky';

  @override
  String get coachProgramEverydayDescription =>
      'Pět krátkých otázek, jedna denně. Každá zabere minutu nebo dvě a pomůže vám zjistit, díky čemu byl den váš. Jemný způsob, jak si vybudovat návyk každý den trochu psát.';

  @override
  String get coachProgramReflectTitle => 'Pohled dovnitř';

  @override
  String get coachProgramReflectDescription =>
      'Jedna hlubší otázka týdně, po dobu pěti týdnů. Udělejte si čas s každým: jak jste se cítili, co vás vyčerpává, za co jste vděční.';

  @override
  String get searchFilters => 'Filtry';

  @override
  String get searchFilterTags => 'Tagy';

  @override
  String get searchFilterStarred => 'S hvězdičkou';

  @override
  String get searchHint => 'Zadejte a vyhledejte nebo vyberte filtr.';

  @override
  String get locationTitle => 'Umístění';

  @override
  String get locationName => 'Název místa';

  @override
  String get locationRemove => 'Odebrat';

  @override
  String get locationServiceDisabled => 'Lokalizační služby jsou vypnuté.';

  @override
  String get locationPermissionDenied => 'Povolení k umístění bylo odepřeno.';

  @override
  String get locationUnavailable => 'Nelze získat aktuální polohu.';

  @override
  String get calendarJumpToToday => 'Přejít na dnešek';

  @override
  String get editorStartWriting => 'Začněte psát nebo zvolte a ';

  @override
  String get editorTemplateLink => 'Šablona';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Vyberte šablonu';

  @override
  String get templateFeatured => 'Doporučené šablony';

  @override
  String get templateMine => 'Moje šablony';

  @override
  String get templateDailyName => 'Denní přehled';

  @override
  String get templateDailyDescription =>
      'Co se stalo, jaký to byl pocit a co bude následovat.';

  @override
  String get templateDailyText =>
      '## Co se dnes stalo\n\n\n## Jak jsem se cítil\n\n\n## Tři věci, za které jsem vděčný\n1. \n2. \n3. \n\n## Zítra\n';

  @override
  String get templateTravelName => 'Záznam cestovního deníku';

  @override
  String get templateTravelDescription => 'Místa, momenty a jídlo z cesty.';

  @override
  String get templateTravelText =>
      '## Kam jsem šel\n\n\n## Moment, který si nejvíc pamatuji\n\n\n## Co jsem jedl\n\n\n## Plány na zítřek\n';

  @override
  String get templateReadingName => 'Čtení poznámek';

  @override
  String get templateReadingDescription =>
      'Citáty a myšlenky z toho, co čtete.';

  @override
  String get templateReadingText =>
      '## Kniha\n\n\n## Kde jsem\n\n\n## Citáty\n> \n\n## Moje myšlenky\n';

  @override
  String get templateWeeklyName => 'Týdenní přehled';

  @override
  String get templateWeeklyDescription =>
      'Nejdůležitější události, problémy a zaměření na příští týden.';

  @override
  String get templateWeeklyText =>
      '## Nejdůležitější\n\n\n## Co bylo těžké\n\n\n## Co jsem se naučil\n\n\n## Soustřeďte se na příští týden\n';

  @override
  String get entrySaveAsTemplate => 'Uložit jako šablonu';

  @override
  String get entrySavedAsTemplate => 'Uloženo jako šablona';

  @override
  String get storyStatistics => 'Statistiky';

  @override
  String get storyMoodChart => 'Graf nálady';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return 'Záznamy $entries · Dny $days';
  }

  @override
  String get storyThisYear => 'Tento rok';

  @override
  String get storyLastYear => 'Minulý rok';

  @override
  String get storyTapToOpen => 'Klepnutím na den jej otevřete';

  @override
  String get settingsGeneralTitle => 'Generál';

  @override
  String get settingsDataTitle => 'Data a úložiště';

  @override
  String get settingsStoriesTitle => 'Příběhy';

  @override
  String get settingsHelpTitle => 'Nápověda a informace';

  @override
  String get weatherTitle => 'Počasí';

  @override
  String get weatherClear => 'Jasný';

  @override
  String get weatherPartlyCloudy => 'Částečně oblačno';

  @override
  String get weatherCloudy => 'Zataženo';

  @override
  String get weatherFog => 'mlha';

  @override
  String get weatherDrizzle => 'Mrholení';

  @override
  String get weatherRain => 'déšť';

  @override
  String get weatherSnow => 'Sníh';

  @override
  String get weatherStorm => 'Bouřka';

  @override
  String get weatherFetch => 'Získejte počasí pro tento záznam';

  @override
  String get weatherNeedsLocation => 'Nejprve přidejte místo se souřadnicemi.';

  @override
  String get weatherUnavailable =>
      'Počasí pro toto místo a čas není k dispozici.';

  @override
  String get weatherRemove => 'Odstraňte počasí';

  @override
  String get weatherTemperature => 'Teplota';

  @override
  String get activityStill => 'Pořád';

  @override
  String get activityWalking => 'Chůze';

  @override
  String get activityRunning => 'Běh';

  @override
  String get activityCycling => 'Cyklistika';

  @override
  String get activityVehicle => 'Ve vozidle';

  @override
  String get activityFlying => 'Létání';

  @override
  String get activityExercise => 'Cvičení';

  @override
  String get settingsAutoAddTitle => 'Přidat automaticky';

  @override
  String get settingsAutoAddLocation => 'Umístění';

  @override
  String get settingsAutoAddWeather => 'Počasí';

  @override
  String get settingsAutoAddHint =>
      'Nové položky se vyplní při jejich vytvoření.';

  @override
  String get settingsTemperatureUnit => 'Jednotka teploty';

  @override
  String get settingsCelsius => 'Celsia (°C)';

  @override
  String get settingsFahrenheit => 'Fahrenheit (°F)';

  @override
  String get moodGreat => 'Skvělé';

  @override
  String get moodGood => 'Dobře';

  @override
  String get moodOkay => 'Dobře';

  @override
  String get moodBad => 'Špatný';

  @override
  String get moodAwful => 'Strašné';

  @override
  String get locationSearchHint => 'Vyhledejte místo';

  @override
  String get locationSearchEmpty => 'Nebyla nalezena žádná místa';

  @override
  String get settingsWallpaper => 'Tapeta';

  @override
  String get wallpaperNone => 'žádný';

  @override
  String get wallpaperDots => 'Tečky';

  @override
  String get wallpaperGrid => 'Mřížka';

  @override
  String get wallpaperLines => 'Čáry';

  @override
  String get wallpaperPhoto => 'Foto…';

  @override
  String get settingsFontFamily => 'Písmo';

  @override
  String get fontSystem => 'Systém';

  @override
  String get fontSerif => 'Serif';

  @override
  String get fontMono => 'Jednoprostorový';

  @override
  String get settingsFontSize => 'Velikost písma';

  @override
  String get fontSizeSmall => 'Malý';

  @override
  String get fontSizeMedium => 'Střední';

  @override
  String get fontSizeLarge => 'Velký';

  @override
  String get fontSizeExtraLarge => 'Extra velký';

  @override
  String get settingsLineSpacing => 'Řádkování';

  @override
  String get lineSpacingCompact => 'Kompaktní';

  @override
  String get lineSpacingNormal => 'Normální';

  @override
  String get lineSpacingRelaxed => 'Uvolněný';

  @override
  String get moodAssociationsTitle => 'Co ve mně vyvolává pocit…';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching ze $total záznamů';
  }

  @override
  String get videoRecord => 'Nahrajte video';

  @override
  String get videoChoose => 'Vyberte video';

  @override
  String get audioRecordTitle => 'Nahrajte hlasovou poznámku';

  @override
  String get audioChoose => 'Vyberte zvukový soubor';

  @override
  String get audioStart => 'Záznam';

  @override
  String get audioStop => 'Zastavit a uložit';

  @override
  String get audioPermissionDenied =>
      'Přístup k mikrofonu je vypnutý. Povolte to v nastavení systému.';

  @override
  String get mediaTooLarge => 'Toto video je pro připojení příliš velké.';

  @override
  String get mediaUnavailable =>
      'Tato příloha není na tomto zařízení dostupná.';

  @override
  String get widgetDone => 'Dnešní zápis je napsán';

  @override
  String get widgetPending => 'jaký jsi měl den?';

  @override
  String get widgetWrite => 'Napište';

  @override
  String get insertChecklist => 'Kontrolní seznam';

  @override
  String get insertNumberedList => 'Číslovaný seznam';

  @override
  String get insertTable => 'Tabulka';

  @override
  String get insertDivider => 'Dělič';

  @override
  String get insertCodeBlock => 'Blok kódu';

  @override
  String get journalSortTitle => 'Seřadit záznamy';

  @override
  String get journalSortUpdated => 'Naposledy aktualizováno';

  @override
  String get settingsTimeFormat => 'Formát času';

  @override
  String get settingsDayStart =>
      'Nové záznamy se počítají od předchozího dne do';

  @override
  String get settingsDayAskUntil => 'Pak se zeptejte, do kterého dne';

  @override
  String get settingsDayStartMidnight => 'Vypnuto';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'U každého záznamu je vedle času, kdy byl napsán, uveden den, ke kterému patří, a tento den můžete v editoru kdykoli změnit. Tyto hodiny pouze vybírají den pro nové záznamy, takže jejich změnou se nepřesune žádný existující záznam.';

  @override
  String get lateNightBadge => 'Psáno pozdě v noci, počítáno za předchozí den';

  @override
  String editorDayAsk(String time) {
    return 'Napsáno na $time. Na který den to je?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (včera)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (dnes)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'Napsáno $when';
  }

  @override
  String get timeFormat12 => '12 hodin';

  @override
  String get timeFormat24 => '24 hodin';

  @override
  String get settingsReminderDays => 'Připomeňte mi';

  @override
  String get locationRecent => 'Nedávná místa';

  @override
  String get shareImage => 'Sdílet obrázek';

  @override
  String get shareSaveImage => 'Uložit obrázek';

  @override
  String get shareSaved => 'Obrázek uložen';

  @override
  String get deletedTitle => 'Nedávno smazáno';

  @override
  String get deletedNone => 'V poslední době nebylo nic smazáno';

  @override
  String deletedHint(int days) {
    return 'Smazané záznamy zde zůstanou $days dní, poté budou vymazány.';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days dní zbývá';
  }

  @override
  String get deletedRestore => 'Obnovit';

  @override
  String get deletedDeleteForever => 'Smazat navždy';

  @override
  String get deletedDeleteForeverDescription =>
      'Záznam a jeho přílohy budou vymazány. Toto nelze vrátit zpět.';

  @override
  String get deletedEmpty => 'Prázdný';

  @override
  String get deletedEmptyDescription =>
      'Vymazat všechny položky v Nedávno smazané? Toto nelze vrátit zpět.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Náhodná procházka';

  @override
  String get randomSubtitle => 'Otevřete minulý záznam';

  @override
  String get randomNext => 'Další';

  @override
  String get randomAll => 'všechny';

  @override
  String get randomWithPhotos => 'S fotkami';

  @override
  String get randomGoodDays => 'Dobré dny';

  @override
  String get randomEmpty => 'Žádné záznamy k výběru';

  @override
  String get reviewWeekTitle => 'Tento týden';

  @override
  String get reviewWeekSubtitle => 'Váš dosavadní týden';

  @override
  String get reviewYearTitle => 'Tento rok';

  @override
  String get reviewEmpty => 'Zatím nic nenapsáno';

  @override
  String get reviewEntries => 'Příspěvky';

  @override
  String get reviewDaysWritten => 'Napsané dny';

  @override
  String get reviewWords => 'Slova';

  @override
  String get reviewPhotos => 'Fotografie';

  @override
  String get reviewLongestRun => 'Nejdelší běh dní';

  @override
  String get reviewAverageMood => 'Průměrná nálada';

  @override
  String get reviewFavorites => 'Nejčastěji';

  @override
  String get reviewByMonth => 'Podle měsíce';

  @override
  String get reviewHighlight => 'Zvýrazněte';

  @override
  String get yearInPixels => 'Rok v pixelech';

  @override
  String get capsuleSeal => 'Utěsnění jako časová kapsle';

  @override
  String get capsuleTitle => 'Časová kapsle';

  @override
  String capsuleOpensOn(Object date) {
    return 'Otevírá se na $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Napsáno na $date';
  }

  @override
  String get capsuleOpenEarly => 'Otevřeno brzy';

  @override
  String get capsuleOpenEarlyDescription =>
      'Kapsle se nyní otevře a zůstane otevřená.';

  @override
  String get capsuleOpened => 'Časová kapsle otevřena';

  @override
  String get templateMorningName => 'Ranní stránky';

  @override
  String get templateMorningDescription => 'Nastavte den za tři minuty';

  @override
  String get templateMorningText =>
      '## Tři věci, které chci dnes udělat dobře\n1. \n2. \n3. \n\n## Něco, na co se těším\n\n## Poznámka pro sebe\n';

  @override
  String get templateEveningName => 'Večerní recenze';

  @override
  String get templateEveningDescription => 'Uzavřete den tím, co se povedlo';

  @override
  String get templateEveningText =>
      '## Dnes tři dobré věci\n1. \n2. \n3. \n\n## Co jsem se naučil\n\n## Co může být zítra lepší\n';

  @override
  String get routineMorning => 'Dobré ráno';

  @override
  String get routineEvening => 'Večerní recenze';

  @override
  String get settingsRoutinePrompts => 'Ranní a večerní výzvy';

  @override
  String get settingsRoutinePromptsHint =>
      'Navrhněte ranní nebo večerní šablonu ve Stories';

  @override
  String get checkInTitle => 'Rychlé odbavení';

  @override
  String get checkInSubtitle => 'Nálada ve dvou kohoutcích';

  @override
  String get checkInMood => 'jak se cítíš?';

  @override
  String get checkInActivity => 'co to děláš?';

  @override
  String get checkInNote => 'Řádek o tom (volitelné)';

  @override
  String get checkInSave => 'Uložit';

  @override
  String editorWordCount(int words, int characters) {
    return 'Slova $words · $characters znaky';
  }

  @override
  String get coachProgramEverydayTagline => 'Všímejte si malých věcí za den.';

  @override
  String get coachProgramReflectTagline => 'Zpomalte a poslouchejte sami sebe.';

  @override
  String get coachDuration => 'Doba trvání';

  @override
  String get coachInterval => 'Interval';

  @override
  String get coachDifficulty => 'Obtížnost';

  @override
  String get coachIntervalDaily => 'Denně';

  @override
  String get coachIntervalWeekly => 'Týdenní';

  @override
  String get coachDifficultyBeginner => 'Začátečník';

  @override
  String get coachDifficultyIntermediate => 'Střední';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dní',
      one: '$count den',
      many: '$count dne',
      few: '$count dny',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count týdnů',
      one: '$count týden',
      many: '$count týdne',
      few: '$count týdny',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'Den $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Týden $n';
  }

  @override
  String get coachEnroll => 'Zaregistrujte se';

  @override
  String get coachEndProgram => 'Ukončení programu';

  @override
  String get coachAuthor => 'Autor';

  @override
  String get coachAuthorBio => 'Výzvy napsané pro tuto aplikaci.';

  @override
  String get coachEnrolledTip =>
      'Vše nastaveno! Vaše otázky se zobrazí ve Stories.';

  @override
  String get coachGoToStories => 'Přejděte na Příběhy';

  @override
  String get coachAnswerHint => 'Napište svou odpověď…';

  @override
  String get storyWrapUp => 'To je pro dnešek vše.';

  @override
  String get storyTapToClose => 'Klepnutím zavřete';

  @override
  String get coachAnswerDone => 'Hotovo';

  @override
  String get coachAnswered => 'Přijato, klepnutím otevřete';

  @override
  String get coachAnsweredEarlier => 'Odpovězeno';

  @override
  String get locationLocating => 'Vyhledávání…';

  @override
  String get locationPickPlace => 'Vyberte si místo';

  @override
  String get locationPlacesHint => 'Adresa nebo název místa';

  @override
  String get locationCustom => 'Vlastní místo';

  @override
  String get locationCurrent => 'Aktuální poloha';

  @override
  String get locationSaved => 'Uložená místa';

  @override
  String get locationSearchResults => 'Výsledky vyhledávání';

  @override
  String get locationNearby => 'Blízká místa';

  @override
  String get locationRename => 'Přejmenovat';

  @override
  String get locationSavePlace => 'Uložit místo';

  @override
  String get locationUnsavePlace => 'Odebrat z uložených míst';

  @override
  String get shareAs => 'Sdílet jako…';

  @override
  String get shareAsImage => 'Obrázek';

  @override
  String get shareAsZip => 'ZIP s originálním médiem';

  @override
  String get shareAsPlainText => 'Prostý text';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Vítejte v AID Diary';

  @override
  String get onboardWelcomeText =>
      'Začněte zde nebo připojte toto zařízení k zařízení, které již používáte.';

  @override
  String get onboardStart => 'Začněte psát';

  @override
  String get helpFaq => 'Často kladené otázky';

  @override
  String get helpFaq1Q => 'Kde je uložen můj deník?';

  @override
  String get helpFaq1A =>
      'Váš deník je uložen v tomto zařízení. Do ostatních zařízení nebo úložiště se dostane pouze tehdy, když povolíte synchronizaci, sdílení nebo export. Synchronizace je šifrována end-to-end.';

  @override
  String get helpFaq2Q =>
      'Jak si ponechám kopii nebo přesunu na nové zařízení?';

  @override
  String get helpFaq2A =>
      'Připojte se ke stávajícímu zařízení v Nastavení → Data a úložiště → Synchronizovat a potvrďte autorizaci na zařízení, které má váš deník. Obě zařízení zůstávají použitelná. Můžete také vytvořit zálohu a obnovit ji na jiném zařízení.';

  @override
  String get helpFaq3Q => 'Mohu přidávat záznamy z jiných aplikací pro deník?';

  @override
  String get helpFaq3A =>
      'Ano: v Nastavení → Data a úložiště importujte exporty ze Daylio, Diarium, Diaro, DayBook, My Brain, OneShot a Pixels nebo export JSON.';

  @override
  String get helpFaq4Q => 'Jak koučovací programy fungují?';

  @override
  String get helpFaq4A =>
      'Zaregistrujte se do programu na stránce Coach. Každý den nebo týden čeká ve Stories nová otázka; vaše odpověď se uloží jako záznam.';

  @override
  String get helpFaq5Q => 'Co když zapomenu heslo?';

  @override
  String get helpFaq5A =>
      'Přístupový kód nelze obnovit, proto si uschovejte zálohu svého deníku.';

  @override
  String get helpPrivacy => 'soukromí';

  @override
  String get helpPrivacyText =>
      'Obsah deníku a média zůstanou v tomto zařízení, pokud nepovolíte šifrovanou synchronizaci nebo je nesdílíte/exportujete. Mapy, vyhledávání míst a počasí používají nakonfigurované služby a odesílají polohu nebo vyhledávací dotaz potřebný pro tento požadavek, nikoli text z deníku.';

  @override
  String get photoMetaTitle => 'Použít detaily fotky?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Počítat tento záznam pro $date a nastavit jeho místo na $place, jak je zaznamenáno na fotografii?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Počítat tento záznam pro $date, kdy byla fotografie pořízena?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Nastavit místo tohoto záznamu na $place, kde byla fotografie pořízena?';
  }

  @override
  String get photoMetaApply => 'Použijte je';

  @override
  String get quickWriteTitle => 'Rychlé psaní';

  @override
  String get quickWriteText => 'Klepnutím zahájíte nový záznam.';

  @override
  String get settingsQuickWriteTitle => 'Rychlé zápisy do notifikací';

  @override
  String get settingsQuickWriteDescription =>
      'Ponechte si upozornění, které otevře nový záznam.';

  @override
  String get settingsNudgesTitle => 'Po tichém protažení mě šťouchni';

  @override
  String settingsNudgesDescription(int days) {
    return 'Jemné připomenutí, když jste $days dní nepsali.';
  }

  @override
  String get nudgeTitle => 'Už je to nějaký čas';

  @override
  String get nudgeMonday => 'Nový týden: na co se těšíte?';

  @override
  String get nudgeTuesday => 'Dva řádky stačí. jak se dnes máš?';

  @override
  String get nudgeWednesday => 'V polovině týdne. Co dosud vyniklo?';

  @override
  String get nudgeThursday =>
      'Něco malého, co stojí za to si z dneška ponechat?';

  @override
  String get nudgeFriday => 'Týden končí. Všimněte si jednoho dobrého momentu.';

  @override
  String get nudgeSaturday => 'Pomalá sobota je dobrý den na psaní.';

  @override
  String get nudgeSunday => 'Podívejte se zpět na týden před koncem.';

  @override
  String get photoWidgetEmpty =>
      'Zde se zobrazí fotografie, které přidáte k záznamům.';

  @override
  String get channelReminders => 'Připomenutí';

  @override
  String get channelOnThisDay => 'V tento den';

  @override
  String get channelCoach => 'Trenér nabádá';

  @override
  String get channelNudges => 'Pošťuchování po klidných dnech';

  @override
  String get channelQuickWrite => 'Rychlé psaní';

  @override
  String get channelBackup => 'Zálohy';

  @override
  String get formatJsonExport => 'JSON (export AID Diary)';

  @override
  String get aboutModifiedNotice =>
      'Upravená verze Daily You od Demiza a přispěvatelů. Není to oficiální aplikace Daily You.';

  @override
  String get toolbarPhotos => 'Přidejte fotky';

  @override
  String get toolbarMedia => 'Fotografie a videa';

  @override
  String get mediaFromGallery => 'Vyberte si z galerie';

  @override
  String get mediaFromFiles => 'Vyberte ze souborů';

  @override
  String get editorLeaveTitle => 'Uložit tento záznam?';

  @override
  String get editorLeaveDiscard => 'Neukládat';

  @override
  String get editorTitleHint => 'Název';

  @override
  String get editorLocating => 'Vyhledávání…';

  @override
  String get toolbarVideo => 'Video';

  @override
  String get toolbarAudio => 'Hlasová poznámka';

  @override
  String get toolbarTags => 'Tagy';

  @override
  String get toolbarBulletList => 'Seznam s odrážkami';

  @override
  String get toolbarHeading => 'Směr';

  @override
  String get toolbarBold => 'Tučné';

  @override
  String get toolbarItalic => 'kurzíva';

  @override
  String get toolbarHighlight => 'Zvýrazněte';

  @override
  String get toolbarStrikethrough => 'Přeškrtnutí';

  @override
  String get toolbarQuote => 'Citace';

  @override
  String get toolbarLink => 'Odkaz';

  @override
  String get toolbarInsert => 'Vložit';

  @override
  String get toolbarUndo => 'Vrátit zpět';

  @override
  String get toolbarRedo => 'Znovu';

  @override
  String get toolbarInsertDate => 'Vložte datum';

  @override
  String get toolbarInsertTime => 'Vložte čas';

  @override
  String get settingsSyncTitle => 'Cloudová synchronizace';

  @override
  String get syncOffDescription =>
      'Udržujte tento deník stejný na všech svých zařízeních prostřednictvím serveru Google Drive nebo WebDAV, jako je Nextcloud, Synology nebo Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'Synchronizujte se Google Drive';

  @override
  String get syncOrWebDav => 'Nebo server WebDAV';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn =>
      'Jste přihlášeni. Můžete se vrátit na AID Diary.';

  @override
  String get syncGoogleSignInAgain =>
      'Google potřebuje, abyste se znovu přihlásili.';

  @override
  String get syncSignInAgain => 'Znovu se přihlaste';

  @override
  String get settingsCommandLineTitle => 'Příkazový řádek';

  @override
  String get commandLineToggle => 'Rozhraní příkazového řádku';

  @override
  String get commandLineToggleHint =>
      'Umožňuje příkazu aid a dalším programům na tomto zařízení používat příkazy aplikace.';

  @override
  String get commandLineAlwaysOn => 'Ve vývoji se neustále pracuje.';

  @override
  String commandLineListening(int port) {
    return 'Poslech na portu $port';
  }

  @override
  String get commandPaletteTitle => 'Všechny příkazy';

  @override
  String get commandPaletteSearch => 'Hledat příkazy';

  @override
  String get commandPaletteRun => 'Spustit';

  @override
  String get commandPaletteConfirm =>
      'To nelze jednoduše vrátit zpět. spustit to?';

  @override
  String syncReceiving(int done, int total) {
    return 'Příjem $done z $total…';
  }

  @override
  String syncSending(int done, int total) {
    return 'Odesílání $done z $total…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'Přístup k Google Drive nebyl povolen. Připojte se znovu a zaškrtněte Google Drive na stránce Google.';

  @override
  String get syncEntryUnsynced =>
      'Nesynchronizováno: poslední synchronizace neproběhla';

  @override
  String get syncUseOfficial => 'Použijte synchronizační server AID';

  @override
  String get syncServer => 'Adresa serveru';

  @override
  String get syncUsername => 'Uživatelské jméno';

  @override
  String get syncPassword => 'Heslo';

  @override
  String get syncConnect => 'Připojte se';

  @override
  String get syncConnecting => 'Připojování…';

  @override
  String get syncSignInFailed =>
      'Nelze se přihlásit. Zkontrolujte adresu, uživatelské jméno a heslo.';

  @override
  String syncConnectFailed(String error) {
    return 'Nelze se připojit: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Spusťte synchronizaci';

  @override
  String get syncNewSpaceDescription =>
      'Synchronizovaný deník zde zatím není. Tento deník bude nahrán, end-to-end zašifrován pomocí klíče, který zůstane na vašich zařízeních.';

  @override
  String get syncJoinTitle => 'Připojte se k synchronizovanému deníku';

  @override
  String get syncWrongKey =>
      'Tento obnovovací kód neotevře synchronizovaný deník.';

  @override
  String syncLastSynced(String time) {
    return 'Poslední synchronizace $time';
  }

  @override
  String get syncNever => 'Dosud nesynchronizováno';

  @override
  String get syncSyncing => 'Synchronizace…';

  @override
  String syncFailed(String error) {
    return 'Poslední synchronizace se nezdařila: $error';
  }

  @override
  String get syncLocked =>
      'Synchronizovaný deník nyní patří do jiných zařízení nebo byl spuštěn znovu. Spárujte s jedním z nich nebo použijte obnovovací kód pro pokračování synchronizace.';

  @override
  String get syncNow => 'Synchronizovat nyní';

  @override
  String get syncUnlock => 'Odemknout';

  @override
  String get syncEncrypted => 'End-to-end šifrováno';

  @override
  String get syncDisconnect => 'Zastavit synchronizaci';

  @override
  String get syncDisconnectDescription =>
      'Toto zařízení přestane synchronizovat. Zdejší deník a synchronizovaná kopie zůstanou tak, jak jsou.';

  @override
  String get syncOwnRecoveryPassword => 'Použít mé vlastní heslo pro obnovení';

  @override
  String get syncRecoveryPassword => 'Heslo pro obnovení';

  @override
  String get syncRecoveryPasswordRepeat => 'Opakujte heslo pro obnovení';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Použijte alespoň $min znaků';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'Hesla se liší';

  @override
  String get syncRecoveryCode => 'Obnovovací kód';

  @override
  String get syncRecoveryCodeTitle => 'Uložte si kód pro obnovení';

  @override
  String get syncRecoveryCodeDescription =>
      'Pokud se ztratí každé vaše zařízení, tento kód obnoví váš synchronizovaný deník. Uchovávejte jej ve správci hesel nebo na papíře. Zobrazuje se pouze jednou.';

  @override
  String get syncRecoveryCodeCopied => 'Obnovovací kód byl zkopírován';

  @override
  String get syncRecoveryCodeSaved => 'Uložil jsem to';

  @override
  String get syncJoinNeedsKey =>
      'Tento synchronizovaný deník patří vašim dalším zařízením. Spárujte s jedním z nich nebo použijte obnovovací kód. Položky na tomto zařízení se do něj přidají.';

  @override
  String get syncPairDevice => 'Spárujte se zařízením';

  @override
  String get syncUseRecoveryCode => 'Použijte obnovovací kód';

  @override
  String get syncAddDevice => 'Přidejte zařízení';

  @override
  String get syncChangeRecoveryCode => 'Změňte kód pro obnovení';

  @override
  String get syncChangeRecoveryDescription =>
      'Nový kód nahradí stávající, který přestane fungovat. Vaše data a další zařízení zůstanou tak, jak jsou.';

  @override
  String get syncNewRandomCode => 'Nový náhodný kód';

  @override
  String get syncRecoveryCodeChanged => 'Kód obnovení byl změněn';

  @override
  String get syncResetSpace => 'Spusťte synchronizovaný deník znovu';

  @override
  String get syncResetSpaceDescription =>
      'Pouze když jej již neotevře žádné zařízení a žádný kód pro obnovení: synchronizovaná kopie je nahrazena deníkem na tomto zařízení pod tlačítky tohoto zařízení. Vaše ostatní zařízení se poté znovu spárují.';

  @override
  String get syncPairTitle => 'Spárujte zařízení';

  @override
  String get syncPairShow => 'Ukažte kód';

  @override
  String get syncPairEnter => 'Zadejte kód';

  @override
  String get syncPairShowHint =>
      'Na druhém zařízení otevřete Spárovat zařízení, zvolte Zadejte kód a zadejte nebo naskenujte tento.';

  @override
  String get syncPairEnterHint =>
      'Zadejte kód zobrazený na druhém zařízení nebo jej naskenujte.';

  @override
  String get syncPairCode => 'Párovací kód';

  @override
  String get syncPairScan => 'Skenujte';

  @override
  String get syncPairStart => 'Spárovat';

  @override
  String get syncPairWaiting => 'Čekání na další zařízení…';

  @override
  String syncPairDone(String device) {
    return 'Spárováno s $device';
  }

  @override
  String get syncPairWrongCode =>
      'Kód se neshodoval. Ukažte nový kód a zkuste to znovu.';

  @override
  String get syncPairNoOffer =>
      'Tento kód nezobrazuje žádné zařízení. Možná vypršela platnost.';

  @override
  String get syncPairTimedOut => 'Druhé zařízení neodpovědělo včas.';

  @override
  String get syncPairNeither =>
      'Žádné zařízení zatím nemá nastaven tento synchronizovaný deník.';

  @override
  String get syncPairBoth =>
      'Obě zařízení již tento synchronizovaný deník otevírají.';

  @override
  String syncPairFailed(String error) {
    return 'Párování se nezdařilo: $error';
  }

  @override
  String get syncMediaPending =>
      'Diář synchronizován · některá média se stále přenášejí';

  @override
  String get syncWaitingForDevices =>
      'Diář synchronizován · čeká, až jiné zařízení přenese média';

  @override
  String get syncCacheNotice =>
      'Cloudová média jsou dočasná. Uchovávejte originály ve svých zařízeních; synchronizace není záloha.';

  @override
  String get paperTitle => 'Dopisní papír';

  @override
  String get paperPlain => 'Obyčejný';

  @override
  String get paperLined => 'Podšité';

  @override
  String get paperGrid => 'Mřížka';

  @override
  String get paperTinted => 'Tónovaná';

  @override
  String get paperDecorationTitle => 'Dekorace';

  @override
  String get paperDecorationNone => 'žádný';

  @override
  String get paperDecorationBotanical => 'Listy';

  @override
  String get paperDecorationStars => 'hvězdy';

  @override
  String get paperDecorationWashi => 'Washi páska';

  @override
  String get themeDarkChoice => 'Tmavý vzhled';

  @override
  String get themeDarkSame => 'Postupujte podle světelné palety';

  @override
  String get themeDarkCustom => 'Samostatná paleta';

  @override
  String get themeDarkAccent => 'Tmavá akcentní barva';

  @override
  String get themeColorTeal => 'Modrozelená';

  @override
  String get themeColorCyan => 'azurová';

  @override
  String get themeColorIndigo => 'Indigová';

  @override
  String get themeColorCoral => 'Korálová';

  @override
  String get themeColorOlive => 'Olivový';

  @override
  String get themeColorSlate => 'Břidlice';

  @override
  String get drawingTitle => 'Kreslení';

  @override
  String get drawingPen => 'Pero';

  @override
  String get drawingEraser => 'Guma';

  @override
  String get drawingUndo => 'Vrátit zpět';

  @override
  String get drawingClear => 'Jasný';

  @override
  String get drawingWidth => 'Šířka pera';

  @override
  String get drawingStylusOnly => 'Pouze stylus';

  @override
  String get drawingDiscardTitle => 'Zahodit kresbu?';

  @override
  String get drawingDiscardBody => 'Tento výkres nebyl uložen.';

  @override
  String get drawingSaveError => 'Výkres se nepodařilo uložit.';

  @override
  String get syncNetworkTitle => 'Diagnostika sítě';

  @override
  String get syncNetworkRefresh => 'Obnovit';

  @override
  String get syncNetworkSelectedRoute => 'Aktuální cesta';

  @override
  String get syncNetworkAvailableRoutes => 'Dostupné cesty';

  @override
  String get syncNetworkSignaling => 'Připojení adresáře zařízení';

  @override
  String get syncNetworkRelayRemaining => 'Zbývající štafeta';

  @override
  String get syncNetworkIcePair => 'Kandidáti na přímé připojení';

  @override
  String get syncNetworkPeerTrusted => 'Ověřené zařízení';

  @override
  String get syncNetworkNoRoute => 'Čekání na spojení';

  @override
  String get syncNetworkUnavailable => 'Diagnostika není k dispozici';

  @override
  String get syncMediaCopiesTitle => 'Doručování médií a kopií';

  @override
  String get syncMediaPendingCount => 'Čekání na přenos';

  @override
  String get syncMediaDurableCount => 'Doručeno do osobního skladu';

  @override
  String get syncMediaTemporaryCount => 'Dočasné nebo nepotvrzené kopie';

  @override
  String get syncMediaReceiptExplanation =>
      'Tyto počty popisují dokončené dodávky, nikoli nový audit přežívajících záloh.';

  @override
  String get syncMediaCacheExplanation =>
      'Platnost dočasného cloudového média může vypršet. Uschovejte si originály nebo samostatnou zálohu.';

  @override
  String get momentsTitle => 'Fotografické momentky';

  @override
  String get momentsHint =>
      'Najděte skupiny pomocí místních fotografických časů a volitelných souřadnic. Fotografie jsou připojeny pouze v případě, že vyberete kartu.';

  @override
  String get momentsScan => 'Najděte okamžiky';

  @override
  String get momentsChooseFolder => 'Vyberte složku s fotografiemi';

  @override
  String get momentsLocation => 'Zahrnout umístění fotografií';

  @override
  String get momentsEmpty => 'Žádné nedávné skupiny fotografií.';

  @override
  String get momentsCreate => 'Napište o těchto fotkách';

  @override
  String get momentsDismiss => 'Odmítnout';

  @override
  String get momentsError => 'Nelze přečíst místní fotografie.';

  @override
  String get momentsCreated => 'Fotka byla vytvořena.';

  @override
  String get momentsPermission =>
      'Povolte přístup k fotkám, abyste našli místní návrhy.';

  @override
  String get momentsScope =>
      'Pouze nejnovější fotografie; maximálně 500 fotografií a 20 fotografií na kartu.';

  @override
  String momentsPhotoCount(int count) {
    return 'Fotografie $count';
  }

  @override
  String get nearbyTitle => 'Připojte zařízení';

  @override
  String get nearbySend => 'Autorizujte další zařízení';

  @override
  String get nearbyReceive => 'Připojte se ke stávajícímu zařízení';

  @override
  String get nearbyInstructions =>
      'Připojte obě zařízení ke stejnému Wi-Fi nebo ke vzájemnému hotspotu. Potvrďte autorizaci na stávajícím zařízení; obě zařízení zůstávají použitelná. Není vyžadován žádný internet.';

  @override
  String get nearbyCompare =>
      'Před schválením tento kód porovnejte na obou zařízeních.';

  @override
  String get nearbyConfirm => 'Kódy se shodují';

  @override
  String get nearbyScan => 'Naskenujte kód druhého zařízení';

  @override
  String get nearbyPaste => 'Vložit pozvánku';

  @override
  String get nearbyWaiting => 'Čekání na schválení na druhém zařízení';

  @override
  String get nearbyWorking =>
      'Autorizace a synchronizace vašeho deníku a příloh…';

  @override
  String get nearbyPending =>
      'Některé přílohy stále vyžadují synchronizaci. Ponechte druhé zařízení online a zkuste to znovu.';

  @override
  String get nearbyComplete =>
      'Zařízení připojeno; diář a přílohy synchronizovány';

  @override
  String get nearbyFailed =>
      'Připojení nebylo dokončeno. Zkontrolujte místní připojení a zkuste to znovu.';

  @override
  String get nearbyEmptyRequired =>
      'Použijte zařízení s prázdným deníkem, které ještě není připojeno k synchronizaci.';

  @override
  String get nearbyRetry => 'Pokračujte v synchronizaci';

  @override
  String get nearbyWifi => 'Nastavení Wi-Fi';

  @override
  String get nearbyHotspot => 'Nastavení hotspotu';

  @override
  String get nearbyKeepOpen =>
      'Ponechte tuto stránku otevřenou, dokud nové zařízení nedokončí. Platnost pozvánky vyprší po dvou minutách.';

  @override
  String get syncDevicesTitle => 'Autorizovaná zařízení';

  @override
  String get syncDevicesDescription =>
      'K tomuto účtu AID mají přístup pouze schválená zařízení. Odvolání zařízení zablokuje server, ale nemůže vymazat hlavní klíč nebo deník, které jsou na něj již zkopírovány.';

  @override
  String get syncDeviceRequest =>
      'Ukažte tento autorizační QR na schváleném zařízení';

  @override
  String get syncDeviceAuthorize => 'Autorizujte zařízení';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Naskenujte nebo vložte žádost o autorizaci nového zařízení.';

  @override
  String get syncDeviceRevoke => 'Odvolat';

  @override
  String get syncDeviceRotate => 'Otočte podpisový klíč tohoto zařízení';

  @override
  String get syncDeviceCheck => 'Zkontrolujte autorizaci';

  @override
  String get syncDeviceHardware => 'Hardwarově podporovaný podpisový klíč';

  @override
  String get syncDeviceSoftware => 'Neexportovatelný softwarový podpisový klíč';

  @override
  String get syncDeviceUnavailable =>
      'Autorizace zařízení není k dispozici. Schvalte toto zařízení z jiného autorizovaného zařízení a zkuste to znovu.';

  @override
  String get syncDeviceRevoked => 'Odvoláno';

  @override
  String get syncDeviceLocal => 'Toto zařízení';

  @override
  String get cloudTrafficTitle =>
      'Měsíční kvóta cloudového přenosu dat pro mediální soubory';

  @override
  String get cloudTrafficLimit => 'Měsíční kvóta přenosu dat';

  @override
  String get cloudTrafficUsed => 'Použitý přenos dat';

  @override
  String get cloudTrafficRemaining => 'Zbývá datový přenos';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'Kvóta přenosu dat resetuje $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'Kvóta cloudového přenosu dat pro mediální soubory byla vyčerpána. Chybějící mediální soubory se automaticky synchronizují, jakmile bude k dispozici přímé připojení nebo se kvóta resetuje.';

  @override
  String get cloudTrafficExplanation =>
      'Tuto kvótu přenosu dat sdílí ukládání mediálních souborů do mezipaměti a živé přenosy. Přímá připojení jej nespotřebovávají. Text v deníku a zprávy o kontrole připojení mají samostatné malé denní limity.';

  @override
  String get appearanceThemeSection => 'Téma aplikace';

  @override
  String get appearancePaperSection => 'Deník papír';

  @override
  String get appearanceTypographySection => 'Text deníku';

  @override
  String get appearancePreferencesSection => 'Obecné preference';

  @override
  String get themeSystemAccentHint =>
      'Místo vlastních barev používá systémovou paletu. Vypněte jej a vyberte si vlastní.';

  @override
  String get syncDeviceNameSaveFailed =>
      'Název zařízení nelze uložit. Zkuste to prosím znovu.';

  @override
  String get nearbyConnectionHelp => 'Pomoc s připojením';

  @override
  String get syncAllSynced => 'Vše synchronizováno';

  @override
  String get syncDetailsTitle => 'Podrobnosti synchronizace';

  @override
  String get syncMore => 'Více možností';

  @override
  String get syncDeviceName => 'Název zařízení';

  @override
  String get syncDeviceNameHint => 'Například: Můj tablet';

  @override
  String get syncDeviceNameInvalid => 'Použijte 1 až 32 znaků';

  @override
  String get syncDeviceKeyDetails => 'Bezpečnostní detaily';

  @override
  String get syncConnectionProblem =>
      'Momentálně nelze synchronizovat. Probíhá automatický pokus znovu.';

  @override
  String get syncCopyComplete =>
      'Kompletní kopie vašeho deníku a mediálních souborů';

  @override
  String get syncCopyPartial => 'Některá média stále chybí';

  @override
  String get syncCopyOlder => 'Nové změny čekají na synchronizaci';

  @override
  String get syncCopyUnavailable =>
      'Podrobnosti o kopii nejsou k dispozici. Zkuste to znovu později.';

  @override
  String get syncCopyLastKnown =>
      'Ostatní zařízení ukazují svou poslední potvrzenou kopii. Offline zařízení nyní nelze kontrolovat.';

  @override
  String get syncCopyTemporary =>
      'Dočasná mezipaměť. Originály si ponechte na svých zařízeních.';

  @override
  String get syncCopyStorage =>
      'Vaše synchronizační úložiště. Dokončená nahrání médií jsou uvedena v diagnostice.';

  @override
  String syncCopyChecked(String time) {
    return 'Naposledy potvrzeno $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Přenos dat zbývající tento měsíc: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Začněte zde';

  @override
  String get onboardConnect => 'Připojte se ke stávajícímu zařízení';

  @override
  String get onboardFailed =>
      'Nastavení nebylo možné dokončit. Váš deník je v bezpečí; zkuste to prosím znovu.';

  @override
  String get tutorialTitle => 'Jak používat deník';

  @override
  String get tutorialWriteTitle => 'Napište svůj první záznam do deníku';

  @override
  String get tutorialWriteText =>
      'Klepnutím na + napište záznam do deníku. Přidejte volitelný název, vyberte datum deníku a klepnutím na zaškrtnutí uložte. Záznam v deníku můžete kdykoli znovu upravit.';

  @override
  String get tutorialMediaTitle => 'Přidejte fotografie, zvuk nebo rukopis';

  @override
  String get tutorialMediaText =>
      'Pomocí + v editoru deníku můžete připojit fotografie, videa nebo hlasový záznam nebo otevřít plátno pro psaní rukou. Tyto přílohy se ukládají se záznamem v deníku.';

  @override
  String get tutorialReviewTitle => 'Najděte si znovu den';

  @override
  String get tutorialReviewText =>
      'Procházejte svůj diář nebo kalendář, prohledávejte své psaní a organizujte záznamy pomocí značek. Stránky Média a Atlas vám umožňují najít minulé záznamy podle fotografie nebo umístění.';

  @override
  String get tutorialSyncTitle => 'Používejte více než jedno zařízení';

  @override
  String get tutorialSyncText =>
      'V Nastavení → Data a úložiště → Synchronizace se připojte ke stávajícímu zařízení a potvrďte autorizaci na tomto zařízení. Obě zařízení mohou deník nadále používat. Nejprve se synchronizuje text deníku. Mediální soubory se synchronizují dále, když to síťové připojení a zbývající kvóta přenosu dat dovolí.';

  @override
  String get tutorialPrivacyTitle => 'Udržujte svůj deník v bezpečí';

  @override
  String get tutorialPrivacyText =>
      'Záznamy v deníku zůstanou na tomto zařízení, pokud nepovolíte synchronizaci, sdílení nebo export. Synchronizace je šifrována end-to-end. V Nastavení můžete také nastavit přístupový kód aplikace, vytvořit zálohy a znovu otevřít tento výukový program.';

  @override
  String get editorDiaryDay => 'Den deníku';

  @override
  String get editorDiaryDayPicker =>
      'Den deníku · Ke kterému dni tento záznam patří?';

  @override
  String editorCreatedAt(String time) {
    return 'Vytvořeno $time';
  }

  @override
  String get editorDiaryDayHint =>
      'Den, ke kterému tento záznam patří. Jeho změna nezmění čas vytvoření záznamu.';

  @override
  String get hiddenDiaryTitle => 'Skryté zápisy';

  @override
  String get hiddenDiaryHide => 'Skrýt zápis';

  @override
  String get hiddenDiaryShow => 'Odkrýt zápis';

  @override
  String get hiddenDiaryEmpty => 'Žádné skryté zápisy';

  @override
  String get hiddenDiaryUnlock => 'Odemknout skryté zápisy';

  @override
  String get hiddenDiaryAuthHint =>
      'Použijte zámek aplikace nebo obrazovky zařízení.';

  @override
  String hiddenDiaryWhere(String path) {
    return 'Skryto. Znovu zobrazit lze v: $path';
  }

  @override
  String get noteKeep => 'Uložit';

  @override
  String get noteComment => 'Komentovat';

  @override
  String get noteCommentHint => 'Napiš svému minulému já';

  @override
  String get noteKept => 'Úryvek uložen';

  @override
  String get notesPassages => 'Uložené úryvky';

  @override
  String get notesComments => 'Komentáře';

  @override
  String get noteDeleteConfirm => 'Smazat tuto poznámku?';

  @override
  String get editPastTitle => 'Upravit minulou vzpomínku?';

  @override
  String get editPastBody =>
      'Tento záznam je z dřívějšího dne. Chcete-li na něj odpovědět, označte text a uložte nebo okomentujte jej.';

  @override
  String get editPastDontAsk => 'Už se neptat';

  @override
  String get editPastEdit => 'Přesto upravit';

  @override
  String noteOnEntry(String date) {
    return 'K záznamu z $date';
  }

  @override
  String get settingsConfirmEditPast => 'Ptát se před úpravou minulých záznamů';

  @override
  String get settingsCompressPhotos => 'Komprimovat nové fotky';

  @override
  String get settingsCompressPhotosHint =>
      'Ukládat nové fotky jako WebP o velikosti asi 1 MB. Vypnuto zachová originály.';

  @override
  String get compressExistingTitle => 'Komprimovat stávající fotky';

  @override
  String compressExistingBody(int count, String size) {
    return '$count fotek zabírá $size. Fotky nad asi 1 MB se změní na WebP o asi 1 MB. Tím se nahradí a nelze to vrátit; originály si uložte jinde, pokud je chcete.';
  }

  @override
  String get compressExistingAction => 'Komprimovat';

  @override
  String compressExistingDone(int count, String size) {
    return 'Zkomprimováno $count fotek, ušetřeno $size';
  }

  @override
  String get commentExpand => 'Rozbalit';

  @override
  String get refAdd => 'Citovat záznam';

  @override
  String get refMissing => 'Tento záznam už neexistuje';

  @override
  String get moodClear => 'Vymazat náladu';

  @override
  String get scrollToTop => 'Zpět nahoru';

  @override
  String get feedbackTitle => 'Zpětná vazba';

  @override
  String get feedbackHint => 'Popište problém nebo návrh';

  @override
  String get feedbackGithub => 'Problém na GitHubu';

  @override
  String get feedbackEmail => 'Poslat e-mail';

  @override
  String get feedbackCopy => 'Kopírovat text';

  @override
  String get feedbackLaunchFailed =>
      'Aplikaci nelze otevřít. Zkopírujte text a použijte e-mail níže.';

  @override
  String get feedbackCopied => 'Text zkopírován';
}
