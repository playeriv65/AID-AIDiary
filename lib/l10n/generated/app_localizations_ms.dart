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
  String get themeColorTitle => 'Warna tema';

  @override
  String get themeColorHint => 'Pilih warna untuk palet ini.';

  @override
  String get themeColorBlue => 'Biru langit';

  @override
  String get themeColorGreen => 'Hijau hutan';

  @override
  String get themeColorBrown => 'Kopi suam';

  @override
  String get themeColorPurple => 'Lavender';

  @override
  String get themeColorRose => 'Mawar berdebu';

  @override
  String get themeColorAmber => 'Amber';

  @override
  String get themeColorPreview => 'Sedikit setiap hari';

  @override
  String get themeTintBackgroundTitle =>
      'Warna latar belakang dengan warna tema';

  @override
  String get themeTintBackgroundHint =>
      'Matikan untuk latar belakang kelabu neutral; butang mengekalkan warna pilihan anda.';

  @override
  String get dailyReminderTitle => 'Log hari ini!';

  @override
  String get dailyReminderDescription => 'Ambil log harian anda…';

  @override
  String get actionTakePhoto => 'Ambil gambar';

  @override
  String get flashbacksTitle => 'Imbas kembali';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Kecualikan hari-hari buruk';

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
  String get chartSmoothingLabel => 'Melicinkan';

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
      other: 'Hari Hebat $count',
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
  String get settingsShowFlashbacks => 'Tunjukkan Imbasan Semula';

  @override
  String get settingsChangeMoodIcons => 'Tukar Ikon Emosi';

  @override
  String get moodIconPrompt => 'Masukkan Ikon';

  @override
  String get settingsHideImages => 'Sembunyikan Imej';

  @override
  String get pageCalendarTitle => 'Kalendar';

  @override
  String get settingsNotificationsTitle => 'Pemberitahuan';

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
  String get manageTemplates => 'Urus Templat';

  @override
  String get noTemplateTitle => 'Tiada';

  @override
  String get noTemplatesDescription => 'Tiada templat dicipta…';

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
  String get settingsTagsTitle => 'Tag';

  @override
  String get manageTags => 'Urus Teg';

  @override
  String get tagTypeLabelTitle => 'Label';

  @override
  String get tagTypeTrackerTitle => 'Penjejak';

  @override
  String get nameHint => 'Nama';

  @override
  String get tagColorLabel => 'warna';

  @override
  String get iconPickerTitle => 'Pilih Ikon';

  @override
  String get iconPickerIconsTab => 'ikon';

  @override
  String get iconPickerCustomTab => 'Adat';

  @override
  String get iconPickerSearchHint => 'Cari ikon…';

  @override
  String get colorPickerTitle => 'Pilih Warna';

  @override
  String get colorPickerPaletteTab => 'warna';

  @override
  String get iconGroupMoodPeople => 'Mood & Orang';

  @override
  String get iconGroupHealth => 'Kesihatan';

  @override
  String get iconGroupWorkFinance => 'Kerja & Kewangan';

  @override
  String get iconGroupHabitsGoals => 'Tabiat & Matlamat';

  @override
  String get iconGroupNature => 'alam semula jadi';

  @override
  String get iconGroupFoodDrink => 'Makanan & Minuman';

  @override
  String get iconGroupHome => 'Rumah';

  @override
  String get iconGroupTravel => 'Perjalanan';

  @override
  String get iconGroupSymbols => 'Simbol';

  @override
  String get tagCategoryLabel => 'kategori';

  @override
  String get tagLabel => 'Tag';

  @override
  String get tagCategoryUncategorized => 'Tidak dikategorikan';

  @override
  String get newCategoryTitle => 'Kategori Baharu';

  @override
  String get shareButtonLabel => 'Kongsi';

  @override
  String get importErrorDescription => 'Gagal mengimport fail!';

  @override
  String get exportErrorDescription => 'Gagal mengeksport fail!';

  @override
  String get deleteTitle => 'Padam';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Ia digunakan dalam $count entri diari.',
      one: ' Ia digunakan dalam 1 log.',
      zero: '',
    );
    return 'Padamkan \"$name\"?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' $count tagnya juga akan dipadamkan.',
      one: ' 1 tegnya juga akan dipadamkan.',
      zero: '',
    );
    return 'Padamkan \"$name\"?$_temp0';
  }

  @override
  String get tagNameExists => 'Sudah ada tag dengan nama ini';

  @override
  String get categoryNameExists => 'Sudah ada kategori dengan nama ini';

  @override
  String deleteTemplateMessage(Object name) {
    return 'Padamkan \"$name\"?';
  }

  @override
  String get addTagsTitle => 'Tambah Teg';

  @override
  String get addTagsSearchHint => 'Teg carian…';

  @override
  String get tagsRecent => 'Digunakan baru-baru ini';

  @override
  String get tagNew => 'Tag baharu';

  @override
  String get tagFavoriteName => 'Kegemaran';

  @override
  String get iconGroupActivities => 'Aktiviti';

  @override
  String get iconGroupHobbies => 'Hiburan';

  @override
  String get settingsStorageTitle => 'Storan';

  @override
  String get settingsLogFolder => 'Folder Log';

  @override
  String get settingsImageFolder => 'Folder Imej';

  @override
  String get warningTitle => 'Amaran';

  @override
  String get logFolderWarningDescription =>
      'Jika folder yang dipilih telah mengandungi fail \'aid_diary.db\', ia akan digunakan untuk menulis semula log sedia ada anda!';

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
  String get settingsBackupPasswordProtect => 'Sandaran Lindungi Kata Laluan';

  @override
  String get backupEncryptedTitle => 'Sandaran yang disulitkan';

  @override
  String get backupEncryptedContent => 'Sandaran ini dilindungi kata laluan.';

  @override
  String get settingsAutoBackup => 'Sandaran Automatik';

  @override
  String get settingsAutoBackupLocation => 'Lokasi Sandaran';

  @override
  String get settingsAutoBackupInterval => 'Selang Sandaran';

  @override
  String get settingsAutoBackupIntervalDaily => 'Setiap hari';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Mingguan';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Bulanan';

  @override
  String get settingsAutoBackupMaxCount => 'Sandaran Untuk Disimpan';

  @override
  String get settingsAutoBackupRequireCharging => 'Hanya Semasa Mengecas';

  @override
  String settingsBackupLast(Object time) {
    return 'Sandaran terakhir $time';
  }

  @override
  String get settingsBackupNever => 'Tidak pernah disandarkan';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Sandaran seterusnya $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'Semua';

  @override
  String get autoBackupFailedTitle => 'Sandaran Gagal';

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
    return 'Menyulitkan Sandaran… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Menyahsulit Sandaran… $percent%';
  }

  @override
  String get cleanUpStatus => 'Membersihkan…';

  @override
  String get settingsExportToAnotherFormat => 'Eksport Kepada Format Lain';

  @override
  String get settingsExportFormatDescription =>
      'Ini tidak boleh digunakan sebagai sandaran!';

  @override
  String get settingsImportFromAnotherApp => 'Import Daripada Aplikasi Lain';

  @override
  String get logFormatTitle => 'Pilih Format';

  @override
  String get logFormatDescription =>
      'Format aplikasi lain mungkin tidak menyokong semua ciri. Sila laporkan sebarang isu kerana format pihak ketiga mungkin berubah pada bila-bila masa. Ini tidak akan menjejaskan log sedia ada!';

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
  String get settingsDeleteAllLogsTitle => 'Padam Semua Log';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Adakah anda ingin memadam semua log anda?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Masukkan \'$prompt\' untuk meneruskan. Ini tidak dapat dibatalkan!';
  }

  @override
  String get settingsAppLanguageTitle => 'Bahasa Apl';

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
  String get settingsOpenSourceLicenses => 'Lesen Sumber Terbuka';

  @override
  String get tagMoodTitle => 'Suasana';

  @override
  String get selectTagTitle => 'Pilih Teg';

  @override
  String get labelPresentLabel => 'Hadir';

  @override
  String get labelAbsentLabel => 'tidak hadir';

  @override
  String get labelCoverageLabel => 'Liputan';

  @override
  String chartDistributionTitle(Object tag) {
    return 'Pengagihan $tag';
  }

  @override
  String get shareAddToLogPickerTitle => 'Pilih catatan diari';

  @override
  String get adaptiveEmptyDay => 'Tiada penyertaan untuk hari ini';

  @override
  String get adaptiveNewEntry => 'Tulis entri';

  @override
  String get pageJournalTitle => 'Jurnal';

  @override
  String get coachPrompt1 => 'Apa yang membuat anda tersenyum hari ini?';

  @override
  String get coachPrompt2 => 'Apakah satu perkara yang anda pelajari hari ini?';

  @override
  String get coachPrompt3 =>
      'Dengan siapa anda bercakap hari ini, dan apakah perasaannya?';

  @override
  String get coachPrompt4 => 'Apa yang anda bersyukur sekarang?';

  @override
  String get coachPrompt5 =>
      'Apa yang mengambil sebahagian besar tenaga anda hari ini?';

  @override
  String get coachPrompt6 => 'Terangkan detik kecil yang anda ingin ingat.';

  @override
  String get coachPrompt7 => 'Apa yang akan menjadikan esok hari yang baik?';

  @override
  String get coachPrompt8 =>
      'Apa yang ada dalam fikiran anda kebelakangan ini?';

  @override
  String get coachPrompt9 =>
      'Apa yang anda lakukan hari ini hanya untuk diri sendiri?';

  @override
  String get coachPrompt10 => 'Jika hari ini mempunyai tajuk, apakah itu?';

  @override
  String get pageMediaTitle => 'Media';

  @override
  String get pageAtlasTitle => 'Atlas';

  @override
  String get pageCoachTitle => 'Jurulatih';

  @override
  String get noEntrySelected => 'Tiada entri dipilih.';

  @override
  String get entryShare => 'Kongsi';

  @override
  String get entryFavorite => 'Bintang';

  @override
  String get entryEdit => 'Sunting';

  @override
  String get entryPrevious => 'Entri sebelum ini';

  @override
  String get entryNext => 'Entri seterusnya';

  @override
  String get journalStories => 'Cerita';

  @override
  String get journalEntries => 'entri';

  @override
  String get journalEmptyHint =>
      'Mulakan diari anda dengan menambah entri baharu.';

  @override
  String get storyToday => 'Hari ini';

  @override
  String get storyThrowback => 'Kenangan lama';

  @override
  String get storyNoThrowback => 'Tiada throwback hari ini';

  @override
  String get mediaFiles => 'Fail media';

  @override
  String get mediaEmpty => 'Tiada foto lagi.';

  @override
  String get mediaEmptyHint =>
      'Foto yang dilampirkan pada penyertaan akan ditunjukkan di sini.';

  @override
  String get atlasEmpty => 'Tiada penyertaan dengan lokasi.';

  @override
  String get atlasEmptyHint => 'Entri dengan lokasi akan ditunjukkan di sini.';

  @override
  String get atlasShowAll => 'Tunjukkan semua entri';

  @override
  String get atlasMyLocation => 'lokasi saya';

  @override
  String get coachAll => 'Semua';

  @override
  String get coachPrograms => 'Program';

  @override
  String get coachTemplates => 'templat';

  @override
  String get coachKindProgram => 'Program';

  @override
  String get coachKindTemplate => 'templat';

  @override
  String get coachNoTemplates => 'Tiada program atau templat.';

  @override
  String get coachUseTemplate => 'Tulis dengan templat ini';

  @override
  String get coachProgramEverydayTitle => 'Detik setiap hari';

  @override
  String get coachProgramEverydayDescription =>
      'Lima soalan pendek, satu soalan sehari. Setiap satu atau dua minit dan membantu anda melihat perkara yang menjadikan hari itu milik anda. Cara yang lembut untuk membina tabiat menulis sedikit setiap hari.';

  @override
  String get coachProgramReflectTitle => 'Memandang ke dalam';

  @override
  String get coachProgramReflectDescription =>
      'Satu soalan yang lebih mendalam seminggu, selama lima minggu. Luangkan masa anda dengan setiap perkara: bagaimana perasaan anda, apa yang meletihkan anda, apa yang anda syukuri.';

  @override
  String get searchFilters => 'Penapis';

  @override
  String get searchFilterTags => 'Tag';

  @override
  String get searchFilterStarred => 'Dibintangi';

  @override
  String get searchHint => 'Taip untuk mencari atau pilih penapis.';

  @override
  String get locationTitle => 'Lokasi';

  @override
  String get locationName => 'Nama tempat';

  @override
  String get locationRemove => 'Alih keluar';

  @override
  String get locationServiceDisabled => 'Perkhidmatan lokasi dimatikan.';

  @override
  String get locationPermissionDenied => 'Kebenaran lokasi telah ditolak.';

  @override
  String get locationUnavailable => 'Tidak dapat mendapatkan lokasi semasa.';

  @override
  String get calendarJumpToToday => 'Lompat ke hari ini';

  @override
  String get editorStartWriting => 'Mula menulis atau pilih a ';

  @override
  String get editorTemplateLink => 'templat';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Pilih templat';

  @override
  String get templateFeatured => 'Templat pilihan';

  @override
  String get templateMine => 'templat saya';

  @override
  String get templateDailyName => 'Tinjauan harian';

  @override
  String get templateDailyDescription =>
      'Apa yang berlaku, bagaimana perasaannya, dan apa yang akan berlaku seterusnya.';

  @override
  String get templateDailyText =>
      '## Apa yang berlaku hari ini\n\n\n## Bagaimana perasaan saya\n\n\n## Tiga perkara yang saya syukuri\n1. \n2. \n3. \n\n## Esok\n';

  @override
  String get templateTravelName => 'Entri diari perjalanan';

  @override
  String get templateTravelDescription =>
      'Tempat, detik dan makanan dari jalan raya.';

  @override
  String get templateTravelText =>
      '## Ke mana saya pergi\n\n\n## Saat yang paling saya ingat\n\n\n## Apa yang saya makan\n\n\n## Rancangan untuk esok\n';

  @override
  String get templateReadingName => 'Membaca nota';

  @override
  String get templateReadingDescription =>
      'Petikan dan pemikiran daripada apa yang anda baca.';

  @override
  String get templateReadingText =>
      '## Buku\n\n\n## Di mana saya berada\n\n\n## Petikan\n> \n\n## Fikiran saya\n';

  @override
  String get templateWeeklyName => 'Semakan mingguan';

  @override
  String get templateWeeklyDescription =>
      'Sorotan, perjuangan dan fokus minggu depan.';

  @override
  String get templateWeeklyText =>
      '## Sorotan\n\n\n## Apa yang sukar\n\n\n## Apa yang saya pelajari\n\n\n## Fokus untuk minggu hadapan\n';

  @override
  String get entrySaveAsTemplate => 'Simpan sebagai templat';

  @override
  String get entrySavedAsTemplate => 'Disimpan sebagai templat';

  @override
  String get storyStatistics => 'Perangkaan';

  @override
  String get storyMoodChart => 'Carta mood';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return 'Entri $entries · $days hari';
  }

  @override
  String get storyThisYear => 'tahun ini';

  @override
  String get storyLastYear => 'tahun lepas';

  @override
  String get storyTapToOpen => 'Ketik hari untuk membukanya';

  @override
  String get settingsGeneralTitle => 'Umum';

  @override
  String get settingsDataTitle => 'Data & storan';

  @override
  String get settingsStoriesTitle => 'Cerita';

  @override
  String get settingsHelpTitle => 'Bantuan & tentang';

  @override
  String get weatherTitle => 'Cuaca';

  @override
  String get weatherClear => 'Jelas';

  @override
  String get weatherPartlyCloudy => 'Sebahagian mendung';

  @override
  String get weatherCloudy => 'mendung';

  @override
  String get weatherFog => 'kabut';

  @override
  String get weatherDrizzle => 'Hujan renyai-renyai';

  @override
  String get weatherRain => 'hujan';

  @override
  String get weatherSnow => 'salji';

  @override
  String get weatherStorm => 'Ribut petir';

  @override
  String get weatherFetch => 'Dapatkan cuaca untuk entri ini';

  @override
  String get weatherNeedsLocation => 'Tambah lokasi dengan koordinat dahulu.';

  @override
  String get weatherUnavailable =>
      'Cuaca tidak tersedia untuk tempat dan masa ini.';

  @override
  String get weatherRemove => 'Keluarkan cuaca';

  @override
  String get weatherTemperature => 'Suhu';

  @override
  String get activityStill => 'Masih';

  @override
  String get activityWalking => 'berjalan';

  @override
  String get activityRunning => 'Berlari';

  @override
  String get activityCycling => 'Berbasikal';

  @override
  String get activityVehicle => 'Dalam kenderaan';

  @override
  String get activityFlying => 'terbang';

  @override
  String get activityExercise => 'Bersenam';

  @override
  String get settingsAutoAddTitle => 'Tambah secara automatik';

  @override
  String get settingsAutoAddLocation => 'Lokasi';

  @override
  String get settingsAutoAddWeather => 'Cuaca';

  @override
  String get settingsAutoAddHint =>
      'Entri baharu akan diisi apabila ia dibuat.';

  @override
  String get settingsTemperatureUnit => 'Unit suhu';

  @override
  String get settingsCelsius => 'Celsius (°C)';

  @override
  String get settingsFahrenheit => 'Fahrenheit (°F)';

  @override
  String get moodGreat => 'Hebat';

  @override
  String get moodGood => 'bagus';

  @override
  String get moodOkay => 'Okay';

  @override
  String get moodBad => 'teruk';

  @override
  String get moodAwful => 'Mengerikan';

  @override
  String get locationSearchHint => 'Cari tempat';

  @override
  String get locationSearchEmpty => 'Tiada tempat ditemui';

  @override
  String get settingsWallpaper => 'Kertas dinding';

  @override
  String get wallpaperNone => 'tiada';

  @override
  String get wallpaperDots => 'titik';

  @override
  String get wallpaperGrid => 'Grid';

  @override
  String get wallpaperLines => 'Garisan';

  @override
  String get wallpaperPhoto => 'Foto…';

  @override
  String get settingsFontFamily => 'fon';

  @override
  String get fontSystem => 'Sistem';

  @override
  String get fontSerif => 'Serif';

  @override
  String get fontMono => 'Monospace';

  @override
  String get settingsFontSize => 'Saiz fon';

  @override
  String get fontSizeSmall => 'Kecil';

  @override
  String get fontSizeMedium => 'Sederhana';

  @override
  String get fontSizeLarge => 'besar';

  @override
  String get fontSizeExtraLarge => 'Lebih besar';

  @override
  String get settingsLineSpacing => 'Jarak baris';

  @override
  String get lineSpacingCompact => 'Padat';

  @override
  String get lineSpacingNormal => 'Biasalah';

  @override
  String get lineSpacingRelaxed => 'Santai';

  @override
  String get moodAssociationsTitle => 'Apa yang membuatkan saya rasa…';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching daripada masukan $total';
  }

  @override
  String get videoRecord => 'Rakam video';

  @override
  String get videoChoose => 'Pilih video';

  @override
  String get audioRecordTitle => 'Rakam nota suara';

  @override
  String get audioChoose => 'Pilih fail audio';

  @override
  String get audioStart => 'Rekod';

  @override
  String get audioStop => 'Berhenti dan simpan';

  @override
  String get audioPermissionDenied =>
      'Akses mikrofon dimatikan. Benarkan dalam tetapan sistem.';

  @override
  String get mediaTooLarge => 'Video ini terlalu besar untuk dilampirkan.';

  @override
  String get mediaUnavailable =>
      'Lampiran ini tidak tersedia pada peranti ini.';

  @override
  String get widgetDone => 'Entry hari ini ditulis';

  @override
  String get widgetPending => 'Bagaimana hari anda?';

  @override
  String get widgetWrite => 'tulis';

  @override
  String get insertChecklist => 'Senarai semak';

  @override
  String get insertNumberedList => 'Senarai bernombor';

  @override
  String get insertTable => 'Jadual';

  @override
  String get insertDivider => 'Pembahagi';

  @override
  String get insertCodeBlock => 'Blok kod';

  @override
  String get journalSortTitle => 'Isih entri';

  @override
  String get journalSortUpdated => 'Kemas kini terakhir';

  @override
  String get settingsTimeFormat => 'Format masa';

  @override
  String get settingsDayStart =>
      'Penyertaan baharu dikira untuk sehari sebelum sehingga';

  @override
  String get settingsDayAskUntil => 'Lepas tu tanya sampai hari mana';

  @override
  String get settingsDayStartMidnight => 'Mati';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Setiap entri mengekalkan hari ia berada di sebelah masa ia ditulis dan anda boleh menukar hari itu dalam editor pada bila-bila masa. Waktu ini hanya memilih hari untuk entri baharu, jadi menukarnya tidak mengalihkan entri sedia ada.';

  @override
  String get lateNightBadge =>
      'Ditulis lewat malam, dikira untuk hari sebelumnya';

  @override
  String editorDayAsk(String time) {
    return 'Ditulis di $time. Hari itu untuk hari yang mana?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (semalam)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (hari ini)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'Ditulis $when';
  }

  @override
  String get timeFormat12 => '12 jam';

  @override
  String get timeFormat24 => '24 jam';

  @override
  String get settingsReminderDays => 'Ingatkan saya';

  @override
  String get locationRecent => 'Tempat terkini';

  @override
  String get shareImage => 'Kongsi imej';

  @override
  String get shareSaveImage => 'Simpan imej';

  @override
  String get shareSaved => 'Imej disimpan';

  @override
  String get deletedTitle => 'Baru-baru ini dipadamkan';

  @override
  String get deletedNone => 'Tiada apa-apa yang dipadamkan baru-baru ini';

  @override
  String deletedHint(int days) {
    return 'Entri yang dipadam kekal di sini selama $days hari, kemudian dipadamkan.';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days hari lagi';
  }

  @override
  String get deletedRestore => 'Pulihkan';

  @override
  String get deletedDeleteForever => 'Padam selama-lamanya';

  @override
  String get deletedDeleteForeverDescription =>
      'Entri dan lampirannya dipadamkan. Ini tidak boleh dibuat asal.';

  @override
  String get deletedEmpty => 'kosong';

  @override
  String get deletedEmptyDescription =>
      'Padamkan setiap entri dalam Dipadamkan baru-baru ini? Ini tidak boleh dibuat asal.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Berjalan secara rawak';

  @override
  String get randomSubtitle => 'Buka entri lepas';

  @override
  String get randomNext => 'Satu lagi';

  @override
  String get randomAll => 'Semua';

  @override
  String get randomWithPhotos => 'Dengan foto';

  @override
  String get randomGoodDays => 'hari yang baik';

  @override
  String get randomEmpty => 'Tiada penyertaan untuk dipilih';

  @override
  String get reviewWeekTitle => 'minggu ini';

  @override
  String get reviewWeekSubtitle => 'Minggu anda setakat ini';

  @override
  String get reviewYearTitle => 'tahun ini';

  @override
  String get reviewEmpty => 'Tiada apa yang ditulis lagi';

  @override
  String get reviewEntries => 'entri';

  @override
  String get reviewDaysWritten => 'Hari ditulis';

  @override
  String get reviewWords => 'Kata-kata';

  @override
  String get reviewPhotos => 'Foto';

  @override
  String get reviewLongestRun => 'Tempoh hari terpanjang';

  @override
  String get reviewAverageMood => 'Mood sederhana';

  @override
  String get reviewFavorites => 'Selalunya';

  @override
  String get reviewByMonth => 'Mengikut bulan';

  @override
  String get reviewHighlight => 'Serlahkan';

  @override
  String get yearInPixels => 'Tahun dalam piksel';

  @override
  String get capsuleSeal => 'Meterai sebagai kapsul masa';

  @override
  String get capsuleTitle => 'Kapsul masa';

  @override
  String capsuleOpensOn(Object date) {
    return 'Dibuka pada $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Ditulis pada $date';
  }

  @override
  String get capsuleOpenEarly => 'Buka awal';

  @override
  String get capsuleOpenEarlyDescription =>
      'Kapsul dibuka sekarang dan kekal terbuka.';

  @override
  String get capsuleOpened => 'Kapsul masa dibuka';

  @override
  String get templateMorningName => 'Muka surat pagi';

  @override
  String get templateMorningDescription =>
      'Sediakan hari dalam masa tiga minit';

  @override
  String get templateMorningText =>
      '## Tiga perkara yang saya mahu lakukan dengan baik hari ini\n1. \n2. \n3. \n\n## Sesuatu yang saya nantikan\n\n## Catatan untuk diri saya sendiri\n';

  @override
  String get templateEveningName => 'Semakan petang';

  @override
  String get templateEveningDescription =>
      'Tutup hari dengan apa yang berjalan lancar';

  @override
  String get templateEveningText =>
      '## Tiga perkara baik hari ini\n1. \n2. \n3. \n\n## Apa yang saya pelajari\n\n## Apa yang boleh menjadi lebih baik esok\n';

  @override
  String get routineMorning => 'selamat pagi';

  @override
  String get routineEvening => 'Semakan petang';

  @override
  String get settingsRoutinePrompts => 'Gesaan pagi dan petang';

  @override
  String get settingsRoutinePromptsHint =>
      'Cadangkan templat pagi atau petang dalam Cerita';

  @override
  String get checkInTitle => 'Daftar masuk cepat';

  @override
  String get checkInSubtitle => 'Mood dalam dua paip';

  @override
  String get checkInMood => 'Bagaimana perasaan anda?';

  @override
  String get checkInActivity => 'awak buat apa?';

  @override
  String get checkInNote => 'Satu baris mengenainya (pilihan)';

  @override
  String get checkInSave => 'Jimat';

  @override
  String editorWordCount(int words, int characters) {
    return '$words perkataan · $characters aksara';
  }

  @override
  String get coachProgramEverydayTagline =>
      'Perhatikan perkara kecil dalam sehari.';

  @override
  String get coachProgramReflectTagline => 'Perlahan dan dengar sendiri.';

  @override
  String get coachDuration => 'Tempoh';

  @override
  String get coachInterval => 'Selang waktu';

  @override
  String get coachDifficulty => 'Kesukaran';

  @override
  String get coachIntervalDaily => 'Setiap hari';

  @override
  String get coachIntervalWeekly => 'Mingguan';

  @override
  String get coachDifficultyBeginner => 'pemula';

  @override
  String get coachDifficultyIntermediate => 'Pertengahan';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hari',
      one: '1 hari',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minggu',
      one: '1 minggu',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'Hari $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Minggu $n';
  }

  @override
  String get coachEnroll => 'Daftar';

  @override
  String get coachEndProgram => 'Tamat program';

  @override
  String get coachAuthor => 'Pengarang';

  @override
  String get coachAuthorBio => 'Gesaan ditulis untuk apl ini.';

  @override
  String get coachEnrolledTip =>
      'Semua siap! Soalan anda akan dipaparkan dalam Cerita.';

  @override
  String get coachGoToStories => 'Pergi ke Cerita';

  @override
  String get coachAnswerHint => 'Tulis jawapan anda…';

  @override
  String get storyWrapUp => 'Itu sahaja untuk hari ini.';

  @override
  String get storyTapToClose => 'Ketik untuk menutup';

  @override
  String get coachAnswerDone => 'Selesai';

  @override
  String get coachAnswered => 'Dijawab, ketik untuk membuka';

  @override
  String get coachAnsweredEarlier => 'Dijawab';

  @override
  String get locationLocating => 'Mengesan…';

  @override
  String get locationPickPlace => 'Pilih tempat';

  @override
  String get locationPlacesHint => 'Alamat atau nama tempat';

  @override
  String get locationCustom => 'Tempat tersuai';

  @override
  String get locationCurrent => 'Lokasi semasa';

  @override
  String get locationSaved => 'Tempat yang disimpan';

  @override
  String get locationSearchResults => 'Hasil carian';

  @override
  String get locationNearby => 'Tempat berdekatan';

  @override
  String get locationRename => 'Namakan semula';

  @override
  String get locationSavePlace => 'Jimat tempat';

  @override
  String get locationUnsavePlace => 'Alih keluar daripada tempat yang disimpan';

  @override
  String get shareAs => 'Kongsi sebagai…';

  @override
  String get shareAsImage => 'Imej';

  @override
  String get shareAsZip => 'ZIP dengan media asal';

  @override
  String get shareAsPlainText => 'Teks biasa';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Selamat datang ke AID Diary';

  @override
  String get onboardWelcomeText =>
      'Mulakan di sini, atau sambungkan peranti ini kepada peranti yang telah anda gunakan.';

  @override
  String get onboardStart => 'Mula menulis';

  @override
  String get helpFaq => 'Soalan lazim';

  @override
  String get helpFaq1Q => 'Di manakah diari saya disimpan?';

  @override
  String get helpFaq1A =>
      'Diari anda disimpan pada peranti ini. Ia mencapai peranti atau storan lain hanya apabila anda mendayakan penyegerakan, berkongsi atau mengeksportnya. Penyegerakan disulitkan dari hujung ke hujung.';

  @override
  String get helpFaq2Q =>
      'Bagaimanakah cara saya menyimpan salinan atau beralih ke peranti baharu?';

  @override
  String get helpFaq2A =>
      'Sambung ke peranti sedia ada dalam Tetapan → Data & storan → Segerakkan dan sahkan kebenaran pada peranti yang mempunyai diari anda. Kedua-dua peranti kekal boleh digunakan. Anda juga boleh membuat sandaran dan memulihkannya pada peranti lain.';

  @override
  String get helpFaq3Q =>
      'Bolehkah saya membawa masuk entri daripada apl diari lain?';

  @override
  String get helpFaq3A =>
      'Ya: dalam Tetapan → Data & storan, import eksport daripada Daylio, Diarium, Diaro, DayBook, My Brain, OneShot dan Pixels, atau eksport JSON.';

  @override
  String get helpFaq4Q => 'Bagaimanakah program jurulatih berfungsi?';

  @override
  String get helpFaq4A =>
      'Mendaftar dalam program di halaman Jurulatih. Setiap hari atau minggu soalan baharu menanti dalam Cerita; jawapan anda disimpan sebagai entri.';

  @override
  String get helpFaq5Q => 'Bagaimana jika saya terlupa kod laluan saya?';

  @override
  String get helpFaq5A =>
      'Kod laluan tidak boleh dipulihkan, jadi simpan sandaran diari anda.';

  @override
  String get helpPrivacy => 'Privasi';

  @override
  String get helpPrivacyText =>
      'Kandungan diari dan media kekal pada peranti ini melainkan anda mendayakan penyegerakan yang disulitkan atau berkongsi/mengeksportnya. Peta, carian tempat dan cuaca menggunakan perkhidmatan yang dikonfigurasikan dan menghantar lokasi atau pertanyaan carian yang diperlukan untuk permintaan itu, bukan teks diari.';

  @override
  String get photoMetaTitle => 'Gunakan butiran foto?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Kira entri ini untuk $date dan tetapkan tempatnya kepada $place, seperti yang dirakamkan dalam foto?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Kira entri ini untuk $date, bila foto itu diambil?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Tetapkan tempat entri ini kepada $place, di mana foto itu diambil?';
  }

  @override
  String get photoMetaApply => 'Gunakan mereka';

  @override
  String get quickWriteTitle => 'Tulis cepat';

  @override
  String get quickWriteText => 'Ketik untuk memulakan entri baharu.';

  @override
  String get settingsQuickWriteTitle => 'Tulis cepat dalam pemberitahuan';

  @override
  String get settingsQuickWriteDescription =>
      'Simpan pemberitahuan yang membuka entri baharu.';

  @override
  String get settingsNudgesTitle => 'Pukul saya selepas regangan yang tenang';

  @override
  String settingsNudgesDescription(int days) {
    return 'Peringatan lembut apabila anda tidak menulis selama $days hari.';
  }

  @override
  String get nudgeTitle => 'dah agak lama';

  @override
  String get nudgeMonday => 'Minggu baru: apa yang anda nantikan?';

  @override
  String get nudgeTuesday =>
      'Dua baris sudah memadai. Apa khabar anda hari ini?';

  @override
  String get nudgeWednesday =>
      'Setengah minggu. Apa yang menonjol setakat ini?';

  @override
  String get nudgeThursday =>
      'Apa-apa perkara kecil yang patut disimpan mulai hari ini?';

  @override
  String get nudgeFriday =>
      'Minggu sudah berakhir. Perhatikan satu saat yang baik.';

  @override
  String get nudgeSaturday =>
      'Sabtu yang lambat adalah hari yang baik untuk menulis.';

  @override
  String get nudgeSunday => 'Imbas kembali minggu sebelum ia berakhir.';

  @override
  String get photoWidgetEmpty =>
      'Foto yang anda tambahkan pada entri dipaparkan di sini.';

  @override
  String get channelReminders => 'Peringatan';

  @override
  String get channelOnThisDay => 'Pada hari ini';

  @override
  String get channelCoach => 'Gesaan jurulatih';

  @override
  String get channelNudges => 'Menyinggung selepas hari yang tenang';

  @override
  String get channelQuickWrite => 'Tulis cepat';

  @override
  String get channelBackup => 'Sandaran';

  @override
  String get formatJsonExport => 'JSON (eksport AID Diary)';

  @override
  String get aboutModifiedNotice =>
      'Versi Daily You yang diubah suai oleh Demizo dan penyumbang. Ia bukan apl Daily You rasmi.';

  @override
  String get toolbarPhotos => 'Tambah foto';

  @override
  String get toolbarMedia => 'Foto dan video';

  @override
  String get mediaFromGallery => 'Pilih daripada galeri';

  @override
  String get mediaFromFiles => 'Pilih daripada fail';

  @override
  String get editorLeaveTitle => 'Simpan entri ini?';

  @override
  String get editorLeaveDiscard => 'Jangan simpan';

  @override
  String get editorTitleHint => 'Tajuk';

  @override
  String get editorLocating => 'Mengesan…';

  @override
  String get toolbarVideo => 'Video';

  @override
  String get toolbarAudio => 'Nota suara';

  @override
  String get toolbarTags => 'Tag';

  @override
  String get toolbarBulletList => 'Senarai bertitik tumpu mata';

  @override
  String get toolbarHeading => 'Tajuk';

  @override
  String get toolbarBold => 'berani';

  @override
  String get toolbarItalic => 'Condong';

  @override
  String get toolbarHighlight => 'Serlahkan';

  @override
  String get toolbarStrikethrough => 'Garis potong';

  @override
  String get toolbarQuote => 'petikan';

  @override
  String get toolbarLink => 'Pautan';

  @override
  String get toolbarInsert => 'Sisipkan';

  @override
  String get toolbarUndo => 'Buat asal';

  @override
  String get toolbarRedo => 'Buat semula';

  @override
  String get toolbarInsertDate => 'Masukkan tarikh';

  @override
  String get toolbarInsertTime => 'Masukkan masa';

  @override
  String get settingsSyncTitle => 'Penyegerakan Awan';

  @override
  String get syncOffDescription =>
      'Simpan diari ini sama pada semua peranti anda melalui Google Drive atau pelayan WebDAV, seperti Nextcloud, Synology atau Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'Segerakkan dengan Google Drive';

  @override
  String get syncOrWebDav => 'Atau pelayan WebDAV';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn =>
      'Log masuk. Anda boleh kembali ke AID Diary.';

  @override
  String get syncGoogleSignInAgain =>
      'Google memerlukan anda untuk log masuk semula.';

  @override
  String get syncSignInAgain => 'Log masuk semula';

  @override
  String get settingsCommandLineTitle => 'Barisan arahan';

  @override
  String get commandLineToggle => 'Antara muka baris arahan';

  @override
  String get commandLineToggleHint =>
      'Membenarkan arahan bantuan dan program lain pada peranti ini menggunakan arahan apl.';

  @override
  String get commandLineAlwaysOn =>
      'Sentiasa di dalam pembangunan yang dibina.';

  @override
  String commandLineListening(int port) {
    return 'Mendengar pada port $port';
  }

  @override
  String get commandPaletteTitle => 'Semua arahan';

  @override
  String get commandPaletteSearch => 'Perintah carian';

  @override
  String get commandPaletteRun => 'Lari';

  @override
  String get commandPaletteConfirm =>
      'Ini tidak boleh dibuat asal. Jalankan ia?';

  @override
  String syncReceiving(int done, int total) {
    return 'Menerima $done daripada $total…';
  }

  @override
  String syncSending(int done, int total) {
    return 'Menghantar $done daripada $total…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'Akses kepada Google Drive tidak dibenarkan. Sambung semula dan tandakan Google Drive pada halaman Google.';

  @override
  String get syncEntryUnsynced =>
      'Tidak disegerakkan: penyegerakan terakhir tidak berjaya';

  @override
  String get syncUseOfficial => 'Gunakan pelayan penyegerakan AID';

  @override
  String get syncServer => 'Alamat pelayan';

  @override
  String get syncUsername => 'Nama pengguna';

  @override
  String get syncPassword => 'Kata laluan';

  @override
  String get syncConnect => 'Sambung';

  @override
  String get syncConnecting => 'Menyambung…';

  @override
  String get syncSignInFailed =>
      'Tidak dapat log masuk. Semak alamat, nama pengguna dan kata laluan.';

  @override
  String syncConnectFailed(String error) {
    return 'Tidak dapat menyambung: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Mula menyegerak';

  @override
  String get syncNewSpaceDescription =>
      'Belum ada diari yang disegerakkan di sini. Diari ini akan dimuat naik, disulitkan dari hujung ke hujung dengan kunci yang kekal pada peranti anda.';

  @override
  String get syncJoinTitle => 'Sertai diari yang disegerakkan';

  @override
  String get syncWrongKey =>
      'Kod pemulihan ini tidak membuka diari yang disegerakkan.';

  @override
  String syncLastSynced(String time) {
    return 'Terakhir disegerakkan $time';
  }

  @override
  String get syncNever => 'Belum disegerakkan lagi';

  @override
  String get syncSyncing => 'Menyegerakkan…';

  @override
  String syncFailed(String error) {
    return 'Penyegerakan terakhir gagal: $error';
  }

  @override
  String get syncLocked =>
      'Diari yang disegerakkan kini dimiliki oleh peranti lain, atau telah dimulakan semula. Gandingkan dengan salah satu daripadanya atau gunakan kod pemulihan untuk terus menyegerak.';

  @override
  String get syncNow => 'Segerakkan sekarang';

  @override
  String get syncUnlock => 'Buka kunci';

  @override
  String get syncEncrypted => 'Hujung ke hujung disulitkan';

  @override
  String get syncDisconnect => 'Berhenti menyegerak';

  @override
  String get syncDisconnectDescription =>
      'Peranti ini berhenti menyegerak. Diari di sini dan salinan yang disegerakkan kekal seperti sedia ada.';

  @override
  String get syncOwnRecoveryPassword =>
      'Gunakan kata laluan pemulihan saya sendiri';

  @override
  String get syncRecoveryPassword => 'Kata laluan pemulihan';

  @override
  String get syncRecoveryPasswordRepeat => 'Ulang kata laluan pemulihan';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Gunakan sekurang-kurangnya $min aksara';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'Kata laluan berbeza';

  @override
  String get syncRecoveryCode => 'Kod pemulihan';

  @override
  String get syncRecoveryCodeTitle => 'Simpan kod pemulihan anda';

  @override
  String get syncRecoveryCodeDescription =>
      'Jika setiap peranti anda hilang, kod ini memulihkan diari anda yang disegerakkan. Simpan dalam pengurus kata laluan atau di atas kertas. Ia ditunjukkan sekali sahaja.';

  @override
  String get syncRecoveryCodeCopied => 'Kod pemulihan disalin';

  @override
  String get syncRecoveryCodeSaved => 'Saya telah menyimpannya';

  @override
  String get syncJoinNeedsKey =>
      'Diari yang disegerakkan ini adalah milik peranti anda yang lain. Gandingkan dengan salah satu daripadanya, atau gunakan kod pemulihan. Entri pada peranti ini akan ditambahkan padanya.';

  @override
  String get syncPairDevice => 'Gandingkan dengan peranti';

  @override
  String get syncUseRecoveryCode => 'Gunakan kod pemulihan';

  @override
  String get syncAddDevice => 'Tambahkan peranti';

  @override
  String get syncChangeRecoveryCode => 'Tukar kod pemulihan';

  @override
  String get syncChangeRecoveryDescription =>
      'Kod baharu menggantikan kod semasa, yang berhenti berfungsi. Data anda dan peranti lain kekal seperti sedia ada.';

  @override
  String get syncNewRandomCode => 'Kod rawak baharu';

  @override
  String get syncRecoveryCodeChanged => 'Kod pemulihan ditukar';

  @override
  String get syncResetSpace => 'Mulakan diari yang disegerakkan semula';

  @override
  String get syncResetSpaceDescription =>
      'Hanya apabila tiada peranti dan tiada kod pemulihan membukanya lagi: salinan yang disegerakkan digantikan dengan diari pada peranti ini, di bawah kekunci peranti ini. Peranti anda yang lain kemudian pasangkan semula.';

  @override
  String get syncPairTitle => 'Pasangkan peranti';

  @override
  String get syncPairShow => 'Tunjukkan kod';

  @override
  String get syncPairEnter => 'Masukkan kod';

  @override
  String get syncPairShowHint =>
      'Pada peranti anda yang lain, buka Pasangkan peranti, pilih Masukkan kod dan taip atau imbas ini.';

  @override
  String get syncPairEnterHint =>
      'Taip kod yang ditunjukkan oleh peranti anda yang lain atau imbasnya.';

  @override
  String get syncPairCode => 'Kod berpasangan';

  @override
  String get syncPairScan => 'Imbas';

  @override
  String get syncPairStart => 'berpasangan';

  @override
  String get syncPairWaiting => 'Menunggu peranti lain…';

  @override
  String syncPairDone(String device) {
    return 'Digandingkan dengan $device';
  }

  @override
  String get syncPairWrongCode =>
      'Kod tidak sepadan. Tunjukkan kod baharu dan cuba lagi.';

  @override
  String get syncPairNoOffer =>
      'Tiada peranti menunjukkan kod ini. Ia mungkin telah tamat tempoh.';

  @override
  String get syncPairTimedOut =>
      'Peranti lain tidak menjawab tepat pada masanya.';

  @override
  String get syncPairNeither =>
      'Kedua-dua peranti belum disediakan dengan diari yang disegerakkan ini.';

  @override
  String get syncPairBoth =>
      'Kedua-dua peranti sudah membuka diari yang disegerakkan ini.';

  @override
  String syncPairFailed(String error) {
    return 'Gagal berpasangan: $error';
  }

  @override
  String get syncMediaPending =>
      'Diari disegerakkan · sesetengah media masih dipindahkan';

  @override
  String get syncWaitingForDevices =>
      'Diari disegerakkan · menunggu peranti lain untuk memindahkan media';

  @override
  String get syncCacheNotice =>
      'Media awan bersifat sementara. Simpan yang asal pada peranti anda; penyegerakan bukan sandaran.';

  @override
  String get paperTitle => 'Kertas surat';

  @override
  String get paperPlain => 'Biasa';

  @override
  String get paperLined => 'Berbaris';

  @override
  String get paperGrid => 'Grid';

  @override
  String get paperTinted => 'Berwarna';

  @override
  String get paperDecorationTitle => 'Hiasan';

  @override
  String get paperDecorationNone => 'tiada';

  @override
  String get paperDecorationBotanical => 'daun';

  @override
  String get paperDecorationStars => 'Bintang';

  @override
  String get paperDecorationWashi => 'Pita washi';

  @override
  String get themeDarkChoice => 'Penampilan gelap';

  @override
  String get themeDarkSame => 'Ikut palet cahaya';

  @override
  String get themeDarkCustom => 'Palet berasingan';

  @override
  String get themeDarkAccent => 'Warna aksen gelap';

  @override
  String get themeColorTeal => 'Biru kehijauan';

  @override
  String get themeColorCyan => 'Cyan';

  @override
  String get themeColorIndigo => 'nila';

  @override
  String get themeColorCoral => 'karang';

  @override
  String get themeColorOlive => 'Zaitun';

  @override
  String get themeColorSlate => 'Batu tulis';

  @override
  String get drawingTitle => 'Melukis';

  @override
  String get drawingPen => 'Pen';

  @override
  String get drawingEraser => 'Pemadam';

  @override
  String get drawingUndo => 'Buat asal';

  @override
  String get drawingClear => 'Jelas';

  @override
  String get drawingWidth => 'Lebar pen';

  @override
  String get drawingStylusOnly => 'Stylus sahaja';

  @override
  String get drawingDiscardTitle => 'Buang lukisan?';

  @override
  String get drawingDiscardBody => 'Lukisan ini belum disimpan.';

  @override
  String get drawingSaveError => 'Tidak dapat menyimpan lukisan itu.';

  @override
  String get syncNetworkTitle => 'Diagnostik rangkaian';

  @override
  String get syncNetworkRefresh => 'Segarkan semula';

  @override
  String get syncNetworkSelectedRoute => 'Laluan semasa';

  @override
  String get syncNetworkAvailableRoutes => 'Laluan yang tersedia';

  @override
  String get syncNetworkSignaling => 'Sambungan direktori peranti';

  @override
  String get syncNetworkRelayRemaining => 'Baki elaun relay';

  @override
  String get syncNetworkIcePair => 'Calon sambungan langsung';

  @override
  String get syncNetworkPeerTrusted => 'Peranti yang disahkan';

  @override
  String get syncNetworkNoRoute => 'Menunggu sambungan';

  @override
  String get syncNetworkUnavailable => 'Diagnostik tidak tersedia';

  @override
  String get syncMediaCopiesTitle => 'Penghantaran media dan salinan';

  @override
  String get syncMediaPendingCount => 'Menunggu untuk dipindahkan';

  @override
  String get syncMediaDurableCount => 'Dihantar ke storan peribadi';

  @override
  String get syncMediaTemporaryCount => 'Salinan sementara atau tidak disahkan';

  @override
  String get syncMediaReceiptExplanation =>
      'Kiraan ini menerangkan penghantaran yang telah selesai, bukan audit baharu bagi sandaran yang masih ada.';

  @override
  String get syncMediaCacheExplanation =>
      'Media awan sementara boleh tamat tempoh. Simpan dokumen asal anda atau sandaran berasingan.';

  @override
  String get momentsTitle => 'Detik foto';

  @override
  String get momentsHint =>
      'Cari kumpulan menggunakan masa foto tempatan dan koordinat pilihan. Foto dilampirkan hanya apabila anda memilih kad.';

  @override
  String get momentsScan => 'Cari detik';

  @override
  String get momentsChooseFolder => 'Pilih folder foto';

  @override
  String get momentsLocation => 'Sertakan lokasi foto';

  @override
  String get momentsEmpty => 'Tiada kumpulan foto terbaru.';

  @override
  String get momentsCreate => 'Tulis tentang foto-foto ini';

  @override
  String get momentsDismiss => 'Tolak';

  @override
  String get momentsError => 'Tidak dapat membaca foto tempatan.';

  @override
  String get momentsCreated => 'Entri foto dibuat.';

  @override
  String get momentsPermission =>
      'Benarkan akses kepada foto untuk mencari cadangan setempat.';

  @override
  String get momentsScope =>
      'Foto terbaru sahaja; paling banyak 500 gambar dan 20 gambar setiap kad.';

  @override
  String momentsPhotoCount(int count) {
    return 'Foto $count';
  }

  @override
  String get nearbyTitle => 'Sambungkan peranti';

  @override
  String get nearbySend => 'Benarkan peranti lain';

  @override
  String get nearbyReceive => 'Sambung ke peranti sedia ada';

  @override
  String get nearbyInstructions =>
      'Sambungkan kedua-dua peranti ke Wi-Fi yang sama atau ke tempat liputan satu sama lain. Sahkan kebenaran pada peranti sedia ada; kedua-dua peranti kekal boleh digunakan. Tiada internet diperlukan.';

  @override
  String get nearbyCompare =>
      'Bandingkan kod ini pada kedua-dua peranti sebelum meluluskan.';

  @override
  String get nearbyConfirm => 'Kod sepadan';

  @override
  String get nearbyScan => 'Imbas kod peranti lain';

  @override
  String get nearbyPaste => 'Tampal jemputan';

  @override
  String get nearbyWaiting => 'Menunggu kelulusan pada peranti lain';

  @override
  String get nearbyWorking =>
      'Membenarkan dan menyegerakkan diari dan lampiran anda…';

  @override
  String get nearbyPending =>
      'Sesetengah lampiran masih memerlukan penyegerakan. Pastikan peranti lain dalam talian dan cuba lagi.';

  @override
  String get nearbyComplete =>
      'Peranti disambungkan; diari dan lampiran disegerakkan';

  @override
  String get nearbyFailed =>
      'Sambungan tidak selesai. Semak sambungan setempat dan cuba lagi.';

  @override
  String get nearbyEmptyRequired =>
      'Gunakan peranti dengan diari kosong yang belum disambungkan kepada penyegerakan lagi.';

  @override
  String get nearbyRetry => 'Teruskan penyegerakan';

  @override
  String get nearbyWifi => 'Tetapan Wi-Fi';

  @override
  String get nearbyHotspot => 'Tetapan tempat liputan';

  @override
  String get nearbyKeepOpen =>
      'Pastikan halaman ini terbuka sehingga peranti baharu selesai. Jemputan tamat tempoh selepas dua minit.';

  @override
  String get syncDevicesTitle => 'Peranti yang dibenarkan';

  @override
  String get syncDevicesDescription =>
      'Hanya peranti yang diluluskan boleh mengakses akaun AID ini. Membatalkan peranti menyekat pelayan tetapi tidak boleh memadamkan kunci induk atau diari yang telah disalin kepadanya.';

  @override
  String get syncDeviceRequest =>
      'Tunjukkan QR kebenaran ini kepada peranti yang diluluskan';

  @override
  String get syncDeviceAuthorize => 'Benarkan peranti';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Imbas atau tampal permintaan kebenaran peranti baharu.';

  @override
  String get syncDeviceRevoke => 'Batalkan';

  @override
  String get syncDeviceRotate => 'Putar kunci tandatangan peranti ini';

  @override
  String get syncDeviceCheck => 'Semak kebenaran';

  @override
  String get syncDeviceHardware => 'Kunci tandatangan yang disokong perkakasan';

  @override
  String get syncDeviceSoftware =>
      'Kunci tandatangan perisian tidak boleh dieksport';

  @override
  String get syncDeviceUnavailable =>
      'Keizinan peranti tidak tersedia. Luluskan peranti ini daripada peranti lain yang dibenarkan dan cuba semula.';

  @override
  String get syncDeviceRevoked => 'Dibatalkan';

  @override
  String get syncDeviceLocal => 'Peranti ini';

  @override
  String get cloudTrafficTitle =>
      'Kuota pemindahan data awan bulanan untuk fail media';

  @override
  String get cloudTrafficLimit => 'Kuota pemindahan data bulanan';

  @override
  String get cloudTrafficUsed => 'Pemindahan data digunakan';

  @override
  String get cloudTrafficRemaining => 'Pemindahan data yang tinggal';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'Kuota pemindahan data menetapkan semula $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'Kuota pemindahan data awan untuk fail media telah habis. Fail media yang hilang akan disegerakkan secara automatik apabila sambungan terus tersedia atau kuota ditetapkan semula.';

  @override
  String get cloudTrafficExplanation =>
      'Caching fail media dan geganti langsung berkongsi kuota pemindahan data ini. Sambungan langsung tidak memakannya. Teks diari dan mesej kawalan sambungan mempunyai had harian kecil yang berasingan.';

  @override
  String get appearanceThemeSection => 'Tema apl';

  @override
  String get appearancePaperSection => 'Kertas diari';

  @override
  String get appearanceTypographySection => 'Teks diari';

  @override
  String get appearancePreferencesSection => 'Keutamaan umum';

  @override
  String get themeSystemAccentHint =>
      'Menggunakan palet sistem dan bukannya warna tersuai. Matikan untuk memilih sendiri.';

  @override
  String get syncDeviceNameSaveFailed =>
      'Tidak dapat menyimpan nama peranti. Sila cuba lagi.';

  @override
  String get nearbyConnectionHelp => 'Bantuan sambungan';

  @override
  String get syncAllSynced => 'Semuanya disegerakkan';

  @override
  String get syncDetailsTitle => 'Butiran penyegerakan';

  @override
  String get syncMore => 'Lebih banyak pilihan';

  @override
  String get syncDeviceName => 'Nama peranti';

  @override
  String get syncDeviceNameHint => 'Contohnya: Tablet saya';

  @override
  String get syncDeviceNameInvalid => 'Gunakan 1 hingga 32 aksara';

  @override
  String get syncDeviceKeyDetails => 'Butiran keselamatan';

  @override
  String get syncConnectionProblem =>
      'Tidak dapat menyegerak buat masa ini. Mencuba semula secara automatik.';

  @override
  String get syncCopyComplete => 'Salinan lengkap diari dan fail media anda';

  @override
  String get syncCopyPartial => 'Beberapa media masih hilang';

  @override
  String get syncCopyOlder =>
      'Perubahan baharu sedang menunggu untuk disegerakkan';

  @override
  String get syncCopyUnavailable =>
      'Butiran salinan tidak tersedia. Cuba lagi nanti.';

  @override
  String get syncCopyLastKnown =>
      'Peranti lain menunjukkan salinan terakhir yang disahkan. Peranti luar talian tidak boleh disemak sekarang.';

  @override
  String get syncCopyTemporary =>
      'Cache sementara. Simpan yang asal pada peranti anda.';

  @override
  String get syncCopyStorage =>
      'Storan penyegerakan anda. Muat naik media yang lengkap disenaraikan dalam diagnostik.';

  @override
  String syncCopyChecked(String time) {
    return 'Terakhir disahkan $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Pemindahan data yang tinggal pada bulan ini: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Mulakan di sini';

  @override
  String get onboardConnect => 'Sambung ke peranti sedia ada';

  @override
  String get onboardFailed =>
      'Persediaan tidak dapat diselesaikan. Diari anda selamat; sila cuba lagi.';

  @override
  String get tutorialTitle => 'Cara menggunakan diari';

  @override
  String get tutorialWriteTitle => 'Tulis catatan diari pertama anda';

  @override
  String get tutorialWriteText =>
      'Ketik + untuk menulis entri diari. Tambahkan tajuk pilihan, pilih tarikh diari dan ketik tanda semak untuk menyimpan. Anda boleh mengedit entri diari anda semula pada bila-bila masa.';

  @override
  String get tutorialMediaTitle => 'Tambahkan foto, audio atau tulisan tangan';

  @override
  String get tutorialMediaText =>
      'Gunakan + dalam editor diari untuk melampirkan foto, video atau rakaman suara, atau untuk membuka kanvas tulisan tangan. Lampiran ini disimpan dengan entri diari.';

  @override
  String get tutorialReviewTitle => 'Cari hari lagi';

  @override
  String get tutorialReviewText =>
      'Semak imbas diari atau kalendar anda, cari tulisan anda dan susun entri dengan tag. Halaman Media dan Atlas membolehkan anda mencari entri lepas mengikut foto atau lokasi.';

  @override
  String get tutorialSyncTitle => 'Gunakan lebih daripada satu peranti';

  @override
  String get tutorialSyncText =>
      'Dalam Tetapan → Data & storan → Segerak, sambungkan ke peranti sedia ada dan sahkan kebenaran pada peranti itu. Kedua-dua peranti boleh terus menggunakan diari. Teks diari disegerakkan dahulu. Fail media disegerakkan seterusnya apabila sambungan rangkaian dan baki kuota pemindahan data membenarkannya.';

  @override
  String get tutorialPrivacyTitle => 'Simpan diari anda dengan selamat';

  @override
  String get tutorialPrivacyText =>
      'Entri diari kekal pada peranti ini melainkan anda mendayakan penyegerakan atau berkongsi atau mengeksportnya. Penyegerakan disulitkan dari hujung ke hujung. Dalam Tetapan anda juga boleh menetapkan kod laluan apl, membuat sandaran dan membuka semula tutorial ini.';

  @override
  String get editorDiaryDay => 'Hari diari';

  @override
  String get editorDiaryDayPicker => 'Hari diari · Catatan ini untuk hari apa?';

  @override
  String editorCreatedAt(String time) {
    return 'Dicipta $time';
  }

  @override
  String get editorDiaryDayHint =>
      'Hari yang ditetapkan untuk catatan ini. Mengubahnya tidak mengubah masa catatan dicipta.';

  @override
  String get hiddenDiaryTitle => 'Catatan tersembunyi';

  @override
  String get hiddenDiaryHide => 'Sembunyikan catatan';

  @override
  String get hiddenDiaryShow => 'Paparkan catatan';

  @override
  String get hiddenDiaryEmpty => 'Tiada catatan tersembunyi';

  @override
  String get hiddenDiaryUnlock => 'Buka kunci catatan tersembunyi';

  @override
  String get hiddenDiaryAuthHint =>
      'Gunakan kunci aplikasi atau kunci skrin peranti anda.';

  @override
  String hiddenDiaryWhere(String path) {
    return 'Disembunyikan. Untuk memaparkannya semula: $path';
  }

  @override
  String get noteKeep => 'Simpan';

  @override
  String get noteComment => 'Komen';

  @override
  String get noteCommentHint => 'Tulis kepada diri anda yang lalu';

  @override
  String get noteKept => 'Petikan disimpan';

  @override
  String get notesPassages => 'Petikan tersimpan';

  @override
  String get notesComments => 'Komen';

  @override
  String get noteDeleteConfirm => 'Padam nota ini?';

  @override
  String get editPastTitle => 'Sunting kenangan lalu?';

  @override
  String get editPastBody =>
      'Catatan ini dari hari terdahulu. Untuk membalasnya, pilih teks untuk disimpan atau dikomen.';

  @override
  String get editPastDontAsk => 'Jangan tanya lagi';

  @override
  String get editPastEdit => 'Sunting juga';

  @override
  String noteOnEntry(String date) {
    return 'Tentang catatan $date';
  }

  @override
  String get settingsConfirmEditPast => 'Tanya sebelum menyunting catatan lama';

  @override
  String get settingsCompressPhotos => 'Mampatkan foto baharu';

  @override
  String get settingsCompressPhotosHint =>
      'Simpan foto baharu sebagai WebP kira-kira 1 MB. Jika dimatikan, foto asal disimpan.';

  @override
  String get compressExistingTitle => 'Mampatkan foto sedia ada';

  @override
  String compressExistingBody(int count, String size) {
    return '$count foto menggunakan $size. Foto melebihi kira-kira 1 MB menjadi WebP kira-kira 1 MB. Ini menggantikannya dan tidak boleh dibuat asal; simpan foto asal di tempat lain jika perlu.';
  }

  @override
  String get compressExistingAction => 'Mampatkan';

  @override
  String compressExistingDone(int count, String size) {
    return '$count foto dimampatkan, jimat $size';
  }

  @override
  String get commentExpand => 'Kembangkan';

  @override
  String get refAdd => 'Petik catatan';

  @override
  String get refMissing => 'Catatan itu sudah tiada';

  @override
  String get moodClear => 'Kosongkan perasaan';

  @override
  String get scrollToTop => 'Kembali ke atas';

  @override
  String get feedbackTitle => 'Maklum balas';

  @override
  String get feedbackHint => 'Huraikan masalah atau cadangan';

  @override
  String get feedbackSend => 'Hantar';

  @override
  String get feedbackSent => 'Terima kasih, maklum balas anda telah dihantar.';

  @override
  String get feedbackSendFailed =>
      'Tidak dapat menghantar. Semak sambungan dan cuba lagi.';

  @override
  String get feedbackOpenFailed => 'Tidak dapat membuka aplikasi.';

  @override
  String get feedbackSendNote =>
      'Dihantar ke pelayan AID Diary bersama versi dan bahasa aplikasi, tiada apa-apa daripada diari anda.';

  @override
  String get feedbackGithub => 'Isu GitHub';

  @override
  String get feedbackEmail => 'Hantar e-mel';
}
