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
  /// **'Choose a color for this palette.'**
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

  /// No description provided for @manageTemplates.
  ///
  /// In en, this message translates to:
  /// **'Manage Templates'**
  String get manageTemplates;

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

  /// No description provided for @tagNameExists.
  ///
  /// In en, this message translates to:
  /// **'There is a tag with this name already'**
  String get tagNameExists;

  /// No description provided for @categoryNameExists.
  ///
  /// In en, this message translates to:
  /// **'There is a category with this name already'**
  String get categoryNameExists;

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

  /// No description provided for @tagsRecent.
  ///
  /// In en, this message translates to:
  /// **'Used lately'**
  String get tagsRecent;

  /// No description provided for @tagNew.
  ///
  /// In en, this message translates to:
  /// **'New tag'**
  String get tagNew;

  /// No description provided for @tagFavoriteName.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get tagFavoriteName;

  /// No description provided for @iconGroupActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get iconGroupActivities;

  /// No description provided for @iconGroupHobbies.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get iconGroupHobbies;

  /// No description provided for @settingsStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get settingsStorageTitle;

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
  /// **'If the selected folder already contains a \'aid_diary.db\' file, it will be used to overwrite your existing logs!'**
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

  /// No description provided for @settingsImportFromAnotherApp.
  ///
  /// In en, this message translates to:
  /// **'Import From Another App'**
  String get settingsImportFromAnotherApp;

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

  /// No description provided for @formatDayOne.
  ///
  /// In en, this message translates to:
  /// **'Day One'**
  String get formatDayOne;

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

  /// No description provided for @formatJourney.
  ///
  /// In en, this message translates to:
  /// **'Journey'**
  String get formatJourney;

  /// No description provided for @formatMyBrain.
  ///
  /// In en, this message translates to:
  /// **'My Brain'**
  String get formatMyBrain;

  /// No description provided for @formatOneDiary.
  ///
  /// In en, this message translates to:
  /// **'One Diary'**
  String get formatOneDiary;

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

  /// No description provided for @settingsAppLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get settingsAppLanguageTitle;

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

  /// No description provided for @settingsOpenSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get settingsOpenSourceLicenses;

  /// No description provided for @tagMoodTitle.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get tagMoodTitle;

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

  /// No description provided for @atlasMyLocation.
  ///
  /// In en, this message translates to:
  /// **'My location'**
  String get atlasMyLocation;

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
  /// **'Five short questions, one a day. Each takes a minute or two and helps you see what made the day yours. A gentle way to build the habit of writing a little every day.'**
  String get coachProgramEverydayDescription;

  /// No description provided for @coachProgramReflectTitle.
  ///
  /// In en, this message translates to:
  /// **'Looking inward'**
  String get coachProgramReflectTitle;

  /// No description provided for @coachProgramReflectDescription.
  ///
  /// In en, this message translates to:
  /// **'One deeper question a week, for five weeks. Take your time with each: how you have been feeling, what wears you out, what you are grateful for.'**
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

  /// No description provided for @weatherTemperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get weatherTemperature;

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

  /// No description provided for @settingsDayStart.
  ///
  /// In en, this message translates to:
  /// **'New entries count for the day before until'**
  String get settingsDayStart;

  /// No description provided for @settingsDayAskUntil.
  ///
  /// In en, this message translates to:
  /// **'Then ask which day until'**
  String get settingsDayAskUntil;

  /// No description provided for @settingsDayStartMidnight.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get settingsDayStartMidnight;

  /// No description provided for @settingsDayStartAt.
  ///
  /// In en, this message translates to:
  /// **'{hour}:00'**
  String settingsDayStartAt(int hour);

  /// No description provided for @settingsDayStartHint.
  ///
  /// In en, this message translates to:
  /// **'Every entry keeps the day it belongs to next to the time it was written, and you can change that day in the editor at any time. These hours only pick the day for new entries, so changing them moves no existing entry.'**
  String get settingsDayStartHint;

  /// No description provided for @lateNightBadge.
  ///
  /// In en, this message translates to:
  /// **'Written late at night, counted for the day before'**
  String get lateNightBadge;

  /// No description provided for @editorDayAsk.
  ///
  /// In en, this message translates to:
  /// **'Written at {time}. Which day is it for?'**
  String editorDayAsk(String time);

  /// No description provided for @editorDayYesterday.
  ///
  /// In en, this message translates to:
  /// **'{date} (yesterday)'**
  String editorDayYesterday(String date);

  /// No description provided for @editorDayToday.
  ///
  /// In en, this message translates to:
  /// **'{date} (today)'**
  String editorDayToday(String date);

  /// No description provided for @editorWrittenAt.
  ///
  /// In en, this message translates to:
  /// **'Written {when}'**
  String editorWrittenAt(String when);

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

  /// No description provided for @capsuleSeal.
  ///
  /// In en, this message translates to:
  /// **'Seal as a time capsule'**
  String get capsuleSeal;

  /// No description provided for @capsuleTitle.
  ///
  /// In en, this message translates to:
  /// **'Time capsule'**
  String get capsuleTitle;

  /// No description provided for @capsuleOpensOn.
  ///
  /// In en, this message translates to:
  /// **'Opens on {date}'**
  String capsuleOpensOn(Object date);

  /// No description provided for @capsuleWrittenOn.
  ///
  /// In en, this message translates to:
  /// **'Written on {date}'**
  String capsuleWrittenOn(Object date);

  /// No description provided for @capsuleOpenEarly.
  ///
  /// In en, this message translates to:
  /// **'Open early'**
  String get capsuleOpenEarly;

  /// No description provided for @capsuleOpenEarlyDescription.
  ///
  /// In en, this message translates to:
  /// **'The capsule opens now and stays open.'**
  String get capsuleOpenEarlyDescription;

  /// No description provided for @capsuleOpened.
  ///
  /// In en, this message translates to:
  /// **'Time capsule opened'**
  String get capsuleOpened;

  /// No description provided for @templateMorningName.
  ///
  /// In en, this message translates to:
  /// **'Morning pages'**
  String get templateMorningName;

  /// No description provided for @templateMorningDescription.
  ///
  /// In en, this message translates to:
  /// **'Set up the day in three minutes'**
  String get templateMorningDescription;

  /// No description provided for @templateMorningText.
  ///
  /// In en, this message translates to:
  /// **'## Three things I want to do well today\n1. \n2. \n3. \n\n## Something I look forward to\n\n## A note to myself\n'**
  String get templateMorningText;

  /// No description provided for @templateEveningName.
  ///
  /// In en, this message translates to:
  /// **'Evening review'**
  String get templateEveningName;

  /// No description provided for @templateEveningDescription.
  ///
  /// In en, this message translates to:
  /// **'Close the day with what went well'**
  String get templateEveningDescription;

  /// No description provided for @templateEveningText.
  ///
  /// In en, this message translates to:
  /// **'## Three good things today\n1. \n2. \n3. \n\n## What I learned\n\n## What could go better tomorrow\n'**
  String get templateEveningText;

  /// No description provided for @routineMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get routineMorning;

  /// No description provided for @routineEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening review'**
  String get routineEvening;

  /// No description provided for @settingsRoutinePrompts.
  ///
  /// In en, this message translates to:
  /// **'Morning and evening prompts'**
  String get settingsRoutinePrompts;

  /// No description provided for @settingsRoutinePromptsHint.
  ///
  /// In en, this message translates to:
  /// **'Suggest the morning or evening template in Stories'**
  String get settingsRoutinePromptsHint;

  /// No description provided for @checkInTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick check-in'**
  String get checkInTitle;

  /// No description provided for @checkInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mood in two taps'**
  String get checkInSubtitle;

  /// No description provided for @checkInMood.
  ///
  /// In en, this message translates to:
  /// **'How do you feel?'**
  String get checkInMood;

  /// No description provided for @checkInActivity.
  ///
  /// In en, this message translates to:
  /// **'What are you doing?'**
  String get checkInActivity;

  /// No description provided for @checkInNote.
  ///
  /// In en, this message translates to:
  /// **'A line about it (optional)'**
  String get checkInNote;

  /// No description provided for @checkInSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get checkInSave;

  /// No description provided for @editorWordCount.
  ///
  /// In en, this message translates to:
  /// **'{words} words · {characters} characters'**
  String editorWordCount(int words, int characters);

  /// No description provided for @coachProgramEverydayTagline.
  ///
  /// In en, this message translates to:
  /// **'Notice the small things in a day.'**
  String get coachProgramEverydayTagline;

  /// No description provided for @coachProgramReflectTagline.
  ///
  /// In en, this message translates to:
  /// **'Slow down and listen to yourself.'**
  String get coachProgramReflectTagline;

  /// No description provided for @coachDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get coachDuration;

  /// No description provided for @coachInterval.
  ///
  /// In en, this message translates to:
  /// **'Interval'**
  String get coachInterval;

  /// No description provided for @coachDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get coachDifficulty;

  /// No description provided for @coachIntervalDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get coachIntervalDaily;

  /// No description provided for @coachIntervalWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get coachIntervalWeekly;

  /// No description provided for @coachDifficultyBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get coachDifficultyBeginner;

  /// No description provided for @coachDifficultyIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get coachDifficultyIntermediate;

  /// No description provided for @coachDurationDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String coachDurationDays(int count);

  /// No description provided for @coachDurationWeeks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 week} other{{count} weeks}}'**
  String coachDurationWeeks(int count);

  /// No description provided for @coachDayN.
  ///
  /// In en, this message translates to:
  /// **'Day {n}'**
  String coachDayN(int n);

  /// No description provided for @coachWeekN.
  ///
  /// In en, this message translates to:
  /// **'Week {n}'**
  String coachWeekN(int n);

  /// No description provided for @coachEnroll.
  ///
  /// In en, this message translates to:
  /// **'Enroll'**
  String get coachEnroll;

  /// No description provided for @coachEndProgram.
  ///
  /// In en, this message translates to:
  /// **'End program'**
  String get coachEndProgram;

  /// No description provided for @coachAuthor.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get coachAuthor;

  /// No description provided for @coachAuthorBio.
  ///
  /// In en, this message translates to:
  /// **'Prompts written for this app.'**
  String get coachAuthorBio;

  /// No description provided for @coachEnrolledTip.
  ///
  /// In en, this message translates to:
  /// **'All set! Your questions will show up in Stories.'**
  String get coachEnrolledTip;

  /// No description provided for @coachGoToStories.
  ///
  /// In en, this message translates to:
  /// **'Go to Stories'**
  String get coachGoToStories;

  /// No description provided for @coachAnswerHint.
  ///
  /// In en, this message translates to:
  /// **'Write your answer…'**
  String get coachAnswerHint;

  /// No description provided for @storyWrapUp.
  ///
  /// In en, this message translates to:
  /// **'That\'s all for today.'**
  String get storyWrapUp;

  /// No description provided for @storyTapToClose.
  ///
  /// In en, this message translates to:
  /// **'Tap to close'**
  String get storyTapToClose;

  /// No description provided for @coachAnswerDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get coachAnswerDone;

  /// No description provided for @coachAnswered.
  ///
  /// In en, this message translates to:
  /// **'Answered, tap to open'**
  String get coachAnswered;

  /// No description provided for @coachAnsweredEarlier.
  ///
  /// In en, this message translates to:
  /// **'Answered'**
  String get coachAnsweredEarlier;

  /// No description provided for @locationLocating.
  ///
  /// In en, this message translates to:
  /// **'Locating…'**
  String get locationLocating;

  /// No description provided for @locationPickPlace.
  ///
  /// In en, this message translates to:
  /// **'Pick a place'**
  String get locationPickPlace;

  /// No description provided for @locationPlacesHint.
  ///
  /// In en, this message translates to:
  /// **'Address or name of the place'**
  String get locationPlacesHint;

  /// No description provided for @locationCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom place'**
  String get locationCustom;

  /// No description provided for @locationCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current location'**
  String get locationCurrent;

  /// No description provided for @locationSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved places'**
  String get locationSaved;

  /// No description provided for @locationSearchResults.
  ///
  /// In en, this message translates to:
  /// **'Search results'**
  String get locationSearchResults;

  /// No description provided for @locationNearby.
  ///
  /// In en, this message translates to:
  /// **'Nearby places'**
  String get locationNearby;

  /// No description provided for @locationRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get locationRename;

  /// No description provided for @locationSavePlace.
  ///
  /// In en, this message translates to:
  /// **'Save place'**
  String get locationSavePlace;

  /// No description provided for @locationUnsavePlace.
  ///
  /// In en, this message translates to:
  /// **'Remove from saved places'**
  String get locationUnsavePlace;

  /// No description provided for @shareAs.
  ///
  /// In en, this message translates to:
  /// **'Share as…'**
  String get shareAs;

  /// No description provided for @shareAsImage.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get shareAsImage;

  /// No description provided for @shareAsZip.
  ///
  /// In en, this message translates to:
  /// **'ZIP with the original media'**
  String get shareAsZip;

  /// No description provided for @shareAsPlainText.
  ///
  /// In en, this message translates to:
  /// **'Plain text'**
  String get shareAsPlainText;

  /// No description provided for @shareAsHtml.
  ///
  /// In en, this message translates to:
  /// **'HTML'**
  String get shareAsHtml;

  /// No description provided for @onboardWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to AID Diary'**
  String get onboardWelcomeTitle;

  /// No description provided for @onboardWelcomeText.
  ///
  /// In en, this message translates to:
  /// **'Start here, or connect this device to one you already use.'**
  String get onboardWelcomeText;

  /// No description provided for @onboardStart.
  ///
  /// In en, this message translates to:
  /// **'Start writing'**
  String get onboardStart;

  /// No description provided for @helpFaq.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get helpFaq;

  /// No description provided for @helpFaq1Q.
  ///
  /// In en, this message translates to:
  /// **'Where is my diary stored?'**
  String get helpFaq1Q;

  /// No description provided for @helpFaq1A.
  ///
  /// In en, this message translates to:
  /// **'Your diary is stored on this device. It reaches other devices or storage only when you enable sync, share or export it. Sync is end-to-end encrypted.'**
  String get helpFaq1A;

  /// No description provided for @helpFaq2Q.
  ///
  /// In en, this message translates to:
  /// **'How do I keep a copy or move to a new device?'**
  String get helpFaq2Q;

  /// No description provided for @helpFaq2A.
  ///
  /// In en, this message translates to:
  /// **'Connect to an existing device in Settings → Data & storage → Sync and confirm authorization on the device that has your diary. Both devices remain usable. You can also create a backup and restore it on another device.'**
  String get helpFaq2A;

  /// No description provided for @helpFaq3Q.
  ///
  /// In en, this message translates to:
  /// **'Can I bring in entries from other diary apps?'**
  String get helpFaq3Q;

  /// No description provided for @helpFaq3A.
  ///
  /// In en, this message translates to:
  /// **'Yes: in Settings → Data & storage, import exports from Daylio, Diarium, Diaro, DayBook, My Brain, OneShot and Pixels, or a JSON export.'**
  String get helpFaq3A;

  /// No description provided for @helpFaq4Q.
  ///
  /// In en, this message translates to:
  /// **'How do coach programs work?'**
  String get helpFaq4Q;

  /// No description provided for @helpFaq4A.
  ///
  /// In en, this message translates to:
  /// **'Enroll in a program on the Coach page. Each day or week a new question waits in Stories; your answer is saved as an entry.'**
  String get helpFaq4A;

  /// No description provided for @helpFaq5Q.
  ///
  /// In en, this message translates to:
  /// **'What if I forget my passcode?'**
  String get helpFaq5Q;

  /// No description provided for @helpFaq5A.
  ///
  /// In en, this message translates to:
  /// **'The passcode cannot be recovered, so keep a backup of your diary.'**
  String get helpFaq5A;

  /// No description provided for @helpPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get helpPrivacy;

  /// No description provided for @helpPrivacyText.
  ///
  /// In en, this message translates to:
  /// **'Diary content and media stay on this device unless you enable encrypted sync or share/export them. Maps, place lookup and weather use the configured services and send the location or search query needed for that request, not diary text.'**
  String get helpPrivacyText;

  /// No description provided for @photoMetaTitle.
  ///
  /// In en, this message translates to:
  /// **'Use the photo\'s details?'**
  String get photoMetaTitle;

  /// No description provided for @photoMetaDateAndPlace.
  ///
  /// In en, this message translates to:
  /// **'Count this entry for {date} and set its place to {place}, as recorded in the photo?'**
  String photoMetaDateAndPlace(String date, String place);

  /// No description provided for @photoMetaDate.
  ///
  /// In en, this message translates to:
  /// **'Count this entry for {date}, when the photo was taken?'**
  String photoMetaDate(String date);

  /// No description provided for @photoMetaPlace.
  ///
  /// In en, this message translates to:
  /// **'Set this entry\'s place to {place}, where the photo was taken?'**
  String photoMetaPlace(String place);

  /// No description provided for @photoMetaApply.
  ///
  /// In en, this message translates to:
  /// **'Use them'**
  String get photoMetaApply;

  /// No description provided for @quickWriteTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick write'**
  String get quickWriteTitle;

  /// No description provided for @quickWriteText.
  ///
  /// In en, this message translates to:
  /// **'Tap to start a new entry.'**
  String get quickWriteText;

  /// No description provided for @settingsQuickWriteTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick write in notifications'**
  String get settingsQuickWriteTitle;

  /// No description provided for @settingsQuickWriteDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep a notification that opens a new entry.'**
  String get settingsQuickWriteDescription;

  /// No description provided for @settingsNudgesTitle.
  ///
  /// In en, this message translates to:
  /// **'Nudge me after a quiet stretch'**
  String get settingsNudgesTitle;

  /// No description provided for @settingsNudgesDescription.
  ///
  /// In en, this message translates to:
  /// **'A gentle reminder when you haven\'t written for {days} days.'**
  String settingsNudgesDescription(int days);

  /// No description provided for @nudgeTitle.
  ///
  /// In en, this message translates to:
  /// **'It\'s been a while'**
  String get nudgeTitle;

  /// No description provided for @nudgeMonday.
  ///
  /// In en, this message translates to:
  /// **'A new week: what are you looking forward to?'**
  String get nudgeMonday;

  /// No description provided for @nudgeTuesday.
  ///
  /// In en, this message translates to:
  /// **'Two lines are enough. How are you today?'**
  String get nudgeTuesday;

  /// No description provided for @nudgeWednesday.
  ///
  /// In en, this message translates to:
  /// **'Halfway through the week. What stood out so far?'**
  String get nudgeWednesday;

  /// No description provided for @nudgeThursday.
  ///
  /// In en, this message translates to:
  /// **'Anything small worth keeping from today?'**
  String get nudgeThursday;

  /// No description provided for @nudgeFriday.
  ///
  /// In en, this message translates to:
  /// **'The week is wrapping up. Note one good moment.'**
  String get nudgeFriday;

  /// No description provided for @nudgeSaturday.
  ///
  /// In en, this message translates to:
  /// **'A slow Saturday is a good day to write.'**
  String get nudgeSaturday;

  /// No description provided for @nudgeSunday.
  ///
  /// In en, this message translates to:
  /// **'Look back on the week before it ends.'**
  String get nudgeSunday;

  /// No description provided for @photoWidgetEmpty.
  ///
  /// In en, this message translates to:
  /// **'Photos you add to entries show up here.'**
  String get photoWidgetEmpty;

  /// No description provided for @channelReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get channelReminders;

  /// No description provided for @channelOnThisDay.
  ///
  /// In en, this message translates to:
  /// **'On this day'**
  String get channelOnThisDay;

  /// No description provided for @channelCoach.
  ///
  /// In en, this message translates to:
  /// **'Coach prompts'**
  String get channelCoach;

  /// No description provided for @channelNudges.
  ///
  /// In en, this message translates to:
  /// **'Nudges after quiet days'**
  String get channelNudges;

  /// No description provided for @channelQuickWrite.
  ///
  /// In en, this message translates to:
  /// **'Quick write'**
  String get channelQuickWrite;

  /// No description provided for @channelBackup.
  ///
  /// In en, this message translates to:
  /// **'Backups'**
  String get channelBackup;

  /// No description provided for @formatJsonExport.
  ///
  /// In en, this message translates to:
  /// **'JSON (AID Diary export)'**
  String get formatJsonExport;

  /// No description provided for @aboutModifiedNotice.
  ///
  /// In en, this message translates to:
  /// **'A modified version of Daily You by Demizo and contributors. It is not the official Daily You app.'**
  String get aboutModifiedNotice;

  /// No description provided for @toolbarPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add photos'**
  String get toolbarPhotos;

  /// No description provided for @toolbarMedia.
  ///
  /// In en, this message translates to:
  /// **'Photos and videos'**
  String get toolbarMedia;

  /// No description provided for @mediaFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get mediaFromGallery;

  /// No description provided for @mediaFromFiles.
  ///
  /// In en, this message translates to:
  /// **'Choose from files'**
  String get mediaFromFiles;

  /// No description provided for @editorLeaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Save this entry?'**
  String get editorLeaveTitle;

  /// No description provided for @editorLeaveDiscard.
  ///
  /// In en, this message translates to:
  /// **'Don\'t save'**
  String get editorLeaveDiscard;

  /// No description provided for @editorTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get editorTitleHint;

  /// No description provided for @editorLocating.
  ///
  /// In en, this message translates to:
  /// **'Locating…'**
  String get editorLocating;

  /// No description provided for @toolbarVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get toolbarVideo;

  /// No description provided for @toolbarAudio.
  ///
  /// In en, this message translates to:
  /// **'Voice note'**
  String get toolbarAudio;

  /// No description provided for @toolbarTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get toolbarTags;

  /// No description provided for @toolbarBulletList.
  ///
  /// In en, this message translates to:
  /// **'Bulleted list'**
  String get toolbarBulletList;

  /// No description provided for @toolbarHeading.
  ///
  /// In en, this message translates to:
  /// **'Heading'**
  String get toolbarHeading;

  /// No description provided for @toolbarBold.
  ///
  /// In en, this message translates to:
  /// **'Bold'**
  String get toolbarBold;

  /// No description provided for @toolbarItalic.
  ///
  /// In en, this message translates to:
  /// **'Italic'**
  String get toolbarItalic;

  /// No description provided for @toolbarHighlight.
  ///
  /// In en, this message translates to:
  /// **'Highlight'**
  String get toolbarHighlight;

  /// No description provided for @toolbarStrikethrough.
  ///
  /// In en, this message translates to:
  /// **'Strikethrough'**
  String get toolbarStrikethrough;

  /// No description provided for @toolbarQuote.
  ///
  /// In en, this message translates to:
  /// **'Quote'**
  String get toolbarQuote;

  /// No description provided for @toolbarLink.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get toolbarLink;

  /// No description provided for @toolbarInsert.
  ///
  /// In en, this message translates to:
  /// **'Insert'**
  String get toolbarInsert;

  /// No description provided for @toolbarUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get toolbarUndo;

  /// No description provided for @toolbarRedo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get toolbarRedo;

  /// No description provided for @toolbarInsertDate.
  ///
  /// In en, this message translates to:
  /// **'Insert the date'**
  String get toolbarInsertDate;

  /// No description provided for @toolbarInsertTime.
  ///
  /// In en, this message translates to:
  /// **'Insert the time'**
  String get toolbarInsertTime;

  /// No description provided for @settingsSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud Sync'**
  String get settingsSyncTitle;

  /// No description provided for @syncOffDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep this diary the same on all your devices through Google Drive or a WebDAV server, such as Nextcloud, Synology or Jianguoyun.'**
  String get syncOffDescription;

  /// No description provided for @syncUseGoogleDrive.
  ///
  /// In en, this message translates to:
  /// **'Sync with Google Drive'**
  String get syncUseGoogleDrive;

  /// No description provided for @syncOrWebDav.
  ///
  /// In en, this message translates to:
  /// **'Or a WebDAV server'**
  String get syncOrWebDav;

  /// No description provided for @syncGoogleDrive.
  ///
  /// In en, this message translates to:
  /// **'Google Drive'**
  String get syncGoogleDrive;

  /// Shown in the browser tab after signing in to Google on a computer
  ///
  /// In en, this message translates to:
  /// **'Signed in. You can go back to AID Diary.'**
  String get syncGoogleSignedIn;

  /// No description provided for @syncGoogleSignInAgain.
  ///
  /// In en, this message translates to:
  /// **'Google needs you to sign in again.'**
  String get syncGoogleSignInAgain;

  /// No description provided for @syncSignInAgain.
  ///
  /// In en, this message translates to:
  /// **'Sign in again'**
  String get syncSignInAgain;

  /// No description provided for @settingsCommandLineTitle.
  ///
  /// In en, this message translates to:
  /// **'Command line'**
  String get settingsCommandLineTitle;

  /// No description provided for @commandLineToggle.
  ///
  /// In en, this message translates to:
  /// **'Command line interface'**
  String get commandLineToggle;

  /// No description provided for @commandLineToggleHint.
  ///
  /// In en, this message translates to:
  /// **'Lets the aid command and other programs on this device use the app\'s commands.'**
  String get commandLineToggleHint;

  /// No description provided for @commandLineAlwaysOn.
  ///
  /// In en, this message translates to:
  /// **'Always on in development builds.'**
  String get commandLineAlwaysOn;

  /// No description provided for @commandLineListening.
  ///
  /// In en, this message translates to:
  /// **'Listening on port {port}'**
  String commandLineListening(int port);

  /// No description provided for @commandPaletteTitle.
  ///
  /// In en, this message translates to:
  /// **'All commands'**
  String get commandPaletteTitle;

  /// No description provided for @commandPaletteSearch.
  ///
  /// In en, this message translates to:
  /// **'Search commands'**
  String get commandPaletteSearch;

  /// No description provided for @commandPaletteRun.
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get commandPaletteRun;

  /// No description provided for @commandPaletteConfirm.
  ///
  /// In en, this message translates to:
  /// **'This cannot simply be undone. Run it?'**
  String get commandPaletteConfirm;

  /// No description provided for @syncReceiving.
  ///
  /// In en, this message translates to:
  /// **'Receiving {done} of {total}…'**
  String syncReceiving(int done, int total);

  /// No description provided for @syncSending.
  ///
  /// In en, this message translates to:
  /// **'Sending {done} of {total}…'**
  String syncSending(int done, int total);

  /// No description provided for @syncGoogleDriveNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Access to Google Drive was not allowed. Connect again and tick Google Drive on Google\'s page.'**
  String get syncGoogleDriveNotAllowed;

  /// No description provided for @syncEntryUnsynced.
  ///
  /// In en, this message translates to:
  /// **'Not synced: the last sync did not go through'**
  String get syncEntryUnsynced;

  /// No description provided for @syncUseOfficial.
  ///
  /// In en, this message translates to:
  /// **'Use the AID sync server'**
  String get syncUseOfficial;

  /// No description provided for @syncServer.
  ///
  /// In en, this message translates to:
  /// **'Server address'**
  String get syncServer;

  /// No description provided for @syncUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get syncUsername;

  /// No description provided for @syncPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get syncPassword;

  /// No description provided for @syncConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get syncConnect;

  /// No description provided for @syncConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get syncConnecting;

  /// No description provided for @syncSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not sign in. Check the address, the username and the password.'**
  String get syncSignInFailed;

  /// No description provided for @syncConnectFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not connect: {error}'**
  String syncConnectFailed(String error);

  /// No description provided for @syncNewSpaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Start syncing'**
  String get syncNewSpaceTitle;

  /// No description provided for @syncNewSpaceDescription.
  ///
  /// In en, this message translates to:
  /// **'There is no synced diary here yet. This diary will be uploaded, end-to-end encrypted with a key that stays on your devices.'**
  String get syncNewSpaceDescription;

  /// No description provided for @syncJoinTitle.
  ///
  /// In en, this message translates to:
  /// **'Join the synced diary'**
  String get syncJoinTitle;

  /// No description provided for @syncWrongKey.
  ///
  /// In en, this message translates to:
  /// **'This recovery code does not open the synced diary.'**
  String get syncWrongKey;

  /// No description provided for @syncLastSynced.
  ///
  /// In en, this message translates to:
  /// **'Last synced {time}'**
  String syncLastSynced(String time);

  /// No description provided for @syncNever.
  ///
  /// In en, this message translates to:
  /// **'Not synced yet'**
  String get syncNever;

  /// No description provided for @syncSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing…'**
  String get syncSyncing;

  /// No description provided for @syncFailed.
  ///
  /// In en, this message translates to:
  /// **'The last sync failed: {error}'**
  String syncFailed(String error);

  /// No description provided for @syncLocked.
  ///
  /// In en, this message translates to:
  /// **'The synced diary now belongs to other devices, or was started over. Pair with one of them or use the recovery code to keep syncing.'**
  String get syncLocked;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// No description provided for @syncUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get syncUnlock;

  /// No description provided for @syncEncrypted.
  ///
  /// In en, this message translates to:
  /// **'End-to-end encrypted'**
  String get syncEncrypted;

  /// No description provided for @syncDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Stop syncing'**
  String get syncDisconnect;

  /// No description provided for @syncDisconnectDescription.
  ///
  /// In en, this message translates to:
  /// **'This device stops syncing. The diary here and the synced copy stay as they are.'**
  String get syncDisconnectDescription;

  /// No description provided for @syncOwnRecoveryPassword.
  ///
  /// In en, this message translates to:
  /// **'Use my own recovery password'**
  String get syncOwnRecoveryPassword;

  /// No description provided for @syncRecoveryPassword.
  ///
  /// In en, this message translates to:
  /// **'Recovery password'**
  String get syncRecoveryPassword;

  /// No description provided for @syncRecoveryPasswordRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat the recovery password'**
  String get syncRecoveryPasswordRepeat;

  /// No description provided for @syncRecoveryPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least {min} characters'**
  String syncRecoveryPasswordTooShort(int min);

  /// No description provided for @syncRecoveryPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'The passwords differ'**
  String get syncRecoveryPasswordMismatch;

  /// No description provided for @syncRecoveryCode.
  ///
  /// In en, this message translates to:
  /// **'Recovery code'**
  String get syncRecoveryCode;

  /// No description provided for @syncRecoveryCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Save your recovery code'**
  String get syncRecoveryCodeTitle;

  /// No description provided for @syncRecoveryCodeDescription.
  ///
  /// In en, this message translates to:
  /// **'If every device of yours is lost, this code restores your synced diary. Keep it in a password manager or on paper. It is shown only this once.'**
  String get syncRecoveryCodeDescription;

  /// No description provided for @syncRecoveryCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Recovery code copied'**
  String get syncRecoveryCodeCopied;

  /// No description provided for @syncRecoveryCodeSaved.
  ///
  /// In en, this message translates to:
  /// **'I have saved it'**
  String get syncRecoveryCodeSaved;

  /// No description provided for @syncJoinNeedsKey.
  ///
  /// In en, this message translates to:
  /// **'This synced diary belongs to your other devices. Pair with one of them, or use the recovery code. The entries on this device will be added to it.'**
  String get syncJoinNeedsKey;

  /// No description provided for @syncPairDevice.
  ///
  /// In en, this message translates to:
  /// **'Pair with a device'**
  String get syncPairDevice;

  /// No description provided for @syncUseRecoveryCode.
  ///
  /// In en, this message translates to:
  /// **'Use the recovery code'**
  String get syncUseRecoveryCode;

  /// No description provided for @syncAddDevice.
  ///
  /// In en, this message translates to:
  /// **'Add a device'**
  String get syncAddDevice;

  /// No description provided for @syncChangeRecoveryCode.
  ///
  /// In en, this message translates to:
  /// **'Change the recovery code'**
  String get syncChangeRecoveryCode;

  /// No description provided for @syncChangeRecoveryDescription.
  ///
  /// In en, this message translates to:
  /// **'A new code replaces the current one, which stops working. Your data and other devices stay as they are.'**
  String get syncChangeRecoveryDescription;

  /// No description provided for @syncNewRandomCode.
  ///
  /// In en, this message translates to:
  /// **'New random code'**
  String get syncNewRandomCode;

  /// No description provided for @syncRecoveryCodeChanged.
  ///
  /// In en, this message translates to:
  /// **'Recovery code changed'**
  String get syncRecoveryCodeChanged;

  /// No description provided for @syncResetSpace.
  ///
  /// In en, this message translates to:
  /// **'Start the synced diary over'**
  String get syncResetSpace;

  /// No description provided for @syncResetSpaceDescription.
  ///
  /// In en, this message translates to:
  /// **'Only when no device and no recovery code opens it any more: the synced copy is replaced by the diary on this device, under this device\'s keys. Your other devices then pair again.'**
  String get syncResetSpaceDescription;

  /// No description provided for @syncPairTitle.
  ///
  /// In en, this message translates to:
  /// **'Pair devices'**
  String get syncPairTitle;

  /// No description provided for @syncPairShow.
  ///
  /// In en, this message translates to:
  /// **'Show a code'**
  String get syncPairShow;

  /// No description provided for @syncPairEnter.
  ///
  /// In en, this message translates to:
  /// **'Enter a code'**
  String get syncPairEnter;

  /// No description provided for @syncPairShowHint.
  ///
  /// In en, this message translates to:
  /// **'On your other device, open Pair devices, choose Enter a code, and type or scan this.'**
  String get syncPairShowHint;

  /// No description provided for @syncPairEnterHint.
  ///
  /// In en, this message translates to:
  /// **'Type the code your other device shows, or scan it.'**
  String get syncPairEnterHint;

  /// No description provided for @syncPairCode.
  ///
  /// In en, this message translates to:
  /// **'Pairing code'**
  String get syncPairCode;

  /// No description provided for @syncPairScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get syncPairScan;

  /// No description provided for @syncPairStart.
  ///
  /// In en, this message translates to:
  /// **'Pair'**
  String get syncPairStart;

  /// No description provided for @syncPairWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the other device…'**
  String get syncPairWaiting;

  /// No description provided for @syncPairDone.
  ///
  /// In en, this message translates to:
  /// **'Paired with {device}'**
  String syncPairDone(String device);

  /// No description provided for @syncPairWrongCode.
  ///
  /// In en, this message translates to:
  /// **'The code did not match. Show a new code and try again.'**
  String get syncPairWrongCode;

  /// No description provided for @syncPairNoOffer.
  ///
  /// In en, this message translates to:
  /// **'No device shows this code. It may have expired.'**
  String get syncPairNoOffer;

  /// No description provided for @syncPairTimedOut.
  ///
  /// In en, this message translates to:
  /// **'The other device did not answer in time.'**
  String get syncPairTimedOut;

  /// No description provided for @syncPairNeither.
  ///
  /// In en, this message translates to:
  /// **'Neither device is set up with this synced diary yet.'**
  String get syncPairNeither;

  /// No description provided for @syncPairBoth.
  ///
  /// In en, this message translates to:
  /// **'Both devices already open this synced diary.'**
  String get syncPairBoth;

  /// No description provided for @syncPairFailed.
  ///
  /// In en, this message translates to:
  /// **'Pairing failed: {error}'**
  String syncPairFailed(String error);

  /// No description provided for @syncMediaPending.
  ///
  /// In en, this message translates to:
  /// **'Diary synced · some media is still transferring'**
  String get syncMediaPending;

  /// No description provided for @syncWaitingForDevices.
  ///
  /// In en, this message translates to:
  /// **'Diary synced · waiting for another device to transfer media'**
  String get syncWaitingForDevices;

  /// No description provided for @syncCacheNotice.
  ///
  /// In en, this message translates to:
  /// **'Cloud media is temporary. Keep the originals on your devices; syncing is not a backup.'**
  String get syncCacheNotice;

  /// No description provided for @paperTitle.
  ///
  /// In en, this message translates to:
  /// **'Letter paper'**
  String get paperTitle;

  /// No description provided for @paperPlain.
  ///
  /// In en, this message translates to:
  /// **'Plain'**
  String get paperPlain;

  /// No description provided for @paperLined.
  ///
  /// In en, this message translates to:
  /// **'Lined'**
  String get paperLined;

  /// No description provided for @paperGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get paperGrid;

  /// No description provided for @paperTinted.
  ///
  /// In en, this message translates to:
  /// **'Tinted'**
  String get paperTinted;

  /// No description provided for @paperDecorationTitle.
  ///
  /// In en, this message translates to:
  /// **'Decorations'**
  String get paperDecorationTitle;

  /// No description provided for @paperDecorationNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get paperDecorationNone;

  /// No description provided for @paperDecorationBotanical.
  ///
  /// In en, this message translates to:
  /// **'Leaves'**
  String get paperDecorationBotanical;

  /// No description provided for @paperDecorationStars.
  ///
  /// In en, this message translates to:
  /// **'Stars'**
  String get paperDecorationStars;

  /// No description provided for @paperDecorationWashi.
  ///
  /// In en, this message translates to:
  /// **'Washi tape'**
  String get paperDecorationWashi;

  /// No description provided for @themeDarkChoice.
  ///
  /// In en, this message translates to:
  /// **'Dark appearance'**
  String get themeDarkChoice;

  /// No description provided for @themeDarkSame.
  ///
  /// In en, this message translates to:
  /// **'Follow light palette'**
  String get themeDarkSame;

  /// No description provided for @themeDarkCustom.
  ///
  /// In en, this message translates to:
  /// **'Separate palette'**
  String get themeDarkCustom;

  /// No description provided for @themeDarkAccent.
  ///
  /// In en, this message translates to:
  /// **'Dark accent colour'**
  String get themeDarkAccent;

  /// No description provided for @themeColorTeal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get themeColorTeal;

  /// No description provided for @themeColorCyan.
  ///
  /// In en, this message translates to:
  /// **'Cyan'**
  String get themeColorCyan;

  /// No description provided for @themeColorIndigo.
  ///
  /// In en, this message translates to:
  /// **'Indigo'**
  String get themeColorIndigo;

  /// No description provided for @themeColorCoral.
  ///
  /// In en, this message translates to:
  /// **'Coral'**
  String get themeColorCoral;

  /// No description provided for @themeColorOlive.
  ///
  /// In en, this message translates to:
  /// **'Olive'**
  String get themeColorOlive;

  /// No description provided for @themeColorSlate.
  ///
  /// In en, this message translates to:
  /// **'Slate'**
  String get themeColorSlate;

  /// No description provided for @drawingTitle.
  ///
  /// In en, this message translates to:
  /// **'Drawing'**
  String get drawingTitle;

  /// No description provided for @drawingPen.
  ///
  /// In en, this message translates to:
  /// **'Pen'**
  String get drawingPen;

  /// No description provided for @drawingEraser.
  ///
  /// In en, this message translates to:
  /// **'Eraser'**
  String get drawingEraser;

  /// No description provided for @drawingUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get drawingUndo;

  /// No description provided for @drawingClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get drawingClear;

  /// No description provided for @drawingWidth.
  ///
  /// In en, this message translates to:
  /// **'Pen width'**
  String get drawingWidth;

  /// No description provided for @drawingStylusOnly.
  ///
  /// In en, this message translates to:
  /// **'Stylus only'**
  String get drawingStylusOnly;

  /// No description provided for @drawingDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard drawing?'**
  String get drawingDiscardTitle;

  /// No description provided for @drawingDiscardBody.
  ///
  /// In en, this message translates to:
  /// **'This drawing has not been saved.'**
  String get drawingDiscardBody;

  /// No description provided for @drawingSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save the drawing.'**
  String get drawingSaveError;

  /// No description provided for @syncNetworkTitle.
  ///
  /// In en, this message translates to:
  /// **'Network diagnostics'**
  String get syncNetworkTitle;

  /// No description provided for @syncNetworkRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get syncNetworkRefresh;

  /// No description provided for @syncNetworkSelectedRoute.
  ///
  /// In en, this message translates to:
  /// **'Current path'**
  String get syncNetworkSelectedRoute;

  /// No description provided for @syncNetworkAvailableRoutes.
  ///
  /// In en, this message translates to:
  /// **'Available paths'**
  String get syncNetworkAvailableRoutes;

  /// No description provided for @syncNetworkSignaling.
  ///
  /// In en, this message translates to:
  /// **'Device directory connection'**
  String get syncNetworkSignaling;

  /// No description provided for @syncNetworkRelayRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining relay allowance'**
  String get syncNetworkRelayRemaining;

  /// No description provided for @syncNetworkIcePair.
  ///
  /// In en, this message translates to:
  /// **'Direct connection candidates'**
  String get syncNetworkIcePair;

  /// No description provided for @syncNetworkPeerTrusted.
  ///
  /// In en, this message translates to:
  /// **'Authenticated device'**
  String get syncNetworkPeerTrusted;

  /// No description provided for @syncNetworkNoRoute.
  ///
  /// In en, this message translates to:
  /// **'Waiting for a connection'**
  String get syncNetworkNoRoute;

  /// No description provided for @syncNetworkUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics are unavailable'**
  String get syncNetworkUnavailable;

  /// No description provided for @syncMediaCopiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Media delivery and copies'**
  String get syncMediaCopiesTitle;

  /// No description provided for @syncMediaPendingCount.
  ///
  /// In en, this message translates to:
  /// **'Waiting to transfer'**
  String get syncMediaPendingCount;

  /// No description provided for @syncMediaDurableCount.
  ///
  /// In en, this message translates to:
  /// **'Delivered to personal storage'**
  String get syncMediaDurableCount;

  /// No description provided for @syncMediaTemporaryCount.
  ///
  /// In en, this message translates to:
  /// **'Temporary or unconfirmed copies'**
  String get syncMediaTemporaryCount;

  /// No description provided for @syncMediaReceiptExplanation.
  ///
  /// In en, this message translates to:
  /// **'These counts describe completed deliveries, not a fresh audit of surviving backups.'**
  String get syncMediaReceiptExplanation;

  /// No description provided for @syncMediaCacheExplanation.
  ///
  /// In en, this message translates to:
  /// **'Temporary cloud media can expire. Keep your originals or a separate backup.'**
  String get syncMediaCacheExplanation;

  /// No description provided for @momentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo moments'**
  String get momentsTitle;

  /// No description provided for @momentsHint.
  ///
  /// In en, this message translates to:
  /// **'Find groups using local photo times and optional coordinates. Photos are attached only when you choose a card.'**
  String get momentsHint;

  /// No description provided for @momentsScan.
  ///
  /// In en, this message translates to:
  /// **'Find moments'**
  String get momentsScan;

  /// No description provided for @momentsChooseFolder.
  ///
  /// In en, this message translates to:
  /// **'Choose photo folder'**
  String get momentsChooseFolder;

  /// No description provided for @momentsLocation.
  ///
  /// In en, this message translates to:
  /// **'Include photo locations'**
  String get momentsLocation;

  /// No description provided for @momentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No recent photo groups.'**
  String get momentsEmpty;

  /// No description provided for @momentsCreate.
  ///
  /// In en, this message translates to:
  /// **'Write about these photos'**
  String get momentsCreate;

  /// No description provided for @momentsDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get momentsDismiss;

  /// No description provided for @momentsError.
  ///
  /// In en, this message translates to:
  /// **'Could not read local photos.'**
  String get momentsError;

  /// No description provided for @momentsCreated.
  ///
  /// In en, this message translates to:
  /// **'Photo entry created.'**
  String get momentsCreated;

  /// No description provided for @momentsPermission.
  ///
  /// In en, this message translates to:
  /// **'Allow access to photos to find local suggestions.'**
  String get momentsPermission;

  /// No description provided for @momentsScope.
  ///
  /// In en, this message translates to:
  /// **'Recent photos only; at most 500 photos and 20 photos per card.'**
  String get momentsScope;

  /// No description provided for @momentsPhotoCount.
  ///
  /// In en, this message translates to:
  /// **'{count} photos'**
  String momentsPhotoCount(int count);

  /// No description provided for @nearbyTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect devices'**
  String get nearbyTitle;

  /// No description provided for @nearbySend.
  ///
  /// In en, this message translates to:
  /// **'Authorize another device'**
  String get nearbySend;

  /// No description provided for @nearbyReceive.
  ///
  /// In en, this message translates to:
  /// **'Connect to an existing device'**
  String get nearbyReceive;

  /// No description provided for @nearbyInstructions.
  ///
  /// In en, this message translates to:
  /// **'Connect both devices to the same Wi-Fi or to each other’s hotspot. Confirm authorization on the existing device; both devices remain usable. No internet is required.'**
  String get nearbyInstructions;

  /// No description provided for @nearbyCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare this code on both devices before approving.'**
  String get nearbyCompare;

  /// No description provided for @nearbyConfirm.
  ///
  /// In en, this message translates to:
  /// **'The codes match'**
  String get nearbyConfirm;

  /// No description provided for @nearbyScan.
  ///
  /// In en, this message translates to:
  /// **'Scan the other device’s code'**
  String get nearbyScan;

  /// No description provided for @nearbyPaste.
  ///
  /// In en, this message translates to:
  /// **'Paste invitation'**
  String get nearbyPaste;

  /// No description provided for @nearbyWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for approval on the other device'**
  String get nearbyWaiting;

  /// No description provided for @nearbyWorking.
  ///
  /// In en, this message translates to:
  /// **'Authorizing and syncing your diary and attachments…'**
  String get nearbyWorking;

  /// No description provided for @nearbyPending.
  ///
  /// In en, this message translates to:
  /// **'Some attachments still need syncing. Keep the other device online and try again.'**
  String get nearbyPending;

  /// No description provided for @nearbyComplete.
  ///
  /// In en, this message translates to:
  /// **'Device connected; diary and attachments synced'**
  String get nearbyComplete;

  /// No description provided for @nearbyFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection did not finish. Check the local connection and try again.'**
  String get nearbyFailed;

  /// No description provided for @nearbyEmptyRequired.
  ///
  /// In en, this message translates to:
  /// **'Use a device with an empty diary that is not connected to sync yet.'**
  String get nearbyEmptyRequired;

  /// No description provided for @nearbyRetry.
  ///
  /// In en, this message translates to:
  /// **'Continue syncing'**
  String get nearbyRetry;

  /// No description provided for @nearbyWifi.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi settings'**
  String get nearbyWifi;

  /// No description provided for @nearbyHotspot.
  ///
  /// In en, this message translates to:
  /// **'Hotspot settings'**
  String get nearbyHotspot;

  /// No description provided for @nearbyKeepOpen.
  ///
  /// In en, this message translates to:
  /// **'Keep this page open until the new device finishes. The invitation expires after two minutes.'**
  String get nearbyKeepOpen;

  /// No description provided for @syncDevicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Authorized devices'**
  String get syncDevicesTitle;

  /// No description provided for @syncDevicesDescription.
  ///
  /// In en, this message translates to:
  /// **'Only approved devices can access this AID account. Revoking a device blocks the server but cannot erase a master key or diary already copied to it.'**
  String get syncDevicesDescription;

  /// No description provided for @syncDeviceRequest.
  ///
  /// In en, this message translates to:
  /// **'Show this authorization QR to an approved device'**
  String get syncDeviceRequest;

  /// No description provided for @syncDeviceAuthorize.
  ///
  /// In en, this message translates to:
  /// **'Authorize a device'**
  String get syncDeviceAuthorize;

  /// No description provided for @syncDeviceAuthorizeDescription.
  ///
  /// In en, this message translates to:
  /// **'Scan or paste the new device’s authorization request.'**
  String get syncDeviceAuthorizeDescription;

  /// No description provided for @syncDeviceRevoke.
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get syncDeviceRevoke;

  /// No description provided for @syncDeviceRotate.
  ///
  /// In en, this message translates to:
  /// **'Rotate this device’s signing key'**
  String get syncDeviceRotate;

  /// No description provided for @syncDeviceCheck.
  ///
  /// In en, this message translates to:
  /// **'Check authorization'**
  String get syncDeviceCheck;

  /// No description provided for @syncDeviceHardware.
  ///
  /// In en, this message translates to:
  /// **'Hardware-backed signing key'**
  String get syncDeviceHardware;

  /// No description provided for @syncDeviceSoftware.
  ///
  /// In en, this message translates to:
  /// **'Non-exportable software signing key'**
  String get syncDeviceSoftware;

  /// No description provided for @syncDeviceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Device authorization is unavailable. Approve this device from another authorized device and retry.'**
  String get syncDeviceUnavailable;

  /// No description provided for @syncDeviceRevoked.
  ///
  /// In en, this message translates to:
  /// **'Revoked'**
  String get syncDeviceRevoked;

  /// No description provided for @syncDeviceLocal.
  ///
  /// In en, this message translates to:
  /// **'This device'**
  String get syncDeviceLocal;

  /// No description provided for @cloudTrafficTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly cloud media allowance'**
  String get cloudTrafficTitle;

  /// No description provided for @cloudTrafficLimit.
  ///
  /// In en, this message translates to:
  /// **'Monthly allowance'**
  String get cloudTrafficLimit;

  /// No description provided for @cloudTrafficUsed.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get cloudTrafficUsed;

  /// No description provided for @cloudTrafficRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get cloudTrafficRemaining;

  /// No description provided for @cloudTrafficResetsAt.
  ///
  /// In en, this message translates to:
  /// **'Resets {time}'**
  String cloudTrafficResetsAt(String time);

  /// No description provided for @cloudTrafficExhausted.
  ///
  /// In en, this message translates to:
  /// **'Cloud media allowance used up. Missing media will resume automatically over a direct connection or when the allowance resets.'**
  String get cloudTrafficExhausted;

  /// No description provided for @cloudTrafficExplanation.
  ///
  /// In en, this message translates to:
  /// **'Media cache and live relay share this allowance. Direct connections do not use it. Diary text and connection control have separate small daily limits.'**
  String get cloudTrafficExplanation;

  /// No description provided for @appearanceThemeSection.
  ///
  /// In en, this message translates to:
  /// **'App theme'**
  String get appearanceThemeSection;

  /// No description provided for @appearancePaperSection.
  ///
  /// In en, this message translates to:
  /// **'Diary paper'**
  String get appearancePaperSection;

  /// No description provided for @appearanceTypographySection.
  ///
  /// In en, this message translates to:
  /// **'Diary text'**
  String get appearanceTypographySection;

  /// No description provided for @appearancePreferencesSection.
  ///
  /// In en, this message translates to:
  /// **'General preferences'**
  String get appearancePreferencesSection;

  /// No description provided for @themeSystemAccentHint.
  ///
  /// In en, this message translates to:
  /// **'Uses the system palette instead of custom colors. Turn it off to choose your own.'**
  String get themeSystemAccentHint;

  /// No description provided for @syncDeviceNameSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the device name. Please try again.'**
  String get syncDeviceNameSaveFailed;

  /// No description provided for @nearbyConnectionHelp.
  ///
  /// In en, this message translates to:
  /// **'Connection help'**
  String get nearbyConnectionHelp;

  /// No description provided for @syncAllSynced.
  ///
  /// In en, this message translates to:
  /// **'Everything synced'**
  String get syncAllSynced;

  /// No description provided for @syncDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync details'**
  String get syncDetailsTitle;

  /// No description provided for @syncMore.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get syncMore;

  /// No description provided for @syncDeviceName.
  ///
  /// In en, this message translates to:
  /// **'Device name'**
  String get syncDeviceName;

  /// No description provided for @syncDeviceNameHint.
  ///
  /// In en, this message translates to:
  /// **'For example: My tablet'**
  String get syncDeviceNameHint;

  /// No description provided for @syncDeviceNameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Use 1 to 32 characters'**
  String get syncDeviceNameInvalid;

  /// No description provided for @syncDeviceKeyDetails.
  ///
  /// In en, this message translates to:
  /// **'Security details'**
  String get syncDeviceKeyDetails;

  /// No description provided for @syncConnectionProblem.
  ///
  /// In en, this message translates to:
  /// **'Unable to sync for now. Retrying automatically.'**
  String get syncConnectionProblem;

  /// No description provided for @syncCopyComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete copy'**
  String get syncCopyComplete;

  /// No description provided for @syncCopyPartial.
  ///
  /// In en, this message translates to:
  /// **'Some media is still missing'**
  String get syncCopyPartial;

  /// No description provided for @syncCopyOlder.
  ///
  /// In en, this message translates to:
  /// **'New changes are waiting to sync'**
  String get syncCopyOlder;

  /// No description provided for @syncCopyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Copy details are unavailable. Try again later.'**
  String get syncCopyUnavailable;

  /// No description provided for @syncCopyLastKnown.
  ///
  /// In en, this message translates to:
  /// **'Other devices show their last confirmed copy. Offline devices cannot be checked now.'**
  String get syncCopyLastKnown;

  /// No description provided for @syncCopyTemporary.
  ///
  /// In en, this message translates to:
  /// **'Temporary cache. Keep the originals on your devices.'**
  String get syncCopyTemporary;

  /// No description provided for @syncCopyStorage.
  ///
  /// In en, this message translates to:
  /// **'Your sync storage. Completed media uploads are listed in diagnostics.'**
  String get syncCopyStorage;

  /// No description provided for @syncCopyChecked.
  ///
  /// In en, this message translates to:
  /// **'Last confirmed {time}'**
  String syncCopyChecked(String time);

  /// No description provided for @cloudTrafficSummary.
  ///
  /// In en, this message translates to:
  /// **'Available this month: {remaining} / {limit}'**
  String cloudTrafficSummary(String remaining, String limit);

  /// No description provided for @onboardNewDiary.
  ///
  /// In en, this message translates to:
  /// **'Start here'**
  String get onboardNewDiary;

  /// No description provided for @onboardConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect to an existing device'**
  String get onboardConnect;

  /// No description provided for @onboardFailed.
  ///
  /// In en, this message translates to:
  /// **'Setup could not be completed. Your diary is safe; please try again.'**
  String get onboardFailed;

  /// No description provided for @tutorialTitle.
  ///
  /// In en, this message translates to:
  /// **'How to use the diary'**
  String get tutorialTitle;

  /// No description provided for @tutorialWriteTitle.
  ///
  /// In en, this message translates to:
  /// **'Write your first entry'**
  String get tutorialWriteTitle;

  /// No description provided for @tutorialWriteText.
  ///
  /// In en, this message translates to:
  /// **'Tap + to write. Add a title if you want, choose the diary day and tap the check mark to save. You can edit it again at any time.'**
  String get tutorialWriteText;

  /// No description provided for @tutorialMediaTitle.
  ///
  /// In en, this message translates to:
  /// **'Add photos, audio or handwriting'**
  String get tutorialMediaTitle;

  /// No description provided for @tutorialMediaText.
  ///
  /// In en, this message translates to:
  /// **'Use + in the editor to attach photos, videos or a voice note, or open the pen canvas. These attachments stay with the entry.'**
  String get tutorialMediaText;

  /// No description provided for @tutorialReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Find a day again'**
  String get tutorialReviewTitle;

  /// No description provided for @tutorialReviewText.
  ///
  /// In en, this message translates to:
  /// **'Browse the journal or calendar, search your writing and use tags to organize it. Media and Atlas help you look back by photo or place.'**
  String get tutorialReviewText;

  /// No description provided for @tutorialSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Use more than one device'**
  String get tutorialSyncTitle;

  /// No description provided for @tutorialSyncText.
  ///
  /// In en, this message translates to:
  /// **'In Settings → Data & storage → Sync, connect to an existing device and confirm authorization there. Both devices can keep using the diary. Text syncs first; media follows as the connection and allowance permit.'**
  String get tutorialSyncText;

  /// No description provided for @tutorialPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep your diary safe'**
  String get tutorialPrivacyTitle;

  /// No description provided for @tutorialPrivacyText.
  ///
  /// In en, this message translates to:
  /// **'Entries stay on this device unless you enable sync or share/export them. Sync is end-to-end encrypted. Settings also offers an app passcode and backups; you can reopen this tutorial there.'**
  String get tutorialPrivacyText;

  /// The logical diary date, independent of the immutable entry creation timestamp.
  ///
  /// In en, this message translates to:
  /// **'Diary day'**
  String get editorDiaryDay;

  /// The logical diary date, independent of the immutable entry creation timestamp.
  ///
  /// In en, this message translates to:
  /// **'Diary day · Which day is this entry about?'**
  String get editorDiaryDayPicker;

  /// When an entry was written, shown when that differs from its diary day.
  ///
  /// In en, this message translates to:
  /// **'Created {time}'**
  String editorCreatedAt(String time);

  /// The logical diary date, independent of the immutable entry creation timestamp.
  ///
  /// In en, this message translates to:
  /// **'The day this entry belongs to. Changing it does not change its creation time.'**
  String get editorDiaryDayHint;

  /// No description provided for @hiddenDiaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Hidden entries'**
  String get hiddenDiaryTitle;

  /// No description provided for @hiddenDiaryHide.
  ///
  /// In en, this message translates to:
  /// **'Hide entry'**
  String get hiddenDiaryHide;

  /// No description provided for @hiddenDiaryShow.
  ///
  /// In en, this message translates to:
  /// **'Unhide entry'**
  String get hiddenDiaryShow;

  /// No description provided for @hiddenDiaryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No hidden entries'**
  String get hiddenDiaryEmpty;

  /// No description provided for @hiddenDiaryUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock hidden entries'**
  String get hiddenDiaryUnlock;

  /// No description provided for @hiddenDiaryAuthHint.
  ///
  /// In en, this message translates to:
  /// **'Use the app lock or your device\'s screen lock to unlock.'**
  String get hiddenDiaryAuthHint;

  /// Shown after hiding an entry; path is Settings > Security > Hidden entries.
  ///
  /// In en, this message translates to:
  /// **'Hidden. To show it again: {path}'**
  String hiddenDiaryWhere(String path);

  /// No description provided for @noteKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get noteKeep;

  /// No description provided for @noteComment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get noteComment;

  /// No description provided for @noteCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Write to your past self'**
  String get noteCommentHint;

  /// No description provided for @noteKept.
  ///
  /// In en, this message translates to:
  /// **'Passage kept'**
  String get noteKept;

  /// No description provided for @notesPassages.
  ///
  /// In en, this message translates to:
  /// **'Kept passages'**
  String get notesPassages;

  /// No description provided for @notesComments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get notesComments;

  /// No description provided for @noteDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this note?'**
  String get noteDeleteConfirm;

  /// No description provided for @editPastTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit a past memory?'**
  String get editPastTitle;

  /// No description provided for @editPastBody.
  ///
  /// In en, this message translates to:
  /// **'This entry is from an earlier day. To answer it, select its text to keep or comment on a passage.'**
  String get editPastBody;

  /// No description provided for @editPastDontAsk.
  ///
  /// In en, this message translates to:
  /// **'Don\'t ask again'**
  String get editPastDontAsk;

  /// No description provided for @editPastEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit anyway'**
  String get editPastEdit;

  /// No description provided for @noteOnEntry.
  ///
  /// In en, this message translates to:
  /// **'On the entry of {date}'**
  String noteOnEntry(String date);

  /// No description provided for @settingsConfirmEditPast.
  ///
  /// In en, this message translates to:
  /// **'Ask before editing past entries'**
  String get settingsConfirmEditPast;

  /// No description provided for @settingsCompressPhotos.
  ///
  /// In en, this message translates to:
  /// **'Compress new photos'**
  String get settingsCompressPhotos;

  /// No description provided for @settingsCompressPhotosHint.
  ///
  /// In en, this message translates to:
  /// **'Store new photos as WebP of about 1 MB. Off keeps the originals.'**
  String get settingsCompressPhotosHint;

  /// No description provided for @compressExistingTitle.
  ///
  /// In en, this message translates to:
  /// **'Compress existing photos'**
  String get compressExistingTitle;

  /// No description provided for @compressExistingBody.
  ///
  /// In en, this message translates to:
  /// **'{count} photos take {size}. Those over about 1 MB become WebP of about 1 MB. This replaces them and cannot be undone; keep the originals elsewhere if you want them.'**
  String compressExistingBody(int count, String size);

  /// No description provided for @compressExistingAction.
  ///
  /// In en, this message translates to:
  /// **'Compress'**
  String get compressExistingAction;

  /// No description provided for @compressExistingDone.
  ///
  /// In en, this message translates to:
  /// **'Compressed {count} photos, saving {size}'**
  String compressExistingDone(int count, String size);

  /// No description provided for @commentExpand.
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get commentExpand;

  /// No description provided for @refAdd.
  ///
  /// In en, this message translates to:
  /// **'Cite an entry'**
  String get refAdd;

  /// No description provided for @refMissing.
  ///
  /// In en, this message translates to:
  /// **'That entry is no longer here'**
  String get refMissing;

  /// No description provided for @moodClear.
  ///
  /// In en, this message translates to:
  /// **'Clear mood'**
  String get moodClear;

  /// No description provided for @scrollToTop.
  ///
  /// In en, this message translates to:
  /// **'Back to top'**
  String get scrollToTop;

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedbackTitle;

  /// No description provided for @feedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Describe a problem or suggestion'**
  String get feedbackHint;

  /// No description provided for @feedbackSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get feedbackSend;

  /// No description provided for @feedbackSent.
  ///
  /// In en, this message translates to:
  /// **'Thanks, your feedback was sent.'**
  String get feedbackSent;

  /// No description provided for @feedbackSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not send. Check the connection and try again.'**
  String get feedbackSendFailed;

  /// No description provided for @feedbackOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the app.'**
  String get feedbackOpenFailed;

  /// No description provided for @feedbackSendNote.
  ///
  /// In en, this message translates to:
  /// **'Sent to the AID Diary server with the app version and language, nothing from your diary.'**
  String get feedbackSendNote;

  /// No description provided for @feedbackGithub.
  ///
  /// In en, this message translates to:
  /// **'GitHub issue'**
  String get feedbackGithub;

  /// No description provided for @feedbackEmail.
  ///
  /// In en, this message translates to:
  /// **'Email feedback'**
  String get feedbackEmail;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'AID Diary {version} is available'**
  String updateAvailable(String version);

  /// No description provided for @updateClosesNote.
  ///
  /// In en, this message translates to:
  /// **'The app closes to install the update; open it again afterwards.'**
  String get updateClosesNote;

  /// No description provided for @updateLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get updateLater;

  /// No description provided for @updateSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip this version'**
  String get updateSkip;

  /// No description provided for @updateInstall.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateInstall;

  /// No description provided for @updateDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading… {percent}%'**
  String updateDownloading(int percent);

  /// No description provided for @updateAllowInstall.
  ///
  /// In en, this message translates to:
  /// **'Allow AID Diary to install apps in the settings that opened, then tap Update again.'**
  String get updateAllowInstall;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'The update could not be installed: {reason}'**
  String updateFailed(String reason);

  /// No description provided for @updatedTo.
  ///
  /// In en, this message translates to:
  /// **'Updated to {version}'**
  String updatedTo(String version);

  /// No description provided for @updateWhatsNew.
  ///
  /// In en, this message translates to:
  /// **'What\'s new'**
  String get updateWhatsNew;

  /// No description provided for @updateCheckNow.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get updateCheckNow;

  /// No description provided for @updateNewest.
  ///
  /// In en, this message translates to:
  /// **'This is the newest version.'**
  String get updateNewest;

  /// No description provided for @updateAutoCheck.
  ///
  /// In en, this message translates to:
  /// **'Check for updates automatically'**
  String get updateAutoCheck;

  /// No description provided for @updateSilent.
  ///
  /// In en, this message translates to:
  /// **'Install updates without asking'**
  String get updateSilent;

  /// No description provided for @updateSilentHint.
  ///
  /// In en, this message translates to:
  /// **'Downloads in the background and installs when you leave the app. Android asks once, the first time.'**
  String get updateSilentHint;
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
