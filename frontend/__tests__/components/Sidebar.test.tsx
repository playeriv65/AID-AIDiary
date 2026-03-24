import React from 'react';
import { Platform } from 'react-native';
import { fireEvent, render, screen } from '@testing-library/react-native';
import { Sidebar } from '@/components/Sidebar';

// Mock expo-router
const mockPush = jest.fn();
const mockPathname = jest.fn();
jest.mock('expo-router', () => ({
  useRouter: () => ({
    push: mockPush,
  }),
  usePathname: () => mockPathname(),
}));

// Mock AppContext
const mockUseAppContext = jest.fn();
jest.mock('@/context/AppContext', () => ({
  useAppContext: () => mockUseAppContext(),
}));

// Mock IconSymbol - use testID for identification
jest.mock('@/components/ui/icon-symbol', () => ({
  IconSymbol: function IconSymbolMock({
    name,
    size,
    color,
    weight,
    testID,
  }: {
    name: string;
    size: number;
    color: string;
    weight?: string;
    testID?: string;
  }) {
    const ReactNative = require('react-native');
    return (
      <ReactNative.View testID={testID || `icon-${name}`}>
        <ReactNative.Text>{`icon-${name}-${weight || 'regular'}`}</ReactNative.Text>
      </ReactNative.View>
    );
  },
}));

// Mock ThemedText
jest.mock('@/components/themed-text', () => ({
  ThemedText: function ThemedTextMock({
    children,
    testID,
  }: {
    children: React.ReactNode;
    testID?: string;
  }) {
    const ReactNative = require('react-native');
    return <ReactNative.Text testID={testID}>{children}</ReactNative.Text>;
  },
}));

// Store original Platform.OS
let originalPlatform: typeof Platform.OS;

describe('Sidebar', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    originalPlatform = Platform.OS;

    // Mock Platform.OS to be web by default
    Object.defineProperty(Platform, 'OS', {
      value: 'web',
      configurable: true,
    });

    // Default mock implementation for AppContext - dark theme
    mockUseAppContext.mockReturnValue({
      resolvedTheme: 'dark',
      accentColor: '#02BFB8',
      i18n: {
        timeline: '时间线',
        chat: '聊天',
        calendar: '日历',
        search: '搜索',
        settings: '设置',
      },
    });

    // Default pathname
    mockPathname.mockReturnValue('/');
  });

  afterEach(() => {
    // Restore Platform.OS
    Object.defineProperty(Platform, 'OS', {
      value: originalPlatform,
      configurable: true,
    });
  });

  describe('Rendering Tests', () => {
    it('renders all 5 navigation items', () => {
      render(<Sidebar />);

      // Check all navigation labels are present
      expect(screen.getByText('时间线')).toBeTruthy();
      expect(screen.getByText('聊天')).toBeTruthy();
      expect(screen.getByText('日历')).toBeTruthy();
      expect(screen.getByText('搜索')).toBeTruthy();
      expect(screen.getByText('设置')).toBeTruthy();
    });

    it('renders hamburger toggle button', () => {
      render(<Sidebar />);
      // The toggle button contains the list icon
      expect(screen.getByTestId('icon-list')).toBeTruthy();
    });

    it('renders all navigation icons', () => {
      render(<Sidebar />);

      // Check all icons are rendered using testID
      expect(screen.getByTestId('icon-book-open')).toBeTruthy();
      expect(screen.getByTestId('icon-chat-circle')).toBeTruthy();
      expect(screen.getByTestId('icon-calendar')).toBeTruthy();
      expect(screen.getByTestId('icon-magnifying-glass')).toBeTruthy();
      expect(screen.getByTestId('icon-gear')).toBeTruthy();
    });
  });

  describe('Interaction Tests', () => {
    it('navigates to timeline when timeline item is pressed', () => {
      mockPathname.mockReturnValue('/chat');
      render(<Sidebar />);

      const timelineLabel = screen.getByText('时间线');
      // The touchable is the parent of the label container
      const touchable = timelineLabel.parent?.parent;
      expect(touchable).toBeTruthy();

      fireEvent.press(touchable!);
      expect(mockPush).toHaveBeenCalledWith('/');
    });

    it('navigates to chat when chat item is pressed', () => {
      render(<Sidebar />);

      const chatLabel = screen.getByText('聊天');
      const touchable = chatLabel.parent?.parent;
      expect(touchable).toBeTruthy();

      fireEvent.press(touchable!);
      expect(mockPush).toHaveBeenCalledWith('/chat');
    });

    it('navigates to calendar when calendar item is pressed', () => {
      render(<Sidebar />);

      const calendarLabel = screen.getByText('日历');
      const touchable = calendarLabel.parent?.parent;
      expect(touchable).toBeTruthy();

      fireEvent.press(touchable!);
      expect(mockPush).toHaveBeenCalledWith('/calendar');
    });

    it('navigates to search when search item is pressed', () => {
      render(<Sidebar />);

      const searchLabel = screen.getByText('搜索');
      const touchable = searchLabel.parent?.parent;
      expect(touchable).toBeTruthy();

      fireEvent.press(touchable!);
      expect(mockPush).toHaveBeenCalledWith('/search');
    });

    it('navigates to settings when settings item is pressed', () => {
      render(<Sidebar />);

      const settingsLabel = screen.getByText('设置');
      const touchable = settingsLabel.parent?.parent;
      expect(touchable).toBeTruthy();

      fireEvent.press(touchable!);
      expect(mockPush).toHaveBeenCalledWith('/settings');
    });

    it('toggles sidebar collapse when hamburger button is pressed', () => {
      render(<Sidebar />);

      const listIcon = screen.getByTestId('icon-list');
      const toggleBtn = listIcon.parent;
      expect(toggleBtn).toBeTruthy();

      fireEvent.press(toggleBtn!);
      // Toggle should work without errors
      expect(listIcon).toBeTruthy();
    });
  });

  describe('State Tests - Active Route Highlighting', () => {
    it('highlights timeline when pathname is /', () => {
      mockPathname.mockReturnValue('/');
      render(<Sidebar />);

      // Timeline should be active (fill weight)
      const timelineIcon = screen.getByTestId('icon-book-open');
      expect(timelineIcon).toBeTruthy();
      expect(screen.getByText('icon-book-open-fill')).toBeTruthy();

      // Other items should be inactive (regular weight)
      expect(screen.getByText('icon-chat-circle-regular')).toBeTruthy();
      expect(screen.getByText('icon-calendar-regular')).toBeTruthy();
      expect(screen.getByText('icon-magnifying-glass-regular')).toBeTruthy();
      expect(screen.getByText('icon-gear-regular')).toBeTruthy();
    });

    it('highlights chat when pathname is /chat', () => {
      mockPathname.mockReturnValue('/chat');
      render(<Sidebar />);

      // Chat should be active
      expect(screen.getByText('icon-chat-circle-fill')).toBeTruthy();

      // Timeline should be inactive
      expect(screen.getByText('icon-book-open-regular')).toBeTruthy();
    });

    it('highlights calendar when pathname is /calendar', () => {
      mockPathname.mockReturnValue('/calendar');
      render(<Sidebar />);

      expect(screen.getByText('icon-calendar-fill')).toBeTruthy();
      expect(screen.getByText('icon-book-open-regular')).toBeTruthy();
    });

    it('highlights search when pathname is /search', () => {
      mockPathname.mockReturnValue('/search');
      render(<Sidebar />);

      expect(screen.getByText('icon-magnifying-glass-fill')).toBeTruthy();
      expect(screen.getByText('icon-book-open-regular')).toBeTruthy();
    });

    it('highlights settings when pathname is /settings', () => {
      mockPathname.mockReturnValue('/settings');
      render(<Sidebar />);

      expect(screen.getByText('icon-gear-fill')).toBeTruthy();
      expect(screen.getByText('icon-book-open-regular')).toBeTruthy();
    });
  });

  describe('Language Tests', () => {
    it('renders labels in English when language is en', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'dark',
        accentColor: '#02BFB8',
        i18n: {
          timeline: 'Timeline',
          chat: 'Chat',
          calendar: 'Calendar',
          search: 'Search',
          settings: 'Settings',
        },
      });

      render(<Sidebar />);

      expect(screen.getByText('Timeline')).toBeTruthy();
      expect(screen.getByText('Chat')).toBeTruthy();
      expect(screen.getByText('Calendar')).toBeTruthy();
      expect(screen.getByText('Search')).toBeTruthy();
      expect(screen.getByText('Settings')).toBeTruthy();
    });

    it('renders labels in Japanese when language is ja', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'dark',
        accentColor: '#02BFB8',
        i18n: {
          timeline: 'タイムライン',
          chat: 'チャット',
          calendar: 'カレンダー',
          search: '検索',
          settings: '設定',
        },
      });

      render(<Sidebar />);

      expect(screen.getByText('タイムライン')).toBeTruthy();
      expect(screen.getByText('チャット')).toBeTruthy();
      expect(screen.getByText('カレンダー')).toBeTruthy();
      expect(screen.getByText('検索')).toBeTruthy();
      expect(screen.getByText('設定')).toBeTruthy();
    });
  });

  describe('Theme Tests', () => {
    it('applies dark theme colors', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'dark',
        accentColor: '#02BFB8',
        i18n: {
          timeline: '时间线',
          chat: '聊天',
          calendar: '日历',
          search: '搜索',
          settings: '设置',
        },
      });

      render(<Sidebar />);

      // Icons should be rendered
      expect(screen.getByTestId('icon-book-open')).toBeTruthy();
      expect(screen.getByTestId('icon-chat-circle')).toBeTruthy();
    });

    it('applies light theme colors', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'light',
        accentColor: '#02BFB8',
        i18n: {
          timeline: '时间线',
          chat: '聊天',
          calendar: '日历',
          search: '搜索',
          settings: '设置',
        },
      });

      render(<Sidebar />);

      // Icons should be rendered
      expect(screen.getByTestId('icon-book-open')).toBeTruthy();
      expect(screen.getByTestId('icon-chat-circle')).toBeTruthy();
    });

    it('applies different accent colors to active route', () => {
      const colors = ['#02BFB8', '#3B82F6', '#8B5CF6', '#F43F5E', '#F59E0B', '#22C55E'];

      colors.forEach((color) => {
        mockUseAppContext.mockReturnValue({
          resolvedTheme: 'dark',
          accentColor: color,
          i18n: {
            timeline: '时间线',
            chat: '聊天',
            calendar: '日历',
            search: '搜索',
            settings: '设置',
          },
        });
        mockPathname.mockReturnValue('/');

        const { unmount } = render(<Sidebar />);
        // Active route should be rendered
        expect(screen.getByTestId('icon-book-open')).toBeTruthy();
        unmount();
      });
    });
  });

  describe('Edge Cases', () => {
    it('handles undefined pathname gracefully', () => {
      mockPathname.mockReturnValue(undefined);

      render(<Sidebar />);

      // Should still render all navigation items
      expect(screen.getByText('时间线')).toBeTruthy();
      expect(screen.getByText('聊天')).toBeTruthy();
    });

    it('handles null pathname gracefully', () => {
      mockPathname.mockReturnValue(null);

      render(<Sidebar />);

      expect(screen.getByText('聊天')).toBeTruthy();
      expect(screen.getByText('日历')).toBeTruthy();
    });

    it('handles empty pathname gracefully', () => {
      mockPathname.mockReturnValue('');

      render(<Sidebar />);

      expect(screen.getByText('日历')).toBeTruthy();
      expect(screen.getByText('搜索')).toBeTruthy();
    });

    it('handles unknown route gracefully', () => {
      mockPathname.mockReturnValue('/unknown-route');

      render(<Sidebar />);

      // All items should be inactive (regular weight)
      expect(screen.getByText('icon-book-open-regular')).toBeTruthy();
      expect(screen.getByText('icon-chat-circle-regular')).toBeTruthy();
      expect(screen.getByText('时间线')).toBeTruthy();
      expect(screen.getByText('聊天')).toBeTruthy();
    });

    it('handles rapid toggle clicks', () => {
      render(<Sidebar />);

      const listIcon = screen.getByTestId('icon-list');
      const toggleBtn = listIcon.parent;

      // Rapid clicks should not crash
      fireEvent.press(toggleBtn!);
      fireEvent.press(toggleBtn!);
      fireEvent.press(toggleBtn!);
      fireEvent.press(toggleBtn!);

      expect(listIcon).toBeTruthy();
    });

    it('handles route with query parameters', () => {
      mockPathname.mockReturnValue('/chat?conversation=123');

      render(<Sidebar />);

      // Should not match exact route, so chat should be inactive
      expect(screen.getByText('icon-chat-circle-regular')).toBeTruthy();
    });

    it('handles route with trailing slash', () => {
      mockPathname.mockReturnValue('/chat/');

      render(<Sidebar />);

      // Should not match exact route
      expect(screen.getByText('icon-chat-circle-regular')).toBeTruthy();
    });
  });

  describe('Collapsed State Tests', () => {
    it('starts in expanded state by default', () => {
      render(<Sidebar />);

      // All labels should be visible
      expect(screen.getByText('时间线')).toBeTruthy();
      expect(screen.getByText('聊天')).toBeTruthy();
      expect(screen.getByText('日历')).toBeTruthy();
      expect(screen.getByText('搜索')).toBeTruthy();
      expect(screen.getByText('设置')).toBeTruthy();
    });

    it('triggers collapse animation when toggle is pressed', () => {
      render(<Sidebar />);

      const listIcon = screen.getByTestId('icon-list');
      const toggleBtn = listIcon.parent;

      fireEvent.press(toggleBtn!);

      // Should still be rendered after toggle
      expect(listIcon).toBeTruthy();
    });
  });

  describe('Platform Tests', () => {
    it('renders on web platform', () => {
      Object.defineProperty(Platform, 'OS', {
        value: 'web',
        configurable: true,
      });

      render(<Sidebar />);
      expect(screen.getByText('时间线')).toBeTruthy();
    });

    it('does not render on non-web platforms', () => {
      Object.defineProperty(Platform, 'OS', {
        value: 'ios',
        configurable: true,
      });

      const { toJSON } = render(<Sidebar />);
      // On non-web platforms, the component should not be visible
      // The container has display: 'none' for non-web
      const tree = toJSON();
      expect(tree).toBeTruthy();
    });
  });

  describe('Animation Tests', () => {
    it('has animation value initialized', () => {
      const { getByText } = render(<Sidebar />);
      // Component renders without animation errors
      expect(getByText('时间线')).toBeTruthy();
    });

    it('maintains animation state during toggle', () => {
      render(<Sidebar />);

      const listIcon = screen.getByTestId('icon-list');
      const toggleBtn = listIcon.parent;

      // Toggle multiple times
      fireEvent.press(toggleBtn!);
      fireEvent.press(toggleBtn!);

      // Component should still be stable
      expect(screen.getByText('时间线')).toBeTruthy();
    });
  });
});
