# AGENTS.md - AI Agent 开发指南

## 语言规范

- 保持使用中文回答

## 提交规范

- 提交之前必须向用户报告，未经允许绝对不能自己提交 (本地提交也不行)。用户的习惯是让你写好 commit message(英文，简洁)，然后手动提交。
- 提交之前维护配置文件：.gitignore、README.md、AGENTS.md
- **经验教训**：遇到的问题和解决方案要及时更新到 AGENTS.md 和 README.md

### 提交前检查清单

请你创建 todo list，确保以下内容都完成了再提交
注意，以下内容必须同时通过，而不是只按照顺序做一遍

- [ ] 代码格式化完成 (Prettier/Ruff)，代码规范检查通过 (ESLint/Ruff)
- [ ] 相关文档更新与整理 (AGENTS.md/README.md)
- [ ] 自动测试项目更新 (Jest/Pytest)，并测试全部通过
- [ ] 启动网页使用 chrome devtools 测试，如果用户没有要求，禁止使用截屏工具
- [ ] 使用/code-review-expert 审查代码
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
    index.ts
  services/                # API 服务
    client.ts              # API 客户端
    index.ts

backend/
  main.py                  # FastAPI 入口（lifespan + include_router）
  auth.py                  # JWT 认证（re-export 层，向后兼容）
  crud.py                  # 数据库操作（含用户 CRUD）
  models.py                # SQLAlchemy 模型
  schemas.py               # Pydantic schemas
  ai_service.py            # AI 服务（re-export 层）
  mem0_client.py           # mem0 记忆客户端
  config.py                # 配置管理
  database.py              # 数据库连接
  seed_data.py             # 测试数据生成
  docker-compose.yml       # mem0 服务编排
  routers/                 # 路由层（按功能拆分）
    health.py              # 健康检查端点
    upload.py              # 图片上传端点
    auth.py                # 注册/登录端点
    entries.py             # 日记 CRUD 端点
    ai.py                  # AI 聊天/生成端点（含限流）
  services/                # 服务层（业务逻辑）
    auth_service.py        # JWT 认证、密码哈希
    ai_client.py           # OpenAI 客户端封装
    memory_service.py      # mem0 记忆存储/检索
    ai_chat_service.py     # AI 对话服务
    ai_diary_service.py    # AI 日记生成服务
  tests/                   # 自动测试
    test_ai_service.py     # AI 服务测试（9 tests）
    test_main.py           # API 端点测试（14 tests）
    test_mem0_client.py    # mem0 客户端测试（13 tests）
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
  - 格式化：`cd frontend && npx prettier --write .`
  - 检查：`cd frontend && npx eslint .`
- **后端**: Ruff
  - 格式化：`cd backend && uv run ruff format .`
  - 检查：`cd backend && uv run ruff check .`
- **提交前必须运行格式化**，确保代码风格统一

## 测试规范

- **后端**: `pytest` + FastAPI TestClient，使用 SQLite 内存数据库隔离
- **前端**: `Jest` + `@testing-library/react-native`，使用 `jest-expo`
- **E2E**: `Playwright` + Chromium，测试 AI 聊天核心功能
- **版本对齐**: jest-expo 必须与 expo SDK 主版本一致
- **测试覆盖**: 总计 94 个单元测试 + 4 个 E2E 测试
  - 后端：36 个测试 (tests/test_mem0_client.py: 13, tests/test_ai_service.py: 9, tests/test_main.py: 14)
  - 前端：58 个测试 (组件/钩子测试)
  - E2E：4 个测试 (首条消息发送、多对话创建、对话删除、日期显示)

## UI 规范

- 字体/颜色：使用 `constants/theme.ts`
- 图标：使用 Phosphor Icons (IconSymbol 组件)
- 弹窗选择：使用 Modal 组件

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
  - GOOGLE_API_KEY (Google Gemini API Key，用于 mem0 记忆提取)

## 经验教训

### mem0 服务部署

- **启动**: `cd backend && docker compose up -d`
- **服务状态**:
  - mem0: http://localhost:8888 (记忆存储服务)
  - Postgres: 5432 (向量数据库)
  - Neo4j: 7687 (知识图谱)
- **配置要求**:
  - `GOOGLE_API_KEY`: 有效的 Google Gemini API Key（必需，用于记忆提取）
  - 获取地址：https://aistudio.google.com/apikey
- **降级处理**: 无有效 API Key 时，mem0 功能不可用，但不影响 AI 聊天基本功能
- **验证命令**:
  ```bash
  docker compose ps  # 检查容器状态
  curl http://localhost:8888/memories?user_id=test  # 测试 mem0 API
  ```
- **注意**: 修改 .env 后需要 `docker compose down && docker compose up -d` 完全重启才能生效

### lib/storage 模块架构

- **离线优先**: 所有 CRUD 操作先写本地 IndexedDB，再异步同步到后端
- **Server-wins**: 同步时后端数据覆盖本地（简化冲突处理）
- **Pending 状态**: 本地修改标记为 `sync_status='pending'`，同步成功后标记为`'synced'`
- **软删除**: 使用 `deleted` 字段标记删除，前端过滤 `deleted !== 1` 的条目
- **文件结构**:
  ```
  frontend/lib/storage/
    types.ts              # 类型定义 (LocalJournalEntry, SyncResult, StorageAdapter)
    indexeddb-adapter.ts  # Dexie 实现 (initStorage, getStorageAdapter, syncWithBackend)
    index.ts              # 模块导出
  ```

### 项目启动注意事项

1. 配置环境变量：`cp backend/.env.example backend/.env` 并修改 `SECRET_KEY` 和 `GOOGLE_API_KEY`
2. **Docker Compose 启动（推荐）**：`cd backend && docker compose up -d`
   - 自动启动所有服务：Postgres、Neo4j、mem0、FastAPI 后端
   - 服务按依赖顺序启动，带健康检查
   - 后端服务会等待 mem0 就绪后才启动
3. 启动前端：`cd frontend && npx expo start --web --port 8081`
4. 访问 http://localhost:8081

### 开发环境启动（备选）

如果不使用 Docker：
```bash
cd backend
# 启动 mem0 及依赖服务
docker compose up -d postgres neo4j mem0
# 等待 mem0 就绪后启动后端
uv run uvicorn main:app --reload --port 8000
```

## 测试覆盖说明

### 后端测试（36 个测试）

- **tests/test_mem0_client.py** (13 个): 记忆存储/检索/搜索/降级处理测试
- **tests/test_ai_service.py** (9 个): AI 对话/日记生成/流式响应测试
- **tests/test_main.py** (14 个): API 端点/认证/CRUD/图片上传测试

### 前端测试（58 个测试）

- **hooks/useJournalEntry.test.ts** (12 个): 编辑/保存/模板功能测试
- **components/TagManager.test.tsx** (7 个): 标签增删改/重复检查
- **components/EntryMetadata.test.tsx** (5 个): 分类/天气/位置输入测试
- **components/EntryCard.test.tsx** (8 个): 显示/格式化/交互测试
- **components/ChatMessageList.test.tsx** (8 个): 消息渲染/Markdown/流式测试
- **components/ChatInput.test.tsx** (9 个): 输入/发送/附件/字符计数测试
- **components/ChatContainer.test.tsx** (9 个): 容器/主题/回调传递测试

### 测试运行

- 后端：`cd backend && uv run pytest -v`
- 前端：`cd frontend && npm test`
- 前端覆盖率：`cd frontend && npm run test:coverage`
- E2E 测试：`cd frontend && npm run test:e2e`
- E2E 测试 (UI 模式)：`cd frontend && npm run test:e2e:ui`
- Playwright 浏览器安装：`cd frontend && npm run playwright:install`
- frontend下面有一个.env文件，里面有测试用户名和密码

### E2E 测试说明

- **测试框架**: Playwright + Chromium
- **测试文件**: `frontend/e2e/chat.spec.ts`
- **辅助函数**: `frontend/e2e/helpers/auth.ts` (登录、导航等)
- **配置文件**: `frontend/playwright.config.ts`
- **测试场景**:
  1. 首次进入聊天界面发送第一条消息 (验证竞态修复)
  2. 创建多个对话
  3. 删除对话
  4. 对话历史日期显示
- **运行前提**: 后端服务 (8000) 和前端服务 (8081) 需要运行
