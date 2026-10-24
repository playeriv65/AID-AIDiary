// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => 'Tema rengi';

  @override
  String get themeColorHint => 'Bu palet için bir renk seçin.';

  @override
  String get themeColorBlue => 'Gök mavisi';

  @override
  String get themeColorGreen => 'Orman yeşili';

  @override
  String get themeColorBrown => 'Sıcak kahve';

  @override
  String get themeColorPurple => 'lavanta';

  @override
  String get themeColorRose => 'Tozlu gül';

  @override
  String get themeColorAmber => 'kehribar';

  @override
  String get themeColorPreview => 'Her gün biraz';

  @override
  String get themeTintBackgroundTitle =>
      'Arka planları tema rengiyle renklendirin';

  @override
  String get themeTintBackgroundHint =>
      'Nötr gri arka planlar için kapatın; düğmeler seçtiğiniz rengi korur.';

  @override
  String get dailyReminderTitle => 'Bugünü Kayıtla!';

  @override
  String get dailyReminderDescription => 'Günlük kaydı oluştur…';

  @override
  String get actionTakePhoto => 'Fotoğraf çek';

  @override
  String get flashbacksTitle => 'Geçmiş';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Kötü günleri çıkar';

  @override
  String get flashbackGoodDay => 'İyi Bir Gün';

  @override
  String get flashbackRandomDay => 'Rastgele Bir Gün';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hafta önce',
      one: '$count hafta önce',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ay önce',
      one: '$count ay önce',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yıl önce',
      one: '$count yıl önce',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'Bu Günde';

  @override
  String get searchLogsHint => 'Kayıt Ara…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kayıt',
      one: '$count kayıt',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün',
      one: '$count gün',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sözcük',
      one: '$count sözcük',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Kayıt yok…';

  @override
  String get noResults => 'Sonuç Yok…';

  @override
  String get sortOrderAscendingTitle => 'Artan';

  @override
  String get sortOrderDescendingTitle => 'Azalan';

  @override
  String get pageStatisticsTitle => 'Sayımlama';

  @override
  String get statisticsNotEnoughData => 'Yeterli veri yok…';

  @override
  String get statisticsRangeOneMonth => '1 ay';

  @override
  String get statisticsRangeSixMonths => '6 ay';

  @override
  String get statisticsRangeOneYear => '1 yıl';

  @override
  String get statisticsRangeAllTime => 'Tüm Zamanlar';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag Özeti';
  }

  @override
  String chartByDayTitle(Object tag) {
    return 'Günlük $tag';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag Zaman İçerisinde';
  }

  @override
  String get chartGroupingLabel => 'Gruplama ölçütü';

  @override
  String get chartGroupingDay => 'Gün';

  @override
  String get chartGroupingWeek => 'Hafta';

  @override
  String get chartGroupingMonth => 'Ay';

  @override
  String get chartGroupingYear => 'Yıl';

  @override
  String get chartSmoothingLabel => 'Düzeltme';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mevcut seri $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'En uzun seri $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Harika Günler $count',
      one: 'Harika Günler $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Geçen son kötü gün $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Harici Depolamaya Erişilemiyor';

  @override
  String get errorExternalStorageAccessDescription =>
      'Ağ depolama alanını kullanıyorsanız, hizmetin çevrim içi olduğundan ve ağ erişiminiz olduğundan emin olun.\n\nAksi takdirde, uygulama harici klasör için izinleri kaybetmiş olabilir. Ayarlara gidin ve erişim vermek için harici klasörü yeniden seçin.\n\nUyarı, harici depolama konumuna erişimi geri yükleyene kadar değişiklikler eşlenemeyecektir!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Yerel Veri Tabanı ile Devam Edin';

  @override
  String get lastModified => 'Değişiklik';

  @override
  String get writeSomethingHint => 'Bir şeyler yaz…';

  @override
  String get titleHint => 'Başlık…';

  @override
  String get deleteLogTitle => 'Kaydı Sil';

  @override
  String get deleteLogDescription => 'Bu kaydı silmek istiyor musunuz?';

  @override
  String get deletePhotoTitle => 'Fotoğrafı Sil';

  @override
  String get deletePhotoDescription => 'Bu fotoğrafı silmek istiyor musunuz?';

  @override
  String get pageSettingsTitle => 'Ayarlar';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Aydınlık';

  @override
  String get themeDark => 'Karanlık';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Haftanın İlk Günü';

  @override
  String get settingsCalendarSystem => 'Takvim Sistemi';

  @override
  String get calendarSystemGregorian => 'Miladi';

  @override
  String get calendarSystemJalali => 'Celali';

  @override
  String get settingsUseSystemAccentColor => 'Sistem Vurgu Rengini Kullan';

  @override
  String get settingsCustomAccentColor => 'Özel Vurgu Rengi';

  @override
  String get settingsShowFlashbacks => 'Bilgi Kartlarını Göster';

  @override
  String get settingsChangeMoodIcons => 'Ruh Hali Simgelerini Değiştir';

  @override
  String get moodIconPrompt => 'Bir simge belirleyin';

  @override
  String get settingsHideImages => 'Resimleri Gizle';

  @override
  String get pageCalendarTitle => 'Takvim';

  @override
  String get settingsNotificationsTitle => 'Bildirimler';

  @override
  String get settingsDailyReminderTitle => 'Günlük Hatırlatma';

  @override
  String get settingsOnThisDayDescription => 'Geçmiş anılarını ziyaret et';

  @override
  String get settingsDailyReminderDescription => 'Her gün nazik bir hatırlatma';

  @override
  String get settingsReminderTime => 'Hatırlatma Zamanı';

  @override
  String get settingsFixedReminderTimeTitle => 'Sabit Hatırlatma Zamanı';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Hatırlatma için sabit bir zaman seçin';

  @override
  String get settingsAlwaysSendReminderTitle => 'Daima Hatırlatma Gönder';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Bir kayıt açılmış olsa bile hatırlatma gönder';

  @override
  String get settingsCustomizeNotificationTitle => 'Bildirimleri Özelleştirin';

  @override
  String get settingsTemplatesTitle => 'Şablonlar';

  @override
  String get manageTemplates => 'Şablonları Yönet';

  @override
  String get noTemplateTitle => 'Hiçbiri';

  @override
  String get noTemplatesDescription => 'Henüz şablon oluşturulmadı…';

  @override
  String get templateDefaultTimestampTitle => 'Zaman Damgası';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Gün Özeti';

  @override
  String get templateDefaultSummaryBody =>
      '### Gün özeti\n- \n\n### Alıntı\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Yansıma';

  @override
  String get templateDefaultReflectionBody =>
      '### Bugün hakkında neyi sevdiniz?\n- \n\n### Ne için şükrediyorsunuz?\n- \n\n### Neyi dört gözle bekliyorsunuz?\n- ';

  @override
  String get settingsTagsTitle => 'Etiketler';

  @override
  String get manageTags => 'Etiketleri Yönet';

  @override
  String get tagTypeLabelTitle => 'Etiket';

  @override
  String get tagTypeTrackerTitle => 'İzleyici';

  @override
  String get nameHint => 'İsim';

  @override
  String get tagColorLabel => 'Renk';

  @override
  String get iconPickerTitle => 'Simge Seç';

  @override
  String get iconPickerIconsTab => 'Simgeler';

  @override
  String get iconPickerCustomTab => 'Özel';

  @override
  String get iconPickerSearchHint => 'Simge ara…';

  @override
  String get colorPickerTitle => 'Renk Seç';

  @override
  String get colorPickerPaletteTab => 'Renkler';

  @override
  String get iconGroupMoodPeople => 'Ruh Hâli & İnsanlar';

  @override
  String get iconGroupHealth => 'Sağlık';

  @override
  String get iconGroupWorkFinance => 'İş & Finans';

  @override
  String get iconGroupHabitsGoals => 'Alışkanlıklar & Hedefler';

  @override
  String get iconGroupNature => 'Doğa';

  @override
  String get iconGroupFoodDrink => 'Yemek & İçecek';

  @override
  String get iconGroupHome => 'Ev';

  @override
  String get iconGroupTravel => 'Yolculuk';

  @override
  String get iconGroupSymbols => 'Semboller';

  @override
  String get tagCategoryLabel => 'Kategori';

  @override
  String get tagLabel => 'Etiket';

  @override
  String get tagCategoryUncategorized => 'Kategori edilmemiş';

  @override
  String get newCategoryTitle => 'Yeni Kategori';

  @override
  String get shareButtonLabel => 'Paylaş';

  @override
  String get importErrorDescription => 'Dosya içe aktarılamadı!';

  @override
  String get exportErrorDescription => 'Dosya dışa aktarılamadı!';

  @override
  String get deleteTitle => 'Sil';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' $count günlük girişinde kullanılır.',
      one: ' $count günlük girişinde kullanılır.',
      zero: '',
    );
    return '\"$name\" silinsin mi?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' $count etiketi de silinecek.',
      one: ' $count etiketi de silinecek.',
      zero: '',
    );
    return '\"$name\" silinsin mi?$_temp0';
  }

  @override
  String get tagNameExists => 'Bu isimde bir etiket zaten var';

  @override
  String get categoryNameExists => 'Bu isimde bir kategori zaten var';

  @override
  String deleteTemplateMessage(Object name) {
    return '\"$name\" silinsin mi?';
  }

  @override
  String get addTagsTitle => 'Etiketler Ekle';

  @override
  String get addTagsSearchHint => 'Etiketleri ara…';

  @override
  String get tagFavoriteName => 'Favori';

  @override
  String get iconGroupActivities => 'Aktiviteler';

  @override
  String get iconGroupHobbies => 'Eğlence';

  @override
  String get settingsStorageTitle => 'Depolama';

  @override
  String get settingsImageQuality => 'Görüntü Kalitesi';

  @override
  String get imageQualityHigh => 'Yüksek';

  @override
  String get imageQualityMedium => 'Orta';

  @override
  String get imageQualityLow => 'Düşük';

  @override
  String get imageQualityNoCompression => 'Sıkıştırmadan';

  @override
  String get settingsLogFolder => 'Kayıt Klasörü';

  @override
  String get settingsImageFolder => 'Görüntü Klasörü';

  @override
  String get warningTitle => 'Uyarı';

  @override
  String get logFolderWarningDescription =>
      'Seçilen klasör zaten bir \'aid_diary.db\' dosyası içeriyorsa, mevcut günlüklerinizin üzerine yazmak için kullanılacaktır!';

  @override
  String get errorTitle => 'Hata';

  @override
  String get logFolderErrorDescription => 'Günlük klasörü değiştirilemedi!';

  @override
  String get imageFolderErrorDescription => 'Görüntü klasörü değiştirilemedi!';

  @override
  String get backupErrorDescription => 'Yedekleme oluşturulamadı!';

  @override
  String get restoreErrorDescription => 'Yedekleme geri yüklenemedi!';

  @override
  String get settingsBackupRestoreTitle => 'Yedekleme ve Geri yükleme';

  @override
  String get settingsBackup => 'Yedekle';

  @override
  String get settingsRestore => 'Geri yükleme';

  @override
  String get settingsRestorePromptDescription =>
      'Bir yedeklemeyi geri yüklemek mevcut verilerinizin üzerine yazacaktır!';

  @override
  String get settingsBackupPasswordProtect => 'Yedeklemeleri Parola Korumalı';

  @override
  String get backupEncryptedTitle => 'Şifreli Yedekleme';

  @override
  String get backupEncryptedContent => 'Bu yedekleme şifre korumalıdır.';

  @override
  String get settingsAutoBackup => 'Otomatik Yedeklemeler';

  @override
  String get settingsAutoBackupLocation => 'Yedekleme Konumu';

  @override
  String get settingsAutoBackupInterval => 'Yedekleme Aralığı';

  @override
  String get settingsAutoBackupIntervalDaily => 'Günlük';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Haftalık';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Aylık';

  @override
  String get settingsAutoBackupMaxCount => 'Saklanacak Yedeklemeler';

  @override
  String get settingsAutoBackupRequireCharging => 'Yalnızca Şarj Ederken';

  @override
  String settingsBackupLast(Object time) {
    return 'Son yedekleme $time';
  }

  @override
  String get settingsBackupNever => 'Hiçbir zaman yedeklenmedi';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Sonraki yedekleme $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'Hepsi';

  @override
  String get autoBackupFailedTitle => 'Yedekleme Başarısız';

  @override
  String tranferStatus(Object percent) {
    return 'Aktarılıyor… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Yedekleme Oluşturuluyor… $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Yedekleme Geri Yükleniyor… $percent%';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return 'Yedekleme Şifreleniyor… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Yedeklemenin şifresi çözülüyor… $percent%';
  }

  @override
  String get cleanUpStatus => 'Temizleniyor…';

  @override
  String get settingsExportToAnotherFormat => 'Başka Bir Formatta Dışarı Aktar';

  @override
  String get settingsExportFormatDescription =>
      'Bu yedek olarak kullanılmamalıdır!';

  @override
  String get settingsImportFromAnotherApp => 'Başka Bir Uygulamadan İçe Aktar';

  @override
  String get logFormatTitle => 'Biçim Seçin';

  @override
  String get logFormatDescription =>
      'Başka bir uygulamanın formatı tüm özellikleri desteklemeyebilir. Üçüncü taraf formatlar her an değişebileceğinden dolayı lütfen herhangi bir sorunu bildirin. Bu mevcut günlükleri etkilemez!';

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
  String get formatOneShot => 'Tek çekim';

  @override
  String get formatPixels => 'Pixels';

  @override
  String get formatMarkdown => 'Markdown';

  @override
  String get settingsDeleteAllLogsTitle => 'Tüm Kayıtları Sil';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Tüm kayıtlarınızı silmek istiyor musunuz?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Onaylamak için \'$prompt\' girin. Bu geri alınamaz!';
  }

  @override
  String get settingsAppLanguageTitle => 'Uygulama Dili';

  @override
  String get settingsSecurityTitle => 'Güvenlik';

  @override
  String get settingsSecurityRequirePassword => 'Şifre Gerektir';

  @override
  String get settingsSecurityEnterPassword => 'Şifre Gir';

  @override
  String get settingsSecuritySetPassword => 'Şifre Belirle';

  @override
  String get settingsSecurityChangePassword => 'Şifre Değiştir';

  @override
  String get settingsSecurityPassword => 'Şifre';

  @override
  String get settingsSecurityConfirmPassword => 'Şifreyi Doğrula';

  @override
  String get settingsSecurityOldPassword => 'Eski Şifre';

  @override
  String get settingsSecurityIncorrectPassword => 'Yanlış Şifre';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'Şifreler eşleşmiyor';

  @override
  String get requiredPrompt => 'Gerekli';

  @override
  String get settingsSecurityBiometricUnlock => 'Biyometrik Açma';

  @override
  String get unlockAppPrompt => 'Uygulamayı aç';

  @override
  String get settingsAboutTitle => 'Hakkında';

  @override
  String get settingsVersion => 'Sürüm';

  @override
  String get settingsLicense => 'Lisans';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsOpenSourceLicenses => 'Açık Kaynak Lisansları';

  @override
  String get tagMoodTitle => 'Ruh hâli';

  @override
  String get selectTagTitle => 'Etiket Seç';

  @override
  String get labelPresentLabel => 'Şimdi';

  @override
  String get labelAbsentLabel => 'yok';

  @override
  String get labelCoverageLabel => 'Kapsam';

  @override
  String chartDistributionTitle(Object tag) {
    return '$tag Dağıtımı';
  }

  @override
  String get shareAddToLogPickerTitle => 'Bir günlük girişi seçin';

  @override
  String get adaptiveEmptyDay => 'Bu gün için henüz giriş yok';

  @override
  String get adaptiveNewEntry => 'Bir giriş yazın';

  @override
  String get pageJournalTitle => 'Günlük';

  @override
  String get coachPrompt1 => 'Bugün seni ne güldürdü?';

  @override
  String get coachPrompt2 => 'Bugün öğrendiğin bir şey nedir?';

  @override
  String get coachPrompt3 => 'Bugün kiminle konuştunuz ve nasıl hissettiniz?';

  @override
  String get coachPrompt4 => 'Şu anda neye minnettarsınız?';

  @override
  String get coachPrompt5 => 'Bugün enerjinizin çoğunu ne aldı?';

  @override
  String get coachPrompt6 => 'Hatırlamak istediğiniz küçük bir anı anlatın.';

  @override
  String get coachPrompt7 => 'Yarının güzel bir gün olmasını ne sağlar?';

  @override
  String get coachPrompt8 => 'Son zamanlarda aklınızdan neler geçiyor?';

  @override
  String get coachPrompt9 => 'Bugün sadece kendin için ne yaptın?';

  @override
  String get coachPrompt10 => 'Bugünün bir başlığı olsaydı ne olurdu?';

  @override
  String get pageMediaTitle => 'Medya';

  @override
  String get pageAtlasTitle => 'Atlası';

  @override
  String get pageCoachTitle => 'Antrenör';

  @override
  String get noEntrySelected => 'Hiçbir giriş seçilmedi.';

  @override
  String get entryShare => 'Paylaş';

  @override
  String get entryFavorite => 'Yıldız';

  @override
  String get entryEdit => 'Düzenle';

  @override
  String get entryPrevious => 'Önceki giriş';

  @override
  String get entryNext => 'Sonraki giriş';

  @override
  String get journalStories => 'Hikayeler';

  @override
  String get journalEntries => 'Girişler';

  @override
  String get journalEmptyHint =>
      'Günlüğünüze yeni bir giriş ekleyerek başlayın.';

  @override
  String get storyToday => 'Bugün';

  @override
  String get storyThrowback => 'Gerileme';

  @override
  String get storyNoThrowback => 'Bugün geri dönüş yok';

  @override
  String get mediaFiles => 'Medya dosyaları';

  @override
  String get mediaEmpty => 'Henüz fotoğraf yok.';

  @override
  String get mediaEmptyHint =>
      'Girişlere eklenen fotoğraflar burada gösterilecektir.';

  @override
  String get atlasEmpty => 'Konum içeren giriş yok.';

  @override
  String get atlasEmptyHint => 'Konum içeren girişler burada gösterilecektir.';

  @override
  String get atlasShowAll => 'Tüm girişleri göster';

  @override
  String get atlasMyLocation => 'Konumum';

  @override
  String get coachAll => 'Hepsi';

  @override
  String get coachPrograms => 'Programlar';

  @override
  String get coachTemplates => 'Şablonlar';

  @override
  String get coachKindProgram => 'programı';

  @override
  String get coachKindTemplate => 'Şablon';

  @override
  String get coachNoTemplates => 'Program veya şablon yok.';

  @override
  String get coachUseTemplate => 'Bu şablonla yaz';

  @override
  String get coachProgramEverydayTitle => 'Gündelik anlar';

  @override
  String get coachProgramEverydayDescription =>
      'Günde bir tane olmak üzere beş kısa soru. Her biri bir veya iki dakikanızı alır ve günü sizin yapan şeyin ne olduğunu görmenize yardımcı olur. Her gün biraz yazma alışkanlığı kazanmanın nazik bir yolu.';

  @override
  String get coachProgramReflectTitle => 'İçeriye bakmak';

  @override
  String get coachProgramReflectDescription =>
      'Beş hafta boyunca her hafta daha derin bir soru. Her birine zaman ayırın: nasıl hissettiğiniz, sizi ne yıpratır, ne için minnettarsınız.';

  @override
  String get searchFilters => 'Filtreler';

  @override
  String get searchFilterTags => 'Etiketler';

  @override
  String get searchFilterStarred => 'Yıldızlı';

  @override
  String get searchHint => 'Aramak için yazın veya bir filtre seçin.';

  @override
  String get locationTitle => 'Konum';

  @override
  String get locationName => 'Yer adı';

  @override
  String get locationRemove => 'Kaldır';

  @override
  String get locationServiceDisabled => 'Konum hizmetleri kapalı.';

  @override
  String get locationPermissionDenied => 'Konum izni reddedildi.';

  @override
  String get locationUnavailable => 'Geçerli konum alınamadı.';

  @override
  String get calendarJumpToToday => 'Bugüne atla';

  @override
  String get editorStartWriting => 'Yazmaya başlayın veya bir tane seçin ';

  @override
  String get editorTemplateLink => 'Şablon';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Bir şablon seçin';

  @override
  String get templateFeatured => 'Öne çıkan şablonlar';

  @override
  String get templateMine => 'Şablonlarım';

  @override
  String get templateDailyName => 'Günlük inceleme';

  @override
  String get templateDailyDescription =>
      'Ne oldu, nasıl hissettirdi ve bundan sonra ne olacak?';

  @override
  String get templateDailyText =>
      '## Bugün ne oldu\n\n\n## Nasıl hissettim\n\n\n## Minnettar olduğum üç şey\n1. \n2. \n3. \n\n## Yarın\n';

  @override
  String get templateTravelName => 'Seyahat günlüğü girişi';

  @override
  String get templateTravelDescription => 'Yoldan yerler, anlar ve yiyecekler.';

  @override
  String get templateTravelText =>
      '## Nereye gittim\n\n\n## En çok hatırladığım an\n\n\n## Ne yedim\n\n\n## Yarın için planlar\n';

  @override
  String get templateReadingName => 'Notları okuma';

  @override
  String get templateReadingDescription =>
      'Okuduklarınızdan alıntılar ve düşünceler.';

  @override
  String get templateReadingText =>
      '## Kitap\n\n\n## Neredeyim\n\n\n## Alıntılar\n> \n\n## Düşüncelerim\n';

  @override
  String get templateWeeklyName => 'Haftalık inceleme';

  @override
  String get templateWeeklyDescription =>
      'Önemli noktalar, mücadeleler ve gelecek haftanın odak noktası.';

  @override
  String get templateWeeklyText =>
      '## Öne Çıkanlar\n\n\n## Ne zordu\n\n\n## Ne öğrendim\n\n\n## Gelecek haftaya odaklanın\n';

  @override
  String get entrySaveAsTemplate => 'Şablon olarak kaydet';

  @override
  String get entrySavedAsTemplate => 'Şablon olarak kaydedildi';

  @override
  String get storyStatistics => 'İstatistikler';

  @override
  String get storyMoodChart => 'Ruh hali tablosu';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return '$entries girişleri · $days gün sayısı';
  }

  @override
  String get storyThisYear => 'Bu yıl';

  @override
  String get storyLastYear => 'Geçen yıl';

  @override
  String get storyTapToOpen => 'Açmak için bir güne dokunun';

  @override
  String get settingsGeneralTitle => 'Genel';

  @override
  String get settingsDataTitle => 'Veri ve depolama';

  @override
  String get settingsStoriesTitle => 'Hikayeler';

  @override
  String get settingsHelpTitle => 'Yardım ve hakkında';

  @override
  String get weatherTitle => 'Hava Durumu';

  @override
  String get weatherClear => 'Temizle';

  @override
  String get weatherPartlyCloudy => 'Parçalı bulutlu';

  @override
  String get weatherCloudy => 'Bulutlu';

  @override
  String get weatherFog => 'Sis';

  @override
  String get weatherDrizzle => 'Çiseleyen yağmur';

  @override
  String get weatherRain => 'Yağmur';

  @override
  String get weatherSnow => 'Kar';

  @override
  String get weatherStorm => 'Fırtına';

  @override
  String get weatherFetch => 'Bu giriş için hava durumunu alın';

  @override
  String get weatherNeedsLocation =>
      'Önce koordinatları olan bir konum ekleyin.';

  @override
  String get weatherUnavailable =>
      'Hava durumu bu yer ve zaman için kullanılamıyor.';

  @override
  String get weatherRemove => 'Hava durumunu kaldır';

  @override
  String get activityTitle => 'Etkinlik';

  @override
  String get activityStill => 'Hala';

  @override
  String get activityWalking => 'Yürüyüş';

  @override
  String get activityRunning => 'Koşu';

  @override
  String get activityCycling => 'Bisiklete binme';

  @override
  String get activityVehicle => 'Bir araçta';

  @override
  String get activityFlying => 'Uçmak';

  @override
  String get activityExercise => 'Egzersiz';

  @override
  String get activityDetect => 'Mevcut aktiviteyi tespit et';

  @override
  String get activityDetectFailed => 'Bir etkinlik algılanamadı.';

  @override
  String get activityRemove => 'Etkinliği kaldır';

  @override
  String get settingsAutoAddTitle => 'Otomatik olarak ekle';

  @override
  String get settingsAutoAddLocation => 'Konum';

  @override
  String get settingsAutoAddWeather => 'Hava Durumu';

  @override
  String get settingsAutoAddHint =>
      'Yeni girişler oluşturulduklarında bu bilgiler doldurulur.';

  @override
  String get settingsTemperatureUnit => 'Sıcaklık birimi';

  @override
  String get settingsCelsius => 'Santigrat (°C)';

  @override
  String get settingsFahrenheit => 'Fahrenhayt (°F)';

  @override
  String get moodGreat => 'Harika';

  @override
  String get moodGood => 'iyi';

  @override
  String get moodOkay => 'tamam';

  @override
  String get moodBad => 'Kötü';

  @override
  String get moodAwful => 'Berbat';

  @override
  String get locationSearchHint => 'Bir yer arayın';

  @override
  String get locationSearchEmpty => 'Hiçbir yer bulunamadı';

  @override
  String get settingsWallpaper => 'Duvar kağıdı';

  @override
  String get wallpaperNone => 'Yok';

  @override
  String get wallpaperDots => 'Noktalar';

  @override
  String get wallpaperGrid => 'Izgara';

  @override
  String get wallpaperLines => 'çizgiler';

  @override
  String get wallpaperPhoto => 'Fotoğraf…';

  @override
  String get settingsFontFamily => 'Yazı tipi';

  @override
  String get fontSystem => 'Sistem';

  @override
  String get fontSerif => 'Serif';

  @override
  String get fontMono => 'Tek uzay';

  @override
  String get settingsFontSize => 'Yazı tipi boyutu';

  @override
  String get fontSizeSmall => 'Küçük';

  @override
  String get fontSizeMedium => 'Orta';

  @override
  String get fontSizeLarge => 'Büyük';

  @override
  String get fontSizeExtraLarge => 'Ekstra büyük';

  @override
  String get settingsLineSpacing => 'Satır aralığı';

  @override
  String get lineSpacingCompact => 'Kompakt';

  @override
  String get lineSpacingNormal => 'Normal';

  @override
  String get lineSpacingRelaxed => 'Rahat';

  @override
  String get moodAssociationsTitle => 'Bana neler hissettiriyor…';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$total girişlerinin $matching\'si';
  }

  @override
  String get videoRecord => 'Video kaydetme';

  @override
  String get videoChoose => 'Bir video seçin';

  @override
  String get audioRecordTitle => 'Sesli not kaydetme';

  @override
  String get audioChoose => 'Bir ses dosyası seçin';

  @override
  String get audioStart => 'Kayıt';

  @override
  String get audioStop => 'Durdur ve kaydet';

  @override
  String get audioPermissionDenied =>
      'Mikrofon erişimi kapalı. Sistem ayarlarında buna izin verin.';

  @override
  String get mediaTooLarge => 'Bu video eklenemeyecek kadar büyük.';

  @override
  String get mediaUnavailable => 'Bu eklenti bu cihazda mevcut değil.';

  @override
  String get widgetDone => 'Bugünün yazısı yazıldı';

  @override
  String get widgetPending => 'Günün nasıldı?';

  @override
  String get widgetWrite => 'Yaz';

  @override
  String get insertChecklist => 'Kontrol listesi';

  @override
  String get insertNumberedList => 'Numaralı liste';

  @override
  String get insertTable => 'Tablo';

  @override
  String get insertDivider => 'Bölücü';

  @override
  String get insertCodeBlock => 'Kod bloğu';

  @override
  String get journalSortTitle => 'Girişleri sırala';

  @override
  String get journalSortUpdated => 'Son güncelleme';

  @override
  String get settingsTimeFormat => 'Zaman formatı';

  @override
  String get settingsDayStart =>
      'Yeni girişler bir önceki gün için şu tarihe kadar sayılır:';

  @override
  String get settingsDayAskUntil => 'Sonra hangi güne kadar olduğunu sorun';

  @override
  String get settingsDayStartMidnight => 'Kapalı';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Her giriş, yazıldığı zamanın yanındaki ait olduğu günü tutar ve o günü istediğiniz zaman editörden değiştirebilirsiniz. Bu saatler yalnızca yeni girişler için günü seçer, bu nedenle bunları değiştirmek mevcut girişi değiştirmez.';

  @override
  String get lateNightBadge => 'Gece geç saatte yazıldı, bir gün önce sayıldı';

  @override
  String editorDayAsk(String time) {
    return '$time\'de yazılmıştır. Hangi gün için?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (dün)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (bugün)';
  }

  @override
  String editorWrittenAt(String when) {
    return '$when yazıldı';
  }

  @override
  String get timeFormat12 => '12 saatlik';

  @override
  String get timeFormat24 => '24 saat';

  @override
  String get settingsReminderDays => 'Bana hatırlat';

  @override
  String get locationRecent => 'Son yerler';

  @override
  String get shareImage => 'Resmi paylaş';

  @override
  String get shareSaveImage => 'Resmi kaydet';

  @override
  String get shareSaved => 'Resim kaydedildi';

  @override
  String get deletedTitle => 'Yakın zamanda silindi';

  @override
  String get deletedNone => 'Yakın zamanda silinen hiçbir şey yok';

  @override
  String deletedHint(int days) {
    return 'Silinen girişler $days gün boyunca burada kalır, ardından silinir.';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days gün kaldı';
  }

  @override
  String get deletedRestore => 'Geri yükle';

  @override
  String get deletedDeleteForever => 'Tamamen sil';

  @override
  String get deletedDeleteForeverDescription =>
      'Giriş ve ekleri silinir. Bu geri alınamaz.';

  @override
  String get deletedEmpty => 'Boş';

  @override
  String get deletedEmptyDescription =>
      'Son silinenler bölümündeki tüm girişler silinsin mi? Bu geri alınamaz.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Rastgele yürüyüş';

  @override
  String get randomSubtitle => 'Geçmiş bir girişi aç';

  @override
  String get randomNext => 'Başka bir';

  @override
  String get randomAll => 'Hepsi';

  @override
  String get randomWithPhotos => 'Fotoğraflı';

  @override
  String get randomGoodDays => 'İyi günler';

  @override
  String get randomEmpty => 'Aralarından seçim yapılabilecek giriş yok';

  @override
  String get reviewWeekTitle => 'Bu hafta';

  @override
  String get reviewWeekSubtitle => 'Şu ana kadarki haftanız';

  @override
  String get reviewYearTitle => 'Bu yıl';

  @override
  String get reviewEmpty => 'Henüz yazılı bir şey yok';

  @override
  String get reviewEntries => 'Girişler';

  @override
  String get reviewDaysWritten => 'Yazılan günler';

  @override
  String get reviewWords => 'kelimeler';

  @override
  String get reviewPhotos => 'Fotoğraflar';

  @override
  String get reviewLongestRun => 'En uzun gün koşusu';

  @override
  String get reviewAverageMood => 'Ortalama ruh hali';

  @override
  String get reviewFavorites => 'Çoğu zaman';

  @override
  String get reviewByMonth => 'Aya göre';

  @override
  String get reviewHighlight => 'Vurgula';

  @override
  String get yearInPixels => 'Piksel cinsinden yıl';

  @override
  String get capsuleSeal => 'Zaman kapsülü olarak mühürleyin';

  @override
  String get capsuleTitle => 'Zaman kapsülü';

  @override
  String capsuleOpensOn(Object date) {
    return '$date\'de açılıyor';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return '$date\'de yazıldı';
  }

  @override
  String get capsuleOpenEarly => 'Erken aç';

  @override
  String get capsuleOpenEarlyDescription =>
      'Kapsül artık açılıyor ve açık kalıyor.';

  @override
  String get capsuleOpened => 'Zaman kapsülü açıldı';

  @override
  String get templateMorningName => 'Sabah sayfaları';

  @override
  String get templateMorningDescription => 'Üç dakikada günü ayarla';

  @override
  String get templateMorningText =>
      '## Bugün iyi yapmak istediğim üç şey\n1. \n2. \n3. \n\n## Dört gözle beklediğim bir şey\n\n## Kendime bir not\n';

  @override
  String get templateEveningName => 'Akşam incelemesi';

  @override
  String get templateEveningDescription => 'Günü iyi giden bir şeyle kapatın';

  @override
  String get templateEveningText =>
      '## Bugün üç güzel şey\n1. \n2. \n3. \n\n## Ne öğrendim\n\n## Yarın daha iyi ne olabilir\n';

  @override
  String get routineMorning => 'Günaydın';

  @override
  String get routineEvening => 'Akşam incelemesi';

  @override
  String get settingsRoutinePrompts => 'Sabah ve akşam istemleri';

  @override
  String get settingsRoutinePromptsHint =>
      'Hikayelerde sabah veya akşam şablonunu önerin';

  @override
  String get checkInTitle => 'Hızlı giriş';

  @override
  String get checkInSubtitle => 'İki dokunuşla ruh hali';

  @override
  String get checkInMood => 'Nasıl hissediyorsun?';

  @override
  String get checkInActivity => 'Ne yapıyorsun?';

  @override
  String get checkInNote => 'Bununla ilgili bir satır (isteğe bağlı)';

  @override
  String get checkInSave => 'Kaydet';

  @override
  String editorWordCount(int words, int characters) {
    return '$words sözcükler · $characters karakterler';
  }

  @override
  String get coachProgramEverydayTagline =>
      'Bir günde küçük şeylere dikkat edin.';

  @override
  String get coachProgramReflectTagline => 'Yavaşlayın ve kendinizi dinleyin.';

  @override
  String get coachDuration => 'Süre';

  @override
  String get coachInterval => 'Aralık';

  @override
  String get coachDifficulty => 'Zorluk';

  @override
  String get coachIntervalDaily => 'Günlük';

  @override
  String get coachIntervalWeekly => 'Haftalık';

  @override
  String get coachDifficultyBeginner => 'Başlangıç';

  @override
  String get coachDifficultyIntermediate => 'Orta seviye';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün',
      one: '$count gün',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hafta',
      one: '$count hafta',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'Gün $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Hafta $n';
  }

  @override
  String get coachEnroll => 'Kayıt ol';

  @override
  String get coachEndProgram => 'Programı sonlandır';

  @override
  String get coachAuthor => 'Yazar';

  @override
  String get coachAuthorBio => 'Bu uygulama için yazılmış istemler.';

  @override
  String get coachEnrolledTip =>
      'Her şey hazır! Sorularınız Hikayelerde görünecek.';

  @override
  String get coachGoToStories => 'Hikayelere Git';

  @override
  String get coachAnswerHint => 'Cevabınızı yazın…';

  @override
  String get storyWrapUp => 'Bugünlük bu kadar.';

  @override
  String get storyTapToClose => 'Kapatmak için dokunun';

  @override
  String get coachAnswerDone => 'Bitti';

  @override
  String get coachAnswered => 'Yanıtlandı, açmak için dokunun';

  @override
  String get coachAnsweredEarlier => 'Yanıtlandı';

  @override
  String get locationLocating => 'Bulunuyor…';

  @override
  String get locationPickPlace => 'Bir yer seç';

  @override
  String get locationPlacesHint => 'Yerin adresi veya adı';

  @override
  String get locationCustom => 'Özel yer';

  @override
  String get locationCurrent => 'Mevcut konum';

  @override
  String get locationSaved => 'Kaydedilen yerler';

  @override
  String get locationSearchResults => 'Arama sonuçları';

  @override
  String get locationNearby => 'Yakındaki yerler';

  @override
  String get locationRename => 'Yeniden adlandır';

  @override
  String get locationSavePlace => 'Yeri kaydet';

  @override
  String get locationUnsavePlace => 'Kaydedilen yerlerden kaldır';

  @override
  String get shareAs => 'Farklı paylaş…';

  @override
  String get shareAsImage => 'Resim';

  @override
  String get shareAsZip => 'Orijinal ortamla ZIP';

  @override
  String get shareAsPlainText => 'Düz metin';

  @override
  String get shareAsHtml => 'HTML\'';

  @override
  String get onboardWelcomeTitle => 'AID Diary\'ye hoş geldiniz';

  @override
  String get onboardWelcomeText =>
      'Buradan başlayın veya bu cihazı halihazırda kullandığınız bir cihaza bağlayın.';

  @override
  String get onboardStart => 'Yazmaya başla';

  @override
  String get helpFaq => 'Sık sorulan sorular';

  @override
  String get helpFaq1Q => 'Günlüğüm nerede saklanıyor?';

  @override
  String get helpFaq1A =>
      'Günlüğünüz bu cihazda saklanıyor. Yalnızca senkronizasyonu etkinleştirdiğinizde, paylaştığınızda veya dışa aktardığınızda diğer cihazlara veya depolama alanına ulaşır. Senkronizasyon uçtan uca şifrelenir.';

  @override
  String get helpFaq2Q =>
      'Bir kopyasını nasıl saklayabilirim veya yeni bir cihaza nasıl taşıyabilirim?';

  @override
  String get helpFaq2A =>
      'Ayarlar → Veri ve depolama → Senkronizasyon bölümünden mevcut bir cihaza bağlanın ve günlüğünüzün bulunduğu cihazda yetkilendirmeyi onaylayın. Her iki cihaz da kullanılabilir durumda kalır. Ayrıca bir yedekleme oluşturabilir ve onu başka bir cihaza geri yükleyebilirsiniz.';

  @override
  String get helpFaq3Q =>
      'Diğer günlük uygulamalarından girdiler getirebilir miyim?';

  @override
  String get helpFaq3A =>
      'Evet: Ayarlar → Veri ve depolama bölümünde, Daylio, Diarium, Diaro, DayBook, My Brain, OneShot ve Pixels\'den dışa aktarmaları veya JSON\'den dışa aktarmaları içe aktarın.';

  @override
  String get helpFaq4Q => 'Koçluk programları nasıl çalışır?';

  @override
  String get helpFaq4A =>
      'Koç sayfasından bir programa kaydolun. Hikayelerde her gün veya her hafta yeni bir soru sizi bekliyor; Cevabınız giriş olarak kaydedilir.';

  @override
  String get helpFaq5Q => 'Şifremi unutursam ne olur?';

  @override
  String get helpFaq5A =>
      'Şifre kurtarılamaz, bu nedenle günlüğünüzün yedeğini alın.';

  @override
  String get helpPrivacy => 'Gizlilik';

  @override
  String get helpPrivacyText =>
      'Şifreli senkronizasyonu etkinleştirmediğiniz veya bunları paylaşmadığınız/dışa aktarmadığınız sürece günlük içeriği ve medya bu cihazda kalır. Haritalar, yer arama ve hava durumu yapılandırılmış hizmetleri kullanır ve günlük metnini değil, bu istek için gereken konumu veya arama sorgusunu gönderir.';

  @override
  String get photoMetaTitle => 'Fotoğrafın ayrıntıları kullanılsın mı?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Bu girişi $date için sayın ve yerini fotoğrafta kaydedildiği gibi $place olarak ayarlayın.';
  }

  @override
  String photoMetaDate(String date) {
    return 'Fotoğraf çekildiğinde bu girişi $date için sayın mı?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Bu girişin yeri fotoğrafın çekildiği $place olarak ayarlansın mı?';
  }

  @override
  String get photoMetaApply => 'Onları kullan';

  @override
  String get quickWriteTitle => 'Hızlı yazma';

  @override
  String get quickWriteText => 'Yeni bir giriş başlatmak için dokunun.';

  @override
  String get settingsQuickWriteTitle => 'Bildirimlere hızlı yazma';

  @override
  String get settingsQuickWriteDescription =>
      'Yeni bir giriş açan bir bildirim bulundurun.';

  @override
  String get settingsNudgesTitle => 'Sessiz bir esnemeden sonra beni dürt';

  @override
  String settingsNudgesDescription(int days) {
    return '$days gün boyunca yazmadığınız zamanlar için nazik bir hatırlatma.';
  }

  @override
  String get nudgeTitle => 'Bir süre oldu';

  @override
  String get nudgeMonday => 'Yeni bir hafta: Neyi sabırsızlıkla bekliyorsunuz?';

  @override
  String get nudgeTuesday => 'İki satır yeterli. Bugün nasılsın?';

  @override
  String get nudgeWednesday =>
      'Haftanın ortasında. Şu ana kadar öne çıkan ne oldu?';

  @override
  String get nudgeThursday =>
      'Bugünden itibaren saklamaya değer küçük bir şey var mı?';

  @override
  String get nudgeFriday => 'Hafta tamamlanıyor. Güzel bir anı not edin.';

  @override
  String get nudgeSaturday =>
      'Yavaş bir cumartesi yazmak için güzel bir gündür.';

  @override
  String get nudgeSunday => 'Bitmeden önceki haftaya dönüp bakın.';

  @override
  String get photoWidgetEmpty =>
      'Girişlere eklediğiniz fotoğraflar burada gösterilir.';

  @override
  String get channelReminders => 'Hatırlatıcılar';

  @override
  String get channelOnThisDay => 'Bu günde';

  @override
  String get channelCoach => 'Koç istemleri';

  @override
  String get channelNudges => 'Sessiz günlerin ardından dürtmeler';

  @override
  String get channelQuickWrite => 'Hızlı yazma';

  @override
  String get channelBackup => 'Yedeklemeler';

  @override
  String get formatJsonExport => 'JSON (AID Diary dışa aktarma)';

  @override
  String get aboutModifiedNotice =>
      'Daily You\'nun Demizo ve katkıda bulunanlar tarafından değiştirilmiş bir versiyonu. Bu, resmi Daily You uygulaması değildir.';

  @override
  String get toolbarPhotos => 'Fotoğraf ekle';

  @override
  String get toolbarMedia => 'Fotoğraflar ve videolar';

  @override
  String get mediaFromGallery => 'Galeriden seç';

  @override
  String get mediaFromFiles => 'Dosyalar arasından seçim yapın';

  @override
  String get editorLeaveTitle => 'Bu giriş kaydedilsin mi?';

  @override
  String get editorLeaveDiscard => 'Kaydetme';

  @override
  String get editorTitleHint => 'Başlık';

  @override
  String get editorLocating => 'Bulunuyor…';

  @override
  String get toolbarVideo => 'video';

  @override
  String get toolbarAudio => 'Sesli not';

  @override
  String get toolbarTags => 'Etiketler';

  @override
  String get toolbarBulletList => 'Madde işaretli liste';

  @override
  String get toolbarHeading => 'Başlık';

  @override
  String get toolbarBold => 'Kalın';

  @override
  String get toolbarItalic => 'italik';

  @override
  String get toolbarHighlight => 'Vurgula';

  @override
  String get toolbarStrikethrough => 'Üstü çizili';

  @override
  String get toolbarQuote => 'Alıntı';

  @override
  String get toolbarLink => 'Bağlantı';

  @override
  String get toolbarInsert => 'Ekle';

  @override
  String get toolbarUndo => 'Geri al';

  @override
  String get toolbarRedo => 'Yinele';

  @override
  String get toolbarInsertDate => 'Tarihi ekle';

  @override
  String get toolbarInsertTime => 'Saati girin';

  @override
  String get settingsSyncTitle => 'Bulut Senkronizasyonu';

  @override
  String get syncOffDescription =>
      'Bu günlüğü, Google Drive veya Nextcloud, Synology veya Jianguoyun gibi bir WebDAV sunucusu aracılığıyla tüm cihazlarınızda aynı tutun.';

  @override
  String get syncUseGoogleDrive => 'Google Drive ile senkronize edin';

  @override
  String get syncOrWebDav => 'Veya bir WebDAV sunucusu';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn =>
      'Oturum açtınız. AID Diary\'ye geri dönebilirsiniz.';

  @override
  String get syncGoogleSignInAgain =>
      'Google\'ın tekrar oturum açmanız gerekiyor.';

  @override
  String get syncSignInAgain => 'Tekrar oturum açın';

  @override
  String get settingsCommandLineTitle => 'Komut satırı';

  @override
  String get commandLineToggle => 'Komut satırı arayüzü';

  @override
  String get commandLineToggleHint =>
      'Yardım komutunun ve bu cihazdaki diğer programların, uygulamanın komutlarını kullanmasına izin verir.';

  @override
  String get commandLineAlwaysOn => 'Her zaman geliştirme aşamasındadır.';

  @override
  String commandLineListening(int port) {
    return '$port bağlantı noktasında dinleme';
  }

  @override
  String get commandPaletteTitle => 'Tüm komutlar';

  @override
  String get commandPaletteSearch => 'Arama komutları';

  @override
  String get commandPaletteRun => 'Çalıştır';

  @override
  String get commandPaletteConfirm =>
      'Bu basitçe geri alınamaz. Çalıştırmak mı?';

  @override
  String syncReceiving(int done, int total) {
    return '$total\'nin $done\'si alınıyor…';
  }

  @override
  String syncSending(int done, int total) {
    return '$total\'nin $done\'si gönderiliyor…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'Google Drive\'ye erişime izin verilmedi. Tekrar bağlanın ve Google sayfasında Google Drive seçeneğini işaretleyin.';

  @override
  String get syncEntryUnsynced =>
      'Senkronize edilmedi: son senkronizasyon gerçekleşmedi';

  @override
  String get syncUseOfficial => 'AID senkronizasyon sunucusunu kullanma';

  @override
  String get syncServer => 'Sunucu adresi';

  @override
  String get syncUsername => 'Kullanıcı adı';

  @override
  String get syncPassword => 'Şifre';

  @override
  String get syncConnect => 'Bağlan';

  @override
  String get syncConnecting => 'Bağlanıyor…';

  @override
  String get syncSignInFailed =>
      'Oturum açılamadı. Adresi, kullanıcı adını ve şifreyi kontrol edin.';

  @override
  String syncConnectFailed(String error) {
    return 'Bağlanılamadı: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Senkronizasyonu başlat';

  @override
  String get syncNewSpaceDescription =>
      'Henüz burada senkronize edilmiş bir günlük yok. Bu günlük, cihazlarınızda kalacak bir anahtarla uçtan uca şifrelenmiş olarak yüklenecektir.';

  @override
  String get syncJoinTitle => 'Senkronize edilmiş günlüğe katılın';

  @override
  String get syncWrongKey =>
      'Bu kurtarma kodu senkronize edilen günlüğü açmaz.';

  @override
  String syncLastSynced(String time) {
    return 'Son senkronize edilen $time';
  }

  @override
  String get syncNever => 'Henüz senkronize edilmedi';

  @override
  String get syncSyncing => 'Senkronize ediliyor…';

  @override
  String syncFailed(String error) {
    return 'Son senkronizasyon başarısız oldu: $error';
  }

  @override
  String get syncLocked =>
      'Senkronize edilen günlük artık diğer cihazlara ait veya baştan başlatıldı. Senkronizasyonu sürdürmek için bunlardan biriyle eşleştirin veya kurtarma kodunu kullanın.';

  @override
  String get syncNow => 'Şimdi senkronize et';

  @override
  String get syncUnlock => 'Kilidi aç';

  @override
  String get syncEncrypted => 'Uçtan uca şifrelenmiş';

  @override
  String get syncDisconnect => 'Senkronizasyonu durdur';

  @override
  String get syncDisconnectDescription =>
      'Bu cihaz senkronizasyonu durduruyor. Buradaki günlük ve senkronize edilmiş kopya olduğu gibi kalır.';

  @override
  String get syncOwnRecoveryPassword => 'Kendi kurtarma şifremi kullan';

  @override
  String get syncRecoveryPassword => 'Kurtarma şifresi';

  @override
  String get syncRecoveryPasswordRepeat => 'Kurtarma şifresini tekrarlayın';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'En az $min karakter kullanın';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'Şifreler farklı';

  @override
  String get syncRecoveryCode => 'Kurtarma kodu';

  @override
  String get syncRecoveryCodeTitle => 'Kurtarma kodunuzu kaydedin';

  @override
  String get syncRecoveryCodeDescription =>
      'Tüm cihazlarınız kaybolursa bu kod, senkronize edilen günlüğünüzü geri yükler. Bunu bir şifre yöneticisinde veya kağıt üzerinde saklayın. Yalnızca bu kez gösterilir.';

  @override
  String get syncRecoveryCodeCopied => 'Kurtarma kodu kopyalandı';

  @override
  String get syncRecoveryCodeSaved => 'onu sakladım';

  @override
  String get syncJoinNeedsKey =>
      'Bu senkronize edilmiş günlük diğer cihazlarınıza aittir. Bunlardan biriyle eşleştirin veya kurtarma kodunu kullanın. Bu cihazdaki girişler ona eklenecektir.';

  @override
  String get syncPairDevice => 'Bir cihazla eşleştirin';

  @override
  String get syncUseRecoveryCode => 'Kurtarma kodunu kullanın';

  @override
  String get syncAddDevice => 'Cihaz ekle';

  @override
  String get syncChangeRecoveryCode => 'Kurtarma kodunu değiştirin';

  @override
  String get syncChangeRecoveryDescription =>
      'Yeni bir kod, çalışmayı durduran mevcut kodun yerini alır. Verileriniz ve diğer cihazlarınız oldukları gibi kalır.';

  @override
  String get syncNewRandomCode => 'Yeni rastgele kod';

  @override
  String get syncRecoveryCodeChanged => 'Kurtarma kodu değiştirildi';

  @override
  String get syncResetSpace => 'Senkronize edilmiş günlüğü baştan başlat';

  @override
  String get syncResetSpaceDescription =>
      'Ancak artık hiçbir cihaz veya kurtarma kodu açılmadığında: senkronize edilen kopyanın yerini, bu cihazdaki, bu cihazın tuşlarının altındaki günlük alır. Daha sonra diğer cihazlarınız tekrar eşleşir.';

  @override
  String get syncPairTitle => 'Cihazları eşleştir';

  @override
  String get syncPairShow => 'Bir kod göster';

  @override
  String get syncPairEnter => 'Bir kod girin';

  @override
  String get syncPairShowHint =>
      'Diğer cihazınızda Cihazları eşleştir\'i açın, Kod girin\'i seçin ve bunu yazın veya tarayın.';

  @override
  String get syncPairEnterHint =>
      'Diğer cihazınızın gösterdiği kodu yazın veya tarayın.';

  @override
  String get syncPairCode => 'Eşleştirme kodu';

  @override
  String get syncPairScan => 'Tara';

  @override
  String get syncPairStart => 'Çift';

  @override
  String get syncPairWaiting => 'Diğer cihaz bekleniyor…';

  @override
  String syncPairDone(String device) {
    return '$device ile eşleştirildi';
  }

  @override
  String get syncPairWrongCode =>
      'Kod eşleşmedi. Yeni bir kod gösterip tekrar deneyin.';

  @override
  String get syncPairNoOffer =>
      'Bu kodu hiçbir cihaz göstermiyor. Süresi dolmuş olabilir.';

  @override
  String get syncPairTimedOut => 'Diğer cihaz zamanında yanıt vermedi.';

  @override
  String get syncPairNeither =>
      'Henüz hiçbir cihaz bu senkronize günlükle ayarlanmadı.';

  @override
  String get syncPairBoth =>
      'Her iki cihaz da bu senkronize edilmiş günlüğü zaten açıyor.';

  @override
  String syncPairFailed(String error) {
    return 'Eşleştirme başarısız oldu: $error';
  }

  @override
  String get syncMediaPending =>
      'Günlük senkronize edildi · bazı medyalar hâlâ aktarılıyor';

  @override
  String get syncWaitingForDevices =>
      'Günlük senkronize edildi · başka bir cihazın medya aktarması bekleniyor';

  @override
  String get syncCacheNotice =>
      'Bulut medyası geçicidir. Orijinalleri cihazlarınızda saklayın; senkronizasyon bir yedekleme değildir.';

  @override
  String get paperTitle => 'Mektup kağıdı';

  @override
  String get paperPlain => 'Düz';

  @override
  String get paperLined => 'Astarlı';

  @override
  String get paperGrid => 'Izgara';

  @override
  String get paperTinted => 'Renkli';

  @override
  String get paperDecorationTitle => 'Dekorasyonlar';

  @override
  String get paperDecorationNone => 'Yok';

  @override
  String get paperDecorationBotanical => 'Yapraklar';

  @override
  String get paperDecorationStars => 'Yıldızlar';

  @override
  String get paperDecorationWashi => 'Washi bant';

  @override
  String get themeDarkChoice => 'Koyu görünüm';

  @override
  String get themeDarkSame => 'Işık paletini takip edin';

  @override
  String get themeDarkCustom => 'Ayrı palet';

  @override
  String get themeDarkAccent => 'Koyu vurgu rengi';

  @override
  String get themeColorTeal => 'turkuaz';

  @override
  String get themeColorCyan => 'Camgöbeği';

  @override
  String get themeColorIndigo => 'Çivit mavisi';

  @override
  String get themeColorCoral => 'Mercan';

  @override
  String get themeColorOlive => 'zeytin';

  @override
  String get themeColorSlate => 'Arduvaz';

  @override
  String get drawingTitle => 'Çizim';

  @override
  String get drawingPen => 'Kalem';

  @override
  String get drawingEraser => 'Silgi';

  @override
  String get drawingUndo => 'Geri al';

  @override
  String get drawingClear => 'Temizle';

  @override
  String get drawingWidth => 'Kalem genişliği';

  @override
  String get drawingStylusOnly => 'Yalnızca kalem';

  @override
  String get drawingDiscardTitle => 'Çizim silinsin mi?';

  @override
  String get drawingDiscardBody => 'Bu çizim kaydedilmedi.';

  @override
  String get drawingSaveError => 'Çizim kaydedilemedi.';

  @override
  String get syncNetworkTitle => 'Ağ teşhisi';

  @override
  String get syncNetworkRefresh => 'Yenile';

  @override
  String get syncNetworkSelectedRoute => 'Geçerli yol';

  @override
  String get syncNetworkAvailableRoutes => 'Mevcut yollar';

  @override
  String get syncNetworkSignaling => 'Cihaz dizini bağlantısı';

  @override
  String get syncNetworkRelayRemaining => 'Kalan aktarma ödeneği';

  @override
  String get syncNetworkIcePair => 'Doğrudan bağlantı adayları';

  @override
  String get syncNetworkPeerTrusted => 'Kimliği doğrulanmış cihaz';

  @override
  String get syncNetworkNoRoute => 'Bağlantı bekleniyor';

  @override
  String get syncNetworkUnavailable => 'Teşhis kullanılamıyor';

  @override
  String get syncMediaCopiesTitle => 'Medya dağıtımı ve kopyalar';

  @override
  String get syncMediaPendingCount => 'Aktarılmayı bekliyorum';

  @override
  String get syncMediaDurableCount => 'Kişisel depoya teslim edildi';

  @override
  String get syncMediaTemporaryCount => 'Geçici veya onaylanmamış kopyalar';

  @override
  String get syncMediaReceiptExplanation =>
      'Bu sayımlar, hayatta kalan yedeklerin yeni denetimini değil, tamamlanan teslimatları açıklar.';

  @override
  String get syncMediaCacheExplanation =>
      'Geçici bulut ortamının süresi dolabilir. Orijinallerinizi veya ayrı bir yedeğinizi saklayın.';

  @override
  String get momentsTitle => 'Fotoğraf anları';

  @override
  String get momentsHint =>
      'Yerel fotoğraf zamanlarını ve isteğe bağlı koordinatları kullanarak grupları bulun. Fotoğraflar yalnızca bir kart seçtiğinizde eklenir.';

  @override
  String get momentsScan => 'Anları bulun';

  @override
  String get momentsChooseFolder => 'Fotoğraf klasörünü seçin';

  @override
  String get momentsLocation => 'Fotoğraf konumlarını dahil et';

  @override
  String get momentsEmpty => 'Yeni fotoğraf grubu yok.';

  @override
  String get momentsCreate => 'Bu fotoğraflar hakkında yazın';

  @override
  String get momentsDismiss => 'Reddet';

  @override
  String get momentsError => 'Yerel fotoğraflar okunamadı.';

  @override
  String get momentsCreated => 'Fotoğraf girişi oluşturuldu.';

  @override
  String get momentsPermission =>
      'Yerel öneriler bulmak için fotoğraflara erişime izin verin.';

  @override
  String get momentsScope =>
      'Yalnızca son fotoğraflar; Kart başına en fazla 500 fotoğraf ve 20 fotoğraf.';

  @override
  String momentsPhotoCount(int count) {
    return '$count fotoğrafları';
  }

  @override
  String get nearbyTitle => 'Cihazları bağlayın';

  @override
  String get nearbySend => 'Başka bir cihazı yetkilendirin';

  @override
  String get nearbyReceive => 'Mevcut bir cihaza bağlanın';

  @override
  String get nearbyInstructions =>
      'Her iki cihazı da aynı Wi-Fi\'ye veya birbirlerinin erişim noktasına bağlayın. Mevcut cihazdaki yetkilendirmeyi onaylayın; her iki cihaz da kullanılabilir durumda kalır. İnternet gerekmez.';

  @override
  String get nearbyCompare =>
      'Onaylamadan önce bu kodu her iki cihazda karşılaştırın.';

  @override
  String get nearbyConfirm => 'Kodlar eşleşiyor';

  @override
  String get nearbyScan => 'Diğer cihazın kodunu tarayın';

  @override
  String get nearbyPaste => 'Davetiyeyi yapıştır';

  @override
  String get nearbyWaiting => 'Diğer cihazda onay bekleniyor';

  @override
  String get nearbyWorking =>
      'Günlüğünüzü ve eklerinizi yetkilendirme ve senkronize etme…';

  @override
  String get nearbyPending =>
      'Bazı eklerin hâlâ senkronize edilmesi gerekiyor. Diğer cihazı çevrimiçi tutun ve tekrar deneyin.';

  @override
  String get nearbyComplete =>
      'Cihaz bağlandı; günlük ve ekler senkronize edildi';

  @override
  String get nearbyFailed =>
      'Bağlantı tamamlanmadı. Yerel bağlantıyı kontrol edip tekrar deneyin.';

  @override
  String get nearbyEmptyRequired =>
      'Henüz senkronizasyona bağlanmamış, boş günlüğü olan bir cihaz kullanın.';

  @override
  String get nearbyRetry => 'Senkronizasyona devam et';

  @override
  String get nearbyWifi => 'Wi-Fi ayarları';

  @override
  String get nearbyHotspot => 'Erişim noktası ayarları';

  @override
  String get nearbyKeepOpen =>
      'Yeni cihaz bitene kadar bu sayfayı açık tutun. Davet iki dakika sonra sona erer.';

  @override
  String get syncDevicesTitle => 'Yetkili cihazlar';

  @override
  String get syncDevicesDescription =>
      'Bu AID hesabına yalnızca onaylı cihazlar erişebilir. Bir aygıtın iptal edilmesi sunucuyu bloke eder ancak önceden kendisine kopyalanmış olan ana anahtarı veya günlüğü silemez.';

  @override
  String get syncDeviceRequest =>
      'Bu yetkilendirme QR\'sini onaylanmış bir cihaza göster';

  @override
  String get syncDeviceAuthorize => 'Bir cihazı yetkilendirin';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Yeni cihazın yetkilendirme isteğini tarayın veya yapıştırın.';

  @override
  String get syncDeviceRevoke => 'İptal et';

  @override
  String get syncDeviceRotate => 'Bu cihazın imzalama anahtarını döndürün';

  @override
  String get syncDeviceCheck => 'Yetkilendirmeyi kontrol edin';

  @override
  String get syncDeviceHardware => 'Donanım destekli imzalama anahtarı';

  @override
  String get syncDeviceSoftware =>
      'Dışa aktarılamayan yazılım imzalama anahtarı';

  @override
  String get syncDeviceUnavailable =>
      'Cihaz yetkilendirmesi kullanılamıyor. Bu cihazı başka bir yetkili cihazdan onaylayın ve yeniden deneyin.';

  @override
  String get syncDeviceRevoked => 'İptal edildi';

  @override
  String get syncDeviceLocal => 'Bu cihaz';

  @override
  String get cloudTrafficTitle =>
      'Medya dosyaları için aylık bulut veri aktarımı kotası';

  @override
  String get cloudTrafficLimit => 'Aylık veri aktarım kotası';

  @override
  String get cloudTrafficUsed => 'Kullanılan veri aktarımı';

  @override
  String get cloudTrafficRemaining => 'Kalan veri aktarımı';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'Veri aktarım kotası $time sıfırlanır';
  }

  @override
  String get cloudTrafficExhausted =>
      'Medya dosyaları için bulut veri aktarımı kotası kullanıldı. Eksik medya dosyaları, doğrudan bağlantı mevcut olduğunda veya kota sıfırlandığında otomatik olarak senkronize edilir.';

  @override
  String get cloudTrafficExplanation =>
      'Medya dosyasını önbelleğe alma ve canlı aktarma bu veri aktarım kotasını paylaşır. Doğrudan bağlantılar onu tüketmez. Günlük metni ve bağlantı kontrol mesajlarının ayrı küçük günlük sınırları vardır.';

  @override
  String get appearanceThemeSection => 'Uygulama teması';

  @override
  String get appearancePaperSection => 'Günlük kağıdı';

  @override
  String get appearanceTypographySection => 'Günlük metni';

  @override
  String get appearancePreferencesSection => 'Genel tercihler';

  @override
  String get themeSystemAccentHint =>
      'Özel renkler yerine sistem paletini kullanır. Kendinizinkini seçmek için kapatın.';

  @override
  String get syncDeviceNameSaveFailed =>
      'Cihaz adı kaydedilemedi. Lütfen tekrar deneyin.';

  @override
  String get nearbyConnectionHelp => 'Bağlantı yardımı';

  @override
  String get syncAllSynced => 'Her şey senkronize edildi';

  @override
  String get syncDetailsTitle => 'Ayrıntıları senkronize et';

  @override
  String get syncMore => 'Daha fazla seçenek';

  @override
  String get syncDeviceName => 'Cihaz adı';

  @override
  String get syncDeviceNameHint => 'Örneğin: Tabletim';

  @override
  String get syncDeviceNameInvalid => '1 ila 32 karakter kullanın';

  @override
  String get syncDeviceKeyDetails => 'Güvenlik ayrıntıları';

  @override
  String get syncConnectionProblem =>
      'Şimdilik senkronize edilemiyor. Otomatik olarak yeniden deneniyor.';

  @override
  String get syncCopyComplete =>
      'Günlüğünüzün ve medya dosyalarınızın tam kopyası';

  @override
  String get syncCopyPartial => 'Bazı medyalar hâlâ eksik';

  @override
  String get syncCopyOlder => 'Yeni değişiklikler senkronize edilmeyi bekliyor';

  @override
  String get syncCopyUnavailable =>
      'Kopyalama ayrıntıları kullanılamıyor. Daha sonra tekrar deneyin.';

  @override
  String get syncCopyLastKnown =>
      'Diğer cihazlar en son onaylanmış kopyalarını gösterir. Çevrimdışı cihazlar şu anda kontrol edilemiyor.';

  @override
  String get syncCopyTemporary =>
      'Geçici önbellek. Orijinalleri cihazlarınızda saklayın.';

  @override
  String get syncCopyStorage =>
      'Senkronizasyon depolama alanınız. Tamamlanan medya yüklemeleri teşhiste listelenir.';

  @override
  String syncCopyChecked(String time) {
    return 'Son onaylanan $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Bu ay kalan veri aktarımı: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Buradan başlayın';

  @override
  String get onboardConnect => 'Mevcut bir cihaza bağlanın';

  @override
  String get onboardFailed =>
      'Kurulum tamamlanamadı. Günlüğünüz güvende; lütfen tekrar deneyin.';

  @override
  String get tutorialTitle => 'Günlük nasıl kullanılır?';

  @override
  String get tutorialWriteTitle => 'İlk günlük girişinizi yazın';

  @override
  String get tutorialWriteText =>
      'Günlük girişi yazmak için + öğesine dokunun. İsteğe bağlı bir başlık ekleyin, günlük tarihini seçin ve kaydetmek için onay işaretine dokunun. Günlük girişinizi istediğiniz zaman tekrar düzenleyebilirsiniz.';

  @override
  String get tutorialMediaTitle => 'Fotoğraf, ses veya el yazısı ekleyin';

  @override
  String get tutorialMediaText =>
      'Fotoğraf, video veya ses kaydı eklemek ya da el yazısı tuvalini açmak için günlük düzenleyicisindeki + işaretini kullanın. Bu ekler günlük girişiyle birlikte kaydedilir.';

  @override
  String get tutorialReviewTitle => 'Tekrar bir gün bul';

  @override
  String get tutorialReviewText =>
      'Günlüğünüze veya takviminize göz atın, yazılarınızda arama yapın ve girişleri etiketlerle düzenleyin. Medya ve Atlas sayfaları, geçmiş girişleri fotoğrafa veya konuma göre bulmanızı sağlar.';

  @override
  String get tutorialSyncTitle => 'Birden fazla cihaz kullanma';

  @override
  String get tutorialSyncText =>
      'Ayarlar → Veri ve depolama → Senkronizasyon bölümünde mevcut bir cihaza bağlanın ve bu cihazdaki yetkilendirmeyi onaylayın. Her iki cihaz da günlüğü kullanmaya devam edebilir. Önce günlük metni senkronize edilir. Medya dosyaları, ağ bağlantısı ve kalan veri aktarım kotası izin verdiğinde bir sonraki adımda senkronize edilir.';

  @override
  String get tutorialPrivacyTitle => 'Günlüğünüzü güvende tutun';

  @override
  String get tutorialPrivacyText =>
      'Senkronizasyonu etkinleştirmediğiniz, paylaşmadığınız veya dışa aktarmadığınız sürece günlük girişleri bu cihazda kalır. Senkronizasyon uçtan uca şifrelenir. Ayarlar\'da ayrıca bir uygulama şifresi ayarlayabilir, yedeklemeler oluşturabilir ve bu öğreticiyi yeniden açabilirsiniz.';

  @override
  String get editorDiaryDay => 'Günlük günü';

  @override
  String get editorDiaryDayPicker => 'Günlük günü · Bu kayıt hangi güne ait?';

  @override
  String editorCreatedAt(String time) {
    return 'Oluşturuldu $time';
  }

  @override
  String get editorDiaryDayHint =>
      'Bu kaydın ait olduğu gün. Bunu değiştirmek kaydın oluşturulma zamanını değiştirmez.';

  @override
  String get hiddenDiaryTitle => 'Gizli kayıtlar';

  @override
  String get hiddenDiaryHide => 'Kaydı gizle';

  @override
  String get hiddenDiaryShow => 'Kaydı göster';

  @override
  String get hiddenDiaryEmpty => 'Gizli kayıt yok';

  @override
  String get hiddenDiaryUnlock => 'Gizli kayıtların kilidini aç';

  @override
  String get hiddenDiaryAuthHint =>
      'Uygulama kilidini veya cihazınızın ekran kilidini kullanın.';

  @override
  String get moodClear => 'Ruh halini temizle';

  @override
  String get scrollToTop => 'Başa dön';

  @override
  String get feedbackTitle => 'Geri bildirim';

  @override
  String get feedbackHint => 'Sorunu veya öneriyi açıklayın';

  @override
  String get feedbackGithub => 'GitHub sorunu';

  @override
  String get feedbackEmail => 'E-posta gönder';

  @override
  String get feedbackCopy => 'Metni kopyala';

  @override
  String get feedbackLaunchFailed =>
      'Uygulama açılamadı. Metni kopyalayıp aşağıdaki e-postayı kullanın.';

  @override
  String get feedbackCopied => 'Geri bildirim kopyalandı';
}
