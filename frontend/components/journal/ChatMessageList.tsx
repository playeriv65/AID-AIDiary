import React from 'react';
import { View, ActivityIndicator, StyleSheet, ScrollView } from 'react-native';
import { ThemedText } from '@/components/themed-text';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors, FontSizes } from '@/constants/theme';

interface Message {
    role: 'user' | 'assistant';
    content: string;
}

interface ChatMessageListProps {
    messages: Message[];
    streaming: boolean;
    accentColor: string;
    resolvedTheme: 'light' | 'dark';
    i18n: Record<string, string>;
    scrollViewRef: React.RefObject<ScrollView>;
}

export function ChatMessageList({ messages, streaming, accentColor, resolvedTheme, i18n, scrollViewRef }: ChatMessageListProps) {
    const c = Colors[resolvedTheme];
    
    return (
        <ScrollView 
            ref={scrollViewRef}
            style={styles.chatArea}
            contentContainerStyle={styles.chatContent}
            showsVerticalScrollIndicator={false}
        >
            {messages.length === 0 ? (
                <View style={styles.emptyState}>
                    <IconSymbol name="chat-circle" size={64} color={c.icon + '40'} />
                    <ThemedText style={[styles.emptyTitle, { color: c.text }]}>{i18n.aiWelcome}</ThemedText>
                    <ThemedText style={[styles.emptySubtitle, { color: c.icon }]}>{i18n.aiHint}</ThemedText>
                </View>
            ) : (
                messages.map((msg, index) => (
                    <View 
                        key={index} 
                        style={[
                            styles.messageBubble,
                            msg.role === 'user' ? styles.userBubble : styles.assistantBubble,
                            msg.role === 'user' 
                                ? { backgroundColor: accentColor } 
                                : { backgroundColor: resolvedTheme === 'dark' ? '#2A2C30' : '#F0F0F2' }
                        ]}
                    >
                        <ThemedText style={[
                            styles.messageText,
                            { color: msg.role === 'user' ? '#000' : c.text }
                        ]}>
                            {msg.content}
                        </ThemedText>
                    </View>
                ))
            )}
            {streaming && (
                <View style={[styles.typingBubble, { backgroundColor: resolvedTheme === 'dark' ? '#2A2C30' : '#F0F0F2' }]}>
                    <ActivityIndicator size="small" color={accentColor} />
                </View>
            )}
        </ScrollView>
    );
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
    emptyState: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
        paddingTop: 100,
    },
    emptyTitle: {
        fontSize: FontSizes.xl,
        fontWeight: '500',
        marginTop: 16,
    },
    emptySubtitle: {
        fontSize: FontSizes.md,
        marginTop: 8,
        textAlign: 'center',
        paddingHorizontal: 40,
    },
    messageBubble: {
        maxWidth: '80%',
        padding: 14,
        borderRadius: 18,
        marginBottom: 12,
    },
    userBubble: {
        alignSelf: 'flex-end',
        borderBottomRightRadius: 4,
    },
    assistantBubble: {
        alignSelf: 'flex-start',
        borderBottomLeftRadius: 4,
    },
    messageText: {
        fontSize: FontSizes.md,
        lineHeight: FontSizes.md * 1.5,
    },
    typingBubble: {
        alignSelf: 'flex-start',
        paddingHorizontal: 20,
        paddingVertical: 14,
        borderRadius: 18,
        borderBottomLeftRadius: 4,
        marginBottom: 12,
    },
});
