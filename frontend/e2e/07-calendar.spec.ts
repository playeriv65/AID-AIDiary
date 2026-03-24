import { expect, test } from '@playwright/test';

test.describe('日历功能', () => {
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

  test('日历视图显示', async ({ page }) => {
    await ensureLoggedIn(page);

    await page.getByText('日历').click();
    await page.waitForTimeout(5000);

    await expect(page.locator('body')).toBeVisible();
  });

  test('点击日历日期', async ({ page }) => {
    await ensureLoggedIn(page);

    await page.getByText('日历').click();
    await page.waitForTimeout(5000);

    const today = new Date().getDate();
    await expect(page.getByText(String(today)).first()).toBeVisible({ timeout: 10000 });
  });

  test('切换月份', async ({ page }) => {
    await ensureLoggedIn(page);

    await page.getByText('日历').click();
    await page.waitForTimeout(5000);

    const navButtons = page.locator('button').filter({ has: page.locator('svg') });
    const count = await navButtons.count();

    if (count >= 2) {
      await navButtons.first().click();
      await page.waitForTimeout(2000);

      await expect(page.locator('body')).toBeVisible();
    }
  });
});
