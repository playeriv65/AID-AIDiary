// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

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
  String get dailyReminderTitle => 'Напиши про день!';

  @override
  String get dailyReminderDescription => 'Час написати про сьогодні…';

  @override
  String get actionTakePhoto => 'Зробити фото';

  @override
  String get actionToday => 'Сьогодні';

  @override
  String get actionOtherDay => 'Іншого дня';

  @override
  String get pageHomeTitle => 'Домашня';

  @override
  String get jumpToMonthTitle => 'Перейти до місяця';

  @override
  String get jumpToLogTitle => 'Перейти до журналу';

  @override
  String get flashbacksTitle => 'Спогади';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Виключити погані дні';

  @override
  String get flaskbacksEmpty => 'Ще немає спогадів…';

  @override
  String get flashbackGoodDay => 'Хороший день';

  @override
  String get flashbackRandomDay => 'Випадковий день';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count тижнів тому',
      few: '$count тижні тому',
      one: '$count тиждень тому',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count місяців тому',
      few: '$count місяці тому',
      one: '$count місяць тому',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count років тому',
      few: '$count роки тому',
      one: '$count рік тому',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'Цього дня';

  @override
  String get pageGalleryTitle => 'Галерея';

  @override
  String get searchLogsHint => 'Шукати запис…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count записів',
      few: '$count записи',
      one: '$count запис',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count днів',
      few: '$count дні',
      one: '$count день',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count слова',
      one: '$count слово',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Немає записів…';

  @override
  String get noResults => 'Немає результатів…';

  @override
  String get sortDateTitle => 'За датою';

  @override
  String get sortOrderAscendingTitle => 'За зростанням';

  @override
  String get sortOrderDescendingTitle => 'За зменшенням';

  @override
  String get pageStatisticsTitle => 'Статистика';

  @override
  String get statisticsNotEnoughData => 'Недостатньо даних…';

  @override
  String get statisticsRangeOneMonth => '1 місяць';

  @override
  String get statisticsRangeSixMonths => '6 місяців';

  @override
  String get statisticsRangeOneYear => '1 рік';

  @override
  String get statisticsRangeAllTime => 'За весь час';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag зведений';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag за днем тижня';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag За часом';
  }

  @override
  String get chartGroupingLabel => 'Згрупувати за';

  @override
  String get chartGroupingDay => 'День';

  @override
  String get chartGroupingWeek => 'Тиждень';

  @override
  String get chartGroupingMonth => 'Місяць';

  @override
  String get chartGroupingYear => 'Рік';

  @override
  String get chartSmoothingLabel => 'Згладжування';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Поточний ланцюжок: $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Найдовший ланцюжок: $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Чудові дні $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Пройшло днів з останнього поганого дня: $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Не вдається отримати доступ до зовнішнього сховища';

  @override
  String get errorExternalStorageAccessDescription =>
      'Якщо ви використовуєте мережеве сховище, перевірте інтернет і доступ до сервісу сховища.\n\nТакож DailyYou могла втратити дозволи на доступ до зовнішньої теки. Перейдіть до налаштувань і знову виберіть зовнішню теку, щоб надати до неї доступ.\n\nУвага, зміни не будуть синхронізовані, доки ви не відновите доступ до зовнішнього сховища!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Використовувати натомість локальне сховище';

  @override
  String get databaseMigrationErrorTitle => 'Не вдалося перемістити ваші дані';

  @override
  String get databaseMigrationErrorDescription =>
      'Ваші записи в безпеці, але не можуть бути переміщенні до сховища додатка.\n\nСпробуйте знову та повідомте про проблему, якщо вона повториться.';

  @override
  String get databaseMigrationErrorRetry => 'Спробувати знову';

  @override
  String get errorReport => 'Повідомити про проблему';

  @override
  String get lastModified => 'Востаннє змінено';

  @override
  String get writeSomethingHint => 'Щось таки написати ж треба…';

  @override
  String get titleHint => 'Назва…';

  @override
  String get deleteLogTitle => 'Видалити запис';

  @override
  String get deleteLogDescription => 'Точно хочете видалити цей запис?';

  @override
  String get deletePhotoTitle => 'Видалити фото';

  @override
  String get deletePhotoDescription => 'Все ж таки видалити це фото?';

  @override
  String get pageSettingsTitle => 'Налаштування';

  @override
  String get settingsAppearanceTitle => 'Зовнішній вигляд';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get themeSystem => 'Як у системі';

  @override
  String get themeLight => 'Світла';

  @override
  String get themeDark => 'Темна';

  @override
  String get themeAmoled => 'Я бачу вас цікавить пітьма (OLED)';

  @override
  String get settingsFirstDayOfWeek => 'Перший день тижня';

  @override
  String get settingsCalendarSystem => 'Календарна система';

  @override
  String get calendarSystemGregorian => 'Григоріанський';

  @override
  String get calendarSystemJalali => 'Jalali';

  @override
  String get settingsUseSystemAccentColor =>
      'Використовувати колір акценту як в системі';

  @override
  String get settingsCustomAccentColor => 'Обрати свій колір акценту';

  @override
  String get settingsShowMarkdownToolbar =>
      'Відображати панель форматування тексту';

  @override
  String get settingsShowFlashbacks => 'Показати флешбеки';

  @override
  String get settingsChangeMoodIcons => 'Змініть емоджи настроїв';

  @override
  String get moodIconPrompt => 'Введіть іконку (емоджи)';

  @override
  String get settingsFlashbacksViewLayout => 'Макет перегляду флешбеків';

  @override
  String get settingsHideImagesInGallery => 'Приховати зображення в галереї';

  @override
  String get settingsHideImages => 'Сховати зображення';

  @override
  String get pageCalendarTitle => 'Календар';

  @override
  String get settingsNotificationsTitle => 'Нагадування';

  @override
  String get settingsDailyReminderOnboarding =>
      'Увімкніть щоденні нагадування, щоб залишатися послідовним!';

  @override
  String get settingsNotificationsPermissionsPrompt =>
      'Для надсилання нагадування у випадковий момент або у вибраний вами час буде запрошено дозвіл на «запланування будильників».';

  @override
  String get settingsDailyReminderTitle => 'Кожноденне нагадування';

  @override
  String get settingsOnThisDayDescription => 'Revisit past memories';

  @override
  String get settingsDailyReminderDescription => 'Ніжне нагадування щодня';

  @override
  String get settingsReminderTime => 'Час нагадування';

  @override
  String get settingsFixedReminderTimeTitle => 'Фіксований час нагадування';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Оберіть точний час для нагадувань';

  @override
  String get settingsAlwaysSendReminderTitle => 'Завжди надсилати нагадування';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Надсилати нагадування, навіть якщо ведення журналу вже розпочато';

  @override
  String get settingsCustomizeNotificationTitle => 'Налаштувати сповіщення';

  @override
  String get settingsTemplatesTitle => 'Шаблони';

  @override
  String get settingsDefaultTemplate => 'Шаблон за замовчуванням';

  @override
  String get manageTemplates => 'Керувати шаблонами';

  @override
  String get addTemplate => 'Додати шаблон';

  @override
  String get newTemplate => 'Новий шаблон';

  @override
  String get noTemplateTitle => 'Порожній';

  @override
  String get noTemplatesDescription => 'Жодного шаблону немає…';

  @override
  String get templateVariableTime => 'Час';

  @override
  String get templateDefaultTimestampTitle => 'Timestamp';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Підсумок дня';

  @override
  String get templateDefaultSummaryBody => '### Summary\n- \n\n### Quote\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Reflection';

  @override
  String get templateDefaultReflectionBody =>
      '### What did you enjoy about today?\n- \n\n### What are you thankful for?\n- \n\n### What are you looking forward to?\n- ';

  @override
  String get settingsTagsTitle => 'Tags';

  @override
  String get manageTags => 'Manage Tags';

  @override
  String get tagTypeLabelTitle => 'Label';

  @override
  String get tagTypeTrackerTitle => 'Tracker';

  @override
  String get nameHint => 'Name';

  @override
  String get tagColorLabel => 'Color';

  @override
  String get iconPickerTitle => 'Choose Icon';

  @override
  String get iconPickerIconsTab => 'Icons';

  @override
  String get iconPickerCustomTab => 'Custom';

  @override
  String get iconPickerSearchHint => 'Search icons…';

  @override
  String get colorPickerTitle => 'Choose Color';

  @override
  String get colorPickerPaletteTab => 'Colors';

  @override
  String get iconGroupMoodPeople => 'Mood & People';

  @override
  String get iconGroupHealth => 'Health';

  @override
  String get iconGroupWorkFinance => 'Work & Finance';

  @override
  String get iconGroupHabitsGoals => 'Habits & Goals';

  @override
  String get iconGroupNature => 'Nature';

  @override
  String get iconGroupFoodDrink => 'Food & Drink';

  @override
  String get iconGroupHome => 'Home';

  @override
  String get iconGroupTravel => 'Travel';

  @override
  String get iconGroupSymbols => 'Symbols';

  @override
  String get tagCategoryLabel => 'Category';

  @override
  String get tagLabel => 'Tag';

  @override
  String get tagCategoryUncategorized => 'Uncategorized';

  @override
  String get newCategoryTitle => 'New Category';

  @override
  String get shareButtonLabel => 'Share';

  @override
  String get importErrorDescription => 'Failed to import file!';

  @override
  String get exportErrorDescription => 'Failed to export file!';

  @override
  String get deleteTitle => 'Delete';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' It is used in $count logs.',
      one: ' It is used in 1 log.',
      zero: '',
    );
    return 'Delete \"$name\"?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Its $count tags will also be deleted.',
      one: ' Its 1 tag will also be deleted.',
      zero: '',
    );
    return 'Delete \"$name\"?$_temp0';
  }

  @override
  String deleteTemplateMessage(Object name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get filterTagsTitle => 'Filter';

  @override
  String get tagFilterModeAny => 'Any Tag';

  @override
  String get tagFilterModeAll => 'All Tags';

  @override
  String get clearAllFilters => 'Clear All';

  @override
  String get noTagsFilterLabel => 'No Tags';

  @override
  String get addTagsTitle => 'Add Tags';

  @override
  String get addTagsSearchHint => 'Search tags…';

  @override
  String get tagPickerSortManualLabel => 'Manual order';

  @override
  String get tagPickerSortUsageLabel => 'Sort by usage';

  @override
  String get tagFavoriteName => 'Favorite';

  @override
  String get tagEnergyName => 'Energy';

  @override
  String get tagCategoryActivitiesName => 'Activities';

  @override
  String get tagExerciseName => 'Exercise';

  @override
  String get tagSocializingName => 'Socializing';

  @override
  String get tagHobbyName => 'Hobby';

  @override
  String get tagEntertainmentName => 'Entertainment';

  @override
  String get tagDiningName => 'Dining';

  @override
  String get tagChoresName => 'Chores';

  @override
  String get tagCategoryEmotionsName => 'Emotions';

  @override
  String get tagExcitedName => 'Excited';

  @override
  String get tagGratefulName => 'Grateful';

  @override
  String get tagCalmName => 'Calm';

  @override
  String get tagTiredName => 'Tired';

  @override
  String get tagAnxiousName => 'Anxious';

  @override
  String get tagAnnoyedName => 'Annoyed';

  @override
  String get welcomeLogBodyText =>
      '## Welcome to AID Diary\n\n> Every day is worth remembering.\n\nWrite what happened, how you felt, and where you were. Your entries stay on this device.\n\n- **Journal** lists every entry by day\n- **Calendar**, **Media** and **Atlas** look back by date, photo and place\n- **Coach** offers prompts and templates when you don\'t know what to write\n\nAID Diary is a modified version of [Daily You](https://github.com/Demizo/Daily_You) by Demizo and contributors, and not the official Daily You app.';

  @override
  String get settingsStorageTitle => 'Сховище';

  @override
  String get settingsImageQuality => 'Якість світлин';

  @override
  String get imageQualityHigh => 'Висока';

  @override
  String get imageQualityMedium => 'Середня';

  @override
  String get imageQualityLow => 'Низька';

  @override
  String get imageQualityNoCompression => 'Оригінальна';

  @override
  String get settingsLogFolder => 'Тека для записів';

  @override
  String get settingsImageFolder => 'Тека для світлин';

  @override
  String get warningTitle => 'Увага';

  @override
  String get logFolderWarningDescription =>
      'Якщо вибрана тека вже містить файл \'daily_you.db\', він перезапише існуючі записи в журналі!';

  @override
  String get errorTitle => 'Помилка';

  @override
  String get logFolderErrorDescription =>
      'Не вдалось змінити теку для записів!';

  @override
  String get imageFolderErrorDescription =>
      'Не вдалось змінити теку для світлин!';

  @override
  String get backupErrorDescription => 'Не вдалось створити резервну копію!';

  @override
  String get restoreErrorDescription => 'Не вдалось відновити резервну копію!';

  @override
  String get settingsBackupRestoreTitle => 'Резервне копіювання та відновлення';

  @override
  String get settingsBackup => 'Резервна копія';

  @override
  String get settingsRestore => 'Відновити резервну копію';

  @override
  String get settingsRestorePromptDescription =>
      'Відновлення резервної копії перезапише всі дані!';

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
    return 'Обробка… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Створення резервної копії… $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Відновлення із резервної копії… $percent%';
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
  String get cleanUpStatus => 'Замітаємо сліди…';

  @override
  String migratingImagesStatus(Object current, Object total) {
    return 'Migrating photos… $current/$total';
  }

  @override
  String get settingsExport => 'Експорт';

  @override
  String get settingsExportToAnotherFormat => 'Експорт в інший формат';

  @override
  String get settingsExportFormatDescription =>
      'Це не слід використовувати як резервний варіант!';

  @override
  String get exportLogs => 'Експортувати записи';

  @override
  String get exportImages => 'Експортувати світлини';

  @override
  String get settingsImport => 'Імпорт';

  @override
  String get settingsImportFromAnotherApp => 'Імпорт з іншої програми';

  @override
  String get settingsTranslateCallToAction =>
      'Кожен повинен мати доступ до щоденника!';

  @override
  String get settingsHelpTranslate => 'Допомога з перекладом';

  @override
  String get importLogs => 'Імпортувати записи';

  @override
  String get importImages => 'Імпортувати світлини';

  @override
  String get logFormatTitle => 'Оберіть тип файлу';

  @override
  String get logFormatDescription =>
      'Формат іншої програми може не підтримувати всі функції. Будь ласка, повідомляйте про будь-які проблеми, оскільки формати сторонніх розробників можуть змінитися будь-коли. Це не вплине на існуючі журнали!';

  @override
  String get formatDailyYouJson => 'Daily You (JSON)';

  @override
  String get formatDaybook => 'Щоденник';

  @override
  String get formatDaylio => 'Daylio';

  @override
  String get formatDiarium => 'Diarium';

  @override
  String get formatDiaro => 'Діаро';

  @override
  String get formatMyBrain => 'My Brain';

  @override
  String get formatOneShot => 'OneShot';

  @override
  String get formatPixels => 'Pixels';

  @override
  String get formatMarkdown => 'Markdown';

  @override
  String get settingsDeleteAllLogsTitle => 'Видалити всі записи';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Ви дійсно хочете видалити ВСІ записи журналу?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Введіть \'$prompt\' для підтвердження. Назад шляху вже не буде!';
  }

  @override
  String get settingsLanguageTitle => 'Мова';

  @override
  String get settingsAppLanguageTitle => 'Мова програми';

  @override
  String get settingsOverrideAppLanguageTitle => 'Перевизначити мову програми';

  @override
  String get settingsSecurityTitle => 'Безпека';

  @override
  String get settingsSecurityRequirePassword => 'Вимагати пароль';

  @override
  String get settingsSecurityEnterPassword => 'Введіть пароль';

  @override
  String get settingsSecuritySetPassword => 'Встановити пароль';

  @override
  String get settingsSecurityChangePassword => 'Змінити пароль';

  @override
  String get settingsSecurityPassword => 'Пароль';

  @override
  String get settingsSecurityConfirmPassword => 'Підтвердьте пароль';

  @override
  String get settingsSecurityOldPassword => 'Старий пароль';

  @override
  String get settingsSecurityIncorrectPassword => 'Неправильний пароль';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'Паролі не збігаються';

  @override
  String get requiredPrompt => 'Обов\'язково';

  @override
  String get settingsSecurityBiometricUnlock => 'Біометричне розблокування';

  @override
  String get unlockAppPrompt => 'Розблокувати додаток';

  @override
  String get settingsAboutTitle => 'Про нас';

  @override
  String get settingsVersion => 'Версія';

  @override
  String get settingsLicense => 'Ліцензія';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsSourceCode => 'Вихідний код';

  @override
  String get settingsOpenSourceLicenses => 'Open Source Licenses';

  @override
  String get settingsMadeWithLove => 'Зроблено з ❤️';

  @override
  String get settingsConsiderSupporting => 'розглянути можливість підтримки';

  @override
  String get imagesTitle => 'Images';

  @override
  String get tagMoodTitle => 'Настрій';

  @override
  String get calendarTagDisplayLabel => 'Tag';

  @override
  String get selectTagTitle => 'Select Tag';

  @override
  String get labelPresentLabel => 'Present';

  @override
  String get labelAbsentLabel => 'Absent';

  @override
  String get labelCoverageLabel => 'Coverage';

  @override
  String chartDistributionTitle(Object tag) {
    return '$tag Distribution';
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
}
