import React, { useCallback } from 'react';
import { ScrollView, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors } from '@/constants/theme';
import { useConversation } from '@/context/ConversationContext';

interface ConversationSidebarProps {
  visible: boolean;
  currentConversationId: string | null;
  onSelectConversation: (conversationId: string) => void;
  onNewConversation?: () => void;
  onClose: () => void;
  theme: 'light' | 'dark';
}

export function ConversationSidebar({
  visible,
  currentConversationId,
  onSelectConversation,
  onNewConversation,
  onClose,
  theme,
}: ConversationSidebarProps) {
  const { conversations, loading, deleteConversation, createConversation } = useConversation();
  const c = Colors[theme];

  const handleNewConversation = useCallback(async () => {
    try {
      const newId = await createConversation();
      if (onNewConversation) {
        onNewConversation();
      } else {
        onSelectConversation(newId);
      }
    } catch (error) {
      console.error('Failed to create conversation:', error);
    }
  }, [createConversation, onSelectConversation, onNewConversation]);

  const handleDelete = useCallback(
    async (e: React.MouseEvent, conversationId: string) => {
      e.stopPropagation();
      if (confirm('确定要删除这个对话吗？')) {
        await deleteConversation(conversationId);
      }
    },
    [deleteConversation]
  );

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    const now = new Date();

    // 比较日历日期而非时间差
    const dateStart = new Date(date.getFullYear(), date.getMonth(), date.getDate());
    const nowStart = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const diffDays = Math.floor((nowStart.getTime() - dateStart.getTime()) / (1000 * 60 * 60 * 24));

    if (diffDays === 0) {
      return '今天';
    } else if (diffDays === 1) {
      return '昨天';
    } else if (diffDays < 7) {
      return `${diffDays}天前`;
    } else {
      return date.toLocaleDateString('zh-CN');
    }
  };

  if (!visible) {
    return null;
  }

  return (
    <View style={[styles.container, { backgroundColor: c.background }]}>
      <View style={[styles.header, { borderBottomColor: c.border }]}>
        <Text style={[styles.headerTitle, { color: c.text }]}>对话历史</Text>
        <TouchableOpacity onPress={handleNewConversation} style={styles.newButton}>
          <IconSymbol name="plus" size={20} color={c.text} />
        </TouchableOpacity>
        <TouchableOpacity onPress={onClose} style={styles.closeButton}>
          <IconSymbol name="xmark" size={20} color={c.text} />
        </TouchableOpacity>
      </View>

      {loading ? (
        <View style={styles.loadingContainer}>
          <Text style={[styles.loadingText, { color: c.textSecondary }]}>加载中...</Text>
        </View>
      ) : conversations.length === 0 ? (
        <View style={styles.emptyContainer}>
          <Text style={[styles.emptyText, { color: c.textSecondary }]}>暂无对话</Text>
          <Text style={[styles.emptySubtext, { color: c.textSecondary }]}>
            点击右上角 + 创建新对话
          </Text>
        </View>
      ) : (
        <ScrollView style={styles.list}>
          {conversations.map((conversation) => (
            <TouchableOpacity
              key={conversation.id}
              onPress={() => onSelectConversation(conversation.id)}
              style={[
                styles.item,
                { borderBottomColor: c.border },
                conversation.id === currentConversationId && {
                  backgroundColor: theme === 'light' ? '#f0f0f0' : '#2a2a2a',
                },
              ]}
            >
              <View style={styles.itemContent}>
                <Text
                  style={[
                    styles.itemTitle,
                    { color: c.text },
                    !conversation.title && { fontStyle: 'italic', opacity: 0.6 },
                  ]}
                  numberOfLines={1}
                >
                  {conversation.title || '新对话'}
                </Text>
                <Text style={[styles.itemDate, { color: c.textSecondary }]}>
                  {formatDate(conversation.updated_at)}
                </Text>
              </View>
              <TouchableOpacity
                onPress={(e) => handleDelete(e as any, conversation.id)}
                style={styles.deleteButton}
              >
                <IconSymbol name="trash" size={16} color={c.textSecondary} />
              </TouchableOpacity>
            </TouchableOpacity>
          ))}
        </ScrollView>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    width: 280,
    borderRightWidth: 1,
    position: 'absolute',
    left: 0,
    top: 0,
    bottom: 0,
    zIndex: 100,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 16,
    borderBottomWidth: 1,
    gap: 12,
  },
  headerTitle: {
    fontSize: 18,
    fontWeight: '600',
    flex: 1,
  },
  newButton: {
    padding: 8,
  },
  closeButton: {
    padding: 8,
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingTop: 40,
  },
  loadingText: {
    fontSize: 14,
  },
  emptyContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingTop: 80,
    paddingHorizontal: 24,
  },
  emptyText: {
    fontSize: 16,
    textAlign: 'center',
    marginBottom: 8,
  },
  emptySubtext: {
    fontSize: 14,
    textAlign: 'center',
  },
  list: {
    flex: 1,
  },
  item: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 12,
    borderBottomWidth: 1,
  },
  itemContent: {
    flex: 1,
  },
  itemTitle: {
    fontSize: 14,
    marginBottom: 4,
  },
  itemDate: {
    fontSize: 12,
  },
  deleteButton: {
    padding: 8,
  },
});
