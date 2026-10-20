// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

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
  String get dailyReminderDescription => 'Ambil log harian anda…';

  @override
  String get actionTakePhoto => 'Ambil gambar';

  @override
  String get actionToday => 'Hari ini';

  @override
  String get actionOtherDay => 'Hari lain';

  @override
  String get pageHomeTitle => 'Utama';

  @override
  String get jumpToMonthTitle => 'Langkau ke bulan';

  @override
  String get jumpToLogTitle => 'Langkau ke log';

  @override
  String get flashbacksTitle => 'Imbas kembali';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Kecualikan hari-hari buruk';

  @override
  String get flaskbacksEmpty => 'Belum ada imbas semula…';

  @override
  String get flashbackGoodDay => 'Hari yang baik';

  @override
  String get flashbackRandomDay => 'Hari yang rawak';

  @override
  String flashbackWeek(num count) {
    return '$count Minggu Lepas';
  }

  @override
  String flashbackMonth(num count) {
    return '$count Bulan Lepas';
  }

  @override
  String flashbackYear(num count) {
    return '$count Tahun Lepas';
  }

  @override
  String get flashbackOnThisDay => 'Pada Hari Ini';

  @override
  String get pageGalleryTitle => 'Galeri';

  @override
  String get searchLogsHint => 'Log carian…';

  @override
  String logCount(num count) {
    return '$count log';
  }

  @override
  String dayCount(num count) {
    return '$count hari';
  }

  @override
  String wordCount(num count) {
    return '$count perkataan';
  }

  @override
  String get noLogs => 'Tiada log…';

  @override
  String get noResults => 'Tiada hasil…';

  @override
  String get sortDateTitle => 'Tarikh';

  @override
  String get sortOrderAscendingTitle => 'Menaik';

  @override
  String get sortOrderDescendingTitle => 'Menurun';

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
  String get statisticsRangeAllTime => 'Setiap Masa';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag Ringkasan';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag Per Hari';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag Dari Semasa Ke Semasa';
  }

  @override
  String get chartGroupingLabel => 'Kumpulkan dengan';

  @override
  String get chartGroupingDay => 'Hari';

  @override
  String get chartGroupingWeek => 'Minggu';

  @override
  String get chartGroupingMonth => 'Bulan';

  @override
  String get chartGroupingYear => 'Tahun';

  @override
  String get chartSmoothingLabel => 'Smoothing';

  @override
  String streakCurrent(num count) {
    return 'Rentetan Semasa $count';
  }

  @override
  String streakLongest(num count) {
    return 'Rentetan Terpanjang $count';
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
    return 'Hari Semenjak Hari Yang Buruk $count';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Tidak Dapat Mengakses Storan Luaran';

  @override
  String get errorExternalStorageAccessDescription =>
      'Jika anda menggunakan storan rangkaian, pastikan perkhidmatan tersebut dalam talian dan anda mempunyai akses rangkaian.\n\nJika tidak, aplikasi mungkin akan kehilangan kebenaran untuk folder luaran. Pergi ke tetapan dan pilih semula folder luaran untuk memberikan akses.\n\nAmaran, perubahan tidak akan disegerakkan sehingga anda memulihkan akses ke lokasi storan luaran!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Teruskan Dengan Pangkalan Data Tempatan';

  @override
  String get databaseMigrationErrorTitle => 'Couldn\'t Move Your Data';

  @override
  String get databaseMigrationErrorDescription =>
      'Your entries are safe but couldn\'t be moved to the app\'s storage.\n\nTry again, and report the issue if it keeps happening.';

  @override
  String get databaseMigrationErrorRetry => 'Retry';

  @override
  String get errorReport => 'Report Issue';

  @override
  String get lastModified => 'Diubah suai';

  @override
  String get writeSomethingHint => 'Tulis sesuatu…';

  @override
  String get titleHint => 'Tajuk…';

  @override
  String get deleteLogTitle => 'Padam Log';

  @override
  String get deleteLogDescription => 'Adakah anda ingin memadam log ini?';

  @override
  String get deletePhotoTitle => 'Padam Foto';

  @override
  String get deletePhotoDescription => 'Adakah anda ingin memadam foto ini?';

  @override
  String get pageSettingsTitle => 'Tetapan';

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
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Hari Pertama Dalam Seminggu';

  @override
  String get settingsCalendarSystem => 'Sistem Kalendar';

  @override
  String get calendarSystemGregorian => 'Gregorian';

  @override
  String get calendarSystemJalali => 'Jalali';

  @override
  String get settingsUseSystemAccentColor => 'Gunakan Warna Tema Sistem';

  @override
  String get settingsCustomAccentColor => 'Warna Tema Tersuai';

  @override
  String get settingsShowMarkdownToolbar => 'Show Markdown Toolbar';

  @override
  String get settingsShowFlashbacks => 'Tunjukkan Imbasan Semula';

  @override
  String get settingsChangeMoodIcons => 'Tukar Ikon Emosi';

  @override
  String get moodIconPrompt => 'Masukkan Ikon';

  @override
  String get settingsFlashbacksViewLayout => 'Flashbacks View Layout';

  @override
  String get settingsHideImagesInGallery => 'Sembunyikan Imej Dalam Galeri';

  @override
  String get settingsHideImages => 'Sembunyikan Imej';

  @override
  String get pageCalendarTitle => 'Kalendar';

  @override
  String get settingsNotificationsTitle => 'Pemberitahuan';

  @override
  String get settingsDailyReminderOnboarding =>
      'Dayakan peringatan harian untuk memastikan diri anda konsisten!';

  @override
  String get settingsNotificationsPermissionsPrompt =>
      'Kebenaran \'jadualkan penggera\' akan diminta untuk menghantar peringatan pada waktu tertentu atau pada waktu pilihan anda.';

  @override
  String get settingsDailyReminderTitle => 'Peringatan Harian';

  @override
  String get settingsOnThisDayDescription => 'Imbas kembali memori lama';

  @override
  String get settingsDailyReminderDescription =>
      'Peringatan lembut setiap hari';

  @override
  String get settingsReminderTime => 'Masa Peringatan';

  @override
  String get settingsFixedReminderTimeTitle => 'Masa Peringatan Tetap';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Pilih masa yang tetap untuk peringatan';

  @override
  String get settingsAlwaysSendReminderTitle => 'Semtiasa Hantar Peringatan';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Hantar peringatan walaupun log telah dimulakan';

  @override
  String get settingsCustomizeNotificationTitle => 'Sesuaikan Pemberitahuan';

  @override
  String get settingsTemplatesTitle => 'Templat';

  @override
  String get settingsDefaultTemplate => 'Templat Asal';

  @override
  String get manageTemplates => 'Urus Templat';

  @override
  String get addTemplate => 'Tambah Templat';

  @override
  String get newTemplate => 'New Template';

  @override
  String get noTemplateTitle => 'Tiada';

  @override
  String get noTemplatesDescription => 'Tiada templat dicipta…';

  @override
  String get templateVariableTime => 'Masa';

  @override
  String get templateDefaultTimestampTitle => 'Tanda Masa';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Ringkasan Hari';

  @override
  String get templateDefaultSummaryBody =>
      '### Ringkasan\n- \n\n### Petikan\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Refleksi';

  @override
  String get templateDefaultReflectionBody =>
      '### Apakah yang anda nikmati hari ini?\n- \n\n### Apakah yang anda syukuri?\n- \n\n### Apakah yang anda nanti-nantikan?\n- ';

  @override
  String get settingsTagsTitle => 'Tags';

  @override
  String get manageTags => 'Manage Tags';

  @override
  String get tagTypeLabelTitle => 'Label';

  @override
  String get tagTypeTrackerTitle => 'Tracker';

  @override
  String get nameHint => 'Name';

  @override
  String get tagColorLabel => 'Color';

  @override
  String get iconPickerTitle => 'Choose Icon';

  @override
  String get iconPickerIconsTab => 'Icons';

  @override
  String get iconPickerCustomTab => 'Custom';

  @override
  String get iconPickerSearchHint => 'Search icons…';

  @override
  String get colorPickerTitle => 'Choose Color';

  @override
  String get colorPickerPaletteTab => 'Colors';

  @override
  String get iconGroupMoodPeople => 'Mood & People';

  @override
  String get iconGroupHealth => 'Health';

  @override
  String get iconGroupWorkFinance => 'Work & Finance';

  @override
  String get iconGroupHabitsGoals => 'Habits & Goals';

  @override
  String get iconGroupNature => 'Nature';

  @override
  String get iconGroupFoodDrink => 'Food & Drink';

  @override
  String get iconGroupHome => 'Home';

  @override
  String get iconGroupTravel => 'Travel';

  @override
  String get iconGroupSymbols => 'Symbols';

  @override
  String get tagCategoryLabel => 'Category';

  @override
  String get tagLabel => 'Tag';

  @override
  String get tagCategoryUncategorized => 'Uncategorized';

  @override
  String get newCategoryTitle => 'New Category';

  @override
  String get shareButtonLabel => 'Share';

  @override
  String get importErrorDescription => 'Failed to import file!';

  @override
  String get exportErrorDescription => 'Failed to export file!';

  @override
  String get deleteTitle => 'Delete';

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
  String deleteTemplateMessage(Object name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get addTagsTitle => 'Add Tags';

  @override
  String get addTagsSearchHint => 'Search tags…';

  @override
  String get tagPickerSortManualLabel => 'Manual order';

  @override
  String get tagPickerSortUsageLabel => 'Sort by usage';

  @override
  String get tagFavoriteName => 'Favorite';

  @override
  String get tagEnergyName => 'Energy';

  @override
  String get tagCategoryActivitiesName => 'Activities';

  @override
  String get tagExerciseName => 'Exercise';

  @override
  String get tagSocializingName => 'Socializing';

  @override
  String get tagHobbyName => 'Hobby';

  @override
  String get tagEntertainmentName => 'Entertainment';

  @override
  String get tagDiningName => 'Dining';

  @override
  String get tagChoresName => 'Chores';

  @override
  String get tagCategoryEmotionsName => 'Emotions';

  @override
  String get tagExcitedName => 'Excited';

  @override
  String get tagGratefulName => 'Grateful';

  @override
  String get tagCalmName => 'Calm';

  @override
  String get tagTiredName => 'Tired';

  @override
  String get tagAnxiousName => 'Anxious';

  @override
  String get tagAnnoyedName => 'Annoyed';

  @override
  String get welcomeLogBodyText =>
      '## Welcome to AID Diary\n\n> Every day is worth remembering.\n\nWrite what happened, how you felt, and where you were. Your entries stay on this device.\n\n- **Journal** lists every entry by day\n- **Calendar**, **Media** and **Atlas** look back by date, photo and place\n- **Coach** offers prompts and templates when you don\'t know what to write\n\nAID Diary is a modified version of [Daily You](https://github.com/Demizo/Daily_You) by Demizo and contributors, and not the official Daily You app.';

  @override
  String get settingsStorageTitle => 'Storan';

  @override
  String get settingsImageQuality => 'Kualiti Imej';

  @override
  String get imageQualityHigh => 'Tinggi';

  @override
  String get imageQualityMedium => 'Sederhana';

  @override
  String get imageQualityLow => 'Rendah';

  @override
  String get imageQualityNoCompression => 'Tiada Pemampatan';

  @override
  String get settingsLogFolder => 'Folder Log';

  @override
  String get settingsImageFolder => 'Folder Imej';

  @override
  String get warningTitle => 'Amaran';

  @override
  String get logFolderWarningDescription =>
      'Jika folder yang dipilih telah mengandungi fail \'daily_you.db\', ia akan digunakan untuk menulis semula log sedia ada anda!';

  @override
  String get errorTitle => 'Ralat';

  @override
  String get logFolderErrorDescription => 'Gagal menukar folder log!';

  @override
  String get imageFolderErrorDescription => 'Gagal menukar folder imej!';

  @override
  String get backupErrorDescription => 'Gagal mencipta sandaran!';

  @override
  String get restoreErrorDescription => 'Gagal memulihkan sandaran!';

  @override
  String get settingsBackupRestoreTitle => 'Sandaran & Pemulihan';

  @override
  String get settingsBackup => 'Sandarkan';

  @override
  String get settingsRestore => 'Pulihkan';

  @override
  String get settingsRestorePromptDescription =>
      'Memulihkan sandaran akan menulis semula data sedia ada anda!';

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
    return 'Memindahkan... $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Mencipta Sandaran... $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Memulihkan Sandaran... $percent%';
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
    return 'Migrating photos… $current/$total';
  }

  @override
  String get settingsExport => 'Export';

  @override
  String get settingsExportToAnotherFormat => 'Eksport Kepada Format Lain';

  @override
  String get settingsExportFormatDescription =>
      'Ini tidak boleh digunakan sebagai sandaran!';

  @override
  String get exportLogs => 'Export Logs';

  @override
  String get exportImages => 'Export Images';

  @override
  String get settingsImport => 'Import';

  @override
  String get settingsImportFromAnotherApp => 'Import Daripada Aplikasi Lain';

  @override
  String get settingsTranslateCallToAction =>
      'Setiap orang harus mempunyai akses kepada jurnal!';

  @override
  String get settingsHelpTranslate => 'Bantu Terjemahkan';

  @override
  String get importLogs => 'Import Logs';

  @override
  String get importImages => 'Import Images';

  @override
  String get logFormatTitle => 'Pilih Format';

  @override
  String get logFormatDescription =>
      'Format aplikasi lain mungkin tidak menyokong semua ciri. Sila laporkan sebarang isu kerana format pihak ketiga mungkin berubah pada bila-bila masa. Ini tidak akan menjejaskan log sedia ada!';

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
  String get formatOneShot => 'OneShot';

  @override
  String get formatPixels => 'Pixels';

  @override
  String get formatMarkdown => 'Markdown';

  @override
  String get settingsDeleteAllLogsTitle => 'Padam Semua Log';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Adakah anda ingin memadam semua log anda?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Masukkan \'$prompt\' untuk meneruskan. Ini tidak dapat dibatalkan!';
  }

  @override
  String get settingsLanguageTitle => 'Bahasa';

  @override
  String get settingsAppLanguageTitle => 'Bahasa Apl';

  @override
  String get settingsOverrideAppLanguageTitle => 'Bahasa Aplikasi Ganti';

  @override
  String get settingsSecurityTitle => 'Keselamatan';

  @override
  String get settingsSecurityRequirePassword => 'Memerlukan Kata Laluan';

  @override
  String get settingsSecurityEnterPassword => 'Masukkan Kata Laluan';

  @override
  String get settingsSecuritySetPassword => 'Tetapkan Kata Laluan';

  @override
  String get settingsSecurityChangePassword => 'Tukar Kata Laluan';

  @override
  String get settingsSecurityPassword => 'Kata Laluan';

  @override
  String get settingsSecurityConfirmPassword => 'Sahkan Kata Laluan';

  @override
  String get settingsSecurityOldPassword => 'Kata Laluan Lama';

  @override
  String get settingsSecurityIncorrectPassword => 'Kata Laluan Salah';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'Kata laluan tidak sepadan';

  @override
  String get requiredPrompt => 'Diperlukan';

  @override
  String get settingsSecurityBiometricUnlock => 'Buka Kunci Biometrik';

  @override
  String get unlockAppPrompt => 'Buka kunci apl';

  @override
  String get settingsAboutTitle => 'Tentang';

  @override
  String get settingsVersion => 'Versi';

  @override
  String get settingsLicense => 'Lesen';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsSourceCode => 'Kod Sumber';

  @override
  String get settingsOpenSourceLicenses => 'Open Source Licenses';

  @override
  String get settingsMadeWithLove => 'Dibuat dengan ❤️';

  @override
  String get settingsConsiderSupporting => 'pertimbangkan untuk menyokong';

  @override
  String get imagesTitle => 'Images';

  @override
  String get tagMoodTitle => 'Suasana';

  @override
  String get calendarTagDisplayLabel => 'Tag';

  @override
  String get selectTagTitle => 'Select Tag';

  @override
  String get labelPresentLabel => 'Present';

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
  String get shareAsText => 'Share as text';

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
}
