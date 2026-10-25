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
  String get themeColorTitle => 'Cor do tema';

  @override
  String get themeColorHint => 'Escolha uma cor para esta paleta.';

  @override
  String get themeColorBlue => 'Céu azul';

  @override
  String get themeColorGreen => 'Verde floresta';

  @override
  String get themeColorBrown => 'Café quente';

  @override
  String get themeColorPurple => 'Lavanda';

  @override
  String get themeColorRose => 'Rosa empoeirada';

  @override
  String get themeColorAmber => 'Âmbar';

  @override
  String get themeColorPreview => 'Um pouco todos os dias';

  @override
  String get themeTintBackgroundTitle => 'Tingir fundos com a cor do tema';

  @override
  String get themeTintBackgroundHint =>
      'Desligue para fundos cinzentos neutros; os botões mantêm a cor escolhida.';

  @override
  String get dailyReminderTitle => 'Registe hoje!';

  @override
  String get dailyReminderDescription => 'Faça o seu registo diário…';

  @override
  String get actionTakePhoto => 'Tire uma foto';

  @override
  String get flashbacksTitle => 'Recordações';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Excluir dias maus';

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
      other: '$count dias',
      one: '$count dias',
      many: '$count dias',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count palavras',
      one: '$count palavras',
      many: '$count palavras',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Sem Registos…';

  @override
  String get noResults => 'Sem resultados…';

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
    return '$tag ao longo do tempo';
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
  String get chartSmoothingLabel => 'Suavização';

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
      other: 'Ótimos dias $count',
      one: 'Óptimos dias $count',
      many: 'Óptimos dias $count',
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
  String get settingsCalendarSystem => 'Sistema de calendário';

  @override
  String get calendarSystemGregorian => 'Gregoriano';

  @override
  String get calendarSystemJalali => 'Jalali';

  @override
  String get settingsUseSystemAccentColor => 'Usar Cores do Sistema';

  @override
  String get settingsCustomAccentColor => 'Cor Personalizada';

  @override
  String get settingsShowFlashbacks => 'Mostrar recordações';

  @override
  String get settingsChangeMoodIcons => 'Alterar Ícones de Humor';

  @override
  String get moodIconPrompt => 'Insira um ícone';

  @override
  String get settingsHideImages => 'Ocultar imagens';

  @override
  String get pageCalendarTitle => 'Calendário';

  @override
  String get settingsNotificationsTitle => 'Notificações';

  @override
  String get settingsDailyReminderTitle => 'Lembrete Diário';

  @override
  String get settingsOnThisDayDescription => 'Revisite memórias passadas';

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
  String get manageTemplates => 'Gerir Modelos';

  @override
  String get noTemplateTitle => 'Nenhum';

  @override
  String get noTemplatesDescription => 'Nenhum modelo criado ainda…';

  @override
  String get templateDefaultTimestampTitle => 'Carimbo de data e hora';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Resumo do dia';

  @override
  String get templateDefaultSummaryBody => '### Resumo\n- \n\n### Citação\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Reflexão';

  @override
  String get templateDefaultReflectionBody =>
      '### O que gostou hoje?\n- \n\n### Pelo que está grato?\n- \n\n### O que está ansioso?\n- ';

  @override
  String get settingsTagsTitle => 'Etiquetas';

  @override
  String get manageTags => 'Gerir tags';

  @override
  String get tagTypeLabelTitle => 'Etiqueta';

  @override
  String get tagTypeTrackerTitle => 'Rastreador';

  @override
  String get nameHint => 'Nome';

  @override
  String get tagColorLabel => 'Cor';

  @override
  String get iconPickerTitle => 'Escolha o ícone';

  @override
  String get iconPickerIconsTab => 'Ícones';

  @override
  String get iconPickerCustomTab => 'Personalizado';

  @override
  String get iconPickerSearchHint => 'Ícones de pesquisa…';

  @override
  String get colorPickerTitle => 'Escolha a cor';

  @override
  String get colorPickerPaletteTab => 'Cores';

  @override
  String get iconGroupMoodPeople => 'Humor e Pessoas';

  @override
  String get iconGroupHealth => 'Saúde';

  @override
  String get iconGroupWorkFinance => 'Trabalho e Finanças';

  @override
  String get iconGroupHabitsGoals => 'Hábitos e objetivos';

  @override
  String get iconGroupNature => 'Natureza';

  @override
  String get iconGroupFoodDrink => 'Comida e bebida';

  @override
  String get iconGroupHome => 'Página inicial';

  @override
  String get iconGroupTravel => 'Viajar';

  @override
  String get iconGroupSymbols => 'Símbolos';

  @override
  String get tagCategoryLabel => 'Categoria';

  @override
  String get tagLabel => 'Etiqueta';

  @override
  String get tagCategoryUncategorized => 'Sem categoria';

  @override
  String get newCategoryTitle => 'Nova categoria';

  @override
  String get shareButtonLabel => 'Compartilhar';

  @override
  String get importErrorDescription => 'Falha ao importar ficheiro!';

  @override
  String get exportErrorDescription => 'Falha ao exportar ficheiro!';

  @override
  String get deleteTitle => 'Excluir';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' É utilizado em $count entradas do diário.',
      one: ' É utilizado em $count entradas do diário.',
      many: ' É utilizado em $count de entradas do diário.',
      zero: '',
    );
    return 'Apagar \"$name\"?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' As suas $count tags também serão excluídas.',
      one: ' As suas tags $count também serão excluídas.',
      many: ' As suas $count tags também serão eliminadas.',
      zero: '',
    );
    return 'Apagar \"$name\"?$_temp0';
  }

  @override
  String get tagNameExists => 'Já existe uma tag com esse nome';

  @override
  String get categoryNameExists => 'Já existe uma categoria com este nome';

  @override
  String deleteTemplateMessage(Object name) {
    return 'Apagar \"$name\"?';
  }

  @override
  String get addTagsTitle => 'Adicionar tags';

  @override
  String get addTagsSearchHint => 'Pesquisar tags…';

  @override
  String get tagsRecent => 'Usadas recentemente';

  @override
  String get tagNew => 'Nova etiqueta';

  @override
  String get tagFavoriteName => 'Favorito';

  @override
  String get iconGroupActivities => 'Atividades';

  @override
  String get iconGroupHobbies => 'Entretenimento';

  @override
  String get settingsStorageTitle => 'Armazenamento';

  @override
  String get settingsLogFolder => 'Pasta de Registos';

  @override
  String get settingsImageFolder => 'Pasta de Imagens';

  @override
  String get warningTitle => 'Aviso';

  @override
  String get logFolderWarningDescription =>
      'Se a pasta selecionada já contiver um ficheiro \'aid_diary.db\', ele será usado para substituir os seus registos existentes!';

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
  String get settingsBackupPasswordProtect =>
      'Backups protegidos por palavra-passe';

  @override
  String get backupEncryptedTitle => 'Backup encriptado';

  @override
  String get backupEncryptedContent =>
      'Este backup está protegido por palavra-passe.';

  @override
  String get settingsAutoBackup => 'Backups Automáticos';

  @override
  String get settingsAutoBackupLocation => 'Local de backup';

  @override
  String get settingsAutoBackupInterval => 'Intervalo de cópia de segurança';

  @override
  String get settingsAutoBackupIntervalDaily => 'Diariamente';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Semanalmente';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Mensalmente';

  @override
  String get settingsAutoBackupMaxCount => 'Backups para manter';

  @override
  String get settingsAutoBackupRequireCharging =>
      'Apenas durante o carregamento';

  @override
  String settingsBackupLast(Object time) {
    return 'Último backup $time';
  }

  @override
  String get settingsBackupNever => 'Nunca fiz backup';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Próximo backup $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'Todos';

  @override
  String get autoBackupFailedTitle => 'Falha no backup';

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
    return 'Encriptação de backup… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Desencriptar backup… $percent%';
  }

  @override
  String get cleanUpStatus => 'A limpar…';

  @override
  String get settingsExportToAnotherFormat => 'Exportar para outro formato';

  @override
  String get settingsExportFormatDescription =>
      'Isto não deve ser usado como backup!';

  @override
  String get settingsImportFromAnotherApp => 'Importar de outra app';

  @override
  String get logFormatTitle => 'Escolher Formato';

  @override
  String get logFormatDescription =>
      'O formato de outra app pode não suportar todas as funcionalidades. Por favor, informe quaisquer problemas, pois os formatos de terceiros podem mudar a qualquer momento. Isto não irá impactar os registos existentes!';

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
  String get settingsDeleteAllLogsTitle => 'Apagar Todos os Registos';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Quer apagar todos os seus registos?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Digite \'$prompt\' para confirmar. Isto não pode ser desfeito!';
  }

  @override
  String get settingsAppLanguageTitle => 'Idioma da app';

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
  String get settingsOpenSourceLicenses => 'Licenças de código aberto';

  @override
  String get tagMoodTitle => 'Humor';

  @override
  String get selectTagTitle => 'Selecione a etiqueta';

  @override
  String get labelPresentLabel => 'Presente';

  @override
  String get labelAbsentLabel => 'Ausente';

  @override
  String get labelCoverageLabel => 'Cobertura';

  @override
  String chartDistributionTitle(Object tag) {
    return 'Distribuição $tag';
  }

  @override
  String get shareAddToLogPickerTitle => 'Escolha uma entrada do diário';

  @override
  String get adaptiveEmptyDay => 'Ainda não há entradas para este dia';

  @override
  String get adaptiveNewEntry => 'Escrever uma entrada';

  @override
  String get pageJournalTitle => 'Diário';

  @override
  String get coachPrompt1 => 'O que o fez sorrir hoje?';

  @override
  String get coachPrompt2 => 'O que aprendeu hoje?';

  @override
  String get coachPrompt3 => 'Com quem falou hoje e como se sentiu?';

  @override
  String get coachPrompt4 => 'Pelo que está grato agora?';

  @override
  String get coachPrompt5 =>
      'O que consumiu a maior parte da sua energia hoje?';

  @override
  String get coachPrompt6 => 'Descreva um pequeno momento que queira recordar.';

  @override
  String get coachPrompt7 => 'O que faria de amanhã um bom dia?';

  @override
  String get coachPrompt8 => 'O que lhe tem passado pela cabeça ultimamente?';

  @override
  String get coachPrompt9 => 'O que fez hoje só para si?';

  @override
  String get coachPrompt10 => 'Se hoje tivesse um título, qual seria?';

  @override
  String get pageMediaTitle => 'Mídia';

  @override
  String get pageAtlasTitle => 'Atlas';

  @override
  String get pageCoachTitle => 'Treinador';

  @override
  String get noEntrySelected => 'Nenhuma entrada selecionada.';

  @override
  String get entryShare => 'Compartilhar';

  @override
  String get entryFavorite => 'Estrela';

  @override
  String get entryEdit => 'Editar';

  @override
  String get entryPrevious => 'Entrada anterior';

  @override
  String get entryNext => 'Próxima entrada';

  @override
  String get journalStories => 'Histórias';

  @override
  String get journalEntries => 'Entradas';

  @override
  String get journalEmptyHint =>
      'Comece o seu diário adicionando uma nova entrada.';

  @override
  String get storyToday => 'Hoje';

  @override
  String get storyThrowback => 'Retrocesso';

  @override
  String get storyNoThrowback => 'Sem retrocesso hoje';

  @override
  String get mediaFiles => 'Arquivos de mídia';

  @override
  String get mediaEmpty => 'Ainda não há fotos.';

  @override
  String get mediaEmptyHint =>
      'As fotos anexadas às inscrições serão mostradas aqui.';

  @override
  String get atlasEmpty => 'Sem entrada com localização.';

  @override
  String get atlasEmptyHint => 'As entradas com um local serão aqui mostradas.';

  @override
  String get atlasShowAll => 'Mostrar todas as entradas';

  @override
  String get atlasMyLocation => 'A minha localização';

  @override
  String get coachAll => 'Todos';

  @override
  String get coachPrograms => 'Programas';

  @override
  String get coachTemplates => 'Modelos';

  @override
  String get coachKindProgram => 'Programa';

  @override
  String get coachKindTemplate => 'Modelo';

  @override
  String get coachNoTemplates => 'Sem programas ou modelos.';

  @override
  String get coachUseTemplate => 'Escreva com este modelo';

  @override
  String get coachProgramEverydayTitle => 'Momentos do dia a dia';

  @override
  String get coachProgramEverydayDescription =>
      'Cinco perguntas curtas, uma por dia. Cada um demora um ou dois minutos e ajuda-o a ver o que tornou o dia seu. Uma forma gentil de criar o hábito de escrever um pouco todos os dias.';

  @override
  String get coachProgramReflectTitle => 'Olhando para dentro';

  @override
  String get coachProgramReflectDescription =>
      'Uma pergunta mais profunda por semana, durante cinco semanas. Não tenha pressa com cada um: como se sente, o que o desgasta, pelo que está grato.';

  @override
  String get searchFilters => 'Filtros';

  @override
  String get searchFilterTags => 'Etiquetas';

  @override
  String get searchFilterStarred => 'Com estrela';

  @override
  String get searchHint => 'Digite para pesquisar ou escolha um filtro.';

  @override
  String get locationTitle => 'Localização';

  @override
  String get locationName => 'Nome do lugar';

  @override
  String get locationRemove => 'Remover';

  @override
  String get locationServiceDisabled =>
      'Os serviços de localização estão desativados.';

  @override
  String get locationPermissionDenied =>
      'A permissão de localização foi negada.';

  @override
  String get locationUnavailable =>
      'Não foi possível obter a localização atual.';

  @override
  String get calendarJumpToToday => 'Ir para hoje';

  @override
  String get editorStartWriting => 'Comece a escrever ou escolha um ';

  @override
  String get editorTemplateLink => 'Modelo';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Escolha um modelo';

  @override
  String get templateFeatured => 'Modelos em destaque';

  @override
  String get templateMine => 'Os meus modelos';

  @override
  String get templateDailyName => 'Revisão diária';

  @override
  String get templateDailyDescription =>
      'O que aconteceu, como foi e o que vem a seguir.';

  @override
  String get templateDailyText =>
      '## O que aconteceu hoje\n\n\n##Como me senti\n\n\n## Três coisas pelas quais estou grato\n1. \n2. \n3. \n\n## Amanhã\n';

  @override
  String get templateTravelName => 'Entrada no diário de viagem';

  @override
  String get templateTravelDescription =>
      'Lugares, momentos e comida da estrada.';

  @override
  String get templateTravelText =>
      '##Onde fui\n\n\n## O momento que mais recordo\n\n\n## O que comi\n\n\n## Planos para amanhã\n';

  @override
  String get templateReadingName => 'Notas de leitura';

  @override
  String get templateReadingDescription => 'Citações e pensamentos do que leu.';

  @override
  String get templateReadingText =>
      '## Livro\n\n\n## Onde estou\n\n\n## Citações\n> \n\n## Os meus pensamentos\n';

  @override
  String get templateWeeklyName => 'Revisão semanal';

  @override
  String get templateWeeklyDescription =>
      'Destaques, combates e foco da próxima semana.';

  @override
  String get templateWeeklyText =>
      '## Destaques\n\n\n## O que foi difícil\n\n\n## O que aprendi\n\n\n## Foco para a próxima semana\n';

  @override
  String get entrySaveAsTemplate => 'Guardar como modelo';

  @override
  String get entrySavedAsTemplate => 'Salvo como modelo';

  @override
  String get storyStatistics => 'Estatísticas';

  @override
  String get storyMoodChart => 'Gráfico de humor';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return 'Entradas $entries · Dias $days';
  }

  @override
  String get storyThisYear => 'Este ano';

  @override
  String get storyLastYear => 'Ano passado';

  @override
  String get storyTapToOpen => 'Toque num dia para abri-lo';

  @override
  String get settingsGeneralTitle => 'Geral';

  @override
  String get settingsDataTitle => 'Dados e armazenamento';

  @override
  String get settingsStoriesTitle => 'Histórias';

  @override
  String get settingsHelpTitle => 'Ajuda e sobre';

  @override
  String get weatherTitle => 'Tempo';

  @override
  String get weatherClear => 'Limpar';

  @override
  String get weatherPartlyCloudy => 'Parcialmente nublado';

  @override
  String get weatherCloudy => 'Nublado';

  @override
  String get weatherFog => 'Nevoeiro';

  @override
  String get weatherDrizzle => 'Chuvisco';

  @override
  String get weatherRain => 'Chuva';

  @override
  String get weatherSnow => 'Neve';

  @override
  String get weatherStorm => 'Tempestade';

  @override
  String get weatherFetch => 'Obtenha a previsão do tempo para esta entrada';

  @override
  String get weatherNeedsLocation =>
      'Adicione primeiro um local com coordenadas.';

  @override
  String get weatherUnavailable =>
      'O tempo não está disponível para este local e horário.';

  @override
  String get weatherRemove => 'Remover clima';

  @override
  String get weatherTemperature => 'Temperatura';

  @override
  String get activityStill => 'Ainda assim';

  @override
  String get activityWalking => 'Caminhando';

  @override
  String get activityRunning => 'Correndo';

  @override
  String get activityCycling => 'Ciclismo';

  @override
  String get activityVehicle => 'Num veículo';

  @override
  String get activityFlying => 'Voando';

  @override
  String get activityExercise => 'Exercício';

  @override
  String get settingsAutoAddTitle => 'Adicionar automaticamente';

  @override
  String get settingsAutoAddLocation => 'Localização';

  @override
  String get settingsAutoAddWeather => 'Tempo';

  @override
  String get settingsAutoAddHint =>
      'As novas entradas são preenchidas quando são criadas.';

  @override
  String get settingsTemperatureUnit => 'Unidade de temperatura';

  @override
  String get settingsCelsius => 'Celsius (°C)';

  @override
  String get settingsFahrenheit => 'Fahrenheit (°F)';

  @override
  String get moodGreat => 'Ótimo';

  @override
  String get moodGood => 'Bom';

  @override
  String get moodOkay => 'Ok';

  @override
  String get moodBad => 'Ruim';

  @override
  String get moodAwful => 'Horrível';

  @override
  String get locationSearchHint => 'Procure um lugar';

  @override
  String get locationSearchEmpty => 'Nenhum lugar encontrado';

  @override
  String get settingsWallpaper => 'Papel de parede';

  @override
  String get wallpaperNone => 'Nenhum';

  @override
  String get wallpaperDots => 'Pontos';

  @override
  String get wallpaperGrid => 'Grade';

  @override
  String get wallpaperLines => 'Linhas';

  @override
  String get wallpaperPhoto => 'Foto…';

  @override
  String get settingsFontFamily => 'Fonte';

  @override
  String get fontSystem => 'Sistema';

  @override
  String get fontSerif => 'Serif';

  @override
  String get fontMono => 'Monoespaçado';

  @override
  String get settingsFontSize => 'Tamanho da fonte';

  @override
  String get fontSizeSmall => 'Pequeno';

  @override
  String get fontSizeMedium => 'Médio';

  @override
  String get fontSizeLarge => 'Grande';

  @override
  String get fontSizeExtraLarge => 'Extra grande';

  @override
  String get settingsLineSpacing => 'Espaçamento entre linhas';

  @override
  String get lineSpacingCompact => 'Compacto';

  @override
  String get lineSpacingNormal => 'Normais';

  @override
  String get lineSpacingRelaxed => 'Descontraído';

  @override
  String get moodAssociationsTitle => 'O que me faz sentir…';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching de entradas $total';
  }

  @override
  String get videoRecord => 'Grave um vídeo';

  @override
  String get videoChoose => 'Escolha um vídeo';

  @override
  String get audioRecordTitle => 'Grave uma nota de voz';

  @override
  String get audioChoose => 'Escolha um ficheiro de áudio';

  @override
  String get audioStart => 'Gravar';

  @override
  String get audioStop => 'Pare e poupe';

  @override
  String get audioPermissionDenied =>
      'O acesso ao microfone está desativado. Permita isso nas definições do sistema.';

  @override
  String get mediaTooLarge => 'Este vídeo é demasiado grande para ser anexado.';

  @override
  String get mediaUnavailable =>
      'Este anexo não está disponível neste dispositivo.';

  @override
  String get widgetDone => 'A entrada de hoje está escrita';

  @override
  String get widgetPending => 'Como foi o seu dia?';

  @override
  String get widgetWrite => 'Escreva';

  @override
  String get insertChecklist => 'Lista de verificação';

  @override
  String get insertNumberedList => 'Lista numerada';

  @override
  String get insertTable => 'Mesa';

  @override
  String get insertDivider => 'Divisor';

  @override
  String get insertCodeBlock => 'Bloco de código';

  @override
  String get journalSortTitle => 'Classificar entradas';

  @override
  String get journalSortUpdated => 'Última atualização';

  @override
  String get settingsTimeFormat => 'Formato de hora';

  @override
  String get settingsDayStart =>
      'As novas entradas contam para o dia anterior até';

  @override
  String get settingsDayAskUntil => 'Depois pergunte que dia até';

  @override
  String get settingsDayStartMidnight => 'Desligado';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Cada entrada mantém o dia a que pertence próximo da hora a que foi escrita, e pode alterar esse dia no editor a qualquer momento. Estes horários escolhem apenas o dia para novas entradas, pelo que alterá-los não move nenhuma entrada existente.';

  @override
  String get lateNightBadge =>
      'Escrito a altas horas da noite, contado no dia anterior';

  @override
  String editorDayAsk(String time) {
    return 'Escrito em $time. Para que dia é?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (ontem)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (hoje)';
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
  String get settingsReminderDays => 'Lembre-me em';

  @override
  String get locationRecent => 'Lugares recentes';

  @override
  String get shareImage => 'Partilhar imagem';

  @override
  String get shareSaveImage => 'Guardar imagem';

  @override
  String get shareSaved => 'Imagem guardada';

  @override
  String get deletedTitle => 'Excluído recentemente';

  @override
  String get deletedNone => 'Nada excluído recentemente';

  @override
  String deletedHint(int days) {
    return 'As entradas eliminadas permanecem aqui durante $days dias e depois são apagadas.';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days restantes dias';
  }

  @override
  String get deletedRestore => 'Restaurar';

  @override
  String get deletedDeleteForever => 'Excluir definitivamente';

  @override
  String get deletedDeleteForeverDescription =>
      'A entrada e os seus anexos são apagados. Isto não pode ser desfeito.';

  @override
  String get deletedEmpty => 'Vazio';

  @override
  String get deletedEmptyDescription =>
      'Apagar todas as entradas em Eliminadas recentemente? Isto não pode ser desfeito.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Caminhada aleatória';

  @override
  String get randomSubtitle => 'Abra uma entrada anterior';

  @override
  String get randomNext => 'Outro';

  @override
  String get randomAll => 'Todos';

  @override
  String get randomWithPhotos => 'Com fotos';

  @override
  String get randomGoodDays => 'Bons dias';

  @override
  String get randomEmpty => 'Sem entrada para escolher';

  @override
  String get reviewWeekTitle => 'Esta semana';

  @override
  String get reviewWeekSubtitle => 'A sua semana até agora';

  @override
  String get reviewYearTitle => 'Este ano';

  @override
  String get reviewEmpty => 'Nada escrito ainda';

  @override
  String get reviewEntries => 'Entradas';

  @override
  String get reviewDaysWritten => 'Dias escritos';

  @override
  String get reviewWords => 'Palavras';

  @override
  String get reviewPhotos => 'Fotos';

  @override
  String get reviewLongestRun => 'O maior período de dias';

  @override
  String get reviewAverageMood => 'Humor médio';

  @override
  String get reviewFavorites => 'Na maioria das vezes';

  @override
  String get reviewByMonth => 'Por mês';

  @override
  String get reviewHighlight => 'Destaque';

  @override
  String get yearInPixels => 'Ano em pixels';

  @override
  String get capsuleSeal => 'Selo como uma cápsula do tempo';

  @override
  String get capsuleTitle => 'Cápsula do tempo';

  @override
  String capsuleOpensOn(Object date) {
    return 'Abre em $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Escrito em $date';
  }

  @override
  String get capsuleOpenEarly => 'Abra mais cedo';

  @override
  String get capsuleOpenEarlyDescription =>
      'A cápsula abre agora e permanece aberta.';

  @override
  String get capsuleOpened => 'Cápsula do tempo aberta';

  @override
  String get templateMorningName => 'Páginas matinais';

  @override
  String get templateMorningDescription => 'Configure o dia em três minutos';

  @override
  String get templateMorningText =>
      '## Três coisas que quero fazer bem hoje\n1. \n2. \n3. \n\n## Algo que estou ansioso por\n\n## Uma nota para mim mesmo\n';

  @override
  String get templateEveningName => 'Revisão noturna';

  @override
  String get templateEveningDescription => 'Feche o dia com o que correu bem';

  @override
  String get templateEveningText =>
      '## Três coisas boas hoje\n1. \n2. \n3. \n\n## O que aprendi\n\n## O que poderia ser melhor amanhã\n';

  @override
  String get routineMorning => 'Bom dia';

  @override
  String get routineEvening => 'Revisão noturna';

  @override
  String get settingsRoutinePrompts => 'Avisos de manhã e à noite';

  @override
  String get settingsRoutinePromptsHint =>
      'Sugira o modelo matinal ou noturno nas Stories';

  @override
  String get checkInTitle => 'Check-in rápido';

  @override
  String get checkInSubtitle => 'Humor em dois toques';

  @override
  String get checkInMood => 'Como se sente?';

  @override
  String get checkInActivity => 'O que está a fazer?';

  @override
  String get checkInNote => 'Uma linha sobre isso (opcional)';

  @override
  String get checkInSave => 'Salvar';

  @override
  String editorWordCount(int words, int characters) {
    return 'Palavras $words · Caracteres $characters';
  }

  @override
  String get coachProgramEverydayTagline =>
      'Observe as pequenas coisas num dia.';

  @override
  String get coachProgramReflectTagline => 'Abrande e ouça-se a si mesmo.';

  @override
  String get coachDuration => 'Duração';

  @override
  String get coachInterval => 'Intervalo';

  @override
  String get coachDifficulty => 'Dificuldade';

  @override
  String get coachIntervalDaily => 'Diariamente';

  @override
  String get coachIntervalWeekly => 'Semanalmente';

  @override
  String get coachDifficultyBeginner => 'Iniciante';

  @override
  String get coachDifficultyIntermediate => 'Intermediário';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias',
      one: '$count dias',
      many: '$count dias',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count semanas',
      one: '$count semanas',
      many: '$count semanas',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'Dia $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Semana $n';
  }

  @override
  String get coachEnroll => 'Inscreva-se';

  @override
  String get coachEndProgram => 'Finalizar programa';

  @override
  String get coachAuthor => 'Autor';

  @override
  String get coachAuthorBio => 'Prompts escritos para esta aplicação.';

  @override
  String get coachEnrolledTip =>
      'Tudo pronto! As suas perguntas aparecerão nos Stories.';

  @override
  String get coachGoToStories => 'Ir para histórias';

  @override
  String get coachAnswerHint => 'Escreva a sua resposta…';

  @override
  String get storyWrapUp => 'Por hoje é tudo.';

  @override
  String get storyTapToClose => 'Toque para fechar';

  @override
  String get coachAnswerDone => 'Concluído';

  @override
  String get coachAnswered => 'Respondido, toque para abrir';

  @override
  String get coachAnsweredEarlier => 'Respondido';

  @override
  String get locationLocating => 'Localizando…';

  @override
  String get locationPickPlace => 'Escolha um lugar';

  @override
  String get locationPlacesHint => 'Endereço ou nome do local';

  @override
  String get locationCustom => 'Local personalizado';

  @override
  String get locationCurrent => 'Localização atual';

  @override
  String get locationSaved => 'Lugares salvos';

  @override
  String get locationSearchResults => 'Resultados da pesquisa';

  @override
  String get locationNearby => 'Lugares próximos';

  @override
  String get locationRename => 'Renomear';

  @override
  String get locationSavePlace => 'Guardar lugar';

  @override
  String get locationUnsavePlace => 'Remover dos locais guardados';

  @override
  String get shareAs => 'Partilhar como…';

  @override
  String get shareAsImage => 'Imagem';

  @override
  String get shareAsZip => 'ZIP com o suporte original';

  @override
  String get shareAsPlainText => 'Texto simples';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Bem-vindo ao AID Diary';

  @override
  String get onboardWelcomeText =>
      'Comece aqui ou ligue este dispositivo a um que já utilize.';

  @override
  String get onboardStart => 'Comece a escrever';

  @override
  String get helpFaq => 'Perguntas frequentes';

  @override
  String get helpFaq1Q => 'Onde está armazenado o meu diário?';

  @override
  String get helpFaq1A =>
      'O seu diário está armazenado neste dispositivo. Chega a outros dispositivos ou armazenamento apenas quando ativa a sincronização, partilha ou exporta. A sincronização é encriptada de ponta a ponta.';

  @override
  String get helpFaq2Q =>
      'Como mantenho uma cópia ou mudo para um novo dispositivo?';

  @override
  String get helpFaq2A =>
      'Ligue a um dispositivo existente em Definições → Dados e armazenamento → Sincronizar e confirme a autorização no dispositivo que contém o seu diário. Ambos os dispositivos permanecem utilizáveis. Também pode criar um backup e restaurá-lo noutro dispositivo.';

  @override
  String get helpFaq3Q =>
      'Posso trazer entradas de outras aplicações de diário?';

  @override
  String get helpFaq3A =>
      'Sim: em Definições → Dados e armazenamento, importe exportações de Daylio, Diarium, Diaro, DayBook, My Brain, OneShot e Pixels ou uma exportação JSON.';

  @override
  String get helpFaq4Q => 'Como funcionam os programas de coaching?';

  @override
  String get helpFaq4A =>
      'Inscreva-se num programa na página do Coach. A cada dia ou semana uma nova questão aguarda nas Stories; a sua resposta é guardada como uma entrada.';

  @override
  String get helpFaq5Q => 'E se me esquecer da minha senha?';

  @override
  String get helpFaq5A =>
      'A palavra-passe não pode ser recuperada, por isso mantenha um backup do seu diário.';

  @override
  String get helpPrivacy => 'Privacidade';

  @override
  String get helpPrivacyText =>
      'O conteúdo e os suportes do diário permanecem neste dispositivo, a menos que ative a sincronização encriptada ou os partilhe/exporte. Os mapas, a pesquisa de localização e a previsão meteorológica utilizam os serviços configurados e enviam a localização ou a consulta de pesquisa necessária para esse pedido, e não o texto do diário.';

  @override
  String get photoMetaTitle => 'Usar os detalhes da foto?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Contar esta entrada para $date e definir o seu lugar para $place, conforme registado na foto?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Contar esta entrada para $date, quando a foto foi tirada?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Defina o local desta entrada para $place, onde a fotografia foi tirada?';
  }

  @override
  String get photoMetaApply => 'Use-os';

  @override
  String get quickWriteTitle => 'Escrita rápida';

  @override
  String get quickWriteText => 'Toque em para iniciar uma nova entrada.';

  @override
  String get settingsQuickWriteTitle => 'Gravação rápida em notificações';

  @override
  String get settingsQuickWriteDescription =>
      'Mantenha uma notificação que abre uma nova entrada.';

  @override
  String get settingsNudgesTitle => 'Cutuquem-me depois de um trecho tranquilo';

  @override
  String settingsNudgesDescription(int days) {
    return 'Um lembrete gentil quando não escreve há dias $days.';
  }

  @override
  String get nudgeTitle => 'Já faz algum tempo';

  @override
  String get nudgeMonday => 'Uma nova semana: de que está à espera?';

  @override
  String get nudgeTuesday => 'Duas linhas são suficientes. Como está hoje?';

  @override
  String get nudgeWednesday =>
      'A meio da semana. O que se destacou até ao momento?';

  @override
  String get nudgeThursday =>
      'Alguma coisa pequena que valha a pena guardar de hoje?';

  @override
  String get nudgeFriday => 'A semana está a terminar. Observe um bom momento.';

  @override
  String get nudgeSaturday => 'Um sábado lento é um bom dia para escrever.';

  @override
  String get nudgeSunday => 'Recorde a semana antes de terminar.';

  @override
  String get photoWidgetEmpty =>
      'As fotos que adicionar às entradas aparecem aqui.';

  @override
  String get channelReminders => 'Lembretes';

  @override
  String get channelOnThisDay => 'Neste dia';

  @override
  String get channelCoach => 'Solicitações do treinador';

  @override
  String get channelNudges => 'Cutucões depois de dias tranquilos';

  @override
  String get channelQuickWrite => 'Escrita rápida';

  @override
  String get channelBackup => 'Cópias de segurança';

  @override
  String get formatJsonExport => 'JSON (exportação AID Diary)';

  @override
  String get aboutModifiedNotice =>
      'Uma versão modificada do Daily You de Demizo e colaboradores. Não é a aplicação oficial do Daily You.';

  @override
  String get toolbarPhotos => 'Adicionar fotos';

  @override
  String get toolbarMedia => 'Fotos e vídeos';

  @override
  String get mediaFromGallery => 'Escolha na galeria';

  @override
  String get mediaFromFiles => 'Escolha entre os ficheiros';

  @override
  String get editorLeaveTitle => 'Guardar esta entrada?';

  @override
  String get editorLeaveDiscard => 'Não guarde';

  @override
  String get editorTitleHint => 'Título';

  @override
  String get editorLocating => 'Localizando…';

  @override
  String get toolbarVideo => 'Vídeo';

  @override
  String get toolbarAudio => 'Nota de voz';

  @override
  String get toolbarTags => 'Etiquetas';

  @override
  String get toolbarBulletList => 'Lista com marcadores';

  @override
  String get toolbarHeading => 'Título';

  @override
  String get toolbarBold => 'Ousado';

  @override
  String get toolbarItalic => 'Itálico';

  @override
  String get toolbarHighlight => 'Destaque';

  @override
  String get toolbarStrikethrough => 'Tachado';

  @override
  String get toolbarQuote => 'Citação';

  @override
  String get toolbarLink => 'Ligação';

  @override
  String get toolbarInsert => 'Inserir';

  @override
  String get toolbarUndo => 'Desfazer';

  @override
  String get toolbarRedo => 'Refazer';

  @override
  String get toolbarInsertDate => 'Insira a data';

  @override
  String get toolbarInsertTime => 'Introduza a hora';

  @override
  String get settingsSyncTitle => 'Sincronização na nuvem';

  @override
  String get syncOffDescription =>
      'Mantenha este diário igual em todos os seus dispositivos através do Google Drive ou de um servidor WebDAV, como o Nextcloud, Synology ou Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'Sincronizar com Google Drive';

  @override
  String get syncOrWebDav => 'Ou um servidor WebDAV';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn => 'Conectado. Pode voltar para AID Diary.';

  @override
  String get syncGoogleSignInAgain =>
      'O Google precisa que faça login novamente.';

  @override
  String get syncSignInAgain => 'Faça login novamente';

  @override
  String get settingsCommandLineTitle => 'Linha de comando';

  @override
  String get commandLineToggle => 'Interface de linha de comandos';

  @override
  String get commandLineToggleHint =>
      'Permite que o comando aid e outros programas neste dispositivo utilizem os comandos da aplicação.';

  @override
  String get commandLineAlwaysOn =>
      'Sempre ativo nas compilações de desenvolvimento.';

  @override
  String commandLineListening(int port) {
    return 'Escuta na porta $port';
  }

  @override
  String get commandPaletteTitle => 'Todos os comandos';

  @override
  String get commandPaletteSearch => 'Comandos de pesquisa';

  @override
  String get commandPaletteRun => 'Corre';

  @override
  String get commandPaletteConfirm =>
      'Isto não pode ser simplesmente desfeito. Executar?';

  @override
  String syncReceiving(int done, int total) {
    return 'Receber $done de $total…';
  }

  @override
  String syncSending(int done, int total) {
    return 'Envio $done de $total…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'O acesso a Google Drive não foi permitido. Ligue-se novamente e marque Google Drive na página do Google.';

  @override
  String get syncEntryUnsynced =>
      'Não sincronizado: a última sincronização não foi realizada';

  @override
  String get syncUseOfficial => 'Utilize o servidor de sincronização AID';

  @override
  String get syncServer => 'Endereço do servidor';

  @override
  String get syncUsername => 'Nome de utilizador';

  @override
  String get syncPassword => 'Senha';

  @override
  String get syncConnect => 'Conectar';

  @override
  String get syncConnecting => 'Conectando…';

  @override
  String get syncSignInFailed =>
      'Não foi possível fazer login. Verifique o endereço, o nome de utilizador e a palavra-passe.';

  @override
  String syncConnectFailed(String error) {
    return 'Não foi possível ligar: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Comece a sincronizar';

  @override
  String get syncNewSpaceDescription =>
      'Ainda não há aqui um diário sincronizado. Este diário será carregado, encriptado de ponta a ponta com uma chave que permanece nos seus dispositivos.';

  @override
  String get syncJoinTitle => 'Junte-se ao diário sincronizado';

  @override
  String get syncWrongKey =>
      'Este código de recuperação não abre o diário sincronizado.';

  @override
  String syncLastSynced(String time) {
    return 'Última sincronização $time';
  }

  @override
  String get syncNever => 'Ainda não sincronizado';

  @override
  String get syncSyncing => 'Sincronizando…';

  @override
  String syncFailed(String error) {
    return 'A última sincronização falhou: $error';
  }

  @override
  String get syncLocked =>
      'O diário sincronizado pertence agora a outros dispositivos ou foi reiniciado. Emparelhe com um deles ou utilize o código de recuperação para continuar a sincronizar.';

  @override
  String get syncNow => 'Sincronize agora';

  @override
  String get syncUnlock => 'Desbloquear';

  @override
  String get syncEncrypted => 'Encriptado de ponta a ponta';

  @override
  String get syncDisconnect => 'Pare de sincronizar';

  @override
  String get syncDisconnectDescription =>
      'Este dispositivo interrompe a sincronização. O diário aqui e a cópia sincronizada permanecem como estão.';

  @override
  String get syncOwnRecoveryPassword =>
      'Usar a minha própria palavra-passe de recuperação';

  @override
  String get syncRecoveryPassword => 'Senha de recuperação';

  @override
  String get syncRecoveryPasswordRepeat =>
      'Repita a palavra-passe de recuperação';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Utilize pelo menos caracteres $min';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'As palavras-passe diferem';

  @override
  String get syncRecoveryCode => 'Código de recuperação';

  @override
  String get syncRecoveryCodeTitle => 'Guarde o seu código de recuperação';

  @override
  String get syncRecoveryCodeDescription =>
      'Se todos os seus dispositivos forem perdidos, este código restaura o seu diário sincronizado. Mantenha-o num gestor de senhas ou em papel. É mostrado apenas uma vez.';

  @override
  String get syncRecoveryCodeCopied => 'Código de recuperação copiado';

  @override
  String get syncRecoveryCodeSaved => 'eu salvei';

  @override
  String get syncJoinNeedsKey =>
      'Este diário sincronizado pertence aos seus outros dispositivos. Emparelhe com um deles ou utilize o código de recuperação. As entradas neste dispositivo serão adicionadas ao mesmo.';

  @override
  String get syncPairDevice => 'Emparelhar com um dispositivo';

  @override
  String get syncUseRecoveryCode => 'Utilize o código de recuperação';

  @override
  String get syncAddDevice => 'Adicionar um dispositivo';

  @override
  String get syncChangeRecoveryCode => 'Alterar o código de recuperação';

  @override
  String get syncChangeRecoveryDescription =>
      'Um novo código substitui o atual, que deixa de funcionar. Os seus dados e outros dispositivos permanecem como estão.';

  @override
  String get syncNewRandomCode => 'Novo código aleatório';

  @override
  String get syncRecoveryCodeChanged => 'Código de recuperação alterado';

  @override
  String get syncResetSpace => 'Reiniciar o diário sincronizado';

  @override
  String get syncResetSpaceDescription =>
      'Apenas quando nenhum dispositivo e nenhum código de recuperação o abre: a cópia sincronizada é substituída pelo diário neste dispositivo, nas chaves deste dispositivo. Os seus outros dispositivos serão emparelhados novamente.';

  @override
  String get syncPairTitle => 'Emparelhar dispositivos';

  @override
  String get syncPairShow => 'Mostrar um código';

  @override
  String get syncPairEnter => 'Introduza um código';

  @override
  String get syncPairShowHint =>
      'No outro dispositivo, abra o Emparelhar dispositivos, escolha Introduzir um código e introduza ou digitalize-o.';

  @override
  String get syncPairEnterHint =>
      'Introduza o código que o seu outro dispositivo mostra ou digitalize-o.';

  @override
  String get syncPairCode => 'Código de emparelhamento';

  @override
  String get syncPairScan => 'Digitalizar';

  @override
  String get syncPairStart => 'Par';

  @override
  String get syncPairWaiting => 'A aguardar o outro dispositivo…';

  @override
  String syncPairDone(String device) {
    return 'Emparelhado com $device';
  }

  @override
  String get syncPairWrongCode =>
      'O código não correspondeu. Mostre um novo código e tente novamente.';

  @override
  String get syncPairNoOffer =>
      'Nenhum dispositivo mostra este código. Pode ter expirado.';

  @override
  String get syncPairTimedOut => 'O outro dispositivo não respondeu a tempo.';

  @override
  String get syncPairNeither =>
      'Nenhum dos dispositivos está ainda configurado com este diário sincronizado.';

  @override
  String get syncPairBoth =>
      'Ambos os dispositivos já abrem este diário sincronizado.';

  @override
  String syncPairFailed(String error) {
    return 'Falha no emparelhamento: $error';
  }

  @override
  String get syncMediaPending =>
      'Diário sincronizado · alguns suportes ainda estão a ser transferidos';

  @override
  String get syncWaitingForDevices =>
      'Diário sincronizado · aguardando outro dispositivo transferir media';

  @override
  String get syncCacheNotice =>
      'A comunicação social na nuvem é temporária. Mantenha os originais nos seus dispositivos; a sincronização não é um backup.';

  @override
  String get paperTitle => 'Papel carta';

  @override
  String get paperPlain => 'Simples';

  @override
  String get paperLined => 'Forrado';

  @override
  String get paperGrid => 'Grade';

  @override
  String get paperTinted => 'Matizado';

  @override
  String get paperDecorationTitle => 'Decorações';

  @override
  String get paperDecorationNone => 'Nenhum';

  @override
  String get paperDecorationBotanical => 'Folhas';

  @override
  String get paperDecorationStars => 'Estrelas';

  @override
  String get paperDecorationWashi => 'Fita Washi';

  @override
  String get themeDarkChoice => 'Aparência escura';

  @override
  String get themeDarkSame => 'Siga a paleta de luz';

  @override
  String get themeDarkCustom => 'Paleta separada';

  @override
  String get themeDarkAccent => 'Cor de destaque escura';

  @override
  String get themeColorTeal => 'Azul-petróleo';

  @override
  String get themeColorCyan => 'Ciano';

  @override
  String get themeColorIndigo => 'Índigo';

  @override
  String get themeColorCoral => 'Coral';

  @override
  String get themeColorOlive => 'azeitona';

  @override
  String get themeColorSlate => 'Ardósia';

  @override
  String get drawingTitle => 'Desenho';

  @override
  String get drawingPen => 'Caneta';

  @override
  String get drawingEraser => 'Borracha';

  @override
  String get drawingUndo => 'Desfazer';

  @override
  String get drawingClear => 'Limpar';

  @override
  String get drawingWidth => 'Largura da caneta';

  @override
  String get drawingStylusOnly => 'Somente caneta';

  @override
  String get drawingDiscardTitle => 'Descartar desenho?';

  @override
  String get drawingDiscardBody => 'Este desenho não foi guardado.';

  @override
  String get drawingSaveError => 'Não foi possível guardar o desenho.';

  @override
  String get syncNetworkTitle => 'Diagnóstico de rede';

  @override
  String get syncNetworkRefresh => 'Atualizar';

  @override
  String get syncNetworkSelectedRoute => 'Caminho atual';

  @override
  String get syncNetworkAvailableRoutes => 'Caminhos disponíveis';

  @override
  String get syncNetworkSignaling => 'Ligação de diretório de dispositivos';

  @override
  String get syncNetworkRelayRemaining => 'Subsídio de retransmissão restante';

  @override
  String get syncNetworkIcePair => 'Candidatos de ligação direta';

  @override
  String get syncNetworkPeerTrusted => 'Dispositivo autenticado';

  @override
  String get syncNetworkNoRoute => 'Esperando por uma ligação';

  @override
  String get syncNetworkUnavailable => 'Os diagnósticos não estão disponíveis';

  @override
  String get syncMediaCopiesTitle => 'Entrega de suportes e cópias';

  @override
  String get syncMediaPendingCount => 'Aguarda transferência';

  @override
  String get syncMediaDurableCount => 'Entregue em armazenamento pessoal';

  @override
  String get syncMediaTemporaryCount => 'Cópias temporárias ou não confirmadas';

  @override
  String get syncMediaReceiptExplanation =>
      'Estas contagens descrevem as entregas concluídas, e não uma nova auditoria dos backups sobreviventes.';

  @override
  String get syncMediaCacheExplanation =>
      'A mídia temporária na nuvem pode expirar. Mantenha os seus originais ou um backup separado.';

  @override
  String get momentsTitle => 'Momentos fotográficos';

  @override
  String get momentsHint =>
      'Encontre grupos utilizando horários locais para fotografias e coordenadas opcionais. As fotos são anexadas apenas quando escolhe um cartão.';

  @override
  String get momentsScan => 'Encontre momentos';

  @override
  String get momentsChooseFolder => 'Escolha a pasta de fotografias';

  @override
  String get momentsLocation => 'Incluir locais de fotos';

  @override
  String get momentsEmpty => 'Nenhum grupo de fotos recentes.';

  @override
  String get momentsCreate => 'Escreva sobre estas fotos';

  @override
  String get momentsDismiss => 'Dispensar';

  @override
  String get momentsError => 'Não foi possível ler fotos locais.';

  @override
  String get momentsCreated => 'Entrada de fotografia criada.';

  @override
  String get momentsPermission =>
      'Permita o acesso às fotos para encontrar sugestões locais.';

  @override
  String get momentsScope =>
      'Apenas fotos recentes; máximo 500 fotos e 20 fotos por cartão.';

  @override
  String momentsPhotoCount(int count) {
    return 'Fotos $count';
  }

  @override
  String get nearbyTitle => 'Conectar dispositivos';

  @override
  String get nearbySend => 'Autorizar outro dispositivo';

  @override
  String get nearbyReceive => 'Ligue-se a um dispositivo existente';

  @override
  String get nearbyInstructions =>
      'Ligue ambos os dispositivos ao mesmo Wi-Fi ou ao ponto de acesso um do outro. Confirme a autorização no dispositivo existente; ambos os dispositivos permanecem utilizáveis. Não é necessária internet.';

  @override
  String get nearbyCompare =>
      'Compare este código nos dois dispositivos antes de aprovar.';

  @override
  String get nearbyConfirm => 'Os códigos correspondem';

  @override
  String get nearbyScan => 'Digitalizar o código do outro dispositivo';

  @override
  String get nearbyPaste => 'Colar convite';

  @override
  String get nearbyWaiting => 'Aguarda aprovação no outro dispositivo';

  @override
  String get nearbyWorking =>
      'Autorizando e sincronizando o seu diário e anexos…';

  @override
  String get nearbyPending =>
      'Alguns anexos ainda precisam de sincronização. Mantenha o outro dispositivo online e tente novamente.';

  @override
  String get nearbyComplete =>
      'Dispositivo ligado; diário e anexos sincronizados';

  @override
  String get nearbyFailed =>
      'A ligação não foi concluída. Verifique a ligação local e tente novamente.';

  @override
  String get nearbyEmptyRequired =>
      'Utilize um dispositivo com um diário vazio que ainda não esteja ligado para sincronização.';

  @override
  String get nearbyRetry => 'Continuar a sincronizar';

  @override
  String get nearbyWifi => 'Configurações Wi-Fi';

  @override
  String get nearbyHotspot => 'Configurações do ponto de acesso';

  @override
  String get nearbyKeepOpen =>
      'Mantenha esta página aberta até que o novo dispositivo esteja concluído. O convite expira ao fim de dois minutos.';

  @override
  String get syncDevicesTitle => 'Dispositivos autorizados';

  @override
  String get syncDevicesDescription =>
      'Apenas os dispositivos aprovados podem aceder a esta conta AID. A revogação de um dispositivo bloqueia o servidor, mas não pode apagar uma chave mestra ou um diário já copiado para o mesmo.';

  @override
  String get syncDeviceRequest =>
      'Mostrar este QR de autorização para um dispositivo aprovado';

  @override
  String get syncDeviceAuthorize => 'Autorizar um dispositivo';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Digitalize ou cole o pedido de autorização do novo dispositivo.';

  @override
  String get syncDeviceRevoke => 'Revogar';

  @override
  String get syncDeviceRotate => 'Rode a chave de assinatura deste dispositivo';

  @override
  String get syncDeviceCheck => 'Verifique a autorização';

  @override
  String get syncDeviceHardware => 'Chave de assinatura apoiada por hardware';

  @override
  String get syncDeviceSoftware =>
      'Chave de assinatura de software não exportável';

  @override
  String get syncDeviceUnavailable =>
      'A autorização do dispositivo não está disponível. Aprove este dispositivo a partir de outro dispositivo autorizado e tente novamente.';

  @override
  String get syncDeviceRevoked => 'Revogado';

  @override
  String get syncDeviceLocal => 'Este dispositivo';

  @override
  String get cloudTrafficTitle =>
      'Quota mensal de transferência de dados na nuvem para ficheiros de média';

  @override
  String get cloudTrafficLimit => 'Quota mensal de transferência de dados';

  @override
  String get cloudTrafficUsed => 'Transferência de dados utilizada';

  @override
  String get cloudTrafficRemaining => 'Transferência de dados restante';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'A quota de transferência de dados é reposta $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'A quota de transferência de dados na nuvem para ficheiros de média foi esgotada. Os ficheiros de média em falta serão sincronizados automaticamente quando uma ligação direta estiver disponível ou a quota for reposta.';

  @override
  String get cloudTrafficExplanation =>
      'A cache de ficheiros de média e a retransmissão ao vivo partilham esta quota de transferência de dados. As ligações diretas não o consomem. O texto do diário e as mensagens de controlo de ligação têm pequenos limites diários separados.';

  @override
  String get appearanceThemeSection => 'Tema da aplicação';

  @override
  String get appearancePaperSection => 'Papel diário';

  @override
  String get appearanceTypographySection => 'Texto do diário';

  @override
  String get appearancePreferencesSection => 'Preferências gerais';

  @override
  String get themeSystemAccentHint =>
      'Utiliza a paleta do sistema em vez de cores personalizadas. Desligue-o para escolher o seu próprio.';

  @override
  String get syncDeviceNameSaveFailed =>
      'Não foi possível guardar o nome do dispositivo. Por favor, tente novamente.';

  @override
  String get nearbyConnectionHelp => 'Ajuda de ligação';

  @override
  String get syncAllSynced => 'Tudo sincronizado';

  @override
  String get syncDetailsTitle => 'Detalhes de sincronização';

  @override
  String get syncMore => 'Mais opções';

  @override
  String get syncDeviceName => 'Nome do dispositivo';

  @override
  String get syncDeviceNameHint => 'Por exemplo: O meu tablet';

  @override
  String get syncDeviceNameInvalid => 'Utilize de 1 a 32 caracteres';

  @override
  String get syncDeviceKeyDetails => 'Detalhes de segurança';

  @override
  String get syncConnectionProblem =>
      'Não é possível sincronizar de momento. Tentando novamente automaticamente.';

  @override
  String get syncCopyComplete =>
      'Cópia completa do seu diário e ficheiros de média';

  @override
  String get syncCopyPartial => 'Algumas mídias ainda estão em falta';

  @override
  String get syncCopyOlder =>
      'Novas alterações estão a aguardar para serem sincronizadas';

  @override
  String get syncCopyUnavailable =>
      'Os detalhes da cópia não estão disponíveis. Tente novamente mais tarde.';

  @override
  String get syncCopyLastKnown =>
      'Outros dispositivos mostram a sua última cópia confirmada. Os dispositivos offline não podem ser verificados agora.';

  @override
  String get syncCopyTemporary =>
      'Cache temporário. Mantenha os originais nos seus dispositivos.';

  @override
  String get syncCopyStorage =>
      'O seu armazenamento de sincronização. Os carregamentos de suportes concluídos são listados em diagnósticos.';

  @override
  String syncCopyChecked(String time) {
    return 'Último $time confirmado';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Transferência de dados restantes deste mês: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Comece aqui';

  @override
  String get onboardConnect => 'Ligue-se a um dispositivo existente';

  @override
  String get onboardFailed =>
      'A configuração não pôde ser concluída. O seu diário está seguro; por favor tente novamente.';

  @override
  String get tutorialTitle => 'Como usar o diário';

  @override
  String get tutorialWriteTitle => 'Escreva a sua primeira entrada no diário';

  @override
  String get tutorialWriteText =>
      'Toque em + para escrever uma entrada no diário. Adicione um título opcional, escolha a data do diário e toque na marca de verificação para guardar. Pode editar a sua entrada no diário novamente a qualquer momento.';

  @override
  String get tutorialMediaTitle => 'Adicione fotos, áudio ou manuscrito';

  @override
  String get tutorialMediaText =>
      'Utilize + no editor de diário para anexar fotografias, vídeos ou uma gravação de voz, ou para abrir o ecrã de escrita à mão. Estes anexos são guardados com a entrada do diário.';

  @override
  String get tutorialReviewTitle => 'Encontre novamente um dia';

  @override
  String get tutorialReviewText =>
      'Navegue no seu diário ou calendário, pesquise os seus escritos e organize entradas com etiquetas. As páginas Media e Atlas permitem encontrar entradas anteriores por foto ou localização.';

  @override
  String get tutorialSyncTitle => 'Utilize mais de um dispositivo';

  @override
  String get tutorialSyncText =>
      'Em Definições → Dados e armazenamento → Sincronizar, ligue-se a um dispositivo existente e confirme a autorização nesse dispositivo. Ambos os dispositivos podem continuar a utilizar o diário. O texto do diário é sincronizado em primeiro lugar. Os ficheiros de média serão sincronizados em seguida quando a ligação de rede e a quota restante de transferência de dados o permitirem.';

  @override
  String get tutorialPrivacyTitle => 'Mantenha o seu diário seguro';

  @override
  String get tutorialPrivacyText =>
      'As entradas do diário permanecem neste dispositivo, a menos que ative a sincronização, partilhe ou exporte-as. A sincronização é encriptada de ponta a ponta. Em Definições também pode definir uma palavra-passe de aplicação, criar cópias de segurança e reabrir este tutorial.';

  @override
  String get editorDiaryDay => 'Dia do diário';

  @override
  String get editorDiaryDayPicker =>
      'Dia do diário · A que dia pertence esta entrada?';

  @override
  String editorCreatedAt(String time) {
    return 'Criada $time';
  }

  @override
  String get editorDiaryDayHint =>
      'O dia a que pertence esta entrada. Alterá-lo não muda a data nem a hora de criação.';

  @override
  String get hiddenDiaryTitle => 'Entradas ocultas';

  @override
  String get hiddenDiaryHide => 'Ocultar entrada';

  @override
  String get hiddenDiaryShow => 'Mostrar entrada';

  @override
  String get hiddenDiaryEmpty => 'Sem entradas ocultas';

  @override
  String get hiddenDiaryUnlock => 'Desbloquear entradas ocultas';

  @override
  String get hiddenDiaryAuthHint =>
      'Utiliza o bloqueio da aplicação ou do ecrã do dispositivo.';

  @override
  String hiddenDiaryWhere(String path) {
    return 'Ocultada. Para voltar a mostrar: $path';
  }

  @override
  String get noteKeep => 'Guardar';

  @override
  String get noteComment => 'Comentar';

  @override
  String get noteCommentHint => 'Escreve ao teu eu do passado';

  @override
  String get noteKept => 'Excerto guardado';

  @override
  String get notesPassages => 'Excertos guardados';

  @override
  String get notesComments => 'Comentários';

  @override
  String get noteDeleteConfirm => 'Eliminar esta nota?';

  @override
  String get editPastTitle => 'Editar uma memória passada?';

  @override
  String get editPastBody =>
      'Esta entrada é de um dia anterior. Para lhe responder, seleciona texto para o guardar ou comentar.';

  @override
  String get editPastDontAsk => 'Não perguntar outra vez';

  @override
  String get editPastEdit => 'Editar mesmo assim';

  @override
  String noteOnEntry(String date) {
    return 'Sobre a entrada de $date';
  }

  @override
  String get settingsConfirmEditPast =>
      'Perguntar antes de editar entradas passadas';

  @override
  String get settingsCompressPhotos => 'Comprimir fotos novas';

  @override
  String get settingsCompressPhotosHint =>
      'Guardar as fotos novas como WebP de cerca de 1 MB. Desligado mantém os originais.';

  @override
  String get compressExistingTitle => 'Comprimir fotos existentes';

  @override
  String compressExistingBody(int count, String size) {
    return '$count fotos ocupam $size. As que passam de cerca de 1 MB passam a WebP de cerca de 1 MB. Isto substitui-as e não pode ser desfeito; guarda os originais noutro sítio se os quiseres.';
  }

  @override
  String get compressExistingAction => 'Comprimir';

  @override
  String compressExistingDone(int count, String size) {
    return '$count fotos comprimidas, $size poupados';
  }

  @override
  String get commentExpand => 'Expandir';

  @override
  String get refAdd => 'Citar uma entrada';

  @override
  String get refMissing => 'Essa entrada já não existe';

  @override
  String get moodClear => 'Limpar humor';

  @override
  String get scrollToTop => 'Voltar ao topo';

  @override
  String get feedbackTitle => 'Comentários';

  @override
  String get feedbackHint => 'Descreva um problema ou sugestão';

  @override
  String get feedbackSend => 'Enviar';

  @override
  String get feedbackSent => 'Obrigado, o seu comentário foi enviado.';

  @override
  String get feedbackSendFailed =>
      'Não foi possível enviar. Verifique a ligação e tente novamente.';

  @override
  String get feedbackOpenFailed => 'Não foi possível abrir a aplicação.';

  @override
  String get feedbackSendNote =>
      'Enviado para o servidor do AID Diary com a versão e o idioma da aplicação, nada do seu diário.';

  @override
  String get feedbackGithub => 'Problema no GitHub';

  @override
  String get feedbackEmail => 'Enviar e-mail';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => 'Cor do tema';

  @override
  String get themeColorHint => 'Escolha uma cor para esta paleta.';

  @override
  String get themeColorBlue => 'Céu azul';

  @override
  String get themeColorGreen => 'Verde floresta';

  @override
  String get themeColorBrown => 'Café quente';

  @override
  String get themeColorPurple => 'Lavanda';

  @override
  String get themeColorRose => 'Rosa empoeirada';

  @override
  String get themeColorAmber => 'Âmbar';

  @override
  String get themeColorPreview => 'Um pouco todos os dias';

  @override
  String get themeTintBackgroundTitle => 'Tingir fundos com a cor do tema';

  @override
  String get themeTintBackgroundHint =>
      'Desligue para fundos cinza neutros; os botões mantêm a cor escolhida.';

  @override
  String get dailyReminderTitle => 'Registre hoje!';

  @override
  String get dailyReminderDescription => 'Faça o seu registro diário…';

  @override
  String get actionTakePhoto => 'Tirar uma foto';

  @override
  String get flashbacksTitle => 'Recordações';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Excluir dias ruins';

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
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias',
      one: '$count dias',
      many: '$count dias',
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
  String chartOverTimeTitle(Object tag) {
    return '$tag ao longo do tempo';
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
  String get chartSmoothingLabel => 'Suavização';

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
      other: 'Ótimos dias $count',
      one: 'Ótimos dias $count',
      many: 'Ótimos dias $count',
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
  String get settingsShowFlashbacks => 'Mostrar Flashbacks';

  @override
  String get settingsChangeMoodIcons => 'Alterar Ícones de Humor';

  @override
  String get moodIconPrompt => 'Insira um ícone';

  @override
  String get settingsHideImages => 'Ocultar Imagens';

  @override
  String get pageCalendarTitle => 'Calendário';

  @override
  String get settingsNotificationsTitle => 'Notificações';

  @override
  String get settingsDailyReminderTitle => 'Lembrete Diário';

  @override
  String get settingsOnThisDayDescription => 'Revisite memórias passadas';

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
  String get manageTemplates => 'Gerenciar Modelos';

  @override
  String get noTemplateTitle => 'Nenhum';

  @override
  String get noTemplatesDescription => 'Nenhum modelo criado ainda…';

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
  String get settingsTagsTitle => 'Etiquetas';

  @override
  String get manageTags => 'Gerenciar tags';

  @override
  String get tagTypeLabelTitle => 'Etiqueta';

  @override
  String get tagTypeTrackerTitle => 'Rastreador';

  @override
  String get nameHint => 'Nome';

  @override
  String get tagColorLabel => 'Cor';

  @override
  String get iconPickerTitle => 'Escolha o ícone';

  @override
  String get iconPickerIconsTab => 'Ícones';

  @override
  String get iconPickerCustomTab => 'Personalizado';

  @override
  String get iconPickerSearchHint => 'Ícones de pesquisa…';

  @override
  String get colorPickerTitle => 'Escolha a cor';

  @override
  String get colorPickerPaletteTab => 'Cores';

  @override
  String get iconGroupMoodPeople => 'Humor e Pessoas';

  @override
  String get iconGroupHealth => 'Saúde';

  @override
  String get iconGroupWorkFinance => 'Trabalho e Finanças';

  @override
  String get iconGroupHabitsGoals => 'Hábitos e objetivos';

  @override
  String get iconGroupNature => 'Natureza';

  @override
  String get iconGroupFoodDrink => 'Comida e bebida';

  @override
  String get iconGroupHome => 'Página inicial';

  @override
  String get iconGroupTravel => 'Viajar';

  @override
  String get iconGroupSymbols => 'Símbolos';

  @override
  String get tagCategoryLabel => 'Categoria';

  @override
  String get tagLabel => 'Etiqueta';

  @override
  String get tagCategoryUncategorized => 'Sem categoria';

  @override
  String get newCategoryTitle => 'Nova categoria';

  @override
  String get shareButtonLabel => 'Compartilhar';

  @override
  String get importErrorDescription => 'Falha ao importar arquivo!';

  @override
  String get exportErrorDescription => 'Falha ao exportar arquivo!';

  @override
  String get deleteTitle => 'Excluir';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' É usado em $count entradas do diário.',
      one: ' É usado em $count entradas do diário.',
      many: ' É usado em $count de entradas do diário.',
      zero: '',
    );
    return 'Excluir \"$name\"?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Suas $count tags também serão excluídas.',
      one: ' Suas tags $count também serão excluídas.',
      many: ' Suas $count tags também serão excluídas.',
      zero: '',
    );
    return 'Excluir \"$name\"?$_temp0';
  }

  @override
  String get tagNameExists => 'Já existe uma tag com esse nome';

  @override
  String get categoryNameExists => 'Já existe uma categoria com este nome';

  @override
  String deleteTemplateMessage(Object name) {
    return 'Excluir \"$name\"?';
  }

  @override
  String get addTagsTitle => 'Adicionar tags';

  @override
  String get addTagsSearchHint => 'Pesquisar tags…';

  @override
  String get tagsRecent => 'Usadas recentemente';

  @override
  String get tagNew => 'Nova tag';

  @override
  String get tagFavoriteName => 'Favorito';

  @override
  String get iconGroupActivities => 'Atividades';

  @override
  String get iconGroupHobbies => 'Entretenimento';

  @override
  String get settingsStorageTitle => 'Armazenamento';

  @override
  String get settingsLogFolder => 'Pasta de Registros';

  @override
  String get settingsImageFolder => 'Pasta de Imagens';

  @override
  String get warningTitle => 'Aviso';

  @override
  String get logFolderWarningDescription =>
      'Se a pasta selecionada já contiver um arquivo \'aid_diary.db\', ele será usado para substituir seus registros existentes!';

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
  String get settingsBackupPasswordProtect => 'Backups protegidos por senha';

  @override
  String get backupEncryptedTitle => 'Backup criptografado';

  @override
  String get backupEncryptedContent => 'Este backup é protegido por senha.';

  @override
  String get settingsAutoBackup => 'Backups Automáticos';

  @override
  String get settingsAutoBackupLocation => 'Local de backup';

  @override
  String get settingsAutoBackupInterval => 'Intervalo de backup';

  @override
  String get settingsAutoBackupIntervalDaily => 'Diariamente';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Semanalmente';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Mensalmente';

  @override
  String get settingsAutoBackupMaxCount => 'Backups para manter';

  @override
  String get settingsAutoBackupRequireCharging =>
      'Somente durante o carregamento';

  @override
  String settingsBackupLast(Object time) {
    return 'Último backup $time';
  }

  @override
  String get settingsBackupNever => 'Nunca fiz backup';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Próximo backup $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'Todos';

  @override
  String get autoBackupFailedTitle => 'Falha no backup';

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
  String encryptingBackupStatus(Object percent) {
    return 'Criptografando backup… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Descriptografando backup… $percent%';
  }

  @override
  String get cleanUpStatus => 'Limpando…';

  @override
  String get settingsExportToAnotherFormat => 'Exportar Para Outro Formato';

  @override
  String get settingsExportFormatDescription =>
      'Isso não deve ser usado como backup!';

  @override
  String get settingsImportFromAnotherApp => 'Importar de Outro Aplicativo';

  @override
  String get logFormatTitle => 'Escolher Formato';

  @override
  String get logFormatDescription =>
      'O formato de outro aplicativo pode não suportar todas as funcionalidades. Por favor, informe qualquer problemas, pois os formatos de terceiros podem mudar a qualquer momento. Isto não irá impactar os registros existentes!';

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
  String get settingsDeleteAllLogsTitle => 'Apagar Todos os Registros';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Você quer apagar todos os seus registros?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Digite \'$prompt\' para confirmar. Isto não pode ser desfeito!';
  }

  @override
  String get settingsAppLanguageTitle => 'Linguagem do Aplicativo';

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
  String get settingsOpenSourceLicenses => 'Licenças de código aberto';

  @override
  String get tagMoodTitle => 'Humor';

  @override
  String get selectTagTitle => 'Selecione a etiqueta';

  @override
  String get labelPresentLabel => 'Presente';

  @override
  String get labelAbsentLabel => 'Ausente';

  @override
  String get labelCoverageLabel => 'Cobertura';

  @override
  String chartDistributionTitle(Object tag) {
    return 'Distribuição $tag';
  }

  @override
  String get shareAddToLogPickerTitle => 'Escolha uma entrada do diário';

  @override
  String get adaptiveEmptyDay => 'Ainda não há entradas para este dia';

  @override
  String get adaptiveNewEntry => 'Escreva uma entrada';

  @override
  String get pageJournalTitle => 'Diário';

  @override
  String get coachPrompt1 => 'O que fez você sorrir hoje?';

  @override
  String get coachPrompt2 => 'O que você aprendeu hoje?';

  @override
  String get coachPrompt3 => 'Com quem você conversou hoje e como se sentiu?';

  @override
  String get coachPrompt4 => 'Pelo que você está grato agora?';

  @override
  String get coachPrompt5 =>
      'O que consumiu a maior parte da sua energia hoje?';

  @override
  String get coachPrompt6 =>
      'Descreva um pequeno momento que você deseja lembrar.';

  @override
  String get coachPrompt7 => 'O que faria de amanhã um bom dia?';

  @override
  String get coachPrompt8 => 'O que tem passado pela sua cabeça ultimamente?';

  @override
  String get coachPrompt9 => 'O que você fez hoje só para você?';

  @override
  String get coachPrompt10 => 'Se hoje tivesse um título, qual seria?';

  @override
  String get pageMediaTitle => 'Mídia';

  @override
  String get pageAtlasTitle => 'Atlas';

  @override
  String get pageCoachTitle => 'Treinador';

  @override
  String get noEntrySelected => 'Nenhuma entrada selecionada.';

  @override
  String get entryShare => 'Compartilhar';

  @override
  String get entryFavorite => 'Estrela';

  @override
  String get entryEdit => 'Editar';

  @override
  String get entryPrevious => 'Entrada anterior';

  @override
  String get entryNext => 'Próxima entrada';

  @override
  String get journalStories => 'Histórias';

  @override
  String get journalEntries => 'Entradas';

  @override
  String get journalEmptyHint =>
      'Comece seu diário adicionando uma nova entrada.';

  @override
  String get storyToday => 'Hoje';

  @override
  String get storyThrowback => 'Retrocesso';

  @override
  String get storyNoThrowback => 'Sem retrocesso hoje';

  @override
  String get mediaFiles => 'Arquivos de mídia';

  @override
  String get mediaEmpty => 'Ainda não há fotos.';

  @override
  String get mediaEmptyHint =>
      'As fotos anexadas às inscrições serão mostradas aqui.';

  @override
  String get atlasEmpty => 'Nenhuma entrada com localização.';

  @override
  String get atlasEmptyHint => 'As entradas com um local serão mostradas aqui.';

  @override
  String get atlasShowAll => 'Mostrar todas as entradas';

  @override
  String get atlasMyLocation => 'Minha localização';

  @override
  String get coachAll => 'Todos';

  @override
  String get coachPrograms => 'Programas';

  @override
  String get coachTemplates => 'Modelos';

  @override
  String get coachKindProgram => 'Programa';

  @override
  String get coachKindTemplate => 'Modelo';

  @override
  String get coachNoTemplates => 'Sem programas ou modelos.';

  @override
  String get coachUseTemplate => 'Escreva com este modelo';

  @override
  String get coachProgramEverydayTitle => 'Momentos do dia a dia';

  @override
  String get coachProgramEverydayDescription =>
      'Cinco perguntas curtas, uma por dia. Cada um leva um ou dois minutos e ajuda você a ver o que tornou o dia seu. Uma maneira gentil de criar o hábito de escrever um pouco todos os dias.';

  @override
  String get coachProgramReflectTitle => 'Olhando para dentro';

  @override
  String get coachProgramReflectDescription =>
      'Uma pergunta mais profunda por semana, durante cinco semanas. Não tenha pressa com cada um: como você está se sentindo, o que o desgasta, pelo que você é grato.';

  @override
  String get searchFilters => 'Filtros';

  @override
  String get searchFilterTags => 'Etiquetas';

  @override
  String get searchFilterStarred => 'Com estrela';

  @override
  String get searchHint => 'Digite para pesquisar ou escolha um filtro.';

  @override
  String get locationTitle => 'Localização';

  @override
  String get locationName => 'Nome do lugar';

  @override
  String get locationRemove => 'Remover';

  @override
  String get locationServiceDisabled =>
      'Os serviços de localização estão desativados.';

  @override
  String get locationPermissionDenied =>
      'A permissão de localização foi negada.';

  @override
  String get locationUnavailable =>
      'Não foi possível obter a localização atual.';

  @override
  String get calendarJumpToToday => 'Ir para hoje';

  @override
  String get editorStartWriting => 'Comece a escrever ou escolha um ';

  @override
  String get editorTemplateLink => 'Modelo';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Escolha um modelo';

  @override
  String get templateFeatured => 'Modelos em destaque';

  @override
  String get templateMine => 'Meus modelos';

  @override
  String get templateDailyName => 'Revisão diária';

  @override
  String get templateDailyDescription =>
      'O que aconteceu, como foi e o que vem a seguir.';

  @override
  String get templateDailyText =>
      '## O que aconteceu hoje\n\n\n##Como eu me senti\n\n\n## Três coisas pelas quais sou grato\n1. \n2. \n3. \n\n## Amanhã\n';

  @override
  String get templateTravelName => 'Entrada no diário de viagem';

  @override
  String get templateTravelDescription =>
      'Lugares, momentos e comida da estrada.';

  @override
  String get templateTravelText =>
      '##Onde eu fui\n\n\n## O momento que mais me lembro\n\n\n## O que eu comi\n\n\n## Planos para amanhã\n';

  @override
  String get templateReadingName => 'Notas de leitura';

  @override
  String get templateReadingDescription =>
      'Citações e pensamentos do que você leu.';

  @override
  String get templateReadingText =>
      '## Livro\n\n\n## Onde estou\n\n\n## Citações\n> \n\n## Meus pensamentos\n';

  @override
  String get templateWeeklyName => 'Revisão semanal';

  @override
  String get templateWeeklyDescription =>
      'Destaques, lutas e foco da próxima semana.';

  @override
  String get templateWeeklyText =>
      '## Destaques\n\n\n## O que foi difícil\n\n\n## O que aprendi\n\n\n## Foco para a próxima semana\n';

  @override
  String get entrySaveAsTemplate => 'Salvar como modelo';

  @override
  String get entrySavedAsTemplate => 'Salvo como modelo';

  @override
  String get storyStatistics => 'Estatísticas';

  @override
  String get storyMoodChart => 'Gráfico de humor';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return 'Entradas $entries · Dias $days';
  }

  @override
  String get storyThisYear => 'Este ano';

  @override
  String get storyLastYear => 'Ano passado';

  @override
  String get storyTapToOpen => 'Toque em um dia para abri-lo';

  @override
  String get settingsGeneralTitle => 'Geral';

  @override
  String get settingsDataTitle => 'Dados e armazenamento';

  @override
  String get settingsStoriesTitle => 'Histórias';

  @override
  String get settingsHelpTitle => 'Ajuda e sobre';

  @override
  String get weatherTitle => 'Tempo';

  @override
  String get weatherClear => 'Limpar';

  @override
  String get weatherPartlyCloudy => 'Parcialmente nublado';

  @override
  String get weatherCloudy => 'Nublado';

  @override
  String get weatherFog => 'Nevoeiro';

  @override
  String get weatherDrizzle => 'Chuvisco';

  @override
  String get weatherRain => 'Chuva';

  @override
  String get weatherSnow => 'Neve';

  @override
  String get weatherStorm => 'Tempestade';

  @override
  String get weatherFetch => 'Obtenha a previsão do tempo para esta entrada';

  @override
  String get weatherNeedsLocation =>
      'Adicione um local com coordenadas primeiro.';

  @override
  String get weatherUnavailable =>
      'O clima não está disponível para este local e horário.';

  @override
  String get weatherRemove => 'Remover clima';

  @override
  String get weatherTemperature => 'Temperatura';

  @override
  String get activityStill => 'Ainda assim';

  @override
  String get activityWalking => 'Caminhando';

  @override
  String get activityRunning => 'Correndo';

  @override
  String get activityCycling => 'Ciclismo';

  @override
  String get activityVehicle => 'Em um veículo';

  @override
  String get activityFlying => 'Voando';

  @override
  String get activityExercise => 'Exercício';

  @override
  String get settingsAutoAddTitle => 'Adicionar automaticamente';

  @override
  String get settingsAutoAddLocation => 'Localização';

  @override
  String get settingsAutoAddWeather => 'Tempo';

  @override
  String get settingsAutoAddHint =>
      'Novas entradas são preenchidas quando são criadas.';

  @override
  String get settingsTemperatureUnit => 'Unidade de temperatura';

  @override
  String get settingsCelsius => 'Celsius (°C)';

  @override
  String get settingsFahrenheit => 'Fahrenheit (°F)';

  @override
  String get moodGreat => 'Ótimo';

  @override
  String get moodGood => 'Bom';

  @override
  String get moodOkay => 'Ok';

  @override
  String get moodBad => 'Ruim';

  @override
  String get moodAwful => 'Horrível';

  @override
  String get locationSearchHint => 'Procure um lugar';

  @override
  String get locationSearchEmpty => 'Nenhum lugar encontrado';

  @override
  String get settingsWallpaper => 'Papel de parede';

  @override
  String get wallpaperNone => 'Nenhum';

  @override
  String get wallpaperDots => 'Pontos';

  @override
  String get wallpaperGrid => 'Grade';

  @override
  String get wallpaperLines => 'Linhas';

  @override
  String get wallpaperPhoto => 'Foto…';

  @override
  String get settingsFontFamily => 'Fonte';

  @override
  String get fontSystem => 'Sistema';

  @override
  String get fontSerif => 'Serif';

  @override
  String get fontMono => 'Monoespaçado';

  @override
  String get settingsFontSize => 'Tamanho da fonte';

  @override
  String get fontSizeSmall => 'Pequeno';

  @override
  String get fontSizeMedium => 'Médio';

  @override
  String get fontSizeLarge => 'Grande';

  @override
  String get fontSizeExtraLarge => 'Extra grande';

  @override
  String get settingsLineSpacing => 'Espaçamento entre linhas';

  @override
  String get lineSpacingCompact => 'Compacto';

  @override
  String get lineSpacingNormal => 'Normais';

  @override
  String get lineSpacingRelaxed => 'Descontraído';

  @override
  String get moodAssociationsTitle => 'O que me faz sentir…';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching de entradas $total';
  }

  @override
  String get videoRecord => 'Grave um vídeo';

  @override
  String get videoChoose => 'Escolha um vídeo';

  @override
  String get audioRecordTitle => 'Grave uma nota de voz';

  @override
  String get audioChoose => 'Escolha um arquivo de áudio';

  @override
  String get audioStart => 'Gravar';

  @override
  String get audioStop => 'Pare e economize';

  @override
  String get audioPermissionDenied =>
      'O acesso ao microfone está desativado. Permita isso nas configurações do sistema.';

  @override
  String get mediaTooLarge => 'Este vídeo é muito grande para ser anexado.';

  @override
  String get mediaUnavailable =>
      'Este anexo não está disponível neste dispositivo.';

  @override
  String get widgetDone => 'A entrada de hoje está escrita';

  @override
  String get widgetPending => 'Como foi seu dia?';

  @override
  String get widgetWrite => 'Escreva';

  @override
  String get insertChecklist => 'Lista de verificação';

  @override
  String get insertNumberedList => 'Lista numerada';

  @override
  String get insertTable => 'Mesa';

  @override
  String get insertDivider => 'Divisor';

  @override
  String get insertCodeBlock => 'Bloco de código';

  @override
  String get journalSortTitle => 'Classificar entradas';

  @override
  String get journalSortUpdated => 'Última atualização';

  @override
  String get settingsTimeFormat => 'Formato de hora';

  @override
  String get settingsDayStart =>
      'Novas entradas contam para o dia anterior até';

  @override
  String get settingsDayAskUntil => 'Então pergunte que dia até';

  @override
  String get settingsDayStartMidnight => 'Desligado';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Cada entrada mantém o dia ao qual pertence próximo ao horário em que foi escrita, e você pode alterar esse dia no editor a qualquer momento. Esses horários escolhem apenas o dia para novas entradas, portanto, alterá-los não move nenhuma entrada existente.';

  @override
  String get lateNightBadge =>
      'Escrito tarde da noite, contado no dia anterior';

  @override
  String editorDayAsk(String time) {
    return 'Escrito em $time. Para que dia é?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (ontem)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (hoje)';
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
  String get settingsReminderDays => 'Lembre-me em';

  @override
  String get locationRecent => 'Lugares recentes';

  @override
  String get shareImage => 'Compartilhar imagem';

  @override
  String get shareSaveImage => 'Salvar imagem';

  @override
  String get shareSaved => 'Imagem salva';

  @override
  String get deletedTitle => 'Excluído recentemente';

  @override
  String get deletedNone => 'Nada excluído recentemente';

  @override
  String deletedHint(int days) {
    return 'As entradas excluídas permanecem aqui por $days dias e depois são apagadas.';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days dias restantes';
  }

  @override
  String get deletedRestore => 'Restaurar';

  @override
  String get deletedDeleteForever => 'Excluir definitivamente';

  @override
  String get deletedDeleteForeverDescription =>
      'A entrada e seus anexos são apagados. Isto não pode ser desfeito.';

  @override
  String get deletedEmpty => 'Vazio';

  @override
  String get deletedEmptyDescription =>
      'Apagar todas as entradas em Excluídas recentemente? Isto não pode ser desfeito.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Caminhada aleatória';

  @override
  String get randomSubtitle => 'Abra uma entrada anterior';

  @override
  String get randomNext => 'Outro';

  @override
  String get randomAll => 'Todos';

  @override
  String get randomWithPhotos => 'Com fotos';

  @override
  String get randomGoodDays => 'Bons dias';

  @override
  String get randomEmpty => 'Nenhuma entrada para escolher';

  @override
  String get reviewWeekTitle => 'Esta semana';

  @override
  String get reviewWeekSubtitle => 'Sua semana até agora';

  @override
  String get reviewYearTitle => 'Este ano';

  @override
  String get reviewEmpty => 'Nada escrito ainda';

  @override
  String get reviewEntries => 'Entradas';

  @override
  String get reviewDaysWritten => 'Dias escritos';

  @override
  String get reviewWords => 'Palavras';

  @override
  String get reviewPhotos => 'Fotos';

  @override
  String get reviewLongestRun => 'O maior período de dias';

  @override
  String get reviewAverageMood => 'Humor médio';

  @override
  String get reviewFavorites => 'Na maioria das vezes';

  @override
  String get reviewByMonth => 'Por mês';

  @override
  String get reviewHighlight => 'Destaque';

  @override
  String get yearInPixels => 'Ano em pixels';

  @override
  String get capsuleSeal => 'Selo como uma cápsula do tempo';

  @override
  String get capsuleTitle => 'Cápsula do tempo';

  @override
  String capsuleOpensOn(Object date) {
    return 'Abre em $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Escrito em $date';
  }

  @override
  String get capsuleOpenEarly => 'Abra mais cedo';

  @override
  String get capsuleOpenEarlyDescription =>
      'A cápsula abre agora e permanece aberta.';

  @override
  String get capsuleOpened => 'Cápsula do tempo aberta';

  @override
  String get templateMorningName => 'Páginas matinais';

  @override
  String get templateMorningDescription => 'Configure o dia em três minutos';

  @override
  String get templateMorningText =>
      '## Três coisas que quero fazer bem hoje\n1. \n2. \n3. \n\n## Algo que estou ansioso para\n\n## Uma nota para mim mesmo\n';

  @override
  String get templateEveningName => 'Revisão noturna';

  @override
  String get templateEveningDescription => 'Feche o dia com o que deu certo';

  @override
  String get templateEveningText =>
      '## Três coisas boas hoje\n1. \n2. \n3. \n\n## O que aprendi\n\n## O que poderia ser melhor amanhã\n';

  @override
  String get routineMorning => 'Bom dia';

  @override
  String get routineEvening => 'Revisão noturna';

  @override
  String get settingsRoutinePrompts => 'Avisos de manhã e à noite';

  @override
  String get settingsRoutinePromptsHint =>
      'Sugira o modelo matinal ou noturno nos Stories';

  @override
  String get checkInTitle => 'Check-in rápido';

  @override
  String get checkInSubtitle => 'Humor em dois toques';

  @override
  String get checkInMood => 'Como você se sente?';

  @override
  String get checkInActivity => 'O que você está fazendo?';

  @override
  String get checkInNote => 'Uma linha sobre isso (opcional)';

  @override
  String get checkInSave => 'Salvar';

  @override
  String editorWordCount(int words, int characters) {
    return 'Palavras $words · Caracteres $characters';
  }

  @override
  String get coachProgramEverydayTagline =>
      'Observe as pequenas coisas em um dia.';

  @override
  String get coachProgramReflectTagline => 'Desacelere e ouça a si mesmo.';

  @override
  String get coachDuration => 'Duração';

  @override
  String get coachInterval => 'Intervalo';

  @override
  String get coachDifficulty => 'Dificuldade';

  @override
  String get coachIntervalDaily => 'Diariamente';

  @override
  String get coachIntervalWeekly => 'Semanalmente';

  @override
  String get coachDifficultyBeginner => 'Iniciante';

  @override
  String get coachDifficultyIntermediate => 'Intermediário';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias',
      one: '$count dias',
      many: '$count dias',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count semanas',
      one: '$count semanas',
      many: '$count semanas',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'Dia $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Semana $n';
  }

  @override
  String get coachEnroll => 'Inscreva-se';

  @override
  String get coachEndProgram => 'Finalizar programa';

  @override
  String get coachAuthor => 'Autor';

  @override
  String get coachAuthorBio => 'Prompts escritos para este aplicativo.';

  @override
  String get coachEnrolledTip =>
      'Tudo pronto! Suas perguntas aparecerão nos Stories.';

  @override
  String get coachGoToStories => 'Ir para histórias';

  @override
  String get coachAnswerHint => 'Escreva sua resposta…';

  @override
  String get storyWrapUp => 'Isso é tudo por hoje.';

  @override
  String get storyTapToClose => 'Toque para fechar';

  @override
  String get coachAnswerDone => 'Concluído';

  @override
  String get coachAnswered => 'Respondido, toque para abrir';

  @override
  String get coachAnsweredEarlier => 'Respondido';

  @override
  String get locationLocating => 'Localizando…';

  @override
  String get locationPickPlace => 'Escolha um lugar';

  @override
  String get locationPlacesHint => 'Endereço ou nome do local';

  @override
  String get locationCustom => 'Local personalizado';

  @override
  String get locationCurrent => 'Localização atual';

  @override
  String get locationSaved => 'Lugares salvos';

  @override
  String get locationSearchResults => 'Resultados da pesquisa';

  @override
  String get locationNearby => 'Lugares próximos';

  @override
  String get locationRename => 'Renomear';

  @override
  String get locationSavePlace => 'Salvar lugar';

  @override
  String get locationUnsavePlace => 'Remover dos lugares salvos';

  @override
  String get shareAs => 'Compartilhar como…';

  @override
  String get shareAsImage => 'Imagem';

  @override
  String get shareAsZip => 'ZIP com a mídia original';

  @override
  String get shareAsPlainText => 'Texto simples';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Bem-vindo ao AID Diary';

  @override
  String get onboardWelcomeText =>
      'Comece aqui ou conecte este dispositivo a um que você já usa.';

  @override
  String get onboardStart => 'Comece a escrever';

  @override
  String get helpFaq => 'Perguntas frequentes';

  @override
  String get helpFaq1Q => 'Onde meu diário está armazenado?';

  @override
  String get helpFaq1A =>
      'Seu diário está armazenado neste dispositivo. Ele alcança outros dispositivos ou armazenamento somente quando você ativa a sincronização, compartilha ou exporta. A sincronização é criptografada de ponta a ponta.';

  @override
  String get helpFaq2Q =>
      'Como mantenho uma cópia ou mudo para um novo dispositivo?';

  @override
  String get helpFaq2A =>
      'Conecte-se a um dispositivo existente em Configurações → Dados e armazenamento → Sincronizar e confirme a autorização no dispositivo que contém seu diário. Ambos os dispositivos permanecem utilizáveis. Você também pode criar um backup e restaurá-lo em outro dispositivo.';

  @override
  String get helpFaq3Q =>
      'Posso trazer entradas de outros aplicativos de diário?';

  @override
  String get helpFaq3A =>
      'Sim: em Configurações → Dados e armazenamento, importe exportações de Daylio, Diarium, Diaro, DayBook, My Brain, OneShot e Pixels ou uma exportação JSON.';

  @override
  String get helpFaq4Q => 'Como funcionam os programas de coaching?';

  @override
  String get helpFaq4A =>
      'Inscreva-se em um programa na página do Coach. A cada dia ou semana uma nova pergunta aguarda nos Stories; sua resposta é salva como uma entrada.';

  @override
  String get helpFaq5Q => 'E se eu esquecer minha senha?';

  @override
  String get helpFaq5A =>
      'A senha não pode ser recuperada, então mantenha um backup do seu diário.';

  @override
  String get helpPrivacy => 'Privacidade';

  @override
  String get helpPrivacyText =>
      'O conteúdo e a mídia do diário permanecem neste dispositivo, a menos que você ative a sincronização criptografada ou os compartilhe/exporte. Mapas, pesquisa de local e previsão do tempo usam os serviços configurados e enviam a localização ou a consulta de pesquisa necessária para essa solicitação, e não o texto do diário.';

  @override
  String get photoMetaTitle => 'Usar os detalhes da foto?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Contar esta entrada para $date e definir seu lugar para $place, conforme registrado na foto?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Contar esta entrada para $date, quando a foto foi tirada?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Defina o local desta entrada como $place, onde a foto foi tirada?';
  }

  @override
  String get photoMetaApply => 'Use-os';

  @override
  String get quickWriteTitle => 'Escrita rápida';

  @override
  String get quickWriteText => 'Toque para iniciar uma nova entrada.';

  @override
  String get settingsQuickWriteTitle => 'Gravação rápida em notificações';

  @override
  String get settingsQuickWriteDescription =>
      'Mantenha uma notificação que abre uma nova entrada.';

  @override
  String get settingsNudgesTitle => 'Cutuque-me depois de um trecho tranquilo';

  @override
  String settingsNudgesDescription(int days) {
    return 'Um lembrete gentil quando você não escreve há dias $days.';
  }

  @override
  String get nudgeTitle => 'Já faz um tempo';

  @override
  String get nudgeMonday => 'Uma nova semana: o que você está esperando?';

  @override
  String get nudgeTuesday =>
      'Duas linhas são suficientes. Como você está hoje?';

  @override
  String get nudgeWednesday =>
      'No meio da semana. O que se destacou até agora?';

  @override
  String get nudgeThursday =>
      'Alguma coisa pequena que valha a pena guardar de hoje?';

  @override
  String get nudgeFriday => 'A semana está terminando. Observe um bom momento.';

  @override
  String get nudgeSaturday => 'Um sábado lento é um bom dia para escrever.';

  @override
  String get nudgeSunday => 'Relembre a semana antes de terminar.';

  @override
  String get photoWidgetEmpty =>
      'As fotos que você adiciona às entradas aparecem aqui.';

  @override
  String get channelReminders => 'Lembretes';

  @override
  String get channelOnThisDay => 'Neste dia';

  @override
  String get channelCoach => 'Solicitações do treinador';

  @override
  String get channelNudges => 'Cutucões depois de dias tranquilos';

  @override
  String get channelQuickWrite => 'Escrita rápida';

  @override
  String get channelBackup => 'Cópias de segurança';

  @override
  String get formatJsonExport => 'JSON (exportação AID Diary)';

  @override
  String get aboutModifiedNotice =>
      'Uma versão modificada do Daily You de Demizo e colaboradores. Não é o aplicativo oficial do Daily You.';

  @override
  String get toolbarPhotos => 'Adicionar fotos';

  @override
  String get toolbarMedia => 'Fotos e vídeos';

  @override
  String get mediaFromGallery => 'Escolha na galeria';

  @override
  String get mediaFromFiles => 'Escolha entre os arquivos';

  @override
  String get editorLeaveTitle => 'Salvar esta entrada?';

  @override
  String get editorLeaveDiscard => 'Não salve';

  @override
  String get editorTitleHint => 'Título';

  @override
  String get editorLocating => 'Localizando…';

  @override
  String get toolbarVideo => 'Vídeo';

  @override
  String get toolbarAudio => 'Nota de voz';

  @override
  String get toolbarTags => 'Etiquetas';

  @override
  String get toolbarBulletList => 'Lista com marcadores';

  @override
  String get toolbarHeading => 'Título';

  @override
  String get toolbarBold => 'Ousado';

  @override
  String get toolbarItalic => 'Itálico';

  @override
  String get toolbarHighlight => 'Destaque';

  @override
  String get toolbarStrikethrough => 'Tachado';

  @override
  String get toolbarQuote => 'Citação';

  @override
  String get toolbarLink => 'Ligação';

  @override
  String get toolbarInsert => 'Inserir';

  @override
  String get toolbarUndo => 'Desfazer';

  @override
  String get toolbarRedo => 'Refazer';

  @override
  String get toolbarInsertDate => 'Insira a data';

  @override
  String get toolbarInsertTime => 'Insira a hora';

  @override
  String get settingsSyncTitle => 'Sincronização na nuvem';

  @override
  String get syncOffDescription =>
      'Mantenha este diário igual em todos os seus dispositivos por meio do Google Drive ou de um servidor WebDAV, como Nextcloud, Synology ou Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'Sincronizar com Google Drive';

  @override
  String get syncOrWebDav => 'Ou um servidor WebDAV';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn =>
      'Conectado. Você pode voltar para AID Diary.';

  @override
  String get syncGoogleSignInAgain =>
      'O Google precisa que você faça login novamente.';

  @override
  String get syncSignInAgain => 'Faça login novamente';

  @override
  String get settingsCommandLineTitle => 'Linha de comando';

  @override
  String get commandLineToggle => 'Interface de linha de comando';

  @override
  String get commandLineToggleHint =>
      'Permite que o comando aid e outros programas neste dispositivo usem os comandos do aplicativo.';

  @override
  String get commandLineAlwaysOn =>
      'Sempre ativo nas compilações de desenvolvimento.';

  @override
  String commandLineListening(int port) {
    return 'Escutando na porta $port';
  }

  @override
  String get commandPaletteTitle => 'Todos os comandos';

  @override
  String get commandPaletteSearch => 'Comandos de pesquisa';

  @override
  String get commandPaletteRun => 'Corre';

  @override
  String get commandPaletteConfirm =>
      'Isto não pode simplesmente ser desfeito. Executar?';

  @override
  String syncReceiving(int done, int total) {
    return 'Recebendo $done de $total…';
  }

  @override
  String syncSending(int done, int total) {
    return 'Enviando $done de $total…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'O acesso a Google Drive não foi permitido. Conecte-se novamente e marque Google Drive na página do Google.';

  @override
  String get syncEntryUnsynced =>
      'Não sincronizado: a última sincronização não foi realizada';

  @override
  String get syncUseOfficial => 'Use o servidor de sincronização AID';

  @override
  String get syncServer => 'Endereço do servidor';

  @override
  String get syncUsername => 'Nome de usuário';

  @override
  String get syncPassword => 'Senha';

  @override
  String get syncConnect => 'Conectar';

  @override
  String get syncConnecting => 'Conectando…';

  @override
  String get syncSignInFailed =>
      'Não foi possível fazer login. Verifique o endereço, o nome de usuário e a senha.';

  @override
  String syncConnectFailed(String error) {
    return 'Não foi possível conectar: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Comece a sincronizar';

  @override
  String get syncNewSpaceDescription =>
      'Ainda não há diário sincronizado aqui. Este diário será carregado, criptografado de ponta a ponta com uma chave que permanece em seus dispositivos.';

  @override
  String get syncJoinTitle => 'Junte-se ao diário sincronizado';

  @override
  String get syncWrongKey =>
      'Este código de recuperação não abre o diário sincronizado.';

  @override
  String syncLastSynced(String time) {
    return 'Última sincronização $time';
  }

  @override
  String get syncNever => 'Ainda não sincronizado';

  @override
  String get syncSyncing => 'Sincronizando…';

  @override
  String syncFailed(String error) {
    return 'A última sincronização falhou: $error';
  }

  @override
  String get syncLocked =>
      'O diário sincronizado agora pertence a outros dispositivos ou foi reiniciado. Emparelhe com um deles ou use o código de recuperação para continuar sincronizando.';

  @override
  String get syncNow => 'Sincronize agora';

  @override
  String get syncUnlock => 'Desbloquear';

  @override
  String get syncEncrypted => 'Criptografado de ponta a ponta';

  @override
  String get syncDisconnect => 'Pare de sincronizar';

  @override
  String get syncDisconnectDescription =>
      'Este dispositivo interrompe a sincronização. O diário aqui e a cópia sincronizada permanecem como estão.';

  @override
  String get syncOwnRecoveryPassword =>
      'Usar minha própria senha de recuperação';

  @override
  String get syncRecoveryPassword => 'Senha de recuperação';

  @override
  String get syncRecoveryPasswordRepeat => 'Repita a senha de recuperação';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Use pelo menos caracteres $min';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'As senhas diferem';

  @override
  String get syncRecoveryCode => 'Código de recuperação';

  @override
  String get syncRecoveryCodeTitle => 'Salve seu código de recuperação';

  @override
  String get syncRecoveryCodeDescription =>
      'Se todos os seus dispositivos forem perdidos, este código restaura seu diário sincronizado. Mantenha-o em um gerenciador de senhas ou em papel. É mostrado apenas uma vez.';

  @override
  String get syncRecoveryCodeCopied => 'Código de recuperação copiado';

  @override
  String get syncRecoveryCodeSaved => 'eu salvei';

  @override
  String get syncJoinNeedsKey =>
      'Este diário sincronizado pertence aos seus outros dispositivos. Emparelhe com um deles ou use o código de recuperação. As entradas neste dispositivo serão adicionadas a ele.';

  @override
  String get syncPairDevice => 'Emparelhar com um dispositivo';

  @override
  String get syncUseRecoveryCode => 'Use o código de recuperação';

  @override
  String get syncAddDevice => 'Adicionar um dispositivo';

  @override
  String get syncChangeRecoveryCode => 'Alterar o código de recuperação';

  @override
  String get syncChangeRecoveryDescription =>
      'Um novo código substitui o atual, que para de funcionar. Seus dados e outros dispositivos permanecem como estão.';

  @override
  String get syncNewRandomCode => 'Novo código aleatório';

  @override
  String get syncRecoveryCodeChanged => 'Código de recuperação alterado';

  @override
  String get syncResetSpace => 'Reiniciar o diário sincronizado';

  @override
  String get syncResetSpaceDescription =>
      'Somente quando nenhum dispositivo e nenhum código de recuperação o abre: a cópia sincronizada é substituída pelo diário neste dispositivo, nas chaves deste dispositivo. Seus outros dispositivos serão emparelhados novamente.';

  @override
  String get syncPairTitle => 'Emparelhar dispositivos';

  @override
  String get syncPairShow => 'Mostrar um código';

  @override
  String get syncPairEnter => 'Insira um código';

  @override
  String get syncPairShowHint =>
      'No outro dispositivo, abra Emparelhar dispositivos, escolha Insira um código e digite ou digitalize-o.';

  @override
  String get syncPairEnterHint =>
      'Digite o código que seu outro dispositivo mostra ou escaneie-o.';

  @override
  String get syncPairCode => 'Código de emparelhamento';

  @override
  String get syncPairScan => 'Digitalizar';

  @override
  String get syncPairStart => 'Par';

  @override
  String get syncPairWaiting => 'Aguardando o outro dispositivo…';

  @override
  String syncPairDone(String device) {
    return 'Emparelhado com $device';
  }

  @override
  String get syncPairWrongCode =>
      'O código não correspondeu. Mostre um novo código e tente novamente.';

  @override
  String get syncPairNoOffer =>
      'Nenhum dispositivo mostra este código. Pode ter expirado.';

  @override
  String get syncPairTimedOut => 'O outro dispositivo não respondeu a tempo.';

  @override
  String get syncPairNeither =>
      'Nenhum dos dispositivos está configurado com este diário sincronizado ainda.';

  @override
  String get syncPairBoth =>
      'Ambos os dispositivos já abrem este diário sincronizado.';

  @override
  String syncPairFailed(String error) {
    return 'Falha no emparelhamento: $error';
  }

  @override
  String get syncMediaPending =>
      'Diário sincronizado · algumas mídias ainda estão sendo transferidas';

  @override
  String get syncWaitingForDevices =>
      'Diário sincronizado · aguardando outro dispositivo transferir mídia';

  @override
  String get syncCacheNotice =>
      'A mídia na nuvem é temporária. Mantenha os originais em seus dispositivos; a sincronização não é um backup.';

  @override
  String get paperTitle => 'Papel carta';

  @override
  String get paperPlain => 'Simples';

  @override
  String get paperLined => 'Forrado';

  @override
  String get paperGrid => 'Grade';

  @override
  String get paperTinted => 'Matizado';

  @override
  String get paperDecorationTitle => 'Decorações';

  @override
  String get paperDecorationNone => 'Nenhum';

  @override
  String get paperDecorationBotanical => 'Folhas';

  @override
  String get paperDecorationStars => 'Estrelas';

  @override
  String get paperDecorationWashi => 'Fita Washi';

  @override
  String get themeDarkChoice => 'Aparência escura';

  @override
  String get themeDarkSame => 'Siga a paleta de luz';

  @override
  String get themeDarkCustom => 'Paleta separada';

  @override
  String get themeDarkAccent => 'Cor de destaque escura';

  @override
  String get themeColorTeal => 'Azul-petróleo';

  @override
  String get themeColorCyan => 'Ciano';

  @override
  String get themeColorIndigo => 'Índigo';

  @override
  String get themeColorCoral => 'Coral';

  @override
  String get themeColorOlive => 'azeitona';

  @override
  String get themeColorSlate => 'Ardósia';

  @override
  String get drawingTitle => 'Desenho';

  @override
  String get drawingPen => 'Caneta';

  @override
  String get drawingEraser => 'Borracha';

  @override
  String get drawingUndo => 'Desfazer';

  @override
  String get drawingClear => 'Limpar';

  @override
  String get drawingWidth => 'Largura da caneta';

  @override
  String get drawingStylusOnly => 'Somente caneta';

  @override
  String get drawingDiscardTitle => 'Descartar desenho?';

  @override
  String get drawingDiscardBody => 'Este desenho não foi salvo.';

  @override
  String get drawingSaveError => 'Não foi possível salvar o desenho.';

  @override
  String get syncNetworkTitle => 'Diagnóstico de rede';

  @override
  String get syncNetworkRefresh => 'Atualizar';

  @override
  String get syncNetworkSelectedRoute => 'Caminho atual';

  @override
  String get syncNetworkAvailableRoutes => 'Caminhos disponíveis';

  @override
  String get syncNetworkSignaling => 'Conexão de diretório de dispositivos';

  @override
  String get syncNetworkRelayRemaining => 'Subsídio de retransmissão restante';

  @override
  String get syncNetworkIcePair => 'Candidatos de conexão direta';

  @override
  String get syncNetworkPeerTrusted => 'Dispositivo autenticado';

  @override
  String get syncNetworkNoRoute => 'Esperando por uma conexão';

  @override
  String get syncNetworkUnavailable => 'Os diagnósticos não estão disponíveis';

  @override
  String get syncMediaCopiesTitle => 'Entrega de mídia e cópias';

  @override
  String get syncMediaPendingCount => 'Aguardando transferência';

  @override
  String get syncMediaDurableCount => 'Entregue em armazenamento pessoal';

  @override
  String get syncMediaTemporaryCount => 'Cópias temporárias ou não confirmadas';

  @override
  String get syncMediaReceiptExplanation =>
      'Essas contagens descrevem entregas concluídas, não uma nova auditoria dos backups sobreviventes.';

  @override
  String get syncMediaCacheExplanation =>
      'A mídia temporária na nuvem pode expirar. Mantenha seus originais ou um backup separado.';

  @override
  String get momentsTitle => 'Momentos fotográficos';

  @override
  String get momentsHint =>
      'Encontre grupos usando horários locais para fotos e coordenadas opcionais. As fotos são anexadas apenas quando você escolhe um cartão.';

  @override
  String get momentsScan => 'Encontre momentos';

  @override
  String get momentsChooseFolder => 'Escolha a pasta de fotos';

  @override
  String get momentsLocation => 'Incluir locais de fotos';

  @override
  String get momentsEmpty => 'Nenhum grupo de fotos recentes.';

  @override
  String get momentsCreate => 'Escreva sobre essas fotos';

  @override
  String get momentsDismiss => 'Dispensar';

  @override
  String get momentsError => 'Não foi possível ler fotos locais.';

  @override
  String get momentsCreated => 'Entrada de foto criada.';

  @override
  String get momentsPermission =>
      'Permita o acesso às fotos para encontrar sugestões locais.';

  @override
  String get momentsScope =>
      'Apenas fotos recentes; no máximo 500 fotos e 20 fotos por cartão.';

  @override
  String momentsPhotoCount(int count) {
    return 'Fotos $count';
  }

  @override
  String get nearbyTitle => 'Conectar dispositivos';

  @override
  String get nearbySend => 'Autorizar outro dispositivo';

  @override
  String get nearbyReceive => 'Conecte-se a um dispositivo existente';

  @override
  String get nearbyInstructions =>
      'Conecte ambos os dispositivos ao mesmo Wi-Fi ou ao ponto de acesso um do outro. Confirme a autorização no dispositivo existente; ambos os dispositivos permanecem utilizáveis. Não é necessária internet.';

  @override
  String get nearbyCompare =>
      'Compare este código nos dois dispositivos antes de aprovar.';

  @override
  String get nearbyConfirm => 'Os códigos correspondem';

  @override
  String get nearbyScan => 'Digitalize o código do outro dispositivo';

  @override
  String get nearbyPaste => 'Colar convite';

  @override
  String get nearbyWaiting => 'Aguardando aprovação no outro dispositivo';

  @override
  String get nearbyWorking =>
      'Autorizando e sincronizando seu diário e anexos…';

  @override
  String get nearbyPending =>
      'Alguns anexos ainda precisam de sincronização. Mantenha o outro dispositivo online e tente novamente.';

  @override
  String get nearbyComplete =>
      'Dispositivo conectado; diário e anexos sincronizados';

  @override
  String get nearbyFailed =>
      'A conexão não foi concluída. Verifique a conexão local e tente novamente.';

  @override
  String get nearbyEmptyRequired =>
      'Use um dispositivo com um diário vazio que ainda não esteja conectado para sincronização.';

  @override
  String get nearbyRetry => 'Continuar sincronizando';

  @override
  String get nearbyWifi => 'Configurações Wi-Fi';

  @override
  String get nearbyHotspot => 'Configurações de ponto de acesso';

  @override
  String get nearbyKeepOpen =>
      'Mantenha esta página aberta até que o novo dispositivo seja concluído. O convite expira após dois minutos.';

  @override
  String get syncDevicesTitle => 'Dispositivos autorizados';

  @override
  String get syncDevicesDescription =>
      'Somente dispositivos aprovados podem acessar esta conta AID. A revogação de um dispositivo bloqueia o servidor, mas não pode apagar uma chave mestra ou um diário já copiado para ele.';

  @override
  String get syncDeviceRequest =>
      'Mostre este QR de autorização para um dispositivo aprovado';

  @override
  String get syncDeviceAuthorize => 'Autorizar um dispositivo';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Digitalize ou cole a solicitação de autorização do novo dispositivo.';

  @override
  String get syncDeviceRevoke => 'Revogar';

  @override
  String get syncDeviceRotate => 'Gire a chave de assinatura deste dispositivo';

  @override
  String get syncDeviceCheck => 'Verifique a autorização';

  @override
  String get syncDeviceHardware => 'Chave de assinatura apoiada por hardware';

  @override
  String get syncDeviceSoftware =>
      'Chave de assinatura de software não exportável';

  @override
  String get syncDeviceUnavailable =>
      'A autorização do dispositivo não está disponível. Aprove este dispositivo de outro dispositivo autorizado e tente novamente.';

  @override
  String get syncDeviceRevoked => 'Revogado';

  @override
  String get syncDeviceLocal => 'Este dispositivo';

  @override
  String get cloudTrafficTitle =>
      'Cota mensal de transferência de dados na nuvem para arquivos de mídia';

  @override
  String get cloudTrafficLimit => 'Cota mensal de transferência de dados';

  @override
  String get cloudTrafficUsed => 'Transferência de dados usada';

  @override
  String get cloudTrafficRemaining => 'Transferência de dados restante';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'A cota de transferência de dados é redefinida $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'A cota de transferência de dados na nuvem para arquivos de mídia foi esgotada. Os arquivos de mídia ausentes serão sincronizados automaticamente quando uma conexão direta estiver disponível ou a cota for redefinida.';

  @override
  String get cloudTrafficExplanation =>
      'O cache de arquivos de mídia e a retransmissão ao vivo compartilham essa cota de transferência de dados. Conexões diretas não o consomem. O texto do diário e as mensagens de controle de conexão têm pequenos limites diários separados.';

  @override
  String get appearanceThemeSection => 'Tema do aplicativo';

  @override
  String get appearancePaperSection => 'Papel diário';

  @override
  String get appearanceTypographySection => 'Texto do diário';

  @override
  String get appearancePreferencesSection => 'Preferências gerais';

  @override
  String get themeSystemAccentHint =>
      'Usa a paleta do sistema em vez de cores personalizadas. Desligue-o para escolher o seu próprio.';

  @override
  String get syncDeviceNameSaveFailed =>
      'Não foi possível salvar o nome do dispositivo. Por favor, tente novamente.';

  @override
  String get nearbyConnectionHelp => 'Ajuda de conexão';

  @override
  String get syncAllSynced => 'Tudo sincronizado';

  @override
  String get syncDetailsTitle => 'Detalhes de sincronização';

  @override
  String get syncMore => 'Mais opções';

  @override
  String get syncDeviceName => 'Nome do dispositivo';

  @override
  String get syncDeviceNameHint => 'Por exemplo: Meu tablet';

  @override
  String get syncDeviceNameInvalid => 'Use de 1 a 32 caracteres';

  @override
  String get syncDeviceKeyDetails => 'Detalhes de segurança';

  @override
  String get syncConnectionProblem =>
      'Não é possível sincronizar no momento. Tentando novamente automaticamente.';

  @override
  String get syncCopyComplete =>
      'Cópia completa do seu diário e arquivos de mídia';

  @override
  String get syncCopyPartial => 'Algumas mídias ainda estão faltando';

  @override
  String get syncCopyOlder =>
      'Novas alterações estão aguardando para serem sincronizadas';

  @override
  String get syncCopyUnavailable =>
      'Os detalhes da cópia não estão disponíveis. Tente novamente mais tarde.';

  @override
  String get syncCopyLastKnown =>
      'Outros dispositivos mostram sua última cópia confirmada. Dispositivos offline não podem ser verificados agora.';

  @override
  String get syncCopyTemporary =>
      'Cache temporário. Mantenha os originais em seus dispositivos.';

  @override
  String get syncCopyStorage =>
      'Seu armazenamento de sincronização. Os uploads de mídia concluídos são listados em diagnósticos.';

  @override
  String syncCopyChecked(String time) {
    return 'Último $time confirmado';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Transferência de dados restantes deste mês: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Comece aqui';

  @override
  String get onboardConnect => 'Conecte-se a um dispositivo existente';

  @override
  String get onboardFailed =>
      'A configuração não pôde ser concluída. Seu diário está seguro; por favor tente novamente.';

  @override
  String get tutorialTitle => 'Como usar o diário';

  @override
  String get tutorialWriteTitle => 'Escreva sua primeira entrada no diário';

  @override
  String get tutorialWriteText =>
      'Toque em + para escrever uma entrada no diário. Adicione um título opcional, escolha a data do diário e toque na marca de seleção para salvar. Você pode editar sua entrada no diário novamente a qualquer momento.';

  @override
  String get tutorialMediaTitle => 'Adicione fotos, áudio ou manuscrito';

  @override
  String get tutorialMediaText =>
      'Use + no editor de diário para anexar fotos, vídeos ou uma gravação de voz, ou para abrir a tela de escrita à mão. Esses anexos são salvos com a entrada do diário.';

  @override
  String get tutorialReviewTitle => 'Encontre um dia novamente';

  @override
  String get tutorialReviewText =>
      'Navegue em seu diário ou calendário, pesquise seus escritos e organize entradas com tags. As páginas Mídia e Atlas permitem encontrar entradas anteriores por foto ou localização.';

  @override
  String get tutorialSyncTitle => 'Use mais de um dispositivo';

  @override
  String get tutorialSyncText =>
      'Em Configurações → Dados e armazenamento → Sincronizar, conecte-se a um dispositivo existente e confirme a autorização nesse dispositivo. Ambos os dispositivos podem continuar usando o diário. O texto do diário é sincronizado primeiro. Os arquivos de mídia serão sincronizados em seguida quando a conexão de rede e a cota restante de transferência de dados permitirem.';

  @override
  String get tutorialPrivacyTitle => 'Mantenha seu diário seguro';

  @override
  String get tutorialPrivacyText =>
      'As entradas do diário permanecem neste dispositivo, a menos que você ative a sincronização, compartilhe ou exporte-as. A sincronização é criptografada de ponta a ponta. Em Configurações você também pode definir uma senha de aplicativo, criar backups e reabrir este tutorial.';

  @override
  String get editorDiaryDay => 'Dia do diário';

  @override
  String get editorDiaryDayPicker =>
      'Dia do diário · A que dia pertence esta entrada?';

  @override
  String editorCreatedAt(String time) {
    return 'Criada $time';
  }

  @override
  String get editorDiaryDayHint =>
      'O dia ao qual esta entrada pertence. Alterá-lo não muda a data nem a hora de criação.';

  @override
  String get hiddenDiaryTitle => 'Entradas ocultas';

  @override
  String get hiddenDiaryHide => 'Ocultar entrada';

  @override
  String get hiddenDiaryShow => 'Mostrar entrada';

  @override
  String get hiddenDiaryEmpty => 'Nenhuma entrada oculta';

  @override
  String get hiddenDiaryUnlock => 'Desbloquear entradas ocultas';

  @override
  String get hiddenDiaryAuthHint =>
      'Use o bloqueio do aplicativo ou da tela do dispositivo.';

  @override
  String hiddenDiaryWhere(String path) {
    return 'Ocultada. Para mostrar de novo: $path';
  }

  @override
  String get noteKeep => 'Guardar';

  @override
  String get noteComment => 'Comentar';

  @override
  String get noteCommentHint => 'Escreva para o seu eu do passado';

  @override
  String get noteKept => 'Trecho guardado';

  @override
  String get notesPassages => 'Trechos guardados';

  @override
  String get notesComments => 'Comentários';

  @override
  String get noteDeleteConfirm => 'Excluir esta nota?';

  @override
  String get editPastTitle => 'Editar uma memória passada?';

  @override
  String get editPastBody =>
      'Esta entrada é de um dia anterior. Para respondê-la, selecione o texto para guardar ou comentar.';

  @override
  String get editPastDontAsk => 'Não perguntar novamente';

  @override
  String get editPastEdit => 'Editar mesmo assim';

  @override
  String noteOnEntry(String date) {
    return 'Sobre a entrada de $date';
  }

  @override
  String get settingsConfirmEditPast =>
      'Perguntar antes de editar entradas passadas';

  @override
  String get settingsCompressPhotos => 'Compactar fotos novas';

  @override
  String get settingsCompressPhotosHint =>
      'Salvar as fotos novas como WebP de cerca de 1 MB. Desligado mantém os originais.';

  @override
  String get compressExistingTitle => 'Compactar fotos existentes';

  @override
  String compressExistingBody(int count, String size) {
    return '$count fotos ocupam $size. As maiores que cerca de 1 MB viram WebP de cerca de 1 MB. Isso as substitui e não pode ser desfeito; guarde os originais em outro lugar se quiser.';
  }

  @override
  String get compressExistingAction => 'Compactar';

  @override
  String compressExistingDone(int count, String size) {
    return '$count fotos compactadas, $size economizados';
  }

  @override
  String get commentExpand => 'Expandir';

  @override
  String get refAdd => 'Citar uma entrada';

  @override
  String get refMissing => 'Essa entrada não existe mais';

  @override
  String get moodClear => 'Limpar humor';

  @override
  String get scrollToTop => 'Voltar ao topo';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackHint => 'Descreva um problema ou sugestão';

  @override
  String get feedbackSend => 'Enviar';

  @override
  String get feedbackSent => 'Obrigado, seu feedback foi enviado.';

  @override
  String get feedbackSendFailed =>
      'Não foi possível enviar. Verifique a conexão e tente novamente.';

  @override
  String get feedbackOpenFailed => 'Não foi possível abrir o app.';

  @override
  String get feedbackSendNote =>
      'Enviado ao servidor do AID Diary com a versão e o idioma do app, nada do seu diário.';

  @override
  String get feedbackGithub => 'Issue no GitHub';

  @override
  String get feedbackEmail => 'Enviar e-mail';
}
