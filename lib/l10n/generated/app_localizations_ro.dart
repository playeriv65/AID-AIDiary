// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => 'Culoarea temei';

  @override
  String get themeColorHint => 'Alegeți o culoare pentru această paletă.';

  @override
  String get themeColorBlue => 'Albastru cer';

  @override
  String get themeColorGreen => 'Verde de pădure';

  @override
  String get themeColorBrown => 'Cafea caldă';

  @override
  String get themeColorPurple => 'Lavandă';

  @override
  String get themeColorRose => 'Trandafir prafuit';

  @override
  String get themeColorAmber => 'chihlimbar';

  @override
  String get themeColorPreview => 'Puțin în fiecare zi';

  @override
  String get themeTintBackgroundTitle => 'Nuanța fundalului cu culoarea temei';

  @override
  String get themeTintBackgroundHint =>
      'Dezactivați pentru fundaluri gri neutre; butoanele păstrează culoarea aleasă.';

  @override
  String get dailyReminderTitle => 'Înregistrează-te astăzi!';

  @override
  String get dailyReminderDescription => 'Completează-ți jurnalul zilnic…';

  @override
  String get actionTakePhoto => 'Fă o poză';

  @override
  String get flashbacksTitle => 'Amintiri';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Exclude zilele proaste';

  @override
  String get flashbackGoodDay => 'O zi bună';

  @override
  String get flashbackRandomDay => 'O zi aleatorie';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Acum $count de săptămâni',
      one: 'Acum $count saptamana',
      few: 'Acum $count săptămâni',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Acum $count de luni',
      one: 'Acum $count lună',
      few: 'Acum $count luni',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Acum $count de ani',
      one: 'Acum $count an',
      few: '$count ani în urmă',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'În această zi';

  @override
  String get searchLogsHint => 'Caută Înregistrări…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de înregistrări în jurnal',
      one: '$count înregistrare în jurnal',
      few: '$count intrări în jurnal',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de zile',
      one: '$count zi',
      few: '$count zile',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de cuvinte',
      one: '$count cuvânt',
      few: '$count cuvinte',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Nicio Înregistrare…';

  @override
  String get noResults => 'Nu sunt rezultate…';

  @override
  String get sortOrderAscendingTitle => 'Crescător';

  @override
  String get sortOrderDescendingTitle => 'Descrescător';

  @override
  String get pageStatisticsTitle => 'Statistici';

  @override
  String get statisticsNotEnoughData => 'Nu există suficiente date…';

  @override
  String get statisticsRangeOneMonth => '1 Lună';

  @override
  String get statisticsRangeSixMonths => '6 Luni';

  @override
  String get statisticsRangeOneYear => '1 An';

  @override
  String get statisticsRangeAllTime => 'Dintotdeauna';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag Rezumat';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag Pe Zi';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag De-a Lungul Timpului';
  }

  @override
  String get chartGroupingLabel => 'Grupează după';

  @override
  String get chartGroupingDay => 'Zi';

  @override
  String get chartGroupingWeek => 'Săptămână';

  @override
  String get chartGroupingMonth => 'Lună';

  @override
  String get chartGroupingYear => 'An';

  @override
  String get chartSmoothingLabel => 'Netezire';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Serie actuală $count',
      one: 'Serie actuală $count',
      few: 'Serie curentă $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cea mai lungă serie $count',
      one: 'Cea mai lungă serie $count',
      few: 'Cea mai lungă serie $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zilele Mari $count',
      one: 'Zilele grozave $count',
      few: 'Zilele grozave $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zile de la o zi proastă $count',
      one: 'Zile de la o zi proastă $count',
      few: 'Zile de la o zi proastă $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Nu Se Poate Accesa Stocarea Internă';

  @override
  String get errorExternalStorageAccessDescription =>
      'Dacă folosești stocare în rețea, asigură-te că serviciul este online și că ai acces la internet.\n\nÎn caz contrar, este posibil ca aplicația să fi pierdut permisiunile pentru folderul extern. Mergi la setări și selectează din nou folderul extern pentru a-i acorda acces.\n\nAtenție: modificările nu vor fi sincronizate până când nu restabilești accesul la spațiul de stocare extern!';

  @override
  String get errorExternalStorageAccessContinue => 'Continuă Cu Datele Locale';

  @override
  String get lastModified => 'Modificat';

  @override
  String get writeSomethingHint => 'Scrie ceva…';

  @override
  String get titleHint => 'Titlu…';

  @override
  String get deleteLogTitle => 'Șterge Logul';

  @override
  String get deleteLogDescription => 'Dorești să ștergi acest log?';

  @override
  String get deletePhotoTitle => 'Șterge Poză';

  @override
  String get deletePhotoDescription => 'Dorești să ștergi această poză?';

  @override
  String get pageSettingsTitle => 'Setări';

  @override
  String get settingsTheme => 'Temă';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Luminos';

  @override
  String get themeDark => 'Întuncat';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Prima Zi A Săptămânii';

  @override
  String get settingsCalendarSystem => 'Calendar de Sistem';

  @override
  String get calendarSystemGregorian => 'Gregorian';

  @override
  String get calendarSystemJalali => 'Jalali';

  @override
  String get settingsUseSystemAccentColor =>
      'Folosește Culoarea De Accent A Sistemului';

  @override
  String get settingsCustomAccentColor => 'Culoare De Accent Personalizată';

  @override
  String get settingsShowFlashbacks => 'Arată Amintiri';

  @override
  String get settingsChangeMoodIcons => 'Schimbă Iconițele Pentu Setări';

  @override
  String get moodIconPrompt => 'Introdu o iconiță';

  @override
  String get settingsHideImages => 'Ascunde Imaginile';

  @override
  String get pageCalendarTitle => 'Calendar';

  @override
  String get settingsNotificationsTitle => 'Notificări';

  @override
  String get settingsDailyReminderTitle => 'Memento Zilnic';

  @override
  String get settingsOnThisDayDescription => 'Revizitează memoriile din trecut';

  @override
  String get settingsDailyReminderDescription =>
      'O simplă aducere aminte în fiecare zi';

  @override
  String get settingsReminderTime => 'Ora mementoului';

  @override
  String get settingsFixedReminderTimeTitle => 'Oră fixă pentru memento';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Alege o oră fixă pentru memento';

  @override
  String get settingsAlwaysSendReminderTitle => 'Trimite Întotdeauna Memento';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Trimite memento chiar dacă o înregistrare a fost începută deja';

  @override
  String get settingsCustomizeNotificationTitle =>
      'Personalizează Notificările';

  @override
  String get settingsTemplatesTitle => 'Șabloane';

  @override
  String get manageTemplates => 'Gestionează Șabloane';

  @override
  String get noTemplateTitle => 'Nici unul';

  @override
  String get noTemplatesDescription => 'Nici un șablon creat încă…';

  @override
  String get templateDefaultTimestampTitle => 'Marcaj temporal';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Rezumatul Zilei';

  @override
  String get templateDefaultSummaryBody => '### Rezumat\n- \n\n### Citat\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Reflecție';

  @override
  String get templateDefaultReflectionBody =>
      '### Ce ți-a plăcut astăzi?\n- \n\n### Pentru ce ești recunoscător?\n- \n\n### Ce aștepți cu nerăbdare?\n- ';

  @override
  String get settingsTagsTitle => 'Etichete';

  @override
  String get manageTags => 'Gestionați etichetele';

  @override
  String get tagTypeLabelTitle => 'Etichetă';

  @override
  String get tagTypeTrackerTitle => 'Tracker';

  @override
  String get nameHint => 'Nume';

  @override
  String get tagColorLabel => 'Culoare';

  @override
  String get iconPickerTitle => 'Alegeți pictograma';

  @override
  String get iconPickerIconsTab => 'Pictograme';

  @override
  String get iconPickerCustomTab => 'Personalizat';

  @override
  String get iconPickerSearchHint => 'Pictograme de căutare...';

  @override
  String get colorPickerTitle => 'Alegeți Culoare';

  @override
  String get colorPickerPaletteTab => 'Culori';

  @override
  String get iconGroupMoodPeople => 'Dispoziție și oameni';

  @override
  String get iconGroupHealth => 'Sănătate';

  @override
  String get iconGroupWorkFinance => 'Muncă și finanțe';

  @override
  String get iconGroupHabitsGoals => 'Obiceiuri și obiective';

  @override
  String get iconGroupNature => 'Natura';

  @override
  String get iconGroupFoodDrink => 'Mâncare și băutură';

  @override
  String get iconGroupHome => 'Acasă';

  @override
  String get iconGroupTravel => 'Călătorie';

  @override
  String get iconGroupSymbols => 'Simboluri';

  @override
  String get tagCategoryLabel => 'categorie';

  @override
  String get tagLabel => 'Etichetați';

  @override
  String get tagCategoryUncategorized => 'Necategorizat';

  @override
  String get newCategoryTitle => 'Noua categorie';

  @override
  String get shareButtonLabel => 'Distribuie';

  @override
  String get importErrorDescription => 'Nu s-a putut importa fișierul!';

  @override
  String get exportErrorDescription => 'Nu s-a putut exporta fișierul!';

  @override
  String get deleteTitle => 'Ștergeți';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Este folosit în $count de înregistrări din jurnal.',
      one: ' Este folosit într-o intrare de jurnal.',
      few: ' Este folosit în $count înregistrări din jurnal.',
      zero: '',
    );
    return 'Ștergeți „$name”?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Cele $count de etichete ale sale vor fi, de asemenea, șterse.',
      one: ' Eticheta sa $count va fi, de asemenea, ștearsă.',
      few: ' Etichetele sale $count vor fi, de asemenea, șterse.',
      zero: '',
    );
    return 'Ștergeți „$name”?$_temp0';
  }

  @override
  String get tagNameExists => 'Există deja o etichetă cu acest nume';

  @override
  String get categoryNameExists => 'Există deja o categorie cu acest nume';

  @override
  String deleteTemplateMessage(Object name) {
    return 'Ștergeți „$name”?';
  }

  @override
  String get addTagsTitle => 'Adăugați etichete';

  @override
  String get addTagsSearchHint => 'Etichete de căutare...';

  @override
  String get tagFavoriteName => 'Favorit';

  @override
  String get iconGroupActivities => 'Activități';

  @override
  String get iconGroupHobbies => 'Divertisment';

  @override
  String get settingsStorageTitle => 'Depozitare';

  @override
  String get settingsImageQuality => 'Calitatea imaginii';

  @override
  String get imageQualityHigh => 'Înalt';

  @override
  String get imageQualityMedium => 'Mediu';

  @override
  String get imageQualityLow => 'Scăzut';

  @override
  String get imageQualityNoCompression => 'Fără compresie';

  @override
  String get settingsLogFolder => 'dosar de intrare în jurnal';

  @override
  String get settingsImageFolder => 'Dosar imagine';

  @override
  String get warningTitle => 'Avertisment';

  @override
  String get logFolderWarningDescription =>
      'Dacă folderul selectat conține deja un fișier „aid_diary.db”, acesta va fi folosit pentru a suprascrie intrările existente din jurnal!';

  @override
  String get errorTitle => 'Eroare';

  @override
  String get logFolderErrorDescription =>
      'Nu s-a putut schimba folderul de introducere a jurnalului!';

  @override
  String get imageFolderErrorDescription =>
      'Nu s-a putut schimba folderul de imagini!';

  @override
  String get backupErrorDescription => 'Nu s-a putut crea backup!';

  @override
  String get restoreErrorDescription => 'Nu s-a restabilit backupul!';

  @override
  String get settingsBackupRestoreTitle => 'Backup și restaurare';

  @override
  String get settingsBackup => 'Backup';

  @override
  String get settingsRestore => 'Restaurați';

  @override
  String get settingsRestorePromptDescription =>
      'Restaurarea unei copii de rezervă va suprascrie datele existente!';

  @override
  String get settingsBackupPasswordProtect =>
      'Copii de rezervă protejate cu parolă';

  @override
  String get backupEncryptedTitle => 'Backup criptat';

  @override
  String get backupEncryptedContent =>
      'Această copie de rezervă este protejată prin parolă.';

  @override
  String get settingsAutoBackup => 'Backup-uri automate';

  @override
  String get settingsAutoBackupLocation => 'Locație de rezervă';

  @override
  String get settingsAutoBackupInterval => 'Interval de backup';

  @override
  String get settingsAutoBackupIntervalDaily => 'Zilnic';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Săptămânal';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Lunar';

  @override
  String get settingsAutoBackupMaxCount => 'Backup-uri de păstrat';

  @override
  String get settingsAutoBackupRequireCharging => 'Numai în timpul încărcării';

  @override
  String settingsBackupLast(Object time) {
    return 'Ultima copie de rezervă $time';
  }

  @override
  String get settingsBackupNever => 'Niciodată nu a făcut rezervă';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Următorul backup $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'Toate';

  @override
  String get autoBackupFailedTitle => 'Backup eșuat';

  @override
  String tranferStatus(Object percent) {
    return 'Se transferă... $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Se creează o copie de rezervă... $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Se restabilește backupul... $percent%';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return 'Se criptează backupul... $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Se decriptează backupul... $percent%';
  }

  @override
  String get cleanUpStatus => 'Curățare…';

  @override
  String get settingsExportToAnotherFormat => 'Exportați într-un alt format';

  @override
  String get settingsExportFormatDescription =>
      'Aceasta nu ar trebui folosită ca rezervă!';

  @override
  String get settingsImportFromAnotherApp => 'Importați dintr-o altă aplicație';

  @override
  String get logFormatTitle => 'Alegeți Format';

  @override
  String get logFormatDescription =>
      'Este posibil ca formatul unei alte aplicații să nu accepte toate funcțiile. Vă rugăm să raportați orice problemă, deoarece formatele terților se pot schimba în orice moment. Acest lucru nu va afecta înregistrările existente în jurnal!';

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
  String get settingsDeleteAllLogsTitle =>
      'Ștergeți toate înregistrările din jurnal';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Doriți să ștergeți toate înregistrările din jurnal?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Introdu „$prompt” pentru a confirma. Acest lucru nu poate fi anulat!';
  }

  @override
  String get settingsAppLanguageTitle => 'Limba aplicației';

  @override
  String get settingsSecurityTitle => 'Securitate';

  @override
  String get settingsSecurityRequirePassword => 'Solicitați parola';

  @override
  String get settingsSecurityEnterPassword => 'Introduceți parola';

  @override
  String get settingsSecuritySetPassword => 'Setați parola';

  @override
  String get settingsSecurityChangePassword => 'Schimbați parola';

  @override
  String get settingsSecurityPassword => 'Parolă';

  @override
  String get settingsSecurityConfirmPassword => 'Confirmați parola';

  @override
  String get settingsSecurityOldPassword => 'Parolă veche';

  @override
  String get settingsSecurityIncorrectPassword => 'Parolă incorectă';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'Parolele nu se potrivesc';

  @override
  String get requiredPrompt => 'Necesar';

  @override
  String get settingsSecurityBiometricUnlock => 'Deblocare biometrică';

  @override
  String get unlockAppPrompt => 'Deblocați aplicația';

  @override
  String get settingsAboutTitle => 'Despre';

  @override
  String get settingsVersion => 'Versiune';

  @override
  String get settingsLicense => 'Licență';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsOpenSourceLicenses => 'Licențe Open Source';

  @override
  String get tagMoodTitle => 'Starea de spirit';

  @override
  String get selectTagTitle => 'Selectați Etichetă';

  @override
  String get labelPresentLabel => 'Prezent';

  @override
  String get labelAbsentLabel => 'absent';

  @override
  String get labelCoverageLabel => 'Acoperire';

  @override
  String chartDistributionTitle(Object tag) {
    return '$tag Distribuție';
  }

  @override
  String get shareAddToLogPickerTitle => 'Alegeți o înregistrare în jurnal';

  @override
  String get adaptiveEmptyDay =>
      'Încă nu există înregistrări pentru această zi';

  @override
  String get adaptiveNewEntry => 'Scrieți o intrare';

  @override
  String get pageJournalTitle => 'Jurnal';

  @override
  String get coachPrompt1 => 'Ce te-a făcut să zâmbești astăzi?';

  @override
  String get coachPrompt2 => 'Care este un lucru pe care l-ai învățat astăzi?';

  @override
  String get coachPrompt3 => 'Cu cine ai vorbit astăzi și cum te-ai simțit?';

  @override
  String get coachPrompt4 => 'Pentru ce ești recunoscător acum?';

  @override
  String get coachPrompt5 =>
      'Ce ți-a luat cea mai mare parte a energiei astăzi?';

  @override
  String get coachPrompt6 =>
      'Descrieți un mic moment pe care doriți să-l amintiți.';

  @override
  String get coachPrompt7 => 'Ce ar face mâine o zi bună?';

  @override
  String get coachPrompt8 => 'Ce ți-a trecut prin cap în ultima vreme?';

  @override
  String get coachPrompt9 => 'Ce ai făcut azi doar pentru tine?';

  @override
  String get coachPrompt10 => 'Dacă azi ar avea un titlu, care ar fi acesta?';

  @override
  String get pageMediaTitle => 'Media';

  @override
  String get pageAtlasTitle => 'Atlas';

  @override
  String get pageCoachTitle => 'Antrenor';

  @override
  String get noEntrySelected => 'Nicio intrare selectată.';

  @override
  String get entryShare => 'Distribuie';

  @override
  String get entryFavorite => 'Steaua';

  @override
  String get entryEdit => 'Editați';

  @override
  String get entryPrevious => 'Intrarea anterioară';

  @override
  String get entryNext => 'Următoarea intrare';

  @override
  String get journalStories => 'Povești';

  @override
  String get journalEntries => 'Intrări';

  @override
  String get journalEmptyHint =>
      'Începeți-vă jurnalul adăugând o nouă intrare.';

  @override
  String get storyToday => 'Astăzi';

  @override
  String get storyThrowback => 'Revenire';

  @override
  String get storyNoThrowback => 'Nicio întoarcere azi';

  @override
  String get mediaFiles => 'Fișiere media';

  @override
  String get mediaEmpty => 'Nicio fotografie încă.';

  @override
  String get mediaEmptyHint =>
      'Fotografiile atașate la intrări vor fi afișate aici.';

  @override
  String get atlasEmpty => 'Nu există intrări cu o locație.';

  @override
  String get atlasEmptyHint => 'Intrările cu o locație vor fi afișate aici.';

  @override
  String get atlasShowAll => 'Afișați toate intrările';

  @override
  String get atlasMyLocation => 'Locația mea';

  @override
  String get coachAll => 'Toate';

  @override
  String get coachPrograms => 'Programe';

  @override
  String get coachTemplates => 'Șabloane';

  @override
  String get coachKindProgram => 'Program';

  @override
  String get coachKindTemplate => 'Șablon';

  @override
  String get coachNoTemplates => 'Fără programe sau șabloane.';

  @override
  String get coachUseTemplate => 'Scrieți cu acest șablon';

  @override
  String get coachProgramEverydayTitle => 'Momente de zi cu zi';

  @override
  String get coachProgramEverydayDescription =>
      'Cinci întrebări scurte, una pe zi. Fiecare durează un minut sau două și te ajută să vezi ce a făcut ziua ta. O modalitate blândă de a construi obiceiul de a scrie puțin în fiecare zi.';

  @override
  String get coachProgramReflectTitle => 'Privind înăuntru';

  @override
  String get coachProgramReflectDescription =>
      'O întrebare mai profundă pe săptămână, timp de cinci săptămâni. Fă-ți timp cu fiecare: cum te-ai simțit, ce te epuizează, pentru ce ești recunoscător.';

  @override
  String get searchFilters => 'Filtre';

  @override
  String get searchFilterTags => 'Etichete';

  @override
  String get searchFilterStarred => 'Cu stea';

  @override
  String get searchHint => 'Tastați pentru a căuta sau alegeți un filtru.';

  @override
  String get locationTitle => 'Locație';

  @override
  String get locationName => 'Numele locului';

  @override
  String get locationRemove => 'Eliminați';

  @override
  String get locationServiceDisabled =>
      'Serviciile de localizare sunt dezactivate.';

  @override
  String get locationPermissionDenied =>
      'Permisiunea de locație a fost refuzată.';

  @override
  String get locationUnavailable => 'Nu s-a putut obține locația actuală.';

  @override
  String get calendarJumpToToday => 'Sari la azi';

  @override
  String get editorStartWriting => 'Începeți să scrieți sau alegeți a ';

  @override
  String get editorTemplateLink => 'Șablon';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Alegeți un șablon';

  @override
  String get templateFeatured => 'Șabloane recomandate';

  @override
  String get templateMine => 'Șabloanele mele';

  @override
  String get templateDailyName => 'Revizuire zilnică';

  @override
  String get templateDailyDescription =>
      'Ce s-a întâmplat, cum s-a simțit și ce urmează.';

  @override
  String get templateDailyText =>
      '## Ce s-a întâmplat astăzi\n\n\n## Cum m-am simțit\n\n\n## Trei lucruri pentru care sunt recunoscător\n1. \n2. \n3. \n\n## Mâine\n';

  @override
  String get templateTravelName => 'Intrare în jurnal de călătorie';

  @override
  String get templateTravelDescription =>
      'Locuri, momente și mâncare din drum.';

  @override
  String get templateTravelText =>
      '## Unde am fost\n\n\n## Momentul pe care mi-l amintesc cel mai mult\n\n\n## Ce am mâncat\n\n\n## Planuri pentru mâine\n';

  @override
  String get templateReadingName => 'Note de lectură';

  @override
  String get templateReadingDescription =>
      'Citate și gânduri din ceea ce ați citit.';

  @override
  String get templateReadingText =>
      '## Cartea\n\n\n## Unde sunt\n\n\n## Citate\n> \n\n## Gândurile mele\n';

  @override
  String get templateWeeklyName => 'Revizuire săptămânală';

  @override
  String get templateWeeklyDescription =>
      'Repere, lupte și concentrarea săptămânii viitoare.';

  @override
  String get templateWeeklyText =>
      '## Repere\n\n\n## Ce a fost greu\n\n\n## Ce am învățat\n\n\n## Concentrați-vă pentru săptămâna viitoare\n';

  @override
  String get entrySaveAsTemplate => 'Salvați ca șablon';

  @override
  String get entrySavedAsTemplate => 'Salvat ca șablon';

  @override
  String get storyStatistics => 'Statistici';

  @override
  String get storyMoodChart => 'Diagrama de dispoziție';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return '$entries intrări · $days zile';
  }

  @override
  String get storyThisYear => 'Anul acesta';

  @override
  String get storyLastYear => 'Anul trecut';

  @override
  String get storyTapToOpen => 'Atingeți o zi pentru a o deschide';

  @override
  String get settingsGeneralTitle => 'general';

  @override
  String get settingsDataTitle => 'Date și stocare';

  @override
  String get settingsStoriesTitle => 'Povești';

  @override
  String get settingsHelpTitle => 'Ajutor și despre';

  @override
  String get weatherTitle => 'Vremea';

  @override
  String get weatherClear => 'Clar';

  @override
  String get weatherPartlyCloudy => 'Parţial noros';

  @override
  String get weatherCloudy => 'Înnorat';

  @override
  String get weatherFog => 'Ceață';

  @override
  String get weatherDrizzle => 'Burniță';

  @override
  String get weatherRain => 'ploaie';

  @override
  String get weatherSnow => 'Zăpadă';

  @override
  String get weatherStorm => 'Furtună';

  @override
  String get weatherFetch => 'Obțineți vremea pentru această intrare';

  @override
  String get weatherNeedsLocation =>
      'Adăugați mai întâi o locație cu coordonate.';

  @override
  String get weatherUnavailable =>
      'Vremea nu este disponibilă pentru acest loc și oră.';

  @override
  String get weatherRemove => 'Îndepărtați vremea';

  @override
  String get activityTitle => 'Activitate';

  @override
  String get activityStill => 'Totuşi';

  @override
  String get activityWalking => 'Mersul pe jos';

  @override
  String get activityRunning => 'Alergarea';

  @override
  String get activityCycling => 'Ciclism';

  @override
  String get activityVehicle => 'Într-un vehicul';

  @override
  String get activityFlying => 'Zburând';

  @override
  String get activityExercise => 'Exercițiu';

  @override
  String get activityDetect => 'Detectează activitatea curentă';

  @override
  String get activityDetectFailed => 'Nu s-a putut detecta o activitate.';

  @override
  String get activityRemove => 'Eliminați activitatea';

  @override
  String get settingsAutoAddTitle => 'Adăugați automat';

  @override
  String get settingsAutoAddLocation => 'Locație';

  @override
  String get settingsAutoAddWeather => 'Vremea';

  @override
  String get settingsAutoAddHint =>
      'Noile intrări sunt completate atunci când sunt create.';

  @override
  String get settingsTemperatureUnit => 'Unitate de temperatură';

  @override
  String get settingsCelsius => 'Celsius (°C)';

  @override
  String get settingsFahrenheit => 'Fahrenheit (°F)';

  @override
  String get moodGreat => 'grozav';

  @override
  String get moodGood => 'Bun';

  @override
  String get moodOkay => 'Bine';

  @override
  String get moodBad => 'Rău';

  @override
  String get moodAwful => 'îngrozitor';

  @override
  String get locationSearchHint => 'Caută un loc';

  @override
  String get locationSearchEmpty => 'Nu s-au găsit locuri';

  @override
  String get settingsWallpaper => 'Tapet';

  @override
  String get wallpaperNone => 'Niciuna';

  @override
  String get wallpaperDots => 'Puncte';

  @override
  String get wallpaperGrid => 'Grilă';

  @override
  String get wallpaperLines => 'Linii';

  @override
  String get wallpaperPhoto => 'Fotografie…';

  @override
  String get settingsFontFamily => 'Font';

  @override
  String get fontSystem => 'Sistem';

  @override
  String get fontSerif => 'Serif';

  @override
  String get fontMono => 'Monospațiu';

  @override
  String get settingsFontSize => 'Dimensiunea fontului';

  @override
  String get fontSizeSmall => 'Mic';

  @override
  String get fontSizeMedium => 'Mediu';

  @override
  String get fontSizeLarge => 'Mare';

  @override
  String get fontSizeExtraLarge => 'Foarte mare';

  @override
  String get settingsLineSpacing => 'Spațiere între linii';

  @override
  String get lineSpacingCompact => 'Compact';

  @override
  String get lineSpacingNormal => 'Normal';

  @override
  String get lineSpacingRelaxed => 'Relaxat';

  @override
  String get moodAssociationsTitle => 'Ce ma face sa simt...';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching a intrărilor $total';
  }

  @override
  String get videoRecord => 'Înregistrați un videoclip';

  @override
  String get videoChoose => 'Alegeți un videoclip';

  @override
  String get audioRecordTitle => 'Înregistrați o notă vocală';

  @override
  String get audioChoose => 'Alegeți un fișier audio';

  @override
  String get audioStart => 'Înregistrează';

  @override
  String get audioStop => 'Oprește-te și salvează';

  @override
  String get audioPermissionDenied =>
      'Accesul la microfon este dezactivat. Permiteți-l în setările sistemului.';

  @override
  String get mediaTooLarge =>
      'Acest videoclip este prea mare pentru a fi atașat.';

  @override
  String get mediaUnavailable =>
      'Acest atașament nu este disponibil pe acest dispozitiv.';

  @override
  String get widgetDone => 'Intrarea de azi este scrisă';

  @override
  String get widgetPending => 'Cum a fost ziua ta?';

  @override
  String get widgetWrite => 'Scrie';

  @override
  String get insertChecklist => 'Lista de verificare';

  @override
  String get insertNumberedList => 'Lista numerotata';

  @override
  String get insertTable => 'Tabelul';

  @override
  String get insertDivider => 'Divizor';

  @override
  String get insertCodeBlock => 'Bloc de cod';

  @override
  String get journalSortTitle => 'Sortați intrările';

  @override
  String get journalSortUpdated => 'Ultima actualizare';

  @override
  String get settingsTimeFormat => 'Format de timp';

  @override
  String get settingsDayStart =>
      'Noile intrări contează pentru o zi înainte până la';

  @override
  String get settingsDayAskUntil => 'Apoi intreaba pana in ce zi';

  @override
  String get settingsDayStartMidnight => 'Oprit';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Fiecare intrare păstrează ziua căreia îi aparține alături de ora la care a fost scrisă și o poți schimba oricând în editor. Aceste ore aleg doar ziua pentru noile intrări, așa că modificarea lor nu mută nicio intrare existentă.';

  @override
  String get lateNightBadge => 'Scris noaptea târziu, socotit cu o zi înainte';

  @override
  String editorDayAsk(String time) {
    return 'Scris la $time. Pentru care zi este?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (ieri)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (azi)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'Scris $when';
  }

  @override
  String get timeFormat12 => '12 ore';

  @override
  String get timeFormat24 => '24 de ore';

  @override
  String get settingsReminderDays => 'Amintește-mi';

  @override
  String get locationRecent => 'Locuri recente';

  @override
  String get shareImage => 'Distribuiți imaginea';

  @override
  String get shareSaveImage => 'Salvați imaginea';

  @override
  String get shareSaved => 'Imaginea salvată';

  @override
  String get deletedTitle => 'Șters recent';

  @override
  String get deletedNone => 'Nimic nu a fost șters recent';

  @override
  String deletedHint(int days) {
    return 'Intrările șterse rămân aici pentru zile $days, apoi sunt șterse.';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days zile rămase';
  }

  @override
  String get deletedRestore => 'Restaurați';

  @override
  String get deletedDeleteForever => 'Ștergeți pentru totdeauna';

  @override
  String get deletedDeleteForeverDescription =>
      'Înregistrarea și atașamentele sale sunt șterse. Acest lucru nu poate fi anulat.';

  @override
  String get deletedEmpty => 'Gol';

  @override
  String get deletedEmptyDescription =>
      'Ștergeți fiecare intrare din Ștergerea recentă? Acest lucru nu poate fi anulat.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Plimbare aleatorie';

  @override
  String get randomSubtitle => 'Deschideți o intrare anterioară';

  @override
  String get randomNext => 'Altul';

  @override
  String get randomAll => 'Toate';

  @override
  String get randomWithPhotos => 'Cu fotografii';

  @override
  String get randomGoodDays => 'Zile bune';

  @override
  String get randomEmpty => 'Nu există intrări din care să alegeți';

  @override
  String get reviewWeekTitle => 'Săptămâna aceasta';

  @override
  String get reviewWeekSubtitle => 'Săptămâna ta de până acum';

  @override
  String get reviewYearTitle => 'Anul acesta';

  @override
  String get reviewEmpty => 'Nimic încă scris';

  @override
  String get reviewEntries => 'Intrări';

  @override
  String get reviewDaysWritten => 'Zile scrise';

  @override
  String get reviewWords => 'Cuvinte';

  @override
  String get reviewPhotos => 'Fotografii';

  @override
  String get reviewLongestRun => 'Cel mai lung ciclu de zile';

  @override
  String get reviewAverageMood => 'Dispoziție medie';

  @override
  String get reviewFavorites => 'Cel mai adesea';

  @override
  String get reviewByMonth => 'Pe lună';

  @override
  String get reviewHighlight => 'Evidențiați';

  @override
  String get yearInPixels => 'Anul în pixeli';

  @override
  String get capsuleSeal => 'Sigilați ca o capsulă a timpului';

  @override
  String get capsuleTitle => 'Capsula timpului';

  @override
  String capsuleOpensOn(Object date) {
    return 'Se deschide pe $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Scris pe $date';
  }

  @override
  String get capsuleOpenEarly => 'Deschide devreme';

  @override
  String get capsuleOpenEarlyDescription =>
      'Capsula se deschide acum și rămâne deschisă.';

  @override
  String get capsuleOpened => 'Capsula timpului deschisă';

  @override
  String get templateMorningName => 'Pagini de dimineață';

  @override
  String get templateMorningDescription => 'Configurați ziua în trei minute';

  @override
  String get templateMorningText =>
      '## Trei lucruri pe care vreau să le fac bine astăzi\n1. \n2. \n3. \n\n## Ceva pe care îl aștept cu nerăbdare\n\n## O notă pentru mine\n';

  @override
  String get templateEveningName => 'Recenzie de seară';

  @override
  String get templateEveningDescription =>
      'Închideți ziua cu ceea ce a mers bine';

  @override
  String get templateEveningText =>
      '## Trei lucruri bune astăzi\n1. \n2. \n3. \n\n## Ce am învățat\n\n## Ce ar putea merge mai bine mâine\n';

  @override
  String get routineMorning => 'Bună dimineața';

  @override
  String get routineEvening => 'Recenzie de seară';

  @override
  String get settingsRoutinePrompts => 'Îndemnuri de dimineață și de seară';

  @override
  String get settingsRoutinePromptsHint =>
      'Sugerați șablonul de dimineață sau de seară în Povestiri';

  @override
  String get checkInTitle => 'Check-in rapid';

  @override
  String get checkInSubtitle => 'Dispoziție în două atingeri';

  @override
  String get checkInMood => 'Cum te simți?';

  @override
  String get checkInActivity => 'ce faci?';

  @override
  String get checkInNote => 'Un rând despre asta (opțional)';

  @override
  String get checkInSave => 'Salvați';

  @override
  String editorWordCount(int words, int characters) {
    return '$words cuvinte · $characters caractere';
  }

  @override
  String get coachProgramEverydayTagline =>
      'Observați lucrurile mici într-o zi.';

  @override
  String get coachProgramReflectTagline => 'Încetinește și ascultă-te pe tine.';

  @override
  String get coachDuration => 'Durata';

  @override
  String get coachInterval => 'Interval';

  @override
  String get coachDifficulty => 'Dificultate';

  @override
  String get coachIntervalDaily => 'Zilnic';

  @override
  String get coachIntervalWeekly => 'Săptămânal';

  @override
  String get coachDifficultyBeginner => 'începător';

  @override
  String get coachDifficultyIntermediate => 'Intermediar';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de zile',
      one: '$count zi',
      few: '$count zile',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de săptămâni',
      one: '$count saptamana',
      few: '$count săptămâni',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'Ziua $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Săptămâna $n';
  }

  @override
  String get coachEnroll => 'Înscrie-te';

  @override
  String get coachEndProgram => 'Încheiați programul';

  @override
  String get coachAuthor => 'autor';

  @override
  String get coachAuthorBio => 'Solicitări scrise pentru această aplicație.';

  @override
  String get coachEnrolledTip =>
      'Toate gata! Întrebările tale vor apărea în Stories.';

  @override
  String get coachGoToStories => 'Accesați Povești';

  @override
  String get coachAnswerHint => 'Scrie răspunsul tău...';

  @override
  String get storyWrapUp => 'Asta e tot pentru azi.';

  @override
  String get storyTapToClose => 'Atingeți pentru a închide';

  @override
  String get coachAnswerDone => 'Gata';

  @override
  String get coachAnswered => 'Răspuns, atingeți pentru a deschide';

  @override
  String get coachAnsweredEarlier => 'Răspuns';

  @override
  String get locationLocating => 'Se localizează…';

  @override
  String get locationPickPlace => 'Alege un loc';

  @override
  String get locationPlacesHint => 'Adresa sau numele locului';

  @override
  String get locationCustom => 'Loc personalizat';

  @override
  String get locationCurrent => 'Locația actuală';

  @override
  String get locationSaved => 'Locuri salvate';

  @override
  String get locationSearchResults => 'Rezultatele căutării';

  @override
  String get locationNearby => 'Locuri din apropiere';

  @override
  String get locationRename => 'Redenumiți';

  @override
  String get locationSavePlace => 'Salvați locul';

  @override
  String get locationUnsavePlace => 'Eliminați din locurile salvate';

  @override
  String get shareAs => 'Distribuie ca...';

  @override
  String get shareAsImage => 'Imagine';

  @override
  String get shareAsZip => 'ZIP cu suportul media original';

  @override
  String get shareAsPlainText => 'Text simplu';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Bun venit la AID Diary';

  @override
  String get onboardWelcomeText =>
      'Începeți de aici sau conectați acest dispozitiv la unul pe care îl utilizați deja.';

  @override
  String get onboardStart => 'Începeți să scrieți';

  @override
  String get helpFaq => 'Întrebări frecvente';

  @override
  String get helpFaq1Q => 'Unde este păstrat jurnalul meu?';

  @override
  String get helpFaq1A =>
      'Jurnalul dvs. este stocat pe acest dispozitiv. Acesta ajunge la alte dispozitive sau stocare numai atunci când activați sincronizarea, partajarea sau exportul. Sincronizarea este criptată de la capăt la capăt.';

  @override
  String get helpFaq2Q => 'Cum păstrez o copie sau trec pe un dispozitiv nou?';

  @override
  String get helpFaq2A =>
      'Conectați-vă la un dispozitiv existent în Setări → Date și stocare → Sincronizare și confirmați autorizarea pe dispozitivul care are jurnalul dvs. Ambele dispozitive rămân utilizabile. De asemenea, puteți crea o copie de rezervă și o puteți restaura pe alt dispozitiv.';

  @override
  String get helpFaq3Q =>
      'Pot introduce înregistrări din alte aplicații de jurnal?';

  @override
  String get helpFaq3A =>
      'Da: în Setări → Date și stocare, importați exporturi de la Daylio, Diarium, Diaro, DayBook, My Brain, OneShot și Pixels sau un export JSON.';

  @override
  String get helpFaq4Q => 'Cum funcționează programele de antrenor?';

  @override
  String get helpFaq4A =>
      'Înscrie-te într-un program pe pagina Antrenor. În fiecare zi sau săptămână o nouă întrebare așteaptă în Povestiri; răspunsul dvs. este salvat ca intrare.';

  @override
  String get helpFaq5Q => 'Ce se întâmplă dacă îmi uit parola?';

  @override
  String get helpFaq5A =>
      'Parola nu poate fi recuperată, așa că păstrați o copie de rezervă a jurnalului.';

  @override
  String get helpPrivacy => 'Confidențialitate';

  @override
  String get helpPrivacyText =>
      'Conținutul jurnalului și conținutul media rămân pe acest dispozitiv, cu excepția cazului în care activați sincronizarea criptată sau le partajați/exportați. Hărțile, căutarea locului și vremea folosesc serviciile configurate și trimit locația sau interogarea de căutare necesară pentru acea solicitare, nu textul jurnalului.';

  @override
  String get photoMetaTitle => 'Folosiți detaliile fotografiei?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Numărați această intrare pentru $date și setați-i locul la $place, așa cum este înregistrat în fotografie?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Numărați această intrare pentru $date, când a fost făcută fotografia?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Setați locul acestei intrări la $place, unde a fost făcută fotografia?';
  }

  @override
  String get photoMetaApply => 'Folosește-le';

  @override
  String get quickWriteTitle => 'Scrie rapid';

  @override
  String get quickWriteText => 'Atingeți pentru a începe o nouă intrare.';

  @override
  String get settingsQuickWriteTitle => 'Scrie rapid în notificări';

  @override
  String get settingsQuickWriteDescription =>
      'Păstrați o notificare care deschide o nouă intrare.';

  @override
  String get settingsNudgesTitle =>
      'Dă-mi un ghiont după o întindere liniștită';

  @override
  String settingsNudgesDescription(int days) {
    return 'Un memento blând când nu ați scris de zile $days.';
  }

  @override
  String get nudgeTitle => 'A trecut ceva timp';

  @override
  String get nudgeMonday => 'O nouă săptămână: ce aștepți cu nerăbdare?';

  @override
  String get nudgeTuesday => 'Două rânduri sunt suficiente. Cum te simți azi?';

  @override
  String get nudgeWednesday =>
      'La jumătatea săptămânii. Ce s-a remarcat până acum?';

  @override
  String get nudgeThursday => 'Ceva mic care merită păstrat de astăzi?';

  @override
  String get nudgeFriday => 'Săptămâna se încheie. Rețineți un moment bun.';

  @override
  String get nudgeSaturday => 'O sâmbătă lentă este o zi bună pentru a scrie.';

  @override
  String get nudgeSunday =>
      'Priviți înapoi la săptămâna înainte de a se termina.';

  @override
  String get photoWidgetEmpty =>
      'Fotografiile pe care le adăugați la intrări apar aici.';

  @override
  String get channelReminders => 'Mementouri';

  @override
  String get channelOnThisDay => 'În această zi';

  @override
  String get channelCoach => 'Antrenorul solicită';

  @override
  String get channelNudges => 'Înghionturi după zile liniștite';

  @override
  String get channelQuickWrite => 'Scrie rapid';

  @override
  String get channelBackup => 'Backup-uri';

  @override
  String get formatJsonExport => 'JSON (export AID Diary)';

  @override
  String get aboutModifiedNotice =>
      'O versiune modificată a Daily You de către Demizo și colaboratori. Nu este aplicația oficială Daily You.';

  @override
  String get toolbarPhotos => 'Adăugați fotografii';

  @override
  String get toolbarMedia => 'Fotografii și videoclipuri';

  @override
  String get mediaFromGallery => 'Alegeți din galerie';

  @override
  String get mediaFromFiles => 'Alegeți dintre fișiere';

  @override
  String get editorLeaveTitle => 'Salvați această intrare?';

  @override
  String get editorLeaveDiscard => 'Nu salva';

  @override
  String get editorTitleHint => 'Titlu';

  @override
  String get editorLocating => 'Se localizează…';

  @override
  String get toolbarVideo => 'Video';

  @override
  String get toolbarAudio => 'Notă vocală';

  @override
  String get toolbarTags => 'Etichete';

  @override
  String get toolbarBulletList => 'Lista cu marcatori';

  @override
  String get toolbarHeading => 'Titlu';

  @override
  String get toolbarBold => 'Îndrăzneț';

  @override
  String get toolbarItalic => 'cursiv';

  @override
  String get toolbarHighlight => 'Evidențiați';

  @override
  String get toolbarStrikethrough => 'Striat';

  @override
  String get toolbarQuote => 'citat';

  @override
  String get toolbarLink => 'Link';

  @override
  String get toolbarInsert => 'Inserați';

  @override
  String get toolbarUndo => 'Anulați';

  @override
  String get toolbarRedo => 'Reface';

  @override
  String get toolbarInsertDate => 'Introduceți data';

  @override
  String get toolbarInsertTime => 'Introduceți ora';

  @override
  String get settingsSyncTitle => 'Sincronizare în cloud';

  @override
  String get syncOffDescription =>
      'Păstrați același jurnal pe toate dispozitivele dvs. prin Google Drive sau un server WebDAV, cum ar fi Nextcloud, Synology sau Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'Sincronizați cu Google Drive';

  @override
  String get syncOrWebDav => 'Sau un server WebDAV';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn => 'Conectat. Puteți reveni la AID Diary.';

  @override
  String get syncGoogleSignInAgain =>
      'Google are nevoie să vă conectați din nou.';

  @override
  String get syncSignInAgain => 'Conectați-vă din nou';

  @override
  String get settingsCommandLineTitle => 'Linia de comandă';

  @override
  String get commandLineToggle => 'Interfață de linie de comandă';

  @override
  String get commandLineToggleHint =>
      'Permite comanda de ajutor și alte programe de pe acest dispozitiv să utilizeze comenzile aplicației.';

  @override
  String get commandLineAlwaysOn => 'Întotdeauna în curs de dezvoltare.';

  @override
  String commandLineListening(int port) {
    return 'Ascultare pe portul $port';
  }

  @override
  String get commandPaletteTitle => 'Toate comenzile';

  @override
  String get commandPaletteSearch => 'Comenzi de căutare';

  @override
  String get commandPaletteRun => 'Fugi';

  @override
  String get commandPaletteConfirm =>
      'Acest lucru nu poate fi anulat pur și simplu. Rulează-l?';

  @override
  String syncReceiving(int done, int total) {
    return 'Se primește $done din $total...';
  }

  @override
  String syncSending(int done, int total) {
    return 'Se trimite $done de $total...';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'Accesul la Google Drive nu a fost permis. Conectați-vă din nou și bifați Google Drive pe pagina Google.';

  @override
  String get syncEntryUnsynced =>
      'Nesincronizat: ultima sincronizare nu a fost finalizată';

  @override
  String get syncUseOfficial => 'Utilizați serverul de sincronizare AID';

  @override
  String get syncServer => 'Adresa serverului';

  @override
  String get syncUsername => 'Nume de utilizator';

  @override
  String get syncPassword => 'Parolă';

  @override
  String get syncConnect => 'Conectați-vă';

  @override
  String get syncConnecting => 'Se conectează…';

  @override
  String get syncSignInFailed =>
      'Nu s-a putut conecta. Verificați adresa, numele de utilizator și parola.';

  @override
  String syncConnectFailed(String error) {
    return 'Nu s-a putut conecta: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Începeți sincronizarea';

  @override
  String get syncNewSpaceDescription =>
      'Nu există încă un jurnal sincronizat aici. Acest jurnal va fi încărcat, criptat de la capăt la capăt cu o cheie care rămâne pe dispozitivele dvs.';

  @override
  String get syncJoinTitle => 'Alăturați-vă jurnalului sincronizat';

  @override
  String get syncWrongKey =>
      'Acest cod de recuperare nu deschide jurnalul sincronizat.';

  @override
  String syncLastSynced(String time) {
    return 'Ultima sincronizare $time';
  }

  @override
  String get syncNever => 'Nu s-a sincronizat încă';

  @override
  String get syncSyncing => 'Se sincronizează…';

  @override
  String syncFailed(String error) {
    return 'Ultima sincronizare a eșuat: $error';
  }

  @override
  String get syncLocked =>
      'Jurnalul sincronizat aparține acum altor dispozitive sau a fost reluat. Asociați-vă cu unul dintre ele sau utilizați codul de recuperare pentru a continua sincronizarea.';

  @override
  String get syncNow => 'Sincronizează acum';

  @override
  String get syncUnlock => 'Deblocați';

  @override
  String get syncEncrypted => 'Criptat de la capăt la capăt';

  @override
  String get syncDisconnect => 'Opriți sincronizarea';

  @override
  String get syncDisconnectDescription =>
      'Acest dispozitiv se oprește sincronizarea. Jurnalul de aici și copia sincronizată rămân așa cum sunt.';

  @override
  String get syncOwnRecoveryPassword =>
      'Folosește propria mea parolă de recuperare';

  @override
  String get syncRecoveryPassword => 'Parola de recuperare';

  @override
  String get syncRecoveryPasswordRepeat => 'Repetați parola de recuperare';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Utilizați cel puțin caractere $min';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'Parolele diferă';

  @override
  String get syncRecoveryCode => 'Cod de recuperare';

  @override
  String get syncRecoveryCodeTitle => 'Salvați codul de recuperare';

  @override
  String get syncRecoveryCodeDescription =>
      'Dacă fiecare dispozitiv al dvs. este pierdut, acest cod vă restabilește jurnalul sincronizat. Păstrați-l într-un manager de parole sau pe hârtie. Se afișează o singură dată.';

  @override
  String get syncRecoveryCodeCopied => 'Codul de recuperare a fost copiat';

  @override
  String get syncRecoveryCodeSaved => 'L-am salvat';

  @override
  String get syncJoinNeedsKey =>
      'Acest jurnal sincronizat aparține celorlalte dispozitive ale dvs. Asociați-vă cu unul dintre ele sau utilizați codul de recuperare. Înregistrările de pe acest dispozitiv vor fi adăugate acestuia.';

  @override
  String get syncPairDevice => 'Asociați cu un dispozitiv';

  @override
  String get syncUseRecoveryCode => 'Utilizați codul de recuperare';

  @override
  String get syncAddDevice => 'Adăugați un dispozitiv';

  @override
  String get syncChangeRecoveryCode => 'Schimbați codul de recuperare';

  @override
  String get syncChangeRecoveryDescription =>
      'Un nou cod îl înlocuiește pe cel actual, care nu mai funcționează. Datele dvs. și alte dispozitive rămân așa cum sunt.';

  @override
  String get syncNewRandomCode => 'Cod nou aleatoriu';

  @override
  String get syncRecoveryCodeChanged => 'Codul de recuperare a fost modificat';

  @override
  String get syncResetSpace => 'Reîncepeți jurnalul sincronizat';

  @override
  String get syncResetSpaceDescription =>
      'Numai când niciun dispozitiv și niciun cod de recuperare nu îl mai deschide: copia sincronizată este înlocuită cu jurnalul de pe acest dispozitiv, sub cheile acestui dispozitiv. Celelalte dispozitive ale dvs. apoi se asociază din nou.';

  @override
  String get syncPairTitle => 'Asociați dispozitivele';

  @override
  String get syncPairShow => 'Afișează un cod';

  @override
  String get syncPairEnter => 'Introduceți un cod';

  @override
  String get syncPairShowHint =>
      'Pe celălalt dispozitiv, deschideți Asociere dispozitive, alegeți Introduceți un cod și tastați sau scanați-l.';

  @override
  String get syncPairEnterHint =>
      'Introdu codul pe care îl arată celălalt dispozitiv sau scanează-l.';

  @override
  String get syncPairCode => 'Cod de împerechere';

  @override
  String get syncPairScan => 'Scanează';

  @override
  String get syncPairStart => 'Pereche';

  @override
  String get syncPairWaiting => 'În așteptarea celuilalt dispozitiv...';

  @override
  String syncPairDone(String device) {
    return 'Asociat cu $device';
  }

  @override
  String get syncPairWrongCode =>
      'Codul nu se potrivea. Afișați un cod nou și încercați din nou.';

  @override
  String get syncPairNoOffer =>
      'Niciun dispozitiv nu afișează acest cod. Este posibil să fi expirat.';

  @override
  String get syncPairTimedOut => 'Celălalt dispozitiv nu a răspuns la timp.';

  @override
  String get syncPairNeither =>
      'Niciun dispozitiv nu este încă configurat cu acest jurnal sincronizat.';

  @override
  String get syncPairBoth =>
      'Ambele dispozitive deschid deja acest jurnal sincronizat.';

  @override
  String syncPairFailed(String error) {
    return 'Asocierea eșuată: $error';
  }

  @override
  String get syncMediaPending =>
      'Agenda sincronizată · unele media sunt încă transferate';

  @override
  String get syncWaitingForDevices =>
      'Jurnalul sincronizat · se așteaptă ca un alt dispozitiv să transfere media';

  @override
  String get syncCacheNotice =>
      'Media cloud este temporară. Păstrați originalele pe dispozitivele dvs.; sincronizarea nu este o copie de rezervă.';

  @override
  String get paperTitle => 'Hârtie de scrisori';

  @override
  String get paperPlain => 'simplu';

  @override
  String get paperLined => 'Căptușită';

  @override
  String get paperGrid => 'Grilă';

  @override
  String get paperTinted => 'Nuanțat';

  @override
  String get paperDecorationTitle => 'Decoratiuni';

  @override
  String get paperDecorationNone => 'Niciuna';

  @override
  String get paperDecorationBotanical => 'frunze';

  @override
  String get paperDecorationStars => 'Stele';

  @override
  String get paperDecorationWashi => 'Banda Washi';

  @override
  String get themeDarkChoice => 'Aspect întunecat';

  @override
  String get themeDarkSame => 'Urmăriți paleta luminoasă';

  @override
  String get themeDarkCustom => 'Paletă separată';

  @override
  String get themeDarkAccent => 'Culoare de accent închisă';

  @override
  String get themeColorTeal => 'Teal';

  @override
  String get themeColorCyan => 'Cyan';

  @override
  String get themeColorIndigo => 'Indigo';

  @override
  String get themeColorCoral => 'Coral';

  @override
  String get themeColorOlive => 'măsline';

  @override
  String get themeColorSlate => 'Ardezie';

  @override
  String get drawingTitle => 'Desen';

  @override
  String get drawingPen => 'Pix';

  @override
  String get drawingEraser => 'Radieră';

  @override
  String get drawingUndo => 'Anulați';

  @override
  String get drawingClear => 'Clar';

  @override
  String get drawingWidth => 'Lățimea stiloului';

  @override
  String get drawingStylusOnly => 'Doar stylus';

  @override
  String get drawingDiscardTitle => 'Renunțați la desen?';

  @override
  String get drawingDiscardBody => 'Acest desen nu a fost salvat.';

  @override
  String get drawingSaveError => 'Nu s-a putut salva desenul.';

  @override
  String get syncNetworkTitle => 'Diagnosticarea rețelei';

  @override
  String get syncNetworkRefresh => 'Reîmprospătați';

  @override
  String get syncNetworkSelectedRoute => 'Calea curentă';

  @override
  String get syncNetworkAvailableRoutes => 'Căi disponibile';

  @override
  String get syncNetworkSignaling => 'Conexiune la directorul dispozitivului';

  @override
  String get syncNetworkRelayRemaining => 'Alocația de releu rămasă';

  @override
  String get syncNetworkIcePair => 'Candidați pentru conexiune directă';

  @override
  String get syncNetworkPeerTrusted => 'Dispozitiv autentificat';

  @override
  String get syncNetworkNoRoute => 'În așteptarea unei conexiuni';

  @override
  String get syncNetworkUnavailable => 'Diagnosticele nu sunt disponibile';

  @override
  String get syncMediaCopiesTitle => 'Livrare media și copii';

  @override
  String get syncMediaPendingCount => 'În așteptarea transferului';

  @override
  String get syncMediaDurableCount => 'Livrat la depozitul personal';

  @override
  String get syncMediaTemporaryCount => 'Copii temporare sau neconfirmate';

  @override
  String get syncMediaReceiptExplanation =>
      'Aceste numărări descriu livrările finalizate, nu un nou audit al backup-urilor supraviețuitoare.';

  @override
  String get syncMediaCacheExplanation =>
      'Media cloud temporară poate expira. Păstrați originalele sau o copie de rezervă separată.';

  @override
  String get momentsTitle => 'Momente foto';

  @override
  String get momentsHint =>
      'Găsiți grupuri folosind orele locale ale fotografiilor și coordonatele opționale. Fotografiile sunt atașate numai atunci când alegeți un card.';

  @override
  String get momentsScan => 'Găsiți momente';

  @override
  String get momentsChooseFolder => 'Alegeți folderul cu fotografii';

  @override
  String get momentsLocation => 'Includeți locațiile fotografiilor';

  @override
  String get momentsEmpty => 'Nu există grupuri foto recente.';

  @override
  String get momentsCreate => 'Scrieți despre aceste fotografii';

  @override
  String get momentsDismiss => 'Respingeți';

  @override
  String get momentsError => 'Nu s-au putut citi fotografiile locale.';

  @override
  String get momentsCreated => 'Intrarea foto a fost creată.';

  @override
  String get momentsPermission =>
      'Permiteți accesul la fotografii pentru a găsi sugestii locale.';

  @override
  String get momentsScope =>
      'Numai fotografii recente; cel mult 500 de fotografii și 20 de fotografii pe card.';

  @override
  String momentsPhotoCount(int count) {
    return 'fotografii $count';
  }

  @override
  String get nearbyTitle => 'Conectați dispozitive';

  @override
  String get nearbySend => 'Autorizați un alt dispozitiv';

  @override
  String get nearbyReceive => 'Conectați-vă la un dispozitiv existent';

  @override
  String get nearbyInstructions =>
      'Conectați ambele dispozitive la același Wi-Fi sau la hotspot-ul celuilalt. Confirmați autorizarea pe dispozitivul existent; ambele dispozitive rămân utilizabile. Nu este nevoie de internet.';

  @override
  String get nearbyCompare =>
      'Comparați acest cod pe ambele dispozitive înainte de aprobare.';

  @override
  String get nearbyConfirm => 'Codurile se potrivesc';

  @override
  String get nearbyScan => 'Scanați codul celuilalt dispozitiv';

  @override
  String get nearbyPaste => 'Lipiți invitația';

  @override
  String get nearbyWaiting => 'Se așteaptă aprobarea pe celălalt dispozitiv';

  @override
  String get nearbyWorking =>
      'Se autorizează și se sincronizează jurnalul și atașamentele...';

  @override
  String get nearbyPending =>
      'Unele atașamente mai necesită sincronizare. Păstrați celălalt dispozitiv online și încercați din nou.';

  @override
  String get nearbyComplete =>
      'Dispozitiv conectat; jurnal și atașamente sincronizate';

  @override
  String get nearbyFailed =>
      'Conexiunea nu s-a terminat. Verificați conexiunea locală și încercați din nou.';

  @override
  String get nearbyEmptyRequired =>
      'Utilizați un dispozitiv cu un jurnal gol care nu este încă conectat la sincronizare.';

  @override
  String get nearbyRetry => 'Continuați sincronizarea';

  @override
  String get nearbyWifi => 'Setări Wi-Fi';

  @override
  String get nearbyHotspot => 'Setări hotspot';

  @override
  String get nearbyKeepOpen =>
      'Păstrați această pagină deschisă până când se termină noul dispozitiv. Invitația expiră după două minute.';

  @override
  String get syncDevicesTitle => 'Dispozitive autorizate';

  @override
  String get syncDevicesDescription =>
      'Numai dispozitivele aprobate pot accesa acest cont AID. Revocarea unui dispozitiv blochează serverul, dar nu poate șterge o cheie principală sau un jurnal deja copiat pe acesta.';

  @override
  String get syncDeviceRequest =>
      'Afișați acest QR de autorizare pe un dispozitiv aprobat';

  @override
  String get syncDeviceAuthorize => 'Autorizați un dispozitiv';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Scanați sau inserați cererea de autorizare a noului dispozitiv.';

  @override
  String get syncDeviceRevoke => 'Revocați';

  @override
  String get syncDeviceRotate => 'Rotiți cheia de semnare a acestui dispozitiv';

  @override
  String get syncDeviceCheck => 'Verificați autorizația';

  @override
  String get syncDeviceHardware => 'Cheie de semnare susținută de hardware';

  @override
  String get syncDeviceSoftware => 'Cheie de semnare software neexportabilă';

  @override
  String get syncDeviceUnavailable =>
      'Autorizarea dispozitivului nu este disponibilă. Aprobați acest dispozitiv de pe alt dispozitiv autorizat și încercați din nou.';

  @override
  String get syncDeviceRevoked => 'Revocat';

  @override
  String get syncDeviceLocal => 'Acest dispozitiv';

  @override
  String get cloudTrafficTitle =>
      'Cotă lunară de transfer de date în cloud pentru fișierele media';

  @override
  String get cloudTrafficLimit => 'Cotă lunară de transfer de date';

  @override
  String get cloudTrafficUsed => 'Transfer de date utilizat';

  @override
  String get cloudTrafficRemaining => 'Transfer de date rămase';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'Cota de transfer de date resetează $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'Cota de transfer de date în cloud pentru fișierele media a fost epuizată. Fișierele media lipsă se vor sincroniza automat atunci când este disponibilă o conexiune directă sau cota se resetează.';

  @override
  String get cloudTrafficExplanation =>
      'Memorarea în cache a fișierelor media și transmisia live partajează această cotă de transfer de date. Conexiunile directe nu o consumă. Textul din jurnal și mesajele de control al conexiunii au limite zilnice mici separate.';

  @override
  String get appearanceThemeSection => 'Tema aplicației';

  @override
  String get appearancePaperSection => 'Hârtie de jurnal';

  @override
  String get appearanceTypographySection => 'Text de jurnal';

  @override
  String get appearancePreferencesSection => 'Preferințe generale';

  @override
  String get themeSystemAccentHint =>
      'Folosește paleta de sistem în loc de culori personalizate. Dezactivează-l pentru a-ți alege pe al tău.';

  @override
  String get syncDeviceNameSaveFailed =>
      'Nu s-a putut salva numele dispozitivului. Vă rugăm să încercați din nou.';

  @override
  String get nearbyConnectionHelp => 'Ajutor pentru conectare';

  @override
  String get syncAllSynced => 'Totul sincronizat';

  @override
  String get syncDetailsTitle => 'Detalii de sincronizare';

  @override
  String get syncMore => 'Mai multe opțiuni';

  @override
  String get syncDeviceName => 'Numele dispozitivului';

  @override
  String get syncDeviceNameHint => 'De exemplu: Tableta mea';

  @override
  String get syncDeviceNameInvalid => 'Utilizați 1 până la 32 de caractere';

  @override
  String get syncDeviceKeyDetails => 'Detalii de securitate';

  @override
  String get syncConnectionProblem =>
      'Nu se poate sincroniza deocamdată. Se reîncercă automat.';

  @override
  String get syncCopyComplete =>
      'Copie completă a jurnalului și a fișierelor media';

  @override
  String get syncCopyPartial => 'Unele mass-media încă lipsesc';

  @override
  String get syncCopyOlder => 'Noi modificări așteaptă să fie sincronizate';

  @override
  String get syncCopyUnavailable =>
      'Detaliile de copiere nu sunt disponibile. Încercați din nou mai târziu.';

  @override
  String get syncCopyLastKnown =>
      'Alte dispozitive afișează ultima copie confirmată. Dispozitivele offline nu pot fi verificate acum.';

  @override
  String get syncCopyTemporary =>
      'Cache temporară. Păstrați originalele pe dispozitivele dvs.';

  @override
  String get syncCopyStorage =>
      'Stocarea dvs. de sincronizare. Încărcările media finalizate sunt listate în diagnosticare.';

  @override
  String syncCopyChecked(String time) {
    return 'Ultima confirmare $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Transfer de date rămas în această lună: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Începeți de aici';

  @override
  String get onboardConnect => 'Conectați-vă la un dispozitiv existent';

  @override
  String get onboardFailed =>
      'Configurarea nu a putut fi finalizată. Jurnalul tău este în siguranță; vă rugăm să încercați din nou.';

  @override
  String get tutorialTitle => 'Cum se folosește jurnalul';

  @override
  String get tutorialWriteTitle => 'Scrieți prima intrare în jurnal';

  @override
  String get tutorialWriteText =>
      'Atingeți + pentru a scrie o înregistrare în jurnal. Adăugați un titlu opțional, alegeți data jurnalului și atingeți bifa pentru a salva. Puteți edita din nou înregistrarea din jurnal în orice moment.';

  @override
  String get tutorialMediaTitle =>
      'Adăugați fotografii, audio sau scris de mână';

  @override
  String get tutorialMediaText =>
      'Folosiți + în editorul de jurnal pentru a atașa fotografii, videoclipuri sau o înregistrare vocală sau pentru a deschide pânza scrisă de mână. Aceste atașamente sunt salvate împreună cu înregistrarea din jurnal.';

  @override
  String get tutorialReviewTitle => 'Găsiți din nou o zi';

  @override
  String get tutorialReviewText =>
      'Răsfoiți jurnalul sau calendarul dvs., căutați scrisul și organizați intrările cu etichete. Paginile Media și Atlas vă permit să găsiți intrări anterioare după fotografie sau locație.';

  @override
  String get tutorialSyncTitle => 'Utilizați mai mult de un dispozitiv';

  @override
  String get tutorialSyncText =>
      'În Setări → Date și stocare → Sincronizare, conectați-vă la un dispozitiv existent și confirmați autorizarea pe acel dispozitiv. Ambele dispozitive pot continua să folosească jurnalul. Textul jurnalului se sincronizează mai întâi. Fișierele media se sincronizează în continuare când conexiunea la rețea și cota de transfer de date rămasă o permit.';

  @override
  String get tutorialPrivacyTitle => 'Păstrează-ți jurnalul în siguranță';

  @override
  String get tutorialPrivacyText =>
      'Înregistrările din jurnal rămân pe acest dispozitiv, cu excepția cazului în care le activați sincronizarea, le distribuiți sau le exportați. Sincronizarea este criptată de la capăt la capăt. În Setări, puteți, de asemenea, să setați o parolă pentru aplicație, să creați copii de rezervă și să redeschideți acest tutorial.';

  @override
  String get editorDiaryDay => 'Ziua însemnării';

  @override
  String get editorDiaryDayPicker =>
      'Ziua însemnării · Cărei zile îi aparține această însemnare?';

  @override
  String editorCreatedAt(String time) {
    return 'Creată $time';
  }

  @override
  String get editorDiaryDayHint =>
      'Ziua căreia îi aparține această însemnare. Modificarea ei nu schimbă data sau ora creării.';

  @override
  String get hiddenDiaryTitle => 'Însemnări ascunse';

  @override
  String get hiddenDiaryHide => 'Ascunde însemnarea';

  @override
  String get hiddenDiaryShow => 'Afișează însemnarea';

  @override
  String get hiddenDiaryEmpty => 'Nicio însemnare ascunsă';

  @override
  String get hiddenDiaryUnlock => 'Deblochează însemnările ascunse';

  @override
  String get hiddenDiaryAuthHint =>
      'Folosește blocarea aplicației sau a ecranului dispozitivului.';

  @override
  String get moodClear => 'Șterge dispoziția';

  @override
  String get scrollToTop => 'Sus';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackHint => 'Descrieți o problemă sau sugestie';

  @override
  String get feedbackGithub => 'Problemă GitHub';

  @override
  String get feedbackEmail => 'Trimite e-mail';

  @override
  String get feedbackCopy => 'Copiază textul';

  @override
  String get feedbackLaunchFailed =>
      'Aplicația nu s-a deschis. Copiați textul și folosiți e-mailul de mai jos.';

  @override
  String get feedbackCopied => 'Feedback copiat';
}
