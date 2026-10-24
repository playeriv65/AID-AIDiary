// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'AID Diary';

  @override
  String get themeColorTitle => 'Màu chủ đề';

  @override
  String get themeColorHint => 'Chọn một màu cho bảng màu này.';

  @override
  String get themeColorBlue => 'Xanh da trời';

  @override
  String get themeColorGreen => 'Rừng xanh';

  @override
  String get themeColorBrown => 'Cà phê ấm';

  @override
  String get themeColorPurple => 'hoa oải hương';

  @override
  String get themeColorRose => 'hoa hồng bụi';

  @override
  String get themeColorAmber => 'Hổ phách';

  @override
  String get themeColorPreview => 'Một chút mỗi ngày';

  @override
  String get themeTintBackgroundTitle => 'Màu nền với màu chủ đề';

  @override
  String get themeTintBackgroundHint =>
      'Tắt cho nền màu xám trung tính; các nút giữ màu bạn đã chọn.';

  @override
  String get dailyReminderTitle => 'Ghi chép hôm nay!';

  @override
  String get dailyReminderDescription =>
      'Hãy ghi chép nhật ký hàng ngày của bạn…';

  @override
  String get actionTakePhoto => 'Chụp ảnh';

  @override
  String get flashbacksTitle => 'Hồi tưởng';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Loại trừ những ngày tệ';

  @override
  String get flashbackGoodDay => 'Một Ngày Tốt lành';

  @override
  String get flashbackRandomDay => 'Một ngày ngẫu nhiên';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tuần trước',
      one: '$count Tuần trước',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tháng trước',
      one: '$count Tháng trước',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count năm trước',
      one: '$count Năm trước',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'Vào ngày này';

  @override
  String get searchLogsHint => 'Tìm kiếm Nhật ký…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mục nhật ký',
      one: 'Nhật ký $count',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ngày',
      one: 'ngày $count',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count từ',
      one: 'từ $count',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Không có nhật ký…';

  @override
  String get noResults => 'Không có kết quả…';

  @override
  String get sortOrderAscendingTitle => 'Tăng dần';

  @override
  String get sortOrderDescendingTitle => 'Giảm dần';

  @override
  String get pageStatisticsTitle => 'Thống kê';

  @override
  String get statisticsNotEnoughData => 'Không đủ dữ liệu…';

  @override
  String get statisticsRangeOneMonth => '1 tháng';

  @override
  String get statisticsRangeSixMonths => '6 tháng';

  @override
  String get statisticsRangeOneYear => '1 năm';

  @override
  String get statisticsRangeAllTime => 'Mọi thời gian';

  @override
  String chartSummaryTitle(Object tag) {
    return 'Tóm tắt $tag';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag Theo ngày';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag theo thời gian';
  }

  @override
  String get chartGroupingLabel => 'Nhóm theo';

  @override
  String get chartGroupingDay => 'ngày';

  @override
  String get chartGroupingWeek => 'Tuần';

  @override
  String get chartGroupingMonth => 'Tháng';

  @override
  String get chartGroupingYear => 'Năm';

  @override
  String get chartSmoothingLabel => 'Làm mịn';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Chuỗi hiện tại $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Chuỗi dài nhất $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Những Ngày Tuyệt Vời $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Những ngày kể từ một ngày tồi tệ $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Không thể truy cập bộ nhớ ngoài';

  @override
  String get errorExternalStorageAccessDescription =>
      'Nếu bạn đang sử dụng bộ nhớ mạng, hãy đảm bảo dịch vụ này trực tuyến và bạn có quyền truy cập mạng.\n\nNếu không, ứng dụng có thể đã mất quyền đối với thư mục bên ngoài. Đi tới cài đặt và chọn lại thư mục bên ngoài để cấp quyền truy cập.\n\nCảnh báo, các thay đổi sẽ không được đồng bộ hóa cho đến khi bạn khôi phục quyền truy cập vào vị trí lưu trữ bên ngoài!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Tiếp tục với Cơ sở dữ liệu cục bộ';

  @override
  String get lastModified => 'Đã sửa đổi';

  @override
  String get writeSomethingHint => 'Viết cái gì đó…';

  @override
  String get titleHint => 'Tiêu đề…';

  @override
  String get deleteLogTitle => 'Xóa mục nhật ký';

  @override
  String get deleteLogDescription =>
      'Mục nhập sẽ chuyển đến Đã xóa gần đây, nơi bạn có thể khôi phục nó.';

  @override
  String get deletePhotoTitle => 'Xóa tệp đính kèm';

  @override
  String get deletePhotoDescription =>
      'Bạn có chắc chắn muốn xóa tệp đính kèm này không?';

  @override
  String get pageSettingsTitle => 'Cài đặt';

  @override
  String get settingsTheme => 'chủ đề';

  @override
  String get themeSystem => 'Hệ thống';

  @override
  String get themeLight => 'Ánh sáng';

  @override
  String get themeDark => 'Tối';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Ngày Đầu Tuần';

  @override
  String get settingsCalendarSystem => 'Hệ thống lịch';

  @override
  String get calendarSystemGregorian => 'Lịch Gregory';

  @override
  String get calendarSystemJalali => 'Jalali';

  @override
  String get settingsUseSystemAccentColor => 'Sử dụng màu nhấn hệ thống';

  @override
  String get settingsCustomAccentColor => 'Màu nhấn tùy chỉnh';

  @override
  String get settingsShowFlashbacks => 'Hiển thị đoạn hồi tưởng';

  @override
  String get settingsChangeMoodIcons => 'Thay đổi biểu tượng tâm trạng';

  @override
  String get moodIconPrompt => 'Nhập một biểu tượng';

  @override
  String get settingsHideImages => 'Ẩn hình ảnh';

  @override
  String get pageCalendarTitle => 'Lịch';

  @override
  String get settingsNotificationsTitle => 'Thông báo';

  @override
  String get settingsDailyReminderTitle => 'Nhắc nhở hàng ngày';

  @override
  String get settingsOnThisDayDescription => 'Tìm lại ký ức xưa';

  @override
  String get settingsDailyReminderDescription =>
      'Lời nhắc nhở nhẹ nhàng mỗi ngày';

  @override
  String get settingsReminderTime => 'Thời gian nhắc nhở';

  @override
  String get settingsFixedReminderTimeTitle => 'Thời gian nhắc nhở cố định';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Chọn thời gian cố định để nhắc nhở';

  @override
  String get settingsAlwaysSendReminderTitle => 'Luôn gửi lời nhắc';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Gửi lời nhắc ngay cả khi mục nhật ký đã được bắt đầu';

  @override
  String get settingsCustomizeNotificationTitle => 'Tùy chỉnh thông báo';

  @override
  String get settingsTemplatesTitle => 'Mẫu';

  @override
  String get manageTemplates => 'Quản lý mẫu';

  @override
  String get noTemplateTitle => 'không có';

  @override
  String get noTemplatesDescription => 'Chưa có mẫu nào được tạo…';

  @override
  String get templateDefaultTimestampTitle => 'Dấu thời gian';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Tóm tắt ngày';

  @override
  String get templateDefaultSummaryBody =>
      '### Tóm tắt\n- \n\n### Trích dẫn\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Sự phản ánh';

  @override
  String get templateDefaultReflectionBody =>
      '### Hôm nay bạn thích điều gì?\n- \n\n### Bạn biết ơn vì điều gì?\n- \n\n### Bạn đang mong chờ điều gì?\n- ';

  @override
  String get settingsTagsTitle => 'Thẻ';

  @override
  String get manageTags => 'Quản lý thẻ';

  @override
  String get tagTypeLabelTitle => 'Nhãn';

  @override
  String get tagTypeTrackerTitle => 'Trình theo dõi';

  @override
  String get nameHint => 'Tên';

  @override
  String get tagColorLabel => 'Màu sắc';

  @override
  String get iconPickerTitle => 'Chọn biểu tượng';

  @override
  String get iconPickerIconsTab => 'Biểu tượng';

  @override
  String get iconPickerCustomTab => 'tùy chỉnh';

  @override
  String get iconPickerSearchHint => 'Biểu tượng tìm kiếm…';

  @override
  String get colorPickerTitle => 'chọn màu';

  @override
  String get colorPickerPaletteTab => 'Màu sắc';

  @override
  String get iconGroupMoodPeople => 'Tâm trạng và con người';

  @override
  String get iconGroupHealth => 'sức khỏe';

  @override
  String get iconGroupWorkFinance => 'Công việc & Tài chính';

  @override
  String get iconGroupHabitsGoals => 'Thói quen và mục tiêu';

  @override
  String get iconGroupNature => 'thiên nhiên';

  @override
  String get iconGroupFoodDrink => 'Đồ ăn & Đồ uống';

  @override
  String get iconGroupHome => 'Trang chủ';

  @override
  String get iconGroupTravel => 'du lịch';

  @override
  String get iconGroupSymbols => 'Ký hiệu';

  @override
  String get tagCategoryLabel => 'Danh mục';

  @override
  String get tagLabel => 'Gắn thẻ';

  @override
  String get tagCategoryUncategorized => 'Chưa được phân loại';

  @override
  String get newCategoryTitle => 'Danh mục mới';

  @override
  String get shareButtonLabel => 'Chia sẻ';

  @override
  String get importErrorDescription => 'Không thể nhập tệp!';

  @override
  String get exportErrorDescription => 'Không thể xuất tệp!';

  @override
  String get deleteTitle => 'Xóa';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Nó được sử dụng trong $count mục nhật ký.',
      one: ' Nó được sử dụng trong 1 nhật ký.',
      zero: '',
    );
    return 'Delete \"$name\"?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Thẻ $count của nó cũng sẽ bị xóa.',
      one: ' Thẻ 1 của nó cũng sẽ bị xóa.',
      zero: '',
    );
    return 'Delete \"$name\"?$_temp0';
  }

  @override
  String get tagNameExists => 'Đã có một thẻ có tên này rồi';

  @override
  String get categoryNameExists => 'Đã có một danh mục có tên này rồi';

  @override
  String deleteTemplateMessage(Object name) {
    return 'Xóa \"$name\"?';
  }

  @override
  String get addTagsTitle => 'Thêm thẻ';

  @override
  String get addTagsSearchHint => 'Tìm kiếm thẻ…';

  @override
  String get tagFavoriteName => 'yêu thích';

  @override
  String get iconGroupActivities => 'Hoạt động';

  @override
  String get iconGroupHobbies => 'Giải trí';

  @override
  String get settingsStorageTitle => 'Lưu trữ';

  @override
  String get settingsImageQuality => 'Chất lượng hình ảnh';

  @override
  String get imageQualityHigh => 'Cao';

  @override
  String get imageQualityMedium => 'Trung bình';

  @override
  String get imageQualityLow => 'Thấp';

  @override
  String get imageQualityNoCompression => 'Không nén';

  @override
  String get settingsLogFolder => 'thư mục nhật ký';

  @override
  String get settingsImageFolder => 'Thư mục hình ảnh';

  @override
  String get warningTitle => 'Cảnh báo';

  @override
  String get logFolderWarningDescription =>
      'Nếu thư mục đã chọn đã chứa tệp \'aid_diary.db\', tệp này sẽ được sử dụng để ghi đè các mục nhật ký hiện có của bạn!';

  @override
  String get errorTitle => 'Lỗi';

  @override
  String get logFolderErrorDescription =>
      'Không thể thay đổi thư mục mục nhật ký!';

  @override
  String get imageFolderErrorDescription =>
      'Không thể thay đổi thư mục hình ảnh!';

  @override
  String get backupErrorDescription => 'Không tạo được bản sao lưu!';

  @override
  String get restoreErrorDescription => 'Không thể khôi phục bản sao lưu!';

  @override
  String get settingsBackupRestoreTitle => 'Sao lưu & Khôi phục';

  @override
  String get settingsBackup => 'Sao lưu';

  @override
  String get settingsRestore => 'Khôi phục';

  @override
  String get settingsRestorePromptDescription =>
      'Khôi phục bản sao lưu sẽ ghi đè lên dữ liệu hiện có của bạn!';

  @override
  String get settingsBackupPasswordProtect => 'Sao lưu bảo vệ bằng mật khẩu';

  @override
  String get backupEncryptedTitle => 'Sao lưu được mã hóa';

  @override
  String get backupEncryptedContent =>
      'Bản sao lưu này được bảo vệ bằng mật khẩu.';

  @override
  String get settingsAutoBackup => 'Sao lưu tự động';

  @override
  String get settingsAutoBackupLocation => 'Vị trí sao lưu';

  @override
  String get settingsAutoBackupInterval => 'Khoảng thời gian sao lưu';

  @override
  String get settingsAutoBackupIntervalDaily => 'hàng ngày';

  @override
  String get settingsAutoBackupIntervalWeekly => 'hàng tuần';

  @override
  String get settingsAutoBackupIntervalMonthly => 'hàng tháng';

  @override
  String get settingsAutoBackupMaxCount => 'Sao lưu để giữ';

  @override
  String get settingsAutoBackupRequireCharging => 'Chỉ khi đang sạc';

  @override
  String settingsBackupLast(Object time) {
    return 'Bản sao lưu cuối cùng $time';
  }

  @override
  String get settingsBackupNever => 'Chưa bao giờ sao lưu';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Bản sao lưu tiếp theo $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'Tất cả';

  @override
  String get autoBackupFailedTitle => 'Sao lưu không thành công';

  @override
  String tranferStatus(Object percent) {
    return 'Đang chuyển… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Đang tạo bản sao lưu… $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Đang khôi phục bản sao lưu… $percent%';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return 'Đang mã hóa bản sao lưu… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Đang giải mã bản sao lưu… $percent%';
  }

  @override
  String get cleanUpStatus => 'Dọn dẹp…';

  @override
  String get settingsExportToAnotherFormat => 'Xuất sang định dạng khác';

  @override
  String get settingsExportFormatDescription =>
      'Điều này không nên được sử dụng như một bản sao lưu!';

  @override
  String get settingsImportFromAnotherApp => 'Nhập từ ứng dụng khác';

  @override
  String get logFormatTitle => 'Chọn định dạng';

  @override
  String get logFormatDescription =>
      'Định dạng của ứng dụng khác có thể không hỗ trợ tất cả các tính năng. Vui lòng báo cáo mọi vấn đề vì định dạng của bên thứ ba có thể thay đổi bất kỳ lúc nào. Điều này sẽ không ảnh hưởng đến các mục nhật ký hiện có!';

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
  String get settingsDeleteAllLogsTitle => 'Xóa tất cả các mục nhật ký';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Bạn có muốn xóa tất cả các mục nhật ký của bạn?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Nhập \'$prompt\' để xác nhận. Điều này không thể được hoàn tác!';
  }

  @override
  String get settingsAppLanguageTitle => 'Ngôn ngữ ứng dụng';

  @override
  String get settingsSecurityTitle => 'Bảo mật';

  @override
  String get settingsSecurityRequirePassword => 'Yêu cầu mật khẩu';

  @override
  String get settingsSecurityEnterPassword => 'Nhập mật khẩu';

  @override
  String get settingsSecuritySetPassword => 'Đặt mật khẩu';

  @override
  String get settingsSecurityChangePassword => 'Thay đổi mật khẩu';

  @override
  String get settingsSecurityPassword => 'Mật khẩu';

  @override
  String get settingsSecurityConfirmPassword => 'Xác nhận mật khẩu';

  @override
  String get settingsSecurityOldPassword => 'Mật khẩu cũ';

  @override
  String get settingsSecurityIncorrectPassword => 'Mật khẩu sai';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'Mật khẩu không khớp';

  @override
  String get requiredPrompt => 'Bắt buộc';

  @override
  String get settingsSecurityBiometricUnlock => 'Mở khóa sinh trắc học';

  @override
  String get unlockAppPrompt => 'Mở khóa ứng dụng';

  @override
  String get settingsAboutTitle => 'Giới thiệu';

  @override
  String get settingsVersion => 'Phiên bản';

  @override
  String get settingsLicense => 'Giấy phép';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsOpenSourceLicenses => 'Giấy phép nguồn mở';

  @override
  String get tagMoodTitle => 'Tâm trạng';

  @override
  String get selectTagTitle => 'Chọn thẻ';

  @override
  String get labelPresentLabel => 'hiện tại';

  @override
  String get labelAbsentLabel => 'Vắng mặt';

  @override
  String get labelCoverageLabel => 'Bảo hiểm';

  @override
  String chartDistributionTitle(Object tag) {
    return 'Phân phối $tag';
  }

  @override
  String get shareAddToLogPickerTitle => 'Chọn một mục nhật ký';

  @override
  String get adaptiveEmptyDay => 'Chưa có mục nào cho ngày này';

  @override
  String get adaptiveNewEntry => 'Viết một mục';

  @override
  String get pageJournalTitle => 'tạp chí';

  @override
  String get coachPrompt1 => 'Điều gì làm bạn cười hôm nay?';

  @override
  String get coachPrompt2 => 'Một điều bạn học được ngày hôm nay là gì?';

  @override
  String get coachPrompt3 =>
      'Hôm nay bạn đã nói chuyện với ai và bạn cảm thấy thế nào?';

  @override
  String get coachPrompt4 => 'Hiện tại bạn đang biết ơn điều gì?';

  @override
  String get coachPrompt5 =>
      'Điều gì đã lấy đi hầu hết năng lượng của bạn ngày hôm nay?';

  @override
  String get coachPrompt6 =>
      'Hãy mô tả một khoảnh khắc nhỏ mà bạn muốn ghi nhớ.';

  @override
  String get coachPrompt7 =>
      'Điều gì sẽ làm cho ngày mai là một ngày tốt lành?';

  @override
  String get coachPrompt8 => 'Gần đây bạn đang nghĩ gì trong đầu?';

  @override
  String get coachPrompt9 => 'Hôm nay bạn đã làm gì chỉ cho riêng mình?';

  @override
  String get coachPrompt10 => 'Nếu hôm nay có tựa đề thì nó sẽ là gì?';

  @override
  String get pageMediaTitle => 'Phương tiện truyền thông';

  @override
  String get pageAtlasTitle => 'tập bản đồ';

  @override
  String get pageCoachTitle => 'huấn luyện viên';

  @override
  String get noEntrySelected => 'Không có mục nào được chọn.';

  @override
  String get entryShare => 'Chia sẻ';

  @override
  String get entryFavorite => 'Ngôi sao';

  @override
  String get entryEdit => 'Chỉnh sửa';

  @override
  String get entryPrevious => 'Mục trước';

  @override
  String get entryNext => 'Mục tiếp theo';

  @override
  String get journalStories => 'Truyện';

  @override
  String get journalEntries => 'Bài dự thi';

  @override
  String get journalEmptyHint =>
      'Bắt đầu nhật ký của bạn bằng cách thêm một mục mới.';

  @override
  String get storyToday => 'hôm nay';

  @override
  String get storyThrowback => 'Quay lại';

  @override
  String get storyNoThrowback => 'Không có sự trở lại ngày hôm nay';

  @override
  String get mediaFiles => 'Tệp phương tiện';

  @override
  String get mediaEmpty => 'Chưa có ảnh nào.';

  @override
  String get mediaEmptyHint =>
      'Hình ảnh đính kèm với các mục sẽ được hiển thị ở đây.';

  @override
  String get atlasEmpty => 'Không có mục nào có vị trí.';

  @override
  String get atlasEmptyHint => 'Các mục có vị trí sẽ được hiển thị ở đây.';

  @override
  String get atlasShowAll => 'Hiển thị tất cả các mục';

  @override
  String get atlasMyLocation => 'Vị trí của tôi';

  @override
  String get coachAll => 'Tất cả';

  @override
  String get coachPrograms => 'Chương trình';

  @override
  String get coachTemplates => 'Mẫu';

  @override
  String get coachKindProgram => 'chương trình';

  @override
  String get coachKindTemplate => 'mẫu';

  @override
  String get coachNoTemplates => 'Không có chương trình hoặc mẫu.';

  @override
  String get coachUseTemplate => 'Viết bằng mẫu này';

  @override
  String get coachProgramEverydayTitle => 'Khoảnh khắc đời thường';

  @override
  String get coachProgramEverydayDescription =>
      'Năm câu hỏi ngắn, mỗi ngày một câu. Mỗi lần mất một hoặc hai phút và giúp bạn biết điều gì đã tạo nên ngày của bạn. Một cách nhẹ nhàng để xây dựng thói quen viết mỗi ngày một chút.';

  @override
  String get coachProgramReflectTitle => 'Hướng nội';

  @override
  String get coachProgramReflectDescription =>
      'Một câu hỏi sâu hơn mỗi tuần, trong năm tuần. Hãy dành thời gian cho từng điều: bạn cảm thấy thế nào, điều gì làm bạn kiệt sức, điều gì bạn biết ơn.';

  @override
  String get searchFilters => 'Bộ lọc';

  @override
  String get searchFilterTags => 'Thẻ';

  @override
  String get searchFilterStarred => 'Được gắn dấu sao';

  @override
  String get searchHint => 'Nhập để tìm kiếm hoặc chọn một bộ lọc.';

  @override
  String get locationTitle => 'Vị trí';

  @override
  String get locationName => 'Tên địa điểm';

  @override
  String get locationRemove => 'Xóa';

  @override
  String get locationServiceDisabled => 'Dịch vụ định vị đã bị tắt.';

  @override
  String get locationPermissionDenied => 'Quyền truy cập vị trí đã bị từ chối.';

  @override
  String get locationUnavailable => 'Không thể có được vị trí hiện tại.';

  @override
  String get calendarJumpToToday => 'Chuyển đến ngày hôm nay';

  @override
  String get editorStartWriting => 'Bắt đầu viết hoặc chọn một ';

  @override
  String get editorTemplateLink => 'mẫu';

  @override
  String get editorStartWritingEnd => '.';

  @override
  String get templatePickerTitle => 'Chọn một mẫu';

  @override
  String get templateFeatured => 'Mẫu nổi bật';

  @override
  String get templateMine => 'Mẫu của tôi';

  @override
  String get templateDailyName => 'Đánh giá hàng ngày';

  @override
  String get templateDailyDescription =>
      'Chuyện gì đã xảy ra, cảm giác thế nào và điều gì xảy ra tiếp theo.';

  @override
  String get templateDailyText =>
      '## Chuyện gì đã xảy ra hôm nay\n\n\n## Tôi cảm thấy thế nào\n\n\n## Ba điều tôi biết ơn\n1. \n2. \n3. \n\n## Ngày mai\n';

  @override
  String get templateTravelName => 'Mục nhật ký du lịch';

  @override
  String get templateTravelDescription =>
      'Địa điểm, khoảnh khắc và thức ăn trên đường.';

  @override
  String get templateTravelText =>
      '## Tôi đã đi đâu\n\n\n##Khoảnh khắc tôi nhớ nhất\n\n\n## Những gì tôi đã ăn\n\n\n##Kế hoạch cho ngày mai\n';

  @override
  String get templateReadingName => 'Đọc ghi chú';

  @override
  String get templateReadingDescription =>
      'Trích dẫn và suy nghĩ từ những gì bạn đọc.';

  @override
  String get templateReadingText =>
      '## Sách\n\n\n##Tôi đang ở đâu\n\n\n## Trích dẫn\n> \n\n## Suy nghĩ của tôi\n';

  @override
  String get templateWeeklyName => 'Đánh giá hàng tuần';

  @override
  String get templateWeeklyDescription =>
      'Điểm nổi bật, khó khăn và trọng tâm của tuần tới.';

  @override
  String get templateWeeklyText =>
      '## Điểm nổi bật\n\n\n## Có gì khó\n\n\n## Những gì tôi đã học được\n\n\n## Tập trung cho tuần tới\n';

  @override
  String get entrySaveAsTemplate => 'Lưu dưới dạng mẫu';

  @override
  String get entrySavedAsTemplate => 'Đã lưu dưới dạng mẫu';

  @override
  String get storyStatistics => 'Thống kê';

  @override
  String get storyMoodChart => 'Biểu đồ tâm trạng';

  @override
  String storyEntriesAndDays(Object days, Object entries) {
    return 'Các mục $entries · $days ngày';
  }

  @override
  String get storyThisYear => 'Năm nay';

  @override
  String get storyLastYear => 'Năm ngoái';

  @override
  String get storyTapToOpen => 'Nhấn vào một ngày để mở nó';

  @override
  String get settingsGeneralTitle => 'chung';

  @override
  String get settingsDataTitle => 'Dữ liệu & lưu trữ';

  @override
  String get settingsStoriesTitle => 'Truyện';

  @override
  String get settingsHelpTitle => 'Trợ giúp & về';

  @override
  String get weatherTitle => 'Thời tiết';

  @override
  String get weatherClear => 'Xóa';

  @override
  String get weatherPartlyCloudy => 'Có mây rải rác';

  @override
  String get weatherCloudy => 'Nhiều mây';

  @override
  String get weatherFog => 'Sương mù';

  @override
  String get weatherDrizzle => 'Mưa phùn';

  @override
  String get weatherRain => 'Mưa';

  @override
  String get weatherSnow => 'Tuyết';

  @override
  String get weatherStorm => 'Sấm sét';

  @override
  String get weatherFetch => 'Nhận thông tin thời tiết cho mục này';

  @override
  String get weatherNeedsLocation => 'Thêm vị trí có tọa độ trước.';

  @override
  String get weatherUnavailable =>
      'Thời tiết không có sẵn cho địa điểm và thời gian này.';

  @override
  String get weatherRemove => 'Xóa thời tiết';

  @override
  String get activityTitle => 'Hoạt động';

  @override
  String get activityStill => 'Vẫn';

  @override
  String get activityWalking => 'Đi bộ';

  @override
  String get activityRunning => 'Đang chạy';

  @override
  String get activityCycling => 'Đi xe đạp';

  @override
  String get activityVehicle => 'Trong một chiếc xe';

  @override
  String get activityFlying => 'Đang bay';

  @override
  String get activityExercise => 'tập thể dục';

  @override
  String get activityDetect => 'Phát hiện hoạt động hiện tại';

  @override
  String get activityDetectFailed => 'Không thể phát hiện một hoạt động.';

  @override
  String get activityRemove => 'Xóa hoạt động';

  @override
  String get settingsAutoAddTitle => 'Thêm tự động';

  @override
  String get settingsAutoAddLocation => 'Vị trí';

  @override
  String get settingsAutoAddWeather => 'Thời tiết';

  @override
  String get settingsAutoAddHint =>
      'Các mục mới sẽ được điền vào khi chúng được tạo.';

  @override
  String get settingsTemperatureUnit => 'Đơn vị nhiệt độ';

  @override
  String get settingsCelsius => 'độ C (°C)';

  @override
  String get settingsFahrenheit => 'Độ F (°F)';

  @override
  String get moodGreat => 'Tuyệt vời';

  @override
  String get moodGood => 'Tốt';

  @override
  String get moodOkay => 'được rồi';

  @override
  String get moodBad => 'Xấu';

  @override
  String get moodAwful => 'khủng khiếp';

  @override
  String get locationSearchHint => 'Tìm kiếm địa điểm';

  @override
  String get locationSearchEmpty => 'Không tìm thấy địa điểm nào';

  @override
  String get settingsWallpaper => 'Hình nền';

  @override
  String get wallpaperNone => 'không có';

  @override
  String get wallpaperDots => 'Dấu chấm';

  @override
  String get wallpaperGrid => 'Lưới';

  @override
  String get wallpaperLines => 'dòng';

  @override
  String get wallpaperPhoto => 'Ảnh…';

  @override
  String get settingsFontFamily => 'Phông chữ';

  @override
  String get fontSystem => 'Hệ thống';

  @override
  String get fontSerif => 'Serif';

  @override
  String get fontMono => 'Không gian đơn';

  @override
  String get settingsFontSize => 'Cỡ chữ';

  @override
  String get fontSizeSmall => 'nhỏ';

  @override
  String get fontSizeMedium => 'Trung bình';

  @override
  String get fontSizeLarge => 'lớn';

  @override
  String get fontSizeExtraLarge => 'Cực lớn';

  @override
  String get settingsLineSpacing => 'Khoảng cách dòng';

  @override
  String get lineSpacingCompact => 'Nhỏ gọn';

  @override
  String get lineSpacingNormal => 'Bình thường';

  @override
  String get lineSpacingRelaxed => 'Thư giãn';

  @override
  String get moodAssociationsTitle => 'Điều gì khiến tôi cảm thấy…';

  @override
  String moodAssociationsCount(int matching, int total) {
    return '$matching của các mục $total';
  }

  @override
  String get videoRecord => 'Quay video';

  @override
  String get videoChoose => 'Chọn một video';

  @override
  String get audioRecordTitle => 'Ghi lại ghi chú bằng giọng nói';

  @override
  String get audioChoose => 'Chọn một tập tin âm thanh';

  @override
  String get audioStart => 'Ghi lại';

  @override
  String get audioStop => 'Dừng lại và lưu';

  @override
  String get audioPermissionDenied =>
      'Quyền truy cập micrô bị tắt. Cho phép nó trong cài đặt hệ thống.';

  @override
  String get mediaTooLarge => 'Video này quá lớn để đính kèm.';

  @override
  String get mediaUnavailable =>
      'Tệp đính kèm này không có sẵn trên thiết bị này.';

  @override
  String get widgetDone => 'Bài viết hôm nay được viết';

  @override
  String get widgetPending => 'Ngày của bạn thế nào?';

  @override
  String get widgetWrite => 'Viết';

  @override
  String get insertChecklist => 'Danh sách kiểm tra';

  @override
  String get insertNumberedList => 'Danh sách đánh số';

  @override
  String get insertTable => 'Bảng';

  @override
  String get insertDivider => 'Dải phân cách';

  @override
  String get insertCodeBlock => 'Khối mã';

  @override
  String get journalSortTitle => 'Sắp xếp các mục';

  @override
  String get journalSortUpdated => 'Cập nhật lần cuối';

  @override
  String get settingsTimeFormat => 'Định dạng thời gian';

  @override
  String get settingsDayStart =>
      'Các mục mới được tính cho ngày hôm trước cho đến khi';

  @override
  String get settingsDayAskUntil => 'Sau đó hỏi ngày nào cho đến khi';

  @override
  String get settingsDayStartMidnight => 'Tắt';

  @override
  String settingsDayStartAt(int hour) {
    return '$hour:00';
  }

  @override
  String get settingsDayStartHint =>
      'Mỗi mục nhập giữ ngày thuộc về ngày đó bên cạnh thời điểm nó được viết và bạn có thể thay đổi ngày đó trong trình chỉnh sửa bất kỳ lúc nào. Những giờ này chỉ chọn ngày cho các mục nhập mới, vì vậy việc thay đổi chúng sẽ không làm di chuyển mục nhập hiện có.';

  @override
  String get lateNightBadge => 'Viết lúc đêm khuya, tính cho ngày hôm trước';

  @override
  String editorDayAsk(String time) {
    return 'Được viết tại $time. Nó dành cho ngày nào?';
  }

  @override
  String editorDayYesterday(String date) {
    return '$date (hôm qua)';
  }

  @override
  String editorDayToday(String date) {
    return '$date (hôm nay)';
  }

  @override
  String editorWrittenAt(String when) {
    return 'Đã viết $when';
  }

  @override
  String get timeFormat12 => '12 giờ';

  @override
  String get timeFormat24 => '24 giờ';

  @override
  String get settingsReminderDays => 'Nhắc nhở tôi';

  @override
  String get locationRecent => 'Địa điểm gần đây';

  @override
  String get shareImage => 'Chia sẻ hình ảnh';

  @override
  String get shareSaveImage => 'Lưu hình ảnh';

  @override
  String get shareSaved => 'Đã lưu hình ảnh';

  @override
  String get deletedTitle => 'Đã xóa gần đây';

  @override
  String get deletedNone => 'Không có gì bị xóa gần đây';

  @override
  String deletedHint(int days) {
    return 'Các mục đã xóa vẫn ở đây trong $days ngày, sau đó bị xóa.';
  }

  @override
  String deletedDaysLeft(int days) {
    return '$days ngày còn lại';
  }

  @override
  String get deletedRestore => 'Khôi phục';

  @override
  String get deletedDeleteForever => 'Xóa vĩnh viễn';

  @override
  String get deletedDeleteForeverDescription =>
      'Mục nhập và phần đính kèm của nó sẽ bị xóa. Điều này không thể hoàn tác được.';

  @override
  String get deletedEmpty => 'trống';

  @override
  String get deletedEmptyDescription =>
      'Xóa mọi mục trong Đã xóa gần đây? Điều này không thể hoàn tác được.';

  @override
  String get formatJson => 'JSON';

  @override
  String get randomTitle => 'Bước đi ngẫu nhiên';

  @override
  String get randomSubtitle => 'Mở một mục quá khứ';

  @override
  String get randomNext => 'Khác';

  @override
  String get randomAll => 'Tất cả';

  @override
  String get randomWithPhotos => 'Có ảnh';

  @override
  String get randomGoodDays => 'ngày tốt lành';

  @override
  String get randomEmpty => 'Không có mục nào để chọn';

  @override
  String get reviewWeekTitle => 'Tuần này';

  @override
  String get reviewWeekSubtitle => 'Tuần của bạn cho đến nay';

  @override
  String get reviewYearTitle => 'Năm nay';

  @override
  String get reviewEmpty => 'Chưa có gì được viết';

  @override
  String get reviewEntries => 'Bài dự thi';

  @override
  String get reviewDaysWritten => 'Ngày viết';

  @override
  String get reviewWords => 'từ';

  @override
  String get reviewPhotos => 'Ảnh';

  @override
  String get reviewLongestRun => 'Ngày hoạt động dài nhất';

  @override
  String get reviewAverageMood => 'Tâm trạng trung bình';

  @override
  String get reviewFavorites => 'Thường xuyên nhất';

  @override
  String get reviewByMonth => 'Theo tháng';

  @override
  String get reviewHighlight => 'Đánh dấu';

  @override
  String get yearInPixels => 'Năm tính bằng pixel';

  @override
  String get capsuleSeal => 'Niêm phong như một viên nang thời gian';

  @override
  String get capsuleTitle => 'Viên nang thời gian';

  @override
  String capsuleOpensOn(Object date) {
    return 'Mở trên $date';
  }

  @override
  String capsuleWrittenOn(Object date) {
    return 'Được viết trên $date';
  }

  @override
  String get capsuleOpenEarly => 'Mở cửa sớm';

  @override
  String get capsuleOpenEarlyDescription =>
      'Viên nang mở ra bây giờ và vẫn mở.';

  @override
  String get capsuleOpened => 'Viên nang thời gian đã mở';

  @override
  String get templateMorningName => 'Trang buổi sáng';

  @override
  String get templateMorningDescription => 'Thiết lập ngày trong ba phút';

  @override
  String get templateMorningText =>
      '## Ba điều tôi muốn làm tốt hôm nay\n1. \n2. \n3. \n\n## Điều tôi mong đợi\n\n## Một lưu ý cho chính tôi\n';

  @override
  String get templateEveningName => 'Đánh giá buổi tối';

  @override
  String get templateEveningDescription =>
      'Kết thúc một ngày với những gì đã diễn ra tốt đẹp';

  @override
  String get templateEveningText =>
      '##Ba điều tốt hôm nay\n1. \n2. \n3. \n\n## Những gì tôi đã học được\n\n## Điều gì có thể tốt hơn vào ngày mai\n';

  @override
  String get routineMorning => 'Chào buổi sáng';

  @override
  String get routineEvening => 'Đánh giá buổi tối';

  @override
  String get settingsRoutinePrompts => 'Lời nhắc buổi sáng và buổi tối';

  @override
  String get settingsRoutinePromptsHint =>
      'Đề xuất mẫu buổi sáng hoặc buổi tối trong Stories';

  @override
  String get checkInTitle => 'Nhận phòng nhanh';

  @override
  String get checkInSubtitle => 'Tâm trạng trong hai lần nhấn';

  @override
  String get checkInMood => 'Bạn cảm thấy thế nào?';

  @override
  String get checkInActivity => 'Bạn đang làm gì vậy?';

  @override
  String get checkInNote => 'Một dòng về nó (tùy chọn)';

  @override
  String get checkInSave => 'Lưu';

  @override
  String editorWordCount(int words, int characters) {
    return 'Từ $words · Ký tự $characters';
  }

  @override
  String get coachProgramEverydayTagline =>
      'Hãy để ý những điều nhỏ nhặt trong một ngày.';

  @override
  String get coachProgramReflectTagline =>
      'Hãy chậm lại và lắng nghe chính mình.';

  @override
  String get coachDuration => 'Thời lượng';

  @override
  String get coachInterval => 'Khoảng thời gian';

  @override
  String get coachDifficulty => 'độ khó';

  @override
  String get coachIntervalDaily => 'hàng ngày';

  @override
  String get coachIntervalWeekly => 'hàng tuần';

  @override
  String get coachDifficultyBeginner => 'Người mới bắt đầu';

  @override
  String get coachDifficultyIntermediate => 'Trung cấp';

  @override
  String coachDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ngày',
      one: '1 ngày',
    );
    return '$_temp0';
  }

  @override
  String coachDurationWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tuần',
      one: '1 tuần',
    );
    return '$_temp0';
  }

  @override
  String coachDayN(int n) {
    return 'Ngày $n';
  }

  @override
  String coachWeekN(int n) {
    return 'Tuần $n';
  }

  @override
  String get coachEnroll => 'Đăng ký';

  @override
  String get coachEndProgram => 'Kết thúc chương trình';

  @override
  String get coachAuthor => 'tác giả';

  @override
  String get coachAuthorBio => 'Lời nhắc được viết cho ứng dụng này.';

  @override
  String get coachEnrolledTip =>
      'Đã hoàn tất! Câu hỏi của bạn sẽ hiển thị trong Câu chuyện.';

  @override
  String get coachGoToStories => 'Đi đến Câu chuyện';

  @override
  String get coachAnswerHint => 'Viết câu trả lời của bạn…';

  @override
  String get storyWrapUp => 'Đó là tất cả cho ngày hôm nay.';

  @override
  String get storyTapToClose => 'Nhấn để đóng';

  @override
  String get coachAnswerDone => 'Xong';

  @override
  String get coachAnswered => 'Đã trả lời, nhấn để mở';

  @override
  String get coachAnsweredEarlier => 'Đã trả lời';

  @override
  String get locationLocating => 'Đang định vị…';

  @override
  String get locationPickPlace => 'Chọn một địa điểm';

  @override
  String get locationPlacesHint => 'Địa chỉ hoặc tên của địa điểm';

  @override
  String get locationCustom => 'Địa điểm tùy chỉnh';

  @override
  String get locationCurrent => 'Vị trí hiện tại';

  @override
  String get locationSaved => 'Địa điểm đã lưu';

  @override
  String get locationSearchResults => 'Kết quả tìm kiếm';

  @override
  String get locationNearby => 'Địa điểm lân cận';

  @override
  String get locationRename => 'Đổi tên';

  @override
  String get locationSavePlace => 'Lưu địa điểm';

  @override
  String get locationUnsavePlace => 'Xóa khỏi địa điểm đã lưu';

  @override
  String get shareAs => 'Chia sẻ dưới dạng…';

  @override
  String get shareAsImage => 'Hình ảnh';

  @override
  String get shareAsZip => 'ZIP với phương tiện gốc';

  @override
  String get shareAsPlainText => 'Văn bản thuần túy';

  @override
  String get shareAsHtml => 'HTML';

  @override
  String get onboardWelcomeTitle => 'Chào mừng đến với AID Diary';

  @override
  String get onboardWelcomeText =>
      'Bắt đầu ở đây hoặc kết nối thiết bị này với thiết bị bạn đã sử dụng.';

  @override
  String get onboardStart => 'Bắt đầu viết';

  @override
  String get helpFaq => 'Câu hỏi thường gặp';

  @override
  String get helpFaq1Q => 'Nhật ký của tôi được lưu trữ ở đâu?';

  @override
  String get helpFaq1A =>
      'Nhật ký của bạn được lưu trữ trên thiết bị này. Nó chỉ đến được các thiết bị hoặc bộ lưu trữ khác khi bạn bật đồng bộ hóa, chia sẻ hoặc xuất nó. Đồng bộ hóa được mã hóa hai đầu.';

  @override
  String get helpFaq2Q =>
      'Làm cách nào để giữ một bản sao hoặc chuyển sang thiết bị mới?';

  @override
  String get helpFaq2A =>
      'Kết nối với thiết bị hiện có trong Cài đặt → Dữ liệu & lưu trữ → Đồng bộ hóa và xác nhận ủy quyền trên thiết bị có nhật ký của bạn. Cả hai thiết bị vẫn có thể sử dụng được. Bạn cũng có thể tạo bản sao lưu và khôi phục nó trên thiết bị khác.';

  @override
  String get helpFaq3Q =>
      'Tôi có thể nhập các mục từ các ứng dụng nhật ký khác không?';

  @override
  String get helpFaq3A =>
      'Có: trong Cài đặt → Dữ liệu & lưu trữ, nhập các bản xuất từ Daylio, Diarium, Diaro, DayBook, My Brain, OneShot và Pixels hoặc xuất JSON.';

  @override
  String get helpFaq4Q =>
      'Các chương trình huấn luyện viên hoạt động như thế nào?';

  @override
  String get helpFaq4A =>
      'Đăng ký tham gia chương trình trên trang Coach. Mỗi ngày hoặc mỗi tuần, một câu hỏi mới sẽ chờ đợi trong Câu chuyện; câu trả lời của bạn được lưu dưới dạng mục nhập.';

  @override
  String get helpFaq5Q => 'Nếu tôi quên mật mã thì sao?';

  @override
  String get helpFaq5A =>
      'Không thể khôi phục mật mã, vì vậy hãy sao lưu nhật ký của bạn.';

  @override
  String get helpPrivacy => 'Quyền riêng tư';

  @override
  String get helpPrivacyText =>
      'Nội dung nhật ký và phương tiện vẫn còn trên thiết bị này trừ khi bạn bật đồng bộ hóa được mã hóa hoặc chia sẻ/xuất chúng. Bản đồ, tra cứu địa điểm và thời tiết sử dụng các dịch vụ đã định cấu hình và gửi vị trí hoặc truy vấn tìm kiếm cần thiết cho yêu cầu đó chứ không phải văn bản nhật ký.';

  @override
  String get photoMetaTitle => 'Sử dụng chi tiết của bức ảnh?';

  @override
  String photoMetaDateAndPlace(String date, String place) {
    return 'Đếm mục này cho $date và đặt vị trí của nó thành $place, như được ghi trong ảnh?';
  }

  @override
  String photoMetaDate(String date) {
    return 'Đếm mục này cho $date, thời điểm bức ảnh được chụp?';
  }

  @override
  String photoMetaPlace(String place) {
    return 'Đặt vị trí của mục này thành $place, ảnh được chụp ở đâu?';
  }

  @override
  String get photoMetaApply => 'Sử dụng chúng';

  @override
  String get quickWriteTitle => 'Viết nhanh';

  @override
  String get quickWriteText => 'Nhấn để bắt đầu một mục mới.';

  @override
  String get settingsQuickWriteTitle => 'Viết nhanh trong thông báo';

  @override
  String get settingsQuickWriteDescription =>
      'Giữ một thông báo mở ra một mục mới.';

  @override
  String get settingsNudgesTitle =>
      'Thúc đẩy tôi sau một khoảng thời gian yên tĩnh';

  @override
  String settingsNudgesDescription(int days) {
    return 'Một lời nhắc nhở nhẹ nhàng khi bạn chưa viết $days những ngày.';
  }

  @override
  String get nudgeTitle => 'Đã được một thời gian rồi';

  @override
  String get nudgeMonday => 'Tuần mới: Bạn mong chờ điều gì?';

  @override
  String get nudgeTuesday => 'Hai dòng là đủ. Bạn hôm nay thế nào?';

  @override
  String get nudgeWednesday => 'Nửa tuần rồi. Điều gì nổi bật cho đến nay?';

  @override
  String get nudgeThursday =>
      'Có điều gì nhỏ nhặt đáng để giữ lại từ ngày hôm nay không?';

  @override
  String get nudgeFriday =>
      'Một tuần đang kết thúc. Lưu ý một khoảnh khắc tốt.';

  @override
  String get nudgeSaturday =>
      'Một ngày thứ bảy chậm rãi là một ngày tốt để viết.';

  @override
  String get nudgeSunday => 'Nhìn lại tuần trước khi nó kết thúc.';

  @override
  String get photoWidgetEmpty => 'Ảnh bạn thêm vào mục sẽ hiển thị ở đây.';

  @override
  String get channelReminders => 'Lời nhắc';

  @override
  String get channelOnThisDay => 'Vào ngày này';

  @override
  String get channelCoach => 'Lời nhắc của huấn luyện viên';

  @override
  String get channelNudges => 'Cúi đầu sau những ngày im ắng';

  @override
  String get channelQuickWrite => 'Viết nhanh';

  @override
  String get channelBackup => 'Sao lưu';

  @override
  String get formatJsonExport => 'JSON (xuất AID Diary)';

  @override
  String get aboutModifiedNotice =>
      'Phiên bản sửa đổi của Daily You của Demizo và những người đóng góp. Nó không phải là ứng dụng Daily You chính thức.';

  @override
  String get toolbarPhotos => 'Thêm ảnh';

  @override
  String get toolbarMedia => 'Ảnh và video';

  @override
  String get mediaFromGallery => 'Chọn từ thư viện';

  @override
  String get mediaFromFiles => 'Chọn từ các tập tin';

  @override
  String get editorLeaveTitle => 'Lưu mục này?';

  @override
  String get editorLeaveDiscard => 'Đừng lưu';

  @override
  String get editorTitleHint => 'Tiêu đề';

  @override
  String get editorLocating => 'Đang định vị…';

  @override
  String get toolbarVideo => 'Video';

  @override
  String get toolbarAudio => 'Ghi chú bằng giọng nói';

  @override
  String get toolbarTags => 'Thẻ';

  @override
  String get toolbarBulletList => 'Danh sách có dấu đầu dòng';

  @override
  String get toolbarHeading => 'tiêu đề';

  @override
  String get toolbarBold => 'Đậm';

  @override
  String get toolbarItalic => 'Nghiêng';

  @override
  String get toolbarHighlight => 'Đánh dấu';

  @override
  String get toolbarStrikethrough => 'Gạch ngang';

  @override
  String get toolbarQuote => 'Trích dẫn';

  @override
  String get toolbarLink => 'liên kết';

  @override
  String get toolbarInsert => 'Chèn';

  @override
  String get toolbarUndo => 'Hoàn tác';

  @override
  String get toolbarRedo => 'Làm lại';

  @override
  String get toolbarInsertDate => 'Chèn ngày';

  @override
  String get toolbarInsertTime => 'Chèn thời gian';

  @override
  String get settingsSyncTitle => 'Đồng bộ đám mây';

  @override
  String get syncOffDescription =>
      'Giữ nhật ký này giống nhau trên tất cả các thiết bị của bạn thông qua máy chủ Google Drive hoặc WebDAV, chẳng hạn như Nextcloud, Synology hoặc Jianguoyun.';

  @override
  String get syncUseGoogleDrive => 'Đồng bộ hóa với Google Drive';

  @override
  String get syncOrWebDav => 'Hoặc máy chủ WebDAV';

  @override
  String get syncGoogleDrive => 'Google Drive';

  @override
  String get syncGoogleSignedIn =>
      'Đã đăng nhập. Bạn có thể quay lại AID Diary.';

  @override
  String get syncGoogleSignInAgain => 'Google cần bạn đăng nhập lại.';

  @override
  String get syncSignInAgain => 'Đăng nhập lại';

  @override
  String get settingsCommandLineTitle => 'Dòng lệnh';

  @override
  String get commandLineToggle => 'Giao diện dòng lệnh';

  @override
  String get commandLineToggleHint =>
      'Cho phép lệnh viện trợ và các chương trình khác trên thiết bị này sử dụng lệnh của ứng dụng.';

  @override
  String get commandLineAlwaysOn =>
      'Luôn luôn có trong các bản dựng phát triển.';

  @override
  String commandLineListening(int port) {
    return 'Nghe trên cổng $port';
  }

  @override
  String get commandPaletteTitle => 'Tất cả các lệnh';

  @override
  String get commandPaletteSearch => 'Lệnh tìm kiếm';

  @override
  String get commandPaletteRun => 'Chạy';

  @override
  String get commandPaletteConfirm =>
      'Điều này không thể đơn giản được hoàn tác. Chạy nó?';

  @override
  String syncReceiving(int done, int total) {
    return 'Đang nhận $done của $total…';
  }

  @override
  String syncSending(int done, int total) {
    return 'Đang gửi $done của $total…';
  }

  @override
  String get syncGoogleDriveNotAllowed =>
      'Không được phép truy cập vào Google Drive. Kết nối lại và đánh dấu Google Drive trên trang của Google.';

  @override
  String get syncEntryUnsynced =>
      'Chưa được đồng bộ hóa: lần đồng bộ hóa cuối cùng không thành công';

  @override
  String get syncUseOfficial => 'Sử dụng máy chủ đồng bộ AID';

  @override
  String get syncServer => 'Địa chỉ máy chủ';

  @override
  String get syncUsername => 'Tên người dùng';

  @override
  String get syncPassword => 'Mật khẩu';

  @override
  String get syncConnect => 'Kết nối';

  @override
  String get syncConnecting => 'Đang kết nối…';

  @override
  String get syncSignInFailed =>
      'Không thể đăng nhập. Hãy kiểm tra địa chỉ, tên người dùng và mật khẩu.';

  @override
  String syncConnectFailed(String error) {
    return 'Không thể kết nối: $error';
  }

  @override
  String get syncNewSpaceTitle => 'Bắt đầu đồng bộ hóa';

  @override
  String get syncNewSpaceDescription =>
      'Chưa có nhật ký nào được đồng bộ hóa ở đây. Nhật ký này sẽ được tải lên, được mã hóa hai đầu bằng một khóa lưu giữ trên thiết bị của bạn.';

  @override
  String get syncJoinTitle => 'Tham gia nhật ký được đồng bộ hóa';

  @override
  String get syncWrongKey =>
      'Mã khôi phục này không mở nhật ký đã đồng bộ hóa.';

  @override
  String syncLastSynced(String time) {
    return 'Được đồng bộ hóa lần cuối $time';
  }

  @override
  String get syncNever => 'Chưa được đồng bộ hóa';

  @override
  String get syncSyncing => 'Đang đồng bộ hóa…';

  @override
  String syncFailed(String error) {
    return 'Lần đồng bộ hóa cuối cùng không thành công: $error';
  }

  @override
  String get syncLocked =>
      'Nhật ký đã đồng bộ hiện thuộc về các thiết bị khác hoặc đã được bắt đầu lại. Ghép nối với một trong số chúng hoặc sử dụng mã khôi phục để tiếp tục đồng bộ hóa.';

  @override
  String get syncNow => 'Đồng bộ hóa ngay bây giờ';

  @override
  String get syncUnlock => 'Mở khóa';

  @override
  String get syncEncrypted => 'Mã hóa đầu cuối';

  @override
  String get syncDisconnect => 'Dừng đồng bộ hóa';

  @override
  String get syncDisconnectDescription =>
      'Thiết bị này ngừng đồng bộ hóa. Nhật ký ở đây và bản sao được đồng bộ hóa vẫn giữ nguyên như cũ.';

  @override
  String get syncOwnRecoveryPassword =>
      'Sử dụng mật khẩu khôi phục của riêng tôi';

  @override
  String get syncRecoveryPassword => 'Khôi phục mật khẩu';

  @override
  String get syncRecoveryPasswordRepeat => 'Lặp lại mật khẩu khôi phục';

  @override
  String syncRecoveryPasswordTooShort(int min) {
    return 'Sử dụng ít nhất ký tự $min';
  }

  @override
  String get syncRecoveryPasswordMismatch => 'Mật khẩu khác nhau';

  @override
  String get syncRecoveryCode => 'Mã khôi phục';

  @override
  String get syncRecoveryCodeTitle => 'Lưu mã khôi phục của bạn';

  @override
  String get syncRecoveryCodeDescription =>
      'Nếu mọi thiết bị của bạn bị mất, mã này sẽ khôi phục nhật ký đã đồng bộ hóa của bạn. Giữ nó trong trình quản lý mật khẩu hoặc trên giấy. Nó chỉ được hiển thị một lần này.';

  @override
  String get syncRecoveryCodeCopied => 'Đã sao chép mã khôi phục';

  @override
  String get syncRecoveryCodeSaved => 'Tôi đã lưu nó';

  @override
  String get syncJoinNeedsKey =>
      'Nhật ký được đồng bộ hóa này thuộc về các thiết bị khác của bạn. Ghép nối với một trong số chúng hoặc sử dụng mã khôi phục. Các mục trên thiết bị này sẽ được thêm vào nó.';

  @override
  String get syncPairDevice => 'Ghép nối với một thiết bị';

  @override
  String get syncUseRecoveryCode => 'Sử dụng mã khôi phục';

  @override
  String get syncAddDevice => 'Thêm thiết bị';

  @override
  String get syncChangeRecoveryCode => 'Thay đổi mã khôi phục';

  @override
  String get syncChangeRecoveryDescription =>
      'Mã mới thay thế mã hiện tại và mã này sẽ ngừng hoạt động. Dữ liệu của bạn và các thiết bị khác vẫn giữ nguyên như cũ.';

  @override
  String get syncNewRandomCode => 'Mã ngẫu nhiên mới';

  @override
  String get syncRecoveryCodeChanged => 'Mã khôi phục đã thay đổi';

  @override
  String get syncResetSpace => 'Bắt đầu lại nhật ký đã đồng bộ hóa';

  @override
  String get syncResetSpaceDescription =>
      'Chỉ khi không có thiết bị và mã khôi phục nào mở nó ra nữa: bản sao đã đồng bộ hóa sẽ được thay thế bằng nhật ký trên thiết bị này, dưới các phím của thiết bị này. Sau đó, các thiết bị khác của bạn sẽ ghép nối lại.';

  @override
  String get syncPairTitle => 'Ghép nối thiết bị';

  @override
  String get syncPairShow => 'Hiển thị mã';

  @override
  String get syncPairEnter => 'Nhập mã';

  @override
  String get syncPairShowHint =>
      'Trên thiết bị khác của bạn, hãy mở Ghép nối thiết bị, chọn Nhập mã rồi nhập hoặc quét mã này.';

  @override
  String get syncPairEnterHint =>
      'Nhập mã mà thiết bị khác của bạn hiển thị hoặc quét mã đó.';

  @override
  String get syncPairCode => 'Mã ghép nối';

  @override
  String get syncPairScan => 'Quét';

  @override
  String get syncPairStart => 'Cặp';

  @override
  String get syncPairWaiting => 'Đang chờ thiết bị khác…';

  @override
  String syncPairDone(String device) {
    return 'Được ghép nối với $device';
  }

  @override
  String get syncPairWrongCode => 'Mã không khớp. Hiển thị mã mới và thử lại.';

  @override
  String get syncPairNoOffer =>
      'Không có thiết bị nào hiển thị mã này. Nó có thể đã hết hạn.';

  @override
  String get syncPairTimedOut => 'Thiết bị kia không trả lời kịp thời.';

  @override
  String get syncPairNeither =>
      'Chưa có thiết bị nào được thiết lập nhật ký được đồng bộ hóa này.';

  @override
  String get syncPairBoth =>
      'Cả hai thiết bị đều đã mở nhật ký được đồng bộ hóa này.';

  @override
  String syncPairFailed(String error) {
    return 'Ghép nối không thành công: $error';
  }

  @override
  String get syncMediaPending =>
      'Nhật ký đã được đồng bộ hóa · một số phương tiện vẫn đang được truyền';

  @override
  String get syncWaitingForDevices =>
      'Đã đồng bộ hóa nhật ký · đang chờ thiết bị khác truyền phương tiện';

  @override
  String get syncCacheNotice =>
      'Phương tiện đám mây chỉ là tạm thời. Giữ bản gốc trên thiết bị của bạn; đồng bộ hóa không phải là một bản sao lưu.';

  @override
  String get paperTitle => 'Giấy viết thư';

  @override
  String get paperPlain => 'đồng bằng';

  @override
  String get paperLined => 'lót';

  @override
  String get paperGrid => 'Lưới';

  @override
  String get paperTinted => 'nhuộm màu';

  @override
  String get paperDecorationTitle => 'đồ trang trí';

  @override
  String get paperDecorationNone => 'không có';

  @override
  String get paperDecorationBotanical => 'Lá';

  @override
  String get paperDecorationStars => 'Ngôi sao';

  @override
  String get paperDecorationWashi => 'Băng Washi';

  @override
  String get themeDarkChoice => 'Ngoại hình tối';

  @override
  String get themeDarkSame => 'Theo dõi bảng màu sáng';

  @override
  String get themeDarkCustom => 'Bảng màu riêng biệt';

  @override
  String get themeDarkAccent => 'Màu nhấn tối';

  @override
  String get themeColorTeal => 'màu xanh mòng két';

  @override
  String get themeColorCyan => 'lục lam';

  @override
  String get themeColorIndigo => 'màu chàm';

  @override
  String get themeColorCoral => 'San hô';

  @override
  String get themeColorOlive => 'ô liu';

  @override
  String get themeColorSlate => 'Đá phiến';

  @override
  String get drawingTitle => 'Vẽ';

  @override
  String get drawingPen => 'bút';

  @override
  String get drawingEraser => 'Cục tẩy';

  @override
  String get drawingUndo => 'Hoàn tác';

  @override
  String get drawingClear => 'Xóa';

  @override
  String get drawingWidth => 'Chiều rộng bút';

  @override
  String get drawingStylusOnly => 'Chỉ bút cảm ứng';

  @override
  String get drawingDiscardTitle => 'Hủy bản vẽ?';

  @override
  String get drawingDiscardBody => 'Bản vẽ này chưa được lưu.';

  @override
  String get drawingSaveError => 'Không thể lưu bản vẽ.';

  @override
  String get syncNetworkTitle => 'Chẩn đoán mạng';

  @override
  String get syncNetworkRefresh => 'Làm mới';

  @override
  String get syncNetworkSelectedRoute => 'Đường dẫn hiện tại';

  @override
  String get syncNetworkAvailableRoutes => 'Đường dẫn có sẵn';

  @override
  String get syncNetworkSignaling => 'Kết nối thư mục thiết bị';

  @override
  String get syncNetworkRelayRemaining => 'Phụ cấp rơle còn lại';

  @override
  String get syncNetworkIcePair => 'Ứng viên kết nối trực tiếp';

  @override
  String get syncNetworkPeerTrusted => 'Thiết bị được xác thực';

  @override
  String get syncNetworkNoRoute => 'Đang chờ kết nối';

  @override
  String get syncNetworkUnavailable => 'Chẩn đoán không có sẵn';

  @override
  String get syncMediaCopiesTitle => 'Phân phối và sao chép phương tiện';

  @override
  String get syncMediaPendingCount => 'Đang chờ chuyển khoản';

  @override
  String get syncMediaDurableCount => 'Đã gửi tới kho lưu trữ cá nhân';

  @override
  String get syncMediaTemporaryCount =>
      'Bản sao tạm thời hoặc chưa được xác nhận';

  @override
  String get syncMediaReceiptExplanation =>
      'Số lượng này mô tả việc giao hàng đã hoàn thành, không phải là cuộc kiểm tra mới về các bản sao lưu còn sót lại.';

  @override
  String get syncMediaCacheExplanation =>
      'Phương tiện đám mây tạm thời có thể hết hạn. Giữ bản gốc của bạn hoặc một bản sao lưu riêng.';

  @override
  String get momentsTitle => 'Khoảnh khắc ảnh';

  @override
  String get momentsHint =>
      'Tìm nhóm sử dụng thời gian chụp ảnh địa phương và tọa độ tùy chọn. Hình ảnh chỉ được đính kèm khi bạn chọn thẻ.';

  @override
  String get momentsScan => 'Tìm khoảnh khắc';

  @override
  String get momentsChooseFolder => 'Chọn thư mục ảnh';

  @override
  String get momentsLocation => 'Bao gồm các vị trí chụp ảnh';

  @override
  String get momentsEmpty => 'Không có nhóm ảnh gần đây.';

  @override
  String get momentsCreate => 'Viết về những bức ảnh này';

  @override
  String get momentsDismiss => 'Loại bỏ';

  @override
  String get momentsError => 'Không thể đọc ảnh địa phương.';

  @override
  String get momentsCreated => 'Đã tạo mục nhập ảnh.';

  @override
  String get momentsPermission =>
      'Cho phép truy cập vào ảnh để tìm đề xuất địa phương.';

  @override
  String get momentsScope =>
      'Chỉ những bức ảnh gần đây; tối đa 500 ảnh và 20 ảnh mỗi thẻ.';

  @override
  String momentsPhotoCount(int count) {
    return 'Ảnh $count';
  }

  @override
  String get nearbyTitle => 'Kết nối thiết bị';

  @override
  String get nearbySend => 'Ủy quyền cho thiết bị khác';

  @override
  String get nearbyReceive => 'Kết nối với thiết bị hiện có';

  @override
  String get nearbyInstructions =>
      'Kết nối cả hai thiết bị với cùng một Wi-Fi hoặc với điểm phát sóng của nhau. Xác nhận ủy quyền trên thiết bị hiện có; cả hai thiết bị vẫn có thể sử dụng được. Không cần internet.';

  @override
  String get nearbyCompare =>
      'So sánh mã này trên cả hai thiết bị trước khi phê duyệt.';

  @override
  String get nearbyConfirm => 'Các mã trùng khớp';

  @override
  String get nearbyScan => 'Quét mã của thiết bị khác';

  @override
  String get nearbyPaste => 'Dán lời mời';

  @override
  String get nearbyWaiting => 'Đang chờ phê duyệt trên thiết bị khác';

  @override
  String get nearbyWorking =>
      'Cho phép và đồng bộ hóa nhật ký và tệp đính kèm của bạn…';

  @override
  String get nearbyPending =>
      'Một số tệp đính kèm vẫn cần đồng bộ hóa. Giữ thiết bị kia trực tuyến và thử lại.';

  @override
  String get nearbyComplete =>
      'Thiết bị được kết nối; nhật ký và tệp đính kèm được đồng bộ hóa';

  @override
  String get nearbyFailed =>
      'Kết nối không kết thúc. Hãy kiểm tra kết nối cục bộ và thử lại.';

  @override
  String get nearbyEmptyRequired =>
      'Sử dụng thiết bị có nhật ký trống chưa được kết nối để đồng bộ hóa.';

  @override
  String get nearbyRetry => 'Tiếp tục đồng bộ hóa';

  @override
  String get nearbyWifi => 'Cài đặt Wi-Fi';

  @override
  String get nearbyHotspot => 'Cài đặt điểm phát sóng';

  @override
  String get nearbyKeepOpen =>
      'Giữ trang này mở cho đến khi thiết bị mới kết thúc. Lời mời hết hạn sau hai phút.';

  @override
  String get syncDevicesTitle => 'Thiết bị được ủy quyền';

  @override
  String get syncDevicesDescription =>
      'Chỉ những thiết bị được phê duyệt mới có thể truy cập tài khoản AID này. Việc thu hồi thiết bị sẽ chặn máy chủ nhưng không thể xóa khóa chính hoặc nhật ký đã được sao chép vào thiết bị đó.';

  @override
  String get syncDeviceRequest =>
      'Hiển thị mã QR ủy quyền này cho thiết bị được phê duyệt';

  @override
  String get syncDeviceAuthorize => 'Ủy quyền cho một thiết bị';

  @override
  String get syncDeviceAuthorizeDescription =>
      'Quét hoặc dán yêu cầu ủy quyền của thiết bị mới.';

  @override
  String get syncDeviceRevoke => 'Thu hồi';

  @override
  String get syncDeviceRotate => 'Xoay khóa ký của thiết bị này';

  @override
  String get syncDeviceCheck => 'Kiểm tra ủy quyền';

  @override
  String get syncDeviceHardware => 'Khóa ký được hỗ trợ bằng phần cứng';

  @override
  String get syncDeviceSoftware => 'Khóa ký phần mềm không thể xuất được';

  @override
  String get syncDeviceUnavailable =>
      'Ủy quyền thiết bị không có sẵn. Phê duyệt thiết bị này từ một thiết bị được ủy quyền khác và thử lại.';

  @override
  String get syncDeviceRevoked => 'Đã thu hồi';

  @override
  String get syncDeviceLocal => 'Thiết bị này';

  @override
  String get cloudTrafficTitle =>
      'Hạn ngạch truyền dữ liệu đám mây hàng tháng cho các tệp phương tiện';

  @override
  String get cloudTrafficLimit => 'Hạn ngạch truyền dữ liệu hàng tháng';

  @override
  String get cloudTrafficUsed => 'Truyền dữ liệu được sử dụng';

  @override
  String get cloudTrafficRemaining => 'Truyền dữ liệu còn lại';

  @override
  String cloudTrafficResetsAt(String time) {
    return 'Hạn ngạch truyền dữ liệu đặt lại $time';
  }

  @override
  String get cloudTrafficExhausted =>
      'Hạn ngạch truyền dữ liệu đám mây cho các tệp phương tiện đã được sử dụng hết. Các tệp phương tiện bị thiếu sẽ tự động đồng bộ hóa khi có kết nối trực tiếp hoặc khi đặt lại hạn ngạch.';

  @override
  String get cloudTrafficExplanation =>
      'Bộ nhớ đệm tệp phương tiện và chuyển tiếp trực tiếp chia sẻ hạn ngạch truyền dữ liệu này. Kết nối trực tiếp không tiêu thụ nó. Văn bản nhật ký và tin nhắn kiểm soát kết nối có giới hạn nhỏ hàng ngày riêng biệt.';

  @override
  String get appearanceThemeSection => 'Chủ đề ứng dụng';

  @override
  String get appearancePaperSection => 'Giấy nhật ký';

  @override
  String get appearanceTypographySection => 'văn bản nhật ký';

  @override
  String get appearancePreferencesSection => 'Tùy chọn chung';

  @override
  String get themeSystemAccentHint =>
      'Sử dụng bảng màu hệ thống thay vì màu tùy chỉnh. Tắt nó đi để lựa chọn của riêng bạn.';

  @override
  String get syncDeviceNameSaveFailed =>
      'Không thể lưu tên thiết bị. Vui lòng thử lại.';

  @override
  String get nearbyConnectionHelp => 'Trợ giúp kết nối';

  @override
  String get syncAllSynced => 'Mọi thứ đã được đồng bộ hóa';

  @override
  String get syncDetailsTitle => 'Đồng bộ hóa chi tiết';

  @override
  String get syncMore => 'Nhiều lựa chọn hơn';

  @override
  String get syncDeviceName => 'Tên thiết bị';

  @override
  String get syncDeviceNameHint => 'Ví dụ: Máy tính bảng của tôi';

  @override
  String get syncDeviceNameInvalid => 'Sử dụng 1 đến 32 ký tự';

  @override
  String get syncDeviceKeyDetails => 'Chi tiết bảo mật';

  @override
  String get syncConnectionProblem =>
      'Hiện không thể đồng bộ hóa. Đang tự động thử lại.';

  @override
  String get syncCopyComplete =>
      'Bản sao hoàn chỉnh của nhật ký và tập tin media của bạn';

  @override
  String get syncCopyPartial => 'Một số phương tiện vẫn còn thiếu';

  @override
  String get syncCopyOlder => 'Những thay đổi mới đang chờ đồng bộ hóa';

  @override
  String get syncCopyUnavailable =>
      'Chi tiết bản sao không có sẵn. Hãy thử lại sau.';

  @override
  String get syncCopyLastKnown =>
      'Các thiết bị khác hiển thị bản sao được xác nhận cuối cùng của chúng. Hiện không thể kiểm tra các thiết bị ngoại tuyến.';

  @override
  String get syncCopyTemporary =>
      'Bộ đệm tạm thời. Giữ bản gốc trên thiết bị của bạn.';

  @override
  String get syncCopyStorage =>
      'Bộ nhớ đồng bộ hóa của bạn. Quá trình tải lên phương tiện đã hoàn tất được liệt kê trong chẩn đoán.';

  @override
  String syncCopyChecked(String time) {
    return '$time được xác nhận lần cuối';
  }

  @override
  String cloudTrafficSummary(String remaining, String limit) {
    return 'Truyền dữ liệu còn lại trong tháng này: $remaining / $limit';
  }

  @override
  String get onboardNewDiary => 'Bắt đầu ở đây';

  @override
  String get onboardConnect => 'Kết nối với thiết bị hiện có';

  @override
  String get onboardFailed =>
      'Không thể hoàn tất quá trình thiết lập. Nhật ký của bạn được an toàn; vui lòng thử lại.';

  @override
  String get tutorialTitle => 'Cách sử dụng nhật ký';

  @override
  String get tutorialWriteTitle => 'Viết mục nhật ký đầu tiên của bạn';

  @override
  String get tutorialWriteText =>
      'Nhấn + để viết nhật ký. Thêm tiêu đề tùy chọn, chọn ngày nhật ký và nhấn vào dấu kiểm để lưu. Bạn có thể chỉnh sửa lại mục nhật ký của mình bất cứ lúc nào.';

  @override
  String get tutorialMediaTitle => 'Thêm ảnh, âm thanh hoặc chữ viết tay';

  @override
  String get tutorialMediaText =>
      'Sử dụng + trong trình chỉnh sửa nhật ký để đính kèm ảnh, video hoặc bản ghi âm giọng nói hoặc để mở khung vẽ chữ viết tay. Những phần đính kèm này được lưu cùng với mục nhật ký.';

  @override
  String get tutorialReviewTitle => 'Tìm lại một ngày';

  @override
  String get tutorialReviewText =>
      'Duyệt qua nhật ký hoặc lịch của bạn, tìm kiếm bài viết của bạn và sắp xếp các mục bằng thẻ. Các trang Media và Atlas cho phép bạn tìm các mục trước đây theo ảnh hoặc vị trí.';

  @override
  String get tutorialSyncTitle => 'Sử dụng nhiều hơn một thiết bị';

  @override
  String get tutorialSyncText =>
      'Trong Cài đặt → Dữ liệu & lưu trữ → Đồng bộ hóa, kết nối với thiết bị hiện có và xác nhận ủy quyền trên thiết bị đó. Cả hai thiết bị đều có thể tiếp tục sử dụng nhật ký. Văn bản nhật ký được đồng bộ hóa đầu tiên. Tiếp theo, các tệp phương tiện sẽ được đồng bộ hóa khi kết nối mạng và hạn mức truyền dữ liệu còn lại cho phép.';

  @override
  String get tutorialPrivacyTitle => 'Giữ nhật ký của bạn an toàn';

  @override
  String get tutorialPrivacyText =>
      'Các mục nhật ký vẫn còn trên thiết bị này trừ khi bạn bật đồng bộ hóa, chia sẻ hoặc xuất chúng. Đồng bộ hóa được mã hóa hai đầu. Trong Cài đặt, bạn cũng có thể đặt mật mã ứng dụng, tạo bản sao lưu và mở lại hướng dẫn này.';

  @override
  String get editorDiaryDay => 'Ngày nhật ký';

  @override
  String get editorDiaryDayPicker =>
      'Ngày nhật ký · Bài này thuộc về ngày nào?';

  @override
  String editorCreatedAt(String time) {
    return 'Tạo lúc $time';
  }

  @override
  String get editorDiaryDayHint =>
      'Ngày mà mục nhật ký này thuộc về. Thay đổi ngày này không làm thay đổi thời điểm tạo mục.';

  @override
  String get hiddenDiaryTitle => 'Nhật ký ẩn';

  @override
  String get hiddenDiaryHide => 'Ẩn nhật ký';

  @override
  String get hiddenDiaryShow => 'Bỏ ẩn nhật ký';

  @override
  String get hiddenDiaryEmpty => 'Không có nhật ký ẩn';

  @override
  String get hiddenDiaryUnlock => 'Mở khóa nhật ký ẩn';

  @override
  String get hiddenDiaryAuthHint =>
      'Sử dụng khóa ứng dụng hoặc khóa màn hình thiết bị.';

  @override
  String get moodClear => 'Xóa tâm trạng';

  @override
  String get scrollToTop => 'Về đầu trang';

  @override
  String get feedbackTitle => 'Góp ý';

  @override
  String get feedbackHint => 'Mô tả vấn đề hoặc đề xuất';

  @override
  String get feedbackGithub => 'Vấn đề trên GitHub';

  @override
  String get feedbackEmail => 'Gửi email';

  @override
  String get feedbackCopy => 'Sao chép văn bản';

  @override
  String get feedbackLaunchFailed =>
      'Không mở được ứng dụng. Hãy sao chép văn bản và dùng email bên dưới.';

  @override
  String get feedbackCopied => 'Đã sao chép góp ý';
}
