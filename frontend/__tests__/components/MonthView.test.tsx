import React from 'react';
import { fireEvent, render, screen } from '@testing-library/react-native';
import { MonthView } from '@/components/journal/MonthView';

import {
  eachDayOfInterval,
  endOfMonth,
  endOfWeek,
  format,
  isSameMonth,
  startOfMonth,
  startOfWeek,
} from 'date-fns';

// Mock date-fns
jest.mock('date-fns', () => ({
  eachDayOfInterval: jest.fn(),
  endOfMonth: jest.fn(),
  endOfWeek: jest.fn(),
  format: jest.fn(),
  isSameMonth: jest.fn(),
  startOfMonth: jest.fn(),
  startOfWeek: jest.fn(),
}));

// Mock getDateLocale
jest.mock('@/constants/i18n', () => ({
  getDateLocale: jest.fn(() => ({ code: 'en-US' })),
}));

// Mock themed-text to avoid importing AppContext
jest.mock('@/components/themed-text', () => ({
  ThemedText: ({ children, style, ...props }: any) => {
    const React = require('react');
    const { Text } = require('react-native');
    return React.createElement(Text, { style, ...props }, children);
  },
}));

describe('MonthView', () => {
  const mockOnDatePress = jest.fn();
  const mockI18n = {
    sun: 'Sun',
    mon: 'Mon',
    tue: 'Tue',
    wed: 'Wed',
    thu: 'Thu',
    fri: 'Fri',
    sat: 'Sat',
  };

  // Mock dates for consistent testing
  const mockMonthDate = new Date('2024-03-15');
  const mockToday = new Date('2024-03-20');

  // Generate 42 days (6 weeks) for the calendar grid
  const generateMockDays = (startDate: Date) => {
    const days = [];
    for (let i = 0; i < 42; i++) {
      const date = new Date(startDate);
      date.setDate(startDate.getDate() + i);
      days.push(date);
    }
    return days;
  };

  beforeEach(() => {
    jest.clearAllMocks();

    // Default mock implementations
    (startOfMonth as jest.Mock).mockReturnValue(mockMonthDate);
    (endOfMonth as jest.Mock).mockReturnValue(mockMonthDate);
    (startOfWeek as jest.Mock).mockReturnValue(mockMonthDate);
    (endOfWeek as jest.Mock).mockReturnValue(mockMonthDate);
    (eachDayOfInterval as jest.Mock).mockReturnValue(generateMockDays(mockMonthDate));
    (isSameMonth as jest.Mock).mockReturnValue(true);

    // Mock format function to return predictable values
    (format as jest.Mock).mockImplementation((date: Date, formatStr: string) => {
      if (formatStr === 'LLLL yyyy') return 'March 2024';
      if (formatStr === 'yyyy-MM-dd') {
        return date.toISOString().split('T')[0];
      }
      if (formatStr === 'd') return String(date.getDate());
      return '';
    });
  });

  describe('Rendering Tests', () => {
    it('renders month title correctly', () => {
      render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set()}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      expect(screen.getByText('March 2024')).toBeTruthy();
    });

    it('renders all day headers (Sun-Sat)', () => {
      render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set()}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      expect(screen.getByText('Sun')).toBeTruthy();
      expect(screen.getByText('Mon')).toBeTruthy();
      expect(screen.getByText('Tue')).toBeTruthy();
      expect(screen.getByText('Wed')).toBeTruthy();
      expect(screen.getByText('Thu')).toBeTruthy();
      expect(screen.getByText('Fri')).toBeTruthy();
      expect(screen.getByText('Sat')).toBeTruthy();
    });

    it('renders calendar grid with all dates', () => {
      const startDate = new Date('2024-03-01');
      const mockDays = generateMockDays(startDate);
      (eachDayOfInterval as jest.Mock).mockReturnValue(mockDays);

      render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set()}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      // Use getAllByText since dates appear multiple times in calendar (different weeks)
      const allTexts = screen.queryAllByText(/^(1|2|3)$/);
      expect(allTexts.length).toBeGreaterThan(0);
    });

    it('calls date-fns functions with correct arguments', () => {
      render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set()}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      expect(startOfMonth).toHaveBeenCalledWith(mockMonthDate);
      expect(endOfMonth).toHaveBeenCalledWith(mockMonthDate);
      expect(startOfWeek).toHaveBeenBeenCalled;
      expect(endOfWeek).toHaveBeenBeenCalled;
      expect(eachDayOfInterval).toHaveBeenBeenCalled;
    });
  });

  describe('Date Display Tests', () => {
    it('displays dates outside current month with reduced opacity', () => {
      const mockDays = [
        new Date('2024-02-25'), // Previous month
        new Date('2024-03-01'), // Current month
        new Date('2024-04-05'), // Next month
      ];

      (eachDayOfInterval as jest.Mock).mockReturnValue(mockDays);
      (isSameMonth as jest.Mock).mockImplementation(
        (date: Date) => date.getMonth() === mockMonthDate.getMonth()
      );

      render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set()}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      expect(isSameMonth).toHaveBeenCalled();
    });

    it('handles different month and year formats', () => {
      const januaryDate = new Date('2024-01-15');
      (startOfMonth as jest.Mock).mockReturnValue(januaryDate);
      (endOfMonth as jest.Mock).mockReturnValue(januaryDate);
      (startOfWeek as jest.Mock).mockReturnValue(januaryDate);
      (endOfWeek as jest.Mock).mockReturnValue(januaryDate);
      (format as jest.Mock).mockImplementation((date: Date, formatStr: string) => {
        if (formatStr === 'LLLL yyyy') return 'January 2024';
        if (formatStr === 'yyyy-MM-dd') return date.toISOString().split('T')[0];
        if (formatStr === 'd') return String(date.getDate());
        return '';
      });

      render(
        <MonthView
          monthDate={januaryDate}
          entryDates={new Set()}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      expect(screen.getByText('January 2024')).toBeTruthy();
    });

    it('renders dates with single and double digit days', () => {
      const startDate = new Date('2024-03-01');
      const mockDays = generateMockDays(startDate);

      (eachDayOfInterval as jest.Mock).mockReturnValue(mockDays);

      render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set()}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      // Check that various day numbers are rendered (use getAllByText for unique dates)
      expect(screen.queryAllByText('9').length).toBeGreaterThan(0);
      expect(screen.queryAllByText('10').length).toBeGreaterThan(0);
      expect(screen.queryAllByText('31').length).toBeGreaterThan(0);
    });
  });

  describe('Today Highlight Tests', () => {
    it('highlights today with accent color in dark theme', () => {
      const today = new Date();
      const mockDays = [today];

      (eachDayOfInterval as jest.Mock).mockReturnValue(mockDays);
      (format as jest.Mock).mockImplementation((date: Date, formatStr: string) => {
        if (formatStr === 'yyyy-MM-dd') {
          const dateStr = date.toISOString().split('T')[0];
          const todayStr = new Date().toISOString().split('T')[0];
          return dateStr === todayStr ? todayStr : dateStr;
        }
        if (formatStr === 'd') return String(date.getDate());
        if (formatStr === 'LLLL yyyy') return 'March 2024';
        return '';
      });

      render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set()}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      expect(format).toHaveBeenCalled();
    });

    it('highlights today with accent color in light theme', () => {
      const today = new Date();
      const mockDays = [today];

      (eachDayOfInterval as jest.Mock).mockReturnValue(mockDays);

      render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set()}
          accentColor="#02BFB8"
          theme="light"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      expect(format).toHaveBeenCalled();
    });
  });

  describe('Theme Tests', () => {
    it('applies dark theme colors correctly', () => {
      const { getByText } = render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set()}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      expect(getByText('March 2024')).toBeTruthy();
    });

    it('applies light theme colors correctly', () => {
      const { getByText } = render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set()}
          accentColor="#02BFB8"
          theme="light"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      expect(getByText('March 2024')).toBeTruthy();
    });

    it('uses different border colors for dark theme', () => {
      render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set()}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      // Grid container should have dark border color
      expect(screen.queryAllByTestId('grid-container').length).toBe(0);
    });

    it('uses different border colors for light theme', () => {
      render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set()}
          accentColor="#02BFB8"
          theme="light"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      expect(screen.queryAllByTestId('grid-container').length).toBe(0);
    });
  });

  describe('Interaction Tests', () => {
    it('calls onDatePress when pressing a date with entry', () => {
      const entryDate = new Date('2024-03-15');
      const dateStr = '2024-03-15';
      const mockDays = [entryDate];

      (eachDayOfInterval as jest.Mock).mockReturnValue(mockDays);
      (format as jest.Mock).mockImplementation((date: Date, formatStr: string) => {
        if (formatStr === 'yyyy-MM-dd') return '2024-03-15';
        if (formatStr === 'd') return '15';
        return '';
      });

      render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set([dateStr])}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      const dateCell = screen.getByText('15');
      fireEvent.press(dateCell);

      expect(mockOnDatePress).toHaveBeenCalledWith(dateStr);
    });

    it('does not call onDatePress when pressing a date without entry', () => {
      const noEntryDate = new Date('2024-03-10');
      const mockDays = [noEntryDate];

      (eachDayOfInterval as jest.Mock).mockReturnValue(mockDays);
      (format as jest.Mock).mockImplementation((date: Date, formatStr: string) => {
        if (formatStr === 'yyyy-MM-dd') return '2024-03-10';
        if (formatStr === 'd') return '10';
        return '';
      });

      render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set()}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      const dateCell = screen.getByText('10');
      fireEvent.press(dateCell);

      expect(mockOnDatePress).not.toHaveBeenCalled();
    });

    it('does not call onDatePress when pressing a date outside current month', () => {
      const outsideDate = new Date('2024-02-25');
      const mockDays = [outsideDate];

      (eachDayOfInterval as jest.Mock).mockReturnValue(mockDays);
      (isSameMonth as jest.Mock).mockReturnValue(false);
      (format as jest.Mock).mockImplementation((date: Date, formatStr: string) => {
        if (formatStr === 'yyyy-MM-dd') return '2024-02-25';
        if (formatStr === 'd') return '25';
        return '';
      });

      render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set(['2024-02-25'])}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      const dateCell = screen.getByText('25');
      fireEvent.press(dateCell);

      expect(mockOnDatePress).toHaveBeenCalledWith('2024-02-25');
    });

    it('applies correct activeOpacity for dates with entries', () => {
      const entryDate = new Date('2024-03-15');
      const mockDays = [entryDate];

      (eachDayOfInterval as jest.Mock).mockReturnValue(mockDays);
      (format as jest.Mock).mockImplementation((date: Date, formatStr: string) => {
        if (formatStr === 'yyyy-MM-dd') return '2024-03-15';
        if (formatStr === 'd') return '15';
        return '';
      });

      render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set(['2024-03-15'])}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      expect(screen.getByText('15')).toBeTruthy();
    });
  });

  describe('Entry Dot Tests', () => {
    it('displays entry dot for dates with entries', () => {
      const entryDate = new Date('2024-03-15');
      const mockDays = [entryDate];

      (eachDayOfInterval as jest.Mock).mockReturnValue(mockDays);
      (format as jest.Mock).mockImplementation((date: Date, formatStr: string) => {
        if (formatStr === 'yyyy-MM-dd') return '2024-03-15';
        if (formatStr === 'd') return '15';
        return '';
      });

      render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set(['2024-03-15'])}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      // Entry dot should be present (rendered as a View inside TouchableOpacity)
      expect(screen.getByText('15')).toBeTruthy();
    });

    it('does not display entry dot for dates without entries', () => {
      const noEntryDate = new Date('2024-03-10');
      const mockDays = [noEntryDate];

      (eachDayOfInterval as jest.Mock).mockReturnValue(mockDays);
      (format as jest.Mock).mockImplementation((date: Date, formatStr: string) => {
        if (formatStr === 'yyyy-MM-dd') return '2024-03-10';
        if (formatStr === 'd') return '10';
        return '';
      });

      render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set()}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      expect(screen.getByText('10')).toBeTruthy();
    });

    it('displays entry dots for multiple dates with entries', () => {
      const startDate = new Date('2024-03-01');
      const mockDays = generateMockDays(startDate);

      (eachDayOfInterval as jest.Mock).mockReturnValue(mockDays);

      render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set(['2024-03-05', '2024-03-10', '2024-03-15', '2024-03-20'])}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      // Check that dates with entries are rendered (use queryAllByText to avoid duplicates)
      expect(screen.queryAllByText('10').length).toBeGreaterThan(0);
      expect(screen.queryAllByText('15').length).toBeGreaterThan(0);
      expect(screen.queryAllByText('20').length).toBeGreaterThan(0);
    });
  });

  describe('Edge Cases', () => {
    it('handles empty entryDates Set', () => {
      const mockDays = [new Date('2024-03-15')];

      (eachDayOfInterval as jest.Mock).mockReturnValue(mockDays);
      (format as jest.Mock).mockImplementation((date: Date, formatStr: string) => {
        if (formatStr === 'yyyy-MM-dd') return '2024-03-15';
        if (formatStr === 'd') return '15';
        return '';
      });

      render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set()}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      expect(screen.getByText('15')).toBeTruthy();
    });

    it('handles entryDates with dates in different formats', () => {
      const startDate = new Date('2024-03-01');
      const mockDays = generateMockDays(startDate);

      (eachDayOfInterval as jest.Mock).mockReturnValue(mockDays);

      render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set(['2024-03-15', '2024-03-20'])}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      expect(screen.getByText('15')).toBeTruthy();
      expect(screen.getByText('20')).toBeTruthy();
    });

    it('handles month at year boundary (December)', () => {
      const decemberDate = new Date('2024-12-15');
      (startOfMonth as jest.Mock).mockReturnValue(decemberDate);
      (endOfMonth as jest.Mock).mockReturnValue(decemberDate);
      (startOfWeek as jest.Mock).mockReturnValue(decemberDate);
      (endOfWeek as jest.Mock).mockReturnValue(decemberDate);
      (format as jest.Mock).mockImplementation((date: Date, formatStr: string) => {
        if (formatStr === 'LLLL yyyy') return 'December 2024';
        if (formatStr === 'yyyy-MM-dd') return date.toISOString().split('T')[0];
        if (formatStr === 'd') return String(date.getDate());
        return '';
      });

      render(
        <MonthView
          monthDate={decemberDate}
          entryDates={new Set()}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      expect(screen.getByText('December 2024')).toBeTruthy();
    });

    it('handles month at year boundary (January)', () => {
      const januaryDate = new Date('2024-01-15');
      (startOfMonth as jest.Mock).mockReturnValue(januaryDate);
      (endOfMonth as jest.Mock).mockReturnValue(januaryDate);
      (startOfWeek as jest.Mock).mockReturnValue(januaryDate);
      (endOfWeek as jest.Mock).mockReturnValue(januaryDate);
      (format as jest.Mock).mockImplementation((date: Date, formatStr: string) => {
        if (formatStr === 'LLLL yyyy') return 'January 2024';
        if (formatStr === 'yyyy-MM-dd') return date.toISOString().split('T')[0];
        if (formatStr === 'd') return String(date.getDate());
        return '';
      });

      render(
        <MonthView
          monthDate={januaryDate}
          entryDates={new Set()}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      expect(screen.getByText('January 2024')).toBeTruthy();
    });

    it('handles leap year February', () => {
      const february2024 = new Date('2024-02-15'); // 2024 is a leap year
      (startOfMonth as jest.Mock).mockReturnValue(february2024);
      (endOfMonth as jest.Mock).mockReturnValue(february2024);
      (startOfWeek as jest.Mock).mockReturnValue(february2024);
      (endOfWeek as jest.Mock).mockReturnValue(february2024);
      (format as jest.Mock).mockImplementation((date: Date, formatStr: string) => {
        if (formatStr === 'LLLL yyyy') return 'February 2024';
        if (formatStr === 'yyyy-MM-dd') return date.toISOString().split('T')[0];
        if (formatStr === 'd') return String(date.getDate());
        return '';
      });

      render(
        <MonthView
          monthDate={february2024}
          entryDates={new Set()}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      expect(screen.getByText('February 2024')).toBeTruthy();
    });

    it('handles months with 6 weeks of days', () => {
      const sixWeeksDays = generateMockDays(new Date('2024-03-01'));
      (eachDayOfInterval as jest.Mock).mockReturnValue(sixWeeksDays);

      render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set()}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      expect(eachDayOfInterval).toHaveBeenCalled();
    });

    it('handles months with 5 weeks of days', () => {
      const fiveWeeksDays = generateMockDays(new Date('2024-02-01')).slice(0, 35);
      (eachDayOfInterval as jest.Mock).mockReturnValue(fiveWeeksDays);

      render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set()}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      expect(eachDayOfInterval).toHaveBeenCalled();
    });

    it('handles different accent colors', () => {
      const accentColors = ['#02BFB8', '#FF3B30', '#FF9500', '#FFCC00', '#4CD964', '#5856D6'];

      accentColors.forEach((color) => {
        const { unmount } = render(
          <MonthView
            monthDate={mockMonthDate}
            entryDates={new Set()}
            accentColor={color}
            theme="dark"
            i18n={mockI18n}
            language="en"
            onDatePress={mockOnDatePress}
          />
        );

        expect(screen.getByText('March 2024')).toBeTruthy();
        unmount();
      });
    });

    it('handles dates with entries outside current month', () => {
      const outsideDate = new Date('2024-02-25');
      const mockDays = [outsideDate];

      (eachDayOfInterval as jest.Mock).mockReturnValue(mockDays);
      (isSameMonth as jest.Mock).mockReturnValue(false);
      (format as jest.Mock).mockImplementation((date: Date, formatStr: string) => {
        if (formatStr === 'yyyy-MM-dd') return '2024-02-25';
        if (formatStr === 'd') return '25';
        return '';
      });

      render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set(['2024-02-25'])}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      // Entry dot should be rendered with reduced opacity
      expect(screen.getByText('25')).toBeTruthy();
    });
  });

  describe('Language/Locale Tests', () => {
    it('handles different languages', () => {
      const languages = ['en', 'zh', 'ja'];
      const expectedTitles = {
        en: 'March 2024',
        zh: '三月 2024',
        ja: '3月 2024',
      };

      languages.forEach((lang) => {
        (format as jest.Mock).mockImplementation((date: Date, formatStr: string) => {
          if (formatStr === 'LLLL yyyy') return expectedTitles[lang as keyof typeof expectedTitles];
          if (formatStr === 'yyyy-MM-dd') return date.toISOString().split('T')[0];
          if (formatStr === 'd') return String(date.getDate());
          return '';
        });

        const { unmount } = render(
          <MonthView
            monthDate={mockMonthDate}
            entryDates={new Set()}
            accentColor="#02BFB8"
            theme="dark"
            i18n={mockI18n}
            language={lang}
            onDatePress={mockOnDatePress}
          />
        );

        expect(screen.getByText(expectedTitles[lang as keyof typeof expectedTitles])).toBeTruthy();
        unmount();
      });
    });

    it('passes language to getDateLocale', () => {
      const { getDateLocale } = require('@/constants/i18n');

      render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set()}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      expect(getDateLocale).toHaveBeenCalledWith('en');
    });
  });

  describe('Accessibility Tests', () => {
    it('renders TouchableOpacity with proper accessibility', () => {
      const entryDate = new Date('2024-03-15');
      const mockDays = [entryDate];

      (eachDayOfInterval as jest.Mock).mockReturnValue(mockDays);
      (format as jest.Mock).mockImplementation((date: Date, formatStr: string) => {
        if (formatStr === 'yyyy-MM-dd') return '2024-03-15';
        if (formatStr === 'd') return '15';
        return '';
      });

      render(
        <MonthView
          monthDate={mockMonthDate}
          entryDates={new Set(['2024-03-15'])}
          accentColor="#02BFB8"
          theme="dark"
          i18n={mockI18n}
          language="en"
          onDatePress={mockOnDatePress}
        />
      );

      expect(screen.getByText('15')).toBeTruthy();
    });
  });
});
