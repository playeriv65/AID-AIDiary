import { StyleSheet, TextInput, KeyboardAvoidingView, Platform, TouchableOpacity, Alert, Animated, View, ActivityIndicator } from 'react-native';
import { useState, useEffect, useRef } from 'react';
import { useRouter } from 'expo-router';
import axios from 'axios';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors } from '@/constants/theme';
import { useColorScheme } from '@/hooks/use-color-scheme';

const API_URL = 'http://127.0.0.1:8000/api';

export default function WriteEntryScreen() {
    const [title, setTitle] = useState('');
    const [content, setContent] = useState('');
    const [saving, setSaving] = useState(false);
    const [aiPolishing, setAiPolishing] = useState(false);
    const router = useRouter();
    const theme = useColorScheme() ?? 'dark';

    const fadeAnim = useRef(new Animated.Value(0)).current;

    useEffect(() => {
        Animated.timing(fadeAnim, {
            toValue: 1,
            duration: 500,
            useNativeDriver: true,
        }).start();
    }, [fadeAnim]);

    const handleSave = async () => {
        if (!content.trim()) {
            Alert.alert('Empty Entry', 'Please write something before saving.');
            return;
        }

        try {
            setSaving(true);
            await axios.post(`${API_URL}/entries`, {
                title: title.trim() || null,
                content: content.trim()
            });

            // Clear form and go back
            setTitle('');
            setContent('');
            router.back();
        } catch (error) {
            console.error('Failed to save entry:', error);
            Alert.alert('Error', 'Failed to save your journal entry.');
        } finally {
            setSaving(false);
        }
    };

    const handleAIPolish = async () => {
        if (!content.trim()) {
            Alert.alert('Empty Entry', 'Please write something before polishing.');
            return;
        }

        try {
            setAiPolishing(true);
            const response = await axios.post(`${API_URL}/ai/polish`, {
                content: content
            });

            let newContent = response.data.polished_text;
            if (response.data.tags && response.data.tags.length > 0) {
                newContent += '\n\n🏷️ ' + response.data.tags.join(', ');
            }
            setContent(newContent);
        } catch (error) {
            console.error('AI Polish Failed:', error);
            Alert.alert('AI Error', 'Failed to polish text. Check API key and backend.');
        } finally {
            setAiPolishing(false);
        }
    };

    return (
        <KeyboardAvoidingView
            style={styles.container}
            behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
        >
            <ThemedView style={styles.header}>
                <TouchableOpacity style={styles.cancelButton} onPress={() => router.back()}>
                    <ThemedText style={styles.cancelText}>Cancel</ThemedText>
                </TouchableOpacity>

                <ThemedText style={styles.headerTitle}>New Entry</ThemedText>

                <View style={styles.headerActions}>
                    <TouchableOpacity
                        style={[styles.aiButton, aiPolishing && styles.disabledButton]}
                        onPress={handleAIPolish}
                        disabled={aiPolishing || saving}
                    >
                        {aiPolishing ? (
                            <ActivityIndicator size="small" color={Colors[theme].tint} />
                        ) : (
                            <IconSymbol name="sparkles" size={20} color={Colors[theme].tint} />
                        )}
                    </TouchableOpacity>

                    <TouchableOpacity
                        style={[styles.saveButton, (saving || aiPolishing) && styles.disabledButton, { backgroundColor: Colors[theme].tint }]}
                        onPress={handleSave}
                        disabled={saving || aiPolishing}
                        activeOpacity={0.8}
                    >
                        <ThemedText style={styles.saveButtonText}>{saving ? 'Saving...' : 'Done'}</ThemedText>
                    </TouchableOpacity>
                </View>
            </ThemedView>

            <Animated.View style={[styles.formContainer, { opacity: fadeAnim }]}>
                <TextInput
                    style={[styles.titleInput, { color: Colors[theme].text }]}
                    placeholder="Title (Optional)"
                    placeholderTextColor="rgba(255,255,255,0.3)"
                    value={title}
                    onChangeText={setTitle}
                />

                <TextInput
                    style={[styles.contentInput, { color: Colors[theme].text }]}
                    placeholder="What's on your mind?"
                    placeholderTextColor="rgba(255,255,255,0.3)"
                    multiline
                    textAlignVertical="top"
                    value={content}
                    onChangeText={setContent}
                    autoFocus={true}
                />
            </Animated.View>
        </KeyboardAvoidingView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    header: {
        paddingTop: 60,
        paddingBottom: 20,
        paddingHorizontal: 20,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        backgroundColor: 'transparent',
    },
    headerTitle: {
        fontSize: 16,
        fontWeight: '600',
        letterSpacing: 1,
        opacity: 0.8,
    },
    cancelButton: {
        padding: 8,
    },
    cancelText: {
        opacity: 0.6,
        fontSize: 16,
    },
    headerActions: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    aiButton: {
        width: 36,
        height: 36,
        borderRadius: 18,
        backgroundColor: 'rgba(255,255,255,0.05)',
        alignItems: 'center',
        justifyContent: 'center',
        marginRight: 12,
    },
    saveButton: {
        paddingHorizontal: 16,
        paddingVertical: 8,
        borderRadius: 20,
    },
    disabledButton: {
        opacity: 0.5,
    },
    saveButtonText: {
        color: '#000',
        fontWeight: '600',
        fontSize: 15,
    },
    formContainer: {
        flex: 1,
        paddingHorizontal: 32,
        paddingTop: 20,
        maxWidth: 800,
        alignSelf: 'center',
        width: '100%',
    },
    titleInput: {
        fontSize: 28,
        fontWeight: '300',
        marginBottom: 20,
        paddingBottom: 16,
        borderBottomWidth: 1,
        borderBottomColor: 'rgba(255, 255, 255, 0.05)',
    },
    contentInput: {
        flex: 1,
        fontSize: 18,
        lineHeight: 32,
        fontWeight: '300',
    }
});
