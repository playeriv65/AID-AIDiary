import React, { createContext, useCallback, useContext, useEffect, useState } from 'react';
import { CONFIG } from '@/constants/config';
import { useAppContext } from './AppContext';
import type { Conversation, ConversationDetail } from '@/components/chat/types';

interface ConversationContextType {
  conversations: Conversation[];
  currentConversation: ConversationDetail | null;
  loading: boolean;
  createConversation: () => Promise<string>;
  switchConversation: (conversationId: string) => Promise<void>;
  deleteConversation: (conversationId: string) => Promise<void>;
  addMessage: (conversationId: string, role: string, content: string) => Promise<void>;
  refreshConversations: () => Promise<void>;
}

const ConversationContext = createContext<ConversationContextType | undefined>(undefined);

export function ConversationProvider({ children }: { children: React.ReactNode }) {
  const { authToken } = useAppContext();
  const [conversations, setConversations] = useState<Conversation[]>([]);
  const [currentConversation, setCurrentConversation] = useState<ConversationDetail | null>(null);
  const [loading, setLoading] = useState(false);

  const fetchConversations = useCallback(async () => {
    if (!authToken) return;
    try {
      const response = await fetch(`${CONFIG.API_URL}/conversations`, {
        headers: { Authorization: `Bearer ${authToken}` },
      });
      if (response.ok) {
        const data = await response.json();
        setConversations(data);
      }
    } catch (error) {
      console.error('Failed to fetch conversations:', error);
    }
  }, [authToken]);

  const fetchConversationDetail = useCallback(
    async (conversationId: string) => {
      if (!authToken) return null;
      try {
        const response = await fetch(`${CONFIG.API_URL}/conversations/${conversationId}`, {
          headers: { Authorization: `Bearer ${authToken}` },
        });
        if (response.ok) {
          const data = await response.json();
          return data as ConversationDetail;
        }
      } catch (error) {
        console.error('Failed to fetch conversation detail:', error);
      }
      return null;
    },
    [authToken]
  );

  const createConversation = useCallback(async (): Promise<string> => {
    if (!authToken) throw new Error('Not authenticated');
    setLoading(true);
    try {
      const response = await fetch(`${CONFIG.API_URL}/conversations`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${authToken}`,
        },
        body: JSON.stringify({ user_id: -1 }),
      });
      if (response.ok) {
        const data = await response.json();
        await fetchConversations();
        return data.id;
      }
      throw new Error('Failed to create conversation');
    } finally {
      setLoading(false);
    }
  }, [authToken, fetchConversations]);

  const switchConversation = useCallback(
    async (conversationId: string) => {
      setLoading(true);
      const detail = await fetchConversationDetail(conversationId);
      if (detail) {
        setCurrentConversation(detail);
      }
      setLoading(false);
    },
    [fetchConversationDetail]
  );

  const deleteConversation = useCallback(
    async (conversationId: string) => {
      if (!authToken) return;
      try {
        const response = await fetch(`${CONFIG.API_URL}/conversations/${conversationId}`, {
          method: 'DELETE',
          headers: { Authorization: `Bearer ${authToken}` },
        });
        if (response.ok) {
          await fetchConversations();
          if (currentConversation?.id === conversationId) {
            setCurrentConversation(null);
          }
        }
      } catch (error) {
        console.error('Failed to delete conversation:', error);
      }
    },
    [authToken, fetchConversations, currentConversation]
  );

  const addMessage = useCallback(
    async (conversationId: string, role: string, content: string) => {
      if (!authToken) return;
      try {
        const response = await fetch(`${CONFIG.API_URL}/conversations/${conversationId}/messages`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${authToken}`,
          },
          body: JSON.stringify({ role, content }),
        });
        if (response.ok) {
          await fetchConversationDetail(conversationId);
          await fetchConversations();
        }
      } catch (error) {
        console.error('Failed to add message:', error);
      }
    },
    [authToken, fetchConversationDetail, fetchConversations]
  );

  const refreshConversations = useCallback(() => fetchConversations(), [fetchConversations]);

  useEffect(() => {
    fetchConversations();
  }, [fetchConversations]);

  return (
    <ConversationContext.Provider
      value={{
        conversations,
        currentConversation,
        loading,
        createConversation,
        switchConversation,
        deleteConversation,
        addMessage,
        refreshConversations,
      }}
    >
      {children}
    </ConversationContext.Provider>
  );
}

export function useConversation() {
  const context = useContext(ConversationContext);
  if (context === undefined) {
    throw new Error('useConversation must be used within a ConversationProvider');
  }
  return context;
}
