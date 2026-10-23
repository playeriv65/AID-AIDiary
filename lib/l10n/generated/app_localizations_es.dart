// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => 'Color del tema';

  @override
  String get themeColorHint => 'Elige un color para esta paleta.';

  @override
  String get themeColorBlue => 'azul cielo';

  @override
  String get themeColorGreen => 'Verde bosque';

  @override
  String get themeColorBrown => 'café caliente';

  @override
  String get themeColorPurple => 'lavanda';

  @override
  String get themeColorRose => 'rosa polvorienta';

  @override
  String get themeColorAmber => 'ámbar';

  @override
  String get themeColorPreview => 'un poco cada dia';

  @override
  String get themeTintBackgroundTitle => 'Teñir fondos con color del tema.';

  @override
  String get themeTintBackgroundHint =>
      'Desactívelo para fondos grises neutros; Los botones mantienen el color elegido.';

  @override
  String get dailyReminderTitle => '¡Anota hoy!';

  @override
  String get dailyReminderDescription => 'Anota tu entrada diaria…';

  @override
  String get actionTakePhoto => 'Tomar foto';

  @override
  String get flashbacksTitle => 'Recuerdos';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Excluir dias malos';

  @override
  String get flashbackGoodDay => 'Un Buen Día';

  @override
  String get flashbackRandomDay => 'Un Día Aleatorio';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count semanas',
      one: 'Hace $count semana',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count meses',
      one: 'Hace $count mes',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count años',
      one: 'Hace $count año',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'En este día';

  @override
  String get searchLogsHint => 'Buscar registros…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count registros',
      one: '$count registro',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '$count día',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count palabras',
      one: '$count palabra',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'No hay registros…';

  @override
  String get noResults => 'Sin resultados…';

  @override
  String get sortOrderAscendingTitle => 'Ascendente';

  @override
  String get sortOrderDescendingTitle => 'Descendente';

  @override
  String get pageStatisticsTitle => 'Estadísticas';

  @override
  String get statisticsNotEnoughData => 'No hay suficientes datos…';

  @override
  String get statisticsRangeOneMonth => '1 mes';

  @override
  String get statisticsRangeSixMonths => '6 meses';

  @override
  String get statisticsRangeOneYear => '1 año';

  @override
  String get statisticsRangeAllTime => 'Todo el tiempo';

  @override
  String chartSummaryTitle(Object tag) {
    return 'Resumen de $tag';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag por día';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag a lo largo del tiempo';
  }

  @override
  String get chartGroupingLabel => 'Agrupar por';

  @override
  String get chartGroupingDay => 'Día';

  @override
  String get chartGroupingWeek => 'Semana';

  @override
  String get chartGroupingMonth => 'Mes';

  @override
  String get chartGroupingYear => 'Año';

  @override
  String get chartSmoothingLabel => 'Suavizado';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Racha actual $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Racha más larga $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Días estupendos $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Días desde un día malo $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'No se puede acceder al almacenamiento externo';

  @override
  String get errorExternalStorageAccessDescription =>
      'Si estás usando almacenamiento en red, asegúrate de que el servicio esté en línea y de que tengas acceso a la red.\n\nDe lo contrario, la aplicación puede haber perdido los permisos para la carpeta externa. Ve a la configuración y vuelve a seleccionar la carpeta externa para otorgar acceso.\n\nAdvertencia: Los cambios no se sincronizarán hasta que restaures el acceso a la ubicación de almacenamiento externo.';

  @override
  String get errorExternalStorageAccessContinue =>
      'Continuar con la base de datos local';

  @override
  String get lastModified => 'Modificado';

  @override
  String get writeSomethingHint => 'Escribe algo…';

  @override
  String get titleHint => 'Título…';

  @override
  String get deleteLogTitle => 'Eliminar entrada';

  @override
  String get deleteLogDescription => '¿Quieres eliminar esta entrada?';

  @override
  String get deletePhotoTitle => 'Eliminar foto';

  @override
  String get deletePhotoDescription => '¿Quieres eliminar esta foto?';

  @override
  String get pageSettingsTitle => 'Configuración';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Primer Día de la Semana';

  @override
  String get settingsCalendarSystem => 'Calendario del Sistema';

  @override
  String get calendarSystemGregorian => 'Gregoriano';

  @override
  String get calendarSystemJalali => 'Jalalí';

  @override
  String get settingsUseSystemAccentColor => 'Usar Color de Acento del Sistema';

  @override
  String get settingsCustomAccentColor => 'Color de Acento Personalizado';

  @override
  String get settingsShowFlashbacks => 'Mostrar Recuerdos';

  @override
  String get settingsChangeMoodIcons => 'Cambiar Iconos de Estado de Ánimo';

  @override
  String get moodIconPrompt => 'Introduce un icono';

  @override
  String get settingsHideImages => 'Ocultar imágenes';

  @override
  String get pageCalendarTitle => 'Calendario';

  @override
  String get settingsNotificationsTitle => 'Notificaciones';

  @override
  String get settingsDailyReminderTitle => 'Recordatorio diario';

  @override
  String get settingsOnThisDayDescription => 'Revive recuerdos del pasado';

  @override
  String get settingsDailyReminderDescription => 'Breve recordatorio diario';

  @override
  String get settingsReminderTime => 'Hora del Recordatorio';

  @override
  String get settingsFixedReminderTimeTitle => 'Tiempo de Recordatorio Fijo';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Elija una hora fija para el recordatorio';

  @override
  String get settingsAlwaysSendReminderTitle => 'Siempre enviar recordatorio';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Enviar recordatorio aunque ya se haya hecho un registro del dia';

  @override
  String get settingsCustomizeNotificationTitle =>
      'Personalizar notificaciones';

  @override
  String get settingsTemplatesTitle => 'Plantillas';

  @override
  String get manageTemplates => 'Administrar Plantillas';

  @override
  String get noTemplateTitle => 'Ninguno';

  @override
  String get noTemplatesDescription => 'Aún no se han creado plantillas…';

  @override
  String get templateDefaultTimestampTitle => 'Fecha y hora';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Resumen del día';

  @override
  String get templateDefaultSummaryBody => '### Resumen\n- \n\n### Cita\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Reflexión';

  @override
  String get templateDefaultReflectionBody =>
      '### ¿Qué te gustó hoy?\n- \n\n### ¿Por qué estás agradecido/a?\n- \n\n### ¿Qué estás esperando?\n- ';

  @override
  String get settingsTagsTitle => 'Etiquetas';

  @override
  String get manageTags => 'Administrar etiquetas';

  @override
  String get tagTypeLabelTitle => 'Etiqueta';

  @override
  String get tagTypeTrackerTitle => 'Monitor';

  @override
  String get nameHint => 'Nombre';

  @override
  String get tagColorLabel => 'Color';

  @override
  String get iconPickerTitle => 'Elige un icono';

  @override
  String get iconPickerIconsTab => 'Iconos';

  @override
  String get iconPickerCustomTab => 'Personalizado';

  @override
  String get iconPickerSearchHint => 'Busca iconos…';

  @override
  String get colorPickerTitle => 'Elige color';

  @override
  String get colorPickerPaletteTab => 'Colores';

  @override
  String get iconGroupMoodPeople => 'Estados de ánimo y personas';

  @override
  String get iconGroupHealth => 'Salud';

  @override
  String get iconGroupWorkFinance => 'Trabajo y finanzas';

  @override
  String get iconGroupHabitsGoals => 'Hábitos y metas';

  @override
  String get iconGroupNature => 'Naturaleza';

  @override
  String get iconGroupFoodDrink => 'Comidas y bebidas';

  @override
  String get iconGroupHome => 'Hogar';

  @override
  String get iconGroupTravel => 'Viajes';

  @override
  String get iconGroupSymbols => 'Símbolos';

  @override
  String get tagCategoryLabel => 'Categoría';

  @override
  String get tagLabel => 'Etiqueta';

  @override
  String get tagCategoryUncategorized => 'Sin categoría';

  @override
  String get newCategoryTitle => 'Nueva categoría';

  @override
  String get shareButtonLabel => 'Compartir';

  @override
  String get importErrorDescription => '¡No se pudo importar el archivo!';

  @override
  String get exportErrorDescription => '¡No se pudo exportar el archivo!';

  @override
  String get deleteTitle => 'Borrar';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Se ha usado en $count registros.',
      one: ' Se ha usado en 1 registro.',
      zero: '',
    );
    return '¿Borrar \"$name\"?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Sus $count etiquetas también serán borradas.',
      one: ' Su etiqueta también será borrada.',
      zero: '',
    );
    return '¿Borrar \"$name\"?$_temp0';
  }

  @override
  String get tagNameExists => 'Ya existe una etiqueta con este nombre.';

  @override
  String get categoryNameExists => 'Ya existe una categoría con este nombre.';

  @override
  String deleteTemplateMessage(Object name) {
    return '¿Borrar \"$name\"?';
  }

  @override
  String get addTagsTitle => 'Añadir etiquetas';

  @override
  String get addTagsSearchHint => 'Buscar etiquetas…';

  @override
  String get tagPickerSortManualLabel => 'Orden manual';

  @override
  String get tagPickerSortUsageLabel => 'Ordenar por uso';

  @override
  String get tagFavoriteName => 'Favorito';

  @override
  String get tagEnergyName => 'Energía';

  @override
  String get tagCategoryActivitiesName => 'Actividades';

  @override
  String get tagExerciseName => 'Ejercicio';

  @override
  String get tagSocializingName => 'Socializando';

  @override
  String get tagHobbyName => 'Aficiones';

  @override
  String get tagEntertainmentName => 'Entretenimiento';

  @override
  String get tagDiningName => 'Cenando';

  @override
  String get tagChoresName => 'Tareas';

  @override
  String get tagCategoryEmotionsName => 'Emociones';

  @override
  String get tagExcitedName => 'Emocionado/a';

  @override
  String get tagGratefulName => 'Agradecido/a';

  @override
  String get tagCalmName => 'En calma';

  @override
  String get tagTiredName => 'Cansado/a';

  @override
  String get tagAnxiousName => 'Nervioso/a';

  @override
  String get tagAnnoyedName => 'Molesto/a';

  @override
  String get settingsStorageTitle => 'Almacenamiento';

  @override
  String get settingsImageQuality => 'Calidad de Imagen';

  @override
  String get imageQualityHigh => 'Alta';

  @override
  String get imageQualityMedium => 'Media';

  @override
  String get imageQualityLow => 'Baja';

  @override
  String get imageQualityNoCompression => 'Sin Compresión';

  @override
  String get settingsLogFolder => 'Carpeta de entradas';

  @override
  String get settingsImageFolder => 'Carpeta de Imágenes';

  @override
  String get warningTitle => 'Advertencia';

  @override
  String get logFolderWarningDescription =>
      'Si la carpeta seleccionada ya contiene un archivo \'aid_diary.db\', se usará para sobrescribir tus entradas existentes!';

  @override
  String get errorTitle => 'Error';

  @override
  String get logFolderErrorDescription =>
      '¡No se pudo cambiar la carpeta de registro!';

  @override
  String get imageFolderErrorDescription =>
      '¡No se pudo cambiar la carpeta de imágenes!';

  @override
  String get backupErrorDescription => '¡Error al intentar crear un respaldo!';

  @override
  String get restoreErrorDescription => '¡Error en restaurar respaldo!';

  @override
  String get settingsBackupRestoreTitle => 'Respaldo y restauración';

  @override
  String get settingsBackup => 'Respaldo';

  @override
  String get settingsRestore => 'Restauración';

  @override
  String get settingsRestorePromptDescription =>
      '¡Restaurar un respaldo sobreescribirá tus datos existentes!';

  @override
  String get settingsBackupPasswordProtect =>
      'Proteger respaldos con contraseña';

  @override
  String get backupEncryptedTitle => 'Respaldo encriptado';

  @override
  String get backupEncryptedContent =>
      'Este respaldo está protegido por una contraseña.';

  @override
  String get settingsAutoBackup => 'Respaldos automáticos';

  @override
  String get settingsAutoBackupLocation => 'Ubicación del respaldo';

  @override
  String get settingsAutoBackupInterval => 'Frecuencia de los respaldos';

  @override
  String get settingsAutoBackupIntervalDaily => 'Diario';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Semanal';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Mensual';

  @override
  String get settingsAutoBackupMaxCount => 'Respaldos que conservar';

  @override
  String get settingsAutoBackupRequireCharging => 'Solo durante la carga';

  @override
  String settingsBackupLast(Object time) {
    return 'Último respaldo $time';
  }

  @override
  String get settingsBackupNever => 'Nunca se ha respaldado';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Próximo respaldo $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'Todo';

  @override
  String get autoBackupFailedTitle => 'Respaldo fallido';

  @override
  String tranferStatus(Object percent) {
    return 'Transfiriendo… $percent %';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Creando respaldo... $percent %';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Restaurando respaldo… $percent %';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return 'Cifrando respaldo… $percent %';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Descifrando respaldo… $percent %';
  }

  @override
  String get cleanUpStatus => 'Limpiando…';

  @override
  String get settingsExportToAnotherFormat => 'Exportar a otro formato';

  @override
  String get settingsExportFormatDescription =>
      'Esto no debe usarse como respaldo.';

  @override
  String get settingsImportFromAnotherApp => 'Importar de otra aplicación';

  @override
  String get logFormatTitle => 'Elija Formato';

  @override
  String get logFormatDescription =>
      'Otros formatos de aplicaciones pueden no soportar todas las caracteristicas. Por favor reporta cualquier problema, ya que los formatos de terceros pueden cambiar con el tiempo. Esto no afectara a los registros ya existentes';

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
  String get settingsDeleteAllLogsTitle => 'Eliminar Todos los Registros';

  @override
  String get settingsDeleteAllLogsDescription =>
      '¿Quieres eliminar todos tus registros?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Escribe \'$prompt\'para confirmar. ¡Esto no se puede desahacer!';
  }

  @override
  String get settingsAppLanguageTitle => 'Lenguaje de aplicacion';

  @override
  String get settingsSecurityTitle => 'Seguridad';

  @override
  String get settingsSecurityRequirePassword => 'Requiere Contraseña';

  @override
  String get settingsSecurityEnterPassword => 'Introduzca la contraseña';

  @override
  String get settingsSecuritySetPassword => 'Establecer contraseña';

  @override
  String get settingsSecurityChangePassword => 'Cambiar contraseña';

  @override
  String get settingsSecurityPassword => 'Contraseña';

  @override
  String get settingsSecurityConfirmPassword => 'Confirmar contraseña';

  @override
  String get settingsSecurityOldPassword => 'Contraseña antigua';

  @override
  String get settingsSecurityIncorrectPassword => 'Contraseña incorrecta';

  @override
  String get settingsSecurityPasswordsDoNotMatch =>
      'Las contraseñas no coinciden';

  @override
  String get requiredPrompt => 'Necesario';

  @override
  String get settingsSecurityBiometricUnlock => 'Desbloqueo biometrico';

  @override
  String get unlockAppPrompt => 'Desbloquea la aplicacion';

  @override
  String get settingsAboutTitle => 'Acerca de';

  @override
  String get settingsVersion => 'Versión';

  @override
  String get settingsLicense => 'Licencia';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsOpenSourceLicenses => 'Licencias de código abierto';

  @override
  String get tagMoodTitle => 'Ánimo';

  @override
  String get selectTagTitle => 'Selecciona etiqueta';

  @override
  String get labelPresentLabel => 'Presente';

  @override
  String get labelAbsentLabel => 'Ausente';

  @override
  String get labelCoverageLabel => 'Cobertura';

  @override
  String chartDistributionTitle(Object tag) {
    return 'Distribución de $tag';
  }

  @override
  String get shareAddToLogPickerTitle => 'Elija una entrada del diario';

  @override
  String get adaptiveEmptyDay => 'Aún no hay entradas para este día.';

  @override
  String get adaptiveNewEntry => 'Escribe una entrada';

  @override
  String get pageJournalTitle => 'Diario';

  @override
  String get coachPrompt1 => '¿Qué te hizo sonreír hoy?';

  @override
  String get coachPrompt2 => '¿Qué es lo que aprendiste hoy?';

  @override
  String get coachPrompt3 => '¿Con quién hablaste hoy y cómo te sentiste?';

  @override
  String get coachPrompt4 => '¿Por qué estás agradecido en este momento?';

  @override
  String get coachPrompt5 => '¿Qué tomó la mayor parte de tu energía hoy?';

  @override
  String get coachPrompt6 =>
      'Describe un pequeño momento que quieras recordar.';

  @override
  String get coachPrompt7 => '¿Qué haría que mañana fuera un buen día?';

  @override
  String get coachPrompt8 => '¿Qué ha estado en tu mente últimamente?';

  @override
  String get coachPrompt9 => '¿Qué hiciste hoy solo para ti?';

  @override
  String get coachPrompt10 => 'Si hoy tuviera un título, ¿cuál sería?';

  @override
  String get pageMediaTitle => 'Medios';

  @override
  String get pageAtlasTitle => 'Atlas';

  @override
  String get pageCoachTitle => 'Entrenador';

  @override
  String get noEntrySelected => 'No se seleccionó ninguna entrada.';

  @override
  String get entryShare => 'Compartir';

  @override
  String get entryFavorite => 'estrella';

  @override
  String get entryEdit => 'Editar';

  @override
  String get entryPrevious => 'Entrada anterior';

  @override
  String get entryNext => 'Próxima entrada';

  @override
  String get journalStories => 'Historias';

  @override
  String get journalEntries => 'Entradas';

  @override
  String get journalEmptyHint =>
      'Comience su diario agregando una nueva entrada.';

  @override
  String get storyToday => 'hoy';

  @override
  String get storyThrowback => 'retroceso';

  @override
  String get storyNoThrowback => 'No hay retroceso hoy';

  @override
  String get mediaFiles => 'Archivos multimedia';

  @override
  String get mediaEmpty => 'Aún no hay fotos.';

  @override
  String get mediaEmptyHint =>
      'Las fotos adjuntas a las entradas se mostrarán aquí.';

  @override
  String get atlasEmpty => 'No hay entradas con una ubicación.';

  @override
  String get atlasEmptyHint =>
      'Las entradas con una ubicación se mostrarán aquí.';

  @override
  String get atlasShowAll => 'Mostrar todas las entradas';

  @override
  String get atlasMyLocation => 'mi ubicación';

  @override
  String get coachAll => 'Todos';

  @override
  String get coachPrograms => 'Programas';

  @override
  String get coachTemplates => 'Plantillas';

  @override
  String get coachKindProgram => 'Programa';

  @override
  String get coachKindTemplate => 'Plantilla';

  @override
  String get coachNoTemplates => 'Sin programas ni plantillas.';

  @override
  String get coachUseTemplate => 'Escribe con esta plantilla';

  @override
  String get coachProgramEverydayTitle => 'Momentos cotidianos';

  @override
  String get coachProgramEverydayDescription =>
      'Cinco preguntas cortas, una al día. Cada uno toma uno o dos minutos y te ayuda a ver qué hizo tuyo el día. Una forma suave de desarrollar el hábito de escribir un poco todos los días.';

  @override
  String get coachProgramReflectTitle => 'mirando hacia adentro';

  @override
  String get coachProgramReflectDescription =>
      'Una pregunta más profunda por semana, durante cinco semanas. Tómate tu tiempo con cada uno: cómo te has sentido, qué te desgasta, qué estás agradecido.';

  @override
  String get searchFilters => 'Filtros';

  @override
  String get searchFilterTags => 'Etiquetas';

  @override
  String get searchFilterStarred => 'Destacado';

  @override
  String get searchHint => 'Escribe para buscar o elige un filtro.';

  @override
  String get locationTitle => 'Ubicación';

  @override
  String get locationName => 'Nombre del lugar';

  @override
  String get locationRemove => 'Quitar';

  @override
  String get locationServiceDisabled =>
      'Los servicios de ubicación están desactivados.';

  @override
  String get locationPermissionDenied => 'Se denegó el permiso de ubicación.';

  @override
  String get locationUnavailable => 'No se pudo obtener la ubicación actual.';

  @override
  String get calendarJumpToToday => 'Saltar a hoy';

  @override
  String get editorStartWriting => 'Empiece a escribir o elija un ';

  @override
  String get editorTemplateLink => 'Plantilla';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Elige una plantilla';

  @override
  String get templateFeatured => 'Plantillas destacadas';

  @override
  String get templateMine => 'Mis plantillas';

  @override
  String get templateDailyName => 'Revisión diaria';

  @override
  String get templateDailyDescription =>
      'Qué pasó, cómo se sintió y qué viene después.';

  @override
  String get templateDailyText =>
      '## ¿Qué pasó hoy?\n\n\n## Cómo me sentí\n\n\n## Tres cosas por las que estoy agradecido\n1. \n2. \n3. \n\n## mañana\n';

  @override
  String get templateTravelName => 'Entrada del diario de viaje';

  @override
  String get templateTravelDescription =>
      'Lugares, momentos y comida del camino.';

  @override
  String get templateTravelText =>
      '## A donde fui\n\n\n## El momento que más recuerdo\n\n\n## Lo que comí\n\n\n## Planes para mañana\n';

  @override
  String get templateReadingName => 'notas de lectura';

  @override
  String get templateReadingDescription =>
      'Citas y pensamientos de lo que lees.';

  @override
  String get templateReadingText =>
      '## Libro\n\n\n## Donde estoy\n\n\n## Cotizaciones\n> \n\n## Mis pensamientos\n';

  @override
  String get templateWeeklyName => 'revisión semanal';

  @override
  String get templateWeeklyDescription =>
      'Aspectos destacados, luchas y enfoque de la próxima semana.';

  @override
  String get templateWeeklyText =>
      '## Destacados\n\n\n## ¿Qué fue difícil?\n\n\n## Lo que aprendí\n\n\n## Enfoque para la próxima semana\n';

  @override
  String get entryDuplicate => 'Duplicar';

  @override
  String get entryDuplicated => 'Entrada duplicada';

  @override
  String get entrySaveAsTemplate => 'Guardar como plantilla';

  @override
  String get entrySavedAsTemplate => 'Guardado como plantilla';

  @override
  String get storyStatistics => 'Estadísticas';

  @override
  String get storyMoodChart => 'gráfico de humor';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return 'Entradas $entries · Días $days';
  }

  @override
  String get storyThisYear => 'este año';

  @override
  String get storyLastYear => 'el año pasado';

  @override
  String get storyTapToOpen => 'Toca un día para abrirlo';

  @override
  String get settingsGeneralTitle => 'generales';

  @override
  String get settingsDataTitle => 'Datos y almacenamiento';

  @override
  String get settingsStoriesTitle => 'Historias';

  @override
  String get settingsHelpTitle => 'Ayuda y acerca de';

  @override
  String get weatherTitle => 'El tiempo';

  @override
  String get weatherClear => 'Borrar';

  @override
  String get weatherPartlyCloudy => 'Parcialmente nublado';

  @override
  String get weatherCloudy => 'Nublado';

  @override
  String get weatherFog => 'niebla';

  @override
  String get weatherDrizzle => 'llovizna';

  @override
  String get weatherRain => 'Lluvia';

  @override
  String get weatherSnow => 'nieve';

  @override
  String get weatherStorm => 'Tormenta';

  @override
  String get weatherFetch => 'Obtener el clima para esta entrada';

  @override
  String get weatherNeedsLocation =>
      'Primero agregue una ubicación con coordenadas.';

  @override
  String get weatherUnavailable =>
      'El clima no está disponible para este lugar y hora.';

  @override
  String get weatherRemove => 'Quitar el clima';

  @override
  String get activityTitle => 'Actividad';

  @override
  String get activityStill => 'Aún así';

  @override
  String get activityWalking => 'Caminando';

  @override
  String get activityRunning => 'corriendo';

  @override
  String get activityCycling => 'Ciclismo';

  @override
  String get activityVehicle => 'en un vehículo';

  @override
  String get activityFlying => 'Volando';

  @override
  String get activityExercise => 'ejercicio';

  @override
  String get activityDetect => 'Detectar actividad actual';

  @override
  String get activityDetectFailed => 'No se pudo detectar una actividad.';

  @override
  String get activityRemove => 'Eliminar actividad';

  @override
  String get settingsAutoAddTitle => 'Agregar automáticamente';

  @override
  String get settingsAutoAddLocation => 'Ubicación';

  @override
  String get settingsAutoAddWeather => 'El tiempo';

  @override
  String get settingsAutoAddHint =>
      'Las nuevas entradas se completan cuando se crean.';

  @override
  String get settingsTemperatureUnit => 'Unidad de temperatura';

  @override
  String get settingsCelsius => 'Celsius (°C)';

  @override
  String get settingsFahrenheit => 'Fahrenheit (°F)';

  @override
  String get moodGreat => 'Genial';

  @override
  String get moodGood => 'bueno';

  @override
  String get moodOkay => 'Está bien';

  @override
  String get moodBad => 'malo';

  @override
  String get moodAwful => 'horrible';

  @override
  String get locationSearchHint => 'buscar un lugar';

  @override
  String get locationSearchEmpty => 'No se encontraron lugares';

  @override
  String get settingsWallpaper => 'Fondo de pantalla';

  @override
  String get wallpaperNone => 'Ninguno';

  @override
  String get wallpaperDots => 'Puntos';

  @override
  String get wallpaperGrid => 'Cuadrícula';

  @override
  String get wallpaperLines => 'Líneas';

  @override
  String get wallpaperPhoto => 'Foto…';

  @override
  String get settingsFontFamily => 'fuente';

  @override
  String get fontSystem => 'Sistema';

  @override
  String get fontSerif => 'Serifa';

  @override
  String get fontMono => 'monoespacio';

  @override
  String get settingsFontSize => 'Tamaño de fuente';

  @override
  String get fontSizeSmall => 'pequeño';

  @override
  String get fontSizeMedium => 'Medio';

  @override
  String get fontSizeLarge => 'Grande';

  @override
  String get fontSizeExtraLarge => 'Extra grande';

  @override
  String get settingsLineSpacing => 'Interlineado';

  @override
  String get lineSpacingCompact => 'Compacto';

  @override
  String get lineSpacingNormal => 'normales';

  @override
  String get lineSpacingRelaxed => 'Relajado';

  @override
  String get moodAssociationsTitle => '¿Qué me hace sentir…?';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching de entradas $total';
  }

  @override
  String get videoRecord => 'grabar un vídeo';

  @override
  String get videoChoose => 'Elige un vídeo';

  @override
  String get audioRecordTitle => 'Grabar una nota de voz';

  @override
  String get audioChoose => 'Elige un archivo de audio';

  @override
  String get audioStart => 'Registro';

  @override
  String get audioStop => 'Detener y guardar';

  @override
  String get audioPermissionDenied =>
      'El acceso al micrófono está desactivado. Permitirlo en la configuración del sistema.';

  @override
  String get mediaTooLarge => 'Este vídeo es demasiado grande para adjuntarlo.';

  @override
  String get mediaUnavailable =>
      'Este archivo adjunto no está disponible en este dispositivo.';

  @override
  String get widgetDone => 'La entrada de hoy está escrita.';

  @override
  String get widgetPending => '¿Cómo estuvo tu día?';

  @override
  String get widgetWrite => 'escribir';

  @override
  String get insertChecklist => 'Lista de verificación';

  @override
  String get insertNumberedList => 'lista numerada';

  @override
  String get insertTable => 'mesa';

  @override
  String get insertDivider => 'Divisor';

  @override
  String get insertCodeBlock => 'bloque de código';

  @override
  String get journalSortTitle => 'Ordenar entradas';

  @override
  String get journalSortUpdated => 'Última actualización';

  @override
  String get settingsTimeFormat => 'Formato de hora';

  @override
  String get settingsDayStart =>
      'Las nuevas entradas cuentan desde el día anterior hasta';

  @override
  String get settingsDayAskUntil => 'Luego pregunta hasta qué día';

  @override
  String get settingsDayStartMidnight => 'Apagado';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Cada entrada mantiene el día al que pertenece junto a la hora en que fue escrita, y puedes cambiar ese día en el editor en cualquier momento. Estas horas solo eligen el día para las nuevas entradas, por lo que al cambiarlas no se mueve ninguna entrada existente.';

  @override
  String get lateNightBadge =>
      'Escrito a altas horas de la noche, contado para el día anterior.';

  @override
  String editorDayAsk(String time) {
    return 'Escrito en $time. ¿Para qué día es?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (ayer)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (hoy)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'Escrito $when';
  }

  @override
  String get timeFormat12 => '12 horas';

  @override
  String get timeFormat24 => '24 horas';

  @override
  String get settingsReminderDays => 'Recuérdame';

  @override
  String get locationRecent => 'Lugares recientes';

  @override
  String get shareImage => 'Compartir imagen';

  @override
  String get shareSaveImage => 'Guardar imagen';

  @override
  String get shareSaved => 'Imagen guardada';

  @override
  String get deletedTitle => 'Eliminado recientemente';

  @override
  String get deletedNone => 'No se ha eliminado nada recientemente';

  @override
  String deletedHint(int days) {
    return 'Las entradas eliminadas permanecen aquí durante $days días y luego se borran.';
  }

  @override
  String deletedDaysLeft(int days) {
    return 'Quedan días $days';
  }

  @override
  String get deletedRestore => 'Restaurar';

  @override
  String get deletedDeleteForever => 'Eliminar para siempre';

  @override
  String get deletedDeleteForeverDescription =>
      'La entrada y sus archivos adjuntos se borran. Esto no se puede deshacer.';

  @override
  String get deletedEmpty => 'vacio';

  @override
  String get deletedEmptyDescription =>
      '¿Borrar todas las entradas en Eliminado recientemente? Esto no se puede deshacer.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'paseo aleatorio';

  @override
  String get randomSubtitle => 'Abrir una entrada anterior';

  @override
  String get randomNext => 'otro';

  @override
  String get randomAll => 'Todos';

  @override
  String get randomWithPhotos => 'Con fotos';

  @override
  String get randomGoodDays => 'buenos dias';

  @override
  String get randomEmpty => 'No hay entradas para elegir';

  @override
  String get reviewWeekTitle => 'esta semana';

  @override
  String get reviewWeekSubtitle => 'Tu semana hasta ahora';

  @override
  String get reviewYearTitle => 'este año';

  @override
  String get reviewEmpty => 'nada escrito aun';

  @override
  String get reviewEntries => 'Entradas';

  @override
  String get reviewDaysWritten => 'dias escritos';

  @override
  String get reviewWords => 'palabras';

  @override
  String get reviewPhotos => 'Fotos';

  @override
  String get reviewLongestRun => 'La racha de días más larga';

  @override
  String get reviewAverageMood => 'Estado de ánimo promedio';

  @override
  String get reviewFavorites => 'Más a menudo';

  @override
  String get reviewByMonth => 'Por mes';

  @override
  String get reviewHighlight => 'Resaltar';

  @override
  String get yearInPixels => 'Año en píxeles';

  @override
  String get capsuleSeal => 'Sello como cápsula del tiempo';

  @override
  String get capsuleTitle => 'Cápsula del tiempo';

  @override
  String capsuleOpensOn(Object date) {
    return 'Se abre en $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Escrito en $date';
  }

  @override
  String get capsuleOpenEarly => 'Abierto temprano';

  @override
  String get capsuleOpenEarlyDescription =>
      'La cápsula se abre ahora y permanece abierta.';

  @override
  String get capsuleOpened => 'Cápsula del tiempo abierta';

  @override
  String get templateMorningName => 'paginas matutinas';

  @override
  String get templateMorningDescription => 'Configura el día en tres minutos';

  @override
  String get templateMorningText =>
      '## Tres cosas que quiero hacer bien hoy\n1. \n2. \n3. \n\n## Algo que espero con ansias\n\n## Una nota para mí\n';

  @override
  String get templateEveningName => 'Revisión nocturna';

  @override
  String get templateEveningDescription =>
      'Cierra el día con lo que te salió bien.';

  @override
  String get templateEveningText =>
      '## Tres cosas buenas hoy\n1. \n2. \n3. \n\n## Lo que aprendí\n\n## ¿Qué podría ir mejor mañana?\n';

  @override
  String get routineMorning => 'Buenos dias';

  @override
  String get routineEvening => 'Revisión nocturna';

  @override
  String get settingsRoutinePrompts => 'Indicaciones matutinas y vespertinas.';

  @override
  String get settingsRoutinePromptsHint =>
      'Sugerir la plantilla de mañana o de tarde en Stories';

  @override
  String get checkInTitle => 'Registro rápido';

  @override
  String get checkInSubtitle => 'Estado de ánimo en dos toques';

  @override
  String get checkInMood => '¿Cómo te sientes?';

  @override
  String get checkInActivity => '¿Qué estás haciendo?';

  @override
  String get checkInNote => 'Una línea al respecto (opcional)';

  @override
  String get checkInSave => 'Guardar';

  @override
  String editorWordCount(int words, int characters) {
    return 'Palabras $words · Caracteres $characters';
  }

  @override
  String get coachProgramEverydayTagline =>
      'Note las pequeñas cosas en un día.';

  @override
  String get coachProgramReflectTagline =>
      'Baja la velocidad y escúchate a ti mismo.';

  @override
  String get coachDuration => 'Duración';

  @override
  String get coachInterval => 'Intervalo';

  @override
  String get coachDifficulty => 'dificultad';

  @override
  String get coachIntervalDaily => 'Diariamente';

  @override
  String get coachIntervalWeekly => 'Semanal';

  @override
  String get coachDifficultyBeginner => 'principiante';

  @override
  String get coachDifficultyIntermediate => 'Intermedio';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '$count dia',
      many: '$count días',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count semanas',
      one: '$count semana',
      many: '$count semanas',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'Día $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Semana $n';
  }

  @override
  String get coachEnroll => 'Inscribirse';

  @override
  String get coachEndProgram => 'Fin del programa';

  @override
  String get coachAuthor => 'Autor';

  @override
  String get coachAuthorBio => 'Indicaciones escritas para esta aplicación.';

  @override
  String get coachEnrolledTip =>
      '¡Todo listo! Tus preguntas aparecerán en Historias.';

  @override
  String get coachGoToStories => 'Ir a Historias';

  @override
  String get coachAnswerHint => 'Escribe tu respuesta…';

  @override
  String get storyWrapUp => 'Eso es todo por hoy.';

  @override
  String get storyTapToClose => 'Toca para cerrar';

  @override
  String get coachAnswerDone => 'hecho';

  @override
  String get coachAnswered => 'Respondido, toca para abrir';

  @override
  String get coachAnsweredEarlier => 'Respondido';

  @override
  String get locationLocating => 'Ubicando…';

  @override
  String get locationPickPlace => 'Elige un lugar';

  @override
  String get locationPlacesHint => 'Dirección o nombre del lugar';

  @override
  String get locationCustom => 'Lugar personalizado';

  @override
  String get locationCurrent => 'Ubicación actual';

  @override
  String get locationSaved => 'Lugares guardados';

  @override
  String get locationSearchResults => 'Resultados de la búsqueda';

  @override
  String get locationNearby => 'Lugares cercanos';

  @override
  String get locationRename => 'Cambiar nombre';

  @override
  String get locationSavePlace => 'Guardar lugar';

  @override
  String get locationUnsavePlace => 'Eliminar de lugares guardados';

  @override
  String get shareAs => 'Compartir como…';

  @override
  String get shareAsImage => 'Imagen';

  @override
  String get shareAsZip => 'ZIP con los medios originales.';

  @override
  String get shareAsPlainText => 'Texto sin formato';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Bienvenido a AID Diary';

  @override
  String get onboardWelcomeText =>
      'Comience aquí o conecte este dispositivo a uno que ya use.';

  @override
  String get onboardStart => 'empezar a escribir';

  @override
  String get helpFaq => 'Preguntas frecuentes';

  @override
  String get helpFaq1Q => '¿Dónde se guarda mi diario?';

  @override
  String get helpFaq1A =>
      'Su diario se almacena en este dispositivo. Llega a otros dispositivos o almacenamiento solo cuando habilita la sincronización, lo comparte o lo exporta. La sincronización está cifrada de extremo a extremo.';

  @override
  String get helpFaq2Q =>
      '¿Cómo guardo una copia o la muevo a un nuevo dispositivo?';

  @override
  String get helpFaq2A =>
      'Conéctese a un dispositivo existente en Configuración → Datos y almacenamiento → Sincronizar y confirme la autorización en el dispositivo que tiene su diario. Ambos dispositivos siguen siendo utilizables. También puedes crear una copia de seguridad y restaurarla en otro dispositivo.';

  @override
  String get helpFaq3Q =>
      '¿Puedo incorporar entradas de otras aplicaciones de diario?';

  @override
  String get helpFaq3A =>
      'Sí: en Configuración → Datos y almacenamiento, importe exportaciones de Daylio, Diarium, Diaro, DayBook, My Brain, OneShot y Pixels, o una exportación de JSON.';

  @override
  String get helpFaq4Q => '¿Cómo funcionan los programas de entrenadores?';

  @override
  String get helpFaq4A =>
      'Inscríbete en un programa en la página del Entrenador. Cada día o semana espera una nueva pregunta en Historias; su respuesta se guarda como una entrada.';

  @override
  String get helpFaq5Q => '¿Qué pasa si olvido mi contraseña?';

  @override
  String get helpFaq5A =>
      'El código de acceso no se puede recuperar, así que mantenga una copia de seguridad de su diario.';

  @override
  String get helpPrivacy => 'Privacidad';

  @override
  String get helpPrivacyText =>
      'El contenido del diario y los medios permanecen en este dispositivo a menos que habilites la sincronización cifrada o los compartas o exportes. Los mapas, la búsqueda de lugares y el clima utilizan los servicios configurados y envían la ubicación o la consulta de búsqueda necesaria para esa solicitud, no el texto del diario.';

  @override
  String get photoMetaTitle => '¿Usar los detalles de la foto?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return '¿Contar esta entrada para $date y establecer su lugar en $place, como se registra en la foto?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Cuente esta entrada para $date, ¿cuándo se tomó la foto?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Establezca el lugar de esta entrada en $place, ¿dónde se tomó la foto?';
  }

  @override
  String get photoMetaApply => 'Úsalos';

  @override
  String get quickWriteTitle => 'escritura rapida';

  @override
  String get quickWriteText => 'Toque para iniciar una nueva entrada.';

  @override
  String get settingsQuickWriteTitle => 'Escritura rápida en notificaciones';

  @override
  String get settingsQuickWriteDescription =>
      'Mantener una notificación que abre una nueva entrada.';

  @override
  String get settingsNudgesTitle => 'Empujame después de un tramo tranquilo';

  @override
  String settingsNudgesDescription(int days) {
    return 'Un amable recordatorio cuando no hayas escrito durante días $days.';
  }

  @override
  String get nudgeTitle => 'ha pasado un tiempo';

  @override
  String get nudgeMonday => 'Una nueva semana: ¿qué estás esperando?';

  @override
  String get nudgeTuesday => 'Dos líneas son suficientes. ¿Cómo estás hoy?';

  @override
  String get nudgeWednesday => 'A mitad de semana. ¿Qué destacó hasta ahora?';

  @override
  String get nudgeThursday => '¿Algo pequeño que valga la pena conservar hoy?';

  @override
  String get nudgeFriday =>
      'La semana está terminando. Tenga en cuenta un buen momento.';

  @override
  String get nudgeSaturday =>
      'Un sábado tranquilo es un buen día para escribir.';

  @override
  String get nudgeSunday => 'Eche un vistazo a la semana antes de que termine.';

  @override
  String get photoWidgetEmpty =>
      'Las fotos que agregas a las entradas aparecen aquí.';

  @override
  String get channelReminders => 'Recordatorios';

  @override
  String get channelOnThisDay => 'en este dia';

  @override
  String get channelCoach => 'Indicaciones del entrenador';

  @override
  String get channelNudges => 'Empujes después de días tranquilos';

  @override
  String get channelQuickWrite => 'escritura rapida';

  @override
  String get channelBackup => 'Copias de seguridad';

  @override
  String get formatJsonExport => 'JSON (exportación AID Diary)';

  @override
  String get aboutModifiedNotice =>
      'Una versión modificada de Daily You por Demizo y colaboradores. No es la aplicación oficial Daily You.';

  @override
  String get toolbarPhotos => 'Agregar fotos';

  @override
  String get toolbarMedia => 'Fotos y vídeos';

  @override
  String get mediaFromGallery => 'Elige de la galería';

  @override
  String get mediaFromFiles => 'Elija entre archivos';

  @override
  String get editorLeaveTitle => '¿Guardar esta entrada?';

  @override
  String get editorLeaveDiscard => 'no guardar';

  @override
  String get editorTitleHint => 'Título';

  @override
  String get editorLocating => 'Ubicando…';

  @override
  String get toolbarVideo => 'Vídeo';

  @override
  String get toolbarAudio => 'nota de voz';

  @override
  String get toolbarTags => 'Etiquetas';

  @override
  String get toolbarBulletList => 'Lista con viñetas';

  @override
  String get toolbarHeading => 'rumbo';

  @override
  String get toolbarBold => 'Negrita';

  @override
  String get toolbarItalic => 'cursiva';

  @override
  String get toolbarHighlight => 'Resaltar';

  @override
  String get toolbarStrikethrough => 'Tachado';

  @override
  String get toolbarQuote => 'Cotización';

  @override
  String get toolbarLink => 'Enlace';

  @override
  String get toolbarInsert => 'Insertar';

  @override
  String get toolbarUndo => 'Deshacer';

  @override
  String get toolbarRedo => 'Rehacer';

  @override
  String get toolbarInsertDate => 'Insertar la fecha';

  @override
  String get toolbarInsertTime => 'Insertar la hora';

  @override
  String get settingsSyncTitle => 'Sincronización en la nube';

  @override
  String get syncOffDescription =>
      'Mantenga este diario igual en todos sus dispositivos a través de Google Drive o un servidor WebDAV, como Nextcloud, Synology o Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'Sincronizar con Google Drive';

  @override
  String get syncOrWebDav => 'O un servidor WebDAV';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn => 'Iniciado sesión. Puede volver a AID Diary.';

  @override
  String get syncGoogleSignInAgain =>
      'Google necesita que inicies sesión nuevamente.';

  @override
  String get syncSignInAgain => 'Iniciar sesión nuevamente';

  @override
  String get settingsCommandLineTitle => 'línea de comando';

  @override
  String get commandLineToggle => 'Interfaz de línea de comando';

  @override
  String get commandLineToggleHint =>
      'Permite que el comando de ayuda y otros programas de este dispositivo utilicen los comandos de la aplicación.';

  @override
  String get commandLineAlwaysOn => 'Siempre en desarrollo.';

  @override
  String commandLineListening(int port) {
    return 'Escuchando en el puerto $port';
  }

  @override
  String get commandPaletteTitle => 'Todos los comandos';

  @override
  String get commandPaletteSearch => 'Comandos de búsqueda';

  @override
  String get commandPaletteRun => 'correr';

  @override
  String get commandPaletteConfirm =>
      'Esto no se puede deshacer simplemente. ¿Ejecutarlo?';

  @override
  String syncReceiving(int done, int total) {
    return 'Recibiendo $done de $total…';
  }

  @override
  String syncSending(int done, int total) {
    return 'Enviando $done de $total…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'No se permitió el acceso a Google Drive. Conéctese nuevamente y marque Google Drive en la página de Google.';

  @override
  String get syncEntryUnsynced =>
      'No sincronizado: la última sincronización no se realizó';

  @override
  String get syncUseOfficial => 'Utilice el servidor de sincronización AID';

  @override
  String get syncServer => 'Dirección del servidor';

  @override
  String get syncUsername => 'Nombre de usuario';

  @override
  String get syncPassword => 'Contraseña';

  @override
  String get syncConnect => 'Conectar';

  @override
  String get syncConnecting => 'Conectando…';

  @override
  String get syncSignInFailed =>
      'No se pudo iniciar sesión. Verifique la dirección, el nombre de usuario y la contraseña.';

  @override
  String syncConnectFailed(String error) {
    return 'No se pudo conectar: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Iniciar sincronización';

  @override
  String get syncNewSpaceDescription =>
      'Aquí todavía no hay ningún diario sincronizado. Este diario se cargará, cifrado de extremo a extremo con una clave que permanecerá en sus dispositivos.';

  @override
  String get syncJoinTitle => 'Únase al diario sincronizado';

  @override
  String get syncWrongKey =>
      'Este código de recuperación no abre el diario sincronizado.';

  @override
  String syncLastSynced(String time) {
    return 'Última sincronización $time';
  }

  @override
  String get syncNever => 'Aún no sincronizado';

  @override
  String get syncSyncing => 'Sincronizando…';

  @override
  String syncFailed(String error) {
    return 'La última sincronización falló: $error';
  }

  @override
  String get syncLocked =>
      'El diario sincronizado ahora pertenece a otros dispositivos o se inició de nuevo. Emparéjelo con uno de ellos o use el código de recuperación para seguir sincronizando.';

  @override
  String get syncNow => 'Sincronizar ahora';

  @override
  String get syncUnlock => 'Desbloquear';

  @override
  String get syncEncrypted => 'Cifrado de extremo a extremo';

  @override
  String get syncDisconnect => 'Dejar de sincronizar';

  @override
  String get syncDisconnectDescription =>
      'Este dispositivo deja de sincronizarse. El diario aquí y la copia sincronizada permanecen como están.';

  @override
  String get syncOwnRecoveryPassword =>
      'Usar mi propia contraseña de recuperación';

  @override
  String get syncRecoveryPassword => 'Contraseña de recuperación';

  @override
  String get syncRecoveryPasswordRepeat =>
      'Repita la contraseña de recuperación';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Utilice al menos caracteres $min';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'Las contraseñas difieren';

  @override
  String get syncRecoveryCode => 'Código de recuperación';

  @override
  String get syncRecoveryCodeTitle => 'Guarde su código de recuperación';

  @override
  String get syncRecoveryCodeDescription =>
      'Si pierdes todos tus dispositivos, este código restaura tu diario sincronizado. Guárdelo en un administrador de contraseñas o en papel. Se muestra sólo esta vez.';

  @override
  String get syncRecoveryCodeCopied => 'Código de recuperación copiado';

  @override
  String get syncRecoveryCodeSaved => 'lo he guardado';

  @override
  String get syncJoinNeedsKey =>
      'Este diario sincronizado pertenece a sus otros dispositivos. Emparéjelo con uno de ellos o use el código de recuperación. Las entradas de este dispositivo se agregarán al mismo.';

  @override
  String get syncPairDevice => 'Emparejar con un dispositivo';

  @override
  String get syncUseRecoveryCode => 'Utilice el código de recuperación';

  @override
  String get syncAddDevice => 'Agregar un dispositivo';

  @override
  String get syncChangeRecoveryCode => 'Cambiar el código de recuperación';

  @override
  String get syncChangeRecoveryDescription =>
      'Un nuevo código reemplaza al actual, que deja de funcionar. Tus datos y otros dispositivos permanecen como están.';

  @override
  String get syncNewRandomCode => 'Nuevo código aleatorio';

  @override
  String get syncRecoveryCodeChanged => 'Código de recuperación cambiado';

  @override
  String get syncResetSpace => 'Iniciar de nuevo el diario sincronizado';

  @override
  String get syncResetSpaceDescription =>
      'Solo cuando ningún dispositivo ni ningún código de recuperación lo abre: la copia sincronizada se reemplaza por el diario en este dispositivo, bajo las claves de este dispositivo. Luego, sus otros dispositivos se emparejan nuevamente.';

  @override
  String get syncPairTitle => 'Emparejar dispositivos';

  @override
  String get syncPairShow => 'Mostrar un código';

  @override
  String get syncPairEnter => 'Introduce un código';

  @override
  String get syncPairShowHint =>
      'En su otro dispositivo, abra Emparejar dispositivos, elija Ingresar un código y escríbalo o escanéelo.';

  @override
  String get syncPairEnterHint =>
      'Escribe el código que muestra tu otro dispositivo o escanéalo.';

  @override
  String get syncPairCode => 'código de emparejamiento';

  @override
  String get syncPairScan => 'Escanear';

  @override
  String get syncPairStart => 'par';

  @override
  String get syncPairWaiting => 'Esperando el otro dispositivo...';

  @override
  String syncPairDone(String device) {
    return 'Emparejado con $device';
  }

  @override
  String get syncPairWrongCode =>
      'El código no coincidía. Muestra un nuevo código e inténtalo de nuevo.';

  @override
  String get syncPairNoOffer =>
      'Ningún dispositivo muestra este código. Puede que haya caducado.';

  @override
  String get syncPairTimedOut => 'El otro dispositivo no respondió a tiempo.';

  @override
  String get syncPairNeither =>
      'Ningún dispositivo está configurado todavía con este diario sincronizado.';

  @override
  String get syncPairBoth =>
      'Ambos dispositivos ya abren este diario sincronizado.';

  @override
  String syncPairFailed(String error) {
    return 'Error de emparejamiento: $error';
  }

  @override
  String get syncMediaPending =>
      'Diario sincronizado · algunos medios aún se están transfiriendo';

  @override
  String get syncWaitingForDevices =>
      'Diario sincronizado · esperando a que otro dispositivo transfiera medios';

  @override
  String get syncCacheNotice =>
      'Los medios en la nube son temporales. Guarde los originales en sus dispositivos; la sincronización no es una copia de seguridad.';

  @override
  String get paperTitle => 'papel de carta';

  @override
  String get paperPlain => 'Llano';

  @override
  String get paperLined => 'Forrado';

  @override
  String get paperGrid => 'Cuadrícula';

  @override
  String get paperTinted => 'teñido';

  @override
  String get paperDecorationTitle => 'Decoraciones';

  @override
  String get paperDecorationNone => 'Ninguno';

  @override
  String get paperDecorationBotanical => 'hojas';

  @override
  String get paperDecorationStars => 'estrellas';

  @override
  String get paperDecorationWashi => 'cinta washi';

  @override
  String get themeDarkChoice => 'apariencia oscura';

  @override
  String get themeDarkSame => 'Sigue la paleta de luz';

  @override
  String get themeDarkCustom => 'paleta separada';

  @override
  String get themeDarkAccent => 'Color de acento oscuro';

  @override
  String get themeColorTeal => 'verde azulado';

  @override
  String get themeColorCyan => 'cian';

  @override
  String get themeColorIndigo => 'índigo';

  @override
  String get themeColorCoral => 'Corales';

  @override
  String get themeColorOlive => 'oliva';

  @override
  String get themeColorSlate => 'pizarra';

  @override
  String get drawingTitle => 'Dibujo';

  @override
  String get drawingPen => 'bolígrafo';

  @override
  String get drawingEraser => 'borrador';

  @override
  String get drawingUndo => 'Deshacer';

  @override
  String get drawingClear => 'Borrar';

  @override
  String get drawingWidth => 'Ancho de la pluma';

  @override
  String get drawingStylusOnly => 'Solo lápiz óptico';

  @override
  String get drawingDiscardTitle => '¿Descartar dibujo?';

  @override
  String get drawingDiscardBody => 'Este dibujo no ha sido guardado.';

  @override
  String get drawingSaveError => 'No se pudo guardar el dibujo.';

  @override
  String get syncNetworkTitle => 'Diagnóstico de red';

  @override
  String get syncNetworkRefresh => 'Actualizar';

  @override
  String get syncNetworkSelectedRoute => 'Camino actual';

  @override
  String get syncNetworkAvailableRoutes => 'Caminos disponibles';

  @override
  String get syncNetworkSignaling => 'Conexión del directorio del dispositivo';

  @override
  String get syncNetworkRelayRemaining => 'Asignación de relevo restante';

  @override
  String get syncNetworkIcePair => 'Candidatos de conexión directa';

  @override
  String get syncNetworkPeerTrusted => 'Dispositivo autenticado';

  @override
  String get syncNetworkNoRoute => 'Esperando una conexión';

  @override
  String get syncNetworkUnavailable => 'Los diagnósticos no están disponibles';

  @override
  String get syncMediaCopiesTitle => 'Entrega de medios y copias.';

  @override
  String get syncMediaPendingCount => 'Esperando para transferir';

  @override
  String get syncMediaDurableCount => 'Entregado al almacenamiento personal';

  @override
  String get syncMediaTemporaryCount => 'Copias temporales o no confirmadas';

  @override
  String get syncMediaReceiptExplanation =>
      'Estos recuentos describen entregas completadas, no una nueva auditoría de las copias de seguridad supervivientes.';

  @override
  String get syncMediaCacheExplanation =>
      'Los medios temporales en la nube pueden caducar. Guarde sus originales o una copia de seguridad por separado.';

  @override
  String get momentsTitle => 'Momentos fotográficos';

  @override
  String get momentsHint =>
      'Encuentre grupos utilizando horarios de fotografías locales y coordenadas opcionales. Las fotos se adjuntan solo cuando eliges una tarjeta.';

  @override
  String get momentsScan => 'encontrar momentos';

  @override
  String get momentsChooseFolder => 'Elija la carpeta de fotos';

  @override
  String get momentsLocation => 'Incluir ubicaciones de fotografías';

  @override
  String get momentsEmpty => 'No hay grupos de fotos recientes.';

  @override
  String get momentsCreate => 'Escribe sobre estas fotos.';

  @override
  String get momentsDismiss => 'Descartar';

  @override
  String get momentsError => 'No se pudieron leer las fotos locales.';

  @override
  String get momentsCreated => 'Entrada de foto creada.';

  @override
  String get momentsPermission =>
      'Permitir el acceso a las fotos para encontrar sugerencias locales.';

  @override
  String get momentsScope =>
      'Sólo fotos recientes; como máximo 500 fotos y 20 fotos por tarjeta.';

  @override
  String momentsPhotoCount(int count) {
    return 'Fotos de $count';
  }

  @override
  String get nearbyTitle => 'Conectar dispositivos';

  @override
  String get nearbySend => 'Autorizar otro dispositivo';

  @override
  String get nearbyReceive => 'Conectarse a un dispositivo existente';

  @override
  String get nearbyInstructions =>
      'Conecte ambos dispositivos al mismo Wi-Fi o al punto de acceso de cada uno. Confirmar la autorización en el dispositivo existente; ambos dispositivos siguen siendo utilizables. No se requiere internet.';

  @override
  String get nearbyCompare =>
      'Compare este código en ambos dispositivos antes de aprobarlo.';

  @override
  String get nearbyConfirm => 'Los códigos coinciden';

  @override
  String get nearbyScan => 'Escanea el código del otro dispositivo';

  @override
  String get nearbyPaste => 'Pegar invitación';

  @override
  String get nearbyWaiting => 'Esperando aprobación en el otro dispositivo';

  @override
  String get nearbyWorking =>
      'Autorizar y sincronizar su diario y archivos adjuntos...';

  @override
  String get nearbyPending =>
      'Algunos archivos adjuntos aún necesitan sincronización. Mantenga el otro dispositivo en línea e inténtelo nuevamente.';

  @override
  String get nearbyComplete =>
      'Dispositivo conectado; diario y archivos adjuntos sincronizados';

  @override
  String get nearbyFailed =>
      'La conexión no finalizó. Verifique la conexión local y vuelva a intentarlo.';

  @override
  String get nearbyEmptyRequired =>
      'Utilice un dispositivo con un diario vacío que aún no esté conectado para sincronizarse.';

  @override
  String get nearbyRetry => 'Continuar sincronizando';

  @override
  String get nearbyWifi => 'Configuración de Wi-Fi';

  @override
  String get nearbyHotspot => 'Configuración del punto de acceso';

  @override
  String get nearbyKeepOpen =>
      'Mantenga esta página abierta hasta que finalice el nuevo dispositivo. La invitación caduca después de dos minutos.';

  @override
  String get syncDevicesTitle => 'Dispositivos autorizados';

  @override
  String get syncDevicesDescription =>
      'Solo los dispositivos aprobados pueden acceder a esta cuenta de AID. Revocar un dispositivo bloquea el servidor pero no puede borrar una clave maestra o un diario ya copiado en él.';

  @override
  String get syncDeviceRequest =>
      'Muestra este QR de autorización a un dispositivo aprobado';

  @override
  String get syncDeviceAuthorize => 'Autorizar un dispositivo';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Escanee o pegue la solicitud de autorización del nuevo dispositivo.';

  @override
  String get syncDeviceRevoke => 'Revocar';

  @override
  String get syncDeviceRotate => 'Rotar la clave de firma de este dispositivo';

  @override
  String get syncDeviceCheck => 'Verificar autorización';

  @override
  String get syncDeviceHardware => 'Clave de firma respaldada por hardware';

  @override
  String get syncDeviceSoftware => 'Clave de firma de software no exportable';

  @override
  String get syncDeviceUnavailable =>
      'La autorización del dispositivo no está disponible. Apruebe este dispositivo desde otro dispositivo autorizado y vuelva a intentarlo.';

  @override
  String get syncDeviceRevoked => 'Revocado';

  @override
  String get syncDeviceLocal => 'este dispositivo';

  @override
  String get cloudTrafficTitle =>
      'Cuota mensual de transferencia de datos en la nube para archivos multimedia';

  @override
  String get cloudTrafficLimit => 'Cuota mensual de transferencia de datos';

  @override
  String get cloudTrafficUsed => 'Transferencia de datos utilizada';

  @override
  String get cloudTrafficRemaining => 'Transferencia de datos restante';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'La cuota de transferencia de datos se restablece $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'La cuota de transferencia de datos en la nube para archivos multimedia se ha agotado. Los archivos multimedia faltantes se sincronizarán automáticamente cuando haya una conexión directa disponible o se restablezca la cuota.';

  @override
  String get cloudTrafficExplanation =>
      'El almacenamiento en caché de archivos multimedia y la retransmisión en vivo comparten esta cuota de transferencia de datos. Las conexiones directas no lo consumen. Los mensajes de texto del diario y de control de conexión tienen pequeños límites diarios separados.';

  @override
  String get appearanceThemeSection => 'Tema de la aplicación';

  @override
  String get appearancePaperSection => 'papel diario';

  @override
  String get appearanceTypographySection => 'Texto del diario';

  @override
  String get appearancePreferencesSection => 'Preferencias generales';

  @override
  String get themeSystemAccentHint =>
      'Utiliza la paleta del sistema en lugar de colores personalizados. Apágalo para elegir el tuyo.';

  @override
  String get syncDeviceNameSaveFailed =>
      'No se pudo guardar el nombre del dispositivo. Por favor inténtalo de nuevo.';

  @override
  String get nearbyConnectionHelp => 'Ayuda de conexión';

  @override
  String get syncAllSynced => 'Todo sincronizado';

  @override
  String get syncDetailsTitle => 'Detalles de sincronización';

  @override
  String get syncMore => 'Más opciones';

  @override
  String get syncDeviceName => 'Nombre del dispositivo';

  @override
  String get syncDeviceNameHint => 'Por ejemplo: mi tableta';

  @override
  String get syncDeviceNameInvalid => 'Utilice de 1 a 32 caracteres';

  @override
  String get syncDeviceKeyDetails => 'Detalles de seguridad';

  @override
  String get syncConnectionProblem =>
      'No se puede sincronizar por ahora. Reintentando automáticamente.';

  @override
  String get syncCopyComplete =>
      'Copia completa de su diario y archivos multimedia.';

  @override
  String get syncCopyPartial => 'Aún faltan algunos medios.';

  @override
  String get syncCopyOlder =>
      'Hay nuevos cambios esperando para sincronizarse.';

  @override
  String get syncCopyUnavailable =>
      'Los detalles de la copia no están disponibles. Vuelve a intentarlo más tarde.';

  @override
  String get syncCopyLastKnown =>
      'Otros dispositivos muestran su última copia confirmada. Los dispositivos sin conexión no se pueden verificar ahora.';

  @override
  String get syncCopyTemporary =>
      'Caché temporal. Mantenga los originales en sus dispositivos.';

  @override
  String get syncCopyStorage =>
      'Tu almacenamiento de sincronización. Las cargas de medios completadas se enumeran en diagnósticos.';

  @override
  String syncCopyChecked(String time) {
    return 'Último confirmado $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Transferencia de datos restantes este mes: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Empieza aquí';

  @override
  String get onboardConnect => 'Conectarse a un dispositivo existente';

  @override
  String get onboardFailed =>
      'No se pudo completar la configuración. Tu diario está a salvo; por favor inténtalo de nuevo.';

  @override
  String get tutorialTitle => 'Cómo utilizar el diario';

  @override
  String get tutorialWriteTitle => 'Escribe tu primera entrada en el diario.';

  @override
  String get tutorialWriteText =>
      'Toque + para escribir una entrada en el diario. Agregue un título opcional, elija la fecha del diario y toque la marca de verificación para guardar. Puede editar la entrada de su diario nuevamente en cualquier momento.';

  @override
  String get tutorialMediaTitle => 'Añade fotos, audio o escritura a mano.';

  @override
  String get tutorialMediaText =>
      'Utilice + en el editor del diario para adjuntar fotos, vídeos o una grabación de voz, o para abrir el lienzo de escritura a mano. Estos archivos adjuntos se guardan con la entrada del diario.';

  @override
  String get tutorialReviewTitle => 'Encuentra un día otra vez';

  @override
  String get tutorialReviewText =>
      'Explore su diario o calendario, busque sus escritos y organice entradas con etiquetas. Las páginas Media y Atlas le permiten buscar entradas anteriores por foto o ubicación.';

  @override
  String get tutorialSyncTitle => 'Utilice más de un dispositivo';

  @override
  String get tutorialSyncText =>
      'En Configuración → Datos y almacenamiento → Sincronización, conéctese a un dispositivo existente y confirme la autorización en ese dispositivo. Ambos dispositivos pueden seguir usando el diario. El texto del diario se sincroniza primero. Los archivos multimedia se sincronizan a continuación cuando la conexión de red y la cuota de transferencia de datos restante lo permiten.';

  @override
  String get tutorialPrivacyTitle => 'Mantenga su diario seguro';

  @override
  String get tutorialPrivacyText =>
      'Las entradas del diario permanecen en este dispositivo a menos que habilites la sincronización, las compartas o las exportes. La sincronización está cifrada de extremo a extremo. En Configuración también puedes establecer un código de acceso a la aplicación, crear copias de seguridad y volver a abrir este tutorial.';

  @override
  String get editorDiaryDay => 'Día del diario';

  @override
  String get editorDiaryDayPicker => 'Día del diario · creación sin cambios';

  @override
  String get editorDiaryDayHint =>
      'El día al que pertenece esta entrada. Cambiarlo no modifica su fecha ni hora de creación.';

  @override
  String get hiddenDiaryTitle => 'Entradas ocultas';

  @override
  String get hiddenDiaryHide => 'Ocultar entrada';

  @override
  String get hiddenDiaryShow => 'Mostrar entrada';

  @override
  String get hiddenDiaryEmpty => 'No hay entradas ocultas';

  @override
  String get hiddenDiaryUnlock => 'Desbloquear entradas ocultas';

  @override
  String get hiddenDiaryAuthHint =>
      'Usa el bloqueo de la aplicación o de la pantalla del dispositivo.';

  @override
  String get hiddenDiaryLocalOnly =>
      'Las entradas ocultas permanecen en este dispositivo y pausan la sincronización. Usa copias de seguridad cifradas. Las copias existentes en otros lugares no cambian.';

  @override
  String get moodClear => 'Borrar estado de ánimo';
}
