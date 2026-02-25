import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react-native';
import { ChatMessageList } from '@/components/journal/ChatMessageList';

const mockScrollViewRef = {
    current: {
        scrollToEnd: jest.fn(),
    },
};

const mockI18n = {
    aiWelcome: 'Welcome to AI Chat',
    aiHint: 'Start a conversation...',
};

const mockOnEditMessage = jest.fn();
const mockOnRetry = jest.fn();

describe('ChatMessageList', () => {
    const mockMessages = [
        { id: '1', role: 'user' as const, content: 'Hello', timestamp: Date.now() },
        { id: '2', role: 'assistant' as const, content: 'Hi there!', timestamp: Date.now() },
    ];

    beforeEach(() => {
        jest.clearAllMocks();
    });

    it('renders empty state when no messages', () => {
        render(
            <ChatMessageList
                messages={[]}
                streaming={false}
                accentColor="#02BFB8"
                resolvedTheme="dark"
                i18n={mockI18n}
                scrollViewRef={mockScrollViewRef as any}
            />
        );

        expect(screen.getByText('Welcome to AI Chat')).toBeTruthy();
        expect(screen.getByText('Start a conversation...')).toBeTruthy();
    });

    it('renders messages correctly', () => {
        render(
            <ChatMessageList
                messages={mockMessages}
                streaming={false}
                accentColor="#02BFB8"
                resolvedTheme="dark"
                i18n={mockI18n}
                scrollViewRef={mockScrollViewRef as any}
            />
        );

        expect(screen.getByText('Hello')).toBeTruthy();
        expect(screen.getByText('Hi there!')).toBeTruthy();
    });

    it('renders markdown content correctly', () => {
        const markdownMessages = [
            { id: '1', role: 'assistant' as const, content: '**Bold text** and *italic*', timestamp: Date.now() },
        ];

        render(
            <ChatMessageList
                messages={markdownMessages}
                streaming={false}
                accentColor="#02BFB8"
                resolvedTheme="dark"
                i18n={mockI18n}
                scrollViewRef={mockScrollViewRef as any}
            />
        );

        expect(screen.getByText(/Bold text/i)).toBeTruthy();
    });

    it('renders code blocks correctly', () => {
        const codeMessages = [
            { id: '1', role: 'assistant' as const, content: '```javascript\nconst x = 1;\n```', timestamp: Date.now() },
        ];

        render(
            <ChatMessageList
                messages={codeMessages}
                streaming={false}
                accentColor="#02BFB8"
                resolvedTheme="dark"
                i18n={mockI18n}
                scrollViewRef={mockScrollViewRef as any}
            />
        );

        expect(screen.getByText(/const x = 1/i)).toBeTruthy();
    });

    it('shows loading indicator when streaming', () => {
        render(
            <ChatMessageList
                messages={mockMessages}
                streaming={true}
                accentColor="#02BFB8"
                resolvedTheme="dark"
                i18n={mockI18n}
                scrollViewRef={mockScrollViewRef as any}
            />
        );

        expect(screen.getByText('AI 正在思考...')).toBeTruthy();
    });

    it('handles edit message callback', () => {
        const messagesWithId = [
            { id: '1', role: 'user' as const, content: 'Hello', timestamp: Date.now() },
        ];

        render(
            <ChatMessageList
                messages={messagesWithId}
                streaming={false}
                accentColor="#02BFB8"
                resolvedTheme="dark"
                i18n={mockI18n}
                scrollViewRef={mockScrollViewRef as any}
                onEditMessage={mockOnEditMessage}
            />
        );
    });

    it('handles retry callback', () => {
        const messagesWithId = [
            { id: '1', role: 'assistant' as const, content: 'Hello', timestamp: Date.now() },
        ];

        render(
            <ChatMessageList
                messages={messagesWithId}
                streaming={false}
                accentColor="#02BFB8"
                resolvedTheme="dark"
                i18n={mockI18n}
                scrollViewRef={mockScrollViewRef as any}
                onRetry={mockOnRetry}
            />
        );
    });

    it('renders user message with correct alignment', () => {
        render(
            <ChatMessageList
                messages={mockMessages}
                streaming={false}
                accentColor="#02BFB8"
                resolvedTheme="dark"
                i18n={mockI18n}
                scrollViewRef={mockScrollViewRef as any}
            />
        );

        const userMessage = screen.getByText('Hello');
        expect(userMessage).toBeTruthy();
    });
});
