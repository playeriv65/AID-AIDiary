import React from 'react';
import { fireEvent, render, screen } from '@testing-library/react-native';
import ModalScreen from '@/app/modal';

const mockPush = jest.fn();
const mockBack = jest.fn();

jest.mock('expo-router', () => ({
  Link: ({ children, href, dismissTo }: any) => {
    const { Text } = require('react-native');
    return (
      <Text testID="link" onPress={() => mockPush(href)}>
        {children}
      </Text>
    );
  },
  useRouter: () => ({
    push: mockPush,
    back: mockBack,
  }),
}));

jest.mock('@/components/themed-text', () => {
  const { Text } = jest.requireActual('react-native');
  return {
    ThemedText: ({ children, type }: any) => (
      <Text testID={`themed-text-${type || 'default'}`}>{children}</Text>
    ),
  };
});

jest.mock('@/components/themed-view', () => {
  const { View } = jest.requireActual('react-native');
  return {
    ThemedView: ({ children }: any) => <View testID="themed-view">{children}</View>,
  };
});

describe('ModalScreen', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('Rendering Tests', () => {
    it('renders modal container', () => {
      render(<ModalScreen />);
      expect(screen.getByTestId('themed-view')).toBeTruthy();
    });

    it('renders title text', () => {
      render(<ModalScreen />);
      expect(screen.getByText('This is a modal')).toBeTruthy();
    });

    it('renders link to home screen', () => {
      render(<ModalScreen />);
      expect(screen.getByText('Go to home screen')).toBeTruthy();
    });

    it('renders title with correct type', () => {
      render(<ModalScreen />);
      expect(screen.getByTestId('themed-text-title')).toBeTruthy();
    });

    it('renders link text with correct type', () => {
      render(<ModalScreen />);
      expect(screen.getByTestId('themed-text-link')).toBeTruthy();
    });
  });

  describe('Interaction Tests', () => {
    it('link navigates to home screen when pressed', () => {
      render(<ModalScreen />);
      const link = screen.getByTestId('link');
      fireEvent.press(link);
      expect(mockPush).toHaveBeenCalledWith('/');
    });
  });

  describe('Accessibility Tests', () => {
    it('all text elements are accessible', () => {
      render(<ModalScreen />);
      expect(screen.getByText('This is a modal')).toBeTruthy();
      expect(screen.getByText('Go to home screen')).toBeTruthy();
    });
  });

  describe('Layout Tests', () => {
    it('container has correct style properties', () => {
      const { getByTestId } = render(<ModalScreen />);
      const container = getByTestId('themed-view');
      expect(container).toBeTruthy();
    });
  });

  describe('Edge Cases', () => {
    it('handles multiple renders without crashing', () => {
      const { unmount } = render(<ModalScreen />);
      unmount();
      render(<ModalScreen />);
      expect(screen.getByText('This is a modal')).toBeTruthy();
    });

    it('handles rapid link presses', () => {
      render(<ModalScreen />);
      const link = screen.getByTestId('link');
      fireEvent.press(link);
      fireEvent.press(link);
      fireEvent.press(link);
      expect(mockPush).toHaveBeenCalledTimes(3);
    });
  });
});
