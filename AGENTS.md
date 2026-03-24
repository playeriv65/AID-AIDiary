# AGENTS.md - AI Agent 开发指南

## 语言规范

- 保持使用中文回答

## 提交规范

- 提交之前必须向用户报告，未经允许绝对不能自己提交
- 提交前维护配置文件：.gitignore、README.md、AGENTS.md
- **经验教训**：遇到的问题和解决方案要及时更新到 AGENTS.md 和 README.md

### 提交前检查清单

以下内容必须同时通过：

- [ ] 代码格式化完成 (Prettier/Ruff)，代码规范检查通过 (ESLint/Ruff)
- [ ] 相关文档更新与整理 (AGENTS.md/README.md)
- [ ] 自动测试项目更新 (Jest/Pytest)，并测试全部通过
- [ ] 启动网页使用 Chrome DevTools 测试
- [ ] 使用 /code-review-expert 审查代码
- [ ] 提交信息清晰简洁 (英文，50 字以内)

## 运行规范

- 运行前杀掉无用进程：`pkill -f "pattern"` 或 `kill PID`
- 运行前检查端口占用，有旧进程直接杀掉
- 运行后检查是否成功运行
- **后台启动服务**: 使用 `nohup command &`

## 项目架构

- Frontend: Expo (React Native Web) + TypeScript
- Backend: FastAPI + PostgreSQL + uv
- AI Memory: mem0 (记忆存储服务)

## 环境配置

项目支持**生产环境**和**测试环境**两种模式。

### 后端环境

| 环境 | 配置文件 | Docker Compose | 后端端口 |
|------|---------|---------------|---------|
| 生产 | `backend/.env` | `docker-compose.yml` | 8000 |
| 测试 | `backend/.env.test` | `docker-compose.test.yml` | 8001 |

### 前端环境

前端通过 `frontend/.env` 配置环境：

```bash
# 生产环境
EXPO_PUBLIC_ENV=production

# 测试环境
EXPO_PUBLIC_ENV=test
```

| 环境 | EXPO_PUBLIC_ENV | API 地址 |
|------|-----------------|---------|
| 生产 | `production` | `127.0.0.1:8000` |
| 测试 | `test` | `127.0.0.1:8001` |

### 快速启动

**生产环境：**

```bash
# 1. 配置后端环境变量
cd backend && cp .env.example .env
# 编辑 .env，填入 SECRET_KEY 和 GOOGLE_API_KEY

# 2. 配置前端环境变量
cd frontend && cp .env.example .env
# 默认为 production

# 3. Docker 启动
cd backend && docker compose up -d

# 4. 启动前端
cd frontend && npx expo start --web --port 8081

# 5. 访问 http://localhost:8081
```

**测试环境（纯净模式）：**

```bash
# 1. 配置测试环境变量
cd backend && cp .env.test.example .env.test
cd frontend && echo "EXPO_PUBLIC_ENV=test" > .env

# 2. 启动测试后端（内存模式，纯净数据）
cd backend && docker compose -f docker-compose.test.yml up -d

# 5. 测试账号
# 用户名: testuser
# 密码: testpass123
```

**⚠️ 测试环境已自动注入数据**: 启动时 `docker-entrypoint.sh` 会自动为 testuser 创建 13 条测试日记。

**测试模式要求：**

| 组件 | 要求 | 目的 |
|------|------|------|
| 后端 | `docker-compose.test.yml` (tmpfs 内存存储) | 数据隔离，每次重启自动清理 |
| 前端 | 无痕/隐私模式浏览器 | 无缓存、无 localStorage 残留 |
| 数据 | 注入到 `testuser` 而非 `playeriv65` | 测试数据与生产数据分离 |

**⚠️ 重要：测试时必须使用无痕模式浏览器，否则 localStorage 中可能残留生产环境的登录状态。**

## 目录结构

```
frontend/
  app/(tabs)/          # 页面路由
    index.tsx          # 主页（时间线）
    chat.tsx           # AI 聊天
    write.tsx          # 写日记
    search.tsx         # 搜索
    settings.tsx       # 设置
    calendar.tsx       # 日历
  components/
    chat/              # 聊天组件 (ChatContainer, ChatInput, ChatMessage, MarkdownRenderer, ConversationSidebar...)
    journal/           # 日记组件 (ChatMessageList, EntryMetadata, TagManager, GenerateDiaryModal...)
    ui/                # UI 组件 (icon-symbol, collapsible)
    EntryCard.tsx, Sidebar.tsx, TopNav.tsx
  api/client.ts        # API 客户端
  context/AppContext.tsx
  constants/           # config.ts, theme.ts, i18n.ts
  hooks/               # use-journal-entry, use-image-upload, use-color-scheme...

backend/
  main.py              # FastAPI 入口
  auth.py, crud.py, models.py, schemas.py
  config.py, database.py, seed_data.py
  prompts.yaml         # AI 提示词配置（集中管理）
  prompts.py           # 提示词加载模块
  docker-entrypoint.sh # Docker 启动脚本（测试环境自动注入数据）
  mem0_client.py, ai_service.py
  routers/             # auth, entries, ai, health, upload, conversations
  services/            # auth_service, ai_client, memory_service, ai_chat_service, ai_diary_service
  tests/               # 单元测试 + 集成测试
```

## 代码规范

- TypeScript/TSX: 遵循 ESLint
- Python: 遵循 PEP 8
- **禁止未使用的 import**: 提交前必须运行 lint 检查
- **组件统一**: 使用 ThemedText 而非 Text
- **API 地址**: 使用 `constants/config.ts` 中的 CONFIG.API_URL
- **图片 URL**: 后端返回纯文件名，前端拼接 `CONFIG.STATIC_URL + '/' + image`
- **TDD 开发范式**: 测试先行，新功能/Bug 修复必须先写测试

## 代码格式化

```bash
# 前端
cd frontend && npx prettier --write . && npx eslint .

# 后端
cd backend && uv run ruff format . && uv run ruff check .
```

## 测试规范

### TDD 开发流程

所有功能开发遵循「红 → 绿 → 重构」循环：

1. **红**：先写失败的测试（定义预期行为）
2. **绿**：写最少代码让测试通过
3. **重构**：优化代码结构，保持测试通过

### 测试覆盖要求

| 范围 | 要求 |
|------|------|
| 后端 | 业务逻辑（services/）、API 端点（routers/）必须有单元测试 |
| 前端 | 组件（components/）、hooks、工具函数必须有测试 |
| Bug 修复 | 必须先写复现 Bug 的测试 |

### 运行测试

```bash
# 后端
cd backend && uv run pytest -v

# 前端
cd frontend && npm test

# E2E
cd frontend && npm run test:e2e

# 集成测试 (Docker 环境)
cd backend && ./run-integration-tests.sh
```

### 测试覆盖

| 位置 | 数量 | 内容 |
|------|------|------|
| 后端 | 36+ | AI 服务、API 端点、mem0 集成 |
| 前端 | 58 | 组件、hooks 测试 |
| E2E | 4 | 聊天核心功能 |

## 环境变量

复制 `backend/.env.example` 为 `backend/.env`：

| 变量 | 说明 | 默认值 |
|------|------|--------|
| DATABASE_URL | PostgreSQL 连接 | postgresql://postgres:postgres@localhost:5432/postgres |
| API_KEY | OpenAI 兼容 API 密钥 | - |
| BASE_URL | API 端点 | https://integrate.api.nvidia.com/v1 |
| MODEL_NAME | AI 模型名称 | moonshotai/kimi-k2-instruct-0905 |
| SECRET_KEY | JWT 签名密钥 | **必须设置** |
| MEM0_API_URL | mem0 服务地址 | http://localhost:8888 |
| GOOGLE_API_KEY | Google Gemini API Key | **必须设置** (用于 mem0) |

## mem0 服务

```bash
cd backend && docker compose up -d
docker compose ps                                    # 检查状态
curl http://localhost:8888/memories?user_id=test     # 测试 API
```

- mem0: 8888 | PostgreSQL: 5432 | Neo4j: 7687
- 无 GOOGLE_API_KEY 时 mem0 功能降级，不影响 AI 聊天
- 修改 .env 后需 `docker compose down && docker compose up -d` 重启

## 经验教训

### AI 提示词集中管理

- **位置**: `backend/prompts.yaml`
- **目的**: 所有 AI 系统提示词集中管理，便于维护和调整
- **使用**: 通过 `prompts.py` 模块加载，服务层调用 `prompts.get_xxx()` 方法
- **日记生成原则**: 只记录用户明确提到的内容，不添加、不猜测、不杜撰

### 固定 UUID 种子数据

- **目的**: 每次运行产生相同的测试数据
- **实现**: seed_data.py 中使用固定 UUID
- **环境区分**: 
  - 生产模式：数据注入 `playeriv65`
  - 测试模式（`TEST_MODE=true`）：数据注入 `testuser`

### lib/storage 离线优先架构

- 所有 CRUD 先写本地 IndexedDB，再异步同步后端
- Server-wins: 同步时后端数据覆盖本地
- Pending 状态: `sync_status='pending'` → `'synced'`
- 软删除: `deleted` 字段标记

### 工业级测试环境

- tmpfs 内存存储，测试速度提升 2-5 倍
- 独立 test_net 网络，与生产隔离
- 自动清理，无残留

```bash
cd backend
cp .env.test.example .env.test  # 填入真实 API Key
./run-integration-tests.sh
```

## 常见问题

- **数据库修改**: 修改 models.py 后 PostgreSQL 自动同步
- **图片上传**: Web 端需 fetch blob 后再传 FormData
- **CORS**: localhost 和 127.0.0.1 视为不同来源