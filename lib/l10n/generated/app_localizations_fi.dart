// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => 'Teeman väri';

  @override
  String get themeColorHint => 'Valitse väri tälle paletille.';

  @override
  String get themeColorBlue => 'Taivaansininen';

  @override
  String get themeColorGreen => 'Metsän vihreä';

  @override
  String get themeColorBrown => 'Lämmin kahvi';

  @override
  String get themeColorPurple => 'Laventeli';

  @override
  String get themeColorRose => 'Pölyinen ruusu';

  @override
  String get themeColorAmber => 'Meripihka';

  @override
  String get themeColorPreview => 'Joka päivä vähän';

  @override
  String get themeTintBackgroundTitle => 'Sävytä taustat teemaväreillä';

  @override
  String get themeTintBackgroundHint =>
      'Sammuta neutraali harmaa tausta; painikkeet säilyttävät valitsemasi värin.';

  @override
  String get dailyReminderTitle => 'Täytä päiväkirja tänään!';

  @override
  String get dailyReminderDescription => 'Pidä päivittäinen päiväkirjasi…';

  @override
  String get actionTakePhoto => 'Ota kuva';

  @override
  String get flashbacksTitle => 'Muistikuvat';

  @override
  String get settingsFlashbacksExcludeBadDays =>
      'Jätä huonot päivät huomioimatta';

  @override
  String get flashbackGoodDay => 'Hyvä päivä';

  @override
  String get flashbackRandomDay => 'Satunnainen päivä';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count viikkoa sitten',
      one: '$count viikko sitten',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kuukautta sitten',
      one: '$count kuukausi sitten',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vuotta sitten',
      one: '$count vuosi sitten',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'Tänä päivänä';

  @override
  String get searchLogsHint => 'Hae lokeista…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lokia',
      one: '$count loki',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count päivää',
      one: '$count päivä',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sanaa',
      one: '$count sana',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Ei lokeja…';

  @override
  String get noResults => 'Ei tuloksia…';

  @override
  String get sortOrderAscendingTitle => 'Nouseva';

  @override
  String get sortOrderDescendingTitle => 'Laskeva';

  @override
  String get pageStatisticsTitle => 'Tilastot';

  @override
  String get statisticsNotEnoughData => 'Ei tarpeeksi dataa…';

  @override
  String get statisticsRangeOneMonth => 'Yksi kuukausi';

  @override
  String get statisticsRangeSixMonths => 'Kuusi kuukautta';

  @override
  String get statisticsRangeOneYear => 'Yksi vuosi';

  @override
  String get statisticsRangeAllTime => 'Koko aika';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag Yhteenveto';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag Päiväkohtaisesti';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag ajan myötä';
  }

  @override
  String get chartGroupingLabel => 'Ryhmittelyperuste';

  @override
  String get chartGroupingDay => 'päivä';

  @override
  String get chartGroupingWeek => 'Viikko';

  @override
  String get chartGroupingMonth => 'Kuukausi';

  @override
  String get chartGroupingYear => 'vuosi';

  @override
  String get chartSmoothingLabel => 'Tasoitus';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nykyinen putki $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pisin putki $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hienoja päiviä $count',
      one: 'Hienoja päiviä $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Päiviä huonosta päivästä lähtien $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Ulkoiseen tallennustilaan ei pääse käsiksi';

  @override
  String get errorExternalStorageAccessDescription =>
      'Jos käytät verkkotallennustilaa, varmista, että palvelu on verkossa ja sinulla on verkkoyhteys.\n\nMuuten sovellus on saattanut menettää ulkoisen kansion käyttöoikeudet. Siirry asetuksiin ja valitse ulkoinen kansio uudelleen myöntääksesi käyttöoikeudet.\n\nVaroitus: muutoksia ei synkronoida, ennen kuin palautat käyttöoikeuden ulkoiseen tallennussijaintiin!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Jatka paikallisen tietokannan kanssa';

  @override
  String get lastModified => 'Muokattu';

  @override
  String get writeSomethingHint => 'Kirjoita jotain…';

  @override
  String get titleHint => 'Otsikko…';

  @override
  String get deleteLogTitle => 'Poista loki';

  @override
  String get deleteLogDescription => 'Haluatko poistaa tämän lokin?';

  @override
  String get deletePhotoTitle => 'Poista valokuva';

  @override
  String get deletePhotoDescription => 'Haluatko poistaa tämän valokuvan?';

  @override
  String get pageSettingsTitle => 'Asetukset';

  @override
  String get settingsTheme => 'Teema';

  @override
  String get themeSystem => 'Järjestelmä';

  @override
  String get themeLight => 'Vaalea';

  @override
  String get themeDark => 'Tumma';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Viikon ensimmäinen päivä';

  @override
  String get settingsCalendarSystem => 'Kalenterijärjestelmä';

  @override
  String get calendarSystemGregorian => 'gregoriaaninen';

  @override
  String get calendarSystemJalali => 'Jalali';

  @override
  String get settingsUseSystemAccentColor => 'Käytä järjestelmän korostusväriä';

  @override
  String get settingsCustomAccentColor => 'Mukautettu korostusväri';

  @override
  String get settingsShowFlashbacks => 'Näytä takaumat';

  @override
  String get settingsChangeMoodIcons => 'Vaihda mielialakuvakkeita';

  @override
  String get moodIconPrompt => 'Syötä kuvake';

  @override
  String get settingsHideImages => 'Piilota kuvat';

  @override
  String get pageCalendarTitle => 'Kalenteri';

  @override
  String get settingsNotificationsTitle => 'Ilmoitukset';

  @override
  String get settingsDailyReminderTitle => 'Päivittäinen muistutus';

  @override
  String get settingsOnThisDayDescription => 'Palaa menneisiin muistoihin';

  @override
  String get settingsDailyReminderDescription => 'Lempeä muistutus joka päivä';

  @override
  String get settingsReminderTime => 'Muistutusaika';

  @override
  String get settingsFixedReminderTimeTitle => 'Kiinteä muistutusaika';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Valitse muistutukselle kiinteä aika';

  @override
  String get settingsAlwaysSendReminderTitle => 'Lähetä aina muistutus';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Lähetä muistutus, vaikka loki olisi jo aloitettu';

  @override
  String get settingsCustomizeNotificationTitle => 'Mukauta ilmoituksia';

  @override
  String get settingsTemplatesTitle => 'Pohjamallit';

  @override
  String get manageTemplates => 'Hallitse pohjamalleja';

  @override
  String get noTemplateTitle => 'Ei mitään';

  @override
  String get noTemplatesDescription => 'Ei vielä luotuja pohjamalleja…';

  @override
  String get templateDefaultTimestampTitle => 'Aikaleima';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Päivän yhteenveto';

  @override
  String get templateDefaultSummaryBody =>
      '### Yhteenveto\n- \n\n### Lainaus\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Pohdinta';

  @override
  String get templateDefaultReflectionBody =>
      '### Mistä nautit tänään?\n- \n\n### Mistä olet kiitollinen?\n- \n\n### Mitä odotat innolla?\n- ';

  @override
  String get settingsTagsTitle => 'Tunnisteet';

  @override
  String get manageTags => 'Hallitse tunnisteita';

  @override
  String get tagTypeLabelTitle => 'Tunniste';

  @override
  String get tagTypeTrackerTitle => 'Seuranta';

  @override
  String get nameHint => 'Nimi';

  @override
  String get tagColorLabel => 'Väri';

  @override
  String get iconPickerTitle => 'Valitse kuvake';

  @override
  String get iconPickerIconsTab => 'Kuvakkeet';

  @override
  String get iconPickerCustomTab => 'Mukautettu';

  @override
  String get iconPickerSearchHint => 'Hae kuvakkeita…';

  @override
  String get colorPickerTitle => 'Valitse Väri';

  @override
  String get colorPickerPaletteTab => 'värit';

  @override
  String get iconGroupMoodPeople => 'Tunnelma & Ihmiset';

  @override
  String get iconGroupHealth => 'Terveys';

  @override
  String get iconGroupWorkFinance => 'Työ & talous';

  @override
  String get iconGroupHabitsGoals => 'Tottumukset ja tavoitteet';

  @override
  String get iconGroupNature => 'Luonto';

  @override
  String get iconGroupFoodDrink => 'Ruoka & Juoma';

  @override
  String get iconGroupHome => 'Kotiin';

  @override
  String get iconGroupTravel => 'Matkustaa';

  @override
  String get iconGroupSymbols => 'Symbolit';

  @override
  String get tagCategoryLabel => 'Luokka';

  @override
  String get tagLabel => 'Tunniste';

  @override
  String get tagCategoryUncategorized => 'Luokittelematon';

  @override
  String get newCategoryTitle => 'Uusi luokka';

  @override
  String get shareButtonLabel => 'Jaa';

  @override
  String get importErrorDescription => 'Tiedoston tuonti epäonnistui!';

  @override
  String get exportErrorDescription => 'Tiedoston vienti epäonnistui!';

  @override
  String get deleteTitle => 'Poista';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Sitä käytetään $count päiväkirjamerkinnässä.',
      one: ' Sitä käytetään $count päiväkirjamerkinnässä.',
      zero: '',
    );
    return 'Poistetaanko \"$name\"?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Myös sen $count-tunnisteet poistetaan.',
      one: ' Myös sen $count-tunniste poistetaan.',
      zero: '',
    );
    return 'Poistetaanko \"$name\"?$_temp0';
  }

  @override
  String get tagNameExists => 'Tällä nimellä on jo tunniste';

  @override
  String get categoryNameExists => 'Tällä nimellä on jo luokka';

  @override
  String deleteTemplateMessage(Object name) {
    return 'Poistetaanko \"$name\"?';
  }

  @override
  String get addTagsTitle => 'Lisää tunnisteita';

  @override
  String get addTagsSearchHint => 'Hae tunnisteita…';

  @override
  String get tagsRecent => 'Viime aikoina käytetyt';

  @override
  String get tagNew => 'Uusi tunniste';

  @override
  String get tagFavoriteName => 'Suosikki';

  @override
  String get iconGroupActivities => 'Aktiviteetit';

  @override
  String get iconGroupHobbies => 'Viihde';

  @override
  String get settingsStorageTitle => 'Tallennustila';

  @override
  String get settingsLogFolder => 'Lokikansio';

  @override
  String get settingsImageFolder => 'Kuvakansio';

  @override
  String get warningTitle => 'Varoitus';

  @override
  String get logFolderWarningDescription =>
      'Jos valitussa kansiossa on jo \'aid_diary.db\'-tiedosto, sitä käytetään olemassa olevien lokien korvaamiseen!';

  @override
  String get errorTitle => 'Virhe';

  @override
  String get logFolderErrorDescription =>
      'Lokikansion vaihtaminen epäonnistui!';

  @override
  String get imageFolderErrorDescription =>
      'Kuvakansion vaihtaminen epäonnistui!';

  @override
  String get backupErrorDescription => 'Varmuuskopion luominen epäonnistui!';

  @override
  String get restoreErrorDescription =>
      'Varmuuskopion palauttaminen epäonnistui!';

  @override
  String get settingsBackupRestoreTitle => 'Varmuuskopiointi ja palautus';

  @override
  String get settingsBackup => 'Varmuuskopioi';

  @override
  String get settingsRestore => 'Palauta';

  @override
  String get settingsRestorePromptDescription =>
      'Varmuuskopion palauttaminen korvaa olemassa olevat tiedot!';

  @override
  String get settingsBackupPasswordProtect => 'Salasanasuojatut varmuuskopiot';

  @override
  String get backupEncryptedTitle => 'Salattu varmuuskopio';

  @override
  String get backupEncryptedContent =>
      'Tämä varmuuskopio on suojattu salasanalla.';

  @override
  String get settingsAutoBackup => 'Automaattiset varmuuskopiot';

  @override
  String get settingsAutoBackupLocation => 'Varmuuskopiointipaikka';

  @override
  String get settingsAutoBackupInterval => 'Varmuuskopiointiväli';

  @override
  String get settingsAutoBackupIntervalDaily => 'Päivittäin';

  @override
  String get settingsAutoBackupIntervalWeekly => 'viikoittain';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Kuukausittain';

  @override
  String get settingsAutoBackupMaxCount => 'Varmuuskopiot säilytettäväksi';

  @override
  String get settingsAutoBackupRequireCharging => 'Vain latauksen aikana';

  @override
  String settingsBackupLast(Object time) {
    return 'Viimeisin varmuuskopio $time';
  }

  @override
  String get settingsBackupNever => 'Ei koskaan varmuuskopioitu';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Seuraava varmuuskopio $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'Kaikki';

  @override
  String get autoBackupFailedTitle => 'Varmuuskopiointi epäonnistui';

  @override
  String tranferStatus(Object percent) {
    return 'Siirretään… $percent %';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Varmuuskopiota luodaan… $percent %';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Varmuuskopiota palautetaan… $percent %';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return 'Salataan varmuuskopiota… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Puretaan varmuuskopion salausta… $percent%';
  }

  @override
  String get cleanUpStatus => 'Siivotaan…';

  @override
  String get settingsExportToAnotherFormat => 'Vie toiseen muotoon';

  @override
  String get settingsExportFormatDescription =>
      'Tätä ei tule käyttää varmuuskopiona!';

  @override
  String get settingsImportFromAnotherApp => 'Tuo toisesta sovelluksesta';

  @override
  String get logFormatTitle => 'Valitse muoto';

  @override
  String get logFormatDescription =>
      'Toisen sovelluksen muoto ei välttämättä tue kaikkia ominaisuuksia. Ilmoita kaikista vioista, koska kolmansien osapuolten muodot voivat muuttua milloin tahansa. Tämä ei vaikuta olemassa oleviin lokeihin!';

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
  String get settingsDeleteAllLogsTitle => 'Poista kaikki lokit';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Haluatko poistaa kaikki lokisi?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Vahvista syöttämällä \'$prompt\'. Tätä ei voi perua!';
  }

  @override
  String get settingsAppLanguageTitle => 'Sovelluksen kieli';

  @override
  String get settingsSecurityTitle => 'Turvallisuus';

  @override
  String get settingsSecurityRequirePassword => 'Vaadi salasana';

  @override
  String get settingsSecurityEnterPassword => 'Syötä salasana';

  @override
  String get settingsSecuritySetPassword => 'Aseta salasana';

  @override
  String get settingsSecurityChangePassword => 'Vaihda salasana';

  @override
  String get settingsSecurityPassword => 'Salasana';

  @override
  String get settingsSecurityConfirmPassword => 'Vahvista salasana';

  @override
  String get settingsSecurityOldPassword => 'Vanha salasana';

  @override
  String get settingsSecurityIncorrectPassword => 'Väärä salasana';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'Salasanat eivät täsmää';

  @override
  String get requiredPrompt => 'Pakollinen';

  @override
  String get settingsSecurityBiometricUnlock =>
      'Biometrinen lukituksen avaaminen';

  @override
  String get unlockAppPrompt => 'Avaa sovelluksen lukitus';

  @override
  String get settingsAboutTitle => 'Tietoja';

  @override
  String get settingsVersion => 'Versio';

  @override
  String get settingsLicense => 'Lisenssi';

  @override
  String get licenseGPLv3 => 'GPL-v. 3.0';

  @override
  String get settingsOpenSourceLicenses => 'Avoimen lähdekoodin lisenssit';

  @override
  String get tagMoodTitle => 'Mieliala';

  @override
  String get selectTagTitle => 'Valitse Tunniste';

  @override
  String get labelPresentLabel => 'läsnä';

  @override
  String get labelAbsentLabel => 'Poissa';

  @override
  String get labelCoverageLabel => 'Kattavuus';

  @override
  String chartDistributionTitle(Object tag) {
    return '$tag Jakelu';
  }

  @override
  String get shareAddToLogPickerTitle => 'Valitse päiväkirjamerkintä';

  @override
  String get adaptiveEmptyDay => 'Ei vielä merkintöjä tälle päivälle';

  @override
  String get adaptiveNewEntry => 'Kirjoita merkintä';

  @override
  String get pageJournalTitle => 'Päiväkirja';

  @override
  String get coachPrompt1 => 'Mikä sai sinut hymyilemään tänään?';

  @override
  String get coachPrompt2 => 'Mikä on yksi asia, jonka opit tänään?';

  @override
  String get coachPrompt3 => 'Kenen kanssa puhuit tänään ja miltä se tuntui?';

  @override
  String get coachPrompt4 => 'Mistä olet kiitollinen juuri nyt?';

  @override
  String get coachPrompt5 => 'Mikä vie eniten energiaasi tänään?';

  @override
  String get coachPrompt6 => 'Kuvaile pieni hetki, jonka haluat muistaa.';

  @override
  String get coachPrompt7 => 'Mikä tekisi huomisesta hyvän päivän?';

  @override
  String get coachPrompt8 => 'Mitä on ollut mielessäsi viime aikoina?';

  @override
  String get coachPrompt9 => 'Mitä teit tänään vain itseäsi varten?';

  @override
  String get coachPrompt10 => 'Jos päivällä olisi otsikko, mikä se olisi?';

  @override
  String get pageMediaTitle => 'Media';

  @override
  String get pageAtlasTitle => 'Atlas';

  @override
  String get pageCoachTitle => 'Valmentaja';

  @override
  String get noEntrySelected => 'Ei valittuna.';

  @override
  String get entryShare => 'Jaa';

  @override
  String get entryFavorite => 'Tähti';

  @override
  String get entryEdit => 'Muokkaa';

  @override
  String get entryPrevious => 'Edellinen merkintä';

  @override
  String get entryNext => 'Seuraava merkintä';

  @override
  String get journalStories => 'Tarinoita';

  @override
  String get journalEntries => 'merkinnät';

  @override
  String get journalEmptyHint =>
      'Aloita päiväkirjasi lisäämällä uusi merkintä.';

  @override
  String get storyToday => 'Tänään';

  @override
  String get storyThrowback => 'Takaisinheitto';

  @override
  String get storyNoThrowback => 'Ei paluuta tänään';

  @override
  String get mediaFiles => 'Mediatiedostot';

  @override
  String get mediaEmpty => 'Ei kuvia vielä.';

  @override
  String get mediaEmptyHint => 'Ilmoituksiin liitetyt kuvat näkyvät täällä.';

  @override
  String get atlasEmpty => 'Ei merkintöjä sijainnilla.';

  @override
  String get atlasEmptyHint =>
      'Kirjoitukset, joissa on sijainti, näkyvät tässä.';

  @override
  String get atlasShowAll => 'Näytä kaikki merkinnät';

  @override
  String get atlasMyLocation => 'Minun sijaintini';

  @override
  String get coachAll => 'Kaikki';

  @override
  String get coachPrograms => 'Ohjelmat';

  @override
  String get coachTemplates => 'Mallit';

  @override
  String get coachKindProgram => 'Ohjelma';

  @override
  String get coachKindTemplate => 'Malli';

  @override
  String get coachNoTemplates => 'Ei ohjelmia tai malleja.';

  @override
  String get coachUseTemplate => 'Kirjoita tällä mallilla';

  @override
  String get coachProgramEverydayTitle => 'Arjen hetkiä';

  @override
  String get coachProgramEverydayDescription =>
      'Viisi lyhyttä kysymystä, yksi päivässä. Jokainen niistä kestää minuutin tai kaksi ja auttaa sinua näkemään, mikä teki päivästä sinun. Hellävarainen tapa rakentaa tapa kirjoittaa vähän joka päivä.';

  @override
  String get coachProgramReflectTitle => 'Sisäänpäin katsottuna';

  @override
  String get coachProgramReflectDescription =>
      'Yksi syvällisempi kysymys viikossa, viiden viikon ajan. Ota aikaa jokaisen kanssa: miltä sinusta on tuntunut, mikä väsyttää, mistä olet kiitollinen.';

  @override
  String get searchFilters => 'Suodattimet';

  @override
  String get searchFilterTags => 'Tunnisteet';

  @override
  String get searchFilterStarred => 'tähdellä merkitty';

  @override
  String get searchHint => 'Hae kirjoittamalla tai valitse suodatin.';

  @override
  String get locationTitle => 'Sijainti';

  @override
  String get locationName => 'Paikan nimi';

  @override
  String get locationRemove => 'Poista';

  @override
  String get locationServiceDisabled =>
      'Sijaintipalvelut on kytketty pois päältä.';

  @override
  String get locationPermissionDenied => 'Sijaintilupa evättiin.';

  @override
  String get locationUnavailable => 'Nykyistä sijaintia ei voitu hakea.';

  @override
  String get calendarJumpToToday => 'Hyppää tähän päivään';

  @override
  String get editorStartWriting => 'Aloita kirjoittaminen tai valitse a ';

  @override
  String get editorTemplateLink => 'Malli';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Valitse malli';

  @override
  String get templateFeatured => 'Suositellut mallit';

  @override
  String get templateMine => 'Omat mallit';

  @override
  String get templateDailyName => 'Päivittäinen arvostelu';

  @override
  String get templateDailyDescription =>
      'Mitä tapahtui, miltä tuntui ja mitä siitä seuraa.';

  @override
  String get templateDailyText =>
      '## Mitä tänään tapahtui\n\n\n## Miltä minusta tuntui\n\n\n## Kolme asiaa, joista olen kiitollinen\n1. \n2. \n3. \n\n## Huomenna\n';

  @override
  String get templateTravelName => 'Matkapäiväkirjamerkintä';

  @override
  String get templateTravelDescription =>
      'Paikkoja, hetkiä ja ruokaa tien varrelta.';

  @override
  String get templateTravelText =>
      '## Minne menin\n\n\n## Hetki, jonka muistan eniten\n\n\n## Mitä söin\n\n\n## Suunnitelmia huomiselle\n';

  @override
  String get templateReadingName => 'Muistiinpanojen lukeminen';

  @override
  String get templateReadingDescription =>
      'Lainauksia ja ajatuksia lukemastasi.';

  @override
  String get templateReadingText =>
      '## Kirja\n\n\n## Missä olen\n\n\n## Lainaukset\n> \n\n## Ajatukseni\n';

  @override
  String get templateWeeklyName => 'Viikkokatsaus';

  @override
  String get templateWeeklyDescription =>
      'Kohokohdat, kamppailut ja ensi viikon painopiste.';

  @override
  String get templateWeeklyText =>
      '## Kohokohdat\n\n\n## Mikä oli vaikeaa\n\n\n## Mitä opin\n\n\n## Keskity ensi viikkoon\n';

  @override
  String get entrySaveAsTemplate => 'Tallenna mallina';

  @override
  String get entrySavedAsTemplate => 'Tallennettu mallina';

  @override
  String get storyStatistics => 'Tilastot';

  @override
  String get storyMoodChart => 'Tunnelmakaavio';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return '$entries-merkinnät · $days päivää';
  }

  @override
  String get storyThisYear => 'Tänä vuonna';

  @override
  String get storyLastYear => 'Viime vuonna';

  @override
  String get storyTapToOpen => 'Avaa se napauttamalla päivää';

  @override
  String get settingsGeneralTitle => 'Kenraali';

  @override
  String get settingsDataTitle => 'Data ja tallennustila';

  @override
  String get settingsStoriesTitle => 'Tarinoita';

  @override
  String get settingsHelpTitle => 'Apua ja tietoa';

  @override
  String get weatherTitle => 'Sää';

  @override
  String get weatherClear => 'Selkeä';

  @override
  String get weatherPartlyCloudy => 'Puolipilvistä';

  @override
  String get weatherCloudy => 'Pilvistä';

  @override
  String get weatherFog => 'Sumua';

  @override
  String get weatherDrizzle => 'Tihkusadetta';

  @override
  String get weatherRain => 'Sade';

  @override
  String get weatherSnow => 'Lunta';

  @override
  String get weatherStorm => 'Ukkosmyrsky';

  @override
  String get weatherFetch => 'Hanki sää tälle merkinnälle';

  @override
  String get weatherNeedsLocation => 'Lisää ensin sijainti koordinaatteineen.';

  @override
  String get weatherUnavailable =>
      'Sää ei ole saatavilla tälle paikalle ja ajalle.';

  @override
  String get weatherRemove => 'Poista sää';

  @override
  String get weatherTemperature => 'Lämpötila';

  @override
  String get activityStill => 'Silti';

  @override
  String get activityWalking => 'Kävely';

  @override
  String get activityRunning => 'Juoksemassa';

  @override
  String get activityCycling => 'Pyöräily';

  @override
  String get activityVehicle => 'Ajoneuvossa';

  @override
  String get activityFlying => 'Lentäminen';

  @override
  String get activityExercise => 'Harjoittele';

  @override
  String get settingsAutoAddTitle => 'Lisää automaattisesti';

  @override
  String get settingsAutoAddLocation => 'Sijainti';

  @override
  String get settingsAutoAddWeather => 'Sää';

  @override
  String get settingsAutoAddHint =>
      'Uudet merkinnät täytetään, kun ne luodaan.';

  @override
  String get settingsTemperatureUnit => 'Lämpötilayksikkö';

  @override
  String get settingsCelsius => 'Celsius (°C)';

  @override
  String get settingsFahrenheit => 'Fahrenheit (°F)';

  @override
  String get moodGreat => 'Hienoa';

  @override
  String get moodGood => 'Hyvä';

  @override
  String get moodOkay => 'Okei';

  @override
  String get moodBad => 'Huono';

  @override
  String get moodAwful => 'Kamalaa';

  @override
  String get locationSearchHint => 'Etsi paikka';

  @override
  String get locationSearchEmpty => 'Paikkoja ei löytynyt';

  @override
  String get settingsWallpaper => 'Taustakuva';

  @override
  String get wallpaperNone => 'Ei mitään';

  @override
  String get wallpaperDots => 'Pisteitä';

  @override
  String get wallpaperGrid => 'Ruudukko';

  @override
  String get wallpaperLines => 'Linjat';

  @override
  String get wallpaperPhoto => 'Valokuva…';

  @override
  String get settingsFontFamily => 'Fontti';

  @override
  String get fontSystem => 'Järjestelmä';

  @override
  String get fontSerif => 'Serif';

  @override
  String get fontMono => 'Monospace';

  @override
  String get settingsFontSize => 'Fontin koko';

  @override
  String get fontSizeSmall => 'Pieni';

  @override
  String get fontSizeMedium => 'Keskikokoinen';

  @override
  String get fontSizeLarge => 'Suuri';

  @override
  String get fontSizeExtraLarge => 'Erittäin suuri';

  @override
  String get settingsLineSpacing => 'Rivivälit';

  @override
  String get lineSpacingCompact => 'Kompakti';

  @override
  String get lineSpacingNormal => 'Normaali';

  @override
  String get lineSpacingRelaxed => 'Rentoutunut';

  @override
  String get moodAssociationsTitle => 'Mikä saa minut tuntemaan…';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching $total-merkinnöistä';
  }

  @override
  String get videoRecord => 'Tallenna video';

  @override
  String get videoChoose => 'Valitse video';

  @override
  String get audioRecordTitle => 'Nauhoita äänimuistiinpano';

  @override
  String get audioChoose => 'Valitse äänitiedosto';

  @override
  String get audioStart => 'Nauhoita';

  @override
  String get audioStop => 'Pysähdy ja säästä';

  @override
  String get audioPermissionDenied =>
      'Mikrofonin käyttö on pois päältä. Salli se järjestelmäasetuksissa.';

  @override
  String get mediaTooLarge => 'Tämä video on liian suuri liitettäväksi.';

  @override
  String get mediaUnavailable =>
      'Tämä liite ei ole käytettävissä tällä laitteella.';

  @override
  String get widgetDone => 'Tämän päivän kirjoitus on kirjoitettu';

  @override
  String get widgetPending => 'Millainen päiväsi meni?';

  @override
  String get widgetWrite => 'Kirjoita';

  @override
  String get insertChecklist => 'Tarkistuslista';

  @override
  String get insertNumberedList => 'Numeroitu luettelo';

  @override
  String get insertTable => 'Taulukko';

  @override
  String get insertDivider => 'Jakaja';

  @override
  String get insertCodeBlock => 'Koodilohko';

  @override
  String get journalSortTitle => 'Lajittele merkinnät';

  @override
  String get journalSortUpdated => 'Viimeksi päivitetty';

  @override
  String get settingsTimeFormat => 'Aikamuoto';

  @override
  String get settingsDayStart =>
      'Uudet merkinnät lasketaan edellisenä päivänä asti';

  @override
  String get settingsDayAskUntil => 'Kysy sitten mihin päivään asti';

  @override
  String get settingsDayStartMidnight => 'Pois päältä';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Jokainen merkintä säilyttää päivämäärän, johon se kuuluu, kirjoitusajan vieressä, ja voit muuttaa sitä milloin tahansa editorissa. Nämä aukioloajat valitsevat vain päivän uusille merkinnöille, joten niiden muuttaminen ei siirrä olemassa olevia merkintöjä.';

  @override
  String get lateNightBadge =>
      'Kirjoitettu myöhään illalla, laskettu edellisenä päivänä';

  @override
  String editorDayAsk(String time) {
    return 'Kirjoitettu osoitteessa $time. Mille päivälle se on tarkoitettu?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (eilen)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (tänään)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'Kirjoitettu $when';
  }

  @override
  String get timeFormat12 => '12 tuntia';

  @override
  String get timeFormat24 => '24 tuntia';

  @override
  String get settingsReminderDays => 'Muistuta minua';

  @override
  String get locationRecent => 'Viimeaikaiset paikat';

  @override
  String get shareImage => 'Jaa kuva';

  @override
  String get shareSaveImage => 'Tallenna kuva';

  @override
  String get shareSaved => 'Kuva tallennettu';

  @override
  String get deletedTitle => 'Äskettäin poistettu';

  @override
  String get deletedNone => 'Mitään ei ole poistettu äskettäin';

  @override
  String deletedHint(int days) {
    return 'Poistetut merkinnät pysyvät täällä $days päivää, minkä jälkeen ne poistetaan.';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days päivää jäljellä';
  }

  @override
  String get deletedRestore => 'Palauta';

  @override
  String get deletedDeleteForever => 'Poista ikuisesti';

  @override
  String get deletedDeleteForeverDescription =>
      'Merkintä ja sen liitteet poistetaan. Tätä ei voi kumota.';

  @override
  String get deletedEmpty => 'Tyhjä';

  @override
  String get deletedEmptyDescription =>
      'Poistetaanko kaikki merkinnät äskettäin poistettu? Tätä ei voi kumota.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Satunnainen kävely';

  @override
  String get randomSubtitle => 'Avaa mennyt merkintä';

  @override
  String get randomNext => 'Toinen';

  @override
  String get randomAll => 'Kaikki';

  @override
  String get randomWithPhotos => 'Valokuvien kanssa';

  @override
  String get randomGoodDays => 'Hyviä päiviä';

  @override
  String get randomEmpty => 'Ei merkintöjä, joista valita';

  @override
  String get reviewWeekTitle => 'Tällä viikolla';

  @override
  String get reviewWeekSubtitle => 'Viikkosi tähän mennessä';

  @override
  String get reviewYearTitle => 'Tänä vuonna';

  @override
  String get reviewEmpty => 'Ei vielä kirjoitettu mitään';

  @override
  String get reviewEntries => 'merkinnät';

  @override
  String get reviewDaysWritten => 'Päivät kirjoitettu';

  @override
  String get reviewWords => 'Sanat';

  @override
  String get reviewPhotos => 'Valokuvat';

  @override
  String get reviewLongestRun => 'Päivän pisin juoksu';

  @override
  String get reviewAverageMood => 'Keskimääräinen mieliala';

  @override
  String get reviewFavorites => 'Useimmiten';

  @override
  String get reviewByMonth => 'Kuukauden mukaan';

  @override
  String get reviewHighlight => 'Korosta';

  @override
  String get yearInPixels => 'Vuosi pikseleinä';

  @override
  String get capsuleSeal => 'Tiiviste aikakapselina';

  @override
  String get capsuleTitle => 'Aikakapseli';

  @override
  String capsuleOpensOn(Object date) {
    return 'Avautuu malliin $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Kirjoitettu $date:lle';
  }

  @override
  String get capsuleOpenEarly => 'Avoinna aikaisin';

  @override
  String get capsuleOpenEarlyDescription =>
      'Kapseli avautuu nyt ja pysyy auki.';

  @override
  String get capsuleOpened => 'Aikakapseli avattu';

  @override
  String get templateMorningName => 'Aamun sivut';

  @override
  String get templateMorningDescription => 'Aseta päivä kolmessa minuutissa';

  @override
  String get templateMorningText =>
      '## Kolme asiaa, jotka haluan tehdä hyvin tänään\n1. \n2. \n3. \n\n## Jotain mitä odotan\n\n## Huomautus itselleni\n';

  @override
  String get templateEveningName => 'Iltakatsaus';

  @override
  String get templateEveningDescription => 'Päivän päätteeksi mikä meni hyvin';

  @override
  String get templateEveningText =>
      '## Kolme hyvää asiaa tänään\n1. \n2. \n3. \n\n## Mitä opin\n\n## Mikä voisi mennä paremmin huomenna\n';

  @override
  String get routineMorning => 'Hyvää huomenta';

  @override
  String get routineEvening => 'Iltakatsaus';

  @override
  String get settingsRoutinePrompts => 'Aamu- ja iltaohjeet';

  @override
  String get settingsRoutinePromptsHint =>
      'Ehdota aamu- tai iltamalli Tarinoissa';

  @override
  String get checkInTitle => 'Nopea sisäänkirjautuminen';

  @override
  String get checkInSubtitle => 'Tunnelma kahdella napautuksella';

  @override
  String get checkInMood => 'Miltä sinusta tuntuu?';

  @override
  String get checkInActivity => 'Mitä sinä teet?';

  @override
  String get checkInNote => 'Rivi siitä (valinnainen)';

  @override
  String get checkInSave => 'Tallenna';

  @override
  String editorWordCount(int words, int characters) {
    return '$words sanat · $characters merkit';
  }

  @override
  String get coachProgramEverydayTagline => 'Huomaa pienet asiat päivässä.';

  @override
  String get coachProgramReflectTagline => 'Hidasta ja kuuntele itseäsi.';

  @override
  String get coachDuration => 'Kesto';

  @override
  String get coachInterval => 'Intervalli';

  @override
  String get coachDifficulty => 'Vaikeus';

  @override
  String get coachIntervalDaily => 'Päivittäin';

  @override
  String get coachIntervalWeekly => 'viikoittain';

  @override
  String get coachDifficultyBeginner => 'Aloittelija';

  @override
  String get coachDifficultyIntermediate => 'Keskitason';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count päivää',
      one: '$count päivä',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count viikkoa',
      one: '$count viikko',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'Päivä $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Viikko $n';
  }

  @override
  String get coachEnroll => 'Ilmoittaudu mukaan';

  @override
  String get coachEndProgram => 'Lopeta ohjelma';

  @override
  String get coachAuthor => 'Tekijä';

  @override
  String get coachAuthorBio => 'Tätä sovellusta varten kirjoitetut kehotteet.';

  @override
  String get coachEnrolledTip =>
      'Kaikki valmiina! Kysymyksesi näkyvät Tarinoissa.';

  @override
  String get coachGoToStories => 'Siirry Tarinoihin';

  @override
  String get coachAnswerHint => 'Kirjoita vastauksesi…';

  @override
  String get storyWrapUp => 'Siinä kaikki tälle päivälle.';

  @override
  String get storyTapToClose => 'Sulje napauttamalla';

  @override
  String get coachAnswerDone => 'Valmis';

  @override
  String get coachAnswered => 'Vastattu, avaa napauttamalla';

  @override
  String get coachAnsweredEarlier => 'Vastattu';

  @override
  String get locationLocating => 'Haetaan…';

  @override
  String get locationPickPlace => 'Valitse paikka';

  @override
  String get locationPlacesHint => 'Paikan osoite tai nimi';

  @override
  String get locationCustom => 'Mukautettu paikka';

  @override
  String get locationCurrent => 'Nykyinen sijainti';

  @override
  String get locationSaved => 'Tallennetut paikat';

  @override
  String get locationSearchResults => 'Hakutulokset';

  @override
  String get locationNearby => 'Läheisiä paikkoja';

  @override
  String get locationRename => 'Nimeä uudelleen';

  @override
  String get locationSavePlace => 'Tallenna paikka';

  @override
  String get locationUnsavePlace => 'Poista tallennetuista paikoista';

  @override
  String get shareAs => 'Jaa nimellä…';

  @override
  String get shareAsImage => 'Kuva';

  @override
  String get shareAsZip => 'ZIP alkuperäisellä materiaalilla';

  @override
  String get shareAsPlainText => 'Pelkkää tekstiä';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Tervetuloa AID Diary:ään';

  @override
  String get onboardWelcomeText =>
      'Aloita tästä tai yhdistä tämä laite jo käyttämääsi laitteeseen.';

  @override
  String get onboardStart => 'Aloita kirjoittaminen';

  @override
  String get helpFaq => 'Usein kysytyt kysymykset';

  @override
  String get helpFaq1Q => 'Missä päiväkirjaani on tallennettu?';

  @override
  String get helpFaq1A =>
      'Päiväkirjasi on tallennettu tälle laitteelle. Se saavuttaa muut laitteet tai tallennustilan vain, kun otat synkronoinnin, jaat tai viet sen. Synkronointi on päästä päähän -salattu.';

  @override
  String get helpFaq2Q =>
      'Kuinka säilytän kopion tai siirrän uuteen laitteeseen?';

  @override
  String get helpFaq2A =>
      'Muodosta yhteys olemassa olevaan laitteeseen kohdassa Asetukset → Tiedot ja tallennus → Synkronoi ja vahvista päiväkirjasi sisältävän laitteen valtuutus. Molemmat laitteet ovat edelleen käyttökelpoisia. Voit myös luoda varmuuskopion ja palauttaa sen toiselle laitteelle.';

  @override
  String get helpFaq3Q =>
      'Voinko tuoda merkintöjä muista päiväkirjasovelluksista?';

  @override
  String get helpFaq3A =>
      'Kyllä: kohdassa Asetukset → Tiedot ja tallennus, tuo Daylio-, Diarium-, Diaro-, DayBook-, My Brain-, OneShot- ja Pixels-vienti tai JSON-vienti.';

  @override
  String get helpFaq4Q => 'Miten valmentajaohjelmat toimivat?';

  @override
  String get helpFaq4A =>
      'Ilmoittaudu ohjelmaan Valmentaja-sivulla. Joka päivä tai viikko uusi kysymys odottaa Tarinoissa; vastauksesi tallennetaan merkinnäksi.';

  @override
  String get helpFaq5Q => 'Entä jos unohdan salasanani?';

  @override
  String get helpFaq5A =>
      'Pääsykoodia ei voi palauttaa, joten pidä varmuuskopio päiväkirjastasi.';

  @override
  String get helpPrivacy => 'Yksityisyys';

  @override
  String get helpPrivacyText =>
      'Päiväkirjan sisältö ja media säilyvät tällä laitteella, ellet ota salattua synkronointia käyttöön tai jaa/vie niitä. Kartat, paikkahaku ja sää käyttävät määritettyjä palveluita ja lähettävät pyyntöön tarvittavan sijainnin tai hakukyselyn, ei päiväkirjatekstiä.';

  @override
  String get photoMetaTitle => 'Käytätkö kuvan tietoja?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Lasketaanko tämä merkintä $date:lle ja asetetaan sen tilaksi $place, kuten kuvassa on?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Lasketaanko tämä merkintä $date:lle, kun valokuva on otettu?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Asetetaanko tämän merkinnän paikkaksi $place, missä kuva on otettu?';
  }

  @override
  String get photoMetaApply => 'Käytä niitä';

  @override
  String get quickWriteTitle => 'Nopea kirjoitus';

  @override
  String get quickWriteText => 'Aloita uusi merkintä napauttamalla.';

  @override
  String get settingsQuickWriteTitle => 'Nopea kirjoitus ilmoituksiin';

  @override
  String get settingsQuickWriteDescription =>
      'Pidä ilmoitus, joka avaa uuden merkinnän.';

  @override
  String get settingsNudgesTitle => 'Työnnä minua hiljaisen venytyksen jälkeen';

  @override
  String settingsNudgesDescription(int days) {
    return 'Lempeä muistutus, kun et ole kirjoittanut $days päivään.';
  }

  @override
  String get nudgeTitle => 'Siitä on aikaa';

  @override
  String get nudgeMonday => 'Uusi viikko: mitä odotat?';

  @override
  String get nudgeTuesday => 'Kaksi riviä riittää. Miten voit tänään?';

  @override
  String get nudgeWednesday =>
      'Viikon puolivälissä. Mikä on tähän mennessä eronnut?';

  @override
  String get nudgeThursday =>
      'Onko jotain pientä säilyttämisen arvoista tältä päivältä?';

  @override
  String get nudgeFriday => 'Viikko on lopuillaan. Huomaa yksi hyvä hetki.';

  @override
  String get nudgeSaturday => 'Hidas lauantai on hyvä päivä kirjoittaa.';

  @override
  String get nudgeSunday => 'Katso taaksepäin viikkoa ennen sen päättymistä.';

  @override
  String get photoWidgetEmpty =>
      'Merkintöihin lisäämäsi valokuvat näkyvät täällä.';

  @override
  String get channelReminders => 'Muistutukset';

  @override
  String get channelOnThisDay => 'Tänä päivänä';

  @override
  String get channelCoach => 'Valmentaja kehottaa';

  @override
  String get channelNudges => 'Nyökytyksiä hiljaisten päivien jälkeen';

  @override
  String get channelQuickWrite => 'Nopea kirjoitus';

  @override
  String get channelBackup => 'Varmuuskopiot';

  @override
  String get formatJsonExport => 'JSON (AID Diary vienti)';

  @override
  String get aboutModifiedNotice =>
      'Demizon ja avustajien muokattu versio Daily Yousta. Se ei ole virallinen Daily You -sovellus.';

  @override
  String get toolbarPhotos => 'Lisää kuvia';

  @override
  String get toolbarMedia => 'Valokuvia ja videoita';

  @override
  String get mediaFromGallery => 'Valitse galleriasta';

  @override
  String get mediaFromFiles => 'Valitse tiedostoista';

  @override
  String get editorLeaveTitle => 'Tallennetaanko tämä merkintä?';

  @override
  String get editorLeaveDiscard => 'Älä säästä';

  @override
  String get editorTitleHint => 'Otsikko';

  @override
  String get editorLocating => 'Haetaan…';

  @override
  String get toolbarVideo => 'Video';

  @override
  String get toolbarAudio => 'Äänimuistiinpano';

  @override
  String get toolbarTags => 'Tunnisteet';

  @override
  String get toolbarBulletList => 'Luettelomerkitty luettelo';

  @override
  String get toolbarHeading => 'Otsikko';

  @override
  String get toolbarBold => 'Lihavoitu';

  @override
  String get toolbarItalic => 'Kursiivi';

  @override
  String get toolbarHighlight => 'Korosta';

  @override
  String get toolbarStrikethrough => 'Yliviivattu';

  @override
  String get toolbarQuote => 'Lainaus';

  @override
  String get toolbarLink => 'Linkki';

  @override
  String get toolbarInsert => 'Lisää';

  @override
  String get toolbarUndo => 'Kumoa';

  @override
  String get toolbarRedo => 'Toista';

  @override
  String get toolbarInsertDate => 'Lisää päivämäärä';

  @override
  String get toolbarInsertTime => 'Aseta aika';

  @override
  String get settingsSyncTitle => 'Pilvisynkronointi';

  @override
  String get syncOffDescription =>
      'Pidä tämä päiväkirja samana kaikilla laitteillasi Google Drive- tai WebDAV-palvelimen, kuten Nextcloudin, Synologyn tai Jianguoyunin, kautta.';

  @override
  String get syncUseGoogleDrive => 'Synkronoi Google Drive:n kanssa';

  @override
  String get syncOrWebDav => 'Tai WebDAV-palvelin';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn =>
      'Kirjautunut sisään. Voit palata sivulle AID Diary.';

  @override
  String get syncGoogleSignInAgain =>
      'Google tarvitsee sinun kirjautuvan uudelleen sisään.';

  @override
  String get syncSignInAgain => 'Kirjaudu uudelleen sisään';

  @override
  String get settingsCommandLineTitle => 'Komentorivi';

  @override
  String get commandLineToggle => 'Komentorivikäyttöliittymä';

  @override
  String get commandLineToggleHint =>
      'Antaa aid-komennon ja muiden tämän laitteen ohjelmien käyttää sovelluksen komentoja.';

  @override
  String get commandLineAlwaysOn => 'Aina kehitysvaiheessa.';

  @override
  String commandLineListening(int port) {
    return 'Kuuntele portista $port';
  }

  @override
  String get commandPaletteTitle => 'Kaikki komennot';

  @override
  String get commandPaletteSearch => 'Hakukomennot';

  @override
  String get commandPaletteRun => 'Juokse';

  @override
  String get commandPaletteConfirm =>
      'Tätä ei voi yksinkertaisesti kumota. Suorita se?';

  @override
  String syncReceiving(int done, int total) {
    return 'Vastaanotetaan $done/$total…';
  }

  @override
  String syncSending(int done, int total) {
    return 'Lähetetään $done/$total…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'Pääsyä kohteeseen Google Drive ei sallittu. Yhdistä uudelleen ja valitse Google Drive Googlen sivulla.';

  @override
  String get syncEntryUnsynced =>
      'Ei synkronoitu: viimeisin synkronointi ei mennyt läpi';

  @override
  String get syncUseOfficial => 'Käytä AID-synkronointipalvelinta';

  @override
  String get syncServer => 'Palvelimen osoite';

  @override
  String get syncUsername => 'Käyttäjätunnus';

  @override
  String get syncPassword => 'Salasana';

  @override
  String get syncConnect => 'Yhdistä';

  @override
  String get syncConnecting => 'Yhdistetään…';

  @override
  String get syncSignInFailed =>
      'Kirjautuminen ei onnistunut. Tarkista osoite, käyttäjätunnus ja salasana.';

  @override
  String syncConnectFailed(String error) {
    return 'Ei voitu yhdistää: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Aloita synkronointi';

  @override
  String get syncNewSpaceDescription =>
      'Täällä ei ole vielä synkronoitua päiväkirjaa. Tämä päiväkirja ladataan päästä päähän salattuna avaimella, joka pysyy laitteissasi.';

  @override
  String get syncJoinTitle => 'Liity synkronoituun päiväkirjaan';

  @override
  String get syncWrongKey =>
      'Tämä palautuskoodi ei avaa synkronoitua päiväkirjaa.';

  @override
  String syncLastSynced(String time) {
    return 'Viimeksi synkronoitu $time';
  }

  @override
  String get syncNever => 'Ei vielä synkronoitu';

  @override
  String get syncSyncing => 'Synkronoidaan…';

  @override
  String syncFailed(String error) {
    return 'Viimeisin synkronointi epäonnistui: $error';
  }

  @override
  String get syncLocked =>
      'Synkronoitu päiväkirja kuuluu nyt muille laitteille tai aloitettiin alusta. Muodosta laitepari yhden kanssa tai käytä palautuskoodia synkronoinnin jatkamiseen.';

  @override
  String get syncNow => 'Synkronoi nyt';

  @override
  String get syncUnlock => 'Avaa lukitus';

  @override
  String get syncEncrypted => 'Päästä päähän salattu';

  @override
  String get syncDisconnect => 'Lopeta synkronointi';

  @override
  String get syncDisconnectDescription =>
      'Tämä laite lopettaa synkronoinnin. Päiväkirja täällä ja synkronoitu kopio pysyvät ennallaan.';

  @override
  String get syncOwnRecoveryPassword => 'Käytä omaa palautussalasanaani';

  @override
  String get syncRecoveryPassword => 'Palautussalasana';

  @override
  String get syncRecoveryPasswordRepeat => 'Toista palautussalasana';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Käytä vähintään $min-merkkejä';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'Salasanat ovat erilaisia';

  @override
  String get syncRecoveryCode => 'Palautuskoodi';

  @override
  String get syncRecoveryCodeTitle => 'Tallenna palautuskoodisi';

  @override
  String get syncRecoveryCodeDescription =>
      'Jos kaikki laitteesi katoavat, tämä koodi palauttaa synkronoidun päiväkirjasi. Säilytä se salasanan hallinnassa tai paperilla. Se näytetään vain tämän kerran.';

  @override
  String get syncRecoveryCodeCopied => 'Palautuskoodi kopioitu';

  @override
  String get syncRecoveryCodeSaved => 'Olen tallentanut sen';

  @override
  String get syncJoinNeedsKey =>
      'Tämä synkronoitu päiväkirja kuuluu muille laitteillesi. Muodosta laitepari yhden kanssa tai käytä palautuskoodia. Tämän laitteen merkinnät lisätään siihen.';

  @override
  String get syncPairDevice => 'Muodosta laitepari laitteen kanssa';

  @override
  String get syncUseRecoveryCode => 'Käytä palautuskoodia';

  @override
  String get syncAddDevice => 'Lisää laite';

  @override
  String get syncChangeRecoveryCode => 'Vaihda palautuskoodi';

  @override
  String get syncChangeRecoveryDescription =>
      'Uusi koodi korvaa nykyisen, joka lakkaa toimimasta. Tietosi ja muut laitteesi pysyvät ennallaan.';

  @override
  String get syncNewRandomCode => 'Uusi satunnainen koodi';

  @override
  String get syncRecoveryCodeChanged => 'Palautuskoodi vaihdettu';

  @override
  String get syncResetSpace => 'Aloita synkronoitu päiväkirja alusta';

  @override
  String get syncResetSpaceDescription =>
      'Vain silloin, kun mikään laite tai palautuskoodi ei avaa sitä enää: synkronoitu kopio korvataan tämän laitteen päiväkirjalla tämän laitteen avainten alla. Muut laitteesi muodostaa sitten laiteparin uudelleen.';

  @override
  String get syncPairTitle => 'Yhdistä laitteet';

  @override
  String get syncPairShow => 'Näytä koodi';

  @override
  String get syncPairEnter => 'Syötä koodi';

  @override
  String get syncPairShowHint =>
      'Avaa toisella laitteellasi Yhdistä laitteet, valitse Anna koodi ja kirjoita tai skannaa tämä.';

  @override
  String get syncPairEnterHint =>
      'Kirjoita toisen laitteen näyttämä koodi tai skannaa se.';

  @override
  String get syncPairCode => 'Pariliitoskoodi';

  @override
  String get syncPairScan => 'Skannaa';

  @override
  String get syncPairStart => 'Pari';

  @override
  String get syncPairWaiting => 'Odotetaan toista laitetta…';

  @override
  String syncPairDone(String device) {
    return 'Yhdistetty $device:n kanssa';
  }

  @override
  String get syncPairWrongCode =>
      'Koodi ei täsmää. Näytä uusi koodi ja yritä uudelleen.';

  @override
  String get syncPairNoOffer =>
      'Mikään laite ei näytä tätä koodia. Se voi olla vanhentunut.';

  @override
  String get syncPairTimedOut => 'Toinen laite ei vastannut ajoissa.';

  @override
  String get syncPairNeither =>
      'Kumpaankaan laitteeseen ei ole vielä määritetty tätä synkronoitua päiväkirjaa.';

  @override
  String get syncPairBoth =>
      'Molemmat laitteet avaavat jo tämän synkronoidun päiväkirjan.';

  @override
  String syncPairFailed(String error) {
    return 'Pariliitos epäonnistui: $error';
  }

  @override
  String get syncMediaPending =>
      'Päiväkirja synkronoitu · Joitakin mediatiedostoja siirretään edelleen';

  @override
  String get syncWaitingForDevices =>
      'Päiväkirja synkronoitu · odottaa, että toinen laite siirtää mediaa';

  @override
  String get syncCacheNotice =>
      'Pilvimedia on väliaikainen. Pidä alkuperäiset laitteissasi; synkronointi ei ole varmuuskopio.';

  @override
  String get paperTitle => 'Kirjepaperi';

  @override
  String get paperPlain => 'Tavallinen';

  @override
  String get paperLined => 'Vuorattu';

  @override
  String get paperGrid => 'Ruudukko';

  @override
  String get paperTinted => 'Sävytetty';

  @override
  String get paperDecorationTitle => 'Koristeet';

  @override
  String get paperDecorationNone => 'Ei mitään';

  @override
  String get paperDecorationBotanical => 'Lehdet';

  @override
  String get paperDecorationStars => 'Tähdet';

  @override
  String get paperDecorationWashi => 'Washi teippi';

  @override
  String get themeDarkChoice => 'Tumma ulkonäkö';

  @override
  String get themeDarkSame => 'Seuraa vaaleaa palettia';

  @override
  String get themeDarkCustom => 'Erillinen paletti';

  @override
  String get themeDarkAccent => 'Tumma korostusväri';

  @override
  String get themeColorTeal => 'Sinivihreä';

  @override
  String get themeColorCyan => 'Syaani';

  @override
  String get themeColorIndigo => 'Indigo';

  @override
  String get themeColorCoral => 'koralli';

  @override
  String get themeColorOlive => 'Oliivi';

  @override
  String get themeColorSlate => 'Liuskekivi';

  @override
  String get drawingTitle => 'Piirustus';

  @override
  String get drawingPen => 'Kynä';

  @override
  String get drawingEraser => 'Pyyhekumi';

  @override
  String get drawingUndo => 'Kumoa';

  @override
  String get drawingClear => 'Selkeä';

  @override
  String get drawingWidth => 'Kynän leveys';

  @override
  String get drawingStylusOnly => 'Vain kynä';

  @override
  String get drawingDiscardTitle => 'Hylätäänkö piirros?';

  @override
  String get drawingDiscardBody => 'Tätä piirrosta ei ole tallennettu.';

  @override
  String get drawingSaveError => 'Piirustusta ei voitu tallentaa.';

  @override
  String get syncNetworkTitle => 'Verkkodiagnostiikka';

  @override
  String get syncNetworkRefresh => 'Päivitä';

  @override
  String get syncNetworkSelectedRoute => 'Nykyinen polku';

  @override
  String get syncNetworkAvailableRoutes => 'Käytettävissä olevat polut';

  @override
  String get syncNetworkSignaling => 'Laitehakemistoyhteys';

  @override
  String get syncNetworkRelayRemaining => 'Jäljellä oleva relekorvaus';

  @override
  String get syncNetworkIcePair => 'Suoran yhteyden ehdokkaat';

  @override
  String get syncNetworkPeerTrusted => 'Todennettu laite';

  @override
  String get syncNetworkNoRoute => 'Odotetaan yhteyttä';

  @override
  String get syncNetworkUnavailable => 'Diagnostiikkaa ei ole saatavilla';

  @override
  String get syncMediaCopiesTitle => 'Median toimitus ja kopiot';

  @override
  String get syncMediaPendingCount => 'Odotetaan siirtoa';

  @override
  String get syncMediaDurableCount => 'Toimitetaan henkilökohtaiseen varastoon';

  @override
  String get syncMediaTemporaryCount =>
      'Väliaikaiset tai vahvistamattomat kopiot';

  @override
  String get syncMediaReceiptExplanation =>
      'Nämä luvut kuvaavat valmiita toimituksia, eivät elossa olevien varmuuskopioiden uutta tarkastusta.';

  @override
  String get syncMediaCacheExplanation =>
      'Väliaikainen pilvimedia voi vanhentua. Säilytä alkuperäiset tai erillinen varmuuskopio.';

  @override
  String get momentsTitle => 'Valokuvan hetkiä';

  @override
  String get momentsHint =>
      'Etsi ryhmiä käyttämällä paikallisia valokuvaaikoja ja valinnaisia koordinaatteja. Valokuvat liitetään vain, kun valitset kortin.';

  @override
  String get momentsScan => 'Etsi hetkiä';

  @override
  String get momentsChooseFolder => 'Valitse valokuvakansio';

  @override
  String get momentsLocation => 'Sisällytä valokuvan sijainnit';

  @override
  String get momentsEmpty => 'Ei viimeaikaisia valokuvaryhmiä.';

  @override
  String get momentsCreate => 'Kirjoita näistä kuvista';

  @override
  String get momentsDismiss => 'Hylkää';

  @override
  String get momentsError => 'Paikallisia kuvia ei voitu lukea.';

  @override
  String get momentsCreated => 'Kuvamerkintä luotu.';

  @override
  String get momentsPermission =>
      'Salli kuvien käyttö löytääksesi paikallisia ehdotuksia.';

  @override
  String get momentsScope =>
      'Vain viimeisimmät valokuvat; enintään 500 kuvaa ja enintään 20 kuvaa kortilla.';

  @override
  String momentsPhotoCount(int count) {
    return '$count kuvia';
  }

  @override
  String get nearbyTitle => 'Yhdistä laitteet';

  @override
  String get nearbySend => 'Valtuuta toinen laite';

  @override
  String get nearbyReceive => 'Yhdistä olemassa olevaan laitteeseen';

  @override
  String get nearbyInstructions =>
      'Yhdistä molemmat laitteet samaan Wi-Fi-liittimeen tai toistensa hotspotiin. Vahvista olemassa olevan laitteen valtuutus; molemmat laitteet ovat käyttökelpoisia. Internetiä ei tarvita.';

  @override
  String get nearbyCompare =>
      'Vertaa tätä koodia molemmissa laitteissa ennen hyväksymistä.';

  @override
  String get nearbyConfirm => 'Koodit täsmäävät';

  @override
  String get nearbyScan => 'Skannaa toisen laitteen koodi';

  @override
  String get nearbyPaste => 'Liitä kutsu';

  @override
  String get nearbyWaiting => 'Odotetaan hyväksyntää toisessa laitteessa';

  @override
  String get nearbyWorking =>
      'Valtuutetaan ja synkronoidaan päiväkirjaasi ja liitteitäsi…';

  @override
  String get nearbyPending =>
      'Jotkut liitteet tarvitsevat edelleen synkronointia. Pidä toinen laite online-tilassa ja yritä uudelleen.';

  @override
  String get nearbyComplete =>
      'Laite kytketty; päiväkirja ja liitteet synkronoitu';

  @override
  String get nearbyFailed =>
      'Yhteys ei päättynyt. Tarkista paikallinen yhteys ja yritä uudelleen.';

  @override
  String get nearbyEmptyRequired =>
      'Käytä laitetta, jossa on tyhjä päiväkirja ja jota ei ole vielä yhdistetty synkronointiin.';

  @override
  String get nearbyRetry => 'Jatka synkronointia';

  @override
  String get nearbyWifi => 'Wi-Fi asetukset';

  @override
  String get nearbyHotspot => 'Hotspot-asetukset';

  @override
  String get nearbyKeepOpen =>
      'Pidä tämä sivu auki, kunnes uusi laite on valmis. Kutsu vanhenee kahden minuutin kuluttua.';

  @override
  String get syncDevicesTitle => 'Valtuutetut laitteet';

  @override
  String get syncDevicesDescription =>
      'Vain hyväksytyt laitteet voivat käyttää tätä AID-tiliä. Laitteen peruuttaminen estää palvelimen, mutta ei voi poistaa siihen jo kopioitua pääavainta tai päiväkirjaa.';

  @override
  String get syncDeviceRequest =>
      'Näytä tämä valtuutuksen QR hyväksytylle laitteelle';

  @override
  String get syncDeviceAuthorize => 'Valtuuta laite';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Skannaa tai liitä uuden laitteen valtuutuspyyntö.';

  @override
  String get syncDeviceRevoke => 'Peruuta';

  @override
  String get syncDeviceRotate => 'Kierrä tämän laitteen allekirjoitusavainta';

  @override
  String get syncDeviceCheck => 'Tarkista valtuutus';

  @override
  String get syncDeviceHardware => 'Laitteistotuettu allekirjoitusavain';

  @override
  String get syncDeviceSoftware => 'Ei-vietävä ohjelmiston allekirjoitusavain';

  @override
  String get syncDeviceUnavailable =>
      'Laitteen valtuutus ei ole käytettävissä. Hyväksy tämä laite toiselta valtuutetulta laitteelta ja yritä uudelleen.';

  @override
  String get syncDeviceRevoked => 'Peruutettu';

  @override
  String get syncDeviceLocal => 'Tämä laite';

  @override
  String get cloudTrafficTitle =>
      'Kuukausittainen pilvitietojen siirtokiintiö mediatiedostoille';

  @override
  String get cloudTrafficLimit => 'Kuukauden tiedonsiirtokiintiö';

  @override
  String get cloudTrafficUsed => 'Käytetty tiedonsiirto';

  @override
  String get cloudTrafficRemaining => 'Tiedonsiirtoa jäljellä';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'Tiedonsiirtokiintiö nollaa $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'Mediatiedostojen pilvisiirtokiintiö on käytetty loppuun. Puuttuvat mediatiedostot synkronoidaan automaattisesti, kun suora yhteys on käytettävissä tai kiintiö nollataan.';

  @override
  String get cloudTrafficExplanation =>
      'Mediatiedostojen välimuisti ja suora välitys jakavat tämän tiedonsiirtokiintiön. Suorat yhteydet eivät kuluta sitä. Päiväkirjateksteillä ja yhteydenhallintaviesteillä on erilliset pienet päivärajat.';

  @override
  String get appearanceThemeSection => 'Sovelluksen teema';

  @override
  String get appearancePaperSection => 'Päiväkirjapaperi';

  @override
  String get appearanceTypographySection => 'Päiväkirjan teksti';

  @override
  String get appearancePreferencesSection => 'Yleiset asetukset';

  @override
  String get themeSystemAccentHint =>
      'Käyttää järjestelmäpalettia mukautettujen värien sijaan. Valitse omasi sammuttamalla se.';

  @override
  String get syncDeviceNameSaveFailed =>
      'Laitteen nimeä ei voitu tallentaa. Yritä uudelleen.';

  @override
  String get nearbyConnectionHelp => 'Yhteyden apua';

  @override
  String get syncAllSynced => 'Kaikki synkronoitu';

  @override
  String get syncDetailsTitle => 'Synkronoinnin tiedot';

  @override
  String get syncMore => 'Lisää vaihtoehtoja';

  @override
  String get syncDeviceName => 'Laitteen nimi';

  @override
  String get syncDeviceNameHint => 'Esimerkiksi: Oma tabletti';

  @override
  String get syncDeviceNameInvalid => 'Käytä 1-32 merkkiä';

  @override
  String get syncDeviceKeyDetails => 'Tietoturvatiedot';

  @override
  String get syncConnectionProblem =>
      'Synkronointi ei toistaiseksi onnistu. Yritetään automaattisesti uudelleen.';

  @override
  String get syncCopyComplete =>
      'Täydellinen kopio päiväkirjastasi ja mediatiedostoistasi';

  @override
  String get syncCopyPartial => 'Osa mediasta puuttuu edelleen';

  @override
  String get syncCopyOlder => 'Uudet muutokset odottavat synkronointia';

  @override
  String get syncCopyUnavailable =>
      'Kopioinnin tiedot eivät ole saatavilla. Yritä myöhemmin uudelleen.';

  @override
  String get syncCopyLastKnown =>
      'Muut laitteet näyttävät viimeisen vahvistetun kopionsa. Offline-laitteita ei voi tarkistaa nyt.';

  @override
  String get syncCopyTemporary =>
      'Väliaikainen välimuisti. Säilytä alkuperäiset laitteissasi.';

  @override
  String get syncCopyStorage =>
      'Synkronointitallennustilasi. Valmiit medialataukset luetellaan diagnostiikassa.';

  @override
  String syncCopyChecked(String time) {
    return 'Viimeksi vahvistettu $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Tiedonsiirto jäljellä tässä kuussa: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Aloita tästä';

  @override
  String get onboardConnect => 'Yhdistä olemassa olevaan laitteeseen';

  @override
  String get onboardFailed =>
      'Asennusta ei voitu suorittaa loppuun. Päiväkirjasi on turvassa; yritä uudelleen.';

  @override
  String get tutorialTitle => 'Kuinka käyttää päiväkirjaa';

  @override
  String get tutorialWriteTitle => 'Kirjoita ensimmäinen päiväkirjamerkintäsi';

  @override
  String get tutorialWriteText =>
      'Napauta + kirjoittaaksesi päiväkirjamerkinnän. Lisää valinnainen otsikko, valitse päiväkirjan päivämäärä ja tallenna napauttamalla valintamerkkiä. Voit muokata päiväkirjamerkintää uudelleen milloin tahansa.';

  @override
  String get tutorialMediaTitle => 'Lisää kuvia, ääntä tai käsialaa';

  @override
  String get tutorialMediaText =>
      'Käytä + päiväkirjaeditorissa liittääksesi valokuvia, videoita tai äänitallenteita tai avataksesi käsinkirjoituspohjan. Nämä liitteet tallennetaan päiväkirjamerkinnällä.';

  @override
  String get tutorialReviewTitle => 'Etsi päivä uudelleen';

  @override
  String get tutorialReviewText =>
      'Selaa päiväkirjaasi tai kalenteriasi, hae kirjoituksiasi ja järjestä merkintöjä tunnisteilla. Media- ja Atlas-sivuilta löydät aiempia merkintöjä kuvan tai sijainnin mukaan.';

  @override
  String get tutorialSyncTitle => 'Käytä useampaa kuin yhtä laitetta';

  @override
  String get tutorialSyncText =>
      'Muodosta yhteys olemassa olevaan laitteeseen kohdassa Asetukset → Tiedot ja tallennus → Synkronoi ja vahvista kyseisen laitteen valtuutus. Molemmat laitteet voivat jatkaa päiväkirjan käyttöä. Päiväkirjan teksti synkronoidaan ensin. Mediatiedostot synkronoidaan seuraavaksi, kun verkkoyhteys ja jäljellä oleva tiedonsiirtokiintiö sallivat sen.';

  @override
  String get tutorialPrivacyTitle => 'Pidä päiväkirjasi turvassa';

  @override
  String get tutorialPrivacyText =>
      'Päiväkirjamerkinnät pysyvät tällä laitteella, ellet ota synkronointia käyttöön tai jaa tai vie niitä. Synkronointi on päästä päähän -salattu. Asetuksissa voit myös asettaa sovelluksen pääsykoodin, luoda varmuuskopioita ja avata tämän opetusohjelman uudelleen.';

  @override
  String get editorDiaryDay => 'Päiväkirjapäivä';

  @override
  String get editorDiaryDayPicker =>
      'Päiväkirjapäivä · Mihin päivään merkintä kuuluu?';

  @override
  String editorCreatedAt(String time) {
    return 'Luotu $time';
  }

  @override
  String get editorDiaryDayHint =>
      'Päivä, johon tämä merkintä kuuluu. Sen muuttaminen ei muuta merkinnän luontiaikaa.';

  @override
  String get hiddenDiaryTitle => 'Piilotetut merkinnät';

  @override
  String get hiddenDiaryHide => 'Piilota merkintä';

  @override
  String get hiddenDiaryShow => 'Näytä merkintä';

  @override
  String get hiddenDiaryEmpty => 'Ei piilotettuja merkintöjä';

  @override
  String get hiddenDiaryUnlock => 'Avaa piilotetut merkinnät';

  @override
  String get hiddenDiaryAuthHint =>
      'Käytä sovelluksen lukitusta tai laitteen näytön lukitusta.';

  @override
  String hiddenDiaryWhere(String path) {
    return 'Piilotettu. Näytä uudelleen kohdasta: $path';
  }

  @override
  String get noteKeep => 'Säilytä';

  @override
  String get noteComment => 'Kommentoi';

  @override
  String get noteCommentHint => 'Kirjoita menneelle itsellesi';

  @override
  String get noteKept => 'Katkelma säilytetty';

  @override
  String get notesPassages => 'Säilytetyt katkelmat';

  @override
  String get notesComments => 'Kommentit';

  @override
  String get noteDeleteConfirm => 'Poistetaanko tämä merkintä?';

  @override
  String get editPastTitle => 'Muokataanko mennyttä muistoa?';

  @override
  String get editPastBody =>
      'Tämä merkintä on aiemmalta päivältä. Vastataksesi siihen valitse tekstiä ja säilytä tai kommentoi sitä.';

  @override
  String get editPastDontAsk => 'Älä kysy uudelleen';

  @override
  String get editPastEdit => 'Muokkaa silti';

  @override
  String noteOnEntry(String date) {
    return 'Päivän $date merkinnästä';
  }

  @override
  String get settingsConfirmEditPast =>
      'Kysy ennen menneiden merkintöjen muokkaamista';

  @override
  String get settingsCompressPhotos => 'Pakkaa uudet kuvat';

  @override
  String get settingsCompressPhotosHint =>
      'Tallenna uudet kuvat noin 1 Mt:n WebP-kuvina. Pois päältä säilyttää alkuperäiset.';

  @override
  String get compressExistingTitle => 'Pakkaa nykyiset kuvat';

  @override
  String compressExistingBody(int count, String size) {
    return '$count kuvaa vie $size. Yli noin 1 Mt:n kuvat muuttuvat noin 1 Mt:n WebP-kuviksi. Ne korvataan, eikä sitä voi perua; säilytä alkuperäiset muualla, jos tarvitset niitä.';
  }

  @override
  String get compressExistingAction => 'Pakkaa';

  @override
  String compressExistingDone(int count, String size) {
    return 'Pakattiin $count kuvaa, säästettiin $size';
  }

  @override
  String get commentExpand => 'Laajenna';

  @override
  String get refAdd => 'Lainaa merkintää';

  @override
  String get refMissing => 'Merkintää ei ole enää';

  @override
  String get moodClear => 'Poista mieliala';

  @override
  String get scrollToTop => 'Takaisin alkuun';

  @override
  String get feedbackTitle => 'Palaute';

  @override
  String get feedbackHint => 'Kuvaile ongelma tai ehdotus';

  @override
  String get feedbackSend => 'Lähetä';

  @override
  String get feedbackSent => 'Kiitos, palautteesi lähetettiin.';

  @override
  String get feedbackSendFailed =>
      'Lähetys epäonnistui. Tarkista yhteys ja yritä uudelleen.';

  @override
  String get feedbackOpenFailed => 'Sovellusta ei voitu avata.';

  @override
  String get feedbackSendNote =>
      'Lähetetään AID Diaryn palvelimelle sovelluksen version ja kielen kanssa, ei mitään päiväkirjastasi.';

  @override
  String get feedbackGithub => 'GitHub-ongelma';

  @override
  String get feedbackEmail => 'Lähetä sähköposti';

  @override
  String updateAvailable(String version) {
    return 'AID Diary $version on saatavilla';
  }

  @override
  String get updateClosesNote =>
      'Sovellus sulkeutuu päivityksen asennuksen ajaksi; avaa se sen jälkeen uudelleen.';

  @override
  String get updateLater => 'Myöhemmin';

  @override
  String get updateSkip => 'Ohita tämä versio';

  @override
  String get updateInstall => 'Päivitä';

  @override
  String updateDownloading(int percent) {
    return 'Ladataan… $percent %';
  }

  @override
  String get updateAllowInstall =>
      'Salli avautuneissa asetuksissa AID Diaryn asentaa sovelluksia ja napauta sitten Päivitä uudelleen.';

  @override
  String updateFailed(String reason) {
    return 'Päivitystä ei voitu asentaa: $reason';
  }

  @override
  String updatedTo(String version) {
    return 'Päivitetty versioon $version';
  }

  @override
  String get updateWhatsNew => 'Uutta';

  @override
  String get updateCheckNow => 'Tarkista päivitykset';

  @override
  String get updateNewest => 'Tämä on uusin versio.';

  @override
  String get updateAutoCheck => 'Tarkista päivitykset automaattisesti';

  @override
  String get updateSilent => 'Asenna päivitykset kysymättä';

  @override
  String get updateSilentHint =>
      'Lataa taustalla ja asentaa, kun poistut sovelluksesta. Android kysyy kerran, ensimmäisellä kerralla.';
}
