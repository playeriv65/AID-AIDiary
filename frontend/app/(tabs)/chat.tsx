import React, { useState, useEffect, useCallback } from 'react';
import { StyleSheet, Platform, Alert } from 'react-native';
import { useRouter } from 'expo-router';
import axios from 'axios';
import { ThemedView } from '@/components/themed-view';
import { ChatHeader } from '@/components/journal/ChatHeader';
import { ChatContainer, ChatMessageType } from '@/components/chat';
import { GenerateDiaryModal } from '@/components/journal/GenerateDiaryModal';
import { Colors } from '@/constants/theme';
import { CONFIG } from '@/constants/config';
import { useAppContext } from '@/context/AppContext';

export default function ChatScreen() {
    const router = useRouter();
    const { resolvedTheme, accentColor, i18n, authToken, fetchEntries } = useAppContext();
    const c = Colors[resolvedTheme];
    
    const [messages, setMessages] = useState<ChatMessageType[]>([]);
    const [inputText, setInputText] = useState('');
    const [loading, setLoading] = useState(false);
    const [generating, setGenerating] = useState(false);
    const [showGenerateModal, setShowGenerateModal] = useState(false);

    useEffect(() => {
        if (Platform.OS === 'web') {
            const saved = localStorage.getItem('chat_messages');
            if (saved) {
                try {
                    const parsed = JSON.parse(saved);
                    setMessages(parsed.map((m: any, i: number) => ({
                        id: m.id || `msg_${i}`,
                        role: m.role,
                        content: m.content,
                        timestamp: m.timestamp || Date.now(),
                    })));
                } catch {}
            }
        }
    }, []);

    useEffect(() => {
        if (Platform.OS === 'web' && messages.length > 0) {
            localStorage.setItem('chat_messages', JSON.stringify(messages));
        }
    }, [messages]);

    const handleSend = useCallback(async () => {
        if (!inputText.trim() || loading) return;
        
        const userMessage: ChatMessageType = { 
            id: `msg_${Date.now()}`,
            role: 'user', 
            content: inputText.trim(),
            timestamp: Date.now(),
        };
        setMessages(prev => [...prev, userMessage]);
        setInputText('');
        setLoading(true);
        
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

            if (!response.ok) throw new Error('Stream failed');

            const reader = response.body!.getReader();
            const decoder = new TextDecoder();
            let assistantContent = '';
            let buffer = '';
            let firstContent = true;

            while (true) {
                const { done, value } = await reader.read();
                if (done) {
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
                                    setMessages(prev => [...prev, { 
                                        id: `msg_${Date.now()}`,
                                        role: 'assistant', 
                                        content: assistantContent,
                                        timestamp: Date.now(),
                                    }]);
                                } else {
                                    setMessages(prev => {
                                        const newMessages = [...prev];
                                        newMessages[newMessages.length - 1] = { 
                                            ...newMessages[newMessages.length - 1], 
                                            content: assistantContent 
                                        };
                                        return newMessages;
                                    });
                                }
                            }
                        } catch {}
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
    }, [inputText, loading, messages, authToken, i18n]);

    const handleStopGenerating = useCallback(() => {
        setLoading(false);
    }, []);

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
            const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
            const now = new Date();
            const currentTime = now.toLocaleString('zh-CN', { 
                timeZone: userTimezone,
                year: 'numeric', month: '2-digit', day: '2-digit',
                hour: '2-digit', minute: '2-digit', hour12: false
            });
            
            const response = await axios.post(`${CONFIG.API_URL}/ai/generate-entry`, { 
                messages: chatMessages, timezone: userTimezone, current_time: currentTime
            }, { headers: { Authorization: `Bearer ${authToken}` }});
            
            const { id } = response.data;
            await fetchEntries();
            router.push({ pathname: '/write', params: { id } });
        } catch (error) {
            console.error('Generate diary error:', error);
            Alert.alert(i18n.error, '生成日记失败，请重试');
        } finally {
            setGenerating(false);
        }
    };

    const handleClear = () => {
        if (messages.length === 0) return;
        Alert.alert(i18n.clearChat, '确定要清空对话吗？', [
            { text: i18n.cancel, style: 'cancel' },
            { text: i18n.confirm, onPress: () => {
                setMessages([]);
                if (Platform.OS === 'web') localStorage.removeItem('chat_messages');
            }},
        ]);
    };

    const handleEditMessage = (messageId: string, newContent: string) => {
        setMessages(prev => prev.map(msg => 
            msg.id === messageId ? { ...msg, content: newContent } : msg
        ));
    };

    const handleRetryMessage = (messageId: string) => {
        const msgIndex = messages.findIndex(m => m.id === messageId);
        if (msgIndex === -1 || msgIndex >= messages.length - 1) return;
        
        const userMsg = messages[msgIndex - 1];
        if (userMsg?.role !== 'user') return;
        
        const newMessages = messages.slice(0, msgIndex);
        setMessages(newMessages);
        
        setTimeout(() => handleSend(), 100);
    };

    return (
        <ThemedView style={[styles.container, { backgroundColor: c.background }]}>
            <ChatHeader
                hasMessages={messages.length > 0}
                accentColor={accentColor}
                resolvedTheme={resolvedTheme}
                i18n={i18n}
                generating={generating}
                onClear={handleClear}
                onGenerateDiary={handleGenerateDiary}
            />
            <ChatContainer
                messages={messages}
                loading={loading}
                generating={loading}
                inputText={inputText}
                onInputChange={setInputText}
                onSend={handleSend}
                onStopGenerating={handleStopGenerating}
                onEditMessage={handleEditMessage}
                onRetryMessage={handleRetryMessage}
                theme={resolvedTheme}
                accentColor={accentColor}
                placeholder={i18n.chatPlaceholder}
                emptyState={{
                    title: i18n.aiWelcome,
                    subtitle: i18n.aiHint,
                }}
            />
            <GenerateDiaryModal
                visible={showGenerateModal}
                accentColor={accentColor}
                resolvedTheme={resolvedTheme}
                i18n={i18n}
                onCancel={() => setShowGenerateModal(false)}
                onConfirm={confirmGenerateDiary}
            />
        </ThemedView>
    );
}

const styles = StyleSheet.create({
    container: { flex: 1 },
});
