import React, { useState } from 'react';
import {
    StyleSheet, View, ScrollView, TouchableOpacity,
    TextInput, Alert, ActivityIndicator,
} from 'react-native';
import axios from 'axios';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors } from '@/constants/theme';
import { useAppContext, ACCENT_COLORS, LANGUAGES, ThemeMode } from '@/context/AppContext';
import { CONFIG } from '@/constants/config';

const API_URL = CONFIG.API_URL;

// ─── Section ─────────────────────────────────────────────────────────────────
function Section({ label }: { label: string }) {
    const { resolvedTheme } = useAppContext();
    return (
        <ThemedText style={[styles.sectionHeader, { color: Colors[resolvedTheme].icon }]}>
            {label}
        </ThemedText>
    );
}

// ─── Login Panel ─────────────────────────────────────────────────────────────
function LoginPanel({ onClose }: { onClose: () => void }) {
    const { resolvedTheme, login, accentColor, i18n, fetchEntries } = useAppContext();
    const c = Colors[resolvedTheme];
    const [isRegister, setIsRegister] = useState(false);
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const [loading, setLoading] = useState(false);

    const handleSubmit = async () => {
        if (!username.trim() || !password.trim()) {
            Alert.alert(i18n.hint, i18n.enterCredentials);
            return;
        }
        try {
            setLoading(true);
            const endpoint = isRegister ? '/auth/register' : '/auth/login';
            const res = await axios.post(`${API_URL}${endpoint}`, { username, password });
            await login(res.data.user, res.data.access_token);
            await fetchEntries();
            Alert.alert(i18n.success, isRegister ? i18n.registerSuccess : `${i18n.welcomeBack}, ${res.data.user.username}!`);
            onClose();
        } catch (e: any) {
            Alert.alert(i18n.error, e?.response?.data?.detail ?? i18n.authFailed);
        } finally {
            setLoading(false);
        }
    };

    return (
        <View style={[styles.loginPanel, { backgroundColor: c.cardBackground }]}>
            <ThemedText style={[styles.loginTitle, { color: c.text }]}>
                {isRegister ? i18n.registerAccount : i18n.login}
            </ThemedText>

            <TextInput
                style={[styles.input, { color: c.text, borderColor: c.icon + '55', backgroundColor: c.background }]}
                placeholder={i18n.username}
                placeholderTextColor={c.icon}
                value={username}
                onChangeText={setUsername}
                autoCapitalize="none"
            />
            <TextInput
                style={[styles.input, { color: c.text, borderColor: c.icon + '55', backgroundColor: c.background }]}
                placeholder={i18n.password}
                placeholderTextColor={c.icon}
                value={password}
                onChangeText={setPassword}
                secureTextEntry
            />

            <TouchableOpacity
                style={[styles.loginBtn, { backgroundColor: accentColor }]}
                onPress={handleSubmit}
                disabled={loading}
                activeOpacity={0.8}
            >
                {loading
                    ? <ActivityIndicator color="#000" />
                    : <ThemedText style={styles.loginBtnText}>{isRegister ? i18n.register : i18n.login}</ThemedText>
                }
            </TouchableOpacity>

            <TouchableOpacity onPress={() => setIsRegister(!isRegister)} style={styles.switchMode}>
                <ThemedText style={{ color: c.icon, fontSize: 13 }}>
                    {isRegister ? i18n.hasAccount : i18n.noAccount}
                </ThemedText>
            </TouchableOpacity>
            <TouchableOpacity onPress={onClose} style={styles.switchMode}>
                <ThemedText style={{ color: c.icon, fontSize: 13 }}>{i18n.cancel}</ThemedText>
            </TouchableOpacity>
        </View>
    );
}

// ─── Main ────────────────────────────────────────────────────────────────────
export default function SettingsScreen() {
    const {
        resolvedTheme, themeMode, setThemeMode,
        accentColor, setAccentColor,
        language, setLanguage,
        user, logout, i18n,
    } = useAppContext();
    const c = Colors[resolvedTheme];
    const [showLogin, setShowLogin] = useState(false);

    const themeModes: { id: ThemeMode; label: string }[] = [
        { id: 'dark', label: i18n.dark },
        { id: 'light', label: i18n.light },
        { id: 'system', label: i18n.followSystem },
    ];

    const renderAccount = () => {
        if (user) {
            return (
                <View style={[styles.card, { backgroundColor: c.cardBackground }]}>
                    <View style={styles.userRow}>
                        <View style={[styles.avatar, { backgroundColor: accentColor }]}>
                            <ThemedText style={styles.avatarLetter}>
                                {user.username.charAt(0).toUpperCase()}
                            </ThemedText>
                        </View>
                        <View style={{ flex: 1 }}>
                            <ThemedText style={[styles.userName, { color: c.text }]}>{user.username}</ThemedText>
                            {user.email ? (
                                <ThemedText style={[styles.userEmail, { color: c.icon }]}>{user.email}</ThemedText>
                            ) : null}
                        </View>
                    </View>
                    <TouchableOpacity
                        style={[styles.logoutBtn, { borderColor: '#FF3B3066' }]}
                        onPress={() => logout()}
                        activeOpacity={0.7}
                    >
                        <ThemedText style={{ color: '#FF3B30', fontSize: 14, fontWeight: '600' }}>{i18n.logout}</ThemedText>
                    </TouchableOpacity>
                </View>
            );
        }
        if (showLogin) {
            return <LoginPanel onClose={() => setShowLogin(false)} />;
        }
        return (
            <TouchableOpacity
                style={[styles.row, { backgroundColor: c.cardBackground }]}
                onPress={() => setShowLogin(true)}
                activeOpacity={0.7}
            >
                <IconSymbol name="user" size={18} color={accentColor} style={styles.rowIcon} />
                <ThemedText style={[styles.rowLabel, { color: c.text }]}>{i18n.loginRegister}</ThemedText>
                <IconSymbol name="caret-right" size={16} color={c.icon} />
            </TouchableOpacity>
        );
    };

    return (
        <ThemedView style={[styles.container, { backgroundColor: c.background }]}>
            <ScrollView contentContainerStyle={styles.scrollContent} showsVerticalScrollIndicator={false}>
                {/* Appearance */}
                <Section label={i18n.appearance} />
                <View style={[styles.card, { backgroundColor: c.cardBackground }]}>
                    <ThemedText style={[styles.cardLabel, { color: c.icon }]}>{i18n.colorScheme}</ThemedText>
                    <View style={styles.chipRow}>
                        {themeModes.map(({ id, label }) => (
                            <TouchableOpacity
                                key={id}
                                style={[
                                    styles.chip,
                                    { borderColor: c.icon + '44' },
                                    themeMode === id && { backgroundColor: accentColor, borderColor: accentColor }
                                ]}
                                onPress={() => setThemeMode(id)}
                            >
                                <ThemedText style={[styles.chipText, { color: themeMode === id ? '#000' : c.text }]}>
                                    {label}
                                </ThemedText>
                            </TouchableOpacity>
                        ))}
                    </View>
                </View>
                <View style={[styles.card, { backgroundColor: c.cardBackground }]}>
                    <ThemedText style={[styles.cardLabel, { color: c.icon }]}>{i18n.themeColor}</ThemedText>
                    <View style={styles.dotsRow}>
                        {ACCENT_COLORS.map(({ id, hex }) => (
                            <TouchableOpacity
                                key={id}
                                style={[styles.dot, { backgroundColor: hex }, accentColor === hex && { borderWidth: 3, borderColor: '#fff' }]}
                                onPress={() => setAccentColor(hex)}
                            >
                                {accentColor === hex && <IconSymbol name="check" size={14} color="#000" />}
                            </TouchableOpacity>
                        ))}
                    </View>
                </View>

                {/* Language */}
                <Section label={i18n.language} />
                <View style={[styles.card, { backgroundColor: c.cardBackground }]}>
                    {LANGUAGES.map(({ id, label }) => (
                        <TouchableOpacity
                            key={id}
                            style={[styles.langRow, { borderBottomColor: c.icon + '22' }]}
                            onPress={() => setLanguage(id)}
                        >
                            <ThemedText style={[styles.langLabel, { color: c.text }]}>{label}</ThemedText>
                            {language === id && <IconSymbol name="check" size={16} color={accentColor} />}
                        </TouchableOpacity>
                    ))}
                </View>

                {/* Account */}
                <Section label={i18n.account} />
                {renderAccount()}

                {/* About */}
                <Section label={i18n.about} />
                <View style={[styles.row, { backgroundColor: c.cardBackground }]}>
                    <IconSymbol name="info" size={18} color={accentColor} style={styles.rowIcon} />
                    <ThemedText style={[styles.rowLabel, { color: c.text }]}>{i18n.version} 1.0.0</ThemedText>
                </View>
            </ScrollView>
        </ThemedView>
    );
}

const styles = StyleSheet.create({
    container: { flex: 1 },
    scrollContent: { paddingHorizontal: 40, paddingTop: 40, paddingBottom: 80 },
    sectionHeader: { fontSize: 11, fontWeight: '700', letterSpacing: 1.4, marginBottom: 10, marginTop: 32, marginLeft: 4 },
    card: { borderRadius: 14, padding: 18, marginBottom: 10 },
    cardLabel: { fontSize: 11, fontWeight: '600', letterSpacing: 0.5, marginBottom: 14 },
    chipRow: { flexDirection: 'row', gap: 10 },
    chip: { paddingHorizontal: 18, paddingVertical: 9, borderRadius: 20, borderWidth: 1 },
    chipText: { fontSize: 13, fontWeight: '600' },
    dotsRow: { flexDirection: 'row', gap: 14, flexWrap: 'wrap' },
    dot: { width: 38, height: 38, borderRadius: 19, alignItems: 'center', justifyContent: 'center' },
    row: { flexDirection: 'row', alignItems: 'center', padding: 16, borderRadius: 14, marginBottom: 10 },
    rowIcon: { marginRight: 14 },
    rowLabel: { flex: 1, fontSize: 15, fontWeight: '500' },
    langRow: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', paddingVertical: 13, borderBottomWidth: StyleSheet.hairlineWidth },
    langLabel: { fontSize: 15 },
    loginPanel: { borderRadius: 16, padding: 24, marginBottom: 10 },
    loginTitle: { fontSize: 20, fontWeight: '700', marginBottom: 20 },
    input: { borderWidth: 1, borderRadius: 10, paddingVertical: 12, paddingHorizontal: 14, fontSize: 15, marginBottom: 12 },
    loginBtn: { borderRadius: 10, paddingVertical: 14, alignItems: 'center', marginTop: 4 },
    loginBtnText: { color: '#000', fontWeight: '700', fontSize: 16 },
    switchMode: { marginTop: 12, alignItems: 'center' },
    userRow: { flexDirection: 'row', alignItems: 'center', marginBottom: 18 },
    avatar: { width: 50, height: 50, borderRadius: 25, alignItems: 'center', justifyContent: 'center', marginRight: 14 },
    avatarLetter: { color: '#000', fontWeight: '700', fontSize: 22 },
    userName: { fontSize: 17, fontWeight: '600' },
    userEmail: { fontSize: 13, marginTop: 2 },
    logoutBtn: { borderWidth: 1, borderRadius: 10, paddingVertical: 12, alignItems: 'center' },
});
