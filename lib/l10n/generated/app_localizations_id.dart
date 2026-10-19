// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => 'Theme color';

  @override
  String get themeColorHint =>
      'Pick a color to stop following the system accent. Applies to light and dark themes.';

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
  String get dailyReminderTitle => 'Log hari ini!';

  @override
  String get dailyReminderDescription => 'Ambil log harian Anda…';

  @override
  String get actionTakePhoto => 'Ambil foto';

  @override
  String get actionToday => 'Hari ini';

  @override
  String get actionOtherDay => 'Hari lain';

  @override
  String get pageHomeTitle => 'Beranda';

  @override
  String get jumpToMonthTitle => 'Lompat ke bulan';

  @override
  String get jumpToLogTitle => 'Lompat ke log';

  @override
  String get flashbacksTitle => 'Kilas balik';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Kecualikan hari buruk';

  @override
  String get flaskbacksEmpty => 'Belum ada kilas balik…';

  @override
  String get flashbackGoodDay => 'Hari yang baik';

  @override
  String get flashbackRandomDay => 'Hari yang acak';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Weeks Ago',
      one: '$count Week Ago',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Months Ago',
      one: '$count Month Ago',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Years Ago',
      one: '$count Year Ago',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'Pada Hari Ini';

  @override
  String get pageGalleryTitle => 'Galeri';

  @override
  String get searchLogsHint => 'Cari log…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count logs',
      one: '$count log',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hari',
      one: '$count hari',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kata',
      one: '$count kata',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Tidak ada log…';

  @override
  String get noResults => 'Tidak Ada Hasil…';

  @override
  String get sortDateTitle => 'Tanggal';

  @override
  String get sortOrderAscendingTitle => 'Naik';

  @override
  String get sortOrderDescendingTitle => 'Turun';

  @override
  String get pageStatisticsTitle => 'Statistik';

  @override
  String get statisticsNotEnoughData => 'Tidak cukup data…';

  @override
  String get statisticsRangeOneMonth => '1 Bulan';

  @override
  String get statisticsRangeSixMonths => '6 Bulan';

  @override
  String get statisticsRangeOneYear => '1 Tahun';

  @override
  String get statisticsRangeAllTime => 'Sepanjang Waktu';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag Rangkuman';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag Perhari';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag Seiring Waktu';
  }

  @override
  String get chartGroupingLabel => 'Kelompokkan berdasarkan';

  @override
  String get chartGroupingDay => 'Hari';

  @override
  String get chartGroupingWeek => 'Minggu';

  @override
  String get chartGroupingMonth => 'Bulan';

  @override
  String get chartGroupingYear => 'Tahun';

  @override
  String get chartSmoothingLabel => 'Penghalusan';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Beruntun Saat ini $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Beruntun terpanjang $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hari Hebat $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hari dimulai dari hari yang buruk $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Tidak bisa mengakses penyimpanan eksternal';

  @override
  String get errorExternalStorageAccessDescription =>
      'Jika Anda menggunakan penyimpanan jaringan, pastikan layanan ini online dan Anda memiliki akses jaringan.\n\nJika tidak, aplikasi mungkin kehilangan izin untuk folder eksternal. Buka Pengaturan, dan pilih kembali folder eksternal untuk memberikan akses.\n\nPeringatan, perubahan tidak akan disinkronkan sampai Anda mengembalikan akses ke lokasi penyimpanan eksternal!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Lanjutkan dengan database lokal';

  @override
  String get databaseMigrationErrorTitle => 'Tidak Dapat Memindahkan Data Anda';

  @override
  String get databaseMigrationErrorDescription =>
      'Entri Anda aman tetapi tidak dapat dipindahkan ke penyimpanan aplikasi.\n\nCoba lagi, dan laporkan masalah ini jika terus terjadi.';

  @override
  String get databaseMigrationErrorRetry => 'Coba Lagi';

  @override
  String get errorReport => 'Laporkan Masalah';

  @override
  String get lastModified => 'Diubah';

  @override
  String get writeSomethingHint => 'Tulis sesuatu…';

  @override
  String get titleHint => 'Judul…';

  @override
  String get deleteLogTitle => 'Hapus Log';

  @override
  String get deleteLogDescription => 'Apakah Anda ingin menghapus log ini?';

  @override
  String get deletePhotoTitle => 'Hapus Photo';

  @override
  String get deletePhotoDescription => 'Apakah Anda ingin menghapus foto ini?';

  @override
  String get pageSettingsTitle => 'Pengaturan';

  @override
  String get settingsAppearanceTitle => 'Penampilan';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get themeAmoled => 'Hitam Amoled';

  @override
  String get settingsFirstDayOfWeek => 'Hari pertama dalam seminggu';

  @override
  String get settingsCalendarSystem => 'Sistem Kalender';

  @override
  String get calendarSystemGregorian => 'Gregorian';

  @override
  String get calendarSystemJalali => 'Jalali';

  @override
  String get settingsUseSystemAccentColor => 'Gunakan warna aksen sistem';

  @override
  String get settingsCustomAccentColor => 'Warna aksen khusus';

  @override
  String get settingsShowMarkdownToolbar => 'Tampilkan Markdown Toolbar';

  @override
  String get settingsShowFlashbacks => 'Tampilkan Kilas Balik';

  @override
  String get settingsChangeMoodIcons => 'Ubah ikon suasana hati';

  @override
  String get moodIconPrompt => 'Masukkan ikon';

  @override
  String get settingsFlashbacksViewLayout => 'Tata Letak Tampilan Kilas Balik';

  @override
  String get settingsHideImagesInGallery => 'Sembunyikan Gambar di Galeri';

  @override
  String get settingsHideImages => 'Sembunyikan Gambar';

  @override
  String get pageCalendarTitle => 'Kalender';

  @override
  String get settingsNotificationsTitle => 'Pemberitahuan';

  @override
  String get settingsDailyReminderOnboarding =>
      'Aktifkan pengingat harian untuk menjaga konsistensi Anda!';

  @override
  String get settingsNotificationsPermissionsPrompt =>
      'Izin \'jadwalkan alarm\' akan diminta untuk mengirim pengingat pada waktu acak atau pada waktu yang Anda inginkan.';

  @override
  String get settingsDailyReminderTitle => 'Pengingat harian';

  @override
  String get settingsOnThisDayDescription => 'Kunjungi kembali kenangan lama';

  @override
  String get settingsDailyReminderDescription => 'Pengingat lembut setiap hari';

  @override
  String get settingsReminderTime => 'Waktu penginggat';

  @override
  String get settingsFixedReminderTimeTitle => 'Memperbaiki waktu pengingat';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Pilih waktu yang tetap untuk pengingat';

  @override
  String get settingsAlwaysSendReminderTitle => 'Selalu Kirim Pengingat';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Kirim pengingat meskipun catatan sudah dimulai';

  @override
  String get settingsCustomizeNotificationTitle => 'Sesuaikan Notifikasi';

  @override
  String get settingsTemplatesTitle => 'Template';

  @override
  String get settingsDefaultTemplate => 'Template Baku';

  @override
  String get manageTemplates => 'Atur Template';

  @override
  String get addTemplate => 'Tambahkan template';

  @override
  String get newTemplate => 'Template Baru';

  @override
  String get noTemplateTitle => 'Ga ada';

  @override
  String get noTemplatesDescription => 'Belum ada template yang dibuat…';

  @override
  String get templateVariableTime => 'Waktu';

  @override
  String get templateDefaultTimestampTitle => 'Stempel waktu';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Ringkasan Hari';

  @override
  String get templateDefaultSummaryBody =>
      '### Ringkasan\n- \n\n### Kutipan\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Refleksi';

  @override
  String get templateDefaultReflectionBody =>
      '### Apa yang Anda nikmati hari ini?\n- \n\n### Apa yang Anda syukuri?\n- \n\n### Apa yang Anda nantikan?\n- ';

  @override
  String get settingsTagsTitle => 'Tag';

  @override
  String get manageTags => 'Kelola Tag';

  @override
  String get tagTypeLabelTitle => 'Label';

  @override
  String get tagTypeTrackerTitle => 'Pelacak';

  @override
  String get nameHint => 'Nama';

  @override
  String get tagColorLabel => 'Warna';

  @override
  String get iconPickerTitle => 'Pilih Ikon';

  @override
  String get iconPickerIconsTab => 'Ikon';

  @override
  String get iconPickerCustomTab => 'Kustom';

  @override
  String get iconPickerSearchHint => 'Cari ikon…';

  @override
  String get colorPickerTitle => 'Pilih Warna';

  @override
  String get colorPickerPaletteTab => 'Warna';

  @override
  String get iconGroupMoodPeople => 'Suasana Hati & Orang';

  @override
  String get iconGroupHealth => 'Kesehatan';

  @override
  String get iconGroupWorkFinance => 'Pekerjaan & Keuangan';

  @override
  String get iconGroupHabitsGoals => 'Kebiasaan & Sasaran';

  @override
  String get iconGroupNature => 'Alam';

  @override
  String get iconGroupFoodDrink => 'Makanan & Minuman';

  @override
  String get iconGroupHome => 'Home';

  @override
  String get iconGroupTravel => 'Perjalanan';

  @override
  String get iconGroupSymbols => 'Simbol';

  @override
  String get tagCategoryLabel => 'Kategori';

  @override
  String get tagLabel => 'Tag';

  @override
  String get tagCategoryUncategorized => 'Tanpa Kategori';

  @override
  String get newCategoryTitle => 'Kategori Baru';

  @override
  String get shareButtonLabel => 'Share';

  @override
  String get importErrorDescription => 'Failed to import file!';

  @override
  String get exportErrorDescription => 'Failed to export file!';

  @override
  String get deleteTitle => 'Hapus';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Ini digunakan dalam $count log.',
      one: ' Ini digunakan dalam 1 log.',
      zero: '',
    );
    return 'Hapus \"$name\"?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' $count tag miliknya juga akan dihapus.',
      one: ' 1 tag miliknya juga akan dihapus.',
      zero: '',
    );
    return 'Hapus \"$name\"?$_temp0';
  }

  @override
  String deleteTemplateMessage(Object name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get filterTagsTitle => 'Filter';

  @override
  String get tagFilterModeAny => 'Tag Apa Pun';

  @override
  String get tagFilterModeAll => 'Semua Tag';

  @override
  String get clearAllFilters => 'Bersihkan Semua';

  @override
  String get noTagsFilterLabel => 'Tanpa Tag';

  @override
  String get addTagsTitle => 'Tambahkan Tag';

  @override
  String get addTagsSearchHint => 'Cari tag…';

  @override
  String get tagPickerSortManualLabel => 'Urutan manual';

  @override
  String get tagPickerSortUsageLabel => 'Urutkan berdasarkan penggunaan';

  @override
  String get tagFavoriteName => 'Favorit';

  @override
  String get tagEnergyName => 'Energi';

  @override
  String get tagCategoryActivitiesName => 'Aktivitas';

  @override
  String get tagExerciseName => 'Olahraga';

  @override
  String get tagSocializingName => 'Bersosialisasi';

  @override
  String get tagHobbyName => 'Hobi';

  @override
  String get tagEntertainmentName => 'Hiburan';

  @override
  String get tagDiningName => 'Bersantap';

  @override
  String get tagChoresName => 'Pekerjaan rumah';

  @override
  String get tagCategoryEmotionsName => 'Emosi';

  @override
  String get tagExcitedName => 'Bersemangat';

  @override
  String get tagGratefulName => 'Bersyukur';

  @override
  String get tagCalmName => 'Tenang';

  @override
  String get tagTiredName => 'Lelah';

  @override
  String get tagAnxiousName => 'Cemas';

  @override
  String get tagAnnoyedName => 'Kesal';

  @override
  String get welcomeLogBodyText =>
      '## Welcome to AID Diary\n\n> Every day is worth remembering.\n\nWrite what happened, how you felt, and where you were. Your entries stay on this device.\n\n- **Journal** lists every entry by day\n- **Calendar**, **Media** and **Atlas** look back by date, photo and place\n- **Coach** offers prompts and templates when you don\'t know what to write\n\nAID Diary is a modified version of [Daily You](https://github.com/Demizo/Daily_You) by Demizo and contributors, and not the official Daily You app.';

  @override
  String get settingsStorageTitle => 'Penyimpanan';

  @override
  String get settingsImageQuality => 'Kualitas Gambar';

  @override
  String get imageQualityHigh => 'Tinggi';

  @override
  String get imageQualityMedium => 'Sedang';

  @override
  String get imageQualityLow => 'Rendah';

  @override
  String get imageQualityNoCompression => 'Tidak dikompres';

  @override
  String get settingsLogFolder => 'Folder Log';

  @override
  String get settingsImageFolder => 'Folder gambar';

  @override
  String get warningTitle => 'Hati hati';

  @override
  String get logFolderWarningDescription =>
      'Jika folder yang dipilih sudah berisi file \'daily_you.db\', itu akan digunakan untuk menimpa log Anda yang ada!';

  @override
  String get errorTitle => 'Eror';

  @override
  String get logFolderErrorDescription => 'Gagal Mengubah Folder Log!';

  @override
  String get imageFolderErrorDescription => 'Gagal Mengubah Folder Gambar!';

  @override
  String get backupErrorDescription => 'Gagal membuat cadangan!';

  @override
  String get restoreErrorDescription => 'Gagal memulihkan cadangan!';

  @override
  String get settingsBackupRestoreTitle => 'Cadangkan & Pulihkan';

  @override
  String get settingsBackup => 'Cadangan';

  @override
  String get settingsRestore => 'Pulihkan';

  @override
  String get settingsRestorePromptDescription =>
      'Memulihkan cadangan akan menimpa data yang sudah ada!';

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
    return 'Mentransfer... $percent';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Membuat cadangan… $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Memulihkan Cadangan… $percent%';
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
  String get cleanUpStatus => 'Membersihkan…';

  @override
  String migratingImagesStatus(Object current, Object total) {
    return 'Memigrasikan foto… $current/$total';
  }

  @override
  String get settingsExport => 'Eksport';

  @override
  String get settingsExportToAnotherFormat => 'Ekspor ke Format Lain';

  @override
  String get settingsExportFormatDescription =>
      'Ini tidak boleh digunakan sebagai cadangan!';

  @override
  String get exportLogs => 'Ekspor Log';

  @override
  String get exportImages => 'Ekspor Gambar';

  @override
  String get settingsImport => 'Impor';

  @override
  String get settingsImportFromAnotherApp => 'Impor dari Aplikasi Lain';

  @override
  String get settingsTranslateCallToAction =>
      'Semua orang berhak memiliki akses ke jurnal!';

  @override
  String get settingsHelpTranslate => 'Bantu Terjemahkan';

  @override
  String get importLogs => 'Impor log';

  @override
  String get importImages => 'Impor gambar';

  @override
  String get logFormatTitle => 'Pilih Format';

  @override
  String get logFormatDescription =>
      'Format aplikasi lain mungkin tidak mendukung semua fitur. Harap laporkan masalah apa pun karena format pihak ketiga dapat berubah sewaktu-waktu. Ini tidak akan memengaruhi catatan yang sudah ada!';

  @override
  String get formatDailyYouJson => 'Daily You (JSON)';

  @override
  String get formatDaybook => 'Daybook';

  @override
  String get formatDaylio => 'Daylio';

  @override
  String get formatDiarium => 'Diarium';

  @override
  String get formatDiaro => 'Diaro';

  @override
  String get formatMyBrain => 'My Brain';

  @override
  String get formatOneShot => 'Satu kali photo';

  @override
  String get formatPixels => 'Pixels';

  @override
  String get formatMarkdown => 'Markdown';

  @override
  String get settingsDeleteAllLogsTitle => 'Hapus semua log';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Apakah Anda ingin menghapus semua log Anda?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Masukkan \'$prompt\' untuk mengonfirmasi. Ini tidak dapat dibatalkan!';
  }

  @override
  String get settingsLanguageTitle => 'Bahasa';

  @override
  String get settingsAppLanguageTitle => 'Bahasa Aplikasi';

  @override
  String get settingsOverrideAppLanguageTitle => 'Ganti Bahasa Aplikasi';

  @override
  String get settingsSecurityTitle => 'Keamanan';

  @override
  String get settingsSecurityRequirePassword => 'Wajibkan Kata Sandi';

  @override
  String get settingsSecurityEnterPassword => 'Masukkan Kata Sandi';

  @override
  String get settingsSecuritySetPassword => 'Atur Kata Sandi';

  @override
  String get settingsSecurityChangePassword => 'Ubah Kata Sandi';

  @override
  String get settingsSecurityPassword => 'Kata Sandi';

  @override
  String get settingsSecurityConfirmPassword => 'Konfirmasi Kata Sandi';

  @override
  String get settingsSecurityOldPassword => 'Kata Sandi Lama';

  @override
  String get settingsSecurityIncorrectPassword => 'Kata Sandi Salah';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'Kata sandi tidak cocok';

  @override
  String get requiredPrompt => 'Wajib diisi';

  @override
  String get settingsSecurityBiometricUnlock => 'Buka Kunci Biometrik';

  @override
  String get unlockAppPrompt => 'Buka kunci aplikasi';

  @override
  String get settingsAboutTitle => 'Tentang';

  @override
  String get settingsVersion => 'Versi';

  @override
  String get settingsLicense => 'Lisensi';

  @override
  String get licenseGPLv3 => 'GPL -3.0';

  @override
  String get settingsSourceCode => 'Sumber kode';

  @override
  String get settingsOpenSourceLicenses => 'Open Source Licenses';

  @override
  String get settingsMadeWithLove => 'Dibuat dengan ❤️';

  @override
  String get settingsConsiderSupporting => 'pertimbangkan untuk mendukung';

  @override
  String get imagesTitle => 'Gambar';

  @override
  String get tagMoodTitle => 'Perasaan';

  @override
  String get calendarTagDisplayLabel => 'Tag';

  @override
  String get selectTagTitle => 'Pilih Tag';

  @override
  String get labelPresentLabel => 'Ada';

  @override
  String get labelAbsentLabel => 'Tidak Ada';

  @override
  String get labelCoverageLabel => 'Cakupan';

  @override
  String chartDistributionTitle(Object tag) {
    return 'Distribusi $tag';
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
  String get coachWritePrompt => 'Write about it';

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
  String entryReadingTime(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count min read',
      one: '1 min read',
    );
    return '$_temp0';
  }

  @override
  String get pageMediaTitle => 'Media';

  @override
  String get pageAtlasTitle => 'Atlas';

  @override
  String get pageCoachTitle => 'Coach';

  @override
  String get noEntrySelected => 'No entry selected.';

  @override
  String get profileLocalOnly => 'Your diary stays on this device';

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
      'Short questions that help you notice the small things in a day.';

  @override
  String get coachProgramReflectTitle => 'Looking inward';

  @override
  String get coachProgramReflectDescription =>
      'Questions for slowing down and understanding how you feel.';

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
  String get locationNoCoordinates => 'No coordinates';

  @override
  String get locationUseCurrent => 'Use current location';

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
}
