import { StyleSheet, View, FlatList, TouchableOpacity, ActivityIndicator } from 'react-native';
import { useState, useCallback, useMemo } from 'react';
import { useFocusEffect, useRouter } from 'expo-router';
import { format, startOfMonth, startOfWeek, endOfMonth, endOfWeek, eachDayOfInterval, isSameMonth, subMonths, addMonths } from 'date-fns';
import axios from 'axios';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors } from '@/constants/theme';
import { useColorScheme } from '@/hooks/use-color-scheme';

const API_URL = 'http://127.0.0.1:8000/api';

export default function CalendarScreen() {
    const [entries, setEntries] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);
    const router = useRouter();
    const theme = useColorScheme() ?? 'dark';

    // Generate recent months (e.g., past 6 months + current)
    const months = useMemo(() => {
        const result = [];
        let current = addMonths(new Date(), 1); // include next month just in case
        for (let i = 0; i < 12; i++) {
            result.push(current);
            current = subMonths(current, 1);
        }
        return result.reverse(); // oldest to newest
    }, []);

    const fetchEntries = async () => {
        try {
            setLoading(true);
            const response = await axios.get(`${API_URL}/entries`);
            setEntries(response.data);
        } catch (error) {
            console.error('Failed to fetch entries:', error);
        } finally {
            setLoading(false);
        }
    };

    useFocusEffect(
        useCallback(() => {
            fetchEntries();
        }, [])
    );

    // Create a Set of dates (YYYY-MM-DD) that have entries
    const entryDates = useMemo(() => {
        const dates = new Set<string>();
        entries.forEach(entry => {
            const dateStr = format(new Date(entry.created_at), 'yyyy-MM-dd');
            dates.add(dateStr);
        });
        return dates;
    }, [entries]);

    const renderMonth = ({ item: monthDate }: { item: Date }) => {
        const startDate = startOfWeek(startOfMonth(monthDate));
        const endDate = endOfWeek(endOfMonth(monthDate));
        const daysInView = eachDayOfInterval({ start: startDate, end: endDate });

        return (
            <View style={styles.monthContainer}>
                <ThemedText style={styles.monthTitle}>{format(monthDate, 'MMMM yyyy')}</ThemedText>

                <View style={styles.daysHeader}>
                    {['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map(day => (
                        <ThemedText key={`day-header-${day}`} style={styles.dayHeaderText}>{day}</ThemedText>
                    ))}
                </View>

                <View style={styles.gridContainer}>
                    {daysInView.map((date, index) => {
                        const dateStr = format(date, 'yyyy-MM-dd');
                        const isCurrentMonth = isSameMonth(date, monthDate);
                        const hasEntry = entryDates.has(dateStr);

                        return (
                            <TouchableOpacity
                                key={`date-${index}`}
                                style={[
                                    styles.gridCell,
                                    { backgroundColor: isCurrentMonth ? '#1E2023' : '#141618' },
                                    isCurrentMonth && styles.gridCellActive,
                                ]}
                                activeOpacity={hasEntry ? 0.7 : 1}
                                onPress={() => {
                                    if (hasEntry) {
                                        // Highlight or scroll to entry
                                        router.push('/');
                                    }
                                }}
                            >
                                {isCurrentMonth ? (
                                    <>
                                        <ThemedText style={styles.dateText}>{format(date, 'd')}</ThemedText>
                                        {hasEntry && <View style={styles.entryDot} />}
                                    </>
                                ) : null}
                            </TouchableOpacity>
                        );
                    })}
                </View>
            </View>
        );
    };

    return (
        <ThemedView style={[styles.container, { backgroundColor: Colors[theme].background }]}>
            {loading ? (
                <ActivityIndicator size="large" color={Colors[theme].tint} style={styles.loader} />
            ) : (
                <FlatList
                    data={months}
                    keyExtractor={(item) => item.toISOString()}
                    renderItem={renderMonth}
                    contentContainerStyle={styles.listContent}
                    showsVerticalScrollIndicator={false}
                    initialScrollIndex={months.length - 2} // Scroll to current month roughly
                    getItemLayout={(data, index) => (
                        // Approximate height of month block (header + 6 rows of 60px)
                        { length: 480, offset: 480 * index, index }
                    )}
                />
            )}

            <View style={styles.fabContainer}>
                <TouchableOpacity
                    style={styles.calendarFab}
                    activeOpacity={0.8}
                >
                    <IconSymbol size={20} name="calendar.badge.plus" color="#E0E0FF" />
                </TouchableOpacity>

                <TouchableOpacity
                    style={[styles.fab, { backgroundColor: Colors[theme].tint }]}
                    onPress={() => router.push('/write')}
                    activeOpacity={0.8}
                >
                    <IconSymbol size={20} name="plus" color="#000" />
                    <ThemedText style={styles.fabText}>NEW</ThemedText>
                </TouchableOpacity>
            </View>
        </ThemedView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    loader: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },
    listContent: {
        paddingHorizontal: '20%', // Keeps it centered and wide like the screenshot
        paddingTop: 40,
        paddingBottom: 150,
        width: '100%',
    },
    monthContainer: {
        marginBottom: 60,
    },
    monthTitle: {
        fontSize: 16,
        fontWeight: 'bold',
        marginBottom: 20,
        color: '#FFFFFF',
    },
    daysHeader: {
        flexDirection: 'row',
        marginBottom: 10,
    },
    dayHeaderText: {
        flex: 1,
        textAlign: 'center',
        fontSize: 12,
        fontWeight: '600',
        color: '#FFFFFF',
        opacity: 0.9,
    },
    gridContainer: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        borderRadius: 4,
        overflow: 'hidden',
    },
    gridCell: {
        width: `${100 / 7}%`,
        aspectRatio: 1, // Make them square
        minHeight: 80, // or a fixed height if not square
        maxHeight: 100,
        borderWidth: 0.5,
        borderColor: '#191B1E',
        alignItems: 'center',
        justifyContent: 'center',
        position: 'relative',
    },
    gridCellActive: {
        backgroundColor: '#1E2124', // The inner core dark gray seen in the screenshot
    },
    dateText: {
        fontSize: 14,
        fontWeight: 'bold',
        color: '#FFFFFF',
    },
    entryDot: {
        width: 4,
        height: 4,
        borderRadius: 2,
        backgroundColor: '#FF3B30', // Red dot exactly like the screenshot
        position: 'absolute',
        bottom: '25%', // Adjust based on cell appearance
    },
    fabContainer: {
        position: 'absolute',
        bottom: 30,
        right: 30,
        alignItems: 'flex-end',
    },
    calendarFab: {
        backgroundColor: '#353347', // Muted purple from the screenshot
        width: 44,
        height: 44,
        borderRadius: 22,
        alignItems: 'center',
        justifyContent: 'center',
        marginBottom: 16,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.3,
        shadowRadius: 8,
        elevation: 5,
    },
    fab: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingVertical: 14,
        paddingHorizontal: 24,
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
        marginLeft: 8,
        fontSize: 15,
        letterSpacing: 1,
    }
});
