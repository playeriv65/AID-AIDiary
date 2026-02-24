import { renderHook, act } from '@testing-library/react-native';
import { useJournalEntry } from '@/hooks/use-journal-entry';

// Create mock dependencies
const mockApiClient = {
  post: jest.fn(),
  put: jest.fn(),
  uploadFile: jest.fn(),
};

const mockFetchEntries = jest.fn();
const mockAlert = jest.fn();

const mockI18n = {
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
  hint: 'Hint',
  enterCredentials: 'Enter credentials',
  error: 'Error',
  authRequired: 'Auth required',
  saveFailed: 'Save failed',
  aiPolishFailed: 'AI polish failed',
  uploadFailed: 'Upload failed',
};

// Mock AppContext
jest.mock('@/context/AppContext', () => ({
  useAppContext: () => ({
    resolvedTheme: 'light',
    accentColor: '#02BFB8',
    i18n: mockI18n,
    language: 'zh',
    authToken: 'mock-token',
    fetchEntries: mockFetchEntries,
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
  beforeEach(() => {
    jest.clearAllMocks();
    mockAlert.mockClear();
    mockFetchEntries.mockClear();
    (mockApiClient.post as jest.Mock).mockClear();
    (mockApiClient.put as jest.Mock).mockClear();
  });

  it('initializes with default values', () => {
    const { result } = renderHook(() => useJournalEntry({
      alert: mockAlert,
      apiClient: mockApiClient,
      fetchEntries: mockFetchEntries,
    }));
    
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
      apiClient: mockApiClient,
      fetchEntries: mockFetchEntries,
    }));
    
    expect(result.current.title).toBe('Test Title');
    expect(result.current.content).toBe('Test Content');
    expect(result.current.category).toBe('work');
    expect(result.current.weather).toBe('sunny');
    expect(result.current.location).toBe('Office');
    expect(result.current.tags).toEqual(['tag1']);
  });

  it('updates title correctly', () => {
    const { result } = renderHook(() => useJournalEntry({
      alert: mockAlert,
      apiClient: mockApiClient,
      fetchEntries: mockFetchEntries,
    }));
    
    act(() => {
      result.current.setTitle('New Title');
    });
    
    expect(result.current.title).toBe('New Title');
  });

  it('updates content correctly', () => {
    const { result } = renderHook(() => useJournalEntry({
      alert: mockAlert,
      apiClient: mockApiClient,
      fetchEntries: mockFetchEntries,
    }));
    
    act(() => {
      result.current.setContent('New Content');
    });
    
    expect(result.current.content).toBe('New Content');
  });

  it('calculates word count based on content length', () => {
    const { result } = renderHook(() => useJournalEntry({
      initialContent: 'Hello World',
      alert: mockAlert,
      apiClient: mockApiClient,
      fetchEntries: mockFetchEntries,
    }));
    
    expect(result.current.wordCount).toBe(11);
  });

  it('inserts list template correctly', () => {
    const { result } = renderHook(() => useJournalEntry({
      alert: mockAlert,
      apiClient: mockApiClient,
      fetchEntries: mockFetchEntries,
    }));
    
    act(() => {
      result.current.insertTemplate('list');
    });
    
    expect(result.current.content).toContain('•');
  });

  it('inserts task template correctly', () => {
    const { result } = renderHook(() => useJournalEntry({
      alert: mockAlert,
      apiClient: mockApiClient,
      fetchEntries: mockFetchEntries,
    }));
    
    act(() => {
      result.current.insertTemplate('task');
    });
    
    expect(result.current.content).toContain('☐');
  });

  it('inserts time template correctly', () => {
    const { result } = renderHook(() => useJournalEntry({
      alert: mockAlert,
      apiClient: mockApiClient,
      fetchEntries: mockFetchEntries,
    }));
    
    act(() => {
      result.current.insertTemplate('time');
    });
    
    expect(result.current.content).toMatch(/\[\d{2}:\d{2}\]/);
  });

  it('handles save successfully', async () => {
    (mockApiClient.post as jest.Mock).mockResolvedValue({ id: 1, created_at: new Date().toISOString() });
    
    const { result } = renderHook(() => useJournalEntry({
      initialContent: 'Content to save',
      fetchEntries: mockFetchEntries,
      onSuccess: jest.fn(),
      alert: mockAlert,
      apiClient: mockApiClient,
    }));
    
    await act(async () => {
      await result.current.handleSave();
    });
    
    expect(mockApiClient.post).toHaveBeenCalledWith('/entries', expect.objectContaining({
      content: 'Content to save',
      title: null,
      category: null,
      weather: null,
      location: null,
      tags: null,
      image: null,
    }));
    expect(mockFetchEntries).toHaveBeenCalled();
  });

  it('shows alert when trying to save empty content', async () => {
    const { result } = renderHook(() => useJournalEntry({
      initialContent: '   ',
      alert: mockAlert,
      apiClient: mockApiClient,
      fetchEntries: mockFetchEntries,
    }));
    
    await act(async () => {
      await result.current.handleSave();
    });
    
    expect(mockAlert).toHaveBeenCalledWith('Hint', 'Enter credentials');
  });

  it('handles AI polish successfully', async () => {
    (mockApiClient.post as jest.Mock).mockResolvedValue({
      polished_text: 'Polished content',
      tags: ['tag1'],
    });
    
    const { result } = renderHook(() => useJournalEntry({
      initialContent: 'Original content',
      alert: mockAlert,
      apiClient: mockApiClient,
      fetchEntries: mockFetchEntries,
    }));
    
    await act(async () => {
      await result.current.handleAIPolish();
    });
    
    expect(mockApiClient.post).toHaveBeenCalledWith('/ai/polish', { content: 'Original content' });
    expect(result.current.content).toBe('Polished content\n\n🏷️ tag1');
  });

  it('provides correct category options', () => {
    const { result } = renderHook(() => useJournalEntry({
      alert: mockAlert,
      apiClient: mockApiClient,
      fetchEntries: mockFetchEntries,
    }));
    
    const workOption = result.current.categoryOptions.find(opt => opt.value === 'work');
    expect(workOption?.label).toBe('Work');
  });

  it('updates tags correctly', () => {
    const { result } = renderHook(() => useJournalEntry({
      alert: mockAlert,
      apiClient: mockApiClient,
      fetchEntries: mockFetchEntries,
    }));
    
    act(() => {
      result.current.setTags(['new', 'tags']);
    });
    
    expect(result.current.tags).toEqual(['new', 'tags']);
  });
});
