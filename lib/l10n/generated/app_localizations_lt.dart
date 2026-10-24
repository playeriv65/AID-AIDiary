// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Lithuanian (`lt`).
class AppLocalizationsLt extends AppLocalizations {
  AppLocalizationsLt([String locale = 'lt']) : super(locale);

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => 'Temos spalva';

  @override
  String get themeColorHint => 'Pasirinkite šios paletės spalvą.';

  @override
  String get themeColorBlue => 'Dangaus mėlyna';

  @override
  String get themeColorGreen => 'Miškas žalias';

  @override
  String get themeColorBrown => 'Šilta kava';

  @override
  String get themeColorPurple => 'Levandos';

  @override
  String get themeColorRose => 'Dulkėta rožė';

  @override
  String get themeColorAmber => 'Gintaras';

  @override
  String get themeColorPreview => 'Kasdien po truputį';

  @override
  String get themeTintBackgroundTitle => 'Nuspalvinkite foną temos spalvomis';

  @override
  String get themeTintBackgroundHint =>
      'Išjunkite, kad fonas būtų neutralus pilkas; mygtukai išlaiko jūsų pasirinktą spalvą.';

  @override
  String get dailyReminderTitle => 'Parašykite šiandien įrašą!';

  @override
  String get dailyReminderDescription => 'Parašykite kasdienį žurnalo įrašą…';

  @override
  String get actionTakePhoto => 'Fotografuoti';

  @override
  String get flashbacksTitle => 'Žvilgsniai į praeitį';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Neįtraukti blogų dienų';

  @override
  String get flashbackGoodDay => 'Gera diena';

  @override
  String get flashbackRandomDay => 'Atsitiktinė diena';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'prieš $count savaitę',
      many: 'prieš $count savaičių',
      few: 'prieš $count savaites',
      one: 'prieš $count savaitę',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'prieš $count mėnesį',
      many: 'prieš $count mėnesių',
      few: 'prieš $count mėnesius',
      one: 'prieš $count mėnesį',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'prieš $count metus',
      many: 'prieš $count metų',
      few: 'prieš $count metus',
      one: 'prieš $count metus',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'Šią dieną';

  @override
  String get searchLogsHint => 'Ieškoti žurnalo įrašų…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count žurnalo įrašas',
      many: '$count žurnalo įrašų',
      few: '$count žurnalo įrašai',
      one: '$count žurnalo įrašas',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count diena',
      many: '$count dienų',
      few: '$count dienos',
      one: '$count diena',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count žodis',
      many: '$count žodžių',
      few: '$count žodžiai',
      one: '$count žodis',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Nėra žurnalo įrašų…';

  @override
  String get noResults => 'Rezultatų nėra…';

  @override
  String get sortOrderAscendingTitle => 'Didėjančiai';

  @override
  String get sortOrderDescendingTitle => 'Mažėjančiai';

  @override
  String get pageStatisticsTitle => 'Statistika';

  @override
  String get statisticsNotEnoughData => 'Nepakanka duomenų…';

  @override
  String get statisticsRangeOneMonth => '1 mėnesis';

  @override
  String get statisticsRangeSixMonths => '6 mėnesiai';

  @override
  String get statisticsRangeOneYear => '1 metai';

  @override
  String get statisticsRangeAllTime => 'Visas laikas';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag santrauka';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag pagal dieną';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag bėgant laikui';
  }

  @override
  String get chartGroupingLabel => 'Grupuoti pagal';

  @override
  String get chartGroupingDay => 'Diena';

  @override
  String get chartGroupingWeek => 'Savaitė';

  @override
  String get chartGroupingMonth => 'Mėnesis';

  @override
  String get chartGroupingYear => 'Metai';

  @override
  String get chartSmoothingLabel => 'Glodinimas';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dabartinė seka $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ilgiausia seka $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Puikios dienos $count',
      one: 'Puikios dienos $count',
      many: 'Didžiosios dienos $count',
      few: 'Puikios dienos $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Praėjo dienų nuo paskutinės blogos dienos: $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Nepavyksta pasiekti išorinės saugyklos';

  @override
  String get errorExternalStorageAccessDescription =>
      'Jei naudojate saugyklą tinkle, įsitikinkite, kad paslauga veikia ir turite prieigą prie tinklo.\n\nPriešingu atveju, gali būti, jog programėlė prarado prieigą prie išorinio aplanko. Eikite į nustatymus ir iš naujo pasirinkite išorinį aplanką, kad suteiktumėte prieigą.\n\nĮspėjimas: pakeitimai nebus sinchronizuojami tol, kol neatkursite prieigos prie išorinės saugyklos vietos!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Tęsti naudojant vietinę duomenų bazę';

  @override
  String get lastModified => 'Modifikuotas';

  @override
  String get writeSomethingHint => 'Parašykite ką nors…';

  @override
  String get titleHint => 'Pavadinimas…';

  @override
  String get deleteLogTitle => 'Ištrinti žurnalo įrašą';

  @override
  String get deleteLogDescription => 'Ar norite ištrinti šį žurnalo įrašą?';

  @override
  String get deletePhotoTitle => 'Ištrinti nuotrauką';

  @override
  String get deletePhotoDescription => 'Ar norite ištrinti šią nuotrauką?';

  @override
  String get pageSettingsTitle => 'Nustatymai';

  @override
  String get settingsTheme => 'Apipavidalinimas';

  @override
  String get themeSystem => 'Sisteminis';

  @override
  String get themeLight => 'Šviesus';

  @override
  String get themeDark => 'Tamsus';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Pirmoji savaitės diena';

  @override
  String get settingsCalendarSystem => 'Kalendoriaus sistema';

  @override
  String get calendarSystemGregorian => 'Grigaliaus';

  @override
  String get calendarSystemJalali => 'Jalali';

  @override
  String get settingsUseSystemAccentColor =>
      'Naudoti sisteminę paryškinimo spalvą';

  @override
  String get settingsCustomAccentColor => 'Tinkinta paryškinimo spalva';

  @override
  String get settingsShowFlashbacks => 'Rodyti žvilgsnius į praeitį';

  @override
  String get settingsChangeMoodIcons => 'Keisti nuotaikos piktogramas';

  @override
  String get moodIconPrompt => 'Įveskite piktogramą (jaustuką)';

  @override
  String get settingsHideImages => 'Slėpti paveikslus';

  @override
  String get pageCalendarTitle => 'Kalendorius';

  @override
  String get settingsNotificationsTitle => 'Pranešimai';

  @override
  String get settingsDailyReminderTitle => 'Kasdienis priminimas';

  @override
  String get settingsOnThisDayDescription =>
      'Iš naujo peržiūrėti praeities prisiminimus';

  @override
  String get settingsDailyReminderDescription =>
      'Švelnus priminimas kiekvieną dieną';

  @override
  String get settingsReminderTime => 'Priminimo laikas';

  @override
  String get settingsFixedReminderTimeTitle => 'Fiksuotas priminimo laikas';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Pasirinkti konkretų priminimo laiką';

  @override
  String get settingsAlwaysSendReminderTitle => 'Visada rodyti priminimą';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Rodyti priminimą netgi tuo atveju, kai žurnalo įrašas jau pradėtas';

  @override
  String get settingsCustomizeNotificationTitle => 'Tinkinti pranešimus';

  @override
  String get settingsTemplatesTitle => 'Šablonai';

  @override
  String get manageTemplates => 'Tvarkyti šablonus';

  @override
  String get noTemplateTitle => 'Nėra';

  @override
  String get noTemplatesDescription => 'Kol kas nėra sukurtų šablonų…';

  @override
  String get templateDefaultTimestampTitle => 'Laiko žyma';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Dienos santrauka';

  @override
  String get templateDefaultSummaryBody =>
      '### Santrauka\n- \n\n### Citata\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Apmąstymas';

  @override
  String get templateDefaultReflectionBody =>
      '### Kas jums šiandien patiko?\n- \n\n### Už ką esate dėkingi?\n- \n\n### Ko laukiate ar tikitės?\n- ';

  @override
  String get settingsTagsTitle => 'Žymos';

  @override
  String get manageTags => 'Tvarkyti žymas';

  @override
  String get tagTypeLabelTitle => 'Etiketė';

  @override
  String get tagTypeTrackerTitle => 'Tracker';

  @override
  String get nameHint => 'Vardas';

  @override
  String get tagColorLabel => 'Spalva';

  @override
  String get iconPickerTitle => 'Pasirinkite piktogramą';

  @override
  String get iconPickerIconsTab => 'Piktogramos';

  @override
  String get iconPickerCustomTab => 'Pasirinktinis';

  @override
  String get iconPickerSearchHint => 'Ieškoti piktogramų…';

  @override
  String get colorPickerTitle => 'Pasirinkite Spalva';

  @override
  String get colorPickerPaletteTab => 'Spalvos';

  @override
  String get iconGroupMoodPeople => 'Nuotaika ir žmonės';

  @override
  String get iconGroupHealth => 'Sveikata';

  @override
  String get iconGroupWorkFinance => 'Darbas ir finansai';

  @override
  String get iconGroupHabitsGoals => 'Įpročiai ir tikslai';

  @override
  String get iconGroupNature => 'Gamta';

  @override
  String get iconGroupFoodDrink => 'Maistas ir gėrimai';

  @override
  String get iconGroupHome => 'Pradžia';

  @override
  String get iconGroupTravel => 'Kelionės';

  @override
  String get iconGroupSymbols => 'Simboliai';

  @override
  String get tagCategoryLabel => 'Kategorija';

  @override
  String get tagLabel => 'Žyma';

  @override
  String get tagCategoryUncategorized => 'Neįtraukta į kategorijas';

  @override
  String get newCategoryTitle => 'Nauja kategorija';

  @override
  String get shareButtonLabel => 'Dalintis';

  @override
  String get importErrorDescription => 'Nepavyko importuoti failo!';

  @override
  String get exportErrorDescription => 'Nepavyko eksportuoti failo!';

  @override
  String get deleteTitle => 'Ištrinti';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Jis naudojamas $count dienoraščio įrašų.',
      one: ' Jis naudojamas $count dienoraščio įraše.',
      many: ' Jis naudojamas $count dienoraščio įrašuose.',
      few: ' Jis naudojamas $count dienoraščio įrašuose.',
      zero: '',
    );
    return 'Ištrinti „$name“?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Jo $count žymos taip pat bus ištrintos.',
      one: ' Jo $count žyma taip pat bus ištrinta.',
      many: ' Jos $count žymos taip pat bus ištrintos.',
      few: ' Jos $count žymos taip pat bus ištrintos.',
      zero: '',
    );
    return 'Ištrinti „$name“?$_temp0';
  }

  @override
  String get tagNameExists => 'Jau yra žyma tokiu pavadinimu';

  @override
  String get categoryNameExists => 'Kategorija tokiu pavadinimu jau yra';

  @override
  String deleteTemplateMessage(Object name) {
    return 'Ištrinti „$name“?';
  }

  @override
  String get addTagsTitle => 'Pridėti žymas';

  @override
  String get addTagsSearchHint => 'Ieškoti žymų…';

  @override
  String get tagFavoriteName => 'Mėgstamiausias';

  @override
  String get iconGroupActivities => 'Veikla';

  @override
  String get iconGroupHobbies => 'Pramogos';

  @override
  String get settingsStorageTitle => 'Saugykla';

  @override
  String get settingsImageQuality => 'Paveikslų kokybė';

  @override
  String get imageQualityHigh => 'Aukšta';

  @override
  String get imageQualityMedium => 'Vidutinė';

  @override
  String get imageQualityLow => 'Žema';

  @override
  String get imageQualityNoCompression => 'Be glaudinimo';

  @override
  String get settingsLogFolder => 'Žurnalo įrašų aplankas';

  @override
  String get settingsImageFolder => 'Paveikslų aplankas';

  @override
  String get warningTitle => 'Įspėjimas';

  @override
  String get logFolderWarningDescription =>
      'Jei pasirinktame aplanke jau yra \'aid_diary.db\' failas, tada jis bus naudojamas perrašyti jūsų esamus žurnalo įrašus!';

  @override
  String get errorTitle => 'Klaida';

  @override
  String get logFolderErrorDescription =>
      'Nepavyko pakeisti žurnalo įrašų aplanko!';

  @override
  String get imageFolderErrorDescription =>
      'Nepavyko pakeisti paveikslų aplanko!';

  @override
  String get backupErrorDescription => 'Nepavyko sukurti atsarginės kopijos!';

  @override
  String get restoreErrorDescription => 'Nepavyko atkurti atsarginę kopiją!';

  @override
  String get settingsBackupRestoreTitle => 'Atsarginė kopija ir atkūrimas';

  @override
  String get settingsBackup => 'Daryti atsarginę kopiją';

  @override
  String get settingsRestore => 'Atkurti';

  @override
  String get settingsRestorePromptDescription =>
      'Atsarginės kopijos atkūrimas perrašys visus jūsų esamus duomenis!';

  @override
  String get settingsBackupPasswordProtect =>
      'Slaptažodžio apsaugos atsarginės kopijos';

  @override
  String get backupEncryptedTitle => 'Šifruota atsarginė kopija';

  @override
  String get backupEncryptedContent =>
      'Ši atsarginė kopija apsaugota slaptažodžiu.';

  @override
  String get settingsAutoBackup => 'Automatinės atsarginės kopijos';

  @override
  String get settingsAutoBackupLocation => 'Atsarginės kopijos vieta';

  @override
  String get settingsAutoBackupInterval => 'Atsarginės kopijos intervalas';

  @override
  String get settingsAutoBackupIntervalDaily => 'Kasdien';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Kas savaitę';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Kas mėnesį';

  @override
  String get settingsAutoBackupMaxCount =>
      'Atsarginės kopijos, kurias reikia saugoti';

  @override
  String get settingsAutoBackupRequireCharging => 'Tik kraunant';

  @override
  String settingsBackupLast(Object time) {
    return 'Paskutinė atsarginė kopija $time';
  }

  @override
  String get settingsBackupNever => 'Niekada nebuvo sukurta atsarginė kopija';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Kita atsarginė kopija $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'Visi';

  @override
  String get autoBackupFailedTitle => 'Nepavyko sukurti atsarginės kopijos';

  @override
  String tranferStatus(Object percent) {
    return 'Perkeliama… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Kuriama atsarginė kopija… $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Atkuriama atsarginė kopija… $percent%';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return 'Šifruojama atsarginė kopija… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Iššifruojama atsarginė kopija… $percent%';
  }

  @override
  String get cleanUpStatus => 'Tvarkomasi…';

  @override
  String get settingsExportToAnotherFormat => 'Eksportuoti kitu formatu';

  @override
  String get settingsExportFormatDescription =>
      'Tai neturėtų būti naudojama kaip atsarginės kopijos kūrimui!';

  @override
  String get settingsImportFromAnotherApp => 'Importuoti iš kitos programėlės';

  @override
  String get logFormatTitle => 'Pasirinkti formatą';

  @override
  String get logFormatDescription =>
      'Kitos programėlės formatas gali nepalaikyti visų ypatybių. Praneškite apie bet kokias problemas, nes trečiųjų šalių formatai gali bet kuriuo metu pasikeisti. Tai neturės įtakos esamiems žurnalo įrašams!';

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
  String get settingsDeleteAllLogsTitle => 'Ištrinti visus žurnalo įrašus';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Ar norite ištrinti visus žurnalo įrašus?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Norėdami patvirtinti įrašykite \'$prompt\'. Šio veiksmo nebegalėsite atšaukti!';
  }

  @override
  String get settingsAppLanguageTitle => 'Programėlės kalba';

  @override
  String get settingsSecurityTitle => 'Saugumas';

  @override
  String get settingsSecurityRequirePassword => 'Reikalauti slaptažodžio';

  @override
  String get settingsSecurityEnterPassword => 'Įveskite slaptažodį';

  @override
  String get settingsSecuritySetPassword => 'Nustatyti slaptažodį';

  @override
  String get settingsSecurityChangePassword => 'Keisti slaptažodį';

  @override
  String get settingsSecurityPassword => 'Slaptažodis';

  @override
  String get settingsSecurityConfirmPassword => 'Pakartokite slaptažodį';

  @override
  String get settingsSecurityOldPassword => 'Senas slaptažodis';

  @override
  String get settingsSecurityIncorrectPassword => 'Neteisingas slaptažodis';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'Slaptažodžiai nesutampa';

  @override
  String get requiredPrompt => 'Būtinas';

  @override
  String get settingsSecurityBiometricUnlock => 'Biometrinis atrakinimas';

  @override
  String get unlockAppPrompt => 'Atrakinkite programėlę';

  @override
  String get settingsAboutTitle => 'Apie';

  @override
  String get settingsVersion => 'Versija';

  @override
  String get settingsLicense => 'Licencija';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsOpenSourceLicenses => 'Atvirojo kodo licencijos';

  @override
  String get tagMoodTitle => 'Nuotaika';

  @override
  String get selectTagTitle => 'Pasirinkite Žyma';

  @override
  String get labelPresentLabel => 'Pateikti';

  @override
  String get labelAbsentLabel => 'Nėra';

  @override
  String get labelCoverageLabel => 'Aprėptis';

  @override
  String chartDistributionTitle(Object tag) {
    return '$tag paskirstymas';
  }

  @override
  String get shareAddToLogPickerTitle => 'Pasirinkite dienoraščio įrašą';

  @override
  String get adaptiveEmptyDay => 'Šiai dienai dar nėra įrašų';

  @override
  String get adaptiveNewEntry => 'Parašykite įrašą';

  @override
  String get pageJournalTitle => 'Žurnalas';

  @override
  String get coachPrompt1 => 'Kas šiandien privertė nusišypsoti?';

  @override
  String get coachPrompt2 => 'Ką šiandien išmokote?';

  @override
  String get coachPrompt3 => 'Su kuo šiandien kalbėjotės ir kaip jautėtės?';

  @override
  String get coachPrompt4 => 'Už ką šiuo metu esi dėkingas?';

  @override
  String get coachPrompt5 => 'Kas šiandien atėmė daugiausiai energijos?';

  @override
  String get coachPrompt6 =>
      'Apibūdinkite nedidelę akimirką, kurią norite prisiminti.';

  @override
  String get coachPrompt7 => 'Kas padarytų rytoj gerą dieną?';

  @override
  String get coachPrompt8 => 'Kas pastaruoju metu sukosi tavo galvoje?';

  @override
  String get coachPrompt9 => 'Ką šiandien nuveikei dėl savęs?';

  @override
  String get coachPrompt10 => 'Jei šiandien būtų pavadinimas, koks jis būtų?';

  @override
  String get pageMediaTitle => 'Žiniasklaida';

  @override
  String get pageAtlasTitle => 'Atlasas';

  @override
  String get pageCoachTitle => 'Treneris';

  @override
  String get noEntrySelected => 'Nepasirinktas joks įrašas.';

  @override
  String get entryShare => 'Dalintis';

  @override
  String get entryFavorite => 'Žvaigždė';

  @override
  String get entryEdit => 'Redaguoti';

  @override
  String get entryPrevious => 'Ankstesnis įrašas';

  @override
  String get entryNext => 'Kitas įrašas';

  @override
  String get journalStories => 'Istorijos';

  @override
  String get journalEntries => 'Įrašai';

  @override
  String get journalEmptyHint =>
      'Pradėkite savo dienoraštį pridėdami naują įrašą.';

  @override
  String get storyToday => 'Šiandien';

  @override
  String get storyThrowback => 'Atmetimas';

  @override
  String get storyNoThrowback => 'Šiandien jokio atmetimo';

  @override
  String get mediaFiles => 'Medijos failai';

  @override
  String get mediaEmpty => 'Dar nėra nuotraukų.';

  @override
  String get mediaEmptyHint =>
      'Čia bus rodomos prie įrašų pridėtos nuotraukos.';

  @override
  String get atlasEmpty => 'Nėra įrašų su vieta.';

  @override
  String get atlasEmptyHint => 'Čia bus rodomi įrašai su vieta.';

  @override
  String get atlasShowAll => 'Rodyti visus įrašus';

  @override
  String get atlasMyLocation => 'Mano vieta';

  @override
  String get coachAll => 'Visi';

  @override
  String get coachPrograms => 'Programos';

  @override
  String get coachTemplates => 'Šablonai';

  @override
  String get coachKindProgram => 'Programa';

  @override
  String get coachKindTemplate => 'Šablonas';

  @override
  String get coachNoTemplates => 'Jokių programų ar šablonų.';

  @override
  String get coachUseTemplate => 'Rašykite naudodami šį šabloną';

  @override
  String get coachProgramEverydayTitle => 'Kasdienės akimirkos';

  @override
  String get coachProgramEverydayDescription =>
      'Penki trumpi klausimai, vienas per dieną. Kiekvienas iš jų užtrunka minutę ar dvi ir padeda suprasti, kas padarė tą dieną jūsų. Švelnus būdas ugdyti įprotį kasdien po truputį rašyti.';

  @override
  String get coachProgramReflectTitle => 'Žvelgiant į vidų';

  @override
  String get coachProgramReflectDescription =>
      'Vienas gilesnis klausimas per savaitę penkias savaites. Neskubėkite su kiekvienu: kaip jautėtės, kas jus vargina, už ką esate dėkingas.';

  @override
  String get searchFilters => 'Filtrai';

  @override
  String get searchFilterTags => 'Žymos';

  @override
  String get searchFilterStarred => 'Pažymėta žvaigždute';

  @override
  String get searchHint => 'Įveskite norėdami ieškoti arba pasirinkite filtrą.';

  @override
  String get locationTitle => 'Vieta';

  @override
  String get locationName => 'Vietos pavadinimas';

  @override
  String get locationRemove => 'Pašalinti';

  @override
  String get locationServiceDisabled => 'Vietos nustatymo paslaugos išjungtos.';

  @override
  String get locationPermissionDenied =>
      'Leidimas nustatyti vietą buvo atmestas.';

  @override
  String get locationUnavailable => 'Nepavyko gauti dabartinės vietos.';

  @override
  String get calendarJumpToToday => 'Peršokti į šiandieną';

  @override
  String get editorStartWriting => 'Pradėkite rašyti arba pasirinkite a ';

  @override
  String get editorTemplateLink => 'Šablonas';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Pasirinkite šabloną';

  @override
  String get templateFeatured => 'Teminiai šablonai';

  @override
  String get templateMine => 'Mano šablonai';

  @override
  String get templateDailyName => 'Kasdienė apžvalga';

  @override
  String get templateDailyDescription =>
      'Kas atsitiko, kaip jautėsi ir kas bus toliau.';

  @override
  String get templateDailyText =>
      '## Kas atsitiko šiandien\n\n\n## Kaip aš jaučiausi\n\n\n## Trys dalykai, už kuriuos esu dėkingas\n1. \n2. \n3. \n\n## Rytoj\n';

  @override
  String get templateTravelName => 'Kelionės dienoraščio įrašas';

  @override
  String get templateTravelDescription =>
      'Vietos, akimirkos ir maistas iš kelio.';

  @override
  String get templateTravelText =>
      '## Kur aš nuėjau\n\n\n## Akimirka, kurią labiausiai prisimenu\n\n\n## Ką aš valgiau\n\n\n## Rytojaus planai\n';

  @override
  String get templateReadingName => 'Pastabų skaitymas';

  @override
  String get templateReadingDescription =>
      'Citatos ir mintys iš to, ką perskaitėte.';

  @override
  String get templateReadingText =>
      '## Knyga\n\n\n## Kur aš esu\n\n\n## Citatos\n> \n\n## Mano mintys\n';

  @override
  String get templateWeeklyName => 'Savaitės apžvalga';

  @override
  String get templateWeeklyDescription =>
      'Svarbiausi momentai, kovos ir kitos savaitės dėmesys.';

  @override
  String get templateWeeklyText =>
      '## Svarbiausi dalykai\n\n\n## Kas buvo sunku\n\n\n## Ką aš išmokau\n\n\n## Dėmesys kitai savaitei\n';

  @override
  String get entrySaveAsTemplate => 'Išsaugoti kaip šabloną';

  @override
  String get entrySavedAsTemplate => 'Išsaugotas kaip šablonas';

  @override
  String get storyStatistics => 'Statistika';

  @override
  String get storyMoodChart => 'Nuotaikos diagrama';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return '$entries įrašai · $days dienos';
  }

  @override
  String get storyThisYear => 'Šiemet';

  @override
  String get storyLastYear => 'Praėjusiais metais';

  @override
  String get storyTapToOpen => 'Palieskite dieną, kad ją atidarytumėte';

  @override
  String get settingsGeneralTitle => 'Generolas';

  @override
  String get settingsDataTitle => 'Duomenys ir saugykla';

  @override
  String get settingsStoriesTitle => 'Istorijos';

  @override
  String get settingsHelpTitle => 'Pagalba ir apie';

  @override
  String get weatherTitle => 'Orai';

  @override
  String get weatherClear => 'Aišku';

  @override
  String get weatherPartlyCloudy => 'Debesuota';

  @override
  String get weatherCloudy => 'Debesuota';

  @override
  String get weatherFog => 'Rūkas';

  @override
  String get weatherDrizzle => 'Šlapdriba';

  @override
  String get weatherRain => 'Lietus';

  @override
  String get weatherSnow => 'Sniegas';

  @override
  String get weatherStorm => 'Perkūnija';

  @override
  String get weatherFetch => 'Gaukite šio įrašo orus';

  @override
  String get weatherNeedsLocation =>
      'Pirmiausia pridėkite vietą su koordinatėmis.';

  @override
  String get weatherUnavailable => 'Orai nepasiekiami šioje vietoje ir laiku.';

  @override
  String get weatherRemove => 'Pašalinkite orą';

  @override
  String get activityTitle => 'Veikla';

  @override
  String get activityStill => 'Vis tiek';

  @override
  String get activityWalking => 'Vaikščiojimas';

  @override
  String get activityRunning => 'Bėgimas';

  @override
  String get activityCycling => 'Važiavimas dviračiu';

  @override
  String get activityVehicle => 'Transporto priemonėje';

  @override
  String get activityFlying => 'Skraidymas';

  @override
  String get activityExercise => 'Pratimai';

  @override
  String get activityDetect => 'Aptikti dabartinę veiklą';

  @override
  String get activityDetectFailed => 'Nepavyko aptikti veiklos.';

  @override
  String get activityRemove => 'Pašalinti veiklą';

  @override
  String get settingsAutoAddTitle => 'Pridėti automatiškai';

  @override
  String get settingsAutoAddLocation => 'Vieta';

  @override
  String get settingsAutoAddWeather => 'Orai';

  @override
  String get settingsAutoAddHint => 'Nauji įrašai užpildomi juos sukūrus.';

  @override
  String get settingsTemperatureUnit => 'Temperatūros vienetas';

  @override
  String get settingsCelsius => 'Celsijaus (°C)';

  @override
  String get settingsFahrenheit => 'Farenheito (°F)';

  @override
  String get moodGreat => 'Puiku';

  @override
  String get moodGood => 'Gerai';

  @override
  String get moodOkay => 'Gerai';

  @override
  String get moodBad => 'Blogai';

  @override
  String get moodAwful => 'Siaubinga';

  @override
  String get locationSearchHint => 'Ieškokite vietos';

  @override
  String get locationSearchEmpty => 'Vietų nerasta';

  @override
  String get settingsWallpaper => 'Tapetai';

  @override
  String get wallpaperNone => 'Nėra';

  @override
  String get wallpaperDots => 'Taškai';

  @override
  String get wallpaperGrid => 'Tinklelis';

  @override
  String get wallpaperLines => 'Linijos';

  @override
  String get wallpaperPhoto => 'Nuotrauka…';

  @override
  String get settingsFontFamily => 'Šriftas';

  @override
  String get fontSystem => 'Sistema';

  @override
  String get fontSerif => 'Serifas';

  @override
  String get fontMono => 'Monospace';

  @override
  String get settingsFontSize => 'Šrifto dydis';

  @override
  String get fontSizeSmall => 'Mažas';

  @override
  String get fontSizeMedium => 'Vidutinis';

  @override
  String get fontSizeLarge => 'Didelis';

  @override
  String get fontSizeExtraLarge => 'Itin didelis';

  @override
  String get settingsLineSpacing => 'Tarpai tarp eilučių';

  @override
  String get lineSpacingCompact => 'Kompaktiškas';

  @override
  String get lineSpacingNormal => 'Normalus';

  @override
  String get lineSpacingRelaxed => 'Atsipalaidavęs';

  @override
  String get moodAssociationsTitle => 'Kas verčia mane jaustis…';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching iš $total įrašų';
  }

  @override
  String get videoRecord => 'Įrašykite vaizdo įrašą';

  @override
  String get videoChoose => 'Pasirinkite vaizdo įrašą';

  @override
  String get audioRecordTitle => 'Įrašykite balso pastabą';

  @override
  String get audioChoose => 'Pasirinkite garso failą';

  @override
  String get audioStart => 'Įrašas';

  @override
  String get audioStop => 'Sustokite ir išsaugokite';

  @override
  String get audioPermissionDenied =>
      'Prieiga prie mikrofono išjungta. Leiskite tai sistemos nustatymuose.';

  @override
  String get mediaTooLarge =>
      'Šis vaizdo įrašas per didelis, kad jį būtų galima pridėti.';

  @override
  String get mediaUnavailable => 'Šis priedas nepasiekiamas šiame įrenginyje.';

  @override
  String get widgetDone => 'Šios dienos įrašas parašytas';

  @override
  String get widgetPending => 'Kaip praėjo jūsų diena?';

  @override
  String get widgetWrite => 'Rašyti';

  @override
  String get insertChecklist => 'Kontrolinis sąrašas';

  @override
  String get insertNumberedList => 'Sunumeruotas sąrašas';

  @override
  String get insertTable => 'Lentelė';

  @override
  String get insertDivider => 'Skirstytuvas';

  @override
  String get insertCodeBlock => 'Kodo blokas';

  @override
  String get journalSortTitle => 'Rūšiuoti įrašus';

  @override
  String get journalSortUpdated => 'Paskutinį kartą atnaujinta';

  @override
  String get settingsTimeFormat => 'Laiko formatas';

  @override
  String get settingsDayStart => 'Nauji įrašai skaičiuojami už dieną prieš iki';

  @override
  String get settingsDayAskUntil => 'Tada paklausk iki kurios dienos';

  @override
  String get settingsDayStartMidnight => 'Išjungta';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Kiekvienas įrašas išsaugo tą dieną, kuriai jis priklauso, šalia laiko, kada buvo parašytas, o tą dieną galite bet kada pakeisti redaktoriuje. Šios valandos parenka tik dieną naujiems įrašams, todėl jas pakeitus neperkeliamas joks esamas įrašas.';

  @override
  String get lateNightBadge =>
      'Parašyta vėlai vakare, skaičiuojama diena prieš';

  @override
  String editorDayAsk(String time) {
    return 'Parašyta $time. Kuriai dienai skirta?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (vakar)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (šiandien)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'Parašyta $when';
  }

  @override
  String get timeFormat12 => '12 valandų';

  @override
  String get timeFormat24 => '24 val';

  @override
  String get settingsReminderDays => 'Priminti man';

  @override
  String get locationRecent => 'Naujausios vietos';

  @override
  String get shareImage => 'Bendrinti vaizdą';

  @override
  String get shareSaveImage => 'Išsaugoti vaizdą';

  @override
  String get shareSaved => 'Vaizdas išsaugotas';

  @override
  String get deletedTitle => 'Neseniai ištrinta';

  @override
  String get deletedNone => 'Pastaruoju metu nieko neištrinta';

  @override
  String deletedHint(int days) {
    return 'Ištrinti įrašai lieka čia $days dienas, tada ištrinami.';
  }

  @override
  String deletedDaysLeft(int days) {
    return 'Liko $days dienų';
  }

  @override
  String get deletedRestore => 'Atkurti';

  @override
  String get deletedDeleteForever => 'Ištrinti visam laikui';

  @override
  String get deletedDeleteForeverDescription =>
      'Įrašas ir jo priedai ištrinami. To negalima anuliuoti.';

  @override
  String get deletedEmpty => 'Tuščia';

  @override
  String get deletedEmptyDescription =>
      'Ištrinti kiekvieną įrašą iš Neseniai ištrintas? To negalima anuliuoti.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Atsitiktinis pasivaikščiojimas';

  @override
  String get randomSubtitle => 'Atidarykite ankstesnį įrašą';

  @override
  String get randomNext => 'Kitas';

  @override
  String get randomAll => 'Visi';

  @override
  String get randomWithPhotos => 'Su nuotraukomis';

  @override
  String get randomGoodDays => 'Geros dienos';

  @override
  String get randomEmpty => 'Nėra įrašų, iš kurių būtų galima pasirinkti';

  @override
  String get reviewWeekTitle => 'Šią savaitę';

  @override
  String get reviewWeekSubtitle => 'Jūsų savaitė iki šiol';

  @override
  String get reviewYearTitle => 'Šiemet';

  @override
  String get reviewEmpty => 'Dar nieko neparašyta';

  @override
  String get reviewEntries => 'Įrašai';

  @override
  String get reviewDaysWritten => 'Rašytos dienos';

  @override
  String get reviewWords => 'Žodžiai';

  @override
  String get reviewPhotos => 'Nuotraukos';

  @override
  String get reviewLongestRun => 'Ilgiausias dienų bėgimas';

  @override
  String get reviewAverageMood => 'Vidutinė nuotaika';

  @override
  String get reviewFavorites => 'Dažniausiai';

  @override
  String get reviewByMonth => 'Pagal mėnesį';

  @override
  String get reviewHighlight => 'Paryškinti';

  @override
  String get yearInPixels => 'Metai pikseliais';

  @override
  String get capsuleSeal => 'Sandarinimas kaip laiko kapsulė';

  @override
  String get capsuleTitle => 'Laiko kapsulė';

  @override
  String capsuleOpensOn(Object date) {
    return 'Atsidaro $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Parašyta $date';
  }

  @override
  String get capsuleOpenEarly => 'Atidarykite anksti';

  @override
  String get capsuleOpenEarlyDescription =>
      'Kapsulė atsidaro dabar ir lieka atidaryta.';

  @override
  String get capsuleOpened => 'Atidaryta laiko kapsulė';

  @override
  String get templateMorningName => 'Ryto puslapiai';

  @override
  String get templateMorningDescription => 'Nustatykite dieną per tris minutes';

  @override
  String get templateMorningText =>
      '## Trys dalykai, kuriuos šiandien noriu padaryti gerai\n1. \n2. \n3. \n\n## Kažko laukiu\n\n## Pastaba sau\n';

  @override
  String get templateEveningName => 'Vakaro apžvalga';

  @override
  String get templateEveningDescription =>
      'Užbaikite dieną tuo, kas buvo gerai';

  @override
  String get templateEveningText =>
      '## Trys geri dalykai šiandien\n1. \n2. \n3. \n\n## Ką aš išmokau\n\n## Kas gali būti geriau rytoj\n';

  @override
  String get routineMorning => 'Labas rytas';

  @override
  String get routineEvening => 'Vakaro apžvalga';

  @override
  String get settingsRoutinePrompts => 'Ryto ir vakaro raginimai';

  @override
  String get settingsRoutinePromptsHint =>
      'Pasiūlykite ryto arba vakaro šabloną Istorijose';

  @override
  String get checkInTitle => 'Greita registracija';

  @override
  String get checkInSubtitle => 'Nuotaika dviem bakstelėjimais';

  @override
  String get checkInMood => 'kaip tu jautiesi?';

  @override
  String get checkInActivity => 'ka tu darai?';

  @override
  String get checkInNote => 'Eilutė apie tai (neprivaloma)';

  @override
  String get checkInSave => 'Išsaugoti';

  @override
  String editorWordCount(int words, int characters) {
    return '$words žodžiai · $characters simboliai';
  }

  @override
  String get coachProgramEverydayTagline =>
      'Pastebėkite mažus dalykus per dieną.';

  @override
  String get coachProgramReflectTagline => 'Lėtinkite ir įsiklausykite į save.';

  @override
  String get coachDuration => 'Trukmė';

  @override
  String get coachInterval => 'Intervalas';

  @override
  String get coachDifficulty => 'Sunkumas';

  @override
  String get coachIntervalDaily => 'Kasdien';

  @override
  String get coachIntervalWeekly => 'Kas savaitę';

  @override
  String get coachDifficultyBeginner => 'Pradedantysis';

  @override
  String get coachDifficultyIntermediate => 'Vidutinis';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dienų',
      one: '$count diena',
      many: '$count dienos',
      few: '$count dienos',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count savaičių',
      one: '$count savaitė',
      many: '$count savaitės',
      few: '$count savaites',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'Diena $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Savaitė $n';
  }

  @override
  String get coachEnroll => 'Užsiregistruoti';

  @override
  String get coachEndProgram => 'Baigti programą';

  @override
  String get coachAuthor => 'Autorius';

  @override
  String get coachAuthorBio => 'Raginimai parašyti šiai programai.';

  @override
  String get coachEnrolledTip =>
      'Viskas paruošta! Jūsų klausimai bus rodomi istorijose.';

  @override
  String get coachGoToStories => 'Eikite į istorijas';

  @override
  String get coachAnswerHint => 'Parašyk savo atsakymą…';

  @override
  String get storyWrapUp => 'Tai viskas šiai dienai.';

  @override
  String get storyTapToClose => 'Bakstelėkite, kad uždarytumėte';

  @override
  String get coachAnswerDone => 'Atlikta';

  @override
  String get coachAnswered => 'Atsakyta, palieskite, kad atidarytumėte';

  @override
  String get coachAnsweredEarlier => 'Atsakyta';

  @override
  String get locationLocating => 'Ieškoma…';

  @override
  String get locationPickPlace => 'Pasirinkite vietą';

  @override
  String get locationPlacesHint => 'Vietos adresas arba pavadinimas';

  @override
  String get locationCustom => 'Individualizuota vieta';

  @override
  String get locationCurrent => 'Dabartinė vieta';

  @override
  String get locationSaved => 'Išsaugotos vietos';

  @override
  String get locationSearchResults => 'Paieškos rezultatai';

  @override
  String get locationNearby => 'Netoliese esančios vietos';

  @override
  String get locationRename => 'Pervardyti';

  @override
  String get locationSavePlace => 'Išsaugoti vietą';

  @override
  String get locationUnsavePlace => 'Pašalinti iš išsaugotų vietų';

  @override
  String get shareAs => 'Bendrinti kaip…';

  @override
  String get shareAsImage => 'Vaizdas';

  @override
  String get shareAsZip => 'ZIP su originalia laikmena';

  @override
  String get shareAsPlainText => 'Paprastas tekstas';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Sveiki atvykę į AID Diary';

  @override
  String get onboardWelcomeText =>
      'Pradėkite čia arba prijunkite šį įrenginį prie jau naudojamo įrenginio.';

  @override
  String get onboardStart => 'Pradėkite rašyti';

  @override
  String get helpFaq => 'Dažnai užduodami klausimai';

  @override
  String get helpFaq1Q => 'Kur saugomas mano dienoraštis?';

  @override
  String get helpFaq1A =>
      'Jūsų dienoraštis saugomas šiame įrenginyje. Jis pasiekia kitus įrenginius arba saugyklą tik įjungus sinchronizavimą, bendrinimą arba eksportavimą. Sinchronizavimas yra visiškai užšifruotas.';

  @override
  String get helpFaq2Q =>
      'Kaip pasilikti kopiją arba perkelti į naują įrenginį?';

  @override
  String get helpFaq2A =>
      'Prisijunkite prie esamo įrenginio nustatymuose → Duomenys ir saugykla → Sinchronizuoti ir patvirtinkite įrenginio, kuriame yra jūsų dienoraštis, leidimą. Abu įrenginiai išlieka tinkami naudoti. Taip pat galite sukurti atsarginę kopiją ir atkurti ją kitame įrenginyje.';

  @override
  String get helpFaq3Q =>
      'Ar galiu įvesti įrašus iš kitų dienoraščio programų?';

  @override
  String get helpFaq3A =>
      'Taip: Nustatymai → Duomenys ir saugykla importuokite eksportą iš Daylio, Diarium, Diaro, DayBook, My Brain, OneShot ir Pixels arba JSON eksporto.';

  @override
  String get helpFaq4Q => 'Kaip veikia trenerių programos?';

  @override
  String get helpFaq4A =>
      'Užsiregistruokite į programą trenerio puslapyje. Kiekvieną dieną ar savaitę Istorijose laukia naujas klausimas; jūsų atsakymas išsaugomas kaip įrašas.';

  @override
  String get helpFaq5Q => 'Ką daryti, jei pamiršiu slaptažodį?';

  @override
  String get helpFaq5A =>
      'Slaptažodžio atkurti nepavyks, todėl pasidarykite atsarginę dienoraščio kopiją.';

  @override
  String get helpPrivacy => 'Privatumas';

  @override
  String get helpPrivacyText =>
      'Dienoraščio turinys ir medija lieka šiame įrenginyje, nebent įgalinsite šifruotą sinchronizavimą arba bendrinsite / neeksportuosite jų. Žemėlapiai, vietos paieška ir orai naudoja sukonfigūruotas paslaugas ir siunčia tai užklausai reikalingą vietą arba paieškos užklausą, o ne dienoraščio tekstą.';

  @override
  String get photoMetaTitle => 'Naudoti nuotraukos duomenis?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Suskaičiuoti šį įrašą $date ir nustatyti jo vietą į $place, kaip užfiksuota nuotraukoje?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Suskaičiuoti šį įrašą $date, kai buvo padaryta nuotrauka?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Nustatyti šio įrašo vietą į $place, kur buvo padaryta nuotrauka?';
  }

  @override
  String get photoMetaApply => 'Naudokite juos';

  @override
  String get quickWriteTitle => 'Greitai parašyk';

  @override
  String get quickWriteText => 'Bakstelėkite, kad pradėtumėte naują įrašą.';

  @override
  String get settingsQuickWriteTitle => 'Greitai įrašykite pranešimus';

  @override
  String get settingsQuickWriteDescription =>
      'Išsaugokite pranešimą, kuris atidaro naują įrašą.';

  @override
  String get settingsNudgesTitle => 'Pastumdykite mane po tylios atkarpos';

  @override
  String settingsNudgesDescription(int days) {
    return 'Švelnus priminimas, kai neparašėte $days dienas.';
  }

  @override
  String get nudgeTitle => 'Praėjo šiek tiek laiko';

  @override
  String get nudgeMonday => 'Nauja savaitė: ko lauki?';

  @override
  String get nudgeTuesday => 'Pakanka dviejų eilučių. kaip tu siandien?';

  @override
  String get nudgeWednesday => 'Įpusėjus savaitei. Kas išsiskyrė iki šiol?';

  @override
  String get nudgeThursday => 'Ar verta pasilikti ką nors mažo nuo šiandien?';

  @override
  String get nudgeFriday =>
      'Savaitė baigiasi. Atkreipkite dėmesį į vieną gerą momentą.';

  @override
  String get nudgeSaturday => 'Lėtas šeštadienis – gera diena rašyti.';

  @override
  String get nudgeSunday => 'Pažvelkite į savaitę prieš jos pabaigą.';

  @override
  String get photoWidgetEmpty =>
      'Nuotraukos, kurias pridedate prie įrašų, rodomos čia.';

  @override
  String get channelReminders => 'Priminimai';

  @override
  String get channelOnThisDay => 'Šią dieną';

  @override
  String get channelCoach => 'Treneris ragina';

  @override
  String get channelNudges => 'Nusileidžia po ramių dienų';

  @override
  String get channelQuickWrite => 'Greitai parašyk';

  @override
  String get channelBackup => 'Atsarginės kopijos';

  @override
  String get formatJsonExport => 'JSON (AID Diary eksportas)';

  @override
  String get aboutModifiedNotice =>
      '„Demizo“ ir bendradarbių modifikuota „Daily You“ versija. Tai nėra oficiali „Daily You“ programa.';

  @override
  String get toolbarPhotos => 'Pridėkite nuotraukų';

  @override
  String get toolbarMedia => 'Nuotraukos ir vaizdo įrašai';

  @override
  String get mediaFromGallery => 'Pasirinkite iš galerijos';

  @override
  String get mediaFromFiles => 'Pasirinkite iš failų';

  @override
  String get editorLeaveTitle => 'Išsaugoti šį įrašą?';

  @override
  String get editorLeaveDiscard => 'Netaupyk';

  @override
  String get editorTitleHint => 'Pavadinimas';

  @override
  String get editorLocating => 'Ieškoma…';

  @override
  String get toolbarVideo => 'Vaizdo įrašas';

  @override
  String get toolbarAudio => 'Balso pastaba';

  @override
  String get toolbarTags => 'Žymos';

  @override
  String get toolbarBulletList => 'Sąrašas su ženkleliais';

  @override
  String get toolbarHeading => 'Antraštė';

  @override
  String get toolbarBold => 'Paryškintas';

  @override
  String get toolbarItalic => 'Kursyvas';

  @override
  String get toolbarHighlight => 'Paryškinti';

  @override
  String get toolbarStrikethrough => 'Perbraukta';

  @override
  String get toolbarQuote => 'Citata';

  @override
  String get toolbarLink => 'Nuoroda';

  @override
  String get toolbarInsert => 'Įterpti';

  @override
  String get toolbarUndo => 'Anuliuoti';

  @override
  String get toolbarRedo => 'Perdaryti';

  @override
  String get toolbarInsertDate => 'Įveskite datą';

  @override
  String get toolbarInsertTime => 'Įveskite laiką';

  @override
  String get settingsSyncTitle => 'Debesų sinchronizavimas';

  @override
  String get syncOffDescription =>
      'Išsaugokite šį dienoraštį visuose savo įrenginiuose naudodami Google Drive arba WebDAV serverį, pvz., Nextcloud, Synology ar Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'Sinchronizuoti su Google Drive';

  @override
  String get syncOrWebDav => 'Arba WebDAV serveris';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn => 'Prisijungta. Galite grįžti į AID Diary.';

  @override
  String get syncGoogleSignInAgain => '„Google“ reikia vėl prisijungti.';

  @override
  String get syncSignInAgain => 'Prisijunkite dar kartą';

  @override
  String get settingsCommandLineTitle => 'Komandinė eilutė';

  @override
  String get commandLineToggle => 'Komandinės eilutės sąsaja';

  @override
  String get commandLineToggleHint =>
      'Leidžia pagalbos komandai ir kitoms šio įrenginio programoms naudoti programos komandas.';

  @override
  String get commandLineAlwaysOn => 'Visada plėtojant.';

  @override
  String commandLineListening(int port) {
    return 'Klausymas per prievadą $port';
  }

  @override
  String get commandPaletteTitle => 'Visos komandos';

  @override
  String get commandPaletteSearch => 'Paieškos komandos';

  @override
  String get commandPaletteRun => 'Bėk';

  @override
  String get commandPaletteConfirm =>
      'To negalima paprasčiausiai atšaukti. Paleisti?';

  @override
  String syncReceiving(int done, int total) {
    return 'Priimamas $done iš $total…';
  }

  @override
  String syncSending(int done, int total) {
    return 'Siunčiamas $done iš $total…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'Prieiga prie Google Drive nebuvo leista. Prisijunkite dar kartą ir „Google“ puslapyje pažymėkite Google Drive.';

  @override
  String get syncEntryUnsynced =>
      'Nesinchronizuotas: paskutinis sinchronizavimas nebuvo atliktas';

  @override
  String get syncUseOfficial => 'Naudokite AID sinchronizavimo serverį';

  @override
  String get syncServer => 'Serverio adresas';

  @override
  String get syncUsername => 'Vartotojo vardas';

  @override
  String get syncPassword => 'Slaptažodis';

  @override
  String get syncConnect => 'Prisijunkite';

  @override
  String get syncConnecting => 'Jungiamasi…';

  @override
  String get syncSignInFailed =>
      'Nepavyko prisijungti. Patikrinkite adresą, vartotojo vardą ir slaptažodį.';

  @override
  String syncConnectFailed(String error) {
    return 'Nepavyko prisijungti: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Pradėkite sinchronizuoti';

  @override
  String get syncNewSpaceDescription =>
      'Čia dar nėra sinchronizuoto dienoraščio. Šis dienoraštis bus įkeltas, visiškai užšifruotas raktu, kuris lieka jūsų įrenginiuose.';

  @override
  String get syncJoinTitle => 'Prisijunkite prie sinchronizuoto dienoraščio';

  @override
  String get syncWrongKey =>
      'Šis atkūrimo kodas neatidaro sinchronizuoto dienoraščio.';

  @override
  String syncLastSynced(String time) {
    return 'Paskutinį kartą sinchronizuotas $time';
  }

  @override
  String get syncNever => 'Dar nesinchronizuotas';

  @override
  String get syncSyncing => 'Sinchronizuojama…';

  @override
  String syncFailed(String error) {
    return 'Paskutinis sinchronizavimas nepavyko: $error';
  }

  @override
  String get syncLocked =>
      'Sinchronizuotas dienoraštis dabar priklauso kitiems įrenginiams arba buvo paleistas iš naujo. Susiekite su vienu iš jų arba naudokite atkūrimo kodą, kad tęstumėte sinchronizavimą.';

  @override
  String get syncNow => 'Sinchronizuoti dabar';

  @override
  String get syncUnlock => 'Atrakinti';

  @override
  String get syncEncrypted => 'Užšifruota nuo galo iki galo';

  @override
  String get syncDisconnect => 'Sustabdyti sinchronizavimą';

  @override
  String get syncDisconnectDescription =>
      'Šis įrenginys nustoja sinchronizuoti. Čia esantis dienoraštis ir sinchronizuota kopija lieka tokie, kokie yra.';

  @override
  String get syncOwnRecoveryPassword => 'Naudokite savo atkūrimo slaptažodį';

  @override
  String get syncRecoveryPassword => 'Atkūrimo slaptažodis';

  @override
  String get syncRecoveryPasswordRepeat => 'Pakartokite atkūrimo slaptažodį';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Naudokite bent $min simbolius';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'Slaptažodžiai skiriasi';

  @override
  String get syncRecoveryCode => 'Atkūrimo kodas';

  @override
  String get syncRecoveryCodeTitle => 'Išsaugokite atkūrimo kodą';

  @override
  String get syncRecoveryCodeDescription =>
      'Jei pametate visus jūsų įrenginius, šis kodas atkuria sinchronizuotą dienoraštį. Laikykite jį slaptažodžių tvarkyklėje arba popieriuje. Jis rodomas tik šį kartą.';

  @override
  String get syncRecoveryCodeCopied => 'Atkūrimo kodas nukopijuotas';

  @override
  String get syncRecoveryCodeSaved => 'Aš jį išsaugojau';

  @override
  String get syncJoinNeedsKey =>
      'Šis sinchronizuotas dienoraštis priklauso kitiems jūsų įrenginiams. Susiekite su vienu iš jų arba naudokite atkūrimo kodą. Šiame įrenginyje esantys įrašai bus pridėti prie jo.';

  @override
  String get syncPairDevice => 'Susiekite su įrenginiu';

  @override
  String get syncUseRecoveryCode => 'Naudokite atkūrimo kodą';

  @override
  String get syncAddDevice => 'Pridėkite įrenginį';

  @override
  String get syncChangeRecoveryCode => 'Pakeiskite atkūrimo kodą';

  @override
  String get syncChangeRecoveryDescription =>
      'Naujas kodas pakeičia dabartinį, kuris nustoja veikti. Jūsų duomenys ir kiti įrenginiai lieka tokie, kokie yra.';

  @override
  String get syncNewRandomCode => 'Naujas atsitiktinis kodas';

  @override
  String get syncRecoveryCodeChanged => 'Atkūrimo kodas pakeistas';

  @override
  String get syncResetSpace => 'Pradėkite sinchronizuotą dienoraštį iš naujo';

  @override
  String get syncResetSpaceDescription =>
      'Tik tada, kai joks įrenginys ir atkūrimo kodas jo nebeatidaro: sinchronizuotą kopiją pakeičia šio įrenginio dienoraštis, po šio įrenginio klavišais. Tada vėl susiekite kitus įrenginius.';

  @override
  String get syncPairTitle => 'Suporuokite įrenginius';

  @override
  String get syncPairShow => 'Parodykite kodą';

  @override
  String get syncPairEnter => 'Įveskite kodą';

  @override
  String get syncPairShowHint =>
      'Kitame įrenginyje atidarykite Susieti įrenginius, pasirinkite Įvesti kodą ir įveskite arba nuskaitykite jį.';

  @override
  String get syncPairEnterHint =>
      'Įveskite kito įrenginio rodomą kodą arba nuskaitykite jį.';

  @override
  String get syncPairCode => 'Poravimo kodas';

  @override
  String get syncPairScan => 'Nuskaityti';

  @override
  String get syncPairStart => 'Suporuoti';

  @override
  String get syncPairWaiting => 'Laukiama kito įrenginio…';

  @override
  String syncPairDone(String device) {
    return 'Suporuotas su $device';
  }

  @override
  String get syncPairWrongCode =>
      'Kodas nesutapo. Parodykite naują kodą ir bandykite dar kartą.';

  @override
  String get syncPairNoOffer =>
      'Joks įrenginys nerodo šio kodo. Gali būti, kad jo galiojimo laikas baigėsi.';

  @override
  String get syncPairTimedOut => 'Kitas įrenginys laiku neatsiliepė.';

  @override
  String get syncPairNeither =>
      'Nė vienas įrenginys dar nenustatytas naudojant šį sinchronizuotą dienoraštį.';

  @override
  String get syncPairBoth =>
      'Abu įrenginiai jau atidaro šį sinchronizuotą dienoraštį.';

  @override
  String syncPairFailed(String error) {
    return 'Nepavyko susieti: $error';
  }

  @override
  String get syncMediaPending =>
      'Dienoraštis sinchronizuotas · kai kurios laikmenos vis dar perkeliamos';

  @override
  String get syncWaitingForDevices =>
      'Dienoraštis sinchronizuotas · laukiama, kol kitas įrenginys perduos mediją';

  @override
  String get syncCacheNotice =>
      'Debesų laikmena yra laikina. Laikykite originalus savo įrenginiuose; sinchronizavimas nėra atsarginė kopija.';

  @override
  String get paperTitle => 'Laiškų popierius';

  @override
  String get paperPlain => 'Paprastas';

  @override
  String get paperLined => 'Pamušalu';

  @override
  String get paperGrid => 'Tinklelis';

  @override
  String get paperTinted => 'Tamsintas';

  @override
  String get paperDecorationTitle => 'Dekoracijos';

  @override
  String get paperDecorationNone => 'Nėra';

  @override
  String get paperDecorationBotanical => 'Lapai';

  @override
  String get paperDecorationStars => 'Žvaigždės';

  @override
  String get paperDecorationWashi => 'Washi juosta';

  @override
  String get themeDarkChoice => 'Tamsi išvaizda';

  @override
  String get themeDarkSame => 'Sekite šviesią paletę';

  @override
  String get themeDarkCustom => 'Atskira paletė';

  @override
  String get themeDarkAccent => 'Tamsi akcento spalva';

  @override
  String get themeColorTeal => 'žalsvai mėlyna';

  @override
  String get themeColorCyan => 'Žydra spalva';

  @override
  String get themeColorIndigo => 'Indigo';

  @override
  String get themeColorCoral => 'Koralas';

  @override
  String get themeColorOlive => 'Alyvuogių';

  @override
  String get themeColorSlate => 'Šiferis';

  @override
  String get drawingTitle => 'Piešimas';

  @override
  String get drawingPen => 'Rašiklis';

  @override
  String get drawingEraser => 'Trintukas';

  @override
  String get drawingUndo => 'Anuliuoti';

  @override
  String get drawingClear => 'Aišku';

  @override
  String get drawingWidth => 'Rašiklio plotis';

  @override
  String get drawingStylusOnly => 'Tik rašiklis';

  @override
  String get drawingDiscardTitle => 'Atmesti piešinį?';

  @override
  String get drawingDiscardBody => 'Šis piešinys nebuvo išsaugotas.';

  @override
  String get drawingSaveError => 'Nepavyko išsaugoti piešinio.';

  @override
  String get syncNetworkTitle => 'Tinklo diagnostika';

  @override
  String get syncNetworkRefresh => 'Atnaujinti';

  @override
  String get syncNetworkSelectedRoute => 'Dabartinis kelias';

  @override
  String get syncNetworkAvailableRoutes => 'Galimi keliai';

  @override
  String get syncNetworkSignaling => 'Įrenginių katalogo ryšys';

  @override
  String get syncNetworkRelayRemaining => 'Likusi relės pašalpa';

  @override
  String get syncNetworkIcePair => 'Tiesioginio ryšio kandidatai';

  @override
  String get syncNetworkPeerTrusted => 'Autentifikuotas įrenginys';

  @override
  String get syncNetworkNoRoute => 'Laukiama ryšio';

  @override
  String get syncNetworkUnavailable => 'Diagnostika nepasiekiama';

  @override
  String get syncMediaCopiesTitle => 'Žiniasklaidos pristatymas ir kopijos';

  @override
  String get syncMediaPendingCount => 'Laukiama perdavimo';

  @override
  String get syncMediaDurableCount => 'Pristatomas į asmeninę saugyklą';

  @override
  String get syncMediaTemporaryCount => 'Laikinos arba nepatvirtintos kopijos';

  @override
  String get syncMediaReceiptExplanation =>
      'Šie skaičiai apibūdina užbaigtus pristatymus, o ne naują išlikusių atsarginių kopijų auditą.';

  @override
  String get syncMediaCacheExplanation =>
      'Laikinos debesies laikmenos galiojimo laikas gali baigtis. Išsaugokite originalus arba atskirą atsarginę kopiją.';

  @override
  String get momentsTitle => 'Foto akimirkos';

  @override
  String get momentsHint =>
      'Raskite grupes naudodami vietos nuotraukų laiką ir pasirenkamas koordinates. Nuotraukos pridedamos tik tada, kai pasirenkate kortelę.';

  @override
  String get momentsScan => 'Raskite akimirkų';

  @override
  String get momentsChooseFolder => 'Pasirinkite nuotraukų aplanką';

  @override
  String get momentsLocation => 'Įtraukite nuotraukų vietas';

  @override
  String get momentsEmpty => 'Nėra naujausių nuotraukų grupių.';

  @override
  String get momentsCreate => 'Parašykite apie šias nuotraukas';

  @override
  String get momentsDismiss => 'Atsisakyti';

  @override
  String get momentsError => 'Nepavyko perskaityti vietinių nuotraukų.';

  @override
  String get momentsCreated => 'Sukurtas nuotraukos įrašas.';

  @override
  String get momentsPermission =>
      'Suteikite prieigą prie nuotraukų, kad rastumėte vietinių pasiūlymų.';

  @override
  String get momentsScope =>
      'Tik naujausios nuotraukos; ne daugiau kaip 500 nuotraukų ir 20 nuotraukų vienoje kortelėje.';

  @override
  String momentsPhotoCount(int count) {
    return '$count nuotraukos';
  }

  @override
  String get nearbyTitle => 'Prijunkite įrenginius';

  @override
  String get nearbySend => 'Įgaliokite kitą įrenginį';

  @override
  String get nearbyReceive => 'Prisijunkite prie esamo įrenginio';

  @override
  String get nearbyInstructions =>
      'Prijunkite abu įrenginius prie to paties Wi-Fi arba vienas kito viešosios interneto prieigos taško. Patvirtinkite esamo įrenginio autorizaciją; abu įrenginiai išlieka tinkami naudoti. Internetas nereikalingas.';

  @override
  String get nearbyCompare =>
      'Prieš patvirtindami palyginkite šį kodą abiejuose įrenginiuose.';

  @override
  String get nearbyConfirm => 'Kodai sutampa';

  @override
  String get nearbyScan => 'Nuskaitykite kito įrenginio kodą';

  @override
  String get nearbyPaste => 'Įklijuoti kvietimą';

  @override
  String get nearbyWaiting => 'Laukiama patvirtinimo kitame įrenginyje';

  @override
  String get nearbyWorking =>
      'Įgaliojama ir sinchronizuojama jūsų dienoraštis ir priedai…';

  @override
  String get nearbyPending =>
      'Kai kuriuos priedus vis tiek reikia sinchronizuoti. Palaikykite kitą įrenginį prisijungę ir bandykite dar kartą.';

  @override
  String get nearbyComplete =>
      'Prietaisas prijungtas; dienoraštis ir priedai sinchronizuoti';

  @override
  String get nearbyFailed =>
      'Ryšys nebaigtas. Patikrinkite vietinį ryšį ir bandykite dar kartą.';

  @override
  String get nearbyEmptyRequired =>
      'Naudokite įrenginį su tuščiu dienoraščiu, kuris dar neprijungtas prie sinchronizavimo.';

  @override
  String get nearbyRetry => 'Tęsti sinchronizavimą';

  @override
  String get nearbyWifi => 'Wi-Fi nustatymai';

  @override
  String get nearbyHotspot => 'Viešosios interneto prieigos taško nustatymai';

  @override
  String get nearbyKeepOpen =>
      'Laikykite šį puslapį atidarytą, kol naujas įrenginys bus baigtas. Kvietimas nustoja galioti po dviejų minučių.';

  @override
  String get syncDevicesTitle => 'Įgalioti įrenginiai';

  @override
  String get syncDevicesDescription =>
      'Tik patvirtinti įrenginiai gali pasiekti šią AID paskyrą. Atšaukus įrenginį blokuojamas serveris, bet negalima ištrinti pagrindinio rakto ar dienoraščio, jau nukopijuoto į jį.';

  @override
  String get syncDeviceRequest =>
      'Parodykite šį prieigos teisės QR patvirtintą įrenginį';

  @override
  String get syncDeviceAuthorize => 'Įgaliokite įrenginį';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Nuskaitykite arba įklijuokite naujo įrenginio prieigos teisės užklausą.';

  @override
  String get syncDeviceRevoke => 'Atšaukti';

  @override
  String get syncDeviceRotate => 'Pasukite šio įrenginio pasirašymo raktą';

  @override
  String get syncDeviceCheck => 'Patikrinkite įgaliojimą';

  @override
  String get syncDeviceHardware =>
      'Aparatine įranga paremtas pasirašymo raktas';

  @override
  String get syncDeviceSoftware =>
      'Neeksportuojamas programinės įrangos pasirašymo raktas';

  @override
  String get syncDeviceUnavailable =>
      'Įrenginio prieigos teisė nepasiekiama. Patvirtinkite šį įrenginį naudodami kitą įgaliotą įrenginį ir bandykite dar kartą.';

  @override
  String get syncDeviceRevoked => 'Atšauktas';

  @override
  String get syncDeviceLocal => 'Šis prietaisas';

  @override
  String get cloudTrafficTitle =>
      'Mėnesio debesies duomenų perdavimo kvota medijos failams';

  @override
  String get cloudTrafficLimit => 'Mėnesio duomenų perdavimo kvota';

  @override
  String get cloudTrafficUsed => 'Naudojamas duomenų perdavimas';

  @override
  String get cloudTrafficRemaining => 'Liko duomenų perdavimo';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'Duomenų perdavimo kvota iš naujo nustato $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'Išnaudota medijos failų duomenų perdavimo debesyje kvota. Trūkstami medijos failai bus sinchronizuojami automatiškai, kai bus pasiekiamas tiesioginis ryšys arba iš naujo nustatoma kvota.';

  @override
  String get cloudTrafficExplanation =>
      'Medijos failų kaupimas talpykloje ir tiesioginė perdavimas dalijasi šia duomenų perdavimo kvota. Tiesioginiai ryšiai jo nesunaudoja. Dienoraščio tekstas ir ryšio valdymo pranešimai turi atskirus nedidelius dienos limitus.';

  @override
  String get appearanceThemeSection => 'Programėlės tema';

  @override
  String get appearancePaperSection => 'Dienoraščio popierius';

  @override
  String get appearanceTypographySection => 'Dienoraščio tekstas';

  @override
  String get appearancePreferencesSection => 'Bendrosios nuostatos';

  @override
  String get themeSystemAccentHint =>
      'Naudoja sistemos paletę, o ne pasirinktines spalvas. Išjunkite jį, kad pasirinktumėte savo.';

  @override
  String get syncDeviceNameSaveFailed =>
      'Nepavyko išsaugoti įrenginio pavadinimo. Bandykite dar kartą.';

  @override
  String get nearbyConnectionHelp => 'Prisijungimo pagalba';

  @override
  String get syncAllSynced => 'Viskas sinchronizuota';

  @override
  String get syncDetailsTitle => 'Sinchronizavimo informacija';

  @override
  String get syncMore => 'Daugiau parinkčių';

  @override
  String get syncDeviceName => 'Įrenginio pavadinimas';

  @override
  String get syncDeviceNameHint => 'Pavyzdžiui: Mano planšetinis kompiuteris';

  @override
  String get syncDeviceNameInvalid => 'Naudokite nuo 1 iki 32 simbolių';

  @override
  String get syncDeviceKeyDetails => 'Saugumo detalės';

  @override
  String get syncConnectionProblem =>
      'Šiuo metu nepavyko sinchronizuoti. Automatiškai bandoma iš naujo.';

  @override
  String get syncCopyComplete =>
      'Pilna jūsų dienoraščio ir medijos failų kopija';

  @override
  String get syncCopyPartial => 'Kai kurios žiniasklaidos vis dar trūksta';

  @override
  String get syncCopyOlder => 'Nauji pakeitimai laukia sinchronizavimo';

  @override
  String get syncCopyUnavailable =>
      'Išsamios kopijos informacijos negalima. Vėliau bandykite dar kartą.';

  @override
  String get syncCopyLastKnown =>
      'Kiti įrenginiai rodo paskutinę patvirtintą kopiją. Dabar negalima patikrinti neprisijungus naudojamų įrenginių.';

  @override
  String get syncCopyTemporary =>
      'Laikinoji talpykla. Laikykite originalus savo įrenginiuose.';

  @override
  String get syncCopyStorage =>
      'Jūsų sinchronizavimo saugykla. Užbaigti medijos įkėlimai pateikiami diagnostikoje.';

  @override
  String syncCopyChecked(String time) {
    return 'Paskutinį kartą patvirtintas $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Šį mėnesį likęs duomenų perdavimas: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Pradėkite čia';

  @override
  String get onboardConnect => 'Prisijunkite prie esamo įrenginio';

  @override
  String get onboardFailed =>
      'Nepavyko užbaigti sąrankos. Jūsų dienoraštis yra saugus; pabandykite dar kartą.';

  @override
  String get tutorialTitle => 'Kaip naudotis dienoraščiu';

  @override
  String get tutorialWriteTitle => 'Parašykite savo pirmąjį įrašą dienoraštyje';

  @override
  String get tutorialWriteText =>
      'Norėdami parašyti dienoraščio įrašą, bakstelėkite +. Pridėkite pasirenkamą pavadinimą, pasirinkite dienoraščio datą ir bakstelėkite varnelę, kad išsaugotumėte. Galite bet kada vėl redaguoti savo dienoraščio įrašą.';

  @override
  String get tutorialMediaTitle => 'Pridėkite nuotraukų, garso ar rašysenos';

  @override
  String get tutorialMediaText =>
      'Naudokite + dienoraščio rengyklėje, kad pridėtumėte nuotraukų, vaizdo įrašų ar balso įrašų arba atidarytumėte rašymo ranka drobę. Šie priedai išsaugomi su dienoraščio įrašu.';

  @override
  String get tutorialReviewTitle => 'Vėl rask dieną';

  @override
  String get tutorialReviewText =>
      'Naršykite savo dienoraštį ar kalendorių, ieškokite savo raštuose ir tvarkykite įrašus su žymomis. Puslapiuose Media ir Atlas galite rasti ankstesnius įrašus pagal nuotrauką arba vietą.';

  @override
  String get tutorialSyncTitle => 'Naudokite daugiau nei vieną įrenginį';

  @override
  String get tutorialSyncText =>
      'Skiltyje Nustatymai → Duomenys ir saugykla → Sinchronizuoti prisijunkite prie esamo įrenginio ir patvirtinkite to įrenginio prieigos teisę. Abu įrenginiai gali toliau naudoti dienoraštį. Pirmiausia sinchronizuojamas dienoraščio tekstas. Medijos failai sinchronizuojami toliau, kai tai leidžia tinklo ryšys ir likusi duomenų perdavimo kvota.';

  @override
  String get tutorialPrivacyTitle => 'Saugokite savo dienoraštį';

  @override
  String get tutorialPrivacyText =>
      'Dienoraščio įrašai lieka šiame įrenginyje, nebent įgalinsite sinchronizavimą, bendrinsite arba eksportuosite juos. Sinchronizavimas yra visiškai užšifruotas. Nustatymuose taip pat galite nustatyti programos prieigos kodą, kurti atsargines kopijas ir iš naujo atidaryti šią mokymo programą.';

  @override
  String get editorDiaryDay => 'Dienoraščio diena';

  @override
  String get editorDiaryDayPicker =>
      'Dienoraščio diena · Kuriai dienai priklauso šis įrašas?';

  @override
  String editorCreatedAt(String time) {
    return 'Sukurta $time';
  }

  @override
  String get editorDiaryDayHint =>
      'Diena, kuriai priklauso šis įrašas. Ją pakeitus įrašo sukūrimo laikas nesikeičia.';

  @override
  String get hiddenDiaryTitle => 'Paslėpti įrašai';

  @override
  String get hiddenDiaryHide => 'Slėpti įrašą';

  @override
  String get hiddenDiaryShow => 'Rodyti įrašą';

  @override
  String get hiddenDiaryEmpty => 'Paslėptų įrašų nėra';

  @override
  String get hiddenDiaryUnlock => 'Atrakinti paslėptus įrašus';

  @override
  String get hiddenDiaryAuthHint =>
      'Naudokite programėlės arba įrenginio ekrano užraktą.';

  @override
  String hiddenDiaryWhere(String path) {
    return 'Paslėpta. Vėl parodyti galima čia: $path';
  }

  @override
  String get noteKeep => 'Išsaugoti';

  @override
  String get noteComment => 'Komentuoti';

  @override
  String get noteCommentHint => 'Parašyk sau iš praeities';

  @override
  String get noteKept => 'Ištrauka išsaugota';

  @override
  String get notesPassages => 'Išsaugotos ištraukos';

  @override
  String get notesComments => 'Komentarai';

  @override
  String get noteDeleteConfirm => 'Ištrinti šią pastabą?';

  @override
  String get editPastTitle => 'Redaguoti praeities prisiminimą?';

  @override
  String get editPastBody =>
      'Šis įrašas yra iš ankstesnės dienos. Norėdami į jį atsakyti, pažymėkite tekstą ir išsaugokite arba pakomentuokite.';

  @override
  String get editPastDontAsk => 'Daugiau neklausti';

  @override
  String get editPastEdit => 'Vis tiek redaguoti';

  @override
  String noteOnEntry(String date) {
    return 'Apie $date įrašą';
  }

  @override
  String get settingsConfirmEditPast =>
      'Klausti prieš redaguojant senus įrašus';

  @override
  String get commentExpand => 'Išskleisti';

  @override
  String get refAdd => 'Cituoti įrašą';

  @override
  String get refMissing => 'Šio įrašo nebėra';

  @override
  String get moodClear => 'Išvalyti nuotaiką';

  @override
  String get scrollToTop => 'Į viršų';

  @override
  String get feedbackTitle => 'Atsiliepimas';

  @override
  String get feedbackHint => 'Aprašykite problemą ar pasiūlymą';

  @override
  String get feedbackGithub => 'GitHub problema';

  @override
  String get feedbackEmail => 'Siųsti el. laišką';

  @override
  String get feedbackCopy => 'Kopijuoti tekstą';

  @override
  String get feedbackLaunchFailed =>
      'Nepavyko atidaryti programos. Nukopijuokite tekstą ir naudokite el. paštą žemiau.';

  @override
  String get feedbackCopied => 'Atsiliepimas nukopijuotas';
}
