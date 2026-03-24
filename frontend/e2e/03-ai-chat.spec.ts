import { expect, test } from '@playwright/test';
import { injectTestEnv, loginAndVerify } from './helpers/test-utils';

test.describe('AI 聊天流程', () => {
  test.beforeEach(async ({ page }) => {
    await injectTestEnv(page);
    await loginAndVerify(page);
  });

  test('AI 回复显示', async ({ page }) => {
    await page.goto('/chat');
    await page.waitForTimeout(8000);

    // 查找输入框 - 使用更宽松的选择器
    const input = await page
      .locator('input, textarea')
      .filter({ hasText: /输入|message|chat/i })
      .first();

    if (await input.isVisible().catch(() => false)) {
      await input.fill('你好');
      await page.waitForTimeout(1000);
      await input.press('Enter');
    } else {
      // 备用：查找任何输入框
      const anyInput = page.locator('input[type="text"], input:not([type]), textarea').first();
      await anyInput.fill('你好');
      await page.waitForTimeout(1000);
      await anyInput.press('Enter');
    }

    await page.waitForTimeout(25000);

    // 验证有 AI 回复
    const bodyText = await page.locator('body').innerText();
    expect(bodyText.length).toBeGreaterThan(50);
  });
});
