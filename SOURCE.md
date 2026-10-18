# 上游来源

本项目是 Daily You 的修改版，不是 Daily You 官方应用。

- 上游：https://github.com/Demizo/Daily_You
- 基线提交：4b778e0f78d5e36a3a4bbcb5cdc9018776404fef
- 基线版本：3.6.1+3006001
- 许可证：GPL-3.0-only，并遵守 ADDITIONAL_TERMS.md。
- 原作者：Demizo 和 Daily You contributors；原始文件版权标头保留。
- 本地改动：独立应用名／Android ID／Windows 元数据、改版归属提示、Windows 开发脚本；按 Flutter 官方模板打包 native assets；压缩取消改为协作停止，确保关闭文件流；桌面图片解码支持自动识别格式；编辑入口添加稳定的测试 Key。暂不接 AI。
- 当前只导入 Android、Windows 及共享 Dart 源码，不初始化 Flutter SDK 子模块，不配置 iOS。
- 配色扩展：常用主题色预设、始终可见的自定义选色入口、背景色调开关，配置本地保存；新增中英文文案和配色测试。
- 自适应扩展：尺寸与高度断点、常驻侧栏／紧凑导航、内容区独立导航栈、日历与日记分栏、列表与正文分栏、设置内容宽度限制、旋转与草稿测试；显式全屏编辑使用根导航，修正嵌套导航的删除确认归属；取消过期日期渲染并释放图像缓存。布局思路参考 Saber 的响应式导航、StoryPad 的平板体验及 Flutter 官方 adaptive-responsive 文档；未复制这些项目的源码或素材。

- 界面改版：新增“今天”仪表盘（写作灵感、快速心情、连续记录、热力图、最近日记／照片）、日记时间线视图（按月吸顶分组）、正文阅读页排版；主页日历移至“日历”页，启动意图处理移到“今天”页；编辑页支持预选心情和写作灵感。思路参考 Day One、Daylio、StoryPad、Moodiary、DiaryVault，未复制其源码或素材。

旧项目历史保留在 WSL 原仓库 `.git`；旧密钥、数据库备份和上传文件不在此应用源码内。
