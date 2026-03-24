import { expect, test } from '@playwright/test';

test.describe('设置流程', () => {
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

  test('设置页面显示外观选项', async ({ page }) => {
    await ensureLoggedIn(page);

    await page.getByText('设置').click();
    await page.waitForTimeout(3000);

    await expect(page.getByText('外观').first()).toBeVisible({ timeout: 10000 });
  });

  test('设置页面显示语言选项', async ({ page }) => {
    await ensureLoggedIn(page);

    await page.getByText('设置').click();
    await page.waitForTimeout(3000);

    await expect(page.getByText('语言').first()).toBeVisible({ timeout: 10000 });
  });

  test('设置页面显示账号区域', async ({ page }) => {
    await ensureLoggedIn(page);

    await page.getByText('设置').click();
    await page.waitForTimeout(3000);

    await expect(page.getByText('账号').first()).toBeVisible({ timeout: 10000 });
  });
});
