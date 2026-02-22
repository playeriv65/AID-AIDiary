import React from 'react';
import { StyleSheet, View, TouchableOpacity, ScrollView, Platform } from 'react-native';
import { useRouter, usePathname } from 'expo-router';
import { IconSymbol } from './ui/icon-symbol';
import { ThemedText } from './themed-text';
import { Colors } from '@/constants/theme';
import { useAppContext } from '@/context/AppContext';

const SIDEBAR_ITEMS = [
    { name: 'Timeline', icon: 'book.fill', route: '/' },
    { name: 'Calendar', icon: 'calendar', route: '/calendar' },
    { name: 'Media', icon: 'photo', route: '/media' },
    { name: 'Atlas', icon: 'map', route: '/atlas' },
    { name: 'Coach', icon: 'heart', route: '/coach' },
    { name: 'Search', icon: 'magnifyingglass', route: '/search' },
    { name: 'Odyssey AI', icon: 'sparkles', route: '/ai' },
    { name: 'Settings', icon: 'gear', route: '/settings' },
];

export function Sidebar() {
    const router = useRouter();
    const pathname = usePathname();
    const { resolvedTheme, accentColor } = useAppContext();
    const theme = resolvedTheme;

    return (
        <View style={[styles.container, { backgroundColor: Colors[theme].sidebar }]}>
            <ScrollView contentContainerStyle={styles.scrollContent} showsVerticalScrollIndicator={false}>
                {SIDEBAR_ITEMS.map((item) => {
                    const isActive = pathname === item.route;
                    return (
                        <TouchableOpacity
                            key={item.name}
                            style={[
                                styles.itemContent,
                                isActive && { backgroundColor: Colors[theme].sidebarActive }
                            ]}
                            onPress={() => router.push(item.route as any)}
                            activeOpacity={0.7}
                        >
                            <IconSymbol
                                name={item.icon as any}
                                size={20}
                                color={isActive ? accentColor : Colors[theme].icon}
                                style={styles.icon}
                            />
                            <ThemedText style={[styles.itemText, { color: isActive ? Colors[theme].text : Colors[theme].icon }]}>
                                {item.name}
                            </ThemedText>
                        </TouchableOpacity>
                    );
                })}
            </ScrollView>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        width: 260,
        borderRightWidth: 1,
        borderRightColor: '#1A1C1E', // Very dark subtle border
        height: '100%',
        paddingVertical: 10,
        // Hide sidebar completely on very small mobile screens (optional but good practice)
        ...(Platform.OS !== 'web' && { display: 'none' })
    },
    scrollContent: {
        flexGrow: 1,
        paddingTop: 40,
    },
    itemContent: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingVertical: 12,
        paddingHorizontal: 24,
        marginHorizontal: 8,
        borderRadius: 8,
        marginBottom: 4,
    },
    icon: {
        marginRight: 16,
        width: 24, // Fixed width to align icons
        textAlign: 'center',
    },
    itemText: {
        fontSize: 14,
        color: '#8A8D91',
        fontWeight: '500',
    },
    itemTextActive: {
        color: '#DFE1E3',
        fontWeight: '600',
    },
    divider: {
        height: 1,
        backgroundColor: '#1A1C1E',
        marginVertical: 16,
        marginHorizontal: 24,
    }
});
