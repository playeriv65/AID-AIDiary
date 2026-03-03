import { useState } from 'react';
import { StyleSheet, TextInput, TouchableOpacity, View } from 'react-native';
import { ThemedText } from '@/components/themed-text';
import { Picker } from '@/components/picker';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors, FontSizes } from '@/constants/theme';

interface EntryMetadataProps {
  category: string | null;
  weather: string | null;
  location: string;
  categoryOptions: { value: string; label: string; icon: string }[];
  weatherOptions: { value: string; label: string; icon: string }[];
  onCategoryChange: (category: string | null) => void;
  onWeatherChange: (weather: string | null) => void;
  onLocationChange: (location: string) => void;
  theme: 'light' | 'dark';
  accentColor: string;
  i18n: any;
}

export function EntryMetadata({
  category,
  weather,
  location,
  categoryOptions,
  weatherOptions,
  onCategoryChange,
  onWeatherChange,
  onLocationChange,
  theme,
  accentColor,
  i18n,
}: EntryMetadataProps) {
  const c = Colors[theme];
  const mutedColor = c.icon;
  const [showLocationInput, setShowLocationInput] = useState(false);

  const handleLocationBlur = () => {
    if (!location.trim()) {
      setShowLocationInput(false);
    }
  };

  return (
    <View style={styles.container}>
      {/* 水平排列的元数据 */}
      <View style={styles.row}>
        {/* 分类选择 */}
        <Picker
          options={categoryOptions}
          value={category}
          onChange={onCategoryChange}
          placeholder={i18n.setCategory}
          theme={theme}
          accentColor={accentColor}
        />

        {/* 分隔线 */}
        <View style={[styles.divider, { backgroundColor: mutedColor + '40' }]} />

        {/* 天气选择 */}
        <Picker
          options={weatherOptions}
          value={weather}
          onChange={onWeatherChange}
          placeholder={i18n.selectWeather}
          theme={theme}
          accentColor={accentColor}
        />

        {/* 分隔线 */}
        <View style={[styles.divider, { backgroundColor: mutedColor + '40' }]} />

        {/* 位置 */}
        {showLocationInput ? (
          <TextInput
            style={[styles.locationInput, { color: c.text, borderColor: accentColor + '60' }]}
            placeholder={i18n.setLocation}
            placeholderTextColor={mutedColor}
            value={location}
            onChangeText={onLocationChange}
            onBlur={handleLocationBlur}
            autoFocus
          />
        ) : (
          <TouchableOpacity
            style={styles.locationBtn}
            onPress={() => setShowLocationInput(true)}
            activeOpacity={0.7}
          >
            <IconSymbol name="map-pin" size={14} color={location ? accentColor : mutedColor} />
            <ThemedText
              style={[styles.locationText, { color: location ? accentColor : mutedColor }]}
            >
              {location || i18n.setLocation}
            </ThemedText>
          </TouchableOpacity>
        )}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    marginBottom: 0,
    paddingBottom: 20,
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  divider: {
    width: 4,
    height: 4,
    borderRadius: 2,
    opacity: 0.3,
  },
  locationBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    paddingVertical: 2,
  },
  locationText: {
    fontSize: FontSizes.sm,
  },
  locationInput: {
    flex: 1,
    maxWidth: 150,
    borderWidth: 0,
    borderBottomWidth: 1,
    paddingHorizontal: 0,
    paddingVertical: 4,
    fontSize: FontSizes.sm,
  },
});
