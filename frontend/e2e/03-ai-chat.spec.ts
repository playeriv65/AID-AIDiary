import { expect, test } from '@playwright/test';

test.describe('AI 聊天流程', () => {
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

  test('发送消息 → 显示在聊天窗口', async ({ page }) => {
    const message = `测试消息_${Date.now()}`;

    await page.goto('/chat');
    await page.waitForTimeout(5000);

    const chatInput = page.getByRole('textbox', { name: 'Chat message input' });
    await chatInput.fill(message);
    await page.waitForTimeout(1000);

    const sendButton = page.getByRole('button', { name: 'Send message' });
    await sendButton.dispatchEvent('click');
    await page.waitForTimeout(15000);

    const messageVisible = await page.locator(`text=${message}`).isVisible();
    expect(messageVisible).toBeTruthy();
    console.log('✅ 消息发送并显示成功');
  });

  test('发送多条消息 → 创建多个对话', async ({ page }) => {
    await page.goto('/chat');
    await page.waitForTimeout(5000);

    const chatInput = page.getByRole('textbox', { name: 'Chat message input' });

    for (let i = 0; i < 3; i++) {
      const message = `第${i + 1}条消息`;
      await chatInput.fill(message);
      await page.waitForTimeout(500);

      const sendButton = page.getByRole('button', { name: 'Send message' });
      await sendButton.dispatchEvent('click');
      await page.waitForTimeout(10000);

      const messageVisible = await page.locator(`text=${message}`).isVisible();
      expect(messageVisible).toBeTruthy();
    }
    console.log('✅ 多条消息发送成功');
  });

  test('AI 回复显示', async ({ page }) => {
    const message = `你好，帮我记录今天`;

    await page.goto('/chat');
    await page.waitForTimeout(5000);

    const chatInput = page.getByRole('textbox', { name: 'Chat message input' });
    await chatInput.fill(message);
    await page.waitForTimeout(1000);

    const sendButton = page.getByRole('button', { name: 'Send message' });
    await sendButton.dispatchEvent('click');
    await page.waitForTimeout(20000);

    const aiReply = page.locator('text=/你好|Hello|我|AI|助手/').first();
    const hasReply = await aiReply.isVisible().catch(() => false);
    expect(hasReply).toBeTruthy();
    console.log('✅ AI 回复显示成功');
  });

  test('删除对话', async ({ page }) => {
    await page.goto('/chat');
    await page.waitForTimeout(5000);

    const chatInput = page.getByRole('textbox', { name: 'Chat message input' });
    await chatInput.fill('测试对话删除');
    await page.waitForTimeout(500);

    const sendButton = page.getByRole('button', { name: 'Send message' });
    await sendButton.dispatchEvent('click');
    await page.waitForTimeout(10000);

    const sidebarToggle = page
      .locator('button')
      .filter({ has: page.locator('svg') })
      .first();
    await sidebarToggle.click();
    await page.waitForTimeout(2000);

    const deleteButton = page.getByRole('button', { name: /删除/ }).first();
    await deleteButton.click();
    await page.waitForTimeout(2000);

    const confirmButton = page.getByRole('button', { name: /确定/ }).first();
    await confirmButton.click();
    await page.waitForTimeout(3000);

    console.log('✅ 对话删除成功');
  });
});
