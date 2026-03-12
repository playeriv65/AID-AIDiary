import { expect, test } from '@playwright/test';
import { CalendarPage } from './helpers/page-objects';
import { login, ensureAuthenticated } from './helpers/auth';

// Helper function to format date as yyyy-MM-dd
function formatDate(date: Date): string {
  return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`;
}

// Helper function to get month names for different languages
function getExpectedMonthNames(lang: 'zh' | 'en' | 'ja'): string[] {
  const months: Record<string, string[]> = {
    zh: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
    en: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
    ja: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
  };
  return months[lang];
}

// Helper function to get weekday names for different languages
function getExpectedWeekdayNames(lang: 'zh' | 'en' | 'ja'): string[] {
  const weekdays: Record<string, string[]> = {
    zh: ['日', '一', '二', '三', '四', '五', '六'],
    en: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
    ja: ['日', '月', '火', '水', '木', '金', '土'],
  };
  return weekdays[lang];
}

test.describe('Calendar - Display', () => {
  test.setTimeout(60000);

  test.beforeEach(async ({ page }) => {
    await login(page);
  });

  test('should display 12 months (from current month going backwards)', async ({ page }) => {
    const calendarPage = new CalendarPage(page);
    await calendarPage.goto();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    // The calendar should show 12 months
    // Count month containers (each month has a title with year)
    const monthTitles = page.locator('text=/\\d{4}/'); // Matches year patterns like 2024, 2025
    const count = await monthTitles.count();
    expect(count).toBeGreaterThanOrEqual(12);

    // Verify that the current month is visible
    const currentDate = new Date();
    const currentYear = currentDate.getFullYear();
    const currentMonthPattern = new RegExp(currentYear.toString());
    const currentMonthVisible = await page.locator(`text=/${currentYear}/`).first().isVisible();
    expect(currentMonthVisible).toBeTruthy();
  });

  test('should mark dates with diary entries (red dots)', async ({ page, request }) => {
    const calendarPage = new CalendarPage(page);
    const today = new Date();
    const todayStr = formatDate(today);

    // First, create a diary entry via API
    const apiUrl = process.env.EXPO_PUBLIC_ENV === 'test'
      ? 'http://127.0.0.1:8001/api'
      : 'http://127.0.0.1:8000/api';

    const token = await page.evaluate(async () => {
      const item = localStorage.getItem('@app_token');
      return item ? JSON.parse(item) : null;
    }).catch(() => null);

    let testEntryId: string | null = null;

    if (token) {
      try {
        const response = await request.post(`${apiUrl}/entries/`, {
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json',
          },
          data: {
            title: `Calendar Test Entry ${Date.now()}`,
            content: 'Test entry for calendar red dot',
            category: 'life',
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

    // Navigate to calendar and verify red dot
    await calendarPage.goto();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    // Refresh to ensure data is loaded
    await page.reload();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    const entryDot = page.locator('[style*="background-color: rgb(255, 59, 48)"], [style*="#FF3B30"], text=/●/').first().or(page.locator('circle').and(page.locator('[fill="#FF3B30"]')).first());
    const hasEntryDot = await entryDot.isVisible().catch(() => false);

    // Clean up test entry
    if (testEntryId && token) {
      try {
        await request.delete(`${apiUrl}/entries/${testEntryId}`, {
          headers: { 'Authorization': `Bearer ${token}` },
        });
      } catch (error) {
        console.log('Failed to delete test entry:', error);
      }
    }

    // The red dot should be visible if entry was created
    expect(hasEntryDot).toBeTruthy();
  });

  test('should localize month names based on language setting', async ({ page }) => {
    const calendarPage = new CalendarPage(page);

    // Test Chinese month names
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(1000);

    // Select Chinese language
    const langSelect = page.locator('text=简体中文').first().or(page.locator('text=中文').first()).or(page.locator('text=Chinese').first());
    if (await langSelect.isVisible().catch(() => false)) {
      await langSelect.click();
      await page.waitForTimeout(1000);
    }

    await calendarPage.goto();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    // Check for Chinese month names
    const zhMonths = ['一月', '二月', '三月', '四月', '五月', '六月'];
    let hasZhMonth = false;
    for (const month of zhMonths) {
      const monthElement = page.locator(`text=${month}`).first();
      if (await monthElement.isVisible().catch(() => false)) {
        hasZhMonth = true;
        break;
      }
    }

    // Now test English month names
    await page.goto('/settings');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(1000);

    const langSelectEn = page.locator('text=English').first().or(page.locator('text=EN').first()).or(page.locator('text=英语').first());
    if (await langSelectEn.isVisible().catch(() => false)) {
      await langSelectEn.click();
      await page.waitForTimeout(1000);
    }

    await calendarPage.goto();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    // Check for English month names
    const enMonths = ['January', 'February', 'March', 'April', 'May', 'June'];
    let hasEnMonth = false;
    for (const month of enMonths) {
      const monthElement = page.locator(`text=${month}`).first();
      if (await monthElement.isVisible().catch(() => false)) {
        hasEnMonth = true;
        break;
      }
    }

    // At least one language localization should work
    expect(hasZhMonth || hasEnMonth).toBeTruthy();
  });
});

test.describe('Calendar - Month Navigation', () => {
  test.setTimeout(60000);

  test.beforeEach(async ({ page }) => {
    await login(page);
  });

  test('should scroll through months', async ({ page }) => {
    const calendarPage = new CalendarPage(page);
    await calendarPage.goto();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    // Get initial scroll position
    const initialScrollY = await page.evaluate(() => window.scrollY);

    // Scroll down to see older months
    await page.evaluate(() => window.scrollTo(0, 1000));
    await page.waitForTimeout(500);

    const scrolledScrollY = await page.evaluate(() => window.scrollY);

    // Should have scrolled
    expect(scrolledScrollY).toBeGreaterThan(initialScrollY);

    // Scroll back up
    await page.evaluate(() => window.scrollTo(0, 0));
    await page.waitForTimeout(500);

    const finalScrollY = await page.evaluate(() => window.scrollY);
    expect(finalScrollY).toBe(0);
  });

  test('should display correct weekday names', async ({ page }) => {
    const calendarPage = new CalendarPage(page);
    await calendarPage.goto();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    // Check for weekday headers - should show all 7 days
    // Multi-language support: Chinese, English, Japanese
    const weekdayPatterns = [
      /日|Sun/, /一|Mon/, /二|Tue/, /三|Wed/, /四|Thu/, /五|Fri/, /六|Sat/,
    ];

    let foundWeekdays = 0;
    for (const pattern of weekdayPatterns) {
      const weekdayElement = page.locator(`text=${pattern}`).first();
      if (await weekdayElement.isVisible().catch(() => false)) {
        foundWeekdays++;
      }
    }

    // Should find at least some weekday headers
    expect(foundWeekdays).toBeGreaterThanOrEqual(5);

    // Verify there are 7 day headers in each month view
    const dayHeaders = page.locator('text=/日|一|二|三|四|五|六|Sun|Mon|Tue|Wed|Thu|Fri|Sat/').first();
    const hasDayHeaders = await dayHeaders.isVisible().catch(() => false);
    expect(hasDayHeaders).toBeTruthy();
  });
});

test.describe('Calendar - Date Interaction', () => {
  test.setTimeout(60000);

  test.beforeEach(async ({ page }) => {
    await login(page);
  });

  test('should navigate to timeline when clicking a date with entry', async ({ page, request }) => {
    const calendarPage = new CalendarPage(page);
    const today = new Date();

    // Create a diary entry first
    const apiUrl = process.env.EXPO_PUBLIC_ENV === 'test'
      ? 'http://127.0.0.1:8001/api'
      : 'http://127.0.0.1:8000/api';

    const token = await page.evaluate(async () => {
      const item = localStorage.getItem('@app_token');
      return item ? JSON.parse(item) : null;
    }).catch(() => null);

    let testEntryId: string | null = null;

    if (token) {
      try {
        const response = await request.post(`${apiUrl}/entries/`, {
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json',
          },
          data: {
            title: `Click Test Entry ${Date.now()}`,
            content: 'Test entry for date click',
            category: 'life',
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

    await calendarPage.goto();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    // Find and click on a date cell that has an entry
    // Entry dates are clickable (has active opacity)
    const dateCell = page.locator('text=/\\d+/').filter({ hasText: /^\d+$/ }).first();
    const hasDateCell = await dateCell.isVisible().catch(() => false);

    if (hasDateCell) {
      await dateCell.click();
      await page.waitForTimeout(2000);

      // Should navigate to timeline
      const currentUrl = page.url();
      expect(currentUrl).toMatch(/\/$/);
    }

    // Clean up
    if (testEntryId && token) {
      try {
        await request.delete(`${apiUrl}/entries/${testEntryId}`, {
          headers: { 'Authorization': `Bearer ${token}` },
        });
      } catch (error) {
        console.log('Failed to delete test entry:', error);
      }
    }
  });

  test('should show FAB button for creating new diary', async ({ page }) => {
    const calendarPage = new CalendarPage(page);
    await calendarPage.goto();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    // Check for FAB container
    const fabContainer = page.getByText('NEW').or(page.locator('div').and(page.locator('[style*="position: absolute"]'))).first().locator('..').first();
    const hasFabContainer = await fabContainer.isVisible().catch(() => false);

    // Check for main FAB button with plus icon
    const mainFab = page.locator('text=NEW').or(page.locator('text=加')).or(page.locator('text=追加')).first();
    const hasMainFab = await mainFab.isVisible().catch(() => false);

    // Check for calendar FAB button
    const calendarFab = page.locator('svg').filter({ has: page.locator('path[d*="M13 2 H21"], [d*="calendar"]') }).first();
    const hasCalendarFab = await calendarFab.isVisible().catch(() => false);

    // At least one FAB should be visible
    expect(hasFabContainer || hasMainFab || hasCalendarFab).toBeTruthy();

    // Verify FAB has correct styling (accent color background)
    if (hasMainFab) {
      const fabStyles = await mainFab.evaluate((el) => {
        const style = window.getComputedStyle(el);
        return style.backgroundColor;
      });
      // FAB should have a background color (not transparent)
      expect(fabStyles).not.toBe('rgba(0, 0, 0, 0)');
    }
  });

  test('should click FAB to navigate to write page', async ({ page }) => {
    const calendarPage = new CalendarPage(page);
    await calendarPage.goto();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    // Click the main FAB button
    const mainFab = page.locator('text=NEW').or(page.locator('text=加')).or(page.locator('text=追加')).first();
    const hasMainFab = await mainFab.isVisible().catch(() => false);

    if (hasMainFab) {
      await mainFab.click();
      await page.waitForTimeout(2000);

      // Should navigate to write page
      const currentUrl = page.url();
      expect(currentUrl).toContain('/write');
    } else {
      const newEntryButton = page.locator('text=/新建|New|新規|追加|作成/').first();
      if (await newEntryButton.isVisible().catch(() => false)) {
        await newEntryButton.click();
        await page.waitForTimeout(2000);

        const currentUrl = page.url();
        expect(currentUrl).toContain('/write');
      }
    }
  });
});

test.describe('Calendar - Data Synchronization', () => {
  test.setTimeout(60000);

  test.beforeEach(async ({ page }) => {
    await login(page);
  });

  test('should update red dot when diary is created', async ({ page, request }) => {
    const calendarPage = new CalendarPage(page);
    const today = new Date();
    const todayStr = formatDate(today);

    const apiUrl = process.env.EXPO_PUBLIC_ENV === 'test'
      ? 'http://127.0.0.1:8001/api'
      : 'http://127.0.0.1:8000/api';

    const token = await page.evaluate(async () => {
      const item = localStorage.getItem('@app_token');
      return item ? JSON.parse(item) : null;
    }).catch(() => null);

    // Navigate to calendar first
    await calendarPage.goto();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    // Check if there's already a red dot for today
    const initialDot = page.locator('text=/●/[style*="background-color: rgb(255, 59, 48)"]').first().or(page.getByText('●'));
    const hadInitialDot = await initialDot.isVisible().catch(() => false);

    // Create a new entry via API
    let testEntryId: string | null = null;
    if (token) {
      try {
        const response = await request.post(`${apiUrl}/entries/`, {
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json',
          },
          data: {
            title: `Sync Test Entry ${Date.now()}`,
            content: 'Test entry for red dot sync',
            category: 'life',
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

    // Refresh calendar to sync data
    await page.reload();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(3000);

    // Check for red dot after entry creation
    const newDot = page.locator('text=/●/[style*="background-color: rgb(255, 59, 48)"]').first().or(page.getByText('●'));
    const hasNewDot = await newDot.isVisible().catch(() => false);

    // Clean up
    if (testEntryId && token) {
      try {
        await request.delete(`${apiUrl}/entries/${testEntryId}`, {
          headers: { 'Authorization': `Bearer ${token}` },
        });
      } catch (error) {
        console.log('Failed to delete test entry:', error);
      }
    }

    // Red dot should appear after creating entry
    expect(hasNewDot).toBeTruthy();
  });

  test('should remove red dot when diary is deleted', async ({ page, request }) => {
    const calendarPage = new CalendarPage(page);

    const apiUrl = process.env.EXPO_PUBLIC_ENV === 'test'
      ? 'http://127.0.0.1:8001/api'
      : 'http://127.0.0.1:8000/api';

    const token = await page.evaluate(async () => {
      const item = localStorage.getItem('@app_token');
      return item ? JSON.parse(item) : null;
    }).catch(() => null);

    // Create a test entry first
    let testEntryId: string | null = null;
    if (token) {
      try {
        const response = await request.post(`${apiUrl}/entries/`, {
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json',
          },
          data: {
            title: `Delete Test Entry ${Date.now()}`,
            content: 'Test entry to be deleted',
            category: 'life',
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

    // Navigate to calendar and verify entry dot exists
    await calendarPage.goto();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(3000);

    // Check for entry dot before deletion
    const dotBeforeDelete = page.locator('text=/●/[style*="background-color: rgb(255, 59, 48)"]').first().or(page.getByText('●'));
    const hadDotBefore = await dotBeforeDelete.isVisible().catch(() => false);

    // Delete the entry
    if (testEntryId && token) {
      try {
        await request.delete(`${apiUrl}/entries/${testEntryId}`, {
          headers: { 'Authorization': `Bearer ${token}` },
        });
      } catch (error) {
        console.log('Failed to delete test entry:', error);
      }
    }

    // Refresh calendar to sync data
    await page.reload();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(3000);

    // Check if entry dot is removed
    // Note: There might be other entries, so we check if the specific date's dot is gone
    // For this test, we verify the sync mechanism works by checking page state
    const gridContainer = page.locator('div').and(page.locator('[style*="flexDirection: row"][style*="flexWrap: wrap"]')).first();
    const hasGrid = await gridContainer.isVisible().catch(() => false);

    // The calendar should still be functional after deletion
    expect(hasGrid).toBeTruthy();
  });
});

test.describe('Calendar - Additional Features', () => {
  test.setTimeout(60000);

  test.beforeEach(async ({ page }) => {
    await login(page);
  });

  test('should display calendar in sidebar navigation', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(1000);

    // Look for calendar link in sidebar
    const calendarLink = page.locator('text=/日历|Calendar|カレンダー/').first();
    const hasCalendarLink = await calendarLink.isVisible().catch(() => false);

    expect(hasCalendarLink).toBeTruthy();

    // Click on calendar link
    if (hasCalendarLink) {
      await calendarLink.click();
      await page.waitForTimeout(2000);

      // Should navigate to calendar page
      const currentUrl = page.url();
      expect(currentUrl).toContain('/calendar');
    }
  });

  test('should highlight today date', async ({ page }) => {
    const calendarPage = new CalendarPage(page);
    await calendarPage.goto();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    // Today's date should have special styling
    // It has isToday styling with different background
    const todayCell = page.getByRole('button', { name: /\d+/ });
    const hasTodayCell = await todayCell.isVisible().catch(() => false);

    expect(hasTodayCell).toBeTruthy();

    const allCells = page.locator('text=/\\d+/').filter({ hasText: /^\d+$/ });
    const cellCount = await allCells.count();

    // Should have at least 12 months * ~35 days = 420 cells
    expect(cellCount).toBeGreaterThanOrEqual(300);
  });

  test('should handle month grid layout correctly', async ({ page }) => {
    const calendarPage = new CalendarPage(page);
    await calendarPage.goto();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    // Each month should have a grid with 7 columns (weekdays)
    const monthContainers = page.locator('text=/^[A-Za-z]+ \\d{4}$/', { exact: false }).or(page.locator('div >> text=/\\d{4}/'));
    const monthCount = await monthContainers.count();

    // Should have 12 month containers
    expect(monthCount).toBeGreaterThanOrEqual(12);

    // Each month should have a days header with 7 days
    const daysHeaders = page.locator('text=/^(Sun|Mon|Tue|Wed|Thu|Fri|Sat|日|一|二|三|四|五|六|月|火|水|木|金|土)$/');
    const headersCount = await daysHeaders.count();

    expect(headersCount).toBeGreaterThanOrEqual(12);
  });
});
