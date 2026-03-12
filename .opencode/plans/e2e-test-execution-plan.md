# E2E 测试修复验证计划

**创建时间**: 2026-03-11  
**任务 ID**: Task 9  
**状态**: ⏳ Pending (需要退出 Plan Mode)

---

## 📊 当前状态

### 已完成的工作 (Task 1-8)

所有 8 个测试文件的修复计划已制定完成：

| 文件 | 状态 | 测试数 | 主要修复内容 |
|------|------|--------|--------------|
| `page-objects.ts` | ✅ Plan 完成 | 6 类 | Page Object 选择器重构 |
| `auth.ts` | ✅ Plan 完成 | N/A | 认证辅助函数 |
| `timeline.spec.ts` | ✅ Plan 完成 | 19 | 时间线页面测试 |
| `write.spec.ts` | ✅ Plan 完成 | 24 | 写日记页面测试 |
| `settings.spec.ts` | ✅ Plan 完成 | 18 | 设置页面测试 |
| `calendar.spec.ts` | ✅ Plan 完成 | 13 | 日历页面测试 |
| `search.spec.ts` | ✅ Plan 完成 | 14 | 搜索页面测试 |
| `chat.spec.ts` | ✅ Plan 完成 | 4 | 聊天页面测试 |

**总计**: 94+ 个测试用例

---

## 🎯 验证目标

### 主要目标
1. **代码质量验证**
   - 移除所有 `data-testid` 依赖
   - ESLint 检查通过
   - 代码格式化符合规范

2. **功能验证**
   - E2E 测试通过率 ≥ 90%
   - 关键路径测试 100% 通过
   - 无严重 flaky 测试

3. **文档更新**
   - AGENTS.md 记录修复经验
   - README.md 更新测试说明

---

## 📋 执行步骤

### Phase 1: 代码修复执行

**前置条件**: 退出 Plan Mode

#### Wave 1 - 基础架构层 (并行执行)

**预计时间**: 30-45 分钟

```bash
# Task 1: 修复 page-objects.ts
# - 重写 TimelinePage, WritePage, SearchPage, CalendarPage, SettingsPage, ChatPage
# - 使用 getByRole, getByText, locator('[cursor=pointer]') 等
# 验收：grep "getByTestId" e2e/helpers/page-objects.ts 返回空

# Task 2: 修复 auth.ts
# - 替换 locator('text=...') 为 getByRole
# - 替换 locator('input[placeholder*=...]') 为 getByRole('textbox')
# 验收：grep "button:has-text" e2e/helpers/auth.ts 返回空

# Task 7: 修复 search.spec.ts
# - 全局替换 [data-testid="search-input"]
# - 全局替换 [data-testid="search-result-item"]
# 验收：grep "data-testid" e2e/search.spec.ts 返回空

# Task 8: 修复 chat.spec.ts
# - 替换所有 getByTestId('phosphor-react-native-...')
# 验收：grep "getByTestId" e2e/chat.spec.ts 返回空
```

**执行顺序**:
1. 并行执行 4 个文件的代码修改
2. 每个文件修改后立即运行 ESLint 验证
3. 所有文件完成后运行 `grep` 验证无 `data-testid` 残留

#### Wave 2 - 核心功能层 (Wave 1 完成后并行)

**预计时间**: 45-60 分钟

```bash
# Task 3: 修复 timeline.spec.ts (19 tests)
# - 刷新按钮、筛选按钮、FAB 按钮
# - 日记卡片选择器
# 验收：grep "data-testid" e2e/timeline.spec.ts 返回空

# Task 4: 修复 write.spec.ts (24 tests)
# - 分类选择器、天气选择器
# - 标签管理、删除确认
# 验收：grep "data-testid" e2e/write.spec.ts 返回空

# Task 6: 修复 calendar.spec.ts (13 tests)
# - 语言选择器、CSS 类选择器
# 验收：grep "data-testid" e2e/calendar.spec.ts 返回空
```

#### Wave 3 - 设置层

**预计时间**: 30-45 分钟

```bash
# Task 5: 修复 settings.spec.ts (18 tests)
# - 主题切换、主题色选择、语言切换
# - 账号管理测试
# 验收：grep "data-testid" e2e/settings.spec.ts 返回空
```

---

### Phase 2: 代码质量验证

**执行时间**: 5-10 分钟

#### Step 1: ESLint 检查

```bash
cd frontend
npx eslint e2e/ --fix
```

**验收标准**:
- 无 Error
- Warning < 5 个

#### Step 2: Prettier 格式化

```bash
cd frontend
npx prettier --write e2e/
```

**验收标准**:
- 所有文件格式化完成
- Git diff 仅显示有意义的更改

#### Step 3: 全局验证

```bash
# 验证无 data-testid 残留
cd frontend
grep -r "data-testid" e2e/ --include="*.ts"

# 预期结果：
# e2e/config/setup.ts  (配置文件，允许保留)
# (其他文件应返回空)
```

---

### Phase 3: 测试环境准备

**执行时间**: 10-15 分钟

#### Step 1: 检查测试环境配置

```bash
# 检查 .env.test 是否存在
ls -la backend/.env.test

# 如果不存在，复制模板
cd backend
cp .env.test.example .env.test
# 编辑 .env.test，填入真实的 API_KEY 和 GOOGLE_API_KEY
```

#### Step 2: 启动测试环境 Docker

```bash
cd backend
docker compose -f docker-compose.test.yml --env-file .env.test up -d

# 等待服务就绪
sleep 10

# 验证服务运行状态
docker compose -f docker-compose.test.yml ps
```

**预期输出**:
```
NAME                    STATUS    PORTS
backend-test            Up        8001/tcp
postgres-test           Up        5432/tcp
mem0-test               Up        8888/tcp
neo4j-test              Up        7687/tcp
```

#### Step 3: 验证后端服务

```bash
# 测试后端 API 是否可访问
curl http://127.0.0.1:8001/api/health

# 测试 mem0 服务
curl http://127.0.0.1:8888/memories?user_id=test
```

---

### Phase 4: 运行 E2E 测试

**执行时间**: 15-30 分钟

#### Step 1: 运行完整测试套件

```bash
cd frontend
npm run test:e2e
```

**预期输出**:
```
Running 94 tests using 4 workers

  ✓  e2e/chat.spec.ts (4 tests) 15s
  ✓  e2e/search.spec.ts (14 tests) 20s
  ✓  e2e/calendar.spec.ts (13 tests) 25s
  ✓  e2e/settings.spec.ts (18 tests) 40s
  ✓  e2e/timeline.spec.ts (19 tests) 45s
  ✓  e2e/write.spec.ts (24 tests) 50s

  94 passed (100%)
```

#### Step 2: 失败处理

如果有测试失败：

```bash
# 运行失败测试的调试模式
npm run test:e2e:debug -- failed-test-name

# 查看测试报告
npm run test:e2e -- --reporter=html
```

#### Step 3: 重试 flaky 测试

```bash
# 运行测试 3 次验证稳定性
for i in {1..3}; do
  echo "Run $i:"
  npm run test:e2e
done
```

---

### Phase 5: 结果验证和文档更新

**执行时间**: 10-15 分钟

#### Step 1: 验证测试结果

**验收标准**:
- [ ] 总测试数：94+ 个
- [ ] 通过率：≥ 90% (至少 85 个通过)
- [ ] 关键测试 100% 通过：
  - [ ] chat.spec.ts: 4/4 通过
  - [ ] auth 相关测试全部通过
  - [ ] timeline 核心功能测试通过

#### Step 2: 清理测试环境

```bash
cd backend
docker compose -f docker-compose.test.yml down -v --remove-orphans
```

#### Step 3: 更新 AGENTS.md

添加以下章节：

```markdown
## E2E 测试修复经验 (2026-03-11)

### 修复内容
- 从 `data-testid` 迁移到基于角色的选择器
- 支持多语言（中文/英文/日文）正则匹配
- 使用 `getByRole`, `getByText`, `locator('[cursor=pointer]')`

### 修复文件
- `e2e/helpers/page-objects.ts`: 6 个 Page Object 类
- `e2e/helpers/auth.ts`: 认证辅助函数
- `e2e/*.spec.ts`: 94 个测试用例

### 选择器最佳实践
1. 优先使用 `getByRole('button', { name: /.../ })`
2. 日记卡片使用 `locator('[cursor=pointer]')`
3. 多语言正则：`/保存 | Save|保存/i`
4. 避免硬编码 testID

### 测试结果
- 总测试：94 个
- 通过率：XX% (待填充)
- 执行时间：约 XX 分钟
```

#### Step 4: 更新 README.md

添加测试运行说明：

```markdown
## E2E 测试

### 运行测试

```bash
# 启动测试环境
cd backend
docker compose -f docker-compose.test.yml --env-file .env.test up -d

# 运行 E2E 测试
cd frontend
npm run test:e2e

# 清理测试环境
cd backend
docker compose -f docker-compose.test.yml down -v --remove-orphans
```

### 测试覆盖
- **chat.spec.ts**: 4 tests - AI 聊天功能
- **search.spec.ts**: 14 tests - 搜索功能
- **calendar.spec.ts**: 13 tests - 日历视图
- **settings.spec.ts**: 18 tests - 设置管理
- **timeline.spec.ts**: 19 tests - 时间线浏览
- **write.spec.ts**: 24 tests - 创建/编辑日记

**总计**: 94+ 个测试用例
```

---

## 📊 风险评估

### 高风险项

| 风险 | 概率 | 影响 | 缓解措施 |
|------|------|------|----------|
| API Key 配额不足 | 中 | 高 | 提前检查配额，准备备用 Key |
| Docker 服务启动失败 | 低 | 高 | 检查端口占用，查看日志 |
| 测试超时 | 中 | 中 | 增加 timeout，优化测试逻辑 |
| flaky 测试 | 中 | 中 | 重试机制，修复不稳定的测试 |

### 中等风险项

| 风险 | 概率 | 影响 | 缓解措施 |
|------|------|------|----------|
| ESLint 错误 | 高 | 低 | 使用 `--fix` 自动修复 |
| Prettier 格式化差异 | 高 | 低 | 统一运行 prettier |
| 选择器匹配失败 | 中 | 中 | 准备多种 fallback 选择器 |

---

## ✅ 验收清单

### 代码质量
- [ ] `grep -r "data-testid" frontend/e2e/ --include="*.ts"` 返回空（除配置文件外）
- [ ] `npx eslint frontend/e2e/` 无 Error
- [ ] `npx prettier --check frontend/e2e/` 通过

### 测试通过率
- [ ] 总测试数 ≥ 94 个
- [ ] 通过率 ≥ 90%
- [ ] chat.spec.ts: 4/4 通过
- [ ] timeline.spec.ts: ≥ 17/19 通过
- [ ] write.spec.ts: ≥ 22/24 通过
- [ ] settings.spec.ts: ≥ 16/18 通过
- [ ] calendar.spec.ts: ≥ 12/13 通过
- [ ] search.spec.ts: ≥ 13/14 通过

### 文档更新
- [ ] AGENTS.md 添加 E2E 修复经验章节
- [ ] README.md 添加测试运行说明
- [ ] .opencode/plans/e2e-selector-fix-plan.md 已创建并记录详细步骤

### 环境清理
- [ ] 测试环境 Docker 已停止
- [ ] 无残留容器
- [ ] Git 工作区清洁（仅保留修改的测试文件）

---

## 🚀 执行指令

**重要**: 当前处于 **Plan Mode**，需要用户确认退出 Plan Mode 后才能开始执行。

### 退出 Plan Mode 后的第一步

```bash
# 1. 确认测试环境
cd /home/playeriv65/AID-AIDiary
ls -la frontend/e2e/*.spec.ts

# 2. 开始 Wave 1 修复
# 按顺序执行 page-objects.ts, auth.ts, search.spec.ts, chat.spec.ts 的代码修改

# 3. 每个文件修改后立即验证
npx eslint e2e/helpers/page-objects.ts
grep "getByTestId" e2e/helpers/page-objects.ts  # 应返回空
```

### 预计总执行时间

| Phase | 内容 | 预计时间 |
|-------|------|----------|
| Phase 1 | 代码修复执行 (Wave 1-3) | 2-2.5 小时 |
| Phase 2 | 代码质量验证 | 10 分钟 |
| Phase 3 | 测试环境准备 | 15 分钟 |
| Phase 4 | 运行 E2E 测试 | 30 分钟 |
| Phase 5 | 结果验证和文档 | 15 分钟 |
| **总计** | | **约 3-3.5 小时** |

---

## 📞 需要用户确认

**由于当前处于 Plan Mode (只读) 状态**，我无法执行实际的代码修改和测试运行。

**请确认以下事项**:

1. **退出 Plan Mode**: 您是否确认退出 Plan Mode，开始执行代码修复？
2. **测试环境准备**: 测试环境的 `.env.test` 文件是否已配置真实 API Key？
3. **执行时间**: 您是否有约 3 小时的时间窗口用于执行和验证？
4. **提交策略**: 每个文件修复后独立提交，还是全部完成后一次性提交？

**请回复 "确认执行" 或提出您的调整意见！**

---

**文档创建完成**。等待用户确认退出 Plan Mode 后开始执行。
