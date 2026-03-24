import { expect, test } from '@playwright/test';

test.describe('New User Flow', () => {
  test.use({ storageState: undefined });

  test('新用户注册成功', async ({ page }) => {
    const username = `newuser_${Date.now()}`;

    await page.goto('/');
    await page.waitForTimeout(5000);

    await page.getByText('设置').click();
    await page.waitForTimeout(2000);

    await page.getByText(/登录.*注册/).click();
    await page.waitForTimeout(2000);

    await page.getByText(/没有账号/).click();
    await page.waitForTimeout(1000);

    await page.getByPlaceholder(/用户名/).fill(username);
    await page.getByPlaceholder(/密码/).fill('TestPass123!');
    await page.locator('text=注册').last().click();
    await page.waitForTimeout(10000);

    const avatar = page
      .locator('div')
      .filter({ hasText: /^[A-Z]$/ })
      .first();
    await expect(avatar).toBeVisible({ timeout: 15000 });
  });
});
