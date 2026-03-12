import { test, expect } from '@playwright/test';
import { TimelinePage, SearchPage, WritePage } from '../helpers/page-objects';
import { login } from '../helpers/auth';

const testData = {
  username: `testuser_${Date.now()}`,
  password: 'TestPassword123!',
  entryWithKeyword: `Search test entry ${Date.now()} with important keyword`,
  searchKeyword: `important`,
  updatedEntry: `Updated search test entry at ${Date.now()}`,
};

test.describe('Search and Edit Flow', () => {
  test('should search for entries and edit content', async ({ page }) => {
    const timelinePage = new TimelinePage(page);
    const searchPage = new SearchPage(page);
    const writePage = new WritePage(page);

    // Create multiple diary entries with different topics, including one with the search keyword
    await login(page, testData.username, testData.password);
    
    // Create first entry
    await page.getByText(/写日记|Write|日記を書く/).click();
    await expect(writePage.getTitleField()).toBeVisible();
    await writePage.getTitleField().fill('First search test entry');
    await writePage.getContentField().fill('This is about daily activities');
    await writePage.getSaveButton().click();
    await expect(timelinePage.getTimelineContainer()).toBeVisible();
    
    // Create second entry with our keyword
    await page.getByText(/写日记|Write|日記を書く/).click();
    await expect(writePage.getTitleField()).toBeVisible();
    await writePage.getTitleField().fill('Entry containing keyword');
    await writePage.getContentField().fill(testData.entryWithKeyword);
    await writePage.getSaveButton().click();
    await expect(timelinePage.getTimelineContainer()).toBeVisible();
    
    // Create third entry
    await page.getByText(/写日记|Write|日記を書く/).click();
    await expect(writePage.getTitleField()).toBeVisible();
    await writePage.getTitleField().fill('Third search test entry');
    await writePage.getContentField().fill('This is about weekend plans');
    await writePage.getSaveButton().click();
    await expect(timelinePage.getTimelineContainer()).toBeVisible();
    
    // Navigate to search page
    await page.getByText('Search').or(page.getByText('搜索')).click();
    await expect(searchPage.getSearchInput()).toBeVisible();
    
    // Search for specific keyword
    await searchPage.getSearchInput().fill(testData.searchKeyword);
    await searchPage.getSearchInput().press('Enter');
    
    // Wait for search results to appear
    await expect(page.getByText(testData.searchKeyword)).toBeVisible();
    
    // Click search result
    await page.getByText('Entry containing keyword').click();
    
    // Wait for write page to load with edit mode
    await expect(writePage.getTitleField()).toBeVisible();
    await expect(writePage.getTitleField()).toHaveValue('Entry containing keyword');
    
    // Edit diary content
    await writePage.getTitleField().fill(testData.updatedEntry);
    const editedContent = testData.entryWithKeyword.replace('important keyword', 'edited keyword content');
    await writePage.getContentField().fill(editedContent);
    
    // Save changes
    await writePage.getSaveButton().click();
    
    // Verify navigation back to timeline
    await expect(timelinePage.getTimelineContainer()).toBeVisible();
    
    // Verify updated content in timeline
    await expect(page.getByText(testData.updatedEntry)).toBeVisible();
  });
});