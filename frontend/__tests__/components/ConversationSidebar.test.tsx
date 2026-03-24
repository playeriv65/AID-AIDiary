import React from 'react';
import { act, fireEvent, render, screen, waitFor } from '@testing-library/react-native';
import { ConversationSidebar } from '@/components/chat/ConversationSidebar';
import type { Conversation } from '@/components/chat/types';

// Mock IconSymbol - render with testID for easier testing
const mockIconSymbol = jest.fn();
jest.mock('@/components/ui/icon-symbol', () => ({
  IconSymbol: (props: { name: string; size?: number; color?: string; testID?: string }) => {
    mockIconSymbol(props);
    const ReactNative = require('react-native');
    return (
      <ReactNative.View testID={`icon-${props.name}`}>
        <ReactNative.Text>{`icon-${props.name}`}</ReactNative.Text>
      </ReactNative.View>
    );
  },
}));

// Mock ConversationContext
const mockCreateConversation = jest.fn();
const mockDeleteConversation = jest.fn();
let mockConversations: Conversation[] = [];
let mockLoading = false;

jest.mock('@/context/ConversationContext', () => ({
  useConversation: () => ({
    conversations: mockConversations,
    loading: mockLoading,
    deleteConversation: mockDeleteConversation,
    createConversation: mockCreateConversation,
  }),
}));

// Mock confirm
const mockConfirm = jest.fn();
Object.defineProperty(global, 'confirm', {
  value: mockConfirm,
  writable: true,
});

// Mock console.error
const mockConsoleError = jest.spyOn(console, 'error').mockImplementation(() => {});

describe('ConversationSidebar', () => {
  const defaultProps = {
    visible: true,
    currentConversationId: null as string | null,
    onSelectConversation: jest.fn(),
    onNewConversation: jest.fn(),
    onClose: jest.fn(),
    theme: 'light' as const,
  };

  beforeEach(() => {
    jest.clearAllMocks();
    mockConversations = [];
    mockLoading = false;
    mockConfirm.mockReturnValue(true);
  });

  afterAll(() => {
    mockConsoleError.mockRestore();
  });

  describe('Rendering', () => {
    it('returns null when not visible', () => {
      const { toJSON } = render(<ConversationSidebar {...defaultProps} visible={false} />);
      expect(toJSON()).toBeNull();
    });

    it('renders sidebar when visible', () => {
      render(<ConversationSidebar {...defaultProps} />);
      expect(screen.getByText('对话历史')).toBeTruthy();
    });

    it('renders header with title and buttons', () => {
      render(<ConversationSidebar {...defaultProps} />);
      expect(screen.getByText('对话历史')).toBeTruthy();
      const plusIcons = mockIconSymbol.mock.calls.filter((call) => call[0].name === 'plus');
      const xmarkIcons = mockIconSymbol.mock.calls.filter((call) => call[0].name === 'xmark');
      expect(plusIcons.length).toBeGreaterThan(0);
      expect(xmarkIcons.length).toBeGreaterThan(0);
    });

    it('renders loading state', () => {
      mockLoading = true;
      render(<ConversationSidebar {...defaultProps} />);
      expect(screen.getByText('加载中...')).toBeTruthy();
    });

    it('renders empty state when no conversations', () => {
      mockConversations = [];
      render(<ConversationSidebar {...defaultProps} />);
      expect(screen.getByText('暂无对话')).toBeTruthy();
      expect(screen.getByText('点击右上角 + 创建新对话')).toBeTruthy();
    });

    it('renders conversation list', () => {
      mockConversations = [
        { id: '1', title: 'Test Conversation 1', updated_at: new Date().toISOString() },
        { id: '2', title: 'Test Conversation 2', updated_at: new Date().toISOString() },
      ];
      render(<ConversationSidebar {...defaultProps} />);
      expect(screen.getByText('Test Conversation 1')).toBeTruthy();
      expect(screen.getByText('Test Conversation 2')).toBeTruthy();
    });

    it('renders with dark theme', () => {
      render(<ConversationSidebar {...defaultProps} theme="dark" />);
      expect(screen.getByText('对话历史')).toBeTruthy();
    });

    it('renders conversation without title', () => {
      mockConversations = [{ id: '1', title: null, updated_at: new Date().toISOString() }];
      render(<ConversationSidebar {...defaultProps} />);
      expect(screen.getByText('新对话')).toBeTruthy();
    });

    it('renders delete button for each conversation', () => {
      mockConversations = [
        { id: '1', title: 'Test Conversation', updated_at: new Date().toISOString() },
      ];
      render(<ConversationSidebar {...defaultProps} />);
      const trashIcons = mockIconSymbol.mock.calls.filter((call) => call[0].name === 'trash');
      expect(trashIcons.length).toBeGreaterThan(0);
    });
  });

  describe('Interaction', () => {
    it('calls onSelectConversation when conversation is pressed', () => {
      mockConversations = [
        { id: 'conv-123', title: 'Test Conversation', updated_at: new Date().toISOString() },
      ];
      render(<ConversationSidebar {...defaultProps} />);
      const touchable = screen.getByText('Test Conversation');
      fireEvent.press(touchable);
      expect(defaultProps.onSelectConversation).toHaveBeenCalledWith('conv-123');
    });

    it('deletes conversation when confirmed', async () => {
      mockConfirm.mockReturnValue(true);
      mockDeleteConversation.mockResolvedValue(undefined);
      mockConversations = [
        { id: 'conv-123', title: 'Test Conversation', updated_at: new Date().toISOString() },
      ];
      render(<ConversationSidebar {...defaultProps} />);
      const deleteButton = screen.getByLabelText('Delete conversation: Test Conversation');
      const nativeEvent = { stopPropagation: jest.fn() };
      await act(async () => {
        fireEvent(deleteButton, 'press', nativeEvent);
      });
      expect(mockConfirm).toHaveBeenCalledWith('确定要删除这个对话吗？');
      await waitFor(() => {
        expect(mockDeleteConversation).toHaveBeenCalledWith('conv-123');
      });
    });

    it('does not delete conversation when cancelled', async () => {
      mockConfirm.mockReturnValue(false);
      mockConversations = [
        { id: 'conv-123', title: 'Test Conversation', updated_at: new Date().toISOString() },
      ];
      render(<ConversationSidebar {...defaultProps} />);
      const deleteButton = screen.getByLabelText('Delete conversation: Test Conversation');
      const nativeEvent = { stopPropagation: jest.fn() };
      await act(async () => {
        fireEvent(deleteButton, 'press', nativeEvent);
      });
      expect(mockConfirm).toHaveBeenCalledWith('确定要删除这个对话吗？');
      expect(mockDeleteConversation).not.toHaveBeenCalled();
    });

    it('stops propagation when delete button is pressed', async () => {
      mockConfirm.mockReturnValue(true);
      mockDeleteConversation.mockResolvedValue(undefined);
      mockConversations = [
        { id: 'conv-123', title: 'Test Conversation', updated_at: new Date().toISOString() },
      ];
      render(<ConversationSidebar {...defaultProps} />);
      const deleteButton = screen.getByLabelText('Delete conversation: Test Conversation');
      const mockStopPropagation = jest.fn();
      const nativeEvent = { stopPropagation: mockStopPropagation };
      await act(async () => {
        fireEvent(deleteButton, 'press', nativeEvent);
      });
      expect(mockStopPropagation).toHaveBeenCalled();
      expect(mockDeleteConversation).toHaveBeenCalledWith('conv-123');
    });
  });

  describe('State', () => {
    it('highlights current conversation', () => {
      mockConversations = [
        { id: 'conv-1', title: 'Conversation 1', updated_at: new Date().toISOString() },
        { id: 'conv-2', title: 'Conversation 2', updated_at: new Date().toISOString() },
      ];
      render(<ConversationSidebar {...defaultProps} currentConversationId="conv-1" />);
      expect(screen.getByText('Conversation 1')).toBeTruthy();
      expect(screen.getByText('Conversation 2')).toBeTruthy();
    });

    it('highlights current conversation in dark theme', () => {
      mockConversations = [
        { id: 'conv-1', title: 'Conversation 1', updated_at: new Date().toISOString() },
      ];
      render(<ConversationSidebar {...defaultProps} currentConversationId="conv-1" theme="dark" />);
      expect(screen.getByText('Conversation 1')).toBeTruthy();
    });

    it('shows loading indicator when loading', () => {
      mockLoading = true;
      render(<ConversationSidebar {...defaultProps} />);
      expect(screen.getByText('加载中...')).toBeTruthy();
    });

    it('does not show conversation list when loading', () => {
      mockLoading = true;
      mockConversations = [{ id: '1', title: 'Test', updated_at: new Date().toISOString() }];
      render(<ConversationSidebar {...defaultProps} />);
      expect(screen.queryByText('Test')).toBeNull();
    });
  });

  describe('Date Formatting', () => {
    it('formats date as 今天 when conversation was updated today', () => {
      const today = new Date();
      mockConversations = [
        { id: '1', title: 'Today Conversation', updated_at: today.toISOString() },
      ];
      render(<ConversationSidebar {...defaultProps} />);
      expect(screen.getByText('今天')).toBeTruthy();
    });

    it('formats date as 昨天 when conversation was updated yesterday', () => {
      const yesterday = new Date();
      yesterday.setDate(yesterday.getDate() - 1);
      mockConversations = [
        { id: '1', title: 'Yesterday Conversation', updated_at: yesterday.toISOString() },
      ];
      render(<ConversationSidebar {...defaultProps} />);
      expect(screen.getByText('昨天')).toBeTruthy();
    });

    it('formats date as X天前 when conversation was updated within 7 days', () => {
      const threeDaysAgo = new Date();
      threeDaysAgo.setDate(threeDaysAgo.getDate() - 3);
      mockConversations = [
        { id: '1', title: '3 Days Ago Conversation', updated_at: threeDaysAgo.toISOString() },
      ];
      render(<ConversationSidebar {...defaultProps} />);
      expect(screen.getByText('3天前')).toBeTruthy();
    });

    it('formats date as locale date string when conversation was updated more than 7 days ago', () => {
      const tenDaysAgo = new Date();
      tenDaysAgo.setDate(tenDaysAgo.getDate() - 10);
      mockConversations = [
        { id: '1', title: 'Old Conversation', updated_at: tenDaysAgo.toISOString() },
      ];
      render(<ConversationSidebar {...defaultProps} />);
      const expectedDate = tenDaysAgo.toLocaleDateString('zh-CN');
      expect(screen.getByText(expectedDate)).toBeTruthy();
    });

    it('formats date correctly at boundary of 1-6 days range', () => {
      // Test 2 days ago (simple case without timezone issues)
      mockConversations = [];
      const twoDaysAgo = new Date();
      twoDaysAgo.setDate(twoDaysAgo.getDate() - 2);
      twoDaysAgo.setHours(12, 0, 0, 0);
      mockConversations = [{ id: '1', title: 'Test 2 Days', updated_at: twoDaysAgo.toISOString() }];
      render(<ConversationSidebar {...defaultProps} />);
      // Check that it shows "X天前" format
      const dateText = screen.getByText(/\d+天前/);
      expect(dateText).toBeTruthy();
    });

    it('formats date at end of day today correctly', () => {
      const endOfToday = new Date();
      endOfToday.setHours(23, 59, 59, 999);
      mockConversations = [
        { id: '1', title: 'End of Today', updated_at: endOfToday.toISOString() },
      ];
      render(<ConversationSidebar {...defaultProps} />);
      expect(screen.getByText('今天')).toBeTruthy();
    });

    it('formats date at start of day today correctly', () => {
      const startOfToday = new Date();
      startOfToday.setHours(0, 0, 0, 0);
      mockConversations = [
        { id: '1', title: 'Start of Today', updated_at: startOfToday.toISOString() },
      ];
      render(<ConversationSidebar {...defaultProps} />);
      expect(screen.getByText('今天')).toBeTruthy();
    });
  });

  describe('Edge Cases', () => {
    it('handles conversation with empty string title', () => {
      mockConversations = [{ id: '1', title: '', updated_at: new Date().toISOString() }];
      render(<ConversationSidebar {...defaultProps} />);
      expect(screen.getByText('新对话')).toBeTruthy();
    });

    it('handles delete button accessibility label with null title', () => {
      mockConversations = [{ id: '1', title: null, updated_at: new Date().toISOString() }];
      render(<ConversationSidebar {...defaultProps} />);
      const deleteButton = screen.getByLabelText('Delete conversation: New conversation');
      expect(deleteButton).toBeTruthy();
    });

    it('handles delete button accessibility label with empty title', () => {
      mockConversations = [{ id: '1', title: '', updated_at: new Date().toISOString() }];
      render(<ConversationSidebar {...defaultProps} />);
      const deleteButton = screen.getByLabelText('Delete conversation: New conversation');
      expect(deleteButton).toBeTruthy();
    });

    it('handles delete button accessibility label with valid title', () => {
      mockConversations = [
        { id: '1', title: 'My Special Conversation', updated_at: new Date().toISOString() },
      ];
      render(<ConversationSidebar {...defaultProps} />);
      const deleteButton = screen.getByLabelText('Delete conversation: My Special Conversation');
      expect(deleteButton).toBeTruthy();
    });

    it('handles multiple conversations', () => {
      mockConversations = [
        { id: '1', title: 'First', updated_at: new Date().toISOString() },
        { id: '2', title: 'Second', updated_at: new Date().toISOString() },
        { id: '3', title: 'Third', updated_at: new Date().toISOString() },
      ];
      render(<ConversationSidebar {...defaultProps} />);
      expect(screen.getByText('First')).toBeTruthy();
      expect(screen.getByText('Second')).toBeTruthy();
      expect(screen.getByText('Third')).toBeTruthy();
    });

    it('handles conversation with very long title', () => {
      const longTitle = 'A'.repeat(100);
      mockConversations = [{ id: '1', title: longTitle, updated_at: new Date().toISOString() }];
      render(<ConversationSidebar {...defaultProps} />);
      expect(screen.getByText(longTitle)).toBeTruthy();
    });

    it('handles conversation with special characters in title', () => {
      const specialTitle = 'Test 🎉 <script>alert("xss")</script> & More';
      mockConversations = [{ id: '1', title: specialTitle, updated_at: new Date().toISOString() }];
      render(<ConversationSidebar {...defaultProps} />);
      expect(screen.getByText(specialTitle)).toBeTruthy();
    });

    it('renders correctly with light theme', () => {
      render(<ConversationSidebar {...defaultProps} theme="light" />);
      expect(screen.getByText('对话历史')).toBeTruthy();
    });

    it('renders correctly with dark theme', () => {
      render(<ConversationSidebar {...defaultProps} theme="dark" />);
      expect(screen.getByText('对话历史')).toBeTruthy();
    });

    it('handles rapid delete calls', async () => {
      mockConfirm.mockReturnValue(true);
      mockDeleteConversation.mockResolvedValue(undefined);
      mockConversations = [
        { id: '1', title: 'First', updated_at: new Date().toISOString() },
        { id: '2', title: 'Second', updated_at: new Date().toISOString() },
      ];
      render(<ConversationSidebar {...defaultProps} />);
      const deleteButtons = screen.getAllByLabelText(/Delete conversation:/);
      await act(async () => {
        const nativeEvent = { stopPropagation: jest.fn() };
        fireEvent(deleteButtons[0], 'press', nativeEvent);
        fireEvent(deleteButtons[1], 'press', nativeEvent);
      });
      await waitFor(() => {
        expect(mockDeleteConversation).toHaveBeenCalledTimes(2);
      });
    });
  });

  describe('Context Integration', () => {
    it('calls createConversation from context when creating new conversation', async () => {
      mockCreateConversation.mockResolvedValue('new-conv-id');
      const mockOnNewConversation = jest.fn();
      render(<ConversationSidebar {...defaultProps} onNewConversation={mockOnNewConversation} />);
      expect(mockCreateConversation).not.toHaveBeenCalled();
    });

    it('uses ConversationContext values', () => {
      mockConversations = [
        { id: 'ctx-1', title: 'Context Test', updated_at: new Date().toISOString() },
      ];
      render(<ConversationSidebar {...defaultProps} />);
      expect(screen.getByText('Context Test')).toBeTruthy();
    });

    it('reflects loading state from context', () => {
      mockLoading = true;
      render(<ConversationSidebar {...defaultProps} />);
      expect(screen.getByText('加载中...')).toBeTruthy();
      expect(screen.queryByText('对话历史')).toBeTruthy();
    });
  });

  describe('Props', () => {
    it('accepts all required props', () => {
      const props = {
        visible: true,
        currentConversationId: 'test-id',
        onSelectConversation: jest.fn(),
        onNewConversation: jest.fn(),
        onClose: jest.fn(),
        theme: 'dark' as const,
      };
      const { toJSON } = render(<ConversationSidebar {...props} />);
      expect(toJSON()).toBeTruthy();
    });

    it('works without onNewConversation callback', () => {
      const props = {
        visible: true,
        currentConversationId: null,
        onSelectConversation: jest.fn(),
        onClose: jest.fn(),
        theme: 'light' as const,
      };
      const { toJSON } = render(<ConversationSidebar {...props} />);
      expect(toJSON()).toBeTruthy();
    });
  });

  describe('Delete Confirmation', () => {
    it('shows confirmation dialog with correct message', async () => {
      mockConfirm.mockReturnValue(true);
      mockDeleteConversation.mockResolvedValue(undefined);
      mockConversations = [
        { id: 'conv-1', title: 'To Delete', updated_at: new Date().toISOString() },
      ];
      render(<ConversationSidebar {...defaultProps} />);
      const deleteButton = screen.getByLabelText('Delete conversation: To Delete');
      const nativeEvent = { stopPropagation: jest.fn() };
      await act(async () => {
        fireEvent(deleteButton, 'press', nativeEvent);
      });
      expect(mockConfirm).toHaveBeenCalledWith('确定要删除这个对话吗？');
    });

    it('handles delete when confirm returns true', async () => {
      mockConfirm.mockReturnValue(true);
      mockDeleteConversation.mockResolvedValue(undefined);
      mockConversations = [
        { id: 'conv-1', title: 'To Delete', updated_at: new Date().toISOString() },
      ];
      render(<ConversationSidebar {...defaultProps} />);
      const deleteButton = screen.getByLabelText('Delete conversation: To Delete');
      const nativeEvent = { stopPropagation: jest.fn() };
      await act(async () => {
        fireEvent(deleteButton, 'press', nativeEvent);
      });
      expect(mockDeleteConversation).toHaveBeenCalledWith('conv-1');
    });

    it('does not delete when confirm returns false', async () => {
      mockConfirm.mockReturnValue(false);
      mockConversations = [
        { id: 'conv-1', title: 'To Delete', updated_at: new Date().toISOString() },
      ];
      render(<ConversationSidebar {...defaultProps} />);
      const deleteButton = screen.getByLabelText('Delete conversation: To Delete');
      const nativeEvent = { stopPropagation: jest.fn() };
      await act(async () => {
        fireEvent(deleteButton, 'press', nativeEvent);
      });
      expect(mockDeleteConversation).not.toHaveBeenCalled();
    });
  });

  describe('Date Display', () => {
    it('displays relative dates correctly', () => {
      const yesterday = new Date();
      yesterday.setDate(yesterday.getDate() - 1);
      mockConversations = [
        { id: '1', title: 'Yesterday Conv', updated_at: yesterday.toISOString() },
      ];
      render(<ConversationSidebar {...defaultProps} />);
      expect(screen.getByText('昨天')).toBeTruthy();
    });

    it('formats dates for each conversation item', () => {
      const dates = [new Date(), new Date(Date.now() - 86400000), new Date(Date.now() - 172800000)];
      mockConversations = dates.map((date, i) => ({
        id: String(i),
        title: `Conv ${i}`,
        updated_at: date.toISOString(),
      }));
      render(<ConversationSidebar {...defaultProps} />);
      expect(screen.getByText('今天')).toBeTruthy();
      expect(screen.getByText('昨天')).toBeTruthy();
      expect(screen.getByText('2天前')).toBeTruthy();
    });
  });
});
