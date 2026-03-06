import React from 'react';
import { ActivityIndicator, StyleSheet, TouchableOpacity, View } from 'react-native';
import { ThemedText } from '@/components/themed-text';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors, FontSizes, FontWeights } from '@/constants/theme';

interface ChatHeaderProps {
  hasMessages: boolean;
  accentColor: string;
  resolvedTheme: 'light' | 'dark';
  i18n: Record<string, string>;
  generating: boolean;
  onClear: () => void;
  onGenerateDiary: () => void;
  onToggleSidebar?: () => void;
}

export function ChatHeader({
  hasMessages,
  accentColor,
  resolvedTheme,
  i18n,
  generating,
  onClear,
  onGenerateDiary,
  onToggleSidebar,
}: ChatHeaderProps) {
  const c = Colors[resolvedTheme];

  return (
    <View
      style={[
        styles.header,
        { borderBottomColor: resolvedTheme === 'dark' ? '#1A1C1E' : '#E8E8EA' },
      ]}
    >
      <View style={styles.headerLeft}>
        {onToggleSidebar && (
          <TouchableOpacity onPress={onToggleSidebar} style={styles.headerBtn}>
            <IconSymbol name="sidebar" size={24} color={c.text} />
          </TouchableOpacity>
        )}
        <ThemedText style={[styles.headerTitle, { color: c.text }]}>{i18n.aiChat}</ThemedText>
      </View>
      <View style={styles.headerActions}>
        {hasMessages && (
          <TouchableOpacity onPress={onClear} style={styles.headerBtn}>
            <IconSymbol name="trash" size={20} color={c.icon} />
          </TouchableOpacity>
        )}
        <TouchableOpacity
          onPress={onGenerateDiary}
          style={[styles.generateBtn, { backgroundColor: accentColor }]}
          disabled={generating}
        >
          {generating ? (
            <ActivityIndicator size="small" color="#000" />
          ) : (
            <>
              <IconSymbol name="note" size={16} color="#000" />
              <ThemedText style={styles.generateBtnText}>{i18n.generateDiary}</ThemedText>
            </>
          )}
        </TouchableOpacity>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 20,
    paddingTop: 16,
    paddingBottom: 12,
    borderBottomWidth: StyleSheet.hairlineWidth,
  },
  headerLeft: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  headerTitle: {
    fontSize: FontSizes.xl,
    fontWeight: FontWeights.semibold,
    lineHeight: FontSizes.xl * 1.2,
  },
  headerActions: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  headerBtn: {
    padding: 8,
  },
  generateBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
    paddingHorizontal: 14,
    paddingVertical: 8,
    borderRadius: 20,
  },
  generateBtnText: {
    color: '#000',
    fontWeight: FontWeights.semibold,
    fontSize: FontSizes.sm,
  },
});
