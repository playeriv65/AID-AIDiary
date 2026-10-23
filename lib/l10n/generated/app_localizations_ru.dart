// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => 'Цвет темы';

  @override
  String get themeColorHint => 'Выберите цвет для этой палитры.';

  @override
  String get themeColorBlue => 'Небесно-голубой';

  @override
  String get themeColorGreen => 'Лесной зеленый';

  @override
  String get themeColorBrown => 'Теплый кофе';

  @override
  String get themeColorPurple => 'Лаванда';

  @override
  String get themeColorRose => 'Пыльная роза';

  @override
  String get themeColorAmber => 'Янтарь';

  @override
  String get themeColorPreview => 'Немного каждый день';

  @override
  String get themeTintBackgroundTitle => 'Оттенок фона цветом темы';

  @override
  String get themeTintBackgroundHint =>
      'Выключите нейтральный серый фон; кнопки сохраняют выбранный вами цвет.';

  @override
  String get dailyReminderTitle => 'Напиши про день!';

  @override
  String get dailyReminderDescription => 'Заполни свой дневник сегодня…';

  @override
  String get actionTakePhoto => 'Сделать фото';

  @override
  String get flashbacksTitle => 'Воспоминания';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Не учитывать плохие дни';

  @override
  String get flashbackGoodDay => 'Хороший день';

  @override
  String get flashbackRandomDay => 'Случайный день';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Недель назад',
      few: '$count Недели назад',
      one: '$count Неделя назад',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Месяцев назад',
      few: '$count Месяца назад',
      one: '$count Месяц назад',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Лет назад',
      few: '$count Года назад',
      one: '$count Год назад',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'В этот день';

  @override
  String get searchLogsHint => 'Искать записи…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count записей',
      few: '$count записи',
      one: '$count запись',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дней',
      one: '$count день',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count слов',
      many: '$count слов',
      few: '$count слова',
      one: '$count слово',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Нет записей…';

  @override
  String get noResults => 'Нет результатов…';

  @override
  String get sortOrderAscendingTitle => 'В порядке возрастания';

  @override
  String get sortOrderDescendingTitle => 'Убывание';

  @override
  String get pageStatisticsTitle => 'Статистика';

  @override
  String get statisticsNotEnoughData => 'Недостаточно данных…';

  @override
  String get statisticsRangeOneMonth => '1 Месяц';

  @override
  String get statisticsRangeSixMonths => '6 Месяцев';

  @override
  String get statisticsRangeOneYear => '1 Год';

  @override
  String get statisticsRangeAllTime => 'Все время';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag Сводка';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag По дням';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag со временем';
  }

  @override
  String get chartGroupingLabel => 'Сгруппировать по';

  @override
  String get chartGroupingDay => 'День';

  @override
  String get chartGroupingWeek => 'Неделя';

  @override
  String get chartGroupingMonth => 'Месяц';

  @override
  String get chartGroupingYear => 'Год';

  @override
  String get chartSmoothingLabel => 'Сглаживание';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Дней подряд $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Макс. дней подряд $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Великие дни $count',
      one: 'Великие дни $count',
      many: 'Великие дни $count',
      few: 'Великие дни $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Дни с последнего Плохого Дня $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Нет доступа к внешнему хранилищу';

  @override
  String get errorExternalStorageAccessDescription =>
      'Если вы используете сетевое хранилище, убедитесь, что оно работает и у вас есть доступ к Интернету.\n\nВ противном случае, приложение могло потерять разрешение для доступа к внешней папке. Откройте настройки и выберите внешнюю папку снова, чтобы предоставить доступ.\n\nВнимание, изменения не будут синхронизироваться, пока доступ к внешнему хранилищу не будет восстановлен!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Продолжить с локальным хранением данных';

  @override
  String get lastModified => 'Изменено';

  @override
  String get writeSomethingHint => 'Напишите что-нибудь…';

  @override
  String get titleHint => 'Название…';

  @override
  String get deleteLogTitle => 'Удалить запись';

  @override
  String get deleteLogDescription => 'Вы хотите удалить эту запись?';

  @override
  String get deletePhotoTitle => 'Удалить фото';

  @override
  String get deletePhotoDescription => 'Вы хотите удалить это фото?';

  @override
  String get pageSettingsTitle => 'Настройки';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get themeSystem => 'Система';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Темная';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Первый день недели';

  @override
  String get settingsCalendarSystem => 'Тип календаря';

  @override
  String get calendarSystemGregorian => 'Григорианский календарь';

  @override
  String get calendarSystemJalali => 'Джалали';

  @override
  String get settingsUseSystemAccentColor =>
      'Использовать акцентный цвет как в системе';

  @override
  String get settingsCustomAccentColor => 'Пользовательский акцентный цвет';

  @override
  String get settingsShowFlashbacks => 'Показать воспоминания';

  @override
  String get settingsChangeMoodIcons => 'Изменить значки настроения';

  @override
  String get moodIconPrompt => 'Введите значок (емодзи)';

  @override
  String get settingsHideImages => 'Скрыть изображения';

  @override
  String get pageCalendarTitle => 'Календарь';

  @override
  String get settingsNotificationsTitle => 'Уведомления';

  @override
  String get settingsDailyReminderTitle => 'Ежедневное напоминание';

  @override
  String get settingsOnThisDayDescription =>
      'Вернитесь к прошлым воспоминаниям';

  @override
  String get settingsDailyReminderDescription =>
      'Удобное пуш-уведомление на каждый день';

  @override
  String get settingsReminderTime => 'Время напоминания';

  @override
  String get settingsFixedReminderTimeTitle =>
      'Фиксированное время напоминания';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Выберите фиксированное время напоминания';

  @override
  String get settingsAlwaysSendReminderTitle => 'Всегда напоминать';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Напоминать, даже если запись уже начата';

  @override
  String get settingsCustomizeNotificationTitle => 'Настроить уведомления';

  @override
  String get settingsTemplatesTitle => 'Шаблоны';

  @override
  String get manageTemplates => 'Управление шаблонами';

  @override
  String get noTemplateTitle => 'Нет';

  @override
  String get noTemplatesDescription => 'Нет созданных шаблонов…';

  @override
  String get templateDefaultTimestampTitle => 'Временная метка';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Итог дня';

  @override
  String get templateDefaultSummaryBody => '### Итог\n- \n\n### Цитата\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Рефлексия';

  @override
  String get templateDefaultReflectionBody =>
      '### Что тебе понравилось сегодня?\n- \n\n### За что ты благодарен?\n- \n\n### Чего вы ждете?\n- ';

  @override
  String get settingsTagsTitle => 'Теги';

  @override
  String get manageTags => 'Управлять тегами';

  @override
  String get tagTypeLabelTitle => 'Этикетка';

  @override
  String get tagTypeTrackerTitle => 'Трекер';

  @override
  String get nameHint => 'Имя';

  @override
  String get tagColorLabel => 'Цвет';

  @override
  String get iconPickerTitle => 'Выберите значок';

  @override
  String get iconPickerIconsTab => 'Иконки';

  @override
  String get iconPickerCustomTab => 'Пользовательский';

  @override
  String get iconPickerSearchHint => 'Значки поиска…';

  @override
  String get colorPickerTitle => 'Выберите цвет';

  @override
  String get colorPickerPaletteTab => 'Цвета';

  @override
  String get iconGroupMoodPeople => 'Настроение и люди';

  @override
  String get iconGroupHealth => 'Здоровье';

  @override
  String get iconGroupWorkFinance => 'Работа и финансы';

  @override
  String get iconGroupHabitsGoals => 'Привычки и цели';

  @override
  String get iconGroupNature => 'Природа';

  @override
  String get iconGroupFoodDrink => 'Еда и напитки';

  @override
  String get iconGroupHome => 'Главная';

  @override
  String get iconGroupTravel => 'Путешествия';

  @override
  String get iconGroupSymbols => 'Символы';

  @override
  String get tagCategoryLabel => 'Категория';

  @override
  String get tagLabel => 'Тег';

  @override
  String get tagCategoryUncategorized => 'Без категории';

  @override
  String get newCategoryTitle => 'Новая категория';

  @override
  String get shareButtonLabel => 'Поделиться';

  @override
  String get importErrorDescription => 'Не удалось импортировать файл!';

  @override
  String get exportErrorDescription => 'Не удалось экспортировать файл!';

  @override
  String get deleteTitle => 'Удалить';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Используется в дневниковых записях $count.',
      one: ' Используется в $count дневниковой записи.',
      many: ' Используется в $count записях дневника.',
      few: ' Используется в $count дневниковых записях.',
      zero: '',
    );
    return 'Удалить \"$name\"?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Его теги $count также будут удалены.',
      one: ' Его $count тег также будет удален.',
      many: ' Его $count тегов также будут удалены.',
      few: ' Также будут удалены $count его тега.',
      zero: '',
    );
    return 'Удалить \"$name\"?$_temp0';
  }

  @override
  String get tagNameExists => 'Тег с таким названием уже существует';

  @override
  String get categoryNameExists => 'Категория с таким названием уже существует';

  @override
  String deleteTemplateMessage(Object name) {
    return 'Удалить \"$name\"?';
  }

  @override
  String get addTagsTitle => 'Добавить теги';

  @override
  String get addTagsSearchHint => 'Поиск по тегам…';

  @override
  String get tagPickerSortManualLabel => 'Ручной заказ';

  @override
  String get tagPickerSortUsageLabel => 'Сортировать по использованию';

  @override
  String get tagFavoriteName => 'Любимый';

  @override
  String get tagEnergyName => 'Энергия';

  @override
  String get tagCategoryActivitiesName => 'Мероприятия';

  @override
  String get tagExerciseName => 'Упражнение';

  @override
  String get tagSocializingName => 'общение';

  @override
  String get tagHobbyName => 'Хобби';

  @override
  String get tagEntertainmentName => 'Развлечения';

  @override
  String get tagDiningName => 'Столовая';

  @override
  String get tagChoresName => 'Домашние дела';

  @override
  String get tagCategoryEmotionsName => 'Эмоции';

  @override
  String get tagExcitedName => 'взволнованный';

  @override
  String get tagGratefulName => 'Благодарный';

  @override
  String get tagCalmName => 'Спокойствие';

  @override
  String get tagTiredName => 'Усталый';

  @override
  String get tagAnxiousName => 'тревожный';

  @override
  String get tagAnnoyedName => 'Раздраженный';

  @override
  String get settingsStorageTitle => 'Хранилище';

  @override
  String get settingsImageQuality => 'Качество изображения';

  @override
  String get imageQualityHigh => 'Высокое';

  @override
  String get imageQualityMedium => 'Среднее';

  @override
  String get imageQualityLow => 'Низкое';

  @override
  String get imageQualityNoCompression => 'Без сжатия';

  @override
  String get settingsLogFolder => 'Папка для записей';

  @override
  String get settingsImageFolder => 'Папка для картинок';

  @override
  String get warningTitle => 'Внимание';

  @override
  String get logFolderWarningDescription =>
      'Если выбранная папка уже содержит файл \'aid_diary.db\', существующие записи будут перезаписаны!';

  @override
  String get errorTitle => 'Ошибка';

  @override
  String get logFolderErrorDescription =>
      'Не удалось поменять папку для записей!';

  @override
  String get imageFolderErrorDescription =>
      'Не удалось поменять папку для картинок!';

  @override
  String get backupErrorDescription => 'Не удалось создать резервную копию!';

  @override
  String get restoreErrorDescription =>
      'Не удалось восстановить резервную копию!';

  @override
  String get settingsBackupRestoreTitle => 'Резервная копия и востановление';

  @override
  String get settingsBackup => 'Резервная копия';

  @override
  String get settingsRestore => 'Восстановить';

  @override
  String get settingsRestorePromptDescription =>
      'Откат к резервной копии перезапишет существующие данные!';

  @override
  String get settingsBackupPasswordProtect => 'Защита резервных копий паролем';

  @override
  String get backupEncryptedTitle => 'Зашифрованное резервное копирование';

  @override
  String get backupEncryptedContent => 'Эта резервная копия защищена паролем.';

  @override
  String get settingsAutoBackup => 'Автоматическое резервное копирование';

  @override
  String get settingsAutoBackupLocation => 'Место резервного копирования';

  @override
  String get settingsAutoBackupInterval => 'Интервал резервного копирования';

  @override
  String get settingsAutoBackupIntervalDaily => 'Ежедневно';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Еженедельно';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Ежемесячно';

  @override
  String get settingsAutoBackupMaxCount =>
      'Резервные копии, которые нужно сохранить';

  @override
  String get settingsAutoBackupRequireCharging => 'Только во время зарядки';

  @override
  String settingsBackupLast(Object time) {
    return 'Последняя резервная копия $time';
  }

  @override
  String get settingsBackupNever => 'Никогда не создавал резервные копии';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Следующая резервная копия $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'Все';

  @override
  String get autoBackupFailedTitle => 'Резервное копирование не выполнено';

  @override
  String tranferStatus(Object percent) {
    return 'Перемещение... $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Создание резервной копии...$percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Откат из резервной копии... $percent%';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return 'Шифрование резервной копии… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Расшифровка резервной копии… $percent%';
  }

  @override
  String get cleanUpStatus => 'Прибираемся…';

  @override
  String get settingsExportToAnotherFormat => 'Сохранить в другом формате';

  @override
  String get settingsExportFormatDescription =>
      'Не используйте это как резервную копию!';

  @override
  String get settingsImportFromAnotherApp => 'Импорт из другого приложения';

  @override
  String get logFormatTitle => 'Выбрать формат';

  @override
  String get logFormatDescription =>
      'Формат другого приложения может не поддерживать все функции. Пожалуйста, сообщайте о любых проблемах, так как сторонние форматы могут изменяться в любое время. Это не повлияет на существующие записи!';

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
  String get settingsDeleteAllLogsTitle => 'Удалить все записи';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Вы уверены, что хотите удалить все свои записи?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Введите \'$prompt\', чтобы подтвердить. Это действие безвозвратно!';
  }

  @override
  String get settingsLanguageTitle => 'Язык';

  @override
  String get settingsAppLanguageTitle => 'Язык приложения';

  @override
  String get settingsOverrideAppLanguageTitle => 'Заменить язык приложения';

  @override
  String get settingsSecurityTitle => 'Безопасность';

  @override
  String get settingsSecurityRequirePassword => 'Требовать пароль';

  @override
  String get settingsSecurityEnterPassword => 'Введите пароль';

  @override
  String get settingsSecuritySetPassword => 'Установить пароль';

  @override
  String get settingsSecurityChangePassword => 'Сменить пароль';

  @override
  String get settingsSecurityPassword => 'Пароль';

  @override
  String get settingsSecurityConfirmPassword => 'Подтверждение пароля';

  @override
  String get settingsSecurityOldPassword => 'Старый пароль';

  @override
  String get settingsSecurityIncorrectPassword => 'Неверный пароль';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get requiredPrompt => 'При входе требуется пароль';

  @override
  String get settingsSecurityBiometricUnlock => 'Отпечаток пальца';

  @override
  String get unlockAppPrompt => 'Разблокировка дневника';

  @override
  String get settingsAboutTitle => 'О программе';

  @override
  String get settingsVersion => 'Версия';

  @override
  String get settingsLicense => 'Лицензия';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsOpenSourceLicenses => 'Лицензии с открытым исходным кодом';

  @override
  String get tagMoodTitle => 'Настроение';

  @override
  String get selectTagTitle => 'Выберите тег';

  @override
  String get labelPresentLabel => 'Настоящее время';

  @override
  String get labelAbsentLabel => 'Отсутствует';

  @override
  String get labelCoverageLabel => 'Покрытие';

  @override
  String chartDistributionTitle(Object tag) {
    return '$tag Распространение';
  }

  @override
  String get shareAddToLogPickerTitle => 'Выберите запись в дневнике';

  @override
  String get adaptiveEmptyDay => 'Записей на этот день пока нет';

  @override
  String get adaptiveNewEntry => 'Написать запись';

  @override
  String get pageJournalTitle => 'Журнал';

  @override
  String get coachPrompt1 => 'Что заставило тебя улыбнуться сегодня?';

  @override
  String get coachPrompt2 => 'Чему вы научились сегодня?';

  @override
  String get coachPrompt3 => 'С кем вы сегодня разговаривали и какие ощущения?';

  @override
  String get coachPrompt4 => 'За что вы благодарны прямо сейчас?';

  @override
  String get coachPrompt5 => 'Что сегодня отняло у вас больше всего энергии?';

  @override
  String get coachPrompt6 =>
      'Опишите небольшой момент, который вы хотите запомнить.';

  @override
  String get coachPrompt7 => 'Что сделает завтрашний день хорошим?';

  @override
  String get coachPrompt8 => 'Что у тебя на уме в последнее время?';

  @override
  String get coachPrompt9 => 'Что ты сделал сегодня только для себя?';

  @override
  String get coachPrompt10 =>
      'Если бы у сегодняшнего дня было название, какое бы оно было?';

  @override
  String get pageMediaTitle => 'СМИ';

  @override
  String get pageAtlasTitle => 'Атлас';

  @override
  String get pageCoachTitle => 'Тренер';

  @override
  String get noEntrySelected => 'Запись не выбрана.';

  @override
  String get entryShare => 'Поделиться';

  @override
  String get entryFavorite => 'Звезда';

  @override
  String get entryEdit => 'Редактировать';

  @override
  String get entryPrevious => 'Предыдущая запись';

  @override
  String get entryNext => 'Следующая запись';

  @override
  String get journalStories => 'Истории';

  @override
  String get journalEntries => 'Записи';

  @override
  String get journalEmptyHint =>
      'Начните свой дневник с добавления новой записи.';

  @override
  String get storyToday => 'Сегодня';

  @override
  String get storyThrowback => 'Возвращение';

  @override
  String get storyNoThrowback => 'Сегодня никакого возврата';

  @override
  String get mediaFiles => 'Медиа-файлы';

  @override
  String get mediaEmpty => 'Фото пока нет.';

  @override
  String get mediaEmptyHint =>
      'Здесь будут показаны фотографии, прикрепленные к записям.';

  @override
  String get atlasEmpty => 'Нет записей с указанием местоположения.';

  @override
  String get atlasEmptyHint =>
      'Здесь будут показаны записи с указанием местоположения.';

  @override
  String get atlasShowAll => 'Показать все записи';

  @override
  String get atlasMyLocation => 'Мое местоположение';

  @override
  String get coachAll => 'Все';

  @override
  String get coachPrograms => 'Программы';

  @override
  String get coachTemplates => 'Шаблоны';

  @override
  String get coachKindProgram => 'Программа';

  @override
  String get coachKindTemplate => 'Шаблон';

  @override
  String get coachNoTemplates => 'Никаких программ и шаблонов.';

  @override
  String get coachUseTemplate => 'Пишите по этому шаблону';

  @override
  String get coachProgramEverydayTitle => 'Повседневные моменты';

  @override
  String get coachProgramEverydayDescription =>
      'Пять коротких вопросов, по одному в день. Каждый из них занимает минуту или две и помогает вам увидеть, что сделало этот день вашим. Мягкий способ выработать привычку писать понемногу каждый день.';

  @override
  String get coachProgramReflectTitle => 'Глядя внутрь';

  @override
  String get coachProgramReflectDescription =>
      'Один более глубокий вопрос в неделю, в течение пяти недель. Не торопитесь с каждым: как вы себя чувствуете, что вас утомляет, за что вы благодарны.';

  @override
  String get searchFilters => 'Фильтры';

  @override
  String get searchFilterTags => 'Теги';

  @override
  String get searchFilterStarred => 'Помечено';

  @override
  String get searchHint => 'Введите текст для поиска или выберите фильтр.';

  @override
  String get locationTitle => 'Расположение';

  @override
  String get locationName => 'Название места';

  @override
  String get locationRemove => 'Удалить';

  @override
  String get locationServiceDisabled =>
      'Службы определения местоположения отключены.';

  @override
  String get locationPermissionDenied =>
      'В разрешении на размещение было отказано.';

  @override
  String get locationUnavailable =>
      'Не удалось получить текущее местоположение.';

  @override
  String get calendarJumpToToday => 'Перейти к сегодняшнему дню';

  @override
  String get editorStartWriting => 'Начните писать или выберите ';

  @override
  String get editorTemplateLink => 'Шаблон';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Выберите шаблон';

  @override
  String get templateFeatured => 'Рекомендуемые шаблоны';

  @override
  String get templateMine => 'Мои шаблоны';

  @override
  String get templateDailyName => 'Ежедневный обзор';

  @override
  String get templateDailyDescription =>
      'Что произошло, каково это было и что будет дальше.';

  @override
  String get templateDailyText =>
      '## Что произошло сегодня\n\n\n## Что я чувствовал\n\n\n## Три вещи, за которые я благодарен\n1. \n2. \n3. \n\n## Завтра\n';

  @override
  String get templateTravelName => 'Запись в дневнике путешествий';

  @override
  String get templateTravelDescription => 'Места, моменты и еда с дороги.';

  @override
  String get templateTravelText =>
      '## Куда я пошел\n\n\n## Момент, который мне запомнился больше всего\n\n\n## Что я ел\n\n\n## Планы на завтра\n';

  @override
  String get templateReadingName => 'Чтение заметок';

  @override
  String get templateReadingDescription => 'Цитаты и мысли из прочитанного.';

  @override
  String get templateReadingText =>
      '## Книга\n\n\n## Где я\n\n\n## Цитаты\n> \n\n## Мои мысли\n';

  @override
  String get templateWeeklyName => 'Еженедельный обзор';

  @override
  String get templateWeeklyDescription =>
      'Основные моменты, трудности и фокус следующей недели.';

  @override
  String get templateWeeklyText =>
      '## Основные моменты\n\n\n## Что было сложно\n\n\n## Что я узнал\n\n\n## Фокус на следующей неделе\n';

  @override
  String get entryDuplicate => 'Дублировать';

  @override
  String get entryDuplicated => 'Запись продублирована';

  @override
  String get entrySaveAsTemplate => 'Сохранить как шаблон';

  @override
  String get entrySavedAsTemplate => 'Сохранено как шаблон.';

  @override
  String get storyStatistics => 'Статистика';

  @override
  String get storyMoodChart => 'Диаграмма настроения';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return 'Записи $entries · $days дней';
  }

  @override
  String get storyThisYear => 'В этом году';

  @override
  String get storyLastYear => 'В прошлом году';

  @override
  String get storyTapToOpen => 'Нажмите на день, чтобы открыть его.';

  @override
  String get settingsGeneralTitle => 'Общий';

  @override
  String get settingsDataTitle => 'Данные и хранение';

  @override
  String get settingsStoriesTitle => 'Истории';

  @override
  String get settingsHelpTitle => 'Помощь и информация';

  @override
  String get weatherTitle => 'Погода';

  @override
  String get weatherClear => 'Очистить';

  @override
  String get weatherPartlyCloudy => 'Небольшая облачность';

  @override
  String get weatherCloudy => 'Облачно';

  @override
  String get weatherFog => 'Туман';

  @override
  String get weatherDrizzle => 'Морось';

  @override
  String get weatherRain => 'Дождь';

  @override
  String get weatherSnow => 'Снег';

  @override
  String get weatherStorm => 'Гроза';

  @override
  String get weatherFetch => 'Получить прогноз погоды для этой записи';

  @override
  String get weatherNeedsLocation =>
      'Сначала добавьте местоположение с координатами.';

  @override
  String get weatherUnavailable =>
      'Погода недоступна для этого места и времени.';

  @override
  String get weatherRemove => 'Удалить погоду';

  @override
  String get activityTitle => 'Деятельность';

  @override
  String get activityStill => 'Тем не менее';

  @override
  String get activityWalking => 'Прогулка';

  @override
  String get activityRunning => 'Бег';

  @override
  String get activityCycling => 'Велоспорт';

  @override
  String get activityVehicle => 'В автомобиле';

  @override
  String get activityFlying => 'Летающий';

  @override
  String get activityExercise => 'Упражнение';

  @override
  String get activityDetect => 'Обнаружение текущей активности';

  @override
  String get activityDetectFailed => 'Не удалось обнаружить активность.';

  @override
  String get activityRemove => 'Удалить активность';

  @override
  String get settingsAutoAddTitle => 'Добавить автоматически';

  @override
  String get settingsAutoAddLocation => 'Расположение';

  @override
  String get settingsAutoAddWeather => 'Погода';

  @override
  String get settingsAutoAddHint => 'Новые записи заполняются при создании.';

  @override
  String get settingsTemperatureUnit => 'Единица измерения температуры';

  @override
  String get settingsCelsius => 'Цельсия (°С)';

  @override
  String get settingsFahrenheit => 'Фаренгейт (°F)';

  @override
  String get moodGreat => 'Отлично';

  @override
  String get moodGood => 'Хорошо';

  @override
  String get moodOkay => 'Хорошо';

  @override
  String get moodBad => 'Плохо';

  @override
  String get moodAwful => 'Ужасно';

  @override
  String get locationSearchHint => 'Поиск места';

  @override
  String get locationSearchEmpty => 'Мест не найдено';

  @override
  String get settingsWallpaper => 'обои';

  @override
  String get wallpaperNone => 'Нет';

  @override
  String get wallpaperDots => 'Точки';

  @override
  String get wallpaperGrid => 'Сетка';

  @override
  String get wallpaperLines => 'Линии';

  @override
  String get wallpaperPhoto => 'Фото…';

  @override
  String get settingsFontFamily => 'Шрифт';

  @override
  String get fontSystem => 'Система';

  @override
  String get fontSerif => 'с засечками';

  @override
  String get fontMono => 'Моноширинный';

  @override
  String get settingsFontSize => 'Размер шрифта';

  @override
  String get fontSizeSmall => 'Маленький';

  @override
  String get fontSizeMedium => 'Средний';

  @override
  String get fontSizeLarge => 'Большой';

  @override
  String get fontSizeExtraLarge => 'Очень большой';

  @override
  String get settingsLineSpacing => 'Межстрочный интервал';

  @override
  String get lineSpacingCompact => 'Компактный';

  @override
  String get lineSpacingNormal => 'Нормальный';

  @override
  String get lineSpacingRelaxed => 'Расслабленный';

  @override
  String get moodAssociationsTitle => 'Что заставляет меня чувствовать…';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching записей $total';
  }

  @override
  String get videoRecord => 'Записать видео';

  @override
  String get videoChoose => 'Выберите видео';

  @override
  String get audioRecordTitle => 'Запишите голосовую заметку';

  @override
  String get audioChoose => 'Выберите аудиофайл';

  @override
  String get audioStart => 'Запись';

  @override
  String get audioStop => 'Остановись и сохрани';

  @override
  String get audioPermissionDenied =>
      'Доступ к микрофону отключен. Разрешите это в настройках системы.';

  @override
  String get mediaTooLarge =>
      'Это видео слишком велико, чтобы его можно было прикрепить.';

  @override
  String get mediaUnavailable => 'Это вложение недоступно на этом устройстве.';

  @override
  String get widgetDone => 'Сегодняшняя запись написана';

  @override
  String get widgetPending => 'Как прошел твой день?';

  @override
  String get widgetWrite => 'Написать';

  @override
  String get insertChecklist => 'Контрольный список';

  @override
  String get insertNumberedList => 'Нумерованный список';

  @override
  String get insertTable => 'Таблица';

  @override
  String get insertDivider => 'Разделитель';

  @override
  String get insertCodeBlock => 'Кодовый блок';

  @override
  String get journalSortTitle => 'Сортировать записи';

  @override
  String get journalSortUpdated => 'Последнее обновление';

  @override
  String get settingsTimeFormat => 'Формат времени';

  @override
  String get settingsDayStart =>
      'Новые записи учитываются за предыдущий день до';

  @override
  String get settingsDayAskUntil => 'Тогда спросите, до какого дня';

  @override
  String get settingsDayStartMidnight => 'Выкл.';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Каждая запись сохраняет дату, к которой она принадлежит, рядом со временем ее написания, и вы можете изменить этот день в редакторе в любое время. Эти часы определяют только день для новых записей, поэтому их изменение не приводит к изменению существующей записи.';

  @override
  String get lateNightBadge =>
      'Написано поздно вечером, засчитано за вчерашний день';

  @override
  String editorDayAsk(String time) {
    return 'Написано по адресу $time. На какой день это рассчитано?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (вчера)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (сегодня)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'Написано $when';
  }

  @override
  String get timeFormat12 => '12-часовой';

  @override
  String get timeFormat24 => '24-часовой';

  @override
  String get settingsReminderDays => 'Напомни мне о';

  @override
  String get locationRecent => 'Недавние места';

  @override
  String get shareImage => 'Поделиться изображением';

  @override
  String get shareSaveImage => 'Сохранить изображение';

  @override
  String get shareSaved => 'Изображение сохранено.';

  @override
  String get deletedTitle => 'Недавно удалено';

  @override
  String get deletedNone => 'Недавно ничего не удалялось';

  @override
  String deletedHint(int days) {
    return 'Удаленные записи остаются здесь в течение $days дней, а затем удаляются.';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days дней осталось';
  }

  @override
  String get deletedRestore => 'Восстановить';

  @override
  String get deletedDeleteForever => 'Удалить навсегда';

  @override
  String get deletedDeleteForeverDescription =>
      'Запись и ее вложения будут удалены. Это невозможно отменить.';

  @override
  String get deletedEmpty => 'Пустой';

  @override
  String get deletedEmptyDescription =>
      'Удалить все записи в разделе Недавно удаленные? Это невозможно отменить.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Случайное блуждание';

  @override
  String get randomSubtitle => 'Открыть прошлую запись';

  @override
  String get randomNext => 'Другой';

  @override
  String get randomAll => 'Все';

  @override
  String get randomWithPhotos => 'С фотографиями';

  @override
  String get randomGoodDays => 'Хороших дней';

  @override
  String get randomEmpty => 'Нет записей на выбор';

  @override
  String get reviewWeekTitle => 'На этой неделе';

  @override
  String get reviewWeekSubtitle => 'Ваша неделя на данный момент';

  @override
  String get reviewYearTitle => 'В этом году';

  @override
  String get reviewEmpty => 'Еще ничего не написано';

  @override
  String get reviewEntries => 'Записи';

  @override
  String get reviewDaysWritten => 'Дни написаны';

  @override
  String get reviewWords => 'Слова';

  @override
  String get reviewPhotos => 'Фотографии';

  @override
  String get reviewLongestRun => 'Самая длинная серия дней';

  @override
  String get reviewAverageMood => 'Среднее настроение';

  @override
  String get reviewFavorites => 'Чаще всего';

  @override
  String get reviewByMonth => 'По месяцам';

  @override
  String get reviewHighlight => 'Выделить';

  @override
  String get yearInPixels => 'Год в пикселях';

  @override
  String get capsuleSeal => 'Печать как капсула времени';

  @override
  String get capsuleTitle => 'Капсула времени';

  @override
  String capsuleOpensOn(Object date) {
    return 'Открывается на $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Написано на $date';
  }

  @override
  String get capsuleOpenEarly => 'Открыто рано';

  @override
  String get capsuleOpenEarlyDescription =>
      'Капсула открывается и остается открытой.';

  @override
  String get capsuleOpened => 'Капсула времени открыта';

  @override
  String get templateMorningName => 'Утренние страницы';

  @override
  String get templateMorningDescription => 'Настройте день за три минуты';

  @override
  String get templateMorningText =>
      '## Три вещи, которые я хочу сделать сегодня хорошо\n1. \n2. \n3. \n\n## То, чего я с нетерпением жду\n\n## Заметка для себя\n';

  @override
  String get templateEveningName => 'Вечерний обзор';

  @override
  String get templateEveningDescription =>
      'Завершите день тем, что прошло хорошо';

  @override
  String get templateEveningText =>
      '## Три хороших дела сегодня\n1. \n2. \n3. \n\n## Что я узнал\n\n## Что может быть лучше завтра\n';

  @override
  String get routineMorning => 'Доброе утро';

  @override
  String get routineEvening => 'Вечерний обзор';

  @override
  String get settingsRoutinePrompts => 'Утренние и вечерние подсказки';

  @override
  String get settingsRoutinePromptsHint =>
      'Предложите утренний или вечерний шаблон в Stories.';

  @override
  String get checkInTitle => 'Быстрая регистрация';

  @override
  String get checkInSubtitle => 'Настроение в два касания';

  @override
  String get checkInMood => 'Как вы себя чувствуете?';

  @override
  String get checkInActivity => 'Что ты делаешь?';

  @override
  String get checkInNote => 'Строка об этом (необязательно)';

  @override
  String get checkInSave => 'Сохранить';

  @override
  String editorWordCount(int words, int characters) {
    return 'Слова $words · Символы $characters';
  }

  @override
  String get coachProgramEverydayTagline => 'Замечайте мелочи в течение дня.';

  @override
  String get coachProgramReflectTagline =>
      'Замедлитесь и прислушайтесь к себе.';

  @override
  String get coachDuration => 'Продолжительность';

  @override
  String get coachInterval => 'Интервал';

  @override
  String get coachDifficulty => 'Сложность';

  @override
  String get coachIntervalDaily => 'Ежедневно';

  @override
  String get coachIntervalWeekly => 'Еженедельно';

  @override
  String get coachDifficultyBeginner => 'Новичок';

  @override
  String get coachDifficultyIntermediate => 'Средний';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня',
      one: '$count день',
      many: '$count дней',
      few: '$count дня',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count недели',
      one: '$count неделя',
      many: '$count недель',
      few: '$count недели',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'День $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Неделя $n';
  }

  @override
  String get coachEnroll => 'Зарегистрироваться';

  @override
  String get coachEndProgram => 'Завершить программу';

  @override
  String get coachAuthor => 'Автор';

  @override
  String get coachAuthorBio => 'Подсказки написаны для этого приложения.';

  @override
  String get coachEnrolledTip =>
      'Все готово! Ваши вопросы появятся в историях.';

  @override
  String get coachGoToStories => 'Перейти в истории';

  @override
  String get coachAnswerHint => 'Напишите свой ответ…';

  @override
  String get storyWrapUp => 'Это все на сегодня.';

  @override
  String get storyTapToClose => 'Нажмите, чтобы закрыть';

  @override
  String get coachAnswerDone => 'Готово';

  @override
  String get coachAnswered => 'Ответ получен, нажмите, чтобы открыть';

  @override
  String get coachAnsweredEarlier => 'Ответил';

  @override
  String get locationLocating => 'Поиск…';

  @override
  String get locationPickPlace => 'Выберите место';

  @override
  String get locationPlacesHint => 'Адрес или название места';

  @override
  String get locationCustom => 'Пользовательское место';

  @override
  String get locationCurrent => 'Текущее местоположение';

  @override
  String get locationSaved => 'Сохраненные места';

  @override
  String get locationSearchResults => 'Результаты поиска';

  @override
  String get locationNearby => 'Места рядом';

  @override
  String get locationRename => 'Переименовать';

  @override
  String get locationSavePlace => 'Сохранить место';

  @override
  String get locationUnsavePlace => 'Удалить из сохраненных мест';

  @override
  String get shareAs => 'Поделиться как…';

  @override
  String get shareAsImage => 'Изображение';

  @override
  String get shareAsZip => 'ZIP с оригинальным носителем';

  @override
  String get shareAsPlainText => 'Обычный текст';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Добро пожаловать в AID Diary';

  @override
  String get onboardWelcomeText =>
      'Начните здесь или подключите это устройство к уже используемому.';

  @override
  String get onboardStart => 'Начать писать';

  @override
  String get helpFaq => 'Часто задаваемые вопросы';

  @override
  String get helpFaq1Q => 'Где хранится мой дневник?';

  @override
  String get helpFaq1A =>
      'Ваш дневник хранится на этом устройстве. Он достигает других устройств или хранилища только тогда, когда вы включаете синхронизацию, совместное использование или экспорт. Синхронизация имеет сквозное шифрование.';

  @override
  String get helpFaq2Q =>
      'Как сохранить копию или перенести на новое устройство?';

  @override
  String get helpFaq2A =>
      'Подключитесь к существующему устройству в «Настройки» → «Данные и хранилище» → «Синхронизация» и подтвердите авторизацию на устройстве, на котором находится ваш дневник. Оба устройства остаются работоспособными. Вы также можете создать резервную копию и восстановить ее на другом устройстве.';

  @override
  String get helpFaq3Q =>
      'Могу ли я вносить записи из других приложений-дневников?';

  @override
  String get helpFaq3A =>
      'Да: в «Настройки» → «Данные и хранилище» импортируйте экспорт из Daylio, Diarium, Diaro, DayBook, My Brain, OneShot и Pixels или экспортируйте JSON.';

  @override
  String get helpFaq4Q => 'Как работают тренерские программы?';

  @override
  String get helpFaq4A =>
      'Зарегистрируйтесь в программе на странице тренера. Каждый день или неделю в историях ждет новый вопрос; ваш ответ сохраняется как запись.';

  @override
  String get helpFaq5Q => 'Что, если я забуду свой пароль?';

  @override
  String get helpFaq5A =>
      'Код доступа невозможно восстановить, поэтому сохраните резервную копию своего дневника.';

  @override
  String get helpPrivacy => 'Конфиденциальность';

  @override
  String get helpPrivacyText =>
      'Содержимое дневника и медиафайлы остаются на этом устройстве, пока вы не включите зашифрованную синхронизацию или не поделитесь ими/экспортируете их. Карты, поиск мест и погода используют настроенные службы и отправляют местоположение или поисковый запрос, необходимые для этого запроса, а не текст дневника.';

  @override
  String get photoMetaTitle => 'Использовать детали фотографии?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Посчитайте эту запись за $date и установите ее место на $place, как записано на фото?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Считать эту запись $date, когда фото сделано?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Установите место этой записи на $place, где было сделано фото?';
  }

  @override
  String get photoMetaApply => 'Используйте их';

  @override
  String get quickWriteTitle => 'Быстрая запись';

  @override
  String get quickWriteText => 'Нажмите, чтобы начать новую запись.';

  @override
  String get settingsQuickWriteTitle => 'Быстрая запись в уведомлениях';

  @override
  String get settingsQuickWriteDescription =>
      'Держите уведомление, которое открывает новую запись.';

  @override
  String get settingsNudgesTitle => 'Подтолкни меня после спокойной растяжки';

  @override
  String settingsNudgesDescription(int days) {
    return 'Нежное напоминание, если вы не писали уже $days дней.';
  }

  @override
  String get nudgeTitle => 'Прошло много времени';

  @override
  String get nudgeMonday => 'Новая неделя: чего вы ждете?';

  @override
  String get nudgeTuesday => 'Двух строк достаточно. Как вы сегодня?';

  @override
  String get nudgeWednesday =>
      'В середине недели. Что особенного на данный момент?';

  @override
  String get nudgeThursday =>
      'Что-нибудь маленькое, что стоит сохранить с сегодняшнего дня?';

  @override
  String get nudgeFriday =>
      'Неделя подходит к концу. Обратите внимание на один хороший момент.';

  @override
  String get nudgeSaturday => 'Медленная суббота — хороший день для письма.';

  @override
  String get nudgeSunday => 'Оглянитесь на неделю до ее окончания.';

  @override
  String get photoWidgetEmpty =>
      'Здесь отображаются фотографии, которые вы добавляете в записи.';

  @override
  String get channelReminders => 'Напоминания';

  @override
  String get channelOnThisDay => 'В этот день';

  @override
  String get channelCoach => 'Тренер подсказывает';

  @override
  String get channelNudges => 'Подталкивания после тихих дней';

  @override
  String get channelQuickWrite => 'Быстрая запись';

  @override
  String get channelBackup => 'Резервные копии';

  @override
  String get formatJsonExport => 'JSON (экспорт AID Diary)';

  @override
  String get aboutModifiedNotice =>
      'Модифицированная версия Daily You, созданная Демизо и его участниками. Это не официальное приложение Daily You.';

  @override
  String get toolbarPhotos => 'Добавить фотографии';

  @override
  String get toolbarMedia => 'Фото и видео';

  @override
  String get mediaFromGallery => 'Выбрать из галереи';

  @override
  String get mediaFromFiles => 'Выбрать из файлов';

  @override
  String get editorLeaveTitle => 'Сохранить эту запись?';

  @override
  String get editorLeaveDiscard => 'Не сохранять';

  @override
  String get editorTitleHint => 'Название';

  @override
  String get editorLocating => 'Поиск…';

  @override
  String get toolbarVideo => 'Видео';

  @override
  String get toolbarAudio => 'Голосовая заметка';

  @override
  String get toolbarTags => 'Теги';

  @override
  String get toolbarBulletList => 'Маркированный список';

  @override
  String get toolbarHeading => 'Заголовок';

  @override
  String get toolbarBold => 'Жирный';

  @override
  String get toolbarItalic => 'Курсив';

  @override
  String get toolbarHighlight => 'Выделить';

  @override
  String get toolbarStrikethrough => 'Зачеркивание';

  @override
  String get toolbarQuote => 'Цитата';

  @override
  String get toolbarLink => 'Ссылка';

  @override
  String get toolbarInsert => 'Вставить';

  @override
  String get toolbarUndo => 'Отменить';

  @override
  String get toolbarRedo => 'Повторить';

  @override
  String get toolbarInsertDate => 'Вставьте дату';

  @override
  String get toolbarInsertTime => 'Вставьте время';

  @override
  String get settingsSyncTitle => 'Облачная синхронизация';

  @override
  String get syncOffDescription =>
      'Сохраняйте этот дневник одинаковым на всех своих устройствах через Google Drive или сервер WebDAV, например Nextcloud, Synology или Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'Синхронизировать с Google Drive';

  @override
  String get syncOrWebDav => 'Или сервер WebDAV';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn =>
      'Выполнен вход. Вы можете вернуться в AID Diary.';

  @override
  String get syncGoogleSignInAgain =>
      'Google требует, чтобы вы снова вошли в систему.';

  @override
  String get syncSignInAgain => 'Войдите снова';

  @override
  String get settingsCommandLineTitle => 'Командная строка';

  @override
  String get commandLineToggle => 'Интерфейс командной строки';

  @override
  String get commandLineToggleHint =>
      'Разрешит команде помощи и другим программам на этом устройстве использовать команды приложения.';

  @override
  String get commandLineAlwaysOn => 'Всегда в разработке.';

  @override
  String commandLineListening(int port) {
    return 'Прослушивание порта $port';
  }

  @override
  String get commandPaletteTitle => 'Все команды';

  @override
  String get commandPaletteSearch => 'Команды поиска';

  @override
  String get commandPaletteRun => 'Беги';

  @override
  String get commandPaletteConfirm =>
      'Это невозможно просто отменить. Запустить?';

  @override
  String syncReceiving(int done, int total) {
    return 'Получение $done или $total…';
  }

  @override
  String syncSending(int done, int total) {
    return 'Отправка $done из $total…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'Доступ к Google Drive запрещен. Подключитесь еще раз и отметьте Google Drive на странице Google.';

  @override
  String get syncEntryUnsynced =>
      'Не синхронизировано: последняя синхронизация не прошла.';

  @override
  String get syncUseOfficial => 'Используйте сервер синхронизации AID';

  @override
  String get syncServer => 'Адрес сервера';

  @override
  String get syncUsername => 'Имя пользователя';

  @override
  String get syncPassword => 'Пароль';

  @override
  String get syncConnect => 'Подключиться';

  @override
  String get syncConnecting => 'Подключение…';

  @override
  String get syncSignInFailed =>
      'Не удалось войти. Проверьте адрес, имя пользователя и пароль.';

  @override
  String syncConnectFailed(String error) {
    return 'Не удалось подключиться: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Начать синхронизацию';

  @override
  String get syncNewSpaceDescription =>
      'Здесь пока нет синхронизированного дневника. Этот дневник будет загружен в сквозном зашифрованном виде с помощью ключа, который останется на ваших устройствах.';

  @override
  String get syncJoinTitle => 'Присоединяйтесь к синхронизированному дневнику';

  @override
  String get syncWrongKey =>
      'Этот код восстановления не открывает синхронизированный дневник.';

  @override
  String syncLastSynced(String time) {
    return 'Последняя синхронизация $time';
  }

  @override
  String get syncNever => 'Еще не синхронизировано';

  @override
  String get syncSyncing => 'Синхронизация…';

  @override
  String syncFailed(String error) {
    return 'Последняя синхронизация не удалась: $error';
  }

  @override
  String get syncLocked =>
      'Синхронизированный дневник теперь принадлежит другим устройствам или был запущен заново. Подключитесь к одному из них или используйте код восстановления, чтобы продолжить синхронизацию.';

  @override
  String get syncNow => 'Синхронизировать сейчас';

  @override
  String get syncUnlock => 'Разблокировать';

  @override
  String get syncEncrypted => 'Сквозное шифрование';

  @override
  String get syncDisconnect => 'Остановить синхронизацию';

  @override
  String get syncDisconnectDescription =>
      'Это устройство прекращает синхронизацию. Дневник здесь и синхронизированная копия останутся такими, какие они есть.';

  @override
  String get syncOwnRecoveryPassword =>
      'Использовать мой собственный пароль восстановления';

  @override
  String get syncRecoveryPassword => 'Пароль восстановления';

  @override
  String get syncRecoveryPasswordRepeat => 'Повторите пароль восстановления';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Используйте как минимум символы $min.';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'Пароли разные';

  @override
  String get syncRecoveryCode => 'Код восстановления';

  @override
  String get syncRecoveryCodeTitle => 'Сохраните код восстановления';

  @override
  String get syncRecoveryCodeDescription =>
      'Если все ваши устройства потеряны, этот код восстановит ваш синхронизированный дневник. Храните его в менеджере паролей или на бумаге. Это показано только один раз.';

  @override
  String get syncRecoveryCodeCopied => 'Код восстановления скопирован.';

  @override
  String get syncRecoveryCodeSaved => 'Я сохранил это';

  @override
  String get syncJoinNeedsKey =>
      'Этот синхронизированный дневник принадлежит другим вашим устройствам. Выполните сопряжение с одним из них или используйте код восстановления. В него будут добавлены записи на этом устройстве.';

  @override
  String get syncPairDevice => 'Сопряжение с устройством';

  @override
  String get syncUseRecoveryCode => 'Используйте код восстановления';

  @override
  String get syncAddDevice => 'Добавить устройство';

  @override
  String get syncChangeRecoveryCode => 'Изменить код восстановления';

  @override
  String get syncChangeRecoveryDescription =>
      'Новый код заменяет текущий, который перестает работать. Ваши данные и другие устройства останутся такими, какие они есть.';

  @override
  String get syncNewRandomCode => 'Новый случайный код';

  @override
  String get syncRecoveryCodeChanged => 'Код восстановления изменен';

  @override
  String get syncResetSpace => 'Начать синхронизированный дневник заново';

  @override
  String get syncResetSpaceDescription =>
      'Только когда ни одно устройство и никакой код восстановления его больше не откроется: синхронизированная копия заменяется дневником на этом устройстве, под ключами этого устройства. Затем другие ваши устройства снова подключатся.';

  @override
  String get syncPairTitle => 'Сопряжение устройств';

  @override
  String get syncPairShow => 'Показать код';

  @override
  String get syncPairEnter => 'Введите код';

  @override
  String get syncPairShowHint =>
      'На другом устройстве откройте «Сопряжение устройств», выберите «Ввести код» и введите или отсканируйте его.';

  @override
  String get syncPairEnterHint =>
      'Введите код, отображаемый на другом устройстве, или отсканируйте его.';

  @override
  String get syncPairCode => 'Код сопряжения';

  @override
  String get syncPairScan => 'Сканировать';

  @override
  String get syncPairStart => 'Пара';

  @override
  String get syncPairWaiting => 'Ожидание другого устройства…';

  @override
  String syncPairDone(String device) {
    return 'В паре с $device';
  }

  @override
  String get syncPairWrongCode =>
      'Код не совпал. Покажите новый код и повторите попытку.';

  @override
  String get syncPairNoOffer =>
      'Ни одно устройство не отображает этот код. Возможно, срок его действия истек.';

  @override
  String get syncPairTimedOut => 'Другое устройство не ответило вовремя.';

  @override
  String get syncPairNeither =>
      'Ни на одном из устройств пока не настроен этот синхронизированный дневник.';

  @override
  String get syncPairBoth =>
      'Оба устройства уже открывают этот синхронизированный дневник.';

  @override
  String syncPairFailed(String error) {
    return 'Не удалось выполнить сопряжение: $error.';
  }

  @override
  String get syncMediaPending =>
      'Дневник синхронизирован · некоторые медиафайлы все еще передаются';

  @override
  String get syncWaitingForDevices =>
      'Дневник синхронизирован · ожидание передачи мультимедиа с другого устройства';

  @override
  String get syncCacheNotice =>
      'Облачные медиа — это временно. Сохраняйте оригиналы на своих устройствах; синхронизация не является резервной копией.';

  @override
  String get paperTitle => 'Письменная бумага';

  @override
  String get paperPlain => 'Обычный';

  @override
  String get paperLined => 'на подкладке';

  @override
  String get paperGrid => 'Сетка';

  @override
  String get paperTinted => 'Тонированный';

  @override
  String get paperDecorationTitle => 'Украшения';

  @override
  String get paperDecorationNone => 'Нет';

  @override
  String get paperDecorationBotanical => 'Листья';

  @override
  String get paperDecorationStars => 'Звезды';

  @override
  String get paperDecorationWashi => 'Лента Васи';

  @override
  String get themeDarkChoice => 'Темный внешний вид';

  @override
  String get themeDarkSame => 'Следуйте светлой палитре';

  @override
  String get themeDarkCustom => 'Отдельная палитра';

  @override
  String get themeDarkAccent => 'Темный акцентный цвет';

  @override
  String get themeColorTeal => 'Бирюзовый';

  @override
  String get themeColorCyan => 'Голубой';

  @override
  String get themeColorIndigo => 'Индиго';

  @override
  String get themeColorCoral => 'Коралл';

  @override
  String get themeColorOlive => 'Оливковое';

  @override
  String get themeColorSlate => 'Шифер';

  @override
  String get drawingTitle => 'Рисование';

  @override
  String get drawingPen => 'Ручка';

  @override
  String get drawingEraser => 'Ластик';

  @override
  String get drawingUndo => 'Отменить';

  @override
  String get drawingClear => 'Очистить';

  @override
  String get drawingWidth => 'Ширина пера';

  @override
  String get drawingStylusOnly => 'Только стилус';

  @override
  String get drawingDiscardTitle => 'Отказаться от рисунка?';

  @override
  String get drawingDiscardBody => 'Этот рисунок не сохранился.';

  @override
  String get drawingSaveError => 'Не удалось сохранить рисунок.';

  @override
  String get syncNetworkTitle => 'Диагностика сети';

  @override
  String get syncNetworkRefresh => 'Обновить';

  @override
  String get syncNetworkSelectedRoute => 'Текущий путь';

  @override
  String get syncNetworkAvailableRoutes => 'Доступные пути';

  @override
  String get syncNetworkSignaling => 'Подключение к каталогу устройств';

  @override
  String get syncNetworkRelayRemaining => 'Оставшийся лимит на реле';

  @override
  String get syncNetworkIcePair => 'Кандидаты на прямое подключение';

  @override
  String get syncNetworkPeerTrusted => 'Аутентифицированное устройство';

  @override
  String get syncNetworkNoRoute => 'Ожидание соединения';

  @override
  String get syncNetworkUnavailable => 'Диагностика недоступна';

  @override
  String get syncMediaCopiesTitle => 'Доставка носителей и копий';

  @override
  String get syncMediaPendingCount => 'Ожидание передачи';

  @override
  String get syncMediaDurableCount => 'Отправлено в личное хранилище';

  @override
  String get syncMediaTemporaryCount => 'Временные или неподтвержденные копии';

  @override
  String get syncMediaReceiptExplanation =>
      'Эти подсчеты описывают завершенные поставки, а не свежий аудит сохранившихся резервных копий.';

  @override
  String get syncMediaCacheExplanation =>
      'Срок действия временных облачных носителей может истечь. Сохраните оригиналы или отдельную резервную копию.';

  @override
  String get momentsTitle => 'Фото моменты';

  @override
  String get momentsHint =>
      'Находите группы, используя местное время фото и дополнительные координаты. Фотографии прикрепляются только при выборе карты.';

  @override
  String get momentsScan => 'Находите моменты';

  @override
  String get momentsChooseFolder => 'Выбрать папку с фотографиями';

  @override
  String get momentsLocation => 'Включить места для фотографий';

  @override
  String get momentsEmpty => 'Нет недавних групп фотографий.';

  @override
  String get momentsCreate => 'Напишите об этих фотографиях';

  @override
  String get momentsDismiss => 'Уволить';

  @override
  String get momentsError => 'Не смог прочитать местные фотографии.';

  @override
  String get momentsCreated => 'Фотозапись создана.';

  @override
  String get momentsPermission =>
      'Разрешите доступ к фотографиям, чтобы найти местные предложения.';

  @override
  String get momentsScope =>
      'Только последние фотографии; максимум 500 фотографий и 20 фотографий на карту.';

  @override
  String momentsPhotoCount(int count) {
    return '$count фотографии';
  }

  @override
  String get nearbyTitle => 'Подключайте устройства';

  @override
  String get nearbySend => 'Авторизовать другое устройство';

  @override
  String get nearbyReceive => 'Подключиться к существующему устройству';

  @override
  String get nearbyInstructions =>
      'Подключите оба устройства к одному и тому же Wi-Fi или к точке доступа друг друга. Подтвердить авторизацию на имеющемся устройстве; оба устройства остаются пригодными для использования. Интернет не требуется.';

  @override
  String get nearbyCompare =>
      'Прежде чем утвердить, сравните этот код на обоих устройствах.';

  @override
  String get nearbyConfirm => 'Коды совпадают';

  @override
  String get nearbyScan => 'Сканируйте код другого устройства';

  @override
  String get nearbyPaste => 'Вставить приглашение';

  @override
  String get nearbyWaiting => 'Ожидание одобрения на другом устройстве';

  @override
  String get nearbyWorking =>
      'Авторизация и синхронизация вашего дневника и вложений…';

  @override
  String get nearbyPending =>
      'Некоторые вложения все еще требуют синхронизации. Оставьте другое устройство онлайн и повторите попытку.';

  @override
  String get nearbyComplete =>
      'Устройство подключено; дневник и вложения синхронизируются';

  @override
  String get nearbyFailed =>
      'Соединение не завершилось. Проверьте локальное соединение и повторите попытку.';

  @override
  String get nearbyEmptyRequired =>
      'Используйте устройство с пустым дневником, которое еще не подключено к синхронизации.';

  @override
  String get nearbyRetry => 'Продолжить синхронизацию';

  @override
  String get nearbyWifi => 'Настройки Wi-Fi';

  @override
  String get nearbyHotspot => 'Настройки точки доступа';

  @override
  String get nearbyKeepOpen =>
      'Держите эту страницу открытой до тех пор, пока новое устройство не завершится. Срок действия приглашения истекает через две минуты.';

  @override
  String get syncDevicesTitle => 'Авторизованные устройства';

  @override
  String get syncDevicesDescription =>
      'Только одобренные устройства могут получить доступ к этой учетной записи AID. Отзыв устройства блокирует сервер, но не может стереть уже скопированный на него мастер-ключ или дневник.';

  @override
  String get syncDeviceRequest =>
      'Покажите этот QR-код авторизации одобренному устройству.';

  @override
  String get syncDeviceAuthorize => 'Авторизация устройства';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Отсканируйте или вставьте запрос авторизации нового устройства.';

  @override
  String get syncDeviceRevoke => 'Отозвать';

  @override
  String get syncDeviceRotate => 'Поверните ключ подписи этого устройства';

  @override
  String get syncDeviceCheck => 'Проверить авторизацию';

  @override
  String get syncDeviceHardware => 'Аппаратный ключ подписи';

  @override
  String get syncDeviceSoftware =>
      'Неэкспортируемый ключ подписи программного обеспечения';

  @override
  String get syncDeviceUnavailable =>
      'Авторизация устройства недоступна. Одобрите это устройство с другого авторизованного устройства и повторите попытку.';

  @override
  String get syncDeviceRevoked => 'Отозван';

  @override
  String get syncDeviceLocal => 'Это устройство';

  @override
  String get cloudTrafficTitle =>
      'Ежемесячная квота передачи данных в облако для медиафайлов';

  @override
  String get cloudTrafficLimit => 'Ежемесячная квота передачи данных';

  @override
  String get cloudTrafficUsed => 'Используется передача данных';

  @override
  String get cloudTrafficRemaining => 'Осталось передать данные';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'Квота на передачу данных сбрасывается $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'Квота передачи облачных данных для медиафайлов исчерпана. Отсутствующие медиафайлы будут синхронизироваться автоматически, когда будет доступно прямое соединение или сброшена квота.';

  @override
  String get cloudTrafficExplanation =>
      'Кэширование медиафайлов и ретрансляция в реальном времени разделяют эту квоту передачи данных. Прямые соединения его не потребляют. Текст дневника и сообщения контроля соединения имеют отдельные небольшие дневные лимиты.';

  @override
  String get appearanceThemeSection => 'Тема приложения';

  @override
  String get appearancePaperSection => 'Бумага для дневника';

  @override
  String get appearanceTypographySection => 'Текст дневника';

  @override
  String get appearancePreferencesSection => 'Общие предпочтения';

  @override
  String get themeSystemAccentHint =>
      'Использует системную палитру вместо пользовательских цветов. Выключите его, чтобы выбрать свой собственный.';

  @override
  String get syncDeviceNameSaveFailed =>
      'Не удалось сохранить имя устройства. Пожалуйста, попробуйте еще раз.';

  @override
  String get nearbyConnectionHelp => 'Помощь по подключению';

  @override
  String get syncAllSynced => 'Все синхронизировано';

  @override
  String get syncDetailsTitle => 'Подробности синхронизации';

  @override
  String get syncMore => 'Больше возможностей';

  @override
  String get syncDeviceName => 'Имя устройства';

  @override
  String get syncDeviceNameHint => 'Например: Мой планшет';

  @override
  String get syncDeviceNameInvalid => 'Используйте от 1 до 32 символов';

  @override
  String get syncDeviceKeyDetails => 'Детали безопасности';

  @override
  String get syncConnectionProblem =>
      'Синхронизировать пока невозможно. Повторная попытка автоматически.';

  @override
  String get syncCopyComplete => 'Полная копия вашего дневника и медиафайлов';

  @override
  String get syncCopyPartial =>
      'Некоторые средства массовой информации все еще отсутствуют';

  @override
  String get syncCopyOlder => 'Новые изменения ждут синхронизации';

  @override
  String get syncCopyUnavailable =>
      'Сведения о копии недоступны. Повторите попытку позже.';

  @override
  String get syncCopyLastKnown =>
      'На других устройствах отображается последняя подтвержденная копия. Автономные устройства теперь невозможно проверить.';

  @override
  String get syncCopyTemporary =>
      'Временный кэш. Сохраняйте оригиналы на своих устройствах.';

  @override
  String get syncCopyStorage =>
      'Ваше хранилище синхронизации. Завершенные загрузки мультимедиа отображаются в диагностике.';

  @override
  String syncCopyChecked(String time) {
    return 'Последнее подтвержденное $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Передача данных, оставшаяся в этом месяце: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Начните здесь';

  @override
  String get onboardConnect => 'Подключиться к существующему устройству';

  @override
  String get onboardFailed =>
      'Не удалось завершить установку. Ваш дневник в безопасности; пожалуйста, попробуйте еще раз.';

  @override
  String get tutorialTitle => 'Как пользоваться дневником';

  @override
  String get tutorialWriteTitle => 'Напишите свою первую запись в дневнике';

  @override
  String get tutorialWriteText =>
      'Нажмите +, чтобы написать запись в дневнике. Добавьте необязательный заголовок, выберите дату дневника и нажмите галочку, чтобы сохранить. Вы можете отредактировать свою запись в дневнике снова в любое время.';

  @override
  String get tutorialMediaTitle =>
      'Добавьте фотографии, аудио или рукописный текст';

  @override
  String get tutorialMediaText =>
      'Используйте + в редакторе дневника, чтобы прикрепить фотографии, видео или голосовую запись или открыть холст для рукописного ввода. Эти вложения сохраняются вместе с записью в дневнике.';

  @override
  String get tutorialReviewTitle => 'Найдите день снова';

  @override
  String get tutorialReviewText =>
      'Просматривайте свой дневник или календарь, ищите свои записи и систематизируйте записи с помощью тегов. Страницы «Медиа» и «Атлас» позволяют находить прошлые записи по фотографии или местоположению.';

  @override
  String get tutorialSyncTitle => 'Используйте более одного устройства';

  @override
  String get tutorialSyncText =>
      'В меню «Настройки» → «Данные и хранилище» → «Синхронизация» подключитесь к существующему устройству и подтвердите авторизацию на этом устройстве. Оба устройства могут продолжать использовать дневник. Текст дневника синхронизируется первым. Медиа-файлы синхронизируются в следующий раз, когда это позволяют сетевое соединение и оставшаяся квота передачи данных.';

  @override
  String get tutorialPrivacyTitle => 'Держите свой дневник в безопасности';

  @override
  String get tutorialPrivacyText =>
      'Записи дневника остаются на этом устройстве, пока вы не включите их синхронизацию, отправку или экспорт. Синхронизация имеет сквозное шифрование. В настройках вы также можете установить пароль приложения, создать резервные копии и повторно открыть это руководство.';
}
