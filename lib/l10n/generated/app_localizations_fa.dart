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
  String get themeColorTitle => 'رنگ تم';

  @override
  String get themeColorHint => 'رنگی را برای این پالت انتخاب کنید.';

  @override
  String get themeColorBlue => 'آبی آسمانی';

  @override
  String get themeColorGreen => 'سبز جنگلی';

  @override
  String get themeColorBrown => 'قهوه گرم';

  @override
  String get themeColorPurple => 'اسطوخودوس';

  @override
  String get themeColorRose => 'گل رز غبارآلود';

  @override
  String get themeColorAmber => 'کهربا';

  @override
  String get themeColorPreview => 'هر روز کمی';

  @override
  String get themeTintBackgroundTitle => 'پس زمینه را با رنگ تم رنگ کنید';

  @override
  String get themeTintBackgroundHint =>
      'برای پس‌زمینه‌های خاکستری خنثی خاموش کنید. دکمه ها رنگ انتخابی شما را حفظ می کنند.';

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
  String get chartSmoothingLabel => 'صاف کردن';

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
      other: 'روزهای عالی $count',
      one: 'روزهای عالی $count',
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
  String get tagTypeLabelTitle => 'برچسب بزنید';

  @override
  String get tagTypeTrackerTitle => 'ردیاب';

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
  String get iconGroupMoodPeople => 'خلق و خوی و مردم';

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
  String get tagLabel => 'برچسب بزنید';

  @override
  String get tagCategoryUncategorized => 'دسته بندی نشده';

  @override
  String get newCategoryTitle => 'دسته بندی جدید';

  @override
  String get shareButtonLabel => 'به اشتراک بگذارید';

  @override
  String get importErrorDescription => 'وارد کردن فایل انجام نشد!';

  @override
  String get exportErrorDescription => 'فایل صادر نشد!';

  @override
  String get deleteTitle => 'پاک کردن';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' در $count دفترچه خاطرات استفاده می شود.',
      one: ' در $count ثبت خاطرات استفاده می شود.',
      zero: '',
    );
    return '\"$name\" حذف شود؟$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' $count تگ آن نیز حذف خواهد شد.',
      one: ' تگ های $count آن نیز حذف خواهند شد.',
      zero: '',
    );
    return '\"$name\" حذف شود؟$_temp0';
  }

  @override
  String get tagNameExists => 'قبلاً یک برچسب با این نام وجود دارد';

  @override
  String get categoryNameExists => 'در حال حاضر یک دسته با این نام وجود دارد';

  @override
  String deleteTemplateMessage(Object name) {
    return '\"$name\" حذف شود؟';
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
  String get tagHobbyName => 'سرگرمی';

  @override
  String get tagEntertainmentName => 'سرگرمی';

  @override
  String get tagDiningName => 'ناهار خوری';

  @override
  String get tagChoresName => 'کارهای روزمره';

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
  String get settingsBackupPasswordProtect => 'پشتیبان گیری محافظت از رمز عبور';

  @override
  String get backupEncryptedTitle => 'پشتیبان گیری رمزگذاری شده';

  @override
  String get backupEncryptedContent => 'این پشتیبان با رمز محافظت می شود.';

  @override
  String get settingsAutoBackup => 'پشتیبان گیری خودکار';

  @override
  String get settingsAutoBackupLocation => 'مکان پشتیبان گیری';

  @override
  String get settingsAutoBackupInterval => 'فاصله پشتیبان گیری';

  @override
  String get settingsAutoBackupIntervalDaily => 'روزانه';

  @override
  String get settingsAutoBackupIntervalWeekly => 'هفتگی';

  @override
  String get settingsAutoBackupIntervalMonthly => 'ماهانه';

  @override
  String get settingsAutoBackupMaxCount => 'پشتیبان گیری برای نگه داشتن';

  @override
  String get settingsAutoBackupRequireCharging => 'فقط هنگام شارژ';

  @override
  String settingsBackupLast(Object time) {
    return 'آخرین نسخه پشتیبان $time';
  }

  @override
  String get settingsBackupNever => 'هرگز پشتیبان‌گیری نشد';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'پشتیبان بعدی $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'همه';

  @override
  String get autoBackupFailedTitle => 'پشتیبان گیری انجام نشد';

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
    return 'در حال رمزگذاری پشتیبان… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'در حال رمزگشایی پشتیبان… $percent%';
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
  String get formatOneDiary => 'One Diary';

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
  String get settingsOpenSourceLicenses => 'مجوزهای منبع باز';

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
  String get shareAddToLogPickerTitle => 'یک دفترچه خاطرات را انتخاب کنید';

  @override
  String get adaptiveEmptyDay => 'هنوز هیچ ورودی برای این روز وجود ندارد';

  @override
  String get adaptiveNewEntry => 'یک ورودی بنویسید';

  @override
  String get pageJournalTitle => 'مجله';

  @override
  String get coachPrompt1 => 'چه چیزی باعث شد امروز لبخند بزنی؟';

  @override
  String get coachPrompt2 => 'یک چیزی که امروز یاد گرفتی چیست؟';

  @override
  String get coachPrompt3 => 'امروز با چه کسی صحبت کردید و چه حسی داشتید؟';

  @override
  String get coachPrompt4 => 'در حال حاضر برای چه چیزی شکرگزار هستید؟';

  @override
  String get coachPrompt5 => 'چه چیزی بیشتر انرژی امروز شما را گرفت؟';

  @override
  String get coachPrompt6 =>
      'یک لحظه کوچک را که می خواهید به خاطر بسپارید توصیف کنید.';

  @override
  String get coachPrompt7 => 'چه چیزی فردا را روز خوبی می کند؟';

  @override
  String get coachPrompt8 => 'اخیراً چه چیزی در ذهن شما بوده است؟';

  @override
  String get coachPrompt9 => 'امروز فقط برای خودت چه کردی؟';

  @override
  String get coachPrompt10 => 'اگر امروز عنوانی داشت چه عنوانی داشت؟';

  @override
  String get pageMediaTitle => 'رسانه ها';

  @override
  String get pageAtlasTitle => 'اطلس';

  @override
  String get pageCoachTitle => 'مربی';

  @override
  String get noEntrySelected => 'ورودی انتخاب نشده است.';

  @override
  String get entryShare => 'به اشتراک بگذارید';

  @override
  String get entryFavorite => 'ستاره';

  @override
  String get entryEdit => 'ویرایش کنید';

  @override
  String get entryPrevious => 'ورودی قبلی';

  @override
  String get entryNext => 'ورودی بعدی';

  @override
  String get journalStories => 'داستان ها';

  @override
  String get journalEntries => 'ورودی ها';

  @override
  String get journalEmptyHint =>
      'دفتر خاطرات خود را با افزودن یک ورودی جدید آغاز کنید.';

  @override
  String get storyToday => 'امروز';

  @override
  String get storyThrowback => 'برگشت به عقب';

  @override
  String get storyNoThrowback => 'امروز بدون بازگشت';

  @override
  String get mediaFiles => 'فایل های رسانه ای';

  @override
  String get mediaEmpty => 'هنوز عکسی وجود ندارد.';

  @override
  String get mediaEmptyHint =>
      'عکس های پیوست شده به ورودی ها در اینجا نشان داده می شود.';

  @override
  String get atlasEmpty => 'ورودی با مکان وجود ندارد.';

  @override
  String get atlasEmptyHint =>
      'ورودی‌های دارای مکان در اینجا نشان داده می‌شوند.';

  @override
  String get atlasShowAll => 'نمایش همه ورودی ها';

  @override
  String get atlasMyLocation => 'موقعیت مکانی من';

  @override
  String get coachAll => 'همه';

  @override
  String get coachPrograms => 'برنامه ها';

  @override
  String get coachTemplates => 'قالب ها';

  @override
  String get coachKindProgram => 'برنامه';

  @override
  String get coachKindTemplate => 'الگو';

  @override
  String get coachNoTemplates => 'بدون برنامه یا قالب';

  @override
  String get coachUseTemplate => 'با این قالب بنویس';

  @override
  String get coachProgramEverydayTitle => 'لحظه های روزمره';

  @override
  String get coachProgramEverydayDescription =>
      'پنج سوال کوتاه، یک سوال در روز. هر کدام یک یا دو دقیقه طول می‌کشد و به شما کمک می‌کند ببینید چه چیزی آن روز را به شما تبدیل کرده است. روشی ملایم برای ایجاد عادت به نوشتن هر روز.';

  @override
  String get coachProgramReflectTitle => 'به درون نگاه می کند';

  @override
  String get coachProgramReflectDescription =>
      'یک سوال عمیق تر در هفته، به مدت پنج هفته. برای هر کدام وقت بگذارید: چه احساسی داشته اید، چه چیزی شما را خسته می کند، چه چیزی برای آن سپاسگزار هستید.';

  @override
  String get searchFilters => 'فیلترها';

  @override
  String get searchFilterTags => 'برچسب ها';

  @override
  String get searchFilterStarred => 'ستاره دار';

  @override
  String get searchHint => 'برای جستجو تایپ کنید یا فیلتری را انتخاب کنید.';

  @override
  String get locationTitle => 'مکان';

  @override
  String get locationName => 'نام مکان';

  @override
  String get locationRemove => 'حذف کنید';

  @override
  String get locationServiceDisabled => 'خدمات مکان خاموش است.';

  @override
  String get locationPermissionDenied => 'مجوز مکان رد شد.';

  @override
  String get locationUnavailable => 'نمی توان مکان فعلی را دریافت کرد.';

  @override
  String get calendarJumpToToday => 'پرش به امروز';

  @override
  String get editorStartWriting => 'شروع به نوشتن کنید یا a را انتخاب کنید ';

  @override
  String get editorTemplateLink => 'الگو';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'یک الگو را انتخاب کنید';

  @override
  String get templateFeatured => 'قالب های ویژه';

  @override
  String get templateMine => 'قالب های من';

  @override
  String get templateDailyName => 'بررسی روزانه';

  @override
  String get templateDailyDescription =>
      'چه اتفاقی افتاد، چه حسی داشت، و چه چیزی بعد از آن.';

  @override
  String get templateDailyText =>
      '## امروز چه اتفاقی افتاد\n\n\n## چه احساسی داشتم\n\n\n## سه چیز برای من سپاسگزارم\n1. \n2. \n3. \n\n## فردا\n';

  @override
  String get templateTravelName => 'دفترچه خاطرات سفر';

  @override
  String get templateTravelDescription => 'مکان ها، لحظات و غذا از جاده.';

  @override
  String get templateTravelText =>
      '## جایی که رفتم\n\n\n## لحظه ای که بیشتر به یاد دارم\n\n\n## چیزی که خوردم\n\n\n## برنامه برای فردا\n';

  @override
  String get templateReadingName => 'خواندن یادداشت ها';

  @override
  String get templateReadingDescription =>
      'نقل قول ها و افکار از آنچه می خوانید.';

  @override
  String get templateReadingText =>
      '## کتاب\n\n\n## جایی که من هستم\n\n\n## نقل قول\n> \n\n## افکار من\n';

  @override
  String get templateWeeklyName => 'بررسی هفتگی';

  @override
  String get templateWeeklyDescription =>
      'نکات برجسته، مبارزات و تمرکز هفته آینده.';

  @override
  String get templateWeeklyText =>
      '## نکات برجسته\n\n\n## چه سخت بود\n\n\n## چیزی که یاد گرفتم\n\n\n## برای هفته آینده تمرکز کنید\n';

  @override
  String get entryDuplicate => 'تکراری';

  @override
  String get entryDuplicated => 'ورودی کپی شده';

  @override
  String get entrySaveAsTemplate => 'ذخیره به عنوان الگو';

  @override
  String get entrySavedAsTemplate => 'به عنوان یک الگو ذخیره شد';

  @override
  String get storyStatistics => 'آمار';

  @override
  String get storyMoodChart => 'نمودار خلقی';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return 'ورودی های $entries · روز $days';
  }

  @override
  String get storyThisYear => 'امسال';

  @override
  String get storyLastYear => 'سال گذشته';

  @override
  String get storyTapToOpen => 'یک روز ضربه بزنید تا باز شود';

  @override
  String get settingsGeneralTitle => 'ژنرال';

  @override
  String get settingsDataTitle => 'داده و ذخیره سازی';

  @override
  String get settingsStoriesTitle => 'داستان ها';

  @override
  String get settingsHelpTitle => 'راهنما و درباره';

  @override
  String get weatherTitle => 'آب و هوا';

  @override
  String get weatherClear => 'پاک کردن';

  @override
  String get weatherPartlyCloudy => 'نیمه ابری';

  @override
  String get weatherCloudy => 'ابری';

  @override
  String get weatherFog => 'مه';

  @override
  String get weatherDrizzle => 'نم نم باران';

  @override
  String get weatherRain => 'باران';

  @override
  String get weatherSnow => 'برف';

  @override
  String get weatherStorm => 'رعد و برق';

  @override
  String get weatherFetch => 'آب و هوا را برای این ورودی دریافت کنید';

  @override
  String get weatherNeedsLocation => 'ابتدا یک مکان با مختصات اضافه کنید.';

  @override
  String get weatherUnavailable =>
      'آب و هوا برای این مکان و زمان در دسترس نیست.';

  @override
  String get weatherRemove => 'آب و هوا را حذف کنید';

  @override
  String get activityTitle => 'فعالیت';

  @override
  String get activityStill => 'هنوز';

  @override
  String get activityWalking => 'راه رفتن';

  @override
  String get activityRunning => 'در حال دویدن';

  @override
  String get activityCycling => 'دوچرخه سواری';

  @override
  String get activityVehicle => 'در یک وسیله نقلیه';

  @override
  String get activityFlying => 'پرواز کردن';

  @override
  String get activityExercise => 'ورزش کنید';

  @override
  String get activityDetect => 'شناسایی فعالیت فعلی';

  @override
  String get activityDetectFailed => 'فعالیتی شناسایی نشد.';

  @override
  String get activityRemove => 'حذف فعالیت';

  @override
  String get settingsAutoAddTitle => 'به صورت خودکار اضافه کنید';

  @override
  String get settingsAutoAddLocation => 'مکان';

  @override
  String get settingsAutoAddWeather => 'آب و هوا';

  @override
  String get settingsAutoAddHint =>
      'ورودی های جدید پس از ایجاد این موارد پر می شوند.';

  @override
  String get settingsTemperatureUnit => 'واحد دما';

  @override
  String get settingsCelsius => 'درجه سانتیگراد (درجه سانتیگراد)';

  @override
  String get settingsFahrenheit => 'فارنهایت (درجه فارنهایت)';

  @override
  String get moodGreat => 'عالیه';

  @override
  String get moodGood => 'خوب';

  @override
  String get moodOkay => 'باشه';

  @override
  String get moodBad => 'بد';

  @override
  String get moodAwful => 'افتضاح';

  @override
  String get locationSearchHint => 'جستجو برای یک مکان';

  @override
  String get locationSearchEmpty => 'هیچ مکانی یافت نشد';

  @override
  String get settingsWallpaper => 'کاغذ دیواری';

  @override
  String get wallpaperNone => 'هیچ کدام';

  @override
  String get wallpaperDots => 'نقطه ها';

  @override
  String get wallpaperGrid => 'شبکه';

  @override
  String get wallpaperLines => 'خطوط';

  @override
  String get wallpaperPhoto => 'عکس…';

  @override
  String get settingsFontFamily => 'فونت';

  @override
  String get fontSystem => 'سیستم';

  @override
  String get fontSerif => 'سریف';

  @override
  String get fontMono => 'تک فضا';

  @override
  String get settingsFontSize => 'اندازه فونت';

  @override
  String get fontSizeSmall => 'کوچک';

  @override
  String get fontSizeMedium => 'متوسط';

  @override
  String get fontSizeLarge => 'بزرگ';

  @override
  String get fontSizeExtraLarge => 'فوق العاده بزرگ';

  @override
  String get settingsLineSpacing => 'فاصله خطوط';

  @override
  String get lineSpacingCompact => 'فشرده';

  @override
  String get lineSpacingNormal => 'عادی';

  @override
  String get lineSpacingRelaxed => 'آرام';

  @override
  String get moodAssociationsTitle => 'چه احساسی به من می دهد…';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching از ورودی های $total';
  }

  @override
  String get videoRecord => 'یک ویدیو ضبط کنید';

  @override
  String get videoChoose => 'یک ویدیو را انتخاب کنید';

  @override
  String get audioRecordTitle => 'یک یادداشت صوتی ضبط کنید';

  @override
  String get audioChoose => 'یک فایل صوتی را انتخاب کنید';

  @override
  String get audioStart => 'ضبط کنید';

  @override
  String get audioStop => 'توقف کنید و ذخیره کنید';

  @override
  String get audioPermissionDenied =>
      'دسترسی به میکروفون خاموش است. در تنظیمات سیستم اجازه دهید.';

  @override
  String get mediaTooLarge => 'این ویدیو برای پیوست خیلی بزرگ است.';

  @override
  String get mediaUnavailable => 'این پیوست در این دستگاه موجود نیست.';

  @override
  String get widgetDone => 'ورودی امروز نوشته شده است';

  @override
  String get widgetPending => 'روزت چطور بود؟';

  @override
  String get widgetWrite => 'بنویسید';

  @override
  String get insertChecklist => 'چک لیست';

  @override
  String get insertNumberedList => 'لیست شماره گذاری شده';

  @override
  String get insertTable => 'جدول';

  @override
  String get insertDivider => 'تقسیم کننده';

  @override
  String get insertCodeBlock => 'بلوک کد';

  @override
  String get journalSortTitle => 'مرتب سازی ورودی ها';

  @override
  String get journalSortUpdated => 'آخرین به روز رسانی';

  @override
  String get settingsTimeFormat => 'فرمت زمان';

  @override
  String get settingsDayStart => 'ورودی های جدید برای روز قبل تا';

  @override
  String get settingsDayAskUntil => 'سپس بپرسید تا کدام روز';

  @override
  String get settingsDayStartMidnight => 'خاموش';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'هر ورودی روزی را که متعلق به آن است در کنار زمانی که نوشته شده نگه می دارد و شما می توانید آن روز را در ویرایشگر هر زمان که بخواهید تغییر دهید. این ساعت‌ها فقط روز را برای ورودی‌های جدید انتخاب می‌کنند، بنابراین تغییر آنها هیچ ورودی موجود را جابه‌جا نمی‌کند.';

  @override
  String get lateNightBadge =>
      'نوشته شده در اواخر شب، برای روز قبل حساب شده است';

  @override
  String editorDayAsk(String time) {
    return 'نوشته شده در $time. برای کدام روز است؟';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (دیروز)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (امروز)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'نوشته $when';
  }

  @override
  String get timeFormat12 => '12 ساعته';

  @override
  String get timeFormat24 => '24 ساعته';

  @override
  String get settingsReminderDays => 'به من یادآوری کن';

  @override
  String get locationRecent => 'مکان های اخیر';

  @override
  String get shareImage => 'تصویر را به اشتراک بگذارید';

  @override
  String get shareSaveImage => 'ذخیره تصویر';

  @override
  String get shareSaved => 'تصویر ذخیره شد';

  @override
  String get deletedTitle => 'اخیراً حذف شده است';

  @override
  String get deletedNone => 'اخیراً چیزی حذف نشده است';

  @override
  String deletedHint(int days) {
    return 'ورودی های حذف شده برای روز $days در اینجا می مانند، سپس پاک می شوند.';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days روز باقی مانده است';
  }

  @override
  String get deletedRestore => 'بازیابی کنید';

  @override
  String get deletedDeleteForever => 'برای همیشه حذف کنید';

  @override
  String get deletedDeleteForeverDescription =>
      'ورودی و پیوست های آن پاک می شوند. این قابل واگرد نیست.';

  @override
  String get deletedEmpty => 'خالی';

  @override
  String get deletedEmptyDescription =>
      'هر ورودی در Recently deleted پاک شود؟ این قابل واگرد نیست.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'پیاده روی تصادفی';

  @override
  String get randomSubtitle => 'ورودی گذشته را باز کنید';

  @override
  String get randomNext => 'دیگری';

  @override
  String get randomAll => 'همه';

  @override
  String get randomWithPhotos => 'با عکس';

  @override
  String get randomGoodDays => 'روزهای خوب';

  @override
  String get randomEmpty => 'هیچ ورودی برای انتخاب وجود ندارد';

  @override
  String get reviewWeekTitle => 'این هفته';

  @override
  String get reviewWeekSubtitle => 'هفته شما تا الان';

  @override
  String get reviewYearTitle => 'امسال';

  @override
  String get reviewEmpty => 'هنوز چیزی نوشته نشده';

  @override
  String get reviewEntries => 'ورودی ها';

  @override
  String get reviewDaysWritten => 'روز نوشته شده است';

  @override
  String get reviewWords => 'کلمات';

  @override
  String get reviewPhotos => 'عکس ها';

  @override
  String get reviewLongestRun => 'طولانی ترین اجرا روز';

  @override
  String get reviewAverageMood => 'خلق و خوی متوسط';

  @override
  String get reviewFavorites => 'اغلب اوقات';

  @override
  String get reviewByMonth => 'بر اساس ماه';

  @override
  String get reviewHighlight => 'برجسته کردن';

  @override
  String get yearInPixels => 'سال بر حسب پیکسل';

  @override
  String get capsuleSeal => 'به عنوان کپسول زمان مهر و موم کنید';

  @override
  String get capsuleTitle => 'کپسول زمان';

  @override
  String capsuleOpensOn(Object date) {
    return 'در $date باز می شود';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'نوشته شده در $date';
  }

  @override
  String get capsuleOpenEarly => 'زود باز کن';

  @override
  String get capsuleOpenEarlyDescription =>
      'کپسول اکنون باز می شود و باز می ماند.';

  @override
  String get capsuleOpened => 'کپسول زمان باز شد';

  @override
  String get templateMorningName => 'صفحات صبحگاهی';

  @override
  String get templateMorningDescription => 'روز را در سه دقیقه تنظیم کنید';

  @override
  String get templateMorningText =>
      '## سه کاری که امروز می خواهم به خوبی انجام دهم\n1. \n2. \n3. \n\n## چیزی که منتظرش هستم\n\n## یادداشتی برای خودم\n';

  @override
  String get templateEveningName => 'نقد شبانه';

  @override
  String get templateEveningDescription => 'روز را با آنچه خوب پیش رفت ببندید';

  @override
  String get templateEveningText =>
      '## سه چیز خوب امروز\n1. \n2. \n3. \n\n## چیزی که یاد گرفتم\n\n## چه چیزی می تواند بهتر از فردا باشد\n';

  @override
  String get routineMorning => 'صبح بخیر';

  @override
  String get routineEvening => 'نقد شبانه';

  @override
  String get settingsRoutinePrompts => 'هشدارهای صبح و عصر';

  @override
  String get settingsRoutinePromptsHint =>
      'الگوی صبح یا عصر را در Stories پیشنهاد دهید';

  @override
  String get checkInTitle => 'ورود سریع';

  @override
  String get checkInSubtitle => 'حالت در دو شیر';

  @override
  String get checkInMood => 'چه احساسی دارید؟';

  @override
  String get checkInActivity => 'چیکار میکنی؟';

  @override
  String get checkInNote => 'یک خط در مورد آن (اختیاری)';

  @override
  String get checkInSave => 'ذخیره کنید';

  @override
  String editorWordCount(int words, int characters) {
    return 'کلمات $words · کاراکترهای $characters';
  }

  @override
  String get coachProgramEverydayTagline =>
      'به چیزهای کوچک در یک روز توجه کنید.';

  @override
  String get coachProgramReflectTagline =>
      'سرعت خود را کم کنید و به خودتان گوش دهید.';

  @override
  String get coachDuration => 'مدت زمان';

  @override
  String get coachInterval => 'فاصله';

  @override
  String get coachDifficulty => 'دشواری';

  @override
  String get coachIntervalDaily => 'روزانه';

  @override
  String get coachIntervalWeekly => 'هفتگی';

  @override
  String get coachDifficultyBeginner => 'مبتدی';

  @override
  String get coachDifficultyIntermediate => 'متوسط';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count روز',
      one: '$count روز',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count هفته',
      one: '$count هفته',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'روز $n';
  }

  @override
  String coachWeekN(int n) {
    return 'هفته $n';
  }

  @override
  String get coachEnroll => 'ثبت نام کنید';

  @override
  String get coachEndProgram => 'پایان برنامه';

  @override
  String get coachAuthor => 'نویسنده';

  @override
  String get coachAuthorBio => 'دستورات نوشته شده برای این برنامه';

  @override
  String get coachEnrolledTip =>
      'همه چیز آماده است! سوالات شما در Stories نمایش داده می شود.';

  @override
  String get coachGoToStories => 'به داستان بروید';

  @override
  String get coachAnswerHint => 'پاسخ خود را بنویسید…';

  @override
  String get storyWrapUp => 'این همه برای امروز است.';

  @override
  String get storyTapToClose => 'برای بستن ضربه بزنید';

  @override
  String get coachAnswerDone => 'انجام شد';

  @override
  String get coachAnswered => 'پاسخ داده شد، برای باز کردن ضربه بزنید';

  @override
  String get coachAnsweredEarlier => 'پاسخ داد';

  @override
  String get locationLocating => 'در حال مکان یابی…';

  @override
  String get locationPickPlace => 'مکانی را انتخاب کنید';

  @override
  String get locationPlacesHint => 'آدرس یا نام مکان';

  @override
  String get locationCustom => 'مکان سفارشی';

  @override
  String get locationCurrent => 'مکان فعلی';

  @override
  String get locationSaved => 'مکان های ذخیره شده';

  @override
  String get locationSearchResults => 'نتایج جستجو';

  @override
  String get locationNearby => 'مکان های نزدیک';

  @override
  String get locationRename => 'تغییر نام دهید';

  @override
  String get locationSavePlace => 'ذخیره مکان';

  @override
  String get locationUnsavePlace => 'حذف از مکان های ذخیره شده';

  @override
  String get shareAs => 'اشتراک گذاری به عنوان…';

  @override
  String get shareAsImage => 'تصویر';

  @override
  String get shareAsZip => 'ZIP با رسانه اصلی';

  @override
  String get shareAsPlainText => 'متن ساده';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'به AID Diary خوش آمدید';

  @override
  String get onboardWelcomeText =>
      'از اینجا شروع کنید یا این دستگاه را به دستگاهی که قبلاً استفاده می‌کنید وصل کنید.';

  @override
  String get onboardStart => 'شروع به نوشتن کنید';

  @override
  String get helpFaq => 'سوالات متداول';

  @override
  String get helpFaq1Q => 'دفتر خاطرات من کجا ذخیره می شود؟';

  @override
  String get helpFaq1A =>
      'دفتر خاطرات شما در این دستگاه ذخیره می شود. تنها زمانی به دستگاه‌ها یا فضای ذخیره‌سازی دیگر دسترسی پیدا می‌کند که همگام‌سازی، اشتراک‌گذاری یا صادر کردن آن را فعال کنید. همگام سازی سرتاسر رمزگذاری شده است.';

  @override
  String get helpFaq2Q =>
      'چگونه یک کپی را نگه دارم یا به یک دستگاه جدید منتقل کنم؟';

  @override
  String get helpFaq2A =>
      'در تنظیمات ← داده و ذخیره سازی ← همگام سازی به دستگاه موجود متصل شوید و مجوز را در دستگاهی که دفترچه خاطرات شما دارد تأیید کنید. هر دو دستگاه قابل استفاده باقی می مانند. همچنین می توانید یک نسخه پشتیبان تهیه کرده و آن را در دستگاه دیگری بازیابی کنید.';

  @override
  String get helpFaq3Q =>
      'آیا می توانم ورودی های دیگر برنامه های دفتر خاطرات را وارد کنم؟';

  @override
  String get helpFaq3A =>
      'بله: در تنظیمات ← داده و ذخیره سازی، صادرات را از Daylio، Diarium، Diaro، DayBook، My Brain، OneShot و Pixels یا صادرات JSON وارد کنید.';

  @override
  String get helpFaq4Q => 'برنامه های کوچ چگونه کار می کنند؟';

  @override
  String get helpFaq4A =>
      'در یک برنامه در صفحه مربی ثبت نام کنید. هر روز یا هفته یک سوال جدید در Stories منتظر می ماند. پاسخ شما به عنوان یک ورودی ذخیره می شود.';

  @override
  String get helpFaq5Q => 'اگر رمز عبورم را فراموش کنم چه؟';

  @override
  String get helpFaq5A =>
      'رمز عبور قابل بازیابی نیست، بنابراین یک نسخه پشتیبان از دفترچه خاطرات خود نگه دارید.';

  @override
  String get helpPrivacy => 'حریم خصوصی';

  @override
  String get helpPrivacyText =>
      'محتوای خاطرات و رسانه در این دستگاه باقی می‌ماند مگر اینکه همگام‌سازی رمزگذاری شده را فعال کنید یا آنها را به اشتراک بگذارید/صادر کنید. نقشه‌ها، جستجوی مکان و آب‌وهوا از خدمات پیکربندی‌شده استفاده می‌کنند و مکان یا جستجوی مورد نیاز برای آن درخواست را ارسال می‌کنند، نه متن خاطرات.';

  @override
  String get photoMetaTitle => 'از جزئیات عکس استفاده کنید؟';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'این ورودی را برای $date حساب کنید و جای آن را همانطور که در عکس ثبت شده روی $place قرار دهید؟';
  }

  @override
  String photoMetaDate(String date) {
    return 'این ورودی را برای $date، زمانی که عکس گرفته شده است، بشمارید؟';
  }

  @override
  String photoMetaPlace(String place) {
    return 'مکان این ورودی را روی $place، جایی که عکس گرفته شده است، تنظیم کنید؟';
  }

  @override
  String get photoMetaApply => 'از آنها استفاده کنید';

  @override
  String get quickWriteTitle => 'سریع بنویس';

  @override
  String get quickWriteText => 'برای شروع یک ورودی جدید ضربه بزنید.';

  @override
  String get settingsQuickWriteTitle => 'نوشتن سریع در اعلان ها';

  @override
  String get settingsQuickWriteDescription =>
      'یک اعلان نگه دارید که یک ورودی جدید را باز می کند.';

  @override
  String get settingsNudgesTitle => 'بعد از یک کشش آرام به من تکان دهید';

  @override
  String settingsNudgesDescription(int days) {
    return 'یک یادآوری ملایم زمانی که روز $days ننوشته اید.';
  }

  @override
  String get nudgeTitle => 'مدتی گذشت';

  @override
  String get nudgeMonday => 'یک هفته جدید: منتظر چه چیزی هستید؟';

  @override
  String get nudgeTuesday => 'دو خط کافی است. امروز چطوری؟';

  @override
  String get nudgeWednesday => 'در نیمه های هفته. چه چیزی تا اینجا برجسته بود؟';

  @override
  String get nudgeThursday => 'چیز کوچکی ارزش نگهداری از امروز را داشته باشد؟';

  @override
  String get nudgeFriday => 'هفته داره تموم میشه به یک لحظه خوب توجه کنید';

  @override
  String get nudgeSaturday => 'شنبه آهسته روز خوبی برای نوشتن است.';

  @override
  String get nudgeSunday => 'به هفته قبل از پایان آن نگاه کنید.';

  @override
  String get photoWidgetEmpty =>
      'عکس‌هایی که به ورودی‌ها اضافه می‌کنید در اینجا نشان داده می‌شوند.';

  @override
  String get channelReminders => 'یادآوری ها';

  @override
  String get channelOnThisDay => 'در این روز';

  @override
  String get channelCoach => 'مربی می گوید';

  @override
  String get channelNudges => 'تکان دادن بعد از روزهای آرام';

  @override
  String get channelQuickWrite => 'سریع بنویس';

  @override
  String get channelBackup => 'پشتیبان گیری';

  @override
  String get formatJsonExport => 'JSON (صادرات AID Diary)';

  @override
  String get aboutModifiedNotice =>
      'نسخه اصلاح شده Daily You توسط Demizo و همکاران. این برنامه رسمی روزانه شما نیست.';

  @override
  String get toolbarPhotos => 'عکس اضافه کنید';

  @override
  String get toolbarMedia => 'عکس و فیلم';

  @override
  String get mediaFromGallery => 'از گالری انتخاب کنید';

  @override
  String get mediaFromFiles => 'از بین فایل ها انتخاب کنید';

  @override
  String get editorLeaveTitle => 'این ورودی ذخیره شود؟';

  @override
  String get editorLeaveDiscard => 'پس انداز نکن';

  @override
  String get editorTitleHint => 'عنوان';

  @override
  String get editorLocating => 'در حال مکان یابی…';

  @override
  String get toolbarVideo => 'ویدئو';

  @override
  String get toolbarAudio => 'یادداشت صوتی';

  @override
  String get toolbarTags => 'برچسب ها';

  @override
  String get toolbarBulletList => 'لیست گلوله شده';

  @override
  String get toolbarHeading => 'سرفصل';

  @override
  String get toolbarBold => 'پررنگ';

  @override
  String get toolbarItalic => 'کج';

  @override
  String get toolbarHighlight => 'برجسته کردن';

  @override
  String get toolbarStrikethrough => 'ضربه زدن';

  @override
  String get toolbarQuote => 'نقل قول';

  @override
  String get toolbarLink => 'پیوند';

  @override
  String get toolbarInsert => 'درج کنید';

  @override
  String get toolbarUndo => 'واگرد';

  @override
  String get toolbarRedo => 'دوباره انجام دهید';

  @override
  String get toolbarInsertDate => 'تاریخ را درج کنید';

  @override
  String get toolbarInsertTime => 'زمان را درج کنید';

  @override
  String get settingsSyncTitle => 'همگام سازی ابری';

  @override
  String get syncOffDescription =>
      'این دفترچه خاطرات را در همه دستگاه های خود از طریق Google Drive یا سرور WebDAV مانند Nextcloud، Synology یا Jianguoyun یکسان نگه دارید.';

  @override
  String get syncUseGoogleDrive => 'همگام سازی با Google Drive';

  @override
  String get syncOrWebDav => 'یا سرور WebDAV';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn =>
      'وارد شده‌اید. می‌توانید به AID Diary برگردید.';

  @override
  String get syncGoogleSignInAgain =>
      'Google به شما نیاز دارد که دوباره وارد سیستم شوید.';

  @override
  String get syncSignInAgain => 'دوباره وارد شوید';

  @override
  String get settingsCommandLineTitle => 'خط فرمان';

  @override
  String get commandLineToggle => 'رابط خط فرمان';

  @override
  String get commandLineToggleHint =>
      'به دستور کمک و سایر برنامه‌های موجود در این دستگاه اجازه می‌دهد از دستورات برنامه استفاده کنند.';

  @override
  String get commandLineAlwaysOn => 'همیشه در توسعه می سازد.';

  @override
  String commandLineListening(int port) {
    return 'گوش دادن در پورت $port';
  }

  @override
  String get commandPaletteTitle => 'همه دستورات';

  @override
  String get commandPaletteSearch => 'دستورات جستجو';

  @override
  String get commandPaletteRun => 'اجرا کنید';

  @override
  String get commandPaletteConfirm =>
      'این را نمی توان به سادگی واگرد کرد. اجراش کنم؟';

  @override
  String syncReceiving(int done, int total) {
    return 'در حال دریافت $done از $total…';
  }

  @override
  String syncSending(int done, int total) {
    return 'ارسال $done از $total…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'دسترسی به Google Drive مجاز نبود. دوباره وصل شوید و Google Drive را در صفحه گوگل علامت بزنید.';

  @override
  String get syncEntryUnsynced => 'همگام‌سازی نشد: آخرین همگام‌سازی انجام نشد';

  @override
  String get syncUseOfficial => 'از سرور همگام سازی AID استفاده کنید';

  @override
  String get syncServer => 'آدرس سرور';

  @override
  String get syncUsername => 'نام کاربری';

  @override
  String get syncPassword => 'رمز عبور';

  @override
  String get syncConnect => 'اتصال';

  @override
  String get syncConnecting => 'در حال اتصال…';

  @override
  String get syncSignInFailed =>
      'نمی توان وارد سیستم شد. آدرس، نام کاربری و رمز عبور را بررسی کنید.';

  @override
  String syncConnectFailed(String error) {
    return 'اتصال برقرار نشد: $error';
  }

  @override
  String get syncNewSpaceTitle => 'شروع به همگام سازی کنید';

  @override
  String get syncNewSpaceDescription =>
      'هنوز هیچ دفتر خاطرات همگام‌سازی شده‌ای در اینجا وجود ندارد. این دفترچه خاطرات بارگذاری می‌شود، رمزگذاری سرتاسر با کلیدی که در دستگاه‌های شما باقی می‌ماند.';

  @override
  String get syncJoinTitle => 'به دفتر خاطرات همگام سازی شده بپیوندید';

  @override
  String get syncWrongKey =>
      'این کد بازیابی دفترچه خاطرات همگام سازی شده را باز نمی کند.';

  @override
  String syncLastSynced(String time) {
    return 'آخرین همگام سازی $time';
  }

  @override
  String get syncNever => 'هنوز همگام سازی نشده است';

  @override
  String get syncSyncing => 'در حال همگام سازی…';

  @override
  String syncFailed(String error) {
    return 'آخرین همگام سازی ناموفق بود: $error';
  }

  @override
  String get syncLocked =>
      'دفتر خاطرات همگام‌سازی‌شده اکنون به دستگاه‌های دیگر تعلق دارد یا دوباره راه‌اندازی شده است. با یکی از آنها جفت کنید یا از کد بازیابی برای ادامه همگام سازی استفاده کنید.';

  @override
  String get syncNow => 'اکنون همگام سازی کنید';

  @override
  String get syncUnlock => 'باز کردن قفل';

  @override
  String get syncEncrypted => 'رمزگذاری سرتاسر';

  @override
  String get syncDisconnect => 'همگام سازی را متوقف کنید';

  @override
  String get syncDisconnectDescription =>
      'این دستگاه همگام سازی را متوقف می کند. دفترچه خاطرات در اینجا و نسخه همگام‌سازی شده همان‌طور که هستند باقی می‌مانند.';

  @override
  String get syncOwnRecoveryPassword => 'از رمز عبور بازیابی خودم استفاده کنم';

  @override
  String get syncRecoveryPassword => 'رمز بازیابی';

  @override
  String get syncRecoveryPasswordRepeat => 'رمز بازیابی را تکرار کنید';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'حداقل از کاراکترهای $min استفاده کنید';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'رمزهای عبور متفاوت است';

  @override
  String get syncRecoveryCode => 'کد بازیابی';

  @override
  String get syncRecoveryCodeTitle => 'کد بازیابی خود را ذخیره کنید';

  @override
  String get syncRecoveryCodeDescription =>
      'اگر همه دستگاه های شما گم شود، این کد دفتر خاطرات همگام سازی شده شما را بازیابی می کند. آن را در یک مدیریت رمز عبور یا روی کاغذ نگه دارید. فقط این یک بار نشان داده می شود.';

  @override
  String get syncRecoveryCodeCopied => 'کد بازیابی کپی شد';

  @override
  String get syncRecoveryCodeSaved => 'من آن را ذخیره کرده ام';

  @override
  String get syncJoinNeedsKey =>
      'این دفتر خاطرات همگام‌سازی شده متعلق به دستگاه‌های دیگر شماست. با یکی از آنها جفت کنید یا از کد بازیابی استفاده کنید. ورودی های این دستگاه به آن اضافه می شود.';

  @override
  String get syncPairDevice => 'جفت شدن با دستگاه';

  @override
  String get syncUseRecoveryCode => 'از کد بازیابی استفاده کنید';

  @override
  String get syncAddDevice => 'یک دستگاه اضافه کنید';

  @override
  String get syncChangeRecoveryCode => 'کد بازیابی را تغییر دهید';

  @override
  String get syncChangeRecoveryDescription =>
      'یک کد جدید جایگزین کد فعلی می شود که کار نمی کند. داده های شما و سایر دستگاه ها به همان شکلی که هستند باقی می مانند.';

  @override
  String get syncNewRandomCode => 'کد تصادفی جدید';

  @override
  String get syncRecoveryCodeChanged => 'کد بازیابی تغییر کرد';

  @override
  String get syncResetSpace => 'دفتر خاطرات همگام سازی شده را دوباره شروع کنید';

  @override
  String get syncResetSpaceDescription =>
      'فقط زمانی که هیچ دستگاهی و هیچ کد بازیابی دیگر آن را باز نمی‌کند: نسخه همگام‌سازی شده با دفترچه خاطرات این دستگاه، زیر کلیدهای این دستگاه جایگزین می‌شود. سپس دستگاه های دیگر شما دوباره جفت می شوند.';

  @override
  String get syncPairTitle => 'دستگاه ها را جفت کنید';

  @override
  String get syncPairShow => 'نمایش یک کد';

  @override
  String get syncPairEnter => 'یک کد وارد کنید';

  @override
  String get syncPairShowHint =>
      'در دستگاه دیگر خود، Pair devices را باز کنید، رمز را وارد کنید و آن را تایپ یا اسکن کنید.';

  @override
  String get syncPairEnterHint =>
      'کدی را که دستگاه دیگرتان نشان می دهد تایپ کنید یا آن را اسکن کنید.';

  @override
  String get syncPairCode => 'کد جفت شدن';

  @override
  String get syncPairScan => 'اسکن کنید';

  @override
  String get syncPairStart => 'جفت کردن';

  @override
  String get syncPairWaiting => 'در انتظار دستگاه دیگر…';

  @override
  String syncPairDone(String device) {
    return 'با $device جفت شده است';
  }

  @override
  String get syncPairWrongCode =>
      'کد مطابقت نداشت. یک کد جدید نشان دهید و دوباره امتحان کنید.';

  @override
  String get syncPairNoOffer =>
      'هیچ دستگاهی این کد را نشان نمی دهد. ممکن است منقضی شده باشد.';

  @override
  String get syncPairTimedOut => 'دستگاه دیگر به موقع جواب نداد.';

  @override
  String get syncPairNeither =>
      'هیچ‌یک از دستگاه‌ها هنوز با این دفترچه خاطرات همگام‌سازی شده راه‌اندازی نشده‌اند.';

  @override
  String get syncPairBoth =>
      'هر دو دستگاه قبلاً این دفترچه خاطرات همگام‌سازی شده را باز کرده‌اند.';

  @override
  String syncPairFailed(String error) {
    return 'جفت شدن ناموفق بود: $error';
  }

  @override
  String get syncMediaPending =>
      'دفتر خاطرات همگام سازی شد · برخی رسانه ها هنوز در حال انتقال هستند';

  @override
  String get syncWaitingForDevices =>
      'دفتر خاطرات همگام سازی شد · منتظر دستگاه دیگری برای انتقال رسانه';

  @override
  String get syncCacheNotice =>
      'رسانه ابری موقتی است. نسخه اصلی را در دستگاه های خود نگه دارید. همگام سازی یک نسخه پشتیبان نیست.';

  @override
  String get paperTitle => 'کاغذ نامه';

  @override
  String get paperPlain => 'دشت';

  @override
  String get paperLined => 'خط کشی شده';

  @override
  String get paperGrid => 'شبکه';

  @override
  String get paperTinted => 'رنگی';

  @override
  String get paperDecorationTitle => 'تزئینات';

  @override
  String get paperDecorationNone => 'هیچ کدام';

  @override
  String get paperDecorationBotanical => 'برگ';

  @override
  String get paperDecorationStars => 'ستاره ها';

  @override
  String get paperDecorationWashi => 'نوار واشی';

  @override
  String get themeDarkChoice => 'ظاهر تاریک';

  @override
  String get themeDarkSame => 'از پالت نور پیروی کنید';

  @override
  String get themeDarkCustom => 'پالت مجزا';

  @override
  String get themeDarkAccent => 'رنگ تاکیدی تیره';

  @override
  String get themeColorTeal => 'آبی رنگ';

  @override
  String get themeColorCyan => 'فیروزه ای';

  @override
  String get themeColorIndigo => 'نیل';

  @override
  String get themeColorCoral => 'مرجان';

  @override
  String get themeColorOlive => 'زیتون';

  @override
  String get themeColorSlate => 'تخته سنگ';

  @override
  String get drawingTitle => 'طراحی';

  @override
  String get drawingPen => 'قلم';

  @override
  String get drawingEraser => 'پاک کن';

  @override
  String get drawingUndo => 'واگرد';

  @override
  String get drawingClear => 'پاک کردن';

  @override
  String get drawingWidth => 'عرض قلم';

  @override
  String get drawingStylusOnly => 'فقط قلم';

  @override
  String get drawingDiscardTitle => 'از طراحی صرفنظر شود؟';

  @override
  String get drawingDiscardBody => 'این طراحی ذخیره نشده است.';

  @override
  String get drawingSaveError => 'طراحی ذخیره نشد.';

  @override
  String get syncNetworkTitle => 'عیب یابی شبکه';

  @override
  String get syncNetworkRefresh => 'تازه کردن';

  @override
  String get syncNetworkSelectedRoute => 'مسیر فعلی';

  @override
  String get syncNetworkAvailableRoutes => 'مسیرهای موجود';

  @override
  String get syncNetworkSignaling => 'اتصال دایرکتوری دستگاه';

  @override
  String get syncNetworkRelayRemaining => 'کمک هزینه رله باقی مانده';

  @override
  String get syncNetworkIcePair => 'نامزدهای ارتباط مستقیم';

  @override
  String get syncNetworkPeerTrusted => 'دستگاه تایید شده';

  @override
  String get syncNetworkNoRoute => 'در انتظار اتصال';

  @override
  String get syncNetworkUnavailable => 'تشخیص در دسترس نیست';

  @override
  String get syncMediaCopiesTitle => 'تحویل رسانه و کپی';

  @override
  String get syncMediaPendingCount => 'در انتظار انتقال';

  @override
  String get syncMediaDurableCount => 'تحویل به انبار شخصی';

  @override
  String get syncMediaTemporaryCount => 'کپی های موقت یا تایید نشده';

  @override
  String get syncMediaReceiptExplanation =>
      'این شمارش ها تحویل کامل شده را توصیف می کنند، نه یک ممیزی جدید از نسخه های پشتیبان باقی مانده.';

  @override
  String get syncMediaCacheExplanation =>
      'رسانه ابری موقت ممکن است منقضی شود. نسخه اصلی یا یک نسخه پشتیبان جداگانه را نگه دارید.';

  @override
  String get momentsTitle => 'عکس لحظه ها';

  @override
  String get momentsHint =>
      'گروه‌ها را با استفاده از زمان‌های عکس محلی و مختصات اختیاری پیدا کنید. عکس ها فقط زمانی پیوست می شوند که کارتی را انتخاب می کنید.';

  @override
  String get momentsScan => 'لحظه ها را پیدا کنید';

  @override
  String get momentsChooseFolder => 'پوشه عکس را انتخاب کنید';

  @override
  String get momentsLocation => 'شامل مکان های عکس';

  @override
  String get momentsEmpty => 'هیچ گروه عکس اخیری وجود ندارد.';

  @override
  String get momentsCreate => 'در مورد این عکس ها بنویس';

  @override
  String get momentsDismiss => 'رد کردن';

  @override
  String get momentsError => 'نمی توان عکس های محلی را خواند.';

  @override
  String get momentsCreated => 'ورودی عکس ایجاد شد.';

  @override
  String get momentsPermission =>
      'برای یافتن پیشنهادهای محلی به عکس‌ها اجازه دسترسی بدهید.';

  @override
  String get momentsScope =>
      'فقط عکس های اخیر؛ حداکثر 500 عکس و 20 عکس در هر کارت.';

  @override
  String momentsPhotoCount(int count) {
    return 'عکس های $count';
  }

  @override
  String get nearbyTitle => 'دستگاه ها را وصل کنید';

  @override
  String get nearbySend => 'مجوز دستگاه دیگری را صادر کنید';

  @override
  String get nearbyReceive => 'به یک دستگاه موجود متصل شوید';

  @override
  String get nearbyInstructions =>
      'هر دو دستگاه را به یک Wi-Fi یا به هات اسپات یکدیگر متصل کنید. تأیید مجوز در دستگاه موجود؛ هر دو دستگاه قابل استفاده باقی می مانند. نیازی به اینترنت نیست';

  @override
  String get nearbyCompare =>
      'قبل از تایید این کد را در هر دو دستگاه مقایسه کنید.';

  @override
  String get nearbyConfirm => 'کدها مطابقت دارند';

  @override
  String get nearbyScan => 'کد دستگاه دیگر را اسکن کنید';

  @override
  String get nearbyPaste => 'چسباندن دعوت نامه';

  @override
  String get nearbyWaiting => 'در انتظار تایید در دستگاه دیگر';

  @override
  String get nearbyWorking => 'مجوز و همگام سازی خاطرات و پیوست های شما…';

  @override
  String get nearbyPending =>
      'برخی از پیوست‌ها همچنان نیاز به همگام‌سازی دارند. دستگاه دیگر را آنلاین نگه دارید و دوباره امتحان کنید.';

  @override
  String get nearbyComplete => 'دستگاه متصل؛ خاطرات و پیوست ها همگام سازی شدند';

  @override
  String get nearbyFailed =>
      'اتصال تمام نشد. اتصال محلی را بررسی کنید و دوباره امتحان کنید.';

  @override
  String get nearbyEmptyRequired =>
      'از دستگاهی با دفترچه خاطرات خالی استفاده کنید که هنوز به همگام سازی متصل نشده است.';

  @override
  String get nearbyRetry => 'به همگام سازی ادامه دهید';

  @override
  String get nearbyWifi => 'تنظیمات Wi-Fi';

  @override
  String get nearbyHotspot => 'تنظیمات هات اسپات';

  @override
  String get nearbyKeepOpen =>
      'این صفحه را تا پایان کار دستگاه جدید باز نگه دارید. دعوتنامه پس از دو دقیقه منقضی می شود.';

  @override
  String get syncDevicesTitle => 'دستگاه های مجاز';

  @override
  String get syncDevicesDescription =>
      'فقط دستگاه های تایید شده می توانند به این حساب AID دسترسی داشته باشند. باطل کردن یک دستگاه سرور را مسدود می کند اما نمی تواند کلید اصلی یا دفترچه خاطراتی را که قبلاً در آن کپی شده است پاک کند.';

  @override
  String get syncDeviceRequest =>
      'این QR مجوز را به یک دستگاه تأیید شده نشان دهید';

  @override
  String get syncDeviceAuthorize => 'مجوز یک دستگاه';

  @override
  String get syncDeviceAuthorizeDescription =>
      'درخواست مجوز دستگاه جدید را اسکن یا جایگذاری کنید.';

  @override
  String get syncDeviceRevoke => 'لغو';

  @override
  String get syncDeviceRotate => 'کلید امضای این دستگاه را بچرخانید';

  @override
  String get syncDeviceCheck => 'مجوز را بررسی کنید';

  @override
  String get syncDeviceHardware => 'کلید امضای سخت افزاری';

  @override
  String get syncDeviceSoftware => 'کلید امضای نرم افزار غیر قابل صادرات';

  @override
  String get syncDeviceUnavailable =>
      'مجوز دستگاه در دسترس نیست. این دستگاه را از دستگاه مجاز دیگری تأیید کنید و دوباره امتحان کنید.';

  @override
  String get syncDeviceRevoked => 'لغو شد';

  @override
  String get syncDeviceLocal => 'این دستگاه';

  @override
  String get cloudTrafficTitle =>
      'سهمیه ماهانه انتقال داده ابری برای فایل های رسانه ای';

  @override
  String get cloudTrafficLimit => 'سهمیه انتقال داده ماهانه';

  @override
  String get cloudTrafficUsed => 'انتقال داده استفاده شده است';

  @override
  String get cloudTrafficRemaining => 'انتقال داده باقی مانده است';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'سهمیه انتقال داده $time را بازنشانی می کند';
  }

  @override
  String get cloudTrafficExhausted =>
      'سهمیه انتقال داده های ابری برای فایل های رسانه ای تمام شده است. هنگامی که اتصال مستقیم در دسترس باشد یا سهمیه بازنشانی شود، فایل‌های رسانه از دست رفته به‌طور خودکار همگام‌سازی می‌شوند.';

  @override
  String get cloudTrafficExplanation =>
      'ذخیره فایل رسانه ای و رله زنده این سهمیه انتقال داده را به اشتراک می گذارند. اتصالات مستقیم آن را مصرف نمی کنند. متن خاطرات و پیام های کنترل اتصال محدودیت های روزانه کوچک جداگانه ای دارند.';

  @override
  String get appearanceThemeSection => 'تم برنامه';

  @override
  String get appearancePaperSection => 'کاغذ خاطرات';

  @override
  String get appearanceTypographySection => 'متن خاطرات';

  @override
  String get appearancePreferencesSection => 'ترجیحات عمومی';

  @override
  String get themeSystemAccentHint =>
      'از پالت سیستم به جای رنگ های سفارشی استفاده می کند. آن را خاموش کنید تا خودتان انتخاب کنید.';

  @override
  String get syncDeviceNameSaveFailed =>
      'نام دستگاه ذخیره نشد. لطفا دوباره امتحان کنید.';

  @override
  String get nearbyConnectionHelp => 'کمک اتصال';

  @override
  String get syncAllSynced => 'همه چیز همگام شد';

  @override
  String get syncDetailsTitle => 'همگام سازی جزئیات';

  @override
  String get syncMore => 'گزینه های بیشتر';

  @override
  String get syncDeviceName => 'نام دستگاه';

  @override
  String get syncDeviceNameHint => 'به عنوان مثال: تبلت من';

  @override
  String get syncDeviceNameInvalid => 'از 1 تا 32 کاراکتر استفاده کنید';

  @override
  String get syncDeviceKeyDetails => 'جزئیات امنیتی';

  @override
  String get syncConnectionProblem =>
      'در حال حاضر همگام سازی امکان پذیر نیست. در حال تلاش مجدد به صورت خودکار.';

  @override
  String get syncCopyComplete =>
      'کپی کامل از دفترچه خاطرات و فایل های رسانه ای';

  @override
  String get syncCopyPartial => 'برخی رسانه ها هنوز مفقود هستند';

  @override
  String get syncCopyOlder => 'تغییرات جدید در انتظار همگام سازی هستند';

  @override
  String get syncCopyUnavailable =>
      'جزئیات کپی در دسترس نیست. بعداً دوباره امتحان کنید.';

  @override
  String get syncCopyLastKnown =>
      'دستگاه های دیگر آخرین نسخه تایید شده خود را نشان می دهند. دستگاه های آفلاین اکنون قابل بررسی نیستند.';

  @override
  String get syncCopyTemporary =>
      'کش موقت نسخه اصلی را در دستگاه خود نگه دارید.';

  @override
  String get syncCopyStorage =>
      'فضای ذخیره سازی همگام سازی شما بارگذاری‌های رسانه‌ای تکمیل‌شده در عیب‌یابی فهرست شده‌اند.';

  @override
  String syncCopyChecked(String time) {
    return 'آخرین تایید $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'انتقال داده های باقی مانده در این ماه: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'از اینجا شروع کنید';

  @override
  String get onboardConnect => 'به یک دستگاه موجود متصل شوید';

  @override
  String get onboardFailed =>
      'راه اندازی کامل نشد. دفتر خاطرات شما امن است. لطفا دوباره امتحان کنید';

  @override
  String get tutorialTitle => 'نحوه استفاده از دفترچه خاطرات';

  @override
  String get tutorialWriteTitle => 'اولین مدخل خاطرات خود را بنویسید';

  @override
  String get tutorialWriteText =>
      'برای نوشتن یک دفترچه خاطرات روی + ضربه بزنید. یک عنوان اختیاری اضافه کنید، تاریخ خاطرات را انتخاب کنید و برای ذخیره روی علامت تیک بزنید. می‌توانید در هر زمانی که بخواهید دوباره یادداشت روزانه خود را ویرایش کنید.';

  @override
  String get tutorialMediaTitle => 'عکس، صدا یا دست خط اضافه کنید';

  @override
  String get tutorialMediaText =>
      'از + در ویرایشگر خاطرات برای پیوست کردن عکس‌ها، فیلم‌ها، یا ضبط صدا یا باز کردن بوم دست‌نویس استفاده کنید. این پیوست‌ها با ورودی خاطرات ذخیره می‌شوند.';

  @override
  String get tutorialReviewTitle => 'دوباره یک روز پیدا کن';

  @override
  String get tutorialReviewText =>
      'دفتر خاطرات یا تقویم خود را مرور کنید، نوشته های خود را جستجو کنید، و مدخل ها را با برچسب ها سازماندهی کنید. صفحات رسانه و اطلس به شما امکان می دهد ورودی های گذشته را بر اساس عکس یا مکان پیدا کنید.';

  @override
  String get tutorialSyncTitle => 'از بیش از یک دستگاه استفاده کنید';

  @override
  String get tutorialSyncText =>
      'در تنظیمات ← داده و ذخیره سازی ← همگام سازی، به دستگاه موجود متصل شوید و مجوز آن دستگاه را تأیید کنید. هر دو دستگاه می توانند به استفاده از دفترچه خاطرات ادامه دهند. متن خاطرات ابتدا همگام سازی می شود. زمانی که اتصال شبکه و سهمیه انتقال داده باقیمانده به آن اجازه می‌دهد، فایل‌های رسانه همگام‌سازی می‌شوند.';

  @override
  String get tutorialPrivacyTitle => 'دفتر خاطرات خود را ایمن نگه دارید';

  @override
  String get tutorialPrivacyText =>
      'نوشته های خاطرات در این دستگاه باقی می مانند مگر اینکه همگام سازی یا اشتراک گذاری یا صادر کردن آنها را فعال کنید. همگام سازی سرتاسر رمزگذاری شده است. در تنظیمات همچنین می‌توانید یک رمز عبور برنامه تنظیم کنید، پشتیبان‌گیری ایجاد کنید و این آموزش را دوباره باز کنید.';

  @override
  String get editorDiaryDay => 'روز یادداشت';

  @override
  String get editorDiaryDayPicker => 'روز یادداشت · زمان ایجاد ثابت است';

  @override
  String get editorDiaryDayHint =>
      'روزی که این یادداشت به آن تعلق دارد. تغییر آن، زمان ایجاد یادداشت را تغییر نمی‌دهد.';

  @override
  String get hiddenDiaryTitle => 'یادداشت‌های پنهان';

  @override
  String get hiddenDiaryHide => 'پنهان کردن یادداشت';

  @override
  String get hiddenDiaryShow => 'نمایش یادداشت';

  @override
  String get hiddenDiaryEmpty => 'یادداشت پنهانی وجود ندارد';

  @override
  String get hiddenDiaryUnlock => 'باز کردن یادداشت‌های پنهان';

  @override
  String get hiddenDiaryAuthHint =>
      'از قفل برنامه یا قفل صفحهٔ دستگاه استفاده کنید.';

  @override
  String get hiddenDiaryLocalOnly =>
      'یادداشت‌های پنهان در این دستگاه می‌مانند و همگام‌سازی متوقف می‌شود. از پشتیبان رمزگذاری‌شده استفاده کنید. نسخه‌های موجود در دستگاه‌های دیگر تغییر نمی‌کنند.';

  @override
  String get moodClear => 'پاک کردن حال‌وهوا';
}
