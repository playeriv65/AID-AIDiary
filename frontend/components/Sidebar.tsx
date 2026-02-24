import React, { useState, useRef } from 'react';
import { StyleSheet, View, TouchableOpacity, ScrollView, Platform, Animated } from 'react-native';
import { useRouter, usePathname } from 'expo-router';
import { IconSymbol } from './ui/icon-symbol';
import { ThemedText } from './themed-text';
import { Colors } from '@/constants/theme';
import { useAppContext } from '@/context/AppContext';

const SIDEBAR_ITEMS = [
    { key: 'timeline', icon: 'book-open', route: '/' },
    { key: 'chat', icon: 'chat-circle', route: '/chat' },
    { key: 'calendar', icon: 'calendar', route: '/calendar' },
    { key: 'search', icon: 'magnifying-glass', route: '/search' },
    { key: 'settings', icon: 'gear', route: '/settings' },
] as const;

const ICON_AREA = 68;     // fixed icon column width
const TEXT_AREA = 152;    // max text area when expanded
const EXPANDED_WIDTH = ICON_AREA + TEXT_AREA;

export function Sidebar() {
    const router = useRouter();
    const pathname = usePathname();
    const { resolvedTheme, accentColor, i18n } = useAppContext();
    const c = Colors[resolvedTheme];

    const [collapsed, setCollapsed] = useState(false);

    // Animated value: 0 = expanded, 1 = collapsed
    const anim = useRef(new Animated.Value(0)).current;

    const toggle = () => {
        const toValue = collapsed ? 0 : 1;
        Animated.timing(anim, {
            toValue,
            duration: 220,
            useNativeDriver: false, // width animation needs non-native
        }).start();
        setCollapsed(!collapsed);
    };

    // Interpolated sidebar width
    const sidebarWidth = anim.interpolate({
        inputRange: [0, 1],
        outputRange: [EXPANDED_WIDTH, ICON_AREA],
    });

    // Text fades out when collapsing
    const textOpacity = anim.interpolate({
        inputRange: [0, 0.4, 1],
        outputRange: [1, 0, 0],
    });

    // Text slides left when collapsing
    const textTranslateX = anim.interpolate({
        inputRange: [0, 1],
        outputRange: [0, -16],
    });

    return (
        <Animated.View style={[styles.container, {
            width: sidebarWidth,
            backgroundColor: c.sidebar,
            borderRightColor: resolvedTheme === 'dark' ? '#1A1C1E' : '#D0D0D5',
        }]}>
            {/* Hamburger toggle */}
            <TouchableOpacity
                style={styles.toggleBtn}
                onPress={toggle}
                activeOpacity={0.7}
            >
                <IconSymbol name="list" size={22} color={c.icon} />
            </TouchableOpacity>

            <ScrollView contentContainerStyle={styles.scrollContent} showsVerticalScrollIndicator={false}>
                {SIDEBAR_ITEMS.map((item) => {
                    const isActive = pathname === item.route;
                    const label = i18n[item.key as keyof typeof i18n] as string;
                    return (
                        <TouchableOpacity
                            key={item.key}
                            style={[
                                styles.itemContent,
                                isActive && { backgroundColor: c.sidebarActive },
                            ]}
                            onPress={() => router.push(item.route as any)}
                            activeOpacity={0.7}
                        >
                            {/* Icon — always fixed in the same spot */}
                            <View style={styles.iconSlot}>
                                <IconSymbol
                                    name={item.icon as any}
                                    size={22}
                                    color={isActive ? accentColor : c.icon}
                                    weight={isActive ? 'fill' : 'regular'}
                                />
                            </View>

                            {/* Text — fades & slides */}
                            <Animated.View style={{
                                opacity: textOpacity,
                                transform: [{ translateX: textTranslateX }],
                                overflow: 'hidden',
                            }}>
                                <ThemedText style={[styles.itemText, { color: isActive ? c.text : c.icon }]}>
                                    {label}
                                </ThemedText>
                            </Animated.View>
                        </TouchableOpacity>
                    );
                })}
            </ScrollView>
        </Animated.View>
    );
}

const styles = StyleSheet.create({
    container: {
        borderRightWidth: 1,
        height: '100%',
        paddingVertical: 10,
        overflow: 'hidden',
        ...(Platform.OS !== 'web' && { display: 'none' }),
    },
    toggleBtn: {
        width: ICON_AREA,
        height: 46,
        alignItems: 'center',
        justifyContent: 'center',
        marginTop: 8,
        marginBottom: 4,
    },
    scrollContent: {
        flexGrow: 1,
        paddingTop: 8,
    },
    itemContent: {
        flexDirection: 'row',
        alignItems: 'center',
        marginHorizontal: 8,
        borderRadius: 10,
        marginBottom: 2,
        height: 46,
        overflow: 'hidden',
    },
    iconSlot: {
        width: ICON_AREA - 16,  // icon column minus margins
        alignItems: 'center',
        justifyContent: 'center',
        flexShrink: 0,
    },
    itemText: {
        fontSize: 14,
        fontWeight: '500',
    },
});
