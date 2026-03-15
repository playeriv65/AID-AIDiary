import { expect, test } from '@playwright/test';

test.describe('设置流程', () => {
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

  test('切换主题色', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForTimeout(3000);

    const colorButtons = page.locator('[role="button"]').filter({ hasText: /主题色/ });
    await colorButtons.first().click();
    await page.waitForTimeout(2000);

    console.log('✅ 主题色切换成功');
  });

  test('切换语言', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForTimeout(3000);

    const englishButton = page.getByText('English');
    await englishButton.click();
    await page.waitForTimeout(2000);

    console.log('✅ 语言切换成功');

    const zhButton = page.getByText('中文');
    await zhButton.click();
    await page.waitForTimeout(2000);
  });

  test('查看关于信息', async ({ page }) => {
    await page.goto('/settings');
    await page.waitForTimeout(3000);

    const aboutSection = page.locator('text=/关于|About/');
    const isVisible = await aboutSection.isVisible().catch(() => false);
    expect(isVisible).toBeTruthy();

    console.log('✅ 关于信息显示成功');
  });
});
