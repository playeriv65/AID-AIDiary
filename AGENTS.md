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
- Frontend: Expo (React Native Web) + Type
- Backend: FastAPI + SQLite + uv

## 运行命令
- **后端**: `cd backend && uv run uvicorn main:app --reload` (端口 8000)
- **前端**: `cd frontend && npx expo start --web --port 8081` (端口 8081)
- **前端测试**: `cd frontend && npm test`
- **测试数据**: `cd backend && uv run python seed_data.py`

## 目录结构(随时更新)
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

## 测试规范（测试项目随开发进度随时更新）
- 后端: `pytest` + FastAPI TestClient，使用 SQLite 内存数据库隔离
- 前端: `Jest` + `@testing-library/react-native`，使用 `jest-expo`
- **版本对齐**: jest-expo 必须与 expo SDK 主版本一致

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
- 必填: OPENAI_API_KEY, SECRET_KEY

## 经验教训
### ID 系统统一改造 (2026-02)
- **问题**: 数据库同时存在整数 `id` 和字符串 `uuid` 两个字段
- **解决**:
  1. `JournalEntry.id` 改为 UUID 字符串主键
  2. 前后端类型统一为 `id: string`
  3. 乐观更新使用 `crypto.randomUUID()`
  4. 删除所有 `.id.toString()` 和 `.uuid` 引用
- **验证**: pytest 通过 + Chrome DevTools 无报错

