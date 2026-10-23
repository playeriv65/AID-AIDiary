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
  String get themeColorHint => '为这套配色选择颜色。';

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
  String get tagNameExists => '已有同名的标签';

  @override
  String get categoryNameExists => '已有同名的分类';

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
  String get formatOneDiary => '一本日记';

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
  String get settingsAppLanguageTitle => '应用程序语言';

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
  String get onboardWelcomeText => '从这里开始记录，或连接已有设备。由另一台设备确认授权后，两台设备都能继续使用。';

  @override
  String get onboardStart => '开始写';

  @override
  String get helpFaq => '常见问题';

  @override
  String get helpFaq1Q => '日记保存在哪里？';

  @override
  String get helpFaq1A =>
      '日记默认保存在这台设备上。只有主动开启同步、分享或导出时，内容才会到其他设备或存储位置；同步始终端到端加密。';

  @override
  String get helpFaq2Q => '怎样备份，或者换到新设备？';

  @override
  String get helpFaq2A =>
      '在“设置 → 数据与存储 → 同步”中连接已有设备，并在保存着日记的设备上确认授权。两台设备都能继续使用。也可以创建备份，再在另一台设备上恢复。';

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
      '日记和媒体默认保留在本机，除非主动开启加密同步或分享、导出。地图、地名查询和天气使用配置的服务，只发送请求所需的位置或查询词，不发送日记正文。';

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
      '通过 Google 云端硬盘或 WebDAV 服务器（如 Nextcloud、群晖、坚果云）让这本日记在你的所有设备上保持一致。';

  @override
  String get syncUseGoogleDrive => '用 Google 云端硬盘同步';

  @override
  String get syncOrWebDav => '或者用 WebDAV 服务器';

  @override
  String get syncGoogleDrive => 'Google 云端硬盘';

  @override
  String get syncGoogleSignedIn => '已登录，可以回到 AID Diary 了。';

  @override
  String get syncGoogleSignInAgain => 'Google 需要你重新登录。';

  @override
  String get syncSignInAgain => '重新登录';

  @override
  String get settingsCommandLineTitle => '命令行';

  @override
  String get commandLineToggle => '命令行接口';

  @override
  String get commandLineToggleHint => '允许 aid 命令行和本机上的其他程序调用应用的命令。';

  @override
  String get commandLineAlwaysOn => '开发版中始终开启。';

  @override
  String commandLineListening(int port) {
    return '正在端口 $port 上监听';
  }

  @override
  String get commandPaletteTitle => '所有命令';

  @override
  String get commandPaletteSearch => '搜索命令';

  @override
  String get commandPaletteRun => '运行';

  @override
  String get commandPaletteConfirm => '这一步不能简单撤销，确定运行吗？';

  @override
  String syncReceiving(int done, int total) {
    return '正在下载 $done / $total…';
  }

  @override
  String syncSending(int done, int total) {
    return '正在上传 $done / $total…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      '没有允许访问 Google 云端硬盘。请重新连接，并在 Google 的页面上勾选云端硬盘这一项。';

  @override
  String get syncEntryUnsynced => '还没同步：上次同步没有成功';

  @override
  String get syncUseOfficial => '使用 AID 同步服务器';

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
  String get syncNewSpaceDescription => '这里还没有同步的日记。本机日记会端到端加密后上传，密钥只保存在你的设备上。';

  @override
  String get syncJoinTitle => '加入已同步的日记';

  @override
  String get syncWrongKey => '这个恢复码打不开同步的日记。';

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
  String get syncLocked => '同步的日记已由其他设备持有，或已重新开始。与其中一台设备配对或使用恢复码，即可继续同步。';

  @override
  String get syncNow => '立即同步';

  @override
  String get syncUnlock => '解锁';

  @override
  String get syncEncrypted => '已端到端加密';

  @override
  String get syncDisconnect => '停止同步';

  @override
  String get syncDisconnectDescription => '这台设备将停止同步。这里的日记和同步的副本都保持原样。';

  @override
  String get syncOwnRecoveryPassword => '使用我自己的恢复密码';

  @override
  String get syncRecoveryPassword => '恢复密码';

  @override
  String get syncRecoveryPasswordRepeat => '再次输入恢复密码';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return '至少 $min 个字符';
  }

  @override
  String get syncRecoveryPasswordMismatch => '两次输入的密码不一致';

  @override
  String get syncRecoveryCode => '恢复码';

  @override
  String get syncRecoveryCodeTitle => '保存你的恢复码';

  @override
  String get syncRecoveryCodeDescription =>
      '如果你的设备全部丢失，这个恢复码可以找回同步的日记。请存进密码管理器或写在纸上。它只显示这一次。';

  @override
  String get syncRecoveryCodeCopied => '恢复码已复制';

  @override
  String get syncRecoveryCodeSaved => '我已保存';

  @override
  String get syncJoinNeedsKey => '这份同步日记属于你的其他设备。与其中一台配对，或使用恢复码。本机的日记会合并进去。';

  @override
  String get syncPairDevice => '与设备配对';

  @override
  String get syncUseRecoveryCode => '使用恢复码';

  @override
  String get syncAddDevice => '添加设备';

  @override
  String get syncChangeRecoveryCode => '更改恢复码';

  @override
  String get syncChangeRecoveryDescription => '新的恢复码会取代当前的，旧码随即失效。数据和其他设备不受影响。';

  @override
  String get syncNewRandomCode => '生成新的随机码';

  @override
  String get syncRecoveryCodeChanged => '恢复码已更改';

  @override
  String get syncResetSpace => '重新开始同步日记';

  @override
  String get syncResetSpaceDescription =>
      '仅在没有任何设备或恢复码能打开它时使用：同步副本会被本机日记取代，改用本机的密钥。其他设备之后需要重新配对。';

  @override
  String get syncPairTitle => '配对设备';

  @override
  String get syncPairShow => '显示配对码';

  @override
  String get syncPairEnter => '输入配对码';

  @override
  String get syncPairShowHint => '在另一台设备上打开“配对设备”，选择“输入配对码”，输入或扫描下面的码。';

  @override
  String get syncPairEnterHint => '输入另一台设备上显示的码，或扫码。';

  @override
  String get syncPairCode => '配对码';

  @override
  String get syncPairScan => '扫码';

  @override
  String get syncPairStart => '配对';

  @override
  String get syncPairWaiting => '等待另一台设备…';

  @override
  String syncPairDone(String device) {
    return '已与 $device 配对';
  }

  @override
  String get syncPairWrongCode => '配对码不匹配。请显示新的配对码再试一次。';

  @override
  String get syncPairNoOffer => '没有设备在显示这个码，它可能已经过期。';

  @override
  String get syncPairTimedOut => '另一台设备没有及时响应。';

  @override
  String get syncPairNeither => '两台设备都还没有加入这份同步日记。';

  @override
  String get syncPairBoth => '两台设备都已经能打开这份同步日记。';

  @override
  String syncPairFailed(String error) {
    return '配对失败：$error';
  }

  @override
  String get syncMediaPending => '日记已同步，部分媒体仍在传输';

  @override
  String get syncWaitingForDevices => '日记已同步，正在等待其他设备传输媒体';

  @override
  String get syncCacheNotice => '云端媒体缓存会过期。请保留设备上的原件；同步不等于备份。';

  @override
  String get paperTitle => '信纸';

  @override
  String get paperPlain => '素纸';

  @override
  String get paperLined => '横线';

  @override
  String get paperGrid => '方格';

  @override
  String get paperTinted => '淡彩';

  @override
  String get paperDecorationTitle => '装饰';

  @override
  String get paperDecorationNone => '无';

  @override
  String get paperDecorationBotanical => '枝叶';

  @override
  String get paperDecorationStars => '星星';

  @override
  String get paperDecorationWashi => '和纸胶带';

  @override
  String get themeDarkChoice => '暗色外观';

  @override
  String get themeDarkSame => '沿用浅色配色';

  @override
  String get themeDarkCustom => '单独配色';

  @override
  String get themeDarkAccent => '暗色强调色';

  @override
  String get themeColorTeal => '青绿';

  @override
  String get themeColorCyan => '青蓝';

  @override
  String get themeColorIndigo => '靛蓝';

  @override
  String get themeColorCoral => '珊瑚';

  @override
  String get themeColorOlive => '橄榄';

  @override
  String get themeColorSlate => '石板灰';

  @override
  String get drawingTitle => '手写与绘画';

  @override
  String get drawingPen => '画笔';

  @override
  String get drawingEraser => '橡皮';

  @override
  String get drawingUndo => '撤销';

  @override
  String get drawingClear => '清空';

  @override
  String get drawingWidth => '笔宽';

  @override
  String get drawingStylusOnly => '仅使用手写笔';

  @override
  String get drawingDiscardTitle => '放弃绘画？';

  @override
  String get drawingDiscardBody => '当前绘画尚未保存。';

  @override
  String get drawingSaveError => '无法保存绘画。';

  @override
  String get syncNetworkTitle => '网络诊断';

  @override
  String get syncNetworkRefresh => '刷新';

  @override
  String get syncNetworkSelectedRoute => '当前路径';

  @override
  String get syncNetworkAvailableRoutes => '可用路径';

  @override
  String get syncNetworkSignaling => '设备目录连接';

  @override
  String get syncNetworkRelayRemaining => '剩余中继额度';

  @override
  String get syncNetworkIcePair => '直连候选';

  @override
  String get syncNetworkPeerTrusted => '已认证设备';

  @override
  String get syncNetworkNoRoute => '等待连接';

  @override
  String get syncNetworkUnavailable => '暂时无法读取诊断';

  @override
  String get syncMediaCopiesTitle => '媒体传输与副本';

  @override
  String get syncMediaPendingCount => '等待传输';

  @override
  String get syncMediaDurableCount => '已传至个人存储';

  @override
  String get syncMediaTemporaryCount => '临时或未确认副本';

  @override
  String get syncMediaReceiptExplanation => '这些数量记录已完成的传输，不代表当前备份副本的核验结果。';

  @override
  String get syncMediaCacheExplanation => '云端临时媒体会过期，请保留原文件或独立备份。';

  @override
  String get momentsTitle => '照片回忆';

  @override
  String get momentsHint => '仅根据本地照片时间和可选坐标分组，选择卡片后才添加照片。';

  @override
  String get momentsScan => '寻找回忆';

  @override
  String get momentsChooseFolder => '选择照片文件夹';

  @override
  String get momentsLocation => '读取照片位置';

  @override
  String get momentsEmpty => '暂无近期照片分组。';

  @override
  String get momentsCreate => '用这些照片写日记';

  @override
  String get momentsDismiss => '忽略';

  @override
  String get momentsError => '无法读取本地照片。';

  @override
  String get momentsCreated => '已创建照片日记。';

  @override
  String get momentsPermission => '请允许照片访问以查找本地建议。';

  @override
  String get momentsScope => '仅查看近期照片；最多500张，每张卡片最多20张。';

  @override
  String momentsPhotoCount(int count) {
    return '$count 张照片';
  }

  @override
  String get nearbyTitle => '连接已有设备';

  @override
  String get nearbySend => '授权另一台设备';

  @override
  String get nearbyReceive => '连接已有设备';

  @override
  String get nearbyInstructions =>
      '两台设备连接同一 Wi-Fi，或连接对方热点。在已有设备上确认授权后，两台设备都能继续使用，无需互联网。';

  @override
  String get nearbyCompare => '核对两端显示的验证码后再确认。';

  @override
  String get nearbyConfirm => '验证码一致';

  @override
  String get nearbyScan => '扫描另一台设备的二维码';

  @override
  String get nearbyPaste => '粘贴邀请';

  @override
  String get nearbyWaiting => '等待另一台设备确认';

  @override
  String get nearbyWorking => '正在授权并同步日记和附件…';

  @override
  String get nearbyPending => '还有附件待同步，请保持另一台设备在线后重试。';

  @override
  String get nearbyComplete => '设备已连接，日记和附件已同步';

  @override
  String get nearbyFailed => '连接尚未完成，请检查本地连接后重试。';

  @override
  String get nearbyEmptyRequired => '请在日记为空、且尚未连接同步的设备上操作。';

  @override
  String get nearbyRetry => '继续同步';

  @override
  String get nearbyWifi => 'Wi-Fi 设置';

  @override
  String get nearbyHotspot => '热点设置';

  @override
  String get nearbyKeepOpen => '保持本页开启直到新设备完成，邀请两分钟后失效。';

  @override
  String get syncDevicesTitle => '授权设备';

  @override
  String get syncDevicesDescription =>
      '只有授权设备可访问此 AID 账户；撤销仅阻止服务器访问，不能收回已复制的主密钥和日记。';

  @override
  String get syncDeviceRequest => '向已授权设备展示此授权二维码';

  @override
  String get syncDeviceAuthorize => '授权新设备';

  @override
  String get syncDeviceAuthorizeDescription => '扫描或粘贴新设备的授权请求。';

  @override
  String get syncDeviceRevoke => '撤销授权';

  @override
  String get syncDeviceRotate => '轮换本机签名密钥';

  @override
  String get syncDeviceCheck => '检查授权';

  @override
  String get syncDeviceHardware => '硬件保护签名密钥';

  @override
  String get syncDeviceSoftware => '不可导出的软件签名密钥';

  @override
  String get syncDeviceUnavailable => '设备尚未获授权，请从另一台已授权设备批准后重试。';

  @override
  String get syncDeviceRevoked => '已撤销';

  @override
  String get syncDeviceLocal => '本机';

  @override
  String get cloudTrafficTitle => '每月云端媒体额度';

  @override
  String get cloudTrafficLimit => '每月额度';

  @override
  String get cloudTrafficUsed => '已使用';

  @override
  String get cloudTrafficRemaining => '剩余';

  @override
  String cloudTrafficResetsAt(String time) {
    return '$time 重置';
  }

  @override
  String get cloudTrafficExhausted => '云端媒体额度已用尽，待同步媒体会在直连可用或额度重置后自动继续。';

  @override
  String get cloudTrafficExplanation =>
      '媒体缓存与实时中继共用此额度，直连不占用。日记文字和连接控制另有独立的小流量日限额。';

  @override
  String get appearanceThemeSection => '应用主题';

  @override
  String get appearancePaperSection => '日记信纸';

  @override
  String get appearanceTypographySection => '日记文字';

  @override
  String get appearancePreferencesSection => '通用偏好';

  @override
  String get themeSystemAccentHint => '使用系统配色并覆盖自定义颜色，关闭后可自行选色。';

  @override
  String get syncDeviceNameSaveFailed => '无法保存设备名称，请重试。';

  @override
  String get nearbyConnectionHelp => '连接帮助';

  @override
  String get syncAllSynced => '全部已同步';

  @override
  String get syncDetailsTitle => '同步详情';

  @override
  String get syncMore => '更多选项';

  @override
  String get syncDeviceName => '设备名称';

  @override
  String get syncDeviceNameHint => '例如：我的平板';

  @override
  String get syncDeviceNameInvalid => '请输入 1 至 32 个字符';

  @override
  String get syncDeviceKeyDetails => '安全详情';

  @override
  String get syncConnectionProblem => '暂时无法同步，会自动重试';

  @override
  String get syncCopyComplete => '完整副本';

  @override
  String get syncCopyPartial => '部分媒体待同步';

  @override
  String get syncCopyOlder => '有新内容待同步';

  @override
  String get syncCopyUnavailable => '暂时无法查看副本详情，请稍后重试';

  @override
  String get syncCopyLastKnown => '其他设备显示上次确认的副本状态，离线时无法实时核实。';

  @override
  String get syncCopyTemporary => '临时缓存会自动清理，请保留设备上的原件。';

  @override
  String get syncCopyStorage => '你的同步存储，已完成的媒体上传记录可在诊断中查看。';

  @override
  String syncCopyChecked(String time) {
    return '上次确认：$time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return '本月剩余 $remaining / $limit';
  }

  @override
  String get onboardNewDiary => '从这里开始';

  @override
  String get onboardConnect => '连接已有设备';

  @override
  String get onboardFailed => '暂时未能完成设置，日记内容未受影响，请重试。';

  @override
  String get tutorialTitle => '使用教程';

  @override
  String get tutorialWriteTitle => '写下第一篇日记';

  @override
  String get tutorialWriteText => '点 + 开始记录。标题可以不填，选好日记日期后，点勾号保存。保存后随时可以再编辑。';

  @override
  String get tutorialMediaTitle => '添加照片、录音或手写';

  @override
  String get tutorialMediaText => '编辑时点 +，添加照片、视频、录音，或打开手写画布。这些附件会和这篇日记一起保存。';

  @override
  String get tutorialReviewTitle => '找回某一天';

  @override
  String get tutorialReviewText => '在日记或日历里回顾，用搜索查找内容，用标签整理。也可以从媒体或地图按照片、地点回看。';

  @override
  String get tutorialSyncTitle => '在多台设备上使用';

  @override
  String get tutorialSyncText =>
      '进入“设置 → 数据与存储 → 同步”，连接已有设备，并在另一台设备上确认授权。两台设备都能继续使用。文字先同步，附件会按连接情况和可用额度逐步补齐。';

  @override
  String get tutorialPrivacyTitle => '保护自己的记录';

  @override
  String get tutorialPrivacyText =>
      '除非主动开启同步或分享、导出，日记保留在本机。同步始终端到端加密。设置里还可以设置应用密码、备份，也能随时重新打开本教程。';

  @override
  String get editorDiaryDay => '日记日';

  @override
  String get editorDiaryDayPicker => '日记日·创建不变';

  @override
  String get editorDiaryDayHint => '决定这篇日记归属哪一天。修改日记日不会改变创建时间。';

  @override
  String get hiddenDiaryTitle => '隐藏日记';

  @override
  String get hiddenDiaryHide => '隐藏日记';

  @override
  String get hiddenDiaryShow => '取消隐藏';

  @override
  String get hiddenDiaryEmpty => '没有隐藏的日记';

  @override
  String get hiddenDiaryUnlock => '解锁隐藏日记';

  @override
  String get hiddenDiaryAuthHint => '请使用应用锁或设备屏幕锁解锁。';

  @override
  String get hiddenDiaryLocalOnly => '隐藏日记仅保存在本机，同步会暂停。请使用加密备份；其他设备上已有的副本不会改变。';

  @override
  String get moodClear => '清空心情';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => '主題色';

  @override
  String get themeColorHint => '為這套配色選擇顏色。';

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
  String get tagNameExists => '已有同名的標籤';

  @override
  String get categoryNameExists => '已有同名的分類';

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
  String get formatOneDiary => '一本日記';

  @override
  String get formatOneShot => 'OneShot';

  @override
  String get formatPixels => 'Pixels';

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
  String get settingsAppLanguageTitle => '應用程式語言';

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
  String get onboardWelcomeText => '從這裡開始記錄，或連接現有裝置。由另一台裝置確認授權後，兩台裝置都能繼續使用。';

  @override
  String get onboardStart => '開始寫';

  @override
  String get helpFaq => '常見問題';

  @override
  String get helpFaq1Q => '日記保存在哪裡？';

  @override
  String get helpFaq1A =>
      '日記預設保存在這台裝置上。只有主動開啟同步、分享或匯出時，內容才會到其他裝置或儲存位置；同步始終端對端加密。';

  @override
  String get helpFaq2Q => '怎樣備份，或者換到新裝置？';

  @override
  String get helpFaq2A =>
      '在「設定 → 資料與儲存 → 同步」中連接現有裝置，並在儲存日記的裝置上確認授權。兩台裝置都能繼續使用。也能建立備份，再在另一台裝置上還原。';

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
      '日記與媒體預設保留在本機，除非主動開啟加密同步或分享、匯出。地圖、地名查詢與天氣使用設定的服務，只傳送請求需要的位置或查詢詞，不傳送日記內文。';

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

  @override
  String get settingsSyncTitle => '雲端同步';

  @override
  String get syncOffDescription =>
      '透過 Google Drive 或 WebDAV 伺服器（例如 Nextcloud、Synology 或建國雲端）在所有裝置上保持此日記相同。';

  @override
  String get syncUseGoogleDrive => '與 Google Drive 同步';

  @override
  String get syncOrWebDav => '或 WebDAV 伺服器';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn => '已登入。您可以返回AID Diary。';

  @override
  String get syncGoogleSignInAgain => 'Google 需要您重新登入。';

  @override
  String get syncSignInAgain => '重新登入';

  @override
  String get settingsCommandLineTitle => '命令列';

  @override
  String get commandLineToggle => '命令列介面';

  @override
  String get commandLineToggleHint => '允許該裝置上的 help 命令和其他程式使用應用程式的命令。';

  @override
  String get commandLineAlwaysOn => '始終在開發建置中。';

  @override
  String commandLineListening(int port) {
    return '監聽$port端口';
  }

  @override
  String get commandPaletteTitle => '所有命令';

  @override
  String get commandPaletteSearch => '搜尋命令';

  @override
  String get commandPaletteRun => '運行';

  @override
  String get commandPaletteConfirm => '這不能簡單地撤銷。運行它嗎？';

  @override
  String syncReceiving(int done, int total) {
    return '正在接收 $done 的 $total…';
  }

  @override
  String syncSending(int done, int total) {
    return '正在發送 $total 的 $done...';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      '不允許存取 Google Drive。再次連線並在 Google 頁面上勾選 Google Drive。';

  @override
  String get syncEntryUnsynced => '未同步：上次同步未完成';

  @override
  String get syncUseOfficial => '使用 AID 同步伺服器';

  @override
  String get syncServer => '伺服器位址';

  @override
  String get syncUsername => '使用者名稱';

  @override
  String get syncPassword => '密碼';

  @override
  String get syncConnect => '連接';

  @override
  String get syncConnecting => '正在連線…';

  @override
  String get syncSignInFailed => '無法登入。請檢查地址、使用者名稱和密碼。';

  @override
  String syncConnectFailed(String error) {
    return '無法連接：$error';
  }

  @override
  String get syncNewSpaceTitle => '開始同步';

  @override
  String get syncNewSpaceDescription =>
      '這裡還沒有同步日記。該日記將被上傳，並使用您裝置上保留的金鑰進行端對端加密。';

  @override
  String get syncJoinTitle => '加入同步日記';

  @override
  String get syncWrongKey => '此恢復代碼不會開啟同步日記。';

  @override
  String syncLastSynced(String time) {
    return '最後同步 $time';
  }

  @override
  String get syncNever => '尚未同步';

  @override
  String get syncSyncing => '正在同步...';

  @override
  String syncFailed(String error) {
    return '上次同步失敗：$error';
  }

  @override
  String get syncLocked => '同步的日記現在屬於其他設備，或已重新開始。與其中之一配對或使用恢復代碼保持同步。';

  @override
  String get syncNow => '立即同步';

  @override
  String get syncUnlock => '解鎖';

  @override
  String get syncEncrypted => '端對端加密';

  @override
  String get syncDisconnect => '停止同步';

  @override
  String get syncDisconnectDescription => '本設備停止同步。這裡的日記和同步副本保持原樣。';

  @override
  String get syncOwnRecoveryPassword => '使用我自己的恢復密碼';

  @override
  String get syncRecoveryPassword => '恢復密碼';

  @override
  String get syncRecoveryPasswordRepeat => '重複恢復密碼';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return '至少使用 $min 字符';
  }

  @override
  String get syncRecoveryPasswordMismatch => '密碼不同';

  @override
  String get syncRecoveryCode => '恢復碼';

  @override
  String get syncRecoveryCodeTitle => '儲存您的恢復代碼';

  @override
  String get syncRecoveryCodeDescription =>
      '如果您的每台裝置都遺失，此程式碼將恢復您的同步日記。將其保存在密碼管理器中或紙上。僅顯示一次。';

  @override
  String get syncRecoveryCodeCopied => '已複製恢復程式碼';

  @override
  String get syncRecoveryCodeSaved => '我已經保存了';

  @override
  String get syncJoinNeedsKey =>
      '這張同步日記屬於您的其他裝置。與其中之一配對，或使用恢復代碼。該設備上的條目將會新增到其中。';

  @override
  String get syncPairDevice => '與設備配對';

  @override
  String get syncUseRecoveryCode => '使用恢復程式碼';

  @override
  String get syncAddDevice => '新增設備';

  @override
  String get syncChangeRecoveryCode => '更改恢復程式碼';

  @override
  String get syncChangeRecoveryDescription =>
      '新代碼取代了當前代碼，該代碼停止工作。您的資料和其他設備保持原樣。';

  @override
  String get syncNewRandomCode => '新隨機碼';

  @override
  String get syncRecoveryCodeChanged => '恢復程式碼已更改';

  @override
  String get syncResetSpace => '重新開始同步日記';

  @override
  String get syncResetSpaceDescription =>
      '僅當沒有設備且沒有恢復代碼再打開它時：同步副本將替換為該設備上的日記（在該設備的密鑰下）。然後您的其他裝置再次配對。';

  @override
  String get syncPairTitle => '配對裝置';

  @override
  String get syncPairShow => '顯示程式碼';

  @override
  String get syncPairEnter => '輸入代碼';

  @override
  String get syncPairShowHint => '在其他裝置上，開啟“配對裝置”，選擇“輸入代碼”，然後鍵入或掃描該代碼。';

  @override
  String get syncPairEnterHint => '輸入其他裝置顯示的代碼，或掃描它。';

  @override
  String get syncPairCode => '配對碼';

  @override
  String get syncPairScan => '掃描';

  @override
  String get syncPairStart => '配對';

  @override
  String get syncPairWaiting => '等待其他設備...';

  @override
  String syncPairDone(String device) {
    return '與$device配對';
  }

  @override
  String get syncPairWrongCode => '代碼不匹配。顯示新代碼並重試。';

  @override
  String get syncPairNoOffer => '沒有設備顯示此代碼。它可能已經過期了。';

  @override
  String get syncPairTimedOut => '對方設備沒有及時應答。';

  @override
  String get syncPairNeither => '這兩個設備都尚未設定此同步日記。';

  @override
  String get syncPairBoth => '兩台設備都已開啟此同步日記。';

  @override
  String syncPairFailed(String error) {
    return '配對失敗：$error';
  }

  @override
  String get syncMediaPending => '日記已同步，部分媒體仍在傳輸';

  @override
  String get syncWaitingForDevices => '日記已同步，正在等待其他裝置傳輸媒體';

  @override
  String get syncCacheNotice => '雲端媒體暫存會過期。請保留裝置上的原始檔案；同步不等於備份。';

  @override
  String get paperTitle => '信紙';

  @override
  String get paperPlain => '素紙';

  @override
  String get paperLined => '橫線';

  @override
  String get paperGrid => '方格';

  @override
  String get paperTinted => '淡彩';

  @override
  String get paperDecorationTitle => '裝飾';

  @override
  String get paperDecorationNone => '無';

  @override
  String get paperDecorationBotanical => '枝葉';

  @override
  String get paperDecorationStars => '星星';

  @override
  String get paperDecorationWashi => '和紙膠帶';

  @override
  String get themeDarkChoice => '暗色外觀';

  @override
  String get themeDarkSame => '沿用淺色配色';

  @override
  String get themeDarkCustom => '單獨配色';

  @override
  String get themeDarkAccent => '暗色強調色';

  @override
  String get themeColorTeal => '青綠';

  @override
  String get themeColorCyan => '青藍';

  @override
  String get themeColorIndigo => '靛藍';

  @override
  String get themeColorCoral => '珊瑚';

  @override
  String get themeColorOlive => '橄欖';

  @override
  String get themeColorSlate => '石板灰';

  @override
  String get drawingTitle => '手寫與繪畫';

  @override
  String get drawingPen => '畫筆';

  @override
  String get drawingEraser => '橡皮';

  @override
  String get drawingUndo => '復原';

  @override
  String get drawingClear => '清空';

  @override
  String get drawingWidth => '筆寬';

  @override
  String get drawingStylusOnly => '僅使用觸控筆';

  @override
  String get drawingDiscardTitle => '放棄繪畫？';

  @override
  String get drawingDiscardBody => '目前繪畫尚未儲存。';

  @override
  String get drawingSaveError => '無法儲存繪畫。';

  @override
  String get syncNetworkTitle => '網路診斷';

  @override
  String get syncNetworkRefresh => '重新整理';

  @override
  String get syncNetworkSelectedRoute => '目前路徑';

  @override
  String get syncNetworkAvailableRoutes => '可用路徑';

  @override
  String get syncNetworkSignaling => '裝置目錄連線';

  @override
  String get syncNetworkRelayRemaining => '剩餘中繼額度';

  @override
  String get syncNetworkIcePair => '直連候選';

  @override
  String get syncNetworkPeerTrusted => '已驗證裝置';

  @override
  String get syncNetworkNoRoute => '等待連線';

  @override
  String get syncNetworkUnavailable => '暫時無法讀取診斷';

  @override
  String get syncMediaCopiesTitle => '媒體傳輸與副本';

  @override
  String get syncMediaPendingCount => '等待傳輸';

  @override
  String get syncMediaDurableCount => '已傳至個人儲存空間';

  @override
  String get syncMediaTemporaryCount => '暫存或未確認副本';

  @override
  String get syncMediaReceiptExplanation => '這些數量記錄已完成的傳輸，不代表目前備份副本的核驗結果。';

  @override
  String get syncMediaCacheExplanation => '雲端暫存媒體會到期，請保留原始檔案或獨立備份。';

  @override
  String get momentsTitle => '照片回憶';

  @override
  String get momentsHint => '僅根據本機照片時間和可選座標分組，選擇卡片後才加入照片。';

  @override
  String get momentsScan => '尋找回憶';

  @override
  String get momentsChooseFolder => '選擇照片資料夾';

  @override
  String get momentsLocation => '讀取照片位置';

  @override
  String get momentsEmpty => '暫無近期照片分組。';

  @override
  String get momentsCreate => '用這些照片寫日記';

  @override
  String get momentsDismiss => '忽略';

  @override
  String get momentsError => '無法讀取本機照片。';

  @override
  String get momentsCreated => '已建立照片日記。';

  @override
  String get momentsPermission => '請允許照片存取以尋找本機建議。';

  @override
  String get momentsScope => '僅查看近期照片；最多500張，每張卡片最多20張。';

  @override
  String momentsPhotoCount(int count) {
    return '$count 張照片';
  }

  @override
  String get nearbyTitle => '連接現有裝置';

  @override
  String get nearbySend => '授權另一台裝置';

  @override
  String get nearbyReceive => '連接現有裝置';

  @override
  String get nearbyInstructions =>
      '兩台裝置連接相同 Wi-Fi，或連接對方熱點。在現有裝置確認授權後，兩台裝置都能繼續使用，不需要網際網路。';

  @override
  String get nearbyCompare => '核對兩端顯示的驗證碼後再確認。';

  @override
  String get nearbyConfirm => '驗證碼一致';

  @override
  String get nearbyScan => '掃描另一台裝置的 QR 碼';

  @override
  String get nearbyPaste => '貼上邀請';

  @override
  String get nearbyWaiting => '等待另一台裝置確認';

  @override
  String get nearbyWorking => '正在授權並同步日記與附件…';

  @override
  String get nearbyPending => '還有附件待同步，請保持另一台裝置在線後重試。';

  @override
  String get nearbyComplete => '裝置已連接，日記與附件已同步';

  @override
  String get nearbyFailed => '連線尚未完成，請檢查本機連線後重試。';

  @override
  String get nearbyEmptyRequired => '請在日記為空、且尚未連接同步的裝置上操作。';

  @override
  String get nearbyRetry => '繼續同步';

  @override
  String get nearbyWifi => 'Wi-Fi 設定';

  @override
  String get nearbyHotspot => '熱點設定';

  @override
  String get nearbyKeepOpen => '保持本頁開啟直到新裝置完成，邀請兩分鐘後失效。';

  @override
  String get syncDevicesTitle => '授權裝置';

  @override
  String get syncDevicesDescription =>
      '只有授權裝置可存取此 AID 帳戶；撤銷僅阻止伺服器存取，不能收回已複製的主金鑰和日記。';

  @override
  String get syncDeviceRequest => '向已授權裝置展示此授權 QR 碼';

  @override
  String get syncDeviceAuthorize => '授權新裝置';

  @override
  String get syncDeviceAuthorizeDescription => '掃描或貼上新裝置的授權請求。';

  @override
  String get syncDeviceRevoke => '撤銷授權';

  @override
  String get syncDeviceRotate => '輪換本機簽名金鑰';

  @override
  String get syncDeviceCheck => '檢查授權';

  @override
  String get syncDeviceHardware => '硬體保護簽名金鑰';

  @override
  String get syncDeviceSoftware => '不可匯出的軟體簽名金鑰';

  @override
  String get syncDeviceUnavailable => '裝置尚未獲授權，請從另一台已授權裝置批准後重試。';

  @override
  String get syncDeviceRevoked => '已撤銷';

  @override
  String get syncDeviceLocal => '本機';

  @override
  String get cloudTrafficTitle => '每月雲端媒體額度';

  @override
  String get cloudTrafficLimit => '每月額度';

  @override
  String get cloudTrafficUsed => '已使用';

  @override
  String get cloudTrafficRemaining => '剩餘';

  @override
  String cloudTrafficResetsAt(String time) {
    return '$time 重設';
  }

  @override
  String get cloudTrafficExhausted => '雲端媒體額度已用盡，待同步媒體會在直連可用或額度重設後自動繼續。';

  @override
  String get cloudTrafficExplanation =>
      '媒體快取與即時中繼共用此額度，直連不占用。日記文字和連線控制另有獨立的小流量日限額。';

  @override
  String get appearanceThemeSection => '應用主題';

  @override
  String get appearancePaperSection => '日記信紙';

  @override
  String get appearanceTypographySection => '日記文字';

  @override
  String get appearancePreferencesSection => '一般偏好';

  @override
  String get themeSystemAccentHint => '使用系統配色並覆蓋自訂顏色，關閉後可自行選色。';

  @override
  String get syncDeviceNameSaveFailed => '無法儲存裝置名稱，請重試。';

  @override
  String get nearbyConnectionHelp => '連線說明';

  @override
  String get syncAllSynced => '全部已同步';

  @override
  String get syncDetailsTitle => '同步詳細資料';

  @override
  String get syncMore => '更多選項';

  @override
  String get syncDeviceName => '裝置名稱';

  @override
  String get syncDeviceNameHint => '例如：我的平板';

  @override
  String get syncDeviceNameInvalid => '請輸入 1 至 32 個字元';

  @override
  String get syncDeviceKeyDetails => '安全詳細資料';

  @override
  String get syncConnectionProblem => '暫時無法同步，會自動重試';

  @override
  String get syncCopyComplete => '完整副本';

  @override
  String get syncCopyPartial => '部分媒體待同步';

  @override
  String get syncCopyOlder => '有新內容待同步';

  @override
  String get syncCopyUnavailable => '暫時無法查看副本詳細資料，請稍後重試';

  @override
  String get syncCopyLastKnown => '其他裝置顯示上次確認的副本狀態，離線時無法即時核實。';

  @override
  String get syncCopyTemporary => '暫存快取會自動清理，請保留裝置上的原件。';

  @override
  String get syncCopyStorage => '你的同步儲存空間，已完成的媒體上傳紀錄可在診斷中查看。';

  @override
  String syncCopyChecked(String time) {
    return '上次確認：$time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return '本月剩餘 $remaining / $limit';
  }

  @override
  String get onboardNewDiary => '從這裡開始';

  @override
  String get onboardConnect => '連接現有裝置';

  @override
  String get onboardFailed => '暫時無法完成設定，日記內容未受影響，請重試。';

  @override
  String get tutorialTitle => '使用教學';

  @override
  String get tutorialWriteTitle => '寫下第一篇日記';

  @override
  String get tutorialWriteText => '點 + 開始記錄。標題可以不填，選好日記日期後，點勾號儲存。儲存後隨時可以再編輯。';

  @override
  String get tutorialMediaTitle => '加入照片、錄音或手寫';

  @override
  String get tutorialMediaText => '編輯時點 +，加入照片、影片、錄音，或開啟手寫畫布。這些附件會和這篇日記一起儲存。';

  @override
  String get tutorialReviewTitle => '找回某一天';

  @override
  String get tutorialReviewText => '在日記或日曆裡回顧，用搜尋查找內容，用標籤整理。也能從媒體或地圖按照片、地點回看。';

  @override
  String get tutorialSyncTitle => '在多台裝置上使用';

  @override
  String get tutorialSyncText =>
      '進入「設定 → 資料與儲存 → 同步」，連接現有裝置，並在另一台裝置確認授權。兩台裝置都能繼續使用。文字先同步，附件會依連線情況與可用額度逐步補齊。';

  @override
  String get tutorialPrivacyTitle => '保護自己的記錄';

  @override
  String get tutorialPrivacyText =>
      '除非主動開啟同步或分享、匯出，日記保留在本機。同步始終端對端加密。設定裡也能設定應用程式密碼、備份，或重新開啟本教學。';

  @override
  String get editorDiaryDay => '日記日';

  @override
  String get editorDiaryDayPicker => '日記日·建立不變';

  @override
  String get editorDiaryDayHint => '決定這篇日記歸屬哪一天。修改日記日不會改變建立時間。';

  @override
  String get hiddenDiaryTitle => '隱藏日記';

  @override
  String get hiddenDiaryHide => '隱藏日記';

  @override
  String get hiddenDiaryShow => '取消隱藏';

  @override
  String get hiddenDiaryEmpty => '沒有隱藏的日記';

  @override
  String get hiddenDiaryUnlock => '解鎖隱藏日記';

  @override
  String get hiddenDiaryAuthHint => '請使用應用程式鎖或裝置螢幕鎖解鎖。';

  @override
  String get hiddenDiaryLocalOnly => '隱藏日記僅儲存在本機，同步會暫停。請使用加密備份；其他裝置上已有的副本不會改變。';

  @override
  String get moodClear => '清除心情';
}
