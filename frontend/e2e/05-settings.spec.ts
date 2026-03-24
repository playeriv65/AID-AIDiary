import { expect, test } from '@playwright/test';
import { injectTestEnv, loginAndVerify } from './helpers/test-utils';

test.describe('设置流程', () => {
  test.use({ storageState: undefined });

  test.beforeEach(async ({ page, context }) => {
    await context.clearCookies();
    await injectTestEnv(page);
    await loginAndVerify(page);
  });

  test('设置页面显示外观选项 - 验证设置页面可访问', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    await page.getByText('设置').first().click();
    await page.waitForLoadState('networkidle');

    const appearanceText = page.getByText(/外观|Appearance|テーマ|主题|Theme/i).first();
    await expect(appearanceText).toBeVisible({ timeout: 10000 });
  });

  test('设置页面显示语言选项 - 验证语言相关内容存在', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    await page.getByText('设置').first().click();
    await page.waitForLoadState('networkidle');

    const languageText = page.getByText(/语言|Language|言語/i).first();
    await expect(languageText).toBeVisible({ timeout: 10000 });
  });

  test('设置页面显示账号区域 - 验证登出按钮存在', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    await page.getByText('设置').first().click();
    await page.waitForLoadState('networkidle');

    const accountText = page.getByText(/账号|Account|アカウント/i).first();
    await expect(accountText).toBeVisible({ timeout: 10000 });

    const logoutBtn = page.getByText(/退出登录|Logout|ログアウト/);
    await expect(logoutBtn).toBeVisible({ timeout: 10000 });
  });

  test('主题设置区域可见', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    await page.getByText('设置').first().click();
    await page.waitForLoadState('networkidle');

    const settingsContent = await page.locator('body').innerText();
    const hasSettings =
      settingsContent.includes('外观') ||
      settingsContent.includes('Appearance') ||
      settingsContent.includes('主题') ||
      settingsContent.includes('Theme');
    expect(hasSettings).toBe(true);
  });
});
