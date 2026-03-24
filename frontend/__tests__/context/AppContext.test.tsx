import React from 'react';
import { render, waitFor } from '@testing-library/react-native';
import { ACCENT_COLORS, AppProvider, LANGUAGES, useAppContext } from '@/context/AppContext';
import AsyncStorage from '@react-native-async-storage/async-storage';

// Mock dependencies
jest.mock('@react-native-async-storage/async-storage', () => ({
  getItem: jest.fn(),
  setItem: jest.fn(),
  removeItem: jest.fn(),
}));

jest.mock('@/lib/storage', () => ({
  initStorage: jest.fn(() => Promise.resolve()),
  getStorageAdapter: jest.fn(() =>
    Promise.resolve({
      entries: {
        getAll: jest.fn(() => Promise.resolve([])),
        getById: jest.fn(() => Promise.resolve(null)),
        insert: jest.fn(() => Promise.resolve()),
        update: jest.fn(() => Promise.resolve()),
        delete: jest.fn(() => Promise.resolve()),
      },
    })
  ),
  syncWithBackend: jest.fn(() =>
    Promise.resolve({ success: true, uploaded: 0, downloaded: 0, errors: 0 })
  ),
}));

jest.mock('@/api/client', () => ({
  apiClient: {
    setAuthToken: jest.fn(),
    get: jest.fn(() => Promise.resolve({ data: [] })),
    post: jest.fn(() => Promise.resolve({ data: {} })),
  },
}));

jest.mock('@/constants/config', () => ({
  CONFIG: {
    API_URL: 'http://127.0.0.1:8001/api',
    STATIC_URL: 'http://127.0.0.1:8001/static',
  },
}));

// Test component to access context
const TestComponent = ({
  callback,
}: {
  callback: (ctx: ReturnType<typeof useAppContext>) => void;
}) => {
  const ctx = useAppContext();
  React.useEffect(() => {
    callback(ctx);
  }, [ctx]);
  return null;
};

describe('AppContext', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    (AsyncStorage.getItem as jest.Mock).mockImplementation((key: string) => {
      if (key === '@app_theme') return Promise.resolve('dark');
      if (key === '@app_accent') return Promise.resolve('#02BFB8');
      if (key === '@app_language') return Promise.resolve('zh');
      if (key === '@app_token') return Promise.resolve(null);
      if (key === '@app_user') return Promise.resolve(null);
      return Promise.resolve(null);
    });
  });

  describe('Initial State', () => {
    it('should render children after initialization', async () => {
      let rendered = false;

      render(
        <AppProvider>
          <TestComponent
            callback={() => {
              rendered = true;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(rendered).toBe(true);
      });
    });

    it('should load persisted theme from storage', async () => {
      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(contextValue).not.toBeNull();
        expect(contextValue?.themeMode).toBe('dark');
      });
    });

    it('should load persisted accent color from storage', async () => {
      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(contextValue).not.toBeNull();
        expect(contextValue?.accentColor).toBe('#02BFB8');
      });
    });

    it('should load persisted language from storage', async () => {
      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(contextValue).not.toBeNull();
        expect(contextValue?.language).toBe('zh');
      });
    });
  });

  describe('Theme Management', () => {
    it('should have correct accent colors defined', () => {
      expect(ACCENT_COLORS).toHaveLength(6);
      expect(ACCENT_COLORS.map((c) => c.id)).toContain('teal');
      expect(ACCENT_COLORS.map((c) => c.id)).toContain('blue');
      expect(ACCENT_COLORS.map((c) => c.id)).toContain('purple');
    });

    it('should have correct languages defined', () => {
      expect(LANGUAGES).toHaveLength(3);
      expect(LANGUAGES.map((l) => l.id)).toContain('zh');
      expect(LANGUAGES.map((l) => l.id)).toContain('en');
      expect(LANGUAGES.map((l) => l.id)).toContain('ja');
    });

    it('should resolve theme correctly for dark mode', async () => {
      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(contextValue?.resolvedTheme).toBe('dark');
      });
    });

    it('should resolve theme correctly for light mode', async () => {
      (AsyncStorage.getItem as jest.Mock).mockImplementation((key: string) => {
        if (key === '@app_theme') return Promise.resolve('light');
        return Promise.resolve(null);
      });

      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(contextValue?.resolvedTheme).toBe('light');
      });
    });

    it('should have setThemeMode function', async () => {
      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(typeof contextValue?.setThemeMode).toBe('function');
      });
    });

    it('should have setAccentColor function', async () => {
      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(typeof contextValue?.setAccentColor).toBe('function');
      });
    });

    it('should have setLanguage function', async () => {
      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(typeof contextValue?.setLanguage).toBe('function');
      });
    });
  });

  describe('Authentication', () => {
    it('should have null user when not logged in', async () => {
      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(contextValue?.user).toBeNull();
        expect(contextValue?.authToken).toBeNull();
      });
    });

    it('should load persisted user from storage', async () => {
      const mockUser = { id: 1, username: 'testuser', email: 'test@example.com' };
      const mockToken = 'mock-jwt-token';

      (AsyncStorage.getItem as jest.Mock).mockImplementation((key: string) => {
        if (key === '@app_token') return Promise.resolve(mockToken);
        if (key === '@app_user') return Promise.resolve(JSON.stringify(mockUser));
        return Promise.resolve(null);
      });

      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(contextValue?.user).toEqual(mockUser);
        expect(contextValue?.authToken).toBe(mockToken);
      });
    });

    it('should have login function', async () => {
      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(typeof contextValue?.login).toBe('function');
      });
    });

    it('should have logout function', async () => {
      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(typeof contextValue?.logout).toBe('function');
      });
    });
  });

  describe('i18n', () => {
    it('should provide i18n translations', async () => {
      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(contextValue?.i18n).toBeDefined();
        expect(typeof contextValue?.i18n.titlePlaceholder).toBe('string');
      });
    });
  });

  describe('Backend Status', () => {
    it('should have backendStatus state', async () => {
      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(contextValue?.backendStatus).toBeDefined();
        expect(['checking', 'online', 'offline']).toContain(contextValue?.backendStatus);
      });
    });

    it('should have checkBackendHealth function', async () => {
      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(typeof contextValue?.checkBackendHealth).toBe('function');
      });
    });
  });

  describe('Entries Management', () => {
    it('should have entries array', async () => {
      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(Array.isArray(contextValue?.entries)).toBe(true);
      });
    });

    it('should have entriesLoading state', async () => {
      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(typeof contextValue?.entriesLoading).toBe('boolean');
      });
    });

    it('should have fetchEntries function', async () => {
      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(typeof contextValue?.fetchEntries).toBe('function');
      });
    });

    it('should have addEntry function', async () => {
      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(typeof contextValue?.addEntry).toBe('function');
      });
    });

    it('should have updateEntry function', async () => {
      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(typeof contextValue?.updateEntry).toBe('function');
      });
    });

    it('should have deleteEntry function', async () => {
      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(typeof contextValue?.deleteEntry).toBe('function');
      });
    });
  });

  describe('Sync Management', () => {
    it('should have syncResult state', async () => {
      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(contextValue?.syncResult).toBeDefined();
      });
    });

    it('should have manualSync function', async () => {
      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(typeof contextValue?.manualSync).toBe('function');
      });
    });
  });

  describe('Offline State', () => {
    it('should have offlineShown state', async () => {
      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(typeof contextValue?.offlineShown).toBe('boolean');
      });
    });

    it('should have setOfflineShown function', async () => {
      let contextValue: ReturnType<typeof useAppContext> | null = null;

      render(
        <AppProvider>
          <TestComponent
            callback={(ctx) => {
              contextValue = ctx;
            }}
          />
        </AppProvider>
      );

      await waitFor(() => {
        expect(typeof contextValue?.setOfflineShown).toBe('function');
      });
    });
  });
});
