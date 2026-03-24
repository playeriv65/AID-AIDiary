import React from 'react';
import { fireEvent, render, screen } from '@testing-library/react-native';
import { Collapsible } from '@/components/ui/collapsible';
import { Text } from 'react-native';

// Mutable mock state for theme testing
let mockResolvedTheme = 'light';

// Mock AppContext for useThemeColor
jest.mock('@/context/AppContext', () => ({
  useAppContext: () => ({
    resolvedTheme: mockResolvedTheme,
    accentColor: '#02BFB8',
  }),
}));

// Mock IconSymbol component to capture transform styles
const mockIconSymbolProps: { style?: { transform?: { rotate?: string }[] } }[] = [];

jest.mock('@/components/ui/icon-symbol', () => ({
  IconSymbol: jest.fn(({ name, size, color, style }) => {
    mockIconSymbolProps.push({ style });
    const ReactNative = require('react-native');
    return (
      <ReactNative.View testID={`icon-${name}`} style={style}>
        <ReactNative.Text>{`icon-${name}-${size}-${color}`}</ReactNative.Text>
      </ReactNative.View>
    );
  }),
}));

describe('Collapsible', () => {
  const mockTitle = 'Test Section';
  const mockChildren = <Text testID="collapsible-content">Hidden Content</Text>;

  beforeEach(() => {
    jest.clearAllMocks();
    mockIconSymbolProps.length = 0;
    mockResolvedTheme = 'light';
  });

  describe('Rendering', () => {
    it('renders with title correctly', () => {
      render(<Collapsible title={mockTitle}>{mockChildren}</Collapsible>);

      expect(screen.getByText(mockTitle)).toBeTruthy();
    });

    it('renders in collapsed state by default (children hidden)', () => {
      render(<Collapsible title={mockTitle}>{mockChildren}</Collapsible>);

      expect(screen.queryByTestId('collapsible-content')).toBeNull();
      expect(screen.queryByText('Hidden Content')).toBeNull();
    });

    it('renders caret icon in collapsed state', () => {
      render(<Collapsible title={mockTitle}>{mockChildren}</Collapsible>);

      expect(screen.getByTestId('icon-caret-right')).toBeTruthy();
    });

    it('shows children when expanded', () => {
      render(<Collapsible title={mockTitle}>{mockChildren}</Collapsible>);

      expect(screen.queryByTestId('collapsible-content')).toBeNull();

      const touchable = screen.getByText(mockTitle).parent;
      fireEvent.press(touchable);

      expect(screen.getByTestId('collapsible-content')).toBeTruthy();
      expect(screen.getByText('Hidden Content')).toBeTruthy();
    });

    it('hides children when collapsed again', () => {
      render(<Collapsible title={mockTitle}>{mockChildren}</Collapsible>);

      const touchable = screen.getByText(mockTitle).parent;

      fireEvent.press(touchable);
      expect(screen.getByTestId('collapsible-content')).toBeTruthy();

      fireEvent.press(touchable);
      expect(screen.queryByTestId('collapsible-content')).toBeNull();
    });
  });

  describe('Interaction', () => {
    it('toggles open state on press', () => {
      render(<Collapsible title={mockTitle}>{mockChildren}</Collapsible>);

      const touchable = screen.getByText(mockTitle).parent;

      expect(screen.queryByTestId('collapsible-content')).toBeNull();

      fireEvent.press(touchable);
      expect(screen.getByTestId('collapsible-content')).toBeTruthy();

      fireEvent.press(touchable);
      expect(screen.queryByTestId('collapsible-content')).toBeNull();
    });

    it('supports multiple toggle cycles', () => {
      render(<Collapsible title={mockTitle}>{mockChildren}</Collapsible>);

      const touchable = screen.getByText(mockTitle).parent;

      fireEvent.press(touchable);
      expect(screen.getByTestId('collapsible-content')).toBeTruthy();

      fireEvent.press(touchable);
      expect(screen.queryByTestId('collapsible-content')).toBeNull();

      fireEvent.press(touchable);
      expect(screen.getByTestId('collapsible-content')).toBeTruthy();

      fireEvent.press(touchable);
      expect(screen.queryByTestId('collapsible-content')).toBeNull();
    });
  });

  describe('Animation Behavior', () => {
    it('renders caret with 0deg rotation when collapsed', () => {
      render(<Collapsible title={mockTitle}>{mockChildren}</Collapsible>);

      const lastIconProps = mockIconSymbolProps[mockIconSymbolProps.length - 1];
      expect(lastIconProps.style?.transform?.[0]?.rotate).toBe('0deg');
    });

    it('renders caret with 90deg rotation when expanded', () => {
      render(<Collapsible title={mockTitle}>{mockChildren}</Collapsible>);

      const touchable = screen.getByText(mockTitle).parent;
      fireEvent.press(touchable);

      const lastIconProps = mockIconSymbolProps[mockIconSymbolProps.length - 1];
      expect(lastIconProps.style?.transform?.[0]?.rotate).toBe('90deg');
    });

    it('toggles caret rotation between 0deg and 90deg', () => {
      render(<Collapsible title={mockTitle}>{mockChildren}</Collapsible>);

      const touchable = screen.getByText(mockTitle).parent;

      let lastIconProps = mockIconSymbolProps[mockIconSymbolProps.length - 1];
      expect(lastIconProps.style?.transform?.[0]?.rotate).toBe('0deg');

      fireEvent.press(touchable);
      lastIconProps = mockIconSymbolProps[mockIconSymbolProps.length - 1];
      expect(lastIconProps.style?.transform?.[0]?.rotate).toBe('90deg');

      fireEvent.press(touchable);
      lastIconProps = mockIconSymbolProps[mockIconSymbolProps.length - 1];
      expect(lastIconProps.style?.transform?.[0]?.rotate).toBe('0deg');
    });

    it('uses correct icon size', () => {
      render(<Collapsible title={mockTitle}>{mockChildren}</Collapsible>);

      expect(screen.getByText(/icon-caret-right-18-/)).toBeTruthy();
    });
  });

  describe('Theme Support', () => {
    it('uses correct icon color from theme', () => {
      render(<Collapsible title={mockTitle}>{mockChildren}</Collapsible>);

      // Light theme icon color: #6B7280
      expect(screen.getByText(/#6B7280/)).toBeTruthy();
    });
  });

  describe('Edge Cases', () => {
    it('renders without children', () => {
      render(<Collapsible title={mockTitle} />);

      expect(screen.getByText(mockTitle)).toBeTruthy();
      expect(screen.getByTestId('icon-caret-right')).toBeTruthy();
    });

    it('handles empty string children', () => {
      render(<Collapsible title={mockTitle}>{''}</Collapsible>);

      expect(screen.getByText(mockTitle)).toBeTruthy();
      const touchable = screen.getByText(mockTitle).parent;
      fireEvent.press(touchable);
      expect(screen.getByText(mockTitle)).toBeTruthy();
    });

    it('handles null children', () => {
      render(<Collapsible title={mockTitle}>{null}</Collapsible>);

      expect(screen.getByText(mockTitle)).toBeTruthy();
      const touchable = screen.getByText(mockTitle).parent;
      fireEvent.press(touchable);
      expect(screen.getByText(mockTitle)).toBeTruthy();
    });

    it('handles undefined children', () => {
      render(<Collapsible title={mockTitle}>{undefined}</Collapsible>);

      expect(screen.getByText(mockTitle)).toBeTruthy();
      const touchable = screen.getByText(mockTitle).parent;
      fireEvent.press(touchable);
      expect(screen.getByText(mockTitle)).toBeTruthy();
    });

    it('handles complex nested children', () => {
      const complexChildren = (
        <>
          <Text>First child</Text>
          <Text>Second child</Text>
          <Text>Third child</Text>
        </>
      );

      render(<Collapsible title={mockTitle}>{complexChildren}</Collapsible>);

      const touchable = screen.getByText(mockTitle).parent;
      fireEvent.press(touchable);

      expect(screen.getByText('First child')).toBeTruthy();
      expect(screen.getByText('Second child')).toBeTruthy();
      expect(screen.getByText('Third child')).toBeTruthy();
    });

    it('handles special characters in title', () => {
      const specialTitle = 'Special <>&"chars';
      render(<Collapsible title={specialTitle}>{mockChildren}</Collapsible>);

      expect(screen.getByText(specialTitle)).toBeTruthy();
    });

    it('handles long title text', () => {
      const longTitle = 'A'.repeat(200);
      render(<Collapsible title={longTitle}>{mockChildren}</Collapsible>);

      expect(screen.getByText(longTitle)).toBeTruthy();
    });
  });
});
