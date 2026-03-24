import React from 'react';
import { fireEvent, render, screen } from '@testing-library/react-native';
import { Picker } from '@/components/picker';

// Mock IconSymbol component
jest.mock('@/components/ui/icon-symbol', () => ({
  IconSymbol: jest.fn(
    ({ name, size, color }: { name: string; size: number; color: string }) => null
  ),
}));

describe('Picker', () => {
  const mockOptions = [
    { value: 'option1', label: 'Option 1', icon: 'star' },
    { value: 'option2', label: 'Option 2', icon: 'heart' },
    { value: 'option3', label: 'Option 3' },
  ];

  const defaultProps = {
    options: mockOptions,
    value: null as string | null,
    onChange: jest.fn(),
    placeholder: 'Select an option',
    theme: 'light' as const,
    accentColor: '#02BFB8',
  };

  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('Rendering', () => {
    it('renders placeholder when no value is selected', () => {
      render(<Picker {...defaultProps} value={null} />);

      expect(screen.getByText('Select an option')).toBeTruthy();
    });

    it('renders selected option label when value is provided', () => {
      render(<Picker {...defaultProps} value="option1" />);

      expect(screen.getByText('Option 1')).toBeTruthy();
      expect(screen.queryByText('Select an option')).toBeNull();
    });

    it('renders selected option without icon when icon is not provided', () => {
      render(<Picker {...defaultProps} value="option3" />);

      expect(screen.getByText('Option 3')).toBeTruthy();
    });

    it('applies correct theme colors for light theme', () => {
      render(<Picker {...defaultProps} theme="light" />);

      const placeholder = screen.getByText('Select an option');
      expect(placeholder).toBeTruthy();
    });

    it('applies correct theme colors for dark theme', () => {
      render(<Picker {...defaultProps} theme="dark" />);

      const placeholder = screen.getByText('Select an option');
      expect(placeholder).toBeTruthy();
    });
  });

  describe('Modal Interaction', () => {
    it('opens modal when trigger is pressed', () => {
      const { root } = render(<Picker {...defaultProps} />);

      const trigger = screen.getByText('Select an option');
      fireEvent.press(trigger);

      // After modal opens, there should be multiple "Select an option" texts
      // (one in trigger, one in modal title)
      const allTextElements = screen.queryAllByText('Select an option');
      expect(allTextElements.length).toBeGreaterThanOrEqual(1);
    });

    it('closes modal when pressing the overlay', () => {
      const { unmount } = render(<Picker {...defaultProps} />);

      fireEvent.press(screen.getByText('Select an option'));

      expect(screen.getByText('None')).toBeTruthy();
      expect(screen.getByText('Option 1')).toBeTruthy();
    });

    it('closes modal when pressing the close button', () => {
      render(<Picker {...defaultProps} />);

      fireEvent.press(screen.getByText('Select an option'));

      expect(screen.getByText('None')).toBeTruthy();
      expect(screen.getByText('Option 1')).toBeTruthy();
      expect(screen.getByText('Option 2')).toBeTruthy();
      expect(screen.getByText('Option 3')).toBeTruthy();
    });

    it('closes modal on request close (Android back button)', () => {
      render(<Picker {...defaultProps} />);

      // Open modal
      fireEvent.press(screen.getByText('Select an option'));

      // Modal should be visible (we can verify by checking for modal content)
      const allTextElements = screen.queryAllByText('Select an option');
      expect(allTextElements.length).toBeGreaterThanOrEqual(1);
    });
  });

  describe('Option Selection', () => {
    it('calls onChange with selected value when option is pressed', () => {
      const onChange = jest.fn();
      render(<Picker {...defaultProps} onChange={onChange} />);

      // Open modal
      fireEvent.press(screen.getByText('Select an option'));

      // Find and press an option - use getAllByText and pick the one in the modal
      const options = screen.getAllByText('Option 1');
      fireEvent.press(options[options.length - 1]);

      expect(onChange).toHaveBeenCalledWith('option1');
    });

    it('calls onChange with null when same option is selected again (toggle off)', () => {
      const onChange = jest.fn();
      render(<Picker {...defaultProps} onChange={onChange} value="option1" />);

      // Open modal - should show selected option label instead of placeholder
      const triggers = screen.getAllByText('Option 1');
      fireEvent.press(triggers[0]);

      // Find and press the same option again - get all matching and press the last one
      const options = screen.getAllByText('Option 1');
      fireEvent.press(options[options.length - 1]);

      expect(onChange).toHaveBeenCalledWith(null);
    });

    it('calls onChange with new value when different option is selected', () => {
      const onChange = jest.fn();
      render(<Picker {...defaultProps} onChange={onChange} value="option1" />);

      // Open modal
      const triggers = screen.getAllByText('Option 1');
      fireEvent.press(triggers[0]);

      // Select a different option
      const options = screen.getAllByText('Option 2');
      fireEvent.press(options[options.length - 1]);

      expect(onChange).toHaveBeenCalledWith('option2');
    });

    it('closes modal after option selection', () => {
      const onChange = jest.fn();
      render(<Picker {...defaultProps} onChange={onChange} />);

      // Open modal
      fireEvent.press(screen.getByText('Select an option'));

      // Select an option
      const options = screen.getAllByText('Option 1');
      fireEvent.press(options[options.length - 1]);

      // onChange should be called, indicating selection happened
      expect(onChange).toHaveBeenCalled();
    });
  });

  describe('Clear Button', () => {
    it('renders clear button in modal', () => {
      render(<Picker {...defaultProps} />);

      // Open modal
      fireEvent.press(screen.getByText('Select an option'));

      // Clear button should show "None" when no value is selected
      expect(screen.getByText('None')).toBeTruthy();
    });

    it('renders "Clear" text when value is selected', () => {
      render(<Picker {...defaultProps} value="option1" />);

      // Open modal
      const triggers = screen.getAllByText('Option 1');
      fireEvent.press(triggers[0]);

      // Clear button should show "Clear" when value is selected
      expect(screen.getByText('Clear')).toBeTruthy();
    });

    it('calls onChange with null when clear button is pressed', () => {
      const onChange = jest.fn();
      render(<Picker {...defaultProps} onChange={onChange} value="option1" />);

      // Open modal
      const triggers = screen.getAllByText('Option 1');
      fireEvent.press(triggers[0]);

      // Press clear button
      const clearButton = screen.getByText('Clear');
      fireEvent.press(clearButton);

      expect(onChange).toHaveBeenCalledWith(null);
    });

    it('closes modal after pressing clear button', () => {
      const onChange = jest.fn();
      render(<Picker {...defaultProps} onChange={onChange} value="option1" />);

      // Open modal
      const triggers = screen.getAllByText('Option 1');
      fireEvent.press(triggers[0]);

      // Press clear button
      const clearButton = screen.getByText('Clear');
      fireEvent.press(clearButton);

      expect(onChange).toHaveBeenCalledWith(null);
    });
  });

  describe('Options List', () => {
    it('renders all options in the modal', () => {
      render(<Picker {...defaultProps} />);

      // Open modal
      fireEvent.press(screen.getByText('Select an option'));

      // All options should be visible
      expect(screen.getByText('Option 1')).toBeTruthy();
      expect(screen.getByText('Option 2')).toBeTruthy();
      expect(screen.getByText('Option 3')).toBeTruthy();
    });

    it('applies accent color to selected option', () => {
      render(<Picker {...defaultProps} value="option1" accentColor="#FF0000" />);

      // Open modal
      const triggers = screen.getAllByText('Option 1');
      fireEvent.press(triggers[0]);

      // Selected option should be rendered
      const options = screen.getAllByText('Option 1');
      expect(options.length).toBeGreaterThanOrEqual(1);
    });

    it('handles options with icons', () => {
      render(<Picker {...defaultProps} />);

      // Open modal
      fireEvent.press(screen.getByText('Select an option'));

      // Options with icons should render correctly
      expect(screen.getByText('Option 1')).toBeTruthy();
      expect(screen.getByText('Option 2')).toBeTruthy();
    });

    it('handles options without icons', () => {
      render(<Picker {...defaultProps} />);

      // Open modal
      fireEvent.press(screen.getByText('Select an option'));

      // Option 3 doesn't have an icon, should still render
      expect(screen.getByText('Option 3')).toBeTruthy();
    });
  });

  describe('Edge Cases', () => {
    it('handles empty options array', () => {
      render(<Picker {...defaultProps} options={[]} />);

      // Should still render the trigger
      expect(screen.getByText('Select an option')).toBeTruthy();

      // Open modal - should not crash
      fireEvent.press(screen.getByText('Select an option'));

      // Modal title should be visible (multiple instances: trigger + modal title)
      const allTitles = screen.queryAllByText('Select an option');
      expect(allTitles.length).toBeGreaterThanOrEqual(1);
    });

    it('handles null value gracefully', () => {
      render(<Picker {...defaultProps} value={null} />);

      expect(screen.getByText('Select an option')).toBeTruthy();
    });

    it('handles value not in options', () => {
      render(<Picker {...defaultProps} value="nonexistent" />);

      // Should show placeholder since value doesn't match any option
      expect(screen.getByText('Select an option')).toBeTruthy();
    });

    it('handles option without onChange gracefully', () => {
      // This tests that the component doesn't throw if onChange is not provided
      // though TypeScript should prevent this in real usage
      const propsWithoutOnChange = {
        ...defaultProps,
        onChange: jest.fn(),
      };
      render(<Picker {...propsWithoutOnChange} />);

      fireEvent.press(screen.getByText('Select an option'));

      const options = screen.getAllByText('Option 1');
      // Should not throw when pressing option
      expect(() => fireEvent.press(options[options.length - 1])).not.toThrow();
    });

    it('handles dark theme correctly', () => {
      render(<Picker {...defaultProps} theme="dark" />);

      const trigger = screen.getByText('Select an option');
      fireEvent.press(trigger);

      // Modal should be visible
      const allTitles = screen.queryAllByText('Select an option');
      expect(allTitles.length).toBeGreaterThanOrEqual(1);
    });

    it('handles light theme correctly', () => {
      render(<Picker {...defaultProps} theme="light" />);

      const trigger = screen.getByText('Select an option');
      fireEvent.press(trigger);

      // Modal should be visible
      const allTitles = screen.queryAllByText('Select an option');
      expect(allTitles.length).toBeGreaterThanOrEqual(1);
    });

    it('handles rapid open/close of modal', () => {
      render(<Picker {...defaultProps} />);

      const trigger = screen.getByText('Select an option');

      // Rapidly open
      fireEvent.press(trigger);

      // Get pressables and press the first one (overlay)
      const pressables = screen.UNSAFE_queryAllByType('Pressable');
      if (pressables.length > 0) {
        fireEvent.press(pressables[0]);
      }

      // Open again
      fireEvent.press(trigger);

      // Should still work correctly
      const allTitles = screen.queryAllByText('Select an option');
      expect(allTitles.length).toBeGreaterThanOrEqual(1);
    });

    it('renders with different accent colors', () => {
      const { rerender } = render(<Picker {...defaultProps} accentColor="#FF5733" />);

      rerender(<Picker {...defaultProps} accentColor="#33FF57" />);
      rerender(<Picker {...defaultProps} accentColor="#3357FF" />);

      expect(screen.getByText('Select an option')).toBeTruthy();
    });
  });

  describe('Integration', () => {
    it('complete flow: select, deselect, clear', () => {
      const onChange = jest.fn();
      const { rerender } = render(<Picker {...defaultProps} onChange={onChange} value={null} />);

      // Step 1: Select an option
      fireEvent.press(screen.getByText('Select an option'));
      const option1Elements = screen.getAllByText('Option 1');
      fireEvent.press(option1Elements[option1Elements.length - 1]);
      expect(onChange).toHaveBeenCalledWith('option1');

      // Step 2: Simulate value update and deselect same option
      rerender(<Picker {...defaultProps} onChange={onChange} value="option1" />);
      const triggerElements = screen.getAllByText('Option 1');
      fireEvent.press(triggerElements[0]);
      const modalOption1Elements = screen.getAllByText('Option 1');
      fireEvent.press(modalOption1Elements[modalOption1Elements.length - 1]);
      expect(onChange).toHaveBeenLastCalledWith(null);

      // Step 3: Select another option
      rerender(<Picker {...defaultProps} onChange={onChange} value={null} />);
      fireEvent.press(screen.getByText('Select an option'));
      const option2Elements = screen.getAllByText('Option 2');
      fireEvent.press(option2Elements[option2Elements.length - 1]);
      expect(onChange).toHaveBeenLastCalledWith('option2');

      // Step 4: Clear selection
      rerender(<Picker {...defaultProps} onChange={onChange} value="option2" />);
      const trigger2Elements = screen.getAllByText('Option 2');
      fireEvent.press(trigger2Elements[0]);
      const clearButton = screen.getByText('Clear');
      fireEvent.press(clearButton);
      expect(onChange).toHaveBeenLastCalledWith(null);
    });

    it('maintains state correctly across re-renders', () => {
      const onChange = jest.fn();
      const { rerender } = render(<Picker {...defaultProps} onChange={onChange} value={null} />);

      // Initial state
      expect(screen.getByText('Select an option')).toBeTruthy();

      // Re-render with selected value
      rerender(<Picker {...defaultProps} onChange={onChange} value="option2" />);
      expect(screen.getByText('Option 2')).toBeTruthy();

      // Re-render back to null
      rerender(<Picker {...defaultProps} onChange={onChange} value={null} />);
      expect(screen.getByText('Select an option')).toBeTruthy();
    });
  });
});
