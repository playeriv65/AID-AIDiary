import { Page } from '@playwright/test';

/**
 * Page Object Model for Timeline page
 */
export class TimelinePage {
  private page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  /**
   * Navigate to timeline page
   */
  async goto(): Promise<void> {
    await this.page.goto('/timeline');
  }

  /**
   * Filter entries by category
   */
  async filterByCategory(category: string): Promise<void> {
    // Click filter button
    await this.page.getByRole('button', { name: /筛选|Filter|フィルター/ }).click();

    // Select category from filter dropdown
    await this.page.getByRole('combobox', { name: /分类|Category|カテゴリ/ }).click();
    await this.page
      .locator(
        `role=option[name=/${
          category === 'work'
            ? '工作|Work|仕事'
            : category === 'life'
              ? '生活|Life|生活'
              : category === 'travel'
                ? '旅行|Travel|旅行'
                : category === 'study'
                  ? '学习|Study|勉強'
                  : category === 'other'
                    ? '其他|Other|その他'
                    : category === 'health'
                      ? '健康|Health|健康'
                      : ''
        }/i]`
      )
      .click();

    // Apply filter
    await this.page.getByRole('button', { name: /应用|Apply|適用/ }).click();
  }

  /**
   * Filter entries by weather
   */
  async filterByWeather(weather: string): Promise<void> {
    // Click filter button
    await this.page.getByRole('button', { name: /筛选|Filter|フィルター/ }).click();

    // Select weather from filter dropdown
    await this.page.getByRole('combobox', { name: /天气|Weather|天気/ }).click();
    await this.page
      .locator(
        `role=option[name=/${
          weather === 'sunny'
            ? '晴天|Sunny|晴れ'
            : weather === 'rainy'
              ? '雨天|Rainy|雨'
              : weather === 'cloudy'
                ? '多云|Cloudy|曇り'
                : weather === 'snowy'
                  ? '下雪|Snowy|雪'
                  : weather === 'foggy'
                    ? '雾|Foggy|霧'
                    : weather === 'windy'
                      ? '大风|Windy|風'
                      : ''
        }/i]`
      )
      .click();

    // Apply filter
    await this.page.getByRole('button', { name: /应用|Apply|適用/ }).click();
  }

  /**
   * Clear filter
   */
  async clearFilter(): Promise<void> {
    // Close filter popup
    await this.page.getByRole('button', { name: /清除|Clear|クリア/ }).click();
  }

  /**
   * Click on a diary entry card at specified index
   */
  async clickEntry(index: number): Promise<void> {
    const entries = this.page.locator('[cursor=pointer]');
    const entry = await entries.nth(index);
    await entry.click();
  }

  /**
   * Click refresh button to reload entries
   */
  async refresh(): Promise<void> {
    await this.page
      .getByRole('button')
      .filter({ has: this.page.locator('img[alt*="refresh" i]') })
      .click();
  }

  /**
   * Click to create new entry
   */
  async clickNewEntry(): Promise<void> {
    await this.page.getByText('NEW').click();
  }
}

/**
 * Page Object Model for Write Diary page
 */
export class WritePage {
  private page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  /**
   * Navigate to write page
   */
  async goto(): Promise<void> {
    await this.page.goto('/write');
  }

  /**
   * Fill title field
   */
  async fillTitle(title: string): Promise<void> {
    await this.page.getByPlaceholder(/标题|Title|タイトル/).fill(title);
  }

  /**
   * Fill content field
   */
  async fillContent(content: string): Promise<void> {
    await this.page.getByPlaceholder(/记录今日...|Record today...|今日を記録.../).fill(content);
  }

  /**
   * Select category from dropdown
   */
  async selectCategory(category: string): Promise<void> {
    await this.page.getByRole('combobox', { name: /设置分类|Category|カテゴリ/ }).click();

    const categoryMap: Record<string, RegExp> = {
      work: /工作|Work|仕事/,
      life: /生活|Life|生活/,
      travel: /旅行|Travel|旅行/,
      study: /学习|Study|勉強/,
      other: /其他|Other|その他/,
      health: /健康|Health|健康/,
    };

    const option = this.page.locator('role=option').filter({ hasText: categoryMap[category] });
    await option.waitFor({ state: 'visible', timeout: 3000 });
    await option.click();
  }

  /**
   * Select weather from dropdown
   */
  async selectWeather(weather: string): Promise<void> {
    await this.page.getByRole('combobox', { name: /选择天气|Weather|天気/ }).click();

    const weatherMap: Record<string, RegExp> = {
      sunny: /晴天|Sunny|晴れ/,
      rainy: /雨天|Rainy|雨/,
      cloudy: /多云|Cloudy|曇り/,
      snowy: /下雪|Snowy|雪/,
      foggy: /雾|Foggy|霧/,
      windy: /大风|Windy|風/,
    };

    const option = this.page.locator('role=option').filter({ hasText: weatherMap[weather] });
    await option.waitFor({ state: 'visible', timeout: 3000 });
    await option.click();
  }

  /**
   * Set location value
   */
  async setLocation(location: string): Promise<void> {
    await this.page.getByRole('combobox', { name: /设置地点|Location|場所/ }).click();
    await this.page.locator('input').first().fill(location);
  }

  /**
   * Add a tag
   */
  async addTag(tag: string): Promise<void> {
    await this.page.getByRole('button', { name: /Add tag|添加标签/ }).click();
    await this.page.getByRole('textbox', { name: /New tag input|添加标签/ }).fill(tag);
    await this.page.getByRole('button', { name: /保存|Save|保存/ }).click();
  }

  /**
   * Remove a tag
   */
  async removeTag(tag: string): Promise<void> {
    await this.page.getByRole('button', { name: `Remove tag ${tag}` }).click();
  }

  /**
   * Save diary entry
   */
  async save(): Promise<void> {
    await this.page.getByRole('button', { name: /保存|Save|保存/ }).click();
  }

  /**
   * Delete diary entry
   */
  async delete(): Promise<void> {
    await this.page.getByRole('button', { name: /删除|Delete|削除/ }).click();
  }
}

/**
 * Page Object Model for Search page
 */
export class SearchPage {
  private page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  /**
   * Navigate to search page
   */
  async goto(): Promise<void> {
    await this.page.goto('/search');
  }

  /**
   * Get search input element
   */
  getSearchInput() {
    return this.page.locator('input[placeholder*="搜索|Search|検索" i], input[type="search"]');
  }

  /**
   * Get search placeholder text element
   */
  getSearchPlaceholder() {
    return this.page
      .locator('.search-input, input[placeholder*="搜索|Search|検索" i], input[type="search"]')
      .first();
  }

  /**
   * Search for query text
   */
  async search(query: string): Promise<void> {
    await this.getSearchInput().fill(query);
  }

  /**
   * Get all search results
   */
  async getResults(): Promise<string[]> {
    const resultElements = this.page.locator('[cursor=pointer]');
    const resultCount = await resultElements.count();
    const results = [];

    for (let i = 0; i < resultCount; i++) {
      results.push(await resultElements.nth(i).textContent());
    }

    return results;
  }

  /**
   * Click on a search result at specified index
   */
  async clickResult(index: number): Promise<void> {
    const results = this.page.locator('[cursor=pointer]');
    const result = await results.nth(index);
    await result.click();
  }
}

/**
 * Page Object Model for Calendar page
 */
export class CalendarPage {
  private page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  /**
   * Navigate to calendar page
   */
  async goto(): Promise<void> {
    await this.page.goto('/calendar');
  }

  /**
   * Check if specified date has an entry (red dot)
   */
  async hasEntryDot(date: Date): Promise<boolean> {
    const dateStr = `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`;
    const dotElement = this.page.locator(`[data-date="${dateStr}"][class*="entry-dot"]`);
    const count = await dotElement.count();
    return count > 0;
  }

  /**
   * Click on a specific date
   */
  async clickDate(date: Date): Promise<void> {
    const dateStr = `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`;
    await this.page.locator(`[data-date="${dateStr}"]`).click();
  }
}

/**
 * Page Object Model for Settings page
 */
export class SettingsPage {
  private page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  /**
   * Navigate to settings page
   */
  async goto(): Promise<void> {
    await this.page.goto('/settings');
  }

  /**
   * Toggle between dark and light theme
   */
  async toggleTheme(): Promise<void> {
    await this.page.getByRole('switch', { name: /主题|Theme|テーマ/ }).click();
  }

  /**
   * Select accent color
   */
  async selectAccentColor(color: string): Promise<void> {
    await this.page
      .getByRole('combobox', { name: /主题颜色|Accent Color|アクセントカラー/ })
      .click();
    await this.page.locator(`role=option[name="${color}" i]`).click();
  }

  /**
   * Select language (zh/en/ja)
   */
  async selectLanguage(lang: string): Promise<void> {
    await this.page.getByRole('combobox', { name: /语言|Language|言語/ }).click();
    await this.page.locator(`role=option[name="${lang}" i]`).click();
  }

  /**
   * Login with username and password
   */
  async login(username: string, password: string): Promise<void> {
    await this.page.getByPlaceholder(/用户名|Username|ユーザー名/).fill(username);
    await this.page.getByPlaceholder(/密码|Password|パスワード/).fill(password);
    await this.page.getByRole('button', { name: /登录|Login|ログイン/ }).click();
  }

  /**
   * Logout from application
   */
  async logout(): Promise<void> {
    await this.page.getByRole('button', { name: /退出|Logout|ログアウト/ }).click();
  }
}

/**
 * Page Object Model for Chat page
 */
export class ChatPage {
  private page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  /**
   * Navigate to chat page
   */
  async goto(): Promise<void> {
    await this.page.goto('/chat');
  }

  /**
   * Send a message to the AI
   */
  async sendMessage(text: string): Promise<void> {
    await this.page.getByRole('textbox', { name: /Chat message input|消息|message/i }).fill(text);
    await this.page.getByRole('button', { name: /Send message|发送|Send|送信/ }).click();
  }

  /**
   * Get last AI message
   */
  async getLastMessage(): Promise<string> {
    const messageElements = this.page.locator(
      '[data-message-type="response"], [class*="message"] div'
    );
    const count = await messageElements.count();
    if (count === 0) return '';

    const lastMessage = await messageElements.last().textContent();
    return lastMessage || '';
  }

  /**
   * Open conversation sidebar
   */
  async openSidebar(): Promise<void> {
    await this.page.getByRole('button', { name: /侧边栏|Sidebar|サイドバー/ }).click();
  }

  /**
   * Switch to a conversation at specified index
   */
  async switchConversation(index: number): Promise<void> {
    const conversationElements = this.page.locator(
      '[data-conversation-id], [class*="conversation"]'
    );
    const conversation = await conversationElements.nth(index);
    await conversation.click();
  }

  /**
   * Delete conversation at specified index
   */
  async deleteConversation(index: number): Promise<void> {
    const conversationElements = this.page.locator(
      '[data-conversation-id], [class*="conversation"]'
    );
    const conversationElement = await conversationElements.nth(index);

    // Find and click the delete button inside the conversation item
    await conversationElement.getByRole('button', { name: /删除|Delete|削除/ }).click();
  }

  /**
   * Click generate diary button in chat
   */
  async generateDiary(): Promise<void> {
    await this.page.getByRole('button', { name: /生成日记|Generate Diary|日記生成/ }).click();
  }
}
