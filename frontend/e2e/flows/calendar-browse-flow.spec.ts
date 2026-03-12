import { test, expect } from '@playwright/test';
import { TimelinePage, CalendarPage, WritePage } from '../helpers/page-objects';
import { login } from '../helpers/auth';

const testData = {
  username: `testuser_${Date.now()}`,
  password: 'TestPassword123!',
  winterEntry: `Winter diary entry ${Date.now()}`,
  summerEntry: `Summer diary entry ${Date.now()}`,
};

test.describe('Calendar Browse Flow', () => {
  test('should browse calendar and navigate to entries', async ({ page }) => {
    const timelinePage = new TimelinePage(page);
    const calendarPage = new CalendarPage(page);
    const writePage = new WritePage(page);

    // Create diary entries on different dates
    await login(page, testData.username, testData.password);
    
    // Create entry for a past date (e.g., a winter date)
    await page.getByText(/写日记|Write|日記を書く/).click();
    await expect(writePage.getTitleField()).toBeVisible();
    await writePage.getTitleField().fill(testData.winterEntry);
    await writePage.getContentField().fill('This is a winter diary entry I\'m writing on this date');
    
    // Set to a winter date using the date picker (manually input a date string)
    const winterDatePicker = writePage.getDatePicker();
    await winterDatePicker.fill('2025-01-15');  // Winter month
    
    await writePage.getSaveButton().click();
    await expect(timelinePage.getTimelineContainer()).toBeVisible();

    // Create entry for a summer date
    await page.getByText(/写日记|Write|日記を書く/).click();
    await expect(writePage.getTitleField()).toBeVisible();
    await writePage.getTitleField().fill(testData.summerEntry);
    await writePage.getContentField().fill('This is a summer diary entry I\'m writing on this date');
    
    // Set to a summer date using the date picker
    const summerDatePicker = writePage.getDatePicker();
    await summerDatePicker.fill('2025-07-20');  // Summer month
    
    await writePage.getSaveButton().click();
    await expect(timelinePage.getTimelineContainer()).toBeVisible();

    // Navigate to calendar page
    await page.getByText('Calendar').or(page.getByText('日历')).click();
    await expect(calendarPage.getCalendarContainer()).toBeVisible();

    // Verify red dots on dates with entries
    // We expect dates Jan 15 and July 20 to have indicators
    // This would typically involve checking for specific classes/elements on calendar days
    await expect(calendarPage.getDayIndicator('2025-01-15')).toBeVisible();
    await expect(calendarPage.getDayIndicator('2025-07-20')).toBeVisible();

    // Scroll through months (click next month button until we reach July)
    let currentMonth = await calendarPage.getCurrentMonthLabel();
    while (!currentMonth.includes('July')) {
      await calendarPage.getNextMonthButton().click();
      currentMonth = await calendarPage.getCurrentMonthLabel();
    }

    // Check for July 20 dot
    await expect(calendarPage.getDayIndicator('2025-07-20')).toBeVisible();

    // Scroll back to January
    while (!currentMonth.includes('January')) {
      await calendarPage.getPreviousMonthButton().click();
      currentMonth = await calendarPage.getCurrentMonthLabel();
    }

    // Check for January 15 dot
    await expect(calendarPage.getDayIndicator('2025-01-15')).toBeVisible();

    // Click a date with entry (January 15)
    await calendarPage.getDayElement('2025-01-15').click();

    // Verify navigation to timeline showing January entry
    await expect(timelinePage.getTimelineContainer()).toBeVisible();
    await expect(page.getByText(testData.winterEntry)).toBeVisible();
  });
});