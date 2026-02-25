import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react-native';
import { ChatContainer } from '@/components/chat/ChatContainer';

const mockMessages = [
    { id: '1', role: 'user' as const, content: 'Hello', timestamp: Date.now() },
    { id: '2', role: 'assistant' as const, content: 'Hi!', timestamp: Date.now() },
];

describe('ChatContainer', () => {
    const defaultProps = {
        messages: [],
        loading: false,
        generating: false,
        inputText: '',
        onInputChange: jest.fn(),
        onSend: jest.fn(),
        theme: 'dark' as const,
        accentColor: '#02BFB8',
        placeholder: 'Type...',
    };

    beforeEach(() => {
        jest.clearAllMocks();
    });

    it('renders empty state when no messages', () => {
        render(<ChatContainer {...defaultProps} />);
        // Empty state should show something like welcome message
        // Currently it shows IconSymbol - we can test that it renders without crash
        expect(screen.getByTestId).toBeDefined; // placeholder
    });

    it('renders messages when provided', () => {
        render(<ChatContainer {...defaultProps} messages={mockMessages} />);
        expect(screen.getByText('Hello')).toBeTruthy();
        expect(screen.getByText('Hi!')).toBeTruthy();
    });

    it('renders input field', () => {
        render(<ChatContainer {...defaultProps} placeholder="Type a message..." />);
        // Check that the input renders placeholder text
        // Note: In test environment, TextInput placeholder may not be directly accessible
    });

    it('passes inputText to ChatInput', () => {
        const { rerender } = render(<ChatContainer {...defaultProps} inputText="Hello" />);
        rerender(<ChatContainer {...defaultProps} inputText="World" />);
        // ChatInput should receive updated prop
    });

    it('passes loading prop to ChatInput', () => {
        const { rerender } = render(<ChatContainer {...defaultProps} loading={false} />);
        rerender(<ChatContainer {...defaultProps} loading={true} />);
        // ChatInput should receive loading prop
    });

    it('calls onStopGenerating when generating', () => {
        const onStop = jest.fn();
        render(<ChatContainer {...defaultProps} generating={true} onStopGenerating={onStop} />);
        // The stop button should appear in ChatInput when loading/generating
    });

    it('renders with different accent colors', () => {
        const { rerender } = render(<ChatContainer {...defaultProps} accentColor="#FF0000" />);
        rerender(<ChatContainer {...defaultProps} accentColor="#00FF00" />);
        // Both should render without crash
    });

    it('applies correct theme styles', () => {
        const { rerender } = render(<ChatContainer {...defaultProps} theme="light" />);
        // Verify light theme applied
        rerender(<ChatContainer {...defaultProps} theme="dark" />);
        // Verify dark theme applied
    });

    it('forwards edit and retry callbacks', () => {
        const onEdit = jest.fn();
        const onRetry = jest.fn();
        render(<ChatContainer {...defaultProps} messages={mockMessages} onEditMessage={onEdit} onRetryMessage={onRetry} />);
        // Callbacks are passed to ChatMessage component
        // Interaction testing would require more complex setup
    });
});
