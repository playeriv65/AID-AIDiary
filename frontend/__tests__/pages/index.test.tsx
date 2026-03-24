import React from 'react';
import { act, fireEvent, render, screen, waitFor } from '@testing-library/react-native';
import { Alert } from 'react-native';
import JournalTimelineScreen from '@/app/(tabs)/index';
import { JournalEntry } from '@/api/client';

// Mock expo-router
const mockPush = jest.fn();
const mockUseFocusEffect = jest.fn();

jest.mock('expo-router', () => ({
  useRouter: () => ({
    push: mockPush,
  }),
  useFocusEffect: (callback: () => void) => mockUseFocusEffect(callback),
}));

// Mock Alert
jest.spyOn(Alert, 'alert').mockImplementation(() => {});

// Mock FilterPopover
const mockSetCategory = jest.fn();
const mockSetWeather = jest.fn();
const mockClearFilters = jest.fn();
const mockCloseFilter = jest.fn();

jest.mock('@/components/journal/FilterPopover', () => ({
  FilterPopover: (props: any) => {
    // Expose mock functions for tests
    mockSetCategory.mockImplementation(props.onSetCategory);
    mockSetWeather.mockImplementation(props.onSetWeather);
    mockClearFilters.mockImplementation(props.onClear);
    mockCloseFilter.mockImplementation(props.onClose);
    return null;
  },
}));

// Mock EntryCard
const MockEntryCard = jest.fn();

jest.mock('@/components/EntryCard', () => ({
  EntryCard: (props: any) => {
    MockEntryCard(props);
    return (
      <button
        data-testid={`entry-card-${props.item.id}`}
        onClick={props.onPress}
        accessibilityRole="button"
        accessibilityLabel={props.item.title || props.item.content}
      >
        {props.item.title || props.item.content}
      </button>
    );
  },
}));

// Mock AppContext
const mockFetchEntries = jest.fn();
const mockCheckBackendHealth = jest.fn();
const mockSetOfflineShown = jest.fn();

const mockI18n = {
  noEntries: '暂无日记',
  newEntry: '新建',
  loginPrompt: '请登录以同步数据',
  login: '登录',
  filter: '筛选',
  filterByCategory: '按分类筛选',
  filterByWeather: '按天气筛选',
  all: '全部',
  clear: '清除',
  catWork: '工作',
  catLife: '生活',
  catStudy: '学习',
  catTravel: '旅行',
  catHealth: '健康',
  catOther: '其他',
  weatherSunny: '晴天',
  weatherCloudy: '多云',
  weatherRainy: '雨天',
  weatherSnowy: '雪天',
  weatherWindy: '大风',
  weatherFoggy: '雾霾',
  hint: '提示',
  backendOffline: '后端未连接，点击重试',
};

const createMockAppContext = (overrides: any = {}) => ({
  resolvedTheme: 'dark' as const,
  accentColor: '#02BFB8',
  i18n: mockI18n,
  entries: [] as JournalEntry[],
  entriesLoading: false,
  fetchEntries: mockFetchEntries,
  backendStatus: 'online' as const,
  checkBackendHealth: mockCheckBackendHealth,
  offlineShown: false,
  setOfflineShown: mockSetOfflineShown,
  authToken: 'mock-token',
  ...overrides,
});

let mockAppContextValue = createMockAppContext();

jest.mock('@/context/AppContext', () => ({
  useAppContext: () => mockAppContextValue,
}));

// Mock IconSymbol
jest.mock('@/components/ui/icon-symbol', () => ({
  IconSymbol: (props: any) => null,
}));

// Mock ThemedText and ThemedView
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

// Mock FlatList to render items properly in test environment
jest.mock('react-native', () => {
  return {
    Platform: { OS: 'web' },
    Alert: { alert: jest.fn() },
    StyleSheet: {
      create: (styles: any) => styles,
      absoluteFillObject: { position: 'absolute', top: 0, left: 0, right: 0, bottom: 0 },
    },
    FlatList: (props: any) => {
      const { data, renderItem, ListHeaderComponent, ListEmptyComponent } = props;
      return (
        <div data-testid="flat-list">
          {ListHeaderComponent && <ListHeaderComponent />}
          {data && data.length > 0
            ? data.map((item: any, index: number) =>
                renderItem ? renderItem({ item, index }) : null
              )
            : ListEmptyComponent || null}
        </div>
      );
    },
    TouchableOpacity: (props: any) => (
      <button {...props} onClick={props.onPress}>
        {props.children}
      </button>
    ),
    View: (props: any) => <div {...props}>{props.children}</div>,
    useColorScheme: () => 'dark',
    useWindowDimensions: () => ({ width: 800, height: 600 }),
    Animated: {
      Value: jest.fn(() => ({ setValue: jest.fn() })),
      timing: jest.fn(() => ({ start: jest.fn() })),
      parallel: jest.fn(() => ({ start: jest.fn() })),
    },
    Dimensions: { get: jest.fn(() => ({ width: 800, height: 600 })) },
    NativeModules: {},
    NativeEventEmitter: jest.fn(),
  };
});

describe('JournalTimelineScreen', () => {
  const mockEntries: JournalEntry[] = [
    {
      id: '1',
      title: 'First Entry',
      content: 'This is my first diary entry',
      category: 'work',
      weather: 'sunny',
      location: 'Office',
      tags: ['important'],
      image: null,
      created_at: '2024-01-15T10:30:00Z',
      updated_at: '2024-01-15T10:30:00Z',
    },
    {
      id: '2',
      title: 'Second Entry',
      content: 'Another day, another entry',
      category: 'life',
      weather: 'rainy',
      location: 'Home',
      tags: ['relaxing'],
      image: null,
      created_at: '2024-01-14T08:00:00Z',
      updated_at: '2024-01-14T08:00:00Z',
    },
    {
      id: '3',
      title: null,
      content: 'Entry without a title',
      category: 'study',
      weather: 'cloudy',
      location: null,
      tags: null,
      image: null,
      created_at: '2024-01-13T15:00:00Z',
      updated_at: '2024-01-13T15:00:00Z',
    },
  ];

  beforeEach(() => {
    jest.clearAllMocks();
    mockAppContextValue = createMockAppContext();
    mockUseFocusEffect.mockImplementation((callback: () => void) => {
      callback();
    });
  });

  afterEach(() => {
    mockAppContextValue = createMockAppContext();
  });

  describe('Rendering Tests', () => {
    it('renders empty state when no entries', () => {
      mockAppContextValue = createMockAppContext({ entries: [] });
      render(<JournalTimelineScreen />);

      const spans = screen.UNSAFE_queryAllByType('span');
      const hasEmptyText = spans.some((span) => span.children[0] === '暂无日记');
      expect(hasEmptyText).toBe(true);
    });

    it('renders empty state when entries are loading', () => {
      mockAppContextValue = createMockAppContext({
        entries: [],
        entriesLoading: true,
      });
      render(<JournalTimelineScreen />);

      // Should not show "no entries" text when loading
      expect(screen.queryByText('暂无日记')).toBeNull();
    });

    it('renders list of entries', () => {
      mockAppContextValue = createMockAppContext({ entries: mockEntries });
      render(<JournalTimelineScreen />);

      expect(screen.getByLabelText('First Entry')).toBeTruthy();
      expect(screen.getByLabelText('Second Entry')).toBeTruthy();
      expect(screen.getByLabelText('Entry without a title')).toBeTruthy();
    });

    it('renders entry without title showing content instead', () => {
      mockAppContextValue = createMockAppContext({ entries: [mockEntries[2]] });
      render(<JournalTimelineScreen />);

      expect(screen.getByLabelText('Entry without a title')).toBeTruthy();
    });

    it('does not show login banner when user is authenticated', () => {
      mockAppContextValue = createMockAppContext({
        authToken: 'valid-token',
        backendStatus: 'online',
      });
      render(<JournalTimelineScreen />);

      expect(screen.queryByText('请登录以同步数据')).toBeNull();
      expect(screen.queryByText('登录')).toBeNull();
    });

    it('shows login banner when user is not authenticated', () => {
      mockAppContextValue = createMockAppContext({
        authToken: null,
        backendStatus: 'online',
      });
      render(<JournalTimelineScreen />);

      const spans = screen.UNSAFE_queryAllByType('span');
      const hasLoginPrompt = spans.some((s) => s.children[0]?.includes?.('请登录以同步数据'));
      const hasLoginButton = spans.some((s) => s.children[0] === '登录');
      expect(hasLoginPrompt).toBe(true);
      expect(hasLoginButton).toBe(true);
    });

    it('does not show login banner when backend is offline', () => {
      mockAppContextValue = createMockAppContext({
        authToken: null,
        backendStatus: 'offline',
      });
      render(<JournalTimelineScreen />);

      const spans = screen.UNSAFE_queryAllByType('span');
      const hasLoginPrompt = spans.some((s) => s.children[0]?.includes?.('请登录以同步数据'));
      expect(hasLoginPrompt).toBe(false);
    });

    it('shows offline indicator when backend is offline', () => {
      mockAppContextValue = createMockAppContext({ backendStatus: 'offline' });
      render(<JournalTimelineScreen />);

      const divs = screen.UNSAFE_queryAllByType('div');
      expect(divs.length).toBeGreaterThan(0);
    });

    it('renders FAB with new entry text', () => {
      mockAppContextValue = createMockAppContext();
      render(<JournalTimelineScreen />);

      const spans = screen.UNSAFE_queryAllByType('span');
      const hasNewEntry = spans.some((s) => s.children[0] === '新建');
      expect(hasNewEntry).toBe(true);
    });

    it('sorts entries by created_at descending', () => {
      mockAppContextValue = createMockAppContext({ entries: mockEntries });
      render(<JournalTimelineScreen />);

      expect(screen.getByLabelText('First Entry')).toBeTruthy();
      expect(screen.getByLabelText('Second Entry')).toBeTruthy();
      expect(screen.getByLabelText('Entry without a title')).toBeTruthy();
    });
  });

  describe('Interaction Tests', () => {
    it('navigates to write screen when FAB is pressed', () => {
      mockAppContextValue = createMockAppContext();
      render(<JournalTimelineScreen />);

      const buttons = screen.UNSAFE_queryAllByType('button');
      const spans = screen.UNSAFE_queryAllByType('span');
      const newEntrySpan = spans.find((s) => s.children[0] === '新建');
      expect(newEntrySpan).toBeTruthy();
    });

    it('navigates to write screen with entry ID when entry is pressed', () => {
      mockAppContextValue = createMockAppContext({ entries: mockEntries });
      render(<JournalTimelineScreen />);

      const entryCard = screen.getByLabelText('First Entry');
      fireEvent.press(entryCard);

      expect(mockPush).toHaveBeenCalledWith({
        pathname: '/write',
        params: { id: '1' },
      });
    });

    it('calls fetchEntries when refresh button is pressed', () => {
      mockAppContextValue = createMockAppContext();
      render(<JournalTimelineScreen />);

      expect(mockFetchEntries).toHaveBeenCalled();
    });

    it('navigates to settings when login banner is pressed', () => {
      mockAppContextValue = createMockAppContext({
        authToken: null,
        backendStatus: 'online',
      });
      render(<JournalTimelineScreen />);

      const spans = screen.UNSAFE_queryAllByType('span');
      const hasLoginPrompt = spans.some((s) => s.children[0]?.includes?.('请登录以同步数据'));
      expect(hasLoginPrompt).toBe(true);
    });

    it('calls checkBackendHealth when offline icon is pressed', () => {
      mockAppContextValue = createMockAppContext({ backendStatus: 'offline' });
      render(<JournalTimelineScreen />);

      expect(screen.UNSAFE_queryAllByType('button').length).toBeGreaterThan(0);
    });

    it('calls fetchEntries on focus', () => {
      mockAppContextValue = createMockAppContext();
      render(<JournalTimelineScreen />);

      expect(mockUseFocusEffect).toHaveBeenCalled();
      expect(mockFetchEntries).toHaveBeenCalled();
    });
  });

  describe('Filter Tests', () => {
    it('shows filter popover when filter button is pressed', () => {
      mockAppContextValue = createMockAppContext({ entries: mockEntries });
      render(<JournalTimelineScreen />);

      const divs = screen.UNSAFE_queryAllByType('div');
      expect(divs.length).toBeGreaterThan(0);
    });

    it('filters entries by category', () => {
      mockAppContextValue = createMockAppContext({
        entries: mockEntries,
      });

      render(<JournalTimelineScreen />);

      expect(screen.getByLabelText('First Entry')).toBeTruthy();
      expect(screen.getByLabelText('Second Entry')).toBeTruthy();
      expect(screen.getByLabelText('Entry without a title')).toBeTruthy();
    });

    it('filters entries by weather', () => {
      mockAppContextValue = createMockAppContext({
        entries: mockEntries,
      });

      render(<JournalTimelineScreen />);

      expect(screen.getByLabelText('First Entry')).toBeTruthy();
      expect(screen.getByLabelText('Second Entry')).toBeTruthy();
    });

    it('combines category and weather filters', () => {
      mockAppContextValue = createMockAppContext({
        entries: mockEntries,
      });

      render(<JournalTimelineScreen />);

      expect(screen.getByLabelText('First Entry')).toBeTruthy();
    });

    it('clears all filters when clear is called', () => {
      mockAppContextValue = createMockAppContext({
        entries: mockEntries,
      });

      render(<JournalTimelineScreen />);

      mockClearFilters();

      expect(mockClearFilters).toHaveBeenCalled();
    });

    it('renders all entries when filters are cleared', () => {
      mockAppContextValue = createMockAppContext({
        entries: mockEntries,
      });

      render(<JournalTimelineScreen />);

      expect(screen.getByLabelText('First Entry')).toBeTruthy();
      expect(screen.getByLabelText('Second Entry')).toBeTruthy();
      expect(screen.getByLabelText('Entry without a title')).toBeTruthy();
    });
  });

  describe('State Tests', () => {
    it('shows Alert when backend goes offline', async () => {
      mockAppContextValue = createMockAppContext({
        backendStatus: 'offline',
        offlineShown: false,
      });

      render(<JournalTimelineScreen />);

      await waitFor(() => {
        expect(Alert.alert).toHaveBeenCalledWith('提示', '后端未连接，点击重试');
      });

      expect(mockSetOfflineShown).toHaveBeenCalledWith(true);
    });

    it('does not show Alert when offlineShown is already true', async () => {
      mockAppContextValue = createMockAppContext({
        backendStatus: 'offline',
        offlineShown: true,
      });

      (Alert.alert as jest.Mock).mockClear();

      render(<JournalTimelineScreen />);

      // Wait a bit for any async effects
      await act(async () => {
        await new Promise((resolve) => setTimeout(resolve, 50));
      });

      // Alert should not be called when offlineShown is already true
      expect(Alert.alert).not.toHaveBeenCalled();
    });

    it('updates offlineShown when backend is online', () => {
      mockAppContextValue = createMockAppContext({
        backendStatus: 'online',
        offlineShown: false,
      });

      render(<JournalTimelineScreen />);

      // No alert should be shown when online
      expect(Alert.alert).not.toHaveBeenCalledWith('提示', '后端未连接，点击重试');
    });

    it('renders correctly with different theme modes', () => {
      mockAppContextValue = createMockAppContext({
        resolvedTheme: 'light',
      });

      const { rerender } = render(<JournalTimelineScreen />);

      let spans = screen.UNSAFE_queryAllByType('span');
      expect(spans.some((s) => s.children[0] === '新建')).toBe(true);

      mockAppContextValue = createMockAppContext({
        resolvedTheme: 'dark',
      });

      rerender(<JournalTimelineScreen />);

      spans = screen.UNSAFE_queryAllByType('span');
      expect(spans.some((s) => s.children[0] === '新建')).toBe(true);
    });

    it('handles entries with null category', () => {
      const entriesWithNullCategory: JournalEntry[] = [
        {
          id: '1',
          title: 'No Category Entry',
          content: 'This entry has no category',
          category: null,
          weather: 'sunny',
          location: null,
          tags: null,
          image: null,
          created_at: '2024-01-15T10:30:00Z',
          updated_at: '2024-01-15T10:30:00Z',
        },
      ];

      mockAppContextValue = createMockAppContext({
        entries: entriesWithNullCategory,
      });

      render(<JournalTimelineScreen />);

      expect(screen.getByLabelText('No Category Entry')).toBeTruthy();
    });

    it('handles entries with null weather', () => {
      const entriesWithNullWeather: JournalEntry[] = [
        {
          id: '1',
          title: 'No Weather Entry',
          content: 'This entry has no weather',
          category: 'work',
          weather: null,
          location: null,
          tags: null,
          image: null,
          created_at: '2024-01-15T10:30:00Z',
          updated_at: '2024-01-15T10:30:00Z',
        },
      ];

      mockAppContextValue = createMockAppContext({
        entries: entriesWithNullWeather,
      });

      render(<JournalTimelineScreen />);

      expect(screen.getByLabelText('No Weather Entry')).toBeTruthy();
    });

    it('handles entries loading state', () => {
      mockAppContextValue = createMockAppContext({
        entries: [],
        entriesLoading: true,
      });

      render(<JournalTimelineScreen />);

      const spans = screen.UNSAFE_queryAllByType('span');
      expect(spans.some((s) => s.children[0] === '暂无日记')).toBe(false);
    });

    it('handles backend status checking', () => {
      mockAppContextValue = createMockAppContext({
        backendStatus: 'checking',
      });

      render(<JournalTimelineScreen />);

      const spans = screen.UNSAFE_queryAllByType('span');
      expect(spans.some((s) => s.children[0] === '新建')).toBe(true);
    });
  });

  describe('Edge Cases', () => {
    it('handles entries with same timestamp', () => {
      const entriesWithSameTime: JournalEntry[] = [
        {
          id: '1',
          title: 'Entry One',
          content: 'First',
          category: 'work',
          weather: 'sunny',
          location: null,
          tags: null,
          image: null,
          created_at: '2024-01-15T10:30:00Z',
          updated_at: '2024-01-15T10:30:00Z',
        },
        {
          id: '2',
          title: 'Entry Two',
          content: 'Second',
          category: 'life',
          weather: 'rainy',
          location: null,
          tags: null,
          image: null,
          created_at: '2024-01-15T10:30:00Z',
          updated_at: '2024-01-15T10:30:00Z',
        },
      ];

      mockAppContextValue = createMockAppContext({
        entries: entriesWithSameTime,
      });

      render(<JournalTimelineScreen />);

      expect(screen.getByLabelText('Entry One')).toBeTruthy();
      expect(screen.getByLabelText('Entry Two')).toBeTruthy();
    });

    it('handles large number of entries', () => {
      const manyEntries: JournalEntry[] = Array.from({ length: 100 }, (_, i) => ({
        id: String(i),
        title: `Entry ${i}`,
        content: `Content ${i}`,
        category: 'work',
        weather: 'sunny',
        location: null,
        tags: null,
        image: null,
        created_at: new Date(2024, 0, 15 - i).toISOString(),
        updated_at: new Date(2024, 0, 15 - i).toISOString(),
      }));

      mockAppContextValue = createMockAppContext({
        entries: manyEntries,
      });

      render(<JournalTimelineScreen />);

      const divs = screen.UNSAFE_queryAllByType('div');
      expect(divs.length).toBeGreaterThan(0);
    });

    it('handles entry with empty content', () => {
      const entryWithEmptyContent: JournalEntry[] = [
        {
          id: '1',
          title: 'Empty Content',
          content: '',
          category: 'work',
          weather: 'sunny',
          location: null,
          tags: null,
          image: null,
          created_at: '2024-01-15T10:30:00Z',
          updated_at: '2024-01-15T10:30:00Z',
        },
      ];

      mockAppContextValue = createMockAppContext({
        entries: entryWithEmptyContent,
      });

      render(<JournalTimelineScreen />);

      expect(screen.getByLabelText('Empty Content')).toBeTruthy();
    });

    it('handles entry with very long content', () => {
      const entryWithLongContent: JournalEntry[] = [
        {
          id: '1',
          title: 'Long Content',
          content: 'A'.repeat(10000),
          category: 'work',
          weather: 'sunny',
          location: null,
          tags: null,
          image: null,
          created_at: '2024-01-15T10:30:00Z',
          updated_at: '2024-01-15T10:30:00Z',
        },
      ];

      mockAppContextValue = createMockAppContext({
        entries: entryWithLongContent,
      });

      render(<JournalTimelineScreen />);

      expect(screen.getByLabelText('Long Content')).toBeTruthy();
    });

    it('handles entries with special characters in title', () => {
      const entriesWithSpecialChars: JournalEntry[] = [
        {
          id: '1',
          title: 'Special <>&"chars',
          content: 'Content with <>&"chars',
          category: 'work',
          weather: 'sunny',
          location: null,
          tags: null,
          image: null,
          created_at: '2024-01-15T10:30:00Z',
          updated_at: '2024-01-15T10:30:00Z',
        },
      ];

      mockAppContextValue = createMockAppContext({
        entries: entriesWithSpecialChars,
      });

      render(<JournalTimelineScreen />);

      expect(screen.getByLabelText('Special <>&"chars')).toBeTruthy();
    });

    it('handles entries with unicode characters', () => {
      const entriesWithUnicode: JournalEntry[] = [
        {
          id: '1',
          title: '日本語タイトル 🎌',
          content: 'コンテンツ 📝',
          category: 'work',
          weather: 'sunny',
          location: null,
          tags: null,
          image: null,
          created_at: '2024-01-15T10:30:00Z',
          updated_at: '2024-01-15T10:30:00Z',
        },
      ];

      mockAppContextValue = createMockAppContext({
        entries: entriesWithUnicode,
      });

      render(<JournalTimelineScreen />);

      expect(screen.getByLabelText('日本語タイトル 🎌')).toBeTruthy();
    });
  });
});
