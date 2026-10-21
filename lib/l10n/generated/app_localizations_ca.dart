// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

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
  String get dailyReminderTitle => 'Registreu el vostre dia!';

  @override
  String get dailyReminderDescription => 'Feu el vostre registre diari…';

  @override
  String get actionTakePhoto => 'Fes una foto';

  @override
  String get flashbacksTitle => 'Records';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Exclou els dies dolents';

  @override
  String get flashbackGoodDay => 'Un bon dia';

  @override
  String get flashbackRandomDay => 'Un dia a l\'atzar';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fa $count setmanes',
      one: 'Fa $count setmana',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fa $count mesos',
      one: 'Fa $count mes',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fa $count anys',
      one: 'Fa $count any',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'Un dia com avui';

  @override
  String get searchLogsHint => 'Cerca registres…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count registres',
      one: '$count registre',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dies',
      one: '$count dia',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mots',
      one: '$count mot',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Sense registres…';

  @override
  String get noResults => 'Sense resultats…';

  @override
  String get sortOrderAscendingTitle => 'Ascendent';

  @override
  String get sortOrderDescendingTitle => 'Descendent';

  @override
  String get pageStatisticsTitle => 'Estadístiques';

  @override
  String get statisticsNotEnoughData => 'No hi ha prou dades…';

  @override
  String get statisticsRangeOneMonth => '1 mes';

  @override
  String get statisticsRangeSixMonths => '6 mesos';

  @override
  String get statisticsRangeOneYear => '1 any';

  @override
  String get statisticsRangeAllTime => 'Tot el temps';

  @override
  String chartSummaryTitle(Object tag) {
    return 'Resum de $tag';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag per dia';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag al llarg del temps';
  }

  @override
  String get chartGroupingLabel => 'Agrupa per';

  @override
  String get chartGroupingDay => 'Dia';

  @override
  String get chartGroupingWeek => 'Setmana';

  @override
  String get chartGroupingMonth => 'Mes';

  @override
  String get chartGroupingYear => 'Any';

  @override
  String get chartSmoothingLabel => 'Suavitzat';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ratxa actual: $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ratxa més llarga: $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dies excel·lents: $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dies des d\'un dia dolent: $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'No es pot accedir a l\'emmagatzematge extern';

  @override
  String get errorExternalStorageAccessDescription =>
      'Si utilitzeu emmagatzematge de xarxa, assegureu-vos que el servei estigui en línia i que tingueu accés a la xarxa.\n\nSi no és el cas, és possible que l\'aplicació hagi perdut els permisos de la carpeta externa. Aneu als paràmetres i torneu a seleccionar la carpeta externa per a concedir-hi accés.\n\nAdvertiment: els canvis no se sincronitzaran fins que restaureu l\'accés a la ubicació d\'emmagatzematge externa.';

  @override
  String get errorExternalStorageAccessContinue =>
      'Continua amb la base de dades local';

  @override
  String get lastModified => 'Modificat';

  @override
  String get writeSomethingHint => 'Escriviu alguna cosa…';

  @override
  String get titleHint => 'Títol…';

  @override
  String get deleteLogTitle => 'Suprimeix el registre';

  @override
  String get deleteLogDescription => 'Voleu suprimir aquest registre?';

  @override
  String get deletePhotoTitle => 'Suprimeix la foto';

  @override
  String get deletePhotoDescription => 'Voleu suprimir aquesta foto?';

  @override
  String get pageSettingsTitle => 'Paràmetres';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Clar';

  @override
  String get themeDark => 'Fosc';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Primer dia de la setmana';

  @override
  String get settingsCalendarSystem => 'Sistema de calendari';

  @override
  String get calendarSystemGregorian => 'Gregorià';

  @override
  String get calendarSystemJalali => 'Jalali';

  @override
  String get settingsUseSystemAccentColor =>
      'Usa el color d\'accent del sistema';

  @override
  String get settingsCustomAccentColor => 'Color d\'accent personalitzat';

  @override
  String get settingsShowFlashbacks => 'Mostra els records';

  @override
  String get settingsChangeMoodIcons => 'Canvia les icones de l\'estat d\'ànim';

  @override
  String get moodIconPrompt => 'Introdueix una icona';

  @override
  String get settingsHideImages => 'Amaga les imatges';

  @override
  String get pageCalendarTitle => 'Calendari';

  @override
  String get settingsNotificationsTitle => 'Notificacions';

  @override
  String get settingsDailyReminderTitle => 'Recordatori diari';

  @override
  String get settingsOnThisDayDescription => 'Revisita records del passat';

  @override
  String get settingsDailyReminderDescription => 'Un recordatori suau cada dia';

  @override
  String get settingsReminderTime => 'Hora del recordatori';

  @override
  String get settingsFixedReminderTimeTitle => 'Hora fixa del recordatori';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Trieu una hora fixa per al recordatori';

  @override
  String get settingsAlwaysSendReminderTitle => 'Envia sempre el recordatori';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Envia el recordatori encara que ja s\'hagi començat un registre';

  @override
  String get settingsCustomizeNotificationTitle =>
      'Personalitza les notificacions';

  @override
  String get settingsTemplatesTitle => 'Plantilles';

  @override
  String get manageTemplates => 'Gestiona les plantilles';

  @override
  String get noTemplateTitle => 'Cap';

  @override
  String get noTemplatesDescription => 'Encara no s\'ha creat cap plantilla…';

  @override
  String get templateDefaultTimestampTitle => 'Marca horària';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Resum del dia';

  @override
  String get templateDefaultSummaryBody => '### Resum\n- \n\n### Cita\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Reflexió';

  @override
  String get templateDefaultReflectionBody =>
      '### Què us ha agradat d\'avui?\n- \n\n### Què agraïu?\n- \n\n### Què espereu amb ganes?\n- ';

  @override
  String get settingsTagsTitle => 'Etiquetes';

  @override
  String get manageTags => 'Gestiona les etiquetes';

  @override
  String get tagTypeLabelTitle => 'Etiqueta';

  @override
  String get tagTypeTrackerTitle => 'Seguiment';

  @override
  String get nameHint => 'Nom';

  @override
  String get tagColorLabel => 'Color';

  @override
  String get iconPickerTitle => 'Trieu una icona';

  @override
  String get iconPickerIconsTab => 'Icones';

  @override
  String get iconPickerCustomTab => 'Personalitzat';

  @override
  String get iconPickerSearchHint => 'Cerca icones…';

  @override
  String get colorPickerTitle => 'Trieu un color';

  @override
  String get colorPickerPaletteTab => 'Colors';

  @override
  String get iconGroupMoodPeople => 'Estat d\'ànim i persones';

  @override
  String get iconGroupHealth => 'Salut';

  @override
  String get iconGroupWorkFinance => 'Feina i finances';

  @override
  String get iconGroupHabitsGoals => 'Hàbits i objectius';

  @override
  String get iconGroupNature => 'Natura';

  @override
  String get iconGroupFoodDrink => 'Menjar i beguda';

  @override
  String get iconGroupHome => 'Llar';

  @override
  String get iconGroupTravel => 'Viatges';

  @override
  String get iconGroupSymbols => 'Símbols';

  @override
  String get tagCategoryLabel => 'Categoria';

  @override
  String get tagLabel => 'Etiqueta';

  @override
  String get tagCategoryUncategorized => 'Sense categoria';

  @override
  String get newCategoryTitle => 'Categoria nova';

  @override
  String get shareButtonLabel => 'Comparteix';

  @override
  String get importErrorDescription => 'No s\'ha pogut importar el fitxer.';

  @override
  String get exportErrorDescription => 'No s\'ha pogut exportar el fitxer.';

  @override
  String get deleteTitle => 'Suprimeix';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' S\'utilitza en $count registres.',
      one: ' S\'utilitza en un registre.',
      zero: '',
    );
    return 'Voleu suprimir «$name»?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' També se suprimiran les seves $count etiquetes.',
      one: ' També se suprimirà la seva etiqueta.',
      zero: '',
    );
    return 'Voleu suprimir «$name»?$_temp0';
  }

  @override
  String deleteTemplateMessage(Object name) {
    return 'Voleu suprimir «$name»?';
  }

  @override
  String get addTagsTitle => 'Afegeix etiquetes';

  @override
  String get addTagsSearchHint => 'Cerca etiquetes…';

  @override
  String get tagPickerSortManualLabel => 'Ordre manual';

  @override
  String get tagPickerSortUsageLabel => 'Ordena per ús';

  @override
  String get tagFavoriteName => 'Preferit';

  @override
  String get tagEnergyName => 'Energia';

  @override
  String get tagCategoryActivitiesName => 'Activitats';

  @override
  String get tagExerciseName => 'Exercici';

  @override
  String get tagSocializingName => 'Vida social';

  @override
  String get tagHobbyName => 'Afició';

  @override
  String get tagEntertainmentName => 'Entreteniment';

  @override
  String get tagDiningName => 'Menjar fora';

  @override
  String get tagChoresName => 'Feines de casa';

  @override
  String get tagCategoryEmotionsName => 'Emocions';

  @override
  String get tagExcitedName => 'Entusiasme';

  @override
  String get tagGratefulName => 'Gratitud';

  @override
  String get tagCalmName => 'Calma';

  @override
  String get tagTiredName => 'Cansament';

  @override
  String get tagAnxiousName => 'Ansietat';

  @override
  String get tagAnnoyedName => 'Enuig';

  @override
  String get welcomeLogBodyText =>
      '## Welcome to AID Diary\n\n> A quiet place for your days.\n\nWrite what happened, how you felt, and where you were. Your entries stay on this device.\n\n- **Journal** lists every entry by day\n- **Calendar**, **Media** and **Atlas** look back by date, photo and place\n- **Coach** offers prompts and templates when you don\'t know what to write';

  @override
  String get settingsStorageTitle => 'Emmagatzematge';

  @override
  String get settingsImageQuality => 'Qualitat de la imatge';

  @override
  String get imageQualityHigh => 'Alta';

  @override
  String get imageQualityMedium => 'Mitjana';

  @override
  String get imageQualityLow => 'Baixa';

  @override
  String get imageQualityNoCompression => 'Sense compressió';

  @override
  String get settingsLogFolder => 'Carpeta de registres';

  @override
  String get settingsImageFolder => 'Carpeta d\'imatges';

  @override
  String get warningTitle => 'Advertiment';

  @override
  String get logFolderWarningDescription =>
      'Si la carpeta seleccionada ja conté un fitxer «aid_diary.db», s\'utilitzarà per a sobreescriure els vostres registres existents!';

  @override
  String get errorTitle => 'Error';

  @override
  String get logFolderErrorDescription =>
      'No s\'ha pogut canviar la carpeta de registres.';

  @override
  String get imageFolderErrorDescription =>
      'No s\'ha pogut canviar la carpeta d\'imatges.';

  @override
  String get backupErrorDescription =>
      'No s\'ha pogut crear la còpia de seguretat.';

  @override
  String get restoreErrorDescription =>
      'No s\'ha pogut restaurar la còpia de seguretat.';

  @override
  String get settingsBackupRestoreTitle => 'Còpia de seguretat i restauració';

  @override
  String get settingsBackup => 'Còpia de seguretat';

  @override
  String get settingsRestore => 'Restaura';

  @override
  String get settingsRestorePromptDescription =>
      'Si restaureu una còpia de seguretat, se sobreescriuran les dades existents.';

  @override
  String get settingsBackupPasswordProtect =>
      'Protegeix les còpies de seguretat amb contrasenya';

  @override
  String get backupEncryptedTitle => 'Còpia de seguretat xifrada';

  @override
  String get backupEncryptedContent =>
      'Aquesta còpia de seguretat està protegida amb contrasenya.';

  @override
  String get settingsAutoBackup => 'Còpies de seguretat automàtiques';

  @override
  String get settingsAutoBackupLocation => 'Ubicació de la còpia de seguretat';

  @override
  String get settingsAutoBackupInterval => 'Interval de còpia de seguretat';

  @override
  String get settingsAutoBackupIntervalDaily => 'Diari';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Setmanal';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Mensual';

  @override
  String get settingsAutoBackupMaxCount => 'Còpies de seguretat a conservar';

  @override
  String get settingsAutoBackupRequireCharging => 'Només durant la càrrega';

  @override
  String settingsBackupLast(Object time) {
    return 'Última còpia de seguretat: $time';
  }

  @override
  String get settingsBackupNever => 'Mai no s\'ha fet cap còpia de seguretat';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Pròxima còpia de seguretat: $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'Totes';

  @override
  String get autoBackupFailedTitle => 'Ha fallat la còpia de seguretat';

  @override
  String tranferStatus(Object percent) {
    return 'S\'està transferint… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'S\'està creant la còpia de seguretat… $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'S\'està restaurant la còpia de seguretat… $percent%';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return 'S\'està xifrant la còpia de seguretat… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'S\'està desxifrant la còpia de seguretat… $percent%';
  }

  @override
  String get cleanUpStatus => 'S\'està netejant…';

  @override
  String get settingsExportToAnotherFormat => 'Exporta a un altre format';

  @override
  String get settingsExportFormatDescription =>
      'No s\'ha d\'utilitzar com a còpia de seguretat!';

  @override
  String get settingsImportFromAnotherApp =>
      'Importa des d\'una altra aplicació';

  @override
  String get logFormatTitle => 'Trieu un format';

  @override
  String get logFormatDescription =>
      'És possible que el format d\'una altra aplicació no admeti totes les funcions. Informeu de qualsevol problema, ja que els formats de tercers poden canviar en qualsevol moment. Això no afectarà els registres existents.';

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
  String get formatOneShot => 'OneShot';

  @override
  String get formatPixels => 'Pixels';

  @override
  String get formatMarkdown => 'Markdown';

  @override
  String get settingsDeleteAllLogsTitle => 'Suprimeix tots els registres';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Voleu suprimir tots els vostres registres?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Introduïu «$prompt» per a confirmar-ho. Aquesta acció no es pot desfer.';
  }

  @override
  String get settingsLanguageTitle => 'Llengua';

  @override
  String get settingsAppLanguageTitle => 'Llengua de l\'aplicació';

  @override
  String get settingsOverrideAppLanguageTitle =>
      'Substitueix la lengua de l\'aplicació';

  @override
  String get settingsSecurityTitle => 'Seguretat';

  @override
  String get settingsSecurityRequirePassword => 'Requereix contrasenya';

  @override
  String get settingsSecurityEnterPassword => 'Introduïu la contrasenya';

  @override
  String get settingsSecuritySetPassword => 'Estableix una contrasenya';

  @override
  String get settingsSecurityChangePassword => 'Canvia la contrasenya';

  @override
  String get settingsSecurityPassword => 'Contrasenya';

  @override
  String get settingsSecurityConfirmPassword => 'Confirmeu la contrasenya';

  @override
  String get settingsSecurityOldPassword => 'Contrasenya antiga';

  @override
  String get settingsSecurityIncorrectPassword => 'Contrasenya incorrecta';

  @override
  String get settingsSecurityPasswordsDoNotMatch =>
      'Les contrasenyes no coincideixen';

  @override
  String get requiredPrompt => 'Obligatori';

  @override
  String get settingsSecurityBiometricUnlock => 'Desblocatge biomètric';

  @override
  String get unlockAppPrompt => 'Desbloca l\'aplicació';

  @override
  String get settingsAboutTitle => 'Quant a';

  @override
  String get settingsVersion => 'Versió';

  @override
  String get settingsLicense => 'Llicència';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsOpenSourceLicenses => 'Llicències de codi obert';

  @override
  String get tagMoodTitle => 'Estat d\'ànim';

  @override
  String get selectTagTitle => 'Selecciona una etiqueta';

  @override
  String get labelPresentLabel => 'Present';

  @override
  String get labelAbsentLabel => 'Absent';

  @override
  String get labelCoverageLabel => 'Cobertura';

  @override
  String chartDistributionTitle(Object tag) {
    return 'Distribució de $tag';
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
  String get toolbarMedia => 'Photos and videos';

  @override
  String get mediaFromGallery => 'Choose from gallery';

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
}
