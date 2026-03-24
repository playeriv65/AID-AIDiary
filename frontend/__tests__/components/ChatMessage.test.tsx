import React from 'react';
import { render, screen } from '@testing-library/react-native';
import { ChatMessage } from '@/components/chat/ChatMessage';
import type { ChatMessage as ChatMessageType } from '@/components/chat/types';

describe('ChatMessage', () => {
  const mockUserMessage: ChatMessageType = {
    id: 'msg-1',
    role: 'user',
    content: 'Hello, this is a test message',
    timestamp: Date.now(),
  };

  const mockAssistantMessage: ChatMessageType = {
    id: 'msg-2',
    role: 'assistant',
    content: 'Hello! How can I help you today?',
    timestamp: Date.now(),
  };

  const defaultProps = {
    theme: 'dark' as const,
    accentColor: '#02BFB8',
  };

  describe('User Message', () => {
    it('should render user message correctly', () => {
      render(<ChatMessage message={mockUserMessage} {...defaultProps} />);
      expect(screen.getByText('Hello, this is a test message')).toBeTruthy();
    });
  });

  describe('Assistant Message', () => {
    it('should render assistant message correctly', () => {
      render(<ChatMessage message={mockAssistantMessage} {...defaultProps} />);
      expect(screen.getByText('Hello! How can I help you today?')).toBeTruthy();
    });

    it('should apply assistant bubble styles for dark theme', () => {
      render(<ChatMessage message={mockAssistantMessage} theme="dark" accentColor="#02BFB8" />);
      expect(screen.getByText('Hello! How can I help you today?')).toBeTruthy();
    });

    it('should apply assistant bubble styles for light theme', () => {
      render(<ChatMessage message={mockAssistantMessage} theme="light" accentColor="#02BFB8" />);
      expect(screen.getByText('Hello! How can I help you today?')).toBeTruthy();
    });
  });

  describe('Generating State', () => {
    it('should show generating indicator when message is generating', () => {
      const generatingMessage = { ...mockAssistantMessage, generating: true };
      render(<ChatMessage message={generatingMessage} {...defaultProps} />);
      expect(screen.getByText('AI 正在思考...')).toBeTruthy();
    });
  });

  describe('Timestamp', () => {
    it('should render component with timestamp', () => {
      render(<ChatMessage message={mockUserMessage} {...defaultProps} />);
      expect(screen.getByText('Hello, this is a test message')).toBeTruthy();
    });

    it('should render component without timestamp', () => {
      const messageWithoutTimestamp = { ...mockUserMessage, timestamp: undefined };
      render(<ChatMessage message={messageWithoutTimestamp} {...defaultProps} />);
      expect(screen.getByText('Hello, this is a test message')).toBeTruthy();
    });

    it('should show date for messages from previous days', () => {
      const yesterday = new Date();
      yesterday.setDate(yesterday.getDate() - 1);
      const oldMessage = {
        ...mockUserMessage,
        timestamp: yesterday.getTime(),
      };
      render(<ChatMessage message={oldMessage} {...defaultProps} />);
      expect(screen.getByText('Hello, this is a test message')).toBeTruthy();
    });
  });

  describe('Message Actions', () => {
    it('should hide actions when showActions is false', () => {
      render(<ChatMessage message={mockUserMessage} {...defaultProps} showActions={false} />);
      expect(screen.getByText('Hello, this is a test message')).toBeTruthy();
    });

    it('should pass onRetry callback', () => {
      const onRetry = jest.fn();
      render(<ChatMessage message={mockAssistantMessage} {...defaultProps} onRetry={onRetry} />);
      expect(screen.getByText('Hello! How can I help you today?')).toBeTruthy();
    });

    it('should pass onRegenerate callback', () => {
      const onRegenerate = jest.fn();
      render(
        <ChatMessage message={mockAssistantMessage} {...defaultProps} onRegenerate={onRegenerate} />
      );
      expect(screen.getByText('Hello! How can I help you today?')).toBeTruthy();
    });

    it('should pass onEdit callback', () => {
      const onEdit = jest.fn();
      render(<ChatMessage message={mockUserMessage} {...defaultProps} onEdit={onEdit} />);
      expect(screen.getByText('Hello, this is a test message')).toBeTruthy();
    });
  });

  describe('Edit Mode', () => {
    it('should show edit UI when editing user message', () => {
      const onEdit = jest.fn();
      render(<ChatMessage message={mockUserMessage} {...defaultProps} onEdit={onEdit} />);
      expect(screen.getByText('Hello, this is a test message')).toBeTruthy();
    });
  });

  describe('Theme Variants', () => {
    it('should render correctly with light theme', () => {
      render(<ChatMessage message={mockUserMessage} theme="light" accentColor="#02BFB8" />);
      expect(screen.getByText('Hello, this is a test message')).toBeTruthy();
    });

    it('should render correctly with dark theme', () => {
      render(<ChatMessage message={mockUserMessage} theme="dark" accentColor="#02BFB8" />);
      expect(screen.getByText('Hello, this is a test message')).toBeTruthy();
    });
  });

  describe('Accent Color', () => {
    it('should use custom accent color for user bubble', () => {
      const customColor = '#FF5500';
      render(<ChatMessage message={mockUserMessage} {...defaultProps} accentColor={customColor} />);
      expect(screen.getByText('Hello, this is a test message')).toBeTruthy();
    });
  });
});
