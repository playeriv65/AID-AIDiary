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
  String get themeColorTitle => 'Color del tema';

  @override
  String get themeColorHint => 'Trieu un color per a aquesta paleta.';

  @override
  String get themeColorBlue => 'Blau cel';

  @override
  String get themeColorGreen => 'Verd bosc';

  @override
  String get themeColorBrown => 'Cafè calent';

  @override
  String get themeColorPurple => 'Lavanda';

  @override
  String get themeColorRose => 'Rosa pols';

  @override
  String get themeColorAmber => 'Ambre';

  @override
  String get themeColorPreview => 'Cada dia una mica';

  @override
  String get themeTintBackgroundTitle =>
      'Tinteu els fons amb el color del tema';

  @override
  String get themeTintBackgroundHint =>
      'Apagueu per a fons gris neutre; els botons mantenen el color escollit.';

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
  String get tagNameExists => 'Ja hi ha una etiqueta amb aquest nom';

  @override
  String get categoryNameExists => 'Ja hi ha una categoria amb aquest nom';

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
  String get formatOneDiary => 'One Diary';

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
  String get shareAddToLogPickerTitle => 'Trieu una entrada al diari';

  @override
  String get adaptiveEmptyDay => 'Encara no hi ha entrades per a aquest dia';

  @override
  String get adaptiveNewEntry => 'Escriu una entrada';

  @override
  String get pageJournalTitle => 'Diari';

  @override
  String get coachPrompt1 => 'Què t\'ha fet somriure avui?';

  @override
  String get coachPrompt2 => 'Quina és una cosa que has après avui?';

  @override
  String get coachPrompt3 => 'Amb qui has parlat avui i com t\'has sentit?';

  @override
  String get coachPrompt4 => 'Què estàs agraït ara mateix?';

  @override
  String get coachPrompt5 =>
      'Què ha portat la major part de la teva energia avui?';

  @override
  String get coachPrompt6 => 'Descriu un petit moment que vulguis recordar.';

  @override
  String get coachPrompt7 => 'Què faria demà un bon dia?';

  @override
  String get coachPrompt8 => 'Què t\'ha passat pel cap darrerament?';

  @override
  String get coachPrompt9 => 'Què has fet avui només per tu?';

  @override
  String get coachPrompt10 => 'Si avui tingués un títol, quin seria?';

  @override
  String get pageMediaTitle => 'Mitjans de comunicació';

  @override
  String get pageAtlasTitle => 'Atles';

  @override
  String get pageCoachTitle => 'Entrenador';

  @override
  String get noEntrySelected => 'No s\'ha seleccionat cap entrada.';

  @override
  String get entryShare => 'Comparteix';

  @override
  String get entryFavorite => 'Estrella';

  @override
  String get entryEdit => 'Edita';

  @override
  String get entryPrevious => 'Entrada anterior';

  @override
  String get entryNext => 'Següent entrada';

  @override
  String get journalStories => 'Històries';

  @override
  String get journalEntries => 'Entrades';

  @override
  String get journalEmptyHint =>
      'Comenceu el vostre diari afegint una nova entrada.';

  @override
  String get storyToday => 'Avui';

  @override
  String get storyThrowback => 'Retrocés';

  @override
  String get storyNoThrowback => 'Avui no hi ha cap retrocés';

  @override
  String get mediaFiles => 'Fitxers multimèdia';

  @override
  String get mediaEmpty => 'Encara no hi ha cap foto.';

  @override
  String get mediaEmptyHint =>
      'Les fotos adjuntes a les entrades es mostraran aquí.';

  @override
  String get atlasEmpty => 'No hi ha entrades amb una ubicació.';

  @override
  String get atlasEmptyHint =>
      'Les entrades amb una ubicació es mostraran aquí.';

  @override
  String get atlasShowAll => 'Mostra totes les entrades';

  @override
  String get atlasMyLocation => 'La meva ubicació';

  @override
  String get coachAll => 'Tots';

  @override
  String get coachPrograms => 'Programes';

  @override
  String get coachTemplates => 'Plantilles';

  @override
  String get coachKindProgram => 'Programa';

  @override
  String get coachKindTemplate => 'Plantilla';

  @override
  String get coachNoTemplates => 'Sense programes ni plantilles.';

  @override
  String get coachUseTemplate => 'Escriu amb aquesta plantilla';

  @override
  String get coachProgramEverydayTitle => 'Moments quotidians';

  @override
  String get coachProgramEverydayDescription =>
      'Cinc preguntes breus, una al dia. Cadascun triga un minut o dos i t\'ajuda a veure què ha fet teu el dia. Una manera suau de construir l\'hàbit d\'escriure una mica cada dia.';

  @override
  String get coachProgramReflectTitle => 'Mirant cap a dins';

  @override
  String get coachProgramReflectDescription =>
      'Una pregunta més profunda a la setmana, durant cinc setmanes. Preneu-vos el vostre temps amb cadascun: com us heu sentit, què us desgasta, què agraïu.';

  @override
  String get searchFilters => 'Filtres';

  @override
  String get searchFilterTags => 'Etiquetes';

  @override
  String get searchFilterStarred => 'Destacat';

  @override
  String get searchHint => 'Escriviu per cercar o trieu un filtre.';

  @override
  String get locationTitle => 'Ubicació';

  @override
  String get locationName => 'Nom del lloc';

  @override
  String get locationRemove => 'Eliminar';

  @override
  String get locationServiceDisabled =>
      'Els serveis d\'ubicació estan desactivats.';

  @override
  String get locationPermissionDenied => 'S\'ha denegat el permís d\'ubicació.';

  @override
  String get locationUnavailable =>
      'No s\'ha pogut obtenir la ubicació actual.';

  @override
  String get calendarJumpToToday => 'Salta a avui';

  @override
  String get editorStartWriting => 'Comença a escriure o tria a ';

  @override
  String get editorTemplateLink => 'Plantilla';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Trieu una plantilla';

  @override
  String get templateFeatured => 'Plantilles destacades';

  @override
  String get templateMine => 'Les meves plantilles';

  @override
  String get templateDailyName => 'Revisió diària';

  @override
  String get templateDailyDescription =>
      'Què va passar, com es va sentir i què ve després.';

  @override
  String get templateDailyText =>
      '## Què ha passat avui\n\n\n## Com em vaig sentir\n\n\n## Tres coses per les quals estic agraït\n1. \n2. \n3. \n\n## Demà\n';

  @override
  String get templateTravelName => 'Entrada al diari de viatge';

  @override
  String get templateTravelDescription =>
      'Llocs, moments i menjar de la carretera.';

  @override
  String get templateTravelText =>
      '## On vaig anar\n\n\n## El moment que més recordo\n\n\n## El que vaig menjar\n\n\n## Plans per demà\n';

  @override
  String get templateReadingName => 'Notes de lectura';

  @override
  String get templateReadingDescription => 'Cites i pensaments del que llegiu.';

  @override
  String get templateReadingText =>
      '## Llibre\n\n\n## On sóc\n\n\n## Cites\n> \n\n## Els meus pensaments\n';

  @override
  String get templateWeeklyName => 'Revisió setmanal';

  @override
  String get templateWeeklyDescription =>
      'Punts destacats, lluites i focus de la setmana vinent.';

  @override
  String get templateWeeklyText =>
      '## Destacats\n\n\n## Què va ser difícil\n\n\n## El que vaig aprendre\n\n\n## Focus per a la setmana vinent\n';

  @override
  String get entryDuplicate => 'Duplicat';

  @override
  String get entryDuplicated => 'Entrada duplicada';

  @override
  String get entrySaveAsTemplate => 'Desa com a plantilla';

  @override
  String get entrySavedAsTemplate => 'Desat com a plantilla';

  @override
  String get storyStatistics => 'Estadístiques';

  @override
  String get storyMoodChart => 'Gràfic d\'estat d\'ànim';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return '$entries entrades · $days dies';
  }

  @override
  String get storyThisYear => 'Aquest any';

  @override
  String get storyLastYear => 'L\'any passat';

  @override
  String get storyTapToOpen => 'Toca un dia per obrir-lo';

  @override
  String get settingsGeneralTitle => 'General';

  @override
  String get settingsDataTitle => 'Dades i emmagatzematge';

  @override
  String get settingsStoriesTitle => 'Històries';

  @override
  String get settingsHelpTitle => 'Ajuda i sobre';

  @override
  String get weatherTitle => 'El temps';

  @override
  String get weatherClear => 'Clar';

  @override
  String get weatherPartlyCloudy => 'Parcialment ennuvolat';

  @override
  String get weatherCloudy => 'Ennuvolat';

  @override
  String get weatherFog => 'Boira';

  @override
  String get weatherDrizzle => 'Ruixer';

  @override
  String get weatherRain => 'Pluja';

  @override
  String get weatherSnow => 'Neu';

  @override
  String get weatherStorm => 'Tempesta';

  @override
  String get weatherFetch => 'Obteniu el temps per a aquesta entrada';

  @override
  String get weatherNeedsLocation =>
      'Afegiu primer una ubicació amb coordenades.';

  @override
  String get weatherUnavailable =>
      'El temps no està disponible per a aquest lloc i hora.';

  @override
  String get weatherRemove => 'Elimina el temps';

  @override
  String get activityTitle => 'Activitat';

  @override
  String get activityStill => 'Encara';

  @override
  String get activityWalking => 'Caminant';

  @override
  String get activityRunning => 'Córrer';

  @override
  String get activityCycling => 'Ciclisme';

  @override
  String get activityVehicle => 'En un vehicle';

  @override
  String get activityFlying => 'Volant';

  @override
  String get activityExercise => 'Exercici';

  @override
  String get activityDetect => 'Detectar l\'activitat actual';

  @override
  String get activityDetectFailed => 'No s\'ha pogut detectar cap activitat.';

  @override
  String get activityRemove => 'Elimina l\'activitat';

  @override
  String get settingsAutoAddTitle => 'Afegeix automàticament';

  @override
  String get settingsAutoAddLocation => 'Ubicació';

  @override
  String get settingsAutoAddWeather => 'El temps';

  @override
  String get settingsAutoAddHint =>
      'Les entrades noves s\'omplen quan es creen.';

  @override
  String get settingsTemperatureUnit => 'Unitat de temperatura';

  @override
  String get settingsCelsius => 'Celsius (°C)';

  @override
  String get settingsFahrenheit => 'Fahrenheit (°F)';

  @override
  String get moodGreat => 'Genial';

  @override
  String get moodGood => 'Bé';

  @override
  String get moodOkay => 'D\'acord';

  @override
  String get moodBad => 'Dolent';

  @override
  String get moodAwful => 'Horrible';

  @override
  String get locationSearchHint => 'Busca un lloc';

  @override
  String get locationSearchEmpty => 'No s\'han trobat llocs';

  @override
  String get settingsWallpaper => 'Fons de pantalla';

  @override
  String get wallpaperNone => 'Cap';

  @override
  String get wallpaperDots => 'Punts';

  @override
  String get wallpaperGrid => 'Quadrícula';

  @override
  String get wallpaperLines => 'Línies';

  @override
  String get wallpaperPhoto => 'Foto…';

  @override
  String get settingsFontFamily => 'Font';

  @override
  String get fontSystem => 'Sistema';

  @override
  String get fontSerif => 'Serif';

  @override
  String get fontMono => 'Monoespai';

  @override
  String get settingsFontSize => 'Mida de la lletra';

  @override
  String get fontSizeSmall => 'Petit';

  @override
  String get fontSizeMedium => 'Mitjana';

  @override
  String get fontSizeLarge => 'Gran';

  @override
  String get fontSizeExtraLarge => 'Extra gran';

  @override
  String get settingsLineSpacing => 'Interlineat';

  @override
  String get lineSpacingCompact => 'Compacte';

  @override
  String get lineSpacingNormal => 'Normal';

  @override
  String get lineSpacingRelaxed => 'Relaxat';

  @override
  String get moodAssociationsTitle => 'Què em fa sentir...';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching de les entrades $total';
  }

  @override
  String get videoRecord => 'Grava un vídeo';

  @override
  String get videoChoose => 'Tria un vídeo';

  @override
  String get audioRecordTitle => 'Grava una nota de veu';

  @override
  String get audioChoose => 'Trieu un fitxer d\'àudio';

  @override
  String get audioStart => 'Registre';

  @override
  String get audioStop => 'Atureu-vos i estalvieu';

  @override
  String get audioPermissionDenied =>
      'L\'accés al micròfon està desactivat. Permeteu-ho a la configuració del sistema.';

  @override
  String get mediaTooLarge => 'Aquest vídeo és massa gran per adjuntar-lo.';

  @override
  String get mediaUnavailable =>
      'Aquest fitxer adjunt no està disponible en aquest dispositiu.';

  @override
  String get widgetDone => 'L\'entrada d\'avui està escrita';

  @override
  String get widgetPending => 'Com va ser el teu dia?';

  @override
  String get widgetWrite => 'Escriu';

  @override
  String get insertChecklist => 'Llista de verificació';

  @override
  String get insertNumberedList => 'Llista numerada';

  @override
  String get insertTable => 'Taula';

  @override
  String get insertDivider => 'Divisor';

  @override
  String get insertCodeBlock => 'Bloc de codi';

  @override
  String get journalSortTitle => 'Ordena les entrades';

  @override
  String get journalSortUpdated => 'Última actualització';

  @override
  String get settingsTimeFormat => 'Format horari';

  @override
  String get settingsDayStart =>
      'Les noves entrades compten per al dia abans fins';

  @override
  String get settingsDayAskUntil => 'Llavors pregunteu fins a quin dia';

  @override
  String get settingsDayStartMidnight => 'Apagat';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Cada entrada manté el dia al qual pertany al costat de l\'hora en què es va escriure, i podeu canviar aquest dia a l\'editor en qualsevol moment. Aquests horaris només trien el dia per a les noves entrades, de manera que canviar-les no mou cap entrada existent.';

  @override
  String get lateNightBadge => 'Escrit a la nit, comptat per al dia anterior';

  @override
  String editorDayAsk(String time) {
    return 'Escrit a $time. Per a quin dia és?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (ahir)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (avui)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'Escrit $when';
  }

  @override
  String get timeFormat12 => '12 hores';

  @override
  String get timeFormat24 => '24 hores';

  @override
  String get settingsReminderDays => 'Recorda\'m';

  @override
  String get locationRecent => 'Llocs recents';

  @override
  String get shareImage => 'Comparteix la imatge';

  @override
  String get shareSaveImage => 'Guarda la imatge';

  @override
  String get shareSaved => 'S\'ha desat la imatge';

  @override
  String get deletedTitle => 'S\'ha suprimit recentment';

  @override
  String get deletedNone => 'No s\'ha suprimit res recentment';

  @override
  String deletedHint(int days) {
    return 'Les entrades suprimides romanen aquí durant $days dies i després s\'esborren.';
  }

  @override
  String deletedDaysLeft(int days) {
    return 'Queden $days dies';
  }

  @override
  String get deletedRestore => 'Restaurar';

  @override
  String get deletedDeleteForever => 'Suprimeix per sempre';

  @override
  String get deletedDeleteForeverDescription =>
      'L\'entrada i els seus fitxers adjunts s\'esborren. Això no es pot desfer.';

  @override
  String get deletedEmpty => 'Buit';

  @override
  String get deletedEmptyDescription =>
      'Vols esborrar totes les entrades de S\'han suprimit recentment? Això no es pot desfer.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Caminada aleatòria';

  @override
  String get randomSubtitle => 'Obre una entrada passada';

  @override
  String get randomNext => 'Un altre';

  @override
  String get randomAll => 'Tots';

  @override
  String get randomWithPhotos => 'Amb fotos';

  @override
  String get randomGoodDays => 'Bons dies';

  @override
  String get randomEmpty => 'No hi ha entrades per triar';

  @override
  String get reviewWeekTitle => 'Aquesta setmana';

  @override
  String get reviewWeekSubtitle => 'La teva setmana fins ara';

  @override
  String get reviewYearTitle => 'Aquest any';

  @override
  String get reviewEmpty => 'Encara no hi ha res escrit';

  @override
  String get reviewEntries => 'Entrades';

  @override
  String get reviewDaysWritten => 'Dies escrits';

  @override
  String get reviewWords => 'Paraules';

  @override
  String get reviewPhotos => 'Fotos';

  @override
  String get reviewLongestRun => 'El curs més llarg dels dies';

  @override
  String get reviewAverageMood => 'Estat d\'ànim mitjà';

  @override
  String get reviewFavorites => 'Molt sovint';

  @override
  String get reviewByMonth => 'Per mes';

  @override
  String get reviewHighlight => 'Ressaltar';

  @override
  String get yearInPixels => 'Any en píxels';

  @override
  String get capsuleSeal => 'Segell com a càpsula del temps';

  @override
  String get capsuleTitle => 'Càpsula del temps';

  @override
  String capsuleOpensOn(Object date) {
    return 'Obre el $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Escrit a $date';
  }

  @override
  String get capsuleOpenEarly => 'Obrir d\'hora';

  @override
  String get capsuleOpenEarlyDescription =>
      'La càpsula s\'obre ara i es manté oberta.';

  @override
  String get capsuleOpened => 'Càpsula del temps oberta';

  @override
  String get templateMorningName => 'Pàgines matinals';

  @override
  String get templateMorningDescription => 'Configura el dia en tres minuts';

  @override
  String get templateMorningText =>
      '## Tres coses que vull fer bé avui\n1. \n2. \n3. \n\n## Una cosa que espero\n\n## Una nota per a mi mateix\n';

  @override
  String get templateEveningName => 'Revisió de la tarda';

  @override
  String get templateEveningDescription => 'Tanca el dia amb el que ha anat bé';

  @override
  String get templateEveningText =>
      '## Avui tres coses bones\n1. \n2. \n3. \n\n## El que vaig aprendre\n\n## Què podria anar millor demà\n';

  @override
  String get routineMorning => 'Bon dia';

  @override
  String get routineEvening => 'Revisió de la tarda';

  @override
  String get settingsRoutinePrompts => 'Indicacions del matí i de la tarda';

  @override
  String get settingsRoutinePromptsHint =>
      'Suggereix la plantilla del matí o del vespre a Històries';

  @override
  String get checkInTitle => 'Facturació ràpida';

  @override
  String get checkInSubtitle => 'Estat d\'ànim en dos tocs';

  @override
  String get checkInMood => 'Com et sents?';

  @override
  String get checkInActivity => 'Què estàs fent?';

  @override
  String get checkInNote => 'Una línia sobre això (opcional)';

  @override
  String get checkInSave => 'Desa';

  @override
  String editorWordCount(int words, int characters) {
    return '$words paraules · $characters caràcters';
  }

  @override
  String get coachProgramEverydayTagline =>
      'Observeu les petites coses en un dia.';

  @override
  String get coachProgramReflectTagline =>
      'Redueix la velocitat i escolta\'t a tu mateix.';

  @override
  String get coachDuration => 'Durada';

  @override
  String get coachInterval => 'Interval';

  @override
  String get coachDifficulty => 'Dificultat';

  @override
  String get coachIntervalDaily => 'Diàriament';

  @override
  String get coachIntervalWeekly => 'Setmanalment';

  @override
  String get coachDifficultyBeginner => 'Principiant';

  @override
  String get coachDifficultyIntermediate => 'Intermedi';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dies',
      one: '$count dia',
      many: '$count dies',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count setmanes',
      one: '$count setmana',
      many: '$count setmanes',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'Dia $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Setmana $n';
  }

  @override
  String get coachEnroll => 'Inscriu-te';

  @override
  String get coachEndProgram => 'Finalitzar el programa';

  @override
  String get coachAuthor => 'Autor';

  @override
  String get coachAuthorBio => 'Sol·licituds escrites per a aquesta aplicació.';

  @override
  String get coachEnrolledTip =>
      'Tot a punt! Les teves preguntes apareixeran a Stories.';

  @override
  String get coachGoToStories => 'Vés a Històries';

  @override
  String get coachAnswerHint => 'Escriu la teva resposta...';

  @override
  String get storyWrapUp => 'Això és tot per avui.';

  @override
  String get storyTapToClose => 'Toca per tancar';

  @override
  String get coachAnswerDone => 'Fet';

  @override
  String get coachAnswered => 'Resposta, toca per obrir';

  @override
  String get coachAnsweredEarlier => 'Respon';

  @override
  String get locationLocating => 'Localitzant…';

  @override
  String get locationPickPlace => 'Tria un lloc';

  @override
  String get locationPlacesHint => 'Adreça o nom del lloc';

  @override
  String get locationCustom => 'Lloc personalitzat';

  @override
  String get locationCurrent => 'Ubicació actual';

  @override
  String get locationSaved => 'Llocs guardats';

  @override
  String get locationSearchResults => 'Resultats de la cerca';

  @override
  String get locationNearby => 'Llocs propers';

  @override
  String get locationRename => 'Canvia el nom';

  @override
  String get locationSavePlace => 'Guardar lloc';

  @override
  String get locationUnsavePlace => 'Elimina dels llocs desats';

  @override
  String get shareAs => 'Comparteix com...';

  @override
  String get shareAsImage => 'Imatge';

  @override
  String get shareAsZip => 'ZIP amb el suport original';

  @override
  String get shareAsPlainText => 'Text pla';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Benvingut a AID Diary';

  @override
  String get onboardWelcomeText =>
      'Comenceu aquí o connecteu aquest dispositiu a un que ja feu servir.';

  @override
  String get onboardStart => 'Comença a escriure';

  @override
  String get helpFaq => 'Preguntes freqüents';

  @override
  String get helpFaq1Q => 'On està guardat el meu diari?';

  @override
  String get helpFaq1A =>
      'El vostre diari s\'emmagatzema en aquest dispositiu. Només arriba a altres dispositius o emmagatzematge quan activeu la sincronització, la compartició o l\'exportació. La sincronització està xifrada d\'extrem a extrem.';

  @override
  String get helpFaq2Q =>
      'Com puc guardar una còpia o passar a un dispositiu nou?';

  @override
  String get helpFaq2A =>
      'Connecteu-vos a un dispositiu existent a Configuració → Dades i emmagatzematge → Sincronitza i confirmeu l\'autorització al dispositiu que té el vostre diari. Tots dos dispositius continuen utilitzables. També podeu crear una còpia de seguretat i restaurar-la en un altre dispositiu.';

  @override
  String get helpFaq3Q =>
      'Puc introduir entrades d\'altres aplicacions de diari?';

  @override
  String get helpFaq3A =>
      'Sí: a Configuració → Dades i emmagatzematge, importeu exportacions de Daylio, Diarium, Diaro, DayBook, My Brain, OneShot i Pixels, o una exportació JSON.';

  @override
  String get helpFaq4Q => 'Com funcionen els programes de coaching?';

  @override
  String get helpFaq4A =>
      'Inscriu-te en un programa a la pàgina Coach. Cada dia o setmana una nova pregunta espera a les històries; la teva resposta es desa com a entrada.';

  @override
  String get helpFaq5Q => 'Què passa si oblido la meva contrasenya?';

  @override
  String get helpFaq5A =>
      'La contrasenya no es pot recuperar, així que mantingueu una còpia de seguretat del vostre diari.';

  @override
  String get helpPrivacy => 'Privadesa';

  @override
  String get helpPrivacyText =>
      'El contingut del diari i els mitjans es mantenen en aquest dispositiu tret que activeu la sincronització xifrada o els compartiu/exporteu. Els mapes, la cerca de llocs i el temps utilitzen els serveis configurats i envien la ubicació o la consulta de cerca necessària per a aquesta sol·licitud, no el text del diari.';

  @override
  String get photoMetaTitle => 'Utilitzeu els detalls de la foto?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Comptar aquesta entrada per a $date i establir-ne el lloc a $place, tal com es mostra a la foto?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Comptar aquesta entrada per a $date, quan es va fer la foto?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Definiu el lloc d\'aquesta entrada a $place, on s\'ha fet la foto?';
  }

  @override
  String get photoMetaApply => 'Utilitzeu-los';

  @override
  String get quickWriteTitle => 'Escriptura ràpida';

  @override
  String get quickWriteText => 'Toqueu per començar una nova entrada.';

  @override
  String get settingsQuickWriteTitle => 'Escriu ràpidament les notificacions';

  @override
  String get settingsQuickWriteDescription =>
      'Conserveu una notificació que obri una nova entrada.';

  @override
  String get settingsNudgesTitle =>
      'Doneu-me un cop després d\'un tram tranquil';

  @override
  String settingsNudgesDescription(int days) {
    return 'Un recordatori suau quan no heu escrit durant dies $days.';
  }

  @override
  String get nudgeTitle => 'Ja fa temps';

  @override
  String get nudgeMonday => 'Una nova setmana: què esperes?';

  @override
  String get nudgeTuesday => 'Amb dues línies n\'hi ha prou. Com estàs avui?';

  @override
  String get nudgeWednesday => 'A mitja setmana. Què ha destacat fins ara?';

  @override
  String get nudgeThursday =>
      'Alguna cosa petita que valgui la pena guardar d\'avui?';

  @override
  String get nudgeFriday => 'La setmana s\'acaba. Nota un bon moment.';

  @override
  String get nudgeSaturday => 'Un dissabte lent és un bon dia per escriure.';

  @override
  String get nudgeSunday => 'Mireu enrere la setmana abans que s\'acabi.';

  @override
  String get photoWidgetEmpty =>
      'Les fotos que afegiu a les entrades es mostren aquí.';

  @override
  String get channelReminders => 'Recordatoris';

  @override
  String get channelOnThisDay => 'En aquest dia';

  @override
  String get channelCoach => 'Instruccions de l\'entrenador';

  @override
  String get channelNudges => 'Empenta després de dies tranquils';

  @override
  String get channelQuickWrite => 'Escriptura ràpida';

  @override
  String get channelBackup => 'Còpies de seguretat';

  @override
  String get formatJsonExport => 'JSON (exportació AID Diary)';

  @override
  String get aboutModifiedNotice =>
      'Una versió modificada de Daily You per Demizo i col·laboradors. No és l\'aplicació oficial Daily You.';

  @override
  String get toolbarPhotos => 'Afegeix fotos';

  @override
  String get toolbarMedia => 'Fotos i vídeos';

  @override
  String get mediaFromGallery => 'Trieu de la galeria';

  @override
  String get mediaFromFiles => 'Trieu entre fitxers';

  @override
  String get editorLeaveTitle => 'Vols desar aquesta entrada?';

  @override
  String get editorLeaveDiscard => 'No deseu';

  @override
  String get editorTitleHint => 'Títol';

  @override
  String get editorLocating => 'Localitzant…';

  @override
  String get toolbarVideo => 'Vídeo';

  @override
  String get toolbarAudio => 'Nota de veu';

  @override
  String get toolbarTags => 'Etiquetes';

  @override
  String get toolbarBulletList => 'Llista amb pics';

  @override
  String get toolbarHeading => 'Encapçalament';

  @override
  String get toolbarBold => 'Atrevit';

  @override
  String get toolbarItalic => 'Cursiva';

  @override
  String get toolbarHighlight => 'Ressaltar';

  @override
  String get toolbarStrikethrough => 'Tallat';

  @override
  String get toolbarQuote => 'Cita';

  @override
  String get toolbarLink => 'Enllaç';

  @override
  String get toolbarInsert => 'Insereix';

  @override
  String get toolbarUndo => 'Desfer';

  @override
  String get toolbarRedo => 'Refer';

  @override
  String get toolbarInsertDate => 'Introduïu la data';

  @override
  String get toolbarInsertTime => 'Insereix l\'hora';

  @override
  String get settingsSyncTitle => 'Sincronització al núvol';

  @override
  String get syncOffDescription =>
      'Mantingueu aquest diari igual a tots els vostres dispositius mitjançant Google Drive o un servidor WebDAV, com ara Nextcloud, Synology o Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'Sincronitza amb Google Drive';

  @override
  String get syncOrWebDav => 'O un servidor WebDAV';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn =>
      'S\'ha iniciat la sessió. Podeu tornar a AID Diary.';

  @override
  String get syncGoogleSignInAgain =>
      'Google necessita que torneu a iniciar la sessió.';

  @override
  String get syncSignInAgain => 'Torna a iniciar la sessió';

  @override
  String get settingsCommandLineTitle => 'Línia d\'ordres';

  @override
  String get commandLineToggle => 'Interfície de línia d\'ordres';

  @override
  String get commandLineToggleHint =>
      'Permet que l\'ordre d\'ajuda i altres programes d\'aquest dispositiu utilitzin les ordres de l\'aplicació.';

  @override
  String get commandLineAlwaysOn =>
      'Sempre activa en les construccions de desenvolupament.';

  @override
  String commandLineListening(int port) {
    return 'Escoltant al port $port';
  }

  @override
  String get commandPaletteTitle => 'Totes les ordres';

  @override
  String get commandPaletteSearch => 'Ordres de cerca';

  @override
  String get commandPaletteRun => 'Corre';

  @override
  String get commandPaletteConfirm =>
      'Això no es pot desfer simplement. Executar-lo?';

  @override
  String syncReceiving(int done, int total) {
    return 'S\'està rebent $done de $total...';
  }

  @override
  String syncSending(int done, int total) {
    return 'S\'està enviant $done de $total...';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'No es va permetre l\'accés a Google Drive. Connecteu-vos de nou i marqueu Google Drive a la pàgina de Google.';

  @override
  String get syncEntryUnsynced =>
      'No sincronitzat: no s\'ha realitzat l\'última sincronització';

  @override
  String get syncUseOfficial => 'Utilitzeu el servidor de sincronització AID';

  @override
  String get syncServer => 'Adreça del servidor';

  @override
  String get syncUsername => 'Nom d\'usuari';

  @override
  String get syncPassword => 'Contrasenya';

  @override
  String get syncConnect => 'Connecta\'t';

  @override
  String get syncConnecting => 'S\'està connectant…';

  @override
  String get syncSignInFailed =>
      'No s\'ha pogut iniciar la sessió. Comproveu l\'adreça, el nom d\'usuari i la contrasenya.';

  @override
  String syncConnectFailed(String error) {
    return 'No s\'ha pogut connectar: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Comença a sincronitzar';

  @override
  String get syncNewSpaceDescription =>
      'Encara no hi ha un diari sincronitzat aquí. Aquest diari es penjarà, xifrat d\'extrem a extrem amb una clau que roman als vostres dispositius.';

  @override
  String get syncJoinTitle => 'Uneix-te al diari sincronitzat';

  @override
  String get syncWrongKey =>
      'Aquest codi de recuperació no obre el diari sincronitzat.';

  @override
  String syncLastSynced(String time) {
    return 'Darrera sincronització $time';
  }

  @override
  String get syncNever => 'Encara no s\'ha sincronitzat';

  @override
  String get syncSyncing => 'S\'està sincronitzant...';

  @override
  String syncFailed(String error) {
    return 'L\'última sincronització ha fallat: $error';
  }

  @override
  String get syncLocked =>
      'El diari sincronitzat ara pertany a altres dispositius o s\'ha tornat a iniciar. Vincula amb un d\'ells o utilitza el codi de recuperació per seguir sincronitzant-se.';

  @override
  String get syncNow => 'Sincronitza ara';

  @override
  String get syncUnlock => 'Desbloqueja';

  @override
  String get syncEncrypted => 'Encriptat d\'extrem a extrem';

  @override
  String get syncDisconnect => 'Atura la sincronització';

  @override
  String get syncDisconnectDescription =>
      'Aquest dispositiu deixa de sincronitzar-se. El diari aquí i la còpia sincronitzada es mantenen com estan.';

  @override
  String get syncOwnRecoveryPassword =>
      'Utilitzeu la meva pròpia contrasenya de recuperació';

  @override
  String get syncRecoveryPassword => 'Contrasenya de recuperació';

  @override
  String get syncRecoveryPasswordRepeat =>
      'Repetiu la contrasenya de recuperació';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Utilitzeu almenys caràcters $min';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'Les contrasenyes són diferents';

  @override
  String get syncRecoveryCode => 'Codi de recuperació';

  @override
  String get syncRecoveryCodeTitle => 'Deseu el codi de recuperació';

  @override
  String get syncRecoveryCodeDescription =>
      'Si es perd tots els vostres dispositius, aquest codi restaura el vostre diari sincronitzat. Guardeu-lo en un gestor de contrasenyes o en paper. Només es mostra aquesta una vegada.';

  @override
  String get syncRecoveryCodeCopied => 'S\'ha copiat el codi de recuperació';

  @override
  String get syncRecoveryCodeSaved => 'L\'he guardat';

  @override
  String get syncJoinNeedsKey =>
      'Aquest diari sincronitzat pertany als altres dispositius. Vincula amb un d\'ells o utilitza el codi de recuperació. S\'hi afegiran les entrades d\'aquest dispositiu.';

  @override
  String get syncPairDevice => 'Vincula amb un dispositiu';

  @override
  String get syncUseRecoveryCode => 'Utilitzeu el codi de recuperació';

  @override
  String get syncAddDevice => 'Afegeix un dispositiu';

  @override
  String get syncChangeRecoveryCode => 'Canvia el codi de recuperació';

  @override
  String get syncChangeRecoveryDescription =>
      'Un codi nou substitueix l\'actual, que deixa de funcionar. Les vostres dades i altres dispositius es mantenen com estan.';

  @override
  String get syncNewRandomCode => 'Nou codi aleatori';

  @override
  String get syncRecoveryCodeChanged => 'El codi de recuperació ha canviat';

  @override
  String get syncResetSpace => 'Torna a començar el diari sincronitzat';

  @override
  String get syncResetSpaceDescription =>
      'Només quan ja no s\'obre cap dispositiu ni cap codi de recuperació: la còpia sincronitzada se substitueix pel diari d\'aquest dispositiu, sota les claus d\'aquest dispositiu. A continuació, torna a emparellar els altres dispositius.';

  @override
  String get syncPairTitle => 'Vincula els dispositius';

  @override
  String get syncPairShow => 'Mostra un codi';

  @override
  String get syncPairEnter => 'Introduïu un codi';

  @override
  String get syncPairShowHint =>
      'A l\'altre dispositiu, obriu Vincular dispositius, trieu Introduïu un codi i escriviu-lo o escanegeu-lo.';

  @override
  String get syncPairEnterHint =>
      'Escriu el codi que mostra l\'altre dispositiu o escaneja\'l.';

  @override
  String get syncPairCode => 'Codi d\'aparellament';

  @override
  String get syncPairScan => 'Escaneja';

  @override
  String get syncPairStart => 'Parella';

  @override
  String get syncPairWaiting => 'S\'està esperant l\'altre dispositiu...';

  @override
  String syncPairDone(String device) {
    return 'Emparellada amb $device';
  }

  @override
  String get syncPairWrongCode =>
      'El codi no coincideix. Mostra un codi nou i torna-ho a provar.';

  @override
  String get syncPairNoOffer =>
      'Cap dispositiu mostra aquest codi. Pot ser que hagi caducat.';

  @override
  String get syncPairTimedOut => 'L\'altre dispositiu no va respondre a temps.';

  @override
  String get syncPairNeither =>
      'Encara no s\'ha configurat cap dispositiu amb aquest diari sincronitzat.';

  @override
  String get syncPairBoth =>
      'Tots dos dispositius ja obren aquest diari sincronitzat.';

  @override
  String syncPairFailed(String error) {
    return 'S\'ha produït un error en l\'aparellament: $error';
  }

  @override
  String get syncMediaPending =>
      'Agenda sincronitzada · alguns mitjans encara s\'estan transferint';

  @override
  String get syncWaitingForDevices =>
      'Diari sincronitzat · esperant que un altre dispositiu transfereixi contingut multimèdia';

  @override
  String get syncCacheNotice =>
      'Els mitjans al núvol són temporals. Conserveu els originals als vostres dispositius; la sincronització no és una còpia de seguretat.';

  @override
  String get paperTitle => 'Paper de carta';

  @override
  String get paperPlain => 'Plana';

  @override
  String get paperLined => 'Folrat';

  @override
  String get paperGrid => 'Quadrícula';

  @override
  String get paperTinted => 'Tintat';

  @override
  String get paperDecorationTitle => 'Decoracions';

  @override
  String get paperDecorationNone => 'Cap';

  @override
  String get paperDecorationBotanical => 'Fulles';

  @override
  String get paperDecorationStars => 'Estrelles';

  @override
  String get paperDecorationWashi => 'Cinta washi';

  @override
  String get themeDarkChoice => 'Aspecte fosc';

  @override
  String get themeDarkSame => 'Seguiu la paleta de llums';

  @override
  String get themeDarkCustom => 'Paleta separada';

  @override
  String get themeDarkAccent => 'Color d\'accent fosc';

  @override
  String get themeColorTeal => 'Blau verdós';

  @override
  String get themeColorCyan => 'Cian';

  @override
  String get themeColorIndigo => 'Indigo';

  @override
  String get themeColorCoral => 'Corall';

  @override
  String get themeColorOlive => 'oliva';

  @override
  String get themeColorSlate => 'Pissarra';

  @override
  String get drawingTitle => 'Dibuix';

  @override
  String get drawingPen => 'Bolígraf';

  @override
  String get drawingEraser => 'Goma d\'esborrar';

  @override
  String get drawingUndo => 'Desfer';

  @override
  String get drawingClear => 'Clar';

  @override
  String get drawingWidth => 'Amplada del bolígraf';

  @override
  String get drawingStylusOnly => 'Només llapis';

  @override
  String get drawingDiscardTitle => 'Descartar el dibuix?';

  @override
  String get drawingDiscardBody => 'Aquest dibuix no s\'ha desat.';

  @override
  String get drawingSaveError => 'No s\'ha pogut desar el dibuix.';

  @override
  String get syncNetworkTitle => 'Diagnòstic de la xarxa';

  @override
  String get syncNetworkRefresh => 'Actualitza';

  @override
  String get syncNetworkSelectedRoute => 'Camí actual';

  @override
  String get syncNetworkAvailableRoutes => 'Camins disponibles';

  @override
  String get syncNetworkSignaling => 'Connexió al directori del dispositiu';

  @override
  String get syncNetworkRelayRemaining => 'Subsistència de relleus restant';

  @override
  String get syncNetworkIcePair => 'Candidats a connexió directa';

  @override
  String get syncNetworkPeerTrusted => 'Dispositiu autenticat';

  @override
  String get syncNetworkNoRoute => 'Esperant una connexió';

  @override
  String get syncNetworkUnavailable => 'Els diagnòstics no estan disponibles';

  @override
  String get syncMediaCopiesTitle => 'Entrega de mitjans i còpies';

  @override
  String get syncMediaPendingCount => 'Esperant el trasllat';

  @override
  String get syncMediaDurableCount => 'Lliurat a l\'emmagatzematge personal';

  @override
  String get syncMediaTemporaryCount => 'Còpies temporals o no confirmades';

  @override
  String get syncMediaReceiptExplanation =>
      'Aquests recomptes descriuen els lliuraments completats, no una auditoria nova de les còpies de seguretat supervivents.';

  @override
  String get syncMediaCacheExplanation =>
      'Els mitjans temporals al núvol poden caducar. Conserveu els vostres originals o una còpia de seguretat independent.';

  @override
  String get momentsTitle => 'Moments fotogràfics';

  @override
  String get momentsHint =>
      'Trobeu grups utilitzant els horaris de les fotos locals i les coordenades opcionals. Les fotos només s\'adjunten quan trieu una targeta.';

  @override
  String get momentsScan => 'Busca moments';

  @override
  String get momentsChooseFolder => 'Trieu la carpeta de fotos';

  @override
  String get momentsLocation => 'Inclou ubicacions de fotos';

  @override
  String get momentsEmpty => 'No hi ha grups de fotos recents.';

  @override
  String get momentsCreate => 'Escriu sobre aquestes fotos';

  @override
  String get momentsDismiss => 'Descartar';

  @override
  String get momentsError => 'No s\'han pogut llegir les fotos locals.';

  @override
  String get momentsCreated => 'S\'ha creat una entrada de fotos.';

  @override
  String get momentsPermission =>
      'Permet l\'accés a les fotos per trobar suggeriments locals.';

  @override
  String get momentsScope =>
      'Només fotos recents; com a màxim 500 fotos i 20 fotos per targeta.';

  @override
  String momentsPhotoCount(int count) {
    return 'Fotos $count';
  }

  @override
  String get nearbyTitle => 'Connecteu dispositius';

  @override
  String get nearbySend => 'Autoritzar un altre dispositiu';

  @override
  String get nearbyReceive => 'Connecteu-vos a un dispositiu existent';

  @override
  String get nearbyInstructions =>
      'Connecteu els dos dispositius al mateix Wi-Fi o al punt d\'accés de l\'altre. Confirmeu l\'autorització al dispositiu existent; tots dos dispositius continuen utilitzables. No es requereix internet.';

  @override
  String get nearbyCompare =>
      'Compareu aquest codi als dos dispositius abans d\'aprovar-lo.';

  @override
  String get nearbyConfirm => 'Els codis coincideixen';

  @override
  String get nearbyScan => 'Escaneja el codi de l\'altre dispositiu';

  @override
  String get nearbyPaste => 'Enganxa la invitació';

  @override
  String get nearbyWaiting =>
      'S\'està esperant l\'aprovació a l\'altre dispositiu';

  @override
  String get nearbyWorking =>
      'S\'està autoritzant i sincronitzant el vostre diari i els fitxers adjunts...';

  @override
  String get nearbyPending =>
      'Alguns fitxers adjunts encara s\'han de sincronitzar. Manteniu l\'altre dispositiu en línia i torneu-ho a provar.';

  @override
  String get nearbyComplete =>
      'Dispositiu connectat; diari i fitxers adjunts sincronitzats';

  @override
  String get nearbyFailed =>
      'La connexió no s\'ha acabat. Comproveu la connexió local i torneu-ho a provar.';

  @override
  String get nearbyEmptyRequired =>
      'Utilitzeu un dispositiu amb un diari buit que encara no estigui connectat per sincronitzar.';

  @override
  String get nearbyRetry => 'Continueu sincronitzant';

  @override
  String get nearbyWifi => 'Configuració de Wi-Fi';

  @override
  String get nearbyHotspot => 'Configuració de l\'hotspot';

  @override
  String get nearbyKeepOpen =>
      'Manteniu aquesta pàgina oberta fins que acabi el dispositiu nou. La invitació caduca al cap de dos minuts.';

  @override
  String get syncDevicesTitle => 'Dispositius autoritzats';

  @override
  String get syncDevicesDescription =>
      'Només els dispositius aprovats poden accedir a aquest compte d\'AID. La revocació d\'un dispositiu bloqueja el servidor, però no es pot esborrar una clau mestra o un diari que s\'hi hagi copiat.';

  @override
  String get syncDeviceRequest =>
      'Mostra aquest QR d\'autorització a un dispositiu aprovat';

  @override
  String get syncDeviceAuthorize => 'Autoritzar un dispositiu';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Escaneja o enganxa la sol·licitud d\'autorització del dispositiu nou.';

  @override
  String get syncDeviceRevoke => 'Revocar';

  @override
  String get syncDeviceRotate =>
      'Gira la clau de signatura d\'aquest dispositiu';

  @override
  String get syncDeviceCheck => 'Comprovar l\'autorització';

  @override
  String get syncDeviceHardware => 'Clau de signatura amb suport de maquinari';

  @override
  String get syncDeviceSoftware =>
      'Clau de signatura de programari no exportable';

  @override
  String get syncDeviceUnavailable =>
      'L\'autorització del dispositiu no està disponible. Aprova aquest dispositiu des d\'un altre dispositiu autoritzat i torna-ho a provar.';

  @override
  String get syncDeviceRevoked => 'Revocat';

  @override
  String get syncDeviceLocal => 'Aquest dispositiu';

  @override
  String get cloudTrafficTitle =>
      'Quota mensual de transferència de dades al núvol per a fitxers multimèdia';

  @override
  String get cloudTrafficLimit => 'Quota mensual de transferència de dades';

  @override
  String get cloudTrafficUsed => 'Transferència de dades utilitzada';

  @override
  String get cloudTrafficRemaining => 'Transferència de dades restants';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'La quota de transferència de dades restableix $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'La quota de transferència de dades al núvol per als fitxers multimèdia s\'ha esgotat. Els fitxers multimèdia que faltin se sincronitzaran automàticament quan hi hagi una connexió directa disponible o la quota es restableixi.';

  @override
  String get cloudTrafficExplanation =>
      'La memòria cau de fitxers multimèdia i la retransmissió en directe comparteixen aquesta quota de transferència de dades. Les connexions directes no el consumeixen. El text del diari i els missatges de control de connexió tenen límits diaris petits separats.';

  @override
  String get appearanceThemeSection => 'Tema de l\'aplicació';

  @override
  String get appearancePaperSection => 'Paper de diari';

  @override
  String get appearanceTypographySection => 'Text del diari';

  @override
  String get appearancePreferencesSection => 'Preferències generals';

  @override
  String get themeSystemAccentHint =>
      'Utilitza la paleta del sistema en lloc de colors personalitzats. Apagueu-lo per triar el vostre.';

  @override
  String get syncDeviceNameSaveFailed =>
      'No s\'ha pogut desar el nom del dispositiu. Si us plau, torna-ho a provar.';

  @override
  String get nearbyConnectionHelp => 'Ajuda de connexió';

  @override
  String get syncAllSynced => 'Tot sincronitzat';

  @override
  String get syncDetailsTitle => 'Detalls de sincronització';

  @override
  String get syncMore => 'Més opcions';

  @override
  String get syncDeviceName => 'Nom del dispositiu';

  @override
  String get syncDeviceNameHint => 'Per exemple: La meva tauleta';

  @override
  String get syncDeviceNameInvalid => 'Utilitzeu d\'1 a 32 caràcters';

  @override
  String get syncDeviceKeyDetails => 'Detalls de seguretat';

  @override
  String get syncConnectionProblem =>
      'No es pot sincronitzar de moment. S\'està tornant a provar automàticament.';

  @override
  String get syncCopyComplete =>
      'Còpia completa del vostre diari i fitxers multimèdia';

  @override
  String get syncCopyPartial => 'Encara falten alguns mitjans';

  @override
  String get syncCopyOlder =>
      'S\'estan esperant nous canvis per sincronitzar-se';

  @override
  String get syncCopyUnavailable =>
      'Els detalls de la còpia no estan disponibles. Torna-ho a provar més tard.';

  @override
  String get syncCopyLastKnown =>
      'Altres dispositius mostren la seva darrera còpia confirmada. Els dispositius fora de línia no es poden comprovar ara.';

  @override
  String get syncCopyTemporary =>
      'Memòria cau temporal. Conserveu els originals als vostres dispositius.';

  @override
  String get syncCopyStorage =>
      'El vostre emmagatzematge de sincronització. Les càrregues multimèdia finalitzades es mostren al diagnòstic.';

  @override
  String syncCopyChecked(String time) {
    return 'Última confirmació $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Transferència de dades que queden aquest mes: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Comenceu aquí';

  @override
  String get onboardConnect => 'Connecteu-vos a un dispositiu existent';

  @override
  String get onboardFailed =>
      'No s\'ha pogut completar la configuració. El teu diari està segur; si us plau, torna-ho a provar.';

  @override
  String get tutorialTitle => 'Com utilitzar el diari';

  @override
  String get tutorialWriteTitle => 'Escriu la teva primera entrada al diari';

  @override
  String get tutorialWriteText =>
      'Toqueu + per escriure una entrada del diari. Afegiu un títol opcional, trieu la data del diari i toqueu la marca de verificació per desar-lo. Podeu tornar a editar l\'entrada de l\'agenda en qualsevol moment.';

  @override
  String get tutorialMediaTitle => 'Afegeix fotos, àudio o escriptura a mà';

  @override
  String get tutorialMediaText =>
      'Feu servir + a l\'editor del diari per adjuntar fotos, vídeos o una gravació de veu, o per obrir el llenç d\'escriptura a mà. Aquests fitxers adjunts es guarden amb l\'entrada del diari.';

  @override
  String get tutorialReviewTitle => 'Torna a trobar un dia';

  @override
  String get tutorialReviewText =>
      'Exploreu el vostre diari o calendari, cerqueu els vostres escrits i organitzeu les entrades amb etiquetes. Les pàgines de Mitjans i Atles us permeten trobar entrades anteriors per foto o ubicació.';

  @override
  String get tutorialSyncTitle => 'Utilitzeu més d\'un dispositiu';

  @override
  String get tutorialSyncText =>
      'A Configuració → Dades i emmagatzematge → Sincronització, connecteu-vos a un dispositiu existent i confirmeu l\'autorització en aquest dispositiu. Tots dos dispositius poden seguir utilitzant el diari. El text del diari es sincronitza primer. Els fitxers multimèdia es sincronitzen a continuació quan la connexió de xarxa i la quota de transferència de dades restants ho permetin.';

  @override
  String get tutorialPrivacyTitle => 'Guarda el teu diari segur';

  @override
  String get tutorialPrivacyText =>
      'Les entrades del diari romanen en aquest dispositiu tret que les activeu la sincronització, les compartiu o les exporteu. La sincronització està xifrada d\'extrem a extrem. A Configuració també podeu establir una contrasenya d\'aplicació, crear còpies de seguretat i tornar a obrir aquest tutorial.';

  @override
  String get editorDiaryDay => 'Dia del diari';

  @override
  String get editorDiaryDayPicker => 'Dia del diari · creació sense canvis';

  @override
  String get editorDiaryDayHint =>
      'El dia al qual pertany aquesta entrada. Canviar-lo no modifica la data ni l’hora de creació.';

  @override
  String get hiddenDiaryTitle => 'Entrades ocultes';

  @override
  String get hiddenDiaryHide => 'Amaga l’entrada';

  @override
  String get hiddenDiaryShow => 'Mostra l’entrada';

  @override
  String get hiddenDiaryEmpty => 'No hi ha entrades ocultes';

  @override
  String get hiddenDiaryUnlock => 'Desbloca les entrades ocultes';

  @override
  String get hiddenDiaryAuthHint =>
      'Utilitza el bloqueig de l’aplicació o de la pantalla del dispositiu.';

  @override
  String get hiddenDiaryLocalOnly =>
      'Les entrades ocultes es queden en aquest dispositiu i aturen la sincronització. Utilitza còpies de seguretat xifrades. Les còpies existents en altres llocs no canvien.';

  @override
  String get moodClear => 'Esborra l’estat d’ànim';
}
