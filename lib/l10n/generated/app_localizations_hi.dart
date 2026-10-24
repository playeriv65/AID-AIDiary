// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => 'थीम रंग';

  @override
  String get themeColorHint => 'इस पैलेट के लिए एक रंग चुनें.';

  @override
  String get themeColorBlue => 'आसमानी नीला';

  @override
  String get themeColorGreen => 'जंगल हरा';

  @override
  String get themeColorBrown => 'गरम कॉफ़ी';

  @override
  String get themeColorPurple => 'लैवेंडर';

  @override
  String get themeColorRose => 'धूल भरा गुलाब';

  @override
  String get themeColorAmber => 'अंबर';

  @override
  String get themeColorPreview => 'हर दिन थोड़ा सा';

  @override
  String get themeTintBackgroundTitle => 'पृष्ठभूमि को थीम रंग से रंगें';

  @override
  String get themeTintBackgroundHint =>
      'तटस्थ ग्रे पृष्ठभूमि के लिए बंद करें; बटन आपके चुने हुए रंग को बनाए रखते हैं।';

  @override
  String get dailyReminderTitle => 'आज दर्ज करें!';

  @override
  String get dailyReminderDescription => 'अपना आज का दिन दर्ज करें…';

  @override
  String get actionTakePhoto => 'फोटो लें';

  @override
  String get flashbacksTitle => 'फ्लैशबैक्स';

  @override
  String get settingsFlashbacksExcludeBadDays => 'बुरे दिनों के अलावा';

  @override
  String get flashbackGoodDay => 'अच्छा दिन';

  @override
  String get flashbackRandomDay => 'कोई भी दिन';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सप्ताह पहले',
      one: '$count सप्ताह पहले',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count महीने पहले',
      one: '$count महीने पहले',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count साल पहले',
      one: '$count साल पहले',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'आज के दिन';

  @override
  String get searchLogsHint => 'लॉग्स खोजें…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count डायरी प्रविष्टियाँ',
      one: '$count डायरी प्रविष्टियाँ',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन',
      one: '$count दिन',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count शब्द',
      one: '$count शब्द',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'कोई लॉग नहीं…';

  @override
  String get noResults => 'कोई परिणाम नहीं...';

  @override
  String get sortOrderAscendingTitle => 'बढ़ते हुए क्रम में';

  @override
  String get sortOrderDescendingTitle => 'घटते हुए क्रम में';

  @override
  String get pageStatisticsTitle => 'आंकड़े';

  @override
  String get statisticsNotEnoughData => 'पर्याप्त डेटा नहीं है…';

  @override
  String get statisticsRangeOneMonth => '१ महीना';

  @override
  String get statisticsRangeSixMonths => '६ महीने';

  @override
  String get statisticsRangeOneYear => '१ वर्ष';

  @override
  String get statisticsRangeAllTime => 'सारा समय';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag सारांश';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag दिन के हिसाब से';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return 'समय के साथ $tag';
  }

  @override
  String get chartGroupingLabel => 'द्वारा समूहित करें';

  @override
  String get chartGroupingDay => 'दिन';

  @override
  String get chartGroupingWeek => 'सप्ताह';

  @override
  String get chartGroupingMonth => 'महीना';

  @override
  String get chartGroupingYear => 'वर्ष';

  @override
  String get chartSmoothingLabel => 'चौरसाई करना';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'वर्तमान स्ट्रीक $count',
      one: 'वर्तमान स्ट्रीक $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'सबसे लंबी लकीर $count',
      one: 'सबसे लंबी लकीर $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'महान दिन $count',
      one: 'महान दिन $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'बुरे दिन के बाद से दिन $count',
      one: 'एक बुरे दिन के बाद से दिन $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'बाहरी स्टोरेज एक्सेस नहीं कर सकते';

  @override
  String get errorExternalStorageAccessDescription =>
      'यदि आप नेटवर्क स्टोरेज का उपयोग कर रहे हैं तो सुनिश्चित करें कि सेवा ऑनलाइन है और आपके पास नेटवर्क एक्सेस है।\n\nअन्यथा, ऐप ने बाहरी फ़ोल्डर के लिए अनुमतियाँ खो दी होंगी। सेटिंग्स पर जाएं, और पहुंच प्रदान करने के लिए बाहरी फ़ोल्डर को फिर से चुनें।\n\nचेतावनी, परिवर्तन तब तक समन्वयित नहीं होंगे जब तक आप बाहरी संग्रहण स्थान तक पहुंच बहाल नहीं कर देते!';

  @override
  String get errorExternalStorageAccessContinue =>
      'लोकल डेटाबेस के साथ जारी रखें';

  @override
  String get lastModified => 'संशोधित';

  @override
  String get writeSomethingHint => 'कुछ लिखें…';

  @override
  String get titleHint => 'शीर्षक…';

  @override
  String get deleteLogTitle => 'लॉग हटाएं';

  @override
  String get deleteLogDescription => 'क्या आप इस लॉग को हटाना चाहते हैं?';

  @override
  String get deletePhotoTitle => 'फ़ोटो हटाएं';

  @override
  String get deletePhotoDescription => 'क्या आप इस फोटो को हटाना चाहते हैं?';

  @override
  String get pageSettingsTitle => 'सैटिंग्स';

  @override
  String get settingsTheme => 'थीम';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeDark => 'डार्क';

  @override
  String get themeAmoled => 'एमोलेड';

  @override
  String get settingsFirstDayOfWeek => 'सप्ताह का पहला दिन';

  @override
  String get settingsCalendarSystem => 'कैलेंडर प्रकार';

  @override
  String get calendarSystemGregorian => 'ग्रेगोरियन';

  @override
  String get calendarSystemJalali => 'जलाली';

  @override
  String get settingsUseSystemAccentColor => 'सिस्टम का निजी रंग उपयोग करें';

  @override
  String get settingsCustomAccentColor => 'कस्टम एक्सेंट रंग';

  @override
  String get settingsShowFlashbacks => 'फ़्लैशबैक दिखाएँ';

  @override
  String get settingsChangeMoodIcons => 'मूड आइकन बदलें';

  @override
  String get moodIconPrompt => 'कोई आइकन इंटर करें';

  @override
  String get settingsHideImages => 'छवियाँ छिपाएँ';

  @override
  String get pageCalendarTitle => 'कैलेंडर';

  @override
  String get settingsNotificationsTitle => 'सूचनाएं';

  @override
  String get settingsDailyReminderTitle => 'डेली रिमाइंडर';

  @override
  String get settingsOnThisDayDescription => 'पिछली यादों को फिर से याद करें';

  @override
  String get settingsDailyReminderDescription =>
      'प्रत्येक दिन एक सौम्य अनुस्मारक';

  @override
  String get settingsReminderTime => 'अनुस्मारक समय';

  @override
  String get settingsFixedReminderTimeTitle => 'निश्चित अनुस्मारक समय';

  @override
  String get settingsFixedReminderTimeDescription =>
      'अनुस्मारक के लिए एक निश्चित समय चुनें';

  @override
  String get settingsAlwaysSendReminderTitle => 'हमेशा रिमाइंडर भेजें';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'भले ही डायरी प्रविष्टि पहले ही शुरू हो चुकी हो, फिर भी अनुस्मारक भेजें';

  @override
  String get settingsCustomizeNotificationTitle => 'सूचनाएं अनुकूलित करें';

  @override
  String get settingsTemplatesTitle => 'टेम्पलेट्स';

  @override
  String get manageTemplates => 'टेम्पलेट मैनेज करें';

  @override
  String get noTemplateTitle => 'कोई नहीं';

  @override
  String get noTemplatesDescription => 'अभी तक कोई टेम्पलेट नहीं बनाया गया...';

  @override
  String get templateDefaultTimestampTitle => 'टाइमस्टैम्प';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'दिन का सारांश';

  @override
  String get templateDefaultSummaryBody => '### सारांश\n- \n\n### उद्धरण\n> ';

  @override
  String get templateDefaultReflectionTitle => 'प्रतिबिम्ब';

  @override
  String get templateDefaultReflectionBody =>
      '### आज आपको किस बात का आनंद आया?\n- \n\n### तुम किसके लिए आभारी हो?\n- \n\n### आप को किस चीज़ की आशा है?\n- ';

  @override
  String get settingsTagsTitle => 'टैग';

  @override
  String get manageTags => 'टैग प्रबंधित करें';

  @override
  String get tagTypeLabelTitle => 'लेबल';

  @override
  String get tagTypeTrackerTitle => 'ट्रैकर';

  @override
  String get nameHint => 'नाम';

  @override
  String get tagColorLabel => 'रंग';

  @override
  String get iconPickerTitle => 'चिह्न चुनें';

  @override
  String get iconPickerIconsTab => 'प्रतीक';

  @override
  String get iconPickerCustomTab => 'कस्टम';

  @override
  String get iconPickerSearchHint => 'आइकन खोजें…';

  @override
  String get colorPickerTitle => 'रंग चुनें';

  @override
  String get colorPickerPaletteTab => 'रंग';

  @override
  String get iconGroupMoodPeople => 'मूड और लोग';

  @override
  String get iconGroupHealth => 'स्वास्थ्य';

  @override
  String get iconGroupWorkFinance => 'कार्य एवं वित्त';

  @override
  String get iconGroupHabitsGoals => 'आदतें और लक्ष्य';

  @override
  String get iconGroupNature => 'प्रकृति';

  @override
  String get iconGroupFoodDrink => 'खाना-पीना';

  @override
  String get iconGroupHome => 'घर';

  @override
  String get iconGroupTravel => 'यात्रा';

  @override
  String get iconGroupSymbols => 'प्रतीक';

  @override
  String get tagCategoryLabel => 'श्रेणी';

  @override
  String get tagLabel => 'टैग';

  @override
  String get tagCategoryUncategorized => 'अवर्गीकृत';

  @override
  String get newCategoryTitle => 'नई श्रेणी';

  @override
  String get shareButtonLabel => 'साझा करें';

  @override
  String get importErrorDescription => 'फ़ाइल आयात करने में विफल!';

  @override
  String get exportErrorDescription => 'फ़ाइल निर्यात करने में विफल!';

  @override
  String get deleteTitle => 'हटाएँ';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' इसका उपयोग $count डायरी प्रविष्टियों में किया जाता है।',
      one: ' इसका उपयोग $count डायरी प्रविष्टियों में किया जाता है।',
      zero: '',
    );
    return '\"$name\" हटाएं?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' इसके $count टैग भी हटा दिए जाएंगे.',
      one: ' इसके $count टैग भी हटा दिए जाएंगे.',
      zero: '',
    );
    return '\"$name\" हटाएं?$_temp0';
  }

  @override
  String get tagNameExists => 'इस नाम का एक टैग पहले से मौजूद है';

  @override
  String get categoryNameExists => 'इस नाम की एक श्रेणी पहले से ही मौजूद है';

  @override
  String deleteTemplateMessage(Object name) {
    return '\"$name\" हटाएं?';
  }

  @override
  String get addTagsTitle => 'टैग जोड़ें';

  @override
  String get addTagsSearchHint => 'टैग खोजें...';

  @override
  String get tagFavoriteName => 'पसंदीदा';

  @override
  String get iconGroupActivities => 'गतिविधियाँ';

  @override
  String get iconGroupHobbies => 'मनोरंजन';

  @override
  String get settingsStorageTitle => 'भंडारण';

  @override
  String get settingsImageQuality => 'छवि गुणवत्ता';

  @override
  String get imageQualityHigh => 'ऊँचा';

  @override
  String get imageQualityMedium => 'मध्यम';

  @override
  String get imageQualityLow => 'नीचा';

  @override
  String get imageQualityNoCompression => 'कोई संपीड़न नहीं';

  @override
  String get settingsLogFolder => 'डायरी प्रविष्टि फ़ोल्डर';

  @override
  String get settingsImageFolder => 'छवि फ़ोल्डर';

  @override
  String get warningTitle => 'चेतावनी';

  @override
  String get logFolderWarningDescription =>
      'यदि चयनित फ़ोल्डर में पहले से ही \'aid_diary.db\' फ़ाइल मौजूद है, तो इसका उपयोग आपके मौजूदा लॉग को ओवरराइट करने के लिए किया जाएगा!';

  @override
  String get errorTitle => 'त्रुटि';

  @override
  String get logFolderErrorDescription =>
      'डायरी प्रविष्टि फ़ोल्डर बदलने में विफल!';

  @override
  String get imageFolderErrorDescription => 'छवि फ़ोल्डर बदलने में विफल!';

  @override
  String get backupErrorDescription => 'बैकअप बनाने में विफल!';

  @override
  String get restoreErrorDescription => 'बैकअप पुनर्स्थापित करने में विफल!';

  @override
  String get settingsBackupRestoreTitle => 'बैकअप और पुनर्स्थापना';

  @override
  String get settingsBackup => 'बैकअप';

  @override
  String get settingsRestore => 'रीस्टोर';

  @override
  String get settingsRestorePromptDescription =>
      'बैकअप को रीस्टोर करने पर आपके मौजूदा डेटा को ओवरराइट किया जाएगा!';

  @override
  String get settingsBackupPasswordProtect => 'पासवर्ड प्रोटेक्ट बैकअप';

  @override
  String get backupEncryptedTitle => 'एन्क्रिप्टेड बैकअप';

  @override
  String get backupEncryptedContent => 'यह बैकअप पासवर्ड से सुरक्षित है.';

  @override
  String get settingsAutoBackup => 'स्वचालित बैकअप';

  @override
  String get settingsAutoBackupLocation => 'बैकअप स्थान';

  @override
  String get settingsAutoBackupInterval => 'बैकअप अंतराल';

  @override
  String get settingsAutoBackupIntervalDaily => 'दैनिक';

  @override
  String get settingsAutoBackupIntervalWeekly => 'साप्ताहिक';

  @override
  String get settingsAutoBackupIntervalMonthly => 'मासिक';

  @override
  String get settingsAutoBackupMaxCount => 'रखने के लिए बैकअप';

  @override
  String get settingsAutoBackupRequireCharging => 'केवल चार्ज करते समय';

  @override
  String settingsBackupLast(Object time) {
    return 'अंतिम बैकअप $time';
  }

  @override
  String get settingsBackupNever => 'कभी भी बैकअप नहीं लिया';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'अगला बैकअप $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'सब';

  @override
  String get autoBackupFailedTitle => 'बैकअप विफल';

  @override
  String tranferStatus(Object percent) {
    return 'स्थानांतरण… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'बैकअप बनाया जा रहा है... $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'बैकअप रीस्टोर किया जा रहा है $percent%';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return 'बैकअप एन्क्रिप्ट किया जा रहा है... $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'बैकअप को डिक्रिप्ट किया जा रहा है… $percent%';
  }

  @override
  String get cleanUpStatus => 'सफ़ाई हो रही है...';

  @override
  String get settingsExportToAnotherFormat =>
      'किसी अन्य फॉर्मेट में निर्यात करें';

  @override
  String get settingsExportFormatDescription =>
      'इसका उपयोग बैकअप के रूप में नहीं किया जाना चाहिए!';

  @override
  String get settingsImportFromAnotherApp => 'किसी अन्य ऐप से आयात करें';

  @override
  String get logFormatTitle => 'प्रारूप चुनें';

  @override
  String get logFormatDescription =>
      'अन्य ऐप का प्रारूप सभी फीचर्स को सपोर्ट नहीं कर सकता है। कृपया किसी भी समस्या को रिपोर्ट करें क्योंकि थर्ड पार्टी के प्रारूप कभी भी बदल सकते हैं। यह मौजूदा लॉग को प्रभावित नहीं करेगा!';

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
  String get formatOneShot => 'वनशॉट';

  @override
  String get formatPixels => 'Pixels';

  @override
  String get formatMarkdown => 'मार्कडाउन';

  @override
  String get settingsDeleteAllLogsTitle => 'सभी लॉग हटाएं';

  @override
  String get settingsDeleteAllLogsDescription =>
      'क्या आप अपने सभी लॉग को हटाना चाहते हैं?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'पुष्टि करने के लिए \'$prompt\' दर्ज करें। इसे असंपादित नहीं किया जा सकता है!';
  }

  @override
  String get settingsAppLanguageTitle => 'ऐप की भाषा';

  @override
  String get settingsSecurityTitle => 'सिक्योरिटी';

  @override
  String get settingsSecurityRequirePassword => 'पासवर्ड की आवश्यकता है';

  @override
  String get settingsSecurityEnterPassword => 'पासवर्ड दर्ज करें';

  @override
  String get settingsSecuritySetPassword => 'पासवर्ड सेट करें';

  @override
  String get settingsSecurityChangePassword => 'पासवर्ड बदलें';

  @override
  String get settingsSecurityPassword => 'पासवर्ड';

  @override
  String get settingsSecurityConfirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get settingsSecurityOldPassword => 'पुराना पासवर्ड';

  @override
  String get settingsSecurityIncorrectPassword => 'गलत पासवर्ड';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'पासवर्ड मैच नहीं किया';

  @override
  String get requiredPrompt => 'आवश्यक';

  @override
  String get settingsSecurityBiometricUnlock => 'बॉयोमीट्रिक अनलॉक';

  @override
  String get unlockAppPrompt => 'ऐप अनलॉक करें';

  @override
  String get settingsAboutTitle => 'के बारे में';

  @override
  String get settingsVersion => 'ऐप का वर्जन';

  @override
  String get settingsLicense => 'लाइसेंस';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsOpenSourceLicenses => 'ओपन सोर्स लाइसेंस';

  @override
  String get tagMoodTitle => 'मनोदशा';

  @override
  String get selectTagTitle => 'टैग चुनें';

  @override
  String get labelPresentLabel => 'वर्तमान';

  @override
  String get labelAbsentLabel => 'अनुपस्थित';

  @override
  String get labelCoverageLabel => 'कवरेज';

  @override
  String chartDistributionTitle(Object tag) {
    return '$tag वितरण';
  }

  @override
  String get shareAddToLogPickerTitle => 'एक डायरी प्रविष्टि चुनें';

  @override
  String get adaptiveEmptyDay => 'इस दिन के लिए अभी तक कोई प्रविष्टि नहीं';

  @override
  String get adaptiveNewEntry => 'एक प्रविष्टि लिखें';

  @override
  String get pageJournalTitle => 'जर्नल';

  @override
  String get coachPrompt1 => 'आज किस बात ने आपको मुस्कुराया?';

  @override
  String get coachPrompt2 => 'आज आपने कौन सी एक चीज़ सीखी?';

  @override
  String get coachPrompt3 => 'आज आपने किससे बात की और कैसा लगा?';

  @override
  String get coachPrompt4 => 'अभी आप किस चीज़ के लिए आभारी हैं?';

  @override
  String get coachPrompt5 => 'आज आपकी सबसे अधिक ऊर्जा किस चीज़ में लगी?';

  @override
  String get coachPrompt6 =>
      'उस छोटे से क्षण का वर्णन करें जिसे आप याद रखना चाहते हैं।';

  @override
  String get coachPrompt7 => 'कल को क्या अच्छा दिन बनाएगा?';

  @override
  String get coachPrompt8 => 'हाल ही में आपके दिमाग में क्या चल रहा है?';

  @override
  String get coachPrompt9 => 'आज आपने सिर्फ अपने लिए क्या किया?';

  @override
  String get coachPrompt10 => 'यदि आज का कोई शीर्षक होता तो वह क्या होता?';

  @override
  String get pageMediaTitle => 'मीडिया';

  @override
  String get pageAtlasTitle => 'एटलस';

  @override
  String get pageCoachTitle => 'कोच';

  @override
  String get noEntrySelected => 'कोई प्रविष्टि चयनित नहीं.';

  @override
  String get entryShare => 'साझा करें';

  @override
  String get entryFavorite => 'सितारा';

  @override
  String get entryEdit => 'संपादित करें';

  @override
  String get entryPrevious => 'पिछली प्रविष्टि';

  @override
  String get entryNext => 'अगली प्रविष्टि';

  @override
  String get journalStories => 'कहानियां';

  @override
  String get journalEntries => 'प्रविष्टियाँ';

  @override
  String get journalEmptyHint => 'एक नई प्रविष्टि जोड़कर अपनी डायरी शुरू करें।';

  @override
  String get storyToday => 'आज';

  @override
  String get storyThrowback => 'थ्रोबैक';

  @override
  String get storyNoThrowback => 'आज कोई थ्रोबैक नहीं';

  @override
  String get mediaFiles => 'मीडिया फ़ाइलें';

  @override
  String get mediaEmpty => 'अभी तक कोई फ़ोटो नहीं.';

  @override
  String get mediaEmptyHint =>
      'प्रविष्टियों से जुड़ी तस्वीरें यहां दिखाई जाएंगी।';

  @override
  String get atlasEmpty => 'स्थान के साथ कोई प्रविष्टि नहीं.';

  @override
  String get atlasEmptyHint => 'स्थान सहित प्रविष्टियाँ यहां दिखाई जाएंगी।';

  @override
  String get atlasShowAll => 'सभी प्रविष्टियाँ दिखाएँ';

  @override
  String get atlasMyLocation => 'मेरा स्थान';

  @override
  String get coachAll => 'सब';

  @override
  String get coachPrograms => 'कार्यक्रम';

  @override
  String get coachTemplates => 'टेम्पलेट्स';

  @override
  String get coachKindProgram => 'कार्यक्रम';

  @override
  String get coachKindTemplate => 'टेम्पलेट';

  @override
  String get coachNoTemplates => 'कोई प्रोग्राम या टेम्पलेट नहीं.';

  @override
  String get coachUseTemplate => 'इस टेम्पलेट के साथ लिखें';

  @override
  String get coachProgramEverydayTitle => 'हर दिन के पल';

  @override
  String get coachProgramEverydayDescription =>
      'पांच छोटे प्रश्न, एक दिन में एक। प्रत्येक में एक या दो मिनट लगते हैं और आपको यह देखने में मदद मिलती है कि किस कारण से आपका दिन बना। हर दिन थोड़ा लिखने की आदत बनाने का एक सौम्य तरीका।';

  @override
  String get coachProgramReflectTitle => 'अंदर की ओर देखना';

  @override
  String get coachProgramReflectDescription =>
      'पाँच सप्ताह तक, प्रति सप्ताह एक गहरा प्रश्न। प्रत्येक के साथ अपना समय लें: आप कैसा महसूस कर रहे हैं, क्या आपको थका देता है, आप किसके लिए आभारी हैं।';

  @override
  String get searchFilters => 'फिल्टर';

  @override
  String get searchFilterTags => 'टैग';

  @override
  String get searchFilterStarred => 'तारांकित';

  @override
  String get searchHint => 'खोजने के लिए टाइप करें, या फ़िल्टर चुनें।';

  @override
  String get locationTitle => 'स्थान';

  @override
  String get locationName => 'स्थान का नाम';

  @override
  String get locationRemove => 'हटाओ';

  @override
  String get locationServiceDisabled => 'स्थान सेवाएँ बंद हैं.';

  @override
  String get locationPermissionDenied => 'स्थान की अनुमति अस्वीकार कर दी गई.';

  @override
  String get locationUnavailable => 'वर्तमान स्थान प्राप्त नहीं हो सका.';

  @override
  String get calendarJumpToToday => 'आज ही आगे बढ़ें';

  @override
  String get editorStartWriting => 'लिखना प्रारंभ करें या कोई चुनें ';

  @override
  String get editorTemplateLink => 'टेम्पलेट';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'एक टेम्पलेट चुनें';

  @override
  String get templateFeatured => 'विशेष रुप से प्रदर्शित टेम्पलेट्स';

  @override
  String get templateMine => 'मेरे टेम्पलेट्स';

  @override
  String get templateDailyName => 'दैनिक समीक्षा';

  @override
  String get templateDailyDescription => 'क्या हुआ, कैसा लगा और आगे क्या होगा।';

  @override
  String get templateDailyText =>
      '## आज क्या हुआ\n\n\n## मुझे कैसा लगा\n\n\n## तीन चीज़ों के लिए मैं आभारी हूँ\n1. \n2. \n3. \n\n## कल\n';

  @override
  String get templateTravelName => 'यात्रा डायरी प्रविष्टि';

  @override
  String get templateTravelDescription => 'सड़क से स्थान, क्षण और भोजन।';

  @override
  String get templateTravelText =>
      '## मैं कहाँ गया था\n\n\n## वह पल जो मुझे सबसे ज्यादा याद है\n\n\n## मैंने क्या खाया\n\n\n## कल के लिए योजनाएँ\n';

  @override
  String get templateReadingName => 'नोट्स पढ़ना';

  @override
  String get templateReadingDescription => 'आपने जो पढ़ा उससे उद्धरण और विचार।';

  @override
  String get templateReadingText =>
      '## किताब\n\n\n## मैं कहां हूं\n\n\n## उद्धरण\n> \n\n## मेरे विचार\n';

  @override
  String get templateWeeklyName => 'साप्ताहिक समीक्षा';

  @override
  String get templateWeeklyDescription =>
      'हाइलाइट्स, संघर्ष और अगले सप्ताह का फोकस।';

  @override
  String get templateWeeklyText =>
      '## हाइलाइट्स\n\n\n## क्या कठिन था\n\n\n## मैंने क्या सीखा\n\n\n## अगले सप्ताह पर ध्यान दें\n';

  @override
  String get entrySaveAsTemplate => 'टेम्पलेट के रूप में सहेजें';

  @override
  String get entrySavedAsTemplate => 'टेम्पलेट के रूप में सहेजा गया';

  @override
  String get storyStatistics => 'सांख्यिकी';

  @override
  String get storyMoodChart => 'मूड चार्ट';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return '$entries प्रविष्टियाँ · $days दिन';
  }

  @override
  String get storyThisYear => 'इस साल';

  @override
  String get storyLastYear => 'पिछले साल';

  @override
  String get storyTapToOpen => 'इसे खोलने के लिए एक दिन टैप करें';

  @override
  String get settingsGeneralTitle => 'सामान्य';

  @override
  String get settingsDataTitle => 'डेटा और भंडारण';

  @override
  String get settingsStoriesTitle => 'कहानियां';

  @override
  String get settingsHelpTitle => 'मदद और उसके बारे में';

  @override
  String get weatherTitle => 'मौसम';

  @override
  String get weatherClear => 'स्पष्ट';

  @override
  String get weatherPartlyCloudy => 'आंशिक रूप से बादल छाए रहेंगे';

  @override
  String get weatherCloudy => 'बादल छाए रहेंगे';

  @override
  String get weatherFog => 'कोहरा';

  @override
  String get weatherDrizzle => 'बूंदाबांदी';

  @override
  String get weatherRain => 'वर्षा';

  @override
  String get weatherSnow => 'हिमपात';

  @override
  String get weatherStorm => 'आंधी';

  @override
  String get weatherFetch => 'इस प्रविष्टि के लिए मौसम प्राप्त करें';

  @override
  String get weatherNeedsLocation => 'पहले निर्देशांक के साथ एक स्थान जोड़ें.';

  @override
  String get weatherUnavailable => 'इस स्थान और समय के लिए मौसम अनुपलब्ध है।';

  @override
  String get weatherRemove => 'मौसम हटाओ';

  @override
  String get activityTitle => 'गतिविधि';

  @override
  String get activityStill => 'फिर भी';

  @override
  String get activityWalking => 'चलना';

  @override
  String get activityRunning => 'चल रहा है';

  @override
  String get activityCycling => 'साइकिल चलाना';

  @override
  String get activityVehicle => 'एक वाहन में';

  @override
  String get activityFlying => 'उड़ना';

  @override
  String get activityExercise => 'व्यायाम';

  @override
  String get activityDetect => 'वर्तमान गतिविधि का पता लगाएं';

  @override
  String get activityDetectFailed => 'किसी गतिविधि का पता नहीं लगाया जा सका.';

  @override
  String get activityRemove => 'गतिविधि हटाएँ';

  @override
  String get settingsAutoAddTitle => 'स्वचालित रूप से जोड़ें';

  @override
  String get settingsAutoAddLocation => 'स्थान';

  @override
  String get settingsAutoAddWeather => 'मौसम';

  @override
  String get settingsAutoAddHint =>
      'नई प्रविष्टियाँ बनने पर इन्हें भर दिया जाता है।';

  @override
  String get settingsTemperatureUnit => 'तापमान इकाई';

  @override
  String get settingsCelsius => 'सेल्सियस (डिग्री सेल्सियस)';

  @override
  String get settingsFahrenheit => 'फ़ारेनहाइट (°F)';

  @override
  String get moodGreat => 'बढ़िया';

  @override
  String get moodGood => 'अच्छा';

  @override
  String get moodOkay => 'ठीक है';

  @override
  String get moodBad => 'ख़राब';

  @override
  String get moodAwful => 'भयानक';

  @override
  String get locationSearchHint => 'एक जगह खोजें';

  @override
  String get locationSearchEmpty => 'कोई स्थान नहीं मिला';

  @override
  String get settingsWallpaper => 'वॉलपेपर';

  @override
  String get wallpaperNone => 'कोई नहीं';

  @override
  String get wallpaperDots => 'बिंदु';

  @override
  String get wallpaperGrid => 'ग्रिड';

  @override
  String get wallpaperLines => 'पंक्तियाँ';

  @override
  String get wallpaperPhoto => 'फोटो...';

  @override
  String get settingsFontFamily => 'फ़ॉन्ट';

  @override
  String get fontSystem => 'सिस्टम';

  @override
  String get fontSerif => 'सेरिफ़';

  @override
  String get fontMono => 'मोनोस्पेस';

  @override
  String get settingsFontSize => 'फ़ॉन्ट आकार';

  @override
  String get fontSizeSmall => 'छोटा';

  @override
  String get fontSizeMedium => 'मध्यम';

  @override
  String get fontSizeLarge => 'बड़ा';

  @override
  String get fontSizeExtraLarge => 'अतिरिक्त बड़ा';

  @override
  String get settingsLineSpacing => 'पंक्ति रिक्ति';

  @override
  String get lineSpacingCompact => 'सघन';

  @override
  String get lineSpacingNormal => 'सामान्य';

  @override
  String get lineSpacingRelaxed => 'आराम से';

  @override
  String get moodAssociationsTitle => 'मुझे क्या महसूस होता है...';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$total प्रविष्टियों में से $matching';
  }

  @override
  String get videoRecord => 'एक वीडियो रिकॉर्ड करें';

  @override
  String get videoChoose => 'एक वीडियो चुनें';

  @override
  String get audioRecordTitle => 'वॉइस नोट रिकॉर्ड करें';

  @override
  String get audioChoose => 'एक ऑडियो फ़ाइल चुनें';

  @override
  String get audioStart => 'अभिलेख';

  @override
  String get audioStop => 'रुकें और बचाएं';

  @override
  String get audioPermissionDenied =>
      'माइक्रोफ़ोन पहुंच बंद है. इसे सिस्टम सेटिंग्स में अनुमति दें।';

  @override
  String get mediaTooLarge => 'यह वीडियो संलग्न करने के लिए बहुत बड़ा है.';

  @override
  String get mediaUnavailable => 'यह अनुलग्नक इस डिवाइस पर उपलब्ध नहीं है.';

  @override
  String get widgetDone => 'आज की प्रविष्टि लिखी है';

  @override
  String get widgetPending => 'आपका दिन कैसा था?';

  @override
  String get widgetWrite => 'लिखो';

  @override
  String get insertChecklist => 'चेकलिस्ट';

  @override
  String get insertNumberedList => 'क्रमांकित सूची';

  @override
  String get insertTable => 'टेबल';

  @override
  String get insertDivider => 'विभाजक';

  @override
  String get insertCodeBlock => 'कोड ब्लॉक';

  @override
  String get journalSortTitle => 'प्रविष्टियाँ क्रमबद्ध करें';

  @override
  String get journalSortUpdated => 'अंतिम बार अद्यतन किया गया';

  @override
  String get settingsTimeFormat => 'समय प्रारूप';

  @override
  String get settingsDayStart =>
      'नई प्रविष्टियाँ एक दिन पहले तक के लिए गिनी जाती हैं';

  @override
  String get settingsDayAskUntil => 'फिर पूछें कि किस दिन तक';

  @override
  String get settingsDayStartMidnight => 'बंद';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'प्रत्येक प्रविष्टि उस दिन को अपने लिखे जाने के समय के आगे रखती है, और आप किसी भी समय संपादक में उस दिन को बदल सकते हैं। ये घंटे केवल नई प्रविष्टियों के लिए दिन चुनते हैं, इसलिए इन्हें बदलने से कोई मौजूदा प्रविष्टि नहीं रह जाती है।';

  @override
  String get lateNightBadge => 'देर रात लिखा गया, एक दिन पहले गिना गया';

  @override
  String editorDayAsk(String time) {
    return '$time पर लिखा गया। यह किस दिन के लिए है?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (कल)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (आज)';
  }

  @override
  String editorWrittenAt(String when) {
    return '$when लिखा';
  }

  @override
  String get timeFormat12 => '12 घंटे';

  @override
  String get timeFormat24 => '24 घंटे';

  @override
  String get settingsReminderDays => 'मुझे आगे याद दिलाएं';

  @override
  String get locationRecent => 'हाल के स्थान';

  @override
  String get shareImage => 'छवि साझा करें';

  @override
  String get shareSaveImage => 'छवि सहेजें';

  @override
  String get shareSaved => 'छवि सहेजी गई';

  @override
  String get deletedTitle => 'हाल ही में हटाया गया';

  @override
  String get deletedNone => 'हाल ही में कुछ भी नहीं हटाया गया';

  @override
  String deletedHint(int days) {
    return 'हटाई गई प्रविष्टियाँ यहाँ $days दिनों तक रहती हैं, फिर मिटा दी जाती हैं।';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days दिन बचे हैं';
  }

  @override
  String get deletedRestore => 'पुनर्स्थापित करें';

  @override
  String get deletedDeleteForever => 'हमेशा के लिए हटा दें';

  @override
  String get deletedDeleteForeverDescription =>
      'प्रविष्टि और उसके अनुलग्नक मिटा दिए गए हैं. इसे असंपादित नहीं किया जा सकता है।';

  @override
  String get deletedEmpty => 'ख़ाली';

  @override
  String get deletedEmptyDescription =>
      'हाल ही में हटाई गई प्रत्येक प्रविष्टि मिटाएँ? इसे असंपादित नहीं किया जा सकता है।';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'बेतरतीब चलना';

  @override
  String get randomSubtitle => 'पिछली प्रविष्टि खोलें';

  @override
  String get randomNext => 'दूसरा';

  @override
  String get randomAll => 'सब';

  @override
  String get randomWithPhotos => 'फोटो के साथ';

  @override
  String get randomGoodDays => 'अच्छे दिन';

  @override
  String get randomEmpty => 'चुनने के लिए कोई प्रविष्टियाँ नहीं';

  @override
  String get reviewWeekTitle => 'इस सप्ताह';

  @override
  String get reviewWeekSubtitle => 'आपका अब तक का सप्ताह';

  @override
  String get reviewYearTitle => 'इस साल';

  @override
  String get reviewEmpty => 'अभी तक कुछ भी नहीं लिखा है';

  @override
  String get reviewEntries => 'प्रविष्टियाँ';

  @override
  String get reviewDaysWritten => 'दिन लिखे गए';

  @override
  String get reviewWords => 'शब्द';

  @override
  String get reviewPhotos => 'तस्वीरें';

  @override
  String get reviewLongestRun => 'दिनों की सबसे लंबी अवधि';

  @override
  String get reviewAverageMood => 'औसत मूड';

  @override
  String get reviewFavorites => 'सबसे अधिक बार';

  @override
  String get reviewByMonth => 'महीने के हिसाब से';

  @override
  String get reviewHighlight => 'हाइलाइट करें';

  @override
  String get yearInPixels => 'वर्ष पिक्सेल में';

  @override
  String get capsuleSeal => 'टाइम कैप्सूल के रूप में सील करें';

  @override
  String get capsuleTitle => 'समय कैप्सूल';

  @override
  String capsuleOpensOn(Object date) {
    return '$date पर खुलता है';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return '$date पर लिखा है';
  }

  @override
  String get capsuleOpenEarly => 'जल्दी खोलो';

  @override
  String get capsuleOpenEarlyDescription =>
      'कैप्सूल अब खुलता है और खुला रहता है।';

  @override
  String get capsuleOpened => 'टाइम कैप्सूल खुल गया';

  @override
  String get templateMorningName => 'सुबह के पन्ने';

  @override
  String get templateMorningDescription => 'तीन मिनट में दिन निर्धारित करें';

  @override
  String get templateMorningText =>
      '## तीन चीजें जो मैं आज अच्छे से करना चाहता हूं\n1. \n2. \n3. \n\n## कुछ ऐसा जिसका मुझे इंतज़ार है\n\n## A note to myself\n';

  @override
  String get templateEveningName => 'शाम की समीक्षा';

  @override
  String get templateEveningDescription =>
      'जो अच्छा हुआ उसके साथ दिन का समापन करें';

  @override
  String get templateEveningText =>
      '## Three good things today\n1. \n2. \n3. \n\n## मैंने क्या सीखा\n\n## What could go better tomorrow\n';

  @override
  String get routineMorning => 'सुप्रभात';

  @override
  String get routineEvening => 'शाम की समीक्षा';

  @override
  String get settingsRoutinePrompts => 'सुबह और शाम संकेत';

  @override
  String get settingsRoutinePromptsHint =>
      'स्टोरीज़ में सुबह या शाम का टेम्पलेट सुझाएँ';

  @override
  String get checkInTitle => 'त्वरित चेक-इन';

  @override
  String get checkInSubtitle => 'दो नल में मूड';

  @override
  String get checkInMood => 'आपको कैसा लगता है?';

  @override
  String get checkInActivity => 'तुम क्या कर रहे हो?';

  @override
  String get checkInNote => 'इसके बारे में एक पंक्ति (वैकल्पिक)';

  @override
  String get checkInSave => 'सहेजें';

  @override
  String editorWordCount(int words, int characters) {
    return '$words शब्द · $characters अक्षर';
  }

  @override
  String get coachProgramEverydayTagline =>
      'एक दिन में छोटी-छोटी बातों पर ध्यान दें।';

  @override
  String get coachProgramReflectTagline => 'धीरे करो और अपने आप को सुनो.';

  @override
  String get coachDuration => 'अवधि';

  @override
  String get coachInterval => 'अंतराल';

  @override
  String get coachDifficulty => 'कठिनाई';

  @override
  String get coachIntervalDaily => 'दैनिक';

  @override
  String get coachIntervalWeekly => 'साप्ताहिक';

  @override
  String get coachDifficultyBeginner => 'शुरुआती';

  @override
  String get coachDifficultyIntermediate => 'मध्यवर्ती';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन',
      one: '$count दिन',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सप्ताह',
      one: '$count सप्ताह',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'दिन $n';
  }

  @override
  String coachWeekN(int n) {
    return 'सप्ताह $n';
  }

  @override
  String get coachEnroll => 'नामांकन';

  @override
  String get coachEndProgram => 'कार्यक्रम समाप्त';

  @override
  String get coachAuthor => 'लेखक';

  @override
  String get coachAuthorBio => 'इस ऐप के लिए संकेत लिखे गए।';

  @override
  String get coachEnrolledTip =>
      'सब तैयार! Your questions will show up in Stories.';

  @override
  String get coachGoToStories => 'स्टोरीज़ पर जाएँ';

  @override
  String get coachAnswerHint => 'अपना जबाब लिखें…';

  @override
  String get storyWrapUp => 'आज के लिए बस इतना ही.';

  @override
  String get storyTapToClose => 'बंद करने के लिए टैप करें';

  @override
  String get coachAnswerDone => 'हो गया';

  @override
  String get coachAnswered => 'उत्तर दिया गया, खोलने के लिए टैप करें';

  @override
  String get coachAnsweredEarlier => 'उत्तर';

  @override
  String get locationLocating => 'पता लगाया जा रहा है...';

  @override
  String get locationPickPlace => 'एक जगह चुनें';

  @override
  String get locationPlacesHint => 'स्थान का पता या नाम';

  @override
  String get locationCustom => 'कस्टम स्थान';

  @override
  String get locationCurrent => 'वर्तमान स्थान';

  @override
  String get locationSaved => 'सहेजे गए स्थान';

  @override
  String get locationSearchResults => 'खोज परिणाम';

  @override
  String get locationNearby => 'निकटवर्ती स्थान';

  @override
  String get locationRename => 'नाम बदलें';

  @override
  String get locationSavePlace => 'स्थान सहेजें';

  @override
  String get locationUnsavePlace => 'सहेजे गए स्थानों से हटाएँ';

  @override
  String get shareAs => 'के रूप में साझा करें...';

  @override
  String get shareAsImage => 'छवि';

  @override
  String get shareAsZip => 'मूल मीडिया के साथ ZIP';

  @override
  String get shareAsPlainText => 'सादा पाठ';

  @override
  String get shareAsHtml => 'एचटीएमएल';

  @override
  String get onboardWelcomeTitle => 'AID Diary में आपका स्वागत है';

  @override
  String get onboardWelcomeText =>
      'यहां से प्रारंभ करें, या इस डिवाइस को उस डिवाइस से कनेक्ट करें जिसे आप पहले से उपयोग कर रहे हैं।';

  @override
  String get onboardStart => 'लिखना शुरू करें';

  @override
  String get helpFaq => 'अक्सर पूछे जाने वाले प्रश्न';

  @override
  String get helpFaq1Q => 'मेरी डायरी कहाँ संग्रहित है?';

  @override
  String get helpFaq1A =>
      'आपकी डायरी इस डिवाइस पर संग्रहीत है. It reaches other devices or storage only when you enable sync, share or export it. सिंक एंड-टू-एंड एन्क्रिप्टेड है.';

  @override
  String get helpFaq2Q =>
      'मैं एक प्रति कैसे रखूँ या किसी नए उपकरण में कैसे स्थानांतरित करूँ?';

  @override
  String get helpFaq2A =>
      'Connect to an existing device in Settings → Data & storage → Sync and confirm authorization on the device that has your diary. दोनों डिवाइस प्रयोग योग्य बने हुए हैं। You can also create a backup and restore it on another device.';

  @override
  String get helpFaq3Q =>
      'क्या मैं अन्य डायरी ऐप्स से प्रविष्टियाँ ला सकता हूँ?';

  @override
  String get helpFaq3A =>
      'हाँ: सेटिंग्स → डेटा और स्टोरेज में, Daylio, Diarium, Diaro, DayBook, My Brain, OneShot और Pixels, या JSON निर्यात से आयात निर्यात करें।';

  @override
  String get helpFaq4Q => 'कोच कार्यक्रम कैसे काम करते हैं?';

  @override
  String get helpFaq4A =>
      'कोच पृष्ठ पर एक कार्यक्रम में नामांकन करें। Each day or week a new question waits in Stories; आपका उत्तर एक प्रविष्टि के रूप में सहेजा गया है।';

  @override
  String get helpFaq5Q => 'यदि मैं अपना पासकोड भूल जाऊं तो क्या होगा?';

  @override
  String get helpFaq5A =>
      'पासकोड पुनर्प्राप्त नहीं किया जा सकता, इसलिए अपनी डायरी का बैकअप रखें।';

  @override
  String get helpPrivacy => 'गोपनीयता';

  @override
  String get helpPrivacyText =>
      'जब तक आप एन्क्रिप्टेड सिंक सक्षम नहीं करते या उन्हें साझा/निर्यात नहीं करते तब तक डायरी सामग्री और मीडिया इस डिवाइस पर बने रहते हैं। मानचित्र, स्थान लुकअप और मौसम कॉन्फ़िगर की गई सेवाओं का उपयोग करते हैं और उस अनुरोध के लिए आवश्यक स्थान या खोज क्वेरी भेजते हैं, डायरी टेक्स्ट नहीं।';

  @override
  String get photoMetaTitle => 'फ़ोटो के विवरण का उपयोग करें?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'इस प्रविष्टि को $date के लिए गिनें और उसका स्थान $place पर सेट करें, जैसा कि फोटो में रिकॉर्ड किया गया है?';
  }

  @override
  String photoMetaDate(String date) {
    return 'इस प्रविष्टि को $date के लिए गिनें, जब फोटो लिया गया था?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'इस प्रविष्टि का स्थान $place पर सेट करें, जहां फोटो लिया गया था?';
  }

  @override
  String get photoMetaApply => 'उनका प्रयोग करें';

  @override
  String get quickWriteTitle => 'जल्दी लिखो';

  @override
  String get quickWriteText => 'नई प्रविष्टि प्रारंभ करने के लिए टैप करें.';

  @override
  String get settingsQuickWriteTitle => 'सूचनाओं में त्वरित लिखें';

  @override
  String get settingsQuickWriteDescription =>
      'एक अधिसूचना रखें जो एक नई प्रविष्टि खोलती है।';

  @override
  String get settingsNudgesTitle => 'एक शांत खिंचाव के बाद मुझे कुहनी मारो';

  @override
  String settingsNudgesDescription(int days) {
    return 'जब आपने $days दिनों तक नहीं लिखा हो तो एक सौम्य अनुस्मारक।';
  }

  @override
  String get nudgeTitle => 'काफी समय हो गया';

  @override
  String get nudgeMonday => 'एक नया सप्ताह: आप किसका इंतज़ार कर रहे हैं?';

  @override
  String get nudgeTuesday => 'दो पंक्तियाँ ही काफी हैं. आज आप कैसे हैं?';

  @override
  String get nudgeWednesday =>
      'सप्ताह का आधा समय बीत चुका है। अब तक क्या खास रहा?';

  @override
  String get nudgeThursday => 'आज से रखने लायक कोई छोटी चीज़?';

  @override
  String get nudgeFriday => 'सप्ताह ख़त्म हो रहा है. एक अच्छा क्षण नोट करें.';

  @override
  String get nudgeSaturday => 'धीमा शनिवार लिखने के लिए एक अच्छा दिन है।';

  @override
  String get nudgeSunday => 'सप्ताह ख़त्म होने से पहले उस पर नज़र डालें।';

  @override
  String get photoWidgetEmpty =>
      'आपके द्वारा प्रविष्टियों में जोड़ी गई तस्वीरें यहां दिखाई देंगी।';

  @override
  String get channelReminders => 'अनुस्मारक';

  @override
  String get channelOnThisDay => 'इस दिन';

  @override
  String get channelCoach => 'कोच संकेत देता है';

  @override
  String get channelNudges => 'शांत दिनों के बाद कुहनी';

  @override
  String get channelQuickWrite => 'जल्दी लिखो';

  @override
  String get channelBackup => 'बैकअप';

  @override
  String get formatJsonExport => 'JSON (AID Diary निर्यात)';

  @override
  String get aboutModifiedNotice =>
      'डेमिज़ो और योगदानकर्ताओं द्वारा डेली यू का एक संशोधित संस्करण। यह आधिकारिक डेली यू ऐप नहीं है।';

  @override
  String get toolbarPhotos => 'फ़ोटो जोड़ें';

  @override
  String get toolbarMedia => 'तस्वीरें और वीडियो';

  @override
  String get mediaFromGallery => 'गैलरी से चुनें';

  @override
  String get mediaFromFiles => 'फ़ाइलों में से चुनें';

  @override
  String get editorLeaveTitle => 'यह प्रविष्टि सहेजें?';

  @override
  String get editorLeaveDiscard => 'बचाओ मत';

  @override
  String get editorTitleHint => 'शीर्षक';

  @override
  String get editorLocating => 'पता लगाया जा रहा है...';

  @override
  String get toolbarVideo => 'वीडियो';

  @override
  String get toolbarAudio => 'ध्वनि नोट';

  @override
  String get toolbarTags => 'टैग';

  @override
  String get toolbarBulletList => 'बुलेटेड सूची';

  @override
  String get toolbarHeading => 'शीर्षक';

  @override
  String get toolbarBold => 'साहसी';

  @override
  String get toolbarItalic => 'इटैलिक';

  @override
  String get toolbarHighlight => 'हाइलाइट करें';

  @override
  String get toolbarStrikethrough => 'स्ट्राइकथ्रू';

  @override
  String get toolbarQuote => 'उद्धरण';

  @override
  String get toolbarLink => 'लिंक';

  @override
  String get toolbarInsert => 'सम्मिलित करें';

  @override
  String get toolbarUndo => 'पूर्ववत करें';

  @override
  String get toolbarRedo => 'पुनः करें';

  @override
  String get toolbarInsertDate => 'दिनांक डालें';

  @override
  String get toolbarInsertTime => 'समय डालें';

  @override
  String get settingsSyncTitle => 'क्लाउड सिंक';

  @override
  String get syncOffDescription =>
      'इस डायरी को Google Drive या WebDAV सर्वर, जैसे नेक्स्टक्लाउड, सिनोलॉजी या जियांगुओयुन के माध्यम से अपने सभी उपकरणों पर समान रखें।';

  @override
  String get syncUseGoogleDrive => 'Google Drive के साथ सिंक करें';

  @override
  String get syncOrWebDav => 'या एक WebDAV सर्वर';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn =>
      'साइन इन किया गया। आप AID Diary पर वापस जा सकते हैं।';

  @override
  String get syncGoogleSignInAgain =>
      'Google को आपको दोबारा साइन इन करना होगा.';

  @override
  String get syncSignInAgain => 'पुनः साइन इन करें';

  @override
  String get settingsCommandLineTitle => 'कमांड लाइन';

  @override
  String get commandLineToggle => 'कमांड लाइन इंटरफ़ेस';

  @override
  String get commandLineToggleHint =>
      'इस डिवाइस पर सहायता कमांड और अन्य प्रोग्राम को ऐप के कमांड का उपयोग करने दें।';

  @override
  String get commandLineAlwaysOn => 'सदैव विकास कार्यों में लगा रहता है।';

  @override
  String commandLineListening(int port) {
    return 'पोर्ट $port पर सुन रहा हूँ';
  }

  @override
  String get commandPaletteTitle => 'सभी आदेश';

  @override
  String get commandPaletteSearch => 'आदेश खोजें';

  @override
  String get commandPaletteRun => 'भागो';

  @override
  String get commandPaletteConfirm =>
      'इसे यूं ही पूर्ववत नहीं किया जा सकता. इसे चलाने के लिए?';

  @override
  String syncReceiving(int done, int total) {
    return '$total का $done प्राप्त हो रहा है…';
  }

  @override
  String syncSending(int done, int total) {
    return '$total का $done भेजा जा रहा है...';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'Google Drive तक पहुंच की अनुमति नहीं थी। फिर से कनेक्ट करें और Google के पेज पर Google Drive पर टिक करें।';

  @override
  String get syncEntryUnsynced => 'समन्वयित नहीं: अंतिम समन्वयन नहीं हुआ';

  @override
  String get syncUseOfficial => 'AID सिंक सर्वर का उपयोग करें';

  @override
  String get syncServer => 'सर्वर पता';

  @override
  String get syncUsername => 'उपयोगकर्ता नाम';

  @override
  String get syncPassword => 'पासवर्ड';

  @override
  String get syncConnect => 'कनेक्ट करें';

  @override
  String get syncConnecting => 'कनेक्ट हो रहा है...';

  @override
  String get syncSignInFailed =>
      'साइन इन नहीं किया जा सका। पता, उपयोगकर्ता नाम और पासवर्ड जांचें।';

  @override
  String syncConnectFailed(String error) {
    return 'कनेक्ट नहीं हो सका: $error';
  }

  @override
  String get syncNewSpaceTitle => 'समन्वयन प्रारंभ करें';

  @override
  String get syncNewSpaceDescription =>
      'यहां अभी तक कोई सिंक की गई डायरी नहीं है. यह डायरी अपलोड की जाएगी, एक कुंजी के साथ शुरू से अंत तक एन्क्रिप्टेड जो आपके डिवाइस पर रहेगी।';

  @override
  String get syncJoinTitle => 'सिंक की गई डायरी से जुड़ें';

  @override
  String get syncWrongKey =>
      'यह पुनर्प्राप्ति कोड सिंक की गई डायरी को नहीं खोलता है.';

  @override
  String syncLastSynced(String time) {
    return 'अंतिम बार $time समन्वयित किया गया';
  }

  @override
  String get syncNever => 'अभी तक सिंक नहीं हुआ';

  @override
  String get syncSyncing => 'सिंक हो रहा है...';

  @override
  String syncFailed(String error) {
    return 'अंतिम समन्वयन विफल: $error';
  }

  @override
  String get syncLocked =>
      'सिंक की गई डायरी अब अन्य उपकरणों से संबंधित है, या फिर से शुरू की गई थी। उनमें से किसी एक के साथ युग्मित करें या समन्वयन जारी रखने के लिए पुनर्प्राप्ति कोड का उपयोग करें।';

  @override
  String get syncNow => 'अभी सिंक करें';

  @override
  String get syncUnlock => 'अनलॉक';

  @override
  String get syncEncrypted => 'एंड-टू-एंड एन्क्रिप्टेड';

  @override
  String get syncDisconnect => 'सिंक करना बंद करें';

  @override
  String get syncDisconnectDescription =>
      'यह डिवाइस सिंक करना बंद कर देता है. यहां डायरी और सिंक की गई कॉपी वैसे ही रहती है।';

  @override
  String get syncOwnRecoveryPassword =>
      'मेरे अपने पुनर्प्राप्ति पासवर्ड का उपयोग करें';

  @override
  String get syncRecoveryPassword => 'पुनर्प्राप्ति पासवर्ड';

  @override
  String get syncRecoveryPasswordRepeat => 'पुनर्प्राप्ति पासवर्ड दोहराएँ';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'कम से कम $min वर्णों का उपयोग करें';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'पासवर्ड अलग-अलग हैं';

  @override
  String get syncRecoveryCode => 'पुनर्प्राप्ति कोड';

  @override
  String get syncRecoveryCodeTitle => 'अपना पुनर्प्राप्ति कोड सहेजें';

  @override
  String get syncRecoveryCodeDescription =>
      'यदि आपका प्रत्येक उपकरण खो जाता है, तो यह कोड आपकी सिंक की गई डायरी को पुनर्स्थापित करता है। इसे पासवर्ड मैनेजर या कागज पर रखें। इसे सिर्फ एक बार ही दिखाया गया है.';

  @override
  String get syncRecoveryCodeCopied => 'पुनर्प्राप्ति कोड कॉपी किया गया';

  @override
  String get syncRecoveryCodeSaved => 'मैंने इसे सेव कर लिया है';

  @override
  String get syncJoinNeedsKey =>
      'यह समन्वयित डायरी आपके अन्य उपकरणों से संबंधित है। उनमें से किसी एक के साथ युग्मित करें, या पुनर्प्राप्ति कोड का उपयोग करें। इस डिवाइस की प्रविष्टियाँ इसमें जोड़ दी जाएंगी.';

  @override
  String get syncPairDevice => 'किसी डिवाइस के साथ युग्मित करें';

  @override
  String get syncUseRecoveryCode => 'पुनर्प्राप्ति कोड का उपयोग करें';

  @override
  String get syncAddDevice => 'एक उपकरण जोड़ें';

  @override
  String get syncChangeRecoveryCode => 'पुनर्प्राप्ति कोड बदलें';

  @override
  String get syncChangeRecoveryDescription =>
      'एक नया कोड मौजूदा कोड की जगह लेता है, जो काम करना बंद कर देता है। आपका डेटा और अन्य डिवाइस वैसे ही रहेंगे जैसे वे हैं।';

  @override
  String get syncNewRandomCode => 'नया यादृच्छिक कोड';

  @override
  String get syncRecoveryCodeChanged => 'पुनर्प्राप्ति कोड बदल गया';

  @override
  String get syncResetSpace => 'सिंक की गई डायरी को फिर से प्रारंभ करें';

  @override
  String get syncResetSpaceDescription =>
      'केवल तभी जब कोई डिवाइस और कोई पुनर्प्राप्ति कोड इसे नहीं खोलता है: सिंक की गई प्रतिलिपि को इस डिवाइस की कुंजी के तहत इस डिवाइस पर डायरी द्वारा प्रतिस्थापित किया जाता है। आपके अन्य उपकरण फिर से जुड़ जाते हैं।';

  @override
  String get syncPairTitle => 'उपकरण युग्मित करें';

  @override
  String get syncPairShow => 'एक कोड दिखाएँ';

  @override
  String get syncPairEnter => 'एक कोड दर्ज करें';

  @override
  String get syncPairShowHint =>
      'अपने अन्य डिवाइस पर, पेयर डिवाइस खोलें, एक कोड दर्ज करें चुनें और इसे टाइप करें या स्कैन करें।';

  @override
  String get syncPairEnterHint =>
      'वह कोड टाइप करें जो आपका अन्य डिवाइस दिखाता है, या उसे स्कैन करें।';

  @override
  String get syncPairCode => 'युग्मन कोड';

  @override
  String get syncPairScan => 'स्कैन करें';

  @override
  String get syncPairStart => 'जोड़ी';

  @override
  String get syncPairWaiting => 'अन्य डिवाइस की प्रतीक्षा की जा रही है...';

  @override
  String syncPairDone(String device) {
    return '$device के साथ युग्मित';
  }

  @override
  String get syncPairWrongCode =>
      'कोड मेल नहीं खाता. नया कोड दिखाएँ और पुनः प्रयास करें।';

  @override
  String get syncPairNoOffer =>
      'कोई भी डिवाइस यह कोड नहीं दिखाता. हो सकता है कि यह समाप्त हो गया हो.';

  @override
  String get syncPairTimedOut => 'दूसरे उपकरण ने समय पर उत्तर नहीं दिया।';

  @override
  String get syncPairNeither =>
      'इस सिंक की गई डायरी के साथ अभी तक कोई भी डिवाइस सेट नहीं किया गया है।';

  @override
  String get syncPairBoth =>
      'दोनों डिवाइस पहले से ही इस सिंक की गई डायरी को खोलते हैं।';

  @override
  String syncPairFailed(String error) {
    return 'युग्मन विफल: $error';
  }

  @override
  String get syncMediaPending =>
      'डायरी सिंक हो गई · कुछ मीडिया अभी भी स्थानांतरित हो रहा है';

  @override
  String get syncWaitingForDevices =>
      'डायरी सिंक हो गई · मीडिया स्थानांतरित करने के लिए किसी अन्य डिवाइस की प्रतीक्षा की जा रही है';

  @override
  String get syncCacheNotice =>
      'क्लाउड मीडिया अस्थायी है. अपने डिवाइस पर मूल प्रतियाँ रखें; सिंक करना बैकअप नहीं है.';

  @override
  String get paperTitle => 'पत्र पत्र';

  @override
  String get paperPlain => 'सादा';

  @override
  String get paperLined => 'पंक्तिबद्ध';

  @override
  String get paperGrid => 'ग्रिड';

  @override
  String get paperTinted => 'रंगा हुआ';

  @override
  String get paperDecorationTitle => 'सजावट';

  @override
  String get paperDecorationNone => 'कोई नहीं';

  @override
  String get paperDecorationBotanical => 'पत्तियां';

  @override
  String get paperDecorationStars => 'सितारे';

  @override
  String get paperDecorationWashi => 'वाशी टेप';

  @override
  String get themeDarkChoice => 'गहरा रूप';

  @override
  String get themeDarkSame => 'लाइट पैलेट का पालन करें';

  @override
  String get themeDarkCustom => 'अलग पैलेट';

  @override
  String get themeDarkAccent => 'गहरा उच्चारण रंग';

  @override
  String get themeColorTeal => 'चैती';

  @override
  String get themeColorCyan => 'सियान';

  @override
  String get themeColorIndigo => 'इंडिगो';

  @override
  String get themeColorCoral => 'मूंगा';

  @override
  String get themeColorOlive => 'जैतून';

  @override
  String get themeColorSlate => 'स्लेट';

  @override
  String get drawingTitle => 'चित्रकारी';

  @override
  String get drawingPen => 'कलम';

  @override
  String get drawingEraser => 'मिटाने वाला';

  @override
  String get drawingUndo => 'पूर्ववत करें';

  @override
  String get drawingClear => 'स्पष्ट';

  @override
  String get drawingWidth => 'कलम की चौड़ाई';

  @override
  String get drawingStylusOnly => 'केवल स्टाइलस';

  @override
  String get drawingDiscardTitle => 'ड्राइंग त्यागें?';

  @override
  String get drawingDiscardBody => 'यह चित्र सहेजा नहीं गया है.';

  @override
  String get drawingSaveError => 'आरेखण सहेजा नहीं जा सका.';

  @override
  String get syncNetworkTitle => 'नेटवर्क डायग्नोस्टिक्स';

  @override
  String get syncNetworkRefresh => 'ताज़ा करें';

  @override
  String get syncNetworkSelectedRoute => 'वर्तमान पथ';

  @override
  String get syncNetworkAvailableRoutes => 'उपलब्ध पथ';

  @override
  String get syncNetworkSignaling => 'डिवाइस निर्देशिका कनेक्शन';

  @override
  String get syncNetworkRelayRemaining => 'शेष रिले भत्ता';

  @override
  String get syncNetworkIcePair => 'सीधा कनेक्शन उम्मीदवार';

  @override
  String get syncNetworkPeerTrusted => 'प्रमाणित डिवाइस';

  @override
  String get syncNetworkNoRoute => 'कनेक्शन की प्रतीक्षा की जा रही है';

  @override
  String get syncNetworkUnavailable => 'निदान उपलब्ध नहीं हैं';

  @override
  String get syncMediaCopiesTitle => 'मीडिया डिलीवरी और प्रतियां';

  @override
  String get syncMediaPendingCount => 'स्थानांतरण की प्रतीक्षा की जा रही है';

  @override
  String get syncMediaDurableCount => 'व्यक्तिगत भंडारण में वितरित किया गया';

  @override
  String get syncMediaTemporaryCount => 'अस्थायी या अपुष्ट प्रतिलिपियाँ';

  @override
  String get syncMediaReceiptExplanation =>
      'ये गणनाएँ पूर्ण डिलीवरी का वर्णन करती हैं, न कि जीवित बैकअप के ताज़ा ऑडिट का।';

  @override
  String get syncMediaCacheExplanation =>
      'अस्थायी क्लाउड मीडिया समाप्त हो सकता है. अपनी मूल प्रतियाँ या एक अलग बैकअप रखें।';

  @override
  String get momentsTitle => 'फोटो क्षण';

  @override
  String get momentsHint =>
      'स्थानीय फोटो समय और वैकल्पिक निर्देशांक का उपयोग करके समूह ढूंढें। फ़ोटो केवल तभी संलग्न की जाती हैं जब आप कोई कार्ड चुनते हैं।';

  @override
  String get momentsScan => 'क्षण खोजें';

  @override
  String get momentsChooseFolder => 'फोटो फ़ोल्डर चुनें';

  @override
  String get momentsLocation => 'फ़ोटो स्थान शामिल करें';

  @override
  String get momentsEmpty => 'कोई हालिया फ़ोटो समूह नहीं.';

  @override
  String get momentsCreate => 'इन तस्वीरों के बारे में लिखें';

  @override
  String get momentsDismiss => 'ख़ारिज करें';

  @override
  String get momentsError => 'स्थानीय फ़ोटो नहीं पढ़ सका.';

  @override
  String get momentsCreated => 'फोटो प्रविष्टि बनाई गई.';

  @override
  String get momentsPermission =>
      'स्थानीय सुझाव ढूंढने के लिए फ़ोटो तक पहुंच की अनुमति दें।';

  @override
  String get momentsScope =>
      'केवल हाल की तस्वीरें; अधिकतम 500 फ़ोटो और प्रति कार्ड 20 फ़ोटो।';

  @override
  String momentsPhotoCount(int count) {
    return '$count तस्वीरें';
  }

  @override
  String get nearbyTitle => 'डिवाइस कनेक्ट करें';

  @override
  String get nearbySend => 'किसी अन्य डिवाइस को अधिकृत करें';

  @override
  String get nearbyReceive => 'किसी मौजूदा डिवाइस से कनेक्ट करें';

  @override
  String get nearbyInstructions =>
      'दोनों डिवाइस को एक ही Wi-Fi या एक दूसरे के हॉटस्पॉट से कनेक्ट करें। मौजूदा डिवाइस पर प्राधिकरण की पुष्टि करें; दोनों उपकरण प्रयोग योग्य बने रहते हैं। इंटरनेट की आवश्यकता नहीं है.';

  @override
  String get nearbyCompare =>
      'अनुमोदन देने से पहले दोनों डिवाइस पर इस कोड की तुलना करें।';

  @override
  String get nearbyConfirm => 'कोड मेल खाते हैं';

  @override
  String get nearbyScan => 'दूसरे डिवाइस का कोड स्कैन करें';

  @override
  String get nearbyPaste => 'निमंत्रण चिपकाएँ';

  @override
  String get nearbyWaiting =>
      'अन्य डिवाइस पर अनुमोदन की प्रतीक्षा की जा रही है';

  @override
  String get nearbyWorking =>
      'आपकी डायरी और अनुलग्नकों को अधिकृत और समन्वयित किया जा रहा है...';

  @override
  String get nearbyPending =>
      'कुछ अनुलग्नकों को अभी भी समन्वयन की आवश्यकता है. अन्य डिवाइस को ऑनलाइन रखें और पुनः प्रयास करें।';

  @override
  String get nearbyComplete => 'डिवाइस कनेक्टेड; डायरी और अनुलग्नक समन्वयित';

  @override
  String get nearbyFailed =>
      'कनेक्शन ख़त्म नहीं हुआ. स्थानीय कनेक्शन की जाँच करें और पुनः प्रयास करें।';

  @override
  String get nearbyEmptyRequired =>
      'एक खाली डायरी वाले उपकरण का उपयोग करें जो अभी तक सिंक से कनेक्ट नहीं है।';

  @override
  String get nearbyRetry => 'समन्वयन जारी रखें';

  @override
  String get nearbyWifi => 'Wi-Fi सेटिंग्स';

  @override
  String get nearbyHotspot => 'हॉटस्पॉट सेटिंग्स';

  @override
  String get nearbyKeepOpen =>
      'नया उपकरण समाप्त होने तक इस पृष्ठ को खुला रखें। आमंत्रण दो मिनट बाद समाप्त हो जाता है.';

  @override
  String get syncDevicesTitle => 'अधिकृत उपकरण';

  @override
  String get syncDevicesDescription =>
      'केवल स्वीकृत डिवाइस ही इस AID खाते तक पहुंच सकते हैं। किसी डिवाइस को रद्द करने से सर्वर ब्लॉक हो जाता है लेकिन उसमें पहले से कॉपी की गई मास्टर कुंजी या डायरी को नहीं मिटाया जा सकता है।';

  @override
  String get syncDeviceRequest =>
      'इस प्राधिकरण QR को किसी स्वीकृत डिवाइस पर दिखाएं';

  @override
  String get syncDeviceAuthorize => 'किसी डिवाइस को अधिकृत करें';

  @override
  String get syncDeviceAuthorizeDescription =>
      'नए डिवाइस के प्राधिकरण अनुरोध को स्कैन या पेस्ट करें।';

  @override
  String get syncDeviceRevoke => 'निरस्त करें';

  @override
  String get syncDeviceRotate => 'इस डिवाइस की साइनिंग कुंजी घुमाएँ';

  @override
  String get syncDeviceCheck => 'प्राधिकरण की जाँच करें';

  @override
  String get syncDeviceHardware => 'हार्डवेयर-समर्थित हस्ताक्षर कुंजी';

  @override
  String get syncDeviceSoftware =>
      'गैर-निर्यात योग्य सॉफ़्टवेयर हस्ताक्षर कुंजी';

  @override
  String get syncDeviceUnavailable =>
      'डिवाइस प्राधिकरण अनुपलब्ध है. किसी अन्य अधिकृत डिवाइस से इस डिवाइस को स्वीकृत करें और पुनः प्रयास करें।';

  @override
  String get syncDeviceRevoked => 'निरस्त किया गया';

  @override
  String get syncDeviceLocal => 'यह उपकरण';

  @override
  String get cloudTrafficTitle =>
      'मीडिया फ़ाइलों के लिए मासिक क्लाउड डेटा स्थानांतरण कोटा';

  @override
  String get cloudTrafficLimit => 'मासिक डेटा स्थानांतरण कोटा';

  @override
  String get cloudTrafficUsed => 'डेटा ट्रांसफर का उपयोग किया गया';

  @override
  String get cloudTrafficRemaining => 'डेटा स्थानांतरण शेष है';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'डेटा ट्रांसफर कोटा $time रीसेट हो जाता है';
  }

  @override
  String get cloudTrafficExhausted =>
      'मीडिया फ़ाइलों के लिए क्लाउड डेटा ट्रांसफर कोटा का उपयोग किया जा चुका है। सीधा कनेक्शन उपलब्ध होने या कोटा रीसेट होने पर गुम मीडिया फ़ाइलें स्वचालित रूप से सिंक हो जाएंगी।';

  @override
  String get cloudTrafficExplanation =>
      'मीडिया फ़ाइल कैशिंग और लाइव रिले इस डेटा ट्रांसफर कोटा को साझा करते हैं। प्रत्यक्ष कनेक्शन इसका उपभोग नहीं करते. डायरी पाठ और कनेक्शन नियंत्रण संदेशों की अलग-अलग छोटी दैनिक सीमाएँ होती हैं।';

  @override
  String get appearanceThemeSection => 'ऐप थीम';

  @override
  String get appearancePaperSection => 'डायरी का कागज';

  @override
  String get appearanceTypographySection => 'डायरी का पाठ';

  @override
  String get appearancePreferencesSection => 'सामान्य प्राथमिकताएँ';

  @override
  String get themeSystemAccentHint =>
      'कस्टम रंगों के बजाय सिस्टम पैलेट का उपयोग करता है। अपना स्वयं का चयन करने के लिए इसे बंद करें.';

  @override
  String get syncDeviceNameSaveFailed =>
      'डिवाइस का नाम सहेजा नहीं जा सका. कृपया पुन: प्रयास करें।';

  @override
  String get nearbyConnectionHelp => 'कनेक्शन सहायता';

  @override
  String get syncAllSynced => 'सब कुछ समन्वयित हो गया';

  @override
  String get syncDetailsTitle => 'विवरण सिंक करें';

  @override
  String get syncMore => 'अधिक विकल्प';

  @override
  String get syncDeviceName => 'डिवाइस का नाम';

  @override
  String get syncDeviceNameHint => 'उदाहरण के लिए: मेरा टैबलेट';

  @override
  String get syncDeviceNameInvalid => '1 से 32 अक्षरों का प्रयोग करें';

  @override
  String get syncDeviceKeyDetails => 'सुरक्षा विवरण';

  @override
  String get syncConnectionProblem =>
      'अभी सिंक करने में असमर्थ. स्वचालित रूप से पुनः प्रयास किया जा रहा है.';

  @override
  String get syncCopyComplete =>
      'आपकी डायरी और मीडिया फ़ाइलों की पूरी प्रतिलिपि';

  @override
  String get syncCopyPartial => 'कुछ मीडिया अभी भी गायब है';

  @override
  String get syncCopyOlder => 'नए परिवर्तन सिंक होने की प्रतीक्षा कर रहे हैं';

  @override
  String get syncCopyUnavailable =>
      'प्रतिलिपि विवरण उपलब्ध नहीं हैं. बाद में पुन: प्रयास।';

  @override
  String get syncCopyLastKnown =>
      'अन्य डिवाइस अपनी अंतिम पुष्टि की गई प्रति दिखाते हैं। अब ऑफ़लाइन डिवाइस की जाँच नहीं की जा सकती.';

  @override
  String get syncCopyTemporary =>
      'अस्थायी कैश. अपने डिवाइस पर मूल प्रतियाँ रखें.';

  @override
  String get syncCopyStorage =>
      'आपका सिंक स्टोरेज. पूर्ण मीडिया अपलोड डायग्नोस्टिक्स में सूचीबद्ध हैं।';

  @override
  String syncCopyChecked(String time) {
    return 'अंतिम पुष्टि $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'इस माह शेष डेटा स्थानांतरण: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'यहां से प्रारंभ करें';

  @override
  String get onboardConnect => 'किसी मौजूदा डिवाइस से कनेक्ट करें';

  @override
  String get onboardFailed =>
      'सेटअप पूरा नहीं किया जा सका. आपकी डायरी सुरक्षित है; कृपया पुन: प्रयास करें।';

  @override
  String get tutorialTitle => 'डायरी का उपयोग कैसे करें';

  @override
  String get tutorialWriteTitle => 'अपनी पहली डायरी प्रविष्टि लिखें';

  @override
  String get tutorialWriteText =>
      'डायरी प्रविष्टि लिखने के लिए + टैप करें। एक वैकल्पिक शीर्षक जोड़ें, डायरी की तारीख चुनें और सहेजने के लिए चेक मार्क पर टैप करें। आप किसी भी समय अपनी डायरी प्रविष्टि को दोबारा संपादित कर सकते हैं।';

  @override
  String get tutorialMediaTitle => 'फ़ोटो, ऑडियो या लिखावट जोड़ें';

  @override
  String get tutorialMediaText =>
      'फ़ोटो, वीडियो या वॉयस रिकॉर्डिंग संलग्न करने या लिखावट कैनवास खोलने के लिए डायरी संपादक में + का उपयोग करें। ये अनुलग्नक डायरी प्रविष्टि के साथ सहेजे जाते हैं।';

  @override
  String get tutorialReviewTitle => 'फिर से एक दिन ढूंढो';

  @override
  String get tutorialReviewText =>
      'अपनी डायरी या कैलेंडर ब्राउज़ करें, अपना लेखन खोजें, और टैग के साथ प्रविष्टियाँ व्यवस्थित करें। मीडिया और एटलस पेज आपको फोटो या स्थान के आधार पर पिछली प्रविष्टियाँ ढूंढने देते हैं।';

  @override
  String get tutorialSyncTitle => 'एक से अधिक डिवाइस का उपयोग करें';

  @override
  String get tutorialSyncText =>
      'सेटिंग्स → डेटा और स्टोरेज → सिंक में, किसी मौजूदा डिवाइस से कनेक्ट करें और उस डिवाइस पर प्राधिकरण की पुष्टि करें। दोनों डिवाइस डायरी का उपयोग जारी रख सकते हैं। डायरी का पाठ पहले सिंक होता है। मीडिया फ़ाइलें तब सिंक होती हैं जब नेटवर्क कनेक्शन और शेष डेटा ट्रांसफर कोटा इसकी अनुमति देता है।';

  @override
  String get tutorialPrivacyTitle => 'अपनी डायरी सुरक्षित रखें';

  @override
  String get tutorialPrivacyText =>
      'डायरी प्रविष्टियाँ इस डिवाइस पर तब तक रहती हैं जब तक आप सिंक सक्षम नहीं करते या उन्हें साझा या निर्यात नहीं करते। सिंक एंड-टू-एंड एन्क्रिप्टेड है. सेटिंग्स में आप एक ऐप पासकोड भी सेट कर सकते हैं, बैकअप बना सकते हैं और इस ट्यूटोरियल को फिर से खोल सकते हैं।';

  @override
  String get editorDiaryDay => 'डायरी का दिन';

  @override
  String get editorDiaryDayPicker => 'डायरी का दिन · बनाने का समय नहीं बदलता';

  @override
  String get editorDiaryDayHint =>
      'वह दिन जिससे यह प्रविष्टि संबंधित है। इसे बदलने से प्रविष्टि बनाने का समय नहीं बदलता।';

  @override
  String get hiddenDiaryTitle => 'छिपी हुई प्रविष्टियाँ';

  @override
  String get hiddenDiaryHide => 'प्रविष्टि छिपाएँ';

  @override
  String get hiddenDiaryShow => 'प्रविष्टि दिखाएँ';

  @override
  String get hiddenDiaryEmpty => 'कोई छिपी हुई प्रविष्टि नहीं';

  @override
  String get hiddenDiaryUnlock => 'छिपी हुई प्रविष्टियाँ अनलॉक करें';

  @override
  String get hiddenDiaryAuthHint =>
      'ऐप लॉक या अपने डिवाइस के स्क्रीन लॉक का उपयोग करें।';

  @override
  String get moodClear => 'मनःस्थिति हटाएँ';

  @override
  String get scrollToTop => 'ऊपर जाएँ';

  @override
  String get feedbackTitle => 'प्रतिक्रिया';

  @override
  String get feedbackHint => 'समस्या या सुझाव बताएँ';

  @override
  String get feedbackGithub => 'GitHub पर मुद्दा';

  @override
  String get feedbackEmail => 'ईमेल भेजें';

  @override
  String get feedbackCopy => 'टेक्स्ट कॉपी करें';

  @override
  String get feedbackLaunchFailed =>
      'ऐप नहीं खुल सका। टेक्स्ट कॉपी करके नीचे दिए ईमेल का उपयोग करें।';

  @override
  String get feedbackCopied => 'प्रतिक्रिया कॉपी हुई';
}
