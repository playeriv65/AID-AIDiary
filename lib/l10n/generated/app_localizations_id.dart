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
  String get flashbacksTitle => 'Kilas balik';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Kecualikan hari buruk';

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
  String get settingsShowFlashbacks => 'Tampilkan Kilas Balik';

  @override
  String get settingsChangeMoodIcons => 'Ubah ikon suasana hati';

  @override
  String get moodIconPrompt => 'Masukkan ikon';

  @override
  String get settingsHideImages => 'Sembunyikan Gambar';

  @override
  String get pageCalendarTitle => 'Kalender';

  @override
  String get settingsNotificationsTitle => 'Pemberitahuan';

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
  String get manageTemplates => 'Atur Template';

  @override
  String get noTemplateTitle => 'Ga ada';

  @override
  String get noTemplatesDescription => 'Belum ada template yang dibuat…';

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
      '## Welcome to AID Diary\n\n> A quiet place for your days.\n\nWrite what happened, how you felt, and where you were. Your entries stay on this device.\n\n- **Journal** lists every entry by day\n- **Calendar**, **Media** and **Atlas** look back by date, photo and place\n- **Coach** offers prompts and templates when you don\'t know what to write';

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
      'Jika folder yang dipilih sudah berisi file \'aid_diary.db\', itu akan digunakan untuk menimpa log Anda yang ada!';

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
  String get settingsExportToAnotherFormat => 'Ekspor ke Format Lain';

  @override
  String get settingsExportFormatDescription =>
      'Ini tidak boleh digunakan sebagai cadangan!';

  @override
  String get settingsImportFromAnotherApp => 'Impor dari Aplikasi Lain';

  @override
  String get logFormatTitle => 'Pilih Format';

  @override
  String get logFormatDescription =>
      'Format aplikasi lain mungkin tidak mendukung semua fitur. Harap laporkan masalah apa pun karena format pihak ketiga dapat berubah sewaktu-waktu. Ini tidak akan memengaruhi catatan yang sudah ada!';

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
  String get settingsOpenSourceLicenses => 'Open Source Licenses';

  @override
  String get tagMoodTitle => 'Perasaan';

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
  String get settingsAutoAddActivity => 'Activity';

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
    return 'Change this entry\'s time to $date and its place to $place, as recorded in the photo?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Change this entry\'s time to $date, when the photo was taken?';
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
}
