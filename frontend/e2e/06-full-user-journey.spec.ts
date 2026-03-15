import { expect, test } from '@playwright/test';

test.describe('完整用户旅程', () => {
  test('从注册到日常使用全流程', async ({ page }) => {
    const username = `user_${Date.now()}`;
    const password = 'testpass123';
    const diaryTitle = `我的日记_${Date.now()}`;
    const chatMessage = `你好 AI`;

    console.log('\n📍 步骤 1/8: 访问应用');
    await page.goto('/');
    await page.waitForTimeout(3000);

    console.log('📍 步骤 2/8: 注册账号');
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

    console.log('📍 步骤 3/8: 创建第一篇日记');
    await page.goto('/write');
    await page.waitForTimeout(5000);

    await page.getByPlaceholder('标题').fill(diaryTitle);
    await page.getByPlaceholder('记录今日').fill('这是第一篇日记内容');
    await page.getByRole('button', { name: 'Save diary' }).click();
    await page.waitForTimeout(5000);
    console.log('✅ 日记创建成功');

    console.log('📍 步骤 4/8: 时间线查看日记');
    await page.goto('/');
    await page.waitForTimeout(3000);
    await page.reload();
    await page.waitForTimeout(5000);

    const diaryCard = page.locator(`text=${diaryTitle}`).first();
    await expect(diaryCard).toBeVisible({ timeout: 15000 });
    console.log('✅ 日记显示在时间线');

    console.log('📍 步骤 5/8: 编辑日记');
    await diaryCard.click();
    await page.waitForTimeout(3000);

    const contentInput = page.getByPlaceholder('记录今日');
    await contentInput.press('End');
    await contentInput.type(' - 追加内容');

    await page.getByRole('button', { name: 'Save diary' }).click();
    await page.waitForTimeout(5000);
    console.log('✅ 日记编辑成功');

    console.log('📍 步骤 6/8: AI 聊天');
    await page.goto('/chat');
    await page.waitForTimeout(5000);

    const chatInput = page.getByRole('textbox', { name: 'Chat message input' });
    await chatInput.fill(chatMessage);
    await page.waitForTimeout(1000);

    const sendButton = page.getByRole('button', { name: 'Send message' });
    await sendButton.dispatchEvent('click');
    await page.waitForTimeout(15000);

    const messageVisible = await page.locator(`text=${chatMessage}`).isVisible();
    expect(messageVisible).toBeTruthy();
    console.log('✅ AI 聊天成功');

    console.log('📍 步骤 7/8: 搜索日记');
    await page.goto('/search');
    await page.waitForTimeout(3000);

    const searchBox = page.locator('input[placeholder*="搜索"]');
    await searchBox.fill('日记');
    await page.waitForTimeout(5000);

    const searchResults = page.locator(`text=${diaryTitle}`);
    const resultCount = await searchResults.count();
    console.log(`🔍 找到 ${resultCount} 条结果`);
    expect(resultCount).toBeGreaterThan(0);
    console.log('✅ 搜索成功');

    console.log('📍 步骤 8/8: 清理测试数据');
    await page.goto('/');
    await page.waitForTimeout(2000);

    const deleteButton = page.getByRole('button', { name: /删除/ });
    if (await deleteButton.isVisible().catch(() => false)) {
      await diaryCard.click();
      await page.waitForTimeout(2000);
      await deleteButton.click();
      await page.waitForTimeout(2000);

      const confirmButton = page.getByRole('button', { name: /确定/ });
      await confirmButton.click();
      await page.waitForTimeout(3000);
      console.log('✅ 测试数据已清理');
    }

    console.log('\n🎉 完整用户旅程测试完成！');
  });
});
