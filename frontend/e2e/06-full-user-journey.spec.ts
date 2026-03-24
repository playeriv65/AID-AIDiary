import { expect, test } from '@playwright/test';

test.describe('完整用户旅程', () => {
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

  test('用户完成日常使用全流程', async ({ page }) => {
    await ensureLoggedIn(page);

    await page.getByText('时间线').click();
    await page.waitForTimeout(3000);
    await expect(page.getByText('新建')).toBeVisible({ timeout: 10000 });

    await page.getByText('聊天').click();
    await page.waitForTimeout(3000);
    await expect(page.locator('input, textarea').first()).toBeVisible({ timeout: 10000 });

    await page.getByText('日历').click();
    await page.waitForTimeout(3000);
    await expect(page.locator('body')).toBeVisible();

    await page.getByText('搜索').click();
    await page.waitForTimeout(3000);
    await expect(page.locator('input').first()).toBeVisible({ timeout: 10000 });

    await page.getByText('设置').click();
    await page.waitForTimeout(3000);
    await expect(page.getByText('外观').first()).toBeVisible({ timeout: 10000 });
  });
});
