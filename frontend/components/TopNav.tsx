import React from 'react';
// Trigger recompile to fix stale import cache
import { StyleSheet, TouchableOpacity, View } from 'react-native';
import { useRouter } from 'expo-router';
import { ThemedText } from './themed-text';
import { Colors } from '@/constants/theme';
import { useAppContext } from '@/context/AppContext';
import { IconSymbol } from './ui/icon-symbol';

export function TopNav() {
  const router = useRouter();
  const { resolvedTheme, accentColor, user, i18n } = useAppContext();
  const c = Colors[resolvedTheme];

  return (
    <View
      style={[
        styles.container,
        {
          backgroundColor: c.topNav,
          borderBottomColor: resolvedTheme === 'dark' ? '#1A1C1E' : '#D0D0D5',
        },
      ]}
    >
      <View style={styles.headerRow}>
        <View style={styles.logoContainer}>
          <IconSymbol
            name="book-open"
            size={20}
            color={accentColor}
            weight="fill"
            style={{ marginRight: 8 }}
          />
          <ThemedText style={[styles.logoText, { color: c.text }]}>{i18n.appName}</ThemedText>
        </View>
        <TouchableOpacity
          style={styles.profileContainer}
          onPress={() => router.push('/settings')}
          activeOpacity={0.7}
        >
          <View style={[styles.avatar, { backgroundColor: accentColor }]}>
            <ThemedText style={styles.avatarText}>
              {user ? user.username.charAt(0).toUpperCase() : 'U'}
            </ThemedText>
          </View>
        </TouchableOpacity>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    width: '100%',
    borderBottomWidth: 1,
  },
  headerRow: {
    flexDirection: 'row',
    alignItems: 'center',
    height: 60,
    paddingHorizontal: 24,
  },
  logoContainer: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
  },
  logoText: {
    fontSize: 18,
    fontWeight: '800',
    letterSpacing: 3,
  },
  profileContainer: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  avatar: {
    width: 32,
    height: 32,
    borderRadius: 16,
    alignItems: 'center',
    justifyContent: 'center',
  },
  avatarText: {
    fontSize: 14,
    fontWeight: '600',
    color: '#000',
  },
});
