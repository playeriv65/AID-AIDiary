import { expect, test } from '@playwright/test';

test.describe('搜索流程', () => {
  test.use({ storageState: undefined });

  async function ensureLoggedIn(page: import('@playwright/test').Page) {
    await page.goto('/');
    await page.waitForTimeout(3000);

    const avatar = page
      .locator('div')
      .filter({ hasText: /^[A-Z]$/ })
      .first();
    const isLoggedIn = await avatar.isVisible({ timeout: 3000 });

    if (!isLoggedIn) {
      await page.getByText('设置').click();
      await page.waitForTimeout(2000);

      const loginBtn = page.getByText(/登录.*注册/);
      if (await loginBtn.isVisible({ timeout: 3000 })) {
        await loginBtn.click();
        await page.waitForTimeout(2000);

        await page.getByPlaceholder(/用户名/).fill('testuser');
        await page.getByPlaceholder(/密码/).fill('testpass123');
        await page.locator('text=登录').last().click();
        await page.waitForTimeout(8000);
      }
    }
  }

  test('搜索关键词 - 搜索框可用', async ({ page }) => {
    await ensureLoggedIn(page);

    await page.getByText('搜索').click();
    await page.waitForTimeout(3000);

    const searchInput = page.locator('input').first();
    await expect(searchInput).toBeVisible({ timeout: 10000 });

    await searchInput.fill('日记');
    await page.waitForTimeout(3000);

    await expect(searchInput).toHaveValue('日记');
  });

  test('清空搜索框', async ({ page }) => {
    await ensureLoggedIn(page);

    await page.getByText('搜索').click();
    await page.waitForTimeout(3000);

    const searchInput = page.locator('input').first();
    await searchInput.fill('测试');
    await page.waitForTimeout(2000);

    await searchInput.clear();
    await page.waitForTimeout(2000);

    await expect(searchInput).toHaveValue('');
  });
});
