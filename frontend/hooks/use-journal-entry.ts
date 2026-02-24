import { useCallback, useState } from 'react';
import * as ImagePicker from 'expo-image-picker';
import { apiClient, type JournalEntry } from '@/api/client';
import { useAppContext } from '@/context/AppContext';

// Default alert implementation using RN Alert
const defaultAlert = (title: string, message: string) => {
  // Will be replaced by real Alert at runtime if not injected
  console.warn(`[AlertMock] ${title}: ${message}`);
};

const CATEGORIES = [
    { value: 'work', label: 'catWork', icon: 'briefcase' },
    { value: 'life', label: 'catLife', icon: 'heart' },
    { value: 'study', label: 'catStudy', icon: 'book-open' },
    { value: 'travel', label: 'catTravel', icon: 'airplane' },
    { value: 'health', label: 'catHealth', icon: 'heartbeat' },
    { value: 'other', label: 'catOther', icon: 'folder' },
];

const WEATHERS = [
    { value: 'sunny', label: 'weatherSunny', icon: 'sun' },
    { value: 'cloudy', label: 'weatherCloudy', icon: 'cloud' },
    { value: 'rainy', label: 'weatherRainy', icon: 'cloud-rain' },
    { value: 'snowy', label: 'weatherSnowy', icon: 'snowflake' },
    { value: 'windy', label: 'weatherWindy', icon: 'wind' },
    { value: 'foggy', label: 'weatherFoggy', icon: 'fog' },
];

export interface UseJournalEntryProps {
    entryId?: number;
    initialTitle?: string;
    initialContent?: string;
    initialCategory?: string;
    initialWeather?: string;
    initialLocation?: string;
    initialImage?: string;
    initialTags?: string[];
    onSuccess?: () => void;
    alert?: (title: string, message: string) => void;
    apiClient?: typeof import('@/api/client').apiClient;
    fetchEntries?: () => Promise<void>;
}

export interface UseJournalEntryReturn {
    title: string;
    content: string;
    category: string | null;
    weather: string | null;
    location: string;
    tags: string[];
    image: string | null;
    saving: boolean;
    aiPolishing: boolean;
    uploading: boolean;
    wordCount: number;
    categoryOptions: { value: string; label: string; icon: string }[];
    weatherOptions: { value: string; label: string; icon: string }[];
    setTitle: (title: string) => void;
    setContent: (content: string) => void;
    setCategory: (category: string | null) => void;
    setWeather: (weather: string | null) => void;
    setLocation: (location: string) => void;
    setTags: (tags: string[]) => void;
    setImage: (image: string | null) => void;
    handleSave: () => Promise<void>;
    handleAIPolish: () => Promise<void>;
    handleImageUpload: () => Promise<void>;
    insertTemplate: (type: 'list' | 'task' | 'time') => void;
}

// Import real apiClient for default
import { apiClient as defaultApiClient } from '@/api/client';

export function useJournalEntry({
    entryId,
    initialTitle = '',
    initialContent = '',
    initialCategory,
    initialWeather,
    initialLocation = '',
    initialImage,
    initialTags = [],
    onSuccess,
    alert: alertFn,
    apiClient: customApiClient,
    fetchEntries: customFetchEntries,
}: UseJournalEntryProps = {}): UseJournalEntryReturn {
    const { authToken, fetchEntries: contextFetchEntries, i18n } = useAppContext();
    
    // Use injected dependencies or fall back to context / defaults
    const apiClientInstance = customApiClient || defaultApiClient;
    const fetchEntriesFn = customFetchEntries || contextFetchEntries;
    const alertFn_ = alertFn || defaultAlert;

    const [title, setTitle] = useState(initialTitle);
    const [content, setContent] = useState(initialContent);
    const [category, setCategory] = useState<string | null>(initialCategory || null);
    const [weather, setWeather] = useState<string | null>(initialWeather || null);
    const [location, setLocation] = useState(initialLocation);
    const [tags, setTags] = useState<string[]>(initialTags);
    const [image, setImage] = useState<string | null>(initialImage || null);
    const [saving, setSaving] = useState(false);
    const [aiPolishing, setAiPolishing] = useState(false);
    const [uploading, setUploading] = useState(false);

    const wordCount = content.trim().length;

    const categoryOptions = CATEGORIES.map(c => ({
        ...c,
        label: i18n[c.label as keyof typeof i18n] as string,
    }));

    const weatherOptions = WEATHERS.map(w => ({
        ...w,
        label: i18n[w.label as keyof typeof i18n] as string,
    }));

    const handleSave = useCallback(async () => {
        if (!content.trim()) {
            alertFn_(i18n.hint, i18n.enterCredentials);
            return;
        }

        if (!authToken) {
            alertFn_('Error', i18n.authRequired);
            return;
        }

        setSaving(true);
        try {
            const payload = {
                title: title.trim() || null,
                content: content.trim(),
                category,
                weather,
                location: location.trim() || null,
                tags: tags.length > 0 ? tags : null,
                image,
            };

            if (entryId) {
                await apiClientInstance.put<JournalEntry>(`/entries/${entryId}`, payload);
            } else {
                await apiClientInstance.post<JournalEntry>('/entries', payload);
            }

            await fetchEntriesFn();
            onSuccess?.();
        } catch (error) {
            console.error('Save failed:', error);
            alertFn_('Error', i18n.saveFailed || i18n.authFailed);
        } finally {
            setSaving(false);
        }
    }, [content, title, category, weather, location, tags, image, entryId, authToken, fetchEntriesFn, onSuccess, i18n, alertFn_, apiClientInstance]);

    const handleAIPolish = useCallback(async () => {
        if (!content.trim()) {
            alertFn_(i18n.hint, i18n.enterCredentials);
            return;
        }

        try {
            setAiPolishing(true);
            const response = await apiClientInstance.post<{ polished_text: string; tags: string[] }>('/ai/polish', { content });
            let newContent = response.polished_text;
            if (response.tags && response.tags.length > 0) {
                newContent += '\n\n🏷️ ' + response.tags.join(', ');
            }
            setContent(newContent);
        } catch (error) {
            console.error('AI Polish Failed:', error);
            alertFn_('Error', i18n.aiPolishFailed || 'AI polish failed');
        } finally {
            setAiPolishing(false);
        }
    }, [content, i18n, alertFn_, apiClientInstance]);

    const handleImageUpload = useCallback(async () => {
        const permissionResult = await ImagePicker.requestMediaLibraryPermissionsAsync();
        if (!permissionResult.granted) {
            alertFn_('Error', 'Permission required to access photos');
            return;
        }

        const result = await ImagePicker.launchImageLibraryAsync({
            mediaTypes: ['images'],
            allowsEditing: true,
            quality: 0.8,
        });

        if (result.canceled || !result.assets?.[0]) return;

        const asset = result.assets[0];
        setUploading(true);
        try {
            const response = await fetch(asset.uri);
            const blob = await response.blob();

            const formData = new FormData();
            formData.append('file', blob, {
                filename: asset.fileName || `photo_${Date.now()}.jpg`,
                type: asset.mimeType || 'image/jpeg',
            } as any);

            const uploadResponse = await apiClientInstance.uploadFile('/upload', formData);
            setImage(uploadResponse.filename);
        } catch (error) {
            console.error('Upload error:', error);
            alertFn_('Error', i18n.uploadFailed || 'Failed to upload image');
        } finally {
            setUploading(false);
        }
    }, [i18n, alertFn_, apiClientInstance]);

    const insertTemplate = useCallback((type: 'list' | 'task' | 'time') => {
        const now = new Date();
        const timeStr = now.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: false });
        let insert = '';
        switch (type) {
            case 'list':
                insert = '\n• \n• \n• ';
                break;
            case 'task':
                insert = '\n☐ \n☐ \n☐ ';
                break;
            case 'time':
                insert = ` [${timeStr}] `;
                break;
        }
        setContent(prev => prev + insert);
    }, []);

    return {
        title,
        content,
        category,
        weather,
        location,
        tags,
        image,
        saving,
        aiPolishing,
        uploading,
        wordCount,
        categoryOptions,
        weatherOptions,
        setTitle,
        setContent,
        setCategory,
        setWeather,
        setLocation,
        setTags,
        setImage,
        handleSave,
        handleAIPolish,
        handleImageUpload,
        insertTemplate,
    };
}
