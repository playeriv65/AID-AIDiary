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
  String get themeColorTitle => 'Warna tema';

  @override
  String get themeColorHint => 'Pilih warna untuk palet ini.';

  @override
  String get themeColorBlue => 'Langit biru';

  @override
  String get themeColorGreen => 'Hijau hutan';

  @override
  String get themeColorBrown => 'Kopi hangat';

  @override
  String get themeColorPurple => 'warna lembayung muda';

  @override
  String get themeColorRose => 'Mawar berdebu';

  @override
  String get themeColorAmber => 'kuning';

  @override
  String get themeColorPreview => 'Sedikit setiap hari';

  @override
  String get themeTintBackgroundTitle =>
      'Warnai latar belakang dengan warna tema';

  @override
  String get themeTintBackgroundHint =>
      'Matikan untuk latar belakang abu-abu netral; tombol pertahankan warna pilihan Anda.';

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
      other: '$count minggu yang lalu',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bulan yang lalu',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tahun yang lalu',
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
      other: '$count catatan',
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
  String get iconGroupHome => 'Rumah';

  @override
  String get iconGroupTravel => 'Perjalanan';

  @override
  String get iconGroupSymbols => 'Simbol';

  @override
  String get tagCategoryLabel => 'Kategori';

  @override
  String get tagLabel => 'Menandai';

  @override
  String get tagCategoryUncategorized => 'Tanpa Kategori';

  @override
  String get newCategoryTitle => 'Kategori Baru';

  @override
  String get shareButtonLabel => 'Bagikan';

  @override
  String get importErrorDescription => 'Gagal mengimpor file!';

  @override
  String get exportErrorDescription => 'Gagal mengekspor file!';

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
  String get tagNameExists => 'Sudah ada tag dengan nama ini';

  @override
  String get categoryNameExists => 'Sudah ada kategori dengan nama ini';

  @override
  String deleteTemplateMessage(Object name) {
    return 'Hapus \"$name\"?';
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
  String get settingsBackupPasswordProtect => 'Cadangan Lindungi Kata Sandi';

  @override
  String get backupEncryptedTitle => 'Cadangan Terenkripsi';

  @override
  String get backupEncryptedContent => 'Cadangan ini dilindungi kata sandi.';

  @override
  String get settingsAutoBackup => 'Pencadangan Otomatis';

  @override
  String get settingsAutoBackupLocation => 'Lokasi Cadangan';

  @override
  String get settingsAutoBackupInterval => 'Interval Cadangan';

  @override
  String get settingsAutoBackupIntervalDaily => 'Setiap hari';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Mingguan';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Bulanan';

  @override
  String get settingsAutoBackupMaxCount => 'Cadangan Untuk Disimpan';

  @override
  String get settingsAutoBackupRequireCharging => 'Hanya Saat Mengisi Daya';

  @override
  String settingsBackupLast(Object time) {
    return 'Cadangan terakhir $time';
  }

  @override
  String get settingsBackupNever => 'Tidak pernah membuat cadangan';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Selanjutnya cadangan $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'Semua';

  @override
  String get autoBackupFailedTitle => 'Pencadangan Gagal';

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
    return 'Mengenkripsi Cadangan… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Mendekripsi Cadangan… $percent%';
  }

  @override
  String get cleanUpStatus => 'Membersihkan…';

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
  String get settingsAppLanguageTitle => 'Bahasa Aplikasi';

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
  String get settingsOpenSourceLicenses => 'Lisensi Sumber Terbuka';

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
  String get shareAddToLogPickerTitle => 'Pilih entri buku harian';

  @override
  String get adaptiveEmptyDay => 'Belum ada entri untuk hari ini';

  @override
  String get adaptiveNewEntry => 'Tulis entri';

  @override
  String get pageJournalTitle => 'Jurnal';

  @override
  String get coachPrompt1 => 'Apa yang membuatmu tersenyum hari ini?';

  @override
  String get coachPrompt2 => 'Apa satu hal yang kamu pelajari hari ini?';

  @override
  String get coachPrompt3 =>
      'Dengan siapa Anda berbicara hari ini, dan bagaimana rasanya?';

  @override
  String get coachPrompt4 => 'Apa yang kamu syukuri saat ini?';

  @override
  String get coachPrompt5 =>
      'Apa yang menghabiskan sebagian besar energimu hari ini?';

  @override
  String get coachPrompt6 => 'Jelaskan momen kecil yang ingin Anda ingat.';

  @override
  String get coachPrompt7 =>
      'Apa yang membuat hari esok menjadi hari yang baik?';

  @override
  String get coachPrompt8 => 'Apa yang ada di pikiranmu akhir-akhir ini?';

  @override
  String get coachPrompt9 =>
      'Apa yang kamu lakukan hari ini hanya untuk dirimu sendiri?';

  @override
  String get coachPrompt10 => 'Kalau hari ini ada judulnya, apa judulnya?';

  @override
  String get pageMediaTitle => 'Media';

  @override
  String get pageAtlasTitle => 'Atlas';

  @override
  String get pageCoachTitle => 'Pelatih';

  @override
  String get noEntrySelected => 'Tidak ada entri yang dipilih.';

  @override
  String get entryShare => 'Bagikan';

  @override
  String get entryFavorite => 'Bintang';

  @override
  String get entryEdit => 'Sunting';

  @override
  String get entryPrevious => 'Entri sebelumnya';

  @override
  String get entryNext => 'Entri selanjutnya';

  @override
  String get journalStories => 'Cerita';

  @override
  String get journalEntries => 'Entri';

  @override
  String get journalEmptyHint =>
      'Mulailah buku harian Anda dengan menambahkan entri baru.';

  @override
  String get storyToday => 'Hari ini';

  @override
  String get storyThrowback => 'Kemunduran';

  @override
  String get storyNoThrowback => 'Tidak ada kemunduran hari ini';

  @override
  String get mediaFiles => 'File media';

  @override
  String get mediaEmpty => 'Belum ada foto.';

  @override
  String get mediaEmptyHint =>
      'Foto yang dilampirkan pada entri akan ditampilkan di sini.';

  @override
  String get atlasEmpty => 'Tidak ada entri dengan lokasi.';

  @override
  String get atlasEmptyHint => 'Entri dengan lokasi akan ditampilkan di sini.';

  @override
  String get atlasShowAll => 'Tampilkan semua entri';

  @override
  String get atlasMyLocation => 'Lokasi saya';

  @override
  String get coachAll => 'Semua';

  @override
  String get coachPrograms => 'Program';

  @override
  String get coachTemplates => 'Templat';

  @override
  String get coachKindProgram => 'Program';

  @override
  String get coachKindTemplate => 'Templat';

  @override
  String get coachNoTemplates => 'Tidak ada program atau templat.';

  @override
  String get coachUseTemplate => 'Tulis dengan templat ini';

  @override
  String get coachProgramEverydayTitle => 'Momen sehari-hari';

  @override
  String get coachProgramEverydayDescription =>
      'Lima pertanyaan singkat, satu pertanyaan sehari. Masing-masing membutuhkan satu atau dua menit dan membantu Anda melihat apa yang menjadikan hari itu milik Anda. Cara lembut untuk membangun kebiasaan menulis sedikit-sedikit setiap hari.';

  @override
  String get coachProgramReflectTitle => 'Melihat ke dalam';

  @override
  String get coachProgramReflectDescription =>
      'Satu pertanyaan lebih dalam setiap minggu, selama lima minggu. Luangkan waktu Anda untuk setiap hal: bagaimana perasaan Anda, apa yang membuat Anda lelah, apa yang Anda syukuri.';

  @override
  String get searchFilters => 'Filter';

  @override
  String get searchFilterTags => 'Tag';

  @override
  String get searchFilterStarred => 'Berbintang';

  @override
  String get searchHint => 'Ketik untuk mencari, atau pilih filter.';

  @override
  String get locationTitle => 'Lokasi';

  @override
  String get locationName => 'Nama tempat';

  @override
  String get locationRemove => 'Hapus';

  @override
  String get locationServiceDisabled => 'Layanan lokasi dimatikan.';

  @override
  String get locationPermissionDenied => 'Izin lokasi ditolak.';

  @override
  String get locationUnavailable => 'Tidak dapat memperoleh lokasi saat ini.';

  @override
  String get calendarJumpToToday => 'Lompat ke hari ini';

  @override
  String get editorStartWriting => 'Mulailah menulis atau pilih a ';

  @override
  String get editorTemplateLink => 'Templat';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Pilih templat';

  @override
  String get templateFeatured => 'Templat unggulan';

  @override
  String get templateMine => 'Templat saya';

  @override
  String get templateDailyName => 'Ulasan harian';

  @override
  String get templateDailyDescription =>
      'Apa yang terjadi, bagaimana rasanya, dan apa yang terjadi selanjutnya.';

  @override
  String get templateDailyText =>
      '## Apa yang terjadi hari ini\n\n\n## Bagaimana perasaanku\n\n\n## Tiga hal yang saya syukuri\n1. \n2. \n3. \n\n## Besok\n';

  @override
  String get templateTravelName => 'Entri buku harian perjalanan';

  @override
  String get templateTravelDescription =>
      'Tempat, momen, dan makanan dari jalan.';

  @override
  String get templateTravelText =>
      '## Kemana saya pergi\n\n\n## Momen yang paling kuingat\n\n\n## Apa yang saya makan\n\n\n## Rencana untuk besok\n';

  @override
  String get templateReadingName => 'Membaca catatan';

  @override
  String get templateReadingDescription =>
      'Kutipan dan pemikiran dari apa yang Anda baca.';

  @override
  String get templateReadingText =>
      '## Buku\n\n\n## Dimana saya berada\n\n\n## Kutipan\n> \n\n## Pikiranku\n';

  @override
  String get templateWeeklyName => 'Ulasan mingguan';

  @override
  String get templateWeeklyDescription =>
      'Sorotan, perjuangan, dan fokus minggu depan.';

  @override
  String get templateWeeklyText =>
      '## Sorotan\n\n\n## Apa yang sulit\n\n\n## Apa yang saya pelajari\n\n\n## Fokus untuk minggu depan\n';

  @override
  String get entryDuplicate => 'Duplikat';

  @override
  String get entryDuplicated => 'Entri diduplikasi';

  @override
  String get entrySaveAsTemplate => 'Simpan sebagai templat';

  @override
  String get entrySavedAsTemplate => 'Disimpan sebagai templat';

  @override
  String get storyStatistics => 'Statistik';

  @override
  String get storyMoodChart => 'Bagan suasana hati';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return 'Entri $entries · $days hari';
  }

  @override
  String get storyThisYear => 'Tahun ini';

  @override
  String get storyLastYear => 'Tahun lalu';

  @override
  String get storyTapToOpen => 'Ketuk hari untuk membukanya';

  @override
  String get settingsGeneralTitle => 'Umum';

  @override
  String get settingsDataTitle => 'Data & penyimpanan';

  @override
  String get settingsStoriesTitle => 'Cerita';

  @override
  String get settingsHelpTitle => 'Bantuan & tentang';

  @override
  String get weatherTitle => 'Cuaca';

  @override
  String get weatherClear => 'Jelas';

  @override
  String get weatherPartlyCloudy => 'Sebagian berawan';

  @override
  String get weatherCloudy => 'Berawan';

  @override
  String get weatherFog => 'Kabut';

  @override
  String get weatherDrizzle => 'Gerimis';

  @override
  String get weatherRain => 'Hujan';

  @override
  String get weatherSnow => 'Salju';

  @override
  String get weatherStorm => 'Badai petir';

  @override
  String get weatherFetch => 'Dapatkan cuaca untuk entri ini';

  @override
  String get weatherNeedsLocation =>
      'Tambahkan lokasi dengan koordinat terlebih dahulu.';

  @override
  String get weatherUnavailable =>
      'Cuaca tidak tersedia untuk tempat dan waktu ini.';

  @override
  String get weatherRemove => 'Hapus cuaca';

  @override
  String get activityTitle => 'Aktivitas';

  @override
  String get activityStill => 'Tetap saja';

  @override
  String get activityWalking => 'Berjalan';

  @override
  String get activityRunning => 'Berlari';

  @override
  String get activityCycling => 'Bersepeda';

  @override
  String get activityVehicle => 'Di dalam kendaraan';

  @override
  String get activityFlying => 'Terbang';

  @override
  String get activityExercise => 'Latihan';

  @override
  String get activityDetect => 'Deteksi aktivitas saat ini';

  @override
  String get activityDetectFailed => 'Tidak dapat mendeteksi aktivitas.';

  @override
  String get activityRemove => 'Hapus aktivitas';

  @override
  String get settingsAutoAddTitle => 'Tambahkan secara otomatis';

  @override
  String get settingsAutoAddLocation => 'Lokasi';

  @override
  String get settingsAutoAddWeather => 'Cuaca';

  @override
  String get settingsAutoAddHint => 'Entri baru mengisinya saat dibuat.';

  @override
  String get settingsTemperatureUnit => 'Satuan suhu';

  @override
  String get settingsCelsius => 'Celcius (°C)';

  @override
  String get settingsFahrenheit => 'Fahrenheit (°F)';

  @override
  String get moodGreat => 'Bagus';

  @override
  String get moodGood => 'Bagus';

  @override
  String get moodOkay => 'Oke';

  @override
  String get moodBad => 'Buruk';

  @override
  String get moodAwful => 'Mengerikan';

  @override
  String get locationSearchHint => 'Cari tempat';

  @override
  String get locationSearchEmpty => 'Tidak ada tempat yang ditemukan';

  @override
  String get settingsWallpaper => 'kertas dinding';

  @override
  String get wallpaperNone => 'Tidak ada';

  @override
  String get wallpaperDots => 'titik';

  @override
  String get wallpaperGrid => 'jaringan';

  @override
  String get wallpaperLines => 'Garis';

  @override
  String get wallpaperPhoto => 'Foto…';

  @override
  String get settingsFontFamily => 'huruf';

  @override
  String get fontSystem => 'Sistem';

  @override
  String get fontSerif => 'Serif';

  @override
  String get fontMono => 'Ruang tunggal';

  @override
  String get settingsFontSize => 'Ukuran huruf';

  @override
  String get fontSizeSmall => 'Kecil';

  @override
  String get fontSizeMedium => 'Sedang';

  @override
  String get fontSizeLarge => 'Besar';

  @override
  String get fontSizeExtraLarge => 'Ekstra besar';

  @override
  String get settingsLineSpacing => 'Spasi baris';

  @override
  String get lineSpacingCompact => 'Kompak';

  @override
  String get lineSpacingNormal => 'Biasa';

  @override
  String get lineSpacingRelaxed => 'Santai';

  @override
  String get moodAssociationsTitle => 'Apa yang membuatku merasa…';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching dari entri $total';
  }

  @override
  String get videoRecord => 'Rekam video';

  @override
  String get videoChoose => 'Pilih video';

  @override
  String get audioRecordTitle => 'Rekam catatan suara';

  @override
  String get audioChoose => 'Pilih file audio';

  @override
  String get audioStart => 'Rekam';

  @override
  String get audioStop => 'Berhenti dan simpan';

  @override
  String get audioPermissionDenied =>
      'Akses mikrofon tidak aktif. Izinkan di pengaturan sistem.';

  @override
  String get mediaTooLarge => 'Video ini terlalu besar untuk dilampirkan.';

  @override
  String get mediaUnavailable =>
      'Lampiran ini tidak tersedia di perangkat ini.';

  @override
  String get widgetDone => 'Entri hari ini telah ditulis';

  @override
  String get widgetPending => 'Bagaimana harimu?';

  @override
  String get widgetWrite => 'Menulis';

  @override
  String get insertChecklist => 'Daftar periksa';

  @override
  String get insertNumberedList => 'Daftar bernomor';

  @override
  String get insertTable => 'Tabel';

  @override
  String get insertDivider => 'Pembagi';

  @override
  String get insertCodeBlock => 'Blok kode';

  @override
  String get journalSortTitle => 'Urutkan entri';

  @override
  String get journalSortUpdated => 'Terakhir diperbarui';

  @override
  String get settingsTimeFormat => 'Format waktu';

  @override
  String get settingsDayStart =>
      'Entri baru dihitung untuk hari sebelumnya hingga';

  @override
  String get settingsDayAskUntil => 'Lalu tanyakan sampai hari apa';

  @override
  String get settingsDayStartMidnight => 'Mati';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Setiap entri menyimpan hari di sebelah waktu penulisannya, dan Anda dapat mengubah hari itu di editor kapan saja. Jam ini hanya memilih hari untuk entri baru, jadi mengubahnya tidak akan memindahkan entri yang sudah ada.';

  @override
  String get lateNightBadge =>
      'Ditulis larut malam, dihitung sehari sebelumnya';

  @override
  String editorDayAsk(String time) {
    return 'Ditulis di $time. Untuk hari apa?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (kemarin)';
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
  String get shareImage => 'Bagikan gambar';

  @override
  String get shareSaveImage => 'Simpan gambar';

  @override
  String get shareSaved => 'Gambar disimpan';

  @override
  String get deletedTitle => 'Baru-baru ini dihapus';

  @override
  String get deletedNone => 'Tidak ada yang dihapus baru-baru ini';

  @override
  String deletedHint(int days) {
    return 'Entri yang dihapus tetap di sini selama $days hari, lalu dihapus.';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days hari tersisa';
  }

  @override
  String get deletedRestore => 'Pulihkan';

  @override
  String get deletedDeleteForever => 'Hapus selamanya';

  @override
  String get deletedDeleteForeverDescription =>
      'Entri dan lampirannya dihapus. Hal ini tidak dapat dibatalkan.';

  @override
  String get deletedEmpty => 'Kosong';

  @override
  String get deletedEmptyDescription =>
      'Hapus setiap entri di Baru saja dihapus? Hal ini tidak dapat dibatalkan.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Jalan acak';

  @override
  String get randomSubtitle => 'Buka entri sebelumnya';

  @override
  String get randomNext => 'Lainnya';

  @override
  String get randomAll => 'Semua';

  @override
  String get randomWithPhotos => 'Dengan foto';

  @override
  String get randomGoodDays => 'Hari baik';

  @override
  String get randomEmpty => 'Tidak ada entri untuk dipilih';

  @override
  String get reviewWeekTitle => 'Minggu ini';

  @override
  String get reviewWeekSubtitle => 'Minggu Anda sejauh ini';

  @override
  String get reviewYearTitle => 'Tahun ini';

  @override
  String get reviewEmpty => 'Belum ada yang tertulis';

  @override
  String get reviewEntries => 'Entri';

  @override
  String get reviewDaysWritten => 'Hari-hari tertulis';

  @override
  String get reviewWords => 'Kata-kata';

  @override
  String get reviewPhotos => 'Foto';

  @override
  String get reviewLongestRun => 'Hari-hari terlama';

  @override
  String get reviewAverageMood => 'Suasana hati rata-rata';

  @override
  String get reviewFavorites => 'Paling sering';

  @override
  String get reviewByMonth => 'Berdasarkan bulan';

  @override
  String get reviewHighlight => 'Sorot';

  @override
  String get yearInPixels => 'Tahun dalam piksel';

  @override
  String get capsuleSeal => 'Segel sebagai kapsul waktu';

  @override
  String get capsuleTitle => 'Kapsul waktu';

  @override
  String capsuleOpensOn(Object date) {
    return 'Dibuka pada $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Ditulis pada $date';
  }

  @override
  String get capsuleOpenEarly => 'Buka lebih awal';

  @override
  String get capsuleOpenEarlyDescription =>
      'Kapsulnya sekarang terbuka dan tetap terbuka.';

  @override
  String get capsuleOpened => 'Kapsul waktu terbuka';

  @override
  String get templateMorningName => 'Halaman pagi';

  @override
  String get templateMorningDescription => 'Atur hari dalam tiga menit';

  @override
  String get templateMorningText =>
      '## Tiga hal yang ingin saya lakukan dengan baik hari ini\n1. \n2. \n3. \n\n## Sesuatu yang saya nantikan\n\n## Catatan untuk diriku sendiri\n';

  @override
  String get templateEveningName => 'Ulasan malam';

  @override
  String get templateEveningDescription =>
      'Tutup hari dengan apa yang berjalan baik';

  @override
  String get templateEveningText =>
      '## Tiga hal baik hari ini\n1. \n2. \n3. \n\n## Apa yang saya pelajari\n\n## Apa yang bisa lebih baik besok\n';

  @override
  String get routineMorning => 'Selamat pagi';

  @override
  String get routineEvening => 'Ulasan malam';

  @override
  String get settingsRoutinePrompts => 'Perintah pagi dan sore';

  @override
  String get settingsRoutinePromptsHint =>
      'Sarankan templat pagi atau sore hari di Stories';

  @override
  String get checkInTitle => 'Check-in cepat';

  @override
  String get checkInSubtitle => 'Suasana hati dalam dua ketukan';

  @override
  String get checkInMood => 'Bagaimana perasaanmu?';

  @override
  String get checkInActivity => 'Apa yang kamu lakukan?';

  @override
  String get checkInNote => 'Satu baris tentang hal itu (opsional)';

  @override
  String get checkInSave => 'Simpan';

  @override
  String editorWordCount(int words, int characters) {
    return 'Kata $words · Karakter $characters';
  }

  @override
  String get coachProgramEverydayTagline =>
      'Perhatikan hal-hal kecil dalam sehari.';

  @override
  String get coachProgramReflectTagline =>
      'Pelan-pelan dan dengarkan diri Anda sendiri.';

  @override
  String get coachDuration => 'Durasi';

  @override
  String get coachInterval => 'selang waktu';

  @override
  String get coachDifficulty => 'Kesulitan';

  @override
  String get coachIntervalDaily => 'Setiap hari';

  @override
  String get coachIntervalWeekly => 'Mingguan';

  @override
  String get coachDifficultyBeginner => 'Pemula';

  @override
  String get coachDifficultyIntermediate => 'Menengah';

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
  String get coachEndProgram => 'Akhiri program';

  @override
  String get coachAuthor => 'Penulis';

  @override
  String get coachAuthorBio => 'Anjuran ditulis untuk aplikasi ini.';

  @override
  String get coachEnrolledTip =>
      'Sudah siap! Pertanyaan Anda akan muncul di Stories.';

  @override
  String get coachGoToStories => 'Buka Cerita';

  @override
  String get coachAnswerHint => 'Tulis jawaban Anda…';

  @override
  String get storyWrapUp => 'Itu saja untuk hari ini.';

  @override
  String get storyTapToClose => 'Ketuk untuk menutup';

  @override
  String get coachAnswerDone => 'Selesai';

  @override
  String get coachAnswered => 'Dijawab, ketuk untuk membuka';

  @override
  String get coachAnsweredEarlier => 'Dijawab';

  @override
  String get locationLocating => 'Menemukan…';

  @override
  String get locationPickPlace => 'Pilih tempat';

  @override
  String get locationPlacesHint => 'Alamat atau nama tempat';

  @override
  String get locationCustom => 'Tempat khusus';

  @override
  String get locationCurrent => 'Lokasi saat ini';

  @override
  String get locationSaved => 'Tempat yang disimpan';

  @override
  String get locationSearchResults => 'Hasil pencarian';

  @override
  String get locationNearby => 'Tempat-tempat terdekat';

  @override
  String get locationRename => 'Ganti nama';

  @override
  String get locationSavePlace => 'Menghemat tempat';

  @override
  String get locationUnsavePlace => 'Hapus dari tempat yang disimpan';

  @override
  String get shareAs => 'Bagikan sebagai…';

  @override
  String get shareAsImage => 'Gambar';

  @override
  String get shareAsZip => 'ZIP dengan media aslinya';

  @override
  String get shareAsPlainText => 'Teks biasa';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Selamat datang di AID Diary';

  @override
  String get onboardWelcomeText =>
      'Mulai di sini, atau sambungkan perangkat ini ke perangkat yang sudah Anda gunakan.';

  @override
  String get onboardStart => 'Mulailah menulis';

  @override
  String get helpFaq => 'Pertanyaan yang sering diajukan';

  @override
  String get helpFaq1Q => 'Di mana buku harian saya disimpan?';

  @override
  String get helpFaq1A =>
      'Buku harian Anda disimpan di perangkat ini. Ini menjangkau perangkat atau penyimpanan lain hanya ketika Anda mengaktifkan sinkronisasi, berbagi, atau mengekspornya. Sinkronisasi dienkripsi ujung ke ujung.';

  @override
  String get helpFaq2Q =>
      'Bagaimana cara menyimpan salinan atau memindahkannya ke perangkat baru?';

  @override
  String get helpFaq2A =>
      'Hubungkan ke perangkat yang ada di Pengaturan → Data & penyimpanan → Sinkronkan dan konfirmasikan otorisasi pada perangkat yang memiliki buku harian Anda. Kedua perangkat tetap dapat digunakan. Anda juga dapat membuat cadangan dan memulihkannya di perangkat lain.';

  @override
  String get helpFaq3Q =>
      'Bisakah saya memasukkan entri dari aplikasi buku harian lain?';

  @override
  String get helpFaq3A =>
      'Ya: di Pengaturan → Data & penyimpanan, impor ekspor dari Daylio, Diarium, Diaro, DayBook, My Brain, OneShot dan Pixels, atau ekspor JSON.';

  @override
  String get helpFaq4Q => 'Bagaimana cara kerja program pelatih?';

  @override
  String get helpFaq4A =>
      'Mendaftarlah dalam sebuah program di halaman Pelatih. Setiap hari atau minggu, pertanyaan baru menunggu di Stories; jawaban Anda disimpan sebagai entri.';

  @override
  String get helpFaq5Q => 'Bagaimana jika saya lupa kode sandi saya?';

  @override
  String get helpFaq5A =>
      'Kode sandi tidak dapat dipulihkan, jadi simpanlah cadangan buku harian Anda.';

  @override
  String get helpPrivacy => 'Privasi';

  @override
  String get helpPrivacyText =>
      'Konten dan media buku harian tetap ada di perangkat ini kecuali Anda mengaktifkan sinkronisasi terenkripsi atau membagikan/mengekspornya. Peta, pencarian tempat, dan cuaca menggunakan layanan yang dikonfigurasi dan mengirimkan lokasi atau permintaan pencarian yang diperlukan untuk permintaan tersebut, bukan teks buku harian.';

  @override
  String get photoMetaTitle => 'Gunakan detail foto?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Hitung entri ini untuk $date dan atur tempatnya ke $place, seperti yang terekam di foto?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Hitung entri ini untuk $date, kapan foto diambil?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Setel tempat entri ini ke $place, di mana foto itu diambil?';
  }

  @override
  String get photoMetaApply => 'Gunakan mereka';

  @override
  String get quickWriteTitle => 'Tulis cepat';

  @override
  String get quickWriteText => 'Ketuk untuk memulai entri baru.';

  @override
  String get settingsQuickWriteTitle => 'Tulis cepat di notifikasi';

  @override
  String get settingsQuickWriteDescription =>
      'Simpan pemberitahuan yang membuka entri baru.';

  @override
  String get settingsNudgesTitle =>
      'Sikut aku setelah melakukan peregangan yang tenang';

  @override
  String settingsNudgesDescription(int days) {
    return 'Pengingat lembut ketika Anda belum menulis selama $days.';
  }

  @override
  String get nudgeTitle => 'Sudah lama tidak bertemu';

  @override
  String get nudgeMonday => 'Minggu baru: apa yang kamu nantikan?';

  @override
  String get nudgeTuesday => 'Dua baris sudah cukup. Apa kabarmu hari ini?';

  @override
  String get nudgeWednesday => 'Setengah minggu. Apa yang menonjol sejauh ini?';

  @override
  String get nudgeThursday =>
      'Adakah hal kecil yang layak disimpan mulai hari ini?';

  @override
  String get nudgeFriday =>
      'Minggu ini sudah berakhir. Catat satu momen bagus.';

  @override
  String get nudgeSaturday =>
      'Sabtu yang lambat adalah hari yang baik untuk menulis.';

  @override
  String get nudgeSunday => 'Lihat kembali minggu sebelum itu berakhir.';

  @override
  String get photoWidgetEmpty =>
      'Foto yang Anda tambahkan ke entri muncul di sini.';

  @override
  String get channelReminders => 'Pengingat';

  @override
  String get channelOnThisDay => 'Pada hari ini';

  @override
  String get channelCoach => 'Pelatih meminta';

  @override
  String get channelNudges => 'Menyenggol setelah hari-hari tenang';

  @override
  String get channelQuickWrite => 'Tulis cepat';

  @override
  String get channelBackup => 'Cadangan';

  @override
  String get formatJsonExport => 'JSON (ekspor AID Diary)';

  @override
  String get aboutModifiedNotice =>
      'Versi modifikasi dari Daily You oleh Demizo dan kontributor. Ini bukan aplikasi resmi Daily You.';

  @override
  String get toolbarPhotos => 'Tambahkan foto';

  @override
  String get toolbarMedia => 'Foto dan video';

  @override
  String get mediaFromGallery => 'Pilih dari galeri';

  @override
  String get mediaFromFiles => 'Pilih dari file';

  @override
  String get editorLeaveTitle => 'Simpan entri ini?';

  @override
  String get editorLeaveDiscard => 'Jangan simpan';

  @override
  String get editorTitleHint => 'Judul';

  @override
  String get editorLocating => 'Menemukan…';

  @override
  String get toolbarVideo => 'Video';

  @override
  String get toolbarAudio => 'Catatan suara';

  @override
  String get toolbarTags => 'Tag';

  @override
  String get toolbarBulletList => 'Daftar berpoin';

  @override
  String get toolbarHeading => 'Menuju';

  @override
  String get toolbarBold => 'Berani';

  @override
  String get toolbarItalic => 'miring';

  @override
  String get toolbarHighlight => 'Sorot';

  @override
  String get toolbarStrikethrough => 'Dicoret';

  @override
  String get toolbarQuote => 'Kutipan';

  @override
  String get toolbarLink => 'Tautan';

  @override
  String get toolbarInsert => 'Sisipkan';

  @override
  String get toolbarUndo => 'Membatalkan';

  @override
  String get toolbarRedo => 'Ulangi';

  @override
  String get toolbarInsertDate => 'Masukkan tanggalnya';

  @override
  String get toolbarInsertTime => 'Masukkan waktu';

  @override
  String get settingsSyncTitle => 'Sinkronisasi Awan';

  @override
  String get syncOffDescription =>
      'Jaga agar buku harian ini tetap sama di semua perangkat Anda melalui Google Drive atau server WebDAV, seperti Nextcloud, Synology, atau Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'Sinkronkan dengan Google Drive';

  @override
  String get syncOrWebDav => 'Atau server WebDAV';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn => 'Masuk. Anda dapat kembali ke AID Diary.';

  @override
  String get syncGoogleSignInAgain => 'Google mengharuskan Anda masuk lagi.';

  @override
  String get syncSignInAgain => 'Masuk lagi';

  @override
  String get settingsCommandLineTitle => 'Baris perintah';

  @override
  String get commandLineToggle => 'Antarmuka baris perintah';

  @override
  String get commandLineToggleHint =>
      'Mengizinkan perintah bantuan dan program lain di perangkat ini menggunakan perintah aplikasi.';

  @override
  String get commandLineAlwaysOn =>
      'Selalu aktif dalam pembangunan pembangunan.';

  @override
  String commandLineListening(int port) {
    return 'Mendengarkan di port $port';
  }

  @override
  String get commandPaletteTitle => 'Semua perintah';

  @override
  String get commandPaletteSearch => 'Perintah pencarian';

  @override
  String get commandPaletteRun => 'Jalankan';

  @override
  String get commandPaletteConfirm =>
      'Hal ini tidak dapat dibatalkan begitu saja. Jalankan?';

  @override
  String syncReceiving(int done, int total) {
    return 'Menerima $done dari $total…';
  }

  @override
  String syncSending(int done, int total) {
    return 'Mengirim $done dari $total…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'Akses ke Google Drive tidak diizinkan. Hubungkan kembali dan centang Google Drive di halaman Google.';

  @override
  String get syncEntryUnsynced =>
      'Tidak disinkronkan: sinkronisasi terakhir tidak berhasil';

  @override
  String get syncUseOfficial => 'Gunakan server sinkronisasi AID';

  @override
  String get syncServer => 'Alamat server';

  @override
  String get syncUsername => 'Nama pengguna';

  @override
  String get syncPassword => 'Kata sandi';

  @override
  String get syncConnect => 'Hubungkan';

  @override
  String get syncConnecting => 'Menghubungkan…';

  @override
  String get syncSignInFailed =>
      'Tidak dapat masuk. Periksa alamat, nama pengguna, dan kata sandi.';

  @override
  String syncConnectFailed(String error) {
    return 'Tidak dapat terhubung: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Mulai sinkronisasi';

  @override
  String get syncNewSpaceDescription =>
      'Belum ada buku harian yang disinkronkan di sini. Buku harian ini akan diunggah, dienkripsi ujung ke ujung dengan kunci yang tetap ada di perangkat Anda.';

  @override
  String get syncJoinTitle =>
      'Bergabunglah dengan buku harian yang disinkronkan';

  @override
  String get syncWrongKey =>
      'Kode pemulihan ini tidak membuka buku harian yang disinkronkan.';

  @override
  String syncLastSynced(String time) {
    return '$time yang terakhir disinkronkan';
  }

  @override
  String get syncNever => 'Belum disinkronkan';

  @override
  String get syncSyncing => 'Menyinkronkan…';

  @override
  String syncFailed(String error) {
    return 'Sinkronisasi terakhir gagal: $error';
  }

  @override
  String get syncLocked =>
      'Buku harian yang disinkronkan sekarang menjadi milik perangkat lain, atau telah dimulai dari awal. Pasangkan dengan salah satunya atau gunakan kode pemulihan untuk terus menyinkronkan.';

  @override
  String get syncNow => 'Sinkronkan sekarang';

  @override
  String get syncUnlock => 'Buka kunci';

  @override
  String get syncEncrypted => 'Dienkripsi ujung ke ujung';

  @override
  String get syncDisconnect => 'Hentikan sinkronisasi';

  @override
  String get syncDisconnectDescription =>
      'Perangkat ini berhenti menyinkronkan. Buku harian di sini dan salinan yang disinkronkan tetap sebagaimana adanya.';

  @override
  String get syncOwnRecoveryPassword =>
      'Gunakan kata sandi pemulihan saya sendiri';

  @override
  String get syncRecoveryPassword => 'Kata sandi pemulihan';

  @override
  String get syncRecoveryPasswordRepeat => 'Ulangi kata sandi pemulihan';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Gunakan setidaknya karakter $min';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'Kata sandinya berbeda';

  @override
  String get syncRecoveryCode => 'Kode pemulihan';

  @override
  String get syncRecoveryCodeTitle => 'Simpan kode pemulihan Anda';

  @override
  String get syncRecoveryCodeDescription =>
      'Jika setiap perangkat Anda hilang, kode ini memulihkan buku harian Anda yang disinkronkan. Simpan di pengelola kata sandi atau di atas kertas. Itu hanya ditampilkan sekali ini saja.';

  @override
  String get syncRecoveryCodeCopied => 'Kode pemulihan disalin';

  @override
  String get syncRecoveryCodeSaved => 'Saya telah menyimpannya';

  @override
  String get syncJoinNeedsKey =>
      'Buku harian yang disinkronkan ini milik perangkat Anda yang lain. Sandingkan dengan salah satunya, atau gunakan kode pemulihan. Entri pada perangkat ini akan ditambahkan ke dalamnya.';

  @override
  String get syncPairDevice => 'Sandingkan dengan perangkat';

  @override
  String get syncUseRecoveryCode => 'Gunakan kode pemulihan';

  @override
  String get syncAddDevice => 'Tambahkan perangkat';

  @override
  String get syncChangeRecoveryCode => 'Ubah kode pemulihan';

  @override
  String get syncChangeRecoveryDescription =>
      'Kode baru menggantikan kode saat ini, yang berhenti berfungsi. Data Anda dan perangkat lain tetap apa adanya.';

  @override
  String get syncNewRandomCode => 'Kode acak baru';

  @override
  String get syncRecoveryCodeChanged => 'Kode pemulihan diubah';

  @override
  String get syncResetSpace => 'Mulai buku harian yang disinkronkan';

  @override
  String get syncResetSpaceDescription =>
      'Hanya ketika tidak ada perangkat dan kode pemulihan yang membukanya lagi: salinan yang disinkronkan digantikan oleh buku harian di perangkat ini, di bawah kunci perangkat ini. Perangkat Anda yang lain kemudian dipasangkan lagi.';

  @override
  String get syncPairTitle => 'Pasangkan perangkat';

  @override
  String get syncPairShow => 'Tunjukkan kode';

  @override
  String get syncPairEnter => 'Masukkan kode';

  @override
  String get syncPairShowHint =>
      'Di perangkat Anda yang lain, buka Pasangkan perangkat, pilih Masukkan kode, dan ketik atau pindai ini.';

  @override
  String get syncPairEnterHint =>
      'Ketikkan kode yang ditampilkan perangkat Anda yang lain, atau pindai.';

  @override
  String get syncPairCode => 'Kode berpasangan';

  @override
  String get syncPairScan => 'Pindai';

  @override
  String get syncPairStart => 'Pasangkan';

  @override
  String get syncPairWaiting => 'Menunggu perangkat lain…';

  @override
  String syncPairDone(String device) {
    return 'Dipasangkan dengan $device';
  }

  @override
  String get syncPairWrongCode =>
      'Kodenya tidak cocok. Tampilkan kode baru dan coba lagi.';

  @override
  String get syncPairNoOffer =>
      'Tidak ada perangkat yang menampilkan kode ini. Mungkin sudah habis masa berlakunya.';

  @override
  String get syncPairTimedOut => 'Perangkat lain tidak menjawab tepat waktu.';

  @override
  String get syncPairNeither =>
      'Belum ada perangkat yang disiapkan dengan buku harian tersinkronisasi ini.';

  @override
  String get syncPairBoth =>
      'Kedua perangkat sudah membuka buku harian yang disinkronkan ini.';

  @override
  String syncPairFailed(String error) {
    return 'Gagal memasangkan: $error';
  }

  @override
  String get syncMediaPending =>
      'Buku harian disinkronkan · beberapa media masih ditransfer';

  @override
  String get syncWaitingForDevices =>
      'Buku harian disinkronkan · menunggu perangkat lain mentransfer media';

  @override
  String get syncCacheNotice =>
      'Media cloud bersifat sementara. Simpan yang asli di perangkat Anda; sinkronisasi bukan cadangan.';

  @override
  String get paperTitle => 'Kertas surat';

  @override
  String get paperPlain => 'Biasa';

  @override
  String get paperLined => 'Berjajar';

  @override
  String get paperGrid => 'jaringan';

  @override
  String get paperTinted => 'Berwarna';

  @override
  String get paperDecorationTitle => 'Dekorasi';

  @override
  String get paperDecorationNone => 'Tidak ada';

  @override
  String get paperDecorationBotanical => 'Daun-daun';

  @override
  String get paperDecorationStars => 'Bintang';

  @override
  String get paperDecorationWashi => 'Pita washi';

  @override
  String get themeDarkChoice => 'Penampilan gelap';

  @override
  String get themeDarkSame => 'Ikuti palet cahaya';

  @override
  String get themeDarkCustom => 'Palet terpisah';

  @override
  String get themeDarkAccent => 'Warna aksen gelap';

  @override
  String get themeColorTeal => 'teal';

  @override
  String get themeColorCyan => 'Sian';

  @override
  String get themeColorIndigo => 'nila';

  @override
  String get themeColorCoral => 'Karang';

  @override
  String get themeColorOlive => 'Zaitun';

  @override
  String get themeColorSlate => 'Batu tulis';

  @override
  String get drawingTitle => 'Menggambar';

  @override
  String get drawingPen => 'Pena';

  @override
  String get drawingEraser => 'Penghapus';

  @override
  String get drawingUndo => 'Membatalkan';

  @override
  String get drawingClear => 'Jelas';

  @override
  String get drawingWidth => 'Lebar pena';

  @override
  String get drawingStylusOnly => 'Hanya stilus';

  @override
  String get drawingDiscardTitle => 'Buang gambar?';

  @override
  String get drawingDiscardBody => 'Gambar ini belum disimpan.';

  @override
  String get drawingSaveError => 'Tidak dapat menyimpan gambar.';

  @override
  String get syncNetworkTitle => 'Diagnostik jaringan';

  @override
  String get syncNetworkRefresh => 'Segarkan';

  @override
  String get syncNetworkSelectedRoute => 'Jalur saat ini';

  @override
  String get syncNetworkAvailableRoutes => 'Jalur yang tersedia';

  @override
  String get syncNetworkSignaling => 'Koneksi direktori perangkat';

  @override
  String get syncNetworkRelayRemaining => 'Sisa tunjangan estafet';

  @override
  String get syncNetworkIcePair => 'Kandidat koneksi langsung';

  @override
  String get syncNetworkPeerTrusted => 'Perangkat yang diautentikasi';

  @override
  String get syncNetworkNoRoute => 'Menunggu koneksi';

  @override
  String get syncNetworkUnavailable => 'Diagnostik tidak tersedia';

  @override
  String get syncMediaCopiesTitle => 'Pengiriman media dan salinannya';

  @override
  String get syncMediaPendingCount => 'Menunggu untuk ditransfer';

  @override
  String get syncMediaDurableCount => 'Dikirim ke penyimpanan pribadi';

  @override
  String get syncMediaTemporaryCount =>
      'Salinan sementara atau belum dikonfirmasi';

  @override
  String get syncMediaReceiptExplanation =>
      'Jumlah ini menggambarkan pengiriman yang telah selesai, bukan audit baru atas cadangan yang masih ada.';

  @override
  String get syncMediaCacheExplanation =>
      'Media cloud sementara dapat kedaluwarsa. Simpan dokumen asli atau cadangan terpisah.';

  @override
  String get momentsTitle => 'Momen foto';

  @override
  String get momentsHint =>
      'Temukan grup menggunakan waktu foto lokal dan koordinat opsional. Foto dilampirkan hanya ketika Anda memilih kartu.';

  @override
  String get momentsScan => 'Temukan momen';

  @override
  String get momentsChooseFolder => 'Pilih folder foto';

  @override
  String get momentsLocation => 'Sertakan lokasi foto';

  @override
  String get momentsEmpty => 'Tidak ada grup foto terbaru.';

  @override
  String get momentsCreate => 'Tulis tentang foto-foto ini';

  @override
  String get momentsDismiss => 'Singkirkan';

  @override
  String get momentsError => 'Tidak dapat membaca foto lokal.';

  @override
  String get momentsCreated => 'Entri foto dibuat.';

  @override
  String get momentsPermission =>
      'Izinkan akses ke foto untuk menemukan saran lokal.';

  @override
  String get momentsScope =>
      'Hanya foto terbaru; maksimal 500 foto dan 20 foto per kartu.';

  @override
  String momentsPhotoCount(int count) {
    return 'foto $count';
  }

  @override
  String get nearbyTitle => 'Hubungkan perangkat';

  @override
  String get nearbySend => 'Otorisasi perangkat lain';

  @override
  String get nearbyReceive => 'Hubungkan ke perangkat yang ada';

  @override
  String get nearbyInstructions =>
      'Hubungkan kedua perangkat ke Wi-Fi yang sama atau ke hotspot masing-masing. Konfirmasikan otorisasi pada perangkat yang ada; kedua perangkat tetap dapat digunakan. Tidak diperlukan internet.';

  @override
  String get nearbyCompare =>
      'Bandingkan kode ini di kedua perangkat sebelum menyetujui.';

  @override
  String get nearbyConfirm => 'Kodenya cocok';

  @override
  String get nearbyScan => 'Pindai kode perangkat lain';

  @override
  String get nearbyPaste => 'Tempel undangan';

  @override
  String get nearbyWaiting => 'Menunggu persetujuan di perangkat lain';

  @override
  String get nearbyWorking =>
      'Mengotorisasi dan menyinkronkan buku harian dan lampiran Anda…';

  @override
  String get nearbyPending =>
      'Beberapa lampiran masih perlu disinkronkan. Biarkan perangkat lain tetap online dan coba lagi.';

  @override
  String get nearbyComplete =>
      'Perangkat terhubung; buku harian dan lampiran disinkronkan';

  @override
  String get nearbyFailed =>
      'Koneksi tidak selesai. Periksa koneksi lokal dan coba lagi.';

  @override
  String get nearbyEmptyRequired =>
      'Gunakan perangkat dengan buku harian kosong yang belum terhubung untuk sinkronisasi.';

  @override
  String get nearbyRetry => 'Lanjutkan sinkronisasi';

  @override
  String get nearbyWifi => 'Pengaturan Wi-Fi';

  @override
  String get nearbyHotspot => 'Pengaturan hotspot';

  @override
  String get nearbyKeepOpen =>
      'Biarkan halaman ini terbuka hingga perangkat baru selesai dibuat. Undangan berakhir setelah dua menit.';

  @override
  String get syncDevicesTitle => 'Perangkat resmi';

  @override
  String get syncDevicesDescription =>
      'Hanya perangkat yang disetujui yang dapat mengakses akun AID ini. Mencabut perangkat akan memblokir server tetapi tidak dapat menghapus kunci master atau buku harian yang sudah disalin ke dalamnya.';

  @override
  String get syncDeviceRequest =>
      'Tunjukkan QR otorisasi ini ke perangkat yang disetujui';

  @override
  String get syncDeviceAuthorize => 'Otorisasi perangkat';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Pindai atau tempel permintaan otorisasi perangkat baru.';

  @override
  String get syncDeviceRevoke => 'Cabut';

  @override
  String get syncDeviceRotate => 'Putar kunci penandatanganan perangkat ini';

  @override
  String get syncDeviceCheck => 'Periksa otorisasi';

  @override
  String get syncDeviceHardware =>
      'Kunci penandatanganan yang didukung perangkat keras';

  @override
  String get syncDeviceSoftware =>
      'Kunci penandatanganan perangkat lunak yang tidak dapat diekspor';

  @override
  String get syncDeviceUnavailable =>
      'Otorisasi perangkat tidak tersedia. Setujui perangkat ini dari perangkat resmi lainnya dan coba lagi.';

  @override
  String get syncDeviceRevoked => 'Dicabut';

  @override
  String get syncDeviceLocal => 'Perangkat ini';

  @override
  String get cloudTrafficTitle =>
      'Kuota transfer data cloud bulanan untuk file media';

  @override
  String get cloudTrafficLimit => 'Kuota transfer data bulanan';

  @override
  String get cloudTrafficUsed => 'Transfer data digunakan';

  @override
  String get cloudTrafficRemaining => 'Sisa transfer data';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'Kuota transfer data direset $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'Kuota transfer data cloud untuk file media telah habis. File media yang hilang akan disinkronkan secara otomatis ketika koneksi langsung tersedia atau kuota direset.';

  @override
  String get cloudTrafficExplanation =>
      'Caching file media dan relai langsung berbagi kuota transfer data ini. Koneksi langsung tidak mengkonsumsinya. Teks buku harian dan pesan kontrol koneksi memiliki batas harian kecil yang terpisah.';

  @override
  String get appearanceThemeSection => 'Tema aplikasi';

  @override
  String get appearancePaperSection => 'Kertas buku harian';

  @override
  String get appearanceTypographySection => 'Teks buku harian';

  @override
  String get appearancePreferencesSection => 'Preferensi umum';

  @override
  String get themeSystemAccentHint =>
      'Menggunakan palet sistem, bukan warna khusus. Matikan untuk memilih sendiri.';

  @override
  String get syncDeviceNameSaveFailed =>
      'Tidak dapat menyimpan nama perangkat. Silakan coba lagi.';

  @override
  String get nearbyConnectionHelp => 'Bantuan koneksi';

  @override
  String get syncAllSynced => 'Semuanya disinkronkan';

  @override
  String get syncDetailsTitle => 'Detail sinkronisasi';

  @override
  String get syncMore => 'Opsi lainnya';

  @override
  String get syncDeviceName => 'Nama perangkat';

  @override
  String get syncDeviceNameHint => 'Misalnya: Tablet saya';

  @override
  String get syncDeviceNameInvalid => 'Gunakan 1 hingga 32 karakter';

  @override
  String get syncDeviceKeyDetails => 'Detail keamanan';

  @override
  String get syncConnectionProblem =>
      'Tidak dapat menyinkronkan untuk saat ini. Mencoba lagi secara otomatis.';

  @override
  String get syncCopyComplete =>
      'Salinan lengkap buku harian dan file media Anda';

  @override
  String get syncCopyPartial => 'Beberapa media masih hilang';

  @override
  String get syncCopyOlder => 'Perubahan baru menunggu untuk disinkronkan';

  @override
  String get syncCopyUnavailable =>
      'Detail salinan tidak tersedia. Coba lagi nanti.';

  @override
  String get syncCopyLastKnown =>
      'Perangkat lain menunjukkan salinan terakhir yang dikonfirmasi. Perangkat offline tidak dapat diperiksa sekarang.';

  @override
  String get syncCopyTemporary =>
      'Tembolok sementara. Simpan yang asli di perangkat Anda.';

  @override
  String get syncCopyStorage =>
      'Penyimpanan sinkronisasi Anda. Unggahan media yang telah selesai tercantum dalam diagnostik.';

  @override
  String syncCopyChecked(String time) {
    return 'Terakhir dikonfirmasi $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Sisa transfer data bulan ini: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Mulai di sini';

  @override
  String get onboardConnect => 'Hubungkan ke perangkat yang ada';

  @override
  String get onboardFailed =>
      'Penyiapan tidak dapat diselesaikan. Buku harian Anda aman; silakan coba lagi.';

  @override
  String get tutorialTitle => 'Cara menggunakan buku harian';

  @override
  String get tutorialWriteTitle => 'Tulis entri buku harian pertama Anda';

  @override
  String get tutorialWriteText =>
      'Ketuk + untuk menulis entri buku harian. Tambahkan judul opsional, pilih tanggal buku harian, dan ketuk tanda centang untuk menyimpan. Anda dapat mengedit entri buku harian Anda lagi kapan saja.';

  @override
  String get tutorialMediaTitle => 'Tambahkan foto, audio, atau tulisan tangan';

  @override
  String get tutorialMediaText =>
      'Gunakan + di editor buku harian untuk melampirkan foto, video, atau rekaman suara, atau untuk membuka kanvas tulisan tangan. Lampiran ini disimpan dengan entri buku harian.';

  @override
  String get tutorialReviewTitle => 'Temukan hari lagi';

  @override
  String get tutorialReviewText =>
      'Jelajahi buku harian atau kalender Anda, cari tulisan Anda, dan atur entri dengan tag. Halaman Media dan Atlas memungkinkan Anda menemukan entri sebelumnya berdasarkan foto atau lokasi.';

  @override
  String get tutorialSyncTitle => 'Gunakan lebih dari satu perangkat';

  @override
  String get tutorialSyncText =>
      'Di Pengaturan → Data & penyimpanan → Sinkronisasi, sambungkan ke perangkat yang ada dan konfirmasikan otorisasi pada perangkat tersebut. Kedua perangkat dapat terus menggunakan buku harian tersebut. Teks buku harian disinkronkan terlebih dahulu. File media disinkronkan berikutnya ketika koneksi jaringan dan sisa kuota transfer data mengizinkannya.';

  @override
  String get tutorialPrivacyTitle => 'Jaga buku harian Anda tetap aman';

  @override
  String get tutorialPrivacyText =>
      'Entri buku harian tetap ada di perangkat ini kecuali Anda mengaktifkan sinkronisasi atau berbagi atau mengekspornya. Sinkronisasi dienkripsi ujung ke ujung. Di Pengaturan Anda juga dapat mengatur kode sandi aplikasi, membuat cadangan, dan membuka kembali tutorial ini.';

  @override
  String get editorDiaryDay => 'Hari catatan';

  @override
  String get editorDiaryDayPicker => 'Hari catatan · waktu dibuat tetap';

  @override
  String get editorDiaryDayHint =>
      'Hari yang menjadi acuan entri ini. Mengubahnya tidak mengubah waktu pembuatan entri.';

  @override
  String get hiddenDiaryTitle => 'Catatan tersembunyi';

  @override
  String get hiddenDiaryHide => 'Sembunyikan catatan';

  @override
  String get hiddenDiaryShow => 'Tampilkan catatan';

  @override
  String get hiddenDiaryEmpty => 'Tidak ada catatan tersembunyi';

  @override
  String get hiddenDiaryUnlock => 'Buka catatan tersembunyi';

  @override
  String get hiddenDiaryAuthHint =>
      'Gunakan kunci aplikasi atau kunci layar perangkat Anda.';

  @override
  String get hiddenDiaryLocalOnly =>
      'Catatan tersembunyi tetap di perangkat ini dan sinkronisasi dijeda. Gunakan cadangan terenkripsi. Salinan yang sudah ada di tempat lain tidak berubah.';

  @override
  String get moodClear => 'Hapus suasana hati';
}
