// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

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
  String get dailyReminderTitle => 'Registe hoje!';

  @override
  String get dailyReminderDescription => 'Faça o seu registo diário…';

  @override
  String get actionTakePhoto => 'Tire uma foto';

  @override
  String get actionToday => 'Hoje';

  @override
  String get actionOtherDay => 'Outro dia';

  @override
  String get pageHomeTitle => 'Início';

  @override
  String get jumpToMonthTitle => 'Jump to month';

  @override
  String get jumpToLogTitle => 'Jump to log';

  @override
  String get flashbacksTitle => 'Recordações';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Excluir dias maus';

  @override
  String get flaskbacksEmpty => 'Ainda sem recordações…';

  @override
  String get flashbackGoodDay => 'Um Bom Dia';

  @override
  String get flashbackRandomDay => 'Um Dia Aleatório';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Semanas Atrás',
      one: '$count Semana Atrás',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Meses Atrás',
      one: '$count Mês Atrás',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Anos Atrás',
      one: '$count Ano Atrás',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'On This Day';

  @override
  String get pageGalleryTitle => 'Galeria';

  @override
  String get searchLogsHint => 'Procurar registos…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count registos',
      one: '$count registo',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '$count day',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count words',
      one: '$count word',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Sem Registos…';

  @override
  String get noResults => 'No Results…';

  @override
  String get sortDateTitle => 'Data';

  @override
  String get sortOrderAscendingTitle => 'Ascendente';

  @override
  String get sortOrderDescendingTitle => 'Descendente';

  @override
  String get pageStatisticsTitle => 'Estatísticas';

  @override
  String get statisticsNotEnoughData => 'Sem dados suficientes…';

  @override
  String get statisticsRangeOneMonth => '1 Mês';

  @override
  String get statisticsRangeSixMonths => '6 Meses';

  @override
  String get statisticsRangeOneYear => '1 Ano';

  @override
  String get statisticsRangeAllTime => 'Todo o histórico';

  @override
  String chartSummaryTitle(Object tag) {
    return 'Resumo de $tag';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag Por Dia';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag Over Time';
  }

  @override
  String get chartGroupingLabel => 'Group by';

  @override
  String get chartGroupingDay => 'Day';

  @override
  String get chartGroupingWeek => 'Week';

  @override
  String get chartGroupingMonth => 'Month';

  @override
  String get chartGroupingYear => 'Year';

  @override
  String get chartSmoothingLabel => 'Smoothing';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sequência Atual $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sequência Mais Longa $count',
    );
    return '$_temp0';
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
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dias Desde um Dia Ruim $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Não é possível aceder armazenamento externo';

  @override
  String get errorExternalStorageAccessDescription =>
      'Se usar o armazenamento em rede, certifique-se que o serviço está online e que tenha acesso à rede.\n\nCaso contrário, a app pode ter perdido permissões para a pasta externa. Vá em configurações e selecione novamente a pasta externa para permitir o acesso.\n\nAtenção: as modificações não serão sincronizadas até restaurar o acesso ao local do armazenamento externo!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Continuar com a base de dados local';

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
  String get lastModified => 'Modificado';

  @override
  String get writeSomethingHint => 'Escreva alguma coisa…';

  @override
  String get titleHint => 'Título…';

  @override
  String get deleteLogTitle => 'Apagar Registo';

  @override
  String get deleteLogDescription => 'Quer apagar este registo?';

  @override
  String get deletePhotoTitle => 'Remover Foto';

  @override
  String get deletePhotoDescription => 'Quer apagar esta foto?';

  @override
  String get pageSettingsTitle => 'Configurações';

  @override
  String get settingsAppearanceTitle => 'Aparência';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Primeiro Dia da Semana';

  @override
  String get settingsCalendarSystem => 'Calendar System';

  @override
  String get calendarSystemGregorian => 'Gregorian';

  @override
  String get calendarSystemJalali => 'Jalali';

  @override
  String get settingsUseSystemAccentColor => 'Usar Cores do Sistema';

  @override
  String get settingsCustomAccentColor => 'Cor Personalizada';

  @override
  String get settingsShowMarkdownToolbar =>
      'Mostrar Barra de Ferramentas Markdown';

  @override
  String get settingsShowFlashbacks => 'Mostrar recordações';

  @override
  String get settingsChangeMoodIcons => 'Alterar Ícones de Humor';

  @override
  String get moodIconPrompt => 'Insira um ícone';

  @override
  String get settingsFlashbacksViewLayout => 'Flashbacks View Layout';

  @override
  String get settingsHideImagesInGallery => 'Hide Images In Gallery';

  @override
  String get settingsHideImages => 'Hide Images';

  @override
  String get pageCalendarTitle => 'Calendar';

  @override
  String get settingsNotificationsTitle => 'Notificações';

  @override
  String get settingsDailyReminderOnboarding =>
      'Ativar lembretes diários para deixá-lo consistente!';

  @override
  String get settingsNotificationsPermissionsPrompt =>
      'A permissão \"Agendar Alarmes\" será solicitada para mandar lembretes a um momento aleatório ou ao seu tempo preferido.';

  @override
  String get settingsDailyReminderTitle => 'Lembrete Diário';

  @override
  String get settingsOnThisDayDescription => 'Revisit past memories';

  @override
  String get settingsDailyReminderDescription => 'Um lembrete suave cada dia';

  @override
  String get settingsReminderTime => 'Hora do Lembrete';

  @override
  String get settingsFixedReminderTimeTitle => 'Hora do Lembrete Fixa';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Escolha uma hora fixa para o lembrete';

  @override
  String get settingsAlwaysSendReminderTitle => 'Sempre mandar um lembrete';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Mandar um lembrete mesmo se um registo já foi começado';

  @override
  String get settingsCustomizeNotificationTitle => 'Customizar Notificações';

  @override
  String get settingsTemplatesTitle => 'Modelos';

  @override
  String get settingsDefaultTemplate => 'Modelo Padrão';

  @override
  String get manageTemplates => 'Gerir Modelos';

  @override
  String get addTemplate => 'Adicionar Modelo';

  @override
  String get newTemplate => 'Novo Modelo';

  @override
  String get noTemplateTitle => 'Nenhum';

  @override
  String get noTemplatesDescription => 'Nenhum modelo criado ainda…';

  @override
  String get templateVariableTime => 'Time';

  @override
  String get templateDefaultTimestampTitle => 'Timestamp';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Day Summary';

  @override
  String get templateDefaultSummaryBody => '### Summary\n- \n\n### Quote\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Reflection';

  @override
  String get templateDefaultReflectionBody =>
      '### What did you enjoy about today?\n- \n\n### What are you thankful for?\n- \n\n### What are you looking forward to?\n- ';

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
  String get settingsStorageTitle => 'Armazenamento';

  @override
  String get settingsImageQuality => 'Qualidade da Imagem';

  @override
  String get imageQualityHigh => 'Alta';

  @override
  String get imageQualityMedium => 'Média';

  @override
  String get imageQualityLow => 'Baixa';

  @override
  String get imageQualityNoCompression => 'Sem Compressão';

  @override
  String get settingsLogFolder => 'Pasta de Registos';

  @override
  String get settingsImageFolder => 'Pasta de Imagens';

  @override
  String get warningTitle => 'Aviso';

  @override
  String get logFolderWarningDescription =>
      'Se a pasta selecionada já contiver um ficheiro \'daily_you.db\', ele será usado para substituir os seus registos existentes!';

  @override
  String get errorTitle => 'Erro';

  @override
  String get logFolderErrorDescription =>
      'Não foi possível alterar a pasta de registos!';

  @override
  String get imageFolderErrorDescription =>
      'Não foi possível alterar a pasta de imagens!';

  @override
  String get backupErrorDescription => 'Não foi possível criar backup!';

  @override
  String get restoreErrorDescription => 'Não foi possível restaurar backup!';

  @override
  String get settingsBackupRestoreTitle => 'Backup e Restaurar';

  @override
  String get settingsBackup => 'Backup';

  @override
  String get settingsRestore => 'Restaurar';

  @override
  String get settingsRestorePromptDescription =>
      'Restaurar um backup irá sobrescrever os seus dados atuais!';

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
    return 'A transferir… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'A criar um backup… $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'A restaurar o backup… $percent%';
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
  String get cleanUpStatus => 'A limpar…';

  @override
  String migratingImagesStatus(Object current, Object total) {
    return 'Migrating photos… $current/$total';
  }

  @override
  String get settingsExport => 'Export';

  @override
  String get settingsExportToAnotherFormat => 'Exportar para outro formato';

  @override
  String get settingsExportFormatDescription =>
      'Isto não deve ser usado como backup!';

  @override
  String get exportLogs => 'Export Logs';

  @override
  String get exportImages => 'Export Images';

  @override
  String get settingsImport => 'Import';

  @override
  String get settingsImportFromAnotherApp => 'Importar de outra app';

  @override
  String get settingsTranslateCallToAction =>
      'Todos devem ter acesso a um diário!';

  @override
  String get settingsHelpTranslate => 'Ajude a Traduzir';

  @override
  String get importLogs => 'Import Logs';

  @override
  String get importImages => 'Import Images';

  @override
  String get logFormatTitle => 'Escolher Formato';

  @override
  String get logFormatDescription =>
      'O formato de outra app pode não suportar todas as funcionalidades. Por favor, informe quaisquer problemas, pois os formatos de terceiros podem mudar a qualquer momento. Isto não irá impactar os registos existentes!';

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
  String get settingsDeleteAllLogsTitle => 'Apagar Todos os Registos';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Quer apagar todos os seus registos?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Digite \'$prompt\' para confirmar. Isto não pode ser desfeito!';
  }

  @override
  String get settingsLanguageTitle => 'Idioma';

  @override
  String get settingsAppLanguageTitle => 'Idioma da app';

  @override
  String get settingsOverrideAppLanguageTitle => 'Substituir língua da app';

  @override
  String get settingsSecurityTitle => 'Segurança';

  @override
  String get settingsSecurityRequirePassword => 'Pedir Password';

  @override
  String get settingsSecurityEnterPassword => 'Introduza Password';

  @override
  String get settingsSecuritySetPassword => 'Definir Password';

  @override
  String get settingsSecurityChangePassword => 'Alterar Password';

  @override
  String get settingsSecurityPassword => 'Password';

  @override
  String get settingsSecurityConfirmPassword => 'Confirmar Password';

  @override
  String get settingsSecurityOldPassword => 'Antiga Password';

  @override
  String get settingsSecurityIncorrectPassword => 'Password Incorreta';

  @override
  String get settingsSecurityPasswordsDoNotMatch =>
      'As passwords não são iguais';

  @override
  String get requiredPrompt => 'Requirido';

  @override
  String get settingsSecurityBiometricUnlock => 'Desbloqueio por Biometria';

  @override
  String get unlockAppPrompt => 'Desbloquear a aplicação';

  @override
  String get settingsAboutTitle => 'Sobre';

  @override
  String get settingsVersion => 'Versão';

  @override
  String get settingsLicense => 'Licença';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsSourceCode => 'Código-fonte';

  @override
  String get settingsOpenSourceLicenses => 'Open Source Licenses';

  @override
  String get settingsMadeWithLove => 'Feito com ❤️';

  @override
  String get settingsConsiderSupporting => 'Considere Apoiar';

  @override
  String get imagesTitle => 'Images';

  @override
  String get tagMoodTitle => 'Humor';

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
      'Yes: in Settings → Data & storage, import exports from Daylio, Diarium, Diaro, DayBook, My Brain, OneShot and Pixels, or a Daily You JSON file.';

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
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get dailyReminderTitle => 'Registre hoje!';

  @override
  String get dailyReminderDescription => 'Faça o seu registro diário…';

  @override
  String get actionTakePhoto => 'Tirar uma foto';

  @override
  String get actionToday => 'Hoje';

  @override
  String get actionOtherDay => 'Outro dia';

  @override
  String get pageHomeTitle => 'Início';

  @override
  String get jumpToMonthTitle => 'Pular para o mês';

  @override
  String get jumpToLogTitle => 'Ir para registro';

  @override
  String get flashbacksTitle => 'Recordações';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Excluir dias ruins';

  @override
  String get flaskbacksEmpty => 'Ainda sem recordações…';

  @override
  String get flashbackGoodDay => 'Um Bom Dia';

  @override
  String get flashbackRandomDay => 'Um Dia Aleatório';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Semanas Atrás',
      one: '$count Semana Atrás',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Meses Atrás',
      one: '$count Mês Atrás',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Anos Atrás',
      one: '$count Ano Atrás',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'Neste dia';

  @override
  String get pageGalleryTitle => 'Galeria';

  @override
  String get searchLogsHint => 'Buscar Registros…';

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
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count palavras',
      one: '$count palavra',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Sem Registros…';

  @override
  String get noResults => 'Sem resultados…';

  @override
  String get sortDateTitle => 'Data';

  @override
  String get sortOrderAscendingTitle => 'Crescente';

  @override
  String get sortOrderDescendingTitle => 'Decrescente';

  @override
  String get pageStatisticsTitle => 'Estatísticas';

  @override
  String get statisticsNotEnoughData => 'Sem dados suficientes…';

  @override
  String get statisticsRangeOneMonth => '1 Mês';

  @override
  String get statisticsRangeSixMonths => '6 Meses';

  @override
  String get statisticsRangeOneYear => '1 Ano';

  @override
  String get statisticsRangeAllTime => 'Todo o histórico';

  @override
  String chartSummaryTitle(Object tag) {
    return 'Resumo de $tag';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag Por Dia';
  }

  @override
  String get chartGroupingLabel => 'Agrupar por';

  @override
  String get chartGroupingDay => 'Dia';

  @override
  String get chartGroupingWeek => 'Semana';

  @override
  String get chartGroupingMonth => 'Mês';

  @override
  String get chartGroupingYear => 'Ano';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sequência Atual $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sequência Mais Longa $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dias Desde um Dia Ruim $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Não é possível acessar armazenamento externo';

  @override
  String get errorExternalStorageAccessDescription =>
      'Se você estiver usando o armazenamento em rede, certifique-se que o serviço está online e que você tenha acesso à rede.\n\nCaso contrário, o aplicativo pode ter perdido permissões para a pasta externa. Vá em configurações e selecione novamente a pasta externa para permitir o acesso.\n\nAtenção: as modificações não serão sincronizadas até você restaurar o acesso ao local do armazenamento externo!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Continuar com banco de dados local';

  @override
  String get lastModified => 'Modificado';

  @override
  String get writeSomethingHint => 'Escreva alguma coisa…';

  @override
  String get titleHint => 'Título…';

  @override
  String get deleteLogTitle => 'Apagar Registro';

  @override
  String get deleteLogDescription => 'Você quer apagar este registro?';

  @override
  String get deletePhotoTitle => 'Remover Foto';

  @override
  String get deletePhotoDescription => 'Você quer apagar esta foto?';

  @override
  String get pageSettingsTitle => 'Configurações';

  @override
  String get settingsAppearanceTitle => 'Aparência';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Primeiro Dia da Semana';

  @override
  String get settingsCalendarSystem => 'Sistema de Calendário';

  @override
  String get calendarSystemGregorian => 'Gregoriano';

  @override
  String get calendarSystemJalali => 'Persa';

  @override
  String get settingsUseSystemAccentColor => 'Usar Cores do Sistema';

  @override
  String get settingsCustomAccentColor => 'Cor Personalizada';

  @override
  String get settingsShowMarkdownToolbar =>
      'Mostrar Barra de Ferramentas Markdown';

  @override
  String get settingsShowFlashbacks => 'Mostrar Flashbacks';

  @override
  String get settingsChangeMoodIcons => 'Alterar Ícones de Humor';

  @override
  String get moodIconPrompt => 'Insira um ícone';

  @override
  String get settingsFlashbacksViewLayout => 'Visualização de Recordações';

  @override
  String get settingsHideImagesInGallery => 'Ocultar Imagens Na Galeria';

  @override
  String get settingsHideImages => 'Ocultar Imagens';

  @override
  String get pageCalendarTitle => 'Calendário';

  @override
  String get settingsNotificationsTitle => 'Notificações';

  @override
  String get settingsDailyReminderOnboarding =>
      'Habilite lembretes diários para te deixar consistente!';

  @override
  String get settingsNotificationsPermissionsPrompt =>
      'A permissão \"Agendar Alarmes\" será solicitada para mandar lembretes a um momento aleatório ou ao seu tempo preferido.';

  @override
  String get settingsDailyReminderTitle => 'Lembrete Diário';

  @override
  String get settingsDailyReminderDescription => 'Um lembrete suave cada dia';

  @override
  String get settingsReminderTime => 'Hora do Lembrete';

  @override
  String get settingsFixedReminderTimeTitle => 'Hora do Lembrete Fixa';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Escolha uma hora fixa para o lembrete';

  @override
  String get settingsAlwaysSendReminderTitle => 'Sempre mandar um lembrete';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Mandar um lembrete mesmo se um registro já foi começado';

  @override
  String get settingsCustomizeNotificationTitle => 'Customizar Notificações';

  @override
  String get settingsTemplatesTitle => 'Modelos';

  @override
  String get settingsDefaultTemplate => 'Modelo Padrão';

  @override
  String get manageTemplates => 'Gerenciar Modelos';

  @override
  String get addTemplate => 'Adicionar Modelo';

  @override
  String get newTemplate => 'Novo Modelo';

  @override
  String get noTemplateTitle => 'Nenhum';

  @override
  String get noTemplatesDescription => 'Nenhum modelo criado ainda…';

  @override
  String get templateVariableTime => 'Tempo';

  @override
  String get templateDefaultTimestampTitle => 'Registro de data';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date-$time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Resumo Diário';

  @override
  String get templateDefaultSummaryBody => '### Resumo\n- \n\n### Citação\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Reflexão';

  @override
  String get templateDefaultReflectionBody =>
      '### O que você gostou sobre hoje?\n- \n\n### O que te deixou agradecido(a)?\n- \n\n### O que você espera para o futuro?\n- ';

  @override
  String get settingsStorageTitle => 'Armazenamento';

  @override
  String get settingsImageQuality => 'Qualidade da Imagem';

  @override
  String get imageQualityHigh => 'Alta';

  @override
  String get imageQualityMedium => 'Média';

  @override
  String get imageQualityLow => 'Baixa';

  @override
  String get imageQualityNoCompression => 'Sem Compressão';

  @override
  String get settingsLogFolder => 'Pasta de Registros';

  @override
  String get settingsImageFolder => 'Pasta de Imagens';

  @override
  String get warningTitle => 'Aviso';

  @override
  String get logFolderWarningDescription =>
      'Se a pasta selecionada já contiver um arquivo \'daily_you.db\', ele será usado para substituir seus registros existentes!';

  @override
  String get errorTitle => 'Erro';

  @override
  String get logFolderErrorDescription =>
      'Não foi possível alterar a pasta de registros!';

  @override
  String get imageFolderErrorDescription =>
      'Não foi possível alterar a pasta de imagens!';

  @override
  String get backupErrorDescription => 'Não foi possível criar backup!';

  @override
  String get restoreErrorDescription => 'Não foi possível restaurar backup!';

  @override
  String get settingsBackupRestoreTitle => 'Backup e Restaurar';

  @override
  String get settingsBackup => 'Backup';

  @override
  String get settingsRestore => 'Restaurar';

  @override
  String get settingsRestorePromptDescription =>
      'Restaurar um backup irá sobrescrever os seus dados atuais!';

  @override
  String tranferStatus(Object percent) {
    return 'Transferindo… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Criando Backup… $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Restaurando Backup… $percent%';
  }

  @override
  String get cleanUpStatus => 'Limpando…';

  @override
  String get settingsExport => 'Exportar';

  @override
  String get settingsExportToAnotherFormat => 'Exportar Para Outro Formato';

  @override
  String get settingsExportFormatDescription =>
      'Isso não deve ser usado como backup!';

  @override
  String get exportLogs => 'Exportar Registros';

  @override
  String get exportImages => 'Exportar Imagens';

  @override
  String get settingsImport => 'Importar';

  @override
  String get settingsImportFromAnotherApp => 'Importar de Outro Aplicativo';

  @override
  String get settingsTranslateCallToAction =>
      'Todos devem ter acesso a um diário!';

  @override
  String get settingsHelpTranslate => 'Ajude a Traduzir';

  @override
  String get importLogs => 'Importar Registros';

  @override
  String get importImages => 'Importar Imagens';

  @override
  String get logFormatTitle => 'Escolher Formato';

  @override
  String get logFormatDescription =>
      'O formato de outro aplicativo pode não suportar todas as funcionalidades. Por favor, informe qualquer problemas, pois os formatos de terceiros podem mudar a qualquer momento. Isto não irá impactar os registros existentes!';

  @override
  String get formatMarkdown => 'Markdown';

  @override
  String get settingsDeleteAllLogsTitle => 'Apagar Todos os Registros';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Você quer apagar todos os seus registros?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Digite \'$prompt\' para confirmar. Isto não pode ser desfeito!';
  }

  @override
  String get settingsLanguageTitle => 'Idioma';

  @override
  String get settingsAppLanguageTitle => 'Linguagem do Aplicativo';

  @override
  String get settingsOverrideAppLanguageTitle =>
      'Substituir Linguagem do Aplicativo';

  @override
  String get settingsSecurityTitle => 'Segurança';

  @override
  String get settingsSecurityRequirePassword => 'Requer Senha';

  @override
  String get settingsSecurityEnterPassword => 'Digite a Senha';

  @override
  String get settingsSecuritySetPassword => 'Definir Senha';

  @override
  String get settingsSecurityChangePassword => 'Mudar Senha';

  @override
  String get settingsSecurityPassword => 'Senha';

  @override
  String get settingsSecurityConfirmPassword => 'Confirmar Senha';

  @override
  String get settingsSecurityOldPassword => 'Senha Antiga';

  @override
  String get settingsSecurityIncorrectPassword => 'Senha Incorreta';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'Senhas Não Coincidem';

  @override
  String get requiredPrompt => 'Obrigatório';

  @override
  String get settingsSecurityBiometricUnlock => 'Desbloquear com Biometria';

  @override
  String get unlockAppPrompt => 'Desbloquear Aplicativo';

  @override
  String get settingsAboutTitle => 'Sobre';

  @override
  String get settingsVersion => 'Versão';

  @override
  String get settingsLicense => 'Licença';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsSourceCode => 'Código-fonte';

  @override
  String get settingsMadeWithLove => 'Feito com ❤️';

  @override
  String get settingsConsiderSupporting => 'Considere Apoiar';

  @override
  String get tagMoodTitle => 'Humor';
}
