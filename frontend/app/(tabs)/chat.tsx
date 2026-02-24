import React, { useState, useRef, useEffect } from 'react';
import { StyleSheet, View, TextInput, TouchableOpacity, ScrollView, ActivityIndicator, KeyboardAvoidingView, Platform, Alert, Modal } from 'react-native';
import { useRouter } from 'expo-router';
import axios from 'axios';
import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors, FontSizes, FontWeights } from '@/constants/theme';
import { CONFIG } from '@/constants/config';
import { useAppContext } from '@/context/AppContext';

interface Message {
    role: 'user' | 'assistant';
    content: string;
}

export default function ChatScreen() {
    const router = useRouter();
    const { resolvedTheme, accentColor, i18n, authToken, fetchEntries } = useAppContext();
    const c = Colors[resolvedTheme];
    
    const messagesRef = useRef<Message[]>([]);
    const [messages, setMessages] = useState<Message[]>([]);
    const [inputText, setInputText] = useState('');
    const [loading, setLoading] = useState(false);
    const [streaming, setStreaming] = useState(false);
    const [showGenerateModal, setShowGenerateModal] = useState(false);
    const [generating, setGenerating] = useState(false);
    const scrollViewRef = useRef<ScrollView>(null);

    // 从 localStorage 加载聊天记录
    useEffect(() => {
        if (Platform.OS === 'web') {
            const saved = localStorage.getItem('chat_messages');
            if (saved) {
                try {
                    const parsed = JSON.parse(saved);
                    setMessages(parsed);
                    messagesRef.current = parsed;
                } catch {
                    // ignore
                }
            }
        }
    }, []);

    // 保存聊天记录到 localStorage
    useEffect(() => {
        if (Platform.OS === 'web' && messages.length > 0) {
            localStorage.setItem('chat_messages', JSON.stringify(messages));
        }
    }, [messages]);

    const handleKeyPress = (e: any) => {
        if (Platform.OS === 'web' && e.nativeEvent.key === 'Enter' && !e.nativeEvent.shiftKey) {
            e.preventDefault?.();
            handleSend();
        }
    };

    const handleSend = async () => {
        if (!inputText.trim() || loading) return;
        
        const userMessage: Message = { role: 'user', content: inputText.trim() };
        setMessages(prev => [...prev, userMessage]);
        setInputText('');
        setLoading(true);
        setStreaming(true);
        
        try {
            const chatMessages = [...messages, userMessage].map(m => ({ role: m.role, content: m.content }));
            
            const response = await fetch(`${CONFIG.API_URL}/ai/chat/stream`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'text/event-stream',
                    'Cache-Control': 'no-cache',
                    'Authorization': `Bearer ${authToken}`,
                },
                body: JSON.stringify({ messages: chatMessages }),
            });

            if (!response.ok) {
                throw new Error('Stream failed');
            }

            const reader = response.body.getReader();
            const decoder = new TextDecoder();
            let assistantContent = '';
            let buffer = '';
            let firstContent = true;

            while (true) {
                const { done, value } = await reader.read();
                if (done) {
                    setStreaming(false);
                    break;
                }
                
                buffer += decoder.decode(value, { stream: true });
                const lines = buffer.split('\n');
                buffer = lines.pop() || '';
                
                for (const line of lines) {
                    if (line.startsWith('data: ')) {
                        const dataStr = line.slice(6);
                        try {
                            const data = JSON.parse(dataStr);
                            if (data.content) {
                                assistantContent += data.content;
                                if (firstContent) {
                                    firstContent = false;
                                    setStreaming(false);
                                    setMessages(prev => [...prev, { role: 'assistant', content: assistantContent }]);
                                } else {
                                    setMessages(prev => {
                                        const newMessages = [...prev];
                                        newMessages[newMessages.length - 1] = { 
                                            role: 'assistant', 
                                            content: assistantContent 
                                        };
                                        return newMessages;
                                    });
                                }
                            }
                        } catch {
                            // Skip invalid JSON
                        }
                    }
                }
            }
        } catch (error: any) {
            console.error('Chat error:', error);
            const errorMsg = error.response?.data?.detail || error.message || '';
            if (errorMsg.includes('clipboard') || errorMsg.includes('image')) {
                Alert.alert(i18n.hint, '抱歉，我无法读取图片。请用文字描述今天的故事。');
            } else {
                Alert.alert(i18n.error, 'AI 响应失败，请重试');
            }
        } finally {
            setLoading(false);
        }
    };

    const handleGenerateDiary = () => {
        if (messages.length === 0) {
            Alert.alert(i18n.hint, '请先和我聊聊今天的故事');
            return;
        }
        setShowGenerateModal(true);
    };

    const confirmGenerateDiary = async () => {
        setShowGenerateModal(false);
        setGenerating(true);
        try {
            const chatMessages = messages.map(m => ({ role: m.role, content: m.content }));
            
            // 获取用户当前时区
            const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
            const now = new Date();
            const currentTime = now.toLocaleString('zh-CN', { 
                timeZone: userTimezone,
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit',
                hour12: false
            });
            
            const response = await axios.post(`${CONFIG.API_URL}/ai/generate-entry`, { 
                messages: chatMessages,
                timezone: userTimezone,
                current_time: currentTime
            }, {
                headers: { Authorization: `Bearer ${authToken}` },
            });
            
            const { title, content, tags } = response.data;
            
            await fetchEntries();
            router.push({
                pathname: '/write',
                params: { title, content, tags: tags?.join(',') }
            });
        } catch (error) {
            console.error('Generate diary error:', error);
            Alert.alert(i18n.error, '生成日记失败，请重试');
        } finally {
            setGenerating(false);
        }
    };

    const handleClear = () => {
        if (messages.length === 0) return;
        Alert.alert(
            i18n.clearChat,
            '确定要清空对话吗？',
            [
                { text: i18n.cancel, style: 'cancel' },
                { 
                    text: i18n.confirm, 
                    onPress: () => {
                        setMessages([]);
                        if (Platform.OS === 'web') {
                            localStorage.removeItem('chat_messages');
                        }
                    }
                },
            ]
        );
    };

    useEffect(() => {
        setTimeout(() => scrollViewRef.current?.scrollToEnd({ animated: true }), 100);
    }, [messages]);

    return (
        <ThemedView style={[styles.container, { backgroundColor: c.background }]}>
            <View style={[styles.header, { borderBottomColor: resolvedTheme === 'dark' ? '#1A1C1E' : '#E8E8EA' }]}>
                <ThemedText style={[styles.headerTitle, { color: c.text }]}>{i18n.aiChat}</ThemedText>
                <View style={styles.headerActions}>
                    {messages.length > 0 && (
                        <TouchableOpacity onPress={handleClear} style={styles.headerBtn}>
                            <IconSymbol name="trash" size={20} color={c.icon} />
                        </TouchableOpacity>
                    )}
                    <TouchableOpacity 
                        onPress={() => handleGenerateDiary()} 
                        style={[styles.generateBtn, { backgroundColor: accentColor }]}
                        disabled={generating}
                    >
                        {generating ? (
                            <ActivityIndicator size="small" color="#000" />
                        ) : (
                            <>
                                <IconSymbol name="note" size={16} color="#000" />
                                <ThemedText style={styles.generateBtnText}>{i18n.generateDiary}</ThemedText>
                            </>
                        )}
                    </TouchableOpacity>
                </View>
            </View>

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

            <KeyboardAvoidingView 
                behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
                keyboardVerticalOffset={Platform.OS === 'web' ? 0 : 90}
            >
                <View style={[styles.inputArea, { backgroundColor: c.background, borderTopColor: resolvedTheme === 'dark' ? '#1A1C1E' : '#E8E8EA' }]}>
                    <TextInput
                        style={[
                            styles.input, 
                            { 
                                backgroundColor: resolvedTheme === 'dark' ? '#2A2C30' : '#F0F0F2', 
                                color: c.text,
                                ...(Platform.OS === 'web' ? { overflow: 'hidden' } : {}),
                            }
                        ]}
                        placeholder={i18n.chatPlaceholder}
                        placeholderTextColor={c.icon}
                        value={inputText}
                        onChangeText={setInputText}
                        multiline
                        maxLength={500}
                        blurOnSubmit={false}
                        scrollEnabled={false}
                        onKeyPress={handleKeyPress}
                        onSubmitEditing={handleSend}
                        returnKeyType="send"
                    />
                    <TouchableOpacity 
                        style={[styles.sendBtn, { backgroundColor: inputText.trim() ? accentColor : c.icon + '40' }]}
                        onPress={handleSend}
                        disabled={!inputText.trim() || loading}
                    >
                        <IconSymbol name="paper-plane" size={20} color={inputText.trim() ? '#000' : c.icon} />
                    </TouchableOpacity>
                </View>
            </KeyboardAvoidingView>

            <Modal visible={showGenerateModal} transparent animationType="fade">
                <View style={styles.modalOverlay}>
                    <View style={[styles.modalContent, { backgroundColor: c.background }]}>
                        <ThemedText style={[styles.modalTitle, { color: c.text }]}>{i18n.generateDiary}</ThemedText>
                        <ThemedText style={[styles.modalText, { color: c.icon }]}>根据我们的对话生成今天的日记？</ThemedText>
                        <View style={styles.modalButtons}>
                            <TouchableOpacity 
                                style={[styles.modalBtn, { backgroundColor: resolvedTheme === 'dark' ? '#2A2C30' : '#F0F0F2' }]}
                                onPress={() => setShowGenerateModal(false)}
                            >
                                <ThemedText style={{ color: c.text }}>{i18n.cancel}</ThemedText>
                            </TouchableOpacity>
                            <TouchableOpacity 
                                style={[styles.modalBtn, { backgroundColor: accentColor }]}
                                onPress={confirmGenerateDiary}
                            >
                                <ThemedText style={{ color: '#000', fontWeight: FontWeights.semibold }}>{i18n.confirm}</ThemedText>
                            </TouchableOpacity>
                        </View>
                    </View>
                </View>
            </Modal>
        </ThemedView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    header: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        paddingHorizontal: 20,
        paddingTop: Platform.OS === 'web' ? 16 : 56,
        paddingBottom: 12,
        borderBottomWidth: StyleSheet.hairlineWidth,
    },
    headerTitle: {
        fontSize: FontSizes.xl,
        fontWeight: FontWeights.semibold,
    },
    headerActions: {
        flexDirection: 'row',
        alignItems: 'center',
        gap: 12,
    },
    headerBtn: {
        padding: 8,
    },
    generateBtn: {
        flexDirection: 'row',
        alignItems: 'center',
        gap: 6,
        paddingHorizontal: 14,
        paddingVertical: 8,
        borderRadius: 20,
    },
    generateBtnText: {
        color: '#000',
        fontWeight: FontWeights.semibold,
        fontSize: FontSizes.sm,
    },
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
        fontWeight: FontWeights.medium,
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
    inputArea: {
        flexDirection: 'row',
        alignItems: 'flex-end',
        padding: 12,
        borderTopWidth: StyleSheet.hairlineWidth,
        gap: 10,
    },
    input: {
        flex: 1,
        maxHeight: 100,
        paddingHorizontal: 16,
        paddingVertical: 10,
        borderRadius: 20,
        fontSize: FontSizes.md,
    },
    sendBtn: {
        width: 44,
        height: 44,
        borderRadius: 22,
        alignItems: 'center',
        justifyContent: 'center',
    },
    modalOverlay: {
        flex: 1,
        backgroundColor: 'rgba(0,0,0,0.5)',
        justifyContent: 'center',
        alignItems: 'center',
    },
    modalContent: {
        width: '80%',
        maxWidth: 320,
        borderRadius: 16,
        padding: 24,
    },
    modalTitle: {
        fontSize: FontSizes.xl,
        fontWeight: FontWeights.semibold,
        marginBottom: 12,
    },
    modalText: {
        fontSize: FontSizes.md,
        marginBottom: 24,
    },
    modalButtons: {
        flexDirection: 'row',
        gap: 12,
        justifyContent: 'flex-end',
    },
    modalBtn: {
        paddingHorizontal: 20,
        paddingVertical: 10,
        borderRadius: 8,
    },
});
