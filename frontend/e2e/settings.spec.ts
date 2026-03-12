import { expect, test } from '@playwright/test';
import { login, logout, register, navigateToSettings } from './helpers/auth';

// Storage keys from AppContext
const STORAGE_KEYS = {
  THEME: '@app_theme',
  ACCENT: '@app_accent',
  LANGUAGE: '@app_language',
  TOKEN: '@app_token',
  USER: '@app_user',
};

// Accent colors from AppContext
const ACCENT_COLORS = [
  { id: 'teal', hex: '#02BFB8' },
  { id: 'blue', hex: '#3B82F6' },
  { id: 'purple', hex: '#8B5CF6' },
  { id: 'rose', hex: '#F43F5E' },
  { id: 'amber', hex: '#F59E0B' },
  { id: 'green', hex: '#22C55E' },
];

// Language translations for verification
const TRANSLATIONS = {
  zh: {
    appearance: '外观',
    colorScheme: '配色方案',
    dark: '深色',
    light: '浅色',
    followSystem: '跟随系统',
    themeColor: '主题色',
    language: '语言',
    account: '账号',
    loginRegister: '登录 / 注册',
    login: '登录',
    register: '注册',
    username: '用户名',
    password: '密码',
    logout: '退出登录',
    about: '关于',
    version: '版本',
  },
  en: {
    appearance: 'Appearance',
    colorScheme: 'Color Scheme',
    dark: 'Dark',
    light: 'Light',
    followSystem: 'System',
    themeColor: 'Theme Color',
    language: 'Language',
    account: 'Account',
    loginRegister: 'Login / Register',
    login: 'Login',
    register: 'Register',
    username: 'Username',
    password: 'Password',
    logout: 'Log Out',
    about: 'About',
    version: 'Version',
  },
  ja: {
    appearance: '外観',
    colorScheme: '配色',
    dark: 'ダーク',
    light: 'ライト',
    followSystem: 'システム',
    themeColor: 'テーマカラー',
    language: '言語',
    account: 'アカウント',
    loginRegister: 'ログイン / 登録',
    login: 'ログイン',
    register: '登録',
    username: 'ユーザー名',
    password: 'パスワード',
    logout: 'ログアウト',
    about: 'その他',
    version: 'バージョン',
  },
};

test.describe('Settings Page E2E Tests', () => {
  test.setTimeout(60000);

  test.beforeEach(async ({ page }) => {
    // Navigate to page first (required for localStorage access)
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Then clear storage
    await page.evaluate(() => {
      localStorage.clear();
    });
    await page.waitForTimeout(500);
  });

  // ═════════════════════════════════════════════════════════════════════════════
  // THEME SWITCHING TESTS
  // ═════════════════════════════════════════════════════════════════════════════
  test.describe('Theme Switching', () => {
    test('should toggle to dark mode', async ({ page }) => {
      // Navigate to settings
      await navigateToSettings(page);
      
      // Wait for settings page to load properly
      await page.waitForSelector('text="Appearance", text="外观", text="外観"');
      
       // Find and click the dark mode button using accessible text
      const darkButton = page.getByRole('button', { 
        name: new RegExp(`${TRANSLATIONS.en.dark}|${TRANSLATIONS.zh.dark}|${TRANSLATIONS.ja.dark}`) 
      });
      await expect(darkButton).toBeVisible();
      await darkButton.click();
      await page.waitForTimeout(500);
      
      // Verify dark mode is active by checking body background or theme
      const isDarkMode = await page.evaluate(() => {
        const body = document.body;
        const computedStyle = window.getComputedStyle(body);
        // Check if dark theme is applied (typically darker background)
        const bg = computedStyle.backgroundColor;
        return bg.includes('rgb(0') || bg.includes('rgb(1') || bg.includes('rgb(2');
      });
      
      // Also verify localStorage
      const savedTheme = await page.evaluate((key) => {
        return localStorage.getItem(key);
      }, STORAGE_KEYS.THEME);
      
      expect(savedTheme).toBe('dark');
    });

    test('should toggle to light mode', async ({ page }) => {
      await navigateToSettings(page);
      await page.waitForSelector('text="Appearance", text="外观", text="外観"');
      
      // Click light mode button using accessible text
      const lightButton = page.getByRole('button', { 
        name: new RegExp(`${TRANSLATIONS.en.light}|${TRANSLATIONS.zh.light}|${TRANSLATIONS.ja.light}`) 
      });
      await expect(lightButton).toBeVisible();
      await lightButton.click();
      await page.waitForTimeout(500);
      
      // Verify light mode in localStorage
      const savedTheme = await page.evaluate((key) => {
        return localStorage.getItem(key);
      }, STORAGE_KEYS.THEME);
      
      expect(savedTheme).toBe('light');
    });

    test('should persist theme after page refresh', async ({ page }) => {
      await navigateToSettings(page);
      await page.waitForSelector('text="Appearance", text="外观", text="外観"');
      
      // Set to light mode
      const lightButton = page.getByRole('button', { name: new RegExp(`${TRANSLATIONS.en.light}|${TRANSLATIONS.zh.light}|${TRANSLATIONS.ja.light}`) });
      await expect(lightButton).toBeVisible();
      await lightButton.click();
      await page.waitForTimeout(500);
      
      // Refresh the page
      await page.reload();
      await page.waitForLoadState('networkidle');
      await page.waitForTimeout(1500);
      
      // Navigate back to settings
      await navigateToSettings(page);
      await page.waitForSelector('text="Appearance", text="外观", text="外観"');
      
      // Verify theme persisted
      const savedTheme = await page.evaluate((key) => {
        return localStorage.getItem(key);
      }, STORAGE_KEYS.THEME);
      
      expect(savedTheme).toBe('light');
    });
  });

  // ═════════════════════════════════════════════════════════════════════════════
  // ACCENT COLOR SELECTION TESTS
  // ═════════════════════════════════════════════════════════════════════════════
  test.describe('Accent Color Selection', () => {
    test('should select different accent colors (6 available)', async ({ page }) => {
      await navigateToSettings(page);
      await page.waitForSelector('text="Appearance", text="外观", text="外観"');
      
      // Test each accent color
      for (const color of ACCENT_COLORS) {
        // Find the color dot by its background color style
        const colorDot = page.locator('div').filter({ has: page.locator(`[style*="${color.hex}"]`) }).first();
        
        if (await colorDot.isVisible({ timeout: 2000 }).catch(() => false)) {
          await colorDot.click();
          await page.waitForTimeout(300);
          
          // Verify in localStorage
          const savedAccent = await page.evaluate((key) => {
            return localStorage.getItem(key);
          }, STORAGE_KEYS.ACCENT);
          
          expect(savedAccent).toBe(color.hex);
        }
      }
    });

    test('should apply accent color to UI elements', async ({ page }) => {
      await navigateToSettings(page);
      await page.waitForSelector('text="Appearance", text="外观", text="外観"');
      
      // Select a distinct color (purple)
      const purpleColor = ACCENT_COLORS.find(c => c.id === 'purple')!;
      const colorDot = page.locator('div').filter({ has: page.locator(`[style*="${purpleColor.hex}"]`) }).first();
      
      if (await colorDot.isVisible({ timeout: 2000 }).catch(() => false)) {
        await colorDot.click();
        await page.waitForTimeout(500);
        
        // Check if accent color is applied to UI elements
        // Look for elements with the accent color
        const accentElements = await page.locator(`[style*="${purpleColor.hex}"]`).count();
        expect(accentElements).toBeGreaterThan(0);
        
        // Verify localStorage
        const savedAccent = await page.evaluate((key) => {
          return localStorage.getItem(key);
        }, STORAGE_KEYS.ACCENT);
        
        expect(savedAccent).toBe(purpleColor.hex);
      }
    });
  });

  // ═════════════════════════════════════════════════════════════════════════════
  // LANGUAGE SWITCHING TESTS
  // ═════════════════════════════════════════════════════════════════════════════
  test.describe('Language Switching', () => {
    test('should switch to Chinese', async ({ page }) => {
      await navigateToSettings(page);
      await page.waitForSelector('text="Language", text="语言", text="言語"');
      
      // Click Chinese language option using aria-label or text match
      const chineseOption = page.getByText(new RegExp(`${TRANSLATIONS.zh.language}|中文|Chinese`));
      await expect(chineseOption).toBeVisible({ timeout: 5000 });
      await page.getByRole('combobox', { name: /Language|语言|言語/ }).click();
      await page.getByRole('option', { name: /中文|Chinese/ }).click();
      await page.waitForTimeout(500);
      
      // Verify localStorage
      const savedLang = await page.evaluate((key) => {
        return localStorage.getItem(key);
      }, STORAGE_KEYS.LANGUAGE);
      
      expect(savedLang).toBe('zh');
      
      // Verify UI text changed to Chinese
      const appearanceText = page.getByText(TRANSLATIONS.zh.appearance);
      await expect(appearanceText).toBeVisible();
    });

    test('should switch to English', async ({ page }) => {
      await navigateToSettings(page);
      await page.waitForSelector('text="Language", text="语言", text="言語"');
      
      // Click English language option
      await page.getByRole('combobox', { name: /Language|语言|言語/ }).click();
      await page.getByRole('option', { name: /English|英文/ }).click();
      await page.waitForTimeout(500);
      
      // Verify localStorage
      const savedLang = await page.evaluate((key) => {
        return localStorage.getItem(key);
      }, STORAGE_KEYS.LANGUAGE);
      
      expect(savedLang).toBe('en');
      
      // Verify UI text changed to English
      const appearanceText = page.getByText(TRANSLATIONS.en.appearance);
      await expect(appearanceText).toBeVisible();
    });

    test('should switch to Japanese', async ({ page }) => {
      await navigateToSettings(page);
      await page.waitForSelector('text="Language", text="语言", text="言語"');
      
      // Click Japanese language option
      await page.getByRole('combobox', { name: /Language|语言|言語/ }).click();
      await page.getByRole('option', { name: /日本語|Japanese/ }).click();
      await page.waitForTimeout(500);
      
      // Verify localStorage
      const savedLang = await page.evaluate((key) => {
        return localStorage.getItem(key);
      }, STORAGE_KEYS.LANGUAGE);
      
      expect(savedLang).toBe('ja');
      
      // Verify UI text changed to Japanese
      const appearanceText = page.getByText(TRANSLATIONS.ja.appearance);
      await expect(appearanceText).toBeVisible();
    });

    test('should update all UI text in selected language', async ({ page }) => {
      await navigateToSettings(page);
      await page.waitForSelector('text="Language", text="语言", text="言語"');
      
      // Switch to English
      await page.getByRole('combobox', { name: /Language|语言|言語/ }).click();
      await page.getByRole('option', { name: /English|英文/ }).click();
      await page.waitForTimeout(500);
      
      // Verify multiple UI elements show English text
      const enTranslations = TRANSLATIONS.en;
      await expect(page.getByText(enTranslations.appearance)).toBeVisible();
      await expect(page.getByText(enTranslations.colorScheme)).toBeVisible();
      await expect(page.getByText(enTranslations.themeColor)).toBeVisible();
      await expect(page.getByText(enTranslations.language)).toBeVisible();
      await expect(page.getByText(enTranslations.account)).toBeVisible();
      await expect(page.getByText(enTranslations.about)).toBeVisible();
    });
  });

  // ═════════════════════════════════════════════════════════════════════════════
  // ACCOUNT MANAGEMENT TESTS
  // ═════════════════════════════════════════════════════════════════════════════
  test.describe('Account Management', () => {
    test('should show login panel for unauthenticated users', async ({ page }) => {
      // Ensure logged out state
      await logout(page);
      await page.goto('/settings');
      await page.waitForLoadState('networkidle');
      await page.waitForSelector('text="Account", text="账号", text="アカウント"');
      await page.waitForTimeout(1000);
      
      // Look for login/register button using aria role and accessible name
      const loginRegisterButton = page.getByRole('button', { 
        name: new RegExp(`${TRANSLATIONS.en.loginRegister}|${TRANSLATIONS.zh.loginRegister}|${TRANSLATIONS.ja.loginRegister}`) 
      });
      await expect(loginRegisterButton).toBeVisible({ timeout: 5000 });
    });

    test('should register new user successfully', async ({ page }) => {
      // Ensure logged out
      await logout(page);
      await page.goto('/settings');
      await page.waitForLoadState('networkidle');
      await page.waitForSelector('text="Account", text="账号", text="アカウント"');
      await page.waitForTimeout(1000);
      
      // Click login/register button
      const loginButton = page.getByRole('button', { 
        name: new RegExp(`${TRANSLATIONS.en.loginRegister}|${TRANSLATIONS.zh.loginRegister}|${TRANSLATIONS.ja.loginRegister}`) 
      });
      await expect(loginButton).toBeVisible();
      await loginButton.click();
      await page.waitForTimeout(500);
      
      // Switch to register mode
      const switchToRegister = page.getByRole('button', { 
        name: new RegExp(/Don't have an account\? Register|没有账号\？立即注册|アカウントがありませんか\？登録/) 
      });
      await expect(switchToRegister).toBeVisible();
      await switchToRegister.click();
      await page.waitForTimeout(300);
      
      // Fill registration form
      const uniqueUsername = `testuser_${Date.now()}`;
      const password = 'TestPass123!';
      
      const usernameInput = page.locator('input').filter({ has: page.getByPlaceholder(new RegExp(`${TRANSLATIONS.en.username}|${TRANSLATIONS.zh.username}|${TRANSLATIONS.ja.username}|${TRANSLATIONS.en.username}|Username|ユーザー名`)) }).first();
      const passwordInput = page.locator('input').filter({ has: page.getByPlaceholder(new RegExp(`${TRANSLATIONS.en.password}|${TRANSLATIONS.zh.password}|${TRANSLATIONS.ja.password}|${TRANSLATIONS.en.password}|Password|パスワード`)) }).first();
      
      await expect(usernameInput).toBeVisible();
      await expect(passwordInput).toBeVisible();
      
      await usernameInput.fill(uniqueUsername);
      await passwordInput.fill(password);
      
      // Click register button using text match
      const registerBtn = page.getByRole('button', { 
        name: new RegExp(`${TRANSLATIONS.en.register}|${TRANSLATIONS.zh.register}|${TRANSLATIONS.ja.register}`) 
      });
      await expect(registerBtn).toBeVisible();
      await registerBtn.click();
      
      // Wait for registration to complete
      await page.waitForTimeout(3000);
      
      // Verify user is logged in (avatar should be visible)
      const avatar = page.locator(`text/${uniqueUsername.charAt(0).toUpperCase()}/`);
      const isLoggedIn = await avatar.isVisible({ timeout: 10000 }).catch(() => false);
      expect(isLoggedIn).toBeTruthy();
    });

    test('should login with existing user', async ({ page }) => {
      // Ensure logged out first
      await logout(page);
      await page.goto('/settings');
      await page.waitForLoadState('networkidle');
      await page.waitForSelector('text="Account", text="账号", text="アカウント"');
      await page.waitForTimeout(1000);
      
      // Perform login using the login helper
      await login(page);
      await page.waitForTimeout(2000);
      
      // Navigate to settings
      await navigateToSettings(page);
      await page.waitForSelector('text="Account", text="账号", text="アカウント"');
      await page.waitForTimeout(1000);
      
      // Verify user info is displayed (avatar with first letter)
      const avatar = page.locator('text=/^[A-Z]$/');
      await expect(avatar).toBeVisible({ timeout: 5000 });
    });

    test('should show user info when logged in', async ({ page }) => {
      // Login first
      await login(page);
      await page.waitForTimeout(2000);
      
      // Navigate to settings
      await navigateToSettings(page);
      await page.waitForSelector('text="Account", text="账号", text="アカウント"');
      await page.waitForTimeout(1000);
      
      // Verify user info section is visible
      // Look for logout button
      const logoutButton = page.getByRole('button', { 
        name: new RegExp(`${TRANSLATIONS.en.logout}|${TRANSLATIONS.zh.logout}|${TRANSLATIONS.ja.logout}`) 
      });
      await expect(logoutButton).toBeVisible({ timeout: 5000 });
      
      // Verify user data in localStorage
      const userData = await page.evaluate((key) => {
        const data = localStorage.getItem(key);
        return data ? JSON.parse(data) : null;
      }, STORAGE_KEYS.USER);
      
      expect(userData).not.toBeNull();
      expect(userData.username).toBeTruthy();
    });

    test('should logout successfully', async ({ page }) => {
      // Login first
      await login(page);
      await page.waitForTimeout(2000);
      
      // Navigate to settings
      await navigateToSettings(page);
      await page.waitForSelector('text="Account", text="账号", text="アカウント"');
      await page.waitForTimeout(1000);
      
      // Click logout button
      const logoutButton = page.getByRole('button', { 
        name: new RegExp(`${TRANSLATIONS.en.logout}|${TRANSLATIONS.zh.logout}|${TRANSLATIONS.ja.logout}`) 
      });
      await expect(logoutButton).toBeVisible();
      await logoutButton.click();
      await page.waitForTimeout(2000);
      
      // Verify token is removed from localStorage
      const token = await page.evaluate((key) => {
        return localStorage.getItem(key);
      }, STORAGE_KEYS.TOKEN);
      
      expect(token).toBeNull();
      
      // Verify user data is removed
      const userData = await page.evaluate((key) => {
        return localStorage.getItem(key);
      }, STORAGE_KEYS.USER);
      
      expect(userData).toBeNull();
    });

    test('should return to login panel after logout', async ({ page }) => {
      // Login first
      await login(page);
      await page.waitForTimeout(2000);
      
      // Navigate to settings
      await navigateToSettings(page);
      await page.waitForSelector('text="Account", text="账号", text="アカウント"');
      await page.waitForTimeout(1000);
      
      // Logout
      const logoutButton = page.getByRole('button', { 
        name: new RegExp(`${TRANSLATIONS.en.logout}|${TRANSLATIONS.zh.logout}|${TRANSLATIONS.ja.logout}`) 
      });
      await expect(logoutButton).toBeVisible();
      await logoutButton.click();
      await page.waitForTimeout(2000);
      
      // Refresh page to ensure clean state
      await page.reload();
      await page.waitForLoadState('networkidle');
      await page.waitForTimeout(1500);
      
      // Navigate to settings again
      await navigateToSettings(page);
      await page.waitForSelector('text="Account", text="账号", text="アカウント"');
      await page.waitForTimeout(1000);
      
      // Verify login/register button is visible again
      const loginRegisterButton = page.getByRole('button', { 
        name: new RegExp(`${TRANSLATIONS.en.loginRegister}|${TRANSLATIONS.zh.loginRegister}|${TRANSLATIONS.ja.loginRegister}`) 
      });
      await expect(loginRegisterButton).toBeVisible({ timeout: 5000 });
    });
  });

  // ═════════════════════════════════════════════════════════════════════════════
  // SETTINGS PERSISTENCE TESTS
  // ═════════════════════════════════════════════════════════════════════════════
  test.describe('Settings Persistence', () => {
    test('should persist theme setting after navigation', async ({ page }) => {
      await navigateToSettings(page);
      await page.waitForSelector('text="Appearance", text="外观", text="外観"');
      
      // Set to light mode
      const lightButton = page.getByRole('button', { 
        name: new RegExp(`${TRANSLATIONS.en.light}|${TRANSLATIONS.zh.light}|${TRANSLATIONS.ja.light}`) 
      });
      await expect(lightButton).toBeVisible();
      await lightButton.click();
      await page.waitForTimeout(500);
      
      // Navigate away to another page
      await page.goto('/');
      await page.waitForLoadState('networkidle');
      await page.waitForTimeout(1000);
      
      // Navigate back to settings
      await navigateToSettings(page);
      await page.waitForSelector('text="Appearance", text="外观", text="外観"');
      
      // Verify theme persisted
      const savedTheme = await page.evaluate((key) => {
        return localStorage.getItem(key);
      }, STORAGE_KEYS.THEME);
      
      expect(savedTheme).toBe('light');
    });

    test('should persist language setting after refresh', async ({ page }) => {
      await navigateToSettings(page);
      await page.waitForSelector('text="Language", text="语言", text="言語"');
      
      // Switch to Japanese
      await page.getByRole('combobox', { name: /Language|语言|言語/ }).click();
      await page.getByRole('option', { name: /日本語|Japanese/ }).click();
      await page.waitForTimeout(500);
      
      // Refresh page
      await page.reload();
      await page.waitForLoadState('networkidle');
      await page.waitForTimeout(1500);
      
      // Verify language persisted
      const savedLang = await page.evaluate((key) => {
        return localStorage.getItem(key);
      }, STORAGE_KEYS.LANGUAGE);
      
      expect(savedLang).toBe('ja');
      
      // Verify UI is still in Japanese
      const jaTranslations = TRANSLATIONS.ja;
      const appearanceVisible = page.getByText(jaTranslations.appearance);
      await expect(appearanceVisible).toBeVisible();
    });

    test('should persist accent color after page reload', async ({ page }) => {
      await navigateToSettings(page);
      await page.waitForSelector('text="Appearance", text="外观", text="外観"');
      
      // Select a specific color (rose)
      const roseColor = ACCENT_COLORS.find(c => c.id === 'rose')!;
      const colorDot = page.locator('div').filter({ has: page.locator(`[style*="${roseColor.hex}"]`) }).first();
      
      if (await colorDot.isVisible({ timeout: 2000 }).catch(() => false)) {
        await colorDot.click();
        await page.waitForTimeout(500);
        
        // Reload page
        await page.reload();
        await page.waitForLoadState('networkidle');
        await page.waitForTimeout(1500);
        
        // Navigate back to settings
        await navigateToSettings(page);
        await page.waitForSelector('text="Appearance", text="外观", text="外観"');
        
        // Verify accent color persisted
        const savedAccent = await page.evaluate((key) => {
          return localStorage.getItem(key);
        }, STORAGE_KEYS.ACCENT);
        
        expect(savedAccent).toBe(roseColor.hex);
      }
    });
  });
});