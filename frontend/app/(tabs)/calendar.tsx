import { StyleSheet, View, FlatList, TouchableOpacity } from 'react-native';
import { useCallback, useMemo } from 'react';
import { useFocusEffect, useRouter } from 'expo-router';
import { format, subMonths, addMonths } from 'date-fns';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors } from '@/constants/theme';
import { useAppContext } from '@/context/AppContext';
import { MonthView } from '@/components/journal/MonthView';

export default function CalendarScreen() {
    const router = useRouter();
    const { resolvedTheme, accentColor, i18n, entries, fetchEntries } = useAppContext();
    const theme = resolvedTheme;

    const months = useMemo(() => {
        const result = [];
        let current = addMonths(new Date(), 1);
        for (let i = 0; i < 12; i++) {
            result.push(current);
            current = subMonths(current, 1);
        }
        return result.reverse();
    }, []);

    useFocusEffect(useCallback(() => { fetchEntries(); }, [fetchEntries]));

    const entryDates = useMemo(() => {
        const dates = new Set<string>();
        entries.forEach(entry => {
            dates.add(format(new Date(entry.created_at), 'yyyy-MM-dd'));
        });
        return dates;
    }, [entries]);

    const handleDatePress = (dateStr: string) => { router.push('/'); };

    const renderMonth = ({ item }: { item: Date }) => (
        <MonthView
            monthDate={item}
            entryDates={entryDates}
            accentColor={accentColor}
            theme={theme}
            i18n={i18n}
            language={i18n.language || 'zh'}
            onDatePress={handleDatePress}
        />
    );

    return (
        <ThemedView style={[styles.container, { backgroundColor: Colors[theme].background }]}>
            <FlatList
                data={months}
                keyExtractor={(item) => item.toISOString()}
                renderItem={renderMonth}
                contentContainerStyle={styles.listContent}
                showsVerticalScrollIndicator={false}
                initialScrollIndex={months.length - 2}
                getItemLayout={(data, index) => ({ length: 480, offset: 480 * index, index })}
            />
            <View style={styles.fabContainer}>
                <TouchableOpacity style={[styles.calendarFab, { backgroundColor: theme === 'dark' ? '#353347' : '#FFFFFF' }]} activeOpacity={0.8} onPress={() => router.push('/write')}>
                    <IconSymbol size={20} name="calendar-plus" color={theme === 'dark' ? '#E0E0FF' : accentColor} />
                </TouchableOpacity>
                <TouchableOpacity style={[styles.fab, { backgroundColor: accentColor }]} onPress={() => router.push('/write')} activeOpacity={0.8}>
                    <IconSymbol size={20} name="plus" color="#000" />
                    <ThemedText style={styles.fabText}>{i18n.newEntry}</ThemedText>
                </TouchableOpacity>
            </View>
        </ThemedView>
    );
}

const styles = StyleSheet.create({
    container: { flex: 1 },
    listContent: { paddingHorizontal: 40, paddingTop: 40, paddingBottom: 150, width: '100%' },
    fabContainer: { position: 'absolute', bottom: 30, right: 30, alignItems: 'flex-end' },
    calendarFab: { width: 44, height: 44, borderRadius: 22, alignItems: 'center', justifyContent: 'center', marginBottom: 16, shadowColor: '#000', shadowOffset: { width: 0, height: 4 }, shadowOpacity: 0.3, shadowRadius: 8, elevation: 5 },
    fab: { flexDirection: 'row', alignItems: 'center', paddingVertical: 14, paddingHorizontal: 24, borderRadius: 30, shadowColor: '#000', shadowOffset: { width: 0, height: 4 }, shadowOpacity: 0.3, shadowRadius: 8, elevation: 5 },
    fabText: { color: '#000', fontWeight: 'bold', marginLeft: 8, fontSize: 15, letterSpacing: 1 },
});
