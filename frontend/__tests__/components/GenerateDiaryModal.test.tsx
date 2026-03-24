import React from 'react';
import { fireEvent, render, screen } from '@testing-library/react-native';
import { GenerateDiaryModal } from '@/components/journal/GenerateDiaryModal';

describe('GenerateDiaryModal', () => {
  const defaultProps = {
    visible: true,
    accentColor: '#02BFB8',
    resolvedTheme: 'light' as const,
    i18n: {
      generateDiary: '生成日记',
      cancel: '取消',
      confirm: '确认',
    },
    onCancel: jest.fn(),
    onConfirm: jest.fn(),
  };

  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('Rendering Tests', () => {
    it('renders when visible prop is true', () => {
      render(<GenerateDiaryModal {...defaultProps} visible={true} />);

      expect(screen.getByText('生成日记')).toBeTruthy();
      expect(screen.getByText('根据我们的对话生成今天的日记？')).toBeTruthy();
    });

    it('renders when visible prop is false', () => {
      const { toJSON } = render(<GenerateDiaryModal {...defaultProps} visible={false} />);

      // Modal with visible=false should not display content
      expect(toJSON()).toBeNull();
    });

    it('displays modal title from i18n', () => {
      render(<GenerateDiaryModal {...defaultProps} />);

      const title = screen.getByText('生成日记');
      expect(title).toBeTruthy();
    });

    it('displays modal description text', () => {
      render(<GenerateDiaryModal {...defaultProps} />);

      const description = screen.getByText('根据我们的对话生成今天的日记？');
      expect(description).toBeTruthy();
    });

    it('displays cancel button with correct text', () => {
      render(<GenerateDiaryModal {...defaultProps} />);

      const cancelButton = screen.getByText('取消');
      expect(cancelButton).toBeTruthy();
    });

    it('displays confirm button with correct text', () => {
      render(<GenerateDiaryModal {...defaultProps} />);

      const confirmButton = screen.getByText('确认');
      expect(confirmButton).toBeTruthy();
    });

    it('renders both buttons in the modal', () => {
      render(<GenerateDiaryModal {...defaultProps} />);

      const cancelButton = screen.getByText('取消');
      const confirmButton = screen.getByText('确认');

      expect(cancelButton).toBeTruthy();
      expect(confirmButton).toBeTruthy();
    });

    it('renders modal with custom i18n strings', () => {
      const customI18n = {
        generateDiary: 'Generate Diary',
        cancel: 'Cancel',
        confirm: 'Confirm',
      };
      render(<GenerateDiaryModal {...defaultProps} i18n={customI18n} />);

      expect(screen.getByText('Generate Diary')).toBeTruthy();
      expect(screen.getByText('Cancel')).toBeTruthy();
      expect(screen.getByText('Confirm')).toBeTruthy();
    });
  });

  describe('Interaction Tests', () => {
    it('calls onCancel when cancel button is pressed', () => {
      const onCancel = jest.fn();
      render(<GenerateDiaryModal {...defaultProps} onCancel={onCancel} />);

      const cancelButton = screen.getByText('取消');
      fireEvent.press(cancelButton);

      expect(onCancel).toHaveBeenCalledTimes(1);
      expect(onCancel).toHaveBeenCalledWith();
    });

    it('calls onConfirm when confirm button is pressed', () => {
      const onConfirm = jest.fn();
      render(<GenerateDiaryModal {...defaultProps} onConfirm={onConfirm} />);

      const confirmButton = screen.getByText('确认');
      fireEvent.press(confirmButton);

      expect(onConfirm).toHaveBeenCalledTimes(1);
      expect(onConfirm).toHaveBeenCalledWith();
    });

    it('calls onCancel multiple times when pressed multiple times', () => {
      const onCancel = jest.fn();
      render(<GenerateDiaryModal {...defaultProps} onCancel={onCancel} />);

      const cancelButton = screen.getByText('取消');
      fireEvent.press(cancelButton);
      fireEvent.press(cancelButton);
      fireEvent.press(cancelButton);

      expect(onCancel).toHaveBeenCalledTimes(3);
    });

    it('calls onConfirm multiple times when pressed multiple times', () => {
      const onConfirm = jest.fn();
      render(<GenerateDiaryModal {...defaultProps} onConfirm={onConfirm} />);

      const confirmButton = screen.getByText('确认');
      fireEvent.press(confirmButton);
      fireEvent.press(confirmButton);

      expect(onConfirm).toHaveBeenCalledTimes(2);
    });

    it('calls correct callback when cancel and confirm are pressed in sequence', () => {
      const onCancel = jest.fn();
      const onConfirm = jest.fn();
      render(<GenerateDiaryModal {...defaultProps} onCancel={onCancel} onConfirm={onConfirm} />);

      const cancelButton = screen.getByText('取消');
      const confirmButton = screen.getByText('确认');

      fireEvent.press(cancelButton);
      expect(onCancel).toHaveBeenCalledTimes(1);
      expect(onConfirm).not.toHaveBeenCalled();

      fireEvent.press(confirmButton);
      expect(onConfirm).toHaveBeenCalledTimes(1);
    });
  });

  describe('Theme and Style Tests', () => {
    it('renders with light theme', () => {
      const { root } = render(<GenerateDiaryModal {...defaultProps} resolvedTheme="light" />);

      expect(root).toBeTruthy();
      expect(screen.getByText('生成日记')).toBeTruthy();
    });

    it('renders with dark theme', () => {
      const { root } = render(<GenerateDiaryModal {...defaultProps} resolvedTheme="dark" />);

      expect(root).toBeTruthy();
      expect(screen.getByText('生成日记')).toBeTruthy();
    });

    it('renders with different accent colors', () => {
      const accentColors = ['#FF0000', '#00FF00', '#0000FF', '#02BFB8'];

      accentColors.forEach((color) => {
        const { rerender } = render(<GenerateDiaryModal {...defaultProps} accentColor={color} />);
        expect(screen.getByText('确认')).toBeTruthy();
        rerender(<GenerateDiaryModal {...defaultProps} />);
      });
    });

    it('renders with default teal accent color', () => {
      const { getByText } = render(<GenerateDiaryModal {...defaultProps} accentColor="#02BFB8" />);

      expect(getByText('确认')).toBeTruthy();
    });

    it('switches between light and dark themes correctly', () => {
      const { rerender } = render(<GenerateDiaryModal {...defaultProps} resolvedTheme="light" />);

      expect(screen.getByText('生成日记')).toBeTruthy();

      rerender(<GenerateDiaryModal {...defaultProps} resolvedTheme="dark" />);

      expect(screen.getByText('生成日记')).toBeTruthy();
    });
  });

  describe('Edge Cases', () => {
    it('renders with empty i18n strings', () => {
      const emptyI18n = {
        generateDiary: '',
        cancel: '',
        confirm: '',
      };
      const { root } = render(<GenerateDiaryModal {...defaultProps} i18n={emptyI18n} />);

      expect(root).toBeTruthy();
    });

    it('renders with long i18n strings', () => {
      const longI18n = {
        generateDiary: '生成日记生成日记生成日记生成日记',
        cancel: '取消取消取消取消取消取消取消取消',
        confirm: '确认确认确认确认确认确认确认确认',
      };
      const { getByText } = render(<GenerateDiaryModal {...defaultProps} i18n={longI18n} />);

      expect(getByText('生成日记生成日记生成日记生成日记')).toBeTruthy();
      expect(getByText('取消取消取消取消取消取消取消取消')).toBeTruthy();
      expect(getByText('确认确认确认确认确认确认确认确认')).toBeTruthy();
    });

    it('handles rapid button presses correctly', () => {
      const onCancel = jest.fn();
      const onConfirm = jest.fn();
      render(<GenerateDiaryModal {...defaultProps} onCancel={onCancel} onConfirm={onConfirm} />);

      const cancelButton = screen.getByText('取消');
      const confirmButton = screen.getByText('确认');

      // Rapid alternation
      fireEvent.press(cancelButton);
      fireEvent.press(confirmButton);
      fireEvent.press(cancelButton);
      fireEvent.press(confirmButton);
      fireEvent.press(cancelButton);

      expect(onCancel).toHaveBeenCalledTimes(3);
      expect(onConfirm).toHaveBeenCalledTimes(2);
    });

    it('renders with minimal props', () => {
      const minimalProps = {
        visible: true,
        accentColor: '#000000',
        resolvedTheme: 'dark' as const,
        i18n: {
          generateDiary: 'A',
          cancel: 'B',
          confirm: 'C',
        },
        onCancel: jest.fn(),
        onConfirm: jest.fn(),
      };

      const { getByText } = render(<GenerateDiaryModal {...minimalProps} />);

      expect(getByText('A')).toBeTruthy();
      expect(getByText('B')).toBeTruthy();
      expect(getByText('C')).toBeTruthy();
    });

    it('renders with special characters in i18n', () => {
      const specialI18n = {
        generateDiary: 'Generate ♥ Diary! 📝',
        cancel: '<Cancel> & "Test"',
        confirm: '確認@#$%^&*()',
      };
      const { getByText } = render(<GenerateDiaryModal {...defaultProps} i18n={specialI18n} />);

      expect(getByText('Generate ♥ Diary! 📝')).toBeTruthy();
      expect(getByText('<Cancel> & "Test"')).toBeTruthy();
      expect(getByText('確認@#$%^&*()')).toBeTruthy();
    });

    it('maintains callback references after rerender', () => {
      const onCancel = jest.fn();
      const onConfirm = jest.fn();
      const { rerender, getByText } = render(
        <GenerateDiaryModal {...defaultProps} onCancel={onCancel} onConfirm={onConfirm} />
      );

      rerender(
        <GenerateDiaryModal
          {...defaultProps}
          onCancel={onCancel}
          onConfirm={onConfirm}
          accentColor="#FF0000"
        />
      );

      fireEvent.press(getByText('取消'));
      fireEvent.press(getByText('确认'));

      expect(onCancel).toHaveBeenCalledTimes(1);
      expect(onConfirm).toHaveBeenCalledTimes(1);
    });

    it('renders correctly when toggling visibility', () => {
      const { rerender } = render(<GenerateDiaryModal {...defaultProps} visible={true} />);

      expect(screen.getByText('生成日记')).toBeTruthy();

      rerender(<GenerateDiaryModal {...defaultProps} visible={false} />);

      // Component should still exist in tree
      expect(screen.queryByText('生成日记')).toBeNull();

      rerender(<GenerateDiaryModal {...defaultProps} visible={true} />);

      expect(screen.getByText('生成日记')).toBeTruthy();
    });
  });

  describe('Modal Visibility Tests', () => {
    it('modal is visible with visible=true', () => {
      render(<GenerateDiaryModal {...defaultProps} visible={true} />);

      const title = screen.getByText('生成日记');
      expect(title).toBeTruthy();
    });

    it('modal content is not accessible when visible=false', () => {
      render(<GenerateDiaryModal {...defaultProps} visible={false} />);

      const title = screen.queryByText('生成日记');
      expect(title).toBeNull();
    });

    it('toggles from visible to invisible correctly', () => {
      const { rerender } = render(<GenerateDiaryModal {...defaultProps} visible={true} />);

      expect(screen.getByText('生成日记')).toBeTruthy();

      rerender(<GenerateDiaryModal {...defaultProps} visible={false} />);

      expect(screen.queryByText('生成日记')).toBeNull();
    });

    it('toggles from invisible to visible correctly', () => {
      const { rerender } = render(<GenerateDiaryModal {...defaultProps} visible={false} />);

      expect(screen.queryByText('生成日记')).toBeNull();

      rerender(<GenerateDiaryModal {...defaultProps} visible={true} />);

      expect(screen.getByText('生成日记')).toBeTruthy();
    });
  });
});
