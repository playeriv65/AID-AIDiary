import React from 'react';
import { View, TouchableOpacity, Modal, StyleSheet } from 'react-native';
import { ThemedText } from '@/components/themed-text';
import { Colors, FontSizes, FontWeights } from '@/constants/theme';

interface GenerateDiaryModalProps {
    visible: boolean;
    accentColor: string;
    resolvedTheme: 'light' | 'dark';
    i18n: Record<string, string>;
    onCancel: () => void;
    onConfirm: () => void;
}

export function GenerateDiaryModal({ visible, accentColor, resolvedTheme, i18n, onCancel, onConfirm }: GenerateDiaryModalProps) {
    const c = Colors[resolvedTheme];
    
    return (
        <Modal visible={visible} transparent animationType="fade">
            <View style={styles.modalOverlay}>
                <View style={[styles.modalContent, { backgroundColor: c.background }]}>
                    <ThemedText style={[styles.modalTitle, { color: c.text }]}>{i18n.generateDiary}</ThemedText>
                    <ThemedText style={[styles.modalText, { color: c.icon }]}>根据我们的对话生成今天的日记？</ThemedText>
                    <View style={styles.modalButtons}>
                        <TouchableOpacity 
                            style={[styles.modalBtn, { backgroundColor: resolvedTheme === 'dark' ? '#2A2C30' : '#F0F0F2' }]}
                            onPress={onCancel}
                        >
                            <ThemedText style={{ color: c.text }}>{i18n.cancel}</ThemedText>
                        </TouchableOpacity>
                        <TouchableOpacity 
                            style={[styles.modalBtn, { backgroundColor: accentColor }]}
                            onPress={onConfirm}
                        >
                            <ThemedText style={{ color: '#000', fontWeight: FontWeights.semibold }}>{i18n.confirm}</ThemedText>
                        </TouchableOpacity>
                    </View>
                </View>
            </View>
        </Modal>
    );
}

const styles = StyleSheet.create({
    modalOverlay: {
        flex: 1,
        backgroundColor: 'rgba(0,0,0,0.5)',
        justifyContent: 'center',
        alignItems: 'center',
    },
    modalContent: {
        width: '80%',
        maxWidth: 320,
        borderRadius: 16,
        padding: 24,
    },
    modalTitle: {
        fontSize: FontSizes.xl,
        fontWeight: FontWeights.semibold,
        marginBottom: 12,
    },
    modalText: {
        fontSize: FontSizes.md,
        marginBottom: 24,
    },
    modalButtons: {
        flexDirection: 'row',
        gap: 12,
        justifyContent: 'flex-end',
    },
    modalBtn: {
        paddingHorizontal: 20,
        paddingVertical: 10,
        borderRadius: 8,
    },
});
