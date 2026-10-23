// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => 'テーマカラー';

  @override
  String get themeColorHint => 'このパレットの色を選択します。';

  @override
  String get themeColorBlue => 'スカイブルー';

  @override
  String get themeColorGreen => 'フォレストグリーン';

  @override
  String get themeColorBrown => '温かいコーヒー';

  @override
  String get themeColorPurple => 'ラベンダー';

  @override
  String get themeColorRose => 'ダスティローズ';

  @override
  String get themeColorAmber => 'アンバー';

  @override
  String get themeColorPreview => '毎日少しずつ';

  @override
  String get themeTintBackgroundTitle => 'テーマカラーで背景を着色する';

  @override
  String get themeTintBackgroundHint =>
      'ニュートラルグレーの背景の場合はオフにします。ボタンは選択した色を保持します。';

  @override
  String get dailyReminderTitle => '今日の日記を書きましょう！';

  @override
  String get dailyReminderDescription => '今日の日記を残しましょう…';

  @override
  String get actionTakePhoto => '写真を撮る';

  @override
  String get flashbacksTitle => '回想';

  @override
  String get settingsFlashbacksExcludeBadDays => '気分が沈んだ日を除外';

  @override
  String get flashbackGoodDay => 'よい一日';

  @override
  String get flashbackRandomDay => 'ある一日';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 週間前',
      one: '$count 週間前',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count か月前',
      one: '$count か月前',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 年前',
      one: '$count 年前',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'この日には';

  @override
  String get searchLogsHint => '記録を検索…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件の記録',
      one: '$count件の記録',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count日',
      one: '$count 日',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count文字',
      one: '$count文字',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'まだ記録はありません…';

  @override
  String get noResults => '結果はありません…';

  @override
  String get sortOrderAscendingTitle => '昇順';

  @override
  String get sortOrderDescendingTitle => '降順';

  @override
  String get pageStatisticsTitle => '統計';

  @override
  String get statisticsNotEnoughData => 'データが足りません…';

  @override
  String get statisticsRangeOneMonth => '一か月';

  @override
  String get statisticsRangeSixMonths => '六か月';

  @override
  String get statisticsRangeOneYear => '一年';

  @override
  String get statisticsRangeAllTime => 'すべての期間';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag 要約';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag 日毎';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag 時間の経過とともに';
  }

  @override
  String get chartGroupingLabel => 'グループ化';

  @override
  String get chartGroupingDay => '日';

  @override
  String get chartGroupingWeek => '週';

  @override
  String get chartGroupingMonth => '月';

  @override
  String get chartGroupingYear => '年';

  @override
  String get chartSmoothingLabel => 'スムージング';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '現在の連続記録：$count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '最長の連続記録：$count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '素晴らしい日々 $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '悪い日からの日数 $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle => '外部ストレージにアクセスできません';

  @override
  String get errorExternalStorageAccessDescription =>
      'もしネットワークストレージを使用している場合は、サービスがオンラインであり、ネットワークに接続されていることを確認してください。\n\nそうでない場合、アプリは外部フォルダへのアクセス権を失っている可能性があります。設定に移動し、外部フォルダを再選択してアクセスを許可してください。\n\n注意：外部ストレージへのアクセスを復元するまで、変更内容は同期されません！';

  @override
  String get errorExternalStorageAccessContinue => 'ローカルデータベースを使用して続行';

  @override
  String get lastModified => '最終更新';

  @override
  String get writeSomethingHint => '何か書きましょう…';

  @override
  String get titleHint => 'タイトル…';

  @override
  String get deleteLogTitle => '記録を削除';

  @override
  String get deleteLogDescription => 'この記録を削除してもよろしいですか？';

  @override
  String get deletePhotoTitle => '写真を削除';

  @override
  String get deletePhotoDescription => 'この写真を削除してもよろしいですか？';

  @override
  String get pageSettingsTitle => '設定';

  @override
  String get settingsTheme => 'テーマ';

  @override
  String get themeSystem => 'システムに従う';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get themeAmoled => 'ダーク(AMOLED)';

  @override
  String get settingsFirstDayOfWeek => '週の始まり';

  @override
  String get settingsCalendarSystem => 'カレンダーシステム';

  @override
  String get calendarSystemGregorian => 'グレゴリオ暦';

  @override
  String get calendarSystemJalali => 'ジャラリ';

  @override
  String get settingsUseSystemAccentColor => 'システムのユーザーの色を利用';

  @override
  String get settingsCustomAccentColor => '強調色をカスタマイズ';

  @override
  String get settingsShowFlashbacks => '回想を表示';

  @override
  String get settingsChangeMoodIcons => '気分のアイコンを変更する';

  @override
  String get moodIconPrompt => 'アイコンを入力してください';

  @override
  String get settingsHideImages => '画像を非表示にする';

  @override
  String get pageCalendarTitle => 'カレンダー';

  @override
  String get settingsNotificationsTitle => '通知';

  @override
  String get settingsDailyReminderTitle => 'リマインダー';

  @override
  String get settingsOnThisDayDescription => '過去の思い出を振り返る';

  @override
  String get settingsDailyReminderDescription => '毎日、便利なリマインダーを送信';

  @override
  String get settingsReminderTime => 'リマインダーの送信時間';

  @override
  String get settingsFixedReminderTimeTitle => '固定リマインダー時間';

  @override
  String get settingsFixedReminderTimeDescription => 'リマインダーの送信時間を固定する';

  @override
  String get settingsAlwaysSendReminderTitle => '常にリマインダーを送信する';

  @override
  String get settingsAlwaysSendReminderDescription =>
      '記入が開始されている場合でもリマインダーを送信する';

  @override
  String get settingsCustomizeNotificationTitle => '通知をカスタマイズ';

  @override
  String get settingsTemplatesTitle => 'テンプレート';

  @override
  String get manageTemplates => 'テンプレートを管理する';

  @override
  String get noTemplateTitle => 'なし';

  @override
  String get noTemplatesDescription => 'テンプレートはまだ作成されていません…';

  @override
  String get templateDefaultTimestampTitle => 'タイムスタンプ';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => '一日の概要';

  @override
  String get templateDefaultSummaryBody => '### 概要\n- \n\n### 引用\n> ';

  @override
  String get templateDefaultReflectionTitle => '反射';

  @override
  String get templateDefaultReflectionBody =>
      '### 今日は何が楽しかったですか?\n- \n\n### 何に感謝していますか?\n- \n\n### 何を楽しみにしていますか?\n- ';

  @override
  String get settingsTagsTitle => 'タグ';

  @override
  String get manageTags => 'タグの管理';

  @override
  String get tagTypeLabelTitle => 'ラベル';

  @override
  String get tagTypeTrackerTitle => 'トラッカー';

  @override
  String get nameHint => '名前';

  @override
  String get tagColorLabel => '色';

  @override
  String get iconPickerTitle => 'アイコンを選択';

  @override
  String get iconPickerIconsTab => 'アイコン';

  @override
  String get iconPickerCustomTab => 'カスタム';

  @override
  String get iconPickerSearchHint => '検索アイコン…';

  @override
  String get colorPickerTitle => '色の選択';

  @override
  String get colorPickerPaletteTab => '色';

  @override
  String get iconGroupMoodPeople => '気分と人々';

  @override
  String get iconGroupHealth => '健康';

  @override
  String get iconGroupWorkFinance => '仕事と財務';

  @override
  String get iconGroupHabitsGoals => '習慣と目標';

  @override
  String get iconGroupNature => '自然';

  @override
  String get iconGroupFoodDrink => '食べ物と飲み物';

  @override
  String get iconGroupHome => 'ホーム';

  @override
  String get iconGroupTravel => '旅行';

  @override
  String get iconGroupSymbols => '記号';

  @override
  String get tagCategoryLabel => 'カテゴリ';

  @override
  String get tagLabel => 'タグ';

  @override
  String get tagCategoryUncategorized => '未分類';

  @override
  String get newCategoryTitle => '新しいカテゴリー';

  @override
  String get shareButtonLabel => 'シェアする';

  @override
  String get importErrorDescription => 'ファイルのインポートに失敗しました!';

  @override
  String get exportErrorDescription => 'ファイルのエクスポートに失敗しました!';

  @override
  String get deleteTitle => '削除';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' $count件の日記で使用されています。',
      one: ' 1ログで使用されます。',
      zero: '',
    );
    return '「$name」を削除しますか?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' $count 個のタグも削除されます。',
      one: ' その 1 つのタグも削除されます。',
      zero: '',
    );
    return '「$name」を削除しますか?$_temp0';
  }

  @override
  String get tagNameExists => 'この名前のタグはすでに存在します';

  @override
  String get categoryNameExists => 'この名前のカテゴリがすでに存在します';

  @override
  String deleteTemplateMessage(Object name) {
    return '「$name」を削除しますか?';
  }

  @override
  String get addTagsTitle => 'タグを追加する';

  @override
  String get addTagsSearchHint => 'タグを検索…';

  @override
  String get tagPickerSortManualLabel => '手動注文';

  @override
  String get tagPickerSortUsageLabel => '用途別に並べ替える';

  @override
  String get tagFavoriteName => 'お気に入り';

  @override
  String get tagEnergyName => 'エネルギー';

  @override
  String get tagCategoryActivitiesName => '活動内容';

  @override
  String get tagExerciseName => '運動';

  @override
  String get tagSocializingName => '社交';

  @override
  String get tagHobbyName => '趣味';

  @override
  String get tagEntertainmentName => 'エンターテイメント';

  @override
  String get tagDiningName => 'ダイニング';

  @override
  String get tagChoresName => '雑用';

  @override
  String get tagCategoryEmotionsName => '感情';

  @override
  String get tagExcitedName => '興奮した';

  @override
  String get tagGratefulName => '感謝します';

  @override
  String get tagCalmName => '穏やかな';

  @override
  String get tagTiredName => '疲れた';

  @override
  String get tagAnxiousName => '不安';

  @override
  String get tagAnnoyedName => 'イライラする';

  @override
  String get settingsStorageTitle => 'ストレージ';

  @override
  String get settingsImageQuality => '画質';

  @override
  String get imageQualityHigh => '高';

  @override
  String get imageQualityMedium => '中';

  @override
  String get imageQualityLow => '低';

  @override
  String get imageQualityNoCompression => '圧縮なし';

  @override
  String get settingsLogFolder => '記録フォルダ';

  @override
  String get settingsImageFolder => '画像フォルダ';

  @override
  String get warningTitle => '警告';

  @override
  String get logFolderWarningDescription =>
      '選択したフォルダーに既に \'aid_diary.db\' ファイルが含まれている場合は、既存のログを上書きするために使用されます！';

  @override
  String get errorTitle => 'エラー';

  @override
  String get logFolderErrorDescription => '日記フォルダの変更に失敗しました！';

  @override
  String get imageFolderErrorDescription => '画像フォルダの変更に失敗しました！';

  @override
  String get backupErrorDescription => 'バックアップの作成に失敗しました！';

  @override
  String get restoreErrorDescription => 'バックアップの復元に失敗しました！';

  @override
  String get settingsBackupRestoreTitle => 'バックアップと復元';

  @override
  String get settingsBackup => 'バックアップ';

  @override
  String get settingsRestore => '復元';

  @override
  String get settingsRestorePromptDescription => 'これにより現在の設定が上書きされます！';

  @override
  String get settingsBackupPasswordProtect => 'パスワード保護されたバックアップ';

  @override
  String get backupEncryptedTitle => '暗号化されたバックアップ';

  @override
  String get backupEncryptedContent => 'このバックアップはパスワードで保護されています。';

  @override
  String get settingsAutoBackup => '自動バックアップ';

  @override
  String get settingsAutoBackupLocation => 'バックアップの場所';

  @override
  String get settingsAutoBackupInterval => 'バックアップ間隔';

  @override
  String get settingsAutoBackupIntervalDaily => '毎日';

  @override
  String get settingsAutoBackupIntervalWeekly => '毎週';

  @override
  String get settingsAutoBackupIntervalMonthly => '毎月';

  @override
  String get settingsAutoBackupMaxCount => '保存すべきバックアップ';

  @override
  String get settingsAutoBackupRequireCharging => '充電中のみ';

  @override
  String settingsBackupLast(Object time) {
    return '最終バックアップ $time';
  }

  @override
  String get settingsBackupNever => 'バックアップしたことがない';

  @override
  String settingsAutoBackupNext(Object time) {
    return '次のバックアップ $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'すべて';

  @override
  String get autoBackupFailedTitle => 'バックアップに失敗しました';

  @override
  String tranferStatus(Object percent) {
    return '転送中...$percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'バックアップを作成中... $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'バックアップを復元中... $percent%';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return 'バックアップを暗号化しています… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'バックアップを復号中… $percent%';
  }

  @override
  String get cleanUpStatus => 'クリーンアップ中…';

  @override
  String get settingsExportToAnotherFormat => 'その他の形式にエクスポート';

  @override
  String get settingsExportFormatDescription => 'これらの形式はバックアップとして利用できません！';

  @override
  String get settingsImportFromAnotherApp => 'バックアップのインポート';

  @override
  String get logFormatTitle => '形式の選択';

  @override
  String get logFormatDescription =>
      '外部アプリの形式では、すべての機能が利用可能とは限りません。サードパーティの形式は随時変更される可能性があるため、問題が発生した場合はご報告ください。既存のログには影響しません！';

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
  String get formatOneShot => 'ワンショット';

  @override
  String get formatPixels => 'Pixels';

  @override
  String get formatMarkdown => 'Markdown';

  @override
  String get settingsDeleteAllLogsTitle => 'すべてのログを消去';

  @override
  String get settingsDeleteAllLogsDescription => '本当にすべてのログを消去しますか？';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return '確認のため \'$prompt\' と入力してください。この変更は元に戻せません！';
  }

  @override
  String get settingsAppLanguageTitle => 'アプリの言語';

  @override
  String get settingsSecurityTitle => 'セキュリティ';

  @override
  String get settingsSecurityRequirePassword => 'パスワードを使用する';

  @override
  String get settingsSecurityEnterPassword => 'パスワードを入力してください';

  @override
  String get settingsSecuritySetPassword => 'パスワードを設定する';

  @override
  String get settingsSecurityChangePassword => 'パスワードを変更する';

  @override
  String get settingsSecurityPassword => 'パスワード';

  @override
  String get settingsSecurityConfirmPassword => 'パスワードを確認する';

  @override
  String get settingsSecurityOldPassword => '現在のパスワード';

  @override
  String get settingsSecurityIncorrectPassword => 'パスワードが正しくありません';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'パスワードが一致しません';

  @override
  String get requiredPrompt => '必要';

  @override
  String get settingsSecurityBiometricUnlock => '生体認証';

  @override
  String get unlockAppPrompt => 'ロック解除';

  @override
  String get settingsAboutTitle => 'このアプリについて';

  @override
  String get settingsVersion => 'バージョン';

  @override
  String get settingsLicense => 'ライセンス';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsOpenSourceLicenses => 'オープンソースライセンス';

  @override
  String get tagMoodTitle => '気分';

  @override
  String get selectTagTitle => 'タグの選択';

  @override
  String get labelPresentLabel => 'プレゼント';

  @override
  String get labelAbsentLabel => '欠席';

  @override
  String get labelCoverageLabel => '適用範囲';

  @override
  String chartDistributionTitle(Object tag) {
    return '$tag分布';
  }

  @override
  String get shareAddToLogPickerTitle => '日記エントリを選択してください';

  @override
  String get adaptiveEmptyDay => 'この日のエントリーはまだありません';

  @override
  String get adaptiveNewEntry => 'エントリーを書く';

  @override
  String get pageJournalTitle => '日記';

  @override
  String get coachPrompt1 => '今日は何があなたを笑顔にさせましたか？';

  @override
  String get coachPrompt2 => '今日学んだことは何ですか?';

  @override
  String get coachPrompt3 => '今日は誰と話しましたか?そしてそれはどう感じましたか?';

  @override
  String get coachPrompt4 => '今、感謝していることは何ですか？';

  @override
  String get coachPrompt5 => '今日あなたのエネルギーを最も費やしたものは何ですか?';

  @override
  String get coachPrompt6 => '覚えておきたい小さな瞬間を説明してください。';

  @override
  String get coachPrompt7 => '明日を良い日にしてくれるものは何でしょうか？';

  @override
  String get coachPrompt8 => '最近気になっていることは何ですか?';

  @override
  String get coachPrompt9 => '今日は自分のためだけに何をしましたか？';

  @override
  String get coachPrompt10 => '今日にタイトルがあるとしたら何になりますか?';

  @override
  String get pageMediaTitle => 'メディア';

  @override
  String get pageAtlasTitle => 'アトラス';

  @override
  String get pageCoachTitle => 'コーチ';

  @override
  String get noEntrySelected => 'エントリが選択されていません。';

  @override
  String get entryShare => 'シェアする';

  @override
  String get entryFavorite => 'スター';

  @override
  String get entryEdit => '編集';

  @override
  String get entryPrevious => '前のエントリ';

  @override
  String get entryNext => '次のエントリ';

  @override
  String get journalStories => 'ストーリー';

  @override
  String get journalEntries => 'エントリー';

  @override
  String get journalEmptyHint => '新しいエントリを追加して日記を始めます。';

  @override
  String get storyToday => '今日';

  @override
  String get storyThrowback => '振り返り';

  @override
  String get storyNoThrowback => '今日は振り返りはありません';

  @override
  String get mediaFiles => 'メディアファイル';

  @override
  String get mediaEmpty => '写真はまだありません。';

  @override
  String get mediaEmptyHint => 'エントリーに添付された写真がここに表示されます。';

  @override
  String get atlasEmpty => '場所を含むエントリはありません。';

  @override
  String get atlasEmptyHint => '場所を含むエントリがここに表示されます。';

  @override
  String get atlasShowAll => 'すべてのエントリを表示';

  @override
  String get atlasMyLocation => '私の場所';

  @override
  String get coachAll => 'すべて';

  @override
  String get coachPrograms => 'プログラム';

  @override
  String get coachTemplates => 'テンプレート';

  @override
  String get coachKindProgram => 'プログラム';

  @override
  String get coachKindTemplate => 'テンプレート';

  @override
  String get coachNoTemplates => 'プログラムやテンプレートはありません。';

  @override
  String get coachUseTemplate => 'このテンプレートを使って書く';

  @override
  String get coachProgramEverydayTitle => '日常の瞬間';

  @override
  String get coachProgramEverydayDescription =>
      '5 つの短い質問を 1 日 1 つずつ。それぞれ 1 ～ 2 分で、その日が自分のものになったことがわかります。毎日少しずつ書く習慣を身につける優しい方法。';

  @override
  String get coachProgramReflectTitle => '内側に目を向ける';

  @override
  String get coachProgramReflectDescription =>
      '週に 1 つ、より深い質問を 5 週間続けます。どのように感じているか、何に疲れているか、何に感謝しているか、それぞれに時間をかけて考えてみましょう。';

  @override
  String get searchFilters => 'フィルター';

  @override
  String get searchFilterTags => 'タグ';

  @override
  String get searchFilterStarred => 'スター付き';

  @override
  String get searchHint => '入力して検索するか、フィルターを選択します。';

  @override
  String get locationTitle => '場所';

  @override
  String get locationName => '地名';

  @override
  String get locationRemove => '削除';

  @override
  String get locationServiceDisabled => '位置情報サービスはオフになっています。';

  @override
  String get locationPermissionDenied => '位置情報の許可が拒否されました。';

  @override
  String get locationUnavailable => '現在位置を取得できませんでした。';

  @override
  String get calendarJumpToToday => '今日にジャンプ';

  @override
  String get editorStartWriting => '書き始めるか、選択してください ';

  @override
  String get editorTemplateLink => 'テンプレート';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'テンプレートを選択してください';

  @override
  String get templateFeatured => '注目のテンプレート';

  @override
  String get templateMine => '私のテンプレート';

  @override
  String get templateDailyName => '日々の振り返り';

  @override
  String get templateDailyDescription => '何が起こったのか、どう感じたのか、そして次に何が起こるのか。';

  @override
  String get templateDailyText =>
      '## 今日の出来事\n\n\n## 私がどう感じたか\n\n\n## 私が感謝している 3 つのこと\n1. \n2. \n3. \n\n## 明日\n';

  @override
  String get templateTravelName => '旅行日記のエントリー';

  @override
  String get templateTravelDescription => '旅先で得た場所、瞬間、食べ物。';

  @override
  String get templateTravelText =>
      '## 私が行った場所\n\n\n## 一番覚えている瞬間\n\n\n## 私が食べたもの\n\n\n## 明日の予定\n';

  @override
  String get templateReadingName => '読書メモ';

  @override
  String get templateReadingDescription => '読んだものからの引用と感想。';

  @override
  String get templateReadingText =>
      '## 予約する\n\n\n## 私がいる場所\n\n\n## 引用\n> \n\n## 私の考え\n';

  @override
  String get templateWeeklyName => '週次レビュー';

  @override
  String get templateWeeklyDescription => 'ハイライト、苦戦、そして来週の焦点。';

  @override
  String get templateWeeklyText =>
      '## ハイライト\n\n\n## 大変だったこと\n\n\n## 学んだこと\n\n\n## 来週に焦点を当てます\n';

  @override
  String get entrySaveAsTemplate => 'テンプレートとして保存';

  @override
  String get entrySavedAsTemplate => 'テンプレートとして保存されました';

  @override
  String get storyStatistics => '統計';

  @override
  String get storyMoodChart => '気分チャート';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return '$entries エントリ · $days 日';
  }

  @override
  String get storyThisYear => '今年は';

  @override
  String get storyLastYear => '昨年';

  @override
  String get storyTapToOpen => '日付をタップして開きます';

  @override
  String get settingsGeneralTitle => '一般';

  @override
  String get settingsDataTitle => 'データとストレージ';

  @override
  String get settingsStoriesTitle => 'ストーリー';

  @override
  String get settingsHelpTitle => 'ヘルプと概要';

  @override
  String get weatherTitle => '天気';

  @override
  String get weatherClear => 'クリア';

  @override
  String get weatherPartlyCloudy => '曇り';

  @override
  String get weatherCloudy => '曇り';

  @override
  String get weatherFog => '霧';

  @override
  String get weatherDrizzle => '霧雨';

  @override
  String get weatherRain => '雨';

  @override
  String get weatherSnow => '雪';

  @override
  String get weatherStorm => '雷雨';

  @override
  String get weatherFetch => 'このエントリの天気を取得する';

  @override
  String get weatherNeedsLocation => '最初に座標を含む場所を追加します。';

  @override
  String get weatherUnavailable => 'この場所と時間の天気は利用できません。';

  @override
  String get weatherRemove => '天気を削除する';

  @override
  String get activityTitle => 'アクティビティ';

  @override
  String get activityStill => 'それでも';

  @override
  String get activityWalking => 'ウォーキング';

  @override
  String get activityRunning => 'ランニング';

  @override
  String get activityCycling => 'サイクリング';

  @override
  String get activityVehicle => '車両内';

  @override
  String get activityFlying => '飛行';

  @override
  String get activityExercise => '運動';

  @override
  String get activityDetect => '現在のアクティビティを検出する';

  @override
  String get activityDetectFailed => 'アクティビティを検出できませんでした。';

  @override
  String get activityRemove => 'アクティビティを削除する';

  @override
  String get settingsAutoAddTitle => '自動的に追加';

  @override
  String get settingsAutoAddLocation => '場所';

  @override
  String get settingsAutoAddWeather => '天気';

  @override
  String get settingsAutoAddHint => '新しいエントリの作成時にこれらの値が入力されます。';

  @override
  String get settingsTemperatureUnit => '温度単位';

  @override
  String get settingsCelsius => '摂氏 (°C)';

  @override
  String get settingsFahrenheit => '華氏 (°F)';

  @override
  String get moodGreat => '素晴らしい';

  @override
  String get moodGood => '良い';

  @override
  String get moodOkay => 'わかりました';

  @override
  String get moodBad => '悪い';

  @override
  String get moodAwful => 'ひどい';

  @override
  String get locationSearchHint => '場所を探す';

  @override
  String get locationSearchEmpty => '場所が見つかりません';

  @override
  String get settingsWallpaper => '壁紙';

  @override
  String get wallpaperNone => 'なし';

  @override
  String get wallpaperDots => 'ドット';

  @override
  String get wallpaperGrid => 'グリッド';

  @override
  String get wallpaperLines => 'ライン';

  @override
  String get wallpaperPhoto => '写真…';

  @override
  String get settingsFontFamily => 'フォント';

  @override
  String get fontSystem => 'システム';

  @override
  String get fontSerif => 'セリフ';

  @override
  String get fontMono => '等空間';

  @override
  String get settingsFontSize => 'フォントサイズ';

  @override
  String get fontSizeSmall => '小';

  @override
  String get fontSizeMedium => '中';

  @override
  String get fontSizeLarge => '大';

  @override
  String get fontSizeExtraLarge => '特大';

  @override
  String get settingsLineSpacing => '行間';

  @override
  String get lineSpacingCompact => 'コンパクト';

  @override
  String get lineSpacingNormal => 'ノーマル';

  @override
  String get lineSpacingRelaxed => 'リラックスした';

  @override
  String get moodAssociationsTitle => '何を感じますか...';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching/$total エントリ';
  }

  @override
  String get videoRecord => 'ビデオを録画する';

  @override
  String get videoChoose => 'ビデオを選択してください';

  @override
  String get audioRecordTitle => '音声メモを録音する';

  @override
  String get audioChoose => '音声ファイルを選択してください';

  @override
  String get audioStart => '記録';

  @override
  String get audioStop => '停止して保存する';

  @override
  String get audioPermissionDenied => 'マイクアクセスがオフになっています。システム設定で許可してください。';

  @override
  String get mediaTooLarge => 'このビデオは大きすぎて添付できません。';

  @override
  String get mediaUnavailable => 'この添付ファイルはこのデバイスでは使用できません。';

  @override
  String get widgetDone => '今日のエントリーはこう書いています';

  @override
  String get widgetPending => '今日はどうでしたか？';

  @override
  String get widgetWrite => '書く';

  @override
  String get insertChecklist => 'チェックリスト';

  @override
  String get insertNumberedList => '番号付きリスト';

  @override
  String get insertTable => 'テーブル';

  @override
  String get insertDivider => 'ディバイダー';

  @override
  String get insertCodeBlock => 'コードブロック';

  @override
  String get journalSortTitle => 'エントリを並べ替える';

  @override
  String get journalSortUpdated => '最終更新日';

  @override
  String get settingsTimeFormat => '時刻形式';

  @override
  String get settingsDayStart => '新規エントリーは前日からカウントされるまでカウントされます';

  @override
  String get settingsDayAskUntil => 'それから何日までに尋ねます';

  @override
  String get settingsDayStartMidnight => 'オフ';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'すべてのエントリには、そのエントリが書き込まれた時刻の横にそのエントリが属する日付が表示されます。その日はエディタでいつでも変更できます。これらの時間は新しいエントリの日を選択するだけなので、それらを変更しても既存のエントリは移動されません。';

  @override
  String get lateNightBadge => '深夜に書き、前日からカウント';

  @override
  String editorDayAsk(String time) {
    return '$time で書かれています。それはどの日のことですか？';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (昨日)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (今日)';
  }

  @override
  String editorWrittenAt(String when) {
    return '$whenと書かれています';
  }

  @override
  String get timeFormat12 => '12時間';

  @override
  String get timeFormat24 => '24時間対応';

  @override
  String get settingsReminderDays => '思い出させて';

  @override
  String get locationRecent => '最近の場所';

  @override
  String get shareImage => '画像を共有する';

  @override
  String get shareSaveImage => '画像の保存';

  @override
  String get shareSaved => '画像を保存しました';

  @override
  String get deletedTitle => '最近削除されました';

  @override
  String get deletedNone => '最近削除されたものはありません';

  @override
  String deletedHint(int days) {
    return '削除されたエントリは $days 日間ここに残り、その後消去されます。';
  }

  @override
  String deletedDaysLeft(int days) {
    return '残り $days 日';
  }

  @override
  String get deletedRestore => '復元';

  @override
  String get deletedDeleteForever => '永久に削除';

  @override
  String get deletedDeleteForeverDescription =>
      'エントリとその添付ファイルが消去されます。これを元に戻すことはできません。';

  @override
  String get deletedEmpty => '空の';

  @override
  String get deletedEmptyDescription => '最近削除したエントリをすべて消去しますか?これを元に戻すことはできません。';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'ランダムウォーク';

  @override
  String get randomSubtitle => '過去のエントリーを開く';

  @override
  String get randomNext => 'もう一つ';

  @override
  String get randomAll => 'すべて';

  @override
  String get randomWithPhotos => '写真付き';

  @override
  String get randomGoodDays => '良い日々';

  @override
  String get randomEmpty => '選択できるエントリはありません';

  @override
  String get reviewWeekTitle => '今週';

  @override
  String get reviewWeekSubtitle => 'これまでの一週間';

  @override
  String get reviewYearTitle => '今年は';

  @override
  String get reviewEmpty => 'まだ何も書かれていません';

  @override
  String get reviewEntries => 'エントリー';

  @override
  String get reviewDaysWritten => '書かれた日数';

  @override
  String get reviewWords => '言葉';

  @override
  String get reviewPhotos => '写真';

  @override
  String get reviewLongestRun => '最長の日数';

  @override
  String get reviewAverageMood => '平均的な気分';

  @override
  String get reviewFavorites => 'ほとんどの場合';

  @override
  String get reviewByMonth => '月ごと';

  @override
  String get reviewHighlight => 'ハイライト';

  @override
  String get yearInPixels => 'ピクセル単位の年';

  @override
  String get capsuleSeal => 'タイムカプセルとして封印する';

  @override
  String get capsuleTitle => 'タイムカプセル';

  @override
  String capsuleOpensOn(Object date) {
    return '$date で開きます';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return '$date に書かれています';
  }

  @override
  String get capsuleOpenEarly => '早朝営業';

  @override
  String get capsuleOpenEarlyDescription => 'カプセルは開き、開いたままになります。';

  @override
  String get capsuleOpened => 'タイムカプセルを開けた';

  @override
  String get templateMorningName => 'モーニングページ';

  @override
  String get templateMorningDescription => '1 日を 3 分で設定する';

  @override
  String get templateMorningText =>
      '## 今日やっておきたい 3 つのこと\n1. \n2. \n3. \n\n## 楽しみにしていること\n\n## 自分へのメモ\n';

  @override
  String get templateEveningName => '夜の振り返り';

  @override
  String get templateEveningDescription => 'うまくいったことで一日を終える';

  @override
  String get templateEveningText =>
      '## 今日は良いことが 3 つありました\n1. \n2. \n3. \n\n## 学んだこと\n\n## 明日は何がうまくいくでしょうか\n';

  @override
  String get routineMorning => 'おはようございます';

  @override
  String get routineEvening => '夜の振り返り';

  @override
  String get settingsRoutinePrompts => '朝と夕方のプロンプト';

  @override
  String get settingsRoutinePromptsHint => 'ストーリーで朝または夜のテンプレートを提案する';

  @override
  String get checkInTitle => 'クイックチェックイン';

  @override
  String get checkInSubtitle => '2タップで気分';

  @override
  String get checkInMood => 'どう感じますか？';

  @override
  String get checkInActivity => '何をしているのですか？';

  @override
  String get checkInNote => 'それに関する一行 (オプション)';

  @override
  String get checkInSave => '保存';

  @override
  String editorWordCount(int words, int characters) {
    return '$words 単語 · $characters 文字';
  }

  @override
  String get coachProgramEverydayTagline => '一日の小さなことに気づいてください。';

  @override
  String get coachProgramReflectTagline => 'ゆっくりと自分自身の声に耳を傾けてください。';

  @override
  String get coachDuration => '期間';

  @override
  String get coachInterval => '間隔';

  @override
  String get coachDifficulty => '難易度';

  @override
  String get coachIntervalDaily => '毎日';

  @override
  String get coachIntervalWeekly => '毎週';

  @override
  String get coachDifficultyBeginner => '初心者';

  @override
  String get coachDifficultyIntermediate => '中級者';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count日',
      one: '1日',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count週間',
      one: '1週間',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return '$n日';
  }

  @override
  String coachWeekN(int n) {
    return '週 $n';
  }

  @override
  String get coachEnroll => '登録する';

  @override
  String get coachEndProgram => 'プログラムを終了する';

  @override
  String get coachAuthor => '著者';

  @override
  String get coachAuthorBio => 'このアプリ用に書かれたプロンプト。';

  @override
  String get coachEnrolledTip => '準備完了です！あなたの質問はストーリーに表示されます。';

  @override
  String get coachGoToStories => 'ストーリーに移動';

  @override
  String get coachAnswerHint => '答えを書いてください…';

  @override
  String get storyWrapUp => '今日はここまでです。';

  @override
  String get storyTapToClose => 'タップして閉じます';

  @override
  String get coachAnswerDone => '完了';

  @override
  String get coachAnswered => '回答済み、タップして開きます';

  @override
  String get coachAnsweredEarlier => '答えた';

  @override
  String get locationLocating => '探しています…';

  @override
  String get locationPickPlace => '場所を選ぶ';

  @override
  String get locationPlacesHint => '住所または場所の名前';

  @override
  String get locationCustom => 'カスタムプレイス';

  @override
  String get locationCurrent => '現在地';

  @override
  String get locationSaved => '保存された場所';

  @override
  String get locationSearchResults => '検索結果';

  @override
  String get locationNearby => '近くの場所';

  @override
  String get locationRename => '名前の変更';

  @override
  String get locationSavePlace => '場所を保存する';

  @override
  String get locationUnsavePlace => '保存した場所から削除する';

  @override
  String get shareAs => 'として共有…';

  @override
  String get shareAsImage => '画像';

  @override
  String get shareAsZip => 'ZIP (元のメディア付き)';

  @override
  String get shareAsPlainText => 'プレーンテキスト';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'AID Diaryへようこそ';

  @override
  String get onboardWelcomeText => 'ここから始めるか、このデバイスをすでに使用しているデバイスに接続してください。';

  @override
  String get onboardStart => '書き始める';

  @override
  String get helpFaq => 'よくある質問';

  @override
  String get helpFaq1Q => '私の日記はどこに保存されていますか?';

  @override
  String get helpFaq1A =>
      'あなたの日記はこのデバイスに保存されます。同期、共有、またはエクスポートを有効にした場合にのみ、他のデバイスまたはストレージに到達します。同期はエンドツーエンドで暗号化されます。';

  @override
  String get helpFaq2Q => 'コピーを保存したり、新しいデバイスに移動したりするにはどうすればよいですか?';

  @override
  String get helpFaq2A =>
      '「設定」→「データとストレージ」→「同期」で既存のデバイスに接続し、日記があるデバイスでの承認を確認します。どちらのデバイスも引き続き使用可能です。バックアップを作成して、別のデバイスに復元することもできます。';

  @override
  String get helpFaq3Q => '他の日記アプリのエントリを取り込むことはできますか?';

  @override
  String get helpFaq3A =>
      'はい: [設定] → [データとストレージ] で、Daylio、Diarium、Diaro、DayBook、My Brain、OneShot、Pixels からのエクスポート、または JSON エクスポートをインポートします。';

  @override
  String get helpFaq4Q => 'コーチプログラムはどのように機能しますか?';

  @override
  String get helpFaq4A =>
      'Coach ページでプログラムに登録します。毎日または毎週、ストーリーには新しい質問が追加されます。あなたの回答はエントリとして保存されます。';

  @override
  String get helpFaq5Q => 'パスコードを忘れた場合はどうすればよいですか?';

  @override
  String get helpFaq5A => 'パスコードは復元できないため、日記のバックアップを保管してください。';

  @override
  String get helpPrivacy => 'プライバシー';

  @override
  String get helpPrivacyText =>
      '日記のコンテンツとメディアは、暗号化された同期を有効にするか共有/エクスポートしない限り、このデバイスに残ります。地図、場所の検索、天気予報は、設定されたサービスを使用して、日記テキストではなく、そのリクエストに必要な場所または検索クエリを送信します。';

  @override
  String get photoMetaTitle => '写真の詳細を使用しますか?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return '写真に記録されているように、このエントリを $date としてカウントし、その場所を $place に設定しますか?';
  }

  @override
  String photoMetaDate(String date) {
    return '写真がいつ撮影されたか、$date のこのエントリを数えますか?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'このエントリの場所を $place に設定します。写真はどこで撮影されましたか?';
  }

  @override
  String get photoMetaApply => 'それらを使用してください';

  @override
  String get quickWriteTitle => 'クイック書き込み';

  @override
  String get quickWriteText => 'タップして新しいエントリを開始します。';

  @override
  String get settingsQuickWriteTitle => 'クイック書き込み通知';

  @override
  String get settingsQuickWriteDescription => '新しいエントリを開く通知を保持します。';

  @override
  String get settingsNudgesTitle => '静かにストレッチした後、私を小突いてください';

  @override
  String settingsNudgesDescription(int days) {
    return '$days 日間執筆していない場合の優しいリマインダー。';
  }

  @override
  String get nudgeTitle => 'しばらく経ちました';

  @override
  String get nudgeMonday => '新しい週: 何を楽しみにしていますか?';

  @override
  String get nudgeTuesday => '2行あれば十分です。今日は元気ですか？';

  @override
  String get nudgeWednesday => '週の半ば。これまでのところ何が目立っていましたか？';

  @override
  String get nudgeThursday => '今日から覚えておく価値のある小さなことはありますか？';

  @override
  String get nudgeFriday => '今週も終わりです。良い瞬間を思い出してください。';

  @override
  String get nudgeSaturday => 'ゆっくりとした土曜日は書くのに最適な日です。';

  @override
  String get nudgeSunday => '終わるまでの一週間を振り返ってみましょう。';

  @override
  String get photoWidgetEmpty => 'エントリに追加した写真がここに表示されます。';

  @override
  String get channelReminders => 'リマインダー';

  @override
  String get channelOnThisDay => 'この日は';

  @override
  String get channelCoach => 'コーチのプロンプト';

  @override
  String get channelNudges => '静かな日々の後に少しずつ';

  @override
  String get channelQuickWrite => 'クイック書き込み';

  @override
  String get channelBackup => 'バックアップ';

  @override
  String get formatJsonExport => 'JSON (AID Diary エクスポート)';

  @override
  String get aboutModifiedNotice =>
      'Demizo と寄稿者による Daily You の修正版。 Daily Youの公式アプリではありません。';

  @override
  String get toolbarPhotos => '写真を追加する';

  @override
  String get toolbarMedia => '写真とビデオ';

  @override
  String get mediaFromGallery => 'ギャラリーから選ぶ';

  @override
  String get mediaFromFiles => 'ファイルから選択';

  @override
  String get editorLeaveTitle => 'このエントリを保存しますか?';

  @override
  String get editorLeaveDiscard => '保存しないでください';

  @override
  String get editorTitleHint => 'タイトル';

  @override
  String get editorLocating => '探しています…';

  @override
  String get toolbarVideo => 'ビデオ';

  @override
  String get toolbarAudio => 'ボイスメモ';

  @override
  String get toolbarTags => 'タグ';

  @override
  String get toolbarBulletList => '箇条書きリスト';

  @override
  String get toolbarHeading => '見出し';

  @override
  String get toolbarBold => '太字';

  @override
  String get toolbarItalic => 'イタリック体';

  @override
  String get toolbarHighlight => 'ハイライト';

  @override
  String get toolbarStrikethrough => '取り消し線';

  @override
  String get toolbarQuote => '引用';

  @override
  String get toolbarLink => 'リンク';

  @override
  String get toolbarInsert => '挿入';

  @override
  String get toolbarUndo => '元に戻す';

  @override
  String get toolbarRedo => 'やり直し';

  @override
  String get toolbarInsertDate => '日付を挿入する';

  @override
  String get toolbarInsertTime => '時間を挿入します';

  @override
  String get settingsSyncTitle => 'クラウド同期';

  @override
  String get syncOffDescription =>
      'Nextcloud、Synology、Jianguoyun などの Google Drive または WebDAV サーバーを介して、すべてのデバイスでこの日記を同じに保ちます。';

  @override
  String get syncUseGoogleDrive => 'Google Driveと同期する';

  @override
  String get syncOrWebDav => 'または WebDAV サーバー';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn => 'サインインしました。AID Diary に戻ることができます。';

  @override
  String get syncGoogleSignInAgain => 'Google では再度ログインする必要があります。';

  @override
  String get syncSignInAgain => '再度サインインしてください';

  @override
  String get settingsCommandLineTitle => 'コマンドライン';

  @override
  String get commandLineToggle => 'コマンドラインインターフェース';

  @override
  String get commandLineToggleHint =>
      'このデバイス上の補助コマンドおよび他のプログラムがアプリのコマンドを使用できるようにします。';

  @override
  String get commandLineAlwaysOn => '開発ビルドでは常にオンになります。';

  @override
  String commandLineListening(int port) {
    return 'ポート $port でリッスンしています';
  }

  @override
  String get commandPaletteTitle => 'すべてのコマンド';

  @override
  String get commandPaletteSearch => '検索コマンド';

  @override
  String get commandPaletteRun => '走る';

  @override
  String get commandPaletteConfirm => 'これを簡単に元に戻すことはできません。実行しますか？';

  @override
  String syncReceiving(int done, int total) {
    return '$done/$totalを受信中…';
  }

  @override
  String syncSending(int done, int total) {
    return '$done/$total を送信中…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'Google Drive へのアクセスは許可されませんでした。再度接続し、Google のページで Google Drive にチェックを入れます。';

  @override
  String get syncEntryUnsynced => '同期されていません: 最後の同期が完了しませんでした';

  @override
  String get syncUseOfficial => 'AID同期サーバーを使用する';

  @override
  String get syncServer => 'サーバーアドレス';

  @override
  String get syncUsername => 'ユーザー名';

  @override
  String get syncPassword => 'パスワード';

  @override
  String get syncConnect => '接続する';

  @override
  String get syncConnecting => '接続中…';

  @override
  String get syncSignInFailed => 'サインインできませんでした。アドレス、ユーザー名、パスワードを確認してください。';

  @override
  String syncConnectFailed(String error) {
    return '接続できませんでした: $error';
  }

  @override
  String get syncNewSpaceTitle => '同期を開始する';

  @override
  String get syncNewSpaceDescription =>
      'ここにはまだ同期された日記がありません。この日記は、デバイス上に残るキーでエンドツーエンド暗号化されてアップロードされます。';

  @override
  String get syncJoinTitle => '同期された日記に参加する';

  @override
  String get syncWrongKey => 'このリカバリ コードでは、同期された日記は開きません。';

  @override
  String syncLastSynced(String time) {
    return '最後に同期したのは $time';
  }

  @override
  String get syncNever => 'まだ同期されていません';

  @override
  String get syncSyncing => '同期中…';

  @override
  String syncFailed(String error) {
    return '最後の同期が失敗しました: $error';
  }

  @override
  String get syncLocked =>
      '同期された日記は現在他のデバイスに属しているか、最初からやり直しられています。いずれかとペアリングするか、リカバリ コードを使用して同期を続けます。';

  @override
  String get syncNow => '今すぐ同期する';

  @override
  String get syncUnlock => 'ロックを解除する';

  @override
  String get syncEncrypted => 'エンドツーエンド暗号化';

  @override
  String get syncDisconnect => '同期を停止する';

  @override
  String get syncDisconnectDescription =>
      'このデバイスは同期を停止します。ここの日記と同期したコピーはそのまま残ります。';

  @override
  String get syncOwnRecoveryPassword => '自分の回復パスワードを使用する';

  @override
  String get syncRecoveryPassword => '回復パスワード';

  @override
  String get syncRecoveryPasswordRepeat => '回復パスワードを繰り返します';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return '少なくとも $min 文字を使用してください';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'パスワードが異なります';

  @override
  String get syncRecoveryCode => 'リカバリーコード';

  @override
  String get syncRecoveryCodeTitle => 'リカバリーコードを保存してください';

  @override
  String get syncRecoveryCodeDescription =>
      'すべてのデバイスを紛失した場合、このコードにより同期された日記が復元されます。パスワードマネージャーまたは紙に保管してください。この回のみ表示されます。';

  @override
  String get syncRecoveryCodeCopied => 'リカバリーコードがコピーされました';

  @override
  String get syncRecoveryCodeSaved => '保存しました';

  @override
  String get syncJoinNeedsKey =>
      'この同期された日記は他のデバイスに属します。これらのいずれかとペアリングするか、リカバリ コードを使用してください。このデバイス上のエントリがデバイスに追加されます。';

  @override
  String get syncPairDevice => 'デバイスとペアリングする';

  @override
  String get syncUseRecoveryCode => 'リカバリーコードを使用する';

  @override
  String get syncAddDevice => 'デバイスを追加する';

  @override
  String get syncChangeRecoveryCode => 'リカバリーコードを変更する';

  @override
  String get syncChangeRecoveryDescription =>
      '新しいコードが現在のコードを置き換えると、動作が停止します。データやその他のデバイスはそのまま残ります。';

  @override
  String get syncNewRandomCode => '新しいランダムコード';

  @override
  String get syncRecoveryCodeChanged => 'リカバリーコードが変更されました';

  @override
  String get syncResetSpace => '同期された日記を最初からやり直す';

  @override
  String get syncResetSpaceDescription =>
      'デバイスも回復コードも開かない場合にのみ、同期されたコピーは、このデバイスのキーの下にあるこのデバイス上の日記に置き換えられます。その後、他のデバイスを再度ペアリングします。';

  @override
  String get syncPairTitle => 'デバイスをペアリングする';

  @override
  String get syncPairShow => 'コードを表示する';

  @override
  String get syncPairEnter => 'コードを入力してください';

  @override
  String get syncPairShowHint =>
      '他のデバイスで、[デバイスのペアリング] を開き、[コードの入力] を選択して、コードを入力またはスキャンします。';

  @override
  String get syncPairEnterHint => '他のデバイスに表示されるコードを入力するか、スキャンします。';

  @override
  String get syncPairCode => 'ペアリングコード';

  @override
  String get syncPairScan => 'スキャン';

  @override
  String get syncPairStart => 'ペア';

  @override
  String get syncPairWaiting => '他のデバイスを待っています…';

  @override
  String syncPairDone(String device) {
    return '$deviceとペアリング';
  }

  @override
  String get syncPairWrongCode => 'コードが一致しませんでした。新しいコードを表示して、再試行してください。';

  @override
  String get syncPairNoOffer => 'このコードを表示するデバイスはありません。有効期限が切れている可能性があります。';

  @override
  String get syncPairTimedOut => '他のデバイスは時間内に応答しませんでした。';

  @override
  String get syncPairNeither => 'どちらのデバイスも、この同期された日記をまだセットアップしていません。';

  @override
  String get syncPairBoth => '両方のデバイスがこの同期された日記をすでに開いています。';

  @override
  String syncPairFailed(String error) {
    return 'ペアリングに失敗しました: $error';
  }

  @override
  String get syncMediaPending => '日記が同期されました。一部のメディアはまだ転送中です';

  @override
  String get syncWaitingForDevices => '日記が同期されました · 別のデバイスがメディアを転送するのを待っています';

  @override
  String get syncCacheNotice =>
      'クラウド メディアは一時的なものです。オリジナルをデバイスに保存してください。同期はバックアップではありません。';

  @override
  String get paperTitle => '便箋';

  @override
  String get paperPlain => 'プレーン';

  @override
  String get paperLined => '裏地あり';

  @override
  String get paperGrid => 'グリッド';

  @override
  String get paperTinted => '着色された';

  @override
  String get paperDecorationTitle => '装飾品';

  @override
  String get paperDecorationNone => 'なし';

  @override
  String get paperDecorationBotanical => '葉';

  @override
  String get paperDecorationStars => 'スター';

  @override
  String get paperDecorationWashi => '和紙テープ';

  @override
  String get themeDarkChoice => '暗い外観';

  @override
  String get themeDarkSame => 'ライトパレットに従ってください';

  @override
  String get themeDarkCustom => 'セパレートパレット';

  @override
  String get themeDarkAccent => 'ダークなアクセントカラー';

  @override
  String get themeColorTeal => 'ティール';

  @override
  String get themeColorCyan => 'シアン';

  @override
  String get themeColorIndigo => 'インディゴ';

  @override
  String get themeColorCoral => 'サンゴ';

  @override
  String get themeColorOlive => 'オリーブ';

  @override
  String get themeColorSlate => 'スレート';

  @override
  String get drawingTitle => '図面';

  @override
  String get drawingPen => 'ペン';

  @override
  String get drawingEraser => '消しゴム';

  @override
  String get drawingUndo => '元に戻す';

  @override
  String get drawingClear => 'クリア';

  @override
  String get drawingWidth => 'ペン幅';

  @override
  String get drawingStylusOnly => 'スタイラスのみ';

  @override
  String get drawingDiscardTitle => '図面を破棄しますか?';

  @override
  String get drawingDiscardBody => 'この図面は保存されていません。';

  @override
  String get drawingSaveError => '図面を保存できませんでした。';

  @override
  String get syncNetworkTitle => 'ネットワーク診断';

  @override
  String get syncNetworkRefresh => 'リフレッシュ';

  @override
  String get syncNetworkSelectedRoute => '現在のパス';

  @override
  String get syncNetworkAvailableRoutes => '利用可能なパス';

  @override
  String get syncNetworkSignaling => 'デバイスディレクトリ接続';

  @override
  String get syncNetworkRelayRemaining => 'リレー許容残量';

  @override
  String get syncNetworkIcePair => '直接接続候補';

  @override
  String get syncNetworkPeerTrusted => '認証されたデバイス';

  @override
  String get syncNetworkNoRoute => '接続を待っています';

  @override
  String get syncNetworkUnavailable => '診断は利用できません';

  @override
  String get syncMediaCopiesTitle => 'メディアの配信とコピー';

  @override
  String get syncMediaPendingCount => '転送を待っています';

  @override
  String get syncMediaDurableCount => '個人保管場所に配送されます';

  @override
  String get syncMediaTemporaryCount => '一時的なコピーまたは未確認のコピー';

  @override
  String get syncMediaReceiptExplanation =>
      'これらの数は、生き残ったバックアップの新たな監査ではなく、完了した配信を表します。';

  @override
  String get syncMediaCacheExplanation =>
      '一時的なクラウド メディアは期限切れになる場合があります。オリジナルまたは別のバックアップを保管してください。';

  @override
  String get momentsTitle => '写真の瞬間';

  @override
  String get momentsHint =>
      '現地の写真撮影時間とオプションの座標を使用してグループを検索します。写真はカードを選択した場合のみ添付されます。';

  @override
  String get momentsScan => '瞬間を見つける';

  @override
  String get momentsChooseFolder => '写真フォルダーを選択してください';

  @override
  String get momentsLocation => '写真の場所を含める';

  @override
  String get momentsEmpty => '最近の写真グループはありません。';

  @override
  String get momentsCreate => 'これらの写真について書く';

  @override
  String get momentsDismiss => '解雇する';

  @override
  String get momentsError => 'ローカルの写真を読み取れませんでした。';

  @override
  String get momentsCreated => '写真エントリーを作成しました。';

  @override
  String get momentsPermission => 'ローカルの提案を見つけるために写真へのアクセスを許可します。';

  @override
  String get momentsScope => '最近の写真のみ。最大 500 枚の写真、カードあたり 20 枚の写真。';

  @override
  String momentsPhotoCount(int count) {
    return '$countの写真';
  }

  @override
  String get nearbyTitle => 'デバイスを接続する';

  @override
  String get nearbySend => '別のデバイスを認証する';

  @override
  String get nearbyReceive => '既存のデバイスに接続する';

  @override
  String get nearbyInstructions =>
      '両方のデバイスを同じ Wi-Fi または互いのホットスポットに接続します。既存のデバイスでの認証を確認します。両方のデバイスは引き続き使用可能です。インターネットは必要ありません。';

  @override
  String get nearbyCompare => '承認する前に、両方のデバイスでこのコードを比較してください。';

  @override
  String get nearbyConfirm => 'コードは一致します';

  @override
  String get nearbyScan => '他のデバイスのコードをスキャンします';

  @override
  String get nearbyPaste => '招待状を貼り付け';

  @override
  String get nearbyWaiting => '他のデバイスで承認を待っています';

  @override
  String get nearbyWorking => '日記と添付ファイルを認証して同期しています…';

  @override
  String get nearbyPending =>
      '一部の添付ファイルはまだ同期する必要があります。他のデバイスをオンラインのままにして、もう一度試してください。';

  @override
  String get nearbyComplete => 'デバイスが接続されています。日記と添付ファイルが同期されました';

  @override
  String get nearbyFailed => '接続が完了しませんでした。ローカル接続を確認して、再試行してください。';

  @override
  String get nearbyEmptyRequired => 'まだ同期に接続されていない空の日記を持つデバイスを使用してください。';

  @override
  String get nearbyRetry => '同期を続ける';

  @override
  String get nearbyWifi => 'Wi-Fiの設定';

  @override
  String get nearbyHotspot => 'ホットスポット設定';

  @override
  String get nearbyKeepOpen =>
      '新しいデバイスが完了するまで、このページを開いたままにしてください。招待状は 2 分後に期限切れになります。';

  @override
  String get syncDevicesTitle => '認可されたデバイス';

  @override
  String get syncDevicesDescription =>
      '承認されたデバイスのみがこの AID アカウントにアクセスできます。デバイスを取り消すとサーバーはブロックされますが、既にサーバーにコピーされているマスター キーや日記を消去することはできません。';

  @override
  String get syncDeviceRequest => 'この認証 QR を承認されたデバイスに表示します';

  @override
  String get syncDeviceAuthorize => 'デバイスを認証する';

  @override
  String get syncDeviceAuthorizeDescription => '新しいデバイスの認証リクエストをスキャンまたは貼り付けます。';

  @override
  String get syncDeviceRevoke => '取り消し';

  @override
  String get syncDeviceRotate => 'このデバイスの署名キーをローテーションします';

  @override
  String get syncDeviceCheck => '権限の確認';

  @override
  String get syncDeviceHardware => 'ハードウェアでサポートされた署名キー';

  @override
  String get syncDeviceSoftware => 'エクスポートできないソフトウェア署名キー';

  @override
  String get syncDeviceUnavailable =>
      'デバイス認証は利用できません。別の承認されたデバイスからこのデバイスを承認して、再試行してください。';

  @override
  String get syncDeviceRevoked => '取り消されました';

  @override
  String get syncDeviceLocal => 'このデバイス';

  @override
  String get cloudTrafficTitle => 'クラウドの月間メディア転送量';

  @override
  String get cloudTrafficLimit => '月間転送量の上限';

  @override
  String get cloudTrafficUsed => '使用済み転送量';

  @override
  String get cloudTrafficRemaining => '残りの転送量';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'データ転送クォータが $time にリセットされる';
  }

  @override
  String get cloudTrafficExhausted =>
      'メディア ファイルのクラウド データ転送割り当てを使い果たしました。直接接続が利用可能になるか、クォータがリセットされると、不足しているメディア ファイルが自動的に同期されます。';

  @override
  String get cloudTrafficExplanation =>
      'メディア ファイル キャッシュとライブ リレーは、このデータ転送クォータを共有します。直接接続では消費されません。日記のテキストと接続制御メッセージには、1 日あたりの小さな制限が個別にあります。';

  @override
  String get appearanceThemeSection => 'アプリのテーマ';

  @override
  String get appearancePaperSection => '日記用紙';

  @override
  String get appearanceTypographySection => '日記のテキスト';

  @override
  String get appearancePreferencesSection => '一般的な設定';

  @override
  String get themeSystemAccentHint =>
      'カスタムカラーの代わりにシステムパレットを使用します。独自のものを選択するにはオフにしてください。';

  @override
  String get syncDeviceNameSaveFailed => 'デバイス名を保存できませんでした。もう一度試してください。';

  @override
  String get nearbyConnectionHelp => '接続ヘルプ';

  @override
  String get syncAllSynced => 'すべてが同期されました';

  @override
  String get syncDetailsTitle => '同期の詳細';

  @override
  String get syncMore => 'その他のオプション';

  @override
  String get syncDeviceName => 'デバイス名';

  @override
  String get syncDeviceNameHint => '例: 私のタブレット';

  @override
  String get syncDeviceNameInvalid => '1 ～ 32 文字を使用してください';

  @override
  String get syncDeviceKeyDetails => 'セキュリティの詳細';

  @override
  String get syncConnectionProblem => '現在同期できません。自動的に再試行します。';

  @override
  String get syncCopyComplete => '日記とメディア ファイルの完全なコピー';

  @override
  String get syncCopyPartial => '一部のメディアがまだありません';

  @override
  String get syncCopyOlder => '新しい変更は同期を待っています';

  @override
  String get syncCopyUnavailable => 'コピーの詳細は表示されません。後でもう一度試してください。';

  @override
  String get syncCopyLastKnown =>
      '他のデバイスには、最後に確認されたコピーが表示されます。現在、オフラインのデバイスを確認することはできません。';

  @override
  String get syncCopyTemporary => '一時キャッシュ。オリジナルをデバイスに保存してください。';

  @override
  String get syncCopyStorage => '同期ストレージ。完了したメディアのアップロードは診断にリストされます。';

  @override
  String syncCopyChecked(String time) {
    return '最後に確認されたのは $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return '今月の残り転送量: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'ここから始めましょう';

  @override
  String get onboardConnect => '既存のデバイスに接続';

  @override
  String get onboardFailed => 'セットアップを完了できませんでした。あなたの日記は安全です。もう一度試してください。';

  @override
  String get tutorialTitle => '日記の使い方';

  @override
  String get tutorialWriteTitle => 'はじめての日記を書く';

  @override
  String get tutorialWriteText =>
      '＋をタップして日記を書きます。必要に応じてタイトルを追加し、日付を選んでチェックマークをタップすると保存できます。保存後もいつでも編集できます。';

  @override
  String get tutorialMediaTitle => '写真、音声、手書きを追加する';

  @override
  String get tutorialMediaText =>
      '日記エディターで + を使用して、写真、ビデオ、音声録音を添付したり、手書きキャンバスを開きます。これらの添付ファイルは日記エントリとともに保存されます。';

  @override
  String get tutorialReviewTitle => 'もう一度一日を見つけてください';

  @override
  String get tutorialReviewText =>
      '日記やカレンダーを参照し、書き込みを検索し、タグを使用してエントリを整理します。メディア ページとアトラス ページでは、写真や場所から過去のエントリを検索できます。';

  @override
  String get tutorialSyncTitle => '複数のデバイスを使用する';

  @override
  String get tutorialSyncText =>
      '「設定 → データとストレージ → 同期」で既存のデバイスに接続し、そのデバイスで承認してください。どちらのデバイスも引き続き使えます。日記の本文を先に同期し、添付ファイルは接続状況と残りの転送量に応じて順次同期します。';

  @override
  String get tutorialPrivacyTitle => '日記を安全に保管してください';

  @override
  String get tutorialPrivacyText =>
      '日記エントリは、同期、共有、またはエクスポートを有効にしない限り、このデバイスに残ります。同期はエンドツーエンドで暗号化されます。 [設定] では、アプリのパスコードを設定したり、バックアップを作成したり、このチュートリアルを再度開いたりすることもできます。';

  @override
  String get editorDiaryDay => '日記の日付';

  @override
  String get editorDiaryDayPicker => '日記の日付 · 作成日時は変更しません';

  @override
  String get editorDiaryDayHint => 'この日記をどの日に分類するかを指定します。変更しても作成日時は変わりません。';

  @override
  String get hiddenDiaryTitle => '非表示の日記';

  @override
  String get hiddenDiaryHide => '日記を非表示にする';

  @override
  String get hiddenDiaryShow => '日記を再表示する';

  @override
  String get hiddenDiaryEmpty => '非表示の日記はありません';

  @override
  String get hiddenDiaryUnlock => '非表示の日記をロック解除';

  @override
  String get hiddenDiaryAuthHint => 'アプリロックまたは端末の画面ロックで解除してください。';

  @override
  String get hiddenDiaryLocalOnly =>
      '非表示の日記はこの端末に保存され、同期は一時停止します。暗号化バックアップを使用してください。他の端末にある既存のコピーは変更されません。';

  @override
  String get moodClear => '気分をクリア';

  @override
  String get scrollToTop => '先頭に戻る';

  @override
  String get feedbackTitle => 'フィードバック';

  @override
  String get feedbackHint => '問題や提案を入力してください';

  @override
  String get feedbackGithub => 'GitHub で報告';

  @override
  String get feedbackEmail => 'メールで送る';

  @override
  String get feedbackCopy => '文章をコピー';

  @override
  String get feedbackLaunchFailed => 'アプリを開けません。文章をコピーして下記のメールアドレスをご利用ください。';

  @override
  String get feedbackCopied => 'コピーしました';
}
