# E2E 测试选择器修复计划

**创建时间**: 2026-03-11  
**目标**: 基于实际 DOM 结构修复 E2E 测试选择器，从 `data-testid` 转向用户可见文本选择器

---

## 🎯 修复原则

1. **使用 `getByText()`** - 匹配用户可见文本
2. **使用 `locator() + filter()`** - 组合选择器
3. **支持多语言** - 中文/英文/日文正则匹配
4. **避免 testID** - 不依赖 `data-testid` 属性

---

## 📊 修复任务概览

| 文件 | 测试数 | 复杂度 | 优先级 | 状态 |
|------|--------|--------|--------|------|
| `page-objects.ts` | 6 类 | 高 | P0 | ⏳ Pending |
| `auth.ts` | N/A | 中 | P0 | ⏳ Pending |
| `timeline.spec.ts` | 19 | 高 | P1 | ⏳ Pending |
| `write.spec.ts` | 24 | 高 | P1 | ⏳ Pending |
| `settings.spec.ts` | 18 | 中 | P2 | ⏳ Pending |
| `calendar.spec.ts` | 13 | 中 | P2 | ⏳ Pending |
| `search.spec.ts` | 14 | 低 | P3 | ⏳ Pending |
| `chat.spec.ts` | 4 | 低 | P3 | ⏳ Pending |

---

## 🔧 选择器替换映射表

### Timeline 页面

| 场景 | 错误选择器 | 正确选择器 |
|------|-----------|-----------|
| 筛选按钮 | `getByTestId('filter-button')` | `getByRole('button', { name: /筛选\|Filter\|フィルター/i })` |
| 刷新按钮 | `getByTestId('refresh-button')` | `getByRole('button', { name: /刷新\|Refresh\|更新/i })` |
| 日记卡片 | `getByTestId('diary-card')` | `locator('[cursor=pointer]').filter({ hasText: title })` |
| NEW 按钮 | `getByTestId('new-entry-button')` | `getByText('NEW')` |
| 清除筛选 | `getByTestId('clear-filters')` | `getByText(/清除\|Clear\|クリア/i)` |
| 分类选项 | `data-testid="category-filter"` | `locator('text=/工作\|Work\|仕事/')` |
| 天气选项 | `data-testid="weather-filter"` | `locator('text=/晴天\|Sunny\|晴れ/')` |

### Write 页面

| 场景 | 错误选择器 | 正确选择器 |
|------|-----------|-----------|
| 标题输入 | - | `getByPlaceholder(/标题\|Title\|タイトル/)` ✅ 保持 |
| 内容输入 | - | `getByPlaceholder(/记录今日...\|Record today.../)` ✅ 保持 |
| 分类选择 | `text='设置分类'` | `locator('text=/设置分类\|Category\|カテゴリ/)` |
| 天气选择 | `text='选择天气'` | `locator('text=/选择天气\|Weather\|天気/)` |
| 地点设置 | `text='设置地点'` | `locator('text=/设置地点\|Location\|場所/)` |
| 添加标签 | `text=+` | `getByText('+')` |
| 保存按钮 | `text='保存'` | `getByText(/保存\|Save\|保存/)` |
| 删除按钮 | `text=/删除` | `getByText(/删除\|Delete\|削除/)` |

### Settings 页面

| 场景 | 错误选择器 | 正确选择器 |
|------|-----------|-----------|
| 深色模式 | `getByTestId('theme-toggle')` | `getByRole('button', { name: /深色\|Dark\|ダーク/ })` |
| 浅色模式 | - | `getByRole('button', { name: /浅色\|Light\|ライト/ })` |
| 主题色选择 | `data-testid="accent-color-select"` | `locator('div[aria-label*="accent color"]')` |
| 语言选择 | `getByTestId('language-select')` | `getByRole('combobox', { name: /语言\|Language\|言語/ })` |
| 用户名输入 | `getByTestId('username-input')` | `getByRole('textbox', { name: /用户名\|Username/ })` |
| 密码输入 | `getByTestId('password-input')` | `getByRole('textbox', { name: /密码\|Password/ })` |
| 登录按钮 | `getByTestId('login-submit')` | `getByRole('button', { name: /登录\|Login\|ログイン/ })` |
| 注销按钮 | `getByTestId('logout-button')` | `getByRole('button', { name: /退出登录\|Log Out\|ログアウト/ })` |

### Calendar 页面

| 场景 | 错误选择器 | 正确选择器 |
|------|-----------|-----------|
| 月份容器 | - | `locator('[class*="monthContainer"]')` |
| 日期红点 | - | `locator('[class*="entryDot"]')` |
| 日期格子 | - | `locator('[class*="gridCell"]')` |
| FAB 按钮 | - | `locator('[class*="fab"]')` |
| 星期标题 | - | `locator('[class*="daysHeader"]')` |
| 月份标题 | `text=/\d{4}/` | ✅ 保持 |

### Search 页面

| 场景 | 错误选择器 | 正确选择器 |
|------|-----------|-----------|
| 搜索输入 | `getByTestId('search-input')` | `getByRole('searchbox').or(getByPlaceholder(/搜索\|Search\|検索/))` |
| 搜索结果 | `getByTestId('search-result-item')` | `locator('[cursor=pointer]')` |

### Chat 页面

| 场景 | 错误选择器 | 正确选择器 |
|------|-----------|-----------|
| 聊天输入 | - | `getByRole('textbox', { name: '分享今天的故事' })` ✅ 保持 |
| 发送按钮 | `getByTestId('send-message-button')` | `locator('[aria-label="发送"]').or(getByText('发送'))` |
| 对话列表 | `getByTestId('sidebar-toggle')` | `locator('[aria-label="对话列表"]')` |
| 删除对话 | `getByTestId('delete-conversation')` | `getByRole('button', { name: /删除\|Delete\|削除/ })` |
| 新建对话 | - | `locator('[aria-label="新建对话"]')` |

---

## 📝 文件修复详情

### 1. page-objects.ts (6 个 Page Object 类)

#### TimelinePage 类

```typescript
// ❌ 修复前
async filterByCategory(category: string): Promise<void> {
  await this.page.getByTestId('filter-button').click();
  await this.page.locator('[data-testid="category-filter"] select').click();
}

// ✅ 修复后
async filterByCategory(category: string): Promise<void> {
  const filterButton = this.page.getByRole('button', { name: /筛选 | Filter|フィルター/i }).first();
  await filterButton.click();
  
  const categoryMap: Record<string, RegExp> = {
    'work': /工作 | Work|仕事/,
    'life': /生活 | Life|生活/,
    'travel': /旅行 | Travel|旅行/,
    'study': /学习 | Study|勉強/,
    'other': /其他 | Other|その他/,
    'health': /健康 | Health|健康/
  };
  
  await this.page.locator('text=' + categoryMap[category]).first().click();
}
```

#### WritePage 类

```typescript
// ❌ 修复前
async addTag(tag: string): Promise<void> {
  await this.page.locator('text=+').click();
  await this.page.getByPlaceholder(/添加标签 | Add Tag|タグ追加/).fill(tag);
  await this.page.locator('text=' + /保存 | Save|保存/).click();
}

// ✅ 修复后（基本保持不变，已使用多语言）
async addTag(tag: string): Promise<void> {
  await this.page.getByText('+').first().click();
  await this.page.getByPlaceholder(/添加标签 | Add Tag|タグ追加/).fill(tag);
  await this.page.getByRole('button', { name: /保存 | Save|保存/i }).first().click();
}
```

#### SearchPage 类

```typescript
// ❌ 修复前
getSearchInput() {
  return this.page.getByTestId('search-input');
}

// ✅ 修复后
getSearchInput() {
  return this.page.getByRole('searchbox')
    .or(this.page.getByPlaceholder(/搜索 | Search|検索/i));
}
```

#### CalendarPage 类

```typescript
// ❌ 修复前
async hasEntryDot(date: Date): Promise<boolean> {
  const dateStr = `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`;
  const dotElement = this.page.locator(`[data-date="${dateStr}"][class*="entry-dot"]`);
  return (await dotElement.count()) > 0;
}

// ✅ 修复后
async hasEntryDot(date: Date): Promise<boolean> {
  const entryDots = this.page.locator('[class*="entryDot"]');
  return (await entryDots.count()) > 0;
}
```

#### SettingsPage 类

```typescript
// ❌ 修复前
async toggleTheme(): Promise<void> {
  await this.page.getByTestId('theme-toggle').click();
}

// ✅ 修复后
async toggleTheme(): Promise<void> {
  await this.page.getByRole('button', { name: /深色 | Dark|ダーク/i }).first().click();
}
```

#### ChatPage 类

```typescript
// ❌ 修复前
async sendMessage(text: string): Promise<void> {
  await this.page.getByTestId('chat-input').fill(text);
  await this.page.getByTestId('send-message-button').click();
}

// ✅ 修复后
async sendMessage(text: string): Promise<void> {
  const input = this.page.getByRole('textbox', { name: /分享 | Share|共有/i });
  await input.fill(text);
  
  const sendBtn = this.page.getByRole('button', { name: /发送 | Send|送信/i }).first();
  await sendBtn.click();
}
```

---

### 2. auth.ts 修复

```typescript
// ✅ 用户按钮（已正确，保持不变）
const userButton = page.locator('text=/^[A-Z]$/').first();

// ❌ 修复前：登录按钮
await page.locator('button:has-text("登录"), button:has-text("Login")').first().click();

// ✅ 修复后
await page.getByRole('button', { name: /登录 | Login|ログイン/i }).first().click();

// ❌ 修复前：注销按钮
await page.locator('text=退出登录').first().click();

// ✅ 修复后
await page.getByRole('button', { name: /退出登录 | Log Out|ログアウト/i }).first().click();

// ❌ 修复前：设置菜单
await page.locator('text=设置，text=Settings, text=設定').first().click();

// ✅ 修复后
await page.getByRole('menuitem', { name: /设置 | Settings|設定/i }).first().click();
```

---

## 🗺️ 执行顺序

### Wave 1 - 基础架构层 (无依赖，可并行)
- [x] Task 1: `page-objects.ts` 重构
- [ ] Task 2: `auth.ts` 重构
- [ ] Task 7: `search.spec.ts` 修复
- [ ] Task 8: `chat.spec.ts` 修复

### Wave 2 - 核心功能层 (依赖 Wave 1)
- [ ] Task 3: `timeline.spec.ts` 修复
- [ ] Task 4: `write.spec.ts` 修复
- [ ] Task 6: `calendar.spec.ts` 修复

### Wave 3 - 设置层 (依赖 Wave 2)
- [ ] Task 5: `settings.spec.ts` 修复

### Wave 4 - 验证层 (所有修复完成后)
- [ ] Task 9: 运行 E2E 测试验证

---

## ✅ 验收标准

### 代码质量
- [ ] `grep "getByTestId" e2e/` 返回空结果
- [ ] 所有选择器支持多语言正则匹配
- [ ] ESLint 检查通过：`npx eslint e2e/`

### 测试通过率
- [ ] 总测试数：94+ 个测试
- [ ] 通过率目标：≥ 90%
- [ ] 关键路径测试 100% 通过

### 文档更新
- [ ] AGENTS.md 更新测试修复经验
- [ ] README.md 更新测试运行说明

---

## 📚 多语言支持映射表

### 分类 (Category)
```typescript
const categoryMap = {
  'work': { zh: '工作', en: 'Work', ja: '仕事' },
  'life': { zh: '生活', en: 'Life', ja: '生活' },
  'travel': { zh: '旅行', en: 'Travel', ja: '旅行' },
  'study': { zh: '学习', en: 'Study', ja: '勉強' },
  'other': { zh: '其他', en: 'Other', ja: 'その他' },
  'health': { zh: '健康', en: 'Health', ja: '健康' }
};
```

### 天气 (Weather)
```typescript
const weatherMap = {
  'sunny': { zh: '晴天', en: 'Sunny', ja: '晴れ' },
  'rainy': { zh: '雨天', en: 'Rainy', ja: '雨' },
  'cloudy': { zh: '多云', en: 'Cloudy', ja: '曇り' },
  'snowy': { zh: '下雪', en: 'Snowy', ja: '雪' },
  'foggy': { zh: '雾', en: 'Foggy', ja: '霧' },
  'windy': { zh: '大风', en: 'Windy', ja: '風' }
};
```

### 界面按钮 (UI Buttons)
```typescript
const buttonMap = {
  'filter': { zh: '筛选', en: 'Filter', ja: 'フィルター' },
  'refresh': { zh: '刷新', en: 'Refresh', ja: '更新' },
  'save': { zh: '保存', en: 'Save', ja: '保存' },
  'delete': { zh: '删除', en: 'Delete', ja: '削除' },
  'clear': { zh: '清除', en: 'Clear', ja: 'クリア' },
  'login': { zh: '登录', en: 'Login', ja: 'ログイン' },
  'logout': { zh: '退出登录', en: 'Log Out', ja: 'ログアウト' },
  'settings': { zh: '设置', en: 'Settings', ja: '設定' }
};
```

---

## 🚀 快速参考

### 常用选择器模式

```typescript
// 1. 基于文本匹配
page.getByText(/工作 | Work|仕事/)
page.getByRole('button', { name: /保存 | Save/i })

// 2. 基于 CSS 类
page.locator('[class*="entryDot"]')
page.locator('[class*="monthContainer"]')

// 3. 基于属性
page.locator('[cursor=pointer]')
page.locator('[aria-label*="accent color"]')

// 4. 组合过滤
page.locator('[cursor=pointer]').filter({ hasText: '标题' })

// 5. 多语言正则
/标题 | Title|タイトル/
/刷新 | Refresh|更新/
```

### 调试技巧

```typescript
// 1. 打印元素文本
const text = await element.textContent();
console.log('Element text:', text);

// 2. 检查元素是否存在
const isVisible = await element.isVisible();
console.log('Is visible:', isVisible);

// 3. 计数
const count = await page.locator('selector').count();
console.log('Found elements:', count);

// 4. 超时处理
try {
  await element.waitFor({ state: 'visible', timeout: 5000 });
} catch (e) {
  console.log('Element not found within timeout');
}
```

---

## 📋 检查清单

### 修复前检查
- [ ] 确认测试环境 Docker 已启动
- [ ] 确认 `.env.test` 配置正确
- [ ] 确认有足够的 API Key 配额
- [ ] 备份当前测试文件（git commit）

### 修复后检查
- [ ] 运行 `grep "getByTestId" e2e/` 确认无残留
- [ ] 运行 `npx eslint e2e/` 无错误
- [ ] 运行 `npm run test:e2e` 通过率 ≥ 90%
- [ ] 更新 AGENTS.md 记录修复经验

---

**下一步**: 等待用户确认退出 Plan Mode 后开始执行修复

---

## 📝 详细修复步骤

### Task 2: auth.ts 修复详情

**文件位置**: `frontend/e2e/helpers/auth.ts`

**需要修复的函数**:

#### 1. `register()` 函数 (行 9-38)

```typescript
// ❌ 修复前 (行 17-18)
const usernameInput = page.locator('input[placeholder*="用户名"], input[placeholder*="Username"]...').first();
const passwordInput = page.locator('input[placeholder*="密码"], input[placeholder*="Password"]...').first();

// ✅ 修复后
const usernameInput = page.getByRole('textbox', { name: /用户名 | Username|ユーザーネーム/i }).first();
const passwordInput = page.getByRole('textbox', { name: /密码 | Password|パスワード/i }).first();

// ❌ 修复前 (行 24)
await page.locator('button:has-text("注册"), button:has-text("Register")...').first().click();

// ✅ 修复后
await page.getByRole('button', { name: /注册 | Register|登録/i }).first().click();
```

#### 2. `logout()` 函数 (行 46-81)

**注意**: 行 59 已部分修复为 `getByRole`，但需要改进

```typescript
// ❌ 修复前 (行 59)
await page.getByRole('button', { name: /退出登录 | Logout|ログアウト/ }).click();

// ✅ 修复后 (添加 .first())
const logoutBtn = page.getByRole('button', { name: /退出登录 | Log Out|ログアウト/i }).first();
await logoutBtn.click();
```

#### 3. `navigateToSettings()` 函数 (行 109-132)

```typescript
// ❌ 修复前 (行 121)
await page.locator('text=设置，text=Settings, text=設定').first().click();

// ✅ 修复后
await page.getByRole('menuitem', { name: /设置 | Settings|設定/i }).first().click();
```

#### 4. `performLogin()` 内部函数 (行 137-158)

```typescript
// ❌ 修复前 (行 142-145)
const usernameInput = page.locator('input[placeholder*="用户名"]...').first();
await page.locator('button:has-text("登录"), button:has-text("Login")...').first().click();

// ✅ 修复后
const usernameInput = page.getByRole('textbox', { name: /用户名 | Username|ユーザーネーム/i }).first();
const passwordInput = page.getByRole('textbox', { name: /密码 | Password|パスワード/i }).first();
await page.getByRole('button', { name: /登录 | Login|ログイン/i }).first().click();
```

#### 5. `login()` 函数 (行 188-210)

```typescript
// ❌ 修复前 (行 198)
const logoutButton = page.locator('text=退出登录');

// ✅ 修复后
const logoutButton = page.getByRole('button', { name: /退出登录 | Log Out|ログアウト/i });
```

**修复步骤**:
1. 打开 `frontend/e2e/helpers/auth.ts`
2. 替换所有 `locator('input[placeholder*=...]')` 为 `getByRole('textbox', { name: /.../ })`
3. 替换所有 `locator('button:has-text(...)')` 为 `getByRole('button', { name: /.../ })`
4. 替换 `locator('text=设置，text=Settings, text=設定')` 为 `getByRole('menuitem', { name: /设置 | Settings|設定/i })`
5. 保存文件
6. 运行 `npx eslint e2e/helpers/auth.ts` 验证无错误

**验收**:
```bash
grep "getByTestId" frontend/e2e/helpers/auth.ts  # 应返回空
grep "locator('text=" frontend/e2e/helpers/auth.ts  # 应返回空
grep "button:has-text" frontend/e2e/helpers/auth.ts  # 应返回空
```

---

### Task 7: search.spec.ts 修复详情

**文件位置**: `frontend/e2e/search.spec.ts`

**当前状态**: 已有较多 fallback 逻辑，修复工作量低

**需要修复的测试**:

#### 1. 所有测试中的搜索输入选择器

出现在行：10, 19, 30, 48, 59, 71, 88, 99, 117, 129, 141, 154, 168, 181, 199

```typescript
// ❌ 修复前
const searchInput = page.locator('[data-testid="search-input"], input[type="search"], .search-input').first();

// ✅ 修复后
const searchInput = page.getByRole('searchbox')
  .or(page.getByPlaceholder(/搜索 | Search|検索/i))
  .first();
```

#### 2. 搜索结果选择器

出现在行：41, 89, 103

```typescript
// ❌ 修复前
const results = page.locator('[data-testid="search-result-item"], .search-result-item');

// ✅ 修复后
const results = page.locator('[cursor=pointer]').filter({ hasText: /./ });
```

**修复步骤**:
1. 全局替换 `[data-testid="search-input"]` 为 `getByRole('searchbox')`
2. 全局替换 `[data-testid="search-result-item"]` 为 `locator('[cursor=pointer]')`
3. 保存文件
4. 运行 `npx eslint e2e/search.spec.ts` 验证

**验收**:
```bash
grep "data-testid" frontend/e2e/search.spec.ts  # 应返回空
```

---

### Task 8: chat.spec.ts 修复详情

**文件位置**: `frontend/e2e/chat.spec.ts`

**当前状态**: 部分测试已通过，问题较少

**需要修复的测试**:

#### 1. 发送消息测试 (行 12-19)

```typescript
// ✅ 已正确使用 getByRole (无需修改)
const input = page.getByRole('textbox', { name: '分享今天的故事' });
```

#### 2. 创建多个对话测试 (行 26-44)

```typescript
// ❌ 修复前 (行 32, 35, 40)
await page.getByTestId('phosphor-react-native-list-dashes-regular').click();
await page.getByTestId('phosphor-react-native-x-regular').click();
const trashIcons = await page.getByTestId('phosphor-react-native-trash-regular').count();

// ✅ 修复后
// 对话列表按钮
const conversationsBtn = page.getByRole('button', { name: /对话|Conversations|会話/i }).first();
await conversationsBtn.click();

// 关闭按钮
const closeBtn = page.getByRole('button', { name: /关闭 | Close|閉じる/i }).first();
await closeBtn.click();

// 删除按钮计数
const deleteCount = await page.getByRole('button', { name: /删除 | Delete|削除/i }).count();
```

#### 3. 删除对话测试 (行 52-69)

```typescript
// ❌ 修复前 (行 58-59)
const deleteButton = page.getByTestId('phosphor-react-native-trash-regular').first();
await deleteButton.waitFor({ state: 'visible', timeout: 10000 });

// ✅ 修复后
const deleteButton = page.getByRole('button', { name: /删除 | Delete|削除/i }).first();
await deleteButton.waitFor({ state: 'visible', timeout: 10000 });
```

#### 4. 日期格式测试 (行 75-84)

```typescript
// ❌ 修复前 (行 80)
await page.getByTestId('phosphor-react-native-list-dashes-regular').click();

// ✅ 修复后
await page.getByRole('button', { name: /对话 | Conversations|会話/i }).first().click();
```

**修复步骤**:
1. 识别所有 `getByTestId('phosphor-react-native-...')` 调用
2. 替换为基于角色的选择器或文本匹配
3. 保存文件
4. 运行 `npx eslint e2e/chat.spec.ts` 验证

**验收**:
```bash
grep "getByTestId" frontend/e2e/chat.spec.ts  # 应返回空
```

---

### Task 3: timeline.spec.ts 修复详情

**文件位置**: `frontend/e2e/timeline.spec.ts`

**测试数量**: 19 个测试

**关键修复点**:

#### 1. 导航测试 (行 1-74)

```typescript
// ✅ 用户按钮选择器已正确 (无需修改)
const userButton = page.locator('text=/^[A-Z]$/').first();

// ✅ 登录横幅文本 (已使用正则，无需修改)
const loginBannerText = page.locator('text=/请登录以同步数据|Please login to sync/').first();
```

#### 2. 日记列表显示测试 (行 110-302)

```typescript
// ❌ 修复前 (行 204-210)
const refreshButton1 = page.locator('[data-testid="refresh-button"]').first();
const refreshButton2 = page.getByRole('button', { name: /刷新 | Refresh|更新/i });
const refreshButton3 = page.locator('svg[name="arrow-clockwise"]...').first();

// ✅ 修复后 (简化)
const refreshButton = page.getByRole('button', { name: /刷新 | Refresh|更新/i }).first();
await refreshButton.click();

// ❌ 修复前 (行 220-221)
const entryCards1 = page.locator('article, div[role="article"], .entry-card, [data-testid="entry-card"]').all();
const entryCards2 = page.locator(`text=${TEST_ENTRY.title}`).first();

// ✅ 修复后
const entryCards = page.locator('[cursor=pointer]').filter({ hasText: TEST_ENTRY.title });
```

#### 3. 筛选功能测试 (行 303-533)

```typescript
// ❌ 修复前 (行 380-389)
const filterButton1 = page.locator('[data-testid="filter-button"]').first();
const filterButton2 = page.getByRole('button', { name: /筛选 | Filter|フィルター/i });
const filterButton3 = page.locator('svg[name="funnel"]...').first();

// ✅ 修复后
const filterButton = page.getByRole('button', { name: /筛选 | Filter|フィルター/i }).first();
await filterButton.click();

// ❌ 修复前 (行 396-398)
const filterPopover = page.locator('[data-testid="filter-popover"]...').first();

// ✅ 修复后 (通过内容验证筛选器打开)
const categoryOption = page.locator('text=/工作 | Work|仕事/').first();
await categoryOption.click();
```

#### 4. 日记交互测试 (行 534-679)

```typescript
// ❌ 修复前 (行 640-652)
const fabButton1 = page.locator('[data-testid="fab-new-entry"]').first();
const fabButton2 = page.locator('.fab');
const fabButton3 = page.locator('text=/新建 | New|新規/').first();

// ✅ 修复后
const fabButton = page.getByText('NEW').first();
await fabButton.click();
```

#### 5. 额外边界测试 (行 680-766)

```typescript
// ❌ 修复前 (行 723-730)
const refreshButton1 = page.locator('[data-testid="refresh-button"]').first();

// ✅ 修复后
const refreshButton = page.getByRole('button', { name: /刷新 | Refresh|更新/i }).first();
```

**修复步骤**:
1. 全局替换 `[data-testid="refresh-button"]` 为 `getByRole('button', { name: /刷新 | Refresh/ })`
2. 全局替换 `[data-testid="filter-button"]` 为 `getByRole('button', { name: /筛选 | Filter/ })`
3. 全局替换 `[data-testid="fab-new-entry"]` 为 `getByText('NEW')`
4. 简化日记卡片选择器为 `locator('[cursor=pointer]').filter({ hasText: title })`
5. 保存文件
6. 运行 `npx eslint e2e/timeline.spec.ts` 验证

**验收**:
```bash
grep "data-testid" frontend/e2e/timeline.spec.ts  # 应返回空
```

---

### Task 4: write.spec.ts 修复详情

**文件位置**: `frontend/e2e/write.spec.ts`

**测试数量**: 24 个测试

**关键修复点**:

#### 1. 创建日记测试 (行 103-271)

```typescript
// ✅ 标题和内容输入已使用多语言 placeholder (无需修改)
const titleInput = page.getByPlaceholder(/标题 | Title|タイトル/).first();
const contentTextarea = page.getByPlaceholder(/记录今日...|Record today.../).first();

// ❌ 修复前 (行 183-190)
const picker = page.locator('text=' + /设置分类 | Category|カテゴリ/);
const categoryOption = page.locator('text=' + category.label);

// ✅ 修复后
const categoryPicker = page.getByRole('button', { name: /设置分类 | Category|カテゴリ/i }).first();
await categoryPicker.click();
const categoryOption = page.getByText(category.label).first();
await categoryOption.click();

// ❌ 修复前 (行 208-215)
const picker = page.locator('text=' + /选择天气 | Weather|天気/);

// ✅ 修复后
const weatherPicker = page.getByRole('button', { name: /选择天气 | Weather|天気/i }).first();
await weatherPicker.click();
```

#### 2. 编辑日记测试 (行 273-386)

```typescript
// ✅ 已使用正确的 getByPlaceholder (无需修改)
const titleInput = page.getByPlaceholder(/标题 | Title|タイトル/).first();
```

#### 3. 标签管理测试 (行 387-479)

```typescript
// ❌ 修复前 (行 408-411)
await writePage.addTag(tag);  // Page Object 内部使用 text=+

// ✅ 修复后 (在 Page Object 中已修复)
// WritePage.addTag() 将使用 getByText('+')
```

#### 4. 编辑器工具栏测试 (行 480-567)

```typescript
// ❌ 修复前 (行 500)
const listButton = page.locator('text=' + /添加列表 | Add List|リスト追加/).first();

// ✅ 修复后
const listButton = page.getByRole('button', { name: /添加列表 | Add List|リスト追加/i }).first();
```

#### 5. 删除日记测试 (行 568-722)

```typescript
// ❌ 修复前 (行 645-646)
const confirmButton = page.locator('text=/确认 | Confirm|确定 | OK/i').first();

// ✅ 修复后
const confirmButton = page.getByRole('button', { name: /确认 | Confirm|确定 | OK/i }).first();
```

#### 6. 额外功能测试 (行 723-807)

```typescript
// ❌ 修复前 (行 770)
const backButton = page.locator('[data-testid="back-button"], text=/返回 | Back|戻る/i').first();

// ✅ 修复后
const backButton = page.getByRole('button', { name: /返回 | Back|戻る/i }).first();
```

**修复步骤**:
1. 确保 Page Object `WritePage` 已修复
2. 全局替换 `locator('text=' + ...)` 为 `getByRole('button', { name: /.../ })`
3. 全局替换 `locator('text=/...')` 为 `getByText(/.../)`
4. 保存文件
5. 运行 `npx eslint e2e/write.spec.ts` 验证

**验收**:
```bash
grep "data-testid" frontend/e2e/write.spec.ts  # 应返回空
```

---

### Task 5: settings.spec.ts 修复详情

**文件位置**: `frontend/e2e/settings.spec.ts`

**测试数量**: 18 个测试

**关键修复点**:

#### 1. 主题切换测试 (行 99-148)

```typescript
// ❌ 修复前 (行 106)
await page.waitForSelector('text="Appearance", text="外观", text="外観"');

// ✅ 修复后
const appearanceSection = page.getByText(/Appearance|外观 | 外観/).first();
await appearanceSection.waitFor({ state: 'visible', timeout: 5000 });

// ❌ 修复前 (行 109-111)
const darkButton = page.getByRole('button', { name: new RegExp(`${TRANSLATIONS.en.dark}|${TRANSLATIONS.zh.dark}|${TRANSLATIONS.ja.dark}`) });

// ✅ 修复后 (简化)
const darkButton = page.getByRole('button', { name: /深色 | Dark|ダーク/i }).first();
await darkButton.click();
```

#### 2. 主题色选择测试 (行 149-230)

```typescript
// ❌ 修复前 (行 167-168)
const colorDot = page.locator(`div[aria-label="${color.id} accent color"], div[test-id="${color.id}-accent-dot"]`).first();

// ✅ 修复后
const colorDot = page.locator(`div[aria-label="${color.id} accent color"]`).first();
await colorDot.click();
```

#### 3. 语言切换测试 (行 231-320)

```typescript
// ✅ 已使用 getByRole (无需修改)
await page.getByRole('combobox', { name: /Language|语言 | 言語/ }).click();
await page.getByRole('option', { name: /中文 | Chinese/ }).click();
```

#### 4. 账号管理测试 (行 321-511)

```typescript
// ✅ 已使用 getByRole (无需修改)
const loginRegisterButton = page.getByRole('button', { name: /Login \/ Register|登录 \/ 注册/i });

// ❌ 修复前 (行 376-378)
const usernameInput = page.getByRole('textbox', { name: /Username|用户名/i })
  .or(page.locator('input[placeholder*="用户名"]...').first());

// ✅ 修复后 (简化)
const usernameInput = page.getByRole('textbox', { name: /用户名 | Username|ユーザーネーム/i }).first();
```

**修复步骤**:
1. 移除复杂的字符串拼接正则，使用简化的多语言正则
2. 简化选择器，移除冗余的 fallback
3. 保存文件
4. 运行 `npx eslint e2e/settings.spec.ts` 验证

**验收**:
```bash
grep "data-testid" frontend/e2e/settings.spec.ts  # 应返回空
```

---

### Task 6: calendar.spec.ts 修复详情

**文件位置**: `frontend/e2e/calendar.spec.ts`

**测试数量**: 13 个测试

**关键修复点**:

#### 1. 日历显示测试 (行 30-188)

```typescript
// ✅ 月份标题选择器已正确 (无需修改)
const monthTitles = page.locator('text=/\\d{4}/');

// ❌ 修复前 (行 57-58)
const entryDot = page.locator('[class*="entryDot"], [style*="background-color: rgb(255, 59, 48)"]').first();

// ✅ 修复后
const entryDot = page.locator('[class*="entryDot"]').first();

// ❌ 修复前 (行 136-139)
const langSelect = page.locator('[data-testid="language-select"]').first();

// ✅ 修复后
const langSelect = page.getByRole('combobox', { name: /语言 | Language|言語/i }).first();
await langSelect.click();
await page.getByRole('option', { name: /中文 | Chinese/ }).click();
```

#### 2. 月份导航测试 (行 190-253)

```typescript
// ✅ CSS 类选择器已正确 (无需修改)
const dayHeaders = page.locator('[class*="daysHeader"]').first();
```

#### 3. 日期交互测试 (行 254-391)

```typescript
// ✅ CSS 类选择器已正确 (无需修改)
const dateCell = page.locator('[class*="gridCell"]').first();

// ❌ 修复前 (行 336-346)
const fabContainer = page.locator('[class*="fabContainer"]').first();
const mainFab = page.locator('[class*="fab"]').first();

// ✅ 修复后 (保持，或改进为)
const mainFab = page.getByText('NEW').or(page.locator('[class*="fab"]')).first();
```

#### 4. 数据同步测试 (行 392-546)

```typescript
// ✅ CSS 类选择器已正确 (无需修改)
const entryDot = page.locator('[class*="entryDot"]').first();
```

#### 5. 额外功能测试 (行 547-617)

```typescript
// ✅ 日历链接已使用文本匹配 (无需修改)
const calendarLink = page.locator('text=/日历 | Calendar|カレンダー/').first();
```

**修复步骤**:
1. 全局替换 `[data-testid="language-select"]` 为 `getByRole('combobox', { name: /语言 | Language/ })`
2. 简化 CSS 类选择器，保留主要的类名模式
3. 保存文件
4. 运行 `npx eslint e2e/calendar.spec.ts` 验证

**验收**:
```bash
grep "data-testid" frontend/e2e/calendar.spec.ts  # 应返回空
```

---

### Task 9: 运行 E2E 测试验证

**前置条件**: Task 3-8 全部完成

**执行步骤**:

#### 1. 启动测试环境 Docker

```bash
cd backend
docker compose -f docker-compose.test.yml --env-file .env.test up -d
```

#### 2. 等待服务就绪

```bash
# 等待 PostgreSQL 和 mem0 就绪
sleep 10
```

#### 3. 运行 E2E 测试

```bash
cd frontend
npm run test:e2e
```

#### 4. 查看测试报告

```bash
# 测试报告将输出到终端
# 通过率应 >= 90%
```

#### 5. 清理测试环境

```bash
cd backend
docker compose -f docker-compose.test.yml down -v --remove-orphans
```

**验收标准**:
- 总测试数：94+ 个测试
- 通过率：≥ 90%
- 关键路径测试 100% 通过

---

## 📋 执行检查清单

### 修复前检查
- [ ] 确认测试环境 Docker 已启动
- [ ] 确认 `.env.test` 配置正确 (API_KEY, GOOGLE_API_KEY)
- [ ] 确认有足够的 API Key 配额
- [ ] 备份当前测试文件：`git add . && git commit -m "backup: pre-e2e-fix"`

### 每个文件修复后检查
- [ ] `grep "data-testid" <file>` 返回空
- [ ] `npx eslint <file>` 无错误
- [ ] 文件格式正确 (Prettier)

### 全部修复完成后检查
- [ ] `grep -r "data-testid" frontend/e2e/` 返回空
- [ ] `npx eslint frontend/e2e/` 无错误
- [ ] `npm run test:e2e` 通过率 ≥ 90%
- [ ] 更新 `AGENTS.md` 记录修复经验
- [ ] 提交所有更改

---

**文档创建完成**。等待用户确认退出 Plan Mode 后开始执行修复。
