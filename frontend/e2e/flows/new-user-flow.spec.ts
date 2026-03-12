import { test, expect } from '@playwright/test';
import { TimelinePage, WritePage, SettingsPage } from '../helpers/page-objects';
import { register } from '../helpers/auth';

const testData = {
  username: `testuser_${Date.now()}`,
  password: 'TestPassword123!',
  firstEntryTitle: `First Diary Entry ${Date.now()}`,
};

test.describe('New User Flow', () => {
  test('should complete new user registration and create first diary entry', async ({ page }) => {
    const timelinePage = new TimelinePage(page);
    const writePage = new WritePage(page);
    const settingsPage = new SettingsPage(page);

    // Visit app (unauthenticated)
    await page.goto('/');

    // Verify login prompt banner is visible
    await expect(timelinePage.getLoginBanner()).toBeVisible();

    // Navigate to settings
    await page.getByText('Settings').or(page.getByText('设置')).click();
    await expect(settingsPage.getRegisterButton()).toBeVisible();

    // Register new account
    await register(page, testData.username, testData.password);
    
    // Verify auto-login after registration
    await expect(settingsPage.getUsernameDisplay(testData.username)).toBeVisible();

    // Navigate to write page to create first diary entry
    await page.getByText(/写日记|Write|日記を書く/).click();
    await expect(writePage.getTitleField()).toBeVisible();

    // Fill in diary entry details
    await writePage.getTitleField().fill(testData.firstEntryTitle);
    await writePage.getContentField().fill(`This is my first diary entry created at ${new Date().toISOString()}`);
    await writePage.getSaveButton().click();

    // Verify page navigates to timeline
    await expect(timelinePage.getTimelineContainer()).toBeVisible();
    
    // Verify entry appears in timeline
    await expect(page.getByText(testData.firstEntryTitle)).toBeVisible();
  });
});