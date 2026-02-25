import React, { useState, useRef, useCallback } from 'react';
import { View, TextInput, TouchableOpacity, KeyboardAvoidingView, Platform, StyleSheet, Image, ScrollView, Alert, Text } from 'react-native';
import * as ImagePicker from 'expo-image-picker';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors, FontSizes } from '@/constants/theme';

interface Attachment {
    id: string;
    type: 'image';
    uri: string;
    name?: string;
}

interface ChatInputProps {
    inputText: string;
    loading: boolean;
    accentColor: string;
    resolvedTheme: 'light' | 'dark';
    i18n: Record<string, string>;
    onInputChange: (text: string) => void;
    onSend: () => void;
    onKeyPress?: (e: any) => void;
    onStopGenerating?: () => void;
}

export function ChatInput({ 
    inputText, 
    loading, 
    accentColor, 
    resolvedTheme, 
    i18n, 
    onInputChange, 
    onSend, 
    onKeyPress,
    onStopGenerating,
}: ChatInputProps) {
    const c = Colors[resolvedTheme];
    const [attachments, setAttachments] = useState<Attachment[]>([]);
    const canSend = inputText.trim().length > 0 || attachments.length > 0;
    const [inputHeight, setInputHeight] = useState(44);
    const inputRef = useRef<TextInput>(null);

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

        if (!result.canceled && result.assets[0]) {
            const asset = result.assets[0];
            setAttachments(prev => [...prev, {
                id: Date.now().toString(),
                type: 'image',
                uri: asset.uri,
                name: asset.fileName || 'image.jpg',
            }]);
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

        if (!result.canceled && result.assets[0]) {
            const asset = result.assets[0];
            setAttachments(prev => [...prev, {
                id: Date.now().toString(),
                type: 'image',
                uri: asset.uri,
                name: 'photo.jpg',
            }]);
        }
    };

    const handleRemoveAttachment = (id: string) => {
        setAttachments(prev => prev.filter(a => a.id !== id));
    };

    const handleSend = () => {
        if (canSend) {
            onSend();
            setAttachments([]);
        }
    };

    return (
        <KeyboardAvoidingView 
            behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
            keyboardVerticalOffset={Platform.OS === 'web' ? 0 : 90}
        >
            <View style={[styles.inputArea, { backgroundColor: c.background, borderTopColor: resolvedTheme === 'dark' ? '#1A1C1E' : '#E8E8EA' }]}>
                {attachments.length > 0 && (
                    <ScrollView
                        horizontal
                        showsHorizontalScrollIndicator={false}
                        style={styles.attachmentsContainer}
                        contentContainerStyle={styles.attachmentsContent}
                    >
                        {attachments.map((attachment) => (
                            <View key={attachment.id} style={styles.attachment}>
                                <Image
                                    source={{ uri: attachment.uri }}
                                    style={styles.attachmentImage}
                                />
                                <TouchableOpacity
                                    style={styles.removeAttachment}
                                    onPress={() => handleRemoveAttachment(attachment.id)}
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
                        testID="attach-image-button"
                    >
                        <IconSymbol name="photo" size={22} color={c.icon} />
                    </TouchableOpacity>

                    <TouchableOpacity
                        style={styles.attachButton}
                        onPress={handleTakePhoto}
                        disabled={loading}
                        testID="camera-button"
                    >
                        <IconSymbol name="camera" size={22} color={c.icon} />
                    </TouchableOpacity>

                    <View
                        style={[
                            styles.inputWrapper,
                            {
                                backgroundColor: resolvedTheme === 'dark' ? '#2A2C30' : '#F0F0F2',
                                minHeight: inputHeight,
                                maxHeight: 120,
                            }
                        ]}
                    >
                        <TextInput
                            ref={inputRef}
                            style={[
                                styles.input,
                                {
                                    color: c.text,
                                    height: inputHeight,
                                }
                            ]}
                            placeholder={i18n.chatPlaceholder}
                            placeholderTextColor={c.icon}
                            value={inputText}
                            onChangeText={onInputChange}
                            onContentSizeChange={handleContentSizeChange}
                            multiline
                            maxLength={500}
                            blurOnSubmit={false}
                            scrollEnabled={false}
                            onKeyPress={onKeyPress}
                            onSubmitEditing={handleSend}
                            returnKeyType="send"
                            editable={!loading}
                        />
                    </View>

                    {loading ? (
                        <TouchableOpacity
                            style={[styles.sendBtn, { backgroundColor: '#FF4444' }]}
                            onPress={onStopGenerating}
                            testID="stop-button"
                        >
                            <IconSymbol name="stop" size={20} color="#fff" />
                        </TouchableOpacity>
                    ) : (
                        <TouchableOpacity 
                            style={[styles.sendBtn, { backgroundColor: canSend ? accentColor : c.icon + '40' }]}
                            onPress={handleSend}
                            disabled={!canSend}
                            testID="send-button"
                        >
                            <IconSymbol name="paper-plane" size={20} color={canSend ? '#000' : c.icon} />
                        </TouchableOpacity>
                    )}
                </View>

                {inputText.length > 400 && (
                    <Text style={[styles.charCount, { color: c.icon }]}>
                        {inputText.length} / 500
                    </Text>
                )}
            </View>
        </KeyboardAvoidingView>
    );
}

const styles = StyleSheet.create({
    inputArea: {
        borderTopWidth: StyleSheet.hairlineWidth,
        paddingTop: 8,
        paddingBottom: 8,
    },
    attachmentsContainer: {
        maxHeight: 80,
        marginBottom: 8,
        paddingHorizontal: 12,
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
        paddingHorizontal: 12,
        gap: 8,
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
    },
    sendBtn: {
        width: 44,
        height: 44,
        borderRadius: 22,
        alignItems: 'center',
        justifyContent: 'center',
    },
    charCount: {
        fontSize: FontSizes.xs,
        textAlign: 'right',
        paddingHorizontal: 16,
        marginTop: 4,
    },
});
