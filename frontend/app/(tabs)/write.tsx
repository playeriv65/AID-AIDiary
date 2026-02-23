import { StyleSheet, TextInput, Platform, TouchableOpacity, Alert, Animated, View, ScrollView, ActivityIndicator } from 'react-native';
import { useState, useEffect, useRef, useMemo } from 'react';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { format, parseISO } from 'date-fns';
import { getDateLocale } from '@/constants/i18n';
import axios from 'axios';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors, FontSizes, FontWeights } from '@/constants/theme';
import { CONFIG } from '@/constants/config';
import { useAppContext } from '@/context/AppContext';
import { Picker } from '@/components/picker';

const API_URL = CONFIG.API_URL;

const CATEGORIES = [
    { value: 'work', label: 'catWork', icon: 'briefcase' },
    { value: 'life', label: 'catLife', icon: 'heart' },
    { value: 'study', label: 'catStudy', icon: 'book-open' },
    { value: 'travel', label: 'catTravel', icon: 'airplane' },
    { value: 'health', label: 'catHealth', icon: 'heartbeat' },
    { value: 'other', label: 'catOther', icon: 'folder' },
];

const WEATHERS = [
    { value: 'sunny', label: 'weatherSunny', icon: 'sun' },
    { value: 'cloudy', label: 'weatherCloudy', icon: 'cloud' },
    { value: 'rainy', label: 'weatherRainy', icon: 'cloud-rain' },
    { value: 'snowy', label: 'weatherSnowy', icon: 'snowflake' },
    { value: 'windy', label: 'weatherWindy', icon: 'wind' },
    { value: 'foggy', label: 'weatherFoggy', icon: 'fog' },
];

export default function WriteEntryScreen() {
    const params = useLocalSearchParams<{ 
        id?: string; 
        title?: string; 
        content?: string; 
        created_at?: string;
        category?: string;
        weather?: string;
        location?: string;
    }>();
    const isEditing = !!params.id;
    const entryId = params.id ? parseInt(params.id) : null;

    const [title, setTitle] = useState(params.title || '');
    const [content, setContent] = useState(params.content || '');
    const [category, setCategory] = useState<string | null>(params.category || null);
    const [weather, setWeather] = useState<string | null>(params.weather || null);
    const [location, setLocation] = useState(params.location || '');
    const [tags, setTags] = useState<string[]>([]);
    const [saving, setSaving] = useState(false);
    const [aiPolishing, setAiPolishing] = useState(false);
    const [showLocationInput, setShowLocationInput] = useState(false);
    const [showTagInput, setShowTagInput] = useState(false);
    const [newTag, setNewTag] = useState('');
    
    const router = useRouter();
    const { resolvedTheme, accentColor, i18n, addEntry, language, fetchEntries } = useAppContext();
    const theme = resolvedTheme;
    const dateLocale = getDateLocale(language);

    const fadeAnim = useRef(new Animated.Value(0)).current;

    const entryDate = useMemo(() => {
        if (params.created_at) {
            return parseISO(params.created_at);
        }
        return new Date();
    }, [params.created_at]);

    useEffect(() => {
        Animated.timing(fadeAnim, {
            toValue: 1,
            duration: 400,
            useNativeDriver: true,
        }).start();
    }, [fadeAnim]);

    const wordCount = useMemo(() => content.trim().length, [content]);
    const dateStr = useMemo(() => format(entryDate, 'MM月dd日 HH:mm', { locale: dateLocale }), [entryDate, dateLocale]);

    const categoryOptions = CATEGORIES.map(c => ({ ...c, label: i18n[c.label as keyof typeof i18n] as string }));
    const weatherOptions = WEATHERS.map(w => ({ ...w, label: i18n[w.label as keyof typeof i18n] as string }));

    const handleSave = async () => {
        if (!content.trim()) {
            Alert.alert(i18n.hint, i18n.enterCredentials);
            return;
        }
        setSaving(true);
        try {
            if (isEditing && entryId) {
                await axios.put(`${API_URL}/entries/${entryId}`, {
                    title: title.trim() || null,
                    content: content.trim(),
                    category,
                    weather,
                    location: location.trim() || null,
                    tags: tags.length > 0 ? tags : null,
                });
                await fetchEntries();
            } else {
                await addEntry(title.trim() || null, content.trim());
            }
            setTitle('');
            setContent('');
            router.back();
        } catch (error) {
            console.error('Save failed:', error);
            Alert.alert(i18n.error, 'Failed to save entry');
        } finally {
            setSaving(false);
        }
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

    const insertTemplate = (type: 'list' | 'task' | 'time') => {
        const now = new Date();
        const timeStr = format(now, 'HH:mm');
        let insert = '';
        switch (type) {
            case 'list':
                insert = '\n• \n• \n• ';
                break;
            case 'task':
                insert = '\n☐ \n☐ \n☐ ';
                break;
            case 'time':
                insert = ` [${timeStr}] `;
                break;
        }
        setContent(prev => prev + insert);
    };

    const addTag = () => {
        const trimmed = newTag.trim();
        if (trimmed && !tags.includes(trimmed)) {
            setTags(prev => [...prev, trimmed]);
        }
        setNewTag('');
        setShowTagInput(false);
    };

    const removeTag = (tag: string) => {
        setTags(prev => prev.filter(t => t !== tag));
    };

    const c = Colors[theme];
    const mutedColor = c.icon;

    return (
        <ThemedView style={[styles.container, { backgroundColor: c.background }]}>
            <View style={[styles.topBar, { borderBottomColor: theme === 'dark' ? '#1A1C1E' : '#E8E8EA' }]}>
                <TouchableOpacity onPress={() => router.back()} style={styles.backBtn} activeOpacity={0.7}>
                    <IconSymbol name="caret-left" size={22} color={c.text} />
                </TouchableOpacity>

                <View style={styles.topBarCenter}>
                    <ThemedText style={[styles.dateLabel, { color: c.text }]}>{dateStr}</ThemedText>
                    <Picker
                        options={categoryOptions}
                        value={category}
                        onChange={setCategory}
                        placeholder={i18n.setCategory}
                        theme={theme}
                        accentColor={accentColor}
                    />
                    {aiPolishing && <ActivityIndicator size="small" color={accentColor} style={{ marginLeft: 10 }} />}
                </View>

                <TouchableOpacity
                    style={[styles.saveCircle, { backgroundColor: saving ? Colors[theme].icon : accentColor }]}
                    onPress={handleSave}
                    disabled={saving || aiPolishing}
                    activeOpacity={0.8}
                >
                    {saving ? (
                        <ActivityIndicator size="small" color="#000" />
                    ) : (
                        <IconSymbol name="check" size={20} color="#000" weight="bold" />
                    )}
                </TouchableOpacity>
            </View>

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
                        autoFocus={!isEditing}
                    />

                    <TouchableOpacity
                        style={[styles.imageUpload, { backgroundColor: theme === 'dark' ? '#2A2C30' : '#F0F0F2' }]}
                        activeOpacity={0.7}
                        onPress={() => Alert.alert(i18n.hint, 'Image upload coming soon!')}
                    >
                        <IconSymbol name="plus" size={24} color={mutedColor} />
                    </TouchableOpacity>
                </ScrollView>
            </Animated.View>

            <View style={[styles.metaArea, { borderTopColor: theme === 'dark' ? '#1A1C1E' : '#E8E8EA' }]}>
                <View style={styles.metaRow}>
                    <Picker
                        options={weatherOptions}
                        value={weather}
                        onChange={setWeather}
                        placeholder={i18n.selectWeather}
                        theme={theme}
                        accentColor={accentColor}
                    />
                </View>
                <View style={styles.metaRow}>
                    {showLocationInput ? (
                        <TextInput
                            style={[styles.locationInput, { color: c.text, borderColor: mutedColor + '40' }]}
                            placeholder={i18n.setLocation}
                            placeholderTextColor={mutedColor}
                            value={location}
                            onChangeText={setLocation}
                            onBlur={() => !location && setShowLocationInput(false)}
                            autoFocus
                        />
                    ) : (
                        <TouchableOpacity
                            style={{ flexDirection: 'row', alignItems: 'center', gap: 10 }}
                            onPress={() => setShowLocationInput(true)}
                            activeOpacity={0.7}
                        >
                            <IconSymbol name="map-pin" size={18} color={location ? accentColor : mutedColor} />
                            <ThemedText style={[styles.metaText, { color: location ? accentColor : mutedColor }]}>
                                {location || i18n.setLocation}
                            </ThemedText>
                        </TouchableOpacity>
                    )}
                </View>
                <View style={styles.metaRow}>
                    <IconSymbol name="text-aa" size={18} color={mutedColor} />
                    <ThemedText style={[styles.metaText, { color: mutedColor }]}>{wordCount} {i18n.wordCount}</ThemedText>
                </View>
            </View>

            <View style={[styles.toolbar, { backgroundColor: theme === 'dark' ? '#1A1C1E' : '#F5F5F7' }]}>
                <TouchableOpacity style={styles.toolBtn} onPress={handleAIPolish} disabled={aiPolishing} activeOpacity={0.7}>
                    <IconSymbol name="sparkle" size={20} color={aiPolishing ? accentColor : mutedColor} />
                </TouchableOpacity>
                <View style={[styles.toolDivider, { backgroundColor: mutedColor + '33' }]} />
                <TouchableOpacity style={styles.toolBtn} activeOpacity={0.7} onPress={() => setShowTagInput(true)}>
                    <IconSymbol name="hash" size={20} color={tags.length > 0 ? accentColor : mutedColor} />
                </TouchableOpacity>
                <TouchableOpacity style={styles.toolBtn} activeOpacity={0.7} onPress={() => insertTemplate('list')}>
                    <IconSymbol name="list-bullets" size={20} color={mutedColor} />
                </TouchableOpacity>
                <TouchableOpacity style={styles.toolBtn} activeOpacity={0.7} onPress={() => insertTemplate('task')}>
                    <IconSymbol name="check-square" size={20} color={mutedColor} />
                </TouchableOpacity>
                <TouchableOpacity style={styles.toolBtn} activeOpacity={0.7} onPress={() => insertTemplate('time')}>
                    <IconSymbol name="clock" size={20} color={mutedColor} />
                </TouchableOpacity>
                <TouchableOpacity style={styles.toolBtn} activeOpacity={0.7} onPress={() => router.push('/calendar')}>
                    <IconSymbol name="calendar" size={20} color={mutedColor} />
                </TouchableOpacity>
            </View>

            {showTagInput && (
                <View style={[styles.tagInputOverlay, { backgroundColor: theme === 'dark' ? 'rgba(0,0,0,0.7)' : 'rgba(0,0,0,0.5)' }]}>
                    <View style={[styles.tagInputBox, { backgroundColor: c.background }]}>
                        <View style={styles.tagInputHeader}>
                            <ThemedText style={[styles.tagInputTitle, { color: c.text }]}>{i18n.addTag}</ThemedText>
                            <TouchableOpacity onPress={() => { setShowTagInput(false); setNewTag(''); }}>
                                <IconSymbol name="x" size={20} color={mutedColor} />
                            </TouchableOpacity>
                        </View>
                        <View style={styles.tagList}>
                            {tags.map(tag => (
                                <View key={tag} style={[styles.tagChip, { backgroundColor: accentColor + '20' }]}>
                                    <ThemedText style={[styles.tagChipText, { color: accentColor }]}>#{tag}</ThemedText>
                                    <TouchableOpacity onPress={() => removeTag(tag)}>
                                        <IconSymbol name="x" size={12} color={accentColor} />
                                    </TouchableOpacity>
                                </View>
                            ))}
                        </View>
                        <TextInput
                            style={[styles.tagTextInput, { color: c.text, borderColor: mutedColor + '40' }]}
                            placeholder="Add tag..."
                            placeholderTextColor={mutedColor}
                            value={newTag}
                            onChangeText={setNewTag}
                            onSubmitEditing={addTag}
                            autoFocus
                        />
                        <TouchableOpacity style={[styles.tagAddBtn, { backgroundColor: accentColor }]} onPress={addTag}>
                            <ThemedText style={styles.tagAddBtnText}>{i18n.save}</ThemedText>
                        </TouchableOpacity>
                    </View>
                </View>
            )}
        </ThemedView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
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
        fontSize: FontSizes.lg,
        fontWeight: FontWeights.semibold,
    },
    saveCircle: {
        width: 40,
        height: 40,
        borderRadius: 20,
        alignItems: 'center',
        justifyContent: 'center',
    },
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
        fontSize: FontSizes.xxl,
        fontWeight: FontWeights.light,
        marginBottom: 32,
        textAlign: 'center',
        opacity: 0.9,
    },
    contentInput: {
        fontSize: FontSizes.lg,
        lineHeight: FontSizes.lg * 1.75,
        fontWeight: FontWeights.light,
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
        fontSize: FontSizes.sm,
        fontWeight: FontWeights.medium,
    },
    locationInput: {
        flex: 1,
        fontSize: FontSizes.sm,
        paddingVertical: 4,
        paddingHorizontal: 8,
        borderRadius: 6,
        borderWidth: 1,
    },
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
    tagInputOverlay: {
        position: 'absolute',
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        justifyContent: 'center',
        alignItems: 'center',
    },
    tagInputBox: {
        width: 300,
        borderRadius: 12,
        padding: 20,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.3,
        shadowRadius: 12,
        elevation: 10,
    },
    tagInputHeader: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        marginBottom: 16,
    },
    tagInputTitle: {
        fontSize: FontSizes.lg,
        fontWeight: FontWeights.semibold,
    },
    tagList: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        gap: 8,
        marginBottom: 16,
    },
    tagChip: {
        flexDirection: 'row',
        alignItems: 'center',
        gap: 4,
        paddingHorizontal: 10,
        paddingVertical: 4,
        borderRadius: 12,
    },
    tagChipText: {
        fontSize: FontSizes.sm,
        fontWeight: FontWeights.medium,
    },
    tagTextInput: {
        borderWidth: 1,
        borderRadius: 8,
        paddingHorizontal: 12,
        paddingVertical: 10,
        fontSize: FontSizes.md,
        marginBottom: 12,
    },
    tagAddBtn: {
        paddingVertical: 10,
        borderRadius: 8,
        alignItems: 'center',
    },
    tagAddBtnText: {
        color: '#000',
        fontWeight: FontWeights.bold,
        fontSize: FontSizes.md,
    },
});
