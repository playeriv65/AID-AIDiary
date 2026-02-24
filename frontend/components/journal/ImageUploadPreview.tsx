import { TouchableOpacity, View, Image, ActivityIndicator, StyleSheet } from 'react-native';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors } from '@/constants/theme';

interface ImageUploadPreviewProps {
    image: string | null;
    uploading: boolean;
    onUpload: () => void;
    onRemove: () => void;
    theme: 'light' | 'dark';
    accentColor: string;
    apiStaticUrl: string;
}

export function ImageUploadPreview({
    image,
    uploading,
    onUpload,
    onRemove,
    theme,
    accentColor,
    apiStaticUrl,
}: ImageUploadPreviewProps) {
    const c = Colors[theme];
    const mutedColor = c.icon;

    if (image) {
        return (
            <View style={[styles.previewContainer, { backgroundColor: theme === 'dark' ? '#2A2C30' : '#F0F0F2' }]}>
                <Image
                    source={{ uri: `${apiStaticUrl}/${image}` }}
                    style={styles.previewImage}
                    resizeMode="cover"
                />
                <TouchableOpacity style={styles.removeBtn} onPress={onRemove}>
                    <IconSymbol name="x" size={16} color="#fff" />
                </TouchableOpacity>
            </View>
        );
    }

    return (
        <TouchableOpacity
            style={[styles.uploadBtn, { backgroundColor: theme === 'dark' ? '#2A2C30' : '#F0F0F2' }]}
            onPress={onUpload}
            disabled={uploading}
            activeOpacity={0.7}
        >
            {uploading ? (
                <ActivityIndicator size="small" color={accentColor} />
            ) : (
                <IconSymbol name="plus" size={24} color={mutedColor} />
            )}
        </TouchableOpacity>
    );
}

const styles = StyleSheet.create({
    previewContainer: {
        width: 200,
        height: 150,
        borderRadius: 10,
        marginTop: 40,
        overflow: 'hidden',
        position: 'relative',
    },
    previewImage: {
        width: '100%',
        height: '100%',
    },
    removeBtn: {
        position: 'absolute',
        top: 8,
        right: 8,
        width: 24,
        height: 24,
        borderRadius: 12,
        backgroundColor: 'rgba(0,0,0,0.6)',
        alignItems: 'center',
        justifyContent: 'center',
    },
    uploadBtn: {
        width: 120,
        height: 100,
        borderRadius: 10,
        alignItems: 'center',
        justifyContent: 'center',
        marginTop: 40,
    },
});
