# AID Diary

[English](../../README.md) | **简体中文** | [日本語](README.ja.md) | [한국어](README.ko.md)

一款用 Flutter 写的私人日记应用，支持 Windows、Android 和 Linux。

最新 `main` 的构建在 [nightly 预发布版本](https://github.com/playeriv65/AID-AIDiary/releases/tag/nightly)里（Android APK、Windows 压缩包和 Linux tar 包）。它们用调试密钥签名，可以全新安装，但不能覆盖用正式密钥签名的安装。

## 界面

手机上是底部导航栏，平板和电脑窗口上是侧边导航栏加列表/详情双栏。

在手机、平板和 Windows 上，搜索栏都固定在滚动列表上方。长时间浏览日记时会出现一个小的回到顶部按钮。反馈入口在"设置 > 帮助"，写完一点就能直接发送，也可以去 GitHub 提 issue 或发邮件。Windows 保留系统原生标题栏，显示应用图标和 AID Diary 名称，边框颜色跟随应用主题；见 [Windows 安装说明](../SETUP.md#windows-personal-installation)。

| 平板 / 电脑 | 手机 |
|---|---|
| ![日记](../../artifacts/ui-tablet-journal.png) | ![日记](../../artifacts/ui-phone-journal.png) ![日记详情](../../artifacts/ui-phone-entry.png) |
| ![日历](../../artifacts/ui-tablet-calendar.png) | ![日历](../../artifacts/ui-phone-calendar.png) ![媒体](../../artifacts/ui-phone-media.png) |
| ![媒体](../../artifacts/ui-tablet-media.png) | ![写作计划](../../artifacts/ui-phone-coach.png) ![搜索](../../artifacts/ui-phone-search.png) |
| ![写作计划](../../artifacts/ui-tablet-coach.png) | ![编辑器](../../artifacts/ui-phone-editor.png) ![分享](../../artifacts/ui-phone-share.png) |
| ![写作计划详情](../../artifacts/ui-tablet-coach-program.png) | ![地点](../../artifacts/ui-phone-location-picker.png) ![分享为](../../artifacts/ui-phone-share-as.png) |
| ![写作计划故事](../../artifacts/ui-tablet-story-prompt.png) | |
| ![手写](../../artifacts/ui-tablet-backlog-drawing.png) | ![外观](../../artifacts/ui-phone-backlog-appearance.png) |
| ![信纸](../../artifacts/ui-tablet-backlog-lined.png) | ![本地照片建议](../../artifacts/ui-phone-backlog-moments.png) |
| | ![随机漫步](../../artifacts/ui-phone-random.png) ![周回顾](../../artifacts/ui-phone-week-review.png) |
| ![首次启动](../../artifacts/ui-tablet-first-start.png) | ![首次启动](../../artifacts/ui-phone-first-start.png) |
| ![教程](../../artifacts/ui-tablet-tutorial.png) | ![教程](../../artifacts/ui-phone-tutorial.png) |
| ![日记日](../../artifacts/ui-tablet-diary-day-picker.png) | ![日记日](../../artifacts/ui-phone-diary-day-picker.png) |

- **日记**：上方是故事，下面是按天分组的日记，显示时间、标题、摘要、心情、地点、天气、标签和缩略图；可按日记日期（正序或倒序）或最后修改时间排序。故事包括：今天、写作计划的当天内容、那年今日、已开启的时间胶囊、早晚写作提示、快速打卡、随机漫步、本周和本年回顾。今天、写作计划和那年今日连成一组播放（统计、30 天心情图、当场回答的当天提示、那年今日、结束卡片），宽窗口上以卡片形式显示。
- **首次启动**：选择"从这里开始"或"连接已有设备"。只读的教程介绍写作、媒体、查找日记、同步和隐私，可以在设置里重新打开。已有设备授权这次连接，新设备接收日记期间旧设备照常可用。
- **就近迁移与设备授权**：扫描旧设备，核对一个短码，然后直接传输身份和经过校验的日记与媒体。每台设备生成自己的、不可导出的签名密钥；批准新设备时不会复制旧设备的签名密钥。网络诊断会说明待传的媒体，并显示官方服务器的实际用量。官方媒体套餐启用后默认每月 1 GB；自建服务默认不限额、媒体持久保存，管理员可以另设上限。
- **外观与手写**：浅色和深色各自独立的配色，横线、方格、色纸三种信纸，以及原创的植物、星星和纸胶带装饰。手写画布使用 Scribble 和 perfect_freehand，图画存为普通的 PNG 附件，支持只用手写笔输入。
- **本地照片建议**：可选，在设备上按时间（也可按地点）分组，扫描范围有限，需要你明确选择才导入。不会为了生成建议而删除或上传原照片。
- **随机漫步**：每次一篇随机的过往日记，全部看过一遍之前不重复；可选全部日记、只看有照片的，或只看心情好的日子。
- **回顾**：以故事幻灯片呈现一周或一年：篇数、心情（7 天一行，或全年像素图）、最常用的标签和地点、照片、每月篇数和一篇精选。
- **快速打卡**：一个心情加一行字，两下点击存成一篇日记。
- **时间胶囊**：把一篇日记封存到某个日期；在那之前它显示为锁定，不出现在搜索、那年今日、随机漫步、媒体和地图中。也可以提前打开。
- **日历**：日记页的日历按钮在原地展开可滚动的月份；点某一天，列表翻到那一天。日历页（平板，或 `ui.navigate`）在月份旁边显示所选那天。
- **媒体**：所有附带的照片、视频和语音。
- **地图**：在 OpenStreetMap 地图上显示带地点的日记，每个点是一个带数字的圆；一个点有多篇时点开是这些日记的列表。双指缩放时，除非明显转动，否则地图不会旋转；只转了一点的地图会回正朝北。
- **评论与引用**：在以前某天的日记里选中文字，可以收藏这段或评论它，也可以评论整篇。评论就是一篇今天的日记，引用它所回应的内容；可以只写几行，也可以展开成完整编辑器。任何日记都能引用通过搜索找到的其他日记，日记下方会列出回应它的日记。收藏的段落集中在一处。编辑过往日记前会先确认（可选"不再提示"）。
- **写作计划**：内置的提示计划和模板，也可以用自己的模板。计划显示时长、间隔和难度；加入后，每天或每周的问题出现在故事里（Android 上还有通知），回答存成一篇日记。
- **日记详情**：照片、视频和语音，日期块、元数据、正文；可以加星、分享为图片、带原始媒体的 ZIP、纯文本或 HTML 页面，编辑、存为模板、封存为时间胶囊、删除；上一篇/下一篇。
- **编辑器**：顶部是日记日（只有写作时间在另一天时才显示写作时间），心情和标签在右侧；标题可选（写了标题的日记才有标题）；正文；"+"按钮可从相册或文件添加照片和视频、拍照（Android）和录语音（会建议把照片的日期和地点用于这篇日记）；地点和天气行，新日记会自动填写；天气是日记日在该地点的天气，可查询也可手填，同一天同一地点的日记共用。写作时键盘上方有一条工具栏，提供模板和 Markdown 格式以及插入菜单（待办清单、编号列表、表格、分隔线、代码块），收起键盘时随之消失。有修改时返回会询问是否保存；完成按钮直接保存。内置模板包括晨间日记和晚间回顾。
- **时间**：日记保存写作地当时的时间，并记录当地的 UTC 偏移，所以飞到另一个时区什么也不会变；来自别的时区的日记会标出时区（例如 UTC+8）。Journey 和 Day One 的导入导出按每篇日记自己的时区换算。每篇日记都同时保存写作时间和它所属的日记日；所有按天统计的地方（日记列表、日历、连续天数、回顾、统计、提醒、小组件）都用日记日，日记日可以随时在编辑器里修改而不动写作时间。4:00 之前写的新日记算前一天（标一个小月亮），4:00 到 6:00 之间编辑器会问算哪一天（未回答时算今天），之后算当天；这两个钟点都可以在设置里改，只影响新日记。事后补写某天的日记会显示实际写作时间。
- **语言**：默认跟随系统；"通用"设置里的一个"应用语言"选项可以直接切换。
- **心情**：编辑器心情按钮下方直接列出五种心情和一个清除操作。点选立即生效，无需确认。
- **地点**：一键使用当前位置，可以重命名或删除；选择器支持自定义名称、收藏的地点、地点搜索、附近地点和最近地点。
- **搜索**：标题和正文搜索，加上内嵌的标签、星标和心情筛选。
- **统计**：连续天数、心情变化、"是什么让我感到……"（与某种心情最常同时出现的标签）以及全年像素图。
- **最近删除**：删除的日记保留 30 天（可设置）后才彻底清除；可以恢复或提前清除。
- **同步**（可选）：通过你自己的 Google Drive（应用只能看到它自己的 `AID Diary` 文件夹）、你选择的 WebDAV 服务（Nextcloud、群晖、坚果云等）或 `server/` 里的 AID 同步服务器，让每台设备上的日记、照片、标签和模板保持一致。始终端到端加密，没有日记账号和密码：每台设备都持有用户的密钥，新设备通过与已设置好的设备配对获得密钥（任一台显示代码，另一台输入或扫码），所有设备都丢失时用恢复码（随机生成或自己设定）找回。存储里只有密文。附近受信任的设备之间直接交换数据。使用兼容 AID 的 WebDAV 账号和新版网络服务时，设备还会探测公网 IPv4/IPv6 路径、尝试 WebRTC/STUN，必要时使用有限额的实时中转；Google Drive 和普通 WebDAV 只用局域网加存储。日记文字先同步；经过校验的媒体分块在额度允许时可以跨路径续传。状态区分"日记已同步""还有媒体在传""等待另一台设备"。实时中转需要两台设备同时在线；单独的临时媒体缓存不需要，但两者都不是备份。修改会在几秒后、应用打开期间同步；两台设备改了同一篇日记时，较新的版本胜出，另一版保留在"最近删除"里。只有同步失败的日记才会被标记一个划掉的小云朵。网络路径和已验证的情况见 [docs/SYNC_NETWORK.md](../SYNC_NETWORK.md)。
- **设备与同步详情**：每台设备默认以型号或电脑名命名，可以改名。配对后自动发现受信任的设备；日常状态保持简洁。打开同步详情可以看到各个已命名的完整/部分副本，以及另一台设备上次确认内容的时间。临时云缓存单独标明；网络和密钥细节放在更多选项里。
- **导出**：JSON（每篇日记及其标题、地点、天气、标签和附件名；JSON 导入可以读回）、Markdown，以及 Journey 和 Day One 能导入的归档，此外还有完整备份。
- **导入**：[一本日记 v3 备份](../ONE_DIARY_IMPORT.md)，保留原始日记日期、隐藏标记和本地附件；Journey 备份（两种格式）和 Day One JSON 导出，含照片、标签、星标、地点和天气（活动转为标签）；以及 Daybook、Daylio、Diarium、Diaro、My Brain、OneShot 和 Pixels。
- **隐藏日记**：在"设置 → 安全"里经本地验证才能打开的区域，不出现在普通列表、搜索、小组件、导出和命令行内容中。隐藏只是界面上的事：隐藏日记照常同步，并在每台设备上保持隐藏；完整备份像其他日记一样保留它们。详见[具体边界](../ARCHITECTURE.md#hidden-entries)。
- **标签**：新日记本没有任何标签；标签保持你拖出来的顺序（在选择器里长按），日记卡片上显示标签名，导入带来的标签按使用次数排序。
- **照片**：默认原样保存。可以选择把新照片存成约 1 MB 的 WebP，也可以把已有照片一次性压缩（不可撤销）。
- **设置**：通用（主题、壁纸、正文字体、字号和行距、单位、12/24 小时制、决定新日记日记日的钟点、自动添加地点和天气）、数据与存储（备份、导出、最近删除）、故事（早晚提示、那年今日）、通知（Android：按星期的提醒、那年今日、几天没写后的提醒、常驻的快速记录通知）、安全、帮助（常见问题、隐私）和关于。
- **命令行与智能体**：每个功能都是一个动作，应用的按钮、命令面板（Windows 上按 Ctrl+K；"设置 → 命令行 → 所有命令"）和 `aid` 命令行运行的是同一套，所以脚本或 AI 智能体做的事会实时显示在应用里。正式版默认关闭，需在"设置 → 命令行"中开启；API 只在本机监听，每次启动生成新令牌。
- **Android 桌面小组件**：今日状态、每日一张日记照片、连续天数、每日写作提示和快速心情。点击提示或心情会打开一份可编辑的草稿，而不是悄悄存下一篇日记。

日记、照片和坐标都留在设备上；只有打开同步后，才会加密发送到你选择的存储和受信任的设备。联网功能都是可选的，配置在 [assets/config/app_config.json](../../assets/config/app_config.json)：

- OpenStreetMap 地图瓦片，以及 Nominatim 地名和地点搜索。
- Overpass（OpenStreetMap）查询当前位置附近有名字的地点，只在带位置打开地点选择器时使用。
- Open-Meteo 天气（近几天用预报，较早的日记用历史数据）；只发送坐标和日期。
- Google 登录和 Drive API，只在用 Google Drive 同步时使用（[docs/GOOGLE_DRIVE.md](../GOOGLE_DRIVE.md)）。
- 开启同步时的受信任设备发现和加密同步传输：局域网 DNS-SD；对于兼容 AID 的 WebDAV 网络服务，还有经过认证的信令、公网直连探测、配置的 STUN 和有限的实时中转。应用不提供 TURN 服务。

除存储和通知外的 Android 权限：位置（地点，在打开新日记或地图时请求）和麦克风（语音），都只在用到该功能时才请求。

## 语言

界面默认跟随系统语言偏好，可以在设置里另选。使用 Flutter 官方的本地化流程，翻译随应用打包，离线可用。全部 35 个语言变体都覆盖英文消息模板；目录测试检查缺失或为空的消息以及动态参数。翻译覆盖不代表经过母语者审校。匹配规则、翻译维护和验证见[国际化](../ARCHITECTURE.md#internationalization)。

## 开发

主要开发环境是 Windows（不用 WSL，不用 SDK 子模块）。从[文档索引](../INDEX.md)和[维护交接](../HANDOFF.md)开始：它们把环境搭建、架构、产品决策、测试和各子系统的问题指向对应的文档，并标出最近一次带日期的检查点。[工程原则](../ENGINEERING.md)说明我们如何采纳 Flutter/Google 的指南、审查改动和维护文档。[环境搭建](../SETUP.md)介绍新电脑、本地工具链配置、签名和测试设备。

```powershell
./scripts/dev.ps1 pub          # 新检出后解析应用和 CLI 的依赖
./scripts/dev.ps1 l10n         # 修改 ARB 后重新生成本地化代码
./scripts/dev.ps1 test -TestFiles test/sync/local_device_test.dart # 受影响的文件/目录
./scripts/dev.ps1 test-all     # 有意识地跑完整离线回归
./scripts/dev.ps1 analyze      # 静态分析
./scripts/dev.ps1 screenshots  # 无窗口重新生成 artifacts/ui-*.png
./scripts/dev.ps1 windows      # 运行 Windows 应用
./scripts/dev.ps1 windows-build # 构建 Windows 版，不打开窗口
./scripts/dev.ps1 windows-stage # 把该构建放到固定的 DEV_WINDOWS_RUNTIME，不启动
./scripts/dev.ps1 windows-profile-build # 独立的 Windows 性能构建
./scripts/dev.ps1 windows-profile-stage # 把 profile 构建放到同一固定路径
./scripts/windows_scroll.ps1 -Label current # 验证滚动条遍历和帧时间线
./scripts/windows_scroll.ps1 -Label wheel -WheelOnly # 鼠标滚轮动画和帧节奏
./scripts/dev.ps1 android      # 在模拟器上运行
./scripts/dev.ps1 apk          # 构建调试 APK（dev 风味）
./scripts/dev.ps1 profile -Device <serial>     # 以 profile 模式安装 dev 应用
./scripts/dev.ps1 frame-rate -Device <serial>  # 在 4000 篇日记下测它的帧率
./scripts/dev.ps1 frame-rate -Device windows   # 在本机隐藏窗口、用临时数据测同样的项目
./scripts/dev.ps1 release      # 构建签名的正式 APK 并安装到已连接的设备
./scripts/dev.ps1 cli          # 把 aid 命令行构建到 build\cli\aid.exe
```

`aid` 与正在运行的应用通信，可以在本机，也可以通过 adb（需要时会在那边启动 dev 风味）：

```powershell
aid actions                          # 所有动作及其参数
aid guide                            # 同样内容，写成给智能体的指南
aid entry.list limit=5
aid -d <adb serial> entry.seed count=4000
aid -d <adb serial> sync.now
aid sync.network                      # 路由、选中的 ICE 对和额度
aid sync.network_paths paths=ice,cache stunOnly=true  # 仅开发构建
aid entry.delete id=12 --yes         # 破坏性动作需要 --yes
```

Android 构建使用 JDK 23：根目录的 `android/build.gradle` 让每个模块的 Kotlin 使用与其 Java 相同的 JVM 目标，因为很多插件没有设置它。Flutter 的 Android SDK 路径用 `flutter config --android-sdk` 固定。

项目级的[测试策略](../TESTING.md)规定了改动与测试的对应关系、完整回归和发布门槛、关键流程以及结果报告方式，覆盖 Flutter、Go、CLI 和原生平台。独立的纯逻辑可以用针对性的单元测试；界面、持久化和原生行为需要在各自所属的层测试。完整回归用于范围大或风险高的改动、发布门槛，以及每个活跃开发日收尾时的一次兜底；测过且未改动的状态可沿用已有结果。分层目标（`test-unit`、`test-widget`、`test-integration`）也接受 `-TestFiles`；外部服务需要显式运行 `test-live`。GitHub Actions 检查每次推送到 `main` 的提交，并每天打包 nightly 构建（[持续集成](../TESTING.md#continuous-integration)）。

截图由 `tool/screenshots/` 里的 widget 测试用真实字体渲染（Flutter SDK 图标、Windows 的 Noto Sans SC 和 Segoe Emoji），不打开窗口。传入 `-TestFiles` 只渲染受影响的截图文件并检查图片：这些脚本不会自动比对基准图。

平台：Windows、Android 和 Linux（nightly 提供安装包；Linux 上暂时不能播放视频和语音，隐藏日记需要设置应用密码）。iOS 和 macOS 以后会做；网页版未配置。

## 许可证

GPL-3.0-only（[LICENSE.txt](../../LICENSE.txt)），附加条款见 [ADDITIONAL_TERMS.md](../../ADDITIONAL_TERMS.md)。来源与署名见 [SOURCE.md](../../SOURCE.md)。
