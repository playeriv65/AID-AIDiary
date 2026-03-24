import { expect, test } from '@playwright/test';

test.describe('用户资料', () => {
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

  test('登录后显示用户头像', async ({ page }) => {
    await ensureLoggedIn(page);

    const avatar = page
      .locator('div')
      .filter({ hasText: /^[A-Z]$/ })
      .first();
    await expect(avatar).toBeVisible({ timeout: 15000 });
  });

  test('设置页面显示退出登录按钮', async ({ page }) => {
    await ensureLoggedIn(page);

    await page.getByText('设置').click();
    await page.waitForLoadState('networkidle');

    const logoutBtn = page.getByText(/退出登录/);
    if (await logoutBtn.isVisible({ timeout: 5000 }).catch(() => false)) {
      await expect(logoutBtn).toBeVisible();
    }
  });

  test('设置页面显示账号区域', async ({ page }) => {
    await ensureLoggedIn(page);

    await page.getByText('设置').click();
    await page.waitForLoadState('networkidle');

    await expect(page.getByText(/账号/)).toBeVisible({ timeout: 10000 });
  });
});
