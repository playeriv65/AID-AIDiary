import { Page } from '@playwright/test';

const TEST_USER = {
  username: process.env.TEST_USER_NAME || 'testuser',
  password: process.env.TEST_USER_PASSWORD || 'testpass123',
};

export async function register(page: Page, username: string, password: string) {
  const uniqueUsername = `${username}_${Date.now()}`;

  await page.goto('/');
  await page.waitForLoadState('networkidle');

  await page.getByText('设置').click();

  const loginBtn = page.locator('text=/登录.*注册/');
  await loginBtn.waitFor({ state: 'visible', timeout: 5000 });
  await loginBtn.click();

  await page.getByText(/没有账号/).click();

  await page.getByPlaceholder(/用户名/).waitFor({ state: 'visible', timeout: 5000 });
  await page.getByPlaceholder(/用户名/).fill(uniqueUsername);
  await page.getByPlaceholder(/密码/).fill(password);

  await page.locator('text=注册').last().click();

  await page.locator('text=/退出登录|Logout/').waitFor({ timeout: 15000 });

  return uniqueUsername;
}

export async function logout(page: Page) {
  await page.goto('/');
  await page.waitForLoadState('networkidle');

  await page.getByText('设置').click();

  const logoutBtn = page.locator('text=/退出登录|Logout|ログアウト/');
  if (await logoutBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await logoutBtn.click();
    await page.waitForLoadState('networkidle');
  }

  return true;
}

export async function ensureAuthenticated(page: Page) {
  await page.goto('/');
  await page.waitForLoadState('networkidle');

  await page.getByText('设置').click();

  const loginBtn = page.locator('text=/登录.*注册/');
  const needsLogin = await loginBtn.isVisible({ timeout: 3000 }).catch(() => false);

  if (needsLogin) {
    await loginBtn.click();
    await performLogin(page);
    await page.locator('text=/退出登录|Logout/').waitFor({ timeout: 10000 });
  }
}

export async function navigateToSettings(page: Page) {
  await page.goto('/');
  await page.waitForLoadState('networkidle');
  await page.getByText('设置').click();
  return true;
}

export { TEST_USER };

// Internal login helper function
async function performLogin(page: Page) {
  const usernameInput = page
    .locator(
      'input[placeholder*="用户名"], input[placeholder*="Username"], input[placeholder*="ユーザーネーム"], input[name="username"]'
    )
    .first();
  await usernameInput.waitFor({ state: 'visible', timeout: 5000 });

  await usernameInput.fill(TEST_USER.username);
  await page
    .locator(
      'input[placeholder*="密码"], input[placeholder*="Password"], input[placeholder*="パスワード"], input[name="password"], input[type="password"]'
    )
    .first()
    .fill(TEST_USER.password);

  await page.getByRole('button', { name: /登录|Login|ログイン/ }).click();
  // Wait for login to complete - network becomes idle after auth
  await page.waitForLoadState('networkidle');
}

export async function navigateToChat(page: Page) {
  await page.goto('/chat');
  await page.waitForLoadState('networkidle');
}

export async function deleteAllConversations(page: Page) {
  await page
    .locator('button')
    .filter({ has: page.locator('svg') })
    .first()
    .click();

  while (true) {
    const deleteButton = page
      .locator('button')
      .filter({ has: page.locator('svg') })
      .nth(1);
    const isVisible = await deleteButton.isVisible({ timeout: 500 }).catch(() => false);

    if (!isVisible) break;

    page.once('dialog', (dialog) => dialog.accept());
    await deleteButton.click();
    await page.waitForLoadState('networkidle');
  }

  await page.keyboard.press('Escape');
}

export async function login(page: Page) {
  await page.goto('/');
  await page.waitForLoadState('networkidle');

  await page.getByText('设置').click();

  const loginBtn = page.getByText(/登录.*注册/);
  const needsLogin = await loginBtn.isVisible({ timeout: 3000 }).catch(() => false);

  if (needsLogin) {
    await loginBtn.click();
    await performLogin(page);

    await page.locator('text=/退出登录|Logout/').waitFor({ timeout: 30000 });
  }
}
