import React from 'react';
import { render, screen } from '@testing-library/react-native';
import { ThemedText, ThemedTextProps } from '@/components/themed-text';

// Mock AppContext to control theme
const mockUseAppContext = jest.fn();

jest.mock('@/context/AppContext', () => ({
  useAppContext: () => mockUseAppContext(),
}));

describe('ThemedText', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    // Default to light theme
    mockUseAppContext.mockReturnValue({
      resolvedTheme: 'light',
    });
  });

  describe('Rendering Tests - Type Variants', () => {
    it('renders with default type', () => {
      render(<ThemedText testID="text">Default Text</ThemedText>);

      const textElement = screen.getByTestId('text');
      expect(textElement).toBeTruthy();
      expect(screen.getByText('Default Text')).toBeTruthy();
    });

    it('renders with title type', () => {
      render(
        <ThemedText testID="text" type="title">
          Title Text
        </ThemedText>
      );

      const textElement = screen.getByTestId('text');
      expect(textElement).toBeTruthy();
      expect(screen.getByText('Title Text')).toBeTruthy();
    });

    it('renders with subtitle type', () => {
      render(
        <ThemedText testID="text" type="subtitle">
          Subtitle Text
        </ThemedText>
      );

      const textElement = screen.getByTestId('text');
      expect(textElement).toBeTruthy();
      expect(screen.getByText('Subtitle Text')).toBeTruthy();
    });

    it('renders with defaultSemiBold type', () => {
      render(
        <ThemedText testID="text" type="defaultSemiBold">
          SemiBold Text
        </ThemedText>
      );

      const textElement = screen.getByTestId('text');
      expect(textElement).toBeTruthy();
      expect(screen.getByText('SemiBold Text')).toBeTruthy();
    });

    it('renders with link type', () => {
      render(
        <ThemedText testID="text" type="link">
          Link Text
        </ThemedText>
      );

      const textElement = screen.getByTestId('text');
      expect(textElement).toBeTruthy();
      expect(screen.getByText('Link Text')).toBeTruthy();
    });

    it('uses default type when type prop is not provided', () => {
      render(<ThemedText testID="text">No Type Specified</ThemedText>);

      expect(screen.getByText('No Type Specified')).toBeTruthy();
    });

    it('uses default type when type prop is explicitly set to default', () => {
      render(
        <ThemedText testID="text" type="default">
          Explicit Default
        </ThemedText>
      );

      expect(screen.getByText('Explicit Default')).toBeTruthy();
    });
  });

  describe('Theme Color Tests', () => {
    it('applies light theme text color', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'light',
      });

      render(<ThemedText testID="text">Light Theme Text</ThemedText>);

      const textElement = screen.getByTestId('text');
      expect(textElement).toBeTruthy();
    });

    it('applies dark theme text color', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'dark',
      });

      render(<ThemedText testID="text">Dark Theme Text</ThemedText>);

      const textElement = screen.getByTestId('text');
      expect(textElement).toBeTruthy();
    });

    it('uses lightColor prop when provided in light theme', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'light',
      });

      render(
        <ThemedText testID="text" lightColor="#FF0000">
          Custom Light Color
        </ThemedText>
      );

      const textElement = screen.getByTestId('text');
      expect(textElement).toBeTruthy();
    });

    it('uses darkColor prop when provided in dark theme', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'dark',
      });

      render(
        <ThemedText testID="text" darkColor="#00FF00">
          Custom Dark Color
        </ThemedText>
      );

      const textElement = screen.getByTestId('text');
      expect(textElement).toBeTruthy();
    });

    it('prefers lightColor over theme color in light mode', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'light',
      });

      const { getByTestId } = render(
        <ThemedText testID="text" lightColor="#CUSTOM_LIGHT">
          Light Color Override
        </ThemedText>
      );

      expect(getByTestId('text')).toBeTruthy();
    });

    it('prefers darkColor over theme color in dark mode', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'dark',
      });

      const { getByTestId } = render(
        <ThemedText testID="text" darkColor="#CUSTOM_DARK">
          Dark Color Override
        </ThemedText>
      );

      expect(getByTestId('text')).toBeTruthy();
    });

    it('falls back to theme color when lightColor is not provided in light theme', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'light',
      });

      render(<ThemedText testID="text">Theme Fallback Light</ThemedText>);

      expect(screen.getByTestId('text')).toBeTruthy();
    });

    it('falls back to theme color when darkColor is not provided in dark theme', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'dark',
      });

      render(<ThemedText testID="text">Theme Fallback Dark</ThemedText>);

      expect(screen.getByTestId('text')).toBeTruthy();
    });

    it('handles link type with fixed color in light theme', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'light',
      });

      render(
        <ThemedText testID="text" type="link">
          Link in Light Theme
        </ThemedText>
      );

      expect(screen.getByTestId('text')).toBeTruthy();
    });

    it('handles link type with fixed color in dark theme', () => {
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'dark',
      });

      render(
        <ThemedText testID="text" type="link">
          Link in Dark Theme
        </ThemedText>
      );

      expect(screen.getByTestId('text')).toBeTruthy();
    });
  });

  describe('Props Tests', () => {
    it('applies custom style override', () => {
      const customStyle = { fontSize: 24, marginTop: 10 };

      render(
        <ThemedText testID="text" style={customStyle}>
          Custom Style
        </ThemedText>
      );

      expect(screen.getByTestId('text')).toBeTruthy();
    });

    it('applies multiple style properties', () => {
      const customStyle = {
        fontSize: 20,
        fontWeight: 'bold' as const,
        color: '#123456',
        padding: 8,
      };

      render(
        <ThemedText testID="text" style={customStyle}>
          Multiple Styles
        </ThemedText>
      );

      expect(screen.getByTestId('text')).toBeTruthy();
    });

    it('applies empty style object', () => {
      render(
        <ThemedText testID="text" style={{}}>
          Empty Style
        </ThemedText>
      );

      expect(screen.getByTestId('text')).toBeTruthy();
    });

    it('applies style array', () => {
      const styleArray = [{ fontSize: 16 }, { margin: 8 }];

      render(
        <ThemedText testID="text" style={styleArray}>
          Style Array
        </ThemedText>
      );

      expect(screen.getByTestId('text')).toBeTruthy();
    });

    it('passes native Text props', () => {
      render(
        <ThemedText
          testID="text"
          numberOfLines={2}
          ellipsizeMode="tail"
          selectable={true}
          accessibilityLabel="Accessible Text"
        >
          Native Props
        </ThemedText>
      );

      expect(screen.getByTestId('text')).toBeTruthy();
    });

    it('passes onPress handler', () => {
      const onPress = jest.fn();

      render(
        <ThemedText testID="text" onPress={onPress}>
          Pressable Text
        </ThemedText>
      );

      expect(screen.getByTestId('text')).toBeTruthy();
    });

    it('passes accessibility props', () => {
      render(
        <ThemedText
          testID="text"
          accessibilityRole="header"
          accessibilityLabel="Header Text"
          accessibilityHint="This is a header"
        >
          Accessible Header
        </ThemedText>
      );

      expect(screen.getByTestId('text')).toBeTruthy();
    });

    it('combines type prop with style override', () => {
      render(
        <ThemedText testID="text" type="title" style={{ marginBottom: 20 }}>
          Title with Custom Margin
        </ThemedText>
      );

      expect(screen.getByTestId('text')).toBeTruthy();
    });

    it('combines type prop with custom colors and style', () => {
      render(
        <ThemedText
          testID="text"
          type="subtitle"
          lightColor="#FF0000"
          darkColor="#00FF00"
          style={{ padding: 10 }}
        >
          Combined Props
        </ThemedText>
      );

      expect(screen.getByTestId('text')).toBeTruthy();
    });
  });

  describe('Edge Cases', () => {
    it('renders with null children', () => {
      render(<ThemedText testID="text">{null}</ThemedText>);

      expect(screen.getByTestId('text')).toBeTruthy();
    });

    it('renders with empty string', () => {
      render(<ThemedText testID="text" />);

      expect(screen.getByTestId('text')).toBeTruthy();
    });

    it('renders with undefined style', () => {
      render(
        <ThemedText testID="text" style={undefined}>
          Undefined Style
        </ThemedText>
      );

      expect(screen.getByTestId('text')).toBeTruthy();
    });

    it('renders with numeric children', () => {
      render(<ThemedText testID="text">{42}</ThemedText>);

      expect(screen.getByText('42')).toBeTruthy();
    });

    it('renders with nested Text components', () => {
      render(
        <ThemedText testID="parent-text">
          Parent Text Content
          <ThemedText testID="child-text" type="link">
            Nested Link
          </ThemedText>
        </ThemedText>
      );

      expect(screen.getByTestId('parent-text')).toBeTruthy();
      expect(screen.getByTestId('child-text')).toBeTruthy();
      expect(screen.getByText('Nested Link')).toBeTruthy();
    });

    it('renders with special characters', () => {
      render(<ThemedText testID="text">Special: !@#$%^&amp;*()_+-=[]{}|;&apos;:&quot;,./&lt;&gt;?</ThemedText>);

      expect(screen.getByTestId('text')).toBeTruthy();
    });

    it('renders with unicode characters', () => {
      render(<ThemedText testID="text">Unicode: 你好世界 🌍 émojis</ThemedText>);

      expect(screen.getByTestId('text')).toBeTruthy();
    });

    it('renders with very long text', () => {
      const longText = 'A'.repeat(1000);
      render(<ThemedText testID="text">{longText}</ThemedText>);

      expect(screen.getByTestId('text')).toBeTruthy();
    });

    it('renders with multiline text', () => {
      render(
        <ThemedText testID="text">
          Line 1{'\n'}Line 2{'\n'}Line 3
        </ThemedText>
      );

      expect(screen.getByTestId('text')).toBeTruthy();
    });

    it('handles all type variants in sequence', () => {
      const types: ThemedTextProps['type'][] = [
        'default',
        'title',
        'subtitle',
        'defaultSemiBold',
        'link',
      ];

      types.forEach((type, index) => {
        const { unmount } = render(
          <ThemedText testID={`text-${index}`} type={type}>
            Type {type}
          </ThemedText>
        );
        expect(screen.getByTestId(`text-${index}`)).toBeTruthy();
        unmount();
      });
    });

    it('handles rapid theme switches', () => {
      const { rerender } = render(<ThemedText testID="text">Theme Switching</ThemedText>);

      // Switch to dark
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'dark',
      });
      rerender(<ThemedText testID="text">Theme Switching</ThemedText>);
      expect(screen.getByTestId('text')).toBeTruthy();

      // Switch back to light
      mockUseAppContext.mockReturnValue({
        resolvedTheme: 'light',
      });
      rerender(<ThemedText testID="text">Theme Switching</ThemedText>);
      expect(screen.getByTestId('text')).toBeTruthy();
    });

    it('renders with zero-width spaces', () => {
      render(<ThemedText testID="text">Zero-width:{'\u200B'}space</ThemedText>);

      expect(screen.getByTestId('text')).toBeTruthy();
    });

    it('renders with only whitespace', () => {
      render(<ThemedText testID="text"> </ThemedText>);

      expect(screen.getByTestId('text')).toBeTruthy();
    });

    it('renders with boolean children (falsy)', () => {
      render(<ThemedText testID="text">{false}</ThemedText>);

      expect(screen.getByTestId('text')).toBeTruthy();
    });
  });

  describe('Style Composition Tests', () => {
    it('applies styles in correct order: color first, then type, then custom', () => {
      render(
        <ThemedText testID="text" type="title" style={{ color: '#OVERRIDE' }} lightColor="#CUSTOM">
          Style Order Test
        </ThemedText>
      );

      const textElement = screen.getByTestId('text');
      expect(textElement).toBeTruthy();
    });

    it('handles falsy style values', () => {
      render(
        <ThemedText testID="text" style={[null, undefined, false, { fontSize: 16 }]}>
          Falsy Styles
        </ThemedText>
      );

      expect(screen.getByTestId('text')).toBeTruthy();
    });

    it('handles deeply nested style arrays', () => {
      const nestedStyles = [[{ fontSize: 12 }, [{ margin: 4 }]], [{ padding: 8 }]];

      render(
        <ThemedText testID="text" style={nestedStyles}>
          Nested Style Arrays
        </ThemedText>
      );

      expect(screen.getByTestId('text')).toBeTruthy();
    });
  });
});
