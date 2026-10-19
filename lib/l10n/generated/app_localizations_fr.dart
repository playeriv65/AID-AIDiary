// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

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
  String get dailyReminderTitle => 'Notez votre journée !';

  @override
  String get dailyReminderDescription =>
      'N\'oubliez pas d\'enregistrer votre journée…';

  @override
  String get actionTakePhoto => 'Prendre une photo';

  @override
  String get actionToday => 'Aujourd\'hui';

  @override
  String get actionOtherDay => 'Autre jour';

  @override
  String get pageHomeTitle => 'Accueil';

  @override
  String get jumpToMonthTitle => 'Aller au mois';

  @override
  String get jumpToLogTitle => 'Aller à l’entrée';

  @override
  String get flashbacksTitle => 'Souvenirs';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Exclure les mauvais jours';

  @override
  String get flaskbacksEmpty => 'Pas encore de souvenirs…';

  @override
  String get flashbackGoodDay => 'Une bonne journée';

  @override
  String get flashbackRandomDay => 'Une journée ordinaire';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count semaines',
      one: '$count semaine',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mois',
      one: '$count mois',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ans',
      one: '$count an',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'Il y a 1 an';

  @override
  String get pageGalleryTitle => 'Galerie';

  @override
  String get searchLogsHint => 'Rechercher des souvenirs…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count enregistrements',
      one: '$count enregistrement',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '$count jour',
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
  String get noLogs => 'Aucun souvenir…';

  @override
  String get noResults => 'Aucun résultat…';

  @override
  String get sortDateTitle => 'Date';

  @override
  String get sortOrderAscendingTitle => 'Ascendant';

  @override
  String get sortOrderDescendingTitle => 'Descendant';

  @override
  String get pageStatisticsTitle => 'Statistiques';

  @override
  String get statisticsNotEnoughData => 'Pas assez de données…';

  @override
  String get statisticsRangeOneMonth => '1 mois';

  @override
  String get statisticsRangeSixMonths => '6 mois';

  @override
  String get statisticsRangeOneYear => '1 an';

  @override
  String get statisticsRangeAllTime => 'Historique complet';

  @override
  String chartSummaryTitle(Object tag) {
    return 'Résumé $tag';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag par jour';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag sur la durée';
  }

  @override
  String get chartGroupingLabel => 'Grouper par';

  @override
  String get chartGroupingDay => 'Jour';

  @override
  String get chartGroupingWeek => 'Semaine';

  @override
  String get chartGroupingMonth => 'Mois';

  @override
  String get chartGroupingYear => 'Année';

  @override
  String get chartSmoothingLabel => 'Lissage';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Série actuelle $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Série la plus longue $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bonnes journées $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'jours depuis une mauvaise journée $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Impossible d\'accéder au stockage externe';

  @override
  String get errorExternalStorageAccessDescription =>
      'Si vous utilisez le stockage en réseau, assurez-vous que le service est en ligne et que vous avez accès au réseau.\n\nDans le cas contraire, l\'application peut avoir perdu les autorisations pour le dossier externe. Allez dans les paramètres et resélectionnez le dossier externe pour lui accorder l\'accès.\n\nAttention, les modifications ne seront pas synchronisées tant que vous n\'aurez pas rétabli l\'accès à l\'emplacement de stockage externe !';

  @override
  String get errorExternalStorageAccessContinue =>
      'Poursuivre avec la base de données locale';

  @override
  String get databaseMigrationErrorTitle =>
      'Déplacement des données impossible';

  @override
  String get databaseMigrationErrorDescription =>
      'Vos entrées sont en sécurité mais n\'ont pas pu être déplacées dans le stockage applicatif.\n\nEssayez de nouveau et signaler ce souci s’il continue de se produire.';

  @override
  String get databaseMigrationErrorRetry => 'Réessayer';

  @override
  String get errorReport => 'Signaler un problème';

  @override
  String get lastModified => 'Modification';

  @override
  String get writeSomethingHint => 'Écrivez quelque chose…';

  @override
  String get titleHint => 'Titre…';

  @override
  String get deleteLogTitle => 'Supprimer le souvenir';

  @override
  String get deleteLogDescription => 'Voulez-vous supprimer ce souvenir ?';

  @override
  String get deletePhotoTitle => 'Supprimer la photo';

  @override
  String get deletePhotoDescription => 'Voulez-vous supprimer cette photo ?';

  @override
  String get pageSettingsTitle => 'Paramètres';

  @override
  String get settingsAppearanceTitle => 'Apparence';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => '1er jour de la semaine';

  @override
  String get settingsCalendarSystem => 'Système calendaire';

  @override
  String get calendarSystemGregorian => 'Grégorien';

  @override
  String get calendarSystemJalali => 'Jalali';

  @override
  String get settingsUseSystemAccentColor =>
      'Utiliser la couleur d\'appui du système';

  @override
  String get settingsCustomAccentColor => 'Couleur d\'appui personnalisée';

  @override
  String get settingsShowMarkdownToolbar =>
      'Afficher la barre d\'outils Markdown';

  @override
  String get settingsShowFlashbacks => 'Afficher les souvenirs';

  @override
  String get settingsChangeMoodIcons => 'Modifier les icônes d\'humeur';

  @override
  String get moodIconPrompt => 'Saisir une icône';

  @override
  String get settingsFlashbacksViewLayout =>
      'Disposition de la vue des flashbacks';

  @override
  String get settingsHideImagesInGallery => 'Cacher les images dans la galerie';

  @override
  String get settingsHideImages => 'Masquer les images';

  @override
  String get pageCalendarTitle => 'Agenda';

  @override
  String get settingsNotificationsTitle => 'Notifications';

  @override
  String get settingsDailyReminderOnboarding =>
      'Activer le rappel quotidien pour être consistant !';

  @override
  String get settingsNotificationsPermissionsPrompt =>
      'On demandera l\'autorisation « alarme planifiée » pour envoyer un rappel à un moment au hasard ou au moment que vous souhaitez.';

  @override
  String get settingsDailyReminderTitle => 'Rappel quotidien';

  @override
  String get settingsOnThisDayDescription => 'Revisiter des mémoires d\'avant';

  @override
  String get settingsDailyReminderDescription =>
      'Un simple rappel tous les jours';

  @override
  String get settingsReminderTime => 'Heure du rappel';

  @override
  String get settingsFixedReminderTimeTitle => 'Heure fixe du rappel';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Choisir une heure fixe pour le rappel';

  @override
  String get settingsAlwaysSendReminderTitle => 'Toujours envoyer un rappel';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Envoyer un rappel même si une entrée est déjà commencée';

  @override
  String get settingsCustomizeNotificationTitle =>
      'Personnaliser les notifications';

  @override
  String get settingsTemplatesTitle => 'Modèles';

  @override
  String get settingsDefaultTemplate => 'Modèle par défaut';

  @override
  String get manageTemplates => 'Gérer les modèles';

  @override
  String get addTemplate => 'Ajouter un modèle';

  @override
  String get newTemplate => 'Nouveau modèle';

  @override
  String get noTemplateTitle => 'Aucun';

  @override
  String get noTemplatesDescription => 'Aucun modèle créé pour l\'instant…';

  @override
  String get templateVariableTime => 'Heure';

  @override
  String get templateDefaultTimestampTitle => 'Horodatage';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date – $time :';
  }

  @override
  String get templateDefaultSummaryTitle => 'Résumé du jour';

  @override
  String get templateDefaultSummaryBody => '### Résumé\n- \n\n### Avis\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Remarque';

  @override
  String get templateDefaultReflectionBody =>
      '### Qu\'est-ce qui vous a plu aujourd\'hui ?\n- \n\n### Pour quoi avez-vous de la reconnaissance ?\n- \n\n### Qu\'est-ce qu\'il vous tarde ?\n- ';

  @override
  String get settingsTagsTitle => 'Étiquettes';

  @override
  String get manageTags => 'Gestion des étiquettes';

  @override
  String get tagTypeLabelTitle => 'Label';

  @override
  String get tagTypeTrackerTitle => 'Compteur';

  @override
  String get nameHint => 'Nom';

  @override
  String get tagColorLabel => 'Couleur';

  @override
  String get iconPickerTitle => 'Choisir une icône';

  @override
  String get iconPickerIconsTab => 'Icône';

  @override
  String get iconPickerCustomTab => 'Personnalisée';

  @override
  String get iconPickerSearchHint => 'Chercher des icônes…';

  @override
  String get colorPickerTitle => 'Choisir une couleur';

  @override
  String get colorPickerPaletteTab => 'Couleurs';

  @override
  String get iconGroupMoodPeople => 'Humeur et gens';

  @override
  String get iconGroupHealth => 'Santé';

  @override
  String get iconGroupWorkFinance => 'Travail et finance';

  @override
  String get iconGroupHabitsGoals => 'Habitudes et objectifs';

  @override
  String get iconGroupNature => 'Nature';

  @override
  String get iconGroupFoodDrink => 'Boire et manger';

  @override
  String get iconGroupHome => 'Maison';

  @override
  String get iconGroupTravel => 'Voyage';

  @override
  String get iconGroupSymbols => 'Symboles';

  @override
  String get tagCategoryLabel => 'Catégorie';

  @override
  String get tagLabel => 'Étiquette';

  @override
  String get tagCategoryUncategorized => 'Sans catégorie';

  @override
  String get newCategoryTitle => 'Nouvelle catégorie';

  @override
  String get shareButtonLabel => 'Partager';

  @override
  String get importErrorDescription => 'Échec de l\'import du fichier !';

  @override
  String get exportErrorDescription => 'Échec de l\'export du fichier !';

  @override
  String get deleteTitle => 'Supprimer';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Il est utilisé dans $count enregistrements.',
      one: ' Il est utilisé dans 1 enregistrement.',
      zero: '',
    );
    return 'Supprimer « $name » ?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Les $count étiquettes seront aussi supprimées.',
      one: ' Son étiquette sera aussi supprimée.',
      zero: '',
    );
    return 'Supprimer « $name » ?$_temp0';
  }

  @override
  String deleteTemplateMessage(Object name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String get filterTagsTitle => 'Filtrer';

  @override
  String get tagFilterModeAny => 'N’importe quelle étiquette';

  @override
  String get tagFilterModeAll => 'Toutes les étiquettes';

  @override
  String get clearAllFilters => 'Tout effacer';

  @override
  String get noTagsFilterLabel => 'Aucune étiquette';

  @override
  String get addTagsTitle => 'Ajouter des étiquettes';

  @override
  String get addTagsSearchHint => 'Chercher des étiquettes…';

  @override
  String get tagPickerSortManualLabel => 'Ordre manuel';

  @override
  String get tagPickerSortUsageLabel => 'Trier par utilisation';

  @override
  String get tagFavoriteName => 'Favoris';

  @override
  String get tagEnergyName => 'Énergie';

  @override
  String get tagCategoryActivitiesName => 'Activités';

  @override
  String get tagExerciseName => 'Exercice';

  @override
  String get tagSocializingName => 'Vie sociale';

  @override
  String get tagHobbyName => 'Loisir';

  @override
  String get tagEntertainmentName => 'Divertissement';

  @override
  String get tagDiningName => 'Dîner';

  @override
  String get tagChoresName => 'Tâches ménagères';

  @override
  String get tagCategoryEmotionsName => 'Émotions';

  @override
  String get tagExcitedName => 'Impatience';

  @override
  String get tagGratefulName => 'Reconnaissance';

  @override
  String get tagCalmName => 'Calme';

  @override
  String get tagTiredName => 'Fatigue';

  @override
  String get tagAnxiousName => 'Anxiété';

  @override
  String get tagAnnoyedName => 'Ennui';

  @override
  String get welcomeLogBodyText =>
      '## Welcome to AID Diary\n\n> Every day is worth remembering.\n\nWrite what happened, how you felt, and where you were. Your entries stay on this device.\n\n- **Journal** lists every entry by day\n- **Calendar**, **Media** and **Atlas** look back by date, photo and place\n- **Coach** offers prompts and templates when you don\'t know what to write\n\nAID Diary is a modified version of [Daily You](https://github.com/Demizo/Daily_You) by Demizo and contributors, and not the official Daily You app.';

  @override
  String get settingsStorageTitle => 'Stockage';

  @override
  String get settingsImageQuality => 'Qualité d\'image';

  @override
  String get imageQualityHigh => 'Élevée';

  @override
  String get imageQualityMedium => 'Moyenne';

  @override
  String get imageQualityLow => 'Basse';

  @override
  String get imageQualityNoCompression => 'Sans compression';

  @override
  String get settingsLogFolder => 'Dossier d\'enregistrement';

  @override
  String get settingsImageFolder => 'Dossier d\'images';

  @override
  String get warningTitle => 'Attention';

  @override
  String get logFolderWarningDescription =>
      'Si le dossier sélectionné contient déjà un fichier \'daily_you.db\', celui-ci sera utilisé pour écraser vos enregistrements existants !';

  @override
  String get errorTitle => 'Erreur';

  @override
  String get logFolderErrorDescription =>
      'Échec de la modification du dossier d\'enregistrement !';

  @override
  String get imageFolderErrorDescription =>
      'Échec de la modification du dossier de l\'image !';

  @override
  String get backupErrorDescription =>
      'Échec de la création de la sauvegarde !';

  @override
  String get restoreErrorDescription =>
      'Échec de la restauration de la sauvegarde !';

  @override
  String get settingsBackupRestoreTitle => 'Sauvegarde et restauration';

  @override
  String get settingsBackup => 'Sauvegarde';

  @override
  String get settingsRestore => 'Restauration';

  @override
  String get settingsRestorePromptDescription =>
      'La restauration d’une sauvegarde remplacera vos données existantes !';

  @override
  String get settingsBackupPasswordProtect =>
      'Sauvegardes protégées par mot de passe';

  @override
  String get backupEncryptedTitle => 'Sauvegarde chiffrée';

  @override
  String get backupEncryptedContent =>
      'Cette sauvegarde est protégée par mot de passe.';

  @override
  String get settingsAutoBackup => 'Sauvegardes automatiques';

  @override
  String get settingsAutoBackupLocation => 'Emplacement de sauvegarde';

  @override
  String get settingsAutoBackupInterval => 'Intervalle de sauvegarde';

  @override
  String get settingsAutoBackupIntervalDaily => 'Quotidienne';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Hebdomadaire';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Mensuelle';

  @override
  String get settingsAutoBackupMaxCount => 'Sauvegardes à conserver';

  @override
  String get settingsAutoBackupRequireCharging => 'Seulement en charge';

  @override
  String settingsBackupLast(Object time) {
    return 'Dernière sauvegarde $time';
  }

  @override
  String get settingsBackupNever => 'Jamais sauvegardé';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Prochaine sauvegarde $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'Toutes';

  @override
  String get autoBackupFailedTitle => 'Échec de la sauvegarde';

  @override
  String tranferStatus(Object percent) {
    return 'Transfert… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Création de la sauvegarde… $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Restauration de ka sauvegarde… $percent%';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return 'Chiffrement de la sauvegarde… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Déchiffrement de la sauvegarde… $percent%';
  }

  @override
  String get cleanUpStatus => 'Nettoyage…';

  @override
  String migratingImagesStatus(Object current, Object total) {
    return 'Migration des photos… $current/$total';
  }

  @override
  String get settingsExport => 'Exporter';

  @override
  String get settingsExportToAnotherFormat => 'Exporter dans un autre format';

  @override
  String get settingsExportFormatDescription =>
      'Ne doit pas être utilisé comme sauvegarde !';

  @override
  String get exportLogs => 'Exporter les enregistrements';

  @override
  String get exportImages => 'Exporter les images';

  @override
  String get settingsImport => 'Importer';

  @override
  String get settingsImportFromAnotherApp => 'Import d’une autre application';

  @override
  String get settingsTranslateCallToAction =>
      'Tout le monde devrait avoir accès à un journal !';

  @override
  String get settingsHelpTranslate => 'Aider à traduire';

  @override
  String get importLogs => 'Importer les enregistrements';

  @override
  String get importImages => 'Importer les images';

  @override
  String get logFormatTitle => 'Choisissez le format';

  @override
  String get logFormatDescription =>
      'Le format d’un autre application peut ne pas prendre en charge toutes les fonctionnalités. Merci de signaler tout problème étant donné que les formats tiers peuvent changer avec le temps. Cela n’affectera pas les journaux existants !';

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
  String get settingsDeleteAllLogsTitle => 'Supprimer tous les enregistrements';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Voulez-vous supprimer tous vos enregistrements ?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Écrivez \'$prompt\' pour confirmer. Cette action est irréversible !';
  }

  @override
  String get settingsLanguageTitle => 'Langue';

  @override
  String get settingsAppLanguageTitle => 'Ajouter une langue';

  @override
  String get settingsOverrideAppLanguageTitle =>
      'Surcharger la langue de l\'application';

  @override
  String get settingsSecurityTitle => 'Sécurité';

  @override
  String get settingsSecurityRequirePassword => 'Exiger un mot de passe';

  @override
  String get settingsSecurityEnterPassword => 'Entrer le mot de passe';

  @override
  String get settingsSecuritySetPassword => 'Définir le mot de passe';

  @override
  String get settingsSecurityChangePassword => 'Modifier le mot de passe';

  @override
  String get settingsSecurityPassword => 'Mot de passe';

  @override
  String get settingsSecurityConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get settingsSecurityOldPassword => 'Ancien mot de passe';

  @override
  String get settingsSecurityIncorrectPassword => 'Mot de passe incorrect';

  @override
  String get settingsSecurityPasswordsDoNotMatch =>
      'Les mots de passe sont différents';

  @override
  String get requiredPrompt => 'Requis';

  @override
  String get settingsSecurityBiometricUnlock => 'Déverrouillage biométrique';

  @override
  String get unlockAppPrompt => 'Déverrouiller l\'application';

  @override
  String get settingsAboutTitle => 'À propos';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsLicense => 'Licence';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsSourceCode => 'Code source';

  @override
  String get settingsOpenSourceLicenses => 'Licences Open Source';

  @override
  String get settingsMadeWithLove => 'Fait avec ❤️';

  @override
  String get settingsConsiderSupporting => 'pensez à soutenir';

  @override
  String get imagesTitle => 'Images';

  @override
  String get tagMoodTitle => 'Humeur';

  @override
  String get calendarTagDisplayLabel => 'Étiquette';

  @override
  String get selectTagTitle => 'Sélectionner une étiquette';

  @override
  String get labelPresentLabel => 'Présent';

  @override
  String get labelAbsentLabel => 'Absent';

  @override
  String get labelCoverageLabel => 'Couverture';

  @override
  String chartDistributionTitle(Object tag) {
    return 'Distribution de $tag';
  }

  @override
  String get shareAddToLogPickerTitle => 'Choisir un enregistrement';

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
}
