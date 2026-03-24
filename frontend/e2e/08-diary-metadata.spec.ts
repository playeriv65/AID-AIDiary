import { expect, test } from '@playwright/test';

test.describe('日记元数据功能', () => {
  test.use({ storageState: undefined });

  async function ensureLoggedIn(page: import('@playwright/test').Page) {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    const avatar = page
      .locator('div')
      .filter({ hasText: /^[A-Z]$/ })
      .first();
    const isLoggedIn = await avatar.isVisible({ timeout: 3000 }).catch(() => false);

    if (!isLoggedIn) {
      await page.getByText('设置').click();

      const loginBtn = page.getByText(/登录.*注册/);
      if (await loginBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
        await loginBtn.click();

        await page.getByPlaceholder(/用户名/).waitFor({ state: 'visible', timeout: 5000 });
        await page.getByPlaceholder(/用户名/).fill('testuser');
        await page.getByPlaceholder(/密码/).fill('testpass123');
        await page.locator('text=登录').last().click();
        await page.waitForLoadState('networkidle');
      }
    }
  }

  test('新建日记页面显示分类选项', async ({ page }) => {
    await ensureLoggedIn(page);

    await page.getByText('时间线').click();
    await page.waitForLoadState('networkidle');
    await page.getByText('新建').click();
    await page.waitForLoadState('networkidle');

    await expect(page.getByText(/设置分类|分类/)).toBeVisible({ timeout: 10000 });
  });

  test('新建日记页面显示天气选项', async ({ page }) => {
    await ensureLoggedIn(page);

    await page.getByText('时间线').click();
    await page.waitForLoadState('networkidle');
    await page.getByText('新建').click();
    await page.waitForLoadState('networkidle');

    await expect(page.getByText(/选择天气|天气/)).toBeVisible({ timeout: 10000 });
  });

  test('新建日记页面显示标题和内容输入框', async ({ page }) => {
    await ensureLoggedIn(page);

    await page.getByText('时间线').click();
    await page.waitForLoadState('networkidle');
    await page.getByText('新建').click();
    await page.waitForLoadState('networkidle');

    await expect(page.getByPlaceholder(/标题/)).toBeVisible({ timeout: 10000 });
    await expect(page.getByPlaceholder(/记录今日/)).toBeVisible({ timeout: 10000 });
  });
});
