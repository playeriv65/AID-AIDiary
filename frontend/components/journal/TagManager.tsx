import { useCallback, useState } from 'react';
import { StyleSheet, TextInput, TouchableOpacity, View } from 'react-native';
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

  const handleRemoveTag = useCallback(
    (tagToRemove: string) => {
      onTagsChange(tags.filter((tag) => tag !== tagToRemove));
    },
    [tags, onTagsChange]
  );

  const c = Colors[theme];

  return (
    <View style={styles.container}>
      <View style={styles.tagList}>
        {tags.map((tag) => (
          <View
            key={tag}
            style={[
              styles.tagChip,
              { backgroundColor: accentColor + '20', borderColor: accentColor + '40' },
            ]}
          >
            <ThemedText style={[styles.tagChipText, { color: accentColor }]}>#{tag}</ThemedText>
            <TouchableOpacity onPress={() => handleRemoveTag(tag)}>
              <ThemedText style={[styles.tagRemoveBtn, { color: accentColor }]}>✕</ThemedText>
            </TouchableOpacity>
          </View>
        ))}
        <TouchableOpacity
          style={[styles.addBtn, { backgroundColor: accentColor }]}
          onPress={() => setShowInput(!showInput)}
        >
          <ThemedText style={styles.addBtnText}>+</ThemedText>
        </TouchableOpacity>
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
          <TouchableOpacity
            style={[styles.saveBtn, { backgroundColor: accentColor }]}
            onPress={handleAddTag}
          >
            <ThemedText style={styles.saveBtnText}>{i18n.save}</ThemedText>
          </TouchableOpacity>
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    marginTop: 8,
    marginBottom: 0,
    paddingBottom: 8,
  },
  tagList: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 10,
    alignItems: 'center',
  },
  addBtn: {
    width: 36,
    height: 36,
    borderRadius: 18,
    alignItems: 'center',
    justifyContent: 'center',
  },
  addBtnText: {
    color: '#fff',
    fontSize: FontSizes.lg,
    fontWeight: '500' as const,
    lineHeight: FontSizes.lg * 1.2,
  },
  tagChip: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 14,
    paddingVertical: 8,
    borderRadius: 18,
    borderWidth: 0,
    gap: 8,
  },
  tagChipText: {
    fontSize: FontSizes.sm,
    fontWeight: '500' as const,
    lineHeight: FontSizes.sm * 1.2,
  },
  tagRemoveBtn: {
    fontSize: FontSizes.sm,
    fontWeight: '500' as const,
    opacity: 0.8,
    lineHeight: FontSizes.sm * 1.2,
  },
  inputRow: {
    flexDirection: 'row',
    gap: 8,
    marginTop: 12,
  },
  input: {
    flex: 1,
    borderWidth: 0,
    borderBottomWidth: 1,
    paddingHorizontal: 0,
    paddingVertical: 8,
    fontSize: FontSizes.md,
    outline: 'none',
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
