import React, { useState } from 'react';
import { Platform, StyleSheet, TouchableOpacity, View } from 'react-native';
import * as Clipboard from 'expo-clipboard';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors } from '@/constants/theme';

interface MessageActionsProps {
  visible: boolean;
  role: 'user' | 'assistant';
  content: string;
  onEdit?: (content: string) => void;
  onRetry?: () => void;
  onRegenerate?: () => void;
  theme: 'light' | 'dark';
  accentColor?: string;
}

export function MessageActions({
  visible,
  role,
  content,
  onEdit,
  onRetry,
  onRegenerate,
  theme,
  accentColor,
}: MessageActionsProps) {
  const [copied, setCopied] = useState(false);
  const c = Colors[theme];

  if (!visible) {
    return null;
  }

  const handleCopy = async () => {
    await Clipboard.setStringAsync(content);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const handleEdit = () => {
    if (onEdit) {
      onEdit(content);
    }
  };

  const handleRetry = () => {
    if (onRetry) {
      onRetry();
    }
  };

  const handleRegenerate = () => {
    if (onRegenerate) {
      onRegenerate();
    }
  };

  return (
    <View style={styles.container}>
      <TouchableOpacity
        style={styles.button}
        onPress={handleCopy}
        hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}
      >
        <IconSymbol name={copied ? 'checkmark' : 'doc-on-doc'} size={16} color={c.icon} />
      </TouchableOpacity>

      {role === 'assistant' && (
        <TouchableOpacity
          style={styles.button}
          onPress={handleRetry}
          hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}
        >
          <IconSymbol name="arrow-counterclockwise" size={16} color={c.icon} />
        </TouchableOpacity>
      )}

      {role === 'user' && onEdit && (
        <TouchableOpacity
          style={styles.button}
          onPress={handleEdit}
          hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}
        >
          <IconSymbol name="pencil" size={16} color={c.icon} />
        </TouchableOpacity>
      )}

      {role === 'assistant' && onRegenerate && (
        <TouchableOpacity
          style={styles.button}
          onPress={handleRegenerate}
          hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}
        >
          <IconSymbol name="arrow-triclo" size={16} color={c.icon} />
        </TouchableOpacity>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    paddingHorizontal: 8,
    paddingVertical: 4,
    ...(Platform.OS === 'web'
      ? {
          position: 'absolute' as const,
          right: 8,
          top: -12,
          backgroundColor: 'rgba(255,255,255,0.95)',
          borderRadius: 16,
          boxShadow: '0 2px 8px rgba(0,0,0,0.1)',
        }
      : {
          position: 'absolute' as const,
          right: 8,
          top: -12,
          backgroundColor: 'rgba(255,255,255,0.95)',
          borderRadius: 16,
          shadowColor: '#000',
          shadowOffset: { width: 0, height: 2 },
          shadowOpacity: 0.1,
          shadowRadius: 8,
          elevation: 4,
        }),
  },
  button: {
    padding: 6,
    borderRadius: 12,
  },
});
