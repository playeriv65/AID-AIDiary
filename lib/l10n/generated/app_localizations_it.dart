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
  String get themeColorTitle => 'Colore del tema';

  @override
  String get themeColorHint => 'Scegli un colore per questa tavolozza.';

  @override
  String get themeColorBlue => 'Azzurro cielo';

  @override
  String get themeColorGreen => 'Verde bosco';

  @override
  String get themeColorBrown => 'Caffè caldo';

  @override
  String get themeColorPurple => 'Lavanda';

  @override
  String get themeColorRose => 'Rosa polverosa';

  @override
  String get themeColorAmber => 'Ambra';

  @override
  String get themeColorPreview => 'Un po\' ogni giorno';

  @override
  String get themeTintBackgroundTitle => 'Tinta sfondi con colori a tema';

  @override
  String get themeTintBackgroundHint =>
      'Disattiva per sfondi grigio neutro; i pulsanti mantengono il colore scelto.';

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
  String get tagNameExists => 'Esiste già un tag con questo nome';

  @override
  String get categoryNameExists => 'Esiste già una categoria con questo nome';

  @override
  String deleteTemplateMessage(Object name) {
    return 'Eliminare \"$name\"?';
  }

  @override
  String get addTagsTitle => 'Aggiungi annotazioni';

  @override
  String get addTagsSearchHint => 'Cerca annotazioni…';

  @override
  String get tagsRecent => 'Usati di recente';

  @override
  String get tagNew => 'Nuovo tag';

  @override
  String get tagFavoriteName => 'Preferiti';

  @override
  String get iconGroupActivities => 'Attività';

  @override
  String get iconGroupHobbies => 'Cinema e teatro';

  @override
  String get settingsStorageTitle => 'Archiviazione';

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
  String get settingsBackupPasswordProtect => 'Backup protetti con password';

  @override
  String get backupEncryptedTitle => 'Backup crittografato';

  @override
  String get backupEncryptedContent => 'Questo backup è protetto da password.';

  @override
  String get settingsAutoBackup => 'Backup automatici';

  @override
  String get settingsAutoBackupLocation => 'Posizione di backup';

  @override
  String get settingsAutoBackupInterval => 'Intervallo di backup';

  @override
  String get settingsAutoBackupIntervalDaily => 'Ogni giorno';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Settimanale';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Mensile';

  @override
  String get settingsAutoBackupMaxCount => 'Backup da conservare';

  @override
  String get settingsAutoBackupRequireCharging => 'Solo durante la ricarica';

  @override
  String settingsBackupLast(Object time) {
    return 'Ultimo backup $time';
  }

  @override
  String get settingsBackupNever => 'Mai eseguito il backup';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Prossimo backup $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'Tutto';

  @override
  String get autoBackupFailedTitle => 'Backup non riuscito';

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
    return 'Crittografia backup… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Decodifica backup… $percent%';
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
      'Cancella tutte le entrate del diario';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Vuoi davvero cancellare tutte le tue entrate del diario?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Inserisci \'$prompt\' per confermare. Questa operazione non può essere annullata!';
  }

  @override
  String get settingsAppLanguageTitle => 'Lingua dell\'app';

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
  String get settingsOpenSourceLicenses => 'Licenze Open Source';

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
  String get shareAddToLogPickerTitle => 'Scegli una voce del diario';

  @override
  String get adaptiveEmptyDay => 'Ancora nessuna voce per questo giorno';

  @override
  String get adaptiveNewEntry => 'Scrivi una voce';

  @override
  String get pageJournalTitle => 'Diario';

  @override
  String get coachPrompt1 => 'Cosa ti ha fatto sorridere oggi?';

  @override
  String get coachPrompt2 => 'Qual è una cosa che hai imparato oggi?';

  @override
  String get coachPrompt3 => 'Con chi hai parlato oggi e come ti sei sentito?';

  @override
  String get coachPrompt4 => 'Per cosa sei grato in questo momento?';

  @override
  String get coachPrompt5 =>
      'Cosa ha consumato la maggior parte delle tue energie oggi?';

  @override
  String get coachPrompt6 => 'Descrivi un piccolo momento che vuoi ricordare.';

  @override
  String get coachPrompt7 => 'Cosa renderebbe domani una buona giornata?';

  @override
  String get coachPrompt8 => 'Cos\'hai in mente ultimamente?';

  @override
  String get coachPrompt9 => 'Cosa hai fatto oggi solo per te stesso?';

  @override
  String get coachPrompt10 => 'Se oggi avesse un titolo, quale sarebbe?';

  @override
  String get pageMediaTitle => 'Media';

  @override
  String get pageAtlasTitle => 'Atlante';

  @override
  String get pageCoachTitle => 'Allenatore';

  @override
  String get noEntrySelected => 'Nessuna voce selezionata.';

  @override
  String get entryShare => 'Condividi';

  @override
  String get entryFavorite => 'Stella';

  @override
  String get entryEdit => 'Modifica';

  @override
  String get entryPrevious => 'Voce precedente';

  @override
  String get entryNext => 'Voce successiva';

  @override
  String get journalStories => 'Storie';

  @override
  String get journalEntries => 'Voci';

  @override
  String get journalEmptyHint =>
      'Inizia il tuo diario aggiungendo una nuova voce.';

  @override
  String get storyToday => 'Oggi';

  @override
  String get storyThrowback => 'Ritorno al passato';

  @override
  String get storyNoThrowback => 'Nessun ritorno al passato oggi';

  @override
  String get mediaFiles => 'File multimediali';

  @override
  String get mediaEmpty => 'Nessuna foto ancora';

  @override
  String get mediaEmptyHint =>
      'Le foto allegate alle iscrizioni verranno mostrate qui.';

  @override
  String get atlasEmpty => 'Nessuna voce con una posizione.';

  @override
  String get atlasEmptyHint =>
      'Le voci con una posizione verranno visualizzate qui.';

  @override
  String get atlasShowAll => 'Mostra tutte le voci';

  @override
  String get atlasMyLocation => 'La mia posizione';

  @override
  String get coachAll => 'Tutto';

  @override
  String get coachPrograms => 'Programmi';

  @override
  String get coachTemplates => 'Modelli';

  @override
  String get coachKindProgram => 'Programma';

  @override
  String get coachKindTemplate => 'Modello';

  @override
  String get coachNoTemplates => 'Nessun programma o modello.';

  @override
  String get coachUseTemplate => 'Scrivi con questo modello';

  @override
  String get coachProgramEverydayTitle => 'Momenti quotidiani';

  @override
  String get coachProgramEverydayDescription =>
      'Cinque brevi domande, una al giorno. Ciascuno richiede un minuto o due e ti aiuta a vedere cosa ha reso la giornata tua. Un modo delicato per abituarsi a scrivere un po\' ogni giorno.';

  @override
  String get coachProgramReflectTitle => 'Guardando dentro';

  @override
  String get coachProgramReflectDescription =>
      'Una domanda più profonda a settimana, per cinque settimane. Prenditi il ​​tuo tempo con ciascuno: come ti senti, cosa ti logora, per cosa sei grato.';

  @override
  String get searchFilters => 'Filtri';

  @override
  String get searchFilterTags => 'Tag';

  @override
  String get searchFilterStarred => 'Stellato';

  @override
  String get searchHint => 'Digita per cercare o scegli un filtro.';

  @override
  String get locationTitle => 'Posizione';

  @override
  String get locationName => 'Nome del luogo';

  @override
  String get locationRemove => 'Rimuovi';

  @override
  String get locationServiceDisabled =>
      'I servizi di localizzazione sono disattivati.';

  @override
  String get locationPermissionDenied =>
      'L\'autorizzazione alla posizione è stata negata.';

  @override
  String get locationUnavailable =>
      'Impossibile ottenere la posizione corrente.';

  @override
  String get calendarJumpToToday => 'Vai a oggi';

  @override
  String get editorStartWriting => 'Inizia a scrivere o scegli a ';

  @override
  String get editorTemplateLink => 'Modello';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Scegli un modello';

  @override
  String get templateFeatured => 'Modelli in primo piano';

  @override
  String get templateMine => 'I miei modelli';

  @override
  String get templateDailyName => 'Revisione quotidiana';

  @override
  String get templateDailyDescription =>
      'Cosa è successo, come è stato e cosa verrà dopo.';

  @override
  String get templateDailyText =>
      '## Cosa è successo oggi\n\n\n## Come mi sono sentito\n\n\n## Tre cose per cui sono grato\n1. \n2. \n3. \n\n## Domani\n';

  @override
  String get templateTravelName => 'Voce del diario di viaggio';

  @override
  String get templateTravelDescription =>
      'Luoghi, momenti e cibo dalla strada.';

  @override
  String get templateTravelText =>
      '## Dove sono andato\n\n\n## Il momento che ricordo di più\n\n\n## Cosa ho mangiato\n\n\n## Progetti per domani\n';

  @override
  String get templateReadingName => 'Lettura degli appunti';

  @override
  String get templateReadingDescription =>
      'Citazioni e pensieri da ciò che leggi.';

  @override
  String get templateReadingText =>
      '## Libro\n\n\n## Dove sono\n\n\n## Citazioni\n> \n\n## I miei pensieri\n';

  @override
  String get templateWeeklyName => 'Revisione settimanale';

  @override
  String get templateWeeklyDescription =>
      'Punti salienti, difficoltà e focus della prossima settimana.';

  @override
  String get templateWeeklyText =>
      '## In evidenza\n\n\n## Ciò che è stato difficile\n\n\n## Cosa ho imparato\n\n\n## Concentrati sulla prossima settimana\n';

  @override
  String get entrySaveAsTemplate => 'Salva come modello';

  @override
  String get entrySavedAsTemplate => 'Salvato come modello';

  @override
  String get storyStatistics => 'Statistiche';

  @override
  String get storyMoodChart => 'Grafico dell\'umore';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return 'Voci $entries · $days giorni';
  }

  @override
  String get storyThisYear => 'Quest\'anno';

  @override
  String get storyLastYear => 'L\'anno scorso';

  @override
  String get storyTapToOpen => 'Tocca un giorno per aprirlo';

  @override
  String get settingsGeneralTitle => 'Generale';

  @override
  String get settingsDataTitle => 'Dati e archiviazione';

  @override
  String get settingsStoriesTitle => 'Storie';

  @override
  String get settingsHelpTitle => 'Aiuto e informazioni';

  @override
  String get weatherTitle => 'Meteo';

  @override
  String get weatherClear => 'Chiaro';

  @override
  String get weatherPartlyCloudy => 'Parzialmente nuvoloso';

  @override
  String get weatherCloudy => 'Nuvoloso';

  @override
  String get weatherFog => 'Nebbia';

  @override
  String get weatherDrizzle => 'Pioviggina';

  @override
  String get weatherRain => 'Pioggia';

  @override
  String get weatherSnow => 'Neve';

  @override
  String get weatherStorm => 'Temporale';

  @override
  String get weatherFetch => 'Ottieni il meteo per questa voce';

  @override
  String get weatherNeedsLocation =>
      'Aggiungi prima una posizione con le coordinate.';

  @override
  String get weatherUnavailable =>
      'Il meteo non è disponibile per questo luogo e orario.';

  @override
  String get weatherRemove => 'Rimuovi il meteo';

  @override
  String get weatherTemperature => 'Temperatura';

  @override
  String get activityStill => 'Ancora';

  @override
  String get activityWalking => 'Camminare';

  @override
  String get activityRunning => 'Correre';

  @override
  String get activityCycling => 'Ciclismo';

  @override
  String get activityVehicle => 'In un veicolo';

  @override
  String get activityFlying => 'Volare';

  @override
  String get activityExercise => 'Esercizio';

  @override
  String get settingsAutoAddTitle => 'Aggiungi automaticamente';

  @override
  String get settingsAutoAddLocation => 'Posizione';

  @override
  String get settingsAutoAddWeather => 'Meteo';

  @override
  String get settingsAutoAddHint =>
      'Le nuove voci vengono compilate quando vengono create.';

  @override
  String get settingsTemperatureUnit => 'Unità di temperatura';

  @override
  String get settingsCelsius => 'Celsius (°C)';

  @override
  String get settingsFahrenheit => 'Fahrenheit (°F)';

  @override
  String get moodGreat => 'Ottimo';

  @override
  String get moodGood => 'Bene';

  @override
  String get moodOkay => 'Ok';

  @override
  String get moodBad => 'Cattivo';

  @override
  String get moodAwful => 'Terribile';

  @override
  String get locationSearchHint => 'Cerca un posto';

  @override
  String get locationSearchEmpty => 'Nessun posto trovato';

  @override
  String get settingsWallpaper => 'Carta da parati';

  @override
  String get wallpaperNone => 'Nessuno';

  @override
  String get wallpaperDots => 'Punti';

  @override
  String get wallpaperGrid => 'Griglia';

  @override
  String get wallpaperLines => 'Linee';

  @override
  String get wallpaperPhoto => 'Foto…';

  @override
  String get settingsFontFamily => 'Carattere';

  @override
  String get fontSystem => 'Sistema';

  @override
  String get fontSerif => 'Serif';

  @override
  String get fontMono => 'Monospazio';

  @override
  String get settingsFontSize => 'Dimensione del carattere';

  @override
  String get fontSizeSmall => 'Piccolo';

  @override
  String get fontSizeMedium => 'Medio';

  @override
  String get fontSizeLarge => 'Grande';

  @override
  String get fontSizeExtraLarge => 'Molto grande';

  @override
  String get settingsLineSpacing => 'Interlinea';

  @override
  String get lineSpacingCompact => 'Compatto';

  @override
  String get lineSpacingNormal => 'Normale';

  @override
  String get lineSpacingRelaxed => 'Rilassato';

  @override
  String get moodAssociationsTitle => 'Ciò che mi fa sentire...';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching delle voci $total';
  }

  @override
  String get videoRecord => 'Registra un video';

  @override
  String get videoChoose => 'Scegli un video';

  @override
  String get audioRecordTitle => 'Registra una nota vocale';

  @override
  String get audioChoose => 'Scegli un file audio';

  @override
  String get audioStart => 'Registra';

  @override
  String get audioStop => 'Fermati e risparmia';

  @override
  String get audioPermissionDenied =>
      'L\'accesso al microfono è disattivato. Consentilo nelle impostazioni di sistema.';

  @override
  String get mediaTooLarge =>
      'Questo video è troppo grande per essere allegato.';

  @override
  String get mediaUnavailable =>
      'Questo allegato non è disponibile su questo dispositivo.';

  @override
  String get widgetDone => 'La voce di oggi è scritta';

  @override
  String get widgetPending => 'Com\'è andata la giornata?';

  @override
  String get widgetWrite => 'Scrivi';

  @override
  String get insertChecklist => 'Lista di controllo';

  @override
  String get insertNumberedList => 'Elenco numerato';

  @override
  String get insertTable => 'Tabella';

  @override
  String get insertDivider => 'Divisore';

  @override
  String get insertCodeBlock => 'Blocco di codice';

  @override
  String get journalSortTitle => 'Ordina le voci';

  @override
  String get journalSortUpdated => 'Ultimo aggiornamento';

  @override
  String get settingsTimeFormat => 'Formato ora';

  @override
  String get settingsDayStart =>
      'Le nuove iscrizioni contano dal giorno prima fino al';

  @override
  String get settingsDayAskUntil => 'Quindi chiedi fino a quale giorno';

  @override
  String get settingsDayStartMidnight => 'Spento';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Ogni voce conserva il giorno a cui appartiene accanto all\'ora in cui è stata scritta e puoi modificare quel giorno nell\'editor in qualsiasi momento. Questi orari scelgono solo il giorno per le nuove voci, quindi modificarli non sposta alcuna voce esistente.';

  @override
  String get lateNightBadge =>
      'Scritto a tarda notte, conteggiato per il giorno prima';

  @override
  String editorDayAsk(String time) {
    return 'Scritto a $time. Per che giorno è?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (ieri)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (oggi)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'Scritto $when';
  }

  @override
  String get timeFormat12 => '12 ore';

  @override
  String get timeFormat24 => '24 ore su 24';

  @override
  String get settingsReminderDays => 'Ricordamelo';

  @override
  String get locationRecent => 'Luoghi recenti';

  @override
  String get shareImage => 'Condividi l\'immagine';

  @override
  String get shareSaveImage => 'Salva immagine';

  @override
  String get shareSaved => 'Immagine salvata';

  @override
  String get deletedTitle => 'Eliminato di recente';

  @override
  String get deletedNone => 'Niente è stato eliminato di recente';

  @override
  String deletedHint(int days) {
    return 'Le voci eliminate rimangono qui per $days giorni, quindi vengono cancellate.';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days giorni rimasti';
  }

  @override
  String get deletedRestore => 'Ripristina';

  @override
  String get deletedDeleteForever => 'Elimina per sempre';

  @override
  String get deletedDeleteForeverDescription =>
      'La voce e i suoi allegati vengono cancellati. Questa operazione non può essere annullata.';

  @override
  String get deletedEmpty => 'Vuoto';

  @override
  String get deletedEmptyDescription =>
      'Cancellare tutte le voci in Eliminati di recente? Questa operazione non può essere annullata.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Passeggiata casuale';

  @override
  String get randomSubtitle => 'Apri una voce passata';

  @override
  String get randomNext => 'Un altro';

  @override
  String get randomAll => 'Tutto';

  @override
  String get randomWithPhotos => 'Con foto';

  @override
  String get randomGoodDays => 'Buoni giorni';

  @override
  String get randomEmpty => 'Nessuna voce tra cui scegliere';

  @override
  String get reviewWeekTitle => 'Questa settimana';

  @override
  String get reviewWeekSubtitle => 'La tua settimana finora';

  @override
  String get reviewYearTitle => 'Quest\'anno';

  @override
  String get reviewEmpty => 'Niente di scritto ancora';

  @override
  String get reviewEntries => 'Voci';

  @override
  String get reviewDaysWritten => 'Giorni scritti';

  @override
  String get reviewWords => 'Parole';

  @override
  String get reviewPhotos => 'Foto';

  @override
  String get reviewLongestRun => 'La serie di giorni più lunga';

  @override
  String get reviewAverageMood => 'Umore medio';

  @override
  String get reviewFavorites => 'Molto spesso';

  @override
  String get reviewByMonth => 'Per mese';

  @override
  String get reviewHighlight => 'Evidenziare';

  @override
  String get yearInPixels => 'Anno in pixel';

  @override
  String get capsuleSeal => 'Sigillo come capsula del tempo';

  @override
  String get capsuleTitle => 'Capsula del tempo';

  @override
  String capsuleOpensOn(Object date) {
    return 'Apre il $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Scritto su $date';
  }

  @override
  String get capsuleOpenEarly => 'Aperto presto';

  @override
  String get capsuleOpenEarlyDescription =>
      'La capsula ora si apre e rimane aperta.';

  @override
  String get capsuleOpened => 'La capsula del tempo è stata aperta';

  @override
  String get templateMorningName => 'Pagine del mattino';

  @override
  String get templateMorningDescription =>
      'Organizza la giornata in tre minuti';

  @override
  String get templateMorningText =>
      '## Tre cose che voglio fare bene oggi\n1. \n2. \n3. \n\n## Qualcosa che non vedo l\'ora\n\n## Una nota per me\n';

  @override
  String get templateEveningName => 'Rassegna serale';

  @override
  String get templateEveningDescription =>
      'Chiudi la giornata con ciò che è andato bene';

  @override
  String get templateEveningText =>
      '##Tre cose belle oggi\n1. \n2. \n3. \n\n## Cosa ho imparato\n\n## Cosa potrebbe andare meglio domani\n';

  @override
  String get routineMorning => 'Buongiorno';

  @override
  String get routineEvening => 'Rassegna serale';

  @override
  String get settingsRoutinePrompts => 'Suggerimenti mattutini e serali';

  @override
  String get settingsRoutinePromptsHint =>
      'Suggerisci il modello mattutino o serale nelle Storie';

  @override
  String get checkInTitle => 'Check-in veloce';

  @override
  String get checkInSubtitle => 'L\'umore in due tocchi';

  @override
  String get checkInMood => 'Come ti senti?';

  @override
  String get checkInActivity => 'Cosa stai facendo?';

  @override
  String get checkInNote => 'Una riga a riguardo (facoltativa)';

  @override
  String get checkInSave => 'Salva';

  @override
  String editorWordCount(int words, int characters) {
    return 'Parole $words · Caratteri $characters';
  }

  @override
  String get coachProgramEverydayTagline =>
      'Nota le piccole cose in una giornata.';

  @override
  String get coachProgramReflectTagline => 'Rallenta e ascolta te stesso.';

  @override
  String get coachDuration => 'Durata';

  @override
  String get coachInterval => 'Intervallo';

  @override
  String get coachDifficulty => 'Difficoltà';

  @override
  String get coachIntervalDaily => 'Ogni giorno';

  @override
  String get coachIntervalWeekly => 'Settimanale';

  @override
  String get coachDifficultyBeginner => 'Principiante';

  @override
  String get coachDifficultyIntermediate => 'Intermedio';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giorni',
      one: '$count giorno',
      many: '$count giorni',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count settimane',
      one: '$count settimana',
      many: '$count settimane',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'Giorno $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Settimana $n';
  }

  @override
  String get coachEnroll => 'Iscriviti';

  @override
  String get coachEndProgram => 'Fine del programma';

  @override
  String get coachAuthor => 'Autore';

  @override
  String get coachAuthorBio => 'Suggerimenti scritti per questa app.';

  @override
  String get coachEnrolledTip =>
      'Tutto pronto! Le tue domande verranno visualizzate nelle Storie.';

  @override
  String get coachGoToStories => 'Vai alle Storie';

  @override
  String get coachAnswerHint => 'Scrivi la tua risposta...';

  @override
  String get storyWrapUp => 'Per oggi è tutto.';

  @override
  String get storyTapToClose => 'Tocca per chiudere';

  @override
  String get coachAnswerDone => 'Fatto';

  @override
  String get coachAnswered => 'Risposto, tocca per aprire';

  @override
  String get coachAnsweredEarlier => 'Risposto';

  @override
  String get locationLocating => 'Individuazione...';

  @override
  String get locationPickPlace => 'Scegli un posto';

  @override
  String get locationPlacesHint => 'Indirizzo o nome del luogo';

  @override
  String get locationCustom => 'Luogo personalizzato';

  @override
  String get locationCurrent => 'Posizione attuale';

  @override
  String get locationSaved => 'Luoghi salvati';

  @override
  String get locationSearchResults => 'Risultati della ricerca';

  @override
  String get locationNearby => 'Luoghi vicini';

  @override
  String get locationRename => 'Rinominare';

  @override
  String get locationSavePlace => 'Salva posto';

  @override
  String get locationUnsavePlace => 'Rimuovi dai luoghi salvati';

  @override
  String get shareAs => 'Condividi come...';

  @override
  String get shareAsImage => 'Immagine';

  @override
  String get shareAsZip => 'ZIP con il supporto originale';

  @override
  String get shareAsPlainText => 'Testo semplice';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Benvenuti in AID Diary';

  @override
  String get onboardWelcomeText =>
      'Inizia da qui oppure collega questo dispositivo a quello che già usi.';

  @override
  String get onboardStart => 'Inizia a scrivere';

  @override
  String get helpFaq => 'Domande frequenti';

  @override
  String get helpFaq1Q => 'Dove è archiviato il mio diario?';

  @override
  String get helpFaq1A =>
      'Il tuo diario è archiviato su questo dispositivo. Raggiunge altri dispositivi o spazio di archiviazione solo quando abiliti la sincronizzazione, la condivisione o l\'esportazione. La sincronizzazione è crittografata end-to-end.';

  @override
  String get helpFaq2Q =>
      'Come posso conservare una copia o spostarla su un nuovo dispositivo?';

  @override
  String get helpFaq2A =>
      'Connettiti a un dispositivo esistente in Impostazioni → Dati e archiviazione → Sincronizza e conferma l\'autorizzazione sul dispositivo su cui è presente il tuo diario. Entrambi i dispositivi rimangono utilizzabili. Puoi anche creare un backup e ripristinarlo su un altro dispositivo.';

  @override
  String get helpFaq3Q => 'Posso importare voci da altre app di agenda?';

  @override
  String get helpFaq3A =>
      'Sì: in Impostazioni → Dati e archiviazione, importa esportazioni da Daylio, Diarium, Diaro, DayBook, My Brain, OneShot e Pixels o un\'esportazione JSON.';

  @override
  String get helpFaq4Q => 'Come funzionano i programmi coach?';

  @override
  String get helpFaq4A =>
      'Iscriviti a un programma sulla pagina Coach. Ogni giorno o settimana una nuova domanda attende nelle Storie; la tua risposta viene salvata come voce.';

  @override
  String get helpFaq5Q => 'Cosa succede se dimentico il mio passcode?';

  @override
  String get helpFaq5A =>
      'Il passcode non può essere recuperato, quindi conserva un backup del tuo diario.';

  @override
  String get helpPrivacy => 'Privacy';

  @override
  String get helpPrivacyText =>
      'I contenuti e i contenuti multimediali del diario rimangono su questo dispositivo a meno che non abiliti la sincronizzazione crittografata o li condividi/esporti. Mappe, ricerca di luoghi e meteo utilizzano i servizi configurati e inviano la posizione o la query di ricerca necessaria per quella richiesta, non il testo del diario.';

  @override
  String get photoMetaTitle => 'Utilizzare i dettagli della foto?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Contare questa voce per $date e impostarne il posto su $place, come registrato nella foto?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Contare questa voce per $date, quando è stata scattata la foto?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Imposta il luogo di questa voce su $place, dove è stata scattata la foto?';
  }

  @override
  String get photoMetaApply => 'Usateli';

  @override
  String get quickWriteTitle => 'Scrivi velocemente';

  @override
  String get quickWriteText => 'Tocca per iniziare una nuova voce.';

  @override
  String get settingsQuickWriteTitle => 'Scrivi rapidamente nelle notifiche';

  @override
  String get settingsQuickWriteDescription =>
      'Conserva una notifica che apre una nuova voce.';

  @override
  String get settingsNudgesTitle =>
      'Dammi una spinta dopo un tratto tranquillo';

  @override
  String settingsNudgesDescription(int days) {
    return 'Un dolce promemoria quando non scrivi da $days giorni.';
  }

  @override
  String get nudgeTitle => 'E\' passato un po\' di tempo';

  @override
  String get nudgeMonday => 'Una nuova settimana: cosa aspettate?';

  @override
  String get nudgeTuesday => 'Bastano due righe. Come stai oggi?';

  @override
  String get nudgeWednesday => 'A metà settimana. Cosa è emerso finora?';

  @override
  String get nudgeThursday =>
      'Qualcosa di piccolo che vale la pena tenere da parte oggi?';

  @override
  String get nudgeFriday =>
      'La settimana si sta concludendo. Nota un bel momento.';

  @override
  String get nudgeSaturday => 'Un sabato lento è un buon giorno per scrivere.';

  @override
  String get nudgeSunday => 'Guarda indietro alla settimana prima che finisca.';

  @override
  String get photoWidgetEmpty =>
      'Le foto aggiunte alle voci vengono visualizzate qui.';

  @override
  String get channelReminders => 'Promemoria';

  @override
  String get channelOnThisDay => 'In questo giorno';

  @override
  String get channelCoach => 'L\'allenatore suggerisce';

  @override
  String get channelNudges => 'Solleciti dopo giorni tranquilli';

  @override
  String get channelQuickWrite => 'Scrivi velocemente';

  @override
  String get channelBackup => 'Backup';

  @override
  String get formatJsonExport => 'JSON (esportazione AID Diary)';

  @override
  String get aboutModifiedNotice =>
      'Una versione modificata di Daily You di Demizo e collaboratori. Non è l\'app ufficiale Daily You.';

  @override
  String get toolbarPhotos => 'Aggiungi foto';

  @override
  String get toolbarMedia => 'Foto e video';

  @override
  String get mediaFromGallery => 'Scegli dalla galleria';

  @override
  String get mediaFromFiles => 'Scegli tra i file';

  @override
  String get editorLeaveTitle => 'Salvare questa voce?';

  @override
  String get editorLeaveDiscard => 'Non salvare';

  @override
  String get editorTitleHint => 'Titolo';

  @override
  String get editorLocating => 'Individuazione...';

  @override
  String get toolbarVideo => 'Video';

  @override
  String get toolbarAudio => 'Nota vocale';

  @override
  String get toolbarTags => 'Tag';

  @override
  String get toolbarBulletList => 'Elenco puntato';

  @override
  String get toolbarHeading => 'Intestazione';

  @override
  String get toolbarBold => 'Grassetto';

  @override
  String get toolbarItalic => 'Corsivo';

  @override
  String get toolbarHighlight => 'Evidenziare';

  @override
  String get toolbarStrikethrough => 'Barrato';

  @override
  String get toolbarQuote => 'Citazione';

  @override
  String get toolbarLink => 'Collegamento';

  @override
  String get toolbarInsert => 'Inserisci';

  @override
  String get toolbarUndo => 'Annulla';

  @override
  String get toolbarRedo => 'Rifare';

  @override
  String get toolbarInsertDate => 'Inserisci la data';

  @override
  String get toolbarInsertTime => 'Inserisci l\'ora';

  @override
  String get settingsSyncTitle => 'Sincronizzazione nel cloud';

  @override
  String get syncOffDescription =>
      'Mantieni questo diario uguale su tutti i tuoi dispositivi tramite Google Drive o un server WebDAV, come Nextcloud, Synology o Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'Sincronizza con Google Drive';

  @override
  String get syncOrWebDav => 'O un server WebDAV';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn => 'Accedi. Puoi tornare a AID Diary.';

  @override
  String get syncGoogleSignInAgain =>
      'Google ha bisogno che tu acceda di nuovo.';

  @override
  String get syncSignInAgain => 'Accedi di nuovo';

  @override
  String get settingsCommandLineTitle => 'Riga di comando';

  @override
  String get commandLineToggle => 'Interfaccia della riga di comando';

  @override
  String get commandLineToggleHint =>
      'Consente al comando aiuti e ad altri programmi su questo dispositivo di utilizzare i comandi dell\'app.';

  @override
  String get commandLineAlwaysOn => 'Sempre attivo nelle build di sviluppo.';

  @override
  String commandLineListening(int port) {
    return 'Ascolto sulla porta $port';
  }

  @override
  String get commandPaletteTitle => 'Tutti i comandi';

  @override
  String get commandPaletteSearch => 'Comandi di ricerca';

  @override
  String get commandPaletteRun => 'Corri';

  @override
  String get commandPaletteConfirm =>
      'Ciò non può essere semplicemente annullato. Eseguirlo?';

  @override
  String syncReceiving(int done, int total) {
    return 'Ricezione di $done di $total…';
  }

  @override
  String syncSending(int done, int total) {
    return 'Invio di $done di $total…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'L\'accesso a Google Drive non è stato consentito. Connettiti nuovamente e seleziona Google Drive sulla pagina di Google.';

  @override
  String get syncEntryUnsynced =>
      'Non sincronizzato: l\'ultima sincronizzazione non è andata a buon fine';

  @override
  String get syncUseOfficial => 'Utilizza il server di sincronizzazione AID';

  @override
  String get syncServer => 'Indirizzo del server';

  @override
  String get syncUsername => 'Nome utente';

  @override
  String get syncPassword => 'Parola d\'ordine';

  @override
  String get syncConnect => 'Connettiti';

  @override
  String get syncConnecting => 'Connessione…';

  @override
  String get syncSignInFailed =>
      'Impossibile accedere. Controlla l\'indirizzo, il nome utente e la password.';

  @override
  String syncConnectFailed(String error) {
    return 'Impossibile connettersi: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Inizia la sincronizzazione';

  @override
  String get syncNewSpaceDescription =>
      'Non c\'è ancora nessun diario sincronizzato qui. Questo diario verrà caricato, crittografato end-to-end con una chiave che rimarrà sui tuoi dispositivi.';

  @override
  String get syncJoinTitle => 'Unisciti al diario sincronizzato';

  @override
  String get syncWrongKey =>
      'Questo codice di ripristino non apre il diario sincronizzato.';

  @override
  String syncLastSynced(String time) {
    return '$time ultima sincronizzazione';
  }

  @override
  String get syncNever => 'Non ancora sincronizzato';

  @override
  String get syncSyncing => 'Sincronizzazione…';

  @override
  String syncFailed(String error) {
    return 'L\'ultima sincronizzazione non è riuscita: $error';
  }

  @override
  String get syncLocked =>
      'Il diario sincronizzato ora appartiene ad altri dispositivi o è stato riavviato. Accoppialo con uno di essi o utilizza il codice di ripristino per continuare la sincronizzazione.';

  @override
  String get syncNow => 'Sincronizza ora';

  @override
  String get syncUnlock => 'Sblocca';

  @override
  String get syncEncrypted => 'Crittografato end-to-end';

  @override
  String get syncDisconnect => 'Interrompi la sincronizzazione';

  @override
  String get syncDisconnectDescription =>
      'Questo dispositivo interrompe la sincronizzazione. Il diario qui e la copia sincronizzata rimangono invariati.';

  @override
  String get syncOwnRecoveryPassword =>
      'Utilizza la mia password di ripristino';

  @override
  String get syncRecoveryPassword => 'Password di recupero';

  @override
  String get syncRecoveryPasswordRepeat => 'Ripeti la password di ripristino';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Utilizza almeno i caratteri $min';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'Le password differiscono';

  @override
  String get syncRecoveryCode => 'Codice di ripristino';

  @override
  String get syncRecoveryCodeTitle => 'Salva il tuo codice di ripristino';

  @override
  String get syncRecoveryCodeDescription =>
      'Se perdi tutti i tuoi dispositivi, questo codice ripristina il tuo diario sincronizzato. Conservalo in un gestore di password o su carta. Viene mostrato solo questa volta.';

  @override
  String get syncRecoveryCodeCopied => 'Codice di ripristino copiato';

  @override
  String get syncRecoveryCodeSaved => 'L\'ho salvato';

  @override
  String get syncJoinNeedsKey =>
      'Questo diario sincronizzato appartiene agli altri tuoi dispositivi. Accoppialo con uno di essi o utilizza il codice di ripristino. Le voci su questo dispositivo verranno aggiunte ad esso.';

  @override
  String get syncPairDevice => 'Accoppiamento con un dispositivo';

  @override
  String get syncUseRecoveryCode => 'Utilizza il codice di ripristino';

  @override
  String get syncAddDevice => 'Aggiungi un dispositivo';

  @override
  String get syncChangeRecoveryCode => 'Cambia il codice di ripristino';

  @override
  String get syncChangeRecoveryDescription =>
      'Un nuovo codice sostituisce quello attuale, che smette di funzionare. I tuoi dati e gli altri dispositivi rimangono così come sono.';

  @override
  String get syncNewRandomCode => 'Nuovo codice casuale';

  @override
  String get syncRecoveryCodeChanged =>
      'Il codice di ripristino è stato modificato';

  @override
  String get syncResetSpace => 'Ricomincia da capo il diario sincronizzato';

  @override
  String get syncResetSpaceDescription =>
      'Solo quando nessun dispositivo e nessun codice di ripristino lo apre più: la copia sincronizzata viene sostituita dal diario su questo dispositivo, sotto le chiavi di questo dispositivo. Gli altri dispositivi si accoppiano nuovamente.';

  @override
  String get syncPairTitle => 'Associa i dispositivi';

  @override
  String get syncPairShow => 'Mostra un codice';

  @override
  String get syncPairEnter => 'Inserisci un codice';

  @override
  String get syncPairShowHint =>
      'Sull\'altro dispositivo, apri Associa dispositivi, scegli Inserisci un codice e digitalo o scansionalo.';

  @override
  String get syncPairEnterHint =>
      'Digita il codice mostrato dall\'altro dispositivo o scansionalo.';

  @override
  String get syncPairCode => 'Codice di abbinamento';

  @override
  String get syncPairScan => 'Scansione';

  @override
  String get syncPairStart => 'Coppia';

  @override
  String get syncPairWaiting => 'In attesa dell\'altro dispositivo...';

  @override
  String syncPairDone(String device) {
    return 'Abbinato a $device';
  }

  @override
  String get syncPairWrongCode =>
      'Il codice non corrispondeva. Mostra un nuovo codice e riprova.';

  @override
  String get syncPairNoOffer =>
      'Nessun dispositivo mostra questo codice. Potrebbe essere scaduto.';

  @override
  String get syncPairTimedOut =>
      'L\'altro dispositivo non ha risposto in tempo.';

  @override
  String get syncPairNeither =>
      'Nessuno dei due dispositivi è ancora configurato con questo diario sincronizzato.';

  @override
  String get syncPairBoth =>
      'Entrambi i dispositivi aprono già questo diario sincronizzato.';

  @override
  String syncPairFailed(String error) {
    return 'Associazione non riuscita: $error';
  }

  @override
  String get syncMediaPending =>
      'Diario sincronizzato · alcuni media sono ancora in trasferimento';

  @override
  String get syncWaitingForDevices =>
      'Diario sincronizzato · in attesa che un altro dispositivo trasferisca i contenuti multimediali';

  @override
  String get syncCacheNotice =>
      'I media cloud sono temporanei. Conserva gli originali sui tuoi dispositivi; la sincronizzazione non è un backup.';

  @override
  String get paperTitle => 'Carta da lettere';

  @override
  String get paperPlain => 'Semplice';

  @override
  String get paperLined => 'Foderato';

  @override
  String get paperGrid => 'Griglia';

  @override
  String get paperTinted => 'Colorato';

  @override
  String get paperDecorationTitle => 'Decorazioni';

  @override
  String get paperDecorationNone => 'Nessuno';

  @override
  String get paperDecorationBotanical => 'Foglie';

  @override
  String get paperDecorationStars => 'Stelle';

  @override
  String get paperDecorationWashi => 'Nastro adesivo Washi';

  @override
  String get themeDarkChoice => 'Aspetto scuro';

  @override
  String get themeDarkSame => 'Segui la tavolozza chiara';

  @override
  String get themeDarkCustom => 'Tavolozza separata';

  @override
  String get themeDarkAccent => 'Colore accento scuro';

  @override
  String get themeColorTeal => 'Verde acqua';

  @override
  String get themeColorCyan => 'Ciano';

  @override
  String get themeColorIndigo => 'Indaco';

  @override
  String get themeColorCoral => 'Corallo';

  @override
  String get themeColorOlive => 'Oliva';

  @override
  String get themeColorSlate => 'Ardesia';

  @override
  String get drawingTitle => 'Disegno';

  @override
  String get drawingPen => 'Penna';

  @override
  String get drawingEraser => 'Gomma';

  @override
  String get drawingUndo => 'Annulla';

  @override
  String get drawingClear => 'Chiaro';

  @override
  String get drawingWidth => 'Larghezza della penna';

  @override
  String get drawingStylusOnly => 'Solo stilo';

  @override
  String get drawingDiscardTitle => 'Scartare il disegno?';

  @override
  String get drawingDiscardBody => 'Questo disegno non è stato salvato.';

  @override
  String get drawingSaveError => 'Impossibile salvare il disegno.';

  @override
  String get syncNetworkTitle => 'Diagnostica di rete';

  @override
  String get syncNetworkRefresh => 'Aggiorna';

  @override
  String get syncNetworkSelectedRoute => 'Percorso attuale';

  @override
  String get syncNetworkAvailableRoutes => 'Percorsi disponibili';

  @override
  String get syncNetworkSignaling =>
      'Connessione alla directory del dispositivo';

  @override
  String get syncNetworkRelayRemaining => 'Restante indennità per la staffetta';

  @override
  String get syncNetworkIcePair => 'Candidati al collegamento diretto';

  @override
  String get syncNetworkPeerTrusted => 'Dispositivo autenticato';

  @override
  String get syncNetworkNoRoute => 'In attesa di una connessione';

  @override
  String get syncNetworkUnavailable => 'La diagnostica non è disponibile';

  @override
  String get syncMediaCopiesTitle => 'Consegna dei media e copie';

  @override
  String get syncMediaPendingCount => 'In attesa di trasferimento';

  @override
  String get syncMediaDurableCount => 'Consegnato al deposito personale';

  @override
  String get syncMediaTemporaryCount => 'Copie temporanee o non confermate';

  @override
  String get syncMediaReceiptExplanation =>
      'Questi conteggi descrivono consegne completate, non un nuovo controllo dei backup sopravvissuti.';

  @override
  String get syncMediaCacheExplanation =>
      'I supporti cloud temporanei possono scadere. Conserva gli originali o un backup separato.';

  @override
  String get momentsTitle => 'Momenti fotografici';

  @override
  String get momentsHint =>
      'Trova gruppi utilizzando gli orari delle foto locali e le coordinate opzionali. Le foto vengono allegate solo quando scegli una carta.';

  @override
  String get momentsScan => 'Trova momenti';

  @override
  String get momentsChooseFolder => 'Scegli la cartella delle foto';

  @override
  String get momentsLocation => 'Includi posizioni di foto';

  @override
  String get momentsEmpty => 'Nessun gruppo di foto recente.';

  @override
  String get momentsCreate => 'Scrivi di queste foto';

  @override
  String get momentsDismiss => 'Ignora';

  @override
  String get momentsError => 'Impossibile leggere le foto locali.';

  @override
  String get momentsCreated => 'Voce fotografica creata.';

  @override
  String get momentsPermission =>
      'Consenti l\'accesso alle foto per trovare suggerimenti locali.';

  @override
  String get momentsScope =>
      'Solo foto recenti; al massimo 500 foto e 20 foto per scheda.';

  @override
  String momentsPhotoCount(int count) {
    return 'Foto $count';
  }

  @override
  String get nearbyTitle => 'Connetti i dispositivi';

  @override
  String get nearbySend => 'Autorizza un altro dispositivo';

  @override
  String get nearbyReceive => 'Connettiti a un dispositivo esistente';

  @override
  String get nearbyInstructions =>
      'Collega entrambi i dispositivi allo stesso Wi-Fi o all\'hotspot dell\'altro. Confermare l\'autorizzazione sul dispositivo esistente; entrambi i dispositivi rimangono utilizzabili. Non è necessaria alcuna connessione Internet.';

  @override
  String get nearbyCompare =>
      'Confronta questo codice su entrambi i dispositivi prima di approvarlo.';

  @override
  String get nearbyConfirm => 'I codici corrispondono';

  @override
  String get nearbyScan => 'Scansiona il codice dell\'altro dispositivo';

  @override
  String get nearbyPaste => 'Incolla l\'invito';

  @override
  String get nearbyWaiting =>
      'In attesa di approvazione sull\'altro dispositivo';

  @override
  String get nearbyWorking =>
      'Autorizzare e sincronizzare il tuo diario e gli allegati...';

  @override
  String get nearbyPending =>
      'Alcuni allegati necessitano ancora di sincronizzazione. Mantieni l\'altro dispositivo online e riprova.';

  @override
  String get nearbyComplete =>
      'Dispositivo connesso; diario e allegati sincronizzati';

  @override
  String get nearbyFailed =>
      'La connessione non è terminata. Controlla la connessione locale e riprova.';

  @override
  String get nearbyEmptyRequired =>
      'Utilizza un dispositivo con un\'agenda vuota che non è ancora connesso alla sincronizzazione.';

  @override
  String get nearbyRetry => 'Continua la sincronizzazione';

  @override
  String get nearbyWifi => 'Impostazioni Wi-Fi';

  @override
  String get nearbyHotspot => 'Impostazioni dell\'hotspot';

  @override
  String get nearbyKeepOpen =>
      'Mantieni questa pagina aperta fino al completamento dell\'installazione del nuovo dispositivo. L\'invito scade dopo due minuti.';

  @override
  String get syncDevicesTitle => 'Dispositivi autorizzati';

  @override
  String get syncDevicesDescription =>
      'Solo i dispositivi approvati possono accedere a questo account AID. La revoca di un dispositivo blocca il server ma non può cancellare una chiave principale o un diario già copiato su di esso.';

  @override
  String get syncDeviceRequest =>
      'Mostra questo QR di autorizzazione a un dispositivo approvato';

  @override
  String get syncDeviceAuthorize => 'Autorizzare un dispositivo';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Scansiona o incolla la richiesta di autorizzazione del nuovo dispositivo.';

  @override
  String get syncDeviceRevoke => 'Revoca';

  @override
  String get syncDeviceRotate =>
      'Ruota la chiave di firma di questo dispositivo';

  @override
  String get syncDeviceCheck => 'Controlla l\'autorizzazione';

  @override
  String get syncDeviceHardware => 'Chiave di firma supportata da hardware';

  @override
  String get syncDeviceSoftware =>
      'Chiave di firma del software non esportabile';

  @override
  String get syncDeviceUnavailable =>
      'L\'autorizzazione del dispositivo non è disponibile. Approva questo dispositivo da un altro dispositivo autorizzato e riprova.';

  @override
  String get syncDeviceRevoked => 'Revocato';

  @override
  String get syncDeviceLocal => 'Questo dispositivo';

  @override
  String get cloudTrafficTitle =>
      'Quota mensile di trasferimento dati cloud per file multimediali';

  @override
  String get cloudTrafficLimit => 'Quota mensile di trasferimento dati';

  @override
  String get cloudTrafficUsed => 'Trasferimento dati utilizzato';

  @override
  String get cloudTrafficRemaining => 'Trasferimento dati rimanente';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'La quota di trasferimento dati viene reimpostata $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'La quota di trasferimento dati cloud per i file multimediali è stata esaurita. I file multimediali mancanti verranno sincronizzati automaticamente quando è disponibile una connessione diretta o la quota viene reimpostata.';

  @override
  String get cloudTrafficExplanation =>
      'La memorizzazione nella cache dei file multimediali e l\'inoltro live condividono questa quota di trasferimento dati. Le connessioni dirette non lo consumano. I messaggi di testo del diario e di controllo della connessione hanno piccoli limiti giornalieri separati.';

  @override
  String get appearanceThemeSection => 'Tema dell\'app';

  @override
  String get appearancePaperSection => 'Carta del diario';

  @override
  String get appearanceTypographySection => 'Testo del diario';

  @override
  String get appearancePreferencesSection => 'Preferenze generali';

  @override
  String get themeSystemAccentHint =>
      'Utilizza la tavolozza di sistema anziché i colori personalizzati. Spegnilo per scegliere il tuo.';

  @override
  String get syncDeviceNameSaveFailed =>
      'Impossibile salvare il nome del dispositivo. Per favore riprova.';

  @override
  String get nearbyConnectionHelp => 'Aiuto per la connessione';

  @override
  String get syncAllSynced => 'Tutto sincronizzato';

  @override
  String get syncDetailsTitle => 'Sincronizza i dettagli';

  @override
  String get syncMore => 'Più opzioni';

  @override
  String get syncDeviceName => 'Nome del dispositivo';

  @override
  String get syncDeviceNameHint => 'Ad esempio: il mio tablet';

  @override
  String get syncDeviceNameInvalid => 'Utilizza da 1 a 32 caratteri';

  @override
  String get syncDeviceKeyDetails => 'Dettagli di sicurezza';

  @override
  String get syncConnectionProblem =>
      'Impossibile sincronizzare per ora. Nuovo tentativo automatico.';

  @override
  String get syncCopyComplete =>
      'Copia completa del tuo diario e dei file multimediali';

  @override
  String get syncCopyPartial => 'Mancano ancora alcuni media';

  @override
  String get syncCopyOlder =>
      'Nuove modifiche sono in attesa di sincronizzazione';

  @override
  String get syncCopyUnavailable =>
      'I dettagli della copia non sono disponibili. Riprova più tardi.';

  @override
  String get syncCopyLastKnown =>
      'Altri dispositivi mostrano la loro ultima copia confermata. I dispositivi offline non possono essere controllati ora.';

  @override
  String get syncCopyTemporary =>
      'Cache temporanea. Mantieni gli originali sui tuoi dispositivi.';

  @override
  String get syncCopyStorage =>
      'Il tuo spazio di archiviazione sincronizzato. I caricamenti multimediali completati sono elencati nella diagnostica.';

  @override
  String syncCopyChecked(String time) {
    return 'Ultimo $time confermato';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Trasferimento dati rimanente questo mese: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Inizia qui';

  @override
  String get onboardConnect => 'Connettiti a un dispositivo esistente';

  @override
  String get onboardFailed =>
      'Impossibile completare l\'installazione. Il tuo diario è al sicuro; per favore riprova.';

  @override
  String get tutorialTitle => 'Come utilizzare il diario';

  @override
  String get tutorialWriteTitle => 'Scrivi la tua prima voce nel diario';

  @override
  String get tutorialWriteText =>
      'Tocca + per scrivere una voce nel diario. Aggiungi un titolo facoltativo, scegli la data del diario e tocca il segno di spunta per salvare. Puoi modificare nuovamente la voce del tuo diario in qualsiasi momento.';

  @override
  String get tutorialMediaTitle => 'Aggiungi foto, audio o grafia';

  @override
  String get tutorialMediaText =>
      'Utilizza + nell\'editor del diario per allegare foto, video o una registrazione vocale oppure per aprire l\'area di scrittura a mano. Questi allegati vengono salvati con la voce del diario.';

  @override
  String get tutorialReviewTitle => 'Trova di nuovo un giorno';

  @override
  String get tutorialReviewText =>
      'Sfoglia il tuo diario o calendario, cerca nei tuoi scritti e organizza le voci con tag. Le pagine Media e Atlante ti consentono di trovare le voci precedenti per foto o posizione.';

  @override
  String get tutorialSyncTitle => 'Utilizza più di un dispositivo';

  @override
  String get tutorialSyncText =>
      'In Impostazioni → Dati e archiviazione → Sincronizzazione, connettiti a un dispositivo esistente e conferma l\'autorizzazione su quel dispositivo. Entrambi i dispositivi possono continuare a utilizzare il diario. Il testo del diario viene sincronizzato per primo. I file multimediali verranno sincronizzati successivamente quando la connessione di rete e la quota di trasferimento dati rimanente lo consentono.';

  @override
  String get tutorialPrivacyTitle => 'Tieni il tuo diario al sicuro';

  @override
  String get tutorialPrivacyText =>
      'Le voci del diario rimangono su questo dispositivo a meno che non abiliti la sincronizzazione o le condividi o le esporti. La sincronizzazione è crittografata end-to-end. In Impostazioni puoi anche impostare un passcode per l\'app, creare backup e riaprire questo tutorial.';

  @override
  String get editorDiaryDay => 'Giorno del diario';

  @override
  String get editorDiaryDayPicker =>
      'Giorno del diario · A quale giorno appartiene questa voce?';

  @override
  String editorCreatedAt(String time) {
    return 'Creata $time';
  }

  @override
  String get editorDiaryDayHint =>
      'Il giorno a cui appartiene questa voce. Modificarlo non cambia la data o l’ora di creazione.';

  @override
  String get hiddenDiaryTitle => 'Voci nascoste';

  @override
  String get hiddenDiaryHide => 'Nascondi voce';

  @override
  String get hiddenDiaryShow => 'Mostra voce';

  @override
  String get hiddenDiaryEmpty => 'Nessuna voce nascosta';

  @override
  String get hiddenDiaryUnlock => 'Sblocca le voci nascoste';

  @override
  String get hiddenDiaryAuthHint =>
      'Usa il blocco dell’app o dello schermo del dispositivo.';

  @override
  String hiddenDiaryWhere(String path) {
    return 'Nascosta. Per mostrarla di nuovo: $path';
  }

  @override
  String get noteKeep => 'Conserva';

  @override
  String get noteComment => 'Commenta';

  @override
  String get noteCommentHint => 'Scrivi al te del passato';

  @override
  String get noteKept => 'Passo conservato';

  @override
  String get notesPassages => 'Passi conservati';

  @override
  String get notesComments => 'Commenti';

  @override
  String get noteDeleteConfirm => 'Eliminare questa nota?';

  @override
  String get editPastTitle => 'Modificare un ricordo passato?';

  @override
  String get editPastBody =>
      'Questa voce è di un giorno precedente. Per rispondere, seleziona il testo per conservarlo o commentarlo.';

  @override
  String get editPastDontAsk => 'Non chiedere più';

  @override
  String get editPastEdit => 'Modifica comunque';

  @override
  String noteOnEntry(String date) {
    return 'Sulla voce del $date';
  }

  @override
  String get settingsConfirmEditPast =>
      'Chiedi prima di modificare voci passate';

  @override
  String get settingsCompressPhotos => 'Comprimi le nuove foto';

  @override
  String get settingsCompressPhotosHint =>
      'Salva le nuove foto come WebP di circa 1 MB. Disattivato conserva gli originali.';

  @override
  String get compressExistingTitle => 'Comprimi le foto esistenti';

  @override
  String compressExistingBody(int count, String size) {
    return '$count foto occupano $size. Quelle oltre circa 1 MB diventano WebP di circa 1 MB. Vengono sostituite e non si può annullare; conserva gli originali altrove se ti servono.';
  }

  @override
  String get compressExistingAction => 'Comprimi';

  @override
  String compressExistingDone(int count, String size) {
    return '$count foto compresse, risparmiati $size';
  }

  @override
  String get commentExpand => 'Espandi';

  @override
  String get refAdd => 'Cita una voce';

  @override
  String get refMissing => 'Quella voce non c’è più';

  @override
  String get moodClear => 'Rimuovi umore';

  @override
  String get scrollToTop => 'Torna in alto';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackHint => 'Descrivi un problema o un suggerimento';

  @override
  String get feedbackSend => 'Invia';

  @override
  String get feedbackSent => 'Grazie, il tuo feedback è stato inviato.';

  @override
  String get feedbackSendFailed =>
      'Invio non riuscito. Controlla la connessione e riprova.';

  @override
  String get feedbackOpenFailed => 'Impossibile aprire l\'app.';

  @override
  String get feedbackSendNote =>
      'Inviato al server di AID Diary con versione e lingua dell\'app, niente del tuo diario.';

  @override
  String get feedbackGithub => 'Segnalazione GitHub';

  @override
  String get feedbackEmail => 'Invia e-mail';

  @override
  String updateAvailable(String version) {
    return 'AID Diary $version è disponibile';
  }

  @override
  String get updateClosesNote =>
      'L\'app si chiude per installare l\'aggiornamento; riaprila dopo.';

  @override
  String get updateLater => 'Più tardi';

  @override
  String get updateSkip => 'Salta questa versione';

  @override
  String get updateInstall => 'Aggiorna';

  @override
  String updateDownloading(int percent) {
    return 'Download in corso… $percent%';
  }

  @override
  String get updateAllowInstall =>
      'Consenti ad AID Diary di installare app nelle impostazioni aperte, poi tocca di nuovo Aggiorna.';

  @override
  String updateFailed(String reason) {
    return 'Impossibile installare l\'aggiornamento: $reason';
  }

  @override
  String updatedTo(String version) {
    return 'Aggiornato a $version';
  }

  @override
  String get updateWhatsNew => 'Novità';

  @override
  String get updateCheckNow => 'Cerca aggiornamenti';

  @override
  String get updateNewest => 'Questa è la versione più recente.';

  @override
  String get updateAutoCheck => 'Cerca aggiornamenti automaticamente';

  @override
  String get updateSilent => 'Installa gli aggiornamenti senza chiedere';

  @override
  String get updateSilentHint =>
      'Scarica in background e installa quando esci dall\'app. Android chiede una volta, la prima.';
}
