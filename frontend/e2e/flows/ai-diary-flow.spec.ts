import { test, expect } from '@playwright/test';
import { ChatPage, TimelinePage, WritePage } from '../helpers/page-objects';
import { login } from '../helpers/auth';

const testData = {
  username: `testuser_${Date.now()}`,
  password: 'TestPassword123!',
  aiQuery: 'How was your day today?',
  generatedTitle: `Generated Diary ${Date.now()}`,
};

test.describe('AI Diary Creation Flow', () => {
  test('should use AI to generate diary entry from chat', async ({ page }) => {
    const chatPage = new ChatPage(page);
    const timelinePage = new TimelinePage(page);
    const writePage = new WritePage(page);

    // Create and login with test user
    await login(page, testData.username, testData.password);

    // Navigate to chat page
    await page.getByText('Chat').or(page.getByText('聊天')).click();
    
    // Wait for chat interface to load
    await expect(chatPage.getMessageInput()).toBeVisible();

    // Send message to AI
    await chatPage.getMessageInput().fill(testData.aiQuery);
    await chatPage.getMessageInput().press('Enter');

    // Verify AI responds
    await expect(chatPage.getLastBotMessage()).toContainText('AID');
    await expect(chatPage.getLastBotMessage()).toBeVisible();

    // Click "Generate Diary" button from AI response
    await chatPage.getGenerateDiaryButton().click();

    // Verify we're on the write page with generated content
    await expect(writePage.getTitleField()).toBeVisible();
    
    // Edit the generated content
    await writePage.getTitleField().fill(testData.generatedTitle);
    const additionalContent = `\n\nThis entry was generated via AI assistance at ${new Date().toISOString()}`;
    await writePage.getContentField().fill(await writePage.getContentField().inputValue() + additionalContent);
    
    // Add tags and category
    await writePage.getTagInput().fill('AI-generated');
    await writePage.getTagInput().press('Enter');
    await writePage.getCategorySelector().click();
    await page.getByText('Personal').click(); // Assuming 'Personal' is an option
    
    // Save diary
    await writePage.getSaveButton().click();

    // Verify navigation to timeline and entry presence
    await expect(timelinePage.getTimelineContainer()).toBeVisible();
    await expect(page.getByText(testData.generatedTitle)).toBeVisible();
  });
});