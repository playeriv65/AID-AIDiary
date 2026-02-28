import { StyleSheet, TextInput, FlatList, TouchableOpacity, View, Animated } from 'react-native';
import { useState, useCallback, useRef, useEffect } from 'react';
import { useRouter } from 'expo-router';
import { format } from 'date-fns';
import { getDateLocale } from '@/constants/i18n';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors, FontSizes, FontWeights } from '@/constants/theme';
import { useAppContext } from '@/context/AppContext';

export default function SearchScreen() {
    const { resolvedTheme, accentColor, i18n, entries, language } = useAppContext();
    const theme = resolvedTheme;
    const c = Colors[theme];
    const dateLocale = getDateLocale(language);
    const router = useRouter();

    const [query, setQuery] = useState('');
    const fadeAnim = useRef(new Animated.Value(0)).current;

    useEffect(() => {
        Animated.timing(fadeAnim, {
            toValue: 1,
            duration: 300,
            useNativeDriver: false,
        }).start();
    }, [fadeAnim]);

    const filteredEntries = useCallback(() => {
        if (!query.trim()) return [];
        const q = query.toLowerCase();
        return entries.filter((entry: any) => {
            const title = (entry.title || '').toLowerCase();
            const content = (entry.content || '').toLowerCase();
            return title.includes(q) || content.includes(q);
        });
    }, [query, entries])();

    const highlightMatch = (text: string, maxLen: number = 120) => {
        if (!query.trim()) return text.slice(0, maxLen);
        const q = query.toLowerCase();
        const idx = text.toLowerCase().indexOf(q);
        if (idx === -1) return text.slice(0, maxLen);

        const start = Math.max(0, idx - 30);
        const end = Math.min(text.length, idx + query.length + 60);
        let snippet = text.slice(start, end);
        if (start > 0) snippet = '...' + snippet;
        if (end < text.length) snippet = snippet + '...';
        return snippet;
    };

    const handleEntryPress = (entry: any) => {
        router.push({
            pathname: '/write',
            params: {
                id: entry.id,
                title: entry.title || '',
                content: entry.content,
                created_at: entry.created_at,
                category: entry.category || '',
                weather: entry.weather || '',
                location: entry.location || '',
            },
        });
    };

    return (
        <ThemedView style={[styles.container, { backgroundColor: c.background }]}>
            {/* Search Bar */}
            <Animated.View style={[styles.searchBarWrapper, { opacity: fadeAnim }]}>
                <View style={[styles.searchBar, {
                    backgroundColor: theme === 'dark' ? '#1A1C1E' : '#F0F0F2',
                    borderColor: theme === 'dark' ? '#2A2C30' : '#E0E0E5',
                }]}>
                    <IconSymbol name="magnifying-glass" size={18} color={c.icon} style={styles.searchIcon} />
                    <TextInput
                        style={[styles.searchInput, { color: c.text, outlineStyle: 'none' } as any]}
                        placeholder={i18n.search + '...'}
                        placeholderTextColor={c.icon + '88'}
                        value={query}
                        onChangeText={setQuery}
                        autoFocus={true}
                        returnKeyType="search"
                        name="search"
                        id="search"
                    />
                    {query.length > 0 && (
                        <TouchableOpacity onPress={() => setQuery('')} activeOpacity={0.7}>
                            <IconSymbol name="x-circle" size={18} color={c.icon + '88'} />
                        </TouchableOpacity>
                    )}
                </View>
            </Animated.View>

            {/* Results */}
            {query.trim() ? (
                <FlatList
                    data={filteredEntries}
                    keyExtractor={(item) => item.id}
                    contentContainerStyle={styles.listContent}
                    showsVerticalScrollIndicator={false}
                    renderItem={({ item }) => (
                        <TouchableOpacity
                            activeOpacity={0.7}
                            onPress={() => handleEntryPress(item)}
                        >
                            <View style={[styles.resultCard, { backgroundColor: c.cardBackground }]}>
                                <ThemedText style={[styles.resultDate, { color: accentColor }]}>
                                    {format(new Date(item.created_at), 'PPP', { locale: dateLocale })}
                                </ThemedText>
                                {item.title && (
                                    <ThemedText style={[styles.resultTitle, { color: c.text }]}>{item.title}</ThemedText>
                                )}
                                <ThemedText style={[styles.resultSnippet, { color: c.icon }]} numberOfLines={3}>
                                    {highlightMatch(item.content)}
                                </ThemedText>
                            </View>
                        </TouchableOpacity>
                    )}
                    ListEmptyComponent={
                        <ThemedView style={styles.emptyContainer}>
                            <IconSymbol name="magnifying-glass" size={40} color={c.icon + '44'} />
                            <ThemedText style={[styles.emptyText, { color: c.icon }]}>
                                {i18n.noEntries}
                            </ThemedText>
                        </ThemedView>
                    }
                />
            ) : (
                <ThemedView style={styles.emptyContainer}>
                    <IconSymbol name="magnifying-glass" size={48} color={c.icon + '33'} />
                    <ThemedText style={[styles.hintText, { color: c.icon + '88' }]}>
                        {i18n.search}
                    </ThemedText>
                </ThemedView>
            )}
        </ThemedView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    searchBarWrapper: {
        paddingHorizontal: '15%',
        paddingTop: 20,
        paddingBottom: 10,
    },
    searchBar: {
        flexDirection: 'row',
        alignItems: 'center',
        borderRadius: 12,
        borderWidth: 1,
        paddingHorizontal: 14,
        paddingVertical: 10,
    },
    searchIcon: {
        marginRight: 10,
    },
    searchInput: {
        flex: 1,
        fontSize: FontSizes.lg,
        fontWeight: FontWeights.normal,
    },
    listContent: {
        paddingHorizontal: '15%',
        paddingTop: 10,
        paddingBottom: 40,
    },
    resultCard: {
        borderRadius: 12,
        padding: 18,
        marginBottom: 10,
    },
    resultDate: {
        fontSize: FontSizes.sm,
        fontWeight: FontWeights.semibold,
        marginBottom: 6,
    },
    resultTitle: {
        fontSize: FontSizes.lg,
        fontWeight: FontWeights.semibold,
        marginBottom: 4,
    },
    resultSnippet: {
        fontSize: FontSizes.md,
        lineHeight: FontSizes.md * 1.5,
    },
    emptyContainer: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
        gap: 16,
        paddingTop: 80,
    },
    emptyText: {
        fontSize: 14,
    },
    hintText: {
        fontSize: 16,
        fontWeight: '300',
    },
});
