import { StyleSheet, TextInput, KeyboardAvoidingView, Platform, TouchableOpacity, Alert, Animated, View, ScrollView, ActivityIndicator } from 'react-native';
import { useState, useEffect, useRef, useMemo } from 'react';
import { useRouter } from 'expo-router';
import { format } from 'date-fns';
import { getDateLocale } from '@/constants/i18n';
import axios from 'axios';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors } from '@/constants/theme';
import { useAppContext } from '@/context/AppContext';

const API_URL = 'http://127.0.0.1:8000/api';

export default function WriteEntryScreen() {
    const [title, setTitle] = useState('');
    const [content, setContent] = useState('');
    const [saving, setSaving] = useState(false);
    const [aiPolishing, setAiPolishing] = useState(false);
    const router = useRouter();
    const { resolvedTheme, accentColor, i18n, addEntry, language } = useAppContext();
    const theme = resolvedTheme;
    const dateLocale = getDateLocale(language);

    const fadeAnim = useRef(new Animated.Value(0)).current;

    useEffect(() => {
        Animated.timing(fadeAnim, {
            toValue: 1,
            duration: 400,
            useNativeDriver: true,
        }).start();
    }, [fadeAnim]);

    const wordCount = useMemo(() => content.trim().length, [content]);
    const now = useMemo(() => new Date(), []);
    const dateStr = useMemo(() => format(now, 'MM月dd日 HH:mm', { locale: dateLocale }), [now, dateLocale]);

    const handleSave = async () => {
        if (!content.trim()) {
            Alert.alert(i18n.hint, i18n.enterCredentials);
            return;
        }
        addEntry(title.trim() || null, content.trim());
        setTitle('');
        setContent('');
        router.back();
    };

    const handleAIPolish = async () => {
        if (!content.trim()) {
            Alert.alert(i18n.hint, i18n.enterCredentials);
            return;
        }
        try {
            setAiPolishing(true);
            const response = await axios.post(`${API_URL}/ai/polish`, { content });
            let newContent = response.data.polished_text;
            if (response.data.tags && response.data.tags.length > 0) {
                newContent += '\n\n🏷️ ' + response.data.tags.join(', ');
            }
            setContent(newContent);
        } catch (error) {
            console.error('AI Polish Failed:', error);
        } finally {
            setAiPolishing(false);
        }
    };

    const c = Colors[theme];
    const mutedColor = c.icon;

    return (
        <ThemedView style={[styles.container, { backgroundColor: c.background }]}>
            {/* ── Top Bar ── */}
            <View style={[styles.topBar, { borderBottomColor: theme === 'dark' ? '#1A1C1E' : '#E8E8EA' }]}>
                <TouchableOpacity onPress={() => router.back()} style={styles.backBtn} activeOpacity={0.7}>
                    <IconSymbol name="caret-left" size={22} color={c.text} />
                </TouchableOpacity>

                <View style={styles.topBarCenter}>
                    <ThemedText style={[styles.dateLabel, { color: c.text }]}>{dateStr}</ThemedText>
                    <TouchableOpacity
                        style={styles.categoryBtn}
                        activeOpacity={0.7}
                        onPress={() => Alert.alert(i18n.hint, 'Category selection coming soon!')}
                    >
                        <IconSymbol name="bookmark" size={16} color={mutedColor} />
                        <ThemedText style={[styles.categoryText, { color: mutedColor }]}>{i18n.setCategory}</ThemedText>
                    </TouchableOpacity>
                    {aiPolishing && <ActivityIndicator size="small" color={accentColor} style={{ marginLeft: 10 }} />}
                </View>

                <TouchableOpacity
                    style={[styles.saveCircle, { backgroundColor: accentColor }]}
                    onPress={handleSave}
                    disabled={saving || aiPolishing}
                    activeOpacity={0.8}
                >
                    <IconSymbol name="check" size={20} color="#000" weight="bold" />
                </TouchableOpacity>
            </View>

            {/* ── Content Area ── */}
            <Animated.View style={[styles.editorArea, { opacity: fadeAnim }]}>
                <ScrollView
                    style={styles.scrollContent}
                    contentContainerStyle={styles.scrollInner}
                    keyboardDismissMode="interactive"
                    showsVerticalScrollIndicator={false}
                >
                    <TextInput
                        style={[styles.titleInput, { color: c.text, outlineStyle: 'none' } as any]}
                        placeholder={i18n.titlePlaceholder}
                        placeholderTextColor={mutedColor + '88'}
                        value={title}
                        onChangeText={setTitle}
                        textAlign="center"
                    />

                    <TextInput
                        style={[styles.contentInput, { color: c.text, outlineStyle: 'none' } as any]}
                        placeholder={i18n.contentPlaceholder}
                        placeholderTextColor={mutedColor + '66'}
                        multiline
                        textAlignVertical="top"
                        value={content}
                        onChangeText={setContent}
                        autoFocus={true}
                    />

                    {/* ── Image Upload placeholder ── */}
                    <TouchableOpacity
                        style={[styles.imageUpload, { backgroundColor: theme === 'dark' ? '#2A2C30' : '#F0F0F2' }]}
                        activeOpacity={0.7}
                        onPress={() => Alert.alert(i18n.hint, 'Image upload coming soon!')}
                    >
                        <IconSymbol name="plus" size={24} color={mutedColor} />
                    </TouchableOpacity>
                </ScrollView>
            </Animated.View>

            {/* ── Metadata Row ── */}
            <View style={[styles.metaArea, { borderTopColor: theme === 'dark' ? '#1A1C1E' : '#E8E8EA' }]}>
                <TouchableOpacity
                    style={styles.metaRow}
                    activeOpacity={0.7}
                    onPress={() => Alert.alert(i18n.hint, 'Weather selection coming soon!')}
                >
                    <IconSymbol name="sun" size={18} color={mutedColor} />
                    <ThemedText style={[styles.metaText, { color: mutedColor }]}>{i18n.selectWeather}</ThemedText>
                </TouchableOpacity>
                <TouchableOpacity
                    style={styles.metaRow}
                    activeOpacity={0.7}
                    onPress={() => Alert.alert(i18n.hint, 'Location setting coming soon!')}
                >
                    <IconSymbol name="map-pin" size={18} color={mutedColor} />
                    <ThemedText style={[styles.metaText, { color: mutedColor }]}>{i18n.setLocation}</ThemedText>
                </TouchableOpacity>
                <View style={styles.metaRow}>
                    <IconSymbol name="text-aa" size={18} color={mutedColor} />
                    <ThemedText style={[styles.metaText, { color: mutedColor }]}>{wordCount} {i18n.wordCount}</ThemedText>
                </View>
            </View>

            {/* ── Bottom Toolbar ── */}
            <View style={[styles.toolbar, { backgroundColor: theme === 'dark' ? '#1A1C1E' : '#F5F5F7' }]}>
                <TouchableOpacity style={styles.toolBtn} onPress={handleAIPolish} disabled={aiPolishing} activeOpacity={0.7}>
                    <IconSymbol name="sparkle" size={20} color={aiPolishing ? accentColor : mutedColor} />
                </TouchableOpacity>
                <View style={[styles.toolDivider, { backgroundColor: mutedColor + '33' }]} />
                <TouchableOpacity style={styles.toolBtn} activeOpacity={0.7} onPress={() => Alert.alert(i18n.hint, 'Hashtags feature coming soon!')}>
                    <IconSymbol name="hash" size={20} color={mutedColor} />
                </TouchableOpacity>
                <TouchableOpacity style={styles.toolBtn} activeOpacity={0.7} onPress={() => Alert.alert(i18n.hint, 'List feature coming soon!')}>
                    <IconSymbol name="list-bullets" size={20} color={mutedColor} />
                </TouchableOpacity>
                <TouchableOpacity style={styles.toolBtn} activeOpacity={0.7} onPress={() => Alert.alert(i18n.hint, 'Tasks feature coming soon!')}>
                    <IconSymbol name="check-square" size={20} color={mutedColor} />
                </TouchableOpacity>
                <TouchableOpacity style={styles.toolBtn} activeOpacity={0.7} onPress={() => Alert.alert(i18n.hint, 'Time insertion coming soon!')}>
                    <IconSymbol name="clock" size={20} color={mutedColor} />
                </TouchableOpacity>
                <TouchableOpacity style={styles.toolBtn} activeOpacity={0.7} onPress={() => Alert.alert(i18n.hint, 'Calendar link coming soon!')}>
                    <IconSymbol name="calendar" size={20} color={mutedColor} />
                </TouchableOpacity>
            </View>
        </ThemedView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    // ── Top Bar ──
    topBar: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingHorizontal: 16,
        paddingTop: Platform.OS === 'web' ? 16 : 56,
        paddingBottom: 12,
        borderBottomWidth: StyleSheet.hairlineWidth,
    },
    backBtn: {
        width: 36,
        height: 36,
        alignItems: 'center',
        justifyContent: 'center',
    },
    topBarCenter: {
        flex: 1,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        gap: 12,
    },
    dateLabel: {
        fontSize: 15,
        fontWeight: '600',
    },
    categoryBtn: {
        flexDirection: 'row',
        alignItems: 'center',
        gap: 4,
    },
    categoryText: {
        fontSize: 13,
        fontWeight: '500',
    },
    saveCircle: {
        width: 40,
        height: 40,
        borderRadius: 20,
        alignItems: 'center',
        justifyContent: 'center',
    },
    // ── Editor ──
    editorArea: {
        flex: 1,
    },
    scrollContent: {
        flex: 1,
    },
    scrollInner: {
        paddingHorizontal: '15%',
        paddingTop: 40,
        paddingBottom: 60,
    },
    titleInput: {
        fontSize: 22,
        fontWeight: '300',
        marginBottom: 32,
        textAlign: 'center',
        opacity: 0.9,
    },
    contentInput: {
        fontSize: 17,
        lineHeight: 30,
        fontWeight: '300',
        minHeight: 300,
    },
    imageUpload: {
        width: 120,
        height: 100,
        borderRadius: 10,
        alignItems: 'center',
        justifyContent: 'center',
        marginTop: 40,
    },
    // ── Metadata ──
    metaArea: {
        paddingHorizontal: '15%',
        paddingVertical: 12,
        borderTopWidth: StyleSheet.hairlineWidth,
        gap: 10,
    },
    metaRow: {
        flexDirection: 'row',
        alignItems: 'center',
        gap: 10,
    },
    metaText: {
        fontSize: 13,
        fontWeight: '500',
    },
    // ── Toolbar ──
    toolbar: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        paddingVertical: 12,
        paddingHorizontal: 20,
        gap: 6,
    },
    toolBtn: {
        width: 40,
        height: 36,
        alignItems: 'center',
        justifyContent: 'center',
        borderRadius: 8,
    },
    toolDivider: {
        width: 1,
        height: 20,
        marginHorizontal: 4,
    },
});
