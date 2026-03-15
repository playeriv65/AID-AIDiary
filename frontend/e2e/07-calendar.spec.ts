import { expect, test } from '@playwright/test';

test.describe('日历功能', () => {
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

  test('日历视图显示', async ({ page }) => {
    await page.goto('/calendar');
    await page.waitForTimeout(5000);

    const calendarGrid = page.locator('[role="grid"], [data-testid="calendar"]');
    const isVisible = await calendarGrid.isVisible().catch(() => false);
    expect(isVisible).toBeTruthy();
    console.log('✅ 日历视图显示成功');
  });

  test('点击日历日期', async ({ page }) => {
    await page.goto('/calendar');
    await page.waitForTimeout(5000);

    const today = new Date().getDate();
    const dateCell = page.locator(`text=${today}`).first();
    await dateCell.click();
    await page.waitForTimeout(2000);

    console.log('✅ 日期选择成功');
  });

  test('切换月份', async ({ page }) => {
    await page.goto('/calendar');
    await page.waitForTimeout(5000);

    const prevButton = page.locator('button[aria-label*="previous"], button:has-text("<")').first();
    await prevButton.click();
    await page.waitForTimeout(2000);

    const nextButton = page.locator('button[aria-label*="next"], button:has-text(">")').first();
    await nextButton.click();
    await page.waitForTimeout(2000);

    console.log('✅ 月份切换成功');
  });
});
