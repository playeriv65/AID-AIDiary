import { useCallback, useState } from 'react';
import * as ImagePicker from 'expo-image-picker';
import axios from 'axios';
import { Alert } from 'react-native';
import { CONFIG } from '@/constants/config';
import { useAppContext } from '@/context/AppContext';

export interface UseImageUploadReturn {
  image: string | null;
  uploading: boolean;
  uploadImage: (asset: ImagePicker.ImagePickerAsset) => Promise<string | null>;
  clearImage: () => void;
}

export function useImageUpload(authToken: string | null): UseImageUploadReturn {
  const { i18n } = useAppContext();
  const [image, setImage] = useState<string | null>(null);
  const [uploading, setUploading] = useState(false);

  const uploadImage = useCallback(
    async (asset: ImagePicker.ImagePickerAsset): Promise<string | null> => {
      if (!authToken) {
        Alert.alert('Error', i18n.authRequired);
        return null;
      }

      setUploading(true);
      try {
        const response = await fetch(asset.uri);
        const blob = await response.blob();

        const formData = new FormData();
        formData.append('file', blob, {
          filename: asset.fileName || `photo_${Date.now()}.jpg`,
          type: asset.mimeType || 'image/jpeg',
        } as any);

        const uploadResponse = await axios.post(`${CONFIG.API_URL}/upload`, formData, {
          headers: {
            Authorization: `Bearer ${authToken}`,
          },
        });

        const filename = uploadResponse.data.filename;
        setImage(filename);
        return filename;
      } catch (error: any) {
        console.error('Upload error:', error);
        const message = error.response?.data?.detail || i18n.uploadFailed;
        Alert.alert('Error', message);
        return null;
      } finally {
        setUploading(false);
      }
    },
    [authToken, i18n]
  );

  const clearImage = useCallback(() => {
    setImage(null);
  }, []);

  return {
    image,
    uploading,
    uploadImage,
    clearImage,
  };
}
