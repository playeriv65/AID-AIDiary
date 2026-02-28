import { StyleSheet, TouchableOpacity, View, Text, Modal, Pressable } from 'react-native';
import { useState } from 'react';
import { IconSymbol } from './ui/icon-symbol';
import { FontSizes, FontWeights } from '@/constants/theme';

interface Option {
    value: string;
    label: string;
    icon?: string;
}

interface PickerProps {
    options: Option[];
    value: string | null;
    onChange: (value: string | null) => void;
    placeholder: string;
    theme: 'light' | 'dark';
    accentColor: string;
}

export function Picker({ options, value, onChange, placeholder, theme, accentColor }: PickerProps) {
    const [open, setOpen] = useState(false);

    const selectedOption = options.find(o => o.value === value);
    const textColor = theme === 'dark' ? '#fff' : '#000';
    const mutedColor = theme === 'dark' ? '#8A8D91' : '#6B7280';
    const cardBg = theme === 'dark' ? '#1A1C1E' : '#FFFFFF';
    const borderColor = theme === 'dark' ? '#3A3C40' : '#E5E7EB';

    const handleSelect = (optionValue: string) => {
        if (value === optionValue) {
            onChange(null);
        } else {
            onChange(optionValue);
        }
        setOpen(false);
    };

    return (
        <View style={styles.container}>
            <TouchableOpacity
                style={styles.trigger}
                onPress={() => setOpen(true)}
                activeOpacity={0.7}
            >
                {selectedOption ? (
                    <View style={styles.selectedContent}>
                        {selectedOption.icon && (
                            <IconSymbol name={selectedOption.icon} size={14} color={accentColor} />
                        )}
                        <Text style={[styles.selectedText, { color: accentColor }]}>{selectedOption.label}</Text>
                    </View>
                ) : (
                    <Text style={[styles.placeholder, { color: mutedColor }]}>{placeholder}</Text>
                )}
            </TouchableOpacity>

            <Modal
                visible={open}
                transparent
                animationType="fade"
                onRequestClose={() => setOpen(false)}
            >
                <Pressable style={styles.overlay} onPress={() => setOpen(false)}>
                    <View style={[styles.modalContent, { backgroundColor: cardBg }]}>
                        <View style={[styles.modalHeader, { borderBottomColor: borderColor }]}>
                            <Text style={[styles.modalTitle, { color: textColor }]}>{placeholder}</Text>
                            <TouchableOpacity onPress={() => setOpen(false)}>
                                <IconSymbol name="x" size={20} color={mutedColor} />
                            </TouchableOpacity>
                        </View>
                        <View style={styles.optionsGrid}>
                            {options.map((option) => (
                                <TouchableOpacity
                                    key={option.value}
                                    style={[
                                        styles.optionItem,
                                        { 
                                            backgroundColor: value === option.value ? accentColor : borderColor,
                                            borderColor: value === option.value ? accentColor : borderColor
                                        }
                                    ]}
                                    onPress={() => handleSelect(option.value)}
                                    activeOpacity={0.7}
                                >
                                    {option.icon && (
                                        <IconSymbol 
                                            name={option.icon} 
                                            size={18} 
                                            color={value === option.value ? '#000' : textColor} 
                                        />
                                    )}
                                    <Text style={[
                                        styles.optionText,
                                        { color: value === option.value ? '#000' : textColor }
                                    ]}>
                                        {option.label}
                                    </Text>
                                </TouchableOpacity>
                            ))}
                        </View>
                        <TouchableOpacity 
                            style={[styles.clearBtn, { backgroundColor: borderColor }]}
                            onPress={() => { onChange(null); setOpen(false); }}
                        >
                            <Text style={[styles.clearBtnText, { color: value ? textColor : mutedColor }]}>
                                {value ? 'Clear' : 'None'}
                            </Text>
                        </TouchableOpacity>
                    </View>
                </Pressable>
            </Modal>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        position: 'relative',
    },
    trigger: {
        flexDirection: 'row',
        alignItems: 'center',
        gap: 4,
    },
    selectedContent: {
        flexDirection: 'row',
        alignItems: 'center',
        gap: 4,
    },
  selectedText: {
    fontSize: FontSizes.sm,
    fontWeight: FontWeights.medium,
  },
  placeholder: {
    fontSize: FontSizes.sm,
    fontWeight: FontWeights.normal,
    opacity: 0.7,
  },
    overlay: {
        flex: 1,
        backgroundColor: 'rgba(0,0,0,0.5)',
        justifyContent: 'center',
        alignItems: 'center',
    },
    modalContent: {
        width: 320,
        borderRadius: 16,
        padding: 16,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 8 },
        shadowOpacity: 0.25,
        shadowRadius: 16,
        elevation: 10,
    },
    modalHeader: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        paddingBottom: 12,
        marginBottom: 12,
        borderBottomWidth: 1,
    },
    modalTitle: {
        fontSize: FontSizes.lg,
        fontWeight: FontWeights.semibold,
    },
    optionsGrid: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        gap: 8,
    },
    optionItem: {
        flexDirection: 'row',
        alignItems: 'center',
        gap: 6,
        paddingHorizontal: 12,
        paddingVertical: 8,
        borderRadius: 20,
        borderWidth: 1,
    },
    optionText: {
        fontSize: FontSizes.sm,
        fontWeight: FontWeights.medium,
    },
    clearBtn: {
        marginTop: 16,
        paddingVertical: 10,
        borderRadius: 8,
        alignItems: 'center',
    },
    clearBtnText: {
        fontSize: FontSizes.sm,
        fontWeight: FontWeights.medium,
    },
});
