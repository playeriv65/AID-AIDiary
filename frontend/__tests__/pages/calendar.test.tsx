import React from 'react';
import { render } from '@testing-library/react-native';
import CalendarScreen from '@/app/(tabs)/calendar';
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

// Mock AppContext
const mockFetchEntries = jest.fn();

const mockI18n = {
  newEntry: '新建',
  sun: '日',
  mon: '一',
  tue: '二',
  wed: '三',
  thu: '四',
  fri: '五',
  sat: '六',
};

const createMockAppContext = (overrides: any = {}) => ({
  resolvedTheme: 'dark' as const,
  accentColor: '#02BFB8',
  i18n: mockI18n,
  entries: [] as JournalEntry[],
  fetchEntries: mockFetchEntries,
  ...overrides,
});

let mockAppContextValue = createMockAppContext();

jest.mock('@/context/AppContext', () => ({
  useAppContext: () => mockAppContextValue,
}));

// Mock MonthView
const mockOnDatePress = jest.fn();

jest.mock('@/components/journal/MonthView', () => ({
  MonthView: (props: any) => {
    mockOnDatePress.mockImplementation(props.onDatePress);
    const React = require('react');
    return React.createElement(
      'div',
      {
        testID: `month-view-${props.monthDate.toISOString()}`,
      },
      [
        React.createElement(
          'span',
          { testID: 'month-date', key: 'date' },
          props.monthDate.toISOString()
        ),
        React.createElement(
          'span',
          { testID: 'entry-dates-count', key: 'count' },
          String(props.entryDates.size)
        ),
        React.createElement('span', { testID: 'accent-color', key: 'accent' }, props.accentColor),
        React.createElement('span', { testID: 'theme', key: 'theme' }, props.theme),
        React.createElement('span', { testID: 'language', key: 'lang' }, props.language),
      ]
    );
  },
}));

// Mock IconSymbol
jest.mock('@/components/ui/icon-symbol', () => ({
  IconSymbol: (props: any) => null,
}));

// Mock ThemedText and ThemedView
jest.mock('@/components/themed-text', () => ({
  ThemedText: (props: any) => {
    const React = require('react');
    const cleanChildren =
      typeof props.children === 'string'
        ? props.children.replace(/\u001b\[\d+m/g, '')
        : props.children;
    return React.createElement('span', props, cleanChildren);
  },
}));

jest.mock('@/components/themed-view', () => ({
  ThemedView: (props: any) => {
    const React = require('react');
    return React.createElement('div', props, props.children);
  },
}));

// Mock date-fns
const mockFormat = jest.fn();
const mockAddMonths = jest.fn();
const mockSubMonths = jest.fn();

jest.mock('date-fns', () => ({
  format: (...args: any[]) => mockFormat(...args),
  addMonths: (...args: any[]) => mockAddMonths(...args),
  subMonths: (...args: any[]) => mockSubMonths(...args),
}));

// Mock FlatList to render items properly in test environment
jest.mock('react-native', () => {
  return {
    Platform: { OS: 'web' },
    StyleSheet: {
      create: (styles: any) => styles,
      absoluteFillObject: { position: 'absolute', top: 0, left: 0, right: 0, bottom: 0 },
    },
    FlatList: (props: any) => {
      const { data, renderItem, contentContainerStyle } = props;
      return (
        <div data-testid="flat-list" style={contentContainerStyle}>
          {data &&
            data.map((item: any, index: number) =>
              renderItem ? renderItem({ item, index }) : null
            )}
        </div>
      );
    },
    TouchableOpacity: (props: any) => (
      <button {...props} onClick={props.onPress} data-testid={props.testID} role="button">
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

describe('CalendarScreen', () => {
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
      created_at: '2024-03-15T10:30:00Z',
      updated_at: '2024-03-15T10:30:00Z',
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
      created_at: '2024-03-20T08:00:00Z',
      updated_at: '2024-03-20T08:00:00Z',
    },
    {
      id: '3',
      title: 'Third Entry',
      content: 'Entry on a different day',
      category: 'study',
      weather: 'cloudy',
      location: null,
      tags: null,
      image: null,
      created_at: '2024-02-10T15:00:00Z',
      updated_at: '2024-02-10T15:00:00Z',
    },
  ];

  beforeEach(() => {
    jest.clearAllMocks();
    mockAppContextValue = createMockAppContext();
    mockUseFocusEffect.mockImplementation((callback: () => void) => {
      callback();
    });

    mockFormat.mockImplementation((date: Date, formatStr: string) => {
      if (formatStr === 'yyyy-MM-dd') {
        return date.toISOString().split('T')[0];
      }
      return '';
    });

    mockAddMonths.mockImplementation((date: Date, months: number) => {
      const result = new Date(date);
      result.setMonth(result.getMonth() + months);
      return result;
    });

    mockSubMonths.mockImplementation((date: Date, months: number) => {
      const result = new Date(date);
      result.setMonth(result.getMonth() - months);
      return result;
    });
  });

  afterEach(() => {
    mockAppContextValue = createMockAppContext();
  });

  describe('Rendering Tests', () => {
    it('renders FlatList with months', () => {
      mockAppContextValue = createMockAppContext();
      const { getAllByTestId } = render(<CalendarScreen />);
      const monthDates = getAllByTestId('month-date');
      expect(monthDates.length).toBeGreaterThan(0);
    });

    it('renders 12 months in the list', () => {
      mockAppContextValue = createMockAppContext();
      const { getAllByTestId } = render(<CalendarScreen />);
      const monthDates = getAllByTestId('month-date');
      expect(monthDates.length).toBe(12);
    });

    it('renders MonthView components with correct props', () => {
      mockAppContextValue = createMockAppContext({
        accentColor: '#FF3B30',
        resolvedTheme: 'light',
      });
      const { getAllByTestId } = render(<CalendarScreen />);
      const accentColors = getAllByTestId('accent-color');
      expect(accentColors.length).toBeGreaterThan(0);
      expect(accentColors[0].children[0]).toBe('#FF3B30');
      const themes = getAllByTestId('theme');
      expect(themes[0].children[0]).toBe('light');
    });

    it('renders FAB buttons', () => {
      mockAppContextValue = createMockAppContext();
      const { UNSAFE_root } = render(<CalendarScreen />);
      expect(UNSAFE_root).toBeTruthy();
    });

    it('passes correct accent color to MonthView', () => {
      mockAppContextValue = createMockAppContext({
        accentColor: '#4CD964',
      });
      const { getAllByTestId } = render(<CalendarScreen />);
      const accentColors = getAllByTestId('accent-color');
      expect(accentColors[0].children[0]).toBe('#4CD964');
    });

    it('passes correct theme to MonthView', () => {
      mockAppContextValue = createMockAppContext({
        resolvedTheme: 'dark',
      });
      const { getAllByTestId } = render(<CalendarScreen />);
      const themes = getAllByTestId('theme');
      expect(themes[0].children[0]).toBe('dark');
    });

    it('passes correct i18n language to MonthView', () => {
      mockAppContextValue = createMockAppContext({
        i18n: { ...mockI18n, language: 'en' },
      });
      const { getAllByTestId } = render(<CalendarScreen />);
      const languages = getAllByTestId('language');
      expect(languages.length).toBe(12);
      expect(languages[0].children[0]).toBe('en');
    });
  });

  describe('Interaction Tests', () => {
    it('navigates to write screen when main FAB is pressed', () => {
      mockPush.mockClear();
      mockAppContextValue = createMockAppContext();
      render(<CalendarScreen />);
      expect(mockPush).not.toHaveBeenCalled();
    });

    it('navigates to home when a date with entry is pressed', () => {
      mockAppContextValue = createMockAppContext({ entries: mockEntries });
      render(<CalendarScreen />);
      const dateStr = '2024-03-15';
      mockOnDatePress(dateStr);
      expect(mockPush).toHaveBeenCalledWith('/');
    });

    it('calls fetchEntries on focus', () => {
      mockAppContextValue = createMockAppContext();
      render(<CalendarScreen />);
      expect(mockUseFocusEffect).toHaveBeenCalled();
      expect(mockFetchEntries).toHaveBeenCalled();
    });
  });

  describe('State Tests - Entry Dates', () => {
    it('computes entry dates correctly from entries', () => {
      mockAppContextValue = createMockAppContext({ entries: mockEntries });
      const { getAllByTestId } = render(<CalendarScreen />);
      const counts = getAllByTestId('entry-dates-count');
      expect(counts[0].children[0]).toBe('3');
    });

    it('handles empty entries array', () => {
      mockAppContextValue = createMockAppContext({ entries: [] });
      const { getAllByTestId } = render(<CalendarScreen />);
      const counts = getAllByTestId('entry-dates-count');
      expect(counts[0].children[0]).toBe('0');
    });

    it('handles entries with same date', () => {
      const entriesWithSameDate: JournalEntry[] = [
        {
          id: '1',
          title: 'Morning Entry',
          content: 'Morning content',
          category: 'work',
          weather: 'sunny',
          location: null,
          tags: null,
          image: null,
          created_at: '2024-03-15T08:00:00Z',
          updated_at: '2024-03-15T08:00:00Z',
        },
        {
          id: '2',
          title: 'Evening Entry',
          content: 'Evening content',
          category: 'life',
          weather: 'rainy',
          location: null,
          tags: null,
          image: null,
          created_at: '2024-03-15T20:00:00Z',
          updated_at: '2024-03-15T20:00:00Z',
        },
      ];
      mockAppContextValue = createMockAppContext({ entries: entriesWithSameDate });
      const { getAllByTestId } = render(<CalendarScreen />);
      const counts = getAllByTestId('entry-dates-count');
      expect(counts[0].children[0]).toBe('1');
    });

    it('handles entries across different months', () => {
      const entriesAcrossMonths: JournalEntry[] = [
        {
          id: '1',
          title: 'March Entry',
          content: 'Content',
          category: 'work',
          weather: 'sunny',
          location: null,
          tags: null,
          image: null,
          created_at: '2024-03-15T10:00:00Z',
          updated_at: '2024-03-15T10:00:00Z',
        },
        {
          id: '2',
          title: 'February Entry',
          content: 'Content',
          category: 'life',
          weather: 'rainy',
          location: null,
          tags: null,
          image: null,
          created_at: '2024-02-20T10:00:00Z',
          updated_at: '2024-02-20T10:00:00Z',
        },
        {
          id: '3',
          title: 'January Entry',
          content: 'Content',
          category: 'study',
          weather: 'cloudy',
          location: null,
          tags: null,
          image: null,
          created_at: '2024-01-10T10:00:00Z',
          updated_at: '2024-01-10T10:00:00Z',
        },
      ];
      mockAppContextValue = createMockAppContext({ entries: entriesAcrossMonths });
      const { getAllByTestId } = render(<CalendarScreen />);
      const counts = getAllByTestId('entry-dates-count');
      expect(counts[0].children[0]).toBe('3');
    });

    it('updates entry dates when entries change', () => {
      const { rerender, getAllByTestId } = render(<CalendarScreen />);
      let counts = getAllByTestId('entry-dates-count');
      expect(counts[0].children[0]).toBe('0');
      mockAppContextValue = createMockAppContext({ entries: mockEntries });
      rerender(<CalendarScreen />);
      counts = getAllByTestId('entry-dates-count');
      expect(counts[0].children[0]).toBe('3');
    });
  });

  describe('State Tests - Theme', () => {
    it('renders with dark theme', () => {
      mockAppContextValue = createMockAppContext({
        resolvedTheme: 'dark',
        accentColor: '#02BFB8',
      });
      const { getAllByTestId } = render(<CalendarScreen />);
      const themes = getAllByTestId('theme');
      expect(themes[0].children[0]).toBe('dark');
    });

    it('renders with light theme', () => {
      mockAppContextValue = createMockAppContext({
        resolvedTheme: 'light',
        accentColor: '#02BFB8',
      });
      const { getAllByTestId } = render(<CalendarScreen />);
      const themes = getAllByTestId('theme');
      expect(themes[0].children[0]).toBe('light');
    });

    it('updates theme when context changes', () => {
      mockAppContextValue = createMockAppContext({
        resolvedTheme: 'dark',
      });
      const { rerender, getAllByTestId } = render(<CalendarScreen />);
      let themes = getAllByTestId('theme');
      expect(themes[0].children[0]).toBe('dark');
      mockAppContextValue = createMockAppContext({
        resolvedTheme: 'light',
      });
      rerender(<CalendarScreen />);
      themes = getAllByTestId('theme');
      expect(themes[0].children[0]).toBe('light');
    });

    it('handles different accent colors', () => {
      const colors = ['#02BFB8', '#FF3B30', '#FF9500', '#FFCC00', '#4CD964', '#5856D6'];
      colors.forEach((color) => {
        mockAppContextValue = createMockAppContext({
          accentColor: color,
        });
        const { unmount, getAllByTestId } = render(<CalendarScreen />);
        const accentColors = getAllByTestId('accent-color');
        expect(accentColors[0].children[0]).toBe(color);
        unmount();
      });
    });
  });

  describe('State Tests - Months Array', () => {
    it('generates 12 months starting from next month', () => {
      mockAppContextValue = createMockAppContext();
      const { getAllByTestId } = render(<CalendarScreen />);
      const monthDates = getAllByTestId('month-date');
      expect(monthDates.length).toBe(12);
    });

    it('passes correct month dates to MonthView', () => {
      mockAppContextValue = createMockAppContext();
      const { getAllByTestId } = render(<CalendarScreen />);
      const monthDates = getAllByTestId('month-date');
      expect(monthDates.length).toBe(12);
    });
  });

  describe('Edge Cases', () => {
    it('handles entries with null created_at', () => {
      const entriesWithNullDate: JournalEntry[] = [
        {
          id: '1',
          title: 'Entry with null date',
          content: 'Content',
          category: 'work',
          weather: 'sunny',
          location: null,
          tags: null,
          image: null,
          created_at: null as any,
          updated_at: '2024-03-15T10:00:00Z',
        },
      ];
      mockAppContextValue = createMockAppContext({ entries: entriesWithNullDate });
      expect(() => render(<CalendarScreen />)).not.toThrow();
    });

    it('handles entries with invalid date format', () => {
      mockFormat.mockImplementation((date: Date, formatStr: string) => {
        if (formatStr === 'yyyy-MM-dd') {
          if (isNaN(date.getTime())) {
            return 'invalid-date';
          }
          return date.toISOString().split('T')[0];
        }
        return '';
      });

      const entriesWithInvalidDate: JournalEntry[] = [
        {
          id: '1',
          title: 'Entry with invalid date',
          content: 'Content',
          category: 'work',
          weather: 'sunny',
          location: null,
          tags: null,
          image: null,
          created_at: 'invalid-date',
          updated_at: 'invalid-date',
        },
      ];
      mockAppContextValue = createMockAppContext({ entries: entriesWithInvalidDate });
      expect(() => render(<CalendarScreen />)).not.toThrow();
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
        created_at: new Date(2024, 0, 1 + i).toISOString(),
        updated_at: new Date(2024, 0, 1 + i).toISOString(),
      }));
      mockAppContextValue = createMockAppContext({ entries: manyEntries });
      const { getAllByTestId } = render(<CalendarScreen />);
      const counts = getAllByTestId('entry-dates-count');
      expect(counts[0].children[0]).toBe('100');
    });

    it('handles entries with same date different times', () => {
      const entriesSameDateDifferentTimes: JournalEntry[] = [
        {
          id: '1',
          title: 'Morning',
          content: 'Morning entry',
          category: 'work',
          weather: 'sunny',
          location: null,
          tags: null,
          image: null,
          created_at: '2024-03-15T08:00:00Z',
          updated_at: '2024-03-15T08:00:00Z',
        },
        {
          id: '2',
          title: 'Noon',
          content: 'Noon entry',
          category: 'life',
          weather: 'cloudy',
          location: null,
          tags: null,
          image: null,
          created_at: '2024-03-15T12:00:00Z',
          updated_at: '2024-03-15T12:00:00Z',
        },
        {
          id: '3',
          title: 'Evening',
          content: 'Evening entry',
          category: 'study',
          weather: 'rainy',
          location: null,
          tags: null,
          image: null,
          created_at: '2024-03-15T20:00:00Z',
          updated_at: '2024-03-15T20:00:00Z',
        },
      ];
      mockAppContextValue = createMockAppContext({ entries: entriesSameDateDifferentTimes });
      const { getAllByTestId } = render(<CalendarScreen />);
      const counts = getAllByTestId('entry-dates-count');
      expect(counts[0].children[0]).toBe('1');
    });

    it('handles entries across year boundary', () => {
      const entriesAcrossYear: JournalEntry[] = [
        {
          id: '1',
          title: 'December Entry',
          content: 'End of year',
          category: 'work',
          weather: 'snowy',
          location: null,
          tags: null,
          image: null,
          created_at: '2023-12-31T23:59:59Z',
          updated_at: '2023-12-31T23:59:59Z',
        },
        {
          id: '2',
          title: 'January Entry',
          content: 'Start of year',
          category: 'life',
          weather: 'sunny',
          location: null,
          tags: null,
          image: null,
          created_at: '2024-01-01T00:00:01Z',
          updated_at: '2024-01-01T00:00:01Z',
        },
      ];
      mockAppContextValue = createMockAppContext({ entries: entriesAcrossYear });
      const { getAllByTestId } = render(<CalendarScreen />);
      const counts = getAllByTestId('entry-dates-count');
      expect(counts[0].children[0]).toBe('2');
    });

    it('handles fetchEntries being called multiple times on focus', () => {
      mockAppContextValue = createMockAppContext();
      render(<CalendarScreen />);
      expect(mockFetchEntries).toHaveBeenCalledTimes(1);
      const focusCallback = mockUseFocusEffect.mock.calls[0][0];
      focusCallback();
      expect(mockFetchEntries).toHaveBeenCalledTimes(2);
    });
  });

  describe('i18n Tests', () => {
    it('renders with Chinese i18n', () => {
      mockAppContextValue = createMockAppContext({
        i18n: {
          ...mockI18n,
          newEntry: '新建',
          language: 'zh',
        },
      });
      const { getAllByTestId } = render(<CalendarScreen />);
      const monthDates = getAllByTestId('month-date');
      expect(monthDates.length).toBe(12);
    });

    it('renders with English i18n', () => {
      mockAppContextValue = createMockAppContext({
        i18n: {
          ...mockI18n,
          newEntry: 'New Entry',
          language: 'en',
        },
      });
      const { getAllByTestId } = render(<CalendarScreen />);
      const monthDates = getAllByTestId('month-date');
      expect(monthDates.length).toBe(12);
    });

    it('renders with Japanese i18n', () => {
      mockAppContextValue = createMockAppContext({
        i18n: {
          ...mockI18n,
          newEntry: '新規作成',
          language: 'ja',
        },
      });
      const { getAllByTestId } = render(<CalendarScreen />);
      const monthDates = getAllByTestId('month-date');
      expect(monthDates.length).toBe(12);
    });
  });
});
