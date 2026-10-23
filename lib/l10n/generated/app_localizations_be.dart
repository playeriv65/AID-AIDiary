// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Belarusian (`be`).
class AppLocalizationsBe extends AppLocalizations {
  AppLocalizationsBe([String locale = 'be']) : super(locale);

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => 'Колер тэмы';

  @override
  String get themeColorHint => 'Выберыце колер для гэтай палітры.';

  @override
  String get themeColorBlue => 'Нябесна-блакітны';

  @override
  String get themeColorGreen => 'Лес зялёны';

  @override
  String get themeColorBrown => 'Цёплая кава';

  @override
  String get themeColorPurple => 'Лаванда';

  @override
  String get themeColorRose => 'Пыльная ружа';

  @override
  String get themeColorAmber => 'Бурштын';

  @override
  String get themeColorPreview => 'Кожны дзень патроху';

  @override
  String get themeTintBackgroundTitle => 'Адценне фону тэматычным колерам';

  @override
  String get themeTintBackgroundHint =>
      'Выключыце для нейтральнага шэрага фону; кнопкі захоўваюць абраны колер.';

  @override
  String get dailyReminderTitle => 'Занатуй сёння!';

  @override
  String get dailyReminderDescription => 'Зрабі свой штодзённы запіс…';

  @override
  String get actionTakePhoto => 'Сфатаграфаваць';

  @override
  String get flashbacksTitle => 'Флэшбэкі';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Выключыце дрэнныя дні';

  @override
  String get flashbackGoodDay => 'Добры дзень';

  @override
  String get flashbackRandomDay => 'Выпадковы дзень';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count тыдня таму',
      one: '$count тыдзень таму',
      many: '$count тыдняў таму',
      few: '$count тыдні таму',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count месяца таму',
      one: '$count месяц таму',
      many: '$count месяцаў таму',
      few: '$count месяцы таму',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count года таму',
      one: '$count год таму',
      many: '$count гадоў таму',
      few: '$count гады таму',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'У гэты дзень';

  @override
  String get searchLogsHint => 'Шукаць запісы ў дзённіку…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дзённікавых запісаў',
      one: '$count дзённікавы запіс',
      many: '$count дзённікавых запісаў',
      few: '$count дзённікавыя запісы',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня',
      one: '$count дзень',
      many: '$count дзён',
      few: '$count дні',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count слова',
      one: '$count слова',
      many: '$count слоў',
      few: '$count словы',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Ніводнага дзённікавага запісу…';

  @override
  String get noResults => 'Няма вынікаў…';

  @override
  String get sortOrderAscendingTitle => 'Узыходзячы';

  @override
  String get sortOrderDescendingTitle => 'Па сыходзе';

  @override
  String get pageStatisticsTitle => 'Статыстыка';

  @override
  String get statisticsNotEnoughData => 'Недастаткова дадзеных…';

  @override
  String get statisticsRangeOneMonth => '1 месяц';

  @override
  String get statisticsRangeSixMonths => '6 месяцаў';

  @override
  String get statisticsRangeOneYear => '1 год';

  @override
  String get statisticsRangeAllTime => 'Увесь час';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag Рэзюмэ';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag Днём';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag З цягам часу';
  }

  @override
  String get chartGroupingLabel => 'Згрупаваць па';

  @override
  String get chartGroupingDay => 'Дзень';

  @override
  String get chartGroupingWeek => 'Тыдзень';

  @override
  String get chartGroupingMonth => 'Месяц';

  @override
  String get chartGroupingYear => 'год';

  @override
  String get chartSmoothingLabel => 'Разгладжванне';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Бягучая серыя $count',
      one: 'Бягучая серыя $count',
      many: 'Бягучая серыя $count',
      few: 'Бягучая серыя $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Самая доўгая серыя $count',
      one: 'Самая доўгая серыя $count',
      many: 'Самая доўгая серыя $count',
      few: 'Самая доўгая серыя $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Вялікія дні $count',
      one: 'Вялікія дні $count',
      many: 'Вялікія дні $count',
      few: 'Вялікія дні $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Дні пасля дрэннага дня $count',
      one: 'Дні пасля дрэннага дня $count',
      many: 'Дні пасля дрэннага дня $count',
      few: 'Дні пасля дрэннага дня $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Немагчыма атрымаць доступ да знешняй памяці';

  @override
  String get errorExternalStorageAccessDescription =>
      'Калі вы карыстаецеся сеткавым сховішчам, пераканайцеся, што паслуга ў сетцы і ў вас ёсць доступ да сеткі.\n\nУ адваротным выпадку праграма магла страціць дазволы на знешнюю тэчку. Перайдзіце ў налады і паўторна абярыце знешнюю папку, каб даць доступ.\n\nУвага, змены не будуць сінхранізаваны, пакуль вы не адновіце доступ да знешняга сховішча!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Працягнуць з лакальнай базай даных';

  @override
  String get lastModified => 'Зменены';

  @override
  String get writeSomethingHint => 'Напішыце што-небудзь…';

  @override
  String get titleHint => 'Назва…';

  @override
  String get deleteLogTitle => 'Выдаліць дзённікавы запіс';

  @override
  String get deleteLogDescription =>
      'Запіс перамяшчаецца ў Нядаўна выдаленыя, дзе вы можаце аднавіць яго.';

  @override
  String get deletePhotoTitle => 'Выдаліць укладанне';

  @override
  String get deletePhotoDescription =>
      'Вы ўпэўнены, што хочаце выдаліць гэтае ўкладанне?';

  @override
  String get pageSettingsTitle => 'Налады';

  @override
  String get settingsTheme => 'Тэма';

  @override
  String get themeSystem => 'сістэма';

  @override
  String get themeLight => 'Святло';

  @override
  String get themeDark => 'Цёмны';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Першы дзень тыдня';

  @override
  String get settingsCalendarSystem => 'Каляндарная сістэма';

  @override
  String get calendarSystemGregorian => 'Грыгарыянскі';

  @override
  String get calendarSystemJalali => 'Джалалі';

  @override
  String get settingsUseSystemAccentColor =>
      'Выкарыстоўвайце сістэмны акцэнтны колер';

  @override
  String get settingsCustomAccentColor => 'Нестандартны акцэнтны колер';

  @override
  String get settingsShowFlashbacks => 'Паказаць рэтраспекцыі';

  @override
  String get settingsChangeMoodIcons => 'Значкі змены настрою';

  @override
  String get moodIconPrompt => 'Увядзіце значок';

  @override
  String get settingsHideImages => 'Схаваць выявы';

  @override
  String get pageCalendarTitle => 'Каляндар';

  @override
  String get settingsNotificationsTitle => 'Апавяшчэнні';

  @override
  String get settingsDailyReminderTitle => 'Штодзённы напамін';

  @override
  String get settingsOnThisDayDescription => 'Перагледзьце мінулыя ўспаміны';

  @override
  String get settingsDailyReminderDescription =>
      'Далікатны напамін кожны дзень';

  @override
  String get settingsReminderTime => 'Час напамінку';

  @override
  String get settingsFixedReminderTimeTitle => 'Фіксаваны час напамінку';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Выберыце фіксаваны час для напамінку';

  @override
  String get settingsAlwaysSendReminderTitle => 'Заўсёды адпраўляць напамін';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Адправіць напамін, нават калі запіс у дзённіку ўжо быў пачаты';

  @override
  String get settingsCustomizeNotificationTitle => 'Наладзіць апавяшчэнні';

  @override
  String get settingsTemplatesTitle => 'Шаблоны';

  @override
  String get manageTemplates => 'Кіраванне шаблонамі';

  @override
  String get noTemplateTitle => 'Няма';

  @override
  String get noTemplatesDescription => 'Шаблоны яшчэ не створаны...';

  @override
  String get templateDefaultTimestampTitle => 'Метка часу';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Падвядзенне вынікаў дня';

  @override
  String get templateDefaultSummaryBody => '### Рэзюмэ\n- \n\n### Цытата\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Рэфлексія';

  @override
  String get templateDefaultReflectionBody =>
      '### Што вам спадабалася сёння?\n- \n\n### За што вы ўдзячныя?\n- \n\n### Чаго вы чакаеце?\n- ';

  @override
  String get settingsTagsTitle => 'Тэгі';

  @override
  String get manageTags => 'Кіраванне тэгамі';

  @override
  String get tagTypeLabelTitle => 'Этыкетка';

  @override
  String get tagTypeTrackerTitle => 'Трэкер';

  @override
  String get nameHint => 'Імя';

  @override
  String get tagColorLabel => 'Колер';

  @override
  String get iconPickerTitle => 'Выберыце значок';

  @override
  String get iconPickerIconsTab => 'Значкі';

  @override
  String get iconPickerCustomTab => 'Прыстасаваныя';

  @override
  String get iconPickerSearchHint => 'Значкі пошуку…';

  @override
  String get colorPickerTitle => 'Выберыце колер';

  @override
  String get colorPickerPaletteTab => 'Колеры';

  @override
  String get iconGroupMoodPeople => 'Настрой і людзі';

  @override
  String get iconGroupHealth => 'Здароўе';

  @override
  String get iconGroupWorkFinance => 'Праца і фінансы';

  @override
  String get iconGroupHabitsGoals => 'Звычкі і мэты';

  @override
  String get iconGroupNature => 'Прырода';

  @override
  String get iconGroupFoodDrink => 'Ежа і напоі';

  @override
  String get iconGroupHome => 'дадому';

  @override
  String get iconGroupTravel => 'Падарожжа';

  @override
  String get iconGroupSymbols => 'Сімвалы';

  @override
  String get tagCategoryLabel => 'Катэгорыя';

  @override
  String get tagLabel => 'Тэг';

  @override
  String get tagCategoryUncategorized => 'Без катэгорыі';

  @override
  String get newCategoryTitle => 'Новая катэгорыя';

  @override
  String get shareButtonLabel => 'падзяліцца';

  @override
  String get importErrorDescription => 'Не ўдалося імпартаваць файл!';

  @override
  String get exportErrorDescription => 'Не ўдалося экспартаваць файл!';

  @override
  String get deleteTitle => 'Выдаліць';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Ужываецца ў дзённікавых запісах $count.',
      one: ' Ужываецца ў $count дзённікавым запісе.',
      many: ' Ужываецца ў $count дзённікавых запісах.',
      few: ' Ужываецца ў $count дзённікавых запісах.',
      zero: '',
    );
    return 'Выдаліць \"$name\"?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Яе тэгі $count таксама будуць выдалены.',
      one: ' Яго $count тэг таксама будзе выдалены.',
      many: ' Яе тэгі $count таксама будуць выдалены.',
      few: ' Яе $count тэгі таксама будуць выдалены.',
      zero: '',
    );
    return 'Выдаліць \"$name\"?$_temp0';
  }

  @override
  String get tagNameExists => 'Тэг з такой назвай ужо ёсць';

  @override
  String get categoryNameExists => 'Катэгорыя з такой назвай ужо ёсць';

  @override
  String deleteTemplateMessage(Object name) {
    return 'Выдаліць \"$name\"?';
  }

  @override
  String get addTagsTitle => 'Дадаць тэгі';

  @override
  String get addTagsSearchHint => 'Пошук тэгаў…';

  @override
  String get tagPickerSortManualLabel => 'Ручны парадак';

  @override
  String get tagPickerSortUsageLabel => 'Сартаваць па выкарыстанні';

  @override
  String get tagFavoriteName => 'Любімая';

  @override
  String get tagEnergyName => 'Энергія';

  @override
  String get tagCategoryActivitiesName => 'Мерапрыемствы';

  @override
  String get tagExerciseName => 'Практыкаванне';

  @override
  String get tagSocializingName => 'Сацыялізацыя';

  @override
  String get tagHobbyName => 'хобі';

  @override
  String get tagEntertainmentName => 'забавы';

  @override
  String get tagDiningName => 'Сталовая';

  @override
  String get tagChoresName => 'Хатнія справы';

  @override
  String get tagCategoryEmotionsName => 'Эмоцыі';

  @override
  String get tagExcitedName => 'Усхваляваны';

  @override
  String get tagGratefulName => 'Удзячны';

  @override
  String get tagCalmName => 'Спакойны';

  @override
  String get tagTiredName => 'Стаміўся';

  @override
  String get tagAnxiousName => 'Трывожны';

  @override
  String get tagAnnoyedName => 'Раздражнёны';

  @override
  String get settingsStorageTitle => 'Захоўванне';

  @override
  String get settingsImageQuality => 'Якасць выявы';

  @override
  String get imageQualityHigh => 'Высокі';

  @override
  String get imageQualityMedium => 'Сярэдні';

  @override
  String get imageQualityLow => 'Нізкі';

  @override
  String get imageQualityNoCompression => 'Няма сціску';

  @override
  String get settingsLogFolder => 'дзённікавы запіс Папка';

  @override
  String get settingsImageFolder => 'Тэчка з малюнкамі';

  @override
  String get warningTitle => 'Папярэджанне';

  @override
  String get logFolderWarningDescription =>
      'Калі выбраная папка ўжо ўтрымлівае файл \'aid_diary.db\', ён будзе выкарыстоўвацца для перазапісу існуючых запісаў дзённіка!';

  @override
  String get errorTitle => 'Памылка';

  @override
  String get logFolderErrorDescription =>
      'Не ўдалося змяніць тэчку запісаў дзённіка!';

  @override
  String get imageFolderErrorDescription =>
      'Не ўдалося змяніць папку з малюнкамі!';

  @override
  String get backupErrorDescription => 'Не ўдалося стварыць рэзервовую копію!';

  @override
  String get restoreErrorDescription => 'Не ўдалося аднавіць рэзервовую копію!';

  @override
  String get settingsBackupRestoreTitle =>
      'Рэзервовае капіраванне і аднаўленне';

  @override
  String get settingsBackup => 'Рэзервовае капіраванне';

  @override
  String get settingsRestore => 'Аднавіць';

  @override
  String get settingsRestorePromptDescription =>
      'Аднаўленне з рэзервовай копіі перазапіша існуючыя даныя!';

  @override
  String get settingsBackupPasswordProtect =>
      'Рэзервовыя копіі з абаронай паролем';

  @override
  String get backupEncryptedTitle => 'Зашыфраванае рэзервовае капіраванне';

  @override
  String get backupEncryptedContent =>
      'Гэта рэзервовая копія абаронена паролем.';

  @override
  String get settingsAutoBackup => 'Аўтаматычнае рэзервовае капіраванне';

  @override
  String get settingsAutoBackupLocation => 'Рэзервовае месцазнаходжанне';

  @override
  String get settingsAutoBackupInterval => 'Інтэрвал рэзервовага капіявання';

  @override
  String get settingsAutoBackupIntervalDaily => 'Штодня';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Штотыдзень';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Штомесяц';

  @override
  String get settingsAutoBackupMaxCount => 'Рэзервовыя копіі для захоўвання';

  @override
  String get settingsAutoBackupRequireCharging => 'Толькі падчас зарадкі';

  @override
  String settingsBackupLast(Object time) {
    return 'Апошняя рэзервовая копія $time';
  }

  @override
  String get settingsBackupNever => 'Ніколі не стваралася рэзервовая копія';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Наступная рэзервовая копія $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'Усе';

  @override
  String get autoBackupFailedTitle => 'Збой рэзервовага капіравання';

  @override
  String tranferStatus(Object percent) {
    return 'Перадача… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Стварэнне рэзервовай копіі... $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Аднаўленне з рэзервовай копіі... $percent%';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return 'Шыфраванне рэзервовай копіі… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Дэшыфраванне рэзервовай копіі… $percent%';
  }

  @override
  String get cleanUpStatus => 'Ачыстка…';

  @override
  String get settingsExportToAnotherFormat => 'Экспарт у іншы фармат';

  @override
  String get settingsExportFormatDescription =>
      'Гэта не варта выкарыстоўваць у якасці рэзервовай копіі!';

  @override
  String get settingsImportFromAnotherApp => 'Імпарт з іншай праграмы';

  @override
  String get logFormatTitle => 'Выберыце Фармат';

  @override
  String get logFormatDescription =>
      'Фармат іншай праграмы можа не падтрымліваць усе функцыі. Калі ласка, паведамляйце аб любых праблемах, паколькі фарматы іншых вытворцаў могуць змяніцца ў любы час. Гэта не паўплывае на існуючыя дзённікавыя запісы!';

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
  String get settingsDeleteAllLogsTitle => 'Выдаліць усе дзённікавыя запісы';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Вы хочаце выдаліць усе запісы ў дзённіку?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Каб пацвердзіць, увядзіце «$prompt». Гэта нельга адмяніць!';
  }

  @override
  String get settingsAppLanguageTitle => 'Мова праграмы';

  @override
  String get settingsSecurityTitle => 'Бяспека';

  @override
  String get settingsSecurityRequirePassword => 'Патрабаваць пароль';

  @override
  String get settingsSecurityEnterPassword => 'Увядзіце пароль';

  @override
  String get settingsSecuritySetPassword => 'Усталюйце пароль';

  @override
  String get settingsSecurityChangePassword => 'Змяніць пароль';

  @override
  String get settingsSecurityPassword => 'Пароль';

  @override
  String get settingsSecurityConfirmPassword => 'Пацвердзіце пароль';

  @override
  String get settingsSecurityOldPassword => 'Стары пароль';

  @override
  String get settingsSecurityIncorrectPassword => 'Няправільны пароль';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'Паролі не супадаюць';

  @override
  String get requiredPrompt => 'абавязковы';

  @override
  String get settingsSecurityBiometricUnlock => 'Біяметрычная разблакіроўка';

  @override
  String get unlockAppPrompt => 'Разблакіраваць праграму';

  @override
  String get settingsAboutTitle => 'Аб';

  @override
  String get settingsVersion => 'Версія';

  @override
  String get settingsLicense => 'Ліцэнзія';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsOpenSourceLicenses => 'Ліцэнзіі з адкрытым зыходным кодам';

  @override
  String get tagMoodTitle => 'настрой';

  @override
  String get selectTagTitle => 'Выберыце Тэг';

  @override
  String get labelPresentLabel => 'прысутнічае';

  @override
  String get labelAbsentLabel => 'Адсутны';

  @override
  String get labelCoverageLabel => 'Пакрыццё';

  @override
  String chartDistributionTitle(Object tag) {
    return 'Размеркаванне $tag';
  }

  @override
  String get shareAddToLogPickerTitle => 'Выберыце дзённікавы запіс';

  @override
  String get adaptiveEmptyDay => 'Запісаў на гэты дзень пакуль няма';

  @override
  String get adaptiveNewEntry => 'Напісаць запіс';

  @override
  String get pageJournalTitle => 'часопіс';

  @override
  String get coachPrompt1 => 'Што прымусіла вас сёння ўсміхнуцца?';

  @override
  String get coachPrompt2 => 'Што вы сёння даведаліся?';

  @override
  String get coachPrompt3 => 'З кім вы сёння размаўлялі і якія адчуванні?';

  @override
  String get coachPrompt4 => 'За што вы зараз удзячны?';

  @override
  String get coachPrompt5 => 'Што забрала больш за ўсё вашай энергіі сёння?';

  @override
  String get coachPrompt6 =>
      'Апішыце невялікі момант, які вы хочаце запомніць.';

  @override
  String get coachPrompt7 => 'Што зробіць заўтрашні дзень добрым?';

  @override
  String get coachPrompt8 => 'Што ў цябе ў галаве апошнім часам?';

  @override
  String get coachPrompt9 => 'Што вы зрабілі сёння толькі для сябе?';

  @override
  String get coachPrompt10 => 'Калі б сёння была назва, якая б яна была?';

  @override
  String get pageMediaTitle => 'СМІ';

  @override
  String get pageAtlasTitle => 'Атлас';

  @override
  String get pageCoachTitle => 'трэнер';

  @override
  String get noEntrySelected => 'Запіс не выбраны.';

  @override
  String get entryShare => 'падзяліцца';

  @override
  String get entryFavorite => 'Зорка';

  @override
  String get entryEdit => 'Рэдагаваць';

  @override
  String get entryPrevious => 'Папярэдні запіс';

  @override
  String get entryNext => 'Наступны запіс';

  @override
  String get journalStories => 'Гісторыі';

  @override
  String get journalEntries => 'Запісы';

  @override
  String get journalEmptyHint =>
      'Пачніце свой дзённік з дадання новага запісу.';

  @override
  String get storyToday => 'сёння';

  @override
  String get storyThrowback => 'Вяртанне назад';

  @override
  String get storyNoThrowback => 'Сёння без вяртання';

  @override
  String get mediaFiles => 'Медыяфайлы';

  @override
  String get mediaEmpty => 'Фатаграфій пакуль няма.';

  @override
  String get mediaEmptyHint =>
      'Фота, далучаныя да запісаў, будуць паказвацца тут.';

  @override
  String get atlasEmpty => 'Няма запісаў з месцазнаходжаннем.';

  @override
  String get atlasEmptyHint =>
      'Тут будуць паказаны запісы з месцазнаходжаннем.';

  @override
  String get atlasShowAll => 'Паказаць усе запісы';

  @override
  String get atlasMyLocation => 'Маё месцазнаходжанне';

  @override
  String get coachAll => 'Усе';

  @override
  String get coachPrograms => 'Праграмы';

  @override
  String get coachTemplates => 'Шаблоны';

  @override
  String get coachKindProgram => 'праграма';

  @override
  String get coachKindTemplate => 'Шаблон';

  @override
  String get coachNoTemplates => 'Ніякіх праграм і шаблонаў.';

  @override
  String get coachUseTemplate => 'Пішыце з дапамогай гэтага шаблону';

  @override
  String get coachProgramEverydayTitle => 'Штодзённыя моманты';

  @override
  String get coachProgramEverydayDescription =>
      'Пяць кароткіх пытанняў, па адным у дзень. Кожны з іх займае адну-дзве хвіліны і дапамагае вам убачыць, што зрабіла гэты дзень вашым. Мяккі спосаб выпрацаваць звычку пісаць патроху кожны дзень.';

  @override
  String get coachProgramReflectTitle => 'Глядзець унутр';

  @override
  String get coachProgramReflectDescription =>
      'Адно больш глыбокае пытанне на тыдзень, на працягу пяці тыдняў. Не спяшайцеся з кожным: як вы сябе адчуваеце, што вас стамляе, за што вы ўдзячныя.';

  @override
  String get searchFilters => 'Фільтры';

  @override
  String get searchFilterTags => 'Тэгі';

  @override
  String get searchFilterStarred => 'Пазначаны зоркай';

  @override
  String get searchHint => 'Увядзіце для пошуку або выберыце фільтр.';

  @override
  String get locationTitle => 'Размяшчэнне';

  @override
  String get locationName => 'Назва месца';

  @override
  String get locationRemove => 'Выдаліць';

  @override
  String get locationServiceDisabled =>
      'Службы вызначэння месцазнаходжання адключаны.';

  @override
  String get locationPermissionDenied =>
      'У дазволе на вызначэнне месцазнаходжання адмоўлена.';

  @override
  String get locationUnavailable =>
      'Не ўдалося атрымаць бягучае месцазнаходжанне.';

  @override
  String get calendarJumpToToday => 'Перайсці да сённяшняга дня';

  @override
  String get editorStartWriting => 'Пачніце пісаць або абярыце a ';

  @override
  String get editorTemplateLink => 'Шаблон';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Выберыце шаблон';

  @override
  String get templateFeatured => 'Папулярныя шаблоны';

  @override
  String get templateMine => 'Мае шаблоны';

  @override
  String get templateDailyName => 'Штодзённы агляд';

  @override
  String get templateDailyDescription =>
      'Што адбылося, якія адчуванні і што будзе далей.';

  @override
  String get templateDailyText =>
      '## Што здарылася сёння\n\n\n## Як я сябе адчуваў\n\n\n## Тры рэчы, за якія я ўдзячны\n1. \n2. \n3. \n\n## Заўтра\n';

  @override
  String get templateTravelName => 'Запіс у дзённіку падарожжа';

  @override
  String get templateTravelDescription => 'Месцы, моманты і ежа з дарогі.';

  @override
  String get templateTravelText =>
      '## Куды я пайшоў\n\n\n## Момант, які мне запомніўся больш за ўсё\n\n\n## Што я еў\n\n\n## Планы на заўтра\n';

  @override
  String get templateReadingName => 'Чытанне нот';

  @override
  String get templateReadingDescription => 'Цытаты і думкі з прачытанага.';

  @override
  String get templateReadingText =>
      '## Кніга\n\n\n## Дзе я\n\n\n## Цытаты\n> \n\n## Мае думкі\n';

  @override
  String get templateWeeklyName => 'Штотыднёвы агляд';

  @override
  String get templateWeeklyDescription =>
      'Асноўныя моманты, цяжкасці і акцэнт на наступным тыдні.';

  @override
  String get templateWeeklyText =>
      '## Асноўны момант\n\n\n## Што было цяжка\n\n\n## Што я даведаўся\n\n\n## У цэнтры ўвагі на наступным тыдні\n';

  @override
  String get entrySaveAsTemplate => 'Захаваць як шаблон';

  @override
  String get entrySavedAsTemplate => 'Захавана як шаблон';

  @override
  String get storyStatistics => 'Статыстыка';

  @override
  String get storyMoodChart => 'Дыяграма настрою';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return '$entries запісаў · $days дзён';
  }

  @override
  String get storyThisYear => 'Гэты год';

  @override
  String get storyLastYear => 'У мінулым годзе';

  @override
  String get storyTapToOpen => 'Націсніце на дзень, каб адкрыць яго';

  @override
  String get settingsGeneralTitle => 'Генерал';

  @override
  String get settingsDataTitle => 'Дадзеныя і захоўванне';

  @override
  String get settingsStoriesTitle => 'Гісторыі';

  @override
  String get settingsHelpTitle => 'Даведка і пра';

  @override
  String get weatherTitle => 'Надвор\'е';

  @override
  String get weatherClear => 'Ясна';

  @override
  String get weatherPartlyCloudy => 'Пераменная воблачнасць';

  @override
  String get weatherCloudy => 'Воблачна';

  @override
  String get weatherFog => 'Туман';

  @override
  String get weatherDrizzle => 'Дожджык';

  @override
  String get weatherRain => 'Дождж';

  @override
  String get weatherSnow => 'Снег';

  @override
  String get weatherStorm => 'Навальніца';

  @override
  String get weatherFetch => 'Атрымаць прагноз надвор\'я для гэтага запісу';

  @override
  String get weatherNeedsLocation => 'Спачатку дадайце месца з каардынатамі.';

  @override
  String get weatherUnavailable =>
      'Надвор\'е недаступнае для гэтага месца і часу.';

  @override
  String get weatherRemove => 'Зняць надвор\'е';

  @override
  String get activityTitle => 'актыўнасць';

  @override
  String get activityStill => 'Тым не менш';

  @override
  String get activityWalking => 'Хада';

  @override
  String get activityRunning => 'Бег';

  @override
  String get activityCycling => 'Веласпорт';

  @override
  String get activityVehicle => 'У транспартным сродку';

  @override
  String get activityFlying => 'Палёт';

  @override
  String get activityExercise => 'Практыкаванне';

  @override
  String get activityDetect => 'Выявіць бягучую дзейнасць';

  @override
  String get activityDetectFailed => 'Не ўдалося выявіць дзейнасць.';

  @override
  String get activityRemove => 'Выдаліць дзейнасць';

  @override
  String get settingsAutoAddTitle => 'Дадаць аўтаматычна';

  @override
  String get settingsAutoAddLocation => 'Размяшчэнне';

  @override
  String get settingsAutoAddWeather => 'Надвор\'е';

  @override
  String get settingsAutoAddHint =>
      'Новыя запісы запаўняюцца пры іх стварэнні.';

  @override
  String get settingsTemperatureUnit => 'Адзінка вымярэння тэмпературы';

  @override
  String get settingsCelsius => 'Цэльсій (°C)';

  @override
  String get settingsFahrenheit => 'Фарэнгейт (°F)';

  @override
  String get moodGreat => 'Выдатна';

  @override
  String get moodGood => 'Добра';

  @override
  String get moodOkay => 'Добра';

  @override
  String get moodBad => 'Дрэнна';

  @override
  String get moodAwful => 'Жудасна';

  @override
  String get locationSearchHint => 'Пошук месца';

  @override
  String get locationSearchEmpty => 'Месцы не знойдзены';

  @override
  String get settingsWallpaper => 'Шпалеры';

  @override
  String get wallpaperNone => 'Няма';

  @override
  String get wallpaperDots => 'Кропкі';

  @override
  String get wallpaperGrid => 'Сетка';

  @override
  String get wallpaperLines => 'Радкі';

  @override
  String get wallpaperPhoto => 'Фота…';

  @override
  String get settingsFontFamily => 'Шрыфт';

  @override
  String get fontSystem => 'сістэма';

  @override
  String get fontSerif => 'Засечкі';

  @override
  String get fontMono => 'Монапрастор';

  @override
  String get settingsFontSize => 'Памер шрыфта';

  @override
  String get fontSizeSmall => 'Маленькі';

  @override
  String get fontSizeMedium => 'Сярэдні';

  @override
  String get fontSizeLarge => 'Вялікі';

  @override
  String get fontSizeExtraLarge => 'Вельмі вялікі';

  @override
  String get settingsLineSpacing => 'Міжрадковы інтэрвал';

  @override
  String get lineSpacingCompact => 'Кампактны';

  @override
  String get lineSpacingNormal => 'Нармальны';

  @override
  String get lineSpacingRelaxed => 'Расслаблены';

  @override
  String get moodAssociationsTitle => 'Што прымушае мяне адчуваць...';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching з $total запісаў';
  }

  @override
  String get videoRecord => 'Запісаць відэа';

  @override
  String get videoChoose => 'Выберыце відэа';

  @override
  String get audioRecordTitle => 'Запісаць галасавую нататку';

  @override
  String get audioChoose => 'Выберыце аўдыяфайл';

  @override
  String get audioStart => 'Запіс';

  @override
  String get audioStop => 'Спыніцеся і захавайце';

  @override
  String get audioPermissionDenied =>
      'Доступ да мікрафона выключаны. Дазвольце гэта ў наладах сістэмы.';

  @override
  String get mediaTooLarge => 'Гэта відэа занадта вялікае для далучэння.';

  @override
  String get mediaUnavailable =>
      'Гэта ўкладанне недаступнае на гэтай прыладзе.';

  @override
  String get widgetDone => 'Сённяшні запіс напісаны';

  @override
  String get widgetPending => 'Як прайшоў дзень?';

  @override
  String get widgetWrite => 'Пішыце';

  @override
  String get insertChecklist => 'Кантрольны спіс';

  @override
  String get insertNumberedList => 'Нумараваны спіс';

  @override
  String get insertTable => 'стол';

  @override
  String get insertDivider => 'Раздзяляльнік';

  @override
  String get insertCodeBlock => 'Блок кодаў';

  @override
  String get journalSortTitle => 'Сартаваць запісы';

  @override
  String get journalSortUpdated => 'Апошняе абнаўленне';

  @override
  String get settingsTimeFormat => 'Фармат часу';

  @override
  String get settingsDayStart => 'Новыя запісы лічацца за папярэдні дзень да';

  @override
  String get settingsDayAskUntil => 'Затым спытаеце, да якога дня';

  @override
  String get settingsDayStartMidnight => 'Выкл';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Кожны запіс захоўвае дзень, да якога ён належыць, побач з часам яго напісання, і вы можаце змяніць гэты дзень у рэдактары ў любы час. Гэтыя гадзіны выбіраюць толькі дзень для новых запісаў, таму іх змяненне не перамяшчае існуючы запіс.';

  @override
  String get lateNightBadge =>
      'Пісалі позна ўвечары, падлічвалі за дзень раней';

  @override
  String editorDayAsk(String time) {
    return 'Напісана ў $time. На які дзень гэта?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (учора)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (сёння)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'Напісана $when';
  }

  @override
  String get timeFormat12 => '12-гадзінны';

  @override
  String get timeFormat24 => '24-гадзінны';

  @override
  String get settingsReminderDays => 'Нагадаць мне далей';

  @override
  String get locationRecent => 'Нядаўнія месцы';

  @override
  String get shareImage => 'Падзяліцеся выявай';

  @override
  String get shareSaveImage => 'Захаваць малюнак';

  @override
  String get shareSaved => 'Відарыс захаваны';

  @override
  String get deletedTitle => 'Нядаўна выдалены';

  @override
  String get deletedNone => 'Нядаўна нічога не выдалялася';

  @override
  String deletedHint(int days) {
    return 'Выдаленыя запісы застаюцца тут $days дзён, потым сціраюцца.';
  }

  @override
  String deletedDaysLeft(int days) {
    return 'Засталося $days дзён';
  }

  @override
  String get deletedRestore => 'Аднавіць';

  @override
  String get deletedDeleteForever => 'Выдаліць назаўжды';

  @override
  String get deletedDeleteForeverDescription =>
      'Запіс і дадаткі да яго выдаляюцца. Гэта нельга адмяніць.';

  @override
  String get deletedEmpty => 'Пусты';

  @override
  String get deletedEmptyDescription =>
      'Сцерці ўсе запісы ў Нядаўна выдаленых? Гэта нельга адмяніць.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Выпадковае хаджэнне';

  @override
  String get randomSubtitle => 'Адкрыйце мінулы запіс';

  @override
  String get randomNext => 'Іншы';

  @override
  String get randomAll => 'Усе';

  @override
  String get randomWithPhotos => 'З фотаздымкамі';

  @override
  String get randomGoodDays => 'Добрых дзён';

  @override
  String get randomEmpty => 'Няма запісаў для выбару';

  @override
  String get reviewWeekTitle => 'На гэтым тыдні';

  @override
  String get reviewWeekSubtitle => 'Ваш тыдзень';

  @override
  String get reviewYearTitle => 'Гэты год';

  @override
  String get reviewEmpty => 'Пакуль нічога не напісана';

  @override
  String get reviewEntries => 'Запісы';

  @override
  String get reviewDaysWritten => 'Дні напісаны';

  @override
  String get reviewWords => 'Словы';

  @override
  String get reviewPhotos => 'Фатаграфіі';

  @override
  String get reviewLongestRun => 'Самы доўгі прабег дзён';

  @override
  String get reviewAverageMood => 'Сярэдні настрой';

  @override
  String get reviewFavorites => 'Часцей за ўсё';

  @override
  String get reviewByMonth => 'Па месяцах';

  @override
  String get reviewHighlight => 'Вылучыць';

  @override
  String get yearInPixels => 'Год у пікселях';

  @override
  String get capsuleSeal => 'Пячатка як капсула часу';

  @override
  String get capsuleTitle => 'Капсула часу';

  @override
  String capsuleOpensOn(Object date) {
    return 'Адкрываецца на $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Напісана на $date';
  }

  @override
  String get capsuleOpenEarly => 'Адкрываецца рана';

  @override
  String get capsuleOpenEarlyDescription =>
      'Капсула адкрываецца і застаецца адкрытай.';

  @override
  String get capsuleOpened => 'Капсула часу адкрыта';

  @override
  String get templateMorningName => 'Ранішнія старонкі';

  @override
  String get templateMorningDescription => 'Наладзьце дзень за тры хвіліны';

  @override
  String get templateMorningText =>
      '## Сёння я хачу зрабіць добра тры рэчы\n1. \n2. \n3. \n\n## Я з нецярпеннем чакаю\n\n## Заўвага для сябе\n';

  @override
  String get templateEveningName => 'Вячэрні агляд';

  @override
  String get templateEveningDescription =>
      'Завяршыце дзень тым, што пайшло добра';

  @override
  String get templateEveningText =>
      '## Сёння тры добрыя рэчы\n1. \n2. \n3. \n\n## Што я даведаўся\n\n## Што можа быць лепш заўтра\n';

  @override
  String get routineMorning => 'Добрай раніцы';

  @override
  String get routineEvening => 'Вячэрні агляд';

  @override
  String get settingsRoutinePrompts => 'Ранішнія і вячэрнія падказкі';

  @override
  String get settingsRoutinePromptsHint =>
      'Прапануйце ранішні або вячэрні шаблон у Stories';

  @override
  String get checkInTitle => 'Хуткая рэгістрацыя';

  @override
  String get checkInSubtitle => 'Настрой у два краны';

  @override
  String get checkInMood => 'Як сябе адчуваеш?';

  @override
  String get checkInActivity => 'Што ты робіш';

  @override
  String get checkInNote => 'Радок пра гэта (неабавязкова)';

  @override
  String get checkInSave => 'Захаваць';

  @override
  String editorWordCount(int words, int characters) {
    return '$words словы · $characters сімвалы';
  }

  @override
  String get coachProgramEverydayTagline => 'Заўважце дробязі ў дзень.';

  @override
  String get coachProgramReflectTagline =>
      'Запавольце і прыслухайцеся да сябе.';

  @override
  String get coachDuration => 'Працягласць';

  @override
  String get coachInterval => 'Інтэрвал';

  @override
  String get coachDifficulty => 'Цяжкасць';

  @override
  String get coachIntervalDaily => 'Штодня';

  @override
  String get coachIntervalWeekly => 'Штотыдзень';

  @override
  String get coachDifficultyBeginner => 'Пачатковец';

  @override
  String get coachDifficultyIntermediate => 'Прамежкавы';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня',
      one: '$count дзень',
      many: '$count дзён',
      few: '$count дні',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count тыдня',
      one: '$count тыдзень',
      many: '$count тыдняў',
      few: '$count тыдні',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'Дзень $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Тыдзень $n';
  }

  @override
  String get coachEnroll => 'Запісацца';

  @override
  String get coachEndProgram => 'Завяршыць праграму';

  @override
  String get coachAuthor => 'Аўтар';

  @override
  String get coachAuthorBio => 'Падказкі, напісаныя для гэтай праграмы.';

  @override
  String get coachEnrolledTip =>
      'Усё гатова! Вашы пытанні з\'явяцца ў Гісторыях.';

  @override
  String get coachGoToStories => 'Перайдзіце ў Гісторыі';

  @override
  String get coachAnswerHint => 'Напішыце свой адказ…';

  @override
  String get storyWrapUp => 'Вось і ўсё на сёння.';

  @override
  String get storyTapToClose => 'Націсніце, каб закрыць';

  @override
  String get coachAnswerDone => 'Гатова';

  @override
  String get coachAnswered => 'Адказана, націсніце, каб адкрыць';

  @override
  String get coachAnsweredEarlier => 'Адказаў';

  @override
  String get locationLocating => 'Вызначэнне месцазнаходжання…';

  @override
  String get locationPickPlace => 'Выберыце месца';

  @override
  String get locationPlacesHint => 'Адрас або назва месца';

  @override
  String get locationCustom => 'Карыстальніцкае месца';

  @override
  String get locationCurrent => 'Цяперашняе месцазнаходжанне';

  @override
  String get locationSaved => 'Захаваныя месцы';

  @override
  String get locationSearchResults => 'Вынікі пошуку';

  @override
  String get locationNearby => 'Блізкія месцы';

  @override
  String get locationRename => 'Перайменаваць';

  @override
  String get locationSavePlace => 'Захаваць месца';

  @override
  String get locationUnsavePlace => 'Выдаліць з захаваных месцаў';

  @override
  String get shareAs => 'Падзяліцца як…';

  @override
  String get shareAsImage => 'Малюнак';

  @override
  String get shareAsZip => 'ZIP з арыгінальным носьбітам';

  @override
  String get shareAsPlainText => 'Звычайны тэкст';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Сардэчна запрашаем у AID Diary';

  @override
  String get onboardWelcomeText =>
      'Пачніце тут або падключыце гэту прыладу да той, якой вы ўжо карыстаецеся.';

  @override
  String get onboardStart => 'Пачаць пісаць';

  @override
  String get helpFaq => 'Часта задаюць пытанні';

  @override
  String get helpFaq1Q => 'Дзе захоўваецца мой дзённік?';

  @override
  String get helpFaq1A =>
      'Ваш дзённік захоўваецца на гэтай прыладзе. Ён дасягае іншых прылад або сховішча толькі тады, калі вы ўключыце сінхранізацыю, абагульваеце або экспартуеце яго. Сінхранізацыя мае скразное шыфраванне.';

  @override
  String get helpFaq2Q => 'Як захаваць копію або перанесці на новую прыладу?';

  @override
  String get helpFaq2A =>
      'Падключыцеся да існуючай прылады ў Наладах → Даныя і сховішча → Сінхранізацыя і пацвердзіце аўтарызацыю на прыладзе, на якой захаваны ваш дзённік. Абодва прылады застаюцца прыдатнымі да выкарыстання. Вы таксама можаце стварыць рэзервовую копію і аднавіць яе на іншай прыладзе.';

  @override
  String get helpFaq3Q => 'Ці магу я ўвесці запісы з іншых дзённікаў?';

  @override
  String get helpFaq3A =>
      'Так: у Наладах → Даныя і сховішча імпартуйце экспарт з Daylio, Diarium, Diaro, DayBook, My Brain, OneShot і Pixels або экспарт JSON.';

  @override
  String get helpFaq4Q => 'Як працуюць трэнерскія праграмы?';

  @override
  String get helpFaq4A =>
      'Зарэгіструйцеся ў праграме на старонцы трэнера. Кожны дзень ці тыдзень новае пытанне чакае ў Stories; ваш адказ захоўваецца як запіс.';

  @override
  String get helpFaq5Q => 'Што рабіць, калі я забуду свой пароль?';

  @override
  String get helpFaq5A =>
      'Пароль нельга аднавіць, таму захоўвайце рэзервовую копію дзённіка.';

  @override
  String get helpPrivacy => 'Прыватнасць';

  @override
  String get helpPrivacyText =>
      'Змесціва дзённіка і мультымедыя застаюцца на гэтай прыладзе, пакуль вы не ўключыце зашыфраваную сінхранізацыю або абагуліце/экспартуеце іх. Карты, пошук месца і надвор\'е выкарыстоўваюць наладжаныя службы і адпраўляюць месцазнаходжанне або пошукавы запыт, неабходны для гэтага запыту, а не тэкст дзённіка.';

  @override
  String get photoMetaTitle => 'Выкарыстаць дэталі фота?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Разлічыць гэты запіс як $date і задаць яго месца як $place, як запісана на фота?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Залічыць гэты запіс як $date, калі было зроблена фота?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Вызначыць для гэтага запісу месца $place, дзе было зроблена фота?';
  }

  @override
  String get photoMetaApply => 'Выкарыстоўвайце іх';

  @override
  String get quickWriteTitle => 'Хуткі запіс';

  @override
  String get quickWriteText => 'Націсніце, каб пачаць новы запіс.';

  @override
  String get settingsQuickWriteTitle => 'Хуткі запіс у апавяшчэннях';

  @override
  String get settingsQuickWriteDescription =>
      'Захоўвайце апавяшчэнне аб адкрыцці новага запісу.';

  @override
  String get settingsNudgesTitle => 'Падштурхніце мяне пасля ціхай расцяжкі';

  @override
  String settingsNudgesDescription(int days) {
    return 'Далікатны напамін, калі вы не пісалі $days дзён.';
  }

  @override
  String get nudgeTitle => 'Прайшоў час';

  @override
  String get nudgeMonday => 'Новы тыдзень: чаго вы чакаеце?';

  @override
  String get nudgeTuesday => 'Дастаткова двух радкоў. Як справы сёння?';

  @override
  String get nudgeWednesday => 'Палова тыдня. Што вылучалася да гэтага часу?';

  @override
  String get nudgeThursday => 'Што-небудзь дробнае, што варта пакінуць сёння?';

  @override
  String get nudgeFriday => 'Тыдзень завяршаецца. Адзначу адзін добры момант.';

  @override
  String get nudgeSaturday => 'Павольная субота - добры дзень для напісання.';

  @override
  String get nudgeSunday => 'Азірніцеся на тыдзень да яго заканчэння.';

  @override
  String get photoWidgetEmpty =>
      'Фотаздымкі, якія вы дадаяце да запісаў, паказваюцца тут.';

  @override
  String get channelReminders => 'Напаміны';

  @override
  String get channelOnThisDay => 'У гэты дзень';

  @override
  String get channelCoach => 'Трэнер падказвае';

  @override
  String get channelNudges => 'Падштурхоўвае пасля ціхіх дзён';

  @override
  String get channelQuickWrite => 'Хуткі запіс';

  @override
  String get channelBackup => 'Рэзервовыя копіі';

  @override
  String get formatJsonExport => 'JSON (экспарт AID Diary)';

  @override
  String get aboutModifiedNotice =>
      'Змененая версія Daily You ад Demizo і ўдзельнікаў. Гэта не афіцыйнае прыкладанне Daily You.';

  @override
  String get toolbarPhotos => 'Дадайце фатаграфіі';

  @override
  String get toolbarMedia => 'Фота і відэа';

  @override
  String get mediaFromGallery => 'Абярыце з галерэі';

  @override
  String get mediaFromFiles => 'Абярыце з файлаў';

  @override
  String get editorLeaveTitle => 'Захаваць гэты запіс?';

  @override
  String get editorLeaveDiscard => 'Не эканомце';

  @override
  String get editorTitleHint => 'Назва';

  @override
  String get editorLocating => 'Вызначэнне месцазнаходжання…';

  @override
  String get toolbarVideo => 'Відэа';

  @override
  String get toolbarAudio => 'Галасавая нататка';

  @override
  String get toolbarTags => 'Тэгі';

  @override
  String get toolbarBulletList => 'Маркіраваны спіс';

  @override
  String get toolbarHeading => 'Загаловак';

  @override
  String get toolbarBold => 'Тлусты';

  @override
  String get toolbarItalic => 'Курсівам';

  @override
  String get toolbarHighlight => 'Вылучыць';

  @override
  String get toolbarStrikethrough => 'Закрэсліванне';

  @override
  String get toolbarQuote => 'Цытата';

  @override
  String get toolbarLink => 'Спасылка';

  @override
  String get toolbarInsert => 'Уставіць';

  @override
  String get toolbarUndo => 'Адмяніць';

  @override
  String get toolbarRedo => 'Паўтарыць';

  @override
  String get toolbarInsertDate => 'Устаўце дату';

  @override
  String get toolbarInsertTime => 'Устаўце час';

  @override
  String get settingsSyncTitle => 'Воблачная сінхранізацыя';

  @override
  String get syncOffDescription =>
      'Захоўвайце гэты дзённік аднолькава на ўсіх сваіх прыладах праз Google Drive або сервер WebDAV, напрыклад Nextcloud, Synology або Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'Сінхранізацыя з Google Drive';

  @override
  String get syncOrWebDav => 'Або сервер WebDAV';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn =>
      'Вы ўвайшлі. Вы можаце вярнуцца да AID Diary.';

  @override
  String get syncGoogleSignInAgain =>
      'Google патрабуе, каб вы ўвайшлі яшчэ раз.';

  @override
  String get syncSignInAgain => 'Увайдзіце яшчэ раз';

  @override
  String get settingsCommandLineTitle => 'Камандны радок';

  @override
  String get commandLineToggle => 'Інтэрфейс каманднага радка';

  @override
  String get commandLineToggleHint =>
      'Дазваляе камандзе дапамогі і іншым праграмам на гэтай прыладзе выкарыстоўваць каманды праграмы.';

  @override
  String get commandLineAlwaysOn => 'Заўсёды ў стадыі распрацоўкі.';

  @override
  String commandLineListening(int port) {
    return 'Праслухоўванне на порце $port';
  }

  @override
  String get commandPaletteTitle => 'Усе каманды';

  @override
  String get commandPaletteSearch => 'Каманды пошуку';

  @override
  String get commandPaletteRun => 'Бегчы';

  @override
  String get commandPaletteConfirm => 'Гэта нельга проста адмяніць. Запусціць?';

  @override
  String syncReceiving(int done, int total) {
    return 'Атрыманне $done з $total…';
  }

  @override
  String syncSending(int done, int total) {
    return 'Адпраўка $done з $total…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'Доступ да Google Drive быў забаронены. Падключыцеся яшчэ раз і адзначце Google Drive на старонцы Google.';

  @override
  String get syncEntryUnsynced =>
      'Не сінхранізавана: апошняя сінхранізацыя не прайшла';

  @override
  String get syncUseOfficial => 'Выкарыстоўвайце сервер сінхранізацыі AID';

  @override
  String get syncServer => 'Адрас сервера';

  @override
  String get syncUsername => 'Імя карыстальніка';

  @override
  String get syncPassword => 'Пароль';

  @override
  String get syncConnect => 'Злучыцца';

  @override
  String get syncConnecting => 'Падключэнне...';

  @override
  String get syncSignInFailed =>
      'Не атрымалася ўвайсці. Праверце адрас, імя карыстальніка і пароль.';

  @override
  String syncConnectFailed(String error) {
    return 'Немагчыма падключыцца: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Пачаць сінхранізацыю';

  @override
  String get syncNewSpaceDescription =>
      'Тут пакуль няма сінхранізаванага дзённіка. Гэты дзённік будзе загружаны са скразным шыфраваннем з дапамогай ключа, які застаецца на вашых прыладах.';

  @override
  String get syncJoinTitle => 'Далучайцеся да сінхранізаванага дзённіка';

  @override
  String get syncWrongKey =>
      'Гэты код аднаўлення не адкрывае сінхранізаваны дзённік.';

  @override
  String syncLastSynced(String time) {
    return 'Апошняя сінхранізацыя $time';
  }

  @override
  String get syncNever => 'Яшчэ не сінхранізавана';

  @override
  String get syncSyncing => 'Сінхранізацыя…';

  @override
  String syncFailed(String error) {
    return 'Апошняя сінхранізацыя не атрымалася: $error';
  }

  @override
  String get syncLocked =>
      'Сінхранізаваны дзённік цяпер належыць іншым прыладам або быў пачаты спачатку. Спалучайцеся з адным з іх або выкарыстоўвайце код аднаўлення, каб працягваць сінхранізацыю.';

  @override
  String get syncNow => 'Сінхранізаваць зараз';

  @override
  String get syncUnlock => 'Разблакіраваць';

  @override
  String get syncEncrypted => 'Скразное шыфраванне';

  @override
  String get syncDisconnect => 'Спыніць сінхранізацыю';

  @override
  String get syncDisconnectDescription =>
      'Гэта прылада спыняе сінхранізацыю. Дзённік тут і сінхранізаваная копія застаюцца ранейшымі.';

  @override
  String get syncOwnRecoveryPassword =>
      'Выкарыстоўваць мой уласны пароль аднаўлення';

  @override
  String get syncRecoveryPassword => 'Пароль для аднаўлення';

  @override
  String get syncRecoveryPasswordRepeat => 'Паўтарыце пароль аднаўлення';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Выкарыстоўвайце як мінімум сімвалы $min';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'Паролі адрозніваюцца';

  @override
  String get syncRecoveryCode => 'Код аднаўлення';

  @override
  String get syncRecoveryCodeTitle => 'Захавайце код аднаўлення';

  @override
  String get syncRecoveryCodeDescription =>
      'Калі кожная ваша прылада будзе страчана, гэты код аднаўляе ваш сінхранізаваны дзённік. Захоўвайце яго ў менеджэры пароляў або на паперы. Ён паказаны толькі гэты раз.';

  @override
  String get syncRecoveryCodeCopied => 'Код аднаўлення скапіраваны';

  @override
  String get syncRecoveryCodeSaved => 'Я захаваў яго';

  @override
  String get syncJoinNeedsKey =>
      'Гэты сінхранізаваны дзённік належыць іншым вашым прыладам. Спалучайцеся з адным з іх або выкарыстоўвайце код аднаўлення. Да яго будуць дададзены запісы на гэтай прыладзе.';

  @override
  String get syncPairDevice => 'Спалучэнне з прыладай';

  @override
  String get syncUseRecoveryCode => 'Выкарыстоўвайце код аднаўлення';

  @override
  String get syncAddDevice => 'Дадайце прыладу';

  @override
  String get syncChangeRecoveryCode => 'Зменіце код аднаўлення';

  @override
  String get syncChangeRecoveryDescription =>
      'Новы код замяняе бягучы, які перастае працаваць. Вашы даныя і іншыя прылады застаюцца такімі, якія яны ёсць.';

  @override
  String get syncNewRandomCode => 'Новы выпадковы код';

  @override
  String get syncRecoveryCodeChanged => 'Код аднаўлення зменены';

  @override
  String get syncResetSpace => 'Пачніце сінхранізаваны дзённік спачатку';

  @override
  String get syncResetSpaceDescription =>
      'Толькі калі ніякая прылада і код аднаўлення не адкрываюць яго: сінхранізаваная копія замяняецца дзённікам на гэтай прыладзе пад ключамі гэтай прылады. Затым іншыя вашы прылады спалучаюцца зноў.';

  @override
  String get syncPairTitle => 'Спалучэнне прылад';

  @override
  String get syncPairShow => 'Паказаць код';

  @override
  String get syncPairEnter => 'Увядзіце код';

  @override
  String get syncPairShowHint =>
      'На іншай прыладзе адкрыйце Спалучэнне прылад, абярыце Увядзіце код і ўвядзіце або адсканіруйце гэта.';

  @override
  String get syncPairEnterHint =>
      'Увядзіце код, які паказвае ваша іншая прылада, або адсканіруйце яго.';

  @override
  String get syncPairCode => 'Код спалучэння';

  @override
  String get syncPairScan => 'сканаваць';

  @override
  String get syncPairStart => 'Пара';

  @override
  String get syncPairWaiting => 'Чаканне іншай прылады…';

  @override
  String syncPairDone(String device) {
    return 'У пары з $device';
  }

  @override
  String get syncPairWrongCode =>
      'Код не супаў. Пакажыце новы код і паўтарыце спробу.';

  @override
  String get syncPairNoOffer =>
      'Ні адна прылада не паказвае гэты код. Магчыма, ён скончыўся.';

  @override
  String get syncPairTimedOut => 'Іншая прылада не адказала своечасова.';

  @override
  String get syncPairNeither =>
      'Гэты сінхранізаваны дзённік яшчэ не настроены ні на адной прыладзе.';

  @override
  String get syncPairBoth =>
      'Абедзве прылады ўжо адкрываюць гэты сінхранізаваны дзённік.';

  @override
  String syncPairFailed(String error) {
    return 'Спалучэнне не атрымалася: $error';
  }

  @override
  String get syncMediaPending =>
      'Дзённік сінхранізаваны · некаторыя мультымедыя ўсё яшчэ перадаюцца';

  @override
  String get syncWaitingForDevices =>
      'Дзённік сінхранізаваны · чаканне перадачы мультымедыя з іншай прылады';

  @override
  String get syncCacheNotice =>
      'Воблачныя медыя з\'яўляюцца часовымі. Захоўвайце арыгіналы на сваіх прыладах; сінхранізацыя не з\'яўляецца рэзервовай копіяй.';

  @override
  String get paperTitle => 'Літарная папера';

  @override
  String get paperPlain => 'Раўніна';

  @override
  String get paperLined => 'Выкладзеныя';

  @override
  String get paperGrid => 'Сетка';

  @override
  String get paperTinted => 'Таніраванае';

  @override
  String get paperDecorationTitle => 'Упрыгажэнні';

  @override
  String get paperDecorationNone => 'Няма';

  @override
  String get paperDecorationBotanical => 'Лісце';

  @override
  String get paperDecorationStars => 'Зоркі';

  @override
  String get paperDecorationWashi => 'Васі стужка';

  @override
  String get themeDarkChoice => 'Цёмны выгляд';

  @override
  String get themeDarkSame => 'Выконвайце светлую палітру';

  @override
  String get themeDarkCustom => 'Асобная палітра';

  @override
  String get themeDarkAccent => 'Цёмны колер акцэнту';

  @override
  String get themeColorTeal => 'Чыркаваты';

  @override
  String get themeColorCyan => 'Блакітны';

  @override
  String get themeColorIndigo => 'Індыга';

  @override
  String get themeColorCoral => 'Каралавы';

  @override
  String get themeColorOlive => 'Аліўкавы';

  @override
  String get themeColorSlate => 'Шыфер';

  @override
  String get drawingTitle => 'Маляванне';

  @override
  String get drawingPen => 'Пяро';

  @override
  String get drawingEraser => 'Гумка';

  @override
  String get drawingUndo => 'Адмяніць';

  @override
  String get drawingClear => 'Ясна';

  @override
  String get drawingWidth => 'Шырыня ручкі';

  @override
  String get drawingStylusOnly => 'Толькі стілус';

  @override
  String get drawingDiscardTitle => 'Адхіліць малюнак?';

  @override
  String get drawingDiscardBody => 'Гэты малюнак не захаваўся.';

  @override
  String get drawingSaveError => 'Не ўдалося захаваць малюнак.';

  @override
  String get syncNetworkTitle => 'Дыягностыка сеткі';

  @override
  String get syncNetworkRefresh => 'Абнавіць';

  @override
  String get syncNetworkSelectedRoute => 'Бягучы шлях';

  @override
  String get syncNetworkAvailableRoutes => 'Даступныя шляхі';

  @override
  String get syncNetworkSignaling => 'Падключэнне каталога прылад';

  @override
  String get syncNetworkRelayRemaining => 'Пакінуты прыпуск на эстафету';

  @override
  String get syncNetworkIcePair => 'Кандыдаты на прамое падключэнне';

  @override
  String get syncNetworkPeerTrusted => 'Аўтэнтыфікаваная прылада';

  @override
  String get syncNetworkNoRoute => 'Чаканне злучэння';

  @override
  String get syncNetworkUnavailable => 'Дыягностыка недаступная';

  @override
  String get syncMediaCopiesTitle => 'Дастаўка носьбітаў і копій';

  @override
  String get syncMediaPendingCount => 'Чаканне перадачы';

  @override
  String get syncMediaDurableCount => 'Здаецца на асабістае захоўванне';

  @override
  String get syncMediaTemporaryCount => 'Часовыя або непацверджаныя копіі';

  @override
  String get syncMediaReceiptExplanation =>
      'Гэтыя падлікі апісваюць завершаныя пастаўкі, а не новы аўдыт захаваных рэзервовых копій.';

  @override
  String get syncMediaCacheExplanation =>
      'Тэрмін дзеяння часовых хмарных носьбітаў можа скончыцца. Захоўвайце арыгіналы або асобную рэзервовую копію.';

  @override
  String get momentsTitle => 'Фота моманты';

  @override
  String get momentsHint =>
      'Знайдзіце групы, выкарыстоўваючы мясцовы час фатаграфій і дадатковыя каардынаты. Фатаграфіі далучаюцца толькі пры выбары карты.';

  @override
  String get momentsScan => 'Знайдзіце моманты';

  @override
  String get momentsChooseFolder => 'Выберыце тэчку з фота';

  @override
  String get momentsLocation => 'Уключыце месцы фатаграфій';

  @override
  String get momentsEmpty => 'Няма апошніх фотагруп.';

  @override
  String get momentsCreate => 'Напішыце пра гэтыя фатаграфіі';

  @override
  String get momentsDismiss => 'Звольніць';

  @override
  String get momentsError => 'Не ўдалося прачытаць мясцовыя фота.';

  @override
  String get momentsCreated => 'Фотаздымак створаны.';

  @override
  String get momentsPermission =>
      'Дазвольце доступ да фатаграфій, каб знайсці мясцовыя прапановы.';

  @override
  String get momentsScope =>
      'Толькі апошнія фатаграфіі; не больш за 500 фатаграфій і 20 фатаграфій на картку.';

  @override
  String momentsPhotoCount(int count) {
    return 'Фота $count';
  }

  @override
  String get nearbyTitle => 'Падключыце прылады';

  @override
  String get nearbySend => 'Аўтарызаваць іншую прыладу';

  @override
  String get nearbyReceive => 'Падключыцеся да існуючай прылады';

  @override
  String get nearbyInstructions =>
      'Падключыце абедзве прылады да аднаго Wi-Fi або да кропкі доступу адна адной. Пацвердзіце аўтарызацыю на існуючай прыладзе; абодва прылады застаюцца прыдатнымі да выкарыстання. Інтэрнэт не патрабуецца.';

  @override
  String get nearbyCompare =>
      'Параўнайце гэты код на абедзвюх прыладах перад ухваленнем.';

  @override
  String get nearbyConfirm => 'Коды супадаюць';

  @override
  String get nearbyScan => 'Сканіруйце код іншай прылады';

  @override
  String get nearbyPaste => 'Уставіць запрашэнне';

  @override
  String get nearbyWaiting => 'Чаканне зацвярджэння на іншай прыладзе';

  @override
  String get nearbyWorking =>
      'Аўтарызацыя і сінхранізацыя вашага дзённіка і ўкладанняў...';

  @override
  String get nearbyPending =>
      'Некаторыя далучэнні ўсё яшчэ патрабуюць сінхранізацыі. Падтрымлівайце іншую прыладу ў сетцы і паўтарыце спробу.';

  @override
  String get nearbyComplete =>
      'Прылада падключана; дзённік і ўкладанні сінхранізуюцца';

  @override
  String get nearbyFailed =>
      'Злучэнне не завершана. Праверце лакальнае злучэнне і паўтарыце спробу.';

  @override
  String get nearbyEmptyRequired =>
      'Выкарыстоўвайце прыладу з пустым дзённікам, якая яшчэ не падключана для сінхранізацыі.';

  @override
  String get nearbyRetry => 'Працягнуць сінхранізацыю';

  @override
  String get nearbyWifi => 'Налады Wi-Fi';

  @override
  String get nearbyHotspot => 'Налады кропкі доступу';

  @override
  String get nearbyKeepOpen =>
      'Трымайце гэтую старонку адкрытай, пакуль новая прылада не скончыцца. Тэрмін дзеяння запрашэння заканчваецца праз дзве хвіліны.';

  @override
  String get syncDevicesTitle => 'Аўтарызаваныя прылады';

  @override
  String get syncDevicesDescription =>
      'Толькі зацверджаныя прылады могуць атрымаць доступ да гэтага ўліковага запісу AID. Адкліканне прылады блакуе сервер, але не можа сцерці галоўны ключ або дзённік, ужо скапіраваны на яго.';

  @override
  String get syncDeviceRequest =>
      'Пакажыце гэты QR аўтарызацыі на зацверджанай прыладзе';

  @override
  String get syncDeviceAuthorize => 'Аўтарызаваць прыладу';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Адсканіруйце або ўстаўце запыт на аўтарызацыю новай прылады.';

  @override
  String get syncDeviceRevoke => 'Адклікаць';

  @override
  String get syncDeviceRotate => 'Павярніце ключ подпісу гэтай прылады';

  @override
  String get syncDeviceCheck => 'Праверце аўтарызацыю';

  @override
  String get syncDeviceHardware => 'Ключ подпісу з апаратнай падтрымкай';

  @override
  String get syncDeviceSoftware =>
      'Ключ подпісу праграмнага забеспячэння, які не падлягае экспарту';

  @override
  String get syncDeviceUnavailable =>
      'Аўтарызацыя прылады недаступная. Ухваліце ​​гэту прыладу з іншай аўтарызаванай прылады і паўтарыце спробу.';

  @override
  String get syncDeviceRevoked => 'Адкліканы';

  @override
  String get syncDeviceLocal => 'Гэта прылада';

  @override
  String get cloudTrafficTitle =>
      'Штомесячная воблачная квота перадачы медыяфайлаў';

  @override
  String get cloudTrafficLimit => 'Штомесячная квота перадачы дадзеных';

  @override
  String get cloudTrafficUsed => 'Выкарыстоўваецца перадача даных';

  @override
  String get cloudTrafficRemaining => 'Засталося перадаць даныя';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'Квота перадачы дадзеных скідае $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'Квота воблачнай перадачы даных для медыяфайлаў вычарпана. Адсутныя мультымедыйныя файлы будуць сінхранізавацца аўтаматычна, калі будзе даступна прамое злучэнне або квота будзе скінута.';

  @override
  String get cloudTrafficExplanation =>
      'Кэшаванне мультымедыйных файлаў і жывая рэтрансляцыя падзяляюць гэтую квоту перадачы даных. Прамыя злучэнні не спажываюць яго. Тэкст дзённіка і паведамленні кантролю злучэння маюць асобныя невялікія дзённыя ліміты.';

  @override
  String get appearanceThemeSection => 'Тэма прыкладання';

  @override
  String get appearancePaperSection => 'Папера для дзённіка';

  @override
  String get appearanceTypographySection => 'Тэкст дзённіка';

  @override
  String get appearancePreferencesSection => 'Агульныя перавагі';

  @override
  String get themeSystemAccentHint =>
      'Выкарыстоўвае сістэмную палітру замест уласных колераў. Выключыце яго, каб выбраць свой.';

  @override
  String get syncDeviceNameSaveFailed =>
      'Не ўдалося захаваць назву прылады. Калі ласка, паспрабуйце яшчэ раз.';

  @override
  String get nearbyConnectionHelp => 'Даведка па падключэнні';

  @override
  String get syncAllSynced => 'Усё сінхранізавана';

  @override
  String get syncDetailsTitle => 'Падрабязнасці сінхранізацыі';

  @override
  String get syncMore => 'Больш варыянтаў';

  @override
  String get syncDeviceName => 'Назва прылады';

  @override
  String get syncDeviceNameHint => 'Напрыклад: Мой планшэт';

  @override
  String get syncDeviceNameInvalid => 'Выкарыстоўвайце ад 1 да 32 сімвалаў';

  @override
  String get syncDeviceKeyDetails => 'Дэталі бяспекі';

  @override
  String get syncConnectionProblem =>
      'Зараз немагчыма сінхранізаваць. Аўтаматычны паўтор.';

  @override
  String get syncCopyComplete => 'Поўная копія дзённіка і медыяфайлаў';

  @override
  String get syncCopyPartial =>
      'Некаторыя сродкі масавай інфармацыі ўсё яшчэ адсутнічаюць';

  @override
  String get syncCopyOlder => 'Новыя змены чакаюць сінхранізацыі';

  @override
  String get syncCopyUnavailable =>
      'Падрабязныя звесткі аб копіі недаступныя. Паўтарыце спробу пазней.';

  @override
  String get syncCopyLastKnown =>
      'Іншыя прылады паказваюць сваю апошнюю пацверджаную копію. Пазасеткавыя прылады зараз немагчыма праверыць.';

  @override
  String get syncCopyTemporary =>
      'Часовы кэш. Захоўвайце арыгіналы на сваіх прыладах.';

  @override
  String get syncCopyStorage =>
      'Ваша сховішча для сінхранізацыі. Завершаныя загрузкі мультымедыя паказваюцца ў дыягностыцы.';

  @override
  String syncCopyChecked(String time) {
    return 'Апошні раз пацверджаны $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Перадача дадзеных засталася ў гэтым месяцы: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Пачаць тут';

  @override
  String get onboardConnect => 'Падключыцеся да існуючай прылады';

  @override
  String get onboardFailed =>
      'Не ўдалося завяршыць наладку. Ваш дзённік у бяспецы; паспрабуйце яшчэ раз.';

  @override
  String get tutorialTitle => 'Як карыстацца дзённікам';

  @override
  String get tutorialWriteTitle => 'Напішыце свой першы дзённікавы запіс';

  @override
  String get tutorialWriteText =>
      'Націсніце +, каб напісаць дзённікавы запіс. Дадайце неабавязковую назву, абярыце дату дзённіка і націсніце галачку, каб захаваць. Вы можаце адрэдагаваць свой дзённікавы запіс у любы час.';

  @override
  String get tutorialMediaTitle =>
      'Дадайце фатаграфіі, аўдыя або рукапісны тэкст';

  @override
  String get tutorialMediaText =>
      'Выкарыстоўвайце + у рэдактары дзённіка, каб далучыць фатаграфіі, відэа ці запіс голасу, або каб адкрыць палатно рукапіснага ўводу. Гэтыя ўкладанні захоўваюцца разам з запісам у дзённіку.';

  @override
  String get tutorialReviewTitle => 'Знайдзіце дзень зноў';

  @override
  String get tutorialReviewText =>
      'Праглядайце свой дзённік або каляндар, шукайце свае запісы і арганізуйце запісы з дапамогай тэгаў. На старонках \"Медыя\" і \"Атлас\" можна знайсці мінулыя запісы па фота або месцазнаходжанні.';

  @override
  String get tutorialSyncTitle => 'Выкарыстоўвайце некалькі прылад';

  @override
  String get tutorialSyncText =>
      'У Наладах → Даныя і сховішча → Сінхранізацыя падключыцеся да існуючай прылады і пацвердзіце аўтарызацыю на гэтай прыладзе. Абедзве прылады могуць працягваць карыстацца дзённікам. Тэкст дзённіка сінхранізуецца першым. Мультымедыйныя файлы сінхранізуюцца наступным чынам, калі гэта дазваляе падключэнне да сеткі і астатняя квота перадачы даных.';

  @override
  String get tutorialPrivacyTitle => 'Захоўвайце свой дзённік у бяспецы';

  @override
  String get tutorialPrivacyText =>
      'Запісы дзённіка застаюцца на гэтай прыладзе, пакуль вы не ўключыце сінхранізацыю, не абагуліце іх і не экспартуеце. Сінхранізацыя мае скразное шыфраванне. У наладах вы таксама можаце задаць пароль праграмы, стварыць рэзервовыя копіі і зноў адкрыць гэты падручнік.';

  @override
  String get editorDiaryDay => 'Дзень дзённіка';

  @override
  String get editorDiaryDayPicker => 'Дзень запісу · час стварэння нязменны';

  @override
  String get editorDiaryDayHint =>
      'Дзень, да якога належыць гэты запіс. Яго змена не змяняе час стварэння запісу.';

  @override
  String get hiddenDiaryTitle => 'Схаваныя запісы';

  @override
  String get hiddenDiaryHide => 'Схаваць запіс';

  @override
  String get hiddenDiaryShow => 'Паказаць запіс';

  @override
  String get hiddenDiaryEmpty => 'Няма схаваных запісаў';

  @override
  String get hiddenDiaryUnlock => 'Адкрыць схаваныя запісы';

  @override
  String get hiddenDiaryAuthHint =>
      'Выкарыстайце блакіроўку праграмы або экрана прылады.';

  @override
  String get hiddenDiaryLocalOnly =>
      'Схаваныя запісы застаюцца на гэтай прыладзе; сінхранізацыя прыпыняецца. Выкарыстоўвайце зашыфраваныя рэзервовыя копіі. Іншыя наяўныя копіі не змяняюцца.';

  @override
  String get moodClear => 'Ачысціць настрой';

  @override
  String get scrollToTop => 'Угору';

  @override
  String get feedbackTitle => 'Водгук';

  @override
  String get feedbackHint => 'Апішыце праблему або прапанову';

  @override
  String get feedbackGithub => 'Задача на GitHub';

  @override
  String get feedbackEmail => 'Напісаць ліст';

  @override
  String get feedbackCopy => 'Капіяваць тэкст';

  @override
  String get feedbackLaunchFailed =>
      'Не ўдалося адкрыць праграму. Скапіруйце тэкст і скарыстайце пошту ніжэй.';

  @override
  String get feedbackCopied => 'Водгук скапіяваны';
}
