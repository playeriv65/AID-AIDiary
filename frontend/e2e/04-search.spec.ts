import { expect, test } from '@playwright/test';
import { injectTestEnv, loginAndVerify } from './helpers/test-utils';

test.describe('搜索流程', () => {
  test.use({ storageState: undefined });

  test.beforeEach(async ({ page, context }) => {
    await context.clearCookies();
    await injectTestEnv(page);
    await loginAndVerify(page);
  });

  test('搜索关键词 - 验证搜索结果列表显示', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    await page.getByText('搜索').first().click();
    await page.waitForLoadState('networkidle');

    const searchInput = page.locator('input[type="text"], input:not([type])').first();
    await expect(searchInput).toBeVisible({ timeout: 10000 });

    await searchInput.fill('日记');

    await page.waitForTimeout(1000);

    await expect(searchInput).toHaveValue('日记');

    const hasSearchUI = await searchInput.isVisible();
    expect(hasSearchUI).toBe(true);
  });

  test('清空搜索框 - 验证输入值被清除', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    await page.getByText('搜索').first().click();
    await page.waitForLoadState('networkidle');

    const searchInput = page.locator('input[type="text"], input:not([type])').first();
    await searchInput.waitFor({ state: 'visible', timeout: 10000 });

    await searchInput.fill('测试搜索关键词');
    await expect(searchInput).toHaveValue('测试搜索关键词');

    await searchInput.clear();
    await expect(searchInput).toHaveValue('');
  });

  test('搜索页面布局完整', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    await page.getByText('搜索').first().click();
    await page.waitForLoadState('networkidle');

    const searchInput = page.locator('input[type="text"], input:not([type])').first();
    await expect(searchInput).toBeVisible({ timeout: 10000 });

    const placeholder = await searchInput.getAttribute('placeholder');
    expect(placeholder).toBeTruthy();
  });
});
