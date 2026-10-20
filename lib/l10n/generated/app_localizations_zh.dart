// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => '主题色';

  @override
  String get themeColorHint => '点选后自动关闭跟随系统强调色，浅色和深色模式都会生效。';

  @override
  String get themeColorBlue => '天空蓝';

  @override
  String get themeColorGreen => '森林绿';

  @override
  String get themeColorBrown => '暖咖棕';

  @override
  String get themeColorPurple => '薰衣紫';

  @override
  String get themeColorRose => '烟粉玫瑰';

  @override
  String get themeColorAmber => '琥珀橙';

  @override
  String get themeColorPreview => '每天，留下一点记录';

  @override
  String get themeTintBackgroundTitle => '背景跟随主题色';

  @override
  String get themeTintBackgroundHint => '关闭后使用中性黑灰背景，按钮仍保留所选颜色。';

  @override
  String get dailyReminderTitle => '记得留下今日日迹！';

  @override
  String get dailyReminderDescription => '今天的日迹还没写呢…';

  @override
  String get actionTakePhoto => '拍张照';

  @override
  String get actionToday => '今天';

  @override
  String get actionOtherDay => '前几天';

  @override
  String get pageHomeTitle => '主页';

  @override
  String get jumpToMonthTitle => '月迹跳转';

  @override
  String get jumpToLogTitle => '日迹直达';

  @override
  String get flashbacksTitle => '往昔重现';

  @override
  String get settingsFlashbacksExcludeBadDays => '排除糟糕的日子';

  @override
  String get flaskbacksEmpty => '暂无回忆…';

  @override
  String get flashbackGoodDay => '美好的一天';

  @override
  String get flashbackRandomDay => '随机的一天';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 周前',
      one: '$count 周前',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 月前',
      one: '$count 月前',
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
  String get flashbackOnThisDay => '在这一天';

  @override
  String get pageGalleryTitle => '迹忆';

  @override
  String get searchLogsHint => '搜索日迹…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '日迹 $count',
      one: '日迹 $count',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '天数 $count',
      one: '天数 $count',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '字数 $count',
      one: '字数 $count',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => '暂无日迹…';

  @override
  String get noResults => '无结果…';

  @override
  String get sortDateTitle => '日期';

  @override
  String get sortOrderAscendingTitle => '升序';

  @override
  String get sortOrderDescendingTitle => '降序';

  @override
  String get pageStatisticsTitle => '统计';

  @override
  String get statisticsNotEnoughData => '数据不足…';

  @override
  String get statisticsRangeOneMonth => '1 个月';

  @override
  String get statisticsRangeSixMonths => '6 个月';

  @override
  String get statisticsRangeOneYear => '1 年';

  @override
  String get statisticsRangeAllTime => '全部';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag 概览';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag 每日分布';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag 起伏';
  }

  @override
  String get chartGroupingLabel => '群组';

  @override
  String get chartGroupingDay => '天';

  @override
  String get chartGroupingWeek => '周';

  @override
  String get chartGroupingMonth => '月';

  @override
  String get chartGroupingYear => '年';

  @override
  String get chartSmoothingLabel => '平滑';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '连续记录天数 $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '最长连续记录天数 $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '美好的日子 $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '好心情维持天数 $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle => '无法访问外部存储';

  @override
  String get errorExternalStorageAccessDescription =>
      '如果您正在使用网络存储，请确保服务在线且您具有网络访问权限。\n\n否则，该应用程序可能已失去对外部文件夹的权限。请转到设置，然后重新选择外部文件夹以授予访问权限。\n\n警告，在恢复对外部存储位置的访问之前，更改将不会同步！';

  @override
  String get errorExternalStorageAccessContinue => '继续使用本地数据库';

  @override
  String get databaseMigrationErrorTitle => '无法移动你的数据';

  @override
  String get databaseMigrationErrorDescription =>
      '您的数据是安全的，但无法移动到应用的储存中。\n\n请重试，如果问题复现，请报告这个问题。';

  @override
  String get databaseMigrationErrorRetry => '重试';

  @override
  String get errorReport => '报告问题';

  @override
  String get lastModified => '最后修改时间';

  @override
  String get writeSomethingHint => '写点什么…';

  @override
  String get titleHint => '标题…';

  @override
  String get deleteLogTitle => '删除日迹';

  @override
  String get deleteLogDescription => '您确定要删除该条日迹吗？';

  @override
  String get deletePhotoTitle => '删除图片';

  @override
  String get deletePhotoDescription => '您确定要删除这张图片吗？';

  @override
  String get pageSettingsTitle => '设置';

  @override
  String get settingsAppearanceTitle => '外观';

  @override
  String get settingsTheme => '主题模式';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeLight => '浅色主题';

  @override
  String get themeDark => '深色主题';

  @override
  String get themeAmoled => '纯黑主题';

  @override
  String get settingsFirstDayOfWeek => '一周开始日';

  @override
  String get settingsCalendarSystem => '历法系统';

  @override
  String get calendarSystemGregorian => '公历';

  @override
  String get calendarSystemJalali => '波斯历';

  @override
  String get settingsUseSystemAccentColor => '使用系统强调色';

  @override
  String get settingsCustomAccentColor => '自定义强调色';

  @override
  String get settingsShowMarkdownToolbar => '显示 Markdown 工具栏';

  @override
  String get settingsShowFlashbacks => '显示往昔重现';

  @override
  String get settingsChangeMoodIcons => '更改心情图标';

  @override
  String get moodIconPrompt => '输入一个图标';

  @override
  String get settingsFlashbacksViewLayout => '往昔重现的视图布局';

  @override
  String get settingsHideImagesInGallery => '隐藏图库中的图片';

  @override
  String get settingsHideImages => '隐藏图片';

  @override
  String get pageCalendarTitle => '日历';

  @override
  String get settingsNotificationsTitle => '通知';

  @override
  String get settingsDailyReminderOnboarding => '开启每日提醒，保持自己的连贯性！';

  @override
  String get settingsNotificationsPermissionsPrompt => '为了按时发送提醒，应用将请求通知权限。';

  @override
  String get settingsDailyReminderTitle => '每日提醒';

  @override
  String get settingsOnThisDayDescription => '重温过去的记忆';

  @override
  String get settingsDailyReminderDescription => '每天一次温和的提醒';

  @override
  String get settingsReminderTime => '提醒时间';

  @override
  String get settingsFixedReminderTimeTitle => '固定提醒时间';

  @override
  String get settingsFixedReminderTimeDescription => '选择一个固定的提醒时间';

  @override
  String get settingsAlwaysSendReminderTitle => '总是发送提醒';

  @override
  String get settingsAlwaysSendReminderDescription => '即使日志已经开始，也发送提醒';

  @override
  String get settingsCustomizeNotificationTitle => '自定义通知';

  @override
  String get settingsTemplatesTitle => '模板';

  @override
  String get settingsDefaultTemplate => '默认模板';

  @override
  String get manageTemplates => '管理模板';

  @override
  String get addTemplate => '选择添加模板';

  @override
  String get newTemplate => '新建模板';

  @override
  String get noTemplateTitle => '无';

  @override
  String get noTemplatesDescription => '尚未创建任何模板…';

  @override
  String get templateVariableTime => '时间';

  @override
  String get templateDefaultTimestampTitle => '时间戳';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => '每日总结';

  @override
  String get templateDefaultSummaryBody => '### 摘要\n- \n\n### 引用\n> ';

  @override
  String get templateDefaultReflectionTitle => '反思';

  @override
  String get templateDefaultReflectionBody =>
      '### 你今天最享受的是什么？\n- \n\n### 你感恩什么？\n- \n\n### 你期待什么？\n- ';

  @override
  String get settingsTagsTitle => '标签';

  @override
  String get manageTags => '管理标签';

  @override
  String get tagTypeLabelTitle => '标签';

  @override
  String get tagTypeTrackerTitle => '追踪器';

  @override
  String get nameHint => '名称';

  @override
  String get tagColorLabel => '颜色';

  @override
  String get iconPickerTitle => '选择图标';

  @override
  String get iconPickerIconsTab => '图标';

  @override
  String get iconPickerCustomTab => '自定义';

  @override
  String get iconPickerSearchHint => '搜索图标…';

  @override
  String get colorPickerTitle => '选择颜色';

  @override
  String get colorPickerPaletteTab => '颜色';

  @override
  String get iconGroupMoodPeople => '心情与人物';

  @override
  String get iconGroupHealth => '健康';

  @override
  String get iconGroupWorkFinance => '工作与金融';

  @override
  String get iconGroupHabitsGoals => '习惯与目标';

  @override
  String get iconGroupNature => '自然';

  @override
  String get iconGroupFoodDrink => '餐饮';

  @override
  String get iconGroupHome => '家居';

  @override
  String get iconGroupTravel => '旅行';

  @override
  String get iconGroupSymbols => '符号';

  @override
  String get tagCategoryLabel => '分类';

  @override
  String get tagLabel => '标签';

  @override
  String get tagCategoryUncategorized => '未分类';

  @override
  String get newCategoryTitle => '新分类';

  @override
  String get shareButtonLabel => '分享';

  @override
  String get importErrorDescription => '文件导入失败！';

  @override
  String get exportErrorDescription => '文件导出失败！';

  @override
  String get deleteTitle => '删除';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' 它被用于 $count 条记录中。',
      one: ' 它被用于 1 条记录中。',
      zero: '',
    );
    return '删除「$name」？$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '其 $count 个标签也将被删除。',
      one: '其 1 个标签也将被删除。',
      zero: '',
    );
    return '删除「$name」？$_temp0';
  }

  @override
  String deleteTemplateMessage(Object name) {
    return '删除「$name」？';
  }

  @override
  String get addTagsTitle => '添加标签';

  @override
  String get addTagsSearchHint => '搜索标签…';

  @override
  String get tagPickerSortManualLabel => '手动排序';

  @override
  String get tagPickerSortUsageLabel => '按使用次数排序';

  @override
  String get tagFavoriteName => '我的最爱';

  @override
  String get tagEnergyName => '能量';

  @override
  String get tagCategoryActivitiesName => '活动';

  @override
  String get tagExerciseName => '锻炼';

  @override
  String get tagSocializingName => '社交';

  @override
  String get tagHobbyName => '爱好';

  @override
  String get tagEntertainmentName => '娱乐';

  @override
  String get tagDiningName => '用餐';

  @override
  String get tagChoresName => '家务';

  @override
  String get tagCategoryEmotionsName => '情绪';

  @override
  String get tagExcitedName => '激动';

  @override
  String get tagGratefulName => '感激';

  @override
  String get tagCalmName => '冷静';

  @override
  String get tagTiredName => '疲倦';

  @override
  String get tagAnxiousName => '焦虑';

  @override
  String get tagAnnoyedName => '懊恼';

  @override
  String get welcomeLogBodyText =>
      '## 欢迎使用 AID Diary\n\n> 每一天都值得被记住。\n\n写下发生了什么、心情如何、在哪里。日记只保存在这台设备上。\n\n- **日记**：按天列出所有日记\n- **日历**、**媒体**、**地图**：按日期、照片和地点回顾\n- **引导**：不知道写什么时，给你题目和模板\n\nAID Diary 基于 Demizo 和贡献者开发的 [Daily You](https://github.com/Demizo/Daily_You) 修改，不是 Daily You 官方应用。';

  @override
  String get settingsStorageTitle => '存储';

  @override
  String get settingsImageQuality => '图像质量';

  @override
  String get imageQualityHigh => '高';

  @override
  String get imageQualityMedium => '中';

  @override
  String get imageQualityLow => '低';

  @override
  String get imageQualityNoCompression => '无损';

  @override
  String get settingsLogFolder => '日迹存储目录';

  @override
  String get settingsImageFolder => '图片存储目录';

  @override
  String get warningTitle => '警告';

  @override
  String get logFolderWarningDescription =>
      '如果所选文件夹中已包含“daily_you.db”文件，它将被用于覆盖您现有的日迹！';

  @override
  String get errorTitle => '错误';

  @override
  String get logFolderErrorDescription => '无法更改日迹目录！';

  @override
  String get imageFolderErrorDescription => '无法更改图片目录！';

  @override
  String get backupErrorDescription => '创建备份失败！';

  @override
  String get restoreErrorDescription => '恢复备份失败！';

  @override
  String get settingsBackupRestoreTitle => '备份与恢复';

  @override
  String get settingsBackup => '备份数据';

  @override
  String get settingsRestore => '恢复数据';

  @override
  String get settingsRestorePromptDescription => '恢复备份将覆盖您现有的数据！';

  @override
  String get settingsBackupPasswordProtect => '使用密码保护备份';

  @override
  String get backupEncryptedTitle => '加密备份';

  @override
  String get backupEncryptedContent => '此备份受密码保护。';

  @override
  String get settingsAutoBackup => '自动备份';

  @override
  String get settingsAutoBackupLocation => '备份位置';

  @override
  String get settingsAutoBackupInterval => '备份间隔';

  @override
  String get settingsAutoBackupIntervalDaily => '每日';

  @override
  String get settingsAutoBackupIntervalWeekly => '每周';

  @override
  String get settingsAutoBackupIntervalMonthly => '每月';

  @override
  String get settingsAutoBackupMaxCount => '保留的备份数量';

  @override
  String get settingsAutoBackupRequireCharging => '仅在充电时';

  @override
  String settingsBackupLast(Object time) {
    return '上次备份：$time';
  }

  @override
  String get settingsBackupNever => '从未备份过';

  @override
  String settingsAutoBackupNext(Object time) {
    return '下次备份：$time';
  }

  @override
  String get settingsAutoBackupKeepAll => '全部';

  @override
  String get autoBackupFailedTitle => '备份失败';

  @override
  String tranferStatus(Object percent) {
    return '正在传输…$percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return '正在创建备份… $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return '正在恢复备份…$percent%';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return '正在加密备份… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return '正在解密备份… $percent%';
  }

  @override
  String get cleanUpStatus => '正在清理…';

  @override
  String migratingImagesStatus(Object current, Object total) {
    return '正在移动图片… $current/$total';
  }

  @override
  String get settingsExport => '导出数据';

  @override
  String get settingsExportToAnotherFormat => '导出为另一种格式';

  @override
  String get settingsExportFormatDescription => '这不应该被用作备份！';

  @override
  String get exportLogs => '导出日迹';

  @override
  String get exportImages => '导出图片';

  @override
  String get settingsImport => '导入数据';

  @override
  String get settingsImportFromAnotherApp => '从其他应用程序导入';

  @override
  String get settingsTranslateCallToAction => '每个人都应该有权使用日迹！';

  @override
  String get settingsHelpTranslate => '协助翻译';

  @override
  String get importLogs => '导入日迹';

  @override
  String get importImages => '导入图片';

  @override
  String get logFormatTitle => '选择格式';

  @override
  String get logFormatDescription =>
      '其他应用的格式可能无法支持所有功能。若遇到任何问题请及时反馈，因为第三方格式可能随时发生变化。不过这一点不会影响现有的日迹！';

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
  String get settingsDeleteAllLogsTitle => '删除全部日迹';

  @override
  String get settingsDeleteAllLogsDescription => '您确定要删除全部的日迹吗？';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return '请输入 \'$prompt\' 以确认继续删除，此操作无法撤销！';
  }

  @override
  String get settingsLanguageTitle => '语言';

  @override
  String get settingsAppLanguageTitle => '应用程序语言';

  @override
  String get settingsOverrideAppLanguageTitle => '覆盖应用程序语言';

  @override
  String get settingsSecurityTitle => '安全';

  @override
  String get settingsSecurityRequirePassword => '使用密码解锁';

  @override
  String get settingsSecurityEnterPassword => '输入密码';

  @override
  String get settingsSecuritySetPassword => '设置密码';

  @override
  String get settingsSecurityChangePassword => '更改密码';

  @override
  String get settingsSecurityPassword => '密码';

  @override
  String get settingsSecurityConfirmPassword => '确认密码';

  @override
  String get settingsSecurityOldPassword => '旧密码';

  @override
  String get settingsSecurityIncorrectPassword => '密码错误';

  @override
  String get settingsSecurityPasswordsDoNotMatch => '密码不相符';

  @override
  String get requiredPrompt => '请输入密码';

  @override
  String get settingsSecurityBiometricUnlock => '生物识别解锁';

  @override
  String get unlockAppPrompt => '解锁应用程序';

  @override
  String get settingsAboutTitle => '关于';

  @override
  String get settingsVersion => '版本';

  @override
  String get settingsLicense => '许可协议';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsSourceCode => '源代码';

  @override
  String get settingsOpenSourceLicenses => '开源许可';

  @override
  String get settingsMadeWithLove => '用❤️制作';

  @override
  String get settingsConsiderSupporting => '考虑支持';

  @override
  String get imagesTitle => '图像';

  @override
  String get tagMoodTitle => '心情';

  @override
  String get calendarTagDisplayLabel => '标签';

  @override
  String get selectTagTitle => '选择标签';

  @override
  String get labelPresentLabel => '已设定';

  @override
  String get labelAbsentLabel => '未设定';

  @override
  String get labelCoverageLabel => '覆盖率';

  @override
  String chartDistributionTitle(Object tag) {
    return '$tag 分布';
  }

  @override
  String get shareAddToLogPickerTitle => '选择日志';

  @override
  String get adaptiveEmptyDay => '这一天还没有日记';

  @override
  String get adaptiveNewEntry => '写一篇日记';

  @override
  String get pageJournalTitle => '日记';

  @override
  String get coachWritePrompt => '就写这个';

  @override
  String get coachPrompt1 => '今天有什么让你会心一笑的事？';

  @override
  String get coachPrompt2 => '今天学到了什么新东西？';

  @override
  String get coachPrompt3 => '今天和谁聊了天？感觉怎么样？';

  @override
  String get coachPrompt4 => '此刻你最感激的是什么？';

  @override
  String get coachPrompt5 => '今天什么事最耗费你的精力？';

  @override
  String get coachPrompt6 => '记下一个想留住的小瞬间。';

  @override
  String get coachPrompt7 => '怎样能让明天成为美好的一天？';

  @override
  String get coachPrompt8 => '最近心里一直在想什么？';

  @override
  String get coachPrompt9 => '今天你为自己做了什么？';

  @override
  String get coachPrompt10 => '如果给今天起个标题，会是什么？';

  @override
  String entryReadingTime(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '约 $count 分钟读完',
    );
    return '$_temp0';
  }

  @override
  String get pageMediaTitle => '媒体';

  @override
  String get pageAtlasTitle => '地图';

  @override
  String get pageCoachTitle => '引导';

  @override
  String get noEntrySelected => '未选择日记。';

  @override
  String get profileLocalOnly => '日记只保存在这台设备上';

  @override
  String get entryShare => '分享';

  @override
  String get entryFavorite => '星标';

  @override
  String get entryEdit => '编辑';

  @override
  String get entryPrevious => '上一篇';

  @override
  String get entryNext => '下一篇';

  @override
  String get journalStories => '故事';

  @override
  String get journalEntries => '日记';

  @override
  String get journalEmptyHint => '写下第一篇日记，开始记录吧。';

  @override
  String get storyToday => '今天';

  @override
  String get storyThrowback => '往昔';

  @override
  String get storyNoThrowback => '今天没有往昔';

  @override
  String get mediaFiles => '媒体文件';

  @override
  String get mediaEmpty => '还没有照片。';

  @override
  String get mediaEmptyHint => '日记里添加的照片会显示在这里。';

  @override
  String get atlasEmpty => '还没有带位置的日记。';

  @override
  String get atlasEmptyHint => '记录了位置的日记会显示在地图上。';

  @override
  String get atlasShowAll => '显示全部日记';

  @override
  String get coachAll => '全部';

  @override
  String get coachPrograms => '计划';

  @override
  String get coachTemplates => '模板';

  @override
  String get coachKindProgram => '写作计划';

  @override
  String get coachKindTemplate => '模板';

  @override
  String get coachNoTemplates => '没有计划或模板。';

  @override
  String get coachUseTemplate => '用这个模板写';

  @override
  String get coachProgramEverydayTitle => '日常小记';

  @override
  String get coachProgramEverydayDescription => '几个简单的问题，帮你留意一天里的小事。';

  @override
  String get coachProgramReflectTitle => '向内看看';

  @override
  String get coachProgramReflectDescription => '慢下来，想想自己最近的感受。';

  @override
  String get searchFilters => '筛选';

  @override
  String get searchFilterTags => '标签';

  @override
  String get searchFilterStarred => '星标';

  @override
  String get searchHint => '输入文字搜索，或选择筛选条件。';

  @override
  String get locationTitle => '位置';

  @override
  String get locationName => '地点名称';

  @override
  String get locationNoCoordinates => '没有坐标';

  @override
  String get locationUseCurrent => '使用当前位置';

  @override
  String get locationRemove => '移除';

  @override
  String get locationServiceDisabled => '定位服务已关闭。';

  @override
  String get locationPermissionDenied => '没有定位权限。';

  @override
  String get locationUnavailable => '无法获取当前位置。';

  @override
  String get calendarJumpToToday => '回到今天';

  @override
  String get editorStartWriting => '开始写，或选择一个';

  @override
  String get editorTemplateLink => '模板';

  @override
  String get editorStartWritingEnd => '。';

  @override
  String get templatePickerTitle => '选择模板';

  @override
  String get templateFeatured => '精选模板';

  @override
  String get templateMine => '我的模板';

  @override
  String get templateDailyName => '每日回顾';

  @override
  String get templateDailyDescription => '今天发生了什么、心情如何、明天做什么。';

  @override
  String get templateDailyText =>
      '## 今天发生了什么\n\n\n## 我的心情\n\n\n## 值得感激的三件事\n1. \n2. \n3. \n\n## 明天想做的事\n';

  @override
  String get templateTravelName => '旅行日志';

  @override
  String get templateTravelDescription => '记下沿途的地点、瞬间和美食。';

  @override
  String get templateTravelText =>
      '## 今天去了哪里\n\n\n## 印象最深的瞬间\n\n\n## 吃了什么\n\n\n## 明天的计划\n';

  @override
  String get templateReadingName => '读书笔记';

  @override
  String get templateReadingDescription => '摘录和读后的想法。';

  @override
  String get templateReadingText =>
      '## 书名\n\n\n## 读到哪里\n\n\n## 摘录\n> \n\n## 我的想法\n';

  @override
  String get templateWeeklyName => '一周回顾';

  @override
  String get templateWeeklyDescription => '本周亮点、困难和下周重点。';

  @override
  String get templateWeeklyText =>
      '## 本周亮点\n\n\n## 遇到的困难\n\n\n## 学到的东西\n\n\n## 下周重点\n';

  @override
  String get entryDuplicate => '复制一份';

  @override
  String get entryDuplicated => '已复制这篇日记';

  @override
  String get entrySaveAsTemplate => '存为模板';

  @override
  String get entrySavedAsTemplate => '已存为模板';

  @override
  String get storyStatistics => '统计';

  @override
  String get storyMoodChart => '心情图';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return '$entries 篇 · $days 天';
  }

  @override
  String get storyThisYear => '今年';

  @override
  String get storyLastYear => '去年';

  @override
  String get storyTapToOpen => '点一天打开当天的日记';

  @override
  String get settingsGeneralTitle => '通用';

  @override
  String get settingsDataTitle => '数据与存储';

  @override
  String get settingsStoriesTitle => '故事';

  @override
  String get settingsHelpTitle => '帮助与关于';

  @override
  String get weatherTitle => '天气';

  @override
  String get weatherClear => '晴';

  @override
  String get weatherPartlyCloudy => '多云';

  @override
  String get weatherCloudy => '阴';

  @override
  String get weatherFog => '雾';

  @override
  String get weatherDrizzle => '毛毛雨';

  @override
  String get weatherRain => '雨';

  @override
  String get weatherSnow => '雪';

  @override
  String get weatherStorm => '雷雨';

  @override
  String get weatherFetch => '获取这篇日记的天气';

  @override
  String get weatherNeedsLocation => '请先添加带坐标的位置。';

  @override
  String get weatherUnavailable => '无法获取这个地点和时间的天气。';

  @override
  String get weatherRemove => '移除天气';

  @override
  String get activityTitle => '活动';

  @override
  String get activityStill => '静止';

  @override
  String get activityWalking => '步行';

  @override
  String get activityRunning => '跑步';

  @override
  String get activityCycling => '骑行';

  @override
  String get activityVehicle => '乘车';

  @override
  String get activityFlying => '飞行';

  @override
  String get activityExercise => '运动';

  @override
  String get activityDetect => '识别当前活动';

  @override
  String get activityDetectFailed => '无法识别当前活动。';

  @override
  String get activityRemove => '移除活动';

  @override
  String get settingsAutoAddTitle => '自动添加';

  @override
  String get settingsAutoAddLocation => '位置';

  @override
  String get settingsAutoAddWeather => '天气';

  @override
  String get settingsAutoAddActivity => '活动';

  @override
  String get settingsAutoAddHint => '新建日记时自动填好这些信息。';

  @override
  String get settingsTemperatureUnit => '温度单位';

  @override
  String get settingsCelsius => '摄氏度 (°C)';

  @override
  String get settingsFahrenheit => '华氏度 (°F)';

  @override
  String get moodGreat => '很好';

  @override
  String get moodGood => '好';

  @override
  String get moodOkay => '一般';

  @override
  String get moodBad => '差';

  @override
  String get moodAwful => '很差';

  @override
  String get locationSearchHint => '搜索地点';

  @override
  String get locationSearchEmpty => '没有找到地点';

  @override
  String get settingsWallpaper => '壁纸';

  @override
  String get wallpaperNone => '无';

  @override
  String get wallpaperDots => '圆点';

  @override
  String get wallpaperGrid => '方格';

  @override
  String get wallpaperLines => '横线';

  @override
  String get wallpaperPhoto => '照片…';

  @override
  String get settingsFontFamily => '字体';

  @override
  String get fontSystem => '系统';

  @override
  String get fontSerif => '衬线';

  @override
  String get fontMono => '等宽';

  @override
  String get settingsFontSize => '字号';

  @override
  String get fontSizeSmall => '小';

  @override
  String get fontSizeMedium => '中';

  @override
  String get fontSizeLarge => '大';

  @override
  String get fontSizeExtraLarge => '特大';

  @override
  String get settingsLineSpacing => '行距';

  @override
  String get lineSpacingCompact => '紧凑';

  @override
  String get lineSpacingNormal => '标准';

  @override
  String get lineSpacingRelaxed => '宽松';

  @override
  String get moodAssociationsTitle => '什么让我感到…';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$total 篇中有 $matching 篇';
  }
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => '主題色';

  @override
  String get themeColorHint => '點選後自動關閉跟隨系統強調色，淺色和深色模式都會生效。';

  @override
  String get themeColorBlue => '天空藍';

  @override
  String get themeColorGreen => '森林綠';

  @override
  String get themeColorBrown => '暖咖棕';

  @override
  String get themeColorPurple => '薰衣紫';

  @override
  String get themeColorRose => '煙粉玫瑰';

  @override
  String get themeColorAmber => '琥珀橙';

  @override
  String get themeColorPreview => '每天，留下一點記錄';

  @override
  String get themeTintBackgroundTitle => '背景跟隨主題色';

  @override
  String get themeTintBackgroundHint => '關閉後使用中性黑灰背景，按鈕仍保留所選顏色。';

  @override
  String get dailyReminderTitle => '記錄今天！';

  @override
  String get dailyReminderDescription => '寫下我的日常紀錄…';

  @override
  String get actionTakePhoto => '拍照';

  @override
  String get actionToday => '今天';

  @override
  String get actionOtherDay => '其他天';

  @override
  String get pageHomeTitle => '主頁';

  @override
  String get jumpToMonthTitle => '跳至月份';

  @override
  String get jumpToLogTitle => '跳至紀錄';

  @override
  String get flashbacksTitle => '往日重現';

  @override
  String get settingsFlashbacksExcludeBadDays => '排除糟糕的日子';

  @override
  String get flaskbacksEmpty => '暫無回憶…';

  @override
  String get flashbackGoodDay => '美好的一天';

  @override
  String get flashbackRandomDay => '隨機的一天';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 週前',
      one: '$count 週前',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 月前',
      one: '$count 月前',
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
  String get flashbackOnThisDay => '在這一天';

  @override
  String get pageGalleryTitle => '紀錄';

  @override
  String get searchLogsHint => '搜尋紀錄…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 條紀錄',
      one: '$count 條紀錄',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 天',
      one: '$count 天',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個字',
      one: '$count 個字',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => '無紀錄…';

  @override
  String get noResults => '無結果…';

  @override
  String get sortDateTitle => '日期';

  @override
  String get sortOrderAscendingTitle => '升序';

  @override
  String get sortOrderDescendingTitle => '降序';

  @override
  String get pageStatisticsTitle => '統計';

  @override
  String get statisticsNotEnoughData => '資料不足…';

  @override
  String get statisticsRangeOneMonth => '1 個月';

  @override
  String get statisticsRangeSixMonths => '6 個月';

  @override
  String get statisticsRangeOneYear => '1 年';

  @override
  String get statisticsRangeAllTime => '所有時間';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag 概覽';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag 每日分布';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag 隨著時間的變化';
  }

  @override
  String get chartGroupingLabel => '群組';

  @override
  String get chartGroupingDay => '天';

  @override
  String get chartGroupingWeek => '週';

  @override
  String get chartGroupingMonth => '月';

  @override
  String get chartGroupingYear => '年';

  @override
  String get chartSmoothingLabel => '平滑';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '連續紀錄 $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '最長連續紀錄 $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '美好的日子 $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '距離上次糟糕的一天已過去 $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle => '無法存取外部儲存裝置';

  @override
  String get errorExternalStorageAccessDescription =>
      '如果您正在使用網路儲存空間，請確保服務在線且您有網路訪問的權限。\n\n否則，應用程式可能已失去對外部資料夾的權限，請前往設定並重新選擇外部資料夾以授權。\n\n警告：在恢復對外部存儲位置的訪問權限之前，任何更改將不會同步！';

  @override
  String get errorExternalStorageAccessContinue => '繼續使用本地資料庫';

  @override
  String get databaseMigrationErrorTitle => '無法移動你的資料';

  @override
  String get databaseMigrationErrorDescription =>
      '您的條目是安全的，但無法移至應用程式的儲存空間。\n\n請再試一次，如果問題持續發生，請回報該問題。';

  @override
  String get databaseMigrationErrorRetry => '重試';

  @override
  String get errorReport => '報告問題';

  @override
  String get lastModified => '已修改';

  @override
  String get writeSomethingHint => '寫點什麼…';

  @override
  String get titleHint => '標題…';

  @override
  String get deleteLogTitle => '刪除紀錄';

  @override
  String get deleteLogDescription => '您要刪除此紀錄嗎？';

  @override
  String get deletePhotoTitle => '刪除照片';

  @override
  String get deletePhotoDescription => '您要刪除此照片嗎？';

  @override
  String get pageSettingsTitle => '設定';

  @override
  String get settingsAppearanceTitle => '外觀';

  @override
  String get settingsTheme => '主題';

  @override
  String get themeSystem => '系統';

  @override
  String get themeLight => '淺色';

  @override
  String get themeDark => '深色';

  @override
  String get themeAmoled => '純黑';

  @override
  String get settingsFirstDayOfWeek => '一週的起始日';

  @override
  String get settingsCalendarSystem => '曆法系統';

  @override
  String get calendarSystemGregorian => '公曆';

  @override
  String get calendarSystemJalali => '波斯曆';

  @override
  String get settingsUseSystemAccentColor => '使用系統強調色';

  @override
  String get settingsCustomAccentColor => '自訂強調色';

  @override
  String get settingsShowMarkdownToolbar => '顯示 Markdown 工具列';

  @override
  String get settingsShowFlashbacks => '顯示往日重現';

  @override
  String get settingsChangeMoodIcons => '更改心情圖示';

  @override
  String get moodIconPrompt => '輸入圖示';

  @override
  String get settingsFlashbacksViewLayout => '往日重現檢視佈局';

  @override
  String get settingsHideImagesInGallery => '隱藏紀錄頁中的圖片';

  @override
  String get settingsHideImages => '隱藏圖片';

  @override
  String get pageCalendarTitle => '月曆';

  @override
  String get settingsNotificationsTitle => '通知';

  @override
  String get settingsDailyReminderOnboarding => '開啟每日提醒，助你持之以恆！';

  @override
  String get settingsNotificationsPermissionsPrompt =>
      '為了在隨機或您設定的時間發送提醒，系統將請求「排程鬧鐘」權限。';

  @override
  String get settingsDailyReminderTitle => '每日提醒';

  @override
  String get settingsOnThisDayDescription => '重溫過去的回憶';

  @override
  String get settingsDailyReminderDescription => '每日的溫馨提醒';

  @override
  String get settingsReminderTime => '提醒時間';

  @override
  String get settingsFixedReminderTimeTitle => '固定提醒時間';

  @override
  String get settingsFixedReminderTimeDescription => '選擇一個固定的時間來設置提醒';

  @override
  String get settingsAlwaysSendReminderTitle => '總是發送提醒';

  @override
  String get settingsAlwaysSendReminderDescription => '即使日記已經開始，仍需發送提醒';

  @override
  String get settingsCustomizeNotificationTitle => '自訂通知';

  @override
  String get settingsTemplatesTitle => '模板';

  @override
  String get settingsDefaultTemplate => '預設模板';

  @override
  String get manageTemplates => '管理模板';

  @override
  String get addTemplate => '新增模板';

  @override
  String get newTemplate => '新增模板';

  @override
  String get noTemplateTitle => '無';

  @override
  String get noTemplatesDescription => '尚未建立模板…';

  @override
  String get templateVariableTime => '時間';

  @override
  String get templateDefaultTimestampTitle => '時間戳記';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => '每日摘要';

  @override
  String get templateDefaultSummaryBody => '### 摘要\n- \n\n### 引用\n> ';

  @override
  String get templateDefaultReflectionTitle => '反思';

  @override
  String get templateDefaultReflectionBody =>
      '### 你今天最開心的是什麼？\n- \n\n### 你感恩什麼？\n- \n\n### 你最期待什麼？\n- ';

  @override
  String get settingsTagsTitle => '標籤';

  @override
  String get manageTags => '管理標籤';

  @override
  String get tagTypeLabelTitle => '標籤';

  @override
  String get tagTypeTrackerTitle => '追蹤器';

  @override
  String get nameHint => '名稱';

  @override
  String get tagColorLabel => '顏色';

  @override
  String get iconPickerTitle => '選擇圖示';

  @override
  String get iconPickerIconsTab => '圖示';

  @override
  String get iconPickerCustomTab => '自訂';

  @override
  String get iconPickerSearchHint => '搜尋圖示…';

  @override
  String get colorPickerTitle => '選擇顏色';

  @override
  String get colorPickerPaletteTab => '顏色';

  @override
  String get iconGroupMoodPeople => '心情與人物';

  @override
  String get iconGroupHealth => '健康';

  @override
  String get iconGroupWorkFinance => '工作&金融';

  @override
  String get iconGroupHabitsGoals => '習慣&目標';

  @override
  String get iconGroupNature => '自然';

  @override
  String get iconGroupFoodDrink => '餐飲';

  @override
  String get iconGroupHome => '家';

  @override
  String get iconGroupTravel => '旅行';

  @override
  String get iconGroupSymbols => '符號';

  @override
  String get tagCategoryLabel => '分類';

  @override
  String get tagLabel => '標籤';

  @override
  String get tagCategoryUncategorized => '未分類';

  @override
  String get newCategoryTitle => '新分類';

  @override
  String get shareButtonLabel => '分享';

  @override
  String get importErrorDescription => '檔案匯入失敗！';

  @override
  String get exportErrorDescription => '檔案匯出失敗！';

  @override
  String get deleteTitle => '刪除';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' 它被用於 $count 條紀錄中。',
      one: ' 它被用於 1 條紀錄中。',
      zero: '',
    );
    return '刪除「$name」？$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '其 $count 個標籤也將被刪除。',
      one: '其 1 個標籤也將被刪除。',
      zero: '',
    );
    return '刪除「$name」？$_temp0';
  }

  @override
  String deleteTemplateMessage(Object name) {
    return '刪除「$name」？';
  }

  @override
  String get addTagsTitle => '新增標籤';

  @override
  String get addTagsSearchHint => '搜尋標籤…';

  @override
  String get tagPickerSortManualLabel => '手動排序';

  @override
  String get tagPickerSortUsageLabel => '依使用次數排序';

  @override
  String get tagFavoriteName => '我的最愛';

  @override
  String get tagEnergyName => '能量';

  @override
  String get tagCategoryActivitiesName => '活動';

  @override
  String get tagExerciseName => '鍛煉';

  @override
  String get tagSocializingName => '社交';

  @override
  String get tagHobbyName => '愛好';

  @override
  String get tagEntertainmentName => '娛樂';

  @override
  String get tagDiningName => '用餐';

  @override
  String get tagChoresName => '家務';

  @override
  String get tagCategoryEmotionsName => '情緒';

  @override
  String get tagExcitedName => '激動';

  @override
  String get tagGratefulName => '感激';

  @override
  String get tagCalmName => '冷靜';

  @override
  String get tagTiredName => '疲倦';

  @override
  String get tagAnxiousName => '焦慮';

  @override
  String get tagAnnoyedName => '懊惱';

  @override
  String get welcomeLogBodyText =>
      '## 歡迎使用 AID Diary\n\n> 每一天都值得被記住。\n\n寫下發生了什麼、心情如何、在哪裡。日記只保存在這台裝置上。\n\n- **日記**：按天列出所有日記\n- **日曆**、**媒體**、**地圖**：按日期、照片和地點回顧\n- **引導**：不知道寫什麼時，給你題目和範本\n\nAID Diary 基於 Demizo 和貢獻者開發的 [Daily You](https://github.com/Demizo/Daily_You) 修改，不是 Daily You 官方應用。';

  @override
  String get settingsStorageTitle => '存儲';

  @override
  String get settingsImageQuality => '影像品質';

  @override
  String get imageQualityHigh => '高';

  @override
  String get imageQualityMedium => '中';

  @override
  String get imageQualityLow => '低';

  @override
  String get imageQualityNoCompression => '不壓縮';

  @override
  String get settingsLogFolder => '紀錄資料夾';

  @override
  String get settingsImageFolder => '影像資料夾';

  @override
  String get warningTitle => '警告';

  @override
  String get logFolderWarningDescription =>
      '如果選定的資料夾中已經包含一個 \'daily_you.db\' 文件，它將覆蓋您現有的紀錄！';

  @override
  String get errorTitle => '錯誤';

  @override
  String get logFolderErrorDescription => '更改紀錄資料夾失敗！';

  @override
  String get imageFolderErrorDescription => '更改影像資料夾失敗！';

  @override
  String get backupErrorDescription => '備份建立失敗！';

  @override
  String get restoreErrorDescription => '備份還原失敗！';

  @override
  String get settingsBackupRestoreTitle => '備份與還原';

  @override
  String get settingsBackup => '備份';

  @override
  String get settingsRestore => '還原';

  @override
  String get settingsRestorePromptDescription => '還原備份將覆蓋您現有的資料！';

  @override
  String get settingsBackupPasswordProtect => '密碼保護備份';

  @override
  String get backupEncryptedTitle => '加密備份';

  @override
  String get backupEncryptedContent => '此備份受密碼保護。';

  @override
  String get settingsAutoBackup => '自動備份';

  @override
  String get settingsAutoBackupLocation => '備份位置';

  @override
  String get settingsAutoBackupInterval => '備份間隔';

  @override
  String get settingsAutoBackupIntervalDaily => '每日';

  @override
  String get settingsAutoBackupIntervalWeekly => '每週';

  @override
  String get settingsAutoBackupIntervalMonthly => '每月';

  @override
  String get settingsAutoBackupMaxCount => '要保留的備份';

  @override
  String get settingsAutoBackupRequireCharging => '僅在充電時';

  @override
  String settingsBackupLast(Object time) {
    return '上次備份 $time';
  }

  @override
  String get settingsBackupNever => '從未備份過';

  @override
  String settingsAutoBackupNext(Object time) {
    return '下次備份 $time';
  }

  @override
  String get settingsAutoBackupKeepAll => '全部';

  @override
  String get autoBackupFailedTitle => '備份失敗';

  @override
  String tranferStatus(Object percent) {
    return '正在轉移… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return '正在建立備份… $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return '正在還原備份… $percent%';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return '正在加密備份… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return '正在解密備份… $percent%';
  }

  @override
  String get cleanUpStatus => '正在清理…';

  @override
  String migratingImagesStatus(Object current, Object total) {
    return '正在移轉照片… $current/$total';
  }

  @override
  String get settingsExport => '匯出';

  @override
  String get settingsExportToAnotherFormat => '匯出為其他格式';

  @override
  String get settingsExportFormatDescription => '這不應該被用來備份！';

  @override
  String get exportLogs => '匯出紀錄';

  @override
  String get exportImages => '匯出影像';

  @override
  String get settingsImport => '匯入';

  @override
  String get settingsImportFromAnotherApp => '從其他應用程式匯入';

  @override
  String get settingsTranslateCallToAction => '每個人都應該有權使用日記！';

  @override
  String get settingsHelpTranslate => '協助翻譯';

  @override
  String get importLogs => '匯入紀錄';

  @override
  String get importImages => '匯入影像';

  @override
  String get logFormatTitle => '選擇格式';

  @override
  String get logFormatDescription =>
      '其他應用程式的格式可能不支援所有功能，且第三方格式可能隨時發生變化，發現任何問題請向我們回報。這並不會影響現有日誌！';

  @override
  String get formatDiaro => 'Diaro';

  @override
  String get formatOneShot => 'OneShot';

  @override
  String get formatMarkdown => 'Markdown';

  @override
  String get settingsDeleteAllLogsTitle => '刪除所有紀錄';

  @override
  String get settingsDeleteAllLogsDescription => '您要刪除所有紀錄嗎？';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return '輸入「\'$prompt\'」以確認，此操作無法撤銷！';
  }

  @override
  String get settingsLanguageTitle => '語言';

  @override
  String get settingsAppLanguageTitle => '應用程式語言';

  @override
  String get settingsOverrideAppLanguageTitle => '覆寫應用程式語言';

  @override
  String get settingsSecurityTitle => '安全';

  @override
  String get settingsSecurityRequirePassword => '使用密碼解鎖';

  @override
  String get settingsSecurityEnterPassword => '輸入密碼';

  @override
  String get settingsSecuritySetPassword => '設定密碼';

  @override
  String get settingsSecurityChangePassword => '更換密碼';

  @override
  String get settingsSecurityPassword => '密碼';

  @override
  String get settingsSecurityConfirmPassword => '確認密碼';

  @override
  String get settingsSecurityOldPassword => '舊密碼';

  @override
  String get settingsSecurityIncorrectPassword => '密碼錯誤';

  @override
  String get settingsSecurityPasswordsDoNotMatch => '密碼不相符';

  @override
  String get requiredPrompt => '必填';

  @override
  String get settingsSecurityBiometricUnlock => '生物辨識解鎖';

  @override
  String get unlockAppPrompt => '解鎖應用程式';

  @override
  String get settingsAboutTitle => '關於';

  @override
  String get settingsVersion => '版本';

  @override
  String get settingsLicense => '授權';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsSourceCode => '原始碼';

  @override
  String get settingsOpenSourceLicenses => '開源授權條款';

  @override
  String get settingsMadeWithLove => '用❤️製作';

  @override
  String get settingsConsiderSupporting => '考慮支持';

  @override
  String get imagesTitle => '影像';

  @override
  String get tagMoodTitle => '心情';

  @override
  String get calendarTagDisplayLabel => '標籤';

  @override
  String get selectTagTitle => '選擇標籤';

  @override
  String get labelPresentLabel => '已設定';

  @override
  String get labelAbsentLabel => '未設定';

  @override
  String get labelCoverageLabel => '覆蓋率';

  @override
  String chartDistributionTitle(Object tag) {
    return '$tag 分佈';
  }

  @override
  String get shareAddToLogPickerTitle => '選擇一個紀錄';

  @override
  String get adaptiveEmptyDay => '這一天還沒有日記';

  @override
  String get adaptiveNewEntry => '寫一篇日記';

  @override
  String get pageJournalTitle => '日記';

  @override
  String get coachWritePrompt => '就寫這個';

  @override
  String get coachPrompt1 => '今天有什麼讓你會心一笑的事？';

  @override
  String get coachPrompt2 => '今天學到了什麼新東西？';

  @override
  String get coachPrompt3 => '今天和誰聊了天？感覺怎麼樣？';

  @override
  String get coachPrompt4 => '此刻你最感激的是什麼？';

  @override
  String get coachPrompt5 => '今天什麼事最耗費你的精力？';

  @override
  String get coachPrompt6 => '記下一個想留住的小瞬間。';

  @override
  String get coachPrompt7 => '怎樣能讓明天成為美好的一天？';

  @override
  String get coachPrompt8 => '最近心裡一直在想什麼？';

  @override
  String get coachPrompt9 => '今天你為自己做了什麼？';

  @override
  String get coachPrompt10 => '如果給今天起個標題，會是什麼？';

  @override
  String entryReadingTime(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '約 $count 分鐘讀完',
    );
    return '$_temp0';
  }

  @override
  String get pageMediaTitle => '媒體';

  @override
  String get pageAtlasTitle => '地圖';

  @override
  String get pageCoachTitle => '引導';

  @override
  String get noEntrySelected => '未選擇日記。';

  @override
  String get profileLocalOnly => '日記只保存在這台裝置上';

  @override
  String get entryShare => '分享';

  @override
  String get entryFavorite => '星號';

  @override
  String get entryEdit => '編輯';

  @override
  String get entryPrevious => '上一篇';

  @override
  String get entryNext => '下一篇';

  @override
  String get journalStories => '故事';

  @override
  String get journalEntries => '日記';

  @override
  String get journalEmptyHint => '寫下第一篇日記，開始記錄吧。';

  @override
  String get storyToday => '今天';

  @override
  String get storyThrowback => '往昔';

  @override
  String get storyNoThrowback => '今天沒有往昔';

  @override
  String get mediaFiles => '媒體檔案';

  @override
  String get mediaEmpty => '還沒有照片。';

  @override
  String get mediaEmptyHint => '日記裡加入的照片會顯示在這裡。';

  @override
  String get atlasEmpty => '還沒有帶位置的日記。';

  @override
  String get atlasEmptyHint => '記錄了位置的日記會顯示在地圖上。';

  @override
  String get atlasShowAll => '顯示全部日記';

  @override
  String get coachAll => '全部';

  @override
  String get coachPrograms => '計畫';

  @override
  String get coachTemplates => '範本';

  @override
  String get coachKindProgram => '寫作計畫';

  @override
  String get coachKindTemplate => '範本';

  @override
  String get coachNoTemplates => '沒有計畫或範本。';

  @override
  String get coachUseTemplate => '用這個範本寫';

  @override
  String get coachProgramEverydayTitle => '日常小記';

  @override
  String get coachProgramEverydayDescription => '幾個簡單的問題，幫你留意一天裡的小事。';

  @override
  String get coachProgramReflectTitle => '向內看看';

  @override
  String get coachProgramReflectDescription => '慢下來，想想自己最近的感受。';

  @override
  String get searchFilters => '篩選';

  @override
  String get searchFilterTags => '標籤';

  @override
  String get searchFilterStarred => '星號';

  @override
  String get searchHint => '輸入文字搜尋，或選擇篩選條件。';

  @override
  String get locationTitle => '位置';

  @override
  String get locationName => '地點名稱';

  @override
  String get locationNoCoordinates => '沒有座標';

  @override
  String get locationUseCurrent => '使用目前位置';

  @override
  String get locationRemove => '移除';

  @override
  String get locationServiceDisabled => '定位服務已關閉。';

  @override
  String get locationPermissionDenied => '沒有定位權限。';

  @override
  String get locationUnavailable => '無法取得目前位置。';

  @override
  String get calendarJumpToToday => '回到今天';

  @override
  String get editorStartWriting => '開始寫，或選擇一個';

  @override
  String get editorTemplateLink => '範本';

  @override
  String get editorStartWritingEnd => '。';

  @override
  String get templatePickerTitle => '選擇範本';

  @override
  String get templateFeatured => '精選範本';

  @override
  String get templateMine => '我的範本';

  @override
  String get templateDailyName => '每日回顧';

  @override
  String get templateDailyDescription => '今天發生了什麼、心情如何、明天做什麼。';

  @override
  String get templateDailyText =>
      '## 今天發生了什麼\n\n\n## 我的心情\n\n\n## 值得感激的三件事\n1. \n2. \n3. \n\n## 明天想做的事\n';

  @override
  String get templateTravelName => '旅行日誌';

  @override
  String get templateTravelDescription => '記下沿途的地點、瞬間和美食。';

  @override
  String get templateTravelText =>
      '## 今天去了哪裡\n\n\n## 印象最深的瞬間\n\n\n## 吃了什麼\n\n\n## 明天的計畫\n';

  @override
  String get templateReadingName => '讀書筆記';

  @override
  String get templateReadingDescription => '摘錄和讀後的想法。';

  @override
  String get templateReadingText =>
      '## 書名\n\n\n## 讀到哪裡\n\n\n## 摘錄\n> \n\n## 我的想法\n';

  @override
  String get templateWeeklyName => '一週回顧';

  @override
  String get templateWeeklyDescription => '本週亮點、困難和下週重點。';

  @override
  String get templateWeeklyText =>
      '## 本週亮點\n\n\n## 遇到的困難\n\n\n## 學到的東西\n\n\n## 下週重點\n';

  @override
  String get entryDuplicate => '複製一份';

  @override
  String get entryDuplicated => '已複製這篇日記';

  @override
  String get entrySaveAsTemplate => '存為範本';

  @override
  String get entrySavedAsTemplate => '已存為範本';

  @override
  String get storyStatistics => '統計';

  @override
  String get storyMoodChart => '心情圖';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return '$entries 篇 · $days 天';
  }

  @override
  String get storyThisYear => '今年';

  @override
  String get storyLastYear => '去年';

  @override
  String get storyTapToOpen => '點一天打開當天的日記';

  @override
  String get settingsGeneralTitle => '一般';

  @override
  String get settingsDataTitle => '資料與儲存';

  @override
  String get settingsStoriesTitle => '故事';

  @override
  String get settingsHelpTitle => '說明與關於';

  @override
  String get weatherTitle => '天氣';

  @override
  String get weatherClear => '晴';

  @override
  String get weatherPartlyCloudy => '多雲';

  @override
  String get weatherCloudy => '陰';

  @override
  String get weatherFog => '霧';

  @override
  String get weatherDrizzle => '毛毛雨';

  @override
  String get weatherRain => '雨';

  @override
  String get weatherSnow => '雪';

  @override
  String get weatherStorm => '雷雨';

  @override
  String get weatherFetch => '取得這篇日記的天氣';

  @override
  String get weatherNeedsLocation => '請先加入帶座標的位置。';

  @override
  String get weatherUnavailable => '無法取得這個地點和時間的天氣。';

  @override
  String get weatherRemove => '移除天氣';

  @override
  String get activityTitle => '活動';

  @override
  String get activityStill => '靜止';

  @override
  String get activityWalking => '步行';

  @override
  String get activityRunning => '跑步';

  @override
  String get activityCycling => '騎行';

  @override
  String get activityVehicle => '乘車';

  @override
  String get activityFlying => '飛行';

  @override
  String get activityExercise => '運動';

  @override
  String get activityDetect => '辨識目前活動';

  @override
  String get activityDetectFailed => '無法辨識目前活動。';

  @override
  String get activityRemove => '移除活動';

  @override
  String get settingsAutoAddTitle => '自動加入';

  @override
  String get settingsAutoAddLocation => '位置';

  @override
  String get settingsAutoAddWeather => '天氣';

  @override
  String get settingsAutoAddActivity => '活動';

  @override
  String get settingsAutoAddHint => '新增日記時自動填好這些資訊。';

  @override
  String get settingsTemperatureUnit => '溫度單位';

  @override
  String get settingsCelsius => '攝氏度 (°C)';

  @override
  String get settingsFahrenheit => '華氏度 (°F)';

  @override
  String get moodGreat => '很好';

  @override
  String get moodGood => '好';

  @override
  String get moodOkay => '一般';

  @override
  String get moodBad => '差';

  @override
  String get moodAwful => '很差';

  @override
  String get locationSearchHint => '搜尋地點';

  @override
  String get locationSearchEmpty => '沒有找到地點';

  @override
  String get settingsWallpaper => '桌布';

  @override
  String get wallpaperNone => '無';

  @override
  String get wallpaperDots => '圓點';

  @override
  String get wallpaperGrid => '方格';

  @override
  String get wallpaperLines => '橫線';

  @override
  String get wallpaperPhoto => '照片…';

  @override
  String get settingsFontFamily => '字型';

  @override
  String get fontSystem => '系統';

  @override
  String get fontSerif => '襯線';

  @override
  String get fontMono => '等寬';

  @override
  String get settingsFontSize => '字級';

  @override
  String get fontSizeSmall => '小';

  @override
  String get fontSizeMedium => '中';

  @override
  String get fontSizeLarge => '大';

  @override
  String get fontSizeExtraLarge => '特大';

  @override
  String get settingsLineSpacing => '行距';

  @override
  String get lineSpacingCompact => '緊湊';

  @override
  String get lineSpacingNormal => '標準';

  @override
  String get lineSpacingRelaxed => '寬鬆';

  @override
  String get moodAssociationsTitle => '什麼讓我感到…';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$total 篇中有 $matching 篇';
  }
}
