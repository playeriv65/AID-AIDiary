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
- **Backend**: 基于 [FastAPI](https://fastapi.tiangolo.com/) 构建，SQLite 存储日记数据，支持用户注册/登录（JWT）；使用 `uv` 管理 Python 依赖。
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
OPENAI_API_KEY=sk-...
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
  - `test_ai_service.py` - AI 服务测试（9 tests）
  - `test_main.py` - API 端点测试（14 tests）
  - `test_mem0_client.py` - mem0 记忆集成测试（13 tests）
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