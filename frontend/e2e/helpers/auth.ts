import { Page } from '@playwright/test';

const TEST_USER = {
  username: process.env.TEST_USER_NAME || 'playeriv65',
  password: process.env.TEST_USER_PASSWORD || 'password123',
};

export async function login(page: Page) {
  await page.goto('/');

  const userButton = page.locator('text=/^[A-Z]$/').first();
  const isVisible = await userButton.isVisible().catch(() => false);

  if (isVisible) {
    await userButton.click();
    await page.waitForTimeout(500);

    const logoutButton = page.locator('text=退出登录');
    const isLoggedOut = !(await logoutButton.isVisible().catch(() => false));

    if (isLoggedOut) {
      await page.goto('/');
      await page.waitForTimeout(1000);
      await performLogin(page);
    } else {
      await page.goto('/');
    }
  } else {
    await performLogin(page);
  }
}

async function performLogin(page: Page) {
  await page.waitForTimeout(1000);

  const usernameInput = page
    .locator('input[placeholder*="用户名"], input[name="username"]')
    .first();
  const hasLoginForm = await usernameInput.isVisible().catch(() => false);

  if (hasLoginForm) {
    await usernameInput.fill(TEST_USER.username);
    await page
      .locator('input[placeholder*="密码"], input[name="password"], input[type="password"]')
      .first()
      .fill(TEST_USER.password);
    await page.locator('button:has-text("登录"), button[type="submit"]').first().click();
    await page.waitForTimeout(2000);
  }
}

export async function navigateToChat(page: Page) {
  await page.goto('/chat');
  await page.waitForTimeout(3000);
}

export async function deleteAllConversations(page: Page) {
  await page.getByTestId('phosphor-react-native-list-dashes-regular').click();
  await page.waitForTimeout(500);

  while (true) {
    const deleteButton = page.getByTestId('phosphor-react-native-trash-regular').first();
    const isVisible = await deleteButton.isVisible().catch(() => false);

    if (!isVisible) break;

    await deleteButton.click();
    await page.waitForTimeout(300);
    page.on('dialog', (dialog) => dialog.accept());
    const dialog = await page.waitForEvent('dialog', { timeout: 2000 }).catch(() => null);
    if (dialog) await dialog.accept();
    await page.waitForTimeout(1000);
  }

  await page.keyboard.press('Escape');
  await page.waitForTimeout(500);
}
