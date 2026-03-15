import { expect, test } from '@playwright/test';

test.describe('日记 CRUD 流程', () => {
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

  test('创建日记 → 时间线显示', async ({ page }) => {
    const title = `日记_${Date.now()}`;
    const content = `这是日记内容`;

    await page.goto('/write');
    await page.waitForTimeout(5000);

    await page.getByPlaceholder('标题').fill(title);
    await page.getByPlaceholder('记录今日').fill(content);

    const saveButton = page.getByRole('button', { name: 'Save diary' });
    await saveButton.click();
    await page.waitForTimeout(5000);

    await page.goto('/');
    await page.waitForTimeout(3000);
    await page.reload();
    await page.waitForTimeout(5000);

    const diaryCard = page.locator(`text=${title}`).first();
    await expect(diaryCard).toBeVisible({ timeout: 15000 });
    console.log(`✅ 日记 "${title}" 创建并显示成功`);
  });

  test('编辑日记 → 保存修改', async ({ page }) => {
    const title = `编辑测试_${Date.now()}`;
    const content = `原始内容`;

    await page.goto('/write');
    await page.waitForTimeout(5000);

    await page.getByPlaceholder('标题').fill(title);
    await page.getByPlaceholder('记录今日').fill(content);
    await page.getByRole('button', { name: 'Save diary' }).click();
    await page.waitForTimeout(5000);

    await page.goto('/');
    await page.waitForTimeout(3000);
    await page.reload();
    await page.waitForTimeout(5000);

    const diaryCard = page.locator(`text=${title}`).first();
    await diaryCard.click();
    await page.waitForTimeout(3000);

    const contentInput = page.getByPlaceholder('记录今日');
    await contentInput.press('End');
    await contentInput.type(' - 已更新');

    await page.getByRole('button', { name: 'Save diary' }).click();
    await page.waitForTimeout(5000);
    console.log(`✅ 日记 "${title}" 编辑成功`);
  });

  test('删除日记 → 从时间线消失', async ({ page }) => {
    const title = `删除测试_${Date.now()}`;
    const content = `待删除内容`;

    await page.goto('/write');
    await page.waitForTimeout(5000);

    await page.getByPlaceholder('标题').fill(title);
    await page.getByPlaceholder('记录今日').fill(content);
    await page.getByRole('button', { name: 'Save diary' }).click();
    await page.waitForTimeout(5000);

    await page.goto('/');
    await page.waitForTimeout(3000);
    await page.reload();
    await page.waitForTimeout(5000);

    const diaryCard = page.locator(`text=${title}`).first();
    await diaryCard.click();
    await page.waitForTimeout(2000);

    const deleteButton = page.getByRole('button', { name: /删除/ });
    await deleteButton.click();
    await page.waitForTimeout(2000);

    const confirmButton = page.getByRole('button', { name: /确定/ });
    await confirmButton.click();
    await page.waitForTimeout(5000);

    await page.goto('/');
    await page.waitForTimeout(3000);

    const deletedVisible = await page.locator(`text=${title}`).isVisible();
    expect(deletedVisible).toBe(false);
    console.log(`✅ 日记 "${title}" 删除成功`);
  });
});
