# AID-AIDiary
A Brand New Form of Journaling.  
作为一个喜欢玩AI和写日记的人，能把它们结合起来作为人生中的第一个项目，是一件多么激动人心的事情！

## 功能特性 (Features)
- 📝 **日记时间线** — 极简深色风格，支持创建、浏览、编辑日记
- 📅 **日历视图** — 按月展示日期，有日记的天显示小红点
- 🔍 **搜索页面** — 快速检索历史日记，点击跳转编辑
- ⚙️ **设置页面** — 深/浅色切换、6色主题色、中/英/日三语选择
- 👤 **账号系统** — 账密注册/登录，JWT Token 鉴权（bcrypt 加密）
- 🎨 **主题联动** — 所有设置全局生效，持久化存储
- 🪶 **Phosphor Icons** — 全站使用 Phosphor 图标（Web + Native 兼容）
- 🏷️ **分类/天气/地点** — 日记支持分类、天气、地点标记
- ✅ **快捷工具** — 列表模板、任务模板、时间插入
- 🧠 **AI 记忆** — 集成 mem0，AI 聊天会记住你的重要信息

## 项目架构 (Architecture)
- **Frontend**: 基于 [Expo](https://expo.dev/) (React Native Web) 构建的跨平台极简日记界面。全局状态通过 `AppContext` 管理；`constants/i18n.ts` 统一管理三语翻译，`constants/config.ts` 管理 API 地址等配置。
- **Backend**: 基于 [FastAPI](https://fastapi.tiangolo.com/) 构建，PostgreSQL 存储日记数据，支持用户注册/登录（JWT）；使用 `uv` 管理 Python 依赖。
- **mem0**: 记忆服务，为 AI 聊天提供长期记忆存储和检索能力。

## 快速启动 (Getting Started)

### 1. 后端 (Backend)
```bash
cd backend
uv sync
uv run uvicorn main:app --reload
```
后端服务运行在 `http://localhost:8000`

### 2. 前端 (Frontend)
```bash
cd frontend
npm install
npm run web
```
在浏览器打开 `http://localhost:8081`

### 3. 测试数据 (可选)
```bash
cd backend
uv run python seed_data.py
```
生成 13 篇测试日记，默认用户 `playeriv65`，时间跨度 4 个月

### 4. 启动 mem0 服务（可选，用于 AI 记忆功能）
```bash
cd backend
docker-compose up -d
```
mem0 服务运行在 `http://localhost:8888`

## 环境变量
复制 `backend/.env.example` 为 `backend/.env` 并填入：
```
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/postgres  # Docker: postgresql://postgres:postgres@postgres:5432/postgres
API_KEY=sk-...
SECRET_KEY=your-jwt-secret
MEM0_API_URL=http://localhost:8888  # 可选，默认 localhost:8888
```

## 代码格式化 (Code Formatting)

### 前端 (Frontend)
```bash
cd frontend
npx prettier --write .   # 格式化
npx eslint .             # 检查
```

### 后端 (Backend)
```bash
cd backend
uv run ruff format .     # 格式化
uv run ruff check .      # 检查
```

## 测试规范

### 后端测试
- **运行测试**: `cd backend && uv run pytest -v`
- **测试文件**:
  - `tests/test_ai_service.py` - AI 服务测试（9 tests）
  - `tests/test_main.py` - API 端点测试（14 tests）
  - `tests/test_mem0_client.py` - mem0 记忆集成测试（13 tests）
- **测试覆盖**:
  - AI 对话功能（正常/异常/空响应）
  - 日记生成（含标签处理）
  - 流式对话
  - 记忆存储/检索/搜索
  - 记忆集成到 AI 服务
  - 向后兼容性（无 user_id 场景）
  - 降级处理（mem0 失败不影响聊天）

### 前端测试
- **运行测试**: `cd frontend && npm test`
- **技术栈**: Jest + @testing-library/react-native + jest-expo
- **版本对齐**: jest-expo 必须与 expo SDK 主版本一致

### 工业级测试环境 (Docker Integration Tests)

用于需要真实 PostgreSQL/mem0/Neo4j 的集成测试和 E2E 测试。

#### 快速启动

```bash
cd backend

# 1. 配置测试环境变量（复制模板并填入真实 API Key）
cp .env.test.example .env.test
nano .env.test  # 填入你的真实 API_KEY 和 GOOGLE_API_KEY

# 2. 运行集成测试（自动启动/清理 Docker 环境）
./run-integration-tests.sh
```

#### 测试环境特点

- **tmpfs 内存存储**: PostgreSQL 和 Neo4j 数据存储在内存中，测试速度提升 2-5 倍
- **完全隔离**: 使用独立的 `test_net` 网络，与生产环境隔离
- **自动清理**: 测试结束自动销毁容器和数据，无残留
- **健康检查**: 自动等待所有服务就绪后才开始测试

#### 文件说明

| 文件 | 用途 | 提交到 Git |
|------|------|-----------|
| `docker-compose.test.yml` | 测试专用 Docker 配置 | ✅ 可提交 |
| `.env.test.example` | 测试配置模板 | ✅ 可提交 |
| `.env.test` | 测试环境变量（含真实 API Key） | ❌ 不提交 |
| `run-integration-tests.sh` | 自动化测试脚本 | ✅ 可提交 |

#### 手动操作

```bash
# 启动测试环境
docker compose -f docker-compose.test.yml --env-file .env.test up -d --wait

# 运行测试
docker compose -f docker-compose.test.yml exec -T backend uv run pytest -v

# 清理环境
docker compose -f docker-compose.test.yml down -v --remove-orphans
```