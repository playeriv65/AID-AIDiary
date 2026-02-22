import React, { createContext, useContext, useState, useEffect, useCallback, useMemo, useSyncExternalStore } from 'react';
import { Platform, Appearance } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import axios from 'axios';
import { t as getTranslations } from '@/constants/i18n';
import { CONFIG } from '@/constants/config';

const API_URL = CONFIG.API_URL;

// Short timeout so UI doesn't hang when backend is down
axios.defaults.timeout = CONFIG.AXIOS_TIMEOUT;

// Storage Keys
const STORAGE_KEYS = {
    THEME: '@app_theme',
    ACCENT: '@app_accent',
    LANGUAGE: '@app_language',
    TOKEN: '@app_token',
    USER: '@app_user',
};

// Accent Colors
export const ACCENT_COLORS = [
    { id: 'teal', hex: '#02BFB8' },
    { id: 'blue', hex: '#3B82F6' },
    { id: 'purple', hex: '#8B5CF6' },
    { id: 'rose', hex: '#F43F5E' },
    { id: 'amber', hex: '#F59E0B' },
    { id: 'green', hex: '#22C55E' },
];

// Languages
export const LANGUAGES = [
    { id: 'zh', label: '中文' },
    { id: 'en', label: 'English' },
    { id: 'ja', label: '日本語' },
];

export type ThemeMode = 'light' | 'dark' | 'system';

interface User {
    id: number;
    username: string;
    email?: string;
}

interface AppContextType {
    themeMode: ThemeMode;
    setThemeMode: (t: ThemeMode) => void;
    resolvedTheme: 'light' | 'dark';
    accentColor: string;
    setAccentColor: (c: string) => void;
    language: string;
    setLanguage: (l: string) => void;
    i18n: ReturnType<typeof getTranslations>;
    user: User | null;
    authToken: string | null;
    login: (user: User, token: string) => void;
    logout: () => void;
    // Global entries cache
    entries: any[];
    entriesLoading: boolean;
    fetchEntries: () => Promise<void>;
    addEntry: (title: string | null, content: string) => Promise<void>;
}

const AppContext = createContext<AppContextType>({} as AppContextType);

// Robust system color scheme detection that works across SSR hydration
function useSystemColorScheme(): 'light' | 'dark' {
    const getSnapshot = useCallback(() => {
        if (Platform.OS === 'web' && typeof window !== 'undefined' && window.matchMedia) {
            return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
        }
        return (Appearance.getColorScheme() as 'light' | 'dark') ?? 'dark';
    }, []);

    const subscribe = useCallback((callback: () => void) => {
        if (Platform.OS === 'web' && typeof window !== 'undefined' && window.matchMedia) {
            const mql = window.matchMedia('(prefers-color-scheme: dark)');
            mql.addEventListener('change', callback);
            return () => mql.removeEventListener('change', callback);
        } else {
            const sub = Appearance.addChangeListener(callback);
            return () => sub.remove();
        }
    }, []);

    const getServerSnapshot = useCallback(() => 'dark' as const, []);

    return useSyncExternalStore(subscribe, getSnapshot, getServerSnapshot);
}

export function AppProvider({ children }: { children: React.ReactNode }) {
    const [themeMode, _setThemeMode] = useState<ThemeMode>('dark');
    const [accentColor, _setAccentColor] = useState('#02BFB8');
    const [language, _setLanguage] = useState('zh');
    const [user, setUser] = useState<User | null>(null);
    const [authToken, setAuthToken] = useState<string | null>(null);
    const systemScheme = useSystemColorScheme();
    const [entries, setEntries] = useState<any[]>([]);
    const [entriesLoading, setEntriesLoading] = useState(true);
    const [ready, setReady] = useState(false);

    // Load persisted prefs on mount
    useEffect(() => {
        (async () => {
            try {
                const [savedTheme, savedAccent, savedLang, savedToken, savedUser] = await Promise.all([
                    AsyncStorage.getItem(STORAGE_KEYS.THEME),
                    AsyncStorage.getItem(STORAGE_KEYS.ACCENT),
                    AsyncStorage.getItem(STORAGE_KEYS.LANGUAGE),
                    AsyncStorage.getItem(STORAGE_KEYS.TOKEN),
                    AsyncStorage.getItem(STORAGE_KEYS.USER),
                ]);
                if (savedTheme) _setThemeMode(savedTheme as ThemeMode);
                if (savedAccent) _setAccentColor(savedAccent);
                if (savedLang) _setLanguage(savedLang);
                if (savedToken) setAuthToken(savedToken);
                if (savedUser) setUser(JSON.parse(savedUser));
            } catch (err) {
                console.error('Failed to load persisted app state:', err);
            }
            setReady(true);
        })();
    }, []);

    // Global entries fetch (cached across navigations)
    const fetchEntries = useCallback(async () => {
        try {
            const response = await axios.get(`${API_URL}/entries`);
            const sorted = response.data.sort((a: any, b: any) =>
                new Date(b.created_at).getTime() - new Date(a.created_at).getTime());
            setEntries(sorted);
        } catch (err) {
            console.error('Failed to fetch entries:', err);
            // Silently fail for UI — keep existing cached entries
        } finally {
            setEntriesLoading(false);
        }
    }, []);

    // Optimistic add: immediately add to cache, then sync with backend
    const addEntry = useCallback(async (title: string | null, content: string) => {
        const optimisticEntry = {
            id: Date.now(), // temp id
            title,
            content,
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString(),
        };
        // Immediately prepend to cache
        setEntries(prev => [optimisticEntry, ...prev]);
        // Post to backend in background, then reconcile
        try {
            const res = await axios.post(`${API_URL}/entries`, {
                title: title || null,
                content,
            });
            // Replace optimistic entry with real one from server
            setEntries(prev => prev.map(e => e.id === optimisticEntry.id ? res.data : e));
        } catch (err) {
            console.error('Failed to sync new entry to backend:', err);
            // Keep optimistic entry even if backend fails
        }
    }, []);

    // Fetch entries on mount
    useEffect(() => {
        fetchEntries();
    }, [fetchEntries]);

    // System color scheme is now handled by useSystemColorScheme() hook above

    const resolvedTheme: 'light' | 'dark' =
        themeMode === 'system' ? systemScheme : themeMode;

    const i18n = useMemo(() => getTranslations(language), [language]);

    const setThemeMode = useCallback(async (val: ThemeMode) => {
        _setThemeMode(val);
        AsyncStorage.setItem(STORAGE_KEYS.THEME, val);
    }, []);

    const setAccentColor = useCallback(async (val: string) => {
        _setAccentColor(val);
        AsyncStorage.setItem(STORAGE_KEYS.ACCENT, val);
    }, []);

    const setLanguage = useCallback(async (val: string) => {
        _setLanguage(val);
        AsyncStorage.setItem(STORAGE_KEYS.LANGUAGE, val);
    }, []);

    const login = useCallback(async (u: User, token: string) => {
        setUser(u);
        setAuthToken(token);
        AsyncStorage.setItem(STORAGE_KEYS.TOKEN, token);
        AsyncStorage.setItem(STORAGE_KEYS.USER, JSON.stringify(u));
    }, []);

    const logout = useCallback(async () => {
        setUser(null);
        setAuthToken(null);
        AsyncStorage.removeItem(STORAGE_KEYS.TOKEN);
        AsyncStorage.removeItem(STORAGE_KEYS.USER);
    }, []);

    const value = useMemo(() => ({
        themeMode, setThemeMode, resolvedTheme,
        accentColor, setAccentColor,
        language, setLanguage, i18n,
        user, authToken, login, logout,
        entries, entriesLoading, fetchEntries, addEntry,
    }), [themeMode, resolvedTheme, accentColor, language, i18n, user, authToken,
        setThemeMode, setAccentColor, setLanguage, login, logout,
        entries, entriesLoading, fetchEntries, addEntry]);

    if (!ready) return null; // avoid flash of wrong theme

    return (
        <AppContext.Provider value={value}>
            {children}
        </AppContext.Provider>
    );
}

export const useAppContext = () => useContext(AppContext);
