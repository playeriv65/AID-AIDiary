import { useRef, useEffect } from 'react';
import { StyleSheet, TouchableOpacity, Animated } from 'react-native';
import { format } from 'date-fns';
import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { Colors, FontSizes, FontWeights } from '@/constants/theme';
import { useAppContext } from '@/context/AppContext';
import { getDateLocale } from '@/constants/i18n';

export interface JournalEntry {
    id: number;
    title: string | null;
    content: string;
    category: string | null;
    weather: string | null;
    location: string | null;
    tags: string[] | null;
    image: string | null;
    created_at: string;
    updated_at: string;
}

interface EntryCardProps {
    item: JournalEntry;
    index: number;
    onPress: () => void;
}

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
                <ThemedText style={[styles.entryDate, { color: accentColor }]}>
                    {format(new Date(item.created_at), 'PPP p - EEE', { locale: dateLocale })}
                </ThemedText>
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
});
