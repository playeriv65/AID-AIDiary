import { expect, test } from '@playwright/test';
import { injectTestEnv, loginAndVerify } from './helpers/test-utils';

test.describe('完整用户旅程', () => {
  test.use({ storageState: undefined });

  test.beforeEach(async ({ page, context }) => {
    await context.clearCookies();
    await injectTestEnv(page);
    await loginAndVerify(page);
  });

  test('用户完成日常使用全流程 - 验证每个页面核心功能', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    await page.getByText('时间线').first().click();
    await page.waitForLoadState('networkidle');
    await expect(page.getByText(/新建|NEW|新規/).first()).toBeVisible({ timeout: 10000 });

    await page.getByText('聊天').first().click();
    await page.waitForLoadState('networkidle');
    const chatInput = page.locator('input, textarea').first();
    await expect(chatInput).toBeVisible({ timeout: 10000 });

    await page.getByText('日历').first().click();
    await page.waitForLoadState('networkidle');
    const today = new Date().getDate();
    const dateElement = page.getByText(String(today)).first();
    await expect(dateElement).toBeVisible({ timeout: 10000 });

    await page.getByText('搜索').first().click();
    await page.waitForLoadState('networkidle');
    const searchInput = page.locator('input[type="text"], input:not([type])').first();
    await expect(searchInput).toBeVisible({ timeout: 10000 });

    await page.getByText('设置').first().click();
    await page.waitForLoadState('networkidle');
    await expect(page.getByText(/外观|Appearance|テーマ/i).first()).toBeVisible({ timeout: 10000 });
  });

  test('导航持久性验证 - 确保页面切换后状态保持', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    const navItems = ['时间线', '聊天', '日历', '搜索', '设置'];

    for (const item of navItems) {
      await page.getByText(item).first().click();
      await page.waitForLoadState('networkidle');

      for (const navItem of navItems) {
        const isVisible = await page
          .getByText(navItem)
          .first()
          .isVisible({ timeout: 3000 })
          .catch(() => false);
        expect(isVisible).toBe(true);
      }
    }
  });
});
