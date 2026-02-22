import React from 'react';
import { StyleSheet, View } from 'react-native';
import { ThemedText } from './themed-text';
import { Colors } from '@/constants/theme';
import { useAppContext } from '@/context/AppContext';
import { IconSymbol } from './ui/icon-symbol';

export function TopNav() {
    const { resolvedTheme, accentColor, user } = useAppContext();
    const theme = resolvedTheme;

    return (
        <View style={[styles.container, { backgroundColor: Colors[theme].topNav, borderBottomColor: theme === 'dark' ? '#1A1C1E' : '#D0D0D5' }]}>
            <View style={styles.headerRow}>
                <View style={styles.logoContainer}>
                    <IconSymbol name="book.pages.fill" size={20} color={accentColor} style={{ marginRight: 8 }} />
                    <ThemedText style={[styles.logoText, { color: Colors[theme].text }]}>JOURNEY®</ThemedText>
                </View>

                <View style={styles.profileContainer}>
                    <View style={[styles.avatar, { backgroundColor: accentColor }]}>
                        <ThemedText style={styles.avatarText}>
                            {user ? user.username.charAt(0).toUpperCase() : 'U'}
                        </ThemedText>
                    </View>
                </View>
            </View>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        width: '100%',
        borderBottomWidth: 1,
        borderBottomColor: '#1A1C1E',
    },
    headerRow: {
        flexDirection: 'row',
        justifyContent: 'center', // Center logo as in screenshot
        alignItems: 'center',
        height: 60,
        paddingHorizontal: 24,
        position: 'relative',
    },
    logoContainer: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    logoText: {
        fontSize: 16,
        fontWeight: '700',
        letterSpacing: 2,
        color: '#DFE1E3',
    },
    profileContainer: {
        position: 'absolute',
        right: 24,
        flexDirection: 'row',
        alignItems: 'center',
    },
    avatar: {
        width: 32,
        height: 32,
        borderRadius: 16,
        backgroundColor: '#2A2E33',
        alignItems: 'center',
        justifyContent: 'center',
    },
    avatarText: {
        fontSize: 14,
        fontWeight: '600',
    }
});
