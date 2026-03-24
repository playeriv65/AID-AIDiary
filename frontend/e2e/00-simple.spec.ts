import { expect, test } from '@playwright/test';

test.describe('基础页面测试', () => {
  test('页面加载成功', async ({ page }) => {
    const response = await page.goto('/');
    expect(response?.status()).toBe(200);
  });

  test('导航菜单可见', async ({ page }) => {
    await page.goto('/');
    await page.waitForSelector('body', { timeout: 10000 });

    await expect(page.getByText('时间线')).toBeVisible();
    await expect(page.getByText('聊天')).toBeVisible();
    await expect(page.getByText('日历')).toBeVisible();
    await expect(page.getByText('搜索')).toBeVisible();
    await expect(page.getByText('设置')).toBeVisible();
  });

  test('Logo 可见', async ({ page }) => {
    await page.goto('/');
    await page.waitForSelector('body', { timeout: 10000 });

    await expect(page.getByText('AID')).toBeVisible();
  });
});
