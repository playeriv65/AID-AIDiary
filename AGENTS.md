# AGENTS.md - AI Agent 开发指南

## 语言规范

- 保持使用中文回答

## 提交规范

- 提交之前必须向用户报告,未经允许绝对不能自己提交(本地提交也不行)。用户的习惯是让你写好commit message(英文，简洁)，然后手动提交。
- 提交之前维护配置文件：.gitignore、README.md、AGENTS.md
- **经验教训**：遇到的问题和解决方案要及时更新到 AGENTS.md 和 README.md

### 提交前检查清单

请你创建todo list，确保以下内容都完成了再提交
注意，以下内容必须同时通过，而不是只按照顺序做一遍

- [ ] 代码格式化完成 (Prettier/Ruff)，代码规范检查通过 (ESLint/Ruff)
- [ ] 相关文档更新与整理 (AGENTS.md/README.md)
- [ ] 自动测试项目更新 (Jest/Pytest)，并测试全部通过
- [ ] 启动网页使用chrome devtools测试，如果用户没有要求，禁止使用截屏工具
- [ ] 使用/code-review-expert审查代码
- [ ] 提交信息清晰简洁，符合规范 (英文，50 字以内)

## 运行规范

- 运行前杀掉无用进程：`pkill -f "pattern"` 或 `kill PID`
- 运行前检查端口占用，有旧进程直接杀掉
- 运行后检查是否成功运行，进行前后端自动测试
- **后台启动服务**: 使用 `nohup command &`

## 项目架构

- Frontend: Expo (React Native Web) + TypeScript
- Backend: FastAPI + SQLite + uv

## 运行命令

- **后端**: `cd backend && uv run uvicorn main:app --reload` (端口 8000)
- **前端**: `cd frontend && npx expo start --web --port 8081` (端口 8081)
- **前端测试**: `cd frontend && npm test`
- **测试数据**: `cd backend && uv run python seed_data.py`

## 目录结构

```
frontend/
  app/                        # 页面路由（expo-router）
    (tabs)/
      index.tsx            # 主页（时间线）
      chat.tsx             # AI 聊天页面
      write.tsx            # 写日记页面
      search.tsx           # 搜索页面
      settings.tsx         # 设置页面
      calendar.tsx         # 日历页面
      _layout.tsx           # 布局配置
    modal.tsx              # 模态页面
    _layout.tsx            # 根布局
  components/               # 可复用组件
    chat/                  # 聊天相关组件
      ChatContainer.tsx    # 聊天容器
      ChatInput.tsx        # 聊天输入
      ChatMessage.tsx      # 消息组件
      MarkdownRenderer.tsx # Markdown 渲染
      MessageActions.tsx   # 消息操作
      types.ts             # 类型定义
      index.ts
    journal/               # 日记相关组件
      ChatMessageList.tsx # 消息列表
      EntryMetadata.tsx    # 元数据组件
      TagManager.tsx       # 标签管理
      GenerateDiaryModal.tsx
      ChatHeader.tsx
      EditorToolbar.tsx
      MonthView.tsx
      ImageUploadPreview.tsx
      FilterPopover.tsx
    ui/                    # UI 组件
      icon-symbol.tsx       # 图标组件
      collapsible.tsx      # 折叠组件
    EntryCard.tsx          # 日记卡片
    Sidebar.tsx            # 侧边栏
    TopNav.tsx             # 顶部导航
    picker.tsx             # 选择器
    external-link.tsx      # 外部链接
    parallax-scroll-view.tsx
  context/                 # 全局状态
    AppContext.tsx
  constants/               # 常量配置
    config.ts              # API 配置
    theme.ts               # 主题
    i18n.ts                # 国际化
  hooks/                   # React Hooks
    use-journal-entry.ts   # 日记编辑
    use-image-upload.ts    # 图片上传
    use-color-scheme.ts    # 颜色方案
    use-theme-color.ts     # 主题颜色
  lib/storage/             # 存储适配器
    indexeddb-adapter.ts   # IndexedDB 适配
    types.ts
  services/                # API 服务
    client.ts              # API 客户端
    index.ts

backend/
  main.py                  # FastAPI 入口
  auth.py                  # JWT 认证
  crud.py                  # 数据库操作
  models.py                # SQLAlchemy 模型
  schemas.py               # Pydantic schemas
  ai_service.py            # OpenAI + mem0 集成
  mem0_client.py           # mem0 记忆客户端
  config.py                # 配置管理
  database.py              # 数据库连接
  seed_data.py             # 测试数据生成
  docker-compose.yml       # mem0 服务编排
  test_ai_service.py       # AI 服务测试
  test_main.py             # API 端点测试
  test_mem0_client.py      # mem0 客户端测试
```

## 代码规范

- TypeScript/TSX: 遵循 ESLint
- Python: 遵循 PEP 8
- **禁止未使用的 import**: 提交前必须运行 lint 检查
- **组件统一**: 使用 ThemedText 而非 Text
- **API 地址**: 使用 `constants/config.ts` 中的 CONFIG.API_URL
- **图片 URL**: 后端返回纯文件名，前端拼接 `CONFIG.STATIC_URL + '/' + image`

## 代码格式化

- **前端**: Prettier + ESLint
  - 格式化: `cd frontend && npx prettier --write .`
  - 检查: `cd frontend && npx eslint .`
- **后端**: Ruff
  - 格式化: `cd backend && uv run ruff format .`
  - 检查: `cd backend && uv run ruff check .`
- **提交前必须运行格式化**，确保代码风格统一

## 测试规范

- **后端**: `pytest` + FastAPI TestClient，使用 SQLite 内存数据库隔离
- **前端**: `Jest` + `@testing-library/react-native`，使用 `jest-expo`
- **版本对齐**: jest-expo 必须与 expo SDK 主版本一致
- **测试覆盖**: 总计 94 个测试
  - 后端: 36 个测试 (test_mem0_client.py: 13, test_ai_service.py: 9, test_main.py: 14)
  - 前端: 58 个测试 (组件/钩子测试)
## UI 规范

- 字体/颜色: 使用 `constants/theme.ts`
- 图标: 使用 Phosphor Icons (IconSymbol 组件)
- 弹窗选择: 使用 Modal 组件

## 常见问题

- **数据库修改**: 修改 models.py 后需删除 aidiary.db 重建
- **图片上传**: Web 端需 fetch blob 后再传 FormData
- **CORS**: 前端 localhost 和 127.0.0.1 视为不同来源

## 环境变量

- 复制 `backend/.env.example` 为 `backend/.env`
- 必填:
  - API_KEY (OpenAI 兼容 API 密钥，默认使用 NVIDIA)
  - BASE_URL (API 端点，默认 https://integrate.api.nvidia.com/v1)
  - MODEL_NAME (AI 模型名称，默认 moonshotai/kimi-k2-instruct-0905)
  - SECRET_KEY (JWT Token 签名密钥)
  - MEM0_API_URL (mem0 记忆服务地址，默认 http://localhost:8888)
- 可选:
  - GOOGLE_API_KEY (Google API 密钥，用于地图或搜索功能)

## 项目依赖

### 后端 Python 依赖

核心依赖：

- **httpx>=0.28.1**: HTTP 客户端，用于 mem0 API 调用
- **openai>=2.21.0**: OpenAI 兼容 API 客户端
- **fastapi>=0.129.2**: Web 框架
- **sqlalchemy>=2.0.46**: ORM 数据库操作
- **bcrypt>=5.0.0**: 密码加密
- **python-jose[cryptography]>=3.5.0**: JWT 处理
- **pydantic-settings>=2.9.1**: 配置管理
- **slowapi>=0.1.9**: API 限流

### 前端 npm 依赖

核心依赖：

- **expo (~54.0.33)**: React Native 框架
- **react (19.1.0)**: React 核心
- **react-native (0.81.5)**: React Native 核心
- **axios**: HTTP 客户端
- **date-fns**: 日期处理
- **dexie**: IndexedDB 数据库
- **@react-navigation/native**: 导航
- **phosphor-react-native**: 图标库
- **jest**: 测试框架

## 经验教训

### ID 系统统一改造 (2026-02)

- **问题**: 数据库同时存在整数 `id` 和字符串 `uuid` 两个字段
- **解决**:
  1. `JournalEntry.id` 改为 UUID 字符串主键
  2. 前后端类型统一为 `id: string`
  3. 乐观更新使用 `crypto.randomUUID()`
  4. 删除所有 `.id.toString()` 和 `.uuid` 引用
- **验证**: pytest 通过 + Chrome DevTools 无报错

### mem0 记忆框架集成 (2026-03)

- **功能**: 为 AI 聊天添加长期记忆存储和检索能力
- **实现**:
  1. 新增 `backend/mem0_client.py`: 封装 mem0 API 调用（存储/搜索/获取记忆）
  2. 修改 `ai_service.py`:
     - `_get_memory_context()`: 根据当前消息搜索相关记忆
     - `_store_conversation_to_memory()`: 存储对话到 mem0
     - `chat_with_ai()` 和 `stream_chat_with_ai()` 接受可选 `user_id` 参数
     - 记忆注入到系统提示词：`【以下是我们之前对话中的一些重要记忆，供你参考】`
  3. 修改 `main.py`: 从 JWT token 获取 user_id 并传递给 AI 服务
  4. 新增配置 `config.py` 中的 `mem0_api_url`（默认 http://localhost:8888）
  5. 新增 `docker-compose.yml`: mem0 + postgres + neo4j 服务编排
- **依赖**: 新增 `httpx>=0.28.1`, `openai>=2.21.0`
- **降级处理**: mem0 不可用时静默失败，不影响聊天功能
- **向后兼容**: API 接口无变化，前端无需修改
- **环境变量**: `.env` 需配置 `MEM0_API_URL`
- **验证**: pytest 36 tests passed + jest 58 tests passed = 94 tests passed + Ruff/Prettier 通过 + 功能测试验证记忆存储检索正常（包括 AI 回忆 pizzas 测试）

### outline 样式错误修复 (2026-03)

- **问题**: React Native Web 不支持 outline 简写属性，导致控制台警告
- **解决**:
  1. 移除 write.tsx 全局 CSS 中的 `outline: none !important`
  2. 移除 EntryMetadata.tsx 中的 `outline: 'none'`
  3. 移除 TagManager.tsx 中的 `outline: 'none'`
  4. React Native Web 已正确处理输入框焦点样式
- **验证**: Chrome DevTools 无 outline 相关警告

### 前端依赖版本更新 (2026-03)

- **变更**:
  - @expo/vector-icons: ^15.0.3
  - expo: ~54.0.33
  - react: 19.1.0
  - react-native: 0.81.5
- **版本对齐**: jest-expo (~54.0.17) 与 expo SDK 主版本一致

## 测试覆盖说明

### 后端测试（36个测试）

- **test_mem0_client.py** (13个): 记忆存储/检索/搜索/降级处理测试
- **test_ai_service.py** (9个): AI对话/日记生成/流式响应测试
- **test_main.py** (14个): API端点/认证/CRUD/图片上传测试

### 前端测试（58个测试）

- **hooks/useJournalEntry.test.ts** (12个): 编辑/保存/模板功能测试
- **components/TagManager.test.tsx** (7个): 标签增删改/重复检查
- **components/EntryMetadata.test.tsx** (5个): 分类/天气/位置输入测试
- **components/EntryCard.test.tsx** (8个): 显示/格式化/交互测试
- **components/ChatMessageList.test.tsx** (8个): 消息渲染/Markdown/流式测试
- **components/ChatInput.test.tsx** (9个): 输入/发送/附件/字符计数测试
- **components/ChatContainer.test.tsx** (9个): 容器/主题/回调传递测试
### 测试运行

- 后端: `cd backend && uv run pytest -v`
- 前端: `cd frontend && npm test`
- 前端覆盖率: `cd frontend && npm run test:coverage`
