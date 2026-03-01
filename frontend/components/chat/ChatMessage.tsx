import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Platform, ActivityIndicator } from 'react-native';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors, FontSizes, FontWeights } from '@/constants/theme';
import { MarkdownRenderer } from './MarkdownRenderer';
import { MessageActions } from './MessageActions';
import type { ChatMessage as ChatMessageType } from './types';

interface ChatMessageProps {
    message: ChatMessageType;
    theme: 'light' | 'dark';
    accentColor: string;
    showActions?: boolean;
    onEdit?: (messageId: string, newContent: string) => void;
    onRetry?: (messageId: string) => void;
    onRegenerate?: (messageId: string) => void;
}

export function ChatMessage({
    message,
    theme,
    accentColor,
    showActions = true,
    onEdit,
    onRetry,
    onRegenerate,
}: ChatMessageProps) {
    const [isHovered, setIsHovered] = useState(false);
    const [isEditing, setIsEditing] = useState(false);
    const [editContent, setEditContent] = useState(message.content);
    const isUser = message.role === 'user';
    const c = Colors[theme];

    const handleEdit = () => {
        if (onEdit) {
            onEdit(message.id, editContent);
            setIsEditing(false);
        }
    };

    const bubbleStyle = isUser
        ? [styles.bubble, styles.userBubble, { backgroundColor: accentColor, userSelect: 'text' }]
        : [styles.bubble, styles.assistantBubble, { backgroundColor: theme === 'dark' ? '#2A2C30' : '#F0F0F2', userSelect: 'text' }];

    return (
        <TouchableOpacity
            activeOpacity={0.9}
            onLongPress={() => setIsHovered(true)}
            onPress={() => setIsHovered(false)}
            style={[
                styles.container,
                isUser ? styles.userContainer : styles.assistantContainer,
            ]}
            onMouseEnter={() => Platform.OS === 'web' && setIsHovered(true)}
            onMouseLeave={() => Platform.OS === 'web' && setIsHovered(false)}
        >
            {!isUser && (
                <View style={[styles.avatar, { backgroundColor: theme === 'dark' ? '#3A3C40' : '#E0E0E0' }]}>
                    <IconSymbol name="robot" size={18} color={c.tint} />
                </View>
            )}

            <View style={styles.contentWrapper}>
                <View style={bubbleStyle}>
                    {message.generating ? (
                        <View style={styles.generatingContainer}>
                            <ActivityIndicator size="small" color={accentColor} />
                            <Text style={[styles.generatingText, { color: c.icon }]}>
                                AI 正在思考...
                            </Text>
                        </View>
                    ) : isEditing ? (
                        <View style={styles.editContainer}>
                            <Text
                                style={[styles.editInput, { color: c.text, backgroundColor: theme === 'dark' ? '#1A1C1E' : '#FFFFFF' }]}
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
                            theme={theme}
                            accentColor={accentColor}
                        />
                    )}
                </View>

                {!message.generating && (
                    <MessageActions
                        visible={showActions && isHovered}
                        role={message.role}
                        content={message.content}
                        onEdit={(content) => {
                            if (isUser && onEdit) {
                                setEditContent(content);
                                setIsEditing(true);
                            }
                        }}
                        onRetry={onRetry ? () => onRetry(message.id) : undefined}
                        onRegenerate={onRegenerate ? () => onRegenerate(message.id) : undefined}
                        theme={theme}
                        accentColor={accentColor}
                    />
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

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    marginBottom: 12,
    paddingHorizontal: 0,
  },
    userContainer: {
        justifyContent: 'flex-end',
    },
    assistantContainer: {
        justifyContent: 'flex-start',
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
    bubble: {
        padding: 12,
        borderRadius: 18,
    },
    userBubble: {
        borderTopRightRadius: 4,
    },
    assistantBubble: {
        borderTopLeftRadius: 4,
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
    timestamp: {
        fontSize: FontSizes.xs,
        marginTop: 4,
        marginHorizontal: 4,
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
