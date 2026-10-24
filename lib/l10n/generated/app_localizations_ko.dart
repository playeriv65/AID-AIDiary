// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => '테마 색상';

  @override
  String get themeColorHint => '이 팔레트의 색상을 선택하세요.';

  @override
  String get themeColorBlue => '하늘색';

  @override
  String get themeColorGreen => '포레스트 그린';

  @override
  String get themeColorBrown => '따뜻한 커피';

  @override
  String get themeColorPurple => '라벤더';

  @override
  String get themeColorRose => '더스티 로즈';

  @override
  String get themeColorAmber => '호박색';

  @override
  String get themeColorPreview => '매일 조금씩';

  @override
  String get themeTintBackgroundTitle => '테마 색상을 사용한 색조 배경';

  @override
  String get themeTintBackgroundHint => '중간 회색 배경의 경우 끄십시오. 버튼은 선택한 색상을 유지합니다.';

  @override
  String get dailyReminderTitle => '오늘을 기록하세요!';

  @override
  String get dailyReminderDescription => '하루를 기록해보세요…';

  @override
  String get actionTakePhoto => '사진 찍기';

  @override
  String get flashbacksTitle => '회상';

  @override
  String get settingsFlashbacksExcludeBadDays => '나쁜 날들 제외';

  @override
  String get flashbackGoodDay => '좋은 날';

  @override
  String get flashbackRandomDay => '임의의 날';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 주 전',
      one: '$count 주 전',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 달 전',
      one: '$count 달 전',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 년 전',
      one: '$count 년 전',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => '이날';

  @override
  String get searchLogsHint => '기록 검색…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 개의 기록',
      one: '$count 개의 기록',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count일',
      one: '$count일',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 단어',
      one: '$count 단어',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => '기록 없음…';

  @override
  String get noResults => '결과가 없습니다…';

  @override
  String get sortOrderAscendingTitle => '오름차순';

  @override
  String get sortOrderDescendingTitle => '내림차순';

  @override
  String get pageStatisticsTitle => '통계';

  @override
  String get statisticsNotEnoughData => '데이터가 충분하지 않습니다…';

  @override
  String get statisticsRangeOneMonth => '한 달';

  @override
  String get statisticsRangeSixMonths => '6개월';

  @override
  String get statisticsRangeOneYear => '일 년';

  @override
  String get statisticsRangeAllTime => '전체 기간';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag 요약';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag 날짜로';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '시간이 지남에 따라 $tag';
  }

  @override
  String get chartGroupingLabel => '그룹화 기준';

  @override
  String get chartGroupingDay => '일';

  @override
  String get chartGroupingWeek => '주';

  @override
  String get chartGroupingMonth => '월';

  @override
  String get chartGroupingYear => '연도';

  @override
  String get chartSmoothingLabel => '스무딩';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '현재 $count연속',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '최장 연속 $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '좋은 날들 $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '나쁜 날로부터 $count일',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle => '외부 저장소 접근 불가';

  @override
  String get errorExternalStorageAccessDescription =>
      '네트워크 저장소를 사용하는 경우 서비스가 온라인이고 네트워크 접근 권한을 가지고 있는지 확인하십시오.\n\n그렇지 않다면, 앱이 외부 폴더 접근 권한을 잃어버렸을 수 있습니다. 설정에서 외부폴더 접근 권한을 다시 부여하십시오.\n\n경고, 외부 저장소의 접근 권한을 복구하기 전까지 변경사항이 동기화 되지 않습니다!';

  @override
  String get errorExternalStorageAccessContinue => '로컬 데이터베이스로 계속';

  @override
  String get lastModified => '변경됨';

  @override
  String get writeSomethingHint => '뭔가 적어보세요…';

  @override
  String get titleHint => '제목…';

  @override
  String get deleteLogTitle => '기록 삭제';

  @override
  String get deleteLogDescription => '이 기록을 삭제하시겠습니까?';

  @override
  String get deletePhotoTitle => '사진 삭제';

  @override
  String get deletePhotoDescription => '이 사진을 삭제하시겠습니까?';

  @override
  String get pageSettingsTitle => '설정';

  @override
  String get settingsTheme => '테마';

  @override
  String get themeSystem => '시스템';

  @override
  String get themeLight => '라이트';

  @override
  String get themeDark => '다크';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => '한 주의 시작';

  @override
  String get settingsCalendarSystem => '캘린더 시스템';

  @override
  String get calendarSystemGregorian => '그레고리력';

  @override
  String get calendarSystemJalali => '잘랄리';

  @override
  String get settingsUseSystemAccentColor => '시스템 강조 색상 사용';

  @override
  String get settingsCustomAccentColor => '커스텀 강조 색상';

  @override
  String get settingsShowFlashbacks => '회상 표시';

  @override
  String get settingsChangeMoodIcons => '기분 아이콘 변경';

  @override
  String get moodIconPrompt => '아이콘 입력';

  @override
  String get settingsHideImages => '이미지 숨기기';

  @override
  String get pageCalendarTitle => '달력';

  @override
  String get settingsNotificationsTitle => '알림';

  @override
  String get settingsDailyReminderTitle => '일일 알림';

  @override
  String get settingsOnThisDayDescription => '지난 추억을 다시 찾아보세요';

  @override
  String get settingsDailyReminderDescription => '매일의 다정한 알림';

  @override
  String get settingsReminderTime => '리마인더 시간';

  @override
  String get settingsFixedReminderTimeTitle => '고정 리마인더 시간';

  @override
  String get settingsFixedReminderTimeDescription => '리마인더를 보낼 고정 시간 선택';

  @override
  String get settingsAlwaysSendReminderTitle => '항상 리마인더 전송';

  @override
  String get settingsAlwaysSendReminderDescription => '기록을 이미 시작했더라도 리마인더를 전송';

  @override
  String get settingsCustomizeNotificationTitle => '알림 커스터마이즈';

  @override
  String get settingsTemplatesTitle => '템플릿';

  @override
  String get manageTemplates => '템플릿 관리';

  @override
  String get noTemplateTitle => '없음';

  @override
  String get noTemplatesDescription => '아직 템플릿이 생성되지 않았습니다…';

  @override
  String get templateDefaultTimestampTitle => '타임스탬프';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => '일일 요약';

  @override
  String get templateDefaultSummaryBody => '### 요약\n- \n\n### 인용\n> ';

  @override
  String get templateDefaultReflectionTitle => '되짚기';

  @override
  String get templateDefaultReflectionBody =>
      '### 오늘 어떤 것이 즐거웠나요?\n- \n\n### 어떤 것에 감사하나요?\n- \n\n### 앞으로 무엇을 기대하나요?\n- ';

  @override
  String get settingsTagsTitle => '태그';

  @override
  String get manageTags => '태그 관리';

  @override
  String get tagTypeLabelTitle => '라벨';

  @override
  String get tagTypeTrackerTitle => '추적기';

  @override
  String get nameHint => '이름';

  @override
  String get tagColorLabel => '색상';

  @override
  String get iconPickerTitle => '아이콘 선택';

  @override
  String get iconPickerIconsTab => '아이콘';

  @override
  String get iconPickerCustomTab => '맞춤';

  @override
  String get iconPickerSearchHint => '아이콘 검색…';

  @override
  String get colorPickerTitle => '색상 선택';

  @override
  String get colorPickerPaletteTab => '색상';

  @override
  String get iconGroupMoodPeople => '기분과 사람';

  @override
  String get iconGroupHealth => '건강';

  @override
  String get iconGroupWorkFinance => '업무 및 금융';

  @override
  String get iconGroupHabitsGoals => '습관과 목표';

  @override
  String get iconGroupNature => '자연';

  @override
  String get iconGroupFoodDrink => '음식 및 음료';

  @override
  String get iconGroupHome => '홈';

  @override
  String get iconGroupTravel => '여행';

  @override
  String get iconGroupSymbols => '기호';

  @override
  String get tagCategoryLabel => '카테고리';

  @override
  String get tagLabel => '태그';

  @override
  String get tagCategoryUncategorized => '분류되지 않음';

  @override
  String get newCategoryTitle => '새 카테고리';

  @override
  String get shareButtonLabel => '공유';

  @override
  String get importErrorDescription => '파일을 가져오지 못했습니다!';

  @override
  String get exportErrorDescription => '파일을 내보내지 못했습니다.';

  @override
  String get deleteTitle => '삭제';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' $count개의 일기 항목에 사용됩니다.',
      one: ' 1로그에 사용됩니다.',
      zero: '',
    );
    return '\'$name\'을 삭제하시겠습니까?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' $count개의 태그도 삭제됩니다.',
      one: ' 해당 태그 1개도 삭제됩니다.',
      zero: '',
    );
    return '\'$name\'을 삭제하시겠습니까?$_temp0';
  }

  @override
  String get tagNameExists => '이미 같은 이름의 태그가 있습니다.';

  @override
  String get categoryNameExists => '이미 같은 이름의 카테고리가 있습니다.';

  @override
  String deleteTemplateMessage(Object name) {
    return '\'$name\'을 삭제하시겠습니까?';
  }

  @override
  String get addTagsTitle => '태그 추가';

  @override
  String get addTagsSearchHint => '태그 검색…';

  @override
  String get tagFavoriteName => '즐겨찾기';

  @override
  String get iconGroupActivities => '활동';

  @override
  String get iconGroupHobbies => '엔터테인먼트';

  @override
  String get settingsStorageTitle => '저장소';

  @override
  String get settingsImageQuality => '이미지 품질';

  @override
  String get imageQualityHigh => '높음';

  @override
  String get imageQualityMedium => '중간';

  @override
  String get imageQualityLow => '낮음';

  @override
  String get imageQualityNoCompression => '압축 없음';

  @override
  String get settingsLogFolder => '기록 폴더';

  @override
  String get settingsImageFolder => '이미지 폴더';

  @override
  String get warningTitle => '경고';

  @override
  String get logFolderWarningDescription =>
      '이미 \'aid_diary.db\' 파일이 존재하는 폴더를 선택할 경우, 존재하는 기록을 덮어쓰게 됩니다!';

  @override
  String get errorTitle => '에러';

  @override
  String get logFolderErrorDescription => '기록 폴더 변경 실패!';

  @override
  String get imageFolderErrorDescription => '이미지 폴더 변경 실패!';

  @override
  String get backupErrorDescription => '백업 생성 실패!';

  @override
  String get restoreErrorDescription => '백업 불러오기 실패!';

  @override
  String get settingsBackupRestoreTitle => '백업 및 복원';

  @override
  String get settingsBackup => '백업';

  @override
  String get settingsRestore => '복원';

  @override
  String get settingsRestorePromptDescription =>
      '백업을 복구하면 이미 존재하는 데이터를 덮어쓰게 됩니다!';

  @override
  String get settingsBackupPasswordProtect => '비밀번호 보호 백업';

  @override
  String get backupEncryptedTitle => '암호화된 백업';

  @override
  String get backupEncryptedContent => '이 백업은 비밀번호로 보호되어 있습니다.';

  @override
  String get settingsAutoBackup => '자동 백업';

  @override
  String get settingsAutoBackupLocation => '백업 위치';

  @override
  String get settingsAutoBackupInterval => '백업 간격';

  @override
  String get settingsAutoBackupIntervalDaily => '매일';

  @override
  String get settingsAutoBackupIntervalWeekly => '주간';

  @override
  String get settingsAutoBackupIntervalMonthly => '월간';

  @override
  String get settingsAutoBackupMaxCount => '보관할 백업';

  @override
  String get settingsAutoBackupRequireCharging => '충전하는 동안에만';

  @override
  String settingsBackupLast(Object time) {
    return '마지막 백업 $time';
  }

  @override
  String get settingsBackupNever => '백업되지 않음';

  @override
  String settingsAutoBackupNext(Object time) {
    return '다음 백업 $time';
  }

  @override
  String get settingsAutoBackupKeepAll => '모두';

  @override
  String get autoBackupFailedTitle => '백업 실패';

  @override
  String tranferStatus(Object percent) {
    return '전송중… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return '백업 생성 중… $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return '백업 복원 중… $percent%';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return '백업 암호화 중… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return '백업 암호 해독 중… $percent%';
  }

  @override
  String get cleanUpStatus => '정리 중…';

  @override
  String get settingsExportToAnotherFormat => '다른 형식으로 내보내기';

  @override
  String get settingsExportFormatDescription => '백업으로 사용을 권장하지 않습니다!';

  @override
  String get settingsImportFromAnotherApp => '다른 앱에서 가져오기';

  @override
  String get logFormatTitle => '형식 선택';

  @override
  String get logFormatDescription =>
      '다른 앱의 형식은 모든 기능을 지원하지 않을 수 있습니다. 서드 파티 형식은 언제든 바뀔 수 있어 문제가 있다면 알려주시기 바랍니다. 이는 존재하는 기록에 영향을 미치지 않습니다!';

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
  String get formatOneShot => '원샷';

  @override
  String get formatPixels => 'Pixels';

  @override
  String get formatMarkdown => '마크다운';

  @override
  String get settingsDeleteAllLogsTitle => '모든 기록 삭제';

  @override
  String get settingsDeleteAllLogsDescription => '모든 기록을 삭제하시겠습까?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return '확인을 위해 \'$prompt\' 를 입력하세요. 이 변경사항은 되돌릴 수 없습니다!';
  }

  @override
  String get settingsAppLanguageTitle => '앱 언어';

  @override
  String get settingsSecurityTitle => '보안';

  @override
  String get settingsSecurityRequirePassword => '비밀번호 사용';

  @override
  String get settingsSecurityEnterPassword => '비밀번호 입력';

  @override
  String get settingsSecuritySetPassword => '비밀번호 설정';

  @override
  String get settingsSecurityChangePassword => '비밀번호 변경';

  @override
  String get settingsSecurityPassword => '비밀번호';

  @override
  String get settingsSecurityConfirmPassword => '비밀번호 확인';

  @override
  String get settingsSecurityOldPassword => '옛 비밀번호';

  @override
  String get settingsSecurityIncorrectPassword => '틀린 비밀번호';

  @override
  String get settingsSecurityPasswordsDoNotMatch => '비밀번호가 일치하지 않음';

  @override
  String get requiredPrompt => '필요';

  @override
  String get settingsSecurityBiometricUnlock => '생체인식 잠금해제';

  @override
  String get unlockAppPrompt => '앱 잠금해제';

  @override
  String get settingsAboutTitle => '정보';

  @override
  String get settingsVersion => '버전';

  @override
  String get settingsLicense => '라이센스';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsOpenSourceLicenses => '오픈 소스 라이선스';

  @override
  String get tagMoodTitle => '기분';

  @override
  String get selectTagTitle => '태그 선택';

  @override
  String get labelPresentLabel => '현재';

  @override
  String get labelAbsentLabel => '결석';

  @override
  String get labelCoverageLabel => '적용 범위';

  @override
  String chartDistributionTitle(Object tag) {
    return '$tag 배포';
  }

  @override
  String get shareAddToLogPickerTitle => '일기 항목을 선택하세요';

  @override
  String get adaptiveEmptyDay => '오늘은 아직 항목이 없습니다.';

  @override
  String get adaptiveNewEntry => '항목 작성';

  @override
  String get pageJournalTitle => '저널';

  @override
  String get coachPrompt1 => '오늘 당신을 웃게 만든 일은 무엇이었나요?';

  @override
  String get coachPrompt2 => '오늘 배운 것 중 하나는 무엇입니까?';

  @override
  String get coachPrompt3 => '오늘 누구와 이야기를 나눴고, 어떤 느낌이 들었나요?';

  @override
  String get coachPrompt4 => '지금 당신은 무엇에 감사하고 있나요?';

  @override
  String get coachPrompt5 => '오늘 당신의 에너지를 가장 많이 소모한 일은 무엇입니까?';

  @override
  String get coachPrompt6 => '기억하고 싶은 작은 순간을 묘사해보세요.';

  @override
  String get coachPrompt7 => '무엇이 내일을 좋은 날로 만들까요?';

  @override
  String get coachPrompt8 => '최근에 무슨 생각이 들었나요?';

  @override
  String get coachPrompt9 => '오늘 당신은 당신 자신을 위해 무엇을 했나요?';

  @override
  String get coachPrompt10 => '오늘의 제목이 있다면 무엇일까요?';

  @override
  String get pageMediaTitle => '미디어';

  @override
  String get pageAtlasTitle => '아틀라스';

  @override
  String get pageCoachTitle => '코치';

  @override
  String get noEntrySelected => '선택한 항목이 없습니다.';

  @override
  String get entryShare => '공유';

  @override
  String get entryFavorite => '별';

  @override
  String get entryEdit => '편집';

  @override
  String get entryPrevious => '이전 항목';

  @override
  String get entryNext => '다음 항목';

  @override
  String get journalStories => '스토리';

  @override
  String get journalEntries => '항목';

  @override
  String get journalEmptyHint => '새 항목을 추가하여 일기를 시작하세요.';

  @override
  String get storyToday => '오늘';

  @override
  String get storyThrowback => '후퇴';

  @override
  String get storyNoThrowback => '오늘은 후퇴가 없어';

  @override
  String get mediaFiles => '미디어 파일';

  @override
  String get mediaEmpty => '아직 사진이 없습니다.';

  @override
  String get mediaEmptyHint => '항목에 첨부된 사진이 여기에 표시됩니다.';

  @override
  String get atlasEmpty => '위치가 포함된 항목이 없습니다.';

  @override
  String get atlasEmptyHint => '위치가 포함된 항목이 여기에 표시됩니다.';

  @override
  String get atlasShowAll => '모든 항목 표시';

  @override
  String get atlasMyLocation => '내 위치';

  @override
  String get coachAll => '모두';

  @override
  String get coachPrograms => '프로그램';

  @override
  String get coachTemplates => '템플릿';

  @override
  String get coachKindProgram => '프로그램';

  @override
  String get coachKindTemplate => '템플릿';

  @override
  String get coachNoTemplates => '프로그램이나 템플릿이 없습니다.';

  @override
  String get coachUseTemplate => '이 템플릿으로 작성하세요';

  @override
  String get coachProgramEverydayTitle => '일상의 순간';

  @override
  String get coachProgramEverydayDescription =>
      '하루에 하나씩 5개의 짧은 질문입니다. 각각 1~2분 정도 걸리며 무엇이 오늘의 하루를 즐겁게 만들었는지 확인하는 데 도움이 됩니다. 매일 조금씩 쓰는 습관을 들이는 부드러운 방법입니다.';

  @override
  String get coachProgramReflectTitle => '내면을 바라보며';

  @override
  String get coachProgramReflectDescription =>
      '5주 동안 일주일에 한 번씩 더 깊은 질문을 합니다. 지금까지 어떤 기분이었는지, 무엇이 당신을 지치게 했는지, 무엇에 감사했는지 등 각각에 대해 시간을 가지십시오.';

  @override
  String get searchFilters => '필터';

  @override
  String get searchFilterTags => '태그';

  @override
  String get searchFilterStarred => '별표 표시됨';

  @override
  String get searchHint => '검색하려면 입력하거나 필터를 선택하세요.';

  @override
  String get locationTitle => '위치';

  @override
  String get locationName => '지명';

  @override
  String get locationRemove => '제거';

  @override
  String get locationServiceDisabled => '위치 서비스가 꺼져 있습니다.';

  @override
  String get locationPermissionDenied => '위치 권한이 거부되었습니다.';

  @override
  String get locationUnavailable => '현재 위치를 가져올 수 없습니다.';

  @override
  String get calendarJumpToToday => '오늘로 이동';

  @override
  String get editorStartWriting => '글쓰기를 시작하거나 ';

  @override
  String get editorTemplateLink => '템플릿';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => '템플릿을 선택하세요';

  @override
  String get templateFeatured => '추천 템플릿';

  @override
  String get templateMine => '내 템플릿';

  @override
  String get templateDailyName => '일일 리뷰';

  @override
  String get templateDailyDescription =>
      '무슨 일이 일어났고, 어떤 느낌이었는지, 그리고 앞으로 일어날 일은 무엇입니까?';

  @override
  String get templateDailyText =>
      '## 오늘 무슨 일이 있었나요\n\n\n## 내가 느낀 점\n\n\n## 감사한 점 세 가지\n1. \n2. \n3. \n\n## 내일\n';

  @override
  String get templateTravelName => '여행 일기 입력';

  @override
  String get templateTravelDescription => '길에서 본 장소, 순간, 음식.';

  @override
  String get templateTravelText =>
      '##내가갔던곳\n\n\n##가장 기억에 남는 순간\n\n\n## 내가 먹은 것\n\n\n## 내일 계획\n';

  @override
  String get templateReadingName => '메모 읽기';

  @override
  String get templateReadingDescription => '당신이 읽은 내용에 대한 인용문과 생각.';

  @override
  String get templateReadingText =>
      '## 예약\n\n\n## 내가 있는 곳\n\n\n## 인용문\n> \n\n## 내 생각\n';

  @override
  String get templateWeeklyName => '주간 검토';

  @override
  String get templateWeeklyDescription => '하이라이트, 어려움, 다음 주의 초점.';

  @override
  String get templateWeeklyText =>
      '## 하이라이트\n\n\n## 무엇이 힘들었나요\n\n\n## 배운 것\n\n\n## 다음 주에 집중하세요\n';

  @override
  String get entrySaveAsTemplate => '템플릿으로 저장';

  @override
  String get entrySavedAsTemplate => '템플릿으로 저장됨';

  @override
  String get storyStatistics => '통계';

  @override
  String get storyMoodChart => '기분 차트';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return '$entries 항목 · $days 일';
  }

  @override
  String get storyThisYear => '올해';

  @override
  String get storyLastYear => '작년';

  @override
  String get storyTapToOpen => '하루를 탭하여 엽니다.';

  @override
  String get settingsGeneralTitle => '일반';

  @override
  String get settingsDataTitle => '데이터 및 스토리지';

  @override
  String get settingsStoriesTitle => '스토리';

  @override
  String get settingsHelpTitle => '도움말 및 정보';

  @override
  String get weatherTitle => '날씨';

  @override
  String get weatherClear => '지우기';

  @override
  String get weatherPartlyCloudy => '약간 흐림';

  @override
  String get weatherCloudy => '흐림';

  @override
  String get weatherFog => '안개';

  @override
  String get weatherDrizzle => '이슬비';

  @override
  String get weatherRain => '비';

  @override
  String get weatherSnow => '눈';

  @override
  String get weatherStorm => '뇌우';

  @override
  String get weatherFetch => '이 항목의 날씨 확인';

  @override
  String get weatherNeedsLocation => '먼저 좌표가 있는 위치를 추가하세요.';

  @override
  String get weatherUnavailable => '이 장소와 시간에는 날씨를 알 수 없습니다.';

  @override
  String get weatherRemove => '날씨 삭제';

  @override
  String get activityTitle => '활동';

  @override
  String get activityStill => '아직도';

  @override
  String get activityWalking => '걷기';

  @override
  String get activityRunning => '달리기';

  @override
  String get activityCycling => '사이클링';

  @override
  String get activityVehicle => '차량 내';

  @override
  String get activityFlying => '비행';

  @override
  String get activityExercise => '운동';

  @override
  String get activityDetect => '현재 활동 감지';

  @override
  String get activityDetectFailed => '활동을 감지할 수 없습니다.';

  @override
  String get activityRemove => '활동 삭제';

  @override
  String get settingsAutoAddTitle => '자동으로 추가';

  @override
  String get settingsAutoAddLocation => '위치';

  @override
  String get settingsAutoAddWeather => '날씨';

  @override
  String get settingsAutoAddHint => '새 항목은 생성될 때 채워집니다.';

  @override
  String get settingsTemperatureUnit => '온도 단위';

  @override
  String get settingsCelsius => '섭씨(°C)';

  @override
  String get settingsFahrenheit => '화씨(°F)';

  @override
  String get moodGreat => '좋아요';

  @override
  String get moodGood => '좋음';

  @override
  String get moodOkay => '알았어';

  @override
  String get moodBad => '나쁨';

  @override
  String get moodAwful => '끔찍하다';

  @override
  String get locationSearchHint => '장소 검색';

  @override
  String get locationSearchEmpty => '장소를 찾을 수 없습니다.';

  @override
  String get settingsWallpaper => '바탕화면';

  @override
  String get wallpaperNone => '없음';

  @override
  String get wallpaperDots => '도트';

  @override
  String get wallpaperGrid => '그리드';

  @override
  String get wallpaperLines => '라인';

  @override
  String get wallpaperPhoto => '사진…';

  @override
  String get settingsFontFamily => '글꼴';

  @override
  String get fontSystem => '시스템';

  @override
  String get fontSerif => '세리프';

  @override
  String get fontMono => '고정 폭';

  @override
  String get settingsFontSize => '글꼴 크기';

  @override
  String get fontSizeSmall => '작은';

  @override
  String get fontSizeMedium => '중간';

  @override
  String get fontSizeLarge => '대형';

  @override
  String get fontSizeExtraLarge => '특대형';

  @override
  String get settingsLineSpacing => '줄 간격';

  @override
  String get lineSpacingCompact => '콤팩트';

  @override
  String get lineSpacingNormal => '보통';

  @override
  String get lineSpacingRelaxed => '편안한';

  @override
  String get moodAssociationsTitle => '무엇이 나를 느끼게 하는가…';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$total 항목 중 $matching';
  }

  @override
  String get videoRecord => '비디오 녹화';

  @override
  String get videoChoose => '동영상을 선택하세요';

  @override
  String get audioRecordTitle => '음성 메모 녹음';

  @override
  String get audioChoose => '오디오 파일을 선택하세요';

  @override
  String get audioStart => '기록';

  @override
  String get audioStop => '중지하고 저장하세요.';

  @override
  String get audioPermissionDenied => '마이크 액세스가 꺼져 있습니다. 시스템 설정에서 허용하세요.';

  @override
  String get mediaTooLarge => '동영상이 너무 커서 첨부할 수 없습니다.';

  @override
  String get mediaUnavailable => '이 첨부파일은 이 기기에서 사용할 수 없습니다.';

  @override
  String get widgetDone => '오늘의 글이 작성되었습니다';

  @override
  String get widgetPending => '오늘 하루는 어땠나요?';

  @override
  String get widgetWrite => '쓰기';

  @override
  String get insertChecklist => '체크리스트';

  @override
  String get insertNumberedList => '번호가 매겨진 목록';

  @override
  String get insertTable => '테이블';

  @override
  String get insertDivider => '분배기';

  @override
  String get insertCodeBlock => '코드 블록';

  @override
  String get journalSortTitle => '항목 정렬';

  @override
  String get journalSortUpdated => '마지막 업데이트';

  @override
  String get settingsTimeFormat => '시간 형식';

  @override
  String get settingsDayStart => '새로운 항목은 전날부터 다음 날까지로 계산됩니다.';

  @override
  String get settingsDayAskUntil => '그럼 언제까지인지 물어보세요';

  @override
  String get settingsDayStartMidnight => '끄기';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      '모든 항목은 작성된 시간 옆에 해당 날짜를 유지하며 언제든지 편집기에서 해당 날짜를 변경할 수 있습니다. 이 시간은 새 항목의 날짜만 선택하므로 이를 변경하면 기존 항목이 이동되지 않습니다.';

  @override
  String get lateNightBadge => '밤늦게 작성하여 전날로 계산';

  @override
  String editorDayAsk(String time) {
    return '$time에 작성되었습니다. 어느 날인가요?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (어제)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (오늘)';
  }

  @override
  String editorWrittenAt(String when) {
    return '$when로 작성됨';
  }

  @override
  String get timeFormat12 => '12시간';

  @override
  String get timeFormat24 => '24시간';

  @override
  String get settingsReminderDays => '나에게 알림';

  @override
  String get locationRecent => '최근 장소';

  @override
  String get shareImage => '이미지 공유';

  @override
  String get shareSaveImage => '이미지 저장';

  @override
  String get shareSaved => '이미지가 저장되었습니다';

  @override
  String get deletedTitle => '최근 삭제됨';

  @override
  String get deletedNone => '최근에 삭제된 항목이 없습니다.';

  @override
  String deletedHint(int days) {
    return '삭제된 항목은 $days일 동안 여기에 남아 있다가 지워집니다.';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days일 남음';
  }

  @override
  String get deletedRestore => '복원';

  @override
  String get deletedDeleteForever => '완전삭제';

  @override
  String get deletedDeleteForeverDescription =>
      '항목과 해당 첨부 파일이 지워집니다. 이 작업은 취소할 수 없습니다.';

  @override
  String get deletedEmpty => '비어 있음';

  @override
  String get deletedEmptyDescription =>
      '최근 삭제됨의 모든 항목을 삭제하시겠습니까? 이 작업은 취소할 수 없습니다.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => '랜덤 워크';

  @override
  String get randomSubtitle => '과거 항목 열기';

  @override
  String get randomNext => '또 다른';

  @override
  String get randomAll => '모두';

  @override
  String get randomWithPhotos => '사진 포함';

  @override
  String get randomGoodDays => '좋은 날들';

  @override
  String get randomEmpty => '선택할 항목이 없습니다.';

  @override
  String get reviewWeekTitle => '이번주';

  @override
  String get reviewWeekSubtitle => '지금까지의 한 주';

  @override
  String get reviewYearTitle => '올해';

  @override
  String get reviewEmpty => '아직 작성된 내용이 없습니다.';

  @override
  String get reviewEntries => '항목';

  @override
  String get reviewDaysWritten => '쓴 일수';

  @override
  String get reviewWords => '단어';

  @override
  String get reviewPhotos => '사진';

  @override
  String get reviewLongestRun => '가장 긴 날';

  @override
  String get reviewAverageMood => '평균 기분';

  @override
  String get reviewFavorites => '가장 자주';

  @override
  String get reviewByMonth => '월별';

  @override
  String get reviewHighlight => '하이라이트';

  @override
  String get yearInPixels => '연도(픽셀)';

  @override
  String get capsuleSeal => '타임캡슐로서의 봉인';

  @override
  String get capsuleTitle => '타임캡슐';

  @override
  String capsuleOpensOn(Object date) {
    return '$date에서 열립니다';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return '$date에 작성됨';
  }

  @override
  String get capsuleOpenEarly => '조기 오픈';

  @override
  String get capsuleOpenEarlyDescription => '이제 캡슐이 열리고 열려 있습니다.';

  @override
  String get capsuleOpened => '타임캡슐이 열렸습니다';

  @override
  String get templateMorningName => '모닝 페이지';

  @override
  String get templateMorningDescription => '3분 안에 하루를 설정하세요';

  @override
  String get templateMorningText =>
      '##오늘 잘하고 싶은 세 가지\n1. \n2. \n3. \n\n## 뭔가 기대되네요\n\n## 나 자신에게 보내는 메모\n';

  @override
  String get templateEveningName => '저녁 리뷰';

  @override
  String get templateEveningDescription => '잘 된 일로 하루를 마무리하다';

  @override
  String get templateEveningText =>
      '## 오늘 좋은 점 세 가지\n1. \n2. \n3. \n\n## 배운 것\n\n## 내일 더 좋아질 수 있는 일\n';

  @override
  String get routineMorning => '좋은 아침';

  @override
  String get routineEvening => '저녁 리뷰';

  @override
  String get settingsRoutinePrompts => '아침저녁 안내';

  @override
  String get settingsRoutinePromptsHint => '스토리에서 아침이나 저녁 템플릿을 제안하세요.';

  @override
  String get checkInTitle => '빠른 체크인';

  @override
  String get checkInSubtitle => '두 번의 탭으로 기분 전환';

  @override
  String get checkInMood => '기분이 어때요?';

  @override
  String get checkInActivity => '뭐하는 거야?';

  @override
  String get checkInNote => '그것에 관한 한 줄 (선택 사항)';

  @override
  String get checkInSave => '저장';

  @override
  String editorWordCount(int words, int characters) {
    return '$words 단어 · $characters 문자';
  }

  @override
  String get coachProgramEverydayTagline => '하루의 작은 일에 주목하세요.';

  @override
  String get coachProgramReflectTagline => '천천히 자신의 말을 들어보세요.';

  @override
  String get coachDuration => '기간';

  @override
  String get coachInterval => '간격';

  @override
  String get coachDifficulty => '난이도';

  @override
  String get coachIntervalDaily => '매일';

  @override
  String get coachIntervalWeekly => '주간';

  @override
  String get coachDifficultyBeginner => '초보자';

  @override
  String get coachDifficultyIntermediate => '중급';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count일',
      one: '1일',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count주',
      one: '1주',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return '일 $n';
  }

  @override
  String coachWeekN(int n) {
    return '주 $n';
  }

  @override
  String get coachEnroll => '등록';

  @override
  String get coachEndProgram => '프로그램 종료';

  @override
  String get coachAuthor => '작성자';

  @override
  String get coachAuthorBio => '이 앱에 대해 작성된 프롬프트입니다.';

  @override
  String get coachEnrolledTip => '모두 설정되었습니다! 귀하의 질문이 스토리에 표시됩니다.';

  @override
  String get coachGoToStories => '스토리로 이동';

  @override
  String get coachAnswerHint => '답을 쓰세요…';

  @override
  String get storyWrapUp => '오늘은 그게 다입니다.';

  @override
  String get storyTapToClose => '탭하여 닫으세요.';

  @override
  String get coachAnswerDone => '완료';

  @override
  String get coachAnswered => '답변됨. 탭하여 열 수 있음';

  @override
  String get coachAnsweredEarlier => '답변됨';

  @override
  String get locationLocating => '찾는 중…';

  @override
  String get locationPickPlace => '장소를 선택하세요';

  @override
  String get locationPlacesHint => '장소의 주소나 이름';

  @override
  String get locationCustom => '맞춤 장소';

  @override
  String get locationCurrent => '현재 위치';

  @override
  String get locationSaved => '저장된 장소';

  @override
  String get locationSearchResults => '검색결과';

  @override
  String get locationNearby => '주변 장소';

  @override
  String get locationRename => '이름 바꾸기';

  @override
  String get locationSavePlace => '장소 저장';

  @override
  String get locationUnsavePlace => '저장된 장소에서 삭제';

  @override
  String get shareAs => '다음 이름으로 공유…';

  @override
  String get shareAsImage => '이미지';

  @override
  String get shareAsZip => '원본 미디어가 포함된 ZIP';

  @override
  String get shareAsPlainText => '일반 텍스트';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'AID Diary에 오신 것을 환영합니다';

  @override
  String get onboardWelcomeText => '여기에서 시작하거나 이미 사용 중인 장치에 이 장치를 연결하세요.';

  @override
  String get onboardStart => '글쓰기 시작';

  @override
  String get helpFaq => '자주 묻는 질문';

  @override
  String get helpFaq1Q => '내 일기는 어디에 저장되나요?';

  @override
  String get helpFaq1A =>
      '귀하의 일기는 이 기기에 저장됩니다. 동기화, 공유 또는 내보내기를 활성화한 경우에만 다른 장치나 저장소에 도달합니다. 동기화는 종단 간 암호화됩니다.';

  @override
  String get helpFaq2Q => '사본을 보관하거나 새 장치로 이동하려면 어떻게 해야 합니까?';

  @override
  String get helpFaq2A =>
      '설정 → 데이터 및 저장소 → 동기화에서 기존 기기에 연결하고 일기가 있는 기기에서 인증을 확인하세요. 두 장치 모두 계속 사용할 수 있습니다. 백업을 생성하고 다른 장치에 복원할 수도 있습니다.';

  @override
  String get helpFaq3Q => '다른 일기 앱에서 항목을 가져올 수 있나요?';

  @override
  String get helpFaq3A =>
      '예: 설정 → 데이터 및 저장소에서 Daylio, Diarium, Diaro, DayBook, My Brain, OneShot 및 Pixels에서 내보내기를 가져오거나 JSON 내보내기를 가져옵니다.';

  @override
  String get helpFaq4Q => '코치 프로그램은 어떻게 진행되나요?';

  @override
  String get helpFaq4A =>
      '코치 페이지에서 프로그램에 등록하세요. 매일 또는 매주 새로운 질문이 스토리에서 기다립니다. 귀하의 답변은 항목으로 저장됩니다.';

  @override
  String get helpFaq5Q => '비밀번호를 잊어버리면 어떻게 되나요?';

  @override
  String get helpFaq5A => '비밀번호는 복구가 불가능하므로 일기를 백업해두세요.';

  @override
  String get helpPrivacy => '개인 정보 보호';

  @override
  String get helpPrivacyText =>
      '일기 콘텐츠와 미디어는 암호화된 동기화를 활성화하거나 공유/내보내지 않는 한 이 기기에 유지됩니다. 지도, 장소 조회 및 날씨는 구성된 서비스를 사용하고 일기 텍스트가 아닌 해당 요청에 필요한 위치 또는 검색어를 보냅니다.';

  @override
  String get photoMetaTitle => '사진의 세부정보를 사용하시겠습니까?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return '사진에 기록된 대로 이 항목을 $date로 계산하고 해당 위치를 $place로 설정하시겠습니까?';
  }

  @override
  String photoMetaDate(String date) {
    return '사진이 촬영되었을 때 $date에 대한 이 항목을 계산하시겠습니까?';
  }

  @override
  String photoMetaPlace(String place) {
    return '이 항목의 위치를 사진을 찍은 $place로 설정하시겠습니까?';
  }

  @override
  String get photoMetaApply => '사용하세요';

  @override
  String get quickWriteTitle => '빠른 쓰기';

  @override
  String get quickWriteText => '새 항목을 시작하려면 탭하세요.';

  @override
  String get settingsQuickWriteTitle => '알림에 빠르게 쓰기';

  @override
  String get settingsQuickWriteDescription => '새 항목을 여는 알림을 유지합니다.';

  @override
  String get settingsNudgesTitle => '조용히 스트레칭을 한 후 날 살짝 밀어주세요';

  @override
  String settingsNudgesDescription(int days) {
    return '$days일 동안 글을 쓰지 않았을 때 알려주는 부드러운 알림입니다.';
  }

  @override
  String get nudgeTitle => '오랜만이야';

  @override
  String get nudgeMonday => '새로운 한 주: 무엇을 기대하시나요?';

  @override
  String get nudgeTuesday => '두 줄이면 충분합니다. 오늘 기분이 어떠세요?';

  @override
  String get nudgeWednesday => '일주일의 절반. 지금까지 눈에 띄는 것은 무엇입니까?';

  @override
  String get nudgeThursday => '오늘부터 간직할 가치가 있는 작은 일이 있나요?';

  @override
  String get nudgeFriday => '한 주가 마무리되고 있습니다. 좋은 순간을 기록해 보세요.';

  @override
  String get nudgeSaturday => '느린 토요일은 글을 쓰기 좋은 날이다.';

  @override
  String get nudgeSunday => '끝나기 전 일주일을 되돌아보세요.';

  @override
  String get photoWidgetEmpty => '항목에 추가한 사진이 여기에 표시됩니다.';

  @override
  String get channelReminders => '알림';

  @override
  String get channelOnThisDay => '이날';

  @override
  String get channelCoach => '코치 프롬프트';

  @override
  String get channelNudges => '조용한 날 이후에 넛지';

  @override
  String get channelQuickWrite => '빠른 쓰기';

  @override
  String get channelBackup => '백업';

  @override
  String get formatJsonExport => 'JSON (AID Diary 내보내기)';

  @override
  String get aboutModifiedNotice =>
      'Demizo와 기여자들이 만든 Daily You의 수정 버전입니다. 공식 Daily You 앱이 아닙니다.';

  @override
  String get toolbarPhotos => '사진 추가';

  @override
  String get toolbarMedia => '사진 및 비디오';

  @override
  String get mediaFromGallery => '갤러리에서 선택';

  @override
  String get mediaFromFiles => '파일에서 선택';

  @override
  String get editorLeaveTitle => '이 항목을 저장하시겠습니까?';

  @override
  String get editorLeaveDiscard => '저장하지 않음';

  @override
  String get editorTitleHint => '제목';

  @override
  String get editorLocating => '찾는 중…';

  @override
  String get toolbarVideo => '비디오';

  @override
  String get toolbarAudio => '음성 메모';

  @override
  String get toolbarTags => '태그';

  @override
  String get toolbarBulletList => '글머리 기호 목록';

  @override
  String get toolbarHeading => '제목';

  @override
  String get toolbarBold => '굵게';

  @override
  String get toolbarItalic => '이탤릭체';

  @override
  String get toolbarHighlight => '하이라이트';

  @override
  String get toolbarStrikethrough => '취소선';

  @override
  String get toolbarQuote => '견적';

  @override
  String get toolbarLink => '링크';

  @override
  String get toolbarInsert => '삽입';

  @override
  String get toolbarUndo => '실행 취소';

  @override
  String get toolbarRedo => '다시 실행';

  @override
  String get toolbarInsertDate => '날짜를 삽입하세요';

  @override
  String get toolbarInsertTime => '시간을 삽입하세요';

  @override
  String get settingsSyncTitle => '클라우드 동기화';

  @override
  String get syncOffDescription =>
      'Google Drive 또는 Nextcloud, Synology 또는 Jianguoyun과 같은 WebDAV 서버를 통해 모든 장치에서 이 일기장을 동일하게 유지하세요.';

  @override
  String get syncUseGoogleDrive => 'Google Drive와 동기화';

  @override
  String get syncOrWebDav => '또는 WebDAV 서버';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn => '로그인되었습니다. AID Diary로 돌아갈 수 있습니다.';

  @override
  String get syncGoogleSignInAgain => 'Google에 다시 로그인해야 합니다.';

  @override
  String get syncSignInAgain => '다시 로그인';

  @override
  String get settingsCommandLineTitle => '명령줄';

  @override
  String get commandLineToggle => '명령줄 인터페이스';

  @override
  String get commandLineToggleHint =>
      '이 장치의 지원 명령 및 기타 프로그램이 앱 명령을 사용할 수 있도록 합니다.';

  @override
  String get commandLineAlwaysOn => '개발 빌드에서는 항상 켜져 있습니다.';

  @override
  String commandLineListening(int port) {
    return '포트 $port에서 수신 중';
  }

  @override
  String get commandPaletteTitle => '모든 명령';

  @override
  String get commandPaletteSearch => '검색 명령';

  @override
  String get commandPaletteRun => '실행';

  @override
  String get commandPaletteConfirm => '이 작업은 간단히 취소할 수 없습니다. 실행하시겠습니까?';

  @override
  String syncReceiving(int done, int total) {
    return '$total의 $done를 수신 중…';
  }

  @override
  String syncSending(int done, int total) {
    return '$total 중 $done를 보내는 중…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'Google Drive에 대한 액세스가 허용되지 않았습니다. 다시 연결하고 Google 페이지에서 Google Drive를 선택하세요.';

  @override
  String get syncEntryUnsynced => '동기화되지 않음: 마지막 동기화가 진행되지 않았습니다.';

  @override
  String get syncUseOfficial => 'AID 동기화 서버 사용';

  @override
  String get syncServer => '서버 주소';

  @override
  String get syncUsername => '사용자 이름';

  @override
  String get syncPassword => '비밀번호';

  @override
  String get syncConnect => '연결하다';

  @override
  String get syncConnecting => '연결 중…';

  @override
  String get syncSignInFailed => '로그인할 수 없습니다. 주소, 사용자 이름, 비밀번호를 확인하세요.';

  @override
  String syncConnectFailed(String error) {
    return '연결할 수 없습니다: $error';
  }

  @override
  String get syncNewSpaceTitle => '동기화 시작';

  @override
  String get syncNewSpaceDescription =>
      '여기에는 아직 동기화된 일기가 없습니다. 이 일기는 귀하의 기기에 보관된 키로 엔드투엔드 암호화되어 업로드됩니다.';

  @override
  String get syncJoinTitle => '동기화된 일기에 참여하세요';

  @override
  String get syncWrongKey => '이 복구 코드는 동기화된 일기장을 열지 않습니다.';

  @override
  String syncLastSynced(String time) {
    return '마지막 동기화 $time';
  }

  @override
  String get syncNever => '아직 동기화되지 않음';

  @override
  String get syncSyncing => '동기화 중…';

  @override
  String syncFailed(String error) {
    return '마지막 동기화 실패: $error';
  }

  @override
  String get syncLocked =>
      '동기화된 일기는 이제 다른 장치에 속하거나 처음부터 다시 시작되었습니다. 그 중 하나와 페어링하거나 복구 코드를 사용하여 계속 동기화하세요.';

  @override
  String get syncNow => '지금 동기화';

  @override
  String get syncUnlock => '잠금 해제';

  @override
  String get syncEncrypted => '엔드 투 엔드 암호화';

  @override
  String get syncDisconnect => '동기화 중지';

  @override
  String get syncDisconnectDescription =>
      '이 장치는 동기화를 중지합니다. 이곳의 일기장과 동기화된 사본은 그대로 유지됩니다.';

  @override
  String get syncOwnRecoveryPassword => '내 복구 비밀번호 사용';

  @override
  String get syncRecoveryPassword => '복구 비밀번호';

  @override
  String get syncRecoveryPasswordRepeat => '복구 비밀번호를 반복하세요';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return '최소한 $min 문자를 사용하세요';
  }

  @override
  String get syncRecoveryPasswordMismatch => '비밀번호가 다릅니다';

  @override
  String get syncRecoveryCode => '복구 코드';

  @override
  String get syncRecoveryCodeTitle => '복구 코드 저장';

  @override
  String get syncRecoveryCodeDescription =>
      '귀하의 기기를 모두 분실한 경우 이 코드는 동기화된 일기를 복원합니다. 비밀번호 관리자나 종이에 보관하세요. 이번 한 번만 표시됩니다.';

  @override
  String get syncRecoveryCodeCopied => '복구 코드가 복사되었습니다.';

  @override
  String get syncRecoveryCodeSaved => '나는 그것을 저장했다';

  @override
  String get syncJoinNeedsKey =>
      '이 동기화된 일기는 다른 기기에 속합니다. 그 중 하나와 페어링하거나 복구 코드를 사용하세요. 이 장치의 항목이 장치에 추가됩니다.';

  @override
  String get syncPairDevice => '장치와 페어링';

  @override
  String get syncUseRecoveryCode => '복구 코드 사용';

  @override
  String get syncAddDevice => '장치 추가';

  @override
  String get syncChangeRecoveryCode => '복구 코드 변경';

  @override
  String get syncChangeRecoveryDescription =>
      '새로운 코드가 현재 코드를 대체하며 작동이 중지됩니다. 귀하의 데이터와 기타 장치는 그대로 유지됩니다.';

  @override
  String get syncNewRandomCode => '새로운 무작위 코드';

  @override
  String get syncRecoveryCodeChanged => '복구 코드가 변경되었습니다.';

  @override
  String get syncResetSpace => '동기화된 일기를 다시 시작하세요';

  @override
  String get syncResetSpaceDescription =>
      '더 이상 장치나 복구 코드가 열리지 않는 경우에만: 동기화된 사본은 이 장치의 키 아래에 있는 이 장치의 일기로 대체됩니다. 그런 다음 다른 장치를 다시 페어링하세요.';

  @override
  String get syncPairTitle => '장치 페어링';

  @override
  String get syncPairShow => '코드 표시';

  @override
  String get syncPairEnter => '코드를 입력하세요';

  @override
  String get syncPairShowHint =>
      '다른 장치에서 장치 페어링을 열고 코드 입력을 선택한 후 이를 입력하거나 스캔하세요.';

  @override
  String get syncPairEnterHint => '다른 장치에 표시되는 코드를 입력하거나 스캔하세요.';

  @override
  String get syncPairCode => '페어링 코드';

  @override
  String get syncPairScan => '스캔';

  @override
  String get syncPairStart => '쌍';

  @override
  String get syncPairWaiting => '다른 기기를 기다리는 중…';

  @override
  String syncPairDone(String device) {
    return '$device와 페어링됨';
  }

  @override
  String get syncPairWrongCode => '코드가 일치하지 않습니다. 새 코드를 표시하고 다시 시도하세요.';

  @override
  String get syncPairNoOffer => '이 코드를 표시하는 기기가 없습니다. 만료되었을 수 있습니다.';

  @override
  String get syncPairTimedOut => '다른 장치가 제 시간에 응답하지 않았습니다.';

  @override
  String get syncPairNeither => '아직 두 기기 모두 이 동기화된 일기로 설정되지 않았습니다.';

  @override
  String get syncPairBoth => '두 기기 모두 이미 이 동기화된 일기를 열고 있습니다.';

  @override
  String syncPairFailed(String error) {
    return '페어링 실패: $error';
  }

  @override
  String get syncMediaPending => '일기가 동기화되었습니다. 일부 미디어가 아직 전송 중입니다.';

  @override
  String get syncWaitingForDevices => '일기가 동기화됨 · 다른 기기가 미디어를 전송하기를 기다리는 중';

  @override
  String get syncCacheNotice =>
      '클라우드 미디어는 일시적입니다. 원본을 장치에 보관하세요. 동기화는 백업이 아닙니다.';

  @override
  String get paperTitle => '편지지';

  @override
  String get paperPlain => '평야';

  @override
  String get paperLined => '안감';

  @override
  String get paperGrid => '그리드';

  @override
  String get paperTinted => '착색된';

  @override
  String get paperDecorationTitle => '장식';

  @override
  String get paperDecorationNone => '없음';

  @override
  String get paperDecorationBotanical => '나뭇잎';

  @override
  String get paperDecorationStars => '별';

  @override
  String get paperDecorationWashi => '와시 테이프';

  @override
  String get themeDarkChoice => '어두운 외관';

  @override
  String get themeDarkSame => '라이트 팔레트를 따르세요';

  @override
  String get themeDarkCustom => '별도의 팔레트';

  @override
  String get themeDarkAccent => '어두운 액센트 컬러';

  @override
  String get themeColorTeal => '청록색';

  @override
  String get themeColorCyan => '청록색';

  @override
  String get themeColorIndigo => '인디고';

  @override
  String get themeColorCoral => '산호';

  @override
  String get themeColorOlive => '올리브';

  @override
  String get themeColorSlate => '슬레이트';

  @override
  String get drawingTitle => '그리기';

  @override
  String get drawingPen => '펜';

  @override
  String get drawingEraser => '지우개';

  @override
  String get drawingUndo => '실행 취소';

  @override
  String get drawingClear => '지우기';

  @override
  String get drawingWidth => '펜 폭';

  @override
  String get drawingStylusOnly => '스타일러스만';

  @override
  String get drawingDiscardTitle => '그림을 삭제하시겠습니까?';

  @override
  String get drawingDiscardBody => '이 그림은 저장되지 않았습니다.';

  @override
  String get drawingSaveError => '그림을 저장할 수 없습니다.';

  @override
  String get syncNetworkTitle => '네트워크 진단';

  @override
  String get syncNetworkRefresh => '새로고침';

  @override
  String get syncNetworkSelectedRoute => '현재 경로';

  @override
  String get syncNetworkAvailableRoutes => '사용 가능한 경로';

  @override
  String get syncNetworkSignaling => '장치 디렉토리 연결';

  @override
  String get syncNetworkRelayRemaining => '남은 릴레이 수당';

  @override
  String get syncNetworkIcePair => '직접 연결 후보';

  @override
  String get syncNetworkPeerTrusted => '인증된 기기';

  @override
  String get syncNetworkNoRoute => '연결을 기다리는 중';

  @override
  String get syncNetworkUnavailable => '진단을 사용할 수 없습니다.';

  @override
  String get syncMediaCopiesTitle => '미디어 전달 및 사본';

  @override
  String get syncMediaPendingCount => '전송 대기 중';

  @override
  String get syncMediaDurableCount => '개인 창고로 배송됨';

  @override
  String get syncMediaTemporaryCount => '임시 또는 확인되지 않은 사본';

  @override
  String get syncMediaReceiptExplanation =>
      '이러한 수는 남아 있는 백업에 대한 새로운 감사가 아닌 완료된 전달을 나타냅니다.';

  @override
  String get syncMediaCacheExplanation =>
      '임시 클라우드 미디어는 만료될 수 있습니다. 원본을 보관하거나 별도의 백업을 보관하세요.';

  @override
  String get momentsTitle => '사진 순간';

  @override
  String get momentsHint =>
      '현지 포토타임과 선택적 좌표를 사용하여 그룹을 찾아보세요. 카드를 선택하셔야만 사진이 첨부됩니다.';

  @override
  String get momentsScan => '순간 찾기';

  @override
  String get momentsChooseFolder => '사진 폴더 선택';

  @override
  String get momentsLocation => '사진 위치 포함';

  @override
  String get momentsEmpty => '최근 사진 그룹이 없습니다.';

  @override
  String get momentsCreate => '이 사진에 대해 쓰세요';

  @override
  String get momentsDismiss => '닫기';

  @override
  String get momentsError => '현지 사진을 읽을 수 없습니다.';

  @override
  String get momentsCreated => '사진 항목이 생성되었습니다.';

  @override
  String get momentsPermission => '지역 추천을 찾으려면 사진에 대한 액세스를 허용하세요.';

  @override
  String get momentsScope => '최근 사진만; 카드당 사진 최대 500장, 사진 20장.';

  @override
  String momentsPhotoCount(int count) {
    return '$count 사진';
  }

  @override
  String get nearbyTitle => '장치 연결';

  @override
  String get nearbySend => '다른 장치 승인';

  @override
  String get nearbyReceive => '기존 장치에 연결';

  @override
  String get nearbyInstructions =>
      '두 장치를 동일한 Wi-Fi에 연결하거나 서로의 핫스팟에 연결합니다. 기존 장치에 대한 승인을 확인합니다. 두 장치 모두 계속 사용할 수 있습니다. 인터넷이 필요하지 않습니다.';

  @override
  String get nearbyCompare => '승인하기 전에 두 기기에서 이 코드를 비교하세요.';

  @override
  String get nearbyConfirm => '코드가 일치합니다';

  @override
  String get nearbyScan => '다른 기기의 코드를 스캔하세요';

  @override
  String get nearbyPaste => '초대 붙여넣기';

  @override
  String get nearbyWaiting => '다른 기기에서 승인을 기다리는 중';

  @override
  String get nearbyWorking => '일기와 첨부 파일을 승인하고 동기화하는 중…';

  @override
  String get nearbyPending =>
      '일부 첨부파일은 아직 동기화가 필요합니다. 다른 장치를 온라인 상태로 유지하고 다시 시도하십시오.';

  @override
  String get nearbyComplete => '장치가 연결되었습니다. 일기와 첨부 파일이 동기화되었습니다.';

  @override
  String get nearbyFailed => '연결이 완료되지 않았습니다. 로컬 연결을 확인하고 다시 시도하세요.';

  @override
  String get nearbyEmptyRequired => '아직 동기화에 연결되지 않은 빈 다이어리가 있는 기기를 사용하세요.';

  @override
  String get nearbyRetry => '계속 동기화';

  @override
  String get nearbyWifi => 'Wi-Fi 설정';

  @override
  String get nearbyHotspot => '핫스팟 설정';

  @override
  String get nearbyKeepOpen => '새 장치가 완료될 때까지 이 페이지를 열어 두세요. 초대는 2분 후에 만료됩니다.';

  @override
  String get syncDevicesTitle => '승인된 장치';

  @override
  String get syncDevicesDescription =>
      '승인된 장치만 이 AID 계정에 액세스할 수 있습니다. 장치를 취소하면 서버가 차단되지만 이미 복사된 마스터 키나 일기는 지울 수 없습니다.';

  @override
  String get syncDeviceRequest => '승인된 장치에 이 승인 QR을 표시하세요.';

  @override
  String get syncDeviceAuthorize => '장치 승인';

  @override
  String get syncDeviceAuthorizeDescription => '새 기기의 인증 요청을 스캔하거나 붙여넣으세요.';

  @override
  String get syncDeviceRevoke => '취소';

  @override
  String get syncDeviceRotate => '이 기기의 서명 키 순환';

  @override
  String get syncDeviceCheck => '승인 확인';

  @override
  String get syncDeviceHardware => '하드웨어 지원 서명 키';

  @override
  String get syncDeviceSoftware => '내보낼 수 없는 소프트웨어 서명 키';

  @override
  String get syncDeviceUnavailable =>
      '기기 인증을 사용할 수 없습니다. 승인된 다른 장치에서 이 장치를 승인하고 다시 시도하세요.';

  @override
  String get syncDeviceRevoked => '취소됨';

  @override
  String get syncDeviceLocal => '이 장치';

  @override
  String get cloudTrafficTitle => '미디어 파일의 월별 클라우드 데이터 전송 할당량';

  @override
  String get cloudTrafficLimit => '월간 데이터 전송 할당량';

  @override
  String get cloudTrafficUsed => '사용된 데이터 전송';

  @override
  String get cloudTrafficRemaining => '남은 데이터 전송량';

  @override
  String cloudTrafficResetsAt(String time) {
    return '데이터 전송 할당량이 $time를 재설정합니다.';
  }

  @override
  String get cloudTrafficExhausted =>
      '미디어 파일의 클라우드 데이터 전송 할당량이 모두 사용되었습니다. 누락된 미디어 파일은 직접 연결이 가능하거나 할당량이 재설정되면 자동으로 동기화됩니다.';

  @override
  String get cloudTrafficExplanation =>
      '미디어 파일 캐싱과 라이브 릴레이는 이 데이터 전송 할당량을 공유합니다. 직접 연결에서는 이를 소비하지 않습니다. 일기 텍스트와 연결 제어 메시지에는 별도의 작은 일일 한도가 있습니다.';

  @override
  String get appearanceThemeSection => '앱 테마';

  @override
  String get appearancePaperSection => '일기장';

  @override
  String get appearanceTypographySection => '일기 텍스트';

  @override
  String get appearancePreferencesSection => '일반 환경설정';

  @override
  String get themeSystemAccentHint =>
      '사용자 정의 색상 대신 시스템 팔레트를 사용합니다. 직접 선택하려면 이 기능을 끄세요.';

  @override
  String get syncDeviceNameSaveFailed => '장치 이름을 저장할 수 없습니다. 다시 시도해 주세요.';

  @override
  String get nearbyConnectionHelp => '연결 도움말';

  @override
  String get syncAllSynced => '모든 것이 동기화되었습니다.';

  @override
  String get syncDetailsTitle => '동기화 세부정보';

  @override
  String get syncMore => '추가 옵션';

  @override
  String get syncDeviceName => '장치 이름';

  @override
  String get syncDeviceNameHint => '예: 내 태블릿';

  @override
  String get syncDeviceNameInvalid => '1~32자를 사용하세요.';

  @override
  String get syncDeviceKeyDetails => '보안 세부정보';

  @override
  String get syncConnectionProblem => '지금은 동기화할 수 없습니다. 자동으로 다시 시도하는 중입니다.';

  @override
  String get syncCopyComplete => '일기 및 미디어 파일의 전체 사본';

  @override
  String get syncCopyPartial => '일부 미디어가 아직 누락되었습니다.';

  @override
  String get syncCopyOlder => '새로운 변경사항이 동기화 대기 중입니다.';

  @override
  String get syncCopyUnavailable => '세부정보 복사가 불가능합니다. 나중에 다시 시도하세요.';

  @override
  String get syncCopyLastKnown =>
      '다른 장치에는 마지막으로 확인된 복사본이 표시됩니다. 지금은 오프라인 장치를 확인할 수 없습니다.';

  @override
  String get syncCopyTemporary => '임시 캐시. 원본을 장치에 보관하세요.';

  @override
  String get syncCopyStorage => '동기화 저장소. 완료된 미디어 업로드가 진단에 나열됩니다.';

  @override
  String syncCopyChecked(String time) {
    return '마지막으로 확인된 $time';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return '이번달 남은 데이터 전송량 : $remaining / $limit';
  }

  @override
  String get onboardNewDiary => '여기서 시작하세요';

  @override
  String get onboardConnect => '기존 장치에 연결';

  @override
  String get onboardFailed => '설정을 완료할 수 없습니다. 귀하의 일기장은 안전합니다. 다시 시도해 주세요.';

  @override
  String get tutorialTitle => '다이어리 사용법';

  @override
  String get tutorialWriteTitle => '첫 일기 쓰기';

  @override
  String get tutorialWriteText =>
      '+를 눌러 일기를 작성하세요. 선택적 제목을 추가하고 일기 날짜를 선택한 다음 확인 표시를 탭하여 저장합니다. 언제든지 일기 항목을 다시 편집할 수 있습니다.';

  @override
  String get tutorialMediaTitle => '사진, 오디오, 필기 추가';

  @override
  String get tutorialMediaText =>
      '일기 편집기에서 +를 사용하여 사진, 동영상, 음성 녹음을 첨부하거나 필기 캔버스를 엽니다. 이러한 첨부 파일은 일기 항목과 함께 저장됩니다.';

  @override
  String get tutorialReviewTitle => '다시 하루를 찾아';

  @override
  String get tutorialReviewText =>
      '일기나 달력을 찾아보고, 쓴 글을 검색하고, 태그를 사용하여 항목을 정리하세요. 미디어 및 아틀라스 페이지에서는 사진이나 위치별로 과거 항목을 찾을 수 있습니다.';

  @override
  String get tutorialSyncTitle => '두 개 이상의 장치 사용';

  @override
  String get tutorialSyncText =>
      '설정 → 데이터 및 저장소 → 동기화에서 기존 기기에 연결하고 해당 기기에서 연결을 승인하세요. 두 기기 모두 계속 사용할 수 있습니다. 일기 본문이 먼저 동기화되며, 첨부 파일은 연결 상태와 남은 전송량에 따라 순차적으로 동기화됩니다.';

  @override
  String get tutorialPrivacyTitle => '일기장을 안전하게 보관하세요';

  @override
  String get tutorialPrivacyText =>
      '일기 항목은 동기화, 공유 또는 내보내기를 활성화하지 않는 한 이 기기에 유지됩니다. 동기화는 종단 간 암호화됩니다. 설정에서 앱 비밀번호를 설정하고, 백업을 생성하고, 이 튜토리얼을 다시 열 수도 있습니다.';

  @override
  String get editorDiaryDay => '일기 날짜';

  @override
  String get editorDiaryDayPicker => '일기 날짜 · 이 일기는 어느 날의 일기인가요?';

  @override
  String editorCreatedAt(String time) {
    return '작성 $time';
  }

  @override
  String get editorDiaryDayHint => '이 일기가 속하는 날짜입니다. 날짜를 바꿔도 생성 시간은 바뀌지 않습니다.';

  @override
  String get hiddenDiaryTitle => '숨긴 일기';

  @override
  String get hiddenDiaryHide => '일기 숨기기';

  @override
  String get hiddenDiaryShow => '일기 숨기기 해제';

  @override
  String get hiddenDiaryEmpty => '숨긴 일기가 없습니다';

  @override
  String get hiddenDiaryUnlock => '숨긴 일기 잠금 해제';

  @override
  String get hiddenDiaryAuthHint => '앱 잠금 또는 기기의 화면 잠금을 사용하세요.';

  @override
  String get moodClear => '기분 지우기';

  @override
  String get scrollToTop => '맨 위로';

  @override
  String get feedbackTitle => '의견 보내기';

  @override
  String get feedbackHint => '문제나 제안을 설명해 주세요';

  @override
  String get feedbackGithub => 'GitHub 이슈';

  @override
  String get feedbackEmail => '이메일 보내기';

  @override
  String get feedbackCopy => '텍스트 복사';

  @override
  String get feedbackLaunchFailed => '앱을 열 수 없습니다. 텍스트를 복사하여 아래 이메일을 이용해 주세요.';

  @override
  String get feedbackCopied => '의견이 복사됨';
}
