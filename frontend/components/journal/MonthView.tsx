import React from 'react';
import { View, TouchableOpacity, StyleSheet } from 'react-native';
import { format, startOfMonth, startOfWeek, endOfMonth, endOfWeek, eachDayOfInterval, isSameMonth } from 'date-fns';
import { getDateLocale } from '@/constants/i18n';
import { ThemedText } from '@/components/themed-text';
import { Colors } from '@/constants/theme';

interface MonthViewProps {
    monthDate: Date;
    entryDates: Set<string>;
    accentColor: string;
    theme: 'light' | 'dark';
    i18n: Record<string, string>;
    language: string;
    onDatePress: (dateStr: string) => void;
}

export function MonthView({ monthDate, entryDates, accentColor, theme, i18n, language, onDatePress }: MonthViewProps) {
    const dateLocale = getDateLocale(language);
    const startDate = startOfWeek(startOfMonth(monthDate));
    const endDate = endOfWeek(endOfMonth(monthDate));
    const daysInView = eachDayOfInterval({ start: startDate, end: endDate });
    const c = Colors[theme];
    
    return (
        <View style={styles.monthContainer}>
            <ThemedText style={[styles.monthTitle, { color: c.text }]}>{format(monthDate, 'LLLL yyyy', { locale: dateLocale })}</ThemedText>
            <View style={styles.daysHeader}>
                {[i18n.sun, i18n.mon, i18n.tue, i18n.wed, i18n.thu, i18n.fri, i18n.sat].map((day, idx) => (
                    <ThemedText key={`day-header-${idx}`} style={[styles.dayHeaderText, { color: c.icon }]}>{day}</ThemedText>
                ))}
            </View>
            <View style={[styles.gridContainer, { backgroundColor: c.cardBackground, borderWidth: 1, borderColor: theme === 'dark' ? '#2A2C2E' : '#EAEAEA' }]}>
                {daysInView.map((date, index) => {
                    const dateStr = format(date, 'yyyy-MM-dd');
                    const isCurrentMonth = isSameMonth(date, monthDate);
                    const hasEntry = entryDates.has(dateStr);
                    const isToday = format(date, 'yyyy-MM-dd') === format(new Date(), 'yyyy-MM-dd');
                    
                    return (
                        <TouchableOpacity
                            key={`date-${index}`}
                            style={[styles.gridCell, { borderColor: theme === 'dark' ? '#2A2C2E' : '#EAEAEA', backgroundColor: isToday ? (theme === 'dark' ? '#2A2C30' : '#F4F4F6') : 'transparent' }]}
                            activeOpacity={hasEntry ? 0.7 : 1}
                            onPress={() => hasEntry && onDatePress(dateStr)}
                        >
                            <ThemedText style={[styles.dateText, { color: isToday ? accentColor : c.text, opacity: isCurrentMonth ? 1 : 0.2, fontWeight: isToday ? '800' : 'bold' }]}>
                                {format(date, 'd')}
                            </ThemedText>
                            {hasEntry && <View style={[styles.entryDot, { opacity: isCurrentMonth ? 1 : 0.2 }]} />}
                        </TouchableOpacity>
                    );
                })}
            </View>
        </View>
    );
}

const styles = StyleSheet.create({
    monthContainer: { marginBottom: 60 },
    monthTitle: { fontSize: 16, fontWeight: 'bold', marginBottom: 20, color: '#888' },
    daysHeader: { flexDirection: 'row', marginBottom: 10 },
    dayHeaderText: { flex: 1, textAlign: 'center', fontSize: 12, fontWeight: '600', color: '#FFFFFF', opacity: 0.9 },
    gridContainer: { flexDirection: 'row', flexWrap: 'wrap', borderRadius: 4, overflow: 'hidden' },
    gridCell: { width: `${100 / 7}%`, aspectRatio: 1, minHeight: 80, maxHeight: 100, borderWidth: 0.5, borderColor: '#191B1E', alignItems: 'center', justifyContent: 'center', position: 'relative' },
    dateText: { fontSize: 14, fontWeight: 'bold', color: '#FFFFFF' },
    entryDot: { width: 4, height: 4, borderRadius: 2, backgroundColor: '#FF3B30', position: 'absolute', bottom: '25%' },
});
