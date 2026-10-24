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
  String get themeColorTitle => 'Колір теми';

  @override
  String get themeColorHint => 'Виберіть колір для цієї палітри.';

  @override
  String get themeColorBlue => 'Небесно-блакитний';

  @override
  String get themeColorGreen => 'Ліс зелений';

  @override
  String get themeColorBrown => 'Тепла кава';

  @override
  String get themeColorPurple => 'Лаванда';

  @override
  String get themeColorRose => 'Запорошена троянда';

  @override
  String get themeColorAmber => 'Бурштин';

  @override
  String get themeColorPreview => 'Кожен день потроху';

  @override
  String get themeTintBackgroundTitle => 'Відтінок фону кольором теми';

  @override
  String get themeTintBackgroundHint =>
      'Вимкніть для нейтрально-сірого фону; кнопки зберігають обраний вами колір.';

  @override
  String get dailyReminderTitle => 'Напиши про день!';

  @override
  String get dailyReminderDescription => 'Час написати про сьогодні…';

  @override
  String get actionTakePhoto => 'Зробити фото';

  @override
  String get flashbacksTitle => 'Спогади';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Виключити погані дні';

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
      'Якщо ви використовуєте мережеве сховище, перевірте інтернет і доступ до сервісу сховища.\n\nТакож застосунок могла втратити дозволи на доступ до зовнішньої теки. Перейдіть до налаштувань і знову виберіть зовнішню теку, щоб надати до неї доступ.\n\nУвага, зміни не будуть синхронізовані, доки ви не відновите доступ до зовнішнього сховища!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Використовувати натомість локальне сховище';

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
  String get calendarSystemJalali => 'Джалалі';

  @override
  String get settingsUseSystemAccentColor =>
      'Використовувати колір акценту як в системі';

  @override
  String get settingsCustomAccentColor => 'Обрати свій колір акценту';

  @override
  String get settingsShowFlashbacks => 'Показати флешбеки';

  @override
  String get settingsChangeMoodIcons => 'Змініть емоджи настроїв';

  @override
  String get moodIconPrompt => 'Введіть іконку (емоджи)';

  @override
  String get settingsHideImages => 'Сховати зображення';

  @override
  String get pageCalendarTitle => 'Календар';

  @override
  String get settingsNotificationsTitle => 'Нагадування';

  @override
  String get settingsDailyReminderTitle => 'Кожноденне нагадування';

  @override
  String get settingsOnThisDayDescription => 'Перегляньте минулі спогади';

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
  String get manageTemplates => 'Керувати шаблонами';

  @override
  String get noTemplateTitle => 'Порожній';

  @override
  String get noTemplatesDescription => 'Жодного шаблону немає…';

  @override
  String get templateDefaultTimestampTitle => 'Мітка часу';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Підсумок дня';

  @override
  String get templateDefaultSummaryBody => '### Резюме\n- \n\n### Цитата\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Рефлексія';

  @override
  String get templateDefaultReflectionBody =>
      '### Що вам сподобалося сьогодні?\n- \n\n### За що ти вдячний?\n- \n\n### Чого ти чекаєш?\n- ';

  @override
  String get settingsTagsTitle => 'Теги';

  @override
  String get manageTags => 'Керування тегами';

  @override
  String get tagTypeLabelTitle => 'Мітка';

  @override
  String get tagTypeTrackerTitle => 'Трекер';

  @override
  String get nameHint => 'Ім\'я';

  @override
  String get tagColorLabel => 'колір';

  @override
  String get iconPickerTitle => 'Виберіть значок';

  @override
  String get iconPickerIconsTab => 'Ікони';

  @override
  String get iconPickerCustomTab => 'Власні';

  @override
  String get iconPickerSearchHint => 'Значки пошуку…';

  @override
  String get colorPickerTitle => 'Виберіть колір';

  @override
  String get colorPickerPaletteTab => 'Кольори';

  @override
  String get iconGroupMoodPeople => 'Настрій і люди';

  @override
  String get iconGroupHealth => 'Здоров\'я';

  @override
  String get iconGroupWorkFinance => 'Робота та фінанси';

  @override
  String get iconGroupHabitsGoals => 'Звички та цілі';

  @override
  String get iconGroupNature => 'природа';

  @override
  String get iconGroupFoodDrink => 'Їжа та напої';

  @override
  String get iconGroupHome => 'додому';

  @override
  String get iconGroupTravel => 'Подорожі';

  @override
  String get iconGroupSymbols => 'Символи';

  @override
  String get tagCategoryLabel => 'Категорія';

  @override
  String get tagLabel => 'Тег';

  @override
  String get tagCategoryUncategorized => 'Без категорії';

  @override
  String get newCategoryTitle => 'Нова категорія';

  @override
  String get shareButtonLabel => 'Поділіться';

  @override
  String get importErrorDescription => 'Не вдалося імпортувати файл!';

  @override
  String get exportErrorDescription => 'Не вдалося експортувати файл!';

  @override
  String get deleteTitle => 'Видалити';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Використовується в щоденникових записах $count.',
      one: ' Використано в $count щоденниковому записі.',
      many: ' Використовується в $count щоденникових записах.',
      few: ' Використано у $count щоденникових записах.',
      zero: '',
    );
    return 'Видалити \"$name\"?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Його теги $count також буде видалено.',
      one: ' Його $count тег також буде видалено.',
      many: ' Його теги $count також буде видалено.',
      few: ' Також буде видалено $count його теги.',
      zero: '',
    );
    return 'Видалити \"$name\"?$_temp0';
  }

  @override
  String get tagNameExists => 'Тег із такою назвою вже є';

  @override
  String get categoryNameExists => 'Категорія з такою назвою вже існує';

  @override
  String deleteTemplateMessage(Object name) {
    return 'Видалити \"$name\"?';
  }

  @override
  String get addTagsTitle => 'Додайте теги';

  @override
  String get addTagsSearchHint => 'Шукати теги…';

  @override
  String get tagFavoriteName => 'улюблений';

  @override
  String get iconGroupActivities => 'Діяльність';

  @override
  String get iconGroupHobbies => 'Розваги';

  @override
  String get settingsStorageTitle => 'Сховище';

  @override
  String get settingsLogFolder => 'Тека для записів';

  @override
  String get settingsImageFolder => 'Тека для світлин';

  @override
  String get warningTitle => 'Увага';

  @override
  String get logFolderWarningDescription =>
      'Якщо вибрана тека вже містить файл \'aid_diary.db\', він перезапише існуючі записи в журналі!';

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
  String get settingsBackupPasswordProtect => 'Захист паролем резервних копій';

  @override
  String get backupEncryptedTitle => 'Зашифроване резервне копіювання';

  @override
  String get backupEncryptedContent => 'Ця резервна копія захищена паролем.';

  @override
  String get settingsAutoBackup => 'Автоматичне резервне копіювання';

  @override
  String get settingsAutoBackupLocation => 'Розташування резервної копії';

  @override
  String get settingsAutoBackupInterval => 'Інтервал резервного копіювання';

  @override
  String get settingsAutoBackupIntervalDaily => 'Щодня';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Щотижня';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Щомісяця';

  @override
  String get settingsAutoBackupMaxCount => 'Резервні копії для збереження';

  @override
  String get settingsAutoBackupRequireCharging => 'Тільки під час зарядки';

  @override
  String settingsBackupLast(Object time) {
    return 'Остання резервна копія $time';
  }

  @override
  String get settingsBackupNever =>
      'Резервне копіювання ніколи не створювалося';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Наступна резервна копія $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'все';

  @override
  String get autoBackupFailedTitle => 'Помилка резервного копіювання';

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
    return 'Шифрування резервної копії… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Розшифровка резервної копії… $percent%';
  }

  @override
  String get cleanUpStatus => 'Замітаємо сліди…';

  @override
  String get settingsExportToAnotherFormat => 'Експорт в інший формат';

  @override
  String get settingsExportFormatDescription =>
      'Це не слід використовувати як резервний варіант!';

  @override
  String get settingsImportFromAnotherApp => 'Імпорт з іншої програми';

  @override
  String get logFormatTitle => 'Оберіть тип файлу';

  @override
  String get logFormatDescription =>
      'Формат іншої програми може не підтримувати всі функції. Будь ласка, повідомляйте про будь-які проблеми, оскільки формати сторонніх розробників можуть змінитися будь-коли. Це не вплине на існуючі журнали!';

  @override
  String get formatDayOne => 'Day One';

  @override
  String get formatDaybook => 'Щоденник';

  @override
  String get formatDaylio => 'Daylio';

  @override
  String get formatDiarium => 'Diarium';

  @override
  String get formatDiaro => 'Діаро';

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
  String get settingsDeleteAllLogsTitle => 'Видалити всі записи';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Ви дійсно хочете видалити ВСІ записи журналу?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Введіть \'$prompt\' для підтвердження. Назад шляху вже не буде!';
  }

  @override
  String get settingsAppLanguageTitle => 'Мова програми';

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
  String get settingsOpenSourceLicenses => 'Ліцензії з відкритим кодом';

  @override
  String get tagMoodTitle => 'Настрій';

  @override
  String get selectTagTitle => 'Виберіть Тег';

  @override
  String get labelPresentLabel => 'присутній';

  @override
  String get labelAbsentLabel => 'Відсутній';

  @override
  String get labelCoverageLabel => 'Покриття';

  @override
  String chartDistributionTitle(Object tag) {
    return 'Розподіл $tag';
  }

  @override
  String get shareAddToLogPickerTitle => 'Виберіть запис у щоденнику';

  @override
  String get adaptiveEmptyDay => 'На цей день ще немає записів';

  @override
  String get adaptiveNewEntry => 'Напишіть запис';

  @override
  String get pageJournalTitle => 'журнал';

  @override
  String get coachPrompt1 => 'Що змусило тебе посміхнутися сьогодні?';

  @override
  String get coachPrompt2 => 'Що ти навчився сьогодні?';

  @override
  String get coachPrompt3 => 'З ким ти сьогодні спілкувався, і як це було?';

  @override
  String get coachPrompt4 => 'За що ти зараз вдячний?';

  @override
  String get coachPrompt5 => 'Що сьогодні забрало у вас найбільше енергії?';

  @override
  String get coachPrompt6 =>
      'Опишіть маленький момент, який ви хочете запам\'ятати.';

  @override
  String get coachPrompt7 => 'Що може зробити завтрашній день хорошим?';

  @override
  String get coachPrompt8 => 'Що у вас на думці останнім часом?';

  @override
  String get coachPrompt9 => 'Що ти зробив сьогодні тільки для себе?';

  @override
  String get coachPrompt10 =>
      'Якби сьогоднішній день мав назву, якою б вона була?';

  @override
  String get pageMediaTitle => 'ЗМІ';

  @override
  String get pageAtlasTitle => 'Атлас';

  @override
  String get pageCoachTitle => 'тренер';

  @override
  String get noEntrySelected => 'Запис не вибрано.';

  @override
  String get entryShare => 'Поділіться';

  @override
  String get entryFavorite => 'зірка';

  @override
  String get entryEdit => 'Редагувати';

  @override
  String get entryPrevious => 'Попередній запис';

  @override
  String get entryNext => 'Наступний запис';

  @override
  String get journalStories => 'оповідання';

  @override
  String get journalEntries => 'Записи';

  @override
  String get journalEmptyHint => 'Почніть свій щоденник, додавши новий запис.';

  @override
  String get storyToday => 'Сьогодні';

  @override
  String get storyThrowback => 'Повернення';

  @override
  String get storyNoThrowback => 'Сьогодні без повернення';

  @override
  String get mediaFiles => 'Медіафайли';

  @override
  String get mediaEmpty => 'Фото ще немає.';

  @override
  String get mediaEmptyHint =>
      'Тут відображатимуться фотографії, додані до записів.';

  @override
  String get atlasEmpty => 'Немає записів із місцезнаходженням.';

  @override
  String get atlasEmptyHint =>
      'Тут відображатимуться записи з місцезнаходженням.';

  @override
  String get atlasShowAll => 'Показати всі записи';

  @override
  String get atlasMyLocation => 'Моє місцезнаходження';

  @override
  String get coachAll => 'все';

  @override
  String get coachPrograms => 'Програми';

  @override
  String get coachTemplates => 'Шаблони';

  @override
  String get coachKindProgram => 'програма';

  @override
  String get coachKindTemplate => 'Шаблон';

  @override
  String get coachNoTemplates => 'Без програм і шаблонів.';

  @override
  String get coachUseTemplate => 'Напишіть за цим шаблоном';

  @override
  String get coachProgramEverydayTitle => 'Повсякденні моменти';

  @override
  String get coachProgramEverydayDescription =>
      'П\'ять коротких запитань, по одному на день. Кожна з них займає хвилину-дві та допомагає вам побачити, чим цей день був вашим. М’який спосіб виробити звичку писати потроху щодня.';

  @override
  String get coachProgramReflectTitle => 'Дивлячись всередину';

  @override
  String get coachProgramReflectDescription =>
      'Одне глибше запитання на тиждень протягом п’яти тижнів. Не поспішайте з кожним: як ви себе почуваєте, що вас втомлює, за що ви вдячні.';

  @override
  String get searchFilters => 'Фільтри';

  @override
  String get searchFilterTags => 'Теги';

  @override
  String get searchFilterStarred => 'Позначено зірочкою';

  @override
  String get searchHint => 'Введіть для пошуку або виберіть фільтр.';

  @override
  String get locationTitle => 'Розташування';

  @override
  String get locationName => 'Назва місця';

  @override
  String get locationRemove => 'видалити';

  @override
  String get locationServiceDisabled => 'Служби локації вимкнено.';

  @override
  String get locationPermissionDenied =>
      'У дозволі на місцезнаходження відмовлено.';

  @override
  String get locationUnavailable =>
      'Не вдалося отримати поточне місцезнаходження.';

  @override
  String get calendarJumpToToday => 'Перейти до сьогоднішнього дня';

  @override
  String get editorStartWriting => 'Почніть писати або виберіть a ';

  @override
  String get editorTemplateLink => 'Шаблон';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Виберіть шаблон';

  @override
  String get templateFeatured => 'Популярні шаблони';

  @override
  String get templateMine => 'Мої шаблони';

  @override
  String get templateDailyName => 'Щоденний огляд';

  @override
  String get templateDailyDescription =>
      'Що сталося, як це було, і що буде далі.';

  @override
  String get templateDailyText =>
      '## Що сталося сьогодні\n\n\n## Як я почувався\n\n\n## Три речі, за які я вдячний\n1. \n2. \n3. \n\n## Завтра\n';

  @override
  String get templateTravelName => 'Запис у щоденнику подорожі';

  @override
  String get templateTravelDescription => 'Місця, моменти та їжа з дороги.';

  @override
  String get templateTravelText =>
      '## Куди я пішов\n\n\n## Момент, який мені найбільше запам\'ятався\n\n\n## Що я їв\n\n\n## Плани на завтра\n';

  @override
  String get templateReadingName => 'Читання нот';

  @override
  String get templateReadingDescription => 'Цитати та думки з прочитаного.';

  @override
  String get templateReadingText =>
      '## Книга\n\n\n## Де я\n\n\n## Цитати\n> \n\n## Мої думки\n';

  @override
  String get templateWeeklyName => 'Щотижневий огляд';

  @override
  String get templateWeeklyDescription =>
      'Основні моменти, труднощі та фокус наступного тижня.';

  @override
  String get templateWeeklyText =>
      '## Основні моменти\n\n\n## Що було важко\n\n\n## Чого я навчився\n\n\n## Зосередьтеся на наступному тижні\n';

  @override
  String get entrySaveAsTemplate => 'Зберегти як шаблон';

  @override
  String get entrySavedAsTemplate => 'Збережено як шаблон';

  @override
  String get storyStatistics => 'Статистика';

  @override
  String get storyMoodChart => 'Діаграма настрою';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return '$entries записів · $days днів';
  }

  @override
  String get storyThisYear => 'Цього року';

  @override
  String get storyLastYear => 'Минулого року';

  @override
  String get storyTapToOpen => 'Торкніться дня, щоб відкрити його';

  @override
  String get settingsGeneralTitle => 'Загальний';

  @override
  String get settingsDataTitle => 'Дані та зберігання';

  @override
  String get settingsStoriesTitle => 'оповідання';

  @override
  String get settingsHelpTitle => 'Допомога та про';

  @override
  String get weatherTitle => 'Погода';

  @override
  String get weatherClear => 'ясно';

  @override
  String get weatherPartlyCloudy => 'Мінлива хмарність';

  @override
  String get weatherCloudy => 'Хмарно';

  @override
  String get weatherFog => 'Туман';

  @override
  String get weatherDrizzle => 'Дощ';

  @override
  String get weatherRain => 'Дощ';

  @override
  String get weatherSnow => 'сніг';

  @override
  String get weatherStorm => 'гроза';

  @override
  String get weatherFetch => 'Отримати погоду для цього запису';

  @override
  String get weatherNeedsLocation =>
      'Спочатку додайте місцезнаходження з координатами.';

  @override
  String get weatherUnavailable => 'Погода недоступна для цього місця та часу.';

  @override
  String get weatherRemove => 'Зняти погоду';

  @override
  String get activityTitle => 'діяльність';

  @override
  String get activityStill => 'досі';

  @override
  String get activityWalking => 'ходьба';

  @override
  String get activityRunning => 'Біг';

  @override
  String get activityCycling => 'Велоспорт';

  @override
  String get activityVehicle => 'У транспортному засобі';

  @override
  String get activityFlying => 'політ';

  @override
  String get activityExercise => 'вправи';

  @override
  String get activityDetect => 'Визначити поточну активність';

  @override
  String get activityDetectFailed => 'Не вдалося виявити активність.';

  @override
  String get activityRemove => 'Видалити активність';

  @override
  String get settingsAutoAddTitle => 'Додати автоматично';

  @override
  String get settingsAutoAddLocation => 'Розташування';

  @override
  String get settingsAutoAddWeather => 'Погода';

  @override
  String get settingsAutoAddHint =>
      'Нові записи заповнюються під час їх створення.';

  @override
  String get settingsTemperatureUnit => 'Одиниця вимірювання температури';

  @override
  String get settingsCelsius => 'Цельсій (°C)';

  @override
  String get settingsFahrenheit => 'Фаренгейт (°F)';

  @override
  String get moodGreat => 'чудово';

  @override
  String get moodGood => 'добре';

  @override
  String get moodOkay => 'Гаразд';

  @override
  String get moodBad => 'погано';

  @override
  String get moodAwful => 'Жахливо';

  @override
  String get locationSearchHint => 'Пошук місця';

  @override
  String get locationSearchEmpty => 'Місця не знайдено';

  @override
  String get settingsWallpaper => 'Шпалери';

  @override
  String get wallpaperNone => 'Жодного';

  @override
  String get wallpaperDots => 'Крапки';

  @override
  String get wallpaperGrid => 'Сітка';

  @override
  String get wallpaperLines => 'Лінії';

  @override
  String get wallpaperPhoto => 'Фото…';

  @override
  String get settingsFontFamily => 'Шрифт';

  @override
  String get fontSystem => 'система';

  @override
  String get fontSerif => 'Із засічками';

  @override
  String get fontMono => 'Моноширинні';

  @override
  String get settingsFontSize => 'Розмір шрифту';

  @override
  String get fontSizeSmall => 'Маленький';

  @override
  String get fontSizeMedium => 'Середній';

  @override
  String get fontSizeLarge => 'Великий';

  @override
  String get fontSizeExtraLarge => 'Дуже великий';

  @override
  String get settingsLineSpacing => 'Міжрядковий інтервал';

  @override
  String get lineSpacingCompact => 'Компактний';

  @override
  String get lineSpacingNormal => 'нормальний';

  @override
  String get lineSpacingRelaxed => 'Розслаблений';

  @override
  String get moodAssociationsTitle => 'Що змушує мене відчувати…';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching із записів $total';
  }

  @override
  String get videoRecord => 'Записати відео';

  @override
  String get videoChoose => 'Виберіть відео';

  @override
  String get audioRecordTitle => 'Запишіть голосову нотатку';

  @override
  String get audioChoose => 'Виберіть аудіофайл';

  @override
  String get audioStart => 'запис';

  @override
  String get audioStop => 'Зупинись і збережи';

  @override
  String get audioPermissionDenied =>
      'Доступ до мікрофона вимкнено. Дозвольте це в налаштуваннях системи.';

  @override
  String get mediaTooLarge => 'Це відео завелике для прикріплення.';

  @override
  String get mediaUnavailable => 'Це вкладення недоступне на цьому пристрої.';

  @override
  String get widgetDone => 'Сьогоднішній запис написаний';

  @override
  String get widgetPending => 'Як пройшов день?';

  @override
  String get widgetWrite => 'Напишіть';

  @override
  String get insertChecklist => 'Контрольний список';

  @override
  String get insertNumberedList => 'Нумерований список';

  @override
  String get insertTable => 'Таблиця';

  @override
  String get insertDivider => 'Роздільник';

  @override
  String get insertCodeBlock => 'Кодовий блок';

  @override
  String get journalSortTitle => 'Сортування записів';

  @override
  String get journalSortUpdated => 'Останнє оновлення';

  @override
  String get settingsTimeFormat => 'Формат часу';

  @override
  String get settingsDayStart =>
      'Нові записи враховуються за попередній день до';

  @override
  String get settingsDayAskUntil => 'Потім запитайте, до якого дня';

  @override
  String get settingsDayStartMidnight => 'Вимкнено';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Кожен запис зберігає день, до якого він належить, поруч із часом його написання, і ви можете будь-коли змінити цей день у редакторі. Ці години вибирають лише день для нових записів, тому зміна їх не переміщує існуючі записи.';

  @override
  String get lateNightBadge => 'Писали пізно ввечері, рахували за напередодні';

  @override
  String editorDayAsk(String time) {
    return 'Написано на $time. На який день це?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (вчора)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (сьогодні)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'Написано $when';
  }

  @override
  String get timeFormat12 => '12-годинний';

  @override
  String get timeFormat24 => '24 години';

  @override
  String get settingsReminderDays => 'Нагадати мені';

  @override
  String get locationRecent => 'Останні місця';

  @override
  String get shareImage => 'Поділіться зображенням';

  @override
  String get shareSaveImage => 'Зберегти зображення';

  @override
  String get shareSaved => 'Зображення збережено';

  @override
  String get deletedTitle => 'Нещодавно видалено';

  @override
  String get deletedNone => 'Останнім часом нічого не видалено';

  @override
  String deletedHint(int days) {
    return 'Видалені записи залишаються тут протягом $days днів, а потім стираються.';
  }

  @override
  String deletedDaysLeft(int days) {
    return 'Залишилося $days днів';
  }

  @override
  String get deletedRestore => 'Відновити';

  @override
  String get deletedDeleteForever => 'Видалити назавжди';

  @override
  String get deletedDeleteForeverDescription =>
      'Запис і додатки до нього видаляються. Це неможливо скасувати.';

  @override
  String get deletedEmpty => 'Порожній';

  @override
  String get deletedEmptyDescription =>
      'Видалити всі записи в Нещодавно видалено? Це неможливо скасувати.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Випадкове блукання';

  @override
  String get randomSubtitle => 'Відкрийте попередній запис';

  @override
  String get randomNext => 'інший';

  @override
  String get randomAll => 'все';

  @override
  String get randomWithPhotos => 'З фотографіями';

  @override
  String get randomGoodDays => 'Добрих днів';

  @override
  String get randomEmpty => 'Немає записів для вибору';

  @override
  String get reviewWeekTitle => 'Цього тижня';

  @override
  String get reviewWeekSubtitle => 'Ваш тиждень на даний момент';

  @override
  String get reviewYearTitle => 'Цього року';

  @override
  String get reviewEmpty => 'Ще нічого не написано';

  @override
  String get reviewEntries => 'Записи';

  @override
  String get reviewDaysWritten => 'Написані дні';

  @override
  String get reviewWords => 'Слова';

  @override
  String get reviewPhotos => 'Фотографії';

  @override
  String get reviewLongestRun => 'Найдовша кількість днів';

  @override
  String get reviewAverageMood => 'Середній настрій';

  @override
  String get reviewFavorites => 'Найчастіше';

  @override
  String get reviewByMonth => 'По місяцях';

  @override
  String get reviewHighlight => 'Виділіть';

  @override
  String get yearInPixels => 'Рік у пікселях';

  @override
  String get capsuleSeal => 'Запечатайте як капсулу часу';

  @override
  String get capsuleTitle => 'Капсула часу';

  @override
  String capsuleOpensOn(Object date) {
    return 'Відкривається на $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Написано на $date';
  }

  @override
  String get capsuleOpenEarly => 'Рано відкривається';

  @override
  String get capsuleOpenEarlyDescription =>
      'Капсула відкривається і залишається відкритою.';

  @override
  String get capsuleOpened => 'Капсула часу відкрита';

  @override
  String get templateMorningName => 'Ранкові сторінки';

  @override
  String get templateMorningDescription => 'Організуйте день за три хвилини';

  @override
  String get templateMorningText =>
      '## Три речі, які я хочу сьогодні зробити добре\n1. \n2. \n3. \n\n## Те, чого я з нетерпінням чекаю\n\n## Замітка для себе\n';

  @override
  String get templateEveningName => 'Вечірній огляд';

  @override
  String get templateEveningDescription =>
      'Завершіть день тим, що пройшло добре';

  @override
  String get templateEveningText =>
      '## Три хороші речі сьогодні\n1. \n2. \n3. \n\n## Чого я навчився\n\n## Що може бути краще завтра\n';

  @override
  String get routineMorning => 'доброго ранку';

  @override
  String get routineEvening => 'Вечірній огляд';

  @override
  String get settingsRoutinePrompts => 'Ранкові та вечірні підказки';

  @override
  String get settingsRoutinePromptsHint =>
      'Запропонуйте ранковий або вечірній шаблон в Stories';

  @override
  String get checkInTitle => 'Швидкий заїзд';

  @override
  String get checkInSubtitle => 'Настрій у два крани';

  @override
  String get checkInMood => 'як почуваєшся';

  @override
  String get checkInActivity => 'що ти робиш';

  @override
  String get checkInNote => 'Рядок про це (необов\'язково)';

  @override
  String get checkInSave => 'зберегти';

  @override
  String editorWordCount(int words, int characters) {
    return '$words слова · $characters символи';
  }

  @override
  String get coachProgramEverydayTagline => 'Помічайте дрібниці дня.';

  @override
  String get coachProgramReflectTagline =>
      'Уповільніть темп і прислухайтеся до себе.';

  @override
  String get coachDuration => 'Тривалість';

  @override
  String get coachInterval => 'Інтервал';

  @override
  String get coachDifficulty => 'Складність';

  @override
  String get coachIntervalDaily => 'Щодня';

  @override
  String get coachIntervalWeekly => 'Щотижня';

  @override
  String get coachDifficultyBeginner => 'Початківець';

  @override
  String get coachDifficultyIntermediate => 'Проміжний';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня',
      one: '$count день',
      many: '$count днів',
      few: '$count дні',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count тижня',
      one: '$count тиждень',
      many: '$count тижнів',
      few: '$count тижні',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'День $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Тиждень $n';
  }

  @override
  String get coachEnroll => 'Зареєструватися';

  @override
  String get coachEndProgram => 'Завершити програму';

  @override
  String get coachAuthor => 'автор';

  @override
  String get coachAuthorBio => 'Підказки, написані для цієї програми.';

  @override
  String get coachEnrolledTip =>
      'Все готово! Ваші запитання з’являться в Stories.';

  @override
  String get coachGoToStories => 'Перейдіть до Stories';

  @override
  String get coachAnswerHint => 'Напишіть свою відповідь…';

  @override
  String get storyWrapUp => 'На сьогодні все.';

  @override
  String get storyTapToClose => 'Торкніться, щоб закрити';

  @override
  String get coachAnswerDone => 'Готово';

  @override
  String get coachAnswered => 'Відповіли, торкніться, щоб відкрити';

  @override
  String get coachAnsweredEarlier => 'відповів';

  @override
  String get locationLocating => 'Пошук...';

  @override
  String get locationPickPlace => 'Виберіть місце';

  @override
  String get locationPlacesHint => 'Адреса або назва місця';

  @override
  String get locationCustom => 'Спеціальне місце';

  @override
  String get locationCurrent => 'Поточне місцезнаходження';

  @override
  String get locationSaved => 'Збережені місця';

  @override
  String get locationSearchResults => 'Результати пошуку';

  @override
  String get locationNearby => 'Місця поблизу';

  @override
  String get locationRename => 'Перейменувати';

  @override
  String get locationSavePlace => 'Зберегти місце';

  @override
  String get locationUnsavePlace => 'Видалити зі збережених місць';

  @override
  String get shareAs => 'Поділитися як…';

  @override
  String get shareAsImage => 'Зображення';

  @override
  String get shareAsZip => 'ZIP з оригінальним носієм';

  @override
  String get shareAsPlainText => 'Звичайний текст';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Ласкаво просимо до AID Diary';

  @override
  String get onboardWelcomeText =>
      'Почніть тут або підключіть цей пристрій до того, яким ви вже користуєтеся.';

  @override
  String get onboardStart => 'Почніть писати';

  @override
  String get helpFaq => 'Часті запитання';

  @override
  String get helpFaq1Q => 'Де зберігається мій щоденник?';

  @override
  String get helpFaq1A =>
      'Ваш щоденник зберігається на цьому пристрої. Він потрапляє на інші пристрої чи пам’ять лише тоді, коли ви вмикаєте синхронізацію, надаєте спільний доступ або експортуєте його. Синхронізація має наскрізне шифрування.';

  @override
  String get helpFaq2Q => 'Як зберегти копію чи перенести на новий пристрій?';

  @override
  String get helpFaq2A =>
      'Підключіться до наявного пристрою в Налаштуваннях → Дані та зберігання → Синхронізація та підтвердьте авторизацію на пристрої, на якому зберігається ваш щоденник. Обидва пристрої залишаються придатними для використання. Ви також можете створити резервну копію та відновити її на іншому пристрої.';

  @override
  String get helpFaq3Q => 'Чи можу я додати записи з інших програм щоденника?';

  @override
  String get helpFaq3A =>
      'Так: у Налаштуваннях → Дані та сховище імпортуйте експорт із Daylio, Diarium, Diaro, DayBook, My Brain, OneShot і Pixels або експорт JSON.';

  @override
  String get helpFaq4Q => 'Як працюють тренерські програми?';

  @override
  String get helpFaq4A =>
      'Зареєструйтеся в програмі на сторінці тренера. Щодня чи тижня в Stories чекає нове запитання; ваша відповідь буде збережена як запис.';

  @override
  String get helpFaq5Q => 'Що робити, якщо я забуду свій пароль?';

  @override
  String get helpFaq5A =>
      'Пароль не можна відновити, тому зробіть резервну копію свого щоденника.';

  @override
  String get helpPrivacy => 'Конфіденційність';

  @override
  String get helpPrivacyText =>
      'Вміст щоденника та медіафайли залишаються на цьому пристрої, доки ви не ввімкнете зашифровану синхронізацію або не поділитеся/експортуєте їх. Карти, пошук місць і погода використовують налаштовані служби та надсилають запит про місцезнаходження або пошук, необхідний для цього запиту, а не текст щоденника.';

  @override
  String get photoMetaTitle => 'Використовувати деталі фото?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Розрахувати цей запис як $date і встановити його місце на $place, як записано на фото?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Зарахувати цей запис до $date, коли було зроблено фото?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Установити для цього запису місце $place, де було зроблено фотографію?';
  }

  @override
  String get photoMetaApply => 'Використовуйте їх';

  @override
  String get quickWriteTitle => 'Швидкий запис';

  @override
  String get quickWriteText => 'Натисніть, щоб почати новий запис.';

  @override
  String get settingsQuickWriteTitle => 'Швидкий запис у повідомленнях';

  @override
  String get settingsQuickWriteDescription =>
      'Зберігайте сповіщення про відкриття нового запису.';

  @override
  String get settingsNudgesTitle => 'Підштовхни мене після тихої розтяжки';

  @override
  String settingsNudgesDescription(int days) {
    return 'Ніжне нагадування, коли ви не писали протягом $days днів.';
  }

  @override
  String get nudgeTitle => 'Пройшов час';

  @override
  String get nudgeMonday => 'Новий тиждень: чого ти чекаєш?';

  @override
  String get nudgeTuesday => 'Двох рядків достатньо. Як справи сьогодні?';

  @override
  String get nudgeWednesday => 'Половина тижня. Що виділялося досі?';

  @override
  String get nudgeThursday => 'Щось дрібне, що варто залишити сьогодні?';

  @override
  String get nudgeFriday =>
      'Тиждень добігає кінця. Зверніть увагу на один хороший момент.';

  @override
  String get nudgeSaturday => 'Повільна субота — гарний день для писання.';

  @override
  String get nudgeSunday => 'Озирніться на тиждень до його закінчення.';

  @override
  String get photoWidgetEmpty =>
      'Фотографії, які ви додаєте до записів, відображаються тут.';

  @override
  String get channelReminders => 'Нагадування';

  @override
  String get channelOnThisDay => 'У цей день';

  @override
  String get channelCoach => 'Тренер підказує';

  @override
  String get channelNudges => 'Підштовхує після тихих днів';

  @override
  String get channelQuickWrite => 'Швидкий запис';

  @override
  String get channelBackup => 'Резервні копії';

  @override
  String get formatJsonExport => 'JSON (експорт AID Diary)';

  @override
  String get aboutModifiedNotice =>
      'Модифікована версія Daily You від Demizo та співавторів. Це не офіційний додаток Daily You.';

  @override
  String get toolbarPhotos => 'Додайте фотографії';

  @override
  String get toolbarMedia => 'Фото та відео';

  @override
  String get mediaFromGallery => 'Виберіть із галереї';

  @override
  String get mediaFromFiles => 'Виберіть із файлів';

  @override
  String get editorLeaveTitle => 'Зберегти цей запис?';

  @override
  String get editorLeaveDiscard => 'Не економте';

  @override
  String get editorTitleHint => 'Назва';

  @override
  String get editorLocating => 'Пошук...';

  @override
  String get toolbarVideo => 'відео';

  @override
  String get toolbarAudio => 'Голосова нотатка';

  @override
  String get toolbarTags => 'Теги';

  @override
  String get toolbarBulletList => 'Маркірований список';

  @override
  String get toolbarHeading => 'Заголовок';

  @override
  String get toolbarBold => 'жирний';

  @override
  String get toolbarItalic => 'Курсив';

  @override
  String get toolbarHighlight => 'Виділіть';

  @override
  String get toolbarStrikethrough => 'Закреслення';

  @override
  String get toolbarQuote => 'Цитата';

  @override
  String get toolbarLink => 'Посилання';

  @override
  String get toolbarInsert => 'Вставка';

  @override
  String get toolbarUndo => 'Скасувати';

  @override
  String get toolbarRedo => 'Повторити';

  @override
  String get toolbarInsertDate => 'Вставте дату';

  @override
  String get toolbarInsertTime => 'Вставте час';

  @override
  String get settingsSyncTitle => 'Хмарна синхронізація';

  @override
  String get syncOffDescription =>
      'Зберігайте цей щоденник однаковим на всіх своїх пристроях через Google Drive або сервер WebDAV, наприклад Nextcloud, Synology або Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'Синхронізувати з Google Drive';

  @override
  String get syncOrWebDav => 'Або сервер WebDAV';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn =>
      'Ви ввійшли. Ви можете повернутися до AID Diary.';

  @override
  String get syncGoogleSignInAgain => 'Google вимагає, щоб ви знову ввійшли.';

  @override
  String get syncSignInAgain => 'Увійдіть знову';

  @override
  String get settingsCommandLineTitle => 'Командний рядок';

  @override
  String get commandLineToggle => 'Інтерфейс командного рядка';

  @override
  String get commandLineToggleHint =>
      'Дозволяє команді допомоги та іншим програмам на цьому пристрої використовувати команди програми.';

  @override
  String get commandLineAlwaysOn => 'Завжди в розробці.';

  @override
  String commandLineListening(int port) {
    return 'Прослуховування на порту $port';
  }

  @override
  String get commandPaletteTitle => 'Всі команди';

  @override
  String get commandPaletteSearch => 'Команди пошуку';

  @override
  String get commandPaletteRun => 'бігти';

  @override
  String get commandPaletteConfirm =>
      'Це неможливо просто скасувати. Запустити?';

  @override
  String syncReceiving(int done, int total) {
    return 'Отримання $done з $total…';
  }

  @override
  String syncSending(int done, int total) {
    return 'Надсилання $done з $total…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'Доступ до Google Drive було заборонено. Знову підключіться та поставте прапорець Google Drive на сторінці Google.';

  @override
  String get syncEntryUnsynced =>
      'Не синхронізовано: остання синхронізація не пройшла';

  @override
  String get syncUseOfficial => 'Використовуйте сервер синхронізації AID';

  @override
  String get syncServer => 'Адреса сервера';

  @override
  String get syncUsername => 'Ім\'я користувача';

  @override
  String get syncPassword => 'Пароль';

  @override
  String get syncConnect => 'Підключитися';

  @override
  String get syncConnecting => 'Підключення…';

  @override
  String get syncSignInFailed =>
      'Не вдалося ввійти. Перевірте адресу, ім’я користувача та пароль.';

  @override
  String syncConnectFailed(String error) {
    return 'Не вдалося підключитися: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Почніть синхронізацію';

  @override
  String get syncNewSpaceDescription =>
      'Тут ще немає синхронізованого щоденника. Цей щоденник буде завантажено з наскрізним шифруванням за допомогою ключа, який залишиться на ваших пристроях.';

  @override
  String get syncJoinTitle => 'Приєднайтеся до синхронізованого щоденника';

  @override
  String get syncWrongKey =>
      'Цей код відновлення не відкриває синхронізований щоденник.';

  @override
  String syncLastSynced(String time) {
    return 'Остання синхронізація $time';
  }

  @override
  String get syncNever => 'Ще не синхронізовано';

  @override
  String get syncSyncing => 'Синхронізація…';

  @override
  String syncFailed(String error) {
    return 'Остання помилка синхронізації: $error';
  }

  @override
  String get syncLocked =>
      'Синхронізований щоденник тепер належить іншим пристроям або розпочато спочатку. Підключіться до одного з них або скористайтеся кодом відновлення, щоб продовжити синхронізацію.';

  @override
  String get syncNow => 'Синхронізувати зараз';

  @override
  String get syncUnlock => 'Розблокувати';

  @override
  String get syncEncrypted => 'Наскрізне шифрування';

  @override
  String get syncDisconnect => 'Зупинити синхронізацію';

  @override
  String get syncDisconnectDescription =>
      'Цей пристрій припиняє синхронізацію. Щоденник тут і синхронізована копія залишаються без змін.';

  @override
  String get syncOwnRecoveryPassword =>
      'Використовувати мій власний пароль відновлення';

  @override
  String get syncRecoveryPassword => 'Пароль відновлення';

  @override
  String get syncRecoveryPasswordRepeat => 'Повторіть пароль відновлення';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Використовуйте принаймні $min символів';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'Паролі відрізняються';

  @override
  String get syncRecoveryCode => 'Код відновлення';

  @override
  String get syncRecoveryCodeTitle => 'Збережіть свій код відновлення';

  @override
  String get syncRecoveryCodeDescription =>
      'Якщо кожен ваш пристрій буде втрачено, цей код відновить ваш синхронізований щоденник. Зберігайте його в менеджері паролів або на папері. Це показано лише один раз.';

  @override
  String get syncRecoveryCodeCopied => 'Код відновлення скопійовано';

  @override
  String get syncRecoveryCodeSaved => 'Я зберіг його';

  @override
  String get syncJoinNeedsKey =>
      'Цей синхронізований щоденник належить іншим вашим пристроям. Підключіться до одного з них або скористайтеся кодом відновлення. Записи на цьому пристрої будуть додані до нього.';

  @override
  String get syncPairDevice => 'Сполучення з пристроєм';

  @override
  String get syncUseRecoveryCode => 'Використовуйте код відновлення';

  @override
  String get syncAddDevice => 'Додайте пристрій';

  @override
  String get syncChangeRecoveryCode => 'Змініть код відновлення';

  @override
  String get syncChangeRecoveryDescription =>
      'Новий код замінює поточний, який перестає працювати. Ваші дані та інші пристрої залишаються без змін.';

  @override
  String get syncNewRandomCode => 'Новий випадковий код';

  @override
  String get syncRecoveryCodeChanged => 'Код відновлення змінено';

  @override
  String get syncResetSpace => 'Почніть синхронізований щоденник спочатку';

  @override
  String get syncResetSpaceDescription =>
      'Лише коли жоден пристрій і код відновлення більше не відкривають його: синхронізована копія замінюється щоденником на цьому пристрої під ключами цього пристрою. Потім ваші інші пристрої підключаються знову.';

  @override
  String get syncPairTitle => 'Сполучення пристроїв';

  @override
  String get syncPairShow => 'Покажіть код';

  @override
  String get syncPairEnter => 'Введіть код';

  @override
  String get syncPairShowHint =>
      'На іншому пристрої відкрийте «Пара пристроїв», виберіть «Введіть код» і введіть або відскануйте його.';

  @override
  String get syncPairEnterHint =>
      'Введіть код, який показує інший пристрій, або відскануйте його.';

  @override
  String get syncPairCode => 'Код сполучення';

  @override
  String get syncPairScan => 'Сканувати';

  @override
  String get syncPairStart => 'Пара';

  @override
  String get syncPairWaiting => 'Очікування іншого пристрою…';

  @override
  String syncPairDone(String device) {
    return 'У парі з $device';
  }

  @override
  String get syncPairWrongCode =>
      'Код не збігся. Покажіть новий код і повторіть спробу.';

  @override
  String get syncPairNoOffer =>
      'Цей код не відображається на жодному пристрої. Можливо, він закінчився.';

  @override
  String get syncPairTimedOut => 'Інший пристрій не відповів вчасно.';

  @override
  String get syncPairNeither =>
      'На жодному пристрої ще не налаштовано цей синхронізований щоденник.';

  @override
  String get syncPairBoth =>
      'Обидва пристрої вже відкривають цей синхронізований щоденник.';

  @override
  String syncPairFailed(String error) {
    return 'Не вдалося створити пару: $error';
  }

  @override
  String get syncMediaPending =>
      'Щоденник синхронізовано · деякі медіа все ще передаються';

  @override
  String get syncWaitingForDevices =>
      'Щоденник синхронізовано · очікується, поки інший пристрій передасть медіа';

  @override
  String get syncCacheNotice =>
      'Хмарні медіа тимчасові. Зберігайте оригінали на своїх пристроях; синхронізація не є резервною копією.';

  @override
  String get paperTitle => 'Листовий папір';

  @override
  String get paperPlain => 'Рівнина';

  @override
  String get paperLined => 'Підкладений';

  @override
  String get paperGrid => 'Сітка';

  @override
  String get paperTinted => 'Тонований';

  @override
  String get paperDecorationTitle => 'Прикраси';

  @override
  String get paperDecorationNone => 'Жодного';

  @override
  String get paperDecorationBotanical => 'листя';

  @override
  String get paperDecorationStars => 'Зірки';

  @override
  String get paperDecorationWashi => 'Стрічка васі';

  @override
  String get themeDarkChoice => 'Темний зовнішній вигляд';

  @override
  String get themeDarkSame => 'Дотримуйтесь світлої палітри';

  @override
  String get themeDarkCustom => 'Окрема палітра';

  @override
  String get themeDarkAccent => 'Темний акцентний колір';

  @override
  String get themeColorTeal => 'Чирок';

  @override
  String get themeColorCyan => 'Блакитний';

  @override
  String get themeColorIndigo => 'Індиго';

  @override
  String get themeColorCoral => 'Кораловий';

  @override
  String get themeColorOlive => 'Оливкова';

  @override
  String get themeColorSlate => 'Шифер';

  @override
  String get drawingTitle => 'Малювання';

  @override
  String get drawingPen => 'Перо';

  @override
  String get drawingEraser => 'Гумка';

  @override
  String get drawingUndo => 'Скасувати';

  @override
  String get drawingClear => 'ясно';

  @override
  String get drawingWidth => 'Ширина пера';

  @override
  String get drawingStylusOnly => 'Тільки стилус';

  @override
  String get drawingDiscardTitle => 'Відхилити малюнок?';

  @override
  String get drawingDiscardBody => 'Цей малюнок не збережено.';

  @override
  String get drawingSaveError => 'Не вдалося зберегти малюнок.';

  @override
  String get syncNetworkTitle => 'Діагностика мережі';

  @override
  String get syncNetworkRefresh => 'Оновити';

  @override
  String get syncNetworkSelectedRoute => 'Поточний шлях';

  @override
  String get syncNetworkAvailableRoutes => 'Доступні шляхи';

  @override
  String get syncNetworkSignaling => 'Підключення каталогу пристрою';

  @override
  String get syncNetworkRelayRemaining => 'Залишок надбавки на реле';

  @override
  String get syncNetworkIcePair => 'Кандидати на пряме підключення';

  @override
  String get syncNetworkPeerTrusted => 'Автентифікований пристрій';

  @override
  String get syncNetworkNoRoute => 'Очікування з\'єднання';

  @override
  String get syncNetworkUnavailable => 'Діагностика недоступна';

  @override
  String get syncMediaCopiesTitle => 'Доставка медіа та копій';

  @override
  String get syncMediaPendingCount => 'Очікування передачі';

  @override
  String get syncMediaDurableCount => 'Здано на особисте зберігання';

  @override
  String get syncMediaTemporaryCount => 'Тимчасові або непідтверджені копії';

  @override
  String get syncMediaReceiptExplanation =>
      'Ці підрахунки описують завершені поставки, а не новий аудит збережених резервних копій.';

  @override
  String get syncMediaCacheExplanation =>
      'Термін дії тимчасових хмарних носіїв може закінчитися. Зберігайте оригінали або окрему резервну копію.';

  @override
  String get momentsTitle => 'Фото моменти';

  @override
  String get momentsHint =>
      'Знайдіть групи, використовуючи місцевий час фото та додаткові координати. Фото додаються тільки при виборі картки.';

  @override
  String get momentsScan => 'Знайдіть моменти';

  @override
  String get momentsChooseFolder => 'Виберіть папку з фотографіями';

  @override
  String get momentsLocation => 'Включіть місця розташування фотографій';

  @override
  String get momentsEmpty => 'Немає останніх фотогруп.';

  @override
  String get momentsCreate => 'Напишіть про ці фото';

  @override
  String get momentsDismiss => 'Відхилити';

  @override
  String get momentsError => 'Не вдалося прочитати місцеві фотографії.';

  @override
  String get momentsCreated => 'Фотозапис створено.';

  @override
  String get momentsPermission =>
      'Надайте доступ до фотографій, щоб знайти місцеві пропозиції.';

  @override
  String get momentsScope =>
      'Лише останні фотографії; не більше 500 фотографій і 20 фотографій на картку.';

  @override
  String momentsPhotoCount(int count) {
    return 'Фотографії $count';
  }

  @override
  String get nearbyTitle => 'Підключайте пристрої';

  @override
  String get nearbySend => 'Авторизуйте інший пристрій';

  @override
  String get nearbyReceive => 'Підключіться до існуючого пристрою';

  @override
  String get nearbyInstructions =>
      'Підключіть обидва пристрої до одного Wi-Fi або до точки доступу один одного. Підтвердити авторизацію на наявному пристрої; обидва пристрої залишаються придатними для використання. Інтернет не потрібен.';

  @override
  String get nearbyCompare =>
      'Порівняйте цей код на обох пристроях перед схваленням.';

  @override
  String get nearbyConfirm => 'Коди збігаються';

  @override
  String get nearbyScan => 'Відскануйте код іншого пристрою';

  @override
  String get nearbyPaste => 'Вставте запрошення';

  @override
  String get nearbyWaiting => 'Очікування підтвердження на іншому пристрої';

  @override
  String get nearbyWorking =>
      'Авторизація та синхронізація вашого щоденника та вкладень…';

  @override
  String get nearbyPending =>
      'Деякі вкладення все ще потребують синхронізації. Залиште інший пристрій онлайн і повторіть спробу.';

  @override
  String get nearbyComplete =>
      'Пристрій підключено; щоденник і вкладення синхронізовано';

  @override
  String get nearbyFailed =>
      'Підключення не завершено. Перевірте локальне підключення та повторіть спробу.';

  @override
  String get nearbyEmptyRequired =>
      'Використовуйте пристрій із порожнім щоденником, який ще не підключено до синхронізації.';

  @override
  String get nearbyRetry => 'Продовжити синхронізацію';

  @override
  String get nearbyWifi => 'Налаштування Wi-Fi';

  @override
  String get nearbyHotspot => 'Налаштування точки доступу';

  @override
  String get nearbyKeepOpen =>
      'Тримайте цю сторінку відкритою, доки новий пристрій не завершиться. Термін дії запрошення закінчується через дві хвилини.';

  @override
  String get syncDevicesTitle => 'Авторизовані пристрої';

  @override
  String get syncDevicesDescription =>
      'Лише схвалені пристрої можуть отримати доступ до цього облікового запису AID. Відкликання пристрою блокує сервер, але не може стерти головний ключ або щоденник, уже скопійований на нього.';

  @override
  String get syncDeviceRequest =>
      'Покажіть цей авторизаційний QR на затвердженому пристрої';

  @override
  String get syncDeviceAuthorize => 'Авторизувати пристрій';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Відскануйте або вставте запит на авторизацію нового пристрою.';

  @override
  String get syncDeviceRevoke => 'Відкликати';

  @override
  String get syncDeviceRotate => 'Поверніть ключ підпису цього пристрою';

  @override
  String get syncDeviceCheck => 'Перевірте авторизацію';

  @override
  String get syncDeviceHardware => 'Апаратний ключ підпису';

  @override
  String get syncDeviceSoftware =>
      'Ключ підпису програмного забезпечення, що не підлягає експорту';

  @override
  String get syncDeviceUnavailable =>
      'Авторизація пристрою недоступна. Підтвердьте цей пристрій з іншого авторизованого пристрою та повторіть спробу.';

  @override
  String get syncDeviceRevoked => 'Відкликано';

  @override
  String get syncDeviceLocal => 'Цей пристрій';

  @override
  String get cloudTrafficTitle =>
      'Місячна хмарна квота для передачі медіафайлів';

  @override
  String get cloudTrafficLimit => 'Місячна квота передачі даних';

  @override
  String get cloudTrafficUsed => 'Передача даних використана';

  @override
  String get cloudTrafficRemaining => 'Залишилося передати дані';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'Квота передачі даних скидається на $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'Квота хмарної передачі даних для медіафайлів вичерпана. Відсутні мультимедійні файли синхронізуються автоматично, коли стане доступним пряме з’єднання або скинеться квота.';

  @override
  String get cloudTrafficExplanation =>
      'Кешування медіафайлів і ретрансляція в реальному часі спільно використовують цю квоту передачі даних. Прямі підключення не споживають його. Текст щоденника та повідомлення контролю з’єднання мають окремі невеликі щоденні ліміти.';

  @override
  String get appearanceThemeSection => 'Тема програми';

  @override
  String get appearancePaperSection => 'Щоденниковий папір';

  @override
  String get appearanceTypographySection => 'Текст щоденника';

  @override
  String get appearancePreferencesSection => 'Загальні переваги';

  @override
  String get themeSystemAccentHint =>
      'Використовує системну палітру замість спеціальних кольорів. Вимкніть його, щоб вибрати власний.';

  @override
  String get syncDeviceNameSaveFailed =>
      'Не вдалося зберегти назву пристрою. Спробуйте ще раз.';

  @override
  String get nearbyConnectionHelp => 'Допомога підключення';

  @override
  String get syncAllSynced => 'Все синхронізовано';

  @override
  String get syncDetailsTitle => 'Синхронізація деталей';

  @override
  String get syncMore => 'Більше варіантів';

  @override
  String get syncDeviceName => 'Назва пристрою';

  @override
  String get syncDeviceNameHint => 'Наприклад: Мій планшет';

  @override
  String get syncDeviceNameInvalid => 'Використовуйте від 1 до 32 символів';

  @override
  String get syncDeviceKeyDetails => 'Деталі безпеки';

  @override
  String get syncConnectionProblem =>
      'Наразі неможливо синхронізувати. Повторна спроба автоматично.';

  @override
  String get syncCopyComplete => 'Повна копія вашого щоденника та медіафайлів';

  @override
  String get syncCopyPartial => 'Деякі носії досі відсутні';

  @override
  String get syncCopyOlder => 'Нові зміни очікують на синхронізацію';

  @override
  String get syncCopyUnavailable =>
      'Деталі копії недоступні. Повторіть спробу пізніше.';

  @override
  String get syncCopyLastKnown =>
      'Інші пристрої показують свою останню підтверджену копію. Офлайн-пристрої зараз неможливо перевірити.';

  @override
  String get syncCopyTemporary =>
      'Тимчасовий кеш. Зберігайте оригінали на своїх пристроях.';

  @override
  String get syncCopyStorage =>
      'Ваше сховище для синхронізації. Завершені завантаження медіа відображаються в діагностиці.';

  @override
  String syncCopyChecked(String time) {
    return 'Востаннє підтверджено $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Передача даних, що залишилася цього місяця: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Почніть тут';

  @override
  String get onboardConnect => 'Підключіться до існуючого пристрою';

  @override
  String get onboardFailed =>
      'Не вдалося завершити налаштування. Ваш щоденник у безпеці; спробуйте ще раз.';

  @override
  String get tutorialTitle => 'Як користуватися щоденником';

  @override
  String get tutorialWriteTitle => 'Напишіть свій перший щоденник';

  @override
  String get tutorialWriteText =>
      'Торкніться +, щоб створити запис у щоденнику. Додайте необов’язкову назву, виберіть дату щоденника та торкніться галочки, щоб зберегти. Ви можете будь-коли знову відредагувати запис у щоденнику.';

  @override
  String get tutorialMediaTitle =>
      'Додайте фотографії, аудіо або рукописний текст';

  @override
  String get tutorialMediaText =>
      'Використовуйте + у редакторі щоденника, щоб прикріпити фотографії, відео чи голосовий запис або відкрити полотно рукописного тексту. Ці вкладення зберігаються разом із записом у щоденнику.';

  @override
  String get tutorialReviewTitle => 'Знову знайдіть день';

  @override
  String get tutorialReviewText =>
      'Переглядайте свій щоденник або календар, шукайте записи та впорядковуйте записи за допомогою тегів. На сторінках «Медіа» та «Атлас» можна знайти попередні записи за фотографіями чи місцем розташування.';

  @override
  String get tutorialSyncTitle => 'Використовуйте більше одного пристрою';

  @override
  String get tutorialSyncText =>
      'У Налаштуваннях → Дані та зберігання → Синхронізація підключіться до наявного пристрою та підтвердьте авторизацію на цьому пристрої. Обидва пристрої можуть продовжувати використовувати щоденник. Спочатку синхронізується текст щоденника. Мультимедійні файли синхронізуються наступним чином, коли це дозволять підключення до мережі та квота передавання даних, що залишилася.';

  @override
  String get tutorialPrivacyTitle => 'Бережіть свій щоденник';

  @override
  String get tutorialPrivacyText =>
      'Записи щоденника залишаються на цьому пристрої, якщо ви не ввімкнете синхронізацію, не поділитеся ними чи не експортуєте їх. Синхронізація має наскрізне шифрування. У налаштуваннях ви також можете встановити пароль програми, створити резервні копії та повторно відкрити цей посібник.';

  @override
  String get editorDiaryDay => 'День щоденника';

  @override
  String get editorDiaryDayPicker =>
      'День щоденника · До якого дня належить цей запис?';

  @override
  String editorCreatedAt(String time) {
    return 'Створено $time';
  }

  @override
  String get editorDiaryDayHint =>
      'День, до якого належить цей запис. Його зміна не змінює час створення запису.';

  @override
  String get hiddenDiaryTitle => 'Приховані записи';

  @override
  String get hiddenDiaryHide => 'Приховати запис';

  @override
  String get hiddenDiaryShow => 'Показати запис';

  @override
  String get hiddenDiaryEmpty => 'Немає прихованих записів';

  @override
  String get hiddenDiaryUnlock => 'Розблокувати приховані записи';

  @override
  String get hiddenDiaryAuthHint =>
      'Скористайтеся блокуванням застосунку або екрана пристрою.';

  @override
  String hiddenDiaryWhere(String path) {
    return 'Приховано. Щоб показати знову: $path';
  }

  @override
  String get noteKeep => 'Зберегти';

  @override
  String get noteComment => 'Коментувати';

  @override
  String get noteCommentHint => 'Напишіть собі з минулого';

  @override
  String get noteKept => 'Уривок збережено';

  @override
  String get notesPassages => 'Збережені уривки';

  @override
  String get notesComments => 'Коментарі';

  @override
  String get noteDeleteConfirm => 'Видалити цю нотатку?';

  @override
  String get editPastTitle => 'Змінити минулий спогад?';

  @override
  String get editPastBody =>
      'Цей запис зроблено в минулому. Щоб відповісти на нього, виділіть текст і збережіть або прокоментуйте його.';

  @override
  String get editPastDontAsk => 'Більше не питати';

  @override
  String get editPastEdit => 'Усе одно змінити';

  @override
  String noteOnEntry(String date) {
    return 'Про запис від $date';
  }

  @override
  String get settingsConfirmEditPast => 'Питати перед зміною минулих записів';

  @override
  String get settingsCompressPhotos => 'Стискати нові фото';

  @override
  String get settingsCompressPhotosHint =>
      'Зберігати нові фото як WebP близько 1 МБ. Якщо вимкнено, зберігаються оригінали.';

  @override
  String get compressExistingTitle => 'Стиснути наявні фото';

  @override
  String compressExistingBody(int count, String size) {
    return '$count фото займають $size. Фото понад близько 1 МБ стануть WebP близько 1 МБ. Оригінали буде замінено без можливості скасування; збережіть їх окремо, якщо потрібно.';
  }

  @override
  String get compressExistingAction => 'Стиснути';

  @override
  String compressExistingDone(int count, String size) {
    return 'Стиснуто фото: $count, звільнено $size';
  }

  @override
  String get commentExpand => 'Розгорнути';

  @override
  String get refAdd => 'Процитувати запис';

  @override
  String get refMissing => 'Цього запису більше немає';

  @override
  String get moodClear => 'Очистити настрій';

  @override
  String get scrollToTop => 'Нагору';

  @override
  String get feedbackTitle => 'Зворотний зв’язок';

  @override
  String get feedbackHint => 'Опишіть проблему або пропозицію';

  @override
  String get feedbackGithub => 'Задача на GitHub';

  @override
  String get feedbackEmail => 'Написати листа';

  @override
  String get feedbackCopy => 'Копіювати текст';

  @override
  String get feedbackLaunchFailed =>
      'Не вдалося відкрити застосунок. Скопіюйте текст і скористайтеся поштою нижче.';

  @override
  String get feedbackCopied => 'Текст скопійовано';
}
