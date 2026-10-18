<p align="center">
<img width="500" src="https://github.com/Demizo/Daily_You/blob/master/assets/banner.gif" alt="Daily You Logo">
</p>
<div align="center">
  
# AID Diary

这是基于 [Daily You](https://github.com/Demizo/Daily_You) 的 GPL-3.0 修改版，不是官方应用。上游提交和许可证说明见 [SOURCE.md](SOURCE.md)。原作者版权和附加条款完整保留。

主开发目录：`D:/program/AID-AIDiary/app`。Windows 下运行 `./scripts/dev.ps1 windows`；自动化调试用 `windows-driver`；检查用 `analyze` 和 `test`。使用现有官方 Flutter SDK，不需要 WSL 或初始化 Flutter 子模块。

已经直接复用上游日记、SQLite、日历、照片、心情、标签、搜索、备份与导入导出逻辑。尚未接入 AI 或 mem0，也没有自动导入旧项目的数据和密钥。Android 源码保留，但这份改版尚未在 Android 实测；Web 不在当前上游支持范围，iOS 暂不配置。

验证（2026-10-13）：`flutter analyze` 无问题，281 个测试通过。Windows 构建和原生窗口启动成功，MCP 实际验证设置／About 导航、截图与热重载。Windows 缺少 ATL 通过微软官方安装器补齐；旧 CMake 漏打包 SQLite native asset 已按 Flutter 官方模板修正；压缩取消改成协作停止并关闭文件流，修复 Windows 文件占用；桌面缩略图改为自动检测格式，避免对 WebP 使用 JPEG 解码器。

自动化边界：按 `FloatingActionButton` 类型查找会命中离屏相册按钮并超时，编辑入口已添加稳定 Key。一次热重启后的 Widget Inspector 只返回 root，尚未确认根因；当前保留普通入口窗口，不声称自动化 CRUD／热重启完全验证。数据库保存／取消／恢复等已有测试通过，完整端到端保存体验仍需进一步测试。

主题配色：设置 → 外观 → 主题色，可直接选择天空蓝、森林绿、暖咖棕、薰衣紫、烟粉玫瑰、琥珀橙，也可使用自定义选色器。选色自动关闭跟随系统强调色；“背景跟随主题色”关闭后，背景变为中性黑灰／白灰，按钮保留所选强调色。浅／深色模式和 AMOLED 的原有入口保留；配置仍保存在本地，不改系统配色。新增中英文文案、移动宽度与配置保存／对比度测试。

配色验证：285 个测试通过，静态检查无问题；Windows 实测森林绿、暖咖棕、中性背景和重新启动后的配置恢复，热重载及错误检查通过。测试后恢复原有蓝色／跟随系统与背景染色，外观设置窗口保持打开。截图见 `artifacts/theme-color-green.png` 和 `artifacts/theme-color-neutral-brown-final.png`。新配色未在实体 Android 上实测。

宽屏适配（2026-10-13）：沿用 Material 风格，按窗口逻辑尺寸适配，不判断设备名称或强制锁屏。窄于 600 的窗口保留底部导航；其余使用 80 宽紧凑侧栏，宽度至少 1200 且高度至少 600 时展开为 240 宽侧栏。内容区至少 700×280 时，首页显示“日历＋所选日期日记”，日记浏览显示“列表＋正文”。设置和普通编辑通过内容区独立 Navigator 打开，不再盖住侧栏；只有主动展开文本编辑器才覆盖整个应用。外观和设置列表限制阅读宽度。缩放保留导航栈、草稿和所选条目，日历按行比例保留浏览位置，旧尺寸的日期图像缓存会取消并释放。

适配验证：300 个测试通过，静态检查无问题。新增导航尺寸／返回保护测试和使用临时 SQLite 的真实页面测试，覆盖 360～1920 宽、手机横屏 844×390、模拟软键盘、编辑保存／删除、设置返回和列表选择。Windows 原生窗口启动、截图和热重载已验证。Android 尚未构建／设备实测：当前 SDK 只有 API 35／36，而上游要求 API 37；不把窗口尺寸测试声称为 Android 真机验证。未修改用户日记数据或原有配色。

界面改版（2026-10-18）：参考 Day One、Daylio，以及本地只读参考 StoryPad／Moodiary／DiaryVault 的界面思路（未复制源码或素材），导航改为“今天／日记／日历／统计”。“今天”页：问候与连续记录徽标、今日卡片（未写时一键选心情或拍照开写，已写时显示预览并继续写）、四格统计（连续、最长、本月篇数、总字数）、每日写作灵感（可换一个，未作答的灵感草稿不会保存）、按周排列的记录足迹热力图、往昔重现、最近日记和最近照片，宽屏分两栏。“日记”页默认时间线视图：按月吸顶标题并显示当月篇数与有记录天数，左侧日期列同一天只显示一次，行内显示标题／摘要、时间、心情、字数、标签图标和缩略图；搜索栏可切换时间线／列表／网格。正文页改为大日期标题、星期·年份·时间、字数与阅读时长，单张照片宽幅显示。新增中英文和繁中文案。

改版验证：`flutter analyze` 无问题，312 个测试通过（新增摘要提取、今天页多尺寸无溢出、快速心情保存、未作答灵感不保存、日记按月分组与打开条目）。Windows 原生窗口实测宽屏与窄屏截图：`artifacts/ui-today-wide.png`、`ui-today-compact.png`、`ui-journal-timeline.png`、`ui-entry-view.png`。Android 仍未实测。

以下保留上游项目介绍：

# Daily You

[<img src="https://f-droid.org/badge/get-it-on.png" height="80">](https://f-droid.org/en/packages/com.demizo.daily_you/)
[<img src="https://gitlab.com/IzzyOnDroid/repo/-/raw/master/assets/IzzyOnDroid.png" height="80">](https://apt.izzysoft.de/fdroid/index/apk/com.demizo.daily_you)
[<img src="https://github.com/machiav3lli/oandbackupx/blob/034b226cea5c1b30eb4f6a6f313e4dadcbb0ece4/badge_github.png" alt="Get it on GitHub" height="80">](https://github.com/Demizo/Daily_You/releases/latest)

[<img src="https://img.shields.io/badge/Liberapay-F6C915?style=for-the-badge&logo=liberapay&logoColor=black" width="auto" height="100" alt="Donate using Liberapay">](https://liberapay.com/Daily-You/donate)
[<img src="https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black" width="auto" height="100" alt="Buy me a Coffee">](https://buymeacoffee.com/demizo)

### Every day is worth remembering…

---

</div>

Capture the moments that matter. **Daily You** helps you log your thoughts, track your mood, and keep a diary of meaningful moments, every day. Whether you're journaling, reflecting, or just noting what made you smile, **Daily You** gives you a private space that's truly your own.

Join a community that believes **your journal should be yours**, not a product.

<p align="center">
<img width="200" src="https://github.com/Demizo/Daily_You/blob/master/fastlane/metadata/android/en-US/images/phoneScreenshots/1_home.png" alt="home page">
<img width="200" src="https://github.com/Demizo/Daily_You/blob/master/fastlane/metadata/android/en-US/images/phoneScreenshots/2_gallery.png" alt="gallery page">
<img width="200" src="https://github.com/Demizo/Daily_You/blob/master/fastlane/metadata/android/en-US/images/phoneScreenshots/3_stats.png" alt="stats page ">
<img width="200" src="https://github.com/Demizo/Daily_You/blob/master/fastlane/metadata/android/en-US/images/phoneScreenshots/4_entry_view.png" alt="journal entry">
</p>

### Features

✍️ **Take daily logs:** Journal your thoughts, reflections, or routines.

📈 **Track your mood:** Gain insight into how your mood changes over time.

🖼️ **Keep photo memories:** Add pictures to enrich your memories.

📝 **Rich note taking:** Format notes your own way with Markdown.

🔔 **Gentle reminders:** Random daily nudges to keep you consistent.

🔒 **Control your data:** Choose where your data lives, including external storage.

🌐 **Offline-first:** Works without internet. Always.

**Daily You** is free, open source, and community supported. Built around the belief that your diary should be yours forever, not a subscription. No accounts, no ads, no locked features, and no tracking or data collection. Just your story, on your device, owned by you.

## Download 

[![Downloads](https://img.shields.io/github/downloads/Demizo/Daily_You/total)](https://github.com/Demizo/Daily_You/releases)
[<img src="https://shields.rbtlog.dev/simple/com.demizo.daily_you" alt="RB Status">](https://shields.rbtlog.dev/com.demizo.daily_you)

[<img src="https://f-droid.org/badge/get-it-on.png" height="80">](https://f-droid.org/en/packages/com.demizo.daily_you/)
[<img src="https://gitlab.com/IzzyOnDroid/repo/-/raw/master/assets/IzzyOnDroid.png" height="80">](https://apt.izzysoft.de/fdroid/index/apk/com.demizo.daily_you)
[<img src="https://github.com/machiav3lli/oandbackupx/blob/034b226cea5c1b30eb4f6a6f313e4dadcbb0ece4/badge_github.png" alt="Get it on GitHub" height="80">](https://github.com/Demizo/Daily_You/releases/latest)

## Support The App
**Daily You** is _free forever_ since everyone deserves a journal that is truly their own. If you find yourself enjoying the app, please consider supporting its continued development.

[<img src="https://img.shields.io/badge/Liberapay-F6C915?style=for-the-badge&logo=liberapay&logoColor=black" width="auto" height="100" alt="Donate using Liberapay">](https://liberapay.com/Daily-You/donate)
[<img src="https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black" width="auto" height="100" alt="Buy me a Coffee">](https://buymeacoffee.com/demizo)

## Migrate From Another App
Are you coming from another app? **Daily You** supports migrating from other apps. Simply go to `Settings > Backup & Restore > Import From Another App` and select your previous app. Feel free to request any apps not currently listed. **Note:** Imports from some apps may not be one-to-one since **Daily You** may have different features.

## Languages 
Everyone should have access to a journal! **Daily You** uses [Weblate](https://weblate.org) to easily manage translations. If you would like to help translate the app, please visit [the Daily You project on Weblate](https://hosted.weblate.org/projects/daily-you/), thank you!

<div align="center">
<a href="https://hosted.weblate.org/engage/daily-you/">
<img src="https://hosted.weblate.org/widget/daily-you/multi-auto.svg" alt="Translation status" />
</a>
</div>

## Development
The full development environment is defined using [Nix](https://nixos.org/). Simply, install the [Nix Package Manager](https://nixos.org/download/), clone the repository, enter the project directory, and run `nix develop`, that's it! Alternatively, **Daily You** is built using Flutter. You can directly [install Flutter](https://docs.flutter.dev/get-started/install), clone the repository, enter the project directory, and run `flutter pub get`.

## License
This software is free software licensed under the [GNU General Public License 3.0](LICENSE.txt). Additional terms under section 7 of that license apply; see [ADDITIONAL_TERMS.md](ADDITIONAL_TERMS.md).
