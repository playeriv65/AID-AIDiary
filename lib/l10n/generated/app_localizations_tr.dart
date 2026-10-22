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
  String get themeColorTitle => 'Theme color';

  @override
  String get themeColorHint => 'Choose a color for this palette.';

  @override
  String get themeColorBlue => 'Sky blue';

  @override
  String get themeColorGreen => 'Forest green';

  @override
  String get themeColorBrown => 'Warm coffee';

  @override
  String get themeColorPurple => 'Lavender';

  @override
  String get themeColorRose => 'Dusty rose';

  @override
  String get themeColorAmber => 'Amber';

  @override
  String get themeColorPreview => 'A little every day';

  @override
  String get themeTintBackgroundTitle => 'Tint backgrounds with theme color';

  @override
  String get themeTintBackgroundHint =>
      'Turn off for neutral gray backgrounds; buttons keep your chosen color.';

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
  String get noResults => 'No Results…';

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
      other: 'Great Days $count',
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
  String get tagTypeLabelTitle => '';

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
  String get tagLabel => 'Tag';

  @override
  String get tagCategoryUncategorized => 'Kategori edilmemiş';

  @override
  String get newCategoryTitle => 'Yeni Kategori';

  @override
  String get shareButtonLabel => 'Share';

  @override
  String get importErrorDescription => 'Failed to import file!';

  @override
  String get exportErrorDescription => 'Failed to export file!';

  @override
  String get deleteTitle => 'Sil';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' It is used in $count logs.',
      one: ' It is used in 1 log.',
      zero: '',
    );
    return 'Delete \"$name\"?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Its $count tags will also be deleted.',
      one: ' Its 1 tag will also be deleted.',
      zero: '',
    );
    return 'Delete \"$name\"?$_temp0';
  }

  @override
  String get tagNameExists => 'There is a tag with this name already';

  @override
  String get categoryNameExists => 'There is a category with this name already';

  @override
  String deleteTemplateMessage(Object name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get addTagsTitle => 'Etiketler Ekle';

  @override
  String get addTagsSearchHint => 'Etiketleri ara…';

  @override
  String get tagPickerSortManualLabel => 'Manuel sıralama';

  @override
  String get tagPickerSortUsageLabel => 'Kullanıma göre sırala';

  @override
  String get tagFavoriteName => 'Favori';

  @override
  String get tagEnergyName => 'Enerji';

  @override
  String get tagCategoryActivitiesName => 'Aktiviteler';

  @override
  String get tagExerciseName => 'Egzersiz';

  @override
  String get tagSocializingName => 'Sosyalleşme';

  @override
  String get tagHobbyName => 'Hobi';

  @override
  String get tagEntertainmentName => 'Eğlence';

  @override
  String get tagDiningName => 'Yemek';

  @override
  String get tagChoresName => 'Ev işleri';

  @override
  String get tagCategoryEmotionsName => 'Duygular';

  @override
  String get tagExcitedName => 'Heyecanlı';

  @override
  String get tagGratefulName => 'Minnettar';

  @override
  String get tagCalmName => 'Sakin';

  @override
  String get tagTiredName => 'Yorgun';

  @override
  String get tagAnxiousName => 'Kaygılı';

  @override
  String get tagAnnoyedName => 'Sinirli';

  @override
  String get welcomeLogBodyText =>
      '## Welcome to AID Diary\n\n> A quiet place for your days.\n\nWrite what happened, how you felt, and where you were. Your entries stay on this device.\n\n- **Journal** lists every entry by day\n- **Calendar**, **Media** and **Atlas** look back by date, photo and place\n- **Coach** offers prompts and templates when you don\'t know what to write';

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
  String get settingsBackupPasswordProtect => 'Password Protect Backups';

  @override
  String get backupEncryptedTitle => 'Encrypted Backup';

  @override
  String get backupEncryptedContent => 'This backup is password protected.';

  @override
  String get settingsAutoBackup => 'Automatic Backups';

  @override
  String get settingsAutoBackupLocation => 'Backup Location';

  @override
  String get settingsAutoBackupInterval => 'Backup Interval';

  @override
  String get settingsAutoBackupIntervalDaily => 'Daily';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Weekly';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Monthly';

  @override
  String get settingsAutoBackupMaxCount => 'Backups To Keep';

  @override
  String get settingsAutoBackupRequireCharging => 'Only While Charging';

  @override
  String settingsBackupLast(Object time) {
    return 'Last backup $time';
  }

  @override
  String get settingsBackupNever => 'Never backed up';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Next backup $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'All';

  @override
  String get autoBackupFailedTitle => 'Backup Failed';

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
    return 'Encrypting Backup… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Decrypting Backup… $percent%';
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
  String get settingsLanguageTitle => 'Dil';

  @override
  String get settingsAppLanguageTitle => 'Uygulama Dili';

  @override
  String get settingsOverrideAppLanguageTitle => 'Uygulama Dilini Özelleştir';

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
  String get settingsOpenSourceLicenses => 'Open Source Licenses';

  @override
  String get tagMoodTitle => 'Ruh hâli';

  @override
  String get selectTagTitle => 'Etiket Seç';

  @override
  String get labelPresentLabel => 'Şimdi';

  @override
  String get labelAbsentLabel => 'Absent';

  @override
  String get labelCoverageLabel => 'Coverage';

  @override
  String chartDistributionTitle(Object tag) {
    return '$tag Distribution';
  }

  @override
  String get shareAddToLogPickerTitle => 'Choose a log';

  @override
  String get adaptiveEmptyDay => 'No entries for this day yet';

  @override
  String get adaptiveNewEntry => 'Write an entry';

  @override
  String get pageJournalTitle => 'Journal';

  @override
  String get coachPrompt1 => 'What made you smile today?';

  @override
  String get coachPrompt2 => 'What is one thing you learned today?';

  @override
  String get coachPrompt3 => 'Who did you talk to today, and how did it feel?';

  @override
  String get coachPrompt4 => 'What are you grateful for right now?';

  @override
  String get coachPrompt5 => 'What took most of your energy today?';

  @override
  String get coachPrompt6 => 'Describe a small moment you want to remember.';

  @override
  String get coachPrompt7 => 'What would make tomorrow a good day?';

  @override
  String get coachPrompt8 => 'What has been on your mind lately?';

  @override
  String get coachPrompt9 => 'What did you do today just for yourself?';

  @override
  String get coachPrompt10 => 'If today had a title, what would it be?';

  @override
  String get pageMediaTitle => 'Media';

  @override
  String get pageAtlasTitle => 'Atlas';

  @override
  String get pageCoachTitle => 'Coach';

  @override
  String get noEntrySelected => 'No entry selected.';

  @override
  String get entryShare => 'Share';

  @override
  String get entryFavorite => 'Star';

  @override
  String get entryEdit => 'Edit';

  @override
  String get entryPrevious => 'Previous entry';

  @override
  String get entryNext => 'Next entry';

  @override
  String get journalStories => 'Stories';

  @override
  String get journalEntries => 'Entries';

  @override
  String get journalEmptyHint => 'Begin your diary by adding a new entry.';

  @override
  String get storyToday => 'Today';

  @override
  String get storyThrowback => 'Throwback';

  @override
  String get storyNoThrowback => 'No throwback today';

  @override
  String get mediaFiles => 'Media files';

  @override
  String get mediaEmpty => 'No photos yet.';

  @override
  String get mediaEmptyHint => 'Photos attached to entries will be shown here.';

  @override
  String get atlasEmpty => 'No entries with a location.';

  @override
  String get atlasEmptyHint => 'Entries with a location will be shown here.';

  @override
  String get atlasShowAll => 'Show all entries';

  @override
  String get atlasMyLocation => 'My location';

  @override
  String get coachAll => 'All';

  @override
  String get coachPrograms => 'Programs';

  @override
  String get coachTemplates => 'Templates';

  @override
  String get coachKindProgram => 'Program';

  @override
  String get coachKindTemplate => 'Template';

  @override
  String get coachNoTemplates => 'No programs or templates.';

  @override
  String get coachUseTemplate => 'Write with this template';

  @override
  String get coachProgramEverydayTitle => 'Everyday moments';

  @override
  String get coachProgramEverydayDescription =>
      'Five short questions, one a day. Each takes a minute or two and helps you see what made the day yours. A gentle way to build the habit of writing a little every day.';

  @override
  String get coachProgramReflectTitle => 'Looking inward';

  @override
  String get coachProgramReflectDescription =>
      'One deeper question a week, for five weeks. Take your time with each: how you have been feeling, what wears you out, what you are grateful for.';

  @override
  String get searchFilters => 'Filters';

  @override
  String get searchFilterTags => 'Tags';

  @override
  String get searchFilterStarred => 'Starred';

  @override
  String get searchHint => 'Type to search, or pick a filter.';

  @override
  String get locationTitle => 'Location';

  @override
  String get locationName => 'Place name';

  @override
  String get locationRemove => 'Remove';

  @override
  String get locationServiceDisabled => 'Location services are turned off.';

  @override
  String get locationPermissionDenied => 'Location permission was denied.';

  @override
  String get locationUnavailable => 'Could not get the current location.';

  @override
  String get calendarJumpToToday => 'Jump to today';

  @override
  String get editorStartWriting => 'Start writing or choose a ';

  @override
  String get editorTemplateLink => 'Template';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Choose a template';

  @override
  String get templateFeatured => 'Featured templates';

  @override
  String get templateMine => 'My templates';

  @override
  String get templateDailyName => 'Daily review';

  @override
  String get templateDailyDescription =>
      'What happened, how it felt, and what comes next.';

  @override
  String get templateDailyText =>
      '## What happened today\n\n\n## How I felt\n\n\n## Three things I\'m grateful for\n1. \n2. \n3. \n\n## Tomorrow\n';

  @override
  String get templateTravelName => 'Travel log';

  @override
  String get templateTravelDescription =>
      'Places, moments and food from the road.';

  @override
  String get templateTravelText =>
      '## Where I went\n\n\n## The moment I remember most\n\n\n## What I ate\n\n\n## Plans for tomorrow\n';

  @override
  String get templateReadingName => 'Reading notes';

  @override
  String get templateReadingDescription =>
      'Quotes and thoughts from what you read.';

  @override
  String get templateReadingText =>
      '## Book\n\n\n## Where I am\n\n\n## Quotes\n> \n\n## My thoughts\n';

  @override
  String get templateWeeklyName => 'Weekly review';

  @override
  String get templateWeeklyDescription =>
      'Highlights, struggles and next week\'s focus.';

  @override
  String get templateWeeklyText =>
      '## Highlights\n\n\n## What was hard\n\n\n## What I learned\n\n\n## Focus for next week\n';

  @override
  String get entryDuplicate => 'Duplicate';

  @override
  String get entryDuplicated => 'Entry duplicated';

  @override
  String get entrySaveAsTemplate => 'Save as template';

  @override
  String get entrySavedAsTemplate => 'Saved as a template';

  @override
  String get storyStatistics => 'Statistics';

  @override
  String get storyMoodChart => 'Mood chart';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return '$entries entries · $days days';
  }

  @override
  String get storyThisYear => 'This year';

  @override
  String get storyLastYear => 'Last year';

  @override
  String get storyTapToOpen => 'Tap a day to open it';

  @override
  String get settingsGeneralTitle => 'General';

  @override
  String get settingsDataTitle => 'Data & storage';

  @override
  String get settingsStoriesTitle => 'Stories';

  @override
  String get settingsHelpTitle => 'Help & about';

  @override
  String get weatherTitle => 'Weather';

  @override
  String get weatherClear => 'Clear';

  @override
  String get weatherPartlyCloudy => 'Partly cloudy';

  @override
  String get weatherCloudy => 'Cloudy';

  @override
  String get weatherFog => 'Fog';

  @override
  String get weatherDrizzle => 'Drizzle';

  @override
  String get weatherRain => 'Rain';

  @override
  String get weatherSnow => 'Snow';

  @override
  String get weatherStorm => 'Thunderstorm';

  @override
  String get weatherFetch => 'Get weather for this entry';

  @override
  String get weatherNeedsLocation => 'Add a location with coordinates first.';

  @override
  String get weatherUnavailable =>
      'Weather is unavailable for this place and time.';

  @override
  String get weatherRemove => 'Remove weather';

  @override
  String get activityTitle => 'Activity';

  @override
  String get activityStill => 'Still';

  @override
  String get activityWalking => 'Walking';

  @override
  String get activityRunning => 'Running';

  @override
  String get activityCycling => 'Cycling';

  @override
  String get activityVehicle => 'In a vehicle';

  @override
  String get activityFlying => 'Flying';

  @override
  String get activityExercise => 'Exercise';

  @override
  String get activityDetect => 'Detect current activity';

  @override
  String get activityDetectFailed => 'Couldn\'t detect an activity.';

  @override
  String get activityRemove => 'Remove activity';

  @override
  String get settingsAutoAddTitle => 'Add automatically';

  @override
  String get settingsAutoAddLocation => 'Location';

  @override
  String get settingsAutoAddWeather => 'Weather';

  @override
  String get settingsAutoAddHint =>
      'New entries get these filled in when they are created.';

  @override
  String get settingsTemperatureUnit => 'Temperature unit';

  @override
  String get settingsCelsius => 'Celsius (°C)';

  @override
  String get settingsFahrenheit => 'Fahrenheit (°F)';

  @override
  String get moodGreat => 'Great';

  @override
  String get moodGood => 'Good';

  @override
  String get moodOkay => 'Okay';

  @override
  String get moodBad => 'Bad';

  @override
  String get moodAwful => 'Awful';

  @override
  String get locationSearchHint => 'Search for a place';

  @override
  String get locationSearchEmpty => 'No places found';

  @override
  String get settingsWallpaper => 'Wallpaper';

  @override
  String get wallpaperNone => 'None';

  @override
  String get wallpaperDots => 'Dots';

  @override
  String get wallpaperGrid => 'Grid';

  @override
  String get wallpaperLines => 'Lines';

  @override
  String get wallpaperPhoto => 'Photo…';

  @override
  String get settingsFontFamily => 'Font';

  @override
  String get fontSystem => 'System';

  @override
  String get fontSerif => 'Serif';

  @override
  String get fontMono => 'Monospace';

  @override
  String get settingsFontSize => 'Font size';

  @override
  String get fontSizeSmall => 'Small';

  @override
  String get fontSizeMedium => 'Medium';

  @override
  String get fontSizeLarge => 'Large';

  @override
  String get fontSizeExtraLarge => 'Extra large';

  @override
  String get settingsLineSpacing => 'Line spacing';

  @override
  String get lineSpacingCompact => 'Compact';

  @override
  String get lineSpacingNormal => 'Normal';

  @override
  String get lineSpacingRelaxed => 'Relaxed';

  @override
  String get moodAssociationsTitle => 'What makes me feel…';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching of $total entries';
  }

  @override
  String get videoRecord => 'Record a video';

  @override
  String get videoChoose => 'Choose a video';

  @override
  String get audioRecordTitle => 'Record a voice note';

  @override
  String get audioChoose => 'Choose an audio file';

  @override
  String get audioStart => 'Record';

  @override
  String get audioStop => 'Stop and save';

  @override
  String get audioPermissionDenied =>
      'Microphone access is off. Allow it in the system settings.';

  @override
  String get mediaTooLarge => 'This video is too large to attach.';

  @override
  String get mediaUnavailable =>
      'This attachment is not available on this device.';

  @override
  String get widgetDone => 'Today\'s entry is written';

  @override
  String get widgetPending => 'How was your day?';

  @override
  String get widgetWrite => 'Write';

  @override
  String get insertChecklist => 'Checklist';

  @override
  String get insertNumberedList => 'Numbered list';

  @override
  String get insertTable => 'Table';

  @override
  String get insertDivider => 'Divider';

  @override
  String get insertCodeBlock => 'Code block';

  @override
  String get journalSortTitle => 'Sort entries';

  @override
  String get journalSortUpdated => 'Last updated';

  @override
  String get settingsTimeFormat => 'Time format';

  @override
  String get settingsDayStart => 'New entries count for the day before until';

  @override
  String get settingsDayAskUntil => 'Then ask which day until';

  @override
  String get settingsDayStartMidnight => 'Off';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Every entry keeps the day it belongs to next to the time it was written, and you can change that day in the editor at any time. These hours only pick the day for new entries, so changing them moves no existing entry.';

  @override
  String get lateNightBadge =>
      'Written late at night, counted for the day before';

  @override
  String editorDayAsk(String time) {
    return 'Written at $time. Which day is it for?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (yesterday)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (today)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'Written $when';
  }

  @override
  String get timeFormat12 => '12-hour';

  @override
  String get timeFormat24 => '24-hour';

  @override
  String get settingsReminderDays => 'Remind me on';

  @override
  String get locationRecent => 'Recent places';

  @override
  String get shareImage => 'Share image';

  @override
  String get shareSaveImage => 'Save image';

  @override
  String get shareSaved => 'Image saved';

  @override
  String get deletedTitle => 'Recently deleted';

  @override
  String get deletedNone => 'Nothing deleted recently';

  @override
  String deletedHint(int days) {
    return 'Deleted entries stay here for $days days, then are erased.';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days days left';
  }

  @override
  String get deletedRestore => 'Restore';

  @override
  String get deletedDeleteForever => 'Delete forever';

  @override
  String get deletedDeleteForeverDescription =>
      'The entry and its attachments are erased. This cannot be undone.';

  @override
  String get deletedEmpty => 'Empty';

  @override
  String get deletedEmptyDescription =>
      'Erase every entry in Recently deleted? This cannot be undone.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Random walk';

  @override
  String get randomSubtitle => 'Open a past entry';

  @override
  String get randomNext => 'Another';

  @override
  String get randomAll => 'All';

  @override
  String get randomWithPhotos => 'With photos';

  @override
  String get randomGoodDays => 'Good days';

  @override
  String get randomEmpty => 'No entries to pick from';

  @override
  String get reviewWeekTitle => 'This week';

  @override
  String get reviewWeekSubtitle => 'Your week so far';

  @override
  String get reviewYearTitle => 'This year';

  @override
  String get reviewEmpty => 'Nothing written yet';

  @override
  String get reviewEntries => 'Entries';

  @override
  String get reviewDaysWritten => 'Days written';

  @override
  String get reviewWords => 'Words';

  @override
  String get reviewPhotos => 'Photos';

  @override
  String get reviewLongestRun => 'Longest run of days';

  @override
  String get reviewAverageMood => 'Average mood';

  @override
  String get reviewFavorites => 'Most often';

  @override
  String get reviewByMonth => 'By month';

  @override
  String get reviewHighlight => 'Highlight';

  @override
  String get yearInPixels => 'Year in pixels';

  @override
  String get capsuleSeal => 'Seal as a time capsule';

  @override
  String get capsuleTitle => 'Time capsule';

  @override
  String capsuleOpensOn(Object date) {
    return 'Opens on $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Written on $date';
  }

  @override
  String get capsuleOpenEarly => 'Open early';

  @override
  String get capsuleOpenEarlyDescription =>
      'The capsule opens now and stays open.';

  @override
  String get capsuleOpened => 'Time capsule opened';

  @override
  String get templateMorningName => 'Morning pages';

  @override
  String get templateMorningDescription => 'Set up the day in three minutes';

  @override
  String get templateMorningText =>
      '## Three things I want to do well today\n1. \n2. \n3. \n\n## Something I look forward to\n\n## A note to myself\n';

  @override
  String get templateEveningName => 'Evening review';

  @override
  String get templateEveningDescription => 'Close the day with what went well';

  @override
  String get templateEveningText =>
      '## Three good things today\n1. \n2. \n3. \n\n## What I learned\n\n## What could go better tomorrow\n';

  @override
  String get routineMorning => 'Good morning';

  @override
  String get routineEvening => 'Evening review';

  @override
  String get settingsRoutinePrompts => 'Morning and evening prompts';

  @override
  String get settingsRoutinePromptsHint =>
      'Suggest the morning or evening template in Stories';

  @override
  String get checkInTitle => 'Quick check-in';

  @override
  String get checkInSubtitle => 'Mood in two taps';

  @override
  String get checkInMood => 'How do you feel?';

  @override
  String get checkInActivity => 'What are you doing?';

  @override
  String get checkInNote => 'A line about it (optional)';

  @override
  String get checkInSave => 'Save';

  @override
  String editorWordCount(int words, int characters) {
    return '$words words · $characters characters';
  }

  @override
  String get coachProgramEverydayTagline => 'Notice the small things in a day.';

  @override
  String get coachProgramReflectTagline => 'Slow down and listen to yourself.';

  @override
  String get coachDuration => 'Duration';

  @override
  String get coachInterval => 'Interval';

  @override
  String get coachDifficulty => 'Difficulty';

  @override
  String get coachIntervalDaily => 'Daily';

  @override
  String get coachIntervalWeekly => 'Weekly';

  @override
  String get coachDifficultyBeginner => 'Beginner';

  @override
  String get coachDifficultyIntermediate => 'Intermediate';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks',
      one: '1 week',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'Day $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Week $n';
  }

  @override
  String get coachEnroll => 'Enroll';

  @override
  String get coachEndProgram => 'End program';

  @override
  String get coachAuthor => 'Author';

  @override
  String get coachAuthorBio => 'Prompts written for this app.';

  @override
  String get coachEnrolledTip =>
      'All set! Your questions will show up in Stories.';

  @override
  String get coachGoToStories => 'Go to Stories';

  @override
  String get coachAnswerHint => 'Write your answer…';

  @override
  String get storyWrapUp => 'That\'s all for today.';

  @override
  String get storyTapToClose => 'Tap to close';

  @override
  String get coachAnswerDone => 'Done';

  @override
  String get coachAnswered => 'Answered, tap to open';

  @override
  String get coachAnsweredEarlier => 'Answered';

  @override
  String get locationLocating => 'Locating…';

  @override
  String get locationPickPlace => 'Pick a place';

  @override
  String get locationPlacesHint => 'Address or name of the place';

  @override
  String get locationCustom => 'Custom place';

  @override
  String get locationCurrent => 'Current location';

  @override
  String get locationSaved => 'Saved places';

  @override
  String get locationSearchResults => 'Search results';

  @override
  String get locationNearby => 'Nearby places';

  @override
  String get locationRename => 'Rename';

  @override
  String get locationSavePlace => 'Save place';

  @override
  String get locationUnsavePlace => 'Remove from saved places';

  @override
  String get shareAs => 'Share as…';

  @override
  String get shareAsImage => 'Image';

  @override
  String get shareAsZip => 'ZIP with the original media';

  @override
  String get shareAsPlainText => 'Plain text';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Welcome to AID Diary';

  @override
  String get onboardWelcomeText =>
      'A quiet place for your days. Tap Next to look around.';

  @override
  String get onboardIntroTitle => 'Write a little, remember a lot';

  @override
  String get onboardIntroText =>
      'Photos, places, weather and moods sit beside your words. Stories bring old days back.';

  @override
  String get onboardPrivateTitle => 'Safe and private';

  @override
  String get onboardPrivateText =>
      'Your diary stays on this device. Add a passcode to keep it to yourself.';

  @override
  String get onboardPrivateAction => 'Set a passcode';

  @override
  String get onboardNotifyTitle => 'A gentle reminder';

  @override
  String get onboardNotifyText =>
      'Turn on reminders to build the habit; coach programs tell you when a new question is ready.';

  @override
  String get onboardNotifyAction => 'Turn on reminders';

  @override
  String get onboardNotifyOn => 'Reminders are on';

  @override
  String get onboardDoneTitle => 'All set';

  @override
  String get onboardDoneText =>
      'Start with today: what is one thing you want to remember?';

  @override
  String get onboardNext => 'Next';

  @override
  String get onboardBack => 'Back';

  @override
  String get onboardStart => 'Start writing';

  @override
  String get onboardSkip => 'Skip';

  @override
  String get helpFaq => 'Frequently asked questions';

  @override
  String get helpFaq1Q => 'Where is my diary stored?';

  @override
  String get helpFaq1A =>
      'Only on this device, in the app\'s own folder. Nothing is uploaded; there is no account.';

  @override
  String get helpFaq2Q => 'How do I keep a copy or move to a new device?';

  @override
  String get helpFaq2A =>
      'Settings → Data & storage → Backup & Restore makes one file with entries, photos and settings, optionally with a password. Restore it on the new device. Backups can also run on a schedule.';

  @override
  String get helpFaq3Q => 'Can I bring in entries from other diary apps?';

  @override
  String get helpFaq3A =>
      'Yes: in Settings → Data & storage, import exports from Daylio, Diarium, Diaro, DayBook, My Brain, OneShot and Pixels, or a JSON export.';

  @override
  String get helpFaq4Q => 'How do coach programs work?';

  @override
  String get helpFaq4A =>
      'Enroll in a program on the Coach page. Each day or week a new question waits in Stories; your answer is saved as an entry.';

  @override
  String get helpFaq5Q => 'What if I forget my passcode?';

  @override
  String get helpFaq5A =>
      'The passcode cannot be recovered, so keep a backup of your diary.';

  @override
  String get helpPrivacy => 'Privacy';

  @override
  String get helpPrivacyText =>
      'Entries, photos and settings never leave this device unless you share or back them up. The app only goes online for map tiles and place names (OpenStreetMap, Nominatim, Overpass) and weather (Open-Meteo), sending coordinates or a place name, never your writing.';

  @override
  String get photoMetaTitle => 'Use the photo\'s details?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Count this entry for $date and set its place to $place, as recorded in the photo?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Count this entry for $date, when the photo was taken?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Set this entry\'s place to $place, where the photo was taken?';
  }

  @override
  String get photoMetaApply => 'Use them';

  @override
  String get quickWriteTitle => 'Quick write';

  @override
  String get quickWriteText => 'Tap to start a new entry.';

  @override
  String get settingsQuickWriteTitle => 'Quick write in notifications';

  @override
  String get settingsQuickWriteDescription =>
      'Keep a notification that opens a new entry.';

  @override
  String get settingsNudgesTitle => 'Nudge me after a quiet stretch';

  @override
  String settingsNudgesDescription(int days) {
    return 'A gentle reminder when you haven\'t written for $days days.';
  }

  @override
  String get nudgeTitle => 'It\'s been a while';

  @override
  String get nudgeMonday => 'A new week: what are you looking forward to?';

  @override
  String get nudgeTuesday => 'Two lines are enough. How are you today?';

  @override
  String get nudgeWednesday =>
      'Halfway through the week. What stood out so far?';

  @override
  String get nudgeThursday => 'Anything small worth keeping from today?';

  @override
  String get nudgeFriday => 'The week is wrapping up. Note one good moment.';

  @override
  String get nudgeSaturday => 'A slow Saturday is a good day to write.';

  @override
  String get nudgeSunday => 'Look back on the week before it ends.';

  @override
  String get photoWidgetEmpty => 'Photos you add to entries show up here.';

  @override
  String get channelReminders => 'Reminders';

  @override
  String get channelOnThisDay => 'On this day';

  @override
  String get channelCoach => 'Coach prompts';

  @override
  String get channelNudges => 'Nudges after quiet days';

  @override
  String get channelQuickWrite => 'Quick write';

  @override
  String get channelBackup => 'Backups';

  @override
  String get formatJsonExport => 'JSON (AID Diary export)';

  @override
  String get aboutModifiedNotice =>
      'A modified version of Daily You by Demizo and contributors. It is not the official Daily You app.';

  @override
  String get toolbarPhotos => 'Add photos';

  @override
  String get toolbarMedia => 'Photos and videos';

  @override
  String get mediaFromGallery => 'Choose from gallery';

  @override
  String get mediaFromFiles => 'Choose from files';

  @override
  String get editorLeaveTitle => 'Save this entry?';

  @override
  String get editorLeaveDiscard => 'Don\'t save';

  @override
  String get editorTitleHint => 'Title';

  @override
  String get editorLocating => 'Locating…';

  @override
  String get toolbarVideo => 'Video';

  @override
  String get toolbarAudio => 'Voice note';

  @override
  String get toolbarTags => 'Tags';

  @override
  String get toolbarBulletList => 'Bulleted list';

  @override
  String get toolbarHeading => 'Heading';

  @override
  String get toolbarBold => 'Bold';

  @override
  String get toolbarItalic => 'Italic';

  @override
  String get toolbarHighlight => 'Highlight';

  @override
  String get toolbarStrikethrough => 'Strikethrough';

  @override
  String get toolbarQuote => 'Quote';

  @override
  String get toolbarLink => 'Link';

  @override
  String get toolbarInsert => 'Insert';

  @override
  String get toolbarUndo => 'Undo';

  @override
  String get toolbarRedo => 'Redo';

  @override
  String get toolbarInsertDate => 'Insert the date';

  @override
  String get toolbarInsertTime => 'Insert the time';

  @override
  String get settingsSyncTitle => 'Cloud Sync';

  @override
  String get syncOffDescription =>
      'Keep this diary the same on all your devices through Google Drive or a WebDAV server, such as Nextcloud, Synology or Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'Sync with Google Drive';

  @override
  String get syncOrWebDav => 'Or a WebDAV server';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn => 'Signed in. You can go back to AID Diary.';

  @override
  String get syncGoogleSignInAgain => 'Google needs you to sign in again.';

  @override
  String get syncSignInAgain => 'Sign in again';

  @override
  String get settingsCommandLineTitle => 'Command line';

  @override
  String get commandLineToggle => 'Command line interface';

  @override
  String get commandLineToggleHint =>
      'Lets the aid command and other programs on this device use the app\'s commands.';

  @override
  String get commandLineAlwaysOn => 'Always on in development builds.';

  @override
  String commandLineListening(int port) {
    return 'Listening on port $port';
  }

  @override
  String get commandPaletteTitle => 'All commands';

  @override
  String get commandPaletteSearch => 'Search commands';

  @override
  String get commandPaletteRun => 'Run';

  @override
  String get commandPaletteConfirm => 'This cannot simply be undone. Run it?';

  @override
  String syncReceiving(int done, int total) {
    return 'Receiving $done of $total…';
  }

  @override
  String syncSending(int done, int total) {
    return 'Sending $done of $total…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'Access to Google Drive was not allowed. Connect again and tick Google Drive on Google\'s page.';

  @override
  String get syncEntryUnsynced =>
      'Not synced: the last sync did not go through';

  @override
  String get syncUseOfficial => 'Use the AID sync server';

  @override
  String get syncServer => 'Server address';

  @override
  String get syncUsername => 'Username';

  @override
  String get syncPassword => 'Password';

  @override
  String get syncConnect => 'Connect';

  @override
  String get syncConnecting => 'Connecting…';

  @override
  String get syncSignInFailed =>
      'Could not sign in. Check the address, the username and the password.';

  @override
  String syncConnectFailed(String error) {
    return 'Could not connect: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Start syncing';

  @override
  String get syncNewSpaceDescription =>
      'There is no synced diary here yet. This diary will be uploaded, end-to-end encrypted with a key that stays on your devices.';

  @override
  String get syncJoinTitle => 'Join the synced diary';

  @override
  String get syncWrongKey =>
      'This recovery code does not open the synced diary.';

  @override
  String syncLastSynced(String time) {
    return 'Last synced $time';
  }

  @override
  String get syncNever => 'Not synced yet';

  @override
  String get syncSyncing => 'Syncing…';

  @override
  String syncFailed(String error) {
    return 'The last sync failed: $error';
  }

  @override
  String get syncLocked =>
      'The synced diary now belongs to other devices, or was started over. Pair with one of them or use the recovery code to keep syncing.';

  @override
  String get syncNow => 'Sync now';

  @override
  String get syncUnlock => 'Unlock';

  @override
  String get syncEncrypted => 'End-to-end encrypted';

  @override
  String get syncDisconnect => 'Stop syncing';

  @override
  String get syncDisconnectDescription =>
      'This device stops syncing. The diary here and the synced copy stay as they are.';

  @override
  String get syncOwnRecoveryPassword => 'Use my own recovery password';

  @override
  String get syncRecoveryPassword => 'Recovery password';

  @override
  String get syncRecoveryPasswordRepeat => 'Repeat the recovery password';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Use at least $min characters';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'The passwords differ';

  @override
  String get syncRecoveryCode => 'Recovery code';

  @override
  String get syncRecoveryCodeTitle => 'Save your recovery code';

  @override
  String get syncRecoveryCodeDescription =>
      'If every device of yours is lost, this code restores your synced diary. Keep it in a password manager or on paper. It is shown only this once.';

  @override
  String get syncRecoveryCodeCopied => 'Recovery code copied';

  @override
  String get syncRecoveryCodeSaved => 'I have saved it';

  @override
  String get syncJoinNeedsKey =>
      'This synced diary belongs to your other devices. Pair with one of them, or use the recovery code. The entries on this device will be added to it.';

  @override
  String get syncPairDevice => 'Pair with a device';

  @override
  String get syncUseRecoveryCode => 'Use the recovery code';

  @override
  String get syncAddDevice => 'Add a device';

  @override
  String get syncChangeRecoveryCode => 'Change the recovery code';

  @override
  String get syncChangeRecoveryDescription =>
      'A new code replaces the current one, which stops working. Your data and other devices stay as they are.';

  @override
  String get syncNewRandomCode => 'New random code';

  @override
  String get syncRecoveryCodeChanged => 'Recovery code changed';

  @override
  String get syncResetSpace => 'Start the synced diary over';

  @override
  String get syncResetSpaceDescription =>
      'Only when no device and no recovery code opens it any more: the synced copy is replaced by the diary on this device, under this device\'s keys. Your other devices then pair again.';

  @override
  String get syncPairTitle => 'Pair devices';

  @override
  String get syncPairShow => 'Show a code';

  @override
  String get syncPairEnter => 'Enter a code';

  @override
  String get syncPairShowHint =>
      'On your other device, open Pair devices, choose Enter a code, and type or scan this.';

  @override
  String get syncPairEnterHint =>
      'Type the code your other device shows, or scan it.';

  @override
  String get syncPairCode => 'Pairing code';

  @override
  String get syncPairScan => 'Scan';

  @override
  String get syncPairStart => 'Pair';

  @override
  String get syncPairWaiting => 'Waiting for the other device…';

  @override
  String syncPairDone(String device) {
    return 'Paired with $device';
  }

  @override
  String get syncPairWrongCode =>
      'The code did not match. Show a new code and try again.';

  @override
  String get syncPairNoOffer =>
      'No device shows this code. It may have expired.';

  @override
  String get syncPairTimedOut => 'The other device did not answer in time.';

  @override
  String get syncPairNeither =>
      'Neither device is set up with this synced diary yet.';

  @override
  String get syncPairBoth => 'Both devices already open this synced diary.';

  @override
  String syncPairFailed(String error) {
    return 'Pairing failed: $error';
  }

  @override
  String get syncMediaPending =>
      'Diary synced · some media is still transferring';

  @override
  String get syncWaitingForDevices =>
      'Diary synced · waiting for another device to transfer media';

  @override
  String get syncCacheNotice =>
      'Cloud media is temporary. Keep the originals on your devices; syncing is not a backup.';

  @override
  String get paperTitle => 'Letter paper';

  @override
  String get paperPlain => 'Plain';

  @override
  String get paperLined => 'Lined';

  @override
  String get paperGrid => 'Grid';

  @override
  String get paperTinted => 'Tinted';

  @override
  String get paperDecorationTitle => 'Decorations';

  @override
  String get paperDecorationNone => 'None';

  @override
  String get paperDecorationBotanical => 'Leaves';

  @override
  String get paperDecorationStars => 'Stars';

  @override
  String get paperDecorationWashi => 'Washi tape';

  @override
  String get themeDarkChoice => 'Dark appearance';

  @override
  String get themeDarkSame => 'Follow light palette';

  @override
  String get themeDarkCustom => 'Separate palette';

  @override
  String get themeDarkAccent => 'Dark accent colour';

  @override
  String get themeColorTeal => 'Teal';

  @override
  String get themeColorCyan => 'Cyan';

  @override
  String get themeColorIndigo => 'Indigo';

  @override
  String get themeColorCoral => 'Coral';

  @override
  String get themeColorOlive => 'Olive';

  @override
  String get themeColorSlate => 'Slate';

  @override
  String get drawingTitle => 'Drawing';

  @override
  String get drawingPen => 'Pen';

  @override
  String get drawingEraser => 'Eraser';

  @override
  String get drawingUndo => 'Undo';

  @override
  String get drawingClear => 'Clear';

  @override
  String get drawingWidth => 'Pen width';

  @override
  String get drawingStylusOnly => 'Stylus only';

  @override
  String get drawingDiscardTitle => 'Discard drawing?';

  @override
  String get drawingDiscardBody => 'This drawing has not been saved.';

  @override
  String get drawingSaveError => 'Could not save the drawing.';

  @override
  String get syncNetworkTitle => 'Network diagnostics';

  @override
  String get syncNetworkRefresh => 'Refresh';

  @override
  String get syncNetworkSelectedRoute => 'Current path';

  @override
  String get syncNetworkAvailableRoutes => 'Available paths';

  @override
  String get syncNetworkSignaling => 'Device directory connection';

  @override
  String get syncNetworkRelayRemaining => 'Remaining relay allowance';

  @override
  String get syncNetworkIcePair => 'Direct connection candidates';

  @override
  String get syncNetworkPeerTrusted => 'Authenticated device';

  @override
  String get syncNetworkNoRoute => 'Waiting for a connection';

  @override
  String get syncNetworkUnavailable => 'Diagnostics are unavailable';

  @override
  String get syncMediaCopiesTitle => 'Media delivery and copies';

  @override
  String get syncMediaPendingCount => 'Waiting to transfer';

  @override
  String get syncMediaDurableCount => 'Delivered to personal storage';

  @override
  String get syncMediaTemporaryCount => 'Temporary or unconfirmed copies';

  @override
  String get syncMediaReceiptExplanation =>
      'These counts describe completed deliveries, not a fresh audit of surviving backups.';

  @override
  String get syncMediaCacheExplanation =>
      'Temporary cloud media can expire. Keep your originals or a separate backup.';

  @override
  String get momentsTitle => 'Photo moments';

  @override
  String get momentsHint =>
      'Find groups using local photo times and optional coordinates. Photos are attached only when you choose a card.';

  @override
  String get momentsScan => 'Find moments';

  @override
  String get momentsChooseFolder => 'Choose photo folder';

  @override
  String get momentsLocation => 'Include photo locations';

  @override
  String get momentsEmpty => 'No recent photo groups.';

  @override
  String get momentsCreate => 'Write about these photos';

  @override
  String get momentsDismiss => 'Dismiss';

  @override
  String get momentsError => 'Could not read local photos.';

  @override
  String get momentsCreated => 'Photo entry created.';

  @override
  String get momentsPermission =>
      'Allow access to photos to find local suggestions.';

  @override
  String get momentsScope =>
      'Recent photos only; at most 500 photos and 20 photos per card.';

  @override
  String momentsPhotoCount(int count) {
    return '$count photos';
  }

  @override
  String get nearbyTitle => 'Nearby device transfer';

  @override
  String get nearbySend => 'This is the old device';

  @override
  String get nearbyReceive => 'This is the new device';

  @override
  String get nearbyInstructions =>
      'Connect both devices to the same Wi-Fi or connect one to the other’s hotspot. This transfer works without Internet.';

  @override
  String get nearbyCompare =>
      'Compare this code on both devices before approving.';

  @override
  String get nearbyConfirm => 'The codes match';

  @override
  String get nearbyScan => 'Scan old device QR';

  @override
  String get nearbyPaste => 'Paste invitation';

  @override
  String get nearbyWaiting => 'Waiting for approval on the other device';

  @override
  String get nearbyWorking => 'Transferring diary and attachments…';

  @override
  String get nearbyPending =>
      'Some attachments are still pending. Keep the old device open and retry.';

  @override
  String get nearbyComplete => 'Diary and attachments transferred';

  @override
  String get nearbyFailed =>
      'Could not complete the transfer. Check the local connection and retry.';

  @override
  String get nearbyEmptyRequired =>
      'Use a new device with no diary entries and no connected sync account.';

  @override
  String get nearbyRetry => 'Continue transfer';

  @override
  String get nearbyWifi => 'Wi-Fi settings';

  @override
  String get nearbyHotspot => 'Hotspot settings';

  @override
  String get nearbyKeepOpen =>
      'Keep this page open until the new device finishes. The invitation expires after two minutes.';

  @override
  String get syncDevicesTitle => 'Authorized devices';

  @override
  String get syncDevicesDescription =>
      'Only approved devices can access this AID account. Revoking a device blocks the server but cannot erase a master key or diary already copied to it.';

  @override
  String get syncDeviceRequest =>
      'Show this authorization QR to an approved device';

  @override
  String get syncDeviceAuthorize => 'Authorize a device';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Scan or paste the new device’s authorization request.';

  @override
  String get syncDeviceRevoke => 'Revoke';

  @override
  String get syncDeviceRotate => 'Rotate this device’s signing key';

  @override
  String get syncDeviceCheck => 'Check authorization';

  @override
  String get syncDeviceHardware => 'Hardware-backed signing key';

  @override
  String get syncDeviceSoftware => 'Non-exportable software signing key';

  @override
  String get syncDeviceUnavailable =>
      'Device authorization is unavailable. Approve this device from another authorized device and retry.';

  @override
  String get syncDeviceRevoked => 'Revoked';

  @override
  String get syncDeviceLocal => 'This device';

  @override
  String get cloudTrafficTitle => 'Monthly cloud media allowance';

  @override
  String get cloudTrafficLimit => 'Monthly allowance';

  @override
  String get cloudTrafficUsed => 'Used';

  @override
  String get cloudTrafficRemaining => 'Remaining';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'Resets $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'Cloud media allowance used up. Missing media will resume automatically over a direct connection or when the allowance resets.';

  @override
  String get cloudTrafficExplanation =>
      'Media cache and live relay share this allowance. Direct connections do not use it. Diary text and connection control have separate small daily limits.';

  @override
  String get appearanceThemeSection => 'App theme';

  @override
  String get appearancePaperSection => 'Diary paper';

  @override
  String get appearanceTypographySection => 'Diary text';

  @override
  String get appearancePreferencesSection => 'General preferences';

  @override
  String get themeSystemAccentHint =>
      'Uses the system palette instead of custom colors. Turn it off to choose your own.';
}
