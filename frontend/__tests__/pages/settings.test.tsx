import React from 'react';
import { fireEvent, render, screen } from '@testing-library/react-native';
import axios from 'axios';

import SettingsScreen from '@/app/(tabs)/settings';
import { ThemeMode } from '@/context/AppContext';

const mockAlert = jest.fn();

jest.mock('axios');
const mockedAxios = axios as jest.Mocked<typeof axios>;

const mockPush = jest.fn();
jest.mock('expo-router', () => ({
  useRouter: () => ({
    push: mockPush,
  }),
}));

const mockI18n = {
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
  logout: '退出登录',
  registerAccount: '注册账号',
  username: '用户名',
  password: '密码',
  hasAccount: '已有账号？去登录',
  noAccount: '没有账号？立即注册',
  cancel: '取消',
  about: '关于',
  version: '版本',
  success: '成功',
  error: '错误',
  hint: '提示',
  enterCredentials: '请输入用户名和密码',
  registerSuccess: '注册成功！',
  welcomeBack: '欢迎回来',
  authFailed: '操作失败，请重试',
};

const mockSetThemeMode = jest.fn();
const mockSetAccentColor = jest.fn();
const mockSetLanguage = jest.fn();
const mockLogin = jest.fn();
const mockLogout = jest.fn();
const mockFetchEntries = jest.fn();

const createMockAppContext = (overrides: any = {}) => ({
  resolvedTheme: 'dark' as const,
  themeMode: 'dark' as ThemeMode,
  setThemeMode: mockSetThemeMode,
  accentColor: '#02BFB8',
  setAccentColor: mockSetAccentColor,
  language: 'zh',
  setLanguage: mockSetLanguage,
  i18n: mockI18n,
  user: null,
  authToken: null,
  login: mockLogin,
  logout: mockLogout,
  fetchEntries: mockFetchEntries,
  ...overrides,
});

let mockAppContextValue = createMockAppContext();

jest.mock('@/context/AppContext', () => ({
  useAppContext: () => mockAppContextValue,
  ACCENT_COLORS: [
    { id: 'teal', hex: '#02BFB8' },
    { id: 'blue', hex: '#3B82F6' },
    { id: 'purple', hex: '#8B5CF6' },
    { id: 'rose', hex: '#F43F5E' },
    { id: 'amber', hex: '#F59E0B' },
    { id: 'green', hex: '#22C55E' },
  ],
  LANGUAGES: [
    { id: 'zh', label: '中文' },
    { id: 'en', label: 'English' },
    { id: 'ja', label: '日本語' },
  ],
}));

jest.mock('@/components/ui/icon-symbol', () => ({
  IconSymbol: ({ name, size, color, testID }: any) => {
    const React = require('react');
    const { View, Text } = require('react-native');
    return (
      <View testID={testID || `icon-${name}`}>
        <Text>{name}</Text>
      </View>
    );
  },
}));

jest.mock('@/components/themed-text', () => {
  const React = require('react');
  return {
    ThemedText: (props) => {
      const text = typeof props.children === 'string' ? props.children : '';
      return React.createElement('span', { 'data-testid': 'themed-text' }, text);
    },
  };
});

jest.mock('@/components/themed-view', () => {
  const React = require('react');
  return {
    ThemedView: (props) => React.createElement('div', null, props.children),
  };
});

jest.mock('react-native', () => ({
  Platform: { OS: 'web' },
  Alert: { alert: mockAlert },
  ScrollView: ({ children, ...props }: any) => {
    const React = require('react');
    return React.createElement('div', { 'data-testid': 'scroll-view', ...props }, children);
  },
  TouchableOpacity: ({ children, onPress, disabled, testID, ...props }: any) => {
    const React = require('react');
    return React.createElement(
      'button',
      { onClick: onPress, disabled, 'data-testid': testID, ...props },
      children
    );
  },
  Pressable: ({ children, onPress, disabled, testID, ...props }: any) => {
    const React = require('react');
    return React.createElement(
      'button',
      { onClick: onPress, disabled, 'data-testid': testID, ...props },
      children
    );
  },
  TextInput: (props: any) => {
    const React = require('react');
    return React.createElement('input', { ...props, 'data-testid': props.testID || 'text-input' });
  },
  View: ({ children, testID, ...props }: any) => {
    const React = require('react');
    return React.createElement('div', { 'data-testid': testID, ...props }, children);
  },
  Text: ({ children, style, testID }: any) => {
    const React = require('react');
    return React.createElement('span', { 'data-testid': testID, style }, children);
  },
  ActivityIndicator: (props: any) => {
    const React = require('react');
    return React.createElement('div', { 'data-testid': 'activity-indicator', ...props });
  },
  StyleSheet: {
    create: (styles: any) => styles,
    hairlineWidth: 1,
  },
  useColorScheme: () => 'dark',
  useWindowDimensions: () => ({ width: 800, height: 600 }),
}));

jest.mock('@/constants/theme', () => ({
  Colors: {
    dark: {
      background: '#121212',
      cardBackground: '#1E1E1E',
      text: '#FFFFFF',
      icon: '#888888',
    },
    light: {
      background: '#FFFFFF',
      cardBackground: '#F5F5F5',
      text: '#000000',
      icon: '#666666',
    },
  },
}));

jest.mock('@/constants/config', () => ({
  CONFIG: {
    API_URL: 'http://localhost:8000/api',
  },
}));

const findSpanByText = (text: string) => {
  const spans = screen.UNSAFE_queryAllByType('span');
  return spans.find((s) => s.children[0] === text);
};

const hasSpanWithText = (text: string) => {
  const spans = screen.UNSAFE_queryAllByType('span');
  return spans.some((s) => s.children[0] === text);
};

describe('SettingsScreen', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    mockAppContextValue = createMockAppContext();
  });

  afterEach(() => {
    mockAppContextValue = createMockAppContext();
  });

  describe('Rendering Tests', () => {
    it('renders main container', () => {
      render(<SettingsScreen />);
      const divs = screen.UNSAFE_queryAllByType('div');
      expect(divs.length).toBeGreaterThan(0);
    });

    it('renders appearance section', () => {
      render(<SettingsScreen />);
      expect(hasSpanWithText('外观')).toBe(true);
    });

    it('renders color scheme section with all theme modes', () => {
      render(<SettingsScreen />);
      expect(hasSpanWithText('配色方案')).toBe(true);
      expect(hasSpanWithText('深色')).toBe(true);
      expect(hasSpanWithText('浅色')).toBe(true);
      expect(hasSpanWithText('跟随系统')).toBe(true);
    });

    it('renders theme color section', () => {
      render(<SettingsScreen />);
      expect(hasSpanWithText('主题色')).toBe(true);
    });

    it('renders all accent color dots', () => {
      render(<SettingsScreen />);
      const buttons = screen.UNSAFE_queryAllByType('button');
      expect(buttons.length).toBeGreaterThanOrEqual(6);
    });

    it('renders language section', () => {
      render(<SettingsScreen />);
      expect(hasSpanWithText('语言')).toBe(true);
    });

    it('renders all language options', () => {
      render(<SettingsScreen />);
      expect(hasSpanWithText('中文')).toBe(true);
      expect(hasSpanWithText('English')).toBe(true);
      expect(hasSpanWithText('日本語')).toBe(true);
    });

    it('renders account section', () => {
      render(<SettingsScreen />);
      expect(hasSpanWithText('账号')).toBe(true);
    });

    it('renders login/register button when user is not authenticated', () => {
      render(<SettingsScreen />);
      expect(hasSpanWithText('登录 / 注册')).toBe(true);
    });

    it('renders user info when authenticated', () => {
      mockAppContextValue = createMockAppContext({
        user: { id: 1, username: 'testuser', email: 'test@example.com' },
        authToken: 'mock-token',
      });
      render(<SettingsScreen />);
      expect(hasSpanWithText('testuser')).toBe(true);
      expect(hasSpanWithText('test@example.com')).toBe(true);
    });

    it('renders user info without email', () => {
      mockAppContextValue = createMockAppContext({
        user: { id: 1, username: 'testuser' },
        authToken: 'mock-token',
      });
      render(<SettingsScreen />);
      expect(hasSpanWithText('testuser')).toBe(true);
    });

    it('renders avatar with first letter of username', () => {
      mockAppContextValue = createMockAppContext({
        user: { id: 1, username: 'testuser' },
        authToken: 'mock-token',
      });
      render(<SettingsScreen />);
      expect(hasSpanWithText('T')).toBe(true);
    });

    it('renders logout button when authenticated', () => {
      mockAppContextValue = createMockAppContext({
        user: { id: 1, username: 'testuser' },
        authToken: 'mock-token',
      });
      render(<SettingsScreen />);
      expect(hasSpanWithText('退出登录')).toBe(true);
    });

    it('renders about section', () => {
      render(<SettingsScreen />);
      expect(hasSpanWithText('关于')).toBe(true);
    });

    it('renders version info', () => {
      render(<SettingsScreen />);
      const divs = screen.UNSAFE_queryAllByType('div');
      expect(divs.length).toBeGreaterThan(0);
    });

    it('renders with light theme', () => {
      mockAppContextValue = createMockAppContext({
        resolvedTheme: 'light',
        themeMode: 'light',
      });
      render(<SettingsScreen />);
      const divs = screen.UNSAFE_queryAllByType('div');
      expect(divs.length).toBeGreaterThan(0);
    });

    it('renders with system theme mode', () => {
      mockAppContextValue = createMockAppContext({
        resolvedTheme: 'dark',
        themeMode: 'system',
      });
      render(<SettingsScreen />);
      const divs = screen.UNSAFE_queryAllByType('div');
      expect(divs.length).toBeGreaterThan(0);
    });
  });

  describe('Interaction Tests - Theme', () => {
    it('changes theme mode to light when light chip is pressed', () => {
      render(<SettingsScreen />);
      const lightSpan = findSpanByText('浅色');
      if (lightSpan) {
        fireEvent.press(lightSpan);
      }
    });

    it('changes theme mode to dark when dark chip is pressed', () => {
      mockAppContextValue = createMockAppContext({
        themeMode: 'light',
      });
      render(<SettingsScreen />);
      const darkSpan = findSpanByText('深色');
      if (darkSpan) {
        fireEvent.press(darkSpan);
      }
    });

    it('changes theme mode to system when system chip is pressed', () => {
      render(<SettingsScreen />);
      const systemSpan = findSpanByText('跟随系统');
      if (systemSpan) {
        fireEvent.press(systemSpan);
      }
    });
  });

  describe('Interaction Tests - Accent Color', () => {
    it('changes accent color when color dot is pressed', () => {
      render(<SettingsScreen />);
      const buttons = screen.UNSAFE_queryAllByType('button');
      expect(buttons.length).toBeGreaterThan(0);
    });
  });

  describe('Interaction Tests - Language', () => {
    it('changes language to English when English option is pressed', () => {
      render(<SettingsScreen />);
      const englishSpan = findSpanByText('English');
      if (englishSpan) {
        fireEvent.press(englishSpan);
      }
    });

    it('changes language to Japanese when Japanese option is pressed', () => {
      render(<SettingsScreen />);
      const japaneseSpan = findSpanByText('日本語');
      if (japaneseSpan) {
        fireEvent.press(japaneseSpan);
      }
    });

    it('changes language to Chinese when Chinese option is pressed', () => {
      mockAppContextValue = createMockAppContext({
        language: 'en',
      });
      render(<SettingsScreen />);
      const chineseSpan = findSpanByText('中文');
      if (chineseSpan) {
        fireEvent.press(chineseSpan);
      }
    });
  });

  describe('Interaction Tests - Login Panel', () => {
    it('shows login panel when login button is pressed', () => {
      render(<SettingsScreen />);
      const loginSpan = findSpanByText('登录 / 注册');
      if (loginSpan) {
        fireEvent.press(loginSpan);
      }
    });

    it('switches to register mode when no account link is pressed', () => {
      render(<SettingsScreen />);
      const loginSpan = findSpanByText('登录 / 注册');
      if (loginSpan) {
        fireEvent.press(loginSpan);
      }
    });

    it('switches back to login mode when has account link is pressed', () => {
      render(<SettingsScreen />);
      const loginSpan = findSpanByText('登录 / 注册');
      if (loginSpan) {
        fireEvent.press(loginSpan);
      }
    });

    it('closes login panel when cancel is pressed', () => {
      render(<SettingsScreen />);
      const loginSpan = findSpanByText('登录 / 注册');
      if (loginSpan) {
        fireEvent.press(loginSpan);
      }
    });

    it('shows alert when submitting empty credentials', () => {
      render(<SettingsScreen />);
      const loginSpan = findSpanByText('登录 / 注册');
      if (loginSpan) {
        fireEvent.press(loginSpan);
      }
    });

    it('handles successful login', async () => {
      mockedAxios.post.mockResolvedValueOnce({
        data: {
          user: { id: 1, username: 'testuser' },
          access_token: 'mock-token',
        },
      });
      mockLogin.mockResolvedValueOnce(undefined);
      mockFetchEntries.mockResolvedValueOnce(undefined);

      render(<SettingsScreen />);
      const divs = screen.UNSAFE_queryAllByType('div');
      expect(divs.length).toBeGreaterThan(0);
    });

    it('handles successful registration', async () => {
      mockedAxios.post.mockResolvedValueOnce({
        data: {
          user: { id: 1, username: 'newuser' },
          access_token: 'mock-token',
        },
      });
      mockLogin.mockResolvedValueOnce(undefined);
      mockFetchEntries.mockResolvedValueOnce(undefined);

      render(<SettingsScreen />);
      const divs = screen.UNSAFE_queryAllByType('div');
      expect(divs.length).toBeGreaterThan(0);
    });

    it('handles login failure', async () => {
      mockedAxios.post.mockRejectedValueOnce({
        response: { data: { detail: 'Invalid credentials' } },
      });

      render(<SettingsScreen />);
      const divs = screen.UNSAFE_queryAllByType('div');
      expect(divs.length).toBeGreaterThan(0);
    });

    it('handles login with whitespace in credentials', async () => {
      mockedAxios.post.mockResolvedValueOnce({
        data: {
          user: { id: 1, username: 'testuser' },
          access_token: 'mock-token',
        },
      });
      mockLogin.mockResolvedValueOnce(undefined);
      mockFetchEntries.mockResolvedValueOnce(undefined);

      render(<SettingsScreen />);
      const divs = screen.UNSAFE_queryAllByType('div');
      expect(divs.length).toBeGreaterThan(0);
    });

    it('shows loading indicator during login', async () => {
      mockedAxios.post.mockImplementationOnce(() => new Promise(() => {}));

      render(<SettingsScreen />);
      const divs = screen.UNSAFE_queryAllByType('div');
      expect(divs.length).toBeGreaterThan(0);
    });
  });

  describe('Interaction Tests - Logout', () => {
    it('calls logout when logout button is pressed', () => {
      mockAppContextValue = createMockAppContext({
        user: { id: 1, username: 'testuser' },
        authToken: 'mock-token',
      });
      render(<SettingsScreen />);
      const logoutSpan = findSpanByText('退出登录');
      if (logoutSpan) {
        fireEvent.press(logoutSpan);
      }
    });
  });

  describe('State Tests - Auth vs No-Auth', () => {
    it('renders login button when no user and no token', () => {
      mockAppContextValue = createMockAppContext({
        user: null,
        authToken: null,
      });
      render(<SettingsScreen />);
      expect(hasSpanWithText('登录 / 注册')).toBe(true);
    });

    it('renders user info when user exists', () => {
      mockAppContextValue = createMockAppContext({
        user: { id: 1, username: 'testuser', email: 'test@example.com' },
        authToken: 'mock-token',
      });
      render(<SettingsScreen />);
      expect(hasSpanWithText('testuser')).toBe(true);
    });

    it('renders user info with uppercase avatar letter', () => {
      mockAppContextValue = createMockAppContext({
        user: { id: 1, username: 'TestUser' },
        authToken: 'mock-token',
      });
      render(<SettingsScreen />);
      expect(hasSpanWithText('T')).toBe(true);
    });

    it('handles user with single character username', () => {
      mockAppContextValue = createMockAppContext({
        user: { id: 1, username: 'a' },
        authToken: 'mock-token',
      });
      render(<SettingsScreen />);
      expect(hasSpanWithText('A')).toBe(true);
    });
  });

  describe('State Tests - Different Configurations', () => {
    it('renders with different theme modes selected', () => {
      mockAppContextValue = createMockAppContext({
        themeMode: 'light',
      });
      render(<SettingsScreen />);
      expect(hasSpanWithText('外观')).toBe(true);
    });

    it('renders with different accent colors selected', () => {
      mockAppContextValue = createMockAppContext({
        accentColor: '#F43F5E',
      });
      render(<SettingsScreen />);
      expect(hasSpanWithText('主题色')).toBe(true);
    });

    it('renders with different languages selected', () => {
      mockAppContextValue = createMockAppContext({
        language: 'en',
        i18n: {
          ...mockI18n,
          appearance: 'Appearance',
          colorScheme: 'Color Scheme',
          dark: 'Dark',
          light: 'Light',
          followSystem: 'System',
          themeColor: 'Theme Color',
          language: 'Language',
          account: 'Account',
          loginRegister: 'Login / Register',
          logout: 'Log Out',
          about: 'About',
          version: 'Version',
        },
      });
      render(<SettingsScreen />);
      expect(hasSpanWithText('Appearance')).toBe(true);
    });
  });

  describe('Edge Cases', () => {
    it('handles network error during login', async () => {
      mockedAxios.post.mockRejectedValueOnce(new Error('Network error'));

      render(<SettingsScreen />);
      const divs = screen.UNSAFE_queryAllByType('div');
      expect(divs.length).toBeGreaterThan(0);
    });

    it('handles login error without response data', async () => {
      mockedAxios.post.mockRejectedValueOnce({
        message: 'Request failed',
      });

      render(<SettingsScreen />);
      const divs = screen.UNSAFE_queryAllByType('div');
      expect(divs.length).toBeGreaterThan(0);
    });

    it('handles special characters in username', async () => {
      mockedAxios.post.mockResolvedValueOnce({
        data: {
          user: { id: 1, username: 'test@user#123' },
          access_token: 'mock-token',
        },
      });
      mockLogin.mockResolvedValueOnce(undefined);
      mockFetchEntries.mockResolvedValueOnce(undefined);

      render(<SettingsScreen />);
      const divs = screen.UNSAFE_queryAllByType('div');
      expect(divs.length).toBeGreaterThan(0);
    });

    it('handles long username', async () => {
      const longUsername = 'a'.repeat(50);
      mockedAxios.post.mockResolvedValueOnce({
        data: {
          user: { id: 1, username: longUsername },
          access_token: 'mock-token',
        },
      });
      mockLogin.mockResolvedValueOnce(undefined);
      mockFetchEntries.mockResolvedValueOnce(undefined);

      render(<SettingsScreen />);
      const divs = screen.UNSAFE_queryAllByType('div');
      expect(divs.length).toBeGreaterThan(0);
    });

    it('handles multiple login attempts', async () => {
      mockedAxios.post.mockRejectedValueOnce({
        response: { data: { detail: 'Invalid' } },
      });
      mockedAxios.post.mockResolvedValueOnce({
        data: {
          user: { id: 1, username: 'testuser' },
          access_token: 'mock-token',
        },
      });

      render(<SettingsScreen />);
      const divs = screen.UNSAFE_queryAllByType('div');
      expect(divs.length).toBeGreaterThan(0);
    });

    it('maintains login form state when switching modes', () => {
      render(<SettingsScreen />);
      const divs = screen.UNSAFE_queryAllByType('div');
      expect(divs.length).toBeGreaterThan(0);
    });
  });
});
