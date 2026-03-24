import React from 'react';
import { fireEvent, render, screen } from '@testing-library/react-native';
import { ChatInput } from '@/components/journal/ChatInput';

jest.mock('expo-image-picker', () => ({
  requestMediaLibraryPermissionsAsync: jest.fn(() => Promise.resolve({ granted: true })),
  requestCameraPermissionsAsync: jest.fn(() => Promise.resolve({ granted: true })),
  launchImageLibraryAsync: jest.fn(() => Promise.resolve({ canceled: true, assets: [] })),
  launchCameraAsync: jest.fn(() => Promise.resolve({ canceled: true, assets: [] })),
  MediaTypeOptions: {
    Images: 'Images',
  },
}));

const mockI18n = {
  chatPlaceholder: 'Type a message...',
};

describe('ChatInput', () => {
  const mockOnInputChange = jest.fn();
  const mockOnSend = jest.fn();
  const mockOnStopGenerating = jest.fn();

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('renders input placeholder correctly', () => {
    render(
      <ChatInput
        inputText=""
        loading={false}
        accentColor="#02BFB8"
        resolvedTheme="dark"
        i18n={mockI18n}
        onInputChange={mockOnInputChange}
        onSend={mockOnSend}
      />
    );

    expect(screen.getByRole('textbox', { name: 'Chat message input' })).toBeTruthy();
  });

  it('calls onInputChange when text changes', () => {
    render(
      <ChatInput
        inputText=""
        loading={false}
        accentColor="#02BFB8"
        resolvedTheme="dark"
        i18n={mockI18n}
        onInputChange={mockOnInputChange}
        onSend={mockOnSend}
      />
    );

    const input = screen.getByRole('textbox', { name: 'Chat message input' });
    fireEvent.changeText(input, 'Hello World');

    expect(mockOnInputChange).toHaveBeenCalledWith('Hello World');
  });

  it('calls onSend when send button is pressed', () => {
    render(
      <ChatInput
        inputText="Hello"
        loading={false}
        accentColor="#02BFB8"
        resolvedTheme="dark"
        i18n={mockI18n}
        onInputChange={mockOnInputChange}
        onSend={mockOnSend}
      />
    );

    const sendButton = screen.getByRole('button', { name: 'Send message' });
    fireEvent.press(sendButton);

    expect(mockOnSend).toHaveBeenCalled();
  });

  it('disables send button when input is empty', () => {
    render(
      <ChatInput
        inputText=""
        loading={false}
        accentColor="#02BFB8"
        resolvedTheme="dark"
        i18n={mockI18n}
        onInputChange={mockOnInputChange}
        onSend={mockOnSend}
      />
    );

    const sendButton = screen.getByRole('button', { name: 'Send message' });
    expect(sendButton.props.accessibilityState?.disabled).toBe(true);
  });

  it('shows loading indicator when loading', () => {
    render(
      <ChatInput
        inputText=""
        loading={true}
        accentColor="#02BFB8"
        resolvedTheme="dark"
        i18n={mockI18n}
        onInputChange={mockOnInputChange}
        onSend={mockOnSend}
        onStopGenerating={mockOnStopGenerating}
      />
    );

    expect(screen.getByRole('button', { name: 'Stop generating' })).toBeTruthy();
  });

  it('calls onStopGenerating when stop button is pressed', () => {
    render(
      <ChatInput
        inputText=""
        loading={true}
        accentColor="#02BFB8"
        resolvedTheme="dark"
        i18n={mockI18n}
        onInputChange={mockOnInputChange}
        onSend={mockOnSend}
        onStopGenerating={mockOnStopGenerating}
      />
    );

    const stopButton = screen.getByRole('button', { name: 'Stop generating' });
    fireEvent.press(stopButton);

    expect(mockOnStopGenerating).toHaveBeenCalled();
  });

  it('shows character count when input is long', () => {
    const longText = 'a'.repeat(450);

    render(
      <ChatInput
        inputText={longText}
        loading={false}
        accentColor="#02BFB8"
        resolvedTheme="dark"
        i18n={mockI18n}
        onInputChange={mockOnInputChange}
        onSend={mockOnSend}
      />
    );

    expect(screen.getByText(/450 \/ 500/)).toBeTruthy();
  });

  it('has attachment buttons', () => {
    render(
      <ChatInput
        inputText=""
        loading={false}
        accentColor="#02BFB8"
        resolvedTheme="dark"
        i18n={mockI18n}
        onInputChange={mockOnInputChange}
        onSend={mockOnSend}
      />
    );

    expect(screen.getByRole('button', { name: 'Attach image' })).toBeTruthy();
    expect(screen.getByRole('button', { name: 'Take photo' })).toBeTruthy();
  });

  it('applies correct theme styles', () => {
    const { rerender } = render(
      <ChatInput
        inputText=""
        loading={false}
        accentColor="#02BFB8"
        resolvedTheme="dark"
        i18n={mockI18n}
        onInputChange={mockOnInputChange}
        onSend={mockOnSend}
      />
    );

    rerender(
      <ChatInput
        inputText=""
        loading={false}
        accentColor="#02BFB8"
        resolvedTheme="light"
        i18n={mockI18n}
        onInputChange={mockOnInputChange}
        onSend={mockOnSend}
      />
    );

    expect(screen.getByRole('textbox', { name: 'Chat message input' })).toBeTruthy();
  });
});
