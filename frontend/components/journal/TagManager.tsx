import { useState, useCallback } from 'react';
import { View, TextInput, TouchableOpacity, StyleSheet } from 'react-native';
import { ThemedText } from '@/components/themed-text';
import { Colors, FontSizes } from '@/constants/theme';

interface TagManagerProps {
    tags: string[];
    onTagsChange: (tags: string[]) => void;
    theme: 'light' | 'dark';
    accentColor: string;
    i18n: any;
}

export function TagManager({ tags, onTagsChange, theme, accentColor, i18n }: TagManagerProps) {
    const [showInput, setShowInput] = useState(false);
    const [newTag, setNewTag] = useState('');

    const handleAddTag = useCallback(() => {
        const trimmed = newTag.trim();
        if (trimmed && !tags.includes(trimmed)) {
            onTagsChange([...tags, trimmed]);
        }
        setNewTag('');
        setShowInput(false);
    }, [newTag, tags, onTagsChange]);

    const handleRemoveTag = useCallback((tagToRemove: string) => {
        onTagsChange(tags.filter(tag => tag !== tagToRemove));
    }, [tags, onTagsChange]);

    const c = Colors[theme];

    return (
        <View style={styles.container}>
            <View style={styles.header}>
                <ThemedText style={[styles.title, { color: c.text }]}>{i18n.tags}</ThemedText>
                <TouchableOpacity
                    style={[styles.addBtn, { backgroundColor: accentColor }]}
                    onPress={() => setShowInput(!showInput)}
                >
                    <ThemedText style={styles.addBtnText}>+</ThemedText>
                </TouchableOpacity>
            </View>

            <View style={styles.tagList}>
                {tags.map(tag => (
                    <View key={tag} style={[styles.tagChip, { backgroundColor: accentColor + '20', borderColor: accentColor + '40' }]}>
                        <ThemedText style={[styles.tagChipText, { color: accentColor }]}>#{tag}</ThemedText>
                        <TouchableOpacity onPress={() => handleRemoveTag(tag)}>
                            <ThemedText style={[styles.tagRemoveBtn, { color: accentColor }]}>✕</ThemedText>
                        </TouchableOpacity>
                    </View>
                ))}
            </View>

            {showInput && (
                <View style={styles.inputRow}>
                    <TextInput
                        style={[styles.input, { color: c.text, borderColor: accentColor + '40' }]}
                        placeholder={i18n.addTag}
                        placeholderTextColor={c.icon}
                        value={newTag}
                        onChangeText={setNewTag}
                        onSubmitEditing={handleAddTag}
                        autoFocus
                    />
                    <TouchableOpacity style={[styles.saveBtn, { backgroundColor: accentColor }]} onPress={handleAddTag}>
                        <ThemedText style={styles.saveBtnText}>{i18n.save}</ThemedText>
                    </TouchableOpacity>
                </View>
            )}
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        marginTop: 16,
    },
    header: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        marginBottom: 8,
    },
    title: {
        fontSize: FontSizes.md,
        fontWeight: '600' as const,
    },
    addBtn: {
        width: 28,
        height: 28,
        borderRadius: 14,
        alignItems: 'center',
        justifyContent: 'center',
    },
    addBtnText: {
        color: '#fff',
        fontSize: FontSizes.md,
        fontWeight: '600' as const,
        marginTop: -2,
    },
    tagList: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        gap: 8,
    },
    tagChip: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingHorizontal: 12,
        paddingVertical: 6,
        borderRadius: 16,
        borderWidth: 1,
        gap: 6,
    },
    tagChipText: {
        fontSize: FontSizes.sm,
        fontWeight: '500' as const,
    },
    tagRemoveBtn: {
        fontSize: FontSizes.md,
        fontWeight: '600' as const,
    },
    inputRow: {
        flexDirection: 'row',
        gap: 8,
        marginTop: 12,
    },
    input: {
        flex: 1,
        borderWidth: 1,
        borderRadius: 8,
        paddingHorizontal: 12,
        paddingVertical: 8,
        fontSize: FontSizes.md,
    },
    saveBtn: {
        paddingHorizontal: 16,
        paddingVertical: 8,
        borderRadius: 8,
        justifyContent: 'center',
    },
    saveBtnText: {
        color: '#fff',
        fontSize: FontSizes.md,
        fontWeight: '600' as const,
    },
});
