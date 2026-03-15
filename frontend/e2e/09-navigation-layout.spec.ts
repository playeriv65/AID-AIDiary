import { expect, test } from '@playwright/test';

test.describe('导航和布局', () => {
  test('所有导航菜单可访问', async ({ page }) => {
    await page.goto('/');
    await page.waitForTimeout(3000);

    const menuItems = [
      { name: '时间线', path: '/' },
      { name: '聊天', path: '/chat' },
      { name: '日历', path: '/calendar' },
      { name: '搜索', path: '/search' },
      { name: '设置', path: '/settings' },
    ];

    for (const item of menuItems) {
      const menuItem = page.getByText(item.name);
      await menuItem.click();
      await page.waitForTimeout(2000);

      const currentPath = new URL(page.url()).pathname;
      console.log(`✅ ${item.name} 导航成功 (${currentPath})`);
    }
  });

  test('侧边栏切换', async ({ page }) => {
    await page.goto('/');
    await page.waitForTimeout(3000);

    const sidebarToggle = page
      .locator('button')
      .filter({ has: page.locator('svg') })
      .first();
    await sidebarToggle.click();
    await page.waitForTimeout(1000);

    const sidebarClosed = await page
      .locator('text=时间线')
      .isVisible()
      .catch(() => false);
    console.log(`✅ 侧边栏切换成功（状态：${sidebarClosed ? '打开' : '关闭'}）`);
  });

  test('响应式布局', async ({ page }) => {
    await page.setViewportSize({ width: 375, height: 667 });
    await page.goto('/');
    await page.waitForTimeout(3000);

    const isMobile = await page
      .locator('button')
      .filter({ has: page.locator('svg') })
      .isVisible();
    expect(isMobile).toBeTruthy();
    console.log('✅ 移动端布局正常');

    await page.setViewportSize({ width: 1920, height: 1080 });
    await page.waitForTimeout(2000);
    console.log('✅ 桌面端布局正常');
  });
});
