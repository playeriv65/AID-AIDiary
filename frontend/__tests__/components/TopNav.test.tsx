import React from 'react';
import { fireEvent, render, screen } from '@testing-library/react-native';
import { TopNav } from '@/components/TopNav';

// Mock expo-router
const mockPush = jest.fn();
jest.mock('expo-router', () => ({
  useRouter: () => ({
    push: mockPush,
  }),
}));

// Mock AppContext with default values
const mockUseAppContext = jest.fn();
jest.mock('@/context/AppContext', () => ({
  useAppContext: () => mockUseAppContext(),
}));

// Mock IconSymbol to render with testID
jest.mock('@/components/ui/icon-symbol', () => ({
  IconSymbol: ({ name, size, color }: { name: string; size: number; color: string }) => {
    // eslint-disable-next-line react/no-unknown-property
    return <span testID={`icon-${name}`}>{`Icon:${name}:${size}:${color}`}</span>;
  },
}));

// Mock ThemedText - renders children in a span with testID support
jest.mock('@/components/themed-text', () => ({
  ThemedText: ({ children, testID }: { children: React.ReactNode; testID?: string }) => {
    // eslint-disable-next-line react/no-unknown-property
    return <span testID={testID}>{children}</span>;
  },
}));

// Helper to check if rendered output contains text
const containsText = (json: any, text: string): boolean => {
  if (!json) return false;
  if (typeof json === 'string') return json.includes(text);
  if (Array.isArray(json)) {
    return json.some((child) => containsText(child, text));
  }
  if (json.children) {
    return containsText(json.children, text);
  }
  return false;
};

describe('TopNav', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    // Default mock implementation
    mockUseAppContext.mockReturnValue({
      resolvedTheme: 'dark',
      accentColor: '#02BFB8',
      user: { id: 1, username: 'testuser' },
      i18n: { appName: 'AID' },
    });
  });

  describe('Rendering Tests', () => {
    it('renders the app logo icon', () => {
      render(<TopNav />);
      expect(screen.getByTestId('icon-book-open')).toBeTruthy();
    });

    it('renders the app name from i18n', () => {
      render(<TopNav />);
      const json = screen.toJSON();
      expect(containsText(json, 'AID')).toBe(true);
    });

    it('renders app name in different languages', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'dark',
        accentColor: '#02BFB8',
        user: { id: 1, username: 'testuser' },
        i18n: { appName: 'Diary App' },
      });
      render(<TopNav />);
      const json = screen.toJSON();
      expect(containsText(json, 'Diary App')).toBe(true);
    });

    it('renders user avatar with first letter of username', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'dark',
        accentColor: '#02BFB8',
        user: { id: 1, username: 'john_doe' },
        i18n: { appName: 'AID' },
      });
      render(<TopNav />);
      const json = screen.toJSON();
      expect(containsText(json, 'J')).toBe(true);
    });

    it('renders avatar with uppercase letter', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'dark',
        accentColor: '#02BFB8',
        user: { id: 1, username: 'alice' },
        i18n: { appName: 'AID' },
      });
      render(<TopNav />);
      const json = screen.toJSON();
      expect(containsText(json, 'A')).toBe(true);
    });
  });

  describe('Interaction Tests', () => {
    it('navigates to settings when profile container is pressed', () => {
      render(<TopNav />);
      // Find the accessible view (TouchableOpacity renders as accessible View)
      const touchable = screen.UNSAFE_getByProps({ accessible: true });
      expect(touchable).toBeTruthy();
      fireEvent.press(touchable);
      expect(mockPush).toHaveBeenCalledTimes(1);
      expect(mockPush).toHaveBeenCalledWith('/settings');
    });

    it('calls router.push only once per press', () => {
      render(<TopNav />);
      const touchable = screen.UNSAFE_getByProps({ accessible: true });
      expect(touchable).toBeTruthy();
      fireEvent.press(touchable);
      expect(mockPush).toHaveBeenCalledTimes(1);
    });
  });

  describe('State Tests - Theme Colors', () => {
    it('renders without crashing in dark mode', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'dark',
        accentColor: '#02BFB8',
        user: { id: 1, username: 'testuser' },
        i18n: { appName: 'AID' },
      });
      render(<TopNav />);
      const json = screen.toJSON();
      expect(containsText(json, 'AID')).toBe(true);
      expect(screen.getByTestId('icon-book-open')).toBeTruthy();
    });

    it('renders without crashing in light mode', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'light',
        accentColor: '#02BFB8',
        user: { id: 1, username: 'testuser' },
        i18n: { appName: 'AID' },
      });
      render(<TopNav />);
      const json = screen.toJSON();
      expect(containsText(json, 'AID')).toBe(true);
      expect(screen.getByTestId('icon-book-open')).toBeTruthy();
    });

    it('applies custom accent color to icon', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'dark',
        accentColor: '#FF5733',
        user: { id: 1, username: 'testuser' },
        i18n: { appName: 'AID' },
      });
      render(<TopNav />);
      const icon = screen.getByTestId('icon-book-open');
      expect(icon).toBeTruthy();
      // Check that the icon received the correct color prop
      const json = screen.toJSON();
      expect(containsText(json, '#FF5733')).toBe(true);
    });

    it('applies different accent colors', () => {
      const colors = ['#02BFB8', '#3B82F6', '#8B5CF6', '#F43F5E'];
      colors.forEach((color) => {
        mockUseAppContext.mockReturnValue({
          resolvedTheme: 'dark',
          accentColor: color,
          user: { id: 1, username: 'testuser' },
          i18n: { appName: 'AID' },
        });
        const { unmount } = render(<TopNav />);
        expect(screen.getByTestId('icon-book-open')).toBeTruthy();
        const json = screen.toJSON();
        expect(containsText(json, color)).toBe(true);
        unmount();
      });
    });
  });

  describe('State Tests - User Authentication', () => {
    it('renders with logged in user', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'dark',
        accentColor: '#02BFB8',
        user: { id: 1, username: 'testuser' },
        i18n: { appName: 'AID' },
      });
      render(<TopNav />);
      const json = screen.toJSON();
      expect(containsText(json, 'T')).toBe(true);
      expect(containsText(json, 'AID')).toBe(true);
    });

    it('renders with no user (logged out state)', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'dark',
        accentColor: '#02BFB8',
        user: null,
        i18n: { appName: 'AID' },
      });
      render(<TopNav />);
      // Should show 'U' when no user
      const json = screen.toJSON();
      expect(containsText(json, 'U')).toBe(true);
    });

    it('still navigates to settings when logged out', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'dark',
        accentColor: '#02BFB8',
        user: null,
        i18n: { appName: 'AID' },
      });
      render(<TopNav />);
      const touchable = screen.UNSAFE_getByProps({ accessible: true });
      fireEvent.press(touchable);
      expect(mockPush).toHaveBeenCalledWith('/settings');
    });
  });

  describe('Edge Cases', () => {
    it('handles undefined user gracefully', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'dark',
        accentColor: '#02BFB8',
        user: undefined,
        i18n: { appName: 'AID' },
      });
      render(<TopNav />);
      const json = screen.toJSON();
      expect(containsText(json, 'U')).toBe(true);
    });

    it('handles user with empty username', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'dark',
        accentColor: '#02BFB8',
        user: { id: 1, username: '' },
        i18n: { appName: 'AID' },
      });
      render(<TopNav />);
      // charAt(0) on empty string returns empty string
      // We should still see the app name
      const json = screen.toJSON();
      expect(containsText(json, 'AID')).toBe(true);
    });

    it('handles user with single character username', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'dark',
        accentColor: '#02BFB8',
        user: { id: 1, username: 'x' },
        i18n: { appName: 'AID' },
      });
      render(<TopNav />);
      const json = screen.toJSON();
      expect(containsText(json, 'X')).toBe(true);
    });

    it('handles username with special characters', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'dark',
        accentColor: '#02BFB8',
        user: { id: 1, username: '@test_user!' },
        i18n: { appName: 'AID' },
      });
      render(<TopNav />);
      const json = screen.toJSON();
      expect(containsText(json, '@')).toBe(true);
    });

    it('handles username with unicode characters', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'dark',
        accentColor: '#02BFB8',
        user: { id: 1, username: 'ユーザー' },
        i18n: { appName: 'AID' },
      });
      render(<TopNav />);
      const json = screen.toJSON();
      expect(containsText(json, 'ユ')).toBe(true);
    });

    it('handles username with numbers', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'dark',
        accentColor: '#02BFB8',
        user: { id: 1, username: '123user' },
        i18n: { appName: 'AID' },
      });
      render(<TopNav />);
      const json = screen.toJSON();
      expect(containsText(json, '1')).toBe(true);
    });

    it('handles long username correctly', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'dark',
        accentColor: '#02BFB8',
        user: { id: 1, username: 'verylongusername123' },
        i18n: { appName: 'AID' },
      });
      render(<TopNav />);
      // Should only show first letter
      const json = screen.toJSON();
      expect(containsText(json, 'V')).toBe(true);
    });
  });

  describe('Integration', () => {
    it('renders complete navigation header', () => {
      render(<TopNav />);
      const json = screen.toJSON();
      // Logo icon
      expect(screen.getByTestId('icon-book-open')).toBeTruthy();
      // App name
      expect(containsText(json, 'AID')).toBe(true);
      // Avatar with user initial
      expect(containsText(json, 'T')).toBe(true);
      // Settings button (accessible touchable)
      expect(screen.UNSAFE_getByProps({ accessible: true })).toBeTruthy();
    });

    it('maintains structure across re-renders with different props', () => {
      const { rerender } = render(<TopNav />);
      expect(containsText(screen.toJSON(), 'AID')).toBe(true);
      expect(containsText(screen.toJSON(), 'T')).toBe(true);

      // Change theme
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'light',
        accentColor: '#3B82F6',
        user: { id: 1, username: 'testuser' },
        i18n: { appName: 'AID Diary' },
      });
      rerender(<TopNav />);
      expect(containsText(screen.toJSON(), 'AID Diary')).toBe(true);
      expect(containsText(screen.toJSON(), '#3B82F6')).toBe(true);
    });
  });
});
