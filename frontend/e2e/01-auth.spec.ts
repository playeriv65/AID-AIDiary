import { expect, test } from '@playwright/test';

test.describe('认证流程', () => {
  test('新用户注册流程', async ({ page }) => {
    const username = `newuser_${Date.now()}`;
    const password = 'testpass123';

    await page.goto('/');
    await page.waitForTimeout(3000);

    const loginBanner = page.getByText('请登录以同步数据');
    await loginBanner.click();
    await page.waitForTimeout(2000);

    const registerLink = page.getByText(/注册/).first();
    await registerLink.click();
    await page.waitForTimeout(1000);

    const inputs = page.locator('input');
    await inputs.first().fill(username);
    await inputs.nth(1).fill(password);

    const registerButton = page.getByRole('button', { name: /注册/ });
    await registerButton.click();
    await page.waitForTimeout(5000);

    const userAvatar = page.locator('text=/^[A-Z]$/').first();
    await expect(userAvatar).toBeVisible({ timeout: 10000 });
    console.log(`✅ 用户 ${username} 注册成功`);
  });

  test('已有用户登录流程', async ({ page }) => {
    await page.goto('/');
    await page.waitForTimeout(3000);

    const loginBanner = page.getByText('请登录以同步数据');
    await loginBanner.click();
    await page.waitForTimeout(2000);

    const inputs = page.locator('input');
    await inputs.first().fill('testuser');
    await inputs.nth(1).fill('testpass123');

    const loginButton = page.getByRole('button', { name: /登录/ });
    await loginButton.click();
    await page.waitForTimeout(5000);

    const userAvatar = page.locator('text=/^[A-Z]$/').first();
    await expect(userAvatar).toBeVisible({ timeout: 10000 });
    console.log('✅ testuser 登录成功');
  });

  test('登出流程', async ({ page }) => {
    await page.goto('/');
    await page.waitForTimeout(3000);

    const userAvatar = page.locator('text=/^[A-Z]$/').first();
    if (await userAvatar.isVisible().catch(() => false)) {
      await userAvatar.click();
      await page.waitForTimeout(1000);

      const logoutButton = page.getByText(/退出登录/);
      if (await logoutButton.isVisible().catch(() => false)) {
        await logoutButton.click();
        await page.waitForTimeout(3000);

        const loginBanner = page.getByText('请登录以同步数据');
        await expect(loginBanner).toBeVisible({ timeout: 10000 });
        console.log('✅ 登出成功');
      }
    }
  });
});
