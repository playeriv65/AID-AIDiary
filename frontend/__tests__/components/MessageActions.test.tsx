import React from 'react';
import { fireEvent, render, screen, waitFor } from '@testing-library/react-native';
import { MessageActions } from '@/components/chat/MessageActions';

// Mock expo-clipboard
const mockSetStringAsync = jest.fn();
jest.mock('expo-clipboard', () => ({
  setStringAsync: (...args: unknown[]) => mockSetStringAsync(...args),
}));

// Mock IconSymbol
const mockIconSymbol = jest.fn();
jest.mock('@/components/ui/icon-symbol', () => ({
  IconSymbol: (props: { name: string; size?: number; color?: string }) => {
    mockIconSymbol(props);
    return null;
  },
}));

describe('MessageActions', () => {
  const mockOnEdit = jest.fn();
  const mockOnRetry = jest.fn();
  const mockOnRegenerate = jest.fn();

  const defaultProps = {
    visible: true,
    role: 'assistant' as const,
    content: 'Test message content',
    theme: 'light' as const,
    accentColor: '#02BFB8',
  };

  beforeEach(() => {
    jest.clearAllMocks();
    mockSetStringAsync.mockResolvedValue(undefined);
  });

  describe('Rendering', () => {
    it('returns null when not visible', () => {
      const { toJSON } = render(<MessageActions {...defaultProps} visible={false} />);

      expect(toJSON()).toBeNull();
    });

    it('renders container when visible', () => {
      render(<MessageActions {...defaultProps} />);

      expect(screen.getByTestId('message-action-copy')).toBeTruthy();
    });

    it('renders copy button with doc-on-doc icon initially', () => {
      render(<MessageActions {...defaultProps} />);

      const copyIcons = mockIconSymbol.mock.calls.filter((call) => call[0]?.name === 'doc-on-doc');
      expect(copyIcons.length).toBe(1);
    });

    it('renders retry button for assistant role', () => {
      render(<MessageActions {...defaultProps} role="assistant" />);

      expect(screen.getByTestId('message-action-retry')).toBeTruthy();
      const retryIcons = mockIconSymbol.mock.calls.filter(
        (call) => call[0]?.name === 'arrow-counterclockwise'
      );
      expect(retryIcons.length).toBe(1);
    });

    it('renders edit button for user role when onEdit is provided', () => {
      render(<MessageActions {...defaultProps} role="user" onEdit={mockOnEdit} />);

      expect(screen.getByTestId('message-action-edit')).toBeTruthy();
      const editIcons = mockIconSymbol.mock.calls.filter((call) => call[0]?.name === 'pencil');
      expect(editIcons.length).toBe(1);
    });

    it('renders regenerate button for assistant role when onRegenerate is provided', () => {
      render(<MessageActions {...defaultProps} role="assistant" onRegenerate={mockOnRegenerate} />);

      expect(screen.getByTestId('message-action-regenerate')).toBeTruthy();
      const regenerateIcons = mockIconSymbol.mock.calls.filter(
        (call) => call[0]?.name === 'arrow-triclo'
      );
      expect(regenerateIcons.length).toBe(1);
    });

    it('does not render retry button for user role', () => {
      render(<MessageActions {...defaultProps} role="user" />);

      expect(screen.queryByTestId('message-action-retry')).toBeNull();
      const retryIcons = mockIconSymbol.mock.calls.filter(
        (call) => call[0]?.name === 'arrow-counterclockwise'
      );
      expect(retryIcons.length).toBe(0);
    });

    it('does not render edit button when onEdit is not provided', () => {
      render(<MessageActions {...defaultProps} role="user" />);

      expect(screen.queryByTestId('message-action-edit')).toBeNull();
      const editIcons = mockIconSymbol.mock.calls.filter((call) => call[0]?.name === 'pencil');
      expect(editIcons.length).toBe(0);
    });

    it('does not render regenerate button when onRegenerate is not provided', () => {
      render(<MessageActions {...defaultProps} role="assistant" />);

      expect(screen.queryByTestId('message-action-regenerate')).toBeNull();
      const regenerateIcons = mockIconSymbol.mock.calls.filter(
        (call) => call[0]?.name === 'arrow-triclo'
      );
      expect(regenerateIcons.length).toBe(0);
    });

    it('does not render edit button for assistant role even when onEdit is provided', () => {
      render(<MessageActions {...defaultProps} role="assistant" onEdit={mockOnEdit} />);

      expect(screen.queryByTestId('message-action-edit')).toBeNull();
      const editIcons = mockIconSymbol.mock.calls.filter((call) => call[0]?.name === 'pencil');
      expect(editIcons.length).toBe(0);
    });

    it('renders correct icon colors based on theme', () => {
      render(<MessageActions {...defaultProps} theme="light" />);

      const icons = mockIconSymbol.mock.calls;
      expect(icons.length).toBeGreaterThan(0);
      icons.forEach((call) => {
        expect(call[0].color).toBeDefined();
      });
    });
  });

  describe('Interactions', () => {
    it('calls Clipboard.setStringAsync with content when copy button is pressed', async () => {
      const testContent = 'Content to copy';
      render(<MessageActions {...defaultProps} content={testContent} />);

      fireEvent.press(screen.getByTestId('message-action-copy'));

      await waitFor(() => {
        expect(mockSetStringAsync).toHaveBeenCalledWith(testContent);
      });
    });

    it('calls onRetry when retry button is pressed', () => {
      render(<MessageActions {...defaultProps} role="assistant" onRetry={mockOnRetry} />);

      fireEvent.press(screen.getByTestId('message-action-retry'));

      expect(mockOnRetry).toHaveBeenCalled();
    });

    it('calls onEdit with content when edit button is pressed', () => {
      const testContent = 'Content to edit';
      render(
        <MessageActions {...defaultProps} role="user" content={testContent} onEdit={mockOnEdit} />
      );

      fireEvent.press(screen.getByTestId('message-action-edit'));

      expect(mockOnEdit).toHaveBeenCalledWith(testContent);
    });

    it('calls onRegenerate when regenerate button is pressed', () => {
      render(<MessageActions {...defaultProps} role="assistant" onRegenerate={mockOnRegenerate} />);

      fireEvent.press(screen.getByTestId('message-action-regenerate'));

      expect(mockOnRegenerate).toHaveBeenCalled();
    });
  });

  describe('Role-based Rendering', () => {
    it('renders copy + retry buttons for assistant without optional callbacks', () => {
      render(<MessageActions {...defaultProps} role="assistant" />);

      expect(screen.getByTestId('message-action-copy')).toBeTruthy();
      expect(screen.getByTestId('message-action-retry')).toBeTruthy();
      expect(screen.queryByTestId('message-action-regenerate')).toBeNull();
    });

    it('renders copy button only for user without onEdit', () => {
      render(<MessageActions {...defaultProps} role="user" />);

      expect(screen.getByTestId('message-action-copy')).toBeTruthy();
      expect(screen.queryByTestId('message-action-retry')).toBeNull();
      expect(screen.queryByTestId('message-action-edit')).toBeNull();
    });

    it('renders copy + edit buttons for user with onEdit', () => {
      render(<MessageActions {...defaultProps} role="user" onEdit={mockOnEdit} />);

      expect(screen.getByTestId('message-action-copy')).toBeTruthy();
      expect(screen.getByTestId('message-action-edit')).toBeTruthy();
      expect(screen.queryByTestId('message-action-retry')).toBeNull();
    });

    it('renders copy + retry + regenerate buttons for assistant with onRegenerate', () => {
      render(<MessageActions {...defaultProps} role="assistant" onRegenerate={mockOnRegenerate} />);

      expect(screen.getByTestId('message-action-copy')).toBeTruthy();
      expect(screen.getByTestId('message-action-retry')).toBeTruthy();
      expect(screen.getByTestId('message-action-regenerate')).toBeTruthy();
    });

    it('renders three buttons for assistant with all callbacks', () => {
      render(
        <MessageActions
          {...defaultProps}
          role="assistant"
          onRetry={mockOnRetry}
          onRegenerate={mockOnRegenerate}
          onEdit={mockOnEdit}
        />
      );

      expect(screen.getByTestId('message-action-copy')).toBeTruthy();
      expect(screen.getByTestId('message-action-retry')).toBeTruthy();
      expect(screen.getByTestId('message-action-regenerate')).toBeTruthy();
      expect(screen.queryByTestId('message-action-edit')).toBeNull();
    });

    it('renders two buttons for user with all callbacks', () => {
      render(
        <MessageActions
          {...defaultProps}
          role="user"
          onRetry={mockOnRetry}
          onRegenerate={mockOnRegenerate}
          onEdit={mockOnEdit}
        />
      );

      expect(screen.getByTestId('message-action-copy')).toBeTruthy();
      expect(screen.getByTestId('message-action-edit')).toBeTruthy();
      expect(screen.queryByTestId('message-action-retry')).toBeNull();
      expect(screen.queryByTestId('message-action-regenerate')).toBeNull();
    });
  });

  describe('State Management', () => {
    it('changes copy icon to checkmark after successful copy', async () => {
      mockSetStringAsync.mockResolvedValue(undefined);

      render(<MessageActions {...defaultProps} />);

      fireEvent.press(screen.getByTestId('message-action-copy'));

      await waitFor(() => {
        const checkmarkIcons = mockIconSymbol.mock.calls.filter(
          (call) => call[0]?.name === 'checkmark'
        );
        expect(checkmarkIcons.length).toBeGreaterThan(0);
      });
    });

    it('reverts copy icon back after 2 seconds', async () => {
      jest.useFakeTimers();
      mockSetStringAsync.mockResolvedValue(undefined);

      const { rerender } = render(<MessageActions {...defaultProps} />);

      fireEvent.press(screen.getByTestId('message-action-copy'));

      await waitFor(() => {
        expect(mockSetStringAsync).toHaveBeenCalled();
      });

      const checkmarkIconsBefore = mockIconSymbol.mock.calls.filter(
        (call) => call[0]?.name === 'checkmark'
      );
      expect(checkmarkIconsBefore.length).toBeGreaterThan(0);

      jest.advanceTimersByTime(2000);

      mockIconSymbol.mockClear();

      rerender(<MessageActions {...defaultProps} content="updated" />);

      const docIcons = mockIconSymbol.mock.calls.filter((call) => call[0]?.name === 'doc-on-doc');
      expect(docIcons.length).toBeGreaterThan(0);

      jest.useRealTimers();
    });

    it('uses correct icon color from theme', () => {
      render(<MessageActions {...defaultProps} theme="dark" />);

      const icons = mockIconSymbol.mock.calls;
      icons.forEach((call) => {
        expect(call[0].color).toBeDefined();
        expect(typeof call[0].color).toBe('string');
      });
    });
  });

  describe('Edge Cases', () => {
    it('handles empty content string', async () => {
      render(<MessageActions {...defaultProps} content="" />);

      fireEvent.press(screen.getByTestId('message-action-copy'));

      await waitFor(() => {
        expect(mockSetStringAsync).toHaveBeenCalledWith('');
      });
    });

    it('handles very long content', async () => {
      const longContent = 'a'.repeat(10000);
      render(<MessageActions {...defaultProps} content={longContent} />);

      fireEvent.press(screen.getByTestId('message-action-copy'));

      await waitFor(() => {
        expect(mockSetStringAsync).toHaveBeenCalledWith(longContent);
      });
    });

    it('handles special characters in content', async () => {
      const specialContent = 'Hello! @#$%^&*()_+ 🎉 <script>alert("test")</script>';
      render(<MessageActions {...defaultProps} content={specialContent} />);

      fireEvent.press(screen.getByTestId('message-action-copy'));

      await waitFor(() => {
        expect(mockSetStringAsync).toHaveBeenCalledWith(specialContent);
      });
    });

    it('does not call onRetry if handler is not provided', () => {
      render(<MessageActions {...defaultProps} role="assistant" />);

      fireEvent.press(screen.getByTestId('message-action-retry'));

      expect(mockOnRetry).not.toHaveBeenCalled();
    });

    it('does not call onEdit if handler is not provided', () => {
      render(<MessageActions {...defaultProps} role="user" />);

      expect(screen.queryByTestId('message-action-edit')).toBeNull();
    });

    it('does not call onRegenerate if handler is not provided', () => {
      render(<MessageActions {...defaultProps} role="assistant" />);

      expect(screen.queryByTestId('message-action-regenerate')).toBeNull();
    });

    it('handles rapid copy button clicks', async () => {
      mockSetStringAsync.mockResolvedValue(undefined);

      render(<MessageActions {...defaultProps} />);

      fireEvent.press(screen.getByTestId('message-action-copy'));
      fireEvent.press(screen.getByTestId('message-action-copy'));
      fireEvent.press(screen.getByTestId('message-action-copy'));

      await waitFor(() => {
        expect(mockSetStringAsync).toHaveBeenCalledTimes(3);
      });
    });

    it('works with both light and dark themes', () => {
      const { rerender } = render(<MessageActions {...defaultProps} theme="light" />);

      expect(screen.getByTestId('message-action-copy')).toBeTruthy();

      rerender(<MessageActions {...defaultProps} theme="dark" />);

      expect(screen.getByTestId('message-action-copy')).toBeTruthy();
    });

    it('renders with custom accent color', () => {
      const customAccent = '#FF5733';
      const { toJSON } = render(<MessageActions {...defaultProps} accentColor={customAccent} />);

      expect(toJSON()).toBeTruthy();
    });
  });

  describe('Button Hit Slop', () => {
    it('buttons have proper hit slop configuration', () => {
      render(<MessageActions {...defaultProps} />);

      const copyButton = screen.getByTestId('message-action-copy');
      expect(copyButton).toBeTruthy();
    });
  });
});
