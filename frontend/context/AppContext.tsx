import React, { createContext, useContext, useState, useEffect, useCallback } from 'react';
import { Platform, Appearance } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';

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
    resolvedTheme: 'light' | 'dark'; // the actual computed theme
    accentColor: string;
    setAccentColor: (c: string) => void;
    language: string;
    setLanguage: (l: string) => void;
    user: User | null;
    authToken: string | null;
    login: (user: User, token: string) => void;
    logout: () => void;
}

const AppContext = createContext<AppContextType>({
    themeMode: 'dark',
    setThemeMode: () => { },
    resolvedTheme: 'dark',
    accentColor: '#02BFB8',
    setAccentColor: () => { },
    language: 'zh',
    setLanguage: () => { },
    user: null,
    authToken: null,
    login: () => { },
    logout: () => { },
});

export function AppProvider({ children }: { children: React.ReactNode }) {
    const [themeMode, _setThemeMode] = useState<ThemeMode>('dark');
    const [accentColor, _setAccentColor] = useState('#02BFB8');
    const [language, _setLanguage] = useState('zh');
    const [user, setUser] = useState<User | null>(null);
    const [authToken, setAuthToken] = useState<string | null>(null);
    const [systemScheme, setSystemScheme] = useState<'light' | 'dark'>(
        Appearance.getColorScheme() === 'light' ? 'light' : 'dark'
    );

    // Load persisted prefs on mount
    useEffect(() => {
        (async () => {
            try {
                const [t, a, l, tok, u] = await Promise.all([
                    AsyncStorage.getItem(STORAGE_KEYS.THEME),
                    AsyncStorage.getItem(STORAGE_KEYS.ACCENT),
                    AsyncStorage.getItem(STORAGE_KEYS.LANGUAGE),
                    AsyncStorage.getItem(STORAGE_KEYS.TOKEN),
                    AsyncStorage.getItem(STORAGE_KEYS.USER),
                ]);
                if (t) _setThemeMode(t as ThemeMode);
                if (a) _setAccentColor(a);
                if (l) _setLanguage(l);
                if (tok) setAuthToken(tok);
                if (u) setUser(JSON.parse(u));
            } catch (_) { }
        })();

        // Listen to system color scheme changes
        const sub = Appearance.addChangeListener(({ colorScheme }) => {
            setSystemScheme(colorScheme === 'light' ? 'light' : 'dark');
        });
        return () => sub.remove();
    }, []);

    const resolvedTheme: 'light' | 'dark' =
        themeMode === 'system' ? systemScheme : themeMode;

    const setThemeMode = useCallback(async (t: ThemeMode) => {
        _setThemeMode(t);
        await AsyncStorage.setItem(STORAGE_KEYS.THEME, t);
    }, []);

    const setAccentColor = useCallback(async (c: string) => {
        _setAccentColor(c);
        await AsyncStorage.setItem(STORAGE_KEYS.ACCENT, c);
    }, []);

    const setLanguage = useCallback(async (l: string) => {
        _setLanguage(l);
        await AsyncStorage.setItem(STORAGE_KEYS.LANGUAGE, l);
    }, []);

    const login = useCallback(async (u: User, token: string) => {
        setUser(u);
        setAuthToken(token);
        await AsyncStorage.setItem(STORAGE_KEYS.TOKEN, token);
        await AsyncStorage.setItem(STORAGE_KEYS.USER, JSON.stringify(u));
    }, []);

    const logout = useCallback(async () => {
        setUser(null);
        setAuthToken(null);
        await AsyncStorage.removeItem(STORAGE_KEYS.TOKEN);
        await AsyncStorage.removeItem(STORAGE_KEYS.USER);
    }, []);

    return (
        <AppContext.Provider value={{
            themeMode, setThemeMode, resolvedTheme,
            accentColor, setAccentColor,
            language, setLanguage,
            user, authToken, login, logout,
        }}>
            {children}
        </AppContext.Provider>
    );
}

export const useAppContext = () => useContext(AppContext);
