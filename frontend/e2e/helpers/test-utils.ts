import { Page, expect } from '@playwright/test';

const TEST_API_URL = 'http://127.0.0.1:8001/api';
const TEST_USER = 'testuser';
const TEST_PASS = 'testpass123';

export async function getApiToken(
  username: string = TEST_USER,
  password: string = TEST_PASS
): Promise<string> {
  const response = await fetch(`${TEST_API_URL.replace('/api', '')}/api/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ username, password }),
  });

  if (!response.ok) {
    throw new Error(`登录失败：${response.status}`);
  }

  const data = await response.json();
  return data.access_token;
}

export async function verifyEntryExists(token: string, title: string): Promise<boolean> {
  const response = await fetch(`${TEST_API_URL}/entries`, {
    headers: { Authorization: `Bearer ${token}` },
  });

  if (!response.ok) {
    throw new Error(`获取日记失败：${response.status}`);
  }

  const entries = await response.json();
  return entries.some((e: any) => e.title === title);
}

export async function getEntryCount(token: string): Promise<number> {
  const response = await fetch(`${TEST_API_URL}/entries`, {
    headers: { Authorization: `Bearer ${token}` },
  });

  const entries = await response.json();
  return entries.length;
}

export async function injectTestEnv(page: Page): Promise<void> {
  await page.addInitScript(() => {
    window.__EXPO_PUBLIC_ENV__ = 'test';
    (window as any).__PLAYWRIGHT_TEST__ = true;
  });
}

export async function clearAuthState(page: Page): Promise<void> {
  await page.evaluate(() => {
    localStorage.clear();
    sessionStorage.clear();
  });

  await page.evaluate(() => {
    return new Promise<void>((resolve) => {
      const request = indexedDB.deleteDatabase('AIDiaryDB');
      request.onsuccess = () => resolve();
      request.onerror = () => resolve();
      request.onblocked = () => resolve();
    });
  });
}

export async function loginViaUI(
  page: Page,
  username: string = TEST_USER,
  password: string = TEST_PASS
): Promise<void> {
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
  const needsLogin = await loginBtn.isVisible().catch(() => false);

  if (needsLogin) {
    await loginBtn.click();
    await page.waitForTimeout(2000);

    await page.getByPlaceholder(/用户名/).fill(username);
    await page.getByPlaceholder(/密码/).fill(password);

    await page.locator('text=登录').last().click();
    await page.waitForTimeout(5000);

    await expect(page.locator('text=/退出登录|Logout/')).toBeVisible({ timeout: 30000 });
    await page.waitForTimeout(3000);
  }
}

export async function loginAndVerify(
  page: Page,
  username: string = TEST_USER,
  password: string = TEST_PASS
): Promise<void> {
  await loginViaUI(page, username, password);
}

export async function cleanupTestEntries(token: string, titlePattern: string): Promise<number> {
  const response = await fetch(`${TEST_API_URL}/entries`, {
    headers: { Authorization: `Bearer ${token}` },
  });

  const entries = await response.json();
  let deleted = 0;

  for (const entry of entries) {
    if (entry.title?.includes(titlePattern)) {
      await fetch(`${TEST_API_URL}/entries/${entry.id}`, {
        method: 'DELETE',
        headers: { Authorization: `Bearer ${token}` },
      });
      deleted++;
    }
  }

  return deleted;
}
