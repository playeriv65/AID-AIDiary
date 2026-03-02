import axios, { AxiosError, AxiosInstance, InternalAxiosRequestConfig } from 'axios';
import { Alert } from 'react-native';
import { CONFIG } from '../constants/config';

export interface JournalEntry {
  id: string;
  user_id?: number;
  title: string | null;
  content: string;
  category: string | null;
  weather: string | null;
  location: string | null;
  tags: string[] | null;
  image: string | null;
  created_at: string;
  updated_at: string;
  sync_status?: 'synced' | 'pending' | 'error';
  deleted?: number;
}

export interface ApiError {
  detail?: string;
  code?: string;
}

export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  error?: ApiError;
}

class ApiClient {
  private client: AxiosInstance;
  private authToken: string | null;

  constructor() {
    this.authToken = null;
    this.client = axios.create({
      baseURL: CONFIG.API_URL,
      timeout: CONFIG.AXIOS_TIMEOUT,
      headers: {
        'Content-Type': 'application/json',
      },
    });

    this.setupInterceptors();
  }

  setAuthToken(token: string | null) {
    this.authToken = token;
  }

  private setupInterceptors() {
    // Request interceptor
    this.client.interceptors.request.use(
      (config: InternalAxiosRequestConfig) => {
        if (this.authToken) {
          config.headers.Authorization = `Bearer ${this.authToken}`;
        }
        return config;
      },
      (error) => Promise.reject(error)
    );

    // Response interceptor
    this.client.interceptors.response.use(
      (response) => response,
      (error: AxiosError) => {
        if (error.response) {
          const { status, data } = error.response as any;

          if (status === 401) {
            Alert.alert('Error', 'Authentication failed');
          } else if (status === 422) {
            Alert.alert('Error', 'Validation error');
          } else if (status >= 500) {
            Alert.alert('Error', 'Server error');
          } else if (data?.detail) {
            Alert.alert('Error', data.detail as string);
          } else {
            Alert.alert('Error', `Request failed with status ${status}`);
          }
        } else if (error.request) {
          Alert.alert('Error', 'Network error - please check connection');
        } else {
          Alert.alert('Error', 'Unexpected error');
        }

        return Promise.reject(error);
      }
    );
  }

  async get<T>(url: string, params?: Record<string, any>): Promise<T> {
    const response = await this.client.get<T>(url, { params });
    return response.data;
  }

  async post<T>(url: string, data?: any): Promise<T> {
    const response = await this.client.post<T>(url, data);
    return response.data;
  }

  async put<T>(url: string, data?: any): Promise<T> {
    const response = await this.client.put<T>(url, data);
    return response.data;
  }

  async getById<T>(url: string, id: number | string): Promise<T> {
    const response = await this.client.get<T>(`${url}/${id}`);
    return response.data;
  }

  async delete<T>(url: string): Promise<T> {
    const response = await this.client.delete<T>(url);
    return response.data;
  }

  async uploadFile(
    url: string,
    formData: FormData,
    onUploadProgress?: (progress: number) => void
  ): Promise<{ filename: string; url: string }> {
    const response = await this.client.post<{ filename: string; url: string }>(url, formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
      onUploadProgress: (progressEvent) => {
        if (progressEvent.total && onUploadProgress) {
          const progress = Math.round((progressEvent.loaded * 100) / progressEvent.total);
          onUploadProgress(progress);
        }
      },
    });
    return response.data;
  }

  async stream<T>(
    url: string,
    data: any,
    onChunk: (chunk: string) => void,
    onError?: (error: Error) => void,
    onComplete?: () => void
  ): Promise<void> {
    try {
      const response = await fetch(`${CONFIG.API_URL}${url}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${this.authToken}`,
          Accept: 'text/event-stream',
        },
        body: JSON.stringify(data),
      });

      if (!response.ok) {
        throw new Error(`Stream request failed: ${response.status}`);
      }

      const reader = response.body?.getReader();
      if (!reader) {
        throw new Error('No reader available');
      }

      const decoder = new TextDecoder();
      let buffer = '';

      while (true) {
        const { done, value } = await reader.read();
        if (done) {
          onComplete?.();
          break;
        }

        buffer += decoder.decode(value, { stream: true });
        const lines = buffer.split('\n');
        buffer = lines.pop() || '';

        for (const line of lines) {
          if (line.startsWith('data: ')) {
            const data = line.slice(6);
            if (data === '[DONE]') {
              onComplete?.();
              return;
            }
            try {
              const parsed = JSON.parse(data);
              const content = parsed.choices?.[0]?.delta?.content || parsed.content;
              if (content) {
                onChunk(content);
              }
            } catch {
              // Ignore parse errors for incomplete JSON
            }
          }
        }
      }
    } catch (error) {
      onError?.(error as Error);
    }
  }
}

export const apiClient = new ApiClient();
