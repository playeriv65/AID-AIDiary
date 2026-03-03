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
