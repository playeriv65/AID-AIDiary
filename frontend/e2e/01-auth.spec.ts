import { expect, test } from '@playwright/test';
import { clearAuthState, injectTestEnv } from './helpers/test-utils';

test.describe('认证流程', () => {
  test.use({ storageState: undefined });

  test('已有用户登录 - 登录成功后显示用户头像', async ({ page, context }) => {
    await context.clearCookies();
    await injectTestEnv(page);

    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    await clearAuthState(page);
    await page.reload();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    await page.getByText('设置').click();
    await page.waitForTimeout(2000);

    const loginBtn = page.getByText(/登录.*注册/);
    await loginBtn.click();
    await page.waitForTimeout(2000);

    await page.getByPlaceholder(/用户名/).fill('testuser');
    await page.getByPlaceholder(/密码/).fill('testpass123');
    await page.locator('text=登录').last().click();
    await page.waitForTimeout(5000);

    await expect(page.locator('text=/退出登录|Logout/')).toBeVisible({ timeout: 15000 });
  });

  test('登出 - 登出后显示登录按钮', async ({ page, context }) => {
    await context.clearCookies();
    await injectTestEnv(page);

    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    await clearAuthState(page);
    await page.reload();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    await page.getByText('设置').click();
    await page.waitForTimeout(2000);

    const loginBtn = page.getByText(/登录.*注册/);
    await loginBtn.click();
    await page.waitForTimeout(2000);

    await page.getByPlaceholder(/用户名/).fill('testuser');
    await page.getByPlaceholder(/密码/).fill('testpass123');
    await page.locator('text=登录').last().click();
    await page.waitForTimeout(5000);

    const logoutBtn = page.getByText(/退出登录/);
    await expect(logoutBtn).toBeVisible({ timeout: 15000 });
    await logoutBtn.click();
    await page.waitForTimeout(3000);

    await expect(page.getByText(/登录.*注册/)).toBeVisible({ timeout: 10000 });
  });
});
