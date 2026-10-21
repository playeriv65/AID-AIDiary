// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

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
  String get dailyReminderTitle => 'امروز را ثبت کن!';

  @override
  String get dailyReminderDescription => 'گزارش روزانه ات رو ثبت کن…';

  @override
  String get actionTakePhoto => 'عکس بگیر';

  @override
  String get flashbacksTitle => 'فلش بک';

  @override
  String get settingsFlashbacksExcludeBadDays => 'مستثنی کردن روزهای بد';

  @override
  String get flashbackGoodDay => 'یک روز خوب';

  @override
  String get flashbackRandomDay => 'یک روز تصادفی';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count هفته قبل',
      one: '$count هفته قبل',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ماه قبل',
      one: '$count ماه قبل',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count سال قبل',
      one: '$count سال قبل',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'در این روز';

  @override
  String get searchLogsHint => 'تاریخچه جستجوها…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count گزارش ها',
      one: '$count گزارش',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count روز ها',
      one: '$count روز',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کلمات',
      one: '$count کلمه',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'تاریخچه ای وجود ندارد…';

  @override
  String get noResults => 'بدون نتیجه…';

  @override
  String get sortOrderAscendingTitle => 'افزایشی';

  @override
  String get sortOrderDescendingTitle => 'کاهشی';

  @override
  String get pageStatisticsTitle => 'آمارها';

  @override
  String get statisticsNotEnoughData => 'اطلاعات کافی نیست …';

  @override
  String get statisticsRangeOneMonth => '۱ ماه';

  @override
  String get statisticsRangeSixMonths => '۶ ماه';

  @override
  String get statisticsRangeOneYear => '۱ سال';

  @override
  String get statisticsRangeAllTime => 'کل بازه زمانی';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag خلاصه';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag براساس روز';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag در طول زمان';
  }

  @override
  String get chartGroupingLabel => 'گروه‌بندی بر اساس';

  @override
  String get chartGroupingDay => 'روز';

  @override
  String get chartGroupingWeek => 'هفته';

  @override
  String get chartGroupingMonth => 'ماه';

  @override
  String get chartGroupingYear => 'سال';

  @override
  String get chartSmoothingLabel => 'Smoothing';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'توالی کنونی $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'طولانی ترین پیوستگی $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Great Days $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'روز از اخرین روز بد $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'امکان دسترسی به حافظه خارجی وجود ندارد';

  @override
  String get errorExternalStorageAccessDescription =>
      'اگر از فضای ذخیره‌سازی شبکه استفاده می‌کنید، مطمئن شوید سرویس آنلاین است و به شبکه دسترسی دارید.\n\nدر غیر این صورت، ممکن است اپلیکیشن مجوزهای مربوط به پوشهٔ خارجی ز دست داده باشد. به بخش تنظیمات بروید و پوشهٔ خارجی را دوباره انتخاب کنید تا دسترسی مجدد بدهید.\n\nهشدار: تا زمانی که دسترسی به محل ذخیره‌سازی خارجی را بازیابی نکنید، تغییرات همگام‌سازی نخواهند شد!';

  @override
  String get errorExternalStorageAccessContinue => 'ادامه با پایگاه داده محلی';

  @override
  String get lastModified => 'تغییریافته';

  @override
  String get writeSomethingHint => 'چیزی بنویسید…';

  @override
  String get titleHint => 'عنوان…';

  @override
  String get deleteLogTitle => 'حذف تاریخچه';

  @override
  String get deleteLogDescription => 'ایا میخواهید این تاریچه را پاک کنید؟';

  @override
  String get deletePhotoTitle => 'حذف عکس';

  @override
  String get deletePhotoDescription => 'ایا میخواهید این عکس را حذف کنید؟';

  @override
  String get pageSettingsTitle => 'تنظیمات';

  @override
  String get settingsTheme => '‏تم';

  @override
  String get themeSystem => 'سیستم';

  @override
  String get themeLight => 'روشن';

  @override
  String get themeDark => 'تاریک';

  @override
  String get themeAmoled => 'امولد';

  @override
  String get settingsFirstDayOfWeek => 'روز اول هفته';

  @override
  String get settingsCalendarSystem => 'سیستم تقویم';

  @override
  String get calendarSystemGregorian => 'میلادی';

  @override
  String get calendarSystemJalali => 'شمسی (جلالی)';

  @override
  String get settingsUseSystemAccentColor => 'استفاده از رنگ بندی سیستم';

  @override
  String get settingsCustomAccentColor => 'شخصی سازی رنگ بندی';

  @override
  String get settingsShowFlashbacks => 'نمایش فلش بک ها';

  @override
  String get settingsChangeMoodIcons => 'تغییر آیکن حس و حال';

  @override
  String get moodIconPrompt => 'یک آیکون وارد کنید';

  @override
  String get settingsHideImages => 'پنهان کردن عکس ها';

  @override
  String get pageCalendarTitle => 'تقویم';

  @override
  String get settingsNotificationsTitle => 'نوتیفیکشن ها';

  @override
  String get settingsDailyReminderTitle => 'یادآوری روزانه';

  @override
  String get settingsOnThisDayDescription => 'مرور خاطرات گذشته';

  @override
  String get settingsDailyReminderDescription => 'یه یادآوری کوچولو روزانه';

  @override
  String get settingsReminderTime => 'زمان یادآوری';

  @override
  String get settingsFixedReminderTimeTitle => 'زمان یادآوری ثابت';

  @override
  String get settingsFixedReminderTimeDescription =>
      'یک زمان ثابت برای یادآوری انتخاب کنید';

  @override
  String get settingsAlwaysSendReminderTitle => 'همیشه یادآور ارسال شود';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'یادآوری را بفرست، حتی اگر قبلاً یک لاگ شروع شده باشد';

  @override
  String get settingsCustomizeNotificationTitle => 'سفارشی سازی اعلان ها';

  @override
  String get settingsTemplatesTitle => '‎الگوها';

  @override
  String get manageTemplates => 'مدیریت الگوها';

  @override
  String get noTemplateTitle => 'هیچ';

  @override
  String get noTemplatesDescription => 'هیچ الگویی هنوز ایجاد نشده است…';

  @override
  String get templateDefaultTimestampTitle => 'زمان ثبت';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'خلاصه روز';

  @override
  String get templateDefaultSummaryBody => '### خلاصه\n- \n\n### نقل‌قول\n> ';

  @override
  String get templateDefaultReflectionTitle => 'بازتاب';

  @override
  String get templateDefaultReflectionBody =>
      '### چه چیزی امروز لذت بخش بود؟\n- \n\n### بابت چه چیزی شکرگزارید؟\n- \n\n### منتظر چه چیزی هستید؟\n- ';

  @override
  String get settingsTagsTitle => 'برچسب‌ها';

  @override
  String get manageTags => 'مدیریت برچسب‌ها';

  @override
  String get tagTypeLabelTitle => 'Label';

  @override
  String get tagTypeTrackerTitle => 'Tracker';

  @override
  String get nameHint => 'نام';

  @override
  String get tagColorLabel => 'رنگ';

  @override
  String get iconPickerTitle => 'انتخاب آیکن';

  @override
  String get iconPickerIconsTab => 'آیکن‌ها';

  @override
  String get iconPickerCustomTab => 'شخصی‌سازی';

  @override
  String get iconPickerSearchHint => 'جستجوی آیکن‌ها…';

  @override
  String get colorPickerTitle => 'انتخاب رنگ';

  @override
  String get colorPickerPaletteTab => 'رنگ‌ها';

  @override
  String get iconGroupMoodPeople => 'Mood & People';

  @override
  String get iconGroupHealth => 'سلامت';

  @override
  String get iconGroupWorkFinance => 'کار و امور مالی';

  @override
  String get iconGroupHabitsGoals => 'عادات و اهداف';

  @override
  String get iconGroupNature => 'طبیعت';

  @override
  String get iconGroupFoodDrink => 'غذا و نوشیدنی‌';

  @override
  String get iconGroupHome => 'خانه';

  @override
  String get iconGroupTravel => 'سفر';

  @override
  String get iconGroupSymbols => 'نمادها';

  @override
  String get tagCategoryLabel => 'دسته بندی';

  @override
  String get tagLabel => 'Tag';

  @override
  String get tagCategoryUncategorized => 'دسته بندی نشده';

  @override
  String get newCategoryTitle => 'دسته بندی جدید';

  @override
  String get shareButtonLabel => 'Share';

  @override
  String get importErrorDescription => 'Failed to import file!';

  @override
  String get exportErrorDescription => 'Failed to export file!';

  @override
  String get deleteTitle => 'پاک کردن';

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
  String get addTagsTitle => 'افزودن برچسب';

  @override
  String get addTagsSearchHint => 'جستجوی برچسب‌ها…';

  @override
  String get tagPickerSortManualLabel => 'ترتیب دستی';

  @override
  String get tagPickerSortUsageLabel => 'مرتب کردن بر اساس استفاده';

  @override
  String get tagFavoriteName => 'مورد علاقه‌ها';

  @override
  String get tagEnergyName => 'انرژی';

  @override
  String get tagCategoryActivitiesName => 'فعالیت‌ها';

  @override
  String get tagExerciseName => 'ورزش';

  @override
  String get tagSocializingName => 'معاشرت';

  @override
  String get tagHobbyName => '';

  @override
  String get tagEntertainmentName => 'Entertainment';

  @override
  String get tagDiningName => 'Dining';

  @override
  String get tagChoresName => 'Chores';

  @override
  String get tagCategoryEmotionsName => 'احساساتی';

  @override
  String get tagExcitedName => 'هیجان‌زده';

  @override
  String get tagGratefulName => 'سپاسگزار';

  @override
  String get tagCalmName => 'آرام';

  @override
  String get tagTiredName => 'خسته';

  @override
  String get tagAnxiousName => 'مضطرب';

  @override
  String get tagAnnoyedName => 'آزرده خاطر';

  @override
  String get welcomeLogBodyText =>
      '## Welcome to AID Diary\n\n> A quiet place for your days.\n\nWrite what happened, how you felt, and where you were. Your entries stay on this device.\n\n- **Journal** lists every entry by day\n- **Calendar**, **Media** and **Atlas** look back by date, photo and place\n- **Coach** offers prompts and templates when you don\'t know what to write';

  @override
  String get settingsStorageTitle => 'ذخیره سازی';

  @override
  String get settingsImageQuality => 'کیفیت تصویر';

  @override
  String get imageQualityHigh => 'زیاد';

  @override
  String get imageQualityMedium => 'متوسط';

  @override
  String get imageQualityLow => 'پایین';

  @override
  String get imageQualityNoCompression => 'بدون فشرده سازی';

  @override
  String get settingsLogFolder => 'پوشه گزارش';

  @override
  String get settingsImageFolder => 'پوشه تصاویر';

  @override
  String get warningTitle => 'هشدار';

  @override
  String get logFolderWarningDescription =>
      'اگر پوشهٔ انتخابی از قبل شامل فایل \'aid_diary.db\' باشد، از آن فایل برای بازنویسی (overwrite) گزارش های موجود شما استفاده خواهد شد!';

  @override
  String get errorTitle => 'خطا';

  @override
  String get logFolderErrorDescription => 'خطا در تغییر پوشه گزارش!';

  @override
  String get imageFolderErrorDescription => 'خطا در تغییر پوشه عکس!';

  @override
  String get backupErrorDescription => 'خطا در پشتیبانی گیری!';

  @override
  String get restoreErrorDescription => 'خطا در بازیابی پشتیبانی!';

  @override
  String get settingsBackupRestoreTitle => 'پشتیبان گیری و بازیابی';

  @override
  String get settingsBackup => 'پشتیبان گیری';

  @override
  String get settingsRestore => 'بازنشانی';

  @override
  String get settingsRestorePromptDescription =>
      'بازیابی پشتیبان اطلاعات موجود را بازنویسی خواهد کرد!';

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
    return 'درحال انتقال… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'درحال پشتیبانی گیری… $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'درحال بازیابی اطلاعات… $percent%';
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
  String get cleanUpStatus => 'در حال تمیز کردن …';

  @override
  String get settingsExportToAnotherFormat => 'خروجی به فرمت دیگر';

  @override
  String get settingsExportFormatDescription =>
      'این نباید به عنوان یک پشتیبان استفاده شود!';

  @override
  String get settingsImportFromAnotherApp => 'ورودی از یک برنامه دیگر';

  @override
  String get logFormatTitle => 'انتخاب فرمت';

  @override
  String get logFormatDescription =>
      'فرمت اپلیکیشن دیگر ممکن است همهٔ قابلیت‌ها را پشتیبانی نکند. لطفاً مشکلات را گزارش دهید، چون فرمت‌های شخص ثالث ممکن است هر لحظه تغییر کنند. این کار به گزارش های فعلی شما آسیبی نمی‌زند!';

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
  String get formatMarkdown => 'مارک داون';

  @override
  String get settingsDeleteAllLogsTitle => 'حذف همه گزارش ها';

  @override
  String get settingsDeleteAllLogsDescription =>
      'ایا می‌خواهید همه گزارش ها را حذف کنید؟';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'برای تأیید \'$prompt\' را وارد کنید. این عمل قابل بازگشت نیست!';
  }

  @override
  String get settingsLanguageTitle => 'زبان';

  @override
  String get settingsAppLanguageTitle => 'زبان برنامه';

  @override
  String get settingsOverrideAppLanguageTitle => 'نادیده گرفتن زبان برنامه';

  @override
  String get settingsSecurityTitle => 'امنیت';

  @override
  String get settingsSecurityRequirePassword => 'نیاز به گذرواژه';

  @override
  String get settingsSecurityEnterPassword => 'ورود گذرواژه';

  @override
  String get settingsSecuritySetPassword => 'تعیین گذرواژه';

  @override
  String get settingsSecurityChangePassword => 'تغییر گذرواژه';

  @override
  String get settingsSecurityPassword => 'گذرواژه';

  @override
  String get settingsSecurityConfirmPassword => 'تایید گذرواژه';

  @override
  String get settingsSecurityOldPassword => 'گذرواژه قدیمی';

  @override
  String get settingsSecurityIncorrectPassword => 'رمز اشتباه';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'گذرواژه منطبق نیست';

  @override
  String get requiredPrompt => 'نیاز است';

  @override
  String get settingsSecurityBiometricUnlock => 'بازکردن بایومتریک';

  @override
  String get unlockAppPrompt => 'قفل برنامه را باز کنید';

  @override
  String get settingsAboutTitle => 'درباره';

  @override
  String get settingsVersion => 'نسخه';

  @override
  String get settingsLicense => 'مجوز';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsOpenSourceLicenses => 'Open Source Licenses';

  @override
  String get tagMoodTitle => 'حس و حال';

  @override
  String get selectTagTitle => 'انتخاب برچسب';

  @override
  String get labelPresentLabel => 'حال حاضر';

  @override
  String get labelAbsentLabel => 'غایب';

  @override
  String get labelCoverageLabel => 'پوشش';

  @override
  String chartDistributionTitle(Object tag) {
    return '$tag توزیع';
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
  String get settingsDayStart => 'New entries count for the day before until';

  @override
  String get settingsDayAskUntil => 'Then ask which day until';

  @override
  String get settingsDayStartMidnight => 'Off';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Every entry keeps the day it belongs to next to the time it was written, and you can change that day in the editor at any time. These hours only pick the day for new entries, so changing them moves no existing entry.';

  @override
  String get lateNightBadge =>
      'Written late at night, counted for the day before';

  @override
  String editorDayAsk(String time) {
    return 'Written at $time. Which day is it for?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (yesterday)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (today)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'Written $when';
  }

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
    return 'Count this entry for $date and set its place to $place, as recorded in the photo?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Count this entry for $date, when the photo was taken?';
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
  String get mediaFromFiles => 'Choose from files';

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

  @override
  String get settingsSyncTitle => 'Cloud Sync';

  @override
  String get syncOffDescription =>
      'Keep this diary the same on all your devices through Google Drive or a WebDAV server, such as Nextcloud, Synology or Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'Sync with Google Drive';

  @override
  String get syncOrWebDav => 'Or a WebDAV server';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn => 'Signed in. You can go back to AID Diary.';

  @override
  String get syncGoogleSignInAgain => 'Google needs you to sign in again.';

  @override
  String get syncSignInAgain => 'Sign in again';

  @override
  String get syncGoogleDriveNotAllowed =>
      'Access to Google Drive was not allowed. Connect again and tick Google Drive on Google\'s page.';

  @override
  String get syncEntryUnsynced =>
      'Not synced: the last sync did not go through';

  @override
  String get syncUseOfficial => 'Use the AID sync server';

  @override
  String get syncServer => 'Server address';

  @override
  String get syncUsername => 'Username';

  @override
  String get syncPassword => 'Password';

  @override
  String get syncConnect => 'Connect';

  @override
  String get syncConnecting => 'Connecting…';

  @override
  String get syncSignInFailed =>
      'Could not sign in. Check the address, the username and the password.';

  @override
  String syncConnectFailed(String error) {
    return 'Could not connect: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Start syncing';

  @override
  String get syncNewSpaceDescription =>
      'There is no synced diary on this server yet. This diary will be uploaded to it.';

  @override
  String get syncEncrypt => 'End-to-end encryption';

  @override
  String get syncEncryptDescription =>
      'Entries and photos are encrypted on your devices. Nobody else can read them, not even whoever runs the server.';

  @override
  String get syncPassphrase => 'Encryption passphrase';

  @override
  String get syncPassphraseRepeat => 'Repeat the passphrase';

  @override
  String get syncPassphraseTooShort => 'Use at least 8 characters';

  @override
  String get syncPassphraseMismatch => 'The passphrases differ';

  @override
  String get syncPassphraseNote =>
      'You need the passphrase or the recovery key to add another device. The diary on this device stays readable without them.';

  @override
  String get syncRecoveryKeyTitle => 'Save your recovery key';

  @override
  String get syncRecoveryKeyDescription =>
      'If you forget the passphrase, this key opens your synced diary. Keep it in a password manager or on paper. It is shown only this once.';

  @override
  String get syncRecoveryKeyCopied => 'Recovery key copied';

  @override
  String get syncRecoveryKeySaved => 'I have saved it';

  @override
  String get syncJoinTitle => 'Join the synced diary';

  @override
  String get syncJoinDescription =>
      'This server already holds a synced diary. The entries on this device will be added to it.';

  @override
  String get syncJoinEncrypted =>
      'It is end-to-end encrypted. Enter its passphrase to open it.';

  @override
  String get syncUseRecoveryKey => 'Use the recovery key';

  @override
  String get syncUsePassphrase => 'Use the passphrase';

  @override
  String get syncRecoveryKey => 'Recovery key';

  @override
  String get syncWrongKey => 'This does not open the synced diary.';

  @override
  String syncLastSynced(String time) {
    return 'Last synced $time';
  }

  @override
  String get syncNever => 'Not synced yet';

  @override
  String get syncSyncing => 'Syncing…';

  @override
  String syncFailed(String error) {
    return 'The last sync failed: $error';
  }

  @override
  String get syncLocked =>
      'The synced diary was reset on another device, or its key is missing here. Unlock it to keep syncing.';

  @override
  String get syncNow => 'Sync now';

  @override
  String get syncUnlock => 'Unlock';

  @override
  String get syncEncrypted => 'End-to-end encrypted';

  @override
  String get syncNotEncrypted => 'Not encrypted';

  @override
  String get syncChangePassphrase => 'Change passphrase';

  @override
  String get syncPassphraseChanged => 'Passphrase changed';

  @override
  String get syncResetEncryption => 'Reset encryption';

  @override
  String get syncResetEncryptionDescription =>
      'For a forgotten passphrase: the encrypted copy on the server is replaced by the diary on this device, under a new passphrase. Your other devices then join again with it.';

  @override
  String get syncDisconnect => 'Stop syncing';

  @override
  String get syncDisconnectDescription =>
      'This device stops syncing. The diary here and the copy on the server stay as they are.';
}
