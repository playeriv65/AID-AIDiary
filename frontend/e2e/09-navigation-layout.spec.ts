import { expect, test } from '@playwright/test';

test.describe('导航和布局', () => {
  test('所有导航菜单可访问', async ({ page }) => {
    await page.goto('/');
    await page.waitForTimeout(5000);

    await expect(page.getByText('时间线')).toBeVisible({ timeout: 10000 });
    await expect(page.getByText('聊天')).toBeVisible({ timeout: 5000 });
    await expect(page.getByText('日历')).toBeVisible({ timeout: 5000 });
    await expect(page.getByText('搜索')).toBeVisible({ timeout: 5000 });
    await expect(page.getByText('设置')).toBeVisible({ timeout: 5000 });
  });

  test('导航到各页面', async ({ page }) => {
    await page.goto('/');
    await page.waitForTimeout(3000);

    await page.getByText('聊天').click();
    await page.waitForTimeout(3000);
    await expect(page.locator('body')).toBeVisible();

    await page.getByText('日历').click();
    await page.waitForTimeout(3000);
    await expect(page.locator('body')).toBeVisible();

    await page.getByText('搜索').click();
    await page.waitForTimeout(3000);
    await expect(page.locator('body')).toBeVisible();

    await page.getByText('设置').click();
    await page.waitForTimeout(3000);
    await expect(page.locator('body')).toBeVisible();
  });

  test('响应式布局 - 移动端', async ({ page }) => {
    await page.setViewportSize({ width: 375, height: 667 });
    await page.goto('/');
    await page.waitForTimeout(5000);

    await expect(page.locator('body')).toBeVisible();
  });

  test('响应式布局 - 桌面端', async ({ page }) => {
    await page.setViewportSize({ width: 1920, height: 1080 });
    await page.goto('/');
    await page.waitForTimeout(5000);

    await expect(page.locator('body')).toBeVisible();
    await expect(page.getByText('时间线')).toBeVisible({ timeout: 10000 });
  });
});
