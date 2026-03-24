import React from 'react';
import { fireEvent, render, screen } from '@testing-library/react-native';
import { ChatHeader } from '@/components/journal/ChatHeader';

// Mock IconSymbol to avoid Phosphor icons dependency
jest.mock('@/components/ui/icon-symbol', () => ({
  IconSymbol: ({ name, size, color }: { name: string; size: number; color: string }) => (
    <div testID={`icon-${name}`} data-size={size} data-color={color}>
      {name}
    </div>
  ),
}));

const mockI18n = {
  aiChat: 'AI Chat',
  generateDiary: 'Generate',
};

describe('ChatHeader', () => {
  const mockOnClear = jest.fn();
  const mockOnGenerateDiary = jest.fn();
  const mockOnToggleSidebar = jest.fn();

  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('Rendering', () => {
    it('renders header title correctly', () => {
      render(
        <ChatHeader
          hasMessages={false}
          accentColor="#02BFB8"
          resolvedTheme="dark"
          i18n={mockI18n}
          generating={false}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerateDiary}
        />
      );

      expect(screen.getByText('AI Chat')).toBeTruthy();
    });

    it('renders with light theme', () => {
      const { getByText } = render(
        <ChatHeader
          hasMessages={false}
          accentColor="#02BFB8"
          resolvedTheme="light"
          i18n={mockI18n}
          generating={false}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerateDiary}
        />
      );

      expect(getByText('AI Chat')).toBeTruthy();
    });

    it('renders with dark theme', () => {
      const { getByText } = render(
        <ChatHeader
          hasMessages={false}
          accentColor="#02BFB8"
          resolvedTheme="dark"
          i18n={mockI18n}
          generating={false}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerateDiary}
        />
      );

      expect(getByText('AI Chat')).toBeTruthy();
    });

    it('renders sidebar toggle button when onToggleSidebar is provided', () => {
      render(
        <ChatHeader
          hasMessages={false}
          accentColor="#02BFB8"
          resolvedTheme="dark"
          i18n={mockI18n}
          generating={false}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerateDiary}
          onToggleSidebar={mockOnToggleSidebar}
        />
      );

      expect(screen.getByTestId('icon-sidebar')).toBeTruthy();
    });

    it('does not render sidebar toggle button when onToggleSidebar is not provided', () => {
      render(
        <ChatHeader
          hasMessages={false}
          accentColor="#02BFB8"
          resolvedTheme="dark"
          i18n={mockI18n}
          generating={false}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerateDiary}
        />
      );

      expect(screen.queryByTestId('icon-sidebar')).toBeNull();
    });

    it('renders clear button when hasMessages is true', () => {
      render(
        <ChatHeader
          hasMessages={true}
          accentColor="#02BFB8"
          resolvedTheme="dark"
          i18n={mockI18n}
          generating={false}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerateDiary}
        />
      );

      expect(screen.getByTestId('icon-trash')).toBeTruthy();
    });

    it('does not render clear button when hasMessages is false', () => {
      render(
        <ChatHeader
          hasMessages={false}
          accentColor="#02BFB8"
          resolvedTheme="dark"
          i18n={mockI18n}
          generating={false}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerateDiary}
        />
      );

      expect(screen.queryByTestId('icon-trash')).toBeNull();
    });

    it('renders generate diary button with icon and text', () => {
      render(
        <ChatHeader
          hasMessages={false}
          accentColor="#02BFB8"
          resolvedTheme="dark"
          i18n={mockI18n}
          generating={false}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerateDiary}
        />
      );

      expect(screen.getByTestId('icon-note')).toBeTruthy();
      expect(screen.getByText('Generate')).toBeTruthy();
    });

    it('renders with custom accent color', () => {
      const { getByText } = render(
        <ChatHeader
          hasMessages={false}
          accentColor="#FF6B6B"
          resolvedTheme="dark"
          i18n={mockI18n}
          generating={false}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerateDiary}
        />
      );

      const generateButton = getByText('Generate').parent;
      expect(generateButton).toBeTruthy();
    });
  });

  describe('Interaction', () => {
    it('calls onToggleSidebar when sidebar button is pressed', () => {
      render(
        <ChatHeader
          hasMessages={false}
          accentColor="#02BFB8"
          resolvedTheme="dark"
          i18n={mockI18n}
          generating={false}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerateDiary}
          onToggleSidebar={mockOnToggleSidebar}
        />
      );

      const sidebarButton = screen.getByTestId('icon-sidebar').parent;
      fireEvent.press(sidebarButton!);

      expect(mockOnToggleSidebar).toHaveBeenCalledTimes(1);
    });

    it('calls onClear when clear button is pressed', () => {
      render(
        <ChatHeader
          hasMessages={true}
          accentColor="#02BFB8"
          resolvedTheme="dark"
          i18n={mockI18n}
          generating={false}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerateDiary}
        />
      );

      const clearButton = screen.getByTestId('icon-trash').parent;
      fireEvent.press(clearButton!);

      expect(mockOnClear).toHaveBeenCalledTimes(1);
    });

    it('calls onGenerateDiary when generate button is pressed', () => {
      render(
        <ChatHeader
          hasMessages={false}
          accentColor="#02BFB8"
          resolvedTheme="dark"
          i18n={mockI18n}
          generating={false}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerateDiary}
        />
      );

      const generateButton = screen.getByText('Generate').parent;
      fireEvent.press(generateButton!);

      expect(mockOnGenerateDiary).toHaveBeenCalledTimes(1);
    });
  });

  describe('State', () => {
    it('shows ActivityIndicator when generating is true', () => {
      const { UNSAFE_getByType } = render(
        <ChatHeader
          hasMessages={false}
          accentColor="#02BFB8"
          resolvedTheme="dark"
          i18n={mockI18n}
          generating={true}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerateDiary}
        />
      );

      const activityIndicator = UNSAFE_getByType('ActivityIndicator');
      expect(activityIndicator).toBeTruthy();
    });

    it('does not show icon and text when generating is true', () => {
      render(
        <ChatHeader
          hasMessages={false}
          accentColor="#02BFB8"
          resolvedTheme="dark"
          i18n={mockI18n}
          generating={true}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerateDiary}
        />
      );

      expect(screen.queryByTestId('icon-note')).toBeNull();
      expect(screen.queryByText('Generate')).toBeNull();
    });

    it('disables generate button when generating is true', () => {
      const mockOnGenerate = jest.fn();
      render(
        <ChatHeader
          hasMessages={false}
          accentColor="#02BFB8"
          resolvedTheme="dark"
          i18n={mockI18n}
          generating={true}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerate}
        />
      );

      expect(screen.UNSAFE_getByType('ActivityIndicator')).toBeTruthy();
    });

    it('enables generate button when generating is false', () => {
      const mockOnGenerate = jest.fn();
      render(
        <ChatHeader
          hasMessages={false}
          accentColor="#02BFB8"
          resolvedTheme="dark"
          i18n={mockI18n}
          generating={false}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerate}
        />
      );

      const generateButton = screen.getByText('Generate').parent;
      fireEvent.press(generateButton!);
      expect(mockOnGenerate).toHaveBeenCalledTimes(1);
    });

    it('shows both clear and generate buttons when hasMessages is true and not generating', () => {
      render(
        <ChatHeader
          hasMessages={true}
          accentColor="#02BFB8"
          resolvedTheme="dark"
          i18n={mockI18n}
          generating={false}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerateDiary}
        />
      );

      expect(screen.getByTestId('icon-trash')).toBeTruthy();
      expect(screen.getByTestId('icon-note')).toBeTruthy();
      expect(screen.getByText('Generate')).toBeTruthy();
    });

    it('updates correctly when props change from hasMessages false to true', () => {
      const { rerender, queryByTestId, getByTestId } = render(
        <ChatHeader
          hasMessages={false}
          accentColor="#02BFB8"
          resolvedTheme="dark"
          i18n={mockI18n}
          generating={false}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerateDiary}
        />
      );

      expect(queryByTestId('icon-trash')).toBeNull();

      rerender(
        <ChatHeader
          hasMessages={true}
          accentColor="#02BFB8"
          resolvedTheme="dark"
          i18n={mockI18n}
          generating={false}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerateDiary}
        />
      );

      expect(getByTestId('icon-trash')).toBeTruthy();
    });

    it('updates correctly when props change from generating false to true', () => {
      const { rerender, getByTestId, queryByTestId, getByText, queryByText, UNSAFE_getByType } =
        render(
          <ChatHeader
            hasMessages={false}
            accentColor="#02BFB8"
            resolvedTheme="dark"
            i18n={mockI18n}
            generating={false}
            onClear={mockOnClear}
            onGenerateDiary={mockOnGenerateDiary}
          />
        );

      expect(getByTestId('icon-note')).toBeTruthy();
      expect(getByText('Generate')).toBeTruthy();

      rerender(
        <ChatHeader
          hasMessages={false}
          accentColor="#02BFB8"
          resolvedTheme="dark"
          i18n={mockI18n}
          generating={true}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerateDiary}
        />
      );

      expect(queryByTestId('icon-note')).toBeNull();
      expect(queryByText('Generate')).toBeNull();
      const activityIndicator = UNSAFE_getByType('ActivityIndicator');
      expect(activityIndicator).toBeTruthy();
    });
  });

  describe('Edge Cases', () => {
    it('handles missing onToggleSidebar gracefully', () => {
      const { getByText, queryByTestId } = render(
        <ChatHeader
          hasMessages={false}
          accentColor="#02BFB8"
          resolvedTheme="dark"
          i18n={mockI18n}
          generating={false}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerateDiary}
        />
      );

      // Should still render title and generate button
      expect(getByText('AI Chat')).toBeTruthy();
      expect(getByText('Generate')).toBeTruthy();
      // Should not have sidebar button
      expect(queryByTestId('icon-sidebar')).toBeNull();
    });

    it('renders correctly with different i18n values', () => {
      const customI18n = {
        aiChat: '智能助手',
        generateDiary: '生成日记',
      };

      const { getByText } = render(
        <ChatHeader
          hasMessages={false}
          accentColor="#02BFB8"
          resolvedTheme="dark"
          i18n={customI18n}
          generating={false}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerateDiary}
        />
      );

      expect(getByText('智能助手')).toBeTruthy();
      expect(getByText('生成日记')).toBeTruthy();
    });

    it('renders with all buttons visible when hasMessages is true and onToggleSidebar is provided', () => {
      render(
        <ChatHeader
          hasMessages={true}
          accentColor="#02BFB8"
          resolvedTheme="dark"
          i18n={mockI18n}
          generating={false}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerateDiary}
          onToggleSidebar={mockOnToggleSidebar}
        />
      );

      expect(screen.getByTestId('icon-sidebar')).toBeTruthy();
      expect(screen.getByTestId('icon-trash')).toBeTruthy();
      expect(screen.getByTestId('icon-note')).toBeTruthy();
      expect(screen.getByText('AI Chat')).toBeTruthy();
      expect(screen.getByText('Generate')).toBeTruthy();
    });

    it('applies correct border color for dark theme', () => {
      const { UNSAFE_getByType } = render(
        <ChatHeader
          hasMessages={false}
          accentColor="#02BFB8"
          resolvedTheme="dark"
          i18n={mockI18n}
          generating={false}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerateDiary}
        />
      );

      const headerView = UNSAFE_getByType('View');
      expect(headerView.props.style).toEqual(
        expect.arrayContaining([
          expect.objectContaining({
            borderBottomColor: '#1A1C1E',
          }),
        ])
      );
    });

    it('applies correct border color for light theme', () => {
      const { UNSAFE_getByType } = render(
        <ChatHeader
          hasMessages={false}
          accentColor="#02BFB8"
          resolvedTheme="light"
          i18n={mockI18n}
          generating={false}
          onClear={mockOnClear}
          onGenerateDiary={mockOnGenerateDiary}
        />
      );

      const headerView = UNSAFE_getByType('View');
      expect(headerView.props.style).toEqual(
        expect.arrayContaining([
          expect.objectContaining({
            borderBottomColor: '#E8E8EA',
          }),
        ])
      );
    });
  });
});
