import { StyleSheet, FlatList, TouchableOpacity, View, Alert } from 'react-native';
import { useCallback, useEffect, useState, useRef } from 'react';
import { useFocusEffect, useRouter } from 'expo-router';
import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { Colors, FontSizes } from '@/constants/theme';
import { useAppContext } from '@/context/AppContext';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { EntryCard } from '@/components/EntryCard';
import { FilterPopover } from '@/components/journal/FilterPopover';
import { JournalEntry } from '@/api/client';

export default function JournalTimelineScreen() {
    const router = useRouter();
    const { resolvedTheme, accentColor, i18n, entries, entriesLoading, fetchEntries, backendStatus, checkBackendHealth, offlineShown, setOfflineShown } = useAppContext();
    const theme = resolvedTheme;
    
    const [showFilter, setShowFilter] = useState(false);
    const [filterCategory, setFilterCategory] = useState<string | null>(null);
    const [filterWeather, setFilterWeather] = useState<string | null>(null);
    const filterBtnRef = useRef<View>(null);
    const [filterPosition, setFilterPosition] = useState({ x: 0, y: 0, width: 0, height: 0 });

    const filteredEntries = entries.filter(entry => {
        if (filterCategory && entry.category?.toLowerCase() !== filterCategory) return false;
        if (filterWeather && entry.weather?.toLowerCase() !== filterWeather) return false;
        return true;
    });

    const openFilter = () => {
        filterBtnRef.current?.measureInWindow((x, y, width, height) => {
            setFilterPosition({ x, y, width, height });
            setShowFilter(true);
        });
    };

    const hasFilters = filterCategory || filterWeather;

    const clearFilters = () => { setFilterCategory(null); setFilterWeather(null); };

    useEffect(() => {
        if (backendStatus === 'offline' && !offlineShown) {
            Alert.alert(i18n.hint, i18n.backendOffline || '后端未连接，点击重试');
            setOfflineShown(true);
        }
    }, [backendStatus, offlineShown, setOfflineShown, i18n]);

    useFocusEffect(useCallback(() => { fetchEntries(); }, [fetchEntries]));

    const handleEntryPress = (entry: JournalEntry) => {
        router.push({ pathname: '/write', params: { id: entry.id.toString(), title: entry.title || '', content: entry.content, created_at: entry.created_at, category: entry.category || '', weather: entry.weather || '', location: entry.location || '', image: entry.image || '' } });
    };

    const renderHeader = () => (
        <View style={styles.listHeader}>
            {backendStatus === 'offline' && (
                <TouchableOpacity onPress={checkBackendHealth} style={styles.offlineIcon}>
                    <IconSymbol name="wifi-slash" size={20} color="#F43F5E" />
                </TouchableOpacity>
            )}
            <View style={styles.headerActions}>
                <TouchableOpacity onPress={fetchEntries} style={styles.headerBtn}>
                    <IconSymbol name="arrow-clockwise" size={18} color={Colors[theme].icon} />
                </TouchableOpacity>
                <View ref={filterBtnRef} collapsable={false}>
                    <TouchableOpacity onPress={openFilter} style={styles.headerBtn}>
                        <IconSymbol name="funnel" size={18} color={hasFilters ? accentColor : Colors[theme].icon} />
                    </TouchableOpacity>
                </View>
            </View>
        </View>
    );

    return (
        <ThemedView style={[styles.container, { backgroundColor: Colors[theme].background }]}>
            <FlatList
                data={filteredEntries as JournalEntry[]}
                keyExtractor={(item) => item.id.toString()}
                ListHeaderComponent={renderHeader}
                renderItem={({ item, index }) => <EntryCard item={item} index={index} onPress={() => handleEntryPress(item)} />}
                contentContainerStyle={styles.listContent}
                showsVerticalScrollIndicator={false}
                ListEmptyComponent={<ThemedView style={styles.emptyContainer}>{entriesLoading ? null : <ThemedText style={styles.emptyText}>{i18n.noEntries}</ThemedText>}</ThemedView>}
            />

            <TouchableOpacity style={[styles.fab, { backgroundColor: accentColor }]} onPress={() => router.push('/write')} activeOpacity={0.8}>
                <ThemedText style={styles.fabText}>{i18n.newEntry}</ThemedText>
            </TouchableOpacity>

            {showFilter && (
                <FilterPopover
                    filterCategory={filterCategory}
                    filterWeather={filterWeather}
                    hasFilters={hasFilters}
                    accentColor={accentColor}
                    theme={theme}
                    i18n={i18n}
                    filterPosition={filterPosition}
                    onSetCategory={setFilterCategory}
                    onSetWeather={setFilterWeather}
                    onClear={clearFilters}
                    onClose={() => setShowFilter(false)}
                />
            )}
        </ThemedView>
    );
}

const styles = StyleSheet.create({
    container: { flex: 1 },
    listContent: { paddingHorizontal: '15%', paddingTop: 30, paddingBottom: 100, width: '100%' },
    listHeader: { marginBottom: 16, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' },
    offlineIcon: { marginRight: 12 },
    headerActions: { flexDirection: 'row', alignItems: 'center', gap: 4 },
    headerBtn: { padding: 8, borderRadius: 8 },
    emptyContainer: { flex: 1, alignItems: 'center', justifyContent: 'center', minHeight: 200, backgroundColor: 'transparent' },
    emptyText: { fontSize: FontSizes.md, color: '#8A8D91' },
    fab: { position: 'absolute', bottom: 30, right: 30, alignItems: 'center', justifyContent: 'center', paddingVertical: 14, paddingHorizontal: 28, borderRadius: 30, shadowColor: '#000', shadowOffset: { width: 0, height: 4 }, shadowOpacity: 0.3, shadowRadius: 8, elevation: 5 },
    fabText: { color: '#000', fontWeight: 'bold', fontSize: FontSizes.lg, textAlign: 'center', includeFontPadding: false },
});
