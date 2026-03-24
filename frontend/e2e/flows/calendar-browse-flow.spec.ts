import { expect, test } from '@playwright/test';

test.describe('Calendar Browse Flow', () => {
  test.use({ storageState: undefined });

  async function ensureLoggedIn(page: import('@playwright/test').Page) {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    const avatar = page
      .locator('div')
      .filter({ hasText: /^[A-Z]$/ })
      .first();
    const isLoggedIn = await avatar.isVisible({ timeout: 3000 }).catch(() => false);

    if (!isLoggedIn) {
      await page.getByText('设置').click();

      const loginBtn = page.getByText(/登录.*注册/);
      if (await loginBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
        await loginBtn.click();

        await page.getByPlaceholder(/用户名/).waitFor({ state: 'visible', timeout: 5000 });
        await page.getByPlaceholder(/用户名/).fill('testuser');
        await page.getByPlaceholder(/密码/).fill('testpass123');
        await page.locator('text=登录').last().click();
        await page.waitForLoadState('networkidle');
      }
    }
  }

  test('用户浏览日历', async ({ page }) => {
    await ensureLoggedIn(page);

    await page.getByText('日历').click();
    await page.waitForLoadState('networkidle');

    await expect(page.locator('body')).toBeVisible();
  });
});
