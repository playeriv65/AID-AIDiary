import React, { useRef, useEffect, useCallback, useState } from 'react';
import {
    View,
    ScrollView,
    StyleSheet,
    TouchableOpacity,
    Platform,
    ActivityIndicator,
    Text,
} from 'react-native';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors } from '@/constants/theme';
import { ChatMessage } from './ChatMessage';
import { ChatInput } from './ChatInput';
import type { ChatMessage as ChatMessageType, Attachment } from './types';

interface ChatContainerProps {
    messages: ChatMessageType[];
    loading?: boolean;
    generating?: boolean;
    inputText: string;
    onInputChange: (text: string) => void;
    onSend: () => void;
    onStopGenerating?: () => void;
    onEditMessage?: (messageId: string, newContent: string) => void;
    onRetryMessage?: (messageId: string) => void;
    onRegenerateMessage?: (messageId: string) => void;
    theme: 'light' | 'dark';
    accentColor: string;
    placeholder?: string;
    emptyState?: {
        title?: string;
        subtitle?: string;
    };
}

export function ChatContainer({
    messages,
    loading = false,
    generating = false,
    inputText,
    onInputChange,
    onSend,
    onStopGenerating,
    onEditMessage,
    onRetryMessage,
    onRegenerateMessage,
    theme,
    accentColor,
    placeholder = '发送消息...',
    emptyState,
}: ChatContainerProps) {
    const scrollViewRef = useRef<ScrollView>(null);
    const [attachments, setAttachments] = useState<Attachment[]>([]);
    const [showScrollButton, setShowScrollButton] = useState(false);
    const c = Colors[theme];
    const isAtBottomRef = useRef(true);

    useEffect(() => {
        if (messages.length > 0 && isAtBottomRef.current) {
            setTimeout(() => {
                scrollViewRef.current?.scrollToEnd({ animated: true });
            }, 100);
        }
    }, [messages.length]);

    useEffect(() => {
        if (generating) {
            setTimeout(() => {
                scrollViewRef.current?.scrollToEnd({ animated: true });
            }, 50);
        }
    }, [generating]);

    const handleScroll = useCallback((event: any) => {
        const { layoutMeasurement, contentOffset, contentSize } = event.nativeEvent;
        const isAtBottom =
            layoutMeasurement.height + contentOffset.y >= contentSize.height - 100;
        isAtBottomRef.current = isAtBottom;
        setShowScrollButton(!isAtBottom && messages.length > 0);
    }, [messages.length]);

    const scrollToBottom = useCallback(() => {
        scrollViewRef.current?.scrollToEnd({ animated: true });
    }, []);

    const handleAttachImage = useCallback((attachment: Attachment) => {
        setAttachments((prev) => [...prev, attachment]);
    }, []);

    const handleRemoveAttachment = useCallback((id: string) => {
        setAttachments((prev) => prev.filter((a) => a.id !== id));
    }, []);

    const handleSend = useCallback(() => {
        onSend();
        setAttachments([]);
    }, [onSend]);

    const isEmpty = messages.length === 0;

    return (
        <View style={[styles.container, { backgroundColor: c.background }]}>
            <ScrollView
                ref={scrollViewRef}
                style={styles.messageList}
                contentContainerStyle={[
                    styles.messageListContent,
                    isEmpty && styles.emptyContent,
                ]}
                showsVerticalScrollIndicator={false}
                onScroll={handleScroll}
                scrollEventThrottle={16}
            >
                {isEmpty ? (
                    <View style={styles.emptyState}>
                        <IconSymbol
                            name="chat-bubble-left-right"
                            size={64}
                            color={c.icon + '40'}
                        />
                        <View style={styles.emptyTextContainer}>
                            <View style={styles.emptyTitleRow}>
                                <IconSymbol name="sparkles" size={20} color={accentColor} />
                                {emptyState?.title && (
                                    <Text style={[styles.emptyTitle, { color: c.text }]}>
                                        {emptyState.title}
                                    </Text>
                                )}
                            </View>
                            {emptyState?.subtitle && (
                                <Text style={[styles.emptySubtitle, { color: c.icon }]}>
                                    {emptyState.subtitle}
                                </Text>
                            )}
                        </View>
                    </View>
                ) : (
                    messages.map((msg) => (
                        <ChatMessage
                            key={msg.id}
                            message={msg}
                            theme={theme}
                            accentColor={accentColor}
                            onEdit={onEditMessage}
                            onRetry={onRetryMessage}
                            onRegenerate={onRegenerateMessage}
                        />
                    ))
                )}

                {(loading || generating) && (
                    <View style={styles.loadingContainer}>
                        <ActivityIndicator size="small" color={accentColor} />
                    </View>
                )}
            </ScrollView>

            {showScrollButton && (
                <TouchableOpacity
                    style={[styles.scrollButton, { backgroundColor: accentColor }]}
                    onPress={scrollToBottom}
                >
                    <IconSymbol name="arrow-down" size={20} color="#000" />
                </TouchableOpacity>
            )}

            <ChatInput
                value={inputText}
                onChangeText={onInputChange}
                onSend={handleSend}
                onStopGenerating={onStopGenerating}
                loading={loading || generating}
                theme={theme}
                accentColor={accentColor}
                placeholder={placeholder}
                attachments={attachments}
                onAttachImage={handleAttachImage}
                onRemoveAttachment={handleRemoveAttachment}
            />
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    messageList: {
        flex: 1,
    },
  messageListContent: {
    paddingVertical: 16,
    paddingHorizontal: 40,
    flexGrow: 1,
  },
    emptyContent: {
        justifyContent: 'center',
        alignItems: 'center',
    },
    emptyState: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
        paddingTop: 100,
    },
    emptyTextContainer: {
        marginTop: 16,
        alignItems: 'center',
        gap: 8,
    },
    emptyTitleRow: {
        flexDirection: 'row',
        alignItems: 'center',
        gap: 8,
    },
    emptyTitle: {
        fontSize: 18,
        fontWeight: '500',
    },
    emptySubtitle: {
        fontSize: 14,
        textAlign: 'center',
        paddingHorizontal: 40,
    },
    loadingContainer: {
        padding: 16,
        alignItems: 'center',
    },
    scrollButton: {
        position: 'absolute',
        bottom: 80,
        right: 20,
        width: 40,
        height: 40,
        borderRadius: 20,
        alignItems: 'center',
        justifyContent: 'center',
        ...(Platform.OS === 'web' ? {
            boxShadow: '0 2px 8px rgba(0,0,0,0.15)',
        } : {
            shadowColor: '#000',
            shadowOffset: { width: 0, height: 2 },
            shadowOpacity: 0.15,
            shadowRadius: 8,
            elevation: 4,
        }),
    },
});
