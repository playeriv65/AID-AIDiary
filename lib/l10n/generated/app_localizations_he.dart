// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => 'צבע נושא';

  @override
  String get themeColorHint => 'בחר צבע עבור פלטה זו.';

  @override
  String get themeColorBlue => 'כחול שמיים';

  @override
  String get themeColorGreen => 'ירוק יער';

  @override
  String get themeColorBrown => 'קפה חם';

  @override
  String get themeColorPurple => 'לבנדר';

  @override
  String get themeColorRose => 'ורד מאובק';

  @override
  String get themeColorAmber => 'ענבר';

  @override
  String get themeColorPreview => 'כל יום קצת';

  @override
  String get themeTintBackgroundTitle => 'רקע גוון עם צבע נושא';

  @override
  String get themeTintBackgroundHint =>
      'כבה עבור רקע אפור ניטרלי; כפתורים שומרים על הצבע שבחרת.';

  @override
  String get dailyReminderTitle => 'כתוב ביומן שלך עוד היום!';

  @override
  String get dailyReminderDescription => 'קח את הרישום היומי שלך...';

  @override
  String get actionTakePhoto => 'צלם תמונה';

  @override
  String get flashbacksTitle => 'הצצה מהעבר';

  @override
  String get settingsFlashbacksExcludeBadDays => 'להסתיר ימים רעים';

  @override
  String get flashbackGoodDay => 'יום טוב';

  @override
  String get flashbackRandomDay => 'יום אקראי';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      two: 'לפני שבועיים',
      other: 'לפני $count שבועות',
      one: 'לפני שבוע',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      two: 'לפני חודשיים',
      other: 'לפני $count חודשים',
      one: 'לפני חודש',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      two: 'לפני שנתיים',
      other: 'לפני $count שנים',
      one: 'לפני שנה',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'ביום הזה';

  @override
  String get searchLogsHint => 'חיפוש ברישומים…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      two: '$count רשומות ביומן',
      other: '$count רשומות ביומן',
      one: 'רשומה אחת ביומן',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      two: '$count ימים',
      other: '$count ימים',
      one: 'יום אחד',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      two: '$count מילים',
      other: '$count מילים',
      one: 'מילה אחת',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'אין רישומים…';

  @override
  String get noResults => 'אין תוצאות…';

  @override
  String get sortOrderAscendingTitle => 'בסדר עולה';

  @override
  String get sortOrderDescendingTitle => 'בסדר יורד';

  @override
  String get pageStatisticsTitle => 'סטטיסטיקה';

  @override
  String get statisticsNotEnoughData => 'אין מספיק מידע…';

  @override
  String get statisticsRangeOneMonth => 'חודש 1';

  @override
  String get statisticsRangeSixMonths => 'שישה חודשים';

  @override
  String get statisticsRangeOneYear => 'שנה אחת';

  @override
  String get statisticsRangeAllTime => 'כל הזמנים';

  @override
  String chartSummaryTitle(Object tag) {
    return 'סיכום $tag';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag ביום';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag לאורך זמן';
  }

  @override
  String get chartGroupingLabel => 'קבץ לפי';

  @override
  String get chartGroupingDay => 'יום';

  @override
  String get chartGroupingWeek => 'שבוע';

  @override
  String get chartGroupingMonth => 'חודש';

  @override
  String get chartGroupingYear => 'שנה';

  @override
  String get chartSmoothingLabel => 'החלקה';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      two: 'רצף נוכחי $count',
      other: 'רצף נוכחי $count',
      one: 'רצף נוכחי $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      two: 'הרצף הארוך ביותר $count',
      other: 'הרצף הארוך ביותר $count',
      one: 'רצף $count הארוך ביותר',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      two: 'ימים גדולים $count',
      other: 'ימים גדולים $count',
      one: 'ימים גדולים $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      two: 'ימים מאז יום רע $count',
      other: 'ימים מאז יום רע $count',
      one: 'ימים מאז יום רע $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle => 'אחסון חיצוני אינו נגיש';

  @override
  String get errorExternalStorageAccessDescription =>
      'אם הינך משתמש באחסון אינטרנטי, וודא שהשירות פעיל ושיש לך גישה לאינטרנט.\n\nאחרת, יתכן שהאפליקציה איבדה הרשאת גישה לתיקייה החיצונית. גש להגדרות, ובחר מחדש את את התיקייה החיצונית בכדי להעניק הרשאת גישה \n\nאזהרה, שינויים לא יסונכרנו עד שתשוב הגישה למיקות התיקייה החיצונית!';

  @override
  String get errorExternalStorageAccessContinue => 'המשך עם אחסון מקומי';

  @override
  String get lastModified => 'שונה';

  @override
  String get writeSomethingHint => 'תכתוב משהו…';

  @override
  String get titleHint => 'כותרת…';

  @override
  String get deleteLogTitle => 'מחק את רשומת היומן';

  @override
  String get deleteLogDescription =>
      'הערך עובר ל\'נמחק לאחרונה\', שם תוכל לשחזר אותו.';

  @override
  String get deletePhotoTitle => 'מחק את הקובץ המצורף';

  @override
  String get deletePhotoDescription =>
      'האם אתה בטוח שברצונך למחוק את הקובץ המצורף הזה?';

  @override
  String get pageSettingsTitle => 'הגדרות';

  @override
  String get settingsTheme => 'נושא';

  @override
  String get themeSystem => 'מערכת';

  @override
  String get themeLight => 'אור';

  @override
  String get themeDark => 'כהה';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'היום הראשון בשבוע';

  @override
  String get settingsCalendarSystem => 'מערכת לוח שנה';

  @override
  String get calendarSystemGregorian => 'גרגוריאני';

  @override
  String get calendarSystemJalali => 'ג\'לאלי';

  @override
  String get settingsUseSystemAccentColor => 'השתמש ב-System Accent Color';

  @override
  String get settingsCustomAccentColor => 'צבע מבטא מותאם אישית';

  @override
  String get settingsShowFlashbacks => 'הצג פלאשבקים';

  @override
  String get settingsChangeMoodIcons => 'שנה סמלי מצב רוח';

  @override
  String get moodIconPrompt => 'הזן סמל';

  @override
  String get settingsHideImages => 'הסתר תמונות';

  @override
  String get pageCalendarTitle => 'לוח שנה';

  @override
  String get settingsNotificationsTitle => 'התראות';

  @override
  String get settingsDailyReminderTitle => 'תזכורת יומית';

  @override
  String get settingsOnThisDayDescription => 'עיין שוב בזיכרונות העבר';

  @override
  String get settingsDailyReminderDescription => 'תזכורת עדינה בכל יום';

  @override
  String get settingsReminderTime => 'זמן תזכורת';

  @override
  String get settingsFixedReminderTimeTitle => 'זמן תזכורת קבוע';

  @override
  String get settingsFixedReminderTimeDescription => 'בחר זמן קבוע לתזכורת';

  @override
  String get settingsAlwaysSendReminderTitle => 'שלח תמיד תזכורת';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'שלח תזכורת גם אם כבר התחיל רישום ביומן';

  @override
  String get settingsCustomizeNotificationTitle => 'התאם אישית התראות';

  @override
  String get settingsTemplatesTitle => 'תבניות';

  @override
  String get manageTemplates => 'נהל תבניות';

  @override
  String get noTemplateTitle => 'אין';

  @override
  String get noTemplatesDescription => 'עדיין לא נוצרו תבניות...';

  @override
  String get templateDefaultTimestampTitle => 'חותמת זמן';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'סיכום יום';

  @override
  String get templateDefaultSummaryBody => '### סיכום\n- \n\n### ציטוט\n> ';

  @override
  String get templateDefaultReflectionTitle => 'השתקפות';

  @override
  String get templateDefaultReflectionBody =>
      '### ממה נהנית היום?\n- \n\n### על מה אתה אסיר תודה?\n- \n\n### למה אתה מצפה?\n- ';

  @override
  String get settingsTagsTitle => 'תגים';

  @override
  String get manageTags => 'נהל תגים';

  @override
  String get tagTypeLabelTitle => 'תווית';

  @override
  String get tagTypeTrackerTitle => 'גשש';

  @override
  String get nameHint => 'שם';

  @override
  String get tagColorLabel => 'צבע';

  @override
  String get iconPickerTitle => 'בחר אייקון';

  @override
  String get iconPickerIconsTab => 'אייקונים';

  @override
  String get iconPickerCustomTab => 'מותאם אישית';

  @override
  String get iconPickerSearchHint => 'חיפוש אייקונים...';

  @override
  String get colorPickerTitle => 'בחר צבע';

  @override
  String get colorPickerPaletteTab => 'צבעים';

  @override
  String get iconGroupMoodPeople => 'מצב רוח ואנשים';

  @override
  String get iconGroupHealth => 'בריאות';

  @override
  String get iconGroupWorkFinance => 'עבודה וכספים';

  @override
  String get iconGroupHabitsGoals => 'הרגלים ומטרות';

  @override
  String get iconGroupNature => 'הטבע';

  @override
  String get iconGroupFoodDrink => 'אוכל ושתייה';

  @override
  String get iconGroupHome => 'בית';

  @override
  String get iconGroupTravel => 'נסיעות';

  @override
  String get iconGroupSymbols => 'סמלים';

  @override
  String get tagCategoryLabel => 'קטגוריה';

  @override
  String get tagLabel => 'תג';

  @override
  String get tagCategoryUncategorized => 'לא מסווג';

  @override
  String get newCategoryTitle => 'קטגוריה חדשה';

  @override
  String get shareButtonLabel => 'שתף';

  @override
  String get importErrorDescription => 'ייבוא הקובץ נכשל!';

  @override
  String get exportErrorDescription => 'ייצוא הקובץ נכשל!';

  @override
  String get deleteTitle => 'מחק';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      two: ' הוא משמש ב-$count רשומות ביומן.',
      other: ' הוא משמש ב-$count רשומות ביומן.',
      one: ' הוא משמש בערך ביומן אחד.',
      zero: '',
    );
    return 'למחוק את \"$name\"?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      two: ' גם $count התגים שלו יימחקו.',
      other: ' גם $count התגים שלו יימחקו.',
      one: ' תג $count שלו גם יימחק.',
      zero: '',
    );
    return 'למחוק את \"$name\"?$_temp0';
  }

  @override
  String get tagNameExists => 'יש כבר תג עם השם הזה';

  @override
  String get categoryNameExists => 'יש כבר קטגוריה בשם הזה';

  @override
  String deleteTemplateMessage(Object name) {
    return 'למחוק את \"$name\"?';
  }

  @override
  String get addTagsTitle => 'הוסף תגיות';

  @override
  String get addTagsSearchHint => 'חפש תגיות...';

  @override
  String get tagFavoriteName => 'מועדף';

  @override
  String get iconGroupActivities => 'פעילויות';

  @override
  String get iconGroupHobbies => 'בידור';

  @override
  String get settingsStorageTitle => 'אחסון';

  @override
  String get settingsLogFolder => 'תיקיית ערך יומן';

  @override
  String get settingsImageFolder => 'תיקיית תמונות';

  @override
  String get warningTitle => 'אזהרה';

  @override
  String get logFolderWarningDescription =>
      'אם התיקיה שנבחרה כבר מכילה קובץ \'aid_diary.db\', הוא ישמש כדי להחליף את רשומות היומן הקיימות שלך!';

  @override
  String get errorTitle => 'שגיאה';

  @override
  String get logFolderErrorDescription => 'שינוי תיקיית רשומת היומן נכשל!';

  @override
  String get imageFolderErrorDescription => 'שינוי תיקיית התמונות נכשל!';

  @override
  String get backupErrorDescription => 'יצירת הגיבוי נכשלה!';

  @override
  String get restoreErrorDescription => 'שחזור הגיבוי נכשל!';

  @override
  String get settingsBackupRestoreTitle => 'גיבוי ושחזור';

  @override
  String get settingsBackup => 'גיבוי';

  @override
  String get settingsRestore => 'שחזר';

  @override
  String get settingsRestorePromptDescription =>
      'שחזור גיבוי יחליף את הנתונים הקיימים שלך!';

  @override
  String get settingsBackupPasswordProtect => 'גיבויים להגנת סיסמה';

  @override
  String get backupEncryptedTitle => 'גיבוי מוצפן';

  @override
  String get backupEncryptedContent => 'גיבוי זה מוגן בסיסמה.';

  @override
  String get settingsAutoBackup => 'גיבויים אוטומטיים';

  @override
  String get settingsAutoBackupLocation => 'מיקום גיבוי';

  @override
  String get settingsAutoBackupInterval => 'מרווח גיבוי';

  @override
  String get settingsAutoBackupIntervalDaily => 'יומי';

  @override
  String get settingsAutoBackupIntervalWeekly => 'שבועי';

  @override
  String get settingsAutoBackupIntervalMonthly => 'חודשי';

  @override
  String get settingsAutoBackupMaxCount => 'גיבויים לשמירה';

  @override
  String get settingsAutoBackupRequireCharging => 'רק בזמן טעינה';

  @override
  String settingsBackupLast(Object time) {
    return 'גיבוי אחרון $time';
  }

  @override
  String get settingsBackupNever => 'מעולם לא גובו';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'הגיבוי הבא $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'הכל';

  @override
  String get autoBackupFailedTitle => 'הגיבוי נכשל';

  @override
  String tranferStatus(Object percent) {
    return 'מעביר… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'יוצר גיבוי... $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'משחזר את הגיבוי... $percent%';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return 'מצפין גיבוי... $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'מפענח גיבוי... $percent%';
  }

  @override
  String get cleanUpStatus => 'מנקה…';

  @override
  String get settingsExportToAnotherFormat => 'ייצוא לפורמט אחר';

  @override
  String get settingsExportFormatDescription => 'אין להשתמש בזה כגיבוי!';

  @override
  String get settingsImportFromAnotherApp => 'ייבוא מאפליקציה אחרת';

  @override
  String get logFormatTitle => 'בחר פורמט';

  @override
  String get logFormatDescription =>
      'ייתכן שהפורמט של אפליקציה אחרת לא תומך בכל התכונות. אנא דווח על כל בעיה שכן פורמטים של צד שלישי עשויים להשתנות בכל עת. זה לא ישפיע על רשומות יומן קיימות!';

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
  String get settingsDeleteAllLogsTitle => 'מחק את כל רשומות היומן';

  @override
  String get settingsDeleteAllLogsDescription =>
      'האם ברצונך למחוק את כל רשומות היומן שלך?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'הזן \'$prompt\' כדי לאשר. אי אפשר לבטל את זה!';
  }

  @override
  String get settingsAppLanguageTitle => 'שפת האפליקציה';

  @override
  String get settingsSecurityTitle => 'אבטחה';

  @override
  String get settingsSecurityRequirePassword => 'דרוש סיסמה';

  @override
  String get settingsSecurityEnterPassword => 'הזן סיסמה';

  @override
  String get settingsSecuritySetPassword => 'הגדר סיסמה';

  @override
  String get settingsSecurityChangePassword => 'שנה סיסמה';

  @override
  String get settingsSecurityPassword => 'סיסמה';

  @override
  String get settingsSecurityConfirmPassword => 'אשר את הסיסמה';

  @override
  String get settingsSecurityOldPassword => 'סיסמה ישנה';

  @override
  String get settingsSecurityIncorrectPassword => 'סיסמה שגויה';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'הסיסמאות אינן תואמות';

  @override
  String get requiredPrompt => 'חובה';

  @override
  String get settingsSecurityBiometricUnlock => 'פתיחה ביומטרית';

  @override
  String get unlockAppPrompt => 'בטל את נעילת האפליקציה';

  @override
  String get settingsAboutTitle => 'בערך';

  @override
  String get settingsVersion => 'גרסה';

  @override
  String get settingsLicense => 'רישיון';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsOpenSourceLicenses => 'רישיונות קוד פתוח';

  @override
  String get tagMoodTitle => 'מצב רוח';

  @override
  String get selectTagTitle => 'בחר תג';

  @override
  String get labelPresentLabel => 'הווה';

  @override
  String get labelAbsentLabel => 'נעדר';

  @override
  String get labelCoverageLabel => 'כיסוי';

  @override
  String chartDistributionTitle(Object tag) {
    return 'הפצת $tag';
  }

  @override
  String get shareAddToLogPickerTitle => 'בחר ערך ביומן';

  @override
  String get adaptiveEmptyDay => 'אין עדיין רשומות ליום זה';

  @override
  String get adaptiveNewEntry => 'כתוב ערך';

  @override
  String get pageJournalTitle => 'יומן';

  @override
  String get coachPrompt1 => 'מה גרם לך לחייך היום?';

  @override
  String get coachPrompt2 => 'מהו דבר אחד שלמדת היום?';

  @override
  String get coachPrompt3 => 'עם מי דיברת היום ואיך זה הרגיש?';

  @override
  String get coachPrompt4 => 'על מה אתה אסיר תודה עכשיו?';

  @override
  String get coachPrompt5 => 'מה לקח את רוב האנרגיה שלך היום?';

  @override
  String get coachPrompt6 => 'תאר רגע קטן שאתה רוצה לזכור.';

  @override
  String get coachPrompt7 => 'מה יהפוך את מחר ליום טוב?';

  @override
  String get coachPrompt8 => 'מה עובר לך בראש לאחרונה?';

  @override
  String get coachPrompt9 => 'מה עשית היום רק בשביל עצמך?';

  @override
  String get coachPrompt10 => 'אם להיום הייתה כותרת, מה היא הייתה?';

  @override
  String get pageMediaTitle => 'מדיה';

  @override
  String get pageAtlasTitle => 'אטלס';

  @override
  String get pageCoachTitle => 'מאמן';

  @override
  String get noEntrySelected => 'לא נבחרה ערך.';

  @override
  String get entryShare => 'שתף';

  @override
  String get entryFavorite => 'כוכב';

  @override
  String get entryEdit => 'ערוך';

  @override
  String get entryPrevious => 'כניסה קודמת';

  @override
  String get entryNext => 'הכניסה הבאה';

  @override
  String get journalStories => 'סיפורים';

  @override
  String get journalEntries => 'ערכים';

  @override
  String get journalEmptyHint => 'התחל את היומן שלך על ידי הוספת ערך חדש.';

  @override
  String get storyToday => 'היום';

  @override
  String get storyThrowback => 'השלכה לאחור';

  @override
  String get storyNoThrowback => 'אין השלכה לאחור היום';

  @override
  String get mediaFiles => 'קבצי מדיה';

  @override
  String get mediaEmpty => 'עדיין אין תמונות.';

  @override
  String get mediaEmptyHint => 'תמונות המצורפות לערכים יוצגו כאן.';

  @override
  String get atlasEmpty => 'אין ערכים עם מיקום.';

  @override
  String get atlasEmptyHint => 'ערכים עם מיקום יוצגו כאן.';

  @override
  String get atlasShowAll => 'הצג את כל הערכים';

  @override
  String get atlasMyLocation => 'המיקום שלי';

  @override
  String get coachAll => 'הכל';

  @override
  String get coachPrograms => 'תוכניות';

  @override
  String get coachTemplates => 'תבניות';

  @override
  String get coachKindProgram => 'תוכנית';

  @override
  String get coachKindTemplate => 'תבנית';

  @override
  String get coachNoTemplates => 'אין תוכניות או תבניות.';

  @override
  String get coachUseTemplate => 'כתוב עם התבנית הזו';

  @override
  String get coachProgramEverydayTitle => 'רגעים יומיומיים';

  @override
  String get coachProgramEverydayDescription =>
      'חמש שאלות קצרות, אחת ביום. כל אחד מהם לוקח דקה או שתיים ועוזר לך לראות מה הפך את היום לשלך. דרך עדינה לבנות את ההרגל לכתוב קצת כל יום.';

  @override
  String get coachProgramReflectTitle => 'מסתכל פנימה';

  @override
  String get coachProgramReflectDescription =>
      'שאלה אחת עמוקה יותר בשבוע, במשך חמישה שבועות. קח את הזמן שלך עם כל אחד מהם: איך הרגשת, מה שוחק אותך, על מה אתה אסיר תודה.';

  @override
  String get searchFilters => 'מסננים';

  @override
  String get searchFilterTags => 'תגים';

  @override
  String get searchFilterStarred => 'מסומן בכוכב';

  @override
  String get searchHint => 'הקלד כדי לחפש, או בחר מסנן.';

  @override
  String get locationTitle => 'מיקום';

  @override
  String get locationName => 'שם מקום';

  @override
  String get locationRemove => 'הסר';

  @override
  String get locationServiceDisabled => 'שירותי המיקום כבויים.';

  @override
  String get locationPermissionDenied => 'הרשאת המיקום נדחתה.';

  @override
  String get locationUnavailable => 'לא ניתן היה לקבל את המיקום הנוכחי.';

  @override
  String get calendarJumpToToday => 'קפוץ להיום';

  @override
  String get editorStartWriting => 'התחל לכתוב או בחר א ';

  @override
  String get editorTemplateLink => 'תבנית';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'בחר תבנית';

  @override
  String get templateFeatured => 'תבניות מומלצות';

  @override
  String get templateMine => 'התבניות שלי';

  @override
  String get templateDailyName => 'סקירה יומית';

  @override
  String get templateDailyDescription =>
      'מה קרה, איך זה הרגיש ומה יבוא אחר כך.';

  @override
  String get templateDailyText =>
      '## מה קרה היום\n\n\n## איך הרגשתי\n\n\n## שלושה דברים שאני אסיר תודה עליהם\n1. \n2. \n3. \n\n## מחר\n';

  @override
  String get templateTravelName => 'רישום יומן מסע';

  @override
  String get templateTravelDescription => 'מקומות, רגעים ואוכל מהכביש.';

  @override
  String get templateTravelText =>
      '## לאן הלכתי\n\n\n## הרגע שאני הכי זוכר\n\n\n## מה אכלתי\n\n\n## תוכניות למחר\n';

  @override
  String get templateReadingName => 'קריאת הערות';

  @override
  String get templateReadingDescription => 'ציטוטים ומחשבות ממה שקראת.';

  @override
  String get templateReadingText =>
      '## ספר\n\n\n## איפה אני\n\n\n## ציטוטים\n> \n\n## המחשבות שלי\n';

  @override
  String get templateWeeklyName => 'סקירה שבועית';

  @override
  String get templateWeeklyDescription => 'דגשים, מאבקים והתמקדות בשבוע הבא.';

  @override
  String get templateWeeklyText =>
      '## דגשים\n\n\n## מה היה קשה\n\n\n## מה שלמדתי\n\n\n## פוקוס לשבוע הבא\n';

  @override
  String get entrySaveAsTemplate => 'שמור כתבנית';

  @override
  String get entrySavedAsTemplate => 'נשמר כתבנית';

  @override
  String get storyStatistics => 'סטטיסטיקה';

  @override
  String get storyMoodChart => 'טבלת מצב רוח';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return '$entries כניסות · $days ימים';
  }

  @override
  String get storyThisYear => 'השנה';

  @override
  String get storyLastYear => 'שנה שעברה';

  @override
  String get storyTapToOpen => 'הקש על יום כדי לפתוח אותו';

  @override
  String get settingsGeneralTitle => 'כללי';

  @override
  String get settingsDataTitle => 'נתונים ואחסון';

  @override
  String get settingsStoriesTitle => 'סיפורים';

  @override
  String get settingsHelpTitle => 'עזרה ואודות';

  @override
  String get weatherTitle => 'מזג אוויר';

  @override
  String get weatherClear => 'ברור';

  @override
  String get weatherPartlyCloudy => 'מעונן חלקית';

  @override
  String get weatherCloudy => 'מעונן';

  @override
  String get weatherFog => 'ערפל';

  @override
  String get weatherDrizzle => 'טפטוף';

  @override
  String get weatherRain => 'גשם';

  @override
  String get weatherSnow => 'שלג';

  @override
  String get weatherStorm => 'סופת רעמים';

  @override
  String get weatherFetch => 'קבל מזג אוויר עבור ערך זה';

  @override
  String get weatherNeedsLocation => 'הוסף תחילה מיקום עם קואורדינטות.';

  @override
  String get weatherUnavailable => 'מזג האוויר אינו זמין עבור המקום והזמן הזה.';

  @override
  String get weatherRemove => 'הסר מזג אוויר';

  @override
  String get weatherTemperature => 'טמפרטורה';

  @override
  String get activityStill => 'בכל זאת';

  @override
  String get activityWalking => 'הליכה';

  @override
  String get activityRunning => 'ריצה';

  @override
  String get activityCycling => 'רכיבה על אופניים';

  @override
  String get activityVehicle => 'ברכב';

  @override
  String get activityFlying => 'עף';

  @override
  String get activityExercise => 'פעילות גופנית';

  @override
  String get settingsAutoAddTitle => 'הוסף אוטומטית';

  @override
  String get settingsAutoAddLocation => 'מיקום';

  @override
  String get settingsAutoAddWeather => 'מזג אוויר';

  @override
  String get settingsAutoAddHint => 'ערכים חדשים ימלאו אותם כאשר הם נוצרים.';

  @override
  String get settingsTemperatureUnit => 'יחידת טמפרטורה';

  @override
  String get settingsCelsius => 'צלזיוס (°C)';

  @override
  String get settingsFahrenheit => 'פרנהייט (°F)';

  @override
  String get moodGreat => 'נהדר';

  @override
  String get moodGood => 'טוב';

  @override
  String get moodOkay => 'בסדר';

  @override
  String get moodBad => 'רע';

  @override
  String get moodAwful => 'נורא';

  @override
  String get locationSearchHint => 'חפש מקום';

  @override
  String get locationSearchEmpty => 'לא נמצאו מקומות';

  @override
  String get settingsWallpaper => 'טפט';

  @override
  String get wallpaperNone => 'אין';

  @override
  String get wallpaperDots => 'נקודות';

  @override
  String get wallpaperGrid => 'רשת';

  @override
  String get wallpaperLines => 'קווים';

  @override
  String get wallpaperPhoto => 'תמונה…';

  @override
  String get settingsFontFamily => 'גופן';

  @override
  String get fontSystem => 'מערכת';

  @override
  String get fontSerif => 'סריף';

  @override
  String get fontMono => 'מונוספייס';

  @override
  String get settingsFontSize => 'גודל גופן';

  @override
  String get fontSizeSmall => 'קטן';

  @override
  String get fontSizeMedium => 'בינוני';

  @override
  String get fontSizeLarge => 'גדול';

  @override
  String get fontSizeExtraLarge => 'גדול במיוחד';

  @override
  String get settingsLineSpacing => 'מרווח בין שורות';

  @override
  String get lineSpacingCompact => 'קומפקטי';

  @override
  String get lineSpacingNormal => 'רגיל';

  @override
  String get lineSpacingRelaxed => 'רגוע';

  @override
  String get moodAssociationsTitle => 'מה גורם לי להרגיש…';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching של ערכי $total';
  }

  @override
  String get videoRecord => 'הקלט סרטון';

  @override
  String get videoChoose => 'בחר סרטון';

  @override
  String get audioRecordTitle => 'הקלט הערה קולית';

  @override
  String get audioChoose => 'בחר קובץ שמע';

  @override
  String get audioStart => 'הקלט';

  @override
  String get audioStop => 'עצור ושמור';

  @override
  String get audioPermissionDenied =>
      'הגישה למיקרופון כבויה. אפשר זאת בהגדרות המערכת.';

  @override
  String get mediaTooLarge => 'סרטון זה גדול מכדי לצרף.';

  @override
  String get mediaUnavailable => 'קובץ מצורף זה אינו זמין במכשיר זה.';

  @override
  String get widgetDone => 'הערך של היום כתוב';

  @override
  String get widgetPending => 'איך היה היום שלך?';

  @override
  String get widgetWrite => 'כתוב';

  @override
  String get insertChecklist => 'רשימת תיוג';

  @override
  String get insertNumberedList => 'רשימה ממוספרת';

  @override
  String get insertTable => 'שולחן';

  @override
  String get insertDivider => 'מחלק';

  @override
  String get insertCodeBlock => 'בלוק קוד';

  @override
  String get journalSortTitle => 'מיין ערכים';

  @override
  String get journalSortUpdated => 'עודכן לאחרונה';

  @override
  String get settingsTimeFormat => 'פורמט זמן';

  @override
  String get settingsDayStart => 'כניסות חדשות נחשבות ליום הקודם עד';

  @override
  String get settingsDayAskUntil => 'ואז תשאל לאיזה יום עד';

  @override
  String get settingsDayStartMidnight => 'כבוי';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'כל ערך שומר את היום שאליו הוא שייך לצד השעה שנכתבה, וניתן לשנות את היום הזה בעורך בכל עת. שעות אלו בוחרים רק את היום עבור ערכים חדשים, כך ששינוים לא יזיז אף ערך קיים.';

  @override
  String get lateNightBadge => 'נכתב בשעת לילה מאוחרת, נספר ליום הקודם';

  @override
  String editorDayAsk(String time) {
    return 'נכתב ב-$time. לאיזה יום זה מיועד?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (אתמול)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (היום)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'נכתב $when';
  }

  @override
  String get timeFormat12 => '12 שעות';

  @override
  String get timeFormat24 => '24 שעות';

  @override
  String get settingsReminderDays => 'תזכיר לי הלאה';

  @override
  String get locationRecent => 'מקומות אחרונים';

  @override
  String get shareImage => 'שתף תמונה';

  @override
  String get shareSaveImage => 'שמור תמונה';

  @override
  String get shareSaved => 'התמונה נשמרה';

  @override
  String get deletedTitle => 'נמחק לאחרונה';

  @override
  String get deletedNone => 'שום דבר לא נמחק לאחרונה';

  @override
  String deletedHint(int days) {
    return 'ערכים שנמחקו נשארים כאן במשך $days ימים, ולאחר מכן נמחקים.';
  }

  @override
  String deletedDaysLeft(int days) {
    return 'נותרו $days ימים';
  }

  @override
  String get deletedRestore => 'שחזר';

  @override
  String get deletedDeleteForever => 'מחק לנצח';

  @override
  String get deletedDeleteForeverDescription =>
      'הערך והקבצים המצורפים שלו נמחקים. לא ניתן לבטל זאת.';

  @override
  String get deletedEmpty => 'ריק';

  @override
  String get deletedEmptyDescription =>
      'למחוק כל ערך ב- נמחק לאחרונה? לא ניתן לבטל זאת.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'הליכה אקראית';

  @override
  String get randomSubtitle => 'פתח ערך עבר';

  @override
  String get randomNext => 'אחר';

  @override
  String get randomAll => 'הכל';

  @override
  String get randomWithPhotos => 'עם תמונות';

  @override
  String get randomGoodDays => 'ימים טובים';

  @override
  String get randomEmpty => 'אין ערכים לבחירה';

  @override
  String get reviewWeekTitle => 'השבוע';

  @override
  String get reviewWeekSubtitle => 'השבוע שלך עד כה';

  @override
  String get reviewYearTitle => 'השנה';

  @override
  String get reviewEmpty => 'עדיין לא נכתב כלום';

  @override
  String get reviewEntries => 'ערכים';

  @override
  String get reviewDaysWritten => 'ימים כתובים';

  @override
  String get reviewWords => 'מילים';

  @override
  String get reviewPhotos => 'תמונות';

  @override
  String get reviewLongestRun => 'הריצה הארוכה ביותר של ימים';

  @override
  String get reviewAverageMood => 'מצב רוח ממוצע';

  @override
  String get reviewFavorites => 'לרוב';

  @override
  String get reviewByMonth => 'לפי חודש';

  @override
  String get reviewHighlight => 'הדגש';

  @override
  String get yearInPixels => 'שנה בפיקסלים';

  @override
  String get capsuleSeal => 'חותם כקפסולת זמן';

  @override
  String get capsuleTitle => 'קפסולת זמן';

  @override
  String capsuleOpensOn(Object date) {
    return 'נפתח ב-$date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'נכתב ב-$date';
  }

  @override
  String get capsuleOpenEarly => 'פתוח מוקדם';

  @override
  String get capsuleOpenEarlyDescription => 'הקפסולה נפתחת כעת ונשארת פתוחה.';

  @override
  String get capsuleOpened => 'קפסולת הזמן נפתחה';

  @override
  String get templateMorningName => 'דפי בוקר';

  @override
  String get templateMorningDescription => 'קבע את היום בשלוש דקות';

  @override
  String get templateMorningText =>
      '## שלושה דברים שאני רוצה לעשות טוב היום\n1. \n2. \n3. \n\n## משהו שאני מצפה לו\n\n## הערה לעצמי\n';

  @override
  String get templateEveningName => 'סקירת ערב';

  @override
  String get templateEveningDescription => 'סוגרים את היום במה שהלך טוב';

  @override
  String get templateEveningText =>
      '## שלושה דברים טובים היום\n1. \n2. \n3. \n\n## מה שלמדתי\n\n## מה יכול להשתפר מחר\n';

  @override
  String get routineMorning => 'בוקר טוב';

  @override
  String get routineEvening => 'סקירת ערב';

  @override
  String get settingsRoutinePrompts => 'הנחיות בוקר וערב';

  @override
  String get settingsRoutinePromptsHint => 'הצע את תבנית הבוקר או הערב בסטוריז';

  @override
  String get checkInTitle => 'צ\'ק אין מהיר';

  @override
  String get checkInSubtitle => 'מצב רוח בשתי ברזים';

  @override
  String get checkInMood => 'איך אתה מרגיש?';

  @override
  String get checkInActivity => 'מה אתה עושה?';

  @override
  String get checkInNote => 'שורה על זה (לא חובה)';

  @override
  String get checkInSave => 'שמור';

  @override
  String editorWordCount(int words, int characters) {
    return 'מילים $words · תווים $characters';
  }

  @override
  String get coachProgramEverydayTagline => 'שימו לב לדברים הקטנים ביום.';

  @override
  String get coachProgramReflectTagline => 'האטו והקשיבו לעצמכם.';

  @override
  String get coachDuration => 'משך זמן';

  @override
  String get coachInterval => 'מרווח';

  @override
  String get coachDifficulty => 'קושי';

  @override
  String get coachIntervalDaily => 'יומי';

  @override
  String get coachIntervalWeekly => 'שבועי';

  @override
  String get coachDifficultyBeginner => 'מתחיל';

  @override
  String get coachDifficultyIntermediate => 'ביניים';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      two: '$count ימים',
      other: '$count ימים',
      one: 'יום אחד',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      two: '$count שבועות',
      other: '$count שבועות',
      one: 'שבוע אחד',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'יום $n';
  }

  @override
  String coachWeekN(int n) {
    return 'שבוע $n';
  }

  @override
  String get coachEnroll => 'הירשם';

  @override
  String get coachEndProgram => 'סיום התוכנית';

  @override
  String get coachAuthor => 'מחבר';

  @override
  String get coachAuthorBio => 'הנחיות שנכתבו עבור אפליקציה זו.';

  @override
  String get coachEnrolledTip => 'הכל מוכן! השאלות שלך יופיעו בסטוריז.';

  @override
  String get coachGoToStories => 'עבור אל סיפורים';

  @override
  String get coachAnswerHint => 'כתבו את תשובתכם…';

  @override
  String get storyWrapUp => 'זה הכל להיום.';

  @override
  String get storyTapToClose => 'הקש כדי לסגור';

  @override
  String get coachAnswerDone => 'בוצע';

  @override
  String get coachAnswered => 'ענה, הקש כדי לפתוח';

  @override
  String get coachAnsweredEarlier => 'ענה';

  @override
  String get locationLocating => 'מאתר...';

  @override
  String get locationPickPlace => 'בחר מקום';

  @override
  String get locationPlacesHint => 'כתובת או שם המקום';

  @override
  String get locationCustom => 'מקום מותאם אישית';

  @override
  String get locationCurrent => 'מיקום נוכחי';

  @override
  String get locationSaved => 'מקומות שמורים';

  @override
  String get locationSearchResults => 'תוצאות חיפוש';

  @override
  String get locationNearby => 'מקומות קרובים';

  @override
  String get locationRename => 'שנה שם';

  @override
  String get locationSavePlace => 'שמור מקום';

  @override
  String get locationUnsavePlace => 'הסר ממקומות שמורים';

  @override
  String get shareAs => 'שתף כ...';

  @override
  String get shareAsImage => 'תמונה';

  @override
  String get shareAsZip => 'ZIP עם המדיה המקורית';

  @override
  String get shareAsPlainText => 'טקסט רגיל';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'ברוכים הבאים ל-AID Diary';

  @override
  String get onboardWelcomeText =>
      'התחל כאן, או חבר מכשיר זה למכשיר שאתה כבר משתמש בו.';

  @override
  String get onboardStart => 'תתחיל לכתוב';

  @override
  String get helpFaq => 'שאלות נפוצות';

  @override
  String get helpFaq1Q => 'היכן נשמר היומן שלי?';

  @override
  String get helpFaq1A =>
      'היומן שלך מאוחסן במכשיר זה. הוא מגיע למכשירים אחרים או לאחסון רק כאשר אתה מאפשר סנכרון, שיתוף או ייצוא שלו. הסנכרון מוצפן מקצה לקצה.';

  @override
  String get helpFaq2Q => 'כיצד אוכל לשמור עותק או לעבור למכשיר חדש?';

  @override
  String get helpFaq2A =>
      'התחבר למכשיר קיים בהגדרות ← נתונים ואחסון ← סנכרון ואשר הרשאה במכשיר שיש לו את היומן שלך. שני המכשירים נשארים שמישים. אתה יכול גם ליצור גיבוי ולשחזר אותו במכשיר אחר.';

  @override
  String get helpFaq3Q => 'האם אני יכול להביא ערכים מאפליקציות יומן אחרות?';

  @override
  String get helpFaq3A =>
      'כן: בהגדרות ← נתונים ואחסון, ייבא יצוא מ-Daylio, Diarium, Diaro, DayBook, My Brain, OneShot ו-Pixels, או ייצוא JSON.';

  @override
  String get helpFaq4Q => 'איך עובדות תוכניות מאמנים?';

  @override
  String get helpFaq4A =>
      'הירשם לתוכנית בדף המאמן. בכל יום או שבוע מחכה שאלה חדשה בסטוריז; התשובה שלך נשמרת כערך.';

  @override
  String get helpFaq5Q => 'מה אם אשכח את קוד הסיסמה שלי?';

  @override
  String get helpFaq5A =>
      'לא ניתן לשחזר את קוד הגישה, אז שמור גיבוי של היומן שלך.';

  @override
  String get helpPrivacy => 'פרטיות';

  @override
  String get helpPrivacyText =>
      'תוכן יומן ומדיה נשארים במכשיר הזה אלא אם תפעיל סנכרון מוצפן או שתף/ייצא אותם. מפות, חיפוש מקומות ומזג אוויר משתמשים בשירותים המוגדרים ושולחים את המיקום או שאילתת החיפוש הדרושים לבקשה זו, לא טקסט יומן.';

  @override
  String get photoMetaTitle => 'להשתמש בפרטי התמונה?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'לספור את הערך הזה עבור $date ולהגדיר את מקומו ל-$place, כפי שנרשם בתמונה?';
  }

  @override
  String photoMetaDate(String date) {
    return 'לספור את הערך הזה עבור $date, כאשר התמונה צולמה?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'להגדיר את המקום של ערך זה ל-$place, היכן צולמה התמונה?';
  }

  @override
  String get photoMetaApply => 'השתמש בהם';

  @override
  String get quickWriteTitle => 'כתיבה מהירה';

  @override
  String get quickWriteText => 'הקש כדי להתחיל ערך חדש.';

  @override
  String get settingsQuickWriteTitle => 'כתיבה מהירה בהתראות';

  @override
  String get settingsQuickWriteDescription => 'שמור הודעה שפותחת ערך חדש.';

  @override
  String get settingsNudgesTitle => 'דחף אותי אחרי מתיחה שקטה';

  @override
  String settingsNudgesDescription(int days) {
    return 'תזכורת עדינה כשלא כתבת במשך $days ימים.';
  }

  @override
  String get nudgeTitle => 'עבר זמן מה';

  @override
  String get nudgeMonday => 'שבוע חדש: למה אתם מצפים?';

  @override
  String get nudgeTuesday => 'מספיקות שתי שורות. מה שלומך היום?';

  @override
  String get nudgeWednesday => 'באמצע השבוע. מה בלט עד כה?';

  @override
  String get nudgeThursday => 'משהו קטן ששווה לשמור מהיום?';

  @override
  String get nudgeFriday => 'השבוע מסתיים. שימו לב לרגע אחד טוב.';

  @override
  String get nudgeSaturday => 'שבת איטית היא יום טוב לכתיבה.';

  @override
  String get nudgeSunday => 'תסתכל אחורה על השבוע לפני שהוא מסתיים.';

  @override
  String get photoWidgetEmpty => 'תמונות שתוסיף לערכים מופיעות כאן.';

  @override
  String get channelReminders => 'תזכורות';

  @override
  String get channelOnThisDay => 'ביום הזה';

  @override
  String get channelCoach => 'המאמן מבקש';

  @override
  String get channelNudges => 'דחיפות אחרי ימים שקטים';

  @override
  String get channelQuickWrite => 'כתיבה מהירה';

  @override
  String get channelBackup => 'גיבויים';

  @override
  String get formatJsonExport => 'JSON (יצוא AID Diary)';

  @override
  String get aboutModifiedNotice =>
      'גרסה שונה של Daily You מאת Demizo ותורמים. זו לא האפליקציה הרשמית של Daily You.';

  @override
  String get toolbarPhotos => 'הוסף תמונות';

  @override
  String get toolbarMedia => 'תמונות וסרטונים';

  @override
  String get mediaFromGallery => 'בחר מתוך הגלריה';

  @override
  String get mediaFromFiles => 'בחר מתוך קבצים';

  @override
  String get editorLeaveTitle => 'לשמור את הערך הזה?';

  @override
  String get editorLeaveDiscard => 'אל תחסוך';

  @override
  String get editorTitleHint => 'כותרת';

  @override
  String get editorLocating => 'מאתר...';

  @override
  String get toolbarVideo => 'וידאו';

  @override
  String get toolbarAudio => 'הערה קולית';

  @override
  String get toolbarTags => 'תגים';

  @override
  String get toolbarBulletList => 'רשימת תבליטים';

  @override
  String get toolbarHeading => 'כותרת';

  @override
  String get toolbarBold => 'נועז';

  @override
  String get toolbarItalic => 'נטוי';

  @override
  String get toolbarHighlight => 'הדגש';

  @override
  String get toolbarStrikethrough => 'חוצה';

  @override
  String get toolbarQuote => 'ציטוט';

  @override
  String get toolbarLink => 'קישור';

  @override
  String get toolbarInsert => 'הכנס';

  @override
  String get toolbarUndo => 'בטל';

  @override
  String get toolbarRedo => 'בצע מחדש';

  @override
  String get toolbarInsertDate => 'הכנס את התאריך';

  @override
  String get toolbarInsertTime => 'הכנס את השעה';

  @override
  String get settingsSyncTitle => 'סנכרון ענן';

  @override
  String get syncOffDescription =>
      'שמור את היומן הזה זהה בכל המכשירים שלך דרך Google Drive או שרת WebDAV, כגון Nextcloud, Synology או Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'סנכרון עם Google Drive';

  @override
  String get syncOrWebDav => 'או שרת WebDAV';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn => 'מחובר. אתה יכול לחזור אל AID Diary.';

  @override
  String get syncGoogleSignInAgain => 'Google צריכה שתיכנס שוב.';

  @override
  String get syncSignInAgain => 'היכנס שוב';

  @override
  String get settingsCommandLineTitle => 'שורת הפקודה';

  @override
  String get commandLineToggle => 'ממשק שורת הפקודה';

  @override
  String get commandLineToggleHint =>
      'מאפשר לפקודת העזרה ולתוכניות אחרות במכשיר זה להשתמש בפקודות האפליקציה.';

  @override
  String get commandLineAlwaysOn => 'תמיד בפיתוח בונה.';

  @override
  String commandLineListening(int port) {
    return 'האזנה ביציאה $port';
  }

  @override
  String get commandPaletteTitle => 'כל הפקודות';

  @override
  String get commandPaletteSearch => 'חיפוש פקודות';

  @override
  String get commandPaletteRun => 'רוץ';

  @override
  String get commandPaletteConfirm => 'אי אפשר פשוט לבטל את זה. להפעיל את זה?';

  @override
  String syncReceiving(int done, int total) {
    return 'מקבל $done של $total...';
  }

  @override
  String syncSending(int done, int total) {
    return 'שולח $done של $total...';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'הגישה אל Google Drive לא הותרה. התחבר שוב וסמן את Google Drive בעמוד של גוגל.';

  @override
  String get syncEntryUnsynced => 'לא מסונכרן: הסנכרון האחרון לא עבר';

  @override
  String get syncUseOfficial => 'השתמש בשרת סינכרון AID';

  @override
  String get syncServer => 'כתובת שרת';

  @override
  String get syncUsername => 'שם משתמש';

  @override
  String get syncPassword => 'סיסמה';

  @override
  String get syncConnect => 'התחבר';

  @override
  String get syncConnecting => 'מתחבר...';

  @override
  String get syncSignInFailed =>
      'לא ניתן להיכנס. בדוק את הכתובת, שם המשתמש והסיסמה.';

  @override
  String syncConnectFailed(String error) {
    return 'לא ניתן להתחבר: $error';
  }

  @override
  String get syncNewSpaceTitle => 'התחל לסנכרן';

  @override
  String get syncNewSpaceDescription =>
      'אין כאן עדיין יומן מסונכרן. יומן זה יועלה, מוצפן מקצה לקצה עם מפתח שיישאר במכשירים שלך.';

  @override
  String get syncJoinTitle => 'הצטרפו ליומן המסונכרן';

  @override
  String get syncWrongKey => 'קוד שחזור זה אינו פותח את היומן המסונכרן.';

  @override
  String syncLastSynced(String time) {
    return 'סנכרון אחרון $time';
  }

  @override
  String get syncNever => 'עדיין לא מסונכרן';

  @override
  String get syncSyncing => 'מסנכרן...';

  @override
  String syncFailed(String error) {
    return 'הסנכרון האחרון נכשל: $error';
  }

  @override
  String get syncLocked =>
      'היומן המסונכרן שייך כעת למכשירים אחרים, או הופעל מחדש. התאם לאחד מהם או השתמש בקוד השחזור כדי להמשיך לסנכרן.';

  @override
  String get syncNow => 'סנכרן עכשיו';

  @override
  String get syncUnlock => 'פתח את הנעילה';

  @override
  String get syncEncrypted => 'מוצפן מקצה לקצה';

  @override
  String get syncDisconnect => 'הפסק לסנכרן';

  @override
  String get syncDisconnectDescription =>
      'מכשיר זה מפסיק לסנכרן. היומן כאן והעותק המסונכרן נשארים כפי שהם.';

  @override
  String get syncOwnRecoveryPassword => 'השתמש בסיסמת שחזור משלי';

  @override
  String get syncRecoveryPassword => 'סיסמת שחזור';

  @override
  String get syncRecoveryPasswordRepeat => 'חזור על סיסמת השחזור';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'השתמש לפחות בתווים $min';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'הסיסמאות שונות';

  @override
  String get syncRecoveryCode => 'קוד שחזור';

  @override
  String get syncRecoveryCodeTitle => 'שמור את קוד השחזור שלך';

  @override
  String get syncRecoveryCodeDescription =>
      'אם כל מכשיר שלך אבד, הקוד הזה משחזר את היומן המסונכרן שלך. שמור את זה במנהל סיסמאות או על נייר. זה מוצג רק פעם אחת.';

  @override
  String get syncRecoveryCodeCopied => 'קוד השחזור הועתק';

  @override
  String get syncRecoveryCodeSaved => 'שמרתי את זה';

  @override
  String get syncJoinNeedsKey =>
      'היומן המסונכרן הזה שייך למכשירים האחרים שלך. התאם לאחד מהם, או השתמש בקוד השחזור. הערכים במכשיר זה יתווספו אליו.';

  @override
  String get syncPairDevice => 'התאמה עם מכשיר';

  @override
  String get syncUseRecoveryCode => 'השתמש בקוד השחזור';

  @override
  String get syncAddDevice => 'הוסף מכשיר';

  @override
  String get syncChangeRecoveryCode => 'שנה את קוד השחזור';

  @override
  String get syncChangeRecoveryDescription =>
      'קוד חדש מחליף את הקוד הנוכחי, שמפסיק לעבוד. הנתונים והמכשירים האחרים שלך נשארים כפי שהם.';

  @override
  String get syncNewRandomCode => 'קוד אקראי חדש';

  @override
  String get syncRecoveryCodeChanged => 'קוד השחזור השתנה';

  @override
  String get syncResetSpace => 'התחל מחדש את היומן המסונכרן';

  @override
  String get syncResetSpaceDescription =>
      'רק כאשר שום מכשיר ושום קוד שחזור לא פותחים אותו יותר: העותק המסונכרן מוחלף ביומן במכשיר זה, מתחת למפתחות של מכשיר זה. המכשירים האחרים שלך יתחברו שוב.';

  @override
  String get syncPairTitle => 'התאם מכשירים';

  @override
  String get syncPairShow => 'הצג קוד';

  @override
  String get syncPairEnter => 'הזן קוד';

  @override
  String get syncPairShowHint =>
      'במכשיר השני שלך, פתח את הצמד מכשירים, בחר הזן קוד והקלד או סרוק את זה.';

  @override
  String get syncPairEnterHint =>
      'הקלד את הקוד שהמכשיר השני שלך מציג, או סרוק אותו.';

  @override
  String get syncPairCode => 'קוד זיווג';

  @override
  String get syncPairScan => 'סריקה';

  @override
  String get syncPairStart => 'זוג';

  @override
  String get syncPairWaiting => 'ממתין למכשיר השני...';

  @override
  String syncPairDone(String device) {
    return 'בשילוב עם $device';
  }

  @override
  String get syncPairWrongCode => 'הקוד לא תאם. הצג קוד חדש ונסה שוב.';

  @override
  String get syncPairNoOffer => 'אף מכשיר לא מציג את הקוד הזה. ייתכן שהוא פג.';

  @override
  String get syncPairTimedOut => 'המכשיר השני לא ענה בזמן.';

  @override
  String get syncPairNeither =>
      'אף אחד מהמכשירים עדיין לא מוגדר עם היומן המסונכרן הזה.';

  @override
  String get syncPairBoth => 'שני המכשירים כבר פותחים את היומן המסונכרן הזה.';

  @override
  String syncPairFailed(String error) {
    return 'ההתאמה נכשלה: $error';
  }

  @override
  String get syncMediaPending => 'יומן מסונכרן · חלק מהמדיה עדיין מועברת';

  @override
  String get syncWaitingForDevices =>
      'יומן מסונכרן · ממתין למכשיר אחר שיעביר מדיה';

  @override
  String get syncCacheNotice =>
      'מדיה בענן היא זמנית. שמור את המסמכים המקוריים במכשירים שלך; סנכרון אינו גיבוי.';

  @override
  String get paperTitle => 'נייר מכתבים';

  @override
  String get paperPlain => 'רגיל';

  @override
  String get paperLined => 'מרופדת';

  @override
  String get paperGrid => 'רשת';

  @override
  String get paperTinted => 'כהה';

  @override
  String get paperDecorationTitle => 'קישוטים';

  @override
  String get paperDecorationNone => 'אין';

  @override
  String get paperDecorationBotanical => 'עלים';

  @override
  String get paperDecorationStars => 'כוכבים';

  @override
  String get paperDecorationWashi => 'וואשי טייפ';

  @override
  String get themeDarkChoice => 'מראה אפל';

  @override
  String get themeDarkSame => 'עקוב אחר לוח הצבעים הבהיר';

  @override
  String get themeDarkCustom => 'פלטה נפרדת';

  @override
  String get themeDarkAccent => 'צבע מבטא כהה';

  @override
  String get themeColorTeal => 'צהבהב';

  @override
  String get themeColorCyan => 'ציאן';

  @override
  String get themeColorIndigo => 'אינדיגו';

  @override
  String get themeColorCoral => 'אלמוגים';

  @override
  String get themeColorOlive => 'זית';

  @override
  String get themeColorSlate => 'צפחה';

  @override
  String get drawingTitle => 'ציור';

  @override
  String get drawingPen => 'עט';

  @override
  String get drawingEraser => 'מחק';

  @override
  String get drawingUndo => 'בטל';

  @override
  String get drawingClear => 'ברור';

  @override
  String get drawingWidth => 'רוחב העט';

  @override
  String get drawingStylusOnly => 'סטיילוס בלבד';

  @override
  String get drawingDiscardTitle => 'לזרוק את הציור?';

  @override
  String get drawingDiscardBody => 'ציור זה לא נשמר.';

  @override
  String get drawingSaveError => 'לא ניתן לשמור את הציור.';

  @override
  String get syncNetworkTitle => 'אבחון רשת';

  @override
  String get syncNetworkRefresh => 'רענן';

  @override
  String get syncNetworkSelectedRoute => 'נתיב נוכחי';

  @override
  String get syncNetworkAvailableRoutes => 'שבילים זמינים';

  @override
  String get syncNetworkSignaling => 'חיבור ספריית מכשיר';

  @override
  String get syncNetworkRelayRemaining => 'קצבת ממסר שנותרה';

  @override
  String get syncNetworkIcePair => 'מועמדים לחיבור ישיר';

  @override
  String get syncNetworkPeerTrusted => 'מכשיר מאומת';

  @override
  String get syncNetworkNoRoute => 'מחכה לחיבור';

  @override
  String get syncNetworkUnavailable => 'אבחון אינו זמין';

  @override
  String get syncMediaCopiesTitle => 'משלוח מדיה והעתקים';

  @override
  String get syncMediaPendingCount => 'מחכה להעברה';

  @override
  String get syncMediaDurableCount => 'נמסר לאחסון אישי';

  @override
  String get syncMediaTemporaryCount => 'עותקים זמניים או לא מאושרים';

  @override
  String get syncMediaReceiptExplanation =>
      'ספירות אלה מתארות משלוחים שהושלמו, לא ביקורת חדשה של גיבויים ששרדו.';

  @override
  String get syncMediaCacheExplanation =>
      'מדיה ענן זמנית יכולה לפוג. שמור את המסמכים המקוריים שלך או גיבוי נפרד.';

  @override
  String get momentsTitle => 'רגעי צילום';

  @override
  String get momentsHint =>
      'מצא קבוצות באמצעות זמני צילום מקומיים וקואורדינטות אופציונליות. תמונות מצורפות רק כאשר אתה בוחר כרטיס.';

  @override
  String get momentsScan => 'מצא רגעים';

  @override
  String get momentsChooseFolder => 'בחר תיקיית תמונות';

  @override
  String get momentsLocation => 'כלול מיקומי תמונות';

  @override
  String get momentsEmpty => 'אין קבוצות תמונות אחרונות.';

  @override
  String get momentsCreate => 'כתבו על התמונות הללו';

  @override
  String get momentsDismiss => 'לבטל';

  @override
  String get momentsError => 'לא ניתן היה לקרוא תמונות מקומיות.';

  @override
  String get momentsCreated => 'ערך תמונה נוצר.';

  @override
  String get momentsPermission => 'אפשר גישה לתמונות כדי למצוא הצעות מקומיות.';

  @override
  String get momentsScope =>
      'תמונות אחרונות בלבד; לכל היותר 500 תמונות ו-20 תמונות לכל כרטיס.';

  @override
  String momentsPhotoCount(int count) {
    return 'תמונות $count';
  }

  @override
  String get nearbyTitle => 'חבר מכשירים';

  @override
  String get nearbySend => 'אשר מכשיר אחר';

  @override
  String get nearbyReceive => 'התחבר למכשיר קיים';

  @override
  String get nearbyInstructions =>
      'חבר את שני המכשירים לאותו Wi-Fi או לנקודה חמה זה של זה. אשר הרשאה במכשיר הקיים; שני המכשירים נשארים שימושיים. אין צורך באינטרנט.';

  @override
  String get nearbyCompare => 'השווה את הקוד הזה בשני המכשירים לפני האישור.';

  @override
  String get nearbyConfirm => 'הקודים תואמים';

  @override
  String get nearbyScan => 'סרוק את הקוד של המכשיר השני';

  @override
  String get nearbyPaste => 'הדבק הזמנה';

  @override
  String get nearbyWaiting => 'ממתין לאישור במכשיר השני';

  @override
  String get nearbyWorking => 'אישור וסנכרון היומן והקבצים המצורפים שלך...';

  @override
  String get nearbyPending =>
      'חלק מהקבצים המצורפים עדיין זקוקים לסנכרון. השאר את המכשיר השני מקוון ונסה שוב.';

  @override
  String get nearbyComplete => 'מכשיר מחובר; יומן וקבצים מצורפים מסונכרנים';

  @override
  String get nearbyFailed =>
      'החיבור לא הסתיים. בדוק את החיבור המקומי ונסה שוב.';

  @override
  String get nearbyEmptyRequired =>
      'השתמש במכשיר עם יומן ריק שעדיין לא מחובר לסנכרון.';

  @override
  String get nearbyRetry => 'המשך לסנכרן';

  @override
  String get nearbyWifi => 'הגדרות Wi-Fi';

  @override
  String get nearbyHotspot => 'הגדרות נקודה חמה';

  @override
  String get nearbyKeepOpen =>
      'השאר את הדף הזה פתוח עד שהמכשיר החדש יסתיים. תוקף ההזמנה יפוג לאחר שתי דקות.';

  @override
  String get syncDevicesTitle => 'מכשירים מורשים';

  @override
  String get syncDevicesDescription =>
      'רק מכשירים מאושרים יכולים לגשת לחשבון AID זה. ביטול התקן חוסם את השרת אך אינו יכול למחוק מפתח ראשי או יומן שכבר הועתק אליו.';

  @override
  String get syncDeviceRequest => 'הצג את QR האישור הזה למכשיר מאושר';

  @override
  String get syncDeviceAuthorize => 'אשר מכשיר';

  @override
  String get syncDeviceAuthorizeDescription =>
      'סרוק או הדבק את בקשת ההרשאה של המכשיר החדש.';

  @override
  String get syncDeviceRevoke => 'בטל';

  @override
  String get syncDeviceRotate => 'סובב את מפתח החתימה של המכשיר הזה';

  @override
  String get syncDeviceCheck => 'בדוק הרשאה';

  @override
  String get syncDeviceHardware => 'מפתח חתימה מגובה חומרה';

  @override
  String get syncDeviceSoftware => 'מפתח חתימת תוכנה שאינו ניתן לייצוא';

  @override
  String get syncDeviceUnavailable =>
      'הרשאת מכשיר אינה זמינה. אשר מכשיר זה ממכשיר מורשה אחר ונסה שוב.';

  @override
  String get syncDeviceRevoked => 'בוטל';

  @override
  String get syncDeviceLocal => 'המכשיר הזה';

  @override
  String get cloudTrafficTitle =>
      'מכסת העברת נתונים חודשית בענן עבור קובצי מדיה';

  @override
  String get cloudTrafficLimit => 'מכסת העברת נתונים חודשית';

  @override
  String get cloudTrafficUsed => 'נעשה שימוש בהעברת נתונים';

  @override
  String get cloudTrafficRemaining => 'נותרה העברת נתונים';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'מכסת העברת הנתונים מאפסת את $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'ניצלה מכסת העברת הנתונים בענן עבור קובצי מדיה. קבצי מדיה חסרים יסונכרנו אוטומטית כאשר חיבור ישיר זמין או שהמכסה תתאפס.';

  @override
  String get cloudTrafficExplanation =>
      'אחסון קבצי מדיה וממסר חי חולקים את מכסת העברת הנתונים הזו. חיבורים ישירים אינם צורכים אותו. לטקסט יומן ולהודעות בקרת חיבור יש מגבלות יומיות קטנות נפרדות.';

  @override
  String get appearanceThemeSection => 'נושא האפליקציה';

  @override
  String get appearancePaperSection => 'נייר יומן';

  @override
  String get appearanceTypographySection => 'טקסט יומן';

  @override
  String get appearancePreferencesSection => 'העדפות כלליות';

  @override
  String get themeSystemAccentHint =>
      'משתמש בלוח המערכת במקום בצבעים מותאמים אישית. כבה אותו כדי לבחור בעצמך.';

  @override
  String get syncDeviceNameSaveFailed =>
      'לא ניתן לשמור את שם המכשיר. אנא נסה שוב.';

  @override
  String get nearbyConnectionHelp => 'עזרה בחיבור';

  @override
  String get syncAllSynced => 'הכל מסונכרן';

  @override
  String get syncDetailsTitle => 'סנכרון פרטים';

  @override
  String get syncMore => 'אפשרויות נוספות';

  @override
  String get syncDeviceName => 'שם המכשיר';

  @override
  String get syncDeviceNameHint => 'לדוגמא: הטאבלט שלי';

  @override
  String get syncDeviceNameInvalid => 'השתמש ב-1 עד 32 תווים';

  @override
  String get syncDeviceKeyDetails => 'פרטי אבטחה';

  @override
  String get syncConnectionProblem =>
      'לא ניתן לסנכרן לעת עתה. מנסה שוב אוטומטית.';

  @override
  String get syncCopyComplete => 'עותק מלא של היומן וקובצי המדיה שלך';

  @override
  String get syncCopyPartial => 'חלק מהתקשורת עדיין נעדרת';

  @override
  String get syncCopyOlder => 'שינויים חדשים ממתינים לסנכרון';

  @override
  String get syncCopyUnavailable =>
      'פרטי העתקה אינם זמינים. נסה שוב מאוחר יותר.';

  @override
  String get syncCopyLastKnown =>
      'מכשירים אחרים מציגים את העותק המאושר האחרון שלהם. לא ניתן לבדוק מכשירים לא מקוונים כעת.';

  @override
  String get syncCopyTemporary =>
      'מטמון זמני. שמור את המסמכים המקוריים במכשירים שלך.';

  @override
  String get syncCopyStorage =>
      'אחסון הסנכרון שלך. העלאות מדיה שהושלמו רשומות באבחון.';

  @override
  String syncCopyChecked(String time) {
    return 'אושר לאחרונה $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'העברת נתונים שנותרה החודש: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'התחל כאן';

  @override
  String get onboardConnect => 'התחבר למכשיר קיים';

  @override
  String get onboardFailed =>
      'לא ניתן היה להשלים את ההגדרה. היומן שלך בטוח; אנא נסה שוב.';

  @override
  String get tutorialTitle => 'כיצד להשתמש ביומן';

  @override
  String get tutorialWriteTitle => 'כתוב את הערך הראשון שלך ביומן';

  @override
  String get tutorialWriteText =>
      'הקש על + כדי לכתוב רשומה ביומן. הוסף כותרת אופציונלית, בחר את תאריך היומן והקש על סימן הביקורת כדי לשמור. אתה יכול לערוך שוב את הערך ביומן שלך בכל עת.';

  @override
  String get tutorialMediaTitle => 'הוסף תמונות, אודיו או כתב יד';

  @override
  String get tutorialMediaText =>
      'השתמש ב-+ בעורך היומן כדי לצרף תמונות, סרטונים או הקלטת קול, או כדי לפתוח את בד כתב היד. קבצים מצורפים אלה נשמרים עם ערך היומן.';

  @override
  String get tutorialReviewTitle => 'מצא שוב יום';

  @override
  String get tutorialReviewText =>
      'עיין ביומן או בלוח השנה שלך, חפש בכתיבה שלך וארגן ערכים עם תגים. דפי המדיה והאטלס מאפשרים לך למצוא ערכים קודמים לפי תמונה או מיקום.';

  @override
  String get tutorialSyncTitle => 'השתמש ביותר ממכשיר אחד';

  @override
  String get tutorialSyncText =>
      'בהגדרות ← נתונים ואחסון ← סנכרון, התחבר למכשיר קיים ואשר הרשאה במכשיר זה. שני המכשירים יכולים להמשיך להשתמש ביומן. טקסט יומן מסתנכרן תחילה. קבצי מדיה מסתנכרנים לאחר מכן כאשר חיבור הרשת ומכסת העברת הנתונים שנותרה מאפשרים זאת.';

  @override
  String get tutorialPrivacyTitle => 'שמור על היומן שלך בטוח';

  @override
  String get tutorialPrivacyText =>
      'רשומות יומן נשארות במכשיר הזה אלא אם תפעיל סנכרון או שתף או ייצא אותן. הסנכרון מוצפן מקצה לקצה. בהגדרות תוכל גם להגדיר קוד גישה לאפליקציה, ליצור גיבויים ולפתוח מחדש את המדריך הזה.';

  @override
  String get editorDiaryDay => 'יום ביומן';

  @override
  String get editorDiaryDayPicker => 'יום ביומן · לאיזה יום שייכת הרשומה?';

  @override
  String editorCreatedAt(String time) {
    return 'נוצרה $time';
  }

  @override
  String get editorDiaryDayHint =>
      'היום שאליו שייכת הרשומה. שינוי היום אינו משנה את זמן יצירת הרשומה.';

  @override
  String get hiddenDiaryTitle => 'רשומות מוסתרות';

  @override
  String get hiddenDiaryHide => 'הסתרת רשומה';

  @override
  String get hiddenDiaryShow => 'ביטול הסתרת רשומה';

  @override
  String get hiddenDiaryEmpty => 'אין רשומות מוסתרות';

  @override
  String get hiddenDiaryUnlock => 'פתיחת רשומות מוסתרות';

  @override
  String get hiddenDiaryAuthHint =>
      'יש להשתמש בנעילת היישום או בנעילת המסך של המכשיר.';

  @override
  String hiddenDiaryWhere(String path) {
    return 'הוסתרה. כדי להציג שוב: $path';
  }

  @override
  String get noteKeep => 'שמירה';

  @override
  String get noteComment => 'תגובה';

  @override
  String get noteCommentHint => 'כתבו לעצמכם מהעבר';

  @override
  String get noteKept => 'הקטע נשמר';

  @override
  String get notesPassages => 'קטעים שמורים';

  @override
  String get notesComments => 'תגובות';

  @override
  String get noteDeleteConfirm => 'למחוק את ההערה?';

  @override
  String get editPastTitle => 'לערוך זיכרון מהעבר?';

  @override
  String get editPastBody =>
      'הרשומה הזו מיום קודם. כדי להגיב לה, בחרו טקסט לשמירה או לתגובה.';

  @override
  String get editPastDontAsk => 'אל תשאל שוב';

  @override
  String get editPastEdit => 'לערוך בכל זאת';

  @override
  String noteOnEntry(String date) {
    return 'על הרשומה מ־$date';
  }

  @override
  String get settingsConfirmEditPast => 'לשאול לפני עריכת רשומות קודמות';

  @override
  String get settingsCompressPhotos => 'דחיסת תמונות חדשות';

  @override
  String get settingsCompressPhotosHint =>
      'שמירת תמונות חדשות כ‑WebP בגודל כ‑1 MB. כשכבוי נשמרים המקוריים.';

  @override
  String get compressExistingTitle => 'דחיסת התמונות הקיימות';

  @override
  String compressExistingBody(int count, String size) {
    return '$count תמונות תופסות $size. אלה שמעל כ‑1 MB יהפכו ל‑WebP בגודל כ‑1 MB. זה מחליף אותן ואי אפשר לבטל; שמרו את המקוריים במקום אחר אם תרצו בהם.';
  }

  @override
  String get compressExistingAction => 'דחיסה';

  @override
  String compressExistingDone(int count, String size) {
    return 'נדחסו $count תמונות, נחסכו $size';
  }

  @override
  String get commentExpand => 'הרחבה';

  @override
  String get refAdd => 'ציטוט רשומה';

  @override
  String get refMissing => 'הרשומה הזו כבר לא כאן';

  @override
  String get moodClear => 'ניקוי מצב הרוח';

  @override
  String get scrollToTop => 'חזרה למעלה';

  @override
  String get feedbackTitle => 'משוב';

  @override
  String get feedbackHint => 'תיאור בעיה או הצעה';

  @override
  String get feedbackGithub => 'דיווח ב-GitHub';

  @override
  String get feedbackEmail => 'שליחת דוא״ל';

  @override
  String get feedbackCopy => 'העתקת טקסט';

  @override
  String get feedbackLaunchFailed =>
      'לא ניתן לפתוח את היישום. יש להעתיק את הטקסט ולהשתמש בדוא״ל למטה.';

  @override
  String get feedbackCopied => 'המשוב הועתק';
}
