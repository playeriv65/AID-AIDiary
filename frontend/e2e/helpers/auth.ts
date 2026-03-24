import { Page } from '@playwright/test';

const TEST_USER = {
  username: process.env.TEST_USER_NAME || 'testuser',
  password: process.env.TEST_USER_PASSWORD || 'testpass123',
};

// Function to generate a unique username with timestamp
export async function register(page: Page, username: string, password: string) {
  const uniqueUsername = `${username}_${Date.now()}`;

  try {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    await page.getByText('设置').click();
    await page.waitForTimeout(2000);

    const loginBtn = page.getByText(/登录.*注册/);
    await loginBtn.click();
    await page.waitForTimeout(2000);

    await page.getByText(/没有账号/).click();
    await page.waitForTimeout(1000);

    await page.getByPlaceholder(/用户名/).fill(uniqueUsername);
    await page.getByPlaceholder(/密码/).fill(password);

    await page.locator('text=注册').last().click();
    await page.waitForTimeout(5000);

    await page.locator('text=/退出登录|Logout/').waitFor({ timeout: 15000 });

    return uniqueUsername;
  } catch (error) {
    console.error(`Registration failed for user ${uniqueUsername}:`, error);
    throw error;
  }
}

// Logout function that handles multi-language logout buttons
export async function logout(page: Page) {
  try {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    await page.getByText('设置').click();
    await page.waitForTimeout(2000);

    const logoutBtn = page.getByText(/退出登录|Logout|ログアウト/);
    if (await logoutBtn.isVisible()) {
      await logoutBtn.click();
      await page.waitForLoadState('networkidle');
      await page.waitForTimeout(2000);
    }

    return true;
  } catch (error) {
    console.error('Logout failed:', error);
    throw error;
  }
}

// Checks if user is authenticated and logs in if needed
export async function ensureAuthenticated(page: Page) {
  try {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    await page.getByText('设置').click();
    await page.waitForTimeout(2000);

    const loginBtn = page.getByText(/登录.*注册/);
    const needsLogin = await loginBtn.isVisible().catch(() => false);

    if (needsLogin) {
      await loginBtn.click();
      await page.waitForTimeout(2000);
      await performLogin(page);

      await page.locator('text=/退出登录|Logout/').waitFor({ timeout: 30000 });
    }
  } catch (error) {
    console.error('Authentication check failed:', error);
    throw error;
  }
}

// Navigates to the settings page with multi-language support
export async function navigateToSettings(page: Page) {
  try {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    await page.getByText('设置').click();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(1000);

    return true;
  } catch (error) {
    console.error('Navigation to settings failed:', error);
    throw error;
  }
}

export { TEST_USER };

// Internal login helper function
async function performLogin(page: Page) {
  await page.waitForTimeout(1000);

  const usernameInput = page
    .locator(
      'input[placeholder*="用户名"], input[placeholder*="Username"], input[placeholder*="ユーザーネーム"], input[name="username"]'
    )
    .first();
  const hasLoginForm = await usernameInput.isVisible().catch(() => false);

  if (hasLoginForm) {
    await usernameInput.fill(TEST_USER.username);
    await page
      .locator(
        'input[placeholder*="密码"], input[placeholder*="Password"], input[placeholder*="パスワード"], input[name="password"], input[type="password"]'
      )
      .first()
      .fill(TEST_USER.password);

    await page.getByRole('button', { name: /登录|Login|ログイン/ }).click();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(3000);
  }
}

export async function navigateToChat(page: Page) {
  await page.goto('/chat');
  await page.waitForTimeout(3000);
}

export async function deleteAllConversations(page: Page) {
  await page
    .locator('button')
    .filter({ has: page.locator('svg') })
    .first()
    .click();
  await page.waitForTimeout(500);

  while (true) {
    const deleteButton = page
      .locator('button')
      .filter({ has: page.locator('svg') })
      .nth(1);
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

export async function login(page: Page) {
  await page.goto('/');
  await page.waitForLoadState('networkidle');
  await page.waitForTimeout(2000);

  await page.getByText('设置').click();
  await page.waitForTimeout(2000);

  const loginBtn = page.getByText(/登录.*注册/);
  const needsLogin = await loginBtn.isVisible().catch(() => false);

  if (needsLogin) {
    await loginBtn.click();
    await page.waitForTimeout(2000);
    await performLogin(page);

    await page.locator('text=/退出登录|Logout/').waitFor({ timeout: 30000 });
  }
}
