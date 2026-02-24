import { StyleSheet, FlatList, TouchableOpacity, View, Alert } from 'react-native';
import { useCallback, useEffect, useState, useRef } from 'react';
import { useFocusEffect, useRouter } from 'expo-router';
import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { Colors, FontSizes, FontWeights } from '@/constants/theme';
import { useAppContext } from '@/context/AppContext';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { EntryCard, JournalEntry } from '@/components/EntryCard';

const CATEGORIES = ['work', 'life', 'study', 'travel', 'health', 'other'];
const WEATHERS = ['sunny', 'cloudy', 'rainy', 'snowy', 'windy', 'foggy'];

export default function JournalTimelineScreen() {
    const router = useRouter();
    const {
        resolvedTheme,
        accentColor,
        i18n,
        entries,
        entriesLoading,
        fetchEntries,
        backendStatus,
        checkBackendHealth,
        offlineShown,
        setOfflineShown
    } = useAppContext();
    const theme = resolvedTheme;
    
    const [showFilter, setShowFilter] = useState(false);
    const [filterCategory, setFilterCategory] = useState<string | null>(null);
    const [filterWeather, setFilterWeather] = useState<string | null>(null);
    const filterBtnRef = useRef<View>(null);
    const [filterPosition, setFilterPosition] = useState({ x: 0, y: 0, width: 0, height: 0 });

    // 筛选后的日记
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

    useEffect(() => {
        if (backendStatus === 'offline' && !offlineShown) {
            Alert.alert(i18n.hint, i18n.backendOffline || '后端未连接，点击重试');
            setOfflineShown(true);
        }
    }, [backendStatus, offlineShown, setOfflineShown, i18n]);

    useFocusEffect(
        useCallback(() => {
            fetchEntries();
        }, [fetchEntries])
    );

    const handleEntryPress = (entry: JournalEntry) => {
        router.push({
            pathname: '/write',
            params: {
                id: entry.id.toString(),
                title: entry.title || '',
                content: entry.content,
                created_at: entry.created_at,
                category: entry.category || '',
                weather: entry.weather || '',
                location: entry.location || '',
                image: entry.image || '',
            },
        });
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
                    <TouchableOpacity
                        onPress={openFilter}
                        style={styles.headerBtn}
                    >
                        <IconSymbol 
                            name="funnel" 
                            size={18} 
                            color={hasFilters ? accentColor : Colors[theme].icon} 
                        />
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
                renderItem={({ item, index }) => (
                    <EntryCard
                        item={item}
                        index={index}
                        onPress={() => handleEntryPress(item)}
                    />
                )}
                contentContainerStyle={styles.listContent}
                showsVerticalScrollIndicator={false}
                ListEmptyComponent={
                    <ThemedView style={styles.emptyContainer}>
                        {entriesLoading ? null : (
                            <ThemedText style={styles.emptyText}>{i18n.noEntries}</ThemedText>
                        )}
                    </ThemedView>
                }
            />

            <TouchableOpacity
                style={[styles.fab, { backgroundColor: accentColor }]}
                onPress={() => router.push('/write')}
                activeOpacity={0.8}
            >
                <ThemedText style={styles.fabText}>{i18n.newEntry}</ThemedText>
            </TouchableOpacity>

            {showFilter && (
                <>
                    <TouchableOpacity 
                        style={styles.filterOverlay} 
                        activeOpacity={1} 
                        onPress={() => setShowFilter(false)}
                    />
                    <View 
                        style={[
                            styles.filterPopover, 
                            { 
                                backgroundColor: Colors[theme].cardBackground,
                                top: filterPosition.y + filterPosition.height + 8,
                                right: 20,
                            }
                        ]}
                    >
                        <ThemedText style={[styles.filterLabel, { color: Colors[theme].text }]}>{i18n.filterByCategory}</ThemedText>
                        <View style={styles.filterOptions}>
                            <TouchableOpacity 
                                style={[styles.filterChip, filterCategory === null && { backgroundColor: accentColor + '30' }]}
                                onPress={() => setFilterCategory(null)}
                            >
                                <ThemedText style={{ color: filterCategory === null ? accentColor : Colors[theme].text }}>{i18n.all}</ThemedText>
                            </TouchableOpacity>
                            {CATEGORIES.map(cat => (
                                <TouchableOpacity 
                                    key={cat}
                                    style={[styles.filterChip, filterCategory === cat && { backgroundColor: accentColor + '30' }]}
                                    onPress={() => setFilterCategory(cat)}
                                >
                                    <ThemedText style={{ color: filterCategory === cat ? accentColor : Colors[theme].text }}>
                                        {i18n[`cat${cat.charAt(0).toUpperCase() + cat.slice(1)}` as keyof typeof i18n] || cat}
                                    </ThemedText>
                                </TouchableOpacity>
                            ))}
                        </View>

                        <ThemedText style={[styles.filterLabel, { color: Colors[theme].text }]}>{i18n.filterByWeather}</ThemedText>
                        <View style={styles.filterOptions}>
                            <TouchableOpacity 
                                style={[styles.filterChip, filterWeather === null && { backgroundColor: '#3B82F630' }]}
                                onPress={() => setFilterWeather(null)}
                            >
                                <ThemedText style={{ color: filterWeather === null ? '#3B82F6' : Colors[theme].text }}>{i18n.all}</ThemedText>
                            </TouchableOpacity>
                            {WEATHERS.map(w => (
                                <TouchableOpacity 
                                    key={w}
                                    style={[styles.filterChip, filterWeather === w && { backgroundColor: '#3B82F630' }]}
                                    onPress={() => setFilterWeather(w)}
                                >
                                    <ThemedText style={{ color: filterWeather === w ? '#3B82F6' : Colors[theme].text }}>
                                        {i18n[`weather${w.charAt(0).toUpperCase() + w.slice(1)}` as keyof typeof i18n] || w}
                                    </ThemedText>
                                </TouchableOpacity>
                            ))}
                        </View>

                        {hasFilters && (
                            <TouchableOpacity 
                                style={[styles.clearBtn, { borderColor: Colors[theme].icon }]}
                                onPress={clearFilters}
                            >
                                <ThemedText style={{ color: Colors[theme].text, fontSize: FontSizes.sm }}>{i18n.clear}</ThemedText>
                            </TouchableOpacity>
                        )}
                    </View>
                </>
            )}
        </ThemedView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    listContent: {
        paddingHorizontal: '15%',
        paddingTop: 30,
        paddingBottom: 100,
        width: '100%',
    },
    listHeader: {
        marginBottom: 16,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'flex-end',
    },
    offlineIcon: {
        marginRight: 12,
    },
    headerActions: {
        flexDirection: 'row',
        alignItems: 'center',
        gap: 4,
    },
    headerBtn: {
        padding: 8,
        borderRadius: 8,
    },
    emptyContainer: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
        minHeight: 200,
        backgroundColor: 'transparent',
    },
    emptyText: {
        fontSize: FontSizes.md,
        color: '#8A8D91',
    },
    fab: {
        position: 'absolute',
        bottom: 30,
        right: 30,
        alignItems: 'center',
        justifyContent: 'center',
        paddingVertical: 14,
        paddingHorizontal: 28,
        borderRadius: 30,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.3,
        shadowRadius: 8,
        elevation: 5,
    },
    fabText: {
        color: '#000',
        fontWeight: 'bold',
        fontSize: FontSizes.lg,
        textAlign: 'center',
        includeFontPadding: false,
    },
    modalOverlay: {
        flex: 1,
        justifyContent: 'flex-end',
    },
    modalBackdrop: {
        ...StyleSheet.absoluteFillObject,
    },
    modalContent: {
        borderTopLeftRadius: 20,
        borderTopRightRadius: 20,
        padding: 20,
        paddingBottom: 40,
    },
    modalHandle: {
        width: 36,
        height: 4,
        backgroundColor: '#ccc',
        borderRadius: 2,
        alignSelf: 'center',
        marginBottom: 16,
    },
    modalTitle: {
        fontSize: FontSizes.xl,
        fontWeight: FontWeights.semibold,
        marginBottom: 12,
        textAlign: 'center',
    },
    filterLabel: {
        fontSize: FontSizes.md,
        fontWeight: FontWeights.medium,
        marginBottom: 10,
        marginTop: 16,
    },
    filterOptions: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        gap: 8,
    },
    filterChip: {
        paddingHorizontal: 14,
        paddingVertical: 8,
        borderRadius: 20,
        backgroundColor: 'rgba(128,128,128,0.1)',
    },
    modalButtons: {
        flexDirection: 'row',
        justifyContent: 'flex-end',
        gap: 12,
        marginTop: 24,
    },
    modalBtn: {
        paddingHorizontal: 24,
        paddingVertical: 12,
        borderRadius: 8,
    },
    filterOverlay: {
        ...StyleSheet.absoluteFillObject,
        zIndex: 99,
    },
    filterPopover: {
        position: 'absolute',
        zIndex: 100,
        width: 280,
        padding: 16,
        borderRadius: 12,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.15,
        shadowRadius: 12,
        elevation: 8,
    },
    clearBtn: {
        marginTop: 16,
        paddingVertical: 8,
        borderTopWidth: 1,
        borderTopColor: '#ccc',
        alignItems: 'center',
    },
});
