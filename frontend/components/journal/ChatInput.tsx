import React from 'react';
import { View, TextInput, TouchableOpacity, KeyboardAvoidingView, Platform, StyleSheet } from 'react-native';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors, FontSizes } from '@/constants/theme';

interface ChatInputProps {
    inputText: string;
    loading: boolean;
    accentColor: string;
    resolvedTheme: 'light' | 'dark';
    i18n: Record<string, string>;
    onInputChange: (text: string) => void;
    onSend: () => void;
    onKeyPress?: (e: any) => void;
}

export function ChatInput({ inputText, loading, accentColor, resolvedTheme, i18n, onInputChange, onSend, onKeyPress }: ChatInputProps) {
    const c = Colors[resolvedTheme];
    const canSend = inputText.trim().length > 0 && !loading;
    
    return (
        <KeyboardAvoidingView 
            behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
            keyboardVerticalOffset={Platform.OS === 'web' ? 0 : 90}
        >
            <View style={[styles.inputArea, { backgroundColor: c.background, borderTopColor: resolvedTheme === 'dark' ? '#1A1C1E' : '#E8E8EA' }]}>
                <TextInput
                    style={[
                        styles.input, 
                        { 
                            backgroundColor: resolvedTheme === 'dark' ? '#2A2C30' : '#F0F0F2', 
                            color: c.text,
                            ...(Platform.OS === 'web' ? { overflow: 'hidden' } : {}),
                        }
                    ]}
                    placeholder={i18n.chatPlaceholder}
                    placeholderTextColor={c.icon}
                    value={inputText}
                    onChangeText={onInputChange}
                    multiline
                    maxLength={500}
                    blurOnSubmit={false}
                    scrollEnabled={false}
                    onKeyPress={onKeyPress}
                    onSubmitEditing={onSend}
                    returnKeyType="send"
                />
                <TouchableOpacity 
                    style={[styles.sendBtn, { backgroundColor: canSend ? accentColor : c.icon + '40' }]}
                    onPress={onSend}
                    disabled={!canSend}
                >
                    <IconSymbol name="paper-plane" size={20} color={canSend ? '#000' : c.icon} />
                </TouchableOpacity>
            </View>
        </KeyboardAvoidingView>
    );
}

const styles = StyleSheet.create({
    inputArea: {
        flexDirection: 'row',
        alignItems: 'flex-end',
        padding: 12,
        borderTopWidth: StyleSheet.hairlineWidth,
        gap: 10,
    },
    input: {
        flex: 1,
        maxHeight: 100,
        paddingHorizontal: 16,
        paddingVertical: 10,
        borderRadius: 20,
        fontSize: FontSizes.md,
    },
    sendBtn: {
        width: 44,
        height: 44,
        borderRadius: 22,
        alignItems: 'center',
        justifyContent: 'center',
    },
});
