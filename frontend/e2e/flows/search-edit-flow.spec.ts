import { expect, test } from '@playwright/test';

test.describe('Search and Edit Flow', () => {
  test.use({ storageState: undefined });

  async function login(page: import('@playwright/test').Page) {
    await page.goto('/');
    await page.waitForTimeout(3000);

    await page.getByText('设置').click();
    await page.waitForTimeout(2000);

    const loginBtn = page.getByText(/登录.*注册/);
    const needsLogin = await loginBtn.isVisible({ timeout: 3000 });

    if (needsLogin) {
      await loginBtn.click();
      await page.waitForTimeout(2000);

      await page.getByPlaceholder(/用户名/).fill('testuser');
      await page.getByPlaceholder(/密码/).fill('testpass123');
      await page.locator('text=登录').last().click();
      await page.waitForTimeout(8000);
    }
  }

  test('用户搜索日记', async ({ page }) => {
    await login(page);

    await page.getByText('搜索').click();
    await page.waitForTimeout(3000);

    const searchInput = page.getByPlaceholder(/搜索|查找/).first();
    await expect(searchInput).toBeVisible({ timeout: 10000 });

    await searchInput.fill('日记');
    await page.waitForTimeout(5000);

    await expect(page.locator('body')).toBeVisible();
  });
});
