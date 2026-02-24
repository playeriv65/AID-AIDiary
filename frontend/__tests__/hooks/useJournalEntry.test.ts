import { renderHook, act } from '@testing-library/react-native';
import { useJournalEntry } from '@/hooks/use-journal-entry';
import * as apiClient from '@/api/client';
import { useAppContext } from '@/context/AppContext';

// Mock dependencies
const mockApiClient = {
  post: jest.fn(),
  put: jest.fn(),
  uploadFile: jest.fn(),
};

jest.mock('@/api/client', () => ({
  apiClient: mockApiClient,
}));

jest.mock('@/context/AppContext', () => ({
  useAppContext: () => ({
    authToken: 'mock-token',
    fetchEntries: jest.fn(),
    i18n: {
      hint: 'Hint',
      enterCredentials: 'Enter credentials',
      error: 'Error',
      authRequired: 'Auth required',
      saveFailed: 'Save failed',
      aiPolishFailed: 'AI polish failed',
      uploadFailed: 'Upload failed',
      catWork: 'Work',
      catLife: 'Life',
      catStudy: 'Study',
      catTravel: 'Travel',
      catHealth: 'Health',
      catOther: 'Other',
      weatherSunny: 'Sunny',
      weatherCloudy: 'Cloudy',
      weatherRainy: 'Rainy',
      weatherSnowy: 'Snowy',
      weatherWindy: 'Windy',
      weatherFoggy: 'Foggy',
    },
  }),
}));

// Mock fetch for image upload
global.fetch = jest.fn(() =>
  Promise.resolve({
    ok: true,
    blob: () => Promise.resolve(new Blob(['test'], { type: 'image/jpeg' })),
  })
) as any;

describe('useJournalEntry', () => {
  const mockAlert = jest.fn();

  beforeEach(() => {
    jest.clearAllMocks();
    mockAlert.mockClear();
  });

  it('initializes with default values', () => {
    const { result } = renderHook(() => useJournalEntry({ alert: mockAlert }));
    
    expect(result.current.title).toBe('');
    expect(result.current.content).toBe('');
    expect(result.current.category).toBeNull();
    expect(result.current.weather).toBeNull();
    expect(result.current.location).toBe('');
    expect(result.current.tags).toEqual([]);
    expect(result.current.saving).toBe(false);
    expect(result.current.aiPolishing).toBe(false);
  });

  it('accepts initial values', () => {
    const { result } = renderHook(() => useJournalEntry({
      initialTitle: 'Test Title',
      initialContent: 'Test Content',
      initialCategory: 'work',
      initialWeather: 'sunny',
      initialLocation: 'Office',
      initialTags: ['tag1'],
      alert: mockAlert,
    }));
    
    expect(result.current.title).toBe('Test Title');
    expect(result.current.content).toBe('Test Content');
    expect(result.current.category).toBe('work');
    expect(result.current.weather).toBe('sunny');
    expect(result.current.location).toBe('Office');
    expect(result.current.tags).toEqual(['tag1']);
  });

  it('updates title correctly', () => {
    const { result } = renderHook(() => useJournalEntry({ alert: mockAlert }));
    
    act(() => {
      result.current.setTitle('New Title');
    });
    
    expect(result.current.title).toBe('New Title');
  });

  it('updates content correctly', () => {
    const { result } = renderHook(() => useJournalEntry({ alert: mockAlert }));
    
    act(() => {
      result.current.setContent('New Content');
    });
    
    expect(result.current.content).toBe('New Content');
  });

  it('calculates word count based on content length', () => {
    const { result } = renderHook(() => useJournalEntry({
      initialContent: 'Hello World',
      alert: mockAlert,
    }));
    
    expect(result.current.wordCount).toBe(11);
  });

  it('inserts list template correctly', () => {
    const { result } = renderHook(() => useJournalEntry({ alert: mockAlert }));
    
    act(() => {
      result.current.insertTemplate('list');
    });
    
    expect(result.current.content).toContain('•');
  });

  it('inserts task template correctly', () => {
    const { result } = renderHook(() => useJournalEntry({ alert: mockAlert }));
    
    act(() => {
      result.current.insertTemplate('task');
    });
    
    expect(result.current.content).toContain('☐');
  });

  it('inserts time template correctly', () => {
    const { result } = renderHook(() => useJournalEntry({ alert: mockAlert }));
    
    act(() => {
      result.current.insertTemplate('time');
    });
    
    expect(result.current.content).toMatch(/\[\d{2}:\d{2}\]/);
  });

  it('handles save successfully', async () => {
    mockApiClient.post.mockResolvedValue({});
    const mockFetchEntries = jest.fn();
    const mockOnSuccess = jest.fn();
    
    const { result } = renderHook(() => useJournalEntry({
      initialContent: 'Content to save',
      fetchEntries: mockFetchEntries,
      onSuccess: mockOnSuccess,
      alert: mockAlert,
    }));
    
    await act(async () => {
      await result.current.handleSave();
    });
    
    expect(mockApiClient.post).toHaveBeenCalledWith('/entries', expect.objectContaining({
      content: 'Content to save',
    }));
    expect(mockFetchEntries).toHaveBeenCalled();
    expect(mockOnSuccess).toHaveBeenCalled();
  });

  it('shows alert when trying to save empty content', async () => {
    const { result } = renderHook(() => useJournalEntry({
      initialContent: '   ',
      alert: mockAlert,
    }));
    
    await act(async () => {
      await result.current.handleSave();
    });
    
    expect(mockAlert).toHaveBeenCalledWith('Hint', 'Enter credentials');
  });

  it('shows alert when auth token is missing', async () => {
    const { result } = renderHook(() => useJournalEntry({
      initialContent: 'Valid content',
      authToken: null,
      alert: mockAlert,
    }));
    
    await act(async () => {
      await result.current.handleSave();
    });
    
    expect(mockAlert).toHaveBeenCalledWith('Error', 'Auth required');
  });

  it('handles AI polish successfully', async () => {
    mockApiClient.post.mockResolvedValue({
      polished_text: 'Polished content',
      tags: ['tag1'],
    });
    
    const { result } = renderHook(() => useJournalEntry({
      initialContent: 'Original content',
      alert: mockAlert,
    }));
    
    await act(async () => {
      await result.current.handleAIPolish();
    });
    
    expect(result.current.content).toContain('Polished content');
    expect(result.current.content).toContain('🏷️ tag1');
  });

  it('provides correct category options', () => {
    const { result } = renderHook(() => useJournalEntry({ alert: mockAlert }));
    
    const workOption = result.current.categoryOptions.find(opt => opt.value === 'work');
    expect(workOption?.label).toBe('Work');
  });

  it('updates tags correctly', () => {
    const { result } = renderHook(() => useJournalEntry({ alert: mockAlert }));
    
    act(() => {
      result.current.setTags(['new', 'tags']);
    });
    
    expect(result.current.tags).toEqual(['new', 'tags']);
  });
});
