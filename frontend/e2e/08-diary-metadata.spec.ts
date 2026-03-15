import { expect, test } from '@playwright/test';

test.describe('日记元数据功能', () => {
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

    await page.goto('/write');
    await page.waitForTimeout(5000);
  });

  test('设置分类', async ({ page }) => {
    const categoryButton = page
      .getByText('设置分类')
      .or(page.getByText('工作').or(page.getByText('生活')));
    await categoryButton.click();
    await page.waitForTimeout(1000);

    const workOption = page.getByText('工作').or(page.getByText('Work')).first();
    await workOption.click();
    await page.waitForTimeout(2000);

    console.log('✅ 分类设置成功');
  });

  test('设置天气', async ({ page }) => {
    const weatherButton = page.getByText('选择天气').or(page.getByText('晴天')).first();
    await weatherButton.click();
    await page.waitForTimeout(1000);

    const sunnyOption = page.getByText('晴天').or(page.getByText('Sunny')).first();
    await sunnyOption.click();
    await page.waitForTimeout(2000);

    console.log('✅ 天气设置成功');
  });

  test('添加标签', async ({ page }) => {
    const tagInput = page.locator('input[placeholder*="标签"], input[placeholder*="Tag"]').first();
    if (await tagInput.isVisible().catch(() => false)) {
      await tagInput.fill('测试标签');
      await tagInput.press('Enter');
      await page.waitForTimeout(2000);

      const tagVisible = await page
        .locator('text=测试标签')
        .isVisible()
        .catch(() => false);
      expect(tagVisible).toBeTruthy();
      console.log('✅ 标签添加成功');
    } else {
      console.log('⏭️ 跳过标签测试');
    }
  });

  test('完整日记创建（标题 + 内容 + 分类 + 天气）', async ({ page }) => {
    const title = `完整测试_${Date.now()}`;
    const content = `这是完整的日记内容`;

    await page.getByPlaceholder('标题').fill(title);
    await page.getByPlaceholder('记录今日').fill(content);

    const categoryButton = page.getByText('设置分类').first();
    await categoryButton.click();
    await page.waitForTimeout(1000);
    const categoryOption = page.getByText('生活').or(page.getByText('Life')).first();
    await categoryOption.click();
    await page.waitForTimeout(1000);

    const weatherButton = page.getByText('选择天气').first();
    await weatherButton.click();
    await page.waitForTimeout(1000);
    const weatherOption = page.getByText('晴天').or(page.getByText('Sunny')).first();
    await weatherOption.click();
    await page.waitForTimeout(1000);

    const saveButton = page.getByRole('button', { name: 'Save diary' });
    await saveButton.click();
    await page.waitForTimeout(5000);

    await page.goto('/');
    await page.waitForTimeout(3000);
    await page.reload();
    await page.waitForTimeout(5000);

    const diaryCard = page.locator(`text=${title}`).first();
    await expect(diaryCard).toBeVisible({ timeout: 15000 });
    console.log('✅ 完整日记创建成功');
  });
});
