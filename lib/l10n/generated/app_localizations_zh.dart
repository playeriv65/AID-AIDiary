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
  String get dailyReminderTitle => '记得留下今日日记！';

  @override
  String get dailyReminderDescription => '今天的日记还没写呢…';

  @override
  String get actionTakePhoto => '拍张照';

  @override
  String get flashbacksTitle => '往昔重现';

  @override
  String get settingsFlashbacksExcludeBadDays => '排除糟糕的日子';

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
  String get searchLogsHint => '搜索日记…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '日记 $count',
      one: '日记 $count',
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
  String get noLogs => '暂无日记…';

  @override
  String get noResults => '无结果…';

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
  String get lastModified => '最后修改时间';

  @override
  String get writeSomethingHint => '写点什么…';

  @override
  String get titleHint => '标题…';

  @override
  String get deleteLogTitle => '删除日记';

  @override
  String get deleteLogDescription => '删除后会移到「最近删除」，在那里可以恢复。';

  @override
  String get deletePhotoTitle => '删除附件';

  @override
  String get deletePhotoDescription => '确定要删除这个附件吗？';

  @override
  String get pageSettingsTitle => '设置';

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
  String get settingsShowFlashbacks => '显示往昔重现';

  @override
  String get settingsChangeMoodIcons => '更改心情图标';

  @override
  String get moodIconPrompt => '输入一个图标';

  @override
  String get settingsHideImages => '隐藏图片';

  @override
  String get pageCalendarTitle => '日历';

  @override
  String get settingsNotificationsTitle => '通知';

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
  String get manageTemplates => '管理模板';

  @override
  String get noTemplateTitle => '无';

  @override
  String get noTemplatesDescription => '尚未创建任何模板…';

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
      '## 欢迎使用 AID Diary\n\n> 一个安静记录日子的地方。\n\n写下发生了什么、心情如何、在哪里。日记只保存在这台设备上。\n\n- **日记**：按天列出所有日记\n- **日历**、**媒体**、**地图**：按日期、照片和地点回顾\n- **引导**：不知道写什么时，给你问题和模板';

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
  String get settingsLogFolder => '日记存储目录';

  @override
  String get settingsImageFolder => '图片存储目录';

  @override
  String get warningTitle => '警告';

  @override
  String get logFolderWarningDescription =>
      '如果所选文件夹中已包含“aid_diary.db”文件，它将被用于覆盖您现有的日记！';

  @override
  String get errorTitle => '错误';

  @override
  String get logFolderErrorDescription => '无法更改日记目录！';

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
  String get settingsExportToAnotherFormat => '导出为另一种格式';

  @override
  String get settingsExportFormatDescription => '这不应该被用作备份！';

  @override
  String get settingsImportFromAnotherApp => '从其他应用程序导入';

  @override
  String get logFormatTitle => '选择格式';

  @override
  String get logFormatDescription =>
      '其他应用的格式可能无法支持所有功能。若遇到任何问题请及时反馈，因为第三方格式可能随时发生变化。不过这一点不会影响现有的日记！';

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
  String get formatOneShot => 'OneShot';

  @override
  String get formatPixels => 'Pixels';

  @override
  String get formatMarkdown => 'Markdown';

  @override
  String get settingsDeleteAllLogsTitle => '删除全部日记';

  @override
  String get settingsDeleteAllLogsDescription => '您确定要删除全部的日记吗？';

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
  String get settingsOpenSourceLicenses => '开源许可';

  @override
  String get tagMoodTitle => '心情';

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
  String get atlasMyLocation => '我的位置';

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
  String get coachProgramEverydayDescription =>
      '五个简单的问题，每天一个。每个只要一两分钟，帮你看见这一天里属于你的东西。想养成每天写一点的习惯，可以从这里开始。';

  @override
  String get coachProgramReflectTitle => '向内看看';

  @override
  String get coachProgramReflectDescription =>
      '五周，每周一个更深一点的问题。每个都不用急：最近的感受、什么在消耗你、你感激什么。';

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

  @override
  String get videoRecord => '录制视频';

  @override
  String get videoChoose => '选择视频';

  @override
  String get audioRecordTitle => '录制语音';

  @override
  String get audioChoose => '选择音频文件';

  @override
  String get audioStart => '录音';

  @override
  String get audioStop => '停止并保存';

  @override
  String get audioPermissionDenied => '麦克风权限已关闭，请在系统设置中允许。';

  @override
  String get mediaTooLarge => '这个视频太大，无法添加。';

  @override
  String get mediaUnavailable => '此附件在这台设备上不可用。';

  @override
  String get widgetDone => '今天的日记已写好';

  @override
  String get widgetPending => '今天过得怎么样？';

  @override
  String get widgetWrite => '写日记';

  @override
  String get insertChecklist => '待办清单';

  @override
  String get insertNumberedList => '编号列表';

  @override
  String get insertTable => '表格';

  @override
  String get insertDivider => '分割线';

  @override
  String get insertCodeBlock => '代码块';

  @override
  String get journalSortTitle => '日记排序';

  @override
  String get journalSortUpdated => '最近修改';

  @override
  String get settingsTimeFormat => '时间格式';

  @override
  String get settingsDayStart => '新日记在几点前算前一天';

  @override
  String get settingsDayAskUntil => '之后到几点前询问算哪天';

  @override
  String get settingsDayStartMidnight => '不使用';

  @override
  String settingsDayStartAt(int hour) {
    return '凌晨 $hour 点';
  }

  @override
  String get settingsDayStartHint =>
      '每篇日记都会同时保存实际写作时间和它所属的日记日，日记日可以随时在编辑页修改。这两个时间只决定新日记默认算哪天，修改它们不会改动已有的任何日记。';

  @override
  String get lateNightBadge => '凌晨写的，算作前一天';

  @override
  String editorDayAsk(String time) {
    return '$time 写的，算哪一天？';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date（昨天）';
  }

  @override
  String editorDayToday(String date) {
    return '$date（今天）';
  }

  @override
  String editorWrittenAt(String when) {
    return '写于 $when';
  }

  @override
  String get timeFormat12 => '12 小时制';

  @override
  String get timeFormat24 => '24 小时制';

  @override
  String get settingsReminderDays => '提醒日';

  @override
  String get locationRecent => '最近的地点';

  @override
  String get shareImage => '分享图片';

  @override
  String get shareSaveImage => '保存图片';

  @override
  String get shareSaved => '图片已保存';

  @override
  String get deletedTitle => '最近删除';

  @override
  String get deletedNone => '没有最近删除的日记';

  @override
  String deletedHint(int days) {
    return '删除的日记会在这里保留 $days 天，之后彻底清除。';
  }

  @override
  String deletedDaysLeft(int days) {
    return '还剩 $days 天';
  }

  @override
  String get deletedRestore => '恢复';

  @override
  String get deletedDeleteForever => '彻底删除';

  @override
  String get deletedDeleteForeverDescription => '这篇日记和它的附件会被清除，无法撤销。';

  @override
  String get deletedEmpty => '清空';

  @override
  String get deletedEmptyDescription => '清除「最近删除」里的全部日记？无法撤销。';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => '随机漫步';

  @override
  String get randomSubtitle => '翻开一篇旧日记';

  @override
  String get randomNext => '换一篇';

  @override
  String get randomAll => '全部';

  @override
  String get randomWithPhotos => '有照片';

  @override
  String get randomGoodDays => '开心的日子';

  @override
  String get randomEmpty => '没有可以抽的日记';

  @override
  String get reviewWeekTitle => '本周回顾';

  @override
  String get reviewWeekSubtitle => '这一周写了什么';

  @override
  String get reviewYearTitle => '年度回顾';

  @override
  String get reviewEmpty => '还没有写日记';

  @override
  String get reviewEntries => '篇日记';

  @override
  String get reviewDaysWritten => '写日记的天数';

  @override
  String get reviewWords => '字数';

  @override
  String get reviewPhotos => '照片';

  @override
  String get reviewLongestRun => '最长连续天数';

  @override
  String get reviewAverageMood => '平均心情';

  @override
  String get reviewFavorites => '最常出现';

  @override
  String get reviewByMonth => '每月篇数';

  @override
  String get reviewHighlight => '精选一篇';

  @override
  String get yearInPixels => '心情像素';

  @override
  String get capsuleSeal => '设为时间胶囊';

  @override
  String get capsuleTitle => '时间胶囊';

  @override
  String capsuleOpensOn(Object date) {
    return '$date 开启';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return '写于 $date';
  }

  @override
  String get capsuleOpenEarly => '提前打开';

  @override
  String get capsuleOpenEarlyDescription => '胶囊会立即打开，并且不再封存。';

  @override
  String get capsuleOpened => '时间胶囊已开启';

  @override
  String get templateMorningName => '早间日记';

  @override
  String get templateMorningDescription => '三分钟安排好今天';

  @override
  String get templateMorningText =>
      '## 今天最想做好的三件事\n1. \n2. \n3. \n\n## 今天期待的一件事\n\n## 想对自己说的一句话\n';

  @override
  String get templateEveningName => '晚间回顾';

  @override
  String get templateEveningDescription => '用三件好事收尾一天';

  @override
  String get templateEveningText =>
      '## 今天的三件好事\n1. \n2. \n3. \n\n## 今天学到了什么\n\n## 明天可以做得更好的地方\n';

  @override
  String get routineMorning => '早上好';

  @override
  String get routineEvening => '晚间回顾';

  @override
  String get settingsRoutinePrompts => '早晚日记提示';

  @override
  String get settingsRoutinePromptsHint => '在故事里按时段推荐早间或晚间模板';

  @override
  String get checkInTitle => '快速记录';

  @override
  String get checkInSubtitle => '两下记下心情';

  @override
  String get checkInMood => '现在心情如何？';

  @override
  String get checkInActivity => '在做什么？';

  @override
  String get checkInNote => '写一句（可选）';

  @override
  String get checkInSave => '记下';

  @override
  String editorWordCount(int words, int characters) {
    return '$words 字 · $characters 个字符';
  }

  @override
  String get coachProgramEverydayTagline => '留意一天里的小事。';

  @override
  String get coachProgramReflectTagline => '慢下来，听听自己。';

  @override
  String get coachDuration => '时长';

  @override
  String get coachInterval => '频率';

  @override
  String get coachDifficulty => '难度';

  @override
  String get coachIntervalDaily => '每天';

  @override
  String get coachIntervalWeekly => '每周';

  @override
  String get coachDifficultyBeginner => '入门';

  @override
  String get coachDifficultyIntermediate => '进阶';

  @override
  String coachDurationDays(int count) {
    return '$count 天';
  }

  @override
  String coachDurationWeeks(int count) {
    return '$count 周';
  }

  @override
  String coachDayN(int n) {
    return '第 $n 天';
  }

  @override
  String coachWeekN(int n) {
    return '第 $n 周';
  }

  @override
  String get coachEnroll => '参加';

  @override
  String get coachEndProgram => '结束计划';

  @override
  String get coachAuthor => '作者';

  @override
  String get coachAuthorBio => '为这个应用编写的写作问题。';

  @override
  String get coachEnrolledTip => '好了！之后的问题会出现在“故事”里。';

  @override
  String get coachGoToStories => '去看故事';

  @override
  String get coachAnswerHint => '写下你的回答……';

  @override
  String get storyWrapUp => '今天就到这里。';

  @override
  String get storyTapToClose => '点一下关闭';

  @override
  String get coachAnswerDone => '完成';

  @override
  String get coachAnswered => '已写进日记，点一下打开';

  @override
  String get coachAnsweredEarlier => '已回答';

  @override
  String get locationLocating => '正在定位…';

  @override
  String get locationPickPlace => '选择地点';

  @override
  String get locationPlacesHint => '地址或地点名称';

  @override
  String get locationCustom => '自定义地点';

  @override
  String get locationCurrent => '当前位置';

  @override
  String get locationSaved => '收藏的地点';

  @override
  String get locationSearchResults => '搜索结果';

  @override
  String get locationNearby => '附近的地点';

  @override
  String get locationRename => '重命名';

  @override
  String get locationSavePlace => '收藏地点';

  @override
  String get locationUnsavePlace => '取消收藏';

  @override
  String get shareAs => '分享为…';

  @override
  String get shareAsImage => '图片';

  @override
  String get shareAsZip => 'ZIP（含原始照片和音视频）';

  @override
  String get shareAsPlainText => '纯文本';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => '欢迎使用 AID Diary';

  @override
  String get onboardWelcomeText => '一个安静记录日子的地方。点“下一步”看看。';

  @override
  String get onboardIntroTitle => '写一点，记住很多';

  @override
  String get onboardIntroText => '照片、地点、天气和心情都和文字放在一起，“故事”会把过去的日子带回来。';

  @override
  String get onboardPrivateTitle => '安全又私密';

  @override
  String get onboardPrivateText => '日记只保存在这台设备上。加一个密码，只给自己看。';

  @override
  String get onboardPrivateAction => '设置密码';

  @override
  String get onboardNotifyTitle => '温柔的提醒';

  @override
  String get onboardNotifyText => '打开提醒，慢慢养成习惯；参加写作计划后，新问题到了也会告诉你。';

  @override
  String get onboardNotifyAction => '打开提醒';

  @override
  String get onboardNotifyOn => '提醒已打开';

  @override
  String get onboardDoneTitle => '准备好了';

  @override
  String get onboardDoneText => '从今天开始：有什么一件事想记住？';

  @override
  String get onboardNext => '下一步';

  @override
  String get onboardBack => '上一步';

  @override
  String get onboardStart => '开始写';

  @override
  String get onboardSkip => '跳过';

  @override
  String get helpFaq => '常见问题';

  @override
  String get helpFaq1Q => '日记保存在哪里？';

  @override
  String get helpFaq1A => '只保存在这台设备上，在应用自己的文件夹里。不会上传，也没有账号。';

  @override
  String get helpFaq2Q => '怎样备份，或者换到新设备？';

  @override
  String get helpFaq2A =>
      '设置 → 数据与存储 → 备份与恢复，会把日记、照片和设置打成一个文件，可以加密码。在新设备上恢复即可。也可以定时自动备份。';

  @override
  String get helpFaq3Q => '能导入其他日记应用的内容吗？';

  @override
  String get helpFaq3A =>
      '可以：在 设置 → 数据与存储 里导入 Daylio、Diarium、Diaro、DayBook、My Brain、OneShot、Pixels 的导出文件，或 JSON 导出文件。';

  @override
  String get helpFaq4Q => '写作计划怎么用？';

  @override
  String get helpFaq4A => '在“引导”页参加一个计划。每天或每周会有一个新问题出现在“故事”里，你的回答会存成一篇日记。';

  @override
  String get helpFaq5Q => '忘记密码怎么办？';

  @override
  String get helpFaq5A => '密码无法找回，所以请保留日记的备份。';

  @override
  String get helpPrivacy => '隐私';

  @override
  String get helpPrivacyText =>
      '日记、照片和设置不会离开这台设备，除非你自己分享或备份。应用只在显示地图和查地名（OpenStreetMap、Nominatim、Overpass）以及天气（Open-Meteo）时联网，只发送坐标或地名，从不发送你写的内容。';

  @override
  String get photoMetaTitle => '使用照片里的信息？';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return '把这篇日记算作 $date、地点改成 $place？这是照片里记录的。';
  }

  @override
  String photoMetaDate(String date) {
    return '把这篇日记算作照片拍摄的 $date？';
  }

  @override
  String photoMetaPlace(String place) {
    return '把这篇日记的地点设为照片拍摄的 $place？';
  }

  @override
  String get photoMetaApply => '使用';

  @override
  String get quickWriteTitle => '快速写';

  @override
  String get quickWriteText => '点一下开始写新日记。';

  @override
  String get settingsQuickWriteTitle => '通知栏快速写';

  @override
  String get settingsQuickWriteDescription => '在通知栏常驻一个入口，点一下就写新日记。';

  @override
  String get settingsNudgesTitle => '久未写日记时提醒我';

  @override
  String settingsNudgesDescription(int days) {
    return '$days 天没写日记时，轻轻提醒一下。';
  }

  @override
  String get nudgeTitle => '好久没写了';

  @override
  String get nudgeMonday => '新的一周开始了，有什么期待的吗？';

  @override
  String get nudgeTuesday => '写两行就够了。今天怎么样？';

  @override
  String get nudgeWednesday => '一周过半，有什么印象深刻的事？';

  @override
  String get nudgeThursday => '今天有什么小事值得留下来？';

  @override
  String get nudgeFriday => '这周快结束了，记下一个美好的瞬间吧。';

  @override
  String get nudgeSaturday => '慢悠悠的周六，正适合写点什么。';

  @override
  String get nudgeSunday => '在这周结束前回头看看吧。';

  @override
  String get photoWidgetEmpty => '日记里的照片会出现在这里。';

  @override
  String get channelReminders => '写日记提醒';

  @override
  String get channelOnThisDay => '那年今日';

  @override
  String get channelCoach => '写作计划';

  @override
  String get channelNudges => '久未写日记提醒';

  @override
  String get channelQuickWrite => '快速写';

  @override
  String get channelBackup => '备份';

  @override
  String get formatJsonExport => 'JSON（AID Diary 导出）';

  @override
  String get aboutModifiedNotice =>
      'Daily You（作者 Demizo 及贡献者）的修改版，不是官方的 Daily You 应用。';

  @override
  String get toolbarPhotos => '添加照片';

  @override
  String get toolbarMedia => '照片和视频';

  @override
  String get mediaFromGallery => '从图库选择';

  @override
  String get mediaFromFiles => '从文件选择';

  @override
  String get editorLeaveTitle => '保存这篇日记？';

  @override
  String get editorLeaveDiscard => '不保存';

  @override
  String get editorTitleHint => '标题';

  @override
  String get editorLocating => '正在定位…';

  @override
  String get toolbarVideo => '视频';

  @override
  String get toolbarAudio => '语音';

  @override
  String get toolbarTags => '标签';

  @override
  String get toolbarBulletList => '无序列表';

  @override
  String get toolbarHeading => '标题';

  @override
  String get toolbarBold => '粗体';

  @override
  String get toolbarItalic => '斜体';

  @override
  String get toolbarHighlight => '高亮';

  @override
  String get toolbarStrikethrough => '删除线';

  @override
  String get toolbarQuote => '引用';

  @override
  String get toolbarLink => '链接';

  @override
  String get toolbarInsert => '插入';

  @override
  String get toolbarUndo => '撤销';

  @override
  String get toolbarRedo => '重做';

  @override
  String get toolbarInsertDate => '插入日期';

  @override
  String get toolbarInsertTime => '插入时间';

  @override
  String get settingsSyncTitle => '云同步';

  @override
  String get syncOffDescription =>
      '通过 WebDAV 服务器（如 Nextcloud、群晖、坚果云）让这本日记在你的所有设备上保持一致。';

  @override
  String get syncServer => '服务器地址';

  @override
  String get syncUsername => '用户名';

  @override
  String get syncPassword => '密码';

  @override
  String get syncConnect => '连接';

  @override
  String get syncConnecting => '正在连接…';

  @override
  String get syncSignInFailed => '无法登录。请检查地址、用户名和密码。';

  @override
  String syncConnectFailed(String error) {
    return '无法连接：$error';
  }

  @override
  String get syncNewSpaceTitle => '开始同步';

  @override
  String get syncNewSpaceDescription => '这台服务器上还没有同步的日记，将把这本日记上传上去。';

  @override
  String get syncEncrypt => '端到端加密';

  @override
  String get syncEncryptDescription => '日记和照片在你的设备上加密，别人都读不到，包括服务器的运营方。';

  @override
  String get syncPassphrase => '加密口令';

  @override
  String get syncPassphraseRepeat => '再次输入口令';

  @override
  String get syncPassphraseTooShort => '至少 8 个字符';

  @override
  String get syncPassphraseMismatch => '两次输入的口令不一致';

  @override
  String get syncPassphraseNote => '添加其他设备时需要口令或恢复密钥。即使都忘了，这台设备上的日记仍然可以正常查看。';

  @override
  String get syncRecoveryKeyTitle => '保存恢复密钥';

  @override
  String get syncRecoveryKeyDescription =>
      '如果忘了口令，可以用这串密钥打开同步的日记。请把它存进密码管理器或抄在纸上，它只显示这一次。';

  @override
  String get syncRecoveryKeyCopied => '已复制恢复密钥';

  @override
  String get syncRecoveryKeySaved => '我已保存';

  @override
  String get syncJoinTitle => '加入已同步的日记';

  @override
  String get syncJoinDescription => '这台服务器上已经有同步的日记，这台设备上的日记会合并进去。';

  @override
  String get syncJoinEncrypted => '它已端到端加密，请输入口令打开。';

  @override
  String get syncUseRecoveryKey => '改用恢复密钥';

  @override
  String get syncUsePassphrase => '改用口令';

  @override
  String get syncRecoveryKey => '恢复密钥';

  @override
  String get syncWrongKey => '无法用它打开同步的日记。';

  @override
  String syncLastSynced(String time) {
    return '上次同步：$time';
  }

  @override
  String get syncNever => '尚未同步';

  @override
  String get syncSyncing => '正在同步…';

  @override
  String syncFailed(String error) {
    return '上次同步失败：$error';
  }

  @override
  String get syncLocked => '同步的日记在其他设备上重设过，或这台设备上的密钥丢失了。解锁后才能继续同步。';

  @override
  String get syncNow => '立即同步';

  @override
  String get syncUnlock => '解锁';

  @override
  String get syncEncrypted => '已端到端加密';

  @override
  String get syncNotEncrypted => '未加密';

  @override
  String get syncChangePassphrase => '修改口令';

  @override
  String get syncPassphraseChanged => '口令已修改';

  @override
  String get syncResetEncryption => '重设加密';

  @override
  String get syncResetEncryptionDescription =>
      '用于忘记口令时：服务器上的加密副本会被这台设备上的日记替换，并改用新口令加密。之后其他设备需要用新口令重新加入。';

  @override
  String get syncDisconnect => '停止同步';

  @override
  String get syncDisconnectDescription => '这台设备将停止同步。这里的日记和服务器上的副本都保持原样。';
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
  String get flashbacksTitle => '往日重現';

  @override
  String get settingsFlashbacksExcludeBadDays => '排除糟糕的日子';

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
  String get lastModified => '已修改';

  @override
  String get writeSomethingHint => '寫點什麼…';

  @override
  String get titleHint => '標題…';

  @override
  String get deleteLogTitle => '刪除紀錄';

  @override
  String get deleteLogDescription => '刪除後會移到「最近刪除」，在那裡可以恢復。';

  @override
  String get deletePhotoTitle => '刪除附件';

  @override
  String get deletePhotoDescription => '確定要刪除這個附件嗎？';

  @override
  String get pageSettingsTitle => '設定';

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
  String get settingsShowFlashbacks => '顯示往日重現';

  @override
  String get settingsChangeMoodIcons => '更改心情圖示';

  @override
  String get moodIconPrompt => '輸入圖示';

  @override
  String get settingsHideImages => '隱藏圖片';

  @override
  String get pageCalendarTitle => '月曆';

  @override
  String get settingsNotificationsTitle => '通知';

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
  String get manageTemplates => '管理模板';

  @override
  String get noTemplateTitle => '無';

  @override
  String get noTemplatesDescription => '尚未建立模板…';

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
      '## 歡迎使用 AID Diary\n\n> 一個安靜記錄日子的地方。\n\n寫下發生了什麼、心情如何、在哪裡。日記只保存在這台裝置上。\n\n- **日記**：按天列出所有日記\n- **日曆**、**媒體**、**地圖**：按日期、照片和地點回顧\n- **引導**：不知道寫什麼時，給你問題和範本';

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
      '如果選定的資料夾中已經包含一個 \'aid_diary.db\' 文件，它將覆蓋您現有的紀錄！';

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
  String get settingsExportToAnotherFormat => '匯出為其他格式';

  @override
  String get settingsExportFormatDescription => '這不應該被用來備份！';

  @override
  String get settingsImportFromAnotherApp => '從其他應用程式匯入';

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
  String get settingsOpenSourceLicenses => '開源授權條款';

  @override
  String get tagMoodTitle => '心情';

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
  String get atlasMyLocation => '我的位置';

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
  String get coachProgramEverydayDescription =>
      '五個簡單的問題，每天一個。每個只要一兩分鐘，幫你看見這一天裡屬於你的東西。想養成每天寫一點的習慣，可以從這裡開始。';

  @override
  String get coachProgramReflectTitle => '向內看看';

  @override
  String get coachProgramReflectDescription =>
      '五週，每週一個更深一點的問題。每個都不用急：最近的感受、什麼在消耗你、你感激什麼。';

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

  @override
  String get videoRecord => '錄製影片';

  @override
  String get videoChoose => '選擇影片';

  @override
  String get audioRecordTitle => '錄製語音';

  @override
  String get audioChoose => '選擇音訊檔';

  @override
  String get audioStart => '錄音';

  @override
  String get audioStop => '停止並儲存';

  @override
  String get audioPermissionDenied => '麥克風權限已關閉，請在系統設定中允許。';

  @override
  String get mediaTooLarge => '這部影片太大，無法加入。';

  @override
  String get mediaUnavailable => '此附件在這台裝置上無法使用。';

  @override
  String get widgetDone => '今天的日記已寫好';

  @override
  String get widgetPending => '今天過得怎麼樣？';

  @override
  String get widgetWrite => '寫日記';

  @override
  String get insertChecklist => '待辦清單';

  @override
  String get insertNumberedList => '編號列表';

  @override
  String get insertTable => '表格';

  @override
  String get insertDivider => '分隔線';

  @override
  String get insertCodeBlock => '程式碼區塊';

  @override
  String get journalSortTitle => '日記排序';

  @override
  String get journalSortUpdated => '最近修改';

  @override
  String get settingsTimeFormat => '時間格式';

  @override
  String get settingsDayStart => '新日記在幾點前算前一天';

  @override
  String get settingsDayAskUntil => '之後到幾點前詢問算哪天';

  @override
  String get settingsDayStartMidnight => '不使用';

  @override
  String settingsDayStartAt(int hour) {
    return '凌晨 $hour 點';
  }

  @override
  String get settingsDayStartHint =>
      '每篇日記都會同時保存實際寫作時間和它所屬的日記日，日記日可以隨時在編輯頁修改。這兩個時間只決定新日記預設算哪天，修改它們不會改動已有的任何日記。';

  @override
  String get lateNightBadge => '凌晨寫的，算作前一天';

  @override
  String editorDayAsk(String time) {
    return '$time 寫的，算哪一天？';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date（昨天）';
  }

  @override
  String editorDayToday(String date) {
    return '$date（今天）';
  }

  @override
  String editorWrittenAt(String when) {
    return '寫於 $when';
  }

  @override
  String get timeFormat12 => '12 小時制';

  @override
  String get timeFormat24 => '24 小時制';

  @override
  String get settingsReminderDays => '提醒日';

  @override
  String get locationRecent => '最近的地點';

  @override
  String get shareImage => '分享圖片';

  @override
  String get shareSaveImage => '儲存圖片';

  @override
  String get shareSaved => '圖片已儲存';

  @override
  String get deletedTitle => '最近刪除';

  @override
  String get deletedNone => '沒有最近刪除的日記';

  @override
  String deletedHint(int days) {
    return '刪除的日記會在這裡保留 $days 天，之後徹底清除。';
  }

  @override
  String deletedDaysLeft(int days) {
    return '還剩 $days 天';
  }

  @override
  String get deletedRestore => '恢復';

  @override
  String get deletedDeleteForever => '徹底刪除';

  @override
  String get deletedDeleteForeverDescription => '這篇日記和它的附件會被清除，無法復原。';

  @override
  String get deletedEmpty => '清空';

  @override
  String get deletedEmptyDescription => '清除「最近刪除」裡的全部日記？無法復原。';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => '隨機漫步';

  @override
  String get randomSubtitle => '翻開一篇舊日記';

  @override
  String get randomNext => '換一篇';

  @override
  String get randomAll => '全部';

  @override
  String get randomWithPhotos => '有照片';

  @override
  String get randomGoodDays => '開心的日子';

  @override
  String get randomEmpty => '沒有可以抽的日記';

  @override
  String get reviewWeekTitle => '本週回顧';

  @override
  String get reviewWeekSubtitle => '這一週寫了什麼';

  @override
  String get reviewYearTitle => '年度回顧';

  @override
  String get reviewEmpty => '還沒有寫日記';

  @override
  String get reviewEntries => '篇日記';

  @override
  String get reviewDaysWritten => '寫日記的天數';

  @override
  String get reviewWords => '字數';

  @override
  String get reviewPhotos => '照片';

  @override
  String get reviewLongestRun => '最長連續天數';

  @override
  String get reviewAverageMood => '平均心情';

  @override
  String get reviewFavorites => '最常出現';

  @override
  String get reviewByMonth => '每月篇數';

  @override
  String get reviewHighlight => '精選一篇';

  @override
  String get yearInPixels => '心情像素';

  @override
  String get capsuleSeal => '設為時間膠囊';

  @override
  String get capsuleTitle => '時間膠囊';

  @override
  String capsuleOpensOn(Object date) {
    return '$date 開啟';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return '寫於 $date';
  }

  @override
  String get capsuleOpenEarly => '提前打開';

  @override
  String get capsuleOpenEarlyDescription => '膠囊會立即打開，並且不再封存。';

  @override
  String get capsuleOpened => '時間膠囊已開啟';

  @override
  String get templateMorningName => '早間日記';

  @override
  String get templateMorningDescription => '三分鐘安排好今天';

  @override
  String get templateMorningText =>
      '## 今天最想做好的三件事\n1. \n2. \n3. \n\n## 今天期待的一件事\n\n## 想對自己說的一句話\n';

  @override
  String get templateEveningName => '晚間回顧';

  @override
  String get templateEveningDescription => '用三件好事收尾一天';

  @override
  String get templateEveningText =>
      '## 今天的三件好事\n1. \n2. \n3. \n\n## 今天學到了什麼\n\n## 明天可以做得更好的地方\n';

  @override
  String get routineMorning => '早安';

  @override
  String get routineEvening => '晚間回顧';

  @override
  String get settingsRoutinePrompts => '早晚日記提示';

  @override
  String get settingsRoutinePromptsHint => '在故事裡按時段推薦早間或晚間模板';

  @override
  String get checkInTitle => '快速記錄';

  @override
  String get checkInSubtitle => '兩下記下心情';

  @override
  String get checkInMood => '現在心情如何？';

  @override
  String get checkInActivity => '在做什麼？';

  @override
  String get checkInNote => '寫一句（可選）';

  @override
  String get checkInSave => '記下';

  @override
  String editorWordCount(int words, int characters) {
    return '$words 字 · $characters 個字元';
  }

  @override
  String get coachProgramEverydayTagline => '留意一天裡的小事。';

  @override
  String get coachProgramReflectTagline => '慢下來，聽聽自己。';

  @override
  String get coachDuration => '時長';

  @override
  String get coachInterval => '頻率';

  @override
  String get coachDifficulty => '難度';

  @override
  String get coachIntervalDaily => '每天';

  @override
  String get coachIntervalWeekly => '每週';

  @override
  String get coachDifficultyBeginner => '入門';

  @override
  String get coachDifficultyIntermediate => '進階';

  @override
  String coachDurationDays(int count) {
    return '$count 天';
  }

  @override
  String coachDurationWeeks(int count) {
    return '$count 週';
  }

  @override
  String coachDayN(int n) {
    return '第 $n 天';
  }

  @override
  String coachWeekN(int n) {
    return '第 $n 週';
  }

  @override
  String get coachEnroll => '參加';

  @override
  String get coachEndProgram => '結束計畫';

  @override
  String get coachAuthor => '作者';

  @override
  String get coachAuthorBio => '為這個應用編寫的寫作問題。';

  @override
  String get coachEnrolledTip => '好了！之後的問題會出現在「故事」裡。';

  @override
  String get coachGoToStories => '去看故事';

  @override
  String get coachAnswerHint => '寫下你的回答……';

  @override
  String get storyWrapUp => '今天就到這裡。';

  @override
  String get storyTapToClose => '點一下關閉';

  @override
  String get coachAnswerDone => '完成';

  @override
  String get coachAnswered => '已寫進日記，點一下打開';

  @override
  String get coachAnsweredEarlier => '已回答';

  @override
  String get locationLocating => '正在定位…';

  @override
  String get locationPickPlace => '選擇地點';

  @override
  String get locationPlacesHint => '地址或地點名稱';

  @override
  String get locationCustom => '自訂地點';

  @override
  String get locationCurrent => '目前位置';

  @override
  String get locationSaved => '收藏的地點';

  @override
  String get locationSearchResults => '搜尋結果';

  @override
  String get locationNearby => '附近的地點';

  @override
  String get locationRename => '重新命名';

  @override
  String get locationSavePlace => '收藏地點';

  @override
  String get locationUnsavePlace => '取消收藏';

  @override
  String get shareAs => '分享為…';

  @override
  String get shareAsImage => '圖片';

  @override
  String get shareAsZip => 'ZIP（含原始照片和影音）';

  @override
  String get shareAsPlainText => '純文字';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => '歡迎使用 AID Diary';

  @override
  String get onboardWelcomeText => '一個安靜記錄日子的地方。點「下一步」看看。';

  @override
  String get onboardIntroTitle => '寫一點，記住很多';

  @override
  String get onboardIntroText => '照片、地點、天氣和心情都和文字放在一起，「故事」會把過去的日子帶回來。';

  @override
  String get onboardPrivateTitle => '安全又私密';

  @override
  String get onboardPrivateText => '日記只保存在這台裝置上。加一個密碼，只給自己看。';

  @override
  String get onboardPrivateAction => '設定密碼';

  @override
  String get onboardNotifyTitle => '溫柔的提醒';

  @override
  String get onboardNotifyText => '打開提醒，慢慢養成習慣；參加寫作計畫後，新問題到了也會告訴你。';

  @override
  String get onboardNotifyAction => '打開提醒';

  @override
  String get onboardNotifyOn => '提醒已打開';

  @override
  String get onboardDoneTitle => '準備好了';

  @override
  String get onboardDoneText => '從今天開始：有什麼一件事想記住？';

  @override
  String get onboardNext => '下一步';

  @override
  String get onboardBack => '上一步';

  @override
  String get onboardStart => '開始寫';

  @override
  String get onboardSkip => '跳過';

  @override
  String get helpFaq => '常見問題';

  @override
  String get helpFaq1Q => '日記保存在哪裡？';

  @override
  String get helpFaq1A => '只保存在這台裝置上，在應用自己的資料夾裡。不會上傳，也沒有帳號。';

  @override
  String get helpFaq2Q => '怎樣備份，或者換到新裝置？';

  @override
  String get helpFaq2A =>
      '設定 → 資料與儲存 → 備份與還原，會把日記、照片和設定打包成一個檔案，可以加密碼。在新裝置上還原即可。也可以定時自動備份。';

  @override
  String get helpFaq3Q => '能匯入其他日記應用的內容嗎？';

  @override
  String get helpFaq3A =>
      '可以：在 設定 → 資料與儲存 裡匯入 Daylio、Diarium、Diaro、DayBook、My Brain、OneShot、Pixels 的匯出檔，或 JSON 匯出檔。';

  @override
  String get helpFaq4Q => '寫作計畫怎麼用？';

  @override
  String get helpFaq4A => '在「引導」頁參加一個計畫。每天或每週會有一個新問題出現在「故事」裡，你的回答會存成一篇日記。';

  @override
  String get helpFaq5Q => '忘記密碼怎麼辦？';

  @override
  String get helpFaq5A => '密碼無法找回，所以請保留日記的備份。';

  @override
  String get helpPrivacy => '隱私';

  @override
  String get helpPrivacyText =>
      '日記、照片和設定不會離開這台裝置，除非你自己分享或備份。應用只在顯示地圖和查地名（OpenStreetMap、Nominatim、Overpass）以及天氣（Open-Meteo）時連網，只傳送座標或地名，從不傳送你寫的內容。';

  @override
  String get photoMetaTitle => '使用照片裡的資訊？';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return '把這篇日記算作 $date、地點改成 $place？這是照片裡記錄的。';
  }

  @override
  String photoMetaDate(String date) {
    return '把這篇日記算作照片拍攝的 $date？';
  }

  @override
  String photoMetaPlace(String place) {
    return '把這篇日記的地點設為照片拍攝的 $place？';
  }

  @override
  String get photoMetaApply => '使用';

  @override
  String get quickWriteTitle => '快速寫';

  @override
  String get quickWriteText => '點一下開始寫新日記。';

  @override
  String get settingsQuickWriteTitle => '通知列快速寫';

  @override
  String get settingsQuickWriteDescription => '在通知列常駐一個入口，點一下就寫新日記。';

  @override
  String get settingsNudgesTitle => '久未寫日記時提醒我';

  @override
  String settingsNudgesDescription(int days) {
    return '$days 天沒寫日記時，輕輕提醒一下。';
  }

  @override
  String get nudgeTitle => '好久沒寫了';

  @override
  String get nudgeMonday => '新的一週開始了，有什麼期待的嗎？';

  @override
  String get nudgeTuesday => '寫兩行就夠了。今天怎麼樣？';

  @override
  String get nudgeWednesday => '一週過半，有什麼印象深刻的事？';

  @override
  String get nudgeThursday => '今天有什麼小事值得留下來？';

  @override
  String get nudgeFriday => '這週快結束了，記下一個美好的瞬間吧。';

  @override
  String get nudgeSaturday => '慢悠悠的週六，正適合寫點什麼。';

  @override
  String get nudgeSunday => '在這週結束前回頭看看吧。';

  @override
  String get photoWidgetEmpty => '日記裡的照片會出現在這裡。';

  @override
  String get channelReminders => '寫日記提醒';

  @override
  String get channelOnThisDay => '那年今日';

  @override
  String get channelCoach => '寫作計畫';

  @override
  String get channelNudges => '久未寫日記提醒';

  @override
  String get channelQuickWrite => '快速寫';

  @override
  String get channelBackup => '備份';

  @override
  String get formatJsonExport => 'JSON（AID Diary 匯出）';

  @override
  String get aboutModifiedNotice =>
      'Daily You（作者 Demizo 及貢獻者）的修改版，不是官方的 Daily You 應用。';

  @override
  String get toolbarPhotos => '新增照片';

  @override
  String get toolbarMedia => '照片和影片';

  @override
  String get mediaFromGallery => '從相簿選擇';

  @override
  String get mediaFromFiles => '從檔案選擇';

  @override
  String get editorLeaveTitle => '儲存這篇日記？';

  @override
  String get editorLeaveDiscard => '不儲存';

  @override
  String get editorTitleHint => '標題';

  @override
  String get editorLocating => '正在定位…';

  @override
  String get toolbarVideo => '影片';

  @override
  String get toolbarAudio => '語音';

  @override
  String get toolbarTags => '標籤';

  @override
  String get toolbarBulletList => '項目符號清單';

  @override
  String get toolbarHeading => '標題';

  @override
  String get toolbarBold => '粗體';

  @override
  String get toolbarItalic => '斜體';

  @override
  String get toolbarHighlight => '醒目提示';

  @override
  String get toolbarStrikethrough => '刪除線';

  @override
  String get toolbarQuote => '引用';

  @override
  String get toolbarLink => '連結';

  @override
  String get toolbarInsert => '插入';

  @override
  String get toolbarUndo => '復原';

  @override
  String get toolbarRedo => '重做';

  @override
  String get toolbarInsertDate => '插入日期';

  @override
  String get toolbarInsertTime => '插入時間';
}
