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
  String get themeColorTitle => 'Couleur du thème';

  @override
  String get themeColorHint => 'Choisissez une couleur pour cette palette.';

  @override
  String get themeColorBlue => 'Bleu ciel';

  @override
  String get themeColorGreen => 'Vert forêt';

  @override
  String get themeColorBrown => 'Café chaud';

  @override
  String get themeColorPurple => 'Lavande';

  @override
  String get themeColorRose => 'Rose poussiéreuse';

  @override
  String get themeColorAmber => 'Ambre';

  @override
  String get themeColorPreview => 'Un peu chaque jour';

  @override
  String get themeTintBackgroundTitle =>
      'Teinter les arrière-plans avec la couleur du thème';

  @override
  String get themeTintBackgroundHint =>
      'Désactivez-la pour les arrière-plans gris neutres ; les boutons conservent la couleur que vous avez choisie.';

  @override
  String get dailyReminderTitle => 'Notez votre journée !';

  @override
  String get dailyReminderDescription =>
      'N\'oubliez pas d\'enregistrer votre journée…';

  @override
  String get actionTakePhoto => 'Prendre une photo';

  @override
  String get flashbacksTitle => 'Souvenirs';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Exclure les mauvais jours';

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
  String get settingsShowFlashbacks => 'Afficher les souvenirs';

  @override
  String get settingsChangeMoodIcons => 'Modifier les icônes d\'humeur';

  @override
  String get moodIconPrompt => 'Saisir une icône';

  @override
  String get settingsHideImages => 'Masquer les images';

  @override
  String get pageCalendarTitle => 'Agenda';

  @override
  String get settingsNotificationsTitle => 'Notifications';

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
  String get manageTemplates => 'Gérer les modèles';

  @override
  String get noTemplateTitle => 'Aucun';

  @override
  String get noTemplatesDescription => 'Aucun modèle créé pour l\'instant…';

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
  String get tagNameExists => 'Il existe déjà un tag portant ce nom';

  @override
  String get categoryNameExists =>
      'Il existe déjà une catégorie portant ce nom';

  @override
  String deleteTemplateMessage(Object name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String get addTagsTitle => 'Ajouter des étiquettes';

  @override
  String get addTagsSearchHint => 'Chercher des étiquettes…';

  @override
  String get tagFavoriteName => 'Favoris';

  @override
  String get iconGroupActivities => 'Activités';

  @override
  String get iconGroupHobbies => 'Divertissement';

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
      'Si le dossier sélectionné contient déjà un fichier \'aid_diary.db\', celui-ci sera utilisé pour écraser vos enregistrements existants !';

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
  String get settingsExportToAnotherFormat => 'Exporter dans un autre format';

  @override
  String get settingsExportFormatDescription =>
      'Ne doit pas être utilisé comme sauvegarde !';

  @override
  String get settingsImportFromAnotherApp => 'Import d’une autre application';

  @override
  String get logFormatTitle => 'Choisissez le format';

  @override
  String get logFormatDescription =>
      'Le format d’un autre application peut ne pas prendre en charge toutes les fonctionnalités. Merci de signaler tout problème étant donné que les formats tiers peuvent changer avec le temps. Cela n’affectera pas les journaux existants !';

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
  String get settingsDeleteAllLogsTitle => 'Supprimer tous les enregistrements';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Voulez-vous supprimer tous vos enregistrements ?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Écrivez \'$prompt\' pour confirmer. Cette action est irréversible !';
  }

  @override
  String get settingsAppLanguageTitle => 'Ajouter une langue';

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
  String get settingsOpenSourceLicenses => 'Licences Open Source';

  @override
  String get tagMoodTitle => 'Humeur';

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
  String get adaptiveEmptyDay => 'Aucune entrée pour ce jour pour l\'instant';

  @override
  String get adaptiveNewEntry => 'Écrire une entrée';

  @override
  String get pageJournalTitle => 'Revue';

  @override
  String get coachPrompt1 =>
      'Qu\'est-ce qui vous a fait sourire aujourd\'hui ?';

  @override
  String get coachPrompt2 => 'Quelle chose avez-vous apprise aujourd’hui ?';

  @override
  String get coachPrompt3 =>
      'À qui avez-vous parlé aujourd’hui et qu’avez-vous ressenti ?';

  @override
  String get coachPrompt4 => 'De quoi es-tu reconnaissant en ce moment ?';

  @override
  String get coachPrompt5 =>
      'Qu’est-ce qui vous a demandé le plus d’énergie aujourd’hui ?';

  @override
  String get coachPrompt6 =>
      'Décrivez un petit moment dont vous souhaitez vous souvenir.';

  @override
  String get coachPrompt7 =>
      'Qu’est-ce qui ferait de demain une bonne journée ?';

  @override
  String get coachPrompt8 => 'Qu’avez-vous pensé ces derniers temps ?';

  @override
  String get coachPrompt9 => 'Qu\'as-tu fait aujourd\'hui rien que pour toi ?';

  @override
  String get coachPrompt10 =>
      'Si aujourd’hui il y avait un titre, quel serait-il ?';

  @override
  String get pageMediaTitle => 'Médias';

  @override
  String get pageAtlasTitle => 'Atlas';

  @override
  String get pageCoachTitle => 'Entraîneur';

  @override
  String get noEntrySelected => 'Aucune entrée sélectionnée.';

  @override
  String get entryShare => 'Partager';

  @override
  String get entryFavorite => 'Étoile';

  @override
  String get entryEdit => 'Modifier';

  @override
  String get entryPrevious => 'Entrée précédente';

  @override
  String get entryNext => 'Entrée suivante';

  @override
  String get journalStories => 'Histoires';

  @override
  String get journalEntries => 'Entrées';

  @override
  String get journalEmptyHint =>
      'Commencez votre journal en ajoutant une nouvelle entrée.';

  @override
  String get storyToday => 'Aujourd\'hui';

  @override
  String get storyThrowback => 'Retour en arrière';

  @override
  String get storyNoThrowback => 'Pas de retour en arrière aujourd\'hui';

  @override
  String get mediaFiles => 'Fichiers multimédias';

  @override
  String get mediaEmpty => 'Pas encore de photos.';

  @override
  String get mediaEmptyHint =>
      'Les photos jointes aux inscriptions seront affichées ici.';

  @override
  String get atlasEmpty => 'Aucune entrée avec un emplacement.';

  @override
  String get atlasEmptyHint =>
      'Les entrées avec un emplacement seront affichées ici.';

  @override
  String get atlasShowAll => 'Afficher toutes les entrées';

  @override
  String get atlasMyLocation => 'Ma position';

  @override
  String get coachAll => 'Tout';

  @override
  String get coachPrograms => 'Programmes';

  @override
  String get coachTemplates => 'Modèles';

  @override
  String get coachKindProgram => 'Programme';

  @override
  String get coachKindTemplate => 'Modèle';

  @override
  String get coachNoTemplates => 'Aucun programme ni modèle.';

  @override
  String get coachUseTemplate => 'Écrivez avec ce modèle';

  @override
  String get coachProgramEverydayTitle => 'Moments du quotidien';

  @override
  String get coachProgramEverydayDescription =>
      'Cinq questions courtes, une par jour. Chacun prend une minute ou deux et vous aide à voir ce qui a fait de cette journée la vôtre. Une manière douce de prendre l’habitude d’écrire un peu chaque jour.';

  @override
  String get coachProgramReflectTitle => 'Regarder vers l\'intérieur';

  @override
  String get coachProgramReflectDescription =>
      'Une question plus approfondie par semaine, pendant cinq semaines. Prenez votre temps avec chacun : ce que vous ressentez, ce qui vous épuise, ce pour quoi vous êtes reconnaissant.';

  @override
  String get searchFilters => 'Filtres';

  @override
  String get searchFilterTags => 'Balises';

  @override
  String get searchFilterStarred => 'Favoris';

  @override
  String get searchHint => 'Tapez pour rechercher ou choisissez un filtre.';

  @override
  String get locationTitle => 'Emplacement';

  @override
  String get locationName => 'Nom du lieu';

  @override
  String get locationRemove => 'Supprimer';

  @override
  String get locationServiceDisabled =>
      'Les services de localisation sont désactivés.';

  @override
  String get locationPermissionDenied =>
      'L\'autorisation de localisation a été refusée.';

  @override
  String get locationUnavailable =>
      'Impossible d\'obtenir l\'emplacement actuel.';

  @override
  String get calendarJumpToToday => 'Aller à aujourd\'hui';

  @override
  String get editorStartWriting => 'Commencez à écrire ou choisissez un ';

  @override
  String get editorTemplateLink => 'Modèle';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Choisissez un modèle';

  @override
  String get templateFeatured => 'Modèles en vedette';

  @override
  String get templateMine => 'Mes modèles';

  @override
  String get templateDailyName => 'Bilan quotidien';

  @override
  String get templateDailyDescription =>
      'Ce qui s’est passé, ce que vous avez ressenti et ce qui va suivre.';

  @override
  String get templateDailyText =>
      '## Que s\'est-il passé aujourd\'hui\n\n\n## Ce que j\'ai ressenti\n\n\n## Trois choses pour lesquelles je suis reconnaissant\n1. \n2. \n3. \n\n## Demain\n';

  @override
  String get templateTravelName => 'Entrée du carnet de voyage';

  @override
  String get templateTravelDescription =>
      'Lieux, moments et nourriture de la route.';

  @override
  String get templateTravelText =>
      '## Où je suis allé\n\n\n## Le moment dont je me souviens le plus\n\n\n## Ce que j\'ai mangé\n\n\n## Projets pour demain\n';

  @override
  String get templateReadingName => 'Notes de lecture';

  @override
  String get templateReadingDescription =>
      'Citations et réflexions tirées de ce que vous lisez.';

  @override
  String get templateReadingText =>
      '## Livre\n\n\n## Où je suis\n\n\n## Citations\n> \n\n## Mes pensées\n';

  @override
  String get templateWeeklyName => 'Revue hebdomadaire';

  @override
  String get templateWeeklyDescription =>
      'Faits saillants, difficultés et focus de la semaine prochaine.';

  @override
  String get templateWeeklyText =>
      '## Faits saillants\n\n\n## Qu\'est-ce qui a été difficile\n\n\n## Ce que j\'ai appris\n\n\n## Focus pour la semaine prochaine\n';

  @override
  String get entrySaveAsTemplate => 'Enregistrer comme modèle';

  @override
  String get entrySavedAsTemplate => 'Enregistré comme modèle';

  @override
  String get storyStatistics => 'Statistiques';

  @override
  String get storyMoodChart => 'Tableau d\'humeur';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return 'Entrées $entries · Jours $days';
  }

  @override
  String get storyThisYear => 'Cette année';

  @override
  String get storyLastYear => 'L\'année dernière';

  @override
  String get storyTapToOpen => 'Appuyez sur un jour pour l\'ouvrir';

  @override
  String get settingsGeneralTitle => 'Général';

  @override
  String get settingsDataTitle => 'Données et stockage';

  @override
  String get settingsStoriesTitle => 'Histoires';

  @override
  String get settingsHelpTitle => 'Aide et à propos';

  @override
  String get weatherTitle => 'Météo';

  @override
  String get weatherClear => 'Effacer';

  @override
  String get weatherPartlyCloudy => 'Partiellement nuageux';

  @override
  String get weatherCloudy => 'Nuageux';

  @override
  String get weatherFog => 'Brouillard';

  @override
  String get weatherDrizzle => 'Bruine';

  @override
  String get weatherRain => 'Pluie';

  @override
  String get weatherSnow => 'Neige';

  @override
  String get weatherStorm => 'Orage';

  @override
  String get weatherFetch => 'Obtenez la météo pour cette entrée';

  @override
  String get weatherNeedsLocation =>
      'Ajoutez d\'abord un emplacement avec des coordonnées.';

  @override
  String get weatherUnavailable =>
      'La météo n\'est pas disponible pour ce lieu et cette heure.';

  @override
  String get weatherRemove => 'Supprimer la météo';

  @override
  String get activityTitle => 'Activité';

  @override
  String get activityStill => 'Encore';

  @override
  String get activityWalking => 'Marcher';

  @override
  String get activityRunning => 'Courir';

  @override
  String get activityCycling => 'Cyclisme';

  @override
  String get activityVehicle => 'Dans un véhicule';

  @override
  String get activityFlying => 'Voler';

  @override
  String get activityExercise => 'Exercice';

  @override
  String get activityDetect => 'Détecter l\'activité en cours';

  @override
  String get activityDetectFailed => 'Impossible de détecter une activité.';

  @override
  String get activityRemove => 'Supprimer l\'activité';

  @override
  String get settingsAutoAddTitle => 'Ajouter automatiquement';

  @override
  String get settingsAutoAddLocation => 'Emplacement';

  @override
  String get settingsAutoAddWeather => 'Météo';

  @override
  String get settingsAutoAddHint =>
      'Les nouvelles entrées sont complétées lors de leur création.';

  @override
  String get settingsTemperatureUnit => 'Unité de température';

  @override
  String get settingsCelsius => 'Celsius (°C)';

  @override
  String get settingsFahrenheit => 'Fahrenheit (°F)';

  @override
  String get moodGreat => 'Super';

  @override
  String get moodGood => 'Bien';

  @override
  String get moodOkay => 'D\'accord';

  @override
  String get moodBad => 'Mauvais';

  @override
  String get moodAwful => 'Horrible';

  @override
  String get locationSearchHint => 'Rechercher un lieu';

  @override
  String get locationSearchEmpty => 'Aucun lieu trouvé';

  @override
  String get settingsWallpaper => 'Fond d\'écran';

  @override
  String get wallpaperNone => 'Aucun';

  @override
  String get wallpaperDots => 'Points';

  @override
  String get wallpaperGrid => 'Grille';

  @override
  String get wallpaperLines => 'Lignes';

  @override
  String get wallpaperPhoto => 'Photo…';

  @override
  String get settingsFontFamily => 'Police';

  @override
  String get fontSystem => 'Système';

  @override
  String get fontSerif => 'Serif';

  @override
  String get fontMono => 'Monospace';

  @override
  String get settingsFontSize => 'Taille de la police';

  @override
  String get fontSizeSmall => 'Petit';

  @override
  String get fontSizeMedium => 'Moyen';

  @override
  String get fontSizeLarge => 'Grand';

  @override
  String get fontSizeExtraLarge => 'Très grand';

  @override
  String get settingsLineSpacing => 'Espacement des lignes';

  @override
  String get lineSpacingCompact => 'Compacte';

  @override
  String get lineSpacingNormal => 'Normale';

  @override
  String get lineSpacingRelaxed => 'Détendu';

  @override
  String get moodAssociationsTitle => 'Ce qui me fait ressentir…';

  @override
  String moodAssociationsCount(int matching, int total) {
    return 'Entrées $matching sur $total';
  }

  @override
  String get videoRecord => 'Enregistrer une vidéo';

  @override
  String get videoChoose => 'Choisissez une vidéo';

  @override
  String get audioRecordTitle => 'Enregistrer une note vocale';

  @override
  String get audioChoose => 'Choisissez un fichier audio';

  @override
  String get audioStart => 'Enregistrer';

  @override
  String get audioStop => 'Arrêtez et enregistrez';

  @override
  String get audioPermissionDenied =>
      'L\'accès au microphone est désactivé. Autorisez-le dans les paramètres système.';

  @override
  String get mediaTooLarge =>
      'Cette vidéo est trop volumineuse pour être jointe.';

  @override
  String get mediaUnavailable =>
      'Cette pièce jointe n\'est pas disponible sur cet appareil.';

  @override
  String get widgetDone => 'L\'entrée d\'aujourd\'hui est écrite';

  @override
  String get widgetPending => 'Comment s\'est passée ta journée ?';

  @override
  String get widgetWrite => 'Écrire';

  @override
  String get insertChecklist => 'Liste de contrôle';

  @override
  String get insertNumberedList => 'Liste numérotée';

  @override
  String get insertTable => 'Tableau';

  @override
  String get insertDivider => 'Diviseur';

  @override
  String get insertCodeBlock => 'Bloc de code';

  @override
  String get journalSortTitle => 'Trier les entrées';

  @override
  String get journalSortUpdated => 'Dernière mise à jour';

  @override
  String get settingsTimeFormat => 'Format de l\'heure';

  @override
  String get settingsDayStart =>
      'Les nouvelles inscriptions comptent pour la veille jusqu\'au';

  @override
  String get settingsDayAskUntil => 'Puis demandez quel jour jusqu\'à';

  @override
  String get settingsDayStartMidnight => 'Désactivé';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Chaque entrée conserve le jour auquel elle appartient à côté de l\'heure à laquelle elle a été écrite, et vous pouvez modifier ce jour dans l\'éditeur à tout moment. Ces heures sélectionnent uniquement le jour des nouvelles entrées, donc les modifier ne déplace aucune entrée existante.';

  @override
  String get lateNightBadge => 'Écrit tard dans la nuit, compté pour la veille';

  @override
  String editorDayAsk(String time) {
    return 'Écrit à $time. C\'est pour quel jour ?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (hier)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (aujourd\'hui)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'Écrit $when';
  }

  @override
  String get timeFormat12 => '12 heures';

  @override
  String get timeFormat24 => '24 heures';

  @override
  String get settingsReminderDays => 'Rappelle-moi sur';

  @override
  String get locationRecent => 'Lieux récents';

  @override
  String get shareImage => 'Partager l\'image';

  @override
  String get shareSaveImage => 'Enregistrer l\'image';

  @override
  String get shareSaved => 'Image enregistrée';

  @override
  String get deletedTitle => 'Récemment supprimé';

  @override
  String get deletedNone => 'Rien de supprimé récemment';

  @override
  String deletedHint(int days) {
    return 'Les entrées supprimées restent ici pendant $days jours, puis sont effacées.';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days jours restants';
  }

  @override
  String get deletedRestore => 'Restaurer';

  @override
  String get deletedDeleteForever => 'Supprimer pour toujours';

  @override
  String get deletedDeleteForeverDescription =>
      'L\'entrée et ses pièces jointes sont effacées. Cela ne peut pas être annulé.';

  @override
  String get deletedEmpty => 'Vide';

  @override
  String get deletedEmptyDescription =>
      'Effacer toutes les entrées dans Supprimé récemment ? Cela ne peut pas être annulé.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Marche aléatoire';

  @override
  String get randomSubtitle => 'Ouvrir une entrée passée';

  @override
  String get randomNext => 'Un autre';

  @override
  String get randomAll => 'Tout';

  @override
  String get randomWithPhotos => 'Avec photos';

  @override
  String get randomGoodDays => 'Bonnes journées';

  @override
  String get randomEmpty => 'Aucune entrée parmi laquelle choisir';

  @override
  String get reviewWeekTitle => 'Cette semaine';

  @override
  String get reviewWeekSubtitle => 'Votre semaine jusqu\'à présent';

  @override
  String get reviewYearTitle => 'Cette année';

  @override
  String get reviewEmpty => 'Rien d\'écrit pour l\'instant';

  @override
  String get reviewEntries => 'Entrées';

  @override
  String get reviewDaysWritten => 'Jours écrits';

  @override
  String get reviewWords => 'Mots';

  @override
  String get reviewPhotos => 'Photos';

  @override
  String get reviewLongestRun => 'La plus longue série de jours';

  @override
  String get reviewAverageMood => 'Humeur moyenne';

  @override
  String get reviewFavorites => 'Le plus souvent';

  @override
  String get reviewByMonth => 'Par mois';

  @override
  String get reviewHighlight => 'Mettre en surbrillance';

  @override
  String get yearInPixels => 'Année en pixels';

  @override
  String get capsuleSeal => 'Sceau comme une capsule temporelle';

  @override
  String get capsuleTitle => 'Capsule temporelle';

  @override
  String capsuleOpensOn(Object date) {
    return 'Ouvre le $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Écrit le $date';
  }

  @override
  String get capsuleOpenEarly => 'Ouvert tôt';

  @override
  String get capsuleOpenEarlyDescription =>
      'La capsule s\'ouvre maintenant et reste ouverte.';

  @override
  String get capsuleOpened => 'Capsule temporelle ouverte';

  @override
  String get templateMorningName => 'Pages du matin';

  @override
  String get templateMorningDescription =>
      'Préparez la journée en trois minutes';

  @override
  String get templateMorningText =>
      '## Trois choses que je veux bien faire aujourd\'hui\n1. \n2. \n3. \n\n## Quelque chose que j\'attends avec impatience\n\n## Une note pour moi\n';

  @override
  String get templateEveningName => 'Revue du soir';

  @override
  String get templateEveningDescription =>
      'Terminez la journée avec ce qui s\'est bien passé';

  @override
  String get templateEveningText =>
      '## Trois bonnes choses aujourd\'hui\n1. \n2. \n3. \n\n## Ce que j\'ai appris\n\n## Qu\'est-ce qui pourrait aller mieux demain\n';

  @override
  String get routineMorning => 'Bonjour';

  @override
  String get routineEvening => 'Revue du soir';

  @override
  String get settingsRoutinePrompts => 'Invites du matin et du soir';

  @override
  String get settingsRoutinePromptsHint =>
      'Proposer le modèle du matin ou du soir dans les Stories';

  @override
  String get checkInTitle => 'Enregistrement rapide';

  @override
  String get checkInSubtitle => 'L\'humeur en deux clics';

  @override
  String get checkInMood => 'Comment vous sentez-vous ?';

  @override
  String get checkInActivity => 'Que fais-tu ?';

  @override
  String get checkInNote => 'Une ligne à ce sujet (facultatif)';

  @override
  String get checkInSave => 'Enregistrer';

  @override
  String editorWordCount(int words, int characters) {
    return 'Mots $words · Caractères $characters';
  }

  @override
  String get coachProgramEverydayTagline =>
      'Remarquez les petites choses de la journée.';

  @override
  String get coachProgramReflectTagline => 'Ralentissez et écoutez-vous.';

  @override
  String get coachDuration => 'Durée';

  @override
  String get coachInterval => 'Intervalle';

  @override
  String get coachDifficulty => 'Difficulté';

  @override
  String get coachIntervalDaily => 'Quotidiennement';

  @override
  String get coachIntervalWeekly => 'Hebdomadaire';

  @override
  String get coachDifficultyBeginner => 'Débutant';

  @override
  String get coachDifficultyIntermediate => 'Intermédiaire';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '$count jours',
      many: '$count jours',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count semaines',
      one: '$count semaines',
      many: '$count semaines',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'Jour $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Semaine $n';
  }

  @override
  String get coachEnroll => 'S\'inscrire';

  @override
  String get coachEndProgram => 'Fin du programme';

  @override
  String get coachAuthor => 'Auteur';

  @override
  String get coachAuthorBio => 'Invites écrites pour cette application.';

  @override
  String get coachEnrolledTip =>
      'Tout est prêt ! Vos questions apparaîtront dans les Stories.';

  @override
  String get coachGoToStories => 'Aller aux histoires';

  @override
  String get coachAnswerHint => 'Écrivez votre réponse…';

  @override
  String get storyWrapUp => 'C\'est tout pour aujourd\'hui.';

  @override
  String get storyTapToClose => 'Appuyez pour fermer';

  @override
  String get coachAnswerDone => 'Terminé';

  @override
  String get coachAnswered => 'Répondu, appuyez pour ouvrir';

  @override
  String get coachAnsweredEarlier => 'Répondu';

  @override
  String get locationLocating => 'Localisation…';

  @override
  String get locationPickPlace => 'Choisissez un endroit';

  @override
  String get locationPlacesHint => 'Adresse ou nom du lieu';

  @override
  String get locationCustom => 'Lieu personnalisé';

  @override
  String get locationCurrent => 'Emplacement actuel';

  @override
  String get locationSaved => 'Lieux enregistrés';

  @override
  String get locationSearchResults => 'Résultats de la recherche';

  @override
  String get locationNearby => 'Lieux à proximité';

  @override
  String get locationRename => 'Renommer';

  @override
  String get locationSavePlace => 'Enregistrer l\'endroit';

  @override
  String get locationUnsavePlace => 'Supprimer des lieux enregistrés';

  @override
  String get shareAs => 'Partager en tant que…';

  @override
  String get shareAsImage => 'Images';

  @override
  String get shareAsZip => 'ZIP avec le support d\'origine';

  @override
  String get shareAsPlainText => 'Texte brut';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Bienvenue à AID Diary';

  @override
  String get onboardWelcomeText =>
      'Commencez ici ou connectez cet appareil à celui que vous utilisez déjà.';

  @override
  String get onboardStart => 'Commencez à écrire';

  @override
  String get helpFaq => 'Questions fréquemment posées';

  @override
  String get helpFaq1Q => 'Où est stocké mon agenda ?';

  @override
  String get helpFaq1A =>
      'Votre journal est stocké sur cet appareil. Il atteint d\'autres appareils ou stockage uniquement lorsque vous activez la synchronisation, le partage ou l\'exportation. La synchronisation est chiffrée de bout en bout.';

  @override
  String get helpFaq2Q =>
      'Comment puis-je conserver une copie ou passer à un nouvel appareil ?';

  @override
  String get helpFaq2A =>
      'Connectez-vous à un appareil existant dans Paramètres → Données et stockage → Synchroniser et confirmez l\'autorisation sur l\'appareil sur lequel se trouve votre agenda. Les deux appareils restent utilisables. Vous pouvez également créer une sauvegarde et la restaurer sur un autre appareil.';

  @override
  String get helpFaq3Q =>
      'Puis-je importer des entrées provenant d’autres applications de journal ?';

  @override
  String get helpFaq3A =>
      'Oui : dans Paramètres → Données et stockage, importez les exportations depuis Daylio, Diarium, Diaro, DayBook, My Brain, OneShot et Pixels, ou une exportation JSON.';

  @override
  String get helpFaq4Q => 'Comment fonctionnent les programmes de coaching ?';

  @override
  String get helpFaq4A =>
      'Inscrivez-vous à un programme sur la page Coach. Chaque jour ou semaine, une nouvelle question attend dans les Stories ; votre réponse est enregistrée en tant qu\'entrée.';

  @override
  String get helpFaq5Q => 'Et si j\'oublie mon mot de passe ?';

  @override
  String get helpFaq5A =>
      'Le mot de passe ne peut pas être récupéré, alors conservez une sauvegarde de votre journal.';

  @override
  String get helpPrivacy => 'Confidentialité';

  @override
  String get helpPrivacyText =>
      'Le contenu du journal et les médias restent sur cet appareil, sauf si vous activez la synchronisation cryptée ou si vous les partagez/exportez. Les cartes, la recherche de lieux et la météo utilisent les services configurés et envoient la localisation ou la requête de recherche nécessaire à cette demande, et non le texte du journal.';

  @override
  String get photoMetaTitle => 'Utiliser les détails de la photo ?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Compter cette entrée pour $date et définir sa place sur $place, comme enregistré sur la photo ?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Compter cette entrée pour $date, quand la photo a été prise ?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Définir la place de cette entrée sur $place, où la photo a été prise ?';
  }

  @override
  String get photoMetaApply => 'Utilisez-les';

  @override
  String get quickWriteTitle => 'Écriture rapide';

  @override
  String get quickWriteText => 'Appuyez pour commencer une nouvelle entrée.';

  @override
  String get settingsQuickWriteTitle =>
      'Écriture rapide dans les notifications';

  @override
  String get settingsQuickWriteDescription =>
      'Conservez une notification qui ouvre une nouvelle entrée.';

  @override
  String get settingsNudgesTitle =>
      'Donne-moi un coup de coude après un moment tranquille';

  @override
  String settingsNudgesDescription(int days) {
    return 'Un doux rappel lorsque vous n\'avez pas écrit depuis les jours $days.';
  }

  @override
  String get nudgeTitle => 'Ça fait un moment';

  @override
  String get nudgeMonday =>
      'Une nouvelle semaine : qu’attendez-vous avec impatience ?';

  @override
  String get nudgeTuesday =>
      'Deux lignes suffisent. Comment allez-vous aujourd\'hui?';

  @override
  String get nudgeWednesday =>
      'Au milieu de la semaine. Qu’est-ce qui a marqué jusqu’à présent ?';

  @override
  String get nudgeThursday =>
      'Quelque chose de petit qui vaut la peine d’être gardé d’aujourd’hui ?';

  @override
  String get nudgeFriday => 'La semaine se termine. Notez un bon moment.';

  @override
  String get nudgeSaturday =>
      'Un samedi lent est une bonne journée pour écrire.';

  @override
  String get nudgeSunday =>
      'Retour sur la semaine avant qu\'elle ne se termine.';

  @override
  String get photoWidgetEmpty =>
      'Les photos que vous ajoutez aux entrées s\'affichent ici.';

  @override
  String get channelReminders => 'Rappels';

  @override
  String get channelOnThisDay => 'Ce jour-là';

  @override
  String get channelCoach => 'Invites de l\'entraîneur';

  @override
  String get channelNudges => 'Coups de pouce après des journées calmes';

  @override
  String get channelQuickWrite => 'Écriture rapide';

  @override
  String get channelBackup => 'Sauvegardes';

  @override
  String get formatJsonExport => 'JSON (exportation AID Diary)';

  @override
  String get aboutModifiedNotice =>
      'Une version modifiée de Daily You par Demizo et ses contributeurs. Ce n\'est pas l\'application officielle Daily You.';

  @override
  String get toolbarPhotos => 'Ajouter des photos';

  @override
  String get toolbarMedia => 'Photos et vidéos';

  @override
  String get mediaFromGallery => 'Choisissez dans la galerie';

  @override
  String get mediaFromFiles => 'Choisissez parmi les fichiers';

  @override
  String get editorLeaveTitle => 'Enregistrer cette entrée ?';

  @override
  String get editorLeaveDiscard => 'Ne sauvegardez pas';

  @override
  String get editorTitleHint => 'Titre';

  @override
  String get editorLocating => 'Localisation…';

  @override
  String get toolbarVideo => 'Vidéo';

  @override
  String get toolbarAudio => 'Note vocale';

  @override
  String get toolbarTags => 'Balises';

  @override
  String get toolbarBulletList => 'Liste à puces';

  @override
  String get toolbarHeading => 'Rubrique';

  @override
  String get toolbarBold => 'Audacieux';

  @override
  String get toolbarItalic => 'Italique';

  @override
  String get toolbarHighlight => 'Mettre en surbrillance';

  @override
  String get toolbarStrikethrough => 'Barré';

  @override
  String get toolbarQuote => 'Citation';

  @override
  String get toolbarLink => 'Lien';

  @override
  String get toolbarInsert => 'Insérer';

  @override
  String get toolbarUndo => 'Annuler';

  @override
  String get toolbarRedo => 'Refaire';

  @override
  String get toolbarInsertDate => 'Insérez la date';

  @override
  String get toolbarInsertTime => 'Insérez l\'heure';

  @override
  String get settingsSyncTitle => 'Synchronisation dans le cloud';

  @override
  String get syncOffDescription =>
      'Conservez ce journal de la même manière sur tous vos appareils via Google Drive ou un serveur WebDAV, tel que Nextcloud, Synology ou Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'Synchroniser avec Google Drive';

  @override
  String get syncOrWebDav => 'Ou un serveur WebDAV';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn =>
      'Connectez-vous. Vous pouvez revenir à AID Diary.';

  @override
  String get syncGoogleSignInAgain =>
      'Google a besoin que vous vous reconnectiez.';

  @override
  String get syncSignInAgain => 'Connectez-vous à nouveau';

  @override
  String get settingsCommandLineTitle => 'Ligne de commande';

  @override
  String get commandLineToggle => 'Interface de ligne de commande';

  @override
  String get commandLineToggleHint =>
      'Permet à la commande d\'aide et aux autres programmes de cet appareil d\'utiliser les commandes de l\'application.';

  @override
  String get commandLineAlwaysOn =>
      'Toujours actif dans les versions de développement.';

  @override
  String commandLineListening(int port) {
    return 'En écoute sur le port $port';
  }

  @override
  String get commandPaletteTitle => 'Toutes les commandes';

  @override
  String get commandPaletteSearch => 'Commandes de recherche';

  @override
  String get commandPaletteRun => 'Courir';

  @override
  String get commandPaletteConfirm =>
      'Cela ne peut pas être simplement annulé. L\'exécuter ?';

  @override
  String syncReceiving(int done, int total) {
    return 'Réception de $done de $total…';
  }

  @override
  String syncSending(int done, int total) {
    return 'Envoi de $done de $total…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'L\'accès à Google Drive n\'était pas autorisé. Reconnectez-vous et cochez Google Drive sur la page de Google.';

  @override
  String get syncEntryUnsynced =>
      'Non synchronisé : la dernière synchronisation n\'a pas eu lieu';

  @override
  String get syncUseOfficial => 'Utiliser le serveur de synchronisation AID';

  @override
  String get syncServer => 'Adresse du serveur';

  @override
  String get syncUsername => 'Nom d\'utilisateur';

  @override
  String get syncPassword => 'Mot de passe';

  @override
  String get syncConnect => 'Se connecter';

  @override
  String get syncConnecting => 'Connexion…';

  @override
  String get syncSignInFailed =>
      'Impossible de se connecter. Vérifiez l\'adresse, le nom d\'utilisateur et le mot de passe.';

  @override
  String syncConnectFailed(String error) {
    return 'Impossible de se connecter : $error';
  }

  @override
  String get syncNewSpaceTitle => 'Commencer la synchronisation';

  @override
  String get syncNewSpaceDescription =>
      'Il n\'y a pas encore de journal synchronisé ici. Ce journal sera téléchargé, crypté de bout en bout avec une clé qui restera sur vos appareils.';

  @override
  String get syncJoinTitle => 'Rejoignez le journal synchronisé';

  @override
  String get syncWrongKey =>
      'Ce code de récupération n\'ouvre pas le journal synchronisé.';

  @override
  String syncLastSynced(String time) {
    return 'Dernière synchronisation $time';
  }

  @override
  String get syncNever => 'Pas encore synchronisé';

  @override
  String get syncSyncing => 'Synchronisation…';

  @override
  String syncFailed(String error) {
    return 'La dernière synchronisation a échoué : $error';
  }

  @override
  String get syncLocked =>
      'Le journal synchronisé appartient désormais à d\'autres appareils ou a été redémarré. Associez-le à l\'un d\'eux ou utilisez le code de récupération pour continuer la synchronisation.';

  @override
  String get syncNow => 'Synchronisez maintenant';

  @override
  String get syncUnlock => 'Déverrouiller';

  @override
  String get syncEncrypted => 'Chiffré de bout en bout';

  @override
  String get syncDisconnect => 'Arrêter la synchronisation';

  @override
  String get syncDisconnectDescription =>
      'Cet appareil arrête la synchronisation. Le journal ici et la copie synchronisée restent tels quels.';

  @override
  String get syncOwnRecoveryPassword =>
      'Utiliser mon propre mot de passe de récupération';

  @override
  String get syncRecoveryPassword => 'Mot de passe de récupération';

  @override
  String get syncRecoveryPasswordRepeat =>
      'Répétez le mot de passe de récupération';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Utilisez au moins les caractères $min';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'Les mots de passe diffèrent';

  @override
  String get syncRecoveryCode => 'Code de récupération';

  @override
  String get syncRecoveryCodeTitle => 'Enregistrez votre code de récupération';

  @override
  String get syncRecoveryCodeDescription =>
      'Si chacun de vos appareils est perdu, ce code restaure votre journal synchronisé. Conservez-le dans un gestionnaire de mots de passe ou sur papier. Il n\'est affiché qu\'une seule fois.';

  @override
  String get syncRecoveryCodeCopied => 'Code de récupération copié';

  @override
  String get syncRecoveryCodeSaved => 'je l\'ai sauvegardé';

  @override
  String get syncJoinNeedsKey =>
      'Ce journal synchronisé appartient à vos autres appareils. Associez-le à l’un d’eux ou utilisez le code de récupération. Les entrées sur cet appareil y seront ajoutées.';

  @override
  String get syncPairDevice => 'Associer avec un appareil';

  @override
  String get syncUseRecoveryCode => 'Utilisez le code de récupération';

  @override
  String get syncAddDevice => 'Ajouter un appareil';

  @override
  String get syncChangeRecoveryCode => 'Changer le code de récupération';

  @override
  String get syncChangeRecoveryDescription =>
      'Un nouveau code remplace l\'actuel, qui cesse de fonctionner. Vos données et autres appareils restent tels quels.';

  @override
  String get syncNewRandomCode => 'Nouveau code aléatoire';

  @override
  String get syncRecoveryCodeChanged => 'Code de récupération modifié';

  @override
  String get syncResetSpace => 'Recommencer le journal synchronisé';

  @override
  String get syncResetSpaceDescription =>
      'Seulement lorsqu\'aucun appareil ni aucun code de récupération ne l\'ouvre plus : la copie synchronisée est remplacée par l\'agenda sur cet appareil, sous les clés de cet appareil. Vos autres appareils se couplent ensuite à nouveau.';

  @override
  String get syncPairTitle => 'Associer des appareils';

  @override
  String get syncPairShow => 'Afficher un code';

  @override
  String get syncPairEnter => 'Entrez un code';

  @override
  String get syncPairShowHint =>
      'Sur votre autre appareil, ouvrez Associer des appareils, choisissez Entrer un code, puis saisissez ou scannez-le.';

  @override
  String get syncPairEnterHint =>
      'Tapez le code affiché par votre autre appareil ou scannez-le.';

  @override
  String get syncPairCode => 'Code d\'appariement';

  @override
  String get syncPairScan => 'Numériser';

  @override
  String get syncPairStart => 'Paire';

  @override
  String get syncPairWaiting => 'En attendant l\'autre appareil…';

  @override
  String syncPairDone(String device) {
    return 'Associé à $device';
  }

  @override
  String get syncPairWrongCode =>
      'Le code ne correspondait pas. Affichez un nouveau code et réessayez.';

  @override
  String get syncPairNoOffer =>
      'Aucun appareil n\'affiche ce code. Il est peut-être expiré.';

  @override
  String get syncPairTimedOut => 'L\'autre appareil n\'a pas répondu à temps.';

  @override
  String get syncPairNeither =>
      'Aucun des deux appareils n\'est encore configuré avec ce journal synchronisé.';

  @override
  String get syncPairBoth =>
      'Les deux appareils ouvrent déjà ce journal synchronisé.';

  @override
  String syncPairFailed(String error) {
    return 'Échec du couplage : $error';
  }

  @override
  String get syncMediaPending =>
      'Journal synchronisé · certains médias sont toujours en cours de transfert';

  @override
  String get syncWaitingForDevices =>
      'Journal synchronisé · en attente d\'un autre appareil pour transférer des médias';

  @override
  String get syncCacheNotice =>
      'Le média cloud est temporaire. Conservez les originaux sur vos appareils ; la synchronisation n\'est pas une sauvegarde.';

  @override
  String get paperTitle => 'Papier à lettres';

  @override
  String get paperPlain => 'Plaine';

  @override
  String get paperLined => 'Doublé';

  @override
  String get paperGrid => 'Grille';

  @override
  String get paperTinted => 'Teinté';

  @override
  String get paperDecorationTitle => 'Décorations';

  @override
  String get paperDecorationNone => 'Aucun';

  @override
  String get paperDecorationBotanical => 'Feuilles';

  @override
  String get paperDecorationStars => 'Étoiles';

  @override
  String get paperDecorationWashi => 'Ruban adhésif Washi';

  @override
  String get themeDarkChoice => 'Aspect sombre';

  @override
  String get themeDarkSame => 'Suivre la palette de lumière';

  @override
  String get themeDarkCustom => 'Palette séparée';

  @override
  String get themeDarkAccent => 'Couleur d\'accent sombre';

  @override
  String get themeColorTeal => 'Sarcelle';

  @override
  String get themeColorCyan => 'Cyan';

  @override
  String get themeColorIndigo => 'Indigo';

  @override
  String get themeColorCoral => 'Corail';

  @override
  String get themeColorOlive => 'Olivier';

  @override
  String get themeColorSlate => 'Ardoise';

  @override
  String get drawingTitle => 'Dessin';

  @override
  String get drawingPen => 'Stylo';

  @override
  String get drawingEraser => 'Gomme';

  @override
  String get drawingUndo => 'Annuler';

  @override
  String get drawingClear => 'Effacer';

  @override
  String get drawingWidth => 'Largeur du stylo';

  @override
  String get drawingStylusOnly => 'Stylet uniquement';

  @override
  String get drawingDiscardTitle => 'Supprimer le dessin ?';

  @override
  String get drawingDiscardBody => 'Ce dessin n\'a pas été enregistré.';

  @override
  String get drawingSaveError => 'Impossible d\'enregistrer le dessin.';

  @override
  String get syncNetworkTitle => 'Diagnostic réseau';

  @override
  String get syncNetworkRefresh => 'Actualiser';

  @override
  String get syncNetworkSelectedRoute => 'Chemin actuel';

  @override
  String get syncNetworkAvailableRoutes => 'Chemins disponibles';

  @override
  String get syncNetworkSignaling => 'Connexion au répertoire des appareils';

  @override
  String get syncNetworkRelayRemaining => 'Indemnité de relais restante';

  @override
  String get syncNetworkIcePair => 'Candidats à connexion directe';

  @override
  String get syncNetworkPeerTrusted => 'Appareil authentifié';

  @override
  String get syncNetworkNoRoute => 'En attente d\'une connexion';

  @override
  String get syncNetworkUnavailable =>
      'Les diagnostics ne sont pas disponibles';

  @override
  String get syncMediaCopiesTitle => 'Livraison et copies des médias';

  @override
  String get syncMediaPendingCount => 'En attente de transfert';

  @override
  String get syncMediaDurableCount => 'Livré au stockage personnel';

  @override
  String get syncMediaTemporaryCount => 'Copies temporaires ou non confirmées';

  @override
  String get syncMediaReceiptExplanation =>
      'Ces décomptes décrivent les livraisons terminées, et non un nouvel audit des sauvegardes survivantes.';

  @override
  String get syncMediaCacheExplanation =>
      'Les médias cloud temporaires peuvent expirer. Conservez vos originaux ou une sauvegarde séparée.';

  @override
  String get momentsTitle => 'Moments photo';

  @override
  String get momentsHint =>
      'Trouvez des groupes en utilisant les heures de photo locales et les coordonnées facultatives. Les photos sont jointes uniquement lorsque vous choisissez une carte.';

  @override
  String get momentsScan => 'Trouver des moments';

  @override
  String get momentsChooseFolder => 'Choisir le dossier photo';

  @override
  String get momentsLocation => 'Inclure les emplacements des photos';

  @override
  String get momentsEmpty => 'Aucun groupe de photos récentes.';

  @override
  String get momentsCreate => 'Écrivez à propos de ces photos';

  @override
  String get momentsDismiss => 'Rejeter';

  @override
  String get momentsError => 'Impossible de lire les photos locales.';

  @override
  String get momentsCreated => 'Entrée photo créée.';

  @override
  String get momentsPermission =>
      'Autorisez l’accès aux photos pour trouver des suggestions locales.';

  @override
  String get momentsScope =>
      'Photos récentes uniquement ; au maximum 500 photos et 20 photos par carte.';

  @override
  String momentsPhotoCount(int count) {
    return 'Photos de $count';
  }

  @override
  String get nearbyTitle => 'Connecter des appareils';

  @override
  String get nearbySend => 'Autoriser un autre appareil';

  @override
  String get nearbyReceive => 'Connectez-vous à un appareil existant';

  @override
  String get nearbyInstructions =>
      'Connectez les deux appareils au même Wi-Fi ou au point d\'accès de l\'autre. Confirmer l\'autorisation sur l\'appareil existant ; les deux appareils restent utilisables. Aucune connexion Internet n\'est requise.';

  @override
  String get nearbyCompare =>
      'Comparez ce code sur les deux appareils avant d\'approuver.';

  @override
  String get nearbyConfirm => 'Les codes correspondent';

  @override
  String get nearbyScan => 'Scannez le code de l’autre appareil';

  @override
  String get nearbyPaste => 'Coller l\'invitation';

  @override
  String get nearbyWaiting => 'En attente d\'approbation sur l\'autre appareil';

  @override
  String get nearbyWorking =>
      'Autoriser et synchroniser votre agenda et vos pièces jointes…';

  @override
  String get nearbyPending =>
      'Certaines pièces jointes doivent encore être synchronisées. Gardez l\'autre appareil en ligne et réessayez.';

  @override
  String get nearbyComplete =>
      'Appareil connecté ; agenda et pièces jointes synchronisés';

  @override
  String get nearbyFailed =>
      'La connexion n\'a pas abouti. Vérifiez la connexion locale et réessayez.';

  @override
  String get nearbyEmptyRequired =>
      'Utilisez un appareil avec un agenda vide qui n\'est pas encore connecté pour la synchronisation.';

  @override
  String get nearbyRetry => 'Continuer la synchronisation';

  @override
  String get nearbyWifi => 'Paramètres Wi-Fi';

  @override
  String get nearbyHotspot => 'Paramètres du point d\'accès';

  @override
  String get nearbyKeepOpen =>
      'Gardez cette page ouverte jusqu\'à ce que le nouvel appareil soit terminé. L\'invitation expire après deux minutes.';

  @override
  String get syncDevicesTitle => 'Appareils autorisés';

  @override
  String get syncDevicesDescription =>
      'Seuls les appareils approuvés peuvent accéder à ce compte AID. La révocation d\'un appareil bloque le serveur mais ne peut pas effacer une clé principale ou un journal déjà copié sur celui-ci.';

  @override
  String get syncDeviceRequest =>
      'Afficher ce QR d\'autorisation à un appareil approuvé';

  @override
  String get syncDeviceAuthorize => 'Autoriser un appareil';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Scannez ou collez la demande d’autorisation du nouvel appareil.';

  @override
  String get syncDeviceRevoke => 'Révoquer';

  @override
  String get syncDeviceRotate =>
      'Faites pivoter la clé de signature de cet appareil';

  @override
  String get syncDeviceCheck => 'Vérifier l\'autorisation';

  @override
  String get syncDeviceHardware => 'Clé de signature matérielle';

  @override
  String get syncDeviceSoftware => 'Clé de signature logicielle non exportable';

  @override
  String get syncDeviceUnavailable =>
      'L\'autorisation de l\'appareil n\'est pas disponible. Approuvez cet appareil à partir d’un autre appareil autorisé et réessayez.';

  @override
  String get syncDeviceRevoked => 'Révoqué';

  @override
  String get syncDeviceLocal => 'Cet appareil';

  @override
  String get cloudTrafficTitle =>
      'Quota mensuel de transfert de données cloud pour les fichiers multimédias';

  @override
  String get cloudTrafficLimit => 'Quota mensuel de transfert de données';

  @override
  String get cloudTrafficUsed => 'Transfert de données utilisé';

  @override
  String get cloudTrafficRemaining => 'Transfert de données restant';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'Le quota de transfert de données réinitialise $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'Le quota de transfert de données cloud pour les fichiers multimédias a été épuisé. Les fichiers multimédias manquants seront automatiquement synchronisés lorsqu\'une connexion directe est disponible ou que le quota est réinitialisé.';

  @override
  String get cloudTrafficExplanation =>
      'La mise en cache des fichiers multimédias et le relais en direct partagent ce quota de transfert de données. Les connexions directes ne le consomment pas. Les textes du journal et les messages de contrôle de connexion ont de petites limites quotidiennes distinctes.';

  @override
  String get appearanceThemeSection => 'Thème de l\'application';

  @override
  String get appearancePaperSection => 'Papier journal';

  @override
  String get appearanceTypographySection => 'Texte du journal';

  @override
  String get appearancePreferencesSection => 'Préférences générales';

  @override
  String get themeSystemAccentHint =>
      'Utilise la palette système au lieu de couleurs personnalisées. Désactivez-le pour choisir le vôtre.';

  @override
  String get syncDeviceNameSaveFailed =>
      'Impossible d\'enregistrer le nom de l\'appareil. Veuillez réessayer.';

  @override
  String get nearbyConnectionHelp => 'Aide à la connexion';

  @override
  String get syncAllSynced => 'Tout est synchronisé';

  @override
  String get syncDetailsTitle => 'Détails de synchronisation';

  @override
  String get syncMore => 'Plus d\'options';

  @override
  String get syncDeviceName => 'Nom de l\'appareil';

  @override
  String get syncDeviceNameHint => 'Par exemple : Ma tablette';

  @override
  String get syncDeviceNameInvalid => 'Utilisez 1 à 32 caractères';

  @override
  String get syncDeviceKeyDetails => 'Détails de sécurité';

  @override
  String get syncConnectionProblem =>
      'Impossible de synchroniser pour l\'instant. Réessayer automatiquement.';

  @override
  String get syncCopyComplete =>
      'Copie complète de votre agenda et de vos fichiers multimédias';

  @override
  String get syncCopyPartial => 'Certains médias manquent toujours';

  @override
  String get syncCopyOlder =>
      'De nouveaux changements sont en attente de synchronisation';

  @override
  String get syncCopyUnavailable =>
      'Les détails de la copie ne sont pas disponibles. Réessayez plus tard.';

  @override
  String get syncCopyLastKnown =>
      'D\'autres appareils affichent leur dernière copie confirmée. Les appareils hors ligne ne peuvent pas être vérifiés pour le moment.';

  @override
  String get syncCopyTemporary =>
      'Cache temporaire. Conservez les originaux sur vos appareils.';

  @override
  String get syncCopyStorage =>
      'Votre stockage de synchronisation. Les téléchargements multimédias terminés sont répertoriés dans les diagnostics.';

  @override
  String syncCopyChecked(String time) {
    return 'Dernier $time confirmé';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Transfert de données restant ce mois-ci : $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Commencez ici';

  @override
  String get onboardConnect => 'Connectez-vous à un appareil existant';

  @override
  String get onboardFailed =>
      'La configuration n\'a pas pu être terminée. Votre journal est en sécurité ; veuillez réessayer.';

  @override
  String get tutorialTitle => 'Comment utiliser le journal';

  @override
  String get tutorialWriteTitle => 'Écrivez votre première entrée de journal';

  @override
  String get tutorialWriteText =>
      'Appuyez sur + pour écrire une entrée de journal. Ajoutez un titre facultatif, choisissez la date du journal et appuyez sur la coche pour enregistrer. Vous pouvez à tout moment modifier à nouveau votre entrée de journal.';

  @override
  String get tutorialMediaTitle =>
      'Ajouter des photos, du son ou de l\'écriture manuscrite';

  @override
  String get tutorialMediaText =>
      'Utilisez + dans l\'éditeur de journal pour joindre des photos, des vidéos ou un enregistrement vocal, ou pour ouvrir le canevas d\'écriture manuscrite. Ces pièces jointes sont enregistrées avec l\'entrée du journal.';

  @override
  String get tutorialReviewTitle => 'Retrouver un jour';

  @override
  String get tutorialReviewText =>
      'Parcourez votre agenda ou votre calendrier, recherchez vos écrits et organisez les entrées avec des balises. Les pages Médias et Atlas vous permettent de retrouver les entrées passées par photo ou par lieu.';

  @override
  String get tutorialSyncTitle => 'Utiliser plusieurs appareils';

  @override
  String get tutorialSyncText =>
      'Dans Paramètres → Données et stockage → Synchronisation, connectez-vous à un appareil existant et confirmez l’autorisation sur cet appareil. Les deux appareils restent utilisables. Le texte du journal est synchronisé en premier ; les pièces jointes suivent selon la connexion et le quota de transfert restant.';

  @override
  String get tutorialPrivacyTitle => 'Gardez votre agenda en sécurité';

  @override
  String get tutorialPrivacyText =>
      'Les entrées du journal restent sur cet appareil, sauf si vous activez la synchronisation, les partagez ou les exportez. La synchronisation est chiffrée de bout en bout. Dans Paramètres, vous pouvez également définir un mot de passe pour l\'application, créer des sauvegardes et rouvrir ce didacticiel.';

  @override
  String get editorDiaryDay => 'Jour du journal';

  @override
  String get editorDiaryDayPicker =>
      'Jour du journal · À quel jour appartient cette entrée ?';

  @override
  String editorCreatedAt(String time) {
    return 'Créée $time';
  }

  @override
  String get editorDiaryDayHint =>
      'Le jour auquel cette entrée appartient. Le modifier ne change ni sa date ni son heure de création.';

  @override
  String get hiddenDiaryTitle => 'Entrées masquées';

  @override
  String get hiddenDiaryHide => 'Masquer l’entrée';

  @override
  String get hiddenDiaryShow => 'Afficher l’entrée';

  @override
  String get hiddenDiaryEmpty => 'Aucune entrée masquée';

  @override
  String get hiddenDiaryUnlock => 'Déverrouiller les entrées masquées';

  @override
  String get hiddenDiaryAuthHint =>
      'Utilisez le verrouillage de l’application ou de l’écran de votre appareil.';

  @override
  String hiddenDiaryWhere(String path) {
    return 'Masquée. Pour l’afficher à nouveau : $path';
  }

  @override
  String get moodClear => 'Effacer l’humeur';

  @override
  String get scrollToTop => 'Retour en haut';

  @override
  String get feedbackTitle => 'Commentaires';

  @override
  String get feedbackHint => 'Décrivez un problème ou une suggestion';

  @override
  String get feedbackGithub => 'Ticket GitHub';

  @override
  String get feedbackEmail => 'Envoyer un e-mail';

  @override
  String get feedbackCopy => 'Copier le texte';

  @override
  String get feedbackLaunchFailed =>
      'Impossible d’ouvrir l’application. Copiez le texte et utilisez l’adresse ci-dessous.';

  @override
  String get feedbackCopied => 'Commentaires copiés';
}
