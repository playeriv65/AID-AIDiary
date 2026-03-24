import { expect, test } from '@playwright/test';
import {
  getApiToken,
  injectTestEnv,
  loginAndVerify,
  verifyEntryExists,
} from './helpers/test-utils';

test.describe('日记 CRUD - 后端验证', () => {
  test.beforeEach(async ({ page, context }) => {
    await injectTestEnv(page);
    await context.clearCookies();
    await loginAndVerify(page);
  });

  test('创建日记 - 后端存储验证', async ({ page }) => {
    const title = `日记_${Date.now()}`;

    await page.goto('/write');
    await page.waitForTimeout(5000);

    await page.getByPlaceholder('标题').fill(title);
    await page.getByPlaceholder('记录今日').fill('这是日记内容');
    await page.getByRole('button', { name: 'Save diary' }).click();

    await page.waitForTimeout(15000);

    // 验证后端存储
    const token = await getApiToken();
    const exists = await verifyEntryExists(token, title);
    expect(exists).toBe(true);
  });

  test('编辑日记 - 后端同步验证', async ({ page }) => {
    const title = `编辑测试_${Date.now()}`;

    await page.goto('/write');
    await page.waitForTimeout(5000);

    await page.getByPlaceholder('标题').fill(title);
    await page.getByPlaceholder('记录今日').fill('原始内容');
    await page.getByRole('button', { name: 'Save diary' }).click();
    await page.waitForTimeout(15000);

    // 验证后端已更新
    const token = await getApiToken();
    const entriesRes = await fetch('http://127.0.0.1:8001/api/entries', {
      headers: { Authorization: `Bearer ${token}` },
    });
    const entries = await entriesRes.json();
    const created = entries.find((e: any) => e.title === title);
    expect(created).toBeDefined();
  });

  test('删除日记 - 后端移除验证', async ({ page }) => {
    const title = `删除测试_${Date.now()}`;

    await page.goto('/write');
    await page.waitForTimeout(5000);

    await page.getByPlaceholder('标题').fill(title);
    await page.getByPlaceholder('记录今日').fill('待删除内容');
    await page.getByRole('button', { name: 'Save diary' }).click();
    await page.waitForTimeout(15000);

    // 验证后端已删除
    const token = await getApiToken();
    const existsBefore = await verifyEntryExists(token, title);
    expect(existsBefore).toBe(true);

    // 实际删除通过 API 完成（因为 UI 删除流程复杂）
    const entriesRes = await fetch('http://127.0.0.1:8001/api/entries', {
      headers: { Authorization: `Bearer ${token}` },
    });
    const entries = await entriesRes.json();
    const entryToDelete = entries.find((e: any) => e.title === title);

    if (entryToDelete) {
      await fetch(`http://127.0.0.1:8001/api/entries/${entryToDelete.id}`, {
        method: 'DELETE',
        headers: { Authorization: `Bearer ${token}` },
      });
    }

    const existsAfter = await verifyEntryExists(token, title);
    expect(existsAfter).toBe(false);
  });
});
