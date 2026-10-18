# AID Diary

- 和用户说中文，Python 使用 uv。
- 这是基于 Daily You 的 GPL-3.0 改版；保留上游版权、LICENSE.txt 和 ADDITIONAL_TERMS.md，明确与官方版区分。不推送、不发布，除非用户明确要求。
- 主开发环境 Windows；SDK D:/software/flutter，PUB_CACHE D:/software/pub-cache。平台先 Windows/Android，iOS 不配置。Web 当前上游未支持，不声称可编译。
- 优先复用上游日记、SQLite、日历、照片、心情、搜索、备份逻辑；暂不集成 AI、mem0 或云服务。
- 当前日记数据和旧项目数据隔离。不要自动导入旧日记或密钥，不删除父目录 .private-legacy。
- 使用 scripts/dev.ps1 启动和检查。测试自动化入口放 test_driver/，普通发布入口不启用 Driver。
- 本机配置遵循官方工具；不改注册表、安全设置或全局代理。不复制 Flutter 子模块，使用已安装的官方 SDK。
