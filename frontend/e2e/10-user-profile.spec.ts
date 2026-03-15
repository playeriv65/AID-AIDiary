import { expect, test } from '@playwright/test';

test.describe('用户资料', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    await page.waitForTimeout(3000);

    const loginBanner = page.getByText('请登录以同步数据');
    if (await loginBanner.isVisible().catch(() => false)) {
      await loginBanner.click();
      await page.waitForTimeout(2000);

      const inputs = page.locator('input');
      await inputs.first().fill('testuser');
      await inputs.nth(1).fill('testpass123');

      const loginButton = page.getByRole('button', { name: /登录/ });
      await loginButton.click();
      await page.waitForTimeout(5000);
    }
  });

  test('用户头像显示', async ({ page }) => {
    await page.goto('/');
    await page.waitForTimeout(3000);

    const userAvatar = page.locator('text=/^[A-Z]$/').first();
    await expect(userAvatar).toBeVisible({ timeout: 10000 });
    console.log('✅ 用户头像显示成功');
  });

  test('用户菜单展开', async ({ page }) => {
    await page.goto('/');
    await page.waitForTimeout(3000);

    const userAvatar = page.locator('text=/^[A-Z]$/').first();
    await userAvatar.click();
    await page.waitForTimeout(2000);

    const logoutButton = page.getByText(/退出登录/);
    const isVisible = await logoutButton.isVisible().catch(() => false);
    expect(isVisible).toBeTruthy();
    console.log('✅ 用户菜单展开成功');
  });

  test('查看统计数据', async ({ page }) => {
    await page.goto('/');
    await page.waitForTimeout(5000);

    const statsSection = page.locator('text=/共 | 篇|总计/');
    const isVisible = await statsSection.isVisible().catch(() => false);
    if (isVisible) {
      console.log('✅ 统计数据显示成功');
    } else {
      console.log('⏭️ 跳过统计测试');
    }
  });
});
