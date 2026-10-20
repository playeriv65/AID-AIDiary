// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

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
  String get dailyReminderTitle => 'Scrivi sul diario';

  @override
  String get dailyReminderDescription => 'Tieni traccia della tua giornata…';

  @override
  String get actionTakePhoto => 'Scatta una foto';

  @override
  String get flashbacksTitle => 'Ricordi';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Escludi le giornate negative';

  @override
  String get flashbackGoodDay => 'Una bella giornata';

  @override
  String get flashbackRandomDay => 'Una giornata casuale';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count settimane fa',
      one: '$count settimana fa',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mesi fa',
      one: '$count mese fa',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count anni fa',
      one: '$count anno fa',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'Accade oggi';

  @override
  String get searchLogsHint => 'Cerca entrate del diario…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count annotazioni',
      one: '$count annotazione',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giorni',
      one: '$count giorno',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parole',
      one: '$count parola',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Nessuna annotazione…';

  @override
  String get noResults => 'Nessun risultato…';

  @override
  String get sortOrderAscendingTitle => 'Crescente';

  @override
  String get sortOrderDescendingTitle => 'Decrescente';

  @override
  String get pageStatisticsTitle => 'Statistiche';

  @override
  String get statisticsNotEnoughData => 'Dati insufficienti…';

  @override
  String get statisticsRangeOneMonth => 'Un mese';

  @override
  String get statisticsRangeSixMonths => '6 mesi';

  @override
  String get statisticsRangeOneYear => 'Un anno';

  @override
  String get statisticsRangeAllTime => 'Da sempre';

  @override
  String chartSummaryTitle(Object tag) {
    return 'Riepilogo $tag';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag per giorno';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag nel tempo';
  }

  @override
  String get chartGroupingLabel => 'Raggruppa per';

  @override
  String get chartGroupingDay => 'Giorno';

  @override
  String get chartGroupingWeek => 'Settimana';

  @override
  String get chartGroupingMonth => 'Mese';

  @override
  String get chartGroupingYear => 'Anno';

  @override
  String get chartSmoothingLabel => 'Smussamento delle curve';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giorni di fila',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Record di giorni di fila: $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Giornate positive $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Giorni trascorsi dall\'ultima giornata negativa $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Impossibile accedere alla memoria esterna';

  @override
  String get errorExternalStorageAccessDescription =>
      'Se utilizzi un archivio di rete, assicurati che il servizio sia online e che tu disponga di accesso alla rete.\n\nIn caso contrario, l\'app potrebbe aver perso le autorizzazioni per la cartella esterna. Vai alle impostazioni e seleziona la cartella esterna, e concedi l\'accesso.\n\nAttenzione, le modifiche non verranno sincronizzate finché non ripristinerai l\'accesso all\'archivio esterno!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Prosegui con l\'archivio locale';

  @override
  String get lastModified => 'Modificato';

  @override
  String get writeSomethingHint => 'Scrivi qualcosa…';

  @override
  String get titleHint => 'Titolo…';

  @override
  String get deleteLogTitle => 'Elimina l\'entrata del diario';

  @override
  String get deleteLogDescription =>
      'Vuoi davvero eliminare questa entrata del diario?';

  @override
  String get deletePhotoTitle => 'Elimina la foto';

  @override
  String get deletePhotoDescription => 'Vuoi eliminare questa foto?';

  @override
  String get pageSettingsTitle => 'Impostazioni';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Primo giorno della settimana';

  @override
  String get settingsCalendarSystem => 'Formato del calendario';

  @override
  String get calendarSystemGregorian => 'Gregoriano';

  @override
  String get calendarSystemJalali => 'Persiano';

  @override
  String get settingsUseSystemAccentColor =>
      'Usa il colore di accento del sistema';

  @override
  String get settingsCustomAccentColor => 'Personalizza colore';

  @override
  String get settingsShowFlashbacks => 'Mostra i ricordi';

  @override
  String get settingsChangeMoodIcons => 'Cambia le icone dell\'umore';

  @override
  String get moodIconPrompt => 'Inserisci un\'icona';

  @override
  String get settingsHideImages => 'Nascondi immagini';

  @override
  String get pageCalendarTitle => 'Calendario';

  @override
  String get settingsNotificationsTitle => 'Notifiche';

  @override
  String get settingsDailyReminderTitle => 'Promemoria giornaliero';

  @override
  String get settingsOnThisDayDescription => 'Riguarda i tuoi ricordi passati';

  @override
  String get settingsDailyReminderDescription =>
      'Ricevi il promemoria giornaliero';

  @override
  String get settingsReminderTime => 'Orario del promemoria';

  @override
  String get settingsFixedReminderTimeTitle =>
      'Fissa un orario per il promemoria';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Scegli un orario fisso per ricevere un promemoria';

  @override
  String get settingsAlwaysSendReminderTitle => 'Invia comunque un promemoria';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Invia il promemoria giornaliero anche se hai già creato un ricordo manualmente';

  @override
  String get settingsCustomizeNotificationTitle =>
      'Personalizza le notifiche (impostazioni di sistema)';

  @override
  String get settingsTemplatesTitle => 'Modelli fac-simile';

  @override
  String get manageTemplates => 'Gestisci i modelli';

  @override
  String get noTemplateTitle => 'Nessuno';

  @override
  String get noTemplatesDescription => 'Nessun modello ancora creato…';

  @override
  String get templateDefaultTimestampTitle => 'Data e ora';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date, $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Resoconto di oggi';

  @override
  String get templateDefaultSummaryBody =>
      '### Riassunto\n- \n\n### Citazioni\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Riflessioni';

  @override
  String get templateDefaultReflectionBody =>
      '### Cos\'hai fatto oggi di memorabile?\n- \n\n### Cos\'è successo di bello?\n- \n\n### Nuovi progetti per il futuro?\n- ';

  @override
  String get settingsTagsTitle => 'Etichette';

  @override
  String get manageTags => 'Gestisci le etichette';

  @override
  String get tagTypeLabelTitle => 'Etichetta';

  @override
  String get tagTypeTrackerTitle => 'Quantità';

  @override
  String get nameHint => 'Nome';

  @override
  String get tagColorLabel => 'Colore';

  @override
  String get iconPickerTitle => 'Scegli un\'icona';

  @override
  String get iconPickerIconsTab => 'Icone';

  @override
  String get iconPickerCustomTab => 'Personalizzato';

  @override
  String get iconPickerSearchHint => 'Cerca icone…';

  @override
  String get colorPickerTitle => 'Scegli un colore';

  @override
  String get colorPickerPaletteTab => 'Colori';

  @override
  String get iconGroupMoodPeople => 'Umori e persone';

  @override
  String get iconGroupHealth => 'Salute';

  @override
  String get iconGroupWorkFinance => 'Lavoro e finanza';

  @override
  String get iconGroupHabitsGoals => 'Abitudini e obiettivi';

  @override
  String get iconGroupNature => 'Ambiente';

  @override
  String get iconGroupFoodDrink => 'Cibo e bevande';

  @override
  String get iconGroupHome => 'Casa';

  @override
  String get iconGroupTravel => 'Viaggio';

  @override
  String get iconGroupSymbols => 'Simboli';

  @override
  String get tagCategoryLabel => 'Categoria';

  @override
  String get tagLabel => 'Annotazione';

  @override
  String get tagCategoryUncategorized => 'Senza categoria';

  @override
  String get newCategoryTitle => 'Nuova categoria';

  @override
  String get shareButtonLabel => 'Condividi';

  @override
  String get importErrorDescription => 'Impossibile importare il file';

  @override
  String get exportErrorDescription => 'Impossibile esportare il file!';

  @override
  String get deleteTitle => 'Elimina';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' È utilizzata in $count entrate del diario.',
      one: ' È utilizzata in un\'entrata del diario.',
      zero: '',
    );
    return 'Eliminare \"$name\"?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Anche le sue $count annotazioni (categorie) saranno eliminate.',
      one: ' Verrà eliminata anche una sua annotazione (categoria).',
      zero: '',
    );
    return 'Eliminare \"$name\"?$_temp0';
  }

  @override
  String deleteTemplateMessage(Object name) {
    return 'Eliminare \"$name\"?';
  }

  @override
  String get addTagsTitle => 'Aggiungi annotazioni';

  @override
  String get addTagsSearchHint => 'Cerca annotazioni…';

  @override
  String get tagPickerSortManualLabel => 'Ordine predefinito';

  @override
  String get tagPickerSortUsageLabel => 'Per frequenza di utilizzo';

  @override
  String get tagFavoriteName => 'Preferiti';

  @override
  String get tagEnergyName => 'Energia';

  @override
  String get tagCategoryActivitiesName => 'Attività';

  @override
  String get tagExerciseName => 'Esercizio';

  @override
  String get tagSocializingName => 'Compagnia';

  @override
  String get tagHobbyName => 'Passatempo';

  @override
  String get tagEntertainmentName => 'Cinema e teatro';

  @override
  String get tagDiningName => 'Cibo';

  @override
  String get tagChoresName => 'Faccende domestiche';

  @override
  String get tagCategoryEmotionsName => 'Stati d\'animo';

  @override
  String get tagExcitedName => 'Entusiasta';

  @override
  String get tagGratefulName => 'Gratitudine';

  @override
  String get tagCalmName => 'In pace';

  @override
  String get tagTiredName => 'Stanchezza';

  @override
  String get tagAnxiousName => 'Ansia';

  @override
  String get tagAnnoyedName => 'Fastidio';

  @override
  String get welcomeLogBodyText =>
      '## Welcome to AID Diary\n\n> A quiet place for your days.\n\nWrite what happened, how you felt, and where you were. Your entries stay on this device.\n\n- **Journal** lists every entry by day\n- **Calendar**, **Media** and **Atlas** look back by date, photo and place\n- **Coach** offers prompts and templates when you don\'t know what to write';

  @override
  String get settingsStorageTitle => 'Archiviazione';

  @override
  String get settingsImageQuality => 'Qualità delle immagini';

  @override
  String get imageQualityHigh => 'Alta';

  @override
  String get imageQualityMedium => 'Media';

  @override
  String get imageQualityLow => 'Bassa';

  @override
  String get imageQualityNoCompression => 'Qualità originale';

  @override
  String get settingsLogFolder => 'Cartella delle entrate del diario';

  @override
  String get settingsImageFolder => 'Cartella delle immagini';

  @override
  String get warningTitle => 'Attenzione';

  @override
  String get logFolderWarningDescription =>
      'Se la cartella selezionata contiene già un file \'aid_diary.db\', verrà utilizzato per sovrascrivere le annotazioni esistenti!';

  @override
  String get errorTitle => 'Errore';

  @override
  String get logFolderErrorDescription =>
      'Impossibile cambiare cartella delle entrate del diario!';

  @override
  String get imageFolderErrorDescription =>
      'Impossibile modificare la cartella delle immagini!';

  @override
  String get backupErrorDescription => 'Impossibile creare il backup!';

  @override
  String get restoreErrorDescription => 'Impossibile ripristinare il backup!';

  @override
  String get settingsBackupRestoreTitle => 'Backup e ripristino';

  @override
  String get settingsBackup => 'Backup';

  @override
  String get settingsRestore => 'Ripristino';

  @override
  String get settingsRestorePromptDescription =>
      'Ripristinare un backup sovrascriverà i dati esistenti!';

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
    return 'Trasferimento… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Creazione del backup… $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Ripristino dal backup… $percent%';
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
  String get cleanUpStatus => 'Sto facendo pulizia…';

  @override
  String get settingsExportToAnotherFormat => 'Esporta in un altro formato';

  @override
  String get settingsExportFormatDescription =>
      'Questo non dovrebbe essere usato come backup!';

  @override
  String get settingsImportFromAnotherApp => 'Importa da un\'altra app';

  @override
  String get logFormatTitle => 'Scegli il Formato';

  @override
  String get logFormatDescription =>
      'Il formato di un\'altra app potrebbe non supportare tutte le funzionalità. Riporta qualsiasi problema riscontri poiché i formati di terze parti possono cambiare in qualsiasi momento. Ciò non avrà impatto sulle note esistenti!';

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
  String get settingsDeleteAllLogsTitle =>
      'Cancella tutte le entrate del diario';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Vuoi davvero cancellare tutte le tue entrate del diario?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Inserisci \'$prompt\' per confermare. Questa operazione non può essere annullata!';
  }

  @override
  String get settingsLanguageTitle => 'Lingua';

  @override
  String get settingsAppLanguageTitle => 'Lingua dell\'app';

  @override
  String get settingsOverrideAppLanguageTitle =>
      'Sovrascrivi la lingua dell\'app';

  @override
  String get settingsSecurityTitle => 'Sicurezza';

  @override
  String get settingsSecurityRequirePassword => 'Richiedi una password';

  @override
  String get settingsSecurityEnterPassword => 'Inserisci la password';

  @override
  String get settingsSecuritySetPassword => 'Imposta una password';

  @override
  String get settingsSecurityChangePassword => 'Cambia la password';

  @override
  String get settingsSecurityPassword => 'Password';

  @override
  String get settingsSecurityConfirmPassword => 'Conferma password';

  @override
  String get settingsSecurityOldPassword => 'Vecchia password';

  @override
  String get settingsSecurityIncorrectPassword => 'Password errata';

  @override
  String get settingsSecurityPasswordsDoNotMatch =>
      'Le password non coincidono';

  @override
  String get requiredPrompt => 'Campo richiesto';

  @override
  String get settingsSecurityBiometricUnlock => 'Sblocco biometrico';

  @override
  String get unlockAppPrompt => 'Sblocca l\'app';

  @override
  String get settingsAboutTitle => 'Informazioni';

  @override
  String get settingsVersion => 'Versione';

  @override
  String get settingsLicense => 'Licenza';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsOpenSourceLicenses => 'Open Source Licenses';

  @override
  String get tagMoodTitle => 'Stato d\'animo';

  @override
  String get selectTagTitle => 'Scegli un\'annotazione';

  @override
  String get labelPresentLabel => 'Presente';

  @override
  String get labelAbsentLabel => 'Assente';

  @override
  String get labelCoverageLabel => 'Periodo';

  @override
  String chartDistributionTitle(Object tag) {
    return 'Distribuzione di $tag';
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
