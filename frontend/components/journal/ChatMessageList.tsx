import React, { useCallback, useState } from 'react';
import {
  ActivityIndicator,
  Platform,
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import * as Clipboard from 'expo-clipboard';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors, FontSizes, FontWeights } from '@/constants/theme';
import { MarkdownRenderer } from '@/components/chat/MarkdownRenderer';

interface Message {
  id?: string;
  role: 'user' | 'assistant';
  content: string;
  timestamp?: number;
  generating?: boolean;
}

interface ChatMessageListProps {
  messages: Message[];
  streaming: boolean;
  accentColor: string;
  resolvedTheme: 'light' | 'dark';
  i18n: Record<string, string>;
  scrollViewRef: React.RefObject<ScrollView>;
  onEditMessage?: (messageId: string, newContent: string) => void;
  onRetry?: (messageId: string) => void;
}

export function ChatMessageList({
  messages,
  streaming,
  accentColor,
  resolvedTheme,
  i18n,
  scrollViewRef,
  onEditMessage,
  onRetry,
}: ChatMessageListProps) {
  const c = Colors[resolvedTheme];
  const [hoveredIndex, setHoveredIndex] = useState<number | null>(null);
  const [copiedIndex, setCopiedIndex] = useState<number | null>(null);

  const handleCopy = useCallback(async (content: string, index: number) => {
    await Clipboard.setStringAsync(content);
    setCopiedIndex(index);
    setTimeout(() => setCopiedIndex(null), 2000);
  }, []);

  const handleRetry = useCallback(
    (messageId?: string, index?: number) => {
      if (onRetry && messageId) {
        onRetry(messageId);
      }
    },
    [onRetry]
  );

  return (
    <ScrollView
      ref={scrollViewRef}
      style={styles.chatArea}
      contentContainerStyle={[styles.chatContent, messages.length === 0 && styles.emptyContent]}
      showsVerticalScrollIndicator={false}
      onMouseEnter={() =>
        Platform.OS === 'web' && document.body.addEventListener('mousemove', handleMouseMove as any)
      }
    >
      {messages.length === 0 ? (
        <View style={styles.emptyState}>
          <IconSymbol name="chat-bubble-left-right" size={64} color={c.icon + '40'} />
          <View style={styles.emptyTitleRow}>
            <IconSymbol name="sparkles" size={20} color={accentColor} />
            <Text style={[styles.emptyTitle, { color: c.text }]}>{i18n.aiWelcome}</Text>
          </View>
          <Text style={[styles.emptySubtitle, { color: c.icon }]}>{i18n.aiHint}</Text>
        </View>
      ) : (
        messages.map((msg, index) => (
          <MessageBubble
            key={msg.id || index}
            message={msg}
            index={index}
            isHovered={hoveredIndex === index}
            onHover={(hovered) => {
              if (Platform.OS === 'web') {
                setHoveredIndex(hovered ? index : null);
              }
            }}
            onCopy={handleCopy}
            onRetry={handleRetry}
            copied={copiedIndex === index}
            accentColor={accentColor}
            resolvedTheme={resolvedTheme}
            c={c}
            onEditMessage={onEditMessage}
          />
        ))
      )}
      {streaming && (
        <View
          style={[
            styles.typingBubble,
            { backgroundColor: resolvedTheme === 'dark' ? '#2A2C30' : '#F0F0F2' },
          ]}
        >
          <ActivityIndicator size="small" color={accentColor} />
          <Text style={[styles.typingText, { color: c.icon }]}>AI 正在思考...</Text>
        </View>
      )}
    </ScrollView>
  );
}

interface MessageBubbleProps {
  message: Message;
  index: number;
  isHovered: boolean;
  onHover: (hovered: boolean) => void;
  onCopy: (content: string, index: number) => void;
  onRetry: (messageId?: string, index?: number) => void;
  copied: boolean;
  accentColor: string;
  resolvedTheme: 'light' | 'dark';
  c: any;
  onEditMessage?: (messageId: string, newContent: string) => void;
}

function MessageBubble({
  message,
  index,
  isHovered,
  onHover,
  onCopy,
  onRetry,
  copied,
  accentColor,
  resolvedTheme,
  c,
  onEditMessage,
}: MessageBubbleProps) {
  const isUser = message.role === 'user';
  const [isEditing, setIsEditing] = useState(false);
  const [editContent, setEditContent] = useState(message.content);

  const bubbleStyle = isUser
    ? [styles.messageBubble, styles.userBubble, { backgroundColor: accentColor }]
    : [
        styles.messageBubble,
        styles.assistantBubble,
        { backgroundColor: resolvedTheme === 'dark' ? '#2A2C30' : '#F0F0F2' },
      ];

  const handleEdit = () => {
    if (onEditMessage && message.id) {
      onEditMessage(message.id, editContent);
      setIsEditing(false);
    }
  };

  return (
    <TouchableOpacity
      activeOpacity={0.9}
      onLongPress={() => onHover(true)}
      onPress={() => onHover(false)}
      style={[isUser ? styles.userContainer : styles.assistantContainer]}
      onMouseEnter={() => Platform.OS === 'web' && onHover(true)}
      onMouseLeave={() => Platform.OS === 'web' && onHover(false)}
    >
      {!isUser && (
        <View
          style={[
            styles.avatar,
            { backgroundColor: resolvedTheme === 'dark' ? '#3A3C40' : '#E0E0E0' },
          ]}
        >
          <IconSymbol name="robot" size={18} color={c.tint} />
        </View>
      )}

      <View style={styles.contentWrapper}>
        <View style={bubbleStyle}>
          {message.generating ? (
            <View style={styles.generatingContainer}>
              <ActivityIndicator size="small" color={accentColor} />
              <Text style={[styles.generatingText, { color: c.icon }]}>AI 正在思考...</Text>
            </View>
          ) : isEditing ? (
            <View style={styles.editContainer}>
              <Text
                style={[
                  styles.editInput,
                  {
                    color: c.text,
                    backgroundColor: resolvedTheme === 'dark' ? '#1A1C1E' : '#FFFFFF',
                  },
                ]}
                multiline
              >
                {editContent}
              </Text>
              <View style={styles.editActions}>
                <TouchableOpacity
                  style={[styles.editButton, { backgroundColor: accentColor }]}
                  onPress={handleEdit}
                >
                  <Text style={styles.editButtonText}>发送</Text>
                </TouchableOpacity>
                <TouchableOpacity
                  style={[styles.editButton, { backgroundColor: c.icon + '40' }]}
                  onPress={() => {
                    setIsEditing(false);
                    setEditContent(message.content);
                  }}
                >
                  <Text style={[styles.editButtonText, { color: c.text }]}>取消</Text>
                </TouchableOpacity>
              </View>
            </View>
          ) : (
            <MarkdownRenderer
              content={message.content}
              theme={resolvedTheme}
              accentColor={accentColor}
            />
          )}
        </View>

        {isHovered && !message.generating && (
          <View
            style={[
              styles.actionButtons,
              { backgroundColor: resolvedTheme === 'dark' ? '#2A2C30' : '#FFFFFF' },
            ]}
          >
            <TouchableOpacity
              style={styles.actionButton}
              onPress={() => onCopy(message.content, index)}
            >
              <IconSymbol name={copied ? 'checkmark' : 'doc-on-doc'} size={16} color={c.icon} />
            </TouchableOpacity>

            {!isUser && onRetry && (
              <TouchableOpacity
                style={styles.actionButton}
                onPress={() => onRetry(message.id, index)}
              >
                <IconSymbol name="arrow-counterclockwise" size={16} color={c.icon} />
              </TouchableOpacity>
            )}

            {isUser && onEditMessage && message.id && (
              <TouchableOpacity style={styles.actionButton} onPress={() => setIsEditing(true)}>
                <IconSymbol name="pencil" size={16} color={c.icon} />
              </TouchableOpacity>
            )}
          </View>
        )}

        {message.timestamp && (
          <Text style={[styles.timestamp, { color: c.icon }]}>
            {formatTimestamp(message.timestamp)}
          </Text>
        )}
      </View>

      {isUser && (
        <View style={[styles.avatar, styles.userAvatar, { backgroundColor: accentColor }]}>
          <IconSymbol name="person" size={18} color="#000" />
        </View>
      )}
    </TouchableOpacity>
  );
}

function formatTimestamp(timestamp: number): string {
  const date = new Date(timestamp);
  const now = new Date();
  const isToday = date.toDateString() === now.toDateString();

  const hours = date.getHours().toString().padStart(2, '0');
  const minutes = date.getMinutes().toString().padStart(2, '0');

  if (isToday) {
    return `${hours}:${minutes}`;
  }

  const month = (date.getMonth() + 1).toString().padStart(2, '0');
  const day = date.getDate().toString().padStart(2, '0');
  return `${month}-${day} ${hours}:${minutes}`;
}

function handleMouseMove(e: MouseEvent) {
  // Placeholder for mouse tracking
}

const styles = StyleSheet.create({
  chatArea: {
    flex: 1,
  },
  chatContent: {
    padding: 16,
    paddingBottom: 24,
    flexGrow: 1,
    justifyContent: 'flex-start',
  },
  emptyContent: {
    justifyContent: 'center',
  },
  emptyState: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingTop: 100,
  },
  emptyTitleRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    marginTop: 16,
  },
  emptyTitle: {
    fontSize: FontSizes.xl,
    fontWeight: FontWeights.medium,
  },
  emptySubtitle: {
    fontSize: FontSizes.md,
    marginTop: 8,
    textAlign: 'center',
    paddingHorizontal: 40,
  },
  userContainer: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    marginBottom: 12,
    justifyContent: 'flex-end',
    paddingHorizontal: 16,
  },
  assistantContainer: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    marginBottom: 12,
    justifyContent: 'flex-start',
    paddingHorizontal: 16,
  },
  avatar: {
    width: 32,
    height: 32,
    borderRadius: 16,
    alignItems: 'center',
    justifyContent: 'center',
    flexShrink: 0,
  },
  userAvatar: {
    marginLeft: 8,
  },
  contentWrapper: {
    maxWidth: '75%',
    position: 'relative',
  },
  messageBubble: {
    padding: 12,
    borderRadius: 18,
  },
  userBubble: {
    borderBottomRightRadius: 4,
  },
  assistantBubble: {
    borderBottomLeftRadius: 4,
  },
  actionButtons: {
    position: 'absolute',
    right: 8,
    top: -12,
    flexDirection: 'row',
    borderRadius: 16,
    paddingHorizontal: 4,
    paddingVertical: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  actionButton: {
    padding: 6,
    borderRadius: 12,
  },
  timestamp: {
    fontSize: FontSizes.xs,
    marginTop: 4,
    marginHorizontal: 4,
  },
  typingBubble: {
    flexDirection: 'row',
    alignItems: 'center',
    alignSelf: 'flex-start',
    paddingHorizontal: 20,
    paddingVertical: 14,
    borderRadius: 18,
    borderBottomLeftRadius: 4,
    marginBottom: 12,
    marginLeft: 16,
    gap: 8,
  },
  typingText: {
    fontSize: FontSizes.sm,
  },
  generatingContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  generatingText: {
    fontSize: FontSizes.sm,
    marginLeft: 4,
  },
  editContainer: {
    width: '100%',
  },
  editInput: {
    minHeight: 60,
    padding: 8,
    borderRadius: 8,
    fontSize: FontSizes.md,
    textAlignVertical: 'top',
  },
  editActions: {
    flexDirection: 'row',
    gap: 8,
    marginTop: 8,
  },
  editButton: {
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 12,
  },
  editButtonText: {
    fontSize: FontSizes.sm,
    fontWeight: FontWeights.medium,
    color: '#000',
  },
});
