// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Occitan (`oc`).
class AppLocalizationsOc extends AppLocalizations {
  AppLocalizationsOc([String locale = 'oc']) : super(locale);

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => 'Color del tèma';

  @override
  String get themeColorHint => 'Causissètz una color per aquesta paleta.';

  @override
  String get themeColorBlue => 'Blau cèl';

  @override
  String get themeColorGreen => 'Verd de bòsc';

  @override
  String get themeColorBrown => 'Cafè caud';

  @override
  String get themeColorPurple => 'Lavanda';

  @override
  String get themeColorRose => 'Ròsa polverosa';

  @override
  String get themeColorAmber => 'Ambre';

  @override
  String get themeColorPreview => 'Un pauc cada jorn';

  @override
  String get themeTintBackgroundTitle => 'Tintar los fons amb la color de tèma';

  @override
  String get themeTintBackgroundHint =>
      'Desactivar pels fons grises neutres; los botons gardan la color causida.';

  @override
  String get dailyReminderTitle => 'Enregistratz vòstra jornada !';

  @override
  String get dailyReminderDescription => 'Remplissez votre journal de bord…';

  @override
  String get actionTakePhoto => 'Prenètz la fòto';

  @override
  String get flashbacksTitle => 'Retorn enrèire';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Exclure los jorns negatius';

  @override
  String get flashbackGoodDay => 'Una bona jornada';

  @override
  String get flashbackRandomDay => 'Un jorn ordinari';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'fa $count setmanas',
      one: 'fa $count setmana',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'fa $count meses',
      one: 'fa $count mes',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'fa $count ans',
      one: 'fa $count an',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'En aquest dia';

  @override
  String get searchLogsHint => 'Cercar d\'entradas de jornal...';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entradas',
      one: '$count entrada',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jorns',
      one: '$count jorn',
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
  String get noLogs => 'Cap d’entrada…';

  @override
  String get noResults => 'Pas de resultats…';

  @override
  String get sortOrderAscendingTitle => 'Ascendent';

  @override
  String get sortOrderDescendingTitle => 'Descendent';

  @override
  String get pageStatisticsTitle => 'Estatisticas';

  @override
  String get statisticsNotEnoughData => 'Pas pro de donadas…';

  @override
  String get statisticsRangeOneMonth => '1 mes';

  @override
  String get statisticsRangeSixMonths => '6 meses';

  @override
  String get statisticsRangeOneYear => '1 an';

  @override
  String get statisticsRangeAllTime => 'Tot temps';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag Resumit';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag per jorn';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag Al cors del temps';
  }

  @override
  String get chartGroupingLabel => 'Agropar per';

  @override
  String get chartGroupingDay => 'Jorn';

  @override
  String get chartGroupingWeek => 'Setmana';

  @override
  String get chartGroupingMonth => 'Mes';

  @override
  String get chartGroupingYear => 'An';

  @override
  String get chartSmoothingLabel => 'Alisament';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rasca actuala $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rasca mai longa $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Grands jorns $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jorns dempuèi un marrit jorn $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Pòt pas accedir a l\'emmagazinatge extèrne';

  @override
  String get errorExternalStorageAccessDescription =>
      'Se utilizatz l\'emmagazinatge de ret asseguratz-vos que lo servici es en linha e qu\'avètz accès a la ret.\n\nAutrament, l\'aplicacion pòt aver perdut las permissions pel dorsièr extèrne. Anatz dins los paramètres, e tornatz seleccionar lo dorsièr extèrne per concedir l\'accès.\n\nAtencion, las modificacions seràn pas sincronizadas tant que restablitz pas l\'accès a l\'emplaçament d\'emmagazinatge extèrne !';

  @override
  String get errorExternalStorageAccessContinue =>
      'Contunhar amb la basa de donadas locala';

  @override
  String get lastModified => 'Modificacion';

  @override
  String get writeSomethingHint => 'Escrivètz quicòm…';

  @override
  String get titleHint => 'Títol…';

  @override
  String get deleteLogTitle => 'Suprimir l’entrada ?';

  @override
  String get deleteLogDescription =>
      'L\'entrada se desplaça cap a Recentament suprimit, ont la podètz restablir.';

  @override
  String get deletePhotoTitle => 'Escafar la fòto';

  @override
  String get deletePhotoDescription => 'Volètz escafar aquesta fòto ?';

  @override
  String get pageSettingsTitle => 'Paramètres';

  @override
  String get settingsTheme => 'Tèma';

  @override
  String get themeSystem => 'Sistèma';

  @override
  String get themeLight => 'Clar';

  @override
  String get themeDark => 'Escur';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Primièr jorn de la setmana';

  @override
  String get settingsCalendarSystem => 'Sistèma de calendièr';

  @override
  String get calendarSystemGregorian => 'Gregorian';

  @override
  String get calendarSystemJalali => 'Jalali';

  @override
  String get settingsUseSystemAccentColor => 'Personalizar la color afortida';

  @override
  String get settingsCustomAccentColor => 'Color d\'accent personalizada';

  @override
  String get settingsShowFlashbacks => 'Mostrar los flashbacks';

  @override
  String get settingsChangeMoodIcons => 'Icònas de cambiament d\'umor';

  @override
  String get moodIconPrompt => 'Picatz una icòna';

  @override
  String get settingsHideImages => 'Amagar las imatges';

  @override
  String get pageCalendarTitle => 'Calendièr';

  @override
  String get settingsNotificationsTitle => 'Notificacions';

  @override
  String get settingsDailyReminderTitle => 'Rapèl quotidian';

  @override
  String get settingsOnThisDayDescription =>
      'Tornatz visitar los sovenirs passats';

  @override
  String get settingsDailyReminderDescription => 'Un rapèl doç cada jorn';

  @override
  String get settingsReminderTime => 'Ora del rapèl';

  @override
  String get settingsFixedReminderTimeTitle => 'Temps de rapèl fixat';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Causissètz un orari fixe pel rapèl';

  @override
  String get settingsAlwaysSendReminderTitle => 'Mandatz totjorn un rapèl';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Mandatz un rapèl quitament se una entrada de jornal èra ja aviada';

  @override
  String get settingsCustomizeNotificationTitle =>
      'Personalizar las notificacions';

  @override
  String get settingsTemplatesTitle => 'Modèls';

  @override
  String get manageTemplates => 'Gerir los modèls';

  @override
  String get noTemplateTitle => 'Cap';

  @override
  String get noTemplatesDescription => 'Cap de modèl pas encara creat...';

  @override
  String get templateDefaultTimestampTitle => 'Estampèl de temps';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Resumit del jorn';

  @override
  String get templateDefaultSummaryBody =>
      '### Resumit\n- \n\n### Citacion\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Reflexion';

  @override
  String get templateDefaultReflectionBody =>
      '### De qué vos agradèt uèi?\n- \n\n### Per qué sètz arregraït?\n- \n\n### Qu\'espèras amb impatiéncia?\n- ';

  @override
  String get settingsTagsTitle => 'Etiquetas';

  @override
  String get manageTags => 'Gerir las etiquetas';

  @override
  String get tagTypeLabelTitle => 'Etiqueta';

  @override
  String get tagTypeTrackerTitle => 'Seguidor';

  @override
  String get nameHint => 'Nom';

  @override
  String get tagColorLabel => 'Color';

  @override
  String get iconPickerTitle => 'Causissètz Icòna';

  @override
  String get iconPickerIconsTab => 'Icònas';

  @override
  String get iconPickerCustomTab => 'Personalizat';

  @override
  String get iconPickerSearchHint => 'Icònas de recèrca...';

  @override
  String get colorPickerTitle => 'Causissètz la color';

  @override
  String get colorPickerPaletteTab => 'Colors';

  @override
  String get iconGroupMoodPeople => 'Umor & Personas';

  @override
  String get iconGroupHealth => 'Salut';

  @override
  String get iconGroupWorkFinance => 'Trabalh e finanças';

  @override
  String get iconGroupHabitsGoals => 'Abituds e Objectius';

  @override
  String get iconGroupNature => 'Natura';

  @override
  String get iconGroupFoodDrink => 'Manjar e beure';

  @override
  String get iconGroupHome => 'Acuèlh';

  @override
  String get iconGroupTravel => 'Viatge';

  @override
  String get iconGroupSymbols => 'Simbòls';

  @override
  String get tagCategoryLabel => 'Categoria';

  @override
  String get tagLabel => 'Etiqueta';

  @override
  String get tagCategoryUncategorized => 'Sens categoria';

  @override
  String get newCategoryTitle => 'Categoria novèla';

  @override
  String get shareButtonLabel => 'Partatjar';

  @override
  String get importErrorDescription => 'Fracàs a l\'importacion del fichièr !';

  @override
  String get exportErrorDescription => 'Fracàs a l\'exportacion del fichièr !';

  @override
  String get deleteTitle => 'Suprimir';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Es utilizat dins $count dintradas de jornal.',
      one: ' Es utilizat dins 1 jornal.',
      zero: '',
    );
    return 'Suprimir \"$name\"?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Sas balisas $count seràn tanben suprimidas.',
      one: ' Son 1 balisa serà tanben suprimida.',
      zero: '',
    );
    return 'Suprimir \"$name\"?$_temp0';
  }

  @override
  String get tagNameExists => 'I a ja una balisa amb aqueste nom';

  @override
  String get categoryNameExists => 'I a ja una categoria amb aqueste nom';

  @override
  String deleteTemplateMessage(Object name) {
    return 'Suprimir \"$name\"?';
  }

  @override
  String get addTagsTitle => 'Apondre d\'etiquetas';

  @override
  String get addTagsSearchHint => 'Recèrca d\'etiquetas...';

  @override
  String get tagFavoriteName => 'Preferit';

  @override
  String get iconGroupActivities => 'Activitats';

  @override
  String get iconGroupHobbies => 'Divertiment';

  @override
  String get settingsStorageTitle => 'Emmagazinatge';

  @override
  String get settingsImageQuality => 'Qualitat d\'imatge';

  @override
  String get imageQualityHigh => 'Elevada';

  @override
  String get imageQualityMedium => 'Mejana';

  @override
  String get imageQualityLow => 'Febla';

  @override
  String get imageQualityNoCompression => 'Cap de compression';

  @override
  String get settingsLogFolder => 'Dossièr dels jornals';

  @override
  String get settingsImageFolder => 'Dossièrs dels imatges';

  @override
  String get warningTitle => 'Avertiment';

  @override
  String get logFolderWarningDescription =>
      'Se lo dorsièr seleccionat conten ja un fichièr \'aid_diary.db\', serà utilizat per subrescriure vòstras entradas de jornal existentas !';

  @override
  String get errorTitle => 'Error';

  @override
  String get logFolderErrorDescription =>
      'Fracàs al cambiament del dorsièr d\'entrada del jornal !';

  @override
  String get imageFolderErrorDescription =>
      'Fracàs al cambiament del dorsièr d\'imatge !';

  @override
  String get backupErrorDescription =>
      'Fracàs de la creacion de la salvagarda !';

  @override
  String get restoreErrorDescription =>
      'Fracàs al moment de la restauracion de la còpia de seguretat !';

  @override
  String get settingsBackupRestoreTitle => 'Sauvagarda e restauracion';

  @override
  String get settingsBackup => 'Salvagardar';

  @override
  String get settingsRestore => 'Restaurar';

  @override
  String get settingsRestorePromptDescription =>
      'Restablir una còpia de seguretat subrescriurà vòstras donadas existentas !';

  @override
  String get settingsBackupPasswordProtect =>
      'Las còpias de seguretat protegidas per senhal';

  @override
  String get backupEncryptedTitle => 'Sauvagarda chifrada';

  @override
  String get backupEncryptedContent =>
      'Aquesta còpia de seguretat es protegida per senhal.';

  @override
  String get settingsAutoBackup => 'Sauvagardas automaticas';

  @override
  String get settingsAutoBackupLocation => 'Emplaçament de sauvagarda';

  @override
  String get settingsAutoBackupInterval => 'Interval de salvament';

  @override
  String get settingsAutoBackupIntervalDaily => 'Quotidian';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Setmanièr';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Mensual';

  @override
  String get settingsAutoBackupMaxCount => 'De còpias de seguretat per gardar';

  @override
  String get settingsAutoBackupRequireCharging => 'Sonque en carga';

  @override
  String settingsBackupLast(Object time) {
    return 'Darrièra còpia de seguretat $time';
  }

  @override
  String get settingsBackupNever => 'Pas jamai salvat';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Sauvagarda seguenta $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'Totes';

  @override
  String get autoBackupFailedTitle => 'La sauvagarda a fracassat';

  @override
  String tranferStatus(Object percent) {
    return 'Transferiment… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Creacion de la salvagarda… $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Restauracion de la salvagarda… $percent%';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return 'Chifrar la còpia de seguretat... $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Deschifrar la còpia de seguretat... $percent%';
  }

  @override
  String get cleanUpStatus => 'Netejatge…';

  @override
  String get settingsExportToAnotherFormat => 'Exportar cap a un autre format';

  @override
  String get settingsExportFormatDescription =>
      'Aquò deu pas èsser utilizat coma còpia de seguretat !';

  @override
  String get settingsImportFromAnotherApp =>
      'Importar dempuèi una autra aplicacion';

  @override
  String get logFormatTitle => 'Causissètz Format';

  @override
  String get logFormatDescription =>
      'Lo format d\'una autra aplicacion pòt pas prene en carga totas las foncionalitats. Mercés de raportar tot problèma perque los formats tèrces pòdon cambiar a tot moment. Aquò impactarà pas las entradas del jornal existentas!';

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
  String get settingsDeleteAllLogsTitle =>
      'Suprimir totas las entradas del jornal';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Volètz suprimir totas vòstras entradas de jornal?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Picatz \'$prompt\' per confirmar. Aquò pòt pas èsser desfach!';
  }

  @override
  String get settingsAppLanguageTitle => 'Lenga de l\'aplicacion';

  @override
  String get settingsSecurityTitle => 'Seguretat';

  @override
  String get settingsSecurityRequirePassword => 'Requerir un senhal';

  @override
  String get settingsSecurityEnterPassword => 'Picatz lo senhal';

  @override
  String get settingsSecuritySetPassword => 'Definir lo senhal';

  @override
  String get settingsSecurityChangePassword => 'Cambiar lo senhal';

  @override
  String get settingsSecurityPassword => 'Senhal';

  @override
  String get settingsSecurityConfirmPassword => 'Confirmar lo senhal';

  @override
  String get settingsSecurityOldPassword => 'Ancian senhal';

  @override
  String get settingsSecurityIncorrectPassword => 'Senhal incorrècte';

  @override
  String get settingsSecurityPasswordsDoNotMatch =>
      'Los senhals correspondon pas';

  @override
  String get requiredPrompt => 'Requerit';

  @override
  String get settingsSecurityBiometricUnlock => 'Desblocatge biometric';

  @override
  String get unlockAppPrompt => 'Desblocar l\'aplicacion';

  @override
  String get settingsAboutTitle => 'A prepaus';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsLicense => 'Licéncia';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsOpenSourceLicenses => 'Licéncias de còde dobèrt';

  @override
  String get tagMoodTitle => 'Umor';

  @override
  String get selectTagTitle => 'Seleccionar l\'etiqueta';

  @override
  String get labelPresentLabel => 'Present';

  @override
  String get labelAbsentLabel => 'Absent';

  @override
  String get labelCoverageLabel => 'Cobertura';

  @override
  String chartDistributionTitle(Object tag) {
    return 'Distribucion $tag';
  }

  @override
  String get shareAddToLogPickerTitle => 'Causissètz una entrada de jornal';

  @override
  String get adaptiveEmptyDay => 'Cap d\'intrada per aqueste jorn encara';

  @override
  String get adaptiveNewEntry => 'Escriure una entrada';

  @override
  String get pageJournalTitle => 'Jornal';

  @override
  String get coachPrompt1 => 'Qué te faguèt sorire uèi?';

  @override
  String get coachPrompt2 => 'Qu\'es una causa qu\'avètz aprés uèi?';

  @override
  String get coachPrompt3 => 'A qui parlètz uèi, e cossí vos sentiguètz?';

  @override
  String get coachPrompt4 => 'De qué sètz agraït ara?';

  @override
  String get coachPrompt5 => 'Qué a pres la màger part de vòstra energia uèi?';

  @override
  String get coachPrompt6 =>
      'Descrivètz un pichon moment que volètz remembrar.';

  @override
  String get coachPrompt7 => 'Qué fariá deman un bon jorn?';

  @override
  String get coachPrompt8 => 'Qué t\'es estat a l\'esperit recentament?';

  @override
  String get coachPrompt9 => 'Qué faguètz uèi sonque per vos?';

  @override
  String get coachPrompt10 => 'Se uèi aviá un títol, qual seriá?';

  @override
  String get pageMediaTitle => 'Mèdias';

  @override
  String get pageAtlasTitle => 'Atlas';

  @override
  String get pageCoachTitle => 'Entraïnaire';

  @override
  String get noEntrySelected => 'Cap d\'entrada seleccionada.';

  @override
  String get entryShare => 'Partatjar';

  @override
  String get entryFavorite => 'Estela';

  @override
  String get entryEdit => 'Modificar';

  @override
  String get entryPrevious => 'Dintrada precedenta';

  @override
  String get entryNext => 'Entrada seguenta';

  @override
  String get journalStories => 'Contes';

  @override
  String get journalEntries => 'Entradas';

  @override
  String get journalEmptyHint =>
      'Començatz vòstre jornal en apondent una novèla entrada.';

  @override
  String get storyToday => 'Uèi';

  @override
  String get storyThrowback => 'Retorn';

  @override
  String get storyNoThrowback => 'Pas de retorn uèi';

  @override
  String get mediaFiles => 'Fichièrs mèdias';

  @override
  String get mediaEmpty => 'Pas de fòtos encara.';

  @override
  String get mediaEmptyHint =>
      'Las fòtos jonchas a las entradas seràn afichadas aicí.';

  @override
  String get atlasEmpty => 'Cap d\'entrada amb un emplaçament.';

  @override
  String get atlasEmptyHint =>
      'Las entradas amb un emplaçament seràn afichadas aicí.';

  @override
  String get atlasShowAll => 'Afichar totas las entradas';

  @override
  String get atlasMyLocation => 'Mon emplaçament';

  @override
  String get coachAll => 'Totes';

  @override
  String get coachPrograms => 'Programas';

  @override
  String get coachTemplates => 'Modèls';

  @override
  String get coachKindProgram => 'Programa';

  @override
  String get coachKindTemplate => 'Modèl';

  @override
  String get coachNoTemplates => 'Pas de programas ni de modèls.';

  @override
  String get coachUseTemplate => 'Escrivètz amb aqueste modèl';

  @override
  String get coachProgramEverydayTitle => 'Moments de cada jorn';

  @override
  String get coachProgramEverydayDescription =>
      'Cinc questions cortas, una per jorn. Cadun pren una minuta o doas e vos ajuda a veire çò que faguèt la jornada vòstra. Un biais gentil de bastir l\'abitud d\'escriure un pauc cada jorn.';

  @override
  String get coachProgramReflectTitle => 'Agachant cap a l\'interior';

  @override
  String get coachProgramReflectDescription =>
      'Una question mai prigonda per setmana, pendent cinc setmanas. Prenètz vòstre temps amb cadun: cossí vos avètz sentit, çò que vos cansa, çò que sètz agraït.';

  @override
  String get searchFilters => 'Filtres';

  @override
  String get searchFilterTags => 'Etiquetas';

  @override
  String get searchFilterStarred => 'Estelat';

  @override
  String get searchHint => 'Picatz per cercar, o causissètz un filtre.';

  @override
  String get locationTitle => 'Emplaçament';

  @override
  String get locationName => 'Nom de luòc';

  @override
  String get locationRemove => 'Suprimir';

  @override
  String get locationServiceDisabled =>
      'Los servicis de localizacion son desactivats.';

  @override
  String get locationPermissionDenied =>
      'L\'autorizacion de l\'emplaçament es estada refusada.';

  @override
  String get locationUnavailable => 'Poguèt pas obténer l\'emplaçament actual.';

  @override
  String get calendarJumpToToday => 'Sautatz a uèi';

  @override
  String get editorStartWriting => 'Començatz d\'escriure o causissètz un ';

  @override
  String get editorTemplateLink => 'Modèl';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Causissètz un modèl';

  @override
  String get templateFeatured => 'Modèls destacats';

  @override
  String get templateMine => 'Mos modèls';

  @override
  String get templateDailyName => 'Revista quotidiana';

  @override
  String get templateDailyDescription =>
      'Çò que se passèt, cossí se sentiguèt, e çò que ven après.';

  @override
  String get templateDailyText =>
      '## Çò que se passèt uèi\n\n\n## Cossí me sentiguèri\n\n\n## Tres causas que ne soi agraït\n1. \n2. \n3. \n\n## Deman\n';

  @override
  String get templateTravelName => 'Dintrada del jornal de viatge';

  @override
  String get templateTravelDescription => 'Luòcs, moments e manjar de la rota.';

  @override
  String get templateTravelText =>
      '## Ont soi anat\n\n\n## Lo moment que me soveni lo mai\n\n\n## Çò qu\'ai manjat\n\n\n## Plans per deman\n';

  @override
  String get templateReadingName => 'De nòtas de lectura';

  @override
  String get templateReadingDescription =>
      'Citacions e pensadas de çò que legissètz.';

  @override
  String get templateReadingText =>
      '## Libre\n\n\n## Ont soi\n\n\n## Citacions\n> \n\n## Mas pensadas\n';

  @override
  String get templateWeeklyName => 'Revision setmanièra';

  @override
  String get templateWeeklyDescription =>
      'Moments fòrts, luchas e l\'enjòc de la setmana que ven.';

  @override
  String get templateWeeklyText =>
      '## Destacats\n\n\n## Çò qu\'èra dur\n\n\n## Çò qu\'ai aprés\n\n\n## Focus per la setmana que ven\n';

  @override
  String get entrySaveAsTemplate => 'Enregistrar coma modèl';

  @override
  String get entrySavedAsTemplate => 'Enregistrat coma modèl';

  @override
  String get storyStatistics => 'Estatisticas';

  @override
  String get storyMoodChart => 'Tablèu d\'umor';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return '$entries entradas · $days jorns';
  }

  @override
  String get storyThisYear => 'Ongan';

  @override
  String get storyLastYear => 'L\'an passat';

  @override
  String get storyTapToOpen => 'Picatz un jorn per lo dobrir';

  @override
  String get settingsGeneralTitle => 'General';

  @override
  String get settingsDataTitle => 'Donadas e emmagazinatge';

  @override
  String get settingsStoriesTitle => 'Contes';

  @override
  String get settingsHelpTitle => 'Ajuda & a prepaus';

  @override
  String get weatherTitle => 'Temps';

  @override
  String get weatherClear => 'Escafar';

  @override
  String get weatherPartlyCloudy => 'Parcialament nivolós';

  @override
  String get weatherCloudy => 'Nivolós';

  @override
  String get weatherFog => 'Nèbla';

  @override
  String get weatherDrizzle => 'Rossèla';

  @override
  String get weatherRain => 'Pluèja';

  @override
  String get weatherSnow => 'Nèu';

  @override
  String get weatherStorm => 'Tempèsta de tron';

  @override
  String get weatherFetch => 'Obténer lo temps per aquesta entrada';

  @override
  String get weatherNeedsLocation =>
      'Apondètz d\'en primièr un emplaçament amb de coordenadas.';

  @override
  String get weatherUnavailable =>
      'Lo temps es pas disponible per aqueste luòc e ora.';

  @override
  String get weatherRemove => 'Suprimir lo temps';

  @override
  String get activityTitle => 'Activitat';

  @override
  String get activityStill => 'Encara';

  @override
  String get activityWalking => 'Caminar';

  @override
  String get activityRunning => 'En cors';

  @override
  String get activityCycling => 'Ciclisme';

  @override
  String get activityVehicle => 'Dins un veïcul';

  @override
  String get activityFlying => 'Volar';

  @override
  String get activityExercise => 'Exercici';

  @override
  String get activityDetect => 'Detectar l\'activitat actuala';

  @override
  String get activityDetectFailed => 'Poguèt pas detectar una activitat.';

  @override
  String get activityRemove => 'Suprimir l\'activitat';

  @override
  String get settingsAutoAddTitle => 'Apondre automaticament';

  @override
  String get settingsAutoAddLocation => 'Emplaçament';

  @override
  String get settingsAutoAddWeather => 'Temps';

  @override
  String get settingsAutoAddHint =>
      'Las novèlas dintradas son emplenadas quand son creadas.';

  @override
  String get settingsTemperatureUnit => 'Unitat de temperatura';

  @override
  String get settingsCelsius => 'Celsius (°C)';

  @override
  String get settingsFahrenheit => 'Fahrenheit (°F)';

  @override
  String get moodGreat => 'Grand';

  @override
  String get moodGood => 'Bon';

  @override
  String get moodOkay => 'D\'acòrdi';

  @override
  String get moodBad => 'marrit';

  @override
  String get moodAwful => 'espaventós';

  @override
  String get locationSearchHint => 'Cercar un luòc';

  @override
  String get locationSearchEmpty => 'Cap de luòc trobat';

  @override
  String get settingsWallpaper => 'Fond d\'ecran';

  @override
  String get wallpaperNone => 'Cap';

  @override
  String get wallpaperDots => 'Punts';

  @override
  String get wallpaperGrid => 'Grilha';

  @override
  String get wallpaperLines => 'Linhas';

  @override
  String get wallpaperPhoto => 'Fòto…';

  @override
  String get settingsFontFamily => 'Poliça';

  @override
  String get fontSystem => 'Sistèma';

  @override
  String get fontSerif => 'Serif';

  @override
  String get fontMono => 'Monospaci';

  @override
  String get settingsFontSize => 'Talha de poliça';

  @override
  String get fontSizeSmall => 'Pichon';

  @override
  String get fontSizeMedium => 'Mejan';

  @override
  String get fontSizeLarge => 'Grand';

  @override
  String get fontSizeExtraLarge => 'Extra grand';

  @override
  String get settingsLineSpacing => 'Espaçament de linhas';

  @override
  String get lineSpacingCompact => 'Compacte';

  @override
  String get lineSpacingNormal => 'Normal';

  @override
  String get lineSpacingRelaxed => 'Relaxat';

  @override
  String get moodAssociationsTitle => 'Çò que me fa sentir...';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching de las entradas $total';
  }

  @override
  String get videoRecord => 'Enregistrar una vidèo';

  @override
  String get videoChoose => 'Causissètz una vidèo';

  @override
  String get audioRecordTitle => 'Enregistrar una nòta vocala';

  @override
  String get audioChoose => 'Causissètz un fichièr àudio';

  @override
  String get audioStart => 'Enregistrament';

  @override
  String get audioStop => 'Arrèsta e salva';

  @override
  String get audioPermissionDenied =>
      'L\'accès al micrò es desactivat. O permetre dins los paramètres del sistèma.';

  @override
  String get mediaTooLarge => 'Aquesta vidèo es tròp granda per l\'ajustar.';

  @override
  String get mediaUnavailable =>
      'Aquesta pèça junta es pas disponibla sus aqueste periferic.';

  @override
  String get widgetDone => 'L\'entrada d\'avui es escrita';

  @override
  String get widgetPending => 'Cossí foguèt vòstra jornada?';

  @override
  String get widgetWrite => 'Escriure';

  @override
  String get insertChecklist => 'Lista de contraròtle';

  @override
  String get insertNumberedList => 'Lista numerotada';

  @override
  String get insertTable => 'Taula';

  @override
  String get insertDivider => 'Divisor';

  @override
  String get insertCodeBlock => 'Blòt de còde';

  @override
  String get journalSortTitle => 'Triar las entradas';

  @override
  String get journalSortUpdated => 'Darrièra mesa a jorn';

  @override
  String get settingsTimeFormat => 'Format de l\'ora';

  @override
  String get settingsDayStart =>
      'Las novèlas entradas comptan pel jorn d\'abans fins a';

  @override
  String get settingsDayAskUntil => 'Alara demandatz quin jorn fins a';

  @override
  String get settingsDayStartMidnight => 'Desactivat';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Cada entrada garda lo jorn qu\'aperten a costat de l\'ora ont foguèt escricha, e podètz cambiar aquel jorn dins l\'editor a tot moment. Aquestas oras causisson pas que lo jorn per las novèlas entradas, doncas las cambiar desplaça pas cap d\'entrada existenta.';

  @override
  String get lateNightBadge =>
      'Escrich tard dins la nuèch, comptat pel jorn d\'abans';

  @override
  String editorDayAsk(String time) {
    return 'Escrit a $time. Per quin jorn es?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (ièr)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (uèi)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'Escrich $when';
  }

  @override
  String get timeFormat12 => '12-oras';

  @override
  String get timeFormat24 => '24 oras';

  @override
  String get settingsReminderDays => 'Me remembratz sus';

  @override
  String get locationRecent => 'Luòcs recents';

  @override
  String get shareImage => 'Partejar l\'imatge';

  @override
  String get shareSaveImage => 'Enregistrar l\'imatge';

  @override
  String get shareSaved => 'Imatge enregistrat';

  @override
  String get deletedTitle => 'Suprimit recentament';

  @override
  String get deletedNone => 'Pas res suprimit recentament';

  @override
  String deletedHint(int days) {
    return 'Las entradas suprimidas demòran aicí pendent $days jorns, puèi son escafadas.';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days quedan dias';
  }

  @override
  String get deletedRestore => 'Restaurar';

  @override
  String get deletedDeleteForever => 'Suprimir per totjorn';

  @override
  String get deletedDeleteForeverDescription =>
      'L\'entrada e sas pèças juntas son escafadas. Aquò pòt pas èsser desfach.';

  @override
  String get deletedEmpty => 'Vuèg';

  @override
  String get deletedEmptyDescription =>
      'Esfaçar cada entrada dins Recentament suprimit? Aquò pòt pas èsser desfach.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Caminada aleatòria';

  @override
  String get randomSubtitle => 'Dobrir una entrada passada';

  @override
  String get randomNext => 'Un autre';

  @override
  String get randomAll => 'Totes';

  @override
  String get randomWithPhotos => 'Amb de fòtos';

  @override
  String get randomGoodDays => 'Bons jorns';

  @override
  String get randomEmpty => 'Pas d\'entrada a causir';

  @override
  String get reviewWeekTitle => 'Aquesta setmana';

  @override
  String get reviewWeekSubtitle => 'Vòstra setmana fins ara';

  @override
  String get reviewYearTitle => 'Ongan';

  @override
  String get reviewEmpty => 'Res escrich encara';

  @override
  String get reviewEntries => 'Entradas';

  @override
  String get reviewDaysWritten => 'Jorns escrichs';

  @override
  String get reviewWords => 'Mots';

  @override
  String get reviewPhotos => 'Fòtos';

  @override
  String get reviewLongestRun => 'La corsa mai longa de jorns';

  @override
  String get reviewAverageMood => 'Umor mejan';

  @override
  String get reviewFavorites => 'Lo mai sovent';

  @override
  String get reviewByMonth => 'Per mes';

  @override
  String get reviewHighlight => 'Restacament';

  @override
  String get yearInPixels => 'Annada en pixèls';

  @override
  String get capsuleSeal => 'Segel coma una capsula del temps';

  @override
  String get capsuleTitle => 'Capsula del temps';

  @override
  String capsuleOpensOn(Object date) {
    return 'Dobrís sus $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Escrich sus $date';
  }

  @override
  String get capsuleOpenEarly => 'Dubèrt lèu';

  @override
  String get capsuleOpenEarlyDescription =>
      'La capsula se dobrís ara e demòra dobèrta.';

  @override
  String get capsuleOpened => 'Capsula del temps dobèrta';

  @override
  String get templateMorningName => 'Paginas del matin';

  @override
  String get templateMorningDescription =>
      'Configurar la jornada en tres minutas';

  @override
  String get templateMorningText =>
      '## Tres causas que vòli plan far uèi\n1. \n2. \n3. \n\n## Quicòm qu\'espèri\n\n## Una nòta a ieu meteis\n';

  @override
  String get templateEveningName => 'Revista del ser';

  @override
  String get templateEveningDescription =>
      'Tancatz la jornada amb çò qu\'anèt plan';

  @override
  String get templateEveningText =>
      '## Tres bonas causas uèi\n1. \n2. \n3. \n\n## Çò qu\'ai aprés\n\n## Qué poiriá anar melhor deman\n';

  @override
  String get routineMorning => 'Bonjorn';

  @override
  String get routineEvening => 'Revista del ser';

  @override
  String get settingsRoutinePrompts => 'Invitacions del matin e del ser';

  @override
  String get settingsRoutinePromptsHint =>
      'Suggerissètz lo modèl de matin o de ser dins los Contes';

  @override
  String get checkInTitle => 'Enregistrament rapid';

  @override
  String get checkInSubtitle => 'L\'umor en dos taps';

  @override
  String get checkInMood => 'Cossí te sentisses?';

  @override
  String get checkInActivity => 'Qué fasètz?';

  @override
  String get checkInNote => 'Una linha a prepaus d\'aquò (facultatiu)';

  @override
  String get checkInSave => 'Enregistrar';

  @override
  String editorWordCount(int words, int characters) {
    return '$words mots · $characters caractèrs';
  }

  @override
  String get coachProgramEverydayTagline =>
      'Remarcatz las pichonas causas dins un jorn.';

  @override
  String get coachProgramReflectTagline => 'Alentissètz e escotatz-vos.';

  @override
  String get coachDuration => 'Durada';

  @override
  String get coachInterval => 'Interval';

  @override
  String get coachDifficulty => 'Dificultat';

  @override
  String get coachIntervalDaily => 'Quotidian';

  @override
  String get coachIntervalWeekly => 'Setmanièr';

  @override
  String get coachDifficultyBeginner => 'Debutant';

  @override
  String get coachDifficultyIntermediate => 'Intermediari';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jorns',
      one: '1 jorn',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count setmanas',
      one: '1 setmana',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'Jorn $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Setmana $n';
  }

  @override
  String get coachEnroll => 'Inscrivètz-vos';

  @override
  String get coachEndProgram => 'Fin lo programa';

  @override
  String get coachAuthor => 'Autor';

  @override
  String get coachAuthorBio => 'Demandas escrichas per aquesta aplicacion.';

  @override
  String get coachEnrolledTip =>
      'Tot preparat! Vòstras questions apareisseràn dins los Contes.';

  @override
  String get coachGoToStories => 'Anar a Istòrias';

  @override
  String get coachAnswerHint => 'Escrivètz vòstra responsa...';

  @override
  String get storyWrapUp => 'Aquò\'s tot per uèi.';

  @override
  String get storyTapToClose => 'Picatz per tampar';

  @override
  String get coachAnswerDone => 'Fach';

  @override
  String get coachAnswered => 'Respondut, picatz per dobrir';

  @override
  String get coachAnsweredEarlier => 'Respondut';

  @override
  String get locationLocating => 'Localizacion...';

  @override
  String get locationPickPlace => 'Causissètz un luòc';

  @override
  String get locationPlacesHint => 'Adreça o nom del luòc';

  @override
  String get locationCustom => 'Luòc personalizat';

  @override
  String get locationCurrent => 'Emplaçament actual';

  @override
  String get locationSaved => 'Luòcs enregistrats';

  @override
  String get locationSearchResults => 'Resultats de recèrca';

  @override
  String get locationNearby => 'Luòcs pròches';

  @override
  String get locationRename => 'Renomenar';

  @override
  String get locationSavePlace => 'Salvar la plaça';

  @override
  String get locationUnsavePlace => 'Suprimir dels luòcs enregistrats';

  @override
  String get shareAs => 'Partatjar coma...';

  @override
  String get shareAsImage => 'Imatge';

  @override
  String get shareAsZip => 'ZIP amb los mèdias originals';

  @override
  String get shareAsPlainText => 'Tèxte simple';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Benvenguda a AID Diary';

  @override
  String get onboardWelcomeText =>
      'Començatz aicí, o connectatz aqueste periferic a un qu\'utilizatz ja.';

  @override
  String get onboardStart => 'Començatz d\'escriure';

  @override
  String get helpFaq => 'Questions frequentas';

  @override
  String get helpFaq1Q => 'Ont es emmagazinat mon jornal?';

  @override
  String get helpFaq1A =>
      'Vòstre jornal es enregistrat sus aqueste periferic. Atenh d\'autres periferics o emmagazinatge sonque quand l\'activatz la sincronizacion, lo partatge o l\'exportacion. La sincronizacion es chifrada de punta a punta.';

  @override
  String get helpFaq2Q =>
      'Cossí gardar una còpia o passar a un periferic novèl?';

  @override
  String get helpFaq2A =>
      'Connectatz-vos a un periferic existent dins Paramètres → Donadas e emmagazinatge → Sincronizar e confirmar l\'autorizacion sul periferic qu\'a vòstre jornal. Los dos periferics demòran utilizables. Podètz tanben crear una còpia de seguretat e la restablir sus un autre periferic.';

  @override
  String get helpFaq3Q =>
      'Pòdi portar d\'entradas d\'autras aplicacions de jornal?';

  @override
  String get helpFaq3A =>
      'Òc: dins Paramètres → Donadas e emmagazinatge, importatz d\'exportacions dempuèi Daylio, Diarium, Diaro, DayBook, My Brain, OneShot e Pixels, o una exportacion JSON.';

  @override
  String get helpFaq4Q => 'Cossí foncionan los programas d\'entraïnaire?';

  @override
  String get helpFaq4A =>
      'Inscrivètz-vos a un programa sus la pagina Coach. Cada jorn o setmana una novèla question espèra dins los Contes; vòstra responsa es enregistrada coma una dintrada.';

  @override
  String get helpFaq5Q => 'E se oblidi mon senhal?';

  @override
  String get helpFaq5A =>
      'Lo senhal pòt pas èsser recuperat, doncas gardatz una còpia de seguretat de vòstre jornal.';

  @override
  String get helpPrivacy => 'Confidencialitat';

  @override
  String get helpPrivacyText =>
      'Lo contengut del jornal e los mèdias demòran sus aqueste periferic levat se activatz la sincronizacion chifrada o los partejatz/exportatz. Las mapas, la recèrca de luòcs e lo temps utilizan los servicis configurats e mandan l\'emplaçament o la requèsta de recèrca necessàrias per aquela demanda, pas lo tèxte del jornal.';

  @override
  String get photoMetaTitle => 'Utilizar los detalhs de la fòto?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Comptar aquesta entrada per $date e fixar sa plaça a $place, coma enregistrat sus la fòto?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Comptar aquesta entrada per $date, quand la fòto foguèt presa?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Definissètz la plaça d\'aquesta entrada a $place, ont la fòto es estada presa ?';
  }

  @override
  String get photoMetaApply => 'Los utilizatz';

  @override
  String get quickWriteTitle => 'Escritura rapida';

  @override
  String get quickWriteText => 'Picatz per començar una novèla dintrada.';

  @override
  String get settingsQuickWriteTitle =>
      'Escritura rapida dins las notificacions';

  @override
  String get settingsQuickWriteDescription =>
      'Gardatz una notificacion que dobrís una novèla dintrada.';

  @override
  String get settingsNudgesTitle => 'Empegatz-me après un tram tranquille';

  @override
  String settingsNudgesDescription(int days) {
    return 'Un rapèl doç quand avètz pas escrich dempuèi $days jorns.';
  }

  @override
  String get nudgeTitle => 'Fa un brieu';

  @override
  String get nudgeMonday => 'Una setmana novèla: de qué esperatz?';

  @override
  String get nudgeTuesday => 'Doas linhas son pro. Cossí va uèi?';

  @override
  String get nudgeWednesday =>
      'A mièg camin de la setmana. Qué se destacava fins ara?';

  @override
  String get nudgeThursday =>
      'Qualqu\'un de pichon que valga la pena de gardar a partir d\'uèi?';

  @override
  String get nudgeFriday => 'La setmana s\'acaba. Notatz un bon moment.';

  @override
  String get nudgeSaturday => 'Un dissabte lent es un bon jorn per escriure.';

  @override
  String get nudgeSunday => 'Regardatz enrè la setmana abans que s\'acabe.';

  @override
  String get photoWidgetEmpty =>
      'Las fòtos qu\'apondretz a las entradas apareisson aicí.';

  @override
  String get channelReminders => 'Rapèls';

  @override
  String get channelOnThisDay => 'En aquest dia';

  @override
  String get channelCoach => 'Instruccions de l\'entraïnaire';

  @override
  String get channelNudges => 'Emponts après de jorns de silenci';

  @override
  String get channelQuickWrite => 'Escritura rapida';

  @override
  String get channelBackup => 'Sauvagardas';

  @override
  String get formatJsonExport => 'JSON (exportacion AID Diary)';

  @override
  String get aboutModifiedNotice =>
      'Una version modificada de Daily You de Demizo e contributors. Es pas l\'aplicacion oficiala Daily You.';

  @override
  String get toolbarPhotos => 'Ajustar de fòtos';

  @override
  String get toolbarMedia => 'Fòtos e vidèos';

  @override
  String get mediaFromGallery => 'Causissètz dins la galariá';

  @override
  String get mediaFromFiles => 'Causir demest los fichièrs';

  @override
  String get editorLeaveTitle => 'Enregistrar aquesta entrada?';

  @override
  String get editorLeaveDiscard => 'Enregistratz pas';

  @override
  String get editorTitleHint => 'Títol';

  @override
  String get editorLocating => 'Localizacion...';

  @override
  String get toolbarVideo => 'Vidèo';

  @override
  String get toolbarAudio => 'Nòta vocala';

  @override
  String get toolbarTags => 'Etiquetas';

  @override
  String get toolbarBulletList => 'Lista en vignetas';

  @override
  String get toolbarHeading => 'Entèsta';

  @override
  String get toolbarBold => 'Gras';

  @override
  String get toolbarItalic => 'Italic';

  @override
  String get toolbarHighlight => 'Restacament';

  @override
  String get toolbarStrikethrough => 'Strikethrough';

  @override
  String get toolbarQuote => 'Citacion';

  @override
  String get toolbarLink => 'Ligam';

  @override
  String get toolbarInsert => 'Inserir';

  @override
  String get toolbarUndo => 'Desfar';

  @override
  String get toolbarRedo => 'Tornatz far';

  @override
  String get toolbarInsertDate => 'Inserir la data';

  @override
  String get toolbarInsertTime => 'Inserir l\'ora';

  @override
  String get settingsSyncTitle => 'Sincronizacion en nívol';

  @override
  String get syncOffDescription =>
      'Gardatz aqueste jornal parièr sus totes vòstres periferics a travèrs Google Drive o un servidor WebDAV, coma Nextcloud, Synology o Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'Sincronizacion amb Google Drive';

  @override
  String get syncOrWebDav => 'O un servidor WebDAV';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn => 'Connectat. Podètz tornar a AID Diary.';

  @override
  String get syncGoogleSignInAgain =>
      'Google a besonh que vos connectatz tornarmai.';

  @override
  String get syncSignInAgain => 'Connectatz-vos tornarmai';

  @override
  String get settingsCommandLineTitle => 'Linha de comanda';

  @override
  String get commandLineToggle => 'Interfàcia de linha de comanda';

  @override
  String get commandLineToggleHint =>
      'Daissa la comanda d\'ajuda e d\'autres programas sus aqueste periferic utilizar las comandas de l\'aplicacion.';

  @override
  String get commandLineAlwaysOn =>
      'Totjorn sus las construccions de desvolopament.';

  @override
  String commandLineListening(int port) {
    return 'Escota sul pòrt $port';
  }

  @override
  String get commandPaletteTitle => 'Totas las comandas';

  @override
  String get commandPaletteSearch => 'Comandas de recèrca';

  @override
  String get commandPaletteRun => 'Correr';

  @override
  String get commandPaletteConfirm =>
      'Aquò pòt pas èsser simplament desfach. Lo far foncionar?';

  @override
  String syncReceiving(int done, int total) {
    return 'Recepcion de $done de $total…';
  }

  @override
  String syncSending(int done, int total) {
    return 'Enviant $done de $total…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'L\'accès a Google Drive èra pas autorizat. Tornatz vos connectar e marcatz Google Drive sus la pagina de Google.';

  @override
  String get syncEntryUnsynced =>
      'Pas sincronizada : la darrièra sincronizacion passèt pas per';

  @override
  String get syncUseOfficial => 'Utilizar lo servidor de sincronizacion AID';

  @override
  String get syncServer => 'Adreça del servidor';

  @override
  String get syncUsername => 'Nom d\'utilizaire';

  @override
  String get syncPassword => 'Senhal';

  @override
  String get syncConnect => 'Connectar';

  @override
  String get syncConnecting => 'Connectar...';

  @override
  String get syncSignInFailed =>
      'Impossible de se connectar. Verificatz l\'adreça, lo nom d\'utilizaire e lo senhal.';

  @override
  String syncConnectFailed(String error) {
    return 'Impossible de se connectar : $error';
  }

  @override
  String get syncNewSpaceTitle => 'Començar la sincronizacion';

  @override
  String get syncNewSpaceDescription =>
      'I a pas encara de jornal sincronizat aicí. Aqueste jornal serà mandat, chifrat de punta a punta amb una clau que demòra sus vòstres periferics.';

  @override
  String get syncJoinTitle => 'Jónher lo jornal sincronizat';

  @override
  String get syncWrongKey =>
      'Aqueste còde de recuperacion dobrís pas lo jornal sincronizat.';

  @override
  String syncLastSynced(String time) {
    return 'Darrièr sincronizat $time';
  }

  @override
  String get syncNever => 'Pas encara sincronizat';

  @override
  String get syncSyncing => 'Sincronizacion...';

  @override
  String syncFailed(String error) {
    return 'La darrièra sincronizacion a fracassat : $error';
  }

  @override
  String get syncLocked =>
      'Lo jornal sincronizat aparten ara a d\'autres periferics, o es estat reaviat. Acoblar amb un d\'eles o utilizar lo còde de recuperacion per contunhar la sincronizacion.';

  @override
  String get syncNow => 'Sincronizar ara';

  @override
  String get syncUnlock => 'Desblocar';

  @override
  String get syncEncrypted => 'Chifrat de punta a punta';

  @override
  String get syncDisconnect => 'Arrestar la sincronizacion';

  @override
  String get syncDisconnectDescription =>
      'Aqueste periferic s\'arrèsta de sincronizar. Lo jornal aicí e la còpia sincronizada demòran coma son.';

  @override
  String get syncOwnRecoveryPassword =>
      'Utilizar mon pròpri senhal de recuperacion';

  @override
  String get syncRecoveryPassword => 'Senhal de recuperacion';

  @override
  String get syncRecoveryPasswordRepeat => 'Repetir lo senhal de recuperacion';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Utilizar al mens de caractèrs $min';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'Los senhals diferís';

  @override
  String get syncRecoveryCode => 'Còde de recuperacion';

  @override
  String get syncRecoveryCodeTitle =>
      'Enregistratz vòstre còde de recuperacion';

  @override
  String get syncRecoveryCodeDescription =>
      'Se cada vòstre periferic es perdut, aqueste còde restaura vòstre jornal sincronizat. Gardatz-lo dins un gestionari de senhals o sus papièr. Es mostrat sonque aquò un còp.';

  @override
  String get syncRecoveryCodeCopied => 'Lo còde de recuperacion copiat';

  @override
  String get syncRecoveryCodeSaved => 'L\'ai salvat';

  @override
  String get syncJoinNeedsKey =>
      'Aqueste jornal sincronizat aparten a vòstres autres periferics. Acoblar amb un d\'eles, o utilizar lo còde de recuperacion. Las entradas sus aqueste periferic i seràn apondudas.';

  @override
  String get syncPairDevice => 'Acoblar amb un periferic';

  @override
  String get syncUseRecoveryCode => 'Utilizar lo còde de recuperacion';

  @override
  String get syncAddDevice => 'Apondre un periferic';

  @override
  String get syncChangeRecoveryCode => 'Cambiatz lo còde de recuperacion';

  @override
  String get syncChangeRecoveryDescription =>
      'Un còde novèl remplaça l\'actual, qu\'arrèsta de foncionar. Vòstras donadas e autres periferics demòran coma son.';

  @override
  String get syncNewRandomCode => 'Novèl còde aleatòri';

  @override
  String get syncRecoveryCodeChanged => 'Lo còde de recuperacion modificat';

  @override
  String get syncResetSpace => 'Aviatz lo jornal sincronizat sus';

  @override
  String get syncResetSpaceDescription =>
      'Solament quand cap de periferic e cap de còde de recuperacion lo dobrís pas mai : la còpia sincronizada es remplaçada pel jornal sus aqueste periferic, jos las tòcas d\'aqueste periferic. Vòstres autres periferics s\'acoblan alara tornarmai.';

  @override
  String get syncPairTitle => 'Acoblament de periferics';

  @override
  String get syncPairShow => 'Mostrar un còde';

  @override
  String get syncPairEnter => 'Picatz un còde';

  @override
  String get syncPairShowHint =>
      'Sus vòstre autre periferic, dobrissètz Acoblament de periferics, causissètz Picatz un còde, e picatz o escanejatz aquò.';

  @override
  String get syncPairEnterHint =>
      'Picatz lo còde que vòstre autre periferic mòstra, o escanejatz-lo.';

  @override
  String get syncPairCode => 'Còde d\'acoblament';

  @override
  String get syncPairScan => 'Escanar';

  @override
  String get syncPairStart => 'Parelh';

  @override
  String get syncPairWaiting => 'En espèra de l\'autre periferic...';

  @override
  String syncPairDone(String device) {
    return 'Acoblat amb $device';
  }

  @override
  String get syncPairWrongCode =>
      'Lo còde correspondiá pas. Afichar un còde novèl e ensajar tornarmai.';

  @override
  String get syncPairNoOffer =>
      'Cap de periferic aficha pas aqueste còde. Benlèu qu\'es expirat.';

  @override
  String get syncPairTimedOut => 'L\'autre periferic respondèt pas a temps.';

  @override
  String get syncPairNeither =>
      'Cap dels dos periferics es pas encara configurat amb aqueste jornal sincronizat.';

  @override
  String get syncPairBoth =>
      'Los dos periferics dobrisson ja aqueste jornal sincronizat.';

  @override
  String syncPairFailed(String error) {
    return 'L\'acoblament fracassat: $error';
  }

  @override
  String get syncMediaPending =>
      'Diari sincronizat · qualques mèdias son encara en transferiment';

  @override
  String get syncWaitingForDevices =>
      'Jornal sincronizat · en espèra qu\'un autre periferic transferisca de mèdias';

  @override
  String get syncCacheNotice =>
      'Los mèdias en nívol son temporaris. Gardatz los originals sus vòstres periferics; la sincronizacion es pas una còpia de seguretat.';

  @override
  String get paperTitle => 'Papièr de letra';

  @override
  String get paperPlain => 'Plana';

  @override
  String get paperLined => 'Forrat';

  @override
  String get paperGrid => 'Grilha';

  @override
  String get paperTinted => 'Tintat';

  @override
  String get paperDecorationTitle => 'Decoracions';

  @override
  String get paperDecorationNone => 'Cap';

  @override
  String get paperDecorationBotanical => 'Fuèlhas';

  @override
  String get paperDecorationStars => 'Estelas';

  @override
  String get paperDecorationWashi => 'Cinta Washi';

  @override
  String get themeDarkChoice => 'Aparéncia escura';

  @override
  String get themeDarkSame => 'Seguir la paleta de lums';

  @override
  String get themeDarkCustom => 'Paleta separada';

  @override
  String get themeDarkAccent => 'Color d\'accent escur';

  @override
  String get themeColorTeal => 'Teal';

  @override
  String get themeColorCyan => 'Cian';

  @override
  String get themeColorIndigo => 'Indigò';

  @override
  String get themeColorCoral => 'Coralh';

  @override
  String get themeColorOlive => 'Oliva';

  @override
  String get themeColorSlate => 'Pissarra';

  @override
  String get drawingTitle => 'Dessenh';

  @override
  String get drawingPen => 'Pluma';

  @override
  String get drawingEraser => 'Boma';

  @override
  String get drawingUndo => 'Desfar';

  @override
  String get drawingClear => 'Escafar';

  @override
  String get drawingWidth => 'Largor de pluma';

  @override
  String get drawingStylusOnly => 'Solament estilò';

  @override
  String get drawingDiscardTitle => 'Descartar lo dessenh?';

  @override
  String get drawingDiscardBody => 'Aqueste dessenh es pas estat enregistrat.';

  @override
  String get drawingSaveError => 'Pogut pas enregistrar lo dessenh.';

  @override
  String get syncNetworkTitle => 'Diagnòstic de ret';

  @override
  String get syncNetworkRefresh => 'Actualizar';

  @override
  String get syncNetworkSelectedRoute => 'Camin actual';

  @override
  String get syncNetworkAvailableRoutes => 'Camins disponibles';

  @override
  String get syncNetworkSignaling => 'Connexion del repertòri de periferic';

  @override
  String get syncNetworkRelayRemaining => 'Indemnitat de relèu restant';

  @override
  String get syncNetworkIcePair => 'Candidats de connexion dirècta';

  @override
  String get syncNetworkPeerTrusted => 'Dispositiu autentificat';

  @override
  String get syncNetworkNoRoute => 'En espèra d\'una connexion';

  @override
  String get syncNetworkUnavailable => 'Los diagnostics son pas disponibles';

  @override
  String get syncMediaCopiesTitle => 'Liurason de mèdias e còpias';

  @override
  String get syncMediaPendingCount => 'En espèra de transferir';

  @override
  String get syncMediaDurableCount => 'Liurat a l\'emmagazinatge personal';

  @override
  String get syncMediaTemporaryCount => 'Còpias temporàrias o non confirmadas';

  @override
  String get syncMediaReceiptExplanation =>
      'Aquestes comptes descrivon de liurasons completadas, pas una novèla auditoria de còpias de seguretat subreviventas.';

  @override
  String get syncMediaCacheExplanation =>
      'Los mèdias cloud temporaris pòdon expirar. Gardatz vòstres originals o una còpia de seguretat a despart.';

  @override
  String get momentsTitle => 'Moments de fòto';

  @override
  String get momentsHint =>
      'Trobar de grops en utilizant d\'oraris de fòto localas e de coordenadas facultativas. Las fòtos son jonchas sonque quand causissètz una carta.';

  @override
  String get momentsScan => 'Trobar de moments';

  @override
  String get momentsChooseFolder => 'Causissètz lo dorsièr de fòtos';

  @override
  String get momentsLocation => 'Inclure los emplaçaments de las fòtos';

  @override
  String get momentsEmpty => 'Pas de grops de fòtos recents.';

  @override
  String get momentsCreate => 'Escrivètz sus aquelas fòtos';

  @override
  String get momentsDismiss => 'Descartar';

  @override
  String get momentsError => 'Poguèt pas legir las fòtos localas.';

  @override
  String get momentsCreated => 'Entrada de fòto creada.';

  @override
  String get momentsPermission =>
      'Autorizar l\'accès a las fòtos per trobar de suggestions localas.';

  @override
  String get momentsScope =>
      'Solament de fòtos recentas; al maximum 500 fòtos e 20 fòtos per carta.';

  @override
  String momentsPhotoCount(int count) {
    return '$count fòtos';
  }

  @override
  String get nearbyTitle => 'Connectar los periferics';

  @override
  String get nearbySend => 'Autorizar un autre periferic';

  @override
  String get nearbyReceive => 'Connectar-se a un periferic existent';

  @override
  String get nearbyInstructions =>
      'Connectatz los dos periferics al meteis Wi-Fi o al punt d\'accès de l\'autre. Confirmatz l\'autorizacion sul periferic existent ; los dos periferics demòran utilizables. Cap d\'internet es pas requerit.';

  @override
  String get nearbyCompare =>
      'Comparatz aqueste còde sus los dos periferics abans l\'aprovar.';

  @override
  String get nearbyConfirm => 'Los còdes correspondon';

  @override
  String get nearbyScan => 'Escanejar lo còde de l\'autre periferic';

  @override
  String get nearbyPaste => 'Pegatz l\'invitacion';

  @override
  String get nearbyWaiting =>
      'En espèra de l\'aprobacion sus l\'autre periferic';

  @override
  String get nearbyWorking =>
      'Autorizar e sincronizar vòstre jornal e las pèças juntas...';

  @override
  String get nearbyPending =>
      'Qualques pièces juntas an encara besonh de sincronizacion. Mantenètz l\'autre periferic en linha e ensajatz tornarmai.';

  @override
  String get nearbyComplete =>
      'Dispositiu connectat; jornal e pièces juntas sincronizadas';

  @override
  String get nearbyFailed =>
      'La connexion s\'es pas acabada. Verificatz la connexion locala e ensajatz tornarmai.';

  @override
  String get nearbyEmptyRequired =>
      'Utilizatz un periferic amb un jornal void qu\'es pas encara connectat a la sincronizacion.';

  @override
  String get nearbyRetry => 'Contunhar la sincronizacion';

  @override
  String get nearbyWifi => 'Paramètres Wi-Fi';

  @override
  String get nearbyHotspot => 'Paramètres de punt d\'accès';

  @override
  String get nearbyKeepOpen =>
      'Mantenètz aquesta pagina dobèrta fins que lo periferic novèl s\'acabe. L\'invitacion s\'expira al cap de doas minutas.';

  @override
  String get syncDevicesTitle => 'Dispositius autorizats';

  @override
  String get syncDevicesDescription =>
      'Sonque los periferics aprovats pòdon accedir a aqueste compte AID. La revocacion d\'un periferic bloca lo servidor mas pòt pas esfaçar una clau mèstra o un jornal ja copiat sus el.';

  @override
  String get syncDeviceRequest =>
      'Afichar aqueste QR d\'autorizacion a un periferic aprovat';

  @override
  String get syncDeviceAuthorize => 'Autorizar un periferic';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Escanejatz o pegatz la demanda d\'autorizacion del periferic novèl.';

  @override
  String get syncDeviceRevoke => 'Revocar';

  @override
  String get syncDeviceRotate =>
      'Viratz la clau de signatura d\'aqueste periferic';

  @override
  String get syncDeviceCheck => 'Verificar l\'autorizacion';

  @override
  String get syncDeviceHardware => 'Clau de signatura sostenguda pel matériel';

  @override
  String get syncDeviceSoftware =>
      'Clau de signatura de logicials non exportable';

  @override
  String get syncDeviceUnavailable =>
      'L\'autorizacion del periferic es pas disponibla. Aprovatz aqueste periferic dempuèi un autre periferic autorizat e tornatz ensajar.';

  @override
  String get syncDeviceRevoked => 'Revocat';

  @override
  String get syncDeviceLocal => 'Aqueste periferic';

  @override
  String get cloudTrafficTitle =>
      'Quòta mensual de transferiment de donadas en nívol pels fichièrs mèdias';

  @override
  String get cloudTrafficLimit => 'Quòta de transferéncia de donadas mensuala';

  @override
  String get cloudTrafficUsed => 'Transferiment de donadas utilizat';

  @override
  String get cloudTrafficRemaining => 'Transferiment de donadas que demòra';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'Lo quòta de transferiment de donadas reïnicializa $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'Lo quòta de transferiment de donadas en nívol pels fichièrs mèdias es estat utilizat. Los fichièrs mèdias mancants se sincronizaràn automaticament quand una connexion dirècta es disponibla o lo quòta reïnicializat.';

  @override
  String get cloudTrafficExplanation =>
      'L\'escondedor de fichièrs multimèdias e lo relais en dirècte partejan aqueste quòta de transferiment de donadas. Las connexions dirèctas lo consoman pas. Los messatges de tèxte del jornal e de contraròtle de connexion an de limits jornalièrs pichons separats.';

  @override
  String get appearanceThemeSection => 'Tèma de l\'aplicacion';

  @override
  String get appearancePaperSection => 'Papièr de jornal';

  @override
  String get appearanceTypographySection => 'Tèxte del jornal';

  @override
  String get appearancePreferencesSection => 'Preferéncias generalas';

  @override
  String get themeSystemAccentHint =>
      'Utiliza la paleta del sistèma al luòc de las colors personalizadas. Apagatz-lo per causir lo vòstre.';

  @override
  String get syncDeviceNameSaveFailed =>
      'Impossible d\'enregistrar lo nom del periferic. Ensajatz tornarmai.';

  @override
  String get nearbyConnectionHelp => 'Ajuda de connexion';

  @override
  String get syncAllSynced => 'Tot sincronizat';

  @override
  String get syncDetailsTitle => 'Detalhs de sincronizacion';

  @override
  String get syncMore => 'Mai d\'opcions';

  @override
  String get syncDeviceName => 'Nom del periferic';

  @override
  String get syncDeviceNameHint => 'Per exemple: Ma tauleta';

  @override
  String get syncDeviceNameInvalid => 'Utilizar de 1 a 32 caractèrs';

  @override
  String get syncDeviceKeyDetails => 'Detalhs de seguretat';

  @override
  String get syncConnectionProblem =>
      'Impossible de sincronizar pel moment. En tornant ensajar automaticament.';

  @override
  String get syncCopyComplete =>
      'Còpia completa de vòstre jornal e de vòstres fichièrs multimèdias';

  @override
  String get syncCopyPartial => 'Qualques mèdias mancan encara';

  @override
  String get syncCopyOlder =>
      'Las novèlas modificacions son a l\'espèra de sincronizar';

  @override
  String get syncCopyUnavailable =>
      'Los detalhs de còpia son pas disponibles. Tornatz ensajar mai tard.';

  @override
  String get syncCopyLastKnown =>
      'D\'autres periferics mòstran lor darrièra còpia confirmada. Los periferics fòra linha pòdon pas èsser verificats ara.';

  @override
  String get syncCopyTemporary =>
      'Cache temporari. Gardatz los originals sus vòstres periferics.';

  @override
  String get syncCopyStorage =>
      'Vòstre emmagazinatge de sincronizacion. Los telecargaments de mèdias completats son listats dins los diagnostics.';

  @override
  String syncCopyChecked(String time) {
    return 'Darrièr confirmat $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Transferiment de donadas restants aqueste mes : $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Començatz aicí';

  @override
  String get onboardConnect => 'Connectar-se a un periferic existent';

  @override
  String get onboardFailed =>
      'La configuracion a pas pogut èsser completada. Vòstre jornal es segur; ensajatz de nòu.';

  @override
  String get tutorialTitle => 'Cossí utilizar lo jornal';

  @override
  String get tutorialWriteTitle => 'Escrivètz vòstre primièr jornal';

  @override
  String get tutorialWriteText =>
      'Picatz sus + per escriure una entrada de jornal. Apondètz un títol facultatiu, causissètz la data del jornal, e picatz la marca de verificacion per enregistrar. Podètz tornar modificar vòstre jornal a quin moment que siá.';

  @override
  String get tutorialMediaTitle =>
      'Ajustar de fòtos, d\'àudio o d\'escritura manuscrita';

  @override
  String get tutorialMediaText =>
      'Utilizatz + dins l\'editor del jornal per jónher de fòtos, de vidèos, o un enregistrament vocal, o per dobrir la tela de l\'escritura manuscrita. Aquestes pièces juntas son enregistrats amb l\'entrada del jornal.';

  @override
  String get tutorialReviewTitle => 'Trobar un jorn de nòu';

  @override
  String get tutorialReviewText =>
      'Consultatz vòstre jornal o calendièr, cercatz vòstras escrituras, e organizatz las entradas amb d\'etiquetas. Las paginas Media e Atlas vos permeton de trobar d\'entradas passadas per fòto o emplaçament.';

  @override
  String get tutorialSyncTitle => 'Utilizar mai d\'un periferic';

  @override
  String get tutorialSyncText =>
      'Dins Paramètres → Donadas e emmagazinatge → Sincronizacion, connectatz-vos a un periferic existent e confirmatz l\'autorizacion sus aquel periferic. Los dos periferics pòdon contunhar d\'utilizar lo jornal. Lo tèxte del jornal se sincroniza d\'en primièr. Los fichièrs mèdias se sincronizan après quand la connexion ret e lo quòta de transferiment de donadas restant o permeton.';

  @override
  String get tutorialPrivacyTitle => 'Gardatz vòstre jornal segur';

  @override
  String get tutorialPrivacyText =>
      'Las entradas del jornal demòran sus aqueste periferic levat se las activatz la sincronizacion o la partatge o las exportacion. La sincronizacion es chifrada de punta a punta. Dins los Paramètres podètz tanben definir un senhal d\'aplicacion, crear de còpias de seguretat e tornar dobrir aqueste tutorial.';

  @override
  String get editorDiaryDay => 'Jorn del jornal';

  @override
  String get editorDiaryDayPicker =>
      'Jorn del jornal · creacion sens cambiament';

  @override
  String get editorDiaryDayHint =>
      'Lo jorn al qual aparten aquesta nòta. Lo cambiar modifica pas sa data e ora de creacion.';

  @override
  String get hiddenDiaryTitle => 'Entradas amagadas';

  @override
  String get hiddenDiaryHide => 'Amagar l’entrada';

  @override
  String get hiddenDiaryShow => 'Mostrar l’entrada';

  @override
  String get hiddenDiaryEmpty => 'Cap d’entrada amagada';

  @override
  String get hiddenDiaryUnlock => 'Desverrolhar las entradas amagadas';

  @override
  String get hiddenDiaryAuthHint =>
      'Utilizatz lo verrolhatge de l’aplicacion o de l’ecran de l’aparelh.';

  @override
  String get moodClear => 'Escafar l’umor';

  @override
  String get scrollToTop => 'Tornar amont';

  @override
  String get feedbackTitle => 'Comentaris';

  @override
  String get feedbackHint => 'Descrivètz un problèma o una suggestion';

  @override
  String get feedbackGithub => 'Problèma GitHub';

  @override
  String get feedbackEmail => 'Mandar un corrièl';

  @override
  String get feedbackCopy => 'Copiar lo tèxte';

  @override
  String get feedbackLaunchFailed =>
      'Impossible de dobrir l’aplicacion. Copiatz lo tèxte e utilizatz lo corrièl çai jos.';

  @override
  String get feedbackCopied => 'Comentaris copiats';
}
