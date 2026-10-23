// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => 'Kolor motywu';

  @override
  String get themeColorHint => 'Wybierz kolor dla tej palety.';

  @override
  String get themeColorBlue => 'Błękit nieba';

  @override
  String get themeColorGreen => 'Leśna zieleń';

  @override
  String get themeColorBrown => 'Ciepła kawa';

  @override
  String get themeColorPurple => 'Lawenda';

  @override
  String get themeColorRose => 'Zakurzona róża';

  @override
  String get themeColorAmber => 'Bursztyn';

  @override
  String get themeColorPreview => 'Trochę każdego dnia';

  @override
  String get themeTintBackgroundTitle => 'Odcień tła kolorem motywu';

  @override
  String get themeTintBackgroundHint =>
      'Wyłącz dla neutralnego szarego tła; przyciski zachowują wybrany kolor.';

  @override
  String get dailyReminderTitle => 'Wpisz się!';

  @override
  String get dailyReminderDescription => 'Zrób dzisiejszy wpis…';

  @override
  String get actionTakePhoto => 'Zrób zdjęcie';

  @override
  String get flashbacksTitle => 'Wspomnienia';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Wyklucz złe dni';

  @override
  String get flashbackGoodDay => 'Dobry dzień';

  @override
  String get flashbackRandomDay => 'Losowy dzień';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tygodnie temu',
      one: '$count Tydzień temu',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Miesiące Temu',
      one: '$count Miesiąc Temu',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Lata Temu',
      one: '$count Rok Temu',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'Tego dnia';

  @override
  String get searchLogsHint => 'Szukaj wpisu…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wpisy',
      one: '$count wpis',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dni',
      one: '$count dzień',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count słowa',
      one: '$count słowo',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Brak wpisu…';

  @override
  String get noResults => 'Brak wyników…';

  @override
  String get sortOrderAscendingTitle => 'Rosnąco';

  @override
  String get sortOrderDescendingTitle => 'Malejąco';

  @override
  String get pageStatisticsTitle => 'Statystyki';

  @override
  String get statisticsNotEnoughData => 'Zbyt mało danych…';

  @override
  String get statisticsRangeOneMonth => '1 miesiąc';

  @override
  String get statisticsRangeSixMonths => '6 miesięcy';

  @override
  String get statisticsRangeOneYear => '1 rok';

  @override
  String get statisticsRangeAllTime => 'Cały okres';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag - Podsumowanie';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag Z biegiem czasu';
  }

  @override
  String get chartGroupingLabel => 'Grupuj według';

  @override
  String get chartGroupingDay => 'Dni';

  @override
  String get chartGroupingWeek => 'Tygodni';

  @override
  String get chartGroupingMonth => 'Miesięcy';

  @override
  String get chartGroupingYear => 'Lat';

  @override
  String get chartSmoothingLabel => 'Wygładzanie';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aktualna passa $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Najdłuższa passa $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wspaniałe dni $count',
      one: 'Wspaniałe dni $count',
      many: 'Wspaniałe dni $count',
      few: 'Wspaniałe dni $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dni od złego dnia$count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Nie można uzyskać dostępu do pamięci zewnętrznej';

  @override
  String get errorExternalStorageAccessDescription =>
      'Jeśli używasz pamięci sieciowej, upewnij się czy usługa jest online i czy masz połączenie z internetem.\n\nW innym wypadku aplikacja mogła stracić uprawnienia do zewnętrznego folderu. Idź do ustawień i ponownie wybierz zewnętrzny folder by uzyskać uprawnienia.\n\nUwaga, zmiany nie zostaną zsynchronizowane dopóki nie przywrócisz dostępu do lokalizacji pamięci zewnętrznej!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Kontynuuj z lokalną bazą danych';

  @override
  String get lastModified => 'Zmodyfikowane';

  @override
  String get writeSomethingHint => 'Napisz coś…';

  @override
  String get titleHint => 'Tytuł…';

  @override
  String get deleteLogTitle => 'Usuń wpis';

  @override
  String get deleteLogDescription => 'Czy chcesz usunąć ten wpis?';

  @override
  String get deletePhotoTitle => 'Usuń zdjęcie';

  @override
  String get deletePhotoDescription => 'Czy chcesz usunąć to zdjęcie?';

  @override
  String get pageSettingsTitle => 'Ustawienia';

  @override
  String get settingsTheme => 'Motyw';

  @override
  String get themeSystem => 'Systemowy';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Pierwszy dzień tygodnia';

  @override
  String get settingsCalendarSystem => 'Typ kalendarza';

  @override
  String get calendarSystemGregorian => 'Gregoriański';

  @override
  String get calendarSystemJalali => 'Jalali';

  @override
  String get settingsUseSystemAccentColor => 'Użyj systemowego koloru akcentu';

  @override
  String get settingsCustomAccentColor => 'Własny kolor akcentu';

  @override
  String get settingsShowFlashbacks => 'Pokaż wspomnienia';

  @override
  String get settingsChangeMoodIcons => 'Zmień ikony nastroju';

  @override
  String get moodIconPrompt => 'Wprowadź ikonę';

  @override
  String get settingsHideImages => 'Ukryj zdjęcia';

  @override
  String get pageCalendarTitle => 'Kalendarz';

  @override
  String get settingsNotificationsTitle => 'Powiadomienia';

  @override
  String get settingsDailyReminderTitle => 'Codzienne przypomnienie';

  @override
  String get settingsOnThisDayDescription =>
      'Przeglądaj poprzednie wspomnienia';

  @override
  String get settingsDailyReminderDescription =>
      'Subtelne przypomnienie każdego dnia';

  @override
  String get settingsReminderTime => 'Czas przypomnienia';

  @override
  String get settingsFixedReminderTimeTitle => 'Stały czas przypomnienia';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Ustaw niezmienny czas przypomnienia';

  @override
  String get settingsAlwaysSendReminderTitle => 'Zawsze wysyłaj powiadomienie';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Wyślij powiadomienie nawet jeśli wpis został rozpoczęty';

  @override
  String get settingsCustomizeNotificationTitle => 'Modyfikuj powiadomienia';

  @override
  String get settingsTemplatesTitle => 'Szablony';

  @override
  String get manageTemplates => 'Zarządzaj szblonami';

  @override
  String get noTemplateTitle => 'Brak';

  @override
  String get noTemplatesDescription => 'Brak utworzonych szablonów…';

  @override
  String get templateDefaultTimestampTitle => 'Znacznik czasu';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Podsumowanie dnia';

  @override
  String get templateDefaultSummaryBody =>
      '### Podsumowanie\n- \n\n### Cytat\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Refleksja';

  @override
  String get templateDefaultReflectionBody =>
      '### Co ci się dzisiaj podobało?\n- \n\n### Za co jesteś wdzięczny?\n- \n\n### Na co nie możesz się doczekać?\n- ';

  @override
  String get settingsTagsTitle => 'Tagi';

  @override
  String get manageTags => 'Zarządzaj tagami';

  @override
  String get tagTypeLabelTitle => 'Etykieta';

  @override
  String get tagTypeTrackerTitle => 'Śledzenie';

  @override
  String get nameHint => 'Imię';

  @override
  String get tagColorLabel => 'Kolor';

  @override
  String get iconPickerTitle => 'Wybierz ikonę';

  @override
  String get iconPickerIconsTab => 'Ikony';

  @override
  String get iconPickerCustomTab => 'Niestandardowe';

  @override
  String get iconPickerSearchHint => 'Wyszukaj ikony…';

  @override
  String get colorPickerTitle => 'Wybierz Kolor';

  @override
  String get colorPickerPaletteTab => 'Kolory';

  @override
  String get iconGroupMoodPeople => 'Nastrój i ludzie';

  @override
  String get iconGroupHealth => 'Zdrowie';

  @override
  String get iconGroupWorkFinance => 'Praca i finanse';

  @override
  String get iconGroupHabitsGoals => 'Nawyki i cele';

  @override
  String get iconGroupNature => 'Natura';

  @override
  String get iconGroupFoodDrink => 'Jedzenie i napoje';

  @override
  String get iconGroupHome => 'Dom';

  @override
  String get iconGroupTravel => 'Podróż';

  @override
  String get iconGroupSymbols => 'Symbole';

  @override
  String get tagCategoryLabel => 'Kategoria';

  @override
  String get tagLabel => 'Oznacz';

  @override
  String get tagCategoryUncategorized => 'Bez kategorii';

  @override
  String get newCategoryTitle => 'Nowa kategoria';

  @override
  String get shareButtonLabel => 'Udostępnij';

  @override
  String get importErrorDescription => 'Nie udało się zaimportować pliku!';

  @override
  String get exportErrorDescription => 'Nie udało się wyeksportować pliku!';

  @override
  String get deleteTitle => 'Usuń';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Jest używany w $count wpisach do dziennika.',
      one: ' Jest używany w $count wpisie do dziennika.',
      many: ' Jest używany w $count wpisach do dziennika.',
      few: ' Jest ono użyte w $count wpisach do pamiętnika.',
      zero: '',
    );
    return 'Usunąć „$name”?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Jego znaczniki $count również zostaną usunięte.',
      one: ' Jego $count tag również zostanie usunięty.',
      many: ' Jego tagi $count również zostaną usunięte.',
      few: ' Jego $count tagi również zostaną usunięte.',
      zero: '',
    );
    return 'Usunąć „$name”?$_temp0';
  }

  @override
  String get tagNameExists => 'Istnieje już tag o tej nazwie';

  @override
  String get categoryNameExists => 'Istnieje już kategoria o tej nazwie';

  @override
  String deleteTemplateMessage(Object name) {
    return 'Usunąć „$name”?';
  }

  @override
  String get addTagsTitle => 'Dodaj tagi';

  @override
  String get addTagsSearchHint => 'Wyszukaj tagi…';

  @override
  String get tagPickerSortManualLabel => 'Zamówienie ręczne';

  @override
  String get tagPickerSortUsageLabel => 'Sortuj według użycia';

  @override
  String get tagFavoriteName => 'Ulubiony';

  @override
  String get tagEnergyName => 'Energia';

  @override
  String get tagCategoryActivitiesName => 'Działania';

  @override
  String get tagExerciseName => 'Ćwicz';

  @override
  String get tagSocializingName => 'Towarzyskie';

  @override
  String get tagHobbyName => 'Hobby';

  @override
  String get tagEntertainmentName => 'Rozrywka';

  @override
  String get tagDiningName => 'Wyżywienie';

  @override
  String get tagChoresName => 'Obowiązki';

  @override
  String get tagCategoryEmotionsName => 'Emocje';

  @override
  String get tagExcitedName => 'Podekscytowany';

  @override
  String get tagGratefulName => 'Wdzięczny';

  @override
  String get tagCalmName => 'Spokojny';

  @override
  String get tagTiredName => 'Zmęczony';

  @override
  String get tagAnxiousName => 'Niespokojny';

  @override
  String get tagAnnoyedName => 'Zirytowany';

  @override
  String get settingsStorageTitle => 'Pamięć';

  @override
  String get settingsImageQuality => 'Jakość obrazów';

  @override
  String get imageQualityHigh => 'Wysoka';

  @override
  String get imageQualityMedium => 'Średnia';

  @override
  String get imageQualityLow => 'Niska';

  @override
  String get imageQualityNoCompression => 'Brak kompresji';

  @override
  String get settingsLogFolder => 'Folder wpisów';

  @override
  String get settingsImageFolder => 'Folder obrazów';

  @override
  String get warningTitle => 'Ostrzeżenie';

  @override
  String get logFolderWarningDescription =>
      'Jeśli wybrany folder zawiera już plik \'aid_diary.db\', zostanie on użyty do nadpisania twoich wpisów!';

  @override
  String get errorTitle => 'Błąd';

  @override
  String get logFolderErrorDescription =>
      'Nie udało się zmienić folderu wpisów!';

  @override
  String get imageFolderErrorDescription =>
      'Nie udało się zmienić folderu obrazów!';

  @override
  String get backupErrorDescription =>
      'Nie udało się utworzyć kopii zapasowej!';

  @override
  String get restoreErrorDescription =>
      'Nie udało się przywrócić kopii zapasowej!';

  @override
  String get settingsBackupRestoreTitle => 'Kopia i przywracanie';

  @override
  String get settingsBackup => 'Kopia zapasowa';

  @override
  String get settingsRestore => 'Przywróć';

  @override
  String get settingsRestorePromptDescription =>
      'Przywracanie kopii nadpisze wszystkie istniejące dane!';

  @override
  String get settingsBackupPasswordProtect => 'Kopie zapasowe chronione hasłem';

  @override
  String get backupEncryptedTitle => 'Szyfrowana kopia zapasowa';

  @override
  String get backupEncryptedContent =>
      'Ta kopia zapasowa jest chroniona hasłem.';

  @override
  String get settingsAutoBackup => 'Automatyczne kopie zapasowe';

  @override
  String get settingsAutoBackupLocation => 'Lokalizacja kopii zapasowej';

  @override
  String get settingsAutoBackupInterval =>
      'Interwał tworzenia kopii zapasowych';

  @override
  String get settingsAutoBackupIntervalDaily => 'Codziennie';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Co tydzień';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Miesięcznie';

  @override
  String get settingsAutoBackupMaxCount => 'Kopie zapasowe do przechowywania';

  @override
  String get settingsAutoBackupRequireCharging => 'Tylko podczas ładowania';

  @override
  String settingsBackupLast(Object time) {
    return 'Ostatnia kopia zapasowa $time';
  }

  @override
  String get settingsBackupNever => 'Nigdy nie tworzyłem kopii zapasowej';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Następna kopia zapasowa $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'Wszystko';

  @override
  String get autoBackupFailedTitle =>
      'Tworzenie kopii zapasowej nie powiodło się';

  @override
  String tranferStatus(Object percent) {
    return 'Przenoszenie...$percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Tworzenie kopii zapasowej... $percent\$';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Przywracanie kopii zapasowej... $percent%';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return 'Szyfrowanie kopii zapasowej… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Odszyfrowywanie kopii zapasowej… $percent%';
  }

  @override
  String get cleanUpStatus => 'Czyszczenie…';

  @override
  String get settingsExportToAnotherFormat => 'Eksportuj do innego formatu';

  @override
  String get settingsExportFormatDescription =>
      'To nie powinno być używane jako kopia!';

  @override
  String get settingsImportFromAnotherApp => 'Importuj z innej aplikacji';

  @override
  String get logFormatTitle => 'Wybierz format';

  @override
  String get logFormatDescription =>
      'Formaty innych aplikacji mogą nie wspierać wszystkich funkcji. Proszę o zgłaszanie jakichkolwiek błędów, ponieważ formaty tych aplikacji mogą się zmienić w każdym momencie. To nie wpłynie na istniejące wpisy!';

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
  String get settingsDeleteAllLogsTitle => 'Usuń wszystkie wpisy';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Czy chcesz usunąć wszystkie twoje wpisy?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Wprowadź \'$prompt\' by potwierdzić. Ta operacja jest nieodwracalna!';
  }

  @override
  String get settingsLanguageTitle => 'Język';

  @override
  String get settingsAppLanguageTitle => 'Język aplikacji';

  @override
  String get settingsOverrideAppLanguageTitle => 'Wymuś język aplikacji';

  @override
  String get settingsSecurityTitle => 'Bezpieczeństwo';

  @override
  String get settingsSecurityRequirePassword => 'Wymagaj Hasła';

  @override
  String get settingsSecurityEnterPassword => 'Wprowadź hasło';

  @override
  String get settingsSecuritySetPassword => 'Ustaw Hasło';

  @override
  String get settingsSecurityChangePassword => 'Zmień Hasło';

  @override
  String get settingsSecurityPassword => 'Hasło';

  @override
  String get settingsSecurityConfirmPassword => 'Potwierdź Hasło';

  @override
  String get settingsSecurityOldPassword => 'Stare Hasło';

  @override
  String get settingsSecurityIncorrectPassword => 'Hasło Nieprawidłowe';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'Hasła się nie zgadzają';

  @override
  String get requiredPrompt => 'Wymagane';

  @override
  String get settingsSecurityBiometricUnlock => 'Odblokowanie Biometryczne';

  @override
  String get unlockAppPrompt => 'Odblokuj aplikację';

  @override
  String get settingsAboutTitle => 'O aplikacji';

  @override
  String get settingsVersion => 'Wersja';

  @override
  String get settingsLicense => 'Licencja';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsOpenSourceLicenses => 'Licencje Open Source';

  @override
  String get tagMoodTitle => 'Nastrój';

  @override
  String get selectTagTitle => 'Wybierz opcję Etykieta';

  @override
  String get labelPresentLabel => 'Obecny';

  @override
  String get labelAbsentLabel => 'Nieobecny';

  @override
  String get labelCoverageLabel => 'Zasięg';

  @override
  String chartDistributionTitle(Object tag) {
    return 'Dystrybucja $tag';
  }

  @override
  String get shareAddToLogPickerTitle => 'Wybierz wpis w dzienniku';

  @override
  String get adaptiveEmptyDay => 'Nie ma jeszcze żadnych wpisów na ten dzień';

  @override
  String get adaptiveNewEntry => 'Napisz wpis';

  @override
  String get pageJournalTitle => 'Dziennik';

  @override
  String get coachPrompt1 => 'Co sprawiło, że się dzisiaj uśmiechnąłeś?';

  @override
  String get coachPrompt2 => 'Jakiej jednej rzeczy się dzisiaj nauczyłeś?';

  @override
  String get coachPrompt3 => 'Z kim dzisiaj rozmawiałeś i jakie to uczucie?';

  @override
  String get coachPrompt4 => 'Za co jesteś teraz wdzięczny?';

  @override
  String get coachPrompt5 => 'Co pochłonęło dziś najwięcej Twojej energii?';

  @override
  String get coachPrompt6 => 'Opisz krótką chwilę, którą chcesz zapamiętać.';

  @override
  String get coachPrompt7 => 'Co sprawi, że jutro będzie dobry dzień?';

  @override
  String get coachPrompt8 => 'Co ostatnio przyszło Ci do głowy?';

  @override
  String get coachPrompt9 => 'Co dzisiaj zrobiłeś tylko dla siebie?';

  @override
  String get coachPrompt10 =>
      'Gdyby dzisiejszy dzień miał tytuł, jaki by on był?';

  @override
  String get pageMediaTitle => 'Media';

  @override
  String get pageAtlasTitle => 'Atlas';

  @override
  String get pageCoachTitle => 'Trener';

  @override
  String get noEntrySelected => 'Nie wybrano wpisu.';

  @override
  String get entryShare => 'Udostępnij';

  @override
  String get entryFavorite => 'Gwiazda';

  @override
  String get entryEdit => 'Edytuj';

  @override
  String get entryPrevious => 'Poprzedni wpis';

  @override
  String get entryNext => 'Następny wpis';

  @override
  String get journalStories => 'Historie';

  @override
  String get journalEntries => 'Wpisy';

  @override
  String get journalEmptyHint =>
      'Rozpocznij swój dziennik od dodania nowego wpisu.';

  @override
  String get storyToday => 'Dzisiaj';

  @override
  String get storyThrowback => 'Powrót do przeszłości';

  @override
  String get storyNoThrowback => 'Dzisiaj bez powrotu';

  @override
  String get mediaFiles => 'Pliki multimedialne';

  @override
  String get mediaEmpty => 'Nie ma jeszcze zdjęć.';

  @override
  String get mediaEmptyHint =>
      'Tutaj będą wyświetlane zdjęcia dołączone do wpisów.';

  @override
  String get atlasEmpty => 'Brak wpisów z lokalizacją.';

  @override
  String get atlasEmptyHint =>
      'W tym miejscu będą wyświetlane wpisy z lokalizacją.';

  @override
  String get atlasShowAll => 'Pokaż wszystkie wpisy';

  @override
  String get atlasMyLocation => 'Moja lokalizacja';

  @override
  String get coachAll => 'Wszystko';

  @override
  String get coachPrograms => 'Programy';

  @override
  String get coachTemplates => 'Szablony';

  @override
  String get coachKindProgram => 'Program';

  @override
  String get coachKindTemplate => 'Szablon';

  @override
  String get coachNoTemplates => 'Żadnych programów i szablonów.';

  @override
  String get coachUseTemplate => 'Pisz za pomocą tego szablonu';

  @override
  String get coachProgramEverydayTitle => 'Codzienne chwile';

  @override
  String get coachProgramEverydayDescription =>
      'Pięć krótkich pytań, jedno dziennie. Każde z nich zajmuje minutę lub dwie i pomaga Ci zobaczyć, co sprawiło, że ten dzień był Twój. Delikatny sposób na wyrobienie nawyku pisania po trochu każdego dnia.';

  @override
  String get coachProgramReflectTitle => 'Patrząc do wewnątrz';

  @override
  String get coachProgramReflectDescription =>
      'Jedno głębsze pytanie tygodniowo przez pięć tygodni. Nie spiesz się z każdym z nich: jak się czujesz, co cię męczy, za co jesteś wdzięczny.';

  @override
  String get searchFilters => 'Filtry';

  @override
  String get searchFilterTags => 'Tagi';

  @override
  String get searchFilterStarred => 'Oznaczone gwiazdką';

  @override
  String get searchHint => 'Wpisz, aby wyszukać, lub wybierz filtr.';

  @override
  String get locationTitle => 'Lokalizacja';

  @override
  String get locationName => 'Nazwa miejsca';

  @override
  String get locationRemove => 'Usuń';

  @override
  String get locationServiceDisabled => 'Usługi lokalizacyjne są wyłączone.';

  @override
  String get locationPermissionDenied => 'Odmówiono pozwolenia na lokalizację.';

  @override
  String get locationUnavailable =>
      'Nie udało się uzyskać bieżącej lokalizacji.';

  @override
  String get calendarJumpToToday => 'Skocz do dzisiaj';

  @override
  String get editorStartWriting => 'Zacznij pisać lub wybierz ';

  @override
  String get editorTemplateLink => 'Szablon';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Wybierz szablon';

  @override
  String get templateFeatured => 'Polecane szablony';

  @override
  String get templateMine => 'Moje szablony';

  @override
  String get templateDailyName => 'Codzienny przegląd';

  @override
  String get templateDailyDescription =>
      'Co się wydarzyło, jakie to uczucie i co będzie dalej.';

  @override
  String get templateDailyText =>
      '## Co się dzisiaj wydarzyło\n\n\n## Jak się czułem\n\n\n## Trzy rzeczy, za które jestem wdzięczny\n1. \n2. \n3. \n\n## Jutro\n';

  @override
  String get templateTravelName => 'Wpis w dzienniku podróży';

  @override
  String get templateTravelDescription => 'Miejsca, chwile i jedzenie z drogi.';

  @override
  String get templateTravelText =>
      '## Gdzie poszedłem\n\n\n## Moment, który najbardziej pamiętam\n\n\n## Co zjadłem\n\n\n## Plany na jutro\n';

  @override
  String get templateReadingName => 'Czytanie notatek';

  @override
  String get templateReadingDescription =>
      'Cytaty i przemyślenia z tego, co czytasz.';

  @override
  String get templateReadingText =>
      '## Książka\n\n\n## Gdzie jestem\n\n\n## Cytaty\n> \n\n## Moje myśli\n';

  @override
  String get templateWeeklyName => 'Przegląd tygodniowy';

  @override
  String get templateWeeklyDescription =>
      'Najważniejsze momenty, zmagania i cele na przyszły tydzień.';

  @override
  String get templateWeeklyText =>
      '## Najważniejsze informacje\n\n\n## Co było trudne\n\n\n## Czego się nauczyłem\n\n\n## Skup się na przyszły tydzień\n';

  @override
  String get entryDuplicate => 'Duplikat';

  @override
  String get entryDuplicated => 'Wpis zdublowany';

  @override
  String get entrySaveAsTemplate => 'Zapisz jako szablon';

  @override
  String get entrySavedAsTemplate => 'Zapisano jako szablon';

  @override
  String get storyStatistics => 'Statystyki';

  @override
  String get storyMoodChart => 'Wykres nastroju';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return 'Wpisy $entries · $days dni';
  }

  @override
  String get storyThisYear => 'W tym roku';

  @override
  String get storyLastYear => 'W zeszłym roku';

  @override
  String get storyTapToOpen => 'Kliknij dzień, aby go otworzyć';

  @override
  String get settingsGeneralTitle => 'Generał';

  @override
  String get settingsDataTitle => 'Dane i pamięć';

  @override
  String get settingsStoriesTitle => 'Historie';

  @override
  String get settingsHelpTitle => 'Pomoc i informacje';

  @override
  String get weatherTitle => 'Pogoda';

  @override
  String get weatherClear => 'Jasne';

  @override
  String get weatherPartlyCloudy => 'Częściowe zachmurzenie';

  @override
  String get weatherCloudy => 'Pochmurno';

  @override
  String get weatherFog => 'Mgła';

  @override
  String get weatherDrizzle => 'Mżawka';

  @override
  String get weatherRain => 'Deszcz';

  @override
  String get weatherSnow => 'Śnieg';

  @override
  String get weatherStorm => 'Burza';

  @override
  String get weatherFetch => 'Pobierz pogodę dla tego wpisu';

  @override
  String get weatherNeedsLocation =>
      'Najpierw dodaj lokalizację ze współrzędnymi.';

  @override
  String get weatherUnavailable =>
      'Pogoda nie jest dostępna dla tego miejsca i czasu.';

  @override
  String get weatherRemove => 'Usuń pogodę';

  @override
  String get activityTitle => 'Aktywność';

  @override
  String get activityStill => 'Nadal';

  @override
  String get activityWalking => 'Chodzenie';

  @override
  String get activityRunning => 'Bieganie';

  @override
  String get activityCycling => 'Jazda na rowerze';

  @override
  String get activityVehicle => 'W pojeździe';

  @override
  String get activityFlying => 'Latanie';

  @override
  String get activityExercise => 'Ćwicz';

  @override
  String get activityDetect => 'Wykryj bieżącą aktywność';

  @override
  String get activityDetectFailed => 'Nie udało się wykryć aktywności.';

  @override
  String get activityRemove => 'Usuń aktywność';

  @override
  String get settingsAutoAddTitle => 'Dodaj automatycznie';

  @override
  String get settingsAutoAddLocation => 'Lokalizacja';

  @override
  String get settingsAutoAddWeather => 'Pogoda';

  @override
  String get settingsAutoAddHint =>
      'Nowe wpisy są wypełniane podczas tworzenia.';

  @override
  String get settingsTemperatureUnit => 'Jednostka temperatury';

  @override
  String get settingsCelsius => 'Celsjusza (°C)';

  @override
  String get settingsFahrenheit => 'Fahrenheita (°F)';

  @override
  String get moodGreat => 'Świetnie';

  @override
  String get moodGood => 'Dobrze';

  @override
  String get moodOkay => 'OK';

  @override
  String get moodBad => 'Złe';

  @override
  String get moodAwful => 'Okropne';

  @override
  String get locationSearchHint => 'Wyszukaj miejsce';

  @override
  String get locationSearchEmpty => 'Nie znaleziono żadnych miejsc';

  @override
  String get settingsWallpaper => 'Tapeta';

  @override
  String get wallpaperNone => 'Żadne';

  @override
  String get wallpaperDots => 'Kropki';

  @override
  String get wallpaperGrid => 'Siatka';

  @override
  String get wallpaperLines => 'Linie';

  @override
  String get wallpaperPhoto => 'Zdjęcie…';

  @override
  String get settingsFontFamily => 'Czcionka';

  @override
  String get fontSystem => 'Systemu';

  @override
  String get fontSerif => 'Szeryf';

  @override
  String get fontMono => 'Monoprzestrzeń';

  @override
  String get settingsFontSize => 'Rozmiar czcionki';

  @override
  String get fontSizeSmall => 'Mały';

  @override
  String get fontSizeMedium => 'Średni';

  @override
  String get fontSizeLarge => 'Duży';

  @override
  String get fontSizeExtraLarge => 'Bardzo duży';

  @override
  String get settingsLineSpacing => 'Odstępy między wierszami';

  @override
  String get lineSpacingCompact => 'Kompaktowy';

  @override
  String get lineSpacingNormal => 'Normalne';

  @override
  String get lineSpacingRelaxed => 'Zrelaksowany';

  @override
  String get moodAssociationsTitle => 'Co sprawia, że czuję…';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching z wpisów $total';
  }

  @override
  String get videoRecord => 'Nagraj wideo';

  @override
  String get videoChoose => 'Wybierz film';

  @override
  String get audioRecordTitle => 'Nagraj notatkę głosową';

  @override
  String get audioChoose => 'Wybierz plik audio';

  @override
  String get audioStart => 'Nagraj';

  @override
  String get audioStop => 'Zatrzymaj się i zapisz';

  @override
  String get audioPermissionDenied =>
      'Dostęp do mikrofonu jest wyłączony. Zezwól na to w ustawieniach systemu.';

  @override
  String get mediaTooLarge => 'Ten film jest zbyt duży, aby go załączyć.';

  @override
  String get mediaUnavailable =>
      'Ten załącznik nie jest dostępny na tym urządzeniu.';

  @override
  String get widgetDone => 'Dzisiejszy wpis został napisany';

  @override
  String get widgetPending => 'Jak ci minął dzień?';

  @override
  String get widgetWrite => 'Napisz';

  @override
  String get insertChecklist => 'Lista kontrolna';

  @override
  String get insertNumberedList => 'Lista numerowana';

  @override
  String get insertTable => 'Stół';

  @override
  String get insertDivider => 'Dzielnik';

  @override
  String get insertCodeBlock => 'Blok kodu';

  @override
  String get journalSortTitle => 'Sortuj wpisy';

  @override
  String get journalSortUpdated => 'Ostatnia aktualizacja';

  @override
  String get settingsTimeFormat => 'Format czasu';

  @override
  String get settingsDayStart =>
      'Nowe wpisy liczą się od dnia poprzedzającego do';

  @override
  String get settingsDayAskUntil => 'Następnie zapytaj, do którego dnia';

  @override
  String get settingsDayStartMidnight => 'Wyłączone';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Przy każdym wpisie obok godziny powstania wpisu znajduje się dzień, do którego należy, a w dowolnej chwili możesz zmienić ten dzień w edytorze. Te godziny wybierają tylko dzień dla nowych wpisów, więc ich zmiana nie powoduje przeniesienia żadnego istniejącego wpisu.';

  @override
  String get lateNightBadge =>
      'Pisane późnym wieczorem, liczone z poprzedniego dnia';

  @override
  String editorDayAsk(String time) {
    return 'Napisano pod adresem $time. Na który to dzień?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (wczoraj)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (dzisiaj)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'Napisano $when';
  }

  @override
  String get timeFormat12 => '12-godzinny';

  @override
  String get timeFormat24 => '24-godzinne';

  @override
  String get settingsReminderDays => 'Przypomnij mi dalej';

  @override
  String get locationRecent => 'Ostatnie miejsca';

  @override
  String get shareImage => 'Udostępnij obraz';

  @override
  String get shareSaveImage => 'Zapisz obraz';

  @override
  String get shareSaved => 'Obraz został zapisany';

  @override
  String get deletedTitle => 'Niedawno usunięte';

  @override
  String get deletedNone => 'Nic ostatnio nie zostało usunięte';

  @override
  String deletedHint(int days) {
    return 'Usunięte wpisy pozostają tutaj przez $days dni, a następnie są usuwane.';
  }

  @override
  String deletedDaysLeft(int days) {
    return 'Pozostało dni $days';
  }

  @override
  String get deletedRestore => 'Przywróć';

  @override
  String get deletedDeleteForever => 'Usuń na zawsze';

  @override
  String get deletedDeleteForeverDescription =>
      'Wpis i jego załączniki zostaną usunięte. Tego nie można cofnąć.';

  @override
  String get deletedEmpty => 'Pusty';

  @override
  String get deletedEmptyDescription =>
      'Usuń wszystkie wpisy w Ostatnio usunięte? Tego nie można cofnąć.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Przypadkowy spacer';

  @override
  String get randomSubtitle => 'Otwórz poprzedni wpis';

  @override
  String get randomNext => 'Inny';

  @override
  String get randomAll => 'Wszystko';

  @override
  String get randomWithPhotos => 'Ze zdjęciami';

  @override
  String get randomGoodDays => 'Dobre dni';

  @override
  String get randomEmpty => 'Brak wpisów do wyboru';

  @override
  String get reviewWeekTitle => 'W tym tygodniu';

  @override
  String get reviewWeekSubtitle => 'Twój tydzień jak dotąd';

  @override
  String get reviewYearTitle => 'W tym roku';

  @override
  String get reviewEmpty => 'Jeszcze nic nie napisano';

  @override
  String get reviewEntries => 'Wpisy';

  @override
  String get reviewDaysWritten => 'Zapisane dni';

  @override
  String get reviewWords => 'Słowa';

  @override
  String get reviewPhotos => 'Zdjęcia';

  @override
  String get reviewLongestRun => 'Najdłuższy ciąg dni';

  @override
  String get reviewAverageMood => 'Przeciętny nastrój';

  @override
  String get reviewFavorites => 'Najczęściej';

  @override
  String get reviewByMonth => 'Według miesiąca';

  @override
  String get reviewHighlight => 'Zaznacz';

  @override
  String get yearInPixels => 'Rok w pikselach';

  @override
  String get capsuleSeal => 'Pieczęć jako kapsuła czasu';

  @override
  String get capsuleTitle => 'Kapsuła czasu';

  @override
  String capsuleOpensOn(Object date) {
    return 'Otwiera się na $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Napisano na $date';
  }

  @override
  String get capsuleOpenEarly => 'Otwórz wcześnie';

  @override
  String get capsuleOpenEarlyDescription =>
      'Kapsułka otwiera się teraz i pozostaje otwarta.';

  @override
  String get capsuleOpened => 'Kapsuła czasu otwarta';

  @override
  String get templateMorningName => 'Poranne strony';

  @override
  String get templateMorningDescription => 'Ustaw dzień w trzy minuty';

  @override
  String get templateMorningText =>
      '## Trzy rzeczy, które chcę dzisiaj zrobić dobrze\n1. \n2. \n3. \n\n## Coś, na co nie mogę się doczekać\n\n## Notatka dla mnie\n';

  @override
  String get templateEveningName => 'Wieczorna recenzja';

  @override
  String get templateEveningDescription =>
      'Zakończ dzień tym, co poszło dobrze';

  @override
  String get templateEveningText =>
      '## Trzy dobre rzeczy dzisiaj\n1. \n2. \n3. \n\n## Czego się nauczyłem\n\n## Co może jutro pójść lepiej\n';

  @override
  String get routineMorning => 'Dzień dobry';

  @override
  String get routineEvening => 'Wieczorna recenzja';

  @override
  String get settingsRoutinePrompts => 'Polecenia poranne i wieczorne';

  @override
  String get settingsRoutinePromptsHint =>
      'Zaproponuj szablon poranny lub wieczorny w Stories';

  @override
  String get checkInTitle => 'Szybkie zameldowanie';

  @override
  String get checkInSubtitle => 'Nastrój w dwóch kranach';

  @override
  String get checkInMood => 'Jak się czujesz?';

  @override
  String get checkInActivity => 'Co robisz?';

  @override
  String get checkInNote => 'Linia na ten temat (opcjonalnie)';

  @override
  String get checkInSave => 'Zapisz';

  @override
  String editorWordCount(int words, int characters) {
    return '$words słowa · $characters znaki';
  }

  @override
  String get coachProgramEverydayTagline =>
      'Zauważaj małe rzeczy w ciągu dnia.';

  @override
  String get coachProgramReflectTagline => 'Zwolnij i posłuchaj siebie.';

  @override
  String get coachDuration => 'Czas trwania';

  @override
  String get coachInterval => 'Interwał';

  @override
  String get coachDifficulty => 'Trudność';

  @override
  String get coachIntervalDaily => 'Codziennie';

  @override
  String get coachIntervalWeekly => 'Co tydzień';

  @override
  String get coachDifficultyBeginner => 'Początkujący';

  @override
  String get coachDifficultyIntermediate => 'Średnio zaawansowany';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dnia',
      one: '$count dzień',
      many: '$count dni',
      few: '$count dni',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tygodnia',
      one: '$count tydzień',
      many: '$count tygodni',
      few: '$count tygodnie',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'Dzień $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Tydzień $n';
  }

  @override
  String get coachEnroll => 'Zapisz się';

  @override
  String get coachEndProgram => 'Zakończ program';

  @override
  String get coachAuthor => 'Autor';

  @override
  String get coachAuthorBio => 'Podpowiedzi napisane dla tej aplikacji.';

  @override
  String get coachEnrolledTip =>
      'Wszystko gotowe! Twoje pytania pojawią się w Stories.';

  @override
  String get coachGoToStories => 'Przejdź do Historii';

  @override
  String get coachAnswerHint => 'Napisz swoją odpowiedź…';

  @override
  String get storyWrapUp => 'To wszystko na dzisiaj.';

  @override
  String get storyTapToClose => 'Kliknij, aby zamknąć';

  @override
  String get coachAnswerDone => 'Gotowe';

  @override
  String get coachAnswered => 'Odebrano. Kliknij, aby otworzyć';

  @override
  String get coachAnsweredEarlier => 'Odpowiedziano';

  @override
  String get locationLocating => 'Lokalizowanie…';

  @override
  String get locationPickPlace => 'Wybierz miejsce';

  @override
  String get locationPlacesHint => 'Adres lub nazwa miejsca';

  @override
  String get locationCustom => 'Niestandardowe miejsce';

  @override
  String get locationCurrent => 'Aktualna lokalizacja';

  @override
  String get locationSaved => 'Zapisane miejsca';

  @override
  String get locationSearchResults => 'Wyniki wyszukiwania';

  @override
  String get locationNearby => 'Miejsca w pobliżu';

  @override
  String get locationRename => 'Zmień nazwę';

  @override
  String get locationSavePlace => 'Zapisz miejsce';

  @override
  String get locationUnsavePlace => 'Usuń z zapisanych miejsc';

  @override
  String get shareAs => 'Udostępnij jako…';

  @override
  String get shareAsImage => 'Obraz';

  @override
  String get shareAsZip => 'ZIP z oryginalnym nośnikiem';

  @override
  String get shareAsPlainText => 'Zwykły tekst';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Witamy w AID Diary';

  @override
  String get onboardWelcomeText =>
      'Zacznij tutaj lub podłącz to urządzenie do tego, którego już używasz.';

  @override
  String get onboardStart => 'Zacznij pisać';

  @override
  String get helpFaq => 'Często zadawane pytania';

  @override
  String get helpFaq1Q => 'Gdzie jest przechowywany mój pamiętnik?';

  @override
  String get helpFaq1A =>
      'Twój pamiętnik jest przechowywany na tym urządzeniu. Dotrze do innych urządzeń lub pamięci tylko wtedy, gdy włączysz synchronizację, udostępnisz lub wyeksportujesz. Synchronizacja jest szyfrowana od początku do końca.';

  @override
  String get helpFaq2Q =>
      'Jak zachować kopię lub przenieść się na nowe urządzenie?';

  @override
  String get helpFaq2A =>
      'Połącz się z istniejącym urządzeniem w Ustawieniach → Dane i pamięć → Synchronizuj i potwierdź autoryzację na urządzeniu, na którym znajduje się Twój pamiętnik. Obydwa urządzenia nadal nadają się do użytku. Możesz także utworzyć kopię zapasową i przywrócić ją na innym urządzeniu.';

  @override
  String get helpFaq3Q =>
      'Czy mogę wprowadzać wpisy z innych aplikacji do dziennika?';

  @override
  String get helpFaq3A =>
      'Tak: w Ustawieniach → Dane i pamięć, importuj eksporty z Daylio, Diarium, Diaro, DayBook, My Brain, OneShot i Pixels lub eksport JSON.';

  @override
  String get helpFaq4Q => 'Jak działają programy coachingowe?';

  @override
  String get helpFaq4A =>
      'Zarejestruj się w programie na stronie Coach. Każdego dnia lub tygodnia w Stories czeka nowe pytanie; Twoja odpowiedź zostanie zapisana jako wpis.';

  @override
  String get helpFaq5Q => 'Co się stanie, jeśli zapomnę hasła?';

  @override
  String get helpFaq5A =>
      'Hasła nie można odzyskać, dlatego należy zachować kopię zapasową swojego dziennika.';

  @override
  String get helpPrivacy => 'Prywatność';

  @override
  String get helpPrivacyText =>
      'Treść pamiętnika i multimedia pozostają na tym urządzeniu, chyba że włączysz szyfrowaną synchronizację lub udostępnisz/wyeksportujesz je. Mapy, wyszukiwanie miejsc i pogoda korzystają ze skonfigurowanych usług i wysyłają lokalizację lub zapytanie potrzebne do tego żądania, a nie tekst pamiętnika.';

  @override
  String get photoMetaTitle => 'Użyć szczegółów zdjęcia?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Policzyć ten wpis dla $date i ustawić jego miejsce na $place, jak widać na zdjęciu?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Policzyć ten wpis dla $date, kiedy zdjęcie zostało zrobione?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Ustaw miejsce tego wpisu na $place, gdzie zostało zrobione zdjęcie?';
  }

  @override
  String get photoMetaApply => 'Użyj ich';

  @override
  String get quickWriteTitle => 'Szybkie pisanie';

  @override
  String get quickWriteText => 'Stuknij, aby rozpocząć nowy wpis.';

  @override
  String get settingsQuickWriteTitle => 'Szybkie pisanie w powiadomieniach';

  @override
  String get settingsQuickWriteDescription =>
      'Zachowaj powiadomienie otwierające nowy wpis.';

  @override
  String get settingsNudgesTitle => 'Szturchnij mnie po spokojnym rozciąganiu';

  @override
  String settingsNudgesDescription(int days) {
    return 'Delikatne przypomnienie, gdy nie pisałeś przez $days dni.';
  }

  @override
  String get nudgeTitle => 'Minęło trochę czasu';

  @override
  String get nudgeMonday => 'Nowy tydzień: czego nie możesz się doczekać?';

  @override
  String get nudgeTuesday => 'Wystarczą dwie linie. Jak się dzisiaj masz?';

  @override
  String get nudgeWednesday =>
      'W połowie tygodnia. Co wyróżniało się do tej pory?';

  @override
  String get nudgeThursday => 'Coś małego, co warto zachować z dzisiaj?';

  @override
  String get nudgeFriday =>
      'Tydzień dobiega końca. Zwróć uwagę na jeden dobry moment.';

  @override
  String get nudgeSaturday => 'Wolna sobota to dobry dzień na pisanie.';

  @override
  String get nudgeSunday => 'Przypomnij sobie tydzień przed jego zakończeniem.';

  @override
  String get photoWidgetEmpty =>
      'Tutaj pojawiają się zdjęcia dodane do wpisów.';

  @override
  String get channelReminders => 'Przypomnienia';

  @override
  String get channelOnThisDay => 'Tego dnia';

  @override
  String get channelCoach => 'Trener podpowiada';

  @override
  String get channelNudges => 'Odświeża po spokojnych dniach';

  @override
  String get channelQuickWrite => 'Szybkie pisanie';

  @override
  String get channelBackup => 'Kopie zapasowe';

  @override
  String get formatJsonExport => 'JSON (eksport AID Diary)';

  @override
  String get aboutModifiedNotice =>
      'Zmodyfikowana wersja Daily You autorstwa Demizo i współpracowników. To nie jest oficjalna aplikacja Daily You.';

  @override
  String get toolbarPhotos => 'Dodaj zdjęcia';

  @override
  String get toolbarMedia => 'Zdjęcia i filmy';

  @override
  String get mediaFromGallery => 'Wybierz z galerii';

  @override
  String get mediaFromFiles => 'Wybierz spośród plików';

  @override
  String get editorLeaveTitle => 'Zapisać ten wpis?';

  @override
  String get editorLeaveDiscard => 'Nie oszczędzaj';

  @override
  String get editorTitleHint => 'Tytuł';

  @override
  String get editorLocating => 'Lokalizowanie…';

  @override
  String get toolbarVideo => 'Wideo';

  @override
  String get toolbarAudio => 'Notatka głosowa';

  @override
  String get toolbarTags => 'Tagi';

  @override
  String get toolbarBulletList => 'Lista punktowana';

  @override
  String get toolbarHeading => 'Nagłówek';

  @override
  String get toolbarBold => 'Odważne';

  @override
  String get toolbarItalic => 'Kursywa';

  @override
  String get toolbarHighlight => 'Zaznacz';

  @override
  String get toolbarStrikethrough => 'Przekreślenie';

  @override
  String get toolbarQuote => 'Cytat';

  @override
  String get toolbarLink => 'Link';

  @override
  String get toolbarInsert => 'Wstaw';

  @override
  String get toolbarUndo => 'Cofnij';

  @override
  String get toolbarRedo => 'Powtórz';

  @override
  String get toolbarInsertDate => 'Wstaw datę';

  @override
  String get toolbarInsertTime => 'Wstaw godzinę';

  @override
  String get settingsSyncTitle => 'Synchronizacja w chmurze';

  @override
  String get syncOffDescription =>
      'Prowadź ten dziennik w ten sam sposób na wszystkich swoich urządzeniach za pośrednictwem serwera Google Drive lub WebDAV, takiego jak Nextcloud, Synology lub Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'Synchronizuj z Google Drive';

  @override
  String get syncOrWebDav => 'Lub serwer WebDAV';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn => 'Zalogowano. Możesz wrócić do AID Diary.';

  @override
  String get syncGoogleSignInAgain =>
      'Google wymaga ponownego zalogowania się.';

  @override
  String get syncSignInAgain => 'Zaloguj się ponownie';

  @override
  String get settingsCommandLineTitle => 'Linia poleceń';

  @override
  String get commandLineToggle => 'Interfejs wiersza poleceń';

  @override
  String get commandLineToggleHint =>
      'Umożliwia poleceniu pomocy i innym programom na tym urządzeniu korzystanie z poleceń aplikacji.';

  @override
  String get commandLineAlwaysOn =>
      'Zawsze włączone w kompilacjach deweloperskich.';

  @override
  String commandLineListening(int port) {
    return 'Nasłuchuję na porcie $port';
  }

  @override
  String get commandPaletteTitle => 'Wszystkie polecenia';

  @override
  String get commandPaletteSearch => 'Polecenia wyszukiwania';

  @override
  String get commandPaletteRun => 'Biegnij';

  @override
  String get commandPaletteConfirm =>
      'Tego nie można po prostu cofnąć. Uruchomić?';

  @override
  String syncReceiving(int done, int total) {
    return 'Odbieranie $done z $total…';
  }

  @override
  String syncSending(int done, int total) {
    return 'Wysyłanie $done z $total…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'Dostęp do Google Drive nie był dozwolony. Połącz się ponownie i zaznacz Google Drive na stronie Google.';

  @override
  String get syncEntryUnsynced =>
      'Niezsynchronizowane: ostatnia synchronizacja nie została wykonana';

  @override
  String get syncUseOfficial => 'Użyj serwera synchronizacji AID';

  @override
  String get syncServer => 'Adres serwera';

  @override
  String get syncUsername => 'Nazwa użytkownika';

  @override
  String get syncPassword => 'Hasło';

  @override
  String get syncConnect => 'Połącz';

  @override
  String get syncConnecting => 'Łączę…';

  @override
  String get syncSignInFailed =>
      'Nie można się zalogować. Sprawdź adres, nazwę użytkownika i hasło.';

  @override
  String syncConnectFailed(String error) {
    return 'Nie udało się połączyć: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Rozpocznij synchronizację';

  @override
  String get syncNewSpaceDescription =>
      'Nie ma tu jeszcze zsynchronizowanego pamiętnika. Ten dziennik zostanie przesłany i całkowicie zaszyfrowany kluczem, który pozostanie na Twoich urządzeniach.';

  @override
  String get syncJoinTitle => 'Dołącz do zsynchronizowanego dziennika';

  @override
  String get syncWrongKey =>
      'Ten kod odzyskiwania nie otwiera zsynchronizowanego dziennika.';

  @override
  String syncLastSynced(String time) {
    return 'Ostatnia synchronizacja $time';
  }

  @override
  String get syncNever => 'Jeszcze nie zsynchronizowane';

  @override
  String get syncSyncing => 'Synchronizowanie…';

  @override
  String syncFailed(String error) {
    return 'Ostatnia synchronizacja nie powiodła się: $error';
  }

  @override
  String get syncLocked =>
      'Zsynchronizowany dziennik należy teraz do innych urządzeń lub został rozpoczęty od nowa. Sparuj z jednym z nich lub użyj kodu odzyskiwania, aby kontynuować synchronizację.';

  @override
  String get syncNow => 'Zsynchronizuj teraz';

  @override
  String get syncUnlock => 'Odblokuj';

  @override
  String get syncEncrypted => 'Szyfrowane od końca do końca';

  @override
  String get syncDisconnect => 'Zatrzymaj synchronizację';

  @override
  String get syncDisconnectDescription =>
      'To urządzenie przestaje się synchronizować. Dziennik i zsynchronizowana kopia pozostają bez zmian.';

  @override
  String get syncOwnRecoveryPassword =>
      'Użyj mojego własnego hasła odzyskiwania';

  @override
  String get syncRecoveryPassword => 'Hasło odzyskiwania';

  @override
  String get syncRecoveryPasswordRepeat => 'Powtórz hasło odzyskiwania';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Użyj co najmniej znaków $min';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'Hasła są różne';

  @override
  String get syncRecoveryCode => 'Kod odzyskiwania';

  @override
  String get syncRecoveryCodeTitle => 'Zapisz kod odzyskiwania';

  @override
  String get syncRecoveryCodeDescription =>
      'Jeśli utracone zostanie każde Twoje urządzenie, ten kod przywróci zsynchronizowany dziennik. Trzymaj go w menedżerze haseł lub na papierze. Jest to pokazane tylko raz.';

  @override
  String get syncRecoveryCodeCopied => 'Skopiowano kod odzyskiwania';

  @override
  String get syncRecoveryCodeSaved => 'Zachowałem to';

  @override
  String get syncJoinNeedsKey =>
      'Ten zsynchronizowany pamiętnik należy do innych Twoich urządzeń. Połącz się z jednym z nich lub użyj kodu odzyskiwania. Wpisy na tym urządzeniu zostaną do niego dodane.';

  @override
  String get syncPairDevice => 'Sparuj z urządzeniem';

  @override
  String get syncUseRecoveryCode => 'Użyj kodu odzyskiwania';

  @override
  String get syncAddDevice => 'Dodaj urządzenie';

  @override
  String get syncChangeRecoveryCode => 'Zmień kod odzyskiwania';

  @override
  String get syncChangeRecoveryDescription =>
      'Nowy kod zastępuje dotychczasowy, który przestaje działać. Twoje dane i inne urządzenia pozostają bez zmian.';

  @override
  String get syncNewRandomCode => 'Nowy losowy kod';

  @override
  String get syncRecoveryCodeChanged => 'Kod odzyskiwania został zmieniony';

  @override
  String get syncResetSpace => 'Rozpocznij synchronizowany dziennik od nowa';

  @override
  String get syncResetSpaceDescription =>
      'Tylko wtedy, gdy żadne urządzenie ani kod odzyskiwania już go nie otworzy: zsynchronizowana kopia zostanie zastąpiona dziennikiem na tym urządzeniu, pod kluczami tego urządzenia. Następnie pozostałe urządzenia zostaną ponownie sparowane.';

  @override
  String get syncPairTitle => 'Sparuj urządzenia';

  @override
  String get syncPairShow => 'Pokaż kod';

  @override
  String get syncPairEnter => 'Wpisz kod';

  @override
  String get syncPairShowHint =>
      'Na drugim urządzeniu otwórz opcję Połącz urządzenia, wybierz opcję Wprowadź kod i wpisz lub zeskanuj go.';

  @override
  String get syncPairEnterHint =>
      'Wpisz kod wyświetlany na drugim urządzeniu lub zeskanuj go.';

  @override
  String get syncPairCode => 'Kod parowania';

  @override
  String get syncPairScan => 'Skanuj';

  @override
  String get syncPairStart => 'Para';

  @override
  String get syncPairWaiting => 'Czekam na drugie urządzenie…';

  @override
  String syncPairDone(String device) {
    return 'W połączeniu z $device';
  }

  @override
  String get syncPairWrongCode =>
      'Kod nie pasował. Pokaż nowy kod i spróbuj ponownie.';

  @override
  String get syncPairNoOffer =>
      'Żadne urządzenie nie wyświetla tego kodu. Być może wygasł.';

  @override
  String get syncPairTimedOut => 'Drugie urządzenie nie odpowiedziało na czas.';

  @override
  String get syncPairNeither =>
      'Na żadnym urządzeniu nie skonfigurowano jeszcze tego zsynchronizowanego dziennika.';

  @override
  String get syncPairBoth =>
      'Obydwa urządzenia już otwierają ten zsynchronizowany dziennik.';

  @override
  String syncPairFailed(String error) {
    return 'Parowanie nie powiodło się: $error';
  }

  @override
  String get syncMediaPending =>
      'Dziennik zsynchronizowany · niektóre multimedia są nadal przesyłane';

  @override
  String get syncWaitingForDevices =>
      'Dziennik zsynchronizowany · oczekiwanie, aż inne urządzenie prześle multimedia';

  @override
  String get syncCacheNotice =>
      'Media w chmurze mają charakter tymczasowy. Zachowaj oryginały na swoich urządzeniach; synchronizacja nie jest kopią zapasową.';

  @override
  String get paperTitle => 'Papier listowy';

  @override
  String get paperPlain => 'Zwykły';

  @override
  String get paperLined => 'Z podszewką';

  @override
  String get paperGrid => 'Siatka';

  @override
  String get paperTinted => 'Przyciemniane';

  @override
  String get paperDecorationTitle => 'Dekoracje';

  @override
  String get paperDecorationNone => 'Żadne';

  @override
  String get paperDecorationBotanical => 'Liście';

  @override
  String get paperDecorationStars => 'Gwiazdy';

  @override
  String get paperDecorationWashi => 'Taśma Washi';

  @override
  String get themeDarkChoice => 'Ciemny wygląd';

  @override
  String get themeDarkSame => 'Podążaj za jasną paletą';

  @override
  String get themeDarkCustom => 'Oddzielna paleta';

  @override
  String get themeDarkAccent => 'Ciemny akcent kolorystyczny';

  @override
  String get themeColorTeal => 'Turkusowy';

  @override
  String get themeColorCyan => 'Cyjan';

  @override
  String get themeColorIndigo => 'Indygo';

  @override
  String get themeColorCoral => 'Koral';

  @override
  String get themeColorOlive => 'Oliwka';

  @override
  String get themeColorSlate => 'Łupek';

  @override
  String get drawingTitle => 'Rysunek';

  @override
  String get drawingPen => 'Pióro';

  @override
  String get drawingEraser => 'Gumka';

  @override
  String get drawingUndo => 'Cofnij';

  @override
  String get drawingClear => 'Jasne';

  @override
  String get drawingWidth => 'Szerokość pióra';

  @override
  String get drawingStylusOnly => 'Tylko rysik';

  @override
  String get drawingDiscardTitle => 'Odrzucić rysunek?';

  @override
  String get drawingDiscardBody => 'Ten rysunek nie został zapisany.';

  @override
  String get drawingSaveError => 'Nie można zapisać rysunku.';

  @override
  String get syncNetworkTitle => 'Diagnostyka sieci';

  @override
  String get syncNetworkRefresh => 'Odśwież';

  @override
  String get syncNetworkSelectedRoute => 'Aktualna ścieżka';

  @override
  String get syncNetworkAvailableRoutes => 'Dostępne ścieżki';

  @override
  String get syncNetworkSignaling => 'Połączenie z katalogiem urządzenia';

  @override
  String get syncNetworkRelayRemaining => 'Pozostały dodatek na przekaźnik';

  @override
  String get syncNetworkIcePair => 'Kandydaci na bezpośrednie połączenie';

  @override
  String get syncNetworkPeerTrusted => 'Uwierzytelnione urządzenie';

  @override
  String get syncNetworkNoRoute => 'Oczekiwanie na połączenie';

  @override
  String get syncNetworkUnavailable => 'Diagnostyka jest niedostępna';

  @override
  String get syncMediaCopiesTitle => 'Dostawa mediów i kopie';

  @override
  String get syncMediaPendingCount => 'Oczekiwanie na transfer';

  @override
  String get syncMediaDurableCount => 'Dostarczone do magazynu osobistego';

  @override
  String get syncMediaTemporaryCount => 'Kopie tymczasowe lub niepotwierdzone';

  @override
  String get syncMediaReceiptExplanation =>
      'Liczniki te opisują zrealizowane dostawy, a nie nowy audyt zachowanych kopii zapasowych.';

  @override
  String get syncMediaCacheExplanation =>
      'Tymczasowe multimedia w chmurze mogą wygasnąć. Zachowaj oryginały lub osobną kopię zapasową.';

  @override
  String get momentsTitle => 'Chwile fotograficzne';

  @override
  String get momentsHint =>
      'Znajdź grupy, korzystając z lokalnych czasów robienia zdjęć i opcjonalnych współrzędnych. Zdjęcia załączane są dopiero po wybraniu karty.';

  @override
  String get momentsScan => 'Znajdź chwile';

  @override
  String get momentsChooseFolder => 'Wybierz folder ze zdjęciami';

  @override
  String get momentsLocation => 'Uwzględnij lokalizacje zdjęć';

  @override
  String get momentsEmpty => 'Brak ostatnich grup zdjęć.';

  @override
  String get momentsCreate => 'Napisz o tych zdjęciach';

  @override
  String get momentsDismiss => 'Odrzuć';

  @override
  String get momentsError => 'Nie udało się odczytać lokalnych zdjęć.';

  @override
  String get momentsCreated => 'Wpis ze zdjęciem został utworzony.';

  @override
  String get momentsPermission =>
      'Zezwól na dostęp do zdjęć, aby znaleźć lokalne sugestie.';

  @override
  String get momentsScope =>
      'Tylko aktualne zdjęcia; maksymalnie 500 zdjęć i 20 zdjęć na karcie.';

  @override
  String momentsPhotoCount(int count) {
    return 'Zdjęcia $count';
  }

  @override
  String get nearbyTitle => 'Podłącz urządzenia';

  @override
  String get nearbySend => 'Autoryzuj kolejne urządzenie';

  @override
  String get nearbyReceive => 'Połącz się z istniejącym urządzeniem';

  @override
  String get nearbyInstructions =>
      'Połącz oba urządzenia z tym samym Wi-Fi lub ze swoim hotspotem. Potwierdź autoryzację na istniejącym urządzeniu; oba urządzenia pozostają użyteczne. Nie jest wymagany dostęp do Internetu.';

  @override
  String get nearbyCompare =>
      'Przed zatwierdzeniem porównaj ten kod na obu urządzeniach.';

  @override
  String get nearbyConfirm => 'Kody się zgadzają';

  @override
  String get nearbyScan => 'Zeskanuj kod drugiego urządzenia';

  @override
  String get nearbyPaste => 'Wklej zaproszenie';

  @override
  String get nearbyWaiting =>
      'Oczekiwanie na zatwierdzenie na drugim urządzeniu';

  @override
  String get nearbyWorking =>
      'Autoryzuję i synchronizuję Twój dziennik i załączniki…';

  @override
  String get nearbyPending =>
      'Niektóre załączniki nadal wymagają synchronizacji. Pozostaw drugie urządzenie w trybie online i spróbuj ponownie.';

  @override
  String get nearbyComplete =>
      'Urządzenie podłączone; synchronizacja pamiętnika i załączników';

  @override
  String get nearbyFailed =>
      'Połączenie nie zostało zakończone. Sprawdź połączenie lokalne i spróbuj ponownie.';

  @override
  String get nearbyEmptyRequired =>
      'Użyj urządzenia z pustym dziennikiem, które nie jest jeszcze podłączone do synchronizacji.';

  @override
  String get nearbyRetry => 'Kontynuuj synchronizację';

  @override
  String get nearbyWifi => 'Ustawienia Wi-Fi';

  @override
  String get nearbyHotspot => 'Ustawienia hotspotu';

  @override
  String get nearbyKeepOpen =>
      'Pozostaw tę stronę otwartą do czasu zakończenia pracy nad nowym urządzeniem. Zaproszenie wygasa po dwóch minutach.';

  @override
  String get syncDevicesTitle => 'Autoryzowane urządzenia';

  @override
  String get syncDevicesDescription =>
      'Tylko zatwierdzone urządzenia mogą uzyskać dostęp do tego konta AID. Unieważnienie urządzenia blokuje serwer, ale nie może usunąć klucza głównego ani dziennika już na niego skopiowanego.';

  @override
  String get syncDeviceRequest =>
      'Pokaż ten autoryzacyjny kod QR zatwierdzonemu urządzeniu';

  @override
  String get syncDeviceAuthorize => 'Autoryzuj urządzenie';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Zeskanuj lub wklej żądanie autoryzacji nowego urządzenia.';

  @override
  String get syncDeviceRevoke => 'Odwołaj';

  @override
  String get syncDeviceRotate => 'Obróć klucz podpisywania tego urządzenia';

  @override
  String get syncDeviceCheck => 'Sprawdź autoryzację';

  @override
  String get syncDeviceHardware => 'Klucz podpisywania wspierany sprzętowo';

  @override
  String get syncDeviceSoftware =>
      'Nieeksportowalny klucz podpisywania oprogramowania';

  @override
  String get syncDeviceUnavailable =>
      'Autoryzacja urządzenia jest niedostępna. Zatwierdź to urządzenie z innego autoryzowanego urządzenia i spróbuj ponownie.';

  @override
  String get syncDeviceRevoked => 'Unieważnione';

  @override
  String get syncDeviceLocal => 'To urządzenie';

  @override
  String get cloudTrafficTitle =>
      'Miesięczny limit transferu danych w chmurze dla plików multimedialnych';

  @override
  String get cloudTrafficLimit => 'Miesięczny limit transferu danych';

  @override
  String get cloudTrafficUsed => 'Wykorzystano transfer danych';

  @override
  String get cloudTrafficRemaining => 'Pozostał transfer danych';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'Limit transferu danych resetuje się $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'Limit transferu danych w chmurze dla plików multimedialnych został wyczerpany. Brakujące pliki multimedialne zostaną zsynchronizowane automatycznie po udostępnieniu bezpośredniego połączenia lub zresetowaniu limitu.';

  @override
  String get cloudTrafficExplanation =>
      'Buforowanie plików multimedialnych i przekazywanie na żywo współdzielą ten limit transferu danych. Połączenia bezpośrednie go nie zużywają. Wiadomości tekstowe z dziennika i dotyczące kontroli połączenia mają osobne małe limity dzienne.';

  @override
  String get appearanceThemeSection => 'Motyw aplikacji';

  @override
  String get appearancePaperSection => 'Papier do pamiętnika';

  @override
  String get appearanceTypographySection => 'Tekst pamiętnika';

  @override
  String get appearancePreferencesSection => 'Ogólne preferencje';

  @override
  String get themeSystemAccentHint =>
      'Używa palety systemowej zamiast kolorów niestandardowych. Wyłącz tę opcję, aby wybrać własną.';

  @override
  String get syncDeviceNameSaveFailed =>
      'Nie można zapisać nazwy urządzenia. Spróbuj ponownie.';

  @override
  String get nearbyConnectionHelp => 'Pomoc dotycząca połączenia';

  @override
  String get syncAllSynced => 'Wszystko zsynchronizowane';

  @override
  String get syncDetailsTitle => 'Synchronizuj szczegóły';

  @override
  String get syncMore => 'Więcej opcji';

  @override
  String get syncDeviceName => 'Nazwa urządzenia';

  @override
  String get syncDeviceNameHint => 'Na przykład: Mój tablet';

  @override
  String get syncDeviceNameInvalid => 'Użyj od 1 do 32 znaków';

  @override
  String get syncDeviceKeyDetails => 'Szczegóły bezpieczeństwa';

  @override
  String get syncConnectionProblem =>
      'Na razie nie można przeprowadzić synchronizacji. Automatyczna ponowna próba.';

  @override
  String get syncCopyComplete =>
      'Pełna kopia Twojego pamiętnika i plików multimedialnych';

  @override
  String get syncCopyPartial => 'Nadal brakuje niektórych mediów';

  @override
  String get syncCopyOlder => 'Nowe zmiany czekają na synchronizację';

  @override
  String get syncCopyUnavailable =>
      'Szczegóły kopii są niedostępne. Spróbuj ponownie później.';

  @override
  String get syncCopyLastKnown =>
      'Inne urządzenia pokazują swoją ostatnią potwierdzoną kopię. Nie można teraz sprawdzić urządzeń offline.';

  @override
  String get syncCopyTemporary =>
      'Tymczasowa pamięć podręczna. Zachowaj oryginały na swoich urządzeniach.';

  @override
  String get syncCopyStorage =>
      'Twój magazyn synchronizacji. Zakończone przesyłanie multimediów jest wymienione w diagnostyce.';

  @override
  String syncCopyChecked(String time) {
    return 'Ostatnio potwierdzony $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Transfer danych pozostały w tym miesiącu: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Zacznij tutaj';

  @override
  String get onboardConnect => 'Połącz się z istniejącym urządzeniem';

  @override
  String get onboardFailed =>
      'Nie można ukończyć konfiguracji. Twój pamiętnik jest bezpieczny; spróbuj ponownie.';

  @override
  String get tutorialTitle => 'Jak korzystać z pamiętnika';

  @override
  String get tutorialWriteTitle => 'Napisz swój pierwszy wpis do pamiętnika';

  @override
  String get tutorialWriteText =>
      'Stuknij +, aby napisać wpis do pamiętnika. Dodaj opcjonalny tytuł, wybierz datę pamiętnika i dotknij znacznika wyboru, aby zapisać. W dowolnym momencie możesz ponownie edytować swój wpis w dzienniku.';

  @override
  String get tutorialMediaTitle => 'Dodaj zdjęcia, dźwięk lub charakter pisma';

  @override
  String get tutorialMediaText =>
      'Użyj + w edytorze pamiętników, aby dołączyć zdjęcia, filmy lub nagrania głosowe lub otworzyć obszar pisma odręcznego. Załączniki te zapisywane są wraz z wpisem do dziennika.';

  @override
  String get tutorialReviewTitle => 'Znajdź dzień ponownie';

  @override
  String get tutorialReviewText =>
      'Przeglądaj swój pamiętnik lub kalendarz, przeszukuj swoje teksty i organizuj wpisy za pomocą tagów. Strony Media i Atlas umożliwiają wyszukiwanie wcześniejszych wpisów według zdjęcia lub lokalizacji.';

  @override
  String get tutorialSyncTitle => 'Użyj więcej niż jednego urządzenia';

  @override
  String get tutorialSyncText =>
      'Wybierz Ustawienia → Dane i pamięć → Synchronizacja, połącz się z istniejącym urządzeniem i potwierdź autoryzację na tym urządzeniu. Obydwa urządzenia mogą nadal korzystać z dziennika. Tekst dziennika synchronizuje się jako pierwszy. Następnie pliki multimedialne zostaną zsynchronizowane, jeśli pozwoli na to połączenie sieciowe i pozostały limit transferu danych.';

  @override
  String get tutorialPrivacyTitle => 'Chroń swój pamiętnik';

  @override
  String get tutorialPrivacyText =>
      'Wpisy dziennika pozostają na tym urządzeniu, chyba że włączysz synchronizację, udostępnisz je lub wyeksportujesz. Synchronizacja jest szyfrowana od początku do końca. W Ustawieniach możesz także ustawić hasło do aplikacji, utworzyć kopie zapasowe i ponownie otworzyć ten samouczek.';

  @override
  String get editorDiaryDay => 'Dzień dziennika';

  @override
  String get editorDiaryDayPicker =>
      'Dzień dziennika · czas utworzenia bez zmian';

  @override
  String get editorDiaryDayHint =>
      'Dzień, do którego należy ten wpis. Jego zmiana nie zmienia czasu utworzenia wpisu.';

  @override
  String get hiddenDiaryTitle => 'Ukryte wpisy';

  @override
  String get hiddenDiaryHide => 'Ukryj wpis';

  @override
  String get hiddenDiaryShow => 'Odkryj wpis';

  @override
  String get hiddenDiaryEmpty => 'Brak ukrytych wpisów';

  @override
  String get hiddenDiaryUnlock => 'Odblokuj ukryte wpisy';

  @override
  String get hiddenDiaryAuthHint =>
      'Użyj blokady aplikacji lub ekranu urządzenia.';

  @override
  String get hiddenDiaryLocalOnly =>
      'Ukryte wpisy pozostają na tym urządzeniu i wstrzymują synchronizację. Używaj szyfrowanych kopii zapasowych. Istniejące kopie w innych miejscach pozostają bez zmian.';

  @override
  String get moodClear => 'Wyczyść nastrój';
}
