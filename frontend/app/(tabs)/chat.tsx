import React, { useCallback, useEffect, useRef, useState } from 'react';
import { Alert, StyleSheet } from 'react-native';
import { useRouter } from 'expo-router';
import axios from 'axios';
import { ThemedView } from '@/components/themed-view';
import { ChatHeader } from '@/components/journal/ChatHeader';
import { ChatContainer, ChatMessageType } from '@/components/chat';
import { ConversationSidebar } from '@/components/chat/ConversationSidebar';
import { GenerateDiaryModal } from '@/components/journal/GenerateDiaryModal';
import { Colors } from '@/constants/theme';
import { CONFIG } from '@/constants/config';
import { useAppContext } from '@/context/AppContext';
import { useConversation } from '@/context/ConversationContext';

export default function ChatScreen() {
  const router = useRouter();
  const { resolvedTheme, accentColor, i18n, authToken, fetchEntries } = useAppContext();
  const {
    conversations,
    currentConversation,
    loading: convLoading,
    createConversation,
    switchConversation,
    deleteConversation,
    addMessage,
    refreshConversations,
  } = useConversation();

  const c = Colors[resolvedTheme];

  const [messages, setMessages] = useState<ChatMessageType[]>([]);
  const [inputText, setInputText] = useState('');
  const [loading, setLoading] = useState(false);
  const [generating, setGenerating] = useState(false);
  const [showGenerateModal, setShowGenerateModal] = useState(false);
  const [sidebarVisible, setSidebarVisible] = useState(false);
  const [isInitializing, setIsInitializing] = useState(false);

  // 使用 ref 追踪最新的 messages，避免 useCallback 依赖项问题
  const messagesRef = useRef<ChatMessageType[]>([]);
  messagesRef.current = messages;

  // 从当前对话加载消息
  useEffect(() => {
    if (currentConversation?.messages) {
      const formattedMessages = currentConversation.messages.map((m) => ({
        id: m.id,
        role: m.role as 'user' | 'assistant',
        content: m.content,
        timestamp: new Date(m.created_at).getTime(),
      }));
      setMessages(formattedMessages);
    } else {
      // 当前对话不存在时清空消息列表
      setMessages([]);
    }
  }, [currentConversation]);

  // 初始化：首次访问且无对话时自动创建新对话
  useEffect(() => {
    if (convLoading || isInitializing) return;

    if (conversations.length === 0 && !currentConversation) {
      setIsInitializing(true);
      (async () => {
        try {
          const newId = await createConversation();
          await switchConversation(newId);
        } catch (error) {
          console.error('Failed to initialize conversation:', error);
        } finally {
          setIsInitializing(false);
        }
      })();
    } else if (conversations.length > 0 && !currentConversation) {
      (async () => {
        try {
          await switchConversation(conversations[0].id);
        } catch (error) {
          console.error('Failed to switch to fallback conversation:', error);
        }
      })();
    }
  }, [
    conversations,
    conversations.length,
    currentConversation,
    convLoading,
    isInitializing,
    createConversation,
    switchConversation,
  ]);

  // 初始加载时获取对话列表
  useEffect(() => {
    refreshConversations();
  }, [refreshConversations]);

  const handleSend = useCallback(async () => {
    const text = inputText.trim();
    if (!text || loading || convLoading || isInitializing) return;

    // 如果没有当前对话，先创建一个
    let conversationId = currentConversation?.id;
    if (!conversationId) {
      try {
        conversationId = await createConversation();
        await switchConversation(conversationId);
      } catch {
        Alert.alert(i18n.error, '创建对话失败，请重试');
        return;
      }
    }

    const userMessage: ChatMessageType = {
      id: `msg_${Date.now()}`,
      role: 'user',
      content: text,
      timestamp: Date.now(),
    };

    setMessages((prev) => [...prev, userMessage]);
    setInputText('');
    setLoading(true);

    try {
      await addMessage(conversationId, 'user', userMessage.content);

      const chatMessages = [...messagesRef.current, userMessage].map((m) => ({
        role: m.role,
        content: m.content,
      }));

      const response = await fetch(`${CONFIG.API_URL}/ai/chat/stream`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Accept: 'text/event-stream',
          'Cache-Control': 'no-cache',
          Authorization: `Bearer ${authToken}`,
        },
        body: JSON.stringify({ messages: chatMessages }),
      });

      if (!response.ok) {
        if (response.status === 401) {
          throw new Error('AI 服务认证失败，请检查 API Key 配置');
        } else if (response.status === 429) {
          throw new Error('请求过于频繁，请稍后再试');
        } else if (response.status === 503) {
          throw new Error('AI 服务暂时不可用，请稍后再试');
        } else if (response.status === 504) {
          throw new Error('AI 服务响应超时，请重试');
        } else if (response.status >= 500) {
          throw new Error('服务器错误，请稍后再试');
        } else {
          throw new Error(`网络错误：${response.status}`);
        }
      }

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
              if (data.error) {
                throw new Error(data.error);
              }
              if (data.content) {
                assistantContent += data.content;
                if (firstContent) {
                  firstContent = false;
                  setMessages((prev) => [
                    ...prev,
                    {
                      id: `msg_${Date.now()}`,
                      role: 'assistant',
                      content: assistantContent,
                      timestamp: Date.now(),
                    },
                  ]);
                } else {
                  setMessages((prev) => {
                    const newMessages = [...prev];
                    newMessages[newMessages.length - 1] = {
                      ...newMessages[newMessages.length - 1],
                      content: assistantContent,
                    };
                    return newMessages;
                  });
                }
              }
            } catch (parseError: any) {
              if (parseError.message && !parseError.message.includes('JSON')) {
                throw parseError;
              }
            }
          }
        }
      }

      if (assistantContent) {
        await addMessage(conversationId, 'assistant', assistantContent);
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
  }, [
    inputText,
    loading,
    convLoading,
    isInitializing,
    authToken,
    i18n,
    currentConversation,
    createConversation,
    switchConversation,
    addMessage,
  ]);

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
      const chatMessages = messages.map((m) => ({ role: m.role, content: m.content }));
      const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
      const now = new Date();
      const currentTime = now.toLocaleString('zh-CN', {
        timeZone: userTimezone,
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        hour12: false,
      });

      const response = await axios.post(
        `${CONFIG.API_URL}/ai/generate-entry`,
        {
          messages: chatMessages,
          timezone: userTimezone,
          current_time: currentTime,
        },
        { headers: { Authorization: `Bearer ${authToken}` } }
      );

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
    if (!currentConversation) return;
    Alert.alert(i18n.clearChat, '确定要清空当前对话吗？', [
      { text: i18n.cancel, style: 'cancel' },
      {
        text: i18n.confirm,
        onPress: async () => {
          await deleteConversation(currentConversation.id);
          setMessages([]);
          // 创建新对话
          const newId = await createConversation();
          await switchConversation(newId);
        },
      },
    ]);
  };

  const handleEditMessage = (messageId: string, newContent: string) => {
    setMessages((prev) =>
      prev.map((msg) => (msg.id === messageId ? { ...msg, content: newContent } : msg))
    );
  };

  const handleRetryMessage = (messageId: string) => {
    const msgIndex = messages.findIndex((m) => m.id === messageId);
    if (msgIndex === -1 || msgIndex >= messages.length - 1) return;

    const userMsg = messages[msgIndex - 1];
    if (userMsg?.role !== 'user') return;

    const newMessages = messages.slice(0, msgIndex);
    setMessages(newMessages);

    setTimeout(() => handleSend(), 100);
  };

  const handleSelectConversation = async (conversationId: string) => {
    await switchConversation(conversationId);
    setSidebarVisible(false);
  };

  const handleNewConversation = async () => {
    const newId = await createConversation();
    await switchConversation(newId);
    setSidebarVisible(false);
  };

  return (
    <ThemedView style={[styles.container, { backgroundColor: c.background }]}>
      <ConversationSidebar
        visible={sidebarVisible}
        currentConversationId={currentConversation?.id || null}
        onSelectConversation={handleSelectConversation}
        onNewConversation={handleNewConversation}
        onClose={() => setSidebarVisible(false)}
        theme={resolvedTheme}
      />
      <ChatHeader
        hasMessages={messages.length > 0}
        accentColor={accentColor}
        resolvedTheme={resolvedTheme}
        i18n={i18n}
        generating={generating}
        onClear={handleClear}
        onGenerateDiary={handleGenerateDiary}
        onToggleSidebar={() => setSidebarVisible(!sidebarVisible)}
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
