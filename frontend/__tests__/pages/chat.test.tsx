import React from 'react';
import { act, fireEvent, render, screen, waitFor } from '@testing-library/react-native';
import { Alert } from 'react-native';

import ChatScreen from '@/app/(tabs)/chat';

const mockPush = jest.fn();
const mockBack = jest.fn();

jest.mock('expo-router', () => ({
  useRouter: () => ({
    push: mockPush,
    back: mockBack,
  }),
}));

jest.mock('axios', () => ({
  post: jest.fn(),
  default: {
    post: jest.fn(),
  },
}));

const mockAlert = jest.fn();
jest.spyOn(Alert, 'alert').mockImplementation(mockAlert);

jest.mock('@/components/ui/icon-symbol', () => ({
  IconSymbol: ({ name, size, color, testID }: any) => {
    const React = require('react');
    const { View, Text } = require('react-native');
    return (
      <View testID={testID || `icon-${name}`}>
        <Text>{name}</Text>
      </View>
    );
  },
}));

jest.mock('@/components/themed-view', () => ({
  ThemedView: ({ children, style }: any) => {
    const React = require('react');
    const { View } = require('react-native');
    return (
      <View testID="themed-view" style={style}>
        {children}
      </View>
    );
  },
}));

const mockFetchEntries = jest.fn();

const mockI18n = {
  error: 'Error',
  hint: 'Hint',
  clearChat: 'Clear Chat',
  cancel: 'Cancel',
  confirm: 'Confirm',
  chatPlaceholder: 'Type a message...',
  aiWelcome: 'Welcome to AI Chat',
  aiHint: 'Start a conversation',
};

const mockConversationState = {
  conversations: [] as any[],
  currentConversation: { id: 'test-conv', messages: [] } as any,
  loading: false,
  createConversation: jest.fn(() => Promise.resolve('new-conv-id')),
  switchConversation: jest.fn(() => Promise.resolve()),
  deleteConversation: jest.fn(() => Promise.resolve()),
  addMessage: jest.fn(() => Promise.resolve()),
  refreshConversations: jest.fn(() => Promise.resolve()),
};

jest.mock('@/context/AppContext', () => ({
  useAppContext: () => ({
    resolvedTheme: 'dark',
    accentColor: '#02BFB8',
    i18n: mockI18n,
    authToken: 'test-token',
    fetchEntries: mockFetchEntries,
  }),
}));

jest.mock('@/context/ConversationContext', () => ({
  useConversation: () => mockConversationState,
}));

// Mock Chat components
jest.mock('@/components/journal/ChatHeader', () => ({
  ChatHeader: (props: any) => {
    const React = require('react');
    const { View, Text, TouchableOpacity } = require('react-native');
    return (
      <View testID="chat-header">
        <Text testID="chat-header-title">{props.i18n?.aiChat || 'AI Chat'}</Text>
        {props.onToggleSidebar && (
          <TouchableOpacity testID="sidebar-toggle" onPress={props.onToggleSidebar}>
            <Text>Toggle Sidebar</Text>
          </TouchableOpacity>
        )}
        {props.hasMessages && (
          <TouchableOpacity testID="clear-button" onPress={props.onClear}>
            <Text>Clear</Text>
          </TouchableOpacity>
        )}
        <TouchableOpacity
          testID="generate-diary-button"
          onPress={props.onGenerateDiary}
          disabled={props.generating}
        >
          <Text>Generate</Text>
        </TouchableOpacity>
      </View>
    );
  },
}));

jest.mock('@/components/chat', () => ({
  ChatContainer: (props: any) => {
    const React = require('react');
    const { View, Text, TextInput, TouchableOpacity } = require('react-native');
    return (
      <View testID="chat-container">
        {props.messages.length === 0 && (
          <View testID="empty-state">
            <Text>{props.emptyState?.title}</Text>
            <Text>{props.emptyState?.subtitle}</Text>
          </View>
        )}
        {props.messages.map((msg: any) => (
          <View key={msg.id} testID={`message-${msg.role}`}>
            <Text>{msg.content}</Text>
          </View>
        ))}
        <TextInput
          testID="chat-input"
          value={props.inputText}
          placeholder={props.placeholder}
          onChangeText={props.onInputChange}
        />
        <TouchableOpacity testID="send-button" onPress={props.onSend} disabled={props.loading}>
          <Text>Send</Text>
        </TouchableOpacity>
        {props.loading && (
          <TouchableOpacity testID="stop-button" onPress={props.onStopGenerating}>
            <Text>Stop</Text>
          </TouchableOpacity>
        )}
      </View>
    );
  },
  ChatMessageType: {},
}));

jest.mock('@/components/chat/ConversationSidebar', () => ({
  ConversationSidebar: (props: any) => {
    const React = require('react');
    const { View, Text, TouchableOpacity } = require('react-native');
    if (!props.visible) return null;
    return (
      <View testID="conversation-sidebar">
        <Text>Conversation Sidebar</Text>
        <TouchableOpacity testID="new-conversation-button" onPress={props.onNewConversation}>
          <Text>New Conversation</Text>
        </TouchableOpacity>
        <TouchableOpacity testID="close-sidebar-button" onPress={props.onClose}>
          <Text>Close</Text>
        </TouchableOpacity>
      </View>
    );
  },
}));

jest.mock('@/components/journal/GenerateDiaryModal', () => ({
  GenerateDiaryModal: (props: any) => {
    const React = require('react');
    const { View, Text, TouchableOpacity } = require('react-native');
    if (!props.visible) return null;
    return (
      <View testID="generate-diary-modal">
        <Text>Generate Diary Modal</Text>
        <TouchableOpacity testID="cancel-modal" onPress={props.onCancel}>
          <Text>Cancel</Text>
        </TouchableOpacity>
        <TouchableOpacity testID="confirm-modal" onPress={props.onConfirm}>
          <Text>Confirm</Text>
        </TouchableOpacity>
      </View>
    );
  },
}));

global.fetch = jest.fn();

describe('ChatScreen', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    mockConversationState.conversations = [];
    mockConversationState.currentConversation = { id: 'test-conv', messages: [] };
    mockConversationState.loading = false;
    (global.fetch as jest.Mock).mockReset();
  });

  describe('Rendering Tests', () => {
    it('renders main container', () => {
      render(<ChatScreen />);
      expect(screen.getByTestId('themed-view')).toBeTruthy();
    });

    it('renders ChatHeader component', () => {
      render(<ChatScreen />);
      expect(screen.getByTestId('chat-header')).toBeTruthy();
    });

    it('renders ChatContainer component', () => {
      render(<ChatScreen />);
      expect(screen.getByTestId('chat-container')).toBeTruthy();
    });

    it('renders ConversationSidebar when visible', async () => {
      render(<ChatScreen />);
      const sidebarToggle = screen.getByTestId('sidebar-toggle');
      fireEvent.press(sidebarToggle);
      await waitFor(() => {
        expect(screen.getByTestId('conversation-sidebar')).toBeTruthy();
      });
    });

    it('does not render ConversationSidebar initially', () => {
      render(<ChatScreen />);
      expect(screen.queryByTestId('conversation-sidebar')).toBeNull();
    });

    it('renders empty state when no messages', () => {
      render(<ChatScreen />);
      expect(screen.getByTestId('empty-state')).toBeTruthy();
      expect(screen.getByText('Welcome to AI Chat')).toBeTruthy();
    });

    it('renders input field with correct placeholder', () => {
      render(<ChatScreen />);
      const input = screen.getByTestId('chat-input');
      expect(input).toBeTruthy();
      expect(input.props.placeholder).toBe('Type a message...');
    });

    it('renders send button', () => {
      render(<ChatScreen />);
      expect(screen.getByTestId('send-button')).toBeTruthy();
    });

    it('renders generate diary button', () => {
      render(<ChatScreen />);
      expect(screen.getByTestId('generate-diary-button')).toBeTruthy();
    });
  });

  describe('Message Tests', () => {
    it('adds user message when sending', async () => {
      // Mock fetch for streaming response
      const mockReader = {
        read: jest
          .fn()
          .mockResolvedValueOnce({
            done: false,
            value: new TextEncoder().encode('data: {"content":"Hello"}\n'),
          })
          .mockResolvedValueOnce({ done: true, value: undefined }),
      };

      (global.fetch as jest.Mock).mockResolvedValueOnce({
        ok: true,
        status: 200,
        body: {
          getReader: () => mockReader,
        },
      });

      mockConversationState.createConversation.mockResolvedValueOnce('new-conv-id');
      mockConversationState.addMessage.mockResolvedValueOnce(undefined);

      render(<ChatScreen />);

      const input = screen.getByTestId('chat-input');
      const sendButton = screen.getByTestId('send-button');

      fireEvent.changeText(input, 'Hello AI');
      await act(async () => {
        fireEvent.press(sendButton);
      });

      // Wait for async operations
      await waitFor(() => {
        expect(mockConversationState.addMessage).toHaveBeenCalled();
      });
    });

    it('updates input text when typing', () => {
      render(<ChatScreen />);
      const input = screen.getByTestId('chat-input');
      fireEvent.changeText(input, 'Test message');
      expect(input.props.value).toBe('Test message');
    });

    it('clears input after sending message', async () => {
      const mockReader = {
        read: jest.fn().mockResolvedValueOnce({ done: true, value: undefined }),
      };

      (global.fetch as jest.Mock).mockResolvedValueOnce({
        ok: true,
        status: 200,
        body: { getReader: () => mockReader },
      });

      mockConversationState.createConversation.mockResolvedValueOnce('new-conv-id');
      mockConversationState.addMessage.mockResolvedValueOnce(undefined);

      render(<ChatScreen />);

      const input = screen.getByTestId('chat-input');
      const sendButton = screen.getByTestId('send-button');

      fireEvent.changeText(input, 'Test message');
      await act(async () => {
        fireEvent.press(sendButton);
      });

      await waitFor(() => {
        expect(input.props.value).toBe('');
      });
    });

    it('does not send empty messages', () => {
      render(<ChatScreen />);
      const sendButton = screen.getByTestId('send-button');
      fireEvent.press(sendButton);
      expect(global.fetch).not.toHaveBeenCalled();
    });

    it('does not send messages while loading', async () => {
      const mockReader = {
        read: jest.fn().mockImplementation(() => new Promise(() => {})),
      };

      (global.fetch as jest.Mock).mockResolvedValueOnce({
        ok: true,
        status: 200,
        body: { getReader: () => mockReader },
      });

      mockConversationState.createConversation.mockResolvedValueOnce('new-conv-id');
      mockConversationState.addMessage.mockResolvedValueOnce(undefined);

      render(<ChatScreen />);

      const input = screen.getByTestId('chat-input');
      const sendButton = screen.getByTestId('send-button');

      fireEvent.changeText(input, 'First message');
      await act(async () => {
        fireEvent.press(sendButton);
      });

      // Try sending another message while loading
      fireEvent.changeText(input, 'Second message');
      fireEvent.press(sendButton);

      // fetch should only be called once
      expect(global.fetch).toHaveBeenCalledTimes(1);
    });
  });

  describe('Interaction Tests', () => {
    it('toggles sidebar when toggle button is pressed', async () => {
      render(<ChatScreen />);
      const sidebarToggle = screen.getByTestId('sidebar-toggle');

      // Open sidebar
      fireEvent.press(sidebarToggle);
      await waitFor(() => {
        expect(screen.getByTestId('conversation-sidebar')).toBeTruthy();
      });

      // Close sidebar
      const closeButton = screen.getByTestId('close-sidebar-button');
      fireEvent.press(closeButton);
      await waitFor(() => {
        expect(screen.queryByTestId('conversation-sidebar')).toBeNull();
      });
    });

    it('opens clear confirmation dialog when clear is pressed', async () => {
      // Set up current conversation with messages
      mockConversationState.currentConversation = {
        id: 'conv-1',
        messages: [
          { id: 'msg-1', role: 'user', content: 'Hello', created_at: new Date().toISOString() },
        ],
      };
      mockConversationState.conversations.push({
        id: 'conv-1',
        title: 'Test',
        updated_at: new Date().toISOString(),
      });

      render(<ChatScreen />);

      // Wait for messages to be displayed
      await waitFor(() => {
        expect(screen.queryByTestId('message-user')).toBeTruthy();
      });

      const clearButton = screen.getByTestId('clear-button');
      fireEvent.press(clearButton);

      expect(mockAlert).toHaveBeenCalledWith(
        'Clear Chat',
        '确定要清空当前对话吗？',
        expect.any(Array)
      );
    });

    it('opens generate diary modal when generate button is pressed with messages', async () => {
      mockConversationState.currentConversation = {
        id: 'conv-1',
        messages: [
          { id: 'msg-1', role: 'user', content: 'Hello', created_at: new Date().toISOString() },
        ],
      };
      mockConversationState.conversations.push({
        id: 'conv-1',
        title: 'Test',
        updated_at: new Date().toISOString(),
      });

      render(<ChatScreen />);

      await waitFor(() => {
        expect(screen.queryByTestId('message-user')).toBeTruthy();
      });

      const generateButton = screen.getByTestId('generate-diary-button');
      fireEvent.press(generateButton);

      await waitFor(() => {
        expect(screen.getByTestId('generate-diary-modal')).toBeTruthy();
      });
    });

    it('shows hint alert when generating diary without messages', () => {
      render(<ChatScreen />);
      const generateButton = screen.getByTestId('generate-diary-button');
      fireEvent.press(generateButton);

      expect(mockAlert).toHaveBeenCalledWith('Hint', '请先和我聊聊今天的故事');
    });

    it('creates new conversation when sidebar new button is pressed', async () => {
      mockConversationState.createConversation.mockResolvedValueOnce('new-conv-id');

      render(<ChatScreen />);
      const sidebarToggle = screen.getByTestId('sidebar-toggle');
      fireEvent.press(sidebarToggle);

      await waitFor(() => {
        expect(screen.getByTestId('conversation-sidebar')).toBeTruthy();
      });

      const newConversationButton = screen.getByTestId('new-conversation-button');
      await act(async () => {
        fireEvent.press(newConversationButton);
      });

      await waitFor(() => {
        expect(mockConversationState.createConversation).toHaveBeenCalled();
        expect(mockConversationState.switchConversation).toHaveBeenCalledWith('new-conv-id');
      });
    });

    it('stops generating when stop button is pressed', async () => {
      const mockReader = {
        read: jest.fn().mockImplementation(() => new Promise(() => {})),
      };

      (global.fetch as jest.Mock).mockResolvedValueOnce({
        ok: true,
        status: 200,
        body: { getReader: () => mockReader },
      });

      mockConversationState.createConversation.mockResolvedValueOnce('new-conv-id');
      mockConversationState.addMessage.mockResolvedValueOnce(undefined);

      render(<ChatScreen />);

      const input = screen.getByTestId('chat-input');
      const sendButton = screen.getByTestId('send-button');

      fireEvent.changeText(input, 'Long message');
      await act(async () => {
        fireEvent.press(sendButton);
      });

      await waitFor(() => {
        expect(screen.queryByTestId('stop-button')).toBeTruthy();
      });

      const stopButton = screen.getByTestId('stop-button');
      fireEvent.press(stopButton);
    });
  });

  describe('Edge Cases', () => {
    it('handles 401 authentication error', async () => {
      (global.fetch as jest.Mock).mockResolvedValueOnce({
        ok: false,
        status: 401,
      });

      mockConversationState.createConversation.mockResolvedValueOnce('new-conv-id');
      mockConversationState.addMessage.mockResolvedValueOnce(undefined);

      render(<ChatScreen />);

      const input = screen.getByTestId('chat-input');
      const sendButton = screen.getByTestId('send-button');

      fireEvent.changeText(input, 'Test message');
      await act(async () => {
        fireEvent.press(sendButton);
      });

      await waitFor(() => {
        expect(mockAlert).toHaveBeenCalledWith('Error', 'AI 响应失败，请重试');
      });
    });

    it('handles 429 rate limit error', async () => {
      (global.fetch as jest.Mock).mockResolvedValueOnce({
        ok: false,
        status: 429,
      });

      mockConversationState.createConversation.mockResolvedValueOnce('new-conv-id');
      mockConversationState.addMessage.mockResolvedValueOnce(undefined);

      render(<ChatScreen />);

      const input = screen.getByTestId('chat-input');
      const sendButton = screen.getByTestId('send-button');

      fireEvent.changeText(input, 'Test message');
      await act(async () => {
        fireEvent.press(sendButton);
      });

      await waitFor(() => {
        expect(mockAlert).toHaveBeenCalledWith('Error', 'AI 响应失败，请重试');
      });
    });

    it('handles 503 service unavailable error', async () => {
      (global.fetch as jest.Mock).mockResolvedValueOnce({
        ok: false,
        status: 503,
      });

      mockConversationState.createConversation.mockResolvedValueOnce('new-conv-id');
      mockConversationState.addMessage.mockResolvedValueOnce(undefined);

      render(<ChatScreen />);

      const input = screen.getByTestId('chat-input');
      const sendButton = screen.getByTestId('send-button');

      fireEvent.changeText(input, 'Test message');
      await act(async () => {
        fireEvent.press(sendButton);
      });

      await waitFor(() => {
        expect(mockAlert).toHaveBeenCalled();
      });
    });

    it('handles 504 timeout error', async () => {
      (global.fetch as jest.Mock).mockResolvedValueOnce({
        ok: false,
        status: 504,
      });

      mockConversationState.createConversation.mockResolvedValueOnce('new-conv-id');
      mockConversationState.addMessage.mockResolvedValueOnce(undefined);

      render(<ChatScreen />);

      const input = screen.getByTestId('chat-input');
      const sendButton = screen.getByTestId('send-button');

      fireEvent.changeText(input, 'Test message');
      await act(async () => {
        fireEvent.press(sendButton);
      });

      await waitFor(() => {
        expect(mockAlert).toHaveBeenCalled();
      });
    });

    it('handles 500 server error', async () => {
      (global.fetch as jest.Mock).mockResolvedValueOnce({
        ok: false,
        status: 500,
      });

      mockConversationState.createConversation.mockResolvedValueOnce('new-conv-id');
      mockConversationState.addMessage.mockResolvedValueOnce(undefined);

      render(<ChatScreen />);

      const input = screen.getByTestId('chat-input');
      const sendButton = screen.getByTestId('send-button');

      fireEvent.changeText(input, 'Test message');
      await act(async () => {
        fireEvent.press(sendButton);
      });

      await waitFor(() => {
        expect(mockAlert).toHaveBeenCalled();
      });
    });

    it('handles streaming JSON parse error gracefully', async () => {
      const mockReader = {
        read: jest
          .fn()
          .mockResolvedValueOnce({
            done: false,
            value: new TextEncoder().encode('data: {invalid json}\n'),
          })
          .mockResolvedValueOnce({ done: true, value: undefined }),
      };

      (global.fetch as jest.Mock).mockResolvedValueOnce({
        ok: true,
        status: 200,
        body: { getReader: () => mockReader },
      });

      mockConversationState.createConversation.mockResolvedValueOnce('new-conv-id');
      mockConversationState.addMessage.mockResolvedValueOnce(undefined);

      render(<ChatScreen />);

      const input = screen.getByTestId('chat-input');
      const sendButton = screen.getByTestId('send-button');

      fireEvent.changeText(input, 'Test message');
      await act(async () => {
        fireEvent.press(sendButton);
      });

      await waitFor(() => {
        expect(mockConversationState.addMessage).toHaveBeenCalledWith(
          'test-conv',
          'user',
          'Test message'
        );
      });
    });

    it('handles clipboard/image error message', async () => {
      (global.fetch as jest.Mock).mockRejectedValueOnce({
        response: { data: { detail: 'clipboard error' } },
      });

      mockConversationState.createConversation.mockResolvedValueOnce('new-conv-id');
      mockConversationState.addMessage.mockResolvedValueOnce(undefined);

      render(<ChatScreen />);

      const input = screen.getByTestId('chat-input');
      const sendButton = screen.getByTestId('send-button');

      fireEvent.changeText(input, 'Test with image');
      await act(async () => {
        fireEvent.press(sendButton);
      });

      await waitFor(() => {
        expect(mockAlert).toHaveBeenCalledWith(
          'Hint',
          '抱歉，我无法读取图片。请用文字描述今天的故事。'
        );
      });
    });

    it('handles network error without response data', async () => {
      (global.fetch as jest.Mock).mockRejectedValueOnce(new Error('Network error'));

      mockConversationState.createConversation.mockResolvedValueOnce('new-conv-id');
      mockConversationState.addMessage.mockResolvedValueOnce(undefined);

      render(<ChatScreen />);

      const input = screen.getByTestId('chat-input');
      const sendButton = screen.getByTestId('send-button');

      fireEvent.changeText(input, 'Test message');
      await act(async () => {
        fireEvent.press(sendButton);
      });

      await waitFor(() => {
        expect(mockAlert).toHaveBeenCalledWith('Error', 'AI 响应失败，请重试');
      });
    });

    it('loads messages from current conversation', async () => {
      mockConversationState.currentConversation = {
        id: 'conv-1',
        messages: [
          { id: 'msg-1', role: 'user', content: 'Hello', created_at: new Date().toISOString() },
          {
            id: 'msg-2',
            role: 'assistant',
            content: 'Hi there!',
            created_at: new Date().toISOString(),
          },
        ],
      };

      render(<ChatScreen />);

      await waitFor(() => {
        expect(screen.getByText('Hello')).toBeTruthy();
        expect(screen.getByText('Hi there!')).toBeTruthy();
      });
    });

    it('clears messages when conversation is switched to null', async () => {
      mockConversationState.currentConversation = {
        id: 'conv-1',
        messages: [
          { id: 'msg-1', role: 'user', content: 'Hello', created_at: new Date().toISOString() },
        ],
      };

      const { rerender } = render(<ChatScreen />);

      await waitFor(() => {
        expect(screen.getByText('Hello')).toBeTruthy();
      });

      // Simulate conversation being cleared
      mockConversationState.currentConversation = null;
      rerender(<ChatScreen />);

      await waitFor(() => {
        expect(screen.queryByText('Hello')).toBeNull();
      });
    });

    it('trims whitespace from input before sending', async () => {
      const mockReader = {
        read: jest.fn().mockResolvedValueOnce({ done: true, value: undefined }),
      };

      (global.fetch as jest.Mock).mockResolvedValueOnce({
        ok: true,
        status: 200,
        body: { getReader: () => mockReader },
      });

      mockConversationState.createConversation.mockResolvedValueOnce('new-conv-id');
      mockConversationState.addMessage.mockResolvedValueOnce(undefined);

      render(<ChatScreen />);

      const input = screen.getByTestId('chat-input');
      const sendButton = screen.getByTestId('send-button');

      fireEvent.changeText(input, '   Test with spaces   ');
      await act(async () => {
        fireEvent.press(sendButton);
      });

      await waitFor(() => {
        expect(mockConversationState.addMessage).toHaveBeenCalledWith(
          'test-conv',
          'user',
          'Test with spaces'
        );
      });
    });

    it('handles generate diary success flow', async () => {
      const axios = require('axios');
      axios.post.mockResolvedValueOnce({
        data: { id: 'entry-123' },
      });

      mockConversationState.currentConversation = {
        id: 'conv-1',
        messages: [
          {
            id: 'msg-1',
            role: 'user',
            content: 'Today was great',
            created_at: new Date().toISOString(),
          },
        ],
      };
      mockConversationState.conversations.push({
        id: 'conv-1',
        title: 'Test',
        updated_at: new Date().toISOString(),
      });

      render(<ChatScreen />);

      await waitFor(() => {
        expect(screen.queryByTestId('message-user')).toBeTruthy();
      });

      const generateButton = screen.getByTestId('generate-diary-button');
      fireEvent.press(generateButton);

      await waitFor(() => {
        expect(screen.getByTestId('generate-diary-modal')).toBeTruthy();
      });

      const confirmButton = screen.getByTestId('confirm-modal');
      await act(async () => {
        fireEvent.press(confirmButton);
      });

      await waitFor(() => {
        expect(mockFetchEntries).toHaveBeenCalled();
        expect(mockPush).toHaveBeenCalledWith({ pathname: '/write', params: { id: 'entry-123' } });
      });
    });

    it('handles generate diary failure', async () => {
      const axios = require('axios');
      axios.post.mockRejectedValueOnce(new Error('Failed'));

      mockConversationState.currentConversation = {
        id: 'conv-1',
        messages: [
          {
            id: 'msg-1',
            role: 'user',
            content: 'Today was great',
            created_at: new Date().toISOString(),
          },
        ],
      };

      render(<ChatScreen />);

      const generateButton = screen.getByTestId('generate-diary-button');
      fireEvent.press(generateButton);

      await waitFor(() => {
        expect(screen.getByTestId('generate-diary-modal')).toBeTruthy();
      });

      const confirmButton = screen.getByTestId('confirm-modal');
      await act(async () => {
        fireEvent.press(confirmButton);
      });

      await waitFor(() => {
        expect(mockAlert).toHaveBeenCalledWith('Error', '生成日记失败，请重试');
      });
    });

    it('cancels generate diary modal', async () => {
      mockConversationState.currentConversation = {
        id: 'conv-1',
        messages: [
          { id: 'msg-1', role: 'user', content: 'Hello', created_at: new Date().toISOString() },
        ],
      };

      render(<ChatScreen />);

      const generateButton = screen.getByTestId('generate-diary-button');
      fireEvent.press(generateButton);

      await waitFor(() => {
        expect(screen.getByTestId('generate-diary-modal')).toBeTruthy();
      });

      const cancelButton = screen.getByTestId('cancel-modal');
      fireEvent.press(cancelButton);

      await waitFor(() => {
        expect(screen.queryByTestId('generate-diary-modal')).toBeNull();
      });
    });
  });

  describe('Initialization Tests', () => {
    it('creates new conversation when no conversations exist', async () => {
      mockConversationState.currentConversation = null;
      mockConversationState.createConversation.mockResolvedValueOnce('new-conv-id');
      mockConversationState.switchConversation.mockResolvedValueOnce(undefined);

      render(<ChatScreen />);

      await waitFor(() => {
        expect(mockConversationState.createConversation).toHaveBeenCalled();
      });
    });

    it('switches to first conversation when conversations exist but no current', async () => {
      mockConversationState.currentConversation = null;
      mockConversationState.conversations.push({
        id: 'conv-1',
        title: 'Existing',
        updated_at: new Date().toISOString(),
      });
      mockConversationState.switchConversation.mockResolvedValueOnce(undefined);

      render(<ChatScreen />);

      await waitFor(() => {
        expect(mockConversationState.switchConversation).toHaveBeenCalledWith('conv-1');
      });
    });

    it('refreshes conversations on mount', () => {
      render(<ChatScreen />);
      expect(mockConversationState.refreshConversations).toHaveBeenCalled();
    });
  });
});
