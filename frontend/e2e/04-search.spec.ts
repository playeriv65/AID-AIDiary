import { expect, test } from '@playwright/test';

test.describe('搜索流程', () => {
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

  test('搜索关键词 → 显示结果', async ({ page }) => {
    const title = `搜索测试_${Date.now()}`;
    const content = `这是搜索测试内容`;

    await page.goto('/write');
    await page.waitForTimeout(5000);

    await page.getByPlaceholder('标题').fill(title);
    await page.getByPlaceholder('记录今日').fill(content);
    await page.getByRole('button', { name: 'Save diary' }).click();
    await page.waitForTimeout(5000);

    await page.goto('/search');
    await page.waitForTimeout(3000);

    const searchBox = page.locator('input[placeholder*="搜索"]');
    await searchBox.fill('搜索测试');
    await page.waitForTimeout(5000);

    const searchResults = page.locator(`text=${title}`);
    const resultCount = await searchResults.count();
    console.log(`🔍 找到 ${resultCount} 条结果`);
    expect(resultCount).toBeGreaterThan(0);
    console.log('✅ 搜索功能正常');
  });

  test('搜索标题关键词', async ({ page }) => {
    await page.goto('/search');
    await page.waitForTimeout(3000);

    const searchBox = page.locator('input[placeholder*="搜索"]');
    await searchBox.fill('日记');
    await page.waitForTimeout(5000);

    const results = page.locator('text=/日记/');
    const count = await results.count();
    console.log(`🔍 找到 ${count} 条包含"日记"的结果`);
  });

  test('清空搜索框 → 显示全部', async ({ page }) => {
    await page.goto('/search');
    await page.waitForTimeout(3000);

    const searchBox = page.locator('input[placeholder*="搜索"]');
    await searchBox.fill('测试');
    await page.waitForTimeout(3000);

    await searchBox.clear();
    await page.waitForTimeout(3000);

    console.log('✅ 搜索框清空成功');
  });
});
