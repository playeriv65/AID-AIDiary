import React from 'react';
import { StyleSheet, TouchableOpacity, View } from 'react-native';
import { ThemedText } from '@/components/themed-text';
import { Colors, FontSizes, FontWeights } from '@/constants/theme';

const CATEGORIES = ['work', 'life', 'study', 'travel', 'health', 'other'];
const WEATHERS = ['sunny', 'cloudy', 'rainy', 'snowy', 'windy', 'foggy'];
const WEATHER_FILTER_ACTIVE_BG = '#3B82F630';
const WEATHER_FILTER_ACTIVE_TEXT = '#3B82F6';

interface FilterPopoverProps {
  filterCategory: string | null;
  filterWeather: string | null;
  hasFilters: boolean;
  accentColor: string;
  theme: 'light' | 'dark';
  i18n: Record<string, string>;
  filterPosition: { x: number; y: number; width: number; height: number };
  onSetCategory: (cat: string | null) => void;
  onSetWeather: (weather: string | null) => void;
  onClear: () => void;
  onClose: () => void;
}

export function FilterPopover({
  filterCategory,
  filterWeather,
  hasFilters,
  accentColor,
  theme,
  i18n,
  filterPosition,
  onSetCategory,
  onSetWeather,
  onClear,
  onClose,
}: FilterPopoverProps) {
  const c = Colors[theme];

  return (
    <>
      <TouchableOpacity style={styles.filterOverlay} activeOpacity={1} onPress={onClose} />
      <View
        style={[
          styles.filterPopover,
          {
            backgroundColor: c.cardBackground,
            top: filterPosition.y + filterPosition.height + 8,
            right: 20,
          },
        ]}
      >
        <ThemedText style={[styles.filterLabel, { color: c.text }]}>
          {i18n.filterByCategory}
        </ThemedText>
        <View style={styles.filterOptions}>
          <TouchableOpacity
            style={[
              styles.filterChip,
              filterCategory === null && { backgroundColor: accentColor + '30' },
            ]}
            onPress={() => onSetCategory(null)}
          >
            <ThemedText style={{ color: filterCategory === null ? accentColor : c.text }}>
              {i18n.all}
            </ThemedText>
          </TouchableOpacity>
          {CATEGORIES.map((cat) => (
            <TouchableOpacity
              key={cat}
              style={[
                styles.filterChip,
                filterCategory === cat && { backgroundColor: accentColor + '30' },
              ]}
              onPress={() => onSetCategory(cat)}
            >
              <ThemedText style={{ color: filterCategory === cat ? accentColor : c.text }}>
                {i18n[`cat${cat.charAt(0).toUpperCase() + cat.slice(1)}` as keyof typeof i18n] ||
                  cat}
              </ThemedText>
            </TouchableOpacity>
          ))}
        </View>

        <ThemedText style={[styles.filterLabel, { color: c.text }]}>
          {i18n.filterByWeather}
        </ThemedText>
        <View style={styles.filterOptions}>
          <TouchableOpacity
            style={[
              styles.filterChip,
              filterWeather === null && { backgroundColor: WEATHER_FILTER_ACTIVE_BG },
            ]}
            onPress={() => onSetWeather(null)}
          >
            <ThemedText
              style={{ color: filterWeather === null ? WEATHER_FILTER_ACTIVE_TEXT : c.text }}
            >
              {i18n.all}
            </ThemedText>
          </TouchableOpacity>
          {WEATHERS.map((w) => (
            <TouchableOpacity
              key={w}
              style={[
                styles.filterChip,
                filterWeather === w && { backgroundColor: WEATHER_FILTER_ACTIVE_BG },
              ]}
              onPress={() => onSetWeather(w)}
            >
              <ThemedText
                style={{ color: filterWeather === w ? WEATHER_FILTER_ACTIVE_TEXT : c.text }}
              >
                {i18n[`weather${w.charAt(0).toUpperCase() + w.slice(1)}` as keyof typeof i18n] || w}
              </ThemedText>
            </TouchableOpacity>
          ))}
        </View>

        {hasFilters && (
          <TouchableOpacity style={[styles.clearBtn, { borderColor: c.icon }]} onPress={onClear}>
            <ThemedText style={{ color: c.text, fontSize: FontSizes.sm }}>{i18n.clear}</ThemedText>
          </TouchableOpacity>
        )}
      </View>
    </>
  );
}

const styles = StyleSheet.create({
  filterLabel: {
    fontSize: FontSizes.md,
    fontWeight: FontWeights.medium,
    marginBottom: 10,
    marginTop: 16,
  },
  filterOptions: { flexDirection: 'row', flexWrap: 'wrap', gap: 8 },
  filterChip: {
    paddingHorizontal: 14,
    paddingVertical: 8,
    borderRadius: 20,
    backgroundColor: 'rgba(128,128,128,0.1)',
  },
  filterOverlay: { ...StyleSheet.absoluteFillObject, zIndex: 99 },
  filterPopover: {
    position: 'absolute',
    zIndex: 100,
    width: 280,
    padding: 16,
    borderRadius: 12,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.15,
    shadowRadius: 12,
    elevation: 8,
  },
  clearBtn: {
    marginTop: 16,
    paddingVertical: 8,
    borderTopWidth: 1,
    borderTopColor: '#ccc',
    alignItems: 'center',
  },
});
