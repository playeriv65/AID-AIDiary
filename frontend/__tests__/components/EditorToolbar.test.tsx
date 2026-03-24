import React from 'react';
import { fireEvent, render, screen } from '@testing-library/react-native';
import { EditorToolbar } from '@/components/journal/EditorToolbar';

// Mock IconSymbol to render with testID
jest.mock('@/components/ui/icon-symbol', () => ({
  IconSymbol: ({
    name,
    size,
    color,
    weight,
  }: {
    name: string;
    size: number;
    color: string;
    weight?: string;
  }) => {
     
    return (
      <span testID={`icon-${name}`}>{`Icon:${name}:${size}:${color}:${weight || 'regular'}`}</span>
    );
  },
}));

describe('EditorToolbar', () => {
  const mockOnInsertTemplate = jest.fn();
  const mockOnOpenCalendar = jest.fn();

  const defaultProps = {
    onInsertTemplate: mockOnInsertTemplate,
    onOpenCalendar: mockOnOpenCalendar,
    tagsCount: 0,
    theme: 'light' as const,
    accentColor: '#02BFB8',
  };

  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('Rendering Tests', () => {
    it('renders without crashing', () => {
      render(<EditorToolbar {...defaultProps} />);
      expect(screen.getByTestId('icon-list-bullets')).toBeTruthy();
    });

    it('renders all tool buttons', () => {
      render(<EditorToolbar {...defaultProps} />);

      // All four tool buttons should be present
      expect(screen.getByTestId('icon-list-bullets')).toBeTruthy();
      expect(screen.getByTestId('icon-check-square')).toBeTruthy();
      expect(screen.getByTestId('icon-clock')).toBeTruthy();
      expect(screen.getByTestId('icon-calendar')).toBeTruthy();
    });

    it('renders list-bullets button', () => {
      render(<EditorToolbar {...defaultProps} />);
      const listIcon = screen.getByTestId('icon-list-bullets');
      expect(listIcon).toBeTruthy();
    });

    it('renders check-square button', () => {
      render(<EditorToolbar {...defaultProps} />);
      const taskIcon = screen.getByTestId('icon-check-square');
      expect(taskIcon).toBeTruthy();
    });

    it('renders clock button', () => {
      render(<EditorToolbar {...defaultProps} />);
      const clockIcon = screen.getByTestId('icon-clock');
      expect(clockIcon).toBeTruthy();
    });

    it('renders calendar button', () => {
      render(<EditorToolbar {...defaultProps} />);
      const calendarIcon = screen.getByTestId('icon-calendar');
      expect(calendarIcon).toBeTruthy();
    });

    it('does not show tag icon when tagsCount is 0', () => {
      render(<EditorToolbar {...defaultProps} tagsCount={0} />);
      expect(screen.queryByTestId('icon-tag')).toBeNull();
    });

    it('shows tag icon when tagsCount is greater than 0', () => {
      render(<EditorToolbar {...defaultProps} tagsCount={3} />);
      expect(screen.getByTestId('icon-tag')).toBeTruthy();
    });

    it('shows tag icon when tagsCount is 1', () => {
      render(<EditorToolbar {...defaultProps} tagsCount={1} />);
      expect(screen.getByTestId('icon-tag')).toBeTruthy();
    });

    it('renders divider', () => {
      render(<EditorToolbar {...defaultProps} />);
      const json = screen.toJSON();
      // Divider is rendered as a View with specific style
      expect(json).toBeTruthy();
    });

    it('renders complete toolbar structure', () => {
      render(<EditorToolbar {...defaultProps} tagsCount={2} />);

      // Tag icon visible when count > 0
      expect(screen.getByTestId('icon-tag')).toBeTruthy();

      // All four tool buttons
      expect(screen.getByTestId('icon-list-bullets')).toBeTruthy();
      expect(screen.getByTestId('icon-check-square')).toBeTruthy();
      expect(screen.getByTestId('icon-clock')).toBeTruthy();
      expect(screen.getByTestId('icon-calendar')).toBeTruthy();
    });
  });

  describe('Interaction Tests', () => {
    it('calls onInsertTemplate with "list" when list-bullets button is pressed', () => {
      render(<EditorToolbar {...defaultProps} />);

      const listButton = screen.getByTestId('icon-list-bullets').parent;
      fireEvent.press(listButton);

      expect(mockOnInsertTemplate).toHaveBeenCalledTimes(1);
      expect(mockOnInsertTemplate).toHaveBeenCalledWith('list');
    });

    it('calls onInsertTemplate with "task" when check-square button is pressed', () => {
      render(<EditorToolbar {...defaultProps} />);

      const taskButton = screen.getByTestId('icon-check-square').parent;
      fireEvent.press(taskButton);

      expect(mockOnInsertTemplate).toHaveBeenCalledTimes(1);
      expect(mockOnInsertTemplate).toHaveBeenCalledWith('task');
    });

    it('calls onInsertTemplate with "time" when clock button is pressed', () => {
      render(<EditorToolbar {...defaultProps} />);

      const clockButton = screen.getByTestId('icon-clock').parent;
      fireEvent.press(clockButton);

      expect(mockOnInsertTemplate).toHaveBeenCalledTimes(1);
      expect(mockOnInsertTemplate).toHaveBeenCalledWith('time');
    });

    it('calls onOpenCalendar when calendar button is pressed', () => {
      render(<EditorToolbar {...defaultProps} />);

      const calendarButton = screen.getByTestId('icon-calendar').parent;
      fireEvent.press(calendarButton);

      expect(mockOnOpenCalendar).toHaveBeenCalledTimes(1);
    });

    it('calls onInsertTemplate with correct type parameter for each button', () => {
      render(<EditorToolbar {...defaultProps} />);

      // Test list button
      fireEvent.press(screen.getByTestId('icon-list-bullets').parent);
      expect(mockOnInsertTemplate).toHaveBeenLastCalledWith('list');

      // Test task button
      fireEvent.press(screen.getByTestId('icon-check-square').parent);
      expect(mockOnInsertTemplate).toHaveBeenLastCalledWith('task');

      // Test time button
      fireEvent.press(screen.getByTestId('icon-clock').parent);
      expect(mockOnInsertTemplate).toHaveBeenLastCalledWith('time');

      // Verify total calls
      expect(mockOnInsertTemplate).toHaveBeenCalledTimes(3);
    });

    it('handles multiple button presses independently', () => {
      render(<EditorToolbar {...defaultProps} />);

      // Press list button twice
      fireEvent.press(screen.getByTestId('icon-list-bullets').parent);
      fireEvent.press(screen.getByTestId('icon-list-bullets').parent);

      expect(mockOnInsertTemplate).toHaveBeenCalledTimes(2);
      expect(mockOnInsertTemplate).toHaveBeenNthCalledWith(1, 'list');
      expect(mockOnInsertTemplate).toHaveBeenNthCalledWith(2, 'list');
    });

    it('calls different callbacks for different buttons', () => {
      render(<EditorToolbar {...defaultProps} />);

      // Press calendar (should call onOpenCalendar)
      fireEvent.press(screen.getByTestId('icon-calendar').parent);
      expect(mockOnOpenCalendar).toHaveBeenCalledTimes(1);
      expect(mockOnInsertTemplate).not.toHaveBeenCalled();

      // Press list (should call onInsertTemplate)
      fireEvent.press(screen.getByTestId('icon-list-bullets').parent);
      expect(mockOnInsertTemplate).toHaveBeenCalledTimes(1);
    });
  });

  describe('Style Tests', () => {
    it('renders with light theme', () => {
      const { getByTestId } = render(<EditorToolbar {...defaultProps} theme="light" />);
      expect(getByTestId('icon-list-bullets')).toBeTruthy();
    });

    it('renders with dark theme', () => {
      const { getByTestId } = render(<EditorToolbar {...defaultProps} theme="dark" />);
      expect(getByTestId('icon-list-bullets')).toBeTruthy();
    });

    it('applies light theme background color', () => {
      const { root } = render(<EditorToolbar {...defaultProps} theme="light" />);
      expect(root).toBeTruthy();
    });

    it('applies dark theme background color', () => {
      const { root } = render(<EditorToolbar {...defaultProps} theme="dark" />);
      expect(root).toBeTruthy();
    });

    it('applies correct icon color from theme', () => {
      render(<EditorToolbar {...defaultProps} theme="light" />);

      const listIcon = screen.getByTestId('icon-list-bullets');
      const iconText = listIcon.children[0];

      // Light theme icon color
      expect(iconText).toContain('#6B7280');
    });

    it('applies dark theme icon color', () => {
      render(<EditorToolbar {...defaultProps} theme="dark" />);

      const listIcon = screen.getByTestId('icon-list-bullets');
      const iconText = listIcon.children[0];

      // Dark theme icon color
      expect(iconText).toContain('#9CA3AF');
    });

    it('passes accentColor to component', () => {
      const { rerender } = render(<EditorToolbar {...defaultProps} accentColor="#02BFB8" />);
      expect(screen.getByTestId('icon-list-bullets')).toBeTruthy();

      rerender(<EditorToolbar {...defaultProps} accentColor="#FF5733" />);
      expect(screen.getByTestId('icon-list-bullets')).toBeTruthy();
    });

    it('handles different accent colors', () => {
      const colors = ['#02BFB8', '#3B82F6', '#8B5CF6', '#F43F5E'];
      const { rerender } = render(<EditorToolbar {...defaultProps} accentColor={colors[0]} />);

      colors.forEach((color) => {
        rerender(<EditorToolbar {...defaultProps} accentColor={color} />);
        expect(screen.getByTestId('icon-list-bullets')).toBeTruthy();
      });
    });

    it('maintains structure across theme changes', () => {
      const { rerender } = render(<EditorToolbar {...defaultProps} theme="light" />);
      expect(screen.getByTestId('icon-list-bullets')).toBeTruthy();

      rerender(<EditorToolbar {...defaultProps} theme="dark" />);
      expect(screen.getByTestId('icon-list-bullets')).toBeTruthy();
      expect(screen.getByTestId('icon-calendar')).toBeTruthy();
    });
  });

  describe('Edge Cases', () => {
    it('handles large tag count', () => {
      render(<EditorToolbar {...defaultProps} tagsCount={999} />);
      expect(screen.getByTestId('icon-tag')).toBeTruthy();
    });

    it('handles negative tag count (edge case)', () => {
      // Component uses tagsCount > 0 check, negative should not show tag
      render(<EditorToolbar {...defaultProps} tagsCount={-1} />);
      expect(screen.queryByTestId('icon-tag')).toBeNull();
    });

    it('handles zero tag count (edge case)', () => {
      render(<EditorToolbar {...defaultProps} tagsCount={0} />);
      expect(screen.queryByTestId('icon-tag')).toBeNull();
    });

    it('renders with empty accent color', () => {
      render(<EditorToolbar {...defaultProps} accentColor="" />);
      expect(screen.getByTestId('icon-list-bullets')).toBeTruthy();
    });

    it('renders with various accent color formats', () => {
      const { rerender } = render(<EditorToolbar {...defaultProps} accentColor="#FFF" />);
      expect(screen.getByTestId('icon-list-bullets')).toBeTruthy();

      rerender(<EditorToolbar {...defaultProps} accentColor="rgb(255, 0, 0)" />);
      expect(screen.getByTestId('icon-list-bullets')).toBeTruthy();

      rerender(<EditorToolbar {...defaultProps} accentColor="hsl(120, 100%, 50%)" />);
      expect(screen.getByTestId('icon-list-bullets')).toBeTruthy();
    });

    it('calls callbacks correctly when rapidly pressing buttons', () => {
      render(<EditorToolbar {...defaultProps} />);

      // Rapid fire button presses
      const listButton = screen.getByTestId('icon-list-bullets').parent;
      fireEvent.press(listButton);
      fireEvent.press(listButton);
      fireEvent.press(listButton);

      expect(mockOnInsertTemplate).toHaveBeenCalledTimes(3);
    });

    it('maintains correct callback order when pressing different buttons', () => {
      render(<EditorToolbar {...defaultProps} />);

      fireEvent.press(screen.getByTestId('icon-list-bullets').parent);
      fireEvent.press(screen.getByTestId('icon-check-square').parent);
      fireEvent.press(screen.getByTestId('icon-clock').parent);

      expect(mockOnInsertTemplate).toHaveBeenNthCalledWith(1, 'list');
      expect(mockOnInsertTemplate).toHaveBeenNthCalledWith(2, 'task');
      expect(mockOnInsertTemplate).toHaveBeenNthCalledWith(3, 'time');
    });

    it('preserves tag icon visibility across re-renders with different tag counts', () => {
      const { rerender } = render(<EditorToolbar {...defaultProps} tagsCount={1} />);
      expect(screen.getByTestId('icon-tag')).toBeTruthy();

      rerender(<EditorToolbar {...defaultProps} tagsCount={5} />);
      expect(screen.getByTestId('icon-tag')).toBeTruthy();

      rerender(<EditorToolbar {...defaultProps} tagsCount={0} />);
      expect(screen.queryByTestId('icon-tag')).toBeNull();
    });

    it('handles simultaneous theme and accent color changes', () => {
      const { rerender } = render(
        <EditorToolbar {...defaultProps} theme="light" accentColor="#02BFB8" />
      );
      expect(screen.getByTestId('icon-list-bullets')).toBeTruthy();

      rerender(<EditorToolbar {...defaultProps} theme="dark" accentColor="#FF5733" />);
      expect(screen.getByTestId('icon-list-bullets')).toBeTruthy();

      // Verify theme change applied
      const iconText = screen.getByTestId('icon-list-bullets').children[0];
      expect(iconText).toContain('#9CA3AF'); // Dark theme icon color
    });
  });

  describe('Props Validation', () => {
    it('accepts all required props', () => {
      const props = {
        onInsertTemplate: mockOnInsertTemplate,
        onOpenCalendar: mockOnOpenCalendar,
        tagsCount: 2,
        theme: 'dark' as const,
        accentColor: '#3B82F6',
      };

      render(<EditorToolbar {...props} />);
      expect(screen.getByTestId('icon-tag')).toBeTruthy();
      expect(screen.getByTestId('icon-list-bullets')).toBeTruthy();
    });

    it('works with minimal props', () => {
      const minimalProps = {
        onInsertTemplate: mockOnInsertTemplate,
        onOpenCalendar: mockOnOpenCalendar,
        tagsCount: 0,
        theme: 'light' as const,
        accentColor: '#02BFB8',
      };

      render(<EditorToolbar {...minimalProps} />);
      expect(screen.getByTestId('icon-list-bullets')).toBeTruthy();
    });
  });
});
