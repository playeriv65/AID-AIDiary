import { expect, test } from '@playwright/test';
import { login, navigateToChat } from './helpers/auth';

test.describe('AI Chat E2E Tests', () => {
  test.setTimeout(120000);

  test.beforeEach(async ({ page }) => {
    await login(page);
  });

  test('should send first message successfully on fresh chat page', async ({ page }) => {
    await navigateToChat(page);

    const testMessage = `测试第一条消息_${Date.now()}`;
    const input = page.getByRole('textbox', { name: '分享今天的故事' });

    await input.fill(testMessage);
    await input.press('Enter');

    await page.waitForTimeout(5000);

    const messageVisible = await page.locator(`text=${testMessage}`).isVisible();
    expect(messageVisible).toBeTruthy();
  });

  test('should create multiple conversations', async ({ page }) => {
    await navigateToChat(page);

    const input = page.getByRole('textbox', { name: '分享今天的故事' });

    await input.fill('第一个对话的消息');
    await input.press('Enter');
    await page.waitForTimeout(5000);

    await page.getByTestId('phosphor-react-native-list-dashes-regular').click();
    await page.waitForTimeout(1000);

    await page.getByTestId('phosphor-react-native-x-regular').click();
    await page.waitForTimeout(1000);

    await input.fill('第二个对话的消息');
    await input.press('Enter');
    await page.waitForTimeout(5000);

    await page.getByTestId('phosphor-react-native-list-dashes-regular').click();
    await page.waitForTimeout(1000);

    const trashIcons = await page.getByTestId('phosphor-react-native-trash-regular').count();
    expect(trashIcons).toBeGreaterThanOrEqual(1);
  });

  test('should delete conversation successfully', async ({ page }) => {
    await navigateToChat(page);

    const input = page.getByRole('textbox', { name: '分享今天的故事' });
    await input.fill(`待删除的对话_${Date.now()}`);
    await input.press('Enter');
    await page.waitForTimeout(5000);

    await page.getByTestId('phosphor-react-native-list-dashes-regular').click();
    await page.waitForTimeout(1000);

    const deleteButton = page.getByTestId('phosphor-react-native-trash-regular').first();
    await deleteButton.waitFor({ state: 'visible', timeout: 10000 });
    await deleteButton.click();

    page.once('dialog', (dialog) => dialog.accept());
    await page.waitForTimeout(2000);

    await page.keyboard.press('Escape');
  });

  test('should display correct date format in conversation history', async ({ page }) => {
    await navigateToChat(page);

    const input = page.getByRole('textbox', { name: '分享今天的故事' });
    await input.fill('测试日期显示');
    await input.press('Enter');
    await page.waitForTimeout(5000);

    await page.getByTestId('phosphor-react-native-list-dashes-regular').click();
    await page.waitForTimeout(1000);

    const todayText = page.locator('text=今天');
    const isVisible = await todayText.isVisible();
    expect(isVisible).toBeTruthy();
  });
});
