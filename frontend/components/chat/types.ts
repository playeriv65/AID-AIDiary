export interface ChatMessage {
  id: string;
  role: 'user' | 'assistant';
  content: string;
  timestamp?: number;
  generating?: boolean;
  model?: string;
  usage?: {
    totalTokens?: number;
    inputTokens?: number;
    outputTokens?: number;
  };
}

export interface Conversation {
  id: string;
  title: string | null;
  updated_at: string;
  created_at?: string;
  is_archived?: boolean;
}

export interface ConversationDetail extends Conversation {
  messages: ChatMessage[];
}

export interface Attachment {
  id: string;
  type: 'image' | 'file';
  uri: string;
  name?: string;
  mimeType?: string;
}

export interface ChatState {
  messages: ChatMessage[];
  loading: boolean;
  inputText: string;
  attachments: Attachment[];
}

export type ThemeMode = 'light' | 'dark';

export interface ChatTheme {
  primary: string;
  secondary: string;
  background: string;
  surface: string;
  text: string;
  textSecondary: string;
  border: string;
  userBubble: string;
  assistantBubble: string;
}
