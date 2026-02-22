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

const API_URL = 'http://127.0.0.1:8000/api';

// ─── Section Header ─────────────────────────────────────────────────────────
function SectionHeader({ label }: { label: string }) {
    const { resolvedTheme } = useAppContext();
    return (
        <ThemedText style={[styles.sectionHeader, { color: Colors[resolvedTheme].icon }]}>
            {label}
        </ThemedText>
    );
}

// ─── Settings Row ────────────────────────────────────────────────────────────
function SettingsRow({ icon, label, right, onPress }: {
    icon: string; label: string; right?: React.ReactNode; onPress?: () => void
}) {
    const { resolvedTheme } = useAppContext();
    const bg = Colors[resolvedTheme];
    return (
        <TouchableOpacity
            style={[styles.row, { backgroundColor: bg.cardBackground }]}
            onPress={onPress}
            activeOpacity={onPress ? 0.7 : 1}
        >
            <IconSymbol name={icon as any} size={18} color={bg.tint} style={styles.rowIcon} />
            <ThemedText style={[styles.rowLabel, { color: bg.text }]}>{label}</ThemedText>
            <View style={styles.rowRight}>{right}</View>
        </TouchableOpacity>
    );
}

// ─── Login / Register Panel ───────────────────────────────────────────────────
function LoginPanel({ onClose }: { onClose: () => void }) {
    const { resolvedTheme, login, accentColor } = useAppContext();
    const bg = Colors[resolvedTheme];
    const [isRegister, setIsRegister] = useState(false);
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const [loading, setLoading] = useState(false);

    const handleSubmit = async () => {
        if (!username.trim() || !password.trim()) {
            Alert.alert('提示', '请输入用户名和密码');
            return;
        }
        try {
            setLoading(true);
            const endpoint = isRegister ? '/auth/register' : '/auth/login';
            const res = await axios.post(`${API_URL}${endpoint}`, { username, password });
            await login(res.data.user, res.data.access_token);
            Alert.alert('成功', isRegister ? '注册成功！' : `欢迎回来，${res.data.user.username}！`);
            onClose();
        } catch (e: any) {
            Alert.alert('错误', e?.response?.data?.detail ?? '操作失败，请重试');
        } finally {
            setLoading(false);
        }
    };

    return (
        <View style={[styles.loginPanel, { backgroundColor: bg.cardBackground }]}>
            <ThemedText style={[styles.loginTitle, { color: bg.text }]}>
                {isRegister ? '注册账号' : '登录'}
            </ThemedText>

            <TextInput
                style={[styles.input, { color: bg.text, borderColor: bg.icon + '55', backgroundColor: bg.background }]}
                placeholder="用户名"
                placeholderTextColor={bg.icon}
                value={username}
                onChangeText={setUsername}
                autoCapitalize="none"
            />
            <TextInput
                style={[styles.input, { color: bg.text, borderColor: bg.icon + '55', backgroundColor: bg.background }]}
                placeholder="密码"
                placeholderTextColor={bg.icon}
                value={password}
                onChangeText={setPassword}
                secureTextEntry
            />

            <TouchableOpacity
                style={[styles.loginButton, { backgroundColor: accentColor }]}
                onPress={handleSubmit}
                disabled={loading}
                activeOpacity={0.8}
            >
                {loading
                    ? <ActivityIndicator color="#000" />
                    : <ThemedText style={styles.loginButtonText}>{isRegister ? '注册' : '登录'}</ThemedText>
                }
            </TouchableOpacity>

            <TouchableOpacity onPress={() => setIsRegister(!isRegister)} style={styles.switchMode}>
                <ThemedText style={{ color: bg.icon, fontSize: 13 }}>
                    {isRegister ? '已有账号？去登录' : '没有账号？立即注册'}
                </ThemedText>
            </TouchableOpacity>

            <TouchableOpacity onPress={onClose} style={styles.cancelBtn}>
                <ThemedText style={{ color: bg.icon, fontSize: 13 }}>取消</ThemedText>
            </TouchableOpacity>
        </View>
    );
}

// ─── Main Screen ─────────────────────────────────────────────────────────────
export default function SettingsScreen() {
    const {
        resolvedTheme, themeMode, setThemeMode,
        accentColor, setAccentColor,
        language, setLanguage,
        user, logout,
    } = useAppContext();
    const bg = Colors[resolvedTheme];
    const [showLogin, setShowLogin] = useState(false);

    const themeModes: { id: ThemeMode; label: string }[] = [
        { id: 'dark', label: '深色' },
        { id: 'light', label: '浅色' },
        { id: 'system', label: '跟随系统' },
    ];

    // Account section rendering
    const renderAccount = () => {
        if (user) {
            return (
                <View style={[styles.card, { backgroundColor: bg.cardBackground }]}>
                    <View style={styles.userRow}>
                        <View style={[styles.avatar, { backgroundColor: accentColor }]}>
                            <ThemedText style={styles.avatarLetter}>
                                {user.username.charAt(0).toUpperCase()}
                            </ThemedText>
                        </View>
                        <View style={{ flex: 1 }}>
                            <ThemedText style={[styles.userName, { color: bg.text }]}>{user.username}</ThemedText>
                            {user.email ? (
                                <ThemedText style={[styles.userEmail, { color: bg.icon }]}>{user.email}</ThemedText>
                            ) : null}
                        </View>
                    </View>
                    <TouchableOpacity
                        style={[styles.logoutButton, { borderColor: '#FF3B3066' }]}
                        onPress={() => logout()}
                        activeOpacity={0.7}
                    >
                        <ThemedText style={{ color: '#FF3B30', fontSize: 14, fontWeight: '600' }}>退出登录</ThemedText>
                    </TouchableOpacity>
                </View>
            );
        }

        if (showLogin) {
            return <LoginPanel onClose={() => setShowLogin(false)} />;
        }

        return (
            <TouchableOpacity
                style={[styles.row, { backgroundColor: bg.cardBackground }]}
                onPress={() => setShowLogin(true)}
                activeOpacity={0.7}
            >
                <IconSymbol name={"person.circle" as any} size={18} color={bg.tint} style={styles.rowIcon} />
                <ThemedText style={[styles.rowLabel, { color: bg.text }]}>登录 / 注册</ThemedText>
                <View style={styles.rowRight}>
                    <IconSymbol name="chevron.right" size={16} color={bg.icon} />
                </View>
            </TouchableOpacity>
        );
    };

    return (
        <ThemedView style={[styles.container, { backgroundColor: bg.background }]}>
            <ScrollView
                contentContainerStyle={styles.scrollContent}
                showsVerticalScrollIndicator={false}
            >
                {/* ── 外观 ── */}
                <SectionHeader label="外观 APPEARANCE" />

                <View style={[styles.card, { backgroundColor: bg.cardBackground }]}>
                    <ThemedText style={[styles.cardLabel, { color: bg.icon }]}>配色方案</ThemedText>
                    <View style={styles.chipRow}>
                        {themeModes.map(({ id, label }) => (
                            <TouchableOpacity
                                key={id}
                                style={[
                                    styles.chip,
                                    { borderColor: bg.icon + '44' },
                                    themeMode === id && { backgroundColor: accentColor, borderColor: accentColor }
                                ]}
                                onPress={() => setThemeMode(id)}
                            >
                                <ThemedText style={[
                                    styles.chipText,
                                    { color: themeMode === id ? '#000' : bg.text }
                                ]}>
                                    {label}
                                </ThemedText>
                            </TouchableOpacity>
                        ))}
                    </View>
                </View>

                <View style={[styles.card, { backgroundColor: bg.cardBackground }]}>
                    <ThemedText style={[styles.cardLabel, { color: bg.icon }]}>主题色</ThemedText>
                    <View style={styles.dotsRow}>
                        {ACCENT_COLORS.map(({ id, hex }) => (
                            <TouchableOpacity
                                key={id}
                                style={[
                                    styles.dot,
                                    { backgroundColor: hex },
                                    accentColor === hex && { borderWidth: 3, borderColor: '#fff' }
                                ]}
                                onPress={() => setAccentColor(hex)}
                            >
                                {accentColor === hex && (
                                    <IconSymbol name="checkmark" size={14} color="#000" />
                                )}
                            </TouchableOpacity>
                        ))}
                    </View>
                </View>

                {/* ── 语言 ── */}
                <SectionHeader label="语言 LANGUAGE" />
                <View style={[styles.card, { backgroundColor: bg.cardBackground }]}>
                    {LANGUAGES.map(({ id, label }) => (
                        <TouchableOpacity
                            key={id}
                            style={[
                                styles.langRow,
                                { borderBottomColor: bg.icon + '22' }
                            ]}
                            onPress={() => setLanguage(id)}
                        >
                            <ThemedText style={[styles.langLabel, { color: bg.text }]}>{label}</ThemedText>
                            {language === id && (
                                <IconSymbol name="checkmark" size={16} color={accentColor} />
                            )}
                        </TouchableOpacity>
                    ))}
                </View>

                {/* ── 账号 ── */}
                <SectionHeader label="账号 ACCOUNT" />
                {renderAccount()}

                {/* ── 关于 ── */}
                <SectionHeader label="关于 ABOUT" />
                <SettingsRow icon="info.circle" label="版本 1.0.0" />

            </ScrollView>
        </ThemedView>
    );
}

const styles = StyleSheet.create({
    container: { flex: 1 },
    scrollContent: {
        paddingHorizontal: '20%',
        paddingTop: 40,
        paddingBottom: 80,
    },
    sectionHeader: {
        fontSize: 11,
        fontWeight: '700',
        letterSpacing: 1.4,
        marginBottom: 10,
        marginTop: 32,
        marginLeft: 4,
    },
    card: {
        borderRadius: 14,
        padding: 18,
        marginBottom: 10,
    },
    cardLabel: {
        fontSize: 11,
        fontWeight: '600',
        letterSpacing: 0.5,
        marginBottom: 14,
    },
    chipRow: {
        flexDirection: 'row',
        gap: 10,
    },
    chip: {
        paddingHorizontal: 18,
        paddingVertical: 9,
        borderRadius: 20,
        borderWidth: 1,
    },
    chipText: {
        fontSize: 13,
        fontWeight: '600',
    },
    dotsRow: {
        flexDirection: 'row',
        gap: 14,
        flexWrap: 'wrap',
    },
    dot: {
        width: 38,
        height: 38,
        borderRadius: 19,
        alignItems: 'center',
        justifyContent: 'center',
    },
    row: {
        flexDirection: 'row',
        alignItems: 'center',
        padding: 16,
        borderRadius: 14,
        marginBottom: 10,
    },
    rowIcon: { marginRight: 14 },
    rowLabel: { flex: 1, fontSize: 15, fontWeight: '500' },
    rowRight: { marginLeft: 8 },
    langRow: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        paddingVertical: 13,
        borderBottomWidth: StyleSheet.hairlineWidth,
    },
    langLabel: { fontSize: 15 },
    // Login panel
    loginPanel: {
        borderRadius: 16,
        padding: 24,
        marginBottom: 10,
    },
    loginTitle: {
        fontSize: 20,
        fontWeight: '700',
        marginBottom: 20,
    },
    input: {
        borderWidth: 1,
        borderRadius: 10,
        paddingVertical: 12,
        paddingHorizontal: 14,
        fontSize: 15,
        marginBottom: 12,
    },
    loginButton: {
        borderRadius: 10,
        paddingVertical: 14,
        alignItems: 'center',
        marginTop: 4,
    },
    loginButtonText: {
        color: '#000',
        fontWeight: '700',
        fontSize: 16,
    },
    switchMode: {
        marginTop: 14,
        alignItems: 'center',
    },
    cancelBtn: {
        marginTop: 8,
        alignItems: 'center',
    },
    // User card
    userRow: {
        flexDirection: 'row',
        alignItems: 'center',
        marginBottom: 18,
    },
    avatar: {
        width: 50,
        height: 50,
        borderRadius: 25,
        alignItems: 'center',
        justifyContent: 'center',
        marginRight: 14,
    },
    avatarLetter: {
        color: '#000',
        fontWeight: '700',
        fontSize: 22,
    },
    userName: { fontSize: 17, fontWeight: '600' },
    userEmail: { fontSize: 13, marginTop: 2 },
    logoutButton: {
        borderWidth: 1,
        borderRadius: 10,
        paddingVertical: 12,
        alignItems: 'center',
    },
});
