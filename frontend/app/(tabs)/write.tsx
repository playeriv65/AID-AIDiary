import { StyleSheet, TextInput, Platform, TouchableOpacity, Animated, View, ScrollView, ActivityIndicator } from 'react-native';
import { useEffect, useRef, useMemo } from 'react';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { format, parseISO } from 'date-fns';
import { getDateLocale } from '@/constants/i18n';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors, FontSizes, FontWeights } from '@/constants/theme';
import { CONFIG } from '@/constants/config';
import { useAppContext } from '@/context/AppContext';
import { Picker } from '@/components/picker';

import { useJournalEntry } from '../../hooks/use-journal-entry';
import { TagManager } from '@/components/journal/TagManager';
import { EntryMetadata } from '@/components/journal/EntryMetadata';
import { EditorToolbar } from '@/components/journal/EditorToolbar';
import { ImageUploadPreview } from '@/components/journal/ImageUploadPreview';

export default function WriteEntryScreen() {
    const params = useLocalSearchParams<{
        id?: string;
        title?: string;
        content?: string;
        created_at?: string;
        category?: string;
        weather?: string;
        location?: string;
        image?: string;
        tags?: string;
    }>();

    const router = useRouter();
    const { resolvedTheme, accentColor, i18n } = useAppContext();
    const theme = resolvedTheme;
    const dateLocale = getDateLocale(i18n.language);

    const fadeAnim = useRef(new Animated.Value(0)).current;

    const {
        // State
        title,
        content,
        category,
        weather,
        location,
        tags,
        image,
        saving,
        aiPolishing,
        uploading,
        // Computed
        wordCount,
        categoryOptions,
        weatherOptions,
        // Actions
        setTitle,
        setContent,
        setCategory,
        setWeather,
        setLocation,
        setTags,
        setImage,
        // Handlers
        handleSave,
        handleAIPolish,
        handleImageUpload,
        insertTemplate,
    } = useJournalEntry({
        entryId: params.id ? parseInt(params.id) : undefined,
        initialTitle: params.title,
        initialContent: params.content,
        initialCategory: params.category,
        initialWeather: params.weather,
        initialLocation: params.location,
        initialImage: params.image,
        initialTags: params.tags ? params.tags.split(',') : undefined,
        onSuccess: () => router.back(),
    });

    const entryDate = useMemo(() => {
        if (params.created_at) {
            return parseISO(params.created_at);
        }
        return new Date();
    }, [params.created_at]);

    const dateStr = useMemo(() => format(entryDate, 'MM月dd日 HH:mm', { locale: dateLocale }), [entryDate, dateLocale]);

    const c = Colors[theme];
    const mutedColor = c.icon;

    useEffect(() => {
        Animated.timing(fadeAnim, {
            toValue: 1,
            duration: 400,
            useNativeDriver: true,
        }).start();
    }, [fadeAnim]);

    const handleOpenCalendar = () => {
        router.push('/calendar');
    };

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
                        style={[styles.titleInput, { color: c.text }]}
                        placeholder={i18n.titlePlaceholder}
                        placeholderTextColor={mutedColor + '88'}
                        value={title}
                        onChangeText={setTitle}
                        textAlign="center"
                    />

                    <TextInput
                        style={[styles.contentInput, { color: c.text }]}
                        placeholder={i18n.contentPlaceholder}
                        placeholderTextColor={mutedColor + '66'}
                        multiline
                        textAlignVertical="top"
                        value={content}
                        onChangeText={setContent}
                        autoFocus={!params.id}
                    />

                    <ImageUploadPreview
                        image={image}
                        uploading={uploading}
                        onUpload={handleImageUpload}
                        onRemove={() => setImage(null)}
                        theme={theme}
                        accentColor={accentColor}
                        apiStaticUrl={CONFIG.STATIC_URL}
                    />
                </ScrollView>
            </Animated.View>

            <EntryMetadata
                category={category}
                weather={weather}
                location={location}
                categoryOptions={categoryOptions}
                weatherOptions={weatherOptions}
                onCategoryChange={setCategory}
                onWeatherChange={setWeather}
                onLocationChange={setLocation}
                theme={theme}
                accentColor={accentColor}
                i18n={i18n}
            />

            <View style={[styles.metaArea, { borderTopColor: theme === 'dark' ? '#1A1C1E' : '#E8E8EA' }]}>
                <View style={styles.metaRow}>
                    <IconSymbol name="text-aa" size={18} color={mutedColor} />
                    <ThemedText style={[styles.metaText, { color: mutedColor }]}>{wordCount} {i18n.wordCount}</ThemedText>
                </View>
            </View>

            <EditorToolbar
                onAIPolish={handleAIPolish}
                onInsertTemplate={insertTemplate}
                onOpenCalendar={handleOpenCalendar}
                aiPolishing={aiPolishing}
                tagsCount={tags.length}
                theme={theme}
                accentColor={accentColor}
            />

            <TagManager
                tags={tags}
                onTagsChange={setTags}
                theme={theme}
                accentColor={accentColor}
                i18n={i18n}
            />
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
    },
    contentInput: {
        fontSize: FontSizes.lg,
        lineHeight: FontSizes.lg * 1.75,
        fontWeight: FontWeights.light,
        minHeight: 300,
    },
    metaArea: {
        borderTopWidth: StyleSheet.hairlineWidth,
        paddingHorizontal: 16,
        paddingVertical: 12,
    },
    metaRow: {
        flexDirection: 'row',
        alignItems: 'center',
        gap: 8,
    },
    metaText: {
        fontSize: FontSizes.sm,
    },
});
