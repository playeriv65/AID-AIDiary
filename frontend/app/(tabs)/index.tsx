// Trigger recompile
import { StyleSheet, FlatList, TouchableOpacity, ActivityIndicator, Animated, View, Alert } from 'react-native';
import { useState, useCallback, useRef, useEffect } from 'react';
import { useFocusEffect, useRouter } from 'expo-router';
import { format } from 'date-fns';
import { getDateLocale } from '@/constants/i18n';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { Colors } from '@/constants/theme';
import { useAppContext } from '@/context/AppContext';
import { IconSymbol } from '@/components/ui/icon-symbol';

const AnimatedThemedView = Animated.createAnimatedComponent(ThemedView);

function EntryCard({ item, index }: { item: any; index: number }) {
  const { resolvedTheme, accentColor, language, i18n } = useAppContext();
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
    <TouchableOpacity activeOpacity={0.8} onPress={() => Alert.alert(item.title || i18n.hint, item.content)}>
      <AnimatedThemedView style={[styles.entryCard, { backgroundColor: Colors[theme].cardBackground, opacity: fadeAnim, transform: [{ translateY: slideAnim }] }]}>
        <ThemedText style={[styles.entryDate, { color: accentColor }]}>
          {format(new Date(item.created_at), 'PPP p - EEE', { locale: dateLocale })}
        </ThemedText>
        {item.title ? (
          <ThemedText style={[styles.entryTitle, { color: Colors[theme].text }]} type="defaultSemiBold">{item.title}</ThemedText>
        ) : null}
        <ThemedText style={[styles.entryContent, { color: Colors[theme].text }]} numberOfLines={2}>{item.content}</ThemedText>
      </AnimatedThemedView>
    </TouchableOpacity>
  );
}

export default function JournalTimelineScreen() {
  const router = useRouter();
  const { resolvedTheme, accentColor, i18n, entries, entriesLoading, fetchEntries } = useAppContext();
  const theme = resolvedTheme;

  // Silently refresh when page gains focus (data already cached in context)
  useFocusEffect(
    useCallback(() => {
      fetchEntries();
    }, [fetchEntries])
  );

  const renderHeader = () => (
    <View style={styles.listHeader}>
      <View style={styles.entriesSectionHeader}>
        <ThemedText style={[styles.sectionTitle, { color: Colors[theme].text }]}>{i18n.entries}</ThemedText>
        <View style={styles.entriesActions}>
          <TouchableOpacity onPress={fetchEntries} style={{ marginRight: 16 }}>
            <IconSymbol name="arrow-clockwise" size={16} color={Colors[theme].icon} />
          </TouchableOpacity>
          <TouchableOpacity onPress={() => Alert.alert(i18n.hint, i18n.filteringSoon)}>
            <IconSymbol name="sliders" size={16} color={Colors[theme].icon} />
          </TouchableOpacity>
        </View>
      </View>
    </View>
  );

  return (
    <ThemedView style={[styles.container, { backgroundColor: Colors[theme].background }]}>
      <FlatList
        data={entries}
        keyExtractor={(item) => item.id.toString()}
        ListHeaderComponent={renderHeader}
        renderItem={({ item, index }) => <EntryCard item={item} index={index} />}
        contentContainerStyle={styles.listContent}
        showsVerticalScrollIndicator={false}
        ListEmptyComponent={
          <ThemedView style={styles.emptyContainer}>
            {entriesLoading ? null : <ThemedText style={styles.emptyText}>{i18n.noEntries}</ThemedText>}
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
    paddingHorizontal: '15%',
    paddingTop: 30,
    paddingBottom: 100,
    width: '100%',
  },
  listHeader: {
    marginBottom: 8,
  },
  sectionTitle: {
    fontSize: 16,
    fontWeight: '700',
    marginBottom: 8,
    letterSpacing: 0.5,
  },
  entriesSectionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 16,
  },
  entriesActions: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  entryCard: {
    padding: 20,
    marginBottom: 12,
    borderRadius: 8,
  },
  entryDate: {
    fontSize: 13,
    marginBottom: 8,
    fontWeight: '600',
  },
  entryTitle: {
    fontSize: 16,
    marginBottom: 6,
    lineHeight: 24,
  },
  entryContent: {
    opacity: 0.7,
    lineHeight: 22,
    fontSize: 14,
  },
  emptyContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    minHeight: 200,
    backgroundColor: 'transparent',
  },
  emptyText: {
    fontSize: 14,
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
    fontWeight: '700',
    fontSize: 15,
    textAlign: 'center',
    includeFontPadding: false,
  }
});
