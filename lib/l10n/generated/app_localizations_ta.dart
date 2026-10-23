// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => 'தீம் நிறம்';

  @override
  String get themeColorHint => 'இந்தத் தட்டுக்கான வண்ணத்தைத் தேர்வு செய்யவும்.';

  @override
  String get themeColorBlue => 'வானம் நீலம்';

  @override
  String get themeColorGreen => 'காடு பச்சை';

  @override
  String get themeColorBrown => 'சூடான காபி';

  @override
  String get themeColorPurple => 'லாவெண்டர்';

  @override
  String get themeColorRose => 'தூசி நிறைந்த ரோஜா';

  @override
  String get themeColorAmber => 'அம்பர்';

  @override
  String get themeColorPreview => 'ஒவ்வொரு நாளும் கொஞ்சம்';

  @override
  String get themeTintBackgroundTitle => 'தீம் வண்ணத்துடன் பின்னணியில் சாயல்';

  @override
  String get themeTintBackgroundHint =>
      'நடுநிலை சாம்பல் பின்னணியில் அணைக்க; பொத்தான்கள் நீங்கள் தேர்ந்தெடுத்த நிறத்தை வைத்திருக்கும்.';

  @override
  String get dailyReminderTitle => 'இன்றைய பதிவு!';

  @override
  String get dailyReminderDescription => 'உங்கள் தினசரி பதிவை மேற்கொள்ளுங்கள்…';

  @override
  String get actionTakePhoto => 'புகைப்படம் எடு';

  @override
  String get flashbacksTitle => 'நினைவலைகள்';

  @override
  String get settingsFlashbacksExcludeBadDays => 'மோசமான நாட்களை தவிர்க்க';

  @override
  String get flashbackGoodDay => 'ஒரு நல்ல நாள்';

  @override
  String get flashbackRandomDay => 'குறிப்பிடப்படாத ஒரு நாள்';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count வாரங்களுக்கு முன்பு',
      one: '$count வாரம் முன்பு',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count மாதங்களுக்கு முன்பு',
      one: '$count Month ago',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ஆண்டுகளுக்கு முன்பு',
      one: '$count வருடம் முன்பு',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'இந்த நாளில்';

  @override
  String get searchLogsHint => 'தேடல் பதிவுகள்…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பதிவுகள்',
      one: '$count log',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count நாட்கள்',
      one: '$count நாள்',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count சொற்கள்',
      one: '$count word',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'பதிவுகள் இல்லை…';

  @override
  String get noResults => 'முடிவுகள் இல்லை...';

  @override
  String get sortOrderAscendingTitle => 'ஏறுதல்';

  @override
  String get sortOrderDescendingTitle => 'இறங்கு';

  @override
  String get pageStatisticsTitle => 'புள்ளிவிவரங்கள்';

  @override
  String get statisticsNotEnoughData => 'போதுமான தரவு இல்லை…';

  @override
  String get statisticsRangeOneMonth => '1 மாதம்';

  @override
  String get statisticsRangeSixMonths => '6 மாதங்கள்';

  @override
  String get statisticsRangeOneYear => '1 வருடம்';

  @override
  String get statisticsRangeAllTime => 'எல்லா நேரமும்';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag சுருக்கம்';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag நாள் வாரியாக';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag காலப்போக்கில்';
  }

  @override
  String get chartGroupingLabel => 'குழு மூலம்';

  @override
  String get chartGroupingDay => 'நாள்';

  @override
  String get chartGroupingWeek => 'வாரம்';

  @override
  String get chartGroupingMonth => 'மாதம்';

  @override
  String get chartGroupingYear => 'ஆண்டு';

  @override
  String get chartSmoothingLabel => 'மென்மையாக்கும்';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'தற்போதைய தொடர்: $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'மிக நீண்ட தொடர்: $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'பெரிய நாட்கள் $count',
      one: 'பெரிய நாட்கள் $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ஒரு மோசமான நாளிலிருந்து நாட்கள் $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'வெளிப்புற சேமிப்பகத்தை அணுக முடியவில்லை';

  @override
  String get errorExternalStorageAccessDescription =>
      'நீங்கள் பிணையம் சேமிப்பகத்தைப் பயன்படுத்துகிறீர்கள் என்றால், பணி ஆன்லைனில் இருப்பதையும் உங்களுக்கு பிணையம் அணுகல் இருப்பதையும் உறுதிப்படுத்திக் கொள்ளுங்கள். \n\nஇல்லையெனில், ஆப்ச் வெளிப்புற கோப்புறைக்கான அனுமதிகளை இழந்திருக்கலாம். அமைப்புகளுக்குச் சென்று, அணுகலை வழங்க வெளிப்புற கோப்புறையை மீண்டும் தேர்ந்தெடுக்கவும். \n\nஎச்சரிக்கை, வெளிப்புற சேமிப்பக இருப்பிடத்திற்கான அணுகலை மீட்டெடுக்கும் வரை மாற்றங்கள் ஒத்திசைக்கப்படாது!';

  @override
  String get errorExternalStorageAccessContinue =>
      'உள்ளக தரவுத்தளத்துடன் தொடரவும்';

  @override
  String get lastModified => 'மாற்றியமைக்கப்பட்ட';

  @override
  String get writeSomethingHint => 'ஏதாவது எழுது…';

  @override
  String get titleHint => 'தலைப்பு…';

  @override
  String get deleteLogTitle => 'பதிவை நீக்கு';

  @override
  String get deleteLogDescription => 'இந்தப் பதிவை நீக்க வேண்டுமா?';

  @override
  String get deletePhotoTitle => 'புகைப்படத்தை நீக்கு';

  @override
  String get deletePhotoDescription => 'இந்தப் படத்தை நீக்க வேண்டுமா?';

  @override
  String get pageSettingsTitle => 'அமைப்புகள்';

  @override
  String get settingsTheme => 'கருப்பொருள்';

  @override
  String get themeSystem => 'மண்டலம்';

  @override
  String get themeLight => 'ஒளி';

  @override
  String get themeDark => 'இருள்';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'வாரத்தின் முதல் நாள்';

  @override
  String get settingsCalendarSystem => 'காலண்டர் அமைப்பு';

  @override
  String get calendarSystemGregorian => 'கிரிகோரியன்';

  @override
  String get calendarSystemJalali => 'சலாலி';

  @override
  String get settingsUseSystemAccentColor =>
      'கணினி உச்சரிப்பு நிறத்தைப் பயன்படுத்தவும்';

  @override
  String get settingsCustomAccentColor => 'தனிப்பயன் உச்சரிப்பு நிறம்';

  @override
  String get settingsShowFlashbacks => 'ஃப்ளாச்பேக்குகளைக் காட்டு';

  @override
  String get settingsChangeMoodIcons => 'மூட் ஐகான்களை மாற்றவும்';

  @override
  String get moodIconPrompt => 'ஐகானை உள்ளிடவும்';

  @override
  String get settingsHideImages => 'படங்களை மறை';

  @override
  String get pageCalendarTitle => 'நாள்காட்டி';

  @override
  String get settingsNotificationsTitle => 'அறிவிப்புகள்';

  @override
  String get settingsDailyReminderTitle => 'நாள்தோறும் நினைவூட்டல்';

  @override
  String get settingsOnThisDayDescription =>
      'கடந்த கால நினைவுகளை மீண்டும் பார்க்கவும்';

  @override
  String get settingsDailyReminderDescription =>
      'ஒவ்வொரு நாளும் ஒரு மென்மையான நினைவூட்டல்';

  @override
  String get settingsReminderTime => 'நினைவூட்டல் நேரம்';

  @override
  String get settingsFixedReminderTimeTitle => 'நிலையான நினைவூட்டல் நேரம்';

  @override
  String get settingsFixedReminderTimeDescription =>
      'நினைவூட்டலுக்கு ஒரு குறிப்பிட்ட நேரத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get settingsAlwaysSendReminderTitle =>
      'எப்போதும் நினைவூட்டலை அனுப்பவும்';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'பதிவு ஏற்கனவே தொடங்கப்பட்டிருந்தாலும் நினைவூட்டலை அனுப்பவும்';

  @override
  String get settingsCustomizeNotificationTitle =>
      'அறிவிப்புகளைத் தனிப்பயனாக்கு';

  @override
  String get settingsTemplatesTitle => 'வார்ப்புருக்கள்';

  @override
  String get manageTemplates => 'டெம்ப்ளேட்களை நிர்வகிக்கவும்';

  @override
  String get noTemplateTitle => 'எதுவுமில்லை';

  @override
  String get noTemplatesDescription =>
      'இதுவரை டெம்ப்ளேட்கள் எதுவும் உருவாக்கப்படவில்லை…';

  @override
  String get templateDefaultTimestampTitle => 'நேர முத்திரை';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'நாள் சுருக்கம்';

  @override
  String get templateDefaultSummaryBody =>
      '### சுருக்கம் \n- \n\n### மேற்கோள் \n> ';

  @override
  String get templateDefaultReflectionTitle => 'பிரதிபலிப்பு';

  @override
  String get templateDefaultReflectionBody =>
      '### இன்று நீங்கள் எதைப் பற்றி ரசித்தீர்கள்? \n- \n\n### நீங்கள் எதற்கு நன்றி கூறுகிறீர்கள்? \n- \n\n### நீங்கள் என்ன எதிர்பார்க்கிறீர்கள்? \n- ';

  @override
  String get settingsTagsTitle => 'குறிச்சொற்கள்';

  @override
  String get manageTags => 'குறிச்சொற்களை நிர்வகிக்கவும்';

  @override
  String get tagTypeLabelTitle => 'லேபிள்';

  @override
  String get tagTypeTrackerTitle => 'டிராக்கர்';

  @override
  String get nameHint => 'பெயர்';

  @override
  String get tagColorLabel => 'நிறம்';

  @override
  String get iconPickerTitle => 'ஐகானைத் தேர்ந்தெடுக்கவும்';

  @override
  String get iconPickerIconsTab => 'சின்னங்கள்';

  @override
  String get iconPickerCustomTab => 'தனிப்பயன்';

  @override
  String get iconPickerSearchHint => 'ஐகான்களைத் தேடு…';

  @override
  String get colorPickerTitle => 'வண்ணத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get colorPickerPaletteTab => 'நிறங்கள்';

  @override
  String get iconGroupMoodPeople => 'மனநிலை மற்றும் மக்கள்';

  @override
  String get iconGroupHealth => 'ஆரோக்கியம்';

  @override
  String get iconGroupWorkFinance => 'வேலை & நிதி';

  @override
  String get iconGroupHabitsGoals => 'பழக்கம் & இலக்குகள்';

  @override
  String get iconGroupNature => 'இயற்கை';

  @override
  String get iconGroupFoodDrink => 'உணவு & பானம்';

  @override
  String get iconGroupHome => 'வீடு';

  @override
  String get iconGroupTravel => 'பயணம்';

  @override
  String get iconGroupSymbols => 'சின்னங்கள்';

  @override
  String get tagCategoryLabel => 'வகை';

  @override
  String get tagLabel => 'குறியிடவும்';

  @override
  String get tagCategoryUncategorized => 'வகைப்படுத்தப்படாத';

  @override
  String get newCategoryTitle => 'புதிய வகை';

  @override
  String get shareButtonLabel => 'பகிரவும்';

  @override
  String get importErrorDescription => 'கோப்பை இறக்குமதி செய்ய முடியவில்லை!';

  @override
  String get exportErrorDescription => 'கோப்பை ஏற்றுமதி செய்ய முடியவில்லை!';

  @override
  String get deleteTitle => 'நீக்கு';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' இது $count டைரி உள்ளீடுகளில் பயன்படுத்தப்படுகிறது.',
      one: ' இது $count டைரி பதிவில் பயன்படுத்தப்பட்டுள்ளது.',
      zero: '',
    );
    return '\"$name\" ஐ நீக்கவா?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' அதன் $count குறிச்சொற்களும் நீக்கப்படும்.',
      one: ' அதன் $count குறிச்சொல்லும் நீக்கப்படும்.',
      zero: '',
    );
    return '\"$name\" ஐ நீக்கவா?$_temp0';
  }

  @override
  String get tagNameExists => 'இந்தப் பெயரில் ஏற்கனவே ஒரு குறிச்சொல் உள்ளது';

  @override
  String get categoryNameExists => 'இந்தப் பெயரில் ஏற்கனவே ஒரு வகை உள்ளது';

  @override
  String deleteTemplateMessage(Object name) {
    return '\"$name\" ஐ நீக்கவா?';
  }

  @override
  String get addTagsTitle => 'குறிச்சொற்களைச் சேர்க்கவும்';

  @override
  String get addTagsSearchHint => 'குறிச்சொற்களைத் தேடு…';

  @override
  String get tagPickerSortManualLabel => 'கைமுறை ஆர்டர்';

  @override
  String get tagPickerSortUsageLabel => 'பயன்பாட்டின்படி வரிசைப்படுத்தவும்';

  @override
  String get tagFavoriteName => 'பிடித்தது';

  @override
  String get tagEnergyName => 'ஆற்றல்';

  @override
  String get tagCategoryActivitiesName => 'செயல்பாடுகள்';

  @override
  String get tagExerciseName => 'உடற்பயிற்சி';

  @override
  String get tagSocializingName => 'சமூகமயமாக்கல்';

  @override
  String get tagHobbyName => 'பொழுதுபோக்கு';

  @override
  String get tagEntertainmentName => 'பொழுதுபோக்கு';

  @override
  String get tagDiningName => 'சாப்பாடு';

  @override
  String get tagChoresName => 'வேலைகள்';

  @override
  String get tagCategoryEmotionsName => 'உணர்ச்சிகள்';

  @override
  String get tagExcitedName => 'உற்சாகம்';

  @override
  String get tagGratefulName => 'நன்றியுள்ளவர்';

  @override
  String get tagCalmName => 'அமைதி';

  @override
  String get tagTiredName => 'சோர்வாக';

  @override
  String get tagAnxiousName => 'கவலை';

  @override
  String get tagAnnoyedName => 'எரிச்சலடைந்தேன்';

  @override
  String get settingsStorageTitle => 'சேமிப்பு';

  @override
  String get settingsImageQuality => 'படத்தின் தகுதி';

  @override
  String get imageQualityHigh => 'உயர்';

  @override
  String get imageQualityMedium => 'சராசரி';

  @override
  String get imageQualityLow => 'குறைந்த';

  @override
  String get imageQualityNoCompression => 'சுருக்கம் இல்லை';

  @override
  String get settingsLogFolder => 'பதிவு கோப்புறை';

  @override
  String get settingsImageFolder => 'படக் கோப்புறை';

  @override
  String get warningTitle => 'எச்சரிக்கை';

  @override
  String get logFolderWarningDescription =>
      'தேர்ந்தெடுக்கப்பட்ட கோப்புறையில் ஏற்கனவே \'aid_diary.db\' கோப்பு இருந்தால், அது ஏற்கனவே உள்ள உங்கள் பதிவுகளை மேலெழுதப் பயன்படுத்தப்படும்!';

  @override
  String get errorTitle => 'பிழை';

  @override
  String get logFolderErrorDescription => 'பதிவு கோப்புறையை மாற்ற முடியவில்லை!';

  @override
  String get imageFolderErrorDescription => 'பட கோப்புறையை மாற்ற முடியவில்லை!';

  @override
  String get backupErrorDescription => 'காப்புப்பிரதியை உருவாக்குவதில் தோல்வி!';

  @override
  String get restoreErrorDescription =>
      'காப்புப்பிரதியை மீட்டெடுப்பதில் தோல்வி!';

  @override
  String get settingsBackupRestoreTitle => 'காப்புப்பிரதி & மீட்டமை';

  @override
  String get settingsBackup => 'காப்புப்பிரதி';

  @override
  String get settingsRestore => 'மீட்டமை';

  @override
  String get settingsRestorePromptDescription =>
      'காப்புப்பிரதியை மீட்டெடுப்பது ஏற்கனவே உள்ள உங்கள் தரவை மேலெழுதும்!';

  @override
  String get settingsBackupPasswordProtect =>
      'கடவுச்சொல் பாதுகாப்பு காப்புப்பிரதிகள்';

  @override
  String get backupEncryptedTitle => 'மறைகுறியாக்கப்பட்ட காப்புப்பிரதி';

  @override
  String get backupEncryptedContent =>
      'இந்த காப்புப் பிரதி கடவுச்சொல் பாதுகாக்கப்பட்டுள்ளது.';

  @override
  String get settingsAutoBackup => 'தானியங்கி காப்புப்பிரதிகள்';

  @override
  String get settingsAutoBackupLocation => 'காப்புப் பிரதி இடம்';

  @override
  String get settingsAutoBackupInterval => 'காப்பு இடைவெளி';

  @override
  String get settingsAutoBackupIntervalDaily => 'தினசரி';

  @override
  String get settingsAutoBackupIntervalWeekly => 'வாரந்தோறும்';

  @override
  String get settingsAutoBackupIntervalMonthly => 'மாதாந்திர';

  @override
  String get settingsAutoBackupMaxCount =>
      'காப்புப் பிரதிகள் வைத்திருக்க வேண்டும்';

  @override
  String get settingsAutoBackupRequireCharging =>
      'சார்ஜ் செய்யும் போது மட்டும்';

  @override
  String settingsBackupLast(Object time) {
    return 'கடைசி காப்புப்பிரதி $time';
  }

  @override
  String get settingsBackupNever => 'ஒருபோதும் காப்புப் பிரதி எடுக்கவில்லை';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'அடுத்த காப்புப்பிரதி $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'அனைத்து';

  @override
  String get autoBackupFailedTitle => 'காப்புப்பிரதி தோல்வியடைந்தது';

  @override
  String tranferStatus(Object percent) {
    return 'மாற்றுகிறது… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'காப்புப்பிரதியை உருவாக்குகிறது… $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'காப்புப்பிரதியை மீட்டெடுக்கிறது… $percent%';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return 'காப்புப்பிரதியை என்க்ரிப்ட் செய்கிறது… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'காப்புப்பிரதியை மறைகுறியாக்குகிறது… $percent%';
  }

  @override
  String get cleanUpStatus => 'தூய்மை செய்கிறது…';

  @override
  String get settingsExportToAnotherFormat =>
      'மற்றொரு வடிவத்திற்கு ஏற்றுமதி செய்யவும்';

  @override
  String get settingsExportFormatDescription =>
      'இதை காப்புப்பிரதியாகப் பயன்படுத்தக் கூடாது!';

  @override
  String get settingsImportFromAnotherApp =>
      'மற்றொரு பயன்பாட்டிலிருந்து இறக்குமதி செய்யவும்';

  @override
  String get logFormatTitle => 'வடிவமைப்பைத் தேர்ந்தெடுக்கவும்';

  @override
  String get logFormatDescription =>
      'மற்றொரு ஆப்சின் வடிவம் அனைத்து அம்சங்களையும் ஆதரிக்காமல் இருக்கலாம். மூன்றாம் தரப்பு வடிவங்கள் எந்த நேரத்திலும் மாறக்கூடும் என்பதால், ஏதேனும் சிக்கல்களைப் புகாரளிக்கவும். இது ஏற்கனவே உள்ள பதிவுகளை பாதிக்காது!';

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
  String get formatOneShot => 'ஒன்ஷாட்';

  @override
  String get formatPixels => 'Pixels';

  @override
  String get formatMarkdown => 'மார்க் பேரூர்';

  @override
  String get settingsDeleteAllLogsTitle => 'அனைத்து பதிவுகளையும் நீக்கு';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Do you want பெறுநர் நீக்கு அனைத்தும் of your logs?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'உறுதிப்படுத்த \'$prompt\' ஐ உள்ளிடவும். இதை செயல்தவிர்க்க முடியாது!';
  }

  @override
  String get settingsLanguageTitle => 'மொழி';

  @override
  String get settingsAppLanguageTitle => 'பயன்பாட்டு மொழி';

  @override
  String get settingsOverrideAppLanguageTitle =>
      'பயன்பாட்டு மொழியை மேலெழுதவும்';

  @override
  String get settingsSecurityTitle => 'பாதுகாப்பு';

  @override
  String get settingsSecurityRequirePassword => 'கடவுச்சொல் தேவை';

  @override
  String get settingsSecurityEnterPassword => 'கடவுச்சொல்லை உள்ளிடவும்';

  @override
  String get settingsSecuritySetPassword => 'கடவுச்சொல்லை அமைக்கவும்';

  @override
  String get settingsSecurityChangePassword => 'கடவுச்சொல்லை மாற்றவும்';

  @override
  String get settingsSecurityPassword => 'கடவுச்சொல்';

  @override
  String get settingsSecurityConfirmPassword =>
      'கடவுச்சொல்லை உறுதிப்படுத்தவும்';

  @override
  String get settingsSecurityOldPassword => 'பழைய கடவுச்சொல்';

  @override
  String get settingsSecurityIncorrectPassword => 'தவறான கடவுச்சொல்';

  @override
  String get settingsSecurityPasswordsDoNotMatch =>
      'கடவுச்சொற்கள் பொருந்தவில்லை';

  @override
  String get requiredPrompt => 'தேவை';

  @override
  String get settingsSecurityBiometricUnlock => 'பயோமெட்ரிக் திறத்தல்';

  @override
  String get unlockAppPrompt => 'பயன்பாட்டைத் திறக்கவும்';

  @override
  String get settingsAboutTitle => 'பற்றி';

  @override
  String get settingsVersion => 'பதிப்பு';

  @override
  String get settingsLicense => 'உரிமம்';

  @override
  String get licenseGPLv3 => 'சிபிஎல்-3.0';

  @override
  String get settingsOpenSourceLicenses => 'திறந்த மூல உரிமங்கள்';

  @override
  String get tagMoodTitle => 'மனநிலை';

  @override
  String get selectTagTitle => 'குறிச்சொல்லைத் தேர்ந்தெடுக்கவும்';

  @override
  String get labelPresentLabel => 'தற்போது';

  @override
  String get labelAbsentLabel => 'இல்லாதது';

  @override
  String get labelCoverageLabel => 'கவரேஜ்';

  @override
  String chartDistributionTitle(Object tag) {
    return '$tag விநியோகம்';
  }

  @override
  String get shareAddToLogPickerTitle => 'ஒரு நாட்குறிப்பைத் தேர்ந்தெடுக்கவும்';

  @override
  String get adaptiveEmptyDay => 'இந்த நாளுக்கான பதிவுகள் எதுவும் இல்லை';

  @override
  String get adaptiveNewEntry => 'ஒரு பதிவை எழுதுங்கள்';

  @override
  String get pageJournalTitle => 'இதழ்';

  @override
  String get coachPrompt1 => 'இன்று உங்களை சிரிக்க வைத்தது எது?';

  @override
  String get coachPrompt2 => 'இன்று நீங்கள் கற்றுக்கொண்ட ஒரு விஷயம் என்ன?';

  @override
  String get coachPrompt3 =>
      'இன்று நீங்கள் யாருடன் பேசினீர்கள், எப்படி உணர்ந்தீர்கள்?';

  @override
  String get coachPrompt4 =>
      'நீங்கள் இப்போது எதற்காக நன்றியுள்ளவர்களாக இருக்கிறீர்கள்?';

  @override
  String get coachPrompt5 => 'இன்று உங்கள் ஆற்றலை அதிகம் எடுத்தது எது?';

  @override
  String get coachPrompt6 =>
      'நீங்கள் நினைவில் கொள்ள விரும்பும் ஒரு சிறிய தருணத்தை விவரிக்கவும்.';

  @override
  String get coachPrompt7 => 'நாளை ஒரு நல்ல நாளாக மாற்றுவது எது?';

  @override
  String get coachPrompt8 => 'சமீபத்தில் உங்கள் மனதில் என்ன இருந்தது?';

  @override
  String get coachPrompt9 => 'இன்று உனக்காக மட்டும் என்ன செய்தாய்?';

  @override
  String get coachPrompt10 =>
      'இன்று ஒரு தலைப்பு இருந்தால், அது என்னவாக இருக்கும்?';

  @override
  String get pageMediaTitle => 'ஊடகம்';

  @override
  String get pageAtlasTitle => 'அட்லஸ்';

  @override
  String get pageCoachTitle => 'பயிற்சியாளர்';

  @override
  String get noEntrySelected => 'நுழைவு எதுவும் தேர்ந்தெடுக்கப்படவில்லை.';

  @override
  String get entryShare => 'பகிரவும்';

  @override
  String get entryFavorite => 'நட்சத்திரம்';

  @override
  String get entryEdit => 'திருத்தவும்';

  @override
  String get entryPrevious => 'முந்தைய நுழைவு';

  @override
  String get entryNext => 'அடுத்த பதிவு';

  @override
  String get journalStories => 'கதைகள்';

  @override
  String get journalEntries => 'உள்ளீடுகள்';

  @override
  String get journalEmptyHint =>
      'புதிய பதிவைச் சேர்ப்பதன் மூலம் உங்கள் நாட்குறிப்பைத் தொடங்குங்கள்.';

  @override
  String get storyToday => 'இன்று';

  @override
  String get storyThrowback => 'த்ரோபேக்';

  @override
  String get storyNoThrowback => 'இன்று பின்னடைவு இல்லை';

  @override
  String get mediaFiles => 'மீடியா கோப்புகள்';

  @override
  String get mediaEmpty => 'இதுவரை புகைப்படங்கள் இல்லை.';

  @override
  String get mediaEmptyHint =>
      'உள்ளீடுகளுடன் இணைக்கப்பட்ட புகைப்படங்கள் இங்கே காட்டப்படும்.';

  @override
  String get atlasEmpty => 'இருப்பிடத்துடன் உள்ளீடுகள் இல்லை.';

  @override
  String get atlasEmptyHint =>
      'இருப்பிடத்துடன் உள்ள பதிவுகள் இங்கே காட்டப்படும்.';

  @override
  String get atlasShowAll => 'அனைத்து உள்ளீடுகளையும் காட்டு';

  @override
  String get atlasMyLocation => 'எனது இருப்பிடம்';

  @override
  String get coachAll => 'அனைத்து';

  @override
  String get coachPrograms => 'நிகழ்ச்சிகள்';

  @override
  String get coachTemplates => 'வார்ப்புருக்கள்';

  @override
  String get coachKindProgram => 'நிரல்';

  @override
  String get coachKindTemplate => 'டெம்ப்ளேட்';

  @override
  String get coachNoTemplates => 'திட்டங்கள் அல்லது டெம்ப்ளேட்கள் இல்லை.';

  @override
  String get coachUseTemplate => 'இந்த டெம்ப்ளேட்டைக் கொண்டு எழுதுங்கள்';

  @override
  String get coachProgramEverydayTitle => 'அன்றாட தருணங்கள்';

  @override
  String get coachProgramEverydayDescription =>
      'ஐந்து சிறிய கேள்விகள், ஒரு நாளைக்கு ஒன்று. ஒவ்வொன்றும் ஒரு நிமிடம் அல்லது இரண்டு நிமிடங்கள் எடுத்து, அந்த நாளை உங்களுடையதாக ஆக்கியது என்ன என்பதைப் பார்க்க உதவுகிறது. ஒவ்வொரு நாளும் கொஞ்சம் எழுதும் பழக்கத்தை உருவாக்க ஒரு மென்மையான வழி.';

  @override
  String get coachProgramReflectTitle => 'உள்நோக்கிப் பார்க்கிறது';

  @override
  String get coachProgramReflectDescription =>
      'ஒரு வாரத்திற்கு ஒரு ஆழமான கேள்வி, ஐந்து வாரங்களுக்கு. ஒவ்வொன்றிலும் உங்கள் நேரத்தை எடுத்துக் கொள்ளுங்கள்: நீங்கள் எப்படி உணர்கிறீர்கள், எது உங்களை சோர்வடையச் செய்கிறது, எதற்காக நீங்கள் நன்றியுள்ளவர்களாக இருக்கிறீர்கள்.';

  @override
  String get searchFilters => 'வடிப்பான்கள்';

  @override
  String get searchFilterTags => 'குறிச்சொற்கள்';

  @override
  String get searchFilterStarred => 'நட்சத்திரமிட்டது';

  @override
  String get searchHint =>
      'தேட தட்டச்சு செய்யவும் அல்லது வடிப்பானைத் தேர்ந்தெடுக்கவும்.';

  @override
  String get locationTitle => 'இடம்';

  @override
  String get locationName => 'இடப் பெயர்';

  @override
  String get locationRemove => 'அகற்று';

  @override
  String get locationServiceDisabled => 'இருப்பிடச் சேவைகள் முடக்கப்பட்டுள்ளன.';

  @override
  String get locationPermissionDenied => 'இருப்பிட அனுமதி மறுக்கப்பட்டது.';

  @override
  String get locationUnavailable => 'தற்போதைய இருப்பிடத்தைப் பெற முடியவில்லை.';

  @override
  String get calendarJumpToToday => 'இன்று தாவி';

  @override
  String get editorStartWriting =>
      'எழுதத் தொடங்குங்கள் அல்லது தேர்வு செய்யவும் ';

  @override
  String get editorTemplateLink => 'டெம்ப்ளேட்';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'ஒரு டெம்ப்ளேட்டைத் தேர்ந்தெடுக்கவும்';

  @override
  String get templateFeatured => 'சிறப்பு வார்ப்புருக்கள்';

  @override
  String get templateMine => 'எனது வார்ப்புருக்கள்';

  @override
  String get templateDailyName => 'தினசரி ஆய்வு';

  @override
  String get templateDailyDescription =>
      'என்ன நடந்தது, எப்படி உணர்ந்தது, அடுத்து என்ன நடக்கும்.';

  @override
  String get templateDailyText =>
      '## இன்று என்ன நடந்தது\n\n\n## நான் எப்படி உணர்ந்தேன்\n\n\n## மூன்று விஷயங்களுக்கு நான் நன்றியுள்ளவனாக இருக்கிறேன்\n1. \n2. \n3. \n\n## நாளை\n';

  @override
  String get templateTravelName => 'பயண நாட்குறிப்பு பதிவு';

  @override
  String get templateTravelDescription =>
      'சாலையிலிருந்து இடங்கள், தருணங்கள் மற்றும் உணவு.';

  @override
  String get templateTravelText =>
      '## நான் எங்கு சென்றேன்\n\n\n## நான் மிகவும் நினைவில் வைத்திருக்கும் தருணம்\n\n\n## நான் என்ன சாப்பிட்டேன்\n\n\n## நாளைக்கான திட்டங்கள்\n';

  @override
  String get templateReadingName => 'குறிப்புகளைப் படித்தல்';

  @override
  String get templateReadingDescription =>
      'நீங்கள் படித்தவற்றிலிருந்து மேற்கோள்கள் மற்றும் எண்ணங்கள்.';

  @override
  String get templateReadingText =>
      '## புத்தகம்\n\n\n## நான் எங்கே இருக்கிறேன்\n\n\n## மேற்கோள்கள்\n> \n\n## என் எண்ணங்கள்\n';

  @override
  String get templateWeeklyName => 'வாராந்திர ஆய்வு';

  @override
  String get templateWeeklyDescription =>
      'சிறப்பம்சங்கள், போராட்டங்கள் மற்றும் அடுத்த வார கவனம்.';

  @override
  String get templateWeeklyText =>
      '## சிறப்பம்சங்கள்\n\n\n## என்ன கடினமாக இருந்தது\n\n\n## நான் கற்றுக்கொண்டது\n\n\n## அடுத்த வாரம் கவனம்\n';

  @override
  String get entryDuplicate => 'நகல்';

  @override
  String get entryDuplicated => 'நுழைவு நகல்';

  @override
  String get entrySaveAsTemplate => 'டெம்ப்ளேட்டாக சேமிக்கவும்';

  @override
  String get entrySavedAsTemplate => 'டெம்ப்ளேட்டாக சேமிக்கப்பட்டது';

  @override
  String get storyStatistics => 'புள்ளிவிவரங்கள்';

  @override
  String get storyMoodChart => 'மனநிலை விளக்கப்படம்';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return '$entries உள்ளீடுகள் · $days நாட்கள்';
  }

  @override
  String get storyThisYear => 'இந்த ஆண்டு';

  @override
  String get storyLastYear => 'கடந்த ஆண்டு';

  @override
  String get storyTapToOpen => 'அதைத் திறக்க ஒரு நாள் தட்டவும்';

  @override
  String get settingsGeneralTitle => 'பொது';

  @override
  String get settingsDataTitle => 'தரவு & சேமிப்பு';

  @override
  String get settingsStoriesTitle => 'கதைகள்';

  @override
  String get settingsHelpTitle => 'உதவி & பற்றி';

  @override
  String get weatherTitle => 'வானிலை';

  @override
  String get weatherClear => 'தெளிவு';

  @override
  String get weatherPartlyCloudy => 'ஓரளவு மேகமூட்டத்துடன் காணப்படும்';

  @override
  String get weatherCloudy => 'மேகமூட்டம்';

  @override
  String get weatherFog => 'மூடுபனி';

  @override
  String get weatherDrizzle => 'தூறல்';

  @override
  String get weatherRain => 'மழை';

  @override
  String get weatherSnow => 'பனி';

  @override
  String get weatherStorm => 'இடியுடன் கூடிய மழை';

  @override
  String get weatherFetch => 'இந்த நுழைவுக்கான வானிலையைப் பெறுங்கள்';

  @override
  String get weatherNeedsLocation =>
      'முதலில் ஆயத்தொலைவுகளுடன் இருப்பிடத்தைச் சேர்க்கவும்.';

  @override
  String get weatherUnavailable =>
      'இந்த இடத்திற்கும் நேரத்திற்கும் வானிலை இல்லை.';

  @override
  String get weatherRemove => 'வானிலை அகற்று';

  @override
  String get activityTitle => 'செயல்பாடு';

  @override
  String get activityStill => 'இன்னும்';

  @override
  String get activityWalking => 'நடைபயிற்சி';

  @override
  String get activityRunning => 'ஓடுகிறது';

  @override
  String get activityCycling => 'சைக்கிள் ஓட்டுதல்';

  @override
  String get activityVehicle => 'ஒரு வாகனத்தில்';

  @override
  String get activityFlying => 'பறக்கும்';

  @override
  String get activityExercise => 'உடற்பயிற்சி';

  @override
  String get activityDetect => 'தற்போதைய செயல்பாட்டைக் கண்டறியவும்';

  @override
  String get activityDetectFailed => 'செயல்பாட்டைக் கண்டறிய முடியவில்லை.';

  @override
  String get activityRemove => 'செயல்பாட்டை அகற்று';

  @override
  String get settingsAutoAddTitle => 'தானாகச் சேர்க்கவும்';

  @override
  String get settingsAutoAddLocation => 'இடம்';

  @override
  String get settingsAutoAddWeather => 'வானிலை';

  @override
  String get settingsAutoAddHint =>
      'புதிய உள்ளீடுகள் உருவாக்கப்படும் போது இவை நிரப்பப்படும்.';

  @override
  String get settingsTemperatureUnit => 'வெப்பநிலை அலகு';

  @override
  String get settingsCelsius => 'செல்சியஸ் (°C)';

  @override
  String get settingsFahrenheit => 'ஃபாரன்ஹீட் (°F)';

  @override
  String get moodGreat => 'பெரிய';

  @override
  String get moodGood => 'நல்லது';

  @override
  String get moodOkay => 'சரி';

  @override
  String get moodBad => 'மோசமான';

  @override
  String get moodAwful => 'பரிதாபம்';

  @override
  String get locationSearchHint => 'ஒரு இடத்தைத் தேடுங்கள்';

  @override
  String get locationSearchEmpty => 'இடங்கள் இல்லை';

  @override
  String get settingsWallpaper => 'வால்பேப்பர்';

  @override
  String get wallpaperNone => 'இல்லை';

  @override
  String get wallpaperDots => 'புள்ளிகள்';

  @override
  String get wallpaperGrid => 'கட்டம்';

  @override
  String get wallpaperLines => 'கோடுகள்';

  @override
  String get wallpaperPhoto => 'புகைப்படம்…';

  @override
  String get settingsFontFamily => 'எழுத்துரு';

  @override
  String get fontSystem => 'அமைப்பு';

  @override
  String get fontSerif => 'செரிஃப்';

  @override
  String get fontMono => 'மோனோஸ்பேஸ்';

  @override
  String get settingsFontSize => 'எழுத்துரு அளவு';

  @override
  String get fontSizeSmall => 'சிறியது';

  @override
  String get fontSizeMedium => 'நடுத்தர';

  @override
  String get fontSizeLarge => 'பெரியது';

  @override
  String get fontSizeExtraLarge => 'கூடுதல் பெரியது';

  @override
  String get settingsLineSpacing => 'வரி இடைவெளி';

  @override
  String get lineSpacingCompact => 'கச்சிதமான';

  @override
  String get lineSpacingNormal => 'இயல்பானது';

  @override
  String get lineSpacingRelaxed => 'நிதானமாக';

  @override
  String get moodAssociationsTitle => 'என்னை என்ன உணர வைக்கிறது...';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$total உள்ளீடுகளின் $matching';
  }

  @override
  String get videoRecord => 'வீடியோவை பதிவு செய்யுங்கள்';

  @override
  String get videoChoose => 'வீடியோவைத் தேர்ந்தெடுக்கவும்';

  @override
  String get audioRecordTitle => 'குரல் குறிப்பை பதிவு செய்யவும்';

  @override
  String get audioChoose => 'ஆடியோ கோப்பைத் தேர்ந்தெடுக்கவும்';

  @override
  String get audioStart => 'பதிவு';

  @override
  String get audioStop => 'நிறுத்தி சேமிக்கவும்';

  @override
  String get audioPermissionDenied =>
      'மைக்ரோஃபோன் அணுகல் முடக்கப்பட்டுள்ளது. கணினி அமைப்புகளில் அதை அனுமதிக்கவும்.';

  @override
  String get mediaTooLarge =>
      'இந்த வீடியோ இணைக்க முடியாத அளவுக்கு பெரிதாக உள்ளது.';

  @override
  String get mediaUnavailable => 'இந்த சாதனத்தில் இந்த இணைப்பு கிடைக்கவில்லை.';

  @override
  String get widgetDone => 'இன்றைய பதிவு எழுதப்பட்டது';

  @override
  String get widgetPending => 'உங்கள் நாள் எப்படி இருந்தது?';

  @override
  String get widgetWrite => 'எழுது';

  @override
  String get insertChecklist => 'சரிபார்ப்பு பட்டியல்';

  @override
  String get insertNumberedList => 'எண்ணிடப்பட்ட பட்டியல்';

  @override
  String get insertTable => 'அட்டவணை';

  @override
  String get insertDivider => 'பிரிப்பான்';

  @override
  String get insertCodeBlock => 'குறியீடு தொகுதி';

  @override
  String get journalSortTitle => 'உள்ளீடுகளை வரிசைப்படுத்தவும்';

  @override
  String get journalSortUpdated => 'கடைசியாக புதுப்பிக்கப்பட்டது';

  @override
  String get settingsTimeFormat => 'நேர வடிவம்';

  @override
  String get settingsDayStart =>
      'புதிய உள்ளீடுகள் முந்தைய நாள் வரை கணக்கிடப்படும்';

  @override
  String get settingsDayAskUntil => 'பிறகு எந்த நாள் வரை என்று கேளுங்கள்';

  @override
  String get settingsDayStartMidnight => 'ஆஃப்';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'ஒவ்வொரு பதிவும் அது எழுதப்பட்ட நேரத்திற்கு அடுத்ததாக இருக்கும் நாளை வைத்து, எந்த நேரத்திலும் எடிட்டரில் அந்த நாளை மாற்றலாம். இந்த மணிநேரங்கள் புதிய உள்ளீடுகளுக்கான நாளை மட்டுமே தேர்ந்தெடுக்கின்றன, எனவே அவற்றை மாற்றுவது ஏற்கனவே உள்ள நுழைவை மாற்றாது.';

  @override
  String get lateNightBadge =>
      'இரவு தாமதமாக எழுதப்பட்டது, முந்தைய நாளுக்காக எண்ணப்பட்டது';

  @override
  String editorDayAsk(String time) {
    return '$time இல் எழுதப்பட்டது. இது எந்த நாளுக்கானது?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (நேற்று)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (இன்று)';
  }

  @override
  String editorWrittenAt(String when) {
    return '$when எழுதப்பட்டது';
  }

  @override
  String get timeFormat12 => '12-மணிநேரம்';

  @override
  String get timeFormat24 => '24-மணிநேரம்';

  @override
  String get settingsReminderDays => 'எனக்கு நினைவூட்டு';

  @override
  String get locationRecent => 'சமீபத்திய இடங்கள்';

  @override
  String get shareImage => 'படத்தைப் பகிரவும்';

  @override
  String get shareSaveImage => 'படத்தை சேமிக்கவும்';

  @override
  String get shareSaved => 'படம் சேமிக்கப்பட்டது';

  @override
  String get deletedTitle => 'சமீபத்தில் நீக்கப்பட்டது';

  @override
  String get deletedNone => 'சமீபத்தில் எதுவும் நீக்கப்படவில்லை';

  @override
  String deletedHint(int days) {
    return 'நீக்கப்பட்ட உள்ளீடுகள் $days நாட்களுக்கு இங்கே இருக்கும், பின்னர் அழிக்கப்படும்.';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days நாட்கள் உள்ளன';
  }

  @override
  String get deletedRestore => 'மீட்டமை';

  @override
  String get deletedDeleteForever => 'நிரந்தரமாக நீக்கு';

  @override
  String get deletedDeleteForeverDescription =>
      'நுழைவு மற்றும் அதன் இணைப்புகள் அழிக்கப்பட்டன. இதை செயல்தவிர்க்க முடியாது.';

  @override
  String get deletedEmpty => 'காலி';

  @override
  String get deletedEmptyDescription =>
      'சமீபத்தில் நீக்கப்பட்டதில் உள்ள ஒவ்வொரு பதிவையும் அழிக்கவா? இதை செயல்தவிர்க்க முடியாது.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'சீரற்ற நடை';

  @override
  String get randomSubtitle => 'கடந்த உள்ளீட்டைத் திறக்கவும்';

  @override
  String get randomNext => 'மற்றொன்று';

  @override
  String get randomAll => 'அனைத்து';

  @override
  String get randomWithPhotos => 'புகைப்படங்களுடன்';

  @override
  String get randomGoodDays => 'நல்ல நாட்கள்';

  @override
  String get randomEmpty => 'தேர்வு செய்ய உள்ளீடுகள் இல்லை';

  @override
  String get reviewWeekTitle => 'இந்த வாரம்';

  @override
  String get reviewWeekSubtitle => 'இதுவரை உங்கள் வாரம்';

  @override
  String get reviewYearTitle => 'இந்த ஆண்டு';

  @override
  String get reviewEmpty => 'இன்னும் எதுவும் எழுதவில்லை';

  @override
  String get reviewEntries => 'உள்ளீடுகள்';

  @override
  String get reviewDaysWritten => 'எழுதப்பட்ட நாட்கள்';

  @override
  String get reviewWords => 'வார்த்தைகள்';

  @override
  String get reviewPhotos => 'புகைப்படங்கள்';

  @override
  String get reviewLongestRun => 'மிக நீண்ட நாட்கள்';

  @override
  String get reviewAverageMood => 'சராசரி மனநிலை';

  @override
  String get reviewFavorites => 'பெரும்பாலும்';

  @override
  String get reviewByMonth => 'மாதப்படி';

  @override
  String get reviewHighlight => 'முன்னிலைப்படுத்தவும்';

  @override
  String get yearInPixels => 'பிக்சல்களில் ஆண்டு';

  @override
  String get capsuleSeal => 'நேர காப்ஸ்யூலாக முத்திரையிடவும்';

  @override
  String get capsuleTitle => 'நேர காப்ஸ்யூல்';

  @override
  String capsuleOpensOn(Object date) {
    return '$date இல் திறக்கப்படும்';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return '$date இல் எழுதப்பட்டது';
  }

  @override
  String get capsuleOpenEarly => 'முன்கூட்டியே திறக்கவும்';

  @override
  String get capsuleOpenEarlyDescription =>
      'காப்ஸ்யூல் இப்போது திறந்து திறந்திருக்கும்.';

  @override
  String get capsuleOpened => 'டைம் கேப்ஸ்யூல் திறக்கப்பட்டது';

  @override
  String get templateMorningName => 'காலை பக்கங்கள்';

  @override
  String get templateMorningDescription =>
      'மூன்று நிமிடங்களில் நாளை அமைக்கவும்';

  @override
  String get templateMorningText =>
      '## நான் இன்று நன்றாக செய்ய விரும்பும் மூன்று விஷயங்கள்\n1. \n2. \n3. \n\n## நான் ஆவலுடன் காத்திருக்கிறேன்\n\n## எனக்கு நானே ஒரு குறிப்பு\n';

  @override
  String get templateEveningName => 'மாலை விமர்சனம்';

  @override
  String get templateEveningDescription =>
      'நன்றாக நடந்ததை வைத்து நாளை முடிக்கவும்';

  @override
  String get templateEveningText =>
      '## இன்று மூன்று நல்ல விஷயங்கள்\n1. \n2. \n3. \n\n## நான் கற்றுக்கொண்டது\n\n## நாளை எது சிறப்பாக நடக்க முடியும்\n';

  @override
  String get routineMorning => 'காலை வணக்கம்';

  @override
  String get routineEvening => 'மாலை விமர்சனம்';

  @override
  String get settingsRoutinePrompts => 'காலை மற்றும் மாலை தூண்டுகிறது';

  @override
  String get settingsRoutinePromptsHint =>
      'கதைகளில் காலை அல்லது மாலை டெம்ப்ளேட்டைப் பரிந்துரைக்கவும்';

  @override
  String get checkInTitle => 'விரைவான செக்-இன்';

  @override
  String get checkInSubtitle => 'இரண்டு தட்டுகளில் மனநிலை';

  @override
  String get checkInMood => 'நீங்கள் எப்படி உணர்கிறீர்கள்?';

  @override
  String get checkInActivity => 'என்ன செய்கிறாய்?';

  @override
  String get checkInNote => 'அதைப் பற்றிய ஒரு வரி (விரும்பினால்)';

  @override
  String get checkInSave => 'சேமிக்கவும்';

  @override
  String editorWordCount(int words, int characters) {
    return '$words வார்த்தைகள் · $characters எழுத்துக்கள்';
  }

  @override
  String get coachProgramEverydayTagline =>
      'ஒரு நாளில் சிறிய விஷயங்களைக் கவனியுங்கள்.';

  @override
  String get coachProgramReflectTagline => 'மெதுவாக நீங்களே கேளுங்கள்.';

  @override
  String get coachDuration => 'கால அளவு';

  @override
  String get coachInterval => 'இடைவெளி';

  @override
  String get coachDifficulty => 'சிரமம்';

  @override
  String get coachIntervalDaily => 'தினசரி';

  @override
  String get coachIntervalWeekly => 'வாரந்தோறும்';

  @override
  String get coachDifficultyBeginner => 'ஆரம்பநிலை';

  @override
  String get coachDifficultyIntermediate => 'இடைநிலை';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count நாட்கள்',
      one: '$count நாள்',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count வாரங்கள்',
      one: '$count வாரம்',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'நாள் $n';
  }

  @override
  String coachWeekN(int n) {
    return 'வாரம் $n';
  }

  @override
  String get coachEnroll => 'பதிவு செய்யுங்கள்';

  @override
  String get coachEndProgram => 'நிரலை முடிக்கவும்';

  @override
  String get coachAuthor => 'ஆசிரியர்';

  @override
  String get coachAuthorBio =>
      'இந்த பயன்பாட்டிற்காக எழுதப்பட்ட அறிவுறுத்தல்கள்.';

  @override
  String get coachEnrolledTip =>
      'எல்லாம் தயார்! உங்கள் கேள்விகள் கதைகளில் காண்பிக்கப்படும்.';

  @override
  String get coachGoToStories => 'கதைகளுக்கு செல்க';

  @override
  String get coachAnswerHint => 'உங்கள் பதிலை எழுதுங்கள்...';

  @override
  String get storyWrapUp => 'இன்னைக்கு அவ்வளவுதான்.';

  @override
  String get storyTapToClose => 'மூடுவதற்கு தட்டவும்';

  @override
  String get coachAnswerDone => 'முடிந்தது';

  @override
  String get coachAnswered => 'பதில், திறக்க தட்டவும்';

  @override
  String get coachAnsweredEarlier => 'பதிலளித்தார்';

  @override
  String get locationLocating => 'இருப்பிடம்…';

  @override
  String get locationPickPlace => 'ஒரு இடத்தைத் தேர்ந்தெடுங்கள்';

  @override
  String get locationPlacesHint => 'முகவரி அல்லது இடத்தின் பெயர்';

  @override
  String get locationCustom => 'விருப்ப இடம்';

  @override
  String get locationCurrent => 'தற்போதைய இடம்';

  @override
  String get locationSaved => 'சேமிக்கப்பட்ட இடங்கள்';

  @override
  String get locationSearchResults => 'தேடல் முடிவுகள்';

  @override
  String get locationNearby => 'அருகிலுள்ள இடங்கள்';

  @override
  String get locationRename => 'மறுபெயரிடவும்';

  @override
  String get locationSavePlace => 'இடத்தை சேமிக்கவும்';

  @override
  String get locationUnsavePlace => 'சேமித்த இடங்களிலிருந்து அகற்று';

  @override
  String get shareAs => 'இவ்வாறு பகிரவும்…';

  @override
  String get shareAsImage => 'படம்';

  @override
  String get shareAsZip => 'அசல் மீடியாவுடன் ZIP';

  @override
  String get shareAsPlainText => 'எளிய உரை';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'AID Diary க்கு வரவேற்கிறோம்';

  @override
  String get onboardWelcomeText =>
      'இங்கே தொடங்கவும் அல்லது நீங்கள் ஏற்கனவே பயன்படுத்தும் சாதனத்துடன் இந்தச் சாதனத்தை இணைக்கவும்.';

  @override
  String get onboardStart => 'எழுத ஆரம்பியுங்கள்';

  @override
  String get helpFaq => 'அடிக்கடி கேட்கப்படும் கேள்விகள்';

  @override
  String get helpFaq1Q => 'எனது நாட்குறிப்பு எங்கே சேமிக்கப்பட்டுள்ளது?';

  @override
  String get helpFaq1A =>
      'உங்கள் நாட்குறிப்பு இந்த சாதனத்தில் சேமிக்கப்பட்டுள்ளது. நீங்கள் அதை ஒத்திசைத்தல், பகிர்தல் அல்லது ஏற்றுமதி செய்யும் போது மட்டுமே இது மற்ற சாதனங்கள் அல்லது சேமிப்பகத்தை அடையும். ஒத்திசைவு எண்ட்-டு-எண்ட் என்க்ரிப்ட் செய்யப்பட்டுள்ளது.';

  @override
  String get helpFaq2Q =>
      'ஒரு நகலை வைத்திருப்பது அல்லது புதிய சாதனத்திற்கு நகர்த்துவது எப்படி?';

  @override
  String get helpFaq2A =>
      'அமைப்புகள் → தரவு & சேமிப்பிடம் → ஒத்திசைவில் இருக்கும் சாதனத்துடன் இணைக்கவும் மற்றும் உங்கள் நாட்குறிப்பைக் கொண்ட சாதனத்தில் அங்கீகாரத்தை உறுதிப்படுத்தவும். இரண்டு சாதனங்களும் பயன்படுத்தக்கூடியதாக இருக்கும். நீங்கள் காப்புப்பிரதியை உருவாக்கி அதை மற்றொரு சாதனத்தில் மீட்டெடுக்கலாம்.';

  @override
  String get helpFaq3Q =>
      'பிற டைரி பயன்பாடுகளிலிருந்து உள்ளீடுகளை நான் கொண்டு வர முடியுமா?';

  @override
  String get helpFaq3A =>
      'ஆம்: அமைப்புகள் → தரவு & சேமிப்பகத்தில், Daylio, Diarium, Diaro, DayBook, My Brain, OneShot மற்றும் Pixels அல்லது JSON ஏற்றுமதியிலிருந்து ஏற்றுமதிகளை இறக்குமதி செய்யவும்.';

  @override
  String get helpFaq4Q => 'பயிற்சியாளர் திட்டங்கள் எவ்வாறு செயல்படுகின்றன?';

  @override
  String get helpFaq4A =>
      'பயிற்சியாளர் பக்கத்தில் உள்ள திட்டத்தில் பதிவு செய்யவும். ஒவ்வொரு நாளும் அல்லது வாரமும் ஒரு புதிய கேள்வி கதைகளில் காத்திருக்கிறது; உங்கள் பதில் ஒரு பதிவாக சேமிக்கப்பட்டது.';

  @override
  String get helpFaq5Q => 'எனது கடவுக்குறியீட்டை மறந்துவிட்டால் என்ன செய்வது?';

  @override
  String get helpFaq5A =>
      'கடவுக்குறியீட்டை மீட்டெடுக்க முடியாது, எனவே உங்கள் நாட்குறிப்பின் காப்புப்பிரதியை வைத்திருங்கள்.';

  @override
  String get helpPrivacy => 'தனியுரிமை';

  @override
  String get helpPrivacyText =>
      'குறியாக்கப்பட்ட ஒத்திசைவை இயக்கும் வரை அல்லது அவற்றைப் பகிர/ஏற்றுமதி செய்யாத வரை, டைரி உள்ளடக்கமும் மீடியாவும் இந்தச் சாதனத்தில் இருக்கும். வரைபடங்கள், இடத் தேடல் மற்றும் வானிலை ஆகியவை உள்ளமைக்கப்பட்ட சேவைகளைப் பயன்படுத்துகின்றன, மேலும் அந்த கோரிக்கைக்கு தேவையான இடம் அல்லது தேடல் வினவலை அனுப்பவும், டைரி உரை அல்ல.';

  @override
  String get photoMetaTitle => 'புகைப்படத்தின் விவரங்களைப் பயன்படுத்தவா?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return '$dateக்கான இந்தப் பதிவை எண்ணி அதன் இடத்தை $place என அமைக்கவும், புகைப்படத்தில் பதிவு செய்யப்பட்டுள்ளதா?';
  }

  @override
  String photoMetaDate(String date) {
    return '$date, புகைப்படம் எப்போது எடுக்கப்பட்டது என்று இந்த பதிவை எண்ணவா?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'இந்தப் பதிவின் இடத்தை $place என அமைக்கவா, புகைப்படம் எடுக்கப்பட்ட இடமா?';
  }

  @override
  String get photoMetaApply => 'அவற்றைப் பயன்படுத்துங்கள்';

  @override
  String get quickWriteTitle => 'சீக்கிரம் எழுது';

  @override
  String get quickWriteText => 'புதிய பதிவைத் தொடங்க தட்டவும்.';

  @override
  String get settingsQuickWriteTitle => 'அறிவிப்புகளில் விரைவாக எழுதுங்கள்';

  @override
  String get settingsQuickWriteDescription =>
      'புதிய நுழைவைத் திறக்கும் அறிவிப்பை வைத்திருங்கள்.';

  @override
  String get settingsNudgesTitle =>
      'அமைதியான நீட்சிக்குப் பிறகு என்னைத் தள்ளுங்கள்';

  @override
  String settingsNudgesDescription(int days) {
    return '$days நாட்களாக நீங்கள் எழுதாத போது ஒரு மென்மையான நினைவூட்டல்.';
  }

  @override
  String get nudgeTitle => 'கொஞ்ச நேரம் ஆகிவிட்டது';

  @override
  String get nudgeMonday =>
      'ஒரு புதிய வாரம்: நீங்கள் எதை எதிர்பார்க்கிறீர்கள்?';

  @override
  String get nudgeTuesday =>
      'இரண்டு வரிகள் போதும். இன்று எப்படி இருக்கிறீர்கள்?';

  @override
  String get nudgeWednesday => 'வாரத்தின் பாதி. இதுவரை தனித்து நின்றது எது?';

  @override
  String get nudgeThursday =>
      'இன்றிலிருந்து ஏதாவது சிறியதாக வைத்திருக்க முடியுமா?';

  @override
  String get nudgeFriday =>
      'வாரம் நிறைவடைகிறது. ஒரு நல்ல தருணத்தைக் கவனியுங்கள்.';

  @override
  String get nudgeSaturday => 'மெதுவான சனிக்கிழமை எழுதுவதற்கு நல்ல நாள்.';

  @override
  String get nudgeSunday =>
      'அது முடிவதற்கு முந்தைய வாரத்தைத் திரும்பிப் பாருங்கள்.';

  @override
  String get photoWidgetEmpty =>
      'உள்ளீடுகளில் நீங்கள் சேர்க்கும் புகைப்படங்கள் இங்கே காட்டப்படும்.';

  @override
  String get channelReminders => 'நினைவூட்டல்கள்';

  @override
  String get channelOnThisDay => 'இந்த நாளில்';

  @override
  String get channelCoach => 'பயிற்சியாளர் கேட்கிறார்';

  @override
  String get channelNudges => 'அமைதியான நாட்களுக்குப் பிறகு அசைகிறது';

  @override
  String get channelQuickWrite => 'சீக்கிரம் எழுது';

  @override
  String get channelBackup => 'காப்புப்பிரதிகள்';

  @override
  String get formatJsonExport => 'JSON (AID Diary ஏற்றுமதி)';

  @override
  String get aboutModifiedNotice =>
      'டெமிசோ மற்றும் பங்களிப்பாளர்களால் டெய்லி யூவின் மாற்றியமைக்கப்பட்ட பதிப்பு. இது அதிகாரப்பூர்வ டெய்லி யூ ஆப் அல்ல.';

  @override
  String get toolbarPhotos => 'புகைப்படங்களைச் சேர்க்கவும்';

  @override
  String get toolbarMedia => 'புகைப்படங்கள் மற்றும் வீடியோக்கள்';

  @override
  String get mediaFromGallery => 'கேலரியில் இருந்து தேர்வு செய்யவும்';

  @override
  String get mediaFromFiles => 'கோப்புகளிலிருந்து தேர்வு செய்யவும்';

  @override
  String get editorLeaveTitle => 'இந்த பதிவை சேமிக்கவா?';

  @override
  String get editorLeaveDiscard => 'சேமிக்க வேண்டாம்';

  @override
  String get editorTitleHint => 'தலைப்பு';

  @override
  String get editorLocating => 'இருப்பிடம்…';

  @override
  String get toolbarVideo => 'வீடியோ';

  @override
  String get toolbarAudio => 'குரல் குறிப்பு';

  @override
  String get toolbarTags => 'குறிச்சொற்கள்';

  @override
  String get toolbarBulletList => 'பொட்டுக்குறியிடப்பட்ட பட்டியல்';

  @override
  String get toolbarHeading => 'தலைப்பு';

  @override
  String get toolbarBold => 'தடித்த';

  @override
  String get toolbarItalic => 'சாய்வு';

  @override
  String get toolbarHighlight => 'முன்னிலைப்படுத்தவும்';

  @override
  String get toolbarStrikethrough => 'வேலைநிறுத்தம்';

  @override
  String get toolbarQuote => 'மேற்கோள்';

  @override
  String get toolbarLink => 'இணைப்பு';

  @override
  String get toolbarInsert => 'செருகு';

  @override
  String get toolbarUndo => 'செயல்தவிர்';

  @override
  String get toolbarRedo => 'மீண்டும் செய்';

  @override
  String get toolbarInsertDate => 'தேதியைச் செருகவும்';

  @override
  String get toolbarInsertTime => 'நேரத்தைச் செருகவும்';

  @override
  String get settingsSyncTitle => 'கிளவுட் ஒத்திசைவு';

  @override
  String get syncOffDescription =>
      'Google Drive அல்லது Nextcloud, Synology அல்லது Jianguoyun போன்ற WebDAV சேவையகம் மூலம் உங்கள் எல்லா சாதனங்களிலும் இந்த நாட்குறிப்பை ஒரே மாதிரியாக வைத்திருங்கள்.';

  @override
  String get syncUseGoogleDrive => 'Google Drive உடன் ஒத்திசைக்கவும்';

  @override
  String get syncOrWebDav => 'அல்லது WebDAV சர்வர்';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn =>
      'உள்நுழைந்துள்ளீர்கள். நீங்கள் மீண்டும் AID Diary க்கு செல்லலாம்.';

  @override
  String get syncGoogleSignInAgain =>
      'Google நீங்கள் மீண்டும் உள்நுழைய வேண்டும்.';

  @override
  String get syncSignInAgain => 'மீண்டும் உள்நுழையவும்';

  @override
  String get settingsCommandLineTitle => 'கட்டளை வரி';

  @override
  String get commandLineToggle => 'கட்டளை வரி இடைமுகம்';

  @override
  String get commandLineToggleHint =>
      'இந்தச் சாதனத்தில் உள்ள உதவி கட்டளை மற்றும் பிற நிரல்களை பயன்பாட்டின் கட்டளைகளைப் பயன்படுத்த அனுமதிக்கிறது.';

  @override
  String get commandLineAlwaysOn => 'எப்போதும் வளர்ச்சியில் உள்ளது.';

  @override
  String commandLineListening(int port) {
    return '$port போர்ட்டில் கேட்கிறது';
  }

  @override
  String get commandPaletteTitle => 'அனைத்து கட்டளைகளும்';

  @override
  String get commandPaletteSearch => 'தேடல் கட்டளைகள்';

  @override
  String get commandPaletteRun => 'ஓடவும்';

  @override
  String get commandPaletteConfirm =>
      'இதை வெறுமனே செயல்தவிர்க்க முடியாது. அதை இயக்கவா?';

  @override
  String syncReceiving(int done, int total) {
    return '$total இன் $done ஐப் பெறுகிறது…';
  }

  @override
  String syncSending(int done, int total) {
    return '$total இன் $done ஐ அனுப்புகிறது…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'Google Drive க்கான அணுகல் அனுமதிக்கப்படவில்லை. மீண்டும் இணைத்து, கூகுளின் பக்கத்தில் Google Drive என்பதை டிக் செய்யவும்.';

  @override
  String get syncEntryUnsynced =>
      'ஒத்திசைக்கப்படவில்லை: கடைசி ஒத்திசைவு செல்லவில்லை';

  @override
  String get syncUseOfficial => 'AID ஒத்திசைவு சேவையகத்தைப் பயன்படுத்தவும்';

  @override
  String get syncServer => 'சேவையக முகவரி';

  @override
  String get syncUsername => 'பயனர் பெயர்';

  @override
  String get syncPassword => 'கடவுச்சொல்';

  @override
  String get syncConnect => 'இணைக்கவும்';

  @override
  String get syncConnecting => 'இணைக்கிறது…';

  @override
  String get syncSignInFailed =>
      'உள்நுழைய முடியவில்லை. முகவரி, பயனர்பெயர் மற்றும் கடவுச்சொல்லைச் சரிபார்க்கவும்.';

  @override
  String syncConnectFailed(String error) {
    return 'இணைக்க முடியவில்லை: $error';
  }

  @override
  String get syncNewSpaceTitle => 'ஒத்திசைக்கத் தொடங்குங்கள்';

  @override
  String get syncNewSpaceDescription =>
      'இங்கு இதுவரை ஒத்திசைக்கப்பட்ட டைரி எதுவும் இல்லை. இந்த நாட்குறிப்பு பதிவேற்றப்படும், உங்கள் சாதனங்களில் இருக்கும் ஒரு விசையுடன் இறுதி முதல் இறுதி வரை குறியாக்கம் செய்யப்படும்.';

  @override
  String get syncJoinTitle => 'ஒத்திசைக்கப்பட்ட நாட்குறிப்பில் சேரவும்';

  @override
  String get syncWrongKey =>
      'இந்த மீட்புக் குறியீடு ஒத்திசைக்கப்பட்ட டைரியைத் திறக்காது.';

  @override
  String syncLastSynced(String time) {
    return 'கடைசியாக ஒத்திசைக்கப்பட்டது $time';
  }

  @override
  String get syncNever => 'இன்னும் ஒத்திசைக்கப்படவில்லை';

  @override
  String get syncSyncing => 'ஒத்திசைக்கிறது...';

  @override
  String syncFailed(String error) {
    return 'கடைசி ஒத்திசைவு தோல்வியடைந்தது: $error';
  }

  @override
  String get syncLocked =>
      'ஒத்திசைக்கப்பட்ட நாட்குறிப்பு இப்போது பிற சாதனங்களுக்கு சொந்தமானது அல்லது தொடங்கப்பட்டது. ஒத்திசைவைத் தொடர, அவற்றில் ஒன்றை இணைக்கவும் அல்லது மீட்புக் குறியீட்டைப் பயன்படுத்தவும்.';

  @override
  String get syncNow => 'இப்போது ஒத்திசைக்கவும்';

  @override
  String get syncUnlock => 'திறக்கவும்';

  @override
  String get syncEncrypted => 'எண்ட்-டு-எண்ட் என்க்ரிப்ட் செய்யப்பட்டது';

  @override
  String get syncDisconnect => 'ஒத்திசைப்பதை நிறுத்து';

  @override
  String get syncDisconnectDescription =>
      'இந்தச் சாதனம் ஒத்திசைப்பதை நிறுத்துகிறது. இங்குள்ள நாட்குறிப்பும் ஒத்திசைக்கப்பட்ட பிரதியும் அப்படியே இருக்கும்.';

  @override
  String get syncOwnRecoveryPassword =>
      'எனது சொந்த மீட்பு கடவுச்சொல்லைப் பயன்படுத்தவும்';

  @override
  String get syncRecoveryPassword => 'மீட்பு கடவுச்சொல்';

  @override
  String get syncRecoveryPasswordRepeat =>
      'மீட்பு கடவுச்சொல்லை மீண்டும் செய்யவும்';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'குறைந்தது $min எழுத்துகளைப் பயன்படுத்தவும்';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'கடவுச்சொற்கள் வேறுபடுகின்றன';

  @override
  String get syncRecoveryCode => 'மீட்பு குறியீடு';

  @override
  String get syncRecoveryCodeTitle =>
      'உங்கள் மீட்புக் குறியீட்டைச் சேமிக்கவும்';

  @override
  String get syncRecoveryCodeDescription =>
      'உங்களுடைய ஒவ்வொரு சாதனமும் தொலைந்துவிட்டால், இந்தக் குறியீடு உங்கள் ஒத்திசைக்கப்பட்ட டைரியை மீட்டெடுக்கும். கடவுச்சொல் மேலாளரில் அல்லது காகிதத்தில் வைக்கவும். இது ஒரு முறை மட்டுமே காட்டப்படுகிறது.';

  @override
  String get syncRecoveryCodeCopied => 'மீட்பு குறியீடு நகலெடுக்கப்பட்டது';

  @override
  String get syncRecoveryCodeSaved => 'நான் சேமித்து விட்டேன்';

  @override
  String get syncJoinNeedsKey =>
      'இந்த ஒத்திசைக்கப்பட்ட நாட்குறிப்பு உங்கள் பிற சாதனங்களுக்கு சொந்தமானது. அவற்றில் ஒன்றை இணைக்கவும் அல்லது மீட்புக் குறியீட்டைப் பயன்படுத்தவும். இந்தச் சாதனத்தில் உள்ள உள்ளீடுகள் அதில் சேர்க்கப்படும்.';

  @override
  String get syncPairDevice => 'சாதனத்துடன் இணைக்கவும்';

  @override
  String get syncUseRecoveryCode => 'மீட்புக் குறியீட்டைப் பயன்படுத்தவும்';

  @override
  String get syncAddDevice => 'சாதனத்தைச் சேர்க்கவும்';

  @override
  String get syncChangeRecoveryCode => 'மீட்பு குறியீட்டை மாற்றவும்';

  @override
  String get syncChangeRecoveryDescription =>
      'தற்போதைய குறியீட்டை புதிய குறியீடு மாற்றுகிறது, இது வேலை செய்வதை நிறுத்துகிறது. உங்கள் தரவு மற்றும் பிற சாதனங்கள் அப்படியே இருக்கும்.';

  @override
  String get syncNewRandomCode => 'புதிய சீரற்ற குறியீடு';

  @override
  String get syncRecoveryCodeChanged => 'மீட்பு குறியீடு மாற்றப்பட்டது';

  @override
  String get syncResetSpace =>
      'ஒத்திசைக்கப்பட்ட நாட்குறிப்பை மீண்டும் தொடங்கவும்';

  @override
  String get syncResetSpaceDescription =>
      'சாதனம் மற்றும் மீட்டெடுப்பு குறியீடு எதுவும் திறக்கப்படாவிட்டால் மட்டுமே: ஒத்திசைக்கப்பட்ட நகலானது இந்தச் சாதனத்தில் உள்ள டைரியால் இந்தச் சாதனத்தின் விசைகளுக்குப் பதிலாக மாற்றப்படும். உங்கள் மற்ற சாதனங்கள் மீண்டும் இணைக்கவும்.';

  @override
  String get syncPairTitle => 'சாதனங்களை இணைக்கவும்';

  @override
  String get syncPairShow => 'குறியீட்டைக் காட்டு';

  @override
  String get syncPairEnter => 'குறியீட்டை உள்ளிடவும்';

  @override
  String get syncPairShowHint =>
      'உங்கள் மற்றொரு சாதனத்தில், ஜோடி சாதனங்களைத் திறந்து, குறியீட்டை உள்ளிடவும் என்பதைத் தேர்வுசெய்து, தட்டச்சு செய்யவும் அல்லது ஸ்கேன் செய்யவும்.';

  @override
  String get syncPairEnterHint =>
      'உங்கள் மற்ற சாதனம் காட்டும் குறியீட்டை உள்ளிடவும் அல்லது ஸ்கேன் செய்யவும்.';

  @override
  String get syncPairCode => 'இணைத்தல் குறியீடு';

  @override
  String get syncPairScan => 'ஸ்கேன் செய்யவும்';

  @override
  String get syncPairStart => 'ஜோடி';

  @override
  String get syncPairWaiting => 'மற்ற சாதனத்திற்காகக் காத்திருக்கிறது…';

  @override
  String syncPairDone(String device) {
    return '$device உடன் இணைக்கப்பட்டது';
  }

  @override
  String get syncPairWrongCode =>
      'குறியீடு பொருந்தவில்லை. புதிய குறியீட்டைக் காட்டி மீண்டும் முயலவும்.';

  @override
  String get syncPairNoOffer =>
      'எந்த சாதனமும் இந்தக் குறியீட்டைக் காட்டாது. அது காலாவதியாகியிருக்கலாம்.';

  @override
  String get syncPairTimedOut =>
      'மற்ற சாதனம் சரியான நேரத்தில் பதிலளிக்கவில்லை.';

  @override
  String get syncPairNeither =>
      'இந்த ஒத்திசைக்கப்பட்ட டைரியுடன் எந்த சாதனமும் இன்னும் அமைக்கப்படவில்லை.';

  @override
  String get syncPairBoth =>
      'இரண்டு சாதனங்களும் ஏற்கனவே இந்த ஒத்திசைக்கப்பட்ட டைரியைத் திறக்கின்றன.';

  @override
  String syncPairFailed(String error) {
    return 'இணைத்தல் தோல்வி: $error';
  }

  @override
  String get syncMediaPending =>
      'டைரி ஒத்திசைக்கப்பட்டது · சில மீடியாக்கள் இன்னும் மாற்றப்படுகின்றன';

  @override
  String get syncWaitingForDevices =>
      'டைரி ஒத்திசைக்கப்பட்டது · மீடியாவை மாற்ற மற்றொரு சாதனம் காத்திருக்கிறது';

  @override
  String get syncCacheNotice =>
      'கிளவுட் மீடியா தற்காலிகமானது. உங்கள் சாதனங்களில் அசல்களை வைத்திருங்கள்; ஒத்திசைவு என்பது காப்புப்பிரதி அல்ல.';

  @override
  String get paperTitle => 'கடிதத் தாள்';

  @override
  String get paperPlain => 'வெற்று';

  @override
  String get paperLined => 'வரிசையாக';

  @override
  String get paperGrid => 'கட்டம்';

  @override
  String get paperTinted => 'சாயம் பூசப்பட்டது';

  @override
  String get paperDecorationTitle => 'அலங்காரங்கள்';

  @override
  String get paperDecorationNone => 'இல்லை';

  @override
  String get paperDecorationBotanical => 'இலைகள்';

  @override
  String get paperDecorationStars => 'நட்சத்திரங்கள்';

  @override
  String get paperDecorationWashi => 'வாஷி டேப்';

  @override
  String get themeDarkChoice => 'இருண்ட தோற்றம்';

  @override
  String get themeDarkSame => 'ஒளி தட்டுகளைப் பின்பற்றவும்';

  @override
  String get themeDarkCustom => 'தனி தட்டு';

  @override
  String get themeDarkAccent => 'அடர் உச்சரிப்பு நிறம்';

  @override
  String get themeColorTeal => 'டீல்';

  @override
  String get themeColorCyan => 'சியான்';

  @override
  String get themeColorIndigo => 'இண்டிகோ';

  @override
  String get themeColorCoral => 'பவளம்';

  @override
  String get themeColorOlive => 'ஆலிவ்';

  @override
  String get themeColorSlate => 'ஸ்லேட்';

  @override
  String get drawingTitle => 'வரைதல்';

  @override
  String get drawingPen => 'பேனா';

  @override
  String get drawingEraser => 'அழிப்பான்';

  @override
  String get drawingUndo => 'செயல்தவிர்';

  @override
  String get drawingClear => 'தெளிவு';

  @override
  String get drawingWidth => 'பேனா அகலம்';

  @override
  String get drawingStylusOnly => 'ஸ்டைலஸ் மட்டும்';

  @override
  String get drawingDiscardTitle => 'வரைவதை நிராகரிக்கவா?';

  @override
  String get drawingDiscardBody => 'இந்த வரைதல் சேமிக்கப்படவில்லை.';

  @override
  String get drawingSaveError => 'வரைபடத்தைச் சேமிக்க முடியவில்லை.';

  @override
  String get syncNetworkTitle => 'நெட்வொர்க் கண்டறிதல்';

  @override
  String get syncNetworkRefresh => 'புதுப்பிக்கவும்';

  @override
  String get syncNetworkSelectedRoute => 'தற்போதைய பாதை';

  @override
  String get syncNetworkAvailableRoutes => 'கிடைக்கும் பாதைகள்';

  @override
  String get syncNetworkSignaling => 'சாதன அடைவு இணைப்பு';

  @override
  String get syncNetworkRelayRemaining => 'மீதமுள்ள ரிலே கொடுப்பனவு';

  @override
  String get syncNetworkIcePair => 'நேரடி இணைப்பு வேட்பாளர்கள்';

  @override
  String get syncNetworkPeerTrusted => 'அங்கீகரிக்கப்பட்ட சாதனம்';

  @override
  String get syncNetworkNoRoute => 'இணைப்புக்காகக் காத்திருக்கிறது';

  @override
  String get syncNetworkUnavailable => 'நோய் கண்டறிதல் கிடைக்கவில்லை';

  @override
  String get syncMediaCopiesTitle => 'மீடியா டெலிவரி மற்றும் பிரதிகள்';

  @override
  String get syncMediaPendingCount => 'பரிமாற்றத்திற்காக காத்திருக்கிறது';

  @override
  String get syncMediaDurableCount =>
      'தனிப்பட்ட சேமிப்பகத்திற்கு வழங்கப்பட்டது';

  @override
  String get syncMediaTemporaryCount =>
      'தற்காலிக அல்லது உறுதிப்படுத்தப்படாத பிரதிகள்';

  @override
  String get syncMediaReceiptExplanation =>
      'இந்த எண்ணிக்கைகள் முடிந்த டெலிவரிகளை விவரிக்கின்றன, உயிர்வாழும் காப்புப்பிரதிகளின் புதிய தணிக்கை அல்ல.';

  @override
  String get syncMediaCacheExplanation =>
      'தற்காலிக கிளவுட் மீடியா காலாவதியாகலாம். உங்கள் அசல் அல்லது தனி காப்புப்பிரதியை வைத்திருங்கள்.';

  @override
  String get momentsTitle => 'புகைப்பட தருணங்கள்';

  @override
  String get momentsHint =>
      'உள்ளூர் புகைப்பட நேரங்கள் மற்றும் விருப்ப ஆயங்களைப் பயன்படுத்தி குழுக்களைக் கண்டறியவும். நீங்கள் கார்டைத் தேர்ந்தெடுக்கும்போது மட்டுமே புகைப்படங்கள் இணைக்கப்படும்.';

  @override
  String get momentsScan => 'தருணங்களைக் கண்டறியவும்';

  @override
  String get momentsChooseFolder => 'புகைப்படக் கோப்புறையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get momentsLocation => 'புகைப்பட இடங்களைச் சேர்க்கவும்';

  @override
  String get momentsEmpty => 'சமீபத்திய புகைப்படக் குழுக்கள் இல்லை.';

  @override
  String get momentsCreate => 'இந்த புகைப்படங்களைப் பற்றி எழுதுங்கள்';

  @override
  String get momentsDismiss => 'நிராகரி';

  @override
  String get momentsError => 'உள்ளூர் புகைப்படங்களைப் படிக்க முடியவில்லை.';

  @override
  String get momentsCreated => 'புகைப்பட உள்ளீடு உருவாக்கப்பட்டது.';

  @override
  String get momentsPermission =>
      'உள்ளூர் பரிந்துரைகளைக் கண்டறிய புகைப்படங்களுக்கான அணுகலை அனுமதிக்கவும்.';

  @override
  String get momentsScope =>
      'சமீபத்திய புகைப்படங்கள் மட்டும்; ஒரு கார்டுக்கு அதிகபட்சம் 500 புகைப்படங்கள் மற்றும் 20 புகைப்படங்கள்.';

  @override
  String momentsPhotoCount(int count) {
    return '$count புகைப்படங்கள்';
  }

  @override
  String get nearbyTitle => 'சாதனங்களை இணைக்கவும்';

  @override
  String get nearbySend => 'மற்றொரு சாதனத்தை அங்கீகரிக்கவும்';

  @override
  String get nearbyReceive => 'ஏற்கனவே உள்ள சாதனத்துடன் இணைக்கவும்';

  @override
  String get nearbyInstructions =>
      'இரண்டு சாதனங்களையும் ஒரே Wi-Fi அல்லது ஒன்றின் ஹாட்ஸ்பாட்டுடன் இணைக்கவும். ஏற்கனவே உள்ள சாதனத்தில் அங்கீகாரத்தை உறுதிப்படுத்தவும்; இரண்டு சாதனங்களும் பயன்படுத்தக்கூடியதாக இருக்கும். இணையம் தேவையில்லை.';

  @override
  String get nearbyCompare =>
      'ஒப்புதலளிக்கும் முன் இரு சாதனங்களிலும் இந்தக் குறியீட்டை ஒப்பிடவும்.';

  @override
  String get nearbyConfirm => 'குறியீடுகள் பொருந்துகின்றன';

  @override
  String get nearbyScan => 'மற்ற சாதனத்தின் குறியீட்டை ஸ்கேன் செய்யவும்';

  @override
  String get nearbyPaste => 'அழைப்பிதழை ஒட்டவும்';

  @override
  String get nearbyWaiting => 'மற்ற சாதனத்தில் ஒப்புதலுக்காகக் காத்திருக்கிறது';

  @override
  String get nearbyWorking =>
      'உங்கள் நாட்குறிப்பு மற்றும் இணைப்புகளை அங்கீகரிக்கிறது மற்றும் ஒத்திசைக்கிறது…';

  @override
  String get nearbyPending =>
      'சில இணைப்புகளை இன்னும் ஒத்திசைக்க வேண்டும். மற்ற சாதனத்தை ஆன்லைனில் வைத்து மீண்டும் முயலவும்.';

  @override
  String get nearbyComplete =>
      'சாதனம் இணைக்கப்பட்டுள்ளது; டைரி மற்றும் இணைப்புகள் ஒத்திசைக்கப்பட்டது';

  @override
  String get nearbyFailed =>
      'இணைப்பு முடிவடையவில்லை. உள்ளூர் இணைப்பைச் சரிபார்த்து மீண்டும் முயலவும்.';

  @override
  String get nearbyEmptyRequired =>
      'இன்னும் ஒத்திசைக்க இணைக்கப்படாத வெற்று நாட்குறிப்பைக் கொண்ட சாதனத்தைப் பயன்படுத்தவும்.';

  @override
  String get nearbyRetry => 'ஒத்திசைவைத் தொடரவும்';

  @override
  String get nearbyWifi => 'Wi-Fi அமைப்புகள்';

  @override
  String get nearbyHotspot => 'ஹாட்ஸ்பாட் அமைப்புகள்';

  @override
  String get nearbyKeepOpen =>
      'புதிய சாதனம் முடியும் வரை இந்தப் பக்கத்தைத் திறந்து வைக்கவும். இரண்டு நிமிடங்களுக்குப் பிறகு அழைப்பிதழ் காலாவதியாகிறது.';

  @override
  String get syncDevicesTitle => 'அங்கீகரிக்கப்பட்ட சாதனங்கள்';

  @override
  String get syncDevicesDescription =>
      'அங்கீகரிக்கப்பட்ட சாதனங்கள் மட்டுமே இந்த AID கணக்கை அணுக முடியும். சாதனத்தைத் திரும்பப் பெறுவது சேவையகத்தைத் தடுக்கிறது, ஆனால் ஏற்கனவே நகலெடுக்கப்பட்ட முதன்மை விசை அல்லது நாட்குறிப்பை அழிக்க முடியாது.';

  @override
  String get syncDeviceRequest =>
      'அங்கீகரிக்கப்பட்ட சாதனத்தில் இந்த அங்கீகார QRஐக் காட்டு';

  @override
  String get syncDeviceAuthorize => 'ஒரு சாதனத்தை அங்கீகரிக்கவும்';

  @override
  String get syncDeviceAuthorizeDescription =>
      'புதிய சாதனத்தின் அங்கீகார கோரிக்கையை ஸ்கேன் செய்யவும் அல்லது ஒட்டவும்.';

  @override
  String get syncDeviceRevoke => 'திரும்பப் பெறு';

  @override
  String get syncDeviceRotate => 'இந்தச் சாதனத்தின் கையொப்ப விசையைச் சுழற்று';

  @override
  String get syncDeviceCheck => 'அங்கீகாரத்தை சரிபார்க்கவும்';

  @override
  String get syncDeviceHardware => 'வன்பொருள் ஆதரவு கையொப்ப விசை';

  @override
  String get syncDeviceSoftware =>
      'ஏற்றுமதி செய்ய முடியாத மென்பொருள் கையொப்ப விசை';

  @override
  String get syncDeviceUnavailable =>
      'சாதன அங்கீகாரம் கிடைக்கவில்லை. அங்கீகரிக்கப்பட்ட மற்றொரு சாதனத்திலிருந்து இந்தச் சாதனத்தை அனுமதித்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get syncDeviceRevoked => 'ரத்து செய்யப்பட்டது';

  @override
  String get syncDeviceLocal => 'இந்த சாதனம்';

  @override
  String get cloudTrafficTitle =>
      'மீடியா கோப்புகளுக்கான மாதாந்திர கிளவுட் தரவு பரிமாற்ற ஒதுக்கீடு';

  @override
  String get cloudTrafficLimit => 'மாதாந்திர தரவு பரிமாற்ற ஒதுக்கீடு';

  @override
  String get cloudTrafficUsed => 'தரவு பரிமாற்றம் பயன்படுத்தப்பட்டது';

  @override
  String get cloudTrafficRemaining => 'தரவு பரிமாற்றம் மீதமுள்ளது';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'தரவு பரிமாற்ற ஒதுக்கீடு $time ஐ மீட்டமைக்கிறது';
  }

  @override
  String get cloudTrafficExhausted =>
      'மீடியா கோப்புகளுக்கான கிளவுட் தரவு பரிமாற்ற ஒதுக்கீடு பயன்படுத்தப்பட்டது. நேரடி இணைப்பு கிடைக்கும்போது அல்லது ஒதுக்கீடு மீட்டமைக்கப்படும்போது விடுபட்ட மீடியா கோப்புகள் தானாகவே ஒத்திசைக்கப்படும்.';

  @override
  String get cloudTrafficExplanation =>
      'மீடியா கோப்பு கேச்சிங் மற்றும் லைவ் ரிலே இந்த தரவு பரிமாற்ற ஒதுக்கீட்டைப் பகிர்ந்து கொள்கின்றன. நேரடி இணைப்புகள் அதைப் பயன்படுத்துவதில்லை. நாட்குறிப்பு உரை மற்றும் இணைப்பு கட்டுப்பாட்டு செய்திகளுக்கு தனித்தனி சிறிய தினசரி வரம்புகள் உள்ளன.';

  @override
  String get appearanceThemeSection => 'பயன்பாட்டு தீம்';

  @override
  String get appearancePaperSection => 'டைரி பேப்பர்';

  @override
  String get appearanceTypographySection => 'நாட்குறிப்பு உரை';

  @override
  String get appearancePreferencesSection => 'பொதுவான விருப்பத்தேர்வுகள்';

  @override
  String get themeSystemAccentHint =>
      'தனிப்பயன் வண்ணங்களுக்குப் பதிலாக கணினி தட்டுகளைப் பயன்படுத்துகிறது. உங்களுடையதைத் தேர்வுசெய்ய அதை அணைக்கவும்.';

  @override
  String get syncDeviceNameSaveFailed =>
      'சாதனத்தின் பெயரைச் சேமிக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get nearbyConnectionHelp => 'இணைப்பு உதவி';

  @override
  String get syncAllSynced => 'எல்லாம் ஒத்திசைக்கப்பட்டது';

  @override
  String get syncDetailsTitle => 'விவரங்களை ஒத்திசைக்கவும்';

  @override
  String get syncMore => 'மேலும் விருப்பங்கள்';

  @override
  String get syncDeviceName => 'சாதனத்தின் பெயர்';

  @override
  String get syncDeviceNameHint => 'உதாரணமாக: எனது டேப்லெட்';

  @override
  String get syncDeviceNameInvalid => '1 முதல் 32 எழுத்துகளைப் பயன்படுத்தவும்';

  @override
  String get syncDeviceKeyDetails => 'பாதுகாப்பு விவரங்கள்';

  @override
  String get syncConnectionProblem =>
      'இப்போதைக்கு ஒத்திசைக்க முடியவில்லை. தானாக மீண்டும் முயற்சிக்கிறது.';

  @override
  String get syncCopyComplete =>
      'உங்கள் டைரி மற்றும் மீடியா கோப்புகளின் முழு நகல்';

  @override
  String get syncCopyPartial => 'சில ஊடகங்கள் இன்னும் காணவில்லை';

  @override
  String get syncCopyOlder => 'புதிய மாற்றங்கள் ஒத்திசைக்க காத்திருக்கின்றன';

  @override
  String get syncCopyUnavailable =>
      'நகல் விவரங்கள் கிடைக்கவில்லை. பிறகு முயற்சிக்கவும்.';

  @override
  String get syncCopyLastKnown =>
      'பிற சாதனங்கள் அவற்றின் கடைசி உறுதிப்படுத்தப்பட்ட நகலைக் காட்டுகின்றன. ஆஃப்லைன் சாதனங்களை இப்போது சரிபார்க்க முடியாது.';

  @override
  String get syncCopyTemporary =>
      'தற்காலிக சேமிப்பு. உங்கள் சாதனங்களில் அசல்களை வைத்திருங்கள்.';

  @override
  String get syncCopyStorage =>
      'உங்கள் ஒத்திசைவு சேமிப்பு. முடிக்கப்பட்ட மீடியா பதிவேற்றங்கள் கண்டறியும் பட்டியலில் பட்டியலிடப்பட்டுள்ளன.';

  @override
  String syncCopyChecked(String time) {
    return 'கடைசியாக உறுதிப்படுத்தப்பட்ட $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'இந்த மாதம் மீதமுள்ள தரவு பரிமாற்றம்: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'இங்கே தொடங்குங்கள்';

  @override
  String get onboardConnect => 'ஏற்கனவே உள்ள சாதனத்துடன் இணைக்கவும்';

  @override
  String get onboardFailed =>
      'அமைவை முடிக்க முடியவில்லை. உங்கள் நாட்குறிப்பு பாதுகாப்பாக உள்ளது; மீண்டும் முயற்சிக்கவும்.';

  @override
  String get tutorialTitle => 'நாட்குறிப்பை எவ்வாறு பயன்படுத்துவது';

  @override
  String get tutorialWriteTitle => 'உங்கள் முதல் டைரி பதிவை எழுதுங்கள்';

  @override
  String get tutorialWriteText =>
      'டைரி பதிவை எழுத + தட்டவும். விருப்பத் தலைப்பைச் சேர்த்து, நாட்குறிப்புத் தேதியைத் தேர்வுசெய்து, சேமிக்கச் சரிபார்ப்புக் குறியைத் தட்டவும். எந்த நேரத்திலும் உங்கள் டைரி பதிவை மீண்டும் திருத்தலாம்.';

  @override
  String get tutorialMediaTitle =>
      'புகைப்படங்கள், ஆடியோ அல்லது கையெழுத்தைச் சேர்க்கவும்';

  @override
  String get tutorialMediaText =>
      'புகைப்படங்கள், வீடியோக்கள் அல்லது குரல் பதிவை இணைக்க அல்லது கையெழுத்து கேன்வாஸைத் திறக்க டைரி எடிட்டரில் + ஐப் பயன்படுத்தவும். இந்த இணைப்புகள் டைரி உள்ளீட்டுடன் சேமிக்கப்படும்.';

  @override
  String get tutorialReviewTitle => 'மீண்டும் ஒரு நாளைக் கண்டுபிடி';

  @override
  String get tutorialReviewText =>
      'உங்கள் நாட்குறிப்பு அல்லது காலெண்டரை உலாவவும், உங்கள் எழுத்தைத் தேடவும் மற்றும் குறிச்சொற்களுடன் உள்ளீடுகளை ஒழுங்கமைக்கவும். மீடியா மற்றும் அட்லஸ் பக்கங்கள் புகைப்படம் அல்லது இருப்பிடம் மூலம் கடந்த உள்ளீடுகளைக் கண்டறிய உங்களை அனுமதிக்கின்றன.';

  @override
  String get tutorialSyncTitle =>
      'ஒன்றுக்கும் மேற்பட்ட சாதனங்களைப் பயன்படுத்தவும்';

  @override
  String get tutorialSyncText =>
      'அமைப்புகள் → தரவு & சேமிப்பு → ஒத்திசைவில், ஏற்கனவே உள்ள சாதனத்துடன் இணைத்து, அந்தச் சாதனத்தில் அங்கீகாரத்தை உறுதிப்படுத்தவும். இரு சாதனங்களும் நாட்குறிப்பைப் பயன்படுத்திக் கொள்ளலாம். டைரி உரை முதலில் ஒத்திசைக்கப்படும். நெட்வொர்க் இணைப்பு மற்றும் மீதமுள்ள தரவு பரிமாற்ற ஒதுக்கீட்டை அனுமதிக்கும் போது மீடியா கோப்புகள் அடுத்ததாக ஒத்திசைக்கப்படும்.';

  @override
  String get tutorialPrivacyTitle =>
      'உங்கள் நாட்குறிப்பை பாதுகாப்பாக வைத்திருங்கள்';

  @override
  String get tutorialPrivacyText =>
      'டைரி உள்ளீடுகளை நீங்கள் ஒத்திசைக்க அல்லது பகிர அல்லது ஏற்றுமதி செய்யும் வரை இந்தச் சாதனத்தில் இருக்கும். ஒத்திசைவு எண்ட்-டு-எண்ட் என்க்ரிப்ட் செய்யப்பட்டுள்ளது. அமைப்புகளில் நீங்கள் பயன்பாட்டு கடவுக்குறியீட்டை அமைக்கலாம், காப்புப்பிரதிகளை உருவாக்கலாம் மற்றும் இந்த டுடோரியலை மீண்டும் திறக்கலாம்.';

  @override
  String get editorDiaryDay => 'நாட்குறிப்பு நாள்';

  @override
  String get editorDiaryDayPicker =>
      'நாட்குறிப்பு நாள் · உருவாக்க நேரம் மாறாது';

  @override
  String get editorDiaryDayHint =>
      'இந்தப் பதிவு எந்த நாளைச் சேர்ந்தது என்பதைத் தீர்மானிக்கிறது. இதை மாற்றினாலும் பதிவு உருவாக்கப்பட்ட நேரம் மாறாது.';

  @override
  String get hiddenDiaryTitle => 'மறைக்கப்பட்ட பதிவுகள்';

  @override
  String get hiddenDiaryHide => 'பதிவை மறை';

  @override
  String get hiddenDiaryShow => 'பதிவைக் காட்டு';

  @override
  String get hiddenDiaryEmpty => 'மறைக்கப்பட்ட பதிவுகள் இல்லை';

  @override
  String get hiddenDiaryUnlock => 'மறைக்கப்பட்ட பதிவுகளைத் திற';

  @override
  String get hiddenDiaryAuthHint =>
      'செயலிப் பூட்டு அல்லது சாதனத் திரைப் பூட்டைப் பயன்படுத்தவும்.';

  @override
  String get hiddenDiaryLocalOnly =>
      'மறைக்கப்பட்ட பதிவுகள் இந்தச் சாதனத்தில் இருக்கும்; ஒத்திசைவு இடைநிறுத்தப்படும். மறையாக்கப்பட்ட காப்புப்பிரதிகளைப் பயன்படுத்தவும். மற்ற இடங்களில் உள்ள பிரதிகள் மாறாது.';
}
