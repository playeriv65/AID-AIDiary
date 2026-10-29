// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => 'Цвят на темата';

  @override
  String get themeColorHint => 'Изберете цвят за тази палитра.';

  @override
  String get themeColorBlue => 'Небесно синьо';

  @override
  String get themeColorGreen => 'Горско зелено';

  @override
  String get themeColorBrown => 'Топло кафе';

  @override
  String get themeColorPurple => 'Лавандула';

  @override
  String get themeColorRose => 'Прашна роза';

  @override
  String get themeColorAmber => 'Амбър';

  @override
  String get themeColorPreview => 'Всеки ден по малко';

  @override
  String get themeTintBackgroundTitle => 'Оцветете фонове с тематичен цвят';

  @override
  String get themeTintBackgroundHint =>
      'Изключете за неутрален сив фон; бутоните запазват избрания от вас цвят.';

  @override
  String get dailyReminderTitle => 'Води Докладна!';

  @override
  String get dailyReminderDescription => 'Вземи дневния си журнал…';

  @override
  String get actionTakePhoto => 'Направете снимка';

  @override
  String get flashbacksTitle => 'Спомени';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Отлъчи лоши дни';

  @override
  String get flashbackGoodDay => 'Хубав Ден';

  @override
  String get flashbackRandomDay => 'Произволен Ден';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count преди седмици',
      one: '$count преди седмица',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Преди $count месеца',
      one: 'Преди $count месец',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Преди $count години',
      one: 'Преди $count година',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'На този ден';

  @override
  String get searchLogsHint => 'Търсене на записи в дневника...';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count записа в дневника',
      one: '$count запис в дневника',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дни',
      one: '$count ден',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count думи',
      one: '$count дума',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Няма записи в дневника…';

  @override
  String get noResults => 'Няма резултати…';

  @override
  String get sortOrderAscendingTitle => 'Възходящо';

  @override
  String get sortOrderDescendingTitle => 'Спускане';

  @override
  String get pageStatisticsTitle => 'Статистика';

  @override
  String get statisticsNotEnoughData => 'Няма достатъчно данни…';

  @override
  String get statisticsRangeOneMonth => '1 месец';

  @override
  String get statisticsRangeSixMonths => '6 месеца';

  @override
  String get statisticsRangeOneYear => '1 година';

  @override
  String get statisticsRangeAllTime => 'Всички времена';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag Резюме';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag По ден';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag С течение на времето';
  }

  @override
  String get chartGroupingLabel => 'Групиране по';

  @override
  String get chartGroupingDay => 'ден';

  @override
  String get chartGroupingWeek => 'седмица';

  @override
  String get chartGroupingMonth => 'месец';

  @override
  String get chartGroupingYear => 'година';

  @override
  String get chartSmoothingLabel => 'Изглаждане';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Текуща серия $count',
      one: 'Текуща серия $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Най-дълга поредица $count',
      one: 'Най-дълга поредица $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Страхотни дни $count',
      one: 'Страхотни дни $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Дни след лош ден $count',
      one: 'Дни след един лош ден $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Няма достъп до външно хранилище';

  @override
  String get errorExternalStorageAccessDescription =>
      'Ако използвате мрежово хранилище, уверете се, че услугата е онлайн и имате достъп до мрежата.\n\nВ противен случай приложението може да е загубило разрешения за външната папка. Отидете в настройките и изберете отново външната папка, за да предоставите достъп.\n\nПредупреждение, промените няма да бъдат синхронизирани, докато не възстановите достъпа до външното място за съхранение!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Продължете с локална база данни';

  @override
  String get lastModified => 'Променен';

  @override
  String get writeSomethingHint => 'Напиши нещо...';

  @override
  String get titleHint => 'Заглавие…';

  @override
  String get deleteLogTitle => 'Изтриване на запис в дневника';

  @override
  String get deleteLogDescription =>
      'Записът се премества в Наскоро изтрити, където можете да го възстановите.';

  @override
  String get deletePhotoTitle => 'Изтриване на прикачения файл';

  @override
  String get deletePhotoDescription =>
      'Сигурни ли сте, че искате да изтриете този прикачен файл?';

  @override
  String get pageSettingsTitle => 'Настройки';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get themeSystem => 'система';

  @override
  String get themeLight => 'светлина';

  @override
  String get themeDark => 'Тъмно';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Първи ден от седмицата';

  @override
  String get settingsCalendarSystem => 'Календарна система';

  @override
  String get calendarSystemGregorian => 'григориански';

  @override
  String get calendarSystemJalali => 'Джалали';

  @override
  String get settingsUseSystemAccentColor => 'Използвайте System Accent Color';

  @override
  String get settingsCustomAccentColor => 'Персонализиран цвят на акцента';

  @override
  String get settingsShowFlashbacks => 'Показване на ретроспекции';

  @override
  String get settingsChangeMoodIcons => 'Промяна на иконите за настроение';

  @override
  String get moodIconPrompt => 'Въведете икона';

  @override
  String get settingsHideImages => 'Скриване на изображения';

  @override
  String get pageCalendarTitle => 'Календар';

  @override
  String get settingsNotificationsTitle => 'Известия';

  @override
  String get settingsDailyReminderTitle => 'Ежедневно напомняне';

  @override
  String get settingsOnThisDayDescription => 'Прегледайте минали спомени';

  @override
  String get settingsDailyReminderDescription => 'Нежно напомняне всеки ден';

  @override
  String get settingsReminderTime => 'Време за напомняне';

  @override
  String get settingsFixedReminderTimeTitle => 'Фиксиран час за напомняне';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Изберете фиксиран час за напомнянето';

  @override
  String get settingsAlwaysSendReminderTitle => 'Винаги изпращайте напомняне';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Изпратете напомняне, дори ако записът в дневника вече е започнат';

  @override
  String get settingsCustomizeNotificationTitle =>
      'Персонализиране на известията';

  @override
  String get settingsTemplatesTitle => 'Шаблони';

  @override
  String get manageTemplates => 'Управление на шаблони';

  @override
  String get noTemplateTitle => 'Няма';

  @override
  String get noTemplatesDescription => 'Все още няма създадени шаблони...';

  @override
  String get templateDefaultTimestampTitle => 'Времево клеймо';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Резюме на деня';

  @override
  String get templateDefaultSummaryBody => '### Резюме\n- \n\n### Цитат\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Отражение';

  @override
  String get templateDefaultReflectionBody =>
      '### Какво ви хареса днес?\n- \n\n### За какво си благодарен?\n- \n\n### Какво очакваш с нетърпение?\n- ';

  @override
  String get settingsTagsTitle => 'Етикети';

  @override
  String get manageTags => 'Управление на етикети';

  @override
  String get tagTypeLabelTitle => 'Етикет';

  @override
  String get tagTypeTrackerTitle => 'Тракер';

  @override
  String get nameHint => 'Име';

  @override
  String get tagColorLabel => 'Цвят';

  @override
  String get iconPickerTitle => 'Изберете Икона';

  @override
  String get iconPickerIconsTab => 'Икони';

  @override
  String get iconPickerCustomTab => 'По поръчка';

  @override
  String get iconPickerSearchHint => 'Икони за търсене...';

  @override
  String get colorPickerTitle => 'Изберете цвят';

  @override
  String get colorPickerPaletteTab => 'Цветове';

  @override
  String get iconGroupMoodPeople => 'Настроение и хора';

  @override
  String get iconGroupHealth => 'здраве';

  @override
  String get iconGroupWorkFinance => 'Работа и финанси';

  @override
  String get iconGroupHabitsGoals => 'Навици и цели';

  @override
  String get iconGroupNature => 'Природата';

  @override
  String get iconGroupFoodDrink => 'Храна и напитки';

  @override
  String get iconGroupHome => 'Начало';

  @override
  String get iconGroupTravel => 'Пътуване';

  @override
  String get iconGroupSymbols => 'Символи';

  @override
  String get tagCategoryLabel => 'Категория';

  @override
  String get tagLabel => 'Етикет';

  @override
  String get tagCategoryUncategorized => 'Некатегоризиран';

  @override
  String get newCategoryTitle => 'Нова категория';

  @override
  String get shareButtonLabel => 'Споделете';

  @override
  String get importErrorDescription => 'Неуспешно импортиране на файл!';

  @override
  String get exportErrorDescription => 'Неуспешно експортиране на файл!';

  @override
  String get deleteTitle => 'Изтриване';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Използва се в $count записа в дневника.',
      one: ' Използва се в $count дневник.',
      zero: '',
    );
    return 'Изтриване на „$name“?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Неговите $count тагове също ще бъдат изтрити.',
      one: ' Неговият $count таг също ще бъде изтрит.',
      zero: '',
    );
    return 'Изтриване на „$name“?$_temp0';
  }

  @override
  String get tagNameExists => 'Вече има етикет с това име';

  @override
  String get categoryNameExists => 'Вече има категория с това име';

  @override
  String deleteTemplateMessage(Object name) {
    return 'Изтриване на „$name“?';
  }

  @override
  String get addTagsTitle => 'Добавете етикети';

  @override
  String get addTagsSearchHint => 'Търсене на тагове...';

  @override
  String get tagsRecent => 'Наскоро използвани';

  @override
  String get tagNew => 'Нов етикет';

  @override
  String get tagFavoriteName => 'Любима';

  @override
  String get iconGroupActivities => 'дейности';

  @override
  String get iconGroupHobbies => 'Развлечение';

  @override
  String get settingsStorageTitle => 'Съхранение';

  @override
  String get settingsLogFolder => 'запис в дневника Папка';

  @override
  String get settingsImageFolder => 'Папка с изображения';

  @override
  String get warningTitle => 'Предупреждение';

  @override
  String get logFolderWarningDescription =>
      'Ако избраната папка вече съдържа файл \'aid_diary.db\', той ще бъде използван за презаписване на вашите съществуващи записи в дневника!';

  @override
  String get errorTitle => 'Грешка';

  @override
  String get logFolderErrorDescription =>
      'Неуспешна промяна на папката за запис в дневника!';

  @override
  String get imageFolderErrorDescription =>
      'Неуспешна промяна на папката с изображения!';

  @override
  String get backupErrorDescription => 'Неуспешно създаване на резервно копие!';

  @override
  String get restoreErrorDescription => 'Неуспешно възстановяване на архива!';

  @override
  String get settingsBackupRestoreTitle => 'Архивиране и възстановяване';

  @override
  String get settingsBackup => 'Архивиране';

  @override
  String get settingsRestore => 'Възстановяване';

  @override
  String get settingsRestorePromptDescription =>
      'Възстановяването на резервно копие ще презапише съществуващите ви данни!';

  @override
  String get settingsBackupPasswordProtect =>
      'Защитени с парола резервни копия';

  @override
  String get backupEncryptedTitle => 'Криптирано архивиране';

  @override
  String get backupEncryptedContent => 'Това архивиране е защитено с парола.';

  @override
  String get settingsAutoBackup => 'Автоматично архивиране';

  @override
  String get settingsAutoBackupLocation => 'Резервно местоположение';

  @override
  String get settingsAutoBackupInterval => 'Интервал на архивиране';

  @override
  String get settingsAutoBackupIntervalDaily => 'Ежедневно';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Ежеседмично';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Месечно';

  @override
  String get settingsAutoBackupMaxCount => 'Резервни копия за запазване';

  @override
  String get settingsAutoBackupRequireCharging => 'Само по време на зареждане';

  @override
  String settingsBackupLast(Object time) {
    return 'Последно архивиране $time';
  }

  @override
  String get settingsBackupNever => 'Никога не е архивирано';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Следващо архивиране $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'Всички';

  @override
  String get autoBackupFailedTitle => 'Неуспешно архивиране';

  @override
  String tranferStatus(Object percent) {
    return 'Прехвърляне... $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Създаване на резервно копие... $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Възстановява се архивиране... $percent%';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return 'Шифроване на резервното копие... $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Декриптиране на архива... $percent%';
  }

  @override
  String get cleanUpStatus => 'Почистване...';

  @override
  String get settingsExportToAnotherFormat => 'Експортиране в друг формат';

  @override
  String get settingsExportFormatDescription =>
      'Това не трябва да се използва като резервно копие!';

  @override
  String get settingsImportFromAnotherApp => 'Импортиране от друго приложение';

  @override
  String get logFormatTitle => 'Изберете Формат';

  @override
  String get logFormatDescription =>
      'Форматът на друго приложение може да не поддържа всички функции. Моля, докладвайте за всякакви проблеми, тъй като форматите на трети страни могат да се променят по всяко време. Това няма да повлияе на съществуващите записи в дневника!';

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
  String get settingsDeleteAllLogsTitle =>
      'Изтриване на всички записи в дневника';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Искате ли да изтриете всичките си записи в дневника?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Въведете „$prompt“, за да потвърдите. Това не може да бъде отменено!';
  }

  @override
  String get settingsAppLanguageTitle => 'Език на приложението';

  @override
  String get settingsSecurityTitle => 'сигурност';

  @override
  String get settingsSecurityRequirePassword => 'Изискване на парола';

  @override
  String get settingsSecurityEnterPassword => 'Въведете парола';

  @override
  String get settingsSecuritySetPassword => 'Задайте парола';

  @override
  String get settingsSecurityChangePassword => 'Промяна на паролата';

  @override
  String get settingsSecurityPassword => 'Парола';

  @override
  String get settingsSecurityConfirmPassword => 'Потвърдете паролата';

  @override
  String get settingsSecurityOldPassword => 'Стара парола';

  @override
  String get settingsSecurityIncorrectPassword => 'Неправилна парола';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'Паролите не съвпадат';

  @override
  String get requiredPrompt => 'Задължително';

  @override
  String get settingsSecurityBiometricUnlock => 'Биометрично отключване';

  @override
  String get unlockAppPrompt => 'Отключете приложението';

  @override
  String get settingsAboutTitle => 'За';

  @override
  String get settingsVersion => 'Версия';

  @override
  String get settingsLicense => 'Лиценз';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsOpenSourceLicenses => 'Лицензи с отворен код';

  @override
  String get tagMoodTitle => 'настроение';

  @override
  String get selectTagTitle => 'Изберете Етикет';

  @override
  String get labelPresentLabel => 'Настояще';

  @override
  String get labelAbsentLabel => 'отсъства';

  @override
  String get labelCoverageLabel => 'Покритие';

  @override
  String chartDistributionTitle(Object tag) {
    return '$tag Разпределение';
  }

  @override
  String get shareAddToLogPickerTitle => 'Изберете запис в дневника';

  @override
  String get adaptiveEmptyDay => 'Все още няма записи за този ден';

  @override
  String get adaptiveNewEntry => 'Напишете запис';

  @override
  String get pageJournalTitle => 'Журнал';

  @override
  String get coachPrompt1 => 'Какво ви накара да се усмихнете днес?';

  @override
  String get coachPrompt2 => 'Кое е едно нещо, което научи днес?';

  @override
  String get coachPrompt3 => 'С кого говорихте днес и какво беше чувството?';

  @override
  String get coachPrompt4 => 'За какво си благодарен в момента?';

  @override
  String get coachPrompt5 => 'Какво отне най-много енергия днес?';

  @override
  String get coachPrompt6 => 'Опишете малък момент, който искате да запомните.';

  @override
  String get coachPrompt7 => 'Какво би направило утрешния ден добър?';

  @override
  String get coachPrompt8 => 'Какво ви е на ум напоследък?';

  @override
  String get coachPrompt9 => 'Какво направи днес само за себе си?';

  @override
  String get coachPrompt10 => 'Ако днес имаше заглавие, какво би било то?';

  @override
  String get pageMediaTitle => 'Медия';

  @override
  String get pageAtlasTitle => 'Атлас';

  @override
  String get pageCoachTitle => 'Треньор';

  @override
  String get noEntrySelected => 'Няма избран запис.';

  @override
  String get entryShare => 'Споделете';

  @override
  String get entryFavorite => 'звезда';

  @override
  String get entryEdit => 'Редактиране';

  @override
  String get entryPrevious => 'Предишен запис';

  @override
  String get entryNext => 'Следващ запис';

  @override
  String get journalStories => 'Истории';

  @override
  String get journalEntries => 'Вписвания';

  @override
  String get journalEmptyHint =>
      'Започнете дневника си, като добавите нов запис.';

  @override
  String get storyToday => 'Днес';

  @override
  String get storyThrowback => 'Връщане назад';

  @override
  String get storyNoThrowback => 'Днес няма връщане назад';

  @override
  String get mediaFiles => 'Медийни файлове';

  @override
  String get mediaEmpty => 'Все още няма снимки.';

  @override
  String get mediaEmptyHint =>
      'Снимките, прикачени към записите, ще бъдат показани тук.';

  @override
  String get atlasEmpty => 'Няма записи с местоположение.';

  @override
  String get atlasEmptyHint => 'Тук ще се показват записи с местоположение.';

  @override
  String get atlasShowAll => 'Покажи всички записи';

  @override
  String get atlasMyLocation => 'Моето местоположение';

  @override
  String get coachAll => 'Всички';

  @override
  String get coachPrograms => 'Програми';

  @override
  String get coachTemplates => 'Шаблони';

  @override
  String get coachKindProgram => 'програма';

  @override
  String get coachKindTemplate => 'Шаблон';

  @override
  String get coachNoTemplates => 'Без програми или шаблони.';

  @override
  String get coachUseTemplate => 'Пишете с този шаблон';

  @override
  String get coachProgramEverydayTitle => 'Всекидневни моменти';

  @override
  String get coachProgramEverydayDescription =>
      'Пет кратки въпроса, по един на ден. Всеки отнема минута или две и ви помага да видите какво е направило деня ваш. Нежен начин да изградите навик да пишете по малко всеки ден.';

  @override
  String get coachProgramReflectTitle => 'Гледайки навътре';

  @override
  String get coachProgramReflectDescription =>
      'Един по-задълбочен въпрос на седмица, в продължение на пет седмици. Отделете време за всеки: как се чувствате, какво ви изморява, за какво сте благодарни.';

  @override
  String get searchFilters => 'Филтри';

  @override
  String get searchFilterTags => 'Етикети';

  @override
  String get searchFilterStarred => 'Със звезда';

  @override
  String get searchHint => 'Въведете за търсене или изберете филтър.';

  @override
  String get locationTitle => 'Местоположение';

  @override
  String get locationName => 'Име на място';

  @override
  String get locationRemove => 'Премахнете';

  @override
  String get locationServiceDisabled =>
      'Услугите за местоположение са изключени.';

  @override
  String get locationPermissionDenied =>
      'Разрешението за местоположение беше отказано.';

  @override
  String get locationUnavailable =>
      'Не може да се получи текущото местоположение.';

  @override
  String get calendarJumpToToday => 'Отидете до днес';

  @override
  String get editorStartWriting => 'Започнете да пишете или изберете a ';

  @override
  String get editorTemplateLink => 'Шаблон';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Изберете шаблон';

  @override
  String get templateFeatured => 'Представени шаблони';

  @override
  String get templateMine => 'Моите шаблони';

  @override
  String get templateDailyName => 'Ежедневен преглед';

  @override
  String get templateDailyDescription =>
      'Какво се случи, как се почувствах и какво следва.';

  @override
  String get templateDailyText =>
      '## Какво се случи днес\n\n\n## Как се почувствах\n\n\n## Три неща, за които съм благодарен\n1. \n2. \n3. \n\n## Утре\n';

  @override
  String get templateTravelName => 'Запис в дневника на пътуването';

  @override
  String get templateTravelDescription => 'Места, моменти и храна от пътя.';

  @override
  String get templateTravelText =>
      '## Къде отидох\n\n\n## Моментът, който помня най-много\n\n\n## Какво ядох\n\n\n## Планове за утре\n';

  @override
  String get templateReadingName => 'Четене на бележки';

  @override
  String get templateReadingDescription => 'Цитати и мисли от прочетеното.';

  @override
  String get templateReadingText =>
      '## Книга\n\n\n## Къде съм\n\n\n## Цитати\n> \n\n## Моите мисли\n';

  @override
  String get templateWeeklyName => 'Седмичен преглед';

  @override
  String get templateWeeklyDescription =>
      'Акценти, борби и фокус следващата седмица.';

  @override
  String get templateWeeklyText =>
      '## Акценти\n\n\n## Какво беше трудно\n\n\n## Какво научих\n\n\n## Фокус за следващата седмица\n';

  @override
  String get entrySaveAsTemplate => 'Запазете като шаблон';

  @override
  String get entrySavedAsTemplate => 'Запазено като шаблон';

  @override
  String get storyStatistics => 'Статистика';

  @override
  String get storyMoodChart => 'Диаграма на настроението';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return '$entries записи · $days дни';
  }

  @override
  String get storyThisYear => 'Тази година';

  @override
  String get storyLastYear => 'Миналата година';

  @override
  String get storyTapToOpen => 'Докоснете ден, за да го отворите';

  @override
  String get settingsGeneralTitle => 'генерал';

  @override
  String get settingsDataTitle => 'Данни и съхранение';

  @override
  String get settingsStoriesTitle => 'Истории';

  @override
  String get settingsHelpTitle => 'Помощ и относно';

  @override
  String get weatherTitle => 'Времето';

  @override
  String get weatherClear => 'ясно';

  @override
  String get weatherPartlyCloudy => 'Частична облачност';

  @override
  String get weatherCloudy => 'Облачно';

  @override
  String get weatherFog => 'мъгла';

  @override
  String get weatherDrizzle => 'Дъжд';

  @override
  String get weatherRain => 'дъжд';

  @override
  String get weatherSnow => 'сняг';

  @override
  String get weatherStorm => 'гръмотевична буря';

  @override
  String get weatherFetch => 'Вземете времето за този запис';

  @override
  String get weatherNeedsLocation =>
      'Първо добавете местоположение с координати.';

  @override
  String get weatherUnavailable =>
      'Времето не е налично за това място и време.';

  @override
  String get weatherRemove => 'Премахване на времето';

  @override
  String get weatherTemperature => 'Температура';

  @override
  String get activityStill => 'Все още';

  @override
  String get activityWalking => 'ходене';

  @override
  String get activityRunning => 'бягане';

  @override
  String get activityCycling => 'Колоездене';

  @override
  String get activityVehicle => 'В превозно средство';

  @override
  String get activityFlying => 'летене';

  @override
  String get activityExercise => 'Упражнение';

  @override
  String get settingsAutoAddTitle => 'Добавете автоматично';

  @override
  String get settingsAutoAddLocation => 'Местоположение';

  @override
  String get settingsAutoAddWeather => 'Времето';

  @override
  String get settingsAutoAddHint =>
      'Новите записи се попълват, когато бъдат създадени.';

  @override
  String get settingsTemperatureUnit => 'Температурна единица';

  @override
  String get settingsCelsius => 'Целзий (°C)';

  @override
  String get settingsFahrenheit => 'Фаренхайт (°F)';

  @override
  String get moodGreat => 'страхотно';

  @override
  String get moodGood => 'добре';

  @override
  String get moodOkay => 'окей';

  @override
  String get moodBad => 'лошо';

  @override
  String get moodAwful => 'Ужасно';

  @override
  String get locationSearchHint => 'Търсене на място';

  @override
  String get locationSearchEmpty => 'Няма намерени места';

  @override
  String get settingsWallpaper => 'Тапет';

  @override
  String get wallpaperNone => 'Няма';

  @override
  String get wallpaperDots => 'Точки';

  @override
  String get wallpaperGrid => 'Решетка';

  @override
  String get wallpaperLines => 'Линии';

  @override
  String get wallpaperPhoto => 'Снимка…';

  @override
  String get settingsFontFamily => 'Шрифт';

  @override
  String get fontSystem => 'система';

  @override
  String get fontSerif => 'Със серифи';

  @override
  String get fontMono => 'Монопространство';

  @override
  String get settingsFontSize => 'Размер на шрифта';

  @override
  String get fontSizeSmall => 'малък';

  @override
  String get fontSizeMedium => 'Среден';

  @override
  String get fontSizeLarge => 'Голям';

  @override
  String get fontSizeExtraLarge => 'Изключително голям';

  @override
  String get settingsLineSpacing => 'Разстояние между редовете';

  @override
  String get lineSpacingCompact => 'Компактен';

  @override
  String get lineSpacingNormal => 'нормално';

  @override
  String get lineSpacingRelaxed => 'Отпуснат';

  @override
  String get moodAssociationsTitle => 'Какво ме кара да се чувствам...';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching от $total записи';
  }

  @override
  String get videoRecord => 'Запишете видеоклип';

  @override
  String get videoChoose => 'Изберете видеоклип';

  @override
  String get audioRecordTitle => 'Запишете гласова бележка';

  @override
  String get audioChoose => 'Изберете аудио файл';

  @override
  String get audioStart => 'Записвайте';

  @override
  String get audioStop => 'Спрете и запазете';

  @override
  String get audioPermissionDenied =>
      'Достъпът до микрофона е изключен. Разрешете го в системните настройки.';

  @override
  String get mediaTooLarge => 'Този видеоклип е твърде голям за прикачване.';

  @override
  String get mediaUnavailable =>
      'Този прикачен файл не е наличен на това устройство.';

  @override
  String get widgetDone => 'Днешният запис е написан';

  @override
  String get widgetPending => 'как мина денят ти';

  @override
  String get widgetWrite => 'Пишете';

  @override
  String get insertChecklist => 'Контролен списък';

  @override
  String get insertNumberedList => 'Номериран списък';

  @override
  String get insertTable => 'Таблица';

  @override
  String get insertDivider => 'Разделител';

  @override
  String get insertCodeBlock => 'Кодов блок';

  @override
  String get journalSortTitle => 'Сортиране на записи';

  @override
  String get journalSortUpdated => 'Последна актуализация';

  @override
  String get settingsTimeFormat => 'Формат на времето';

  @override
  String get settingsDayStart => 'Новите записи се броят за предния ден до';

  @override
  String get settingsDayAskUntil => 'След това попитайте до кой ден';

  @override
  String get settingsDayStartMidnight => 'Изкл';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Всеки запис запазва деня, към който принадлежи, до часа, в който е написан, и можете да промените този ден в редактора по всяко време. Тези часове избират само деня за нови записи, така че промяната им не премества нито един съществуващ запис.';

  @override
  String get lateNightBadge =>
      'Написано късно през нощта, преброено за предния ден';

  @override
  String editorDayAsk(String time) {
    return 'Написано на $time. За кой ден е?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (вчера)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (днес)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'Написано $when';
  }

  @override
  String get timeFormat12 => '12-часов';

  @override
  String get timeFormat24 => '24-часов';

  @override
  String get settingsReminderDays => 'Напомни ми за';

  @override
  String get locationRecent => 'Последни места';

  @override
  String get shareImage => 'Споделете изображение';

  @override
  String get shareSaveImage => 'Запазване на изображението';

  @override
  String get shareSaved => 'Изображението е запазено';

  @override
  String get deletedTitle => 'Наскоро изтрит';

  @override
  String get deletedNone => 'Нищо не е изтрито наскоро';

  @override
  String deletedHint(int days) {
    return 'Изтритите записи остават тук за $days дни, след което се изтриват.';
  }

  @override
  String deletedDaysLeft(int days) {
    return 'Остават $days дни';
  }

  @override
  String get deletedRestore => 'Възстановяване';

  @override
  String get deletedDeleteForever => 'Изтрий завинаги';

  @override
  String get deletedDeleteForeverDescription =>
      'Записът и прикачените към него файлове се изтриват. Това не може да бъде отменено.';

  @override
  String get deletedEmpty => 'празна';

  @override
  String get deletedEmptyDescription =>
      'Изтриване на всеки запис в Наскоро изтрити? Това не може да бъде отменено.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Случайна разходка';

  @override
  String get randomSubtitle => 'Отворете минал запис';

  @override
  String get randomNext => 'друг';

  @override
  String get randomAll => 'Всички';

  @override
  String get randomWithPhotos => 'Със снимки';

  @override
  String get randomGoodDays => 'Добри дни';

  @override
  String get randomEmpty => 'Няма записи за избор';

  @override
  String get reviewWeekTitle => 'Тази седмица';

  @override
  String get reviewWeekSubtitle => 'Вашата седмица досега';

  @override
  String get reviewYearTitle => 'Тази година';

  @override
  String get reviewEmpty => 'Все още нищо не е написано';

  @override
  String get reviewEntries => 'Вписвания';

  @override
  String get reviewDaysWritten => 'Написани дни';

  @override
  String get reviewWords => 'Думи';

  @override
  String get reviewPhotos => 'Снимки';

  @override
  String get reviewLongestRun => 'Най-дълъг период от дни';

  @override
  String get reviewAverageMood => 'Средно настроение';

  @override
  String get reviewFavorites => 'Най често';

  @override
  String get reviewByMonth => 'По месеци';

  @override
  String get reviewHighlight => 'Маркирайте';

  @override
  String get yearInPixels => 'Година в пиксели';

  @override
  String get capsuleSeal => 'Запечатайте като капсула на времето';

  @override
  String get capsuleTitle => 'Капсула на времето';

  @override
  String capsuleOpensOn(Object date) {
    return 'Отваря се на $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Написано на $date';
  }

  @override
  String get capsuleOpenEarly => 'Отворете рано';

  @override
  String get capsuleOpenEarlyDescription =>
      'Капсулата се отваря сега и остава отворена.';

  @override
  String get capsuleOpened => 'Капсулата на времето е отворена';

  @override
  String get templateMorningName => 'Сутрешни страници';

  @override
  String get templateMorningDescription => 'Подредете деня за три минути';

  @override
  String get templateMorningText =>
      '## Три неща, които искам да направя добре днес\n1. \n2. \n3. \n\n## Нещо, което очаквам с нетърпение\n\n## Бележка към себе си\n';

  @override
  String get templateEveningName => 'Вечерен преглед';

  @override
  String get templateEveningDescription =>
      'Завършете деня с това, което мина добре';

  @override
  String get templateEveningText =>
      '## Три добри неща днес\n1. \n2. \n3. \n\n## Какво научих\n\n## Какво може да стане по-добре утре\n';

  @override
  String get routineMorning => 'добро утро';

  @override
  String get routineEvening => 'Вечерен преглед';

  @override
  String get settingsRoutinePrompts => 'Подсказки сутрин и вечер';

  @override
  String get settingsRoutinePromptsHint =>
      'Предложете сутрешния или вечерния шаблон в Истории';

  @override
  String get checkInTitle => 'Бързо настаняване';

  @override
  String get checkInSubtitle => 'Настроение в две докосвания';

  @override
  String get checkInMood => 'как се чувстваш';

  @override
  String get checkInActivity => 'какво правиш';

  @override
  String get checkInNote => 'Ред за това (по избор)';

  @override
  String get checkInSave => 'Запазване';

  @override
  String editorWordCount(int words, int characters) {
    return '$words думи · $characters знаци';
  }

  @override
  String get coachProgramEverydayTagline => 'Забелязвайте малките неща в деня.';

  @override
  String get coachProgramReflectTagline =>
      'Намалете темпото и се вслушайте в себе си.';

  @override
  String get coachDuration => 'Продължителност';

  @override
  String get coachInterval => 'Интервал';

  @override
  String get coachDifficulty => 'Трудност';

  @override
  String get coachIntervalDaily => 'Ежедневно';

  @override
  String get coachIntervalWeekly => 'Ежеседмично';

  @override
  String get coachDifficultyBeginner => 'Начинаещ';

  @override
  String get coachDifficultyIntermediate => 'Междинен';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дни',
      one: '$count ден',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count седмици',
      one: '$count седмица',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'Ден $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Седмица $n';
  }

  @override
  String get coachEnroll => 'Запишете се';

  @override
  String get coachEndProgram => 'Край на програмата';

  @override
  String get coachAuthor => 'Автор';

  @override
  String get coachAuthorBio => 'Подкани, написани за това приложение.';

  @override
  String get coachEnrolledTip =>
      'Готово! Вашите въпроси ще се показват в Stories.';

  @override
  String get coachGoToStories => 'Отидете на Истории';

  @override
  String get coachAnswerHint => 'Напишете своя отговор...';

  @override
  String get storyWrapUp => 'Това е всичко за днес.';

  @override
  String get storyTapToClose => 'Докоснете, за да затворите';

  @override
  String get coachAnswerDone => 'Готово';

  @override
  String get coachAnswered => 'Отговорено, докоснете за отваряне';

  @override
  String get coachAnsweredEarlier => 'Отговорено';

  @override
  String get locationLocating => 'Намиране...';

  @override
  String get locationPickPlace => 'Изберете място';

  @override
  String get locationPlacesHint => 'Адрес или име на мястото';

  @override
  String get locationCustom => 'Персонализирано място';

  @override
  String get locationCurrent => 'Текущо местоположение';

  @override
  String get locationSaved => 'Запазени места';

  @override
  String get locationSearchResults => 'Резултати от търсенето';

  @override
  String get locationNearby => 'Близки места';

  @override
  String get locationRename => 'Преименуване';

  @override
  String get locationSavePlace => 'Запазете място';

  @override
  String get locationUnsavePlace => 'Премахване от запазените места';

  @override
  String get shareAs => 'Споделете като...';

  @override
  String get shareAsImage => 'Изображение';

  @override
  String get shareAsZip => 'ZIP с оригиналната медия';

  @override
  String get shareAsPlainText => 'Обикновен текст';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Добре дошли в AID Diary';

  @override
  String get onboardWelcomeText =>
      'Започнете от тук или свържете това устройство към такова, което вече използвате.';

  @override
  String get onboardStart => 'Започнете да пишете';

  @override
  String get helpFaq => 'Често задавани въпроси';

  @override
  String get helpFaq1Q => 'Къде се съхранява моят дневник?';

  @override
  String get helpFaq1A =>
      'Вашият дневник се съхранява на това устройство. Достига до други устройства или хранилище само когато активирате синхронизирането, споделяте или експортирате. Синхронизирането е криптирано от край до край.';

  @override
  String get helpFaq2Q =>
      'Как да запазя копие или да преместя на ново устройство?';

  @override
  String get helpFaq2A =>
      'Свържете се със съществуващо устройство в Настройки → Данни и съхранение → Синхронизиране и потвърдете оторизацията на устройството, което има вашия дневник. И двете устройства остават използваеми. Можете също да създадете резервно копие и да го възстановите на друго устройство.';

  @override
  String get helpFaq3Q =>
      'Мога ли да въвеждам записи от други приложения за дневници?';

  @override
  String get helpFaq3A =>
      'Да: в Настройки → Данни и съхранение импортирайте експортирания от Daylio, Diarium, Diaro, DayBook, My Brain, OneShot и Pixels или експортиран JSON.';

  @override
  String get helpFaq4Q => 'Как работят треньорските програми?';

  @override
  String get helpFaq4A =>
      'Запишете се в програма на страницата Coach. Всеки ден или седмица нов въпрос чака в Stories; вашият отговор се запазва като запис.';

  @override
  String get helpFaq5Q => 'Ами ако забравя паролата си?';

  @override
  String get helpFaq5A =>
      'Паролата не може да бъде възстановена, така че запазете резервно копие на дневника си.';

  @override
  String get helpPrivacy => 'Поверителност';

  @override
  String get helpPrivacyText =>
      'Съдържанието на дневника и медиите остават на това устройство, освен ако не активирате шифровано синхронизиране или не ги споделите/експортирате. Картите, търсенето на място и времето използват конфигурираните услуги и изпращат местоположението или заявката за търсене, необходима за тази заявка, а не текст от дневника.';

  @override
  String get photoMetaTitle => 'Използване на детайлите на снимката?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Пребройте този запис за $date и задайте мястото му на $place, както е записано на снимката?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Бройте този запис за $date, когато е направена снимката?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Задайте мястото на този запис на $place, където е направена снимката?';
  }

  @override
  String get photoMetaApply => 'Използвайте ги';

  @override
  String get quickWriteTitle => 'Бързо писане';

  @override
  String get quickWriteText => 'Докоснете, за да започнете нов запис.';

  @override
  String get settingsQuickWriteTitle => 'Бързо писане в известията';

  @override
  String get settingsQuickWriteDescription =>
      'Запазете известие, което отваря нов запис.';

  @override
  String get settingsNudgesTitle => 'Побутни ме след тихо разтягане';

  @override
  String settingsNudgesDescription(int days) {
    return 'Нежно напомняне, когато не сте писали от $days дни.';
  }

  @override
  String get nudgeTitle => 'Мина известно време';

  @override
  String get nudgeMonday => 'Нова седмица: какво очаквате с нетърпение?';

  @override
  String get nudgeTuesday => 'Два реда са достатъчни. как си днес';

  @override
  String get nudgeWednesday =>
      'По средата на седмицата. Какво се открои досега?';

  @override
  String get nudgeThursday =>
      'Нещо дребно, което си струва да запазите от днес?';

  @override
  String get nudgeFriday =>
      'Седмицата приключва. Обърнете внимание на един добър момент.';

  @override
  String get nudgeSaturday => 'Бавната събота е добър ден за писане.';

  @override
  String get nudgeSunday =>
      'Погледнете назад към седмицата, преди да приключи.';

  @override
  String get photoWidgetEmpty =>
      'Снимките, които добавяте към записи, се показват тук.';

  @override
  String get channelReminders => 'Напомняния';

  @override
  String get channelOnThisDay => 'На този ден';

  @override
  String get channelCoach => 'Треньор подсказва';

  @override
  String get channelNudges => 'Подтиквания след спокойни дни';

  @override
  String get channelQuickWrite => 'Бързо писане';

  @override
  String get channelBackup => 'Архивиране';

  @override
  String get formatJsonExport => 'JSON (AID Diary износ)';

  @override
  String get aboutModifiedNotice =>
      'Модифицирана версия на Daily You от Demizo и сътрудници. Това не е официалното приложение Daily You.';

  @override
  String get toolbarPhotos => 'Добавете снимки';

  @override
  String get toolbarMedia => 'Снимки и видеоклипове';

  @override
  String get mediaFromGallery => 'Изберете от галерията';

  @override
  String get mediaFromFiles => 'Изберете от файлове';

  @override
  String get editorLeaveTitle => 'Запазване на този запис?';

  @override
  String get editorLeaveDiscard => 'Не спестявайте';

  @override
  String get editorTitleHint => 'Заглавие';

  @override
  String get editorLocating => 'Намиране...';

  @override
  String get toolbarVideo => 'видео';

  @override
  String get toolbarAudio => 'Гласова бележка';

  @override
  String get toolbarTags => 'Етикети';

  @override
  String get toolbarBulletList => 'Списък с водещи символи';

  @override
  String get toolbarHeading => 'Заглавие';

  @override
  String get toolbarBold => 'Удебелен';

  @override
  String get toolbarItalic => 'Курсив';

  @override
  String get toolbarHighlight => 'Маркирайте';

  @override
  String get toolbarStrikethrough => 'Зачертано';

  @override
  String get toolbarQuote => 'цитат';

  @override
  String get toolbarLink => 'Връзка';

  @override
  String get toolbarInsert => 'Поставете';

  @override
  String get toolbarUndo => 'Отмяна';

  @override
  String get toolbarRedo => 'Повторете';

  @override
  String get toolbarInsertDate => 'Въведете датата';

  @override
  String get toolbarInsertTime => 'Въведете часа';

  @override
  String get settingsSyncTitle => 'Облачно синхронизиране';

  @override
  String get syncOffDescription =>
      'Поддържайте този дневник еднакъв на всичките си устройства чрез Google Drive или WebDAV сървър, като Nextcloud, Synology или Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'Синхронизиране с Google Drive';

  @override
  String get syncOrWebDav => 'Или WebDAV сървър';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn =>
      'Влезли сте. Можете да се върнете към AID Diary.';

  @override
  String get syncGoogleSignInAgain => 'Google иска да влезете отново.';

  @override
  String get syncSignInAgain => 'Влезте отново';

  @override
  String get settingsCommandLineTitle => 'Команден ред';

  @override
  String get commandLineToggle => 'Интерфейс на командния ред';

  @override
  String get commandLineToggleHint =>
      'Позволява на командата за помощ и други програми на това устройство да използват командите на приложението.';

  @override
  String get commandLineAlwaysOn => 'Винаги в процес на разработка.';

  @override
  String commandLineListening(int port) {
    return 'Слушане на порт $port';
  }

  @override
  String get commandPaletteTitle => 'Всички команди';

  @override
  String get commandPaletteSearch => 'Команди за търсене';

  @override
  String get commandPaletteRun => 'Бягай';

  @override
  String get commandPaletteConfirm =>
      'Това не може просто да бъде отменено. Пусни го?';

  @override
  String syncReceiving(int done, int total) {
    return 'Получаване на $done от $total...';
  }

  @override
  String syncSending(int done, int total) {
    return 'Изпраща се $done от $total...';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'Достъпът до Google Drive не беше разрешен. Свържете се отново и маркирайте Google Drive на страницата на Google.';

  @override
  String get syncEntryUnsynced =>
      'Не е синхронизирано: последното синхронизиране не е преминало';

  @override
  String get syncUseOfficial => 'Използвайте сървъра за синхронизиране на AID';

  @override
  String get syncServer => 'Адрес на сървъра';

  @override
  String get syncUsername => 'Потребителско име';

  @override
  String get syncPassword => 'Парола';

  @override
  String get syncConnect => 'Свържете се';

  @override
  String get syncConnecting => 'Свързване...';

  @override
  String get syncSignInFailed =>
      'Не можах да вляза. Проверете адреса, потребителското име и паролата.';

  @override
  String syncConnectFailed(String error) {
    return 'Не може да се свърже: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Започнете синхронизирането';

  @override
  String get syncNewSpaceDescription =>
      'Тук все още няма синхронизиран дневник. Този дневник ще бъде качен, криптиран от край до край с ключ, който остава на вашите устройства.';

  @override
  String get syncJoinTitle => 'Присъединете се към синхронизирания дневник';

  @override
  String get syncWrongKey =>
      'Този код за възстановяване не отваря синхронизирания дневник.';

  @override
  String syncLastSynced(String time) {
    return 'Последно синхронизиран $time';
  }

  @override
  String get syncNever => 'Все още не е синхронизирано';

  @override
  String get syncSyncing => 'Синхронизиране...';

  @override
  String syncFailed(String error) {
    return 'Последното синхронизиране е неуспешно: $error';
  }

  @override
  String get syncLocked =>
      'Синхронизираният дневник вече принадлежи на други устройства или е започнат отначало. Сдвоете с един от тях или използвайте кода за възстановяване, за да продължите синхронизирането.';

  @override
  String get syncNow => 'Синхронизиране сега';

  @override
  String get syncUnlock => 'Отключи';

  @override
  String get syncEncrypted => 'Криптирано от край до край';

  @override
  String get syncDisconnect => 'Спрете синхронизирането';

  @override
  String get syncDisconnectDescription =>
      'Това устройство спира да се синхронизира. Дневникът тук и синхронизираното копие остават такива, каквито са.';

  @override
  String get syncOwnRecoveryPassword =>
      'Използвайте моята собствена парола за възстановяване';

  @override
  String get syncRecoveryPassword => 'Парола за възстановяване';

  @override
  String get syncRecoveryPasswordRepeat =>
      'Повторете паролата за възстановяване';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Използвайте поне $min знаци';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'Паролите се различават';

  @override
  String get syncRecoveryCode => 'Код за възстановяване';

  @override
  String get syncRecoveryCodeTitle => 'Запазете вашия код за възстановяване';

  @override
  String get syncRecoveryCodeDescription =>
      'Ако всяко ваше устройство бъде изгубено, този код възстановява вашия синхронизиран дневник. Съхранявайте го в мениджър на пароли или на хартия. Показва се само този път.';

  @override
  String get syncRecoveryCodeCopied => 'Кодът за възстановяване е копиран';

  @override
  String get syncRecoveryCodeSaved => 'Запазил съм го';

  @override
  String get syncJoinNeedsKey =>
      'Този синхронизиран дневник принадлежи на другите ви устройства. Сдвоете с един от тях или използвайте кода за възстановяване. Записите на това устройство ще бъдат добавени към него.';

  @override
  String get syncPairDevice => 'Сдвояване с устройство';

  @override
  String get syncUseRecoveryCode => 'Използвайте кода за възстановяване';

  @override
  String get syncAddDevice => 'Добавяне на устройство';

  @override
  String get syncChangeRecoveryCode => 'Променете кода за възстановяване';

  @override
  String get syncChangeRecoveryDescription =>
      'Нов код замества текущия, който спира да работи. Вашите данни и други устройства остават такива, каквито са.';

  @override
  String get syncNewRandomCode => 'Нов произволен код';

  @override
  String get syncRecoveryCodeChanged => 'Кодът за възстановяване е променен';

  @override
  String get syncResetSpace => 'Стартирайте синхронизирания дневник отначало';

  @override
  String get syncResetSpaceDescription =>
      'Само когато никое устройство и код за възстановяване не го отварят повече: синхронизираното копие се заменя от дневника на това устройство, под ключовете на това устройство. След това другите ви устройства се сдвояват отново.';

  @override
  String get syncPairTitle => 'Сдвояване на устройства';

  @override
  String get syncPairShow => 'Покажете код';

  @override
  String get syncPairEnter => 'Въведете код';

  @override
  String get syncPairShowHint =>
      'На другото си устройство отворете Сдвояване на устройства, изберете Въведете код и въведете или сканирайте това.';

  @override
  String get syncPairEnterHint =>
      'Въведете кода, който другото ви устройство показва, или го сканирайте.';

  @override
  String get syncPairCode => 'Код за сдвояване';

  @override
  String get syncPairScan => 'Сканиране';

  @override
  String get syncPairStart => 'чифт';

  @override
  String get syncPairWaiting => 'Изчаква се другото устройство...';

  @override
  String syncPairDone(String device) {
    return 'В комбинация с $device';
  }

  @override
  String get syncPairWrongCode =>
      'Кодът не съвпадна. Покажете нов код и опитайте отново.';

  @override
  String get syncPairNoOffer =>
      'Нито едно устройство не показва този код. Може да е изтекъл.';

  @override
  String get syncPairTimedOut => 'Другото устройство не отговори навреме.';

  @override
  String get syncPairNeither =>
      'Нито едно устройство все още не е настроено с този синхронизиран дневник.';

  @override
  String get syncPairBoth =>
      'И двете устройства вече отварят този синхронизиран дневник.';

  @override
  String syncPairFailed(String error) {
    return 'Неуспешно сдвояване: $error';
  }

  @override
  String get syncMediaPending =>
      'Дневникът е синхронизиран · някои медии все още се прехвърлят';

  @override
  String get syncWaitingForDevices =>
      'Дневникът е синхронизиран · чака друго устройство да прехвърли мултимедия';

  @override
  String get syncCacheNotice =>
      'Облачните медии са временни. Съхранявайте оригиналите на вашите устройства; синхронизирането не е резервно копие.';

  @override
  String get paperTitle => 'Хартия за писма';

  @override
  String get paperPlain => 'Обикновен';

  @override
  String get paperLined => 'Подплатени';

  @override
  String get paperGrid => 'Решетка';

  @override
  String get paperTinted => 'Тонирани';

  @override
  String get paperDecorationTitle => 'Декорации';

  @override
  String get paperDecorationNone => 'Няма';

  @override
  String get paperDecorationBotanical => 'листа';

  @override
  String get paperDecorationStars => 'Звезди';

  @override
  String get paperDecorationWashi => 'Уаши лента';

  @override
  String get themeDarkChoice => 'Тъмен външен вид';

  @override
  String get themeDarkSame => 'Следвайте светлата палитра';

  @override
  String get themeDarkCustom => 'Отделна палитра';

  @override
  String get themeDarkAccent => 'Цвят на тъмен акцент';

  @override
  String get themeColorTeal => 'Тил';

  @override
  String get themeColorCyan => 'циан';

  @override
  String get themeColorIndigo => 'Индиго';

  @override
  String get themeColorCoral => 'Корал';

  @override
  String get themeColorOlive => 'Маслина';

  @override
  String get themeColorSlate => 'шисти';

  @override
  String get drawingTitle => 'рисуване';

  @override
  String get drawingPen => 'Писалка';

  @override
  String get drawingEraser => 'Гумичка';

  @override
  String get drawingUndo => 'Отмяна';

  @override
  String get drawingClear => 'ясно';

  @override
  String get drawingWidth => 'Ширина на писалката';

  @override
  String get drawingStylusOnly => 'Само стилус';

  @override
  String get drawingDiscardTitle => 'Да се отхвърли ли рисунката?';

  @override
  String get drawingDiscardBody => 'Този чертеж не е запазен.';

  @override
  String get drawingSaveError => 'Чертежът не можа да бъде запазен.';

  @override
  String get syncNetworkTitle => 'Мрежова диагностика';

  @override
  String get syncNetworkRefresh => 'Опресняване';

  @override
  String get syncNetworkSelectedRoute => 'Текущ път';

  @override
  String get syncNetworkAvailableRoutes => 'Налични пътеки';

  @override
  String get syncNetworkSignaling => 'Връзка с директорията на устройството';

  @override
  String get syncNetworkRelayRemaining => 'Остатъчна надбавка за реле';

  @override
  String get syncNetworkIcePair => 'Кандидати за директна връзка';

  @override
  String get syncNetworkPeerTrusted => 'Удостоверено устройство';

  @override
  String get syncNetworkNoRoute => 'В очакване на връзка';

  @override
  String get syncNetworkUnavailable => 'Диагностиката е недостъпна';

  @override
  String get syncMediaCopiesTitle => 'Доставка на медии и копия';

  @override
  String get syncMediaPendingCount => 'Изчакване за прехвърляне';

  @override
  String get syncMediaDurableCount => 'Доставено на личен склад';

  @override
  String get syncMediaTemporaryCount => 'Временни или непотвърдени копия';

  @override
  String get syncMediaReceiptExplanation =>
      'Тези преброявания описват завършени доставки, а не нов одит на оцелели резервни копия.';

  @override
  String get syncMediaCacheExplanation =>
      'Временната облачна медия може да изтече. Запазете вашите оригинали или отделно резервно копие.';

  @override
  String get momentsTitle => 'Фото моменти';

  @override
  String get momentsHint =>
      'Намерете групи, като използвате местни времена за снимки и незадължителни координати. Снимките се прикачват само при избор на карта.';

  @override
  String get momentsScan => 'Намерете моменти';

  @override
  String get momentsChooseFolder => 'Изберете папка със снимки';

  @override
  String get momentsLocation => 'Включете местоположенията на снимките';

  @override
  String get momentsEmpty => 'Няма скорошни групи снимки.';

  @override
  String get momentsCreate => 'Пишете за тези снимки';

  @override
  String get momentsDismiss => 'Отхвърляне';

  @override
  String get momentsError => 'Не можах да прочета местни снимки.';

  @override
  String get momentsCreated => 'Записът със снимка е създаден.';

  @override
  String get momentsPermission =>
      'Разрешете достъп до снимки, за да намерите местни предложения.';

  @override
  String get momentsScope =>
      'Само скорошни снимки; най-много 500 снимки и 20 снимки на карта.';

  @override
  String momentsPhotoCount(int count) {
    return '$count снимки';
  }

  @override
  String get nearbyTitle => 'Свързване на устройства';

  @override
  String get nearbySend => 'Упълномощаване на друго устройство';

  @override
  String get nearbyReceive => 'Свържете се със съществуващо устройство';

  @override
  String get nearbyInstructions =>
      'Свържете двете устройства към един и същ Wi-Fi или към гореща точка на другото. Потвърдете оторизацията на съществуващото устройство; и двете устройства остават използваеми. Не е необходим интернет.';

  @override
  String get nearbyCompare =>
      'Сравнете този код на двете устройства, преди да одобрите.';

  @override
  String get nearbyConfirm => 'Кодовете съвпадат';

  @override
  String get nearbyScan => 'Сканирайте кода на другото устройство';

  @override
  String get nearbyPaste => 'Поставете покана';

  @override
  String get nearbyWaiting => 'Изчаква се одобрение на другото устройство';

  @override
  String get nearbyWorking =>
      'Упълномощаване и синхронизиране на вашия дневник и прикачени файлове...';

  @override
  String get nearbyPending =>
      'Някои прикачени файлове все още се нуждаят от синхронизиране. Дръжте другото устройство онлайн и опитайте отново.';

  @override
  String get nearbyComplete =>
      'Устройството е свързано; синхронизирани дневник и прикачени файлове';

  @override
  String get nearbyFailed =>
      'Връзката не завърши. Проверете локалната връзка и опитайте отново.';

  @override
  String get nearbyEmptyRequired =>
      'Използвайте устройство с празен дневник, което все още не е свързано за синхронизиране.';

  @override
  String get nearbyRetry => 'Продължаване на синхронизирането';

  @override
  String get nearbyWifi => 'Настройки на Wi-Fi';

  @override
  String get nearbyHotspot => 'Настройки на гореща точка';

  @override
  String get nearbyKeepOpen =>
      'Дръжте тази страница отворена, докато новото устройство приключи. Поканата изтича след две минути.';

  @override
  String get syncDevicesTitle => 'Оторизирани устройства';

  @override
  String get syncDevicesDescription =>
      'Само одобрени устройства имат достъп до този AID акаунт. Отмяната на устройство блокира сървъра, но не може да изтрие главен ключ или дневник, които вече са копирани в него.';

  @override
  String get syncDeviceRequest =>
      'Покажете този QR за оторизация на одобрено устройство';

  @override
  String get syncDeviceAuthorize => 'Упълномощаване на устройство';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Сканирайте или поставете заявката за оторизация на новото устройство.';

  @override
  String get syncDeviceRevoke => 'Отмени';

  @override
  String get syncDeviceRotate =>
      'Завъртете ключа за подписване на това устройство';

  @override
  String get syncDeviceCheck => 'Проверете разрешението';

  @override
  String get syncDeviceHardware => 'Хардуерен ключ за подписване';

  @override
  String get syncDeviceSoftware =>
      'Ключ за подписване на софтуер, който не може да се експортира';

  @override
  String get syncDeviceUnavailable =>
      'Упълномощаването на устройството не е налично. Одобрете това устройство от друго оторизирано устройство и опитайте отново.';

  @override
  String get syncDeviceRevoked => 'Отменено';

  @override
  String get syncDeviceLocal => 'Това устройство';

  @override
  String get cloudTrafficTitle =>
      'Месечна квота за трансфер на данни в облак за медийни файлове';

  @override
  String get cloudTrafficLimit => 'Месечна квота за пренос на данни';

  @override
  String get cloudTrafficUsed => 'Използван трансфер на данни';

  @override
  String get cloudTrafficRemaining => 'Остава трансфер на данни';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'Квотата за трансфер на данни нулира $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'Квотата за пренос на данни в облак за медийни файлове е изчерпана. Липсващите медийни файлове ще се синхронизират автоматично, когато е налична директна връзка или квотата се нулира.';

  @override
  String get cloudTrafficExplanation =>
      'Кеширането на медийни файлове и предаването на живо споделят тази квота за пренос на данни. Директните връзки не го консумират. Текстът на дневника и съобщенията за контрол на връзката имат отделни малки дневни лимити.';

  @override
  String get appearanceThemeSection => 'Тема на приложението';

  @override
  String get appearancePaperSection => 'Дневникова хартия';

  @override
  String get appearanceTypographySection => 'Текст на дневника';

  @override
  String get appearancePreferencesSection => 'Общи предпочитания';

  @override
  String get themeSystemAccentHint =>
      'Използва системната палитра вместо персонализирани цветове. Изключете го, за да изберете свой собствен.';

  @override
  String get syncDeviceNameSaveFailed =>
      'Името на устройството не можа да бъде запазено. Моля, опитайте отново.';

  @override
  String get nearbyConnectionHelp => 'Помощ за свързване';

  @override
  String get syncAllSynced => 'Всичко синхронизирано';

  @override
  String get syncDetailsTitle => 'Подробности за синхронизиране';

  @override
  String get syncMore => 'Още опции';

  @override
  String get syncDeviceName => 'Име на устройството';

  @override
  String get syncDeviceNameHint => 'Например: Моят таблет';

  @override
  String get syncDeviceNameInvalid => 'Използвайте от 1 до 32 знака';

  @override
  String get syncDeviceKeyDetails => 'Подробности за сигурността';

  @override
  String get syncConnectionProblem =>
      'Засега не може да се синхронизира. Опитва се автоматично.';

  @override
  String get syncCopyComplete =>
      'Пълно копие на вашия дневник и медийни файлове';

  @override
  String get syncCopyPartial => 'Някои медии все още липсват';

  @override
  String get syncCopyOlder => 'Новите промени чакат синхронизиране';

  @override
  String get syncCopyUnavailable =>
      'Подробностите за копието не са налични. Опитайте отново по-късно.';

  @override
  String get syncCopyLastKnown =>
      'Други устройства показват последното си потвърдено копие. Офлайн устройствата не могат да бъдат проверени сега.';

  @override
  String get syncCopyTemporary =>
      'Временен кеш. Запазете оригиналите на вашите устройства.';

  @override
  String get syncCopyStorage =>
      'Вашето хранилище за синхронизиране. Завършените качвания на мултимедия са изброени в диагностиката.';

  @override
  String syncCopyChecked(String time) {
    return 'Последно потвърдено $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Оставащи трансфери на данни този месец: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Започнете тук';

  @override
  String get onboardConnect => 'Свържете се със съществуващо устройство';

  @override
  String get onboardFailed =>
      'Настройката не можа да бъде завършена. Вашият дневник е в безопасност; моля опитайте отново.';

  @override
  String get tutorialTitle => 'Как да използвате дневника';

  @override
  String get tutorialWriteTitle => 'Напишете първия си запис в дневника';

  @override
  String get tutorialWriteText =>
      'Докоснете +, за да напишете запис в дневника. Добавете незадължително заглавие, изберете датата на дневника и докоснете отметката, за да запазите. Можете да редактирате отново своя запис в дневника по всяко време.';

  @override
  String get tutorialMediaTitle => 'Добавете снимки, аудио или ръкопис';

  @override
  String get tutorialMediaText =>
      'Използвайте + в редактора на дневника, за да прикачите снимки, видеоклипове или гласов запис, или за да отворите платното за ръкопис. Тези прикачени файлове се запазват с записа в дневника.';

  @override
  String get tutorialReviewTitle => 'Намерете ден отново';

  @override
  String get tutorialReviewText =>
      'Разглеждайте своя дневник или календар, търсете във вашите записи и организирайте записи с тагове. Страниците Media и Atlas ви позволяват да намерите минали записи по снимка или местоположение.';

  @override
  String get tutorialSyncTitle => 'Използвайте повече от едно устройство';

  @override
  String get tutorialSyncText =>
      'В Настройки → Данни и съхранение → Синхронизиране, свържете се със съществуващо устройство и потвърдете оторизацията на това устройство. И двете устройства могат да продължат да използват дневника. Текстът на дневника се синхронизира първо. Медийните файлове се синхронизират след това, когато мрежовата връзка и оставащата квота за пренос на данни го позволяват.';

  @override
  String get tutorialPrivacyTitle => 'Пазете дневника си на сигурно място';

  @override
  String get tutorialPrivacyText =>
      'Записите в дневника остават на това устройство, освен ако не активирате синхронизирането или ги споделите или експортирате. Синхронизирането е криптирано от край до край. В Настройки можете също да зададете парола за приложение, да създадете резервни копия и да отворите отново този урок.';

  @override
  String get editorDiaryDay => 'Ден на дневника';

  @override
  String get editorDiaryDayPicker =>
      'Ден на дневника · За кой ден е този запис?';

  @override
  String editorCreatedAt(String time) {
    return 'Създадено $time';
  }

  @override
  String get editorDiaryDayHint =>
      'Денят, към който принадлежи този запис. Промяната му не променя времето на създаване.';

  @override
  String get hiddenDiaryTitle => 'Скрити записи';

  @override
  String get hiddenDiaryHide => 'Скриване на запис';

  @override
  String get hiddenDiaryShow => 'Показване на запис';

  @override
  String get hiddenDiaryEmpty => 'Няма скрити записи';

  @override
  String get hiddenDiaryUnlock => 'Отключване на скритите записи';

  @override
  String get hiddenDiaryAuthHint =>
      'Използвайте заключването на приложението или на екрана на устройството.';

  @override
  String hiddenDiaryWhere(String path) {
    return 'Скрито. За да го покажете отново: $path';
  }

  @override
  String get noteKeep => 'Запази';

  @override
  String get noteComment => 'Коментирай';

  @override
  String get noteCommentHint => 'Пиши на миналото си аз';

  @override
  String get noteKept => 'Откъсът е запазен';

  @override
  String get notesPassages => 'Запазени откъси';

  @override
  String get notesComments => 'Коментари';

  @override
  String get noteDeleteConfirm => 'Да се изтрие ли тази бележка?';

  @override
  String get editPastTitle => 'Да се редактира ли минал спомен?';

  @override
  String get editPastBody =>
      'Този запис е от по-ранен ден. За да му отговорите, маркирайте текст, за да го запазите или коментирате.';

  @override
  String get editPastDontAsk => 'Не питай отново';

  @override
  String get editPastEdit => 'Редактирай въпреки това';

  @override
  String noteOnEntry(String date) {
    return 'За записа от $date';
  }

  @override
  String get settingsConfirmEditPast =>
      'Питай преди редактиране на минали записи';

  @override
  String get settingsCompressPhotos => 'Компресиране на новите снимки';

  @override
  String get settingsCompressPhotosHint =>
      'Новите снимки се пазят като WebP от около 1 MB. Изключено пази оригиналите.';

  @override
  String get compressExistingTitle => 'Компресиране на наличните снимки';

  @override
  String compressExistingBody(int count, String size) {
    return '$count снимки заемат $size. Тези над около 1 MB стават WebP от около 1 MB. Това ги заменя и не може да се отмени; пазете оригиналите другаде, ако ви трябват.';
  }

  @override
  String get compressExistingAction => 'Компресирай';

  @override
  String compressExistingDone(int count, String size) {
    return 'Компресирани $count снимки, спестени $size';
  }

  @override
  String get commentExpand => 'Разгъни';

  @override
  String get refAdd => 'Цитирай запис';

  @override
  String get refMissing => 'Този запис вече го няма';

  @override
  String get moodClear => 'Изчистване на настроението';

  @override
  String get scrollToTop => 'Най-горе';

  @override
  String get feedbackTitle => 'Обратна връзка';

  @override
  String get feedbackHint => 'Опишете проблем или предложение';

  @override
  String get feedbackSend => 'Изпращане';

  @override
  String get feedbackSent => 'Благодарим, отзивът ви е изпратен.';

  @override
  String get feedbackSendFailed =>
      'Изпращането не бе успешно. Проверете връзката и опитайте отново.';

  @override
  String get feedbackOpenFailed => 'Приложението не можа да се отвори.';

  @override
  String get feedbackSendNote =>
      'Изпраща се до сървъра на AID Diary с версията и езика на приложението, без нищо от дневника ви.';

  @override
  String get feedbackGithub => 'Проблем в GitHub';

  @override
  String get feedbackEmail => 'Изпрати имейл';

  @override
  String updateAvailable(String version) {
    return 'Налична е AID Diary $version';
  }

  @override
  String get updateClosesNote =>
      'Приложението се затваря, за да инсталира актуализацията; отворете го отново след това.';

  @override
  String get updateLater => 'По-късно';

  @override
  String get updateSkip => 'Пропускане на тази версия';

  @override
  String get updateInstall => 'Актуализиране';

  @override
  String updateDownloading(int percent) {
    return 'Изтегляне… $percent%';
  }

  @override
  String get updateAllowInstall =>
      'Разрешете на AID Diary да инсталира приложения в отворените настройки и докоснете отново „Актуализиране“.';

  @override
  String updateFailed(String reason) {
    return 'Актуализацията не можа да се инсталира: $reason';
  }

  @override
  String updatedTo(String version) {
    return 'Актуализирано до $version';
  }

  @override
  String get updateWhatsNew => 'Какво ново';

  @override
  String get updateCheckNow => 'Проверка за актуализации';

  @override
  String get updateNewest => 'Това е най-новата версия.';

  @override
  String get updateAutoCheck => 'Автоматична проверка за актуализации';

  @override
  String get updateSilent => 'Инсталиране на актуализации без питане';

  @override
  String get updateSilentHint =>
      'Изтегля във фонов режим и инсталира, когато излезете от приложението. Android пита веднъж, първия път.';
}
