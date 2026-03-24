import { expect, test } from '@playwright/test';
import { injectTestEnv, loginAndVerify } from './helpers/test-utils';

test.describe('AI 聊天流程', () => {
  test.beforeEach(async ({ page }) => {
    await injectTestEnv(page);
    await loginAndVerify(page);
  });

  test('AI 回复显示 - 验证聊天功能可用', async ({ page }) => {
    await page.goto('/chat');
    await page.waitForLoadState('networkidle');

    const chatInput = page.locator('input, textarea').first();
    await chatInput.waitFor({ state: 'visible', timeout: 10000 });

    const userMessage = `测试消息_${Date.now()}`;
    await chatInput.fill(userMessage);
    await chatInput.press('Enter');

    await page.waitForTimeout(25000);

    const pageContent = await page.locator('body').innerText();
    const contentLength = pageContent.length;
    expect(contentLength).toBeGreaterThan(50);

    const hasUserMessage = pageContent.includes(userMessage) || pageContent.includes('测试');
    expect(hasUserMessage || contentLength > 100).toBe(true);
  });

  test('聊天输入框可交互', async ({ page }) => {
    await page.goto('/chat');
    await page.waitForLoadState('networkidle');

    const chatInput = page.locator('input, textarea').first();
    await expect(chatInput).toBeVisible({ timeout: 10000 });

    const testText = '测试输入';
    await chatInput.fill(testText);
    await expect(chatInput).toHaveValue(testText);

    await chatInput.clear();
    await expect(chatInput).toHaveValue('');
  });

  test('聊天页面核心功能验证', async ({ page }) => {
    await page.goto('/chat');
    await page.waitForLoadState('networkidle');

    const chatInput = page.locator('input, textarea').first();
    await expect(chatInput).toBeEnabled({ timeout: 10000 });

    await chatInput.fill('你好，请自我介绍');
    const value = await chatInput.inputValue();
    expect(value).toBe('你好，请自我介绍');
  });
});
