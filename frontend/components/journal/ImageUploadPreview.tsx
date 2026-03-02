import { ActivityIndicator, Image, StyleSheet, TouchableOpacity, View } from 'react-native';
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
      <View style={styles.container}>
        <View
          style={[
            styles.previewContainer,
            { backgroundColor: theme === 'dark' ? '#2A2C30' : '#F0F0F2' },
          ]}
        >
          <Image
            source={{ uri: `${apiStaticUrl}/${image}` }}
            style={styles.previewImage}
            resizeMode="cover"
          />
          <TouchableOpacity style={styles.removeBtn} onPress={onRemove}>
            <IconSymbol name="x" size={14} color="#fff" />
          </TouchableOpacity>
        </View>
      </View>
    );
  }

  // 无图片时显示 subtle 的上传按钮
  return (
    <View style={styles.container}>
      <TouchableOpacity
        style={[styles.uploadBtn, { borderColor: mutedColor + '40' }]}
        onPress={onUpload}
        disabled={uploading}
        activeOpacity={0.7}
      >
        {uploading ? (
          <ActivityIndicator size="small" color={accentColor} />
        ) : (
          <>
            <IconSymbol name="image" size={20} color={mutedColor} />
            <View style={styles.uploadTextContainer}>
              <View style={[styles.plusIcon, { borderColor: mutedColor + '60' }]}>
                <IconSymbol name="plus" size={12} color={mutedColor} />
              </View>
            </View>
          </>
        )}
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    marginTop: 24,
    marginBottom: 0,
    paddingBottom: 8,
  },
  previewContainer: {
    width: '100%',
    height: 280,
    borderRadius: 16,
    overflow: 'hidden',
    position: 'relative',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.15,
    shadowRadius: 12,
    elevation: 5,
  },
  previewImage: {
    width: '100%',
    height: '100%',
  },
  removeBtn: {
    position: 'absolute',
    top: 12,
    right: 12,
    width: 28,
    height: 28,
    borderRadius: 14,
    backgroundColor: 'rgba(0,0,0,0.4)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  uploadBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
    paddingVertical: 14,
    paddingHorizontal: 20,
    borderRadius: 10,
    borderWidth: 1,
    borderStyle: 'dashed',
    alignSelf: 'flex-start',
    maxWidth: '100%',
  },
  uploadTextContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
  },
  plusIcon: {
    width: 20,
    height: 20,
    borderRadius: 10,
    borderWidth: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
