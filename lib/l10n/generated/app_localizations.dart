import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_be.dart';
import 'app_localizations_bg.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_lt.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_oc.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('be'),
    Locale('bg'),
    Locale('ca'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fa'),
    Locale('fi'),
    Locale('fr'),
    Locale('he'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('lt'),
    Locale('ms'),
    Locale('nb'),
    Locale('nl'),
    Locale('oc'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('ro'),
    Locale('ru'),
    Locale('sv'),
    Locale('ta'),
    Locale('tr'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'AID Diary'**
  String get appTitle;

  /// No description provided for @themeColorTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme color'**
  String get themeColorTitle;

  /// No description provided for @themeColorHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a color to stop following the system accent. Applies to light and dark themes.'**
  String get themeColorHint;

  /// No description provided for @themeColorBlue.
  ///
  /// In en, this message translates to:
  /// **'Sky blue'**
  String get themeColorBlue;

  /// No description provided for @themeColorGreen.
  ///
  /// In en, this message translates to:
  /// **'Forest green'**
  String get themeColorGreen;

  /// No description provided for @themeColorBrown.
  ///
  /// In en, this message translates to:
  /// **'Warm coffee'**
  String get themeColorBrown;

  /// No description provided for @themeColorPurple.
  ///
  /// In en, this message translates to:
  /// **'Lavender'**
  String get themeColorPurple;

  /// No description provided for @themeColorRose.
  ///
  /// In en, this message translates to:
  /// **'Dusty rose'**
  String get themeColorRose;

  /// No description provided for @themeColorAmber.
  ///
  /// In en, this message translates to:
  /// **'Amber'**
  String get themeColorAmber;

  /// No description provided for @themeColorPreview.
  ///
  /// In en, this message translates to:
  /// **'A little every day'**
  String get themeColorPreview;

  /// No description provided for @themeTintBackgroundTitle.
  ///
  /// In en, this message translates to:
  /// **'Tint backgrounds with theme color'**
  String get themeTintBackgroundTitle;

  /// No description provided for @themeTintBackgroundHint.
  ///
  /// In en, this message translates to:
  /// **'Turn off for neutral gray backgrounds; buttons keep your chosen color.'**
  String get themeTintBackgroundHint;

  /// No description provided for @dailyReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Today!'**
  String get dailyReminderTitle;

  /// No description provided for @dailyReminderDescription.
  ///
  /// In en, this message translates to:
  /// **'Take your daily log…'**
  String get dailyReminderDescription;

  /// No description provided for @actionTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get actionTakePhoto;

  /// No description provided for @actionToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get actionToday;

  /// No description provided for @actionOtherDay.
  ///
  /// In en, this message translates to:
  /// **'Other day'**
  String get actionOtherDay;

  /// No description provided for @pageHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get pageHomeTitle;

  /// No description provided for @jumpToMonthTitle.
  ///
  /// In en, this message translates to:
  /// **'Jump to month'**
  String get jumpToMonthTitle;

  /// No description provided for @jumpToLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Jump to log'**
  String get jumpToLogTitle;

  /// No description provided for @flashbacksTitle.
  ///
  /// In en, this message translates to:
  /// **'Flashbacks'**
  String get flashbacksTitle;

  /// No description provided for @settingsFlashbacksExcludeBadDays.
  ///
  /// In en, this message translates to:
  /// **'Exclude bad days'**
  String get settingsFlashbacksExcludeBadDays;

  /// No description provided for @flaskbacksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No Flashbacks Yet…'**
  String get flaskbacksEmpty;

  /// No description provided for @flashbackGoodDay.
  ///
  /// In en, this message translates to:
  /// **'A Good Day'**
  String get flashbackGoodDay;

  /// No description provided for @flashbackRandomDay.
  ///
  /// In en, this message translates to:
  /// **'A Random Day'**
  String get flashbackRandomDay;

  /// No description provided for @flashbackWeek.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} Week Ago} other{{count} Weeks Ago}}'**
  String flashbackWeek(num count);

  /// No description provided for @flashbackMonth.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} Month Ago} other{{count} Months Ago}}'**
  String flashbackMonth(num count);

  /// No description provided for @flashbackYear.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} Year Ago} other{{count} Years Ago}}'**
  String flashbackYear(num count);

  /// No description provided for @flashbackOnThisDay.
  ///
  /// In en, this message translates to:
  /// **'On This Day'**
  String get flashbackOnThisDay;

  /// No description provided for @pageGalleryTitle.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get pageGalleryTitle;

  /// No description provided for @searchLogsHint.
  ///
  /// In en, this message translates to:
  /// **'Search Logs…'**
  String get searchLogsHint;

  /// No description provided for @logCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} log} other{{count} logs}}'**
  String logCount(num count);

  /// No description provided for @dayCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} day} other{{count} days}}'**
  String dayCount(num count);

  /// No description provided for @wordCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} word} other{{count} words}}'**
  String wordCount(num count);

  /// No description provided for @noLogs.
  ///
  /// In en, this message translates to:
  /// **'No Logs…'**
  String get noLogs;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No Results…'**
  String get noResults;

  /// No description provided for @sortDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get sortDateTitle;

  /// No description provided for @sortOrderAscendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get sortOrderAscendingTitle;

  /// No description provided for @sortOrderDescendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get sortOrderDescendingTitle;

  /// No description provided for @pageStatisticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get pageStatisticsTitle;

  /// No description provided for @statisticsNotEnoughData.
  ///
  /// In en, this message translates to:
  /// **'Not enough data…'**
  String get statisticsNotEnoughData;

  /// No description provided for @statisticsRangeOneMonth.
  ///
  /// In en, this message translates to:
  /// **'1 Month'**
  String get statisticsRangeOneMonth;

  /// No description provided for @statisticsRangeSixMonths.
  ///
  /// In en, this message translates to:
  /// **'6 Months'**
  String get statisticsRangeSixMonths;

  /// No description provided for @statisticsRangeOneYear.
  ///
  /// In en, this message translates to:
  /// **'1 Year'**
  String get statisticsRangeOneYear;

  /// No description provided for @statisticsRangeAllTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get statisticsRangeAllTime;

  /// No description provided for @chartSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'{tag} Summary'**
  String chartSummaryTitle(Object tag);

  /// No description provided for @chartByDayTitle.
  ///
  /// In en, this message translates to:
  /// **'{tag} By Day'**
  String chartByDayTitle(Object tag);

  /// No description provided for @chartOverTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'{tag} Over Time'**
  String chartOverTimeTitle(Object tag);

  /// No description provided for @chartGroupingLabel.
  ///
  /// In en, this message translates to:
  /// **'Group by'**
  String get chartGroupingLabel;

  /// No description provided for @chartGroupingDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get chartGroupingDay;

  /// No description provided for @chartGroupingWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get chartGroupingWeek;

  /// No description provided for @chartGroupingMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get chartGroupingMonth;

  /// No description provided for @chartGroupingYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get chartGroupingYear;

  /// No description provided for @chartSmoothingLabel.
  ///
  /// In en, this message translates to:
  /// **'Smoothing'**
  String get chartSmoothingLabel;

  /// No description provided for @streakCurrent.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{Current Streak {count}}}'**
  String streakCurrent(num count);

  /// No description provided for @streakLongest.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{Longest Streak {count}}}'**
  String streakLongest(num count);

  /// No description provided for @streakGreatDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{Great Days {count}}}'**
  String streakGreatDays(num count);

  /// No description provided for @streakSinceBadDay.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{Days Since a Bad Day {count}}}'**
  String streakSinceBadDay(num count);

  /// No description provided for @errorExternalStorageAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Can\'t Access External Storage'**
  String get errorExternalStorageAccessTitle;

  /// No description provided for @errorExternalStorageAccessDescription.
  ///
  /// In en, this message translates to:
  /// **'If you are using network storage make sure the service is online and you have network access.\n\nOtherwise, the app may have lost permissions for the external folder. Go to settings, and reselect the external folder to grant access.\n\nWarning, changes will not be synced until you restore access to the external storage location!'**
  String get errorExternalStorageAccessDescription;

  /// No description provided for @errorExternalStorageAccessContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue With Local Database'**
  String get errorExternalStorageAccessContinue;

  /// No description provided for @databaseMigrationErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t Move Your Data'**
  String get databaseMigrationErrorTitle;

  /// No description provided for @databaseMigrationErrorDescription.
  ///
  /// In en, this message translates to:
  /// **'Your entries are safe but couldn\'t be moved to the app\'s storage.\n\nTry again, and report the issue if it keeps happening.'**
  String get databaseMigrationErrorDescription;

  /// No description provided for @databaseMigrationErrorRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get databaseMigrationErrorRetry;

  /// No description provided for @errorReport.
  ///
  /// In en, this message translates to:
  /// **'Report Issue'**
  String get errorReport;

  /// No description provided for @lastModified.
  ///
  /// In en, this message translates to:
  /// **'Modified'**
  String get lastModified;

  /// No description provided for @writeSomethingHint.
  ///
  /// In en, this message translates to:
  /// **'Write something…'**
  String get writeSomethingHint;

  /// No description provided for @titleHint.
  ///
  /// In en, this message translates to:
  /// **'Title…'**
  String get titleHint;

  /// No description provided for @deleteLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Log'**
  String get deleteLogTitle;

  /// No description provided for @deleteLogDescription.
  ///
  /// In en, this message translates to:
  /// **'The entry moves to Recently deleted, where you can restore it.'**
  String get deleteLogDescription;

  /// No description provided for @deletePhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete attachment'**
  String get deletePhotoTitle;

  /// No description provided for @deletePhotoDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this attachment?'**
  String get deletePhotoDescription;

  /// No description provided for @pageSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get pageSettingsTitle;

  /// No description provided for @settingsAppearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceTitle;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeAmoled.
  ///
  /// In en, this message translates to:
  /// **'AMOLED'**
  String get themeAmoled;

  /// No description provided for @settingsFirstDayOfWeek.
  ///
  /// In en, this message translates to:
  /// **'First Day Of Week'**
  String get settingsFirstDayOfWeek;

  /// No description provided for @settingsCalendarSystem.
  ///
  /// In en, this message translates to:
  /// **'Calendar System'**
  String get settingsCalendarSystem;

  /// No description provided for @calendarSystemGregorian.
  ///
  /// In en, this message translates to:
  /// **'Gregorian'**
  String get calendarSystemGregorian;

  /// No description provided for @calendarSystemJalali.
  ///
  /// In en, this message translates to:
  /// **'Jalali'**
  String get calendarSystemJalali;

  /// No description provided for @settingsUseSystemAccentColor.
  ///
  /// In en, this message translates to:
  /// **'Use System Accent Color'**
  String get settingsUseSystemAccentColor;

  /// No description provided for @settingsCustomAccentColor.
  ///
  /// In en, this message translates to:
  /// **'Custom Accent Color'**
  String get settingsCustomAccentColor;

  /// No description provided for @settingsShowMarkdownToolbar.
  ///
  /// In en, this message translates to:
  /// **'Show Markdown Toolbar'**
  String get settingsShowMarkdownToolbar;

  /// No description provided for @settingsShowFlashbacks.
  ///
  /// In en, this message translates to:
  /// **'Show Flashbacks'**
  String get settingsShowFlashbacks;

  /// No description provided for @settingsChangeMoodIcons.
  ///
  /// In en, this message translates to:
  /// **'Change Mood Icons'**
  String get settingsChangeMoodIcons;

  /// No description provided for @moodIconPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter an icon'**
  String get moodIconPrompt;

  /// No description provided for @settingsFlashbacksViewLayout.
  ///
  /// In en, this message translates to:
  /// **'Flashbacks View Layout'**
  String get settingsFlashbacksViewLayout;

  /// No description provided for @settingsHideImagesInGallery.
  ///
  /// In en, this message translates to:
  /// **'Hide Images In Gallery'**
  String get settingsHideImagesInGallery;

  /// No description provided for @settingsHideImages.
  ///
  /// In en, this message translates to:
  /// **'Hide Images'**
  String get settingsHideImages;

  /// No description provided for @pageCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get pageCalendarTitle;

  /// No description provided for @settingsNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotificationsTitle;

  /// No description provided for @settingsDailyReminderOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Enable daily reminders to keep yourself consistent!'**
  String get settingsDailyReminderOnboarding;

  /// No description provided for @settingsNotificationsPermissionsPrompt.
  ///
  /// In en, this message translates to:
  /// **'The \'schedule alarms\' permission will be requested to send the reminder at a random moment or at your preferred time.'**
  String get settingsNotificationsPermissionsPrompt;

  /// No description provided for @settingsDailyReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder'**
  String get settingsDailyReminderTitle;

  /// No description provided for @settingsOnThisDayDescription.
  ///
  /// In en, this message translates to:
  /// **'Revisit past memories'**
  String get settingsOnThisDayDescription;

  /// No description provided for @settingsDailyReminderDescription.
  ///
  /// In en, this message translates to:
  /// **'A gentle reminder each day'**
  String get settingsDailyReminderDescription;

  /// No description provided for @settingsReminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder Time'**
  String get settingsReminderTime;

  /// No description provided for @settingsFixedReminderTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Fixed Reminder Time'**
  String get settingsFixedReminderTimeTitle;

  /// No description provided for @settingsFixedReminderTimeDescription.
  ///
  /// In en, this message translates to:
  /// **'Pick a fixed time for the reminder'**
  String get settingsFixedReminderTimeDescription;

  /// No description provided for @settingsAlwaysSendReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Always Send Reminder'**
  String get settingsAlwaysSendReminderTitle;

  /// No description provided for @settingsAlwaysSendReminderDescription.
  ///
  /// In en, this message translates to:
  /// **'Send reminder even if a log was already started'**
  String get settingsAlwaysSendReminderDescription;

  /// No description provided for @settingsCustomizeNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Customize Notifications'**
  String get settingsCustomizeNotificationTitle;

  /// No description provided for @settingsTemplatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get settingsTemplatesTitle;

  /// No description provided for @settingsDefaultTemplate.
  ///
  /// In en, this message translates to:
  /// **'Default Template'**
  String get settingsDefaultTemplate;

  /// No description provided for @manageTemplates.
  ///
  /// In en, this message translates to:
  /// **'Manage Templates'**
  String get manageTemplates;

  /// No description provided for @addTemplate.
  ///
  /// In en, this message translates to:
  /// **'Add a Template'**
  String get addTemplate;

  /// No description provided for @newTemplate.
  ///
  /// In en, this message translates to:
  /// **'New Template'**
  String get newTemplate;

  /// No description provided for @noTemplateTitle.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noTemplateTitle;

  /// No description provided for @noTemplatesDescription.
  ///
  /// In en, this message translates to:
  /// **'No templates created yet…'**
  String get noTemplatesDescription;

  /// No description provided for @templateVariableTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get templateVariableTime;

  /// No description provided for @templateDefaultTimestampTitle.
  ///
  /// In en, this message translates to:
  /// **'Timestamp'**
  String get templateDefaultTimestampTitle;

  /// No description provided for @templateDefaultTimestampBody.
  ///
  /// In en, this message translates to:
  /// **'{date} - {time}:'**
  String templateDefaultTimestampBody(Object date, Object time);

  /// No description provided for @templateDefaultSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Day Summary'**
  String get templateDefaultSummaryTitle;

  /// No description provided for @templateDefaultSummaryBody.
  ///
  /// In en, this message translates to:
  /// **'### Summary\n- \n\n### Quote\n> '**
  String get templateDefaultSummaryBody;

  /// No description provided for @templateDefaultReflectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Reflection'**
  String get templateDefaultReflectionTitle;

  /// No description provided for @templateDefaultReflectionBody.
  ///
  /// In en, this message translates to:
  /// **'### What did you enjoy about today?\n- \n\n### What are you thankful for?\n- \n\n### What are you looking forward to?\n- '**
  String get templateDefaultReflectionBody;

  /// No description provided for @settingsTagsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get settingsTagsTitle;

  /// No description provided for @manageTags.
  ///
  /// In en, this message translates to:
  /// **'Manage Tags'**
  String get manageTags;

  /// No description provided for @tagTypeLabelTitle.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get tagTypeLabelTitle;

  /// No description provided for @tagTypeTrackerTitle.
  ///
  /// In en, this message translates to:
  /// **'Tracker'**
  String get tagTypeTrackerTitle;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameHint;

  /// No description provided for @tagColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get tagColorLabel;

  /// No description provided for @iconPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Icon'**
  String get iconPickerTitle;

  /// No description provided for @iconPickerIconsTab.
  ///
  /// In en, this message translates to:
  /// **'Icons'**
  String get iconPickerIconsTab;

  /// No description provided for @iconPickerCustomTab.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get iconPickerCustomTab;

  /// No description provided for @iconPickerSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search icons…'**
  String get iconPickerSearchHint;

  /// No description provided for @colorPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Color'**
  String get colorPickerTitle;

  /// No description provided for @colorPickerPaletteTab.
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get colorPickerPaletteTab;

  /// No description provided for @iconGroupMoodPeople.
  ///
  /// In en, this message translates to:
  /// **'Mood & People'**
  String get iconGroupMoodPeople;

  /// No description provided for @iconGroupHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get iconGroupHealth;

  /// No description provided for @iconGroupWorkFinance.
  ///
  /// In en, this message translates to:
  /// **'Work & Finance'**
  String get iconGroupWorkFinance;

  /// No description provided for @iconGroupHabitsGoals.
  ///
  /// In en, this message translates to:
  /// **'Habits & Goals'**
  String get iconGroupHabitsGoals;

  /// No description provided for @iconGroupNature.
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get iconGroupNature;

  /// No description provided for @iconGroupFoodDrink.
  ///
  /// In en, this message translates to:
  /// **'Food & Drink'**
  String get iconGroupFoodDrink;

  /// No description provided for @iconGroupHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get iconGroupHome;

  /// No description provided for @iconGroupTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get iconGroupTravel;

  /// No description provided for @iconGroupSymbols.
  ///
  /// In en, this message translates to:
  /// **'Symbols'**
  String get iconGroupSymbols;

  /// No description provided for @tagCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get tagCategoryLabel;

  /// No description provided for @tagLabel.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get tagLabel;

  /// No description provided for @tagCategoryUncategorized.
  ///
  /// In en, this message translates to:
  /// **'Uncategorized'**
  String get tagCategoryUncategorized;

  /// No description provided for @newCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'New Category'**
  String get newCategoryTitle;

  /// No description provided for @shareButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareButtonLabel;

  /// No description provided for @importErrorDescription.
  ///
  /// In en, this message translates to:
  /// **'Failed to import file!'**
  String get importErrorDescription;

  /// No description provided for @exportErrorDescription.
  ///
  /// In en, this message translates to:
  /// **'Failed to export file!'**
  String get exportErrorDescription;

  /// No description provided for @deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteTitle;

  /// No description provided for @deleteTagMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?{count, plural, =0{} =1{ It is used in 1 log.} other{ It is used in {count} logs.}}'**
  String deleteTagMessage(num count, Object name);

  /// No description provided for @deleteCategoryMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?{count, plural, =0{} =1{ Its 1 tag will also be deleted.} other{ Its {count} tags will also be deleted.}}'**
  String deleteCategoryMessage(num count, Object name);

  /// No description provided for @deleteTemplateMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String deleteTemplateMessage(Object name);

  /// No description provided for @addTagsTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Tags'**
  String get addTagsTitle;

  /// No description provided for @addTagsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search tags…'**
  String get addTagsSearchHint;

  /// No description provided for @tagPickerSortManualLabel.
  ///
  /// In en, this message translates to:
  /// **'Manual order'**
  String get tagPickerSortManualLabel;

  /// No description provided for @tagPickerSortUsageLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort by usage'**
  String get tagPickerSortUsageLabel;

  /// No description provided for @tagFavoriteName.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get tagFavoriteName;

  /// No description provided for @tagEnergyName.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get tagEnergyName;

  /// No description provided for @tagCategoryActivitiesName.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get tagCategoryActivitiesName;

  /// No description provided for @tagExerciseName.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get tagExerciseName;

  /// No description provided for @tagSocializingName.
  ///
  /// In en, this message translates to:
  /// **'Socializing'**
  String get tagSocializingName;

  /// No description provided for @tagHobbyName.
  ///
  /// In en, this message translates to:
  /// **'Hobby'**
  String get tagHobbyName;

  /// No description provided for @tagEntertainmentName.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get tagEntertainmentName;

  /// No description provided for @tagDiningName.
  ///
  /// In en, this message translates to:
  /// **'Dining'**
  String get tagDiningName;

  /// No description provided for @tagChoresName.
  ///
  /// In en, this message translates to:
  /// **'Chores'**
  String get tagChoresName;

  /// No description provided for @tagCategoryEmotionsName.
  ///
  /// In en, this message translates to:
  /// **'Emotions'**
  String get tagCategoryEmotionsName;

  /// No description provided for @tagExcitedName.
  ///
  /// In en, this message translates to:
  /// **'Excited'**
  String get tagExcitedName;

  /// No description provided for @tagGratefulName.
  ///
  /// In en, this message translates to:
  /// **'Grateful'**
  String get tagGratefulName;

  /// No description provided for @tagCalmName.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get tagCalmName;

  /// No description provided for @tagTiredName.
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get tagTiredName;

  /// No description provided for @tagAnxiousName.
  ///
  /// In en, this message translates to:
  /// **'Anxious'**
  String get tagAnxiousName;

  /// No description provided for @tagAnnoyedName.
  ///
  /// In en, this message translates to:
  /// **'Annoyed'**
  String get tagAnnoyedName;

  /// No description provided for @welcomeLogBodyText.
  ///
  /// In en, this message translates to:
  /// **'## Welcome to AID Diary\n\n> Every day is worth remembering.\n\nWrite what happened, how you felt, and where you were. Your entries stay on this device.\n\n- **Journal** lists every entry by day\n- **Calendar**, **Media** and **Atlas** look back by date, photo and place\n- **Coach** offers prompts and templates when you don\'t know what to write\n\nAID Diary is a modified version of [Daily You](https://github.com/Demizo/Daily_You) by Demizo and contributors, and not the official Daily You app.'**
  String get welcomeLogBodyText;

  /// No description provided for @settingsStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get settingsStorageTitle;

  /// No description provided for @settingsImageQuality.
  ///
  /// In en, this message translates to:
  /// **'Image Quality'**
  String get settingsImageQuality;

  /// No description provided for @imageQualityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get imageQualityHigh;

  /// No description provided for @imageQualityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get imageQualityMedium;

  /// No description provided for @imageQualityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get imageQualityLow;

  /// No description provided for @imageQualityNoCompression.
  ///
  /// In en, this message translates to:
  /// **'No Compression'**
  String get imageQualityNoCompression;

  /// No description provided for @settingsLogFolder.
  ///
  /// In en, this message translates to:
  /// **'Log Folder'**
  String get settingsLogFolder;

  /// No description provided for @settingsImageFolder.
  ///
  /// In en, this message translates to:
  /// **'Image Folder'**
  String get settingsImageFolder;

  /// No description provided for @warningTitle.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warningTitle;

  /// No description provided for @logFolderWarningDescription.
  ///
  /// In en, this message translates to:
  /// **'If the selected folder already contains a \'daily_you.db\' file, it will be used to overwrite your existing logs!'**
  String get logFolderWarningDescription;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @logFolderErrorDescription.
  ///
  /// In en, this message translates to:
  /// **'Failed to change log folder!'**
  String get logFolderErrorDescription;

  /// No description provided for @imageFolderErrorDescription.
  ///
  /// In en, this message translates to:
  /// **'Failed to change image folder!'**
  String get imageFolderErrorDescription;

  /// No description provided for @backupErrorDescription.
  ///
  /// In en, this message translates to:
  /// **'Failed to create backup!'**
  String get backupErrorDescription;

  /// No description provided for @restoreErrorDescription.
  ///
  /// In en, this message translates to:
  /// **'Failed to restore backup!'**
  String get restoreErrorDescription;

  /// No description provided for @settingsBackupRestoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get settingsBackupRestoreTitle;

  /// No description provided for @settingsBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get settingsBackup;

  /// No description provided for @settingsRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get settingsRestore;

  /// No description provided for @settingsRestorePromptDescription.
  ///
  /// In en, this message translates to:
  /// **'Restoring a backup will overwrite your existing data!'**
  String get settingsRestorePromptDescription;

  /// No description provided for @settingsBackupPasswordProtect.
  ///
  /// In en, this message translates to:
  /// **'Password Protect Backups'**
  String get settingsBackupPasswordProtect;

  /// No description provided for @backupEncryptedTitle.
  ///
  /// In en, this message translates to:
  /// **'Encrypted Backup'**
  String get backupEncryptedTitle;

  /// No description provided for @backupEncryptedContent.
  ///
  /// In en, this message translates to:
  /// **'This backup is password protected.'**
  String get backupEncryptedContent;

  /// No description provided for @settingsAutoBackup.
  ///
  /// In en, this message translates to:
  /// **'Automatic Backups'**
  String get settingsAutoBackup;

  /// No description provided for @settingsAutoBackupLocation.
  ///
  /// In en, this message translates to:
  /// **'Backup Location'**
  String get settingsAutoBackupLocation;

  /// No description provided for @settingsAutoBackupInterval.
  ///
  /// In en, this message translates to:
  /// **'Backup Interval'**
  String get settingsAutoBackupInterval;

  /// No description provided for @settingsAutoBackupIntervalDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get settingsAutoBackupIntervalDaily;

  /// No description provided for @settingsAutoBackupIntervalWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get settingsAutoBackupIntervalWeekly;

  /// No description provided for @settingsAutoBackupIntervalMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get settingsAutoBackupIntervalMonthly;

  /// No description provided for @settingsAutoBackupMaxCount.
  ///
  /// In en, this message translates to:
  /// **'Backups To Keep'**
  String get settingsAutoBackupMaxCount;

  /// No description provided for @settingsAutoBackupRequireCharging.
  ///
  /// In en, this message translates to:
  /// **'Only While Charging'**
  String get settingsAutoBackupRequireCharging;

  /// No description provided for @settingsBackupLast.
  ///
  /// In en, this message translates to:
  /// **'Last backup {time}'**
  String settingsBackupLast(Object time);

  /// No description provided for @settingsBackupNever.
  ///
  /// In en, this message translates to:
  /// **'Never backed up'**
  String get settingsBackupNever;

  /// No description provided for @settingsAutoBackupNext.
  ///
  /// In en, this message translates to:
  /// **'Next backup {time}'**
  String settingsAutoBackupNext(Object time);

  /// No description provided for @settingsAutoBackupKeepAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get settingsAutoBackupKeepAll;

  /// No description provided for @autoBackupFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup Failed'**
  String get autoBackupFailedTitle;

  /// No description provided for @tranferStatus.
  ///
  /// In en, this message translates to:
  /// **'Transferring… {percent}%'**
  String tranferStatus(Object percent);

  /// No description provided for @creatingBackupStatus.
  ///
  /// In en, this message translates to:
  /// **'Creating Backup… {percent}%'**
  String creatingBackupStatus(Object percent);

  /// No description provided for @restoringBackupStatus.
  ///
  /// In en, this message translates to:
  /// **'Restoring Backup… {percent}%'**
  String restoringBackupStatus(Object percent);

  /// No description provided for @encryptingBackupStatus.
  ///
  /// In en, this message translates to:
  /// **'Encrypting Backup… {percent}%'**
  String encryptingBackupStatus(Object percent);

  /// No description provided for @decryptingBackupStatus.
  ///
  /// In en, this message translates to:
  /// **'Decrypting Backup… {percent}%'**
  String decryptingBackupStatus(Object percent);

  /// No description provided for @cleanUpStatus.
  ///
  /// In en, this message translates to:
  /// **'Cleaning Up…'**
  String get cleanUpStatus;

  /// No description provided for @migratingImagesStatus.
  ///
  /// In en, this message translates to:
  /// **'Migrating photos… {current}/{total}'**
  String migratingImagesStatus(Object current, Object total);

  /// No description provided for @settingsExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get settingsExport;

  /// No description provided for @settingsExportToAnotherFormat.
  ///
  /// In en, this message translates to:
  /// **'Export To Another Format'**
  String get settingsExportToAnotherFormat;

  /// No description provided for @settingsExportFormatDescription.
  ///
  /// In en, this message translates to:
  /// **'This should not be used as a backup!'**
  String get settingsExportFormatDescription;

  /// No description provided for @exportLogs.
  ///
  /// In en, this message translates to:
  /// **'Export Logs'**
  String get exportLogs;

  /// No description provided for @exportImages.
  ///
  /// In en, this message translates to:
  /// **'Export Images'**
  String get exportImages;

  /// No description provided for @settingsImport.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get settingsImport;

  /// No description provided for @settingsImportFromAnotherApp.
  ///
  /// In en, this message translates to:
  /// **'Import From Another App'**
  String get settingsImportFromAnotherApp;

  /// No description provided for @settingsTranslateCallToAction.
  ///
  /// In en, this message translates to:
  /// **'Everyone should have access to a journal!'**
  String get settingsTranslateCallToAction;

  /// No description provided for @settingsHelpTranslate.
  ///
  /// In en, this message translates to:
  /// **'Help Translate'**
  String get settingsHelpTranslate;

  /// No description provided for @importLogs.
  ///
  /// In en, this message translates to:
  /// **'Import Logs'**
  String get importLogs;

  /// No description provided for @importImages.
  ///
  /// In en, this message translates to:
  /// **'Import Images'**
  String get importImages;

  /// No description provided for @logFormatTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Format'**
  String get logFormatTitle;

  /// No description provided for @logFormatDescription.
  ///
  /// In en, this message translates to:
  /// **'Another app\'s format may not support all features. Please report any issues since third party formats may change at any time. This will not impact existing logs!'**
  String get logFormatDescription;

  /// No description provided for @formatDailyYouJson.
  ///
  /// In en, this message translates to:
  /// **'Daily You (JSON)'**
  String get formatDailyYouJson;

  /// No description provided for @formatDaybook.
  ///
  /// In en, this message translates to:
  /// **'Daybook'**
  String get formatDaybook;

  /// No description provided for @formatDaylio.
  ///
  /// In en, this message translates to:
  /// **'Daylio'**
  String get formatDaylio;

  /// No description provided for @formatDiarium.
  ///
  /// In en, this message translates to:
  /// **'Diarium'**
  String get formatDiarium;

  /// No description provided for @formatDiaro.
  ///
  /// In en, this message translates to:
  /// **'Diaro'**
  String get formatDiaro;

  /// No description provided for @formatMyBrain.
  ///
  /// In en, this message translates to:
  /// **'My Brain'**
  String get formatMyBrain;

  /// No description provided for @formatOneShot.
  ///
  /// In en, this message translates to:
  /// **'OneShot'**
  String get formatOneShot;

  /// No description provided for @formatPixels.
  ///
  /// In en, this message translates to:
  /// **'Pixels'**
  String get formatPixels;

  /// No description provided for @formatMarkdown.
  ///
  /// In en, this message translates to:
  /// **'Markdown'**
  String get formatMarkdown;

  /// No description provided for @settingsDeleteAllLogsTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete All Logs'**
  String get settingsDeleteAllLogsTitle;

  /// No description provided for @settingsDeleteAllLogsDescription.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete all of your logs?'**
  String get settingsDeleteAllLogsDescription;

  /// No description provided for @settingsDeleteAllLogsPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter \'{prompt}\' to confirm. This cannot be undone!'**
  String settingsDeleteAllLogsPrompt(Object prompt);

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsAppLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get settingsAppLanguageTitle;

  /// No description provided for @settingsOverrideAppLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Override App Language'**
  String get settingsOverrideAppLanguageTitle;

  /// No description provided for @settingsSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecurityTitle;

  /// No description provided for @settingsSecurityRequirePassword.
  ///
  /// In en, this message translates to:
  /// **'Require Password'**
  String get settingsSecurityRequirePassword;

  /// No description provided for @settingsSecurityEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get settingsSecurityEnterPassword;

  /// No description provided for @settingsSecuritySetPassword.
  ///
  /// In en, this message translates to:
  /// **'Set Password'**
  String get settingsSecuritySetPassword;

  /// No description provided for @settingsSecurityChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get settingsSecurityChangePassword;

  /// No description provided for @settingsSecurityPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get settingsSecurityPassword;

  /// No description provided for @settingsSecurityConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get settingsSecurityConfirmPassword;

  /// No description provided for @settingsSecurityOldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get settingsSecurityOldPassword;

  /// No description provided for @settingsSecurityIncorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect Password'**
  String get settingsSecurityIncorrectPassword;

  /// No description provided for @settingsSecurityPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get settingsSecurityPasswordsDoNotMatch;

  /// No description provided for @requiredPrompt.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredPrompt;

  /// No description provided for @settingsSecurityBiometricUnlock.
  ///
  /// In en, this message translates to:
  /// **'Biometric Unlock'**
  String get settingsSecurityBiometricUnlock;

  /// No description provided for @unlockAppPrompt.
  ///
  /// In en, this message translates to:
  /// **'Unlock the app'**
  String get unlockAppPrompt;

  /// No description provided for @settingsAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAboutTitle;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsLicense.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get settingsLicense;

  /// No description provided for @licenseGPLv3.
  ///
  /// In en, this message translates to:
  /// **'GPL-3.0'**
  String get licenseGPLv3;

  /// No description provided for @settingsSourceCode.
  ///
  /// In en, this message translates to:
  /// **'Source Code'**
  String get settingsSourceCode;

  /// No description provided for @settingsOpenSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get settingsOpenSourceLicenses;

  /// No description provided for @settingsMadeWithLove.
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️'**
  String get settingsMadeWithLove;

  /// No description provided for @settingsConsiderSupporting.
  ///
  /// In en, this message translates to:
  /// **'consider supporting'**
  String get settingsConsiderSupporting;

  /// No description provided for @imagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get imagesTitle;

  /// No description provided for @tagMoodTitle.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get tagMoodTitle;

  /// No description provided for @calendarTagDisplayLabel.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get calendarTagDisplayLabel;

  /// No description provided for @selectTagTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Tag'**
  String get selectTagTitle;

  /// No description provided for @labelPresentLabel.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get labelPresentLabel;

  /// No description provided for @labelAbsentLabel.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get labelAbsentLabel;

  /// No description provided for @labelCoverageLabel.
  ///
  /// In en, this message translates to:
  /// **'Coverage'**
  String get labelCoverageLabel;

  /// No description provided for @chartDistributionTitle.
  ///
  /// In en, this message translates to:
  /// **'{tag} Distribution'**
  String chartDistributionTitle(Object tag);

  /// No description provided for @shareAddToLogPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a log'**
  String get shareAddToLogPickerTitle;

  /// No description provided for @adaptiveEmptyDay.
  ///
  /// In en, this message translates to:
  /// **'No entries for this day yet'**
  String get adaptiveEmptyDay;

  /// No description provided for @adaptiveNewEntry.
  ///
  /// In en, this message translates to:
  /// **'Write an entry'**
  String get adaptiveNewEntry;

  /// No description provided for @pageJournalTitle.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get pageJournalTitle;

  /// No description provided for @coachWritePrompt.
  ///
  /// In en, this message translates to:
  /// **'Write about it'**
  String get coachWritePrompt;

  /// No description provided for @coachPrompt1.
  ///
  /// In en, this message translates to:
  /// **'What made you smile today?'**
  String get coachPrompt1;

  /// No description provided for @coachPrompt2.
  ///
  /// In en, this message translates to:
  /// **'What is one thing you learned today?'**
  String get coachPrompt2;

  /// No description provided for @coachPrompt3.
  ///
  /// In en, this message translates to:
  /// **'Who did you talk to today, and how did it feel?'**
  String get coachPrompt3;

  /// No description provided for @coachPrompt4.
  ///
  /// In en, this message translates to:
  /// **'What are you grateful for right now?'**
  String get coachPrompt4;

  /// No description provided for @coachPrompt5.
  ///
  /// In en, this message translates to:
  /// **'What took most of your energy today?'**
  String get coachPrompt5;

  /// No description provided for @coachPrompt6.
  ///
  /// In en, this message translates to:
  /// **'Describe a small moment you want to remember.'**
  String get coachPrompt6;

  /// No description provided for @coachPrompt7.
  ///
  /// In en, this message translates to:
  /// **'What would make tomorrow a good day?'**
  String get coachPrompt7;

  /// No description provided for @coachPrompt8.
  ///
  /// In en, this message translates to:
  /// **'What has been on your mind lately?'**
  String get coachPrompt8;

  /// No description provided for @coachPrompt9.
  ///
  /// In en, this message translates to:
  /// **'What did you do today just for yourself?'**
  String get coachPrompt9;

  /// No description provided for @coachPrompt10.
  ///
  /// In en, this message translates to:
  /// **'If today had a title, what would it be?'**
  String get coachPrompt10;

  /// No description provided for @entryReadingTime.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 min read} other{{count} min read}}'**
  String entryReadingTime(num count);

  /// No description provided for @pageMediaTitle.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get pageMediaTitle;

  /// No description provided for @pageAtlasTitle.
  ///
  /// In en, this message translates to:
  /// **'Atlas'**
  String get pageAtlasTitle;

  /// No description provided for @pageCoachTitle.
  ///
  /// In en, this message translates to:
  /// **'Coach'**
  String get pageCoachTitle;

  /// No description provided for @noEntrySelected.
  ///
  /// In en, this message translates to:
  /// **'No entry selected.'**
  String get noEntrySelected;

  /// No description provided for @profileLocalOnly.
  ///
  /// In en, this message translates to:
  /// **'Your diary stays on this device'**
  String get profileLocalOnly;

  /// No description provided for @entryShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get entryShare;

  /// No description provided for @entryFavorite.
  ///
  /// In en, this message translates to:
  /// **'Star'**
  String get entryFavorite;

  /// No description provided for @entryEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get entryEdit;

  /// No description provided for @entryPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous entry'**
  String get entryPrevious;

  /// No description provided for @entryNext.
  ///
  /// In en, this message translates to:
  /// **'Next entry'**
  String get entryNext;

  /// No description provided for @journalStories.
  ///
  /// In en, this message translates to:
  /// **'Stories'**
  String get journalStories;

  /// No description provided for @journalEntries.
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get journalEntries;

  /// No description provided for @journalEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Begin your diary by adding a new entry.'**
  String get journalEmptyHint;

  /// No description provided for @storyToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get storyToday;

  /// No description provided for @storyThrowback.
  ///
  /// In en, this message translates to:
  /// **'Throwback'**
  String get storyThrowback;

  /// No description provided for @storyNoThrowback.
  ///
  /// In en, this message translates to:
  /// **'No throwback today'**
  String get storyNoThrowback;

  /// No description provided for @mediaFiles.
  ///
  /// In en, this message translates to:
  /// **'Media files'**
  String get mediaFiles;

  /// No description provided for @mediaEmpty.
  ///
  /// In en, this message translates to:
  /// **'No photos yet.'**
  String get mediaEmpty;

  /// No description provided for @mediaEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Photos attached to entries will be shown here.'**
  String get mediaEmptyHint;

  /// No description provided for @atlasEmpty.
  ///
  /// In en, this message translates to:
  /// **'No entries with a location.'**
  String get atlasEmpty;

  /// No description provided for @atlasEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Entries with a location will be shown here.'**
  String get atlasEmptyHint;

  /// No description provided for @atlasShowAll.
  ///
  /// In en, this message translates to:
  /// **'Show all entries'**
  String get atlasShowAll;

  /// No description provided for @coachAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get coachAll;

  /// No description provided for @coachPrograms.
  ///
  /// In en, this message translates to:
  /// **'Programs'**
  String get coachPrograms;

  /// No description provided for @coachTemplates.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get coachTemplates;

  /// No description provided for @coachKindProgram.
  ///
  /// In en, this message translates to:
  /// **'Program'**
  String get coachKindProgram;

  /// No description provided for @coachKindTemplate.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get coachKindTemplate;

  /// No description provided for @coachNoTemplates.
  ///
  /// In en, this message translates to:
  /// **'No programs or templates.'**
  String get coachNoTemplates;

  /// No description provided for @coachUseTemplate.
  ///
  /// In en, this message translates to:
  /// **'Write with this template'**
  String get coachUseTemplate;

  /// No description provided for @coachProgramEverydayTitle.
  ///
  /// In en, this message translates to:
  /// **'Everyday moments'**
  String get coachProgramEverydayTitle;

  /// No description provided for @coachProgramEverydayDescription.
  ///
  /// In en, this message translates to:
  /// **'Short questions that help you notice the small things in a day.'**
  String get coachProgramEverydayDescription;

  /// No description provided for @coachProgramReflectTitle.
  ///
  /// In en, this message translates to:
  /// **'Looking inward'**
  String get coachProgramReflectTitle;

  /// No description provided for @coachProgramReflectDescription.
  ///
  /// In en, this message translates to:
  /// **'Questions for slowing down and understanding how you feel.'**
  String get coachProgramReflectDescription;

  /// No description provided for @searchFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get searchFilters;

  /// No description provided for @searchFilterTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get searchFilterTags;

  /// No description provided for @searchFilterStarred.
  ///
  /// In en, this message translates to:
  /// **'Starred'**
  String get searchFilterStarred;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Type to search, or pick a filter.'**
  String get searchHint;

  /// No description provided for @locationTitle.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationTitle;

  /// No description provided for @locationName.
  ///
  /// In en, this message translates to:
  /// **'Place name'**
  String get locationName;

  /// No description provided for @locationNoCoordinates.
  ///
  /// In en, this message translates to:
  /// **'No coordinates'**
  String get locationNoCoordinates;

  /// No description provided for @locationUseCurrent.
  ///
  /// In en, this message translates to:
  /// **'Use current location'**
  String get locationUseCurrent;

  /// No description provided for @locationRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get locationRemove;

  /// No description provided for @locationServiceDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are turned off.'**
  String get locationServiceDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission was denied.'**
  String get locationPermissionDenied;

  /// No description provided for @locationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not get the current location.'**
  String get locationUnavailable;

  /// No description provided for @calendarJumpToToday.
  ///
  /// In en, this message translates to:
  /// **'Jump to today'**
  String get calendarJumpToToday;

  /// No description provided for @editorStartWriting.
  ///
  /// In en, this message translates to:
  /// **'Start writing or choose a '**
  String get editorStartWriting;

  /// No description provided for @editorTemplateLink.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get editorTemplateLink;

  /// No description provided for @editorStartWritingEnd.
  ///
  /// In en, this message translates to:
  /// **'.'**
  String get editorStartWritingEnd;

  /// No description provided for @templatePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a template'**
  String get templatePickerTitle;

  /// No description provided for @templateFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured templates'**
  String get templateFeatured;

  /// No description provided for @templateMine.
  ///
  /// In en, this message translates to:
  /// **'My templates'**
  String get templateMine;

  /// No description provided for @templateDailyName.
  ///
  /// In en, this message translates to:
  /// **'Daily review'**
  String get templateDailyName;

  /// No description provided for @templateDailyDescription.
  ///
  /// In en, this message translates to:
  /// **'What happened, how it felt, and what comes next.'**
  String get templateDailyDescription;

  /// No description provided for @templateDailyText.
  ///
  /// In en, this message translates to:
  /// **'## What happened today\n\n\n## How I felt\n\n\n## Three things I\'m grateful for\n1. \n2. \n3. \n\n## Tomorrow\n'**
  String get templateDailyText;

  /// No description provided for @templateTravelName.
  ///
  /// In en, this message translates to:
  /// **'Travel log'**
  String get templateTravelName;

  /// No description provided for @templateTravelDescription.
  ///
  /// In en, this message translates to:
  /// **'Places, moments and food from the road.'**
  String get templateTravelDescription;

  /// No description provided for @templateTravelText.
  ///
  /// In en, this message translates to:
  /// **'## Where I went\n\n\n## The moment I remember most\n\n\n## What I ate\n\n\n## Plans for tomorrow\n'**
  String get templateTravelText;

  /// No description provided for @templateReadingName.
  ///
  /// In en, this message translates to:
  /// **'Reading notes'**
  String get templateReadingName;

  /// No description provided for @templateReadingDescription.
  ///
  /// In en, this message translates to:
  /// **'Quotes and thoughts from what you read.'**
  String get templateReadingDescription;

  /// No description provided for @templateReadingText.
  ///
  /// In en, this message translates to:
  /// **'## Book\n\n\n## Where I am\n\n\n## Quotes\n> \n\n## My thoughts\n'**
  String get templateReadingText;

  /// No description provided for @templateWeeklyName.
  ///
  /// In en, this message translates to:
  /// **'Weekly review'**
  String get templateWeeklyName;

  /// No description provided for @templateWeeklyDescription.
  ///
  /// In en, this message translates to:
  /// **'Highlights, struggles and next week\'s focus.'**
  String get templateWeeklyDescription;

  /// No description provided for @templateWeeklyText.
  ///
  /// In en, this message translates to:
  /// **'## Highlights\n\n\n## What was hard\n\n\n## What I learned\n\n\n## Focus for next week\n'**
  String get templateWeeklyText;

  /// No description provided for @entryDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get entryDuplicate;

  /// No description provided for @entryDuplicated.
  ///
  /// In en, this message translates to:
  /// **'Entry duplicated'**
  String get entryDuplicated;

  /// No description provided for @entrySaveAsTemplate.
  ///
  /// In en, this message translates to:
  /// **'Save as template'**
  String get entrySaveAsTemplate;

  /// No description provided for @entrySavedAsTemplate.
  ///
  /// In en, this message translates to:
  /// **'Saved as a template'**
  String get entrySavedAsTemplate;

  /// No description provided for @storyStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get storyStatistics;

  /// No description provided for @storyMoodChart.
  ///
  /// In en, this message translates to:
  /// **'Mood chart'**
  String get storyMoodChart;

  /// No description provided for @storyEntriesAndDays.
  ///
  /// In en, this message translates to:
  /// **'{entries} entries · {days} days'**
  String storyEntriesAndDays(Object days, Object entries);

  /// No description provided for @storyThisYear.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get storyThisYear;

  /// No description provided for @storyLastYear.
  ///
  /// In en, this message translates to:
  /// **'Last year'**
  String get storyLastYear;

  /// No description provided for @storyTapToOpen.
  ///
  /// In en, this message translates to:
  /// **'Tap a day to open it'**
  String get storyTapToOpen;

  /// No description provided for @settingsGeneralTitle.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneralTitle;

  /// No description provided for @settingsDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Data & storage'**
  String get settingsDataTitle;

  /// No description provided for @settingsStoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Stories'**
  String get settingsStoriesTitle;

  /// No description provided for @settingsHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & about'**
  String get settingsHelpTitle;

  /// No description provided for @weatherTitle.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weatherTitle;

  /// No description provided for @weatherClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get weatherClear;

  /// No description provided for @weatherPartlyCloudy.
  ///
  /// In en, this message translates to:
  /// **'Partly cloudy'**
  String get weatherPartlyCloudy;

  /// No description provided for @weatherCloudy.
  ///
  /// In en, this message translates to:
  /// **'Cloudy'**
  String get weatherCloudy;

  /// No description provided for @weatherFog.
  ///
  /// In en, this message translates to:
  /// **'Fog'**
  String get weatherFog;

  /// No description provided for @weatherDrizzle.
  ///
  /// In en, this message translates to:
  /// **'Drizzle'**
  String get weatherDrizzle;

  /// No description provided for @weatherRain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get weatherRain;

  /// No description provided for @weatherSnow.
  ///
  /// In en, this message translates to:
  /// **'Snow'**
  String get weatherSnow;

  /// No description provided for @weatherStorm.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorm'**
  String get weatherStorm;

  /// No description provided for @weatherFetch.
  ///
  /// In en, this message translates to:
  /// **'Get weather for this entry'**
  String get weatherFetch;

  /// No description provided for @weatherNeedsLocation.
  ///
  /// In en, this message translates to:
  /// **'Add a location with coordinates first.'**
  String get weatherNeedsLocation;

  /// No description provided for @weatherUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Weather is unavailable for this place and time.'**
  String get weatherUnavailable;

  /// No description provided for @weatherRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove weather'**
  String get weatherRemove;

  /// No description provided for @activityTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activityTitle;

  /// No description provided for @activityStill.
  ///
  /// In en, this message translates to:
  /// **'Still'**
  String get activityStill;

  /// No description provided for @activityWalking.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get activityWalking;

  /// No description provided for @activityRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get activityRunning;

  /// No description provided for @activityCycling.
  ///
  /// In en, this message translates to:
  /// **'Cycling'**
  String get activityCycling;

  /// No description provided for @activityVehicle.
  ///
  /// In en, this message translates to:
  /// **'In a vehicle'**
  String get activityVehicle;

  /// No description provided for @activityFlying.
  ///
  /// In en, this message translates to:
  /// **'Flying'**
  String get activityFlying;

  /// No description provided for @activityExercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get activityExercise;

  /// No description provided for @activityDetect.
  ///
  /// In en, this message translates to:
  /// **'Detect current activity'**
  String get activityDetect;

  /// No description provided for @activityDetectFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t detect an activity.'**
  String get activityDetectFailed;

  /// No description provided for @activityRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove activity'**
  String get activityRemove;

  /// No description provided for @settingsAutoAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add automatically'**
  String get settingsAutoAddTitle;

  /// No description provided for @settingsAutoAddLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get settingsAutoAddLocation;

  /// No description provided for @settingsAutoAddWeather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get settingsAutoAddWeather;

  /// No description provided for @settingsAutoAddActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get settingsAutoAddActivity;

  /// No description provided for @settingsAutoAddHint.
  ///
  /// In en, this message translates to:
  /// **'New entries get these filled in when they are created.'**
  String get settingsAutoAddHint;

  /// No description provided for @settingsTemperatureUnit.
  ///
  /// In en, this message translates to:
  /// **'Temperature unit'**
  String get settingsTemperatureUnit;

  /// No description provided for @settingsCelsius.
  ///
  /// In en, this message translates to:
  /// **'Celsius (°C)'**
  String get settingsCelsius;

  /// No description provided for @settingsFahrenheit.
  ///
  /// In en, this message translates to:
  /// **'Fahrenheit (°F)'**
  String get settingsFahrenheit;

  /// No description provided for @moodGreat.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get moodGreat;

  /// No description provided for @moodGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get moodGood;

  /// No description provided for @moodOkay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get moodOkay;

  /// No description provided for @moodBad.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get moodBad;

  /// No description provided for @moodAwful.
  ///
  /// In en, this message translates to:
  /// **'Awful'**
  String get moodAwful;

  /// No description provided for @locationSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a place'**
  String get locationSearchHint;

  /// No description provided for @locationSearchEmpty.
  ///
  /// In en, this message translates to:
  /// **'No places found'**
  String get locationSearchEmpty;

  /// No description provided for @settingsWallpaper.
  ///
  /// In en, this message translates to:
  /// **'Wallpaper'**
  String get settingsWallpaper;

  /// No description provided for @wallpaperNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get wallpaperNone;

  /// No description provided for @wallpaperDots.
  ///
  /// In en, this message translates to:
  /// **'Dots'**
  String get wallpaperDots;

  /// No description provided for @wallpaperGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get wallpaperGrid;

  /// No description provided for @wallpaperLines.
  ///
  /// In en, this message translates to:
  /// **'Lines'**
  String get wallpaperLines;

  /// No description provided for @wallpaperPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo…'**
  String get wallpaperPhoto;

  /// No description provided for @settingsFontFamily.
  ///
  /// In en, this message translates to:
  /// **'Font'**
  String get settingsFontFamily;

  /// No description provided for @fontSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get fontSystem;

  /// No description provided for @fontSerif.
  ///
  /// In en, this message translates to:
  /// **'Serif'**
  String get fontSerif;

  /// No description provided for @fontMono.
  ///
  /// In en, this message translates to:
  /// **'Monospace'**
  String get fontMono;

  /// No description provided for @settingsFontSize.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get settingsFontSize;

  /// No description provided for @fontSizeSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get fontSizeSmall;

  /// No description provided for @fontSizeMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get fontSizeMedium;

  /// No description provided for @fontSizeLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get fontSizeLarge;

  /// No description provided for @fontSizeExtraLarge.
  ///
  /// In en, this message translates to:
  /// **'Extra large'**
  String get fontSizeExtraLarge;

  /// No description provided for @settingsLineSpacing.
  ///
  /// In en, this message translates to:
  /// **'Line spacing'**
  String get settingsLineSpacing;

  /// No description provided for @lineSpacingCompact.
  ///
  /// In en, this message translates to:
  /// **'Compact'**
  String get lineSpacingCompact;

  /// No description provided for @lineSpacingNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get lineSpacingNormal;

  /// No description provided for @lineSpacingRelaxed.
  ///
  /// In en, this message translates to:
  /// **'Relaxed'**
  String get lineSpacingRelaxed;

  /// No description provided for @moodAssociationsTitle.
  ///
  /// In en, this message translates to:
  /// **'What makes me feel…'**
  String get moodAssociationsTitle;

  /// No description provided for @moodAssociationsCount.
  ///
  /// In en, this message translates to:
  /// **'{matching} of {total} entries'**
  String moodAssociationsCount(int matching, int total);

  /// No description provided for @videoRecord.
  ///
  /// In en, this message translates to:
  /// **'Record a video'**
  String get videoRecord;

  /// No description provided for @videoChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose a video'**
  String get videoChoose;

  /// No description provided for @audioRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Record a voice note'**
  String get audioRecordTitle;

  /// No description provided for @audioChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose an audio file'**
  String get audioChoose;

  /// No description provided for @audioStart.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get audioStart;

  /// No description provided for @audioStop.
  ///
  /// In en, this message translates to:
  /// **'Stop and save'**
  String get audioStop;

  /// No description provided for @audioPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Microphone access is off. Allow it in the system settings.'**
  String get audioPermissionDenied;

  /// No description provided for @mediaTooLarge.
  ///
  /// In en, this message translates to:
  /// **'This video is too large to attach.'**
  String get mediaTooLarge;

  /// No description provided for @mediaUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This attachment is not available on this device.'**
  String get mediaUnavailable;

  /// No description provided for @widgetDone.
  ///
  /// In en, this message translates to:
  /// **'Today\'s entry is written'**
  String get widgetDone;

  /// No description provided for @widgetPending.
  ///
  /// In en, this message translates to:
  /// **'How was your day?'**
  String get widgetPending;

  /// No description provided for @widgetWrite.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get widgetWrite;

  /// No description provided for @insertChecklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get insertChecklist;

  /// No description provided for @insertNumberedList.
  ///
  /// In en, this message translates to:
  /// **'Numbered list'**
  String get insertNumberedList;

  /// No description provided for @insertTable.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get insertTable;

  /// No description provided for @insertDivider.
  ///
  /// In en, this message translates to:
  /// **'Divider'**
  String get insertDivider;

  /// No description provided for @insertCodeBlock.
  ///
  /// In en, this message translates to:
  /// **'Code block'**
  String get insertCodeBlock;

  /// No description provided for @journalSortTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort entries'**
  String get journalSortTitle;

  /// No description provided for @journalSortUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get journalSortUpdated;

  /// No description provided for @settingsTimeFormat.
  ///
  /// In en, this message translates to:
  /// **'Time format'**
  String get settingsTimeFormat;

  /// No description provided for @timeFormat12.
  ///
  /// In en, this message translates to:
  /// **'12-hour'**
  String get timeFormat12;

  /// No description provided for @timeFormat24.
  ///
  /// In en, this message translates to:
  /// **'24-hour'**
  String get timeFormat24;

  /// No description provided for @settingsReminderDays.
  ///
  /// In en, this message translates to:
  /// **'Remind me on'**
  String get settingsReminderDays;

  /// No description provided for @locationRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent places'**
  String get locationRecent;

  /// No description provided for @shareImage.
  ///
  /// In en, this message translates to:
  /// **'Share image'**
  String get shareImage;

  /// No description provided for @shareSaveImage.
  ///
  /// In en, this message translates to:
  /// **'Save image'**
  String get shareSaveImage;

  /// No description provided for @shareAsText.
  ///
  /// In en, this message translates to:
  /// **'Share as text'**
  String get shareAsText;

  /// No description provided for @shareSaved.
  ///
  /// In en, this message translates to:
  /// **'Image saved'**
  String get shareSaved;

  /// No description provided for @deletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Recently deleted'**
  String get deletedTitle;

  /// No description provided for @deletedNone.
  ///
  /// In en, this message translates to:
  /// **'Nothing deleted recently'**
  String get deletedNone;

  /// No description provided for @deletedHint.
  ///
  /// In en, this message translates to:
  /// **'Deleted entries stay here for {days} days, then are erased.'**
  String deletedHint(int days);

  /// No description provided for @deletedDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days} days left'**
  String deletedDaysLeft(int days);

  /// No description provided for @deletedRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get deletedRestore;

  /// No description provided for @deletedDeleteForever.
  ///
  /// In en, this message translates to:
  /// **'Delete forever'**
  String get deletedDeleteForever;

  /// No description provided for @deletedDeleteForeverDescription.
  ///
  /// In en, this message translates to:
  /// **'The entry and its attachments are erased. This cannot be undone.'**
  String get deletedDeleteForeverDescription;

  /// No description provided for @deletedEmpty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get deletedEmpty;

  /// No description provided for @deletedEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Erase every entry in Recently deleted? This cannot be undone.'**
  String get deletedEmptyDescription;

  /// No description provided for @formatJson.
  ///
  /// In en, this message translates to:
  /// **'JSON'**
  String get formatJson;

  /// No description provided for @randomTitle.
  ///
  /// In en, this message translates to:
  /// **'Random walk'**
  String get randomTitle;

  /// No description provided for @randomSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open a past entry'**
  String get randomSubtitle;

  /// No description provided for @randomNext.
  ///
  /// In en, this message translates to:
  /// **'Another'**
  String get randomNext;

  /// No description provided for @randomAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get randomAll;

  /// No description provided for @randomWithPhotos.
  ///
  /// In en, this message translates to:
  /// **'With photos'**
  String get randomWithPhotos;

  /// No description provided for @randomGoodDays.
  ///
  /// In en, this message translates to:
  /// **'Good days'**
  String get randomGoodDays;

  /// No description provided for @randomEmpty.
  ///
  /// In en, this message translates to:
  /// **'No entries to pick from'**
  String get randomEmpty;

  /// No description provided for @reviewWeekTitle.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get reviewWeekTitle;

  /// No description provided for @reviewWeekSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your week so far'**
  String get reviewWeekSubtitle;

  /// No description provided for @reviewYearTitle.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get reviewYearTitle;

  /// No description provided for @reviewEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing written yet'**
  String get reviewEmpty;

  /// No description provided for @reviewEntries.
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get reviewEntries;

  /// No description provided for @reviewDaysWritten.
  ///
  /// In en, this message translates to:
  /// **'Days written'**
  String get reviewDaysWritten;

  /// No description provided for @reviewWords.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get reviewWords;

  /// No description provided for @reviewPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get reviewPhotos;

  /// No description provided for @reviewLongestRun.
  ///
  /// In en, this message translates to:
  /// **'Longest run of days'**
  String get reviewLongestRun;

  /// No description provided for @reviewAverageMood.
  ///
  /// In en, this message translates to:
  /// **'Average mood'**
  String get reviewAverageMood;

  /// No description provided for @reviewFavorites.
  ///
  /// In en, this message translates to:
  /// **'Most often'**
  String get reviewFavorites;

  /// No description provided for @reviewByMonth.
  ///
  /// In en, this message translates to:
  /// **'By month'**
  String get reviewByMonth;

  /// No description provided for @reviewHighlight.
  ///
  /// In en, this message translates to:
  /// **'Highlight'**
  String get reviewHighlight;

  /// No description provided for @yearInPixels.
  ///
  /// In en, this message translates to:
  /// **'Year in pixels'**
  String get yearInPixels;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'be',
        'bg',
        'ca',
        'cs',
        'da',
        'de',
        'en',
        'es',
        'fa',
        'fi',
        'fr',
        'he',
        'hi',
        'id',
        'it',
        'ja',
        'ko',
        'lt',
        'ms',
        'nb',
        'nl',
        'oc',
        'pl',
        'pt',
        'ro',
        'ru',
        'sv',
        'ta',
        'tr',
        'uk',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'be':
      return AppLocalizationsBe();
    case 'bg':
      return AppLocalizationsBg();
    case 'ca':
      return AppLocalizationsCa();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fa':
      return AppLocalizationsFa();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'lt':
      return AppLocalizationsLt();
    case 'ms':
      return AppLocalizationsMs();
    case 'nb':
      return AppLocalizationsNb();
    case 'nl':
      return AppLocalizationsNl();
    case 'oc':
      return AppLocalizationsOc();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sv':
      return AppLocalizationsSv();
    case 'ta':
      return AppLocalizationsTa();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
