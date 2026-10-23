// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => 'لون الموضوع';

  @override
  String get themeColorHint => 'اختر لونًا لهذه اللوحة.';

  @override
  String get themeColorBlue => 'السماء الزرقاء';

  @override
  String get themeColorGreen => 'الغابة الخضراء';

  @override
  String get themeColorBrown => 'قهوة دافئة';

  @override
  String get themeColorPurple => 'لافندر';

  @override
  String get themeColorRose => 'وردة مغبرة';

  @override
  String get themeColorAmber => 'العنبر';

  @override
  String get themeColorPreview => 'قليلا كل يوم';

  @override
  String get themeTintBackgroundTitle => 'صبغ الخلفيات مع لون الموضوع';

  @override
  String get themeTintBackgroundHint =>
      'قم بإيقاف تشغيله للحصول على خلفيات رمادية محايدة؛ تحافظ الأزرار على اللون الذي اخترته.';

  @override
  String get dailyReminderTitle => 'سَجِّل اليوم!';

  @override
  String get dailyReminderDescription => 'خذ سجل يومياتك…';

  @override
  String get actionTakePhoto => 'التقط صورة';

  @override
  String get flashbacksTitle => 'الذكريات';

  @override
  String get settingsFlashbacksExcludeBadDays => 'استبعد الأيام السيئة';

  @override
  String get flashbackGoodDay => 'يوم جيد';

  @override
  String get flashbackRandomDay => 'يوم عشوائي';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ $count أسبوع',
      many: 'منذ $count أسبوعًا',
      few: 'منذ $count أسابيع',
      two: 'منذ أسبوعين',
      one: 'منذ أسبوع واحد',
      zero: 'منذ $count أسبوع',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ $count أشهر',
      one: 'منذ شهر واحد',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ $count سنوات',
      one: 'منذ سنة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'في مثل هذا اليوم';

  @override
  String get searchLogsHint => 'ابحث في السجلات…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count سجلات',
      one: '$count سجل',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أيام',
      one: '$count يوم',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count كلمات',
      one: '$count كلمة',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'لا توجد سجلات…';

  @override
  String get noResults => 'لا يوجد نتأج';

  @override
  String get sortOrderAscendingTitle => 'تصاعدي';

  @override
  String get sortOrderDescendingTitle => 'تنازلي';

  @override
  String get pageStatisticsTitle => 'إحصائيات';

  @override
  String get statisticsNotEnoughData => 'لا توجد بيانات كافية…';

  @override
  String get statisticsRangeOneMonth => 'شهر';

  @override
  String get statisticsRangeSixMonths => '٦ أشهر';

  @override
  String get statisticsRangeOneYear => 'سنة';

  @override
  String get statisticsRangeAllTime => 'كل الأوقات';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag الملخص';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag حسب اليوم';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag بمرور الوقت';
  }

  @override
  String get chartGroupingLabel => 'تجميع حسب';

  @override
  String get chartGroupingDay => 'اليوم';

  @override
  String get chartGroupingWeek => 'الأسبوع';

  @override
  String get chartGroupingMonth => 'الشهر';

  @override
  String get chartGroupingYear => 'السنة';

  @override
  String get chartSmoothingLabel => 'التنعيم';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'السلسلة الحالية $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'أطول سلسلة $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'أيام عظيمة $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'أيام منذ يوم سيء',
      one: 'يوم منذ يوم سيء',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'لا يمكن الوصول إلى وحدة التخزين الخارجية';

  @override
  String get errorExternalStorageAccessDescription =>
      'إذا كنت تستخدم التخزين عبر الانترنت تأكد من أن الخدمة متاحة ولديك وصول للشبكة.\n\nوإلا فقد يكون التطبيق فقد الأذونات للمجلد الخارجي. اذهب إلى الإعدادات وأعد اختيار المجلد الخارجي لمنح الوصول.\n\nتحذير، لن تتم مزامنة التغييرات حتى تستعيد الوصول إلى موقع التخزين الخارجي!';

  @override
  String get errorExternalStorageAccessContinue =>
      'متابعة مع قاعدة البيانات المحلية';

  @override
  String get lastModified => 'معدّل';

  @override
  String get writeSomethingHint => 'اكتب شيئًا…';

  @override
  String get titleHint => 'عنوان…';

  @override
  String get deleteLogTitle => 'احذف السجل';

  @override
  String get deleteLogDescription => 'هل تريد حذف هذا السجل؟';

  @override
  String get deletePhotoTitle => 'احذف الصورة';

  @override
  String get deletePhotoDescription => 'هل تريد حذف هذه الصورة؟';

  @override
  String get pageSettingsTitle => 'الإعدادات';

  @override
  String get settingsTheme => 'السمة';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeAmoled => 'أموليد';

  @override
  String get settingsFirstDayOfWeek => 'أول يوم في الأسبوع';

  @override
  String get settingsCalendarSystem => 'نظام التاريخ';

  @override
  String get calendarSystemGregorian => 'الميلادي';

  @override
  String get calendarSystemJalali => 'جلالي';

  @override
  String get settingsUseSystemAccentColor => 'استخدم ألوان النظام';

  @override
  String get settingsCustomAccentColor => 'لون مخصص';

  @override
  String get settingsShowFlashbacks => 'اعرض الذكريات';

  @override
  String get settingsChangeMoodIcons => 'غيِّر شكل الأيقونات';

  @override
  String get moodIconPrompt => 'أدخل أيقونة';

  @override
  String get settingsHideImages => 'إخفاء الصور';

  @override
  String get pageCalendarTitle => 'التقويم';

  @override
  String get settingsNotificationsTitle => 'الإشعارات';

  @override
  String get settingsDailyReminderTitle => 'تذكير يومي';

  @override
  String get settingsOnThisDayDescription => 'استرجع الذكريات الماضية';

  @override
  String get settingsDailyReminderDescription => 'تذكير لطيف كل يوم';

  @override
  String get settingsReminderTime => 'وقت التذكير';

  @override
  String get settingsFixedReminderTimeTitle => 'وقت التذكير الثابت';

  @override
  String get settingsFixedReminderTimeDescription =>
      'اختر وقتًا ثابتًا للتذكير';

  @override
  String get settingsAlwaysSendReminderTitle => 'أرسل تذكير دائمًا';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'أرسل تذكير حتى لو تم بدء السجل بالفعل';

  @override
  String get settingsCustomizeNotificationTitle => 'تخصيص الإشعارات';

  @override
  String get settingsTemplatesTitle => 'القوالب';

  @override
  String get manageTemplates => 'إدارة القوالب';

  @override
  String get noTemplateTitle => 'لا شيء';

  @override
  String get noTemplatesDescription => 'لم يتم إنشاء أي قوالب بعد…';

  @override
  String get templateDefaultTimestampTitle => 'الطابع الزمني';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'ملخص اليوم';

  @override
  String get templateDefaultSummaryBody => '### ملخص\n-\n\n### اقتباس\n> ';

  @override
  String get templateDefaultReflectionTitle => 'تأمل';

  @override
  String get templateDefaultReflectionBody =>
      '### ما الذي استمتعت به اليوم؟\n- \n\n### ما الذي تشعر بالامتنان تجاهه؟\n- \n\n### ما الذي تتطلع إليه؟\n- ';

  @override
  String get settingsTagsTitle => 'العلامات';

  @override
  String get manageTags => 'إدارة العلامات';

  @override
  String get tagTypeLabelTitle => 'التسمية';

  @override
  String get tagTypeTrackerTitle => 'أداة التتبع';

  @override
  String get nameHint => 'أسم';

  @override
  String get tagColorLabel => 'لون';

  @override
  String get iconPickerTitle => 'اختار الرمز';

  @override
  String get iconPickerIconsTab => 'الرموز';

  @override
  String get iconPickerCustomTab => 'مخصص';

  @override
  String get iconPickerSearchHint => 'ابحث الرموز…';

  @override
  String get colorPickerTitle => 'اختار اللون';

  @override
  String get colorPickerPaletteTab => 'الوان';

  @override
  String get iconGroupMoodPeople => 'المزاج والناس';

  @override
  String get iconGroupHealth => 'الصحة';

  @override
  String get iconGroupWorkFinance => 'العمل';

  @override
  String get iconGroupHabitsGoals => 'العادات والأهداف';

  @override
  String get iconGroupNature => 'الطبيعة';

  @override
  String get iconGroupFoodDrink => 'الطعام والشراب';

  @override
  String get iconGroupHome => 'الرئيسية';

  @override
  String get iconGroupTravel => 'السفر';

  @override
  String get iconGroupSymbols => 'رموز';

  @override
  String get tagCategoryLabel => 'فئة';

  @override
  String get tagLabel => 'علامة';

  @override
  String get tagCategoryUncategorized => 'غير مصنف';

  @override
  String get newCategoryTitle => 'فئة جديدة';

  @override
  String get shareButtonLabel => 'مشاركة';

  @override
  String get importErrorDescription => 'تعذّر استيراد الملف!';

  @override
  String get exportErrorDescription => 'تعذّر تصدير الملف!';

  @override
  String get deleteTitle => 'حذف';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      two: ' يتم استخدامه في $count إدخالات اليوميات.',
      other: ' يتم استخدامه في $count إدخالات يومية.',
      one: ' يتم استخدامه في إدخال يوميات واحد.',
      many: ' يتم استخدامه في $count إدخالات يومية.',
      few: ' يتم استخدامه في $count إدخالات يومية.',
      zero: '',
    );
    return 'هل تريد حذف \"$name\"؟$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      two: ' سيتم أيضًا حذف علامتيها.',
      other: ' سيتم أيضًا حذف علاماتها الـ $count.',
      one: ' سيتم أيضًا حذف علامة $count الخاصة به.',
      many: ' سيتم أيضًا حذف علاماتها الـ $count.',
      few: ' ستُحذف أيضًا وسومه الـ $count.',
      zero: '',
    );
    return 'هل تريد حذف \"$name\"؟$_temp0';
  }

  @override
  String get tagNameExists => 'هناك علامة بهذا الاسم بالفعل';

  @override
  String get categoryNameExists => 'هناك فئة بهذا الاسم بالفعل';

  @override
  String deleteTemplateMessage(Object name) {
    return 'حذف \"$name\"؟';
  }

  @override
  String get addTagsTitle => 'إضافة علامات';

  @override
  String get addTagsSearchHint => 'البحث عن علامات…';

  @override
  String get tagPickerSortManualLabel => 'ترتيب يدوي';

  @override
  String get tagPickerSortUsageLabel => 'الترتيب حسب الاستخدام';

  @override
  String get tagFavoriteName => 'المفضلة';

  @override
  String get tagEnergyName => 'الطاقة';

  @override
  String get tagCategoryActivitiesName => 'الأنشطة';

  @override
  String get tagExerciseName => 'تمارين';

  @override
  String get tagSocializingName => 'التواصل الاجتماعي';

  @override
  String get tagHobbyName => 'هواية';

  @override
  String get tagEntertainmentName => 'الترفيه';

  @override
  String get tagDiningName => 'تناول الطعام';

  @override
  String get tagChoresName => 'الأعمال اليومية';

  @override
  String get tagCategoryEmotionsName => 'العواطف';

  @override
  String get tagExcitedName => 'متحمس';

  @override
  String get tagGratefulName => 'ممتن';

  @override
  String get tagCalmName => 'الهدوء';

  @override
  String get tagTiredName => 'متعب';

  @override
  String get tagAnxiousName => 'قلق';

  @override
  String get tagAnnoyedName => 'منزعج';

  @override
  String get settingsStorageTitle => 'التخزين';

  @override
  String get settingsImageQuality => 'جودة الصورة';

  @override
  String get imageQualityHigh => 'عالية';

  @override
  String get imageQualityMedium => 'متوسطة';

  @override
  String get imageQualityLow => 'منخفضة';

  @override
  String get imageQualityNoCompression => 'بدون ضغط';

  @override
  String get settingsLogFolder => 'مجلد السجل';

  @override
  String get settingsImageFolder => 'مجلد الصور';

  @override
  String get warningTitle => 'تحذير';

  @override
  String get logFolderWarningDescription =>
      'إذا كان المجلد المحدد يحتوي بالفعل على ملف \"aid_diary.db\"، فسيتم استخدامه لاستبدال سجلاتك الحالية!';

  @override
  String get errorTitle => 'خطأ';

  @override
  String get logFolderErrorDescription => 'فشل في تغيير مجلد السجل!';

  @override
  String get imageFolderErrorDescription => 'فشل في تغيير مجلد الصور!';

  @override
  String get backupErrorDescription => 'فشل في إنشاء النسخة الاحتياطية!';

  @override
  String get restoreErrorDescription => 'فشل في استعادة النسخة الاحتياطية!';

  @override
  String get settingsBackupRestoreTitle => 'النسخ الاحتياطي والاستعادة';

  @override
  String get settingsBackup => 'النسخ الاحتياطي';

  @override
  String get settingsRestore => 'الاستعادة';

  @override
  String get settingsRestorePromptDescription =>
      'إن استعادة النسخة الاحتياطية سوف يؤدي إلى استبدال بياناتك الحالية!';

  @override
  String get settingsBackupPasswordProtect =>
      'حماية النسخ الاحتياطية بكلمة مرور';

  @override
  String get backupEncryptedTitle => 'النسخ الاحتياطي المشفرة';

  @override
  String get backupEncryptedContent =>
      'هذه النسخة الاحتياطية محمية بكلمة مرور.';

  @override
  String get settingsAutoBackup => 'النسخ الاحتياطية التلقائية';

  @override
  String get settingsAutoBackupLocation => 'موقع النسخ الاحتياطي';

  @override
  String get settingsAutoBackupInterval => 'الفاصل الزمني للنسخ الاحتياطي';

  @override
  String get settingsAutoBackupIntervalDaily => 'يوميا';

  @override
  String get settingsAutoBackupIntervalWeekly => 'أسبوعيا';

  @override
  String get settingsAutoBackupIntervalMonthly => 'شهريا';

  @override
  String get settingsAutoBackupMaxCount => 'النسخ الاحتياطية للاحتفاظ بها';

  @override
  String get settingsAutoBackupRequireCharging => 'فقط أثناء الشحن';

  @override
  String settingsBackupLast(Object time) {
    return 'آخر نسخة احتياطية $time';
  }

  @override
  String get settingsBackupNever => 'لم يتم الاحتفاظ بنسخة احتياطية أبدًا';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'النسخ الاحتياطي التالي $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'الكل';

  @override
  String get autoBackupFailedTitle => 'فشل النسخ الاحتياطي';

  @override
  String tranferStatus(Object percent) {
    return 'جارٍ النقل… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'جارٍ إنشاء نسخة احتياطية... $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'جارٍ استعادة النسخة الاحتياطية… $percent%';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return 'تشفير النسخة الاحتياطية… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'فك تشفير النسخة الاحتياطية… $percent%';
  }

  @override
  String get cleanUpStatus => 'جارٍ التنظيف…';

  @override
  String get settingsExportToAnotherFormat => 'التصدير إلى تنسيق آخر';

  @override
  String get settingsExportFormatDescription =>
      'لا ينبغي استخدام هذا كنسخة احتياطية!';

  @override
  String get settingsImportFromAnotherApp => 'الاستيراد من تطبيق آخر';

  @override
  String get logFormatTitle => 'اختر التنسيق';

  @override
  String get logFormatDescription =>
      'قد لا يدعم تنسيق تطبيق آخر جميع الميزات. يُرجى الإبلاغ عن أي مشاكل، إذ قد تتغير تنسيقات الجهات الخارجية في أي وقت. لن يؤثر هذا على السجلات الحالية!';

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
  String get formatOneShot => 'ون شوت';

  @override
  String get formatPixels => 'Pixels';

  @override
  String get formatMarkdown => 'ماركداون (markdown)';

  @override
  String get settingsDeleteAllLogsTitle => 'احذف جميع السجلات';

  @override
  String get settingsDeleteAllLogsDescription => 'هل تريد حذف كافة سجلاتك؟';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'أدخل \'$prompt\' للتأكيد. لا يمكن التراجع عن هذا!';
  }

  @override
  String get settingsAppLanguageTitle => 'لغة التطبيق';

  @override
  String get settingsSecurityTitle => 'الأمان';

  @override
  String get settingsSecurityRequirePassword => 'اطلب كلمة مرور';

  @override
  String get settingsSecurityEnterPassword => 'أدخل كلمة المرور';

  @override
  String get settingsSecuritySetPassword => 'تعيين كلمة المرور';

  @override
  String get settingsSecurityChangePassword => 'تغيير كلمة المرور';

  @override
  String get settingsSecurityPassword => 'كلمة المرور';

  @override
  String get settingsSecurityConfirmPassword => 'تأكيد كلمة المرور';

  @override
  String get settingsSecurityOldPassword => 'كلمة المرور القديمة';

  @override
  String get settingsSecurityIncorrectPassword => 'كلمة المرور غير صحيحة';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get requiredPrompt => 'مطلوب';

  @override
  String get settingsSecurityBiometricUnlock =>
      'افتح باستخدام القياسات الحيوية';

  @override
  String get unlockAppPrompt => 'افتح التطبيق';

  @override
  String get settingsAboutTitle => 'عن التطبيق';

  @override
  String get settingsVersion => 'الإصدار';

  @override
  String get settingsLicense => 'الرخصة';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsOpenSourceLicenses => 'تراخيص مفتوحة المصدر';

  @override
  String get tagMoodTitle => 'المزاج';

  @override
  String get selectTagTitle => 'حدد العلامة';

  @override
  String get labelPresentLabel => 'الحاضر';

  @override
  String get labelAbsentLabel => 'غائب';

  @override
  String get labelCoverageLabel => 'التغطية';

  @override
  String chartDistributionTitle(Object tag) {
    return 'توزيع $tag';
  }

  @override
  String get shareAddToLogPickerTitle => 'اختر إدخال اليوميات';

  @override
  String get adaptiveEmptyDay => 'لا توجد إدخالات لهذا اليوم حتى الآن';

  @override
  String get adaptiveNewEntry => 'اكتب إدخالا';

  @override
  String get pageJournalTitle => 'مجلة';

  @override
  String get coachPrompt1 => 'ما الذي جعلك تبتسم اليوم؟';

  @override
  String get coachPrompt2 => 'ما هو الشيء الوحيد الذي تعلمته اليوم؟';

  @override
  String get coachPrompt3 => 'مع من تحدثت اليوم وكيف كان شعورك؟';

  @override
  String get coachPrompt4 => 'ما الذي أنت ممتن له الآن؟';

  @override
  String get coachPrompt5 => 'ما الذي استهلك معظم طاقتك اليوم؟';

  @override
  String get coachPrompt6 => 'صف لحظة صغيرة تريد أن تتذكرها.';

  @override
  String get coachPrompt7 => 'ما الذي يجعل الغد يومًا جيدًا؟';

  @override
  String get coachPrompt8 => 'ما الذي كان يدور في ذهنك في الآونة الأخيرة؟';

  @override
  String get coachPrompt9 => 'ماذا فعلت اليوم من أجل نفسك فقط؟';

  @override
  String get coachPrompt10 => 'لو كان لليوم عنوان، ماذا سيكون؟';

  @override
  String get pageMediaTitle => 'وسائل الإعلام';

  @override
  String get pageAtlasTitle => 'أطلس';

  @override
  String get pageCoachTitle => 'مدرب';

  @override
  String get noEntrySelected => 'لم يتم تحديد إدخال.';

  @override
  String get entryShare => 'شارك';

  @override
  String get entryFavorite => 'نجمة';

  @override
  String get entryEdit => 'تحرير';

  @override
  String get entryPrevious => 'الإدخال السابق';

  @override
  String get entryNext => 'الإدخال التالي';

  @override
  String get journalStories => 'قصص';

  @override
  String get journalEntries => 'إدخالات';

  @override
  String get journalEmptyHint => 'ابدأ يومياتك بإضافة إدخال جديد.';

  @override
  String get storyToday => 'اليوم';

  @override
  String get storyThrowback => 'إرتداد';

  @override
  String get storyNoThrowback => 'لا يوجد ارتداد اليوم';

  @override
  String get mediaFiles => 'ملفات الوسائط';

  @override
  String get mediaEmpty => 'لا توجد صور بعد.';

  @override
  String get mediaEmptyHint => 'سيتم عرض الصور المرفقة بالإدخالات هنا.';

  @override
  String get atlasEmpty => 'لا توجد إدخالات مع الموقع.';

  @override
  String get atlasEmptyHint => 'سيتم عرض الإدخالات مع الموقع هنا.';

  @override
  String get atlasShowAll => 'إظهار كافة الإدخالات';

  @override
  String get atlasMyLocation => 'موقعي';

  @override
  String get coachAll => 'الكل';

  @override
  String get coachPrograms => 'البرامج';

  @override
  String get coachTemplates => 'قوالب';

  @override
  String get coachKindProgram => 'البرنامج';

  @override
  String get coachKindTemplate => 'القالب';

  @override
  String get coachNoTemplates => 'لا توجد برامج أو قوالب.';

  @override
  String get coachUseTemplate => 'اكتب بهذا القالب';

  @override
  String get coachProgramEverydayTitle => 'لحظات كل يوم';

  @override
  String get coachProgramEverydayDescription =>
      'خمسة أسئلة قصيرة، واحد في اليوم. يستغرق كل منها دقيقة أو دقيقتين ويساعدك على معرفة ما الذي جعل يومك مميزًا. طريقة لطيفة لبناء عادة الكتابة قليلاً كل يوم.';

  @override
  String get coachProgramReflectTitle => 'النظر إلى الداخل';

  @override
  String get coachProgramReflectDescription =>
      'سؤال أعمق في الأسبوع، لمدة خمسة أسابيع. خذ وقتك مع كل منها: ما الذي كنت تشعر به، ما الذي يرهقك، ما الذي تشعر بالامتنان له.';

  @override
  String get searchFilters => 'المرشحات';

  @override
  String get searchFilterTags => 'العلامات';

  @override
  String get searchFilterStarred => 'المميزة بنجمة';

  @override
  String get searchHint => 'اكتب للبحث، أو اختر مرشحًا.';

  @override
  String get locationTitle => 'الموقع';

  @override
  String get locationName => 'اسم المكان';

  @override
  String get locationRemove => 'إزالة';

  @override
  String get locationServiceDisabled => 'تم إيقاف خدمات الموقع.';

  @override
  String get locationPermissionDenied => 'تم رفض إذن تحديد الموقع.';

  @override
  String get locationUnavailable => 'تعذر الحصول على الموقع الحالي.';

  @override
  String get calendarJumpToToday => 'انتقل إلى اليوم';

  @override
  String get editorStartWriting => 'ابدأ بالكتابة أو اختر أ ';

  @override
  String get editorTemplateLink => 'القالب';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'اختر قالبًا';

  @override
  String get templateFeatured => 'قوالب مميزة';

  @override
  String get templateMine => 'القوالب الخاصة بي';

  @override
  String get templateDailyName => 'المراجعة اليومية';

  @override
  String get templateDailyDescription =>
      'ماذا حدث وكيف شعرت وماذا سيأتي بعد ذلك.';

  @override
  String get templateDailyText =>
      '## ماذا حدث اليوم\n\n\n## كيف شعرت\n\n\n## ثلاثة أشياء أنا ممتن لها\n1. \n2. \n3. \n\n## غدا\n';

  @override
  String get templateTravelName => 'إدخال مذكرات السفر';

  @override
  String get templateTravelDescription => 'الأماكن واللحظات والطعام من الطريق.';

  @override
  String get templateTravelText =>
      '## أين ذهبت\n\n\n## أكثر لحظة أتذكرها\n\n\n## ما أكلته\n\n\n## خطط للغد\n';

  @override
  String get templateReadingName => 'قراءة الملاحظات';

  @override
  String get templateReadingDescription => 'اقتباسات وأفكار من ما تقرأه.';

  @override
  String get templateReadingText =>
      '## كتاب\n\n\n## أين أنا\n\n\n## اقتباسات\n> \n\n## أفكاري\n';

  @override
  String get templateWeeklyName => 'مراجعة أسبوعية';

  @override
  String get templateWeeklyDescription =>
      'أبرز الأحداث والنضالات والتركيز في الأسبوع المقبل.';

  @override
  String get templateWeeklyText =>
      '## أبرز\n\n\n##ما كان صعبا\n\n\n## ما تعلمته\n\n\n## التركيز للأسبوع المقبل\n';

  @override
  String get entryDuplicate => 'مكررة';

  @override
  String get entryDuplicated => 'الإدخال مكرر';

  @override
  String get entrySaveAsTemplate => 'حفظ كقالب';

  @override
  String get entrySavedAsTemplate => 'تم الحفظ كقالب';

  @override
  String get storyStatistics => 'الإحصائيات';

  @override
  String get storyMoodChart => 'مخطط المزاج';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return 'إدخالات $entries · أيام $days';
  }

  @override
  String get storyThisYear => 'هذا العام';

  @override
  String get storyLastYear => 'العام الماضي';

  @override
  String get storyTapToOpen => 'اضغط على يوم لفتحه';

  @override
  String get settingsGeneralTitle => 'عام';

  @override
  String get settingsDataTitle => 'البيانات والتخزين';

  @override
  String get settingsStoriesTitle => 'قصص';

  @override
  String get settingsHelpTitle => 'مساعدة وحول';

  @override
  String get weatherTitle => 'الطقس';

  @override
  String get weatherClear => 'واضح';

  @override
  String get weatherPartlyCloudy => 'غائم جزئيا';

  @override
  String get weatherCloudy => 'غائم';

  @override
  String get weatherFog => 'ضباب';

  @override
  String get weatherDrizzle => 'رذاذ';

  @override
  String get weatherRain => 'المطر';

  @override
  String get weatherSnow => 'ثلج';

  @override
  String get weatherStorm => 'عاصفة رعدية';

  @override
  String get weatherFetch => 'الحصول على الطقس لهذا الإدخال';

  @override
  String get weatherNeedsLocation => 'أضف موقعًا بالإحداثيات أولاً.';

  @override
  String get weatherUnavailable => 'الطقس غير متوفر لهذا المكان والوقت.';

  @override
  String get weatherRemove => 'إزالة الطقس';

  @override
  String get activityTitle => 'النشاط';

  @override
  String get activityStill => 'لا يزال';

  @override
  String get activityWalking => 'المشي';

  @override
  String get activityRunning => 'الجري';

  @override
  String get activityCycling => 'ركوب الدراجات';

  @override
  String get activityVehicle => 'في مركبة';

  @override
  String get activityFlying => 'الطيران';

  @override
  String get activityExercise => 'تمرين';

  @override
  String get activityDetect => 'كشف النشاط الحالي';

  @override
  String get activityDetectFailed => 'تعذر اكتشاف النشاط.';

  @override
  String get activityRemove => 'إزالة النشاط';

  @override
  String get settingsAutoAddTitle => 'أضف تلقائيا';

  @override
  String get settingsAutoAddLocation => 'الموقع';

  @override
  String get settingsAutoAddWeather => 'الطقس';

  @override
  String get settingsAutoAddHint => 'يتم ملء الإدخالات الجديدة عند إنشائها.';

  @override
  String get settingsTemperatureUnit => 'وحدة درجة الحرارة';

  @override
  String get settingsCelsius => 'مئوية (درجة مئوية)';

  @override
  String get settingsFahrenheit => 'فهرنهايت (درجة فهرنهايت)';

  @override
  String get moodGreat => 'عظيم';

  @override
  String get moodGood => 'جيد';

  @override
  String get moodOkay => 'حسنا';

  @override
  String get moodBad => 'سيئة';

  @override
  String get moodAwful => 'فظيعة';

  @override
  String get locationSearchHint => 'ابحث عن مكان';

  @override
  String get locationSearchEmpty => 'لم يتم العثور على أماكن';

  @override
  String get settingsWallpaper => 'ورق جدران';

  @override
  String get wallpaperNone => 'لا شيء';

  @override
  String get wallpaperDots => 'النقاط';

  @override
  String get wallpaperGrid => 'الشبكة';

  @override
  String get wallpaperLines => 'خطوط';

  @override
  String get wallpaperPhoto => 'الصورة…';

  @override
  String get settingsFontFamily => 'الخط';

  @override
  String get fontSystem => 'النظام';

  @override
  String get fontSerif => 'شريف';

  @override
  String get fontMono => 'مونوسبيس';

  @override
  String get settingsFontSize => 'حجم الخط';

  @override
  String get fontSizeSmall => 'صغير';

  @override
  String get fontSizeMedium => 'متوسط';

  @override
  String get fontSizeLarge => 'كبير';

  @override
  String get fontSizeExtraLarge => 'كبيرة جدًا';

  @override
  String get settingsLineSpacing => 'تباعد الأسطر';

  @override
  String get lineSpacingCompact => 'مدمج';

  @override
  String get lineSpacingNormal => 'عادي';

  @override
  String get lineSpacingRelaxed => 'استرخاء';

  @override
  String get moodAssociationsTitle => 'ما الذي يجعلني أشعر…';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching لإدخالات $total';
  }

  @override
  String get videoRecord => 'سجل مقطع فيديو';

  @override
  String get videoChoose => 'اختر فيديو';

  @override
  String get audioRecordTitle => 'سجل ملاحظة صوتية';

  @override
  String get audioChoose => 'اختر ملفًا صوتيًا';

  @override
  String get audioStart => 'سجل';

  @override
  String get audioStop => 'توقف واحفظ';

  @override
  String get audioPermissionDenied =>
      'تم إيقاف الوصول إلى الميكروفون. السماح بذلك في إعدادات النظام.';

  @override
  String get mediaTooLarge => 'هذا الفيديو كبير جدًا بحيث لا يمكن إرفاقه.';

  @override
  String get mediaUnavailable => 'هذا المرفق غير متوفر على هذا الجهاز.';

  @override
  String get widgetDone => 'دخول اليوم مكتوب';

  @override
  String get widgetPending => 'كيف كان يومك؟';

  @override
  String get widgetWrite => 'اكتب';

  @override
  String get insertChecklist => 'قائمة التحقق';

  @override
  String get insertNumberedList => 'قائمة مرقمة';

  @override
  String get insertTable => 'الجدول';

  @override
  String get insertDivider => 'مقسم';

  @override
  String get insertCodeBlock => 'كتلة التعليمات البرمجية';

  @override
  String get journalSortTitle => 'فرز الإدخالات';

  @override
  String get journalSortUpdated => 'آخر تحديث';

  @override
  String get settingsTimeFormat => 'تنسيق الوقت';

  @override
  String get settingsDayStart =>
      'يتم احتساب الإدخالات الجديدة لليوم السابق حتى';

  @override
  String get settingsDayAskUntil => 'ثم اسأل في أي يوم حتى';

  @override
  String get settingsDayStartMidnight => 'إيقاف';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'يحتفظ كل إدخال باليوم الذي ينتمي إليه بجوار وقت كتابته، ويمكنك تغيير ذلك اليوم في المحرر في أي وقت. تختار هذه الساعات اليوم للإدخالات الجديدة فقط، لذا فإن تغييرها لا يؤدي إلى نقل أي إدخال موجود.';

  @override
  String get lateNightBadge =>
      'مكتوب في وقت متأخر من الليل، ويحسب لليوم السابق';

  @override
  String editorDayAsk(String time) {
    return 'مكتوب في $time. لأي يوم هو؟';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (أمس)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (اليوم)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'مكتوب $when';
  }

  @override
  String get timeFormat12 => '12 ساعة';

  @override
  String get timeFormat24 => '24 ساعة';

  @override
  String get settingsReminderDays => 'ذكرني على';

  @override
  String get locationRecent => 'الأماكن الأخيرة';

  @override
  String get shareImage => 'مشاركة الصورة';

  @override
  String get shareSaveImage => 'حفظ الصورة';

  @override
  String get shareSaved => 'تم حفظ الصورة';

  @override
  String get deletedTitle => 'تم حذفه مؤخرًا';

  @override
  String get deletedNone => 'لم يتم حذف أي شيء مؤخرًا';

  @override
  String deletedHint(int days) {
    return 'تبقى الإدخالات المحذوفة هنا لمدة $days، ثم يتم مسحها.';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days أيام متبقية';
  }

  @override
  String get deletedRestore => 'استعادة';

  @override
  String get deletedDeleteForever => 'حذف إلى الأبد';

  @override
  String get deletedDeleteForeverDescription =>
      'يتم مسح الإدخال ومرفقاته. لا يمكن التراجع عن هذا.';

  @override
  String get deletedEmpty => 'فارغ';

  @override
  String get deletedEmptyDescription =>
      'هل تريد مسح كل إدخال في المحذوفة مؤخرًا؟ لا يمكن التراجع عن هذا.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'المشي العشوائي';

  @override
  String get randomSubtitle => 'افتح الإدخال السابق';

  @override
  String get randomNext => 'آخر';

  @override
  String get randomAll => 'الكل';

  @override
  String get randomWithPhotos => 'مع الصور';

  @override
  String get randomGoodDays => 'أيام جيدة';

  @override
  String get randomEmpty => 'لا توجد إدخالات للاختيار من بينها';

  @override
  String get reviewWeekTitle => 'هذا الاسبوع';

  @override
  String get reviewWeekSubtitle => 'أسبوعك حتى الآن';

  @override
  String get reviewYearTitle => 'هذا العام';

  @override
  String get reviewEmpty => 'لا شيء مكتوب بعد';

  @override
  String get reviewEntries => 'إدخالات';

  @override
  String get reviewDaysWritten => 'أيام مكتوبة';

  @override
  String get reviewWords => 'كلمات';

  @override
  String get reviewPhotos => 'صور';

  @override
  String get reviewLongestRun => 'أطول فترة من الأيام';

  @override
  String get reviewAverageMood => 'متوسط المزاج';

  @override
  String get reviewFavorites => 'في أغلب الأحيان';

  @override
  String get reviewByMonth => 'بالشهر';

  @override
  String get reviewHighlight => 'تسليط الضوء';

  @override
  String get yearInPixels => 'السنة بالبكسل';

  @override
  String get capsuleSeal => 'ختم ككبسولة زمنية';

  @override
  String get capsuleTitle => 'كبسولة زمنية';

  @override
  String capsuleOpensOn(Object date) {
    return 'يفتح على $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'مكتوب على $date';
  }

  @override
  String get capsuleOpenEarly => 'فتح في وقت مبكر';

  @override
  String get capsuleOpenEarlyDescription => 'تفتح الكبسولة الآن وتبقى مفتوحة.';

  @override
  String get capsuleOpened => 'فتحت كبسولة الزمن';

  @override
  String get templateMorningName => 'صفحات الصباح';

  @override
  String get templateMorningDescription => 'قم بإعداد اليوم في ثلاث دقائق';

  @override
  String get templateMorningText =>
      '## ثلاثة أشياء أريد أن أفعلها بشكل جيد اليوم\n1. \n2. \n3. \n\n## شيء أتطلع إليه\n\n##ملاحظة لنفسي\n';

  @override
  String get templateEveningName => 'مراجعة مسائية';

  @override
  String get templateEveningDescription => 'اختتم اليوم بما سار على ما يرام';

  @override
  String get templateEveningText =>
      '## ثلاثة أشياء جيدة اليوم\n1. \n2. \n3. \n\n## ما تعلمته\n\n## ما الذي يمكن أن يكون أفضل غدًا\n';

  @override
  String get routineMorning => 'صباح الخير';

  @override
  String get routineEvening => 'مراجعة مسائية';

  @override
  String get settingsRoutinePrompts => 'أذكار الصباح والمساء';

  @override
  String get settingsRoutinePromptsHint =>
      'اقترح قالب الصباح أو المساء في القصص';

  @override
  String get checkInTitle => 'تسجيل وصول سريع';

  @override
  String get checkInSubtitle => 'المزاج في نقرتين';

  @override
  String get checkInMood => 'كيف تشعر؟';

  @override
  String get checkInActivity => 'ماذا تفعل؟';

  @override
  String get checkInNote => 'سطر عنها (اختياري)';

  @override
  String get checkInSave => 'حفظ';

  @override
  String editorWordCount(int words, int characters) {
    return 'كلمات $words · أحرف $characters';
  }

  @override
  String get coachProgramEverydayTagline => 'لاحظ الأشياء الصغيرة في يوم واحد.';

  @override
  String get coachProgramReflectTagline => 'تمهل واستمع لنفسك.';

  @override
  String get coachDuration => 'المدة';

  @override
  String get coachInterval => 'الفاصل الزمني';

  @override
  String get coachDifficulty => 'صعوبة';

  @override
  String get coachIntervalDaily => 'يوميا';

  @override
  String get coachIntervalWeekly => 'أسبوعيا';

  @override
  String get coachDifficultyBeginner => 'مبتدئ';

  @override
  String get coachDifficultyIntermediate => 'متوسط';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count يوم',
      many: '$count يومًا',
      few: '$count أيام',
      two: 'يومان',
      one: 'يوم واحد',
      zero: '$count يوم',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أسبوع',
      many: '$count أسبوعًا',
      few: '$count أسابيع',
      two: 'أسبوعان',
      one: 'أسبوع واحد',
      zero: '$count أسبوع',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'يوم $n';
  }

  @override
  String coachWeekN(int n) {
    return 'الأسبوع $n';
  }

  @override
  String get coachEnroll => 'تسجيل';

  @override
  String get coachEndProgram => 'نهاية البرنامج';

  @override
  String get coachAuthor => 'المؤلف';

  @override
  String get coachAuthorBio => 'المطالبات المكتوبة لهذا التطبيق.';

  @override
  String get coachEnrolledTip => 'كل شيء جاهز! ستظهر أسئلتك في القصص.';

  @override
  String get coachGoToStories => 'اذهب إلى القصص';

  @override
  String get coachAnswerHint => 'أكتب إجابتك...';

  @override
  String get storyWrapUp => 'هذا كل شيء لهذا اليوم.';

  @override
  String get storyTapToClose => 'انقر للإغلاق';

  @override
  String get coachAnswerDone => 'تم';

  @override
  String get coachAnswered => 'تمت الإجابة، انقر للفتح';

  @override
  String get coachAnsweredEarlier => 'أجاب';

  @override
  String get locationLocating => 'تحديد موقع…';

  @override
  String get locationPickPlace => 'اختر مكانا';

  @override
  String get locationPlacesHint => 'العنوان أو إسم المكان';

  @override
  String get locationCustom => 'مكان مخصص';

  @override
  String get locationCurrent => 'الموقع الحالي';

  @override
  String get locationSaved => 'الأماكن المحفوظة';

  @override
  String get locationSearchResults => 'نتائج البحث';

  @override
  String get locationNearby => 'الأماكن القريبة';

  @override
  String get locationRename => 'إعادة تسمية';

  @override
  String get locationSavePlace => 'حفظ المكان';

  @override
  String get locationUnsavePlace => 'إزالة من الأماكن المحفوظة';

  @override
  String get shareAs => 'مشاركة باسم...';

  @override
  String get shareAsImage => 'صورة';

  @override
  String get shareAsZip => 'ZIP مع الوسائط الأصلية';

  @override
  String get shareAsPlainText => 'نص عادي';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'مرحبا بكم في AID Diary';

  @override
  String get onboardWelcomeText =>
      'ابدأ هنا، أو قم بتوصيل هذا الجهاز بجهاز تستخدمه بالفعل.';

  @override
  String get onboardStart => 'ابدأ بالكتابة';

  @override
  String get helpFaq => 'الأسئلة المتداولة';

  @override
  String get helpFaq1Q => 'أين يتم تخزين مذكراتي؟';

  @override
  String get helpFaq1A =>
      'يتم تخزين يومياتك على هذا الجهاز. ولا يصل إلى الأجهزة أو وحدات التخزين الأخرى إلا عند تمكين المزامنة أو المشاركة أو التصدير. المزامنة مشفرة من طرف إلى طرف.';

  @override
  String get helpFaq2Q => 'كيف يمكنني الاحتفاظ بنسخة أو نقلها إلى جهاز جديد؟';

  @override
  String get helpFaq2A =>
      'اتصل بجهاز موجود في الإعدادات → البيانات والتخزين → مزامنة وتأكيد التفويض على الجهاز الذي يحتوي على مذكراتك. يبقى كلا الجهازين صالحين للاستخدام. يمكنك أيضًا إنشاء نسخة احتياطية واستعادتها على جهاز آخر.';

  @override
  String get helpFaq3Q => 'هل يمكنني إحضار إدخالات من تطبيقات اليوميات الأخرى؟';

  @override
  String get helpFaq3A =>
      'نعم: في الإعدادات ← البيانات والتخزين، قم باستيراد الصادرات من Daylio، وDiarium، وDiaro، وDayBook، وMy Brain، وOneShot، وPixels، أو تصدير JSON.';

  @override
  String get helpFaq4Q => 'كيف تعمل برامج المدرب؟';

  @override
  String get helpFaq4A =>
      'قم بالتسجيل في برنامج على صفحة المدرب. كل يوم أو أسبوع ينتظرك سؤال جديد في القصص؛ يتم حفظ إجابتك كإدخال.';

  @override
  String get helpFaq5Q => 'ماذا لو نسيت رمز المرور الخاص بي؟';

  @override
  String get helpFaq5A =>
      'لا يمكن استعادة رمز المرور، لذا احتفظ بنسخة احتياطية من مذكراتك.';

  @override
  String get helpPrivacy => 'الخصوصية';

  @override
  String get helpPrivacyText =>
      'يظل محتوى اليوميات والوسائط على هذا الجهاز ما لم تقم بتمكين المزامنة المشفرة أو مشاركتها/تصديرها. تستخدم الخرائط والبحث عن الأماكن والطقس الخدمات التي تم تكوينها وترسل الموقع أو استعلام البحث المطلوب لهذا الطلب، وليس نص اليوميات.';

  @override
  String get photoMetaTitle => 'استخدام تفاصيل الصورة؟';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'إحسب هذا الإدخال لـ $date وأضع مكانه $place كما هو مسجل في الصورة؟';
  }

  @override
  String photoMetaDate(String date) {
    return 'احسب هذا الإدخال لـ $date، متى تم التقاط الصورة؟';
  }

  @override
  String photoMetaPlace(String place) {
    return 'اضبط مكان هذا الإدخال على $place، أين تم التقاط الصورة؟';
  }

  @override
  String get photoMetaApply => 'استخدمها';

  @override
  String get quickWriteTitle => 'الكتابة السريعة';

  @override
  String get quickWriteText => 'انقر لبدء إدخال جديد.';

  @override
  String get settingsQuickWriteTitle => 'الكتابة السريعة في الإخطارات';

  @override
  String get settingsQuickWriteDescription =>
      'احتفظ بإشعار يفتح إدخالاً جديدًا.';

  @override
  String get settingsNudgesTitle => 'ادفعني بعد فترة هادئة';

  @override
  String settingsNudgesDescription(int days) {
    return 'تذكير لطيف عندما لا تكتب لأيام $days.';
  }

  @override
  String get nudgeTitle => 'لقد مضى وقت طويل';

  @override
  String get nudgeMonday => 'أسبوع جديد: ما الذي تتطلع إليه؟';

  @override
  String get nudgeTuesday => 'سطرين يكفي . كيف حالك اليوم؟';

  @override
  String get nudgeWednesday => 'في منتصف الأسبوع. ما الذي برز حتى الآن؟';

  @override
  String get nudgeThursday => 'أي شيء صغير يستحق الاحتفاظ به من اليوم؟';

  @override
  String get nudgeFriday => 'الأسبوع على وشك الانتهاء. لاحظ لحظة واحدة جيدة.';

  @override
  String get nudgeSaturday => 'يوم السبت البطيء هو يوم جيد للكتابة.';

  @override
  String get nudgeSunday => 'انظر إلى الوراء في الأسبوع الذي سبق أن ينتهي.';

  @override
  String get photoWidgetEmpty => 'تظهر هنا الصور التي تضيفها إلى الإدخالات.';

  @override
  String get channelReminders => 'تذكيرات';

  @override
  String get channelOnThisDay => 'في هذا اليوم';

  @override
  String get channelCoach => 'يطالب المدرب';

  @override
  String get channelNudges => 'دفعات بعد أيام هادئة';

  @override
  String get channelQuickWrite => 'الكتابة السريعة';

  @override
  String get channelBackup => 'النسخ الاحتياطية';

  @override
  String get formatJsonExport => 'JSON (تصدير AID Diary)';

  @override
  String get aboutModifiedNotice =>
      'نسخة معدلة من Daily You من تأليف Demizo والمساهمين. إنه ليس تطبيق Daily You الرسمي.';

  @override
  String get toolbarPhotos => 'أضف الصور';

  @override
  String get toolbarMedia => 'الصور ومقاطع الفيديو';

  @override
  String get mediaFromGallery => 'اختر من المعرض';

  @override
  String get mediaFromFiles => 'اختر من الملفات';

  @override
  String get editorLeaveTitle => 'هل تريد حفظ هذا الإدخال؟';

  @override
  String get editorLeaveDiscard => 'لا تحفظ';

  @override
  String get editorTitleHint => 'العنوان';

  @override
  String get editorLocating => 'تحديد موقع…';

  @override
  String get toolbarVideo => 'فيديو';

  @override
  String get toolbarAudio => 'ملاحظة صوتية';

  @override
  String get toolbarTags => 'العلامات';

  @override
  String get toolbarBulletList => 'قائمة نقطية';

  @override
  String get toolbarHeading => 'العنوان';

  @override
  String get toolbarBold => 'جريئة';

  @override
  String get toolbarItalic => 'مائل';

  @override
  String get toolbarHighlight => 'تسليط الضوء';

  @override
  String get toolbarStrikethrough => 'يتوسطه خط';

  @override
  String get toolbarQuote => 'اقتباس';

  @override
  String get toolbarLink => 'رابط';

  @override
  String get toolbarInsert => 'إدراج';

  @override
  String get toolbarUndo => 'تراجع';

  @override
  String get toolbarRedo => 'إعادة';

  @override
  String get toolbarInsertDate => 'أدخل التاريخ';

  @override
  String get toolbarInsertTime => 'أدخل الوقت';

  @override
  String get settingsSyncTitle => 'مزامنة السحابة';

  @override
  String get syncOffDescription =>
      'احتفظ بهذه اليوميات كما هي على جميع أجهزتك من خلال Google Drive أو خادم WebDAV، مثل Nextcloud أو Synology أو Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'مزامنة مع Google Drive';

  @override
  String get syncOrWebDav => 'أو خادم WebDAV';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn =>
      'تم تسجيل الدخول. يمكنك العودة إلى AID Diary.';

  @override
  String get syncGoogleSignInAgain => 'يحتاج Google منك تسجيل الدخول مرة أخرى.';

  @override
  String get syncSignInAgain => 'قم بتسجيل الدخول مرة أخرى';

  @override
  String get settingsCommandLineTitle => 'سطر الأوامر';

  @override
  String get commandLineToggle => 'واجهة سطر الأوامر';

  @override
  String get commandLineToggleHint =>
      'يتيح لأمر المساعدة والبرامج الأخرى الموجودة على هذا الجهاز استخدام أوامر التطبيق.';

  @override
  String get commandLineAlwaysOn => 'دائما في تطوير يبني.';

  @override
  String commandLineListening(int port) {
    return 'الاستماع على المنفذ $port';
  }

  @override
  String get commandPaletteTitle => 'جميع الأوامر';

  @override
  String get commandPaletteSearch => 'أوامر البحث';

  @override
  String get commandPaletteRun => 'تشغيل';

  @override
  String get commandPaletteConfirm =>
      'لا يمكن التراجع عن هذا الأمر ببساطة. تشغيله؟';

  @override
  String syncReceiving(int done, int total) {
    return 'جارٍ استلام $done من $total...';
  }

  @override
  String syncSending(int done, int total) {
    return 'جارٍ إرسال $done من $total...';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'لم يسمح بالوصول إلى Google Drive. اتصل مرة أخرى وحدد Google Drive على صفحة Google.';

  @override
  String get syncEntryUnsynced => 'لم تتم المزامنة: لم تتم المزامنة الأخيرة';

  @override
  String get syncUseOfficial => 'استخدم خادم مزامنة AID';

  @override
  String get syncServer => 'عنوان الخادم';

  @override
  String get syncUsername => 'اسم المستخدم';

  @override
  String get syncPassword => 'كلمة المرور';

  @override
  String get syncConnect => 'الاتصال';

  @override
  String get syncConnecting => 'جارٍ الاتصال…';

  @override
  String get syncSignInFailed =>
      'تعذر تسجيل الدخول. تحقق من العنوان واسم المستخدم وكلمة المرور.';

  @override
  String syncConnectFailed(String error) {
    return 'تعذر الاتصال: $error';
  }

  @override
  String get syncNewSpaceTitle => 'ابدأ المزامنة';

  @override
  String get syncNewSpaceDescription =>
      'لا توجد مذكرات متزامنة هنا حتى الآن. سيتم تحميل هذه اليوميات وتشفيرها بالكامل باستخدام مفتاح يبقى على أجهزتك.';

  @override
  String get syncJoinTitle => 'انضم إلى اليوميات المتزامنة';

  @override
  String get syncWrongKey => 'لا يفتح رمز الاسترداد هذا اليوميات المتزامنة.';

  @override
  String syncLastSynced(String time) {
    return 'آخر مزامنة $time';
  }

  @override
  String get syncNever => 'لم تتم المزامنة بعد';

  @override
  String get syncSyncing => 'جارٍ المزامنة…';

  @override
  String syncFailed(String error) {
    return 'فشلت آخر مزامنة: $error';
  }

  @override
  String get syncLocked =>
      'تنتمي اليوميات التي تمت مزامنتها الآن إلى أجهزة أخرى، أو تم بدء تشغيلها من جديد. قم بالاقتران بأحدهم أو استخدم رمز الاسترداد لمواصلة المزامنة.';

  @override
  String get syncNow => 'مزامنة الآن';

  @override
  String get syncUnlock => 'فتح';

  @override
  String get syncEncrypted => 'مشفرة من طرف إلى طرف';

  @override
  String get syncDisconnect => 'توقف عن المزامنة';

  @override
  String get syncDisconnectDescription =>
      'يتوقف هذا الجهاز عن المزامنة. تبقى اليوميات هنا والنسخة المتزامنة كما هي.';

  @override
  String get syncOwnRecoveryPassword => 'استخدم كلمة مرور الاسترداد الخاصة بي';

  @override
  String get syncRecoveryPassword => 'كلمة مرور الاسترداد';

  @override
  String get syncRecoveryPasswordRepeat => 'كرر كلمة مرور الاسترداد';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'استخدم أحرف $min على الأقل';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'تختلف كلمات المرور';

  @override
  String get syncRecoveryCode => 'رمز الاسترداد';

  @override
  String get syncRecoveryCodeTitle => 'احفظ رمز الاسترداد الخاص بك';

  @override
  String get syncRecoveryCodeDescription =>
      'إذا فقدت كل جهاز خاص بك، فسيقوم هذا الرمز باستعادة يومياتك التي تمت مزامنتها. احتفظ بها في مدير كلمات المرور أو على الورق. ويظهر هذه المرة فقط.';

  @override
  String get syncRecoveryCodeCopied => 'تم نسخ رمز الاسترداد';

  @override
  String get syncRecoveryCodeSaved => 'لقد أنقذته';

  @override
  String get syncJoinNeedsKey =>
      'تنتمي هذه اليوميات المتزامنة إلى أجهزتك الأخرى. قم بالاقتران مع واحد منهم، أو استخدم رمز الاسترداد. ستتم إضافة الإدخالات الموجودة على هذا الجهاز إليه.';

  @override
  String get syncPairDevice => 'إقران مع جهاز';

  @override
  String get syncUseRecoveryCode => 'استخدم رمز الاسترداد';

  @override
  String get syncAddDevice => 'أضف جهازًا';

  @override
  String get syncChangeRecoveryCode => 'تغيير رمز الاسترداد';

  @override
  String get syncChangeRecoveryDescription =>
      'يحل الرمز الجديد محل الرمز الحالي، والذي يتوقف عن العمل. تظل بياناتك وأجهزتك الأخرى كما هي.';

  @override
  String get syncNewRandomCode => 'كود عشوائي جديد';

  @override
  String get syncRecoveryCodeChanged => 'تم تغيير رمز الاسترداد';

  @override
  String get syncResetSpace => 'ابدأ تشغيل اليوميات المتزامنة';

  @override
  String get syncResetSpaceDescription =>
      'فقط في حالة عدم فتح أي جهاز أو رمز استرداد مرة أخرى: يتم استبدال النسخة المتزامنة بالمذكرات الموجودة على هذا الجهاز، أسفل مفاتيح هذا الجهاز. ثم يتم إقران أجهزتك الأخرى مرة أخرى.';

  @override
  String get syncPairTitle => 'إقران الأجهزة';

  @override
  String get syncPairShow => 'إظهار الرمز';

  @override
  String get syncPairEnter => 'أدخل رمزا';

  @override
  String get syncPairShowHint =>
      'على جهازك الآخر، افتح \"إقران الأجهزة\"، واختر \"إدخال رمز\"، ثم اكتب هذا الرمز أو قم بمسحه ضوئيًا.';

  @override
  String get syncPairEnterHint =>
      'اكتب الرمز الذي يعرضه جهازك الآخر، أو قم بمسحه ضوئيًا.';

  @override
  String get syncPairCode => 'رمز الاقتران';

  @override
  String get syncPairScan => 'مسح';

  @override
  String get syncPairStart => 'زوج';

  @override
  String get syncPairWaiting => 'في انتظار الجهاز الآخر...';

  @override
  String syncPairDone(String device) {
    return 'يقترن مع $device';
  }

  @override
  String get syncPairWrongCode =>
      'الرمز غير متطابق. أظهر الرمز الجديد وحاول مرة أخرى.';

  @override
  String get syncPairNoOffer =>
      'لا يوجد جهاز يعرض هذا الرمز. ربما تكون قد انتهت صلاحيتها.';

  @override
  String get syncPairTimedOut => 'الجهاز الآخر لم يرد في الوقت المناسب.';

  @override
  String get syncPairNeither =>
      'لم يتم إعداد أي جهاز بهذه اليوميات المتزامنة حتى الآن.';

  @override
  String get syncPairBoth => 'يفتح كلا الجهازين هذه اليوميات المتزامنة بالفعل.';

  @override
  String syncPairFailed(String error) {
    return 'فشل الاقتران: $error';
  }

  @override
  String get syncMediaPending =>
      'تمت مزامنة اليوميات · لا تزال بعض الوسائط قيد النقل';

  @override
  String get syncWaitingForDevices =>
      'تمت مزامنة اليوميات · في انتظار جهاز آخر لنقل الوسائط';

  @override
  String get syncCacheNotice =>
      'الوسائط السحابية مؤقتة. احتفظ بالنسخ الأصلية على أجهزتك؛ المزامنة ليست نسخة احتياطية.';

  @override
  String get paperTitle => 'ورقة الرسالة';

  @override
  String get paperPlain => 'عادي';

  @override
  String get paperLined => 'مبطن';

  @override
  String get paperGrid => 'الشبكة';

  @override
  String get paperTinted => 'ملون';

  @override
  String get paperDecorationTitle => 'الأوسمة';

  @override
  String get paperDecorationNone => 'لا شيء';

  @override
  String get paperDecorationBotanical => 'أوراق';

  @override
  String get paperDecorationStars => 'النجوم';

  @override
  String get paperDecorationWashi => 'شريط واشي';

  @override
  String get themeDarkChoice => 'مظهر داكن';

  @override
  String get themeDarkSame => 'اتبع لوحة الضوء';

  @override
  String get themeDarkCustom => 'لوحة منفصلة';

  @override
  String get themeDarkAccent => 'لون لهجة داكنة';

  @override
  String get themeColorTeal => 'البط البري';

  @override
  String get themeColorCyan => 'سماوي';

  @override
  String get themeColorIndigo => 'نيلي';

  @override
  String get themeColorCoral => 'المرجان';

  @override
  String get themeColorOlive => 'زيتون';

  @override
  String get themeColorSlate => 'لائحة';

  @override
  String get drawingTitle => 'الرسم';

  @override
  String get drawingPen => 'قلم';

  @override
  String get drawingEraser => 'ممحاة';

  @override
  String get drawingUndo => 'تراجع';

  @override
  String get drawingClear => 'واضح';

  @override
  String get drawingWidth => 'عرض القلم';

  @override
  String get drawingStylusOnly => 'القلم فقط';

  @override
  String get drawingDiscardTitle => 'هل تريد تجاهل الرسم؟';

  @override
  String get drawingDiscardBody => 'لم يتم حفظ هذا الرسم.';

  @override
  String get drawingSaveError => 'لا يمكن حفظ الرسم.';

  @override
  String get syncNetworkTitle => 'تشخيص الشبكة';

  @override
  String get syncNetworkRefresh => 'تحديث';

  @override
  String get syncNetworkSelectedRoute => 'المسار الحالي';

  @override
  String get syncNetworkAvailableRoutes => 'المسارات المتاحة';

  @override
  String get syncNetworkSignaling => 'اتصال دليل الجهاز';

  @override
  String get syncNetworkRelayRemaining => 'بدل التتابع المتبقي';

  @override
  String get syncNetworkIcePair => 'مرشحي الاتصال المباشر';

  @override
  String get syncNetworkPeerTrusted => 'جهاز مصادق عليه';

  @override
  String get syncNetworkNoRoute => 'في انتظار اتصال';

  @override
  String get syncNetworkUnavailable => 'التشخيص غير متوفر';

  @override
  String get syncMediaCopiesTitle => 'تسليم وسائل الإعلام والنسخ';

  @override
  String get syncMediaPendingCount => 'في انتظار النقل';

  @override
  String get syncMediaDurableCount => 'تسليمها إلى التخزين الشخصي';

  @override
  String get syncMediaTemporaryCount => 'نسخ مؤقتة أو غير مؤكدة';

  @override
  String get syncMediaReceiptExplanation =>
      'تصف هذه الأعداد عمليات التسليم المكتملة، وليس مراجعة جديدة للنسخ الاحتياطية الباقية.';

  @override
  String get syncMediaCacheExplanation =>
      'يمكن أن تنتهي صلاحية الوسائط السحابية المؤقتة. احتفظ بنسخك الأصلية أو نسخة احتياطية منفصلة.';

  @override
  String get momentsTitle => 'لحظات الصور';

  @override
  String get momentsHint =>
      'ابحث عن المجموعات باستخدام أوقات الصور المحلية والإحداثيات الاختيارية. يتم إرفاق الصور فقط عند اختيار البطاقة.';

  @override
  String get momentsScan => 'البحث عن لحظات';

  @override
  String get momentsChooseFolder => 'اختر مجلد الصور';

  @override
  String get momentsLocation => 'تضمين مواقع الصور';

  @override
  String get momentsEmpty => 'لا توجد مجموعات صور حديثة.';

  @override
  String get momentsCreate => 'اكتب عن هذه الصور';

  @override
  String get momentsDismiss => 'استبعاد';

  @override
  String get momentsError => 'لا يمكن قراءة الصور المحلية.';

  @override
  String get momentsCreated => 'تم إنشاء إدخال الصورة.';

  @override
  String get momentsPermission =>
      'السماح بالوصول إلى الصور للعثور على اقتراحات محلية.';

  @override
  String get momentsScope =>
      'الصور الحديثة فقط؛ بحد أقصى 500 صورة و20 صورة لكل بطاقة.';

  @override
  String momentsPhotoCount(int count) {
    return 'صور $count';
  }

  @override
  String get nearbyTitle => 'توصيل الأجهزة';

  @override
  String get nearbySend => 'تخويل جهاز آخر';

  @override
  String get nearbyReceive => 'الاتصال بجهاز موجود';

  @override
  String get nearbyInstructions =>
      'قم بتوصيل كلا الجهازين بنفس Wi-Fi أو بنقطة الاتصال الخاصة ببعضهما البعض. تأكيد الترخيص على الجهاز الموجود؛ يبقى كلا الجهازين صالحين للاستخدام. لا يلزم الإنترنت.';

  @override
  String get nearbyCompare =>
      'قارن هذا الرمز على كلا الجهازين قبل الموافقة عليه.';

  @override
  String get nearbyConfirm => 'تتطابق الرموز';

  @override
  String get nearbyScan => 'قم بمسح رمز الجهاز الآخر';

  @override
  String get nearbyPaste => 'لصق الدعوة';

  @override
  String get nearbyWaiting => 'في انتظار الموافقة على الجهاز الآخر';

  @override
  String get nearbyWorking => 'اعتماد ومزامنة يومياتك ومرفقاتك...';

  @override
  String get nearbyPending =>
      'لا تزال بعض المرفقات بحاجة إلى المزامنة. احتفظ بالجهاز الآخر متصلاً بالإنترنت وحاول مرة أخرى.';

  @override
  String get nearbyComplete => 'الجهاز متصل؛ مزامنة اليوميات والمرفقات';

  @override
  String get nearbyFailed =>
      'لم ينته الاتصال. تحقق من الاتصال المحلي وحاول مرة أخرى.';

  @override
  String get nearbyEmptyRequired =>
      'استخدم جهازًا يحتوي على مذكرات فارغة ولم يتم توصيله للمزامنة بعد.';

  @override
  String get nearbyRetry => 'متابعة المزامنة';

  @override
  String get nearbyWifi => 'إعدادات Wi-Fi';

  @override
  String get nearbyHotspot => 'إعدادات نقطة الاتصال';

  @override
  String get nearbyKeepOpen =>
      'أبقِ هذه الصفحة مفتوحة حتى ينتهي الجهاز الجديد. تنتهي صلاحية الدعوة بعد دقيقتين.';

  @override
  String get syncDevicesTitle => 'الأجهزة المعتمدة';

  @override
  String get syncDevicesDescription =>
      'يمكن للأجهزة المعتمدة فقط الوصول إلى حساب AID هذا. يؤدي إبطال الجهاز إلى حظر الخادم ولكن لا يمكنه مسح المفتاح الرئيسي أو اليوميات التي تم نسخها إليه بالفعل.';

  @override
  String get syncDeviceRequest => 'أظهر هذا التفويض QR لجهاز معتمد';

  @override
  String get syncDeviceAuthorize => 'تخويل جهاز';

  @override
  String get syncDeviceAuthorizeDescription =>
      'قم بمسح أو لصق طلب ترخيص الجهاز الجديد.';

  @override
  String get syncDeviceRevoke => 'إبطال';

  @override
  String get syncDeviceRotate => 'قم بتدوير مفتاح التوقيع لهذا الجهاز';

  @override
  String get syncDeviceCheck => 'التحقق من الترخيص';

  @override
  String get syncDeviceHardware => 'مفتاح التوقيع المدعوم بالأجهزة';

  @override
  String get syncDeviceSoftware => 'مفتاح توقيع البرامج غير القابلة للتصدير';

  @override
  String get syncDeviceUnavailable =>
      'ترخيص الجهاز غير متوفر. قم بالموافقة على هذا الجهاز من جهاز معتمد آخر ثم أعد المحاولة.';

  @override
  String get syncDeviceRevoked => 'تم إبطاله';

  @override
  String get syncDeviceLocal => 'هذا الجهاز';

  @override
  String get cloudTrafficTitle =>
      'حصة نقل البيانات السحابية الشهرية لملفات الوسائط';

  @override
  String get cloudTrafficLimit => 'حصة نقل البيانات الشهرية';

  @override
  String get cloudTrafficUsed => 'نقل البيانات المستخدمة';

  @override
  String get cloudTrafficRemaining => 'نقل البيانات المتبقية';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'تقوم حصة نقل البيانات بإعادة تعيين $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'تم استنفاد حصة نقل البيانات السحابية لملفات الوسائط. ستتم مزامنة ملفات الوسائط المفقودة تلقائيًا عند توفر اتصال مباشر أو إعادة تعيين الحصة النسبية.';

  @override
  String get cloudTrafficExplanation =>
      'يقوم التخزين المؤقت لملفات الوسائط والترحيل المباشر بمشاركة حصة نقل البيانات هذه. الاتصالات المباشرة لا تستهلكه. تحتوي رسائل اليوميات النصية ورسائل التحكم في الاتصال على حدود يومية صغيرة منفصلة.';

  @override
  String get appearanceThemeSection => 'موضوع التطبيق';

  @override
  String get appearancePaperSection => 'ورقة مذكرات';

  @override
  String get appearanceTypographySection => 'نص اليوميات';

  @override
  String get appearancePreferencesSection => 'التفضيلات العامة';

  @override
  String get themeSystemAccentHint =>
      'يستخدم لوحة النظام بدلاً من الألوان المخصصة. قم بإيقاف تشغيله لاختيار ما يناسبك.';

  @override
  String get syncDeviceNameSaveFailed =>
      'لا يمكن حفظ اسم الجهاز. يرجى المحاولة مرة أخرى.';

  @override
  String get nearbyConnectionHelp => 'مساعدة الاتصال';

  @override
  String get syncAllSynced => 'تمت مزامنة كل شيء';

  @override
  String get syncDetailsTitle => 'تفاصيل المزامنة';

  @override
  String get syncMore => 'المزيد من الخيارات';

  @override
  String get syncDeviceName => 'اسم الجهاز';

  @override
  String get syncDeviceNameHint => 'على سبيل المثال: جهازي اللوحي';

  @override
  String get syncDeviceNameInvalid => 'استخدم من 1 إلى 32 حرفًا';

  @override
  String get syncDeviceKeyDetails => 'تفاصيل أمنية';

  @override
  String get syncConnectionProblem =>
      'غير قادر على المزامنة في الوقت الحالي. إعادة المحاولة تلقائيًا.';

  @override
  String get syncCopyComplete => 'نسخة كاملة من يومياتك وملفات الوسائط';

  @override
  String get syncCopyPartial => 'بعض وسائل الإعلام لا تزال مفقودة';

  @override
  String get syncCopyOlder => 'التغييرات الجديدة في انتظار المزامنة';

  @override
  String get syncCopyUnavailable =>
      'تفاصيل النسخ غير متوفرة. حاول مرة أخرى لاحقًا.';

  @override
  String get syncCopyLastKnown =>
      'تعرض الأجهزة الأخرى آخر نسخة مؤكدة لها. لا يمكن التحقق من الأجهزة غير المتصلة بالإنترنت الآن.';

  @override
  String get syncCopyTemporary =>
      'ذاكرة التخزين المؤقتة. احتفظ بالنسخ الأصلية على أجهزتك.';

  @override
  String get syncCopyStorage =>
      'تخزين المزامنة الخاصة بك. يتم إدراج تحميلات الوسائط المكتملة في التشخيص.';

  @override
  String syncCopyChecked(String time) {
    return 'آخر تأكيد $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'المتبقي من نقل البيانات هذا الشهر: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'ابدأ هنا';

  @override
  String get onboardConnect => 'الاتصال بجهاز موجود';

  @override
  String get onboardFailed =>
      'لا يمكن إكمال الإعداد. يومياتك آمنة. يرجى المحاولة مرة أخرى.';

  @override
  String get tutorialTitle => 'كيفية استخدام اليوميات';

  @override
  String get tutorialWriteTitle => 'اكتب أول تدوينة';

  @override
  String get tutorialWriteText =>
      'اضغط على + لكتابة تدوينة. أضف عنوانًا إن أردت، واختر تاريخ التدوينة، ثم اضغط على علامة الصح للحفظ. يمكنك تعديلها في أي وقت.';

  @override
  String get tutorialMediaTitle => 'إضافة الصور والصوت أو الكتابة اليدوية';

  @override
  String get tutorialMediaText =>
      'استخدم + في محرر اليوميات لإرفاق الصور أو مقاطع الفيديو أو التسجيل الصوتي، أو لفتح لوحة الكتابة اليدوية. يتم حفظ هذه المرفقات مع إدخال اليوميات.';

  @override
  String get tutorialReviewTitle => 'العثور على يوم مرة أخرى';

  @override
  String get tutorialReviewText =>
      'تصفح يومياتك أو تقويمك، وابحث في كتاباتك، وقم بتنظيم الإدخالات باستخدام العلامات. تتيح لك صفحات الوسائط والأطلس العثور على الإدخالات السابقة حسب الصورة أو الموقع.';

  @override
  String get tutorialSyncTitle => 'استخدام أكثر من جهاز';

  @override
  String get tutorialSyncText =>
      'من الإعدادات ← البيانات والتخزين ← المزامنة، اتصل بجهاز موجود وأكّد التفويض على ذلك الجهاز. يمكنك الاستمرار في استخدام الجهازين. يُزامَن نص اليوميات أولًا، ثم تُزامَن المرفقات حسب الاتصال وحصة نقل البيانات المتبقية.';

  @override
  String get tutorialPrivacyTitle => 'حافظ على يومياتك آمنة';

  @override
  String get tutorialPrivacyText =>
      'تظل إدخالات اليوميات على هذا الجهاز ما لم تقم بتمكين مزامنتها أو مشاركتها أو تصديرها. المزامنة مشفرة من طرف إلى طرف. في الإعدادات، يمكنك أيضًا تعيين رمز مرور التطبيق وإنشاء نسخ احتياطية وإعادة فتح هذا البرنامج التعليمي.';

  @override
  String get editorDiaryDay => 'يوم التدوينة';

  @override
  String get editorDiaryDayPicker => 'يوم التدوينة · وقت الإنشاء ثابت';

  @override
  String get editorDiaryDayHint =>
      'اليوم الذي تنتمي إليه هذه التدوينة. تغييره لا يغيّر وقت إنشائها.';

  @override
  String get hiddenDiaryTitle => 'اليوميات المخفية';

  @override
  String get hiddenDiaryHide => 'إخفاء اليومية';

  @override
  String get hiddenDiaryShow => 'إظهار اليومية';

  @override
  String get hiddenDiaryEmpty => 'لا توجد يوميات مخفية';

  @override
  String get hiddenDiaryUnlock => 'فتح اليوميات المخفية';

  @override
  String get hiddenDiaryAuthHint =>
      'استخدم قفل التطبيق أو قفل شاشة جهازك للفتح.';

  @override
  String get hiddenDiaryLocalOnly =>
      'تبقى اليوميات المخفية على هذا الجهاز وتتوقف المزامنة. استخدم نسخًا احتياطية مشفرة. لا تتغير النسخ الموجودة على الأجهزة الأخرى.';

  @override
  String get moodClear => 'مسح الحالة المزاجية';
}
