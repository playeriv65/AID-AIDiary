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
  String get actionToday => 'Avui';

  @override
  String get actionOtherDay => 'Un altre dia';

  @override
  String get pageHomeTitle => 'Inici';

  @override
  String get jumpToMonthTitle => 'Salta al mes';

  @override
  String get jumpToLogTitle => 'Salta al registre';

  @override
  String get flashbacksTitle => 'Records';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Exclou els dies dolents';

  @override
  String get flaskbacksEmpty => 'Encara no hi ha records…';

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
  String get pageGalleryTitle => 'Galeria';

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
  String get sortDateTitle => 'Data';

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
  String get databaseMigrationErrorTitle =>
      'No s\'han pogut moure les vostres dades';

  @override
  String get databaseMigrationErrorDescription =>
      'Les vostres entrades estan segures, però no s\'han pogut moure a l\'emmagatzematge de l\'aplicació.\n\nTorneu-ho a provar i informeu del problema si continua passant.';

  @override
  String get databaseMigrationErrorRetry => 'Torna-ho a provar';

  @override
  String get errorReport => 'Informa d\'un problema';

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
  String get settingsAppearanceTitle => 'Aparença';

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
  String get settingsShowMarkdownToolbar => 'Show Markdown Toolbar';

  @override
  String get settingsShowFlashbacks => 'Mostra els records';

  @override
  String get settingsChangeMoodIcons => 'Canvia les icones de l\'estat d\'ànim';

  @override
  String get moodIconPrompt => 'Introdueix una icona';

  @override
  String get settingsFlashbacksViewLayout => 'Flashbacks View Layout';

  @override
  String get settingsHideImagesInGallery => 'Amaga les imatges a la galeria';

  @override
  String get settingsHideImages => 'Amaga les imatges';

  @override
  String get pageCalendarTitle => 'Calendari';

  @override
  String get settingsNotificationsTitle => 'Notificacions';

  @override
  String get settingsDailyReminderOnboarding =>
      'Activeu els recordatoris diaris per a mantenir la constància.';

  @override
  String get settingsNotificationsPermissionsPrompt =>
      'Se sol·licitarà el permís «programa alarmes» per a enviar el recordatori en un moment aleatori o a l\'hora que preferiu.';

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
  String get settingsDefaultTemplate => 'Plantilla predeterminada';

  @override
  String get manageTemplates => 'Gestiona les plantilles';

  @override
  String get addTemplate => 'Afegeix una plantilla';

  @override
  String get newTemplate => 'New Template';

  @override
  String get noTemplateTitle => 'Cap';

  @override
  String get noTemplatesDescription => 'Encara no s\'ha creat cap plantilla…';

  @override
  String get templateVariableTime => 'Hora';

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
      '## Welcome to AID Diary\n\n> Every day is worth remembering.\n\nWrite what happened, how you felt, and where you were. Your entries stay on this device.\n\n- **Journal** lists every entry by day\n- **Calendar**, **Media** and **Atlas** look back by date, photo and place\n- **Coach** offers prompts and templates when you don\'t know what to write\n\nAID Diary is a modified version of [Daily You](https://github.com/Demizo/Daily_You) by Demizo and contributors, and not the official Daily You app.';

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
      'Si la carpeta seleccionada ja conté un fitxer «daily_you.db», s\'utilitzarà per a sobreescriure els vostres registres existents!';

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
  String migratingImagesStatus(Object current, Object total) {
    return 'S\'estan migrant les fotos… $current/$total';
  }

  @override
  String get settingsExport => 'Export';

  @override
  String get settingsExportToAnotherFormat => 'Exporta a un altre format';

  @override
  String get settingsExportFormatDescription =>
      'No s\'ha d\'utilitzar com a còpia de seguretat!';

  @override
  String get exportLogs => 'Export Logs';

  @override
  String get exportImages => 'Export Images';

  @override
  String get settingsImport => 'Import';

  @override
  String get settingsImportFromAnotherApp =>
      'Importa des d\'una altra aplicació';

  @override
  String get settingsTranslateCallToAction =>
      'Tothom hauria de tenir accés a un diari!';

  @override
  String get settingsHelpTranslate => 'Ajudeu a traduir';

  @override
  String get importLogs => 'Import Logs';

  @override
  String get importImages => 'Import Images';

  @override
  String get logFormatTitle => 'Trieu un format';

  @override
  String get logFormatDescription =>
      'És possible que el format d\'una altra aplicació no admeti totes les funcions. Informeu de qualsevol problema, ja que els formats de tercers poden canviar en qualsevol moment. Això no afectarà els registres existents.';

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
  String get settingsSourceCode => 'Codi font';

  @override
  String get settingsOpenSourceLicenses => 'Llicències de codi obert';

  @override
  String get settingsMadeWithLove => 'Fet amb ❤️';

  @override
  String get settingsConsiderSupporting => 'considereu donar-hi suport';

  @override
  String get imagesTitle => 'Imatges';

  @override
  String get tagMoodTitle => 'Estat d\'ànim';

  @override
  String get calendarTagDisplayLabel => 'Etiqueta';

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
}
