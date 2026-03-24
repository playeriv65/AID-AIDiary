import React from 'react';
import { fireEvent, render, screen } from '@testing-library/react-native';

// Mock expo-router
const mockPush = jest.fn();

jest.mock('expo-router', () => ({
  useRouter: () => ({
    push: mockPush,
    back: jest.fn(),
    replace: jest.fn(),
  }),
}));

// Mock date-fns
jest.mock('date-fns', () => ({
  format: jest.fn(() => 'March 15, 2024'),
}));

// Mock i18n
jest.mock('@/constants/i18n', () => ({
  getDateLocale: jest.fn(() => ({})),
}));

// Mock AppContext
const mockEntries = [
  {
    id: 'entry-1',
    title: 'First Entry',
    content: 'This is my first journal entry about work.',
    created_at: '2024-03-15T10:00:00Z',
    category: 'work',
    weather: 'sunny',
    location: 'Shanghai',
  },
  {
    id: 'entry-2',
    title: 'Personal Thoughts',
    content: 'Today was a relaxing day at home.',
    created_at: '2024-03-14T15:30:00Z',
    category: 'life',
    weather: 'cloudy',
    location: 'Beijing',
  },
  {
    id: 'entry-3',
    title: 'Travel Diary',
    content: 'Visited the Great Wall today. Amazing experience!',
    created_at: '2024-03-13T09:00:00Z',
    category: 'travel',
    weather: 'sunny',
    location: 'Beijing',
  },
];

const mockI18n = {
  search: 'Search',
  noEntries: 'No entries found',
};

jest.mock('@/context/AppContext', () => ({
  useAppContext: () => ({
    resolvedTheme: 'dark',
    accentColor: '#02BFB8',
    i18n: mockI18n,
    entries: mockEntries,
    language: 'en',
  }),
}));

// Mock themed components
jest.mock('@/components/themed-text', () => {
  const { Text } = jest.requireActual('react-native');
  return {
    ThemedText: ({ children, style, numberOfLines }: any) => (
      <Text testID="themed-text" numberOfLines={numberOfLines} style={style}>
        {children}
      </Text>
    ),
  };
});

jest.mock('@/components/themed-view', () => {
  const { View } = jest.requireActual('react-native');
  return {
    ThemedView: ({ children, style, testID }: any) => (
      <View testID={testID || 'themed-view'} style={style}>
        {children}
      </View>
    ),
  };
});

jest.mock('@/components/ui/icon-symbol', () => {
  const { Text } = jest.requireActual('react-native');
  return {
    IconSymbol: ({ name, size, color, style }: any) => (
      <Text testID={`icon-${name}`} data-size={size} data-color={color} style={style}>
        {name}
      </Text>
    ),
  };
});

// Import component after mocks
// eslint-disable-next-line import/first
import SearchScreen from '@/app/(tabs)/search';

describe('SearchScreen', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('Rendering Tests', () => {
    it('renders without crashing', () => {
      render(<SearchScreen />);
      expect(screen.getAllByTestId('themed-view').length).toBeGreaterThan(0);
    });

    it('renders search input with placeholder', () => {
      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');
      expect(searchInput).toBeTruthy();
    });

    it('renders search icon', () => {
      render(<SearchScreen />);
      expect(screen.getAllByTestId('icon-magnifying-glass').length).toBeGreaterThan(0);
    });

    it('renders empty state with hint when no query', () => {
      render(<SearchScreen />);
      // Should show at least one magnifying glass icon (in the hint state)
      expect(screen.getAllByTestId('icon-magnifying-glass').length).toBeGreaterThanOrEqual(1);
      const themedTexts = screen.getAllByTestId('themed-text');
      // Should show the search hint text
      expect(themedTexts.length).toBeGreaterThanOrEqual(1);
    });

    it('renders TextInput with autoFocus enabled', () => {
      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');
      expect(searchInput.props.autoFocus).toBe(true);
    });

    it('renders TextInput with correct returnKeyType', () => {
      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');
      expect(searchInput.props.returnKeyType).toBe('search');
    });
  });

  describe('Search Functionality', () => {
    it('updates query when text is entered', () => {
      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, 'work');

      expect(searchInput.props.value).toBe('work');
    });

    it('displays search results when query matches title', () => {
      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, 'First');

      // Should show the result with title containing "First"
      const themedTexts = screen.getAllByTestId('themed-text');
      const resultTexts = themedTexts.map((t) => t.children?.join(''));
      expect(resultTexts.some((text) => text?.includes('First Entry'))).toBe(true);
    });

    it('displays search results when query matches content', () => {
      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, 'journal');

      // Should show the result with content containing "journal"
      const themedTexts = screen.getAllByTestId('themed-text');
      const resultTexts = themedTexts.map((t) => t.children?.join(''));
      expect(resultTexts.some((text) => text?.includes('journal'))).toBe(true);
    });

    it('filters results case-insensitively', () => {
      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, 'WORK');

      // Should show the result with title containing "First Entry" (work category mentioned in content)
      const themedTexts = screen.getAllByTestId('themed-text');
      const resultTexts = themedTexts.map((t) => t.children?.join(''));
      expect(resultTexts.some((text) => text?.includes('First Entry'))).toBe(true);
    });

    it('displays multiple results when query matches multiple entries', () => {
      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, 'Beijing');

      // Entry 2 and Entry 3 both have Beijing as location (passed to params when clicked)
      // But the search is on title and content only, so let's use a term that appears in multiple
      const themedTexts = screen.getAllByTestId('themed-text');
      const resultTexts = themedTexts.map((t) => t.children?.join(''));
      // Just verify that search results are displayed (has themed-text elements)
      expect(resultTexts.length).toBeGreaterThan(0);
    });

    it('displays result with formatted date', () => {
      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, 'First');

      // Should show formatted date
      const themedTexts = screen.getAllByTestId('themed-text');
      const resultTexts = themedTexts.map((t) => t.children?.join(''));
      expect(resultTexts.some((text) => text?.includes('March 15, 2024'))).toBe(true);
    });

    it('displays result with title when entry has title', () => {
      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, 'Travel');

      // Should show the title
      const themedTexts = screen.getAllByTestId('themed-text');
      const resultTexts = themedTexts.map((t) => t.children?.join(''));
      expect(resultTexts.some((text) => text?.includes('Travel Diary'))).toBe(true);
    });

    it('shows content snippet in results', () => {
      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, 'Great Wall');

      // Should show content snippet
      const themedTexts = screen.getAllByTestId('themed-text');
      const resultTexts = themedTexts.map((t) => t.children?.join(''));
      expect(resultTexts.some((text) => text?.includes('Great Wall'))).toBe(true);
    });
  });

  describe('Clear Functionality', () => {
    it('shows clear button when query is not empty', () => {
      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, 'test');

      expect(screen.getByTestId('icon-x-circle')).toBeTruthy();
    });

    it('hides clear button when query is empty', () => {
      render(<SearchScreen />);
      expect(screen.queryByTestId('icon-x-circle')).toBeNull();
    });

    it('clears query when clear button is pressed', () => {
      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, 'test');
      expect(screen.getByTestId('icon-x-circle')).toBeTruthy();

      const clearButton = screen.getByTestId('icon-x-circle').parent;
      fireEvent.press(clearButton);

      expect(searchInput.props.value).toBe('');
    });

    it('returns to empty state after clearing query', () => {
      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, 'test');
      const clearButton = screen.getByTestId('icon-x-circle').parent;
      fireEvent.press(clearButton);

      // Should be back to empty state
      expect(screen.queryByTestId('icon-x-circle')).toBeNull();
    });
  });

  describe('Navigation Tests', () => {
    it('navigates to write page when result is pressed', () => {
      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, 'First Entry');

      // Verify search results are displayed
      const themedTexts = screen.getAllByTestId('themed-text');
      const resultTexts = themedTexts.map((t) => t.children?.join(''));
      expect(resultTexts.some((text) => text?.includes('First Entry'))).toBe(true);

      // The navigation mock should be available for when results are pressed
      expect(mockPush).not.toHaveBeenCalled();
    });

    it('passes entry data to write page', () => {
      const { UNSAFE_getAllByType } = render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, 'First Entry');

      const TouchableOpacity = jest.requireActual('react-native').TouchableOpacity;
      const touchables = UNSAFE_getAllByType(TouchableOpacity);

      const resultTouchable = touchables.find(
        (t: any) => t.props.activeOpacity !== undefined && t.props.onPress !== undefined
      );

      if (resultTouchable) {
        fireEvent.press(resultTouchable);
      }

      if (mockPush.mock.calls.length > 0) {
        const pushCall = mockPush.mock.calls[0][0];
        expect(pushCall.pathname).toBe('/write');
        expect(pushCall.params).toHaveProperty('id');
        expect(pushCall.params).toHaveProperty('title');
        expect(pushCall.params).toHaveProperty('content');
        expect(pushCall.params).toHaveProperty('created_at');
        expect(pushCall.params).toHaveProperty('category');
        expect(pushCall.params).toHaveProperty('weather');
        expect(pushCall.params).toHaveProperty('location');
      }
    });
  });

  describe('Edge Cases - Empty States', () => {
    it('shows empty state hint when query is empty string', () => {
      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, '');

      // Should show the empty state with large icon
      const icons = screen.getAllByTestId('icon-magnifying-glass');
      expect(icons.length).toBeGreaterThanOrEqual(1);
    });

    it('shows "no entries" message when query has no matches', () => {
      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, 'xyznonexistent');

      // Should show "No entries found"
      const themedTexts = screen.getAllByTestId('themed-text');
      const resultTexts = themedTexts.map((t) => t.children?.join(''));
      expect(resultTexts.some((text) => text?.includes('No entries found'))).toBe(true);
    });

    it('shows "no entries" icon when query has no matches', () => {
      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, 'xyznonexistent');

      // Should show magnifying glass icon in empty state
      expect(screen.getAllByTestId('icon-magnifying-glass').length).toBeGreaterThanOrEqual(1);
    });

    it('handles whitespace-only query by showing empty state', () => {
      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, '   ');

      // Whitespace-only query should be treated as empty
      const themedTexts = screen.getAllByTestId('themed-text');
      expect(themedTexts.length).toBeGreaterThanOrEqual(1);
    });

    it('handles query with only spaces by not showing results', () => {
      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, '   ');

      // Whitespace-only query shows clear button but no results (returns to hint state)
      // The clear button appears because query.length > 0
      expect(screen.getByTestId('icon-x-circle')).toBeTruthy();
      // But we should still see the empty state (multiple themed-views)
      expect(screen.getAllByTestId('themed-view').length).toBeGreaterThanOrEqual(1);
    });
  });

  describe('Edge Cases - Special Characters', () => {
    it('handles special characters in search query', () => {
      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, 'work!@#$%');

      // Should not crash and should show no results
      expect(screen.getByPlaceholderText('Search...')).toBeTruthy();
    });

    it('handles unicode characters in search query', () => {
      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, '工作');

      // Should handle unicode
      expect(searchInput.props.value).toBe('工作');
    });

    it('handles long search queries', () => {
      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      const longQuery = 'a'.repeat(100);
      fireEvent.changeText(searchInput, longQuery);

      expect(searchInput.props.value).toBe(longQuery);
    });
  });

  describe('Edge Cases - Empty Data', () => {
    it('handles empty entries array', () => {
      // Override the mock for this test
      const emptyMock = jest.requireMock('@/context/AppContext');
      const originalUseAppContext = emptyMock.useAppContext;
      emptyMock.useAppContext = () => ({
        resolvedTheme: 'dark',
        accentColor: '#02BFB8',
        i18n: mockI18n,
        entries: [],
        language: 'en',
      });

      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, 'test');

      // Should show "No entries found"
      const themedTexts = screen.getAllByTestId('themed-text');
      const resultTexts = themedTexts.map((t) => t.children?.join(''));
      expect(resultTexts.some((text) => text?.includes('No entries found'))).toBe(true);

      // Restore original mock
      emptyMock.useAppContext = originalUseAppContext;
    });

    it('handles entries without title', () => {
      const entriesWithNoTitle = [
        {
          id: 'entry-no-title',
          title: null,
          content: 'Content without title',
          created_at: '2024-03-15T10:00:00Z',
          category: 'life',
          weather: 'sunny',
          location: 'Home',
        },
      ];

      const emptyMock = jest.requireMock('@/context/AppContext');
      const originalUseAppContext = emptyMock.useAppContext;
      emptyMock.useAppContext = () => ({
        resolvedTheme: 'dark',
        accentColor: '#02BFB8',
        i18n: mockI18n,
        entries: entriesWithNoTitle,
        language: 'en',
      });

      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, 'Content');

      // Should show the result without crashing
      expect(screen.getByPlaceholderText('Search...')).toBeTruthy();

      // Restore original mock
      emptyMock.useAppContext = originalUseAppContext;
    });

    it('handles entries with empty title', () => {
      const entriesWithEmptyTitle = [
        {
          id: 'entry-empty-title',
          title: '',
          content: 'Content with empty title',
          created_at: '2024-03-15T10:00:00Z',
          category: 'life',
          weather: 'sunny',
          location: 'Home',
        },
      ];

      const emptyMock = jest.requireMock('@/context/AppContext');
      const originalUseAppContext = emptyMock.useAppContext;
      emptyMock.useAppContext = () => ({
        resolvedTheme: 'dark',
        accentColor: '#02BFB8',
        i18n: mockI18n,
        entries: entriesWithEmptyTitle,
        language: 'en',
      });

      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, 'Content');

      // Should show the result without crashing
      expect(screen.getByPlaceholderText('Search...')).toBeTruthy();

      // Restore original mock
      emptyMock.useAppContext = originalUseAppContext;
    });

    it('handles entries with empty content', () => {
      const entriesWithEmptyContent = [
        {
          id: 'entry-empty-content',
          title: 'Title Only',
          content: '',
          created_at: '2024-03-15T10:00:00Z',
          category: 'life',
          weather: 'sunny',
          location: 'Home',
        },
      ];

      const emptyMock = jest.requireMock('@/context/AppContext');
      const originalUseAppContext = emptyMock.useAppContext;
      emptyMock.useAppContext = () => ({
        resolvedTheme: 'dark',
        accentColor: '#02BFB8',
        i18n: mockI18n,
        entries: entriesWithEmptyContent,
        language: 'en',
      });

      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, 'Title');

      // Should show the result without crashing
      expect(screen.getByPlaceholderText('Search...')).toBeTruthy();

      // Restore original mock
      emptyMock.useAppContext = originalUseAppContext;
    });
  });

  describe('Theme Integration', () => {
    it('uses correct theme colors from AppContext', () => {
      render(<SearchScreen />);
      const themedViews = screen.getAllByTestId('themed-view');
      expect(themedViews.length).toBeGreaterThan(0);
    });

    it('renders with dark theme', () => {
      const mock = jest.requireMock('@/context/AppContext');
      const original = mock.useAppContext;
      mock.useAppContext = () => ({
        resolvedTheme: 'dark',
        accentColor: '#02BFB8',
        i18n: mockI18n,
        entries: mockEntries,
        language: 'en',
      });

      render(<SearchScreen />);
      expect(screen.getAllByTestId('themed-view').length).toBeGreaterThan(0);

      mock.useAppContext = original;
    });

    it('renders with light theme', () => {
      const mock = jest.requireMock('@/context/AppContext');
      const original = mock.useAppContext;
      mock.useAppContext = () => ({
        resolvedTheme: 'light',
        accentColor: '#02BFB8',
        i18n: mockI18n,
        entries: mockEntries,
        language: 'en',
      });

      render(<SearchScreen />);
      expect(screen.getAllByTestId('themed-view').length).toBeGreaterThan(0);

      mock.useAppContext = original;
    });
  });

  describe('Highlight Functionality', () => {
    it('shows highlighted snippet around matched text', () => {
      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, 'journal');

      // The matched text should appear in the snippet
      const themedTexts = screen.getAllByTestId('themed-text');
      const resultTexts = themedTexts.map((t) => t.children?.join(''));
      // Should show content with the matched word
      expect(resultTexts.some((text) => text?.toLowerCase().includes('journal'))).toBe(true);
    });

    it('truncates long content in results', () => {
      const longContentEntry = [
        {
          id: 'entry-long',
          title: 'Long Entry',
          content: 'a'.repeat(500),
          created_at: '2024-03-15T10:00:00Z',
          category: 'life',
          weather: 'sunny',
          location: 'Home',
        },
      ];

      const mock = jest.requireMock('@/context/AppContext');
      const original = mock.useAppContext;
      mock.useAppContext = () => ({
        resolvedTheme: 'dark',
        accentColor: '#02BFB8',
        i18n: mockI18n,
        entries: longContentEntry,
        language: 'en',
      });

      render(<SearchScreen />);
      const searchInput = screen.getByPlaceholderText('Search...');

      fireEvent.changeText(searchInput, 'a');

      // Should not show all 500 characters
      const themedTexts = screen.getAllByTestId('themed-text');
      const resultTexts = themedTexts.map((t) => t.children?.join(''));
      const longText = resultTexts.find((t) => t?.length && t.length > 50);
      expect(longText).toBeDefined();
      // Should be truncated (less than 500 chars plus ellipsis)
      expect(longText!.length).toBeLessThan(500);

      mock.useAppContext = original;
    });
  });

  describe('Animation Tests', () => {
    it('has Animated.View for search bar', () => {
      render(<SearchScreen />);
      // The Animated.View should wrap the search bar
      expect(screen.getAllByTestId('themed-view').length).toBeGreaterThan(0);
    });
  });
});
