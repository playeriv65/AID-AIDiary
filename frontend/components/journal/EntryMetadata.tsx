import { useState } from 'react';
import { View, TextInput, TouchableOpacity, StyleSheet } from 'react-native';
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
            <View style={styles.row}>
                <Picker
                    options={categoryOptions}
                    value={category}
                    onChange={onCategoryChange}
                    placeholder={i18n.setCategory}
                    theme={theme}
                    accentColor={accentColor}
                />
                <Picker
                    options={weatherOptions}
                    value={weather}
                    onChange={onWeatherChange}
                    placeholder={i18n.selectWeather}
                    theme={theme}
                    accentColor={accentColor}
                />
            </View>

            <View style={styles.row}>
                {showLocationInput ? (
                    <TextInput
                        style={[styles.locationInput, { color: c.text, borderColor: mutedColor + '40' }]}
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
                        <IconSymbol name="map-pin" size={18} color={location ? accentColor : mutedColor} />
                        <ThemedText style={[styles.locationText, { color: location ? accentColor : mutedColor }]}>
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
        marginTop: 12,
        gap: 8,
    },
    row: {
        flexDirection: 'row',
        gap: 12,
    },
    locationBtn: {
        flexDirection: 'row',
        alignItems: 'center',
        gap: 8,
        paddingVertical: 8,
    },
    locationText: {
        fontSize: FontSizes.md,
    },
    locationInput: {
        flex: 1,
        borderWidth: 1,
        borderRadius: 8,
        paddingHorizontal: 12,
        paddingVertical: 8,
        fontSize: FontSizes.md,
    },
});
