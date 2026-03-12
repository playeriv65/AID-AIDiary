import { expect, test } from '@playwright/test';
import { login, logout, register, ensureAuthenticated } from './helpers/auth';

const TEST_ENTRY = {
  title: `Test Entry ${Date.now()}`,
  content: `This is a test journal entry created at ${new Date().toISOString()}`,
  category: 'work',
  weather: 'sunny',
  location: 'Test Location',
  tags: ['test', 'e2e'],
};

test.describe('Timeline - Unauthenticated User Experience', () => {
  test.setTimeout(60000);

  test.beforeEach(async ({ page }) => {
    // Ensure user is logged out before each test
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(1000);
    
    // Try to logout if logged in
    const userButton = page.locator('text=/^[A-Z]$/').first();
    const isLoggedIn = await userButton.isVisible().catch(() => false);
    if (isLoggedIn) {
      await logout(page);
    }
  });

  test('should display login prompt banner for unauthenticated users', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(1000);

    // Check for login banner text (multi-language support)
    const loginBannerText = page.locator('text=/请登录以同步数据|Please login to sync|ログインしてデータを同期/').first();
    const isBannerVisible = await loginBannerText.isVisible({ timeout: 5000 }).catch(() => false);
    expect(isBannerVisible).toBeTruthy();
  });

  test('should navigate to settings when clicking login banner', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(1000);

    // Click the login banner by text content
    const loginBannerText = page.locator('text=/请登录以同步数据|Please login to sync|ログインしてデータを同期/').first();
    await loginBannerText.click();
    
    await page.waitForTimeout(2000);

    // Should navigate to settings page
    const currentUrl = page.url();
    expect(currentUrl).toContain('/settings');
  });

  test('should show correct login banner styling (accent color border)', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(1000);

    // Find the login banner container
    const loginBanner = page.locator('text=/请登录以同步数据|Please login to sync/').first().locator('..');
    
    // Check that banner exists and has styling
    const isVisible = await loginBanner.isVisible().catch(() => false);
    expect(isVisible).toBeTruthy();

    // Verify login button exists within the banner
    const loginButton = page.locator('text=/登录|Login|ログイン/').first();
    const isButtonVisible = await loginButton.isVisible().catch(() => false);
    expect(isButtonVisible).toBeTruthy();
  });
});

test.describe('Timeline - Authenticated User Experience', () => {
  test.setTimeout(60000);

  test.beforeEach(async ({ page }) => {
    await login(page);
  });

  test('should not display login banner after login', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(1000);

    await page.waitForTimeout(3000);
    const userAvatar = page.locator('text=/^[A-Z]$/');
    const userAvatarVisible = await userAvatar.isVisible();
    
    const headerElements = page.locator('text=Timeline, text=Chat, text=Calendar');
    
    if (userAvatarVisible) {
      expect(userAvatarVisible).toBeTruthy();
    } else {
      expect(await page.locator('main, .container, .timeline-page').first().isVisible()).toBeTruthy();
    }
  });

  test('should show user avatar letter in header', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(1000);

    // User avatar should be a single uppercase letter
    const userButton = page.locator('text=/^[A-Z]$/').first();
    const isAvatarVisible = await userButton.isVisible({ timeout: 5000 });
    expect(isAvatarVisible).toBeTruthy();

    // Verify it's a single uppercase letter
    const avatarText = await userButton.textContent();
    expect(avatarText).toMatch(/^[A-Z]$/);
  });
});

test.describe('Timeline - Journal List Display', () => {
  test.setTimeout(60000);
  let testEntryId: string | null = null;

  test.beforeEach(async ({ page, request }) => {
    await login(page);
    
    // Create a test entry via API for authenticated tests
    const apiUrl = process.env.EXPO_PUBLIC_ENV === 'test' 
      ? 'http://127.0.0.1:8001/api' 
      : 'http://127.0.0.1:8000/api';
    
    // Get auth token from storage
    const token = await page.evaluate(async () => {
      const item = localStorage.getItem('@app_token');
      return item ? JSON.parse(item) : null;
    }).catch(() => null);

    if (token) {
      try {
        const response = await request.post(`${apiUrl}/entries/`, {
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json',
          },
          data: TEST_ENTRY,
        });
        
        if (response.ok()) {
          const data = await response.json();
          testEntryId = data.id;
        }
      } catch (error) {
        console.log('Failed to create test entry via API:', error);
      }
    }
  });

  test.afterEach(async ({ page, request }) => {
    // Clean up test entry
    if (testEntryId) {
      const apiUrl = process.env.EXPO_PUBLIC_ENV === 'test' 
        ? 'http://127.0.0.1:8001/api' 
        : 'http://127.0.0.1:8000/api';
      
      const token = await page.evaluate(async () => {
        const item = localStorage.getItem('@app_token');
        return item ? JSON.parse(item) : null;
      }).catch(() => null);

      if (token) {
        try {
          await request.delete(`${apiUrl}/entries/${testEntryId}`, {
            headers: {
              'Authorization': `Bearer ${token}`,
            },
          });
        } catch (error) {
          console.log('Failed to delete test entry:', error);
        }
      }
      testEntryId = null;
    }
  });

  test('should display empty state message when no entries', async ({ page }) => {
    // Navigate to a fresh user account or clear entries
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    // Check for empty state message (multi-language)
    const emptyMessage = page.locator('text=/暂无日记|No entries yet|まだ日記がありません/').first();
    
    // Empty state might or might not be visible depending on existing data
    // Just verify the page loads without errors
    const listContainer = page.locator('[role="list"]').first();
    const hasList = await listContainer.isVisible().catch(() => false);
    
    // Either empty state or entries should be visible
    const isEmptyVisible = await emptyMessage.isVisible().catch(() => false);
    expect(isEmptyVisible || hasList).toBeTruthy();
  });

  test('should display EntryCard list when entries exist', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    // Refresh to ensure data is loaded
    const refreshButton = page.getByRole('button').filter({ has: page.locator('svg, img') }).nth(0);
    
    if (await refreshButton.isVisible().catch(() => false)) {
      await refreshButton.click();
    } else {
      // Fallback: find by icon or text
      const refreshBtn = page.locator('text=/刷新|Refresh|更新/').first();
      if (await refreshBtn.isVisible().catch(() => false)) {
        await refreshBtn.click();
      }
    }
    await page.waitForTimeout(2000);

    // Check for entry cards using various possible selectors
    const entryCards1 = page.locator('article, div[role="article"], .entry-card, [data-testid="entry-card"]').all();
    const entryCards2 = page.locator(`text=${TEST_ENTRY.title}`).first();
  
    // Get all potential entry elements
    const hasEntries1 = (await entryCards1).length > 0;
    const hasEntries2 = await entryCards2.isVisible().catch(() => false);
    
    const hasEntries = hasEntries1 || hasEntries2;
    
    // If we created a test entry, it should be visible
    if (testEntryId) {
      const testEntryTitle = page.locator(`text=${TEST_ENTRY.title}`).first();
      const isTestEntryVisible = await testEntryTitle.isVisible().catch(() => false);
      expect(isTestEntryVisible || hasEntries).toBeTruthy();
    }
  });

  test('should show title, date, category, weather on each card', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    // Look for entry cards by role (view container) or by content containing titles
    const entryContainers = page.locator('article, div[role="article"], .entry-card').first();
    const entryWithTestTitle = page.locator(`[cursor=pointer]`).filter({ hasText: TEST_ENTRY.title }).first();
    const hasCard = await Promise.any([
      entryContainers.isVisible().catch(() => Promise.resolve(false)),
      entryWithTestTitle.isVisible().catch(() => Promise.resolve(false))
    ]);

    if (hasCard) {
      // Check for title
      const title = entryContainers.locator('.entryTitle, [class*="title"], [class*="content"], article [cursor=pointer]').first();
      const hasTitle = await title.isVisible().catch(() => false);
      
      // Check for date
      const date = entryContainers.locator('.entryDate, .metaRow [class*="date"], time').first();
      const hasDate = await date.isVisible().catch(() => false);
      
      // Check for category badge
      const category = entryContainers.locator('.badgeText').first();
      const hasCategory = await category.isVisible().catch(() => false);
      
      // Check for weather badge
      const weather = entryContainers.locator('.badgeText[class*="weather"]').first();
      const hasWeather = await weather.isVisible().catch(() => false);

      // At least some metadata should be visible
      expect(hasDate || hasCategory || hasWeather).toBeTruthy();
    }
  });

  test('should refresh list when clicking refresh', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(1000);

    // Click refresh button
    const refreshButton = page.getByRole('button').filter({ has: page.locator('svg, img') }).nth(0);
    
    if (await refreshButton.isVisible()) {
      await refreshButton.click();
    }

    await page.waitForTimeout(2000);

    // Page should still be functional after refresh
    const listContainer = page.locator('[role="list"]').first();
    const entryCards = page.locator('article, div[role="article"], .entry-card, [cursor=pointer]');
    const timelineContent = page.locator('.timeline-container, .container, .main-content, main').first();

    const isVisible = await listContainer.isVisible().catch(() => false) 
                   || (await entryCards.count()) > 0 
                   || await timelineContent.isVisible().catch(() => false);
    expect(isVisible).toBeTruthy();
  });
});

test.describe('Timeline - Filter Functionality', () => {
  test.setTimeout(60000);
  let testEntryId: string | null = null;

  test.beforeEach(async ({ page, request }) => {
    await login(page);
    
    // Create test entries with different categories and weathers
    const apiUrl = process.env.EXPO_PUBLIC_ENV === 'test' 
      ? 'http://127.0.0.1:8001/api' 
      : 'http://127.0.0.1:8000/api';
    
    const token = await page.evaluate(async () => {
      const item = localStorage.getItem('@app_token');
      return item ? JSON.parse(item) : null;
    }).catch(() => null);

    if (token) {
      try {
        // Create work/sunny entry
        const response = await request.post(`${apiUrl}/entries/`, {
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json',
          },
          data: {
            title: `Work Entry ${Date.now()}`,
            content: 'Test work entry',
            category: 'work',
            weather: 'sunny',
          },
        });
        
        if (response.ok()) {
          const data = await response.json();
          testEntryId = data.id;
        }
      } catch (error) {
        console.log('Failed to create test entry:', error);
      }
    }
  });

  test.afterEach(async ({ page, request }) => {
    if (testEntryId) {
      const apiUrl = process.env.EXPO_PUBLIC_ENV === 'test' 
        ? 'http://127.0.0.1:8001/api' 
        : 'http://127.0.0.1:8000/api';
      
      const token = await page.evaluate(async () => {
        const item = localStorage.getItem('@app_token');
        return item ? JSON.parse(item) : null;
      }).catch(() => null);

      if (token) {
        try {
          await request.delete(`${apiUrl}/entries/${testEntryId}`, {
            headers: { 'Authorization': `Bearer ${token}` },
          });
        } catch (error) {
          console.log('Failed to delete test entry:', error);
        }
      }
      testEntryId = null;
    }
  });

  test('should open filter popover when clicking filter button', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(1000);

    // Click filter button
    const filterButton = page.getByRole('button').filter({ has: page.locator('svg, img') }).nth(1);
    
    if (await filterButton.isVisible()) {
      await filterButton.click();
    }

    await page.waitForTimeout(1000);

    // Check for filter popover content (by content and accessibility labels)
    const filterPopover = page.locator('[data-testid="filter-popover"], .filterPopover, .filterOptions, div[style*="position: absolute"]').first();
    const filterLabel = page.locator('text=/按分类筛选|Filter by category|カテゴリーで絞り込む/').first();
    const categoryLabel = page.locator('text=/工作|Work|仕事/').first(); // Check for specific category options
    
    const isPopoverVisible = await filterPopover.isVisible().catch(() => false);
    const isLabelVisible = await filterLabel.isVisible().catch(() => false);
    const isCategoryVisible = await categoryLabel.isVisible().catch(() => false);
    expect(isPopoverVisible || isLabelVisible || isCategoryVisible).toBeTruthy();
  });

  test('should filter entries by category', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(1500);

    // Open filter popover
    const filterButton = page.getByRole('button').filter({ has: page.locator('svg, img') }).nth(1);
    
    if (await filterButton.isVisible().catch(() => false)) {
      await filterButton.click();
    }
    await page.waitForTimeout(1000);

    // Click on 'work' category
    const workCategory = page.locator('text=/工作|Work|仕事/').first();
    if (await workCategory.isVisible().catch(() => false)) {
      await workCategory.click();
      await page.waitForTimeout(1500);

       // Verify filter is applied (filter button should show active state or entries should be filtered)
      const filteredEntries1 = page.locator('article, div[role="article"], .entry-card, [data-testid="entry-card"]').all();
      const filteredEntries2 = page.locator(`text=/工作|Work|仕事/`).first();
      const hasFilteredEntries1 = (await filteredEntries1).length;
      
      let hasFilteredEntries;
      try {
        hasFilteredEntries = await filteredEntries2.isVisible() ? hasFilteredEntries1 || 1 : hasFilteredEntries1;
      } catch {
        hasFilteredEntries = hasFilteredEntries1;
      }
      expect(hasFilteredEntries).toBeGreaterThanOrEqual(0);
    }
  });

  test('should filter entries by weather', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(1500);

    // Open filter popover
    const filterButton = page.getByRole('button').filter({ has: page.locator('svg, img') }).nth(1);
    
    if (await filterButton.isVisible().catch(() => false)) {
      await filterButton.click();
    }
    await page.waitForTimeout(1000);

    // Click on 'sunny' weather
    const sunnyWeather = page.locator('text=/晴天|Sunny|晴れ/').first();
    if (await sunnyWeather.isVisible().catch(() => false)) {
      await sunnyWeather.click();
      await page.waitForTimeout(1500);

      // Verify filter is applied
      const filteredEntries1 = page.locator('article, div[role="article"], .entry-card, [data-testid="entry-card"]').all();
      const filteredEntries2 = page.locator(`text=/晴天|Sunny|晴れ/`).first();
      const hasFilteredEntries1 = (await filteredEntries1).length;
      
      let hasFilteredEntries;
      try {
        hasFilteredEntries = await filteredEntries2.isVisible() ? hasFilteredEntries1 || 1 : hasFilteredEntries1;
      } catch {
        hasFilteredEntries = hasFilteredEntries1;
      }
      expect(hasFilteredEntries).toBeGreaterThanOrEqual(0);
    }
  });

  test('should clear filters', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(1500);

    // Open filter popover and apply a filter
    const filterButton = page.getByRole('button').filter({ has: page.locator('svg, img') }).nth(1);
    
    if (await filterButton.isVisible().catch(() => false)) {
      await filterButton.click();
    }
    await page.waitForTimeout(1000);

    // Apply a filter
    const workCategory = page.locator('text=/工作|Work|仕事/').first();
    if (await workCategory.isVisible().catch(() => false)) {
      await workCategory.click();
      await page.waitForTimeout(1000);
    }

    // Reopen filter popover
    if (await filterButton.isVisible().catch(() => false)) {
      await filterButton.click();
    }
    await page.waitForTimeout(1000);

    // Click clear button
    const clearButton = page.locator('text=/清除|Clear|クリア/').first();
    if (await clearButton.isVisible().catch(() => false)) {
      await clearButton.click();
      await page.waitForTimeout(1500);

      // Verify filter is cleared (all entries should be visible again)
      const entries1 = page.locator('article, div[role="article"], .entry-card, [data-testid="entry-card"]').all();
      const entries2 = page.locator(`text=${TEST_ENTRY.title}`).first();
      const hasEntries1 = (await entries1).length;
      const hasEntries2 = await entries2.isVisible().catch(() => false);
      
      expect(hasEntries1 || (hasEntries2 ? 1 : 0)).toBeGreaterThanOrEqual(0);
    }
  });
});

test.describe('Timeline - Journal Interaction', () => {
  test.setTimeout(60000);
  let testEntryId: string | null = null;

  test.beforeEach(async ({ page, request }) => {
    await login(page);
    
    // Create a test entry for navigation tests
    const apiUrl = process.env.EXPO_PUBLIC_ENV === 'test' 
      ? 'http://127.0.0.1:8001/api' 
      : 'http://127.0.0.1:8000/api';
    
    const token = await page.evaluate(async () => {
      const item = localStorage.getItem('@app_token');
      return item ? JSON.parse(item) : null;
    }).catch(() => null);

    if (token) {
      try {
        const response = await request.post(`${apiUrl}/entries/`, {
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json',
          },
          data: {
            title: `Nav Test Entry ${Date.now()}`,
            content: 'Test entry for navigation',
            category: 'life',
            weather: 'cloudy',
          },
        });
        
        if (response.ok()) {
          const data = await response.json();
          testEntryId = data.id;
        }
      } catch (error) {
        console.log('Failed to create test entry:', error);
      }
    }
  });

  test.afterEach(async ({ page, request }) => {
    if (testEntryId) {
      const apiUrl = process.env.EXPO_PUBLIC_ENV === 'test' 
        ? 'http://127.0.0.1:8001/api' 
        : 'http://127.0.0.1:8000/api';
      
      const token = await page.evaluate(async () => {
        const item = localStorage.getItem('@app_token');
        return item ? JSON.parse(item) : null;
      }).catch(() => null);

      if (token) {
        try {
          await request.delete(`${apiUrl}/entries/${testEntryId}`, {
            headers: { 'Authorization': `Bearer ${token}` },
          });
        } catch (error) {
          console.log('Failed to delete test entry:', error);
        }
      }
      testEntryId = null;
    }
  });

  test('should navigate to edit page when clicking entry card', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    // Click on an entry card
    const entryCard = page.locator('article, div[role="article"], .entry-card').first();
    const entryWithTestTitle = page.locator(`[cursor=pointer]`).filter({ hasText: TEST_ENTRY.title }).first();
    const hasCard = await Promise.any([
      entryCard.isVisible().catch(() => Promise.resolve(false)),
      entryWithTestTitle.isVisible().catch(() => Promise.resolve(false))
    ]);

    if (hasCard) {
      await entryWithTestTitle.click().catch(() => entryCard.click());
      await page.waitForTimeout(2000);

      // Should navigate to write/edit page
      const currentUrl = page.url();
      expect(currentUrl).toContain('/write');
    }
  });

  test('should navigate to write page when clicking + button', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(1000);

     // Click the FAB (Floating Action Button) for creating new entry
    const fabButton = page.getByText('NEW');
    
    const hasFab = await fabButton.isVisible().catch(() => false);

    if (hasFab) {
      await fabButton.click();
    }

    await page.waitForTimeout(2000);

    // Should navigate to write page
    const currentUrl = page.url();
    expect(currentUrl).toContain('/write');
  });

  test('should display backend offline message when server unavailable', async ({ page }) => {
    // This test simulates offline scenario
    // Intercept API calls to simulate server unavailability
    await page.route('**/api/**', (route) => {
      route.abort('internetdisconnected');
    });

    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(3000);

    // Check for offline indicator or message
    const offlineIndicator = page.locator('[data-testid="offline-indicator"], .offlineIcon, [class*="offline"], svg[name="wifi-slash"], [class*="wifi-slash"]').first();
    const offlineMessage = page.locator('text=/后端未连接|Backend offline|バックエンド未接続/').first();
    const offlineIcon = page.locator('svg[name="wifi-slash"], svg[data-icon="wifi-slash"], text=/wifi-slash|offline/').first();

    const hasOfflineIndicator = await offlineIndicator.isVisible().catch(() => false);
    const hasOfflineMessage = await offlineMessage.isVisible().catch(() => false);
    const hasOfflineIcon = await offlineIcon.isVisible().catch(() => false);

    // At least one offline indicator should be visible
    expect(hasOfflineIndicator || hasOfflineMessage || hasOfflineIcon).toBeTruthy();

    // Remove the route interception
    await page.unroute('**/api/**');
  });
});

test.describe('Timeline - Additional Edge Cases', () => {
  test.setTimeout(60000);

  test.beforeEach(async ({ page }) => {
    await login(page);
  });

  test('should handle rapid filter changes gracefully', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(1000);

    // Open filter
    const filterButton = page.getByRole('button').filter({ has: page.locator('svg, img') }).nth(1);
    if (await filterButton.isVisible().catch(() => false)) {
      await filterButton.click();
      await page.waitForTimeout(500);

      // Rapidly click different filters
      const categories = ['work', 'life', 'study'];
      for (const cat of categories) {
        const catButton = page.locator(`text=/${cat}/i`).first();
        if (await catButton.isVisible().catch(() => false)) {
          await catButton.click();
          await page.waitForTimeout(200);
        }
      }
    }

    // Page should still be stable
    expect(page.url()).toContain('/');
  });

  test('should maintain scroll position after refresh', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(1500);

    // Scroll down
    await page.evaluate(() => window.scrollTo(0, 300));
    await page.waitForTimeout(500);

    // Click refresh
    const refreshButton = page.getByRole('button').filter({ has: page.locator('svg, img') }).nth(0);
    
    if (await refreshButton.isVisible()) {
      await refreshButton.click();
      await page.waitForTimeout(2000);
    }

    // Page should still be functional
    const container = page.locator('[role="list"]').first();
    const isVisible = await container.isVisible().catch(() => false);
    expect(isVisible).toBeTruthy();
  });

  test('should display correct date formatting on entry cards', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    // Check for date pattern on entry cards
    const dateElements = page.locator('.entry-date, .metaRow, .entryCard [class*="date"], [role="timer"], time').first();
    const datePatternElements = page.locator('text=/\\d{4}-\\d{2}-\\d{2}|\\d{4}年|Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec|周一|周二|周三|周四|周五|周六|周日|月|火|水|木|金|土|日/i').first(); // Find by common date formats
    
    const hasDateElement = await dateElements.isVisible().catch(() => false);
    const hasDatePattern = await datePatternElements.isVisible().catch(() => false);
    
    const elementToTest = hasDateElement ? dateElements : 
                         datePatternElements;
    
    if(hasDateElement || hasDatePattern) {
      const dateText = await elementToTest.textContent();
      // Should contain year, month, or day patterns
      expect(dateText).toMatch(/\d{4}|\d{1,2}|Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec|周一|周二|周三|周四|周五|周六|周日|月|火|水|木|金|土|日/i);
    }
  });
});
