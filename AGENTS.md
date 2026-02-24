# AGENTS.md - AI Agent 开发指南

## 语言规范
- 保持使用中文回答

## 提交规范
- 提交之前必须向用户报告
- 提交之前维护配置文件：.gitignore、README.md、AGENTS.md
- **经验教训**：遇到的问题和解决方案要及时更新到 AGENTS.md 和 README.md

## 运行规范
- Windows 环境使用 PowerShell 命令（bash 工具在 Windows 上有兼容性问题）
- 运行前杀掉无用进程：`powershell -Command "Stop-Process -Name 'node','python' -Force -ErrorAction SilentlyContinue"`
- 运行前检查端口占用，有旧进程直接杀掉
- 运行后检查是否成功运行（curl 测试 API 或检查端口）
- 使用内置浏览器调试 UI
- **后台启动服务**: 使用 `Start-Process` 避免 bash 超时终止进程

## 项目架构
- Frontend: Expo (React Native Web) + TypeScript
- Backend: FastAPI + SQLite + uv 包管理

## 运行命令
- **后端**: `cd backend && uv run uvicorn main:app --reload` (端口 8000)
- **前端**: `cd frontend && npm run web` (端口 8081)
- **前端 lint**: `cd frontend && npm run lint`
- **测试数据**: `cd backend && uv run python seed_data.py`

## 目录结构
```
frontend/
  app/        # 页面路由（expo-router）
  components/ # 可复用组件
  context/    # AppContext 全局状态
  constants/  # i18n.ts 国际化, config.ts 配置, theme.ts 主题

backend/
  main.py     # FastAPI 入口
  auth.py     # JWT 认证
  crud.py     # 数据库操作
  models.py   # SQLAlchemy 模型
  schemas.py  # Pydantic schemas
  ai_service.py # OpenAI 集成
  seed_data.py # 测试数据生成
```

## 代码规范
- TypeScript/TSX: 遵循 ESLint (expo config)
- Python: 遵循 PEP 8
- 不添加不必要的注释
- **禁止未使用的 import**: 提交前必须运行 lint 检查，清除警告
- **组件统一**: 使用 ThemedText 而非 Text，保持字体风格一致
- **API 地址**: 使用 `constants/config.ts` 中的 CONFIG.API_URL，不要硬编码
- **图片 URL 规范**: 
  - 后端：存储/返回纯文件名（如 `uploads/xxx.jpg`），不加 `/static/` 前缀
  - 前端：统一拼接 `CONFIG.STATIC_URL + '/' + image`，不加特判

## 测试规范
### 后端（Python/FastAPI）
- **测试框架**: `pytest` + FastAPI `TestClient`
- **测试文件**: `backend/test_main.py`
- **运行测试**: `cd backend && uv run pytest`
- **覆盖场景**: CRUD、图片上传、AI润色、认证
- **数据库**: 使用 SQLite 内存数据库进行隔离测试

### 前端（Expo/React Native）
- **测试框架**: `Jest` + `@testing-library/react-native`
- **预设**: `jest-expo`（与 Expo SDK 版本严格对齐）
- **测试目录**: `frontend/__tests__/`
  - `components/` - 组件测试（TagManager, EntryMetadata, EntryCard）
  - `hooks/` - Hook 测试（useJournalEntry, useImageUpload）
- **运行测试**: `cd frontend && npm test`
- **覆盖率**: `npm run test:coverage`

### 测试设计原则（重要）
1. **避免过度 Mock**: 原生模块（Alert, AsyncStorage）依赖 jest-expo 自动 mock，不手动 mock
2. **依赖注入**: Hook 通过参数接收副作用函数（如 `alertFn`），便于测试时替换
3. **纯函数优先**: 业务逻辑集中在 Hook，组件仅负责渲染
4. **隔离性**: 每个测试独立，不依赖全局状态

### 版本对齐要求
- `jest-expo` 版本必须与 `expo` SDK 主版本一致（如 SDK 54 → `jest-expo@^54.0.0`）
- `react-test-renderer` 版本必须与 `react` 版本完全一致
- 使用 `npx expo install` 自动安装兼容版本

### 当前测试状态
- ✅ 后端：12/12 测试通过（~60% 覆盖率）
- ⚠️ 前端：框架已就绪，组件测试 21/21 通过，Hook 测试待完善

## UI 规范
- **字体统一**: 使用 `constants/theme.ts` 中的 `FontSizes`, `FontWeights`, `LineHeights`
- **颜色统一**: 使用 `constants/theme.ts` 中的 `Colors` 对象
- **组件复用**: 使用 `ThemedText`, `ThemedView`, `Picker` 等组件
- **弹窗选择**: 使用 Modal 组件，避免下拉菜单被父容器裁剪
- **图标**: 使用 Phosphor Icons (IconSymbol 组件)

## 常见问题
### Windows bash 兼容性
- `taskkill /F /PID xxx` 会被解析成路径，使用 PowerShell 代替
- bash 超时 120 秒会终止进程，后台服务用 `Start-Process`

### 中文编码问题
- curl 发送中文会有编码问题，使用 Python 脚本代替

### React Native Web 图片上传
- `expo-image-picker` 在 Web 上返回特殊 URI 格式
- 必须先 fetch 获取 blob，再传给 FormData：
  ```typescript
  const blob = await fetch(asset.uri).then(r => r.blob())
  formData.append('file', blob, { filename: 'photo.jpg' })
  ```

### CORS 问题
- 前端 `localhost` 和 `127.0.0.1` 被视为不同来源
- 后端 CORS 要同时允许两个地址

### 数据库修改
- 修改 models.py 后需删除 aidiary.db 重建数据库
- 或使用 Alembic 进行迁移

## 环境变量
- 复制 backend/.env.example 为 backend/.env
- 必填: OPENAI_API_KEY, SECRET_KEY

## 功能清单
| 功能 | 状态 | 说明 |
|------|------|------|
| 日记时间线 | ✅ | 首页列表展示 |
| 日记详情/编辑 | ✅ | 点击卡片进入编辑页 |
| 分类选择 | ✅ | 工作/生活/学习/旅行/健康/其他 |
| 天气选择 | ✅ | 晴天/多云/雨天/雪天/大风/雾霾 |
| 地点设置 | ✅ | 点击输入 |
| 标签功能 | ✅ | 弹窗添加/删除 |
| 列表模板 | ✅ | 插入 • 列表 |
| 任务模板 | ✅ | 插入 ☐ 任务 |
| 时间插入 | ✅ | 插入 [HH:mm] |
| 日历链接 | ✅ | 跳转日历页 |
| 搜索功能 | ✅ | 标题/内容搜索 |
| AI 润色 | ✅ | OpenAI API |
| 图片上传 | ✅ | 后端 static 目录存储 |
| AI 聊天 | ✅ | 侧边栏入口，聊天生成日记 |
| 筛选功能 | ⏳ | 按日期/分类筛选 |
