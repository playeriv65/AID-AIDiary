import { Page } from '@playwright/test';

const TEST_USER = {
  username: process.env.TEST_USER_NAME || 'testuser',
  password: process.env.TEST_USER_PASSWORD || 'testpass123',
};

// Function to generate a unique username with timestamp
export async function register(page: Page, username: string, password: string) {
  const uniqueUsername = `${username}_${Date.now()}`;

  try {
    await page.goto('/auth/register'); // Or wherever the register page is
    await page.waitForLoadState('networkidle');

    // Multi-language placeholders for registration form
    const usernameInput = page
      .locator(
        'input[placeholder*="用户名"], input[placeholder*="Username"], input[placeholder*="ユーザーネーム"], input[name="username"]'
      )
      .first();
    const passwordInput = page
      .locator(
        'input[placeholder*="密码"], input[placeholder*="Password"], input[placeholder*="パスワード"], input[name="password"], input[type="password"]'
      )
      .first();

    await usernameInput.fill(uniqueUsername);
    await passwordInput.fill(password);

    // Multi-language register button text
    await page
      .locator(
        'button:has-text("注册"), button:has-text("Register"), button:has-text("登録"), button[type="submit"]'
      )
      .first()
      .click();

    // Wait for registration to complete
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    // Verify registration success - navigate to home or profile to confirm
    const userButton = page.locator('text=/^[A-Z]$/').first();
    const isLoggedIn = await userButton.isVisible({ timeout: 10000 });

    if (!isLoggedIn) {
      throw new Error(`Registration failed for user ${uniqueUsername}. Not logged in.`);
    }

    return uniqueUsername;
  } catch (error) {
    console.error(`Registration failed for user ${uniqueUsername}:`, error);
    throw error;
  }
}

// Logout function that handles multi-language logout buttons
export async function logout(page: Page) {
  try {
    // Navigate to a page where the user menu is visible
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    const userButton = page.locator('text=/^[A-Z]$/').first();

    // Click the user menu button to open the dropdown
    if (await userButton.isVisible()) {
      await userButton.click();

      // Multi-language logout buttons: 退出登录, Logout, ログアウト
      await page.getByRole('button', { name: /退出登录|Logout|ログアウト/ }).click();

      // Wait for logout to complete
      await page.waitForLoadState('networkidle');
      await page.waitForTimeout(2000);

      // Verify logout by checking that user button is gone or state has changed
      await page.waitForTimeout(1000);

      // Refresh the page to ensure logout state is applied
      await page.goto('/');
      await page.waitForLoadState('networkidle');

      return true;
    } else {
      // Already logged out
      return true;
    }
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

    const userButton = page.locator('text=/^[A-Z]$/').first();
    const isVisible = await userButton.isVisible({ timeout: 5000 });

    if (!isVisible) {
      // User is not authenticated, need to log in
      await performLogin(page);

      // Verify login was successful
      await page.waitForTimeout(2000);
      const isLoggedIn = await userButton.isVisible({ timeout: 10000 });

      if (!isLoggedIn) {
        throw new Error('Failed to authenticate user');
      }
    }
  } catch (error) {
    console.error('Authentication check failed:', error);
    throw error;
  }
}

// Navigates to the settings page with multi-language support
export async function navigateToSettings(page: Page) {
  try {
    // Go to base URL first
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    // Click user menu
    const userButton = page.locator('text=/^[A-Z]$/').first();
    await userButton.click();

    // Multi-language selector for settings menu item: 设置, Settings, 設定
    await page.getByText(/设置|Settings|設定/).click();

    // Wait for navigation to complete
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

  // Multi-language placeholders and selectors for login form
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

    // Multi-language login button: Chinese login, Login, ログイン
    await page.getByRole('button', { name: /登录|Login|ログイン/ }).click();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);
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

  const userButton = page.locator('text=/^[A-Z]$/').first();
  const isVisible = await userButton.isVisible().catch(() => false);

  if (isVisible) {
    await userButton.click();
    await page.waitForTimeout(500);

    const logoutButton = page.getByText(/退出登录|Logout|ログアウト/);
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
