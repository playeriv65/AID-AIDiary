import { useRef, useEffect } from 'react';
import { StyleSheet, TouchableOpacity, View, Animated } from 'react-native';
import { format } from 'date-fns';
import { ThemedText } from '@/components/themed-text';
import { Colors, FontSizes, FontWeights } from '@/constants/theme';
import { useAppContext } from '@/context/AppContext';
import { getDateLocale } from '@/constants/i18n';
import { IconSymbol } from './ui/icon-symbol';
import { JournalEntry } from '@/api/client';

interface EntryCardProps {
    item: JournalEntry;
    index: number;
    onPress: () => void;
}

const WEATHER_ICONS: Record<string, string> = {
    'sunny': 'sun',
    'cloudy': 'cloud',
    'rainy': 'cloud-rain',
    'snowy': 'snowflake',
    'windy': 'wind',
    'foggy': 'fog',
};

const CATEGORY_ICONS: Record<string, string> = {
    'work': 'briefcase',
    'life': 'heart',
    'study': 'book-open',
    'travel': 'airplane',
    'health': 'heartbeat',
    'other': 'folder',
};

export function EntryCard({ item, index, onPress }: EntryCardProps) {
    const { resolvedTheme, accentColor, language } = useAppContext();
    const theme = resolvedTheme;
    const dateLocale = getDateLocale(language);
    const fadeAnim = useRef(new Animated.Value(0)).current;
    const slideAnim = useRef(new Animated.Value(10)).current;

    useEffect(() => {
        Animated.parallel([
            Animated.timing(fadeAnim, {
                toValue: 1,
                duration: 300,
                delay: index * 50,
                useNativeDriver: true,
            }),
            Animated.timing(slideAnim, {
                toValue: 0,
                duration: 300,
                delay: index * 50,
                useNativeDriver: true,
            }),
        ]).start();
    }, [fadeAnim, slideAnim, index]);

    const weatherKey = item.weather?.toLowerCase() || '';
    const weatherIcon = WEATHER_ICONS[weatherKey] || 'sun';
    const categoryKey = item.category?.toLowerCase() || '';
    const categoryIcon = CATEGORY_ICONS[categoryKey] || 'folder';

    return (
        <TouchableOpacity activeOpacity={0.8} onPress={onPress}>
            <Animated.View style={[
                styles.entryCard,
                {
                    backgroundColor: Colors[theme].cardBackground,
                    opacity: fadeAnim,
                    transform: [{ translateY: slideAnim }]
                }
            ]}>
                <View style={styles.metaRow}>
                    <ThemedText style={[styles.entryDate, { color: accentColor }]}>
                        {format(new Date(item.created_at), 'PPP p - EEE', { locale: dateLocale })}
                    </ThemedText>
                    <View style={styles.badges}>
                        {item.category && (
                            <View style={[styles.badge, { backgroundColor: accentColor + '20' }]}>
                                <IconSymbol name={categoryIcon} size={12} color={accentColor} />
                                <ThemedText style={[styles.badgeText, { color: accentColor }]}>{item.category}</ThemedText>
                            </View>
                        )}
                        {item.weather && (
                            <View style={[styles.badge, { backgroundColor: '#3B82F620' }]}>
                                <IconSymbol name={weatherIcon} size={12} color="#3B82F6" />
                                <ThemedText style={[styles.badgeText, { color: '#3B82F6' }]}>{item.weather}</ThemedText>
                            </View>
                        )}
                    </View>
                </View>
                {item.title ? (
                    <ThemedText
                        style={[styles.entryTitle, { color: Colors[theme].text }]}
                        type="defaultSemiBold"
                    >
                        {item.title}
                    </ThemedText>
                ) : null}
                <ThemedText
                    style={[styles.entryContent, { color: Colors[theme].text }]}
                    numberOfLines={2}
                >
                    {item.content}
                </ThemedText>
            </Animated.View>
        </TouchableOpacity>
    );
}

const styles = StyleSheet.create({
    entryCard: {
        padding: 20,
        marginBottom: 12,
        borderRadius: 8,
    },
    entryDate: {
        fontSize: FontSizes.sm,
        marginBottom: 8,
        fontWeight: FontWeights.semibold,
    },
    entryTitle: {
        fontSize: FontSizes.lg,
        marginBottom: 6,
        lineHeight: FontSizes.lg * 1.5,
    },
    entryContent: {
        opacity: 0.7,
        lineHeight: FontSizes.md * 1.6,
        fontSize: FontSizes.md,
    },
    metaRow: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        marginBottom: 8,
    },
    badges: {
        flexDirection: 'row',
        gap: 6,
    },
    badge: {
        flexDirection: 'row',
        alignItems: 'center',
        gap: 4,
        paddingHorizontal: 8,
        paddingVertical: 3,
        borderRadius: 4,
    },
    badgeText: {
        fontSize: FontSizes.xs,
        fontWeight: FontWeights.medium,
    },
});
