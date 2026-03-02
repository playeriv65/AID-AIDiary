import React, { useCallback, useRef, useState } from 'react';
import {
  Alert,
  Image,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';
import * as ImagePicker from 'expo-image-picker';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors, FontSizes } from '@/constants/theme';
import type { Attachment } from './types';

interface ChatInputProps {
  value: string;
  onChangeText: (text: string) => void;
  onSend: () => void;
  onStopGenerating?: () => void;
  loading?: boolean;
  theme: 'light' | 'dark';
  accentColor: string;
  placeholder?: string;
  onAttachImage?: (attachment: Attachment) => void;
  attachments?: Attachment[];
  onRemoveAttachment?: (id: string) => void;
  maxLength?: number;
}

export function ChatInput({
  value,
  onChangeText,
  onSend,
  onStopGenerating,
  loading = false,
  theme,
  accentColor,
  placeholder = '发送消息...',
  onAttachImage,
  attachments = [],
  onRemoveAttachment,
  maxLength = 5000,
}: ChatInputProps) {
  const inputRef = useRef<TextInput>(null);
  const [inputHeight, setInputHeight] = useState(44);
  const c = Colors[theme];

  const canSend = value.trim().length > 0 && !loading;

  const handleContentSizeChange = useCallback((e: any) => {
    const height = Math.min(Math.max(e.nativeEvent.contentSize.height, 44), 120);
    setInputHeight(height);
  }, []);

  const handlePickImage = async () => {
    const permissionResult = await ImagePicker.requestMediaLibraryPermissionsAsync();

    if (!permissionResult.granted) {
      Alert.alert('权限需要', '需要访问相册以上传图片');
      return;
    }

    const result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ImagePicker.MediaTypeOptions.Images,
      allowsEditing: true,
      quality: 0.8,
    });

    if (!result.canceled && result.assets[0] && onAttachImage) {
      const asset = result.assets[0];
      onAttachImage({
        id: Date.now().toString(),
        type: 'image',
        uri: asset.uri,
        name: asset.fileName || 'image.jpg',
        mimeType: asset.type || 'image/jpeg',
      });
    }
  };

  const handleTakePhoto = async () => {
    const permissionResult = await ImagePicker.requestCameraPermissionsAsync();

    if (!permissionResult.granted) {
      Alert.alert('权限需要', '需要访问相机以拍照');
      return;
    }

    const result = await ImagePicker.launchCameraAsync({
      allowsEditing: true,
      quality: 0.8,
    });

    if (!result.canceled && result.assets[0] && onAttachImage) {
      const asset = result.assets[0];
      onAttachImage({
        id: Date.now().toString(),
        type: 'image',
        uri: asset.uri,
        name: 'photo.jpg',
        mimeType: 'image/jpeg',
      });
    }
  };

  const handleSend = () => {
    if (canSend) {
      onSend();
      setInputHeight(44);
    }
  };

  const handleKeyPress = (e: any) => {
    if (e.nativeEvent.key === 'Enter' && !e.nativeEvent.shiftKey) {
      e.preventDefault();
      handleSend();
    }
  };

  return (
    <KeyboardAvoidingView
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
      keyboardVerticalOffset={Platform.OS === 'web' ? 0 : 90}
    >
      <View
        style={[
          styles.container,
          {
            backgroundColor: c.background,
            borderTopColor: c.border,
          },
        ]}
      >
        {attachments.length > 0 && (
          <ScrollView
            horizontal
            showsHorizontalScrollIndicator={false}
            style={styles.attachmentsContainer}
            contentContainerStyle={styles.attachmentsContent}
          >
            {attachments.map((attachment) => (
              <View key={attachment.id} style={styles.attachment}>
                <Image source={{ uri: attachment.uri }} style={styles.attachmentImage} />
                <TouchableOpacity
                  style={styles.removeAttachment}
                  onPress={() => onRemoveAttachment?.(attachment.id)}
                >
                  <IconSymbol name="xmark" size={12} color="#fff" />
                </TouchableOpacity>
              </View>
            ))}
          </ScrollView>
        )}

        <View style={styles.inputRow}>
          <TouchableOpacity
            style={styles.attachButton}
            onPress={handlePickImage}
            disabled={loading}
          >
            <IconSymbol name="photo" size={22} color={c.icon} />
          </TouchableOpacity>

          <TouchableOpacity
            style={styles.attachButton}
            onPress={handleTakePhoto}
            disabled={loading}
          >
            <IconSymbol name="camera" size={22} color={c.icon} />
          </TouchableOpacity>

          <View
            style={[
              styles.inputWrapper,
              {
                backgroundColor: theme === 'dark' ? '#2A2C30' : '#F0F0F2',
                minHeight: inputHeight,
                maxHeight: 120,
              },
            ]}
          >
            <TextInput
              ref={inputRef}
              style={[
                styles.input,
                {
                  color: c.text,
                  height: inputHeight,
                },
              ]}
              value={value}
              onChangeText={onChangeText}
              onContentSizeChange={handleContentSizeChange}
              placeholder={placeholder}
              placeholderTextColor={c.icon}
              multiline
              maxLength={maxLength}
              blurOnSubmit={false}
              scrollEnabled={false}
              onKeyPress={handleKeyPress}
              editable={!loading}
              name="chat-input"
              id="chat-input"
            />
          </View>

          {loading ? (
            <TouchableOpacity
              style={[styles.sendButton, { backgroundColor: '#FF4444' }]}
              onPress={onStopGenerating}
            >
              <IconSymbol name="stop" size={20} color="#fff" />
            </TouchableOpacity>
          ) : (
            <TouchableOpacity
              style={[
                styles.sendButton,
                { backgroundColor: canSend ? accentColor : c.icon + '40' },
              ]}
              onPress={handleSend}
              disabled={!canSend}
            >
              <IconSymbol name="paper-plane" size={20} color={canSend ? '#000' : c.icon} />
            </TouchableOpacity>
          )}
        </View>

        {value.length > maxLength - 100 && (
          <Text style={[styles.charCount, { color: c.icon }]}>
            {value.length} / {maxLength}
          </Text>
        )}
      </View>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: {
    borderTopWidth: StyleSheet.hairlineWidth,
    paddingTop: 8,
    paddingBottom: 8,
  },
  attachmentsContainer: {
    maxHeight: 80,
    marginBottom: 8,
    paddingHorizontal: 40,
  },
  attachmentsContent: {
    gap: 8,
    alignItems: 'center',
  },
  attachment: {
    position: 'relative',
    marginRight: 8,
  },
  attachmentImage: {
    width: 60,
    height: 60,
    borderRadius: 8,
  },
  removeAttachment: {
    position: 'absolute',
    top: -6,
    right: -6,
    width: 20,
    height: 20,
    borderRadius: 10,
    backgroundColor: '#FF4444',
    alignItems: 'center',
    justifyContent: 'center',
  },
  inputRow: {
    flexDirection: 'row',
    alignItems: 'flex-end',
    paddingHorizontal: 40,
    gap: 4,
  },
  attachButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    alignItems: 'center',
    justifyContent: 'center',
  },
  inputWrapper: {
    flex: 1,
    borderRadius: 20,
    paddingHorizontal: 16,
    paddingVertical: Platform.OS === 'ios' ? 10 : 6,
  },
  input: {
    fontSize: FontSizes.md,
    padding: 0,
    margin: 0,
    borderWidth: 0,
    outlineWidth: 0,
  },
  sendButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    alignItems: 'center',
    justifyContent: 'center',
  },
  charCount: {
    fontSize: FontSizes.xs,
    textAlign: 'right',
    paddingHorizontal: 40,
    marginTop: 4,
  },
});
